#Include "PROTHEUS.CH"            
/* Ponto de Entrada na geracao da NF para buscar a 
Taxa da Moeda do Pedido pela data da emissao do
Pedido de Venda
*/
User Function M460PRC()
Local nPrecoven := ParamIxb[1]
Local nPrecoUn  := ParamIxb[2]   
Local nTaxa     := Posicione("SM2",1,DTOS(SC5->C5_EMISSAO),"M2_MOEDA"+Str(SC5->C5_MOEDA,1))                                   

u_GerA0003(ProcName())

IF SC5->C5_TXMOEDA > 0  .and. SC5->C5_TXMOEDA <> 1
	nPrecoVen 	:= nprecoVen * SC5->C5_TXMOEDA
    nPrecoUn  	:= nPrecoUn  * SC5->C5_TXMOEDA
ELSE     
	nPrecoVen 	:= nprecoVen * nTaxa
    nPrecoUn  	:= nPrecoUn  * nTaxa		
ENDIF               
Return ({nPrecoVen,nPrecoUn})