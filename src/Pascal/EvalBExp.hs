module Pascal.EvalBExp where

import Pascal.Data
import Pascal.Scope
import Pascal.EvalRExp
import qualified Data.Map.Strict as M

evalBExp :: BExp -> SymTab -> (GenExp, SymTab)

--binary operator (and, or)
evalBExp (OpB op b1 b2) st =
    let 
        ((BoolExp (Boolean b1')), st') = evalBExp b1 st
        ((BoolExp (Boolean b2')), st'') = evalBExp b2 st'
    in
        case op of
            "and" -> ((BoolExp (Boolean (b1' && b2'))), st'')
            "or" -> ((BoolExp (Boolean (b1' || b2'))), st'')

--negation (not)
evalBExp (Not b) st =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b st
    in
        ((BoolExp (Boolean (not b'))), st')

-- comparison of two real expressions (>,<,>=,<=,=,<>)
evalBExp (Comp op r1 r2) st = 
    let
        ((FloatExp (Real r1')), st') = evalRExp r1 st
        ((FloatExp (Real r2')), st'') = evalRExp r2 st'
    in
        case op of
            "=" -> ((BoolExp (Boolean(r1' == r2'))), st'')
            "<>" -> ((BoolExp (Boolean(r1' /= r2'))), st'')
            ">" -> ((BoolExp (Boolean(r1' > r2'))), st'')
            "<" -> ((BoolExp (Boolean(r1' < r2'))), st'')
            ">=" -> ((BoolExp (Boolean(r1' >= r2'))), st'')
            "<=" -> ((BoolExp (Boolean(r1' <= r2'))), st'')

--true expression
evalBExp (Boolean b) st = 
    case b of
        True -> ((BoolExp (Boolean (True))), st)
        False -> ((BoolExp (Boolean (False))), st)

-- --false expression
-- evalBExp (False_C) st = ((BoolExp (False)), st)

-- variable, aka symbol table lookup
evalBExp (Var_B str) st = 
    case lookupT str st of
        ((BoolExp b), st') -> ((BoolExp b), st')
        ((FloatExp f), st') -> ((FloatExp f), st')
        _ -> error $ "No boolean value defined of variable " ++ str

