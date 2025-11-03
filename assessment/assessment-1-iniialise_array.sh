#!/bin/bash

arr1=(11 45 121 34)
arr2=(4 6 3 5 9)

echo "Array 1: ${arr1[@]}"
echo "Array 2: ${arr2[@]}"

is_palindrome() {
  local num=$1
  local rev=$(echo $num | rev)
  [ "$num" -eq "$rev" ]
}

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

palindrome=""
position=-1
for ((i=0; i<${#arr1[@]}; i++)); do
  if is_palindrome ${arr1[i]}; then
    palindrome=${arr1[i]}
    position=$i
  fi
done

primes=()
for num in "${arr2[@]}"; do
  if is_prime $num; then
    primes+=($num)
  fi
done

sum_digits=0
temp=$palindrome
while [ $temp -gt 0 ]; do
  digit=$((temp % 10))
  sum_digits=$((sum_digits + digit))
  temp=$((temp / 10))
done

echo
echo "Palindrome number: $palindrome"
echo "Position in first array: $position"
echo "Sum of digits of palindrome: $sum_digits"
echo "Prime numbers found: ${primes[@]}"
echo
echo "Results (sum_of_digits × prime):"
for p in "${primes[@]}"; do
  result=$((sum_digits * p))
  echo "$sum_digits × $p = $result"
done

