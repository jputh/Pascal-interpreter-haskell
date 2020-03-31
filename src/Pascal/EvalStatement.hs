module Pascal.EvalStatement where
    --evaluator for statement data type
    
import Pascal.Data
import Pascal.EvalRExp
import Pascal.EvalVal
import Pascal.Scope
import Data.Maybe (fromJust)
import qualified Data.Map.Strict as M

--temporarily here, should move somewhere else and instead call top of stack here




evalState :: Statement -> ((String, [SymTab]), FuncTab) -> ((String, [SymTab]), FuncTab)
-- assignment
evalState (Assign x val) ((str, (st:tail)), ft) =
    let
        genVal = evalValParam ((str, (st:tail)), ft) val
        ((str', (st':tail')), ft') = addSymbol x genVal ((str, (st:tail)), ft)
    in
        ((str' ++ "symbol " ++ x ++ " added!", (st':tail')), ft')

--procedure call
evalState (ProcCall procId paramList) ((str, (st:tail)), ft) =
    let
        params = map (evalValParam ((str, (st:tail)), ft)) paramList
        func = lookupF procId ft
            --case lookupF procId ft of
                --(RType_None pg vars stmts) -> ((str ++ "function table found " ++ procId , st:tail), ft)
                    --((str ++ " $$$$$$$$$$  " ++ (show st) ++ " $$$$$$$$$$  ", (st:tail)), ft)
                --_ -> error $ "No procedure found of name " ++ procId
        (a', stmts2) = setFScope func params ((str, (st:tail)), ft) procId
        ((str', a'':tail'), ft') = foldl evalStatementOut ((str, a':[]), ft) stmts2
        (a''':tail'') = removeScope(a'':st:tail)
    in
        --((str ++ " $$$$$$$$$$  " ++ (show str') ++ " $$$$$$$$$$  ", (a''':tail'')), ft)
        ((str', (a''':tail'')), ft)

--function call
evalState (FuncCall x funcId paramList) ((str, (st:tail)), ft) =
    let
        params = map (evalValParam ((str, (st:tail)), ft)) paramList
        func = lookupF funcId ft
            --case lookupF procId ft of
                --(RType_None pg vars stmts) -> ((str ++ "function table found " ++ procId , st:tail), ft)
                    --((str ++ " $$$$$$$$$$  " ++ (show st) ++ " $$$$$$$$$$  ", (st:tail)), ft)
                --_ -> error $ "No procedure found of name " ++ procId
        (a', stmts2) = setFScope func params ((str, (st:tail)), ft) funcId
        --((str, (a'':tail)), ft) = evalVarDec ((str, (a':tail)), ft) (DecF funcId)
        ((str', a'':tail'), ft') = foldl evalStatementOut ((str, a':[]), ft) stmts2
        (result, stTemp) = lookupT funcId a''
        (a''':tail'') = removeScope(a'':st:tail)
        ((fStr, (fSt:fTail)), fFt) = addSymbol x result ((str', a''':tail''), ft)
    in 
        ((fStr, (fSt:fTail)), ft)


--if statement
evalState (If_State condStmts elseStmt) ((str, (st:tail)), ft) =
    case filter isTrue (map evalConditional' condStmts) of
        [] -> foldl evalStatementOut ((str, (st:tail)), ft) elseStmt
        ((Boolean c1), stmts1):condTail -> foldl evalStatementOut ((str, (st:tail)), ft) stmts1
    where
        evalConditional' = evalConditional ((str, (st:tail)), ft)

--for loop
evalState (For_Loop id n max stmts) ((str, (st:tail)), ft) =
    let
        ((str', (st':tail)), ft') = addSymbol id (FloatExp (Real n')) ((str, (st:tail)), ft)
        (a:b:c) = addScope (st':tail)
        ((FloatExp (Real n')), a') = evalRExp n ((str, (a:[])), ft)
        ((FloatExp (Real max')), a'') = evalRExp max ((str, (a':[])), ft)
        ((str'', a''':tail'), ft) =
            if n' < max' then
                evalState (For_Loop id (Real (n' + 1)) (Real max') stmts) (foldl evalStatementOut ((str, removeScope(a'':b:c)), ft) stmts)
            else
                ((str, removeScope(a'':b:c)), ft)
    in 
        ((str'', a''':tail'), ft)
    -- let
    --     st' = addSymbol id (FloatExp (Real n')) ((str, (st:tail)), ft)
    --     (a:b:c) = addScope (st':tail)
    --     ((FloatExp (Real n')), a') = evalRExp n ((str, (a:[])), ft)
    --     ((FloatExp (Real max')), a'') = evalRExp max ((str, (a':[])), ft)
    --     ((str', a''':tail'), ft) =
    --         if n' < max' then
    --             evalState (For_Loop id (Real (n' + 1)) (Real max') stmts) (foldl evalStatementOut ((str, removeScope(a'':b:c)), ft) stmts)
    --         else
    --             ((str, removeScope(a'':b:c)), ft)
    -- in 
    --     ((str', a''':tail'), ft)

--while loop
evalState (While_Loop n stmts) ((str, (st:tail)), ft) =
    let
        (a:b:c) = addScope (st:tail)
        ((BoolExp (Boolean n')), a') = evalBExp n ((str, (a:[])), ft)
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
        ((str', (st':tail)), ft) = foldl evalValW ((str, (st:tail)), ft) vals
    in 
        ((str' ++ "\n", (st':tail)), ft)
-- last pattern to match; calls evalState
evalStatementOut ((str, (st:tail)), ft)  statement = 
    let 
        ((str', (st':tail')), ft') = evalState statement ((str, (st:tail)), ft)
    in 
        ((str', (st':tail')), ft')







--HELPER FUNCTIONS

--helper function to evaluate conditional types
evalConditional :: ((String, [SymTab]), FuncTab) -> Conditional -> Conditional
evalConditional ((str, (st:tail)), ft) (b, stmts) =
    let 
        ((BoolExp (Boolean b')), st') = evalBExp b ((str, (st:tail)), ft) 
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




