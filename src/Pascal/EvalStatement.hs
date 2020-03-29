module Pascal.EvalStatement where
    --evaluator for statement data type
    
import Pascal.Data
import Pascal.EvalVar 
import Pascal.EvalRExp
import Pascal.EvalBExp
import Pascal.EvalVal
import qualified Data.Map.Strict as M

--temporarily here, should move somewhere else and instead call top of stack here




evalState :: Statement -> (String, [SymTab]) -> (String, [SymTab])
-- assignment
evalState (Assign x (FloatExp y)) (str, (st:tail)) =
    let ((FloatExp y'), st') = evalRExp y st
        st'' = addSymbol x (FloatExp y') st'
    in
        (str ++ "symbol " ++ x ++ " added!", (st'':tail))

evalState (Assign x (BoolExp y)) (str, (st:tail)) = 
    let ((BoolExp y'), st') = evalBExp y st
        st'' = addSymbol x (BoolExp y') st'
    in
        (str, (st'':tail))

evalState (If_State condStmts elseStmt) (str, (st:tail)) =
    case filter isTrue (map evalConditional' condStmts) of
        [] -> foldl evalStatementOut (str, (st:tail)) elseStmt
        ((Boolean c1), stmts1):condTail -> foldl evalStatementOut (str, (st:tail)) stmts1
    where
        evalConditional' = evalConditional st

evalState (For_Loop id n max stmts) (str, (st:tail)) =
    let
        st' = addSymbol id (FloatExp (Real n')) st
        (a:b:c) = addScope (st':tail)
        ((FloatExp (Real n')), a') = evalRExp n a
        ((FloatExp (Real max')), a'') = evalRExp max a'
        --a''' = addSymbol id (FloatExp (Real n')) a''
        (str', a''':tail') =
            if n' < max' then
                evalState (For_Loop id (Real (n' + 1)) (Real max') stmts) (foldl evalStatementOut (str, removeScope(a'':b:c)) stmts)
            else
                (str, removeScope(a'':b:c))

    in 
        (str', a''':tail')
    -- let
    --     --(a:b:c) = addScope (st:tail)
    --     ((FloatExp (Real n')), st') = evalRExp n st
    --     ((FloatExp (Real max')), st'') = evalRExp max st'
        
    --     st''' = addSymbol id (FloatExp (Real n')) st''
    --     (str', (st'''':tail)) =
    --         if n' < max' then
    --             evalState (For_Loop id (Real (n' + 1)) (Real max') stmts) (foldl evalStatementOut (str, (st''':tail)) stmts)
    --         else
    --             (str', (st''':tail))

    -- in 
    --     (str', (st'''':tail))




-- writeln and any other function that outputs a string (but i dont think there is one)
-- should be matched by evalStatementOut.
evalStatementOut :: (String, [SymTab]) -> Statement -> (String, [SymTab]) --((GenExp, SymTab), String)
evalStatementOut (str, (st:tail)) (Writeln vals) = 
    let 
        (str', (st':tail)) = foldl evalVal (str, (st:tail)) vals
    in 
        (str' ++ "\n", (st':tail))
-- last pattern to match; calls evalState
evalStatementOut (str, (st:tail))  statement = 
    let 
        (str', (st':tail)) = evalState statement (str, (st:tail))
    in 
        (str', (st':tail))


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
addScope (st:tail) = (st:st:tail)

removeScope :: [SymTab] -> [SymTab]
removeScope (st1:st2:tail) = ((M.intersection st1 st2):tail)
