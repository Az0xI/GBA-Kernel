import System.Environment -- argv
import System.IO -- IO ()
import Data.Word -- IO Word8
import Foreign.Storable -- Peek
import Foreign.Marshal.Alloc -- MallocBytes
import Numeric


{-
read4Bytes :: Handle -> [IO Word8]
read4Bytes handle =
-}

dumpHeader :: String -> IO ()
dumpHeader x = do
  putStrLn $ "Path: " ++ x;
  handle <- openBinaryFile x ReadMode;
  buffer <- mallocBytes 32;
  content <- hGetBufSome handle buffer 32;
  if content /= 32
    then return ()
    else do
    val <- peek buffer :: IO Word32;
    putStrLn $ showHex val "";
  free buffer;
  hClose handle;


parseHeader :: [String] -> IO ()
parseHeader [] = return ()
parseHeader ("dump":x:_) = dumpHeader x
parseHeader ("gen":x) = return ()
parseHeader _ = putStrLn "Bad arguments."

parseArgs :: [String] -> IO ()
parseArgs ("hdr":xs) = parseHeader xs
parseArgs _ = putStrLn "Arguments do not exist."

main :: IO ()
main = do
  argv <- getArgs;
  parseArgs argv;
  return ();
