#INCLUDE "protheus.ch"

USER FUNCTION ACERTO07()
    
Local cQry   := ""
Local cTexto := ""
Local cResul := ""

u_GerA0003(ProcName())


msginfo("ACERTO07")  

cQry := "   SELECT	'SA1 - CLIENTE' CADASTRO, '008' COD_ERR,'ENDEREÇO INCOMPLETO' OCORRENCIA, A1_COD ,A1_LOJA , A1_NOME NOME , A1_END , A1_BAIRRO BAIRRO,A1_MUN MUNICIPIO,  A1_CEP CEP, A1_EST UF, A1_ENDCOB END_COBRANÇA , A1_CEPC CEP_COBRANÇA, A1_ENDENT END_ENTREGA, A1_CEPE CEP_ENTREGA, A1_INSCR INS_EST, A1_COD_MUN COD_MUN, A1_CGC CGC, R_E_C_N_O_ " +CRLF
cQry += "   FROM   SA1020 " +CRLF
cQry += "   WHERE  D_E_L_E_T_ <> '*'  AND A1_MSBLQL <> 1 AND A1_END NOT LIKE '%,%' " +CRLF

MEMOWRITE("d:\QRY01.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	cTexto := TRB->A1_END
	cResul := cTexto
	For nI := 1 to len(cTexto) 
    	If substr(cTexto,nI,1) $ '0123456789'
    		cResul := substr(cTexto,1,nI-1)+","+substr(cTexto,nI,len(cTexto)-nI)
    		lSair  := .T.
    		exit    			
    	Endif
	Next nI       
    dbselectarea("SA1")
	SA1->(dbsetorder(1))
	SA1->(dbseek("  "+TRB->A1_COD+TRB->A1_LOJA))	
	Reclock("SA1",.F.)
	A1_END := cResul
	SA1->(Msunlock())	
    TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(dbCloseArea())     


msginfo("ACERTO07")

RETURN