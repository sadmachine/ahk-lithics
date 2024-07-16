; ==== Script Information ======================================================
; Name .........: DotEnv
; Description ..: Read and output .env files
; AHK Version ..: 2.* (Unicode 64-bit)
; Start Date ...: 10/24/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DotEnv.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (10/24/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================

; Directives
#Requires AutoHotkey >=2.0

class Config
{
    filename := ""
    data := Map()
    sections := Array()

    __New(filename, failOnNotFound := false) 
    {
        if (!FileExist(this.filename)) {
            if (failOnNotFound) {
                throw Error("File Not Found", A_ThisFunc, this.filename)
            } else {
                return
            }
        }
        this.filename := filename

        this.sections := StrSplit(IniRead(this.filename), '`n')

        for (section in this.sections) {
            this.data[section] := Map(StrSplit(IniRead(this.filename, section), ['=', '`n'])*)
        }
    }

    Call(identifier?, default?)
    {
        if (!IsSet(identifier)) {
            return this.data
        }

        parts := StrSplit(identifier, '.', unset, 2)
        section := parts[1]
        key := parts[2]

        if (!this.data.has(section) || !this.data[section].has(key)) {
            return default ?? ""
        }

        return this._getValue(this.data[section][key])
    }

    _getValue(value)
    {
        if (IsInteger(value)) {
            return Integer(value)
        }

        if (IsFloat(value)) {
            return Float(value)
        }

        if (value == 'true' || value == 'false') {
            return value == 'true'
        }

        return value
    }
}