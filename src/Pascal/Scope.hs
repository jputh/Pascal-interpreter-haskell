module Pascal.Scope where


import Pascal.Data
import Data.Maybe (fromJust)
import qualified Data.Map.Strict as M



--type ScopeStack = [SymTab]



lookup :: String -> SymTab -> (GenExp, SymTab)
lookup x st = 
    case M.lookup x st of
        Just v -> ((fromJust (Just v)), st)
        Nothing -> error $ "Undefined variable " ++ x

addSymbol :: String -> GenExp -> SymTab -> SymTab
addSymbol x (FloatExp f) symbTab = M.insert x (FloatExp f) symbTab
addSymbol x (BoolExp b) symbTab = M.insert x (BoolExp b) symbTab



