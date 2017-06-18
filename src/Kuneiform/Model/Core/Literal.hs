module Kuneiform.Model.Core.Literal where

import Data.Text

data Literal
  = LitBool Bool
  | LitInt  Int
  | LitText Text
  deriving (Eq, Show)
