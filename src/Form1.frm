Option Explicit

Dim Connection1 As New ADODB.Connection
Dim Recordset1 As New ADODB.Recordset
Dim DatabaseName As String
Dim pX As Single, pY As Single
Dim OnEditToothIndex As Integer '���ڱ༭�ĳݺ�

Public Sub SendMsgStr(Msg As String)
TextMemo.Text = Now & ":" & Msg & Chr(13) & Chr(10) & TextMemo.Text
'StatusBar1.Panels(1).Text = Now & ":" & Msg
End Sub

Public Sub SetComboFromStr(ByRef Combo As ComboBox, ByVal S As String) '��ComboBox�������Ƶ���ComboBox��ListIndex
Dim i%
For i = 0 To Combo.ListCount - 1
    If Combo.List(i) = S Then Combo.ListIndex = i
Next i
End Sub

Private Sub SetOptionEnable() '������������������Զ�����û�еļӹ���ʽѡ��
Dim D As Double
Dim i As Integer
Dim StrPreHole As String
Recordset1.Open "SELECT * FROM 6_8Բ���������� WHERE D1<=" & D & " AND " & D & "<=D2 ORDER BY D1"
'ѡ���ʺϵ�ֱ��

OptionReaming.Enabled = False
OptionCounterboring.Enabled = False
OptionDrilling.Enabled = False
OptionBoring.Enabled = False
For i = 1 To Recordset1.RecordCount
'MsgBox AscW(Recordset1.Fields("Ԥ�ƿ׼ӹ���ʽ")) & AscW("��")
  If AscW(Recordset1.Fields("Ԥ�ƿ׼ӹ���ʽ")) = AscW("��") Then
    OptionReaming.Enabled = True
    OptionReaming.Value = True
    StrPreHole = "��"
  End If
  If AscW(Recordset1.Fields("Ԥ�ƿ׼ӹ���ʽ")) = AscW("��") Then
    OptionCounterboring.Enabled = True
    OptionCounterboring.Value = True
    StrPreHole = "��"
  End If
  If AscW(Recordset1.Fields("Ԥ�ƿ׼ӹ���ʽ")) = AscW("��") Then
    OptionDrilling.Enabled = True
    OptionDrilling.Value = True
    StrPreHole = "��"
  End If
  If AscW(Recordset1.Fields("Ԥ�ƿ׼ӹ���ʽ")) = AscW("��") Then
    OptionBoring.Enabled = True
    OptionBoring.Value = True
    StrPreHole = "��"
  End If
  Recordset1.MoveNext
Next i
Recordset1.Close
End Sub

Public Function GetStrFromMachiningMode() As String
If OptionReaming.Value = True Then GetStrFromMachiningMode = OptionReaming.Caption
If OptionCounterboring.Value = True Then GetStrFromMachiningMode = OptionCounterboring.Caption
If OptionDrilling.Value = True Then GetStrFromMachiningMode = OptionDrilling.Caption
If OptionBoring.Value = True Then GetStrFromMachiningMode = OptionBoring.Caption
End Function

Public Sub SetMachiningModeFromStr(ByVal S As String)
If S = OptionReaming.Caption Then OptionReaming.Value = True
If S = OptionCounterboring.Caption Then OptionCounterboring.Value = True
If S = OptionDrilling.Caption Then OptionDrilling.Value = True
If S = OptionBoring.Caption Then OptionBoring.Value = True
End Sub

Public Function GetStrFromSmallerOption() As String
If OptionSmallerGroove.Value = True Then GetStrFromSmallerOption = OptionSmallerGroove.Caption
If OptionNoSmallerGroove.Value = True Then GetStrFromSmallerOption = OptionNoSmallerGroove.Caption
End Function

Public Sub SetSmallerOptionFromStr(ByVal S As String)
If S = OptionSmallerGroove.Caption Then OptionSmallerGroove.Value = True
If S = OptionNoSmallerGroove.Caption Then OptionNoSmallerGroove.Value = True
End Sub

Public Function GetStrFromGrooveOption() As String
Dim i%
For i = 0 To 3
    If OptionGroove(i).Value = True Then GetStrFromGrooveOption = OptionGroove(i).Caption
Next i
End Function

Public Sub SetGrooveOptionFromStr(ByVal S As String)
Dim i%
For i = 0 To 3
    If S = OptionGroove(i).Caption Then OptionGroove(i).Value = True
Next i
End Sub

'������������ʽ��----------------------------------------------------------------------
Private Function GetA0FromFormula() As Double
If OptionReaming.Value = True Or OptionBoring.Value = True Then '�»���
    GetA0FromFormula = 0.005 * ValF(TextD.Text, "����ֱ��D") + 0.05 * Sqr(ValF(TextL0.Text, "��������L0"))
    Else
    If OptionCounterboring.Value = True Then '��
        GetA0FromFormula = 0.005 * ValF(TextD.Text, "����ֱ��D") + 0.075 * Sqr(ValF(TextL0.Text, "��������L0"))
        Else
        If OptionDrilling.Value = True Then '��
        GetA0FromFormula = 0.005 * ValF(TextD.Text, "����ֱ��D") + 0.1 * Sqr(ValF(TextL0.Text, "��������L0"))
        End If
    End If
End If
End Function

'�������������---------------------------------------------------------------
Private Function GetA0FromTable() As String
Dim i, n As Integer
Dim StrPreHole As String 'Ԥ�ƿ׼ӹ���ʽ
Dim ly(100), lydata(100), lymin, lymax As Integer

If OptionReaming.Value = True Then StrPreHole = "��"
If OptionCounterboring.Value = True Then StrPreHole = "��"
If OptionDrilling.Value = True Then StrPreHole = "��"
If OptionBoring.Value = True Then StrPreHole = "��"

If (IsNumeric(TextD.Text)) And (IsNumeric(TextL0.Text)) Then
    Recordset1.Open "SELECT * FROM 6_8Բ���������� WHERE D1<=" & TextD.Text & " AND " & TextD.Text & "<=D2 AND Ԥ�ƿ׼ӹ���ʽ='" & StrPreHole & "'"
    If Recordset1.RecordCount > 0 Then '�м�¼
        'ȡ��A0-------------------------------------------
        n = 0
        For i = 0 To CInt(Recordset1.Fields.Count) - 1 '�����ֶ���
          If (IsNumeric(Recordset1.Fields(i).Name) And Recordset1.Fields(i) > 0) Then '����ֶ���Ϊ�����Ҹ��ֶ���������
            ly(n) = Recordset1.Fields(i).Name
            lydata(n) = Recordset1.Fields(i)
            n = n + 1
          End If
        Next i
        lymin = ly(0)
        lymax = ly(n - 1)
        If Val(TextL0.Text) < lymin Then  'L0��������
          GetA0FromTable = "��������L0 < [Բ����������]����С��ѯֵ = " & lymin & "��"
          Else
            If Val(TextL0.Text) > lymax Then 'L0�߳�����
                GetA0FromTable = "��������L0 > [Բ����������]������ѯֵ = " & lymax & "��"
            Else 'L0���㷶Χ
            For i = 0 To n - 1
             If Val(TextL0.Text) >= ly(i) Then
                GetA0FromTable = lydata(i) '�õ�A0
             End If
            Next i
            End If
        End If
    Else 'û��¼
    GetA0FromTable = "�����ϲ�����������Ԥ�ƿ׼ӹ���ʽ��"
    End If
    Recordset1.Close
Else
    GetA0FromTable = "����ȷ��������ֱ��D����������L0��"
End If
End Function


Private Sub Checkbalpha1_Click()
If Checkbalpha1.Value = 1 Then
    Labelbalpha1_1.Enabled = True
    Labelbalpha1_2.Enabled = True
    Textbalpha1_1.Enabled = True
    Textbalpha1_2.Enabled = True
    Textbalpha1_1.Text = "0.05"
    Textbalpha1_2.Text = "0.05"
Else
    Labelbalpha1_1.Enabled = False
    Labelbalpha1_2.Enabled = False
    Textbalpha1_1.Enabled = False
    Textbalpha1_2.Enabled = False
    Textbalpha1_1.Text = ""
    Textbalpha1_2.Text = ""
End If
End Sub

Private Sub CheckHasChipDividingGroove_Click()
Dim i%
If CheckHasChipDividingGroove.Value = 1 Then
    CommandChipDividingGroove.Enabled = True
    For i = Labelchip.LBound To Labelchip.UBound
        Labelchip(i).Enabled = True
    Next i
    Textnk.Enabled = True
    Textbc.Enabled = True
    Texthc.Enabled = True
    Textrc.Enabled = True
    TextOmegac.Enabled = True
    LabelbcRange.Enabled = True
    LabelhcRange.Enabled = True
    LabelrcRange.Enabled = True
    LabelOmegacRange.Enabled = True
Else
    CommandChipDividingGroove.Enabled = False
    For i = Labelchip.LBound To Labelchip.UBound
        Labelchip(i).Enabled = False
    Next i
    Textnk.Enabled = False
    Textbc.Enabled = False
    Texthc.Enabled = False
    Textrc.Enabled = False
    TextOmegac.Enabled = False
    LabelbcRange.Enabled = False
    LabelhcRange.Enabled = False
    LabelrcRange.Enabled = False
    LabelOmegacRange.Enabled = False
End If
End Sub

Public Sub ComboD1ToleranceZone_GotFocus()
Dim U, L As Double
If IsNumeric(TextD1.Text) Then
    GetLimitFromTable Val(TextD1.Text), ComboD1ToleranceZone.Text, U, L
    TextD1UpperLimit.Text = FixLimit(U / 1000)
    TextD1LowerLimit.Text = FixLimit(L / 1000)
End If
End Sub

Public Sub ComboD2ToleranceZone_GotFocus()
Dim U, L As Double
If IsNumeric(TextD2.Text) Then
    GetLimitFromTable Val(TextD2.Text), ComboD2ToleranceZone.Text, U, L
    TextD2UpperLimit.Text = FixLimit(U / 1000)
    TextD2LowerLimit.Text = FixLimit(L / 1000)
End If
End Sub

Public Sub ComboD3ToleranceZone_GotFocus()
Dim U, L As Double
If IsNumeric(TextD3.Text) Then
    GetLimitFromTable Val(TextD3.Text), ComboD3ToleranceZone.Text, U, L
    TextD3UpperLimit.Text = FixLimit(U / 1000)
    TextD3LowerLimit.Text = FixLimit(L / 1000)
End If
End Sub

Public Sub ComboD4ToleranceZone_GotFocus()
Dim U, L As Double
If IsNumeric(TextD4.Text) Then
    GetLimitFromTable Val(TextD1.Text), ComboD4ToleranceZone.Text, U, L
    TextD4UpperLimit.Text = FixLimit(U / 1000)
    TextD4LowerLimit.Text = FixLimit(L / 1000)
End If
End Sub

Public Sub ComboDToleranceZone_Click()
Dim U#, L#
If IsNumeric(TextD.Text) Then
    GetLimitFromTable Val(TextD.Text), ComboDToleranceZone.Text, U, L
    TextDMax.Text = FixLimit(U / 1000)
    TextDMin.Text = FixLimit(L / 1000)
End If
End Sub

Public Function Checkingh_hz(Optional ByVal ShowMsg As Boolean = True) As Boolean
If Val(Comboh.Text) < Val(LabelhminFormula.Caption) Then '��ͨ��
    Comboh.ForeColor = RGB(255, 0, 0)
    Labelh.ForeColor = RGB(255, 0, 0)
    Checkingh_hz = False
    If ShowMsg = True Then
        TabStrip1.TabIndex = 3
        'MsgBox "���гݡ����ɳ���м�����h=" & Comboh.Text & "<�������hmin=" & LabelhminFormula.Caption
        SendMsgStr "���гݡ����ɳ���м�����h=" & Comboh.Text & "<�������hmin=" & LabelhminFormula.Caption
    End If
Else 'ͨ��
    Comboh.ForeColor = RGB(0, 0, 0)
    Labelh.ForeColor = RGB(0, 0, 0)
    Checkingh_hz = True
End If

If Val(Combohz.Text) < Val(LabelhzminFormula.Caption) Then '��ͨ��
    Combohz.ForeColor = RGB(255, 0, 0)
    Labelhz.ForeColor = RGB(255, 0, 0)
    Checkingh_hz = False
    If ShowMsg = True Then
        TabStrip1.TabIndex = 3
        'MsgBox "���гݡ�У׼����м�����hz=" & Combohz.Text & "<�������hzmin=" & LabelhzminFormula.Caption
        SendMsgStr "���гݡ�У׼����м�����hz=" & Combohz.Text & "<�������hzmin=" & LabelhzminFormula.Caption
    End If
Else 'ͨ��
    Combohz.ForeColor = RGB(0, 0, 0)
    Labelhz.ForeColor = RGB(0, 0, 0)
    Checkingh_hz = True
End If

End Function

Private Sub Combog_Click()
If Combog.ListCount > 1 Then
        Comboh.ListIndex = Combog.ListIndex
        Combol_r.ListIndex = Combog.ListIndex
        ComboU_R.ListIndex = Combog.ListIndex
End If
End Sub

Private Sub Combogz_Click()
If Combogz.ListCount > 1 Then
    Combohz.ListIndex = Combogz.ListIndex
    Combol_rz.ListIndex = Combogz.ListIndex
    ComboU_Rz.ListIndex = Combogz.ListIndex
End If
End Sub

Private Sub Comboh_Change()
Checkingh_hz False
End Sub

Private Sub Comboh_Click()
If Comboh.ListCount > 1 Then
    Combog.ListIndex = Comboh.ListIndex
    Combol_r.ListIndex = Comboh.ListIndex
    ComboU_R.ListIndex = Comboh.ListIndex
End If
End Sub

Private Sub Combohz_Change()
Checkingh_hz False
End Sub

Private Sub Combohz_Click()
If Combohz.ListCount > 1 Then
    Combogz.ListIndex = Combohz.ListIndex
    Combol_rz.ListIndex = Combohz.ListIndex
    ComboU_Rz.ListIndex = Combohz.ListIndex
End If
End Sub

Private Sub Combol_r_Click()
If Combol_r.ListCount > 1 Then
    Comboh.ListIndex = Combol_r.ListIndex
    Combog.ListIndex = Combol_r.ListIndex
    ComboU_R.ListIndex = Combol_r.ListIndex
End If
End Sub

Private Sub Combol_rz_Click()
If Combol_rz.ListCount > 1 Then
    Combohz.ListIndex = Combol_rz.ListIndex
    Combogz.ListIndex = Combol_rz.ListIndex
    ComboU_Rz.ListIndex = Combol_rz.ListIndex
End If
End Sub

Sub RefreshQ_l_l0(Optional ByVal iSendMsg As Boolean, Optional ByVal iReason As Integer) 'ԭ��1���������ͺţ�2����ϵ��
Dim sReason As String
If iReason = 1 Then sReason = "�����ͺ�"
If iReason = 2 Then sReason = "������������ϵ��"
Recordset1.Open "SELECT * FROM ������������Ҫ��� WHERE �����ͺ�='" & ComboModel.Text & "'", Connection1, 1, 1
If IsNumeric(TextQCoefficient.Text) And (LabelQ.Caption <> Str(Val(Recordset1.Fields("��������")) * Val(TextQCoefficient.Text))) Then
    LabelQ.Caption = Val(Recordset1.Fields("��������")) * Val(TextQCoefficient.Text)
    If iSendMsg Then SendMsgStr "���ڸ�����" & sReason & "��������������[Q]�Ѹ���Ϊ" & LabelQ.Caption
End If
If Textl_l0.Text <> Recordset1.Fields("l0") Then
    Textl_l0.Text = Recordset1.Fields("l0")
    If iSendMsg Then SendMsgStr "���ڸ�����" & sReason & "������l0�Ѹ���Ϊ" & Textl_l0.Text
End If
Recordset1.Close
End Sub

Public Sub ComboModel_Click()
RefreshQ_l_l0 True, 1
End Sub

Public Sub ComboToolMaterial_Click()
'����Ӳ������------------------------------------------------------
Recordset1.Open "SELECT * FROM ���ϱ� WHERE �ƺ�='" & ComboToolMaterial.Text & "'", Connection1, 1, 1

If (Recordset1.Fields("HBmin") <> 0) And (Recordset1.Fields("HBmax") <> 0) Then
    LabelToolHBRange.Caption = Recordset1.Fields("HBmin") & "~" & Recordset1.Fields("HBmax")
    TextToolHB.Text = Recordset1.Fields("HBmax")
Else
    LabelToolHBRange.Caption = "�����ݡ�"
    TextToolHB.Text = "�����ݡ�"
End If
Recordset1.Close

'��������Ӧ������--------------------------------------------------
Recordset1.Open "SELECT * FROM ���ϱ� WHERE �ƺ�='" & ComboToolMaterial.Text & "'"
If StrComp(Recordset1.Fields("6_55���"), "���ٸ�") = 0 Then
    TextToolSigmamax1.Text = "350"
    TextToolSigmamax2.Text = "400"
End If
If StrComp(Recordset1.Fields("6_55���"), "�Ͻ��") = 0 Then
    TextToolSigmamax1.Text = "250"
    TextToolSigmamax2.Text = "300"
End If
If Not (Recordset1.Fields("6_55���") <> 0) Then '������
    TextToolSigmamax1.Text = "�����ݡ�"
    TextToolSigmamax2.Text = "�����ݡ�"
End If
LabelToolSigmamaxRange.Caption = TextToolSigmamax1.Text & "~" & TextToolSigmamax2.Text & "MPa"
Recordset1.Close
End Sub

Private Sub ComboU_R_Click()
If ComboU_R.ListCount > 1 Then
    Comboh.ListIndex = ComboU_R.ListIndex
    Combog.ListIndex = ComboU_R.ListIndex
    Combol_r.ListIndex = ComboU_R.ListIndex
End If
End Sub

Private Sub ComboU_Rz_Click()
If ComboU_Rz.ListCount > 1 Then
    Combohz.ListIndex = ComboU_Rz.ListIndex
    Combogz.ListIndex = ComboU_Rz.ListIndex
    Combol_rz.ListIndex = ComboU_Rz.ListIndex
End If
End Sub

Public Sub ComboWorkpieceMaterial_Click() 'ˢ�¹�������
Recordset1.Open "SELECT * FROM ���ϱ� WHERE �ƺ�=" & "'" & ComboWorkpieceMaterial.Text & "'"

If (Recordset1.Fields("����ǿ������") <> 0) And (Recordset1.Fields("����ǿ������") <> 0) Then '��ÿ���ǿ������
    LabelWpSigmabRange.Caption = Recordset1.Fields("����ǿ������") & "~" & Recordset1.Fields("����ǿ������")
    TextWpSigmab.Text = (Recordset1.Fields("����ǿ������") + Recordset1.Fields("����ǿ������")) / 2
Else
    LabelWpSigmabRange.Caption = "�����ݡ�"
    TextWpSigmab.Text = "�����ݡ������вⶨ��"
End If

TextGammaoDeg.Text = Recordset1.Fields("6_18������ǰ��")

Recordset1.Close
End Sub

Private Sub Command1_Click()
MsgBox Format(0.152587, "0.####")
'Picture1(0).BackColor = Picture1(0).BackColor + 1
'Command1.Caption = Val(Command1.Caption) + 1
End Sub

Public Sub CommandCalcFinishingTeethD_Click()
Dim Dmax#, DZone#
DZone = Val(TextDMax.Text) - Val(TextDMin.Text)
Dmax = Val(TextD.Text) + Val(TextDMax.Text)
Recordset1.Open "SELECT * FROM 1_1_24����ʱ�׵������� WHERE �׵�ֱ������1<=" & DZone & " AND " & DZone & "<=�׵�ֱ������2"
TextFinishingTeethD.Text = Dmax + Recordset1.Fields("������")
LabelFinishingTeethDDelta.Caption = "=" & Dmax & "+" & Fix0(Recordset1.Fields("������"))
Recordset1.Close
End Sub

Public Sub CommandCalcLength_Click()
TextToolLength.Text = Val(TextL1.Text) + Val(TextL2.Text) + Val(Textl_l0.Text) + Val(Textl_l3.Text) + _
    Val(Textl_l.Text) + Val(Textlg.Text) + Val(Textlz.Text) + Val(Textl_l4.Text)
LabelCalcLength.Caption = "= " & TextL1.Text & " + " & TextL2.Text & " + " & Textl_l0.Text & " + " & Textl_l3.Text & " + " & _
    Textl_l.Text & " + " & Textlg.Text & " + " & Textlz.Text & " + " & Textl_l4.Text
End Sub

Public Sub CommandCalcN_Click()
Dim D As Double
Dim n1, n2, n21, n22, n3, n4 As Integer
Dim A, af As Double

If IsNumeric(TextD.Text) Then
    D = Val(TextD.Text)
    A = ValF(TextA0.Text, "��������A", 1)
    af = ValF(Textaf.Text, "������af", 1)
    If GetToleranceGrade(ComboDToleranceZone.Text) <= 8 Then
        Select Case af '�趨n2.caption
        Case Is <= 0.15
            Labeln2.Caption = "3~5": n21 = 3: n22 = 5: n2 = 3
        Case Is <= 0.3
            Labeln2.Caption = "5~7": n21 = 5: n22 = 7: n2 = 5
        Case Is > 0.3
            Labeln2.Caption = "6~8": n21 = 6: n22 = 8: n2 = 6
        End Select
        Labeln3.Caption = "4~7": n3 = 4 '�趨n3.caption
        Labeln4.Caption = "5~7": n4 = 5 '�趨n4.caption
    Else
        If af <= 0.2 Then '�趨n2.caption
            Labeln2.Caption = "2~3": n21 = 2: n22 = 3: n2 = 2
        Else
            Labeln2.Caption = "3~5": n21 = 3: n22 = 5: n2 = 3
        End If
        Labeln3.Caption = "2~5": n3 = 2 '�趨n3.caption
        Labeln4.Caption = "4~5": n4 = 4 '�趨n4.caption
    End If
    Labeln1.Caption = Int(A / (2 * af) + 2 - n21) & "~" & Int(A / (2 * af) + 5 - n22) '�趨n1.caption
    n1 = Int(A / (2 * af) + 2 - n21)
    
    Textn1.Text = n1
    Textn2.Text = n2
    Textn3.Text = n3
    Textn4.Text = n4
End If
End Sub

Public Sub CommandChipDividingGroove_Click()
Recordset1.Open "SELECT * FROM 1_1_19�����ķ�м�۳ߴ� WHERE D1<=" & TextD.Text & " AND " & TextD.Text & "<=D2", Connection1, 1, 1
LabelbcRange.Caption = Fix0(Recordset1.Fields("bc1")) & "~" & Fix0(Recordset1.Fields("bc2"))
LabelhcRange.Caption = Fix0(Recordset1.Fields("hc1")) & "~" & Fix0(Recordset1.Fields("hc2"))
LabelrcRange.Caption = Fix0(Recordset1.Fields("rc1")) & "~" & Fix0(Recordset1.Fields("rc2"))
LabelOmegacRange.Caption = "45��~60��"
Textnk.Text = Fix0(Recordset1.Fields("nk"))
Textbc.Text = Fix0(Recordset1.Fields("bc1"))
Texthc.Text = Fix0(Recordset1.Fields("hc1"))
Textrc.Text = Fix0(Recordset1.Fields("rc1"))
TextOmegac.Text = "45"
Recordset1.Close
End Sub

Public Sub InsertTooth(NumClass As Integer)
Dim n%, i%, nCount%
If ListViewTeeth.ListItems.Count > 0 Then
    n = ListViewTeeth.SelectedItem.Index
    nCount = ListViewTeeth.ListItems.Count + 1
    ListViewTeeth.ListItems.Add nCount
    ListViewTeeth.ListItems(nCount).Text = nCount
    
    For i = ListViewTeeth.ListItems.Count To n + 1 Step -1
    'MsgBox i
        ListViewTeeth.ListItems(i).SubItems(1) = ListViewTeeth.ListItems(i - 1).SubItems(1)
        ListViewTeeth.ListItems(i).SubItems(2) = ListViewTeeth.ListItems(i - 1).SubItems(2)
        ListViewTeeth.ListItems(i).SubItems(3) = ListViewTeeth.ListItems(i - 1).SubItems(3)
    Next i
    ListViewTeeth.ListItems(n).Text = n
Else
    ListViewTeeth.ListItems.Add 1
    ListViewTeeth.ListItems.Item(1).Text = "1"
    n = 1
End If

Select Case NumClass
Case Is = 1:
    ListViewTeeth.ListItems(n).SubItems(1) = "���г�"
    ListViewTeeth.ListItems(n).SubItems(2) = ""
    ListViewTeeth.ListItems(n).SubItems(3) = "��0.005"
    Textn1.Text = Val(Textn1.Text) + 1
Case Is = 2:
    ListViewTeeth.ListItems(n).SubItems(1) = "���ɳ�"
    ListViewTeeth.ListItems(n).SubItems(2) = ""
    ListViewTeeth.ListItems(n).SubItems(3) = "��0.005"
    Textn2.Text = Val(Textn2.Text) + 1
Case Is = 3:
    ListViewTeeth.ListItems(n).SubItems(1) = "���г�"
    ListViewTeeth.ListItems(n).SubItems(2) = ""
    ListViewTeeth.ListItems(n).SubItems(3) = "-0.005"
    Textn3.Text = Val(Textn3.Text) + 1
Case Is = 4:
    ListViewTeeth.ListItems(n).SubItems(1) = "У׼��"
    ListViewTeeth.ListItems(n).SubItems(2) = ""
    ListViewTeeth.ListItems(n).SubItems(3) = "-0.005"
    Textn4.Text = Val(Textn4.Text) + 1
End Select
End Sub

Public Sub DeleteOneTooth()
Dim n%, i%
If ListViewTeeth.ListItems.Count > 0 Then
    n = ListViewTeeth.SelectedItem.Index
    Select Case ListViewTeeth.ListItems(n).SubItems(1)
    Case Is = "���г�":
        Textn1.Text = Val(Textn1.Text) - 1
    Case Is = "���ɳ�":
        Textn2.Text = Val(Textn2.Text) - 1
    Case Is = "���г�":
        Textn3.Text = Val(Textn3.Text) - 1
    Case Is = "У׼��":
        Textn4.Text = Val(Textn4.Text) - 1
    End Select
    ListViewTeeth.ListItems.Remove (n)
    For i = n To ListViewTeeth.ListItems.Count
        ListViewTeeth.ListItems(i).Text = i
    Next i
End If
End Sub

Private Sub CommandDeleteOneTooth_Click()
DeleteOneTooth
End Sub

Private Sub CommandEditTooth_Click()
EditTooth
End Sub

Private Sub CommandInsertTooth_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
mnuDelete.Visible = False
mnuEditTooth.Visible = False
Form1.PopupMenu mnuTooth
mnuDelete.Visible = True
mnuEditTooth.Visible = True
End Sub

Private Sub CommandTooth_Click() '��Ƶ���ֱ��
Dim D, Dn4Final, Dnow#, Dn1Final#, Dn2Final#
Dim n1, n2, n21, n22, n3, n4 As Integer
Dim A, af, afnow As Double
Dim Sn2#, dd2#, Sn3#, dd3#
Dim i%, j#

If IsNumeric(TextD.Text) Then
    D = Val(TextD.Text)
    Dn4Final = Val(TextFinishingTeethD.Text)
    
    A = ValF(TextA0.Text, "��������A", 1)
    af = ValF(Textaf.Text, "������af", 1)
    
    n1 = Val(Textn1.Text)
    If n1 <= 1 Then n1 = 1
    n2 = Val(Textn2.Text)
    n3 = Val(Textn3.Text)
    n4 = Val(Textn4.Text)
    
    afnow = af * 2
    
    '��ʼ�������ֱ��-----------------------------------------------------------------------------
    ListViewTeeth.ListItems.Clear
    For i = 1 To n1
        ListViewTeeth.ListItems.Add , , i
        ListViewTeeth.ListItems(i).SubItems(1) = "���г�"
        Dnow = D - A + i * afnow
        ListViewTeeth.ListItems(i).SubItems(2) = Dnow
        ListViewTeeth.ListItems(i).SubItems(3) = "��0.005"
    Next i
    
    If n2 <> 0 Then
        Dn1Final = Dnow
        Sn2 = D - Dn1Final
        dd2 = Sn2 / AriSquSum(1, n2)
        j = n2 - 1
        For i = n1 + 1 To n1 + n2
            ListViewTeeth.ListItems.Add , , i
            ListViewTeeth.ListItems(i).SubItems(1) = "���ɳ�"
            If Dnow + UpTo5(j * dd2) < D Then Dnow = Dnow + UpTo5(j * dd2)
            ListViewTeeth.ListItems(i).SubItems(2) = Dnow
            ListViewTeeth.ListItems(i).SubItems(3) = "��0.005"
            j = j - 1
        Next i
    End If
    
    Dn2Final = Dnow
    Sn3 = Dn4Final - Dn2Final
    'dd3 = Sn3 / AriSquSum(1, n3) '�ݼ��㷨
    dd3 = Sn3 / (n3 + 1) 'ƽ���㷨
    j = 0
    
    For i = n1 + n2 + 1 To n1 + n2 + n3 - 1
        'j = j + 1'�ݼ��㷨
        ListViewTeeth.ListItems.Add , , i
        ListViewTeeth.ListItems(i).SubItems(1) = "���г�"
        'If Dnow + UpTo5(j * dd3) <= Dn4Final Then Dnow = Dnow + UpTo5(j * dd3) '�ݼ��㷨
        If Dnow + UpTo5(dd3) <= Dn4Final Then Dnow = Dnow + UpTo5(dd3)  'ƽ���㷨
        ListViewTeeth.ListItems(i).SubItems(2) = Dnow
        ListViewTeeth.ListItems(i).SubItems(3) = "-0.005"
    Next i
    
    '���һ�����г�ֱ��Ӧ����У׼��ֱ��
    ListViewTeeth.ListItems.Add , , n1 + n2 + n3
    ListViewTeeth.ListItems(i).SubItems(1) = "���г�"
    ListViewTeeth.ListItems(i).SubItems(2) = Dn4Final
    ListViewTeeth.ListItems(i).SubItems(3) = "-0.005"
    
    For i = n1 + n2 + n3 + 1 To n1 + n2 + n3 + n4
        ListViewTeeth.ListItems.Add , , i
        ListViewTeeth.ListItems(i).SubItems(1) = "У׼��"
        ListViewTeeth.ListItems(i).SubItems(2) = Dn4Final '���ճߴ�
        ListViewTeeth.ListItems(i).SubItems(3) = "-0.005"
    Next i
End If
End Sub

Private Sub CommandBuild_Click()
Form1.Hide
Form2.Show
MakeMeOnTop Form2.hWnd

oCreateRoundBroach

Unload Form2
Form1.Show
End Sub

Public Sub SetCommandA_Click()
End Sub

Public Sub CommandA_Click() '������������
LabelA0Formula.Caption = Fix0(Math.Round(GetA0FromFormula, 2))
LabelA0Table.Caption = Fix0(GetA0FromTable)
TextA0 = Fix0(Math.Round(GetA0FromFormula, 1))
LabelPreHoleD.Caption = Val(TextD.Text) - Val(TextA0.Text)
End Sub

Public Sub Commandaf_Click() '���ó�����
If IsNumeric(TextD.Text) Then
    Recordset1.Open "SELECT * FROM 6_56Բ�����ĳ����� WHERE D1<=" & TextD.Text & " AND " & TextD.Text & "<D2", Connection1, 1, 1
    LabelafRange.Caption = Fix0(Recordset1.Fields("�ֲ�ʽMin")) & "~" & Fix0(Recordset1.Fields("�ֲ�ʽMax"))
    LabelMRange.Caption = Fix0(20 * (Val(Recordset1.Fields("�ֲ�ʽMin")) - 0.01) + 1.1) & "~" & Fix0(20 * (Val(Recordset1.Fields("�ֲ�ʽMax")) - 0.01) + 1.1)
    Textaf.Text = Fix0(Recordset1.Fields("�ֲ�ʽMax"))
    Recordset1.Close
Else
    LabelafRange.Caption = "���趨����ֱ��D��"
    Textaf.Text = ""
End If
If IsNumeric(Textaf.Text) Then TextM.Text = Fix0(20 * (Val(Textaf.Text) - 0.01) + 1.1)
End Sub

Public Sub CommandKmin_Click() '����Kmin
Dim Sigmab As Double
Dim af As Double
Dim HasMaterial As Boolean
Dim StrSQL, StrFieldsName As String

Recordset1.Open "SELECT * FROM ���ϱ� WHERE �ƺ�=" & "'" & ComboWorkpieceMaterial.Text & "'", Connection1, 1, 1

If StrComp(Recordset1.Fields("6_17���"), "��") = 0 Then
    If IsNumeric(TextWpSigmab.Text) Then 'ͨ������ǿ��ѡ������
        Sigmab = Val(TextWpSigmab.Text)
        Select Case Sigmab
        Case Is < 400
            StrFieldsName = "�ֿ���ǿ��less400"
            StrSQL = "SELECT af," & StrFieldsName & " FROM 6_17�ֲ�ʽ��������мϵ��"
        Case Is <= 700
            StrFieldsName = "�ֿ���ǿ��in400to700"
            StrSQL = "SELECT af," & StrFieldsName & " FROM 6_17�ֲ�ʽ��������мϵ��"
        Case Is > 700
            StrFieldsName = "�ֿ���ǿ��more700"
            StrSQL = "SELECT af," & StrFieldsName & " FROM 6_17�ֲ�ʽ��������мϵ��"
        End Select
        
    Else
      MsgBox "���趨��������ǿ�Ȧ�b�ⶨֵ��"
    End If
Else
    StrFieldsName = ComboWorkpieceMaterial.Text
    StrSQL = "SELECT af," & StrFieldsName & " FROM 6_17�ֲ�ʽ��������мϵ��"
End If
Recordset1.Close

If StrSQL <> 0 Then '�иý�������
    If IsNumeric(Textaf.Text) Then
        af = Val(Textaf.Text)
        Select Case af
        Case Is < 0.03:
            StrSQL = StrSQL & " WHERE af='aflessp03'"
        Case Is <= 0.07
            StrSQL = StrSQL & " WHERE af='afinp03top07'"
        Case Is > 0.07
            StrSQL = StrSQL & " WHERE af='afmorep07'"
        End Select
        Recordset1.Open StrSQL, Connection1, 1, 1
        TextKmin.Text = Recordset1.Fields(StrFieldsName)
        Recordset1.Close
    Else
        MsgBox "���趨������af��"
    End If
End If
End Sub

Public Sub Commandp_Click() '����ݾ�
Dim pFormula#, pzFormula#
pFormula = ValF(TextM, "Mֵ") * Sqr(ValF(TextL0.Text, "��������L0"))
LabelpFormula.Caption = "p����ֵ:" & Math.Round(pFormula, 2)

Textp.Text = Math.Round(pFormula, 0)

pzFormula = 0.7 * ValF(Textp.Text, "�ݾ�p����ֵ")
LabelpzFormula.Caption = "pz����ֵ:" & pzFormula

Textpz.Text = Math.Round(pzFormula, 0)
End Sub

Public Sub CommandCheck_Click() '����У��
Dim FieldName As String
Dim HB, Fq, Fmax, D2, l_d, l_dmin, Amin, ze, Q, BroachSigma, ToolSigmamax1, ToolSigmamax2 As Double
Dim PassSigma, PassFmax As Boolean
Dim ResultSigma, ResultFmax As String
'����ze------------------------------------------------------------------------
ze = Fix(ValF(TextL0.Text, "��������L0") / ValF(Textp.Text, "�ݾ�p", 1) + 1)
Labelze.Caption = ze

'ˢ��Q------------------------------------------------------------------------
ComboModel_Click
Q = ValF(LabelQ.Caption, "������������[Q]")
LabelQ.Caption = Q & "N"

'���в��Ϸ���----------------------------------------------------------------------
Recordset1.Open "SELECT * FROM ���ϱ� WHERE �ƺ�='" & ComboToolMaterial.Text & "'"

HB = ValF(TextToolHB.Text, "����Ӳ�ȲⶨֵHB")
If StrComp(Recordset1.Fields("6_55���"), "̼��") = 0 Then
    If HB <= 197 Then
        FieldName = "̼��lessequ197"
    Else
        If HB <= 229 Then
            FieldName = "̼��in197to229"
        Else
            FieldName = "̼��more229"
        End If
    End If
End If
If (StrComp(Recordset1.Fields("6_55���"), "�Ͻ��") = 0) Or (StrComp(Recordset1.Fields("6_55���"), "���ٸ�") = 0) Then
    If HB <= 197 Then
        FieldName = "�Ͻ��lessequ197"
    Else
        If HB <= 229 Then
            FieldName = "�Ͻ��in197to229"
        Else
            FieldName = "�Ͻ��more229"
        End If
    End If
End If
If StrComp(Recordset1.Fields("6_55���"), "������") = 0 Then
    If HB <= 180 Then
        FieldName = "������lessequ180"
    Else
        FieldName = "������more180"
    End If
End If
If StrComp(Recordset1.Fields("6_55���"), "�ɶ�����") = 0 Then
    FieldName = "�ɶ�����"
End If
Recordset1.Close

'���6-48�õ�F'(Fq)��У��-----------------------------------------------------------
Recordset1.Open "SELECT * FROM 6_48������λ�����������ϵ������� WHERE af=" & ValF(Textaf.Text, "������af", 0)

If Len(FieldName) > 0 Then '���Ϸ�����ȷ
    If Recordset1.RecordCount > 0 Then '��af,���߲��϶�ӦF'����
        '����Fq-----------------------------------
        Fq = Recordset1.Fields(FieldName)
        LabelFq.Caption = Fq & "N/mm"
        '����Fmax------------------------------
        Fmax = 3.33 * Fq * ValF(TextD.Text, "����ֱ��D") * ze
        LabelFmax.Caption = Fmax & "N"

        '�ж���С����--------------------------------------------------------------------------
        l_d = ValF(TextD.Text, "����ֱ��D") - ValF(TextA0.Text, "��������A") - 2 * ValF(Comboh.Text, "��м�����h")
        D2 = ValF(TextD2.Text, "ǰ��D2")
        If (D2 <> 0) And (D2 < l_d) Then 'ǰ��D2��С
            l_dmin = D2
            Labell_dmin.Caption = "ǰ��D2=" & D2 & "mm<" & "��һ�ݲ۵�ֱ��d=" & l_d & "mm"
        Else
            If (D2 <> l_d) Then '���߲�����-��һ�ݲ۵�ֱ����С
                l_dmin = l_d
                Labell_dmin.Caption = "��һ�ݲ۵�ֱ��d=" & l_d & "mm<" & "ǰ��D2=" & D2 & "mm"
            Else '�������
                l_dmin = l_d
                Labell_dmin.Caption = "ǰ��D2=" & D2 & "mm=" & "��һ�ݲ۵�ֱ��d=" & l_d & "mm"
            End If
        End If
        '����Amin-------------------------------
        Amin = 3.14 * ((l_dmin / 2) ^ 2)
        LabelAmin.Caption = Math.Round(Amin, 2) & " mm^2"
        '��������Ӧ��------------------------------
        ToolSigmamax1 = ValF(TextToolSigmamax1.Text, "���߲�������Ӧ��[��]")
        ToolSigmamax2 = ValF(TextToolSigmamax2.Text, "���߲�������Ӧ��[��]")
        LabelToolSigmamaxRange.Caption = ToolSigmamax1 & "~" & ToolSigmamax2 & "MPa"
        '������Ӧ��------------------------------
        If Amin <> 0 Then
            BroachSigma = Fmax / Amin
            LabelBroachSigma.Caption = Math.Round(BroachSigma, 2) & "MPa"
        End If
        'У��--------------------------------------------------------------------------------------
        If (Fmax <= Q) Then
            PassFmax = True 'ͨ����������
            LabelCheckF.Caption = "ͨ��"
            LabelCheckF.ForeColor = RGB(0, 0, 0)
        Else
            PassFmax = False '��ͨ����������
            ResultFmax = "Fmax=" & LabelFmax.Caption & ">[Q]=" & LabelQ.Caption  '��ͨ��ԭ��
            LabelCheckF.Caption = "δͨ����" & ResultFmax
            LabelCheckF.ForeColor = RGB(255, 0, 0)
        End If
        
        If (BroachSigma <= ToolSigmamax2) Then
            PassSigma = True 'ͨ������Ӧ��
            LabelCheckSigma.Caption = "ͨ��"
            LabelCheckSigma.ForeColor = RGB(0, 0, 0)
        Else
            PassSigma = False '��ͨ������Ӧ��
            ResultSigma = "��=" & LabelBroachSigma.Caption & ">[��]=" & TextToolSigmamax2.Text '��ͨ��ԭ��
            LabelCheckSigma.Caption = "δͨ����" & ResultSigma
            LabelCheckSigma.ForeColor = RGB(255, 0, 0)
        End If
        
        LabelCheckResult = ""
        LabelAdvice.Caption = ""
        LabelCheckResult.ForeColor = RGB(255, 0, 0)
        LabelAdvice.ForeColor = RGB(255, 0, 0)
        If Not PassSigma Then
            LabelCheckResult.Caption = LabelCheckResult.Caption & "Ӧ��У�˲��ϸ�"
            If (D2 <> 0) And (D2 < l_d) Then 'ǰ��D2��С
                LabelAdvice.Caption = "��ǰ��D2Ϊ��ʽ�������ʿ�ͨ�����ĵ��߲�����ߵ��߲�������Ӧ��[��]��"
            Else
                LabelAdvice.Caption = "�ɸ��Ĳ����ͻ�����Ը��ĵ�һ�ݲ۵�ֱ��������ĵ��߲�������ߵ��߲�������Ӧ��[��]��"
            End If
        End If
        
        If Not PassFmax Then
            LabelCheckResult.Caption = LabelCheckResult.Caption & "����У�˲��ϸ�"
            LabelAdvice.Caption = LabelAdvice.Caption & "��Сaf�����ĵ��߲��ϣ�����ݾ�p�����������ͺŻ�������������ϵ����"
        End If
        
        If Not Checkingh_hz(False) Then
            LabelCheckResult.Caption = LabelCheckResult.Caption & "���������С����hmin��"
            LabelAdvice.Caption = LabelAdvice.Caption & "���Ĳ����ͻ���"
        End If
        
        If PassSigma And PassFmax And Checkingh_hz(False) Then
            LabelCheckResult.Caption = "У�˺ϸ�"
            LabelAdvice.Caption = "��"
            LabelCheckResult.ForeColor = RGB(0, 0, 0)
            LabelAdvice.ForeColor = RGB(0, 0, 0)
        End If
        
    Else
        LabelBroachSigma.Caption = "�޼�������������afֵ��"
        LabelCheckSigma.Caption = "�޼�������������afֵ��"
    End If
Else
    MsgBox "δ�ҵ��ò��� " & ComboToolMaterial.Text & " ��Ӧ���ࡣ"
End If
Recordset1.Close

End Sub

Public Sub CommandGroove_Click() '��м��
Dim StrGrooveTableName As String
Dim p, pz As Double
Dim i, n As Integer
Dim HasData As Boolean

'����hmin
LabelhminFormula.Caption = Math.Round(1.13 * Sqr(ValF(Textaf.Text, "������af") * ValF(TextKmin.Text, "��мϵ��Kmin") * ValF(TextL0.Text, "��������L0")), 2)
LabelhzminFormula.Caption = LabelhminFormula.Caption

'������Ҫ���ҵı�
If OptionSmallerGroove.Value = True Then
    StrGrooveTableName = "6_23�����г��õ���м�۳ߴ�"
Else
    StrGrooveTableName = "6_24���ߺ�ֱ�߳ݱ���м�ۼ���ߴ�"
End If

For i = 3 To 0 Step -1 '�������������
    If (OptionGroove(i).Value = True) And (OptionGroove(i).Enabled = True) Then '��ĳ�ѡ���ҿ�ѡ
    
        'p--------------------------------------------------------------------
        If IsNumeric(Textp.Text) Then 'p������
            '��p�Ͳ����Ͳ��
            p = Val(Textp.Text)
            
            Recordset1.Open "SELECT * FROM " & StrGrooveTableName & " WHERE ������='" _
                & OptionGroove(i).Caption & "'" & " AND p=" & p
            
            Comboh.Clear
            Combog.Clear
            Combol_r.Clear
            ComboU_R.Clear
            
            HasData = (Recordset1.RecordCount > 0) And _
                (Not IsNull(Recordset1.Fields("h"))) And _
                (Not IsNull(Recordset1.Fields("g"))) And _
                (Not IsNull(Recordset1.Fields("l_r"))) And _
                (Not IsNull(Recordset1.Fields("U_R")))
            If HasData Then '����м�¼����Ч
                For n = 0 To Recordset1.RecordCount - 1
                    Comboh.AddItem (Recordset1.Fields("h"))
                    Combog.AddItem (Recordset1.Fields("g"))
                    Combol_r.AddItem (Recordset1.Fields("l_r"))
                    ComboU_R.AddItem (Recordset1.Fields("U_R"))
                    Comboh.ListIndex = 0
                    Combog.ListIndex = 0
                    Combol_r.ListIndex = 0
                    ComboU_R.ListIndex = 0
                    Recordset1.MoveNext
                Next n
                If n > 1 Then '�����¼����1
                    SendMsgStr "���гݡ����ɳ���м�۳ߴ绹������" & Comboh.ListCount - 1 & "�����ݣ������ͷ������"
                    Comboh.ToolTipText = "���гݡ����ɳ���м�۳ߴ绹������" & Comboh.ListCount - 1 & "�����ݣ������ͷ������"
                    Combog.ToolTipText = "���гݡ����ɳ���м�۳ߴ绹������" & Comboh.ListCount - 1 & "�����ݣ������ͷ������"
                    Combol_r.ToolTipText = "���гݡ����ɳ���м�۳ߴ绹������" & Comboh.ListCount - 1 & "�����ݣ������ͷ������"
                    ComboU_R.ToolTipText = "���гݡ����ɳ���м�۳ߴ绹������" & Comboh.ListCount - 1 & "�����ݣ������ͷ������"
                Else
                    Comboh.ToolTipText = ""
                    Combog.ToolTipText = ""
                    Combol_r.ToolTipText = ""
                    ComboU_R.ToolTipText = ""
                End If
                'Textp.BackColor = &H80000005  '��
                'Textp.ForeColor = &H80000008 '��
            Else '���û�м�¼��������Ч
                MsgBox "δ�ҵ� p = " & p & " ��Ӧ��м�۳ߴ����ݣ�������ݾ�p����м�۹����߻�����͡�"
                SendMsgStr "δ�ҵ� p = " & p & " ��Ӧ��м�۳ߴ����ݣ�������ݾ�p����м�۹����߻�����͡�"
            End If
            Recordset1.Close
        Else '���p������
            MsgBox "���趨�ݾ�p��"
        End If
        
        'pz--------------------------------------------------------------------
        If IsNumeric(Textpz.Text) Then 'pz������
            '��pz�Ͳ����Ͳ��
            pz = Val(Textpz.Text)
            
            Recordset1.Open "SELECT * FROM " & StrGrooveTableName & " WHERE ������='" _
                & OptionGroove(i).Caption & "'" & " AND p=" & pz
            
            Combohz.Clear
            Combogz.Clear
            Combol_rz.Clear
            ComboU_Rz.Clear
            
            HasData = (Recordset1.RecordCount > 0) And _
                (Not IsNull(Recordset1.Fields("h"))) And _
                (Not IsNull(Recordset1.Fields("g"))) And _
                (Not IsNull(Recordset1.Fields("l_r"))) And _
                (Not IsNull(Recordset1.Fields("U_R")))
            If HasData Then '����м�¼����Ч
                For n = 0 To Recordset1.RecordCount - 1
                    Combohz.AddItem (Recordset1.Fields("h"))
                    Combogz.AddItem (Recordset1.Fields("g"))
                    Combol_rz.AddItem (Recordset1.Fields("l_r"))
                    ComboU_Rz.AddItem (Recordset1.Fields("U_R"))
                    Combohz.ListIndex = 0
                    Combogz.ListIndex = 0
                    Combol_rz.ListIndex = 0
                    ComboU_Rz.ListIndex = 0
                    Recordset1.MoveNext
                Next n
                If n > 1 Then '�����¼����1
                    SendMsgStr "���гݡ�У׼����м�۳ߴ绹������" & Combohz.ListCount - 1 & "�����ݣ������ͷ������"
                    Combohz.ToolTipText = "���гݡ�У׼����м�۳ߴ绹������" & Combohz.ListCount - 1 & "�����ݣ������ͷ������"
                    Combogz.ToolTipText = "���гݡ�У׼����м�۳ߴ绹������" & Combohz.ListCount - 1 & "�����ݣ������ͷ������"
                    Combol_rz.ToolTipText = "���гݡ�У׼����м�۳ߴ绹������" & Combohz.ListCount - 1 & "�����ݣ������ͷ������"
                    ComboU_Rz.ToolTipText = "���гݡ�У׼����м�۳ߴ绹������" & Combohz.ListCount - 1 & "�����ݣ������ͷ������"
                Else
                    Combohz.ToolTipText = ""
                    Combogz.ToolTipText = ""
                    Combol_rz.ToolTipText = ""
                    ComboU_Rz.ToolTipText = ""
                End If
                
                'Textpz.BackColor = &H80000005  '��
                'Textpz.ForeColor = &H80000008 '��
            Else '���û�м�¼��������Ч
                MsgBox "δ�ҵ� pz = " & pz & " ��Ӧ��м�۳ߴ����ݣ�������ݾ�pz����м�۹����߻�����͡�"
                SendMsgStr "δ�ҵ� pz = " & pz & " ��Ӧ��м�۳ߴ����ݣ�������ݾ�pz����м�۹����߻�����͡�"
            End If
            Recordset1.Close
        Else '���pz������
            MsgBox "���趨�ݾ�pz��"
        End If
        
    End If
Next i
Checkingh_hz
End Sub

Private Sub CommandAutoSmooth_Click() '�⻬�ߴ�
Recordset1.Open "SELECT * FROM 6_36����Բ���α���II����ʽ�ͻ����ߴ� ORDER BY D1" '��D1����

While Not Recordset1.EOF
    If (ValF(TextD, "����ֱ��D") - ValF(TextA0.Text, "��������")) >= Recordset1.Fields("D1") Then
        TextD1.Text = Recordset1.Fields("D1")
        TextDq1.Text = Recordset1.Fields("Dq1")
        TextD2.Text = Recordset1.Fields("D2")
        TextL1.Text = Recordset1.Fields("L1")
        TextL2.Text = Recordset1.Fields("L2")
        TextU_L3.Text = Recordset1.Fields("L3")
        TextU_L4.Text = Recordset1.Fields("L4")
        TextC.Text = Recordset1.Fields("C")
    End If
    Recordset1.MoveNext
Wend
Recordset1.Close
Call ComboD1ToleranceZone_GotFocus
Call ComboD2ToleranceZone_GotFocus
'����-----------------------------------------------------------
TextD0.Text = TextD1.Text

'����׶l--------------------------------------------------------
Combolq3.Clear
Combolq3.AddItem "10"
Combolq3.AddItem "15"
Combolq3.AddItem "20"
Combolq3.ListIndex = 0

'ǰ����-------------------------------------------------------------
TextD3.Text = ValF(TextD.Text, "����ֱ��D") - ValF(TextA0.Text, "��������A") 'D3=D0
Call ComboD3ToleranceZone_GotFocus '���¹���
Textl_l3.Text = TextL0.Text

'��������У׼��-----------------------------------------------------
Textl_l.Text = (ValF(Textn1.Text, "���гݳ���") + ValF(Textn2.Text, "���ɳݳ���")) * ValF(Textp.Text, "�ݾ�p")
Textlg.Text = ValF(Textn3.Text, "���гݳ���") * ValF(Textpz.Text, "�ݾ�pz")
Textlz.Text = ValF(Textn4.Text, "У׼�ݳ���") * ValF(Textpz.Text, "�ݾ�pz")

'�󵼲�--------------------------------------------------------------
TextD4.Text = TextD.Text
Call ComboD4ToleranceZone_GotFocus '���¹���
Recordset1.Open "SELECT * FROM 6_40�������Ⱥͺ󵼲����� WHERE ��������L1<=" & ValF(TextL0.Text, "��������L") & " AND " & ValF(TextL0.Text, "��������L") & "<��������L2", Connection1, 1, 1
Textl_l4.Text = Recordset1.Fields("�󵼲�����")
Recordset1.Close

'�����ܳ�-------------------------------------------------------------
Call CommandCalcLength_Click
End Sub

Public Sub ShowMsgAutoExit(ByVal Msg As String, ByVal Time As Integer)
Form2.Label1.Caption = Msg
Form2.Timer1.Interval = Time
Form2.Timer1.Enabled = True
Form2.Show
End Sub

Private Sub CommandAuto_Click()
SendMsgStr "�Զ�����ʼ��"
ShowMsgAutoExit "�����Զ�����...", 800

Call CommandA_Click
Call Commandaf_Click
Call CommandKmin_Click
Call Commandp_Click

Call CommandCalcN_Click
Call CommandCalcFinishingTeethD_Click
Call CommandTooth_Click

Call CommandGroove_Click
Call CommandChipDividingGroove_Click

Call CommandAutoSmooth_Click

Call CommandCheck_Click

InitListViewParameters
RefreshListViewParameters

SendMsgStr "������Զ�����" & "D=" & TextD.Text & " L=" & TextL0.Text
End Sub

Sub iregsvr32(ByVal FileName As String)
If Dir(FileName) <> "" Then
Else
    Shell ("regsvr32 /s " & FileName)
    SendMsgStr "��⵽ϵͳû��" & FileName & "�ļ��������ע�ᡣ"
End If
End Sub

Private Sub Form_Load()
Dim i As Integer
'����OCX������ʼ��-------------------------------------
iregsvr32 "C:\windows\system32\MSADODC.OCX"
'iregsvr32 "C:\windows\system32\COMCTL32.OCX"
iregsvr32 "C:\windows\system32\comdlg32.OCX"

'��ʼ��TabStrip----------------------------------------
With TabStrip1
    .Tabs.Item(1).Caption = "���߻�������"
    .Tabs.Add , , "���ϵ��ѡ��"
    .Tabs.Add , , "��Ƶ���ֱ��"
    .Tabs.Add , , "��м�����м��"
    .Tabs.Add , , "�⻬���ֳߴ�"
    .Tabs.Add , , "ǿ��У��"
    .Tabs.Add , , "�����б�"
End With
TabStrip1.Top = 0
TabStrip1.Left = 0
TabStrip1.Height = 9255
TabStrip1.Width = 8535
TabStrip1_Click

'��ʼ��From-----------------------------------------------
'Form1.Height = 11115
Form1.Width = 8535 '10620

'�������ݿ�---------------------------------------------
DatabaseName = App.Path & "\����������ݿ�.mdb"
Connection1.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + DatabaseName
SendMsgStr "�Ѷ���" & DatabaseName

'���뵶������-----------------------------------------
ComboBroach.AddItem ("�ֲ�ʽ")
ComboBroach.AddItem ("�ۺ�ʽ(�����)")
ComboBroach.AddItem ("�ֿ�ʽ(�����)")
ComboBroach.ListIndex = 0

'���������ͺż������������[Q]-------------------------------
Recordset1.Open "SELECT * FROM ������������Ҫ���", Connection1, 1, 1
While Not Recordset1.EOF
    ComboModel.AddItem (Recordset1.Fields("�����ͺ�"))
    Recordset1.MoveNext
Wend
Recordset1.Close
ComboModel.ListIndex = 0

'���û�������ϵ��---------------------------------------------------
'OptionAutoQCoefficient.Value = True
'OptionNew.Value = True
LabelQCoefficient.Caption = "�»���0.9~1��" & Chr(13) & Chr(10) & _
                            "��������״̬�ľɻ���0.8��" & Chr(13) & Chr(10) & _
                            "���ڲ���״̬�µľɻ���0.5~0.7��"

'����¼ӹ���ѡ��-----------------------------------------
OptionReaming.Value = True

'�������------------------------------------------------
Recordset1.Open "SELECT * FROM ���ϱ�", Connection1, 1, 1

While Not Recordset1.EOF '���뵶�߼����߲�������
    ComboToolMaterial.AddItem (Recordset1.Fields("�ƺ�"))
    ComboWorkpieceMaterial.AddItem (Recordset1.Fields("�ƺ�"))
    Recordset1.MoveNext
Wend
Recordset1.Close
For i = 0 To ComboToolMaterial.ListCount - 1 '����Ĭ�ϵ��߲���
    If StrComp(ComboToolMaterial.List(i), "W18Cr4V") = 0 Then
        ComboToolMaterial.ListIndex = i
    End If
Next i

For i = 0 To ComboWorkpieceMaterial.ListCount - 1 '����Ĭ�Ϲ��߲���
    If StrComp(ComboWorkpieceMaterial.List(i), "45") = 0 Then
        ComboWorkpieceMaterial.ListIndex = i
    End If
Next i

'������߲��ϸ�ѡ���Ը�������Ӧ������----------------------------
Call ComboToolMaterial_Click

'������߲��ϸ�ѡ���Ը��¿���ǿ������----------------------------
Call ComboWorkpieceMaterial_Click

'��ʼ��D����---------------------------------------------
TextD_Validate (False) 'ˢ��D

'��������ֱ�����ȵȼ�--------------------------------------------
ComboDToleranceZone.AddItem ("H7")
ComboDToleranceZone.AddItem ("H8")
ComboDToleranceZone.AddItem ("H9")
ComboDToleranceZone.ListIndex = 0

'����⻬���ֹ����---------------------------------------------
ComboD1ToleranceZone.AddItem "f8"
ComboD2ToleranceZone.AddItem "h12"
ComboD3ToleranceZone.AddItem "e8"
ComboD4ToleranceZone.AddItem "f7"
ComboD1ToleranceZone.ListIndex = 0
ComboD2ToleranceZone.ListIndex = 0
ComboD3ToleranceZone.ListIndex = 0
ComboD4ToleranceZone.ListIndex = 0

'����ֱ���б��ʼ��-----------------------------------------------
InitListViewTeeth

'�������-----------------------------------------------------
Dim nCmdString As String
nCmdString = Command
nCmdString = Replace(nCmdString, """", "")
If nCmdString <> "" Then
    CommonDialog1.FileName = nCmdString
    MenuOpen_Click
End If

End Sub

Private Sub LabelToolSigmaMax1_Click()

End Sub

Private Sub ListViewTeeth_DblClick()
EditTooth
End Sub

Sub EditTooth()
'Dim alln% '�ܹ���ʾ������
Dim NowN% '��ǰ����
If (ListViewTeeth.ColumnHeaders.Count > 0) And (ListViewTeeth.ListItems.Count > 0) Then
    
    '�ƶ��༭��
    TextEditTooth.Left = ListViewTeeth.Left + (ListViewTeeth.ColumnHeaders.Item(1).Width + ListViewTeeth.ColumnHeaders.Item(2).Width) * 1.65
    
    NowN = Fix(pY / ListViewTeeth.ListItems(ListViewTeeth.SelectedItem.Index).Height)
    
    TextEditTooth.Top = ListViewTeeth.Top + ListViewTeeth.ListItems(ListViewTeeth.SelectedItem.Index).Height * NowN + 80
    TextEditTooth.Width = ListViewTeeth.ColumnHeaders.Item(3).Width
    TextEditTooth.Height = ListViewTeeth.ListItems(ListViewTeeth.SelectedItem.Index).Height
    
    If NowN <= ListViewTeeth.ListItems.Count Then
        TextEditTooth.Text = ListViewTeeth.ListItems(ListViewTeeth.SelectedItem.Index).SubItems(2)
        OnEditToothIndex = ListViewTeeth.SelectedItem.Index
        TextEditTooth.Visible = True
        TextEditTooth.SetFocus
        TextEditTooth.SelStart = 0
        TextEditTooth.SelLength = Len(TextEditTooth.Text)
    End If
End If
End Sub

Private Sub ListViewTeeth_KeyDown(KeyCode As Integer, Shift As Integer)
If KeyCode = 46 Or KeyCode = 110 Then DeleteOneTooth
End Sub

Private Sub ListViewTeeth_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
pX = X
pY = Y
TextEditTooth.Visible = False
If Button = 2 Then
    Form1.PopupMenu mnuTooth
End If
End Sub

Private Sub MenuAbout_Click()
frmAbout.Show
End Sub

Private Sub MenuExit_Click()
Unload Me
End Sub

Private Sub MenuOpen_Click()
'CancelError Ϊ True��
On Error GoTo ErrHandler
CommonDialog1.Filter = "�����ļ� (*.*)|*.*|Բ�����������ļ� (*.DAT)|*.DAT" '���ù�������
CommonDialog1.FilterIndex = 2 'ָ��ȱʡ��������
CommonDialog1.ShowOpen '��ʾ�����桱�Ի���
OpenBroach CommonDialog1.FileName '���ô��ļ��Ĺ��̡�
ShowMsgAutoExit "����ϡ�", 800
SendMsgStr "�ļ�" & CommonDialog1.FileName & "����ϡ�"

Exit Sub
ErrHandler:
'�û�����ȡ������ť��
Exit Sub
End Sub

Private Sub MenuSave_Click()
'MsgBox Dir(CommonDialog1.FileName)
If CommonDialog1.FileName <> "" Then '�ļ�����
    SaveBroach CommonDialog1.FileName '���ô��ļ��Ĺ��̡�
    ShowMsgAutoExit "������ϡ�", 800
    SendMsgStr "�ļ�" & CommonDialog1.FileName & "������ϡ�"
Else '�ļ�������
    MenuSaveAs_Click
End If
End Sub

Private Sub MenuSaveAs_Click()
'CancelError Ϊ True��
On Error GoTo ErrHandler
CommonDialog1.Filter = "�����ļ� (*.*)|*.*|Բ�����������ļ� (*.DAT)|*.DAT" '���ù�������
CommonDialog1.FilterIndex = 2 'ָ��ȱʡ��������
CommonDialog1.ShowSave '��ʾ�����桱�Ի���
SaveBroach CommonDialog1.FileName '���ñ����ļ��Ĺ��̡�
ShowMsgAutoExit "������ϡ�", 800
SendMsgStr "�ļ�" & CommonDialog1.FileName & "������ϡ�"

Exit Sub
ErrHandler:
'�û�����ȡ������ť��
Exit Sub
End Sub

Private Sub mnuDelete_Click()
DeleteOneTooth
End Sub

Private Sub mnuEditTooth_Click()
EditTooth
End Sub

Private Sub mnuInsertN1_Click()
InsertTooth (1)
End Sub
Private Sub mnuInsertN2_Click()
InsertTooth (2)
End Sub
Private Sub mnuInsertN3_Click()
InsertTooth (3)
End Sub
Private Sub mnuInsertN4_Click()
InsertTooth (4)
End Sub

Sub CalcTeethLength()
Textl_l.Text = (Val(Textn1.Text) + Val(Textn2.Text)) * Val(Textp.Text)
Textlg.Text = Val(Textn3.Text) * Val(Textpz.Text)
Textlz.Text = Val(Textn4.Text) * Val(Textpz.Text)
End Sub

Private Sub TabStrip1_Click()
Dim i As Integer
For i = 0 To 6 'TabStrip1.Tabs.Count
    Picture1(i).Visible = False
Next i
Picture1(TabStrip1.SelectedItem.Index - 1).BackColor = &H8000000F
Picture1(TabStrip1.SelectedItem.Index - 1).BorderStyle = 0
Picture1(TabStrip1.SelectedItem.Index - 1).Top = 360
Picture1(TabStrip1.SelectedItem.Index - 1).Left = (TabStrip1.Width - Picture1(TabStrip1.SelectedItem.Index - 1).Width) / 2
Picture1(TabStrip1.SelectedItem.Index - 1).Visible = True

If TabStrip1.SelectedItem.Index - 1 = 4 Then
    CalcTeethLength
End If

If TabStrip1.SelectedItem.Index - 1 = 6 Then
    InitListViewParameters
    RefreshListViewParameters
End If
End Sub

Private Sub TextA0_Change()
If IsNumeric(TextD.Text) And IsNumeric(TextA0.Text) Then
    LabelPreHoleD.Caption = Val(TextD.Text) - Val(TextA0.Text)
    SendMsgStr "��������A�Ѹı䡣"
Else
    LabelPreHoleD.Caption = "��������ֱ��D����������Aֵ��"
    SendMsgStr "��������ֱ��D����������Aֵ��"
End If
End Sub

Private Sub TextAutoQCoefficient_Change()

End Sub

Private Sub TextD_Validate(Cancel As Boolean) '��ɱ༭D
Dim D, dymin, dymax As Integer
D = ValF(TextD.Text, "����ֱ��D")
'ȡ��D����Χ----------------------------------------
Recordset1.Open "SELECT * FROM 6_8Բ���������� ORDER BY D1", Connection1, 1, 1
dymin = Recordset1.Fields("D1")
Recordset1.MoveLast
dymax = Recordset1.Fields("D2")
Recordset1.Close
If D < dymin Then MsgBox "����ֱ��D < [Բ����������]����С��ѯֵ = " & dymin & "��"
If D > dymax Then MsgBox "����ֱ��D > [Բ����������]������ѯֵ = " & dymax & "��"

If ComboDToleranceZone.ListCount > 0 Then
    Call ComboDToleranceZone_Click
End If
End Sub

Private Sub TextEditTooth_KeyPress(KeyAscii As Integer)
If KeyAscii = 13 Then
    TextEditTooth_LostFocus
End If
End Sub

Private Sub TextEditTooth_LostFocus()
If ListViewTeeth.ListItems.Count > 0 Then
    ListViewTeeth.ListItems(OnEditToothIndex).SubItems(2) = TextEditTooth.Text
End If
TextEditTooth.Visible = False
End Sub

Private Sub TextManualQCoefficient_Validate(Cancel As Boolean)
Call ComboModel_Click
End Sub

Private Sub TextQCoefficient_Change()
RefreshQ_l_l0 True, 2
End Sub
