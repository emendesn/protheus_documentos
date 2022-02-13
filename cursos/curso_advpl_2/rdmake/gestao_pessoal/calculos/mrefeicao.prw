User Function MRefeicao()                                  
Local zz := 0

u_GerA0003(ProcName())
zz := ascan( arefeicao,{ |x|  x[1]    = sra->ra_valeref })    
If zz > 0
	fGeraVerba("788",arefeicao[zz,2]*arefeicao[zz,3],,,,,,,,,.T.)    
else                                                                   
	fGeraVerba("788",arefeicao[1,2]*arefeicao[1,3],,,,,,,,,.T.)    
endif
Return .T.