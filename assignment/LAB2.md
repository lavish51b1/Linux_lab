# 🔧understanding how existing scripts in repo work

# 🔧script 1

  ```
 #!/bin/bash      - shebang
 echo "hello world!"     - printing hello world
 name="Lavish Goyal"   - taking Lavish Goyal variable name
 age=18    -  taking 18 in variable age 

 echo "My name is $name ansd I am $age year old."  - printing name and age
```
#### OUTPUT :
![Image](imagess/aa.png)
![Image](imagess/bb.png)


# 🔧 script 2

```
#!/bin/bash        -shebang
a="Lavish Goyal"           -taking Lavish Goyal in the variable a
b=40                 -taking 40 in the variable b

if [ $a="Lavish Goyal" ] && [ $b -gt 18 ]; then      -checking conditions and using an opreator and(&&)
    echo " you are adult "                     - printing you are adult
fi

if [ $a="Lavish Goyal" ] && [ $b -lt 18 ]; then       -checking conditions and using an opreator and(&&)
    echo "you are minor"                         - printing you are minor
fi

```
![Image](imagess/a.png)
![Image](imagess/b.png)


### 🔧 Q1 what is the purpose of #!/bin/bash at the top of the script

ANS-- the shebang line at the top of a script specifies the interpreter that should be used to the run the script.

### 🔧 Q2 how do you make a script executable?
ANS-- 1. add the shebang at the top
          2. give permission using the chmod command
          3. run the code....