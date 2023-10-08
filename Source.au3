#include <File.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; T?o GUI
Local $hGUI = GUICreate("File Sorter by Le Vinh Khang", 300, 120)
GUISetBkColor(0xFFFFFF) ; Ð?t màu n?n cho GUI
Local $inputSourceFolder = GUICtrlCreateInput("", 20, 30, 200, 25)
Local $btnBrowse = GUICtrlCreateButton("Browse", 230, 30, 60, 25)
Local $btnSort = GUICtrlCreateButton("Sort Files", 100, 70, 100, 40)

; Hi?n th? GUI
GUISetState(@SW_SHOW)

While 1
    Local $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit

        Case $btnBrowse
            Local $sourceFolder = FileSelectFolder("Select Source Folder", "")
            If Not @error Then
                GUICtrlSetData($inputSourceFolder, $sourceFolder)
            EndIf

        Case $btnSort
            Local $sourceFolder = GUICtrlRead($inputSourceFolder)
            If FileExists($sourceFolder) Then
                SortFiles($sourceFolder)
                MsgBox(64, "Done", "Files have been sorted.")
            Else
                MsgBox(48, "Error", "Source folder does not exist.")
            EndIf
    EndSwitch
WEnd

Func SortFiles($sourceFolder)
    ; L?y danh sách t?p trong thu m?c ngu?n
    Local $aFiles = _FileListToArray($sourceFolder, "*", 1)

    If @error Then
        MsgBox(48, "Error", "Error listing files in source folder.")
        Return
    EndIf

    For $i = 1 To $aFiles[0]
        Local $file = $aFiles[$i]
        ; Ki?m tra xem có ph?i là thu m?c không
        If Not StringInStr(FileGetAttrib($sourceFolder & "\" & $file), "D") Then
            ; L?y ph?n m? r?ng c?a t?p
            $extension = StringTrimLeft($file, StringInStr($file, ".", 0, -1))
            
            ; T?o thu m?c con n?u nó chua t?n t?i
            $destinationFolder = $sourceFolder & "\" & $extension
            If Not FileExists($destinationFolder) Then
                DirCreate($destinationFolder)
            EndIf
            
            ; Di chuy?n t?p vào thu m?c con
            FileMove($sourceFolder & "\" & $file, $destinationFolder & "\" & $file, 1)
        EndIf
    Next
EndFunc
