module Pascal.EvalRExp where

import Pascal.Data
import Pascal.Scope
import qualified Data.Map.Strict as M

evalRExp :: RExp -> SymTab -> (GenExp, SymTab)

--unary operator
evalRExp (Op1 "-" r) st = 
    let 
        ((FloatExp (Real r')), st') = evalRExp r st
    in 
        ((FloatExp (Real (r' * (-1)))), st')

--binary operator
evalRExp (Op2 op r1 r2) st = 
    let ((FloatExp (Real r1')), st') = evalRExp r1 st
        ((FloatExp (Real r2')), st'') = evalRExp r2 st'
    in
        case op of
            "*" -> ((FloatExp (Real (r1' * r2'))), st'')
            "/" -> ((FloatExp (Real (r1' / r2'))), st'')
            "+" -> ((FloatExp (Real (r1' + r2'))), st'')
            "-" -> ((FloatExp (Real (r1' - r2'))), st'')
            
--float value
evalRExp (Real r) st = ((FloatExp (Real r)), st)

-- string, aka table lookup 
evalRExp (Var_R str) st = 
    case lookupT str st of
        ((FloatExp f), st') -> ((FloatExp f), st')
        _ -> error $ "No real value defined of variable " ++ str
    -- let
    --     ((FloatExp f), st') = lookupT str st
    -- in
    --     ((FloatExp f), st')




    
    -- case lookup str (M.toList st) of
    --     Just (FloatExp (Real v)) -> ((FloatExp (Real v)), st)
    --     Nothing -> error $ "Float exp lookup failed of " ++ str


-- evalBExp (Var_B str) st = 
--     case lookup str (M.toList st) of
--         Just (BoolExp (Boolean v)) -> ((BoolExp (Boolean v)), st)
--         Just (FloatExp (Real v)) -> ((FloatExp (Real v)), st)
--         Nothing -> error $ "Boolean exp lookup failed of " ++ str