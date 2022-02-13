#INCLUDE "Rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TbiConn.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

/*/                                                                                                                                                                                                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ImpVenda ³ Autor ³ Herbert Ayres         ³ Data ³ 13.03.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para realizar a importacao da nota fiscal de ven- ³±±
±±³          ³ da da base producao para a base TEF.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Totvs Protheus 10                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³  Data  ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Leonardo   ³21.06.12|Correc³ Capturar o valor de Despesas acessorias  ³±±
±±³            ³        ³      ³ nDespesa(Lines: 28, 94)                  ³±±
±±³ Leonardo   ³05.02.13|Correc³ Correcao da variavel que armazena o indi ³±±
±±³            ³        ³      ³ do AScan de nPos para nP                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ImpVenda (cConectString, cServer, cEmp, cFil, cSerie, cDoc, cCliente, cLoja,nxPort,cxTipo)

Local aCabec		:= {}	// Variável de cabecalho das nota fiscais de entrada
Local aItens		:= {}	// Variável de itens das nota fiscais de entrada
Local aGrupos		:= {}	// Variável para controle dos grupos de produto
Local aTipos		:= {}	// Variável para controle dos tipos de produto
Local cAlias		:= GetNextAlias()	// Variável que contem o proximo alias
Local nConexao
Local lMV_XDESCLE
Local lRet
Local aErros 		:= {.F., "Importacao efetuda com sucesso"}
Local I
Local nP
Local nDespesa 	:= 0   // Armazena o valor da despesa acessorias, e caso nao seja informada por existir em outras funcoes, inicia com valor 0
Local nPTipo
Local nxfilial
Local nPCond
Local lAuto := .F.
Local cxRotina := "ImpVenda"
Local nPicment
Local cOrigem
Local cTES
// Testes

/*cConectString	:= "MSSQL7/PRODUCAO_11"
cServer			:= "127.0.0.1"
cEMp			:= "01"
cFil			:= "01"
cTipo			:= "N"
cSerie			:= "01"
cDoc			:= "000007"
cCliente		:= "000001"
cLoja			:= "03"
cTpCli			:= "F"
cCond			:= "001"
cMenNota        := ""
*/
Private lMsErroAuto	:= .F.

lMV_XDESCLE := U_SuperGetMV("MV_XDESCLE", .T.,"F","L","Parâmetro que define se, na NF importada, a descrição será da lente específica ou genérica.")

dbSelectArea("SC5")
SC5->(dbSetOrder(1))
cNum :=GetSXENum("SC5","C5_NUM", xFilial("SC5")+"SC5NUM")

//Especifica o protocolo de comunicação a ser utilizado pelo TOPConnect.
TCConType("TCPIP")
// Abre uma conexão com o Top Conect da base producao
//nConexao := TCLink (cConectString,cServer)
nConexao := TCLink(cConectString,cServer,nxPort)
//Valida se a conexão realmente foi estabelecida
If nConexao < 0 //Conexões com retorno < 0 significam erro
	RollBackSx8()
	Alert("Falha de conexão com o TOPConnect: " + Str(nConexao))
	lMsErroAuto := .T.
	aErros := {.T.,"Falha de conexão com o TOPConnect: " + Str(nConexao) + " impvenda.prw"}
	return aErros
Else
	Begin Transaction
	 
	IF cxTipo == "N"
		cQuery	:= " SELECT DISTINCT F2.*, ISNULL(C5_MENNOTA,'') AS C5_MENNOTA, C5_DESPESA,C5_TPFRETE,A1_NOME AS FORNECLI,C5_VEND1,C5_VEND2,C5_VEND3,C5_VEND4,C5_VEND5,C5_BANCO," 
		cQuery	+= " C5_VOLUME1,C5_VOLUME2,C5_VOLUME3,C5_VOLUME4,C5_ESPECI1,C5_ESPECI2,C5_ESPECI3,C5_ESPECI4,C5_PESOL,C5_PBRUTO "
		cQuery	+= " FROM " + RetSqlName("SF2") + " AS F2 "
		cQuery	+= " INNER JOIN " + RetSqlName("SD2") + " AS D2 ON D2.D_E_L_E_T_ <> '*' AND D2_FILIAL = F2_FILIAL AND D2_SERIE = F2_SERIE AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
		cQuery	+= " INNER JOIN " + RetSqlName("SF4") + " AS F4 ON F4.D_E_L_E_T_ <> '*' AND F4_CODIGO = D2_TES "
		cQuery	+= " INNER JOIN " + RetSqlName("SA1") + " AS A1 ON A1.D_E_L_E_T_ <> '*' AND A1_COD = F2_CLIENTE  AND A1_LOJA = F2_LOJA "
		cQuery	+= " LEFT OUTER JOIN " + RetSqlName("SC5") + " AS C5 ON C5.D_E_L_E_T_ <> '*' AND C5_FILIAL = '" + mv_par02 + "' AND C5_NUM = D2_PEDIDO "
		cQuery	+= " WHERE F2.D_E_L_E_T_ <> '*' AND F2_MSEXP = '' AND D2_ORIGLAN <> 'LO' AND F2_MSFIL = '" + mv_par02 + "' "
		cQuery	+= " AND F2_SERIE = '" + PADR(mv_par03, TamSX3("F2_SERIE")[1]) + "' AND F2_DOC = '" + PADR(mv_par04, TamSX3("F2_DOC")[1]) + "' AND F2_CLIENTE = '" + PADR(mv_par05, TamSX3("F2_CLIENTE")[1]) + "' AND F2_LOJA = '" + PADR(mv_par06, TamSX3("F2_LOJA")[1]) + "' "
		cQuery	+= " ORDER BY F2_MSFIL, F2_EMISSAO, F2_SERIE, F2_DOC "
	ELSE
		cQuery	:= " SELECT DISTINCT F2.*, ISNULL(C5_MENNOTA,'') AS C5_MENNOTA, C5_DESPESA,C5_TPFRETE,A2_NOME AS FORNECLI,C5_VEND1,C5_VEND2,C5_VEND3,C5_VEND4,C5_VEND5,C5_BANCO,"
	   	cQuery	+= " C5_VOLUME1,C5_VOLUME2,C5_VOLUME3,C5_VOLUME4,C5_ESPECI1,C5_ESPECI2,C5_ESPECI3,C5_ESPECI4,C5_PESOL,C5_PBRUTO "
	   	cQuery	+= " FROM " + RetSqlName("SF2") + " AS F2 "
		cQuery	+= " INNER JOIN " + RetSqlName("SD2") + " AS D2 ON D2.D_E_L_E_T_ <> '*' AND D2_FILIAL = F2_FILIAL AND D2_SERIE = F2_SERIE AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
		cQuery	+= " INNER JOIN " + RetSqlName("SF4") + " AS F4 ON F4.D_E_L_E_T_ <> '*' AND F4_CODIGO = D2_TES "
		cQuery	+= " INNER JOIN " + RetSqlName("SA2") + " AS A2 ON A2.D_E_L_E_T_ <> '*' AND A2_COD = F2_CLIENTE  AND A2_LOJA = F2_LOJA "
		cQuery	+= " LEFT OUTER JOIN " + RetSqlName("SC5") + " AS C5 ON C5.D_E_L_E_T_ <> '*' AND C5_FILIAL = '" + mv_par02 + "' AND C5_NUM = D2_PEDIDO "
		cQuery	+= " WHERE F2.D_E_L_E_T_ <> '*' AND F2_MSEXP = '' AND D2_ORIGLAN <> 'LO' AND F2_MSFIL = '" + mv_par02 + "' "
		cQuery	+= " AND F2_SERIE = '" + PADR(mv_par03, TamSX3("F2_SERIE")[1]) + "' AND F2_DOC = '" + PADR(mv_par04, TamSX3("F2_DOC")[1]) + "' AND F2_CLIENTE = '" + PADR(mv_par05, TamSX3("F2_CLIENTE")[1]) + "' AND F2_LOJA = '" + PADR(mv_par06, TamSX3("F2_LOJA")[1]) + "' "
		cQuery	+= " ORDER BY F2_MSFIL, F2_EMISSAO, F2_SERIE, F2_DOC "		
	ENDIF
	
	
	If Select("QRYCAB") > 0
		dbSelectArea("QRYCAB")
		QRYCAB->(dbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "QRYCAB"
	
	dbSelectArea("QRYCAB")
	QRYCAB->(DBGoTop())
	// Campos e seus conteudos a serem gravados na tabela SC5
	
	aAdd( aCabec, {"C5_FILIAL"	, QRYCAB->F2_MSFIL     ,Nil } )
	aAdd( aCabec, {"C5_NUM"		, cNum		     	   ,Nil } )
	aAdd( aCabec, {"C5_TIPO"	, QRYCAB->F2_TIPO	   ,Nil } )
	aAdd( aCabec, {"C5_CLIENTE"	, QRYCAB->F2_CLIENTE   ,Nil } )
	aAdd( aCabec, {"C5_LOJACLI"	, QRYCAB->F2_LOJA      ,Nil } )
	aAdd( aCabec, {"C5_CLIENT"	, QRYCAB->F2_CLIENTE   ,Nil } )
	aAdd( aCabec, {"C5_LOJAENT"	, QRYCAB->F2_LOJA      ,Nil } )
	aAdd( aCabec, {"C5_TIPOCLI"	, QRYCAB->F2_TIPOCLI   ,Nil } )
	aAdd( aCabec, {"C5_CONDPAG"	, QRYCAB->F2_COND	   ,Nil } )
	aAdd( aCabec, {"C5_EMISSAO" , dDataBase	           ,Nil } )
	aAdd( aCabec, {"C5_MOEDA"	, 1				       ,Nil } )
	aAdd( aCabec, {"C5_TIPLIB" 	, "1" 			       ,Nil } )
	aAdd( aCabec, {"C5_TXMOEDA" , 1				       ,Nil } )
	aAdd( aCabec, {"C5_XDOCPRO" , QRYCAB->F2_DOC	   ,Nil } )
	aAdd( aCabec, {"C5_XSERPRO" , QRYCAB->F2_SERIE     ,Nil } )
	aAdd( aCabec, {"C5_XRAZSOC" , QRYCAB->FORNECLI     ,Nil } )
	aAdd( aCabec, {"C5_MENNOTA" , QRYCAB->C5_MENNOTA   ,Nil } )
	aAdd( aCabec, {"C5_DESPESA" , QRYCAB->C5_DESPESA   ,Nil } )
	aAdd( aCabec, {"C5_TPFRETE" , QRYCAB->C5_TPFRETE   ,Nil } ) 
	
	aAdd( aCabec, {"C5_VEND1"   , QRYCAB->C5_VEND1	   ,Nil } )
	aAdd( aCabec, {"C5_VEND2"   , QRYCAB->C5_VEND2     ,Nil } )
	aAdd( aCabec, {"C5_VEND3"   , QRYCAB->C5_VEND3     ,Nil } )
	aAdd( aCabec, {"C5_VEND4"   , QRYCAB->C5_VEND4     ,Nil } )
	aAdd( aCabec, {"C5_VEND5"   , QRYCAB->C5_VEND5     ,Nil } )
	aAdd( aCabec, {"C5_BANCO"   , QRYCAB->C5_BANCO     ,Nil } ) 
	aAdd( aCabec, {"C5_VOLUME1" , QRYCAB->C5_VOLUME1   ,Nil } )
	aAdd( aCabec, {"C5_VOLUME2" , QRYCAB->C5_VOLUME2   ,Nil } )   
	aAdd( aCabec, {"C5_VOLUME3" , QRYCAB->C5_VOLUME3   ,Nil } )
	aAdd( aCabec, {"C5_VOLUME4" , QRYCAB->C5_VOLUME4   ,Nil } )
	aAdd( aCabec, {"C5_ESPECI1" , QRYCAB->C5_ESPECI1   ,Nil } )
	aAdd( aCabec, {"C5_ESPECI2" , QRYCAB->C5_ESPECI2   ,Nil } )
	aAdd( aCabec, {"C5_ESPECI3" , QRYCAB->C5_ESPECI3   ,Nil } )
	aAdd( aCabec, {"C5_ESPECI4" , QRYCAB->C5_ESPECI4   ,Nil } )
	//aAdd( aCabec, {"C5_NATUREZ" , QRYCAB->C5_NATUREZ  ,Nil } )
	aAdd( aCabec, {"C5_PESOL"   , QRYCAB->C5_PESOL     ,Nil } )
	aAdd( aCabec, {"C5_PBRUTO"  , QRYCAB->C5_PBRUTO    ,Nil } )	
	
	nPTipo := aScan (aCabec, {|x| AllTrim(x[1]) == "C5_TIPO"})
	nPCond := aScan (aCabec, {|x| AllTrim(x[1]) == "C5_CONDPAG" })
	       
	// Query para o detalhamento das notas fiscais de venda.
	cQuery := " SELECT SUB.*, B1_COD, B1_DESC, "
	cQuery += " CASE WHEN (B1_COD IS NULL) THEN 'NULO' WHEN (B1_COD  IS NOT NULL) THEN B1_COD  END AS CODTESTE  "
	cQuery += " FROM ( "
	cQuery += " 	SELECT DISTINCT D2_ITEM, D2_TP, D2_COD, D2_UM, D2_QUANT, "
	cQuery += " 		D2_PRCVEN, D2_TOTAL, D2_PRUNIT, D2_TES, D2_LOCAL, D2_CF, D2_NFORI, "
	cQuery += " 		D2_SERIORI, D2_ITEMORI, D2_DOC, D2_SERIE, D2_GRUPO,D2_DESC,D2_DESCON, "
	cQuery += " 		CASE D2_TP "
	cQuery += " 			WHEN 'LC' THEN D2_COD "
	cQuery += " 			ELSE SUBSTRING(D2_COD, 1, 7) "
	cQuery += " 		END AS NEWCOD "
	cQuery += " 	FROM " + RetSqlName("SD2") + " AS D2 "
	cQuery += " 	WHERE D2.D_E_L_E_T_ = '' "
	cQuery += " 		AND D2_TIPO = '" + aCabec[nPTipo][2] + "' "
	cQuery += " 		AND D2_SERIE = '" + cSerie + "' "
	cQuery += " 		AND D2_DOC = '" + cDoc + "' "
	cQuery += " 		AND D2_CLIENTE = '" + cCliente + "' "
	cQuery += " 		AND D2_LOJA = '" + cLoja + "' "
	cQuery += " 		AND D2_MSFIL = '" + cFil + "' "
	cQuery += " 	) AS SUB "
	cQuery += "     LEFT  JOIN " + RetSqlName("SB1") + " AS B1 "
	cQuery += " 	ON B1.D_E_L_E_T_ = '' "
	cQuery += " 	AND B1_COD = SUB.NEWCOD "
	cQuery += " 	AND B1_TIPO NOT IN ('LP','BL', 'LC') "
	If Select("QRYITE") > 0
		dbSelectArea("QRYITE")
		QRYITE->(dbCloseArea())
	EndIf
	TcQuery cQuery New Alias "QRYITE"
	
	While QRYITE->(!EOF())
		aItem 	:= {}
		IF alltrim( QRYITE->CODTESTE) != 'NULO'
			cCod	:= IIf (QRYITE->D2_TP $ "BL#LP", QRYITE->B1_COD, QRYITE->D2_COD)
			aAdd( aItem, {"C6_FILIAL"	, cFil					, Nil } )
			aAdd( aItem, {"C6_ITEM"		, QRYITE->D2_ITEM		, Nil } )
			aAdd( aItem, {"C6_PRODUTO"	, cCod					, Nil } )
			If lMV_XDESCLE
				aAdd( aItem, {"C6_DESCRI"	, Posicione("SB1",1,xFilial("SB1") + QRYITE->D2_COD,"B1_DESC"), Nil } )
			Else
				aAdd( aItem, {"C6_DESCRI"	, QRYITE->B1_DESC		, Nil } )
			endIf
			
			If aCabec[nPTipo][2] <>"D"
				
				aAdd( aItem, {"C6_UM"		, QRYITE->D2_UM		, Nil } )
				aAdd( aItem, {"C6_QTDVEN"	, QRYITE->D2_QUANT	, Nil } )
				aAdd( aItem, {"C6_PRCVEN"	, QRYITE->D2_PRCVEN	, Nil } )
				aAdd( aItem, {"C6_PRUNIT"	, QRYITE->D2_PRUNIT	, Nil } )
				aAdd( aItem, {"C6_VALOR"	, QRYITE->D2_TOTAL	, Nil } )
				aAdd( aItem, {"C6_TES"		, QRYITE->D2_TES	, Nil } )
				aAdd( aItem, {"C6_QTDLIB"	, QRYITE->D2_QUANT	, Nil } )
				aAdd( aItem, {"C6_LOCAL" 	, QRYITE->D2_LOCAL	, Nil } )
				aAdd( aItem, {"C6_CF"		, QRYITE->D2_CF		, Nil } )
				aAdd( aItem, {"C6_DESCONT"  , QRYITE->D2_DESC   , Nil } )
				aAdd( aItem, {"C6_VALDESC"  , QRYITE->D2_DESCON , Nil } )
				aAdd( aItem, {"C6_ENTREG"	, dDataBase			, Nil } )
				aAdd( aItem, {"C6_CLI"		, cCliente			, Nil } )
				aAdd( aItem, {"C6_LOJA"    	, cLoja				, Nil } ) 
			   //	aAdd( aItem, {"C6_OPER"    	, cLoja				, Nil } )
				
			Else
				
				aAdd( aItem, {"C6_UM"		, QRYITE->D2_UM		, Nil } )
				aAdd( aItem, {"C6_QTDVEN"	, QRYITE->D2_QUANT	, Nil } )
		    	//aAdd( aItem, {"C6_PRCVEN"	, QRYITE->D2_PRCVEN	, Nil } )
				aAdd( aItem, {"C6_PRUNIT"	, QRYITE->D2_PRCVEN	, Nil } )
				aAdd( aItem, {"C6_VALOR"	, QRYITE->D2_TOTAL	, Nil } )
				aAdd( aItem, {"C6_TES"		, QRYITE->D2_TES	, Nil } )
				aAdd( aItem, {"C6_QTDLIB"	, QRYITE->D2_QUANT	, Nil } )
				aAdd( aItem, {"C6_LOCAL" 	, QRYITE->D2_LOCAL	, Nil } )
				aAdd( aItem, {"C6_CF"		, QRYITE->D2_CF		, Nil } )
				aAdd( aItem, {"C6_DESCONT"  , QRYITE->D2_DESC   , Nil } )
				aAdd( aItem, {"C6_VALDESC"  , QRYITE->D2_DESCON , Nil } )
				aAdd( aItem, {"C6_ENTREG"	, dDataBase			, Nil } )
				aAdd( aItem, {"C6_CLI"		, cCliente			, Nil } )
				aAdd( aItem, {"C6_LOJA"    	, cLoja				, Nil } )
				aAdd( aItem, {"C6_NFORI"    , QRYITE->D2_NFORI	, Nil } )
				aAdd( aItem, {"C6_SERIORI"  , QRYITE->D2_SERIORI, Nil } )
				aAdd( aItem, {"C6_ITEMORI"  , QRYITE->D2_ITEMORI, Nil } )
			   //	aAdd( aItem, {"C6_OPER"    	, cLoja				, Nil } )
				
			EndIf
			
			aAdd (aItens , aItem)
			aAdd (aGrupos, QRYITE->D2_GRUPO)
			aAdd (aTipos , QRYITE->D2_TP)
		ELSE
	   		aErros 	:= {.T., "Produto: "+ SUBSTR(QRYITE->D2_COD,1,7) + " não cadastrado - Importacao interrompida!!"}
	   		TCUnLink(nConexao)
	   		RollBackSx8()
			DisarmTransaction()			
			Return aErros
		ENDIF
		QRYITE->(dbSkip())
		IncProc ( QRYITE->(D2_DOC + D2_SERIE) )
	End
	QRYITE->(dbCloseArea())
	QRYCAB->(dbCloseArea())
	
	
	// Fecha conexão com o Top Conect do producao
	TCUnLink(nConexao)
	
	// Verifica se o cadastro a verificar é de cliente ou de fornecedor
	If aCabec[nPTipo][2] $ "D#B" // Se a nota fiscal for de devolucao ou de beneficiamento
		
		// Verifica se o cadastro do fornecedor já existe
		DBSELECTAREA("SA2")
		SA2->(dbSetOrder(1))
		If !SA2->(dbSeek(xFilial("SA2") + cCliente + cLoja))
			// Executa rotina de importação de fornecedor
			aErros := U_ImpForn(cConectString, cServer, cCliente, cLoja, 3,cEmp, cFil,nxPort)
		ELSE
			aErros := U_ImpForn(cConectString, cServer, cCliente, cLoja, 4,cEmp, cFil,nxPort)
		ENDIF
		
		If aErros[1]
			RollBackSx8()
			DisarmTransaction()
		   //	RollBackSXE()
			Return aErros
		EndIf
		
	Else
		// Verifica se o cadastro do cliente já existe
		DBSELECTAREA("SA1")
		SA1->(dbSetOrder(1))
		If !SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))
			// Executa rotina de importação de cliente
			//aErros := STARTJOB("U_ImpCli",getenvserver(),.T.,cConectString, cServer, cCliente, cLoja, 3,cEmp, cFil)
			aErros := U_ImpCli(cConectString, cServer, cCliente, cLoja, 3,cEmp, cFil,nxPort)
		ELSE
			aErros := U_ImpCli(cConectString, cServer, cCliente, cLoja, 4,cEmp, cFil,nxPort)
		ENDIF
		
		If aErros[1]
			RollBackSx8()
			DisarmTransaction()
			Return aErros
		EndIf
		
	EndIf
	
	// Verifica se o cadastro do Vendedor já existe

	FOR xVEND := 1 TO 5 
	
	    DO CASE
	    	CASE xVEND == 1
	    		nPVended := aScan (aCabec, {|x| AllTrim(x[1]) == "C5_VEND1" })
	    	CASE xVEND == 2
	       		nPVended := aScan (aCabec, {|x| AllTrim(x[1]) == "C5_VEND2" })
	    	CASE xVEND == 3
	    		nPVended := aScan (aCabec, {|x| AllTrim(x[1]) == "C5_VEND3" })
	    	CASE xVEND == 4
	    		nPVended := aScan (aCabec, {|x| AllTrim(x[1]) == "C5_VEND4" })	
	    	CASE xVEND == 5
	    		nPVended := aScan (aCabec, {|x| AllTrim(x[1]) == "C5_VEND5" })	    		
	    ENDCASE   	
	    
	    IF !(EMPTY(ALLTRIM(aCabec[nPVended][2])))
	   		DBSELECTAREA("SA3")
			SA3->(dbSetOrder(1))
			If !SA3->(dbSeek(xFilial("SA3") + aCabec[nPVended][2] ))
				aErros := U_ImpVenden(cConectString, cServer,nxPort,aCabec[nPVended][2],3,cEmp, cFil)		
			ELSE
				aErros := U_ImpVenden(cConectString, cServer,nxPort,aCabec[nPVended][2],4,cEmp, cFil)
			ENDIF
			
			If aErros[1]
			   	RollBackSx8()
				DisarmTransaction()
				Return aErros
			EndIf
		ENDIF
		
	NEXT xVEND 
	
	// Verifica se a condicao de pagamento já está cadastrada
	DBSELECTAREA("SE4")
	SE4->(dbSetOrder(1))
	If !SE4->(dbSeek(xFilial("SE4") + aCabec[nPCond][2]))
		// Executa rotina de importação de fornecedor
		//	aErros := STARTJOB("U_ImpCond",getenvserver(),.T.,cConectString, cServer, cCond, .T.,cEmp, cFil)
		aErros := U_ImpCond(cConectString, cServer, aCabec[nPCond][2], .T.,cEmp, cFil,nxPort)
		If aErros[1]
			RollBackSx8()
			DisarmTransaction()
			Return aErros
		EndIf
	EndIf
	
	For i := 1 to Len(aGrupos)
		// Verifica se o cadastro do grupo já existe
		SBM->(dbSetOrder(1))
		If !SBM->(dbSeek(xFilial("SBM") + aGrupos[i]))
			// Executa rotina de importação de grupo
			//aErros := STARTJOB("U_ImpGrupo",getenvserver(),.T.,cConectString, cServer, aGrupos[i], .T.,cEmp, cFil)
			aErros := U_ImpGrupo(cConectString, cServer, aGrupos[i], .T.,cEmp, cFil,nxPort)
			If aErros[1]
		   		RollBackSx8()
				DisarmTransaction()
				Return aErros
			EndIf
		EndIf
	Next i
	
	For i := 1 to Len(aTipos)
		// Verifica se o tipo já existe
		SX5->(dbSetOrder(1))
		If !SX5->(dbSeek(xFilial("SX5") + "02" + aTipos[i]))
			RecLock("SX5",.T.)
			SX5->X5_FILIAL	:= xFilial("SX5")
			SX5->X5_TABELA	:= "02"
			SX5->X5_CHAVE	:= aTipos[i]
			SX5->X5_DESCRI	:= "Tipo " + aTipos[i]
			SX5->X5_DESCSPA	:= "Tipo " + aTipos[i]
			SX5->X5_DESCENG	:= "Tipo " + aTipos[i]
			MsUnLock("SX5")
		EndIf
	Next i
	
	For i := 1 to Len(aItens)
		nP := aScan (aItens[i], {|x| AllTrim(x[1]) == "C6_TES"})
		nProdu := aScan ( aItens[i], {|x| AllTrim( x[1]) == "D1_COD" } )
		
		// Verifica se o cadastro do TES já existe 
		DBSELECTAREA("SF4")
		SF4->(dbSetOrder(1))
		If !SF4->(dbSeek(xFilial("SF4") + aItens[i][nP][2]))
			// Executa rotina de importação de TES
			//	aErros := STARTJOB("U_ImpTES",getenvserver(),.T.,cConectString, cServer, aItens[i][nP][2], .T.,cEmp, cFil)
			aErros := U_ImpTES(cConectString, cServer, aItens[i][nP][2], .T.,cEmp, cFil,nxPort)
		ELSE
			aErros := U_ImpTES(cConectString, cServer, aItens[i][nP][2], .F.,cEmp, cFil,nxPort)
		ENDIF
		
		If aErros[1]
			RollBackSx8()
			DisarmTransaction()
			aRet[2] := "Verificar o TES de codigo: " + aItens[i][nP][2]+" no produto "+AllTrim(aItens[i][nProdu][2])+". "+aRet[2]
			Return aErros
		EndIf
		
		nP := aScan (aItens[i], {|x| AllTrim(x[1]) == "C6_PRODUTO"})
		
		// Verifica se o cadastro do produto já existe 
		DBSELECTAREA("SB1")
		SB1->(dbSetOrder(1))
		If !SB1->(dbSeek(xFilial("SB1") + aItens[i][nP][2]))
			// Executa rotina de importação de produto
			//	aErros := STARTJOB("U_ImpProd",getenvserver(),.T.,cConectString, cServer, aItens[i][nP][2], 3, cEmp, cFil)
		  	aErros := U_ImpProd( cConectString, cServer, aItens[i][nP][2], 3  , cEmp, cFil, cxRotina, nPicment, cOrigem, cTES, nxPort, cCliente, cLoja,aCabec[nPTipo][2] )
		ELSE
			aErros := U_ImpProd( cConectString, cServer, aItens[i][nP][2], 4  , cEmp, cFil, cxRotina, nPicment, cOrigem, cTES, nxPort, cCliente, cLoja,aCabec[nPTipo][2] )
		ENDIF
		
		If aErros[1]
	   		RollBackSx8()
			DisarmTransaction()
			aErros[2] := aItens[i][nP][2]+": "+aErros[2]
			Return aErros
		EndIf
		cCod := aItens[i][nP][2]
		
		nP := aScan (aItens[i], {|x| AllTrim(x[1]) == "C6_LOCAL"})
		
		// Verifica se existe registro do produto na SB2 para o armazem informado
		DBSELECTAREA("SB2")
		SB2->(dbSetOrder(1))
		If !SB2->(dbSeek(xFilial("SB2") + cCod + aItens[i][nP][2]))
			RecLock("SB2",.T.)
			SB2->B2_FILIAL	:= xFilial("SB2")
			SB2->B2_COD		:= cCod
			SB2->B2_LOCAL	:= aItens[i][nP][2]
			MsUnLock("SB2")
		EndIf
		
	Next i
	
	DBSELECTAREA("SC5")
	nxfilial := aScan (aCabec, {|x| AllTrim(x[1]) == "C5_FILIAL"})
	IF !(aCabec[nxfilial][2] == XFILIAL("SC5"))
		cFilAtu := cFilAnt //Grava a Filial corrente
		cFilant := aCabec[nxfilial][2]
		lAuto := .T.
		
		dbselectarea("SM0")
		SM0->(dbsetorder(1))
		SM0->(dbseek(SM0->M0_CODIGO + cFilant))
	Endif
	
	aCabec := FWVetByDic( aCabec, "SC5" )
	aItens := FWVetByDic( aItens, "SC6",.T., 1)
	
	lMsErroAuto	:= .F.
	// Aguarde...Gerando pedido de venda.
	MSExecAuto( {|x,y,z| Mata410(x,y,z)}, aCabec, aItens, 3)
	
	// Verifica se deu algum erro na inclusão da nota fiscal de entrada
	If lMsErroAuto
		RollbackSx8()
		DisarmTransaction()
		conout("Erro na execucao do ExecAuto MATA410!")
		aErros := {.T.,"Erro na execucao do ExecAuto MATA410! impvenda.prw "+chr(13)+chr(10)+ MostraErro()}
		return aErros
	Else
		IF lAuto
			cFilAnt := cFilAtu
			SM0->(dbsetorder(1))
			SM0->(dbseek(SM0->M0_CODIGO + cFilant))
		ENDIF
		
		ConfirmSX8()
		// Abre uma conexão com o Top Conect da base producao
		nConexao:= TCLink(cConectString,cServer,nxPort)
		
		// Grava confirmação na base producao da importação da nota fiscal de entrada
		cQuery	:= " UPDATE " + RetSqlName("SF2") + " SET F2_MSEXP = '" + DtoS(dDataBase) + "' "
		cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND F2_TIPO = '" + aCabec[nPTipo][2] + "' AND F2_SERIE = '" + cSerie + "' "
		cQuery	+= " 	AND F2_DOC = '" + cDoc + "' AND F2_CLIENTE = '" + cCliente + "' AND F2_LOJA = '" + cLoja + "' "
		cQuery	+= " 	AND F2_MSFIL = '" + cFil + "' "
		
		// Executa a query para atualizar na base produção.
		If TCSQLEXEC(cQuery) < 0
			lMsErroAuto := .T.
			TCSQLERROR()
			DisarmTransaction()
			conout("Erro na gravacao de confirmacao na base producao de importacao da NF de saida!")
			aErros := {.T., "Erro na gravacao de confirmacao na base producao- impmvenda.prw "+chr(13)+chr(10)+TCSQLERROR()}
			return aErros
		EndIf
		
		// Fecha conexão com o Top Conect do producao
		TCUnLink(nConexao)
	EndIf
	End Transaction
EndIf

Return aErros
