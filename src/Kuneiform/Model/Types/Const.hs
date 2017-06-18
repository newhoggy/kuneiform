module Kuneiform.Model.Types.Const
    ( Const(..)
    ) where

data Const
  = ConfigInt    Int
  | ConfigString String
  deriving (Eq, Ord, Show)
