module Kuneiform.Model.Plan.Plan where

import Data.Monoid
import Kuneiform.Model.Plan.Dependencies
import Kuneiform.Model.Plan.Module
import Kuneiform.Model.Types.ModuleName
import Kuneiform.Validity
import Kuneiform.ValidityOf

import qualified Data.HashMap.Strict  as HMS
import qualified Data.HashSet         as HS
import qualified Data.Map             as M
import qualified Data.List.NonEmpty   as NE

data Plan = Plan
  { planModules       :: M.Map ModuleName Module
  , planDependencies  :: Dependencies
  } deriving (Eq, Show)

instance ValidityOf Plan where
  validityOf (Plan m d) = validityOf d <> dependenciesDefined
    where dependenciesDefined :: Validity
          dependenciesDefined = case NE.nonEmpty (HS.toList (deps `HS.difference` mods)) of
            Nothing             -> Valid
            Just invalidModules -> Invalid (show <$> invalidModules)
          mods = HS.fromList (M.keys m)
          deps = HS.fromList (HMS.keys (dependencies d))
