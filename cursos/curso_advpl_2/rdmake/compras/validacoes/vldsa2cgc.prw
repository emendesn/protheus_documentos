#Include "Totvs.ch"

/*
*Programa: VldSA2CGC 
*Autor	 : Thomas Quintino Galv�o 
*Data 	 : 07/10/12   
*Desc.   : Valida��o do Campo A2_CGC - GLPI ID 7211                       
*		 : N�o permite incluir cadastro de Fornecedor com CPF/CNPJ duplicado
*/
User Function VldSA2CGC
	Local aAreaSA2 	:= SA2->(GetArea())
	Local lRet 		:= .T.
	Local cMsg 		:= ""   

u_GerA0003(ProcName())
    
    &&Valida��o anterior do campo A2_CGC
    &&Iif (Empty(M->A2_CGC).And. !(M->A2_TIPO $ "X"), (MsgAlert("Favor Verificar o Campo CGC esta Vazio!"),.F.),.T.)                  
    
	&&Valida��o CPF/CGC/CNP
 	dbSelectArea("SA2")
 	SA2->(dbSetOrder(3))
 	If Empty(M->A2_CGC).And. !(M->A2_TIPO $ "X")
 		cMsg += "Favor Verificar o Campo CGC esta Vazio"
 		lRet := .F.
 	ElseIf !Empty(M->A2_CGC)
 		If SA2->(DbSeek(xFilial("SA2")+M->A2_CGC))
			If M->A2_TIPO $ 'F'
				cTipo := "CPF"
			Else
				cTipo := "CNPJ/CGC" 
			EndIf
			cMsg += cTipo+" j� cadastrado"			 
			lRet := .F.   
		EndIf
	EndIf
	
	&&Mensagem
	IIF(!lRet, Aviso("Valida��o de Campo", cMsg,{'OK'}),)	 
	    
	SA2->(RestArea(aAreaSA2))
Return lRet