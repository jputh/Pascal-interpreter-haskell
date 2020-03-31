module Pascal.Auxilary where

import Pascal.Data
import Pascal.EvalRExp
import Pascal.EvalBExp
import Pascal.Scope
import qualified Data.Map.Strict as M

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
        ((str ++ (show r'), (st':tail)), ft)
        

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