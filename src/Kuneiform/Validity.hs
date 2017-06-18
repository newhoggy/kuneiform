module Kuneiform.Validity where

import Data.List.NonEmpty
import Data.Semigroup

data Validity
  = Valid
  | Invalid { invalidReason :: NonEmpty String }
  deriving (Eq, Show)

instance Monoid Validity where
  mempty = Valid
  mappend (Invalid a) (Invalid b) = Invalid (a <> b)
  mappend _           (Invalid b) = Invalid       b
  mappend (Invalid a) _           = Invalid  a
  mappend _           _           = Valid
