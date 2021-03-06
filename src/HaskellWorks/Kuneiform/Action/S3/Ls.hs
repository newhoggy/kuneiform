{-# LANGUAGE OverloadedStrings #-}

module HaskellWorks.Kuneiform.Action.S3.Ls where

import Conduit
import Control.Lens
import Data.Monoid
import HaskellWorks.Data.Conduit.Combinator
import HaskellWorks.Kuneiform.Aws.S3
import HaskellWorks.Kuneiform.Conduit.Aws.S3
import HaskellWorks.Kuneiform.Option.Cmd.S3.Ls
import Network.AWS.S3.ListObjectsV
import Network.AWS.S3.ListObjectVersions
import Network.AWS.S3.Types

printS3Entry :: S3Entry -> IO ()
printS3Entry (S3EntryOfObjectVersion ov) = print $ ov  ^. ovKey
printS3Entry (S3EntryOfDeleteMarker dme) = print $ show (dme ^. dmeKey) <> " (delete marker)"

actionS3Ls :: CmdS3Ls -> IO ()
actionS3Ls opts = do
  let b = opts ^. s3LsBucket
  let r = opts ^. s3LsRecursive

  if opts ^. s3LsVersions
    then  let req = listObjectVersions (BucketName b)
                  & (lovMaxKeys   .~ (opts ^. s3LsMaxKeys))
                  & (lovDelimiter .~ (opts ^. s3LsDelimiter))
                  & (lovPrefix    .~ (opts ^. s3LsPrefix))
          in runConduit $ s3ListObjectVersionsOrMarkersC r req
          .| effectC printS3Entry
          .| sinkNull
    else  let req = listObjectsV (BucketName b)
                  & (lMaxKeys     .~ (opts ^. s3LsMaxKeys))
                  & (lDelimiter   .~ (opts ^. s3LsDelimiter))
                  & (lPrefix      .~ (opts ^. s3LsPrefix))
          in runConduit $ s3ListObjectsC r req
          .| effectC print
          .| sinkNull
