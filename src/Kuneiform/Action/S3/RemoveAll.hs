module Kuneiform.Action.S3.RemoveAll where

import Conduit
import Control.Concurrent.Async
import Control.Concurrent.BoundedChan
import Control.Lens
import Control.Monad
import Data.Monoid
import HaskellWorks.Data.Conduit.Combinator
import Kuneiform.Aws.Core
import Kuneiform.Conduit.Aws.S3
import Kuneiform.Conduit.BoundedChan
import Kuneiform.Option.Cmd.S3.Ls
import Kuneiform.Option.Cmd.S3.RemoveAll
import Network.AWS.S3
import Network.AWS.S3.ListObjectsV
import Network.AWS.S3.ListObjectVersions
import Network.AWS.S3.Types

import qualified Data.Conduit.List as CL

performDeleteObjectVersions :: BucketName -> [ObjectVersion] -> IO DeleteObjectsResponse
performDeleteObjectVersions bucketName ovs = do
  let oids = ovs >>= objectVersionToObjectIdentifier
      req = deleteObjects bucketName $ delete'
          & dQuiet    .~ Just True
          & dObjects  .~ oids
  liftIO $ sendAws req

actionS3RemoveAll :: CmdS3RemoveAll -> IO ()
actionS3RemoveAll opts = do
  let b = opts ^. s3RemoveAllBucket
  let p = opts ^. s3RemoveAllPrefix
  let r = opts ^. s3RemoveAllRecursive

  if opts ^. s3RemoveAllVersions
    then do
      objectVersionChan <- newBoundedChan 20000
      completionChan <- newBoundedChan 100
      let req = listObjectVersions (BucketName b)
              & (lovMaxKeys   .~ (opts ^. s3RemoveAllMaxKeys))
              & (lovDelimiter .~ (opts ^. s3RemoveAllDelimiter))
              & (lovPrefix    .~ (opts ^. s3RemoveAllPrefix))
      let listObjectVersions = runConduit $ s3ListObjectVersionsC r req
              .| boundedChanSink objectVersionChan
      let processObjectVersions = runConduit $ boundedChanSource objectVersionChan
              -- .| effectC (\ov -> forM_ (ov ^. ovKey) (\k -> putStrLn $ "Process: " <> show k))
              .| CL.chunksOf 1000
              -- .| effectC (\_ -> putStrLn "==== Deleting chunk ====")
              .| CL.mapM (async . performDeleteObjectVersions (BucketName b))
              .| boundedChanSink completionChan
      let waitComplete = runConduit $ boundedChanSource completionChan
              .| CL.mapM wait
              .| effectC logDeleteObjectsResponse
              -- .| effectC (\dor -> putStrLn "==== Deleted chunk ====")
              .| effectC (\dor -> putStrLn $ "ResponseStatus: " <> show (dor ^. drsResponseStatus))
              .| sinkNull
      withAsync listObjectVersions $ \a1 ->
        withAsync processObjectVersions $ \a2 ->
          withAsync waitComplete $ \a3 -> do
            _ <- wait a1
            _ <- wait a2
            _ <- wait a3
            return ()
    else do
      objectChan <- newBoundedChan 1000
      let req = listObjectsV (BucketName b)
              & (lMaxKeys     .~ (opts ^. s3RemoveAllMaxKeys))
              & (lDelimiter   .~ (opts ^. s3RemoveAllDelimiter))
              & (lPrefix      .~ (opts ^. s3RemoveAllPrefix))
      let listObjects = do
            putStrLn "Listing"
            runConduit $ s3ListObjectsC r req
              .| effectC (\ov -> putStrLn $ "List: " <> show (ov ^. oKey))
              .| boundedChanSink objectChan
      let processObjects = do
            putStrLn "Processing"
            runConduit $ boundedChanSource objectChan
              .| effectC (\ov -> putStrLn $ "Process: " <> show (ov ^. oKey))
              .| sinkNull
      withAsync listObjects $ \b1 ->
        withAsync processObjects $ \b2 -> do
          _ <- wait b1
          _ <- wait b2
          return ()

  return ()

logDeleteObjectsResponse :: DeleteObjectsResponse -> IO ()
logDeleteObjectsResponse dor = do
  forM_ (dor ^. drsDeleted) $ \d ->
    putStrLn $ "Deleted " <> show (d ^. dKey) <> ":" <> show (d ^. dVersionId)
  forM_ (dor ^. drsErrors) $ \e ->
    putStrLn $ "Could not delete " <> show (e ^. sseKey) <> ":" <> show (e ^. sseVersionId) <> ": " <> show (e ^. sseMessage)
