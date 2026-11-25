module Quenelle where

import System.IO -- IO ()
import Data.Hex (hex)

toLittleEndian :: String -> String
toLittleEndian [] = []
toLittleEndian (x:xs) = toLittleEndian xs ++ [x]

readBytes :: Int -> Handle -> IO String
readBytes 0 _ = return []
readBytes i hdl = do
  a <- hGetChar hdl;
  b <- readBytes (i - 1) hdl
  return (a : b)

dumpHeader :: String -> IO ()
dumpHeader path = do
  print $ "Path: " ++ path;
  hdl <- openBinaryFile path ReadMode;
  hSeek hdl AbsoluteSeek 0x02;
  content <- readBytes 4 hdl;
  putStrLn $ hex (toLittleEndian content);
  hClose hdl;

parseHeader :: [String] -> IO ()
parseHeader [] = return ()
parseHeader ("dump":x:_) = dumpHeader x
parseHeader ("gen":_) = return ()
parseHeader _ = print "Bad arguments."

parseArgs :: [String] -> IO ()
parseArgs ("hdr":xs) = parseHeader xs
parseArgs _ = print "Arguments do not exist."
