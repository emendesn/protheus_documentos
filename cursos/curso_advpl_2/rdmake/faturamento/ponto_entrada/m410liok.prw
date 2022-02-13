#include "rwmake.ch"
#INCLUDE 'TOPCONN.CH' 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOK  ºAutor  ³ Edson Rodrigues    º Data ³27/04/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para Verificacao da Campanha Digitada.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³EspecIfico BGH                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³Revisado - 27/04/08                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410LIOK()

Local _aSvAlias	:= GetArea()
Local _cPosLoc  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_LOCAL"})]
local _cPoscam  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_CAMPANH"})]
local _cPostes  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_TES"})]
local _cPosOS   := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_OSGVS"})]
local _cnfeori  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_NFORI"})]
local _cserori  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_SERIORI"})]
local _citeori  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_ITEMORI"})]
local _ccodpro  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_PRODUTO"})]
local _ctransc  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_XTRANSC"})]
local _ccodiss  := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_CODISS"})] 
local _cIdentB6 := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_IDENTB6"})]

Local nPosDocCli:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XDOCCLI"})
Local nPosSerCli:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XSERCLI"})
Local nPosIteCli := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XITECLI"})

Local nPosNFOri:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_NFORI"})
Local nPosSeOri:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_SERIORI"})
Local nPosLote := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOTECTL"})
Local nPosEnder:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCALIZ"})
Local nPosQLib := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"})

local _ccodcli  := M->C5_CLIENTE
local _ccodloj  := M->C5_LOJACLI
local _cTipoPed := M->C5_TIPO
local _cPro		:= Posicione("SB1", 1, xFilial("SB1") + _ccodpro, "B1_CODISS")
local _nIss		:= Posicione("SF4", 1, xFilial("SF4") + _cPostes, "F4_ISS")
local _cpoder3	:= Posicione("SF4", 1, xFilial("SF4") + _cPostes, "F4_PODER3")
local _cestoq	:= Posicione("SF4", 1, xFilial("SF4") + _cPostes, "F4_ESTOQUE")
Local _carmdist := GetMV("MV_ARMCAMP")
Local _cARMRPG  := GetMV("MV_XARMRPG")
Local _cTARRPG  := GetMV("MV_XARTRPG")
Local _cTESRPG  := GetMV("MV_XTESRPG")
Local _cTRARPG  := GetMV("MV_TRANRPG")
Local _Ret		:= .T.


Private nPosNFOri:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_NFORI"})
Private nPosSeOri:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_SERIORI"})
Private nPosLote := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOTECTL"})
Private nPosEnder:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCALIZ"})
Private nPosQLib := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"})
Private nPosProd := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Private nPosItPv := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
Private nPosQVen := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
Private nPosQLib := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"})
Private nPosPrVen:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
Private nPosTotal:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})


u_GerA0003(ProcName())

If Inclui .or. Altera
	
	//Valida existencia do armazem
	dbSelectArea("NNR")
	dbSetOrder(1)
	If !dbSeek(xFilial("NNR")+_cPosLoc,.F.)
		ApMsgStop("Armazem "+_cPosLoc+" não existente no Cadastro. Entrar em contato com a Controladoria!","Armazém inválido")
		Return(.F.)
	Else
		If NNR->NNR_MSBLQL == "1"
			ApMsgStop("Armazem "+_cPosLoc+" bloqueado. Entrar em contato com a Controladoria!","Armazém bloqueado")
			Return(.F.)
		Endif
	Endif
	
	If !empty(_cPosLoc)
		If _cPosLoc $ _carmdist .and. (empty(_cPoscam) .or. _cPoscam =="00")
			MsgAlert("Favor digitar uma campanha valida para esse armazem","Atencao")
			_Ret  :=.f.
		endif
		
		IF _cPosLoc $ alltrim(_cTARRPG) .and. empty(_ctransc)  .and. _cPostes $ alltrim(_cTESRPG)
			MsgAlert("Favor digitar o Transaction code Motorola","Atencao")
			_Ret  :=.f.
			
		ELSEIF _cPosLoc $ alltrim(_cTARRPG) .and. !ALLTRIM(_ctransc) $ _cTRARPG  .and. _cPostes $ alltrim(_cTESRPG)
			MsgAlert("Transaction Code digitado nao pertence ao processo de RPG","Atencao")
			_Ret  :=.f.
		ENDIF
		
		
		IF _cpoder3 <> "D"  .AND. _cestoq="S" .and. _cPosLoc $ alltrim(_cTARRPG) .and. _cPostes $ alltrim(_cTESRPG)
			IF empty(_cnfeori)
				MsgStop("Favor digitar o NF origem para essa operação. Dados de origem não cadastrado!")
				_Ret  :=.f.
				
			Elseif empty(_citeori)
				MsgStop("Favor digitar o item origem referente NF origem para essa operação . Dados de origem não cadastrado!")
				_Ret  :=.f.
				
			Elseif !empty(_cnfeori) .and. !empty(_citeori)
				_Ret:=vernfori(_cnfeori,_cserori,_citeori,_ccodpro)
				If !_Ret
					MsgStop("Não existe a entrada do documento de origem - NF/Serie/Item : "+_cnfeori+"/"+_cserori+"/"+_citeori+" Digite uma nota, serie ou item de origem válidos. Dados de origem não cadastrado!")
				Endif
				
			Endif
			
		ENDIF
		
		If _nIss $ "S" .And. Empty(_cPro)
			MsgStop("Favor verificar campo Cod.Serv.ISS no cadastro do produto . Favor efetuar cadastro!")
			_Ret  :=.f.
		EndIf
		
		If _ccodiss <> _cPro
			MsgStop("Codigo do ISS divergente. Favor efetuar acerto!")
			_Ret  :=.f.
		EndIf
		
		//Acrescentado esse IF para gravar a OS na linha do pedido e alterar o status da OS Nextel na tabela ZZL na inclusao do pedido - Edson Rodrigues - 07/07/10
		If _cPosLoc $ alltrim(_cARMRPG) .and. _cPostes $ alltrim(_cTESRPG) .and. empty(_cPosOS)
			Dbselectarea("ZZL")
			DbSetOrder(1) //ZZL_FILIAL, ZZL_DOC, ZZL_SERIE,ZZL_FORNEC,ZZL_LOJA,ZZL_ITEMD1,ZZL_FORMUL,ZZL_ITEGRD
			If ZZL->(dbSeek( xFilial("ZZL") + _cnfeori+_cserori+_ccodcli+_ccodloj+_citeori))
				While ZZL->(!Eof()) .AND. xFilial("ZZL") == ZZL->ZZL_FILIAL .AND. ZZL->(ZZL_DOC+ZZL_SERIE+ZZL_FORNEC+ZZL_LOJA+ZZL_ITEMD1)==_cnfeori+_cserori+_ccodcli+_ccodloj+_citeori
					IF ZZL->ZZL_STATUS $ '1/4' .AND. !EMPTY(ZZL->ZZL_OSNEXT)
						aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_OSGVS"})]:=alltrim(ZZL->ZZL_OSNEXT)
						reclock("ZZL",.f.)
						ZZL->ZZL_STATUS := '3'
						msunlock()
						exit
						
					ELSEIF ZZL->ZZL_STATUS= '3' .AND. !EMPTY(ZZL->ZZL_OSNEXT)
						MsgAlert("Foi encontrada  OS Nextel :"+alltrim(ZZL->ZZL_OSNEXT)+" mas ela ja foi usada em outro(s) Pedido(s) com essa NFe/Serie/Item : "+alltrim(_cnfeori)+"/"+_cserori+"/"+_citeori+" . Digite a OS ou regularize o cadastro de OS Nextel (ZZL) na Entrada dessa nota ?","Atencao OS Nextel Já usada")
						//_Ret  :=.T.
					ELSE
						MsgAlert("Pedido efetuados nesse armazem/TES :"+_cPosLoc+"/"+_cPostes+ " referem-se a Operacao RPG. Portanto para gerar o arquivo Mclaims-RPG é necessario ter OS-Nextel. A mesma nao foi encontrada para essa NFe/Serie/Item : "+alltrim(_cnfeori)+"/"+_cserori+"/"+_citeori+" . Digite a OS ou regularize o cadastro de OS Nextel (ZZL) na Entrada dessa nota ?","Atencao OS Nextel Nao Encontrada")
						//_Ret  :=.T.
					ENDIF
					ZZL->(dbSkip())
				Enddo
			Else
				Dbselectarea("ZZL")
				DbSetOrder(2) //ZZL_FILIAL, ZZL_DOC, ZZL_SERIE,ZZL_ITEMD1,ZZL_CODPRO
				If ZZL->(dbSeek( xFilial("ZZL") + _cnfeori+_cserori+_citeori+_ccodpro))
					While ZZL->(!Eof()) .AND. xFilial("ZZL") == ZZL->ZZL_FILIAL .AND. ZZL->(ZZL_DOC+ZZL_SERIE+ZZL_ITEMD1+ZZL_CODPRO)==_cnfeori+_cserori+_citeori+_ccodpro
						IF ZZL->ZZL_STATUS $ '1/4' .AND. !EMPTY(ZZL->ZZL_OSNEXT)
							aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_OSGVS"})]:=alltrim(ZZL->ZZL_OSNEXT)
							reclock("ZZL",.f.)
							ZZL->ZZL_STATUS := '3'
							msunlock()
							exit
						ELSEIF ZZL->ZZL_STATUS= '3' .AND. !EMPTY(ZZL->ZZL_OSNEXT)
							MsgAlert("Foi encontrada  OS Nextel :"+alltrim(ZZL->ZZL_OSNEXT)+" mas ela ja foi usada em outro(s) Pedido(s) com essa NFe/Serie/Item : "+alltrim(_cnfeori)+"/"+_cserori+"/"+_citeori+" . Digite a OS ou regularize o cadastro de OS Nextel (ZZL) na Entrada dessa nota ?","Atencao OS Nextel Já usada")
							//_Ret  :=.T.
						ELSE
							MsgAlert("Pedido efetuados nesse armazem/TES :"+_cPosLoc+"/"+_cPostes+ " referem-se a Operacao RPG. Portanto para gerar o arquivo Mclaims-RPG é necessario ter OS-Nextel. A mesma nao foi encontrada para essa NFe/Serie/Item : "+alltrim(_cnfeori)+"/"+_cserori+"/"+_citeori+" . Digite a OS ou regularize o cadastro de OS Nextel (ZZL) na Entrada dessa nota ?","Atencao OS Nextel Nao Encontrada")
							//_Ret  :=.T.
						ENDIF
						ZZL->(dbSkip())
					Enddo
				Else
					//_Ret  :=.T.
					MsgAlert("Pedido efetuados nesse armazem/TES :"+_cPosLoc+"/"+_cPostes+ " referem-se a Operacao RPG. Portanto para gerar o arquivo Mclaims-RPG é necessario ter OS-Nextel. A mesma nao foi encontrada para essa NFe/Serie/Item : "+alltrim(_cnfeori)+"/"+_cserori+"/"+_citeori+" . Digite a OS ou regularize o cadastro de OS Nextel (ZZL) na Entrada dessa nota ?","Atencao OS Nextel Nao Encontrada")
				Endif
			Endif
		Endif
	Endif
	
	If !EMPTY(_cIdentB6)
		dbSelectArea("SB6")
		dbSetOrder(3)
		If dbSeek(xFilial("SB6")+_cIdentB6+_ccodpro+"R")
			aCols[n][nPosDocCli] := SB6->B6_XDOCCLI
			aCols[n][nPosSerCli] := SB6->B6_XSERCLI
		Endif
	Endif
	
	If _Ret .and. !aCols[n,len(aHeader)+1]
		If _cTipoPed=="B" .and. _cPosLoc=="H1" .and. _cpoder3=="R" .and. _cestoq=="S"
			_lAchNf := .F.
			_nSaldo := _nQtdVen
			If Empty(_cnfeori)
				_aDados := BusNFOri(_ccodpro,_cPosLoc)
				If len(_aDados) > 0
					For i:= 1 to Len(_aDados)
						If !_lAchNf
							If _aDados[i,5] >= _nSaldo
								aCols[n][nPosNfOri] := _aDados[i,1]
								aCols[n][nPosSeOri] := _aDados[i,2]
								aCols[n][nPosLote]  := _aDados[i,3]
								aCols[n][nPosEnder] := _aDados[i,4]
								aCols[n][nPosQLib]  := _nSaldo
								aCols[n][nPosPrVen] := _aDados[i,6]
								aCols[n][nPosTotal] := aCols[n][nPosQVen]*aCols[n][nPosPrVen]
								_lAchNf := .T.
							Endif
						Else
							Exit
						Endif
					Next i
				Endif
				If !_lAchNf .and. len(_aDados)==0
					_Ret  :=.F.
					MsgAlert("Não existe saldo para o produto informado. Favor verificar!")
				ElseIf !_lAchNf .and. len(_aDados) > 0
					_Ret  :=.F.
					AutoGRLog("Saldo do Produto "+Alltrim(_ccodpro))
					For i:= 1 to Len(_aDados)
						AutoGRLog("Lote|Endereço -> "+Alltrim(_aDados[i,3])+"|"+Alltrim(_aDados[i,4])+" - "+Alltrim(STR(Round(_aDados[i,5] ,2))))
					Next i
					MostraErro()
				Endif
			ElseIf aCols[n][nPosQLib] == 0
				aCols[n][nPosQLib]  := _nSaldo
			Endif
		Endif
	Endif
	
Endif
RestArea(_aSvAlias)
Return(_Ret)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Vernfori ºAutor  ³Edson Rodrigues    º Data ³  05/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar a existência da Nf de origem         º±±
±±º          ³ digitada pelo usuário.                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Vernfori(_cnfeori,_cserori,_citeori,_ccodpro)

local _cQry
Local lret:=.f.
Local CR  :=""

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf


_cQry   := CR + " SELECT D1_FILIAL+D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_COD+D1_ITEM  AS CHAVED1"
_cQry   += CR + "                  FROM  "+RetSqlName("SD1")+"  D1 (NOLOCK)  "
_cQry   += CR + "                  WHERE  D1_FILIAL='"+xFilial("SD1")+"' AND "
_cQry   += CR + " D1_DOC='"+_cnfeori+"' AND D1_SERIE='"+_cserori+"' AND D1_ITEM='"+_citeori+"' AND D1_COD='"+_ccodpro+"' "

TCQUERY _cQry ALIAS "QRY" NEW
TCRefresh(RetSqlName("SD1"))

If Select("QRY") > 0
	QRY->(dbGoTop())
	IF QRY->(!eof()) .and. !empty(QRY->CHAVED1)
		lret:=.T.
	Endif
	QRY->(dbCloseArea())
Endif

Return(lret)


Static Function BusNFOri(_ccodpro,_cPosLoc,_cItemPv)

Local _aRet := {}

_cQuery := " SELECT "
_cQuery += "	B6_DOC,B6_SERIE,B6_PRUNIT,B8_PRODUTO,B8_LOCAL,B8_LOTECTL,BF_LOCALIZ, SUM(BF_QUANT-BF_EMPENHO) AS SALDOBF "
_cQuery += " FROM "+RetSqlName("SB8")+"  SB8 (NOLOCK)  "
_cQuery += " INNER JOIN "+RetSqlName("SBF")+" SBF (NOLOCK) ON "
_cQuery += "	BF_FILIAL='"+xFilial("SBF")+"' AND "
_cQuery += "	BF_PRODUTO=B8_PRODUTO AND "
_cQuery += "	BF_LOCAL=B8_LOCAL AND "
_cQuery += "	BF_LOTECTL=B8_LOTECTL AND "
_cQuery += "	SBF.D_E_L_E_T_ = '' "
_cQuery += " INNER JOIN "+RetSqlName("SB6")+"  SB6 (NOLOCK) ON "
_cQuery += "	B6_FILIAL='"+xFilial("SB6")+"' AND "
_cQuery += " 	B6_PRODUTO=B8_PRODUTO AND "
_cQuery += "	B6_LOCAL=B8_LOCAL AND "
_cQuery += "	B6_DOC=B8_DOC AND "
_cQuery += "	B6_LOJA=B8_LOJA AND "
_cQuery += "	B6_CLIFOR=B8_CLIFOR AND "
_cQuery += "	B6_LOJA=B8_LOJA AND "
_cQuery += "	SB6.D_E_L_E_T_='' "
_cQuery += " WHERE "
_cQuery += "	B8_FILIAL='"+xFilial("SB8")+"' AND "
_cQuery += "	B8_PRODUTO='"+_ccodpro+"' AND "
_cQuery += "	B8_LOCAL='"+_cPosLoc+"' AND "
_cQuery += "	B8_SALDO > 0  AND "
_cQuery += "	SB8.D_E_L_E_T_='' AND "
_cQuery += "	RIGHT(RTRIM(BF_LOCALIZ),1) <> 'B' AND "//Endereço de peças com problema
_cQuery += "	BF_QUANT-B8_EMPENHO > 0 AND "
_cQuery += "	B6_SALDO > 0 "
_cQuery += " GROUP BY B6_DOC,B6_SERIE,B8_PRODUTO,B8_LOCAL,B8_LOTECTL,BF_LOCALIZ,B6_PRUNIT "
_cQuery += " ORDER BY B6_DOC,B6_SERIE,B8_PRODUTO,B8_LOCAL,B8_LOTECTL,BF_LOCALIZ "

If Select("TSQL")>0
	dbSelectArea("TSQL")
	dbCloseArea()
EndIf

TcQuery _cQuery New Alias "TSQL"

TcSetField("TSQL","SALDOBF","N",14,2)

dbSelectArea("TSQL")
TSQL->(dbGotop())

While TSQL->(!Eof())
	nSaldoBF := TSQL->SALDOBF
	For nx:=1 to Len(aCols)
		If aCols[nx][nPosProd] == aCols[n][nPosProd] .and. aCols[nx][nPosItPv] <> aCols[n][nPosItPv]
			If aCols[nx][nPosNfOri] == TSQL->B6_DOC .and. ;
				aCols[nx][nPosSeOri] == TSQL->B6_SERIE .and.;
				aCols[nx][nPosLote]  == TSQL->B8_LOTECTL .and.;
				aCols[nx][nPosEnder] == TSQL->BF_LOCALIZ
				nSaldoBF := nSaldoBF-aCols[nx][nPosQVen]
			Endif
		Endif
	Next nx
	If nSaldoBF > 0
		Aadd( _aRet, {TSQL->B6_DOC,TSQL->B6_SERIE,TSQL->B8_LOTECTL,TSQL->BF_LOCALIZ,nSaldoBF,TSQL->B6_PRUNIT} )
	Endif
	TSQL->(dbSkip())
EndDo

Return(_aRet)