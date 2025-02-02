module AddRoundKeySpec
  ( runTests
  ) where

import Test.Tasty
import Test.Tasty.HUnit

import AES128.Encryption
import AES128.Decryption
import AES128.ExpandedKey
import AES128.Utils

runTests :: TestTree
runTests = testGroup " AddRoundKey function" [addRoundKeyTest]

key :: Key
key = Key128 [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]

block1 :: Block
block1 = Block [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]

blockAfterFirstADK :: Block
blockAfterFirstADK = Block [0x40, 0xbf, 0xab, 0xf4, 0x06, 0xee, 0x4d, 0x30, 0x42, 0xca, 0x6b, 0x99, 0x7a, 0x5c, 0x58, 0x16]

blockR5AfterMC :: Block
blockR5AfterMC = Block [0xF8, 0x9B, 0x35, 0xEC, 0x4e, 0x40, 0x72, 0x4e, 0x02, 0x5b, 0x00, 0xc7, 0x34, 0xd7, 0xd8, 0x1b]

blockR5AfterADK :: Block
blockR5AfterADK = Block [0x2c, 0x4a, 0xf3, 0x14, 0x32, 0xc3, 0xef, 0xc9, 0xc8, 0xa9, 0xb8, 0x7b, 0x25, 0x2e, 0xcd, 0xa7]

blockR9AfterMC :: Block
blockR9AfterMC = Block [0x17, 0x41, 0xa1, 0x18, 0x91, 0xc9, 0x91, 0x68, 0x8c, 0x36, 0x38, 0x6f, 0x23, 0xad, 0x82, 0xaa]

blockR9AfterADK :: Block
blockR9AfterADK = Block [0xbb, 0x36, 0xc7, 0xeb, 0x88, 0x33, 0x4d, 0x49, 0xa4, 0xe7, 0x11, 0x2e, 0x74, 0xf1, 0x82, 0xc4]

addRoundKeyTest :: TestTree
addRoundKeyTest =
  testCase
    "Checks addRoundKey works correctness" $ do
      assertEqual "Test01" (stateToBlock $ addRoundKey (blockToState block1) key) blockAfterFirstADK
      assertEqual "Test02" (stateToBlock $ addRoundKey (blockToState blockR5AfterMC) (keys !! 4)) blockR5AfterADK
      assertEqual "Test03" (stateToBlock $ addRoundKey (blockToState blockR9AfterMC) (keys !! 8)) blockR9AfterADK
  where
      keys = generateExpandedKey key