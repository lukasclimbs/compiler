# Compiler (eventually)
=======================
### My name is Lukas Alden Resch! 

This repository is for my compiler, which I am building as part of my CSC312 class at Grinnell College.

If you have ocaml installed on your machine, the only necessary steps should be to call 'make' in the command-line from the same directory. You can then run by calling './compiler.native example.file'. 

## Changelog
### Assignment 1
-features an echo-like program called repeat.

-There is also a test suite for the program called tests.sh (see above for instructions on both).

-There are currently no known bugs.

### Assignment 2
-I now have a basic compiler! This compiler can do arithmetic and features booleans, an if/else expression, and a <= operator.

-The oasis and makefile have been updated to compile compiler.ml instead of repeat.ml

-I have included example .arith files to show off basic syntax. Follow the instructions above to test out the files. I have put example1.arith in the same path that you call the program for so that should be good to go. Otherwise, for the files in the Examples folder, you'll have to move them ore specify their path.

-Its current syntax operates as such: 
 
e ::= n | (+ e1 e2) | (- e1 e2) | (* e1 e2) | (/ e1 e2)
        | true | false | (<= e1 e2) | (if e1 e2 e3)
        
where n is an int. Note that you can put the appropriate subexpressions in any of the e's but the compiler will not allow for type mismatches, so you cannot put a boolean where an int should go or vice versa. So the arithmetic operators will only work on numbers and have the semantics of 'e1 OPERATOR e2'. The '<=' operator will compare two numbers and return 'true' if e1 is less than or equal to e2, else 'false'. Lastly the 'if' expression follows the following semantics: if e1(bool) then e2 else e3. Be careful when choosing e2 and e3 for 'if', as they can have different types.

Lastly, here are the expected results of compiling/running the example files:
-Example1.arith: 10
-Example2.arith: 9
-Example3.arith: true
-Example4.arith: false
-Example5.arith: 3
-Example6.arith: 4
-Example7.arith: 3
-Example8.arith: 4
