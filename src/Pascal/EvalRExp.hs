module Pascal.EvalRExp where

import Pascal.Data
import Pascal.Scope
import qualified Data.Map.Strict as M

evalRExp :: RExp -> ((String, [SymTab]), FuncTab) -> (GenExp, SymTab)

--unary operator
evalRExp (Op1 "-" r) ((str, (st:tail)), ft) = 
    let 
        ((FloatExp (Real r')), st') = evalRExp r ((str, (st:tail)), ft)
    in 
        ((FloatExp (Real (r' * (-1)))), st')

--binary operator
evalRExp (Op2 op r1 r2) ((str, (st:tail)), ft) = 
    let ((FloatExp (Real r1')), st') = evalRExp r1 ((str, (st:tail)), ft)
        ((FloatExp (Real r2')), st'') = evalRExp r2 ((str, (st':tail)), ft)
    in
        case op of
            "*" -> ((FloatExp (Real (r1' * r2'))), st'')
            "/" -> ((FloatExp (Real (r1' / r2'))), st'')
            "+" -> ((FloatExp (Real (r1' + r2'))), st'')
            "-" -> ((FloatExp (Real (r1' - r2'))), st'')

evalRExp (OpEq op r) ((str, (st:tail)), ft) = 
    let ((FloatExp (Real r')), st') = evalRExp r ((str, (st:tail)), ft)
    in
        case op of
            "sqrt" -> ((FloatExp (Real (sqrt(r')))), st')
            "ln" -> ((FloatExp (Real (log(r')))), st')
            "exp" -> ((FloatExp (Real (exp(r')))), st')
            "sin" -> ((FloatExp (Real (sin(r')))), st')
            "cos" -> ((FloatExp (Real (cos(r')))), st')
            
--float value
evalRExp (Real r) ((str, (st:tail)), ft) = ((FloatExp (Real r)), st)


-- string, aka table lookup 
evalRExp (Var_R x) ((str, (st:tail)), ft) = 
    case lookupT x st of
        ((FloatExp f), st') -> ((FloatExp f), st')
        _ -> error $ "No real value defined of variable " ++ str






