module Pascal.EvalRExp where

import Pascal.Data
import Pascal.Scope
import Pascal.EvalVal
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

-- -- function call
-- evalRExp (RFuncCall funcId paramList) ((str, (st:tail)), ft) =
--     let
--         params = map (evalValParam ((str, (st:tail)), ft)) paramList
--         func = lookupF funcId ft
--             --case lookupF procId ft of
--                 --(RType_None pg vars stmts) -> ((str ++ "function table found " ++ procId , st:tail), ft)
--                     --((str ++ " $$$$$$$$$$  " ++ (show st) ++ " $$$$$$$$$$  ", (st:tail)), ft)
--                 --_ -> error $ "No procedure found of name " ++ procId
--         (a', stmts2) = setFScope func params ((str, (st:tail)), ft) funcId
--         ((str, (a'':tail)), ft) = evalVarDec ((str, (a':tail)), ft) (DecF funcId)
--         ((str', a''':tail'), ft') = foldl evalStatementOut ((str, a'':[]), ft) stmts2
--         (result, stTemp) = lookupT funcId a'''
--         (a'''':tail'') = removeScope(a''':st:tail)
--         ((fStr, (fSt:fTail)), fFt) = addSymbol x result a''''
--     in 
--         (result, (fSt:fTail))

-- string, aka table lookup 
evalRExp (Var_R x) ((str, (st:tail)), ft) = 
    case lookupT x st of
        ((FloatExp f), st') -> ((FloatExp f), st')
        _ -> error $ "No real value defined of variable " ++ str





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




--HELPER: 

--allows for passing of parameters
evalValParam :: ((String, [SymTab]), FuncTab) -> Val -> GenExp
evalValParam ((str, (st:tail)), ft) (Val_ID x) = 
    case lookupT x st of
        ((FloatExp (Real f)), st') -> (FloatExp (Real f))
        ((BoolExp (Boolean b)), st') -> (BoolExp (Boolean b))
        _ -> error $ "No value (writeln) defined of variable " ++ x

evalValParam ((str, (st:tail)), ft) (GExp (FloatExp r)) =
    let 
        ((FloatExp (Real r')), st') = evalRExp r ((str, (st:tail)), ft)
    in 
        (FloatExp (Real r'))

evalValParam ((str, (st:tail)), ft) (GExp (BoolExp b)) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b ((str, (st:tail)), ft)
    in 
        (BoolExp (Boolean b'))

evalValW :: ((String, [SymTab]), FuncTab) -> Val -> ((String, [SymTab]), FuncTab)

-- Just ID
evalValW ((str, (st:tail)), ft) (Val_ID x) = 
    case lookupT x st of
        ((FloatExp (Real f)), st') -> ((str ++ (show f), (st':tail)), ft)
        ((BoolExp (Boolean b)), st') -> ((str ++ (show b), (st':tail)), ft)
        _ -> error $ "No value (writeln) defined of variable " ++ x


evalValW ((str, (st:tail)), ft) (GExp (FloatExp r)) =
    let 
        ((FloatExp (Real r')), st') = evalRExp r ((str, (st:tail)), ft)
    in 
        ((str ++ " ***" ++ (show r) ++ "*** " ++ (show r'), (st':tail)), ft)
        

-- Bool expression
evalValW  ((str, (st:tail)), ft) (GExp (BoolExp b)) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b ((str, (st:tail)), ft)
    in
        ((str ++ (show b'), (st':tail)), ft)

-- String
evalValW ((str, (st:tail)), ft) (Val_S s) = ((str ++ (removeQuote s), (st:tail)), ft)


--helper function that removes single quotes on strings
removeQuote :: String -> String
removeQuote s = tail (init s)





-- FUNCTIONS FOR SYMBOL TABLE (EvalVarFunc)
-- Initializing variables
evalVarDec :: ((String, [SymTab]), FuncTab) -> VarDec -> ((String, [SymTab]), FuncTab)
evalVarDec ((str, (st:tail)), ft) (Init x (FloatExp f)) = 
    let 
        ((FloatExp (Real f')), st') = evalRExp f ((str, (st:tail)), ft)
        ((str, (st'':tail)), ft) = addSymbol x (FloatExp (Real f')) ((str, (st':tail)), ft)
    in
        ((str, (st'':tail)), ft)

evalVarDec ((str, (st:tail)), ft) (Init x (BoolExp b)) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b ((str, (st:tail)), ft)
        ((str, (st'':tail)), ft) = addSymbol x (BoolExp (Boolean b')) ((str, (st':tail)), ft)
    in
        ((str, (st'':tail)), ft)
    
-- Declaring variables
evalVarDec ((str, (st:tail)), ft) (DecF x) =
    let
        ((str, (st'':tail)), ft) = addSymbol x (FloatExp (Real (0.0::Float))) ((str, (st:tail)), ft)
    in
        ((str, (st'':tail)), ft)

evalVarDec ((str, (st:tail)), ft) (DecB x) = 
    let
        ((str, (st'':tail)), ft) = addSymbol x (BoolExp (Boolean (False::Bool))) ((str, (st:tail)), ft)
    in
        ((str, (st'':tail)), ft)


-- add symbol to symbol table
addSymbol :: String -> GenExp -> ((String, [SymTab]), FuncTab) -> ((String, [SymTab]), FuncTab)
addSymbol x (FloatExp f) ((str, (st:tail)), ft) = 
    let 
        (FloatExp (Real f'), st') = evalRExp f ((str, (st:tail)), ft) 
        st'' = M.insert x (FloatExp (Real f')) st
    in
        ((str, (st'':tail)), ft)

addSymbol x (BoolExp b) ((str, (st:tail)), ft) = 
    let 
        (BoolExp (Boolean b'), st') = evalBExp b ((str, (st:tail)), ft) 
        st'' = M.insert x (BoolExp (Boolean b')) st
    in
        ((str, (st'':tail)), ft)



--FUNCTIONS FOR FUNCTION TABLE
--add function to function table
addFunc :: FuncTab -> Function  -> FuncTab
addFunc ft (id, body)  = M.insert id body ft



--setting up scope of functions and procedure,
setFScope :: FunctionBody -> [GenExp] -> ((String, [SymTab]), FuncTab) -> String -> (SymTab, [Statement])
setFScope (RType_Real pg vars stmts) exprs ((str, (st:tail)), ft) name =
    let
        ((str', (st':tail')), ft') = foldl evalVarDec ((str, (st:tail)), ft) vars -- add variable declarations
        vars2 = zipWith matchParam pg exprs
        ((str'', (st'':tail'')), ft'') = foldl evalVarDec ((str', (st':tail')), ft') vars2
        ((str''', (st''':tail''')), ft''') = addSymbol name (FloatExp (Real (0.0::Float))) ((str'', (st'':tail'')), ft'')
    in 
        (st''', stmts)


setFScope (RType_Bool pg vars stmts) exprs ((str, (st:tail)), ft) name =
   let
        ((str', (st':tail')), ft') = foldl evalVarDec ((str, (st:tail)), ft) vars -- add variable declarations
        vars2 = zipWith matchParam pg exprs
        ((str'', (st'':tail'')), ft'') = foldl evalVarDec ((str, (st':tail)), ft) vars2
        ((str''', (st''':tail''')), ft''') = addSymbol name (BoolExp (Boolean (False::Bool))) ((str, (st'':tail)), ft)
    in 
        (st''', stmts)

setFScope (RType_None pg vars stmts) exprs ((str, (st:tail)), ft) name =
    let
        ((str', (st':tail')), ft') = foldl evalVarDec ((str, (st:tail)), ft) vars -- add variable declarations
        vars2 = zipWith matchParam pg exprs
        ((str'', (st'':tail'')), ft'') = foldl evalVarDec ((str', (st':tail')), ft') vars2
    in 
       (st'', stmts)

matchParam :: String -> GenExp -> VarDec
matchParam p v = (Init p v)