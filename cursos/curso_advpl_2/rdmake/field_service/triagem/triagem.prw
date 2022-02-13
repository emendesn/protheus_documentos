#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#include "font.ch"
#include "colors.ch"

#define PAD_LEFT            0
#define PAD_RIGHT           1
#define PAD_CENTER          2
#define ENTER chr(13) + chr(10)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Triagem  บ Autor ณPaulo Lopez         บ Data ณ  23/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela para Triagem MOTOROLA / ANHANGUERA                     บฑฑ
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
User Function Triagem()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao de Variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aCores      := {}
Local aArea       := GetArea()

Private cCadastro := "Triagem"
Private cString   := "ZZO"
Private aRotina   := {}
Private nOpcao
Private lgarest   := .F. //Variavel para indicar aparelhos com garantia estendida
Private _lspc433  := .T.
Private _cPsq	  := GetMv("MV_PERSPC3") 				 // Periodo Parametrizados para Especifico SPC0000433 - Motorola
Private _cSpr	  := GetMv("MV_SPC0433") 				 // Aparelhos Parametrizados para Especifico SPC0000433 - Motorola
Private _lspc433  := .F.

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta opcoes de acordo com o tipo de acesso                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aRotina := {{"Pesquisar"             , "AxPesqui"    , 0, 1},;
{"V&isualizar"           	, "AxVisual"					      	, 0, 2},;
{"S&epara็ใo"            	, "U_Triagem2(1,'Separacao')"         	, 0, 3},;
{"Conferencia MA"      		, "U_Triagem2(6,'Conf.MA')"         	, 0, 3},;
{"C&onferencia"          	, "U_Triagem2(2,'Conferencia')"       	, 0, 4},;
{"Se&gregar"            	, "U_Triagem2(3,'Segregar')"          	, 0, 2},;
{"Alterar"   				, "U_Triagem2(4,'Alterar')"				, 0, 4},;
{"Cad. CLA"	            	, "U_TRIAG01"          					, 0, 2},;
{"I&mprimir"        		, "U_MENUDIN"				          	, 0, 2},;
{"L&egenda"              	, "U_Triagem2(5,'Legenda')"           	, 0, 2}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cores da Legenda                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aCores, {"ZZO_STATUS == '0'  .And. ZZO_SEGREG <>  'S'"                      , "ENABLE"    	})    // Triando
aAdd(aCores, {"ZZO_STATUS == '1'  .And. ZZO_SEGREG <>  'S'"                      , "BR_AZUL"   	})    // Separacao Efetuada
aAdd(aCores, {"ZZO_STATUS == '1'  .And. ZZO_SEGREG ==  'S'"                      , "DISABLE"   	})    // Equipamento Segregado
aAdd(aCores, {"ZZO_STATUS == '2'"                                                , "BR_PINK"   	})    // Entrada Massiva BGH
aAdd(aCores, {"ZZO_STATUS == '9'"                                                , "BR_CANCEL" 	})    // Rotina Master Estoque BGH


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do Browse                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cString)
dbSetOrder(1)

mBrowse(6, 1, 22, 75, cString,,,,,, aCores)

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTriagem2  บAutor  ณPaulo Francisco     บ Data ณ25/07/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFuncoes do MBrouse                                          บฑฑ
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

User Function Triagem2(nOpcao, cOpcao)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aCorDesc  	:= {}
Local aArea     	:= GetArea()
Local lOk	    	:= .F.

#IFDEF TOP
	Local 	cZOTemp		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	lQuery    	:= .F.
#ENDIF


Private _bOk      	:= {||nOpc := 1, GravaOK(nOpcao), _oDlgTria:End() }
Private _bCancel  	:= {||nOpc := 0, _oDlgTria:End() .and. Rollbacksx8()}
Private _aDados  	:= {}
Private _aProd   	:= {}
Private _aTemp		:= {}
Private _aTemp1		:= {}
Private _aTemp2		:= {}
Private _aHeader  	:= {}
Private _aHeader1  	:= {}
Private _aHeader2  	:= {}
Private _aColumns 	:= {}
Private _aColumns1 	:= {}
Private _aColumns2 	:= {}
Private _cGara
Private oBrw3
Private oBrw4
Private oPrint
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut  	:= .F.
Private lUsrAdm  	:= .F.
Private lUsrExp		:= .F.
Private cData		:=	DtoS(dDatabase)
Private cOper
Private cRecl
Private cCont		:= 0
Private nStat		:= 0
Private vImei		:= .F.
Private vCarc		:= .F.
Private _lMark   	:= .F.
Private cGrava		:= .F.
Private aCombo  := {"1-REFURBISH-GAR",;
"2-REFURBISH-FOG",;
"3-REPARO-GAR",;
"4-BOUNCE",;
"5-PRATA"}

SetPrvt("oDlg1")
SetPrvt("oFld1")
SetPrvt("oGrp1","oGrp2")
SetPrvt("oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11")
SetPrvt("oSay12","oSay13","oSay14","oSay15","oSay16","oSay17","oSay18","oSay19","oSay20","oSay21","oSay22")
SetPrvt("oSay23","oSay24")
SetPrvt("oGet1","oGet2","oGet3","oGet4","oGet5","oGet6","oGet7","oGet8","oGet9","oGet10","oGet11")
SetPrvt("oGet12","oGet13","oGet14","oGet14","oGet15","oGet16","oGet17","oGet18","oGet19","oGet20","oGet21")
SetPrvt("oMGet1","oMGet2","oMGet3")
SetPrvt("oCBox1","oCBox2")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado
	If AllTrim(GRPRetName(aGrupos[i])) $ "Nextelanha"
		lUsrAut  := .T.
	EndIf
	
	If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores#Nexteladm"
		lUsrAdm  := .T.
		lUsrAut  := .T.
	EndIf
	
	If AllTrim(GRPRetName(aGrupos[i])) $ "Explider"
		lUsrExp  := .T.
	EndIf
	
Next i


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Validacoes Acesso                                                   |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lUsrAdm == .F. .And. (nOpcao == 4)
	MsgStop("Nใo ้ possํvel separar/alterar/conferir/excluir o cadastro!")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Usuario Expedi็ใo                                                   |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lUsrExp == .T. .And. (nOpcao == 3 .Or. nOpcao == 4 .Or. nOpcao == 6)
	
	MsgStop("Usuario sem acesso a essa rotina!")
	Return
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Alteracao                                                           |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nOpcao == 4
	
	If ZZO->ZZO_STATUS == '0'
		AxAltera("ZZO", Recno(), 4)
	EndIf
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Legenda                                                             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nOpcao == 5
	aCorDesc := {{"ENABLE"     	, "Triagem Efetuada" },;
	{"BR_AZUL"		, "Separacao Efetuada"	},;
	{"BR_PINK"		, "Entrada Massiva BGH" },;
	{"BR_CANCEL"	, "Rotina Master Estoque BGH" },;
	{"DISABLE"		, "Equipamento Segregado"	}}
	
	BrwLegenda(cCadastro, "Status", aCorDesc )
	Return ( .T. )
EndIf



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Separacao                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcao == 1
	
	aAdd(_aDados, {CriaVar("ZZO_CODIGO")		          		, .F.})  // Num Sequencial
	aAdd(_aDados, {{CriaVar("ZZO_IMEI")  , Space(TamSX3("ZZ4_IMEI")[1])}  		, .T.})  // IMEI
	aAdd(_aDados, {{CriaVar("ZZO_CARCAC"), Space(20)} 	   		, .T.})  // Carcaca
	aAdd(_aDados, {{CriaVar("ZZO_MODELO"), Space(40)}    		, .T.})  // Modelo
	aAdd(_aDados, {{CriaVar("ZZO_GARANT"), Space(01)}			, .T.})  // Garantia
	aAdd(_aDados, {CriaVar("ZZO_BOUNCE")    					, .T.})  // Bounce
	aAdd(_aDados, {CriaVar("ZZO_NVEZ")    						, .T.})  // Numero de Vezes
	aAdd(_aDados, {CriaVar("ZZO_DBOUNC")    					, .T.})  // Numero dias Bounce
	aAdd(_aDados, {CriaVar("ZZO_OPBOUN")    					, .T.})  // Operacao
	aAdd(_aDados, {CriaVar("ZZO_RECLIC")    					, .T.})  // Codigo Reclamacao do Cliente
	aAdd(_aDados, {CriaVar("ZZO_DTSEPA")    					, .T.})  // Data Triagem
	aAdd(_aDados, {CriaVar("ZZO_HRSEPA")    					, .T.})  // Hora Triagem Separacao
	aAdd(_aDados, {CriaVar("ZZO_USRSEP")    					, .T.})  // Usuario Triagem Separacao
	aAdd(_aDados, {CriaVar("ZZO_STATUS")    					, .T.})  // Status Equipamento
	aAdd(_aDados, {CriaVar("ZZO_REFGAR")    					, .T.})  // Refurbish ou garantia
	aAdd(_aDados, {CriaVar("ZZO_DESTIN")    					, .T.})  // Codigo Destino
	aAdd(_aDados, {CriaVar("ZZO_DTDEST")    					, .T.})  // Data Triagem  Destino
	aAdd(_aDados, {CriaVar("ZZO_HRDEST")    					, .T.})  // Hora Triagem  Destino
	aAdd(_aDados, {CriaVar("ZZO_USRDES")    					, .T.})  // Usuario Triagem  Destino
	aAdd(_aDados, {CriaVar("ZZO_NUMCX")    						, .T.})  // Numero da Caixa
	aAdd(_aDados, {CriaVar("ZZO_IMPETI")    					, .T.})  // Imprime Etiqueta
	aAdd(_aDados, {CriaVar("ZZO_COETMA")    					, .T.})  // Codigo Etiqueta Master
	aAdd(_aDados, {CriaVar("ZZO_DTCOFE")    					, .T.})  // Data Triagem  Conferencia
	aAdd(_aDados, {CriaVar("ZZO_HRCOFE")    					, .T.})  // Hora Triagem  Conferencia
	aAdd(_aDados, {CriaVar("ZZO_USRCOF")    					, .T.})  // Usuario Triagem  Conferen
	aAdd(_aDados, {{CriaVar("ZZO_GAREST"), Space(01)}			, .T.})  // Garantia Estendida
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Conferencia                                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ElseIf nOpcao == 2
	
	aAdd(_aDados, {CriaVar("ZZO_CODIGO")          				, .F.})  // Num Sequencial
	aAdd(_aDados, {{CriaVar("ZZO_IMEI")  , Space(TamSX3("ZZ4_IMEI")[1])}  		, .T.})  // IMEI
	aAdd(_aDados, {{CriaVar("ZZO_CARCAC"), Space(20)} 	   		, .T.})  // Carcaca
	aAdd(_aDados, {{CriaVar("ZZO_MODELO"), Space(40)}    		, .T.})  // Modelo
	aAdd(_aDados, {{CriaVar("ZZO_GARANT"), Space(01)}			, .T.})  // Garantia
	aAdd(_aDados, {CriaVar("ZZO_BOUNCE")    					, .T.})  // Bounce
	aAdd(_aDados, {CriaVar("ZZO_NVEZ")    						, .T.})  // Numero de Vezes
	aAdd(_aDados, {CriaVar("ZZO_DBOUNC")    					, .T.})  // Numero dias Bounce
	aAdd(_aDados, {CriaVar("ZZO_OPBOUN")    					, .T.})  // Operacao
	aAdd(_aDados, {CriaVar("ZZO_RECLIC")    					, .T.})  // Codigo Reclamacao do Cliente
	aAdd(_aDados, {CriaVar("ZZO_DTSEPA")    					, .T.})  // Data Triagem
	aAdd(_aDados, {CriaVar("ZZO_HRSEPA")    					, .T.})  // Hora Triagem Separacao
	aAdd(_aDados, {CriaVar("ZZO_USRSEP")    					, .T.})  // Usuario Triagem Separacao
	aAdd(_aDados, {CriaVar("ZZO_STATUS")    					, .T.})  // Status Equipamento
	aAdd(_aDados, {CriaVar("ZZO_REFGAR")    					, .T.})  // Refurbish ou garantia
	aAdd(_aDados, {CriaVar("ZZO_DESTIN")     					, .T.})  // Codigo Destino
	aAdd(_aDados, {CriaVar("ZZO_DTDEST")    					, .T.})  // Data Triagem  Destino
	aAdd(_aDados, {CriaVar("ZZO_HRDEST")    					, .T.})  // Hora Triagem  Destino
	aAdd(_aDados, {CriaVar("ZZO_USRDES")    					, .T.})  // Usuario Triagem  Destino
	aAdd(_aDados, {GetSXENum("ZZO","ZZO_NUMCX")					, .F.})  // Numero da Caixa
	aAdd(_aDados, {CriaVar("ZZO_IMPETI")    					, .T.})  // Imprime Etiqueta
	aAdd(_aDados, {CriaVar("ZZO_COETMA")		    			, .F.})  // Codigo Etiqueta Master
	aAdd(_aDados, {CriaVar("ZZO_DTCOFE")    					, .T.})  // Data Triagem  Conferencia
	aAdd(_aDados, {CriaVar("ZZO_HRCOFE")    					, .T.})  // Hora Triagem  Conferencia
	aAdd(_aDados, {CriaVar("ZZO_USRCOF")    					, .T.})  // Usuario Triagem  Conferen
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Segregar Equipamentos                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ElseIf nOpcao == 3
	
	aAdd(_aDados, {ZZO->ZZO_CODIGO     		       				, .F.})  // Num Sequencial
	aAdd(_aDados, {ZZO->ZZO_IMEI  		  						, .F.})  // IMEI
	aAdd(_aDados, {ZZO->ZZO_CARCAC  		            		, .F.})  // Carcaca
	aAdd(_aDados, {ZZO->ZZO_MODELO  	                		, .T.})  // Modelo
	aAdd(_aDados, {ZZO->ZZO_GARANT  	            			, .F.})  // Garantia
	aAdd(_aDados, {ZZO->ZZO_BOUNCE 		     					, .F.})  // Bounce
	aAdd(_aDados, {ZZO->ZZO_NVEZ  		   						, .F.})  // Numero de Vezes
	aAdd(_aDados, {ZZO->ZZO_DBOUNC  	    					, .F.})  // Numero dias Bounce
	aAdd(_aDados, {ZZO->ZZO_OPBOUN  	    					, .F.})  // Operacao
	aAdd(_aDados, {ZZO->ZZO_RECLIC 	    	 					, .F.})  // Codigo Reclamacao do Cliente
	aAdd(_aDados, {ZZO->ZZO_DTSEPA  	    					, .F.})  // Data Triagem
	aAdd(_aDados, {ZZO->ZZO_HRSEPA  	    					, .F.})  // Hora Triagem Separacao
	aAdd(_aDados, {ZZO->ZZO_USRSEP		      					, .F.})  // Usuario Triagem Separacao
	aAdd(_aDados, {ZZO->ZZO_STATUS  	    					, .F.})  // Status Equipamento
	aAdd(_aDados, {ZZO->ZZO_REFGAR  	    					, .F.})  // Refurbish ou garantia
	aAdd(_aDados, {ZZO->ZZO_DESTIN  	     					, .T.})  // Codigo Destino
	aAdd(_aDados, {ZZO->ZZO_DTDEST  	    					, .F.})  // Data Triagem  Destino
	aAdd(_aDados, {ZZO->ZZO_HRDEST  	    					, .F.})  // Hora Triagem  Destino
	aAdd(_aDados, {ZZO->ZZO_USRDES  	    					, .F.})  // Usuario Triagem  Destino
	aAdd(_aDados, {ZZO->ZZO_NUMCX  								, .F.})  // Numero da Caixa
	aAdd(_aDados, {ZZO->ZZO_IMPETI  	    					, .F.})  // Imprime Etiqueta
	aAdd(_aDados, {ZZO->ZZO_COETMA  			    			, .F.})  // Codigo Etiqueta Master
	aAdd(_aDados, {ZZO->ZZO_DTCOFE		      					, .F.})  // Data Triagem  Conferencia
	aAdd(_aDados, {ZZO->ZZO_HRCOFE  	    					, .F.})  // Hora Triagem  Conferencia
	aAdd(_aDados, {ZZO->ZZO_USRCOF  	    					, .F.})  // Usuario Triagem  Conferen
	aAdd(_aDados, {ZZO->ZZO_GAREST  	            			, .F.})   // Garantia Estendida
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Conferencia MA                                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ElseIf nOpcao == 6
	
	aAdd(_aDados, {CriaVar("ZZO_CODIGO")          				, .F.})  // Num Sequencial
	aAdd(_aDados, {{CriaVar("ZZO_IMEI")  , Space(TamSX3("ZZ4_IMEI")[1])}  		, .T.})  // IMEI
	aAdd(_aDados, {CriaVar("ZZO_CARCAC")             	   		, .F.})  // Carcaca
	aAdd(_aDados, {CriaVar("ZZO_MODELO")                		, .F.})  // Modelo
	aAdd(_aDados, {CriaVar("ZZO_GARANT")            			, .F.})  // Garantia
	aAdd(_aDados, {CriaVar("ZZO_BOUNCE")    					, .F.})  // Bounce
	aAdd(_aDados, {CriaVar("ZZO_NVEZ")    						, .F.})  // Numero de Vezes
	aAdd(_aDados, {CriaVar("ZZO_DBOUNC")    					, .F.})  // Numero dias Bounce
	aAdd(_aDados, {CriaVar("ZZO_OPBOUN")    					, .F.})  // Operacao
	aAdd(_aDados, {CriaVar("ZZO_RECLIC")    					, .F.})  // Codigo Reclamacao do Cliente
	aAdd(_aDados, {CriaVar("ZZO_DTSEPA")    					, .F.})  // Data Triagem
	aAdd(_aDados, {CriaVar("ZZO_HRSEPA")    					, .F.})  // Hora Triagem Separacao
	aAdd(_aDados, {CriaVar("ZZO_USRSEP")    					, .F.})  // Usuario Triagem Separacao
	aAdd(_aDados, {CriaVar("ZZO_STATUS")    					, .F.})  // Status Equipamento
	aAdd(_aDados, {CriaVar("ZZO_REFGAR")    					, .F.})  // Refurbish ou garantia
	aAdd(_aDados, {CriaVar("ZZO_DESTIN")     					, .F.})  // Codigo Destino
	aAdd(_aDados, {CriaVar("ZZO_DTDEST")    					, .F.})  // Data Triagem  Destino
	aAdd(_aDados, {CriaVar("ZZO_HRDEST")    					, .F.})  // Hora Triagem  Destino
	aAdd(_aDados, {CriaVar("ZZO_USRDES")    					, .F.})  // Usuario Triagem  Destino
	aAdd(_aDados, {CriaVar("ZZO_NUMCX")							, .F.})  // Numero da Caixa
	aAdd(_aDados, {CriaVar("ZZO_IMPETI")    					, .F.})  // Imprime Etiqueta
	aAdd(_aDados, {CriaVar("ZZO_COETMA")		    			, .F.})  // Codigo Etiqueta Master
	aAdd(_aDados, {CriaVar("ZZO_DTCOFE")    					, .F.})  // Data Triagem  Conferencia
	aAdd(_aDados, {CriaVar("ZZO_HRCOFE")    					, .F.})  // Hora Triagem  Conferencia
	aAdd(_aDados, {CriaVar("ZZO_USRCOF")    					, .F.})  // Usuario Triagem  Conferen
	aAdd(_aDados, {{CriaVar("ZZO_SYMPTO"), Space(05)}			, .T.})  // Problem Fault
	aAdd(_aDados, {{CriaVar("ZZO_ACTION"), Space(05)}			, .T.})  // Repair Cod
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Apresenta o MarkBrowse para o usuario                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcao == 1
	_oDlgTria          	:= MSDialog():New(000, 000, 600, 1400, "Triagem - Separa็ใo GAF/FOG" ,,,,,,,, oMainWnd, .T.)
	_oDlgTria:lCentered 	:= .T.
ElseIf nOpcao == 2
	_oDlgTria          	:= MSDialog():New(000, 000, 600, 1400, "Conferencia - Destino " ,,,,,,,, oMainWnd, .T.)
	_oDlgTria:lCentered 	:= .T.
	
ElseIf nOpcao == 3
	_oDlgTria          	:= MSDialog():New(000, 000, 600, 1400, "Segregar Equipamentos " ,,,,,,,, oMainWnd, .T.)
	_oDlgTria:lCentered 	:= .T.
	
ElseIf nOpcao == 6
	_oDlgTria          	:= MSDialog():New(000, 000, 600, 1400, "Conferencia - MA " ,,,,,,,, oMainWnd, .T.)
	_oDlgTria:lCentered 	:= .T.
Endif

If nOpcao == 1 .Or. nOpcao == 2 .Or. nOpcao == 6 .Or. nOpcao == 3
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Desenha os GroupBoxes                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	_oGrpo1 := TGroup():New(016, 003, 293, 698,, _oDlgTria,,, .T.)
	_oGrpo2 := TGroup():New(018, 004, 100, 696,, _oDlgTria,,, .T.)
	_oGrpo3 := TGroup():New(020, 343, 035, 483,, _oDlgTria,,, .T.)
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Iformacoes Adicionais                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nOpcao == 1
	
	oSay1      			:= TSay():New( 021,006,{||"Modelo"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1      			:= TGet():New( 020,038,{|u| If(PCount()>0,_aDados[04,01,01]:=u,_aDados[04,01,01])},_oGrpo2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,,.F.,"SB1TRI","_aDados[04,01,01]",,)
	oGet2     			:= TGet():New( 020,111,{|u| If(PCount()>0,_aDados[04,01,02]:=u,_aDados[04,01,02])},_oGrpo2,141,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_aDados[04,01,02]",,)
	oGet1:bValid 		:= {|| !Empty(Posicione("SB1",1,xFilial("SB1")+_aDados[04,01,01],"B1_COD"))}
	oGet1:bLostFocus 	:= {|| _aDados[04,01,02] := Posicione("SB1",1,xFilial("SB1")+_aDados[04,01,01],"B1_DESC")}
	
	oSay2  				:= TSay():New( 041,006,{||"Carca็a"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	oGet3  				:= TGet():New( 040,038,{|u| If(PCount()>0,_aDados[03,01,02]:=u,_aDados[03,01,02])},_oGrpo2,055,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGet3:bValid 		:= {|| Valida(nOpcao,.F.,.T.)}
	oGet3:bLostFocus	:= {||  oBrw3:Refresh()}
	
	oSay3  				:= TSay():New( 061,006,{||"IMEI"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	oGet4  				:= TGet():New( 060,038,{|u| If(PCount()>0,_aDados[02,01,02]:=u,_aDados[02,01,02])},_oGrpo2,052,009,'@E 999999999999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_aDados[02,01,01]",,)
	oGet4:bValid 		:= {|| Valida(nOpcao,.T.,.F.)}
	oGet4:bLostFocus	:= {|| oGet3:Refresh(), oBrw3:Refresh()}
	
	oSay4  				:= TSay():New( 022,300,{||"Garantia S/N"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,050)
	oSay4  				:= TSay():New( 022,350,{|| Iif(!Empty(Alltrim(_aDados[05,01,02])), Iif(_aDados[05,01,02] == 'S', "GAR - Garantia",IIF(lgarest,"FOG - Fora Garantia / Ext. Garantia Motorola","FOG - Fora Garantia")),"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,150,150)
	
	oSay5  				:= TSay():New( 022,500,{||"Ext. Garantia"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,015)
	oSay5  				:= TSay():New( 022,530,{|| Iif(!Empty(Alltrim(_aDados[05,01,02])), Iif(lgarest , "SIM", "NAO"),"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,025,025)
	
	oSay6  				:= TSay():New( 041,300,{||"Bounce S/N"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,015)
	oSay6  				:= TSay():New( 041,335,{|| Iif(!Empty(Alltrim(_aDados[06,01])), Iif(_aDados[06,01] == 'S' .And. _aDados[07,01] <= '120' , "SIM - Qtd Dias: " + TransForm(_aDados[07,01], "@E 999"), "NAO - Qtd Dias: " + Transform(_aDados[07,01], "@E 999")),"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,050,035)
	
	oSay7  				:= TSay():New( 061,300,{||"Ultima Opera็ใo"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,015)
	oSay7  				:= TSay():New( 061,325,{|| Iif(!Empty(Alltrim(cOper)), cOper,"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,085)
	
	oSay8  				:= TSay():New( 081,300,{||"Defeito Reclamado"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,015)
	oSay8  				:= TSay():New( 081,325,{|| Iif(!Empty(Alltrim(cRecl)), cRecl,"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,085)
	
ElseIf nOpcao == 2
	
	oSay9     			:= TSay():New( 021,006,{||"Destino"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oCBox1     			:= TComboBox():New( 020,038,{|u| If(PCount()>0,_aDados[16,01]:=u,_aDados[16,01])},Iif(_aDados[16,01]=="1", {"BGH","NEXTEL"}, {"NEXTEL","BGH"}),060,010,_oGrpo2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,)
	
	oSay10     			:= TSay():New( 041,006,{||"Opera็ใo"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oCBox2     			:= TComboBox():New( 040,038,{|u| If(PCount()>0,_aDados[15,01]:=u,"_aDados[15,01]")},aCombo,060,010,_oGrpo2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,)
  
	oSay11  			:= TSay():New( 061,006,{||"IMEI"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	oGet5  				:= TGet():New( 060,038,{|u| If(PCount()>0,_aDados[02,01,02]:=u,_aDados[02,01,02])},_oGrpo2,052,009,'@E 999999999999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_aDados[02,01,01]",,)
	oGet5:bValid 		:= {|| Valida(nOpcao,.T.,.F.) }
	oGet5:bLostFocus	:= {|| oBrw4:Refresh()}
	
	
	oSay12 				:= TSay():New( 022,345,{||"Caixa"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,025)
	oSay13 				:= TSay():New( 022,385,{|| _aDados[20,01]},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,045)
	//oSay13 				:= TSay():New( 022,385,{|u| If(PCount()>0,_aDados[02,01,02]:=u,space(20))},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,045)
	
	oSay14 				:= TSay():New( 041,345,{||"Contagem"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,025)
	oSay15 				:= TSay():New( 041,385,{|| cCont},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,045)
	
	oSay16 				:= TSay():New( 061,345,{||"Cod. Etq. Master"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,025)
	oSay17 				:= TSay():New( 061,385,{|| _aDados[20,01]},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,045)
	//oSay17 				:= TSay():New( 061,385,{|u| If(PCount()>0,_aDados[02,01,02]:=u,space(20))},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,045)
	
ElseIf nOpcao == 3
	
	oSay18     			:= TSay():New( 021,006,{||"Modelo"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet6      			:= TGet():New( 020,038,{|u| If(PCount()>0,_aDados[04,01]:=u,_aDados[04,01])},_oGrpo2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,,.F.,"","_aDados[04,01,01]",,)
	
	oSay19 				:= TSay():New( 041,006,{||"Carca็a"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	oGet7  				:= TGet():New( 040,038,{|u| If(PCount()>0,_aDados[03,01]:=u,_aDados[03,01])},_oGrpo2,055,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay20 				:= TSay():New( 061,006,{||"IMEI"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	oGet8  				:= TGet():New( 060,038,{|u| If(PCount()>0,_aDados[02,01]:=u,_aDados[02,01])},_oGrpo2,052,009,'@E 999999999999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_aDados[02,01,01]",,)
	
	oSay21 				:= TSay():New( 022,345,{||"Garantia S/N"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,050)
	oSay9  				:= TSay():New( 022,385,{|| Iif(!Empty(Alltrim(_aDados[05,01])), Iif(_aDados[05,01] == 'S', "GAR - Garantia", IIF(lgarest,"FOG - Fora Garantia / Ext. Garantia Motorola","FOG - Fora Garantia")),"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,160,160)
	
	oSay22				:= TSay():New( 022,500,{||"Ext. Garantia"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,015)
	oSay10 				:= TSay():New( 022,530,{|| Iif(!Empty(Alltrim(_aDados[05,01])), Iif(lgarest , "SIM", "NAO"),"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,025,025)
	
	
	oSay23 				:= TSay():New( 041,345,{||"Bounce S/N"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,015)
	oSay11 				:= TSay():New( 041,385,{|| Iif(!Empty(_aDados[06,01]), Iif(_aDados[06,01] == 'S' .And. StrZero(_aDados[07,01],3) <= '120' , "SIM - Qtd Dias: " + TransForm(_aDados[07,01], "@E 999"), "NAO - Qtd Dias: " + Transform(_aDados[07,01], "@E 999")),"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,050,035)
	
	oSay24 				:= TSay():New( 061,345,{||"Ultima Opera็ใo"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,015)
	oSay12 				:= TSay():New( 061,385,{|| Iif(!Empty(Alltrim(_aDados[09,01])), Alltrim(_aDados[09,01]),"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,085)
	
	oSay25 				:= TSay():New( 081,345,{||"Defeito Reclamado"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,015)
	oSay13 				:= TSay():New( 081,385,{|| Iif(!Empty(Alltrim(_aDados[10,01])), Alltrim(_aDados[10,01]),"") },_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_GREEN,080,085)
	
ElseIf nOpcao == 6
	
	oSay26    			:= TSay():New( 021,006,{||"Problem Fault"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet09     			:= TGet():New( 020,038,{|u| If(PCount()>0,_aDados[26,01,01]:=u,_aDados[26,01,01])},_oGrpo2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,,.F.,"","_aDados[26,01,01]",,)
	oGet10     			:= TGet():New( 020,111,{|u| If(PCount()>0,_aDados[26,01,02]:=u,_aDados[26,01,02])},_oGrpo2,141,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_aDados[26,01,02]",,)
	oGet09:bValid 		:= {|| Iif(Len(AllTrim(_aDados[26,01,01])) > 0,!Empty(Posicione("SX5",1,xFilial("SX5")+"W7"+ AllTrim(_aDados[26,01,01]),"X5_DESCRI")),.F.)}
	oGet09:bLostFocus 	:= {|| _aDados[26,01,02] := Posicione("SX5",1,xFilial("SX5")+"W7"+ AllTrim(_aDados[26,01,01]),"X5_DESCRI")}
	
	oSay27 				:= TSay():New( 041,006,{||"Repair Cod."},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	oGet12 				:= TGet():New( 040,038,{|u| If(PCount()>0,_aDados[27,01,01]:=u,_aDados[27,01,01])},_oGrpo2,055,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,,.F.,"","_aDados[27,01,01]",,)
	oGet13     			:= TGet():New( 040,111,{|u| If(PCount()>0,_aDados[27,01,02]:=u,_aDados[27,01,02])},_oGrpo2,141,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_aDados[27,01,02]",,)
	oGet12:bValid 		:= {|| Iif(Len(AllTrim(_aDados[27,01,01])) > 0,!Empty(Posicione("SZM",2,xFilial("SZM") + AllTrim(_aDados[27,01,01]),"ZM_DESCPTB")),.F.)}
	oGet12:bLostFocus 	:= {|| _aDados[27,01,02] := Posicione("SZM",2,xFilial("SZM") + AllTrim(_aDados[27,01,01]),"ZM_DESCPTB")}
	
	oSay28 				:= TSay():New( 061,006,{||"IMEI"},_oGrpo2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	oGet14 				:= TGet():New( 060,038,{|u| If(PCount()>0,_aDados[02,01,02]:=u,_aDados[02,01,02])},_oGrpo2,052,009,'@E 999999999999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_aDados[02,01,01]",,)
	oGet14:bValid 		:= {|| Iif(!Empty(AllTrim(_aDados[02,01,02])),Valida(nOpcao,.T.,.T.),.F.), oGet14:Refresh()}
	oGet14:bLostFocus	:= {|| oBrw5:Refresh()}
	
Endif

If nOpcao == 1
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Estrutura do MarkBrowse                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	aAdd(_aHeader , { "Modelo", "IMEI", "CARCAวA", "Bounce", "Reclama็ใo", "Dt. Separa็ใo", "Hr. Separa็ใo", "Usuario","Gar Estendida"})
	aAdd(_aColumns, { 40, 40, 40, 40, 40, 40, 40, 40,40})
	
	If Len(_aTemp) < 1
		aAdd (_aTemp,{'', '', '','','','','','','',''})
	EndIf
	
ElseIf nOpcao == 2
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Estrutura do MarkBrowse                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	aAdd(_aHeader1 , { "Modelo", "IMEI", "CARCAวA", "Bounce", "Reclama็ใo", "Dt. Conferencia", "Hr. Conferencia", "Usuario"})
	aAdd(_aColumns1, { 60, 80, 60, 40, 40, 40, 40, 40})
	
	
	If Len(_aTemp1) < 1
		aAdd (_aTemp1,{'', '', '','','','','',''})
	EndIf
	
ElseIf nOpcao == 6
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Estrutura do MarkBrowse                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	aAdd(_aHeader2 , { "IMEI", "Cod. Prob. Fault", "Desc. Prob. Fault", "Cod. Repair", "Desc. Repair","Dt. Conferencia", "Hr. Conferencia", "Usuario"})
	aAdd(_aColumns2, { 80, 80,80, 80, 80, 60, 60, 60})
	
	
	If Len(_aTemp2) < 1
		aAdd (_aTemp2,{'', '', '','','','','',''})
	EndIf
	
EndIf

If nOpcao == 1
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Desenha o MarkBrowse.                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	oBrw3 := TWBrowse():New(110, 005, 693, 180,, _aHeader[1], _aColumns[1], _oGrpo1,,,,,,,,,,,,,, .T.)
	oBrw3:SetArray(_aTemp)
	oBrw3:bLine := {|| {;
	_aTemp[oBrw3:nAt][01],;
	_aTemp[oBrw3:nAt][02],;
	_aTemp[oBrw3:nAt][03],;
	_aTemp[oBrw3:nAt][04],;
	_aTemp[oBrw3:nAt][05],;
	TransForm(Stod(_aTemp[oBrw3:nAt][06]), "@E 99/99/99"),;
	_aTemp[oBrw3:nAt][07],;
	_aTemp[oBrw3:nAt][08],;
	_aTemp[oBrw3:nAt][09]}}
	
	oBrw3:lAdJustColSize := .F.
	oBrw3:lColDrag       := .F.
	oBrw3:lMChange       := .F.
	oBrw3:lHScroll       := .T.
	oBrw3:Refresh()
	
ElseIf nOpcao == 2
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Desenha o MarkBrowse.                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	oBrw4 := TWBrowse():New(110, 005, 693, 180,, _aHeader1[1], _aColumns1[1], _oGrpo1,,,,,,,,,,,,,, .T.)
	oBrw4:SetArray(_aTemp1)
	oBrw4:bLine := {|| {;
	_aTemp1[oBrw4:nAt][01],;
	_aTemp1[oBrw4:nAt][02],;
	_aTemp1[oBrw4:nAt][03],;
	_aTemp1[oBrw4:nAt][04],;
	_aTemp1[oBrw4:nAt][05],;
	TransForm(Stod(_aTemp1[oBrw4:nAt][06]), "@E 99/99/99"),;
	_aTemp1[oBrw4:nAt][07],;
	_aTemp1[oBrw4:nAt][08]}}
	
	oBrw4:lAdJustColSize := .F.
		oBrw4:lColDrag       := .F.
	oBrw4:lMChange       := .F.
	oBrw4:lHScroll       := .T.
	
ElseIf nOpcao == 6
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Desenha o MarkBrowse.                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	oBrw5 := TWBrowse():New(110, 005, 693, 180,, _aHeader2[1], _aColumns2[1], _oGrpo1,,,,,,,,,,,,,, .T.)
	oBrw5:SetArray(_aTemp2)
	oBrw5:bLine := {|| {;
	_aTemp2[oBrw5:nAt][01],;
	_aTemp2[oBrw5:nAt][02],;
	_aTemp2[oBrw5:nAt][03],;
	_aTemp2[oBrw5:nAt][04],;
	_aTemp2[oBrw5:nAt][05],;
	TransForm(Stod(_aTemp2[oBrw5:nAt][06]), "@E 99/99/99"),;
	_aTemp2[oBrw5:nAt][07],;
	_aTemp2[oBrw5:nAt][08]}}
	
	oBrw5:lAdJustColSize := .F.
	oBrw5:lColDrag       := .F.
	oBrw5:lMChange       := .F.
	oBrw5:lHScroll       := .T.
	
EndIf

If nOpcao == 1 .Or. nOpcao == 2 .Or. nOpcao == 6 .or. nOpcao == 3
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Desenha o MarkBrowse.                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	ACTIVATE MSDIALOG _oDlgTria ON INIT EnchoiceBar(_oDlgTria,_bOk,_bCancel) CENTERED
	
EndIf
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGarantia  บAutor  ณPaulo Francisco     บ Data ณ25/07/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCalcula Grantia pela Carcaca                                บฑฑ
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

Static Function Garantia()

Local cQry
Local cDef

lgarest :=.F.

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calcula Garantia Pela Carcaca com Data Base                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQry	:= " SELECT DATEDIFF(MONTH, (SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM('"+AllTrim(_aDados[03,01,02])+"'),5,1) = X5_CHAVE) +	(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM('"+AllTrim(_aDados[03,01,02])+"'),6,1) = X5_CHAVE)+ '01' ,(SELECT GETDATE())) MES_GARA "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

If QRY->MES_GARA <= 14 .And. Len(AllTrim(cRecl)) > 0
	_cGara := 'S'
Else
	_cGara := 'N'
EndIf

cDef	:= "SELECT ZZG_RECCLI RECCLI FROM " + RetSqlName("ZZG") + " WHERE D_E_L_E_T_ = '' AND ZZG_LAB = 2 AND ZZG_CODIGO = '"+Left(AllTrim(cRecl),5)+"' "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cDef), "QRY1", .F., .T.)

If !Empty(AllTrim(QRY1->RECCLI))
	
	//Verifica se o aparelho estแ na garantia estendida Motorola - Edson Rodrigues 30/12/11. - Alterado Paulo Francisco 24/01/12
	IF _cGara == "N" .and. AllTrim(_aDados[04,01,01]) $ _cSpr .And. Transform(QRY->MES_GARA, "@E 99") $ _cPsq  .and. QRY1->RECCLI <> 'C0022'
		lgarest:=.T.
	Else
		lgarest:=.F.
	Endif	
Else	
	lgarest:=.F.	
EndIf

If lgarest	
	_aDados[26,01,02] 	:= 'S'
Else
	_aDados[26,01,02] 	:= 'N'
EndIf

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf


Return(_cGara)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBounce    บAutor  ณPaulo Francisco     บ Data ณ25/07/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณConculta Bounce Pela ultima saida BGH                       บฑฑ
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

Static Function Bounce()

Local cQry1
Local cBoun

#IFDEF TOP
	Local 	cZ4Temp		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	cZMTemp		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	_lQuery    	:= .F.
	Local  	_cQuery		:= .F.
#ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Consulta Ultima Entrada para Calculo Bounce                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

#IFDEF TOP
	
	_lQuery  := .T.
	BeginSql alias cZ4Temp
		SELECT TOP 1 ZZ4_NFSDT AS DTNFS, ZZ4_OPEBGH AS OPERA, ZZJ_DESCRI AS DESCRI
		FROM %table:ZZ4% ZZ4
		JOIN %table:ZZJ% ZZJ ON
		ZZJ.ZZJ_FILIAL = %xfilial:ZZJ% 				AND
		ZZ4.ZZ4_OPEBGH = ZZJ.ZZJ_OPERA				AND
		ZZJ.%notDel%
		WHERE   ZZ4.ZZ4_FILIAL = %xfilial:ZZ4% 		AND
		ZZ4.ZZ4_IMEI = 	%exp: _aDados[02,01,02]%  	AND
		ZZ4.%notDel%
		ORDER BY ZZ4.ZZ4_NFSDT DESC
	EndSql
	
#ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calcula Periodo da Ultima Entrada com Data Base                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

cQry1	:=	" SELECT DATEDIFF(DAY, '"+(cZ4Temp)->DTNFS+"' ,'"+AllTrim(cData)+"') AS BOUNCE " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry1), "QRY1", .F., .T.)

If QRY1->BOUNCE <= 120
	_aDados[06,01] 	:= 'S'
Else
	_aDados[06,01] 	:= 'N'
EndIf

_aDados[07,01]		:= StrZero(QRY1->BOUNCE,3)

cOper				:= (cZ4Temp)->OPERA + ' - ' + (cZ4Temp)->DESCRI

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

If _lQuery
	(cZ4Temp)->( DbCloseArea())
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica Defeito Reclamado Pelo Cliente                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

#IFDEF TOP
	
	_cQuery  := .T.
	BeginSql alias cZMTemp
		SELECT ZZM_DEFINF AS DEFEITO
		FROM %table:ZZM% ZZM
		WHERE   ZZM.ZZM_FILIAL = %exp: '02'% 		AND
		ZZM.ZZM_IMEI 	= 	%exp: _aDados[02,01,02]%  	AND
		ZZM.ZZM_LAB  	= 	%exp: '2' %  				AND
		ZZM.ZZM_MSBLQL 	= 	%exp: '2' %  				AND
		ZZM.%notDel%
	EndSql
	
#ENDIF

cRecl		:= (cZMTemp)->DEFEITO

If _cQuery
	(cZMTemp)->( DbCloseArea())
Endif

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrava     บAutor  ณPaulo Francisco     บ Data ณ25/07/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGrava Apontamentos na Tabela ZZO020                         บฑฑ
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

Static Function Grava(nOpcao)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava็ใo das Informa็๕es                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If lUsrExp == .F.

If nOpcao == 1
	DBSelectArea('ZZO')  //Cadastro de Triagem
	ZZO->(DbSetOrder(1)) // ZZO_FILIAL+ZZO_IMEI+ZZO_CARCAC+ZZO_STATUS
	
	Begin Transaction
	RecLock("ZZO",.T.)
	ZZO->ZZO_FILIAL     := xFILIAL("ZZO")
	ZZO->ZZO_CODIGO 	:= AllTrim(_aDados[01,01])
	ZZO->ZZO_IMEI		:= _aDados[02,01,02]
	ZZO->ZZO_CARCAC		:= AllTrim(_aDados[03,01,02])
	ZZO->ZZO_MODELO		:= AllTrim(_aDados[04,01,01])
	ZZO->ZZO_GARANT  	:= _aDados[05,01,02]
	ZZO->ZZO_BOUNCE		:= _aDados[06,01]
	ZZO->ZZO_NVEZ		:= 0
	ZZO->ZZO_DBOUNC		:= Iif(Len(_aDados[07,01]) >0, Transform(_aDados[07,01], "@E 999"),000)
	ZZO->ZZO_OPBOUN		:= Substr(cOper,1,3)
	ZZO->ZZO_RECLIC		:= Substr(cRecl,1,5)
	ZZO->ZZO_DTSEPA		:= dDataBase
	ZZO->ZZO_HRSEPA		:= Time()
	ZZO->ZZO_USRSEP		:= cUserName
	ZZO->ZZO_STATUS		:= '0'
	ZZO->ZZO_GAREST		:= _aDados[26,01,02]
	
	MsUnlock()
	End Transaction
	
ElseIf nOpcao == 2
	
	/*	DBSelectArea('ZZO')  //Cadastro de Triagem
	ZZO->(DbSetOrder(3)) // ZZO_FILIAL+ZZO_IMEI+ZZO_STATUS
	MsSeek(xFilial("ZZO") + AllTrim(_aDados[02,01,02]))
	
	Begin Transaction
	RecLock("ZZO",.F.)
	
	ZZO->ZZO_DTDEST		:= dDataBase
	ZZO->ZZO_HRDEST		:= Time()
	ZZO->ZZO_USRDES		:= cUserName
	ZZO->ZZO_STATUS		:= '1'
	ZZO->ZZO_REFGAR		:= _aDados[15,01]
	ZZO->ZZO_DESTIN		:= _aDados[16,01]
	ZZO->ZZO_NUMCX		:= _aDados[20,01]
	ZZO->ZZO_COETMA		:= _aDados[20,01]
	
	MsUnlock()
	
	End Transaction     */
	_cQryExec := "UPDATE " + RetSqlName("ZZO") + ENTER
	_cQryExec += "SET ZZO_DTDEST = '"+DtoC(dDataBase)+"', ZZO_HRDEST = '"+Time()+"', ZZO_USRDES = '" + AllTrim(cUserName) + "',ZZO_STATUS = '1', ZZO_REFGAR = '"+Substring(_aDados[15,01],1,1)+"',ZZO_DESTIN = '"+Substring(_aDados[16,01],1,1)+"',ZZO_NUMCX = '"+_aDados[20,01]+"'" + ENTER
	_cQryExec += "WHERE ZZO_FILIAL  = '"+xFilial("ZZO")+"' " + ENTER 
	_cQryExec += "AND ZZO_STATUS = '0' " + ENTER
	_cQryExec += "AND ZZO_IMEI = '" +AllTrim(_aDados[02,01,02])+ "' " + ENTER
	_cQryExec += "AND D_E_L_E_T_ = '' " + ENTER
	
	//	MemoWrite("c:\bosta.sql",_cQryExec)
	TcSQlExec(_cQryExec)
	TCRefresh(RETSQLNAME("ZZO"))
	
ElseIf nOpcao == 6
	
	_cQryExec1 := "UPDATE " + RetSqlName("ZZO") + ENTER
	_cQryExec1 += "SET ZZO_SYMPTO = '" + AllTrim(_aDados[26,01,01]) + "', ZZO_ACTION = '" + AllTrim(_aDados[27,01,01]) + "' " + ENTER
	_cQryExec1 += "WHERE ZZO_FILIAL  = '"+xFilial("ZZO")+"' " + ENTER  
	_cQryExec1 += "AND ZZO_IMEI = '" +AllTrim(_aDados[02,01,02])+ "' " + ENTER
	_cQryExec1 += "AND D_E_L_E_T_ = '' " + ENTER
	
	TcSQlExec(_cQryExec1)
	TCRefresh(RETSQLNAME("ZZO"))
	
EndIf

ZZO->(dbCloseArea())

EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณaDtela    บAutor  ณPaulo Francisco     บ Data ณ26/07/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณInclui Apontamentos no Array _aTemp                         บฑฑ
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

Static Function aDtela(nOpcao)


#IFDEF TOP
	Local 	cZOTemp1		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	_lQuery    		:= .F.
#ENDIF

If nOpcao == 1
	
	aAdd (_aTemp,{_aDados[04,01,01], _aDados[02,01,02], _aDados[03,01,02], _aDados[06,01], Substr(cRecl,1,5), DtoS(dDataBase), Time(), cUserName,_aDados[26,01,02]})
	
	_aDados[03,01,02] := SPACE(20)
	_aDados[02,01,02] := SPACE(TamSX3("ZZ4_IMEI")[1])//SPACE(20)
	oGet3:Refresh()
	oBrw3:Refresh()
	
ElseIf	 nOpcao == 2
	
	#IFDEF TOP
		
		_lQuery  := .T.
		BeginSql alias cZOTemp1
			SELECT ZZO_MODELO AS MODELO, ZZO_IMEI AS IMEI, ZZO_CARCAC AS CARCAC, ZZO_BOUNCE	AS BOUNCE, ZZO_RECLIC AS RECLAM
			FROM %table:ZZO% ZZO
			WHERE   ZZO.ZZO_FILIAL = %xfilial:ZZO% 		AND
			ZZO.ZZO_STATUS = %exp: '1'%  				AND
			ZZO.ZZO_IMEI = %exp: _aDados[02,01,02]%	AND
			ZZO.%notDel%
			ORDER BY ZZO.ZZO_CODIGO DESC
		EndSql
		
		aAdd (_aTemp1,{(cZOTemp1)->MODELO, _aDados[02,01,02], (cZOTemp1)->CARCAC, (cZOTemp1)->BOUNCE, (cZOTemp1)->RECLAM, DtoS(dDataBase), Time(), cUserName})
		
		If _lQuery
			
			(cZOTemp1)->( DbCloseArea())
			
		Endif
		
	#ENDIF
	
	oBrw4:Refresh()
	_aDados[02,01,02] := SPACE(TamSX3("ZZ4_IMEI")[1])//SPACE(20)
	
ElseIf nOpcao == 6
	
	aAdd (_aTemp2,{_aDados[02,01,02],_aDados[26,01,01], _aDados[26,01,02], _aDados[27,01,01], _aDados[27,01,02], DtoS(dDataBase), Time(), cUserName})
	
	_aDados[02,01,02] := SPACE(TamSX3("ZZ4_IMEI")[1])//SPACE(20)
	oBrw5:Refresh()
	
Endif



Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValida    บAutor  ณPaulo Francisco     บ Data ณ27/07/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValida Campos IMEI / CARCACA                                บฑฑ
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

Static Function Valida(nOpcao,vImei,vCarc)

Local _lRet	:= .T.

#IFDEF TOP
	Local 	xVaTemp 		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	xVaTemp1 		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	xVaTemp2 		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	xVaTemp3 		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	xVaTemp5 		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	xVaTemp6 		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	xlQuery    		:= .F.
	Local 	xlQuery1   		:= .F.
	Local 	xlQuery2   		:= .F.
	Local 	xlQuery3   		:= .F.
	Local 	xlQuery5   		:= .F.
	Local 	xlQuery6   		:= .F.
#ENDIF

If nOpcao == 1 .And. Empty(AllTrim(_aDados[03,01,02]))
	
	_aDados[03,01,02]	:= Space(20)
	_lRet := .F.
	
ElseIf _lRet .And. nOpcao == 1  .And. Len(AllTrim(_aDados[03,01,02])) <> 10 .And. lUsrExp == .F.
	
	MsgStop("Equipamento com Erro na Carca็a, Favor Inserir Novamente !!!", "Apontamento")
	_aDados[03,01,02]	:= Space(20)
	_lRet := .F.
	
ElseIf _lRet .And. nOpcao == 1  .And. !U_VALDCARC(AllTrim(_aDados[03,01,02]))
	MsgStop("Equipamento com Erro na Carca็a, Favor Inserir Novamente !!!", "Apontamento")
	_aDados[03,01,02]	:= Space(20)
	_lRet := .F.
	
	
ElseIf _lRet .And. nOpcao == 1 .And. !Empty(AllTrim(_aDados[03,01,02])) .And. lUsrExp == .F.
	
	If !Empty(AllTrim(_aDados[02,01,02]))
		
		dbSelectArea("ZZT")
		dbSetOrder(2)
		If MsSeek(xFilial("ZZT") + AllTrim(_aDados[02,01,02]))
			
			If ZZT->ZZT_STATUS == '1'
				
				MsgStop("Equipamento com Problema Fiscal, Favor Segregar o Equipamento !!!", "Apontamento")
				_aDados[02,01,02]	:= SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
				_aDados[03,01,02]	:= Space(20)
				_lRet := .F.
				
			EndIf
			
			If _lRet .And. AllTrim(ZZT->ZZT_MODELO) <>	AllTrim(_aDados[04,01,01])
				
				MsgStop("Equipamento com Modelo Divergente !!!", "Apontamento")
				_aDados[02,01,02]	:= SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
				_aDados[03,01,02]	:= Space(20)
				_lRet := .F.
				
			EndIf
			
		Else
			
			MsgStop("Equipamento Nใo Encotrado no Arquivo Imputado, Favor Verificar o Arquivo e Inserir Novamente !!!", "Apontamento")
			_aDados[02,01,02]	:= SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_aDados[03,01,02]	:= Space(20)
			_lRet := .F.
			
		EndIf
		
		If _lRet
			
			RecLock("ZZT",.F.)
			
			ZZT->ZZT_STATUS		:= "3"
			
			msunlock()
			
		Endif
		
	EndIf
	
ElseIf nOpcao == 2 .And. Empty(AllTrim(_aDados[02,01,02]))
	
	_aDados[02,01,02]	:= SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
	_lRet := .F.
	
ElseIf nOpcao == 6 .And. Empty(AllTrim(_aDados[02,01,02]))
	
	_aDados[02,01,02]	:= SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
	_lRet := .F.
	
EndIf

If _lRet .And. nOpcao == 1
	
	#IFDEF TOP
		xlQuery5  := .T.
		BeginSql alias xVaTemp5
			SELECT TOP 1 ZZ4_STATUS AS STATUSS
			FROM %table:ZZ4% ZZ4
			WHERE   ZZ4.ZZ4_FILIAL = %xfilial:ZZ4% 		AND
			ZZ4.ZZ4_IMEI = %exp: _aDados[02,01,02]%	AND
			ZZ4.%notDel%
			ORDER BY ZZ4.R_E_C_N_O_ DESC
		EndSql
		
		If !EMPTY(AllTrim((xVaTemp5)->STATUSS))
			
			If (AllTrim((xVaTemp5)->STATUSS)) <> '9'
				MsgStop("Equipamento Em Aberto na BGH, Favor Entrar em Contato com Supervisor !!!", "Apontamento")
				_aDados[02,01,02]	:= SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
				_lRet := .F.
			EndIf
			
		EndIf
		
		If xlQuery5
			
			(xVaTemp5)->( DbCloseArea())
			
		Endif
		
	#ENDIF
	
EndIf

If _lRet .And. nOpcao == 1 .And. vImei
	
	If Empty(AllTrim(_aDados[02,01,02]))
		
		_lRet := .F.
		
	Else
		
		#IFDEF TOP
			xlQuery  := .T.
			BeginSql alias xVaTemp
				SELECT ZZO_MODELO AS MODELO, ZZO_IMEI AS IMEI, ZZO_CARCAC AS CARCAC, ZZO_BOUNCE	AS BOUNCE, ZZO_RECLIC AS RECLAM
				FROM %table:ZZO% ZZO
				WHERE   ZZO.ZZO_FILIAL = %xfilial:ZZO% 		AND
				ZZO.ZZO_STATUS = %exp: '0'%  				AND
				ZZO.ZZO_IMEI = %exp: _aDados[02,01,02]%	AND
				ZZO.%notDel%
				ORDER BY ZZO.ZZO_CODIGO DESC
			EndSql
			
			If !EMPTY(AllTrim((xVaTemp)->IMEI))
				
				MsgStop("Equipamento Registrado Anteriormente", "Apontamento")
				_aDados[02,01,02]	:= SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
				_lRet := .F.
				
			EndIf
			
			
			
			If xlQuery
				
				(xVaTemp)->( DbCloseArea())
				
			Endif
			
			If _lRet .And. !Empty(AllTrim(_aDados[02,01,02]))
				
				Bounce()
				_aDados[05,01,02] := Garantia()
				Grava(nOpcao)
				aDtela(nOpcao)
				
			EndIf
			
		#ENDIF
		
	EndIf
	
	_aDados[03,01,02] := Space(20)
	_aDados[02,01,02] := SPACE(TamSX3("ZZ4_IMEI")[1])////Space(20)
	oBrw3:Refresh()
	
EndIf

If _lRet .And. nOpcao == 1 .And. vCarc
	
	If Empty(_aDados[03,01,02])
		
		_lRet := .F.
		
	Else
		
		#IFDEF TOP
			xlQuery1  := .T.
			BeginSql alias xVaTemp1
				SELECT ZZO_MODELO AS MODELO, ZZO_IMEI AS IMEI, ZZO_CARCAC AS CARCAC, ZZO_BOUNCE	AS BOUNCE, ZZO_RECLIC AS RECLAM
				FROM %table:ZZO% ZZO
				WHERE   ZZO.ZZO_FILIAL = %xfilial:ZZO% 		AND
				ZZO.ZZO_STATUS =  %exp: '0'%  				AND
				ZZO.ZZO_CARCAC =  %exp: _aDados[03,01,02]%	AND
				ZZO.%notDel%
			EndSql
			
			If !EMPTY(AllTrim((xVaTemp1)->IMEI))
				
				MsgStop("Equipamento Registrado Anteriormente", "Apontamento")
				_aDados[03,01,02] := Space(20)
				
			EndIf
			
			If xlQuery1
				
				(xVaTemp1)->( DbCloseArea())
				
			Endif
			
		#ENDIF
		
	EndIf
EndIf


If _lRet .And. nOpcao == 2 .And. vImei
	
	If Empty(AllTrim(_aDados[02,01,02]))
		
		_lRet := .F.
		
	Else
		#IFDEF TOP
			xlQuery2  := .T.
			BeginSql alias xVaTemp2
				SELECT TOP 1 ZZO_MODELO AS MODELO, ZZO_IMEI AS IMEI, ZZO_CARCAC AS CARCAC, ZZO_BOUNCE	AS BOUNCE, ZZO_RECLIC AS RECLAM, ZZO_STATUS AS STAT
				FROM %table:ZZO% ZZO
				WHERE
				ZZO.ZZO_FILIAL = %xfilial:ZZO% 				AND
				ZZO.ZZO_IMEI = %exp: _aDados[02,01,02]%	AND
				ZZO.ZZO_STATUS = %exp: '0'%					AND
				ZZO.%notDel%
			EndSql
			
			xlQuery3  := .T.
			BeginSql alias xVaTemp3
				SELECT TOP 1 ZZO_MODELO AS MODELO, ZZO_IMEI AS IMEI, ZZO_CARCAC AS CARCAC, ZZO_BOUNCE	AS BOUNCE, ZZO_RECLIC AS RECLAM, ZZO_STATUS AS STAT, ZZO_REFGAR AS REFGAR
				FROM %table:ZZO% ZZO
				WHERE
				ZZO.ZZO_FILIAL = %xfilial:ZZO% 				AND
				ZZO.ZZO_NUMCX = %exp: _aDados[20,01]%		AND
				ZZO.%notDel%
			EndSql
			
			If EMPTY(AllTrim((xVaTemp2)->IMEI))
				
				MsgStop("Equipamento Registrado Anteriormente ou Nโo Triados ", "Apontamento")
				_lRet := .F.
				
			ElseIf Len(AllTrim((xVaTemp3)->MODELO)) >0 .And. (xVaTemp3)->REFGAR <> '4'
				
				If AllTrim((xVaTemp2)->MODELO) <> AllTrim((xVaTemp3)->MODELO)
					
					MsgStop("Equipamento com Divergencia Modelo ", "Divergencia - Modelo")
					_lRet := .F.
					
				Endif
				
			Endif
			
			If xlQuery2
				
				(xVaTemp2)->( DbCloseArea())
				
			Endif
			
			If xlQuery3
				
				(xVaTemp3)->( DbCloseArea())
				
			Endif
			
			If _lRet .And. !Empty(AllTrim(_aDados[02,01,02]))
				
				cCont ++
				Grava(nOpcao)
				aDtela(nOpcao)
				cGrava := .T.
				
			EndIf
			
			
		#ENDIF
		
		_aDados[02,01,02] := SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
	EndIf
Endif

If _lRet .And. nOpcao == 6 .And. vImei
	
	If Empty(AllTrim(_aDados[02,01,02]))
		
		_lRet := .F.
		
	Else
		#IFDEF TOP
			xlQuery6  := .T.
			BeginSql alias xVaTemp6
				SELECT TOP 1 ZZO_MODELO AS MODELO, ZZO_IMEI AS IMEI, ZZO_CARCAC AS CARCAC, ZZO_BOUNCE	AS BOUNCE, ZZO_RECLIC AS RECLAM, ZZO_STATUS AS STAT
				FROM %table:ZZO% ZZO
				WHERE
				ZZO.ZZO_FILIAL = %xfilial:ZZO% 				AND
				ZZO.ZZO_IMEI = %exp: _aDados[02,01,02]%	AND
				ZZO.ZZO_STATUS < %exp: '1'%					AND
				ZZO.%notDel%
			EndSql
			
			If EMPTY(AllTrim((xVaTemp6)->IMEI))
				
				MsgStop("Equipamento Nโo Triados ", "Apontamento")
				_lRet := .F.
				
			Endif
			
			If xlQuery6
				
				(xVaTemp6)->( DbCloseArea())
				
			Endif
			
			If _lRet .And. !Empty(AllTrim(_aDados[02,01,02]))
				
				Grava(nOpcao)
				aDtela(nOpcao)
				
			EndIf
			
		#ENDIF
		
		_aDados[02,01,02] := SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
		
	EndIf
Endif

If StrZero(cCont,3) == "200"
	U_IMPTRIA(_aDados[20,01])
	ConfirmSX8()
	_oDlgTria:End()
	
Else
	
	_aDados[02,01,02] := SPACE(TamSX3("ZZ4_IMEI")[1])//Space(20)
	
EndIf

Return(_lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaOk   บAutor  ณPaulo Francisco     บ Data ณ17/09/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGrava e Imprime apos pressionar bt OK                       บฑฑ
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

Static Function GravaOK(nOpcao)

Local _xRet := .F.
Local _cDes
#IFDEF TOP
	Local 	xVaTemp4 		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	xlQuery4   		:= .F.
#ENDIF



If cGrava .And. !Empty(_aDados[20,01]) .And. StrZero(cCont,3) >= "001"
	
	#IFDEF TOP
		xlQuery4  := .T.
		BeginSql alias xVaTemp4
			SELECT TOP 1 ZZO_DESTIN AS DESTIN
			FROM %table:ZZO% ZZO
			WHERE   ZZO.ZZO_FILIAL = %xfilial:ZZO% 		AND
			ZZO.ZZO_STATUS = %exp: '1'%  				AND
			ZZO.ZZO_NUMCX  = %exp: _aDados[20,01]%		AND
			ZZO.%notDel%
		EndSql
		
		If !EMPTY(AllTrim((xVaTemp4)->DESTIN))
			
			_cDest := (AllTrim((xVaTemp4)->DESTIN))
			
		EndIf
		
		If xlQuery4
			
			(xVaTemp4)->( DbCloseArea())
			
		Endif
	#ENDIF
	If MsgBox("Existe "+TransForm(strzero(cCont,3),"@E 999")+ " Equipamentos Apontados, Deseja Imprimir ??","Aten็ใo !!","YESNO")
		
		U_IMPTRIA(_aDados[20,01],_cDest)
		ConfirmSX8()
		_oDlgTria:End()
		_xRet := .T.
		
	EndIf
	
EndIf

If nOpcao == 3
	
	_cQryExec := "UPDATE " + RetSqlName("ZZO") + ENTER
	_cQryExec += "SET ZZO_SEGREG = 'S' " + ENTER
	_cQryExec += "WHERE ZZO_FILIAL = '"+xfilial("ZZO")+"'  " + ENTER
	_cQryExec += "AND ZZO_STATUS = '1' " + ENTER
	_cQryExec += "AND ZZO_IMEI = '" +AllTrim(_aDados[02,01])+ "' " + ENTER
	_cQryExec += "AND ZZO_CARCAC = '"+AllTrim(_aDados[03,01])+ "' " + ENTER
	_cQryExec += "AND D_E_L_E_T_ = '' "+ ENTER
	
	TcSQlExec(_cQryExec)
	TCRefresh(RETSQLNAME("ZZO"))
	
	U_IMPTRIA(_aDados[20,01],_aDados[16,01])
	_oDlgTria:End()
	_xRet := .T.
	
EndIf

Return(_xRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMENUDIN   บ Autor ณPaulo Lopez         บ Data ณ  29/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCADASTROS PARA MENU DINAMICO                                บฑฑ
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

User Function MENUDIN()

Private cPerg       := "TRIAG"
Private cDestin
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
		cDestin   := "B"
		
		Etqtri(cDestin)
		
	Case mv_par01 == 2
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//|Modulo para Administradores											ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cDestin   := "N"
		
		Etqtri(cDestin)
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

aAdd(aSx1,{cPerg,"01","Qual Empresa ? ","","","mv_ch1","N",01,0,0,"C","","mv_par01","BGH","","","","","Nextel/Motorola","","","","","","","","","","","","","","","","","","","",""})

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
ฑฑบPrograma  ณEtqGera   บ Autor ณPaulo Lopez         บ Data ณ  02/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณIMPRIME ETIQUETA MASTER                                     บฑฑ
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


Static Function Etqtri(cDestin)

Private oDlgMass
Private _cNumEtq		:= Space(20)
Private _ocodimei		:= '1'
Private _lRet			:= .F.


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao da janela e seus conteudos                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlgMass TITLE "Etiquetas Master" FROM 0,0 TO 210,420 OF oDlgMass PIXEL

//@ 010,015 SAY   "Informe o Numero Master para Impressใo." 	SIZE 150,008 PIXEL OF oDlgMass
@ 035,015 TO 070,180 LABEL "Master" PIXEL OF oDlgMass
@ 045,025 GET _cNumEtq PICTURE "@!" 	SIZE 080,010 Valid U_IMPTRIA(@_cNumEtq,cDestin) Object ocodimei

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Botoes da MSDialog                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//@ 080,140 BUTTON "&CANCELAR" SIZE 36,16  PIXEL ACTION (oDlgMass:End())
@ 080,140 BUTTON "Sai&r"       SIZE 036,012 ACTION oDlgMass:End() OF oDlgMass PIXEL

Activate MSDialog oDlgMass CENTER

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALDCARC  บAutor  ณ Edson Rodrigues    บ Data ณ  01/12/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida digitos de calculo degarantia da carca็ใo           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ           BGH DO BRASIL                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VALDCARC(cVarSim)

Local _dmes     := SUBSTR(DTOC(ddatabase),4,2)
Local _cdia     := IIF(_dmes='02','28',IIF(_dmes $ "01/03/05/07/08/10/12",'31','30'))
Local _cvmessim := substr(cVarSim,6,1)
Local _cvanosim := substr(cVarSim,5,1)
Local _cmes     :="01"
Local _cano     := "2000"
Local _lvcarc   := .t.

IF !SX5->(dbseek(xfilial("SX5")+"WD"+alltrim(_cvmessim)))
	MsgBox("Carca็a Invalida ou o identificador do mes de fabrica็ใo : "+_cvmessim+" nใo existe na tabela WD dos SX5 !","Digite uma carca็a vแlida ou entre em contato com Administrador do sistema","ALERT")
	_lvcarc:= .f.
ENDIF
IF !SX5->(dbseek(xfilial("SX5")+"WC"+alltrim(_cvanosim)))
	MsgBox("Carca็a Invalida ou o identificador do ano de fabrica็ใo : "+_cvanosim+" nใo existe na tabela WC dos SX5 !","Digite uma carca็a vแlida ou entre em contato com Administrador do sistema","ALERT")
	_lvcarc:= .f.
Endif

return(_lvcarc)
