#INCLUDE "RWMAKE.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "CHEQUE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APVT100.CH"
#DEFINE LFRC CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ tecax012 ºAutor  ³ERPPLUS - M.Munhoz  º Data ³ 13/05/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que executa a saida Massiva de Celulares no         º±±
±±º          ³ estoque e Field Service                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGATEC/SIGAEST - BGH do Brasil                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecax012()
Local cVarBar  := Replicate(" ",20)
Local cVarSIM  := Replicate(" ",20)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Especifico Coletor de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSave    := {}
Local nPosicao := 1
Local aCabec   := {"LOG..."}
Local aKits    := {}
Local aSize    := {100} 
Local aLog     := {}
Local aButtons    	:= {}
Public cTexto  := ""
Public UltReg  := .F.
Public _lFechSM:= .F.
//Public cTipo   := cTipoAux
Private oV1,oV2,oV3,oV4
Private cPerg    := "SAIZZ4"                                   
Private nTamNfe  := TAMSX3("D1_DOC")[1]
Private nTamNfs  := TAMSX3("D2_DOC")[1]                                                                  
Private cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Private _nTotal := 0000
Private _cCodCli:= ""
Private nValTot  := 0 
//Private lFirst   := .T.
u_GerA0003(ProcName())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Especifico Coletor de dados - DeltaDecisao³
//³14/10/2011                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aLidos  := {}
dbSelectArea("SA1")  //Cadastro de Clientes
dbSelectArea("SB1")  //Cadastro de Produtos
dbSelectArea("ZZ4")  //Entrada Massiva
dbSelectArea("AB7")  //Itens da OS
SA1->(dbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
ZZ4->(dbSetOrder(2)) //ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI
AB7->(DBOrderNickName("AB7NUMSER")) //AB7_FILIAL+AB7_NUMOS+AB7_NUMSER
If Upper(Alltrim(cUsername)) $ Upper(GETMV("BH_CONSKIT",.F.,"LEANDRO.CASTANHARO"))
	If ApMsgYesNo("Deseja consultar Saldo do KIT?","Consulta Saldo do KIT")
		U_BCONSKIT()
		If !ApMsgYesNo("Deseja continuar na Saida Massiva?","Saida Massiva")
			Return()	
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Habilita perguntas                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("BARZZ4",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos fontes                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFnt1  := TFont():New("Arial",18,22,,.T.,,,,.T.,.F.)
oFnt2  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
oFnt3  := TFont():New("Courier New",08,12,,.F.,,,,.F.,.F.)
oFnt4  := TFont():New("Arial",12,14,,.T.,,,,.T.,.F.) 
oFnt5  := TFont():New("Arial",12,40,,.T.,,,,.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Implantacao do coletor de dados - 14/10/2011  Delta Decisao              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IsTelNet() //Implantacao Radio Frequencia 
	VTSetKey(2,{||  MostraLids() }) //CTRL + B
	VTSetKey(3,{||  Pergunte("BARZZ4",.T.) }) //CTRL + C
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definicao das Teclas de Funcao                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetKey(VK_F9 ,{|| Pergunte("BARZZ4",.T.)}) //Tela com todos os parametros
	//SetKey(VK_F10,{|| U_ITNFE(@cTexto,cTipo)}) //Permite INSERIR Itens da NF sem numero de Série
	//SetKey(VK_F11,{|| U_CLILJ()}) //Permite mudar o Cliente e Loja     
	//SetKey(VK_F12,{|| U_PRODUTO()}) //Permite mudar o Modelo do Celular	
EndIf	
Public _SerSai := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega digitacoes anteriores de SAIDA MASSIVA - Alterado por Marcelo Munhoz - ERP PLUS - em 22/05/2007                                      ³
//³Alterado o Where do select para filtrar por sequencia de ordem de indice,  no intuido da mesma ficar mais rápida - Edson Rodrigues - 13/04/10³
//³Ordena a tabela no indice mais proximo que sera executada a query - Edson Rodrigues 12/04/10                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
_cQrySai := " SELECT ZZ4_IMEI, ZZ4_CODCLI, ZZ4_LOJA "
_cQrySai += " FROM   "+RetSqlName("ZZ4")+" (nolock) "
_cQrySai += " WHERE  ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' AND "
_cQrySai += "        ZZ4_STATUS  = '6' AND " // Saida Massiva lida/apontada
_cQrySai += "        D_E_L_E_T_ = ''  AND "
_cQrySai += "        Upper(LEFT(ZZ4_SMUSER,13)) = '"+Upper(Left(cUserName,13))+"' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySai),"X01",.T.,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
//³Volta o indice da tabela no indice que estava - Edson Rodrigues 12/04/10³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ
ZZ4->(dbSetOrder(2)) //ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI
dbSelectArea("X01")
X01->(dBGoTop())
While X01->(!Eof())
	tMemo  := "Numero serie "+X01->ZZ4_IMEI  +" já incluido"+LFRC+LFRC
	cTexto := tMemo+cTexto
	AADD(_SerSai,X01->ZZ4_IMEI  )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Implantacao coletos de dados  ³
	//³	Delta Decisao - 14/10/2011    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aLog, {"NS: "+X01->ZZ4_IMEI  +" já incluido"} )
	If Empty(_cCodCli)
  		_cCodCli:= Alltrim(X01->ZZ4_CODCLI)+Alltrim(X01->ZZ4_LOJA)
  	EndIf
	X01->(dbSkip())
EndDo
If Len(_SerSai) > 0
	tMemo  := "Foram incluidos anteriormente "+Transf(Len(_SerSai),"@E 999,999")+" aparelhos "+LFRC+LFRC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Implantacao coletos de dados  ³
	//³	Delta Decisao - 14/10/2011    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IsTelNet()
		AADD(aLog, {"Lidos "+ Alltrim(Transf(Len(_SerSai),"@E 999,999")) + " aparelhos " } )
	EndIf
	cTexto := tMemo+cTexto
EndIf
X01->(dbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adaptação para o coletor de dados                                      ³
//³ Delta Decisao - DF - 11/10/2011                                        ³
//³ Lista as etiquetas ja lidas no processo 							   ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IsTelNet() .AND. Len(aLog) > 0
	aSave := VTSAVE()
	VTClear()
	nPosicao := VTaBrowse(0,0,7,19,aCabec,aLog,aSize,,nPosicao)
	VtRestore(,,,,aSave)
	VTClearBuffer()
EndIf
aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )	
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{160,200,240,265}} )
nGetLin := aPosObj[3,1]
Aadd(aButtons,{"GRAVAR",{|| tecx012a() },"GRAVAR","GRAVAR"}) //"GRAVAR"
Aadd(aButtons,{"EXCLUIR",{|| AbreRastro(@cTexto) },"EXCLUIR","EXCLUIR"}) //"EXCLUIR"
While !_lFechSM
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adaptação para o coletor de dados                                      ³
	//³ Delta Decisao - DF - 11/10/2011                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !IsTelnet()	   
		DEFINE MSDIALOG oDlg TITLE "Saida Massiva" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		//@ 0,0 TO 460,520 DIALOG oDlg TITLE "Saida Massiva"
		oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"CodBar.bmp",.T.,oDlg)
		@ 005+10,077 SAY oV1 var "Passe a leitora de"  of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
		@ 020+10,075 SAY oV2 var "código de barras"    of oDlg FONT oFnt1 PIXEL SIZE 150,012 COLOR CLR_BLUE
		@ 050,170 SAY oV3 var "Quantidade" +Transform(_nTotal,"@E 9999") of oDlg FONT oFnt4 PIXEL SIZE 150,012 COLOR CLR_BLUE		
		@ 100,300 SAY oV4 var "Total" +Transform(nValTot,"@E 999,999.99999") of oDlg FONT oFnt5 PIXEL SIZE 150,020 COLOR CLR_RED		
		@ 050,010 GET cVarBar Size 100,080 PICTURE "@!" valid u_tecx012grv(@cVarBar,@cTexto,@cVarSim,.F.) Object oEdBar
		@ 050,130 GET "" Size 001,001 PICTURE "@!" //Tratado para atualizar o valid da variavel cvarbar
		@ 065,010 Get cTexto  Size 250,115 MEMO Object oMemo when .F. 
/*
		@ 187,180 BUTTON "GRAVAR" 		SIZE 60,13 ACTION Processa({|| tecx012a() })
		@ 202,180 BUTTON "CONFIRMA"		SIZE 60,13 ACTION Processa({|| u_tecx012c(.f.), oDlg:End(), Close(oDlg) })
		@ 217,180 BUTTON "CANCELA" 		SIZE 60,13 ACTION IIF(MSGYESNO("DESEJA REALMENTE CANCELAR? TODOS APARELHOS DEVERÃO SER APONTADOS NOVAMENTE."),tecx012b(.f.),Close(oDlg))
		@ 217,180 BUTTON "CANCELA" 		SIZE 60,13 ACTION IIF(MSGYESNO("DESEJA REALMENTE CANCELAR? TODOS APARELHOS DEVERÃO SER APONTADOS NOVAMENTE."),tecx012b(.f.),)
*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria legenda de funcoes na tela                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		tecx012leg() //	CriaLeg()
		//Activate MSDialog oDlg Centered On Init oEdBAR:SetFocus()
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||u_tecx012c(.f.), oDlg:End(), Close(oDlg)},;
		{||IIF(MSGYESNO("DESEJA REALMENTE CANCELAR? TODOS APARELHOS DEVERÃO SER APONTADOS NOVAMENTE."),tecx012b(.f.),)},,aButtons)
	Else
		VTClear()
		VTClearBuffer()
		DLVTCabec("Saida Massiva",.F.,.F.,.T.)
		@ 01, 00 VTSay "Cod. Barras" VTGet cVarBar Pict "@!" Valid u_tecx012grv(@cVarBar,@cTexto,@cVarSim,.F.)
		@ 02, 00 VTSay "Quantidade"
		@ 02, 15 VTSay Alltrim(Str(_nTotal))
		VTREAD
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tecla ESC pressionada, lista opções 	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (VTLastKey()==27)
			nOpcao := DLVTAviso("", "Opções", {"CONFIRMA", "GRAVAR", "CANCELAR"})
			Do Case
				Case nOpcao == 1  //Confirma
					u_tecx012c(.f.)
				Case nOpcao == 2  //Gravar  
					tecx012a()
				Case nOpcao == 3  //Cancelar
					If DLVTAviso("", "DESEJA REALMENTE CANCELAR? TODOS APARELHOS DEVERÃO SER APONTADOS NOVAMENTE.", {"SIM", "NAO"}) == 1
						tecx012b(.f.)
						Exit
					Else
						Loop											
					EndIf					
			End Case 
			VTClearBuffer()
		EndIf
	EndIf
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa Filtro                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbCloseArea("ZZ4")
ZZ4->(dbCloseArea())
dbSelectArea("ZZ4")
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx012grvºAutor  ³ Antonio L.F.Favero º Data ³ 27/03/2003  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava registro no ZZ4 e atualiza Memo                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx012grv(cCodBar,Memo,cVARSIM,_lAuto)
Local nVlZZ4   := 0.00 
Local lResult  := .T.
Local tMemo    := ""
Local cDescOper:= ""
Local cOpAgreg := SuperGetMV("MV_XOPEAGR",  ,"S06")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Só executa a validação se o código de barra estiver preenchido.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cCodBar) .AND.  !IsTelnet()  
	oEdBAR:SetFocus()
	Return
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado por M.Munhoz - ERP PLUS - 24/09/07.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "'" $ cCodBar .OR. "'" $ cVarSim .OR. '"' $ cCodBar .OR. '"' $ cVarSim
	If !IsTelnet()	//Implantacao Radio Frequencia - 11/10/2011
		tMemo := "------Proibido informar aspas simples ou dupla no IMEI ou Carcaçà.--------"+LFRC+LFRC
		Memo  := tMemo //+Memo
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",20)
		Close(oDlg)
	Else
		VTBEEP(3)     
	    VTAlert("------Proibido informar aspas simples ou dupla no IMEI ou Carcaçà.--------","Alerta",.t.,2500)		
   		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",20)
	EndIf
	Return
EndIf
If !_lAuto .AND. !Empty(cCodBar) .AND. Len(AllTrim(cCodBar)) <> 15 .AND. !__cUserID $ GetMV("MV_XIMEI15")  .AND. __cUserID <> "000300"
	If Len(AllTrim(cCodBar)) > 15                                
		If !IsTelNet() //Implantacao Radio Frequencia - 11/10/2011
			tMemo := "------Codigo de Barras Inválido - "+AllTrim(cCodBar)+"! MAIS de 15 caracteres.--------"+LFRC+LFRC
		Else
			VTBEEP(3)     
		    VTAlert("------Codigo de Barras Inválido - "+AllTrim(cCodBar)+"! MAIS de 15 caracteres.--------","Alerta",.t.,2500)				
		EndIf	
	ElseIf Len(AllTrim(cCodBar)) < 15
	    If !IsTelNet() //Implantacao Radio Frequencia - 11/10/2011
			tMemo := "------Codigo de Barras Inválido - "+AllTrim(cCodBar)+"! MENOS de 15 caracteres.--------"+LFRC+LFRC			
		Else			                                                                                                 
			VTBEEP(3)     
		    VTAlert("------Codigo de Barras Inválido - "+AllTrim(cCodBar)+"! MENOS de 15 caracteres.--------","Alerta",.t.,2500)				
		EndIf		
	EndIf
	If !IsTelNet()	//Implantacao Radio Frequencia - 11/10/2011
		Memo  := tMemo //+Memo    
		Close(oDlg)
	EndIf 
	cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",20)
	Return
EndIf
cOper := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa query para localizar aparelho apontado apenas pelo IMEI - M.Munhoz - 14/05/2007                                                      ³
//³Alterado o Where do select para filtrar por sequencia de ordem de indice,  no intuido da mesma ficar mais rápida - Edson Rodrigues - 13/04/10³
//³Ordena a tabela no indice mais proximo que sera executada a query - Edson Rodrigues 12/04/10                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
_cQryIMEI := " SELECT ZZ4_FILIAL, ZZ4_IMEI, ZZ4_OS, ZZ4_CODCLI, ZZ4_LOJA, ZZ4_LOCAL, ZZ4_CODPRO, ZZ4_NFENR, ZZ4_NFESER, ZZ4_VLRUNI, ZZ4_OPER, ZZ4_CARCAC,ZZ4_OPEBGH"
_cQryIMEI += " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQryIMEI += " WHERE  ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' "
_cQryIMEI += "        AND ZZ4_IMEI    = '"+cCodBar+"' "
_cQryIMEI += "        AND ZZ4_STATUS  = '5' "  // OS encerrada
_cQryIMEI += "        AND ZZ4_PV      = ''  "
_cQryIMEI += "        AND ZZ4.D_E_L_E_T_  = '' "
_cQryIMEI += " ORDER BY R_E_C_N_O_ DESC "
//memowrite("saidamassiva1.sql",_cQryIMEI)
_cQryIMEI := ChangeQuery(_cQryIMEI)
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryIMEI),"QRY1",.T.,.T.)
QRY1->(dBGoTop())
If QRY1->(Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se teve entrada e o status em que esta o aparelho / colocado essa verificacao aqui no inicio para representar o real status do aparelho.³
	//³Edson Rodrigues - 13/04/10                                                                                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
	If !ZZ4->(dbSeek(xFilial("ZZ4") + cCODBAR + "5" )) //Localiza o numero da OS  // Status = OS encerrada
		If !_lAuto
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
			//³Acrescentado IFs para dizer exatamente qual a posição do aparelho - 12/04/10³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
			If ZZ4->(dbSeek(xFilial("ZZ4") + cCODBAR))
				While ZZ4->(!Eof()) .AND. ZZ4->ZZ4_IMEI == cCODBAR
					//ZZ4->(dbSetOrder(2)) //ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
					If Empty(ZZ4->ZZ4_PV)
						If ZZ4->ZZ4_STATUS = "9"
							tMemo:="------Aparelho ja feito a saida massiva e com NFS gerada !------"+LFRC+LFRC
						ElseIf ZZ4->ZZ4_STATUS = "8"
							tMemo:="------Aparelho ja feito a saida massiva e com Pedido gerado !------"+LFRC+LFRC
						ElseIf ZZ4->ZZ4_STATUS $ "6/7"
							tMemo:="------Aparelho em encerramento - IMEI lido ou Confirmado !------"+LFRC+LFRC
						ElseIf ZZ4->ZZ4_STATUS $ "3/4"
							tMemo:="------Aparelho em atendimento no laboratorio !------"+LFRC+LFRC
						ElseIf ZZ4->ZZ4_STATUS $ "1/2"
							tMemo:="------Aparelho em processo de entrada massiva !------"+LFRC+LFRC
						Else
							tMemo:="------Aparelho com status invalido ! Entre em contato com Administrador do sistema !------"+LFRC+LFRC
						EndIf
					EndIf
					ZZ4->(dbSkip())
				EndDo
			Else
				tMemo:="------Aparelho nao encontrado na entrada massiva - favor verificar !------"+LFRC+LFRC
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Mostra alerta da mensagem no coletor se for   ³
			//³utilizada pelo Radio Frequencia  - 11/10/2011 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Memo:=tMemo //+Memo
			If !IsTelNet() //Implantação Radio Frequencia
				Close(oDlg)
			Else
				VTBEEP(3)
				VTAlert(tMemo,"Alerta",.t.,2500)
			EndIf
		EndIf
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",20)
		QRY1->(dbCloseArea())
		// Volta o indice da tabela no indice que estava - Edson Rodrigues 12/04/10
		ZZ4->(dbSetOrder(3)) //ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI + ZZ4_STATUS
		Return
	Else
		cvpclis:=Posicione("ZZJ",1,xFilial("ZZJ") + QRY1->ZZ4_OPEBGH, "ZZJ_VPCLIS") // Valida parametro saida massiva
		// Grava dados da entrada
		If cvpclis=="S"
			MV_PAR01 := If(MV_PAR01=MV_PAR01,MV_PAR01,QRY1->ZZ4_CODCLI)
			MV_PAR02 := QRY1->ZZ4_LOJA
			MV_PAR03 := QRY1->ZZ4_CODPRO
			MV_PAR04 := QRY1->ZZ4_OPER
		Else
			MV_PAR01 := QRY1->ZZ4_CODCLI
			MV_PAR02 := QRY1->ZZ4_LOJA
			MV_PAR03 := QRY1->ZZ4_CODPRO
			MV_PAR04 := QRY1->ZZ4_OPER
		EndIf
		cNFE     := QRY1->ZZ4_NFENR
		cSerie   := QRY1->ZZ4_NFESER
		nVlZZ4   := QRY1->ZZ4_VLRUNI
		nValTot	 := nValTot+nVlZZ4
		cOper    := QRY1->ZZ4_OPER
		cVARSIM  := QRY1->ZZ4_CARCAC
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Rotina de travamento do radio - GLPI 14467³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !U_VLDTRAV(QRY1->ZZ4_FILIAL, QRY1->ZZ4_IMEI, QRY1->ZZ4_OS, {Iif(IsTelNet(),"C","P"),"TECAX012","tecx012grv"})
		If !IsTelNet() 
			Close(oDlg)
		EndIf
		QRY1->(dbCloseArea())
		Return
	EndIf
	If QRY1->ZZ4_OPEBGH == "O01"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Implantação Radio Frequencia³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !IsTelNet()
			Alert("Para saída massiva dessa Operação, entrar em contato com o TI")
			Close(oDlg)
			QRY1->(dbCloseArea())
			Return
		Else
			VTBEEP(3)
			VTAlert("Para saída massiva dessa Operação, entrar em contato com o TI","Alerta",.t.,2500)
			QRY1->(dbCloseArea())
			Return
		EndIf
	EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida de acordo com os Parametros MV_PAR01  a saida massiva (Nextel SP\RJ) - Luiz Ferreira - 060309³
	//³Solicitação Marcos Marques - Expedição BGH.                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCliente := QRY1->ZZ4_CODCLI
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Desabilitado o If abaixo, pois nao faz sentido - Edson Rodrigues 13/04/10³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
	If !Empty(MV_PAR01)
	EndIf
	If cCliente $ "000016/000680" .AND. QRY1->ZZ4_Local $ "10/11" .AND. QRY1->ZZ4_CODCLI <> Alltrim(MV_PAR01)
*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida parametro saida massiva³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cvpclis:=Posicione("ZZJ",1,xFilial("ZZJ") + QRY1->ZZ4_OPEBGH, "ZZJ_VPCLIS")
	If cvpclis=="S" .AND. QRY1->ZZ4_CODCLI <> Alltrim(MV_PAR01)	.AND. !_lAuto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Mostra alerta da mensagem no coletor se for   ³
		//³utilizada pelo Radio Frequencia  - 11/10/2011 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
		Alert("ATENÇÃO!!!! - CLIENTE DIVERGENTE DOS PARÂMETROS INFORMADO - "+alltrim(MV_PAR01)+" - "+AllTrim(cCodBar)+". NÃO MISTURAR O APARELHO COM O(S) JÁ APONTADO(S) NESTA SAÍDA MASSIVA. SOB SUA RESPONSABILIDADE!!")
		tMemo:="Cliente Divergente dos Parâmetros Informado - "+alltrim(MV_PAR01)+" - "+AllTrim(cCodBar)+"."+LFRC
		If !IsTelNet() //Implantação Radio Frequencia
			Memo:=tMemo //+Memo
			Close(oDlg)
		Else
			VTBEEP(3)
			VTAlert(tMemo,"Alerta",.t.,2500)
		EndIf
		//     msginfo ("Cliente Divergente dos Parâmetros Informado" + MV_PAR01 )
		QRY1->(dbCloseArea())
		Pergunte("BARZZ4",.T.)
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetuado conforme solicitação do Marcos Marques³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If Empty(_cCodCli)
		_cCodCli:= Alltrim(QRY1->ZZ4_CODCLI)+Alltrim(QRY1->ZZ4_LOJA)
	Else
		If _cCodCli <> Alltrim(QRY1->ZZ4_CODCLI)+Alltrim(QRY1->ZZ4_LOJA)
			Alert("ATENÇÃO!!!! - IMEI - "+AllTrim(cCodBar)+" DIVERGENTE DO CLIENTE DESTA SAÍDA MASSIVA - "+alltrim(MV_PAR01)+". NÃO MISTURAR O APARELHO COM O(S) JÁ APONTADO(S) NESTA SAÍDA MASSIVA. SOB SUA RESPONSABILIDADE!!")
			tMemo:="IMEI - "+AllTrim(cCodBar)+" Divergente do Cliente desta Saida Massiva."+LFRC 
			If !IsTelNet()
				Memo:=tMemo
				Close(oDlg)
			Else
				VTBEEP(3)
				VTAlert(tMemo,"Alerta",.t.,2500)
			EndIf
			QRY1->(dbCloseArea())
			Return
		EndIf
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava dados da entrada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cvpclis=="S"
		MV_PAR01 := IF(MV_PAR01=MV_PAR01,MV_PAR01,QRY1->ZZ4_CODCLI)
		MV_PAR02 := QRY1->ZZ4_LOJA
		MV_PAR03 := QRY1->ZZ4_CODPRO
		MV_PAR04 := QRY1->ZZ4_OPER
	Else
		MV_PAR01 := QRY1->ZZ4_CODCLI
		MV_PAR02 := QRY1->ZZ4_LOJA
		MV_PAR03 := QRY1->ZZ4_CODPRO
		MV_PAR04 := QRY1->ZZ4_OPER
	EndIf
	cNFE     := QRY1->ZZ4_NFENR
	cSerie   := QRY1->ZZ4_NFESER
	nVlZZ4   := QRY1->ZZ4_VLRUNI
	nValTot	 := nValTot+nVlZZ4
	cOper    := QRY1->ZZ4_OPER
	cVARSIM  := QRY1->ZZ4_CARCAC
	//EndIf
EndIf
QRY1->(dbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¬t§¿
//³Posiciona o ZZ4 no registro correto - Edson Rodrigues - 14/04/10³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¬t§Ù
ZZ4->(dbSetOrder(3)) //ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI + ZZ4_STATUS
ZZ4->(dbSeek(xFilial("ZZ4") + cNFE + cSerie + MV_PAR01 + MV_PAR02 + MV_PAR03 + AvKey(cCODBAR,"ZZ4_IMEI") + "5" )) //Localiza o numero da OS  // Status = OS encerrada
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a situação da OS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AB7->(DBOrderNickName("AB7NUMSER")) //AB7_FILIAL+AB7_NUMOS+AB7_NUMSER
If AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI  )) .AND. AB7->AB7_TIPO < "4" //Status de Atendido
	_cStr := "ACERTA_AB7TP1"
	If TCSPExist(_cStr)
		TCSqlExec(_cStr)
	Else //Colocado esse Else pois a funcao TSCPExist nao encontra a procedure, mesmo a mesma existindo. 13/05/10 Edson Rodrigues
		//TCSqlExec(_cStr)
		tMemo:="------Procedure de correçao "+_cStr+" nao encontrada. favor entrar em contato com Adminitrador do sistema"+LFRC+LFRC
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Mostra alerta da mensagem no coletor se for   ³
		//³utilizada pelo Radio Frequencia  - 11/10/2011 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IsTelNet() //Implantação Radio Frequencia - 11/10/2011
			VTBEEP(3)
			VTAlert(tMemo,"Alerta",.t.,2500)
		EndIf
	EndIf
	_cStr := "ACERTA_AB7TP23"
	If TCSPExist(_cStr)
		TCSqlExec(_cStr)
	Else //Colocado esse Else pois a funcao TSCPExist nao encontra a procedure, mesmo a mesma existindo.  13/05/10 Edson Rodrigues
		//TCSqlExec(_cStr)
		tMemo:="------Procedure de correçao "+_cStr+" nao encontrada. favor entrar em contato com Adminitrador do sistema"+LFRC+LFRC
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Mostra alerta da mensagem no coletor se for   ³
		//³utilizada pelo Radio Frequencia  - 11/10/2011 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IsTelNet() //Implantação Radio Frequencia - 11/10/2011
			VTBEEP(3)
			VTAlert(tMemo,"Alerta",.t.,2500)
		EndIf
	EndIf
EndIf
If AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI  )) .AND. AB7->AB7_TIPO < "4" //Status de Atendido     
	If !_lAuto                                                                    
		If AB7->AB7_TIPO == "2" //Pedido gerado
			tMemo:="------Ja foi gerado Pedido para esse aparelho. (AB7_TIPO = 2)--------"+LFRC+LFRC
		ElseIf AB7->AB7_TIPO == "1" //OS
			tMemo:="------Esse aparelho NAO foi atendido. (AB7_TIPO = 1)--------"+LFRC+LFRC
		Else
			tMemo:="------Esse aparelho esta em atendimento. (AB7_TIPO = 3)--------"+LFRC+LFRC
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Mostra alerta da mensagem no coletor se for   ³
	    //³utilizada pelo Radio Frequencia  - 11/10/2011 ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !IsTelNet() //Implantação Radio Frequencia - 11/10/2011
			Memo:=tMemo //+Memo
			Close(oDlg)
		Else
			VTBEEP(3)
		    VTAlert(tMemo,"Alerta",.t.,2500)
		EndIf			 	  
	EndIf
	cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",20)
	Return
EndIf
//Vinicius Leonardo - Delta Decisão - 16/07/15 - Solicitação de Marcos Marques
/*If lFirst
	If ZZ4->ZZ4_OPEBGH $ cOpAgreg
		lFirst := .F.
		cDescOper := Alltrim(Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH, "ZZJ_DESCRI"))	
		If !IsTelNet()
			If !ApMsgYesNo("Esta é a operação " + Alltrim(ZZ4->ZZ4_OPEBGH) +" - "+ Alltrim(cDescOper) + ".Podem ser agregados mais aparelhos até atingir o valor limite. Deseja continuar o apontamento? ","ATENÇÃO" )
				Close(oDlg)
				QRY1->(dbCloseArea())
				Return
			EndIf
		EndIf
	EndIf
EndIf*/
_nTotal ++
AADD(_SerSai, cCodBar)
//Begin Transaction
RecLock("ZZ4",.F.)
ZZ4->ZZ4_STATUS := "6"       // Saida Massiva lida/apontada
ZZ4->ZZ4_SMUSER := cUserName // Nome do usuario que gerou a Saida Massiva
ZZ4->ZZ4_SMDT   := dDataBase // Data da Saida Massiva
ZZ4->ZZ4_SMHR   := Time()    // Horario da Saida Massiva
MsUnlock("ZZ4")
SB1->(dbSeek(xFilial("SB1")+MV_PAR03))
If !_lAuto
	If !IsTelNet() //Implantacao coletor de dados
		tMemo := "Qtd: " +Transform(_nTotal,"@E 9999")+"   "+"Total: " +Transform(nValTot,"@E 999,999.99999")+LFRC
		tMemo += "Cliente: "+MV_PAR01+" Loja: "+MV_PAR02+LFRC
		tMemo += "Produto: "+MV_PAR03+" Descricao: "+SB1->B1_DESC+LFRC
		tMemo += "SN: "+cCodBar+"   SIM/Carcaça: "+cVarSIM+LFRC
		tMemo += "NF: "+cNFE+" Série: "+cSerie+" Valor: "+Transform(nVlZZ4,"@E 999,999.99999")+LFRC
	Else
		aLidos := {}
		AADD(aLidos, {Alltrim(Transform(_nTotal,"@E 9999")),;
		MV_PAR01+"/"+MV_PAR02,;
		Alltrim(MV_PAR03)+"/"+SB1->B1_DESC,;
		cCodBar,;
		cVarSIM,;
		cNFE+"/"+cSerie,;
		Alltrim(Transform(nVlZZ4,"@E 999,999.99999"))})
	EndIf	
EndIf
If !_lAuto .AND. !IsTelNet()
	tMemo += LFRC
	Memo  := tMemo //+ Memo
	Close(oDlg)
EndIf
cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",20)
cVarSIM:=Replicate(" ",20)
UltReg:=.T.            
Return(lResult)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECX012C ºAutor  ³Microsiga           º Data ³  09/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de confirmacao da SAIDA MASSIVA                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx012c(_lAuto)
Local nConta     := 0
Local ChaveNF    := ""
Local cProd      := ""
Local nProd      := 0
Local nTotalNf   := 0.00
Local cConf      := ""
Local nTotal     := 0
Local _cQuery2   := ""
Local cAliasTop2 := ""
Local _aAreaZZ4  := ZZ4->(GetArea())
Local oDlgConf
If Len(_sersai) == 0
	If !IsTelNet() //Implantacao Radio Frequencia - 11/10/2011
		apMsgStop("Caro usuário, nenhum IMEI foi apontado na Saída Massiva. A rotina está sendo interrompida neste momento.","Saída Massiva interrompida!!!")
	Else 
		VTBEEP(3)     
	    VTAlert("Caro usuário, nenhum IMEI foi apontado na Saída Massiva. A rotina está sendo interrompida neste momento.","Saída interrompida",.t.,3500)				
	EndIf	
	Return()
EndIf
oFnt1	:= TFont():New("Arial"		,18,22,,.T.,,,,.T.,.F.)
oFnt2	:= TFont():New("Arial"		,08,14,,.T.,,,,.T.,.F.)
oFnt3	:= TFont():New("Courier New",08,12,,.F.,,,,.F.,.F.)
oFnt4	:= TFont():New("Arial"		,12,14,,.T.,,,,.T.,.F.)
dbSelectArea("ZZ4")
_nIndZZ4 := IndexOrd()
_nRecZZ4 := Recno()
// Grava status de saida massiva apontada
/*
For I := 1 to Len(_SerSai)
	dbSelectArea("ZZ4")
	dbSetOrder(4)  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
	If ZZ4->(dbSeek(xFilial("ZZ4")+_SerSai[I]+"4"))
		dbSelectArea("ZZ4")
		RecLock("ZZ4",.F.)
		ZZ4->ZZ4_STATUS := "5" //Saida massiva apontada
		MsUnlock("ZZ4")
		nConta++
	EndIf
Next
If nConta > 0 .AND. !_lAuto //Edson Rodrigues 28/11/07
	MsgBox("Foram confirmados "+alltrim(Str(nConta))+" saidas","Lançamento de Saida","Alert")
EndIf
*/
dbSelectArea("SB1")
SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado o Where do select para filtrar por sequencia de ordem de indice,  no intuido da mesma ficar mais rápida - Edson Rodrigues - 13/04/10³
//³Ordena a tabela no indice mais proximo que sera executada a query - Edson Rodrigues 12/04/10.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ZZ4")
//ZZ4->(dbSetOrder(3)) //ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
ZZ4->(dbGoTop())
cAliasTop2	:= GetNextAlias()
_cQuery2 := " SELECT ZZ4_FILIAL, ZZ4_IMEI, ZZ4_OS, ZZ4_NFENR, ZZ4_NFESER, ZZ4_CODPRO, ZZ4_VLRUNI, ZZ4_SMUSER"
_cQuery2 += " FROM "+RetSqlName("ZZ4") + "(NOLOCK)"
_cQuery2 += " WHERE D_E_L_E_T_ = ''"
_cQuery2 += " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
_cQuery2 += " AND ZZ4_STATUS = '6'"
_cQuery2 += " AND substring(ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"'"
_cQuery2 += " ORDER BY ZZ4_NFENR, ZZ4_NFESER, ZZ4_CODPRO"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery2),cAliasTop2,.T.,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna ao indice anterior  - Edson Rodrigues 12/04/10.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ZZ4->(dbSetOrder(3)) //ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
ZZ4->(dBGoTop())
//dbSelectArea("cAliasTop2")
//(cAliasTop2)->(dBGoTop())
While !((cAliasTop2)->(Eof())) 
	If !U_VLDTRAV((cAliasTop2)->ZZ4_FILIAL, (cAliasTop2)->ZZ4_IMEI, (cAliasTop2)->ZZ4_OS, {Iif(IsTelNet(),"C","P"),"TECAX012","tecx012c"})
		Return()
	EndIf
	nTotal++
	If (cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER) <> ChaveNF
		ChaveNF := (cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER) // ZZ4F->(ZZ4_NFENR+ZZ4_NFESER)
		cProd   := (cAliasTop2)->ZZ4_CODPRO
		nProd   := 0
		If !_lAuto //Entrar so quando não for rotina automática de saida massiva - Edson Rodrigues - 12/03/09 
		  cConf   += "Qtd: " +Transform(nTotal,"@E 9,999,999.99")+LFRC
		  cConf   += "Nota: "+ (cAliasTop2)->ZZ4_NFENR
		  cConf   += "Serie:"+ (cAliasTop2)->ZZ4_NFESER+LFRC
		  cConf   += "Codigo          Descrição                        Quant"+LFRC
          cconf   += ""         
      EndIf
	EndIf
	If  ((cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER) == ChaveNF  .AND.  (cAliasTop2)->ZZ4_CODPRO==cProd)
		nProd++
	Else
		cProd   := (cAliasTop2)->ZZ4_CODPRO
		SB1->(dbSeek(xFilial("SB1")+cProd))
		If !_lAuto //Entrar so quando não for rotina automática de saida massiva - Edson Rodrigues - 12/03/09
		   cConf+=cProd+" "+Alltrim(SB1->B1_DESC)+" "+Transform(nProd,"@E 999999")+LFRC 
		   cconf+= ""
		EndIf 
	   nProd:=1
	   cProd:= (cAliasTop2)->ZZ4_CODPRO
	EndIf
	nTotalNF+= (cAliasTop2)->ZZ4_VLRUNI
	(cAliasTop2)->(DBSkip())
	If ((cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER) <> ChaveNF) .OR.;
		((cAliasTop2)->ZZ4_SMUSER <> left(cUserName,13)) .OR. ;
		(cAliasTop2)->(Eof())
		SB1->(dbSeek(xFilial("SB1")+cProd))
		If !_lAuto //Entrar so quanto não for rotina automática de saida massiva - Edson Rodrigues - 12/03/09
		  cConf += cProd+" "+SB1->B1_DESC+" "+Transform(nProd,"@E 999999")+LFRC 
		  cconf += ""
		EndIf  
		nProd    := 0
		cProd    := (cAliasTop2)->ZZ4_CODPRO
		If !_lAuto //Entrar so quanto não for rotina automática de saida massiva - Edson Rodrigues - 12/03/09
		  cConf += LFRC+"Total da Nota:"+Transform(nTotalNF,"@E 9,999,999.99")+LFRC+LFRC 
		  cconf += ""
		EndIf  
		nTotalNf := 0.00
	EndIf
EndDo
dbSelectArea(cAliasTop2)
dbCloseArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Janela de Conferência³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTotal == 0
	If !IsTelNet() //Implantacao Radio Frequencia - 11/10/2011
		Aviso("Massiva","Não existem itens para conferência!",{"OK"})
	Else                                                             
		VTBEEP(3)     
	    VTAlert("Não existem itens para conferência!","Massiva",.T.,2500)
	EndIf	
Else
	If AllTrim(MV_PAR07) == "12"
		lCont := .T.
		While lCont
			If !IsTelNet() //Implantação Radio Frequencia - 13/10/11
				oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
				@ 0,0 TO 200,300 DIALOG oDlg2 TITLE "Massiva"
				oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlg2)
				@ 20,010 SAY oV1 var "Informe o fornecedor:" of oDlg2 FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
				@ 40,010 GET cForn Size 60,080 PICTURE "@!" F3 "FOR"
				@ 40,080 GET cLoja Size 20,080 PICTURE "@!"
				@ 80,085 BMPBUTTON TYPE 1 ACTION (IIf(ExistCpo("SA2", cForn + cLoja), lCont := .F., lCont := .T.), oDlg2:End())
				@ 80,120 BMPBUTTON TYPE 2 ACTION (lCont := .F., oDlg2:End())
				Activate MSDialog oDlg2 Centered                             
			Else
   				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Tela no coletor para receber o codigo do Fornecedor ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				VTClear()
				VTClearBuffer()
				DLVTCabec("Massiva",.F.,.F.,.T.)
				@ 01, 00 VTSay "Informe Fornecedor"	//VTGet cVarBar Pict "@!"	Valid u_tecx012grv(@cVarBar,@cTexto,@cVarSim,.F.)
				@ 02, 00 VTGet cForn Pict "@!"
				@ 03, 00 VTGet cLoja Pict "@!"				
				VTREAD	   
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o fornecedor informado é valido³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA2")
				dbSetOrder(1)
				If !MsSeek(xFilial("SA2")+cForn+cLoja)
					VTBEEP(3)     
				    VTAlert("Fornecedor Invalido!","Alerta",.t.,2500)							
				    cForn :=  TamSX3("A2_COD")[1]
				    cLoja :=  TamSX3("A2_LOJA")[1]
				Else
					lCont := .F.					    
				EndIf
			EndIf 	
		EndDo
	EndIf
	If  !_lAuto //Edson Rodrigues 17/11/08 
		If !IsTelNet() //Implantação Radio Frequencia - 13/10/11
	   		MsgBox("Foram Lidos "+alltrim(Str(nTotal))+" Imeis ","Confirme a  Saida Massiva","Alert")
			@ 0,0 TO 350,400 DIALOG oDlgConf TITLE "Confirmar Dados"
			@ 05,005 SAY oV1 var Alltrim(cUserName)+"," of oDlgConf FONT oFnt2 PIXEL SIZE 150,010
			@ 15,005 SAY oV2 var "confirme os itens abaixo listados." of oDlgConf FONT oFnt2 PIXEL SIZE 150,012
			@ 25,005 SAY oV3 var "Importante: A responsabilidade dos dados é sua." of oDlgConf FONT oFnt2 PIXEL SIZE 150,012 COLOR CLR_RED
			@ 40,005 Get cConf Size 195,115 MEMO Object oMemoConf
			@ 160,130 BMPBUTTON TYPE 1 ACTION Processa({|| tecx012d(oDlgConf,_lAuto) })
	//		@ 160,165 BMPBUTTON TYPE 2 ACTION tecx012f(oDlgConf)
			@ 160,165 BMPBUTTON TYPE 2 ACTION oDlgConf:End()
			oMemoConf:oFont:=oFnt3
			Activate MSDialog oDlgConf Centered
		Else
			tecx012d(oDlgConf,_lAuto) //Edson Rodrigues
		EndIf
	Else
		//	  @ 0,0 TO 350,400 DIALOG oDlgConf TITLE "Confirmar Dados"
		tecx012d(oDlgConf,_lAuto) //Edson Rodrigues
	EndIf
EndIf
//If !_lAuto
//	Close(oDlg)
//EndIf
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Sair     ºAutor  ³ Edson              º Data ³ 29/12/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abandona a inclusão para reiniciar a digitação             º±±
±±º          ³ posteriormente                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx012a()
If !IsTelNet() //Implantacao Radio Frequencia - 10/11/2011
	If apMsgYesNo("Esta opção deve ser escolhida se a inclusão for ser retomada posteriormente. Confirma a saída ?","Lançamento Parcial","YESNO")
		_lFechSM := .T.
		Close(oDlg)
	EndIf
Else     
	If DLVTAviso("Lançamento Parcial", "A inclusão deve ser retomada posteriormente. Confirma a saída ?", {"SIM", "NAO"}) == 1
		_lFechSM := .T.
	EndIf
EndIf	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ tecx012d ºAutor  ³ Antonio L.F.Favero º Data ³ 23/11/2002  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca o campo ZZ4->CONFIRM com "S"                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx012d(WndDlg,_lAuto)
Local _cQuery    := ""
Local _aSavNFE   := {}
Local _lrotaut   := .f.  //Edson Rodrigues
Local _aAreaZZ4  := ZZ4->(GetArea())
If _lAuto
	_lrotaut := .t.
EndIf
//dbSelectArea("ZZ4")  //Entrada Massiva                                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado o Where do select para filtrar por sequencia de ordem de indice,  no intuido da mesma ficar mais rápida - Edson Rodrigues - 13/04/10³
//³Ordena a tabela no indice mais proximo que sera executada a query - Edson Rodrigues 12/04/10.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
_cUpdate := " UPDATE " + RetSqlName("ZZ4")
_cUpdate += " SET    ZZ4_STATUS = '7' "  // Saida Massiva confirmada
_cUpdate += " WHERE  ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND "
_cUpdate += "        ZZ4_STATUS = '6' AND "  // Saida Massiva lida/apontada
_cUpdate += "        D_E_L_E_T_ = ''  AND "
_cUpdate += "        Upper(SUBSTRING(ZZ4_SMUSER,1,13)) = '"+Upper(Substr(cUserName,1,13))+"'"
tcSqlExec(_cUpdate)
TCRefresh(RetSqlName("ZZ4"))
/*
cAliasTop1	:= GetNextAlias()
_cQuery := " SELECT * "
_cQuery += " FROM   "+RetSqlName("ZZ4")
_cQuery += " WHERE  "
_cQuery += "        ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND "
_cQuery += "        D_E_L_E_T_ = '' AND "
_cQuery += "        SUBSTRING(ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' AND "
_cQuery += "        ZZ4_STATUS = '5' "
//_cQuery += "        ZZ4_TIPO = '"+cTipo+"' "
//_cQuery += "        ZZ4_CONFIRM <> 'S' AND "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery),cAliasTop1,.T.,.T.)
(cAliasTop1)->(dBGoTop())
Feche(_lAuto) //Fecha Janela
ProcRegua((cAliasTop1)->(RECCOUNT()))
While !(cAliasTop1)->(Eof())
	ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
	If ZZ4->(dbSeek(xFilial("ZZ4")+(cAliasTop1)->ZZ4_IMEI + "5"))   // "E"
		While ZZ4->(!Eof()) .AND. ZZ4->ZZ4_IMEI == (cAliasTop1)->ZZ4_IMEI .AND. ZZ4->ZZ4_STATUS == "5"
			If Upper(Substr(ZZ4->ZZ4_SMUSER,1,13)) == Upper(Substr(cUserName,1,13)) //.AND. ZZ4->ZZ4_CONFIRM <> "S"
				RecLock("ZZ4",.F.)
//				If ZZ4->ZZ4_CONFIRM <> "W" 	//Edson Rodrigues - 27/09/07 --> Condicao para evitar erros na saida massiva
//					ZZ4->ZZ4_CONFIRM := "S"
//				EndIf
				ZZ4->ZZ4_STATUS := "6"
				MsUnLock("ZZ4")
				IncProc()
			EndIf
			ZZ4->(DbSkip())
		EndDo
	EndIf
	(cAliasTop1)->(DBSkip())
EndDo
*/
tecx012b(_lAuto) //Fecha Janela
If !_lAuto
	If !IsTelNet() //Implantacao Radio Frequencia - 13/10/2011
		WndDlg:End()
	EndIf	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera o Pedido de Vendas a partir da saida massiva ³
//³E Necessario alterar a variacel nModulo, porque	 ³
//³no ACD erros são gerados se utilizar o ExecAuto do³
//³pedido de venda									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nModulOld := nModulo
nModulo   := 5 //Faturamento
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera o Pedido de Vendas a partir da saida massiva³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
u_tecax015(_lrotaut,IsTelNet())
nModulo	 := nModulOld
RestArea(_aAreaZZ4)
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx012legºAutor  ³ Antonio L.F.Favero º Data ³ 27/03/2003  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Legenda de teclas de funções na Janela                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx012leg()
nTop:=360
nLeft:=16
//oMemo:oFont := oFnt2
oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := "Teclas de Função"
oGrp1:nLeft := 6+nLeft
oGrp1:nTop := 9+nTop
oGrp1:nWidth := 323
oGrp1:nHeight := 59
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.
oF9 := TSAY():Create(oDlg)
oF9:cName := "oF9"
oF9:cCaption := "F9 "
oF9:nLeft := 17+nLeft
oF9:nTop := 26+nTop
oF9:nWidth := 25
oF9:nHeight := 17
oF9:lShowHint := .F.
oF9:lReadOnly := .F.
oF9:Align := 0
oF9:lVisibleControl := .T.
oF9:lWordWrap := .F.
oF9:lTransparent := .T.
/*
oF10 := TSAY():Create(oDlg)
oF10:cName := "oF10"
oF10:cCaption := "F10"
oF10:nLeft := 17+nLeft
oF10:nTop := 44+nTop
oF10:nWidth := 25
oF10:nHeight := 17
oF10:lShowHint := .F.
oF10:lReadOnly := .F.
oF10:Align := 0
oF10:lVisibleControl := .T.
oF10:lWordWrap := .F.
oF10:lTransparent := .T.
*/
oSay4 := TSAY():Create(oDlg)
oSay4:cName := "oSay4"
oSay4:cCaption := "Parâmetros"
oSay4:nLeft := 52+nLeft
oSay4:nTop := 26+nTop
oSay4:nWidth := 65
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .T.
/*
oSay5 := TSAY():Create(oDlg)
oSay5:cName := "oSay5"
oSay5:cCaption := "Inserir item da NF"
oSay5:nLeft := 52+nLeft
oSay5:nTop := 44+nTop
oSay5:nWidth := 65
oSay5:nHeight := 17
oSay5:lShowHint := .F.
oSay5:lReadOnly := .F.
oSay5:Align := 0
oSay5:lVisibleControl := .T.
oSay5:lWordWrap := .F.
oSay5:lTransparent := .T.
oF11 := TSAY():Create(oDlg)
oF11:cName := "oF11"
oF11:cCaption := "F11"
oF11:nLeft := 157+nLeft
oF11:nTop := 26+nTop
oF11:nWidth := 25
oF11:nHeight := 17
oF11:lShowHint := .F.
oF11:lReadOnly := .F.
oF11:Align := 0
oF11:lVisibleControl := .T.
oF11:lWordWrap := .F.
oF11:lTransparent := .T.
oF12 := TSAY():Create(oDlg)
oF12:cName := "oF12"
oF12:cCaption := "F12"
oF12:nLeft := 157+nLeft
oF12:nTop := 44+nTop
oF12:nWidth := 25
oF12:nHeight := 17
oF12:lShowHint := .F.
oF12:lReadOnly := .F.
oF12:Align := 0
oF12:lVisibleControl := .T.
oF12:lWordWrap := .F.
oF12:lTransparent := .T.
oSay8 := TSAY():Create(oDlg)
oSay8:cName := "oSay8"
oSay8:cCaption := "Mudar Cliente e Loja"
oSay8:nLeft := 192+nLeft
oSay8:nTop := 26+nTop
oSay8:nWidth := 101
oSay8:nHeight := 17
oSay8:lShowHint := .F.
oSay8:lReadOnly := .F.
oSay8:Align := 0
oSay8:lVisibleControl := .T.
oSay8:lWordWrap := .F.
oSay8:lTransparent := .T.
oSay9 := TSAY():Create(oDlg)
oSay9:cName := "oSay9"
oSay9:cCaption := "Mudar Modelo Celular"
oSay9:nLeft := 192+nLeft
oSay9:nTop := 44+nTop
oSay9:nWidth := 113
oSay9:nHeight := 17
oSay9:lShowHint := .F.
oSay9:lReadOnly := .F.
oSay9:Align := 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap := .F.
oSay9:lTransparent := .T.
oSBtn1 := SBUTTON():Create(oDlg)
oSBtn1:cName := "oBtnDEL"
oSBtn1:cCaption := "oSBtn1"
oSBtn1:nLeft := 220
oSBtn1:nTop := 95
oSBtn1:nWidth := 52
oSBtn1:nHeight := 22
oSBtn1:lShowHint := .T.
oSBtn1:lReadOnly := .F.
oSBtn1:Align := 0
oSBtn1:lVisibleControl := .T.
oSBtn1:nType := 3                             
oSBtn1:bLClicked := {|| AbreRastro(@cTexto) }
*/
oEdBar:SetFocus()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECX012B ºAutor  ³ Antonio L.F.Favero º Data ³ 28/08/2002  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fecha a janela de devolucao                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx012b(_lAuto)
Local _aAreaZZ4 := ZZ4->(GetArea())
_lFechSM := .T.
/*
ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
For I := 1 to Len(_SerSai)
	If ZZ4->(dbSeek(xFilial("ZZ4")+_SerSai[I]+"4"))
		dbSelectArea("ZZ4")
		RecLock("ZZ4",.F.)
		ZZ4->ZZ4_STATUS := "3" //Saida de itens não confirmados
		MsUnlock("ZZ4")
	EndIf
Next
For I := 1 to Len(_SerSai)
	If ZZ4->(dbSeek(xFilial("ZZ4")+_SerSai[I]+"5"))
		dbSelectArea("ZZ4")
		RecLock("ZZ4",.F.)
		ZZ4->ZZ4_STATUS := "3" //Saida de itens não confirmados
		MsUnLock("ZZ4")
	EndIf
Next
*/
If !_lAuto 
	If Len(_SerSai) > 0
		ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
		For I := 1 to Len(_SerSai)
			If ZZ4->(dbSeek(xFilial("ZZ4") + _SerSai[I] + "6" )) // Status = Saida Massiva lida nao confirmada
				RecLock("ZZ4",.F.)
				ZZ4->ZZ4_STATUS := "5" // OS Encerrada
				MsUnlock("ZZ4")
			EndIf
		Next
	EndIf
	If !IsTelnet()	//Implantacao Radio Frequencia
		Close(oDlg)
	EndIf		
EndIf
restarea(_aAreaZZ4)
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AbreRastroºAutor  ³Microsiga           º Data ³  07/17/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AbreRastro()
u_TECAX019()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MostraLidsºAutor  ³Diego Fernandes     º Data ³  10/13/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que mostra as ultimas etiquetas lidas               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MostraLids()
Local aSave    := {}
Local nPosicao := 1
Local aCabec   := {"Qtd","Cliente","Produto","Num Serie","Sim/Carcaça","NF / Serie","Valor"}
Local aKits    := {}
Local aSize    := {15,9,35,15,15,12,14} 
aSave := VTSAVE()
VTClear()
nPosicao := VTaBrowse(0,0,7,19,aCabec,aLidos,aSize,,nPosicao)
VtRestore(,,,,aSave)
VTClearBuffer()
Return