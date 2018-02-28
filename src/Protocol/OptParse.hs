module Protocol.OptParse
    ( module Protocol.OptParse
    , module Protocol.OptParse.Types
    ) where

import Import

import Protocol.OptParse.Types
import Protocol.ServerLocation

import Network.Socket

import Options.Applicative
import System.Environment

getInstructions :: IO Instructions
getInstructions = do
    (cmd, flags) <- getArguments
    dispatch <- getDispatch cmd flags
    settings <- getSettings flags
    pure (dispatch, settings)

getArguments :: IO Arguments
getArguments = do
    args <- getArgs
    let result = runArgumentsParser args
    handleParseResult result

getSettings :: Flags -> IO Settings
getSettings flg = do
    cfg <- getConfig flg
    getSettingsFromConfig flg cfg

getSettingsFromConfig :: Flags -> Configuration -> IO Settings
getSettingsFromConfig _ _ = pure Settings

getDispatch :: Command -> Flags -> IO Dispatch
getDispatch cmd flags = do
    cfg <- getConfig flags
    getDispatchFromConfig cmd flags cfg

getDispatchFromConfig :: Command -> Flags -> Configuration -> IO Dispatch
getDispatchFromConfig CommandStartClient serverLoc _ =
    pure $ DispatchStartClient serverLoc

getConfig :: Flags -> IO Configuration
getConfig _ = pure Configuration

runArgumentsParser :: [String] -> ParserResult Arguments
runArgumentsParser = execParserPure prefs_ argParser
  where
    prefs_ =
        ParserPrefs
        { prefMultiSuffix = ""
        , prefDisambiguate = True
        , prefShowHelpOnError = True
        , prefShowHelpOnEmpty = True
        , prefBacktrack = True
        , prefColumns = 80
        }

argParser :: ParserInfo Arguments
argParser = info (helper <*> parseArgs) help_
  where
    help_ = fullDesc <> progDesc description
    description = "protocol"

parseArgs :: Parser Arguments
parseArgs = (,) <$> parseCommand <*> parseFlags

parseCommandStartClient :: ParserInfo Command
parseCommandStartClient = info parser modifier
  where
    modifier = fullDesc <> progDesc "List all habits"
    parser = pure CommandStartClient

parseCommand :: Parser Command
parseCommand =
    hsubparser $ mconcat [command "startClient" parseCommandStartClient]

parseServiceName :: Parser (Maybe ServiceName)
parseServiceName =
    option
        (Just <$> str)
        (mconcat
             [ long "serviceName"
             , short 's'
             , help "The service name of the server"
             , value Nothing
             , metavar "STRING"
             ])

parseHostName :: Parser (Maybe HostName)
parseHostName =
    option
        (Just <$> str)
        (mconcat
             [ long "hostname"
             , short 'h'
             , help "The host name of the server"
             , value Nothing
             , metavar "HOSTNAME"
             ])

parseFlags :: Parser Flags
parseFlags = ServerLocation <$> parseServiceName <*> parseHostName
