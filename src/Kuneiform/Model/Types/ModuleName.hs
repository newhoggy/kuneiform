{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Kuneiform.Model.Types.ModuleName
    ( ModuleName(..)
    ) where

import Data.Hashable

newtype ModuleName = ModuleName String
  deriving (Eq, Ord, Hashable, Show)
