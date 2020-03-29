module Pascal.EvalStatement where
    --evaluator for statement data type
    
import Pascal.Data
import Pascal.EvalVarFunc
import Pascal.EvalRExp
import Pascal.EvalBExp
import Pascal.EvalVal
import qualified Data.Map.Strict as M

--temporarily here, should move somewhere else and instead call top of stack here




evalState :: Statement -> ((String, [SymTab]), FuncTab) -> ((String, [SymTab]), FuncTab)
-- assignment
evalState (Assign x (FloatExp y)) ((str, (st:tail)), ft) =
    let ((FloatExp y'), st') = evalRExp y st
        st'' = addSymbol x (FloatExp y') st'
    in
        ((str ++ "symbol " ++ x ++ " added!", (st'':tail)), ft)

evalState (Assign x (BoolExp y)) ((str, (st:tail)), ft) = 
    let ((BoolExp y'), st') = evalBExp y st
        st'' = addSymbol x (BoolExp y') st'
    in
        ((str, (st'':tail)), ft)

-- evalState (ProcCall procId params) ((str, (st:tail)), ft) =
--     let
--         func = M.lookup procId ft
--         case func of
--             (RType_Real pg)


evalState (If_State condStmts elseStmt) ((str, (st:tail)), ft) =
    case filter isTrue (map evalConditional' condStmts) of
        [] -> foldl evalStatementOut ((str, (st:tail)), ft) elseStmt
        ((Boolean c1), stmts1):condTail -> foldl evalStatementOut ((str, (st:tail)), ft) stmts1
    where
        evalConditional' = evalConditional st

evalState (For_Loop id n max stmts) ((str, (st:tail)), ft) =
    let
        st' = addSymbol id (FloatExp (Real n')) st
        (a:b:c) = addScope (st':tail)
        ((FloatExp (Real n')), a') = evalRExp n a
        ((FloatExp (Real max')), a'') = evalRExp max a'
        ((str', a''':tail'), ft) =
            if n' < max' then
                evalState (For_Loop id (Real (n' + 1)) (Real max') stmts) (foldl evalStatementOut ((str, removeScope(a'':b:c)), ft) stmts)
            else
                ((str, removeScope(a'':b:c)), ft)
    in 
        ((str', a''':tail'), ft)
    -- where
    --     evalStatementOut' = evalStatementOut ft


evalState (While_Loop n stmts) ((str, (st:tail)), ft) =
    let
        (a:b:c) = addScope (st:tail)
        ((BoolExp (Boolean n')), a') = evalBExp n a
        ((str', a'':tail'), ft) =
            if n' then
                evalState (While_Loop n stmts) (foldl evalStatementOut ((str, removeScope(a':b:c)), ft) stmts)
            else
                ((str, removeScope(a':b:c)), ft)
    in 
        ((str', a'':tail'), ft)



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
evalStatementOut :: ((String, [SymTab]), FuncTab) -> Statement -> ((String, [SymTab]), FuncTab) --((GenExp, SymTab), String)
evalStatementOut ((str, (st:tail)), ft) (Writeln vals) = 
    let 
        (str', (st':tail)) = foldl evalVal (str, (st:tail)) vals
    in 
        ((str' ++ "\n", (st':tail)), ft)
-- last pattern to match; calls evalState
evalStatementOut ((str, (st:tail)), ft)  statement = 
    let 
        ((str', (st':tail)), ft) = evalState statement ((str, (st:tail)), ft)
    in 
        ((str', (st':tail)), ft)






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
