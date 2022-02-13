#include "topconn.ch"        
#include "tbiconn.ch"   
#include "protheus.ch" 
#include "rwmake.ch"                        
             
#define GETF_ONLYSERVER		0 

Static __aMenu
Static __aGroup
Static __aOptions
Static __aTables  


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGA002   � Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �MANUTENCAO DE ACESSOS - MENU                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                          
User Function CFGA002()

//������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                    �
//��������������������������������������������������������������
Local aArea    := GetArea()   

Private cAlias    := "SZU"
Private aRotina   := {}    
Private cCadastro := "Cadastro de Menus"


u_GerA0003(ProcName())

/*/
+----------------------------------------------------------------+
| Define Array contendo as Rotinas a executar do programa        |
| ----------- Elementos contidos por dimensao -------------------| 
| 1. Nome a aparecer no cabecalho                                |
| 2. Nome da Rotina associada                                    |
| 3. Usado pela rotina                                           |
| 4. Tipo de Transacao a ser efetuada                            |
|                                                                |
| 1 - Pesquisa e Posiciona em um Banco de Dados                  |
| 2 - Simplesmente Mostra os Campos                              |
| 3 - Inclui registros no Bancos de Dados                        |
| 4 - Altera o registro corrente                                 |
| 5 - Remove o registro corrente do Banco de Dados               |
+----------------------------------------------------------------+
/*/

//������������������������������������������������������������Ŀ
//� Menu                                                       �
//��������������������������������������������������������������
aAdd( aRotina, {"Pesquisar"  , "AxPesqui"    , 0, 1})
aAdd( aRotina, {"Visualizar" , "U_CFGA02VISU", 0, 2})
aAdd( aRotina, {"Incluir"    , "U_CFGA02INCL", 0, 3})
aAdd( aRotina, {"Alterar"    , "U_CFGA02ALTR", 0, 4})
aAdd( aRotina, {"Excluir"    , "U_CFGA02EXCL", 0, 5})
aAdd( aRotina, {"Gera Menus" , "U_CFGA02GXNU", 0, 2})

//������������������������������������������������������������Ŀ
//� Browser                                                    �
//��������������������������������������������������������������
dbSelectArea(cAlias)
dbSetOrder(1)

dbSelectArea(cAlias)
mBrowse( 6,1,22,75,cAlias)

RestArea(aArea)

Return 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGA02VISU� Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �MANUTENCAO DE ACESSOS - VISUALIZAR                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                              
User Function CFGA02VISU(cAlias,nReg,nOpcx)

//������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                    �
//��������������������������������������������������������������
Local aArea     := GetArea()
Local oGetDad
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local lContinua := .T.
Local lQuery    := .F.
Local cCadastro := "Cadastro de Menus"
Local cQuery    := ""
Local cTrab     := "SZV"
Local bWhile    := {|| .T. }
Local aObjects  := {}
Local aPosObj   := {}
Local aSizeAut  := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}

//������������������������������������������������������������Ŀ
//� Montagem de variaveis de memoria                           �
//��������������������������������������������������������������
dbSelectArea("SZU")
dbSetOrder(1)
For nCntFor := 1 To FCount()
	M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
Next nCntFor

//������������������������������������������������������������Ŀ
//� Montagem do aHeader                                        �
//��������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZV")

While (!Eof() .And. SX3->X3_ARQUIVO == "SZV" )
	If (X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)
		nUsado++
		aAdd(aHeader,{Trim(X3Titulo()),;
		Trim(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo   

//������������������������������������������������������������Ŀ
//� Montagem do Acols                                          �
//��������������������������������������������������������������
dbSelectArea("SZV")
dbSetOrder(1)

lQuery := .T.
cQuery := "SELECT *,R_E_C_N_O_ SZVRECNO FROM " + RetSqlName("SZV") + " SZV "
cQuery += " WHERE SZV.ZV_FILIAL = '" + xFilial("SZV") + "' " 
cQuery += "		AND SZV.ZV_CODUSR = '" + SZU->ZU_CODUSR + "' "
cQuery += "		AND SZV.ZV_EMPFIL = '" + SZU->ZU_EMPFIL + "' "
cQuery += "		AND SZV.ZV_MODULO = '" + SZU->ZU_MODULO + "' "
cQuery += "		AND SZV.D_E_L_E_T_ <> '*' "
cQuery += "	ORDER BY " + SqlOrder(SZV->(IndexKey()))
cQuery := ChangeQuery(cQuery)

cTrab  := "CFG02VIS"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)

For nCntFor := 1 To Len(aHeader)
	TcSetField(cTrab,AllTrim(aHeader[nCntFor][2]),aHeader[nCntFor,8],aHeader[nCntFor,4],aHeader[nCntFor,5])
Next nCntFor

SZV->(MsSeek(xFilial("SZV") + SZU->ZU_CODUSR + SZU->ZU_EMPFIL + SZU->ZU_MODULO))
bWhile := {|| xFilial("SZV") == SZV->ZV_FILIAL ;
		.And. SZU->ZU_CODUSR == SZV->ZV_CODUSR ;
		.And. SZU->ZU_EMPFIL == SZV->ZV_EMPFIL ; 
        .And. SZU->ZU_MODULO == SZV->ZV_MODULO }

While (!Eof() .And. Eval(bWhile))
	
	aAdd(aCols, Array(nUsado+1))
	
	For nCntFor := 1 To nUsado
		If (aHeader[nCntFor][10] != "V")
			aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
		Else
			If (lQuery)
				SZV->(dbGoto((cTrab)->SZVRECNO))
			EndIf
		aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
		EndIf
	Next nCntFor
	
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	dbSelectArea(cTrab)
	dbSkip()
EndDo

If (lQuery)
	dbSelectArea(cTrab)
	dbCloseArea()
	dbSelectArea(cAlias)
EndIf

aObjects := {}
aAdd(aObjects, {315, 050, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.}) 

aInfo   := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
aPosObj := MsObjSize(aInfo, aObjects, .T.)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7], 000 TO aSizeAut[6], aSizeAut[5] OF oMainWnd PIXEL
	EnChoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)
	oGetDad := MSGetDados():New(aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpcx, "AllwaysTrue", "AllwaysTrue", "", .F.)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

RestArea(aArea)

Return (.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGA02INCL� Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �MANUTENCAO DE ACESSOS - INCLUIR                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                              
User Function CFGA02INCL(cAlias,nReg,nOpcx)

//������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                    �
//��������������������������������������������������������������
Local aArea     := GetArea()
Local oGetDad
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local cCadastro := "Cadastro de Menus"
Local cQuery    := ""
Local cTrab     := "SZV"
Local aObjects  := {}
Local aPosObj   := {}
Local aSizeAut  := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}

//������������������������������������������������������������Ŀ
//� Montagem de variaveis de memoria                           �
//��������������������������������������������������������������
dbSelectArea("SZU")
dbSetOrder(1)
For nCntFor := 1 To FCount()
	M->&(FieldName(nCntFor)) := CriaVar(FieldName(nCntFor))
Next nCntFor

//������������������������������������������������������������Ŀ
//� Montagem do aHeader                                        �
//��������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZV")

While (!Eof() .And. SX3->X3_ARQUIVO == "SZV" )
	If (X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)
		nUsado++
		aAdd(aHeader,{Trim(X3Titulo()),;
		Trim(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo   

//������������������������������������������������������������Ŀ
//� Montagem do Acols                                          �
//��������������������������������������������������������������
aAdd(aCols, Array(nUsado+1))

For nCntFor := 1 To nUsado
	aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
Next nCntFor

aCols[1][Len(aHeader)+1] := .F.

aObjects := {}
aAdd(aObjects, {315, 050, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})

aInfo   := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
aPosObj := MsObjSize(aInfo, aObjects, .T.)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7], 000 TO aSizeAut[6], aSizeAut[5] OF oMainWnd PIXEL
	EnChoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)
	@ 70, 10 BUTTON "Obter Acessos" OF oDlg PIXEL SIZE 70,12 ACTION U_CFGA02IMPT(1)
	oGetDad := MSGetDados():New(aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpcx, "AllwaysTrue", "AllwaysTrue", "", .T.,,,, 999)
ACTIVATE MSDIALOG oDlg ON INIT ;
	EnchoiceBar(oDlg, {||nOpcA:=If(oGetDad:TudoOk() .And. Obrigatorio(aGets,aTela), 1, 0),;
	If(nOpcA==1,oDlg:End(),Nil)},{||oDlg:End()})   
	
If ( nOpcA == 1 )
	Begin Transaction
		CFG02GRV(1)
		If ( __lSX8 )
			ConfirmSX8()
		EndIf
		EvalTrigger()
	End Transaction
Else
	If ( __lSX8 )
		RollBackSX8()
	EndIf
EndIf

RestArea(aArea)

Return(.T.)    


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGA02ALTR� Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �MANUTENCAO DE ACESSOS - ALTERAR                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                              
User Function CFGA02ALTR(cAlias,nReg,nOpcx)

//������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                    �
//��������������������������������������������������������������
Local aArea     := GetArea()
Local cCadastro := "Cadastro de Menus"
Local oGetDad
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local lContinua := .T.
Local cQuery    := ""
Local cTrab     := "SZV"
Local bWhile    := {|| .T. }
Local aObjects  := {}
Local aPosObj   := {}
Local aSizeAut  := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}

//������������������������������������������������������������Ŀ
//� Montagem de variaveis de memoria                           �
//��������������������������������������������������������������
dbSelectArea("SZU")
dbSetOrder(1)

lContinua := SoftLock("SZU")

If ( lContinua )
	For nCntFor := 1 To FCount()
		M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
	
	//������������������������������������������������������������Ŀ
	//� Montagem do aHeader                                        �
	//��������������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZV")
	
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SZV" )
		If (X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)
			nUsado++
			aAdd(aHeader, {Trim(X3Titulo()),;
			Trim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT})
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	//������������������������������������������������������������Ŀ
	//� Montagem do Acols                                          �
	//��������������������������������������������������������������
	dbSelectArea("SZV")
	dbSetOrder(1)

	lQuery := .T.
	cQuery := "SELECT *,R_E_C_N_O_ SZVRECNO FROM " + RetSqlName("SZV") + " SZV "
	cQuery += " WHERE SZV.ZV_FILIAL = '" + xFilial("SZV") + "' " 
	cQuery += "		AND SZV.ZV_CODUSR = '" + SZU->ZU_CODUSR + "' "
	cQuery += "		AND SZV.ZV_EMPFIL = '" + SZU->ZU_EMPFIL + "' "
	cQuery += "		AND SZV.ZV_MODULO = '" + SZU->ZU_MODULO + "' "
	cQuery += "		AND SZV.D_E_L_E_T_ <> '*' "
	cQuery += "	ORDER BY " + SqlOrder(SZV->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	
	cTrab  := "CFG02VIS"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)
	
	For nCntFor := 1 To Len(aHeader)
		TcSetField(cTrab, AllTrim(aHeader[nCntFor][2]), aHeader[nCntFor, 8],;
		aHeader[nCntFor, 4], aHeader[nCntFor, 5])
	Next nCntFor

	SZV->(MsSeek(xFilial("SZV") + SZU->ZU_CODUSR + SZU->ZU_EMPFIL + SZU->ZU_MODULO))
	bWhile := {|| xFilial("SZV") == SZV->ZV_FILIAL ;
	         .And. SZU->ZU_CODUSR == SZV->ZV_CODUSR ;
	 		 .And. SZU->ZU_EMPFIL == SZV->ZV_EMPFIL ; 
             .And. SZU->ZU_MODULO == SZV->ZV_MODULO }

	While ( !Eof() .And. Eval(bWhile) )

		aAdd(aCols, Array(nUsado+1))
		
		For nCntFor := 1 To nUsado
			If (aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
			Else
				If ( lQuery )
					SZV->(dbGoto((cTrab)->SZVRECNO))
				EndIf
				aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
			EndIf
		Next nCntFor

		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		
		dbSelectArea(cTrab)
		dbSkip()
	EndDo

	If (lQuery)
		dbSelectArea(cTrab)
		dbCloseArea()
		dbSelectArea(cAlias)
	EndIf
	
EndIf

If (lContinua)
	
	aObjects := {}
	aAdd(aObjects, {315, 050, .T., .T.})
	aAdd(aObjects, {100, 100, .T., .T.})
	
	aInfo   := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7],00 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
		EnChoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)                         
		@ 70, 10 BUTTON "Obter Acessos" OF oDlg PIXEL SIZE 70,12 ACTION U_CFGA02IMPT(1)
		oGetDad := MSGetDados():New(aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpcx, "AllwaysTrue", "AllwaysTrue", "", .T.,,,, 999)
	ACTIVATE MSDIALOG oDlg ON INIT;
		EnchoiceBar(oDlg,{||nOpca := If(oGetDad:TudoOk() .And. Obrigatorio(aGets,aTela), 1, 0),;
		If(nOpcA == 1, oDlg:End(), Nil)}, {||oDlg:End()})
		
	If ( nOpcA == 1 )
		
		Begin Transaction
			CFG02GRV(2)
			If ( __lSX8 )
				ConfirmSX8()
			EndIf
			EvalTrigger()
		End Transaction
	Else
		If ( __lSX8)
			RollBackSX8()
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGA02EXCL� Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �MANUTENCAO DE ACESSOS - EXCLUIR                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                              
User Function CFGA02EXCL(cAlias,nReg,nOpcx)

//������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                    �
//��������������������������������������������������������������
Local aArea     := GetArea()
Local cCadastro := "Cadastro de Menus"
Local oGetDad
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local lContinua := .T.
Local cQuery    := ""
Local cTrab     := "SZV"
Local bWhile    := {|| .T. }
Local aObjects  := {}
Local aPosObj   := {}
Local aSizeAut  := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}

//������������������������������������������������������������Ŀ
//� Montagem de variaveis de memoria                           �
//��������������������������������������������������������������
dbSelectArea("SZU")
dbSetOrder(1)

lContinua := SoftLock("SZU")

If (lContinua)
	For nCntFor := 1 To FCount()
		M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
	Next nCntFor

	//������������������������������������������������������������Ŀ
	//� Montagem do aHeader                                        �
	//��������������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZU")
	
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SZV" )
		If (X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			aAdd(aHeader, {Trim(X3Titulo()),;
			Trim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo

	//������������������������������������������������������������Ŀ
	//� Montagem do Acols                                          �
	//��������������������������������������������������������������
	dbSelectArea("SZV")
	dbSetOrder(1)
	
	lQuery := .T.
	cQuery := "SELECT *,R_E_C_N_O_ SZVRECNO FROM " + RetSqlName("SZV") + " SZV "
	cQuery += " WHERE SZV.ZV_FILIAL = '" + xFilial("SZV") + "' " 
	cQuery += "		AND SZV.ZV_CODUSR = '" + SZU->ZU_CODUSR + "' "
	cQuery += "		AND SZV.ZV_EMPFIL = '" + SZU->ZU_EMPFIL + "' "
	cQuery += "		AND SZV.ZV_MODULO = '" + SZU->ZU_MODULO + "' "
	cQuery += "		AND SZV.D_E_L_E_T_ <> '*' "
	cQuery += "	ORDER BY " + SqlOrder(SZV->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	
	cTrab  := "CFG02VIS"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)

	For nCntFor := 1 To Len(aHeader)
		TcSetField(cTrab, AllTrim(aHeader[nCntFor][2]), aHeader[nCntFor,8],;
		aHeader[nCntFor,4], aHeader[nCntFor,5])
	Next nCntFor


	SZV->(MsSeek(xFilial("SZV") + SZU->ZU_CODUSR + SZU->ZU_EMPFIL + SZU->ZU_MODULO))
	bWhile := {|| xFilial("SZV") == SZV->ZV_FILIAL ;
	         .And. SZU->ZU_CODUSR == SZV->ZV_CODUSR ;
	 		 .And. SZU->ZU_EMPFIL == SZV->ZV_EMPFIL ; 
             .And. SZU->ZU_MODULO == SZV->ZV_MODULO }

	While (!Eof() .And. Eval(bWhile))
		
		aAdd(aCols, Array(nUsado+1))
		
		For nCntFor := 1 To nUsado
			If (aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
			Else
				If (lQuery)
					SZV->(dbGoto((cTrab)->SZVRECNO))
				EndIf
				aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
			EndIf
		Next nCntFor

		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		
		dbSelectArea(cTrab)
		dbSkip()
	EndDo
	
	If (lQuery)
		dbSelectArea(cTrab)
		dbCloseArea()
		dbSelectArea(cAlias)
	EndIf
	
EndIf

If (lContinua)
	aObjects := {}
	aAdd(aObjects, {315, 050, .T., .T.})
	aAdd(aObjects, {100, 100, .T., .T.})

	aInfo   := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7], 000 TO aSizeAut[6], aSizeAut[5] OF oMainWnd PIXEL
		EnChoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)
		oGetDad := MSGetDados():New(aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpcx, "AllwaysTrue", "AllwaysTrue", "", .F.)
	ACTIVATE MSDIALOG oDlg ON INIT;
		EnchoiceBar(oDlg, {||nOpca:=If(oGetDad:TudoOk(), 1, 0), If(nOpcA == 1, oDlg:End(), Nil)}, {||oDlg:End()})

	If ( nOpcA == 1 )
		Begin Transaction
			CFG02GRV(3)
			EvalTrigger()
		End Transaction
	EndIf
	
EndIf 

RestArea(aArea)

Return (.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGA02IMPT� Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �MANUTENCAO DE ACESSOS - IMPORTAR                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                              
User Function CFGA02IMPT(nPar)

//������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                    �
//��������������������������������������������������������������

//Local cFOpen    := cGetFile("Arquivos XNU|*.XNU|", "Abrir Arquivo...", 0, "E:\Protheus10\Protheus_Data\menus\", .T., GETF_ONLYSERVER)
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cFOpen    := cGetFile("Arquivos XNU|*.XNU|", "Abrir Arquivo...", 0, cRootPath +"\menus\", .T., GETF_ONLYSERVER)
Local aArea     := GetArea() 

__aMenu			:= XNULoad( cFOpen )
__aGroup		:= {}
__aOptions		:= {}
__aTables		:= {}
nGroupId		:= 0

//������������������������������������������������������������Ŀ
//� Tratamento para array padrao do menu                       �
//��������������������������������������������������������������
For nMaster := 1 To Len( __aMenu )
	cMasterTitle	:= __aMenu[ nMaster , 1 , 1 ]
	aSubTitle			:= {}
	nSubGroup			:= 0

	SplitMenu(;
	cMasterTitle			,;
	nMaster					,;
	__aMenu[ nMaster , 3 ]	,;
	""      				,;
	@__aGroup				,;
	@__aOptions				,;
	@__aTables				,;
	@nGroupId				,;
	aSubTitle				,;
	nSubGroup				 ;
	)
	
Next nMaster 

//��������������������������������������������������������������Ŀ
//� Coloca o Ponteiro do Mouse em Estado de Espera			     �
//����������������������������������������������������������������
CursorWait()

Begin Sequence

//������������������������������������������������������������Ŀ
//� Inclui Menus                                               �
//��������������������������������������������������������������
If nPar == 1
	nItem := 1
	
	For nMaster := 1 To Len(__aOptions)
		
		//������������������������������������������������������������������Ŀ
		//� Cria linha em branco no acols de acordo com o tamanho do aHeader �
		//��������������������������������������������������������������������
		If nItem <> 1
			Aadd(aCols, Array(Len(aHeader)+1))
			aCols[Len(aCols), Len(aHeader)+1] := .f.
		EndIf
		
		nItem++
		
		For _x := 1 TO Len(aHeader)
			
			//��������������������������������������������������������Ŀ
			//� Preenche cada elemento da linha do aCols com seu valor �
			//����������������������������������������������������������
			If _x == 2
				aCols[Len(aCols), _x] := __aOptions[nMaster][4]               //Acessos
			ElseIf _x == 1
				aCols[Len(aCols), _x] := __aOptions[nMaster][3]               //Funcao
			EndIf
			
		Next
		
		GetdRefresh()
		
	Next nMaster
	
EndIf    

End Sequence   

//��������������������������������������������������������������Ŀ
//�Restaura o Estado do Ponteiro do Mouse						 �
//����������������������������������������������������������������
CursorArrow()

RestArea(aArea)

MsgInfo("Opera��o realizada com sucesso!")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFG02GRV  � Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �MANUTENCAO DE ACESSOS - GRAVAR                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/    
Static Function CFG02GRV(nOpc)

//������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                    �
//��������������������������������������������������������������
Local aArea     := GetArea()
Local aRegistro := {}
Local cQuery    := ""
Local lGravou   := .F.
Local nCntFor   := 0
Local nCntFor2  := 0
Local nUsado    := Len(aHeader)

//������������������������������������������������������������Ŀ
//| Guarda os registros em um array para atualizacao           |
//��������������������������������������������������������������
dbSelectArea("SZV")
dbSetOrder(1)          

cQuery := "SELECT SZV.R_E_C_N_O_ SZVRECNO FROM " + RetSqlName("SZV") + " SZV "
cQuery += " WHERE SZV.ZV_FILIAL = '" + xFilial("SZV") + "' " 
cQuery += "		AND SZV.ZV_CODUSR = '" + M->ZU_CODUSR + "' "
cQuery += "		AND SZV.ZV_EMPFIL = '" + M->ZU_EMPFIL + "' "
cQuery += "		AND SZV.ZV_MODULO = '" + M->ZU_MODULO + "' "
cQuery += "		AND SZV.D_E_L_E_T_ <> '*' "
cQuery += "	ORDER BY " + SqlOrder( SZV->( IndexKey() ) )
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "CFG02GRV", .T., .T. )

dbSelectArea("CFG02GRV")
While (!Eof())
	aAdd( aRegistro, SZVRECNO)
	dbSelectArea("CFG02GRV")
	dbSkip()
EndDo

dbSelectArea("CFG02GRV")
dbCloseArea()        

dbSelectArea("SZV")

Do Case
	//������������������������������������������������������������Ŀ
	//| Inclusao / Alteracao                                       |
	//��������������������������������������������������������������
	Case nOpc != 3
		For nCntFor := 1 To Len(aCols)
			If ( nCntFor > Len(aRegistro) )
				If ( !aCols[nCntFor][nUsado+1] )
					RecLock("SZV",.T.)
				EndIf
			Else
				SZV->(dbGoto(aRegistro[nCntFor]))
				RecLock("SZV")
			EndIf
			
			If ( !aCols[nCntFor][nUsado+1] )
				lGravou := .T.
				For nCntFor2 := 1 To nUsado
					If ( aHeader[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				//������������������������������������������������������������Ŀ
				//| Grava os campos obrigatorios                               |
				//��������������������������������������������������������������
				SZV->ZV_FILIAL := xFilial("SZV")
				SZV->ZV_CODUSR := M->ZU_CODUSR
				SZV->ZV_EMPFIL := M->ZU_EMPFIL
	            SZV->ZV_MODULO := M->ZU_MODULO 
	            
			Else
				If ( nCntFor <= Len(aRegistro) )
					dbDelete()
				EndIf	            
			EndIf
			
			MsUnLock()
		Next nCntFor
	//������������������������������������������������������������Ŀ
    //| Exclusao                                                   |
	//��������������������������������������������������������������
	OtherWise
		For nCntFor := 1 To Len(aRegistro)
			SZV->(dbGoto(aRegistro[nCntFor]))
			RecLock("SZV")
				dbDelete()
			MsUnLock()
		Next nCntFor
EndCase

//������������������������������������������������������������Ŀ
//| Atualizacao do cabecalho                                   |
//��������������������������������������������������������������
dbSelectArea("SZU")
dbSetOrder(1)
If ( MsSeek( xFilial("SZU") + M->ZU_USR + M->ZU_EMPFIL + M->ZU_MODULO ))
	RecLock("SZU")
Else
	If (lGravou)
		RecLock("SZU",.T.)
	EndIf
EndIf

If (!lGravou)
	dbDelete()
Else
	For nCntFor := 1 To SZU->(FCount())
		If (FieldName(nCntFor) != "ZU_FILIAL" )
			FieldPut(nCntFor, M->&(FieldName(nCntFor)))
		Else
			SZU->ZU_FILIAL := xFilial("SZU")
		EndIf
	Next nCntFor                                        
EndIf

MsUnLock()   

//������������������������������������������������������������Ŀ
//| Restaura integridade da rotina                             | 
//��������������������������������������������������������������
RestArea(aArea)

Return( .T. )        

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SPLITMENU � Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �DIVIDI ARRAY DE MENU PADRAO EM GRUPO, SUBGRUPOS E TABELAS   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/    
Static Function SplitMenu(;
							cMasterTitle	,;
							nMaster			,;
							aMenu			,;
							cLanguage		,;
							aGroup			,;
							aOptions		,;
							aTables			,;
							nGroupId		,;
							aSubTitle		,;
							nSubGroup		 ;
						 )

Local aTmpTables

Local cTitle
Local cStatus
Local cSubTitle

Local nGroup
Local nGroups
Local nTable
Local nTables

nGroups := Len( aMenu )
For nGroup := 1 To nGroups
	cStatus := aMenu[ nGroup , 2 ]
	IF ( cStatus == "H" .Or. cStatus == "D" )
		Loop
	EndIF
	cTitle	:= aMenu[ nGroup , 1 , 1 ]
	IF ( ValType( aMenu[ nGroup , 3 ] ) == "A" )
			aAdd( aGroup , {;
								nMaster				,;
								++nGroupId			,;
								cTitle				,;
								Space(10)			,;
								Replicate("x",10)	,;
								Space( 10 )			,;
								nSubGroup			 ;
							};
				)
		IF ( nSubGroup == 0 )
			aSubTitle := {}
		EndIF
		aAdd( aSubTitle , cTitle )
		IF ( cStatus == "E" )
			SplitMenu(;
						cMasterTitle			,;
						nMaster					,;
						aMenu[ nGroup , 3 ]		,;
						cLanguage				,;
						@aGroup					,;
						@aOptions				,;
						@aTables				,;
						@nGroupId				,;
						@aSubTitle				,;
						nGroup				 	 ;
					 )
		EndIF
	Else
		IF ( cStatus <> "D" )
			aTmpTables	:= aMenu[ nGroup , 4 ]
			nTables		:= Len( aTmpTables )
			For nTable := 1 To nTables
				IF ( aScan( aTables , { |cTable| ( cTable == aTmpTables[ nTable ] ) } ) == 0 )
					aAdd( aTables , aTmpTables[ nTable ] )
				EndIF
			Next nTable
		    cSubTitle := ( cMasterTitle + "->" )
		    aEval( aSubTitle , { |cTitle| cSubTitle += ( cTitle + "->" ) } )
		    cSubTitle += cTitle
		    aAdd( aOptions , {;
		    					nMaster				,;
		    					cTitle				,;
		    					aMenu[ nGroup , 3 ]	,;
		    					aMenu[ nGroup , 5 ]	,;
		    					aMenu[ nGroup , 6 ]	,;
		    					nGroupId			,;
		    					cSubTitle			,;
		    					nSubGroup			,;
		    					aClone( aTmpTables ),;
		    					aMenu[ nGroup , 7 ] ;		    					
		    				 };
		    	 )
		EndIF
	EndIF
Next nGroup

Return( NIL )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGA02GXNU� Autor �Paulo Lopez         � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao �GERA XNU DOS USUARIOS                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/    
User Function CFGA02GXNU()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                             �
//�����������������������������������������������������������������������
Local cQry                       
Local cPath      := "\menus\"
Local aDirectory := Directory(cPath + "*.xnu")   // Identifica todos os arquivos do DIR

Private cArqTxt 
Private nHdlTxt 

//���������������������������������������������������������������������Ŀ
//� Apaga arquivos xnu do diretorio                                     �
//�����������������������������������������������������������������������
aEval(aDirectory, {|x| FErase(cPath + x[1])}) 

//���������������������������������������������������������������������Ŀ
//� Query                                                               �
//�����������������������������������������������������������������������
cQry := "SELECT RTRIM(ZV_CODUSR)  AS USUARIO, "
cQry += "       RTRIM(ZV_EMPFIL)  AS EMPFIL, "
cQry += "       RTRIM(ZV_MODULO)  AS MODULO, "
cQry += "       RTRIM(ZS_SIGLA)   AS SIGLA, "
cQry += "       RTRIM(ZX_TIPOGRF) AS TIPOGRF, "
cQry += "       RTRIM(ZX_DESCGRF) AS SUBGRUPO, "
cQry += "       RTRIM(ZV_FUNCAO)  AS FUNCAO, "
cQry += "       RTRIM(ZX_TIPO)    AS TIPOF, "
cQry += "       RTRIM(ZX_DESCRI)  AS DESFUNC, "
cQry += "       RTRIM(ZX_TABELAS) AS TABELAS, "
cQry += "       RTRIM(LOWER(ZV_ACESSO)) AS ACESSO "	 
cQry += "FROM " + RetSqlName("SZV") + " SZV "
cQry += "LEFT JOIN " + RetSqlName("SZX") + " SZX "
cQry += "ON (ZV_FUNCAO = ZX_FUNCAO) "
cQry += "LEFT JOIN " + RetSqlName("SZS") + " SZS "
cQry += "ON (ZV_MODULO = ZS_CODIGO) "
cQry += "WHERE SZV.D_E_L_E_T_ <> '*' "
cQry += "      AND SZX.D_E_L_E_T_ <> '*' "
cQry += "      AND SZS.D_E_L_E_T_ <> '*' "
cQry += "      AND ZV_FILIAL = '" + xFilial("SZV") + "' "
cQry += "ORDER BY USUARIO, EMPFIL, MODULO, TIPOGRF, SUBGRUPO, DESFUNC " 

MemoWrite("cfga002.sql", cQry)

TCQUERY cQry NEW ALIAS QRY

//���������������������������������������������������������������������Ŀ
//� Processamento                                                       �
//�����������������������������������������������������������������������
dbSelectArea("QRY")
dbGoTop()

CursorWait()

While !EOF("QRY")

	cWhen    := QRY->USUARIO + QRY->EMPFIL + QRY->MODULO
	         
	cXnuPath := AllTrim(cWhen)

	cMenu    :=	'<ApMenu>' + chr(13) + chr(10)
	cMenu    +=	chr(9) + '<DocumentProperties>' + chr(13) + chr(10)
	cMenu    +=	chr(9) + chr(9) + '	<Module>SIGA' + AllTrim(QRY->SIGLA) + '</Module>' + chr(13) + chr(10)
	cMenu    +=	chr(9) + chr(9) + '	<Version>8.11</Version>' + chr(13) + chr(10)
	cMenu    +=	chr(9) + '</DocumentProperties>' + chr(13) + chr(10)

	While !EOF("SZV") .And. QRY->USUARIO + QRY->EMPFIL + QRY->MODULO == cWhen
	                           
		cTipo := QRY->TIPOGRF

		cMenu   +=	chr(9) + '<Menu Status="Enable">' + chr(13) + chr(10)
		
		Do Case
			Case cTipo == "1"                                 
				cMenu   +=	chr(9) + chr(9) + '<Title lang="pt">Atualiza��es</Title>' + chr(13) + chr(10)
			Case cTipo == "2"                                 
				cMenu   +=	chr(9) + chr(9) + '<Title lang="pt">Consultas</Title>' + chr(13) + chr(10)
			Case cTipo == "3"                                 
				cMenu   +=	chr(9) + chr(9) + '<Title lang="pt">Relat�rios</Title>' + chr(13) + chr(10)
			Case cTipo == "4"                                 
				cMenu   +=	chr(9) + chr(9) + '<Title lang="pt">Miscel�nea</Title>' + chr(13) + chr(10)
		EndCase
			
		While !EOF("SZV") .And.;
		      QRY->USUARIO + QRY->EMPFIL + QRY->MODULO == cWhen .And.;
		      QRY->TIPOGRF == cTipo   
		      
		      cGrpFunc := QRY->SUBGRUPO
		      
              cMenu    +=	chr(9) + chr(9) + '	<Menu Status="Enable">' + chr(13) + chr(10)
			  cMenu    +=	chr(9) + chr(9) + chr(9) + '<Title lang="pt">' + AllTrim(cGrpFunc) + '</Title>' + chr(13) + chr(10)
		      
		      While !EOF("SZV").And.;
		            QRY->USUARIO + QRY->EMPFIL + QRY->MODULO == cWhen .And.;
                    QRY->TIPOGRF == cTipo .And.;
                    QRY->SUBGRUPO == cGrpFunc                                     
				                    
					cMenu    +=	chr(9) + chr(9) + chr(9) + '<MenuItem Status="Enable">' + chr(13) + chr(10)
					cMenu    +=	chr(9) + chr(9) + chr(9) + chr(9) +; 
					            '<Title lang="pt">' +;
					            AllTrim(QRY->DESFUNC) +;
					            '</Title>' + chr(13) + chr(10)
					cMenu    +=	chr(9) + chr(9) + chr(9) + chr(9) +;
					           '<Function>' + AllTrim(QRY->FUNCAO) + '</Function>' + chr(13) + chr(10)
					cMenu    +=	chr(9) + chr(9) + chr(9) + chr(9) +;
								'<Type>' + QRY->TIPOF + '</Type>' + chr(13) + chr(10)
                                           
					cTabelas := QRY->TABELAS
					
					For nLoop := 1 to Len( cTabelas ) Step 4
						If !Empty( Substr( cTabelas, nLoop, 3 ) )
							cMenu    +=	chr(9) + chr(9) + chr(9) + chr(9) +;
									    '<Tables>' + Substr( cTabelas, nLoop, 3 ) + '</Tables>' + chr(13) + chr(10)
						EndIf
					Next nLoop

					cMenu    +=	chr(9) + chr(9) + chr(9) + chr(9) +;	
								'<Access>' + Lower(QRY->ACESSO) + '</Access>' + chr(13) + chr(10)
					cMenu    +=	chr(9) + chr(9) + chr(9) + chr(9) +;	
								'<Module>' + QRY->MODULO + '</Module>' + chr(13) + chr(10)
					cMenu    +=	chr(9) + chr(9) + chr(9) +;									
								'</MenuItem>' + chr(13) + chr(10)                  
	    
				    dbSelectArea("QRY")
					dbSkip()
		
			  EndDo           
			  
			  cMenu    +=	chr(9) + chr(9) + '</Menu>' + chr(13) + chr(10)   

		EndDo                                                                  
		
        cMenu    +=	chr(9) + '</Menu>' + chr(13) + chr(10)   
        
  	EndDo
    
    cMenu    +=	'</ApMenu>' + chr(13) + chr(10)  
    
	//���������������������������������������������������������������������Ŀ
	//� Grava arquivo                                                       �
	//�����������������������������������������������������������������������
	cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
	cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )  
	cArqTxt :=  cRootPath + cPath + cXnuPath + ".xnu"
	nHdlTxt := fCreate(cArqTxt)  
	
	If nHdlTxt == -1
		MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif

	If fWrite(nHdlTxt, cMenu, Len( cMenu )) != Len( cMenu )
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?", "Atencao!")
		Endif
	Endif          
	
	fClose(nHdlTxt)                        
	
EndDo

CursorArrow()
//dbCloseArea("QRY")
QRY->(dbCloseArea())

Return    