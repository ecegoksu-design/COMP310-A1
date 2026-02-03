#!/bin/bash

echo "===Starting mysh==="

cd ../src || exit 1
make clean
make mysh

cd ../test-cases || exit 1

tests=("prompt" "echo" "badcommand" "set" "ls" "mkdir" "oneline" "oneline2" "source" "run")
passed=0
total=${#tests[@]}

for test in "${tests[@]}"; do
    echo -n "Testing $test... "

    ../src/mysh < "$test.txt" > temp_output.txt

    if diff -iw temp_output.txt "${test}_result.txt" > /dev/null; then
        echo "PASS"
        ((passed++))
    else
        echo "FAIL"
        echo "Differences:"
        diff -iw temp_output.txt "${test}_result.txt"
    fi

    echo "**********************"
    rm -f temp_output.txt
done

echo "Passed: $passed/$total"
echo "Failed: $((total - passed))/$total"

echo "===Making clean==="
cd ../src || exit 1
make clean
