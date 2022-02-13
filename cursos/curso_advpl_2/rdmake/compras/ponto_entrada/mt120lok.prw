#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120LOK  ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inicializador padrao de diversos campos do Pedido de Compraº±±
±±º          ³ para alimentar os campos a partir do 2o item com o valor doº±±
±±º          ³ 1o item.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function MT120LOK()

local _nPosTES  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_TES"   })
local _nPosLoc  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_LOCAL" })
local _nPoscam  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_CAMPANH" })
local _nPosprod := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_PRODUTO" })
local _nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_ITEM" })
local _nPosdivne:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_DIVNEG"})
local _nPosAprov:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_APROV"})
local _nPosCC	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_CC"})
Local _cfabric	:= ""
Local _carmdist := GetMV("MV_ARMCAMP")
Local _lOnOff    := GetMV("MV_ONOFF") // Parametro Para Ligar/Desligar Trecho do Codigo (Deve ser retirado apos validacao)
Local _lreturn  := .t.
Local _cMacro   := ""


u_GerA0003(ProcName())
//local _IniPad  := criavar(_cCampo,.F.)

if Inclui .or. Altera
	
	//Valida existencia do armazem
	dbSelectArea("NNR")
	dbSetOrder(1)
	If !dbSeek(xFilial("NNR")+aCols[n,_nPosLoc],.F.)
		ApMsgStop("Armazem "+aCols[n,_nPosLoc]+" não existente no Cadastro. Entrar em contato com a Controladoria!","Armazém inválido")
		Return(.F.)
	Else
		If NNR->NNR_MSBLQL == "1"
			ApMsgStop("Armazem "+aCols[n,_nPosLoc]+" bloqueado. Entrar em contato com a Controladoria!","Armazém bloqueado")
			Return(.F.)
		Endif
	Endif
	
	
	if !empty(aCols[n,_nPosLoc])
		If aCols[n,_nPosLoc] $ _carmdist .and. (empty(aCols[n,_nPoscam]) .or. aCols[n,_nPoscam] =="00")
			MsgAlert("Favor digitar uma campanha valida para esse armazem","Atencao")
			_lreturn  :=.f.
		endif
	endif
endif

//_lreturn  := IIF( FINDFUNCTION('U_XVALCFOP'),U_XVALCFOP(aCols[n,_nPosTES],aCols[n,_nPosLoc]),.T.)//CLAUDIA, VALIDAR AMARRACAO DE CFOP X ARMAZEM

_cfabric := Posicione("SB1",1,xFilial("SB1") + aCols[n,_nPosProd], "B1_FABRIC")
if !empty(_cfabric)
	DO CASE
		CASE  aCols[n,_nPosLoc] $ "80/81" .and. !substr(alltrim(_cfabric),1,8)="MOTOROLA"
			apMsgStop("Caro usuário, por favor corrigir o Fabricante ou Arm. Padrao do item " + aCols[n,_nPosItem] +" no Cadastro de Produtos ", "Fabricante ou Arm. Padrao Invalido")
			_lreturn := .f.
		CASE  aCols[n,_nPosLoc] $ "87/88" .and. !substr(alltrim(_cfabric),1,4)="SONY"
			apMsgStop("Caro usuário, por favor corrigir o Fabricante ou Arm. Padrao do item " + aCols[n,_nPosItem] +" no Cadastro de Produtos ", "Fabricante ou Arm. Padrao Invalido")
			_lreturn := .f.
	ENDCASE
Else
	If  aCols[n,_nPosLoc] $ "80/81"
		apMsgStop("Caro usuário, por favor Preencher o Fabricante do item " + aCols[n,_nPosItem]+" no Cadastro de Produtos ", "Fabricante não preenchido")
		_lreturn := .f.
	Endif
Endif
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Adequacao na validacao da Divisão de Negocio x Armazem ³
³Uiran Almeida 08.10.2014                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If(_lOnOff) // <- Esse Parâmetro é somente para tempo de Adaptação da Rotina Após validada retirar
	
	DbSelectArea("ZZ0")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZ0")+aCols[n,_nPosdivne],.F.)
		_cMacro := StrTran(ZZ0->ZZ0_REGENT,	"%ARMAZEM%"	,"aCols[n,"+Transform(_nPosLoc,"@E 999")+"] $ ")
		_cMacro := StrTran(_cMacro,			"%PRODUTO%"	,"subSTR(aCols[n,"+Transform(_nPosProd,"@E 999")+"],1,2) $ ")
		If !Empty(_cMacro)
			If !(&(_cMacro))
				Aviso("Divisão de Negócio","Caro usuário, Divisão de negócio não adequada para esse item "+aCols[n,_nPosItem]+", verifique o Armazém e o código do Produto !",{'OK'})
				_lreturn := .F.
			EndIf
		EndIf
	Else
		apMsgStop("Caro usuário, divisão de negócio não cadastrada !" + aCols[n,_nPosdivne], "Div. Negócio Não Encontrada")
		_lreturn := .F.
	EndIf
	
Else
	Do case
		Case (aCols[n,_nPosLoc] $ "80/81" .and. substr(aCols[n,_nPosProd],1,2)=="Z-") .and. aCols[n,_nPosdivne]<>"06"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
		Case (aCols[n,_nPosLoc] $ "83/84" .and. substr(aCols[n,_nPosProd],1,2)=="B-") .and. (aCols[n,_nPosdivne]<>"05" .AND. aCols[n,_nPosdivne]<>"15" .AND. aCols[n,_nPosdivne]<>"13")
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
		Case (aCols[n,_nPosLoc] == "87" .and. substr(aCols[n,_nPosProd],1,2)=="S-") .and. aCols[n,_nPosdivne]<>"07"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
			//Incluso essa condição para atender os aprelhos ainda movimentados no armazém 85 -- Edson Rodrigues 28/09/09
		Case aCols[n,_nPosLoc] == "85"  .and. aCols[n,_nPosdivne]<>"01"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
			
		Case (aCols[n,_nPosLoc] $ "01/1A/1B" .and. !substr(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .and. aCols[n,_nPosdivne]<>"04"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
		Case (aCols[n,_nPosLoc] == "21" .and. !substr(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .and. aCols[n,_nPosdivne]<>"03"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
		Case (aCols[n,_nPosLoc] == "51" .and. !substr(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .and. aCols[n,_nPosdivne]<>"09"
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
		Case (aCols[n,_nPosLoc] $ "70/71/72/73" .and.  aCols[n,_nPosdivne]<>"14")
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
		Case (aCols[n,_nPosLoc] $ "92" .and.  aCols[n,_nPosdivne]<>"15")
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
		Case (aCols[n,_nPosLoc] $ "30/31" .and.  aCols[n,_nPosdivne]<>"16")
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
			
		Case (aCols[n,_nPosLoc] $ "75" .and.  aCols[n,_nPosdivne]<>"17")
			apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
			_lreturn := .f.
	Endcase
EndIf
if Inclui .and. n <> 1 .and. !aCols[n,len(aHeader)+1]
	
	if empty(aCols[n,_nPosTES])
		aCols[n,_nPosTES] := aCols[1,_nPosTES]
		MaAvalTES('E',aCols[n,_nPosTES])
		MaFisRef('IT_TES','MT120',aCols[n,_nPosTES])
	endif
	
	if empty(aCols[n,_nPosLoc])
		aCols[n,_nPosLoc] := aCols[1,_nPosLoc]
	endif
	
	
endif

//Inclusão conforme chamado 4766 do Fernando Peratello - Luciano (Delta Decisao) - 23/03/2012
If (Inclui .or. Altera) .and. !aCols[n,len(aHeader)+1]
	If ALLTRIM(CA120FORN)=="001" .and. aCols[n,_nPosLoc] == "01" .and. empty(aCols[n,_nPosTES])
		aCols[n,_nPosTES] := "201"
		MaAvalTES('E',aCols[n,_nPosTES])
		MaFisRef('IT_TES','MT120',aCols[n,_nPosTES])
	Endif
	
	If AllTrim(aCols[n,_nPosCC]) == '2021'
		aCols[n,_nPosAprov] := '000004'
	Else
		aCols[n,_nPosAprov] := ''
	EndIf
Endif

return(_lreturn)
