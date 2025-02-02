module GUI.EncryptedObjectsActions 
  ( updateEncDataState
  , getEncFileFromDataState
  , buildEncAddButtons
  , buildEncFileBoxes
  , buildEncTrashButtons
  , buildEncFCButtons
  , buildEncArrowButtons
  , onEncAddButtonsClick
  , onEncTrashButtonsClick
  , onEncFCButtonsClick
  , onEncArrowButtonsClick
  , onEncPasswordStartClick
  , onEncAfterCrypto
  ) where

import GUI.Utils
import GUI.Global
import GUI.CommonObjectsActions

import Graphics.UI.Gtk
import Data.IORef
import Control.Monad.Cont (when)

updateEncDataState :: DataState -> Int -> File -> DataState
updateEncDataState state id file = state { enc = updateDataState (enc state) id file }

getEncFileFromDataState :: DataState -> Int -> File
getEncFileFromDataState state = getFileFromDataState (enc state)


buildEncAddButtons :: Builder -> IO ButtonsPack
buildEncAddButtons builder = buildButtons builder StringsPack { str1 = "add_encrypt1"
                                                              , str2 = "add_encrypt2"
                                                              , str3 = "add_encrypt3"
                                                              , str4 = "add_encrypt4"
                                                              , str5 = "add_encrypt5"
                                                              }
                     
buildEncFileBoxes :: Builder -> IO BoxesPack
buildEncFileBoxes builder = buildBoxes builder StringsPack { str1 = "encrypted_box1"
                                                           , str2 = "encrypted_box2"
                                                           , str3 = "encrypted_box3"
                                                           , str4 = "encrypted_box4"
                                                           , str5 = "encrypted_box5"
                                                           }


buildEncTrashButtons :: Builder -> IO ButtonsPack
buildEncTrashButtons builder = buildButtons builder StringsPack { str1 = "encrypted_box_trash1"
                                                                , str2 = "encrypted_box_trash2"
                                                                , str3 = "encrypted_box_trash3"
                                                                , str4 = "encrypted_box_trash4"
                                                                , str5 = "encrypted_box_trash5"
                                                                }
                     
buildEncFCButtons :: Builder -> IO FCButtonsPack
buildEncFCButtons builder = buildFCButtons builder StringsPack { str1 = "encrypted_box_chooser1"
                                                               , str2 = "encrypted_box_chooser2"
                                                               , str3 = "encrypted_box_chooser3"
                                                               , str4 = "encrypted_box_chooser4"
                                                               , str5 = "encrypted_box_chooser5"
                                                               }

buildEncArrowButtons :: Builder -> IO ButtonsPack
buildEncArrowButtons builder = buildButtons builder StringsPack { str1 = "encrypted_box_arrow1"
                                                                , str2 = "encrypted_box_arrow2"
                                                                , str3 = "encrypted_box_arrow3"
                                                                , str4 = "encrypted_box_arrow4"
                                                                , str5 = "encrypted_box_arrow5"
                                                                }

onEncAddButtonsClick :: Box -> ButtonsPack -> BoxesPack -> IO ()
onEncAddButtonsClick = onAddButtonClick

onEncTrashButtonsClick :: IORef DataState -> Box -> ButtonsPack -> BoxesPack -> ButtonsPack -> FCButtonsPack-> IO ()
onEncTrashButtonsClick refState = onTrashButtonsClick refState updateEncDataState

onEncFCButtonsClick :: IORef DataState -> FCButtonsPack -> IO ()
onEncFCButtonsClick refState = onFCButtonClick refState updateEncDataState

onEncArrowButtonsClick :: IORef DataState -> IORef CurrentArrow 
  -> Dialog -> Entry -> FileChooserDialog -> FileFilter -> Dialog -> Label -> ButtonsPack  -> IO ()
onEncArrowButtonsClick refState refCurrentArrow = onArrowButtonsClick refState refCurrentArrow getEncFileFromDataState False

onEncPasswordStartClick ::  Bool -> Int -> Box -> ButtonsPack -> BoxesPack -> EmptiesPack -> IO ()
onEncPasswordStartClick isEncryption position encTable encAddButtonsPack encFileBoxesPack emptiesPack = do
  encAddButton <- getButtonFromPack encAddButtonsPack position
  encFileBox <- getBoxFromPack encFileBoxesPack position
  empty <- getEmptyFromPack emptiesPack position
  when isEncryption $ do
    pos <- get encTable $ boxChildPosition encAddButton
    replaceInBox encTable (if pos < 0 then castToWidget encFileBox else castToWidget encAddButton) (castToWidget empty)

onEncAfterCrypto :: IORef DataState -> Bool -> Int -> Box -> ButtonsPack -> BoxesPack -> FCButtonsPack -> EmptiesPack -> IO ()
onEncAfterCrypto refState isEncryption position encTable encAddButtonsPack encFileBoxesPack encFCButtonsPack emptiesPack = do
  state <- readIORef refState
  encAddButton <- getButtonFromPack encAddButtonsPack position
  encFileBox <- getBoxFromPack encFileBoxesPack position
  encFCButton <- getFCButtonFromPack encFCButtonsPack position
  empty <- getEmptyFromPack emptiesPack position
  if isEncryption
    then do
      fileChooserSetFilename encFCButton $ createFullPath $ getEncFileFromDataState state position
      replaceInBox encTable (castToWidget empty) (castToWidget encFileBox)
    else do
      fileChooserSetFilename encFCButton "(No)"
      writeIORef refState $ updateEncDataState state position emptyFile
      replaceInBox encTable (castToWidget encFileBox) (castToWidget encAddButton)