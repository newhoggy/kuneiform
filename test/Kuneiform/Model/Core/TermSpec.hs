{-# LANGUAGE OverloadedStrings #-}

module Kuneiform.Model.Core.TermSpec (spec) where

import Kuneiform.Model.Core.Term
import Kuneiform.Model.Core.Var

import Test.Hspec

{-# ANN module ("HLint: ignore Redundant do"        :: String) #-}
{-# ANN module ("HLint: ignore Reduce duplication"  :: String) #-}

spec :: Spec
spec = describe "TermSpec" $ do
  describe "shift" $ do
    it "same var" $ do
      let expected = TermVar (Var "x" 10)
      let actual = shift 2 (Var "x" 5) (TermVar (Var "x" 8))
      actual `shouldBe` expected
    it "different var" $ do
      let expected = TermVar (Var "x" 8)
      let actual = shift 2 (Var "y" 5) (TermVar (Var "x" 8))
      actual `shouldBe` expected
