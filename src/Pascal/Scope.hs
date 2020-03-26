module Pascal.Scope where


import Pascal.Data
import Data.Maybe (fromJust)
import Pascal.EvalRExp
import Pascal.EvalBExp
import qualified Data.Map.Strict as M



--type ScopeStack = [SymTab]



lookup :: String -> SymTab -> (GenExp, SymTab)
lookup x st = 
    case M.lookup x st of
        Just v -> ((fromJust (Just v)), st)
        Nothing -> error $ "Lookup function failed at root of " ++ x

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



