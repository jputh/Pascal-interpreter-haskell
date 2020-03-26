module Pascal.EvalRExp where

import Pascal.Data
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
evalRExp (Var str) st = 
    case lookup str (M.toList st) of
        Just (FloatExp (Real v)) -> ((FloatExp (Real v)), st)
        Nothing -> error $ "Float exp lookup failed of " ++ str

