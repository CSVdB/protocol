module Protocol.OptParse.Types where

import Network.Socket

import Protocol.ServerLocation

type Arguments = (Command, Flags)

type Instructions = (Dispatch, Settings)

data Command =
    CommandStartClient
    deriving (Show, Eq)

type Flags = ServerLocation

data Configuration =
    Configuration
    deriving (Show, Eq)

data Settings =
    Settings
    deriving (Show, Eq)

newtype Dispatch =
    DispatchStartClient SockAddr
    deriving (Show, Eq)
