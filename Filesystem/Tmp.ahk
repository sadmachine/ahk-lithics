; ==== Script Information ======================================================
; Name .........: Tmp
; Description ..: Handles creation of temporary files
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 09/17/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Tmp.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (09/17/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================

; Directives
#Requires AutoHotkey >=2.0
#Include Path.ahk

class Tmp
{
    static path(namespace, addPath)
    {
        return Path.concat(this._fetchNamespace(namespace), addPath)
    }

    static _fetchNamespace(namespace)
    {
        namespacePath := Path.concat(A_Temp, namespace)
        if ( !InStr(FileExist(namespacePath), 'D') ) {
            DirCreate(namespacePath)
        }
        return namespacePath
    }
}
