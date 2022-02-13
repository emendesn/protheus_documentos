#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECAX023  ºAutor  ³D.FERNANDES         º Data ³  10/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao especifica para amarraçao de fases para controle    º±±
±±º          ³ do bounce interno                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TECAX023()

Private cCadastro := "Entrada Massiva"
Private cAlias := "ZA8" 
Private aRotina := { 	{'Defeitos', "u_TECADEF1"  , 0,2},;   //"Visualizar"
{'Incluir', "AxInclui"  , 0,3},;   //"Incluir "
{'Alterar', "AxAltera"  , 0,4},;   //"Alterar"
{"Excluir"   , "AxDeleta" , 0,5}}      //"Legenda"

dbSelectArea("ZA8")
ZA8->(dbSetorder(1))                       

mBrowse( 6,1,22,75,cAlias)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECADEF1  ºAutor  ³D.FERNANDES         º Data ³  10/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para manipular dados na tabela SX5 				  º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TECADEF1()

Local aBtn 	   	:= Array(10)
Local lConf     := .F. 

Private nLinha  := 1
Private nOpcx   := 4
Private nUsado  := 1
Private dData   := dDataBase
Private aHeader := {}
Private aCols   := {}

//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados              ¦
//+-----------------------------------------------+
aAdd(aHeader,{"Código","CODIGO","@!",3,0,,,"C",,"V"})
aAdd(aHeader,{"Descricao","DESC","@!",55,0,,,"C",,"V"})

//+-----------------------------------------------+
//¦ Montando aCols para a GetDados                ¦
//+-----------------------------------------------+
cQuery := " SELECT X5_CHAVE, "
cQuery += " 	   X5_DESCRI "
cQuery += " FROM "+RetSqlName("SX5")+" SX5  "
cQuery += " WHERE X5_TABELA = 'YW'  "
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += " AND X5_FILIAL = '"+xFilial("SX5")+"' "
cQuery += " ORDER BY X5_CHAVE "

If Select("TSQL") > 0
	TSQL->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS 'TSQL'

//+----------------------------------------------+
//¦ Alimenta acols de acordo com os Filtros 	 ¦
//+----------------------------------------------+
While TSQL->(!Eof())
	
	AAdd(aCols, Array(Len(aHeader)+1))
	nLinha := Len(aCols)
	
	aCols[nLinha][1]  := TSQL->X5_CHAVE
	aCols[nLinha][2]  := TSQL->X5_DESCRI
	aCols[nLinha][Len(aHeader)+1] := .F.
	
	TSQL->(dbskip())
EndDo

If Len(aCols) <> 0
	//+----------------------------------------------+
	//¦ Titulo da Janela                             ¦
	//+----------------------------------------------+
	cTitulo := "Cadastro de defeitos"
	
	//+----------------------------------------------+
	//¦ Array com descricao dos campos do Cabecalho  ¦
	//+----------------------------------------------+
	aC:={}
	aR:={}
	
	aGets := {}
	AADD(aGets,"CODIGO")
	AADD(aGets,"DESC")
	
	//+------------------------------------------------+
	//¦ Array com coordenadas da GetDados no modelo2   ¦
	//+------------------------------------------------+
	#IFDEF WINDOWS
		aCGD := {44,5,518,915}
	#ELSE
		aCGD := {10,04,15,73}
	#ENDIF
		
	lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,,,aGets,,,999,,,,)
	                                                          
	
	If lRet .And. MsgYesNo("Confirma alteracao nos dados?")
	
		For nLin := 1 To Len(aCols)
			                                      
			If !Empty(aCols[nLin][1]) .And. !Empty(aCols[nLin][2])
				dbSelectArea("SX5")
				dbSetOrder(1)
				If !MsSeek(xFilial("SX5")+"YW"+aCols[nLin][1])
					SX5->(RecLock("SX5",.T.))
					SX5->X5_FILIAL  := xFilial("SX5")
					SX5->X5_TABELA  := "YW"
					SX5->X5_CHAVE   := aCols[nLin][1]
					SX5->X5_DESCRI  := aCols[nLin][2]				
					SX5->X5_DESCSPA := aCols[nLin][2]								
					SX5->X5_DESCENG := aCols[nLin][2]												
					SX5->(MsUnLock())
				Else
					If aCols[nLin][Len(aHeader)+1]//Se for excluido apaga registro 
					
						//Verificar se o codigo pode ser excluido
						MsAguarde({ || lConf := ConfDel(aCols[nLin][1]) }, "Aguarde - Validando apontamentos . . . ")
						If !lConf
							Aviso("Não pode excluir", aCols[nLin][1] + " modo de falha não pode ser excluído, já existe apontamento!",{"Ok"})
						Else						
							SX5->(RecLock("SX5",.F.))
							SX5->(dbDelete())
							SX5->(MsUnLock())											
						EndIf							
					Else
						//Altera somente a descricao
						SX5->(RecLock("SX5",.F.))
						SX5->X5_DESCRI  := aCols[nLin][2]				
						SX5->X5_DESCSPA := aCols[nLin][2]								
						SX5->X5_DESCENG := aCols[nLin][2]				
						SX5->(MsUnLock())											
					EndIf					
				EndIf			
			Else
				Alert("Codigo ou Descricao não preenchido, item não será gravado!")						
			EndIf				
										
		Next nLin
		
	EndIf
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConfDel   ºAutor  ³D.FERNANDES         º Data ³  10/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao especifica para verificar se existe apontamento     º±±
±±º          ³ 					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConfDel(cModFal)

Local cQuery := ""
Local lRet   := .T.

cQuery := " SELECT COUNT(ZZ3_MODFLA) AS TOTAL "
cQuery += " FROM "+RetSqlName("ZZ3")+" ZZ3
cQuery += " WHERE ZZ3_MODFLA = '"+cModFal+"'
cQuery += " AND ZZ3_FILIAL = '"+xFilial("ZZ3")+"'
cQuery += " AND D_E_L_E_T_ = ''

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
TMP->(dbGotop())

If TMP->TOTAL > 0 
	lRet   := .F.
EndIf

Return lRet