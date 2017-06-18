{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Kuneiform.Model.Types.Name
    ( Name(..)
    ) where

import Data.Hashable

newtype Name = Name String
  deriving (Eq, Ord, Hashable, Show)
