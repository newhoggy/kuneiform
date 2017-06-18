module Kuneiform.Model.Plan.Dependencies
  ( Dependencies(..)
  , cyclicSccs
  , findCycles
  , toHashMap
  ) where

import Data.Hashable
import Data.Maybe
import Kuneiform.Model.Types.ModuleName
import Kuneiform.Validity
import Kuneiform.ValidityOf

import qualified Data.Bimap          as BM
import qualified Data.Graph          as G
import qualified Data.HashMap.Strict as HMS
import qualified Data.List.NonEmpty  as NE

newtype Dependencies = Dependencies
  { dependencies  :: HMS.HashMap ModuleName [ModuleName]
  } deriving (Eq, Show)

instance ValidityOf Dependencies where
  validityOf (Dependencies d) = case NE.nonEmpty (findCycles d) of
    Just neCycles -> Invalid (show <$> neCycles)
    Nothing       -> Valid

cyclicSccs :: [G.SCC a] -> [[a]]
cyclicSccs sccs = catMaybes (go <$> sccs)
  where go (G.AcyclicSCC _) = Nothing
        go (G.CyclicSCC as) = Just as

toHashMap :: (Eq k, Hashable k) => BM.Bimap k v -> HMS.HashMap k v
toHashMap = BM.fold HMS.insert HMS.empty

findCycles :: HMS.HashMap ModuleName [ModuleName] -> [[ModuleName]]
findCycles edges = cyclicSccs (G.stronglyConnComp (triple <$> HMS.toList edges))
  where triple (x, ys) = (x, x, ys)
