#INCLUDE "Rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TbiConn.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ImpGrupo  � Autor � Herbert Ayres       Data �  13/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para realizar a importacao do grupo da base produ-���
���          � cao para a base TEF.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Totvs Protheus 10                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ImpGrupo (cConectString, cServer, cGrupo, lInclui,cEmp, cFil,nxPort)

Local lRet		:= .T.	// Vari�vel de retorno da fun��o. Indica se a importa��o teve sucesso ou n�o.
Local aGrupo	:= {}	// Vari�vel com dados do grupo
Local aGrupo2	:= {}	// Vari�vel com dados do grupo
Local cAlias	:= GetNextAlias()	// Vari�vel que contem o proximo alias
Local nConexao
Local aErros 	:= {.F., "Cadastro de Grupo OK - ImpGrupo.prw"}
Local lLocal 	:= .F. // colocar .T. para testes
Local aStruct	:= {} 
Local C
Local I
Local nX

//Seta job para nao consumir licensas
//	RpcSetType(3)

// Seta job para empresa filial desejada
//	RpcSetEnv( cEmp, cFil,,,'FAT')
//PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES  "SX2", "SX3", "SA1", "SA2", "SE4", "SBM", "SF4", "SB1", "SX5" MODULO "FAT"

//Especifica o protocolo de comunica��o a ser utilizado pelo TOPConnect.
TCConType("TCPIP")

// Abre uma conex�o com o Top Conect da base producao
//nConexao := TCLink (cConectString,cServer)
nConexao := TCLink (cConectString,cServer,nxPort)

//Valida se a conex�o realmente foi estabelecida
If nConexao < 0 //Conex�es com retorno < 0 significam erro
	Alert("Falha de conex�o com o TOPConnect: " + Str(nConexao))
	lRet := .F.
	aErros := {.T.,"Falha de conex�o com o TOPConnect: - impgrupo.prw"}
	Return aErros
Else
	Begin Transaction
	
	// Campos e seus conteudos a serem gravados na tabela SB1
	aCamAux := {}	
	
	// Query para o detalhamento das notas fiscais de venda.
	cQuery	:= "SELECT BM.* FROM " + RetSqlName("SBM") + " AS BM "
	cQuery	+= "WHERE BM.D_E_L_E_T_ <> '*' AND BM_GRUPO = '" + cGrupo + "' "
	
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
		IF  SX3->X3_ARQUIVO == "SBM"  .AND. Alltrim(SX3->X3_CAMPO) == Alltrim(aStruct[C][1]) .AND. SX3->X3_CONTEXTO <> 'V'
			aadd( aCamAux, { SX3->X3_CAMPO, SX3->X3_TIPO } )
		EndIf
	Next C
	
	//
	(cAlias)->(DBGoTop())
	While (cAlias)->(!EOF())
		
		// Varre todos os campos da tabela SD1
		For i := 1 To Len(aCamAux)
			
			Do Case
				Case VALType((cAlias)->&(aCamAux[i][1])) <> "U"
					If aCamAux[i][2] = "D"
						aAdd(aGrupo, {aCamAux[i][1], StoD( (cAlias)->&(aCamAux[i][1]) ), Nil} )
					Else
						aAdd(aGrupo, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil} )
					EndIf
				OtherWise
					aAdd(aGrupo, {aCamAux[i][1], CriaVar(aCamAux[i][1]), Nil} )
			EndCase
			
		Next
		
		(cAlias)->(dbSkip())
		IncProc ( (cAlias)->(BM_GRUPO) )
		
	End
	(cAlias)->(dbCloseArea())
	
	TCUnLink(nConexao)
	
	dbSelectArea("SBM")
	FOR nX := 1 TO LEN(aGrupo)
		If FieldPos(aGrupo[nX][1]) > 0
			aAdd(aGrupo2, {aGrupo[NX][1], aGrupo[NX][2], Nil} )
		ENDIF
	NEXT nX
	aGrupo := aGrupo2
	
	
	IF Empty(aGrupo)
   		DisarmTransaction() 
		Return {.T., "Grupo nao existente no Producao - ImpGrupo.prw"}
	EndIF
	
	// Aguarde... importando grupo.
	If lInclui
		RecLock("SBM", .T.)
		For i := 1 To Len(aGrupo)
			SBM->&(aGrupo[i][1]) := aGrupo[i][2]
		Next
		MsUnLock("SBM")
	Else
		SBM->(dbSeek(xFilial("SBM") + cGrupo))
		RecLock("SBM", .F.)
		For i := 1 To Len(aGrupo)
			SBM->&(aGrupo[i][1]) := aGrupo[i][2]
		Next
		MsUnLock("SBM")
	EndIf
	
	// Abre uma conex�o com o Top Conect da base producao
	nConexao:= TCLink (cConectString,cServer)
	
	// Grava confirma��o na base producao da importa��o da nota fiscal de entrada
	cQuery	:= "UPDATE " + RetSqlName("SBM") + " SET BM_MSEXP = '" + DtoS(dDataBase) + "' "
	cQuery	+= "WHERE D_E_L_E_T_ <> '*' AND BM_GRUPO = '" + cGrupo + "' "
	
	// Executa a query para atualizar na base produ��o.
	
	If TCSQLEXEC(cQuery) < 0
		lRet := .F.
		if lLocal
			TCSQLERROR()
		else
			aErros := {.T.,"Erro de TcQuery: - ImpGrupo.prw"}
		endif
		DisarmTransaction() 
		TCUnLink(nConexao)
		Return aErros
	EndIf
	
	// Fecha conex�o com o Top Conect do producao
	TCUnLink(nConexao)
	
	End Transaction
	
EndIf

//Limpa o ambiente, liberando a licen�a e fechando as conex�es
//	RpcClearEnv()
//RESET ENVIRONMENT
Return aErros
