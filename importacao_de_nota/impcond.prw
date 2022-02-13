#INCLUDE "Rwmake.ch" 
#INCLUDE "TOTVS.CH"
#INCLUDE "TbiConn.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ImpCond   � Autor � Herbert Ayres       Data �  13/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para realizar a importacao da condicao de pagamen-���
���          � to da base producao para a base TEF.                       ���
�������������������������������������������������������������������������͹��
���Uso       � Totvs Protheus 10                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ImpCond (cConectString, cServer, cCond, lInclui,cEmp, cFil,nxPort)

Local lRet		:= .T.	// Vari�vel de retorno da fun��o. Indica se a importa��o teve sucesso ou n�o.
Local aCond		:= {}	// Vari�vel com dados da condicao de pagamento
Local aCond2		:= {}	// Vari�vel com dados da condicao de pagamento
Local aStruct		:= {}
Local cAlias	:= GetNextAlias()	// Vari�vel que contem o proximo alias
Local nConexao
Local aErros := {.F.,"Cadastro de Condicao OK - impcond.prw"}
Local lLocal := .F. // colacar .T. para testes
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
	aErros := {.T.,"Erro de conexao - impcond.prw"}
	Return aErros
Else
	Begin Transaction
	
	// Campos e seus conteudos a serem gravados na tabela SB1
	aCamAux := {}
	
	
	// Query para o detalhamento das notas fiscais de venda.
	cQuery	:= "SELECT E4.* FROM " + RetSqlName("SE4") + " AS E4 "
	cQuery	+= "WHERE E4.D_E_L_E_T_ <> '*' AND E4_CODIGO = '" + cCond + "' "
	
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
		IF  SX3->X3_ARQUIVO == "SE4"  .AND. Alltrim(SX3->X3_CAMPO) == Alltrim(aStruct[C][1]) .AND. SX3->X3_CONTEXTO <> 'V'
			aadd( aCamAux, { SX3->X3_CAMPO, SX3->X3_TIPO } )
		EndIf
	Next C
	
	(cAlias)->(DBGoTop())
	While (cAlias)->(!EOF())
		
		// Varre todos os campos da tabela SD1
		For i := 1 To Len(aCamAux)
			
			Do Case
				Case VALType((cAlias)->&(aCamAux[i][1])) <> "U"
					If aCamAux[i][2] == "D"
						aAdd(aCond, {aCamAux[i][1], StoD( (cAlias)->&(aCamAux[i][1]) ), Nil} )
					Else
						aAdd(aCond, {aCamAux[i][1], (cAlias)->&(aCamAux[i][1]), Nil} )
					EndIf
				OtherWise
					aAdd(aCond, {aCamAux[i][1], CriaVar(aCamAux[i][1]), Nil} )
			EndCase
			
		Next
		
		(cAlias)->(dbSkip())
		IncProc ( (cAlias)->(E4_CODIGO) )
		
	End
	(cAlias)->(dbCloseArea())
	
	TCUnLink(nConexao)
	
	dbSelectArea("SE4")
	FOR nX := 1 TO LEN(aCond)
		If FieldPos(aCond[nX][1]) > 0
			aAdd(aCond2, {aCond[NX][1], aCond[NX][2], Nil} )
		ENDIF
	NEXT nX
	aCond := aCond2
	
	IF Empty(aCond)
		DisarmTransaction()
		Return {.T., "Condi��o de pagamento inexistente no Produ��o - ImpCond.prw"}
	EndIF
	
	// Aguarde... importando grupo.
	If lInclui
		RecLock("SE4", .T.)
		For i := 1 To Len(aCond)
			SE4->&(aCond[i][1]) := aCond[i][2]
		Next
		MsUnLock("SE4")
	Else
		SE4->(dbSeek(xFilial("SE4") + cCond))
		RecLock("SE4", .F.)
		For i := 1 To Len(aCond)
			SE4->&(aCond[i][1]) := aCond[i][2]
		Next
		MsUnLock("SE4")
	EndIf
	
	// Abre uma conex�o com o Top Conect da base producao
   //	nConexao:= TCLink (cConectString,cServer)
   nConexao := TCLink (cConectString,cServer,nxPort)
	
	// Grava confirma��o na base producao da importa��o da nota fiscal de entrada
	cQuery	:= "UPDATE " + RetSqlName("SE4") + " SET E4_MSEXP = '" + DtoS(dDataBase) + "' "
	cQuery	+= "WHERE D_E_L_E_T_ <> '*' AND E4_CODIGO = '" + cCond + "' "
	
	// Executa a query para atualizar na base produ��o.
	
	If TCSQLEXEC(cQuery) < 0
		lRet := .F.
		//TCSQLERROR()
		DisarmTransaction()
		if lLocal
			TCSQLERROR()
		else
			aErros := {.T.,"Erro de Tcquery - impcond.prw" + chr(13)+chr(10)+TCSQLERROR()}
		endif
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
