module Kuneiform.Model.Types.ConfigName where

newtype ConfigName = ConfigName
  { configNameValue :: String
  } deriving (Eq, Show)
