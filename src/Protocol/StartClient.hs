module Protocol.StartClient where

import Import hiding (ByteString)

import Protocol.Socket

import Control.Concurrent
import Data.ByteString.Lazy (ByteString)
import Network.Socket hiding (recv)
import Network.Socket.ByteString.Lazy

startClient :: SockAddr -> IO ()
startClient addr = do
    sock <- getSocketBoundToAddr addr
    listen sock 2
    loop sock

loop :: Socket -> IO ()
loop sock = do
    (conn, _) <- accept sock
    _ <- forkIO $ runConn conn
    loop sock

numberOfBytes :: Int64
numberOfBytes = 1000

runConn :: Socket -> IO ()
runConn conn = do
    message <- recv conn numberOfBytes
    responseBS <- processMessage message
    sendAll conn responseBS
    close conn

processMessage :: ByteString -> IO ByteString
processMessage = undefined
