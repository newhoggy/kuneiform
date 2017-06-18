{-# LANGUAGE DeriveGeneric              #-}

module Kuneiform.Model.World.Module
    ( Module(..)
    ) where

import GHC.Generics
import Kuneiform.Model.Types.Config
import Kuneiform.Model.Types.Const
import Kuneiform.Model.World.Goal
import Kuneiform.Model.World.State

data Module = Module
  { moduleConfig     :: Config  Const
  , moduleGoal       :: Goal    Const
  , moduleState      :: State   Const
  } deriving (Eq, Generic, Show)
