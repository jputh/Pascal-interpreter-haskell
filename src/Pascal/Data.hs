-- This file contains the data-structures for the AST
-- The role of the parser is to build the AST (Abstract Syntax Tree) 

module Pascal.Data
    (
        RExp(..),
        BExp(..),
        Statement(..),
        Conditional(..),
        GenExp(..),
        Val(..),
        VarDec(..),
        FunctionBody(..),
        Program,
        SymTab,
        FuncTab,
        Function
    ) where

import qualified Data.Map.Strict as M



-- Generic data type
data GenExp = FloatExp RExp | BoolExp BExp 
    deriving (Show, Eq)


-- Data-structure for  numeric expressions
data RExp = 
    -- unary operator (-): Op name expression
    Op1 String RExp
    -- binary operator (*,/,+,-): Op name leftExpression rightExpression
    | Op2 String RExp RExp
    -- equations
    | OpEq String RExp
    -- real value: e.g. Real 1.0
    | Real Float
    -- function call
    | RFuncCall String [Val]
    -- variable: e.g. Var "x"
    | Var_R String
    
    deriving (Show, Eq)

-- Data-structure for boolean expressions
data BExp = 
    -- binary operator on boolean expressions (and, or)
    OpB String BExp BExp
    -- negation, the only unary operator
    | Not BExp
    -- comparison operator: Comp name expression expression
    | Comp String RExp RExp
    -- true and false constants
    | Boolean Bool
    -- variable
    | Var_B String
    deriving (Show, Eq)

-- Data-structure for statements
data Statement = 
    -- TODO: add other statements
    -- Variable assignment
    Assign String Val
    -- function call
    | FuncCall String String [Val]
    -- procedure call
    | ProcCall String [Val]
    -- writeln statement
    | Writeln [Val]
    -- If statement
    | If_State [Conditional] [Statement]
    -- Loop
    | For_Loop String RExp RExp [Statement]
    | While_Loop BExp [Statement]
    -- Block
    | Block [Statement]
    deriving (Show, Eq)


-- handles all things passed into writeln function
data Val =
    Val_ID String
    | GExp GenExp
    | Val_S String
    deriving (Show, Eq)


data VarDec = 
    -- Initializing a Real or Boolean expression
    Init String GenExp
    -- Declaring a Real Expression to default value
    | DecF String
    -- Declaring a Boolean Expression to default value
    | DecB String
    deriving (Show, Eq)


data FunctionBody = 
    RType_Real [String] [VarDec] [Statement]
    | RType_Bool [String] [VarDec] [Statement]
    | RType_None [String] [VarDec] [Statement]
    deriving (Show, Eq)


--unlike Val, handles all things that can be passed as parameters into functions/procedures
-- data Parameter =




-- Data-structure for whole program
-- TODO: add declarations and other useful stuff
-- Hint: make a tuple containing the other ingredients
type Program = (([VarDec], [Function]), [Statement])

--Data Structures for managing scopes:
type SymTab = M.Map String GenExp

type FuncTab = M.Map String FunctionBody


type Conditional = (BExp, [Statement])

type Function = (String, FunctionBody)







