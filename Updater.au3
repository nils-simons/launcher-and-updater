#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\Pictures\icons\gear-blue-md.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <SendMessage.au3>
#include <FileConstants.au3>
#include <Constants.au3>

Sleep(500)

$hGUI = GUICreate("Update", 220, 50)
GUICtrlCreateProgress(10, 10, 200, 20, $PBS_MARQUEE)
_SendMessage(GUICtrlGetHandle(-1), $PBM_SETMARQUEE, True, 50)
GUISetState()

$dir = 'bin'
DirRemove($dir,1)
DirCreate($dir)

$sFilePath = _WinAPI_GetTempFileName(@TempDir)
$hDownload = InetGet("https://update.ggmarket.net/my-program/latest_bin/latest_bin.zip", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
Do
	Sleep(250)
Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

;MsgBox($MB_SYSTEMMODAL, "game", "Complete" & @CRLF & $sFilePath)



$sDestPath = @ScriptDir & "\unzip-bin.zip"
If Not FileWrite($sFilePath, "This is an example of using FileCopy.") Then
    MsgBox($MB_SYSTEMMODAL, "", "An error occurred while writing the file.")
EndIf
$iCopyStatus = FileCopy($sFilePath, $sDestPath, $FC_OVERWRITE + $FC_CREATEPATH)
If $iCopyStatus Then
    ;MsgBox($MB_SYSTEMMODAL, "", "Copy Success")

	Const $sZipFile = @ScriptDir & "\unzip-bin.zip"
	Const $sDestFolder = @ScriptDir & "\bin"
	UnZip($sZipFile, $sDestFolder)
	If @error Then Exit MsgBox ($MB_SYSTEMMODAL,"","Error unzipping file : " & @error)
	FileDelete("unzip-bin.zip")
	Sleep(1000)
	MsgBox($MB_SYSTEMMODAL, "Update", "Update Success!")

Else
    MsgBox($MB_SYSTEMMODAL, "", "Copy Failed")
	Exit
EndIf


Func UnZip($sZipFile, $sDestFolder)
	  If Not FileExists($sZipFile) Then Return SetError (1) ; source file does not exists
	  If Not FileExists($sDestFolder) Then
		If Not DirCreate($sDestFolder) Then Return SetError (2) ; unable to create destination
	  Else
		If Not StringInStr(FileGetAttrib($sDestFolder), "D") Then Return SetError (3) ; destination not folder
	  EndIf
	  Local $oShell = ObjCreate("shell.application")
	  Local $oZip = $oShell.NameSpace($sZipFile)
	  Local $iZipFileCount = $oZip.items.Count
	  If Not $iZipFileCount Then Return SetError (4) ; zip file empty
	  For $oFile In $oZip.items
		$oShell.NameSpace($sDestFolder).copyhere($ofile)
	  Next
EndFunc   ;==>UnZip﻿
