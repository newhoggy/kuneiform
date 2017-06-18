module Kuneiform.Model.STM
    ( unsafeWorld
    ) where

import Control.Concurrent.STM.TVar
import Data.Default
import Kuneiform.Model.World.World
import System.IO.Unsafe

unsafeWorld :: TVar World
unsafeWorld = unsafePerformIO (newTVarIO def)
{-# NOINLINE unsafeWorld #-}
