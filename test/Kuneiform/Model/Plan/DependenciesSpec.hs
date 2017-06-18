module Kuneiform.Model.Plan.DependenciesSpec (spec) where

import Kuneiform.Model.Plan.Dependencies
import Kuneiform.Model.Types.ModuleName
import Kuneiform.ValidityOf
import Test.HUnit.Base

import qualified Data.HashMap.Strict as HMS

import Test.Hspec

{-# ANN module ("HLint: ignore Redundant do"        :: String) #-}
{-# ANN module ("HLint: ignore Reduce duplication"  :: String) #-}

spec :: Spec
spec = describe "DependenciesSpec" $ do
  it "Cycling dependencies should be invalid" $ do
    let deps = Dependencies $ HMS.fromList
          [ (ModuleName "1", [ModuleName "2"])
          , (ModuleName "2", [ModuleName "1"])
          ]
    isValid deps `shouldBe` False
  it "No cycling dependencies should be valid" $ do
    let deps = Dependencies $ HMS.fromList
          [ (ModuleName "1", [ModuleName "2"])
          , (ModuleName "2", [ModuleName "3"])
          , (ModuleName "2", [ModuleName "4"])
          , (ModuleName "3", [ModuleName "4"])
          , (ModuleName "4", [])
          ]
    isValid deps `shouldBe` True
