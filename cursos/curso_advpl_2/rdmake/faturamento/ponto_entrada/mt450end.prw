User Function MT450end() 

u_GerA0003(ProcName())

/* Ponto de Entrada  na liberacao do Pedido de Venda para VOLTAR a data base
para os pedidos em moeda diferente de R$ e buscar a taxa da moeda pela data de 
emissao do pedido de venda */   
IF SC5->C5_MOEDA > 1
	dDatabase := ddtolddt
ENDIF	
Return 