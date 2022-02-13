#include "protheus.ch"
USER FUNCTION CT105TOK()
/* VALIDACAO DA EXCLUSAO DO LANCAMENTO CONTABIL - NAO DEIXA EXCLUIR NO AMBIENTE FINANCEIRO
CLAUDIA 30/04/09*/
LOCAL nvaldeb    := PARAMIXB[1]
Local nValcre    := PARAMIXB[2]
Local ntotrodape := PARAMIXB[3]
Local nTotinf    := PARAMIXB[4]
Local nRecTMP    := TMP->(Recno())
Local cMens      := space(50)
Local lRet       := .t.
Local _lretvcc   := .t.

u_GerA0003(ProcName())

IF nmodulo = 6 // nao validar para outros modulos que não sejam financeiro
	TMP->(dbGoTop())
	While TMP->(!Eof())
		If TMP->CT2_FLAG // registro foi deletado                             
			cMens := "Nao e permitido excluir o lancamento ! "
			lRet := .f.
			Exit
		endif
		
		
		//Incluso Edson Rodrigues para validar Centro de custo digitado
        _lretvcc:= u_valccust(1)   
        IF !_lretvcc
           cMens := "Centro de Custo digitado Invalido ! "
		   lRet := .f.
		   Exit
        Endif		
		TMP->(DbSkip())
	endDo              
	TMP->(MsGoTo(nRecTMP))
	If nValDeb <> nValCre .or. ntotrodape <> ntotinf 
		If Empty(Alltrim(cMens))
			cMens := "Valores divergentes!"
		Else 
			cMens += "Valores divergentes!"
		Endif                              
		lRet := .f.
	Endif 		
endif	        
If ! lRet
	Alert(cMens)
EndIf


return lRet