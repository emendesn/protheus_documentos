#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECAX010 บAutor  ณ ERPPLUS - M.Munhoz บ Data ณ 29/04/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manutencao da Entrada Massiva                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlterado  ณ Edson Rodrigues em 27/05/11 - trocado rotina de axcadastro บฑฑ
ฑฑบ          ณ por Mbrowse                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function Tecax010()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cfiltro	:= "ZZ4_STATUS < '8' "
Local cAlias	:= "ZZ4"
Private cCadastro	:= "Manuten็ใo de Entrada Massiva"
Private ctabela		:= "ZZ4"
Private	lUsrAut		:=.F.
Private aGrupos		:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private aRotina		:= {;
	{"Pesquisar"	,"AxPesqui"		,0 ,1},; //"Pesquisar"
	{"Visualizar"	,"AxVisual"		,0 ,2},; //"Visualizar"
	{"Legenda"		,"u_Tec010Le()"	,0 ,4},; //"Legenda"
	{"Excluir"		,"u_EXCLZZ4()"	,0 ,5};
}
Private aCores		:= {;
	{'!Empty(ZZ4->ZZ4_TRAVA)', "DISABLE"	},;
	{'ZZ4->ZZ4_STATUS == "1"', "BR_BRANCO"	},;
	{'ZZ4->ZZ4_STATUS == "2"', "BR_AMARELO"	},;
	{'ZZ4->ZZ4_STATUS == "3"', "ENABLE"		},;
	{'ZZ4->ZZ4_STATUS == "4"', "BR_AZUL"	},;
	{'ZZ4->ZZ4_STATUS == "5"', "BR_LARANJA"	},;
	{'ZZ4->ZZ4_STATUS == "6"', "BR_MARROM"	},;
	{'ZZ4->ZZ4_STATUS == "7"', "BR_CINZA"	},;
	{'ZZ4->ZZ4_STATUS == "8"', "BR_PRETO"	},;
	{'ZZ4->ZZ4_STATUS == "9"', "BR_PINK"	};
}
u_GerA0003(ProcName())
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	//Usuarios de Autorizado a fazer troca de IMEI
	If Upper(AllTrim(GRPRetName(aGrupos[i]))) $ "EXCLUIENTMASS#ADMINISTRADORES"
		lUsrAut  := .T.
	EndIf
Next i
If !lUsrAut
	MsgAlert("Voce nao tem autorizacao para executar essa rotina. Contate o administrador do sistema.","Usuario nao Autorizado")
	Return
EndIf
dbSelectArea("ZZ4")
dbSetOrder(3)
ZZ4->(dbsetfilter({|| &(cFiltro)} ,cFiltro))
mBrowse( 6,1,22,75,cAlias, , , , , ,aCores)
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXCLZZ4   บ Autor ณ Edson rodrigues    บ Data ณ  27/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function EXCLZZ4(cAlias,nReg, nOpc)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cTitulo	:= "Exclusao Entrada Massiva"
Local aCab		:= {} // Array com descricao dos campos do Cabecalho do Modelo 2
Local aRoda		:= {} // Array com descricao dos campos do Rodape do Modelo 2
Local aGrid		:= {80,005,050,300}  //Array com coordenadas da GetDados no modelo2 - Padrao: {44,5,118,315}
Local cLinhaOk	:= ".T." // Validacoes na linha da GetDados da Modelo 2
Local cTudoOk	:= ".T." // Validacao geral da GetDados da Modelo 2
Local lRetMod2	:= .F. // Retorno da fun็ใo Modelo2 - .T. Confirmou / .F. Cancelou
Local nColuna	:= 0
Local cnewchav	:= Space(6)
Local lvalinfo	:= .T.
Local lRet		:= .T.
Local _lRet		:= .F.
Local cMsg		:= ""
Private cultchav	:= Space(6)
Private aCols 		:= {}
Private aHeader		:= {}
Private ncount		:= 0
Private ccodcli		:= Space(6)
Private cloja		:= Space(2)

If ZZ4->ZZ4_STATUS > '2' // .OR. Empty(ZZ4->ZZ4_NFEDT)
	cMsg += "Ja foi feito Doc. Entrada dessa entrada Massiva. Exclua-a via rotina de Exclusao de Doc. Entrada" + CHR(13) + CHR(10)
	lRet := .F.
EndIf
If !U_VLDTRAV(ZZ4->ZZ4_FILIAL,ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS,{"P","TECAX010","EXCLZZ4"})
	lRet := .F.
EndIf
If !lRet
	MsgAlert(cMsg,"ExclZZ4")
	Return()
EndIf
_lRet:=apMsgYesNo("Deseja excluir todos IMEIS da NFE/SERIE :" +AllTrim(ZZ4->ZZ4_NFENR)+"/"+ZZ4->ZZ4_NFESER+" ?")
Private cdoc	:= ZZ4->ZZ4_NFENR
Private cserie	:= ZZ4->ZZ4_NFESER
Private cemissa	:= DTOC(ZZ4->ZZ4_EMDT)
Private cIMEI	:= ZZ4->ZZ4_IMEI
Private ccodpro	:= ZZ4->ZZ4_CODPRO
Private _clab	:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH, "ZZJ_LAB")
Private lvdaprod:= U_VLDDREQ(ZZ4->ZZ4_OPEBGH,_clab) //Valida opera็๕es para chamar a fun็ใo de inclusใo ou estorno de OP. Edson Rodrigues 05/05/10
Private _nopctip:= Iif(lvdaprod,2,1)
Private ccodcli	:= Iif(lvdaprod,SUBSTR(AllTrim(GETMV('MV_XFORSRF')),1,6),ZZ4->ZZ4_CODCLI)
Private cloja	:= Iif(lvdaprod,SUBSTR(AllTrim(GETMV('MV_XFORSRF')),7,2),ZZ4->ZZ4_LOJA )
Private cnome	:= Posicione("SA1",1,xFilial("SA1")+ccodcli+cloja,"A1_NOME")
Private _ctipo	:= Iif(lvdaprod,"N","B")
// Montagem do array de cabe็alho
// aAdd(aCab,{"Variแvel"	,{L,C} ,"Tํtulo","Picture","Valid","F3",lEnable})
aAdd(aCab,{"cdoc"	,{015,023},"Nota Fiscal","@!",,,.F.})
aAdd(aCab,{"cserie"	,{015,100},"Serie"		,"@!",,,.F.})
aAdd(aCab,{"cemissa",{015,150},"Emissao"	,"@!",,,.F.})
aAdd(aCab,{"ccodcli",{030,023},"Client"		,"@!",,,.F.})
aAdd(aCab,{"cloja"	,{030,100},"Loja"		,"@!",,,.F.})
aAdd(aCab,{"cnome"	,{030,150},"Nome"		,"@!",,,.F.})
// Montagem do aHeader
aAdd(aHeader,{"PRODUTO"		,"ZZ4_CODPRO"	,"@!"				,15,0,"AllwaysTrue()","","C","","V"})
aAdd(aHeader,{"IMEI"		,"ZZ4_IMEI"		,"@!"				,TamSX3("ZZ4_IMEI")[1],0,"AllwaysTrue()","","C","","V"})
aAdd(aHeader,{"CARCACA"		,"ZZ4_CARCAC"	,"@!"				,25,0,"AllwaysTrue()","","C","","V"})
aAdd(aHeader,{"USUARIO EM"	,"ZZ4_EMUSER"	,"@!"				,20,0,"AllwaysTrue()","","C","","V"})
aAdd(aHeader,{"VALOR UNIT"	,"ZZ4_VLRUNI"	,"@E 99999999.9999"	,13,4,"AllwaysTrue()","","N","","V"})
aAdd(aHeader,{"STATUS"		,"ZZ4_STATUS"	,"@!"				,01,0,"AllwaysTrue()","","C","","V"})
aAdd(aHeader,{"OPERACAO"	,"ZZ4_OPEBGH"	,"@!"				,03,0,"AllwaysTrue()","","C","","V"})
// Montagem do aCols
aCols := Array(1,Len(aHeader)+1)
// Inicializa็ใo do aCols
For nColuna := 1 to Len(aHeader)
	If aHeader[nColuna][8] == "C"
		aCols[1][nColuna] := Space(aHeader[nColuna][4])
	ElseIf aHeader[nColuna][8] == "N"
		aCols[1][nColuna] := 0
	ElseIf aHeader[nColuna][8] == "D"
		aCols[1][nColuna] := CTOD("")
	ElseIf aHeader[nColuna][8] == "L"
		aCols[1][nColuna] := .F.
	ElseIf aHeader[nColuna][8] == "M"
		aCols[1][nColuna] := ""
	EndIf
Next nColuna
dbSelectArea('ZZ4')
dbSetOrder(3)
If _lRet
	If !ZZ4->(dbSeek(XFILIAL("ZZ4")+cdoc+cserie+ccodcli+cloja+ccodpro))
		MsgAlert("Registro nao encontrado, Contate o administrador do sistema","Exclzz4")
		Return()
	EndIf
Else
	If !ZZ4->(dbSeek(XFILIAL("ZZ4")+cdoc+cserie+ccodcli+cloja+ccodpro+cIMEI))
		MsgAlert("Registro nao encontrado, Contate o administrador do sistema","Exclzz4")
		Return()
	EndIf
EndIf
While !ZZ4->(Eof()) .AND. ZZ4->ZZ4_NFENR=cdoc .AND. ZZ4->ZZ4_NFESER=cserie ;
	.AND. ZZ4->ZZ4_CODCLI==ccodcli .AND. ZZ4->ZZ4_LOJA==cloja .AND. ZZ4->ZZ4_CODPRO==ccodpro .AND. Iif(_lRet,.T.,ZZ4->ZZ4_IMEI==cIMEI)
	ncount++
	If ncount > 1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAdiciona mais uma linha no aCols com os campos originais.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aAdd(aCols,Array(Len(aheader)+1))
		For _ni:=1 To Len(aheader)
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
	EndIf
	If !U_VLDTRAV(ZZ4->ZZ4_FILIAL,ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS,{"P","TECAX010","EXCLZZ4"})
		lRet := .F.
	EndIf
	aCols[ncount][Len(aHeader)+1] := .F. // Linha nใo deletada
	aCols[ncount][1]:=ZZ4->ZZ4_CODPRO
	aCols[ncount][2]:=ZZ4->ZZ4_IMEI
	aCols[ncount][3]:=ZZ4->ZZ4_CARCAC
	aCols[ncount][4]:=ZZ4->ZZ4_EMUSER
	aCols[ncount][5]:=ZZ4->ZZ4_VLRUNI
	aCols[ncount][6]:=ZZ4->ZZ4_STATUS
	aCols[ncount][7]:=ZZ4->ZZ4_OPEBGH
	ZZ4->(dbSkip())
EndDo
If !lRet
	MsgAlert(cMsg,"ExclZZ4")
	Return()
EndIf
dbSelectArea("ZZ4") //Cad Lp X Ccusto X Conta
lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,nOpc,cLinhaOk,cTudoOk)
If lRetMod2
	For nLinha := 1 to len(aCols)
		If !aCols[nLinha,len(aHeader)+1]
			U_DelMASS(_nopctip,cdoc,cserie,ccodcli,cloja,aCols[nLinha,1],aCols[nLinha,2],_ctipo,"")
		EndIf
	Next nLinha
Else
	MsgAlert("Voc๊ cancelou a opera็ใo","Exclzz4")
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda   บAutor  ณPaulo Francisco       บ Data ณ  20/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Legenda                                                 บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function Tec010Le()
Local aCor := {;
{"DISABLE"		, "Registro bloqueado"},;
{"BR_BRANCO"	, "Entrada Apontada"},;
{"BR_AMARELO"	, "Entrada Confirmada "},;
{"ENABLE"		, "NFE Gerada"},;
{"BR_AZUL"		, "Em atendimento"},;
{"BR_LARANJA"	, "OS Encerrada"},;
{"BR_MARROM"	, "Saida Lida/Apontada"},;
{"BR_CINZA"		, "Saida Confirmada"},;
{"BR_PRETO"		, "PV Gerado"},;
{"BR_PINK"		, "NFS Gerada"};
}
BrwLegenda("ZZ4",cCadastro,aCor)
Return()