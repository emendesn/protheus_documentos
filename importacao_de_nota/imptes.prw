#INCLUDE "Rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TbiConn.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"


/*/este
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpTES   บ Autor ณ Herbert Ayres       Data ณ  13/03/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para realizar a importacao do TES da base producaoบฑฑ
ฑฑบ          ณ para a base TEF.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs Protheus 10                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ImpTES (cConectString, cServer, cTES, lInclui,cEmp, cFil,nxPort)

Local lRet			:= .T.	// Variแvel retorno da fun็ใo. Indica se a importa็ใo teve sucesso ou nใo.
Local aTES			:= {}	// Variแvel de TES
Local aTES2			:= {}	// Variแvel de TES
Local cAlias		:= GetNextAlias()	// Variแvel que contem o proximo alias
Local nConexao
Local nRegs     	:= 0
Local aErros 		:= {.F.,"Cadastro de TES OK - imptes.prw"}
Local aStruct     	:= {} 
Local I 
Local C
Local nX
//cTes:= "100"

//lInclui :=.T.
////////////////////
//cConectString	:= "MSSQL7/PRODUCAO"
//cServer			:= "192.168.1.103"
///////////////

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
	aErros := {.T.,"Falha conectando o TOP - imptes.prw"}
	lRet := .F.
Else
	Begin Transaction
	
	// Campos e seus conteudos a serem gravados na tabela SB1
	aCamAux := {}
	
	// Query para o detalhamento das notas fiscais de venda.
	cQuery	:= "SELECT F4.* FROM " + RetSqlName("SF4") + " AS F4 "
	cQuery	+= "WHERE F4.D_E_L_E_T_ <> '*' AND F4_CODIGO = '" + cTES + "' "
	
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
		IF  SX3->X3_ARQUIVO == "SF4"  .AND. Alltrim(SX3->X3_CAMPO) == Alltrim(aStruct[C][1]) .AND. SX3->X3_CONTEXTO <> 'V'
			aadd( aCamAux, { SX3->X3_CAMPO, SX3->X3_TIPO } )
		EndIf
	Next C
	
	//
	(cAlias)->(DBGoTop())
	While (cAlias)->(!EOF())
		// Varre todos os campos da tabela SD1
		For i := 1 To Len(aCamAux)
			Do Case
		   		Case AllTrim((cAlias)->(aCamAux[i][1])) == "F4_MSBLQL" // 
					aAdd(aTES, {aCamAux[i][1], "2", Nil} )	
				Case VALType((cAlias)->&(aCamAux[i][1])) <> "U"
					If aCamAux[i][2] = "D"
						aAdd(aTES, {aCamAux[i][1], StoD( (cAlias)->&(aCamAux[i][1]) ), Nil} )
					Else
						aAdd(aTES, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil} )
					EndIf
				OtherWise
					aAdd(aTES, {aCamAux[i][1], CriaVar(aCamAux[i][1]), Nil} )
			EndCase
		Next
		
		(cAlias)->(dbSkip())
		IncProc ( (cAlias)->(F4_CODIGO) )
		//		 nRegs += 1
	End
	(cAlias)->(dbCloseArea())
	
	TCUnLink(nConexao)		
	dbSelectArea("SF4")
	FOR nX := 1 TO LEN(aTES)
		If FieldPos(aTES[nX][1]) > 0
			aAdd(aTES2, {aTES[NX][1], aTES[NX][2], Nil} )
		ENDIF
	NEXT nX
	aTES := aTES2
	
	// Verifica se existe o produto cadastrado no Producao
	IF Empty(aTES)
		DisarmTransaction()
		Return {.T., "TES nao existente no Producao - ImpTES.prw"}
	EndIF
	
	// Aguarde... importando TES.
	//	if nRegs >0
	If lInclui
		RecLock("SF4", .T.)
		For i := 1 To Len(aTES)
			SF4->&(aTES[i][1]) := aTES[i][2]
		Next
		MsUnLock("SF4")
	Else
		SF4->(dbSeek(xFilial("SF4") + cTES))
		RecLock("SF4", .F.)
		For i := 1 To Len(aTES)
			SF4->&(aTES[i][1]) := aTES[i][2]
		Next
		MsUnLock("SF4")
	EndIf
	
	End Transaction
	
EndIf


Return aErros 

