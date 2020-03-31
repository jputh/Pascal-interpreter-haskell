import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Pascal.Data
import Pascal.EvalStatement
import Pascal.EvalRExp
import qualified Data.Map as M

main :: IO ()
main = hspec $ do
  describe "evalRExp" $ do

      
    context "Unary Operator" $ do

      it "returns value * -1" $ do
        evalRExp (Op1 "-" (Real (10.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (-10.0))), M.empty)


    context "Binary Operator" $ do

      it "adds two real values together" $ do
        evalRExp (Op2 "+" (Real (10.0)) (Real (5.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (15.0))), M.empty)

      it "subtracts two real values" $ do
        evalRExp (Op2 "-" (Real (10.0)) (Real (5.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (5.0))), M.empty)

      it "multiplies two real values together" $ do
        evalRExp (Op2 "*" (Real (10.0)) (Real (5.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (50.0))), M.empty)

      it "divides two real values together" $ do
        evalRExp (Op2 "/" (Real (10.0)) (Real (5.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (2.0))), M.empty)



    context "Equations" $ do

      it "computes the square root" $ do
        evalRExp (OpEq "sqrt" (Real (4.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (2.0))), M.empty)

      it "computes the natural log" $ do
        evalRExp (OpEq "ln" (Real (1.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (0.0))), M.empty)

      it "computes the exponential" $ do
        evalRExp (OpEq "exp" (Real (0.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (1.0))), M.empty)

      it "computes the sin" $ do
        evalRExp (OpEq "sin" (Real (0.0))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (0.0))), M.empty)

      it "computes the cos" $ do
        evalRExp (OpEq "cos" (Real (pi))) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (-1.0))), M.empty)


    context "Real Value" $ do

      it "returns the real value" $ do
        evalRExp (Real (4.0)) (("", [M.empty]), M.empty) `shouldBe` ((FloatExp (Real (4.0))), M.empty)


    context "Table Lookup" $ do

      it "returns the real value in a symbol table" $ do
        evalRExp (Var_R "a") (("", [(M.fromList [("a", (FloatExp (Real 19.0)))])]), M.empty) `shouldBe` ((FloatExp (Real (19.0))), (M.fromList [("a", (FloatExp (Real 19.0)))]))
