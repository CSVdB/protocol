module Protocol
    ( client
    ) where

import Protocol.OptParse
import Protocol.StartClient

client :: IO ()
client = do
    (disp, sett) <- getInstructions
    execute disp sett

execute :: Dispatch -> Settings -> IO ()
execute (DispatchStartClient serverLoc) _ = startClient serverLoc
