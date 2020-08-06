#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\Pictures\icons\IchBinHanz-logo.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <MsgBoxConstants.au3>

CheckUpdate()

Func CheckUpdate()
	$LatestVersionsUrl = "https://update.ggmarket.net/my-program/latest_version.txt"
	Global $BinaryLatestVersions = InetRead($LatestVersionsUrl)
	Global $StringLatestVersions = BinaryToString($BinaryLatestVersions)
	Global $LocalVersionsFilePath = @ScriptDir & "\bin\version.txt"
	Global $LocalBinVersionsOnGUI = FileRead($LocalVersionsFilePath)
	FileClose($LocalBinVersionsOnGUI)
	If Number($LocalBinVersionsOnGUI) < Number($StringLatestVersions) Then
		Global $isUpdate = 1
	Else
		Global $isUpdate = 0
	EndIf
EndFunc

If Number($isUpdate) == 0 Then
	Launcher()
EndIf

If Number($isUpdate) == 1 Then
	MsgBox($MB_SYSTEMMODAL, "", "New Update available")
	$UpdaterExe = @ScriptDir & "\Updater.exe"
	Run($UpdaterExe , "", @SW_MAXIMIZE)
	Exit
EndIf


Func Launcher()
	$GameExe = @ScriptDir & "\bin\MyProgram.exe"
	Run($GameExe, @ScriptDir & "\bin\", @SW_MAXIMIZE)
	Exit
EndFunc