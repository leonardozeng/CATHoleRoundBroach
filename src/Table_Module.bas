Attribute VB_Name = "Table_Module"
Option Explicit

'�鹫������
'Dim U#, L#
'If IsNumeric(TextD.Text) Then
'    GetLimitFromTable Val(TextD.Text), ComboDToleranceZone.Text, U, L
'    TextDMax.Text = FixLimit(U / 1000)
'    TextDMin.Text = FixLimit(L / 1000)
'End If


' ***********************************************************************
'   Ŀ�ģ�      ��ù���ȼ�
'
'   ���룺      Tolerance������Ĺ����ַ���
'
'   ���ӣ�      ����"H7"����7
' ***********************************************************************
Public Function GetToleranceGrade(Tolerance As String) As Integer
Dim i As Integer
For i = 1 To Len(Tolerance)
    If IsNumeric(Mid(Tolerance, i, 1)) = True Then
        GetToleranceGrade = Val(Mid(Tolerance, i, Len(Tolerance) - i + 1))
        Exit For
    End If
Next i
End Function

' ***********************************************************************
'   Ŀ�ģ�      ��ù������
'
'   ���룺      Tolerance������Ĺ����ַ���
'
'   ���ӣ�      ����"H7"����"H"
' ***********************************************************************
Public Function GetToleranceCode(Tolerance As String) As String
Dim i As Integer
For i = 1 To Len(Tolerance)
    If IsNumeric(Mid(Tolerance, i, 1)) = True Then
        GetToleranceCode = Mid(Tolerance, 1, i - 1)
        Exit For
    End If
Next i
End Function

' ***********************************************************************
'   Ŀ�ģ�      ��������Զ�������ǰ�������ż�0
'
'   ���룺      Num������ƫ��
'
'   ���ӣ�
' ***********************************************************************
Public Function FixLimit(ByVal Num As Double) As String
FixLimit = Format(Num, "+0.000;-0.000;0")
'Select Case Num
'Case Is < -1
'    FixLimit = "-" & Num
'Case Is < 0
'    FixLimit = "-0" & Mid(Str(Num), 2, Len(Str(Num)) - 1)
'Case Is = 0
'    FixLimit = Num
'Case Is < 1
'    FixLimit = "+0" & Num
'Case Is >= 1
'    FixLimit = "+" & Num
'End Select
End Function
' ***********************************************************************
'   Ŀ�ģ�      �ɹ���������ᾶ�ó����¼��ޣ�δ�꣩
'
'   ���룺      D��ֱ��
'               ToleranceZone�������
'               UpperLimitDeviation�����ô��ݣ��ϼ���ƫ��
'               LowerLimitDeviation�����ô��ݣ��¼���ƫ��
'
'   ���ӣ�
' ***********************************************************************
Public Sub GetLimitFromTable(D As Double, ToleranceZone As String, ByRef UpperLimitDeviation, LowerLimitDeviation As Double)
Dim ToleranceGrade As Integer
Dim ToleranceCode As String
Dim IsStandard As Boolean
Dim IsAxis As Boolean '����
Dim IsES As Boolean '��ƫ��
Dim IsEI As Boolean '��ƫ��
Dim TableName As String

Dim Connection1 As New ADODB.Connection
Dim Recordset1 As New ADODB.Recordset
Dim DatabaseName As String
DatabaseName = App.Path & "\����������ݿ�.mdb"
Connection1.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + DatabaseName

ToleranceCode = GetToleranceCode(ToleranceZone) '�������
ToleranceGrade = GetToleranceGrade(ToleranceZone) '����ȼ�
IsAxis = (Asc(ToleranceCode) >= Asc("a")) And (Asc(ToleranceCode) <= Asc("z")) '�ж����
IsES = (Asc(ToleranceCode) >= Asc("a")) And (Asc(ToleranceCode) <= Asc("h")) '��ƫ��
IsEI = (Asc(ToleranceCode) >= Asc("m")) And (Asc(ToleranceCode) <= Asc("z")) '��ƫ��
IsEI = IsEI Or (Asc(ToleranceCode) >= Asc("A")) And (Asc(ToleranceCode) <= Asc("H")) '��ƫ��
'�᣺js,j,k����
If IsAxis Then 'a~z
    TableName = "��Ļ���ƫ��"
Else
    TableName = "�׵Ļ���ƫ��"
End If

If IsES Then '���Ϊ��ƫ�� a~h
    Recordset1.Open "SELECT " & ToleranceCode & " FROM " & TableName & " WHERE " & D & ">���� AND " & D & "<=��", Connection1, 1, 1 '����Dֵ�����ŵõ�����ƫ��
    UpperLimitDeviation = Recordset1.Fields(ToleranceCode)
    Recordset1.Close
    
    Recordset1.Open "SELECT IT" & ToleranceGrade & " FROM ��׼������ֵ�� WHERE " & D & ">���� AND " & D & "<=��", Connection1, 1, 1  '����Dֵ��IT*�õ���ֵ
    LowerLimitDeviation = UpperLimitDeviation - Val(Recordset1.Fields("IT" & ToleranceGrade))
    Recordset1.Close
    
    If ToleranceGrade >= 12 Then '����12��
        UpperLimitDeviation = UpperLimitDeviation * 1000
        LowerLimitDeviation = LowerLimitDeviation * 1000
    End If
End If

If IsEI Then '���Ϊ��ƫ�� m~z,A~H
    Recordset1.Open "SELECT " & ToleranceCode & " FROM " & TableName & " WHERE " & D & ">���� AND " & D & "<=��", Connection1, 1, 1 '����Dֵ�����ŵõ�����ƫ��
     LowerLimitDeviation = Recordset1.Fields(ToleranceCode)
    Recordset1.Close
    
    Recordset1.Open "SELECT IT" & ToleranceGrade & " FROM ��׼������ֵ�� WHERE " & D & ">���� AND " & D & "<=��", Connection1, 1, 1  '����Dֵ��IT*�õ���ֵ
    UpperLimitDeviation = UpperLimitDeviation + Val(Recordset1.Fields("IT" & ToleranceGrade))
    Recordset1.Close
    
    If ToleranceGrade >= 12 Then '����12��
        UpperLimitDeviation = UpperLimitDeviation * 1000
        LowerLimitDeviation = LowerLimitDeviation * 1000
    End If
End If

End Sub

' ***********************************************************************
'   Ŀ�ģ�      �жϱ��Ƿ���ڣ�δ�ã�
'
'   ���룺
'
'   ���ӣ�
' ***********************************************************************
Public Function TableExist(mdbName As String, TableName As String) As Boolean
Dim TableExit As Boolean
Dim cn As New ADODB.Connection, Rs As New ADODB.Recordset
cn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & mdbName & ";Persist Security Info=False"
On Error Resume Next
Rs.Open "Select * From " & TableName, cn
If Err.Number = 0 Then
    TableExit = True
End If
Err.Clear
Rs.Close
cn.Close
Set Rs = Nothing
Set cn = Nothing
End Function

