module Pascal.EvalVar where


import Pascal.Data
import Pascal.EvalRExp
import Pascal.EvalBExp
import qualified Data.Map.Strict as M



--type ScopeStack = [SymTab]

evalVarDec :: SymTab -> VarDec -> SymTab
evalVarDec st (InitF x (FloatExp f)) = 
    let 
        ((FloatExp (Real f')), st') = evalRExp f st
        st'' = addSymbol x (FloatExp (Real f')) st'
    in
        st''

evalVarDec st (InitB x (BoolExp b)) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b st
        st'' = addSymbol x (BoolExp (Boolean b')) st'
    in
        st''
    
-- evalVarDec st (InitB x (BoolExp b)) = addSymbol x (BoolExp b) st
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