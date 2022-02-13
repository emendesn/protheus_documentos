#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
User Function VincFrete()
Local nPos      := 0
Local bBlock    := {|| Nil}
Local nX	   	:= 0
Local aCores    := {	{'Empty(F1_STATUS)'	,'ENABLE'		},;	// NF Nao Classificada
						{'F1_STATUS=="B"'	,'BR_LARANJA'	},;	// NF Bloqueada
						{'F1_TIPO=="N"'		,'DISABLE'   	},;	// NF Normal
						{'F1_TIPO=="P"'		,'BR_AZUL'   	},;	// NF de Compl. IPI
						{'F1_TIPO=="I"'		,'BR_MARRON' 	},;	// NF de Compl. ICMS
						{'F1_TIPO=="C"'		,'BR_PINK'   	},;	// NF de Compl. Preco/Frete
						{'F1_TIPO=="B"'		,'BR_CINZA'  	},;	// NF de Beneficiamento
						{'F1_TIPO=="D"'		,'BR_AMARELO'	} }	// NF de Devolucao
Local aCoresUsr  := {}
Private aRotina := {  { "Pesquisar", "AxPesqui" , 0 , 0},; // "Pesquisar"
					  { "Vincular", "U_VINCULF" , 0 , 3},;  //"incluir amarracao frete"
                      { "Excluir", "U_VINCULF"  , 0 , 5, 3}} //"Excluir"

PRIVATE cCadastro	:= "Amarracao de conhecimento de frete"
PRIVATE aBackSD1    := {}
PRIVATE aBackSDE    := {}

u_GerA0003(ProcName())

If	(SuperGetMV('MV_INTDL')=='S')
	DbSelectArea("DCF")
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta as cores se utilizar coletor de dados                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SuperGetMV("MV_CONFFIS") == "S"

	aCores    := {	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. Empty(F1_STATUS)'	, 'ENABLE' 		},;	// NF Nao Classificada
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="N"'	 	, 'DISABLE'		},;	// NF Normal
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="P"'	 	, 'BR_AZUL'		},;	// NF de Compl. IPI
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="I"'	 	, 'BR_MARRON'	},;	// NF de Compl. ICMS
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="C"'	 	, 'BR_PINK'		},;	// NF de Compl. Preco/Frete
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="B"'	 	, 'BR_CINZA'	},;	// NF de Beneficiamento
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="D"'    	, 'BR_AMARELO'	},;	// NF de Devolucao
					{ 'F1_STATCON<>"1" .AND. !EMPTY(F1_STATCON)'						, 'BR_PRETO'	}}

EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a permissao do programa em relacao aos modulos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AMIIn(2,4,11,12,14,17,39,41,42,43,97,44,67,69,72) 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a pilha fiscal                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	MaFisSave()
	MaFisEnd()       
	/*
	dbSelectArea("SF1")
	RetIndex()
	dbSetOrder(1)
	cCondicao  := 'SF1->F1_ESPECIE == "CTR"'
	aIndSF1    := {}
	bFiltraBrw := {|| FilBrowse("SF1",@aIndSF1,@cCondicao) }
	Eval(bFiltraBrw)
	*/
	mBrowse(6,1,22,75,"SF1",,,,,,aCores)
	
	/*
	Retira o Filtro, selecionando a ordem principal
	
	dbSelectArea("SF1")
	RetIndex()
	dbClearFilter()
	aEval(aIndSF1,{|x| Ferase(x[1]+OrdBagExt())})
	dbSetOrder(1)    
	*/
	MaFisRestore()
EndIf
Return(.T.)   

User Function VinculF(cAlias,nReg,nOpcx)
	If aRotina[nOpcx][4] == 3
		If !'CTR/CTE' $ SF1->F1_ESPECIE
			MsgAlert("Essa Nota Fiscal nao e de conhecimento de frete!")
			Return .t.
		Endif
		U_ConhecFr(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_EMISSAO,SF1->F1_LOJA,SF1->F1_FORNECE)
	Else		
		U_DelConFre()
	EndIF	
Return .t.