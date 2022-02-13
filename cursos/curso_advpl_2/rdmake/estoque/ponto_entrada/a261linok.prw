#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A261LINOK ºAutor  ³Microsiga           º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ma261Lin()
Local aArea 			:= GetArea()
Local lRet 				:= .T.
Local nAt  				:= ParamIxb[1]                      
Local lRastro 			:= .F.
Local lRastro2 			:= .F.
Local _nPosCODOri		:= 1 								//Codigo do Produto Origem
local _nPosDOri			:= 2								//Descricao do Produto Origem
local _nPosUMOri		:= 3								//Unidade de Medida Origem
local _nPosLOCOri		:= 4								//Armazem Origem
local _nPosLcZOri		:= 5								//Localizacao Origem
local _nPosCODDes		:= Iif(!__lPyme,6,5)					//Codigo do Produto Destino
local _nPosDDes			:= Iif(!__lPyme,7,6)		   			//Descricao do Produto Destino
local _nPosUMDes		:= Iif(!__lPyme,8,7)					//Unidade de Medida Destino
local _nPosLOCDes		:= Iif(!__lPyme,9,8)					//Armazem Destino
local _nPosLcZDes		:= 10								//Localizacao Destino
Local _nPosSeri     	:= 11                   			// Serie do Produto
local _nPosLoTCTL		:= 12								//Lote de Controle
local _nPosNLOTE		:= 13								//Numero do Lote
local _nPosDTVAL		:= 14								//Data Valida
local _nPosPotenc		:= 15								//Data Valida
local _nPosQUANT		:= Iif(!__lPyme,16,9)		 			//Quantidade
local _nPosQTSEG		:= Iif(!__lPyme,17,10)		  		//Quantidade na 2a. Unidade de Medida
Local cCod     			:= aCols[naT,_nPosCODOri]
Local cLocal   			:= aCols[naT,_nPosLocOri]
Local cLoteCtl 			:= aCols[nAt,_nPosLoTCTL]
Local cnumLote 			:= aCols[nAt,_nPosNLOTE]  
Local cNumSeri 			:= aCols[nAt,_nPosSeri]  
Local cLocaliz 			:= aCols[nAT,_nPosLCZOri]
Local nQuant   			:= aCols[nAT,_nPosQuant]
Local nQuantSEG 		:= aCols[nAT,_nPosQTSEG] 
Local cCodDes   		:= aCols[naT,_nPosCODDes]
Local cLocalDes   		:= aCols[naT,_nPosLocDes]
Local cLczDES	    	:= aCols[naT,_nPosLcZdes]
Local nSaldoB2 			:= 0
Local nSaldo   			:= 0
Local nDSaldoB2 		:= 0
Local nDSaldo   		:= 0
Local aTravas			:={}
Local lRecuper			:= .F.

u_GerA0003(ProcName())

SBF->(DbSetOrder(2))
SB8->(DbSetOrder(1))

//Valida existencia do armazem origem na transferencia
dbSelectArea("NNR")
dbSetOrder(1)
If !dbSeek(xFilial("NNR")+cLocal,.F.)
	ApMsgStop("Armazem "+Alltrim(cLocal)+" não existente no Cadastro. Entrar em contato com a Controladoria!","Armazém inválido")
	Return(.F.)
Else 
	If NNR->NNR_MSBLQL == "1"
		ApMsgStop("Armazem "+Alltrim(cLocal)+" bloqueado. Entrar em contato com a Controladoria!","Armazém bloqueado")
		Return(.F.)
	Endif
Endif

//Valida existencia do armazem destino na transferencia
dbSelectArea("NNR")
dbSetOrder(1)
If !dbSeek(xFilial("NNR")+cLocalDes,.F.)
	ApMsgStop("Armazem "+Alltrim(cLocalDes)+" não existente no Cadastro. Entrar em contato com a Controladoria!","Armazém inválido")
	Return(.F.)
Else 
	If NNR->NNR_MSBLQL == "1"
		ApMsgStop("Armazem "+Alltrim(cLocalDes)+" bloqueado. Entrar em contato com a Controladoria!","Armazém bloqueado")
		Return(.F.)
	Endif
Endif

/* valida saldo do produto origem */
/*If Rastro(cCOD)  .Or. (Localiza(cCOD) .And. !Empty(cLOCALIZ))
		lRastro := .T.
		nSaldo:=0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa saldo a distribuir pendente                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Localiza(cCod)
			aAreaSDA:=SDA->(GetArea())
			SDA->(dbSetOrder(1))
			If SDA->(dbSeek(xFilial("SDA")+cCOD+cLocal))
				nSaldo+=SDA->DA_SALDO
			EndIf
			Restarea(aAreaSDA)
		EndIf
		If Rastro(cCOD) 
			SB8->(dbSetOrder(1))
			If SB8->(dbSeek(xFilial('SB8')+cCod+cLocal, .F.))
				Do While ! SB8->(EOF()) .AND. SB8->B8_FILIAL = XFILIAL("SB8") .AND. SB8->B8_PRODUTO = cCod .AND. SB8->B8_LOCAL = cLocal
					nSaldo +=  QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,lEmpPrev,Nil,ddatabase)) 
					SB8->(DbSkip())
				EndDo	
	        Endif
		Else       
			SBF->(DbSetOrder(2))
			SBF->(DbSeek(XFilial("SBF") + cCod + ClOCAL))
			Do While ! SBF->(EOF()) .AND. SBF->BF_FILIAL = XFILIAL("SBF") .AND. SBF->BF_PRODUTO = cCod  .AND. SBF->BF_LOCAL = cLocal
				nSaldo+=QtdComp(SaldoSBF(cLocal,SBF->BF_LOCALIZ,cCod,SBF->BF_NUMSERI,SBF->BF_LOTECTL,If(Rastro(cCod, 'S'),SBF->BF_NUMLOTE,''))) 
				SBF->(DbSkip())
			EndDo				
		EndIf
Endif   */
/* valida saldo do produto destino */              
/*If Rastro(cCODDes)  .Or. (Localiza(cCODDes) .And. !Empty(cLczDES))
		lRastro2 := .T.
		nDSaldo:=0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa saldo a distribuir pendente                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Localiza(cCodDes)
			aAreaSDA:=SDA->(GetArea())
			SDA->(dbSetOrder(1))
			If SDA->(dbSeek(xFilial("SDA")+cCODDes+cLocalDes))
				nDSaldo+=SDA->DA_SALDO
			EndIf
			Restarea(aAreaSDA)
		EndIf
		If Rastro(cCODDes) 
			SB8->(dbSetOrder(1))
			If SB8->(dbSeek(xFilial('SB8')+cCodDes+cLocalDes, .F.))
				Do While ! SB8->(EOF()) .AND. SB8->B8_FILIAL = XFILIAL("SB8") .AND. SB8->B8_PRODUTO = cCodDes .AND. SB8->B8_LOCAL = cLocalDes
					nDSaldo +=  QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,lEmpPrev,Nil,ddatabase)) 
					SB8->(DbSkip())
				EndDo	
	        Endif
		Else       
			SBF->(DbSetOrder(2))
			SBF->(DbSeek(XFilial("SBF") + cCodDes + ClOCALDes))
			Do While ! SBF->(EOF()) .AND. SBF->BF_FILIAL = XFILIAL("SBF") .AND. SBF->BF_PRODUTO = cCodDes  .AND. SBF->BF_LOCAL = cLocalDes
				nDSaldo+=QtdComp(SaldoSBF(cLocalDes,SBF->BF_LOCALIZ,cCodDes,SBF->BF_NUMSERI,SBF->BF_LOTECTL,If(Rastro(cCodDes, 'S'),SBF->BF_NUMLOTE,''))) 
				SBF->(DbSkip())
			EndDo				
		EndIf
		
Endif*/
/* 
If DA261DATA <> dDataBase
	ApMsgStop("Rotina de transferência com datas diferentes desabilitada pelo administrador. Entre em contato com TI")
	lRet := .F. 
EndIf
*/
/* VERIFICA O SALDO ATUAL DO PRODUTO */
dbSelectArea("SB2")
dbSetOrder(1)
If MsSeek(xFilial("SB2")+cCod+cLocal)
	nSaldoB2 := SB2->B2_QATU - SB2->B2_QACLASS // QUANTIDADE ATUAL - QUANTIDADE A ENDERECAR
Else 
	nSaldoB2 := 0
Endif	

If MsSeek(xFilial("SB2")+cCodDes+cLocalDes)
	nDSaldoB2 := SB2->B2_QATU - SB2->B2_QACLASS // QUANTIDADE ATUAL - QUANTIDADE A ENDERECAR
Else 
	nDSaldoB2 := 0
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se transferencia entre produtos é para peças recuperadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Alltrim(cCod) == SubSTR(Alltrim(cCodDes),1,Len(Alltrim(cCod))) .AND. right(Alltrim(cCodDes),2) == "-R"
	lRecuper := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se Produto de Origem eh igual ao Produto de Destino  - Paulo Lopez - 06/04/10     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
If cCod <> cCodDes .AND. !lRecuper                                 
	ApMsgStop("Rotina de transferência entre produtos diferentes desabilitada pelo administrador. Entre em contato com TI")
	lRet := .F. 
EndIf

/* informa ao usuario no caso de inconsistencias */
If lRastro  // validar o saldo atual com o saldo do endereço/lote
	If nSaldo <> nSaldoB2
		Aviso("Transferencia","Saldo Produto Origem divergente entre SB2: " + alltrim(transform(NSALDOB2,"@e 999,999,999,999.9999")) + " e SBF: " +  alltrim(transform(NSALDO,"@e 999,999,999,999.9999")),{"OK"})
		lRet := .F.
	Endif
EndIf


If lRastro2  // validar o saldo atual com o saldo do endereço/lote
	If nDSaldo <> nDSaldoB2
		Aviso("Transferencia","Saldo Produto Destino divergente entre SB2: " + alltrim(transform(NDSALDOB2,"@e 999,999,999,999.9999")) + " e SBF: " +  alltrim(transform(NDSALDO,"@e 999,999,999,999.9999")),{"OK"})
		lRet := .F.
	Endif
EndIf
RestArea(aArea)

Return lRet
