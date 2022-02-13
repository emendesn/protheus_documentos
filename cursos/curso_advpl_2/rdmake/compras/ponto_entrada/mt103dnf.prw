/**
 * Rotina		:	PE Mt103Dnf - Valida��es C�digo de Acesso 
 * Autor		:	Thomas Quintino Galv�o
 * Data			:	13/07/2012	
  * Uso			:	SIGACOM
 * Descricao	:	Valida��o de Cadastro de Produtos por Grupo de Usu�rios
 */  
#Include "Totvs.ch"
User Function Mt103Dnf
	Local lRet   	:= .T.
	Local _cNFiscal := ''
	Local _cSerie 	:= ''
	Local cParam 	:= ParamixB[1][13]

	u_GerA0003(ProcName())
	
	If TRIM(M->CFORMUL) == "N" .AND. TRIM(M->CESPECIE) == "SPED"
		If Empty(cParam)  
			MsgAlert("NFE do tipo SPED deve ter Chave de Acesso Obrigat�riamente!")
			lRet:= .F.				
		Else 
			_cNFiscal := StrZero(Val(cnFiscal),9)
			_cSerie	  := StrZero(Val(cSerie),3)
			IF SubStr(cParam,23,12) != _cSerie+_cNFiscal
				MsgAlert("Numero da NFE n�o bate com a Chave de Acesso, verifique!") 
				lRet := .F.			
			EndIf		
		EndIf
	EndIf
Return lRet