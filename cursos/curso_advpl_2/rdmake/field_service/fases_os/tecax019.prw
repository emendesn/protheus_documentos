#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FIVEWIN.CH'
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECAX019 บAutor  ณEdson B. - ERP Plus บ Data ณ  19/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rastreabilidade de fases por OS                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TECAX019()
Private oFont0    := TFont():New("Tahoma",10, 12,,.F.,,,,,.F.)
Private aDados
Private cBrow
Private cPerg     := "TECA01"
Private cCadastro := "Rastreabilidade de Aparelhos"
Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   := "ZZ4"
Private aRotina   := {;
{"Pesquisar"	,"AxPesqui"		,0,1} ,;
{"Visualizar"	,"AxVisual"		,0,2} ,;
{"Rastrear"		,"U_TECA19SCR"	,0,3} ,;
{"Imp Etq NF"	,"U_BGHPRETQ"	,0,4} ,;
{"Legenda"		,"U_TECX19LEG"	,0,5} }
Private aCores    := {;
{'!Empty(ZZ4->ZZ4_TRAVA)' ,'BR_PINK'	},;
{'ZZ4->ZZ4_STATUS == "1"' ,'BR_BRANCO'	},;
{'ZZ4->ZZ4_STATUS == "2"' ,'BR_AMARELO'	},;
{'ZZ4->ZZ4_STATUS == "3"' ,'ENABLE'		},;
{'ZZ4->ZZ4_STATUS == "4"' ,'BR_AZUL'	},;
{'ZZ4->ZZ4_STATUS == "5"' ,'BR_LARANJA'	},;
{'ZZ4->ZZ4_STATUS == "6"' ,'BR_MARROM'	},;
{'ZZ4->ZZ4_STATUS == "7"' ,'BR_CINZA'	},;
{'ZZ4->ZZ4_STATUS == "8"' ,'BR_PRETO'	},;
{'ZZ4->ZZ4_STATUS == "9"' ,'DISABLE'	} }
u_GerA0003(ProcName())
/*
1 = Entrada Apontada
2 = Entrada Confirmada
3 = NFE Gerada
4 = Em atendimento
5 = OS Encerrada
6 = Saida Lida/Apontada
7 = Saida Confirmada
8 = PV Gerado
9 = NFS Gerada
*/
//ValidPerg()  //Cria Perguntas SX1
dbSelectArea(cString)
dbSetOrder(1)
//Pergunte(cPerg,.T.)
//SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros
mBrowse( 6,1,22,75,cString,,,,,,aCores)
//Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECA01    บAutor  ณEdson B. - ERP Puls บ Data ณ  19/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER Function TECA19SCR()

Local oDlg  := Nil
Local oGet  := Nil
Local oFld  := Nil
Local _nPosTec := _nPosSeq := _nPosOS  := 0 
Local nAlt := 0
Local nLarg:= 0
Local nTwbLarg:= 0

Private aHeader   := {}
Private aCOLS     := {}
Private aRotina   := {}
Private nUsado    := 0
Private _nRegs    := 0
Private _lprimReg := .T.
Private IMEI2     := PROD2 := DESC2 := NRNFS2 := SERIE2 := DTNFS2 := HRNFS2 := DTSDOC2 := HRSDOC2 := ""
Private aHeader1  := {}
Private aColumns1 := {} 
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrNext  	:= .F.                             	 //Usuarios de Autorizado Nextel
Private lUsrSony  	:= .F.                             	 //Usuarios de Autorizado Sony
Private _nFldMCL    := 4 // Numero do folder com informacoes do MCLAIM. Quando existir part number (Z9_PARTNR) lancado sera 4 quando nao existir sera 3.
aAdd( aRotina, {"Pesquisar"  ,'pesqbrw' ,0,1})
aAdd( aRotina, {"Visualizar" ,'AxVisual',0,2})
aAdd( aRotina, {"Incluir"    ,'AxInclui',0,3})
aAdd( aRotina, {"Alterar"    ,'AxAltera',0,4})
aAdd( aRotina, {"Excluir"    ,'AxDeleta',0,5}) 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado Nextel
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Admi#Next"
		lUsrNext  := .T.
	EndIf  
	
		//Usuarios de Autorizado Sony
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Admi#Sony"
		lUsrSony  := .T.
	EndIf
	
Next i


Private cAlias1 := "ZZ3"

ZZ4->(dbSetOrder(4))

// Gera relatorio para Part Number
U_TECA02SQL()

// Cria arquivo temporario
U_TECA19SQL()

dbSelectArea("TRB")

//If _nRegs > 0

//Define tamanho da Tela
Private aSize   := MsAdvSize(,.F.,100)
Private aObjects:= {{ 0, 150, .T., .F. },{ 0, 100, .T., .T. }}  //Obj1 = Folder, Obj2 = Itens
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 3 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private MCLTRAN := MCLPROB  := MCLREP  := MCLANO  := MCLMES  := MCLBAT  := MCLSPP  := MCLSTT  := ""

Aadd(aHeader, {"Seq"			, "SEQ"		, "@!" , 02, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"T้cnico"		, "CODTEC"	, "@!" , 06, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Nome"			, "NOMTEC"	, "@!" , 20, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"C๓d. Analista"	, "CODANA"	, "@!" , 30, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Laborat๓rio"	, "DESLAB"	, "@!" , 10, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"C๓d.Setor"		, "CODSET"	, "@!" , 06, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Descri็ใo"		, "DESSET"	, "@!" , 20, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Fase"			, "FASEO"	, "@!" , 06, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Descri็ใo"		, "DESFAS"	, "@!" , 20, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Problema"		, "PROBLE"	, "@!" , 05, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Solucao"		, "REPAIR"	, "@!" , 05, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Data Conclusใo"	, "DATA"	, "@!" , 08, 0, ".F.", USADO , "D", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Hora Conclusใo"	, "HORA"	, "@!" , 05, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Estorno"		, "ESTORNO"	, "@!" , 03, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"C๓d.Setor Dest.", "CODSETD"	, "@!" , 06, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Fase Dest."		, "FASED"	, "@!" , 06, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Descri็ใo"		, "DESFASD"	, "@!" , 20, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } )
Aadd(aHeader, {"Encerra OS"   	, "ENCOS"   , "@!" , 03, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } ) 
Aadd(aHeader, {"Transaction"   	, "TRANS"   , "@!" , 03, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } ) 
Aadd(aHeader, {"Numero OS"   	, "NUMOS"   , "@!" , 08, 0, ".F.", USADO , "C", "", ""  , "", "" , "", "" , "", "", ""  } ) 

_nPosTec := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODTEC" })
_nPosSeq := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "SEQ"    })
_nPosOS  := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "NUMOS"  })

//Carrega variแveis do cabe็alho
IMEI1       := ZZ4->ZZ4_IMEI    //IMEI Original
OS1         := left(ZZ4->ZZ4_OS,6)      //OS
SERIE       := ZZ4->ZZ4_CARCAC  //Serie
PROD1       := ZZ4->ZZ4_CODPRO  //Codigo do aparelho
DESC1       := Posicione("SB1",1,xFilial("SB1") + ZZ4->ZZ4_CODPRO,"B1_DESC") //Descri็ใo do aparelho
SPC			:= Posicione("SZA",1,xFilial("SZA") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI,"ZA_SPC") //Numero do SPC atribuido
CODCLI1     := ZZ4->ZZ4_CODCLI
LOJA1		:= ZZ4->ZZ4_LOJA
NFENR1 		:= ZZ4->ZZ4_NFENR 
NFESER1 	:= ZZ4->ZZ4_NFESER
If !Empty(AllTrim(ZZ4->ZZ4_OPEANT))
	OPBGHANT	:= AllTrim(ZZ4->ZZ4_OPEANT) + " - " + AllTrim(Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(ZZ4->ZZ4_OPEANT),"ZZJ_DESCRI")) // Opera็ใo BGH Antigo
Else
	OPBGHANT	:= ""
EndIf
OPBGHATU	:= AllTrim(ZZ4->ZZ4_OPEBGH) + " - " + AllTrim(Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(ZZ4->ZZ4_OPEBGH),"ZZJ_DESCRI")) // Opera็ใo BGH Atual
TRANSACTION := ZZ4->ZZ4_TRANSC	// Transactions
DTENTDOC1   := ZZ4->ZZ4_DOCDTE  //Data Entrada na Doca
HRENTDOC1   := ZZ4->ZZ4_DOCHRE  //Hora Entrada na Doca
DTENTMAS1   := ZZ4->ZZ4_EMDT    //Data Entrada Massiva
HRENTMAS1   := ZZ4->ZZ4_EMHR    //Hora Entrada Massiva
DTNFE1      := ZZ4->ZZ4_NFEDT   //Data NFE
HRNFE1      := ZZ4->ZZ4_NFEHR   //Hora NFE
NRNFS1      := ZZ4->ZZ4_NFSNR   //Numero NFS
SERIE1      := ZZ4->ZZ4_NFSSER  //Serie NFS
DTNFS1      := ZZ4->ZZ4_NFSDT   //Data NFS
HRNFS1      := ZZ4->ZZ4_NFSHR   //Hora NFS
DTSAIDDOC   := ZZ4->ZZ4_DOCDTS  //
HRSAIDDOC   := ZZ4->ZZ4_DOCHRS
GVSOS       := ZZ4->ZZ4_GVSOS
GVSARQ      := ZZ4->ZZ4_GVSARQ
MCLARQ      := ZZ4->ZZ4_MCLGER

if !empty(ZZ4->ZZ4_SWAP)
	// Executa funcao que identifica informacoes do aparelho de SWAP
	IdentSwap()
	
	//		IMEI2   := ZZ4->ZZ4_SWAP
	//		PROD2   := Space(20)
	//		DESC2   := Space(20)
	//		NRNFS2  := Space(20)
	//		SERIE2  := Space(20)
	//		DTNFS2  := Space(20)
	//		HRNFS2  := Space(20)
	//		DTSDOC2 := Space(20)
	//		HRSDOC2 := Space(20)
	
endif

//Monta tela
DEFINE MSDIALOG oDlg TITLE "Rastreabilidade de Fases por OS" From aSize[7],aSize[1] To aSize[3],aSize[5] of oMainWnd pixel

If Len(AllTrim(aDados[01][01]))>1
	_nFldMCL    := 4
	@ aPosObj[1,1], aPosObj[1,2] FOLDER oFld OF oDlg PROMPT "IMEI &Original", "IMEI &Novo", "Posi็ใo &Produto", "MCLAIM" PIXEL SIZE aPosObj[1,4]-aPosObj[1,2], aPosObj[1,3]-aPosObj[1,1]+20
Else
	_nFldMCL    := 3
	@ aPosObj[1,1], aPosObj[1,2] FOLDER oFld OF oDlg PROMPT "IMEI &Original", "IMEI &Novo", "MCLAIM" PIXEL SIZE aPosObj[1,4]-aPosObj[1,2], aPosObj[1,3]-aPosObj[1,1]+20
EndIf

_nCol1 := 010
_nCol2 := 140
_nCol3 := 270

_nAjust := 015 //Espaco entre as linhas
_nLin1  := 005 //Linha inicial
_nLin2  := _nLin1 + _nAjust
_nLin3  := _nLin2 + _nAjust
_nLin4  := _nLin3 + _nAjust
_nLin5  := _nLin4 + _nAjust
_nLin6  := _nLin5 + _nAjust
_nLin7  := _nLin6 + _nAjust
_nLin8  := _nLin7 + _nAjust
_nLin9  := _nLin8 + _nAjust

//Titulos
@ _nLin1, _nCol1 SAY "IMEI Original" 		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin1, _nCol2 SAY "OS"            		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin1, _nCol3 SAY "Serie"         		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin2, _nCol1 SAY "Cod. Produto"  		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin2, _nCol2 SAY "Descri็ใo"     		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin2, _nCol3 SAY "Special Project"    	SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin3, _nCol1 SAY "Dt Entr Doca"  		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin3, _nCol2 SAY "Hr Entr Doca"  		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin3, _nCol3 SAY "Opera็ใo BGH Ant."    SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin4, _nCol1 SAY "Dt Entr Mass"  		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin4, _nCol2 SAY "Hr Entr Mass"  		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin4, _nCol3 SAY "Opera็ใo BGH Atu."   	SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin5, _nCol1 SAY "Dt NFE"        		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin5, _nCol2 SAY "Hr NFE"        		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin5, _nCol3 SAY "Transaction."       	SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin6, _nCol1 SAY "Nr NFS"        		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin6, _nCol2 SAY "S้rie"         		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin7, _nCol1 SAY "Dt NFS"        		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin7, _nCol2 SAY "Hr NFS"        		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin8, _nCol1 SAY "Dt Said Doca"  		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin8, _nCol2 SAY "Hr Said Doca"  		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin9, _nCol1 SAY "OS GVS"        		SIZE 65,10 PIXEL OF oFld:aDialogs[1]
@ _nLin9, _nCol2 SAY "Arquivo GVS"   		SIZE 65,10 PIXEL OF oFld:aDialogs[1]

@ _nLin1, _nCol1 + 50 MSGET IMEI1       When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin1, _nCol2 + 50 MSGET OS1         When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin1, _nCol3 + 50 MSGET SERIE       When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin2, _nCol1 + 50 MSGET PROD1       When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin2, _nCol2 + 50 MSGET DESC1       When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin2, _nCol3 + 50 MSGET SPC         When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin3, _nCol1 + 50 MSGET DTENTDOC1   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin3, _nCol2 + 50 MSGET HRENTDOC1   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin3, _nCol3 + 50 MSGET OPBGHANT    When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin4, _nCol1 + 50 MSGET DTENTMAS1   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin4, _nCol2 + 50 MSGET HRENTMAS1   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin4, _nCol3 + 50 MSGET OPBGHATU    When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin5, _nCol1 + 50 MSGET DTNFE1      When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin5, _nCol2 + 50 MSGET HRNFE1      When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin5, _nCol3 + 50 MSGET TRANSACTION When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin6, _nCol1 + 50 MSGET NRNFS1      When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin6, _nCol2 + 50 MSGET SERIE1      When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin7, _nCol1 + 50 MSGET DTNFS1      When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin7, _nCol2 + 50 MSGET HRNFS1      When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin8, _nCol1 + 50 MSGET DTSAIDDOC   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin8, _nCol2 + 50 MSGET HRSAIDDOC   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin9, _nCol1 + 50 MSGET GVSOS       When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]
@ _nLin9, _nCol2 + 50 MSGET GVSARQ      When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[1]

@ _nLin1, _nCol1 SAY "IMEI Novo"      SIZE 65,10 PIXEL OF oFld:aDialogs[2]
@ _nLin2, _nCol1 SAY "Cod. Produto"   SIZE 65,10 PIXEL OF oFld:aDialogs[2]
@ _nLin2, _nCol2 SAY "Descri็ใo"      SIZE 65,10 PIXEL OF oFld:aDialogs[2]
@ _nLin3, _nCol1 SAY "Nr NFS"         SIZE 65,10 PIXEL OF oFld:aDialogs[2]
@ _nLin3, _nCol2 SAY "S้rie"          SIZE 65,10 PIXEL OF oFld:aDialogs[2]
@ _nLin4, _nCol1 SAY "Dt NFS"         SIZE 65,10 PIXEL OF oFld:aDialogs[2]
@ _nLin4, _nCol2 SAY "Hr NFS"         SIZE 65,10 PIXEL OF oFld:aDialogs[2]
@ _nLin5, _nCol1 SAY "Dt Said Doca"   SIZE 65,10 PIXEL OF oFld:aDialogs[2]
@ _nLin5, _nCol2 SAY "Hr Said Doca"   SIZE 65,10 PIXEL OF oFld:aDialogs[2]

@ _nLin1, _nCol1 + 50 MSGET IMEI2   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]
@ _nLin2, _nCol1 + 50 MSGET PROD2   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]
@ _nLin2, _nCol2 + 50 MSGET DESC2   When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]
@ _nLin3, _nCol1 + 50 MSGET NRNFS2  When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]
@ _nLin3, _nCol2 + 50 MSGET SERIE2  When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]
@ _nLin4, _nCol1 + 50 MSGET DTNFS2  When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]
@ _nLin4, _nCol2 + 50 MSGET HRNFS2  When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]
@ _nLin5, _nCol1 + 50 MSGET DTSDOC2 When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]
@ _nLin5, _nCol2 + 50 MSGET HRSDOC2 When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[2]


If Len(AllTrim(aDados[01][01]))>1
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//|Apresenta o MarkBrowse para o usuario                                |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oGrp3      := TGroup():New( 001,001,100,770,"",oFld:aDialogs[3],CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	_oOk      	:= LoadBitmap(GetResources(), "ENABLE")
	_oNo      	:= LoadBitmap(GetResources(), "DISABLE")
	
	If lUsrSony .And. AllTrim(aDados[01][21]) == '32'
		cBrow := _oNo
	  	oSay1   := TSay():New(120, 010, {|| "Equipamento Aguardando Pe็as " + AllTrim(aDados[01][11]) + " - " + AllTrim(aDados[01][12])}, oFld:aDialogs[3],,oFont0,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,400,008) 
	
	ElseIf lUsrNext .And. AllTrim(aDados[01][21]) == '11'
		cBrow := _oNo
	  	oSay1   := TSay():New(120, 010, {|| "Equipamento Aguardando Pe็as " + AllTrim(aDados[01][11]) + " - " + AllTrim(aDados[01][12])}, oFld:aDialogs[3],,oFont0,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,400,008)
	  	
	Else
		cBrow := _oOk 
		
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Estrutura do MarkBrowse                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aHeader1 , {"","Seq.", "Item Atend.", "Fault ID", "Symptom ID", "Action ID", "Sint. Codifi", "Mot. Defeito", "Nivel Reparo", "Tp. Corre.", "Quantidade", "Part Number", "Descri็ใo", "Usado ?", "IMEI", "Cod. Fase", "Status", "Armazem Pe็a", "Pedido Pe็a", "Dt. Pedido"})
	aAdd(aColumns1, {10,20, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 40, 25, 40,30, 30, 40, 40, 40})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Desenha o MarkBrowse.                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	
	&&Tratamento para diminuir a TWBrowse para resolu็๕es menores - Thomas Galvao - 20/09/12
	nAlt  := oMainWnd:nClientWidth 
	nLarg := oMainWnd:nClientHeight
		
	If nAlt <= 1024 .And. nLarg <= 768
		nTwbLarg := nLarg -138
	Else 
		nTwbLarg := nLarg + 15
   	EndIf
    &&--------------------------------------------------------------------------------------
        
   	oBrw1 := TWBrowse():New(005, 005, nTwbLarg, 090,, aHeader1[1], aColumns1[1], oFld:aDialogs[3],,,,,,,,,,,,,, .T.)
  	
	oBrw1 :SetArray(aDados)
	oBrw1 :bLine := {|| {;
	cBrow,;
	aDados[oBrw1:nAt][01],;
	aDados[oBrw1:nAt][02],;
	aDados[oBrw1:nAt][03],;
	aDados[oBrw1:nAt][04],;
	aDados[oBrw1:nAt][05],;
	aDados[oBrw1:nAt][06],;
	aDados[oBrw1:nAt][07],;
	aDados[oBrw1:nAt][08],;
	aDados[oBrw1:nAt][09],;
	aDados[oBrw1:nAt][10],;
	aDados[oBrw1:nAt][11],;
	aDados[oBrw1:nAt][12],;
	aDados[oBrw1:nAt][13],;
	aDados[oBrw1:nAt][14],;
	aDados[oBrw1:nAt][15],;
	aDados[oBrw1:nAt][16],;
	aDados[oBrw1:nAt][17],;
	aDados[oBrw1:nAt][18],;
	aDados[oBrw1:nAt][19]}}
	
	oBrw1:lAdJustColSize := .T.
	oBrw1:lColDrag       := .T.
	oBrw1:lMChange       := .T.
	oBrw1:lHScroll       := .T.
EndIf
oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2,,,"+ITEM",.F.,,,.t.,1)
//	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2,,,"+ITEM",.F.,,,.f.,1)
//	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2     ,           ,          ,"+ITEM"    ,.F.       ,          ,        ,.t.      ,)
//	oGet := MsGetDados():New( nTop        , nLeft      , nBottom    , nRight      , nOpc, [cLinhaOk], [cTudoOk], [cIniCpos], [lDelete], [aAlter], [uPar1], [lEmpty], [nMax], [cFieldOk], [cSuperDel], [uPar2], [cDelOk], [oWnd])

//Adiciona Itens no aHeader
TRB->(dbGoTop())

While TRB->(!EOF())
	
	If !_lprimReg
		aAdd( aCols, Array(Len(aHeader)+1))
	EndIf
	For _ni := 1 to Len(aHeader)
		if aHeader[_ni,8] == 'C'
			aCols[Len(aCols),_ni] := ""
		elseif aHeader[_ni,8] == 'D'
			aCols[Len(aCols),_ni] := dDataBase
		elseif aHeader[_ni,8] == 'N'
			aCols[Len(aCols),_ni] := 0
		else
			aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2],.T.)
		endif
	Next
	aCols[Len(aCols),Len(aHeader)+1] := .F. // Nao esta deletado
	
	//Carregar campos com as variaveis
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "SEQ"    })] := TRB->ZZ3_SEQ
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODTEC" })] := TRB->ZZ3_CODTEC
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "NOMTEC" })] := TRB->AA1_NOMTEC
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODANA" })] := IIF(!Empty(TRB->ZZ3_CODANA),PADR(TRB->ZZ3_CODANA,3)+' - '+AllTrim(Posicione("AA1", 1, xFilial("AA1") + TRB->ZZ3_CODANA,'AA1_NOMTEC')),'' )
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DESLAB" })] := TRB->DESLAB
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODSET" })] := TRB->ZZ3_CODSET
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DESSET" })] := TRB->ZZ2_DESSET
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "FASEO"  })] := TRB->ZZ3_FASE1
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DESFAS" })] := TRB->ZZ1_DESFA1
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DATA"   })] := STOD(TRB->ZZ3_DATA)
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "HORA"   })] := TRB->ZZ3_HORA
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ESTORNO"})] := TRB->ZZ3_ESTORN
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "CODSETD"})] := TRB->ZZ3_CODSE2
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "FASED"  })] := TRB->ZZ3_FASE2
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "DESFASD"})] := TRB->ZZ1_DESFA2 
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "NUMOS"  })] := TRB->ZZ3_NUMOS
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "PROBLE" })] := TRB->ZZ3_DEFDET
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "REPAIR" })] := TRB->ZZ3_ACAO
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ENCOS"  })] := TRB->ZZ3_ENCOS
	aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "TRANS"  })] := TRB->ZZ3_TRANSC
	
	TRB->(dbSkip())
	
	_lprimReg := iif(_lprimReg ,.F.,.F.)
	
EndDo

// BUSCA DADOS DO MCLAIM - ticket 12155 - M.Munhoz - 24/06/2013
AtuMCLAIM(OS1,IMEI1)

// FOLDER MCLAIM - ticket 12155 - M.Munhoz - 24/06/2013
@ _nLin1, _nCol1 SAY "Transaction"      SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin2, _nCol1 SAY "Arquivo MCLAIM"   SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin3, _nCol1 SAY "Problem Found"    SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin3, _nCol2 SAY "Repair Code"      SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin4, _nCol1 SAY "Ano"              SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin4, _nCol2 SAY "Mes"              SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin4, _nCol3 SAY "Batch"            SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin5, _nCol1 SAY "Special Project"  SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin5, _nCol2 SAY "Status"           SIZE 65,10 PIXEL OF oFld:aDialogs[_nFldMCL]

@ _nLin1, _nCol1 + 50 MSGET MCLTRAN When .F.	SIZE 030,7 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin2, _nCol1 + 50 MSGET MCLARQ  When .F.	SIZE 140,7 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin3, _nCol1 + 50 MSGET MCLPROB When .F.	SIZE 040,7 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin3, _nCol2 + 50 MSGET MCLREP  When .F.	SIZE 040,7 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin4, _nCol1 + 50 MSGET MCLANO  When .F.	SIZE 040,7 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin4, _nCol2 + 50 MSGET MCLMES  When .F.	SIZE 030,7 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin4, _nCol3 + 50 MSGET MCLBAT  When .F.	SIZE 030,7 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin5, _nCol1 + 50 MSGET MCLSPP  When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[_nFldMCL]
@ _nLin5, _nCol2 + 50 MSGET MCLSTT  When .F.	SIZE 070,7 PIXEL OF oFld:aDialogs[_nFldMCL]


//	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,{{'DBG06',{|| U_AddPartNO(2,.t.)},'Part. No.'}})
//	tecax017(OS1,aCols[n,_nPosTec],IMEI1,aCols[n,_nPosSeq])
Inclui := Altera :=_lobripart := .f.
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,{{'DBG06',{|| U_tecax017(aCols[n,_nPosOS],aCols[n,_nPosTec],IMEI1,aCols[n,_nPosSeq],_lobripart)},'Part. No.'},{'EDITABLE',{|| U_pecasfalt(aCols[n,_nPosOS],aCols[n,_nPosTec],IMEI1,aCols[n,_nPosSeq],_lobripart)},'Pe็as Falt.'},;
{'RELATORIO',{|| ConsAces(IMEI1,CODCLI1,LOJA1,NFENR1,NFESER1)},'Acessorios.'}})
//	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||U_STATUSOK(1), oDlg:End()},{||U_GRAVA(), oDlg:End()},,{{'DBG06',{|| U_AddPartNO(2)},'Part. No.'}})
/*
Else

MsgAlert("Nใo hแ nenhum registro para esta data.")

EndIf
*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณEdson B. - ERP Plus บ Data ณ  19/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

PutSX1(cPerg,'01','IMEI?'       ,'IMEI?'       ,'IMEI?'       ,'mv_ch1','C',TamSX3("ZZ4_IMEI")[1],0,0,'' ,'','','','G','mv_par01','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'02','De Data?'    ,'De Data?'    ,'De Data?'    ,'mv_ch2','D',8 ,0,0,'' ,'','','','G','mv_par02','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'03','At้ Data?'   ,'At้ Data?'   ,'At้ Data?'   ,'mv_ch3','D',8 ,0,0,'' ,'','','','G','mv_par03','','','','','','','','','','','','','','','','')

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECA19SQL บAutor  ณEdson B. - ERP Plus บ Data ณ  26/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TECA19SQL()

Local _cQuery   := ""
Local _cNomeArq := CriaTrab(NIL,.F.)

_cQuery += ENTER + " SELECT ZZ3_SEQ, ZZ3_CODTEC, AA1_NOMTEC, ZZ3_NUMOS, "
_cQuery += ENTER + "        DESLAB = CASE WHEN ZZ3_LAB = '0' THEN 'Todos' WHEN ZZ3_LAB = '1' THEN 'Sony' WHEN ZZ3_LAB = '2' THEN 'Nextel' ELSE 'Nao informado' END, "
_cQuery += ENTER + "        ZZ3_CODSET, ZZ2_DESSET, ZZ3_FASE1, ZZ1.ZZ1_DESFA1, ZZ3_DATA, ZZ3_HORA, ZZ3_CODSE2, ZZ3_FASE2, ZZ1B.ZZ1_DESFA1 ZZ1_DESFA2,ZZ3_CODANA, "
_cQuery += ENTER + "        ZZ3_ESTORN = CASE WHEN ZZ3_ESTORN = 'S' THEN 'Sim' ELSE '   ' END, ZZ3_DEFDET, ZZ3_ACAO, "
_cQuery += ENTER + "        ZZ3_ENCOS  = CASE WHEN ZZ3_ENCOS  = 'S' THEN 'Sim' ELSE '   ' END, ZZ3_TRANSC "
_cQuery += ENTER + " FROM   " + RetSqlName("ZZ3") + " AS ZZ3 (nolock) "
_cQuery += ENTER + " LEFT OUTER JOIN   " + RetSqlName("ZZ1") + " AS ZZ1 "
_cQuery += ENTER + " ON     ZZ1.ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND ZZ1.ZZ1_LAB = ZZ3_LAB AND ZZ1.ZZ1_FASE1 = ZZ3_FASE1 AND ZZ1.D_E_L_E_T_ = '' "
//_cQuery += ENTER + "        AND ZZ1.ZZ1_CODSET = CASE WHEN ZZ3_LAB = '1' THEN ZZ3_CODSET ELSE ZZ1.ZZ1_CODSET END " Alterado essa linha, por estar duplicando - Edson Rodrigues 29/09/09
_cQuery += ENTER + " AND ZZ1.ZZ1_CODSET =ZZ3_CODSET "
_cQuery += ENTER + " LEFT OUTER JOIN " + RetSqlName("ZZ1") + " AS ZZ1B (nolock) "
_cQuery += ENTER + " ON     ZZ1B.ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND ZZ1B.ZZ1_LAB = ZZ3_LAB AND ZZ1B.ZZ1_FASE1 = ZZ3_FASE2 AND ZZ1B.D_E_L_E_T_ = '' "
//_cQuery += ENTER + "        AND ZZ1B.ZZ1_CODSET = CASE WHEN ZZ3_LAB = '1' THEN ZZ3_CODSET ELSE ZZ1B.ZZ1_CODSET END "  Alterado essa linha, por estar duplicando - Edson Rodrigues 29/09/09
_cQuery += ENTER + " AND ZZ1B.ZZ1_CODSET = ZZ3_CODSE2 "
_cQuery += ENTER + " LEFT OUTER JOIN   " + RetSqlName("ZZ2") + " AS ZZ2 (nolock) "
_cQuery += ENTER + " ON     ZZ2_FILIAL = '"+xFilial("ZZ2")+"' AND ZZ2_LAB = ZZ3_LAB AND ZZ2_CODSET = ZZ3_CODSET AND ZZ2.D_E_L_E_T_ = '' "
_cQuery += ENTER + " LEFT OUTER JOIN   " + RetSqlName("AA1") + " AS AA1 (nolock) "
_cQuery += ENTER + " ON     AA1_FILIAL = '"+xFilial("AA1")+"' AND AA1_CODTEC = ZZ3_CODTEC AND AA1.D_E_L_E_T_ = '' "
_cQuery += ENTER + " WHERE  ZZ3_FILIAL = '"+xFilial("ZZ3")+"' "
//_cQuery += ENTER + "        AND ZZ3_DATA BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"' "
_cQuery += ENTER + "        AND ZZ3_IMEI  = '"+ZZ4->ZZ4_IMEI+"' "
_cQuery += ENTER + "        AND LEFT(ZZ3_NUMOS,6) = '"+left(ZZ4->ZZ4_OS,6)+"' "
_cQuery += ENTER + "        AND ZZ3_STATUS = '1' "
_cQuery += ENTER + "        AND ZZ3.D_E_L_E_T_ = '' "
_cQuery += ENTER + " ORDER BY ZZ3_SEQ, ZZ3_DATA, ZZ3_HORA "

if select("TRB") > 0
	TRB->(dbCloseArea())
endif

//memowrite("d:\TECA19SQL.SQL",_cQuery)
_cQuery := strtran(_cQuery, ENTER, "")
TcQuery _cQuery NEW ALIAS "TRB"

_cNomeArq := CriaTrab(NIL,.F.)
dbselectarea("TRB")
copy to &(_cNomeArq) //VIA "DBFCDXADS"
TRB->(dbclosearea())
dbUseArea(.T.,,_cNomeArq,"TRB",.F.,.F.)

//TcSetField("TRB","ZZ3_DATA","D",8,0)

_nRegs := TRB->(reccount())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECA02SQL บAutor  ณPaulo Francisco     บ Data ณ  17/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosicao Produtos e seus Descritivos.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TECA02SQL()

Local  cQry
Local _cQry


If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf    
If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

cQry	:= "SELECT	SZ9.Z9_SEQ		AS SEQUEN,  "														+ ENTER
cQry	+= "		SZ9.Z9_ITEM		AS ITEM,    "														+ ENTER
cQry	+= "		SZ9.Z9_FAULID	AS FAULTID, " 														+ ENTER
cQry	+= "		SZ9.Z9_SYMPTO	AS SYMPTOM, " 														+ ENTER
cQry	+= "		SZ9.Z9_ACTION	AS ACTIONE, " 														+ ENTER
cQry	+= "		SZ9.Z9_SINTCOD	AS SINTCOD, " 														+ ENTER
cQry	+= "		SZ9.Z9_MOTDEFE	AS MOTDEFE, " 														+ ENTER
cQry	+= "		SZ9.Z9_NIVELRE	AS NIVELRE, " 														+ ENTER
cQry	+= "		TPCORRE =	CASE WHEN SZ9.Z9_PREVCOR = 'C' THEN 'CORRECAO' ELSE 'PREVENTIVA' END, " + ENTER
cQry	+= "		SZ9.Z9_QTY		AS QTY, " 															+ ENTER
cQry	+= "		ISNULL(SZ9.Z9_PARTNR,0)	AS PARTNR, " 														+ ENTER
cQry	+= "		SB1.B1_DESC		AS DESCRI, " 														+ ENTER
cQry	+= "		USED =	CASE WHEN SZ9.Z9_USED = '0' THEN 'NAO' ELSE 'SIM' END, " 					+ ENTER
cQry	+= "		SZ9.Z9_IMEI		AS IMEI, " 															+ ENTER
cQry	+= "		SZ9.Z9_FASE1	AS CODFASE, " 														+ ENTER
cQry	+= "		STTUS =	CASE WHEN Z9_STATUS = '0' THEN 'TEMPORARIO' ELSE 'GRAVADO' END, " 			+ ENTER
cQry	+= "		SZ9.Z9_LOCAL	AS LOCALI, " 														+ ENTER
cQry	+= "		SZ9.Z9_PEDPECA	AS PEDPECA, " 														+ ENTER
cQry	+= "		''				AS DTSOLPECA, " 														+ ENTER
cQry	+= "		''				AS DTSOL "															+ ENTER

cQry	+= "FROM " + RetSqlName("SZ9") + " SZ9 (nolock) "												+ ENTER
cQry	+= "LEFT JOIN " + RetSqlName("SB1") + " SB1 (nolock) "											+ ENTER
cQry	+= "ON(SZ9.Z9_PARTNR = SB1.B1_COD) " 															+ ENTER
cQry	+= "WHERE SZ9.D_E_L_E_T_ = ''  " 																+ ENTER
cQry	+= "AND SB1.D_E_L_E_T_ = '' " 																	+ ENTER
cQry	+= "AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "												+ ENTER
cQry	+= "AND SZ9.Z9_IMEI = '" + AllTRim(ZZ4->ZZ4_IMEI) + "' " 										+ ENTER
cQry	+= "AND SZ9.Z9_NUMOS = '" + AllTRim(ZZ4->ZZ4_OS)  + "' " 										+ ENTER
cQry	+= "AND SZ9.Z9_FILIAL = '" + xFilial ("SZ9") + "' "												+ ENTER

/*cQry	+= "UNION "																						+ ENTER

cQry	+= "SELECT	ZZ7.ZZ7_SEQ		AS SEQUEN, "														+ ENTER
cQry	+= "		ZZ7.ZZ7_ITEM	AS ITEM, "															+ ENTER
cQry	+= "		''				AS FAULTID, "														+ ENTER
cQry	+= "		''				AS SYMPTOM, "														+ ENTER
cQry	+= "		''				AS ACTIONE, "														+ ENTER
cQry	+= "		''				AS SINTCOD, "														+ ENTER
cQry	+= "		''				AS MOTDEFE, "														+ ENTER
cQry	+= "		''				AS NIVELRE, "														+ ENTER
cQry	+= "		''				AS TPCORRE, "														+ ENTER
cQry	+= "		ZZ7.ZZ7_QTY		AS QTY, "															+ ENTER
cQry	+= "		ZZ7.ZZ7_PARTNR	AS PARTNR, "														+ ENTER
cQry	+= "		SB1.B1_DESC		AS DESCRI, "														+ ENTER
cQry	+= "		''				AS USED, "															+ ENTER
cQry	+= "		ZZ7.ZZ7_IMEI	AS IMEI, "															+ ENTER
cQry	+= "		ZZ7.ZZ7_FASE1	AS CODFASE, "														+ ENTER
cQry	+= "		''				AS STTUS , "														+ ENTER
cQry	+= "		ZZ7.ZZ7_LOCAL	AS LOCALI, "														+ ENTER
cQry	+= "		''				AS PEDPECA, "														+ ENTER
cQry	+= "		ZZ7.ZZ7_DATA	AS DTSOLPECA, "														+ ENTER
cQry	+= "		ZZ7.ZZ7_DATA	AS DTSOL "															+ ENTER

cQry	+= "FROM " + RetSqlName("ZZ7") + " ZZ7 (nolock) "												+ ENTER
cQry	+= "LEFT JOIN " + RetSqlName("SB1") + " SB1 (nolock) "											+ ENTER
cQry	+= "ON(ZZ7.ZZ7_PARTNR = SB1.B1_COD) "															+ ENTER
cQry	+= "WHERE ZZ7.D_E_L_E_T_ = '' "																	+ ENTER
cQry	+= "AND SB1.D_E_L_E_T_ = '' "																	+ ENTER
cQry	+= "AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "												+ ENTER
cQry	+= "AND ZZ7.ZZ7_IMEI = '" + AllTRim(ZZ4->ZZ4_IMEI) + "' "										+ ENTER
cQry	+= "AND ZZ7.ZZ7_NUMOS = '" + AllTRim(ZZ4->ZZ4_OS)  + "' "										+ ENTER
cQry	+= "AND ZZ7.ZZ7_FILIAL = '" + xFilial("ZZ7") + "' "												+ ENTER */

MemoWrite("C:\teca02sql.sql", cQry)
TCQUERY cQry NEW ALIAS QRY
TcSetField("QRY","DTSOLPECA","D") 


_cQry := "SELECT TOP 1 ZZ3_DATA AS DATA, ZZ3_FASE2 AS FASE, ZZ3_USER AS USERID "						+ ENTER
_cQry += "FROM " + RetSqlName("ZZ3") + " ZZ3 (nolock) "  												+ ENTER
_cQry += "WHERE D_E_L_E_T_ = ''" 																		+ ENTER
_cQry += "AND ZZ3_IMEI = '" + AllTRim(ZZ4->ZZ4_IMEI) + "' "											+ ENTER
_cQry += "AND ZZ3_NUMOS = '" + AllTRim(ZZ4->ZZ4_OS)  + "' "											+ ENTER
_cQry += "AND ZZ3_FILIAL = '" + xFilial("ZZ3") + "' "													+ ENTER
_cQry += "ORDER BY 1 DESC  " 																			+ ENTER 

MemoWrite("C:\teca03sql.sql", _cQry)
TCQUERY _cQry NEW ALIAS QRY1


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Grava dados no Array                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


dbSelectArea("QRY")
dbGoTop()

aDados := {}

If !Empty(QRY->SEQUEN)
	
	While !QRY->(EOF())
		
		aAdd(aDados, {QRY->SEQUEN, QRY->ITEM, QRY->FAULTID, QRY->SYMPTOM, QRY->ACTIONE, QRY->SINTCOD, QRY->MOTDEFE, QRY->NIVELRE, QRY->TPCORRE, QRY->QTY, QRY->PARTNR, QRY->DESCRI, QRY->USED, QRY->IMEI, QRY->CODFASE, QRY->STTUS, QRY->LOCALI, QRY->PEDPECA, QRY->DTSOLPECA, QRY->DTSOL, QRY1->FASE, QRY1->USERID })
		
		dbSelectArea("QRY")
		dbSkip()
	EndDo
Else
	aAdd(aDados, {0})
EndIf

QRY->(dbCloseArea())
QRY1->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtecx011H  บAutor  ณAntonio L.F. Favero บ Data ณ  26/10/2002 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria botao de Legenda                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function tecx19leg()
BRWLegenda(	'Legenda',;
'Status do IMEI',;
{{'BR_PINK'		,'  = Aparelho Bloqueado'	},;
{'BR_BRANCO'	,'1 = Entrada Apontada'		},;
{'BR_AMARELO'	,'2 = Entrada Confirmada'	},;
{'BR_VERDE'		,'3 = NFE Gerada'			},;
{'BR_AZUL'		,'4 = OS em atendimento'	},;
{'BR_LARANJA'	,'5 = OS encerrada'			},;
{'BR_MARROM'	,'6 = Saida Lida/Apontada'	},;
{'BR_CINZA'		,'7 = Saida Confirmada'		},;
{'BR_PRETO'		,'8 = PV Gerado'			},;
{'BR_VERMELHO'	,'9 = NFS Gerada'			}})
Return(nil)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIdentSwap บAutor  ณMicrosiga           บ Data ณ  07/14/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function IdentSwap()

local _cQuery    := ""
local _cAliasTop := GetNextAlias()

_cQuery += " SELECT C6_NUM, C6_ITEM, C6_NOTA, C6_SERIE, F2_EMISSAO, F2_HORA, F2_SAIROMA, F2_HSAIROM"
_cQuery += " FROM   "+RetSqlName("SC6")+" AS C6 (nolock) "
_cQuery += " LEFT OUTER JOIN   "+RetSqlName("SD2")+" AS D2 (nolock) "
_cQuery += " ON     C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND D2.D_E_L_E_T_ = '' "
_cQuery += " LEFT OUTER JOIN   "+RetSqlName("SF2")+" AS F2 (nolock) "
_cQuery += " ON     C6_FILIAL = F2_FILIAL AND F2_DOC = C6_NOTA AND F2_SERIE = C6_SERIE AND F2.D_E_L_E_T_ = '' "
_cQuery += " WHERE  C6.D_E_L_E_T_ = '' "
_cQuery += "        AND C6_FILIAL = '"+xFilial("SC6")+"' "
_cQuery += "        AND C6_IMEINOV = '"+ZZ4->ZZ4_SWAP+"' "
_cQuery += "        AND C6_XIMEOLD = '"+ZZ4->ZZ4_IMEI+"' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasTop,.T.,.T.)
(_cAliasTop)->(dbGoTop())

IMEI2   := ZZ4->ZZ4_SWAP
PROD2   := iif(!empty(ZZ4->ZZ4_PRODUP), ZZ4->ZZ4_PRODUP, ZZ4->ZZ4_CODPRO)
DESC2   := posicione("SB1",1,xFilial("SB1") + PROD2, "B1_DESC")
If (_cAliasTop)->(!eof())
	NRNFS2  := (_cAliasTop)->C6_NOTA
	SERIE2  := (_cAliasTop)->C6_SERIE
	DTNFS2  := dtoc(stod((_cAliasTop)->F2_EMISSAO))
	HRNFS2  := (_cAliasTop)->F2_HORA
	DTSDOC2 := dtoc(stod((_cAliasTop)->F2_SAIROMA))
	HRSDOC2 := (_cAliasTop)->F2_HSAIROM
Endif
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBGHPRETQ  บAutor  ณ                          บData ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function BGHPRETQ()
Local aAreaZZ4 := GetArea()
Private aNfOk   := {}
Private _cTesEtq:= ""
Private _cLayETQ:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH, "ZZJ_LAYETQ")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRotina de travamento do radio - GLPI 14467ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !U_VLDTRAV(ZZ4->ZZ4_FILIAL, ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS, {"P","TECAX019","BGHPRETQ"})
	_cTesEtq := ""
ElseIf Empty(ZZ4->ZZ4_NFSNR)
	MsgAlert("IMEI selecionado nใo possui NF gerada.")
Else
	dbSelectArea("SF2")
	dbSetOrder(1)
	If dbSeek(xFilial("SF2")+ZZ4->ZZ4_NFSNR+ZZ4->ZZ4_NFSSER)
		If Empty(SF2->F2_XNUMETQ)
			MsgAlert("NF nใo possui etiqueta gerada.")	
		Else
			_cQry := " SELECT "
			_cQry += " D2_DOC,D2_SERIE,D2_TES "
			_cQry += " FROM " + RetSqlName("SF2") + " AS SF2 (nolock), "+ RetSqlName("SD2") + " AS SD2 (nolock) "
			_cQry += " WHERE "
			_cQry += " F2_FILIAL='"+xFilial("SF2")+"' "
			_cQry += " AND F2_XNUMETQ = '"+SF2->F2_XNUMETQ+"' "
			_cQry += " AND F2_EMISSAO = '"+DTOS(SF2->F2_EMISSAO)+"' "
			_cQry += " AND SF2.D_E_L_E_T_=' ' "
			_cQry += " AND D2_FILIAL=F2_FILIAL "
			_cQry += " AND D2_DOC=F2_DOC "
			_cQry += " AND D2_CLIENTE=F2_CLIENTE "
			_cQry += " AND D2_LOJA=F2_LOJA "
			_cQry += " AND SD2.D_E_L_E_T_ = '' "
			_cQry += " GROUP BY D2_DOC,D2_SERIE,D2_TES "
			
			If Select("QRY") > 0
				QRY->(dbCloseArea())
			EndIf
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

			dbSelectArea("QRY")
			dbGoTop()
			While !EOF("QRY")
				aADD(aNfOk,{QRY->D2_SERIE,QRY->D2_DOC,SF2->F2_XNUMETQ})
				_cTesEtq:= QRY->D2_TES
				dbSelectArea("QRY")
				DbSkip()
			EndDo
			
			If Select("QRY") > 0
				QRY->(dbCloseArea())
			EndIf
			
			If len(aNFOK) > 0 
				U_BGHETQNF(aNfOk,_cTesEtq,_cLayETQ)
			Endif	
		Endif
	Else
		MsgAlert("NF nใo localizada no sistema.")
	Endif
Endif

RestArea(aAreaZZ4)

Return


Static Function ConsAces(IMEI1,CODCLI1,LOJA1,NFENR1,NFESER1)

Local aArea	  := GetArea()
Local cQrySZC := ""
Local aCampos := {}

Private oDlg		:= Nil    

cQrySZC := " SELECT ZC_ACESS AS ACESS, ZC_DESACES AS DESACES "
cQrySZC += " FROM "+RetSQLName("SZC")+" "
cQrySZC += " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' "
cQrySZC += " AND ZC_IMEI = '"+IMEI1+"' "
cQrySZC += " AND ZC_FORNECE = '"+CODCLI1+"' "
cQrySZC += " AND ZC_LOJA = '"+LOJA1+"' "
cQrySZC += " AND ZC_DOC = '"+NFENR1+"' "
cQrySZC += " AND ZC_SERIE = '"+NFESER1+"' "
cQrySZC += " AND D_E_L_E_T_ = '' "
cQrySZC += " ORDER BY ZC_ACESS, ZC_DESACES "

If Select("TRB1") > 0
	dbSelectArea("TRB1")
	DbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQrySZC),"TRB1",.F.,.T.)

AADD(aCampos,{"ACESS"	,"Acessorio"})
AADD(aCampos,{"DESACES"	,"Descri็ใo"})


dbSelectArea("TRB1")
dbGotop()      

If TRB1->(!Eof())
	@ 001,001 TO 395,1000 DIALOG oDlg TITLE OemtoAnsi("Consulta Acessorios")
	@ 015,005 TO 175,495 BROWSE "TRB1" FIELDS aCampos Object oBrowse
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End(), Close(oDlg)},{||oDlg:End()},,)
Else
	MsgAlert("Acessorio nใo localizado para o IMEI informado.")
Endif

If Select("TRB1") > 0
	dbSelectArea("TRB1")
	DbCloseArea()
EndIf

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuMCLAIM บAutor  ณMicrosiga           บ Data ณ  24/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza dados MCLAIM na tela de Rastreabilidade           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function AtuMCLAIM(_cNumOs)

local _aAreaSZR := SZR->(getarea())

SZR->(dbSetOrder(4)) // ZR_FILIAL + ZR_OSZZ4
if SZR->(dbSeek(xFilial("SZR")+_cNumOs))

	MCLTRAN := SZR->ZR_TRANS
	MCLPROB := SZR->ZR_PROBL
	MCLREP  := SZR->ZR_REPARO
	MCLANO  := SZR->ZR_ANOMCL
	MCLMES  := SZR->ZR_MESMCL
	MCLBAT  := SZR->ZR_BATCH
	MCLSPP  := SZR->ZR_SPC
	MCLSTT  := iif(SZR->ZR_STATUS == "A", "Aprovado", iif(SZR->ZR_STATUS == "R", "Reprovado", "-"))

endif

restarea(_aAreaSZR)

Return()