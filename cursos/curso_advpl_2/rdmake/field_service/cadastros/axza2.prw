#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'


/*
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : AXZA2			  		| 	Maio de 2012					  								  					|
|-------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																				|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descri��o : Cadastro de Dados Iniciais para o Relat�rio com resumo de Opera��es			  	|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
*/

User Function AXZA2()
u_GerA0003(ProcName())

	AxCadastro("ZA2","Cadastro de Informa��es Iniciais para o Resumo de Opera��es", ".T.", "U_AXZA2A()")

return                                                                                                                                                    


User Function AXZA2A()  

	if val(substring(M->ZA2_MESANO,1,2)) > 12 .or. val(substring(M->ZA2_MESANO,1,2)) < 1
		msgAlert ("O m�s deve estar no intervalo de 01 e 12 !!")
		return .F.	
	endif

	if Inclui
		if dbSeek(xFilial("ZA2")+M->ZA2_MESANO+M->ZA2_OPEBGH)
			msgAlert("Esse m�s/ano j� est� cadastrado para essa operacao !!")
			return .F.
		endif
	endif
	 
	if val(substring(M->ZA2_MESANO,4,4)) < 2012
		msgAlert ("O ano deve ser superior ao ano de 2011 !!")
		return .F.	
	endif                         
	
	if M->ZA2_ENTPLA < 1
		msgAlert ("O n�mero de entradas Planejadas deve ser superior a zero !!")
		return .F.	
	endif

return .T.