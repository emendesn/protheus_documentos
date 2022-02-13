#Include "PROTHEUS.CH"
#include 'topconn.ch'

User Function MT416FIM() 
/* Ponto de Entrada  no Final do orcamento pra gravacao dos campos customizados do orcamento no Pedido de Venda */  
Local cQuery :="" 

u_GerA0003(ProcName())

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif    
cQuery := " SELECT DISTINCT C6_FILIAL,C6_NUM   "
cQuery += " FROM " + RetSqlName("SC6") + " SC6 (NOLOCK) "
cQuery += " WHERE  SC6.D_E_L_E_T_ = ' '  "
cQuery += " AND  SC6.C6_FILIAL = '" + SCJ->CJ_FILIAL +  "' " 
cQuery += " AND  SUBSTRING(SC6.C6_NUMORC,1,6) = '" + SCJ->CJ_NUM + "' "
TCQUERY cQuery NEW ALIAS "QRY1"
SC5->(DBSETORDER(1)) 
QRY1->(DBGOTOP())
WHILE !QRY1->(EOF())
	IF SC5->(DBSEEK(QRY1->C6_FILIAL + QRY1->C6_NUM))	
		RecLock('SC5',.F.)
		SC5->C5_TIPOCLI := SCJ->CJ_XTPCLI
		SC5->C5_TRANSP  := SCJ->CJ_XTRANS      
		SC5->C5_TPFRETE := SCJ->CJ_TPFRETE
		SC5->C5_TXMOEDA := SCJ->CJ_TXMOEDA
		MsUnlock()
	ENDIF
	QRY1->(DBSKIP())
EndDo
IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif    

Return                                 

/*----------------------------------------------*/
User Function XUPOCLI(cCli,cLoja,ctipo)
/* Funcao para atualizar o tipo do cliente de acordo com o tipo do cliente escolhido no orcamento de venda
necessario fazer isso, pois do contrario o calculo dos impostos do orcamento e feito incorreto, pois o calculo
baseia-se no tipo do cliente.
Essa funcao eh chamada da validacao do campo CJ_XTPCLI - CADASTRO DO ORCAMENTO*/
SA1->(DbSetOrder(1))
If SA1->(DbSeeK(Xfilial('SA1') + cCli + cLoja))
	Reclock('SA1',.F.)
	SA1->A1_TIPO := cTipo
	MsUnlock()
Endif	
Return .T.