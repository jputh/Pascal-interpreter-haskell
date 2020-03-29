import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Pascal.Data
import Pascal.EvalStatement
import qualified Data.Map as M

main :: IO ()
main = hspec $ do
  describe "evalState" $ do
    context "Writeln" $ do
        it "returns a string" $ do
            evalStatementOut ("", M.empty) (Writeln [(Val_S "'Howdy'")]) `shouldBe` ("Howdy\n", M.empty)
        
        