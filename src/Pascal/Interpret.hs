module Pascal.Interpret 
(
    interpret
)
where

import Pascal.Data
import Pascal.EvalStatement

-- TODO: define auxiliary functions to aid interpretation
-- Feel free to put them here or in different modules
-- Hint: write separate evaluators for numeric and
-- boolean expressions and for statements
-- stringTogether :: [String] -> String -> String
-- stringTogether (x:list) s = s ++ x ++ (stringTogether(list s'))

-- stringTogether [] s = ""

-- make sure you write test unit cases for all functions

interpret :: Program -> String
-- TODO: write the interpreter
interpret states = concat (map evalState states)

interpret _ = "Not implemented"