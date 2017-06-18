{-# LANGUAGE DeriveGeneric              #-}

module Kuneiform.Model.Types.ResourceName
    ( ResourceName(..)
    ) where

import Data.Hashable
import GHC.Generics

data ResourceName = ResourceName
  { resourceName :: String
  , resourceType :: String
  } deriving (Eq, Ord, Generic, Show)

instance Hashable ResourceName
