{-# OPTIONS_GHC -fno-warn-orphans #-}

module Kuneiform.Orphans.HashMap where

import Data.Default
import Data.HashMap.Lazy       as HML

instance Default (HashMap k v) where
  def = HML.empty
