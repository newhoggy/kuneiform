{-# LANGUAGE OverloadedStrings #-}

module Kuneiform.Action.Sqs where

import Kuneiform.Action.Sqs.ToKinesis
import Kuneiform.Option.Cmd.Sqs
import Kuneiform.Option.Cmd.Sqs.ToKinesis

actionSqs :: CmdSqsOf -> IO ()
actionSqs (CmdSqsOfHelp       _)    = putStrLn "No SQS help yet"
actionSqs (CmdSqsOfToKinesis  opts) = actionSqsToKinesis opts