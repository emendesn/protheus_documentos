#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#define ENTER CHR(10)+CHR(13)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Buscaces  ºAutor  ³ Edson Rodrigues º Data ³  10/09/2010    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca acessorios conforme parametros recebidos             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Buscaces(_cdoc,_cserie,_ccli,_cloja,_cprod,_cimei,_coperbgh)
Local _acessor := {}         
Local _cSepEnt := Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_SEPENT")//Incluido conforme solicitação do Edson 12/06/2012

u_GerA0003(ProcName())

  dbSelectArea('SX5')
  SX5->(dbSetOrder(1))

  dbSelectArea('SZC')  //Acessorios
  SZC->(dbSetOrder(1)) 
  cAliasSZC1	:= GetNextAlias()

  _cQrySZC := " SELECT ZC_TPACESS,ZC_QUANT, ZC_ACERECE,ZC_ACESS "+ENTER
  _cQrySZC += " FROM   "+RetSqlName("SZC")+" (nolock) "+ENTER
  _cQrySZC += " WHERE ZC_FILIAL = "+xFilial("SZC")+" AND "+ENTER
  _cQrySZC += "       ZC_DOC     = '"+_cdoc+"' AND "+ENTER
  _cQrySZC += "       ZC_SERIE   = '"+_cserie+"' AND "+ENTER
  _cQrySZC += "       ZC_FORNECE = '"+_ccli+"' AND "+ENTER
  _cQrySZC += "       ZC_LOJA    = '"+_cloja+"' AND "+ENTER
  _cQrySZC += "       ZC_CODPRO  = '"+_cprod+"' AND "+ENTER
  _cQrySZC += "       ZC_IMEI    = '"+_cimei+"' AND "+ENTER
  _cQrySZC += "       ZC_STATUS  <> '0' AND "+ENTER
  _cQrySZC += "       ZC_TPACESS <> ''  AND "+ENTER
  _cQrySZC += "       D_E_L_E_T_ = '' "+ENTER                                         
  _cQrySZC += " ORDER BY ZC_TPACESS "+ENTER

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySZC),cAliasSZC1,.T.,.T.)
  (cAliasSZC1)->(DBGoTop())

  ProcRegua((cAliasSZC1)->(RECCOUNT()))
  While !(cAliasSZC1)->(EOF())
  
      If _cSepEnt <> "S"
	      IF  SX5->(dbSeek(xFilial("SX5") + "Z5" + (cAliasSZC1)->ZC_TPACESS))
	        aadd(_acessor,{(cAliasSZC1)->ZC_QUANT, (cAliasSZC1)->ZC_TPACESS, ALLTRIM(SX5->X5_DESCRI), (cAliasSZC1)->ZC_ACERECE})
	      ENDIF 
	  Else
	  	dbSelectArea("SB1")
	  	dbSetOrder(1)
	  	If dbSeek(xFilial("SB1")+(cAliasSZC1)->ZC_ACESS)
	  		aadd(_acessor,{(cAliasSZC1)->ZC_QUANT, Alltrim(SB1->B1_COD), ALLTRIM(SB1->B1_DESC), (cAliasSZC1)->ZC_ACERECE})	  	
	  	Endif
	  Endif

	  IncProc()
	 (cAliasSZC1)->(DBSkip())
  Enddo

Return(_acessor)
