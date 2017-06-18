module Kuneiform.ValidityOf where

import Kuneiform.Validity

class ValidityOf a where
  validityOf :: a -> Validity

  isValid :: a -> Bool
  isValid a = case validityOf a of
    Valid     -> True
    Invalid _ -> False
