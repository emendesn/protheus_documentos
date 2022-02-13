//#INCLUDE "Rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TbiConn.CH"
//#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpForn  บ Autor ณ Herbert Ayres       Data ณ  13/03/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para realizar a importacao do fornecedor da base  บฑฑ
ฑฑบ          ณ producao para a base TEF.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs Protheus 10                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ImpForn (cConectString, cServer, cCodigo, cLoja, nOp,cEmp, cFil,nxPort)

Local aFornece		:= {}	// Variแvel de fornecedor
Local aFornece2		:= {}	// Variแvel de fornecedor
Local cAlias			:= GetNextAlias()	// Variแvel que contem o proximo alias
Local nConexao
Local aStruct		:= {}
Local C
Local I
Local nX

Private lMsErroAuto	:= .T.	// Variแvel retorno da fun็ใo. Indica se a importa็ใo teve sucesso ou nใo.
Private aErros 		:= {.F., "Cadastro de fornecedor OK - impforn.prw"}

/*
cConectString	:= "MSSQL7/PRODUCAO11_MARIO"
cServer			:= "192.168.2.110"
cCodigo:="001359"
cLoja:= "01"
nOp  :=  3
*/
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
	lRet := .F.
	aErros := {.T.,"Falha conectando o TOP - impforn.prw"}
	
Else
	Begin Transaction
	
	// Campos e seus conteudos a serem gravados na tabela SB1
	aCamAux := {}
	
	// Query para o detalhamento das notas fiscais de venda.
	cQuery	:= " SELECT A2.* "
	cQuery	+= " FROM " + RetSqlName("SA2") + " AS A2 "
	cQuery	+= " 		WHERE A2.D_E_L_E_T_ <> '*' AND A2_COD = '" + cCodigo + "' AND A2_LOJA = '" + cLoja + "' "
	
	If Select( cAlias ) > 0
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
		IF  SX3->X3_ARQUIVO == "SA2"  .AND. Alltrim(SX3->X3_CAMPO) == Alltrim(aStruct[C][1]) .AND. SX3->X3_CONTEXTO <> 'V'
			aadd( aCamAux, { SX3->X3_CAMPO, SX3->X3_TIPO } )
		EndIf
	Next C
	
	(cAlias)->(DBGoTop())
	While (cAlias)->(!EOF())
		
		// Varre todos os campos da tabela SA2
		For i := 1 To Len(aCamAux)
			
			Do Case
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "A2_NATUREZ" // Nao envia	
				Case AllTrim((cAlias)->(aCamAux[i][1])) == "A2_MSBLQL" // 
					aAdd(aFornece, {aCamAux[i][1], "2", Nil} )				
				Case VALType((cAlias)->&(aCamAux[i][1])) <> "U"
					If aCamAux[i][2] = "D"
						aAdd(aFornece, {aCamAux[i][1], StoD( (cAlias)->&(aCamAux[i][1]) ), Nil} )
					Else
						If !Empty((cAlias)->&(aCamAux[i][1]))
							aAdd(aFornece, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil} )
						EndIf
					EndIf
				OtherWise
					aAdd(aFornece, {aCamAux[i][1], CriaVar(aCamAux[i][1]), Nil} )
			EndCase
			
		Next	
		
	(cAlias)->(dbSkip())
	IncProc( (cAlias)->(A2_COD + A2_LOJA) )
		
	End
	(cAlias)->(dbCloseArea())
	
	TCUnLink(nConexao)
	
	dbSelectArea("SA2")
	FOR nX := 1 TO LEN(aFornece)
		If FieldPos(aFornece[nX][1]) > 0
			aAdd(aFornece2, {aFornece[NX][1], aFornece[NX][2], Nil} )
		ENDIF
	NEXT nX
	aFornece := aFornece2
	
	IF Empty(aFornece)
    	DisarmTransaction() 
		Return {.T., "Fornecedor nao existente no Producao - ImpFor.prw"}
	EndIF
	
	// Aguarde... importando produtos.
	lMsErroAuto := .F.	
	MSExecAuto({|X, Y| Mata020(X,Y)}, aFornece, nOp) 

	// Verifica se deu algum erro na inclusใo da nota fiscal de entrada
	If lMsErroAuto
		//			MostraErro()
		DisarmTransaction()
		aErros := {.T.,"Falha execauto - impforn.prw"+ chr(13)+chr(10) + MostraErro()}
		Return aErros
	Else
		// Abre uma conexใo com o Top Conect da base producao
	   //	nConexao:= TCLink (cConectString,cServer) 
	   nConexao := TCLink (cConectString,cServer,nxPort)
		
		// Grava confirma็ใo na base producao da importa็ใo da nota fiscal de entrada
		cQuery	:= "UPDATE " + RetSqlName("SA2") + " SET A2_MSEXP = '" + DtoS(dDataBase) + "' "
		cQuery	+= "WHERE D_E_L_E_T_ <> '*' AND A2_COD = '" + cCodigo + "' AND A2_LOJA = '" + cLoja + "' "
		
		// Executa a query para atualizar na base produ็ใo.
		
		If TCSQLEXEC(cQuery) < 0
			lRet := .F.
			TCSQLERROR()
			aErros := {.T.,"Erro SQL- impforn.prw"}
			
			DisarmTransaction()
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

Return aErros
