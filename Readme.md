# README

Project by: Jason Puthusseril
Date: 3-30-2020

## About

To get acquainted with functional programming and with the world of interpreters and compilers, I used Haskell to build this interpreter for the Pascal programming language. The interpreter uses Alex for lexical analysis and Happy as a parser generator.




## How to run the code

* To run the tests, navigate to the Project directory and do the following for tests t1.pas through t12.pas:
```bash
cabal run Pascal tests/t1.pas
```

* To run the unit tests, navigate to the src directory and do the following for the these spec files: EvalBExpSpec.hs, EvalRExpSpec.hs, AuxilarySpec.hs:
```bash
runhaskell Spec/EvalBExpSpec.hs
```



## Features

The following features have been implemented, including:

* while-do and for-do loops 
* user-defined functions and procedures
* static scoping
    * see input12.pas and input13.pas (and any test involving functions/procedures)



## Assumptions

- True and False have to be capitalized
- Booleans and Reals have default values
- need to cd into src to run haskell unit tests
- functions must be caught by a variable. That means that you cannot just call a function without assigning it to a variable.
    - INVALID: a := b * functionCall
    - VALID: ID := functionCall
- writeln only takes in alphanumeric characters — no special characters (!, ?, :, etc.)

