module Pascal.EvalStatement where
    --evaluator for statement data type
    
import Pascal.Data
import Pascal.EvalVar 
import Pascal.EvalRExp
import Pascal.EvalBExp
import Pascal.EvalVal
import qualified Data.Map.Strict as M

--temporarily here, should move somewhere else and instead call top of stack here




evalState :: Statement -> (String, SymTab) -> (String, SymTab)
-- assignment
evalState (Assign x (FloatExp y)) (str, st) =
    let ((FloatExp y'), st') = evalRExp y st
        st'' = addSymbol x (FloatExp y') st'
    in
        (str ++ "symbol " ++ x ++ " added!", st'')

evalState (Assign x (BoolExp y)) (str, st) = 
    let ((BoolExp y'), st') = evalBExp y st
        st'' = addSymbol x (BoolExp y') st'
    in
        (str, st'')

evalState (If_State condStmts elseStmt) (str, st) =
    case filter isTrue (map evalConditional' condStmts) of
        [] -> foldl evalStatementOut (str, st) elseStmt
        ((Boolean c1), stmts1):tail -> foldl evalStatementOut (str, st) stmts1
    
    where
        evalConditional' = evalConditional st

evalState (For_Loop id n max stmts) (str, st) =
    let
        ((FloatExp (Real n')), st') = evalRExp n st
        ((FloatExp (Real max')), st'') = evalRExp max st'
        st''' = addSymbol id (FloatExp (Real n')) st''
        (str', st'''') =
            if n' < max' then
                evalState (For_Loop id (Real (n' + 1)) (Real max') stmts) (foldl evalStatementOut (str, st''') stmts)
            else
                (str, st''')

    in 
        (str', st'''')




-- writeln and any other function that outputs a string (but i dont think there is one)
-- should be matched by evalStatementOut.
evalStatementOut :: (String, SymTab) -> Statement -> (String, SymTab) --((GenExp, SymTab), String)
evalStatementOut (str, st) (Writeln vals) = 
    let 
        (str', st') = foldl evalVal (str, st) vals
    in 
        (str' ++ "\n", st')
-- last pattern to match; calls evalState
evalStatementOut (str, st)  statement = 
    let 
        (str', st') = evalState statement (str, st)
    in 
        (str', st')


--HELPER FUNCTIONS

--helper function to evaluate conditional types
evalConditional :: SymTab -> Conditional -> Conditional
evalConditional st (b, stmts) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b st 
    in
        ((Boolean b'), stmts)

--helper function for if-statements
isTrue :: Conditional -> Bool
isTrue ((Boolean b), stmts) = b == True


--creating a new scope
addScope :: [SymTab] -> [SymTab]
addScope (st:tail) = 
    let 
        newST = st
    in 
        (newST:st:tail)

removeScope :: [SymTab] -> [SymTab]
removeScope (st1:st2:tail) = (M.intersection st1 st2):tail
