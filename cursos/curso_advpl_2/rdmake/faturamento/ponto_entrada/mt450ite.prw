User Function MT450ITE() 

u_GerA0003(ProcName())

/* Ponto de Entrada  na liberacao do Pedido de Venda para alterar a data base
para os pedidos em moeda diferente de R$ e buscar a taxa da moeda pela data de 
emissao do pedido de venda */
Private ddtolddt := dDatabase    
IF SC5->C5_MOEDA > 1
	dDatabase := SC5->C5_EMISSAO
Endif	
Return 