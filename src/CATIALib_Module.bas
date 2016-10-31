Attribute VB_Name = "CATIALib_Module"
Option Explicit
' ***********************************************************************
'   Ŀ�ģ�       ��׼����ģ��
'   ԭ���ߣ�     SUNNYTECH Huting <tianshuen@gmail.com>
'   �Ķ���       TomWillow
'   �������:    VB
'   ����:        ����
'   CATIA Level: V5R9
' ***********************************************************************

' --------------------------------------------------------------
' ���������趨API����
' --------------------------------------------------------------
Private Declare Function SetWindowPos Lib "User32" ( _
                                ByVal hWnd As Long, _
                                ByVal hWndInsertAfter As Long, _
                                ByVal X As Long, ByVal Y As Long, _
                                ByVal cx As Long, ByVal cy As Long, _
                                ByVal wFlags As Long) As Long
Private Const SWP_NOMOVE = &H2
Private Const SWP_NOSIZE = &H1
Private Const HWND_TOPMOST = -1
Private Const HWND_NOTOPMOST = -2

' --------------------------------------------------------------
' ������������
' --------------------------------------------------------------
Public CATIA As INFITF.Application
Public oProductDoc As ProductDocument
Public oPartDoc As PartDocument
Public oDrawingDoc As DrawingDocument
Public oPart As Part

Public oBodies As Bodies
Public oBody As Body
Public oHBodies As HybridBodies
Public oHBody As HybridBody

Public oSF As ShapeFactory
Public oHSF As HybridShapeFactory

' ***********************************************************************
'   Ŀ�ģ�      ��ʼ��CATIA��Ʒ�ĵ�������ʼ����Ҫ�Ļ�������
'
'   ���룺      bNewProduct:   ��ʼ��ʱ�Ƿ��½���Ʒ�ļ�
'                              ��ѡ��Ĭ���½��ļ�
'               strProduct:    ��ʼ��ʱ�Ƿ���Ѿ����ڵĲ�Ʒ�ļ�
'                              ��ѡ��Ĭ���½��ļ�
' ***********************************************************************
Sub InitCATIAProduct(Optional bNewProduct As Boolean = True, _
                     Optional strProduct As String = "")
    
    On Error Resume Next
    Set CATIA = GetObject(, "CATIA.Application")
    If Err.Number <> 0 Then
      Set CATIA = CreateObject("CATIA.Application")
      CATIA.Visible = True
    End If
    
    If bNewProduct Then
        Set oProductDoc = CATIA.Documents.Add("Product")
    Else
        If strProduct = "" Then
            Set oProductDoc = CATIA.ActiveDocument
            If oProductDoc Is Nothing Then
                Err.Clear
                Set oProductDoc = CATIA.Documents.Add("Product")
            End If
        Else
            If Dir(strProduct) <> "" Then
                Set oProductDoc = CATIA.Documents.Open(strProduct)
            Else
                MsgBox "ָ�����ļ������ڣ�"
                End
            End If
        End If
    End If
    
    On Error GoTo 0

End Sub

' ***********************************************************************
'   Ŀ�ģ�      ��ʼ��CATIA����ĵ�������ʼ����Ҫ�Ļ�������
'
'   ���룺       bNewPart:    ��ʼ��ʱ�Ƿ��½�����ļ�
'                             ��ѡ��Ĭ���½��ļ�
'                strPart:     ��ʼ��ʱ�Ƿ���Ѿ����ڵ�����ļ�
'                             ��ѡ��Ĭ���½��ļ�
' ***********************************************************************
Function InitCATIAPart(Optional bNewPart As Boolean = True, _
                  Optional strPart As String = "") As Boolean

    'On Error GoTo out
    On Error Resume Next
    
    Set CATIA = GetObject(, "CATIA.Application") '���ӵ�CATIA
    
    If Err.Number <> 0 Then 'CATIAδ�򿪡���CATIA
      Set CATIA = CreateObject("CATIA.Application")
      CATIA.Visible = True
    End If
    
    If CATIA.Caption <> "" Then '������CATIA
    
        If bNewPart Then
            Set oPartDoc = CATIA.Documents.Add("Part")
        Else
            If strPart = "" Then
                Set oPartDoc = CATIA.ActiveDocument
                If oPartDoc Is Nothing Then
                    Err.Clear
                    Set oPartDoc = CATIA.Documents.Add("Part")
                End If
            Else
                If Dir(strPart) <> "" Then
                    Set oPartDoc = CATIA.Documents.Open(strPart)
                Else
                    MsgBox "ָ�����ļ������ڣ�"
                    End
                End If
            End If
        End If
        
        Set oPart = oPartDoc.Part
        Set oBodies = oPart.Bodies
        Set oBody = oPart.MainBody
        Set oHBodies = oPart.HybridBodies
        
        Set oSF = oPart.ShapeFactory
        Set oHSF = oPart.HybridShapeFactor
        
        InitCATIAPart = True '���������ź�
        On Error GoTo 0
    Else
        MsgBox "δ��⵽CATIA��"
        Form1.SendMsgStr "δ��⵽CATIA��"
    End If
        

End Function

' ***********************************************************************
'   Ŀ�ģ�      ��ʼ��CATIA����ͼ�ĵ�������ʼ����Ҫ�Ļ�������
'
'   ���룺       bNewDrawing:    ��ʼ��ʱ�Ƿ��½�����ļ�
'                                ��ѡ��Ĭ���½��ļ�
'                strDrawing:     ��ʼ��ʱ�Ƿ���Ѿ����ڵĹ���ͼ�ļ�
'                                ��ѡ��Ĭ���½��ļ�
' ***********************************************************************
Sub InitCATIADrawing(Optional bNewDrawing As Boolean = True, _
                     Optional strDrawing As String = "")

    On Error Resume Next
    Set CATIA = GetObject(, "CATIA.Application")
    If Err.Number <> 0 Then
      Set CATIA = CreateObject("CATIA.Application")
      CATIA.Visible = True
    End If
    
    If bNewDrawing Then
        Set oDrawingDoc = CATIA.Documents.Add("Drawing")
    Else
        If bNewDrawing = "" Then
            Set oDrawingDoc = CATIA.ActiveDocument
            If oDrawingDoc Is Nothing Then
                Err.Clear
                Set oDrawingDoc = CATIA.Documents.Add("Drawing")
            End If
        Else
            If Dir(bNewDrawing) <> "" Then
                Set oDrawingDoc = CATIA.Documents.Open(strDrawing)
            Else
                MsgBox "ָ�����ļ������ڣ�"
                End
            End If
        End If
    End If
    
    On Error GoTo 0

End Sub

' ***********************************************************************
'   Ŀ�ģ�      ���ô���ʹ��ʼ����������������
'
'   ���룺      iHwnd:    Ҫ���õĴ��ھ��
'               bOnTop:   ���û�ȡ�����ڵ��ö�����
'                         ��ѡ��Ĭ��Ϊ��
' ***********************************************************************
Sub MakeMeOnTop(iHwnd As Long, Optional bOnTop As Boolean = True)
    
    If bOnTop Then
        SetWindowPos iHwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE
    Else
        SetWindowPos iHwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE
    End If

End Sub

' ***********************************************************************
'   Ŀ�ģ�      ����µļ���Ԫ�ؼ�
'
'   ���룺      HBodyName: ����Ԫ�ؼ�����
' ***********************************************************************
Function AddHBody(Optional HBodyName As String = "") As HybridBody
    
    Dim oHB As HybridBody
    
    On Error Resume Next
    
    Set oHB = oHBodies.Add()
    If HBodyName <> "" Then
        oHB.Name = HBodyName
    End If
    
    Set AddHBody = oHB
    
    On Error GoTo 0
    
End Function

' ***********************************************************************
'   Ŀ�ģ�      ����/��ʾԪ��
'
'   ���룺      Element: Ҫ����/��ʾ��Ԫ��
'               isShow:  Ҫ���ػ���ʾ��Ԫ��
'                        ��ѡ��Ĭ������
' ***********************************************************************
Sub HideShow(Element, Optional isShow As Boolean = False)
    
    Dim RefElement As Reference
    
    Set RefElement = oPart.CreateReferenceFromObject(Element)
    oHSF.GSMVisibility RefElement, isShow
    
End Sub

Public Function FixBRepName(ByVal iBRepName As String) As String
FixBRepName = iBRepName
FixBRepName = Replace(FixBRepName, "��ת��", "Shaft")
FixBRepName = Replace(FixBRepName, "��ͼ", "Sketch")
End Function

' ***********************************************************************
'   Ŀ�ģ�      ���ɵ���
'
'   ���룺      Object1: ���ô��ݡ��赹�Ǽ�����
'               iLabel: Ԫ�ر��
'               oLength:���ǳ���
' ***********************************************************************
Sub oCreateChamfer(ByRef Object1 As AnyObject, ByVal iLabel As String, oLength As Double)
Dim ref1, ref2 As Reference
Set ref1 = oPart.CreateReferenceFromName("")
Set ref2 = oPart.CreateReferenceFromBRepName(iLabel, Object1)

Dim oSF As ShapeFactory
Set oSF = oPart.ShapeFactory

Dim oChamfer1 As Chamfer
Set oChamfer1 = oSF.AddNewChamfer(ref1, catTangencyChamfer, catLengthAngleChamfer, catNoReverseChamfer, 1#, 45#)

Dim olength1 As Length
Set olength1 = oChamfer1.Length1
olength1.Value = oLength

oChamfer1.AddElementToChamfer ref2
oChamfer1.Mode = catLengthAngleChamfer
oChamfer1.Propagation = catTangencyChamfer
oChamfer1.Orientation = catNoReverseChamfer

oPart.Update
End Sub

Function GetRef(iObject As AnyObject) As Reference
GetRef = oPart.CreateReferenceFromObject(iObject)
End Function
' ***********************************************************************
'   Ŀ�ģ�      Ϊһ��Ԫ�����Լ��
'
'   ���룺      oConstraints: Լ����
'               iCstType: Լ������
'               Object1,Object2: Ԫ��
' ***********************************************************************
Sub oAddMonoEltCst(ByRef oConstraints As Constraints, ByRef oConstraint As Constraint, ByVal iCstType As CatConstraintType, ByVal Object1 As AnyObject, Optional ByVal Num As Double)

Dim oref1 As Reference
Set oref1 = oPart.CreateReferenceFromObject(Object1)

'Dim oconstraint As Constraint
Set oConstraint = oConstraints.AddMonoEltCst(iCstType, oref1)
'Dim ilength As Dimension
'Set ilength = oconstraint1.Dimension
'ilength.value = Num
'oconstraint1.Dimension.value = Num

End Sub

' ***********************************************************************
'   Ŀ�ģ�      Ϊ����Ԫ�����Լ��
'
'   ���룺      oConstraints: Լ����
'               iCstType: Լ������
'               Object1,Object2: Ԫ��
' ***********************************************************************
Sub oAddBiEltCst(ByRef oConstraints As Constraints, ByRef oConstraint As Constraint, ByVal iCstType As CatConstraintType, ByVal Object1 As AnyObject, ByVal Object2 As AnyObject, Optional ByVal Num As Double)

Dim oref1, oref2 As Reference
Set oref1 = oPart.CreateReferenceFromObject(Object1)
Set oref2 = oPart.CreateReferenceFromObject(Object2)

Set oConstraint = oConstraints.AddBiEltCst(iCstType, oref1, oref2)
'oConstraint1.Dimension.value = Num

End Sub

' ***********************************************************************
'   Ŀ�ģ�      Ϊ����Ԫ�����Լ��
'
'   ���룺      oConstraints: Լ����
'               iCstType: Լ������
'               Object1,Object2: Ԫ��
' ***********************************************************************
Sub oAddTriEltCst(ByRef oConstraints As Constraints, ByRef oConstraint As Constraint, ByVal iCstType As CatConstraintType, ByVal Object1 As AnyObject, ByVal Object2 As AnyObject, ByVal object3 As AnyObject, Optional ByVal Num As Double)

Dim oref1, oref2, oref3 As Reference
Set oref1 = oPart.CreateReferenceFromObject(Object1)
Set oref2 = oPart.CreateReferenceFromObject(Object2)
Set oref3 = oPart.CreateReferenceFromObject(object3)

Set oConstraint = oConstraints.AddTriEltCst(iCstType, oref1, oref2, oref3)
'oConstraint1.Dimension.value = Num

End Sub

