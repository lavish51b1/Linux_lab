# 🐚 Shell Scripting Basics

This guide explains **arrays, loops, user input, and basic printing** in Shell (`bash`) scripting.

---

## 📦 Arrays in Shell

### 1. Declaring an Array
```sh
arr=(10 20 30 40 50)


2. Accessing Array Elements
sh
Copy code
echo ${arr[0]}   # First element → 10
echo ${arr[3]}   # Fourth element → 40
3. Array Length
sh
Copy code
echo ${#arr[@]}   # Number of elements in array
4. Looping Through Array
sh
Copy code
for val in "${arr[@]}"; do
  echo $val
done
🔁 Loops
1. C-Style For Loop
sh
Copy code
for ((i=0; i<5; i++)); do
  echo "Number: $i"
done
2. Print a Range
sh
Copy code
for i in {1..10}; do
  echo $i
done
3. While Loop
sh
Copy code
count=1
while [ $count -le 5 ]; do
  echo "Count: $count"
  ((count++))
done
🔂 Nested Loops with Arrays
sh
Copy code
arr1=(1 2 3)
arr2=(a b c)

for i in "${arr1[@]}"; do
  for j in "${arr2[@]}"; do
    echo "$i - $j"
  done
done
👤 User Input
1. Read User Input
sh
Copy code
echo "Enter your name:"
read name
echo "Hello, $name!"
2. Stop on User Input
sh
Copy code
while true; do
  read -p "Type 'stop' to exit: " input
  if [ "$input" == "stop" ]; then
    break
  fi
done
🖨️ Printing Examples
1. Print "Hello World"
sh
Copy code
echo "Hello, World!"
2. Print Numbers 1 to 5
sh
Copy code
for i in {1..5}; do
  echo $i
done
3. Print Name & Age (from user input)
sh
Copy code
echo "Enter your name:"
read name

echo "Enter your age:"
read age

echo "Your name is $name and your age is $age"
🚀 Next Steps
Practice each script by saving in a .sh file.

Make it executable:

sh
Copy code
chmod +x script.sh
./script.sh