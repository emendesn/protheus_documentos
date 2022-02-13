#INCLUDE "Rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TbiConn.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpCli    บ Autor ณ Herbert Ayres       Data ณ  13/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para realizar a importacao do cliente da base pro-บฑฑ
ฑฑบ          ณ ducao para a base TEF.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs Protheus 10                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ImpCli (cConectString, cServer, cCodigo, cLoja, nOp,cEmp, cFil,nxPort)

Local lLocal 			:= .F. // para testes locais colcar .T.
Local aCliente		:= {}	// Variแvel de fornecedor
Local aCliente2		:= {}
Local aStruct		:= {}
Local cAlias			:= GetNextAlias()	// Variแvel que contem o proximo alias
Local nConexao
Local C
Local I
Local nX

Private lMsErroAuto	:= .F.	// Variแvel de controle do MsExecAuto e retorno da fun็ใo. Indica se a importa็ใo teve sucesso ou nใo.
aErros 				:= {.F.,"Cadastro de cliente OK - impcli.prw"}

//Seta job para nao consumir licensas
//	RpcSetType(3)

// Seta job para empresa filial desejada
//	RpcSetEnv( cEmp, cFil,,,'FAT')
//PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES  "SX2", "SX3", "SA1", "SA2", "SE4", "SBM", "SF4", "SB1", "SX5" MODULO "FAT"

//Especifica o protocolo de comunica็ใo a ser utilizado pelo TOPConnect.
TCConType("TCPIP")

// Abre uma conexใo com o Top Conect da base producao
//nConexao := TCLink (cConectString,cServer)
nConexao := TCLink (cConectString,cServer,nxPort)

//Valida se a conexใo realmente foi estabelecida
If nConexao < 0 //Conex๕es com retorno < 0 significam erro
	Alert("Falha de conexใo com o TOPConnect: " + Str(nConexao))
	lMsErroAuto := .T.
	aErros := {.T.,"Falha conectando o TOP - impclie.prw"}
	Return aErros
Else
	Begin Transaction
	
	// Campos e seus conteudos a serem gravados na tabela SB1
	aCamAux := {}
	
	
	// Query para o detalhamento das notas fiscais de venda.
	cQuery	:= "SELECT A1.* FROM " + RetSqlName("SA1") + " AS A1 "
	cQuery	+= "WHERE A1.D_E_L_E_T_ <> '*' AND A1_COD = '" + cCodigo + "' AND A1_LOJA = '" + cLoja + "' "
	
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		dbCloseArea()
	EndIf
	
	//
	TcQuery cQuery New Alias &cAlias
	//
	
	
	aStruct := DBStruct(cAlias)
	
	// ABRE A TABELA DE DICONARIO PARA PEGAR OS CAMPOS DAS TABELAS.
	For C := 1 To LEN(aStruct)
		DBSelectArea( "SX3" )
		SX3->( DBSetOrder( 2 ) )
		SX3->( DBGoTop() )
		SX3->( DBSeek( aStruct[C][1]) )
		IF  SX3->X3_ARQUIVO == "SA1"  .AND. Alltrim(SX3->X3_CAMPO) == Alltrim(aStruct[C][1]) .AND. SX3->X3_CONTEXTO <> 'V'
			aadd( aCamAux, { SX3->X3_CAMPO, SX3->X3_TIPO } )
		EndIf
	Next C
	
	(cAlias)->(DBGoTop())
	While (cAlias)->(!EOF())
		
		// Varre todos os campos da tabela SD1
		For i := 1 To Len(aCamAux)
			
			Do Case
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "A1_NATUREZ" // Nao envia 
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "A1_MSBLQL" // 
					aAdd(aCliente, {aCamAux[i][1], "2", Nil} )
				Case VALType((cAlias)->&(aCamAux[i][1])) <> "U"
					If aCamAux[i][2] = "D"
						aAdd(aCliente, {aCamAux[i][1], StoD( (cAlias)->&(aCamAux[i][1]) ), Nil} )
					Else
						If !Empty((cAlias)->&(aCamAux[i][1]))
							aAdd(aCliente, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil} )
						EndIf
					EndIf
				OtherWise
					aAdd(aCliente, {aCamAux[i][1], CriaVar(aCamAux[i][1]), Nil} )
			EndCase
			
		Next
		
		(cAlias)->(dbSkip())
		IncProc ( (cAlias)->(A1_COD + A1_LOJA) )
		
	End
	(cAlias)->(dbCloseArea())
	
	TCUnLink(nConexao)
	
	dbSelectArea("SA1")
	FOR nX := 1 TO LEN(aCliente)
		If FieldPos(aCliente[nX][1]) > 0
			aAdd(aCliente2, {aCliente[NX][1], aCliente[NX][2], Nil} )
		ENDIF
	NEXT nX
	aCliente := aCliente2
	
	
	IF Empty(aCliente)
		DisarmTransaction()
		Return {.T., "Cliente nao existente no Producao - Impcli.prw"}
	EndIF
	
	// Aguarde... importando produtos.
	lMsErroAuto := .F.
	MSExecAuto({|X, Y| Mata030(X,Y)}, aCliente, nOp)
	
	// Verifica se deu algum erro na inclusใo da nota fiscal de entrada
	If lMsErroAuto
		if lLocal
			MostraErro()
		else
			aErros := {.T.,"Erro de execauto-impcli.prw" + chr(13)+chr(10) + MostraErro()}
		endif
		DisarmTransaction()
		Return aErros
	Else
		
		// Abre uma conexใo com o Top Conect da base producao
	   //	nConexao:= TCLink (cConectString,cServer)
	   nConexao := TCLink (cConectString,cServer,nxPort)
		
		// Grava confirma็ใo na base producao da importa็ใo do cliente
		cQuery	:= "UPDATE " + RetSqlName("SA1") + " SET A1_MSEXP = '" + DtoS(dDataBase) + "' "
		cQuery	+= "WHERE D_E_L_E_T_ <> '*' AND A1_COD = '" + cCodigo + "' AND A1_LOJA = '" + cLoja + "' "
		
		// Executa a query para atualizar na base produ็ใo.
		
		If TCSQLEXEC(cQuery) < 0
			lMsErroAuto := .T.
			if lLocal
				TCSQLERROR()
			else
				aErros := {.F.,"Erro de TCquery-impcli.prw" + chr(13)+chr(10)+ TCSQLERROR() }
			endif
			DisarmTransaction() 
			TCUnLink(nConexao)
			Return aErros
		EndIf
		
		// Fecha conexใo com o Top Conect do producao
		TCUnLink(nConexao)
	EndIf
	
	End Transaction
	
EndIf

//Limpa o ambiente, liberando a licen็a e fechando as conex๕es
//	RpcClearEnv()
//RESET ENVIRONMENT

Return 	aErros
