module Pascal.Interpret 
(
    interpret
)
where

import Pascal.Data

import Pascal.EvalStatement
import Pascal.Auxilary
import qualified Data.Map.Strict as M

-- TODO: define auxiliary functions to aid interpretation
-- Feel free to put them here or in different modules
-- Hint: write separate evaluators for numeric and
-- boolean expressions and for statements


-- make sure you write test unit cases for all functions


mySymbTab :: SymTab
mySymbTab = M.empty


myFuncTab :: FuncTab
myFuncTab = M.empty

scopeStack :: [SymTab]
scopeStack = [mySymbTab]




interpret :: Program -> String
-- TODO: write the interpreter
-- interpret states = concat (map evalStatementOut' states)
--     where evalStatementOut' = evalStatementOut st ""

interpret ((vars, funcs), stmts) = 
    let 
        
        ft = foldl addFunc myFuncTab funcs -- create function table
        
        ((tempStr, st:tail), tempFt) = foldl evalVarDec (("", (mySymbTab:[])), ft) vars -- create symbol table
        
        ((str', st'), ft') = foldl evalStatementOut (("", (st:[])), ft) stmts
    in
        str'


interpret _ = "Not implemented"
