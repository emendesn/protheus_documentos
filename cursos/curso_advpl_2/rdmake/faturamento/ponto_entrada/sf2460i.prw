#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF2460I  ºAutor  ³Microsiga           º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada apos inclusao da Nota Fiscal de Saida     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function SF2460I()
local  aArea	:= SF2->(GetArea())
local _aAreaSF2 := SF2->(GetArea())
local _aAreaSD2 := SD2->(GetArea())
local _aAreaSC5 := SC5->(GetArea())
local _aAreaSE1 := SE1->(GetArea())
local _aAreaZZ4 := ZZ4->(GetArea())
local _aAreaZZQ := ZZQ->(GetArea())
local _aAreaSZN := SZN->(GetArea())
local _aAreaZZO := ZZO->(GetArea())
Local _aregzzq  :={}
local _cCCusto  := ""
local _cCcSe1   := ""
local _cNaturez := ""
local _ccfop    := ""
Local nLognf    := 0
Local aPedPeca	:= {}                     
Local _cmudfdes   := ALLTRIM(GETMV("MV_MUDFDES"))
Local _cmudfori   := ALLTRIM(GETMV("MV_MUDFORI"))
Local _copmubgh   := ALLTRIM(GETMV("MV_OPMUBGH"))
Local _cfornbgh   := ALLTRIM(GETMV("MV_FORBGHM"))
Local _ctesultf   := ALLTRIM(GETMV("MV_TESULTF"))
Local _ctesretc   := ALLTRIM(GETMV("MV_TESRETC"))

u_GerA0003(ProcName())

SD2->(dbSetOrder(3))  // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
SC5->(dbSetOrder(1))  // C5_FILIAL + C5_NUM
SE1->(dbSetOrder(1))  // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
ZZ4->(dbSetOrder(3))  // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
SC6->(dbSetOrder(1))  // C6_FILIAL + C6_NUM + C6_ITEM
ZZQ->(dbSetOrder(2))  // ZZQ_FILIAL + ZZQ_PV + ZZQ_ITEMPV + ZZQ_MODELO + ZZQ_NFS + ZZQ_NFSSER
SZN->(dbSetOrder(3))  // ZN_FILIAL + ZN_PEDVEN
ZZO->(dbSetOrder(4))  // ZZO_FILIAL + ZZO_NUMCX +ZZO_IMEI+ ZZO_STATUS

/*CLAUDIA 28/01/2009 - VERIFICA SE A NF FOI EXCLUIDA ANTERIORMENTE E ESTA SENDO INCLUIDA NOVAMENTE */
DbSelectArea("ZZD")
DbSetOrder(1)
If  ZZD->(dbSeek(xFilial("ZZD") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
	nLogNF := 0
	Do While ! ZZD->(Eof()) .and.   ZZD->ZZD_FILIAL = XFILIAL("ZZD")    .and. ;
		ZZD->ZZD_DOC    = SF2->F2_DOC       .and. ;
		ZZD->ZZD_SERIE  = SF2->F2_SERIE     .and. ;
		ZZD->ZZD_CLIENT = SF2->F2_CLIENTE	.and. ;
		ZZD->ZZD_LOJA   = SF2->F2_LOJA
		nLogNf := ZZD->ZZD_SEQ
		ZZD->(DbSkip())
	EndDo
	If nLogNf <> 0
		nLogNF ++
		RecLock("ZZD",.T.)
		ZZD->ZZD_FILIAL := XFILIAL("ZZD")
		ZZD->ZZD_DOC    := SF2->F2_DOC
		ZZD->ZZD_SERIE  := SF2->F2_SERIE
		ZZD->ZZD_CLIENT := SF2->F2_CLIENTE
		ZZD->ZZD_LOJA   := SF2->F2_LOJA
		ZZD->ZZD_EMIS   := SF2->F2_EMISSAO
		ZZD->ZZD_DATA   := dDataBase
		//ZZD->ZZD_USUARI := Substr(cUsuario,7,15)
		ZZD->ZZD_USUARI := cUsername	  // Alterado para nova versao P10
		ZZD->ZZD_PEDIDO := SD2->D2_PEDIDO
		ZZD->ZZD_MOTIVO := "**"
		ZZD->ZZD_SEQ    := Iif(nLogNF=0,1,nLogNf)
		ZZD->(MSUnlock())
	EndIf
EndIF
RestArea(aArea)
/*---------------------------------------------------*/

// Atualiza centro de custo no Item da Nota Fiscal de Saida
if SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
	
	while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == SF2->F2_DOC .and. ;
		SD2->D2_SERIE == SF2->F2_SERIE .and. SD2->D2_CLIENTE == SF2->F2_CLIENTE .and. SD2->D2_LOJA == SF2->F2_LOJA
		
		if SC5->(dbSeek(xFilial("SC5") + SD2->D2_PEDIDO )) .and. !EMPTY(SC5->C5_DIVNEG)
			_ccfop = SD2->D2_CF
			
			dbSelectArea("ZZ0")
			dbSetOrder(1)
			
			if dbSeek(xFilial("ZZ0")+SC5->C5_DIVNEG)
				if len(alltrim(ZZ0->ZZ0_REGRCC)) == 0
					_cCusto := ZZ0->ZZ0_CCUSTO
				else
					_formula := ZZ0->ZZ0_REGRCC
					_cCusto := &_formula
				endif
				
				if len(alltrim(ZZ0->ZZ0_REGNAF)) == 0
					_cNaturez := ZZ0->ZZ0_NATFAT
				else
					_formula := ZZ0->ZZ0_REGNAF
					_cNaturez := &_formula
				endif
			else
				_cCusto := ''
				_cNaturez := ''
			endif
			
			reclock("SD2",.f.)
			SD2->D2_CCUSTO := _cCusto
			msunlock()
			_cCcSe1 := iif(empty(_cCcSe1),_cCusto,_cCcSe1)
			
		endif
		
		
		// Grava status da saida massiva
		// Verifica Com todos os parametros
		If ZZ4->(dbSeek(xFilial("ZZ4") + SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_NUMSERI))
            If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(SD2->D2_PEDIDO)
				reclock("ZZ4",.f.)
				ZZ4->ZZ4_STATUS := "9"
				ZZ4->ZZ4_NFSNR  := SD2->D2_DOC
				ZZ4->ZZ4_NFSSER := SD2->D2_SERIE
				ZZ4->ZZ4_NFSDT  := dDataBase
				ZZ4->ZZ4_NFSHR  := time()
				ZZ4->ZZ4_DOCDTS := SF2->F2_SAIROMA
				ZZ4->ZZ4_DOCHRS := SF2->F2_HSAIROM
				ZZ4->ZZ4_NFSTES := SD2->D2_TES
				ZZ4->ZZ4_NFSCLI := SD2->D2_CLIENTE
				ZZ4->ZZ4_NFSLOJ := SD2->D2_LOJA
				msunlock()
				
				//Atualizar campo MenNota dos pedidos de peças e serviço com a NF de retorno dos radios 
				If !Empty(ZZ4->ZZ4_PVPECA) .and. Alltrim(ZZ4->ZZ4_OPEBGH) $ "N01/N10/N11"
					aadd(aPedPeca,{SD2->D2_DOC,LEFT(ZZ4->ZZ4_PVPECA,6),LEFT(ZZ4->ZZ4_PVSERV,6)})
				Endif
			Endif
		Else
			
			// Incluso para quando somente o Cliente e loja  sejam diferentes da entrada massiva. Edson Rodrigues
			ZZ4->(dbSetOrder(5))  // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_IMEI
			If ZZ4->(dbSeek(xFilial("ZZ4") + SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_NUMSERI))
				If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(SD2->D2_PEDIDO)
					reclock("ZZ4",.f.)
					ZZ4->ZZ4_STATUS := "9"
					ZZ4->ZZ4_NFSNR  := SD2->D2_DOC
					ZZ4->ZZ4_NFSSER := SD2->D2_SERIE
					ZZ4->ZZ4_NFSDT  := dDataBase
					ZZ4->ZZ4_NFSHR  := time()
					ZZ4->ZZ4_DOCDTS := SF2->F2_SAIROMA
					ZZ4->ZZ4_DOCHRS := SF2->F2_HSAIROM
					ZZ4->ZZ4_NFSTES := SD2->D2_TES
					ZZ4->ZZ4_NFSCLI := SD2->D2_CLIENTE
					ZZ4->ZZ4_NFSLOJ := SD2->D2_LOJA
					msunlock()
					//Atualizar campo MenNota dos pedidos de peças e serviço com a NF de retorno dos radios 
					If !Empty(ZZ4->ZZ4_PVPECA) .and. Alltrim(ZZ4->ZZ4_OPEBGH) $ "N01/N10/N11"
						aadd(aPedPeca,{SD2->D2_DOC,LEFT(ZZ4->ZZ4_PVPECA,6),LEFT(ZZ4->ZZ4_PVSERV,6)})
					Endif
				Endif
			Else
				// Incluso para quando e Cliente e loja, Nf/item e serie origem  sejam diferentes da entrada massiva, tipo a operacao Sony Refurbish
				ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
				If ZZ4->(dbSeek(xFilial("ZZ4") + SD2->D2_NUMSERI))
					
					While !ZZ4->(eof()) .AND.  ZZ4->ZZ4_FILIAL=xFilial("ZZ4") .AND.  ZZ4->ZZ4_IMEI=SD2->D2_NUMSERI
						IF alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(SD2->D2_PEDIDO) .AND. alltrim(SUBSTR(ZZ4->ZZ4_PV,7))==alltrim(SD2->D2_ITEMPV)
							 
   						  If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(SD2->D2_PEDIDO)
	   						  // Altera o Status da Entrada Massiva
								reclock("ZZ4",.f.)
								ZZ4->ZZ4_STATUS := "9"
								ZZ4->ZZ4_NFSNR  := SD2->D2_DOC
								ZZ4->ZZ4_NFSSER := SD2->D2_SERIE
								ZZ4->ZZ4_NFSDT  := dDataBase
								ZZ4->ZZ4_NFSHR  := time()
								ZZ4->ZZ4_DOCDTS := SF2->F2_SAIROMA
								ZZ4->ZZ4_DOCHRS := SF2->F2_HSAIROM
								ZZ4->ZZ4_NFSTES := SD2->D2_TES
								ZZ4->ZZ4_NFSCLI := SD2->D2_CLIENTE
								ZZ4->ZZ4_NFSLOJ := SD2->D2_LOJA
								msunlock()
								
								//Atualizar campo MenNota dos pedidos de peças e serviço com a NF de retorno dos radios 
								If !Empty(ZZ4->ZZ4_PVPECA) .and. Alltrim(ZZ4->ZZ4_OPEBGH) $ "N01/N10/N11"
									aadd(aPedPeca,{SD2->D2_DOC,LEFT(ZZ4->ZZ4_PVPECA,6),LEFT(ZZ4->ZZ4_PVSERV,6)})
								Endif
														
							 // ATUALIZA DADOS NA ZZO PARA O PROCESSO DE MUDANÇA A BGH 
             				 IF ZZO->(dbSeek(ALLTRIM(_cmudfori) + STRZERO(ZZ4->ZZ4_ETQMAS,20) + SD2->D2_NUMSERI + "P")) .OR. ZZO->(dbSeek(ALLTRIM(_cmudfori) + STRZERO(ZZ4->ZZ4_ETQMAS,20) + SD2->D2_NUMSERI + "E"))						
             				
             				    reclock("ZZ4",.f.)
                                    ZZ4->ZZ4_CHVFIL := ALLTRIM(ZZ4->ZZ4_OS)+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_ITEMD1
   							    msunlock()

                                
                                
                                cupdQry:=" UPDATE "+RETSQLNAME("ZZO")+ " SET
                                IF SD2->D2_TIPO="B"
                                    cupdQry+=" ZZO_CLIENT = '"+_cfornbgh+"' , "
                                    cupdQry+=" ZZO_LOJA = '01' , "
                                ELSE
                                    cupdQry+=" ZZO_CLIENT = '"+SD2->D2_CLIENTE+"' , "
                                    cupdQry+=" ZZO_LOJA = '"+SD2->D2_LOJA+"' , "
                                ENDIF
                                 cupdQry+=" ZZO_NF = '"+SD2->D2_DOC+"' , "
                                 cupdQry+=" ZZO_SERIE = '"+SD2->D2_SERIE+"' "
   							     cupdQry+=" WHERE ZZO_FILIAL='"+ALLTRIM(_cmudfori)+"' AND ZZO_NUMCX='"+STRZERO(ZZ4->ZZ4_ETQMAS,20)+"'  AND ZZO_IMEI='"+SD2->D2_NUMSERI+"' AND  (ZZO_STATUS='P' OR  ZZO_STATUS='E')  AND D_E_L_E_T_='' "
			                     TCSQLEXEC (cupdQry)
			                     TCRefresh(RETSQLNAME("ZZO"))
	                        
	                         ENDIF
	                        
	                      Endif
							
						ENDIF
						ZZ4->(dbSKIP())
					ENDDO
				Endif
			Endif
		Endif		
		
		If Select("SC6") == 0
			DbSelectArea("SC6")
		EndIf
		SC6->(DbSetOrder(1))	 
		SC6->(DbGoTop())			                                                        
		if SC6->(dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV)) 
			If !empty(SC6->C6_IMEINOV) .and. empty(SC6->C6_NUMSERI) 
				_cUpdate := " UPDATE "+retsqlname("ZZ4")
				_cUpdate += " SET ZZ4_SWNFDT = '"+dtos(SD2->D2_EMISSAO)+"', "
				_cUpdate += "     ZZ4_SWNFNR = '"+SD2->D2_DOC+"', "
				_cUpdate += "     ZZ4_SWNFSE = '"+SD2->D2_SERIE+"', "
				_cUpdate += "     ZZ4_SWSADC = '"+dtos(SF2->F2_SAIROMA)+"' "
				_cUpdate += " WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND " 
				_cUpdate += "       ZZ4_IMEI   = '"+SC6->C6_XIMEOLD+"' AND "
				_cUpdate += "       ZZ4_SWAP   = '"+SC6->C6_IMEINOV+"' AND "
				_cUpdate += "       ZZ4_SWNFNR = '' AND "
				_cUpdate += "       D_E_L_E_T_ = '' "
				tcSqlExec(_cUpdate)
				TCRefresh(RetSqlName("ZZ4"))
			EndIf
		endif		
		
		ZZ4->(dbSetOrder(10))  // ZZ4_FILIAL + ZZ4_PVSERV + ZZ4_DTPVSE
		cpeditem:=ALLTRIM(SD2->D2_PEDIDO)+ALLTRIM(SD2->D2_ITEMPV)
		cpedido :=SD2->D2_PEDIDO
		citem   :=SD2->D2_ITEMPV
		
		IF ZZ4->(dbSeek(xFilial("ZZ4") + cpeditem)) .or. ZZ4->(dbSeek(xFilial("ZZ4") + cpedido))
			cupdQry:=" UPDATE "+RETSQLNAME("ZZ4")+ " SET ZZ4_NFSERV='"+SD2->D2_DOC+"', ZZ4_NFSSSV='"+SD2->D2_SERIE+"', ZZ4_DTNFSE='"+dtos(SD2->D2_EMISSAO)+"',ZZ4_HRNFSE='"+time()+"' "
			cupdQry+=" WHERE ZZ4_FILIAL='"+ xFilial("ZZ4")+"' AND LEFT(ZZ4_PVSERV,6)='"+ALLTRIM(cpedido)+"' AND D_E_L_E_T_=''"
			TCSQLEXEC (cupdQry)
			TCRefresh(RETSQLNAME("ZZ4"))
			
			cupdQry:=" UPDATE "+RETSQLNAME("SZN")+ " SET ZN_NFRPS='"+RIGHT(ALLTRIM(SD2->D2_DOC),6)+"',ZN_SERRPS='"+SD2->D2_SERIE+"'
			cupdQry+=" WHERE ZN_FILIAL='"+ xFilial("SZN")+"' AND ZN_PEDVEND='"+ALLTRIM(cpedido)+"' AND D_E_L_E_T_=''"
			TCSQLEXEC (cupdQry)
			TCRefresh(RETSQLNAME("SZN"))
			
		Else
			IF SZN->(dbSeek(xFilial("SZN") + cpedido))
				cupdQry:=" UPDATE "+RETSQLNAME("SZN")+ " SET ZN_NFRPS='"+RIGHT(ALLTRIM(SD2->D2_DOC),6)+"',ZN_SERRPS='"+SD2->D2_SERIE+"'
				cupdQry+=" WHERE ZN_FILIAL='"+ xFilial("SZN")+"' AND ZN_PEDVEND='"+ALLTRIM(cpedido)+"' AND D_E_L_E_T_=''"
				TCSQLEXEC (cupdQry)
				TCRefresh(RETSQLNAME("SZN"))
			ENDIF
		Endif
		
		
		ZZ4->(dbSetOrder(9))  // ZZ4_FILIAL + ZZ4_PVPECA + ZZ4_IMEI + ZZ4_OS
		ZZQ->(dbgotop())
		
		
		IF ZZQ->(dbSeek(xFilial("ZZQ") + cpedido + citem))
			
			cupdQry:=" UPDATE "+RETSQLNAME("ZZQ")+ " SET  ZZQ_NFS='"+SD2->D2_DOC+"',ZZQ_NFSSER='"+SD2->D2_SERIE+"'
			cupdQry+=" WHERE ZZQ_FILIAL='"+ xFilial("ZZQ")+"' AND ZZQ_PV='"+ALLTRIM(cpedido)+"' AND ZZQ_ITEMPV='"+ALLTRIM(citem)+"' AND D_E_L_E_T_=''"
			TCSQLEXEC (cupdQry)
			TCRefresh(RETSQLNAME("ZZQ"))
			
			aadd(_aregzzq,{cpedido,citem,SD2->D2_DOC,SD2->D2_SERIE,dtos(SD2->D2_EMISSAO),time()})
			
			//While !ZZQ->(eof())  .and.  ZZQ->ZZQ_FILIAL==xFilial("ZZQ") .AND. ZZQ->ZZQ_PV==cpedido
			//   If ZZQ->ZZQ_ITEMPV==citem
			//      IF (ZZ4->(dbSeek(xFilial("ZZ4") + ZZQ->ZZQ_PV + ZZQ->ZZQ_IMEI + ZZQ->ZZQ_NUMOS ))) .OR. ZZ4->(dbSeek(xFilial("ZZ4") + ZZQ->ZZQ_PV + ZZQ->ZZQ_IMEI))
			//    	  	Begin Transaction
			//    	    reclock("ZZ4",.f.)
			//	          ZZ4->ZZ4_NFSPEC := SD2->D2_DOC
			//	          ZZ4->ZZ4_NFSSEP := SD2->D2_SERIE
			// 	          ZZ4->ZZ4_DTNPEC := dDataBase
			//	          ZZ4->ZZ4_HRNPEC := time()
			// 	         msunlock()
			//           End Transaction
			//      ENDIF
			//
			//     aadd(_areczzq,{zzq->(recno()),SD2->D2_DOC,SD2->D2_SERIE})
			
			// Endif
			
			//ZZQ->(DBSkip())
			//Enddo
			
			//If len(_areczzq) > 0
			//   for xzq:=1 to len(_areczzq)
			
			//        ZZQ->(DBgoto(_areczzq[xzq,1]))
			//         Reclock("ZZQ",.F.)
			//           ZZQ->ZZQ_NFS    := _areczzq[xzq,2]
			//         ZZQ->ZZQ_NFSSER := _areczzq[xzq,3]
			//         msunlock()
			
			// Next
			//Endif
			
		Endif
		
		
		_cContSe := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_XCONTSE")
		If _cContSe == "S"			
			_cQryAA3 := " SELECT "
			_cQryAA3 += " AA3_CODCLI, AA3_LOJA, AA3_CODPRO, AA3_NUMSER "
			_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock), "+RetSqlName("SB1")+" AS SB1 (nolock) "
			_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
			_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
			_cQryAA3 += " AND AA3_NUMPED='"+SD2->D2_PEDIDO+"' "
			_cQryAA3 += " AND AA3_CODCLI='"+SD2->D2_CLIENTE+"' "
			_cQryAA3 += " AND AA3_LOJA='"+SD2->D2_LOJA+"' "
			_cQryAA3 += " AND AA3_CODPRO='"+SD2->D2_COD+"' "
			_cQryAA3 += " AND AA3_NFVEND='' "
			_cQryAA3 += " AND AA3_XCLASS='S' "
			_cQryAA3 += " AND SB1.D_E_L_E_T_ = '' "
			_cQryAA3 += " AND B1_FILIAL='"+xFilial("SB1")+"' "
			_cQryAA3 += " AND B1_COD=AA3_CODPRO "
			_cQryAA3 += " AND B1_XCONTSE='S' "
			
			_cQryAA3 := ChangeQuery(_cQryAA3)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRY1",.T.,.T.)
			
			_nQtdAA3 := 1 
			
			QRY1->(dbGoTop())
			Do While QRY1->(!Eof()) .AND. SD2->D2_QUANT >= _nQtdAA3
				dbSelectArea("AA3")
				dbSetOrder(1)
				If dbSeek(xFilial("AA3")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
					dbSelectArea("AAF")
					Reclock("AAF",.T.)
					AAF->AAF_FILIAL := xFilial("AAF")
					AAF->AAF_CODCLI := SD2->D2_CLIENTE
					AAF->AAF_LOJA   := SD2->D2_LOJA
					AAF->AAF_CODPRO := AA3->AA3_CODPRO
					AAF->AAF_NUMSER := AA3->AA3_NUMSER
					AAF->AAF_PRODAC := AA3->AA3_CODPRO
					AAF->AAF_NSERAC := AA3->AA3_NUMSER
					AAF->AAF_DTINI  := dDataBase
					AAF->AAF_CODFAB := AA3->AA3_CODFAB
					AAF->AAF_LOJAFA := AA3->AA3_LOJAFA
					AAF->AAF_LOGINI := Left( "NF SAIDA " + ALLTRIM(SD2->D2_SERIE) + "/" + ;
					ALLTRIM(SD2->D2_DOC) + " - NF ENTRADA " + ALLTRIM(AA3->AA3_XSEREN) + "/" + ALLTRIM(AA3->AA3_XNFENT), Len( AAF->AAF_LOGINI ) )
					MsUnLock()
					
					RecLock("AA3",.F.)
					AA3->AA3_NFVEND := SD2->D2_DOC
					AA3->AA3_SERINF := SD2->D2_SERIE
					MsUnLock()
					_nQtdAA3++
				Endif
				dbSelectArea("QRY1")
				DbSkip()
			Enddo
			QRY1->(dbCloseArea())
		Endif
				
		SD2->(dbSkip())
		
	enddo
	
endif

// Atualiza centro de custo no Titulo a Receber
if alltrim(SF2->F2_TIPO) == "N" .and. SE1->(dbSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DOC))
	while SE1->(!eof()) .and. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_PREFIXO == SF2->F2_PREFIXO .and. SE1->E1_NUM == SF2->F2_DOC
		reclock("SE1",.f.)
		SE1->E1_CCD := _cCcSe1
		SE1->E1_NATUREZ := _cNaturez
		msunlock()
		SE1->(dbSkip())
	enddo
endif

If len(_aregzzq) > 0
	for xzq:=1 to len(_aregzzq)
		
		cupdQry:=" UPDATE "+RETSQLNAME("ZZ4")+" SET ZZ4_NFSPEC='"+_aregzzq[xzq,3]+"',ZZ4_NFSSEP='"+_aregzzq[xzq,4]+"',ZZ4_DTNPEC='"+_aregzzq[xzq,5]+"',ZZ4_HRNPEC='"+_aregzzq[xzq,6]+"'   "
		cupdQry+=" FROM "+RETSQLNAME("ZZ4")+" ZZ4 (NOLOCK) INNER JOIN   "
		cupdQry+=" (SELECT * FROM "+RETSQLNAME("ZZQ")+" (NOLOCK) "
		cupdQry+=" WHERE ZZQ_PV='"+_aregzzq[xzq,1]+"' AND ZZQ_ITEMPV='"+_aregzzq[xzq,2]+"' AND D_E_L_E_T_='' AND ZZQ_NFS<>'') AS ZZQ "
		cupdQry+=" ON  ZZ4_IMEI=ZZQ_IMEI AND ZZ4_OS=ZZQ_NUMOS AND ZZ4_PVPECA=ZZQ_PV   "
		cupdQry+=" WHERE ZZ4.D_E_L_E_T_='' AND (ZZ4_NFSPEC='' OR ZZ4_NFSSEP='' OR ZZ4_DTNPEC='') "
		
		TCSQLEXEC (cupdQry)
		TCRefresh(RETSQLNAME("ZZ4"))
	Next
Endif


If len(aPedPeca) > 0 
	For i:=1 to len(aPedPeca)
		AtuMenNF(aPedPeca[i,1],aPedPeca[i,2],aPedPeca[i,3])
	Next i 
Endif


restarea(_aAreaZZ4)
restarea(_aAreaSE1)
restarea(_aAreaSF2)
restarea(_aAreaSD2)
restarea(_aAreaSC5)
restarea(_aAreaZZQ)
restarea(_aAreaSZN)
restarea(_aAreaZZO)
return


Static Function AtuMenNF(cNF,cPvPeca,cPvServ)

Local aAreaAtu := GetArea()
Local cMenNota := ""

If !empty(cPvPeca)
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+cPvPeca)
		If !AllTrim(cNF) $ Alltrim(SC5->C5_MENNOTA)
			dbSelectArea("SC5")
			Reclock("SC5",.F.)
			If !" Ref. NF(s) - " $ Alltrim(SC5->C5_MENNOTA)
		  		SC5->C5_MENNOTA := Alltrim(SC5->C5_MENNOTA)+" Ref. NF(s) - "+AllTrim(cNF)
			Else
				SC5->C5_MENNOTA := Alltrim(SC5->C5_MENNOTA)+"/"+AllTrim(cNF)
			Endif
			MsUnlock()					
		Endif
	Endif
Endif

If !empty(cPvServ)
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+cPvServ)
		If !AllTrim(cNF) $ Alltrim(SC5->C5_MENNOTA)
			dbSelectArea("SC5")
			Reclock("SC5",.F.)
			If !" Ref. NF(s) - " $ Alltrim(SC5->C5_MENNOTA)
		  		SC5->C5_MENNOTA := Alltrim(SC5->C5_MENNOTA)+" Ref. NF(s) - "+AllTrim(cNF)
			Else
				SC5->C5_MENNOTA := Alltrim(SC5->C5_MENNOTA)+"/"+AllTrim(cNF)
			Endif
			MsUnlock()					
		Endif
	Endif
Endif

RestArea(aAreaAtu)

Return