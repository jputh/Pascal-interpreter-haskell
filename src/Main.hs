module Main where

import Pascal
import System.Environment

main :: IO ()
main = do
    (fileName:_) <- getArgs
    contents <- readFile fileName --contents in just a string
    case parseString contents of 
        Left err -> print $ show err
        Right ast -> do
            putStrLn $ show ast ++ "%%%"
            putStrLn $ interpret ast


