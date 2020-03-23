module Pascal.EvalVal where

import Pascal.Data
import Pascal.EvalRExp
import Pascal.EvalBExp

evalVal :: SymTab -> String -> Val -> String
-- Real expression
evalVal st str (GExp (FloatExp r)) =
    let 
        ((FloatExp (Real r')), st') = evalRExp r st
    in 
        str ++ (show r')

-- evalRExp (Op1 "-" r) st = 
--     let 
--         ((FloatExp (Real r')), st') = evalRExp r st
--     in 
--         ((FloatExp (Real (r' * (-1)))), st')

-- Bool expression
evalVal  st str (GExp (BoolExp b)) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b st
    in
        str ++ (show b')

-- String
evalVal st str (Val_S s) = str ++ (removeQuote s)



--helper function that removes single quotes on strings
removeQuote :: String -> String
removeQuote s = tail (init s)

--helper functions for conversion


-- toGenExp :: Val -> GenExp
-- toGenExp 



