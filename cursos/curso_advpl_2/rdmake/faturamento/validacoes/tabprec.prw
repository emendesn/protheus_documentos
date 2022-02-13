#INCLUDE "PROTHEUS.CH"
User Function TabPrec(nPrecoAlt)      
Local nPLoteCtl     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
Local nPNumLote     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
Local nPQtdVen      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})     
Local nPProduto     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPDescont     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local nPValDesc     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local npostes       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPrecoOri     := 0
Local _tesvnext     := ALLTRIM(GetMV("MV_XTESVNE"))



nPrecoOri := 0
nPrecoOri :=A410Tabela( aCols[n][nPProduto],;                                                      
                        M->C5_TABELA,;                          
                        n,;                                     
                        aCols[n][nPQtdVen],;                    
                        M->C5_CLIENTE,;                               
                        M->C5_LOJACLI,;                              
                        If(nPLoteCtl>0,aCols[n][nPLoteCtl],""),;
                        If(nPNumLote>0,aCols[n][nPNumLote],""),;
                        NIL,;                                  
                        NIL,;                                   
                       .F.)
                       
                                 
If !aCols[n][npostes] $ _tesvnext  .and. nPrecoOri <> 0 .and.  nPrecoAlt < nPrecoOri .and. aCols[n][nPDescont] = 0 .and. aCols[n][nPValdesc] = 0
	MsgAlert("Produto com tabela de preco. Nao pode alterar o preco para menor","Atencao")
	Return .F.
EndIF                     
Return .T.