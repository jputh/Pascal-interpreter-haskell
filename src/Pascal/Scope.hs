module Pascal.Scope where

import Pascal.Data
import Data.Maybe (fromJust)
import qualified Data.Map.Strict as M


lookupT :: String -> SymTab -> (GenExp, SymTab)
lookupT x st = 
    case M.lookup x st of
        Just (FloatExp (Real f)) -> ((fromJust (Just (FloatExp (Real f)))), st)
        Just (BoolExp (Boolean b)) -> ((fromJust (Just (BoolExp (Boolean b)))), st)
        Nothing -> error $ "Lookup function failed at root of " ++ x

