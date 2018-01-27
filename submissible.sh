#!/bin/bash
IFS= 

echo `make clean`

echo `make`

for num in {1..9} 
do
printf "\n\t\t\tTest: %d\n" $num
echo "--------------------------------------------------------"
echo `cat tests/test"$num" | ./scan`
done
