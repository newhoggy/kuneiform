{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Kuneiform.Model.World.Goal
    ( Goal(..)
    ) where

import Data.Default
import Data.HashMap.Lazy
import GHC.Generics
import Kuneiform.Model.Types.Name
import Kuneiform.Orphans ()

newtype Goal a = Goal (HashMap Name a)
  deriving (Eq, Generic, Show)

instance Default (Goal a)
