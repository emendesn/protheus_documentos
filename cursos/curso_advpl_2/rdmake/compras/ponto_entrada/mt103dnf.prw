/**
 * Rotina		:	PE Mt103Dnf - Validações Código de Acesso 
 * Autor		:	Thomas Quintino Galvão
 * Data			:	13/07/2012	
  * Uso			:	SIGACOM
 * Descricao	:	Validação de Cadastro de Produtos por Grupo de Usuários
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
			MsgAlert("NFE do tipo SPED deve ter Chave de Acesso Obrigatóriamente!")
			lRet:= .F.				
		Else 
			_cNFiscal := StrZero(Val(cnFiscal),9)
			_cSerie	  := StrZero(Val(cSerie),3)
			IF SubStr(cParam,23,12) != _cSerie+_cNFiscal
				MsgAlert("Numero da NFE não bate com a Chave de Acesso, verifique!") 
				lRet := .F.			
			EndIf		
		EndIf
	EndIf
Return lRet