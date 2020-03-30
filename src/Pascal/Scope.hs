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

lookupF :: String -> FuncTab -> FunctionBody
lookupF s ft = 
    case M.lookup s ft of 
        Just (RType_Real pg vars stmts) -> (fromJust (Just (RType_Real pg vars stmts)))
        Just (RType_Bool pg vars stmts) -> (fromJust (Just (RType_Bool pg vars stmts)))
        Just (RType_None pg vars stmts) -> (fromJust (Just (RType_None pg vars stmts)))
        Nothing -> error $ "Lookup function failed at root of " ++ s