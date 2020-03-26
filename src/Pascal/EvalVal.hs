module Pascal.EvalVal where

import Pascal.Data
import Pascal.EvalRExp
import Pascal.EvalBExp

evalVal :: (String, SymTab) -> Val -> (String, SymTab)
-- Real expression
evalVal (str, st) (GExp (FloatExp r)) =
    let 
        ((FloatExp (Real r')), st') = evalRExp r st
    in 
        (str ++ (show r'), st')
        

-- evalRExp (Op1 "-" r) st = 
--     let 
--         ((FloatExp (Real r')), st') = evalRExp r st
--     in 
--         ((FloatExp (Real (r' * (-1)))), st')

-- Bool expression
evalVal  (str, st) (GExp (BoolExp b)) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b st
    in
        (str ++ (show b'), st)

-- String
evalVal (str, st) (Val_S s) = (str ++ (removeQuote s), st)




--helper function that removes single quotes on strings
removeQuote :: String -> String
removeQuote s = tail (init s)

--helper functions for conversion


-- toGenExp :: Val -> GenExp
-- toGenExp 



