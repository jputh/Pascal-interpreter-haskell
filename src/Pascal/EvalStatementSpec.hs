import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Data
import EvalStatement
import Interpret

main :: IO ()
main = hspec $ do
  describe "evalState" $ do
    context (Writeln s) $ do
        it "returns a string" $ do
            evalState (Writeln "This love is taking control") `shouldBe` "This love is taking control"
        
        