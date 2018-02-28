module Protocol
    ( client
    ) where

import Protocol.OptParse
import Protocol.StartClient

client :: IO ()
client = do
    putStrLn "works"

execute :: Dispatch -> IO ()
execute (DispatchStartClient sockAddr) = startClient sockAddr
