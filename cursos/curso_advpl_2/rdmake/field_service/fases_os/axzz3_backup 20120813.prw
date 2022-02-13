#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#define ENTER CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AXZZ3    ºAutor  ³Edson B. - Erp Plus º Data ³  24/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para apontamento das fases de Ordens de Servico.    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function AXZZ3()

Local aFixed     := {}
Private	_center   	:= Chr(13)+Chr(10)
Private ccAlias  := ''
Private _csetmast:= ""
Private _cfasmast:= ""
Private _aModBlq := {}
Private _agarblq := {}
Private cartime	 := Space(20)
Private cnumlin	 := Space(12)
Private csofin	 := Space(10)
Private csoftout := Space(10)
Private ctransc	 := Space(5)
Private cGarmcl	 := Space(1)
Private cgarant  := Space(1)
Private copebgh  := Space(3)
Private aGrupos  := aClone(UsrRetGRP())
Private lUsrNext := .F.
Private lUsrAdmi := .F.
Private lUsrsony := .F.
Private _cFasDoc :=  GETMV("BH_DOCSEP",.F.,"0000060100000000") // Setores e Fases atuais e destinos da operação que deve solicitar informação do dcto de separação
Private oartime
Private onumlin
Private osofin
Private osoftout
Private otransc
Private oDlgout 		// Dialog de outras informacoes
Private cCliente := Space(6)
Private cloja    := Space(2)
Private cfasstam := Space(12)
Private cReset := Space(2)
Private oDlgCli
Private _aAlterCampo := {}
Private cString   := "ZZ3"
Private cCadastro := "Apontamento de Fases de OS's"
Private aRotina   := {}
Private _cIssue	  := GetMv("MV_ISSUE") 				 	// Aparelhos Parametrizados ISSUE
Private oFld
Private aCores    := {	{ 'ZZ3->ZZ3_ESTORN == "S"' ,'DISABLE'		},;
{ 'ZZ3->ZZ3_ESTORN <> "S"' ,'ENABLE'		} }

aAdd( aRotina, {"Pesquisar"  	,"AxPesqui"                         ,0,1})
aAdd( aRotina, {"Visualizar" 	,'AxVisual("ZZ3",ZZ3->(recno()),2)' ,0,2})
aAdd( aRotina, {"Apontar Fase"	,"U_AXZZ3MOD"                       ,0,3})
aAdd( aRotina, {"Estornar Fase"	,"U_EstZZ3"                         ,0,4})
aAdd( aRotina, {"Garantia"		,"U_CONSGA01"                       ,0,5})
aAdd( aRotina, {"Apontar &Peça"	,"U_APONTPCA"                       ,0,5})
aAdd( aRotina, {"Special Prj"	,"U_BLQGAR01"                       ,0,5})
aAdd( aRotina, {"Etiq. Master"	,"U_EtqGera"						,0,5})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to Len(aGrupos)
	
	//Usuarios Nextel
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Next"
		lUsrNext  := .T.
	Elseif Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Sony"
		lUsrSony  := .T.
	EndIf
	
	//Administradores
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Admi"
		U_Menu()
	EndIf
Next i

Set Key VK_F4 TO U_CONSGA08()
Set Key VK_F5 TO U_CONSPECA()

If Empty(Posicione("SX3",1,cString,"X3_ARQUIVO"))
	Help("",1,"","NOX3X2IX","NÃO É POSSÍVEL EXECUTAR, FALTA"+_center+"X3, X2, IX E X7",1,0)
	RETURN
Endif

dbSelectArea("SZA")
SZA->(dbsetorder(1))

If lUsrNext .Or. lUsrAdmi
	
	_lAltTec	:= Posicione("AA1",4,xFilial("AA1") + __cUserId,"AA1_CODTEC")
	
	If Empty(AllTrim(_lAltTec))
	    MsgStop("Usuário Sem Cadastro, Favor Entrar em Contato com Supervisor","Erro Cadastro")
	   	Return
  	Else
		dbSelectArea(cString)
		mBrowse(,,,,cString,aFixed,,,,,aCores)
    EndIf
	
Else
	
	dbSelectArea(cString)
	mBrowse(,,,,cString,aFixed,,,,,aCores)
	
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXZZ3ALTVISºAutor  ³Edson B. - ERP Plus º Data ³  28/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de inclusao, alteracao, exclusao e visualizacao       º±±
±±º          ³da tabela ZZ3.                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AXZZ3MOD( cString, nRecNo, nOpcX )
Private lCliente 	:= .F.
Private lClismas    := .F.
Private lfasstam    := .F.
Private _nMaxLin    := 0 //Numero maximo de linha do oGet
Private _lDelet     := .T.
Private _lAltera    := .T.
Private _lEncOS     := .F.
Private _lEncOSMsg  := .F.
Private _lCodAna	:= .T.
Private _lSwap      := .F.
Private _lSwap2     := .F.
Private _lNumdoc	:= .F.
Private _lgongo     := .F.
Private _lAltTec
Private _SetDest    := .T.
Private _FaseDest   := .T.
Private _lNewLine   := .T.
Private _lDEFINF    := .T.
Private _lDEFDET    := .T.
Private _lLaudo     := .T.
Private _lSolucao   := .T.
Private _cGrava		:= .T.
Private _lCor       := .T.
Private _cDEFINF    := ""
Private _cDefMc		:= ""
Private _cDEFDET    := ""
Private _cFGONGO    := ""
Private _cdefcli   	:= ""
Private _lInfres := .F.
Private _aLabs 		:={}
Private _aYN        := {"","S=SIM","N=NÃO"}
Private _lREGACOLS  := .F.
Private _lADDPARTNO := .F.
Private _lADDPECAF  := .F.
Private _lobrigpf   := .F.
Private _lobripart  := .F.
Private _dUltSai    := CTOD(" / / ")
Private _nBounce    := 0
Private _ctransIMEI :="S"
Private _cobrdefdet :="N"
Private _cobrdefcli :="N"
Private aHeader   	:= {}
Private aCOLS     	:= {}
Private nUsado    	:= 0
Private _aStru    	:= {}
Private oGet      	:= Nil
Private _lscreen  	:=.F.
Private _lValidPartNO := .T.
Private ctransope	:= ""
Private _cDefRec 	:= ""
Private _cDefSeq 	:= ""

Private _aRecnoZZ3   := {}
Private _aRecnoSZ9   := {}
Private _aRecnoZZ7   := {}
Private aSavAheadZZ3 := {}
Private aSavAcolsZZ3 := {}
Private _cSEQ 		 := '01'
Private _cGarmcl
Private _cMissue

Private aSize   	:= MsAdvSize(,.F.,100)
Private aObjects	:= {{ 0, 130, .T., .F. },{ 0, 200, .T., .T. }}  //Obj1 = Cabecalho, Obj2 = Itens
Private aInfo   	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
Private aPosObj 	:= MsObjSize( aInfo, aObjects, .T. )

//-- Incluso Edson Rodrigues 20/03/10
dbselectarea("SX5")
dbsetorder(1)
SX5->(dbSeek(xFilial("SX5") + 'LB'))
While SX5->(!eof()) .And. SX5->X5_FILIAL == xFilial("SX5") .And. SX5->X5_TABELA == 'LB'
	AADD(_aLabs,ALLTRIM(SX5->X5_CHAVE)+"="+ALLTRIM(SX5->X5_DESCRI))
	SX5->(DBSKIP())
Enddo

If lUsrNext .Or. lUsrAdmi
	Private _aCabec := {{"SEQ"  	,"SEQ"		},;
	{"IMEI" 	,"IMEI"		},;
	{"DPYIMEI" 	,"DPYIMEI"	},;
	{"SERIE"	,"SERIE"	},;
	{"LOTEIRL"	,"LOTEIRL"	},;
	{"OS"   	,""			},;
	{"DATA" 	,""			},;
	{"HORA" 	,""			},;
	{"ENCOS"	,"ENCOS"	},;
	{"DEFIN"	,"DEFINF"	},;
	{"DEFCO"	,"DEFDET"	},;
	{"IMEIN"	,"IMEINOVO"	},;
	{"CONTROC"	,"CONTROC"	},;
	{"DPYIMN"	,"DPYINOVO"	},;
	{"FGONGO"	,"FGONGO"	},;
	{"CODSET"	,"CODSET"	},;
	{"FASEO"	,"FAS1"		},;
	{"CODSE2"	,"CODSE2"	},;
	{"FASED"	,"FAS2"		},;
	{"SOLUCAO"	,"SOLUCAO"	},;
	{"COR"  	,"COR"		},;
	{"ARTIME"	,"ARTIME"   }}
Else
	Private _aCabec := {{"SEQ"  	,"SEQ"		},;
	{"IMEI" 	,"IMEI"		},;
	{"DPYIMEI" 	,"DPYIMEI"	},;
	{"SERIE"	,"SERIE"	},;
	{"LOTEIRL"	,"LOTEIRL"	},;
	{"OS"   	,""			},;
	{"DATA" 	,""			},;
	{"HORA" 	,""			},;
	{"ENCOS"	,"ENCOS"	},;
	{"DEFIN"	,"DEFINF"	},;
	{"DEFCO"	,"DEFDET"	},;
	{"IMEIN"	,"IMEINOVO"	},;
	{"CONTROC"	,"CONTROC"	},;
	{"DPYIMN"	,"DPYINOVO"	},;
	{"FGONGO"	,"FGONGO"	},;
	{"CODSET"	,"CODSET"	},;
	{"FASEO"	,"FAS1"		},;
	{"CODSE2"	,"CODSE2"	},;
	{"FASED"	,"FAS2"		},;
	{"LAUDO"	,"LAUDO"	},;
	{"COR"  	,"COR"		},;
	{"ARTIME"	,"ARTIME"   }}
EndIf

//Monta aHeader para o MSGetDados() usando os campos a tabela temporária TRB
Aadd(aHeader, {"SEQUENCIA"		, "SEQ"		, "@!"	     	 , 02, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"IMEI"	    	, "IMEI"	, "@!"	     	 , 20, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"DPY. REPARO"	, "DPYIMEI"	, "@!"	     	 , 20, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"SERIE"	    	, "SERIE"	, "@!"	     	 , 20, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"OS" 	    	, "OS"		, "@!"	     	 , 08, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"LOTEIRL" 		, "LOTEIRL"	, "@!"	     	 , 10, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"DATA" 	    	, "DATA"	, "@!"	     	 , 08, 0, ".F.", USADO , "D", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"HORA" 	    	, "HORA"	, "@!"	     	 , 05, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"ENCERRA OS"		, "ENCOS"	, "@!"	     	 , 03, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )

If lUsrNext .Or. lUsrAdmi
	Aadd(aHeader, {"DEF.RECLAMADO"	, "DEFIN"	, "@!"	     	 , 05, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
	Aadd(aHeader, {"DEF.CONSTATADO"	, "DEFCO"	, "@!"	     	 , 05, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Else
	Aadd(aHeader, {"DEF.CLIENTE"	, "DEFIN"	, "@!"	     	 , 05, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
	Aadd(aHeader, {"DEF.IDENTIF.."	, "DEFCO"	, "@!"	     	 , 05, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
EndIf

Aadd(aHeader, {"IMEI NOVO" 		, "IMEIN"	, "@!"	     	 , 20, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"DPY.NOVO"   	, "DPYIMN"	, "@!"	     	 , 20, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"CONTR.TROCA"	, "CONTROC"	, "@!"	     	 , 10, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"FALHA.GONGO"	, "FGONGO"	, "@!"	     	 , 06, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"SETOR ORIG."	, "CODSET"	, "@!"	     	 , 06, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"FASE ORIG."		, "FASEO"	, "@!"	     	 , 02, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"SETOR DEST."	, "CODSE2"	, "@!"	     	 , 06, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"FASE DEST."		, "FASED"	, "@!"	     	 , 02, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )

If lUsrNext .Or. lUsrAdmi
	Aadd(aHeader, {"SOLUCAO"			, "SOLUCAO"	, "@!"	     	 , 02, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Else
	Aadd(aHeader, {"LAUDO"			, "LAUDO"	, "@!"	     	 , 02, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
EndIf

Aadd(aHeader, {"COR"			, "COR"		, "@!"	     	 , 02, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )
Aadd(aHeader, {"ARTIME"			, "ARTIME"	, "@!"	     	 , 20, 0, ".F.", USADO , "C", "", ""  , "", ""      , "", "" , "", "", ""  } )

//Inicia variaveis para o cabecalho
Private SEQ      := CriaVar("ZZ3_SEQ"	    ,.F.)
Private CODTEC   := CriaVar("ZZ3_CODTEC"   ,.F.)
Private CODANA	 := Criavar("ZZ3_CODANA"   ,.F.)
Private LAB      := CriaVar("ZZ3_LAB"      ,.F.)
Private CODSET   := CriaVar("ZZ3_CODSET"   ,.F.)
Private FAS1     := CriaVar("ZZ3_FASE1"    ,.F.)
Private CODSE2   := CriaVar("ZZ3_CODSE2"   ,.F.)
Private FAS2     := CriaVar("ZZ3_FASE2"    ,.F.)
Private DEFINF   := CriaVar("ZZ3_DEFINF"   ,.F.)
Private DEFDET   := CriaVar("ZZ3_DEFDET"   ,.F.)
Private LAUDO    := CriaVar("ZZ3_LAUDO"    ,.F.)
Private SOLUCAO  := CriaVar("ZZ3_ACAO"     ,.F.)
Private COR      := CriaVar("ZZ3_COR"      ,.F.)
Private SERIE    := CriaVar("ZZ4_CARCAC"   ,.F.)
Private SWAP     := CriaVar("ZZ3_SWAP"     ,.F.)
Private ENCOS    := CriaVar("ZZ3_ENCOS"    ,.F.)
Private IMEI     := CriaVar("ZZ3_IMEI"     ,.F.)
Private IMEINOVO := CriaVar("ZZ3_IMEISW"   ,.F.)
Private MODIMEIN := CriaVar("ZZ3_MODSW"    ,.F.)
Private DPYINOVO := CriaVar("ZZ3_DPYINV"   ,.F.)
Private CONTROC  := CriaVar("ZZ3_CTROCA"   ,.F.)
Private FGONGO   := CriaVar("ZZ3_FGONGO"   ,.F.)
Private LOTEIRL  := CriaVar("ZZ3_LOTIRL"   ,.F.)
Private ARTIME   := CriaVar("ZZ3_ARTIME"   ,.F.)
Private DPYIMEI  := CriaVar("ZZ3_DPYIME"   ,.F.)
Private UPGRAD   := CriaVar("ZZ3_UPGRAD"   ,.F.)
Private FAS1Ori  := FAS2Ori  := CODSETORI := CODSE2ORI := XCODSET := ""
Private _cNumDoc := Space(9)

//valida inclusao, exclusao, visualizacao, alteracao
_nMax     := Iif(nOpcX == 3 .or. nOpcX == 4,99  ,Len(aCols)) 					//Se Visualizar, nao deixa incluir mais linhas

DEFINE MSDIALOG oDlg TITLE "Apontamento de Fases de OS's" From aSize[7],aSize[1] To aSize[3],aSize[5] of oMainWnd Pixel

@ aPosObj[1,1], aPosObj[1,2] TO aPosObj[1,3], aPosObj[1,4] LABEL "" OF oDlg PIXEL

_nCol1 := 000
_nCol2 := 150

_nAjust := 012 //015-Espaco entre as linhas
_nLin1  := 005 //Linha inicial
_nLin2  := _nLin1 + _nAjust
_nLin3  := _nLin2 + _nAjust
_nLin4  := _nLin3 + _nAjust
_nLin5  := _nLin4 + _nAjust
_nLin6  := _nLin5 + _nAjust
_nLin7  := _nLin6 + _nAjust
_nLin8  := _nLin7 + _nAjust
_nLin9  := _nLin8 + _nAjust
_nLin10 := _nLin9 + _nAjust

//Informar os campos na sequencia de apresentacao da tela, para que o Tab siga a sequencia na tela
@ aPosObj[1,1]+_nLin1 ,	aPosObj[1,1]+_nCol1 	SAY "Técnico" 		    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin1 ,	aPosObj[1,1]+_nCol2		SAY "Laboratório"  		SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin2 ,	aPosObj[1,1]+_nCol1 	SAY "Data"			    SIZE 70,7 PIXEL OF oDlg

If lUsrNext .Or. lUsrAdmi
	
	@ aPosObj[1,1]+_nLin2 ,	aPosObj[1,1]+_nCol2 	SAY "Analista"		    SIZE 70,7 PIXEL OF oDlg
	
EndIf

@ aPosObj[1,1]+_nLin3 ,	aPosObj[1,1]+_nCol1 	SAY "Setor Atual"	    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin3 ,	aPosObj[1,1]+_nCol2		SAY "Fase Atual"	    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin4 ,	aPosObj[1,1]+_nCol1 	SAY "Setor Destino"	    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin4 ,	aPosObj[1,1]+_nCol2 	SAY "Fase Destino"		SIZE 70,7 PIXEL OF oDlg

If lUsrNext .Or. lUsrAdmi
	@ aPosObj[1,1]+_nLin5 ,	aPosObj[1,1]+_nCol1		SAY "Def. Reclamado"    	SIZE 70,7 PIXEL OF oDlg
	@ aPosObj[1,1]+_nLin5 ,	aPosObj[1,1]+_nCol2		SAY "Def. Constatado"     	SIZE 70,7 PIXEL OF oDlg
	@ aPosObj[1,1]+_nLin6 ,	aPosObj[1,1]+_nCol1		SAY "Solucao"			    SIZE 70,7 PIXEL OF oDlg
Else
	@ aPosObj[1,1]+_nLin5 ,	aPosObj[1,1]+_nCol1		SAY "Def. Cliente"    	SIZE 70,7 PIXEL OF oDlg
	@ aPosObj[1,1]+_nLin5 ,	aPosObj[1,1]+_nCol2		SAY "Def. Identif."     SIZE 70,7 PIXEL OF oDlg
	@ aPosObj[1,1]+_nLin6 ,	aPosObj[1,1]+_nCol1		SAY "Laudo"			    SIZE 70,7 PIXEL OF oDlg
EndIf

@ aPosObj[1,1]+_nLin6 ,	aPosObj[1,1]+_nCol2		SAY "Cor"			    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin7 ,	aPosObj[1,1]+_nCol1 	SAY "Swap?"			    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin7 ,	aPosObj[1,1]+_nCol2 	SAY "Encerrar Os?"	    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin8 ,	aPosObj[1,1]+_nCol1 	SAY "IMEI Novo"		    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin8 ,	aPosObj[1,1]+_nCol2 	SAY "Mod. IMEI Novo"	SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin9 ,	aPosObj[1,1]+_nCol1 	SAY "Cod. DPY Novo"	    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin9 ,	aPosObj[1,1]+_nCol2 	SAY "falha.GoNoGo"	    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin9,	aPosObj[1,1]+_nCol2+150	SAY "Doc Planejado"	    SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin10,	aPosObj[1,1]+_nCol1 	SAY "Upgrade?"			SIZE 70,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin10,	aPosObj[1,1]+_nCol2 	SAY "IMEI"			    SIZE 70,7 PIXEL OF oDlg

If lUsrNext .Or. lUsrAdmi
	
	_lAltTec	:= Posicione("AA1",4,xFilial("AA1") + __cUserId,"AA1_CODTEC")
	CODTEC		:= _lAltTec
	AltCabec("AA1")
	
Endif
//O MSGET trunca os nomes da variáveis, deixando-as com o tamanho 10
@ aPosObj[1,1]+_nLin1 ,aPosObj[1,1] + _nCol1 + 70    		MSGET    CODTEC	                	When Iif(!Empty(_lAltTec),.F.,.T.)  	F3 "AA1"   	valid ExistCPO("AA1") .And. AltCabec("AA1") Picture "@!"	 			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin1 ,aPosObj[1,1] + _nCol2 + 70	   		COMBOBOX LAB       ITEMS _aLabs   	When .F.	                                	                                	 			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin2 ,aPosObj[1,1] + _nCol1 + 70    		MSGET    date()                		When .F.	                             	                                    	 			SIZE 070,7 PIXEL OF oDlg

If lUsrNext .Or. lUsrAdmi
	
	@ aPosObj[1,1]+_nLin2 ,aPosObj[1,1] + _nCol2 + 70    	MSGET    CODANA	                	When Iif(!Empty(_lAltTec),.T.,.F.)  	F3 "AA1"   	valid Iif(!Empty(CODANA),ExistCPO("AA1") .And. AltCabec("AA1"),"") Picture "@!"	 			SIZE 070,7 PIXEL OF oDlg
	
EndIf

@ aPosObj[1,1]+_nLin3 ,aPosObj[1,1] + _nCol1 + 70    		MSGET    CODSET                   	When .T.        F3 "ZZB_2" 	valid AltCabec("SET1")     					Picture "@!"			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin3, aPosObj[1,1] + _nCol2 + 70	   		MSGET    FAS1                      	When .T.	    F3 "ZZB_1" 	valid AltCabec("FAS1")                   	Picture "@!"			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin4 ,aPosObj[1,1] + _nCol1 + 70 			MSGET    CODSE2                    	When _SetDest   F3 "ZZ2_4" 	valid AltCabec("SET2")						Picture "@!"			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin4, aPosObj[1,1] + _nCol2 + 70 			MSGET    FAS2                      	When _FaseDest  F3 "ZZA"   	valid AltCabec("FAS2")                     	Picture "@!"			SIZE 070,7 PIXEL OF oDlg


@ aPosObj[1,1]+_nLin5 ,aPosObj[1,1] + _nCol1 + 70	   	MSGET    DEFINF	                 	When _lDefInf   F3 IIF(lUsrSony,"SZ8SIN","ZZG01")  valid IIF(lUsrSony,AltCabec("Z82"), AltCabec("ZZG") )             Picture "@!"			SIZE 070,7 PIXEL OF oDlg


If lUsrNext .Or. lUsrAdmi
	/*	@ aPosObj[1,1]+_nLin5 ,aPosObj[1,1] + _nCol2 + 70 		MSGET    DEFDET                 	When _lDefDet   F3 "SZ8SIN" valid AltCabec("Z81")		                Picture "@!" 			SIZE 070,7 PIXEL OF oDlg
	@ aPosObj[1,1]+_nLin6 ,aPosObj[1,1] + _nCol1 + 70 		MSGET    SOLUCAO                	When _lSolucao  F3 "SZL" 	valid AltCabec("SZ8")              			Picture "@!"			SIZE 070,7 PIXEL OF oDlg*/
	@ aPosObj[1,1]+_nLin5 ,aPosObj[1,1] + _nCol2 + 70 		MSGET    DEFDET                 	When _lDefDet   F3 "SZL2"  valid AltCabec("Z81")		                Picture "@!" 			SIZE 070,7 PIXEL OF oDlg
	@ aPosObj[1,1]+_nLin6 ,aPosObj[1,1] + _nCol1 + 70 		MSGET    SOLUCAO                	When _lSolucao  F3 "SZL1"  valid AltCabec("SZ8")              			Picture "@!"			SIZE 070,7 PIXEL OF oDlg
Else
	@ aPosObj[1,1]+_nLin5 ,aPosObj[1,1] + _nCol2 + 70 		MSGET    DEFDET                 	When _lDefDet   F3 "ZZG01" valid AltCabec("ZZG2")		                Picture "@!" 			SIZE 070,7 PIXEL OF oDlg
	@ aPosObj[1,1]+_nLin6 ,aPosObj[1,1] + _nCol1 + 70 		MSGET    LAUDO                  	When _lLaudo    F3 "Z8"    valid AltCabec("Z8")		                    Picture "@!"			SIZE 070,7 PIXEL OF oDlg
EndIf

@ aPosObj[1,1]+_nLin6 ,aPosObj[1,1] + _nCol2 + 70	   		MSGET    COR                       	When _lCor      F3 "Z3"    valid AltCabec("Z3")		                        		 			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin7 ,aPosObj[1,1] + _nCol1 + 70	   		COMBOBOX SWAP      ITEMS _aYN      	When _lSwap                valid AltCabec("SWAP")                          			 			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin7 ,aPosObj[1,1] + _nCol2 + 70	   		COMBOBOX ENCOS     ITEMS _aYN      	When _lEncOS                                                                		 			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin8 ,aPosObj[1,1] + _nCol1 + 70	   		MSGET    IMEINOVO                  	When _lSwap2               valid AltCabec("IMEINOVO")                        		 			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin8 ,aPosObj[1,1] + _nCol2 + 70	   		MSGET    MODIMEIN                  	When _lSwap2    F3 "SB1"   valid (Vazio() .or. ExistCpo("SB1")) .And. AltCabec("MODIMEIN")		SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin9 ,aPosObj[1,1] + _nCol1 + 70	   		MSGET    DPYINOVO                  	When _lSwap2    F3 "SB1"   valid (Vazio() .or. ExistCpo("SB1")) .And. AltCabec("DPYINOVO")		SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin9 ,aPosObj[1,1] + _nCol2 + 70	   		MSGET    FGONGO                    	When _lgongo    F3 "ZR"    valid AltCabec("GONOGO")	                        		 			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin9,	aPosObj[1,1]+ _nCol2 + 200	        MSGET    _cNumdoc                  	When _lNumdoc               Valid Empty(_cNumDoc) .OR. FvldDoc() SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin10,aPosObj[1,1] + _nCol1 + 70	   		COMBOBOX UPGRAD    ITEMS _aYN      	When _lSwap2                                                                 		 			SIZE 070,7 PIXEL OF oDlg
@ aPosObj[1,1]+_nLin10,aPosObj[1,1] + _nCol2 + 70	   		MSGET    IMEI                      	When _lAltera              valid BlqImei(IMEI) .And. AltCabec("IMEI") .And. oGet:ForceRefresh()	SIZE 070,7 PIXEL OF oDlg

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],3,,,"+SEQ",_lDelet,,,.F.,1,,,,)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||U_STATUSOK(1),IIf(_lscreen,.F.,oDlg:End())},{||U_GRAVA(), oDlg:End()},,{{'DBG06',{|| U_AddPartNO(2,.T.)},'Part. No.'},{'EDITABLE',{|| U_ADDPECAF(2)},'Pcs. Falt.'},{'AGENDA',{|| HISTIMEI()},'Histórico Imei'}}) 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADDPARTNO ºAutor  ³Edson B. - ERP Plus º Data ³  30/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para chamar rotina de inclusao de PartNo             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ADDPARTNO(_nOpc,_lADDPARTNO)

Local _nPosIMEI  := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "IMEI"})
Local _nPosOS    := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "OS"})
Local _nPosSeq   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "SEQ"})
Local _nPosSet1  := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODSET"})
Local _nPosfas1  := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "FASEO"})

_aAreaZZ1 := ZZ1->(GetArea())
_aAreaZZ3 := ZZ3->(GetArea())
aSavAcolsZZ3 := aClone(aCols)
aSavAcolsZZ3 := aClone(aHeader)

If _lADDPARTNO
	If _nOpc == 1 //Dispara Automatico ao colocar IMEI
		_cNrOS := Posicione("ZZ4",4,xFilial("ZZ4") + IMEI + "3","ZZ4_OS")
		_cNrOS := iif(Empty(_cNrOS), Posicione("ZZ4",4,xFilial("ZZ4") + IMEI + "4","ZZ4_OS"), _cNrOS)
		U_TECAX017(_cNrOS, CODTEC, IMEI, SEQ,@_lobripart) //OS + CODTEC + IMEI + SEQ
	ElseIf _nOpc == 2 //Quando aperta o Botao da enchoice
		
		If ReadVar(N) = "" //Se estiver posicionado no aCols
			//Inclusao validacoes abaixo - Edson rodrigues - 28/07/10
			_csetori1   := iif("/" $ ALLTRIM(aCols[N,_nPosSet1]), left(AllTrim(aCols[N,_nPosSet1]), at("/",AllTrim(aCols[N,_nPosSet1]))-1), AllTrim(aCols[N,_nPosSet1]))
			_cfaseor1   := iif("/" $ ALLTRIM(aCols[N,_nPosfas1]), left(AllTrim(aCols[N,_nPosfas1]), at("/",AllTrim(aCols[N,_nPosfas1]))-1), AllTrim(aCols[N,_nPosfas1]))
			ZZ1->(dbSetOrder(1))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
			If ZZ1->(dbSeek(xFilial("ZZ1") + LAB + AllTrim(_csetori1) +  AllTrim(_cfaseor1)))
				_cinfprtn:=ZZ1->ZZ1_PARTNR
			Else
				_cinfprtn:='0'
			EndIf
			If !_cinfprtn='0'
				U_TECAX017(aCols[N,_nPosOS], CODTEC, aCols[N,_nPosIMEI],aCols[N,_nPosSeq],@_lobripart) //OS + CODTEC + IMEI + SEQ
				SZ9->(dbSetOrder(1))//Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM
				If SZ9->(dbSeek(xFilial("SZ9") + aCols[N,_nPosOS] + CODTEC + aCols[N,_nPosSeq]))
					_aRecnoSZ9:={}
					While (SZ9->Z9_NUMOS == aCols[N,_nPosOS] .And. (SZ9->Z9_CODTEC == CODTEC) .And. (SZ9->Z9_SEQ == aCols[N,_nPosSeq]))
						Aadd(_aRecnoSZ9, SZ9->(Recno()))
						SZ9->(dbSkip())
					EndDo
				Endif
				
				If len(_aRecnozz3) > 0 .And. len(_aRecnoSZ9) > 0
					dbselectarea("ZZ3")
					ZZ3->(dbSetOrder(1))  // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
					If (dbSeek(xFilial("ZZ3") + aCols[N,_nPosIMEI] + aCols[N,_nPosOS]  + aCols[N,_nPosSeq]  ))
						_nrcolszz3:=Ascan(_aRecnozz3, {|X| X[1] =ZZ3->(Recno())})
						If _nrcolszz3 > 0
							_aRecnozz3[_nrcolszz3,2] := _aRecnoSZ9
						Endif
					EndIf
				EndIf
			Else
				Aviso("Part.no Proibido","É Proibida a Inclusao de Part.no para a Fase apontada nesse IMEI/OS : "+AllTrim(aCols[N,_nPosIMEI])+"/"+AllTrim(aCols[N,_nPosOS])+".",{"OK"})
			EndIf
			
		Else
			apMsgInfo("Caro usuário, posicione no IMEI desejado para habilitar a rotina de apontamento de Part Numbers","Posicionar no IMEI desejado")
		EndIf
	EndIf
Else
	Aviso("Part.no Proibido","É Proibida a Inclusao de Part.no para a Fase Atual",{"OK"})
EndIf

restarea(_aAreaZZ1)
restarea(_aAreaZZ3)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADDPECAF  ºAutor  ³Edson Rodrigues-BGH º Data ³  25/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para chamar rotina de inclusao de Pecas Faltantes    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ADDPECAF(_nOpc)

Local _nPosIMEI := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "IMEI"})
Local _nPosOS   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "OS"})
Local _nPosSeq	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "SEQ"})
Local _nPosSet1 := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODSET"})
Local _nPosfas1 := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "FASEO"})

_aAreaZZ1 := ZZ1->(GetArea())
_aAreaZZ3 := ZZ3->(GetArea())

aSavAcolsZZ3 := aClone(aCols)
aSavAcolsZZ3 := aClone(aHeader)

If _lADDPECAF
	If _nOpc == 1 //Dispara Automatico ao colocar IMEI
		_cNrOS := Posicione("ZZ4",4,xFilial("ZZ4") + IMEI + "3","ZZ4_OS")
		_cNrOS := iif(Empty(_cNrOS), Posicione("ZZ4",4,xFilial("ZZ4") + IMEI + "4","ZZ4_OS"), _cNrOS)
		U_TECAX022(_cNrOS, CODTEC, IMEI, SEQ,_lobrigpf) //OS + CODTEC + IMEI + SEQ
	ElseIf _nOpc == 2 //Quando aperta o Botao da enchoice
		If ReadVar(N) = "" //Se estiver posicionado no aCols
			//Inclusao validacoes abaixo - Edson rodrigues - 28/07/10
			_csetori1   := iif("/" $ ALLTRIM(aCols[N,_nPosSet1]), left(AllTrim(aCols[N,_nPosSet1]), at("/",AllTrim(aCols[N,_nPosSet1]))-1), AllTrim(aCols[N,_nPosSet1]))
			_cfaseor1   := iif("/" $ ALLTRIM(aCols[N,_nPosfas1]), left(AllTrim(aCols[N,_nPosfas1]), at("/",AllTrim(aCols[N,_nPosfas1]))-1), AllTrim(aCols[N,_nPosfas1]))
			ZZ1->(dbSetOrder(1))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
			If ZZ1->(dbSeek(xFilial("ZZ1") + LAB + AllTrim(_csetori1) +  AllTrim(_cfaseor1)))
				_cpecfal:=ZZ1->ZZ1_PECFAL
			Else
				_cpecfal:='N'
			EndIf
			
			If _cpecfal='S'
				U_TECAX022(aCols[N,_nPosOS], CODTEC, aCols[N,_nPosIMEI],aCols[N,_nPosSeq],_lobrigpf) //OS + CODTEC + IMEI + SEQ
				ZZ7->(dbSetOrder(1))//Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM
				If ZZ7->(dbSeek(xFilial("ZZ7") + aCols[N,_nPosOS] + CODTEC + ZZ3->ZZ3_SEQ))
					_aRecnoZZ7:={}
					While ((ZZ7->ZZ7_NUMOS == aCols[N,_nPosOS]) .And. (ZZ7->ZZ7_CODTEC == ZZ3->ZZ3_CODTEC) .And. (ZZ7->ZZ7_SEQ == ZZ3->ZZ3_SEQ))
						Aadd(_aRecnoZZ7, ZZ7->(Recno()))
						ZZ7->(dbSkip())
					EndDo
				Endif
				
				If len(_aRecnozz3) > 0 .And. len(_aRecnoZZ7) > 0
					dbselectarea("ZZ3")
					ZZ3->(dbSetOrder(1))  // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
					If (dbSeek(xFilial("ZZ3") + aCols[N,_nPosIMEI] + aCols[N,_nPosOS]+aCols[N,_nPosSeq] ))
						_nrcolszz7:=Ascan(_aRecnozz3, {|X| X[1] =ZZ3->(Recno())})
						If _nrcolszz7 > 0
							_aRecnozz3[_nrcolszz7,4] := _aRecnoZZ7
						Endif
					EndIf
				EndIf
			Else
				Aviso("Cadastro de Peca Faltante Proibido","É Proibida a Inclusao de Peca faltante a Fase apontada nesse IMEI/OS : "+AllTrim(aCols[N,_nPosIMEI])+"/"+AllTrim(aCols[N,_nPosOS])+".",{"OK"})
			EndIf
		Else
			apMsgInfo("Caro usuário, posicione no IMEI desejado para habilitar a rotina de Pecas Faltantes","Posicionar no IMEI desejado")
		EndIf
	EndIf
Else
	Aviso("Part.no Proibido","É Proibida a Inclusao de Peças.Faltantes na Fase Atual",{"OK"})
EndIf

restarea(_aAreaZZ1)
restarea(_aAreaZZ3)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltCabec  ºAutor  ³Edson B. - ERP Plus º Data ³  05/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza campos do cabecalho                                º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AltCabec(_cTab)

Local _lRet      	:= .T.
Local _nPosSeq   	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "SEQ"  	})
Local _nPosIMEI  	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "IMEI" 	})
Local _nPosDPYIM 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DPYIMEI"})
Local _nPosOS    	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "OS"   	})
Local _nPoslote  	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "LOTEIRL"})
Local _nPosctroc 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CONTROC"})
Local _nPosHora  	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "HORA" 	})
Local _nPosdata  	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DATA" 	})
Local _nPosEncOS 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ENCOS"	})
Local _nPosIMEIN 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "IMEIN"	})
Local _nPosSet1  	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODSET"	})
Local _nPosFaseO 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "FASEO"	})
Local _nPosSet2  	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODSE2"	})
Local _nPosFaseD 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "FASED"	})
Local _nPosDefIn 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DEFIN"	})
Local _nPosDefCo 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DEFCO"	})
Local _nPosSolucao	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "SOLUCAO"	})
Local _nPosLaudo 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "LAUDO"	})
Local _nPosCor   	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "COR"  	})
Local _nPosSerie 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "SERIE"  	})
Local _nPosarti  	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ARTIME"  })
Local _cQryTrPtn

Private lRetIR		:= ""


// Verifica se Habilita ou Nao Edicao do documento de separacao
_cSetAtu := LEFT(CODSET,6)
_cFasAtu := LEFT(FAS1,2)
_cSetDes := LEFT(CODSE2,6)
_cFasDes := LEFT(FAS2,2)
_cDocObAt:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + _cSetAtu + _cFasAtu + SPACE(04),"ZZ1_DOCSEP")  
_cDocObDe:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + _cSetDes + _cFasDes + SPACE(04),"ZZ1_DOCSEP")  
If _cDocObAt == "S"  .AND. _cDocObDe == "S" 
   _lNumDoc := .T.
Else
   _lNumDoc := .F.
Endif

//
Do Case
	
	Case _cTab == "AA1"
		cCliente := SPACE(6)
		cLoja := SPACE(2)
		
		_lRet := !Empty(CODTEC)
		
		If (lUsrNext .Or. lUsrAdmi) .And. !Empty(CODANA)
			
			if Posicione("AA1",1,xFilial("AA1") + CODANA, "AA1_ALOCA") == "2"
				_lRet := .F.
				apMsgStop("Técnico indisponível para atendimento de OS. Por favor, contate seu supervisor!", "Técnico indisponível")
			endif
			
		Else
			
			if Posicione("AA1",1,xFilial("AA1") + CODTEC, "AA1_ALOCA") == "2"
				_lRet := .F.
				apMsgStop("Técnico indisponível para atendimento de OS. Por favor, contate seu supervisor!", "Técnico indisponível")
			endif
			
		EndIf
		//____________________________________________________________________________________________________________________________________
		//Verifica se usuário tem algum algum apontamento nao confirmado
		
		_aAreaZZ3 := ZZ3->(GetArea())
		_aAreaAA1 := AA1->(GetArea())
		_aAreaZZ1 := ZZ1->(GetArea())
		_aAreaZZ4 := ZZ4->(GetArea())
		
		ZZ4->(dbsetOrder(1))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
		
		If (lUsrNext .Or. lUsrAdmi) .And. !Empty(CODANA)
		
			_lCodAna:= iif(AllTrim(CODANA) $ "C11/C12/C13/C21/C22/C23/C31/C32",.F.,.T.) && Thomas Galvão - GPLI ID 7669 - 03/08/12
			
			AA1->(dbSetOrder(1))  // AA1_FILIAL + AA1_CODTEC
			AA1->(dbSeek(xFilial("AA1") + CODANA))
			
		Else
			
			// Pega informacoes do cadastro de TECNICOS
			AA1->(dbSetOrder(1))  // AA1_FILIAL + AA1_CODTEC
			AA1->(dbSeek(xFilial("AA1") + CODTEC))
			
		EndIf
		
		_cLab   := AA1->AA1_LAB
		lCliente := Iif(AA1->(FIELDPOS("AA1_INFCLI")) > 0, IIf(AA1->AA1_INFCLI='1',.T.,.F.),.F.)
		_cSetor := AA1->AA1_CODSET
		
		If (lUsrNext .Or. lUsrAdmi) .And. !Empty(CODANA)
			
			If Empty(_cSetor)
				_cSetor := Posicione("ZZB",1,xFilial("ZZB")+CODANA+_cLab,"ZZB_CODSET") //Alterado variaverl LAB p/ clab, Edson Rodrigues 17/03
			Endif
			
		Else
			
			If Empty(_cSetor)
				_cSetor := Posicione("ZZB",1,xFilial("ZZB")+CODTEC+_cLab,"ZZB_CODSET") //Alterado variaverl LAB p/ clab, Edson Rodrigues 17/03
			Endif
			
		Endif
		
		_cFase  := AA1->AA1_CODFAS
		LAB     := _cLab
		CODSET  := _cSetor
		FAS1    := _cFase
		
		// Pega informacoes do cadastro de FASES
		ZZ1->(dbSetOrder(1))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
		ZZ1->(dbSeek(xFilial("ZZ1") + LAB + CODSET + FAS1))
		
		//ZZ3->(dbSetOrder(2)) //ZZ3_FILIAL, ZZ3_CODTEC, ZZ3_LAB, ZZ3_CODSET, ZZ3_FASE1, ZZ3_STATUS
		ZZ3->(dbSetOrder(3)) //ZZ3_FILIAL, ZZ3_LAB, ZZ3_CODTEC, ZZ3_STATUS, DTOS(ZZ3_DATA), ZZ3_HORA
		
		//If ZZ3->(dbSeek(xFilial("ZZ3") + CODTEC + _cLab + _cSetor + _cFase + '0'))
		If ZZ3->(dbSeek(xFilial("ZZ3") + _cLab + CODTEC + '0'))
			If ApMsgYesNo("Existem apontamentos não confirmados para este código de técnico. Deseja visualizar estes apontamentos? Caso os apontamentos existentes não sejam tratados neste momento, os mesmos serão apagados.","Apontamentos existentes")
				Begin transaction
				While ZZ3->(!eof()) .And. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .And. ZZ3->ZZ3_LAB == _cLab .And. ;
					ZZ3->ZZ3_CODTEC == CODTEC .And. ZZ3->ZZ3_STATUS == '0'
					If !ZZ3->ZZ3_STATRA='1' // Ve se o aparelho esta sendo usado por algum outro usuario nesse mesmo tecnico. Edson Rodrigues - 28/07/10
						
						//Verificac se aCols esta vazio. Se não estiver adiciona uma linha
						If _lNewline .And. _lREGACOLS
							aAdd( aCols, Array(Len(aHeader)+1))
							For _ni := 1 to Len(aHeader)
								if aHeader[_ni,8] == 'C'
									aCols[Len(aCols),_ni] := ""
								ElseIf aHeader[_ni,8] == 'D'
									aCols[Len(aCols),_ni] := date()
								ElseIf aHeader[_ni,8] == 'N'
									aCols[Len(aCols),_ni] := 0
								else
									aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2],.T.)
								endif
							Next
							aCols[Len(aCols),Len(_aCabec)+1] := .F. // Nao esta deletado
							
						Elseif  !len(acols) > 0 // Adicionado devido erro apresentado em 29/11/11 as 00:20 -Edson rodrigues
							aAdd( aCols, Array(Len(aHeader)+1))
							For _ni := 1 to Len(aHeader)
								if aHeader[_ni,8] == 'C'
									aCols[Len(aCols),_ni] := ""
								ElseIf aHeader[_ni,8] == 'D'
									aCols[Len(aCols),_ni] := date()
								ElseIf aHeader[_ni,8] == 'N'
									aCols[Len(aCols),_ni] := 0
								else
									aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2],.T.)
								endif
							Next
							aCols[Len(aCols),Len(_aCabec)+1] := .F. // Nao esta deletado
							_lREGACOLS := .T.
						Else
							_lREGACOLS := .T.
						EndIf
						
						aCols[len(aCols),_nPosSeq]   := ZZ3->ZZ3_SEQ
						aCols[len(aCols),_nPosIMEI]  := ZZ3->ZZ3_IMEI
						aCols[len(aCols),_nPosDPYIM] := ZZ3->ZZ3_DPYIME
						aCols[len(aCols),_nPosOS]    := ZZ3->ZZ3_NUMOS
						aCols[len(aCols),_nPoslote]  := ZZ3->ZZ3_LOTIRL
						aCols[len(aCols),_nPosdata]  := ZZ3->ZZ3_DATA
						aCols[len(aCols),_nPosHora]  := ZZ3->ZZ3_HORA
						aCols[len(aCols),_nPosEncOS] := ZZ3->ZZ3_ENCOS
						aCols[len(aCols),_nPosIMEIN] := ZZ3->ZZ3_IMEISW
						aCols[len(aCols),_nPosctroc] := ZZ3->ZZ3_CTROCA
						aCols[len(aCols),_nPosSet1]  := ZZ3->ZZ3_CODSET
						aCols[len(aCols),_nPosFaseO] := ZZ3->ZZ3_FASE1
						aCols[len(aCols),_nPosSet2]  := ZZ3->ZZ3_CODSE2
						aCols[len(aCols),_nPosFaseD] := ZZ3->ZZ3_FASE2
						aCols[len(aCols),_nPosDefIn] := ZZ3->ZZ3_DEFINF
						aCols[len(aCols),_nPosDefCo] := ZZ3->ZZ3_DEFDET
						
						If lUsrNext .Or. lUsrAdmi
							aCols[len(aCols),_nPosSolucao] := ZZ3->ZZ3_ACAO
						Else
							aCols[len(aCols),_nPosLaudo] := ZZ3->ZZ3_LAUDO
						EndIf
						
						aCols[len(aCols),_nPosarti]  := ZZ3->ZZ3_ARTIME
						_cCor   := posicione("ZZ4",1,xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6),"ZZ4_COR")
						aCols[len(aCols),_nPosCor]   := iif(!Empty(_cCor), AllTrim(upper(_cCor)) + " / " + TABELA("Z3", upper(_cCor), .F.), ZZ3->ZZ3_COR)
						_cSerie := posicione("ZZ4",1,xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6),"ZZ4_CARCAC")
						aCols[len(aCols),_nPosSerie] := iif(!Empty(_cSerie), AllTrim(_cSerie), ZZ4->ZZ4_CARCAC)
						
						//Adiciona ao array RecnoZ9 todos os registros do SZ9 que estao relacionados com os registros recuperados
						//do ZZ3
						SZ9->(dbSetOrder(1))//Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM
						if SZ9->(dbSeek(xFilial("SZ9") + ZZ3->ZZ3_NUMOS + ZZ3->ZZ3_CODTEC + ZZ3->ZZ3_SEQ))
							While (SZ9->Z9_NUMOS == ZZ3->ZZ3_NUMOS) .And. (SZ9->Z9_CODTEC == ZZ3->ZZ3_CODTEC) .And. (SZ9->Z9_SEQ == ZZ3->ZZ3_SEQ)
								Aadd(_aRecnoSZ9, SZ9->(Recno()))
								SZ9->(dbSkip())
							EndDo
						endif
						
						//Adiciona ao array RecnoZZ7 todos os registros do ZZ7 que estao relacionados com os registros recuperados
						//do ZZ3
						ZZ7->(dbSetOrder(1))//Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM
						if ZZ7->(dbSeek(xFilial("ZZ7") + ZZ3->ZZ3_NUMOS + ZZ3->ZZ3_CODTEC + ZZ3->ZZ3_SEQ))
							While (ZZ7->ZZ7_NUMOS == ZZ3->ZZ3_NUMOS) .And. (ZZ7->ZZ7_CODTEC == ZZ3->ZZ3_CODTEC) .And. (ZZ7->ZZ7_SEQ == ZZ3->ZZ3_SEQ)
								Aadd(_aRecnoZZ7, ZZ7->(Recno()))
								ZZ7->(dbSkip())
							EndDo
						endif
						
						aadd(_aRecnoZZ3, {ZZ3->(Recno()), _aRecnoSZ9, ZZ4->(recno()),_aRecnoZZ7 } )
						
						//grava status 1 para ninguém mais usar esse registro enquanto estiver em array/acols
						reclock("ZZ3",.F.)
						ZZ3->ZZ3_STATRA :='1'
						ZZ3->ZZ3_USER   := cUserName
						msunlock()
						
						_aRecnoSZ9 := {}
						_aRecnoZZ7 := {}
						
					Else
						If ALLTRIM(ZZ3->ZZ3_USER)=ALLTRIM(cUserName)
							MsgAlert("O IMEI/OS : "+ALLTRIM(ZZ3->ZZ3_IMEI)+"/"+ALLTRIM(ZZ3->ZZ3_NUMOS)+" esta em sendo apontado no tecnico :"+AllTrim(ZZ3->ZZ3_CODTEC)+" pelo seu usuário : "+AllTrim(ZZ3->ZZ3_USER)+".","Apontamento em Uso")
							If ApMsgYesNo("Se Voce tem ABSOLUTA certeza que nao tem ninguem conectado com o seu USUARIO apontando O IMEI/OS: "+ALLTRIM(ZZ3->ZZ3_IMEI)+"/"+ALLTRIM(ZZ3->ZZ3_NUMOS)+" com esse tecnico "+AllTrim(ZZ3->ZZ3_CODTEC)+", entao clique [SIM] para liberar esse IMEI, saia e entre nessa tela novamente para visualiza-lo e confirmar o apontamento, ou caso contrario clique em [NAO].","Confirmacao de Apontamentos em uso")
								//grava status 0 e libera o registro
								reclock("ZZ3",.F.)
								ZZ3->ZZ3_STATRA :='0'
								ZZ3->ZZ3_USER   := cUserName
								msunlock()
							Endif
							
						Else
							MsgAlert("O IMEI/OS : "+ALLTRIM(ZZ3->ZZ3_IMEI)+"/"+ALLTRIM(ZZ3->ZZ3_NUMOS)+" esta em sendo apontado no tecnico :"+AllTrim(ZZ3->ZZ3_CODTEC)+" pelo usuário : "+AllTrim(ZZ3->ZZ3_USER)+".","Apontamento em Uso")
							MsgAlert("Saia e entre nessa tela novamente com o usuario : "+AllTrim(ZZ3->ZZ3_USER)+" se quiser liberar esse IMEI/OS : "+ALLTRIM(ZZ3->ZZ3_IMEI)+"/"+ALLTRIM(ZZ3->ZZ3_NUMOS)+".","Dica para liberar o aparelho em uso")
						EndIf
					EndIf
					
					ZZ3->(dbSkip())
				EndDo
				End transaction
				//Incluso IF - Edson Rodrigues - 29/11/11
				IF !oGet==NIL
					oGet:ForceRefresh()
				ENDIF
			Else
				Begin Transaction //Incluso edson Rodrigues - 21/05/10
				_cQuery :=""
				_nreczz3:=0
				While ZZ3->(!eof()) .And. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .And. ;
					ZZ3->ZZ3_LAB == _cLab .And.  ;
					ZZ3->ZZ3_CODTEC == CODTEC .And.  ZZ3->ZZ3_STATUS = '0'
					
					//Incluso Edson Rodrigues - 18/06/10
					_nreczz3:=ZZ3->(recno())
					
					//Permite so deletar e voltar o status da transacao dos aparelhos forem do mesmo usuário ou nao estiverem em uso- Edson Rodrigues
					If (ZZ3->ZZ3_STATRA ='0') .OR. (ZZ3->ZZ3_STATRA ='1' .And. ALLTRIM(ZZ3->ZZ3_USER)=ALLTRIM(cUserName))
						
						//Retirado linhas de códigos e incluso funcao Edson Rodrigues - 28/07/10
						U_EXCLAPO2(_nreczz3)
						
						//Adicionado por Edson Rodrigues, pois o aparelho não retornava a fase atual no zz4 quando não se confirmava o apontamento -19/05/09
						_cQuery :=" SELECT ZZ3_FASE2,ZZ3_CODSE2,R_E_C_N_O_ FROM "+RetSqlName("ZZ3")+"  (NOLOCK) INNER JOIN "
						_cQuery +=" (SELECT ZZ3_NUMOS,ZZ3_IMEI,MAX(R_E_C_N_O_) AS RECNO FROM "+RetSqlName("ZZ3")+"  (NOLOCK) "
						_cQuery +=" WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND ZZ3_IMEI='"+LEFT(ZZ3->ZZ3_IMEI,15)+"' AND ZZ3_NUMOS='"+LEFT(ZZ3->ZZ3_NUMOS,6)+"' AND ZZ3_SEQ < '"+ZZ3->ZZ3_SEQ+"' AND D_E_L_E_T_='' "
						_cQuery +=" GROUP BY ZZ3_NUMOS,ZZ3_IMEI ) AS ZZ3_2 ON R_E_C_N_O_=RECNO "
						
						TCQUERY _cQuery ALIAS "QryZZ3" NEW
						
						If Select("QryZZ3") > 0 .And. !QryZZ3->(EOF())
							
							If ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + LEFT(ZZ3->ZZ3_NUMOS,6)))
								reclock("ZZ4",.F.)
								ZZ4->ZZ4_SETATU :=QryZZ3->ZZ3_CODSE2
								ZZ4->ZZ4_FASATU :=QryZZ3->ZZ3_FASE2
								msunlock()
							Endif
						Else
							If ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + LEFT(ZZ3->ZZ3_NUMOS,6)))
								reclock("ZZ4",.F.)
								ZZ4->ZZ4_SETATU :=""
								ZZ4->ZZ4_FASATU :=""
								ZZ4->ZZ4_STATUS :="3"
								msunlock()
							Endif
						Endif
						
						ZZ3->(dbgoto(_nreczz3))
						reclock("ZZ3",.F.)
						ZZ3->ZZ3_STATRA :='0'
						ZZ3->ZZ3_USER   := cUserName
						msunlock()
						
						reclock("ZZ3",.F.)
						dbDelete()
						msunlock()
						U_GRVLOGFA("001")
						
						If Select("QryZZ3") > 0
							QryZZ3->(dbCloseArea())
						Endif
					Endif
					ZZ3->(dbSkip())
				Enddo
				End transaction
			EndIf
			
		Endif
		
		restarea(_aAreaZZ3)
		
		//____________________________________________________________________________________________________________________________________
		
		//Variavel _lFase se ha fase ou nao
		_lFase := !Empty(FAS1)
		
		//Verifica se preenche Defeito Informado pelo cliente ou nao
		//_cautdefinf :=Posicione("ZZJ",2,xFilial("ZZJ")+LAB, "ZZJ_DEFINF")
		_lDefInf := iif(ZZ1->ZZ1_DEFINF == "S" .And. _lAltera .And. _lFase,.T.,.F.)
		//_lDefInf := iif(AllTrim(_cautdefinf) == "S" .And. _lAltera .And. _lFase,.T.,.F.)
		DEFINF   := CriaVar("ZZ3_DEFINF"   ,.F.)
		
		//Verifica se preenche Defeito Detectado pela BGH ou nao
		_lDefDet := iif(ZZ1->ZZ1_DEFDET == "S" .And. _lAltera .And. _lFase,.T.,.F.)
		DEFDET   := CriaVar("ZZ3_DEFDET"   ,.F.)
		
		//Verifica se preenche laudo ou nao
		_lLaudo  := iif(ZZ1->ZZ1_LAUDO == "S" .And. _lAltera .And. _lFase,.T.,.F.)
		
		//Verifica se preenche Solucao ou nao
		_lSolucao  := iif(ZZ1->ZZ1_LAUDO == "S" .And. _lAltera .And. _lFase,.T.,.F.)
		_cGrava	   := _lSolucao
		
		//Verifica se preenche Cor ou nao
		_lCor    := iif(ZZ1->ZZ1_COR   == "S" .And. _lAltera .And. _lFase,.T.,.F.)
		
		//Verifica se a fase pode encerrar a OS
		ENCOS   	:= iif(_lFase,ZZ1->ZZ1_ENCOS," ")
		_lEncOsMsg 	:= iif(ZZ1->ZZ1_ENCOS == "S" .And. _lAltera .And. _lFase ,.T.,.F.)
		_lEncOs 	:= iif(ZZ1->ZZ1_ENCOS == "S" .And. _lAltera .And. _lFase .And. _lCodAna,.T.,.F.)
		
		//Verifica se ha Swap ou nao
		SWAP    := iif(_lFase,ZZ1->ZZ1_SWAP," ")
		_lSwap2 := _lSwap := iif(ZZ1->ZZ1_SWAP == "S" .And. _lAltera .And. _lFase,.T.,.F.)
		
		//FAS1Ori   := FAS1                         ,
		FAS1Ori   := iif("/" $ ALLTRIM(FAS1), left(AllTrim(FAS1), at("/",AllTrim(FAS1))-1), AllTrim(FAS1)) //LEFT(FAS1,6)
		CODSETOri := CODSET
		XCODSET   := CODSETOri
		FAS1      += " / " + ALLTRIM(ZZ1->ZZ1_DESFA1)
		CODSET    += " / " + Posicione("ZZ2",1,xFilial("ZZ2") + LAB + CODSET, "ZZ2_DESSET" )
		
		_ctransIMEI :=Posicione("ZZJ",2,xFilial("ZZJ")+LAB, "ZZJ_TRAIME")
		_cobrdefdet :=Posicione("ZZJ",2,xFilial("ZZJ")+LAB, "ZZJ_DEFDOB")
		_cobrdefcli :=Posicione("ZZJ",2,xFilial("ZZJ")+LAB, "ZZJ_DEFCOB")
		
		//if LAB == '1' // A Sony nao transfere IMEIS de um setor para outro
		//Alterado esse If, Edson Rodrigues 15/04/10
		If _ctransIMEI="N"
			CODSE2ORI := CODSETORI
			CODSE2    := CODSET
			_SetDest  := .F.
		Else
			_SetDest  := .T.
			CODSE2ORI := CODSE2
			_cDescSet := iif(!Empty(CODSE2), posicione("ZZ2",1,xfilial("ZZ2")+LAB+CODSE2,"ZZ2_DESSET"), "")
			If !Empty(_cDescSet)
				CODSE2 := Alltrim(CODSE2) + " / " + _cDescSet
			EndIf
		Endif
		
		If ZZ1->ZZ1_PARTNR == "0"  //Verifica se para o IMEI informado é proibida a inclusao de part no.
			_lADDPARTNO := .F.
		Else
			_lADDPARTNO := .T.
		EndIf
		
		// Nao acrescentado essa regra na tabela ZZJ-Parametros de processo industriais BGH, por ser
		// muito especifico para sony e sua reportologia - Edson Rodrigues 15/04/10
		_lgongo :=  iif(ALLTRIM(LAB) =='1' .And. ALLTRIM(ZZ1->ZZ1_FASE1) $ "03/22" .And. _lAltera .And. _lFase,.T.,.F.)
		If !_lgongo
			FGONGO := "000001"
		Endif
		
		_FaseDest := .T.
		FAS2 := CriaVar("ZZ3_FASE2",.F.)
		
	Case _cTab == "Z81" //.And. Left(CODSET,6) == "000000"
		If !Empty(DEFDET).And. SX5->(dbSeek(xFilial("SX5") + "W7" + UPPER(ALLTRIM(DEFDET))))
			DEFDET := Alltrim(UPPER(DEFDET)) + " / " + ALLTRIM(UPPER(SX5->X5_DESCRI))
			/*_lSolu 		:=Posicione("SZ8",3,xFilial("SZ8") + LEFT(DEFDET,5), "Z8_DESSINT" )
			DEFDET  	:= Alltrim(LEFT(DEFDET,5)) + " / " + ALLTRIM(_lSolu)*/
			If !Empty(DEFDET)
				_lRet := .T.
			Else
				apMsgStop("Código de Defeito Constatado não cadastrado.", "Código Invalido")
				_lRet := .F.
			Endif
		Else
			apMsgStop("Necessario Código de Defeito Constatado.", "Código Invalido")
			_lRet := .F.
		EndIf
	Case _cTab == "Z82" //.And. Left(CODSET,6) == "000000"
		If !Empty(DEFINF)
			dbSelectArea("SZ8")
			dbSetOrder(1)
			If  SZ8->(dbSeek(xFilial("SZ8") + LAB + LEFT(DEFINF,5)))
				_cDEFINF :=SZ8->Z8_DESSINT
				DEFINF  := Alltrim(LEFT(DEFINF,5)) + " / " + ALLTRIM(_cDEFINF)
				_lRet := .T.
			Else
				apMsgStop("Código de Reclamação do Cliente não cadastrado.", "Código Invalido")
				DEFINF  := CriaVar("ZZ3_DEFINF"   ,.F.)
				_lRet := .F.
			EndIf
		Else
			apMsgStop("De acordo com as regras do laboratorio e obrigatorio informar o Defeito do Cliente para upload no SIX.", "Def. Cliente Invalido")
			DEFINF  := CriaVar("ZZ3_DEFINF"   ,.F.)
			_lRet := .F.
		Endif
	Case _cTab == "SZ8" //.And. Left(CODSET,6) == "000000"
		
		lSolu := Posicione("SZL",4,xFilial("SZL")+ LAB + Left(DEFDET,5) +  LEFT(SOLUCAO,5), "ZL_DESCPTB")
		
		If !Empty(lSolu)
			
			_lSolu := Posicione("SZM",1,xFilial("SZM")+  LEFT(SOLUCAO,5), "ZM_DESCPTB")
			
			If !Empty(SOLUCAO) .And. !Empty(_lSolu)
				//	_lSolu 		:=Posicione("SZL",1,xFilial("SZL") + LAB + LEFT(SOLUCAO,5), "ZL_DESCSIN" )
				SOLUCAO  	:= Alltrim(LEFT(SOLUCAO,5)) + " / " + ALLTRIM(_lSolu)
				If !Empty(_lSolu)
					_lRet := .T.
				Else
					apMsgStop("Código de Solução não cadastrado.", "Código Invalido")
					_lRet := .F.
				EndIf
			Else
				apMsgStop("Código de Solução não cadastrado.", "Código Invalido")
				_lRet := .F.
			EndIf
		Else
			apMsgStop("Código de Solução não confere.", "Código Invalido")
			_lRet := .F.
		EndIf
		
		//incluso edson Rodrigues para informar o Defeito Reclamado pelo cliente.
	Case _cTab == "ZZG"
		
		_cDEFINF:= ""
		If !Empty(DEFINF)
			ZZG->(dbSetOrder(1)) // ZZG_FILIAL + ZZG_LAB + ZZG_CODIGO
			If  ZZG->(dbSeek(xFilial("ZZG") + LAB + LEFT(DEFINF,5)))
				_cDEFINF :=Posicione("ZZG",1,xFilial("ZZG") + LAB + LEFT(DEFINF,5), "ZZG_DESCRI" )
				DEFINF  := Alltrim(LEFT(DEFINF,5)) + " / " + ALLTRIM(_cDEFINF)
				_cDefMc :=Posicione("ZZG",1,xFilial("ZZG") + LAB + LEFT(DEFINF,5), "ZZG_RECCLI" )
				_cDefSeq := "02"
				_lRet := .T.
			Else
				apMsgStop("Código de Reclamação do Cliente não cadastrado.", "Código Invalido")
				DEFINF  := CriaVar("ZZ3_DEFINF"   ,.F.)
				_lRet := .F.
			EndIf
			
		Else
			
			If _lDEFINF .And. _cobrdefcli='S'
				apMsgStop("De acordo com as regras do laboratorio e obrigatorio informar o Defeito do Cliente.", "Def. Cliente Invalido")
				DEFINF  := CriaVar("ZZ3_DEFINF"   ,.F.)
				_lRet := .F.
			Else
				_lRet := .T.
			Endif
		Endif
	Case _cTab == "ZZG2"
		
		_cDEFDET:= ""
		If !Empty(DEFDET)
			ZZG->(dbSetOrder(1)) // ZZG_FILIAL + ZZG_LAB + ZZG_CODIGO
			If  ZZG->(dbSeek(xFilial("ZZG") + LAB + DEFDET))
				_cDEFDET :=Posicione("ZZG",1,xFilial("ZZG") + LAB + DEFDET, "ZZG_DESCRI" )
				DEFDET  := Alltrim(DEFDET) + " / " + ALLTRIM(_cDEFDET)
				_lRet:= .T.
			Else
				apMsgStop("Código de Reclamação do Cliente não cadastrado.", "Código Invalido")
				DEFDET  := CriaVar("ZZ3_DEFDET"   ,.F.)
				_lRet:= .F.
			EndIf
		Else
			If _lDEFDET .And. _cobrdefdet='S'
				apMsgStop("De acordo com as regras do laboratorio e obrigatorio informar o Defeito detectado.", "Def. detectado Invalido")
				DEFDET  := CriaVar("ZZ3_DEFDET"   ,.F.)
				_lRet := .F.
			Else
				_lRet := .T.
			Endif
		Endif
		
	Case _cTab == "Z3"
		
		_ccor := iif("/" $ ALLTRIM(COR),left(ALLTRIM(COR),AT("/",ALLTRIM(COR))-1),ALLTRIM(COR))
		If !Empty(_ccor) .And. SX5->(dbSeek(xFilial("SX5") + "Z3" + UPPER(ALLTRIM(_ccor))))
			COR := Alltrim(UPPER(_ccor)) + " / " + ALLTRIM(UPPER(SX5->X5_DESCRI))
		Else
			If !Empty(_ccor)
				apMsgStop("Cor nao encontrado no cadastro de tabelas - Z3-Cores","Cor nao encontrada")
				_lRet := .F.
			Endif
		Endif
		
	Case _cTab == "SET2"
		
		If _ctransIMEI="N"
			CODSE2ORI := CODSETORI
			CODSE2    := CODSET
			
			//Adicionado validacao ZZB - Edson Rodrigues - 21/03/09
			If  !Empty(CODSE2)
				
				If (lUsrNext .Or. lUsrAdmi) .And. !Empty(CODANA)
					
					ZZB->(dbSetOrder(1)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODSET + ZZB_CODFAS
					if  !ZZB->(dbSeek(xFilial("ZZB") + CODANA + LAB + left(CODSE2,6)))
						apMsgStop("Setor Destino não cadastrado na amarração Tecnico x Fase ","Setor Destino Invalido")
						_lRet := .F.
					Endif
					
				Else
					
					ZZB->(dbSetOrder(1)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODSET + ZZB_CODFAS
					if  !ZZB->(dbSeek(xFilial("ZZB") + CODTEC + LAB + left(CODSE2,6)))
						apMsgStop("Setor Destino não cadastrado na amarração Tecnico x Fase ","Setor Destino Invalido")
						_lRet := .F.
					Endif
					
				Endif
				
			Else
				apMsgStop("O setor Destino deve ser preenchido","Setor Destino em Branco")
				_lRet := .F.
			Endif
			
		else
			
			//Adicionado validaco ZZB - Edson Rodrigues - 21/03/09
			If  !Empty(CODSE2)
				
				If (lUsrNext .Or. lUsrAdmi) .And. !Empty(CODANA)
					
					ZZB->(dbSetOrder(1)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODSET + ZZB_CODFAS
					if  ZZB->(dbSeek(xFilial("ZZB") + CODANA + LAB + left(CODSE2,6)))
						CODSE2ORI := CODSE2
						_cDescSet := iif(!Empty(CODSE2), posicione("ZZ2",1,xfilial("ZZ2")+LAB+CODSE2,"ZZ2_DESSET"), "")
						If !Empty(_cDescSet)
							CODSE2 := Alltrim(CODSE2) + " / " + _cDescSet
						EndIf
						XCODSET := CODSE2ORI
					Else
						apMsgStop("Setor Destino não cadastrado na amarração Tecnico x Fase ","Setor Destino Invalido")
						_lRet := .F.
					Endif
					
				Else
					
					ZZB->(dbSetOrder(1)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODSET + ZZB_CODFAS
					if  ZZB->(dbSeek(xFilial("ZZB") + CODTEC + LAB + left(CODSE2,6)))
						CODSE2ORI := CODSE2
						_cDescSet := iif(!Empty(CODSE2), posicione("ZZ2",1,xfilial("ZZ2")+LAB+CODSE2,"ZZ2_DESSET"), "")
						If !Empty(_cDescSet)
							CODSE2 := Alltrim(CODSE2) + " / " + _cDescSet
						EndIf
						XCODSET := CODSE2ORI
					Else
						apMsgStop("Setor Destino não cadastrado na amarração Tecnico x Fase ","Setor Destino Invalido")
						_lRet := .F.
					Endif
					
				EndIf
				
			Else
				apMsgStop("O setor Destino deve ser preenchido","Setor Destino em Branco")
				_lRet := .F.
			Endif
		Endif
		
	Case _cTab == "SET1"
		
		//Adicionado validacao ZZB - Edson Rodrigues - 21/03/09
		If  !Empty(CODSET)
			
			If (lUsrNext .Or. lUsrAdmi) .And. !Empty(CODANA)
				
				ZZB->(dbSetOrder(1)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODSET + ZZB_CODFAS
				if  !ZZB->(dbSeek(xFilial("ZZB") + CODANA + LAB + left(CODSET,6)))
					apMsgStop("Setor Atual não cadastrado na amarração Tecnico x Fase ","Setor Atual Invalido")
					_lRet := .F.
				else
					CODSETOri := left(iif('/' $ CODSET, CODSETORI, CODSET),6)
					CODSET    := AllTrim(CODSETORI) + " / " + Posicione("ZZ2",1,xFilial("ZZ2") + LAB + CODSETOri, "ZZ2_DESSET" )
				Endif
				
			Else
				
				ZZB->(dbSetOrder(1)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODSET + ZZB_CODFAS
				if  !ZZB->(dbSeek(xFilial("ZZB") + CODTEC + LAB + left(CODSET,6)))
					apMsgStop("Setor Atual não cadastrado na amarração Tecnico x Fase ","Setor Atual Invalido")
					_lRet := .F.
				else
					CODSETOri := left(iif('/' $ CODSET, CODSETORI, CODSET),6)
					CODSET    := AllTrim(CODSETORI) + " / " + Posicione("ZZ2",1,xFilial("ZZ2") + LAB + CODSETOri, "ZZ2_DESSET" )
				Endif
				
			EndIf
			
		Else
			apMsgStop("O setor Atual deve ser preenchido","Setor Atual em Branco")
			_lRet := .F.
		Endif
		
	Case _cTab == "FAS1"
		
		// Verifica se a Fase informada/digitada corresponde ao tecnico do apontamento
		//FAS1Ori := LEFT(FAS1,2)          //Mudado o tamanho do Left para 2 - Edson Rodrigues em 09/03/09
		FAS1Ori := iif("/" $ ALLTRIM(FAS1),left(ALLTRIM(FAS1),AT("/",ALLTRIM(FAS1))-1),ALLTRIM(FAS1)) // alterado - Edson Rodrigues em 17/03/09
		
		If (lUsrNext .Or. lUsrAdmi) .And. !Empty(CODANA)
			_lRet := u_VerFasTec(CODANA, LAB, FAS1Ori, left(CODSETORI,6))// alterado a variavel FAS1 para a FAS1ORI - Edson Rodrigues em 17/03/09
		Else
			//_lRet := u_VerFasTec(CODTEC, LAB, LEFT(FAS1,2), left(CODSETORI,6))//Incluso o Left de 2 para variavel FAS1 - Edson Rodrigues em 09/03/09
			_lRet := u_VerFasTec(CODTEC, LAB, FAS1Ori, left(CODSETORI,6))// alterado a variavel FAS1 para a FAS1ORI - Edson Rodrigues em 17/03/09
		Endif
		
		if _lRet
			
			_aAreaZZ1 := ZZ1->(GetArea())
			_cfase1   :=AllTrim(FAS1Ori) + Space(6-len(AllTrim(FAS1Ori))) //Incluso Edson Rodrigues - 17/03/09
			
			// Pega informacoes do cadastro de FASES
			ZZ1->(dbSetOrder(1))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
			_lFase := ZZ1->(dbSeek(xFilial("ZZ1") + LAB + left(CODSETORI,6) + _cfase1))
			
			//Verifica se preenche Defeito Informado pelo cliente ou nao
			_lDefInf := iif(ZZ1->ZZ1_DEFINF == "S" .And. _lAltera .And. _lFase,.T.,.F.)
			DEFINF   := CriaVar("ZZ3_DEFINF"   ,.F.)
			
			//Verifica se preenche Defeito Detectado pela BGH ou nao
			_lDefDet := iif(ZZ1->ZZ1_DEFDET == "S" .And. _lAltera .And. _lFase,.T.,.F.)
			DEFDET   := CriaVar("ZZ3_DEFDET"   ,.F.)
			
			//Verifica se preenche Defeito Detectado pela BGH ou nao
			_lLaudo  := iif(ZZ1->ZZ1_LAUDO == "S" .And. _lAltera .And. _lFase,.T.,.F.)
			
			//Verifica se preenche Defeito Detectado pela BGH ou nao
			_lSolucao  := iif(ZZ1->ZZ1_LAUDO == "S" .And. _lAltera .And. _lFase,.T.,.F.)
			_cGrava    := _lSolucao
			
			
			//Verifica se preenche Defeito Informado pelo cliente ou nao
			_lCor    := iif(ZZ1->ZZ1_COR   == "S" .And. _lAltera .And. _lFase,.T.,.F.)
			
			//Verifica se pode Encerrar OS
			ENCOS   := iif(_lFase,ZZ1->ZZ1_ENCOS," ") 
			_lEncOsMsg := iif(ZZ1->ZZ1_ENCOS == "S" .And. _lAltera .And. _lFase,.T.,.F.)
			_lEncOs := iif(ZZ1->ZZ1_ENCOS == "S" .And. _lAltera .And. _lFase .And. _lCodAna,.T.,.F.)
						
			//Verifica se ha Swap ou nao
			SWAP    := iif(_lFase,ZZ1->ZZ1_SWAP," ")
			_lSwap2 := _lSwap := iif(ZZ1->ZZ1_SWAP == "S" .And. _lAltera .And. _lFase,.T.,.F.)
			
			FAS1      += " / " + ALLTRIM(ZZ1->ZZ1_DESFA1)
			If ZZ1->ZZ1_PARTNR == "0"  //Verifica se para o IMEI informado é proibida a inclusao de part no.
				_lADDPARTNO := .F.
			Else
				_lADDPARTNO := .T.
			EndIf
			
			// Nao acrescentado essa regra na tabela ZZJ-Parametros de processo industriais BGH, por ser
			// muito especifico para sony e sua reportologia - Edson Rodrigues 15/04/10
			_lgongo :=  iif(ALLTRIM(LAB) =='1' .And. ALLTRIM(ZZ1->ZZ1_FASE1) $ "03/22" .And. _lAltera .And. _lFase,.T.,.F.)
			If !_lgongo
				FGONGO := "000001"
			Endif
			
			_FaseDest := .T.
			FAS2 := CriaVar("ZZ3_FASE2",.F.)
			
			restarea(_aAreaZZ1)
		Else
			//Adicionada essa mensagem Edson Rodrigues em 09/03/09
			apMsgStop("A fase Atual do Cadastro do Tecnico não esta cadastrada no cadastro de Tecnicos X Fase. Favor Cadastrar a fase atual no Cadastro de Tecnicos X Fases.","Fase Atual inválida")
		endif
		
	Case _cTab == "FAS2"
		
		// Verifica se a fase destino eh igual a fase atual
		//		FAS2Ori := FAS2
		//		FAS2Ori := LEFT(FAS2,2) //Mudado o tamanho do Left para 2 - Edson Rodrigues em 09/03/09
		FAS2Ori := iif("/" $ ALLTRIM(FAS2),left(ALLTRIM(FAS2),AT("/",ALLTRIM(FAS2))-1),ALLTRIM(FAS2)) // alterado - Edson Rodrigues em 17/03/09
		if (LAB+AllTrim(CODSE2ORI)+AllTrim(FAS2Ori) == LAB+AllTrim(CODSETORI)+AllTrim(FAS1Ori)) .And. ENCOS <> "S"// alterado - Edson Rodrigues em 17/03/09
			apMsgStop("A fase destino não pode ser igual à fase atual. Favor informar outra fase como destino.","Fase inválida")
			_lRet := .F.
		ElseIf !Empty(FAS2)
			_lRet := u_VerFasDest(LAB, CODSETORI, FAS1Ori, CODSE2ORI, FAS2Ori)			
			If !_lRet
				//Adicionada essa mensagem Edson Rodrigues em 09/03/09
				apMsgStop("A fase Destino não esta amarrada com a fase origem no cadastro de Fase Origem X Fase Destino. Favor Cadastrar a fase destino para essa fase origem no Cadastro de Fase Origem X Fase Destino.","Fase Destino inválida")
			Endif		    
			
		ElseIf Empty(FAS2) //Adcionado Edson Rodrigues - 17/03/09
			If _lEncOsMsg .And. left(CODSETORI,6)<>left(CODSE2ORI,6)
				If !apMsgYesNo("A fase Origem "+FAS1+" pode encerrar a OS, porém o setor destino é diferente do setor Origem. Confirma o setor destino?","Setor destino diferente do setor Origem")
					_lRet := .F.
				Endif
			ElseIf  !_lEncOsMsg
				apMsgStop("Favor informar uma fase destino, não é permitido apontar fase destino em branco quando a fase origem não ecerra OS. Favor informar a fase destino.","Fase Destino inválida")
				_lRet := .F.				
			Endif			
		endif
		
	Case _cTab == "SWAP"
		
		_lSwap2 := iif(SWAP == "N", .F., .T.)
		If !_lSwap2
			IMEINOVO := CriaVar("ZZ3_IMEISW"   ,.F.)
			MODIMEIN := CriaVar("ZZ3_MODSW"    ,.F.)
			DPYINOVO := CriaVar("ZZ3_DPYINV"    ,.F.)
			CONTROC  := CriaVar("ZZ3_CTROCA"    ,.F.)
			UPGRAD   := CriaVar("ZZ3_UPGRAD"   ,.F.)
		EndIf
		
	Case _cTab == "IMEINOVO"
		_lSwap2 := iif(SWAP == "S",.T.,.F.)
		If _lSwap2  .And. Empty(IMEINOVO)
			apMsgStop("A fase atual é SWAP favor informar o Imei do aparelho novo.","Codigo IMEI em Branco")
			_lRet := .F.
		ElseIf _lSwap2  .And. ! Empty(IMEINOVO)
			// validacao do digito do IMEI - CLAUDIA 21/01/2010
			_lret := Iif(FINDFUNCTION("U_CHKIMEI"), U_CHKIMEI(IMEINOVO),.T.)
		Else
			_Lret := .T.
		Endif
		
		//Verifica se informa falha GonoGo - Proj. IRL - Edson Rodrigues 05/10/08
	Case _cTab == "GONOGO"
		If !_lgongo
			FGONGO := CriaVar("ZZ3_FGONGO"   ,.F.)
			FGONGO := "000001"
		Else
			_cFGONGO := TABELA("ZR", FGONGO, .F.)
			If !Empty(FGONGO)
				FGONGO := Alltrim(FGONGO) + " / " + _cFGONGO
			Else
				apMsgStop("A fase atual é GONOGO favor informar o codigo GoNoGo.","Codigo GonoGo")
				_lRet := .F.
			EndIf
		Endif
	Case _cTab =="MODIMEIN"
		_lSwap2 := iif(SWAP == "S",.T.,.F.)
		If _lSwap2  .And. Empty(MODIMEIN)
			apMsgStop("A fase atual é SWAP favor informar o modelo do aparelho novo.","Codigo Modelo em Branco")
			_lRet := .F.
		Endif
		
	Case _cTab == "IMEI"

        // Desabilitado essa validação do cliente, pois não faz mais sentido ter que informar o cliente para validar, a validação deverá ser au
        // tomática, a partir do primeiro cleinte localizado no primeiro IMEI - Edson Rodrigues - 15/05/12.
		/* --- Claudia Cabral 15/04/2009 Validar Cliente quando campo AA1_INFCLI do cad. tecnico = 1 (sim)  */
		// If lCliente .And. Empty(cCliente) .And. ENCOS = "S" // e obrigado a digitar o cliente e ainda nao digitou E E ENCERRAMENTO DA OS
		//	Do While Empty(cCliente)    // obriga a digitar o cliente
		//		dbSelectArea("SA1") //Incluso Edson Rodrigues - 04/08/10
		//		U_DigitaCli()
	    //	EndDo
		//	
		//EndIF
		/* --------------------------------------------------------------------------------------------------*/

			_aAreaZZ1 := ZZ1->(GetArea())
			_cfase1   :=AllTrim(FAS1Ori) + Space(6-len(AllTrim(FAS1Ori)))
		
		If !Empty(IMEI) .And. !Empty(CODTEC)
			
			_lRet      := .F.  // Retorna false para que o cursor se mantenha no campo IMEI
			_lContinua := .T.  // Trata se o programa deve continuar sendo executado ou se deve ser abortado por falta de validacao
			
			&&Validação para evitar que o IMEI novo seja igual ao IMEI anterior - Thomas Galvão - 02/08/2012
			If IMEI == IMEINOVO
				apMsgStop("O IMEI Novo não pode ser o igual ao IMEI trocado!","IMEI Novo igual ao IMEI trocado")
				IMEI := Space(20)
				_lRet := .F.				
			Endif
			
			// Verifica se o IMEI apontado ja foi apontado anteriormente na mesma tela
			for _nw := 1 to len(aCols)
				if IMEI == aCols[_nw,_nPosIMEI] .And. !aCols[_nw,Len(aHeader)+1]
					apMsgStop("O IMEI já foi apontado anteriormente nesta tela. Verifique o IMEI apontado.","IMEI já apontado anteriormente")
					_lContinua := .F.
					exit
				endif
			next _nw
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			// Verifica se a fase destino foi informada quando a OS nao for encerrada
			if Empty(FAS2) .And. ENCOS <> "S"
				apMsgStop("A fase de destino deve ser informada. O IMEI não foi gravado.","Fase destino não informada")
				_lContinua := .F.
			endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			//Acrescentado essa validacao de fases e setor - edson Rodrigues - 30/07/10
			If Empty(CODSE2)
				apMsgStop("Setor destino deve ser informado. O IMEI não foi gravado.","setor destino não informada")
				_lContinua := .F.
				
			Endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			/* verifica se o a obrigatoriedade de defeito informado, defeito cosntatado e solucao da fase esta vazia  - Paulo Francisco - 26/02/11*/
			If _lDefInf .And. Empty(DEFINF)
				apMsgStop("Defeito Informado Obrigatorio. O IMEI não foi gravado.","Defeito Informado não informada")
				_lContinua := .F.
				
			Endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			End
			
			If _lDefDet .And. Empty(DEFDET)
				apMsgStop("Defeito Constatado Obrigatorio. O IMEI não foi gravado.","Defeito Constatado não informada")
				_lContinua := .F.
				
			Endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			End
			
			If _lSolucao .And. Empty(SOLUCAO)
				apMsgStop("Solucao Constatado deve ser informado. O IMEI não foi gravado.","Solucao Constatado não informada")
				_lContinua := .F.
				
			Endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			End
			
			DBSELECTAREA("ZZ4")
			ZZ4->(dbsetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
			If ZZ4->(dbSeek(xFilial("ZZ4") + IMEI))
				//If ZZ4->ZZ4_STATUS $ "34" .And. _lContinua
				//_lContinua := .T. // Já é .T.
				If ZZ4->ZZ4_STATUS < "3" // Encontrou o IMEI mas o STATUS nao permite apontamento de fase
					_lContinua := .F.
					apMsgStop("Ainda não foi gerada NF de Entrada para este IMEI","IMEI sem NF de Entrada")
				ElseIf ZZ4->ZZ4_STATUS >= "5" // Encontrou o IMEI mas o STATUS nao permite apontamento de fase
					_lContinua := .F.
					apMsgStop("OS já encerrada ou IMEI está em processo de Saída Massiva","Saída Massiva") 
				EndIf
			Else
				_lContinua := .F.
				apMsgStop("IMEI não Cadastrado","IMEI inválido")
			EndIf
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			/* verifica se o cliente digitado e o mesmo do IMEI */
			if lClismas .And. !Empty(cCliente) .and. (ZZ4->ZZ4_CODCLI <> cCliente .OR. ZZ4->ZZ4_LOJA <> cLoja)
				apMsgStop("Cliente desse IMEI: " + ALLTRIM(ZZ4->ZZ4_CODCLI)+ "/ " +ZZ4->ZZ4_LOJA + " divegente do Cliente : " + ALLTRIM(cCliente)+ "/" +cLoja+ "escaneado no(s) IMEI(s) / Num. Série(s) anterior(es)"   ," Cliente Invalido")
				_lContinua := .F.
			endif
			/*--------------------------------------------------*/
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			// Declara variaveis utilizadas no calculo do TRANSACTION + GARANTIA MCL
			_cRecCli    := ""
			_cSPC       := ""
			_cMesFabr   := ""
			_cOpeBGH    := ZZ4->ZZ4_OPEBGH
			_aTransCode := {}
			cTransc     := ZZ4->ZZ4_TRANSC
			cGarMCL     := ZZ4->ZZ4_GARMCL

			// Verifica se a fase que esta sendo apontada coincide com a fase atual do aparelho
			_cVerFaseta := u_VerFasAtu(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
			if (!Empty(ZZ4->ZZ4_FASATU) .And. !Empty(ZZ4->ZZ4_SETATU)) .And. ((AllTrim(left(_cVerFaseta,6))+AllTrim(right(_cVerFaseta,6))) <> (AllTrim(FAS1Ori)+AllTrim(CODSETOri))) //.And. ENCOS<>"S" Desabilidado Edson Rodrigues em 16/04/09.
				apMsgStop("O IMEI encontra-se na fase/setor: "+ AllTrim(left(_cVerFaseta,6))+"/"+AllTrim(right(_cVerFaseta,6))+" e não poderá ser apontado da fase/setor: " + AllTrim(FAS1Ori)+"/"+AllTrim(CODSETOri)+"!","Fase Inválida")
				_lContinua := .F.
			endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			// Verifica se o IMEI está sendo apontado da fase atual por outro tecnico e nao confirmada //  Edson Rodrigues - 24/05/10
			_cVerfasncf := u_verfancf(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
			if (!Empty(_cVerfasncf))
				apMsgStop("O IMEI Esta sendo apontado pelo tecnico : "+substr(_cVerfasncf,13)+" na fase/setor "+ AllTrim(left(_cVerfasncf,6))+"/"+AllTrim(substr(_cVerfasncf,7,6))+". Finalize ou exclua o(s) apontamento(s) desse tecnico : "+AllTrim(substr(_cVerfasncf,13))+" primeiro.","Apontamento em andamento nao confirmado")
				_lContinua := .F.
			endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			// Verifica se o IMEI está sendo apontado da fase atual por outro tecnico e nao confirmada //  Edson Rodrigues - 26/07/10
			_capontenc := u_VerEncer(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
			if _capontenc='S'
				DBSelectArea("AB9")
				DBSetOrder(7) //AB9_FILIAL+AB9_SN+AB9_NUMOS+AB9_CODCLI+AB9_LOJA
				If AB9->(dbSeek(xFilial("AB9") +ZZ4->ZZ4_IMEI+left(ZZ4->ZZ4_OS,6)))
					apMsgStop("O ultimo apontamento desse IMEI esta encerrado e com atendimento. Exclua o atendimento e em seguinte estorne o encerramento na tela de apontamento de fases.","Apontamento Encerrado")
					_lContinua := .F.
				Else
					apMsgStop("O ultimo apontamento desse IMEI esta encerrado e sem atendimento. Estorne o encerramento na tela de apontamento de fases.","Apontamento Encerrado")
					_lContinua := .F.
				Endif
			endif
			
			// Verifica se a Fase Necessita de Informacao do Documento de Separacao ( Documento Utilizado pela equipe de Logistica Para separar os Radios a Serem Enviados para a Producao
			If _lContinua .AND. GETMV("BH_VALMAX",.F.,.F.) .AND. ZZ4->ZZ4_STATUS=='3'  // Parametro Para Validar Existencia da Etiqueta Master com o Documento planejado para Produção)
			   _cSetAtu := LEFT(CODSET,6)
			   _cFasAtu := LEFT(FAS1,2)
			   _cSetDes := LEFT(CODSE2,6)
			   _cFasDes := LEFT(FAS2,2)
			   _cDocObAt:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + _cSetAtu + _cFasAtu + SPACE(04),"ZZ1_DOCSEP")  
			   _cDocObDe:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + _cSetDes + _cFasDes + SPACE(04),"ZZ1_DOCSEP")  
			   If _cDocObAt == "S"  .AND. _cDocObDe == "S" 
			      If Empty(_cNumDoc)
			         apMsgStop("Informe Primeiro o Documento Planejado !!!")
                     _lContinua := .F.
			      Else
			        // Valida se documento Possui Saldo
			        DbSelectArea("ZZY")  // Tabela de Planejamento da Producao
					DbSetOrder(3)  // ZZY_FILIAL, ZZY_NUMDOC, ZZY_NUMMAS, ZZY_CODPLA, R_E_C_N_O_, D_E_L_E_T_
					If !Empty(ZZ4->ZZ4_ETQMEM) // Possui Etiqueta Master
						If DbSeek(xFilial("ZZY")+_cNumDoc+ZZ4->ZZ4_ETQMEM,.F.)
						   If ZZY->ZZY_QTDSEP == ZZY->ZZY_QTDMAS
						      apMsgStop("Nao Existe Saldo Para o Documento de Separacao !!!")
						      _lContinua := .F.
                	       Endif
                        Else
                          apMsgStop("Documento de Separacao Nao Localizado para a Etiqueta Master deste IMEI")
					       _lContinua := .F.
                        Endif
                    Else
                    	// Regra Para quando nao possuir etiqueta master ( Garantia de Refurbish
                    	_cSemMaster := "SEM_MASTER"+SPACE(10)
                    	If DbSeek(xFilial("ZZY")+_cNumDoc+_cSemMaster,.F.)
						   If ZZY->ZZY_QTDSEP == ZZY->ZZY_QTDMAS
						      apMsgStop("Nao Existe Saldo Para o Documento de Separacao !!!")
					         _lContinua := .F.
						   Endif
                        Else
						     apMsgStop("Documento de Separacao Nao Localizado")
					         _lContinua := .F.
                        Endif
                    Endif   
			      Endif   
               Endif
            Endif
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			// Verifica se o IMEI entrou mais de uma vez para conserto
			if !left(CODSET,6) $ AllTrim(_csetmast) .And. ZZ4->ZZ4_NUMVEZ > 1 .And. !apMsgYesNo("Esta é a "+cvaltochar(ZZ4->ZZ4_NUMVEZ)+"a. vez que este aparelho está sendo atendido. Confirma apontamento de fase?","Aparelho retornado")
				_lContinua := .F.
			ElseIf ZZ4->ZZ4_NUMVEZ > 1
				//verifica se o aparelho é bounce ou seja esta retornando menos que 90 dias. Edson Rodrigues - 20/07/09
				// Verifica data da ultima saida do IMEI
				_dUltSai := u_UltSai(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_EMDT)
				_nBounce := 0
				If !Empty(_dUltSai)
					If !left(CODSET,6) $ AllTrim(_csetmast) .And. ZZ4->ZZ4_EMDT-_dUltSai < 90 .And. !apMsgYesNo("Este Aparelho esta retornando a  menos de 90 dias,  é Bounce. Confirma apontamento ?","Bounce do Aparelho")
						_lContinua := .F.
					Endif
				endif
			Endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			// Verifica se o aparelho esta em SWAP ANTECIPADO
			if !Empty(ZZ4->ZZ4_SWANT) .And. !ApMsgYesNo("Esse IMEI trata-se de SWAP ANTECIPADO e portanto não deveria sofrer atendimento. Confirma inclusão do atendimento deste IMEI?","SWAP ANTECIPADO")
				_lContinua := .F.
			endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			_lSwap2 := iif(SWAP == "S",.T.,.F.)
			If _lSwap2  .And. Empty(IMEINOVO)
				apMsgStop("A fase atual é SWAP favor informar o Imei do aparelho novo.","Codigo IMEI em Branco")
				_lContinua := .F.
			ElseIf _lSwap2  .And. Empty(MODIMEIN)
				apMsgStop("A fase atual é SWAP favor informar o modelo do aparelho novo.","Codigo Modelo em Branco")
				_lContinua := .F.
			Endif
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			
			//Verifica se o produto entrou como SCRAP - Edson Rodrigues -
			If ZZ4->ZZ4_ASCRAP="S" .And. !ApMsgYesNo("Esse APARELHO foi baixado como SCRAP na última vez que esteve na BGH e ele retornou. COMUNIQUE SEU SUPERIOR URGENTE !!. Quer continuar apontando esse IMEI ou não ?","APARELHO SCRAP")
				_lContinua := .F.
			EndIf
			
			// Ticket 5954 - M.Munhoz - 11/05/2012 
			// Verifica se o IMEI esta sendo transferido para as operacoes N10 ou N11 caso pertencam a N08 ou N09 e nao atendam as condicoes de garantia.
			_cDefInf := iif(!empty(DEFINF),left(DEFINF,5),ZZ4->ZZ4_DEFINF)
			if LAB == '2' ;
			.and. alltrim(ZZ4->ZZ4_OPEBGH) $ "N08/N09" ;
			.and. (      u_CondIRF(LAB, ZZ4->ZZ4_GARANT, ZZ4->ZZ4_CODPRO, transform(u_TmpFabric(ZZ4->ZZ4_CARCAC, dtos(ZZ4->ZZ4_DOCDTE)),"@!"), _cDefInf) ;
			        .or. ZZ4->ZZ4_GARANT == "N" .and. !u_CondIXT(LAB, ZZ4->ZZ4_GARANT, ZZ4->ZZ4_CODPRO, transform(u_TmpFabric(ZZ4->ZZ4_CARCAC, dtos(ZZ4->ZZ4_DOCDTE)),"@!"), _cDefInf) )

				cTransOpe := Posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSE2,6) + LEFT(FAS2,2)+ SPACE(04),"ZZ1_ALTOPE")

				if empty(cTransOpe) ;
				.or. ZZ4->ZZ4_OPEBGH == "N08" .and. alltrim(cTransOpe) <> "N10" ;
				.or. ZZ4->ZZ4_OPEBGH == "N09" .and. alltrim(cTransOpe) <> "N11"

					apMsgStop('Este IMEI deve ser transferido para a operação '+iif(ZZ4->ZZ4_OPEBGH=="N08",'N10','N11')+', uma vez que ele não atende as condições de garantia da operação. Selecione outra fase destino para efetuar a transferência.','Fase destino inválida.')
					_lContinua := .f.

				endif

			endif
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			// Pega informacoes do cadastro de FASES
			dbSelectArea("ZZ1")
			dbSetOrder(1)  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
			if dbSeek(xFilial("ZZ1") + LAB + left(CODSETORI,6) + _cfase1)
				if ZZ1->ZZ1_INFRES  == "S"
					_lInfres := .T.
					U_DigitaRST()
				endif			
			endif
			restarea(_aAreaZZ1)
			
			//Faz as novas validacoes para o processo novo Motorola-Relatorios MClaims // Edson Rodrigues - 12/05/09
			If !Empty(ZZ4->ZZ4_OPEBGH)
				dbselectarea("ZZJ")
				ZZJ->(dbsetOrder(1)) // ZZJ_FILIAL + ZZJ_OPEBGH+ ZZJ_LAB
				If ZZJ->(dbseek(xFilial("ZZJ")+ ZZ4->ZZ4_OPEBGH+Lab))
					cinftrans	:=ZZJ->ZZJ_INFTCM  // variavel que informa o Transcode - Processo Mclaims - Edson Rodrigues 22/03/10
					ctransfix	:=ZZJ->ZZJ_TRAFIX  // variavel que diz se Transcode e fixo,sim, nao ou condicional - Processo Mclaims - Edson Rodrigues 15/04/10
					ccodtrfix	:=ZZJ->ZZJ_CODTRF // variavel que obtem o Transcode quando ZZJ_TRAFIX=SIM - Processo Mclaims - Edson Rodrigues 15/04/10
//					ctransfai	:=ZZJ->ZZJ_FASORI // variavel que obtem fases inicial onde posa ser transferido de operacao BGH
//					ctranssei	:=ZZJ->ZZJ_SETORI // variavel que obtem setor inicial onde posa ser transferido de operacao BGH
//					ctransfaf	:=ZZJ->ZZJ_FASFIM // variavel que obtem fases final   onde posa ser transferido de operacao BGH
//					ctranssef	:=ZZJ->ZZJ_SETFIM // variavel que obtem setor final   onde posa ser transferido de operacao BGH
//					cimpmaste	:=ZZJ->ZZJ_SETMAS // variavel que obtem setor de impressao de etiqueta Master BGH
					cfastnfix	:=ALLTRIM(ZZJ->ZZJ_FASTRC) 	// variavel que obtem a(s) fase(s) quando ZZJ_TRAFIX=NAO - Processo Mclaims - Edson Rodrigues 15/04/10
					csettnfix	:=ALLTRIM(ZZJ->ZZJ_SETTRC) 	// variavel que obtem o(s) setor(s) quando ZZJ_TRAFIX=NAO - Processo Mclaims - Edson Rodrigues 15/04/10
					cfasouinf	:=ALLTRIM(ZZJ->ZZJ_FASOUT) 	// variavel que obtem a(s) fase(s) que informa outros dados para o processo do Mclaims e que o ZZJ_TRAFIX=NAO - Edson Rodrigues 15/04/10
					_csetmast	:=ALLTRIM(ZZJ->ZZJ_SETMAS) // variavel que obtem setor(es) de impressao de etiqueta Master BGH
					_cfasmast	:=ALLTRIM(ZZJ->ZZJ_FASMAS) // variavel que obtem fases(es) de impressao de etiqueta Master BGH
					cfasalltn	:=cfastnfix+'/'+cfasouinf
					_cinfsix    :=ZZJ->ZZJ_INFSIX
					cdific      :=SPACE(2)
					crepair     :=SPACE(2)
					ccondic     :=SPACE(1)
				Else
					ApMsgInfo("Não foi encontrado a operacao cadastrada para OS "+ZZ4->ZZ4_OS+" e IMEI "+ZZ4->ZZ4_IMEI+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
					_lContinua := .F.
					return(_lRet)
				EndIf
				copebgh :=ZZ4->ZZ4_OPEBGH
				cmodel  :=Posicione("SB1",1,xFilial("SB1") + ZZ4->ZZ4_CODPRO, "B1_GRUPO")
				cfinime :=RIGHT(ALLTRIM(IMEI),3)
				_cfase1   := IIf('/' $ ALLTRIM(FAS1),substr(FAS1,1,At('/',FAS1)-1),FAS1)
				_cfase1   :=AllTrim(_cfase1) + Space(6-len(AllTrim(	_cfase1)))       
				_cfase2   := IIf('/' $ ALLTRIM(FAS2),substr(FAS2,1,At('/',FAS2)-1),FAS2)
				_cfase2   :=AllTrim(_cfase2) + Space(6-len(AllTrim(	_cfase2)))
				
				If  cinftrans="S"  .And. _lContinua
					cgarant :=IIf(!Empty(ZZ4->ZZ4_GARANT),ZZ4->ZZ4_GARANT,U_Vergaran(AllTrim(ZZ4->ZZ4_CARCAC),ALLTRIM(ZZ4->ZZ4_OPEBGH),ZZ4->ZZ4_IMEI))
//					cgarspc := SZA->ZA_SPC
/*					TICKET 4818
					if Empty(ZZ4->ZZ4_GARANT) .And. !Empty(cgarant)
						RecLock("ZZ4",.F.)
						ZZ4->ZZ4_GARANT := cgarant
						MSUnlock()
					EndIf
*/					
					ZAD->(dbsetOrder(1))  // ZAD_FILIAL + ZAD_MODEL + ZAD_FINIME + ZAD_VERSOF
					If ZAD->(dbseek(xFilial("ZAD")+ cmodel+cfinime))
						csoftout:=ZAD->ZAD_VERSOF
					ElseIf ZAD->(dbseek(xFilial("ZAD")+ cmodel))
						csoftout:=ZAD->ZAD_VERSOF
					EndIf
					cnumlin:="NA"
					
/*					
					//Incluso Edson Rodrigues - 11/08/10 - conforme necessidade apresentada no e-mail da katia/fernando em 11/08/10
					If  ENCOS = "S"

						BLQIMEI(IMEI)
						/* Ticket 5227 - M.Munhoz - 10/04/12 
						// Durante a solucao deste ticket verifiquei que as funcoes PROREPA e CONSGA09 gravam informacoes no ZZ4 antes da fase 
						// ser efetivada. quando ocorre um estorno isso gera um problema de inconsistencia, uma vez que os dados desta fase permanecem 
						// gravados no ZZ4 indevidamente
						If Empty(AllTrim(cgarspc)) .And. (lUsrNext .Or. lUsrAdmi)
							PROREPA(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS,LAB)
							
							CONSGA09(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
						EndIf
						*/
/*						If ctransfix='N'
							//_lvtrc:=U_Vtransc(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
							_lvtrc:= Posicione("ZZ4",1,xFilial("ZZ4") + ZZ4->ZZ4_IMEI + ZZ4->ZZ4_OS ,"ZZ4_TRANSC")
							//If !_lvtrc
							If Empty(AllTrim(_lvtrc))
								ApMsgInfo("Transaction Code não digitado em nenhuma fase apontada para OS: "+ZZ4->ZZ4_OS+" e IMEI: "+ZZ4->ZZ4_IMEI+" . Favor digita-lo a seguir.","Transaction Code  não localizado!")
								Do While Empty(cTransc)
									OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'3')
								ENDDO
							Endif
						EndIf
						
						If ctransfix='C' .And. cgarant='S' .And. ENCOS = "S".Or. ctransfix='C' .And. cgarant='S' .And. !Empty(cgarspc) .And. ENCOS = "S"
							If lUsrNext .And. cgarant='S' .Or. lUsrAdmi .And. cgarant='S'
								ctransope := Posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSE2,6) + LEFT(FAS2,2)+ SPACE(04),"ZZ1_ALTOPE")
								If !Empty(AllTrim(ctransope))
									cTransc:= Posicione("ZZJ",1,xFilial("ZZJ") + ctransope,"ZZJ_CODTRF")
								Else
									//_lvtrc:=U_Vtransc(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
									_lvtrc:= Posicione("ZZ4",1,xFilial("ZZ4") + ZZ4->ZZ4_IMEI + ZZ4->ZZ4_OS ,"ZZ4_TRANSC")
									
								EndIf
							Endif
						Endif
						
/*						TICKET 4818
						If 	lUsrNext .And. ctransfix='C' .And. cgarant='S' .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrAdmi .And. ctransfix='C' .And. cgarant='S' .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrNext .And. ctransfix='C' .And. cgarant='N' .And. Empty(Alltrim(cTransc)) .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrAdmi .And. ctransfix='C' .And. cgarant='N' .And. Empty(Alltrim(cTransc)) .And. Empty(AllTrim(ctransope))
							
							U_Atransc(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
							
							cTransc:= lRetIR
							
						EndIf
*/
/*
					Else
						
						/* Ticket 5227 - M.Munhoz - 10/04/12 
						// Durante a solucao deste ticket verifiquei que as funcoes PROREPA e CONSGA09 gravam informacoes no ZZ4 antes da fase 
						// ser efetivada. quando ocorre um estorno isso gera um problema de inconsistencia, uma vez que os dados desta fase permanecem 
						// gravados no ZZ4 indevidamente
						If Empty(AllTrim(cgarspc)) .And. (lUsrNext .Or. lUsrAdmi) //.Or. cTransc <> 'IXT' .And. (lUsrNext .Or. lUsrAdmi) - Alterado Paulo Francisco 07/03/12
							
							PROREPA(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS,LAB)
							
							CONSGA09(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
							
						EndIf
						*/
/*						ctransope := Posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSE2,6) + LEFT(FAS2,2)+ SPACE(04),"ZZ1_ALTOPE")
						
						If 	lUsrNext .And. ctransfix<> 'N' .And. cgarant='S'  .And. !Empty(AllTrim(ctransope)) .Or. ;
							lUsrAdmi .And. ctransfix<> 'N' .And. cgarant='S'  .And. !Empty(AllTrim(ctransope))
							
							cTransc:= Posicione("ZZJ",1,xFilial("ZZJ") + ctransope,"ZZJ_CODTRF")
							//cTransc:= Posicione("ZZ4",1,xFilial("ZZ4") + ZZ4->ZZ4_IMEI + ZZ4->ZZ4_OS ,"ZZ4_TRANSC")
							
							If Empty(AllTrim(cTransc))
								ApMsgInfo("Transaction Code não digitado em nehuma fase apontada para OS: "+ZZ4->ZZ4_OS+" e IMEI: "+ZZ4->ZZ4_IMEI+" . Favor digita-lo a seguir.","Transaction Code  não localizado!")
								Do While Empty(cTransc)
									OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'3')
								ENDDO
							Endif
							
						ElseIf 	lUsrNext .And. ctransfix='C' .And. cgarant='S' .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrAdmi .And. ctransfix='C' .And. cgarant='S' .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrNext .And. ctransfix='C' .And. cgarant='N' .And. Empty(Alltrim(cTransc)) .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrAdmi .And. ctransfix='C' .And. cgarant='N' .And. Empty(Alltrim(cTransc)) .And. Empty(AllTrim(ctransope))
							
							U_Atransc(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
							
							cTransc:= lRetIR
							
						ElseIf 	ctransfix='C' .And. cgarant='N' .And. Empty(cgarspc) .And. Empty(Alltrim(cTransc))
							
							cTransc:="IOW"
							cartime:="00000000000000000000"
							
						ElseIf 	ctransfix=='N' .And. ( left(CODSETORI,6)  $ csettnfix .And. ALLTRIM(_cfase1) $ cfasalltn ) .And. Empty(Alltrim(cTransc))
							If AllTrim(_cfase1) $ AllTrim(cfasouinf)
								Do While (Empty(cSoftOut) .or. Empty(cartime))
									OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'1')
								ENDDO
							EndIf
							
							If AllTrim(_cfase1) $ AllTrim(cfastnfix)
								Do While Empty(cTransc) .And. ALLTRIM(_cfase1) $ AllTrim(cfastnfix)
									OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'2')
								ENDDO
							EndIf
							
						ElseIf   ctransfix='S'
							cTransc:=AllTrim(ccodtrfix)
							cartime:="00000000000000000000"
						EndIf
					EndIf
*/
				EndIf
				
				
				//Verifica se o aparelho esta na garantia para outras operacoes/laboratorios diferente do n../02-Nextel.
				//Por enquanto especifico para a Sony Brazil - Edson Rodrigues 19/01/12
				_cgarinf :=ZZ4->ZZ4_GARANT
				_cinfgar :=Posicione("ZZ1",1,xFilial("ZZ1") + LAB + IIf('/' $ ALLTRIM(CODSET),substr(ALLTRIM(CODSET),1,At('/',ALLTRIM(CODSET))-2),ALLTRIM(CODSET)) + _cfase1,"ZZ1_INFGAR")
				
				IF _cinfgar=="S" .AND. _cinfsix="S"
					if ApMsgYesNo("Esse APARELHO Esta na GARANTIA ?","APARELHO GARANTIA SIM OU NAO ?")
						_cgarinf :="S"
					Else
						_cgarinf :="N"
					Endif
					RecLock("ZZ4",.F.)
					ZZ4->ZZ4_GARANT := _cgarinf
					MSUnlock()
					
				EndIf
				

				// M.Munhoz - 26/04/2012 - Nova programacao para definir o transaction e a garantia MCLAIM
				//Incluso Edson Rodrigues - 11/08/10 - conforme necessidade apresentada no e-mail da katia/fernando em 11/08/10
				ctransope := Posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSE2,6) + LEFT(FAS2,2)+ SPACE(04),"ZZ1_ALTOPE")
				If  ENCOS = "S" 
					
					BLQIMEI(IMEI)
				
					If  cinftrans="S" .and. ctransfix<>'S' // Transaction NAO FIXO = MANUAL

						// Se estiver VAZIO mostra tela pro usuario preencher o TRANSACTION
						If Empty(AllTrim(ZZ4->ZZ4_TRANSC))
							ApMsgInfo("Transaction Code não digitado em nenhuma fase apontada para OS: "+ZZ4->ZZ4_OS+" e IMEI: "+ZZ4->ZZ4_IMEI+" . Favor digita-lo a seguir.","Transaction Code  não localizado!")
							Do While Empty(cTransc)
								// Tela para preencher outras informacoes das operacoes Laboratorio 2 (Nextel) >>> Tela 3 = Transaction
								OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'3')
							ENDDO
						ElseIf AllTrim(_cfase1) $ AllTrim(cfastnfix) .and. left(CODSETORI,6) $	csettnfix		
						    cTransc :=SPACE(5)
							Do While Empty(cTransc) .And. AllTrim(_cfase1) $ AllTrim(cfastnfix) .and. left(CODSETORI,6) $	csettnfix		
								// Tela para preencher outras informacoes das operacoes Laboratorio 2 (Nextel) >>> Tela 3 = Transaction
								OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'3')
							ENDDO
						
						//Elseif (left(CODSETORI,6)+_cfase1) == "00000431" .and. (left(CODSE2ORI,6)+_cfase2) == "00000401"
						//		cTransc := "IR2"	 
						
						
						//Elseif (left(CODSETORI,6)+_cfase1) == "00000431" .and. (left(CODSE2ORI,6)+_cfase2) == "00001101"						
					    //     	cTransc := "ITS"	 
						Endif
				
					EndIf
					
				Else
					
//					ctransope := Posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSE2,6) + LEFT(FAS2,2)+ SPACE(04),"ZZ1_ALTOPE")
					
					If 	cinftrans="S" .and. lUsrNext .And. ctransfix<> 'N' .And. cgarant='S'  .And. !Empty(AllTrim(ctransope)) .Or. ;
						cinftrans="S" .and. lUsrAdmi .And. ctransfix<> 'N' .And. cgarant='S'  .And. !Empty(AllTrim(ctransope))
						
						cTransc:= Posicione("ZZJ",1,xFilial("ZZJ") + ctransope,"ZZJ_CODTRF")
						
						If Empty(AllTrim(cTransc))
							ApMsgInfo("Transaction Code não digitado em nenhuma fase apontada para OS: "+ZZ4->ZZ4_OS+" e IMEI: "+ZZ4->ZZ4_IMEI+" . Favor digita-lo a seguir.","Transaction Code  não localizado!")
							Do While Empty(cTransc)
								// Tela para preencher outras informacoes das operacoes Laboratorio 2 (Nextel) >>> Tela 3 = Transaction
								OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'3')
							ENDDO
						Endif
						
					ElseIf cinftrans='S' .and. ctransfix=='N' .And. ( left(CODSETORI,6)  $ csettnfix .And. ALLTRIM(_cfase1) $ cfasalltn ) //.And. Empty(Alltrim(cTransc))
				
						If AllTrim(_cfase1) $ AllTrim(cfasouinf)
							Do While (Empty(cSoftOut) .or. Empty(cartime))
								// Tela para preencher outras informacoes das operacoes Laboratorio 2 (Nextel) >>> Tela 1 = Vers.Soft.Out, Vers.Soft.In,Artime - Util. aparelho 
								OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'1')
							ENDDO
						EndIf
						
						If AllTrim(_cfase1) $ AllTrim(cfastnfix)
						    cTransc :=SPACE(5)
							Do While Empty(cTransc) .And. ALLTRIM(_cfase1) $ AllTrim(cfastnfix)
								// Tela para preencher outras informacoes das operacoes Laboratorio 2 (Nextel) >>> Tela 2 = Transaction
								OutInf(COPEBGH,CGARANT,@cSofIn,@csoftout,@cTransc,left(CODSETORI,6),_cfase1,cfastnfix,cfasouinf,cfasalltn,'2')
							ENDDO
						EndIf
						
					EndIf
				
				EndIf
				
				if cinftrans == "S"
					_cDefInf    := iif(!empty(DEFINF),left(DEFINF,5),ZZ4->ZZ4_DEFINF)
					_cRecCli    := Posicione("ZZG",1,xFilial("ZZG")+LAB+_cDefInf,"ZZG_RECCLI")
					_cSPC       := Posicione("SZA",1,xFilial("SZA")+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_IMEI,"ZA_SPC")
					_cOpeBGH    := iif(!empty(cTransOpe),cTransOpe,ZZ4->ZZ4_OPEBGH)
					_cRepair    := iif(!empty(SOLUCAO),left(SOLUCAO,5),ZZ4->ZZ4_REPAIR)
					_aTransCode := u_DefTrans(_cOpeBGH, ZZ4->ZZ4_GARANT, _cRecCli, ZZ4->ZZ4_CODPRO, _cSPC, cTransc, !empty(SWAP), _cRepair, ZZ4->ZZ4_TRANSC, ZZ4->ZZ4_CARCAC, ZZ4->ZZ4_DOCDTE, _cDefInf)
					cTransc     := _aTransCode[1]
					cGarMCL     := _aTransCode[2]
				endif
				
				//Verifica se o aparelho esta sendo encerrado e se pertence a Sony Brazil para solicitar informacao de ISIS DIFICULT e ISIS REPAIR
				//Edson Rodrigues 19/01/12
				IF ENCOS = "S" .AND. _cinfsix="S"
					
					Do While (Empty(cdific) .or. Empty(crepair))
						Outisix(COPEBGH,_cgarinf,@cdific,@crepair,@ccondic,left(CODSETORI,6),'1')
					ENDDO
					
				ELSEIF _lDefInf .AND. _cinfsix="S"
					
					Do While Empty(ccondic)
						Outisix(COPEBGH,_cgarinf,@cdific,@crepair,@ccondic,left(CODSETORI,6),'2')
					ENDDO
					
				ENDIF
				
			EndIf
			
			IF ALLTRIM(copebgh) $ "P01/V01/I01/I02/I03"  
				
				
				IF  empty(cfasstam) .and. ALLTRIM(_cfase1) $ "05/15" .and. ALLTRIM(copebgh) $ "P01/I01/I02/I03"
				    lfasstam := .T.  
				    cfasstam :="05/15"
				
				ELSEIF empty(cfasstam) .and. ALLTRIM(_cfase1) $ "05" .and. copebgh == "P01"
				    lfasstam := .T.  
				    cfasstam :="05"
				
                ELSEIF empty(cfasstam) .and. ALLTRIM(_cfase1) == "07" 
                    lfasstam := .T.  
				    cfasstam :="07"	
				    
                ELSEIF empty(cfasstam) .and. ALLTRIM(_cfase1) == "06" 
                    lfasstam := .T.  
				    cfasstam :="06"					    
				    			
				ENDIF    

			ENDIF	
			
			
			IF lfasstam .and. !_cfase1 $ cfasstam
				apMsgStop("A fase atual desse IMEI: " + ALLTRIM(FAS1)+ " divegente da fase(s) : " + ALLTRIM(cfasstam)+ "escaneada(s) no(s) IMEI(s) / Num. Série(s) anteriores"   ," Fases Invalidas")
				_lContinua := .F.
			endif
			/*--------------------------------------------------*/
			
			If !_lContinua
				IMEI := Space(20)
				return(_lRet)
			Endif
			

			
			

							
			
			
			
			if _lContinua
				
				_cNumOS   	:= ZZ4->ZZ4_OS
				_clote    	:= ZZ4->ZZ4_LOTIRL
				_ccliente 	:= ZZ4->ZZ4_CODCLI
				_cloja    	:= ZZ4->ZZ4_LOJA
				_cnfenr   	:= ZZ4->ZZ4_NFENR
				_cnfeser  	:= ZZ4->ZZ4_NFESER
				SEQ       	:= u_CalcSeq(IMEI, _cNumOS)
				_cfase1   	:= IIf('/' $ ALLTRIM(FAS1),substr(FAS1,1,At('/',FAS1)-1),FAS1)
				_cfase1   	:= AllTrim(_cfase1) + Space(6-len(AllTrim(	_cfase1)))
				_cfase2   	:= iif(ENCOS == "S", iif("/" $ ALLTRIM(FAS1),left(ALLTRIM(FAS1),AT("/",ALLTRIM(FAS1))-1),ALLTRIM(FAS1)), iif("/" $ ALLTRIM(FAS2),left(ALLTRIM(FAS2),AT("/",ALLTRIM(FAS2))-1),ALLTRIM(FAS2)))  //alterado - Edson Rodrigues em 17/03/09
				_csetfas2 	:= LEFT(CODSE2,6)+_cfase2
				_lobrigpf  	:= .F.  // obriga a cadastrar a peca faltante de acordo com as regras de apontamento
				_lobripart 	:= .F.  // obriga a cadastrar a partnumber quando no cadastro de fase estiver obrigatório
				_cvreccli 	:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH+LAB, "ZZJ_VRECLI")
				_cfpcfal  	:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH+LAB, "ZZJ_FPCFAL")
				_cGarMcla	:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH+LAB, "ZZJ_GARMCL")
				_cfasfal  	:= AllTrim(Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH+LAB, "ZZJ_FASFAL"))
				
				IIf(_lSwap2,_cControl :=GetSxeNum('ZZ3','ZZ3_CTROCA'),_cControl:="")
				
				If _cvreccli='S'  .And. SZA->(dbSeek(xFilial("SZA") +_ccliente+_cloja+_cnfenr+_cnfeser+ LEFT(IMEI,15) ))
					If !Empty(SZA->ZA_DEFRECL)
						_cdefcli:= left(SZA->ZA_DEFRECL,5)+" / "+AllTrim(POSICIONE("ZZG",1,XFILIAL("ZZG")+LAB+LEFT(SZA->ZA_DEFRECL,5),"ZZG_DESCRI"))
						_cDefSeq:= "00"
					Else
						u_Verdef(IMEI,_ccliente,_cloja,_cnfenr,_cnfeser,LAB)
						_cdefcli:= _cDefRec
						_cDefSeq:= "00"
					EndIf
					
				EndIf
				
				If _cvreccli='S' .And. Empty(_cdefcli)
					
					If !Empty(_cdefcli)
						_cDefSeq:= "01"
					EndIf
				EndIf
				
				
				//verifica valida apontamento de pecas
				If Posicione("ZZ1",1,xFilial("ZZ1") + LAB + IIf('/' $ ALLTRIM(CODSET),substr(ALLTRIM(CODSET),1,At('/',ALLTRIM(CODSET))-2),ALLTRIM(CODSET)) + _cfase1,"ZZ1_PARTNR") == "2"
					U_ADDPARTNO(1,_lADDPARTNO)
					_cGrava := .F.
					//_lobripart:=.T. Desabilitado, pois não há necessidade de declarar novamente e estava causando problemas - Edson Rodrigues 29/03/10
					
					Do while  _lobripart  .And. len(_aRecnoSZ9) <= 0  // Incluso Edson Rodrigues - 19/07/09
						apMsgStop("De acordo com as regras é obrigatorio informar o partnumber para essa fase.","Por favor preencher")
						_lobripart :=.T.
						U_ADDPARTNO(1,_lADDPARTNO)
					Enddo
				ElseIf Posicione("ZZ1",1,xFilial("ZZ1") + LAB +  IIf('/' $ ALLTRIM(CODSET),substr(ALLTRIM(CODSET),1,At('/',ALLTRIM(CODSET))-2),ALLTRIM(CODSET)) + _cfase1,"ZZ1_PARTNR") == "1"
					If ApMsgYesNo("O Apontamento de Part. No para a Fase Atual é Opcional. Deseja Apontar um Part. No para este Item?")
						U_ADDPARTNO(1,_lADDPARTNO)
						_cGrava := .F.
					EndIf
				EndIf
				
				If Left(AllTrim(_cMissue),2) $ "I1" .Or. Left(AllTrim(_cMissue),4) == "MPI1"
					
					_cMissue := "MPI1  "
					
				EndIf
				
				If left(CODSET,6) == '000016' .And. left(FAS1,2) == '01'  .And. AllTrim(_cGarmcl) == 'S' .And. Left(_cMissue,6) $  _cIssue
					//	MsgAlert("Necessário Apontamento de Peças,Equipamento GARANTIA !!!","PEÇAS - GARANTIA")
					If ApMsgYesNo("Necessário Apontamento de Peças,Equipamento GARANTIA. Equipamento ISSUE?","PEÇAS - GARANTIA")
						
						U_ADDPARTNO(1,.T.)
						
					Else
						
						If Select("QRY2") > 0
							QRY2->(dbCloseArea())
						EndIf
						
						_cQry2 := "SELECT TOP 1 Z9_PARTNR PARTNR FROM " + RetSqlName("SZ9") + " WHERE D_E_L_E_T_ = '' AND Z9_PARTNR <> '' AND Z9_STATUS = '1' AND Z9_NUMOS = '" + AllTrim(_cNumOS) + "' "
						
						dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry2), "QRY2", .F., .T.)
						
						If Empty(AllTrim(QRY2->PARTNR))
							
							cMensagem := "Equipamento Encerrado : "+DTOC(date())+" - "+time()+" hrs."+ _center
							cMensagem += "Operação : " + AllTrim(ZZ4->ZZ4_OPEBGH)+ _center
							cMensagem += "Transaction : " + AllTrim(cTransc)+ _center
							cMensagem += "Equipamento Sendo Apontado : "+IMEI+ _center
							cMensagem += "Os.:   " + AllTrim(_cNumOS) + _center
							cMensagem += "Modelo : " + AllTrim(_cMissue) + _center
							cMensagem += "Usuario Apontando " + AllTrim(cUsername)  + _center
							
							U_ENVIAEMAIL(cTitemail,"paulo.francisco@bgh.com.br;fluciano@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
							
						EndIf
						
					EndIf
					
				EndIf
				
				If left(CODSET,6) == '000002' .And. left(FAS1,2)  == '03' .And. AllTrim(_cGarmcl) == 'S' .And. Left(_cMissue,6) $  _cIssue
					//	MsgAlert("Necessário Apontamento de Peças,Equipamento GARANTIA !!!","PEÇAS - GARANTIA")
					If ApMsgYesNo("Necessário Apontamento de Peças,Equipamento GARANTIA. Equipamento ISSUE?","PEÇAS - GARANTIA")
						
						U_ADDPARTNO(1,.T.)
						
					Else
						
						If Select("QRY2") > 0
							QRY2->(dbCloseArea())
						EndIf
						
						_cQry2 := "SELECT TOP 1 Z9_PARTNR PARTNR FROM " + RetSqlName("SZ9") + " WHERE D_E_L_E_T_ = '' AND Z9_PARTNR <> '' AND Z9_STATUS = '1' AND Z9_NUMOS = '" + AllTrim(_cNumOS) + "' "
						
						dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry2), "QRY2", .F., .T.)
						
						If Empty(AllTrim(QRY2->PARTNR))
							
							cMensagem := "Equipamento Encerrado : "+DTOC(date())+" - "+time()+" hrs."+  _center
							cMensagem += "Operação : " + AllTrim(ZZ4->ZZ4_OPEBGH)+  _center
							cMensagem += "Transaction : " + AllTrim(cTransc)+  _center
							cMensagem += "Equipamento Sendo Apontado : "+IMEI+  _center
							cMensagem += "Os.:   " + AllTrim(_cNumOS) +  _center
							cMensagem += "Modelo : " + AllTrim(_cMissue) +  _center
							cMensagem += "Usuario Apontando " + AllTrim(cUsername)  +  _center
							
							U_ENVIAEMAIL(cTitemail,"paulo.francisco@bgh.com.br;fluciano@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
							
						EndIf
					EndIf
					
				EndIf
				
				If _cfpcfal ='S' .OR. (_cfpcfal ='C' .And. AllTrim(_csetfas2) $ _cfasfal)
					_lADDPECAF:=.T.
					_lobrigpf :=.T.
					U_ADDPECAF(1)
				Else
					If Posicione("ZZ1",1,xFilial("ZZ1") + LAB +  IIf('/' $ ALLTRIM(CODSET),substr(ALLTRIM(CODSET),1,At('/',ALLTRIM(CODSET))-2),ALLTRIM(CODSET)) + _cfase1,"ZZ1_PECFAL") == "S"
						If ApMsgYesNo("Essa fase Indica que deve informar peça Faltante. Deseja Apontar a(s) Peça(s) Faltante(s) para este Item?")
							_lADDPECAF:=.T.
							U_ADDPECAF(1)
						EndIf
					EndIf
				Endif
				
				Do while  _lobrigpf .And. len(_aRecnoZZ7) <= 0  // // Incluso Edson Rodrigues - 19/07/09
					apMsgStop("De acordo com as regras é obrigatorio informar o partnumber faltante.","Por favor preencher")
					_lobrigpf :=.T.
					U_ADDPECAF(1)
				Enddo
				
				If _lValidPartNO
					
					//Adiciona uma linha no acols
					If _lNewline .And. _lREGACOLS
						aAdd( aCols, Array(Len(aHeader)+1))
						For _ni := 1 to Len(aHeader)
							if aHeader[_ni,8] == 'C'
								aCols[Len(aCols),_ni] := ""
							ElseIf aHeader[_ni,8] == 'D'
								aCols[Len(aCols),_ni] := date()
							ElseIf aHeader[_ni,8] == 'N'
								aCols[Len(aCols),_ni] := 0
							else
								aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2],.T.)
							endif
						Next
						aCols[Len(aCols),Len(_aCabec)+1] := .F. // Nao esta deletado
					Else
						_lREGACOLS := .T.
					EndIf
					
					//Insere registros no acols
					For _nI := 1 to Len(_aCabec)
						_nPos := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == _aCabec[_nI,1]})
						If _nPos > 0
							aCols[Len(aCols), _nPos] := &(_aCabec[_nI,2])
						EndIf
						if _aCabec[_nI,1] == "OS"
							aCols[Len(aCols), _nPos] := _cNumOS
						ElseIf _aCabec[_nI,1] == "COR"
							_cDescCor := iif(!Empty(ZZ4->ZZ4_COR), " / " + Tabela("Z3",UPPER(ZZ4->ZZ4_COR)), "")
							aCols[Len(aCols), _nPos] := iif(!Empty(COR), COR, ZZ4->ZZ4_COR + _cDescCor)
						ElseIf _aCabec[_nI,1] == "SERIE"
							aCols[Len(aCols), _nPos] := ZZ4->ZZ4_CARCAC
						ElseIf _aCabec[_nI,1] == "LOTEIRL"
							aCols[Len(aCols), _nPos] := ZZ4->ZZ4_LOTIRL
						ElseIf _aCabec[_nI,1] == "CONTROC"
							aCols[Len(aCols), _nPos] := _cControl
						ElseIf _aCabec[_nI,1] == "DEFIN"
							aCols[Len(aCols), _nPos] := IIf(!Empty(_cdefcli),_cdefcli,DEFINF)
							//aCols[Len(aCols), _nPos] := LEFT(_cdefcli,5)
						ElseIf _aCabec[_nI,1] == "DEFCO"
							aCols[Len(aCols), _nPos] := DEFDET
						endif
					Next _nI
					oGet:ForceRefresh()
					
					Begin Transaction
					RecLock("ZZ3",.T.)
					ZZ3->ZZ3_FILIAL	:= xFilial("ZZ3")
					ZZ3->ZZ3_CODTEC	:= CODTEC
					
					If lUsrNext .Or. lUsrAdmi
						
						ZZ3->ZZ3_CODANA	:= CODANA
						
					EndIf
					
					ZZ3->ZZ3_LAB   	:= LAB
					ZZ3->ZZ3_DATA   := date()
					ZZ3->ZZ3_HORA   := Time()
					ZZ3->ZZ3_CODSET := CODSET
					ZZ3->ZZ3_FASE1  := iif("/" $ ALLTRIM(FAS1),left(ALLTRIM(FAS1),AT("/",ALLTRIM(FAS1))-1),ALLTRIM(FAS1)) // alterado - Edson Rodrigues em 17/03/09
					ZZ3->ZZ3_FASE2  := iif(ENCOS == "S", iif("/" $ ALLTRIM(FAS1),left(ALLTRIM(FAS1),AT("/",ALLTRIM(FAS1))-1),ALLTRIM(FAS1)), iif("/" $ ALLTRIM(FAS2),left(ALLTRIM(FAS2),AT("/",ALLTRIM(FAS2))-1),ALLTRIM(FAS2)))  //alterado - Edson Rodrigues em 17/03/09
					ZZ3->ZZ3_CODSE2 := IIf(!Empty(CODSE2),CODSE2,POSICIONE("ZZB",2,XFILIAL("ZZB")+ZZ3->(ZZ3_CODTEC+ZZ3_LAB+ZZ3_FASE2),"ZZB_CODSET"))
					ZZ3->ZZ3_DEFINF := LEFT(DEFINF,5)
					ZZ3->ZZ3_DEFDET := iif("/" $ DEFDET,left(ALLTRIM(DEFDET),AT("/",ALLTRIM(DEFDET))-1),ALLTRIM(DEFDET))
					
					If lUsrNext .Or. lUsrAdmi
						ZZ3->ZZ3_ACAO  := SOLUCAO
					Else
						ZZ3->ZZ3_LAUDO  := LAUDO
					EndIf
					_cDescCor := iif(!Empty(ZZ4->ZZ4_COR), " / " + Tabela("Z3",upper(ZZ4->ZZ4_COR)), "")
					ZZ3->ZZ3_COR    := iif(!Empty(COR), COR, ZZ4->ZZ4_COR + _cDescCor)
					ZZ3->ZZ3_ENCOS  := ENCOS
					ZZ3->ZZ3_IMEI   := IMEI
					ZZ3->ZZ3_DPYIME := DPYIMEI
					ZZ3->ZZ3_SWAP   := SWAP
					ZZ3->ZZ3_IMEISW := IMEINOVO
					ZZ3->ZZ3_MODSW  := MODIMEIN
					ZZ3->ZZ3_DPYINV := DPYINOVO
					ZZ3->ZZ3_CTROCA := _cControl
					ZZ3->ZZ3_UPGRAD := UPGRAD
					ZZ3->ZZ3_STATUS := "0"
					ZZ3->ZZ3_NUMOS  := _cNumOS
					ZZ3->ZZ3_LOTIRL := _clote
					ZZ3->ZZ3_SEQ    := SEQ
					ZZ3->ZZ3_USER   := cUserName
					ZZ3->ZZ3_ARTIME := cArtime
					ZZ3->ZZ3_MINUMB := cNumLin
					ZZ3->ZZ3_STATRA :='1' // incluso Edson Rodrigues 27/07/10
					ZZ3->ZZ3_ASCRAP :=getadvfval("ZZ1","ZZ1_SCRAP",xFilial("ZZ1") + LAB + ALLTRIM(LEFT(CODSET,6)) + _cfase1, 1, "N")  // incluso Edson Rodrigues 24/09/10
					ZZ3->ZZ3_DIFICU :=cdific
					ZZ3->ZZ3_ISICON :=ccondic   
					
					IF _lInfres
						ZZ3->ZZ3_QTDRES	:= val(cReset)
					ENDIF
					IF ENCOS = "S" .AND. _cinfsix="S"
						ZZ3->ZZ3_ACAO   :=crepair
					ENDIF

					if !empty(cSoftOut)					// TICKET 4818 
						ZZ3->ZZ3_SOFOUT := cSoftOut
					endif
					if !empty(cSofIn)					// TICKET 4818 
						ZZ3->ZZ3_SOFIN  := cSofIn
					endif
					if !empty(cTransc)					// TICKET 4818 
						ZZ3->ZZ3_TRANSC := cTransc
						ZZ3->ZZ3_GARMCL := cGarMCL
					endif
					
					ZZ3->ZZ3_OPEBGH := _cOpeBGH
					
					MSUnlock()
					ConfirmSX8()
					End Transaction
					
/*					TICKET 4818 - M.MUNHOZ - 16/04/2012
					If Empty(AllTrim(ctransope))
						ZZ4->(dbsetorder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
						If ZZ4->(DbSeek(xFilial("ZZ4") + IMEI + _cNumOS))
							If !Empty(AllTrim(cTransc))
								Begin Transaction
								RecLock('ZZ4',.F.)
								
								ZZ4->ZZ4_TRANSC := cTransc
								ZZ4->ZZ4_GARMCL := Iif( Len(AllTrim(cGarmcl)) > 0, cGarmcl, _cGarMcla)
								
								If !Empty(AllTrim(cSoftOut))
									ZZ4->ZZ4_SOFOUT := cSoftOut
								EndIf
								
								If !Empty(AllTrim(cSofIn))
									ZZ4->ZZ4_SOFIN  := cSofIn
								EndIf
								
								MsUnlock()
								End Transaction
							EndIf
						EndIf
					EndIf
*/					
					If lUsrNext .And. _cGrava .Or. lUsrAdmi .And. _cGrava
						Begin Transaction
						RecLock("SZ9",.T.)
						SZ9->Z9_FILIAL 	:= xFilial("SZ9")
						SZ9->Z9_NUMOS 	:= _cNumOS
						SZ9->Z9_SEQ    	:= SEQ
						SZ9->Z9_CODTEC 	:= CODTEC
						
						If lUsrNext .Or. lUsrAdmi
							
							SZ9->Z9_CODANA	:= CODANA
							
						EndIf
						SZ9->Z9_ITEM   	:= "01"
						SZ9->Z9_SYMPTO := iif("/" $ DEFDET,left(ALLTRIM(DEFDET),AT("/",ALLTRIM(DEFDET))-1),ALLTRIM(DEFDET))
						SZ9->Z9_ACTION	:= SOLUCAO
						SZ9->Z9_QTY		:= 0
						SZ9->Z9_USED  	:= "0"
						SZ9->Z9_PREVCOR := "C"
						SZ9->Z9_IMEI	:= IMEI
						SZ9->Z9_STATUS	:= "1"
						SZ9->Z9_FASE1	:= iif("/" $ ALLTRIM(FAS1),left(ALLTRIM(FAS1),AT("/",ALLTRIM(FAS1))-1),ALLTRIM(FAS1))
						SZ9->Z9_DTAPONT	:= dDataBase//Gravar data do apontamento da peca conforme solicitaçao do Edson - 27/07
						MSUnlock()
						ConfirmSX8()
						End Transaction
						
					EndIF
					
					_cGrava := _lSolucao

/*					TICKET 4818 - M.MUNHOZ - 16/04/2012

					If !Empty(AllTrim(ctransope))
						If Select("TrPtn") > 0
							TrPtn->(dbCloseArea())
						Endif
						
						_cQryTrPtn := " SELECT ZZJ.ZZJ_CODTRF CODTRF, ZZJ.ZZJ_OPERA OPERA, ZZJ.ZZJ_BLOQ BLOQ  "
						_cQryTrPtn += " FROM " + RetSqlName("ZZJ") + " ZZJ(NOLOCK) "
						_cQryTrPtn += " WHERE ZZJ.D_E_L_E_T_ = '' "
						_cQryTrPtn += " AND ZZJ.ZZJ_OPERA = '" + ctransope +"' "
						_cQryTrPtn += " AND ZZJ.ZZJ_BLOQ = 'N' "
						_cQryTrPtn += " AND ZZJ.ZZJ_FILIAL = '"+xFilial("ZZJ")+"' "
						
						TCQUERY _cQryTrPtn ALIAS "TrPtn" NEW
						
						If Len(AllTrim(TrPtn->CODTRF)) > 0
							
							ZZ4->(dbsetorder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
							If ZZ4->(DbSeek(xFilial("ZZ4") + IMEI + _cNumOS))
								
								Begin Transaction
								RecLock('ZZ4',.F.)
								
								ZZ4->ZZ4_OPEANT := AllTrim(ZZ4->ZZ4_OPEBGH)
								ZZ4->ZZ4_OPEBGH := TrPtn->OPERA
								ZZ4->ZZ4_TRANSC := AllTrim(TrPtn->CODTRF)
								
								If !Empty(AllTrim(cSoftOut))
									ZZ4->ZZ4_SOFOUT := cSoftOut
								EndIf
								
								If !Empty(AllTrim(cSofIn))
									ZZ4->ZZ4_SOFIN  := cSofIn
								EndIf
								
								MsUnlock()
								End Transaction
							EndIf
							
							SZA->(dbsetorder(3)) //ZA_FILIAL+ZA_NFISCAL+ZA_SERIE+ZA_IMEI
							If SZA->(DbSeek(xFilial("SZA") + _cnfenr + _cnfeser + IMEI))
								
								Begin Transaction
								RecLock('SZA',.F.)
								
								SZA->ZA_OPERBGH := TrPtn->OPERA
								SZA->ZA_CODRECL := _cDefMc
								
								MsUnlock()
								End Transaction
							EndIf
							
						Else
							MsgAlert("Não Foi Possivel Alterar Operações Favor Entrar em Contato com Supervisor da Area")
						EndIf
						
						If Select("TrPtn") > 0
							TrPtn->(dbCloseArea())
						Endif
						
					EndIf
*/
					ZZ4->(dbsetorder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
					ZZ4->(DbSeek(xFilial("ZZ4") + IMEI + _cNumOS))
					aadd(_aRecnoZZ3, {ZZ3->(recno()), _aRecnoSZ9, ZZ4->(recno()),_aRecnoZZ7 })
					
					//Limpa os campos do cabecalho e a matriz de Part Numbers // e a matriz de pecas faltantes
					IMEINOVO := CriaVar("ZZ3_IMEISW" ,.F.)
					IMEI 	 := CriaVar("ZZ3_IMEI"  ,.F.)
					MODIMEIN := CriaVar("ZZ3_MODSW" ,.F.)
					DPYINOVO := CriaVar("ZZ3_DPYINV" ,.F.)
					CONTROC  := CriaVar("ZZ3_CTROCA" ,.F.)
					UPGRAD   := CriaVar("ZZ3_UPGRAD",.F.)
					cartime	 := Space(20)
					cnumlin	 := Space(12)
					csofin	 := Space(10)
					csoftout := Space(10)
					ctransc	 := Space(5)
					cgarant  := Space(1)
					copebgh  := Space(3)
					_aRecnoSZ9 := {}
					_aRecnoZZ7 := {}
				Else
					_lValidPartNO := .T.
				EndIf
			endif
			IMEI := Space(20)
			oGet:ForceRefresh()
		EndIf
		
EndCase

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRAVA     ºAutor  ³Edson B. - ERP Plus º Data ³  15/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pergunta ao usuário se deseja gravar os apontamentos        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Grava()

Local _aRegSZ9 := {}
Local _aRegZZ7 := {}
Local _lgravado := .F.
Local _aAreaZZ4  := ZZ4->(GetArea())
Local _aAreaZZ3  := ZZ4->(GetArea())
Local _aAreaSZ9  := SZ9->(GetArea())
Local _aAreaZZ7  := ZZ7->(GetArea())
Local _nPosIMEI  := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "IMEI"})
Local _nPosOS    := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "OS"})

If _lREGACOLS
	
	If ApmsgYesNo("Deseja gravar os apontamentos para futura confirmação? Caso eles não sejam gravados neste momento, eles serão perdidos.","Grava apontamentos existentes?")
		U_STATUSOK(0)
	Else
		//Acrescentado Controle de Transacao - Edson Rodrigues - 17/05/10
		Begin Transaction
		
		//Apaga as OS apontadas
		Dbselectarea("ZZ3")
		For _nI := 1 To Len(_aRecnoZZ3)
			ZZ3->(dbGoto(_aRecnoZZ3[_nI,1]))
			//Retirado linhas de códigos e incluso funcao Edson Rodrigues - 27/07/10
			U_EXCLAPON(@_nI,_nPosIMEI,_nPosOS)
		Next
		
		End transaction
		If Len(_aModBlq) > 0
			_aModBlq := {}
		EndIf
		
		If Len(_agarBlq) > 0
			_agarBlq := {}
		EndIf

		
	EndIf
EndIf

restarea(_aAreaZZ4)
restarea(_aAreaZZ3)
restarea(_aAreaSZ9)
restarea(_aAreaZZ7)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXZZ3     ºAutor  ³Edson B. - ERP Plus º Data ³  12/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STATUSOK(_nStatus)

Local _cRegistro
Local _nPosSet1     := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODSET"})
Local _nPosFaseD    := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "FASED"})
Local _nPosSet2     := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODSE2"})
Local _nPosFaseO    := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "FASEO"})
Local _nPosIMEI     := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "IMEI"})
Local _nPosOS       := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "OS"})
Local _nPosEncOS    := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ENCOS"	})
Local _aAreaZZ4     := ZZ4->(GetArea())
Local _aAreaZZ3     := ZZ3->(GetArea())
Local _aAreaSZ9     := SZ9->(GetArea())
Local _aAreaZZ7     := ZZ7->(GetArea())
Local _aAreaAB1     := AB1->(GetArea())
Local _aAreaAB6     := AB6->(GetArea())
Local _aAreaAB7     := AB7->(GetArea())
Local _aAreaAB9     := AB9->(GetArea())
Local _aAreaZZ1     := ZZ1->(GetArea())
Local _aRegSZ9      := {}
Local _aRegZZ7      := {}
Local _aEmpenh      := {}
Local _aAponOP      := {}
Local _atransp      := {}
Local _aImpEtiq     := {}
Local _aEtiqMas     := {}
Local _newprod      := ""
Local _laponta      :=.T.
Local _lempenh      :=.T.
Local _lContinua    := .T.
Local _ANOTEMP      := {} // claudia 06/01/2010 - correcao de variavel nao existe
Local _nencerr      := 0
Local _nencer2      := 0
local _nqtdmas      := 0
Local _lencerr      := .F.
Local _cvletcdu     := "N"
Local _letequip		:= .F.
Local _lImpetqm		:= .F.
Local _cImpetqm		:= "N"
Local _limpmas      := .f.
Local _cmsgetqm		:= ""
Local _cqetqfix     := "N"
Local _coperac      := ""
Local _lvalmod      :=.T.
Local _lvalgar      :=.T. 
Local _lvalcli      :=.T.
Local _cmodinval    := ""
Local _cgarinval    := ""
Local _ccliinval    := ""
Local _cOsmodInv    := ""
Local _cOsgarInv    := ""
Local _cOscliInv    := ""
Local _cOssetfinv   := ""
Local _cfasetinv    := ""
Local _cmodelo      := ""
Local _cmodNew      := ""
Local _cgarant      := ""
Local _cgarnew      := ""          
Local _cclimas      := ""
Local _cclinew      := ""
Local _csetori1     := iif("/" $ ALLTRIM(CODSET), left(AllTrim(CODSET), at("/",AllTrim(CODSET))-1), AllTrim(CODSET))
Local _cfaseor1     := iif("/" $ ALLTRIM(FAS1), left(AllTrim(FAS1), at("/",AllTrim(FAS1))-1), AllTrim(FAS1))
Local _lpassou      := .t.
Local _lfasetm      := .t.
local _lvalpeca     := .T.
local _cOSpeca      := ""
Local _ncountz9     := 0
Private _cQtd		:= 0    //GetMv("MV_QTDETQM")  // Quantidade de Equipamentos para Impressão Etiquetas Master // Retirado busca ao parametro - Edson Rodrigues 18/01/12
Private _cNumEtq
Private lmsErroAuto := .F.
Private lOPCHK      := .F.  //VERIFICA SE TEM OP
Private	cArmPeca
Private	cEndProd
Private	cEndAudi
Private	cArmScra
Private	cEndScra
Private lRet	    := .T.
Private aDados	    := {}
Private Path        := "172.16.0.7"
Private _cmodetq    := ""
Private lRetIR		:= ""       

_Hora := Time()

Dbselectarea("ZZJ")
ZZJ->(dbsetOrder(1)) // ZZJ_FILIAL + ZZJ_OPEBGH+ ZZJ_LAB

DBSELECTAREA("ZZ4")
ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_NUMOS

DBSELECTAREA("ZZ3")
ZZ3->(dbSetOrder(1)) // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ

DBSELECTAREA("AB1")
AB1->(dbSetOrder(1)) // AB1_FILIAL + AB1_NRCHAM

DBSELECTAREA("AB6")
AB6->(dbSetOrder(1)) // AB6_FILIAL + AB6_NUMOS

DBSELECTAREA("AB7")
AB7->(dbSetOrder(6)) // AB7_FILIAL + AB7_NUMOS + AB7_NUMSER

ZZ1->(dbSetOrder(1))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
ZZ1->(dbSeek(xFilial("ZZ1") + LAB + AllTrim(_csetori1) +  AllTrim(_cfaseor1)))

//Incluso condição para voltar a apontar caso nao seja confirmado a mensagem abaixo - Edson Rodrigues - 01/10/10
For _nI := 1 To Len(_aRecnoZZ3)
	
	If aCols[_nI,Len(_aCabec)+1] == .F. //Se Linha nao estiver deletada         6
		
		
		
		DBSELECTAREA("ZZ3")
		ZZ3->(dbGoTo(_aRecnoZZ3[_nI,1]))
		
		DBSELECTAREA("ZZ4")
		If ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) ))
			
			Dbselectarea("ZZJ")
			If ZZJ->(dbseek(xFilial("ZZJ")+ ZZ4->ZZ4_OPEBGH+ZZ3->ZZ3_LAB))
				
				_csetori1     := iif("/" $ ALLTRIM(ZZ3->ZZ3_CODSET), left(AllTrim(ZZ3->ZZ3_CODSET), at("/",AllTrim(ZZ3->ZZ3_CODSET))-1), AllTrim(ZZ3->ZZ3_CODSET))
				_cfaseor1     := iif("/" $ ALLTRIM(ZZ3->ZZ3_FASE1), left(AllTrim(ZZ3->ZZ3_FASE1), at("/",AllTrim(ZZ3->ZZ3_FASE1))-1), AllTrim(ZZ3->ZZ3_FASE1))
				
				ZZ1->(dbSeek(xFilial("ZZ1") + LAB +  AllTrim(_csetori1) +  AllTrim(_cfaseor1)))
				
				
				_cvletcdu	:=	ZZJ->ZZJ_ETQCDU // Indica se imprime etiqueta CARD-U
				_csetmast	:= SPACE(6)  // ALLTRIM(ZZJ->ZZJ_SETMAS) // variavel que obtem setor(es) de impressao de etiqueta Master BGH
				_cfasmast	:= SPACE(6)  //ALLTRIM(ZZJ->ZZJ_FASMAS) // variavel que obtem fases(es) de impressao de etiqueta Master BGH
				cArmPeca	:= 	ZZJ->ZZJ_ALMEP
				cEndProd	:= 	ZZJ->ZZJ_ENDPRO
				cEndAudi	:= 	ZZJ->ZZJ_ENDAUD
				cArmScra	:= 	ZZJ->ZZJ_ALMSCR
				cEndScra	:= 	ZZJ->ZZJ_ENDSCR
				_cQtd       :=  ZZJ->ZZJ_QTDETM
				//_cQtd       :=  1
				_cqetqfix   :=  ZZJ->ZZJ_QMFIXA
				_cImpetqm	:=  ZZJ->ZZJ_IMETQM
				//_cImpetqm	:=  "N"
				_coperac    :=  ZZ4->ZZ4_OPEBGH
			   	_cimpmas    :=  ZZ1->ZZ1_IMPMAS
			    //_cimpmas    :=  "N"
				_cetqeqp    :=  ZZ1->ZZ1_ETQEQP
				_claboper   :=  ZZJ->ZZJ_LAB
				_cvlmodm    :=  ZZJ->ZZJ_VLMODM
				_cvlgarm    :=  ZZJ->ZZJ_VLGARM
				_cvlclim    :=  ZZJ->ZZJ_VLCLIM
				_lpassou    :=  .t.
				_lfasetm    :=  .t.
				
				IF _cimpmas=="S"
					_csetmast:= alltrim(_csetori1)
					_cfasmast:= alltrim(_cfaseor1)
				ENDIF
				
				IF _cetqeqp == "S"
					_letequip :=.t.
				ENDIF
				
				IF _lencerr .and. _cimpmas <> "S" .and. _limpmas
					_lfasetm    :=  .f.
					_cOssetfinv := _cOssetfinv+ALLTRIM(ZZ4->ZZ4_OS)+" / "
					_cfasetinv  := _cfasetinv+alltrim(_csetori1)+"/"+alltrim(_cfaseor1)+" | "
				ENDIF
				
				DBSELECTAREA("ZZ3")
				
				If  ZZ3->ZZ3_ENCOS == "S" .And. _nStatus == 1
					
					IF (_cvletcdu="S" .or. _cImpetqm="S")  .and. _cimpmas="S"
						
						If (dbSeek(xFilial("ZZ3") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) )) .And. (ZZ3->ZZ3_IMEI==aCols[_nI,_nPosIMEI] .And. LEFT(ZZ3->ZZ3_NUMOS,6)==LEFT(aCols[_nI, _nPosOS],6))
							If AB6->(dbSeek(xFilial("AB6") + left(ZZ3->ZZ3_NUMOS,6) )) .And. AB6->AB6_STATUS <> 'B' .And. ;
								AB7->(dbSeek(xFilial("AB7") + left(ZZ3->ZZ3_NUMOS,6) + ZZ3->ZZ3_IMEI ))
								
								_lencerr:=.T.
								_nencerr++
								
								IF _nencerr == 1
									_cmodelo := ZZ4->ZZ4_CODPRO
									_cnumser := ZZ4->ZZ4_IMEI
									_cgarant := ZZ4->ZZ4_GARANT
									_cclimas := ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA
									_cmodnew := ZZ4->ZZ4_CODPRO
									_cgarnew := ZZ4->ZZ4_GARANT
                                    _cclinew := ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA
									
									
									IF empty(_cgarant) .and. _cvletcdu<>"S" .and. _cImpetqm="S" .and. _cvlgarm=="S"
										If ApMsgYesNo("Esse Aparelho não tem Garantia informada. Ele esta na GARANTIA ?","APARELHO GARANTIA SIM OU NAO ?")
											_cgarinf :="S"
										Else
											_cgarinf :="N"
										Endif
										
										RecLock("ZZ4",.F.)
										ZZ4->ZZ4_GARANT := _cgarinf
										MSUnlock()
									ENDIF
									_cgarnew := ZZ4->ZZ4_GARANT
									_cgarant := ZZ4->ZZ4_GARANT
								ELSE
									_cmodnew := ZZ4->ZZ4_CODPRO
									_cgarnew := ZZ4->ZZ4_GARANT
								    _cclinew := ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA
								ENDIF
								
								// Valida Modelo
								If _lencerr .and. _nencerr > 0 .and. (_cvletcdu="S" .or. _cImpetqm="S" ) .and. _cmodelo<>_cmodnew  .and. _cimpmas="S" .and. _cvlmodm=="S"
									_lvalmod      :=.f.
									_lpassou      :=.f.
									_cmodinval    := _cmodinval+alltrim(_cmodnew)+" / "
									_cOsmodInv    := _cOsmodInv+ALLTRIM(ZZ4->ZZ4_OS)+" / "
								Endif
								
								// Valida Garantia
								If _lencerr .and. _nencerr > 0 .and. _cvletcdu<>"S" .and. _cImpetqm="S" .and. _cgarant<>_cgarnew  .and. _cimpmas="S" .and. _cvlgarm = "S"
									_lvalgar      :=.f.
									_lpassou      :=.f.
									_cgarinval    := _cgarinval+alltrim(_cgarnew)+" / "
									_cOsgarInv    := _cOsgarInv+ALLTRIM(ZZ4->ZZ4_OS)+" / "
								Endif             
								
								// Valida Cliente 
								If _lencerr .and. _nencerr > 0 .and. _cvletcdu<>"S" .and. _cImpetqm="S" .and. _cclimas<>_cclinew  .and. _cimpmas="S" .and. _cvlclim = "S"
									_lvalcli      :=.f.
									_lpassou      :=.f.
									_ccliinval    := _ccliinval+alltrim(_cclinew)+" / "
									_cOscliInv    := _cOscliInv+ALLTRIM(ZZ4->ZZ4_OS)+" / "
								Endif             
								
								
								If _lpassou
									aadd(_aEtiqMas,{alltrim(left(ZZ3->ZZ3_NUMOS,6)),ZZ3->ZZ3_IMEI})
									_limpmas :=.t.
								Endif
							EndIf
						Endif
					ENDIF
					
					
					If !Empty(cArmPeca) .And. !Empty(cEndProd) .And. !Empty(cEndAudi) .And. !Empty(cArmScra) .And. !Empty(cEndScra)
						
						DBSELECTAREA("SZ9")
						SZ9->(dbSetOrder(2))//Z9_FILIAL, Z9_IMEI, Z9_NUMOS, Z9_SEQ
						If SZ9->(dbSeek(xFilial("SZ9") + ZZ3->ZZ3_IMEI + Left(ZZ3->ZZ3_NUMOS,6)))
							
							While SZ9->(!Eof()) .And. xFilial("SZ9") == SZ9->Z9_FILIAL .And. Left(ZZ3->ZZ3_NUMOS,6) == AllTrim(SZ9->Z9_NUMOS) .And. ;
								Alltrim(SZ9->Z9_IMEI) == AllTrim(ZZ3->ZZ3_IMEI)
								
								If !Empty(SZ9->Z9_PARTNR)
									
									If Empty(SZ9->Z9_NUMSEQ) //.AND. SZ9->Z9_COLETOR<>"S"
										
										lRet :=	u_SaldPeca(Left(SZ9->Z9_PARTNR,15),SZ9->Z9_QTY,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,cArmPeca,cEndProd)
										
									Else
										
										lRet := .F.
										
									EndIf
									
								EndIf
								
								If lRet .And. !Empty(SZ9->Z9_PARTNR) .And. Empty(AllTrim(SZ9->Z9_NUMSEQ)) //.AND. SZ9->Z9_COLETOR<>"S"
									
									aAdd(aDados,{ZZ4->ZZ4_OPEBGH, Left(SZ9->Z9_PARTNR,15), SZ9->Z9_SEQ, SZ9->Z9_NUMOS, SZ9->Z9_QTY, cArmPeca, cEndProd, cArmPeca, cEndAudi, SZ9->(RECNO()) })
									
									/* Array para Transferencia de Armazem - Endereçamento.
									Array aDados
									1-> Operação,
									2-> ParNumber,
									3-> Num. Seq.,
									4-> Num. O.S.,
									5-> Quantidade,
									6-> Arm. Origem,
									7-> End. Origem,
									8-> Arm. Destino,
									9-> End. Destino 	*/
									
								Elseif !lRet .And. !Empty(SZ9->Z9_PARTNR) .And. Empty(AllTrim(SZ9->Z9_NUMSEQ)) //.AND. SZ9->Z9_COLETOR<>"S"
								
										//Gravar no Z9 se o item nao gerou movimento na tabela SD3 - Conforme solicitacao do Edson - 27/07
										reclock("SZ9",.F.)
										SZ9->Z9_ATUSD3 :='N'
										msunlock()		
										
										_ncountz9++
										_lvalpeca :=.F.
										_cOSpeca  :=_cOSpeca+alltrim(SZ9->Z9_NUMOS)+" / " 								 
		                                AutoGRLog("OS:"+alltrim(SZ9->Z9_NUMOS)+ " Peça : "+alltrim(SZ9->Z9_PARTNR)+" Qtde: "+STRZERO(SZ9->Z9_QTY,3)+" --> Sem Saldo fisico/Endereço ") 
		                          		IF _ncountz9 == 1
		                           		    cMensagem := "OSs Não Encerradas por falta de saldo nos partnumbers em : "+DTOC(date())+" - "+time()+" hrs."+ _center
		     							    cMensagem += "Equipamento Sendo Apontado : "+AllTrim(SZ9->Z9_IMEI)+ _center
    									    cMensagem += "OS : " + AllTrim(SZ9->Z9_NUMOS)+ _center
		     							    cMensagem += "Usuario Apontando " + AllTrim(cUsername)  +_center
		                          		ENDIF
									    

									    cMensagem += "Peça : " + AllTrim(SZ9->Z9_PARTNR)+ _center
									    cMensagem += "Qtde : " + STRZERO(SZ9->Z9_QTY,3)+ _center
		   							    cMensagem += "---------------------------------------   " + _center 
								EndIf
								SZ9->(dbSkip())
							EndDo
							
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Endif
Next

IF !_lvalpeca  
   Alert("Existe(m) peça(s) apontada(s) com indisponibilidade de saldo em estoque. Não pdoerá prosseguir com encerramento. Fale com seu superior")
   //Alert("Existe(m) peça(s) apontada(s) com indisponibilidade de saldo em estoque. Fale Imediatamente com seu superior")
   cTitemail:="OS Não encerradas por falta de saldo em estoque de Peças" 
   U_ENVIAEMAIL(cTitemail,"LiderancaNextel@bgh.com.br;fernando.luciano@bgh.com.br;nivea.goncalves@bgh.com.br;denise.marcelino@bgh.com.br;marcos.santos@bgh.com.br;PCP@bgh.com.br;rodrigo.bazzo@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
   MostraErro()
ENDIF

// Faz validacoes para impressao da etiqueta master - Edson Rodrigues 18/01/12
IF _limpmas
	
	IF _cvletcdu="S"  .and. !(lUsrNext .Or. lUsrAdmi)
		_cmsgetqm:= "Usuário NAO pertencente ao grupo Nextel ou Administradores. Sem autorizaçao para encerrar erquipamentos com Impressão da Etiqueta Máster. Solicitar Permissao !"
		
	Elseif !_lvalmod
		_cmsgetqm:= "Modelo(s) :"+_cmodinval+" referente(s) a(s) OS(s) : "+_cOsmodInv+" diferente(s) do primeiro apontado : "+_cmodelo +"nesse encerramento. Delete a(s) Linha(s) do(s) mesmo(s e confirme o encerramento novmaente !"
		
	Elseif !_lvalgar
		_cmsgetqm:= "Garantia :"+_cgarinval+" referente(s) a(s) OS(s) : "+_cOsgarInv+" são diferente(s) do primeiro num. serie apontado : "+_cnumser +" nesse encerramento. Delete a(s) Linha(s) do(s) mesmo(s e confirme o encerramento novmaente !"
		
		//Elseif (_cvletcdu="S" .or. _cImpetqm="S")   .And. _cimpmas=="S" .and.  ALLTRIM(CODSET) <> AllTrim(_csetmast)
		//	If ApmsgYesNo("Esse Apontamento se trata de um Encerramento para Geração de Etiqueta Master ?")
		//		_cmsgetqm:= "Setor atual posicionado : "+left(CODSET,6)+"  não é permitido a impressao da etiqueta master. Setor(es) autorizado(s) :  "+AllTrim(_csetmast)+". Altere o Setor para fazer a Impressão da Etiqueta Master !"
		//	Else
		//		_lImpetqm := .T.
		//	Endif
		
		//Elseif (_cvletcdu="S" .or. _cImpetqm="S")   .And. _cimpmas=="S" .and. ALLTRIM(FAS1) $ AllTrim(_cfasmast)
		//	If ApmsgYesNo("Esse Apontamento se trata de um Encerramento para Geração de Etiqueta Master ?")
		//		_cmsgetqm:= "Fase atual posicionada : "+left(CODSET,6)+"  não é permitido para impressao da etiqueta master. Fase(s) não autorizada(s0 :  "+AllTrim(_cfasemast)+". Altere o Setor para fazer a Impressão da Etiqueta Master !"
		//	Else
		//		_lImpetqm := .T.
		//	Endif     
		
	Elseif !_lvalcli
		_cmsgetqm:= "Cliente(s) :"+_ccliinval+" referente(s) a(s) OS(s) : "+_cOscliInv+" são diferente(s) do primeiro num. serie apontado : "+_cnumser +" nesse encerramento. Delete a(s) Linha(s) do(s) mesmo(s e confirme o encerramento novmaente !"	
		
	Elseif !_lfasetm
		_cmsgetqm:= "A(s) OS(s) "+_cOssetfinv+" foi(ram) apontada(s) com os setor(es)/fase(s) : "+_cfasetinv+" de encerramento que não permite(m) a geração de etiqueta master. Delete a(s) Linha(s) dessa(s) OS(s) e confirme o encerramento novmaente !"
		
	Elseif _cqetqfix="S" .and. len(_aEtiqMas) <> _cQtd
		_cmsgetqm:="Necessário total de " + strzero(_cQtd,3) + " equipamentos para finalização e Impressão da Etiqueta Máster. Existe(m) "+strzero(len(_aEtiqMas),3)+" Apontados !! . Verificar Apontamentos"
		
	Elseif  _cqetqfix="N" .and. len(_aEtiqMas) > _cQtd
		If ApmsgYesNo("A quantidade encerrada  : "+strzero(len(_aEtiqMas),3)+" para impressão da etiqueta master é maior que a cadastrada para essa operação : " +strzero(_cQtd,3) + ". Quer fechar com essa quantidade encerrada ?")
			_lImpetqm := .T.
		Else
			_cmsgetqm:= "quantidade encerrada : "+strzero(len(_aEtiqMas),3)+" é maior que a cadastrada para essa operação : " +strzero(_cQtd,3) + ". Sem confirmação do usuário !"
		Endif
		
	Elseif _cqetqfix="N" .and. len(_aEtiqMas) <= _cQtd
		If ApmsgYesNo("sera encerrado : "+strzero(len(_aEtiqMas),3)+" Aparelhos / Componentes nessa etiqueta master . Confirma encerramento ?")
			_lImpetqm := .T.
		Endif
	Else
		_lImpetqm:= .T.
		
	Endif
ENDIF


If _lImpetqm
	cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97())
	_cKIT		:= SPACE(15)
	_lSemKit	:= .F.//CANCELOU TELA DE KIT?
	_lRetKIT    := .T.//TEM SALDO DO KIT?
	For _nI := 1 To Len(_aRecnoZZ3)
		If aCols[_nI,Len(_aCabec)+1] == .F. //Se Linha nao estiver deletada         6
			DBSELECTAREA("ZZ3")
			ZZ3->(dbGoTo(_aRecnoZZ3[_nI,1]))
			DBSELECTAREA("ZZ4")
			If ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) ))
				_cKITZZJ	:= Posicione("ZZJ",1,xFilial("ZZJ")+  ZZ4->ZZ4_OPEBGH,"ZZJ_INFKIT")
				_cKITZZ1 	:= Posicione("ZZ1",1,xFilial("ZZ1") + ZZ3->ZZ3_LAB + LEFT(ZZ3->ZZ3_CODSET,6) + LEFT(ZZ3->ZZ3_FASE1,2)+ SPACE(04),"ZZ1_INFKIT")
				If _cKITZZJ == "S" .and. _cKITZZ1 == "S" .and. Empty(_cKit)
					oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
					@ 0,0 TO 200,300 DIALOG oDlgKIT TITLE "Kit"
					oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlgKIT)
					@ 05,050 SAY oV1 var "Selecione o KIT:" of oDlgKIT FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
					@ 40,010 GET _cKit Size 100,080 PICTURE "@!" valid ExistCPO('SB1',_cKit)  F3 'SB1'
					@ 80,085 BMPBUTTON TYPE 1 ACTION oDlgKIT:End()
					@ 80,120 BMPBUTTON TYPE 2 ACTION oDlgKIT:End()
					Activate MSDialog oDlgKIT Centered
					If !empty(_cKit)
						Processa({|| _lRetKIT  := ProcKIT(_cKit,ZZ4->ZZ4_CODPRO,ZZ4->ZZ4_CODCLI,ZZ4->ZZ4_LOJA,ZZ4->ZZ4_OPEBGH,len(_aEtiqMas)) },"Processando KIT de Acessorios...")
					Else
						_lSemKit	:= .T.
						_cKit := "NAO INFORMADO"
					Endif
				ElseIf _cKITZZJ <> "S" .and. _cKITZZ1 <> "S"//se nao controlar sai do laço
					Exit
				Endif
				If !_lRetKIT .and. !_lSemKit
					MsgAlert("Favor selecionar outro KIT para prosseguir!")
					_lImpetqm := .F.
					Exit
				Else
					Begin Transaction
					reclock("ZZ4",.f.)
					ZZ4->ZZ4_CODKIT := _cKit
					msunlock()
					End Transaction
				Endif
			Endif
		Endif
	Next _nI
Endif



If (_lencerr .or. _limpmas) .and. (_nencerr > 0 .or. len(_aEtiqMas) > 0 )
	IF _lImpetqm
		
		IF  ApmsgYesNo("Será encerrado "+strzero(_nencerr,3)+" aparelho(s) e gerado 1 etiq. master com "+strzero(len(_aEtiqMas),3)+" itens. Deseja prosseguir com a confirmação ? Caso não queira prosseguir, voce podera continuar apontando.","Re-Confirma gravacao de apontamentos existentes?")
			_cmodetq:= IIF(_cvletcdu="S","1","2")
			_cNumEtq :=	NumEtq(_coperac,_claboper,"S",_cmodetq)
			
		Else
			restarea(_aAreaZZ4)
			restarea(_aAreaZZ3)
			restarea(_aAreaSZ9)
			restarea(_aAreaZZ7)
			restarea(_aAreaAB1)
			restarea(_aAreaAB6)
			restarea(_aAreaAB7)
			restarea(_aAreaZZ1)
			_lscreen:=.T.       
			return(.F.)
		Endif
		
	Else
		apMsgInfo(_cmsgetqm)
		restarea(_aAreaZZ4)
		restarea(_aAreaZZ3)
		restarea(_aAreaSZ9)
		restarea(_aAreaZZ7)
		restarea(_aAreaAB1)
		restarea(_aAreaAB6)
		restarea(_aAreaAB7)
		restarea(_aAreaZZ1)
		_lscreen:=.T.
		return(.F.)
	Endif
EndIf


For _nI := 1 To Len(_aRecnoZZ3)
	
	//EDUARDO NAKAMATU 5.2.2010 - ANALISA SE TEM OP E VE DEPENDENCIAS DE ESTOQUE, OPERACOES SONY
	//If GETMV("MV_BIALE") // SE DEIXA HABILITADO A ROTINA PARA EVITAR ERROS , DEPOIS EXCLUO ISSO!
	//	If !lOPCHK
	//		DBSELECTAREA("ZZ3")
	//		ZZ3->(dbGoTo(_aRecnoZZ3[_nI,1]))
	//		lOPCHK := VER_OP()
	//
	//		If !lOPCHK
	//			Msgalert("falha na analise de OP, revise todos os itens listados !")
	//			return(.F.)
	//		EndIf
	//	EndIf
	//EndIf
	
	Begin Transaction
	
	
	If aCols[_nI,Len(_aCabec)+1] == .F. //Se Linha nao estiver deletada
		
		//Posiciona no registro do ZZ3/ZZ4
		DBSELECTAREA("ZZ3")
		ZZ3->(dbGoTo(_aRecnoZZ3[_nI,1]))
		
		DBSELECTAREA("ZZ4")
		ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_NUMOS
		// Acrescentado para verificar se o acols esta posicionado certo no recno e se o registro
		// ainda existe no sistema ou se foi deletado por outro usuário // Edson Rodrigues - 27/07/10
		DBSELECTAREA("ZZ3")
		If (ZZ3->ZZ3_IMEI==aCols[_nI,_nPosIMEI] .And. LEFT(ZZ3->ZZ3_NUMOS,6)==LEFT(aCols[_nI, _nPosOS],6)) .AND.  (!LEFT(ZZ3->ZZ3_NUMOS,6) $ _cOSpeca) //--> Retirado o ultimo .and. conforme solicitação do Fernando Luciano em 09/05/2011. Edson Rodrigues
			
			DBSELECTAREA("ZZ4")
			If ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) ))
				
				DBSELECTAREA("ZZ3")
				RecLock("ZZ3",.F.)
				ZZ3->ZZ3_STATUS := cValToChar(_nStatus)
				ZZ3->ZZ3_STATRA :='0'
				ZZ3->ZZ3_HORA   := Time()
				ZZ3->ZZ3_DATA   := date()   //Acrescentado Edson Rodrigues - 11/08/10
				MSUnlock()
				
				// Altera status dos part numbers apontados
				_aRegSZ9 := {}
				If LEN(_aRecnoZZ3[_ni,2]) > 0
					_aRegSZ9 := _aRecnoZZ3[_ni,2]
				EndIf
				
				DBSELECTAREA("SZ9")
				For _nH := 1 To Len(_aRegSZ9)
					SZ9->(dbGoTo(_aRegSZ9[_nH]))
					RecLock("SZ9",.F.)
					SZ9->Z9_STATUS := cValToChar(_nStatus)
					MsUnlock()
				Next _nH
				
				// Altera status das Pecas Faltante
				_aRegZZ7 := {}
				If LEN(_aRecnoZZ3[_ni,4]) > 0
					_aRegZZ7 := _aRecnoZZ3[_ni,4]
				EndIf
				
				DBSELECTAREA("ZZ7")
				For _nH := 1 To Len(_aRegZZ7)
					//If ZZ7->(dbGoTo(_aRegZZ7[_nH]))
					ZZ7->(dbGoTo(_aRegZZ7[_nH]))
					RecLock("ZZ7",.F.)
					ZZ7->ZZ7_STATUS := cValToChar(_nStatus)
					MsUnlock()
					//Endif
				Next _nH
				
				IF _letequip
					aAdd(_aImpEtiq, {ZZ3->ZZ3_IMEI, ZZ4->ZZ4_OS, AB7->AB7_ITEM, ZZ4->ZZ4_NFENR, ZZ4->ZZ4_NFESER,ZZ4->ZZ4_CODPRO,ZZ4->ZZ4_NFEDT,0, ZZ4->ZZ4_CODCLI, ZZ4->ZZ4_LOJA,ZZ4->ZZ4_XLOTE,,,,,,ZZ4->(recno()), ZZ4->ZZ4_ITEMD1}) // M.Munhoz - 16/08/2011
				ENDIF
				
				
				// Executa encerramento da OS quando selecionado
				DBSELECTAREA("ZZ3")
				ZZ3->(dbGoTo(_aRecnoZZ3[_nI,1])) //Posiciona no registro do ZZ3
				If ZZ3->ZZ3_ENCOS == "S" .And. _nStatus == 1 .And. ZZ3->ZZ3_STATUS == "1"
					
					DBSELECTAREA("ZZ4")
					RecLock("ZZ4",.F.)
					ZZ4->ZZ4_STATUS := "5"    
					MsUnlock()
		
					_cNrCham := GetAdvFVal("AB2","AB2_NRCHAM",xFilial("AB2") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) + "01", 5,"") // AB2_FILIAL + AB2_NUMSER + AB2_NUMOS
					
					DBSELECTAREA("AB1")
					AB1->(dbSetOrder(1)) // AB1_FILIAL + AB1_NRCHAM
					
					DBSELECTAREA("AB6")
					AB6->(dbSetOrder(1)) // AB6_FILIAL + AB6_NUMOS
					
					DBSELECTAREA("AB7")
					AB7->(dbSetOrder(6)) // AB7_FILIAL + AB7_NUMOS + AB7_NUMSER
					
					If AB6->(dbSeek(xFilial("AB6") + left(ZZ3->ZZ3_NUMOS,6) )) .And. AB6->AB6_STATUS <> 'B' .And. ;
						AB7->(dbSeek(xFilial("AB7") + left(ZZ3->ZZ3_NUMOS,6) + ZZ3->ZZ3_IMEI ))
						
						If AB1->(dbSeek(xFilial("AB1") + _cNrCham ))
							_dChamEmis := AB1->AB1_EMISSA
							_cChamHora := AB1->AB1_HORA
						Else
							_dChamEmis := date()
							_cChamHora := time()
						Endif
						
						Reclock("AB6",.F.)
						AB6->AB6_STATUS := 'B'
						Msunlock()
						
						Reclock("AB7",.F.)
						AB7->AB7_TIPO   := '4'
						Msunlock()
						
						Reclock("AB9",.T.)
						AB9->AB9_FILIAL := xFilial("AB9")
						AB9->AB9_SN     := ALLTRIM(ZZ3->ZZ3_IMEI)
						AB9->AB9_NRCHAM := _cNrCham
						AB9->AB9_NUMOS  := left(ZZ3->ZZ3_NUMOS,6)+"01"
						AB9->AB9_CODTEC := ZZ3->ZZ3_CODTEC
						AB9->AB9_SEQ    := ZZ3->ZZ3_SEQ
						AB9->AB9_LINHA  := ZZ3->ZZ3_FASE2
						AB9->AB9_DTCHEG := _dChamEmis
						AB9->AB9_HRCHEG := _cChamHora
						AB9->AB9_DTINI  := _dChamEmis
						AB9->AB9_HRINI  := _cChamHora
						AB9->AB9_DTSAID := date()
						AB9->AB9_HRSAID := time()
						AB9->AB9_DTFIM  := date()
						AB9->AB9_HRFIM  := time()
						AB9->AB9_CODPRB := AB7->AB7_CODPRB
						AB9->AB9_GARANT := "N"
						AB9->AB9_TIPO   := "1"
						AB9->AB9_CODCLI := ZZ4->ZZ4_CODCLI
						AB9->AB9_LOJA   := ZZ4->ZZ4_LOJA
						AB9->AB9_CODPRO := ZZ4->ZZ4_CODPRO
						AB9->AB9_TOTFAT := "01:00"
						AB9->AB9_BGHKIT := AB6->AB6_BGHKIT
						AB9->AB9_STATAR := "1" // 1=Tarefa encerrada / 2=Tarefa em aberto
						AB9->AB9_NUMVEZ := AB6->AB6_NUMVEZ
						AB9->AB9_SERIAL := ZZ4->ZZ4_CARCAC
						AB9->AB9_XTREPA := time()
						AB9->AB9_SWAPAN := ZZ4->ZZ4_SWANT
						AB9->AB9_XTCENC := ZZ3->ZZ3_CODTEC
						AB9->AB9_NOVOSN := ZZ4->ZZ4_SWAP
						AB9->AB9_OPER   := ZZ4->ZZ4_OPER
						msunlock()
						
					Else
						_lContinua := .F.
					Endif
					
					//=======================================================================
					// Faz apontamento das OP gerada para o processo Sony Refurbish
					DBSELECTAREA("ZZ4")
					lvdaprod  :=U_VLDPROD(ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB) //Valida operações para chamar a função de inclusão ou estorno de OP. Edson Rodrigues 05/05/10
					If lvdaprod
						dbselectarea("ZZJ")
						ZZJ->(dbsetOrder(1)) // ZZJ_FILIAL + ZZJ_OPEBGH+ ZZJ_LAB
						If ZZJ->(dbseek(xFilial("ZZJ")+ ZZ4->ZZ4_OPEBGH+ZZ3->ZZ3_LAB))
							_lContinua  := .T.
							_nreczzj    :=ZZJ->(RECNO())
							//Retirado linhas de códigos e incluso funcao Edson Rodrigues - 27/07/10
							U_APONPECA(@_ni,@_lContinua,_nreczzj,_nPosFaseO)
						Else
							ApMsgInfo("Não foi encontrado a operacao cadastrada para OS "+ZZ4->ZZ4_OS+" e IMEI "+ZZ4->ZZ4_IMEI+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
							_lContinua := .F.
						EndIf
					EndIf
					
					//Adicionado para contar quantos aparelhos foram ecerrados. Edson Rodrigues - 16/09/10
					If _lContinua
						_lencerr:=.T.
						_nencer2++
					Endif
					
				Endif
				
				// Atualiza o arquivo de Entrada/Saida Massiva com informacoes de cada atendimento
				// M.Munhoz - TICKET 4818 - 16/04/2012 - toda e qualquer gravacao no ZZ4 deve ser feita dentro deste IF. 
				DBSELECTAREA("ZZ4")
				
				If _lContinua .And. ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) )) .And. ;
					_nStatus==1  .And. ZZ3->ZZ3_STATUS == "1"
					
					_nPosBar := at("/",aCols[_ni,_nPosSet1])
					_nPosBar := iif(_nPosBar > 0, _nPosBar - 1, len(aCols[_ni,_nPosSet1]) )
					//				_cSetOri := AllTrim(left(aCols[_ni,_nPosSet1], at("/",aCols[_ni,_nPosSet1]) - 1 ))
					_cSetOri := AllTrim(left(aCols[_ni,_nPosSet1], _nPosBar ))
					_nPosBar := 0
					
					_nPosBar := at("/",aCols[_ni,_nPosFaseO])
					_nPosBar := iif(_nPosBar > 0, _nPosBar - 1, len(aCols[_ni,_nPosFaseO]) )
					//				_cFasOri := AllTrim(left(aCols[_ni,_nPosFaseO], at("/",aCols[_ni,_nPosFaseO]) - 1 ))
					_cFasOri := AllTrim(left(aCols[_ni,_nPosFaseO], _nPosBar - 1 ))
					_nPosBar := 0
					
					If ZZ3->ZZ3_ENCOS == "S"
						_cSetAtu := _cSetOri
						_cFasAtu := _cFasOri
					Else
						_nPosBar := at("/",aCols[_ni,_nPosSet2])
						_nPosBar := iif(_nPosBar > 0, _nPosBar - 1, len(aCols[_ni,_nPosSet2]) )
						//					_cSetAtu := AllTrim(left(aCols[_ni,_nPosSet2], at("/",aCols[_ni,_nPosSet2]) - 1 ))
						_cSetAtu := AllTrim(left(aCols[_ni,_nPosSet2], _nPosBar))
						_nPosBar := 0
						
						_nPosBar := at("/",aCols[_ni,_nPosFaseD])
						_nPosBar := iif(_nPosBar > 0, _nPosBar - 1, len(aCols[_ni,_nPosFaseD]) )
						//					_cFasAtu := AllTrim(left(aCols[_ni,_nPosFaseD], at("/",aCols[_ni,_nPosFaseD]) ))
						_cFasAtu := AllTrim(left(aCols[_ni,_nPosFaseD], _nPosBar ))
						_nPosBar := 0
					Endif
					_aFasMax := {,,,}
					// Incluso parametro setor atual ou origem na funcao abaixo -Edson Rodrigues 13/12/10.
					_aFasMax := u_FasMax(ZZ4->ZZ4_LOCAL, ZZ4->ZZ4_GRMAX, iif(!Empty(_cFasAtu),_cFasAtu, _cFasOri),iif(!Empty(_cSetAtu),_cSetAtu,_cSetOri) )
					
					// Atualiza o Documento de Separacao 
					If  ! Empty(_cNumDoc) .AND. Empty(ZZ4->ZZ4_DOCSEP)
						DbSelectArea("ZZY")  // Tabela de Planejamento da Producao
					 	DbSetOrder(3)  // ZZY_FILIAL, ZZY_NUMMAS, ZZY_CODMAS, ZZY_CODPLA, R_E_C_N_O_, D_E_L_E_T_
					 	_cNumMaster := ZZ4->ZZ4_ETQMEM
					 	If Empty(_cNumMaster)
					 	   _cNumMaster := "SEM_MASTER"+SPACE(10)
                    	Endif
                    	If DbSeek(xFilial("ZZY")+_cNumDoc+_cNumMaster,.F.)
	 	   				  	RecLock("ZZY",.F.)
						      ZZY->ZZY_QTDSEP := ZZY->ZZY_QTDSEP+1
						  	msUnlock()  
					 	Endif
                    Endif
					DBSELECTAREA("ZZ4")
					reclock("ZZ4",.F.)
					ZZ4->ZZ4_SETATU := iif(!Empty(_cSetAtu), _cSetAtu, _cSetOri)
					ZZ4->ZZ4_FASATU := iif(!Empty(_cFasAtu), _cFasAtu, _cFasOri)
					ZZ4->ZZ4_STATUS := iif(ZZ3->ZZ3_ENCOS == "S" .And. ZZ3->ZZ3_STATUS == "1" .And. _nStatus == 1,"5","4")
					ZZ4->ZZ4_SWAP   := iif(!Empty(ZZ3->ZZ3_IMEISW), ZZ3->ZZ3_IMEISW, ZZ4->ZZ4_SWAP  )
					ZZ4->ZZ4_DPYINV := iif(!Empty(ZZ3->ZZ3_DPYINV), ZZ3->ZZ3_DPYINV, ZZ4->ZZ4_DPYINV )
					ZZ4->ZZ4_PRODUP := iif(!Empty(ZZ3->ZZ3_IMEISW), ZZ3->ZZ3_MODSW , ZZ4->ZZ4_PRODUP)
					ZZ4->ZZ4_CTROCA := iif(!Empty(ZZ3->ZZ3_CTROCA), ZZ3->ZZ3_CTROCA, ZZ4->ZZ4_CTROCA )
					//	ZZ4->ZZ4_DEFINF := iif( Empty(ZZ4->ZZ4_DEFINF), iif(!Empty(ZZ3->ZZ3_DEFINF),ZZ3->ZZ3_DEFINF,Left(DEFINF,5)), ZZ4->ZZ4_DEFINF)
					//ZZ4->ZZ4_DEFINF := iif( !Empty(ZZ4->ZZ4_DEFINF), iif(!Empty(ZZ3->ZZ3_DEFINF),ZZ3->ZZ3_DEFINF,Left(DEFINF,5)), ZZ4->ZZ4_DEFINF)
					//ZZ4->ZZ4_DEFINF := iif( Empty(Left(DEFINF,5)), Iif (!Empty(AllTrim(ZZ3->ZZ3_DEFINF)), ZZ3->ZZ3_DEFINF,ZZ4->ZZ4_DEFINF), Left(DEFINF,5))
					ZZ4->ZZ4_DEFINF := iif( Empty(ZZ3->ZZ3_DEFINF), iif(!Empty(ZZ4->ZZ4_DEFINF),ZZ4->ZZ4_DEFINF,Left(DEFINF,5)), ZZ3->ZZ3_DEFINF)
					ZZ4->ZZ4_DEFDET := iif( Empty(ZZ4->ZZ4_DEFDET), ZZ3->ZZ3_DEFDET, ZZ4->ZZ4_DEFDET)
					ZZ4->ZZ4_COR    := iif( Empty(ZZ4->ZZ4_COR)   , ZZ3->ZZ3_COR   , ZZ4->ZZ4_COR   )
					ZZ4->ZZ4_ATPRI  := iif( Empty(ZZ4->ZZ4_ATPRI) , dtos(date())+time(), ZZ4->ZZ4_ATPRI)
					ZZ4->ZZ4_ATULT  := dtos(date())+time()
					
					If ! Empty(_cNumdoc) .AND. EMPTY(ZZ4->ZZ4_DOCSEP)
						ZZ4->ZZ4_DOCSEP := _cNumDoc
					Endif
					If _lImpetqm
						_nPosetq := aScan(_aEtiqMas, { |X| X[1] == alltrim(ZZ4->ZZ4_OS) })
						
						if _nPosetq > 0 .and. _aEtiqMas[_nPosetq,2] == ZZ4->ZZ4_IMEI
							_nqtdmas++
							
							cQryExec := " UPDATE " + RetSqlName("ZZ4") + _center
							cQryExec += " SET ZZ4_ETQMAS = '"+Transform(_cNumEtq, "@E 999999999999")+"' "
							cQryExec += " WHERE ZZ4_OS = '"+left(ZZ3->ZZ3_NUMOS,6)+"' "
							//MemoWrite("c:\axzz3.2.sql", cQryExec)
							TcSQlExec(cQryExec)
							TCRefresh(RETSQLNAME("ZZ4"))
							_lscreen  	:=.F.  // Forca Fechar a Tela e efetuar nova digitação
							U_GRVLOGFA("002")   
						endif
					Endif
					ZZ4->ZZ4_SEQZZ3 := _cDefSeq
					if !Empty(_aFasMax[1])
						ZZ4->ZZ4_FASMAX := _aFasMax[1]
						//ZZ4->ZZ4_DFAMAX := _aFasMax[2]
						ZZ4->ZZ4_GRMAX  := _aFasMax[3]
						ZZ4->ZZ4_SETMAX := _aFasMax[4]
					endif
					ZZ4->ZZ4_TRANSC := iif(!empty(ZZ3->ZZ3_TRANSC), ZZ3->ZZ3_TRANSC, ZZ4->ZZ4_TRANSC)
					ZZ4->ZZ4_GARMCL := iif(!empty(ZZ3->ZZ3_GARMCL), ZZ3->ZZ3_GARMCL, ZZ4->ZZ4_GARMCL)

					If !Empty(AllTrim(ZZ3->ZZ3_SOFOUT))
						ZZ4->ZZ4_SOFOUT := ZZ3->ZZ3_SOFOUT
					EndIf

					If !Empty(AllTrim(ZZ3->ZZ3_SOFIN))
						ZZ4->ZZ4_SOFIN  := ZZ3->ZZ3_SOFIN
					EndIf

					If ZZ3->ZZ3_OPEBGH <> ZZ4->ZZ4_OPEBGH //!Empty(AllTrim(ctransope))
						ZZ4->ZZ4_OPEANT := AllTrim(ZZ4->ZZ4_OPEBGH)
						ZZ4->ZZ4_OPEBGH := ZZ3->ZZ3_OPEBGH
						_aAreaSZA := SZA->(getarea())
						SZA->(dbsetorder(3)) //ZA_FILIAL+ZA_NFISCAL+ZA_SERIE+ZA_IMEI
						If SZA->(DbSeek(xFilial("SZA") + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI))
							Begin Transaction
							RecLock('SZA',.F.)
							SZA->ZA_OPERBGH := ZZ3->ZZ3_OPEBGH
							SZA->ZA_CODRECL := _cDefMc
							MsUnlock()
							End Transaction
						EndIf
						restarea(_aAreaSZA)
					endif
					
					msunlock()
					
					// Ticket 5227 - M.Munhoz - 10/04/12
					// Estas funcoes estavam em local errado, gravando dados no ZZ4 indevidamente, ou seja, antes da fase ser confirmada.
//					If Empty(AllTrim(cgarspc)) .And. (lUsrNext .Or. lUsrAdmi) //.Or. cTransc <> 'IXT' .And. (lUsrNext .Or. lUsrAdmi) - Alterado Paulo Francisco 07/03/12
					_cgarspc := posicione("SZA",1,xFilial("SZA")+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_IMEI,"ZA_SPC")
					// Deve gravar o Problema/Solucao mesmo com SPC informado cfe definido por Luiz/Fernando Luciano em 19/04/2012. M.Munhoz
					if (lUsrNext .Or. lUsrAdmi)
						PROREPA(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS,LAB)
					endif
					If empty(_cgarspc) .and. (lUsrNext .Or. lUsrAdmi)
						
						//PROREPA(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS,LAB)
						CONSGA09(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
						
					EndIf

					If !Empty(_cDefRec)
						U_GravDef(ZZ3->ZZ3_IMEI)
					EndIf
					
					//Impressao de Etiqueta de Entrada no encerramento da OS conforme parametrizado na operacao - Edson Rodrigues - 10/07/11
					//IF ZZ3->ZZ3_ENCOS == "S"
					//	Dbselectarea("ZZJ")
					//	If ZZJ->(dbseek(xFilial("ZZJ")+ ZZ4->ZZ4_OPEBGH+ZZ3->ZZ3_LAB))
					//		IF _letequip
					//			aAdd(_aImpEtiq, {ZZ3->ZZ3_IMEI, ZZ4->ZZ4_OS, AB7->AB7_ITEM, ZZ4->ZZ4_NFENR, ZZ4->ZZ4_NFESER,ZZ4->ZZ4_CODPRO,ZZ4->ZZ4_NFEDT,0, ZZ4->ZZ4_CODCLI, ZZ4->ZZ4_LOJA,ZZ4->ZZ4_XLOTE,,,,,,ZZ4->(recno()), ZZ4->ZZ4_ITEMD1}) // M.Munhoz - 16/08/2011
					//		ENDIF
					//	Endif
					//	DBSELECTAREA("ZZ4")
					//Endif

//******************************************************************************************************************************************************
					// M.Munhoz - TICKET 4818 - 16/04/2012 - As gravacoes de dados no ZZ4 abaixo foram trazidas da funcao ALTCABEC que gravava infos no ZZ4 indevidamente.
//					ctransope := Posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSE2,6) + LEFT(FAS2,2)+ SPACE(04),"ZZ1_ALTOPE")
					cTransOpe := Posicione("ZZ1",1,xFilial("ZZ1") + ZZ3->ZZ3_LAB + ZZ3->ZZ3_CODSE2 + LEFT(ZZ3->ZZ3_FASE2,2) + SPACE(04),"ZZ1_ALTOPE")
					_cGarMcla := Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH + ZZ3->ZZ3_LAB, "ZZJ_GARMCL")
					_cDefMc   := Posicione("ZZG",1,xFilial("ZZG") + ZZ3->ZZ3_LAB + ZZ3->ZZ3_DEFINF, "ZZG_RECCLI" )

					//Faz as novas validacoes para o processo novo Motorola-Relatorios MClaims // Edson Rodrigues - 12/05/09
					If !Empty(ZZ4->ZZ4_OPEBGH)
						dbselectarea("ZZJ")
						ZZJ->(dbsetOrder(1)) // ZZJ_FILIAL + ZZJ_OPEBGH+ ZZJ_LAB
						If ZZJ->(dbseek(xFilial("ZZJ")+ ZZ4->ZZ4_OPEBGH + ZZ3->ZZ3_LAB))
							cinftrans	:=ZZJ->ZZJ_INFTCM  // variavel que informa o Transcode - Processo Mclaims - Edson Rodrigues 22/03/10
							ctransfix	:=ZZJ->ZZJ_TRAFIX  // variavel que diz se Transcode e fixo,sim, nao ou condicional - Processo Mclaims - Edson Rodrigues 15/04/10
							ccodtrfix	:=ZZJ->ZZJ_CODTRF // variavel que obtem o Transcode quando ZZJ_TRAFIX=SIM - Processo Mclaims - Edson Rodrigues 15/04/10
							cfastnfix	:=ALLTRIM(ZZJ->ZZJ_FASTRC) 	// variavel que obtem a(s) fase(s) quando ZZJ_TRAFIX=NAO - Processo Mclaims - Edson Rodrigues 15/04/10
							csettnfix	:=ALLTRIM(ZZJ->ZZJ_SETTRC) 	// variavel que obtem o(s) setor(s) quando ZZJ_TRAFIX=NAO - Processo Mclaims - Edson Rodrigues 15/04/10
							cfasouinf	:=ALLTRIM(ZZJ->ZZJ_FASOUT) 	// variavel que obtem a(s) fase(s) que informa outros dados para o processo do Mclaims e que o ZZJ_TRAFIX=NAO - Edson Rodrigues 15/04/10
							_csetmast	:=ALLTRIM(ZZJ->ZZJ_SETMAS) // variavel que obtem setor(es) de impressao de etiqueta Master BGH
							_cfasmast	:=ALLTRIM(ZZJ->ZZJ_FASMAS) // variavel que obtem fases(es) de impressao de etiqueta Master BGH
							cfasalltn	:=cfastnfix+'/'+cfasouinf
							_cinfsix    :=ZZJ->ZZJ_INFSIX
						Else
							ApMsgInfo("Não foi encontrado a operacao cadastrada para OS "+ZZ4->ZZ4_OS+" e IMEI "+ZZ4->ZZ4_IMEI+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
							_lContinua := .F.
							return(_lRet)
						EndIf

						//copebgh := ZZ4->ZZ4_OPEBGH
						//cmodel  := Posicione("SB1",1,xFilial("SB1") + ZZ4->ZZ4_CODPRO, "B1_GRUPO")
						//cfinime := RIGHT(ALLTRIM(IMEI),3)
						If cinftrans == "S" // .And. _lContinua
							cgarant := IIf(!Empty(ZZ4->ZZ4_GARANT),ZZ4->ZZ4_GARANT,U_Vergaran(AllTrim(ZZ4->ZZ4_CARCAC),ALLTRIM(ZZ4->ZZ4_OPEBGH),ZZ4->ZZ4_IMEI))
							cgarspc := posicione("SZA",1,xFilial("SZA")+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_IMEI,"ZA_SPC")
							
							if Empty(ZZ4->ZZ4_GARANT) .And. !Empty(cgarant)
								RecLock("ZZ4",.F.)
								ZZ4->ZZ4_GARANT := cgarant
								MSUnlock()
							EndIf
						EndIf
/*
						If 	lUsrNext .And. ctransfix == 'C' .And. cgarant == 'S' .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrAdmi .And. ctransfix == 'C' .And. cgarant == 'S' .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrNext .And. ctransfix == 'C' .And. cgarant == 'N' .And. Empty(Alltrim(ZZ3->ZZ3_TRANSC)) .And. Empty(AllTrim(ctransope)) .Or. ;
							lUsrAdmi .And. ctransfix == 'C' .And. cgarant == 'N' .And. Empty(Alltrim(ZZ3->ZZ3_TRANSC)) .And. Empty(AllTrim(ctransope))
							
							cTransc := U_Atransc(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
							
							RecLock("ZZ4",.F.)
							ZZ4->ZZ4_TRANSC := cTransc
							ZZ4->ZZ4_GARMCL := cGarMCL
							MSUnlock()
							
						EndIf
*/
                    endif
/*
					If Empty(AllTrim(cTransOpe))
						If !Empty(AllTrim(cTransc))
							Begin Transaction
							RecLock('ZZ4',.F.)
							
							ZZ4->ZZ4_TRANSC := cTransc
							ZZ4->ZZ4_GARMCL := Iif( Len(AllTrim(cGarmcl)) > 0, cGarmcl, _cGarMcla)
							
							If !Empty(AllTrim(ZZ3->ZZ3_SOFOUT))
								ZZ4->ZZ4_SOFOUT := ZZ3->ZZ3_SOFOUT
							EndIf
							
							If !Empty(AllTrim(ZZ3->ZZ3_SOFIN))
								ZZ4->ZZ4_SOFIN  := ZZ3->ZZ3_SOFIN
							EndIf
							
							MsUnlock()
							End Transaction
						EndIf
					EndIf
*/
/*
					If !Empty(AllTrim(ctransope))
						If Select("TrPtn") > 0
							TrPtn->(dbCloseArea())
						Endif
						_cQryTrPtn := " SELECT ZZJ.ZZJ_CODTRF CODTRF, ZZJ.ZZJ_OPERA OPERA, ZZJ.ZZJ_BLOQ BLOQ  "
						_cQryTrPtn += " FROM " + RetSqlName("ZZJ") + " ZZJ(NOLOCK) "
						_cQryTrPtn += " WHERE ZZJ.D_E_L_E_T_ = '' "
						_cQryTrPtn += " AND ZZJ.ZZJ_OPERA = '" + ctransope +"' "
						_cQryTrPtn += " AND ZZJ.ZZJ_BLOQ = 'N' "
						_cQryTrPtn += " AND ZZJ.ZZJ_FILIAL = '"+xFilial("ZZJ")+"' "
						TCQUERY _cQryTrPtn ALIAS "TrPtn" NEW
						
						If Len(AllTrim(TrPtn->CODTRF)) > 0
							
							Begin Transaction
							RecLock('ZZ4',.F.)
							
							ZZ4->ZZ4_OPEANT := AllTrim(ZZ4->ZZ4_OPEBGH)
							ZZ4->ZZ4_OPEBGH := TrPtn->OPERA
							ZZ4->ZZ4_TRANSC := AllTrim(TrPtn->CODTRF)
							
							If !Empty(AllTrim(ZZ3->ZZ3_SOFOUT))
								ZZ4->ZZ4_SOFOUT := ZZ3->ZZ3_SOFOUT
							EndIf
							
							If !Empty(AllTrim(ZZ3->ZZ3_SOFIN))
								ZZ4->ZZ4_SOFIN  := ZZ3->ZZ3_SOFIN
							EndIf

							MsUnlock()
							End Transaction

							SZA->(dbsetorder(3)) //ZA_FILIAL+ZA_NFISCAL+ZA_SERIE+ZA_IMEI
							If SZA->(DbSeek(xFilial("SZA") + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI))
								Begin Transaction
								RecLock('SZA',.F.)
								SZA->ZA_OPERBGH := TrPtn->OPERA
								SZA->ZA_CODRECL := _cDefMc
								MsUnlock()
								End Transaction
							EndIf
						EndIf
						
						If Select("TrPtn") > 0
							TrPtn->(dbCloseArea())
						Endif
						
					EndIf
*/
					// Ticket 4818 - M.Munhoz - 16/04/2012 - Tratamentos para Transactions IOW com SPC
					// Sempre que o IMEI possuir um SPC o transaction deve ser alterado de IOW para outro conforme a operacao
/*
					_cSPC := Posicione("SZA",3,xFilial("SZA")+ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI,"ZA_SPC")
					if !empty(_cSPC) .and. alltrim(ZZ4->ZZ4_TRANSC) == "IOW"
						begin transaction 
						reclock("ZZ4",.f.)
						if ZZ4->ZZ4_OPEBGH == "N02"
							ZZ4->ZZ4_TRANSC := "ITS"
						elseif ZZ4->ZZ4_OPEBGH == "N04"
							ZZ4->ZZ4_TRANSC := "IER"
						elseif ZZ4->ZZ4_OPEBGH == "N10"
							ZZ4->ZZ4_TRANSC := "IRR"
						elseif ZZ4->ZZ4_OPEBGH == "N11"
							ZZ4->ZZ4_TRANSC := "IBS"
						endif
						msunlock()
						end transaction
					endif
*/
//******************************************************************************************************************************************************
					
				Else
					// Incluso para voltar o status para zero quando houver falha na operação SR - Edson Rodrigues 17/03/10
					// M.Munhoz - TICKET 4818 - 16/04/2012 - nenhuma informacao pode ser gravada no ZZ4 nesta parte do programa porque o atendimento nao foi efetivado
					DBSELECTAREA("ZZ3")
					RecLock("ZZ3",.F.)
					ZZ3->ZZ3_STATUS := cValToChar(0)
					ZZ3->ZZ3_STATRA :='0'
					ZZ3->ZZ3_HORA   := Time()
					ZZ3->ZZ3_DATA   := date()   //Acrescentado Edson Rodrigues - 11/08/10
					MSUnlock()
					
					// Altera status dos part numbers apontados
					_aRegSZ9 := {}
					If LEN(_aRecnoZZ3[_ni,2]) > 0
						_aRegSZ9 := _aRecnoZZ3[_ni,2]
					EndIf
					
					DBSELECTAREA("SZ9")
					For _nH := 1 To Len(_aRegSZ9)
						SZ9->(dbGoTo(_aRegSZ9[_nH]))
						RecLock("SZ9",.F.)
						SZ9->Z9_STATUS := cValToChar(0)
						MsUnlock()
					Next _nH
					
					// Altera status das Pecas Faltante
					_aRegZZ7 := {}
					If LEN(_aRecnoZZ3[_ni,4]) > 0
						_aRegZZ7 := _aRecnoZZ3[_ni,4]
					EndIf
					
					DBSELECTAREA("ZZ7")
					For _nH := 1 To Len(_aRegZZ7)
						If ZZ7->(dbGoTo(_aRegZZ7[_nH]))
							RecLock("ZZ7",.F.)
							ZZ7->ZZ7_STATUS := cValToChar(0)
							MsUnlock()
						Endif
					Next _nH
					
					DBSELECTAREA("ZZ3")
					//If ZZ3->ZZ3_ENCOS == "S" .And. _nStatus == 1 alterado Edson Rodrigues - 21/05/10
					If ZZ3->ZZ3_ENCOS == "S" .And. ZZ3->ZZ3_ESTORN <> "S" .And. _nStatus==1
						RecLock("ZZ4",.F.)
						ZZ4->ZZ4_STATUS := "4"
						MsUnlock()
						
						reclock("AB6",.F.)
						AB6->AB6_STATUS := 'A'
						msunlock()
						
						reclock("AB7",.F.)
						AB7->AB7_TIPO   := '1'
						msunlock()
						
						reclock("AB9",.F.)
						dbDelete()
						msunlock()
						U_GRVLOGFA("003")
						
					Endif
				Endif
			Else
				IF _lImpetqm
					DBSELECTAREA("ZZ3")
					ZZ3->(dbGoTo(_aRecnoZZ3[_nI,1]))
					
					DBSELECTAREA("ZZ4")
					ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_NUMOS
					ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) ))
					
					cTitemail:= " Nao Encerrado Etiqueta Master - IMEI e ou OS não encontrado no ZZ4 -  acolszz3 "+strzero(_nI,3)+". "
					cMensagem := "Equipamento Encerrado : "+DTOC(date())+" - "+time()+" hrs."+  _center
					cMensagem += "Recnozz3 : " + STRZERO(_aRecnoZZ3[_nI,1],8)+"."+  _center
					cMensagem += "Setor do apontamento : " + AllTrim(left(CODSET,6))+  _center
					cMensagem += "Setor Etq Master : " + AllTrim(_csetmast)+  _center
					cMensagem += "Qde Encerrado apresentada ao usuário : "+STRZERO(_nencerr,3)+  _center
					cMensagem += "Equipamento Sendo Apontado : "+ALLTRIM(ZZ3->ZZ3_IMEI)+  _center
					cMensagem += "Os.:   " + AllTrim(left(ZZ3->ZZ3_NUMOS,6)) +  _center
					cMensagem += "IMEI no Acols : "+aCols[_nI,_nPosIMEI]+  _center
					cMensagem += "Os no acols:   " + LEFT(aCols[_nI, _nPosOS],6) +  _center
					cMensagem += "Usuario Apontando " + AllTrim(cUsername)  +  _center
					U_ENVIAEMAIL(cTitemail,"edson.rodrigues@bgh.com.br;paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
				ENDIF
				//Retirado linhas de códigos e incluso funcao Edson Rodrigues - 27/07/10
				U_EXCLAPON(@_nI,_nPosIMEI,_nPosOS)
				
			EndIf
		Else
			IF _lImpetqm
				DBSELECTAREA("ZZ3")
				ZZ3->(dbGoTo(_aRecnoZZ3[_nI,1]))
				
				DBSELECTAREA("ZZ4")
				ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_NUMOS
				ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) ))
				
				cTitemail:= " Nao Encerrado Etiqueta Master - IMEI e ou OS diferente da posicao acolszz3 "+strzero(_nI,3)+". "
				cMensagem := "Equipamento Encerrado : "+DTOC(date())+" - "+time()+" hrs."+  _center
				cMensagem += "Recnozz3 : " + STRZERO(_aRecnoZZ3[_nI,1],8)+"."+  _center
				cMensagem += "Setor do apontamento : " + AllTrim(left(CODSET,6))+  _center
				cMensagem += "Setor Etq Master : " + AllTrim(_csetmast)+  _center
				cMensagem += "Qde Encerrado apresentada ao usuário : "+STRZERO(_nencerr,3)+  _center
				cMensagem += "Equipamento Sendo Apontado : "+ALLTRIM(ZZ3->ZZ3_IMEI)+  _center
				cMensagem += "Os.:   " + AllTrim(left(ZZ3->ZZ3_NUMOS,6)) +  _center
				cMensagem += "IMEI no Acols : "+aCols[_nI,_nPosIMEI]+  _center
				cMensagem += "Os no acols:   " + LEFT(aCols[_nI, _nPosOS],6) +  _center
				cMensagem += "Usuario Apontando " + AllTrim(cUsername)  +  _center
				U_ENVIAEMAIL(cTitemail,"edson.rodrigues@bgh.com.br;paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
				
			ENDIF
			
			//Retirado linhas de códigos e incluso funcao Edson Rodrigues - 27/07/10
			U_EXCLAPON(@_nI,_nPosIMEI,_nPosOS)
		EndIf
	Else
		IF _lImpetqm
			DBSELECTAREA("ZZ3")
			ZZ3->(dbGoTo(_aRecnoZZ3[_nI,1]))
			
			DBSELECTAREA("ZZ4")
			ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_NUMOS
			ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) ))
			
			cTitemail:= " Nao Encerrado Etiqueta Master - acolszz3 posicao "+strzero(_nI,3)+" deteletado "
			cMensagem := "Equipamento Encerrado : "+DTOC(date())+" - "+time()+" hrs."+  _center
			cMensagem += "Recnozz3 : " + STRZERO(_aRecnoZZ3[_nI,1],8)+"."+  _center
			cMensagem += "Setor do apontamento : " + AllTrim(left(CODSET,6))+  _center
			cMensagem += "Setor Etq Master : " + AllTrim(_csetmast)+  _center
			cMensagem += "Qde Encerrado apresentada ao usuário : "+STRZERO(_nencerr,3)+  _center
			cMensagem += "Equipamento Sendo Apontado : "+ALLTRIM(ZZ3->ZZ3_IMEI)+  _center
			cMensagem += "Os.:   " + AllTrim(left(ZZ3->ZZ3_NUMOS,6)) +  _center
			cMensagem += "Usuario Apontando " + AllTrim(cUsername)  +  _center
			U_ENVIAEMAIL(cTitemail,"edson.rodrigues@bgh.com.br;paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
			
			
		ENDIF
		//Retirado linhas de códigos e incluso funcao Edson Rodrigues - 28/07/10
		U_EXCLAPON(@_nI,_nPosIMEI,_nPosOS)
	EndIf
	End Transaction
Next

If len(_aNotEmp) > 0
	apMsgStop("Ocorreram erros no Apontamento, Encerramento da OP ou Transferencia do Armazem Processo o p/ Acabado.  Imprima e verifique. O encerramento referente a essas OS com erros serao excluidos.")
	U_tecrx036(_aNotEmp,_lContinua)
	_aNotEmp:={}
Endif

//Mensagem de quantos aparelhos foram ecerrados - Edson Rodrigues - 16/09/10
If _lencerr .And. _nencer2 > 0
	apMsgStop("Foram encerrados "+strzero(_nencer2,3)+" aparelhos no total")
Endif

// Se matriz nao estiver vazia, executa funcao de impressao de etiquetas - Edson rodrigues 10/07/11
if len(_aImpEtiq) > 0 .and. ApMsgYesNo("Impressao de Etiqueta para equipamentos no encerramento, conforme parametrizado na fase. Confirma impressão?","Impressão de Etiquetas")
	U_EtqMass(_aImpEtiq)
endif

If Len(_aModBlq) > 0
	_aModBlq := {}
EndIf

If Len(_agarBlq) > 0
	_agarBlq := {}
EndIf


If Len(aDados) > 0
	u_TransPeca(aDados)
EndIf

If _lImpetqm .and. _nqtdmas==len(_aEtiqMas)
	U_EtqGera1(_cNumEtq,'2',_cmodetq)
	
Elseif _lImpetqm .and. !_nqtdmas==len(_aEtiqMas)
	IF ApMsgYesNo("O Sistema encerrou : "+strzero(_nqtdmas,3)+" itens para etiqueta master : "+Transform(_cNumEtq, "@E 999999999999")+" ,enquanto o correto seria "+strzero(len(_aEtiqMas),3)+". Deseja prosseguir com a impressão da etiqueta mesmo assim ?","Impressão de Etiquetas")
		U_EtqGera1(_cNumEtq,'2',_cmodetq)
	Else
		apMsgStop("Entre em contato com o TI e informe o problema ocorrido.")
	Endif
EndIf

// Limpa variavel de memoria do documento de separação
_cNumDoc := Space(9)
restarea(_aAreaZZ4)
restarea(_aAreaZZ3)
restarea(_aAreaSZ9)
restarea(_aAreaZZ7)
restarea(_aAreaAB1)
restarea(_aAreaAB6)
restarea(_aAreaAB7)
restarea(_aAreaZZ1)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CALCSEQ  ºAutor  ³M.Munhoz - ERP Plus º Data ³  06/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para identificar a proxima sequencia a ser utilizadaº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function CalcSeq(_cIMEI, _cNumOS)

Local _cCalcSeq := "01"
Local _cQuery   := ""

_cQuery += " SELECT MAX(SEQ) NRSEQ "
_cQuery += " FROM  ("
_cQuery += " SELECT ZZ3_SEQ 'SEQ', ZZ3_IMEI, ZZ3_NUMOS FROM "+RetSqlName("ZZ3")+" (nolock) WHERE D_E_L_E_T_ = '' AND ZZ3_FILIAL = '"+xFilial("ZZ3")+"' AND ZZ3_IMEI = '"+_cIMEI+"' AND LEFT(ZZ3_NUMOS,6) = '"+left(_cNumOS,6)+"' "
_cQuery += " UNION  ALL"
_cQuery += " SELECT AB9_SEQ 'SEQ', AB9_SN, AB9_NUMOS FROM "+RetSqlName("AB9")+" (nolock) WHERE D_E_L_E_T_ = '' AND AB9_FILIAL = '"+xFilial("AB9")+"' AND AB9_SN = '"+_cIMEI+"' AND LEFT(AB9_NUMOS,6) = '"+left(_cNumOS,6)+"' "
_cQuery += " ) AS SEQ "
if Select("SEQ") > 0
	SEQ->(dbCloseArea())
endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"SEQ",.T.,.T.)
SEQ->(dbGoTop())
if SEQ->(!eof()) .And. !Empty(SEQ->NRSEQ)
	_cCalcSeq := soma1(SEQ->NRSEQ)
endif

return(_cCalcSeq)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF190Vis  ºAutor  ³Marcos S. Lobo      º Data ³  13/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualização da Amarração Responsáveis x Bens (SND)         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - SIGAATF                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EstZZ3(cAlias,nReg,nOpc)

Local _aAreaZZ4     := ZZ4->(GetArea())
Local _aAreaZZ3     := ZZ3->(GetArea())
Local _aAreaSZ9     := SZ9->(GetArea())
Local _aAreaZZ7     := ZZ7->(GetArea())
Local _lRet         := .T.
Local _cIMEI        := ZZ3->ZZ3_IMEI
Local _cNumOS       := ZZ3->ZZ3_NUMOS
Local _cCodTec      := ZZ3->ZZ3_CODTEC
Local _cLab         := ZZ3->ZZ3_LAB
Local _cSetor       := ZZ3->ZZ3_CODSET
Local _cSetor2      := ZZ3->ZZ3_CODSE2
Local _cCodFase1    := ZZ3->ZZ3_FASE1
Local _cCodFase2    := ZZ3->ZZ3_FASE2
Local _cSeq         := ZZ3->ZZ3_SEQ
Local _encos        := ZZ3->ZZ3_ENCOS
Local _ctransope
Local _cPxrec
Local _cQry

dbselectarea("ZZ4")
ZZ4->(dbSetOrder(1))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
//Modificado Paulo Francisco devido a apontamento de peças via coletores - 14/02/2012
/*dbselectarea("SZ9")
SZ9->(dbSetOrder(1))  //Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM*/
dbselectarea("SZ9")
SZ9->(dbSetOrder(4))  // Z9_FILIAL+Z9_NUMOS+Z9_SEQ+Z9_PARTNR
dbselectarea("ZZ7")
ZZ7->(dbSetOrder(3))  //ZZ7_FILIAL, ZZ7_IMEI, ZZ7_NUMOS, ZZ7_SE
dbselectarea("ZZ3")
ZZ3->(dbSetOrder(1))  // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ

If Empty(cAlias)
	cAlias := Alias()
Endif

If Empty(nReg)
	nReg := (cAlias)->(Recno())
Endif

_ctransope := Posicione("ZZ1",1,xFilial("ZZ1") + _cLab + _cSetor2 + _cCodFase2,"ZZ1_ALTOPE")

if ZZ3->ZZ3_ESTORN == "S"
	apMsgStop("Esta fase é um estorno e portanto não poderá ser estornada novamente. ","Fase não estornada")
	_lRet := .F.
endif

//Acrescentado Edson Rodrigues     22/02/10
if ZZ3->ZZ3_STATUS == "0"
	apMsgStop("Esta fase é temporária e portanto não necessita de ser estornada. ","Fase não estornada")
	_lRet := .F.
endif

// Verifica se o IMEI selecionado ainda esta em atendimento
if _lRet .And. ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + LEFT(ZZ3->ZZ3_NUMOS,6)))
	_nRegZZ4 := ZZ4->(recno())
	if ZZ4->ZZ4_STATUS <> "4"  // Status 4 = em atendimento
		apMsgStop("Esta fase não poderá ser estornada porque o IMEI não está em atendimento.","Fase não estornada")
		_lRet := .F.
	endif           
	
	/* 
	if _lRet .And. ZZ4->ZZ4_ETQMAS <> 0 .AND. ZZ4->ZZ4_ETQMAS > 1  
	   	apMsgStop("Este aparelho não poderá ser estornado porque o IMEI está vinculado há uma etiqueta master : "+ TransForm(ZZ4->ZZ4_ETQMAS, "@E 999999999999") +" E necessario excluir toda Master. Contate seu Lider ou Supervisor.","Fase não estornada")
	   _lRet := .F.	  
	endif 
	*/
endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

_cQry	:=	"SELECT TOP 1 R_E_C_N_O_ AS RECNOZ3 FROM " + RetSqlName("ZZ3") +"  WHERE D_E_L_E_T_ = '' AND ZZ3_ESTORN <> 'S' AND ZZ3_IMEI = '"+ZZ3->ZZ3_IMEI+"' AND ZZ3_NUMOS = '"+LEFT(ZZ3->ZZ3_NUMOS,6)+"' "

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

_cPxrec := QRY->RECNOZ3

QRY->(dbCloseArea())

// Verifica se a fase a ser estonada eh a ultima fase apontada
if _lRet .And. ZZ3->(dbSeek(xFilial("ZZ3") + _cIMEI + _cNumOS + _cSeq))
	
	while ZZ3->(!eof()) .And. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .And. _cIMEI == ZZ3->ZZ3_IMEI .And. _cNumOS == ZZ3->ZZ3_NUMOS
		if ZZ3->ZZ3_SEQ > _cSeq .And. ZZ3->ZZ3_ESTORN <> "S"
			_lRet := .F.
		endif
		ZZ3->(dbSkip())
	enddo
	if !_lRet
		apMsgStop("Esta fase não poderá ser estornada porque ela não é a última fase. Dirija-se à última fase para efetuar o estorno.","Fase não estornada")
	endif
	
endif

//Modificado Paulo Francisco devido a apontamento de peças via coletores - 14/02/2012
If SZ9->(dbSeek(xFilial("SZ9") + _cNumOS + _cSeq)) //Z9_FILIAL+Z9_NUMOS+Z9_SEQ+Z9_PARTNR
	While SZ9->(!EOF()).And. SZ9->Z9_FILIAL == xFilial("SZ9") .And. SZ9->Z9_IMEI == _cIMEI .And. SZ9->Z9_NUMOS == _cNumOS .And. SZ9->Z9_SEQ == _cSeq
		
		If SZ9->Z9_COLETOR == "S"
			
			_lRet	:=	.F.
			
		EndIf
		
		SZ9->(dbSkip())
		
	EndDo
	
	If !_lRet
		
		apMsgStop("Peças Apontadas pelo Coletor Favor Remover as Peças.","Fase não estornada")
		
	EndIf
	
Endif

restarea(_aAreaZZ3)
restarea(_aAreaZZ4)

if _lRet .And. AxVisual(cAlias,nReg,nOpc) == 1
	
	If _cPxrec == nReg
		
		// Atualiza a fase atual do aparelho no ZZ4 para a fase anterior
		ZZ4->(dbGoTo(_nRegZZ4))
		reclock("ZZ4",.F.)
		ZZ4->ZZ4_FASATU := ""//_cCodFase1
		ZZ4->ZZ4_SETATU := ""//_cSetor
		ZZ4->ZZ4_STATUS := "3"
		
	Else
		
		// Atualiza a fase atual do aparelho no ZZ4 para a fase anterior
		ZZ4->(dbGoTo(_nRegZZ4))
		reclock("ZZ4",.F.)
		ZZ4->ZZ4_FASATU := _cCodFase1
		ZZ4->ZZ4_SETATU := _cSetor
		
	EndIf
	
	If !Empty(AllTrim(_ctransope)) .and. !empty(ZZ4->ZZ4_OPEANT)
		ZZ4->ZZ4_OPEBGH := ZZ4->ZZ4_OPEANT
		ZZ4->ZZ4_OPEANT := ""
		
	EndIf
	ZZ4->ZZ4_TRANSC := ""
	
	msunlock()
	
	// Cria um novo apontamento de fase de estorno da fase apontamentada anteriormente
	reclock("ZZ3",.T.)
	ZZ3->ZZ3_FILIAL := xFilial("ZZ3")
	ZZ3->ZZ3_CODTEC := _cCodTec
	ZZ3->ZZ3_LAB    := _cLab
	ZZ3->ZZ3_DATA   := date()
	ZZ3->ZZ3_HORA   := Time()
	ZZ3->ZZ3_CODSET := _cSetor2
	ZZ3->ZZ3_FASE1  := _cCodFase2
	ZZ3->ZZ3_CODSE2 := _cSetor
	ZZ3->ZZ3_FASE2  := _cCodFase1
	ZZ3->ZZ3_ENCOS  := "N"
	ZZ3->ZZ3_IMEI   := _cIMEI
	ZZ3->ZZ3_SWAP   := ""
	ZZ3->ZZ3_IMEISW := ""
	ZZ3->ZZ3_MODSW  := ""
	ZZ3->ZZ3_UPGRAD := ""
	ZZ3->ZZ3_NUMOS  := _cNumOS
	ZZ3->ZZ3_STATUS := "1"
	ZZ3->ZZ3_SEQ    := SOMA1(_cSeq)
	ZZ3->ZZ3_USER   := cUserName
	ZZ3->ZZ3_ACAO   := ""
	ZZ3->ZZ3_LAUDO  := ""
	ZZ3->ZZ3_COR    := ZZ4->ZZ4_COR
	ZZ3->ZZ3_ESTORN := "S"
	ZZ3->ZZ3_STATRA := "0"
	ZZ3->ZZ3_ASCRAP :=getadvfval("ZZ1","ZZ1_SCRAP",xFilial("ZZ1") + _cLab + AllTrim(_cSetor2) + _cCodFase2, 1, "N")  // incluso Edson Rodrigues 24/09/10
	msunlock()
	
	// Grava a fase original como estornada
	ZZ3->(dbGoTo(nReg))
	reclock("ZZ3",.F.)
	ZZ3->ZZ3_ESTORN := "S"
	ZZ3->ZZ3_STATRA := "0"
	msunlock()
	
	//Retirado linhas de códigos e incluso funcao Edson Rodrigues - 28/07/10
	U_EXCLAPO2(nReg)
	
endif

restarea(_aAreaSZ9)
restarea(_aAreaZZ7)
restarea(_aAreaZZ4)

Return (_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FASMAX   ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  05/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar se a fase apontada possui grau maior º±±
±±º          ³ ou menor do que as fases anterioes                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function FasMax(_cLocal, _cGrauMax, _cFasMax,_csetmax )

Local _aFase := {,,,}

//retirado esse If pois Fernando Luciano solicitou que fosse feito da mesma forma que a Sony Ericson - Edson Rodrigues - 19/05/10
//if ZZ3->ZZ3_LAB == '2'     // NEXTEL
//	ZZ1->(dbSetOrder(2))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_FASE1 + ZZ1_CODSET
//	_cChave := xFilial("ZZ1") + ZZ3->ZZ3_LAB + _cFasMax
//else                       // SONY
ZZ1->(dbSetOrder(1))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
_cChave := xFilial("ZZ1") + ZZ3->ZZ3_LAB + _csetmax + _cFasMax
//endif

if ZZ1->(dbSeek(_cChave)) .And. ZZ1->ZZ1_GRAU >= _cGrauMax
	_aFase[1] := ZZ1->ZZ1_FASE1
	_aFase[2] := ZZ1->ZZ1_DESFA1
	_aFase[3] := ZZ1->ZZ1_GRAU
	_aFase[4] := ZZ1->ZZ1_CODSET
EndIf

return(_aFase)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXZZ3     ºAutor  ³Microsiga           º Data ³  09/26/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function VerFasAtu(_cIMEI, _cNumOS)
Local _aAreaZZ3 := ZZ3->(GetArea())
Local _cFasset  := ""
Local cselQry   := ""

//Alterado Edson Rodrigues em 01/04/09

If Select("QryZZ3") > 0
	QryZZ3->(dbCloseArea())
Endif

cselQry:="SELECT ZZ3_FASE2,ZZ3_CODSE2 FROM ZZ3020 (NOLOCK) INNER JOIN "
cselQry+="(SELECT MAX(R_E_C_N_O_) AS RECNO FROM ZZ3020 (NOLOCK) WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND  ZZ3_IMEI='"+_cIMEI+"' AND LEFT(ZZ3_NUMOS,6)='"+left(_cNumOS,6)+"' AND D_E_L_E_T_='' AND ZZ3_STATUS='1' AND ZZ3_ESTORN = '') AS ZZ31 ON RECNO=R_E_C_N_O_ "

TCQUERY cselQry ALIAS "QryZZ3" NEW
TCRefresh("ZZ3020")

If Select("QryZZ3") > 0
	QryZZ3->(dbGoTop())
	If QryZZ3->(!eof())
		_cFasset:=QryZZ3->ZZ3_FASE2+QryZZ3->ZZ3_CODSE2
	Endif
	QryZZ3->(dbCloseArea())
Endif

restarea(_aAreaZZ3)

return(_cFasset)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³verfancf  ºAutor  ³Edson Rodrigues     º Data ³  24/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se existe apontamentos da fase atual nao           º±±
±±º          |nao confirmados por outros tecnicos                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function verfancf(_cIMEI, _cNumOS)
Local _aAreaZZ3 := ZZ3->(GetArea())
Local _cFasetec  := ""
Local cselQry   := ""

If Select("QryZZ3") > 0
	QryZZ3->(dbCloseArea())
Endif

cselQry:="SELECT ZZ3_CODTEC,ZZ3_FASE2,ZZ3_CODSE2 FROM ZZ3020 (NOLOCK) INNER JOIN "
cselQry+="(SELECT MAX(R_E_C_N_O_) AS RECNO FROM ZZ3020 (NOLOCK) WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND  ZZ3_IMEI='"+_cIMEI+"' AND LEFT(ZZ3_NUMOS,6)='"+left(_cNumOS,6)+"' AND D_E_L_E_T_='' AND ZZ3_STATUS='0') AS ZZ31 ON RECNO=R_E_C_N_O_ "

TCQUERY cselQry ALIAS "QryZZ3" NEW
TCRefresh("ZZ3020")

If Select("QryZZ3") > 0
	QryZZ3->(dbGoTop())
	If QryZZ3->(!eof())
		_cFasetec:=QryZZ3->ZZ3_FASE2+QryZZ3->ZZ3_CODSE2+QryZZ3->ZZ3_CODTEC
	EndIf
	QryZZ3->(dbCloseArea())
Endif

restarea(_aAreaZZ3)

return(_cFasetec)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerEncer  ºAutor  ³Edson Rodrigues     º Data ³  26/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ver se o ultimo apontamento esta encerrado e nao estornado  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function VerEncer(_cIMEI, _cNumOS)
Local _aAreaZZ3 := ZZ3->(GetArea())
Local _cencos   := ""
Local cselQry   := ""

If Select("QryZZ3") > 0
	QryZZ3->(dbCloseArea())
Endif

cselQry:="SELECT ZZ3_ENCOS FROM ZZ3020 (NOLOCK) INNER JOIN "
cselQry+="(SELECT MAX(R_E_C_N_O_) AS RECNO FROM ZZ3020 (NOLOCK) WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND  ZZ3_IMEI='"+_cIMEI+"' AND LEFT(ZZ3_NUMOS,6)='"+left(_cNumOS,6)+"' AND D_E_L_E_T_='' AND ZZ3_STATUS='1' AND ZZ3_ESTORN<>'S') AS ZZ31 ON RECNO=R_E_C_N_O_ "

TCQUERY cselQry ALIAS "QryZZ3" NEW
TCRefresh("ZZ3020")

If Select("QryZZ3") > 0
	QryZZ3->(dbGoTop())
	If QryZZ3->(!eof())
		_cencos:=QryZZ3->ZZ3_ENCOS
	endif
	QryZZ3->(dbCloseArea())
Endif

restarea(_aAreaZZ3)

Return(_cencos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Atransc   ºAutor  ³Paulo Francisco     º Data ³  17/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Altera o Transaction conforme solicitacao Motorola          º±±
±±º          |                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function Atransc(_cIMEI,_cNumOS)

Local cselQry1	:= ""
Local ExecQry
Local _cDef

Private _lspc433    := .T.
Private _cSpr		:= GetMv("MV_SPC0433") 				 // Aparelhos Parametrizados para Especifico SPC0000433 - Motorola
Private _cPsq		:= GetMv("MV_PERSPC3") 				 // Periodo Parametrizados para Especifico SPC0000433 - Motorola
Private _cSps		:= GetMv("MV_DTFSPC1") 				 // Data Final Parametrizados para Especifico SPC0000433 - Motorola
Private _cSpf		:= GetMv("MV_PRFOUND")				 // Problem Found para SPC0000433 - Motorola
Private _cnotdefc   := GetMv("MV_NOTDEFC")

IF date() >= ctod('03/01/12')
	_cPsq     := GetMv("MV_PERTIXT")  //Periodo parametricado para aparelhos que constam no MV_SPC0433 e que ultilizam o transaction code especial IXT. Edson Rodrigues 29/12/12.
	_cSpx	 := GetMv("MV_DTFTIXT")
	_lspc433  := .F.
ENDIF



If Select("QryZZ4") > 0
	QryZZ4->(dbCloseArea())
Endif

cselQry1	:=" SELECT ZZ4_DEFINF DEFINF, ZG.ZZG_RECCLI RECCLI, ZZ4_TRANSC TRANSC, ISNULL(SZA.ZA_SPC,'')	SPC, ZZ4.ZZ4_GARANT	GARANT, ZZ4_OPEBGH OPERAC, ZZ4_CODPRO COD, ISNULL(SZA.ZA_DEFRECL,'')  DEFEITO, ZZ4.ZZ4_PROBLE PFOUND, "
cselQry1	+="	(SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	  "
cselQry1	+="	(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' GARACARC, "
cselQry1	+="		DATEDIFF(MONTH, (SELECT RTRIM(X5_DESCRI) FROM " + RetSqlName("SX5") + " WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	  "
cselQry1	+="				(SELECT LEFT(X5_DESCRI,2) FROM " + RetSqlName("SX5") + " WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' ,ZZ4.ZZ4_NFEDT) MES_GARA  "
cselQry1	+=" FROM " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) "
cselQry1	+=" LEFT JOIN " + RetSqlName("ZZG") + " ZG (NOLOCK) "
cselQry1	+=" ON(ZZ4.ZZ4_DEFINF = ZZG_CODIGO AND ZZ4.D_E_L_E_T_ = ZG.D_E_L_E_T_ AND ZG.ZZG_LAB = '" +LAB+ "') "
cselQry1	+=" LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock)   	"
cselQry1	+=" ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI    "
cselQry1	+=" AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_)   "
cselQry1	+=" WHERE ZZ4.D_E_L_E_T_ = ''  "
cselQry1	+=" AND ZZ4.ZZ4_OS = '"+left(_cNumOS,6)+"' "
cselQry1	+=" AND ZZ4.ZZ4_IMEI = '"+_cIMEI+"' "
cselQry1	+=" AND ZZ4.ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "

//MemoWrite("c:\AXZZ1.sql", cselQry1)

TCQUERY cselQry1 ALIAS "QryZZ4" NEW

TCRefresh("ZZ4020")

Do Case
	
	Case (AllTrim(QryZZ4->OPERAC) $ "N01#N08#N09#N10#N11") .And. Empty(Alltrim(QryZZ4->SPC)) .And. AllTrim(QryZZ4->GARANT) == 'N'
		
		If Alltrim(QryZZ4->GARANT) == 'N' .And. AllTrim(QryZZ4->COD) $ _cSpr .And. Transform (QryZZ4->MES_GARA, "@E 99") $ _cPsq
			//IF  (!AllTrim(QryZZ4->DEFEITO) $ _cnotdefc  .or. !AllTrim(QryZZ4->RECCLI) $ _cnotdefc) Alterado Paulo Francisco 07/03/12
			If !Empty(QryZZ4->DEFINF) .And. !Empty(AllTrim(QryZZ4->RECCLI)) .And. AllTrim(QryZZ4->RECCLI) <> 'C0022'
				lRetIR	:= "IXT"
			Else
				lRetIR	:= "IOW"
			Endif
		Else
			lRetIR	:= "IOW"
		Endif
		
	Case (AllTrim(QryZZ4->OPERAC) $ "N01") .And. AllTrim(QryZZ4->GARANT) == 'S' .And. Empty(Alltrim(QryZZ4->SPC))
		
		If (AllTrim(QryZZ4->TRANSC) $ "IRF") .Or. Empty(AllTrim(QryZZ4->TRANSC))
			
			If !Empty(QryZZ4->DEFINF) .And. !Empty(AllTrim(QryZZ4->RECCLI)) .And. AllTrim(QryZZ4->RECCLI) <> 'C0022'
				
				lRetIR 	:= "IRR"
				
			Else
				
				lRetIR 	:= "IRF"
				
			EndIf
			
		EndIf
		
	Case (AllTrim(QryZZ4->OPERAC) $ "N08#N09") .And. AllTrim(QryZZ4->GARANT) == 'S'
		
		lRetIR := Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(QryZZ4->OPERAC) + LAB,"ZZJ_CODTRF")
		
		
	Case (AllTrim(QryZZ4->OPERAC) $ "N01#N10") .And. AllTrim(QryZZ4->GARANT) == 'S' .And. Empty(Alltrim(QryZZ4->SPC))
		
		If (AllTrim(QryZZ4->TRANSC) $ "IRF#IOW") .Or. Empty(AllTrim(QryZZ4->TRANSC))
			
			If !Empty(QryZZ4->DEFINF) .And. !Empty(AllTrim(QryZZ4->RECCLI)) .And. AllTrim(QryZZ4->RECCLI) <> 'C0022'
				
				lRetIR 	:= "IRR"
				
			Else
				
				lRetIR := "IRF"
				
			EndIf
			
		EndIf
		
	Case (AllTrim(QryZZ4->OPERAC) $ "N11") .And. Empty(Alltrim(QryZZ4->SPC))
		
		If (AllTrim(QryZZ4->TRANSC) $ "IRF#IBS") .Or. Empty(AllTrim(QryZZ4->TRANSC))
			
			If !Empty(QryZZ4->DEFINF) .And. !Empty(AllTrim(QryZZ4->RECCLI)) .And. AllTrim(QryZZ4->RECCLI) <> 'C0022'
				
				lRetIR	:= "IBS"
				
			Else
				
				lRetIR	:= "IRF"
				
			EndIf
			
		EndIf
		
	Case (AllTrim(QryZZ4->OPERAC) $ "N01#N10") .And. !Empty(Alltrim(QryZZ4->SPC))
		
		lRetIR	:= "IRR"
		
	Case (AllTrim(QryZZ4->OPERAC) $ "N11") .And. !Empty(Alltrim(QryZZ4->SPC))
		
		lRetIR	:= "IBS"
		
EndCase

Do Case
	
	Case AllTrim(QryZZ4->OPERAC) == "N01" .And. lRetIR == "IOW"
		
		cGarmcl := "N"
		
	Case AllTrim(QryZZ4->OPERAC) == "N01" .And. lRetIR == "IRR"
		
		cGarmcl := "S"
		
	Case AllTrim(QryZZ4->OPERAC) == "N01" .And. lRetIR == "IRF"
		
		cGarmcl := "N"
		
	Case AllTrim(QryZZ4->OPERAC) == "N01" .And. lRetIR == "IXT"
		
		cGarmcl := "S"
		
		
	Case AllTrim(QryZZ4->OPERAC) == "N08" .And. lRetIR == "IRE"
		
		cGarmcl := "S"
		
		
	Case AllTrim(QryZZ4->OPERAC) == "N08" .And. lRetIR == "IXT"
		
		cGarmcl := "S"
		
		
	Case AllTrim(QryZZ4->OPERAC) == "N09" .And. lRetIR == "IRS"
		
		cGarmcl := "S"
		
	Case AllTrim(QryZZ4->OPERAC) == "N09" .And. lRetIR == "IXT"
		
		cGarmcl := "S"
		
	Case AllTrim(QryZZ4->OPERAC) == "N10" .And. lRetIR == "IRR"
		
		cGarmcl := "S"
		
	Case AllTrim(QryZZ4->OPERAC) == "N10" .And. lRetIR == "IRF"
		
		cGarmcl := "N"
		
	Case AllTrim(QryZZ4->OPERAC) == "N10" .And. lRetIR == "IOW"
		
		cGarmcl := "N"
		
	Case AllTrim(QryZZ4->OPERAC) == "N10" .And. lRetIR == "IXT"
		
		cGarmcl := "S"
		
		
	Case AllTrim(QryZZ4->OPERAC) == "N11" .And. lRetIR == "IBS"
		
		cGarmcl := "S"
		
	Case AllTrim(QryZZ4->OPERAC) == "N11" .And. lRetIR == "IRF"
		
		cGarmcl := "N"
		
	Case AllTrim(QryZZ4->OPERAC) == "N11" .And. lRetIR == "IOW"
		
		cGarmcl := "N"
		
	Case AllTrim(QryZZ4->OPERAC) == "N11" .And. lRetIR == "IRR"
		
		cGarmcl := "S"
		
	Case AllTrim(QryZZ4->OPERAC) == "N11" .And. lRetIR == "IXT"
		
		cGarmcl := "S"
		
		
EndCase

QryZZ4->(dbCloseArea())

Return(lRetIR)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VERFASTEC ºAutor  ³Microsiga           º Data ³  26/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se fase informada corresponde ao tecnico          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function VerFasTec(_cCodTec, _cLab, _cCodFas, _cCodSet)

Local _aAreaZZB := ZZB->(GetArea())
Local _lRet     := .F.

//ZZB->(dbSetOrder(2)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODFAS + ZZB_CODSET
ZZB->(dbSetOrder(1)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODSET + ZZB_CODFAS

if ZZB->(dbSeek(xFilial("ZZB") + _cCodTec + _cLab + _cCodSet + AllTrim(_cCodFas) ))
	CODSET := AllTrim(_cCodSet) + ' / ' + AllTrim(Posicione("ZZ2",1,xfilial("ZZ2") + LAB + _cCodSet, "ZZ2_DESSET" ))
	FAS1   := AllTrim(_cCodFas) + ' / ' + AllTrim(Posicione("ZZ1",1,xfilial("ZZ1") + LAB + _cCodSet + _cCodFas, "ZZ1_DESFA1" ))
	_lRet  := .T.
endif

restarea(_aAreaZZB)

return(_lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VERFASDESTºAutor  ³Microsiga           º Data ³  26/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se fase informada corresponde ao tecnico          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function VerFasDest(_cLab, _cCodSet, _cFasOri, _cSetDest, _cFasDest)

Local _aAreaZZA := ZZA->(GetArea())
Local _lRet     := .F.
_cFasOri := AllTrim(_cFasOri) + Space(6-len(AllTrim(_cFasOri)))
_cFasDest := AllTrim(_cFasDest) + Space(6-len(AllTrim(_cFasDest)))

ZZA->(dbSetOrder(1)) // ZZA_FILIAL + ZZA_LAB + ZZA_SETOR1 + ZZ_CODFAS //Incluso Edson Rodrigues 09-03-09

if ZZA->(dbSeek( xFilial("ZZA") + _cLab + _cCodSet + _cFasOri + _cSetDest + _cFasDest ))
	FAS2  := AllTrim(ZZA->ZZA_FASE2) + ' / ' + AllTrim(Posicione("ZZ1",1,xfilial("ZZ1") + ZZA->ZZA_LAB + ZZA->ZZA_SETOR2 + ZZA->ZZA_FASE2, "ZZ1_DESFA1" ))
	_lRet := .T.
endif

&& VldFasBloq - Validação de Fase Bloqueada 
&& Chamado - ID 5669 - Thomas Quintino Galvão - 17/07/2012
If _lRet
	_lRet := u_VldFasBloq(_cLab, _cCodSet, _cFasOri, _cSetDest, _cFasDest)
EndIf 

restarea(_aAreaZZA)

return(_lRet)

/**
 * Rotina		:	VldFasBloq - Chamado - ID 5669
 * Autor		:	Thomas Quintino Galvão
 * Data			:	17/07/2012	
 * Descricao	:	Validação de Fase Bloqueada
 */ 
User Function VldFasBloq(_cLab, _cCodSet, _cFasOri, _cSetDest, _cFasDest)
	Local _aAreaZZA := ZZA->(GetArea())
	Local _lRet     := .T.
   
	_cFasOri := AllTrim(_cFasOri) + Space(6-len(AllTrim(_cFasOri)))
	_cFasDest := AllTrim(_cFasDest) + Space(6-len(AllTrim(_cFasDest)))
	
	ZZA->(dbSetOrder(1))
	
	If ZZA->(dbSeek( xFilial("ZZA") + _cLab + _cCodSet + _cFasOri + _cSetDest + _cFasDest ))
		If AllTrim(Posicione("ZZ1",1,xfilial("ZZ1") + ZZA->ZZA_LAB + ZZA->ZZA_SETOR2 + ZZA->ZZA_FASE2, "ZZ1_MSBLQL" )) =="1"
			apMsgStop("A fase "+AllTrim(FAS2)+" está bloqueada, não será possível usa-lá como Destino!","Usar setor destino diferente")
			_lRet := .F.
		EndIf		
	endif	
	RestArea(_aAreaZZA)
Return _lRet	


Static Function AltOpbgh()

Local _aAreaZZA := ZZA->(GetArea())

dbSelectArea("ZZA")
dbSetOrder(1)
MsSeek(xFilial("ZZA") + LAB + LEFT(CODSET,6) + LEFT(FAS1,2) + LEFT(CODSE2,6) + LEFT(FAS2,2))

msgAlert(ZZA->ZZA_ALTOPE)
ctransope := ZZA->ZZA_ALTOPE

restarea(_aAreaZZA)

Return(ctransope)







User Function DigitaCli()

Local _aAreaSA1 := SA1->(GetArea()) //Alterado e Incluso - Edson Rodrigues - 04/08/10
// Variaveis Private da Funcao
Private ocCliente
Private ocLoja
Private oDlgCli				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

DEFINE MSDIALOG oDlgCli TITLE "Dados do Cliente da OS" FROM C(306),C(324) TO C(465),C(534) PIXEL

// Cria as Groups do Sistema
@ C(001),C(002) TO C(080),C(103) LABEL "Cliente" PIXEL OF oDlgCli

// Cria Componentes Padroes do Sistema
@ C(015),C(004) Say "Cliente" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlgCli
@ C(030),C(005) Say "Loja"  Size C(012),C(008) COLOR CLR_BLACK PIXEL OF oDlgCli
@ C(014),C(025) MsGet ocCliente Var cCliente F3 "SA1"  VALID Valcli(cCliente,cloja) Size C(052),C(009) COLOR CLR_BLACK PIXEL OF oDlgCli
@ C(030),C(026) MsGet ocLoja Var cLoja VALID Valcli(cCliente,cLoja) Size C(013),C(009) COLOR CLR_BLACK PIXEL OF oDlgCli
DEFINE SBUTTON FROM C(058),C(043) TYPE 1 ENABLE OF oDlgCli ACTION (odlgcli:end())

ACTIVATE MSDIALOG oDlgCli centered

//RestArea1(_aArea)
restarea(_aAreaSA1) //Incluso - Edson Rodrigues - 04/08/10

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtrlArea º Autor ³Ricardo Mansano     º Data ³ 18/05/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ Fab.Tradicional  ³Contato ³ mansano@microsiga.com.br       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Static Function auxiliar no GetArea e ResArea retornando   º±±
±±º          ³ o ponteiro nos Aliases descritos na chamada da Funcao.     º±±
±±º          ³ Exemplo:                                                   º±±
±±º          ³ Local _aArea  := {} // Array que contera o GetArea         º±±
±±º          ³ Local _aAlias := {} // Array que contera o                 º±±
±±º          ³                     // Alias(), IndexOrd(), Recno()        º±±
±±º          ³                                                            º±±
±±º          ³ // Chama a Funcao como GetArea                             º±±
±±º          ³ P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         º±±
±±º          ³                                                            º±±
±±º          ³ // Chama a Funcao como RestArea                            º±±
±±º          ³ P_CtrlArea(2,_aArea,_aAlias)                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nTipo   = 1=GetArea / 2=RestArea                           º±±
±±º          ³ _aArea  = Array passado por referencia que contera GetArea º±±
±±º          ³ _aAlias = Array passado por referencia que contera         º±±
±±º          ³           {Alias(), IndexOrd(), Recno()}                   º±±
±±º          ³ _aArqs  = Array com Aliases que se deseja Salvar o GetArea º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Generica.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ValCli(cCliente,cloja)
If !SA1->(EOF()) .And. cCliente = SA1->A1_COD .And. Empty(cLoja)
	cLoja := SA1->A1_LOJA
	ocLoja:refresh()
ElseIf !SA1->(EOF()) .And. cCliente = SA1->A1_COD .And. cLoja = SA1->A1_LOJA
	Return .T.
ElseIf !Empty(cCliente) .And. !Empty(cLoja) .And. SA1->(EOF())
	SA1->(DbSetOrder(1))
	iF !SA1->(DbSeek(Xfilial("SA1") + cCliente + cLoja))
		apMsgStop("Cliente Invalido","Cliente")
		Return .F.
	EndIF
ElseIf !Empty(cCliente) .And. Empty(cLoja) .And. SA1->(EOF())
	SA1->(DbSetOrder(1))
	iF !SA1->(DbSeek(Xfilial("SA1") + cCliente ))
		apMsgStop("Cliente Invalido","Cliente")
		Return .F.
	EndIF
	cLoja := SA1->A1_LOJA
	ocLoja:refresh()
Else
	apMsgStop("Cliente Invalido","Cliente")
	Return .F.
EndIf
Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OutInf    ºAutor  ³ Edson Rodrigues    º Data ³  ??????     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para informar outras infromacoes das operacoes lab 2  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OutInf(COPEBGH,CGARANT,cSofIn,csoftout,ctransc,CODSET,_cfase1,cfastnfix,cfasouinf,cfasalltn,_ctela)

Local descgaran:=IIf(CGARANT = "S","EM GARANTIA","FORA DE GARANTIA")
Local cdescoper:=Posicione("ZZJ",1,xFilial("ZZJ")+COPEBGH+LAB,"ZZJ_DESCRI")
Local oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
cartime:="00000000000000000000"

// Cria Componentes Padroes do Sistema
If  AllTrim(_cfase1) $ AllTrim(cfasouinf) .And. _ctela='1' // GET Vers.Soft.Out, Vers.Soft.In,Artime - Util. aparelho 
	DEFINE MSDIALOG oDlgout TITLE "Outras" FROM C(252),C(395) TO C(521),C(709) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(136),C(157) LABEL "Outras Informacoes" PIXEL OF oDlgout
	@ C(007),C(012) Say "Operacao: "+AllTrim(cdescoper)+"." Size C(160),C(050)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
	@ C(017),C(032) Say ""+AllTrim(descgaran)+"" Size C(160),C(025)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
	
	@ C(032),C(070) MsGet osoftout Var csoftout f3 "ZAD"  Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(034),C(013) Say "Versao Software OUT:" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(050),C(070) MsGet osofin Var csofin Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(052),C(013) Say "Versao Software IN :" Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(067),C(070) MsGet oartime Var cartime VALID !Empty(cartime) PICT "99999999999999999999" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(068),C(012) Say "Artime - Util. aparelho:" Size C(053),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	DEFINE SBUTTON FROM C(109),C(072) TYPE 1 ENABLE OF oDlgout ACTION (odlgOut:end())
EndIf

If ALLTRIM(_cfase1) $ AllTrim(cfastnfix) .And. _ctela='2' // GET Transaction
	DEFINE MSDIALOG oDlgout TITLE "Outras" FROM C(252),C(300) TO C(400),C(600) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(65),C(150) LABEL "Outras Informacoes" PIXEL OF oDlgout
	@ C(007),C(012) Say "Operacao: "+AllTrim(cdescoper)+"." Size C(160),C(050)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
	@ C(017),C(032) Say ""+AllTrim(descgaran)+"" Size C(160),C(025)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
//	@ C(032),C(070) MsGet otransc Var ctransc F3 "W5" VALID EXISTCPO("SX5","W5" + ctransc) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(032),C(070) MsGet otransc Var ctransc F3 "W5" VALID u_VldTransc(cTransc,COPEBGH,LAB) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(034),C(012) Say "Codigo transacao:" Size C(045),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	DEFINE SBUTTON FROM C(048),C(072) TYPE 1 ENABLE OF oDlgout ACTION (odlgOut:end())
	
Endif

If _ctela='3' // GET Transaction
	DEFINE MSDIALOG oDlgout TITLE "Outras" FROM C(252),C(300) TO C(400),C(600) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(65),C(150) LABEL "Outras Informacoes" PIXEL OF oDlgout
	@ C(007),C(012) Say "Operacao: "+AllTrim(cdescoper)+"." Size C(160),C(050)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
	@ C(017),C(032) Say ""+AllTrim(descgaran)+"" Size C(160),C(025)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
//	@ C(032),C(070) MsGet otransc Var ctransc F3 "W5" VALID EXISTCPO("SX5","W5" + ctransc) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(032),C(070) MsGet otransc Var ctransc F3 "W5" VALID u_VldTransc(cTransc,COPEBGH,LAB) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(034),C(012) Say "Codigo transacao:" Size C(045),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	DEFINE SBUTTON FROM C(048),C(072) TYPE 1 ENABLE OF oDlgout ACTION (odlgOut:end())
Endif

ACTIVATE MSDIALOG oDlgout centered

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Outisix   ºAutor  ³ Edson Rodrigues    º Data ³  19/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para informar outras infromacoes Sony brasil - SIX    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Outisix(COPEBGH,_cgarinf,cdific,crepair,ccondic,CODSET,_ctela)

IF empty(_cgarinf)
	if ApMsgYesNo("Esse APARELHO Esta na GARANTIA ?","APARELHO GARANTIA SIM OU NAO ?")
		_cgarinf :="S"
	Else
		_cgarinf :="N"
	Endif
	RecLock("ZZ4",.F.)
	ZZ4->ZZ4_GARANT := _cgarinf
	MSUnlock()
EndIf


descgaran:=IIf(_cgarinf = "S","EM GARANTIA","FORA DE GARANTIA")
cdescoper:=Posicione("ZZJ",1,xFilial("ZZJ")+COPEBGH+LAB,"ZZJ_DESCRI")
oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
cartime:="00000000000000000000"

// Cria Componentes Padroes do Sistema
If   _ctela='1'
	dbSelectArea("SZ8")
	dbSetOrder(2)
	
	DEFINE MSDIALOG oDlgout TITLE "Outras Inform. SIX" FROM C(252),C(395) TO C(521),C(709) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(136),C(157) LABEL "Outras Informacoes SIX" PIXEL OF oDlgout
	@ C(007),C(012) Say "Operacao: "+AllTrim(cdescoper)+"." Size C(160),C(050)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
	@ C(017),C(032) Say ""+AllTrim(descgaran)+"" Size C(160),C(025)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
	
	@ C(032),C(070) MsGet odific Var cdific f3 "ZY"  VALID ExistCPO("SX5","ZY"+cdific,1) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(034),C(013) Say "Cod. Difficult SIX:" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(050),C(070) MsGet ocrepair Var crepair F3 "SZ8SOL" VALID ExistCPO("SZ8",LAB+crepair,2)   Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(052),C(013) Say "Cod. Reparo SIX :" Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	//@ C(067),C(070) MsGet oartime Var cartime VALID !Empty(cartime) PICT "99999999999999999999" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	//@ C(068),C(012) Say "Artime - Util. aparelho:" Size C(053),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	DEFINE SBUTTON FROM C(109),C(072) TYPE 1 ENABLE OF oDlgout ACTION (odlgOut:end())
	
Elseif _ctela='2'
	DEFINE MSDIALOG oDlgout TITLE "Outras Inform. SIX" FROM C(252),C(300) TO C(400),C(600) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(65),C(150) LABEL "Outras Informacoes SIX" PIXEL OF oDlgout
	@ C(007),C(012) Say "Operacao: "+AllTrim(cdescoper)+"." Size C(160),C(050)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
	@ C(017),C(032) Say ""+AllTrim(descgaran)+"" Size C(160),C(025)  COLOR CLR_RED PIXEL OF oDlgout FONT oFnt1
	@ C(032),C(070) MsGet ocondic Var ccondic F3 "ZT" VALID ExistCPO("SX5","ZT"+alltrim(ccondic))  Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgout
	@ C(034),C(012) Say "Codigo Condition :" Size C(045),C(008) COLOR CLR_BLACK PIXEL OF oDlgout
	DEFINE SBUTTON FROM C(048),C(072) TYPE 1 ENABLE OF oDlgout ACTION (odlgOut:end())
	
EndIf


ACTIVATE MSDIALOG oDlgout centered

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Vergaran  ºAutor  ³ Edson Rodrigues    º Data ³  20/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula tempo de garantida do aparelho                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Vergaran(cImei)
Local _aAreaZZ4 := ZZ4->(GetArea())
Local _newimei  :=AllTrim(cImei) + Space(20-len(AllTrim(cImei)))
Local _cgaran   := ""
Local _cserial  := ""
Local _coper    := ""
Local _lret     :=.T.

ZZ4->(DbSetOrder(4))
If ZZ4->(dbSeek(xFilial("ZZ4") +  _newimei))
	While !ZZ4->(EOF()) .And. ZZ4->ZZ4_IMEI== _newimei
		If ZZ4->ZZ4_STATUS < "9" .And. !Empty(ZZ4->ZZ4_GARANT)
			_cgaran:=ZZ4->ZZ4_GARANT
			_coper :=ZZ4->ZZ4_OPEBGH
		Else
			_cserial:=AllTrim(ZZ4->ZZ4_CARCAC)
			If len(_cserial) == 10
				_cgaran:=u_vergaran(_cserial,_coper,_newimei)
			Else
				_lret     :=.F.
			Endif
		EndIf
		ZZ4->(DBSKIP())
	ENDDO                                                                            
Endif

If _lret .And. _cgaran =="S"
	apMsgStop("ESSE APARELHO ESTA NA GARANTIA.","GARANTIA")
ElseIf _lret .And. _cgaran =="N"
	apMsgStop("ESSE APARELHO NAO ESTA NA GARANTIA.","FORA DE GARANTIA")
Else
	apMsgStop("NAO FOI ENCONTRADO ESSE IMEI CADASTRADO OU O SN ESTA INCORRETO.","IMEI NAO CADASTRADO/SN INCORRETO")
Endif

cImei:=SPACE(15)
ocodimei:SetFocus()
restarea(_aAreaZZ4)
return(_lret)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Verdef    ºAutor  ³ Paulo Lopez        º Data ³  18/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Defeito Reclamado Cliente                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Verdef(IMEI,_ccliente,_cloja,_cnfenr,_cnfeser,_clab)

Local cQry

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao Query                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQry := "SELECT LEFT(SZA.ZA_DEFRECL, 5) +' / ' + ZZG.ZZG_DESCRI  AS DEFRECL" + _center
cQry += "FROM " + RetSqlName("SZA") + " SZA (nolock) " + _center
cQry += "LEFT JOIN " + RetSqlName("ZZG") + "  ZZG (nolock) " + _center
cQry += "ON (LEFT(SZA.ZA_DEFRECL, 5) = ZZG.ZZG_CODIGO AND SZA.D_E_L_E_T_ = ZZG.D_E_L_E_T_ ) " + _center
cQry += "WHERE SZA.D_E_L_E_T_ = ''  "+ _center
cQry += "AND ZZG.ZZG_LAB = '"+_clab+"' "+ _center
cQry += "AND SZA.ZA_NFISCAL = '"+_cnfenr+"' "+ _center
cQry += "AND SZA.ZA_NFISCAL = '"+_cnfeser+"' "+ _center
cQry += "AND SZA.ZA_CLIENTE = '"+_ccliente+"' "+ _center
cQry += "AND SZA.ZA_LOJA = '"+_cloja+"' "+ _center
cQry += "AND SZA.ZA_IMEI = '" +Left(IMEI,15) + "' "+ _center

//MemoWrite("verdef.sql", cQry)

TCQUERY cQry NEW ALIAS QRY



_cDefRec := QRY->DEFRECL

QRY->(dbCloseArea())

Return(_cDefRec)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravDef   ºAutor  ³ Paulo Lopez        º Data ³  18/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza  Status do Defeito Reclamado na Tabela ZZM        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GravDef(_cImei)

Local cQryExecUpZM
Local cQryExecUpZA

cQryExecUpZM := "UPDATE " + RetSqlName("ZZM")  + _center
cQryExecUpZM += "SET ZZM_MSBLQL = '1' " + _center
cQryExecUpZM += "FROM " + RetSqlName("ZZM") + " ZM (NOLOCK) " + _center
cQryExecUpZM += "WHERE D_E_L_E_T_ = '' " + _center
cQryExecUpZM += "AND ZZM_MSBLQL = '2' " + _center
cQryExecUpZM += "AND ZZM_IMEI = '"+_cImei+"' " + _center

//MemoWrite("verdefx.sql", cQryExecUpZM)

TcSqlExec(cQryExecUpZM)
TCRefresh(RETSQLNAME("ZZM"))


cQryExecUpZA := "UPDATE " + RetSqlName("SZA") + _center
cQryExecUpZA += "SET ZA_CODRECL = ZZG.ZZG_RECCLI " + _center
cQryExecUpZA += "FROM " + RetSqlName("SZA") + " SZA (NOLOCK) " + _center
cQryExecUpZA += "INNER JOIN " + RetSQlName("ZZG") + " ZZG (NOLOCK) " + _center
cQryExecUpZA += "ON (SZA.ZA_DEFRECL = ZZG.ZZG_CODIGO AND SZA.D_E_L_E_T_ = ZZG.D_E_L_E_T_ AND ZZG.ZZG_LAB = '2' AND ZZG.ZZG_FILIAL = '') " + _center
cQryExecUpZA += "WHERE SZA.D_E_L_E_T_ = '' " + _center
cQryExecUpZA += "AND SZA.ZA_DEFRECL != '' " + _center
cQryExecUpZA += "AND ZZG.ZZG_RECCLI ! ='' " + _center
cQryExecUpZA += "AND SZA.ZA_IMEI = '"+_cImei+"' " + _center

//MemoWrite("verdefx1.sql", cQryExecUpZM)
TcSqlExec(cQryExecUpZA)
TCRefresh(RETSQLNAME("SZA"))

Return

//=================================================
//=================================================
//  VERIRICA CONSISTENCOA DE OP PARA SOBY REFURBIS
//=================================================

STATIC FUNCTION VER_OP()

dbselectarea("ZZ4")
dbsetorder(1)
ZZ4->(dbSeek(xFilial("ZZ4") + ZZ3->ZZ3_IMEI + left(ZZ3->ZZ3_NUMOS,6) ))
lvdaprod  :=U_VLDPROD(ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB) //Valida operações para chamar a função de inclusão ou estorno de OP. Edson Rodrigues 05/05/10
// VERIFICANDO SE É SOBY REFURBISH
If !lvdaprod
	RETURN(.T.)
EndIf

// ANALISANDO EXISTENCIA DE OP
DBSELECTAREA("SC2")
DBSELECTAREA(1)
If !DBSEEK(XFILIAL("SC2")+ALLTRIM(ZZ3->ZZ3_NUMOS))
	MsgAlert("Atenção, este apontamento esta sem amarração com Ordem de Produção, verifique!")
	return(.F.)
	
ElseIf DBSEEK(XFILIAL("SC2")+ALLTRIM(ZZ3->ZZ3_NUMOS)) .And. SC2->C2_QUJE = 0
	MsgAlert("Ordem de Produção ja apontada, verifique com adm do sistema!")
	return(.F.)
EndIf

// ANALISE ESTOQUE DAS PECAS
DBSELECTAREA("SZ9")
DBSETORDER(1)
DBSEEK(XFILIAL("SZ9")+ALLTRIM(ZZ3->ZZ3_NUMOS))

WHILE !EOF() .And. ALLTRIM(ZZ3->ZZ3_NUMOS) == ALLTRIM(SZ9->Z9_NUMOS)
	
	If SZ9->Z9_ACTION == "01"
		// VERIFICA ALMOXARIFADO 34
		DBSELECTAREA("SB2")
		DBSETORDER(1)
		If !DBSEEK(XFILIAL("SB2")+SUBSTR(SZ9->Z9_PARTNR,1,15)+"34")
			MsgAlert("Almoxarifado 34 nao existe para o PartNumber, corrija!: "+SUBSTR(SZ9->Z9_PARTNR,1,15))
			return(.F.)
		EndIf
		
		// VERIFICA SALDO
		if SB2->B2_QATU < SZ9->Z9_QTY
			Msgalert("PartNumber: "+SUBSTR(SZ9->Z9_PARTNR,1,15)+" SEM ESTOQUE!")
			RETURN(.F.)
		EndIf
	EndIf
	
	DBSELECTAREA("SZ9")
	SZ9->(DBSKIP())
ENDDO

RETURN(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SRConsal  ºAutor  ³ Edson Rodrigues    º Data ³  10/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo Sony Refurbish - Consulta Saldo de Aparelhos e    º±±
±±º          ³ Peças                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function SRConsal(_cpeca,carmpeca,_crastro,clotesub,carmproc,_cnewpro,_cnumos,_cIMEI,_nZ9Qty,_cSeqZZ3,_lempenh,_lContinua,_aEmpenh,_aNotEmp,lInclui,lgeraemp)
Local nSalb2:=0.00
Local nSalbf:= 0.00
NMODULO:=04
CMODULO:="EST"

dbselectarea("SB2")
If !SB2->(DBSeek(xFilial('SB2')+_cpeca+left(carmpeca,2)))
	U_saldoini(_cpeca,left(carmpeca,2))
	AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),_cIMEI,0,0,.F.,'SB2-Sem Saldo no Estoque p/ Partnumber','Incluir Saldo no armazem de Producao',_cSeqZZ3})
	_lempenh:=.F.
	_lContinua:=.F.
Else
	dbselectarea("SB2")
	SB2->(DBSeek(xFilial('SB2')+_cpeca+left(carmpeca,2)))  //Para garantir, posiciona o SB2 - Edson Rodrigues 03/03/10
	_calias=alias()
	
	//Opção para ver o saldo disponível SB2 através de função do sistema - Edson Rodrigues - 15/03/10
	nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
	
	//If  SB2->B2_QATU > 0 .And. SB2->B2_QATU>=_nZ9Qty
	If  nSalb2 > 0 .And. nSalb2 >=_nZ9Qty
		dbselectarea("SBF")
		//SBF->(dbsetorder(1))
		SBF->(dbsetorder(2))
		//If !SBF->(DBSeek(xFilial('SBF')+left(carmpeca,2)+substr(carmpeca,3,15)+_cpeca))
		If !SBF->(DBSeek(xFilial('SBF')+_cpeca+left(carmpeca,2)))
			AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),_cIMEI,0,0,.F.,'SBF-Sem Saldo no Endereco p/ Partnumber ','Enderecar o saldo do Partnumber',_cSeqZZ3})
			_lempenh:=.F.
			_lContinua:=.F.
		Else
			Do While ! SBF->(EOF()) .And. SBF->BF_FILIAL = XFILIAL("SBF") .And. SBF->BF_PRODUTO = _cpeca  .And. SBF->BF_LOCAL = left(carmpeca,2)
				nSalbf+=QtdComp(SaldoSBF(left(carmpeca,2),SBF->BF_LOCALIZ,_cpeca,SBF->BF_NUMSERI,SBF->BF_LOTECTL,If(Rastro(_cpeca, 'S'),SBF->BF_NUMLOTE,'')))
				SBF->(DbSkip())
			EndDo
			
			//If SB2->B2_QATU > 0 .And. SBF->BF_QUANT > 0  .And. !Empty(SBF->BF_LOCALIZ) .And. SB2->B2_QATU>=_nZ9Qty
			If nSalb2  > 0 .And.  nSalbf > 0  .And. nSalbf >= _nZ9Qty
				dbselectarea("SD4")
				SD4->(dbsetorder(2))
				If !SD4->(DBSeek(xFilial('SD4')+left(_cnumos,6)+'01001  '+_cpeca+left(carmpeca,2)))
					// Desabilitado função de inclusão apontamento - Edson Rodrigues 20/03/10
					//U_SRAdEmp(_cpeca,left(carmpeca,2),_cnumos,_nZ9Qty,_nZ9Qty,left(clotesub,10),substr(clotesub,11,6),@_aEmpenh,@lInclui,@_lempenh,@lgeraemp)
				Else
					dbselectarea("SD4")
					SD4->(DBSeek(xFilial('SD4')+left(_cnumos,6)+'01001  '+_cpeca+left(carmpeca,2)))  //Para garantir, posiciona o SD4 - Edson Rodrigues 03/03/10
					RecLock("SD4",.F.)
					SD4->D4_QTDEORI  :=SD4->D4_QTDEORI+iif(_nZ9Qty<=0,1,_nZ9Qty)
					SD4->D4_QUANT     :=SD4->D4_QUANT+iif(_nZ9Qty<=0,1,_nZ9Qty)
					MsUnlock()
				EndIf
			Else
				// If SB2->B2_QATU > 0  .And.  ( SBF->BF_QUANT <= 0 .OR. Empty(SBF->BF_LOCALIZ))
				If nSalb2  > 0   .And. nSalbf <= 0
					AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'SBF-Sem Saldo no Endereco p/ Partnumber ','Enderecar o saldo do Partnumber',_cSeqZZ3})
					//ElseIf SB2->B2_QATU <= 0
				ElseIf nSalb2 <= 0
					AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'SB2-Sem Saldo no Estoque p/ Partnumber','Incluir Saldo no armazem de Producao',_cSeqZZ3})
					
				EndIf
				_lempenh:=.F.
				_lContinua:=.F.
			EndIf
		EndIf
	Else
		AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,0,0,.F.,'SB2-Sem Saldo no Estoque p/ Partnumber','Incluir Saldo no armazem de Producao',_cSeqZZ3})
		_lempenh:=.F.
		_lContinua:=.F.
	EndIf
	dbselectarea(_calias)
EndIf

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ULTSAI   ºAutor  ³M.Munhoz - ERPPLUS  º Data ³  15/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar data de ultima saida do IMEI para    º±±
±±º          ³ calcular BOUNCE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UltSai()

Local _dSaida   := ctod("  /  /  ")
Local _cSaiIMEI := ZZ4->ZZ4_IMEI
Local _dEmisSai := Dtos(ZZ4->ZZ4_EMDT)
Local _cQry

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

_cQry :="SELECT MAX(D2_EMISSAO) AS EMISSAO " 				+ _center
_cQry +="FROM " + RetSqlName("SD2") + " SD2 (nolock) " 		+ _center
_cQry +="WHERE "				 							+ _center
_cQry +="D2_FILIAL  = '" + xFilial("SD2") + "' AND "		+ _center
_cQry +="D2_NUMSERI = '" + _cSaiIMEI + "' AND "				+ _center
_cQry +="D2_EMISSAO < '" + _dEmisSai + "' AND "				+ _center
_cQry +="D_E_L_E_T_ = '' " 									+ _center

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

_dUltSai := StoD(QRY->EMISSAO)

return(_dUltSai)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BLQIMEI  º Autor ³Paulo Francisco     º Data ³  14/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ BLOQUEIO DOS EQUIPAMENTOS FORA DE GARANTIA                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function BlqImei(IMEI)

Local _lRet      := .T.
Local _nFase	 := Transform(Substr(FAS2,1,2), "@E 99")
Local _cOper
Local _cOperfas
Local _cOperalt
Local _cOpergar
local _cConfCli
Local _cQry
Local _cQry1
Local _cQry2
Local _cQryExec
Local cTitemail := "Equipamento Sem Peças"
Local Path 		:= "172.16.0.7"
Local _center   := Chr(13)+Chr(10)

#IFDEF TOP
	Local xVaTemp		:= GetNextAlias()
	Local xlQuery		:= .F.
#ENDIF

Private _cSfa		:= GetMv("MV_SPCFASE")				 // Fases que Possam ser Apontados Aparelhos Fora de Garantia - Motorola

If Empty(IMEI)
	return(_lRet)
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

_cQry :="SELECT TOP 1	ZZ4.ZZ4_CODCLI			CODCLI, 	" + _center
_cQry +="				ZZ4.ZZ4_LOJA  			LOJA, 	  	" + _center
_cQry +="				ZZ4.ZZ4_IMEI  			IMEI, 	  	" + _center
_cQry +="				ZZ4.ZZ4_CARCAC			CARCAC,   	" + _center
_cQry +="				RTRIM(ZZ4.ZZ4_CODPRO)	COD, 	  	" + _center
_cQry +="				ZZ4.ZZ4_OS  			ORDSERV,  	" + _center
_cQry +="				ZZ4.ZZ4_NFENR  			NFE, 	  	" + _center
_cQry +="				ZZ4.ZZ4_NFESER			SERIE, 	  	" + _center
_cQry +="				ZZ4.ZZ4_STATUS			STATU, 	  	" + _center
_cQry +="				ZZ4.ZZ4_NFEDT  			DTENTRA,  	" + _center
_cQry +="				ZZ4.ZZ4_OPEBGH 			OPEBGH,   	" + _center
_cQry +="				ZZ4.ZZ4_BOUNCE			BOUNCE,   	" + _center
_cQry +="				ZZ4.ZZ4_GARANT			GARANT,    	" + _center
_cQry +="				ZZ4.ZZ4_GARMCL			GARMCL,    	" + _center
_cQry +="				ZZ4.ZZ4_TRANSC			TRANSC,		" + _center
_cQry +="				ISNULL(SZA.ZA_GARNFC,'N') GARNFC,	" + _center
_cQry +="				ISNULL(SZA.ZA_GARNFT,'N') GARNFT,	" + _center
_cQry +="				ISNULL(SZA.ZA_SPC,'N')    GARSPC,	" + _center
_cQry +="				ZZ4.R_E_C_N_O_ ZZ4RECNO				" + _center
_cQry +="FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock)   	" + _center
_cQry +="LEFT JOIN "+ RetSqlname("SZA") + " SZA (nolock)   	" +  _center
_cQry +="ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI    " + _center
_cQry +="AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_)   " + _center
_cQry +="WHERE ZZ4.D_E_L_E_T_ = ''    " + _center
_cQry +="AND ZZ4.ZZ4_FILIAL = '" + xFilial("ZZ4") + "' " + _center
_cQry +="AND ZZ4.ZZ4_IMEI = '" +  IMEI + "' " + _center
_cQry +="ORDER BY ZZ4.R_E_C_N_O_ DESC " + _center

//MemoWrite("c:\sql\axzz3.sql", _cQry)\

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Posiciona Operacao Parametrizada                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cOper 		:= Posicione("ZZJ",1,xFilial("ZZJ")+  AllTrim(QRY->OPEBGH),"ZZJ_BLGARA")
_cOperfas 	:= Posicione("ZZ2",1,xFilial("ZZ2") + LAB + left(CODSE2,6), "ZZ2_OPERAC")
_cOpergar 	:= Posicione("ZZ2",1,xFilial("ZZ2") + LAB + left(CODSE2,6), "ZZ2_BLGARA")
_cOperalt 	:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSE2,6) + LEFT(FAS2,2)+ SPACE(04),"ZZ1_ALTOPE")
_csetmast	:= Posicione("ZZJ",1,xFilial("ZZJ")+AllTrim(QRY->OPEBGH),"ZZJ_SETMAS") // variavel que obtem setor de impressao de etiqueta Master BGH
_cConfCli	:= Posicione("ZZJ",1,xFilial("ZZJ")+AllTrim(QRY->OPEBGH),"ZZJ_IMETQM")
_cvClimas	:= Posicione("ZZJ",1,xFilial("ZZJ")+AllTrim(QRY->OPEBGH),"ZZJ_VLCLIM")
_cvgarmas	:= Posicione("ZZJ",1,xFilial("ZZJ")+AllTrim(QRY->OPEBGH),"ZZJ_VLGARM")                            
_cimpetm 	:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSET,6) + LEFT(FAS1,2)+ SPACE(04),"ZZ1_IMPMAS")

// M.Munhoz - 05/03/2012 - Ticket 3505
// Alterado para gravar novo Transaction para a Fast Shop
// Confome Luiz Reis foi alterado a regra abaixo, onde a solução nao é mais a R0035 e  sim R0034 e também nesse caso não tem mais necessidade da pergunta. Edson Rodrigeus - 22/03/12
/*
if alltrim(QRY->OPEBGH) == 'N04' .and. SWAP == 'S' .and. left(SOLUCAO,5) == 'R0034' .and. alltrim(QRY->TRANSC) <> "IFS" //.and. ;
    //apMsgYesNo('Esta transação de Swap N04 refere-se a Fast Shop?','Fast Shop - Transaction Code')
	Begin Transaction
	ZZ4->(dbGoTo(QRY->ZZ4RECNO))	
	reclock("ZZ4",.f.)
	ZZ4->ZZ4_TRANSC := "IFS"
	msunlock()
	End Transaction
endif
*/
If Len(AllTrim(QRY->TRANSC)) > 0 .And. Len(AllTrim(_cOperalt))== 0 .And. Len(AllTrim(QRY->GARSPC))< 2 .And. LEFT(CODSE2,6) <> '000000' .And. LEFT(FAS2,2) <> '00'
	
	Do Case
		
		Case AllTrim(QRY->OPEBGH) == 'N01' .And. !(AllTrim(QRY->TRANSC) $ "IRR#IRF#IOW#IXT")
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " Fora de Garantia, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N02' .And. !(AllTrim(QRY->TRANSC) $ "IR2#ITS#IOW#IXT")
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " , Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N03' .And. AllTrim(QRY->TRANSC) <> "IR4"
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " , Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		// Incluido conteudo IFS para atender alteracao da Fast Shop (GLPI 3505) cfe conversado com Paulo Francisco
		Case AllTrim(QRY->OPEBGH) == 'N04' .And. !(AllTrim(QRY->TRANSC) $ "IER#IOW#IXT#IFS")
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " , Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N05' .And. AllTrim(QRY->TRANSC) <> "IOW"
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " , Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N06' .And. AllTrim(QRY->TRANSC) <> "IFR"
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " , Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N07' .And. AllTrim(QRY->TRANSC) <> "IOW"
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " , Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N08' .And. AllTrim(QRY->TRANSC) <> 'IRE'
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " Fora de Garantia, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N09' .And. AllTrim(QRY->TRANSC) <> 'IRS'
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " Fora de Garantia, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N10' .And. !(AllTrim(QRY->TRANSC) $ "IRR#IRF#IOW/IXT")
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " , Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		Case AllTrim(QRY->OPEBGH) == 'N11' .And. !(AllTrim(QRY->TRANSC) $ "IBS#IRF#IOW#IRR/IXT")
			
			MsgAlert("Equipamento com Transaction Cod " + QRY->TRANSC + " , Não Poderá Prosseguir !!!")
			_lRet := .F.
			
	EndCase
EndIf

If _cOper == 'S' .And. !Empty(_nFase)
	If QRY->GARNFC == 'S' .Or. QRY->GARNFT == 'S'
		If QRY->GARANT == "N" .And. !(_nFase $ AllTrim(_cSfa))
			MsgAlert("Equipamento Fora de Garantia, Não Poderá Prosseguir !!!")
			_lRet := .F.
		EndIf
	ElseIf QRY->GARNFC == 'N' .And. QRY->GARNFT == 'N' .And. Len(AllTrim(QRY->GARSPC))< 2 .And. !(_nFase $ AllTrim(_cSfa))
		MsgAlert("Favor Informar Nota Fiscal de Compra, Não Poderá Prosseguir !!!")
		_lRet := .F.
	EndIf
EndIf

If !Empty(AllTrim(_cOpergar)).And. !(_nFase $ AllTrim(_cSfa))
	If AllTrim(QRY->GARANT) <> AllTrim(_cOpergar)
		MsgStop("Equipamento Fora de Garantia, Não Poderá Prosseguir !!!")
		_lRet := .F.
	EndIf
EndIf

If !Empty(AllTrim(_cOperfas))
	If Empty(AllTrim(_cOperalt))
		If !AllTrim(QRY->OPEBGH) $ AllTrim(_cOperfas)
			
			_cVerFaseta := u_VerFasAtu(QRY->IMEI, QRY->ORDSERV)
			
			If !Empty(AllTrim(_cVerFaseta))
				apMsgStop("O IMEI encontra-se na setor/fase: "+AllTrim(right(_cVerFaseta,6))+"/"+ AllTrim(left(_cVerFaseta,6))+" Operação:" + AllTrim(QRY->OPEBGH) + " !","Operação Divergente do Setor")
				_lRet := .F.
			Else
				MsgAlert("Operação Divergente do Setor, Não Poderá Prosseguir !!!")
				_lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf

_cGarmcl 	:= 	AllTrim(QRY->GARMCL)
_cMissue 	:= 	AllTrim(QRY->COD)

If _lRet .And. _cvClimas='S' .and. !Empty(AllTrim(_cConfCli)) .And. AllTrim(_cConfCli) == 'S' .and. _cimpetm =="S"
	
	//If !Empty(AllTrim(_cConfCli)) .And. AllTrim(_cConfCli) == 'S'
		lClismas    := .T.
		If Empty(AllTrim(cCliente))
			
			cCliente	:=	AllTrim(QRY->CODCLI)
			cloja		:=	AllTrim(QRY->LOJA)
			
		EndIf
		
Else
		lClismas := .F.		
		lCliente := .F.
		
EndIf
	
//EndIf

If left(CODSET,6) == AllTrim(_csetmast) .And. Len(_aModBlq) == 0
	Aadd(_aModBlq,{QRY->COD})
	
ElseIf left(CODSET,6) $ AllTrim(_csetmast) .And. Len(_aModBlq) > 0
	If _aModBlq[01,01] <> QRY->COD
		apMsgStop("Modelo Diferente dos Apontamentos em execução","Divergencia Modelo")
		_lRet := .F.
	EndIf
EndIf                                                      

If _lRet .And. _cvgarmas='S' .and. !Empty(AllTrim(_cConfCli)) .And. AllTrim(_cConfCli) == 'S' .And. Len(_agarBlq) == 0
   Aadd(_agarBlq,{QRY->GARANT})                                                                                           

ElseIf _lRet .And. _cvgarmas='S' .and. !Empty(AllTrim(_cConfCli)) .And. AllTrim(_cConfCli) == 'S' .And. Len(_agarBlq) > 0
	If _agarBlq[01,01] <> QRY->GARANT
		apMsgStop("Garantia do Aparelho : "+QRY->GARANT+" , diferente dos Apontamentos em execução","Divergencia Garantia")
		_lRet := .F.
	EndIf
Endif   
   
// M.Munhoz - 07/03/2012 - Ticket 3470
// Alterado para gravar motivo do Scrap
if _lRet .and. posicione("ZZ1",1,xFilial("ZZ1") + LAB + LEFT(CODSET,6) + left(FAS1,2) , "ZZ1_MOTSCR") == "S" .and. empty(ZZ4->ZZ4_MOTSCR)
	_cMotScrap := MotScrap()
	if !empty(_cMotScrap)
		Begin Transaction
		ZZ4->(dbGoTo(QRY->ZZ4RECNO))
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_MOTSCR := _cMotScrap
		msunlock()
		End Transaction
	endif
endif

If QRY->OPEBGH == 'N04' .And. QRY->GARANT = 'S' .And. QRY->TRANSC $ 'IER' .And. Empty(AllTrim(QRY->GARSPC))
	
	_cQryExec := "UPDATE " + RetSqlName("SZA") + _center
	_cQryExec += "SET ZA_SPC = 'SPC0000515' " + _center
	_cQryExec += "WHERE ZA_CLIENTE = '" + QRY->CODCLI + "' " + _center
	_cQryExec += "AND ZA_LOJA = '" + QRY->LOJA + "' " + _center
	_cQryExec += "AND ZA_NFISCAL = '" + QRY->NFE + "' " + _center
	_cQryExec += "AND ZA_SERIE = '" + QRY->SERIE + "' " + _center
	_cQryExec += "AND ZA_IMEI = '" + QRY->IMEI + "' " + _center
	
	TcSQlExec(_cQryExec)
	TCRefresh(RETSQLNAME("SZA"))
	
EndIf


_cQry1 :="SELECT ZL_TRANSAC TRANSC " + _center
_cQry1 +="FROM " + RetSqlName("SZL") + " ZL (nolock) " + _center
_cQry1 +="WHERE ZL.D_E_L_E_T_ = '' " + _center
_cQry1 +="AND ZL.ZL_CODPROB = '"+LEFT(DEFDET,5) +"' " + _center
_cQry1 +="AND ZL.ZL_CODIGO = '"+LEFT(SOLUCAO,5)+"' " + _center

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry1), "QRY1", .F., .T.)

If Len(AllTrim(LEFT(SOLUCAO,5)))>0
	
	If Len(AllTrim(QRY->TRANSC))>0
		
		If AllTrim(QRY->TRANSC) == "IER" .And. Substr(QRY1->TRANSC,1,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IRF" .And. Substr(QRY1->TRANSC,2,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IOO" .And. Substr(QRY1->TRANSC,3,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IPC" .And. Substr(QRY1->TRANSC,4,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IPF" .And. Substr(QRY1->TRANSC,5,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IPR" .And. Substr(QRY1->TRANSC,6,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IPT" .And. Substr(QRY1->TRANSC,7,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IR2" .And. Substr(QRY1->TRANSC,8,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IR4" .And. Substr(QRY1->TRANSC,9,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IFR" .And. Substr(QRY1->TRANSC,10,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IOW" .And. Substr(QRY1->TRANSC,11,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "ITS" .And. Substr(QRY1->TRANSC,12,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IRR" .And. Substr(QRY1->TRANSC,13,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IRE" .And. Substr(QRY1->TRANSC,14,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IRS" .And. Substr(QRY1->TRANSC,15,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		ElseIf AllTrim(QRY->TRANSC) == "IBS" .And. Substr(QRY1->TRANSC,16,1) <> "X"
			MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
			//ElseIf AllTrim(QRY->TRANSC) == "IXT" .And. Substr(QRY1->TRANSC,17,1) <> "X"
			//	MsgAlert("Codigo de Defeito Constatado e Solução inadequado, Não Poderá Prosseguir !!!")
			//	_lRet := .F.
			
		EndIf
	EndIf
EndIf

If _lSwap2 .And. lUsrNext .Or. _lSwap2 .And. lUsrAdmi
	
	#IFDEF TOP
		
		xlQuery  := .T.
		BeginSql alias xVaTemp
			SELECT TOP 1 SZ9.Z9_SEQ AS SEQ
			FROM %table:SZ9% SZ9
			INNER JOIN %table:SB1% SB1 ON (B1_FILIAL = %xfilial:SB1% AND SZ9.Z9_PARTNR = B1_COD AND SB1.%notDel%)
			INNER JOIN %table:ZZW% ZZW ON (ZZW_FILIAL = %xfilial:ZZW% AND ZZW_CODIGO = B1_CREFDES AND ZZW.%notDel%)
			WHERE   SZ9.Z9_FILIAL = %xfilial:SZ9% 			AND
			SZ9.Z9_IMEI = %exp: (AllTrim(IMEI))%			AND
			SZ9.Z9_NUMOS = %exp: (AllTrim(QRY->ORDSERV))%	AND
			SZ9.Z9_PARTNR <> %exp: ''%						AND
			SZ9.%notDel% 									AND 
			ZZW.ZZW_SOLEST = %exp: 'S'%
			ORDER BY SZ9.R_E_C_N_O_ DESC
		EndSql
		
		If !Empty(AllTrim((xVaTemp)->SEQ))
			
			MsgAlert("Necessario Excluir Todas Peças Apontadas, Não Poderá Prosseguir !!!")
			_lRet := .F.
			
		EndIf
		
		If xlQuery
			
			(xVaTemp)->( DbCloseArea())
			
		Endif
		
	#ENDIF
	
EndIf

If ENCOS == "S" .And. _lRet .And. lUsrNext .Or. ENCOS == "S" .And. _lRet .And. lUsrAdmi
	
	If Empty(AllTrim(CODANA)) .Or. !("C" $ CODANA)
		
		MsgAlert("Necessario Apontar Codigo Analista Classificando Célula, Não Poderá Prosseguir !!!")
		_lRet := .F.
		
	EndIf
	
EndIf


If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf

return(_lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EXCLAPON ºAutor  ³Edson Rodrigues     º Data ³  27/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para excluir registro de apontamento do ZZ3 quando  º±±
±±º          ³ nao atender condicoes para Inclusão ou  alteracao e quando º±±
±±º          ³ o usuario resolver cancelar a inclusao dos apontamentos    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EXCLAPON(_nI,_nPosIMEI,_nPosOS)
_aRegSZ9:={}
_aRegZZ7:={}

DBSELECTAREA("ZZ3")
ZZ3->(dbGoto(_aRecnoZZ3[_nI,1]))
If !ZZ3->ZZ3_STATUS='1'
	If  ZZ3->ZZ3_IMEI==aCols[_nI,_nPosIMEI] .And. LEFT(ZZ3->ZZ3_NUMOS,6)==LEFT(aCols[_nI,_nPosOS],6) //Acrescentado para verificar se o acols esta posicionado certo no recno // Edson Rodrigues - 11/03/10
		reclock("ZZ3",.F.)
		ZZ3->ZZ3_STATRA :='0'
		ZZ3->ZZ3_USER   := cUserName
		msunlock()
		
		RecLock("ZZ3",.F.)
		DBDELETE()
		MsUnlock()
		U_GRVLOGFA("004")
		
		If lUsrNext .Or. lUsrAdmi
			//if left(FAS1,2) == "00"
			
			Dbselectarea("SZ9")
			SZ9->(dbSetOrder(1))//Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM
			
			If SZ9->(dbSeek(xFilial("SZ9") + ZZ3->ZZ3_NUMOS + ZZ3->ZZ3_CODTEC + ZZ3->ZZ3_SEQ))
				While SZ9->(!eof()) .And. SZ9->Z9_FILIAL == xFilial("SZ9") .And. ;
					SZ9->Z9_NUMOS == ZZ3->ZZ3_NUMOS .And. SZ9->Z9_CODTEC == ZZ3->ZZ3_CODTEC .And. SZ9->Z9_SEQ == ZZ3->ZZ3_SEQ
					
					Dbselectarea("SZ9")
					reclock("SZ9",.F.)
					dbDelete()
					msunlock()
					U_GRVLOGFA("005")
					SZ9->(dbSkip())
				EndDo
			EndIf
			//EndIf
		EndIf
		
		//-----|| 29.3.2010 - Edson Rodrigues
		//-----|| EXCLUI Empenhos ou Apontamento da OP - Processo Refurbish  - mesmo que a mesma pode está encerrada sem apontamento de peças
		Dbselectarea("ZZ4")
		DBSETORDER(1)
		If DBSEEK(XFILIAL("ZZ4")+ZZ3->ZZ3_IMEI+LEFT(ZZ3->ZZ3_NUMOS,6))
			lvdaprod  :=U_VLDDREQ(ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB) //Valida operações para chamar a função de inclusão ou estorno de OP. Edson Rodrigues 05/05/10
			
			_aRegSZ9 := _aRecnoZZ3[_ni,2]
			If  Len(_aRegSZ9)<=0 .And. lvdaprod
				_lencrrado:=IIf(ZZ3->ZZ3_ENCOS=='S' .And. ZZ3->ZZ3_STATUS=='1',.T.,.F.)
				U_EXEMPAPO("",0,LEFT(ZZ4->ZZ4_OS,6),ZZ4->ZZ4_CODPRO,_lencrrado,ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB)
			Else
				DBSELECTAREA("SZ9")
				For _nH := 1 To Len(_aRegSZ9)
					SZ9->(dbGoTo(_aRegSZ9[_nH]))
					
					//-----|| 9.3.2010 - Edson Rodrigues
					//-----|| EXCLUI Empenhos ou Apontamento da OP - Processo Refurbish
					//-----|| Colocada minha função antes da chamada da função do Eduardo mais abaixo, pois a a dele só funcionará se a OP estiver em aberto.
					If lvdaprod
						_lencrrado:=IIf(ZZ3->ZZ3_ENCOS=='S' .And. ZZ3->ZZ3_STATUS=='1' ,.T.,.F.)
						U_EXEMPAPO(SZ9->Z9_PARTNR,SZ9->Z9_QTY,LEFT(SZ9->Z9_NUMOS,6),ZZ4->ZZ4_CODPRO,_lencrrado,ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB)
					EndIf
					
					//-----|| 4.3.2010 - EDUARDO NAKAMATU
					//-----|| EXCLUI REQUISICAO
					If !Empty(SZ9->Z9_NUMSEQ)
						cOpe := ZZ4->ZZ4_OPEBGH
						cLab := ZZ3->ZZ3_LAB
						lFazReq  :=  IIf(!Empty(SZ9->Z9_PARTNR) .And. SZ9->Z9_USED=="0",.T.,.F.)
						lvdadreq  :=U_VLDDREQ(cOpe,cLab) //Valida operações para chamar a função de inserção/alteração de Mov. Interno. Edson Rodrigues 24/03/10
						lvdaprod  :=U_VLDPROD(cOpe,cLab)  //Valida se a opercao envolve processo de Ordem de producao. Edson Rodrigues  26/04/10
						
						If lFazReq .And. lvdadreq
							Dbselectarea("SD3")
							DBSETORDER(4)
							If DBSEEK(XFILIAL("SD3")+ALLTRIM(SZ9->Z9_NUMSEQ)+'E0'+SZ9->Z9_PARTNR)
								SD3->(U_REQ_EST(3,D3_COD,D3_LOCAL,D3_QUANT,D3_OP,D3_EMISSAO,D3_NUMSEQ,ZZJ->ZZJ_CODSF5,D3_CHAVE,RECNO(),lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM),ALLTRIM(ZZJ->ZZJ_CC)))
							Else
								MsgAlert("Não foi encontrado a sequencia de movimentação para a peça/OP : "+ALLTRIM(SZ9->Z9_PARTNR)+"/"+LEFT(SZ9->Z9_NUMOS,6)+"01001 "+" no armazém : "+ZZJ->ZZJ_ALMEP+" . Verifique ou entre contado com o Administrador do Sistema ! ")
							EndIf
						EndIf
					EndIf
					
					RecLock("SZ9",.F.)
					dbDelete()
					MsUnlock()
					U_GRVLOGFA("006")
				Next _nH
			EndIf
			// Altera status das pecas faltants apontadas
			If len(_aRecnoZZ3[_nI,4]) > 0
				_aRegZZ7 := _aRecnoZZ3[_ni,4]
				
				DBSELECTAREA("ZZ7")
				For _nH := 1 To Len(_aRegZZ7)
					//if ZZ7->(dbGoTo(_aRegZZ7[_nH]))
					ZZ7->(dbGoTo(_aRegZZ7[_nH]))
					RecLock("ZZ7",.F.)
					dbDelete()
					MsUnlock()
					U_GRVLOGFA("007")
					// EndIf
				Next _nH
			Endif
		Else
			apMsgStop(" Erro Grave de Sistema favor Printar essa Tela e entrar em contato com o Administrador do Sistema, IMEI/OS : "+aCols[_nI,_nPosIMEI]+"/"+aCols[_nI, _nPosOS]+" , nao encontrado na tabela de E/S Massiva ZZ4 " ," Falha de Sistema.")
		EndIf
		
		
	Else
		apMsgStop(" Erro Grave de Sistema favor Printar essa Tela e entrar em contato com o Administrador do Sistema, IMEI/OS acols: "+aCols[_nI,_nPosIMEI]+"/"+aCols[_nI, _nPosOS]+" , recno vetor : "+STRZERO(_aRecnoZZ3[_nI,1],10) +" . Falha de Sistema.")
	EndIf
Else
	apMsgStop("O IMEI/OS : "+ALLTRIM(ZZ3->ZZ3_IMEI)+"/"+ALLTRIM(ZZ3->ZZ3_NUMOS)+"  não foi apagado, pois esta com status já confirmados. ","Use a rotina de estorno para cancelar esse IMEI")
EndIf
return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EXCLAPO2 ºAutor  ³Edson Rodrigues     º Data ³  29/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para excluir registro de apontamento do ZZ3 quando  º±±
±±º          ³ usuario desejar cancelar apontamentos já inclusos ou fazer º±±
±±º          | estorno de atendimentos.                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EXCLAPO2(_nreczz3)

Dbselectarea("ZZ3")
ZZ3->(dbgoto(_nreczz3))

Dbselectarea("SZ9")
SZ9->(dbSetOrder(1))//Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM
If SZ9->(dbSeek(xFilial("SZ9") + ZZ3->ZZ3_NUMOS + ZZ3->ZZ3_CODTEC + ZZ3->ZZ3_SEQ))
	While SZ9->(!eof()) .And. SZ9->Z9_FILIAL == xFilial("SZ9") .And. ;
		SZ9->Z9_NUMOS == ZZ3->ZZ3_NUMOS .And. SZ9->Z9_CODTEC == ZZ3->ZZ3_CODTEC .And. SZ9->Z9_SEQ == ZZ3->ZZ3_SEQ
		
		//-----|| 9.3.2010 - Edson Rodrigues
		//-----|| EXCLUI Empenhos ou Apontamento da OP - Processo Refurbish
		//-----|| Colocada minha função antes da chamada da função do Eduardo mais abaixo, pois a a dele só funcionará se a OP estiver em aberto.
		Dbselectarea("ZZ4")
		DBSETORDER(1)
		DBSEEK(XFILIAL("ZZ4")+ZZ3->ZZ3_IMEI+LEFT(ZZ3->ZZ3_NUMOS,6))
		lvdaprod  :=U_VLDPROD(ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB) //Valida operações para chamar a função de inclusão ou estorno de OP. Edson Rodrigues 05/05/10
		If  lvdaprod
			_lencrrado:=.F.
			U_EXEMPAPO(SZ9->Z9_PARTNR,SZ9->Z9_QTY,LEFT(SZ9->Z9_NUMOS,6),ZZ4->ZZ4_CODPRO,_lencrrado,ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB)
		EndIf
		
		
		//-----|| 4.3.2010 - EDUARDO NAKAMATU
		//-----|| EXCLUI REQUISICAO
		If !Empty(SZ9->Z9_NUMSEQ)
			cOpe := ZZ4->ZZ4_OPEBGH
			cLab := ZZ3->ZZ3_LAB
			lFazReq  := IIf(!Empty(SZ9->Z9_PARTNR) .And. SZ9->Z9_USED=="0",.T.,.F.)
			lvdadreq  :=U_VLDDREQ(cOpe,cLab) //Valida operações para chamar a função de inserção/alteração de Mov. Interno. Edson Rodrigues 24/03/10
			lvdaprod  :=U_VLDPROD(cOpe,cLab)  //Valida se a opercao envolve processo de Ordem de producao. Edson Rodrigues  26/04/10
			
			If lFazReq .And. lvdadreq
				dbselectarea("SD3")
				DBSETORDER(4)
				//If DBSEEK(XFILIAL("SD3")+ALLTRIM(SZ9->Z9_NUMSEQ)) //Alterarado a busca para encontrar o registro correto nos caso onde já houve estorno. Edson Rodrigues 30/03/10
				If DBSEEK(XFILIAL("SD3")+ALLTRIM(SZ9->Z9_NUMSEQ)+'E0'+SZ9->Z9_PARTNR)
					// Desabilitado  o seek abaixo, pois já faz as validações acima no retorno da variável lvdadreq - Edson Rodrigues - 24/03/10
					//dbselectarea("ZZJ")
					//dbsetorder(1)
					//DBSEEK(XFILIAL("ZZJ")+cOPE+cLab)
					//If   !Empty(ZZJ->ZZJ_CODSF5) .And. !Empty(ZZJ->ZZJ_ALMEP) // Incluso Edson Rodrigues - 20/03/10 - Para entrar na função somente quando estiver preenchido o armazém de processo e Código de Movimentação Interna no cadastro de Operações
					//SD3->(U_REQ_EST(3,D3_COD,D3_LOCAL,D3_QUANT,D3_OP,D3_EMISSAO,D3_NUMSEQ,ZZJ->ZZJ_CODSF5))
					SD3->(U_REQ_EST(3,D3_COD,D3_LOCAL,D3_QUANT,D3_OP,D3_EMISSAO,D3_NUMSEQ,ZZJ->ZZJ_CODSF5,D3_CHAVE,RECNO(),lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM),ALLTRIM(ZZJ->ZZJ_CC)))
					//EndIf
				Else
					//MsgAlert("sequencia: "+ALLTRIM(SZ9->Z9_NUMSEQ)+" nao localizado!")
					MsgAlert("Não foi encontrado a sequencia de movimentação para a peça/OP : "+ALLTRIM(SZ9->Z9_PARTNR)+"/"+LEFT(SZ9->Z9_NUMOS,6)+"01001 "+" no armazém : "+ZZJ->ZZJ_ALMEP+" . Verifique ou entre contado com o Administrador do Sistema ! ")
				EndIf
			Endif
		EndIf
		Dbselectarea("SZ9")
		reclock("SZ9",.F.)
		dbDelete()
		msunlock()
		U_GRVLOGFA("008")
		SZ9->(dbSkip())
	EndDo
Else
	//-----|| 29.3.2010 - Edson Rodrigues
	//-----|| EXCLUI Empenhos ou Apontamento da OP - Processo Refurbish  - mesmo que a mesma pode está encerrada sem apontamento de peças
	Dbselectarea("ZZ4")
	DBSETORDER(1)
	DBSEEK(XFILIAL("ZZ4")+ZZ3->ZZ3_IMEI+LEFT(ZZ3->ZZ3_NUMOS,6))
	lvdaprod  :=U_VLDPROD(ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB) //Valida operações para chamar a função de inclusão ou estorno de OP. Edson Rodrigues 05/05/10
	If  lvdaprod
		_lencrrado:=.F.
		U_EXEMPAPO("",0,LEFT(ZZ4->ZZ4_OS,6),ZZ4->ZZ4_CODPRO,_lencrrado,ZZ4->ZZ4_OPEBGH,ZZ3->ZZ3_LAB)
	EndIf
Endif

ZZ7->(dbSetOrder(1))//Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM
if ZZ7->(dbSeek(xFilial("ZZ7") + ZZ3->ZZ3_NUMOS + ZZ3->ZZ3_CODTEC + ZZ3->ZZ3_SEQ))
	While (ZZ7->ZZ7_NUMOS == ZZ3->ZZ3_NUMOS) .And. (ZZ7->ZZ7_CODTEC == ZZ3->ZZ3_CODTEC) .And. (ZZ7->ZZ7_SEQ == ZZ3->ZZ3_SEQ)
		reclock("ZZ7",.F.)
		dbDelete()
		msunlock()
		U_GRVLOGFA("009")
		ZZ7->(dbSkip())
	EndDo
endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ APONPECA ºAutor  ³Edson Rodrigues     º Data ³  27/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao generica para fazer validacao e apontamento da OP deº±±
±±º          ³ pecas quando no encerramento do atendimento da  OS         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function APONPECA(_ni,_lContinua,_nreczzj,_nPosFaseO)
ZZJ->(dbgoto(_nreczzj))
carmpeca  :=ZZJ->ZZJ_ALMEP
carmpacab :=ZZJ->ZZJ_ALMPRO
carmproc  :=ZZJ->ZZJ_ALMEP
cmovprod  :=ZZJ->ZZJ_CODPRO
carmscrap :=ZZJ->ZZJ_ALMSCR
cprefixpa :=ALLTRIM(ZZJ->ZZJ_PREFPA)
_cfascrap :=ZZJ->ZZJ_FASSCR
_aRegSZ9   := {}
_aEmpenh   := {}
_aAponOP   := {}
_atransp   := {}
_lempenh   :=.T.
_laponta   :=.T.
lInclui    :=.T.
ltransf    :=.T.
_lgeraemp  :=.F.
_lgerapon  :=.T.
_lgertrans :=.T.
_lnotprnz9 :=.F.
clotesub   :=GetMV("MV_LOTESUB")
_nqtde      := 0.00
/*
carmpeca  :=GetMV("MV_ARMLPEC")
carmpacab :=GetMV("MV_ARMACAB")
carmproc  :=GetMV("MV_ARMPROC")
cmovprod  :=GetMV("MV_MOVPROD")
carmscrap:=GetMV("MV_ARMSCRA")
*/
_cpeca    :=''
_clocaliz :=''
_crastro  :=''
_cdtvalid :=''
_endpeca  :=substr(ALLTRIM(GetMV("MV_ARMLPEC")),3,10)
_aEmptrue := {}
_cnumos   :=left(ZZ3->ZZ3_NUMOS,6)

SB1->(dbsetOrder(1))

_cnewpro:=IIf(left(ZZ4->ZZ4_CODPRO,3)=="DPY",AllTrim(cprefixpa)+substr(AllTrim(ZZ4->ZZ4_CODPRO),4,12),AllTrim(cprefixpa)+AllTrim(ZZ4->ZZ4_CODPRO))
_cnewpro:=Alltrim(_cnewpro)+SPACE(15-len(AllTrim(_cnewpro)))

//----- variaveis de erro de log do edson
_cSeqZZ3 := ZZ3->ZZ3_SEQ

If LEN(_aRecnoZZ3[_ni,2]) > 0
	_aRegSZ9 := _aRecnoZZ3[_ni,2]
	_aEmptrue   := {}
	
	DBSELECTAREA("SZ9")
	For _nH := 1 To Len(_aRegSZ9)
		SZ9->(dbGoTo(_aRegSZ9[_nH]))
		_cnumos :=left(SZ9->Z9_NUMOS,6)
		_cpeca  :=Alltrim(SZ9->Z9_PARTNR)+SPACE(15-len(ALLTRIM(SZ9->Z9_PARTNR)))
		
		//If !Empty(SZ9->Z9_PARTNR) .And.  SZ9->Z9_USED="0" .And. SZ9->Z9_STATUS<>"0"
		// Alterado o If para contemplar a novo método de baixar as peças sem fazer empenho - Edson - 25/03/10
		If !Empty(SZ9->Z9_PARTNR) .And.  SZ9->Z9_USED="0" .And. SZ9->Z9_STATUS<>"0"  .And. !Empty(SZ9->Z9_NUMSEQ)
			_aEmpenh   := {}
			_nqtde     :=SZ9->Z9_QTY
			
			SB1->(DBSeek(xFilial('SB1')+_cpeca))
			_clocaliz :=SB1->B1_LOCALIZ
			_crastro  :=SB1->B1_RASTRO
			If _crastro $ "SL"
				_calias=alias()
				dbselectarea("SB8")
				SB8->(dbsetorder(3))
				If SB8->(DBSeek(xFilial('SB8')+_cpeca+left(carmproc,2)+left(clotesub,10)+substr(clotesub,11,6)))
					_cdtvalid:=DTOC(SB8->B8_DTVALID)
				EndIf
				dbselectarea(_calias)
			EndIf
			
			//Verifica saldo disponível
			//Desabilitado função Consulta de Saldo das Peças  - Edson Rodrigues 20/03/10
			//SRConsal(_cpeca,carmpeca,_crastro,clotesub,carmproc,_cnewpro,left(_cnumos,6),ZZ4->ZZ4_IMEI,SZ9->Z9_QTY,_cSeqZZ3,@_lempenh,@_lContinua,@_aEmpenh,@_aNotEmp,@lInclui,@ _lgeraemp)
			//NMODULO:=28
			//CMODULO:="TEC"
		Else
			_lnotprnz9:=.T.
		Endif
		// Corrigido para empenhar somente se tudo estiver OK -- Edson rodrigues - 03/03/10
		If _lempenh .And. _lContinua //.And.  len(_aEmpenh) > 0
			lInclui:=.T.
			// Desabilitado função de Inclusão de apontamento - Edson Rodrigues 20/03/10
			//NMODULO:=04
			//CMODULO:="EST"
			//_lempenh :=U_BGHOP002(_aEmpenh,lInclui)
			//NMODULO:=28
			//CMODULO:="TEC"
			//	if _lempenh
			//		AADD(_aEmptrue,{_aEmpenh[1],_aEmpenh[2],_aEmpenh[3],_aEmpenh[4],_aEmpenh[5],_aEmpenh[6],_aEmpenh[7],_aEmpenh[8]})
			//	endif
		Else
			_lempenh:=.F.
		Endif
	Next _nH
	
	If _lempenh
		_aAponOP   := {}
		
		SB1->(DBSeek(xFilial('SB1')+_cnewpro))
		If !SB2->(DBSeek(xFilial('SB2')+_cnewpro+left(carmproc,2)))
			U_saldoini(_cnewpro,left(carmproc,2))
		EndIf
		
		dbselectarea("SC2")
		dbsetorder(1)
		If SC2->(DBSeek(xFilial('SC2')+left(_cnumos,6)))  //Para garantir que a OP foi criada Edson Rodrigues 12/03/10
			lInclui:=.T.
			U_SRAdApo(cmovprod,_cnewpro,SB1->B1_UM,left(_cnumos,6),left(carmproc,2),@_laponta,@_aAponOP,@lInclui,@_lgerapon,SPACE(6))
			NMODULO:=28
			CMODULO:="TEC"
			If !_laponta
				AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'ERRAPON-Erro Apont.O.Producao','Simule o encerramento novamente e envie o Erro ao HelpDesk',_cSeqZZ3})
				//apMsgStop("Processo Refurbish Sony - Houve Falha Encerramento da OP : "+AllTrim(LEFT(ZZ4->ZZ4_OS,6))+ " Favor verificar. Duvidas Contate o administrador do sistema. Falha no Encerramento da OP.")
				_lContinua:=.F.
				If len(_aEmptrue) > 0
					For  x:=1 to Len(_aEmptrue)
						dbselectarea("SD4")
						SD4->(dbsetorder(2))
						If SD4->(DBSeek(xFilial('SD4')+_aEmptrue[x,3]+_aEmptrue[x,1]+_aEmptrue[x,2]))
							lInclui:=.F.
							_lgeraemp:=.T.
							// Desabilitado função de inclusão de apontamento - Edson Rodrigues 20/03/10
							//U_SRAdEmp(_aEmptrue[x,1],_aEmptrue[x,2],_aEmptrue[x,3],_aEmptrue[x,5],_aEmptrue[x,6],_aEmptrue[x,7],_aEmptrue[x,8],@_aEmpenh,@ lInclui,@_lempenh,@_lgeraemp)
							NMODULO:=28
							CMODULO:="TEC"
						EndIf
					Next
				Endif
			Endif
		Else
			_laponta :=.F.
			_lContinua:=.F.
			AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'ERRAPON-Nao encontrada a OP cadastrada ','Verifique o que ocorreu e  cadastre a OP manualmente ',_cSeqZZ3})
			If len(_aEmptrue) > 0
				For  x:=1 to len(_aEmptrue)
					dbselectarea("SD4")
					SD4->(dbsetorder(2))
					If SD4->(DBSeek(xFilial('SD4')+_aEmptrue[x,3]+_aEmptrue[x,1]+_aEmptrue[x,2]))
						lInclui:=.F.
						_lgeraemp := .T.
						// Desabilitado função de inclusão de apontamento - Edson Rodrigues 20/03/10
						//U_SRAdEmp(_aEmptrue[x,1],_aEmptrue[x,2],_aEmptrue[x,3],_aEmptrue[x,5],_aEmptrue[x,6],_aEmptrue[x,7],_aEmptrue[x,8],@_aEmpenh,@ lInclui,@_lempenh,@_lgeraemp)
						NMODULO:=28
						CMODULO:="TEC"
					EndIf
				Next
			Endif
		EndIf
	Else
		If _lnotprnz9 // Faz o apontamento, mesmo que não haja partnumber, ou seja faz apontamento só do aparelho a reformar
			_aAponOP   := {}
			SB1->(DBSeek(xFilial('SB1')+_cnewpro))
			If !SB2->(DBSeek(xFilial('SB2')+_cnewpro+left(carmproc,2)))
				U_saldoini(_cnewpro,left(carmproc,2))
			EndIf
			dbselectarea("SC2")
			dbsetorder(1)
			If SC2->(DBSeek(xFilial('SC2')+left(_cnumos,6)))  //Para garantir que a OP foi criada Edson Rodrigues 12/03/10
				U_SRAdApo(cmovprod,_cnewpro,SB1->B1_UM,left(_cnumos,6),left(carmproc,2),@_laponta,@_aAponOP,@lInclui,@_lgerapon,SPACE(6))
				NMODULO:=28
				CMODULO:="TEC"
				If !_laponta
					AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'ERRAPON-Erro Apont.O.Producao','Simule o encerramento novamente e envie o Erro ao HelpDesk',_cSeqZZ3})
					//apMsgStop("Processo Refurbish Sony - Houve Falha Encerramento da OP : "+AllTrim(LEFT(ZZ4->ZZ4_OS,6))+ " Favor verificar. Duvidas Contate o administrador do sistema. Falha no Encerramento da OP.")
					_lContinua:=.F.
				Endif
			Else
				_laponta :=.F.
				_lContinua:=.F.
				AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'ERRAPON-Nao encontrada a OP cadastrada ','Verifique o que ocorreu e  cadastre a OP manualmente ',_cSeqZZ3})
				If len(_aEmptrue) > 0
					For  x:=1 to len(_aEmptrue)
						dbselectarea("SD4")
						SD4->(dbsetorder(2))
						If SD4->(DBSeek(xFilial('SD4')+_aEmptrue[x,3]+_aEmptrue[x,1]+_aEmptrue[x,2]))
							lInclui:=.F.
							_lgeraemp:=.T.
							// Desabilitado função de exclusão de apontamento - Edson Rodrigues 20/03/10
							//U_SRAdEmp(_aEmptrue[x,1],_aEmptrue[x,2],_aEmptrue[x,3],_aEmptrue[x,5],_aEmptrue[x,6],_aEmptrue[x,7],_aEmptrue[x,8],@_aEmpenh,@lInclui,@_lempenh,@_lgeraemp)
							NMODULO:=28
							CMODULO:="TEC"
						EndIf
					Next
				Endif
			EndIf
		Else
			If len(_aEmptrue) > 0
				For  x:=1 to len(_aEmptrue)
					dbselectarea("SD4")
					SD4->(dbsetorder(2))
					If SD4->(DBSeek(xFilial('SD4')+_aEmptrue[x,3]+_aEmptrue[x,1]+_aEmptrue[x,2]))
						lInclui:=.F.
						_lgeraemp:=.T.
						// Desabilitado função de exclusão de apontamento - Edson Rodrigues 20/03/10
						//U_SRAdEmp(_aEmptrue[x,1],_aEmptrue[x,2],_aEmptrue[x,3],_aEmptrue[x,5],_aEmptrue[x,6],_aEmptrue[x,7],_aEmptrue[x,8],@_aEmpenh,@lInclui,@_lgeraemp)
						NMODULO:=28
						CMODULO:="TEC"
					EndIf
				Next
			Endif
			AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'ERREMPE-Erro Empenho das Pecas','Simule o encerramento novamente e envie o Erro ao HelpDesk',_cSeqZZ3})
			_laponta:=.F.
			// apMsgStop("Processo Refurbish Sony - Houve Falha no empenho das ?s da OP : "+AllTrim(LEFT(ZZ4->ZZ4_OS,6))+ " Favor empenhar a(s) peca(s) nao apontada(s). Duvidas Contate o administrador do sistema. Falha no apontamento.")
			_lContinua:=.F.
		EndIf
	EndIf
Else
	SB1->(DBSeek(xFilial('SB1')+_cnewpro))
	If !SB2->(DBSeek(xFilial('SB2')+_cnewpro+left(carmproc,2)))
		U_saldoini(_cnewpro,left(carmproc,2))
	EndIf
	_aAponOP   := {}
	dbselectarea("SC2")
	dbsetorder(1)
	If SC2->(DBSeek(xFilial('SC2')+left(_cnumos,6)))  //Para garantir que a OP foi criada Edson Rodrigues 12/03/10
		U_SRAdApo(cmovprod,_cnewpro,SB1->B1_UM,left(_cnumos,6),left(carmproc,2),@_laponta,@_aAponOP,@lInclui,_lgerapon,SPACE(6))
		NMODULO:=28
		CMODULO:="TEC"
		If !_laponta
			AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'ERRAPON-Erro Apont.O.Producao','Simule o encerramento novamente e envie o Erro ao HelpDesk',_cSeqZZ3})
			//apMsgStop("Processo Refurbish Sony - Houve Falha Encerramento da OP : "+AllTrim(LEFT(ZZ4->ZZ4_OS,6))+ " Favor verificar. Duvidas Contate o administrador do sistema. Falha no Encerramento da OP.")
			_lContinua:=.F.
			If len(_aEmptrue) > 0
				For  x:=1 to len(_aEmptrue)
					dbselectarea("SD4")
					SD4->(dbsetorder(2))
					If SD4->(DBSeek(xFilial('SD4')+_aEmptrue[x,3]+_aEmptrue[x,1]+_aEmptrue[x,2]))
						lInclui:=.F.
						_lgeraemp:=.T.
						// Desabilitado função de exclusão de apontamento - Edson Rodrigues 20/03/10
						//U_SRAdEmp(_aEmptrue[x,1],_aEmptrue[x,2],_aEmptrue[x,3],_aEmptrue[x,5],_aEmptrue[x,6],_aEmptrue[x,7],_aEmptrue[x,8],@_aEmpenh,@lInclui,@_lgeraemp)
						NMODULO:=28
						CMODULO:="TEC"
					EndIf
				Next
			Endif
		Endif
	Else
		_laponta :=.F.
		_lContinua:=.F.
		AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'ERRAPON-Nao encontrada a OP cadastrada ','Verifique o que ocorreu e  cadastre a OP manualmente ',_cSeqZZ3})
		If len(_aEmptrue) > 0
			For  x:=1 to len(_aEmptrue)
				dbselectarea("SD4")
				SD4->(dbsetorder(2))
				If SD4->(DBSeek(xFilial('SD4')+_aEmptrue[x,3]+_aEmptrue[x,1]+_aEmptrue[x,2]))
					lInclui:=.F.
					_lgeraemp:=.T.
					// Desabilitado função de exclusão de apontamento - Edson Rodrigues 20/03/10
					//U_SRAdEmp(_aEmptrue[x,1],_aEmptrue[x,2],_aEmptrue[x,3],_aEmptrue[x,5],_aEmptrue[x,6],_aEmptrue[x,7],_aEmptrue[x,8],@_aEmpenh,@lInclui,@_lempenh,@_lgeraemp)
					NMODULO:=28
					CMODULO:="TEC"
				EndIf
			Next
		Endif
	EndIf
Endif
If _laponta
	_atransp   := {}
	_nPosBar := at("/",aCols[_ni,_nPosFaseO])
	_nPosBar := iif(_nPosBar > 0, _nPosBar - 1, len(aCols[_ni,_nPosFaseO]) )
	_cFaseenc:=AllTrim(left(aCols[_ni,_nPosFaseO], _nPosBar - 1 ))
	nTdocD3  := TAMSX3("D3_DOC")[1]
	_cdocd3  := LEFT(ZZ4->ZZ4_OS,6)+SPACE(nTdocD3-len(LEFT(ZZ4->ZZ4_OS,6)))
	
	If left(_cFaseenc,2) $ _cfascrap
		If !SB2->(DBSeek(xFilial('SB2')+_cnewpro+left(carmscrap,2)))
			U_saldoini(_cnewpro,left(carmscrap,2))
		EndIf
	Endif
	
	U_SRAdtrans(_cnewpro,left(carmproc,2),_cdocd3,_cnewpro,iif(left(_cFaseenc,2)$ _cfascrap,left(carmscrap,2),left(carmpacab,2)),@_atransp,@ltransf,@lInclui,@_lgertrans,0,0,IIf(_nqtde<=0,1,_nqtde))
	NMODULO:=28
	CMODULO:="TEC"
	If !ltransf
		AADD(_aNotEmp,{_cnewpro,_cpeca,left(carmpeca,2),left(_cnumos,6),ZZ4->ZZ4_IMEI,SB2->B2_QATU,SBF->BF_QUANT,IIf(!Empty(SBF->BF_LOCALIZ),.T.,.F.),'ERRAPON-na Transferencia do armaz. Producao p/ armaz. Prod. Acabado','Simule o encerramento novamente e envie o Erro ao HelpDesk',_cSeqZZ3})
		//apMsgStop("Processo Refurbish Sony - Houve Falha Encerramento da OP : "+AllTrim(LEFT(ZZ4->ZZ4_OS,6))+ " Favor verificar. Duvidas Contate o administrador do sistema. Falha no Encerramento da OP.")
		_lContinua:=.F.
	EndIf
Endif
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA09 º Autor ³Paulo Lopez         º Data ³  29/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS CONFORME PARAMETROS DETERMINADOS            º±±
±±º          ³SPC0000433 - PERIODO DE 15 A 20 MESES                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CONSGA09(_NumImei,_NumOS)

Local _cQry
Local _cQry1
Local _cQry2
Local _cQryExec
Local _cQryGaran
Local _ExecQry

Private _lspc433    := .T.
Private _cSpr		:= GetMv("MV_SPC0433") 				 // Aparelhos Parametrizados para Especifico SPC0000433 - Motorola
Private _cPsq		:= GetMv("MV_PERSPC3") 				 // Periodo Parametrizados para Especifico SPC0000433 - Motorola
Private _cSps		:= GetMv("MV_DTFSPC1") 				 // Data Final Parametrizados para Especifico SPC0000433 - Motorola
Private _cSpf		:= GetMv("MV_PRFOUND")				 // Problem Found para SPC0000433 - Motorola
Private _cnotdefc   := GetMv("MV_NOTDEFC")

IF date() >= ctod('03/01/12')
	_cPsq     := GetMv("MV_PERTIXT")  //Periodo parametricado para aparelhos que constam no MV_SPC0433 e que ultilizam o transaction code especial IXT. Edson Rodrigues 29/12/12.
	_cSpx	 := GetMv("MV_DTFTIXT")
	_lspc433  := .F.
ENDIF


If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf

_cQry	:=" SELECT ZZ4.ZZ4_CODCLI CODCLI, ZZ4.ZZ4_LOJA LOJA, ZZ4.ZZ4_NFENR NFE, ZZ4.ZZ4_NFESER SERIE, ZZ4.ZZ4_IMEI IMEI, ZZ4.ZZ4_NFEDT DTENTRA,ZZ4.ZZ4_CODPRO COD, ZZ4.ZZ4_CARCAC CARCAC, ZZ4.ZZ4_OS ORDSERV, ZZ4.ZZ4_GARANT GARANT, SZA.ZA_DEFRECL DEFEITO, ZZ4.ZZ4_PROBLE PFOUND, ZZ4.ZZ4_TRANSC TRANSC,  "
_cQry	+="	(SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	  "
_cQry	+="	(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' GARACARC, "
_cQry	+="		DATEDIFF(MONTH, (SELECT RTRIM(X5_DESCRI) FROM " + RetSqlName("SX5") + " WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	  "
_cQry	+="				(SELECT LEFT(X5_DESCRI,2) FROM " + RetSqlName("SX5") + " WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' ,ZZ4.ZZ4_NFEDT) MES_GARA  "
_cQry	+=" FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock) "
_cQry	+=" LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock) "
_cQry	+=" ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI "
_cQry	+=" AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_) "
_cQry	+=" WHERE ZZ4.D_E_L_E_T_ = '' "
_cQry	+=" AND ZZ4.ZZ4_IMEI = '"+_NumImei+"' "
_cQry	+=" AND ZZ4.ZZ4_OS = '"+_NumOs+"' "

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY1", .F., .T.)


_cDef	:= "SELECT ZZG_RECCLI RECCLI FROM " + RetSqlName("ZZG") + " WHERE D_E_L_E_T_ = '' AND ZZG_LAB = 2 AND ZZG_CODIGO = '"+Left(AllTrim(QRY1->DEFEITO),5)+"' "

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cDef), "QRY3", .F., .T.)


If Alltrim(QRY1->GARANT) == 'N' .And. AllTrim(QRY1->COD) $ _cSpr .And. Transform (QRY1->MES_GARA, "@E 99") $ _cPsq .And. AllTrim(QRY1->GARACARC) <= _cSpx .And.  IIF(_lspc433,AllTrim(QRY1->PFOUND) $ _cSpf, Iif (!Empty(QRY3->RECCLI), AllTrim(QRY3->RECCLI) <> 'C0022', .F.))
	
	_cQry1	:=" SELECT ZA_CLIENTE CLIENTE "
	_cQry1	+=" FROM " + RetSqlName("SZA") + " SZA (nolock) "
	_cQry1	+=" WHERE ZA_CLIENTE = '"+QRY1->CODCLI+"' "
	_cQry1	+=" AND ZA_LOJA = '"+QRY1->LOJA+"' "
	_cQry1	+=" AND ZA_NFISCAL = '"+QRY1->NFE+"' "
	_cQry1	+=" AND ZA_SERIE = '"+QRY1->SERIE+"' "
	_cQry1	+=" AND ZA_IMEI = '"+QRY1->IMEI+"' "
	_cQry1	+=" AND ZA_STATUS = 'V' "
	_cQry1	+=" AND D_E_L_E_T_ = '' "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry1), "QRY2", .F., .T.)
	
	If Empty(QRY2->CLIENTE)
		
		RecLock("SZA",.T.)
		
		SZA->ZA_FILIAL 	:= "02"
		SZA->ZA_CLIENTE	:= QRY1->CODCLI
		SZA->ZA_LOJA 	:= QRY1->LOJA
		SZA->ZA_NFISCAL	:= QRY1->NFE
		SZA->ZA_SERIE 	:= QRY1->SERIE
		SZA->ZA_IMEI 	:= QRY1->IMEI
		SZA->ZA_CODPRO 	:= QRY1->COD
		SZA->ZA_STATUS 	:= "V"
		SZA->ZA_SPC 	:= iif(_lspc433,"SPC0000433","")
		SZA->ZA_EXECAO	:= "S"
		
		msunlock()
		
	Else
		cQryExec := " UPDATE " + RetSqlName("SZA")
		if _lspc433
			cQryExec += " SET ZA_SPC = 'SPC0000433', ZA_EXECAO = 'S', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + _center "
		Else
			cQryExec += " SET ZA_EXECAO = 'S', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + _center
		Endif
		cQryExec += " WHERE ZA_CLIENTE = '"+QRY1->CODCLI+"' "
		cQryExec += " AND ZA_LOJA = '"+QRY1->LOJA+"' "
		cQryExec += " AND ZA_NFISCAL = '"+QRY1->NFE+"' "
		cQryExec += " AND ZA_SERIE = '"+QRY1->SERIE+ "' "
		cQryExec += " AND ZA_IMEI = '"+QRY1->IMEI+"' "
		
		TcSQlExec(cQryExec)
		TCRefresh(RETSQLNAME("SZA"))
	EndIf
	/*
	_cQryGaran := " UPDATE  " + RetSqlName("ZZ4")
	if _lspc433
		_cQryGaran += " SET ZZ4_GARANT = 'S', ZZ4_TRANSC = 'IRF' "
	else
		_cQryGaran += " SET ZZ4_GARMCL = 'S', ZZ4_TRANSC = 'IXT' "
	endif
	_cQryGaran += " WHERE ZZ4_CODCLI = '"+QRY1->CODCLI+ "' "
	_cQryGaran += " AND ZZ4_LOJA = '"+QRY1->LOJA+"' "
	_cQryGaran += " AND ZZ4_IMEI = '"+QRY1->IMEI+"' "
	_cQryGaran += " AND ZZ4_CARCAC = '"+QRY1->CARCAC+"' "
	_cQryGaran += " AND ZZ4_OS  = '"+QRY1->ORDSERV+"' "
	_cQryGaran += " AND ZZ4_STATUS < '8' "
	
	TcSQlExec(_cQryGaran)
	TCRefresh(RETSQLNAME("ZZ4"))
	*/
EndIf

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PROREPA  º Autor ³Paulo Lopez         º Data ³  18/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS DEFEITO INFORMADO PELO CLIENTE              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PROREPA(cImei,cOs,cLab)

Local   cQryExec
Local  _cQryExec
Local   cQryExec1
Local  _cQryExec1
Local 	cProble
Local 	cReparo
Local _aAreaZZ4  := ZZ4->(GetArea())

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf
If Select("QRY4") > 0
	QRY4->(dbCloseArea())
EndIf
If Select("QRY5") > 0
	QRY5->(dbCloseArea())
EndIf
If Select("QRY6") > 0
	QRY6->(dbCloseArea())
EndIf
If Select("QRY7") > 0
	QRY7->(dbCloseArea())
EndIf
If Select("QRY8") > 0
	QRY8->(dbCloseArea())
EndIf

cQryExec	:= "SELECT TOP 1 ZL_CODIGO REPA " + _center
cQryExec	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + _center
cQryExec	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + _center
cQryExec	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODSINT AND Z3.ZZ3_ACAO = ZL.ZL_CODREPA AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + _center
cQryExec	+= "WHERE Z3.D_E_L_E_T_ = '' " + _center
cQryExec	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + _center
cQryExec	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + _center
cQryExec	+= "AND Z3.ZZ3_DEFDET <> '' " + _center
cQryExec	+= "AND Z3.ZZ3_ACAO <> '' " + _center
cQryExec	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + _center
cQryExec	+= "AND Z3.ZZ3_ESTORN <> 'S' " + _center
cQryExec	+= "AND Z3.ZZ3_STATUS = '1' " + _center
cQryExec	+= "AND ZL.ZL_CODPROB <> 'P0021' " + _center
cQryExec	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + _center
cQryExec	+= "AND ZL.ZL_MSBLQL != '1' " + _center
cQryExec	+= "ORDER BY ZL.ZL_GRAU DESC " + _center

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryExec), "QRY1", .F., .T.)

cQryExec1	:= "SELECT TOP 1 ZL.ZL_CODPROB PROB " + _center
cQryExec1	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + _center
cQryExec1	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + _center
cQryExec1	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODSINT AND Z3.ZZ3_ACAO = ZL.ZL_CODREPA AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + _center
cQryExec1	+= "WHERE Z3.D_E_L_E_T_ = '' " + _center
cQryExec1	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + _center
cQryExec1	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + _center
cQryExec1	+= "AND Z3.ZZ3_DEFDET <> '' " + _center
cQryExec1	+= "AND Z3.ZZ3_ACAO <> '' " + _center
cQryExec1	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + _center
cQryExec1	+= "AND Z3.ZZ3_ESTORN <> 'S' " + _center
cQryExec1	+= "AND Z3.ZZ3_STATUS = '1' " + _center
cQryExec1	+= "AND ZL.ZL_CODIGO = '"+QRY1->REPA+"' " + _center
cQryExec1	+= "AND ZL.ZL_CODPROB <> 'P0021' " + _center
cQryExec1	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + _center
cQryExec1	+= "AND ZL.ZL_MSBLQL != '1' " + _center
cQryExec1	+= "ORDER BY Z3.R_E_C_N_O_ " + _center

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryExec1), "QRY2", .F., .T.)

If Len(AllTrim(QRY1->REPA))>0
	cproblem 	:= QRY2->PROB
	creparo		:= QRY1->REPA
Else
	
	_cQryExec	:= "SELECT TOP 1 ZL_CODIGO REPA " + _center
	_cQryExec	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + _center
	_cQryExec	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + _center
	_cQryExec	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODSINT AND Z3.ZZ3_ACAO = ZL.ZL_CODREPA AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + _center
	_cQryExec	+= "WHERE Z3.D_E_L_E_T_ = '' " + _center
	_cQryExec	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + _center
	_cQryExec	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + _center
	_cQryExec	+= "AND Z3.ZZ3_DEFDET <> '' " + _center
	_cQryExec	+= "AND Z3.ZZ3_ACAO <> '' " + _center
	_cQryExec	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + _center
	_cQryExec	+= "AND Z3.ZZ3_ESTORN <> 'S' " + _center
	_cQryExec	+= "AND Z3.ZZ3_STATUS = '1' " + _center
	_cQryExec	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + _center
	_cQryExec	+= "AND ZL.ZL_MSBLQL != '1' " + _center
	_cQryExec	+= "ORDER BY ZL.ZL_GRAU DESC " + _center
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQryExec), "QRY3", .F., .T.)
	
	_cQryExec1	:= "SELECT TOP 1 ZL.ZL_CODPROB PROB " + _center
	_cQryExec1	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + _center
	_cQryExec1	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + _center
	_cQryExec1	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODSINT AND Z3.ZZ3_ACAO = ZL.ZL_CODREPA AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + _center
	_cQryExec1	+= "WHERE Z3.D_E_L_E_T_ = '' " + _center
	_cQryExec1	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + _center
	_cQryExec1	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + _center
	_cQryExec1	+= "AND Z3.ZZ3_DEFDET <> '' " + _center
	_cQryExec1	+= "AND Z3.ZZ3_ACAO <> '' " + _center
	_cQryExec1	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + _center
	_cQryExec1	+= "AND Z3.ZZ3_ESTORN <> 'S' " + _center
	_cQryExec1	+= "AND Z3.ZZ3_STATUS = '1' " + _center
	_cQryExec1	+= "AND ZL.ZL_CODIGO = '"+QRY3->REPA+"' " + _center
	_cQryExec1	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + _center
	_cQryExec1	+= "AND ZL.ZL_MSBLQL != '1' " + _center
	_cQryExec1	+= "ORDER BY Z3.R_E_C_N_O_ " + _center
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQryExec1), "QRY4", .F., .T.)
	
	cproblem 	:= 	QRY4->PROB
	creparo		:=	QRY3->REPA
	
EndIf

If Empty(AllTrim(cproblem)) .And. Empty(AllTrim(creparo))
	
	cQryExec	:= "SELECT TOP 1 ZL_CODIGO REPA " + _center
	cQryExec	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + _center
	cQryExec	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + _center
	cQryExec	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODPROB AND Z3.ZZ3_ACAO = ZL.ZL_CODIGO AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + _center
	cQryExec	+= "WHERE Z3.D_E_L_E_T_ = '' " + _center
	cQryExec	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + _center
	cQryExec	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + _center
	cQryExec	+= "AND Z3.ZZ3_DEFDET <> '' " + _center
	cQryExec	+= "AND Z3.ZZ3_ACAO <> '' " + _center
	cQryExec	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + _center
	cQryExec	+= "AND Z3.ZZ3_ESTORN <> 'S' " + _center
	cQryExec	+= "AND Z3.ZZ3_STATUS = '1' " + _center
	cQryExec	+= "AND ZL.ZL_CODPROB <> 'P0021' " + _center
	cQryExec	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + _center
	cQryExec	+= "AND ZL.ZL_MSBLQL != '1' " + _center
	cQryExec	+= "ORDER BY ZL.ZL_GRAU DESC " + _center
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryExec), "QRY5", .F., .T.)
	
	cQryExec1	:= "SELECT TOP 1 ZL.ZL_CODPROB PROB " + _center
	cQryExec1	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + _center
	cQryExec1	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + _center
	cQryExec1	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODPROB AND Z3.ZZ3_ACAO = ZL.ZL_CODIGO AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + _center
	cQryExec1	+= "WHERE Z3.D_E_L_E_T_ = '' " + _center
	cQryExec1	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + _center
	cQryExec1	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + _center
	cQryExec1	+= "AND Z3.ZZ3_DEFDET <> '' " + _center
	cQryExec1	+= "AND Z3.ZZ3_ACAO <> '' " + _center
	cQryExec1	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + _center
	cQryExec1	+= "AND Z3.ZZ3_ESTORN <> 'S' " + _center
	cQryExec1	+= "AND Z3.ZZ3_STATUS = '1' " + _center
	cQryExec1	+= "AND ZL.ZL_CODIGO = '"+QRY5->REPA+"' " + _center
	cQryExec1	+= "AND ZL.ZL_CODPROB <> 'P0021' " + _center
	cQryExec1	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + _center
	cQryExec1	+= "AND ZL.ZL_MSBLQL != '1' " + _center
	cQryExec1	+= "ORDER BY Z3.R_E_C_N_O_ " + _center
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryExec1), "QRY6", .F., .T.)
	
	If Len(AllTrim(QRY5->REPA))>0
		cproblem 	:= QRY6->PROB
		creparo		:= QRY5->REPA
	Else
		
		_cQryExec	:= "SELECT TOP 1 ZL_CODIGO REPA " + _center
		_cQryExec	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + _center
		_cQryExec	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + _center
		_cQryExec	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODPROB AND Z3.ZZ3_ACAO = ZL.ZL_CODIGO AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + _center
		_cQryExec	+= "WHERE Z3.D_E_L_E_T_ = '' " + _center
		_cQryExec	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + _center
		_cQryExec	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + _center
		_cQryExec	+= "AND Z3.ZZ3_DEFDET <> '' " + _center
		_cQryExec	+= "AND Z3.ZZ3_ACAO <> '' " + _center
		_cQryExec	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + _center
		_cQryExec	+= "AND Z3.ZZ3_ESTORN <> 'S' " + _center
		_cQryExec	+= "AND Z3.ZZ3_STATUS = '1' " + _center
		_cQryExec	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + _center
		_cQryExec	+= "AND ZL.ZL_MSBLQL != '1' " + _center
		_cQryExec	+= "ORDER BY ZL.ZL_GRAU DESC " + _center
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQryExec), "QRY7", .F., .T.)
		
		_cQryExec1	:= "SELECT TOP 1 ZL.ZL_CODPROB PROB " + _center
		_cQryExec1	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + _center
		_cQryExec1	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + _center
		_cQryExec1	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODPROB AND Z3.ZZ3_ACAO = ZL.ZL_CODIGO AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + _center
		_cQryExec1	+= "WHERE Z3.D_E_L_E_T_ = '' " + _center
		_cQryExec1	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + _center
		_cQryExec1	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + _center
		_cQryExec1	+= "AND Z3.ZZ3_DEFDET <> '' " + _center
		_cQryExec1	+= "AND Z3.ZZ3_ACAO <> '' " + _center
		_cQryExec1	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + _center
		_cQryExec1	+= "AND Z3.ZZ3_ESTORN <> 'S' " + _center
		_cQryExec1	+= "AND Z3.ZZ3_STATUS = '1' " + _center
		_cQryExec1	+= "AND ZL.ZL_CODIGO = '"+QRY7->REPA+"' " + _center
		_cQryExec1	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + _center
		_cQryExec1	+= "AND ZL.ZL_MSBLQL != '1' " + _center
		_cQryExec1	+= "ORDER BY Z3.R_E_C_N_O_ " + _center
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQryExec1), "QRY8", .F., .T.)
		
		cproblem 	:= 	QRY8->PROB
		creparo		:=	QRY7->REPA
		
	EndIf
	
EndIf

/* Ticket 5227 - M.Munhoz - 10/04/12
Esta parte do programa foi comentada porque a funcao sera executada apos a gravacao do ZZ3, portanto as variaveis abaixo nao estarao mais disponiveis
e nem seriam necessarias.

If Len(AllTrim(cproblem)) < 1
	
	cproblem 	:= 	Iif("/" $ DEFDET,left(ALLTRIM(DEFDET),AT("/",ALLTRIM(DEFDET))-1),ALLTRIM(DEFDET))
	creparo		:=	SOLUCAO
	
EndIf
*/
If !Empty(AllTrim(cproblem)) .And. !Empty(AllTrim(creparo))
	
	
	_cQryReapir := " UPDATE  " + RetSqlName("ZZ4") + _center
	_cQryReapir += " SET ZZ4_PROBLE = '" + AllTRim(cproblem) + "', ZZ4_REPAIR = '" + AllTrim(creparo)+ "' " + _center
	_cQryReapir += " WHERE D_E_L_E_T_ = '' " +  _center
	_cQryReapir += " AND ZZ4_IMEI = '" + cimei + "' " + _center
	_cQryReapir += " AND ZZ4_OS  = '" + Left(cos,6) + "' " + _center
	
	TcSQlExec(_cQryReapir)
	TCRefresh(RETSQLNAME("ZZ4"))
	
EndIf

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf
If Select("QRY4") > 0
	QRY4->(dbCloseArea())
EndIf
If Select("QRY5") > 0
	QRY5->(dbCloseArea())
EndIf
If Select("QRY6") > 0
	QRY6->(dbCloseArea())
EndIf
If Select("QRY7") > 0
	QRY7->(dbCloseArea())
EndIf
If Select("QRY8") > 0
	QRY8->(dbCloseArea())
EndIf

RestArea(_aAreaZZ4)

Return(cproblem,creparo)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NumEtq    º Autor ³Paulo Lopez         º Data ³  11/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Consulta Numero Etiqueta Master                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function NumEtq(_coperac,_clab,ctipo,_cmodetq)

Local cQry
Local cQryd
Local nEtQt
Local dDate := Dtos(dDataBase)
local cano  := substr(dDate,3,2)
local cdate := _clab+'0'+cano+substr(dDate,5,4)



If Select("QRYX") > 0
	QRYX->(dbCloseArea())
EndIf

/*
cQry	:= " SELECT TOP 1 R_E_C_N_O_ REC, ZZ4_ETQMAS + 1 ETQ1 "
cQry	+= " FROM " + RetSqlname("ZZ4") + " ZZ4 (NOLOCK) "
cQry	+= " WHERE D_E_L_E_T_ = '' "
cQry	+= " AND ZZ4_ETQMAS > 0 "
cQry	+= " AND ZZ4_ETQMAS >= '" + dDate +"' + '0001' "
cQry	+= " ORDER BY ZZ4_ETQMAS DESC "
*/


cQry	:= " SELECT TOP 1 R_E_C_N_O_ REC, ZZU_ETQMAS + 1 ETQ1 "
cQry	+= " FROM " + RetSqlname("ZZU") + " ZZU (NOLOCK) "
cQry	+= " WHERE ZZU_FILIAL='"+ XFILIAL("ZZU")+ "' AND D_E_L_E_T_ = '' "
cQry	+= " AND ZZU_ETQMAS > 0 "
If _cmodetq=="1"
	cQry	+= " AND ZZU_ETQMAS >= '" + dDate +"' + '0001' "
Elseif _cmodetq=="2"
	cQry	+= " AND ZZU_ETQMAS >= " + cdate +" + 0001 "
Endif
cQry	+= " AND ZZU_OPERAC IN "
cQry    += " (SELECT ZZJ_OPERA FROM  " + RetSqlname("ZZJ") + " WHERE ZZJ_FILIAL='"+ XFILIAL("ZZJ")+ "' AND ZZJ_LAB='"+_clab+"' AND ZZJ_IMETQM='S') "
cQry	+= " ORDER BY ZZU_ETQMAS DESC "

//MemoWrite("c:\axzz3.1.sql", cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRYX", .F., .T.)

If !Empty(QRYX->ETQ1)
	nEtQt := QRYX->ETQ1
	reclock("ZZU",.T.)
	ZZU->ZZU_FILIAL := XFILIAL("ZZU")
	ZZU->ZZU_OPERAC := _coperac
	ZZU->ZZU_DATA   := dDataBase
	ZZU->ZZU_TIPO   := ctipo
	ZZU->ZZU_ETQMAS := nEtQt
	msunlock()
	
Else
	If _cmodetq=="1"
		nEtQt  := dDate += '0001'
	Elseif _cmodetq=="2"
		nEtQt  := cDate += '0001'
	Endif
	reclock("ZZU",.T.)
	ZZU->ZZU_FILIAL := XFILIAL("ZZU")
	ZZU->ZZU_OPERAC := _coperac
	ZZU->ZZU_DATA   := dDataBase
	ZZU->ZZU_TIPO   := ctipo
	ZZU->ZZU_ETQMAS := val(nEtQt)
	msunlock()
	IF left(time(),2) > "06"
		cQryd	:= " DELETE " + RetSqlname("ZZU") + " "
		cQryd	+= " WHERE D_E_L_E_T_ = '' "
		cQryd	+= " AND ZZU_ETQMAS > 0 "
		If _cmodetq=="1"
			cQryd	+= " AND ZZU_ETQMAS < '" + dDate +"' "
		Elseif  _cmodetq=="2"
			cQryd	+= " AND ZZU_ETQMAS < '" + cDate +"' "
		Endif
		cQryd	+= " AND ZZU_OPERAC IN "
		cQryd   += " (SELECT ZZJ_OPERA FROM  " + RetSqlname("ZZJ") + " WHERE ZZJ_FILIAL='"+ XFILIAL("ZZJ")+ "' AND ZZJ_LAB='"+_clab+"' AND ZZJ_IMETQM='S') "
		
		tcSqlExec(cQryd)
		TCREFRESH(RETSQLNAME("ZZU"))
		
	ENDIF
Endif

If Select("QRYX") > 0
	QRYX->(dbCloseArea())
EndIf

Return(nEtQt)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONSGA    º Autor ³Paulo Lopez         º Data ³  13/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³CADASTROS PARA MENU DINAMICO                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MENU()

Private cPerg       := "AXZZ3"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Cria dicionario de perguntas                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return
Endif

Do Case
	
	Case mv_par01 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|Modulo para Administradores                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lUsrAdmi  := .T.
		
	Case mv_par01 == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|Modulo para Administradores											³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lUsrAdmi  := .F.
		
EndCase
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FVLDDOC  º Autor ³Eduardo Barbosa      º Data ³  19/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Valida Digitacao Documento de Separacao                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FvldDoc()

Local _aArea	:= GetArea()
Local _lRet	    := .T.

_cSetAtu := LEFT(CODSET,6)
_cFasAtu := LEFT(FAS1,2)
_cSetDes := LEFT(CODSE2,6)
_cFasDes := LEFT(FAS2,2)
_cDocObAt:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + _cSetAtu + _cFasAtu + SPACE(04),"ZZ1_DOCSEP")  
_cDocObDe:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + _cSetDes + _cFasDes + SPACE(04),"ZZ1_DOCSEP")  
If _cDocObAt == "S"  .AND. _cDocObDe == "S" 
	DbSelectArea("ZZY")  // Tabela de Planejamento da Producao
	DbSetOrder(1)  // ZZY_FILIAL, ZZY_NUMDOC, ZZY_CODPLA, ZZY_NUMMAS, ZZY_CODMAS
	If ! DbSeek(xFilial("ZZY")+_cNumDoc,.F.)
	    apMsgStop("Numero do Documento Invalido")
		_lRet := .F.
	Endif
Else
    MsgAlert("Esta Operacao Nao Necessita de Documento de Planejamento")
    _cNumDoc := Space(9)
Endif

RestArea(_aArea)

Return _lRet



Static Function FDigDoc()

Local _lRetDig := .F.

_cSetAtu := LEFT(CODSET,6)
_cFasAtu := LEFT(FAS1,2)
_cSetDes := LEFT(CODSE2,6)
_cFasDes := LEFT(FAS2,2)
_cDocObAt:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + _cSetAtu + _cFasAtu + SPACE(04),"ZZ1_DOCSEP")  
_cDocObDe:= Posicione("ZZ1",1,xFilial("ZZ1") + LAB + _cSetDes + _cFasDes + SPACE(04),"ZZ1_DOCSEP")  
If _cDocObAt == "S"  .AND. _cDocObDe == "S" 
   _lRetDig := .F.
Endif

Return _lRetDig


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FCRIASX1  º Autor ³Paulo Lopez         º Data ³  08/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³GERA DICIONARIO DE PERGUNTAS                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCriaSX1()

dbSelectArea("SX1")
dbSetOrder(1)
aSX1 := {}

aAdd(aSx1,{cPerg,"01","Qual Empresa ? ","","","mv_ch1","N",01,0,0,"C","","mv_par01","Nextel/Motorola","","","","","Sony","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega as Perguntas no SX1                                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
ValidPerg(aSX1,cPerg)

Return

User Function DigitaRST()

Private ocReset
Private oDlgCli                                  
cReset := SPACE(2)

DEFINE MSDIALOG oDlgCli TITLE "Quantidade de Resets" FROM C(306),C(324) TO C(400),C(450) PIXEL

@ C(015),C(004) Say "Qtde. de Resets" Size C(080),C(008) COLOR CLR_BLACK PIXEL OF oDlgCli
@ C(014),C(037) MsGet ocReset Var cReset PICT "99" valid VerQtRes() Size C(010),C(009) COLOR CLR_BLACK PIXEL OF oDlgCli
DEFINE SBUTTON FROM C(030),C(025) TYPE 1 ENABLE OF oDlgCli ACTION (odlgcli:end())

ACTIVATE MSDIALOG oDlgCli CENTERED

Return(.T.)

                                                                       
Static Function VerQtRes()
	if  len(alltrim(M->cReset)) == 0
		msgalert ("A Quantidade de Resets deve ser informada. Favor Verificar")
		return .F.
	endif          
	return .T.


User Function filtrazzg()
	if LAB == '5'                    
		if  ZZG->ZZG_LAB=='5' .and. ZZG->ZZG_DEFDET == '1'
			return .T.
		else
			return .F.  
		endif	
	else
		if  ZZG->ZZG_LAB==LAB .and. ZZG->ZZG_DEFDET <> '1
			return .T.
		else
			return .F.  
		endif			
	endif


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MOTSCRAP ºAutor  ³ M.Munhoz           º Data ³  07/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aponta motivo do Scrap                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function MotScrap()

local _cMotScrap := space(6)
local aTabela := {}
local oDlg := NIL
local oLbx := NIL
local _aAreaZZ1 := ZZ1->(getarea())

_copbgh :=Posicione("ZZJ",2,xFilial("ZZJ")+LAB, "ZZJ_OPERA")

// Alimenta array com Motivos de Scrap
dbSelectArea("ZZX")
if ZZX->(dbSeek(xFilial("ZZX")+_copbgh))
	While ZZX->(!Eof()) .and. ZZX->ZZX_FILIAL == xFilial("ZZX") .and. ZZX->ZZX_OPERAC == _copbgh
		aAdd(aTabela,{ZZX->ZZX_CODSCR,ZZX->ZZX_SCRAP, iif(ZZX->ZZX_RESPON=='1', 'BGH', 'CLIENTE')})
		ZZX->(dbSkip())
	EndDo
endif

// Avisa sobre tabela vazia caso aconteca
If Len(aTabela) == 0
	Aviso( "Cadastro de Scrap vazio", "Não foi encontrado nenhum motivo de Scrap cadastrado no sistema. Favor contatar o administrador do sistema.", {"Ok"} )
	Return
Endif

// Apresenta tela com motivos de Scrap
DEFINE MSDIALOG oDlg TITLE "Motivos de SCRAP" FROM 300,400 TO 540,900 PIXEL
@ 10,10 LISTBOX oLbx VAR nChave FIELDS HEADER "Código", "Descrição", "Responsabilidade"  SIZE 230,095 OF oDlg PIXEL
oLbx:SetArray( aTabela )
oLbx:bLine := {|| {aTabela[oLbx:nAt,1],aTabela[oLbx:nAt,2],aTabela[oLbx:nAt,3]} }

DEFINE SBUTTON FROM 107,183 TYPE  1 ACTION (_cMotScrap := aTabela[oLbx:nAt,1],oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 107,213 TYPE  2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg

restarea(_aAreaZZ1)
return(_cMotScrap)



/*
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : BrowSZ9				| 	Abril de 2012																		|
|-------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																				|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descrição : Tela com visualização de histórico da SZ9														  	|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
*/
Static Function BrowSZ9(cImeiHist)
	local aTabela := {}
	local oDlgl := NIL
	local oLbx := NIL
	Private aDados

	_cqry :=	"SELECT ZZ4_OS FROM " + retSqlName("ZZ4") + " AS ZZ4 WHERE ZZ4_IMEI = '" + cImeiHist + "' AND D_E_L_E_T_ <> '*' AND ZZ4_STATUS <> '9'"
	TCQUERY _cqry ALIAS "TFB" 
	dbSelectArea("ZZ4")
	dbSetOrder(1)
	dbSeek(xFilial("ZZ4")+cImeiHist+TFB->ZZ4_OS)
	                            
	U_TECA19SCR()
	TFB->(dbCloseArea())             
	
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMPFABRICºAutor  ³ M.Munhoz           º Data ³  26/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calculo do Tempo de Fabricacao                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function TmpFabric(_cCarcaca, _cEntrDoca)

local _cTmpFabric := ""
local _cCodAno    := substr(_cCarcaca,5,1)
local _cCodMes    := substr(_cCarcaca,6,1)
local _cAno       := alltrim(Tabela("WC",_cCodAno))
local _cMes       := left(Tabela("WD",_cCodMes),2)
local _cDtFabr    := _cAno + _cMes + "01"

if select("TFB") > 0
	TFB->(dbCloseArea())
endif

_cCalcTFab := "SELECT TMPFABR = DATEDIFF(MONTH , '"+_cDtFabr+"', '"+_cEntrDoca+"')"

TCQUERY _cCalcTFab ALIAS "TFB" NEW

_cTmpFabric := TFB->TMPFABR
TFB->(dbCloseArea())

return(_cTmpFabric)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DEFTRANS ºAutor  ³ M.Munhoz           º Data ³  26/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao exclusiva para definir o Transaction e a Garantia   º±±
±±º          ³ MCLAIM.                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function DefTrans(_cOpeBGH, _cGarant, _cRecCli, _cCodPro, _cSPC, _cZZ3Trans, _lSwap, _cSolucao, _cZZ4Trans, _cCarcac, _dDocDtE, _cDefInf)

local _cTrans   := "XXX"
local _cGarMCL  := "X"
local _aReturn  := {}
local _aAreaZZJ := ZZJ->(getarea())
local _cSPC433  := getmv("MV_SPC0433")
local _cPerSPC3 := getmv("MV_PERTIXT")
local _cOrcMCL  := getmv("MV_XORCMCL")
local _cFasOrc  := alltrim(CODSETORI) + alltrim(FAS1Ori) + alltrim(CODSE2ORI) + alltrim(FAS2Ori)

ZZJ->(dbSetOrder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
if ZZJ->(dbSeek(xFilial("ZZJ") + _cOpeBGH + "2")) .and. ZZJ->ZZJ_INFTCM == "S"

	// Trasaction Code FIXO
	// Atende atualmente as operacoes N03 / N05 / N06 / N07
	if ZZJ->ZZJ_TRAFIX == "S"
		_cTrans := ZZJ->ZZJ_CODTRF

	// Trasaction Code NAO FIXO = MANUAL
	// Atende atualmente as operacoes N02 / N04
	elseif ZZJ->ZZJ_TRAFIX == "N"
		// Grava variavel com o conteudo digitado
		_cTrans := iif(!empty(_cZZ3Trans), _cZZ3Trans, _cZZ4Trans)
		// Excecoes para a operacao N02 - Nextel Retail Nextel
		if ZZJ->ZZJ_OPERA == "N02" 
			if _cTrans <> "IOW" .and. _cFasOrc $ _cOrcMCL // Fases de Orcamento
				_cTrans := "IOW"
			elseif _cTrans == "IOW" .and. !empty(_cSPC)
				_cTrans := "ITS"
			endif
		// Excecoes para a operacao N04 - Nextel Varejo Lojas DOA
		elseif ZZJ->ZZJ_OPERA == "N04" 
			if _cTrans <> "IOW" .and. _cFasOrc $ _cOrcMCL // Fases de Orcamento
				_cTrans := "IOW"
			elseif _cGarant == "S" .and. _lSwap .and. _cSolucao == "R0034" // Fast Shop
				_cTrans := "IFS"
			elseif _cGarant == "N" .and. !empty(_cSPC)
				_cTrans := "IER"
			endif
		endif

	// Trasaction Code Condicional a Garantia
	// Atende atualmente as operacoes N01 / N08 / N09 / N10 / N11
	elseif ZZJ->ZZJ_TRAFIX == "C"
		if _cGarant == "S" .and. !empty(_cRecCli) .and. _cRecCli <> "C0022"
			_cTrans := ZZJ->ZZJ_CODTRF
//		elseif _cGarant == "S" .and. (empty(_cRecCli) .or. _cRecCli == "C0022") .and. _cOpeBGH $ "N01/N10/N11"
		elseif u_CondIRF(LAB, _cGarant, _cCodPro, transform(u_TmpFabric(_cCarcac, dtos(_dDocDtE)),"@!"), _cDefInf)
			_cTrans := "IRF"
//		elseif _cGarant == "N" .and. alltrim(_cCodPro) $ _cSPC433 .and. transform(u_TmpFabric(_cCarcac, dtos(_dDocDtE)),"@!") $ _cPerSPC3 .and. !empty(_cRecCli) .and. _cRecCli <> "C0022"
		elseif u_CondIXT(LAB, _cGarant, _cCodPro, transform(u_TmpFabric(_cCarcac, dtos(_dDocDtE)),"@!"), _cDefInf)
			_cTrans := "IXT"
		elseif _cOpeBGH $ "N01/N10/N11"
			_cTrans := "IOW"
		endif
	endif

endif

// Define Garantia MCLAIM de acordo com o Transaction
if alltrim(_cTrans) $ "IBS/IRE/IRR/IRS/IXT/IR2/IR4/ITS/IER/IFS/IFR"
	_cGarMCL := "S"
elseif alltrim(_cTrans) $ "IOW/IRF"
	_cGarMCL := "N"
endif

restarea(_aAreaZZJ)

return({_cTrans,_cGarMCL})
Static Function HISTIMEI()
	
	local _aArea := getArea()
	Private ocImeiHist
	Private oDlgIme                                  
	cImeiHist := SPACE(20)
     
	aSavAcolsZZ3 := aClone(aCols)
	aSavAheadZZ3 := aClone(aHeader)     
	_nLine := n

	_aAreaZZ1 := ZZ1->(GetArea())
	_aAreaZZ3 := ZZ3->(GetArea())
	
	DEFINE MSDIALOG oDlgIme TITLE "Histórico do Imei" FROM C(306),C(324) TO C(400),C(550) PIXEL
	
	@ C(015),C(024) Say "IMEI :" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF oDlgIme
	@ C(014),C(040) MsGet ocImeiHist Var cImeiHist PICT "@!"  Size C(050),C(009) COLOR CLR_BLACK PIXEL OF oDlgIme
	DEFINE SBUTTON FROM C(030),C(050) TYPE 1 ENABLE OF oDlgIme ACTION (BrowSZ9(cImeiHist))
	
	ACTIVATE MSDIALOG oDlgIme CENTERED        
	
	n := _nLine
	
	aCols := aClone(aSavAcolsZZ3)
	aHeader := aClone(aSavAheadZZ3)
	
	restArea(_aArea)
	restarea(_aAreaZZ1)
	restarea(_aAreaZZ3)
return                                   



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VLDTRANSCºAutor  ³ M.Munhoz           º Data ³  11/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para validar os transactions de cada operacao       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function VldTransc(_cTransc, _cOperacao, _cLab)

local _lRet     := .t.
local _cTransOK := posicione("ZZJ",1,xFilial("ZZJ")+_cOperacao+_cLab,"ZZJ_VLTRAN")

// Verifica se o transaction digitado existe na lista de Transactions
if !EXISTCPO("SX5","W5" + _cTransc)
	apMsgStop('Código Transaction digitado inexistente. Favor digitar um código válido.','Transaction inexistente')
	_lRet := .f.
	cTransc := space(3)
// Verifica se o transaction digitado corresponde a operacao do IMEI
elseif !empty(_cTransOK) .and. !alltrim(_cTransc) $ alltrim(_cTransOK)
	apMsgStop('O código digitado não é um transaction válido para a operação '+_cOperacao+'. Favor digitar um código válido.','Transaction inválido')
	_lRet := .f.
	cTransc := space(3)
endif
/*
if _lRet

	if COPEBGH == "N02"
		_lRet := alltrim(cTransc) $ "IOW/ITS/IR2"
	elseif COPEBGH == "N04"
		_lRet := alltrim(cTransc) $ "IOW/IFS/IER"
	elseif COPEBGH == "N03"
		_lRet := alltrim(cTransc) $ "IR4"
	elseif COPEBGH == "N05"
		_lRet := alltrim(cTransc) $ "IOW"
	elseif COPEBGH == "N06"
		_lRet := alltrim(cTransc) $ "IFR"
	elseif COPEBGH == "N07"
		_lRet := alltrim(cTransc) $ "IOW"
	elseif COPEBGH == "N08"
		_lRet := alltrim(cTransc) $ "IRE/IXT"
	elseif COPEBGH == "N09"
		_lRet := alltrim(cTransc) $ "IRS/IXT"
	elseif COPEBGH $  "N01/10"
		_lRet := alltrim(cTransc) $ "IOW/IXT/IRF/IRR"
	elseif COPEBGH == "N11"
		_lRet := alltrim(cTransc) $ "IOW/IXT/IRF/IBS"
	endif

endif
*/

return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONDIRF  ºAutor  ³ M.Munhoz           º Data ³  11/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar se a situacao do IMEI eh de IRF      º±±
±±º          ³ Utilizado nas operacoes N01, N10, N11, N08, N09            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function CondIRF(_cLab, _cGarant, _cCodProd, _cTmpFabr, _cDefInf)

local _lIRF := .f.

_cRecCli := Posicione("ZZG",1,xFilial("ZZG")+_cLab+_cDefInf,"ZZG_RECCLI")

if _cGarant == "S" .and. (empty(_cDefInf) .or. empty(_cRecCli) .or. alltrim(_cRecCli) == "C0022") 
	_lIRF := .t.
endif

return(_lIRF)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONDIXT  ºAutor  ³ M.Munhoz           º Data ³  11/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar se a situacao do IMEI eh de IXT      º±±
±±º          ³ Utilizado nas operacoes N01, N10, N11, N08, N09            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function CondIXT(_cLab, _cGarant, _cCodProd, _cTmpFabr, _cDefInf)

local _lIXT     := .f.
local _cSPC433  := getmv("MV_SPC0433")
local _cPerSPC3 := getmv("MV_PERTIXT")

_cRecCli := Posicione("ZZG",1,xFilial("ZZG")+_cLab+_cDefInf,"ZZG_RECCLI")

if _cGarant == "N" .and. !empty(_cDefInf) .and. !empty(_cRecCli) .and. alltrim(_cRecCli) <> "C0022" .and. _cTmpFabr $ _cPerSPC3 .and. alltrim(_cCodProd) $ _cSPC433
	_lIXT := .t.
endif

return(_lIXT)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProcKIT  ºAutor  ³ Luciano Siqueir    º Data ³  06/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar se os acessorios do KIT possuem saldoº±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcKIT(_cKit,_cCodPro,_cCodCli,_cLoja,_cOpeBgh,_nQtdKit)

Local aAreaAtu := GetArea()
Local _lRetSld := .T.
Local _cAlmKIT := Posicione("ZZJ",1,xFilial("ZZJ") + _cOpeBgh, "ZZJ_ALMKIT")

// Criacao dos Campos Para Montagem do TRB
aCampos:={}
AADD(aCampos,{"COMP"    ,"C",15,0})
AADD(aCampos,{"DESCOMP" ,"C",40,0})
AADD(aCampos,{"SLDB2"  ,"N",12,2})
AADD(aCampos,{"SLDFIM"  ,"N",12,2})
		
cArqTrb := CriaTrab(aCampos,.t.)
			
If SELE("TRB")<>0
	TRB->(DbCloseArea())
Endif
			
dbUseArea(.T.,,cArqTrb,"TRB",.F.)
				
aCampos:={}
AADD(aCampos,{"COMP"    ,"Componente"})
AADD(aCampos,{"DESCOMP" ,"Descrição"})
AADD(aCampos,{"SLDB2"	,"Saldo Atual"})
AADD(aCampos,{"SLDFIM"	,"Saldo Disponivel"})

nQtdFas	:= 0
nQtdEnc	:= 0
nQtdPed	:= 0

_cQryFas := " SELECT "
_cQryFas += " 	ZZ4_STATUS, "	
_cQryFas += " 	COUNT(*) QTDREG "
_cQryFas += " FROM  " + RetSqlName("ZZ4") + " ZZ4 (nolock) "  
_cQryFas += " WHERE "
_cQryFas += " 	ZZ4_FILIAL = '" + xFilial("ZZ4") + "' AND "  
_cQryFas += " 	ZZ4_CODPRO = '" + _cCodPro + "' AND "
_cQryFas += " 	ZZ4_CODCLI = '" + _cCodCli + "' AND "
_cQryFas += " 	ZZ4_LOJA   = '" + _cLoja + "' AND "
_cQryFas += " 	ZZ4_STATUS BETWEEN '4' AND '8' AND "
_cQryFas += " 	ZZ4_CODKIT = '" + _cKit + "' AND "
_cQryFas += " 	ZZ4.D_E_L_E_T_ = '' "  
_cQryFas += " GROUP BY ZZ4_STATUS "
_cQryFas += " ORDER BY ZZ4_STATUS "
		
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryFas),"TSQLFAS",.T.,.T.)
            
dbSelectArea("TSQLFAS")
TSQLFAS->(DBGoTop())

While !TSQLFAS->(EOF())
	If Alltrim(TSQLFAS->ZZ4_STATUS) == "4"
		nQtdFas	+= TSQLFAS->QTDREG
	ElseIf Alltrim(TSQLFAS->ZZ4_STATUS) >= "5" .AND. Alltrim(TSQLFAS->ZZ4_STATUS) <= "7"
		nQtdEnc	+= TSQLFAS->QTDREG
	ElseIf Alltrim(TSQLFAS->ZZ4_STATUS) == "8"
		nQtdPed	+= TSQLFAS->QTDREG
	Endif
	TSQLFAS->(DbSkip())
EndDo	
		
TSQLFAS->(DbCloseArea())

_cQrySG1 := " SELECT "
_cQrySG1 += " 	G1_COMP AS COMP "
_cQrySG1 += " FROM " + RetSqlName("SG1") + " (nolock) "
_cQrySG1 += " WHERE "
_cQrySG1 += " 	G1_FILIAL='" + xFilial("SG1") + "' "
_cQrySG1 += " 	AND G1_COD='" + _cKit + "' "
_cQrySG1 += " 	AND D_E_L_E_T_ = '' "
_cQrySG1 += " ORDER BY G1_COMP "	
			
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySG1),"TSQLSG1",.T.,.T.)
            
dbSelectArea("TSQLSG1")
TSQLSG1->(DBGoTop())

If !TSQLSG1->(EOF())
	While !TSQLSG1->(EOF())
		
		nSldSB2 := 0  
		nSldFim	:= 0
			
		If Alltrim(TSQLSG1->COMP) <> Alltrim(_cCodPro)
			_cQrySB2 := " SELECT "
			_cQrySB2 += " 	B2_COD AS COMP, "
			_cQrySB2 += " 	B2_LOCAL AS ALMOX "
			_cQrySB2 += " FROM " + RetSqlName("SB2") + " (nolock) "
			_cQrySB2 += " WHERE "
			_cQrySB2 += " 	B2_FILIAL='" + xFilial("SB2") + "' "
			_cQrySB2 += " 	AND B2_COD='" + TSQLSG1->COMP + "' "
			_cQrySB2 += "	AND B2_LOCAL IN "+FormatIn(_cAlmKIT,";")+" 
			_cQrySB2 += " 	AND D_E_L_E_T_ = '' "
			_cQrySB2 += " ORDER BY B2_COD, B2_LOCAL "	
						
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySB2),"TSQLSB2",.T.,.T.)
			            
			dbSelectArea("TSQLSB2")
			TSQLSB2->(DBGoTop())
			
			While !TSQLSB2->(EOF())
			
				DbSelectArea("SB2")
				DbSetOrder(1)
				If DbSeek(xFilial("SB2")+TSQLSB2->COMP+TSQLSB2->ALMOX)
					nSldSB2 += SaldoSB2()
				Endif 
				
				TSQLSB2->(DbSkip())
			EndDo	
			
			TSQLSB2->(DbCloseArea())
			
			nSldFim := nSldSB2-(nQtdFas+nQtdEnc+nQtdPed)
			
			If nSldFim < _nQtdKit
				DbSelectArea("TRB")
				RecLock("TRB",.T.)     
				TRB->COMP 	:= TSQLSG1->COMP
				TRB->DESCOMP:= Posicione("SB1",1,xFilial("SB1") + TSQLSG1->COMP,"B1_DESC")
				TRB->SLDB2 	:= nSldSB2
				TRB->SLDFIM	:= nSldFim			
				MsUnlock()
			Endif
		Endif
		TSQLSG1->(DbSkip())
	EndDo	
Else
	MsgAlert("O KIT selecionado não possui BOM.")
	_lRetSld := .F.
Endif
TSQLSG1->(DbCloseArea())
			
			
DbSelectarea("TRB")
DbGoTop()
If TRB->(!Eof())
	_lRetSld := .F.
	@ 001,001 TO 395,1000 DIALOG oDlgComp TITLE OemtoAnsi("Componentes sem Saldo")
	@ 005,005 TO 175,495 BROWSE "TRB" FIELDS aCampos Object oBrowse
	@ 180,435 BMPBUTTON TYPE 01 ACTION (lExec := .F.,Close(oDlgComp))
	ACTIVATE DIALOG oDlgComp CENTERED
Endif			

//Apaga arquivo temporario
If SELE("TRB")<>0
	DbSelectArea("TRB")
	DbCloseArea()
	FErase(cArqTrb+OrdBagExt())
Endif	

RestArea(aAreaAtu)

Return(_lRetSld)