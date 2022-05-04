Attribute VB_Name = "Module11"
Option Explicit
Public Function ValidateRegex(rngCell As Range, strPattern As String) As Boolean
    '*******************************************************************************
    'Purpose: Returns whether or not the value in the cell matches the regular
    '         expression pattern
    'Inputs:
    '   - rngCell: Range containing a single cell whose value to check
    '   - strPattern: Regular expression to match
    'Outputs: True for a match, False otherwise
    '*******************************************************************************
    
    Dim regEx As New RegExp
    
    'Ensure input contains a single cell
    If rngCell.Cells.Count > 1 Then
        Err.Raise vbObjectError + 513, "Input range must be a single cell"
    End If
    
    regEx.Pattern = strPattern
    
    ValidateRegex = regEx.Test(rngCell.Value)
End Function
Public Function ValidateColor(rngCell As Range) As Boolean
    '*******************************************************************************
    'Purpose: Returns whether or not the value in the cell is a valid "(A, R, G, B)"
    '         color
    'Inputs:
    '   - rngCell: Range containing a single cell whose value to check
    'Outputs: True for a valid color, False otherwise
    '*******************************************************************************
    Dim strColorComponentRegex As String: strColorComponentRegex = "(0|[1-9]\d?|1\d{2}|2[0-4]\d|25[0-5])"
    Dim strColorRegex As String: strColorRegex = "^\(" & strColorComponentRegex & ", " & strColorComponentRegex & ", " & strColorComponentRegex & ", " & strColorComponentRegex & "\)$"
    
    ValidateColor = ValidateRegex(rngCell, strColorRegex)
End Function
Public Function ValidateMRN(rngCell As Range) As Boolean
    '*******************************************************************************
    'Purpose: Returns whether or not the value in the cell is a valid CRMC MRN
    '         (three zeroes followed by any six digits)
    'Inputs:
    '   - rngCell: Range containing a single cell whose value to check
    'Outputs: True for a valid MRN, False otherwise
    '*******************************************************************************
    
    ValidateMRN = ValidateRegex(rngCell, "^0{3}\d{6}$")
End Function
Public Function ValidateName(rngCell As Range) As Boolean
    '*******************************************************************************
    'Purpose: Returns whether or not the value in the cell is a valid name in the
    '         format: last comma first, possibly middle or middle initial (with or
    '         without a period
    'Inputs:
    '   - rngCell: Range containing a single cell whose value to check
    'Outputs: True for a valid name, False otherwise
    '*******************************************************************************
    
    ValidateName = ValidateRegex(rngCell, "^[A-Za-z-']+, [A-Za-z-']+([A-Za-z]\.?[A-Za-z-']*)?$")
End Function
Public Function ValidatePatient(rngCell As Range) As Boolean
    '*******************************************************************************
    'Purpose: Returns whether or not the value in the cell is a valid CRMC MRN or
    '         name
    'Inputs:
    '   - rngCell: Range containing a single cell whose value to check
    'Outputs: True for a valid MRN or name, False otherwise
    '*******************************************************************************
    
    ValidatePatient = ValidateMRN(rngCell) Or ValidateName(rngCell)
End Function
