VERSION 5.00
Begin VB.Form frmAbout 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "�����ҵ�Ӧ�ó���"
   ClientHeight    =   3435
   ClientLeft      =   2340
   ClientTop       =   1935
   ClientWidth     =   4830
   ClipControls    =   0   'False
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2370.898
   ScaleMode       =   0  'User
   ScaleWidth      =   4535.62
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '����������
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   1455
      Left            =   120
      Picture         =   "frmAbout.frx":0000
      ScaleHeight     =   1425
      ScaleWidth      =   4545
      TabIndex        =   4
      Top             =   120
      Width           =   4575
   End
   Begin VB.CommandButton cmdOK 
      Cancel          =   -1  'True
      Caption         =   "ȷ��"
      Default         =   -1  'True
      Height          =   345
      Left            =   3240
      TabIndex        =   0
      Top             =   3000
      Width           =   1500
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      BorderStyle     =   6  'Inside Solid
      Index           =   1
      X1              =   0
      X2              =   4394.762
      Y1              =   1987.827
      Y2              =   1987.827
   End
   Begin VB.Label lblDescription 
      Caption         =   "By ��е2009-12�� ������"
      ForeColor       =   &H00000000&
      Height          =   330
      Left            =   120
      TabIndex        =   1
      Top             =   2400
      Width           =   3885
   End
   Begin VB.Label lblTitle 
      Caption         =   "Բ��������ά���������ϵͳ"
      ForeColor       =   &H00000000&
      Height          =   240
      Left            =   120
      TabIndex        =   2
      Top             =   1680
      Width           =   4005
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FFFFFF&
      BorderWidth     =   2
      Index           =   0
      X1              =   98.6
      X2              =   5309.399
      Y1              =   1697.936
      Y2              =   1697.936
   End
   Begin VB.Label lblVersion 
      Caption         =   "�汾"
      Height          =   225
      Left            =   120
      TabIndex        =   3
      Top             =   2040
      Width           =   3885
   End
End
Attribute VB_Name = "frmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------frmAbout------------
Option Explicit

Private Sub cmdOK_Click()
  Unload Me
End Sub

Private Sub Form_Load()
    Me.Caption = "���� " & App.Title
    lblVersion.Caption = "�汾 " & App.Major & "." & App.Minor & "." & App.Revision
End Sub

