#!/bin/bash

clear

echo "Test 1:"
./repeat.native Hello World! > tmp.txt
diff tmp.txt test1.out

echo "Test 2:"
./repeat.native l3t5 try s0m3 numb3r5 4nd 4 l0ng m355483 > tmp.txt
diff tmp.txt test2.out

echo "Test 3:"
./repeat.native -length I am testing out some flags what could all these numbers be huh ha ha > tmp.txt
diff tmp.txt test3.out

echo "Test 4:"
./repeat.native > tmp.txt
diff tmp.txt test4.out

echo "Test 5:"
./repeat.native -help > tmp.txt
diff tmp.txt test5.out

echo "if all are blank, the program has passed the test suite!"
