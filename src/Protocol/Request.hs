module Protocol.Request
    ( Request(..)
    , ValidRequest(..)
    , decodeRequest
    ) where

import Import hiding (ByteString)

import Protocol.Crc

import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy as LB

import Data.Attoparsec.ByteString.Lazy

data Request
    = ValidRequest ValidRequest
    | Other
    deriving (Show, Eq)

data ValidRequest
    = GetStatus
    | GetConfig
    deriving (Show, Eq)

decodeRequest :: ByteString -> Request
decodeRequest bs =
    case maybeResult $ parse parseValidRequest bs of
        Just req -> ValidRequest req
        Nothing -> Other

parseValidRequest :: Parser ValidRequest
parseValidRequest
    -- head
 = do
    sync <- word8 0xe3
    lenM <- anyWord8
    lenL <- anyWord8
    let len = toWord16 lenM lenL
    when (len /= 12) $ fail "The length of the input is incorrect"
    chkM <- anyWord8
    chkL <- anyWord8
    hdrchk <- anyWord8
    when (sync `xor` lenM `xor` lenL `xor` chkM `xor` chkL /= hdrchk) $
        fail "hdrchk failed"
    (bs, rqstType) <-
        match $
        -- intro
         do
            _ <- word8 2
            _ <- word8 0
            _ <- word16 101
            GetStatus <$ word16 0x0001 <|> GetConfig <$ word16 0x0002
    -- tail
    let chk = toWord16 chkM chkL
    let crc = crc16_ANSI $ LB.fromStrict bs
    when (chk /= crc) $ fail "The crc of the input is incorrect"
    _ <- word8 13
    pure rqstType

toWord16 :: Word8 -> Word8 -> Word16
toWord16 wordM wordL = shiftL (fromIntegral wordM) 8 .|. fromIntegral wordL

word16 :: Word16 -> Parser Word16
word16 w = do
    result <- toWord16 <$> anyWord8 <*> anyWord8
    if result == w
        then pure w
        else fail $ mconcat ["The parsed word16 isn't equal to", show w, "."]
