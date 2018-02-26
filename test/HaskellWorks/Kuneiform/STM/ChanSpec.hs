module HaskellWorks.Kuneiform.STM.ChanSpec (spec) where

import Control.Concurrent              (threadDelay)
import Control.Concurrent.STM
import Control.Monad.IO.Class
import Data.Hourglass
import HaskellWorks.Hspec.Hedgehog
import HaskellWorks.Kuneiform.STM.Chan
import Hedgehog
import Test.Hspec
import Time.System

{-# ANN module ("HLint: ignore Redundant do"  :: String) #-}

spec :: Spec
spec = describe "HaskellWorks.Kuneiform.STM.ChanSpec" $ do
  it "Can read chan" $ do
    require $ withTests 1 $ property $ do
      _ <- liftIO $ atomically $ newChan 2
      tc1 <- liftIO $ timeCurrent
      liftIO $ threadDelay 2000000
      tc2 <- liftIO $ timeCurrent
      let td = timeDiff tc2 tc1
      td === 2
