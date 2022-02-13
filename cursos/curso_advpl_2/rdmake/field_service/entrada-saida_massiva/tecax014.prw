#INCLUDE 'RWMAKE.CH'
#Include "Colors.ch"
#include "cheque.ch"
#include "topconn.ch"
#define ENTER CHR(10)+CHR(13)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECAX014 ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  13/05/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa responsavel por alimentar a NF Entrada com os     º±±
±±º          ³ itens da Entrada Massiva                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterado por M.Munhoz em 23/08/2011 para alimentar o SD1 com os itens do ZZ4   ³
//³ (IMEIs) aglutinados por codigo de produto, valor unitario e operacao BGH.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function tecax014()

local cVarTES  := Space(3)
local dDdoca   := ctod("  /  /  ")
local cHdoca   := Space(8)
local cmotdoca := space(2)
local _ccusto  := space(9)
local _cLote   := space(7)
local _ctpent  := space(2)
local _carmaz  := space(2)
Local _ccoper  := Space(9) 
Local lVerForm := SuperGetMv("MV_XBUTEM", .F., .F.)

Private cAliasTop3 := ""
Private cAliasTop4 := ""
Private cNFEntr	   := IIF(EMPTY(CNFISCAL) .and. EMPTY(CSERIE),"999999999",CNFISCAL)
Private cSerEntr   := IIF(EMPTY(CNFISCAL) .and. EMPTY(CSERIE),"999",CSERIE)

Private cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

u_GerA0003(ProcName())

DbSelectArea("SA1") //Cadastro de Clientes
DBSelectArea('SB1') //Cadastro de Produtos
DBSelectArea('SD1') //Itens da NFE
DBSelectArea('SF4') //Cadastro de TES
DBSelectArea('ZZ4') //Entrada Massiva
DBSelectArea('SZA') //Excel x Entrada Massiva

ZZ4->(DBSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR +ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO
SF4->(DbSetOrder(1)) // F4_FILIAL + F4_CODIGO
SZA->(DbSetOrder(1)) // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
ZZO->(DbSetOrder(1)) // ZZO_FILIAL + ZZO_IMEI + ZZO_CARCAC + ZZO_STATUS

If lVerForm
	// Bloqueia chamada do botao se o Formulario proprio for igual a Nao
	If cFormul == "N"
		MsgAlert('Nao é permitida Entrada Massiva com Formulario proprio igual a Nao','Formulario proprio'	)
		Return
	endif
EndIf

// Permite execucao da rotina apenas quando posicionado nos itens da NFE
if !Empty(__ReadVar)
	MsgAlert('Clique nos itens da Nota Fiscal antes de chamar a Entrada Massiva','itens'	)
	Return
endif

// Bloqueia chamada do botao se o tipo da NFE for diferente de Beneficiamento
If cTipo <> 'B'
	MsgAlert('A Entrada Massiva funciona apenas para Beneficiamento','Beneficiamento')
	Return
EndIf

DBSELECTAREA("ZZ4")
// Verifica se existe entrada massiva disponivel para inclusao da NFE
If !ZZ4->(dbSeek(xFilial('ZZ4') + cNFEntr + cSerEntr + CA100FOR + cLoja)) .and. ZZ4->ZZ4_STATUS <> "2"
	MsgAlert('Nao foi localizada a entrada massiva para essa Nota Fiscal. Verifique os parametros!','Entrada Massiva')
	Return
Else
	// Verifica se o numero de OS nao esta gravado //Edson Rodrigues - 11/09
	while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_CODCLI == CA100FOR  .and. ZZ4->ZZ4_LOJA == CLOJA .and. ;
		ZZ4->ZZ4_NFENR == cNFEntr .and. ZZ4->ZZ4_NFESER == cSerEntr
		If Empty(ZZ4->ZZ4_OS)
			Msgalert('Numero de OS na entrada Massiva nao esta preenchido. Contate do Administrador![SEM OS]')
			Return
		Endif
		
		cOpe      := POSICIONE("ZZ4",1,xFilial("ZZ4") + ZZ4->ZZ4_IMEI + left(ZZ4->ZZ4_OS,6),"ZZ4_OPEBGH")
		_ctpent   := POSICIONE("ZZ4",1,xFilial("ZZ4") + ZZ4->ZZ4_IMEI + left(ZZ4->ZZ4_OS,6),"ZZ4_OPER")
		cdescr    := POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe,"ZZJ_DESCRI")
		clab      := POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe,"ZZJ_LAB")
		_cctrlot  := POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe,"ZZJ_CTRLOT")
		_ccoper   := POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe,"ZZJ_CC")
		coperacao := alltrim(cOpe)+'-'+alltrim(cdescr)
		lvdprod   := U_VLDPROD(cOpe,clab) //Valida operações para chamar a função de inserção de requisição. Edson Rodrigues 24/03
		_ctriagem := POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe,"ZZJ_TRIAGE")
		// Verifica se operacao e sony Ericson Refurbish
		//If ZZ4->ZZ4_OPEBGH == "S03"
		IF lvdprod
			MsgALERT('Documento de Entrada via Entrada Massiva nao permitido','Nao e permitida fazer o documento de entrada via entrada massiva para operacao'+coperacao+'. Contate do Administrador!')
			Return
		Endif
		
		
		If _ctriagem =="S" .and. !empty(ZZ4->ZZ4_ETQMEM)
			If !ZZO->(dbSeek(xFilial('ZZO') + ZZ4->ZZ4_IMEI + ZZ4->ZZ4_CARCAC + "2"))
				MsgAlert('Imei nao foi validado na entrada massiva com arquivo de Triagem. Verifique se o imei passou por todas etapas da Triagem!','Valida Entrada Massiva X Triagem')
				Return
			Endif
		Endif
		
		ZZ4->(dbSkip())
	Enddo
Endif

// Alimenta itens com importacao de dados gerada atraves de arquivo Excel
if SZA->(dbSeek(xFilial("SZA") + CA100FOR + cLoja + cNFEntr + cSerEntr))
	while SZA->(!eof()) .and. SZA->ZA_FILIAL == xFilial("SZA") .and. SZA->ZA_CLIENTE == CA100FOR  .and. SZA->ZA_LOJA == CLOJA .and. ;
		SZA->ZA_NFISCAL == cNFEntr .and. SZA->ZA_SERIE == cSerEntr
		if SZA->ZA_STATUS $ "IN"
			MsgAlert('Esta Entrada Massiva ainda não foi validada e a NFE não poderá ser inserida. Verifique sua Validação!','Validação Entrada Massiva')
			Return
		endif
		SZA->(dbSkip())
	enddo
endif

//Janela  - Modificada por Edson Rodrigues em 11/07/07
oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
@ 0,0 TO 420,400 DIALOG oDlg TITLE "Tipo de Entrada"
oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlg)
@ 015,010 SAY oV1 var "Informe a TES a ser usada:" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
@ 025,010 GET cVarTES Size 50,080 PICTURE "@!" valid ExistCPO('SF4',cVarTES) .AND. cVarTES<'500'  F3 'SF4'
@ 040,010 SAY oV2 var "Informe a data de entrada na doca :" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
@ 050,010 GET dDdoca Size 30,050 Picture "99/99/99" VALID !Empty(dDdoca) .and. valdoca(dDdoca,cHdoca,cOpe,clab)
@ 065,010 SAY oV2 var "Informe a Hora de entrada na doca :" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
@ 075,010 GET cHdoca Size 30,050 Picture "@R 99:99:99" VALID !Empty(cHdoca) .and. valdoca(dDdoca,cHdoca,cOpe,clab)
@ 095,010 SAY oV2 var "Informe o Motivo atraso Dt.Doca X Dt.Docto :" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
@ 105,010 GET cMOTDOCA Size 30,080 PICTURE "@!" valid ExistCpo("SX5","ZD"+cMOTDOCA) F3 'ZD'
If Empty(_ccoper)
	@ 120,010 SAY oV2 var "Informe o Centro de Custo :" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
	@ 130,010 GET _ccusto Size 30,080 PICTURE "@!" valid ExistCpo('CTT',alltrim(_ccusto)) F3 'CTT'
Else
	_ccusto:=_ccoper
	@ 120,010 SAY oV2 var "Informe o Centro de Custo :" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
	@ 130,010 GET _ccusto Size 30,080 PICTURE "@!"  when .F.
Endif
IF _cctrlot ="S"
	_cLote:=GetSx8Num('ZZ4','ZZ4_XLOTE')
	ConfirmSX8()
	@ 145,010 SAY oV2 var "Informe o Lote:" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
	@ 155,010 GET _cLote Size 30,080 PICTURE "@!" //When .F.
ELSE
	@ 145,010 SAY oV2 var "Informe o Lote:" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
	@ 155,010 GET _cLote Size 30,080 PICTURE "@!"
ENDIF
If _ctpent='07'
	@ 170,010 SAY oV2 var "Informe o Armazem:" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
	@ 180,010 GET _carmaz Size 30,080 PICTURE "@!"  VALID !Empty(_carmaz) .and. valdarmz(_carmaz,cOpe)
Else
	@ 170,010 SAY oV2 var "Informe o Armazem:" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
	@ 180,010 GET _carmaz Size 30,080 PICTURE "@!"  When .F.
Endif
@ 192,085 BMPBUTTON TYPE 1 ACTION Processa({|| xConfirma(cVarTES,dDdoca,cHdoca,cmotdoca,_cLote,_ccusto,_carmaz,oDlg) })
@ 192,120 BMPBUTTON TYPE 2 ACTION oDlg:End()
Activate MSDialog oDlg Centered

DBSelectArea('ZZ4')
//DBCloseArea('ZZ4') //Alterado conforme chamado microsiga SDJHBQ - Edson Rodrigues - 05/04/11
ZZ4->(DBCloseArea())

DBSelectArea('ZZ4')

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Filtra   ºAutor  ³Antonio L. Favero   º Data ³ 26/01/2003  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina fara o filtro dos celulares que não geraram NFEº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Filtra()

DbSelectArea("ZZ4")
cAliasTop3	:= GetNextAlias()
//Alterado o select para com campos fixos, a fim de melhorar a performance. Edson Rodrigues - 06/05/10
//Inclusao dos campos ZZ4_OPEBGH no SELECT e dos ZZ4_VLRUNI e ZZ4_OPEBGH no ORDER BY. M.Munhoz - 23/08/11
_cQuery := " SELECT ZZ4_IMEI,ZZ4_OS,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_CODPRO,ZZ4_VLRUNI,ZZ4_LOCAL,ZZ4_OPEBGH,R_E_C_N_O_ "
_cQuery += " FROM " + RetSqlName("ZZ4") + " (nolock) "
_cQuery += " WHERE ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND "
_cQuery += "   D_E_L_E_T_ = ''  AND "
_cQuery += "   ZZ4_STATUS = '2' AND "  // Entrada Massiva Confirmada
_cQuery += "   ZZ4_NFENR  = '"+cNFEntr+"' AND "
_cQuery += "   ZZ4_NFESER = '"+cSerEntr  +"' AND "
_cQuery += "   ZZ4_CODCLI = '"+CA100FOR+"' AND "
_cQuery += "   ZZ4_LOJA   = '"+CLOJA   +"' "
_cQuery += " ORDER BY ZZ4_CODPRO, ZZ4_VLRUNI, ZZ4_OPEBGH,ZZ4_LOCAL, R_E_C_N_O_ "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery),cAliasTop3,.T.,.T.)

(cAliasTop3)->(DBGoTop())

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ xConfirmaºAutor  ³Antonio L. Favero   º Data ³ 26/01/2003  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina fara a geracao dos itens no aCols da nota      º±±
±±º          ³ fiscal de entrada                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xConfirma(cTES,Dddoca,cHdoca,cmotdoca,_cLote,_ccusto,_carmaz)

SetPrvt("x1,xCF,xEstado")

private _nItem   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ITEM" })     // Item da NF
private _nCod    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_COD" })     // Codigo do Produto
private _nUm     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_UM" })      // Unidade
private _nSegum  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_SEGUM" })   // Segunda Unidade
private _nQuant  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_QUANT" })
private _nVunit  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_VUNIT" })
private _nTotal  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_TOTAL" })
private _nValipi := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_VALIPI" })
private _nValicm := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_VALICM" })
private _nTes    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_TES" })
private _nCf     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_CF" })
private _nDesc   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_DESC" })
private _nIpi    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_IPI" })
private _nPicm   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_PICM" })
private _nPeso   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_PESO" })
private _nConta  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_CONTA" })
private _nCC     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_CC" })
private _nItemcta:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ITEMCTA" })
private _nOp     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_OP" })
private _nPedido := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_PEDIDO" })
private _nItempc := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ITEMPC" })
private _nlocal  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_LOCAL" })
private _nQtSegum:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_QTSEGUM" })
private _nNfori  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_NFORI" })
private _nSeriori:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_SERIORI" })
private _nItemori:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ITEMORI" })
private _nIcmsret:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ICMSRET" })
private _nBricms := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_BRICMS" })
private _nNumcq  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_NUMCQ" })
private _nItem   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ITEM" })
private _nBaseicm:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_BASEICM" })
private _nValdesc:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_VALDESC" })
private _nLotefor:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_LOTEFOR" })
private _nBaseipi:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_BASEIPI" })
private _nLotectl:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_LOTECTL" })
private _nNumlote:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_NUMLOTE" })
private _nDtvalid:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_DTVALID" })
private _nClasfis:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_CLASFIS" })
private _nIcmscom:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ICMSCOM" }) // ICMS COMPLEMENTAR
private _nRateio := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_RATEIO" })
private _nIdentB6:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_IDENTB6" }) // Identificador poder 3
private _nOP     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_OP" })      // Ordem de Producao
private _nNumSer := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_NUMSER" })  // Customizado
private _ddtdoca := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_DTDOCA" })  // Customizado - Edson Rodrigues - 11/07/07
private _cHrdoca := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_HRDOCA" })  // Customizado - Edson Rodrigues - 11/07/07
private _cmtdoca := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_MOTDOCA" })  // Customizado - Edson Rodrigues - 04/09/07
private _nPosLot := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_XLOTE" })  //
private _cPoscust:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_CC" })  //
private _cPosxace:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_XACESS" })  //
private _cPosdivn:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_DIVNEG" })  //
private _nOpeBGH := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_XOPEBGH" })  // Customizado - M.Munhoz - 23/08/11
private _larmzau  :=.f.
private _nwhile   := 0
private _lvlarmz  :=.t.
private _cmsgarmz := ""
private _aAcess	  := {}
private cEstado   := ""


if !(ExistCPO('SF4',cTES) .AND. cTES < '500')
	Return
endif

oDlg:End()
Filtra()
Filcount()

if (cAliasTop4)->ZZ4_CODCLI <> 'Z00403'
	(cAliasTop4)->(DbGoTop())
	While !(cAliasTop4)->(EOF())
		_nwhile++
		IF !EMPTY((cAliasTop4)->ZZ4_LOCAL)
			carment:= ALLTRIM(POSICIONE("ZZJ",1,xFilial("ZZJ") + (cAliasTop4)->ZZ4_OPEBGH,"ZZJ_ARMENT"))
			IF ALLTRIM((cAliasTop4)->ZZ4_LOCAL) $ carment
				_cmsgarmz :=_cmsgarmz+ "Operac: "+(cAliasTop4)->ZZ4_OPEBGH+"  Armaz: "+(cAliasTop4)->ZZ4_LOCAL+"  Qtde Imeis : "+STRZERO((cAliasTop4)->QTDARMZ,3)+"."+ENTER
			ELSE
				_cmsgarmz :=_cmsgarmz+ "Operac: "+(cAliasTop4)->ZZ4_OPEBGH+"  Armaz: "+(cAliasTop4)->ZZ4_LOCAL+"  Qtde Imeis : "+STRZERO((cAliasTop4)->QTDARMZ,3)+"."+ENTER
				_lvlarmz :=.f.
			ENDIF
		ELSE
			_lvlarmz  :=.T.
			_cmsgarmz :="" // _cmsgarmz+ "Operac: "+(cAliasTop4)->ZZ4_OPEBGH+"  Armaz: "+(cAliasTop4)->ZZ4_LOCAL+"  Qtde imeis : "+STRZERO((cAliasTop4)->QTDARMZ,3)+"."+ENTER
		ENDIF
		(cAliasTop4)->(DbSkip())
	enddo

	IF _nwhile > 1 .and. !empty(_cmsgarmz)
		IF MSGYESNO("Deseja considerar os armazéns abaixo para essa entrada [SIM], ou quer que o sistema considere o(s) armazém(ns) conforme operação e regras já definidas [NAO] ?"+ENTER+" "+_cmsgarmz)
			IF !_lvlarmz
				MsgAlert("Existe(m) Imeis com armazém não preenchido ou não cadastrados para aoperacao. Nao poderá prosseguir, preencha o armazém na entrada massiva")
				Return
			ELSE
				_larmzau  :=.t.
			ENDIF
		ELSE
			_larmzau  :=.f.
		ENDIF
	ENDIF

endif


x1      := 1
xCols   := aCols  // carrego com os campos contidos no aCols da nota fiscal
cItem   := '0001'
cdivn   := ''
clocal  := ''
_larmaz := .f.
_cProd  := ''
_nVlrUni:= 0
SF4->(DbSeek(xFilial("SF4")+cTES,.F.))

(cAliasTop3)->(DbGoTop())
While !(cAliasTop3)->(EOF())
	
	IF !SB1->(DBSeek(xFilial('SB1')+(cAliasTop3)->ZZ4_CODPRO))
		MsgAlert("Nao tem esse produto "+(cAliasTop3)->ZZ4_CODPRO+" cadastrado no cadastro de produtos. Favor cadastrar!","Validação produto da Entrada Massiva")
		Return
	ELSE
		SB1->(DBSeek(xFilial('SB1')+(cAliasTop3)->ZZ4_CODPRO))
	ENDIF
	
	//	M.Munhoz - 23/08/11
	_cProd    := (cAliasTop3)->ZZ4_CODPRO
	_nVlrUni  := (cAliasTop3)->ZZ4_VLRUNI
	_nQtdIMEI := 0
	
	cOpe    	:= (cAliasTop3)->ZZ4_OPEBGH  //POSICIONE("ZZ4",1,xFilial("ZZ4") + (cAliasTop3)->ZZ4_IMEI + left((cAliasTop3)->ZZ4_OS,6),"ZZ4_OPEBGH")  //	M.Munhoz - 23/08/11
	clab    	:= POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe,"ZZJ_LAB")
	carment 	:= ALLTRIM(POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe+clab,"ZZJ_ARMENT"))
	cdescr  	:= POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe+clab,"ZZJ_DESCRI")
	//    clab    	:= POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe+clab,"ZZJ_LAB")
	coperacao 	:= alltrim(cOpe)+'-'+alltrim(cdescr)
	// informa divisao de negocio,  Edson Rodrigues - 01/12/08
	cdivn :=POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe+clab,"ZZJ_DIVNEG")
	// Ve se a operação trabalha com mais de 1 armazem
	_larmaz     := IIF(len(alltrim(carment))==2,.t.,.f.)
	
	cSepEnt:= Posicione("ZZJ",1,xFilial("ZZJ") + cOpe, "ZZJ_SEPENT")//Incluido conforme solicitação do Edson 12/06/2012
	
	IF !empty(carment) .and. _larmaz .and. !_larmzau
		clocal:=alltrim(carment)
		//_larmaz:=.t.
	Elseif _larmaz .and. !_larmzau
		clocal:=alltrim(carment)
	Else
		clocal:=IIF(EMPTY((cAliasTop3)->ZZ4_LOCAL),LEFT(carment,2),(cAliasTop3)->ZZ4_LOCAL)
	Endif
	
	
	IF  !_larmaz .and. ZZ4->ZZ4_CODCLI <> 'Z00403' // Se nao trabalhar com mais de 1 armazem, faz as validacoes abaixo.
		
		//Valida Preenchimento do armazem e retorna caso nao esteja preenchido ou invalido com a operação
		If EMPTY(clocal)
			clocal:=IIF(EMPTY((cAliasTop3)->ZZ4_LOCAL),SB1->B1_LOCPAD,(cAliasTop3)->ZZ4_LOCAL)
			IF  EMPTY(clocal)
				MsgAlert("Armazem nao cadastrado no cadastro de operacoes ZZJ para operacao: "+coperacao+". Favor cadastrar!","Validação armazem de Entrada Massiva")
				Return
			Elseif !alltrim(clocal) $ alltrim(carment)
				MsgAlert("Nao tem esse armazem "+clocal+" cadastrado no cadastro de operacoes ZZJ para operacao: "+coperacao+". Favor cadastrar!","Validação armazem de Entrada Massiva")
				Return
			Endif
		Elseif  !alltrim(clocal) $ alltrim(carment)
			MsgAlert("Nao tem esse armazem "+clocal+" cadastrado no cadastro de operacoes ZZJ para operacao: "+coperacao+". Favor cadastrar!","Validação armazem de Entrada Massiva")
			Return
			
		ENDIF
		
		// Faz outras validacoes, conforme regras de operacoes e Cliente.
		//Adicionado Luiz Ferreira 26/02/09 - Altarado Armzem Rotina nova Nextel MARCOS MARQUES - Armazem ="11" , caso o cliente seja 000680
		If cOpe=="N01" .and. !_larmzau
			
			// Alterado Para comportar novos Clientes Nextel CD - Uiran Almeida 29.01.2015 
			/*IF ((cAliasTop3)->ZZ4_CODCLI =='000680' .and. (cAliasTop3)->ZZ4_LOJA == '01')  //.and. empty(_carmaz)
				clocal :="11"
			Elseif ((cAliasTop3)->ZZ4_CODCLI =='000016' .and. (cAliasTop3)->ZZ4_LOJA == '01')   //.and. empty(_carmaz)
				clocal :="10"
			Endif*/
			
			cEstado := Posicione( "SA1",1,xFilial('SA1')+(cAliasTop3)->ZZ4_CODCLI+(cAliasTop3)->ZZ4_LOJA,"A1_EST")
		    
		 	If(Alltrim(cEstado) == "RJ")
		 		clocal := "11"
		 	ElseIf(Alltrim(cEstado) == "SP")
		 		clocal := "10"			
			EndIf
						
			
		Elseif cOpe=="N02" .and. !_larmzau
			IF  SA1->(DBSeek(xFilial('SA1')+(cAliasTop3)->ZZ4_CODCLI+(cAliasTop3)->ZZ4_LOJA))  //.and. empty(_carmaz)
				IF '669702290' $ (LEFT(SA1->A1_CGC,9))
					clocal  :="16"
				Endif
			Endif
		Endif
		
	Endif
	
	// M.Munhoz - 23/08/11 - While criado para somar a quantidade de IMEIs com mesmo codigo de produto, valor unitario e operacao BGH.
	// O SD1 sera alimentado a partir destes itens aglutinados.
	while !(cAliasTop3)->(EOF()) .and. _cProd == (cAliasTop3)->ZZ4_CODPRO .and. _nVlrUni == (cAliasTop3)->ZZ4_VLRUNI .and. cOpe == (cAliasTop3)->ZZ4_OPEBGH .and. IIF(_larmzau,(cAliasTop3)->ZZ4_LOCAL == clocal, .t.)
		_nQtdIMEI++
		(cAliasTop3)->(DbSkip())
	enddo
	
	//Processa acessorios conforme solicitação do Edson - 13/06/12
	If Alltrim(cSepEnt) == "S"  .and. ZZ4->ZZ4_CODCLI <> 'Z00403'
		Processa({|| ProcAcess() },"Processando Acessorios...")
	Endif
	
	IF x1 > 1
		//-----------------------------------------------------------
		// Adiciona mais uma linha no aCols com os campos originais |
		//-----------------------------------------------------------
		AADD(aCols,Array(Len(aheader)+1))
		For _ni:=1 to Len(aheader)
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
			aCols[Len(aCols),_ni]:=xCols[1,_ni]
		Next
		aCols[Len(aCols),Len(aheader)+1]:=.F.
	EndIF
	
	
	//-------------------------------------------------
	//            Gravacao de Dados no aCols          |
	//-------------------------------------------------
	_nLin := Len(aCols)
	aCols[_nLin,_nItem]   := cItem                                    // Item da NF
	//	aCols[_nLin,_nCod]    := (cAliasTop3)->ZZ4_CODPRO                  // CODIGO DO PRODUTO
	aCols[_nLin,_nCod]    := _cProd			                           // CODIGO DO PRODUTO
	aCols[_nLin,_nUm]     := SB1->B1_UM                               // UNIDADE DE MEDIDA
	aCols[_nLin,_nSegum]  := SPACE(02)                                 // SEGUNDA UNIDADE DE MEDIDA
	//	aCols[_nLin,_nQuant]  := 1                                         // QUANTIDADE
	aCols[_nLin,_nQuant]  := _nQtdIMEI                                 // QUANTIDADE
	//	aCols[_nLin,_nVUnit]  := (cAliasTop3)->ZZ4_VLRUNI                  // PRECO DE VENDA
	aCols[_nLin,_nVUnit]  := _nVlrUni				                   // PRECO DE VENDA
	aCols[_nLin,_nTotal]  := aCols[_nLin,_nQuant]*aCols[_nLin,_nVUnit] // TOTAL
	aCols[_nLin,_nQtsegum]:= 0.0                                       // QT. SEGUNDA UNIDADE
	aCols[_nLin,_nTes]    := cTES//SB1->B1_TE                          // TES
	aCols[_nLin,_nCf]     := SF4->F4_CF                                // Codigo Fiscal
	//	aCols[_nLin,_nNumSer] := (cAliasTop3)->ZZ4_IMEI                    // Numero de Serie (Customizado)
	aCols[_nLin,_dDtdoca] := dDdoca                           		   // Data da Doca - Customizado - Edson Rodrigues - 11/07/07
	aCols[_nLin,_cHrdoca] := cHdoca                           		   // Horada Doca - Customizado - Edson Rodrigues - 11/07/07
	aCols[_nLin,_cmtdoca] := cmotdoca                           	   // Horada Doca - Customizado - Edson Rodrigues - 04/09/07
	aCols[_nLin,_nPosLot] := _cLote
	aCols[_nLin,_cPoscust] := _ccusto
	aCols[_nLin,_cPosxace] :=IIf(empty(SB1->B1_XACESS),"N",SB1->B1_XACESS) // informa se tem acessorio ou nao - Edson Rodrigues
	aCols[_nLin,_cPosdivn] :=cdivn // informa divisao de negocio, conforme armazem - Edson Rodrigues
	aCols[_nLin,_nlocal]   := clocal
	aCols[_nLin,_nOpeBGH]  := cOpe    		                           // Numero de Serie (Customizado) // M.Munhoz - 23/08/11
	// a atualizacao abaixo se faz necessario para nao ocorrer a perda de informacoes
	// quando der enter em algum campo do aCols da nota fiscal de entrada
	// Usa as funcoes MaFis???
	
	
	MaFisIniLoad(_nLin)
	MaFisLoad("IT_PRODUTO",aCols[_nLin,_nCod]    ,_nLin)
	MaFisLoad("IT_QUANT"  ,aCols[_nLin,_nQuant]  ,_nLin)
	MaFisLoad("IT_PRCUNI" ,aCols[_nLin,_nVunit]  ,_nLin)
	MaFisLoad("IT_NFORI"  ,aCols[_nLin,_nNfori]  ,_nLin)
	MaFisLoad("IT_SERORI" ,aCols[_nLin,_nSeriori],_nLin)
	MaFisLoad("IT_VALMERC",aCols[_nLin,_nTotal]  ,_nLin)
	MaFisLoad("IT_TES"    ,aCols[_nLin,_nTes]    ,_nLin)
	MaFisLoad("IT_CF"     ,aCols[_nLin,_nCf]     ,_nLin)
	MaFisLoad("IT_VALIPI" ,aCols[_nLin,_nValipi] ,_nLin)
	MaFisLoad("IT_VALICM" ,aCols[_nLin,_nValicm] ,_nLin)
	MaFisLoad("IT_ALIQIPI",aCols[_nLin,_nIpi]    ,_nLin)
	MaFisLoad("IT_ALIQICM",aCols[_nLin,_nPicm]   ,_nLin)
	MaFisRecal("",_nLin)
	MaFisEndLoad(Len(aCols))
	
	
	x1++
	cItem:=Soma1(cItem,2)
	//	(cAliasTop3)->(DbSkip())
	//adiciona acessorios conforme solicitacao do Edson - 13/06/2012
	If Len(_aAcess) > 0
		For i:=1 To Len(_aAcess)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+_aAcess[i,1])
			
			dbSelectArea("SB2")
			dbSetOrder(1)
			If !dbSeek(xFilial("SB2")+SB1->B1_COD+cLocal,.F.)
				CriaSB2(SB1->B1_COD,cLocal)
			Endif
			
			
			IF x1 > 1
				//-----------------------------------------------------------
				// Adiciona mais uma linha no aCols com os campos originais |
				//-----------------------------------------------------------
				AADD(aCols,Array(Len(aheader)+1))
				For _ni:=1 to Len(aheader)
					aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
					aCols[Len(aCols),_ni]:=xCols[1,_ni]
				Next
				aCols[Len(aCols),Len(aheader)+1]:=.F.
			EndIF
			
			
			//-------------------------------------------------
			//            Gravacao de Dados no aCols          |
			//-------------------------------------------------
			_nLin := Len(aCols)
			aCols[_nLin,_nItem]   := cItem                                    // Item da NF
			aCols[_nLin,_nCod]    := SB1->B1_COD                            // CODIGO DO PRODUTO
			aCols[_nLin,_nUm]     := SB1->B1_UM                               // UNIDADE DE MEDIDA
			aCols[_nLin,_nSegum]  := SPACE(02)                                 // SEGUNDA UNIDADE DE MEDIDA
			aCols[_nLin,_nQuant]  := _aAcess[i,2]                                // QUANTIDADE
			aCols[_nLin,_nVUnit]  := 0      				                   // PRECO DE VENDA
			aCols[_nLin,_nTotal]  := aCols[_nLin,_nQuant]*aCols[_nLin,_nVUnit] // TOTAL
			aCols[_nLin,_nQtsegum]:= 0.0                                       // QT. SEGUNDA UNIDADE
			aCols[_nLin,_nTes]    := cTES//SB1->B1_TE                          // TES
			aCols[_nLin,_nCf]     := SF4->F4_CF                                // Codigo Fiscal
			aCols[_nLin,_dDtdoca] := dDdoca                           		   // Data da Doca - Customizado - Edson Rodrigues - 11/07/07
			aCols[_nLin,_cHrdoca] := cHdoca                           		   // Horada Doca - Customizado - Edson Rodrigues - 11/07/07
			aCols[_nLin,_cmtdoca] := cmotdoca                           	   // Horada Doca - Customizado - Edson Rodrigues - 04/09/07
			aCols[_nLin,_nPosLot] := _cLote
			aCols[_nLin,_cPoscust] := _ccusto
			aCols[_nLin,_cPosxace] :=IIf(empty(SB1->B1_XACESS),"N",SB1->B1_XACESS) // informa se tem acessorio ou nao - Edson Rodrigues
			aCols[_nLin,_cPosdivn] :=cdivn // informa divisao de negocio, conforme armazem - Edson Rodrigues
			aCols[_nLin,_nlocal]   := clocal
			aCols[_nLin,_nOpeBGH]  := cOpe    		                           // Numero de Serie (Customizado) // M.Munhoz - 23/08/11
			// a atualizacao abaixo se faz necessario para nao ocorrer a perda de informacoes
			// quando der enter em algum campo do aCols da nota fiscal de entrada
			// Usa as funcoes MaFis???
			
			MaFisIniLoad(_nLin)
			MaFisLoad("IT_PRODUTO",aCols[_nLin,_nCod]    ,_nLin)
			MaFisLoad("IT_QUANT"  ,aCols[_nLin,_nQuant]  ,_nLin)
			MaFisLoad("IT_PRCUNI" ,aCols[_nLin,_nVunit]  ,_nLin)
			MaFisLoad("IT_NFORI"  ,aCols[_nLin,_nNfori]  ,_nLin)
			MaFisLoad("IT_SERORI" ,aCols[_nLin,_nSeriori],_nLin)
			MaFisLoad("IT_VALMERC",aCols[_nLin,_nTotal]  ,_nLin)
			MaFisLoad("IT_TES"    ,aCols[_nLin,_nTes]    ,_nLin)
			MaFisLoad("IT_CF"     ,aCols[_nLin,_nCf]     ,_nLin)
			MaFisLoad("IT_VALIPI" ,aCols[_nLin,_nValipi] ,_nLin)
			MaFisLoad("IT_VALICM" ,aCols[_nLin,_nValicm] ,_nLin)
			MaFisLoad("IT_ALIQIPI",aCols[_nLin,_nIpi]    ,_nLin)
			MaFisLoad("IT_ALIQICM",aCols[_nLin,_nPicm]   ,_nLin)
			MaFisRecal("",_nLin)
			MaFisEndLoad(Len(aCols))
			
			x1++
			cItem:=Soma1(cItem,2)
		Next i
	Endif
	_aAcess := {}
EndDo

_nLin:= 1

oGetDados:ForceRefresh()
//DbCloseArea(cAliasTop3) -  //Alterado conforme chamado microsiga SDJHBQ - Edson Rodrigues - 05/04/11
(cAliasTop3)->(DbCloseArea())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VALDOCA  ºAutor  ³ Edson Rodrigues    º Data ³  13/05/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para validar a Data da Doca                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function Valdoca(dDdoca,cHdoca,cOpe,clab)

local _lRet    := .t.
local _cusdoca :=GETMV('MV_UDTDOCA')
Local _nPersis :=GETMV('MV_QTDDOCA') //Quantidade de dias tolerávela para a Doca quando não estiver especificado no ZZJ e o usuário não pertencer ao parametro MV_UDTDOCA
local _nPer    := 0
local _cOper
local _cLab


_cOper	:= Posicione("ZZ4",3,xFilial("ZZ4") + cNFEntr + cSerEntr + CA100FOR + CLOJA ,"ZZ4_OPEBGH")
_clab	:= POSICIONE("ZZJ",1,xFilial("ZZJ") + _cOper,"ZZJ_LAB")
_nPer	:= Posicione("ZZJ",1,xFilial("ZZJ") + _cOper + _clab ,"ZZJ_PERDOC")



If (_cusdoca $ __cUserID)
	_lRet := dDataBase>=dDdoca
	
Elseif  (_nPer <= 0)
	_lRet := (dDataBase-dDdoca) <= _nPersis .and. dDataBase>=dDdoca
	//desabilitado "ELSE" conforme necessidade do Claudio Biale.
	//Retornado em 05/01/10
ElseIf _nPer > 0
	_lRet := (dDataBase-dDdoca) <= _nPer .and. dDataBase>=dDdoca
Endif


//desabilitado "IF" abaixo conforme necessidade do Claudio Biale.
//Retornado em 05/01/10
If !_lRet
	If _nPer > 0
		Msgalert('Data da Doca não pode ser inferior a '+AllTrim(Transform(_nPer, "@E 999")) + ' dias ou maior que a data do sistema, peça para um usuário autorizado mudar ou contate o administrador do sistema','Validação Entrada Massiva')
	Else
		Aviso('Data da Doca','Data da Doca nao pode ser maior que a data do sistema, peca para um usuario autorizado a incluir o Doc. de Entrada ou contate o administrador do sistema',{'OK'})
	Endif
Endif

If left(cHdoca,2) > '23' .or.  substr(cHdoca,3,2) > '59' .or. substr(cHdoca,5,2) > '59'
	_lRet :=.f.
	Msgalert('Hora digitada inválida. Digite uma hora válida','Validação Entrada Massiva')
Endif

return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VALDARMZ ºAutor  ³ Edson Rodrigues    º Data ³  16/06/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para validar armazem digitado                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function VALDARMZ(carmaz,copebgh)

local _lRet    := .t.
local _carmzzj := POSICIONE("ZZJ",1,xFilial("ZZJ") + copebgh,"ZZJ_ARMENT")


If carmaz $ alltrim(_carmzzj)
	_lRet := .t.
Else
	_lRet := .f.
Endif

If !_lRet
	Msgalert('O armazem nao esta cadastrado no cadastro de operacaoes',' Armazem Invalido')
Endif

return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Filcount ºAutor  ³Edson Rodrigues     º Data ³ 31/01/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina fara o filtro e contara quantos locais         º±±
±±º          | diferentes por operação                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Filcount()

DbSelectArea("ZZ4")
cAliasTop4	:= GetNextAlias()

//Alterado o select para com campos fixos, a fim de melhorar a performance. Edson Rodrigues - 06/05/10
//Inclusao dos campos ZZ4_OPEBGH no SELECT e dos ZZ4_VLRUNI e ZZ4_OPEBGH no ORDER BY. M.Munhoz - 23/08/11
_cQuery := " SELECT ZZ4_OPEBGH,ZZ4_LOCAL,COUNT(ZZ4_LOCAL) QTDARMZ, ZZ4_CODCLI"
_cQuery += " FROM " + RetSqlName("ZZ4") + " (nolock) "
_cQuery += " WHERE ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND "
_cQuery += "   D_E_L_E_T_ = ''  AND "
_cQuery += "   ZZ4_STATUS = '2' AND "  // Entrada Massiva Confirmada
_cQuery += "   ZZ4_NFENR  = '"+cNFEntr+"' AND "
_cQuery += "   ZZ4_NFESER = '"+cSerEntr  +"' AND "
_cQuery += "   ZZ4_CODCLI = '"+CA100FOR+"' AND "
_cQuery += "   ZZ4_LOJA   = '"+CLOJA   +"' "
_cQuery += " GROUP BY ZZ4_OPEBGH,ZZ4_LOCAL,ZZ4_CODCLI "
_cQuery += " ORDER BY ZZ4_OPEBGH,ZZ4_LOCAL,ZZ4_CODCLI "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery),cAliasTop4,.T.,.T.)

(cAliasTop4)->(DBGoTop())

Return()


Static Function ProcAcess()
Local aArea := GetArea()

DbSelectArea("SZC")
cAliasSZC	:= GetNextAlias()

_cQuery := " SELECT ZC_ACESS AS ACESS, COUNT(*) AS QTACES"
_cQuery += " FROM " + RetSqlName("SZC") + " (nolock) "
_cQuery += " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND "
_cQuery += "   D_E_L_E_T_ = ''  AND "
_cQuery += "   ZC_STATUS = '1' AND "
_cQuery += "   ZC_CODPRO  = '"+_cProd+"' AND "
_cQuery += "   ZC_DOC  = '"+cNFEntr+"' AND "
_cQuery += "   ZC_SERIE = '"+cSerEntr  +"' AND "
_cQuery += "   ZC_FORNECE = '"+CA100FOR+"' AND "
_cQuery += "   ZC_LOJA   = '"+CLOJA   +"' "
_cQuery += " GROUP BY ZC_ACESS "
_cQuery += " ORDER BY ZC_ACESS "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery),cAliasSZC,.T.,.T.)

(cAliasSZC)->(DBGoTop())

while !(cAliasSZC)->(EOF())
	aadd(_aAcess,{(cAliasSZC)->ACESS,(cAliasSZC)->QTACES})
	(cAliasSZC)->(DbSkip())
enddo

(cAliasSZC)->(DbCloseArea())

RestArea(aArea)

Return
