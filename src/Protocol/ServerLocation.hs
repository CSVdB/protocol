module Protocol.ServerLocation where

import Network.Socket

data ServerLocation = ServerLocation
    { serviceName :: Maybe ServiceName
    , hostName :: Maybe HostName
    } deriving (Show, Eq)
