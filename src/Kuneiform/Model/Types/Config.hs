{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Kuneiform.Model.Types.Config
    ( Config(..)
    ) where

import Data.Default
import Data.HashMap.Lazy
import GHC.Generics
import Kuneiform.Model.Types.Name
import Kuneiform.Orphans ()

newtype Config a = Config (HashMap Name a)
  deriving (Eq, Generic, Show)

instance Default (Config a)
