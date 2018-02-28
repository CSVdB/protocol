{-# LANGUAGE RecordWildCards #-}

module Protocol.Connection
    ( getConnection
    , recvConn
    , Connection
    , sendConn
    ) where

import Import hiding (ByteString)

import Protocol.ServerLocation
import Protocol.Socket

import Data.ByteString.Lazy (ByteString)
import Network.Socket hiding (recv)
import Network.Socket.ByteString.Lazy (recv, sendAll)
import System.Exit (die)

newtype Connection =
    Connection Socket
    deriving (Show, Eq)

getSockAddr :: ServerLocation -> IO SockAddr
getSockAddr ServerLocation {..} = do
    let service = Just $ fromMaybe dftServiceName serviceName
    let host = Just $ fromMaybe dftHost hostName
    addrInfos <- getAddrInfo Nothing host service
    case addrInfos of
        [] -> die "This service name and hostname don't give any addresses!"
        (addrInfo:_) -> pure $ addrAddress addrInfo

getConnection :: ServerLocation -> IO Connection
getConnection serverLoc = do
    addr <- getSockAddr serverLoc
    sock <- getSocket
    connect sock addr
    pure $ Connection sock

recvConn :: Connection -> Int64 -> IO ByteString
recvConn (Connection sock) = recv sock

dftServiceName :: ServiceName
dftServiceName = "31415"

dftHost :: HostName
dftHost = "pris.lumi.guide"

sendConn :: Connection -> ByteString -> IO ()
sendConn (Connection conn) = sendAll conn
