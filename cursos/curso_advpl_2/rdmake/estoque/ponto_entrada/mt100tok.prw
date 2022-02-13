#Include "PROTHEUS.Ch"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100TOK ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na confirmacao da NFE para validar TES e  º±±
±±º          ³ Almoxarifado.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function mt100tok()

local _lRet     := .t.
local _nPosLoc  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_LOCAL" })
local _nPosTES  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_TES"   })
local _aLocal   := {}
local _aTES     := {}
local _nPosDtD  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DTDOCA" })
local _nPosHrD  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_HRDOCA" })
local _nPosmodev:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_MOTDEVO"})
local _nPosdivne:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DIVNEG" })
local _nPospcomp:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_PEDIDO" })
local _nPositpco:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMPC" })
local _nPosCC   := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_CC"     }) 
local _nPosTot  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_TOTAL"  })
local _ctipo    := ctipo
local _adtdoca  := {}
local _adthdoc  := {}
local _nPosprod := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_COD"})
local _nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEM"})
local _nPositgrd:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMGRD"})
local _nPosiqtde:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_QUANT"})
Local aTitulos  := {}
Local cNomefor  := ""
Local nRecSE2   := SE2->(Recno())
Local nRecSA2   := SA2->(Recno())
Local nTotSaldo := 0
Local ddemissao
Local _cARMRPG   := GetMV("MV_XARMRPG")
Local _nqtdeZZ4:= 0
Local _nvalrZZ4:= 0  
Local _nqtdeSD1:= 0
Local _nvalrSD1:= 0
//Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
Private cNextSp		:= GetMv("MV_NEXTSP")
Private cNextRj     := GetMv("MV_NEXTRJ")
Private cNFEntr	   := IIF(EMPTY(CNFISCAL) .and. EMPTY(CSERIE),"999999999",CNFISCAL)
Private cSerEntr   := IIF(EMPTY(CNFISCAL) .and. EMPTY(CSERIE),"999",CSERIE)
u_GerA0003(ProcName())


//+----------------------------------------------------------------------------------+
//|exclusa a rotina MATA920 "Nota fiscal Manual de Saída" para este ponto de entrada |
//|conforme chamado id 9033                                                          |
//+----------------------------------------------------------------------------------+
IF !Upper(Funname()) $ "MATA920*IPTXTGCOM"
	
	
	for x := 1 to len(aCols)
		
		if !empty(aCols[x,_nPosLoc]) .and. aScan(_aLocal, aCols[x,_nPosLoc]) <= 0
			aAdd(_aLocal, aCols[x,_nPosLoc])
		endif
		if !empty(aCols[x,_nPosTES]) .and. aScan(_aTES  , aCols[x,_nPosTES]) <= 0
			aAdd(_aTES  , aCols[x,_nPosTES])
		endif
		if !empty(aCols[x,_nPosDtD]) .and. aScan(_adtdoca  , aCols[x,_nPosDtD]) <= 0
			aAdd(_adtdoca  , aCols[x,_nPosDtD])
		endif
		if !empty(aCols[x,_nPosHrD]) .and. aScan(_adthdoc  , aCols[x,_nPosHrD]) <= 0
			aAdd(_adthdoc  , aCols[x,_nPosHrD])
		endif
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida motivo de Devolucao quando for Devolucao                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !empty(_ctipo) .and. !empty(aCols[x,_nPosmodev])
			if _ctipo=="D" .and. aCols[x,_nPosmodev]=="00"
				apMsgStop("Caro usuário, por favor informe o Motivo de Devolução válido para o item " + aCols[n,_nPosItem], "Motivo de Devolução Invalido" )
				_lRet := .f.
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida armazem digitado para operacoes que envolvem entrada massiva  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_lRet := u_valarmem(cnfiscal,cserie,cA100For,cloja,aCols[x,_nPosprod],aCols[x,_nPosLoc])
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida e preenche a  Divisão de Negocio / Centro de Custo quando for PC   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !empty(aCols[x,_nPospcomp]) .and. !empty(aCols[x,_nPositpco])
			_cProd := aCols[x,_nPosprod]
			_cpcomp:= aCols[x,_nPospcomp]
			_citpco:= aCols[x,_nPositpco]
			_cdivne:= aCols[x,_nPosdivne]
			_cItem := aCols[x,_nPositem]
			_clocal:= aCols[x,_nPosLoc]
			_cCcust:= aCols[x,_nPosCC]
			
			_cnewdiv:= valdneg(_cProd,_cpcomp,_citpco,_cdivne,_cItem,_clocal,_cCcust,_nPosCC,x)
			If empty(_cnewdiv)
				_lRet := .f.
			Else
				if _cdivne<>_cnewdiv
					aCols[x,_nPosdivne]:=_cnewdiv
				Endif
				
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Confirma gravacao de cadastro na tabela ZZL para cada item da NFE.   |
		//³Nesse momento, grava o campo status com valor 1- confirmado          |
		//|Edson Rodrigues - 28/06/10                                           |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if aCols[x,_nPosLoc] $ alltrim(_cARMRPG) .and. cA100For <> "Z00403"
			_lRet :=U_CADOSPRG(cnfiscal,cserie,cA100For,cloja,cformul,aCols[x,_nPosItem],aCols[x,_nPositgrd],aCols[x,_nPosProd],ddemissao,ddatabase,aCols[x,_nPosiqtde],'1')
		endif
		
		_nqtdeSD1:= _nqtdeSD1 + aCols[x,_nPosiqtde]
		_nvalrSD1:= _nvalrSD1 + aCols[x,_nPosTot] 
		
	next x
	
	if len(_aLocal) > 1
		if !apMsgYesNo('Existe mais de 1 almoxarifado informado nesta Nota Fiscal de Entrada. Confirma inclusão?', 'Almoxarifados diferentes na mesma NFE')
			_lRet := .f.
		endif
	endif
	
	if len(_aTES) > 1
		if !apMsgYesNo('Existe mais de 1 TES informado nesta Nota Fiscal de Entrada. Confirma inclusão?', 'TES diferentes na mesma NFE')
			_lRet := .f.
		endif
	endif
	
	
	If AllTrim(cESPECIE) == "CTR" .And. Empty(AllTrim(CCONDICAO))
		MsgStop("Para Documentos de Transporte é Obrigatrio Inserir Condições de Pagamento !!!", "Condição de Pagamento.")
		_lRet := .f.
	EndIf
	
	If _lRet
		/* Rotina de Amarracao de conhecimento de frete com as Notas fiscais de saida CLAUDIA 01/12/2008 */
		/* RETIRADA CHAMADA DA FUNÇAO DESTE P.E., CONFORME SOLICITACAO DO CARLOS ROCHA E COLOCADO NO
		P.E. MT100GRV
		If ALLTRIM(cESPECIE) == "CTR"
		iF FINDFUNCTION("U_CONHECFR")
		U_Conhecfr(cNFiscal,cSerie,dDemissao,cLoja,ca100for)
		Return .T.
		ENDIF
		EndIF
		*/
		/* ------- FIM ROTINA DE AMARRACAO CONHECIMENTO DE FRETE --------------------------*/
	EndIf
     
	//Solicitação Luiz Reis GLPI 20531 
	If _lRet
		For i:= 1 to Len(acols)
			cLocaliz :=Posicione("SB1",1,xFilial("SB1") + aCols[i,_nPosProd], "B1_LOCALIZ")
			If cLocaliz == "S" .and. Alltrim(aCols[i,_nPosLoc]) $ "10/11"//ACESSORIOS
				//Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
				//If (CA100FOR == "000016" .and. CLOJA == "01") .and. Alltrim(aCols[i,_nPosLoc]) <> "10"
		        If (CA100FOR $ Alltrim(cNextSp) .and. CLOJA == "01") .and. Alltrim(aCols[i,_nPosLoc]) <> "10"
					apMsgStop("Armazem informado divergente para o fornecedor "+CA100FOR+"/"+CLOJA+". Favor verificar!", "Armazem Divergente")
					_lRet := .f.
					Exit
				//ElseIf (CA100FOR == "000680" .and. CLOJA == "01") .and. Alltrim(aCols[i,_nPosLoc]) <> "11"
				ElseIf (CA100FOR $ Alltrim(cNextRj) .and. CLOJA == "01") .and. Alltrim(aCols[i,_nPosLoc]) <> "11"
					apMsgStop("Armazem informado divergente para o fornecedor "+CA100FOR+"/"+CLOJA+". Favor verificar!", "Armazem Divergente")
					_lRet := .f.
					Exit
				Endif	
			Endif	
		Next i	
	Endif
	
	If l103Class
	
		If Select("ZZ4") == 0
			DbSelectArea("ZZ4")
		EndIf
		ZZ4->(DbSetOrder(3))				
		ZZ4->(DbGoTop())
		// Verifica se existe entrada massiva disponivel para inclusao da NFE
		If !ZZ4->(dbSeek(xFilial('ZZ4') + AvKey(cNFEntr,"ZZ4_NFENR") + AvKey(cSerEntr,"ZZ4_NFESER") + AvKey(CA100FOR,"ZZ4_CODCLI") + AvKey(cLoja,"ZZ4_LOJA")))// + AvKey(aCols[i,_nPosprod],"ZZ4_CODPRO")))
		
			If !apmsgyesno('Nao foi localizada a entrada massiva para essa Nota Fiscal. É de sua responsabilidade classificá-la ' ;
				+'sem existir a Entrada Massiva. Tem certeza que deseja classificá-la?')
				_lRet := .f.	
			EndIf	
		Else 
			If ZZ4->ZZ4_STATUS < "4" 
				While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFENR == AvKey(cNFEntr,"ZZ4_NFENR") .and. ;
					ZZ4->ZZ4_NFESER == AvKey(cSerEntr,"ZZ4_NFESER") .and. ZZ4->ZZ4_CODCLI == AvKey(CA100FOR,"ZZ4_CODCLI") .and.  ;
					ZZ4->ZZ4_LOJA == AvKey(cLoja,"ZZ4_LOJA") //.and. ZZ4->ZZ4_CODPRO == AvKey(aCols[i,_nPosprod],"ZZ4_CODPRO")					
					_nqtdeZZ4:=_nqtdeZZ4+1
					_nvalrZZ4:=_nvalrZZ4+ZZ4->ZZ4_VLRUNI					
					ZZ4->(dbSkip())
				Enddo
				If _nqtdeSD1 <> _nqtdeZZ4
					apMsgStop("A quantidade informada na Nota Fiscal está divergente da quantidade da Entrada Massiva. Favor verificar a entrada massiva!", "Entrada Massiva Divergente")
					_lRet := .f.
				ElseIf _nvalrSD1 <> _nvalrZZ4
					apMsgStop("O valor total informado na Nota Fiscal está divergente da quantidade da Entrada Massiva. Favor verificar a entrada massiva!", "Entrada Massiva Divergente")
					_lRet := .f.
				EndIf		
			Else			
				apMsgStop("A entrada massiva pertencente a esta Nota Fiscal está com um status avançado. Favor verificar a entrada massiva!", "Entrada Massiva Divergente")
				_lRet := .f.
			EndIf
		EndIf
		
	EndIf     

EndIf

return(_lRet)



/* funcoes da rotina de frete Claudia 01/12/2008 --*/
/* FUNCOES UTILIZADAS NO PONTO DE ENTRADA */
User Function Conhecfr(cNFiscal,cSerie,dDemissao,cLoja,ca100for)

/* Tela de Amarracao do conhecimento de frete */

Local aCombo1    := {"Sim","Nao"}
Local oDlgNF
Private cCombo1  := aCombo1[1]
Private aNotas   := {}
Private oOk      := LoadBitmap( GetResources(), "LBOK" )
Private oNo      := LoadBitmap( GetResources(), "LBNO" )
Private oTik     := LoadBitmap( GetResources(), "LBTIK" )
Private cxNota   := space(9)
Private cxSerie  := space(3)
Private nTotal   := 0
DEFINE MSDIALOG oDlgNF FROM 87 ,52  TO 450,609 TITLE "Notas Fiscais para amarracao"  PIXEL

@ 007,006 SAY  "Pesquisa Nota Fiscal+serie: " Of oDlgNF PIXEL
@ 007,080 MSGET cxNota  PIXEL SIZE 15,09
@ 007,120 MSGET cxSerie PIXEL SIZE 10,09 Valid u_BuscaNF(cxNota,cxSerie)
@ 007,140 SAY "Filtrar notas com conhecimento de frete" Of oDlgNF PIXEL SIZE 100 ,9
@ 007,245 MSCOMBOBOX oCombo1 VAR cCombo1 ITEMS aCombo1 SIZE 30 ,50 ON CHANGE Iif(!Empty(cxNota),u_BuscaNf(cXNota,cxSerie),u_AtuBrow())  OF oDlgNF PIXEL VALID ("SN")
@ 020,006 listbox oListBox fields HEADER " ","Nota Fiscal","Serie","Emissao","Cliente","Loja","Valor" FIELDSIZES  10,50 , 30, 40, 40,20,50  SIZE 260,140 OF oDlgNF pixel ON DBLCLICK (nPos:=oListbox:nAt,U_FS_MarcaNF(),oListbox:Refresh(),oListbox:nAt:=nPos)
If Empty(cxNota)
	U_AtuBrow()
EndIF

@ 165,040 BUTTON "OK" SIZE 52,12  ACTION If(U_GravaNFS(),(lRet:=.T.,oDlgNF:End()),lRet:=.t.) of oDlgNF PIXEL
@ 165,100 BUTTON "CANCELA" SIZE 52,12  ACTION (oDlgNF:End()) OF oDlgNF PIXEL
//@ 165,180 MSGET TRANSFORM(nTotal ,"@E 999,999,999,999.99") PIXEL SIZE 40,09

ACTIVATE MSDIALOG oDlgNF CENTERED

Return .t.



User Function AtuBrow()
/* utilizada na rotina de frete */
LOCAL cQrySF2    := ""
Local cQrySF1    := ""
Local cDtBase := Date() - 90
cDtbase  = Dtos(cDtBase)

//Adicionado - Edson Rodrigues - 26/12/08
if Select("TRB") > 0
	TRB->(dbCloseArea())
endif

if Select("TRB2") > 0
	TRB2->(dbCloseArea())
endif

/* Seleciona NF's de Saida */
cQrySF2     := "SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO, F2_CLIENTE,F2_LOJA,F2_VALBRUT "
cQrySF2     += "FROM " + RetSqlName("SF2") + " SF2 "
cQrySF2     += "WHERE F2_FILIAL='" +  CFILANT + "' AND"
If cCombo1 = "S"
	cQrySF2    += " F2_XAMFRE <> 'S' AND"
EndIF
cQrySF2     += " SF2.F2_EMISSAO >= '" + cDtBase + "'"
cQrySF2     += " AND SF2.D_E_L_E_T_ = ' '"
DbSelectArea("SF2")
astru = dbStruct()

cQrySF2 := ChangeQuery(cQrySF2)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySF2), 'TRB', .F., .T.)
For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('TRB', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

/* Seleciona NF's de Entrada */
cQrySF1     := "SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_EMISSAO, F1_FORNECE,F1_LOJA,F1_VALBRUT "
cQrySF1     += "FROM " + RetSqlName("SF1") + " SF1 "
cQrySF1     += "WHERE F1_FILIAL='" +  CFILANT + "' AND"
If cCombo1 = "S"
	cQrySF1    += " F1_XAMFRE <> 'S' AND"
EndIF
cQrySF1     += " SF1.F1_EMISSAO >= '" + cDtBase + "'"
cQrySF1     += " AND SF1.D_E_L_E_T_ = ' '"

DbSelectArea("SF1")
astru = dbStruct()

cQrySF1 := ChangeQuery(cQrySF1)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySF1), 'TRB2', .F., .T.)
For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('TRB2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next
aNotas:={}

TRB->(dBGoTop())
Do While ! TRB->(Eof())
	aAdd(aNotas,{ .F.,;
	TRB->F2_DOC,;
	TRB->F2_SERIE,;
	TRB->F2_EMISSAO,;
	TRB->F2_CLIENTE,;
	TRB->F2_LOJA,;
	TRB->F2_VALBRUT})
	TRB->(DbSkip())
EndDo

TRB2->(dBGoTop())
Do While ! TRB2->(Eof())
	aAdd(aNotas,{ .F.,;
	TRB2->F1_DOC,;
	TRB2->F1_SERIE,;
	TRB2->F1_EMISSAO,;
	TRB2->F1_FORNECE,;
	TRB2->F1_LOJA,;
	TRB2->F1_VALBRUT})
	TRB2->(DbSkip())
EndDo
Asort(aNotas,,,{|x,y| x[2]+x[3] < y[2]+y[3]})
DbSelectArea("TRB")
dbCloseArea()

DbSelectArea("TRB2") //adicionado Edson Rodrigues - 26/12/08
dbCloseArea()

oListBox:SetArray(aNotas)
nfound := Ascan(aNotas,{|aval| aval[2]=cxnota .and. aval[3] == Cxserie})
If nfound > 0
	oListbox:nAt := nFound
Else
	oListbox:nAt := 1
EndIf
oListBox:bLine := { || { if(aNotas[oListBox:nAt,01] == .f.,oNo,oTik),;
aNotas[oListBox:nAt,02],;
aNotas[oListBox:nAt,03],;
aNotas[oListBox:nAt,04],;
aNotas[oListBox:nAt,05],;
aNotas[oListBox:nAt,06],;
Transform(aNotas[oListBox:nAt,7],"@E 99,999,999,999.99")}}
oListBox:Refresh()
Return .t.

User Function BuscaNf(xnota,xserie)
LOCAL cQrySF2    := ""
Local cQrySF1    := ""

If  !Empty(xNota)
	IF Len(aNotas) <=0
		u_AtuBrow()
	EndIf
	nfound := Ascan(aNotas,{|aval| aval[2]=xnota .and. aval[3] == xserie})
	If nfound > 0
		oListBox:nAt := nFound
		oListBox:Refresh()
	Else
		/* Busca NFS com mais de 3 meses */
		if Select("TRB") > 0
			TRB->(dbCloseArea())
		endif
		
		if Select("TRB2") > 0
			TRB2->(dbCloseArea())
		endif
		/* Seleciona NF's de Saida */
		cQrySF2     := "SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO, F2_CLIENTE,F2_LOJA,F2_VALBRUT "
		cQrySF2     += "FROM " + RetSqlName("SF2") + " SF2 "
		cQrySF2     += "WHERE F2_FILIAL='" +  CFILANT + "' AND"
		If cCombo1 = "S"
			cQrySF2    += " F2_XAMFRE <> 'S' AND"
		EndIF
		cQrySF2     += " SF2.F2_DOC   = '" + xNota + "'"
		cQrySF2     += " AND SF2.F2_SERIE = '" + xSerie + "'"
		cQrySF2     += " AND SF2.D_E_L_E_T_ = ' '"
		DbSelectArea("SF2")
		astru = dbStruct()
		
		cQrySF2 := ChangeQuery(cQrySF2)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySF2), 'TRB', .F., .T.)
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('TRB', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
		
		/* Seleciona NF's de Entrada */
		cQrySF1     := "SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_EMISSAO, F1_FORNECE,F1_LOJA,F1_VALBRUT "
		cQrySF1     += "FROM " + RetSqlName("SF1") + " SF1 "
		cQrySF1     += "WHERE F1_FILIAL='" +  CFILANT + "' AND"
		If cCombo1 = "S"
			cQrySF1    += " F1_XAMFRE <> 'S' AND"
		EndIF
		cQrySF1     += " SF1.F1_DOC   = '" + xNota + "'"
		cQrySF1     += " AND SF1.F1_SERIE = '" + xSerie + "'"
		cQrySF1     += " AND SF1.D_E_L_E_T_ = ' '"
		
		DbSelectArea("SF1")
		astru = dbStruct()
		
		cQrySF1 := ChangeQuery(cQrySF1)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySF1), 'TRB2', .F., .T.)
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('TRB2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
		
		TRB->(dBGoTop())
		Do While ! TRB->(Eof())
			//dDemissao := TRB->F2_EMISSAO -- //Comentado para atender ticket 13163 carregando data incorreta e bloqueando o campopara emissao //carlos.vieira
			aAdd(aNotas,{ .F.,;
			TRB->F2_DOC,;
			TRB->F2_SERIE,;
			TRB->F2_EMISSAO,;
			TRB->F2_CLIENTE,;
			TRB->F2_LOJA,;
			TRB->F2_VALBRUT})
			TRB->(DbSkip())
		EndDo
		
		TRB2->(dBGoTop())
		Do While ! TRB2->(Eof())
			aAdd(aNotas,{ .F.,;
			TRB2->F1_DOC,;
			TRB2->F1_SERIE,;
			TRB2->F1_EMISSAO,;
			TRB2->F1_FORNECE,;
			TRB2->F1_LOJA,;
			TRB2->F1_VALBRUT})
			TRB2->(DbSkip())
		EndDo
		Asort(aNotas,,,{|x,y| x[2]+x[3] < y[2]+y[3]})
		DbSelectArea("TRB")
		dbCloseArea()
		
		DbSelectArea("TRB2") //adicionado Edson Rodrigues - 26/12/08
		dbCloseArea()
		
		oListBox:SetArray(aNotas)
		nfound := Ascan(aNotas,{|aval| aval[2]=cxnota .and. aval[3] == Cxserie})
		If nfound > 0
			oListbox:nAt := nFound
		Else
			oListbox:nAt := 1
			n
		EndIf
		oListBox:bLine := { || { if(aNotas[oListBox:nAt,01] == .f.,oNo,oTik),;
		aNotas[oListBox:nAt,02],;
		aNotas[oListBox:nAt,03],;
		aNotas[oListBox:nAt,04],;
		aNotas[oListBox:nAt,05],;
		aNotas[oListBox:nAt,06],;
		Transform(aNotas[oListBox:nAt,7],"@E 99,999,999,999.99")}}
		oListBox:Refresh()
		/*-------------------------------------------*/
		
		//	oListBox:nAt := 1
		//	oListBox:Refresh()
	Endif
Endif
Return

User Function FS_MarcaNf()
/* utilizada na rotina de frete */
If aNotas[oListbox:nAt,1] == .f.
	aNotas[oListBox:nAt,1] := .t.
	nTotal:= nTotal + aNotas[oListBox:nAt,07]
	@ 165,160 MSGET TRANSFORM(nTotal ,"@E 999,999,999,999.99") PIXEL SIZE 40,09
Else
	aNotas[oListBox:nAt,1] := .f.
	nTotal:= nTotal - aNotas[oListBox:nAt,07]
	@ 165,160 MSGET TRANSFORM(nTotal ,"@E 999,999,999,999.99") PIXEL SIZE 40,09
Endif

oListBox:SetArray(aNotas)
oListBox:bLine := { || { if(aNotas[oListBox:nAt,01] == .f.,oNo,oTik),;
aNotas[oListBox:nAt,02],;
aNotas[oListBox:nAt,03],;
aNotas[oListBox:nAt,04],;
aNotas[oListBox:nAt,05],;
aNotas[oListBox:nAt,06],;
Transform(aNotas[oListBox:nAt,7],"@E 99,999,999,999.99")}}
Return .t.

User Function GravaNFS()
/* utilizada na rotina de frete */
Local ntotalnf := 0
Local nRecSF1 := 0
Private ccfilial := cfilant
If Type("cNfiscal")="U"
	Private cNfiscal  := SF1->F1_DOC
	Private cSerie    := SF1->F1_SERIE
	Private ca100For  := SF1->F1_FORNECE
	Private cLoja     := SF1->F1_LOJA
	Private dDemissao := SF1->F1_EMISSAO
	cfilial 		  := SF1->F1_FILIAL
	nxtotnota 		  := SF1->F1_VALBRUT
Else
	nxtotnota 		  := MaFisRet(,"NF_TOTAL")
EndIf
CHKFILE("Z11",.F.)
Z11->(MsSeek(Xfilial("Z11")+cNfiscal+cSerie+ca100For+cLoja,.t.))
Do While ! Z11->(EOF()) .AND. Z11->Z11_FILIAL+Z11->Z11_CTRNFE+Z11->Z11_SERIE+Z11->Z11_FORNECE+Z11->Z11_LOJA==ccfilial+cNfiscal+cSerie+ca100For+cLoja
	nTotalNf += Z11->Z11_VLRNFV
	Z11->(DbSkip())
EndDo
For i = 1 to Len(aNotas)
	If aNotas[i,1] // NF selecionada
		If Z11->(MsSeek(Xfilial("Z11")+cNfiscal+cSerie+ca100For+cLoja+aNotas[i,2]+aNotas[i,3]+aNotas[i,5]+aNotas[i,6],.t.))
			Reclock("Z11",.f.)
			nTotalNf -= Z11->Z11_VLRNFV
			Z11->Z11_EMISNFV := aNotas[i,4]
			Z11->Z11_VLRNFV  := aNotas[i,7]
			nTotalNf += aNotas[i,7]
		Else
			RecLock("Z11",.t.)
			Z11->Z11_FILIAL  := CFILANT
			Z11->Z11_CTRNFE  := cNfiscal
			Z11->Z11_SERIE   := cSerie
			Z11->Z11_EMISSAO := dDemissao
			Z11->Z11_DIGIT   := dDataBase
			Z11->Z11_FORNECE := ca100For
			Z11->Z11_LOJA    := cLoja
			Z11->Z11_DOC     := aNotas[i,2]
			Z11->Z11_SERIES  := aNotas[i,3]
			Z11->Z11_EMISNFV := aNotas[i,4]
			Z11->Z11_CLIENT  := aNotas[i,5]
			Z11->Z11_LOJACLI := aNotas[i,6]
			Z11->Z11_VLRNFV  := aNotas[i,7]
			nTotalNf += aNotas[i,7]
		EndIf
		MsUnlock()
		SF2->(DbSetOrder(1))
		If SF2->(Dbseek(Xfilial("SF2")+aNotas[i,2]+aNotas[i,3]+aNotas[i,5]+aNotas[i,6]))
			RecLock("SF2",.F.)
			SF2->F2_XAMFRE := "S"
			MsUnlock()
		Endif
		NRecSf1 := SF1->(RecNo())
		SF1->(DbSetOrder(1))
		If SF1->(Dbseek(Xfilial("SF1")+aNotas[i,2]+aNotas[i,3]+aNotas[i,5]+aNotas[i,6]))
			RecLock("SF1",.F.)
			SF1->F1_XAMFRE := "S"
			MsUnlock()
		Endif
		SF1->(DBGOTO(NRECSF1))
		
	Endif
Next
MsgAlert("Total do Conhecimento    : " + Alltrim(transform(nxtotnota,"@E 9,999,999,999,999.99")) + CHR(13) + CHR(10) +;
" Total de Vendas amarrado: " + Alltrim(transform(nTotalNF,"@E 9,999,999,999,999.99")) )
return .t.

/*----- fim funcoes frete ------------------------ */


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³Microsiga           º Data ³  08/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function valdneg(_cProd,_cpcomp,_citpco,_cdivne,_cItem,_clocal,_cCcust,_nPosCC,x)
local _aAreaSC7 := SC7->(GetArea())
local _cdivsc7 := ""
Local _cccSC7  := ""
local _lpassou := .t.

_cdivsc7 := Posicione("SC7",4,xFilial("SC7") + _cProd+_cpcomp+_citpco, "C7_DIVNEG")
_cccSC7  := Posicione("SC7",4,xFilial("SC7") + _cProd+_cpcomp+_citpco, "C7_CC")

if empty(_cdivne) .and. empty(_cdivsc7)
	apMsgStop("Caro usuário, por favor informe a Divisão de negocio do item " + _cItem, "Div. Negocio nao Preenchida no Ped. Compra/Doc.Entrada")
	
Else
	
	do case
		Case (_clocal $ "80/81" .and. substr(_cProd,1,2)=="Z-") .and. _cdivne<>"06"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem, "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
		Case (_clocal $ "83/84" .and. substr(_cProd,1,2)=="B-") .and. (_cdivne<>"05" .AND. _cdivne<>"15" .AND. _cdivne<>"13")
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem, "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
		Case (_clocal == "87" .and. substr(_cProd,1,2)=="S-") .and. _cdivne<>"07"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem, "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
		Case _clocal $ "01/1A/1B" .and. !substr(_cProd,1,2) $ "S-/Z-/B-" .and. _cdivne<>"04"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem, "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
		Case _clocal == "21" .and. !substr(_cProd,1,2) $ "S-/Z-/B-" .and. _cdivne<>"03"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem, "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
			//Nao validar divisao de negocio quando for pedido de compra - pois ja foi validado ao fazer o pedido de compra -  Edson Rodrigues - 01/04/09
			//Case _clocal == "51" .and. !substr(_cProd,1,2) $ "S-/Z-/B-" .and.  _cdivne<>"09"
			//   apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem, "Div. Negócio errada")
			//   _cdivsc7 := ""
			//   _lpassou :=.f.
			
		Case _clocal $ "70/71/72/73" .and.  _cdivne <>"14"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem, "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
		Case _clocal == "92" .and.  _cdivne <>"15"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem , "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
		Case _clocal $ "30/31" .and.  _cdivne <>"16"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem , "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
		Case _clocal == "75" .and.  _cdivne <>"17"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + _cItem , "Div. Negócio errada")
			_cdivsc7 := ""
			_lpassou :=.f.
			
			
	Endcase
	
	If _lpassou .and. _cdivsc7<>_cdivne
		_cdivsc7:=_cdivne
	Endif
	
	// Valida e corrige centro de custo da entrada, quando diferente do Pedido de compra - Edson Rodrigues
	//Comentado conforme chamado - 16596
	/*if !empty(_cccSC7) .and. _cccSC7<>_cCcust
		aCols[x,_nPosCC]:=_cccSC7
	Endif*/
	
Endif
restarea(_aAreaSC7)
return(_cdivsc7)
