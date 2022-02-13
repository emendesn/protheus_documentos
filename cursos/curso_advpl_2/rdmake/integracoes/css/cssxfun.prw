
// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : CssxFun
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/01/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
User Function ACMAILJB(cEvento,cMen,cRotina,lValData)
Local cEmail	:= ""

Default lValData := .T.

Prepare Environment Empresa "02" Filial "02"

cEmail	:= GetMv("ES_CSSMLOG",,"rogerapl@gmail.com;edson.rodrigues@bgh.com.br")

cMensagem := "<html>"
cMensagem += "<head>"
cMensagem += " <title>"+cRotina+"</title>"
cMensagem += "</head>"
cMensagem += "<body>"
cMensagem += " <br>"
cMensagem += " Aviso de Eventos do Scheduler."
cMensagem += " <br>"
cMensagem += " <br>"
cMensagem += " Evento: "+cRotina+" -> "+cEvento
cMensagem += " <br>"
cMensagem += " Mensagem: "+cMen
cMensagem += " <br>"
cMensagem += " Hora: "+Dtoc(ddatabase)+" "+time()
cMensagem += "</body>"
cMensagem += "</html>"
   

U_ENVIAEMAIL(cRotina+"->"+cEvento,cEmail,"",cMensagem,"")

Return






//-- Cria semaforo para execucao de rotinas via Scheduller
User Function SemafWKF(cRotina, nHdlSemaf, lCria)

Local lRET := .T.
                     
Default nHdlSemaf := 0                                                  
Default lCria     := .T.

If lCria
	nHdlSemaf := MSFCreate(cRotina+".LCK")
	IF nHdlSemaf < 0                           
		lRet := .F.
	Endif       
Else
	If File(cRotina+".LCK")
		FClose(nHdlSemaf)
		lRET := .T.
	EndIf
EndIf


Return lRET




//Função Generica de sequencia de utilização de armazens
//ROGER LIMA ERPWORKS 16-09-2014
User Function GetArmPP(cProduto,nQuant)
Local lTemSaldo := .F.
Local aSeqArmz      := &(GetMv("ES_SEQCONS",,"{'01'}"))
Local nX
Local cLocal := ""
Local cQuery
Local cLoteCtl := ""
Local cNumLote := ""
Local nSaldo := 0
/*
cQuery := " SELECT B8_LOCAL,B8_LOTECTL,B8_NUMLOTE,B8_SALDO,B8_EMPENHO FROM "+RetSqlName("SB8")+ " SB8 "
cQuery += " INNER JOIN "+RetSqlName("SB2")+" SB2 ON SB2.D_E_L_E_T_=' ' AND B2_FILIAL = B8_FILIAL AND B2_COD = B8_PRODUTO AND B2_LOCAL = B8_LOCAL "
cQuery += " WHERE SB8.D_E_L_E_T_=' ' AND B8_PRODUTO = '"+cProduto+"' AND B8_FILIAL = '"+xFilial("SB8")+"' "
cQuery += " AND B8_SALDO - B8_EMPENHO > 0 AND B8_LOCAL IN ('PP','PI','IP','PS') AND B2_QATU - B2_QEMP - B2_RESERVA - B2_QACLASS > 0"
cQuery += " ORDER BY B8_DATA "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QUERYSB8",.F.,.T.)

if !QUERYSB8->(Eof())
 	cLocal := QUERYSB8->B8_LOCAL
 	cLoteCtl := QUERYSB8->B8_LOTECTL
	cNumLote := QUERYSB8->B8_NUMLOTE
 	nSaldo := QUERYSB8->(B8_SALDO - B8_EMPENHO)
	lTemSaldo := .T.

Endif
QUERYSB8->(DbCloseArea())

*/

dbSelectarea("SB2")
SB2->(DbsetOrder(1))
For nX := 1 to Len(aSeqArmz)
   If(SB2->(Dbseek(xFilial("SB2")+cProduto+aSeqArmz[nX])))
	  nSaldoSB2 := SB2->B2_QATU - ( SB2->B2_QEMP  + SB2->B2_RESERVA) // Verifica se tem saldo disponivel no armazem antigo
	  // If nSaldoSB2 >= 0  Alterado a condicao do IF, pois o saldo tem que ser maior que 0. Edson Rodrigues 06-04-15
	  If nSaldoSB2 > 0
		 cLocal := aSeqArmz[nX]
		 lTemSaldo := .T.
		 nSaldo := nSaldoSB2
		 Exit
	  Endif
   Endif
Next nX	

Return {lTemSaldo,cLocal,aSeqArmz,cLoteCtl,cNumLote,nSaldo}



  
  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³GRAVALINHAº Autor ³ José Romeiro       º Data ³  13/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para gravar a linha no arquivo texto                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GravaLinha(cLinha,nTamLinha)

Local cLin := "" , nTamLinha := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ³
//³ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ³
//³ string dentro de outra string.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLin := Space(nTamLinha)+cEOL // Variavel para criacao da linha do registros para gravacao
cLin := Stuff(cLin,01,nTamLinha,cLinha)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
//³ linha montada.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return .F.
	Endif
Endif

Return .T.



  