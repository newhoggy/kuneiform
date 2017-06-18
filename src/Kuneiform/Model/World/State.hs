{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Kuneiform.Model.World.State
    ( State(..)
    ) where

import Data.Default
import Data.HashMap.Lazy
import GHC.Generics
import Kuneiform.Model.Types.Name
import Kuneiform.Orphans ()

newtype State a = State (HashMap Name a)
  deriving (Eq, Generic, Show)

instance Default (State a)
