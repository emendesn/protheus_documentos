#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#define ENTER CHR(10)+CHR(13)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REGESMAS บ Autor ณEdson Rodrigues     บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณREGULARIZACAO DE ENTRADA/SAIDA MASSIVA QUANDO O PEDIDO DE   บฑฑ
ฑฑบ          ณSAIDA ษ INCLUSO OU ALTERADO ESPECIICAMENTE MANUALMENTE      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIELD SERVICE                                              บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alterado por M.Munhoz em 19/08/2011 para substituir o tratamento do D1_NUMSER  ณ
//ณ pelo D1_ITEM, uma vez que o IMEI deixara de ser gravado no SD1.                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function REGESMAS()


Local _cQry
Local _cQryc
Local _cQryExec
Local _periodo
Local _cgaran
Local lUsrAut  := .F.
Local luppedES := .F.
Local lupdadES := .F.

Private cPerg 	:= "REGESM"
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Return
Static Functio Auxi()
u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado a fazer troca de IMEI
	If upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES#NEXTELLIDER#EXPLIDER"
		lUsrAut  := .T.
	EndIf
	
Next i



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha a tabela temporaria QRY se estiver aberta.                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Verifica dicionario de perguntas                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fCriaSX1(cPerg)

If Pergunte(cPerg, .T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem da tela de processamento.                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	@ 200,1 TO 380,430 DIALOG oREGESM TITLE OemToAnsi("Regulariza E/S Massiva")
	@ 02,10 TO 068,210
	@ 10,018 Say " Este programa ira regularizar a Entrada e Saida Massiva,conforme os parame- "
	@ 18,018 Say " tros definido,somente onde o pedido tenha sido incluso manualmente  ou "
	@ 26,018 Say " alterado o IMEI, OS etc.., campos essenciais para amarracao com E/S Massiva."
	
	@ 70,128 BMPBUTTON TYPE 01 ACTION Processa( {|lEnd| OKREGESM(@lEnd)}, "Aguarde...","Filtrando/Gravando Pedido/Item na E/S Massiva...", .F. )
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oREGESM)
	
	Activate Dialog oREGESM Centered
Endif


Return



Static Function OKREGESM(lEnd)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Verifica parametros em brancos                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(mv_par01) .and. Empty(mv_par02) .and. Empty(mv_par03) .and. Empty(mv_par04) .and. Empty(mv_par05)
	MsgStop("Favor preencher pelo menos um paramento. Favor preencher....")
	Return
	
Elseif ((Empty(mv_par01) .and. Empty(mv_par02)) .or. (mv_par02 < mv_par01))
	MsgStop(" O Campo 'Emissao Pedido Ate ' tem que ser maior que o campo 'Emissao Pedido de'. Favor preencher....")
	Return
	
EndIf

CursorWait()

luppedES :=REGESM01()


If  luppedES                             
   
	lupdadES :=Processa( {|| REGESM02()}, "Aguarde...","Atualizando E/S Massiva com outras Inform. de Saida...", .T. )
    If !lupdadES
       MsgAlert("Nao foi feita nenhum atualizacao de outras informacoes no arquivo de E/S Massiva. Consulte a Rastreabilidade de IMEI e veja se voce atingiu o resultado esperado. ")
       Return nil
    Endif
Else
   MsgAlert("Nao foi encontrado nenhum registro (pedido) com relacionamento com a E/S Massiva. Revise seus parametros ou entre em contato com o Administrador do Sistema ")
   Return nil
Endif


CursorArrow()

MsgAlert("Regularizao da E/S saida massiva efetuada com sucesso !!")
Close(oREGESM)

Return nil



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณEdson Rodrigues     บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERA DICIONARIO DE PERGUNTAS                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fCriaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cKey 		:= ""
Local aHelpEng 	:= {}
Local aHelpPor 	:= {}
Local aHelpSpa 	:= {}

PutSX1(cPerg,"01","Emissao Pedido de : ","","","mv_ch1","D",08,0,0,"G","",""    ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Emissao Pedido ate: ","","","mv_ch2","D",08,0,0,"G","",""    ,"","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Pedido de         : ","","","mv_ch3","C",06,0,0,"G","",""    ,"","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Pedido ate        : ","","","mv_ch4","C",06,0,0,"G","",""    ,"","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","IMEI   ?","","","mv_ch5","C",TamSX3("ZZ4_IMEI")[1],0,0,"G","",""    ,"","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","")


cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Digite uma data Inicial para  informar a .")
aAdd(aHelpPor,"Emissao do primeiro Pedido")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe uma data final para informar a Emissao do ultimo pedido.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe um Pedido Inicial .")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "04."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe um Pedido final .")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "05."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o IMEI, se tratar de regularizacao de somente um.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return Nil







/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREGESM01  บ Autor ณEdson Rodrigues     บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFAZ PRIMEIRO FILTRO (PRINCIPAL)                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ REGEMAS.PRW                                                บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION REGESM01()
Local _nopcao :=0
Local _nvezes :=8
Local _lselct :=.f.
Local _lupdte :=.f.
lOCAL _nReg   := 0

// TESTA VARIAS POSSIBILIDADE DE FILTRO
// 1 - Quando tem o pedido gravado na E/S massiva, filtra o pedido por ZZ4_CODPRO+D1_IDENTB6+ZZ4_IMEI
// 2 - Quando tem o pedido gravado na E/S massiva, filtra o pedido por D1_COD+D1_IDENTB6+ZZ4_IMEI
// 3 - Quando tem o pedido gravado na E/S massiva, filtra o pedido por ZZ4_CODPRO+D1_IDENTB6
// 4 - Quando tem o pedido gravado na E/S massiva, filtra o pedido por D1_COD+D1_IDENTB6
// 5 - Quando NAO tem o pedido gravado na E/S massiva, filtra o pedido por ZZ4_CODPRO+D1_IDENTB6+ZZ4_IMEI
// 6 - Quando NAO tem o pedido gravado na E/S massiva, filtra o pedido por D1_COD+D1_IDENTB6+ZZ4_IMEI
// 7 - Quando NAO tem o pedido gravado na E/S massiva, filtra o pedido por ZZ4_CODPRO+D1_IDENTB6
// 8 - Quando NAO tem o pedido gravado na E/S massiva, filtra o pedido por D1_COD+D1_IDENTB6

_nReg :=_nvezes
nconvzes:=_nvezes
Procregua(_nReg)


FOR X:= 1 TO _nvezes
	_nopcao:=X 
	nconvzes:=nconvzes-1
	
	IF _lselct
	   exit
	Endif
	
	While _nReg > nconvzes
		_nReg:=_nReg-1
		IncProc()
/*
		_cQry:= " SELECT * "+ ENTER
		_cQry+= " FROM "+ RetSqlName("ZZ4") + " ZZ4  "+ ENTER
		_cQry+= "    INNER JOIN "+ ENTER
		_cQry+= "     (SELECT C6_NUM,ZZ4_PV,C6_ITEM,C6_NOTA,ZZ4_NFENR,C6_SERIE,ZZ4_NFESER,C6_DATFAT,ZZ4_NFSDT,C6_NUMSERI,ZZ4_IMEI,C6_NUMOS,ZZ4_OS,RECZZ4 "+ ENTER
		_cQry+= "         FROM "+RetSqlName("SC6")+ ENTER
		_cQry+= "            INNER JOIN "+ ENTER
		_cQry+= "                (SELECT ZZ4_FILIAL,ZZ4_PV,ZZ4_STATUS,ZZ4_NFSNR,ZZ4_NFSSER,ZZ4_NFSDT,ZZ4_NFSHR,ZZ4_DOCDTS,ZZ4_DOCHRS,ZZ4_NFSTES,ZZ4_NFSCLI,ZZ4_NFSLOJ, "+ ENTER
		_cQry+= "                        ZZ4_CODPRO,ZZ4_IMEI,ZZ4_OS,ZZ4_NFENR,ZZ4_NFESER,R_E_C_N_O_ AS RECZZ4,D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_NUMSER,D1_IDENTB6,D1_ITEM  "+ ENTER
		_cQry+= "                    FROM "+ RetSqlName("ZZ4") +ENTER
		_cQry+= "                        INNER JOIN "+ ENTER
		_cQry+= "                            (SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_NUMSER,D1_IDENTB6,D1_ITEM  "+ ENTER
		_cQry+= "                                 FROM "+ RetSqlName("SD1") + ENTER
		_cQry+= "                                  WHERE D1_FILIAL='"+xFilial("SD1")+"'  "+ ENTER
		IF !EMPTY(MV_PAR05)
			_cQry+= "                               AND D1_NUMSER='"+MV_PAR05+"'  AND D_E_L_E_T_='' "+ ENTER
		ELSE
			_cQry+= "                               AND D_E_L_E_T_='' "+ ENTER
		ENDIF
		_cQry+= "                             ) AS SD1 "+ ENTER
		_cQry+= "                        ON ZZ4_FILIAL=D1_FILIAL AND ZZ4_NFENR=D1_DOC AND ZZ4_NFESER=D1_SERIE AND ZZ4_CODCLI=D1_FORNECE AND ZZ4_LOJA=D1_LOJA AND D1_ITEM=ZZ4_ITEMD1 "+ ENTER 
		_cQry+= "                    WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"' "+ENTER
		IF !EMPTY(MV_PAR05)
			_cQry+= "                       AND ZZ4_IMEI='"+MV_PAR05+"' "+ENTER
		ENDIF
		
		IF  X<=4
			_cQry+= "                       AND LEFT(ZZ4_PV,6)>='"+MV_PAR03+"' "+ ENTER
		ELSE
			_cQry+= "                       AND ZZ4_PV='' "+ ENTER
		ENDIF
		IF !EMPTY(MV_PAR04) .AND. X<=4
			_cQry+= "                       AND LEFT(ZZ4_PV,6)<='"+MV_PAR04+"' "+ ENTER
		ENDIF
		_cQry+= "                          AND D_E_L_E_T_='' "+ ENTER
		_cQry+= "                ) AS ZZ4 "+ ENTER
		_cQry+= "            ON C6_FILIAL=D1_FILIAL AND C6_NUM >='"+MV_PAR03+"' AND C6_NUM <='"+MV_PAR04+"' "+ENTER
		IF STRZERO(X,2) $ "01/05"
			_cQry+= "      AND C6_PRODUTO=ZZ4_CODPRO AND C6_IDENTB6=D1_IDENTB6 AND C6_NUMSERI=ZZ4_IMEI "+ ENTER
			
		ELSEIF STRZERO(X,2) $ "02/06"
			_cQry+= "      AND C6_PRODUTO=D1_COD AND C6_IDENTB6=D1_IDENTB6 AND C6_NUMSERI=ZZ4_IMEI  "+ ENTER
			
		ELSEIF STRZERO(X,2) $ "03/07"
			_cQry+= "      AND C6_PRODUTO=ZZ4_CODPRO AND C6_IDENTB6=D1_IDENTB6  "+ ENTER
			
		ELSEIF STRZERO(X,2) $ "04/08"
			_cQry+= "      AND C6_PRODUTO=D1_COD AND C6_IDENTB6=D1_IDENTB6  "+ ENTER
			
		ENDIF
		_cQry+= "         WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM >='"+MV_PAR03+"' AND C6_NUM <='"+MV_PAR04+"'   "+ENTER
		_cQry+= "         AND C6_DATFAT >='"+DTOS(MV_PAR01)+"' AND C6_DATFAT <='"+DTOS(MV_PAR02)+"' AND D_E_L_E_T_='' "+ENTER
		
		IF  STRZERO(X,2) $ "01/02/05/06" .AND. !EMPTY(MV_PAR05)
			_cQry+= "  AND  C6_NUMSERI='"+MV_PAR05+"' "+ENTER
		ENDIF
		
		_cQry+= "     ) AS SC61  "+ ENTER
		_cQry+= "    ON ZZ4.R_E_C_N_O_=SC61.RECZZ4 "+ ENTER
		_cQry+= "   WHERE ZZ4.ZZ4_FILIAL='"+xFilial("ZZ4")+"' "+ ENTER
		
		IF !EMPTY(MV_PAR05)
			_cQry+= "   AND ZZ4.ZZ4_IMEI='"+MV_PAR05+"' "+ ENTER
		ENDIF
		
		_cQry+= " AND ZZ4.D_E_L_E_T_='' "+ ENTER
		
*/

		_cSel:= " SELECT ZZ4.*, " +ENTER
		_cSel+= "        C6_NUM, ZZ4_PV, C6_ITEM, C6_NOTA, ZZ4_NFENR, C6_SERIE, ZZ4_NFESER, C6_DATFAT, ZZ4_NFSDT, C6_NUMSERI, " +ENTER
		_cSel+= "        ZZ4_IMEI, C6_NUMOS, ZZ4_OS, ZZ4.R_E_C_N_O_ AS RECZZ4 " +ENTER
		
		_cQry:= " FROM "+RetSqlName("ZZ4")+" AS ZZ4 " +ENTER
		
		_cQry+= " INNER JOIN "+RetSqlName("SD1")+" AS SD1 " +ENTER
		_cQry+= " ON ZZ4_FILIAL = D1_FILIAL AND ZZ4_NFENR = D1_DOC AND ZZ4_NFESER = D1_SERIE AND ZZ4_CODCLI = D1_FORNECE AND " +ENTER
		_cQry+= "    ZZ4_LOJA = D1_LOJA AND D1_ITEM = ZZ4_ITEMD1 AND SD1.D_E_L_E_T_ = '' " +ENTER
		
		_cQry+= " INNER JOIN "+RetSqlName("SC6")+" AS SC6 " +ENTER
		_cQry+= " ON C6_FILIAL = D1_FILIAL AND C6_NUM >= '"+MV_PAR03+"' AND C6_NUM <= '"+MV_PAR04+"' " +ENTER
		_cQry+= "    AND C6_DATFAT >= '"+DTOS(MV_PAR01)+"' AND C6_DATFAT <= '"+DTOS(MV_PAR02)+"' AND SC6.D_E_L_E_T_= '' " +ENTER
		IF STRZERO(X,2) $ "01/02/05/06" .AND. !EMPTY(MV_PAR05)
		   _cQry+= " AND C6_NUMSERI = '"+MV_PAR05+"'  " +ENTER
		ENDIF
		IF STRZERO(X,2) $ "01/05"
		   _cQry+= " AND C6_PRODUTO = ZZ4_CODPRO AND C6_IDENTB6 = D1_IDENTB6 AND C6_NUMSERI = ZZ4_IMEI " +ENTER
		ELSEIF STRZERO(X,2) $ "02/06"
		   _cQry+= " AND C6_PRODUTO = D1_COD AND C6_IDENTB6 = D1_IDENTB6 AND C6_NUMSERI = ZZ4_IMEI " +ENTER
		ELSEIF STRZERO(X,2) $ "03/07"
		   _cQry+= " AND C6_PRODUTO = ZZ4_CODPRO AND C6_IDENTB6 = D1_IDENTB6 " +ENTER
		ELSEIF STRZERO(X,2) $ "04/08"
		   _cQry+= " AND C6_PRODUTO = D1_COD AND C6_IDENTB6 = D1_IDENTB6 " +ENTER
		ENDIF
		_cQry+= " WHERE ZZ4_FILIAL = '"+XFILIAL("ZZ4")+"' " +ENTER
		_cQry+= "       AND ZZ4.D_E_L_E_T_='' " +ENTER
		If !empty(MV_PAR05)
			_cQry+= " 	     AND ZZ4_IMEI = '"+mv_par05+"' " +ENTER
		EndIf
		IF X <= 4
			_cQry+= " 	     AND LEFT(ZZ4_PV,6) >= '"+MV_PAR03+"' " +ENTER
		ELSE
			_cQry+= " 	     AND ZZ4_PV = ''  " +ENTER
		ENDIF
		IF !EMPTY(MV_PAR04) .AND. X<=4
			_cQry+= " 	     AND LEFT(ZZ4_PV,6) <= '"+MV_PAR04+"' " +ENTER
		ENDIF
		

		MemoWrite(__reldir + "Sel_RegESMas.sql", _cSel+_cQry)
		if select("QRY") > 0
			QRY->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", TCGenQry(,, _cSel+_cQry), "QRY", .F., .T.)
		
		
		If Select("QRY") > 0  .AND. !EMPTY(QRY->C6_NUM+QRY->C6_ITEM)
			_lselct :=.t.
			Exit
		Endif
		QRY->(dbCloseArea())
		
	Enddo
	
Next

If _lselct
	_cQryExec := "UPDATE " + RetSqlName("ZZ4") + ENTER
	_cQryExec += "SET ZZ4_PV=RTRIM(C6_NUM)+RTRIM(C6_ITEM),ZZ4_STATUS=CASE WHEN C6_NOTA='' THEN '8' ELSE '9' END  "+ ENTER
//	_cQryExec += SUBSTR(_cQry,12)
	_cQryExec += _cQry
	
	MemoWrite(__reldir+"Upd_RegESMas.sql", _cQryExec)
	TcSQlExec(_cQryExec)
	TCRefresh(RETSQLNAME("ZZ4"))
	
    If  TCSQLExec(_cQryExec) < 0 
         ALERT(TCSQLError())
    Elseif TCSQLExec(_cQryExec) = 0
         _lupdte:=.f.
    
    Elseif  TCSQLExec(_cQryExec) > 0
       _lupdte:=.t.
    Endif

	
	
	
Endif

If  _nReg > 0
	while _nReg > 0
		IncProc()
		_nReg:=_nReg-1
	Enddo
Endif


Return(_lupdte)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREGESM02  บ Autor ณEdson Rodrigues     บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFAZ FILTRO E ATUALIZA A ENTRADA / SAIDA MASSIVA             บฑฑ
ฑฑบ          ณCOM DADOS FALTANTE OU DIERENTE                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ REGEMAS.PRW                                                บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION REGESM02()
_nopcao :=0
_nvezes :=2
_lselct :=.f.
_lupdte :=.f.
_nReg    := _nvezes
nconvzes := _nvezes

Procregua(_nReg)


If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf



FOR X:= 1 TO _nvezes
	_nopcao:=X
	nconvzes:=nconvzes-1
	
	
	While  _nReg > nconvzes
		_nReg:=_nReg-1
		IncProc()
		
		
		_cQry:= " SELECT * "+ ENTER
		_cQry+= "	FROM "+ RetSqlName("ZZ4")+ " (nolock) "+ ENTER
		_cQry+= "      INNER JOIN "+ ENTER
		_cQry+= "         (SELECT D2_FILIAL,D2_PEDIDO,D2_NUMSERI,D2_ITEMPV,D2_CLIENTE,D2_LOJA,F2_SAIROMA,F2_HSAIROM,D2_DOC,D2_SERIE,D2_TES,F2_EMISSAO,F2_HORA "+ ENTER
		_cQry+= "               FROM "+ RetSqlName("SD2")+ " D2 (nolock)  "+ ENTER
		_cQry+= "                    INNER JOIN "+ RetSqlName("SF2")+ " F2 (nolock) "+ ENTER
		_cQry+= "                          ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND F2_SERIE=D2_SERIE "+ ENTER
		_cQry+= "               WHERE D2.D_E_L_E_T_='' AND F2.D_E_L_E_T_='' AND D2_FILIAL='"+xFilial("SD2")+"' AND F2_FILIAL='"+xFilial("SF2")+"' "+ ENTER
		If x=1
			_cQry+= "                     AND F2_SAIROMA<>'' "+ ENTER
		Else
			_cQry+= "                     AND F2_SAIROMA='' "+ ENTER
		endif
		_cQry+= "          ) AS SF2  "+ ENTER
		_cQry+= "       ON ZZ4_FILIAL=D2_FILIAL AND LEFT(ZZ4_PV,6)=LEFT(D2_PEDIDO,6) AND substring(ZZ4_PV,7,2)=left(D2_ITEMPV,2) "+ ENTER
		_cQry+= "    WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"'  AND D_E_L_E_T_='' AND ZZ4_PV<>'' AND "+ ENTER
		_cQry+= "          ((ZZ4_NFSNR<>D2_DOC OR  ZZ4_NFSSER<>D2_SERIE OR  "+ ENTER
		_cQry+= "    		  ZZ4_NFSDT<>F2_EMISSAO OR
		If x=1
			_cQry+= "              ZZ4_DOCDTS<>F2_SAIROMA OR  "+ ENTER
		Endif
		_cQry+= "		      ZZ4_NFSTES<>D2_TES OR ZZ4_NFSCLI<>D2_CLIENTE OR ZZ4_NFSLOJ<>D2_LOJA)  OR "+ ENTER
		_cQry+= "		      (ZZ4_STATUS<>'9' OR ZZ4_NFSNR='' OR  ZZ4_NFSDT='' OR ZZ4_NFSHR='' OR "+ ENTER
		_cQry+= "               ZZ4_NFSTES = '' OR ZZ4_NFSCLI='' OR ZZ4_NFSLOJ=''))  "+ ENTER
		
		
		
		MemoWrite("Sel_RegESMa2.sql", _cQry)
		dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
		
		
		If Select("QRY") >  0 .AND. !EMPTY(QRY->D2_PEDIDO+QRY->D1_ITEMPV)
			_lselct:=.t.
	    Endif
		QRY->(dbCloseArea())
		
		
		If _lselct
			_cQryExec:= "  UPDATE "+ RetSqlName("ZZ4")+ " SET ZZ4_NFSNR  = CASE WHEN (ZZ4_NFSNR='' OR ZZ4_NFSNR<>D2_DOC) THEN D2_DOC ELSE ZZ4_NFSNR END,
			_cQryExec+= "	                ZZ4_NFSSER = CASE WHEN (ZZ4_NFSSER='' OR ZZ4_NFSSER<>D2_SERIE) THEN D2_SERIE ELSE ZZ4_NFSSER END,
			_cQryExec+= "	                ZZ4_NFSDT  = CASE WHEN (ZZ4_NFSDT=''  OR ZZ4_NFSDT<>F2_EMISSAO)  THEN F2_EMISSAO ELSE ZZ4_NFSDT END,
			_cQryExec+= "                    ZZ4_NFSHR  = CASE WHEN  ZZ4_NFSHR=''  THEN F2_HORA ELSE ZZ4_NFSHR END,
			If _nopcao==1
				_cQryExec+= "   	            ZZ4_DOCDTS = CASE WHEN (ZZ4_DOCDTS='' OR ZZ4_DOCDTS<>F2_SAIROMA)   THEN F2_SAIROMA ELSE ZZ4_DOCDTS END,
				_cQryExec+= "	                ZZ4_DOCHRS = CASE WHEN  ZZ4_DOCHRS='' THEN F2_HSAIROM ELSE ZZ4_DOCHRS END,
			Else
				_cQryExec+= "                 ZZ4_DOCDTS = CASE WHEN  ZZ4_DOCDTS='' THEN F2_SAIROMA ELSE ZZ4_DOCDTS END,
				_cQryExec+= "		            ZZ4_DOCHRS = CASE WHEN  ZZ4_DOCHRS='' THEN F2_HSAIROM ELSE ZZ4_DOCHRS END,
			Endif
			_cQryExec+= "		                 ZZ4_NFSTES = CASE WHEN (ZZ4_NFSTES='' OR ZZ4_NFSTES<>D2_TES) THEN D2_TES ELSE ZZ4_NFSTES END,
			_cQryExec+= "	                     ZZ4_NFSCLI = CASE WHEN (ZZ4_NFSCLI='' OR ZZ4_NFSCLI<>D2_CLIENTE) THEN D2_CLIENTE ELSE ZZ4_NFSCLI END,
			_cQryExec+= "		                 ZZ4_NFSLOJ = CASE WHEN (ZZ4_NFSLOJ='' OR ZZ4_NFSLOJ<>D2_LOJA) THEN D2_LOJA ELSE ZZ4_NFSLOJ END,
			_cQryExec+= "                         ZZ4_STATUS = CASE WHEN ZZ4_STATUS<>'9' THEN '9' ELSE ZZ4_STATUS END
			_cQryExec+= SUBSTR(_cQry,12)
			
			MemoWrite("Upd_RegESMa2.sql", _cQryExec)
			TcSQlExec(_cQryExec)
			TCRefresh(RETSQLNAME("ZZ4"))
        
        	If  TCSQLExec(_cQryExec) < 0 
                 ALERT(TCSQLError())
            Elseif TCSQLExec(_cQryExec) = 0
                _lupdte:=.f.
    
            Elseif  TCSQLExec(_cQryExec) > 0
               _lupdte:=.t.
            Endif

		Endif
		
	Enddo
	
Next


RETURN (_lupdte)
