#!/bin/bash

echo "Enter elements of first array (with one palindrome):"
read -a arr1
echo "Enter elements of second array (with one prime):"
read -a arr2

# --- Function to check palindrome ---
is_palindrome() {
  local num=$1
  local rev=$(echo $num | rev)
  [ "$num" -eq "$rev" ]
}

# --- Function to check prime ---
is_prime() {
  local n=$1
  if [ $n -lt 2 ]; then
    return 1
  fi
  for ((i=2; i*i<=n; i++)); do
    if [ $((n%i)) -eq 0 ]; then
      return 1
    fi
  done
  return 0
}

# --- Find last palindrome number ---
palindrome=""
position=-1
for ((i=0; i<${#arr1[@]}; i++)); do
  if is_palindrome ${arr1[i]}; then
    palindrome=${arr1[i]}
    position=$i
  fi
done

# --- Store prime numbers from 2nd array ---
primes=()
for num in "${arr2[@]}"; do
  if is_prime $num; then
    primes+=($num)
  fi
done

# --- Add digits of palindrome ---
sum_digits=0
temp=$palindrome
while [ $temp -gt 0 ]; do
  digit=$((temp % 10))
  sum_digits=$((sum_digits + digit))
  temp=$((temp / 10))
done

# --- Print info ---
echo "Palindrome number: $palindrome"
echo "Position in first array: $position"
echo "Sum of digits of palindrome: $sum_digits"
echo "Prime numbers found: ${primes[@]}"

# --- Multiply sum of digits with each prime ---
echo "Results:"
for p in "${primes[@]}"; do
  result=$((sum_digits * p))
  echo "$sum_digits × $p = $result"
done

