Attribute VB_Name = "Module1"
Option Explicit
Sub ReplaceExceptPlaceholders(ByRef rngCell As Range)
    '*******************************************************************************
    'Purpose: Replaces all non-placeholder emails and phone numbers in the cell with
    '         "[redacted]". A placeholder is enclosed in "<>"
    '         (e.g., "<your password>").
    'Input:
    '   - rngCell: The cell to redact information from
    '*******************************************************************************
    Dim strIn As String: strIn = rngCell.Value
    
    'For regex pattern matching
    Dim objRegex As Object  'The RegExp object
    Dim objRegExecuted As Object  'Result of .Execute
    Dim objRegMatch As Object  'A match in the result of .Execute
    Dim strMatch As String  'The string that the match, matches
    
    'Indices of matched string in the cell string
    Dim intStIdx As Integer: intStIdx = 1
    Dim intEndIdx As Integer: intEndIdx = 1
    
    'For each matched email or phone number in the string, if it is not enclosed in "<>", replace it with "[redacted]"
    Set objRegex = CreateObject("VBScript.RegExp")
    With objRegex:
        .Pattern = "(\S+@\S+\.\S+)|([\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6})"  'Match email or phone number
        .MultiLine = True
        .Global = False  'We will not replace all matches at once
        Do While .Test(strIn)  'Continue until there are no more emails or phone numbers
            Set objRegExecuted = .Execute(strIn)
            'Process the first match
            For Each objRegMatch In objRegExecuted
                strMatch = objRegMatch.submatches(0)
                If Len(strMatch) = Len(strIn) Then
                    'Replace the whole value
                    rngCell.Value = "[redacted]"
                    Exit Sub
                Else
                    'Get indices of the "<>", if they exist
                    intStIdx = InStr(intEndIdx, strIn, strMatch, vbTextCompare) - 1  'Index immediately before the matched substring (1-based)
                    intEndIdx = intStIdx + Len(strMatch) + 1  'Index immediately after the matched substring (1-based)
                    If intStIdx <= 0 Or intEndIdx >= Len(strIn) - 1 Then  'Substring comes at the beginning or end of the string, so it can't be a placeholder
                        strIn = .Replace(strIn, "[redacted]")
                    ElseIf Mid(strIn, intStIdx, 1) <> "<" And Mid(strIn, intEndIdx, 1) <> ">" Then  'There is no "<" or no ">", so it's not a placeholder
                        strIn = .Replace(strIn, "[redacted]")
                    End If
                End If
            Next
        Loop
    End With
    rngCell.Value = strIn  'Overwrite the cell value with the redacted string
End Sub
Sub RedactedSpreadsheet()
    '*******************************************************************************
    ' Purpose: Creates a copy of the current document with sensitive info redacted
    '
    ' User provides a list of columns to redact. Each non-empty cell in these
    ' columns is replaced with "[redacted]".
    ' User provides a list of columns to redact ant emails or phoen numbers from.
    ' Any email or phone number in these columns is replaced with "[redacted]".
    ' Any info that would have been redacted but is surrounded by "<>"
    ' (e.g., "<username>") is not redacted.
    ' Of course, not all potentially sensitive info will be redacted! Please check results!
    '*******************************************************************************
    
    'Variables for getting copy filename from user
    Dim copyFilepathPrompt As String: copyFilepathPrompt = "Filename of redacted copy (without extension):"  'User prompt
    Dim copyFilename As String  'Simple filename of redactecd copy (without extension)
    Dim copyFilepath As String  'Absolute filepath to redacted copy
    Dim copyFilepathExists As Boolean: copyFilepathExists = True  'Whether or not a file called `copyFilepath` exists
    Dim fileObj As Object: Set fileObj = CreateObject("Scripting.FileSystemObject")  'To check whether a file called `copyFilepath` exists
    
    'Iteration variables
    Dim sheet As Worksheet  'Iteration variable for worksheets in active workbook
    Dim tbl As ListObject  'Iteration variable for tables on current sheet
    Dim col As Variant  'Iteration variable for column in current table
    Dim cell As Range  'Iteration variable for current cell in the table
    Dim i As Integer  'Iteration variable for cell row index in the current table column
    
    'Variables for user-inputted columns lists
    'Redact all
    Dim colsList As String  'User-inputted, comma-separated list of column names in current table
    Dim colsArr() As String  'User-inputted columns string split into an array of table column names
    Dim colInList As Boolean  'Whether or not the current column is in the user-inputted columns list
    'Redact phone numbers and emails
    Dim colsListPhEmail As String  'User-inputted, comma-separated list of column names in current table
    Dim colsArrPhEmail() As String  'User-inputted columns string split into an array of table column names
    Dim colInListPhEmail As Boolean  'Whether or not the current column is in the user-inputted columns list
    
    'Get unique filename from user
    Do
        copyFilename = InputBox(copyFilepathPrompt)
        If StrPtr(copyFilename) = 0 Then Exit Sub  'Exit macro if user clicked "Cancel"
        copyFilepath = ActiveWorkbook.Path & "\" & copyFilename & ".xlsx"
        copyFilepathExists = fileObj.FileExists(copyFilepath)
        'Change prompt if filename exists
        If copyFilepathExists = True Then
            copyFilepathPrompt = "File '" & copyFilename & "' already exists. Try again:"
        End If
    Loop Until copyFilepathExists = False
    
    'Copy all sheets into a new XLSX file
    ActiveWorkbook.Sheets.Copy
    ActiveWorkbook.SaveAs Filename:=copyFilepath, FileFormat:=xlOpenXMLWorkbook, CreateBackup:=False
    Workbooks.Open copyFilepath
    
    'Iterate over all sheets in the copy
    For Each sheet In ActiveWorkbook.Sheets
        sheet.Activate
        'Iterate over all tables on the sheet
        For Each tbl In sheet.ListObjects
            colsList = InputBox("Enter comma-separated list of columns to redact in table '" & tbl.Name & "':")  'User-inputted, comma-separated list of table columns
            If StrPtr(colsList) = 0 Then GoTo SaveCopy   'Save copy and exit macro if user clicked "Cancel"
            colsListPhEmail = InputBox("Enter comma-separated list of columns in which to replace all phone numbers or emails (not the whole cell) in table '" & tbl.Name & "':")
            If StrPtr(colsListPhEmail) = 0 Then GoTo SaveCopy   'Save copy and exit macro if user clicked "Cancel"
            'Create arrays of column names from user input
            If colsList <> "" Then
                colsArr = Split(colsList, ",")
            End If
            If colsListPhEmail <> "" Then
                colsArrPhEmail = Split(colsListPhEmail, ",")
            End If
            'Iterate over all columns in table
            For Each col In tbl.HeaderRowRange
                If colsList = "" Then
                    colInList = False
                Else
                    colInList = Not IsError(Application.Match(col, colsArr, 0))
                End If
                If colsListPhEmail = "" Then
                    colInListPhEmail = False
                Else
                    colInListPhEmail = Not IsError(Application.Match(col, colsArrPhEmail, 0))
                End If
                For i = 1 To Range(tbl.Name).Rows.Count
                    Set cell = Range(tbl.Name & "[" & col & "]")(i)
                    If colInList And cell.Value <> "" And (Left(cell.Value, 1) <> "<" Or Right(cell.Value, 1) <> ">") Then  'Cell is in column to redact, is nonempty, and is not enclosed in "<>"
                        cell.Value = "[redacted]"
                    ElseIf colInListPhEmail Then
                        ReplaceExceptPlaceholders cell
                    End If
                 Next i
             Next col
        Next tbl
    Next sheet
    
SaveCopy:
    ActiveWorkbook.Save  'Save the redacted copy
End Sub

