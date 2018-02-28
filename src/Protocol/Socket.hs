module Protocol.Socket
    ( getSocket
    , getBoundSocket
    , getSocketBoundToAddr
    ) where

import Network.Socket

hostAddr :: HostAddress
hostAddr = iNADDR_ANY

getSocket :: IO Socket
getSocket = do
    sock <- socket AF_INET Stream 0
    setSocketOption sock ReuseAddr 1
    pure sock

getBoundSocket :: IO Socket
getBoundSocket = do
    sock <- getSocket
    bind sock $ SockAddrInet 0 hostAddr
    pure sock

getSocketBoundToAddr :: SockAddr -> IO Socket
getSocketBoundToAddr addr = do
    sock <- getSocket
    bind sock addr
    pure sock
