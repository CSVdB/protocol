module Protocol.Request where

import Data.ByteString.Lazy (ByteString)

data Request
    = ValidRequest ValidRequest
    | Other
    deriving (Show, Eq)

data ValidRequest
    = GetStatus
    | Getconfig
    deriving (Show, Eq)

decodeRequest :: ByteString -> Request
decodeRequest = undefined
