#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GRV  ºAutor  ³Alexandre Nicoletti º Data ³  10/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada responsavel por excluir a entrada massiva º±±
±±º          ³ no momento da exclusao da Nota fiscal de entrada           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100GRV()

local _aAreaSD1  := SD1->(GetArea())
local _aAreaZZ4  := ZZ4->(GetArea())
local _aAreaAB2  := AB2->(GetArea())
local _aAreaAB6  := AB6->(GetArea())
local _aAreaAB7  := AB7->(GetArea())
local _aAreaAB9  := AB9->(GetArea())
local _aAreaSF1  := SF1->(GetArea())
Local _cfornsrf  := SUBSTR(ALLTRIM(GETMV('MV_XFORSRF')),1,6)
Local _cljforsrf := SUBSTR(ALLTRIM(GETMV('MV_XFORSRF')),7,2)
Local _cARMRPG   := GetMV("MV_XARMRPG")
Local _lvalEmass :=.T.
Local _cvalmass  :="1"
Local _nopctip   := 0
Local _lexcluEm  :=.F.
Local _lret      :=.T.

	u_GerA0003(ProcName())


// Incluso conforme solicitacao do Claudio - Biale
// Desabilitado em 05/01/10
//IF FUNNAME()=="FISXACR1"
//   Return()
//Endif

If !Inclui .and. !Altera
	
	//	ZZ4->(dbSetOrder(3))                // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
	ZZ4->(DBOrderNickName('ZZ4ITEMD1')) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_ITEMD1 // M.Munhoz - 23/08/2011 - Substituicao do D1_NUMSER pelo D1_ITEM
	SD1->(dbSetOrder(1))  // D1_FILIAL  + D1_DOC    + D1_SERIE   + D1_FORNECE + D1_LOJA  + D1_COD     + D1_ITEM
	
	If	SD1->(dbSeek(xfilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		
		IF SF1->F1_TIPO ='B'
			_cclieZZ4 := SF1->F1_FORNECE
			_clojcZZ4 := SF1->F1_LOJA
			_cvalmass:=u_VerStat(SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, _cclieZZ4, _clojcZZ4, '4',SF1->F1_TIPO)
			_nopctip :=1
			
		ELSEIF SF1->F1_TIPO ='N' .AND. SF1->F1_FORNECE=_cfornsrf  .AND. SF1->F1_LOJA=_cljforsrf
			_cclieZZ4:=U_CLICOMP(1,SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SD1->D1_COD,SD1->D1_DTDIGIT)
			_clojcZZ4:=U_CLICOMP(2,SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SD1->D1_COD,SD1->D1_DTDIGIT)
			_nopctip :=2
			IF !EMPTY(_cclieZZ4) .AND. !EMPTY(_clojcZZ4)
				_cvalmass:=u_VerStat(SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE,_cclieZZ4, _clojcZZ4, '4',SF1->F1_TIPO)
			ELSE
				_cvalmass:="1"
			ENDIF
		ELSE
			_cvalmass:="1"
		ENDIF
		
		IF _cvalmass = "0"
			_lret:=.T.
			_lvalEmass:=.T.
		Elseif _cvalmass $ "24"
			_lret:=.F.
			_lvalEmass:=.F.
		Elseif  _cvalmass $ "13"
			_lret:=.T.
			_lvalEmass:=.F.
		ENDIF
		
		// Trata todos os itens da NFE
		IF _lvalEmass
			_lexcluEm:=apMsgYesNo("Escolha 'SIM' para Excluir toda da entrada massiva ou 'NAO' para somente alterar o status a Entrada Massiva e ela ficar habilitada para uso no novo Doc. de Entrada ?","Excluir ou Alterar Status da Entrada Massiva")
			
			While SD1->(!eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SF1->F1_DOC == SD1->D1_DOC .and. SF1->F1_SERIE == SD1->D1_SERIE .and.;
				SF1->F1_FORNECE == SD1->D1_FORNECE .and. SF1->F1_LOJA == SD1->D1_LOJA
				
				IF _lexcluEm  // Exclui toda a entrada massiva
					U_DelMASS(_nopctip,SD1->D1_DOC, SD1->D1_SERIE,_cclieZZ4, _clojcZZ4,SD1->D1_COD,SD1->D1_NUMSER,SD1->D1_TIPO,SD1->D1_ITEM)
				ELSE  // Exclui apenas a NFE e prepara a entrada massiva para receber a NFE novamente
					IF _nopctip=1
						//						If ZZ4->(dbSeek(xFilial("ZZ4") + SD1->(D1_DOC + D1_SERIE + _cclieZZ4 + _clojcZZ4 + D1_COD + D1_NUMSER)))
						If ZZ4->(dbSeek(xFilial("ZZ4") + SD1->(D1_DOC + D1_SERIE + _cclieZZ4 + _clojcZZ4 + D1_COD + D1_ITEM)))
							while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ;
								ZZ4->(ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_ITEMD1) == SD1->(D1_DOC + D1_SERIE + _cclieZZ4 + _clojcZZ4 + D1_COD + D1_ITEM)
								RecLock("ZZ4",.F.)
								ZZ4->ZZ4_STATUS := '2'
								ZZ4->ZZ4_LOCAL  := ''
								MsUnLock()
								ZZ4->(dbSkip())
							enddo
						ENDIF
					ELSEIF _nopctip=2
						If ZZ4->(dbSeek(xFilial("ZZ4") + SD1->(D1_DOC + D1_SERIE + _cclieZZ4 + _clojcZZ4 + D1_COD)))
							While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFENR == SD1->D1_DOC .and. ZZ4->ZZ4_NFESER == SD1->D1_SERIE .and. ;
								ZZ4->ZZ4_CODCLI == _cclieZZ4 .and. ZZ4->ZZ4_LOJA == _clojcZZ4
								IF ZZ4->ZZ4_CODPRO=SD1->D1_COD
									RecLock("ZZ4",.F.)
									ZZ4->ZZ4_STATUS := '1'
									ZZ4->ZZ4_LOCAL  := ''
									MsUnlock()
								EndIf
								ZZ4->(DbSkip())
							Enddo
						EndIf
					EndIf
				EndIf
				
				SD1->(DbSkip())
			EndDo
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Muda Status para 2- excluido na tabela ZZL caso tenha se foi digitado|
		//|a OS Nextel de cada item da NFE  Edson Rodrigues - 28/06/10          |                                      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SD1->(dbSeek(xfilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		IF SF1->F1_TIPO ='B' .AND. SD1->D1_LOCAL $ alltrim(_cARMRPG) .and. cA100For <> "Z00403"
			While SD1->(!eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SF1->F1_DOC == SD1->D1_DOC .and. SF1->F1_SERIE == SD1->D1_SERIE .and.;
				SF1->F1_FORNECE == SD1->D1_FORNECE .and. SF1->F1_LOJA == SD1->D1_LOJA .and. SF1->F1_FORMUL == SD1->D1_FORMUL
				_lRet :=U_CADOSPRG(SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_FORMUL,SD1->D1_ITEM,SD1->D1_ITEMGRD,SD1->D1_COD,SD1->D1_EMISSAO,SD1->D1_DTDIGIT,SD1->D1_QUANT,'2')
				
				SD1->(DbSkip())
			EndDo
		ENDIF
		
		If _lRet
			_cQryAA3 := " SELECT "
			_cQryAA3 += " AA3_CODCLI, AA3_LOJA, AA3_CODPRO, AA3_NUMSER "
			_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock), "+RetSqlName("SB1")+" AS SB1 (nolock) "
			_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
			_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
			_cQryAA3 += " AND AA3_XNFENT='"+SF1->F1_DOC+"' "
			_cQryAA3 += " AND AA3_XSEREN='"+SF1->F1_SERIE+"' "
			_cQryAA3 += " AND AA3_FORNEC='"+SF1->F1_FORNECE+"' "
			_cQryAA3 += " AND AA3_LOJAFO='"+SF1->F1_LOJA+"' "
			_cQryAA3 += " AND SB1.D_E_L_E_T_ = '' "
			_cQryAA3 += " AND B1_FILIAL='"+xFilial("SB1")+"' "
			_cQryAA3 += " AND B1_COD=AA3_CODPRO "
			_cQryAA3 += " AND B1_XCONTSE='S' "
			
			_cQryAA3 := ChangeQuery(_cQryAA3)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRY1",.T.,.T.)
			
			QRY1->(dbGoTop())
			Do While QRY1->(!Eof())
				dbSelectArea("AA3")
				dbSetOrder(1)
				If dbSeek(xFilial("AA3")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
					
					If !Empty(AA3->AA3_NFVEND)
						MSGSTOP("Atenção, Não foi possivel excluir o Numero de Serie "+Alltrim(AA3->AA3_NUMSER)+" da Base Instalada." + CHR(13)+CHR(10)+;
						"O mesmo teve sua saida na NF "+Alltrim(AA3->AA3_NFVEND)+". Favor verificar com o Administrador.")
					Else
						Reclock("AA3",.F.)
						DbDelete()
						MsUnLock()
			
						dbSelectarea("AAF")
						dbSetOrder(1)
						If dbSeek(xFilial("AAF")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
							Reclock("AAF",.F.)
							AAF->AAF_DTFIM  := dDataBase
							AAF->AAF_LOGFIM := "EXCLUIDO PELA AMARRACAO"
							MsUnLock()
						EndIf
					Endif
					
				Endif
				dbSelectArea("QRY1")
				DbSkip()
			Enddo
			QRY1->(dbCloseArea())
		Endif
		//Atualizar dados da tabela ZZQ qdo excluir documento de entrada
		If _lRet		
			_cQryZZQ := " SELECT "
			_cQryZZQ += " ZZQ.R_E_C_N_O_ AS RECZZQ "
			_cQryZZQ += " FROM   "+RetSqlName("ZZQ")+" AS ZZQ (nolock) "
			_cQryZZQ += " WHERE ZZQ.D_E_L_E_T_ = '' "
			_cQryZZQ += " AND ZZQ_FILIAL='"+xFilial("ZZQ")+"' "
			_cQryZZQ += " AND ZZQ_NFENTR='"+SF1->F1_DOC+"' "
			_cQryZZQ += " AND ZZQ_SERENT='"+SF1->F1_SERIE+"' "
			
			_cQryZZQ := ChangeQuery(_cQryZZQ)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryZZQ),"QRYZZQ",.T.,.T.)
			
			QRYZZQ->(dbGoTop())
			Do While QRYZZQ->(!Eof())
				dbSelectarea("ZZQ")
				dbGoto(QRYZZQ->RECZZQ)
				RecLock("ZZQ",.F.)
				ZZQ->ZZQ_NFENTR  := ""
				ZZQ->ZZQ_SERENT  := ""
				ZZQ->ZZQ_DTENTR  := CTOD("  /  /  ")
				ZZQ->(MsUnlock())
				dbSelectArea("QRYZZQ")
				QRYZZQ->(dbSkip())
			EndDo			
			QRYZZQ->(dbCloseArea())			
		Endif

	EndIf
	
EndIf

If INCLUI
	If CFORMUL == "S" .AND. CTIPO == "B"
		cNFEntr := "999999999"
		cSerEntr:= "999"
		aRecZZ4 := {}
		DBSELECTAREA("ZZ4")
		ZZ4->(DBSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR +ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO
		If ZZ4->(dbSeek(xFilial('ZZ4') + cNFEntr + cSerEntr + CA100FOR + cLoja))
			While ZZ4->(!eof()) .and. ZZ4->(ZZ4_FILIAL+ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA) == xFilial("ZZ4")+cNFEntr + cSerEntr + CA100FOR + cLoja
				aAdd(aRecZZ4, {ZZ4->(RECNO())})
				ZZ4->(dbSkip())
			Enddo
			For nx:=1 To Len(aRecZZ4)
				dbSelectArea("ZZ4")
				dbGoto(aRecZZ4[nx,1])
				RecLock('ZZ4',.F.)
				ZZ4->ZZ4_NFENR  := CNFISCAL
				ZZ4->ZZ4_NFESER := CSERIE
				MsUnLock('ZZ4')
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Incluso para ajustar a tabela SZA dos processos automáticos³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				AjustaSZA(ZZ4->ZZ4_FILIAL, ZZ4->ZZ4_CODCLI, ZZ4->ZZ4_LOJA, ZZ4->ZZ4_NFENR, ZZ4->ZZ4_NFESER, ZZ4->ZZ4_IMEI)
			Next nx
		Endif
		       
		aRecSZC := {}
		DBSELECTAREA("SZC")
		SZC->(DBSetOrder(1))//ZC_FILIAL+ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO+ZC_ITEMNFE+ZC_ACESS
		If SZC->(dbSeek(xFilial('SZC') + cNFEntr + cSerEntr + CA100FOR + cLoja))
			While SZC->(!eof()) .and. SZC->(ZC_FILIAL+ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA) == xFilial("SZC")+cNFEntr+cSerEntr+CA100FOR+cLoja
				aAdd(aRecSZC, {SZC->(RECNO())})												
				dbSelectArea("SZC")	
				SZC->(dbSkip())
			Enddo
			For nx:=1 To Len(aRecSZC)
				dbSelectArea("SZC")	
				dbGoto(aRecSZC[nx,1])
				RecLock('SZC',.F.)
				SZC->ZC_DOC  := CNFISCAL
				SZC->ZC_SERIE := CSERIE
				MsUnLock('SZC')	
			Next nx		
		Endif
	Endif
	
	/* Rotina de Amarracao de conhecimento de frete com as Notas fiscais CLAUDIA 08/01/2010 - COLOCADA A CHAMADA DA FUNCAO
	AQUI, CONFORME SOLICITADO POR CARLOS ROCHA - RETIRADA A CHAMADA DO P.E. MT100TOK  */
	If AllTrim(CESPECIE) $ "CTR/CTE" .and. FUNNAME() <> "MATA119" .AND. !IsBlind()
		iF FINDFUNCTION("U_CONHECFR")
			U_Conhecfr(SF1->F1_DOC, SF1->F1_SERIE,  SF1->F1_EMISSAO,SF1->F1_LOJA,SF1->F1_FORNECE )
		ENDIF
	EndIF
	
	/* ------- FIM ROTINA DE AMARRACAO CONHECIMENTO DE FRETE --------------------------*/
	
EndIf

restarea(_aAreaAB9)
restarea(_aAreaAB7)
restarea(_aAreaAB6)
restarea(_aAreaAB2)
restarea(_aAreaSD1)
restarea(_aAreaZZ4)
restarea(_aAreaSF1)

Return(_lret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VERSTAT  ºAutor  ³Microsiga           º Data ³  09/17/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se todos os itens da NFE estao com status ate 4     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function VerStat(_cFilial, _cNFE, _cSerie, _cFornece, _cLoja, _cStatus,_ctipo)

local _aAreaZZ4 := ZZ4->(GetArea())
local _aAreaZZ3 := ZZ3->(GetArea())
local _aAreaSC2 := SC2->(GetArea())
local _aAreaSZ9 := SZ9->(GetArea())

local _cRet     := "0"
local _caviso   := ""
local _csugest  := ""

SZ9->(dbSetOrder(2)) // Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM
SC2->(dbSetOrder(1))
ZZ3->(dbSetOrder(1)) // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
ZZ4->(dbSetOrder(3))  // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI

If ZZ4->(dbSeek(_cFilial + _cNFE + _cSerie + _cFornece + _cLoja))
	
	while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == _cFilial .and. ZZ4->ZZ4_NFENR == _cNFE .and. ZZ4->ZZ4_NFESER == _cSerie .and. ;
		ZZ4->ZZ4_CODCLI == _cFornece .and. ZZ4->ZZ4_LOJA == _cLoja
		
		if ZZ4->ZZ4_STATUS > _cStatus
			_cRet    := "2"
			_caviso  := "Existem aparelho(s) encerrado(s) no laboratorio ou  em processo de saida massiva.       Nao sera possivel a exclusao da Entrada Massiva.           O Docto de Entrada nao podera ser refeito de forma automatica,   devera ser refeito totalmente manual.
			_csugest := "SUGESTAO :    Estorne o(s) encerramento(s) e o(s) apontamento(s) do(s) aparelho(s)  e  depois tente excluir esse documento de entrada novamente."
			exit
		Else
			IF ZZ3->(dbSeek(xFilial("ZZ3") + ZZ4->ZZ4_IMEI + LEFT(ZZ4->ZZ4_OS,6) ))
				IF ZZ3->ZZ3_STATUS='1' .AND. ZZ3->ZZ3_ENCOS='S' .AND. ZZ3->ZZ3_ESTORN<> 'S'
					_cRet    := "2"
					_caviso  := "Existem aparelho(s) encerrado(s) no laboratorio ou  em processo de saida massiva. Nao sera possivel a exclusao da Entrada Massiva. O Docto de Entrada nao podera ser refeito de forma automatica via Ent. Massiva, devera ser refeito totalmente manual.
					_csugest := "SUGESTAO :   Estorne  o(s) apontamento(s) do(s) aparelho(s)  e depois tente excluir esse documento de entrada novamente."
					exit
				ELSE
					IF SZ9->(dbSeek(xFilial("SZ9") + ZZ4->ZZ4_IMEI + LEFT(ZZ4->ZZ4_OS,6) + ZZ3->ZZ3_SEQ ))
						IF SZ9->Z9_STATUS='1'
							_cRet    := "2"
							_caviso  := "Existem pecas apontadas nos apontamentos nao encerrado(s) no laboratorio. Nao sera possivel a exclusao da Entrada Massiva. O Docto de Entrada nao podera ser refeito de forma automatica via Ent. Massiva, devera ser refeito totalmente manual.
							_csugest := "SUGESTAO :   Estorne  o(s) apontamento(s) nao encerrados com apontamentos de peças e depois tente excluir esse documento de entrada novamente."
							exit
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			IF SC2->(dbSeek(xFilial("SC2") + LEFT(ZZ4->ZZ4_OS,6)))
				_cRet    := "2"
				_caviso  := "Essa nota possui Ordem de Producao via Entrada Massiva. Nao sera possivel a exclusao da Entrada Massiva. O Docto de Entrada nao podera ser refeito de forma automatica, devera ser refeito totalmente manual.
				_csugest := "SUGESTAO :    Exclua as Ordens de Producao referenta a essa NF de entrada, osapontamento(s) do(s) aparelho(s) se houver e depois tente excluir esse documento de entrada novamente."
				exit
			ENDIF
		ENDIF
		ZZ4->(DbSkip())
	Enddo
	
	//Acrescentado Edson Rodrigues - 27/04/10
	If _cRet="2"
		MsgBox(""+Upper(_caviso)+".","Entr. Massiva nao pode ser Excluida","ALERT")
		MsgBox(""+upper(_csugest)+".","Entr. Massiva nao pode ser Excluida","ALERT")
		_lRet:=apMsgYesNo("Deseja prosseguir com a exclusão do Doc. de Entrada agora ?")
		If _lRet
			_cRet:="3"
		Else
			_cRet:="4"
		Endif
		
	Endif
Else
	
	// Quando nao se trata de exclusao de NFE com entrada massiva
	_cRet:="1"
Endif

restarea(_aAreaZZ4)
restarea(_aAreaZZ3)
restarea(_aAreaSC2)

return(_cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CLICOMP  ºAutor  ³Edson Rodrigues     º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³localiza Cliente e loja da entrada massiva quando se trata  º±±
±±º          |de Doc de Entrada de compra de aparelhos para Industrializarº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function CLICOMP(nopcao,_cFilial,cdoc,cserie,codpro,_ddtdigit)
Local _ccodcli:=""
Local _clojcli:=""
local _aAreaZZ4 := ZZ4->(GetArea())

ZZ4->(dbSetOrder(3))  // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI

If ZZ4->(dbSeek(_cFilial + cdoc + cserie ))
	While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == _cFilial .and. ZZ4->ZZ4_NFENR == cdoc .and. ZZ4->ZZ4_NFESER == cserie
		If  ZZ4->ZZ4_NFEDT=_ddtdigit .AND. ZZ4->ZZ4_CODPRO=codpro
			_ccodcli:=ZZ4->ZZ4_CODCLI
			_clojcli:=ZZ4->ZZ4_LOJA
		ENDIF
		ZZ4->(DbSkip())
	Enddo
Endif

restarea(_aAreaZZ4)
Return(IIf(nopcao=1,_ccodcli,_clojcli))
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELMASS  ºAutor  ³Edson Rodrigues     º Data ³  21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui a entrada massiva                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function Delmass(_nopctip,_cNFE, _cSerie,_cclieZZ4, _clojcZZ4,_Ccod,_cnumser,_ctipo,_cItemSD1)

Local _cchave:=""

IF _nopctip==1
	//	_cchave:=_cNFE +  _cSerie + _cclieZZ4 + _clojcZZ4 + _Ccod + _cnumser
	_cchave:=_cNFE +  _cSerie + _cclieZZ4 + _clojcZZ4 + _Ccod + _cItemSD1
ELSEIF _nopctip==2
	_cchave:=_cNFE +  _cSerie + _cclieZZ4 + _clojcZZ4 + _Ccod
ENDIF

// Localiza a entrada massiva correspondente ao IMEI

IF !EMPTY(_cchave)
	If ZZ4->(dbSeek(xFilial("ZZ4") + _cchave))
		
		IF _nopctip==1
			
			While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL=xFilial("ZZ4") .and. ;
				ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_CODPRO+ZZ4->ZZ4_ITEMD1=_cchave
				//				ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_CODPRO+ZZ4->ZZ4_IMEI=_cchave
				
				//Pega o numero da OS
				_cNumOs  := alltrim(ZZ4->ZZ4_OS)
				_cNrCham :=""
				
				AB6->(dbSetOrder(1))  // AB6_FILIAL + AB6_NUMOS
				If AB6->(dbSeek(xFilial("AB6")+_cNumOs))
					
					AB7->(dbSetOrder(1))  // AB7_FILIAL + AB7_NUMOS + AB7_ITEM
					If AB7->(dbSeek(xFilial("AB7")+AB6->AB6_NUMOS))
						
						// Passa por todos os itens da OS (geralmente devera existir apenas 1 item por OS)
						While AB7->(!eof()) .and. AB7->AB7_FILIAL == xFilial("AB7") .and. AB6->AB6_NUMOS == AB7->AB7_NUMOS
							
							_cNrOS := AB7->AB7_NUMOS + AB7->AB7_ITEM
							
							// Posiciona e deleta o item do chamado tecnico
							AB2->(dbSetOrder(6))  // AB2_FILIAL + AB2_NUMOS
							If AB2->(dbSeek(xFilial("AB2")+_cNrOS))
								_cNrCham := AB2->AB2_NRCHAM
								Reclock("AB2",.F.)
								DbDelete()
								MsUnlock()
							EndIf
							
							//Incluso para excluir o atendimento sempre que cancelar o documento de entrada --Edson Rodrigues 24/01/08
							AB9->(dbSetOrder(1))  // AB9_FILIAL + AB9_NUMOS + AB9_NUMTEC + AB9_SEQ
							If AB9->(dbSeek(xFilial("AB9")+_cNrOS))
								While AB9->(!eof()) .and. AB9->AB9_FILIAL == xFilial("AB9") .and. Substr(AB9->AB9_NUMOS,1,6) == _cNrOS
									Reclock("AB9",.F.)
									DbDelete()
									MsUnlock()
									AB9->(DbSkip())
								Enddo
							EndIf
							
							// Deleta o item da OS
							RecLock("AB7",.F.)
							DbDelete()
							AB7->(MsUnLock())
							AB7->(DbSkip())
						EndDo
						
						// Posiciona e deleta o cabecalho do chamado tecnico
						IF !empty(_cNrCham)
							AB1->(dbSetOrder(1))  // AB1_FILIAL + AB1_NRCHAM
							if AB1->(dbSeek(xFilial("AB1")+_cNrCham))
								RecLock("AB1",.F.)
								DbDelete()
								AB1->(MsUnLock())
							EndIf
						ENDIF
					EndIf
					
					// Deleta o cabecalho da OS
					Reclock("AB6",.F.)
					DbDelete()
					AB6->(MsUnLock())
					
				EndIf 
				
				//volta status do IMEI na tabela ZZO para o usuario conseguir efetuar entrada massiva novamente.
				dbSelectArea("ZZO")
				dbSetOrder(1)
				If dbSeek(xfilial("ZZO")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_CARCAC)
					While ZZO->(!EOF()) .and. ZZO->(ZZO_FILIAL+ZZO_IMEI+ZZO_CARCAC)==xfilial("ZZO")+ZZ4->(ZZ4_IMEI+ZZ4_CARCAC)
						If ZZO->ZZO_NUMCX==ZZ4->ZZ4_ETQMEM .AND. ZZO->ZZO_STATUS == "2"
							Reclock("ZZO",.F.)
							ZZO->ZZO_STATUS := "1"
							ZZO->(MsUnLock())
						Endif					
						ZZO->(dbSkip())
					EndDo
				Endif
				
				// deleta os atendimentos de fases do IMEI
				u_DelZZ3(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
				// deleta os acessorios da nota informada
				u_DelSZC(_cNFE , _cSerie, _cclieZZ4, _clojcZZ4, ZZ4->ZZ4_IMEI)
				// Deleta a entrada massiva
				RecLock("ZZ4")
				DbDelete()
				ZZ4->(MsUnLock())
				
				ZZ4->(DbSkip())
				
			Enddo
		ELSEIF _nopctip==2
			
			
			While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL=xFilial("ZZ4") .and. ;
				ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_CODPRO=_cchave
				
				//Pega o numero da OS
				_cNumOs := alltrim(ZZ4->ZZ4_OS)
				
				AB6->(dbSetOrder(1))  // AB6_FILIAL + AB6_NUMOS
				If AB6->(dbSeek(xFilial("AB6")+_cNumOs))
					
					AB7->(dbSetOrder(1))  // AB7_FILIAL + AB7_NUMOS + AB7_ITEM
					If AB7->(dbSeek(xFilial("AB7")+AB6->AB6_NUMOS))
						
						// Passa por todos os itens da OS (geralmente devera existir apenas 1 item por OS)
						While AB7->(!eof()) .and. AB7->AB7_FILIAL == xFilial("AB7") .and. AB6->AB6_NUMOS == AB7->AB7_NUMOS
							
							_cNrOS := AB7->AB7_NUMOS + AB7->AB7_ITEM
							
							// Posiciona e deleta o item do chamado tecnico
							AB2->(dbSetOrder(6))  // AB2_FILIAL + AB2_NUMOS
							If AB2->(dbSeek(xFilial("AB2")+_cNrOS))
								_cNrCham := AB2->AB2_NRCHAM
								Reclock("AB2",.F.)
								DbDelete()
								MsUnlock()
							EndIf
							
							//Incluso para excluir o atendimento sempre que cancelar o documento de entrada --Edson Rodrigues 24/01/08
							AB9->(dbSetOrder(1))  // AB9_FILIAL + AB9_NUMOS + AB9_NUMTEC + AB9_SEQ
							If AB9->(dbSeek(xFilial("AB9")+_cNrOS))
								While AB9->(!eof()) .and. AB9->AB9_FILIAL == xFilial("AB9") .and. Substr(AB9->AB9_NUMOS,1,6) == _cNrOS
									Reclock("AB9",.F.)
									DbDelete()
									MsUnlock()
									AB9->(DbSkip())
								Enddo
							EndIf
							
							// Deleta o item da OS
							RecLock("AB7",.F.)
							DbDelete()
							AB7->(MsUnLock())
							AB7->(DbSkip())
						EndDo
						
						// Posiciona e deleta o cabecalho do chamado tecnico
						AB1->(dbSetOrder(1))  // AB1_FILIAL + AB1_NRCHAM
						if AB1->(dbSeek(xFilial("AB1")+_cNrCham))
							RecLock("AB1",.F.)
							DbDelete()
							AB1->(MsUnLock())
						EndIf
						
					EndIf
					
					// Deleta o cabecalho da OS
					Reclock("AB6",.F.)
					DbDelete()
					AB6->(MsUnLock())
					
				EndIf
				
				//volta status do IMEI na tabela ZZO para o usuario conseguir efetuar entrada massiva novamente.
				dbSelectArea("ZZO")
				dbSetOrder(1)
				If dbSeek(xfilial("ZZO")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_CARCAC)
					While ZZO->(!EOF()) .and. ZZO->(ZZO_FILIAL+ZZO_IMEI+ZZO_CARCAC)==xfilial("ZZO")+ZZ4->(ZZ4_IMEI+ZZ4_CARCAC)
						If ZZO->ZZO_NUMCX==ZZ4->ZZ4_ETQMEM .AND. ZZO->ZZO_STATUS == "2"
							Reclock("ZZO",.F.)
							ZZO->ZZO_STATUS := "1"
							ZZO->(MsUnLock())
						Endif					
						ZZO->(dbSkip())
					EndDo
				Endif
				
				// deleta os atendimentos de fases do IMEI
				u_DelZZ3(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
				// deleta os acessorios da nota informada
				u_DelSZC(_cNFE , _cSerie, _cclieZZ4, _clojcZZ4, ZZ4->ZZ4_IMEI)
				// Deleta a entrada massiva
				RecLock("ZZ4")
				DbDelete()
				ZZ4->(MsUnLock())
				
				ZZ4->(dbskip())
				
			enddo
			
		endif
		
	EndIf
	
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELZZ3   ºAutor  ³Microsiga           º Data ³  17/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Deleta todos os atendimentos do IMEI x OS                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function DelZZ3(_cDelIMEI, _cDelOS)

local _aAreaZZ3 := ZZ3->(GetArea())

ZZ3->(dbSetOrder(1)) // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ

if ZZ3->(dbSeek(xFilial("ZZ3") + _cDelIMEI + _cDelOS))
	
	while ZZ3->(!eof()) .and. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .and. ZZ3->ZZ3_IMEI == _cDelIMEI .and. left(ZZ3->ZZ3_NUMOS,6) == left(_cDelOS,6)
		
		// Deleta os part numbers
		u_DelSZ9(ZZ3->ZZ3_IMEI, ZZ3->ZZ3_NUMOS, ZZ3->ZZ3_SEQ)
		
		reclock("ZZ3",.f.)
		dbDelete()
		msunlock()
		
		ZZ3->(dbSkip())
		
	enddo
	
endif

restarea(_aAreaZZ3)

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELSZ9   ºAutor  ³Microsiga           º Data ³  17/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Deleta todos os PART NUMBERS de um atendimento de OS       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function DelSZ9(_cDelIMEI, _cDelOS, _cSeq)

local _aAreaSZ9 := SZ9->(GetArea())

SZ9->(dbSetOrder(2)) // Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM

if SZ9->(dbSeek(xFilial("SZ9") + _cDelIMEI + _cDelOS + _cSeq))
	
	while SZ9->(!eof()) .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and. SZ9->Z9_IMEI == _cDelIMEI .and. ;
		SZ9->Z9_NUMOS == _cDelOS .and. SZ9->Z9_SEQ == _cSeq
		
		reclock("SZ9",.f.)
		dbDelete()
		msunlock()
		
		SZ9->(dbSkip())
		
	enddo
	
endif

restarea(_aAreaSZ9)

return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELSZC   º Autor ³Paulo Francisco     º Data ³  20/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ DELETA ACESSORIOS APONTADOS PELA NFE                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DelSZC(cNfe, cSerie, cClie, cLojc)

local _aAreaSZC := SZC->(GetArea())

SZC->(dbSetOrder(1)) // ZC_FILIAL + ZC_DOC + ZC_SERIE + ZC_FORNECE + ZC_LOJA + ZC_CODPRO + ZC_ITEMNFE + ZC_ACESS

if SZC->(dbSeek(xFilial("SZC") + cNFE + cSerie + cclie + clojc))
	
	while SZC->(!eof()) .And. SZC->ZC_FILIAL == xFilial("SZC") .And. SZC->ZC_DOC == cNfe .And. ;
		SZC->ZC_SERIE == cSerie .And. SZC->ZC_FORNECE == cClie .And. SZC->ZC_LOJA == cLojc
		
		reclock("SZC",.f.)
		dbDelete()
		msunlock()
		
		SZC->(dbSkip())
		
	enddo
	
endif

restarea(_aAreaSZC)

return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³MT100GRV  ºAutor ³Hudson de Souza Santos      º Data³20/03/15º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³                                                             º±±
±±º         ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³BGH                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSZA(cFil, cCli, cLoj, cNFNum, cNFSer, cIme)
Local _aArea := GetArea()
dbSelectArea("SZA")
SZA->(dbSetOrder(1)) // ZA_FILIAL, ZA_CLIENTE, ZA_LOJA, ZA_NFISCAL, ZA_SERIE, ZA_IMEI
SZA->(dbGoTop())
If SZA->(dbSeek(xFilial("SZA")+cCli+cLoj+"999999999"+"999"+cIme))
	RecLock("SZA",.F.)
	 SZA->ZA_NFISCAL	:= cNFNum
	 SZA->ZA_SERIE		:= cNFSer
	MsUnLock()
EndIf
RestArea(_aArea)
Return