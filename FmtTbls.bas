Attribute VB_Name = "NewMacros"
Option Explicit
Sub FmtTbls()
'*******************************************************************************
'Fixes and standardizes formatting of all tables in the active document:
'   - Sets default borders.
'   - Horizontally and vertically center aligns values.
'   - Sets uniform row height.
'   - Center aligns table.
'   - AutoFits column widths.
'   - Disallows the table from spanning multiple pages.
'   - Bolds the first row (header row).
'   - Changes red text to black highlighted text.
'   - Sets the font.
'*******************************************************************************

    'Iteration variables
    Dim tbl As Table
    Dim varBorder As Variant  'Type of table border
    Dim cell As cell
    
    'Iterate over all tables in the active document
    For Each tbl In ActiveDocument.Tables
        tbl.Select
        With Selection
            'Default borders
            For Each varBorder In Array(wdBorderTop, wdBorderLeft, wdBorderBottom, wdBorderRight, wdBorderHorizontal, wdBorderVertical)
                With .Borders(varBorder)
                    .LineStyle = Options.DefaultBorderLineStyle
                    .LineWidth = Options.DefaultBorderLineWidth
                    .Color = Options.DefaultBorderColor
                End With
            Next varBorder
            
            'Center align table and values
            .ParagraphFormat.Alignment = wdAlignParagraphCenter
            .Rows.Alignment = wdAlignRowCenter
            
            'Row height
            .Rows.HeightRule = wdRowHeightExactly
            .Rows.Height = InchesToPoints(0.25)
            
            'Center align values
            .Cells.VerticalAlignment = wdCellAlignVerticalCenter
            
            With .Tables(1)
                'AutoFit columns
                .AutoFitBehavior (wdAutoFitContent)
                
                'Cell padding
                .TopPadding = InchesToPoints(0)
                .BottomPadding = InchesToPoints(0)
                .LeftPadding = InchesToPoints(0.08)
                .RightPadding = InchesToPoints(0.08)
            
                'Misc. cell formatting
                .Spacing = 0
                .AllowPageBreaks = False
                .AllowAutoFit = True
            End With
 
            For Each cell In .Cells
                'Bold first row
                If cell.RowIndex = 1 Then cell.Range.Font.Bold = 1
                
                'Change red text to highlighted
                If cell.Range.Font.TextColor = wdColorRed Then cell.Range.HighlightColorIndex = wdYellow
            Next cell
            
            'Font is black, TNR, size 12
            With .Font
                .TextColor = wdColorBlack
                .Name = "Times New Roman"
                .Size = 12
            End With
        End With
    Next tbl
End Sub
