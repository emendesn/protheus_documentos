#INCLUDE "protheus.ch"

USER FUNCTION ACERTO04()
    
Local cQry   := ""
Local aTexto := {}
Local cResul := ""

u_GerA0003(ProcName())

msginfo("ACERTO04")

cQry := "   SELECT	'SA2 - FORNECEDOR' CADASTRO, '106' COD_ERR,'LOGRADOURO ERRADO' OCORRENCIA, A2_COD ,A2_LOJA , A2_NOME NOME , A2_END , A2_BAIRRO BAIRRO,A2_MUN MUNICIPIO,  A2_CEP CEP, A2_EST UF, '' , '', '', '', A2_INSCR INS_EST, A2_COD_MUN COD_MUN, A2_CGC CGC, R_E_C_N_O_ " +CRLF
cQry += "   FROM   SA2020 " +CRLF
cQry += "   WHERE  LEN(A2_CEP) = 8 AND  " +CRLF
cQry += "          A2_END LIKE '%:%'    " +CRLF
cQry += "   AND D_E_L_E_T_ <> '*'  " +CRLF

MEMOWRITE("d:\QRY01.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	aTexto := separa(TRB->A2_END,":")
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
      
msginfo("ACERTO04")

RETURN