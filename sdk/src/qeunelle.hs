import System.Environment
import System.IO
import qualified Data.ByteString.Lazy as BL


dumpHeader :: String -> IO ()
dumpHeader x = do
  putStrLn $ "Path: " ++ x;
  file <- openFile x ReadMode;
  content <- hGetContents file;
  putStr content;
  hClose file;
  return ()

parseHeader :: [String] -> IO ()
parseHeader [] = return ()
parseHeader ("dump":x:_) = dumpHeader x
parseHeader ("gen":x) = return ()
parseHeader _ = putStrLn "Bad arguments."

parseArgs :: [String] -> IO ()
parseArgs [] = return ()
parseArgs ("hdr":xs) = parseHeader xs
parseArgs (x:xs) = do
  putStrLn x; parseArgs xs

main :: IO ()
main = do
  argv <- getArgs;
  parseArgs argv;
