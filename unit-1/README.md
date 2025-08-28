
# Linux Commands Cheat Sheet

This README contains a summary of **basic Linux commands** to help you get started with the terminal.  

---

## 🖥️ Basic Commands
| Command | Description |
|---------|-------------|
| `pwd` | Print current working directory |
| `ls` | List files in current directory |
| `ls -l` | List files with details (permissions, owner, size, date) |
| `ls -a` | Show hidden files too |
| `cd <dir>` | Change directory |
| `cd ..` | Go one directory back |
| `cd ~` | Go to home directory |
| `clear` | Clear terminal screen |
| `whoami` | Show current logged-in user |
| `date` | Show system date and time |
| `cal` | Show calendar |

---

## 🔑 Sudo Commands
- **`sudo`** = "Super User DO" → run commands with administrator privileges.  

| Command | Description |
|---------|-------------|
| `sudo <command>` | Run command as root (admin) |
| `sudo su` | Switch to root user |
| `sudo apt update` | Update package lists (Debian/Ubuntu) |
| `sudo apt upgrade` | Upgrade installed packages |
| `sudo shutdown now` | Shut down system immediately |
| `sudo reboot` | Restart system |

---

## 👥 User & Group Management
| Command | Description |
|---------|-------------|
| `who` | Show logged-in users |
| `id` | Show user ID (UID) and group ID (GID) |
| `groups` | Show groups current user belongs to |
| `sudo adduser <username>` | Add new user |
| `sudo passwd <username>` | Set/change user password |
| `sudo userdel <username>` | Delete a user |
| `sudo groupadd <groupname>` | Create a new group |
| `sudo groupdel <groupname>` | Delete a group |
| `sudo usermod -aG <group> <user>` | Add user to group |

---

## 📂 File & Directory Manipulation
| Command | Description |
|---------|-------------|
| `touch file.txt` | Create an empty file |
| `cat file.txt` | View file content |
| `nano file.txt` | Edit file in Nano editor |
| `cp file1 file2` | Copy file1 to file2 |
| `cp -r dir1 dir2` | Copy directory recursively |
| `mv file1 file2` | Move/rename file |
| `rm file.txt` | Delete file |
| `rm -r dir` | Delete directory recursively |
| `mkdir newdir` | Create a new directory |
| `rmdir olddir` | Remove empty directory |

---

## 🔒 File Permissions
| Symbol | Meaning | Numeric Value |
|--------|----------|---------------|
| `r` | Read | 4 |
| `w` | Write | 2 |
| `x` | Execute | 1 |

- Format: `rwxr-xr--`
  - Owner → rwx (read, write, execute)
  - Group → r-x (read, execute)
  - Others → r-- (read only)

| Command | Description |
|---------|-------------|
| `ls -l` | Show permissions |
| `chmod 755 file.sh` | Change permission (owner full, group & others read/execute) |
| `chown user:group file.txt` | Change ownership of file |

---

## 📦 Package Management (Debian/Ubuntu)
| Command | Description |
|---------|-------------|
| `sudo apt install <package>` | Install a package |
| `sudo apt remove <package>` | Remove a package |
| `sudo apt search <package>` | Search for a package |
| `dpkg -l` | List installed packages |

---

## 🚀 Quick Shortcuts
- `Ctrl + C` → Stop running process  
- `Ctrl + Z` → Suspend process  
- `Ctrl + L` → Clear terminal (like `clear`)  
- `!!` → Run last command again  
- `history` → Show command history  

---

### 📘 Next Steps
- Practice commands inside a **Linux terminal**.  
- Try different options with `man <command>` (manual page).  
- Combine commands using `|` (pipe) and `>` (redirect).  

---
