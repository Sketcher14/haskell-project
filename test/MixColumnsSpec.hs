module MixColumnsSpec
  ( runTests
  ) where

import Test.Tasty
import Test.Tasty.HUnit

import AES128.Encryption
import AES128.Decryption
import AES128.ExpandedKey
import AES128.Utils

runTests :: TestTree
runTests = testGroup " mixColumns, invMixColumns functions" [mixColumnsTest, invMixColumnsTest]

key :: Key
key = Key128 [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]

blockEncR2AfterSR :: Block
blockEncR2AfterSR = Block [0x89, 0xb5, 0x88, 0x4a, 0xc0, 0x56, 0x53, 0x03, 0x2e, 0x38, 0x9b, 0x21, 0x60, 0x4d, 0x12, 0x3c]

blockEncR2AfterMC :: Block
blockEncR2AfterMC = Block [0x0f, 0x31, 0xe9, 0x29, 0x31, 0x9a, 0x35, 0x58, 0xae, 0xc9, 0x58, 0x93, 0x39, 0xf0, 0x4d, 0x87]

blockEncR8AfterSR :: Block
blockEncR8AfterSR = Block [0x98, 0xb5, 0x54, 0x10, 0x09, 0xa9, 0xc5, 0xff, 0x11, 0x14, 0xea, 0x18, 0x7f, 0x3c, 0xfd, 0x3a]

blockEncR8AfterMC :: Block
blockEncR8AfterMC = Block [0xab, 0x05, 0xb5, 0x72, 0xc8, 0xeb, 0x2b, 0x92, 0xec, 0x04, 0xe2, 0xfd, 0x7d, 0x21, 0xec, 0x34]

blockDecR6AfterARK :: Block
blockDecR6AfterARK = Block [0xa0, 0xc5, 0x63, 0x69, 0x6f, 0xb8, 0x84, 0xe4, 0x48, 0x40, 0xbf, 0xbe, 0xe1, 0xd3, 0x2f, 0x0a]

blockDecR6AfterInvMC :: Block
blockDecR6AfterInvMC = Block [0x71, 0x2e, 0x6c, 0x5c, 0x23, 0xd3, 0xbd, 0xfa, 0xe8, 0x31, 0x0d, 0xdd, 0x3f, 0xd6, 0xdf, 0x21]

blockDecR4AfterARK :: Block
blockDecR4AfterARK = Block [0x4d, 0x25, 0xcb, 0x1e, 0xec, 0xf7, 0x16, 0x46, 0x76, 0x58, 0xc7, 0x3b, 0x49, 0xbc, 0xc9, 0xe9]

blockDecR4AfterInvMC :: Block
blockDecR4AfterInvMC = Block [0x91, 0x2c, 0x76, 0x76, 0x3a, 0xf9, 0x56, 0xde, 0xc0, 0xf2, 0xce, 0x2e, 0xa9, 0x3e, 0x98, 0xda]

mixColumnsTest :: TestTree
mixColumnsTest =
  testCase
    "Checks mixColumns works correctness" $ do
      assertEqual "Test01" (stateToBlock $ mixColumns $ blockToState blockEncR2AfterSR) blockEncR2AfterMC
      assertEqual "Test02" (stateToBlock $ mixColumns $ blockToState blockEncR8AfterSR) blockEncR8AfterMC

invMixColumnsTest :: TestTree
invMixColumnsTest =
  testCase
    "Checks invMixColumns works correctness" $ do
      assertEqual "Test01" (stateToBlock $ invMixColumns $ blockToState blockDecR6AfterARK) blockDecR6AfterInvMC
      assertEqual "Test02" (stateToBlock $ invMixColumns $ blockToState blockDecR4AfterARK) blockDecR4AfterInvMC