{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DeriveGeneric              #-}

module Kuneiform.Model.Types
    ( Config(..)
    , Goal(..)
    , KuneiValue(..)
    , Resource(..)
    , State(..)
    , World(..)
    ) where

import Data.Default
import Data.Hashable
import Data.HashMap.Lazy as HM
import Data.Map          as OM
import GHC.Generics
import Kuneiform.Model.Orphans

data KuneiValue
  = KuneiInt    Int
  | KuneiString String
  deriving (Eq, Ord, Show)

newtype ResourceId = ResourceId String
  deriving (Eq, Ord, Generic, Show, Hashable)

data Resource = Resource
  { resourceName :: String
  , resourceType :: String
  } deriving (Eq, Ord, Generic, Show)

instance Hashable Resource

newtype Goal = Goal (HashMap ResourceId KuneiValue)
  deriving (Eq, Generic, Show)

instance Default Goal

newtype State = State (HashMap ResourceId KuneiValue)
  deriving (Eq, Generic, Show)

instance Default State

newtype Config = Config (HashMap ResourceId KuneiValue)
  deriving (Eq, Generic, Show)

instance Default Config

data ResourceRelation = ResourceRelation
  { resourceToId  :: HashMap Resource ResourceId
  , idToResource  :: HashMap ResourceId Resource
  } deriving (Eq, Generic, Show)

instance Default ResourceRelation

data World = World
  { worldConfig     :: Config
  , worldGoal       :: Goal
  , worldState      :: State
  , worldResources  :: ResourceRelation
  } deriving (Eq, Generic, Show)

instance Default World
