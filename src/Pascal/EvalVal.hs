module Pascal.EvalVal where
    -- deals with evaluating parameters of a writeln statement

import Pascal.Data
import Pascal.Scope
import Pascal.EvalRExp
import Pascal.EvalBExp
import qualified Data.Map.Strict as M


evalVal :: (String, SymTab) -> Val -> (String, SymTab)
-- Real expression
-- evalVal (str, st) (GExp (FloatExp (Var_R x))) = 
--     case lookup str (M.toList st) of
--         Just (FloatExp (Real v)) -> (str ++ (show v), st)
--         Nothing -> error $ "Float exp lookup failed of " ++ str

evalVal (str, st) (Val_ID x) = 
    case lookupT x st of
        ((FloatExp (Real f)), st') -> (str ++ (show f), st')
        ((BoolExp (Boolean b)), st') -> (str ++ (show b), st')
        _ -> error $ "No value (writeln) defined of variable " ++ x

evalVal (str, st) (GExp (FloatExp r)) =
    let 
        ((FloatExp (Real r')), st') = evalRExp r st
    in 
        (str ++ " ***" ++ (show r) ++ "*** " ++ (show r'), st)
        

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



