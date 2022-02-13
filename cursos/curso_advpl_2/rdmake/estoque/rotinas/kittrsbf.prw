#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³KITTRSBF  ³Autor  ³Hudson de Souza Santos ³ Data ³ 10/03/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Transferir os saldos das peças novas para as peças Retraba-³±±
±±³          ³lhadas com saldo no RE.              						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específico início operação KIT.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KITTRSBF()
MsAguarde({|| KITSBF()},"Transferindo Saldos de peças novas para peças retrabalhadas")
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ KITSBF   ³Autor  ³Hudson de Souza Santos ³ Data ³ 10/03/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua transferencia Produto+Armazem+Endereço              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function KITSBF()
Local _cQuery		:= ""
Local CR	 		:= CHR(13)+CHR(10)
Local cDocSD3		:= NextNumero("SD3",2,"D3_DOC",.T.)
Private aAuto		:= {}
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da Query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                    

_cQuery :=      "SELECT"
_cQuery += CR + "BF_PRODUTO as PRODUTO,"
_cQuery += CR + "BF_LOCAL as ARMORI,"
_cQuery += CR + "BF_LOCALIZ as ENDORI,"
_cQuery += CR + "B1_COD as PRODEST,"
//_cQuery += CR + "BF_LOCAL as ARMDES,"
_cQuery += CR + "B1_LOCPAD as ARMDES,"
_cQuery += CR + "BF_LOCALIZ as ENDDES,"
_cQuery += CR + "BF_QUANT as QUANT"
_cQuery += CR + "FROM SBF020 as SBF(NOLOCK)"
_cQuery += CR + "inner join SB1020 as SB1(NOLOCK) ON SB1.D_E_L_E_T_ = ''"
//_cQuery += CR + "		AND BF_PRODUTO = B1_CODNOVA"
//_cQuery += CR + "		AND B1_RETRABA = 'S'"
_cQuery += CR + "		AND BF_PRODUTO = B1_COD"
_cQuery += CR + "		AND B1_TIPO = 'MC'"
_cQuery += CR + "		AND B1_LOCPAD = '55'"
_cQuery += CR + "		AND B1_MSBLQL <> '1'"
_cQuery += CR + "WHERE SBF.D_E_L_E_T_ = ''"
_cQuery += CR + "	AND SBF.BF_LOCAL = '01'"
_cQuery += CR + "	AND SBF.BF_QUANT > 0 "
_cQuery += CR + "	AND SBF.BF_LOCALIZ <> 'BUFFER' "
_cQuery += CR + "ORDER BY BF_PRODUTO"


If Select("TRANS") <> 0 
	dbSelectArea("TRANS")
	dbCloseArea()
Endif
TcQuery StrTran(_cQuery,CR," ") New Alias "TRANS"
TcSetField("TRANS","QUANT"	, "N", 17, 2)
aAdd(aAuto, {cDocSD3, DATE()} ) // D3_DOC , D3_EMISSAO
While !TRANS->(Eof())
	MsProcTxt(	"Qtd: "+Alltrim(Transform(TRANS->QUANT,"@E 999999"))+;
				"de: '"+Alltrim(TRANS->PRODUTO)+"'"+;
				"Para: '"+Alltrim(TRANS->PRODEST)+"'")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria armazem de destino caso nao exista.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectarea("SB2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB2")+TRANS->PRODEST+TRANS->ARMDES,.F.)
		CriaSb2(TRANS->PRODEST,TRANS->ARMDES)
	Endif
	dbSelectarea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+TRANS->PRODEST)
	aAdd(aAuto ,{;
			SB1->B1_COD  			,; // D3_COD
			SB1->B1_DESC			,; // D3_DESCRI
			SB1->B1_UM				,; // D3_UM
			TRANS->ARMORI			,; // D3_LOCAL
			TRANS->ENDORI			,; // D3_LOCALIZ
			SB1->B1_COD				,; // D3_COD
			SB1->B1_DESC			,; // D3_DESCRI
			SB1->B1_UM				,; // D3_UM
			TRANS->ARMDES			,; // D3_LOCAL
			TRANS->ENDDES			,; // D3_LOCALIZ
			CriaVar("D3_NUMSERI")	,; // D3_NUMSERI
			CriaVar("D3_LOTECTL")	,; // D3_LOTECTL
			CriaVar("D3_NUMLOTE")	,; // D3_NUMLOTE
			Ctod("")				,; // D3_DTVALID
			CriaVar("D3_POTENCI")	,; // D3_POTENCI
			TRANS->QUANT			,; // D3_QUANT
			CriaVar("D3_QTSEGUM")	,; // D3_QTSEGUM
			CriaVar("D3_ESTORNO")	,; // D3_ESTORNO
			CriaVar("D3_NUMSEQ")	,; // D3_NUMSEQ
			CriaVar("D3_LOTECTL")	,; // D3_LOTECTL
			Ctod("")				,; // D3_DTVALID
			CriaVar("D3_SERVIC")	,; // D3_SERVIC
			CriaVar("D3_ITEMGRD")	}; // D3_ITEMGRD
	)
	TRANS->(dbSkip())
EndDo
MSExecAuto({|x,y| MATA261(x)},aAuto,3)
If lMsErroAuto
	Alert("Erro no documento " + cDocSD3)
Else
	Alert("Documento gerado com sucesso: " + cDocSD3)
EndIf
Return

User Function HH3HH(nQtd)
Local aAuto	:= {}
Local cQry	:= ""
Local cRet	:= "|"
nQtd := Iif(nQtd==Nil,100, nQtd)
Private lMsErroAuto := .F.
cQry := " SELECT DISTINCT TOP "+Alltrim(Transform(nQtd,"@e 999"))+" D3_DOC as DOC "
cQry += " FROM SD3020(NOLOCK) "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " 	AND D3_ESTORNO <> 'S' "
cQry += " 	AND left(rtrim(ltrim(D3_DOC)),1) = 'K' "
cQry += " 	AND substring(rtrim(ltrim(D3_DOC)),8,1) in ('P','R') "
cQry += " 	AND NOT(right(rtrim(ltrim(D3_DOC)),2) in ('PD','RE')) "
cQry += " ORDER BY D3_DOC "
If Select("TRANS") <> 0 
	dbSelectArea("TRANS")
	dbCloseArea()
Endif
TcQuery cQry New Alias "TRANS"
While !TRANS->(Eof())
	dbSelectArea("SD3")
	dbSetOrder(2)
	dbSeek(xFilial("SD3")+TRANS->DOC)
	MSExecAuto({|x,y| mata261(x,y)},aAuto,6)
	If !lMsErroAuto
		cRet += SD3->D3_DOC + "|"
	Else
		ALERT("Erro na inclusao!")
		MostraErro()
	EndIf
	TRANS->(dbSkip())
	dbCloseArea("SD3")
EndDo
ALERT("Sucesso na operação!"+CHR(13)+cRet)
Return