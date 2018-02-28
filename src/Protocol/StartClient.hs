module Protocol.StartClient where

import Import

import Protocol.ServerLocation

import Network.Socket

startClient :: SockAddr -> IO ()
startClient info = putStrLn "startClient started"
