{-# LANGUAGE DeriveAnyClass   #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell  #-}

module HaskellWorks.Kuneiform.Option.Cmd.S3.Ls
  ( CmdS3Ls(..)
  , parserCmdS3Ls
  , s3LsBucket
  , s3LsDelimiter
  , s3LsPrefix
  , s3LsRecursive
  , s3LsVersions
  , s3LsMaxKeys
  ) where

import Control.Lens
import Data.Monoid
import Data.Text
import HaskellWorks.Kuneiform.Option.Parse
import HaskellWorks.Kuneiform.Optparse.Combinator
import Options.Applicative

data CmdS3Ls = CmdS3Ls
  { _s3LsBucket    :: Text
  , _s3LsPrefix    :: Maybe Text
  , _s3LsVersions  :: Bool
  , _s3LsDelimiter :: Maybe Char
  , _s3LsRecursive :: Bool
  , _s3LsMaxKeys   :: Maybe Int
  } deriving (Show, Eq)

makeLenses ''CmdS3Ls

parserCmdS3Ls :: Parser CmdS3Ls
parserCmdS3Ls = CmdS3Ls
  <$> textOption
      (   long "bucket"
      <>  metavar "S3_BUCKET"
      <>  help "S3 Bucket")
  <*> optional
      ( textOption
        (   long "prefix"
        <>  metavar "S3_PREFIX"
        <>  help "S3 Prefix"))
  <*> switch
      (   long "versions"
      <>  help "Enable version")
  <*> optional
      ( charOption
        (   long "delimiter"
        <>  help "Enable version"))
  <*> switch
      (   long "recursive"
      <>  help "Recursive")
  <*> optional
      ( readOption
        (   long "max-keys"
        <>  help "Maximum number of keys per request"))
