#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#DEFINE OPEN_FILE_ERROR -1
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CorProd  บAutor  ณEdson Rodrigues     บ Data ณ  28/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que corrige o processo  Producao na(s) seguinte(s)บฑฑ
ฑฑบ          ณ Situacao(oes) : Nao apontamento do componente na producao  บฑฑ
ฑฑบ          | Ja encerrada                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CorProd()
Local  cqry
Local  _nopcao


u_GerA0003(ProcName())

PREPARE ENVIRONMENT EMPRESA  '02' FILIAL '02'  TABLES "SD1","SC2","ZZ4","SD3","SB1","SBM","SB2","SX5","ZZ4","ZZ3"

Private nTamNfe  := TAMSX3("D1_DOC")[1]
Private nTamNfs  := TAMSX3("D2_DOC")[1]
Private nTdocD3  := TAMSX3("D3_DOC")[1]
Private nTcodpr  := TAMSX3("B1_COD")[1]

//_nopcao:=1 //Filtra somente OPs com valor zerado - no qual o componete/produto que entrou nใo foi baixado 
//_nopcao:= 2  //Filtra somente OPs com valor de acordo com condicoes amarradas ao D3 e onde o componete/produto que entrou nใo foi baixado
_nopcao:= 3  //Filtra somente OPs encerradas, com valor de acordo com condicoes amarradas ao D3 e onde o componete/produto que entrou foi baixado, porem a OS nao esta encerrada.

//Seleciona os Registros
cqry:=" SELECT C2_NUM,C2_EMISSAO,C2_QUJE,C2_UM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,C2_LOCAL,ZZ4_IMEI,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODPRO,ZZ4_OPEBGH,ZZ4_VLRUNI,D1_VUNIT,D1_TOTAL,D1_CUSTO, "
cqry+="        D1_CUSTO2,D1_CUSTO3,D1_CUSTO/D1_QUANT AS CUSTUNI,C2_VINI1,C2_VINI2,C2_VINI3,C2_APRATU1,C2_APRATU2,C2_APRATU3,C2_APRINI1,C2_APRINI2,C2_APRINI3,C2_APRFIM1,C2_APRFIM2,C2_APRFIM3 "
cqry+=" FROM   "+retsqlname("SC2")+" AS SC2 (nolock) "
cqry+=" INNER JOIN (SELECT ZZ4_IMEI,ZZ4_OS,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFENR,ZZ4_NFESER,ZZ4_VLRUNI,ZZ4_CODPRO,ZZ4_OPEBGH "
cqry+="             FROM "+retsqlname("ZZ4")+ " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' AND D_E_L_E_T_='') AS ZZ4 "
cqry+=" ON LEFT(C2_NUM,6)=LEFT(ZZ4_OS,6) "
cqry+=" INNER JOIN (SELECT D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_VUNIT,D1_TOTAL,D1_CUSTO,D1_CUSTO2,D1_CUSTO3,D1_QUANT "
cqry+="             FROM "+retsqlname("SD1")+ " WHERE D1_FILIAL='"+XFILIAL("SD1")+"' AND D_E_L_E_T_='') AS SD1 "
cqry+=" ON D1_DOC=ZZ4_NFENR AND D1_SERIE=ZZ4_NFESER AND D1_COD=ZZ4_CODPRO "
IF _nopcao == 2 
   cqry+=" LEFT OUTER JOIN  (SELECT D3_OP,D3_COD,D3_LOCAL,D3_CF "
   cqry+="                   FROM "+retsqlname("SD3")+ " 
   cqry+="                   WHERE D3_FILIAL='"+XFILIAL("SD3")+"' AND D3_TM='502' AND D3_ESTORNO<>'S' AND D3_CF='RE0' AND D3_LOCAL='34' AND D3_EMISSAO>='20101001') AS D3 "
   cqry+=" ON LEFT(ZZ4_OS,6)=LEFT(D3_OP,6) AND ZZ4_CODPRO=D3_COD
   cqry+=" WHERE C2_FILIAL='"+XFILIAL("SC2")+"' AND C2_EMISSAO >='20110301' AND C2_APRATU1=0  AND D3_OP IS NULL AND C2_QUJE <= 0 AND D_E_L_E_T_='' "
   cqry+=" ORDER BY C2_NUM "

ELSEIF _nopcao == 3

   cqry+=" LEFT OUTER JOIN  (SELECT D3_OP,D3_COD,D3_LOCAL,D3_CF "
   cqry+="                   FROM "+retsqlname("SD3")+ " 
   cqry+="                   WHERE D3_FILIAL='"+XFILIAL("SD3")+"' AND D3_TM='502' AND D3_ESTORNO<>'S' AND D3_CF='RE0' AND D3_LOCAL='34' AND D3_EMISSAO>='20101001') AS D3 "
   cqry+=" ON LEFT(ZZ4_OS,6)=LEFT(D3_OP,6) AND ZZ4_CODPRO=D3_COD      "
   cqry+=" LEFT OUTER JOIN  ( SELECT ZZ3_NUMOS,ZZ3_IMEI,ZZ3_STATUS,ZZ3_ENCOS,ZZ3_ESTORN 
   cqry+="                    FROM "+retsqlname("ZZ3")+ " 
   cqry+="                    WHERE ZZ3_FILIAL='"+XFILIAL("ZZ3")+"' AND ZZ3_ENCOS='S' AND ZZ3_ESTORN<>'S' AND ZZ3_STATUS='1' AND D_E_L_E_T_='') AS ZZ3 "
   cqry+=" ON C2_NUM=LEFT(ZZ3_NUMOS,6) "
   cqry+=" WHERE C2_FILIAL='"+XFILIAL("SC2")+"' AND C2_EMISSAO >='20110301' AND ZZ3_NUMOS IS NULL AND D_E_L_E_T_='' "  
   cqry+="  AND   C2_QUJE > 0 "
   cqry+=" ORDER BY C2_NUM "

ELSE
   cqry+=" WHERE C2_FILIAL='"+XFILIAL("SC2")+"' AND C2_APRATU1=0 AND C2_QUJE > 0  AND D_E_L_E_T_='' "
   cqry+=" ORDER BY C2_NUM "
ENDIF

dbselectarea("ZZJ")
ZZJ->(dbsetOrder(1)) // ZZJ_FILIAL + ZZJ_OPEBGH+ ZZJ_LAB

dbselectarea("SB2")
SB2->(DBSetOrder(1)) //B1_FILIAL+B1_COD


if select("TRB") > 0
	TRB->(dbclosearea())
endif


TCQUERY cqry NEW ALIAS "TRB"
ProcRegua(TRB->(reccount()))

TRB->(dbGoTop())
While TRB->(!eof())
	
	// Incrementa a regua
	IncProc()
	
	coperac    := TRB->ZZ4_OPEBGH
	_cnewpro   := TRB->C2_PRODUTO
	carmproc   := TRB->C2_LOCAL
	_cIMEI     := TRB->ZZ4_IMEI
	_cNumOS    := TRB->C2_NUM
	_cprod     := TRB->ZZ4_CODPRO
	_cunmed    := TRB->C2_UM
	_cFaseenc  := u_FasEncer(_cIMEI,_cNumOS)
	_atransp   := {}
	ltransf    := .T.
	lInclui    := .F.
	_lgertrans := .T.
	_nqtde     := TRB->C2_QUJE
	CPARTNR    := SPACE(15)
	_lencrrado := iif(empty(_cFaseenc),.f.,.t.)
	_lexctrapo := .f.
	_linclreq  := .f.
	_lprod     := .T.
	_cdocto  :=RIGHT(alltrim(TRB->ZZ4_NFENR),nTdocD3)
	_cdocto  :=alltrim(_cdocto)+space(nTdocD3-len(alltrim(_cdocto))) 
	_cdocd3  := LEFT(_cNumOS,6)+SPACE(nTdocD3-len(LEFT(_cNumOS,6)))
	
	
	
	
	
	If ZZJ->(dbseek(xFilial("ZZJ")+coperac))
		carmcomp   :=LEFT(ZZJ->ZZJ_ARMENT,2)
		carmpeca   :=ZZJ->ZZJ_ALMEP
		carmpacab  :=ZZJ->ZZJ_ALMPRO
		cmovprod   :=ZZJ->ZZJ_CODPRO
		carmscrap  :=ZZJ->ZZJ_ALMSCR
		cprefixpa  :=ALLTRIM(ZZJ->ZZJ_PREFPA)
		_cfascrap  :=ZZJ->ZZJ_FASSCR
		_clab      :=ZZJ->ZZJ_LAB
		cmovcons   :=ZZJ->ZZJ_CODSF5    
		_ccoper   :=ZZJ->ZZJ_CC
	Else
		Return
	Endif
	
//	IF  TRB->C2_QUJE > 0
		
		//Faz Exclusao da Transferencia e estorno da producao
		_lexctrapo:=U_EXEMPAPO(CPARTNR,_nqtde,_cNumOS+'01001  ',_cprod,_lencrrado,coperac,_clab)
		If (_lexctrapo .and. _nqtde > 0) .or. (!_lexctrapo .and. _nqtde = 0)
			
			IF !SB2->(DBSeek(xFilial('SB2')+_cprod+carmproc))
				U_saldoini(_cprod,alltrim(carmproc),.T.)
			ENDIF
			
			
			IF SB2->(DBSeek(xFilial('SB2')+_cprod+carmproc))
				nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)
				
				IF nSalb2 <= 0
					
					IF !SB2->(DBSeek(xFilial('SB2') + _cprod + carmcomp))
						U_saldoini(_cprod,alltrim(carmcomp),.T.)
					ENDIF
					
					
					IF  SB2->(DBSeek(xFilial('SB2') + _cprod + carmcomp))
						//NMODULO :=04
						//CMODULO :="EST"
						nSalb2  :=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)
						nsabzz4 :=u_SalabZZ4(coperac,'3',_cprod)
						
						IF  nSalb2 > nsabzz4
							lInclui:=.T.
							
							//Faz Transferencia do Saldo Disponivel do armazem de compra para o armazem de processo
							U_SRAdtrans(_cprod,carmcomp,_cdocto,_cprod,alltrim(carmproc),@_atransp,@ltransf,@lInclui,@_lgertrans,0,0,nSalb2-nsabzz4)
							IF !ltransf
								apMsgStop("Nao foi possํvel fazer a transferencia do armaz origem:"+carmcomp+ " para o armaz destino: "+carmproc+ " do produto : "+alltrim(_cprod)+" Favor verificar. Duvidas Contate o administrador do sistema")
								//NMODULO:=28
								//CMODULO:="TEC"
							Else
								nrest:=nSalb2-nsabzz4
								apMsgStop("foi Transferido do armaz origem:"+carmcomp+ " para o armaz destino: "+carmproc+ " do produto : "+_cprod+" somente a quantidade de "+strzero(nSalb2,3)+". O restante de "+strzero(nrest,3)+" ficou sem transferir por insuficiencia de saldo no armazem origem.  Favor verificar")
								//NMODULO:=28
								//CMODULO:="TEC"
								
							Endif
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			
			
			SB2->(DBSeek(xFilial('SB2')+_cprod+carmproc))
			nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)
			IF nSalb2 > 0 .and. nSalb2 >= _nqtde
				nOpcao :=1
				//Faz baixa por reusicao do componente
				_linclreq:=u_REQ_EST(nOpcao,_cprod,carmproc,iif(!_lexctrapo .and. _nqtde <= 0,1,_nqtde),_cNumOS+'01001',DATE(),,cmovcons,NIL,NIL,_lprod,_cNumOS+'01001',_ccoper)
			ENDIF
			
			
			IF _linclreq .and. _lencrrado
				_laponta  :=.t.
				_aAponOP  :={}
				lInclui   :=.t.
				_lgerapon :=.t.
				
				//Faz o apontamento novamente
				U_SRAdApo(cmovprod,_cnewpro,_cunmed,left(_cnumos,6),left(carmproc,2),@_laponta,@_aAponOP,@lInclui,@_lgerapon,SPACE(6))
				
				//Faz transferencia novamente
				IF _laponta
					U_SRAdtrans(_cnewpro,left(carmproc,2),_cdocd3,_cnewpro,iif(left(_cFaseenc,2) $ _cfascrap,left(carmscrap,2),left(carmpacab,2)),@_atransp,@ltransf,@lInclui,@_lgertrans,0,0,iif(!_lexctrapo .and. _nqtde <= 0,1,_nqtde))
				ENDIF
			Endif
		Endif
	//ENDIF
	
	TRB->(DBSKIP())
ENDDO

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFasEncer  บAutor  ณEdson Rodrigues     บ Data ณ  28/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVer qual a fase do ultimo apontamento encerrado             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function FasEncer(_cIMEI, _cNumOS)
local _aAreaZZ3 := ZZ3->(GetArea())
local _cfasenc  := ""
local cselQry   := ""

If Select("QryZZ3") > 0
	QryZZ3->(dbCloseArea())
Endif

cselQry:=" SELECT ZZ3_ENCOS,ZZ3_FASE1 "
cselQry+=" FROM "+retsqlname("ZZ3")+" (NOLOCK) "
cselQry+=" INNER JOIN "
cselQry+="      (SELECT MAX(R_E_C_N_O_) AS RECNO       "
cselQry+="       FROM "+retsqlname("ZZ3")+" (NOLOCK)   "
cselQry+="       WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND  ZZ3_IMEI='"+_cIMEI+"' AND LEFT(ZZ3_NUMOS,6)='"+left(_cNumOS,6)+"' AND D_E_L_E_T_='' AND ZZ3_STATUS='1' AND ZZ3_ESTORN<>'S') AS ZZ31 "
cselQry+=" ON RECNO=R_E_C_N_O_ " "

TCQUERY cselQry ALIAS "QryZZ3" NEW
TCRefresh("ZZ3020")

If Select("QryZZ3") > 0  .AND. QryZZ3->ZZ3_ENCOS='S'
	QryZZ3->(dbGoTop())
	IF QryZZ3->(!eof())
		_cfasenc:=QryZZ3->ZZ3_FASE1
	endif
	QryZZ3->(dbCloseArea())
Endif

restarea(_aAreaZZ3)

Return(_cfasenc)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSalabzz4  บAutor  ณEdson Rodrigues     บ Data ณ  28/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVer quantidade de saldo a processar para Operacao Refurbish บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function Salabzz4(coper,cstatus,_cprod)
local _aAreaZZ4 := ZZ4->(GetArea())
local _nsalZZ4  := 0
local cselQry   := ""

If Select("QryZZ4") > 0
	QryZZ4->(dbCloseArea())
Endif

cselQry:=" SELECT COUNT(ZZ4_IMEI) AS QTDZZ4 "
cselQry+=" FROM "+retsqlname("ZZ4")+"  (NOLOCK) "
cselQry+=" WHERE ZZ4_FILIAL='"+xFilial("ZZ3")+"' AND  ZZ4_OPEBGH='"+coper+"' AND  ZZ4_STATUS < '"+cstatus+"' "
cselQry+="       AND ZZ4_CODCLI='"+_cprod+"' AND  D_E_L_E_T_=''

TCQUERY cselQry ALIAS "QryZZ4" NEW
TCRefresh("ZZ4020")

If Select("QryZZ4") > 0
	QryZZ4->(dbGoTop())
	IF QryZZ4->(!eof())
		_nsalZZ4:=QryZZ4->QTDZZ4
	endif
	QryZZ4->(dbCloseArea())
Endif

restarea(_aAreaZZ4)

Return(_nsalZZ4)
