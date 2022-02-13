#INCLUDE "protheus.ch"

USER FUNCTION ACERTO08()
    
Local cQry   := ""
Local cTexto := ""
Local cResul := ""

u_GerA0003(ProcName())

msginfo("ACERTO08")  

cQry := " select * FROM SA1020 " +CRLF
cQry += " WHERE D_E_L_E_T_ <> '*' " +CRLF
cQry += "       AND A1_TEL like '%-%'  " +CRLF

MEMOWRITE("d:\QRY01.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD 

dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)

TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
While TRB->(!EOF())// TRB->(<COMANDO>)
	cTexto := TRB->A1_TEL
	cResul := cTexto
	For nI := 1 to len(cTexto) 
    	If substr(cTexto,nI,1) $ '-'
    		cResul := substr(cTexto,1,nI-1)+substr(cTexto,nI+1,len(cTexto)-nI)
    		lSair  := .T.
    		exit    			
    	Endif
	Next nI       
    dbselectarea("SA1")
	SA1->(dbsetorder(1))
	SA1->(dbseek("  "+TRB->A1_COD+TRB->A1_LOJA))	
	Reclock("SA1",.F.)
	A1_TEL := cResul
	SA1->(Msunlock())		
    TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(dbCloseArea())     


msginfo("ACERTO08")

RETURN