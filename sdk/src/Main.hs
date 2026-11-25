module Main where

import Quenelle
import System.Environment -- argv

main :: IO ()
main = do
  argv <- getArgs;
  parseArgs argv;
  return ();
