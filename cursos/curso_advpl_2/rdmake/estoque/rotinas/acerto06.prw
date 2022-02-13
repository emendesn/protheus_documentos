#INCLUDE "protheus.ch"

USER FUNCTION ACERTO06()
    
Local cQry   := ""
Local aTexto := {}
Local cResul := ""

u_GerA0003(ProcName())


msginfo("ACERTO06")

cQry := "     SELECT	'SA2 - FORNECEDOR' CADASTRO, '020' COD_ERR,'ENDEREÇO COM N°' OCORRENCIA, A2_COD, A2_LOJA, A2_NOME, A2_END, A2_BAIRRO, A2_MUN, A2_CEP, A2_EST ,'' , '', '', '', A2_INSCR INS_EST, A2_COD_MUN COD_MUN, A2_CGC CGC, R_E_C_N_O_ " +CRLF
cQry += "     FROM   SA2020 " +CRLF
cQry += "     WHERE  A2_END LIKE '%N°%' AND D_E_L_E_T_ <> '*'   AND A2_MSBLQL <> 1 " +CRLF
                                       
MEMOWRITE("d:\QRY01.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	aTexto := separa(TRB->A2_END,"N°")
	For nI := 1 to len(aTexto) 
		If nI == 1
			cResul := aTexto[nI]+" "
		Else
			cResul += aTexto[nI]
		Endif	                   
	Next nI
	dbselectarea("SA2")
	SA2->(dbsetorder(1))
	SA2->(dbseek("  "+TRB->A2_COD+TRB->A2_LOJA))	
	Reclock("SA2",.F.)
	A2_END := cResul
	SA2->(Msunlock())
    TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(dbCloseArea())     

cQry := "     SELECT	'SA2 - FORNECEDOR' CADASTRO, '020' COD_ERR,'ENDEREÇO COM N°' OCORRENCIA, A2_COD, A2_LOJA, A2_NOME, A2_END, A2_BAIRRO, A2_MUN, A2_CEP, A2_EST ,'' , '', '', '', A2_INSCR INS_EST, A2_COD_MUN COD_MUN, A2_CGC CGC, R_E_C_N_O_ " +CRLF
cQry += "   FROM   SA2020 " +CRLF
cQry += "   WHERE  A2_END LIKE '% N,%' AND D_E_L_E_T_ <> '*'  AND A2_MSBLQL <> 1 " +CRLF

MEMOWRITE("d:\QRY01.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	aTexto := separa(TRB->A2_END,"N,")
	For nI := 1 to len(aTexto) 
		If nI == 1
			cResul := aTexto[nI]+" "
		Else
			cResul += aTexto[nI]
		Endif	                   
	Next nI
	dbselectarea("SA2")
	SA2->(dbsetorder(1))
	SA2->(dbseek("  "+TRB->A2_COD+TRB->A2_LOJA))	
	Reclock("SA2",.F.)
	A2_END := cResul
	SA2->(Msunlock())
    TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(dbCloseArea())     

cQry := "     SELECT	'SA2 - FORNECEDOR' CADASTRO, '020' COD_ERR,'ENDEREÇO COM N°' OCORRENCIA, A2_COD, A2_LOJA, A2_NOME, A2_END, A2_BAIRRO, A2_MUN, A2_CEP, A2_EST ,'' , '', '', '', A2_INSCR INS_EST, A2_COD_MUN COD_MUN, A2_CGC CGC, R_E_C_N_O_ " +CRLF
cQry += "   FROM   SA2020 " +CRLF
cQry += "   WHERE  A2_END LIKE '%N.%' AND D_E_L_E_T_ <> '*'  AND A2_MSBLQL <> 1 " +CRLF

MEMOWRITE("d:\QRY01.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	aTexto := separa(TRB->A2_END,"N.")
	For nI := 1 to len(aTexto) 
		If nI == 1
			cResul := aTexto[nI]+" "
		Else
			cResul += aTexto[nI]
		Endif	                   
	Next nI
	dbselectarea("SA2")
	SA2->(dbsetorder(1))
	SA2->(dbseek("  "+TRB->A2_COD+TRB->A2_LOJA))	
	Reclock("SA2",.F.)
	A2_END := cResul
	SA2->(Msunlock())
    TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(dbCloseArea())    
      
msginfo("ACERTO06")

RETURN