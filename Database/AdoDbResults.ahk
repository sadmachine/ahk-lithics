; === Script Information =======================================================
; Name .........: Results
; Description ..: Represents a set of raw results from the database
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DbResults.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
#Include <v2/DataTypes/OrderedMap>

class AdoDbResults
{
    rawResult := ""
    rows := Array()
    columnHeaders := Array()

    __New(adoDbResultSet, outputType := 'Object')
    {
        this.rawResult := adoDbResultSet
        if (outputType = 'object') {
            this._formatAsObject(adoDbResultSet)
        }
        if (outputType = 'csv') {
            this._formatAsCsv(adoDbResultSet)
        }
    }

    _formatAsObject(adoDbResultSet)
    {
        Loop adoDbResultSet.RecordCount {
            outer_index := A_Index
            row := OrderedMap()
            row.CaseSense := false
            for field in adoDbResultSet.Fields {
                if (field.name is ComObjArray) {
                    continue
                }
                if (outer_index == 1) {
                    this.columnHeaders.push(field.name)
                }
                if (field.value is ComObjArray) {
                    row[field.name] := ""
                } else {
                    row[field.name] := field.value
                }
            }
            this.rows.push(row)
            adoDbResultSet.MoveNext()
        }
    }

    _encodeNewLines(string)
    {
        return StrReplace(string, "`r`n", "\r\n")
    }

    _decodeNewLines(string)
    {
        return StrReplace(string, "\r\n", "`r`n")
    }

    count()
    {
        return this.rows.Length
    }

    row(row_num)
    {
        return this.rows[row_num]
    }

    raw()
    {
        return this.rawResult
    }

    empty()
    {
        return this.rows.Length == 0
    }

    data()
    {
        return this.rows
    }

    toString(delimiter := ',')
    {
        output := ''
        for index, header in this.columnHeaders {
            if (A_Index != 1) {
                output .= delimiter
            }
            output .= header
        }

        output .= '`n'

        for index, row in this.rows {
            for key, val in row {
                if (A_Index != 1) {
                    output .= delimiter
                }
                if (val is ComObjArray)
                output .= "[ComObjArray]"
            }
            output .= '`n'
        }
        return output
    }

    display()
    {
        Global
        DisplaySQL := Gui("hwndDisplaySQL +AlwaysOnTop")
        ogcListViewthislvHeaders := DisplaySQL.Add("ListView", "x8 y8 w500 r20 +LV0x4000i", [this.displayHeaders()])
        DisplaySQL.Default()

        for index, row in this.rows
        {
            data := Array()
            for header, record in row
            {
                data.push(record)
            }
            ogcListViewthislvHeaders.Add("", data*)
        }

        Loop this.colCount
        {
            ogcListViewthislvHeaders.ModifyCol(A_Index, "AutoHdr")
        }

        DisplaySQL.Show()
        return DisplaySQL
    }

    displayHeaders()
    {
        output := Array()
        for index, header in this.columnHeaders {
            output.push(StrReplace(header, "_", " "))
        }
        return output
    }
}