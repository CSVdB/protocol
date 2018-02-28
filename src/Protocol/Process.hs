module Protocol.Process where

import Protocol.Reply
import Protocol.Request

process :: Request -> IO Reply
process = undefined

process' :: (ValidRequest -> IO Reply) -> Request -> IO Reply
process' _ Other = pure EmptyMsg
process' f (ValidRequest validReq) = f validReq
