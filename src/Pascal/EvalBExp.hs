module Pascal.EvalBExp where

import Pascal.Data
import Pascal.Scope
import Pascal.EvalRExp
import qualified Data.Map.Strict as M

-- BOOLEAN EXPRESSIONS

evalBExp :: BExp -> ((String, [SymTab]), FuncTab) -> (GenExp, SymTab)

--binary operator (and, or)
evalBExp (OpB op b1 b2) ((str, (st:tail)), ft) =
    let 
        ((BoolExp (Boolean b1')), st') = evalBExp b1 ((str, (st:tail)), ft)
        ((BoolExp (Boolean b2')), st'') = evalBExp b2 ((str, (st':tail)), ft)
    in
        case op of
            "and" -> ((BoolExp (Boolean (b1' && b2'))), st'')
            "or" -> ((BoolExp (Boolean (b1' || b2'))), st'')

--negation (not)
evalBExp (Not b) ((str, (st:tail)), ft) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b ((str, (st:tail)), ft)
    in
        ((BoolExp (Boolean (not b'))), st')

-- comparison of two real expressions (>,<,>=,<=,=,<>)
evalBExp (Comp op r1 r2) ((str, (st:tail)), ft) = 
    let
        ((FloatExp (Real r1')), st') = evalRExp r1 ((str, (st:tail)), ft)
        ((FloatExp (Real r2')), st'') = evalRExp r2 ((str, (st':tail)), ft)
    in
        case op of
            "=" -> ((BoolExp (Boolean(r1' == r2'))), st'')
            "<>" -> ((BoolExp (Boolean(r1' /= r2'))), st'')
            ">" -> ((BoolExp (Boolean(r1' > r2'))), st'')
            "<" -> ((BoolExp (Boolean(r1' < r2'))), st'')
            ">=" -> ((BoolExp (Boolean(r1' >= r2'))), st'')
            "<=" -> ((BoolExp (Boolean(r1' <= r2'))), st'')

--true expression
evalBExp (Boolean b) ((str, (st:tail)), ft) = 
    case b of
        True -> ((BoolExp (Boolean (True))), st)
        False -> ((BoolExp (Boolean (False))), st)

-- --false expression
-- evalBExp (False_C) st = ((BoolExp (False)), st)

-- variable, aka symbol table lookup
evalBExp (Var_B x) ((str, (st:tail)), ft) = 
    case lookupT x st of
        ((BoolExp b), st') -> ((BoolExp b), st')
        ((FloatExp f), st') -> ((FloatExp f), st')
        _ -> error $ "No boolean value defined of variable " ++ str