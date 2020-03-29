module Pascal.EvalVal where
    -- deals with evaluating parameters of a writeln statement

import Pascal.Data
import Pascal.Scope
import Pascal.EvalRExp
import Pascal.EvalBExp
import qualified Data.Map.Strict as M


evalVal :: (String, [SymTab]) -> Val -> (String, [SymTab])

-- Just ID
evalVal (str, (st:tail)) (Val_ID x) = 
    case lookupT x st of
        ((FloatExp (Real f)), st') -> (str ++ (show f), (st':tail))
        ((BoolExp (Boolean b)), st') -> (str ++ (show b), (st':tail))
        _ -> error $ "No value (writeln) defined of variable " ++ x


evalVal (str, (st:tail)) (GExp (FloatExp r)) =
    let 
        ((FloatExp (Real r')), st') = evalRExp r st
    in 
        (str ++ " ***" ++ (show r) ++ "*** " ++ (show r'), (st':tail))
        

-- Bool expression
evalVal  (str, (st:tail)) (GExp (BoolExp b)) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b st
    in
        (str ++ (show b'), (st':tail))

-- String
evalVal (str, (st:tail)) (Val_S s) = (str ++ (removeQuote s), (st:tail))




--helper function that removes single quotes on strings
removeQuote :: String -> String
removeQuote s = tail (init s)




