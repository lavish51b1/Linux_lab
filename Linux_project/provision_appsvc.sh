#!/usr/bin/env bash
# provision_appsvc.sh
# Usage:
#   sudo ./provision_appsvc.sh --project myproj --keys /path/to/keys.pub [--home /home/custom] [--cidr 203.0.113.0/24] [--nologin] [--locked] [--force]
#
# Creates user appsvc_<project> with restricted shell allowing SFTP + exactly /usr/local/bin/run_app.
# Installs sudo rule for that command, sets ACLs, imports keys with options.
#
set -euo pipefail

# ---------- Defaults ----------
PROJECT=""
KEYS_FILE=""
CIDR_LIST=""
HOME_DIR_BASE="/home"
FORCE=0
NOLOGIN=0
LOCKED=0
# ---------- helpers ----------
usage() {
  cat <<EOF
Usage: $0 --project myproj --keys /path/to/pkeys.pub [--cidr 203.0.113.0/24] [--home /home] [--nologin] [--locked] [--force]
EOF
  exit 1
}

log() { echo "[*] $*"; }
err() { echo "[!] $*" >&2; }
require_root() { [[ "$(id -u)" -eq 0 ]] || { err "Run as root"; exit 2; } }

# parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT="$2"; shift 2;;
    --keys) KEYS_FILE="$2"; shift 2;;
    --cidr) CIDR_LIST="$2"; shift 2;;
    --home) HOME_DIR_BASE="$2"; shift 2;;
    --force) FORCE=1; shift;;
    --nologin) NOLOGIN=1; shift;;
    --locked) LOCKED=1; shift;;
    -h|--help) usage;;
    *) err "Unknown arg $1"; usage;;
  esac
done

[[ -n "$PROJECT" ]] || { err "Need --project"; usage;}
[[ -n "$KEYS_FILE" ]] || { err "Need --keys"; usage;}
[[ -f "$KEYS_FILE" ]] || { err "Key file not found: $KEYS_FILE"; exit 3; }

require_root

USER="appsvc_${PROJECT}"
USER_HOME="${HOME_DIR_BASE}/${USER}"
GROUP="appsvc_${PROJECT}"
RESTRICTED_SHELL="/usr/local/bin/restricted_shell"
RUN_APP="/usr/local/bin/run_app"
SUDOERS_FILE="/etc/sudoers.d/${USER}"
SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP_DIR="/root/provision_backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# ---------- idempotency checks ----------
if id "$USER" &>/dev/null; then
  log "User $USER already exists."
  if [[ $FORCE -ne 1 ]]; then
    log "Checking if user matches desired state..."
    # basic checks: home dir and shell
    EXIST_HOME=$(getent passwd "$USER" | cut -d: -f6)
    EXIST_SHELL=$(getent passwd "$USER" | cut -d: -f7)
    if [[ "$EXIST_HOME" == "$USER_HOME" && "$EXIST_SHELL" == "$RESTRICTED_SHELL" ]]; then
      log "User appears configured. Exiting (idempotent). Use --force to reapply."
      exit 0
    else
      log "User exists but differs; continuing because --force set or to correct configuration."
      if [[ $FORCE -ne 1 ]]; then
        err "User exists but mismatch; re-run with --force to fix.";
        exit 4
      fi
    fi
  else
    log "--force in effect: will reconfigure."
  fi
fi

# ---------- create group ----------
if ! getent group "$GROUP" >/dev/null; then
  groupadd --system "$GROUP"
  log "Created group $GROUP"
else
  log "Group $GROUP exists"
fi

# ---------- create user (or modify) ----------
if ! id "$USER" &>/dev/null; then
  cmd=(useradd -m -d "$USER_HOME" -g "$GROUP" -s "$RESTRICTED_SHELL" -c "App service user for $PROJECT" "$USER")
  if [[ $NOLOGIN -eq 1 ]]; then
    cmd+=(--shell /sbin/nologin)
  fi
  # create with locked password if requested
  "${cmd[@]}" 
  log "Created user $USER with home $USER_HOME and shell $RESTRICTED_SHELL"
else
  log "User exists; ensuring home and shell are set"
  usermod -d "$USER_HOME" -g "$GROUP" -s "$RESTRICTED_SHELL" "$USER" || true
fi

# optionally lock password
if [[ $LOCKED -eq 1 ]]; then
  passwd -l "$USER" || true
  log "Locked password for $USER (only key-based login)"
fi

# ---------- create restricted_shell wrapper ----------
if [[ ! -f "$RESTRICTED_SHELL" || $FORCE -eq 1 ]]; then
  cat > "$RESTRICTED_SHELL" <<'SH'
#!/usr/bin/env bash
# restricted_shell: only allow internal-sftp or exact /usr/local/bin/run_app
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Where sftp-server may live:
SFTP_INTERNAL="/usr/lib/openssh/sftp-server"
SFTP_INTERNAL2="/usr/libexec/openssh/sftp-server"
SFTP_INTERNAL3="/usr/libexec/sftp-server"
ALLOWED_CMD="/usr/local/bin/run_app"

# If SSH_ORIGINAL_COMMAND is empty -> interactive attempt -> deny
if [[ -z "${SSH_ORIGINAL_COMMAND:-}" ]]; then
  echo "Interactive shell denied."
  exit 1
fi

# Allow sftp subsystem variants:
case "$SSH_ORIGINAL_COMMAND" in
  'internal-sftp'|"/usr/lib/openssh/sftp-server"|"sftp-server"|"$SFTP_INTERNAL"|"$SFTP_INTERNAL2"|"$SFTP_INTERNAL3")
    # exec the system sftp-server or OpenSSH internal-sftp
    # prefer internal-sftp if supported via SSH
    exec /usr/lib/openssh/sftp-server 2>/dev/null || exec /usr/libexec/openssh/sftp-server 2>/dev/null || exec /usr/lib/openssh/sftp-server "$@"
    ;;
  "$ALLOWED_CMD"* )
    # allow exact command (and any args if you want)
    exec $SSH_ORIGINAL_COMMAND
    ;;
  *)
    echo "This account may only use SFTP or run $ALLOWED_CMD"
    exit 1
    ;;
esac
SH
  chmod 755 "$RESTRICTED_SHELL"
  log "Installed restricted shell at $RESTRICTED_SHELL"
else
  log "Restricted shell exists"
fi

# ---------- create placeholder run_app wrapper (executable) ----------
if [[ ! -f "$RUN_APP" || $FORCE -eq 1 ]]; then
  cat > "$RUN_APP" <<'RUN'
#!/usr/bin/env bash
# Placeholder run_app wrapper. Replace with your real app startup logic.
echo "run_app invoked by user: $(whoami), args: $*"
# actual app launch would go here
exit 0
RUN
  chmod 755 "$RUN_APP"
  log "Created placeholder $RUN_APP"
else
  log "$RUN_APP exists"
fi

# ---------- install SSH keys with options ----------
AUTH_DIR="${USER_HOME}/.ssh"
AUTH_FILE="${AUTH_DIR}/authorized_keys"
mkdir -p "$AUTH_DIR"
chown "$USER":"$GROUP" "$AUTH_DIR"
chmod 700 "$AUTH_DIR"

# prepare key options prefix:
KEY_OPTS="no-port-forwarding,no-agent-forwarding,no-X11-forwarding"
if [[ -n "$CIDR_LIST" ]]; then
  KEY_OPTS="from=\"$CIDR_LIST\",${KEY_OPTS}"
fi

# Install keys: for each non-empty line in KEYS_FILE, prepend options and append to authorized_keys if missing
touch "$AUTH_FILE"
chmod 600 "$AUTH_FILE"
chown "$USER":"$GROUP" "$AUTH_FILE"

# iterate keys
while IFS= read -r line || [[ -n "$line" ]]; do
  key="$(echo "$line" | tr -d '\r\n' | sed -e 's/^[[:space:]]*//')"
  [[ -z "$key" ]] && continue
  # if key already present (ignoring options) skip
  if grep -F -- "$key" "$AUTH_FILE" >/dev/null 2>&1; then
    log "Key already present, skipping"
  else
    echo "${KEY_OPTS} ${key}" >> "$AUTH_FILE"
    log "Installed key with options for $USER"
  fi
done < "$KEYS_FILE"

chown "$USER":"$GROUP" "$AUTH_FILE"
chmod 600 "$AUTH_FILE"

# ---------- ACLs: give read+execute to /srv/apps/<project> ----------
SRV_DIR="/srv/apps/${PROJECT}"
mkdir -p "$SRV_DIR"
chown root:root "$SRV_DIR"
# best effort: use setfacl if available
if command -v setfacl >/dev/null 2>&1; then
  setfacl -R -m u:"$USER":rX "$SRV_DIR"
  setfacl -d -m u:"$USER":rX "$SRV_DIR"
  log "Applied POSIX ACLs for $USER on $SRV_DIR"
else
  log "setfacl not present. Falling back to group-based permission."
  chgrp "$GROUP" "$SRV_DIR"
  chmod 750 "$SRV_DIR"
  log "Set group $GROUP and 750 on $SRV_DIR"
fi

# ensure user cannot list other home directories: typical homes are /home/*
# make sure /home perms are conservative (no global read)
if [[ -d "/home" ]]; then
  chmod 711 /home || true
fi

# ---------- sudoers rule (only allow run_app as root, no password) ----------
SUDO_LINE="${USER} ALL=(root) NOPASSWD: ${RUN_APP}"
if [[ -f "$SUDOERS_FILE" ]]; then
  log "Sudoers file exists; backing up."
  cp -a "$SUDOERS_FILE" "$BACKUP_DIR/"
fi
echo "$SUDO_LINE" > "$SUDOERS_FILE"
chmod 440 "$SUDOERS_FILE"
# validate
if visudo -cf "$SUDOERS_FILE"; then
  log "Sudoers file syntax OK"
else
  err "Sudoers syntax failed for $SUDOERS_FILE; restoring and aborting"
  rm -f "$SUDOERS_FILE"
  exit 5
fi

# ---------- sshd_config: (we don't strictly need to edit it if wrapper handles SSH_ORIGINAL_COMMAND) ----------
# However, it's common to ensure PermitEmptyPasswords no, and optionally Match blocks. We'll only make minimal safe changes:
cp -a "$SSHD_CONFIG" "$BACKUP_DIR/sshd_config.bak"
log "Backed up sshd_config to $BACKUP_DIR/sshd_config.bak"

# No change by default. Optionally, user can add a Match block; we'll skip auto-editing unless necessary.
# But ensure sshd syntax checks before reload (we will run check + reload)
if sshd -t; then
  log "sshd config syntax OK"
else
  err "sshd config syntax error already present; abort"
  exit 6
fi

# reload sshd safely
if systemctl is-enabled sshd >/dev/null 2>&1 || systemctl is-enabled ssh >/dev/null 2>&1; then
  if sshd -t; then
    systemctl reload sshd 2>/dev/null || systemctl reload ssh || service ssh reload || true
    log "Reloaded sshd (if possible)"
  else
    err "sshd -t failed; not reloading"
  fi
fi

# ---------- final ownerships and perms ----------
chown -R "$USER":"$GROUP" "$USER_HOME"
chmod 700 "$USER_HOME"
chmod 700 "$AUTH_DIR"
chmod 600 "$AUTH_FILE"

# ---------- done ----------
log "Provisioning done for $USER. Backup dir: $BACKUP_DIR"
cat <<EOF
Next steps / testing:
 - Try SFTP: sftp ${USER}@host (should connect)
 - Try run_app over SSH: ssh ${USER}@host ${RUN_APP}
 - Try interactive: ssh -t ${USER}@host /bin/bash  -> should be denied
 - To rollback, inspect $BACKUP_DIR for backups of modified files and sudoers.
EOF

