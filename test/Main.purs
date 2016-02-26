module Test.Main where

import Prelude
import Control.Monad.Eff
import Control.Monad.Aff.AVar (AVAR())
-- import Control.Monad.Eff.Console

-- main :: forall e. Eff (console :: CONSOLE | e) Unit
-- main = do
--   log "You should add some tests."

import Node.Encoding

import Test.Unit (test, runTest, timeout, TIMER())
import Test.Unit.Assert as Assert
import Test.Unit.Console (TESTOUTPUT())

import Node.FS
import Node.FS.Aff as FS


main ::     forall a. Eff ( fs :: FS
                    , testOutput :: TESTOUTPUT
                    , avar :: AVAR
                    , timer :: TIMER
                    | a
                    )
                Unit

main = runTest do
  test "arithmetic" do
    Assert.assert "2 + 2 should be 4" $ (2 + 2) == 4
    Assert.assertFalse "2 + 2 shouldn't be 5" $ (2 + 2) == 5
    Assert.equal (2 + 2) 4
    Assert.expectFailure "2 + 2 shouldn't be 5" $ Assert.equal (2 + 2) 5
  test "with async IO" do
    fileContents <- FS.readTextFile ASCII "file.txt"
    Assert.equal fileContents "hello here are your file contents"
  test "async operation with a timeout" do
    timeout 100 $ do
      file2Contents <- FS.readTextFile ASCII  "file2.txt"
      Assert.equal file2Contents "can we read a file in 100ms?"