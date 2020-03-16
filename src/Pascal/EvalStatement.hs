module Pascal.EvalStatement where
    --evaluator for statement data type
    
import Pascal.Data

evalState :: Statement -> String
evalState (Writeln s) = concat (map removeQuote s)


--helper function that removes single quotes on strings
removeQuote :: String -> String
removeQuote s = tail (init s)