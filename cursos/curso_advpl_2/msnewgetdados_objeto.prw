#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � NGDBit   �Autor  � Ernani Forastieri  � Data �  16/10/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Uso de NewGetDados com um campo de Bitmap                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function NGDBit()
Local oDlg
Local oGetDados
Local oTPanel
Local aButtons	      := {}
Local nX		      	:= 0
Local aCpoGDa        := { "A1_COD", "A1_LOJA", "A1_NOME", "A1_CGC" }
Local aAlter       	:= NIL
Local nOpc         	:= GD_INSERT + GD_DELETE + GD_UPDATE
Local cLinOk       	:= "AllwaysTrue"
Local cTudoOk      	:= "AllwaysTrue"
Local cFieldOk     	:= "AllwaysTrue"
Local cDelOk         := "AllwaysTrue"
Local cIniCpos     	:= NIL
Local nFreeze      	:= 000
Local nMax         	:= 999
Local cSuperDel      := NIL
Local aHeader     	:= {}
Local aCols        	:= {}
Local nLinha         := 0
Local nI := 0

INCLUI := .F.
ALTERA := .T.

RegToMemory( 'SA1', .T.,, .F. )

//���������������������Ŀ
//� Montagem do aHeader �
//�����������������������

//���������������������������������������������������Ŀ
//� O campo que vai receber o Bitmap pode ser um campo�
//� virtual criado no SX3 ou direto no header sem nem �
//� existir no SX3                                    �
//�����������������������������������������������������
aAdd( aHeader, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'Enable', 'V', 'S' } )

// Carrega aHeader
dbSelectArea( "SX3" )
SX3->( dbSetOrder( 2 ) ) // Campo
For nX := 1 to Len( aCpoGDa )
	If SX3->( dbSeek( aCpoGDa[nX] ) )
		aAdd( aHeader, { AlLTrim( X3Titulo() ), ; // 01 - Titulo
		SX3->X3_CAMPO	, ;			// 02 - Campo
		SX3->X3_Picture	, ;			// 03 - Picture
		SX3->X3_TAMANHO	, ;			// 04 - Tamanho
		SX3->X3_DECIMAL	, ;			// 05 - Decimal
		SX3->X3_Valid  	, ;			// 06 - Valid
		SX3->X3_USADO  	, ;			// 07 - Usado
		SX3->X3_TIPO   	, ;			// 08 - Tipo
		SX3->X3_F3		   , ;			// 09 - F3
		SX3->X3_CONTEXT   , ;         // 10 - Contexto
		SX3->X3_CBOX	  , ; 		// 11 - ComboBox
		SX3->X3_RELACAO   , ;         // 12 - Relacao
		SX3->X3_INIBRW  , ;			// 13 - Inicializador Browse
		SX3->X3_Browse  , ;			// 14 - Mostra no Browse
		SX3->X3_VISUAL  } )
	EndIf
Next nX


//�������������������Ŀ
//� Montagem do aCols �
//���������������������

SA1->( dbSetOrder( 1 ) )
SA1->( dbGoTop() )

While !SA1->( EOF() )
	
	aAdd( aCols, Array( Len( aHeader ) + 1 ) )
	nLinha++ 
	
	//����������������������������������������������Ŀ
	//� Aqui vai a regra para o Bitmap a ser exibido �
	//������������������������������������������������
	aCOLS[ nlinha, 1 ] := Iif( Mod(Val(SA1->A1_COD),2)==0, 'ENABLE', 'DISABLE' )
	
	For nI := 2 To Len( aHeader )
		
		cX3Campo := AlLTrim( aHeader[nI][2] )
		
		If aHeader[nI][10] == 'V'
			aCols[nLinha][nI] := CriaVar( cX3Campo, .T. )
			
		Else
			aCols[nLinha][nI] := &( 'SA1->' + cX3Campo )
			
		EndIf
		
	Next
	aCols[nLinha][Len( aHeader ) + 1] := .F.
	
	SA1->( dbSkip() )
End


DEFINE MSDIALOG oDlg TITLE "NewGetDados com Campo Bitmap" FROM 065, 000 TO 350, 550 PIXEL

	oGetDados := MsNewGetDados():New( 012, 002, 120, 265, nOpc, cLinOk, cTudoOk, cIniCpos, aAlter, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oDlg, aHeader, aCols )
	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oTPanel := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel:Align := CONTROL_ALIGN_BOTTOM
	
	@ 5,1   BITMAP oBmp RESNAME "DISABLE" OF oTPanel SIZE 20,20 NOBORDER PIXEL
	@ 5,10  SAY "C�digo par" OF oTPanel SIZE 100,10 PIXEL
	@ 5,50  BITMAP oBmp RESNAME "ENABLE" OF oTPanel SIZE 20,20 NOBORDER PIXEL
	@ 5,59  SAY "C�digo �mpar" OF oTPanel SIZE 100,10 PIXEL	
	
ACTIVATE MSDIALOG oDlg CENTERED  ON INIT EnchoiceBar( oDlg, { || Alert( "A��o do OK" ) }, { || Alert( "A��o do Cancel" ), oDlg:End() },, aButtons )

Return