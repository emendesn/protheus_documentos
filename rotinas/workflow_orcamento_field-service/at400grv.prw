#INCLUDE "rwmake.ch"
#Include "AP5Mail.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณP.E. UTILIZADO NA GRAVACAO DO CHAMADO TECNICO               บฑฑ
ฑฑบ          ณENVIA WORKFLOW PARA O CLIENTE NOS CASOS DE INCL. E ORCAMENTOบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AT400GRV()


Local aMens     := {} //{01-CODIGO,02-MENSAGEM}
Local nItem     := 0
Local nTotalPrc := 0
Local oHtml
Local cEmail := Space(30)
Local cCepPict:=PesqPict("SA1","A1_CEP")
Local cCGCPict:=PesqPict("SA1","A1_CGC")
Private cEmailUsu



//busca todos os dados do cabecalho
cQuery := " SELECT AB3_NUMORC,AB3_CODCLI,AB3_LOJA, AB3_EMISSA, A1_COD, A1_LOJA, "
cQuery += " A1_NOME,A1_CONTATO, A1_TEL, A1_END, A1_CEP,A1_FAX, A1_MUN,A1_EST, A1_CGC, A1_INSCR, A1_ENDENT,A1_CEPE,"
cQuery += " A1_ENDCOB,A1_CEPC,A1_MUNE,A1_ESTE,A1_MUNC,A1_ESTC, A1_EMAIL, A1_TIPO, A1_VEND "
cQuery += " FROM AB3010 AS AB3 "
cQuery += " INNER JOIN SA1010 AS A1 "
cQuery += " ON AB3_CODCLI = A1_COD AND AB3_LOJA = A1_LOJA "
//verifica se a rotina esta sendo executada pelo sigatec ou pelo schedule
If ProcName(1) == "U_RCFGE52"
	cQuery += " WHERE AB3.D_E_L_E_T_ <> '*'  AND A1.D_E_L_E_T_ <> '*' AND AB3_NUMORC = '"+cNumOrc+"'"
Else
	cQuery += " WHERE AB3.D_E_L_E_T_ <> '*'  AND A1.D_E_L_E_T_ <> '*' AND AB3_NUMORC = '"+AB3->AB3_NUMORC+"'"
EndIf
cQuery += " AND AB3_STATUS = 'A'"
MemoWrit("AT400GRV.sql",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
TcSetField("TRB","AB3_EMISSA","D")

COUNT TO nRecCount
//CASO TENHA DADOS
If nRecCount > 0
	dbSelectArea("TRB")
	dbGoTop()
	cNumOrc := TRB->AB3_NUMORC
	//atualiza quando nao for rotina automatica do configurador
	If len(PswRet()) # 0
		cEmailUsu := PswRet()[1][14]
	EndIF
	
	//caso nao encontre um e-mail
	cEmail := TRB->A1_EMAIL
	If Empty(cEmail)
		If MsgYesNo("O Cliente "+TRB->A1_COD+"-"+TRB->A1_NOME+" nใo tem um email cadastrado, deseja cadastrar agora?")
			
			@ 100,153 To 329,435 Dialog oDlg Title OemToAnsi("Endere็o de e-mail")
			@ 9,9 Say OemToAnsi("E-mail") Size 99,8
			@ 28,9 Get cEmail  Size 79,10
			
			@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
			
			Activate Dialog oDlg Centered
			//grava o email no SA1
			cQuery := " UPDATE SA1010 SET A1_EMAIL = '"+cEmail+"' WHERE A1_COD = '"+TRB->A1_COD+"' AND A1_LOJA = '"+TRB->A1_LOJA+"'
			MemoWrit("AT400GRVb.sql",cQuery)
			TcSqlExec(cQuery)
		EndIf
	EndIf
	
	//Caso nao tenha cadastrado e-mail aborta a operacao
	If Alltrim(cEmail) == ""
		cCliMen  := TRB->AB3_CODCLI +"-"+ TRB->A1_NOME
		MsgStop("Opera็ใo cancelada!")
		cMen := "O Cliente "+cCliMen+" nใo possui e-mail Cadastrado"
		ENVIAEMAIL(cMen)
		TRB->(dbCloseArea())
		Return
	EndIf
	
	//FUNCOES PARA ENVIO DE HTML
	oProcess:=TWFProcess():New("000006","Or็amento de Assist๊ncia T้cnica")
	oProcess:NewTask('Inicio',"\WORKFLOW\HTM\FINE08.htm")
	oHtml   := oProcess:oHtml
	
	//armazena dados do usuario
	PswOrder(1)
	if PswSeek(cUsuario,.t.)
		aInfo    := PswRet(1)
		_cUser   := aInfo[1,2]
	endIf
	
	cCodPro := ""
	dbSelectArea("TRB")
	dbGoTop()
	While !EOF()
		dbSelectArea("TRB")
		aMens := {}
		cCliente := TRB->AB3_CODCLI
		cCliMen  := TRB->AB3_CODCLI +"-"+ TRB->A1_NOME
		cLojaCli := TRB->AB3_LOJA
		nOrcam   := TRB->AB3_NUMORC
		dEmiss   := TRB->AB3_EMISSA
		nAcresc  := 0
		nAcresc  := 0
		tTransp  := ""
		
		oHtml:ValByName("cNumero", TRB->AB3_NUMORC) 					//numero do pedido
		
		//dados da empresa corrente
		oHtml:ValByName("cNomEmp", SM0->M0_NOMECOM)					//nome da empresa coorente
		oHtml:ValByName("cEnd"   , SM0->M0_ENDCOB)					//endereco
		oHtml:ValByName("cTel"	 , SM0->M0_TEL)						//telefone
		oHtml:ValByName("cMun"	 , SM0->M0_CIDCOB)					//municipio
		oHtml:ValByName("cEst"	 , SM0->M0_ESTCOB)					//Estado
		oHtml:ValByName("cCNPJ"	 , Transform(SM0->M0_CGC,cCgcPict))	//cnpj
		
		//dados do cliente
		oHtml:ValByName("cCliente" , TRB->A1_COD + " / " + TRB->A1_LOJA)		//codigo + loja
		oHtml:ValByName("cNomCli"  , TRB->A1_NOME)								//razao social do cliente
		oHtml:ValByName("cContato" , TRB->A1_CONTATO)							//conato
		oHtml:ValByName("cTelCli"  , TRB->A1_TEL)								//telefone
		oHtml:ValByName("cEndCli"  , TRB->A1_END)								//Endereco
		oHtml:ValByName("cCEPCli"  , transform( TRB->A1_CEP, "@R 99999-999" ))	//cep
		oHtml:ValByName("cFaxCli"  , TRB->A1_FAX)								//fax
		oHtml:ValByName("cMunCli"  , TRB->A1_MUN)								//municipio
		oHtml:ValByName("cEstCli"  , TRB->A1_EST)								//estado
		oHtml:ValByName("cCNPJCli" , Transform(TRB->A1_CGC,cCgcPict))			//cnpj
		oHtml:ValByName("cIECli"   , TRANSFORM(TRB->A1_INSCR ,"@R 999.999.999.999")) //inscricao estadual
		//dados da entrega
		oHtml:ValByName("cEndEnt"  , TRB->A1_ENDENT)								//endereco de entrega
		oHtml:ValByName("cCEPEnt"  , transform( TRB->A1_CEPE, "@R 99999-999" ))	//cep de entrega
		oHtml:ValByName("cMunEnt"  , TRB->A1_MUNE)								//municipio de entrega
		oHtml:ValByName("cEstEnt"  , TRB->A1_ESTE)								//estado de entrega
		oHtml:ValByName("cTelEnt"  , TRB->A1_TEL )								//telefone de entrega
		//dados da cobranca
		oHtml:ValByName("cEndCob"  , TRB->A1_ENDCOB)								//endere็o de cobran็a
		oHtml:ValByName("cCEPCob"  , transform( TRB->A1_CEPC, "@R 99999-999" ))	//cep de cobranca
		oHtml:ValByName("cMunCob"  , TRB->A1_MUNC)								//municipio de cobranca
		oHtml:ValByName("cEstCob"  , TRB->A1_ESTC)								//estado de cobranca
		oHtml:ValByName("cTelCob"  , TRB->A1_TEL)								//telefone de cobranca
		
		
		//le os itens do orcamento
		
		cQuery := " SELECT AB3_NUMORC,AB4_ITEM,AB4_CODPRO, AB4_NUMSER,"
		cQuery += " B1_IPI, B1_DESC,B1_UM"
		cQuery += " FROM AB3010 AS AB3"
		cQuery += " INNER JOIN AB4010 AS AB4"
		cQuery += " ON AB4_NUMORC = AB3_NUMORC"
		cQuery += " INNER JOIN SB1010 AS B1"
		cQuery += " ON B1_COD = AB4_CODPRO"
		cQuery += " WHERE AB3.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*' AND AB4.D_E_L_E_T_ <> '*' "
		cQuery += " AND AB3_NUMORC = '"+TRB->AB3_NUMORC+"'"
		MemoWrit("AT400GRVa",cQuery)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)
		
		COUNT TO nRecCount
		//CASO TENHA DADOS
		If nRecCount > 0
			
			dbSelectArea("TRB1")
			dbGoTop()
			
			
			//monta matriz dos itens
			oHtml:ValByName("it.it"         , {})
			oHtml:ValByName("it.cProduto"   , {})
			oHtml:ValByName("it.cDesc"      , {})
			oHtml:ValByName("it.cNser"      , {})
			oHtml:ValByName("it.cServ"      , {})
			oHtml:ValByName("it.cMaterial"  , {})
			oHtml:ValByName("it.cDescMat"   , {})
			oHtml:ValByName("it.cQtdVen"      , {})
			oHtml:ValByName("it.cPrcVen"      , {})
			oHtml:ValByName("it.cValor"      , {})
			
			While !EOF()
				dbSelectArea("TRB1")
				
				//GRAVA UM ITEM DIFERENCIADO POR PRODUTO NO AB4
				If TRB1->AB4_CODPRO # cCodPro
					//itens do orcamento
					aadd(oHtml:ValByName("it.it")      , TRB1->AB4_ITEM)
					aadd(oHtml:ValByName("it.cProduto"), TRB1->AB4_CODPRO)
					aadd(oHtml:ValByName("it.cDesc")   , SubStr(TRB1->B1_DESC,1,38))
					aadd(oHtml:ValByName("it.cNser")   , TRB1->AB4_NUMSER)
					aadd(oHtml:ValByName("it.cServ")   , "")
					aadd(oHtml:ValByName("it.cMaterial"), "")
					aadd(oHtml:ValByName("it.cDescMat") , "")
					aadd(oHtml:ValByName("it.cQtdVen") , Transform(0,"@E 999,999"))
					aadd(oHtml:ValByName("it.cPrcVen") , Transform(0,"@E 999,999.99"))
					aadd(oHtml:ValByName("it.cValor")  , Transform(0,"@E 9,999.99"))
				EndIf
				cCodPro := TRB1->AB4_CODPRO
				
				//GRAVA DADOS NO AB4
				dbSelectArea("AB4")
				dbSetOrder(1)
				dbSeek(xFilial()+TRB->AB3_NUMORC+TRB1->AB4_ITEM)
				RecLock("AB4",.F.)
				AB4_WFCO   := "1003"
				If Empty(AB4_WFDT)
					AB4_WFDT   := dDataBase
				EndIF
				If Empty(AB4_WFEMAI)
					If cUsername == "Administrador"
						AB4_WFEMAI := "pbindo@cis.com.br"//GetMV("MV_RELACNT")
					Else
						AB4_WFEMAIL := cEmailUsu
					EndIF
				EndIf
				AB4_WFID := oProcess:fProcessID
				MsUnlock()
				
				//busca os itens do AB5, que contem os precos e pecas utilizadas
				dbSelectArea("AB5")
				dbSetOrder(1)
				If dbSeek(xFilial()+TRB1->AB3_NUMORC+TRB1->AB4_ITEM)
					While !EOF() .And. TRB1->AB3_NUMORC+TRB1->AB4_ITEM == AB5_NUMORC+AB5_ITEM
						nPgto := Posicione("AA5",1,xFilial("AA5")+AB5->AB5_CODSER,"AA5_PRCCLI")
						//caso o cliente nao tenha que pagar pelo servico
						If nPgto == 0
							dbSkip()
							Loop
						EndIf
						cServico := Posicione("AA5",1,xFilial("AA5")+AB5->AB5_CODSER,"AA5_DESCRI")
						//itens do orcamento
						aadd(oHtml:ValByName("it.it")      , TRB1->AB4_ITEM)
						aadd(oHtml:ValByName("it.cProduto"), "")
						aadd(oHtml:ValByName("it.cDesc")   , "")
						aadd(oHtml:ValByName("it.cNser")   , "")
						aadd(oHtml:ValByName("it.cServ")   , cServico)
						aadd(oHtml:ValByName("it.cMaterial"), AB5->AB5_CODPRO)
						aadd(oHtml:ValByName("it.cDescMat"), SubStr(AB5->AB5_DESPRO,1,38))
						aadd(oHtml:ValByName("it.cQtdVen") , Transform(AB5->AB5_QUANT,"@E 999,999"))
						aadd(oHtml:ValByName("it.cPrcVen") , Transform(((AB5->AB5_VUNIT*nPgto)/100),"@E 999,999.99"))
						aadd(oHtml:ValByName("it.cValor")  , Transform(((AB5->AB5_TOTAL*nPgto)/100),"@E 9,999.99"))
						
						//soma os totais
						nTotalPrc += ((AB5->AB5_TOTAL*nPgto)/100)
						
						dbSkip()
					End
				EndIf
				
				dbSelectArea("TRB1")
				dbSkip()
			End
			TRB1->(dbCloseArea())
		EndIf
		//totais do orcamento
		oHtml:ValByName("cTotalPrc"  , Transform(nTotalPrc,"@E 9,999,999.99"))		//valor unitario
		
		dbSelectArea("TRB")
		dbSkip()
	End
	
	oProcess:cTo      := cEmail
	oProcess:cBCC     := ''
	oProcess:cSubject := "Processo de Or็amento de Assist๊ncia T้cnica " + cNumOrc
	oProcess:cBody    := ""
	oProcess:bReturn  := "U_AT4GRVa(1)"
	oProcess:Start()
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000006",'1003',"Email Enviado Para o Cliente: "+TRB->A1_NOME,cUsername)
	WFSendMail()
	cProc := Lower(oProcess:fProcessID)
	cMen := "Or็amento "+cNumOrc+" enviado ao cliente "+cCliMen+" no e-mail "+cEmail+""
	ENVIAEMAIL(cMen)
	
EndIf


TRB->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณENVIAEMAILบAutor  ณMicrosiga           บ Data ณ  12/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ENVIAEMAIL(cMen)

Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo1
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local cEmailTo
Local cEmailBcc:= ""
Local cError   := ""
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.
Local cFrom	   := GetMV("MV_RELACNT")
Local cConta   := GetMV("MV_RELACNT")
Local cSenha   := GetMV("MV_RELPSW")

cEmailTo := "PBINDO@CIS.COM.BR"//cEmailUsu
cTitulo1:= "Or็amento de Assist๊ncia T้cnica "
cMensagem:= cMen


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tenta conexao com o servidor de E-Mail ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
RESULT   lResult             	// Resultado da tentativa de conexใo

// Se a conexao com o SMPT esta ok
If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth(cConta,cSenha)
	Else
		lRet := .T.
	Endif
	
	If lRet
		SEND MAIL FROM 	cFrom ;
		TO 				cEmailTo;
		BCC     		cEmailBcc;
		SUBJECT 		cTitulo1;
		BODY 			cMensagem;
		RESULT lResult
		
		
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
			Help(" ",1,"ATENCAO",,cError+ " " + cEmailTo,4,5)	//STR0006
		Endif
		
	Else
		GET MAIL ERROR cError
		Help(" ",1,"Autenticacao",,cError,4,5)
		MsgStop("Erro de autentica็ใo","Verifique a conta e a senha para envio")
	Endif
	
	DISCONNECT SMTP SERVER
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"Atencao",,cError,4,5)
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorno do workflow de orcamento de Assistencia Tecnica     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AT4GRVa(nOpcao,oProc)
Private cEmailUsu
Private cEmailAdm

// Orcamento recebido e parametro ativado
If oProc:oHtml:RetByName("Aprovacao") = "S" .And. GetMV("MV_E_GRPV")=="S"
	
	cNUM     := oProc:oHtml:RetByName("cNumero")
	
	dbSelectArea("AB3")
	dbSetOrder(1)
	dbSeek(xFilial()+cNum)
	
	At4Proc(cNum)
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+AB3->AB3_CODCLI+AB3->AB3_LOJA)
	cOS := Posicione("AB4",1,xFilial("AB4")+AB3->AB3_NUMORC,"AB4_NUMOS")
	//envia email para o vendedor avisando que foi gerado o pedido
	cMen := "O Or็amento "+AB3->AB3_NUMORC+" do Cliente "+SA1->A1_NOME+" foi efetivado com sucesso e gerou a OS "+SubStr(cOs,1,6)
	cEmail := "PBINDO@CIS.COM.BR"// IIf(!Empty(cEmailVend),cEmailVend,GetMV("MV_WFADMIN"))
	EnvMail(cMen)
	
	//ATUALIZA O AB4 PARA NAO OCORRER DE GERAR NOVO WORKFLOW
	cQuery := " UPDATE AB4010 SET AB4_WFCO = '1004' WHERE AB4_NUMORC = '"+cNum+"'"
	MemoWrit("AT440GRVc.sql",cQuery)
	TcSqlExec(cQuery)
	
Else
	//envia email para o tecnico avisando que o orcamento foi rejeitado
	cNUM     := oProc:oHtml:RetByName("cNumero")
	
	dbSelectArea("AB3")
	dbSetOrder(1)
	dbSeek(xFilial()+cNum)
	
	cMen := "O Or็amento "+AB3->AB3_NUMORC+" do Cliente "+SA1->A1_NOME+" foi rejeitado pelo motivo:"+CHR(13)+CHR(10)
	cMen += oProc:oHtml:RetByName("Obs")
	cEmailUsu := "PBINDO@CIS.COM.BR"
	EnvMail(cMen)
EndIf


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณENVMAIL   บAutor  ณMicrosiga           บ Data ณ  12/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ENVMAIL(cMen)

Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo1
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local cEmailTo
Local cEmailBcc:= ""
Local cError   := ""
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.
Local cFrom	   := GetMV("MV_RELACNT")
Local cConta   := GetMV("MV_RELACNT")
Local cSenha   := GetMV("MV_RELPSW")

cEmailTo := "PBINDO@CIS.COM.BR"//cEmailUsu
cTitulo1:= "Or็amento de Vendas"
cMensagem:= cMen


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tenta conexao com o servidor de E-Mail ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
RESULT   lResult             	// Resultado da tentativa de conexใo

// Se a conexao com o SMPT esta ok
If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth(cConta,cSenha)
	Else
		lRet := .T.
	Endif
	
	If lRet
		SEND MAIL FROM 	cFrom ;
		TO 				cEmailTo;
		BCC     		cEmailBcc;
		SUBJECT 		cTitulo1;
		BODY 			cMensagem;
		RESULT lResult
		
		
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
			Help(" ",1,"ATENCAO",,cError+ " " + cEmailTo,4,5)	//STR0006
		Endif
		
	Else
		GET MAIL ERROR cError
		Help(" ",1,"Autenticacao",,cError,4,5)
		MsgStop("Erro de autentica็ใo","Verifique a conta e a senha para envio")
	Endif
	
	DISCONNECT SMTP SERVER
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"Atencao",,cError,4,5)
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณAt400Proc ณ Autor ณ Eduardo Riera         ณ Data ณ 02.10.98 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Processamento da Efetivacao de OS                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Void                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function At4Proc(cNum)

Local nCntFor 			:= 0
Local uCampo			:= ""
Local lTravas			:= .T.
Local aTravas			:= {}
Local nUsado			:= 0
Local nPosItem			:= 0
Local aAux				:= {}
Local nSaveSX8       := GetSX8Len()
Private aCols			:= {}
Private aHeader		:= {}
Private aHeaderAB4   := {}
Private AHeaderAB5	:= {}
Private aColsAB5		:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta aHeader                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aT400Monta()
aHeader	:= aClone(aHeaderAB4)
nUsado	:= Len(aHeader)
nPosItem := aScan(aHeaderAB5,{|x| AllTrim(x[2])=="AB5_SUBITE"})
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento da MarkBrowse                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("AB3")
dbSetOrder(1)
dbSeek(xFilial()+cNum)
lTravas	:= .T.
aTravas	:= {}
aCols		:= {}
aColsAb5 := {}
aAux     := {}
aHeader	:= aClone(aHeaderAB4)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria Variaveis de Memoria da Enchoice                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("AB3")
aadd(aTravas , { Alias() , RecNo() })
For nCntFor := 1 To FCount()
	uCampo := FieldName(nCntFor)
	M->&(uCampo) := AB3->(FieldGet(FieldPos(uCampo)))
Next nCntFor
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Acols                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("AB4")
dbSetOrder(1)
dbSeek(xFilial("AB4")+M->AB3_NUMORC)
While ( !Eof() .And. xFilial("AB4") == AB4->AB4_FILIAL .And.;
	M->AB3_NUMORC	== AB4->AB4_NUMORC )
	aadd(aCols,Array(nUsado+1))
	For nCntFor := 1 To nUsado
		If ( aHeader[nCntFor][10] != "V" )
			aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
		Else
			aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
		EndIf
		If ( AllTrim(aHeader[nCntFor][2])=="AB4_TIPO" )
			If AB4->AB4_TIPO == "1"
				aCols[Len(aCols)][nCntFor] := "2"
			EndIf
		EndIf
	Next nCntFor
	aCols[Len(aCols)][nUsado+1] := .F.
	aAux := {}
	dbSelectArea("AB5")
	dbSetOrder(1)
	If ( dbSeek(xFilial("AB5")+M->AB3_NUMORC+AB4->AB4_ITEM) )
		While ( !Eof() .And. xFilial("AB5") == AB5->AB5_FILIAL .And.;
			M->AB3_NUMORC	== AB5->AB5_NUMORC .And.;
			AB4->AB4_ITEM	== AB5->AB5_ITEM )
			aadd(aAux,Array(Len(aHeaderAB5)+1))
			For nCntFor := 1 To Len(aHeaderAB5)
				If ( aHeaderAB5[nCntFor][10] != "V" )
					aAux[Len(aAux)][nCntFor] := FieldGet(FieldPos(aHeaderAB5[nCntFor][2]))
				Else
					aAux[Len(aAux)][nCntFor] := CriaVar(aHeaderAB5[nCntFor][2])
				EndIf
			Next nCntFor
			aAux[Len(aAux)][Len(aHeaderAB5)+1] := .F.
			dbSelectArea("AB5")
			If ( SoftLock("AB5") )
				aadd(aTravas,{Alias(),RecNo()})
			Else
				lTravas := .F.
			EndIf
			dbSkip()
		EndDo
		aadd(aColsAB5,aClone(aAux))
	Else
		aadd(aAux,Array(Len(aHeaderAB5)+1))
		For nCntFor := 1 To Len(aHeaderAB5)
			aAux[Len(aAux)][nCntFor] := CriaVar(aHeaderAB5[nCntFor][2])
		Next nCntFor
		aAux[Len(aAux)][nPosItem] := "01"
		aAux[Len(aAux)][Len(aHeaderAB5)+1] := .F.
		aadd(aColsAB5,aClone(aAux))
	EndIf
	dbSelectArea("AB4")
	If ( SoftLock("AB4") )
		aadd(aTravas,{Alias(),RecNo()})
	Else
		lTravas := .F.
	EndIf
	dbSkip()
EndDo
Begin Transaction
at400Grava(2)
While ( GetSX8Len() > nSaveSx8 )
	ConfirmSx8()
EndDo
End Transaction
For nCntFor := 1 To Len(aTravas)
	dbSelectArea(aTravas[nCntFor][1])
	dbGoto(aTravas[nCntFor][2])
	MsUnLock()
Next nCntFor

Return(.T.)
