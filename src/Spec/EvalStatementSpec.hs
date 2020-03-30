import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Pascal.Data
import Pascal.EvalStatement
import qualified Data.Map as M

main :: IO ()
main = hspec $ do
  -- describe "evalState" $ do
  --   context "Writeln" $ do
  --       it "returns a string" $ do
  --           evalStatementOut (("", [M.empty]), M.empty) (Writeln [(Val_S "'Howdy'")]) `shouldBe` (("Howdy\n", [M.empty]), M.empty) 

  describe "setFScope" $ do
    it "sets up a function's scope" $ do
      setFScope (RType_None ["a"] [(Init "v" (FloatExp (Real 0.0)))] [Writeln [Val_S "'Hello World'"]]) [(FloatExp (Real 10.0))] (M.fromList [("t", (FloatExp (Real 19.0)))]) "procedureid" `shouldBe` (M.fromList[("t", (FloatExp (Real 19.0))), ("v", (FloatExp (Real 0.0))), ("a", (FloatExp (Real 10.0)))], [Writeln [Val_S "'Hello World'"]])

        
        