#INCLUDE "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiCONN.CH"
#INCLUDE "Protheus.ch"
#include "fileio.ch"

/*/
este
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpProd  บ Autor ณ Herbert Ayres      ณ Data ณ  13/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para realizar a importacao do produto da base pro-บฑฑ
ฑฑบ          ณ ducao para a base TEF.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs Protheus 10                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ImpProd ( cConectString, cServer, cCodigo, nOp, cEmp, cFil, cxRotina, nPicment, cOrigem,cTES ,nxPort,cFornece, cLoja,cxTipo)
Local aProds		:= {}																	// Variแvel de produtos
Local cAlias		:= GetNextAlias()													// Variแvel que contem o proximo alias
Local nConexao
Local cIncons 		:= ""
Local aTRB0        := {}
Local aProds2       := {}
Local aStruct     	:= {}
Local C 
Local I
Local nX
Local nP 

Private lMsErroAuto	:= .F. 	// Variแvel de controle do MsExecAuto e retorno da fun็ใo. Indica se a importa็ใo teve sucesso ou nใo.
Private aErros 		:= {.F., "Cadastro de produto OK - impprod.prw"}
/*
cConectString	:= "MSSQL7/PRODUCAO11_MARIO"
cServer			:= "192.168.2.110"
cCodigo         := "0000046"
nOp             := 4
cEmp            := "01"
cFil			:= "05"
nPicment          := 114.62
cOrigem := "060"
*/

//PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES  "SX2", "SX3", "SA1", "SA2", "SE4", "SBM", "SF4", "SB1", "SX5" MODULO "FAT"

//Seta job para nao consumir licensas
//RpcSetType(3)
// Seta job para empresa filial desejada
//RpcSetEnv( cEmp, cFil,,,'FAT' )
//Especifica o protocolo de comunica็ใo a ser utilizado pelo TOPConnect.
TCConType("TCPIP")
// Abre uma conexใo com o Top Conect da base producao
//nConexao := TCLink ( cConectString, cServer )
nConexao := TCLink (cConectString,cServer,nxPort)
//Valida se a conexใo realmente foi estabelecida
If nConexao < 0 																				//Conex๕es com retorno < 0 significam erro
	Alert( "Falha de conexใo com o TOPConnect: " + Str(nConexao) )
	lMsErroAuto := .T.
	aErros := {.T.,"Falha conectando o TOP - impprod.prw"}
	RETURN aErros
Else
	Begin Transaction
	// Campos e seus conteudos a serem gravados na tabela SB1
	aCamAux := {}
	
	
	// Query para o detalhamento das notas fiscais de venda.
	cQuery	:= " SELECT *  "
	cQuery	+= " FROM " + RetSqlName("SB1") + " "
	cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND B1_COD = '" + cCodigo + "' "
	
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		dbCloseArea()
	EndIf
	
	TcQuery cQuery New Alias &cAlias
	
	aStruct := DBStruct(cAlias)
	// ABRE A TABELA DE DICONARIO PARA PEGAR OS CAMPOS DAS TABELAS.
	
	For C := 1 To LEN(aStruct)
		DBSelectArea( "SX3" )
		SX3->( DBSetOrder( 2 ) )
		SX3->( DBGoTop() )
		SX3->( DBSeek( aStruct[C][1]) )
		IF  SX3->X3_ARQUIVO == "SB1"  .AND. Alltrim(SX3->X3_CAMPO) == Alltrim(aStruct[C][1]) .AND. SX3->X3_CONTEXTO <> 'V'
			aadd( aCamAux, { SX3->X3_CAMPO, SX3->X3_TIPO } )
		EndIf
	Next C
	
	// Query para pegar o preco de venda.
	cQuery	:= " SELECT B0_COD,B0_PRV1,B0_PRV2,B0_PRV3,B0_PRV4,B0_PRV5,B0_PRV6,B0_PRV7,B0_PRV8,B0_PRV9 "
	cQuery	+= " FROM " + RetSqlName("SB0") + " "
	cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND B0_COD = '" + cCodigo + "' "
	
	If Select("TRB0") > 0
		dbSelectArea("TRB0")
		dbCloseArea()
	EndIf
	
	TcQuery cQuery NEW ALIAS "TRB0"
	
	dbSelectArea("TRB0")
	dbGoTop()
	
	While ("TRB0")->(!EOF())
		AADD(aTRB0,{"B0_COD"  , ("TRB0")->B0_COD })
		AADD(aTRB0,{"B0_PRV1" , ("TRB0")->B0_PRV1})
		AADD(aTRB0,{"B0_PRV2" , ("TRB0")->B0_PRV2})
		AADD(aTRB0,{"B0_PRV3" , ("TRB0")->B0_PRV3})
		AADD(aTRB0,{"B0_PRV4" , ("TRB0")->B0_PRV4})
		AADD(aTRB0,{"B0_PRV5" , ("TRB0")->B0_PRV5})
		AADD(aTRB0,{"B0_PRV6" , ("TRB0")->B0_PRV6})
		AADD(aTRB0,{"B0_PRV7" , ("TRB0")->B0_PRV7})
		AADD(aTRB0,{"B0_PRV8" , ("TRB0")->B0_PRV8})
		AADD(aTRB0,{"B0_PRV9" , ("TRB0")->B0_PRV9})
		
		("TRB0")->(DbSkip())
	Enddo
	
	// Monta um array para comparar a existencia de campos
	
	(cAlias)->(DBGoTop())
	While (cAlias)->(!EOF())
		// Varre todos os campos da tabela Sb1
		For i := 1 To Len(aCamAux)
			Do Case
				// Tratamento para a obrigatoriedade da garantia
				//Case AllTrim((cAlias)->(aCamAux[i][1])) == "B1_LOJPROC"
				   //	aAdd(aProds, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), .F.})
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "B1_GARANT"
					IF (cAlias)->&(aCamAux[i][1]) == "0"
						aAdd(aProds, {aCamAux[i][1], "2", Nil})
					ElseIF Empty((cAlias)->&(aCamAux[i][1]))
						aAdd(aProds, {aCamAux[i][1], "2", Nil})
					Else
						aAdd(aProds, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil})
					EndIF
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "B1_MSBLQL" // 
					aAdd(aProds, {aCamAux[i][1], "2", Nil} )
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "B1_UPRC"
					 IF (cAlias)->&(aCamAux[i][1]) > 0
					 	aAdd(aProds, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil})				
					 ENDIF
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "B1_PROC" .AND. !(cxTipo == "N")
					aAdd(aProds, {aCamAux[i][1], cFornece, Nil})
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "B1_LOJPROC" .AND. !(cxTipo == "N")
					aAdd(aProds, {aCamAux[i][1], cLoja, Nil})
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "B1_TE" // 
					IF !(cxRotina == "ImpVenda" .AND. nOp == 4)
				   		aAdd(aProds, {aCamAux[i][1], ALLTRIM(cTES), Nil} ) 
				   	ENDIF				
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "B1_ESPECIE"
									
					IF aCamAux[i][2] == "C"					
						aAdd(aProds, {aCamAux[i][1],"0", Nil})    
					ELSE
						aAdd(aProds, {aCamAux[i][1], 0 , Nil})    
					ENDIF
					
				Case ValType((cAlias)->&(aCamAux[i][1])) <> "U"
					If aCamAux[i][2] == "D"
						aAdd(aProds, {aCamAux[i][1], StoD( (cAlias)->&(aCamAux[i][1]) ), Nil} )
					Else
						If !Empty((cAlias)->&(aCamAux[i][1]))
							aAdd(aProds, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil} )
						EndIf
					EndIf
				OtherWise
					aAdd(aProds, {aCamAux[i][1], CriaVar(aCamAux[i][1]), Nil} )
			EndCase
		Next
		IncProc ( (cAlias)->(B1_COD) )
		(cAlias)->(DBSkip())
	End
	(cAlias)->(dbCloseArea())
	TCUnLink(nConexao)
	
	dbSelectArea("SB1")
	FOR nX := 1 TO LEN(aProds)
		If FieldPos(aProds[nX][1]) > 0
			aAdd(aProds2, {aProds[NX][1], aProds[NX][2], Nil} )
		ENDIF
	NEXT nX
	aProds := aProds2
	
	// Verifica se existe o produto cadastrado no Producao
	IF Empty(aProds)
		Return {.T., "Produto nao existente no Producao - ImpProd.prw"}
	EndIF
	
	// Verifica se o cadastro do TES jแ existe
	nP := aScan( aProds, { |x| AllTrim( x[1] ) == "B1_TE" } ) 
	IF nP>0
		SF4->( dbSetOrder( 1 ) )
		If !SF4->( dbSeek( xFilial( "SF4" ) + aProds[nP][2] ) )
			// Executa rotina de importa็ใo de TES
		   //	aErros := STARTJOB( "U_ImpTES", getenvserver(), .T., cConectString, cServer, aProds[nP][2], .T.,cEmp, cFil)
			aErros := U_ImpTES(cConectString, cServer, aProds[nP][2], .T.,cEmp, cFil,nxPort)
		EndIf
	ENDIF
	
	// Verifica se o cadastro do TES jแ existe
	nP := aScan (aProds, {|x| AllTrim(x[1]) == "B1_TS"}) 
	IF nP>0
		SF4->(dbSetOrder(1))
		If !SF4->(dbSeek(xFilial("SF4") + aProds[nP][2]))
			// Executa rotina de importa็ใo de TES
		   //	aErros := STARTJOB("U_ImpTES", getenvserver(), .T., cConectString, cServer, aProds[nP][2], .T.,cEmp, cFil)
			aErros := U_ImpTES(cConectString, cServer, aProds[nP][2], .T.,cEmp, cFil,nxPort)
		EndIf
	ENDIF
	
	// Verifica se o tipo do produto jแ existe
	nP := aScan (aProds, {|x| AllTrim(x[1]) == "B1_TIPO"}) 
	DBSELECTAREA("SX5")
	SX5->(dbSetOrder(1))
	If !SX5->(dbSeek(xFilial("SX5") + "02" + aProds[nP][2]))
		RecLock("SX5",.T.)
		SX5->X5_FILIAL		:= xFilial("SX5")
		SX5->X5_TABELA		:= "02"
		SX5->X5_CHAVE		:= aProds[nP][2]
		SX5->X5_DESCRI		:= "Tipo " + aProds[nP][2]
		SX5->X5_DESCSPA		:= "Tipo " + aProds[nP][2]
		SX5->X5_DESCENG		:= "Tipo " + aProds[nP][2]
		SX5->(MsUnLock("SX5"))
	EndIf
	       
   //VERIFICA SE HA ARMAZEN CRIADO NA TABELA NNR, PARA NAO OCORRER ERRO DE NAO EXISTER ARMAZEN NO EXECAUTO.
	
    IF ALIASINDIC("NNR") 
    	nP := aScan (aProds, {|x| AllTrim(x[1]) == "B1_LOCPAD"}) 
		DBSELECTAREA("NNR")
		NNR->(dbSetOrder(1))
		If !NNR->(dbSeek(xFilial("NNR") + aProds[nP][2]))
			RecLock("NNR",.T.)
			NNR->NNR_FILIAL		:= xFilial("NNR")
			NNR->NNR_CODIGO		:= aProds[nP][2] 
			NNR->NNR_DESCRI		:= "ARMAZEN " + aProds[nP][2]
			NNR->NNR_TIPO		:= "2"
			NNR->NNR_INTP		:= "3"
			NNR->NNR_MRP		:= "1"
			NNR->(MsUnLock("SX5"))
		EndIf
	ENDIF
	
	
	// Verifica se o produto jแ existe na SB0
	nP := aScan (aProds, {|x| AllTrim(x[1]) == "B1_COD"})
	dbSelectArea("SB0")
	SB0->(dbSetOrder(1))
	IF !EMPTY(aTRB0)
		If !SB0->(dbSeek(xFilial("SB0") + aProds[nP][2]))
			aErros := {.T.,"Inserindo SB0 - impprod.prw"}
			RecLock("SB0",.T.)
			SB0->B0_FILIAL		:= xFilial("SB0")
			SB0->B0_COD			:= aProds[nP][2]
			//	SB0->B0_DESC	    := TRB0->B0_DESC
			SB0->B0_PRV1		:= aTRB0[2][2]
			SB0->B0_PRV2		:= aTRB0[3][2]
			SB0->B0_PRV3		:= aTRB0[4][2]
			SB0->B0_PRV4		:= aTRB0[5][2]
			SB0->B0_PRV5		:= aTRB0[6][2]
			SB0->B0_PRV6		:= aTRB0[7][2]
			SB0->B0_PRV7		:= aTRB0[8][2]
			SB0->B0_PRV8		:= aTRB0[9][2]
			SB0->B0_PRV9		:= aTRB0[10][2]
			MsUnLock("SB0")
		ELSE
			aErros := {.T.,"Gravando SB0 - impprod.prw"}
			RecLock("SB0",.F.)
			SB0->B0_FILIAL		:= xFilial("SB0")
			SB0->B0_COD			:= aProds[nP][2]
			//	SB0->B0_DESC	    := TRB0->B0_DESC
			SB0->B0_PRV1		:= aTRB0[2][2]
			SB0->B0_PRV2		:= aTRB0[3][2]
			SB0->B0_PRV3		:= aTRB0[4][2]
			SB0->B0_PRV4		:= aTRB0[5][2]
			SB0->B0_PRV5		:= aTRB0[6][2]
			SB0->B0_PRV6		:= aTRB0[7][2]
			SB0->B0_PRV7		:= aTRB0[8][2]
			SB0->B0_PRV8		:= aTRB0[9][2]
			SB0->B0_PRV9		:= aTRB0[10][2]
			MsUnLock("SB0")
		EndIf
	ENDIF
	nPMENT := aScan (aProds, {|x| AllTrim(x[1]) == "B1_PICMENT"}) // aScan ( aItens[i], { |x| AllTrim(x[1] ) == "B1_PICMENT"} )
	IF nPMENT > 0
		if !empty(nPicment)
			aProds[nPMENT][2]:= nPicment
		endif
	ENDIF
	
	nORIGEM := aScan (aProds, {|x| AllTrim(x[1]) == "B1_ORIGEM"})   // aScan ( aItens[i], { |x| AllTrim(x[1] ) == "B1_ORIGEM"} )
	if nORIGEM > 0
		IF  VALTYPE(cOrigem)<>"U"
			if !empty(ALLTRIM(SUBSTR(cOrigem,1,1)))
				aProds[nORIGEM][2]:= substr(cOrigem,1,1)
			ENDIF
		endif
	EndIF
	nP := aScan (aProds, {|x| AllTrim(x[1]) == "B1_TS"})
	// Aguarde... importando produtos.
	
	aProds := FWVetByDic( aProds, "SB1" )
	
	DBSELECTAREA("SB1")
	lMsErroAuto := .F.
	MSExecAuto({| X, Y | Mata010( X,Y )}, aProds, nOp)
	// Verifica se deu algum erro na inclusใo da nota fiscal de entrada
	If lMsErroAuto
		DisarmTransaction()
		//	MostraErro()
		aErros := {.T., "Erro de execauto - Impprod.prw " +chr(13)+chr(10)+MostraErro()}
		Return aErros
	Else
		// Abre uma conexใo com o Top Conect da base producao
	   //	nConexao:= TCLink ( cConectString, cServer)
	   nConexao := TCLink (cConectString,cServer,nxPort)
		// Grava confirma็ใo na base producao da importa็ใo da nota fiscal de entrada
		cQuery	:= " UPDATE " + RetSqlName("SB1") + " SET B1_MSEXP = '" + DtoS(dDataBase) + "' "
		cQuery	+= " WHERE D_E_L_E_T_ <> '*' AND B1_COD = '" + cCodigo + "' "
		// Executa a query para atualizar na base produ็ใo.
		If TCSQLEXEC(cQuery) < 0
			lMsErroAuto := .T.
			
			TCSQLERROR()
			aErros := {.T., "Erro executando sql - produto"}
			DisarmTransaction()
			TCUnLink(nConexao)
			Return aErros
		EndIf
		// Fecha conexใo com o Top Conect do producao
		TCUnLink(nConexao)
		aErros := {.F.,"Cadastro de produto OK - impprod.prw"}
		
	EndIf
	End Transaction
EndIf
//Limpa o ambiente, liberando a licen็a e fechando as conex๕es
//RpcClearEnv()
//RESET ENVIRONMENT
Return aErros



