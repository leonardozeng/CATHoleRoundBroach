Attribute VB_Name = "ListViewFace_Module"
Option Explicit

'ԭ���� �ٶ�֪�����𰲰���
'���� VB ListView��5.0�ĺ���ô��ʾ������ http://zhidao.baidu.com/question/300375363.html

''''ListView ��Common Control 5.0�� ������ʾ��''''''''''''''''
Private Declare Function SendMessageLong Lib "User32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function SendMessage Lib "User32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long

Public Const LVS_EX_GRIDLINES                      As Long = &H1&
Public Const LVS_EX_CHECKBOXES                     As Long = &H4&
Public Const LVS_EX_FULLROWSELECT                  As Long = &H20&
Public Const LVM_FIRST                             As Long = &H1000
Public Const LVM_SETITEMSTATE                      As Long = (LVM_FIRST + 43)
Public Const LVM_GETITEMSTATE                      As Long = (LVM_FIRST + 44)
Public Const LVIS_STATEIMAGEMASK                   As Long = &HF000
Public Const LVIF_STATE                            As Long = &H8
'***********************����

Private Enum LISTVIEW_MESSAGES
    'LVM_FIRST = &H1000
    LVM_SETITEMCOUNT = (LVM_FIRST + 47)
    LVM_GETITEMRECT = (LVM_FIRST + 14)
    LVM_SCROLL = (LVM_FIRST + 20)
    LVM_GETTOPINDEX = (LVM_FIRST + 39)
    LVM_HITTEST = (LVM_FIRST + 18)
    LVM_DELETEALLITEMS = (LVM_FIRST + 9)
    LVM_SETEXTENDEDLISTVIEWSTYLE = (LVM_FIRST + 54)
    LVM_GETEXTENDEDLISTVIEWSTYLE = (LVM_FIRST + 55)
End Enum
'//����ListView��չ��ʽ------------------------------------------------------------
Public Sub SetExtendedStyle(lv As Object, ByVal lStyle As Long, ByVal lStyleNot As Long)
    Dim lNewStyle   As Long
    lNewStyle = SendMessageLong(lv.hWnd, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
    lNewStyle = lNewStyle And Not lStyleNot
    lNewStyle = lNewStyle Or lStyle
    SendMessageLong lv.hWnd, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, lNewStyle
End Sub
''''''''''''''''''''''''''''''����Listview'''''''''''''''''''''''''''''''''''''''''

'�÷�ʾ��
'Private Sub Form_Load()
'  SetExtendedStyle Listview1, LVS_EX_GRIDLINES, 0
'  SetExtendedStyle Listview1, LVS_EX_FULLROWSELECT, 0
'End Sub

Public Sub InitListViewTeeth()
With Form1
    .ListViewTeeth.Appearance = ccFlat
    .ListViewTeeth.BorderStyle = ccFixedSingle
    .ListViewTeeth.ListItems.Clear               '����б�
    .ListViewTeeth.ColumnHeaders.Clear           '����б�ͷ
    .ListViewTeeth.View = lvwReport              '�����б���ʾ��ʽ
    .ListViewTeeth.LabelEdit = lvwManual         '��ֹ��ǩ�༭
    .ListViewTeeth.MultiSelect = False
    '.listviewteeth.FlatScrollBar = False         '��ʾ������
    SetExtendedStyle .ListViewTeeth, LVS_EX_GRIDLINES, 0 '��ʾ������
    SetExtendedStyle .ListViewTeeth, LVS_EX_FULLROWSELECT, 0 'ѡ������
    
    .ListViewTeeth.ColumnHeaders.Clear
    .ListViewTeeth.ColumnHeaders.Add , , "�ݺ�", .ListViewTeeth.Width * 0.1
    .ListViewTeeth.ColumnHeaders.Add , , "����", .ListViewTeeth.Width * 0.15
    .ListViewTeeth.ColumnHeaders.Add , , "ֱ��", .ListViewTeeth.Width * 0.15
    .ListViewTeeth.ColumnHeaders.Add , , "ƫ��", .ListViewTeeth.Width * 0.2
End With
End Sub

Sub InitListViewParameters()
With Form1
    .ListViewParameters.Appearance = ccFlat
    .ListViewParameters.BorderStyle = ccFixedSingle
    .ListViewParameters.ListItems.Clear               '����б�
    .ListViewParameters.ColumnHeaders.Clear           '����б�ͷ
    .ListViewParameters.View = lvwReport              '�����б���ʾ��ʽ
    .ListViewParameters.LabelEdit = lvwManual         '��ֹ��ǩ�༭
    '.ListViewParameters.FlatScrollBar = False         '��ʾ������
    SetExtendedStyle .ListViewParameters, LVS_EX_GRIDLINES, 0 '��ʾ������
    SetExtendedStyle .ListViewParameters, LVS_EX_FULLROWSELECT, 0 'ѡ������
    
    .ListViewParameters.ColumnHeaders.Clear
    .ListViewParameters.ColumnHeaders.Add , , "���", .ListViewParameters.Width * 0.05
    .ListViewParameters.ColumnHeaders.Add , , "��������", .ListViewParameters.Width * 0.48
    .ListViewParameters.ColumnHeaders.Add , , "����", .ListViewParameters.Width * 0.13
    .ListViewParameters.ColumnHeaders.Add , , "ֵ", .ListViewParameters.Width * 0.35
End With
End Sub
