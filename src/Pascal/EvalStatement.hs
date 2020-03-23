module Pascal.EvalStatement where
    --evaluator for statement data type
    
import Pascal.Data
import Pascal.Scope 
import Pascal.EvalRExp
import Pascal.EvalBExp
import Pascal.EvalVal
import qualified Data.Map.Strict as M

--temporarily here, should move somewhere else and instead call top of stack here




evalState :: Statement -> SymTab -> String -> ((GenExp, SymTab), String)
-- assignment
evalState (Assign x (FloatExp y)) st str =
    let ((FloatExp y'), st') = evalRExp y st
        st'' = addSymbol x (FloatExp y') st'
    in
        (((FloatExp y'), st''), str)

evalState (Assign x (BoolExp y)) st str = 
    let ((BoolExp y'), st') = evalBExp y st
        st'' = addSymbol x (BoolExp y') st'
    in
        (((BoolExp y'), st''), str)


-- writeln and any other function that outputs a string (but i dont think there is one)
-- should be matched by evalStatementOut.
evalStatementOut :: SymTab -> String -> Statement -> String --((GenExp, SymTab), String)
evalStatementOut st str (Writeln vals) = concat (map evalVal' vals)
    where evalVal' = evalVal st str 
-- last pattern to match; calls evalState
evalStatementOut st str  statement= 
    let ((g,st), str') = evalState statement st str
    in str'


--helper function to convert 

