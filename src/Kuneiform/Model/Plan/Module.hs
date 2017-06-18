module Kuneiform.Model.Plan.Module where

import Data.Map
import Kuneiform.Model.Core.Term
import Kuneiform.Model.Types.Name

newtype Module = Module
  { modulePlanConfig :: Map Name Term
  } deriving (Eq, Show)
