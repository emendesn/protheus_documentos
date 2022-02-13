#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'TOPCONN.CH'
#include "VKey.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºExecblock ³ ETQCARDU º Autor ³ Claudia Cabral     º Data ³  28/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para impressao de Etiquetas - CARD-U - ZEBRA      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EtqCardU()
Private ocCardu
Private ccCardu	 := Space(15)
Private ocImei
Private ccImei	 := Space(TamSX3("ZZ4_IMEI")[1])//Space(20)
Private ocserial
Private ccSerial := Space(15)
Private _oDlgETI
Private _cImei    := Space(TamSX3("ZZ4_IMEI")[1])//space(15)
Private _cModelo  := space(20)
Private _cnomeCli := space(60)
Private _cestCli  := space(9)
Private nRegZZ4   := 0
Private cCliente  := space(6)
Private ccloja    := space(2)
PRIVATE CPERG     := "TIPIMP"
Private _operbgh
Private _operdes
Private _operdescri


u_GerA0003(ProcName())


CRIASX1()
PERGUNTE(CPERG,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao das Teclas de Funcao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey(VK_F9,{|| U_DigiCli()}) //Permite mudar o Cliente e Loja





DEFINE MSDIALOG _oDlgETI TITLE "Etiqueta CARD-U" FROM C(276),C(346) TO C(467),C(623) PIXEL
@ C(000),C(001) TO C(097),C(140) LABEL "Dados" PIXEL OF _oDlgETI
@ C(026),C(020) Say "IMEI:" Size C(016),C(008) COLOR CLR_BLACK  PIXEL OF _oDlgETI
@ C(022),C(040) MsGet ocImei Var ccImei Size C(060),C(009) COLOR CLR_BLACK  VALID CHKIMEI()  PIXEL OF _oDlgETI
@ C(044),C(020) Say "SERIAL:" Size C(014),C(008) COLOR CLR_BLACK  PIXEL OF _oDlgETI
@ C(040),C(040) MsGet ocserial Var ccSerial Size C(060),C(009) COLOR CLR_BLACK  VALID CHKSER()  PIXEL OF _oDlgETI
If MV_PAR02 = 1
	@ C(058),C(020) Say "CARD-U: " Size C(025),C(008) COLOR CLR_BLACK PIXEL OF _oDlgETI
	@ C(054),C(040) MsGet ocCardu Var ccCardu Size C(060),C(009) COLOR CLR_BLACK VALID CHKCARD() PIXEL OF _oDlgETI
EndIf

DEFINE SBUTTON FROM C(070),C(045) TYPE 1 ENABLE OF _oDlgETI ACTION ()
DEFINE SBUTTON FROM C(070),C(065) TYPE 2 ENABLE OF _oDlgETI ACTION (_oDlgEti:end())

ACTIVATE MSDIALOG _oDlgETI CENTERED
Return




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ckhimei   ³ Autores ³ Claudia Cabral/Edson Rodrigues-16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel validar o codigo do cliente e IMEI        ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ChkImei()
Local _Lachou   :=.f.
Local nAT       := 0


If Empty(ccImei)
	apMsgStop("Caro usuário, o IMEI nao foi informado.","IMEI não informado")
	return .f.
EndIF

If Empty(ccliente)
	apMsgStop("Caro usuário, o código do Cliente nao foi informado, clique [F9].","Cod Cliente não informado")
	return .f.
EndIF

If Empty(ccloja)
	apMsgStop("Caro usuário, o código do Cliente nao foi informado, clique [F9].","Cod Cliente não informado")
	return .f.
EndIF

/*  
Alterado por Uiran Almeida receber o imei mais recente
A validação anterior estava buscanco O.S. Alfanumerica da matriz  
*/

//ZZ4->(dbSetorder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
ZZ4->(dbSetorder(4)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS 

if ZZ4->(dbSeek(xFilial("ZZ4") + ccIMEI))
	/*while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCImei)
		ZZ4->(dbSkip())
	enddo
	ZZ4->(dbSkip(-1))*/
	_lAchou := alltrim(ZZ4->ZZ4_IMEI) == alltrim(ccImei)
elseif !empty(ccIMEI)
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")
endif

//lAchou := U_CHKIMEI(ccIMEI) // algoritmo para checagem do IMEI
nRegZZ4 := 0
if _lAchou
	//	Alterado essa regra - Edson Rodrigues - 16/09/10
	//If  ! ZZ4->ZZ4_STATUS $ '5'
	//	apMsgStop("Caro usuário, o IMEI informado não encontra-se na fase de encerramento. ","IMEI com fase incorreta")
	//	Return .f.
	//endif
	
	
	_operbgh   	:=ZZ4->ZZ4_OPEBGH
	_operdes	:=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_DESCRI")
	If Left(_operdes,6) $ "NEXTEL"
		_operdescri	:=Substr(_operdes,9,20)
	Else
		_operdescri	:= _operdes
	EndIf
	_cvalcardu 	:=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_ETQCDU")
	
	If _cvalcardu <> "S"
		apMsgStop("Caro usuário, A operacao desse IMEI informado não imprime etiqueta CARD-U. ","Operacao Invalida para Impressão Etiq. CARD-U")
		Return .f.
	Else
		_clab      :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_LAB")
	Endif
	
	_lvalifas  :=valifase(_clab,ZZ4->ZZ4_OS,ccIMEI)
	
	If  !_lvalifas
		apMsgStop("Caro usuário, o IMEI informado não foi enviado para a fase especial : CQS -> PRODUÇÃO ","IMEI na fase incorreta")
		
		// Verifica se a fase que esta sendo apontada coincide com a fase atual do aparelho
		_cVerFaseta := u_VerFasAtu(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
		apMsgStop("O IMEI encontra-se na fase/setor: "+ alltrim(left(_cVerFaseta,6))+"/"+alltrim(right(_cVerFaseta,6))+". Favor aponta-lo para a fase especial : CQS -> PRODUÇÃO","Fase Atual Inválida Imp. Etiqueta")
		Return .f.
	endif
	
	IF ZZ4->ZZ4_CODCLI==ccliente .and. ZZ4->ZZ4_LOJA==ccloja
		SA1->(dbSeek(xFilial("SA1") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA ))
		_cIMEI     := ZZ4->ZZ4_IMEI
		nAt := AT('-',ZZ4->ZZ4_CODPRO)
		_cModelo   := Posicione("SB1",1,xFilial("SB1") + ZZ4->ZZ4_CODPRO, ALLTRIM("B1_MODELO"))                // alterado por Luis Carlos - Maintech
		_cestCli   := SA1->A1_EST
		_cnomecli  := alltrim(SA1->A1_NREDUZ ) //alltrim(SA1->A1_NOME)  + ' - ' + ZZ4->ZZ4_CODCLI + '/' + ZZ4->ZZ4_LOJA
		nRegZZ4 := ZZ4->(RECNO())
	ELSE
		apMsgStop("Caro usuário, Esse IMEI :"+alltrim(_cIMEI)+" informado NÃO é o mesmo do cliente/loja escolhido. O IMEI entrou no Cliente/Loja : "+ZZ4->ZZ4_CODCLI+"/"+ZZ4->ZZ4_LOJA,"IMEI Invalido")
		Return .f.
	ENDIF
Else
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")
	return .f.
EndIF

Return .t.



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ckhser   ³ Autor ³      Edson Rodrigues              16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel validar o Serial                          ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ChkSer()
Local _Lachou   := .F.
Local _cValid	:= .F.
Local cQry

If Empty(ccImei)
	apMsgStop("Caro usuário, o IMEI nao foi informado.","IMEI não informado")
	return .f.
EndIF

If Empty(ccliente)
	apMsgStop("Caro usuário, o código do Cliente nao foi informado, clique [F9].","Cod Cliente não informado")
	return .f.
EndIF

If Empty(ccloja)
	apMsgStop("Caro usuário, o código do Cliente nao foi informado, clique [F9].","Cod Cliente não informado")
	return .f.
EndIF

/*  
Alterado por Uiran Almeida receber o imei mais recente
A validação anterior estava buscanco O.S. Alfanumerica da matriz  
*/

//ZZ4->(dbSetorder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
ZZ4->(dbSetorder(4)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS

if ZZ4->(dbSeek(xFilial("ZZ4") + ccIMEI))
	/*while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCImei)
		ZZ4->(dbSkip())
	enddo
	ZZ4->(dbSkip(-1))*/
	_lAchou := alltrim(ZZ4->ZZ4_IMEI) == alltrim(ccImei)
elseif !empty(ccIMEI)
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")
endif

if _lAchou
	_operbgh   	:= ZZ4->ZZ4_OPEBGH
	_cvalseri  	:= Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_VALSER")
	_cValid		:= .T.
	
	If _cvalseri <> "S"
		apMsgStop("Caro usuário, A operacao desse IMEI informado não valida o serial. ","Operacao Invalida para validar Serial")
		Return .F.
	Else
		IF !empty(ccSerial)
			_clab :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_LAB")
		Else
			apMsgStop("Caro usuário, o Serial nao foi informado.","Serial não informado")
			return .f.
		Endif
	Endif
	
	IF !ALLTRIM(ZZ4->ZZ4_CARCAC)==ALLTRIM(ccSerial)
		apMsgStop("Caro usuário, O serial :"+alltrim(ccSerial)+" é diferente do serial da entrada. O serial da entrada é : "+ALLTRIM(ZZ4->ZZ4_CARCAC),"Serial Invalido")
		Return .f.
	ENDIF
	
	If mv_par02 == 2
		
		If _cValid
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa procedure                                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSProc := "SP_BulkAutomatico '\\bgh005\MOTOROLA\Motorola\LOG\', '" + AllTrim(ccImei) + ".txt','CARDU'"
			TcSQLExec(cSProc)
			
			If Select("QRY") > 0
				QRY->(dbCloseArea())
			EndIf
			
			cQry := " SELECT ZZ4_CARDU CARDU "
			cQry += " FROM " + RetSqlName("ZZ4") + "(NOLOCK) "
			cQry += " WHERE D_E_L_E_T_ = '' "
			cQry += " AND ZZ4_IMEI = '"+AllTrim(ccImei)+"' "
			cQry += " AND ZZ4_CARCAC = '"+AllTRim(ccSerial)+"' "
			cQry += " AND ZZ4_STATUS < 9 "
			
			TCQUERY cQry NEW ALIAS QRY
			
			dbSelectArea("QRY")

			ccCardu :=  AllTrim(QRY->CARDU)
			
			QRY->(dbCloseArea())
			
		EndIf
	EndIf
Else
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")
	return .f.
EndIF

If mv_par02 == 2 .And. !Empty(ccImei)
	ImpEti()
EndIF


Return .t.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ChkCArd   ³ Autores ³ Claudia Cabral/Edson Rodrigues-16/09/10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ³±±
±±³Descricao  ³ Funcao responsavel validar o CARD-U digitado e fazer a       ³±±
±±³           ³ impressao da etiqueta e gravação do CARD-U no ZZ3 e ZZ4      ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ChkCArd()

Local cQuery := ""

If Empty(ccCardu)
	apMsgStop("Caro usuário, o CARD-U nao foi informado.","CARD-U não informado")
	return .f.
EndIF
If len(Alltrim(ccCardu)) < 15
	apMsgStop("Caro usuário, o CARD-U nao foi informado incorretamente","CARD-U incorreto")
	return .f.
EndIF
If ! Right(ccCardu,3) $ "310/360"
	apMsgStop("Caro usuário, final do CARD-U informado incorretamente","CARD-U incorreto")
	return .f.
EndIF                            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se o numero do CARDIU informado está em processo³
//³BGH em outro IMEI - D.FERNANDES - 18/09/2013.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT ZZ4_IMEI "
cQuery += " FROM "+RetSqlName("ZZ4")+" ZZ4(NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("ZZJ")+" ZZJ ON (ZZJ_OPERA = ZZ4_OPEBGH AND ZZJ.D_E_L_E_T_ = '' ) "
cQuery += " WHERE ZZ4_STATUS < '9' "
cQuery += " AND ZZ4.D_E_L_E_T_ = '' "
cQuery += " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
cQuery += " AND ZZJ_ETQCDU = 'S' "
cQuery += " AND ZZ4_CARDU = '"+ccCardu+"' "

If Select("TSQL") > 0
	TSQL->(dbCloseArea())
Endif

TCQUERY cQuery ALIAS "TSQL" NEW

dbSelectArea("TSQL")
TSQL->(dbGoTop())
      
While TSQL->(!Eof())

	If Alltrim(_cIMEI) <> Alltrim(TSQL->ZZ4_IMEI)
		Aviso("CARD-U em processo","O CARD-U: "+ ccCardu +" está em processo no IMEI: "+TSQL->ZZ4_IMEI+" , não será possível imprimir etiqueta!",{'OK'}) 
		Return .f.            
	EndIf
	
	TSQL->(dbSkip())	
EndDo


DbSelectArea("ZZ4")
If nRegZZ4 > 0 .and. FIELDPOS("ZZ4_CARDU") > 0   //verifica se existe o campo na base de dados antes de gravar e se conseguiu posicionar no ZZ4
	ZZ4->(DbGoTo(nRegZZ4))
	RecLock("ZZ4",.F.)
	ZZ4->ZZ4_CARDU := ccCardu
	MsUnlock()
endif
DbSelectArea("ZZ3")
DbSetOrder(1)
If FIELDPOS("ZZ3_CARDU") > 0   //verifica se existe o campo na base de dados antes de gravar
	ZZ3->(MsSeek(XFILIAL("ZZ3") + _cIMEI))
	Do while !ZZ3->(Eof()) .and. ZZ3->ZZ3_IMEI = _cIMEI
		If ZZ3->ZZ3_ENCOS = 'S' // IMEI COM OS ENCERRADA, GRAVAR NUMERO DO CARD-U
			RecLock("ZZ3",.F.)
			ZZ3->ZZ3_CARDU := ccCardu
			MsUnlock()
			Exit
		EndIf
		ZZ3->(DbSkip())
	EndDo
EndIF
If !Empty(ccImei)
	ImpEti()
EndIF
Return .t.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)






/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ DigiCli   ³ Autores ³ Claudia Cabral/Edson Rodrigues-16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Tela para escolha do codigo e loja do cliente                ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DigiCli()
//Local _aArea   		:= {}
//Local _aAlias  		:= {}
//Local _aArea            := SaveArea1({"SA1"})
Local _aAreaSA1 := SA1->(GetArea()) //Alterado e Incluso - Edson Rodrigues - 04/08/10
// Variaveis Private da Funcao
PRIVATE ocCliente
PRIVATE ocLoja

Private oDlgCli				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

DEFINE MSDIALOG oDlgCli TITLE "Validacao Cliente Impr. Etiqueta" FROM C(306),C(324) TO C(465),C(534) PIXEL

// Cria as Groups do Sistema
@ C(001),C(002) TO C(080),C(103) LABEL "Cliente" PIXEL OF oDlgCli

// Cria Componentes Padroes do Sistema
@ C(015),C(004) Say "Cliente" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlgCli
@ C(030),C(005) Say "Loja"  Size C(012),C(008) COLOR CLR_BLACK PIXEL OF oDlgCli
@ C(014),C(025) MsGet ocCliente Var cCliente F3 "SA1"  VALID Valcli('1',cCliente,ccloja) Size C(052),C(009) COLOR CLR_BLACK PIXEL OF oDlgCli
@ C(030),C(026) MsGet ocLoja Var ccLoja VALID Valcli('2',cCliente,ccLoja) Size C(013),C(009) COLOR CLR_BLACK PIXEL OF oDlgCli
DEFINE SBUTTON FROM C(058),C(043) TYPE 1 ENABLE OF oDlgCli ACTION (oDlgCli:end())


ACTIVATE MSDIALOG oDlgCli CENTERED

restarea(_aAreaSA1)

Return(.T.)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ValCli    ³ Autores ³ Claudia Cabral/Edson Rodrigues-16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel validar a codigo e loja do cliente esco-  ³±±
±±³           ³ lhidos.                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValCli(copc,cCliente,ccLoja)


If copc='1' .and. SA1->(DbSeek(Xfilial("SA1") + cCliente))
	ccLoja := SA1->A1_LOJA
	ocLoja:refresh()
	
Elseif copc='2' .AND. SA1->(DbSeek(Xfilial("SA1") + cCliente+ccLoja))
	Return .T.
	
ElseIf copc='2' .and. !empty(cCliente) .and. !empty(ccLoja) .and. !SA1->(DbSeek(Xfilial("SA1") + cCliente+ccLoja))
	apMsgStop("Cliente Invalido","Cliente")
	Return .f.
	
ElseIf copc='2' .and. empty(cCliente) .and. !empty(ccLoja)
	apMsgStop("Favor digitar ou escolher o código do Cliente","Cliente")
	Return .f.
Else
	apMsgStop("Cliente Invalido","Cliente")
	Return .f.
EndIf

Return .t.




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ImpEti    ³ Autores ³ Claudia Cabral/Edson Rodrigues-16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel pela impressão da etiqueta Card-U         ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpEti()
Local nX
//Local _aLin := {03,06,09,12,15}
Local _aLin := {}
Local _aCol := {}  //05,30
Local cfont := "0"
Local _afont :={"020,026","030,040","055,075","065,085","090,090","100,100","110,110"}
Local datab	:= dDataBase
Local hora	:= Time()

IF MV_PAR01 == 1
	_aLin := {03,07,11,15,18}
	_aCol := {02,16,16,55}  //05,30
ELSEIf MV_PAR01 == 2
	_aLin := {06,15,22,31,39}
	_aCol := {10,20,23,107}  //05,30
Else	
	_aLin 	:= {02,09,14,21,27,31,35}
	_aCol 	:= {05,17,20,70,90}
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura da Matriz                                                         ³
//³ 01 - IMEI                                                                   ³
//³ 02 - Numero da OS                                                           ³
//³ 03 - Item da OS                                                             ³
//³ 04 - Numero da NF de Entrada                                                ³
//³ 05 - Serie da NF de Entrada                                                 ³
//³ 06 - Modelo do aparelho                                                     ³
//³ 07 - Data de Entrada                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Layout da Etiqueta                              ³
//³ Ú--------------- 88 mm -----------------------¿ ³
//³ |  CARD-U: 000000000000000  XXXXXXXXXXXXXX    | ³
//³ |  IMEI: 000000000000000           UF      22 | ³
//³ |  CLIENTE                                 mm ³ ³
//³ À---------------------------------------------Ù ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

for nx =1 to 1
	//MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.)
	IF MV_PAR01 == 1 //200 DPI
		MSCBPRINTER("S300","LPT1",,022,.F.,,,,,,.T.)
		MSCBBEGIN(1,6)
		//                                  direcao fonte   tamanho
		MSCBSAYBAR(_aCol[1],_aLin[1],ccCardU,"N","MB07",3.5,.F.,.F.,.F.,,2,1)    // Coluna 1 - Linha 1
		MSCBSAY(   _aCol[4],_aLin[1],"Modelo: " + _cModelo,"N",cfont,_afont[1])  // Coluna 2 - Linha1
		
		MSCBSAY(_aCol[1],_aLin[2],"Card-U: " + ccCardu     ,"N",cfont,_afont[1])  // Coluna 1 - Linha 2
		MSCBSAYBAR(_aCol[4],_aLin[2],_cModelo,"N","MB07",3.5,.F.,.F.,.F.,,2,1)    // Coluna 1 - Linha 1
		//MSCBSAY(_aCol[4],_aLin[2],Transform(datab, "@E 99/99/99") + ' - ' + (hora)   ,"N",cfont,_afont[1])
		
		MSCBSAYBAR(_aCol[1],_aLin[3],alltrim(ccImei),"N","MB07",3.5,.F.,.F.,.F.,,2,1)
		MSCBSAY(_aCol[1],_aLin[4],"IMEI: " 		+ alltrim(ccImei) ,"N",cfont,_afont[1])  // Coluna 1 - Linha 1
		
		// ALT,LARG
		//MSCBSAY(_aCol[4]+14,_aLin[4], _cestCli,"N",cfont,_afont[2])  // Coluna 2 - Linha1
		MSCBSAY(_aCol[4],_aLin[4], _cestCli + ' '+ Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,"020,020")  // Coluna 2 - Linha1
		
		MSCBSAY(_aCol[1],_aLin[5],_cnomecli + ' - ' + AllTRim(_operbgh) + '-' + AllTrim(_operdescri),"N",cfont,_afont[1])  // Coluna 2 - Linha 2
		
		//MSCBSAY(_aCol[4]+20,_aLin[5],Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[3])  // Coluna 2 - Linha 2
		
		MSCBEND()
		
		MSCBCLOSEPRINTER()
	ELSEIf MV_PAR01 == 2 //600 DPI
		
		MSCBPRINTER("Z90XI","LPT1",,22,.F.,,,,,,.T.)
		MSCBBEGIN(1,6)
		MSCBSAYBAR(_aCol[1],_aLin[1],ccCardU,"N","MB07",8,.F.,.F.,.F.,,5,2)    // Coluna 1 - Linha 1
		MSCBSAY(   _aCol[4],_aLin[1],"Modelo: " + _cModelo,"N",cfont,_afont[3])  // Coluna 2 - Linha1
		
		MSCBSAY(_aCol[1],_aLin[2],"Card-U: " + ccCardu     ,"N",cfont,_afont[3])  // Coluna 1 - Linha 2
		MSCBSAYBAR(_aCol[4],_aLin[2],_cModelo,"N","MB07",8,.F.,.F.,.F.,,5,2)    // Coluna 1 - Linha 1
		//MSCBSAY(_aCol[4],_aLin[2],Transform(datab, "@E 99/99/99") + ' - ' + (hora)   ,"N",cfont,_afont[3])
		
		MSCBSAYBAR(_aCol[1],_aLin[3],alltrim(ccImei),"N","MB07",8,.F.,.F.,.F.,,5,2)
		MSCBSAY(_aCol[1],_aLin[4],"IMEI: " 		+ alltrim(ccImei) ,"N",cfont,_afont[3])  // Coluna 1 - Linha 1
		
		// ALT,LARG
		//MSCBSAY(_aCol[4]+20,_aLin[4]-2, _cestCli ,"N",cfont,_afont[4])  // Coluna 2 - Linha1
		MSCBSAY(_aCol[4],_aLin[4], _cestCli + ' '+ Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[4])  // Coluna 2 - Linha1
		
		MSCBSAY(_aCol[1],_aLin[5],_cnomecli + ' - ' + AllTRim(_operbgh) + '-' + AllTrim(_operdescri),"N",cfont,_afont[3])  // Coluna 2 - Linha 2
		
		//	MSCBSAY(_aCol[4]+20,_aLin[5],Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[3])  // Coluna 2 - Linha 2
		MSCBEND()
		
		MSCBCLOSEPRINTER() 
	Else //300 DPI
		MSCBPRINTER("S300","LPT1",,022,.F.,,,,,,.T.)
		MSCBBEGIN(1,6)
		//                                  direcao fonte   tamanho
		MSCBSAYBAR(_aCol[1],_aLin[1],ccCardU,"N","MB07",4.5,.F.,.F.,.F.,,2,1)    // Coluna 1 - Linha 1
		MSCBSAY(   _aCol[4],_aLin[1],"Modelo: " + _cModelo,"N",cfont,_afont[2])  // Coluna 2 - Linha1
		
		MSCBSAY(_aCol[1],_aLin[2],"Card-U: " + ccCardu     ,"N",cfont,_afont[2])  // Coluna 1 - Linha 2
		MSCBSAYBAR(_aCol[4],_aLin[2],_cModelo,"N","MB07",4.5,.F.,.F.,.F.,,2,1)    // Coluna 1 - Linha 1
		//MSCBSAY(_aCol[4],_aLin[2],Transform(datab, "@E 99/99/99") + ' - ' + (hora)   ,"N",cfont,_afont[1])
		
		MSCBSAYBAR(_aCol[1],_aLin[3],alltrim(ccImei),"N","MB07",4.5,.F.,.F.,.F.,,2,1)
		MSCBSAY(_aCol[1],_aLin[4],"IMEI: " 		+ alltrim(ccImei) ,"N",cfont,_afont[2])  // Coluna 1 - Linha 1
		
		// ALT,LARG
		//MSCBSAY(_aCol[4]+14,_aLin[4], _cestCli,"N",cfont,_afont[2])  // Coluna 2 - Linha1
		MSCBSAY(_aCol[4],_aLin[4], _cestCli + ' '+ Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[2])  // Coluna 2 - Linha1
		
		MSCBSAY(_aCol[1],_aLin[5],_cnomecli + ' - ' + AllTRim(_operbgh) + '-' + AllTrim(_operdescri),"N",cfont,_afont[2])  // Coluna 2 - Linha 2
		
		//MSCBSAY(_aCol[4]+20,_aLin[5],Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[3])  // Coluna 2 - Linha 2
		
		MSCBEND()
		
		MSCBCLOSEPRINTER()
		
	ENDIF
NEXT
ccCardu  := space(15)
ccImei   := Space(TamSX3("ZZ4_IMEI")[1])//space(20)
ccSerial := space(15)
ocImei:Setfocus()

Return  .t.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ valifase  ³ Autores ³      Edson Rodrigues           16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel pela validacao da fase de impressao       ³±±
±±³           ³ da etiqueta Card-u                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Static function valifase(_clab,_cos,cimei)

Local cquery:=""
Local lret  :=.f.

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf


cquery:=" SELECT ZZ3_LAB+ZZ3_CODSE2+ZZ3_FASE2 AS LABSETFAS "
cquery+=" FROM "+RETSQLNAME("ZZ3")+"(NOLOCK)" "
cquery+="      INNER JOIN (SELECT ZZ1_LAB,ZZ1_CODSET,ZZ1_FASE1 "
cquery+="                  FROM "+RETSQLNAME("ZZ1")+" (NOLOCK) WHERE ZZ1_FILIAL='"+XFILIAL("ZZ1")+"' AND D_E_L_E_T_='' AND ZZ1_CQSPRO='S') AS ZZ1 "
cquery+="      ON ZZ1_LAB=ZZ3_LAB AND ZZ1_CODSET=ZZ3_CODSE2 AND ZZ1_FASE1=ZZ3_FASE2 "
cquery+=" WHERE ZZ3_FILIAL='"+XFILIAL("ZZ3")+"' AND ZZ3_IMEI='"+cimei+"' AND ZZ3_NUMOS='"+_cos+"' AND D_E_L_E_T_='' AND ZZ3_LAB='"+_clab+"' "

TCQUERY cquery ALIAS "QRY" NEW

If Select("QRY") > 0
	QRY->(dbGoTop())
	IF QRY->(!eof()) .and. !empty(QRY->LABSETFAS)
		lret:=.T.
	Endif
	QRY->(dbCloseArea())
Endif            

Return(lret)



Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Impressora","Impressora","Impressora","mv_ch1","N",01,0,0,"C","",""	,"",,"mv_par01","ZEBRA 200 DPI"	,"","","","ZEBRA 600 DPI"		,"ZEBRA 300 DPI","",""	,"","","","","","","","")
PutSX1(cPerg,"02","Dig. Card-U","Dig. Card-U","Dig. Card-U","mv_ch2","N",01,0,0,"C","",""	,"",,"mv_par02","Sim"	,"","","","Não"		,"","",""	,"","","","","","","","")

Return Nil