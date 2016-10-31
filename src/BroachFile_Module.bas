Attribute VB_Name = "BroachFile_Module"
Option Explicit

Option Base 1 '�����½�Ϊ1

Type BroachVars
    ParametersName As String '��������
    VarsName As String '����
    Value As String '����ֵ
End Type
Const BCount% = 76
Dim BroachData(BCount) As BroachVars
Dim BroachDataCount As Integer
Dim BroachDataIndex As Integer

Type BroachToothVars
    ToothNum As String
    ToothClass As String
    ToothD As String
    ToothLimit As String
End Type
Dim BroachTeethData() As BroachToothVars
Dim BroachTeethDataCount As Integer

'�õ�һ������
Sub AddOneBroachVar(ByVal sParametersName As String, Optional ByVal sVarsName As String, Optional ByVal sValue As String)
BroachDataCount = BroachDataCount + 1
BroachData(BroachDataCount).ParametersName = sParametersName
BroachData(BroachDataCount).VarsName = sVarsName
BroachData(BroachDataCount).Value = sValue
End Sub

Function ReadOneBroachVar() As String '����һ���ؼ�
BroachDataIndex = BroachDataIndex + 1
ReadOneBroachVar = BroachData(BroachDataIndex).Value
End Function

Sub Tab1ToRecord() '�õ�����-��14��
With Form1
    AddOneBroachVar "ʵ�����", , .TextBroachNum.Text
    AddOneBroachVar "ʵ������", , .TextBroachName.Text
    AddOneBroachVar "��������", , .ComboBroach.Text
    AddOneBroachVar "����ֱ��", "D", .TextD.Text
    AddOneBroachVar "����ֱ������", "", .ComboDToleranceZone.Text
    AddOneBroachVar "��������", "L0", .TextL0.Text
    AddOneBroachVar "Ԥ�ƿ׼ӹ���ʽ", , .GetStrFromMachiningMode
    AddOneBroachVar "�����ͺ�", , .ComboModel.Text
    AddOneBroachVar "���߲���", , .ComboToolMaterial.Text
    AddOneBroachVar "����Ӳ�Ȳⶨֵ", "HB", .TextToolHB.Text
    AddOneBroachVar "���߲�������Ӧ���½�", "[��]1", .TextToolSigmamax1.Text
    AddOneBroachVar "���߲�������Ӧ���Ͻ�", "[��]2", .TextToolSigmamax2.Text
    AddOneBroachVar "��������", , .ComboWorkpieceMaterial.Text
    AddOneBroachVar "��������ǿ�Ȳⶨֵ", "��b", .TextWpSigmab.Text
End With
End Sub

Sub RecordToTab1() '����ؼ�
With Form1
    .TextBroachNum.Text = ReadOneBroachVar '"ʵ�����"
    .TextBroachName.Text = ReadOneBroachVar '"ʵ������"
    .SetComboFromStr .ComboBroach, ReadOneBroachVar '"��������"
    .TextD.Text = ReadOneBroachVar '"����ֱ��"
    .SetComboFromStr .ComboDToleranceZone, ReadOneBroachVar: .ComboDToleranceZone_Click '"����ֱ������"
    .TextL0.Text = ReadOneBroachVar '"��������"
    .SetMachiningModeFromStr (ReadOneBroachVar) '"Ԥ�ƿ׼ӹ���ʽ"
    .SetComboFromStr .ComboModel, ReadOneBroachVar: .ComboModel_Click '"�����ͺ�"
    .SetComboFromStr .ComboToolMaterial, ReadOneBroachVar: .ComboToolMaterial_Click '"���߲���"
    .TextToolHB.Text = ReadOneBroachVar '"����Ӳ�Ȳⶨֵ"
    .TextToolSigmamax1.Text = ReadOneBroachVar '"���߲�������Ӧ���½�"
    .TextToolSigmamax2.Text = ReadOneBroachVar '"���߲�������Ӧ���Ͻ�"
    .SetComboFromStr .ComboWorkpieceMaterial, ReadOneBroachVar: .ComboWorkpieceMaterial_Click '"��������"
    .TextWpSigmab.Text = ReadOneBroachVar '"��������ǿ�Ȳⶨֵ"
End With
End Sub

Sub Tab2ToRecord() '��18��
With Form1
    AddOneBroachVar "��������", "A", .TextA0.Text
    AddOneBroachVar "������", "af", .Textaf.Text
    AddOneBroachVar "Mֵ", "M", .TextM.Text
    AddOneBroachVar "��мϵ��", "Kmin", .TextKmin.Text
    AddOneBroachVar "�����ݳݾ�", "p", .Textp.Text
    AddOneBroachVar "У׼�ݳݾ�", "pz", .Textpz.Text
    AddOneBroachVar "�Ƿ����д�", , .Checkbalpha1.Value
    AddOneBroachVar "ǰ��(�Ƕȷ���)", "��o(Deg)", .TextGammaoDeg.Text
    AddOneBroachVar "ǰ��(�ַ���)", "��o(Min)", .TextGammaoMin.Text
    AddOneBroachVar "ǰ��(�����)", "��o(Sec)", .TextGammaoSec.Text
    AddOneBroachVar "�����ݺ��(�Ƕȷ���)", "��o(Deg)", .TextAlphaoDeg.Text
    AddOneBroachVar "�����ݺ��(�ַ���)", "��o(Min)", .TextAlphaoMin.Text
    AddOneBroachVar "�����ݺ��(�����)", "��o(Sec)", .TextAlphaoSec.Text
    AddOneBroachVar "�������д���", "b��1_1", .Textbalpha1_1.Text
    AddOneBroachVar "У׼�ݺ��(�Ƕȷ���)", "��oz(Deg)", .TextAlphaozDeg.Text
    AddOneBroachVar "У׼�ݺ��(�ַ���)", "��oz(Min)", .TextAlphaozMin.Text
    AddOneBroachVar "У׼�ݺ��(�����)", "��oz(Sec)", .TextAlphaozSec.Text
    AddOneBroachVar "У׼���д���", "b��1_2", .Textbalpha1_2.Text
End With
End Sub

Sub RecordToTab2()
With Form1
    .CommandA_Click: .TextA0.Text = ReadOneBroachVar '"��������"
    .Commandaf_Click: .Textaf.Text = ReadOneBroachVar '"������"
    .TextM.Text = ReadOneBroachVar '"Mֵ"
    .CommandKmin_Click: .TextKmin.Text = ReadOneBroachVar '"��мϵ��"
    .Commandp_Click: .Textp.Text = ReadOneBroachVar '"�����ݳݾ�"
    .Textpz.Text = ReadOneBroachVar '"У׼�ݳݾ�"
    .Checkbalpha1.Value = ReadOneBroachVar '"�Ƿ����д�"
    .TextGammaoDeg.Text = ReadOneBroachVar '"ǰ��(�Ƕȷ���)"
    .TextGammaoMin.Text = ReadOneBroachVar '"ǰ��(�ַ���)"
    .TextGammaoSec.Text = ReadOneBroachVar '"ǰ��(�����)"
    .TextAlphaoDeg.Text = ReadOneBroachVar '"�����ݺ��(�Ƕȷ���)"
    .TextAlphaoMin.Text = ReadOneBroachVar '"�����ݺ��(�ַ���)"
    .TextAlphaoSec.Text = ReadOneBroachVar '"�����ݺ��(�����)"
    .Textbalpha1_1.Text = ReadOneBroachVar '"�������д���"
    .TextAlphaozDeg.Text = ReadOneBroachVar '"У׼�ݺ��(�Ƕȷ���)"
    .TextAlphaozMin.Text = ReadOneBroachVar '"У׼�ݺ��(�ַ���)"
    .TextAlphaozSec.Text = ReadOneBroachVar '"У׼�ݺ��(�����)"
    .Textbalpha1_2.Text = ReadOneBroachVar '"У׼���д���"
End With
End Sub

Sub Tab3ToRecord() '��4��
With Form1
    AddOneBroachVar "���гݳ���", , .Textn1.Text
    AddOneBroachVar "���ɳݳ���", , .Textn2.Text
    AddOneBroachVar "���гݳ���", , .Textn3.Text
    AddOneBroachVar "У׼�ݳ���", , .Textn4.Text
    AddOneBroachVar "У׼��ֱ��", , .TextFinishingTeethD.Text
End With
End Sub

Sub RecordToTab3()
With Form1
    .CommandCalcN_Click: .Textn1.Text = ReadOneBroachVar '"���гݳ���"
    .Textn2.Text = ReadOneBroachVar '"���ɳݳ���"
    .Textn3.Text = ReadOneBroachVar '"���гݳ���"
    .Textn4.Text = ReadOneBroachVar '"У׼�ݳ���"
    .CommandCalcFinishingTeethD_Click: .TextFinishingTeethD.Text = ReadOneBroachVar
End With
End Sub

Sub Tab4ToRecord()
With Form1
    AddOneBroachVar "��м�۹�����", , .GetStrFromSmallerOption
    AddOneBroachVar "������", , .GetStrFromGrooveOption
    AddOneBroachVar "���гݡ����ɳ���м�����", "h", .Comboh.Text
    AddOneBroachVar "���гݡ����ɳ���м�۳ݺ�", "g", .Combog.Text
    AddOneBroachVar "���гݡ����ɳ���м�۲۵�Բ���뾶", "r", .Combol_r.Text
    AddOneBroachVar "���гݡ����ɳ���м�۳ݱ�Բ���뾶", "R", .ComboU_R.Text
    AddOneBroachVar "���гݡ�У׼����м�����", "hz", .Combohz.Text
    AddOneBroachVar "���гݡ�У׼����м�۳ݺ�", "gz", .Combogz.Text
    AddOneBroachVar "���гݡ�У׼����м�۲۵�Բ���뾶", "rz", .Combol_rz.Text
    AddOneBroachVar "���гݡ�У׼����м�۳ݱ�Բ���뾶", "Rz", .ComboU_Rz.Text
    AddOneBroachVar "�Ƿ񿪷�м��", , .CheckHasChipDividingGroove.Value
    AddOneBroachVar "��м������", "nk", .Textnk.Text
    AddOneBroachVar "��м�ۿ��", "bc", .Textbc.Text
    AddOneBroachVar "��м�����", "hc", .Texthc.Text
    AddOneBroachVar "��м��Բ�ǰ뾶", "rc", .Textrc.Text
    AddOneBroachVar "��м�۽Ƕ�", "��c", .TextOmegac.Text
    AddOneBroachVar "��м�ۺ���������Ƕȷ�����", "����c(Deg)", .TextDeltaAlphacDeg.Text
    AddOneBroachVar "��м�ۺ���������ַ�����", "����c(Min)", .TextDeltaAlphacMin.Text
    AddOneBroachVar "��м�ۺ���������������", "����c(Sec)", .TextDeltaAlphacSec.Text
End With
End Sub

Sub RecordToTab4()
With Form1
    .SetSmallerOptionFromStr ReadOneBroachVar '"��м�۹�����"
    .SetGrooveOptionFromStr ReadOneBroachVar '"������"
    .CommandGroove_Click: .Comboh.Text = ReadOneBroachVar 'h
    .Combog.Text = ReadOneBroachVar 'g
    .Combol_r.Text = ReadOneBroachVar 'r
    .ComboU_R.Text = ReadOneBroachVar 'R
    .Combohz.Text = ReadOneBroachVar 'hz
    .Combogz.Text = ReadOneBroachVar 'gz
    .Combol_rz.Text = ReadOneBroachVar 'rz
    .ComboU_Rz.Text = ReadOneBroachVar 'Rz
    .CheckHasChipDividingGroove.Value = ReadOneBroachVar '"�Ƿ񿪷�м��"
    .CommandChipDividingGroove_Click: .Textnk.Text = ReadOneBroachVar
    .Textbc.Text = ReadOneBroachVar
    .Texthc.Text = ReadOneBroachVar
    .Textrc.Text = ReadOneBroachVar
    .TextOmegac.Text = ReadOneBroachVar
    .TextDeltaAlphacDeg.Text = ReadOneBroachVar
    .TextDeltaAlphacMin.Text = ReadOneBroachVar
    .TextDeltaAlphacSec.Text = ReadOneBroachVar
End With
End Sub

Sub Tab5ToRecord()
With Form1
    AddOneBroachVar "ǰ��D1", "D1", .TextD1.Text
    AddOneBroachVar "ǰ��L1", "L1", .TextL1.Text
    AddOneBroachVar "ǰ��D'1", "D'1", .TextDq1.Text
    AddOneBroachVar "ǰ��D2", "D2", .TextD2.Text
    AddOneBroachVar "ǰ��L2", "L2", .TextL2.Text
    AddOneBroachVar "�����ο��ߴ�L3", "L3", .TextU_L3.Text
    AddOneBroachVar "�����ο��ߴ�L4", "L4", .TextU_L4.Text
    AddOneBroachVar "����C", "C", .TextC.Text
    AddOneBroachVar "����D0", "D0", .TextD0.Text
    AddOneBroachVar "����l0", "l0", .Textl_l0.Text
    AddOneBroachVar "����׶l'3", "l'3", .Combolq3.Text
    AddOneBroachVar "ǰ����D3", "D3", .TextD3.Text
    AddOneBroachVar "ǰ����l3", "l3", .Textl_l3.Text
    AddOneBroachVar "����������l", "l", .Textl_l.Text
    AddOneBroachVar "���в�����lg", "lg", .Textlg.Text
    AddOneBroachVar "У׼������lz", "lz", .Textlz.Text
    AddOneBroachVar "�󵼲�D4", "D4", .TextD4.Text
    AddOneBroachVar "�󵼲�l4", "l4", .Textl_l4.Text
    AddOneBroachVar "�����ܳ�L", "L", .TextToolLength.Text
End With
End Sub

Sub RecordToTab5()
With Form1
    .TextD1.Text = ReadOneBroachVar '"ǰ��D1"
    .TextL1.Text = ReadOneBroachVar '"ǰ��L1"
    .TextDq1.Text = ReadOneBroachVar '"ǰ��D'1"
    .TextD2.Text = ReadOneBroachVar '"ǰ��D2"
    .TextL2.Text = ReadOneBroachVar '"ǰ��L2"
    .TextU_L3.Text = ReadOneBroachVar '"�����ο��ߴ�L3"
    .TextU_L4.Text = ReadOneBroachVar '"�����ο��ߴ�L4"
    .TextC.Text = ReadOneBroachVar '"����C"
    .TextD0.Text = ReadOneBroachVar '
    .Textl_l0.Text = ReadOneBroachVar '
    .Combolq3.Text = ReadOneBroachVar '
    .TextD3.Text = ReadOneBroachVar '
    .Textl_l3.Text = ReadOneBroachVar '
    .Textl_l.Text = ReadOneBroachVar '
    .Textlg.Text = ReadOneBroachVar '
    .Textlz.Text = ReadOneBroachVar '
    .TextD4.Text = ReadOneBroachVar '
    .Textl_l4.Text = ReadOneBroachVar '
    .TextToolLength.Text = ReadOneBroachVar '
    
    .ComboD1ToleranceZone_GotFocus
    .ComboD2ToleranceZone_GotFocus
    .ComboD3ToleranceZone_GotFocus
    .ComboD4ToleranceZone_GotFocus
    .CommandCalcLength_Click
End With
End Sub

Sub Tab6ToRecord()
With Form1
    AddOneBroachVar "������������ϵ��", , .TextQCoefficient.Text
End With
End Sub

Sub RecordToTab6()
With Form1
    .TextQCoefficient.Text = ReadOneBroachVar: .CommandCheck_Click
End With
End Sub

Sub ToothToRecord()
Dim i%
With Form1
    For i = 1 To BroachTeethDataCount
        BroachTeethData(i).ToothNum = .ListViewTeeth.ListItems(i).Text
        BroachTeethData(i).ToothClass = .ListViewTeeth.ListItems(i).SubItems(1)
        BroachTeethData(i).ToothD = .ListViewTeeth.ListItems(i).SubItems(2)
        BroachTeethData(i).ToothLimit = .ListViewTeeth.ListItems(i).SubItems(3)
    Next i
End With
End Sub

Sub RecordToTooth()
Dim i%
With Form1
    .ListViewTeeth.ListItems.Clear
    For i = 1 To BroachTeethDataCount
        .ListViewTeeth.ListItems.Add i
        .ListViewTeeth.ListItems(i).Text = BroachTeethData(i).ToothNum
        .ListViewTeeth.ListItems(i).SubItems(1) = BroachTeethData(i).ToothClass
        .ListViewTeeth.ListItems(i).SubItems(2) = BroachTeethData(i).ToothD
        .ListViewTeeth.ListItems(i).SubItems(3) = BroachTeethData(i).ToothLimit
    Next i
End With
End Sub

Sub RefreshListViewParameters()
Dim i%
BroachDataCount = 0
Tab1ToRecord
Tab2ToRecord
Tab3ToRecord
Tab4ToRecord
Tab5ToRecord
Tab6ToRecord
With Form1
    .ListViewParameters.ListItems.Clear
    For i = 1 To BCount
        .ListViewParameters.ListItems.Add , , i
        .ListViewParameters.ListItems(i).SubItems(1) = BroachData(i).ParametersName
        .ListViewParameters.ListItems(i).SubItems(2) = BroachData(i).VarsName
        .ListViewParameters.ListItems(i).SubItems(3) = BroachData(i).Value
    Next i
End With
End Sub

Sub SaveBroach(ByVal FileName As String) '��������
Dim i%
BroachDataCount = 0
Tab1ToRecord
Tab2ToRecord
Tab3ToRecord
Tab4ToRecord
Tab5ToRecord
Tab6ToRecord

BroachTeethDataCount = Form1.ListViewTeeth.ListItems.Count
If BroachTeethDataCount > 0 Then
    ReDim BroachTeethData(BroachTeethDataCount) As BroachToothVars
    ToothToRecord
End If

Open FileName For Random As #1 Len = 128
For i = 1 To BCount
    Put #1, , BroachData(i)
Next i

Put #1, , BroachTeethDataCount
If BroachTeethDataCount > 0 Then
    For i = 1 To BroachTeethDataCount
        Put #1, , BroachTeethData(i)
    Next i
End If

Close #1
End Sub

Sub OpenBroach(ByVal FileName As String) '��ȡ����
Dim i%

Open FileName For Random As #1 Len = 128
For i = 1 To BCount
    Get #1, , BroachData(i)
Next i

Get #1, , BroachTeethDataCount
If BroachTeethDataCount > 0 Then
    ReDim BroachTeethData(BroachTeethDataCount) As BroachToothVars
    For i = 1 To BroachTeethDataCount
        Get #1, , BroachTeethData(i)
    Next i
End If

Close #1

BroachDataIndex = 0
RecordToTab1
RecordToTab2
RecordToTab3
RecordToTab4
RecordToTab5
RecordToTab6
RecordToTooth
End Sub

