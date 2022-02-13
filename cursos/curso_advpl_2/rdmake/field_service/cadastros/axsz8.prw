#include "rwmake.ch"
#include "topconn.ch"
#define ENTER CHR(10)+CHR(13)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AXSZ8    บAutor  ณ M.Munhoz - ERPPLUS บ Data ณ  26/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function AXSZ8()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea    := GetArea()

Private cAlias    := "SZ8"
Private aRotina   := {}
Private cCadastro := "Cadastro de Sintomas X Solu็๕es"
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrNext  	:= .F.
Private lBlqNext  	:= .F.
Private lUsrAdmi    := .F.

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	
	//Usuarios Bloqueado Nextel - Motorola
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Nextel"
		lBlqNext  := .T.
	EndIf
	
	//Usuarios Nextel - Motorola
	If AllTrim(GRPRetName(aGrupos[i])) == "Nexteladm"
		lUsrNext  := .T.
	EndIf
	
	//Administradores
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Admi"
		U_Access()
	EndIf
Next i

If lBlqNext
	
	If !(lUsrNext .Or. lUsrAdmi)
		
		MsgStop("Usuario nใo autorizado a usar essa rotina", "Bloqueio Usuario")
		Return()
		
	Endif
EndIf

If lUsrNext .Or. lUsrAdmi
	U_SZ8_CFG()
Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta um aRotina proprio                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private aRotina := { {"Pesquisar"   ,"AxPesqui" ,0,1} ,;
	{"Visualizar" ,"AxVisual" ,0,2} ,;
	{"Incluir"    ,"AxInclui" ,0,3} ,;
	{"Alterar"    ,"AxAltera" ,0,4} ,;
	{"Excluir"    ,"AxDeleta" ,0,5} }
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Browser                                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	dbSelectArea(cAlias)
	
	Set Filter to &("@ Z8_CLIENTE <> '2' ")
	
	mBrowse( 6,1,22,75,cAlias)
	
	RestArea(aArea)
	
	Return
	
EndIf

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  12/26/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function VldSintoma()

local _lRet := .t.

if (M->Z8_CLIENTE == 'N' .and. left(M->Z8_CODSINT,1) <> 'N') .or. (M->Z8_CLIENTE == 'M' .and. left(M->Z8_CODSINT,1) <> 'M')
	_lRet := .F.
endif

return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  12/26/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function VldSolucao()

local _lRet := .t.

if (M->Z8_CLIENTE == 'N' .and. left(M->Z8_CODSOLU,1) <> 'N') .or. (M->Z8_CLIENTE == 'M' .and. left(M->Z8_CODSOLU,1) <> 'M')
	_lRet := .F.
endif

return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ F3MSINT  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  26/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina Especifica de F3 na tabela de sintomas x solucoes   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function F3MSINT()

local _cRet 	:= space(8)
local CR		:= chr(13) + chr(10)
local _cQuery	:= ""
local _cArq		:= Criatrab(NIL,.F.)
local nOpc 		:= 0

private oF3Dlg, oGetF3
private aHeader	:= {}
Private aRotina := { {"","",0,1},{"XXX","" ,0,2}}

_cQuery += " SELECT DISTINCT Z8_CLIENTE CLIENTE, Z8_CODSINT SINTOMA, Z8_DESSINT DESCRICAO "
_cQuery += " FROM  " + RetSQLName("SZ8") + " AS Z8 (nolock) "
_cQuery += " WHERE "
_cQuery += "     Z8_FILIAL = '" + xFilial("SZ8") + "' "
_cQuery += " AND Z8_CLIENTE = 'M' "
_cQuery += " AND Z8.D_E_L_E_T_ = ' ' "
_cQuery += " ORDER BY Z8_CLIENTE, Z8_CODSINT "

Tcquery _cQuery New Alias "QRYTAB"

copy to &(_cArq)

QRYTAB->(dbclosearea())

dbUseArea(.T.,,_cArq,"F3TAB",.F.,.F.)

DEFINE MSDIALOG oF3Dlg FROM 0,0 TO 200,400 TITLE "Cadastro de Sintomas - Motorola" PIXEL of oMainWnd

Aadd(aHeader,{ "Cliente",   	"CLIENTE"  , "", 06, 0,"", CHR(0)+CHR(0)+CHR(1), "C", "", "R" } )
Aadd(aHeader,{ "Cod.Sintoma",	"SINTOMA"  , "", 04, 0,"", CHR(0)+CHR(0)+CHR(1), "C", "", "R" } )
Aadd(aHeader,{ "Descricao",		"DESCRICAO", "", 40, 0,"", CHR(0)+CHR(0)+CHR(1), "C", "", "R" } )

oGetF3 	:= MsGetDb():New(1,1,100,150,2,"Allwaystrue","Allwaystrue",,.T.,,,.F.,,"F3TAB","AllwaysTrue",,,oF3Dlg,.T.,.T.)

@ 010,165 BMPBUTTON TYPE 1 ACTION (nOpc:=1,_cRet := F3TAB->SINTOMA ,oF3Dlg:end())
@ 030,165 BMPBUTTON TYPE 2 ACTION oF3Dlg:end()

ACTIVATE MSDIALOG oF3Dlg CENTERED

F3TAB->(dbclosearea())

PUBLIC CRETMSINT := _cRet

Return(nOpc==1)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ8_CFG   บ Autor ณPaulo Lopez         บ Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ------------ CADASTRO SINTOMA X SOLUCAO ------------------- บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SZ8_CFG()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea    := GetArea()

Private cAlias    := "SZ8"
Private aRotina   := {}
Private cCadastro := "Cadastro de Sintomas X Solu็๕es"

/*/
+----------------------------------------------------------------+
| Define Array contendo as Rotinas a executar do programa        |
| ----------- Elementos contidos por dimensao -------------------|
| 1. Nome a aparecer no cabecalho                                |
| 2. Nome da Rotina associada                                    |
| 3. Usado pela rotina                                           |
| 4. Tipo de Transacao a ser efetuada                            |
|                                                                |
| 1 - Pesquisa e Posiciona em um Banco de Dados                  |
| 2 - Simplesmente Mostra os Campos                              |
| 3 - Inclui registros no Bancos de Dados                        |
| 4 - Altera o registro corrente                                 |
| 5 - Remove o registro corrente do Banco de Dados               |
+----------------------------------------------------------------+
/*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Menu                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aRotina, {"Pesquisar"  , "AxPesqui"    	, 0, 1})
aAdd( aRotina, {"Visualizar" , "U_SZ8002VISU"	, 0, 2})
aAdd( aRotina, {"Incluir"    , "U_SZ8002INCL"	, 0, 3})
aAdd( aRotina, {"Alterar"    , "U_SZ8002ALTR"	, 0, 4})
//aAdd( aRotina, {"Excluir"    , "U_SZ8002EXCL"	, 0, 5})
aAdd( aRotina, {"Cad.Solucao", "U_AXSZ81"   	, 0, 5})
aAdd( aRotina, {"Cad.Repair" , "U_AXSZM"	  	, 0, 6})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Browser                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cAlias)
dbSetOrder(1)

dbSelectArea(cAlias)

Set Filter to &("@ Z8_CLIENTE = '2'  AND Z8_CODSINT <> '' ")

mBrowse( 6,1,22,75,cAlias)

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ8002VISUบ Autor ณPaulo Lopez         บ Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ----------------------- VISUALIZAR ------------------------ บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SZ8002VISU(cAlias,nReg,nOpcx)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea     := GetArea()
Local oGetDad
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local lContinua := .T.
Local lQuery    := .F.
Local cCadastro := "Cadastro de Sintomas X Solu็๕es"
Local cQuery    := ""
Local cTrab     := "SZL"
Local bWhile    := {|| .T. }
Local aObjects  := {}
Local aPosObj   := {}
Local aSizeAut  := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem de variaveis de memoria                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SZ8")
dbSetOrder(1)
For nCntFor := 1 To FCount()
	M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
Next nCntFor

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do aHeader                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZL")

While (!Eof() .And. SX3->X3_ARQUIVO == "SZL" )
	If (X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)
		nUsado++
		aAdd(aHeader,{Trim(X3Titulo()),;
		Trim(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do Acols                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SZL")
dbSetOrder(1)

lQuery := .T.
cQuery := "SELECT *,R_E_C_N_O_ SZLRECNO FROM " + RetSqlName("SZL") + " SZL "
cQuery += " WHERE SZL.ZL_FILIAL = '" + xFilial("SZL") + "' "
cQuery += "		AND SZL.ZL_CODSINT = '" + SZ8->Z8_CODSINT + "' "
cQuery += "		AND SZL.ZL_CLIENTE = '" + SZ8->Z8_CLIENTE + "' "
cQuery += "		AND SZL.D_E_L_E_T_ <> '*' "
cQuery += "	ORDER BY " + SqlOrder(SZL->(IndexKey()))
cQuery := ChangeQuery(cQuery)

MemoWrite("SZ802VIS",cQuery)
cTrab  := "SZ802VIS"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)

For nCntFor := 1 To Len(aHeader)
	TcSetField(cTrab,AllTrim(aHeader[nCntFor][2]),aHeader[nCntFor,8],aHeader[nCntFor,4],aHeader[nCntFor,5])
Next nCntFor

SZL->(MsSeek(xFilial("SZL") + SZ8->Z8_CLIENTE + SZ8->Z8_CODSINT))
bWhile := {|| xFilial("SZL") == SZL->ZL_FILIAL ;
.And. AllTrim(SZ8->Z8_CLIENTE) == AllTrim(SZL->ZL_CLIENTE);
.And. AllTrim(SZ8->Z8_CODSINT) == AllTrim(SZL->ZL_CODSINT)}

While (!Eof() .And. Eval(bWhile))
	
	aAdd(aCols, Array(nUsado+1))
	
	For nCntFor := 1 To nUsado
		If (aHeader[nCntFor][10] != "V")
			aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
		Else
			If (lQuery)
				SZL->(dbGoto((cTrab)->SZLRECNO))
			EndIf
			aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
		EndIf
	Next nCntFor
	
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	dbSelectArea(cTrab)
	dbSkip()
EndDo

If (lQuery)
	dbSelectArea(cTrab)
	dbCloseArea()
	dbSelectArea(cAlias)
EndIf

aObjects := {}
aAdd(aObjects, {315, 050, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})

aInfo   := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
aPosObj := MsObjSize(aInfo, aObjects, .T.)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7], 000 TO aSizeAut[6], aSizeAut[5] OF oMainWnd PIXEL
EnChoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)
oGetDad := MSGetDados():New(aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpcx, "AllwaysTrue", "AllwaysTrue", "", .F.)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

RestArea(aArea)

Return (.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ8002INCLบ Autor ณPaulo Lopez         บ Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ------------------- INCLUIR-------------------------------- บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SZ8002INCL(cAlias,nReg,nOpcx)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea     := GetArea()
Local oGetDad
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local cCadastro := "Cadastro de Sintomas X Solu็๕es"
Local cQuery    := ""
Local cTrab     := "SZL"
Local aObjects  := {}
Local aPosObj   := {}
Local aSizeAut  := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem de variaveis de memoria                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SZ8")
dbSetOrder(1)
For nCntFor := 1 To FCount()
	M->&(FieldName(nCntFor)) := CriaVar(FieldName(nCntFor))
Next nCntFor

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do aHeader                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZL")

While (!Eof() .And. SX3->X3_ARQUIVO == "SZL" )
	If (X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)
		nUsado++
		aAdd(aHeader,{Trim(X3Titulo()),;
		Trim(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do Acols                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aCols, Array(nUsado+1))

For nCntFor := 1 To nUsado
	aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
Next nCntFor

aCols[1][Len(aHeader)+1] := .F.

aObjects := {}
aAdd(aObjects, {315, 050, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})

aInfo   := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
aPosObj := MsObjSize(aInfo, aObjects, .T.)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7], 000 TO aSizeAut[6], aSizeAut[5] OF oMainWnd PIXEL
EnChoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)
oGetDad := MSGetDados():New(aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpcx, "AllwaysTrue", "AllwaysTrue", "", .T.,,,, 999)
ACTIVATE MSDIALOG oDlg ON INIT ;
EnchoiceBar(oDlg, {||nOpcA:=If(oGetDad:TudoOk() .And. Obrigatorio(aGets,aTela), 1, 0),;
If(nOpcA==1,oDlg:End(),Nil)},{||oDlg:End()})
	
	If ( nOpcA == 1 )
		Begin Transaction
		SZ802GRV(1)
		If ( __lSX8 )
			ConfirmSX8()
		EndIf
		EvalTrigger()
		End Transaction
	Else
		If ( __lSX8 )
			RollBackSX8()
		EndIf
	EndIf
	
	RestArea(aArea)
	
Return(.T.)	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ8002ALTRบ Autor ณPaulo Lopez         บ Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ----------------------- ALTERAR --------------------------  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SZ8002ALTR(cAlias,nReg,nOpcx)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea     := GetArea()
Local cCadastro := "Cadastro de Sintomas X Solu็๕es"
Local oGetDad
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local lContinua := .T.
Local cQuery    := ""
Local cTrab     := "SZL"
Local bWhile    := {|| .T. }
Local aObjects  := {}
Local aPosObj   := {}
Local aSizeAut  := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem de variaveis de memoria                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SZ8")
dbSetOrder(1)

lContinua := SoftLock("SZ8")

If ( lContinua )
	For nCntFor := 1 To FCount()
		M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem do aHeader                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZL")
	
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SZL" )
		If (X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)
			nUsado++
			aAdd(aHeader, {Trim(X3Titulo()),;
			Trim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT})
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem do Acols                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SZL")
	dbSetOrder(1)
	
	lQuery := .T.
	cQuery := "SELECT *,R_E_C_N_O_ SZLRECNO FROM " + RetSqlName("SZL") + " SZL "
	cQuery += " WHERE SZL.ZL_FILIAL = '" + xFilial("SZL") + "' "
	cQuery += "		AND SZL.ZL_CODSINT = '" + SZ8->Z8_CODSINT + "' "
	cQuery += "		AND SZL.ZL_CLIENTE = '" + SZ8->Z8_CLIENTE + "' "
	cQuery += "		AND SZL.D_E_L_E_T_ <> '*' "
	cQuery += "	ORDER BY " + SqlOrder(SZL->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	
	cTrab  := "SZ802VIS"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)
	
	For nCntFor := 1 To Len(aHeader)
		TcSetField(cTrab, AllTrim(aHeader[nCntFor][2]), aHeader[nCntFor, 8], aHeader[nCntFor, 4], aHeader[nCntFor, 5])
	Next nCntFor
	
	SZL->(MsSeek(xFilial("SZL") + SZ8->Z8_CLIENTE + SZ8->Z8_CODSINT))
	bWhile := {|| xFilial("SZL") == SZL->ZL_FILIAL ;
	.And. AllTrim(SZ8->Z8_CLIENTE) == AllTrim(SZL->ZL_CLIENTE);
	.And. AllTrim(SZ8->Z8_CODSINT) == AllTrim(SZL->ZL_CODSINT)}
	
	While ( !Eof() .And. Eval(bWhile) )
		
		aAdd(aCols, Array(nUsado+1))
		
		For nCntFor := 1 To nUsado
			If (aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
			Else
				If ( lQuery )
					SZL->(dbGoto((cTrab)->SZLRECNO))
				EndIf
				aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
			EndIf
		Next nCntFor
		
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		
		dbSelectArea(cTrab)
		dbSkip()
	EndDo
	
	If (lQuery)
		dbSelectArea(cTrab)
		dbCloseArea()
		dbSelectArea(cAlias)
	EndIf
	
EndIf

If (lContinua)
	
	aObjects := {}
	aAdd(aObjects, {315, 050, .T., .T.})
	aAdd(aObjects, {100, 100, .T., .T.})
	
	aInfo   := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7],00 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
	EnChoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)
	oGetDad := MSGetDados():New(aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpcx, "AllwaysTrue", "AllwaysTrue", "", .T.,,,, 999)
	ACTIVATE MSDIALOG oDlg ON INIT;
	EnchoiceBar(oDlg,{||nOpca := If(oGetDad:TudoOk() .And. Obrigatorio(aGets,aTela), 1, 0),;
	If(nOpcA == 1, oDlg:End(), Nil)}, {||oDlg:End()})
		
		If ( nOpcA == 1 )
			
			Begin Transaction
			SZ802GRV(2)
			If ( __lSX8 )
				ConfirmSX8()
			EndIf
			EvalTrigger()
			End Transaction
		Else
			If ( __lSX8)
				RollBackSX8()
			EndIf
		EndIf
	EndIf
	
	RestArea(aArea)
	
Return(.T.)
		
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ8002EXCLบ Autor ณPaulo Lopez         บ Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ----------------------- EXCLUIR --------------------------- บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SZ8002EXCL(cAlias,nReg,nOpcx)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea     := GetArea()
Local cCadastro := "Cadastro de Menus"
Local oGetDad
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local lContinua := .T.
Local cQuery    := ""
Local cTrab     := "SZL"
Local bWhile    := {|| .T. }
Local aObjects  := {}
Local aPosObj   := {}
Local aSizeAut  := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem de variaveis de memoria                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SZ8")
dbSetOrder(1)

lContinua := SoftLock("SZ8")

If (lContinua)
	For nCntFor := 1 To FCount()
		M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem do aHeader                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZ8")
	
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SZL" )
		If (X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			aAdd(aHeader, {Trim(X3Titulo()),;
			Trim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem do Acols                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SZL")
	dbSetOrder(1)
	
	lQuery := .T.
	cQuery := "SELECT *,R_E_C_N_O_ SZLRECNO FROM " + RetSqlName("SZL") + " SZL "
	cQuery += " WHERE SZL.ZL_FILIAL = '" + xFilial("SZL") + "' "
	cQuery += "		AND SZL.ZL_CODSINT = '" + SZ8->Z8_CODSINT + "' "
	cQuery += "		AND SZL.ZL_CLIENTE = '" + SZ8->Z8_CLIENTE + "' "
	cQuery += "		AND SZL.D_E_L_E_T_ <> '*' "
	cQuery += "	ORDER BY " + SqlOrder(SZL->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	
	cTrab  := "SZ802VIS"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)
	
	For nCntFor := 1 To Len(aHeader)
		TcSetField(cTrab, AllTrim(aHeader[nCntFor][2]), aHeader[nCntFor,8], aHeader[nCntFor,4], aHeader[nCntFor,5])
	Next nCntFor
	
	
	
	SZL->(MsSeek(xFilial("SZL") + SZ8->Z8_CLIENTE + SZ8->Z8_CODSINT))
	bWhile := {|| xFilial("SZL") == SZL->ZL_FILIAL ;
	.And. AllTrim(SZ8->Z8_CLIENTE) == AllTrim(SZL->ZL_CLIENTE);
	.And. AllTrim(SZ8->Z8_CODSINT) == AllTrim(SZL->ZL_CODSINT)}
	
	While (!Eof() .And. Eval(bWhile))
		
		aAdd(aCols, Array(nUsado+1))
		
		For nCntFor := 1 To nUsado
			If (aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
			Else
				If (lQuery)
					SZL->(dbGoto((cTrab)->SZLRECNO))
				EndIf
				aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
			EndIf
		Next nCntFor
		
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		
		dbSelectArea(cTrab)
		dbSkip()
	EndDo
	
	If (lQuery)
		dbSelectArea(cTrab)
		dbCloseArea()
		dbSelectArea(cAlias)
	EndIf
	
EndIf

If (lContinua)
	aObjects := {}
	aAdd(aObjects, {315, 050, .T., .T.})
	aAdd(aObjects, {100, 100, .T., .T.})
	
	aInfo   := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7], 000 TO aSizeAut[6], aSizeAut[5] OF oMainWnd PIXEL
	EnChoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)
	oGetDad := MSGetDados():New(aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpcx, "AllwaysTrue", "AllwaysTrue", "", .F.)
	ACTIVATE MSDIALOG oDlg ON INIT;
	EnchoiceBar(oDlg, {||nOpca:=If(oGetDad:TudoOk(), 1, 0), If(nOpcA == 1, oDlg:End(), Nil)}, {||oDlg:End()})
	
	If ( nOpcA == 1 )
		Begin Transaction
		SZ802GRV(3)
		EvalTrigger()
		End Transaction
	EndIf
	
EndIf

RestArea(aArea)

Return (.T.)	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ802GRV  บ Autor ณPaulo Lopez         บ Data ณ  13/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ-------------------- GRAVAR-------------------------------- บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function SZ802GRV(nOpc)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea     := GetArea()
Local aRegistro := {}
Local cQuery    := ""
Local lGravou   := .F.
Local nCntFor   := 0
Local nCntFor2  := 0
Local nUsado    := Len(aHeader)

If !Empty(M->Z8_CODSINT) .And. !Empty(M->Z8_CODPROM)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Guarda os registros em um array para atualizacao           |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SZL")
	dbSetOrder(1)
	
	cQuery := "SELECT SZL.R_E_C_N_O_ SZLRECNO FROM " + RetSqlName("SZL") + " SZL "
	cQuery += " WHERE SZL.ZL_FILIAL = '" + xFilial("SZL") + "' "
	cQuery += "		AND SZL.ZL_CODSINT = '" + M->Z8_CODSINT + "' "
	cQuery += "		AND SZL.ZL_CLIENTE = '" + M->Z8_CLIENTE + "' "
	cQuery += "		AND SZL.D_E_L_E_T_ <> '*' "
	cQuery += "	ORDER BY " + SqlOrder( SZL->( IndexKey() ) )
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "SZ802GRV", .T., .T. )
	
	dbSelectArea("SZ802GRV")
	While (!Eof())
		aAdd( aRegistro, SZLRECNO)
		dbSelectArea("SZ802GRV")
		dbSkip()
	EndDo
	
	dbSelectArea("SZ802GRV")
	dbCloseArea()
	
	dbSelectArea("SZL")
	
	Do Case
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Inclusao / Alteracao                                       |
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Case nOpc != 3
			For nCntFor := 1 To Len(aCols)
				If ( nCntFor > Len(aRegistro) )
					If ( !aCols[nCntFor][nUsado+1] )
						RecLock("SZL",.T.)
					EndIf
				Else
					SZL->(dbGoto(aRegistro[nCntFor]))
					RecLock("SZL")
				EndIf
				
				If ( !aCols[nCntFor][nUsado+1] )
					lGravou := .T.
					For nCntFor2 := 1 To nUsado
						If ( aHeader[nCntFor2][10] != "V" )
							FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2])
						EndIf
					Next nCntFor2
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//| Grava os campos obrigatorios                               |
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					SZL->ZL_FILIAL 	:= xFilial("SZL")
					SZL->ZL_CLIENTE	:= M->Z8_CLIENTE
					SZL->ZL_CODSINT	:= M->Z8_CODSINT
					SZL->ZL_CODPROB := M->Z8_CODPROM
					
				Else
					If ( nCntFor <= Len(aRegistro) )
						dbDelete()
					EndIf
				EndIf
				
				MsUnLock()
			Next nCntFor
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//| Exclusao                                                   |
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		OtherWise
			For nCntFor := 1 To Len(aRegistro)
				SZL->(dbGoto(aRegistro[nCntFor]))
				RecLock("SZL")
				dbDelete()
				MsUnLock()
			Next nCntFor
	EndCase
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Atualizacao do cabecalho                                   |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SZ8")
	dbSetOrder(1)
	If ( MsSeek( xFilial("SZ8") + M->Z8_CLIENTE + M->Z8_CODSINT))
		RecLock("SZ8")
	Else
		If (lGravou)
			RecLock("SZ8",.T.)
		EndIf
	EndIf
	
	If (!lGravou)
		dbDelete()
	Else
		For nCntFor := 1 To SZ8->(FCount())
			If (FieldName(nCntFor) != "Z8_FILIAL" )
				FieldPut(nCntFor, M->&(FieldName(nCntFor)))
			Else
				SZ8->Z8_FILIAL := xFilial("SZ8")
			EndIf
		Next nCntFor
	EndIf
	
	MsUnLock()
	
	U_Confirma() 
	
Else
	MsgStop("Favor verificar os campos em brancos")
	Return( .F. )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Restaura integridade da rotina                             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aArea)
Set Filter To


Return( .T. )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACCESS    บ Autor ณPaulo Lopez         บ Data ณ  13/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCADASTROS PARA ACESSO DINAMICO                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ACCESS()

Private cPerg       := "AXZZ3"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Cria dicionario de perguntas                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return
Endif

Do Case
	
	Case mv_par01 == 1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//|Modulo para Administradores                                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lUsrAdmi  := .T.
		
	Case mv_par01 == 2
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//|Modulo para Administradores                                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lUsrAdmi  := .F.
		
EndCase	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณPaulo Lopez         บ Data ณ  08/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERA DICIONARIO DE PERGUNTAS                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fCriaSX1()

dbSelectArea("SX1")
dbSetOrder(1)
aSX1 := {}

aAdd(aSx1,{cPerg,"01","Qual Empresa ? ","","","mv_ch1","N",01,0,0,"C","","mv_par01","Nextel/Motorola","","","","","Sony","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Carrega as Perguntas no SX1                                  ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
ValidPerg(aSX1,cPerg)

Return  



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ8_CFG   บ Autor ณPaulo Lopez         บ Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ------------ CADASTRO RAPAIR / ACTIONS -------------------- บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function AXSZ81() 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea    := GetArea()

Private cAlias    := "SZ8"
Private aRotina   := {}
Private cCadastro := "Solu็๕es"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aRotina := { {"Pesquisar"   ,"AxPesqui" ,0,1} ,;
{"Visualizar" ,"AxVisual" ,0,2} ,;
{"Incluir"    ,"AxInclui" ,0,3} ,;
{"Alterar"    ,"AxAltera" ,0,4}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Browser                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cAlias)
dbSetOrder(1)

dbSelectArea(cAlias)

Set Filter to &("@ Z8_CLIENTE = '2' AND Z8_CODSOLU <> ''")

mBrowse( 6,1,22,75,cAlias)

RestArea(aArea)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ8_CFG   บ Autor ณPaulo Lopez         บ Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ------------ CADASTRO RAPAIR / ACTIONS -------------------- บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
user function AXSZM()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea    := GetArea()

Private cAlias    := "SZM"
Private aRotina   := {}
Private cCadastro := "Cadastro de Repair / Action"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aRotina := { {"Pesquisar"   ,"AxPesqui" 	,0,1} ,;
{"Visualizar" ,"AxVisual" 	,0,2} ,;
{"Incluir"    ,"AxInclui" 	,0,3} ,;
{"Alterar"    ,"AxAltera"	,0,4} ,;
{"Confirma"   ,"U_Confirma"	,0,5}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Browser                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cAlias)
dbSetOrder(1)

dbSelectArea(cAlias)

mBrowse( 6,1,22,75,cAlias)

RestArea(aArea)

Return                    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZ8_CFG   บ Autor ณPaulo Lopez         บ Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ------------ CONFIRA ALTERACOES REPAIR -------------------- บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOTOROLA                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function Confirma()                           

Local cQry
Local cQry1
Local cQry2
Local cQry3 
Local cQry4 
Local cQryPb
Local cQryEn
Local cQryGr
Local cQryPn
Local cQryBl

CursorWait()

If Select("QRY") > 0
	QRY->(dbCloseArea())
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

cQry	:= "SELECT DISTINCT ZM.ZM_CODIGO CODIGO " + ENTER 
cQry	+= "FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
cQry	+= "INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
cQry	+= "ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
cQry	+= "WHERE ZM.D_E_L_E_T_ = '' " + ENTER
cQry	+= "AND ZM.ZM_DESCPTB != ZL.ZL_DESCPTB " + ENTER

MemoWrite("axsz800.sql", cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

If !Empty(QRY->CODIGO)
	cQryPb	:= "UPDATE " + RetSqlName("SZL") + ENTER
	cQryPb	+= " SET ZL_DESCPTB = ZM.ZM_DESCPTB " + ENTER
	cQryPb	+= " FROM "+ RetSqlName("SZM") + "  ZM (nolock) "  + ENTER
	cQryPb	+= " INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
	cQryPb	+= " ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
	cQryPb	+= " WHERE ZM.D_E_L_E_T_ = '' " + ENTER
	cQryPb	+= " AND ZM.ZM_DESCPTB != ZL.ZL_DESCPTB " + ENTER
	
	MemoWrite("up_sz800.sql", cQryPb)
	TcSQlExec(cQryPb)
	TCRefresh(RETSQLNAME("SZL"))
EndIf

cQry1	:= "SELECT DISTINCT ZM.ZM_CODIGO CODIGO " + ENTER
cQry1	+= "FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
cQry1	+= "INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
cQry1	+= "ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
cQry1	+= "WHERE ZM.D_E_L_E_T_ = '' " + ENTER
cQry1	+= "AND ZM.ZM_DESCENG != ZL.ZL_DESCENG " + ENTER

MemoWrite("axsz801.sql", cQry1)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry1), "QRY1", .F., .T.)
                              
If !Empty(QRY1->CODIGO)
	cQryEn	:= "UPDATE " + RetSqlName("SZL") + ENTER
	cQryEn	+= " SET ZL_DESCENG = ZM.ZM_DESCENG " + ENTER
	cQryEn	+= " FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
	cQryEn	+= " INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
	cQryEn	+= " ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
	cQryEn	+= " WHERE ZM.D_E_L_E_T_ = '' " + ENTER
	cQryEn	+= " AND ZM.ZM_DESCENG != ZL.ZL_DESCENG " + ENTER
	
	MemoWrite("up_sz801.sql", cQryEn)
	TcSQlExec(cQryEn)
	TCRefresh(RETSQLNAME("SZL"))
EndIf

cQry2	:= "SELECT DISTINCT ZM.ZM_CODIGO CODIGO " + ENTER
cQry2	+= "FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
cQry2	+= "INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
cQry2	+= "ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
cQry2	+= "WHERE ZM.D_E_L_E_T_ = '' " + ENTER
cQry2	+= "AND ZM.ZM_GRAU != ZL.ZL_GRAU " + ENTER

MemoWrite("axsz802.sql", cQry2)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry2), "QRY2", .F., .T.)

If !Empty(QRY2->CODIGO)
	cQryGr	:= "UPDATE " + RetSqlName("SZL") + ENTER
	cQryGr	+= " SET ZL_GRAU = ZM.ZM_GRAU " + ENTER
	cQryGr	+= " FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
	cQryGr	+= " INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
	cQryGr	+= " ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
	cQryGr	+= " WHERE ZM.D_E_L_E_T_ = '' " + ENTER
	cQryGr	+= " AND ZM.ZM_GRAU != ZL.ZL_GRAU " + ENTER
	
	MemoWrite("up_sz802.sql", cQryGr)
	TcSQlExec(cQryGr)
	TCRefresh(RETSQLNAME("SZL"))
EndIf

cQry3	:= "SELECT DISTINCT ZM.ZM_CODIGO CODIGO " + ENTER
cQry3	+= "FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
cQry3	+= "INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
cQry3	+= "ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
cQry3	+= "WHERE ZM.D_E_L_E_T_ = '' " + ENTER
cQry3	+= "AND ZM.ZM_PARTNUM != ZL.ZL_PARTNUM " + ENTER

MemoWrite("axsz803.sql", cQry3)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry3), "QRY3", .F., .T.)

If !Empty(QRY3->CODIGO)
	cQryPn	:= " UPDATE " + RetSqlName("SZL") + ENTER
	cQryPn	+= " SET ZL_PARTNUM = ZM.ZM_PARTNUM " + ENTER
	cQryPn	+= " FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
	cQryPn	+= " INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
	cQryPn	+= " ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
	cQryPn	+= " WHERE ZM.D_E_L_E_T_ = '' " + ENTER
	cQryPn	+= " AND ZM.ZM_PARTNUM != ZL.ZL_PARTNUM " + ENTER
	
	MemoWrite("up_sz803.sql", cQryPn)
	TcSQlExec(cQryPn)
	TCRefresh(RETSQLNAME("SZL"))
EndIf

cQry4	:= "SELECT DISTINCT ZM.ZM_CODIGO CODIGO " + ENTER
cQry4	+= "FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
cQry4	+= "INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
cQry4	+= "ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
cQry4	+= "WHERE ZM.D_E_L_E_T_ = '' " + ENTER
cQry4	+= "AND ZM.ZM_MSBLQL != ZL.ZL_MSBLQL " + ENTER

MemoWrite("axsz804.sql", cQry4)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry4), "QRY4", .F., .T.)

If !Empty(QRY4->CODIGO)
	cQryBl	:= " UPDATE " + RetSqlName("SZL") + ENTER
	cQryBl	+= " SET ZL_MSBLQL = ZM.ZM_MSBLQL " + ENTER
	cQryBl	+= " FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
	cQryBl	+= " INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
	cQryBl	+= " ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
	cQryBl	+= " WHERE ZM.D_E_L_E_T_ = '' " + ENTER
	cQryBl	+= " AND ZM.ZM_MSBLQL != ZL.ZL_MSBLQL " + ENTER
	
	MemoWrite("up_sz804.sql", cQryBl)
	TcSQlExec(cQryBl)
	TCRefresh(RETSQLNAME("SZL"))
EndIf       

cQry5	:= "SELECT DISTINCT ZM.ZM_CODIGO CODIGO " + ENTER
cQry5	+= "FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
cQry5	+= "INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
cQry5	+= "ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
cQry5	+= "WHERE ZM.D_E_L_E_T_ = '' " + ENTER
cQry5	+= "AND ZM.ZM_TRANSAC != ZL.ZL_TRANSAC " + ENTER

MemoWrite("axsz805.sql", cQry5)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry5), "QRY5", .F., .T.)

If !Empty(QRY5->CODIGO)
	cQryTr	:= " UPDATE " + RetSqlName("SZL") + ENTER
	cQryTr	+= " SET ZL_TRANSAC = ZM.ZM_TRANSAC " + ENTER
	cQryTr	+= " FROM "+ RetSqlName("SZM") + "  ZM (nolock) " + ENTER
	cQryTr	+= " INNER JOIN "+RetSqlName("SZL") + " ZL (nolock) " + ENTER
	cQryTr	+= " ON(ZM.ZM_CODIGO = ZL.ZL_CODIGO AND ZM.D_E_L_E_T_ = ZL.D_E_L_E_T_ ) " + ENTER
	cQryTr	+= " WHERE ZM.D_E_L_E_T_ = '' " + ENTER
	cQryTr	+= " AND ZM.ZM_TRANSAC != ZL.ZL_TRANSAC " + ENTER
	
	MemoWrite("up_sz805.sql", cQryTr)
	TcSQlExec(cQryTr)
	TCRefresh(RETSQLNAME("SZL"))
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
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf 
If Select("QRY4") > 0
	QRY4->(dbCloseArea())
EndIf   
If Select("QRY5") > 0
	QRY5->(dbCloseArea())
EndIf

CursorArrow()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZ8_PARTNUMบ Autor ณPaulo Francisco     บ Data ณ  10/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FUNCOES CAMPO SZM->ZV_TRANSAC                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function Z8_PARTNUM()
                    
Local aRotina
Local aOpcoes

Local cOpcoes
Local cZMAcessos

Local nLoop
Local nLoops   
Local cField := "ZM_TRANSAC"

Begin Sequence

	aRotina := Array( GetSx3Cache( cField , "X3_TAMANHO" ) , 2 )
	nLoops	:= Len( aRotina )   
	
	For nLoop := 1 To nLoops
		aRotina[ nLoop , 1 ] := StrZero( nLoop , 2 )
		Do Case
			Case ( nLoop == 1 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IER"  	+ ( " ( Doa )" ) )	
			Case ( nLoop == 2 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IRF" 		+ ( " ( Refurbish Fora Garantia)" ) )	
			Case ( nLoop == 3 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IOO"    	+ ( " ( Doa Fora de Garantia )" ) )	
			Case ( nLoop == 4 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IPC"    	+ ( " ( RPG )" ) )	
			Case ( nLoop == 5 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IPF"    	+ ( " ( RPG )" ) )	
			Case ( nLoop == 6 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IPR"    	+ ( " ( RPG )" ) )	
			Case ( nLoop == 7 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IPT"    	+ ( " ( RPG )" ) )	
			Case ( nLoop == 8 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IR2"    	+ ( " ( Retail )" ) )										
			Case ( nLoop == 9 ) ; 	aRotina[  nLoop , 2 ]	:= ( "IR4"    	+ ( " ( SAM )" ) )	
			Case ( nLoop == 10) ; 	aRotina[  nLoop , 2 ]	:= ( "IFR"    	+ ( " ( Flip Refurbish )" ) )							
			Case ( nLoop == 11) ; 	aRotina[  nLoop , 2 ]	:= ( "IOW"    	+ ( " ( Refurbish Fora de Garantia)" ) )			
			Case ( nLoop == 12) ; 	aRotina[  nLoop , 2 ]	:= ( "ITS"    	+ ( " ( Retail Cosmetico Aprovado)" ) )			
			Case ( nLoop == 13) ; 	aRotina[  nLoop , 2 ]	:= ( "IRR"    	+ ( " ( Refurbish Garantia)" ) )			
			Case ( nLoop == 14) ; 	aRotina[  nLoop , 2 ]	:= ( "IRE"    	+ ( " ( Reparo Garantia CD)" ) )			
			Case ( nLoop == 15) ; 	aRotina[  nLoop , 2 ]	:= ( "IRS"    	+ ( " ( Reparo Garantia LJ)" ) )			
			Case ( nLoop == 16) ; 	aRotina[  nLoop , 2 ]	:= ( "IBS"    	+ ( " ( Refurbish Fora Garantia)" ) )			
			Case ( nLoop == 17) ; 	aRotina[  nLoop , 2 ]	:= ( "IXT"    	+ ( " ( Extensao Garantia I576)" ) )			
			OtherWise           ;	aRotina[  nLoop , 2 ] 	:= "Reservado"
		End Case	
	Next nLoop

	If (IsInGetDados( { cField } ) )
		cZMAcessos := GdFieldGet( cField )
	ElseIf ( IsMemVar( cField ) )
		cZMAcessos := GetMemVar( cField )
	EndIF
                                                                                        	
	aOpcoes		:= {}
	cOpcoes		:= ""
	nLoops 		:= Len( aRotina )
	
	For nLoop := 1 To nLoops
		If ( SubStr( cZMAcessos , nLoop , 1 ) == "X" )
			cZMAcessos += aRotina[ nLoop , 01 ]
		EndIf
		cOpcoes	+= aRotina[ nLoop , 01 ]
		aAdd( aOpcoes , aRotina[ nLoop , 01 ] += ( "-" + aRotina[ nLoop , 02 ] ) )
	Next nLoop

	If f_Opcoes( @cZMAcessos, "Browse Options", aOpcoes, cOpcoes, Nil, Nil, .F., 2, GetSx3Cache( cField , "X3_TAMANHO" ))
		cOpcoes		:= cZMAcessos
		cZMAcessos	:= ""
		nLoops		:= Len( cOpcoes )
		For nLoop := 1 To nLoops Step 2
			If ( SubStr( cOpcoes , nLoop , 2 ) == "**" )
				cZMAcessos += " "
			Else
				cZMAcessos += "X"
			EndIf
		Next nLoop
		SetMemVar( cField, cZMAcessos )
		If IsInGetDados( { cField } )         
			GdFieldPut( cField , cZMAcessos )
		EndIf
	EndIf

End Sequence

Return