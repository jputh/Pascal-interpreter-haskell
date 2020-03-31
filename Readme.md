# README

Project by: Jason Puthusseril

Date: 3-30-2020

## How to run the code

To run the tests, navigate to the Project directory and do:
```bash
cabal run Pascal tests/t1.pas
```
for tests t1.pas through t12.pas


To run the unit tests, navigate to the src directory and do:

```bash
runhaskell Spec/EvalBExpSpec.hs
```
for the following spec files: EvalBExpSpec.hs, EvalRExpSpec.hs, AuxilarySpec.hs



## Features

The following features have been implemented, including:

1. while-do and for-do loops 

2. user-defined functions and procedures

3. static scoping
    * see input12.pas and input13.pas (and any test involving functions/procedures)

## Bonuses

I also attempted the second bonus from the Project 2, formal parameters passing with proper scoping


## Assumptions

- True and False have to be capitalized
- Booleans and Reals have default values
- need to cd into src to run haskell unit tests
- functions must be caught by a variable. That means that you cannot just call a function without assigning it to a variable.
    - INVALID: a := b * functionCall
    - VALID: ID := functionCall
- writeln only takes in alphanumeric characters — no special characters (!, ?, :, etc.)

