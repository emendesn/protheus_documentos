#INCLUDE "VKEY.CH"
User Function IniTab(cDiv,cTab)
/* Funcao Inicializador da Tabela de Preco do Pedido de Venda 
porque a primeira validacao do usuario do Protheus nao funciona, fui obrigada a forcar
a validacao */
Local lRet := .t.            

u_GerA0003(ProcName())

//SetKey(VK_ESC ,{|| U_VALCPO()})
If cDiv $ "14" // PARA DIVISAO 14 E OBRIGADO A DIGITAR TABELA DE PRECOS ENTAO FORCAMOS UM CODIGO DE TABELA - CLAUDIA 11/05/2009
	If Empty(cTab)
		cTab := "ZZZ"
	Endif	
	M->C5_TABELA := cTab
Else
	lRet := .t.
EndIf


Return lRet

User Function ValidTab(cDiv,CTab)
/* Funcao de Validacao da Tabela de Preco digitada no Pedido de Venda */
Local lRet := .t.
If cDiv $ "14"
	If Empty(cTab)
		MsgAlert("Tabela de Preco Obrigatoria para essa Divisao de Negocio","Atencao")
		lRet := .F.
	Endif	
Else
	lRet := .t.
EndIf


Return lRet          

USER FUNCTION VALCPO() 
LOCAL cTab := ''
If M->C5_DIVNEG $ "14"
	If Empty(M->C5_TABELA)
		cTab := "ZZZ"   
		M->C5_TABELA := cTab
	Endif	
ENDIF	
RETURN .T.