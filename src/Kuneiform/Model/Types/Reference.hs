module Kuneiform.Model.Types.Reference where

import Kuneiform.Model.Types.ModuleName

data Reference
  = QualifiedReference
    { referenceQualifier  :: ModuleName
    , referenceLocal      :: String
    }
  | LocalReference
    { referenceLocal      :: String
    }
  deriving (Eq, Show)
