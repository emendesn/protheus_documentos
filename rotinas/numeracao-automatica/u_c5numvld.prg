#INCLUDE "PROTHEUS.CH"

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁObservacoes.:												   Ё
Ё       	       											   Ё
Ё1 ) As variaveis Static Sao utilizadas para minimizar a  perdaЁ
Ё    de Performance                                            Ё
Ё2 ) Pode ocorrer perda de Numeracao em funcao de outro  prograЁ
Ё    ma Utilizar a GetSxeNum() diretamente para obter a  numeraЁ
Ё    cao Automatica para o C5_NUM ao inves da funcao   definidaЁ
Ё    no X3_RELACAO do campo.                                   Ё
Ё3 ) Para ter a certeza de que o Programa de Pedido de   VendasЁ
Ё    nao ira perder o sequencial do pedido de venda utilize   aЁ
Ё    chamada com U_C5NumIni(.T.) no X3_RELACAO do campo  C5_NUMЁ
Ё    e U_C5NumVld(NIL,NIL,.T.) no X3_VALID do mesmo campo. 	   Ё
Ё    A T E N C A O: Neste caso a performance vai abaixo.       Ё
Ё4 ) As funcoes soh iram garantir a Numeracao se essa for  obtiЁ
Ё    da a partir do X3_RELACAO em conjunto com o X3_VALID    doЁ
Ё    campo. Como existem outros programas que inicializam a  nuЁ
Ё    meracao para o C5_NUM atraves da GetSxeNum() poderao  ocorЁ
Ё    rer, eventualmente, perda de Numeracao.                   Ё
Ё5 ) Recomendo que o campo X5_NUM esteja como Visual no SX3.   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static __cC5NumStc
Static __cC5KeyNumStc

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁU_C5NumVld	 ЁAutorЁMarinaldo de Jesus    Ё Data Ё27/09/2005Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁFuncao para Validar o Conteudo do Campo C5_NUM           	Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁX3_VLDUSER para o campo C5_NUM                         		Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function C5NumVld( cC5Num , lShowHelp , lForceInit )
                                             
Local lC5NumOk		:= .F.

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁObtem o Conteudo para o campo C5_NUM						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF (;
			IsInGetDados( { "C5_NUM" } );
			.and.;
			!( IsCpoVar( "C5_NUM" ) );
		)	
		DEFAULT cC5Num := GdFieldGet( "C5_NUM" )
	ElseIF ( IsMemVar( "C5_NUM" ) )
		DEFAULT cC5Num := GetMemVar( "C5_NUM" )
	ElseIF ( SC5->( FieldPos( "C5_NUM" ) ) > 0 )
		DEFAULT cC5Num := SC5->C5_NUM
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁObtem a Numeracao Automatica e Verifica se ela esta OK		   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	DEFAULT lShowHelp	:= .F.
	DEFAULT lForceInit	:= .F.
	IF !( lC5NumOk := C5GetNum( @cC5Num , .F. , @lShowHelp , @lForceInit ) )
    	Break
    EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁSeta o Codigo do Pedido de Venda 							   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( IsInGetDados( { "C5_NUM" } ) )
		GdFieldPut( "C5_NUM" , cC5Num )
	ElseIF ( IsMemVar( "C5_NUM" ) )
		SetMemVar( "C5_NUM" , cC5Num )
	EndIF

End Sequence

Return( lC5NumOk )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁC5GetNum   	 ЁAutorЁMarinaldo de Jesus    Ё Data Ё27/09/2005Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁObtem Numeracao Valida para o C5_NUM                     	Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁObter Numeracao valida para o C5_NUM                 		Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function C5GetNum( cC5Num , lExistChav , lShowHelp , lForceInit )

Local cPrefixo
Local cLstC5Num
Local cIndexKey
Local cSoftSeek

Local nSC5Order

Local lGetNum

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁInicializo lGetNum com .F.									   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	lGetNum		:= .F.

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁObtenho o Prefixo para a Composicao da Numeracao			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cPrefixo	:= xFilial( "SC5" )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁObtenho a Chave Unica para o SC5 ( X2_UNICO )				   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cIndexKey	:= GetSx2Unico( "SC5" )
	
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁSe estiver vazio, defino a Chave de Indice   				   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF Empty( cIndexKey )
		cIndexKey := "C5_FILIAL+C5_NUM"	
	EndIF

	DEFAULT lForceInit := .F.
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁSe nao Forcar a Inicializacao do Numero desde o Inicio    	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lForceInit )

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁArmazeno o Numero passado por parametro         			   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		cLstC5Num	:= cC5Num

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁArmazena o Prefixo do Pedido de Venda na Variavel Static  paraЁ
		Ё Comparacao na Proxima Inclusao							   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF ( __cC5KeyNumStc <> cPrefixo )
			__cC5NumStc		:= NIL
			__cC5KeyNumStc	:= cPrefixo
		EndIF
	
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁSe cC5Num estiver Vazio, eh uma novo Pedido de Venda,    entaoЁ
		Ёobtenho uma nova numeracao     							   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF (;
				Empty( cC5Num );
				.or.;
				Empty( __cC5NumStc );
			)	
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁSe a ultima Numeracao Obtida nao estiver Definida, obtenho umaЁ
			Ёnova 														   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			IF Empty( __cC5NumStc )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁObtenho a Ordem para a Pesquisa							   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				nSC5Order := RetOrder( "SC5" , cIndexKey )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁSeto a Ordem para a Pesquisa							   	   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				SC5->( dbSetOrder( nSC5Order ) )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁDefine chave paracial para um SoftSeek                        Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				cSoftSeek := Replicate( "9" , GetSx3Cache( "C5_NUM" , "X3_TAMANHO" ) )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁEfetuo um "SoftSeek"( Terceiro parametro da MsSeek == .T. ) paЁ
				Ёra posicionar no Registro mais proximo.					   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				SC5->( MsSeek( cPrefixo + cSoftSeek , .T. ) )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁSe o Numero do Pedido de Venda estiver vazio ou se o    FilialЁ
				Ёnao  Corresponder a Filial Corrente						   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				IF (;
						Empty( SC5->C5_NUM );
						.or.;
						!( cPrefixo == SC5->C5_FILIAL );
					)
					/*/
					здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					ЁVolto um Registro para Obter o ultimo Pedido de Venda RegistradoЁ
					юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
					SC5->( dbSkip( -1 ) )
				EndIF
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁSe a Filial do Pedido de Venda Corresponder a Filial Correte. Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				IF ( cPrefixo == SC5->C5_FILIAL )
					/*/
					здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					ЁObtenho a Ultima Numeracao									   Ё
					юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
					__cC5NumStc := SC5->C5_NUM
				Else
					/*/
					здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					ЁCaso Contrario eh o inicio de uma nova Sequencia de Pedido de VendasЁ
					юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
					__cC5NumStc := StrZero( 1 , GetSx3Cache( "C5_NUM" , "X3_TAMANHO" ) )
				EndIF
			EndIF
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁAtribuo a cC5Num o Ultimo Pedido de Venda Valido			   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			cC5Num := __cC5NumStc
		Else
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁCaso Contrario obtenho a numeracao passada por parametro	   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			__cC5NumStc := cC5Num
		EndIF
	Else
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁCaso Contrario eh o inicio de uma nova Sequencia de Pedido de VendasЁ
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		cC5Num := StrZero( 1 , GetSx3Cache( "C5_NUM" , "X3_TAMANHO" ) )
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁVerifico se a Numeracao para a Pedido de Venda e Valida e Exclusiva Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF (;
			lGetNum := GetNrExclOk(	@cC5Num 		,;	//01 -> Numeracao Exclusiva ( Por Referencia )
									"SC5"			,;	//02 -> Alias para a Numeracao Exclusiva
									""				,;	//03 -> Campo para a Numeracao Exclusiva
									cIndexKey		,;	//04 -> Chave de Indice para Pesquisa
									NIL				,;	//05 -> Bloco com a Funcao para Retorno da Numeracao Exclusiva
									lExistChav		,;	//06 -> Se Executara Existe chave, caso contrario dbSeek()
									lShowHelp		,;	//07 -> Se Devera Mostrar Help caso hava inconsistencia
									cPrefixo		,;	//08 -> Chave Auxiliar para pesquisa ( "P"refixo )
									NIL				,;	//09 -> Chave Auxiliar para pesquisa ( "S"ufixo  )
									.F.				 ;	//10 -> Se deve Considerar o Campo Filial
								);
		)
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁSe Conseguir obter um Novo Numero de Pedido de Venda e este nao  forЁ
		Ёvazio													   	   	     Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF ( lGetNum := !Empty( cC5Num ) )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁSe nao Forcar a Inicializacao do Numero desde o Inicio    	   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			IF !( lForceInit )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁE, se o Numero de Entrada for Diferente do Numero de Saida	   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				IF ( cLstC5Num <> cC5Num )
					/*/
					здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					ЁSalvo a ultima Numeracao de Pedido de Venda Valida			   Ё
					юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
					__cC5NumStc := cC5Num
				Else
					/*/
					здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					ЁSalvo a ultima Numeracao de Pedido de Venda Valida			   Ё
					юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
					__cC5NumStc := cC5Num
				EndIF
			EndIF
		EndIF
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁSe nao Forcar a Inicializacao do Numero desde o Inicio    	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lForceInit )
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁSe nao obtive uma numeracao Exclusiva, reinicializo a   StaticЁ
		Ё__cC5NumStc												   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF !( lGetNum )
			__cC5NumStc := NIL
		EndIF
	EndIF

End Sequence

Return( lGetNum )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁU_C5NumIni	 ЁAutorЁMarinaldo de Jesus    Ё Data Ё27/09/2005Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁInicializador Padrao do Campo C5_NUM 	         			Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁX3_RELACAO para o campo C5_NUM	                         	Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function C5NumIni( lForceInit )

Local cC5Num

DEFAULT lForceInit	:= .F.

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁEfetuo a Chamada a C5GetNum para obter uma Nova Numeracao	   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
IF !( C5GetNum( @cC5Num , .F. , .F. , lForceInit ) )
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁSe Falhou, inicializo com Espacos correspondente ao Tamanho doЁ
	Ёcampo.														   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cC5Num	:= Space( GetSx3Cache( "C5_NUM" , "X3_TAMANHO" ) )
EndIF

Return( cC5Num )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁU_IsCpoVar   ЁAutorЁMarinaldo de Jesus    Ё Data Ё27/09/2005Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁVerificar se a Variavel de Memoria Ativa corresponde ao  camЁ
Ё          Ёpo passado por Parametro.									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico													Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function IsCpoVar( cField )

Local cVar	:= Upper( AllTrim( SubStr( ReadVar() , 4 ) ) )
                                      
DEFAULT cField := ""                  
cField := Upper( AllTrim( cField ) )

Return( ( cVar == cField ) )