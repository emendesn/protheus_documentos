#INCLUDE "Rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TbiConn.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpCompra บ Autor ณ Herbert Ayres       Data ณ  12/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para realizar a importacao da nota fiscal de com- บฑฑ
ฑฑบ          ณ pra da base producao para a base TEF.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs Protheus 10                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function ImpCompra (cConectString, cServer, cEmp, cFil, cTipo, cSerie, cDoc, cFornece, cLoja, dEmissao, cEspecie, cCond, cFormul, nFrete,nxPort)

Local aCabec		:= {}	// Variแvel de cabecalho das nota fiscais de entrada
Local aItens		:= {}	// Variแvel de itens das nota fiscais de entrada
Local cAlias		:= GetNextAlias()	// Variแvel que contem o proximo alias
Local nConexao
Local aErros := {.F.,"OK - impcompra.prw"}
Local lLocal := .F. // colocar .T. para testes 
Local aStruct		     	:= {}
Local C
Local I
Local nX

Private lMsErroAuto	:= .F.	// Variแvel de controle do MsExecAuto e retorno da fun็ใo. Indica se a importa็ใo teve sucesso ou nใo.

// Testes
/*
cConectString	:= "MSSQL7/LEONARDOPROD"
cServer			:= "192.168.1.110"
cEmp		  		:= "01"
cFil				:= "06"
cTipo		  		:= "D"
cSerie			:= "UNI"
cDoc		 		:= "000001"
cFornece	 		:= "018682"
cLoja		 		:= "01"
dEmissao			:= SToD( "20121105" )
cEspecie	 		:= "NF"  
cCond				:= "001"	
cFormul        := "S"
nFrete         := 0
*/
//Seta job para nao consumir licensas
//RpcSetType(3)

// Seta job para empresa filial desejada
//RpcSetEnv( cEmp, cFil,,,'FAT')
PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES  "SX2", "SX3", "SA1", "SA2", "SE4", "SBM", "SF4", "SB1", "SX5" MODULO "FAT"

//Especifica o protocolo de comunica็ใo a ser utilizado pelo TOPConnect.
TCConType("TCPIP")

// Abre uma conexใo com o Top Conect da base producao
//nConexao := TCLink (cConectString,cServer)
nConexao := TCLink (cConectString,cServer,nxPort)
//Valida se a conexใo realmente foi estabelecida
If nConexao < 0 //Conex๕es com retorno < 0 significam erro
	Alert("Falha de conexใo com o TOPConnect: " + Str(nConexao))
	aErros := {.T.,"Falha de conexใo com o TOPConnect: " + Str(nConexao)+" impcompra.prw"}
	lMsErroAuto := .T.
Else
	Begin Transaction
	// Campos e seus conteudos a serem gravados na tabela SF1
	If cFormul = "S"
		cTipoNf	:= SuperGetMv("MV_TPNRNFS")
		cSerNew	:= PadR("1",3) //GetMv("MV_XSERIE")
		cDocNew	:= GetSx8Num ("NFF",,cSerNew + PadR(xFilial("SF2")+X2PATH("SF2"),47)) //NxtSX5Nota(cSerNew, NIL, cTipoNf)
		cEspNew	:= "SPED"
	Else
		cDocNew	:= cDoc
		cSerNew	:= cSerie
		cEspNew	:= cEspecie
	EndIf
	
	aCabec := {	{"F1_FILIAL" ,cFil       ,NIL},;
	{"F1_TIPO"   ,cTipo      ,NIL},;
	{"F1_FORMUL" ,cFormul    ,NIL},;
	{"F1_EMISSAO",dEmissao   ,NIL},;
	{"F1_FORNECE",cFornece	 ,NIL},;
	{"F1_LOJA"   ,cLoja      ,NIL},;
	{"F1_SERIE"  ,cSerNew    ,NIL},;
	{"F1_DOC"    ,cDocNew  	 ,NIL},;
	{"F1_ESPECIE",cEspNew    ,NIL},;
	{"F1_FRETE"	 ,nFrete     ,NIL},;
	{"F1_COND"   ,cCond      ,NIL} }
	
	// Campos e seus conteudos a serem gravados na tabela SD1
	aCamAux := {}
	aCampos := {}
	
	
	// Query para o detalhamento das notas fiscais de compra.
	cQuery	:= " SELECT D1.*, B1_XLENGEN, B1_DESC "
	cQuery	+= " FROM " + RetSqlName("SD1") + " AS D1 "
	cQuery	+= " INNER JOIN " + RetSqlName("SB1") + " AS B1 ON B1.D_E_L_E_T_ <> '*' AND B1_COD = D1_COD "
	cQuery	+= " WHERE D1.D_E_L_E_T_ <> '*' AND D1_TIPO = '" + cTipo + "' AND D1_SERIE = '" + cSerie + "' "
	cQuery	+= " 		AND D1_DOC = '" + cDoc + "' AND D1_FORNECE = '" + cFornece + "' AND D1_LOJA = '" + cLoja + "' "
	cQuery	+= "		AND D1_MSFIL = '" + cFil + "' "
	
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		dbCloseArea()
	EndIf
	
	//
	TcQuery cQuery New Alias &cAlias
	
	aStruct := DBStruct(cAlias)
	
	// ABRE A TABELA DE DICONARIO PARA PEGAR OS CAMPOS DAS TABELAS.
	For C := 1 To LEN(aStruct)
		DBSelectArea( "SX3" )
		SX3->( DBSetOrder( 2 ) )
		SX3->( DBGoTop() )
		SX3->( DBSeek( aStruct[C][1]) )
		IF  SX3->X3_ARQUIVO == "SD1"  .AND. Alltrim(SX3->X3_CAMPO) == Alltrim(aStruct[C][1]) .AND. SX3->X3_CONTEXTO <> 'V'
			aadd( aCamAux, { SX3->X3_CAMPO, SX3->X3_TIPO } )
		EndIf
	Next C
	
	//
	(cAlias)->(DBGoTop())
	While (cAlias)->(!EOF())
		
		aItem 	:= {}
		cCod	:= IIf ((cAlias)->D1_TP $ "BL#LP", (cAlias)->B1_XLENGEN, (cAlias)->D1_COD)
		
		// Varre todos os campos da tabela SD1
		For i := 1 To Len(aCamAux)
			
			Do Case
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_FILIAL"
					aAdd(aItem, {aCamAux[i][1], (cAlias)->D1_MSFIL, Nil} )
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_COD"
					aAdd(aItem, {aCamAux[i][1], cCod, Nil} )
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_SERIE" .and. cFormul = "S"
					aAdd(aItem, {aCamAux[i][1], cSerNew, Nil} )
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_DOC" .and. cFormul = "S"
					aAdd(aItem, {aCamAux[i][1], cDocNew, Nil} )
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_NFORI" .and. !Empty((cAlias)->&(aCamAux[i][1]))
					aAdd(aItem, {aCamAux[i][1], "XXXXXX", Nil} )
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_SERIORI" .and. !Empty((cAlias)->&(aCamAux[i][1]))
					aAdd(aItem, {aCamAux[i][1], "XX", Nil} )
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_ITEMORI" .and. !Empty((cAlias)->&(aCamAux[i][1]))
					aAdd(aItem, {aCamAux[i][1], "", Nil} )
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_PEDIDO" // Nao envia
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_ITEMPC" // Nao envia
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "D1_GRADE" // Nao envia
				Case VALType((cAlias)->&(aCamAux[i][1])) <> "U"
					If aCamAux[i][2] = "D"
						aAdd(aItem, {aCamAux[i][1], StoD( (cAlias)->&(aCamAux[i][1]) ), Nil} )
					Else
						If !Empty((cAlias)->&(aCamAux[i][1]))
							aAdd(aItem, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil} )
						EndIf
					EndIf
				OtherWise
					aAdd(aItem, {aCamAux[i][1], CriaVar(aCamAux[i][1]), Nil} )
			EndCase
			
		Next
		
		aAdd (aItens, aItem)
		
		(cAlias)->(dbSkip())
		IncProc ( (cAlias)->(D1_DOC + D1_SERIE) )
		
				End

		
		(cAlias)->(dbCloseArea())
		
		// Fecha conexใo com o Top Conect do producao
		TCUnLink(nConexao)
			
		// Verifica se o cadastro a verificar ้ de cliente ou de fornecedor
		If cTipo $ "D#B" // Se a nota fiscal for de devolucao ou de beneficiamento
			// Verifica se o cadastro do fornecedor jแ existe
			SA1->(dbSetOrder(1))
			If !SA1->(dbSeek(xFilial("SA1") + cFornece + cLoja))
				// Executa rotina de importa็ใo de cliente
				aErros := STARTJOB("U_ImpCli",getenvserver(),.T.,cConectString, cServer, cFornece, cLoja, 3,nxPort)
				If aErros[1]
					RollBackSXE()
					Return aErros
				EndIf
/*			Else
				// Executa rotina de importa็ใo de cliente
				lRet := STARTJOB("U_ImpCli",getenvserver(),.T.,cConectString, cServer, cFornece, cLoja, 4,nxPort)
				If !lRet
					RollBackSXE()
					Return lRet
				EndIf	*/
			EndIf
		Else
			// Verifica se o cadastro do fornecedor jแ existe
			SA2->(dbSetOrder(1))
			If !SA2->(dbSeek(xFilial("SA2") + cFornece + cLoja))
				// Executa rotina de importa็ใo de fornecedor
				aErros := STARTJOB("U_ImpForn",getenvserver(),.T.,cConectString, cServer, cFornece, cLoja, 3,nxPort)
				If aErros[1]
					RollBackSXE()
					Return aErros
				EndIf
/*			Else
				// Executa rotina de importa็ใo de fornecedor
				lRet := STARTJOB("U_ImpForn",getenvserver(),.T.,cConectString, cServer, cFornece, cLoja, 4,nxPort)
				If !lRet
					RollBackSXE()
					Return lRet
				EndIf	*/
			EndIf
		EndIf
		
		// Verifica se a condicao de pagamento jแ estแ cadastrada
		SE4->(dbSetOrder(1))
		If !SE4->(dbSeek(xFilial("SE4") + cCond))
			// Executa rotina de importa็ใo de fornecedor
			aErros := STARTJOB( "U_ImpCond",getenvserver(),.T.,cConectString, cServer, cCond, .T.,nxPort )
			If aErros[1]
				RollBackSXE()
				Return aErros
			EndIf
/*		Else
			// Executa rotina de importa็ใo de fornecedor
			lRet := STARTJOB("U_ImpCond",getenvserver(),.T.,cConectString, cServer, cCond, .F.,nxPort)
			If !lRet
				RollBackSXE()
				Return lRet
			EndIf	*/
		EndIf
		
		For i := 1 to Len(aItens)
		
			nP := aScan (aItens[i], {|x| AllTrim(x[1]) == "D1_GRUPO"})
			// Verifica se o cadastro do grupo jแ existe
			SBM->(dbSetOrder(1))
			If !SBM->(dbSeek(xFilial("SBM") + aItens[i][nP][2]))
				// Executa rotina de importa็ใo de grupo
				aErros := STARTJOB("U_ImpGrupo",getenvserver(),.T.,cConectString, cServer, aItens[i][nP][2], .T.,nxPort)
				If aErros[1]
					RollBackSXE()
					Return aErros
				EndIf				
/*			Else
				// Executa rotina de importa็ใo de grupo
				lRet := STARTJOB("U_ImpGrupo",getenvserver(),.T.,cConectString, cServer, aItens[i][nPos][2], .F.,nxPort)
				If !lRet
					RollBackSXE()
					Return lRet
				EndIf		*/
			EndIf
			
			nP := aScan (aItens[i], {|x| AllTrim(x[1]) == "D1_TES"})
			// Verifica se o cadastro do TES jแ existe
			SF4->(dbSetOrder(1))
			If !SF4->(dbSeek(xFilial("SF4") + aItens[i][nP][2]))
				// Executa rotina de importa็ใo de TES
				aErros := STARTJOB("U_ImpTES",getenvserver(),.T.,cConectString, cServer, aItens[i][nP][2], .T.,nxPort)
				If aErros[1]
					RollBackSXE()
					Return aErros
				EndIf
/*			Else
				// Executa rotina de importa็ใo de TES
				lRet := STARTJOB("U_ImpTES",getenvserver(),.T.,cConectString, cServer, aItens[i][nPos][2], .F.,nxPort)
				If !lRet
					RollBackSXE()
					Return lRet
				EndIf	*/
			EndIf
			
			nP := aScan (aItens[i], {|x| AllTrim(x[1]) == "D1_TP"})
			// Verifica se o cadastro do TES jแ existe
			SX5->(dbSetOrder(1))
			If !SX5->(dbSeek(xFilial("SX5") + "02" + aItens[i][nP][2]))
				RecLock("SX5",.T.)
				SX5->X5_FILIAL	:= xFilial("SX5")
				SX5->X5_TABELA	:= "02"
				SX5->X5_CHAVE	:= aItens[i][nP][2]
				SX5->X5_DESCRI	:= "Tipo " + aItens[i][nP][2]
				SX5->X5_DESCSPA	:= "Tipo " + aItens[i][nP][2]
				SX5->X5_DESCENG	:= "Tipo " + aItens[i][nP][2]
				MsUnLock("SX5")
			EndIf
			
			nP := aScan (aItens[i], {|x| AllTrim(x[1]) == "D1_COD"})
			// Verifica se o cadastro do produto jแ existe
			SB1->(dbSetOrder(1))
			If !SB1->(dbSeek(xFilial("SB1") + aItens[i][nP][2]))
				// Executa rotina de importa็ใo de produto
				aErros := STARTJOB( "U_ImpProd",getenvserver(),.T.,cConectString, cServer, aItens[i][nP][2], 3, cEmp, cFil , nxPort,cFornece, cLoja)
				If aErros[1]
					RollBackSXE()
					aErros[2] := aItens[i][nP][2]+": "+aErros[2]
					Return aErros
				EndIf
			Else
				// Executa rotina de importa็ใo de produto
				aErros := STARTJOB( "U_ImpProd",getenvserver(),.T.,cConectString, cServer, aItens[i][nP][2], 4, cEmp, cFil, nxPort,cFornece, cLoja )
				If aErros[1]
					RollBackSXE()
					aErros[2] := aItens[i][nP][2]+": "+aErros[2]
					Return aErros
				EndIf
			EndIf
			
		Next
		
		// Aguarde...Gerando nota fiscal de entrada.
		MSExecAuto( {|x,y,z,w| MATA103( x, y, z, w ) }, aCabec, aItens, 3, .F. )
			
		// Verifica se deu algum erro na inclusใo da nota fiscal de entrada
		If lMsErroAuto
		//	MostraErro()
			RollBackSXE()
			DisarmTransaction()
			conout( "ERRO: Falha no ExecAuto MATA103" )
			aErros := {.T.,"ERRO: Falha no ExecAuto MATA103" +chr(13)+chr(10)+MostraErro()}
		    return aErros
		Else
			// Abre uma conexใo com o Top Conect da base producao
		   //	nConexao:= TCLink (cConectString,cServer)
		   nConexao := TCLink (cConectString,cServer,nxPort)
			
			// Grava confirma็ใo na base producao da importa็ใo da nota fiscal de entrada
			cQuery	:= " UPDATE " + RetSqlName("SF1") + " SET F1_MSEXP = '" + DtoS(dDataBase) + "' "
			cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND F1_TIPO = '" + cTipo + "' AND F1_SERIE = '" + cSerie + "' "
			cQuery	+= " 		AND F1_DOC = '" + cDoc + "' AND F1_FORNECE = '" + cFornece + "' AND F1_LOJA = '" + cLoja + "' "
			cQuery	+= "		AND F1_MSFIL = '" + cFil + "' "
			
			// Executa a query para atualizar na base produ็ใo.
	
			If TCSQLEXEC(cQuery) < 0
				lMsErroAuto := .T.
			//	TCSQLERROR()
				DisarmTransaction()
				conout( "ERRO: Falha na gravacao da confirmacao da importacao!" )
				aErros := {.T.,"ERRO: Falha na gravacao da confirmacao da importacao!" +chr(13)+chr(10)+	TCSQLERROR()}
				return aErros
			EndIf

			// Fecha conexใo com o Top Conect do producao
			TCUnLink(nConexao)
			
			ConfirmSX8()
		EndIf
			
	End Transaction
	
EndIf

//Limpa o ambiente, liberando a licen็a e fechando as conex๕es
//RpcClearEnv()
RESET ENVIRONMENT
Return aErros