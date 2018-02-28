{-# LANGUAGE OverloadedStrings #-}

module Protocol.Reply where

import Data.ByteString.Lazy (ByteString)

data Reply
    = ValidReply ValidReply
    | EmptyMsg
    deriving (Show, Eq)

data ValidReply
    = ReplyStatus Status
    | ReplyConfig Config
    deriving (Show, Eq)

data Status =
    Status
    deriving (Show, Eq)

data Config =
    Config
    deriving (Show, Eq)

encodeReply :: Reply -> ByteString
encodeReply EmptyMsg = ""
encodeReply _ = undefined
