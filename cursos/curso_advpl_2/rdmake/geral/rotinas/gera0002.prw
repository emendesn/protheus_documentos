#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERA0002  บAutor  ณThomas Galvใo       บ Data ณ  17/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo Gen้rica de cadastro de Usuแrios                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GerA0002(_aParam)
Local aAllUsers := AllUsers() // A funcao AllUsers() retorna um vetor principal onde cada elemento refere-se a um usuario do sistema,
Local aUser    	:= {}
Local i        	:= 0
Local k        	:= 0
Local j        	:= 0
Local nZ       	:= 0
Local nContMenu := 0
Local aMenu 	:= {}
Local aMenuXnu 	:= {}
Local aGroup 	:= {}
Local aUsrGer 	:= {}
Local aTemp 	:= {}
Local cMenu		:= ""        

DEFAULT _aParam :={"02","02"}

//------------------------------ Seta a empresa e filial-----------------
If ValType(_aParam) != "U"
	If !Empty(_aParam[1]) .and. !Empty(_aParam[2])
		RPCSETTYPE(3)
		If FindFunction('WFPREPENV')
			WfPrepEnv(_aParam[1],_aParam[2])
		Else
		   Prepare Environment Empresa _aParam[1] Filial _aParam[2]  tables "Z98","Z99"
		Endif	
    EndIf
Endif	
//----------------------------------------------------------------------- 		



Private nSX3Id := LenSX3("Z98_IDUSER")
Private nSX3Me := LenSX3("Z98_MENU")
Private nSX3Ro := LenSX3("Z98_ROTINA")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecutando o comando ZAP na tabela Z98 deixando-a exclusiva.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cTabela := RetSqlName("Z98")
cAlias := "TMP"
USE (cTabela) ALIAS (cAlias) EXCLUSIVE NEW VIA "TOPCONN"
If !NetErr()
	ZAP
	USE

ELSE
    _cQuery := " UPDATE "+RetSqlName("Z98")+" SET D_E_L_E_T_='*' WHERE D_E_L_E_T_<>'*' "
    TCSQLEXEC ( _cQuery )
    TCRefresh(RetSqlName("Z98"))

Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecutando o comando ZAP na tabela Z99 deixando-a exclusiva.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cTabela := RetSqlName("Z99")
cAlias := "TMP"
USE (cTabela) ALIAS (cAlias) EXCLUSIVE NEW VIA "TOPCONN"
If !NetErr()
	ZAP
	USE

Else
    _cQuery := " UPDATE "+RetSqlName("Z99")+" SET D_E_L_E_T_='*' WHERE D_E_L_E_T_<>'*' "
    TCSQLEXEC ( _cQuery )
    TCRefresh(RetSqlName("Z99"))

Endif
For i:= 1 to len(aAllUsers)
	For k := 1 To Len(aAllUsers[i][01][10]) // "len" => Retorna o tamanho da string especificada no parametro.
   		aAdd(aUser,aAllUsers[i])
	Next k
Next i
aSort(aUser,,,{ |aVar1,aVar2| aVar1[1][2] < aVar2[1][2]})
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa Usuariosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i:=1 to Len(aUser)  // a letra "i" == 838 usuarios encontrados
	If !aUser[i][01][17] // Usuแrio bloqueado
		PswOrder(1)
		PswSeek(aUser[i][1][11],.t.)
		aSuperior := PswRet(NIL)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime Grupos  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For k:=1 to Len(aUser[i][01][10])  && aArray posicao /1/,/1/,/10/ => codigo de 6 digitos do usuario ex: 000000
			&&Verifica se Grupo eh vazio, pois em casos do usuario nao ter nenhum grupo sera adicionado um elemento ณ
			&&no Array com Space(06) para poder serconsiderado                                                      ณ
			If !Empty(aUser[i][01][10][k])
			    PswOrder(1)
				PswSeek(aUser[i][01][10][k],.f.)
				aAdd(aGroup,PswRet(Nil))
 			EndIf
		Next k
		nContXNU := Len(aUser[i][03]) && Vetor contendo o m๓dulo, o nํvel e o menu do usuแrio.
		For k:=1 To nContXNU &&Len(aModulos)procura todas as rotinas do modulo apontado no for/next
			If Upper(AllTrim(Substr(aUser[i][03][k],3,1)))!="X" .And. Upper(Right(AllTrim(aUser[i][03][k]),3))=="XNU"
				aTemp := aClone(fGetMnu(Substr(aUser[i][03][k],4),aUser[i][01][02],SubStr(cMenu, At('\',cMenu:=(SubStr(aUser[i][03][k] , at("\",aUser[i][03][k] )+1)))+1)))
				For nZ := 1 To Len(aTemp)
					&& sai quando alinha usuario informado no parametro com menu de acesso deste
					aAdd(aMenuXnu, {aTemp[nZ][1],aTemp[nZ][2],aTemp[nZ][3],aTemp[nZ][4],aTemp[nZ][6],aTemp[nZ][7],aTemp[nZ][8] } )
				Next nZ
			EndIf
		Next k
		aAdd(aUsrGer, {	aUser[i][01][01]							,; &&01 User ID
						aUser[i][01][02]							,; &&02 Usuario
						aUser[i][01][04]							,; &&03 Nome Completo
						DTOC(aUser[i][01][06]) 						,; &&04 Validade
						AllTrim(Str(aUser[i][01][07]))				,; &&05 Acessos para Expirar
						If(aUser[i][01][08],"Sim","Nao")			,; &&06 Autorizado a Alterar Senha
						""   										,; &&07 Alterar Senha no Proximo LogOn  If(aUser[i][01][08],"Sim","Nao")
					   	If(!Empty(aSuperior),aSuperior[01][02],"")	,; &&08 Superior
						aUser[i][01][12]                   			,; &&09 Departamento
						aUser[i][01][13]                            ,; &&10 Cargo
						aUser[i][01][14]                            ,; &&11 E-Mail
						AllTrim(Str(aUser[i][01][15])) 				,; &&12 Acessos Simultaneos
						DTOC(aUser[i][01][16])						,; &&13 Ultima Alteracao
						If(aUser[i][01][17],"Sim","Nao") 			,; &&14 Usuario Bloqueado
						AllTrim(STR(aUser[i][01][18]))				,; &&15 Digitos p/o Ano
						""											,; &&16 Idioma
						aUser[i][02][03] 							,; &&17 Diretorio do Relatorio
						aUser[i][02][05]							,; &&18 Acessos
						""											,; &&19 Formato de Impressao
						""  										,; &&20 Ambiente de Impressao
						aUser[i][01][22]							,; &&21 Empresa, filial e matricula
			            aMenuXnu									,;
			            aGroup										})
		GrvZZ9e8(aUsrGer)
	EndIf
	aMenuXnu := {}
	aUsrGer  := {}
Next i
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvZZ9e8  บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvZZ9e8(aUsrGer)
Local nI := 0
Local nJ := 0
Local nx := 0
Local cUser := ""
Local cMenu := ""
Local cRoti := ""
Local aGrMenu := {}
Local lIncZZ9 := .F.
Local lIncZZ8 := .F.
For nI := 1 To Len(aUsrGer)
	dbSelectArea("Z99")
	Z99->(DbSetOrder(1))
	lIncZZ9 := !Z99->(DbSeek( "  "+aUsrGer[nI][1] ))
	&&Grava informa็๕es de Usuแrios
	RecLock("Z99",lIncZZ9)
	 Z99->Z99_FILIAL := "  "
	 Z99->Z99_USERID	:= aUsrGer[nI][1]
	 Z99->Z99_USER		:= aUsrGer[nI][2]
	 Z99->Z99_USNAME	:= aUsrGer[nI][3]
	 Z99->Z99_VALIDA	:= cToD(aUsrGer[nI][4])
	 Z99->Z99_ACEXPI	:= aUsrGer[nI][5]
	 Z99->Z99_ALTSEN	:= aUsrGer[nI][6]
	 Z99->Z99_SUPERI	:= aUsrGer[nI][8]
	 Z99->Z99_DEPART	:= aUsrGer[nI][9]
	 Z99->Z99_CARGO		:= aUsrGer[nI][10]
	 Z99->Z99_EMAIL		:= aUsrGer[nI][11]
	 Z99->Z99_ACSIMU	:= Val(aUsrGer[nI][12])
	 Z99->Z99_BLOQUE	:= aUsrGer[nI][14]
	 Z99->Z99_DIRREL	:= aUsrGer[nI][17]
	 Z99->Z99_ACESSO	:= aUsrGer[nI][18]
	 Z99->Z99_EFMAT	:= aUsrGer[nI][21]
	MsUnlock()
	&&Grava Menus
	aGrMenu := aClone(aUsrGer[nI][22])
	For nJ:=1 To Len(aGrMenu)
	    dbSelectArea("Z98")
	    Z98->(DbSetOrder(1))
		cUser := SubSTR(aUsrGer[nI][1]+Space(nSX3Id),1,nSX3Id)
		cMenu := SubSTR(aGrMenu[nJ][1]+Space(nSX3Me),1,nSX3Me)
		cRoti := SubSTR(aGrMenu[nJ][4]+Space(nSX3Ro),1,nSX3Ro)
	    lIncZZ8 := !(Z98->(dbSeek("  "+cUser+cMenu+cRoti))) //Z98_FILIAL, Z98_IDUSER, Z98_MENU, Z98_ROTINA
		RecLock("Z98",lIncZZ8)
		 Z98->Z98_FILIAL := "  "
		 Z98->Z98_IDUSER	:= cUser
		 Z98->Z98_MENU	:= StrTran(aGrMenu[nJ][1],'\','')
		 Z98->Z98_TITROT	:= aGrMenu[nJ][2]
		 Z98->Z98_ROTINA	:= aGrMenu[nJ][4]
		 Z98->Z98_ACESSO	:= aGrMenu[nJ][5]
		 Z98->Z98_MODULE	:= aGrMenu[nJ][6]
		 Z98->Z98_OWNER	:= cValToChar(aGrMenu[nJ][7])
		MsUnlock()
	Next nJ
Next nI
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetTables บAutor  ณCarlos G. Berganton บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Quebra de Pagina e Imprime Cabecalho                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetTables(aMenu,aTmp,cMod)
Local i
Local nLen := Len(aMenu)
For i := 1 To nLen
	If ValType(aMenu[i,3]) == "A"
		RetTables(aMenu[i,3],@aTmp,cMod)
	Else
		aAdd(aTmp, {cMod, aMenu[i][1][1], aMenu[i][2], aMenu[i][3], aMenu[i][4],aMenu[i][5],aMenu[i][6],aMenu[i][7],aMenu[i][8], aMenu[i][9]})
	EndIf
Next
Return aTmp
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGetMnu   บAutor  ณCarlos G. Berganton บ Data ณ  15/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obtem dados de um arquivo .mnu                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGetMnu(cArq,cUsuario,cMod)
Local   aRet := {}
Local   aMenu:= {}
Private aTmp := {}
aMenu 	:= XNULOAD(cArq)
aRet 	:= RetTables(aMenu,@aTmp, cMod)
Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLenSX3    บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LenSX3(cCampo)
Local aArea := GetArea()
Local nRet	:= 0
dbSelectArea("SX3")
dbSetOrder(2)
SX3->(dbSeek(cCampo))
nRet := SX3->X3_TAMANHO
RestArea(aArea)
Return(nRet)