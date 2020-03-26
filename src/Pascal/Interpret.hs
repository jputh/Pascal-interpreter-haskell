module Pascal.Interpret 
(
    interpret
)
where

import Pascal.Data
import Pascal.EvalStatement
import qualified Data.Map.Strict as M

-- TODO: define auxiliary functions to aid interpretation
-- Feel free to put them here or in different modules
-- Hint: write separate evaluators for numeric and
-- boolean expressions and for statements
-- stringTogether :: [String] -> String -> String
-- stringTogether (x:list) s = s ++ x ++ (stringTogether(list s'))

-- stringTogether [] s = ""

-- make sure you write test unit cases for all functions


mySymbTab :: SymTab
mySymbTab = M.empty

scopeStack :: [SymTab]
scopeStack = [mySymbTab]




interpret :: Program -> String
-- TODO: write the interpreter
-- interpret states = concat (map evalStatementOut' states)
--     where evalStatementOut' = evalStatementOut st ""

interpret states = 
    let 
        (str', st') = foldl evalStatementOut ("", mySymbTab) states
    in
        str'

interpret _ = "Not implemented"