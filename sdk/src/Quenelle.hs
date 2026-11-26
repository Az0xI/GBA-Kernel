module Quenelle where

import System.IO -- IO ()
import Data.Hex (hex)
import Data.Char (ord)
import Data.Bits

toLittleEndian :: String -> String
toLittleEndian [] = []
toLittleEndian (x:xs) = toLittleEndian xs ++ [x]

readBytes :: Int -> Handle -> IO String
readBytes 0 _ = return []
readBytes i hdl = do
  a <- hGetChar hdl;
  b <- readBytes (i - 1) hdl
  return (a : b)

sumString :: String -> Int
sumString [] = 0
sumString (x:xs) = negate $ (ord x) - sumString xs;

algoCheckSum :: Handle -> IO Int
algoCheckSum hdl = do
  hSeek hdl AbsoluteSeek 0x0a0;
  algo <- readBytes 29 hdl;
  let sumAlgo = sumString algo
  putStrLn $ show sumAlgo
  return $ (.&.) (sumAlgo - 0x19) 0x0FF

readHeader :: Handle -> String -> IO ()
readHeader hdl "title" = do
  hSeek hdl AbsoluteSeek 0x0a0;
  content <- readBytes 12 hdl;
  putStrLn $ "game title: " ++ content;
readHeader hdl "logo" = do
  hSeek hdl AbsoluteSeek 0x004;
  content <- readBytes 156 hdl;
  putStrLn $ "Logo: " ++ hex (toLittleEndian content);
readHeader hdl "checkSum" = do
  hSeek hdl AbsoluteSeek 0x0bd;
  content <- readBytes 1 hdl;
  algo <- algoCheckSum hdl;
  putStrLn $ "File check sum: " ++ hex (toLittleEndian content);
  putStrLn $ "Algo check sum: " ++ show algo;
readHeader hdl "fixedValue" = do
  hSeek hdl AbsoluteSeek 0x0b2;
  content <- readBytes 1 hdl;
  putStrLn $ "Fixed value: " ++ hex (toLittleEndian content) ++ " (Should be 96)";
readHeader _ _ = return ()

dumpHeader :: String -> IO ()
dumpHeader path = do
  hdl <- openBinaryFile path ReadMode;
  readHeader hdl "title"
  readHeader hdl "logo"
  readHeader hdl "checkSum"
  readHeader hdl "fixedValue"
  hClose hdl;

parseHeader :: [String] -> IO ()
parseHeader [] = return ()
parseHeader ("dump":x:_) = dumpHeader x
parseHeader ("gen":_) = return ()
parseHeader _ = print "Bad arguments."

parseArgs :: [String] -> IO ()
parseArgs ("hdr":xs) = parseHeader xs
parseArgs _ = print "Arguments do not exist."
