#!/bin/bash

clear

echo "Testing the parsing pipeline:"

echo "Test 1:"
./compiler.native -parse ./tests/example.src > tmp.txt
diff tmp.txt ./tests/example.parse.out

echo "Test 2:"
./compiler.native -parse ./tests/example1.src > tmp.txt
diff tmp.txt ./tests/example1.parse.out

echo "Test 3:"
./compiler.native -parse ./tests/example2.src > tmp.txt
diff tmp.txt ./tests/example2.parse.out

echo "Test 4:"
./compiler.native -parse ./tests/example3.src > tmp.txt
diff tmp.txt ./tests/example3.parse.out

echo "Test 5:"
./compiler.native -parse ./tests/example4.src > tmp.txt
diff tmp.txt ./tests/example4.parse.out

echo "Test 6:"
./compiler.native -parse ./tests/example5.src > tmp.txt
diff tmp.txt ./tests/example5.parse.out

echo "Test 7:"
./compiler.native -parse ./tests/example6.src > tmp.txt
diff tmp.txt ./tests/example6.parse.out

echo "Test 8:"
./compiler.native -parse ./tests/example7.src > tmp.txt
diff tmp.txt ./tests/example7.parse.out

echo "Test 9:"
./compiler.native -parse ./tests/example8.src > tmp.txt
diff tmp.txt ./tests/example8.parse.out

echo "Test 10:"
./compiler.native -parse ./tests/example9.src > tmp.txt
diff tmp.txt ./tests/example9.parse.out

echo "Test 11:"
./compiler.native -parse ./tests/example10.src

echo "Test 12:"
./compiler.native -parse ./tests/example11.src > tmp.txt

echo "if all are blank, the program has passed the lexing test suite! Test 11 will fail, as the file is empty. Test 12 will return a fatal error, this is intentional, as this test has extra characters in it, and this is the expected behavior."
