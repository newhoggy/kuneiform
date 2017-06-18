{-# LANGUAGE OverloadedStrings #-}

module Kuneiform.Model.Core.Var where

import Data.Monoid
import Data.String
import Data.Text
import Data.Text.Buildable (Buildable(..))

-- Bound variable.
data Var = Var
  { varName           :: Text
  , varDebruijnIndex  :: !Int
  }  deriving (Eq, Show)

instance IsString Var where
  fromString str = Var (fromString str) 0

instance Buildable Var where
  build (Var x 0) = build x
  build (Var x n) = build x <> "@" <> build (show n)
