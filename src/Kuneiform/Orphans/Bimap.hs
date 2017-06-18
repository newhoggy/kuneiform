{-# OPTIONS_GHC -fno-warn-orphans #-}

module Kuneiform.Orphans.Bimap where

import Data.Bimap
import Data.Default

instance Default (Bimap k v) where
  def = empty
