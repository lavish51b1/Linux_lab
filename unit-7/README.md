# 🐚 Shell Script Collection

This file contains a set of **four shell scripting programs** that demonstrate common file and data operations in Linux using bash:  

1. **check_file.sh** – This script checks if a specified file exists.  
   - If the file exists, it displays the file’s contents in the terminal.  
   - If the file doesn’t exist, it prompts the user to create it, allowing easy file management directly from the terminal.

2. **count_lines_words.sh** – This script analyzes a text file and provides a quick summary of its contents.  
   - It counts the total **lines**, **words**, and **characters** in the file.  
   - The script first ensures the file exists and is readable, making it a safe utility for basic text analysis.

3. **factorial_function.sh** – This script calculates the factorial of one or more non-negative integers provided as input arguments.  
   - It uses a loop-based approach to compute the factorial of each number.  
   - Invalid inputs (non-numeric or negative values) are skipped, with clear messages shown to the user.

4. **print_numbers.sh** – This script demonstrates the use of **arrays and loops** in bash.  
   - It stores a sequence of numbers in an array and prints each number one by one.  
   - While simple, it illustrates how arrays can be used to handle multiple values efficiently in shell scripting.

Overall, this collection showcases **file checking, file content analysis, mathematical computation, and array handling** in bash.  
It provides examples of practical scripts that can be run in the terminal, with both **code input** and **output** displayed for clarity.

---

## 📋 Scripts Summary

| Script Name                  | Description                                                            |
|------------------|------------------------------------------------------------------------------------|
| 📝 check_file.sh            | Checks if a file exists; displays contents or offers to create it. |
| 🧮 count_lines_words.sh     | Counts lines, words, and characters in a file. |
| 🔢 factorial_function.sh    | Calculates factorials of non-negative integers. |
| 🔢 print_numbers.sh         | Prints numbers from 1 to 7 using an array loop. |

---

## 🖥️ Script: 📝 check_file.sh

### 📜 Core Idea
This script checks if a file exists.  
- If it exists, it displays the file’s contents.  
- If it doesn’t exist, it prompts the user to create the file.  
- Usage: `./check_file.sh filename.txt`

### 💻 Code (Terminal Input)

![images](./images/Screenshot%20from%202025-09-20%2000-28-12.png)

### 🖼️ Output (Terminal Output)

![images](./images/Screenshot%20from%202025-09-20%2000-32-21.png)

---

## 🖥️ Script: 🧮 count_lines_words.sh

### 📜 Core Idea

Counts the number of **lines**, **words**, and **characters** in a text file.

* Checks if the file exists first.
* Usage: `./count_lines_words.sh filename.txt`

### 💻 Code (Terminal Input)

![images](./images/Screenshot%20from%202025-09-20%2000-28-52.png)

### 🖼️ Output (Terminal Output)

![images](./images/Screenshot%20from%202025-09-20%2000-31-35.png)

---

## 🖥️ Script: 🔢 factorial_function.sh

### 📜 Core Idea

Calculates the **factorial** of one or more non-negative integers.

* Skips invalid inputs and shows usage instructions if arguments are missing.
* Usage: `./factorial_fuction.sh 5 7 10`

### 💻 Code (Terminal Input)

![images](./images/Screenshot%20from%202025-09-20%2000-29-17.png)

### 🖼️ Output (Terminal Output)

![images](./images/Screenshot%20from%202025-09-20%2000-31-15.png)

---

## 🖥️ Script: 🔢 print_numbers.sh

### 📜 Core Idea

Prints numbers from **1 to 7** using an array loop.

* Demonstrates looping over an array in bash.
* Usage: `./print_numbers.sh`

### 💻 Code (Terminal Input)

![images](./images/Screenshot%20from%202025-09-20%2000-29-38.png)

### 🖼️ Output (Terminal Output)

![image](./images/Screenshot%20from%202025-09-20%2000-30-48.png)