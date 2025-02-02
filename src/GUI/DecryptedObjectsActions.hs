module GUI.DecryptedObjectsActions
  ( updateDecDataState
  , getDecFileFromDataState
  , buildDecAddButtons
  , buildDecFileBoxes
  , buildDecTrashButtons
  , buildDecFCButtons
  , buildDecArrowButtons
  , onDecAddButtonsClick
  , onDecTrashButtonsClick
  , onDecFCButtonsClick
  , onDecArrowButtonsClick
  , onDecPasswordStartClick
  , onDecAfterCrypto
  ) where

import GUI.Utils
import GUI.Global
import GUI.CommonObjectsActions

import Graphics.UI.Gtk
import Data.IORef
import Control.Monad.Cont (unless)

updateDecDataState :: DataState -> Int -> File -> DataState
updateDecDataState state id file = state { dec = updateDataState (dec state) id file }

getDecFileFromDataState :: DataState -> Int -> File
getDecFileFromDataState state = getFileFromDataState (dec state)

buildDecAddButtons :: Builder -> IO ButtonsPack
buildDecAddButtons builder = buildButtons builder StringsPack { str1 = "add_decrypt1"
                                                                    , str2 = "add_decrypt2"
                                                                    , str3 = "add_decrypt3"
                                                                    , str4 = "add_decrypt4"
                                                                    , str5 = "add_decrypt5"
                                                                    }

buildDecFileBoxes :: Builder -> IO BoxesPack
buildDecFileBoxes builder = buildBoxes builder StringsPack { str1 = "decrypted_box1"
                                                           , str2 = "decrypted_box2"
                                                           , str3 = "decrypted_box3"
                                                           , str4 = "decrypted_box4"
                                                           , str5 = "decrypted_box5"
                                                           }

buildDecTrashButtons :: Builder -> IO ButtonsPack
buildDecTrashButtons builder = buildButtons builder StringsPack { str1 = "decrypted_box_trash1"
                                                                , str2 = "decrypted_box_trash2"
                                                                , str3 = "decrypted_box_trash3"
                                                                , str4 = "decrypted_box_trash4"
                                                                , str5 = "decrypted_box_trash5"
                                                                }

buildDecFCButtons :: Builder -> IO FCButtonsPack
buildDecFCButtons builder = buildFCButtons builder StringsPack { str1 = "decrypted_box_chooser1"
                                                               , str2 = "decrypted_box_chooser2"
                                                               , str3 = "decrypted_box_chooser3"
                                                               , str4 = "decrypted_box_chooser4"
                                                               , str5 = "decrypted_box_chooser5"
                                                               }

buildDecArrowButtons :: Builder -> IO ButtonsPack
buildDecArrowButtons builder = buildButtons builder StringsPack { str1 = "decrypted_box_arrow1"
                                                                , str2 = "decrypted_box_arrow2"
                                                                , str3 = "decrypted_box_arrow3"
                                                                , str4 = "decrypted_box_arrow4"
                                                                , str5 = "decrypted_box_arrow5"
                                                                }

onDecAddButtonsClick :: Box -> ButtonsPack -> BoxesPack -> IO ()
onDecAddButtonsClick = onAddButtonClick

onDecTrashButtonsClick :: IORef DataState -> Box -> ButtonsPack -> BoxesPack -> ButtonsPack -> FCButtonsPack-> IO ()
onDecTrashButtonsClick refState = onTrashButtonsClick refState updateDecDataState

onDecFCButtonsClick :: IORef DataState -> FCButtonsPack -> IO ()
onDecFCButtonsClick refState = onFCButtonClick refState updateDecDataState

onDecArrowButtonsClick :: IORef DataState -> IORef CurrentArrow 
  -> Dialog -> Entry -> FileChooserDialog -> FileFilter -> Dialog -> Label -> ButtonsPack  -> IO ()
onDecArrowButtonsClick refState refCurrentArrow = onArrowButtonsClick refState refCurrentArrow getDecFileFromDataState True

onDecPasswordStartClick :: Bool -> Int -> Box -> ButtonsPack -> BoxesPack -> EmptiesPack -> IO ()
onDecPasswordStartClick isEncryption position decTable decAddButtonsPack decFileBoxesPack emptiesPack = do
  decAddButton <- getButtonFromPack decAddButtonsPack position
  decFileBox <- getBoxFromPack decFileBoxesPack position
  empty <- getEmptyFromPack emptiesPack position
  unless isEncryption $ do
    pos <- get decTable $ boxChildPosition decAddButton
    replaceInBox decTable (if pos < 0 then castToWidget decFileBox else castToWidget decAddButton) (castToWidget empty)

onDecAfterCrypto :: IORef DataState -> Bool -> Int -> Box -> ButtonsPack -> BoxesPack -> FCButtonsPack -> EmptiesPack -> IO ()
onDecAfterCrypto refState isEncryption position decTable decAddButtonsPack decFileBoxesPack decFCButtonsPack emptiesPack = do
  state <- readIORef refState
  decAddButton <- getButtonFromPack decAddButtonsPack position
  decFileBox <- getBoxFromPack decFileBoxesPack position
  decFCButton <- getFCButtonFromPack decFCButtonsPack position
  empty <- getEmptyFromPack emptiesPack position
  if isEncryption
    then do
      fileChooserSetFilename decFCButton "(No)"
      writeIORef refState $ updateDecDataState state position emptyFile
      replaceInBox decTable (castToWidget decFileBox) (castToWidget decAddButton)
    else do
      fileChooserSetFilename decFCButton $ createFullPath $ getDecFileFromDataState state position
      replaceInBox decTable (castToWidget empty) (castToWidget decFileBox)