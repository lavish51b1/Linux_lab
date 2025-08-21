# Shell tutorial - FILE


 ## File Permissions & Ownership

---

### 1. Understanding file permissions in linux
In Linux every file/folder has 3 types of users:

 **user** ==> the file owner  
 **Group** ==> people in the same group  
 **Others** ==> everyone else  


### Permission types

* r (read) (4)==> see the content  
* w (write) (2) ==> edit or delete  
* x (execute) (1) ==> run the file  

### permission layout:

Example from ls -l
![images](./first.png)

*** Breakdown ***

"-" -> regular file(d = directory, 1= symlink,etc.)
"rwx" -> owner can read, write, execute.
"r-x" -> group can read, execute.
"r--" -> others can read only.



### 2. chmod - change File Permissions


#### syntax

 chmod [options] mode file
modes can be set in numeric or symbolic form.

#### (A) Numeric(octal) Method 
each permiossion is represented as a number:

* read = 4
* Write = 2
* Execute = 1

add them up:

* 7 = rwx
* 6 = rw-
* 5 = r-x
* 4 = r--
* 0 = ---

##### example:
  1. chmod 755 lab5_2.md

 Meaning: specific permissions are allowed.

 * owner:7 ==> rwx
 * group:5 ==> r-x
 * others:5 ==> r-x

 ##### snapshot
 ![images](./scnd.png)

  2. chmod 000 lab5_2.md

 Meaning: no permission is allowed

 * owner:o ==> ---
 * group:0 ==> ---
 * others:0 ==> ---

 ##### snapshot
 ![images](./thrd.png)

  3. chmod 777 lab5_2.md

  Meaning: all permissions are granted

 * owner:7 ==> rwx
 * group:7 ==> rwx
 * others:7 ==> rwx

 ##### snapshot
 ![images](./frth.png)


 #### (B) Symbolic Method
 use u(user/owner), g(group), o(others), a(all).

 Operators
 * "+" = add permission
 * "-" = remove permission
 * "=" = assign exact permission


##### Examples:
1. chmod u+x lab5_2.md

##### snapshot;
![images](./fvt.png)

2. chmod a+r lab5_2.md

##### snapshot;
![images](./sxt.png)

3. chmod o=r lab5_2.md

##### snapshot;
![images](./svnt.png)

4. chmod g-w lab5_2.md

##### snapshot;
![images](./egth.png)


#### (C) Recursive Changes

-R ==> Applies changes to all files/subdirectories.

##### example;
chmod -R 755 Linux_lab

##### snapshot;
![images](./recursive.png)



### 3. chown - Change File Ownership

#### syntax
chown [options] new_owner

#### examples;
# Change only the owner
sudo chown lavish notes.txt

# Change both owner and group
sudo chown lavish:dev project.sh

# Change only the group
sudo chown :students report.txt

# Recursive ownership change (folder + all inside)
sudo chown -R lavish:dev Linux_lab


### 4. Putting all it together

#### example:

##### snapshots;

(a) ![images](./nnt.png)
(a) ![images](./tnt.png)
(a) ![images](./elvnt.png)



