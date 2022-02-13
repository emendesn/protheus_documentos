#INCLUDE "protheus.ch"

USER FUNCTION ACERTO03()
    
Local cQry   := ""
Local aTexto := {}
Local cResul := ""

u_GerA0003(ProcName())

msginfo("INICIO - ACERTO03")

cQry := "      SELECT	'SA1 - CLIENTE' CADASTRO, '106' COD_ERR,'LOGRADOURO ERRADO' OCORRENCIA, A1_COD ,A1_LOJA , A1_NOME NOME , A1_END , A1_BAIRRO BAIRRO,A1_MUN MUNICIPIO,  A1_CEP CEP, A1_EST UF, A1_ENDCOB , A1_CEPC CEP_COBRANÇA, A1_ENDENT , A1_CEPE CEP_ENTREGA, A1_INSCR INS_EST, A1_COD_MUN COD_MUN, A1_CGC CGC, R_E_C_N_O_ " +CRLF
cQry += "    FROM   SA1020 (NOLOCK) " +CRLF
cQry += "    WHERE  LEN(A1_CEP) = 8 AND  " +CRLF
cQry += "       A1_END LIKE 'R:%'  OR A1_END LIKE 'R,%' OR A1_END LIKE 'RUA:%' OR A1_END LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_END LIKE 'AV:%'  OR A1_END LIKE 'AV,%' OR A1_END LIKE 'AVENIDA:%' OR A1_END LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_END LIKE 'TRAV:%'  OR A1_END LIKE 'TRAV,%' OR A1_END LIKE 'TRAVESSA:%' OR A1_END LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_END LIKE 'DR:%'  OR A1_END LIKE 'DR,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE ',%' OR A1_ENDCOB LIKE 'R,%' OR A1_ENDCOB LIKE 'RUA:%' OR A1_ENDCOB LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'AV:%'  OR A1_ENDCOB LIKE 'AV,%' OR A1_ENDCOB LIKE 'AVENIDA:%' OR A1_ENDCOB LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'TRAV:%'  OR A1_ENDCOB LIKE 'TRAV,%' OR A1_ENDCOB LIKE 'TRAVESSA:%' OR A1_ENDCOB LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'DR:%'  OR A1_ENDCOB LIKE 'DR,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE ',%' OR A1_ENDENT LIKE 'R,%' OR A1_ENDENT LIKE 'RUA:%' OR A1_ENDENT LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'AV:%'  OR A1_ENDENT LIKE 'AV,%' OR A1_ENDENT LIKE 'AVENIDA:%' OR A1_ENDENT LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'TRAV:%'  OR A1_ENDENT LIKE 'TRAV,%' OR A1_ENDENT LIKE 'TRAVESSA:%' OR A1_ENDENT LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'DR:%'  OR A1_ENDENT LIKE 'DR,%'   " +CRLF
cQry += "  AND D_E_L_E_T_ <> '*'  AND A1_MSBLQL <> 1 " +CRLF


MEMOWRITE("d:\ACERTO0301.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	aTexto := separa(TRB->A1_END,":")
	For nI := 1 to len(aTexto) 
		If nI == 1
			cResul := aTexto[nI]+" "
		Else
			cResul += aTexto[nI]
		Endif	                   
	Next nI
	aArea := getArea()
	dbselectarea("SA1")
	SA1->(dbsetorder(1))
	SA1->(dbseek("  "+TRB->A1_COD+TRB->A1_LOJA))	
	Reclock("SA1",.F.)
	A1_END := cResul
	SA1->(Msunlock())
	RestArea(aArea)
    TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(dbCloseArea())     

cQry := "      SELECT	'SA1 - CLIENTE' CADASTRO, '106' COD_ERR,'LOGRADOURO ERRADO' OCORRENCIA, A1_COD ,A1_LOJA , A1_NOME NOME , A1_END , A1_BAIRRO BAIRRO,A1_MUN MUNICIPIO,  A1_CEP CEP, A1_EST UF, A1_ENDCOB , A1_CEPC CEP_COBRANÇA, A1_ENDENT , A1_CEPE CEP_ENTREGA, A1_INSCR INS_EST, A1_COD_MUN COD_MUN, A1_CGC CGC, R_E_C_N_O_ " +CRLF
cQry += "    FROM   SA1020 (NOLOCK) " +CRLF
cQry += "    WHERE  LEN(A1_CEP) = 8 AND  " +CRLF
cQry += "       A1_END LIKE 'R:%'  OR A1_END LIKE 'R,%' OR A1_END LIKE 'RUA:%' OR A1_END LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_END LIKE 'AV:%'  OR A1_END LIKE 'AV,%' OR A1_END LIKE 'AVENIDA:%' OR A1_END LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_END LIKE 'TRAV:%'  OR A1_END LIKE 'TRAV,%' OR A1_END LIKE 'TRAVESSA:%' OR A1_END LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_END LIKE 'DR:%'  OR A1_END LIKE 'DR,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE ',%' OR A1_ENDCOB LIKE 'R,%' OR A1_ENDCOB LIKE 'RUA:%' OR A1_ENDCOB LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'AV:%'  OR A1_ENDCOB LIKE 'AV,%' OR A1_ENDCOB LIKE 'AVENIDA:%' OR A1_ENDCOB LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'TRAV:%'  OR A1_ENDCOB LIKE 'TRAV,%' OR A1_ENDCOB LIKE 'TRAVESSA:%' OR A1_ENDCOB LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'DR:%'  OR A1_ENDCOB LIKE 'DR,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE ',%' OR A1_ENDENT LIKE 'R,%' OR A1_ENDENT LIKE 'RUA:%' OR A1_ENDENT LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'AV:%'  OR A1_ENDENT LIKE 'AV,%' OR A1_ENDENT LIKE 'AVENIDA:%' OR A1_ENDENT LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'TRAV:%'  OR A1_ENDENT LIKE 'TRAV,%' OR A1_ENDENT LIKE 'TRAVESSA:%' OR A1_ENDENT LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'DR:%'  OR A1_ENDENT LIKE 'DR,%'   " +CRLF
cQry += "  AND D_E_L_E_T_ <> '*'  AND A1_MSBLQL <> 1 " +CRLF


MEMOWRITE("d:\ACERTO0302.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	aTexto := separa(TRB->A1_ENDCOB,":")
	For nI := 1 to len(aTexto) 
		If nI == 1
			cResul := aTexto[nI]+" "
		Else
			cResul += aTexto[nI]
		Endif	                   
	Next nI           
	aArea := getArea()
	dbselectarea("SA1")
	SA1->(dbsetorder(1))
	SA1->(dbseek("  "+TRB->A1_COD+TRB->A1_LOJA))	
	Reclock("SA1",.F.)
	A1_ENDCOB := cResul
	SA1->(Msunlock()) 
	RestArea(aArea)
    TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(dbCloseArea())     


cQry := "      SELECT	'SA1 - CLIENTE' CADASTRO, '106' COD_ERR,'LOGRADOURO ERRADO' OCORRENCIA, A1_COD ,A1_LOJA , A1_NOME NOME , A1_END , A1_BAIRRO BAIRRO,A1_MUN MUNICIPIO,  A1_CEP CEP, A1_EST UF, A1_ENDCOB , A1_CEPC CEP_COBRANÇA, A1_ENDENT , A1_CEPE CEP_ENTREGA, A1_INSCR INS_EST, A1_COD_MUN COD_MUN, A1_CGC CGC, R_E_C_N_O_ " +CRLF
cQry += "    FROM   SA1020 (NOLOCK) " +CRLF
cQry += "    WHERE  LEN(A1_CEP) = 8 AND  " +CRLF
cQry += "       A1_END LIKE 'R:%'  OR A1_END LIKE 'R,%' OR A1_END LIKE 'RUA:%' OR A1_END LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_END LIKE 'AV:%'  OR A1_END LIKE 'AV,%' OR A1_END LIKE 'AVENIDA:%' OR A1_END LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_END LIKE 'TRAV:%'  OR A1_END LIKE 'TRAV,%' OR A1_END LIKE 'TRAVESSA:%' OR A1_END LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_END LIKE 'DR:%'  OR A1_END LIKE 'DR,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE ',%' OR A1_ENDCOB LIKE 'R,%' OR A1_ENDCOB LIKE 'RUA:%' OR A1_ENDCOB LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'AV:%'  OR A1_ENDCOB LIKE 'AV,%' OR A1_ENDCOB LIKE 'AVENIDA:%' OR A1_ENDCOB LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'TRAV:%'  OR A1_ENDCOB LIKE 'TRAV,%' OR A1_ENDCOB LIKE 'TRAVESSA:%' OR A1_ENDCOB LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_ENDCOB LIKE 'DR:%'  OR A1_ENDCOB LIKE 'DR,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE ',%' OR A1_ENDENT LIKE 'R,%' OR A1_ENDENT LIKE 'RUA:%' OR A1_ENDENT LIKE 'RUA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'AV:%'  OR A1_ENDENT LIKE 'AV,%' OR A1_ENDENT LIKE 'AVENIDA:%' OR A1_ENDENT LIKE 'AVENIDA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'TRAV:%'  OR A1_ENDENT LIKE 'TRAV,%' OR A1_ENDENT LIKE 'TRAVESSA:%' OR A1_ENDENT LIKE 'TRAVESSA,%' " +CRLF
cQry += "    OR A1_ENDENT LIKE 'DR:%'  OR A1_ENDENT LIKE 'DR,%'   " +CRLF
cQry += "  AND D_E_L_E_T_ <> '*'  AND A1_MSBLQL <> 1 " +CRLF


MEMOWRITE("d:\ACERTO0303.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	aTexto := separa(TRB->A1_ENDENT,":")
	For nI := 1 to len(aTexto) 
		If nI == 1
			cResul := aTexto[nI]+" "
		Else
			cResul += aTexto[nI]
		Endif	                   
	Next nI        
	aArea := getArea()
	dbselectarea("SA1")
	SA1->(dbsetorder(1))
	SA1->(dbseek("  "+TRB->A1_COD+TRB->A1_LOJA))	
	Reclock("SA1",.F.)
	A1_ENDENT := cResul
	SA1->(Msunlock()) 
	RestArea(aArea)
    TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(dbCloseArea())     

msginfo("FINAL - ACERTO03")
RETURN