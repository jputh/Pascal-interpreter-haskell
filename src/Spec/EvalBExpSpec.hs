import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Pascal.Data
import Pascal.EvalStatement
import Pascal.EvalBExp
import qualified Data.Map as M

main :: IO ()
main = hspec $ do
  let x = (("", [(M.fromList [("a", (BoolExp (Boolean (True))))])]), M.empty)

  describe "evalBExp" $ do    
      
    context "Unary Operator" $ do
      
      it "returns the conjunction of two boolean values" $ do
        evalBExp (OpB "and" (Boolean (True)) (Boolean (False))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)

      it "returns the disjunction of two boolean values" $ do
        evalBExp (OpB "or" (Boolean (True)) (Boolean (False))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)


    context "Negation Operator" $ do

      it "returns the negation of a boolean value" $ do
        evalBExp (Not (Boolean (True))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)

    
    context "Comparison Operators" $ do

      it "equality with two real values" $ do
        evalBExp (Comp "=" (Real (4.0)) (Real (4.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Comp "=" (Real (4.0)) (Real (7.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)

      it "inequality with two real values" $ do
        evalBExp (Comp "<>" (Real (4.0)) (Real (7.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Comp "<>" (Real (4.0)) (Real (4.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)
        
      it "greater than with two real values" $ do
        evalBExp (Comp ">" (Real (4.0)) (Real (2.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Comp ">" (Real (4.0)) (Real (7.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)

      it "less than with two real values" $ do
        evalBExp (Comp "<" (Real (4.0)) (Real (7.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Comp "<" (Real (9.0)) (Real (7.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)

      it "greater than or equal to with two real values" $ do
        evalBExp (Comp ">=" (Real (4.0)) (Real (4.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Comp ">=" (Real (4.0)) (Real (2.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Comp ">=" (Real (4.0)) (Real (7.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)

      it "less than or equal to with two real values" $ do
        evalBExp (Comp "<=" (Real (4.0)) (Real (4.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Comp "<=" (Real (4.0)) (Real (7.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Comp "<=" (Real (4.0)) (Real (2.0))) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)


    context "Boolean Value" $ do

      it "returns a boolean value" $ do
        evalBExp (Boolean (True)) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (True))), M.empty)
        evalBExp (Boolean (False)) (("", [M.empty]), M.empty) `shouldBe` ((BoolExp (Boolean (False))), M.empty)


    context "Table Lookup" $ do

      it "returns a boolean value" $ do
        evalBExp (Var_B "a") x `shouldBe` ((BoolExp (Boolean (True))), (M.fromList [("a", (BoolExp (Boolean (True))))]))