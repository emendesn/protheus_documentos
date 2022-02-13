#Include "Totvs.ch"

/*
*Programa: VldSA1CGC 
*Autor	 : Thomas Quintino Galv�o 
*Data 	 : 07/10/12   
*Desc.   : Valida��o do Campo A1_CGC - GLPI ID 7211                       
*		 : N�o permite incluir cadastro de cliente caso CPF j� esteja cadastrado   
*/
User Function VldSA1CGC
	Local aAreaSA1 	:= SA1->(GetArea())
	Local lRet 		:= .T.
	Local cMsg 		:= ""

u_GerA0003(ProcName())
    
	&&Valida��o Campo DDD e Telefone 
	If Empty(M->A1_TEL).And. !(M->A1_TIPO $ "X")
		cMsg += "Favor Verificar o Campo DDD e Telefone"+CRLF
		lRet := .F. 
	EndIf
   
	&&Valida��o CPF/CGC/CNP
 	dbSelectArea("SA1")
 	SA1->(dbSetOrder(3))
 	If !Empty(M->A1_CGC)
		If SA1->(DbSeek(xFilial("SA1")+M->A1_CGC))
			IIf (M->A1_PESSOA == 'F', cTipo := "CPF ",cTipo := "CNPJ/CGC ")
			cMsg += cTipo+Transform(SA1->A1_CGC,IIF(SA1->A1_PESSOA == 'F','@R 999.999.999-99','@R 99.999.999/9999-99'))+ ;
					" j� cadastrado para o cliente "+SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+SA1->A1_NOME 			 
			lRet := .F.
		EndIf
	EndIf
	
	&&Mensagem
	IIF(!lRet, Aviso("Valida��o de Campo", cMsg,{'OK'}),)	 
	    
	SA1->(RestArea(aAreaSA1))
Return lRet