module Protocol.Socket
    ( getSocket
    ) where

import Network.Socket

getSocket :: IO Socket
getSocket = do
    sock <- socket AF_INET Stream 0
    setSocketOption sock ReuseAddr 1
    pure sock
