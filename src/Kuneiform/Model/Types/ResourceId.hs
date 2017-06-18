{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DeriveGeneric              #-}

module Kuneiform.Model.Types.ResourceId
    ( ResourceId(..)
    ) where

import Data.Hashable
import GHC.Generics

newtype ResourceId = ResourceId String
  deriving (Eq, Ord, Generic, Show, Hashable)
