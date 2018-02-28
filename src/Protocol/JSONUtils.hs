module Protocol.JSONUtils where

import Import

import Control.Monad.IO.Class ()
import Data.Aeson as JSON
import qualified Data.ByteString.Lazy as LB

encode :: (ToJSON a) => a -> ByteString
encode = LB.toStrict . JSON.encode

decode :: (FromJSON a) => ByteString -> Maybe a
decode = JSON.decode . LB.fromStrict
