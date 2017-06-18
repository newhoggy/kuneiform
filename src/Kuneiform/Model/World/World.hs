{-# LANGUAGE DeriveGeneric              #-}

module Kuneiform.Model.World.World
    ( World(..)
    ) where

import Data.Bimap
import Data.Default
import Data.HashMap.Lazy as HM
import GHC.Generics
import Kuneiform.Model.Types.Name
import Kuneiform.Model.Types.ResourceId
import Kuneiform.Model.Types.ResourceName
import Kuneiform.Model.Types.ModuleName
import Kuneiform.Model.World.Module
import Kuneiform.Orphans

data World = World
  { worldModules      :: HashMap ModuleName Module
  , worldResourceIds  :: Bimap ResourceId Name
  , worldResources    :: HashMap ResourceId ResourceName
  } deriving (Eq, Generic, Show)

instance Default World
