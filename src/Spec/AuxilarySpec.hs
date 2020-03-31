import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Pascal.Data
import Pascal.EvalStatement
import Pascal.Auxilary
import qualified Data.Map as M

main :: IO ()
main = hspec $ do

  let str = ""
  let st = [("a", (FloatExp (Real (10.0)))), ("b", (BoolExp (Boolean (False))))]
  let ft = M.fromList [("SayHello", (RType_Real ["x"] [(Init "y" (FloatExp (Real (8.0))))] [Writeln [ (Val_S "Hello")]]))]

  let st' = M.fromList[("a", (FloatExp (Real (10.0)))), ("b", (BoolExp (Boolean (False)))), ("x", (FloatExp (Real (8.0))))]



  describe "evalValParam" $ do    
      
    context "Returns a GenExp when evaluating parameters passed into a function" $ do

      it "ID lookup" $ do
        evalValParam ((str, [(M.fromList st)]), ft) (Val_ID "a") `shouldBe` (FloatExp (Real (10.0)))

      it "RExp calculation" $ do
        evalValParam ((str, [(M.fromList st)]), ft) (GExp (FloatExp (Real (1.0)))) `shouldBe` (FloatExp (Real (1.0)))

      it "BExp calculation" $ do
        evalValParam ((str, [(M.fromList st)]), ft) (GExp (BoolExp (Boolean (False)))) `shouldBe` (BoolExp (Boolean (False)))



  describe "evalValW" $ do    
      
    context "Returns a string when evaluating parameters passed into writeln" $ do

      it "ID lookup" $ do
        evalValW ((str, [(M.fromList st)]), ft) (Val_ID "a") `shouldBe` (((str ++ "10.0"), [(M.fromList st)]), ft)

      it "RExp calculation" $ do
        evalValW ((str, [(M.fromList st)]), ft) (GExp (FloatExp (Real (1.0)))) `shouldBe` (((str ++ "1.0"), [(M.fromList st)]), ft)

      it "BExp calculation" $ do
        evalValW ((str, [(M.fromList st)]), ft) (GExp (BoolExp (Boolean (False)))) `shouldBe` (((str ++ "False"), [(M.fromList st)]), ft)

      it "String passed in to writeln" $ do
        evalValW ((str, [(M.fromList st)]), ft) (Val_S "'Hello'") `shouldBe` (((str ++ "Hello"), [(M.fromList st)]), ft)



  describe "removeQuote" $ do    
      
    context "Removes the quotations around strings passed in (used in writeln function)" $ do

      it "removes quotes" $ do
        removeQuote "'Hello World'" `shouldBe` "Hello World"



