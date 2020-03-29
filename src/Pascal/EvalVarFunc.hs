module Pascal.EvalVarFunc where


import Pascal.Data
import Pascal.EvalRExp
import Pascal.EvalBExp
import qualified Data.Map.Strict as M


-- FUNCTIONS FOR SYMBOL TABLE
-- Initializing variables
evalVarDec :: SymTab -> VarDec -> SymTab
evalVarDec st (Init x (FloatExp f)) = 
    let 
        ((FloatExp (Real f')), st') = evalRExp f st
        st'' = addSymbol x (FloatExp (Real f')) st'
    in
        st''

evalVarDec st (Init x (BoolExp b)) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b st
        st'' = addSymbol x (BoolExp (Boolean b')) st'
    in
        st''
    
-- Declaring variables
evalVarDec st (DecF x) = addSymbol x (FloatExp (Real (0.0::Float))) st
evalVarDec st (DecB x) = addSymbol x (BoolExp (Boolean (False::Bool))) st


-- add symbol to symbol table
addSymbol :: String -> GenExp -> SymTab -> SymTab
addSymbol x (FloatExp f) st = 
    let 
        (FloatExp (Real f'), st') = evalRExp f st 
    in
        M.insert x (FloatExp (Real f')) st
addSymbol x (BoolExp b) st = 
    let 
        (BoolExp (Boolean b'), st') = evalBExp b st 
    in
        M.insert x (BoolExp (Boolean b')) st


--FUNCTIONS FOR FUNCTION TABLE
--add function to function table
addFunc :: FuncTab -> Function  -> FuncTab
addFunc ft (id, body)  = 
    -- let
    --     st = M.empty
    --     st' = foldl evalVarDec st vars -- add variables in var block to symbol table
    M.insert id body ft


-- addFormalParams :: ParamGroup -> SymTab -> SymTab
-- addFormalParams pg st =
--     case pg of
--         (Type_Real ids) -> foldl addSymbol' st ids