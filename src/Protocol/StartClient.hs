module Protocol.StartClient where

import Import hiding (ByteString)

import Protocol.Connection
import Protocol.Process
import Protocol.Reply
import Protocol.Request
import Protocol.ServerLocation

startClient :: ServerLocation -> IO ()
startClient addr = flip reply process =<< getConnection addr

reply :: Connection -> (Request -> IO Reply) -> IO ()
reply conn getReply =
    forever $
    sendConn conn . encodeReply =<<
    getReply . decodeRequest =<< recvConn conn numberOfBytes

numberOfBytes :: Int64
numberOfBytes = 1000
