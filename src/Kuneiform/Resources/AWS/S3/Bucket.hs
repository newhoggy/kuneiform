module Kuneiform.Resources.AWS.S3.Bucket where

newtype Bucket = Bucket
  { bucketName :: String
  } deriving (Eq, Show)
