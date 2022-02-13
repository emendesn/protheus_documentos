#INCLUDE "RWMAKE.CH" 
/*
*Programa: ValDivNeg 
*Autor	 : Edson Rodrigues 
*Data 	 : 20/04/09  
*Desc.   : Valida/Bloqueia Divis�es de Neg�cios                      
*/
User Function ValDivNeg(_cdivneg,cTab)

	Local _lret := .t.
	
	IF !_cdivneg $ GetMv("ZZ_DIVNEGA") //"02/05/08/10/11" Alterado: Thomas Galv�o 14/02/2013 - GLPI 11005
	    MsgAlert("Essa divis�o de Neg�cio est� desabilitada","Atencao")
		_lRet := .F.
	ENDIF
	// PARA DIVISAO 14 E OBRIGADO A DIGITAR TABELA DE PRECOS ENTAO FORCAMOS UM CODIGO DE TABELA - CLAUDIA 11/05/2009
	If _lret .and.  _cdivneg $ "14" .and. FUNNAME() = 'MATA410' 
		If Empty(cTab)
			cTab := "ZZZ"
		Endif	
		M->C5_TABELA := cTab
	EndIf

Return(_lret)