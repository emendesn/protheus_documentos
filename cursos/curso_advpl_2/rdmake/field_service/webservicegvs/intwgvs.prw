#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณINTWGVS   บ Autor ณ Eduardo Nakamatu      บ Data ณ 26/01/09 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Prgrama para gerar os dados para WebService GVS            บฑฑ
ฑฑบ          ณ    Microsiga X Webservice GVS                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nRegI = Contando Inclus๕es                                 บฑฑ
ฑฑบ          ณ nRegE = Contando Altera็๕es                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function INTWGVS(nRegI,nRegE,aParam)
Default nRegI := 0
Default nRegE := 0
Sleep(180)
//ConOut("*")
//ConOut("*")
//ConOut("*")
//ConOut(Replicate("*",40))
//ConOut("   [INTWGVS] ["+Right("00"+Alltrim(STR(Day(date()))),2)+"/"+Right("00"+Alltrim(STR(Month(date()))),2)+"/"+Right("0000"+Alltrim(STR(Year(date()))),4)+"-"+Time()+;
//	"] versao 1.0 - "+dtoc(date())+" "+time())
//ConOut("   [INTWGVS] ["+Right("00"+Alltrim(STR(Day(date()))),2)+"/"+Right("00"+Alltrim(STR(Month(date()))),2)+"/"+Right("0000"+Alltrim(STR(Year(date()))),4)+"-"+Time()+;
//	"] Montando ambiente Enviroment empresa/filial 02/06...")
*
PREPARE ENVIRONMENT EMPRESA  aParam[1] FILIAL  aParam[2] TABLES "ZZ4","ZZ3","ZZ1","ZZ2","ZZ8","SZ9","SZ8","SZA","SA1","SX5","SZ7","SB1","SD1","AB7"
u_GerA0003(ProcName())
*
Private aAlias		:= {"ZZ4","ZZ3","ZZ1","ZZ2","ZZ8","SZ9","SZ8","SZA","SA1","SX5","SZ7","SB1","SD1","AB7"}
Private aIncZZ8		:= {}
Private aaltZZ8		:= {}
Private CR			:= CHR(13)+CHR(10)
Private _lret		:= .T.
Private _laltZZ8	:= .F.
Private _lincZZ8	:= .F.
Private  _cdefcon	:= " "
Private _nProc		:= 0
Private nTamNfs		:= TAMSX3("D2_DOC")[1]
Private _cidsint,_nitmSZ9,_codsint,_csintom,_laltsin, _cidpeca,_cpeca,_cnfser,_cnfsnr,_ccodcli,_cclojcl,_ccimei
Private _nqtypc,_cpospec,_cprecor,_laltpec,_ciddefe,_nseqSZ9,_codsolu,_coddefe
Private _codgrso,_cmotdef,_cnivrep,_cgonogo,_laltdef,_cseqZZ3,_ctecZZ3,_cOSZZ3,_ccodgnog,_cstsint, aInfNFSai
*
//ConOut("   [INTWGVS] ["+DTOC(Date())+"-"+Time()+"] Posicionando tabelas acessorias...")
*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre as tabelas a serem usadasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SD2")
dbSetOrder(7)  //D2_FILIAL, D2_PDV, D2_SERIE, D2_DOC, D2_CLIENTE, D2_LOJA
dbSelectArea("SA1")
dbSetOrder(1) //A1_FILIAL+A1_Cod+A1_Loja
dbSelectArea("ZZ1")
dbSetOrder(3) //ZZ1_FILIAL+ZZ1_FASE1+ZZ1_LAB
dbSelectArea("ZZ3")
dbSetOrder(1) //ZZ3_FILIAL+ZZ3_IMEI+ZZ3_NUMOS+ZZ3_SEQ
dbSelectArea("SB1")
dbSetOrder(1) //B1_FILIAL+B1_COD
dbSelectArea("SZ9")
dbSetOrder(1) //Z9_FILIAL+Z9_NUMOS+Z9_CODTEC+Z9_SEQ+Z9_ITEM
dbSelectArea("SF2")
dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
dbSelectArea("ZZ8")
dbSetOrder(3) //ZZ8_FILIAL+ZZ8_IMEI+ZZ8_NUMOS+ZZ8_CODPRO+ZZ8_ETAPOS
dbSelectArea("ZZ4")
dbSetOrder(1) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
dbSelectArea("AB7")
dbSetOrder(9) //AB7_FILIAL, AB7_NUMOS, AB7_NUMSER
//AB7->(DBOrderNickName('AB7NUMSER'))//dbSetOrder(6) //AB7_FILIAL+AB7_NUMOS+AB7_NUMSER
dbSelectArea("SX5")
dbSetOrder(1) //X5_FILIAL+X5_TABELA+X5_CHAVE
dbSelectArea("Z03")
dbSetOrder(1) //Z03_FILIAL, Z03_DOC, Z03_SERIE, Z03_OBJETO, Z03_EMISSA
dbSelectArea("SC6")
dbSetOrder(15) //C6_FILIAL, C6_IMEINOV, C6_NUM, C6_ITEM
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
*
//ConOut("   [INTWGVS] ["+DTOC(Date())+"-"+Time()+"] Montando QUERY de trabalho ZZA/SZA...")
*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona tudo que foi alterado ou novo registro -- atravesณ
//ณdos campos ZZ4_MSEXP='' AND ZZ4_STATUS>='3'                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT * "
cQuery += CR + "FROM "+RETSQLNAME("ZZ4")+" as ZZ4(NOLOCK) "
cQuery += CR + "	INNER JOIN "+RETSQLNAME("SZA")+" as SZA(NOLOCK) "
cQuery += CR + "		ON SZA.D_E_L_E_T_ = ZZ4.D_E_L_E_T_ "
cQuery += CR + "			AND ZA_FILIAL = ZZ4_FILIAL "
cQuery += CR + "			AND ZA_CLIENTE = ZZ4_CODCLI "
cQuery += CR + "			AND ZA_LOJA = ZZ4_LOJA "
cQuery += CR + "			AND ZA_NFISCAL = ZZ4_NFENR "
cQuery += CR + "			AND ZA_SERIE = ZZ4_NFESER "
cQuery += CR + "			AND ZA_IMEI = ZZ4_IMEI "
cQuery += CR + "			AND ZA_CODPRO = ZZ4_CODPRO "
cQuery += CR + "			AND ZA_STATUS = 'V' "
cQuery += CR + "			AND ZA_LOTEIRL = ZZ4_LOTIRL "
cQuery += CR + "			AND ZA_LOTEIRL <> '' "
cQuery += CR + "WHERE ZZ4.D_E_L_E_T_ = '' "
cQuery += CR + "	AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
cQuery += CR + "	AND ZZ4_MSEXP = '' "
cQuery += CR + "	AND NOT(ZZ4_GVSOS in ('','0000000000') AND ZZ4_OPEBGH in ('S05','S09')) "
//Alterado para envio apenas dos encerrados a cada meia hora e envio do restante a partir das 20:30
//cQuery += CR + "	AND ZZ4_STATUS < '9' "
cQuery += CR + "	AND (ZZ4_STATUS in ('9','3') OR convert(time,getdate()) > convert(time,'20:00:00') ) "
cQuery += CR + "	AND ZZ4_OPEBGH in ('S05','S06','S08','S09') "
//cQuery += CR + "	AND ZZ4_FILIAL+ZZ4_IMEI+ZZ4_GVSOS IN (SELECT FILIAL+IMEI+GVSOS FROM ENVIA) " // GOTO SOLICITAวรO THIAGO B2X
//cQuery += CR + "	AND ZZ4_IMEI = '353004060021446' " // GOTO SOLICITAวรO THIAGO B2X
cQuery += CR + "	AND ZZ4_LOTIRL <> '' "
cQuery += CR + "ORDER BY ZZ4_FILIAL, ZZ4_IMEI, ZZ4_OS "
//MEMOWRIT("D:\A\INTWGVS01_01.SQL",cQuery)
cQuery := strtran(cQuery, "	", "")
cQuery := strtran(cQuery, CR, " ")
//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
TCQUERY cQuery NEW ALIAS "TRB"
TcSetField("TRB","ZZ4_EMDT" ,"D")
TcSetField("TRB","ZZ4_NFEDT","D")
TcSetField("TRB","ZZ4_NFSDT","D")
TcSetField("TRB","ZA_DTOSGVS","D")
TcSetField("TRB","ZZ4_DOCDTE","D")
TcSetField("TRB","ZA_DTOSGVS","D")
TcSetField("TRB","ZZ4_DOCDTS","D")
TcSetField("TRB","ZA_DTRECPR","D")
TcSetField("TRB","ZA_DTNFCOM","D")
TcSetField("TRB","ZA_VALNFCO","N",13,2)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa Novos registrosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ConOut("   [INTWGVS] ["+DTOC(Date())+"-"+Time()+"] Processando registros encontrados...")
TRB->(dbGoTop())
While !TRB->(Eof())
	_nProc++
	_laltZZ8 := .F.	
	//ConOut("   [INTWGVS] ["+DTOC(Date())+"-"+Time()+"] Processando "+StrZero(_nProc,6))
	_laltAB7	:= .F.
	_laltSZ9	:= .F.
	_laltcli	:= .F.
	_laltcom	:= .F.
	_laltexp	:= .F.
	_laltfal	:= .F.
	_laltpec	:= .F.
	_laltaco	:= .F.
	_lfase		:= .F.
	_cseq		:= ""
	_cstaAB7	:= "0"
	_laltsin	:= .F.
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona no cliente para buscar os dados do mesmo, somente quando For alteracao.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cidcli		:= ""
	_ccodcli	:= TRB->ZZ4_CODCLI
	_cclojcl	:= TRB->ZZ4_LOJA
	dbSelectArea("SA1")
	SA1->(dbSeek(TRB->ZZ4_FILIAL+_ccodcli+_cclojcl))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTSOInfo - Informacoes da OSณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cfilial	:= TRB->ZZ4_FILIAL
	_ccimei		:= AvKey(TRB->ZZ4_IMEI,"ZZ4_IMEI")
	_ccnumos	:= AllTrim(TRB->ZZ4_OS)
	_COSGVS		:= AllTrim(TRB->ZA_OSGVS)
	_ccodpro	:= TRB->ZA_CODPROD
	_cnfentr	:= TRB->ZZ4_NFENR
	_cnfeser	:= TRB->ZZ4_NFESER
	_ddocdte	:= TRB->ZZ4_DOCDTE
	_cdochre	:= TRB->ZZ4_DOCHRE
	_cimeswp	:= TRB->ZZ4_SWAP
	_cprodup	:= Iif(Len(Alltrim(TRB->ZZ4_PRODUP))=4,TRB->ZZ4_PRODUP,Posicione("SB1",1,xFilial("SB1")+TRB->ZZ4_PRODUP,"B1_MODELO"))
	_cctroca	:= TRB->ZZ4_CTROCA
	_cdpyimn	:= TRB->ZZ4_DPYINV
	_cdpyime	:= TRB->ZZ4_DPYIME
	_cgvsos		:= TRB->ZZ4_GVSOS
	_clotirl	:= TRB->ZZ4_LOTIRL
	_ccodpos	:= IIF(EMPTY(TRB->ZA_CODPOST),TRB->ZA_CODATEN,TRB->ZA_CODPOST)
	_ddtosgv	:= TRB->ZA_DTOSGVS
	_chrosgv	:= TRB->ZA_HROSGVS
	_cdpyrep	:= TRB->ZA_CODDPY
	_codAT		:= TRB->ZA_CODATEN
	_cnumcel	:= "00000000"  //Nao e obrigatorio
	_cnomeop	:= VEROPER(AllTrim(TRB->ZA_NOMEOPE))
	_clocate	:= VERLOCA(AllTrim(TRB->ZA_LOCATEN))
	_ccproce	:= VERCPROC(AllTrim(TRB->ZA_CODPROC))
	_ccodcob	:= AllTrim(TRB->ZA_CODCOBE)
	_codtpse	:= VERTPSER(AllTrim(TRB->ZA_CODTPSE))
	_cdtfabr	:= TRB->ZA_DTFABRI
	_cnomate	:= AllTrim(TRB->ZA_NOMEATE)
	_cnomate	:= U_TiraAcento(_cnomate)
	_drecpro	:= TRB->ZA_DTRECPR
	_chrrecp	:= TRB->ZA_HRRECPR
	_cdefcon	:= AllTrim(TRB->ZA_DEFCONS)
	_cdefcon	:= U_TiraAcento(_cdefcon)
//	_cmarca		:= Iif(Empty(TRB->ZA_MARCA),"SONY ERICSSON",AllTrim(TRB->ZA_MARCA))
	_cmarca		:= "SONY ERICSSON"
	_cfasatu	:= TRB->ZZ4_FASATU
	_cstaZZ4	:= TRB->ZZ4_STATUS
	_cidOS		:= Iif(!Empty(_ccnumos), _ccnumos + _clotirl + "001","")
	_cestap		:= ""  //Nao e obrigatorio
	_csofrev	:= ""  //Nao e obrigatorio
	_ddtinst	:= TRB->ZA_DTOSGVS // Iif(!Empty(TRB->ZZ4_ATPRI),(CTOD(left(TRB->ZZ4_ATPRI,2)+"/"+SubSTR(TRB->ZZ4_ATPRI,5,2)+"/"+RIGHT(TRB->ZZ4_ATPRI,4))),ctod(" / / "))
	_cchrins	:= ""
	_ddtrepa	:= ctod(" / / ")
	_chrrepa	:= ""
	_ddtinsf	:= ctod(" / / ")
	_ddtfatu	:= ctod(" / / ")
	_chrfatu	:= ""
	_chrinsf	:= ""
	_cobsrep	:= ""
	_netpOS		:= 0
	_cacomp		:= ""
	_ddtprev	:= TRB->ZZ4_DOCDTE+4 //Soma 4 dias da data de entrada na DOCA
	_cacess		:= ""            //Verificar acessorios para o IMEI na tabela SZC
	_cstosgvs	:= ""            //Status OS GVS
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณHudson de Souza Santos - corre็ใo.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(TRB->ZZ4_SWAP)
		_cnfsnr		:= padr(TRB->ZZ4_NFSNR,nTamNfs)
		_cnfser		:= AllTrim(TRB->ZZ4_NFSSER)
		If !Empty(_cnfsnr)
			_cidexpe	:= AllTrim(_cnfsnr)+AllTrim(_cnfser)+AllTrim(_clotirl)+"01"
			_dnfsdt		:= Iif(Empty(TRB->ZZ4_NFSDT),ctod(" / / "),TRB->ZZ4_NFSDT)
			_cateent	:= "EXPED. BGH"
			_nitmnf		:= veritnf(_cfilial,TRB->ZZ4_PV,_cnfser,AllTrim(_cnfsnr),_ccodcli,_cclojcl,_ccimei)
			_nitotnf	:= vtotinf(_cfilial,TRB->ZZ4_PV,_cnfser,AllTrim(_cnfsnr),_ccodcli,_cclojcl,_ccimei)
			_cawb		:= GetAwb(_cnfsnr, _cnfser)
			_cnfshr		:= TRB->ZZ4_DOCHRS
			_cstexpe	:= "1"
		Else
			_cidexpe	:= ""
			_dnfsdt		:= CtoD("  /  /  ")
			_cateent	:= ""
			_nitmnf		:= 0
			_nitotnf	:= 0
			_cawb		:= ""
			_cnfshr		:= ""
			_cstexpe	:= "0"
		EndIf
	Else
		aInfNFSai	:= GetNFSwp(TRB->ZZ4_SWAP)
		If Len(aInfNFSai) = 9
			_cnfsnr		:= aInfNFSai[1]
			_cnfser		:= aInfNFSai[2]
			_cidexpe	:= aInfNFSai[3]
			_dnfsdt		:= aInfNFSai[4]
			_cateent	:= aInfNFSai[5]
			_nitmnf		:= aInfNFSai[6]
			_nitotnf	:= aInfNFSai[7]
			_cawb		:= aInfNFSai[8]
			_cnfshr		:= aInfNFSai[9]
			_cstexpe	:= "1"
		Else
			_cnfsnr		:= ""
			_cnfser		:= ""
			_cidexpe	:= ""
			_dnfsdt		:= CtoD("  /  /  ")
			_cateent	:= ""
			_nitmnf		:= 0
			_nitotnf	:= 0
			_cawb		:= ""
			_cnfshr		:= ""
			_cstexpe	:= "0"
		EndIf
	EndIf
	_cseqZZ3	:= "01"
	_ctecZZ3	:= ""
	_cclojcl	:= TRB->ZZ4_LOJA
//	_dnfsdt		:= ctod(" / / ")
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona no Item da OS para buscar o status.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("AB7")
	If AB7->(dbSeek(TRB->ZZ4_FILIAL+LEFT(TRB->ZZ4_OS,6)+_ccimei))
		_cstaAB7	:= AB7->AB7_TIPO
//		_cstaAB7	:= Posicione("AB7",9,xFilial("AB7")+_ccnumos+_ccimei,"AB7_TIPO")
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona na ZZ8 PARA Buscar os IDs das classes (compra,cliente,Sintoma,Falhas,Pecas,Expedicao e Acompanhamento).ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("ZZ8")////ZZ8_FILIAL+ZZ8_IMEI+ZZ8_NUMOS+ZZ8_CODPRO
	ZZ8->(dbSetOrder(3))//ZZ8_FILIAL, ZZ8_IMEI+ZZ8_NUMOS+ZZ8_CODPRO
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerificado Etapa da OS para atualizar ZZ8.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(_cstaAB7) .AND. !Empty( _cstaZZ4)
		If _cstaAB7 $ "1/3/0" .AND. _cstaZZ4<="4"
			_netpOS	:= 5 //5- Em Reparo
			_cacomp	:= "Em Reparo"
		ElseIf _cstaAB7  $ "4/0" .AND. _cstaZZ4 $ "4/5"
			_netpOS	:= 6 //6-Reparo Concluido
			_cacomp	:= "Reparo Concluido"
		ElseIf _cstaAB7 $ "5/2/0" .AND. _cstaZZ4="5"
			_netpOS	:= 7 //-Encerramento
			_cacomp	:= "Encerramento do Reparo"
		ElseIf _cstaAB7 $ "5/2/0" .AND. _cstaZZ4 $"6/7/8"
			_netpOS	:= 7 //-Encerramento
			_cacomp	:= "EM EXPEDICAO"
		ElseIf _cstaAB7 $ "5/2/0" .AND. _cstaZZ4 = "9"  .AND. !Empty(_dnfsdt)
			_netpOS	:= 7 //-Encerramento
			_cacomp	:= "EXPEDICAO  AP.REPARO "+AllTrim(_cnfsnr)+" FINALIZADO"
		ElseIf _cstaAB7 $ "5/2/0" .AND. _cstaZZ4 = "9"  .AND. Empty(_dnfsdt)
			_netpOS	:= 7 //-Encerramento
			_cacomp	:= "EXPEDICAO  AP.REPARO NF: "+AllTrim(_cnfsnr)+" GERADA"
		Else
			_netpOS	:= 5 //5- Em Reparo
			_cacomp	:= "Em Reparo"
		EndIf
	ElseIf !Empty(_cstaZZ4)
		If _cstaZZ4 $ "6/7"
			_cacomp	:= "PROCESSO DE SAIDA LABORATORIO"
			_netpOS	:= 6
		ElseIf _cstaZZ4 = "8"
			_cacomp	:= "EM EXPEDICAO"
			_netpOS	:= 7
		ElseIf _cstaZZ4 = "9" .AND. Empty(_dnfsdt)
			_cacomp	:= "NF REPARO N. "+AllTrim(_cnfsnr)+" GERADA"
			_netpOS	:= 7
		ElseIf _cstaZZ4 = "9" .AND. !Empty(_cimeswp)
			_cnfswap	=" " //desenvolver funcao para buscar a n do imei de swap
			//If SE ACHAR NF DE SWAP E NAO TEM SAIDA DA DOCA :
			_cacomp	:= "NF AP.TROCA N. "+cnfswap+" GERADA"
			//ElseIf SE ACHAR A NF SE SWAP E TEM SAIDA DA DOCA :
			// _cacomp := "EXPEDICAO DO AP.TROCA N. "+cnfswap+" FINALIZADA"
			//EndIf
			_netpOS	:= 7
		ElseIf _cstaZZ4 = "9"  .AND. !Empty(_dnfsdt)
			_cacomp	:= "EXPEDICAO  AP.REPARO "+AllTrim(_cnfsnr)+" FINALIZADO"
			_netpOS	:= 7
		EndIf
	EndIf
	If ZZ8->(dbSeek(TRB->ZZ4_FILIAL+_ccimei+ _COSGVS+_ccodpro))
		_laltZZ8	:= .T.
		_cidsint	:= ZZ8->ZZ8_IDSINT
		_cstsint	:= ZZ8->ZZ8_STASYM
		_ciddefe	:= ZZ8->ZZ8_IDFALH
		_cstadef	:= ZZ8->ZZ8_STAFAU
		_cidpeca	:= ZZ8->ZZ8_IDPECA
		_cstpeca	:= ZZ8->ZZ8_STAPEC
		_cidexpe	:= ZZ8->ZZ8_IDEXPE
		_cidacom	:= ZZ8->ZZ8_IDACOM
		_cidcomp	:= ZZ8->ZZ8_IDNFCO
		_cstcomp	:= ZZ8->ZZ8_STAPUR
		_cidcli		:= ZZ8->ZZ8_IDCLIE
		_cstcli		:= ZZ8->ZZ8_STACLI
//		_cstexpe	:= ZZ8->ZZ8_STADEL
		_cstacom	:= ZZ8->ZZ8_STACOM
		_cidOS		:= ZZ8->ZZ8_IDOS
		_cseqosnew	:= VAL(SubSTR(_cidOS,17,3))+1
		_cidOS		:= _ccnumos + _clotirl + StrZero(_cseqosnew,3)
	Else
		_cidsint	:= ""
		_cstsint	:= ""
		_ciddefe	:= ""
		_cstadef	:= ""
		_cidpeca	:= ""
		_cstpeca	:= ""
		_cidexpe	:= ""
		_cidacom	:= ""
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDados da compra, somente quando For inclusใo.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cnfcomp	:= AllTrim(TRB->ZA_NFCOMPR)
	_cidcomp	:= Iif(_laltZZ8 .AND. !Empty(_cidcomp),AllTrim(_cidcomp),AllTrim(_cnfcomp)+AllTrim(_clotirl))
	_cstcomp	:= Iif(_laltZZ8 .AND. !Empty(_cidcomp), _cstcomp,"0")
	_dtnfcom	:= TRB->ZA_DTNFCOM
	_nvlrcom	:= TRB->ZA_VALNFCO
	_cnomrev	:= AllTrim(TRB->ZA_NOMEREV)
	_cnomrev	:= Iif(!Empty(_cnomrev),U_TiraAcento(_cnomrev),_cnomrev)
	_cnpjrev	:= ""  //Nao e obrigatorio
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDados do cliente, somente quando For inclusao, as  ณ
	//ณinformacoes serao extraidas no envio ao Webservice.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cidcli		:= Iif(_laltZZ8 .AND. !Empty(_cidcli),AllTrim(_cidcli),_ccodcli+_cclojcl+_clotirl)
	_cstcli		:= Iif(_laltZZ8 .AND. !Empty(_cidcli), _cstcli,"0")
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona no arquivo de Apontamento de fases.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("ZZ3")
	If ZZ3->(dbSeek(TRB->ZZ4_FILIAL+_ccimei+LEFT(TRB->ZZ4_OS,6)))
		_lfase	:= .T.
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPreenche dados da OS.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		While !ZZ3->(Eof()) .AND. ZZ3->ZZ3_IMEI=_ccimei .AND. LEFT(ZZ3->ZZ3_NUMOS,6)=LEFT(TRB->ZZ4_OS,6)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPosiciona no arquivo de apontamento de sintoma,ณ
			//ณfalhas,pecas,solucใo.                          ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_cseqZZ3	:= ZZ3->ZZ3_SEQ
			_ctecZZ3	:= ZZ3->ZZ3_CODTEC
			_cOSZZ3		:= AllTrim(ZZ3->ZZ3_NUMOS)+space(8-Len(AllTrim(ZZ3->ZZ3_NUMOS)))
			SZ9->(dbSetOrder(1)) // Z9_FILIAL, Z9_NUMOS, Z9_CODTEC, Z9_SEQ, Z9_ITEM
			If _lfase .AND. SZ9->(dbSeek(xFilial("SZ9") + _cOSZZ3 + _ctecZZ3 + _cseqZZ3))
				Iif(_laltZZ8,_laltSZ9 :=.T.,_laltSZ9:=.F.)
				_cidsint	:= Iif(!Empty(_cidsint),_cidsint,AllTrim(SZ9->Z9_NUMOS)+AllTrim(SZ9->Z9_SEQ)+AllTrim(SZ9->Z9_ITEM))
				_ciddefe	:= Iif(!Empty(_ciddefe),_ciddefe,AllTrim(SZ9->Z9_NUMOS)+AllTrim(SZ9->Z9_SEQ)+AllTrim(SZ9->Z9_ITEM))
				_cidpeca	:= Iif(!Empty(_cidpeca),_cidpeca,AllTrim(SZ9->Z9_NUMOS)+AllTrim(SZ9->Z9_SEQ)+AllTrim(SZ9->Z9_ITEM))
			EndIf
			If !_cfasatu==ZZ3->ZZ3_FASE1
				_cfasatu	:= ZZ3->ZZ3_FASE1
			EndIf
			_cencos		:= ZZ3->ZZ3_ENCOS
			_cstaZZ3	:= ZZ3->ZZ3_STATUS
			_ddtfatu	:= ZZ3->ZZ3_DATA
			_chrfatu	:= ZZ3->ZZ3_HORA
			If _cencos = "S"
				_ddtrepa	:= Iif(_cencos="S",ZZ3->ZZ3_DATA,_ddtrepa)
				_dhrrepa	:= Iif(_cencos="S",ZZ3->ZZ3_HORA,_chrrepa)
				_ddtinsf	:= Iif(_cencos="S",ZZ3->ZZ3_DATA,_ddtinsf)
				_chrinsf	:= Iif(_cencos="S",ZZ3->ZZ3_HORA,_chrinsf)
			EndIf
			_claudo		:= ZZ3->ZZ3_LAUDO
			_cobsrep	:= AllTrim(TABELA("Z8", _claudo, .F.))
			_cstosgvs	:= Posicione("ZZ1",3,xFilial("ZZ1")+_cfasatu+"1","ZZ1_SOSGVS")
			_ccodgnog	:= Iif(Empty(ZZ3->ZZ3_FGONGO),"000001",ZZ3->ZZ3_FGONGO)
			ZZ3->(dbSkip())
		EndDo
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz uma verificacao entre a etapa da OS e os c๓digosณ
	//ณdas Etapas.                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _netpOS=5 .AND.!_cstosgvs $ "14/2/30/71/72"
		_cstosgvs	:= "2"
	ElseIf _netpOS=6 .AND. !_cstosgvs $ "15/18/19/24/25/5/6/95"
		_cstosgvs	:= "5"
	ElseIf _netpOS=7 .AND. !_cstosgvs $ "10/12/13/20/7/81/82/83/84/85/86/87" .AND.!Empty(_dnfsdt)
		_cstosgvs	:= "86"
	ElseIf _netpOS=7 .AND. !_cstosgvs $ "10/12/13/20/7/81/82/83/84/85/86/87" .AND.Empty(_dnfsdt)
		_cstosgvs	:= "87"
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChave para busca do sintoma quando houver.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cidsint	:= VERSINT(_cidsint)
	_cstsint	:= Iif(_laltZZ8,Iif(_laltsin,"2",_cstsint),Iif(_laltsin,"0",_cstsint))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChave para busca de falhas quando houver.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//_cgonogo :=Posicione("SX5",1,xFilial("SX5")+"ZR"+_ccodgnog,"X5_DESCRI")
	_cgonogo	:= Iif(Empty(_cgonogo),"sem falha",_cgonogo)
	_ciddefe	:= VERDEFE(_ciddefe)
	_cstadef	:= Iif(_laltZZ8,Iif(_laltdef,"2",_cstadef),Iif(_laltdef,"0",_cstadef))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChave para busca de Pecas quando houver.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cidpeca	:= VERPECA(_cidpeca)
	_cstpeca	:= Iif(_laltZZ8,Iif(_laltpec,"2",_cstpeca),Iif(_laltpec,"0",_cstpeca))
/*
	If Empty(_cidexpe)
		_cnfshr		:= Iif(!Empty(_dnfsdt),TRB->ZZ4_DOCHRS,"")
		_cidexpe	:= Iif(!Empty(_dnfsdt),AllTrim(_cnfsnr)+AllTrim(_cnfser)+AllTrim(_clotirl)+"01","")
		_cstexpe	:= Iif(!Empty(_dnfsdt),"0","2")
		_cateent	:= Iif(!Empty(_dnfsdt),"EXPED. BGH","") //Iif(Empty(TRB->ZZ4_DOCDTS),"","EXPEDICAO BGH")
		_nitmnf		:= Iif(!Empty(_dnfsdt),veritnf(_cfilial,TRB->ZZ4_PV,_cnfser,AllTrim(_cnfsnr),_ccodcli,_cclojcl,_ccimei),0)
		_nitotnf	:= Iif(!Empty(_dnfsdt),vtotinf(_cfilial,TRB->ZZ4_PV,_cnfser,AllTrim(_cnfsnr),_cclojcl,_cclojcl,_ccimei),0)
		_cawb		:= Iif(!Empty(_dnfsdt),GetAwb(_cnfsnr, _cnfser),"")
	Else
		If _laltZZ8
			_cnfsant	:= AllTrim(Posicione("ZZ8",3,xFilial("ZZ8")+_ccimei+ _COSGVS+_ccodpro,"ZZ8_NFSAID"))
			_ddtexan	:= Posicione("ZZ8",3,xFilial("ZZ8")+_ccimei+ _COSGVS+_ccodpro,"ZZ8_DTEXPE")
			_nSEQant	:= val(right(AllTrim(_cidexpe),3))+1
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณHudson de Souza Santos - corre็ใo.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_cidexpe	:= Iif(_cnfsant=AllTrim(_cnfsnr),_cidexpe,AllTrim(_cnfsnr)+AllTrim(_cnfser)+AllTrim(_clotirl)+StrZero(_nSEQant,2))
			_cnfshr		:= Iif(_cnfsant=AllTrim(_cnfsnr),AllTrim(Posicione("ZZ8",3,xFilial("ZZ8")+_ccimei+ _COSGVS+_ccodpro,"ZZ8_HREXPE")),TRB->ZZ4_DOCHRS)
			_cstexpe	:= Iif(_cnfsant=AllTrim(_cnfsnr) .AND._ddtexan=TRB->ZZ4_DOCDTS,_cstexpe,"2")
			_cateent	:= Iif(_cnfsant=AllTrim(_cnfsnr),"","EXPED. BGH") //Iif(Empty(TRB->ZZ4_DOCDTS),"","EXPEDICAO BGH")
			_nitmnf		:= veritnf(_cfilial,TRB->ZZ4_PV,_cnfser,_cnfsnr,_ccodcli,_cclojcl,_ccimei)
			_nitotnf	:= vtotinf(_cfilial,TRB->ZZ4_PV,_cnfser,_cnfsnr,_ccodcli,_cclojcl,_ccimei)
			_cawb		:= GetAwb(_cnfsnr, _cnfser)
		Else
			_cnfsant	:= ""
			_nSEQant	:= val(right(AllTrim(_cidexpe),3))+1
			_cnfsnr		:= AllTrim(TRB->ZZ4_NFSNR)+(SPACE(9)-Len(AllTrim(TRB->ZZ4_NFSNR)))
			_cidexpe	:= Iif(_cnfsant=AllTrim(_cnfsnr),_cidexpe,AllTrim(_cnfsnr)+AllTrim(_cnfser)+AllTrim(_clotirl)+StrZero(_nSEQant,2))
			_cstexpe	:= Iif(_cnfsant=AllTrim(_cnfsnr) .AND. Empty(TRB->ZZ4_DOCDTS),_cstexpe,"2")
			_cnfshr		:= Iif(_cnfsant=AllTrim(_cnfsnr),AllTrim(Posicione("ZZ8",3,xFilial("ZZ8")+_ccimei+ _COSGVS+_ccodpro,"ZZ8_HREXPE")),TRB->ZZ4_DOCHRS)
			_cateent	:= "EXPED. BGH" //Iif(Empty(TRB->ZZ4_DOCDTS),"","EXPEDICAO BGH")
			_nitmnf		:= veritnf(_cfilial,TRB->ZZ4_PV,_cnfser,_cnfsnr,_ccodcli,_cclojcl,_ccimei)
			_nitotnf	:= vtotinf(_cfilial,TRB->ZZ4_PV,_cnfser,_cnfsnr,_ccodcli,_cclojcl,_ccimei)
			_cawb		:= GetAwb(_cnfsnr, _cnfser)
		EndIf
	EndIf
*/
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDados do Acompanhamento.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(_cidacom)
		_cidacom	:= Iif(!Empty(_cacomp),_ccnumos+_clotirl+_cstaZZ4+StrZero(1,3),"")
		_cstacom	:= Iif(!Empty(_cacomp),"0","1")
		_dtacom		:= ddatabase
		_cseqaco	:= 001
		_cacomp		:= Iif(!Empty(_cacomp),_cacomp,"")
		_cusacom	:= "BGH-WEBSERVICE"
	Else
		If _laltZZ8
			_cacoant	:= Posicione("ZZ8",3,xFilial("ZZ8")+_ccimei+ _COSGVS+_ccodpro,"ZZ8_ACOMPA")
			_nSEQant	:= val(right(AllTrim(_cidacom),3))
			_cidacom	:= Iif(!Empty(_cacomp),Iif(AllTrim(_cacomp)=AllTrim(_cacoant),_cidacom ,_ccnumos+_clotirl+_cstaZZ4+StrZero(_nSEQant+1,2)),_ccnumos+_clotirl+_cstaZZ4+StrZero(_nSEQant+1,2))
			_cstacom	:= Iif(!Empty(_cacomp),Iif(AllTrim(_cacomp)=AllTrim(_cacoant),"1","0"),"1")
			_dtacom		:= ddatabase
			_cseqaco	:= 001
			_cacomp		:= Iif(!Empty(_cacomp),Iif(AllTrim(_cacomp)<>AllTrim(_cacoant),_cacomp,_cacoant),_cacomp)
			_cusacom	:= "BGH-WEBSERVICE"
		Else
			_cacoant	:= ""
			_cidacom	:= _ccnumos+_clotirl+_cstaZZ4+STR(1,3)
			_cstacom	:= Iif(!Empty(_cacomp),"1","0")
			_dtacom		:= ddatabase
			_cseqaco	:= 001
			_cacomp		:= _cacomp
			_cusacom	:= "BGH-WEBSERVICE"
		EndIf
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValidacoes.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤู
	If _ddtosgv < _dtnfcom
		_dtnfcom	:= _ddtosgv
	EndIf
	If _ddtosgv > _ddtprev
		_ddtprev	:= _ddtosgv
	EndIf
	If _ddtosgv > _ddtfatu
		_ddtfatu	:= _ddtosgv
	EndIf
	If _ddtinst > _ddtosgv
		_ddtinst	:= _ddtosgv
	EndIf
	If !Empty(_ddtrepa) .AND. _ddtrepa < _ddtosgv
		_ddtrepa := _ddtosgv
	EndIf
	If _ddtinst >_ddtrepa
		_ddtinst	:= _ddtrepa
	EndIf
	If _ddtrepa > _ddtinsf
		_ddtinsf	:= _ddtrepa
	EndIf
	If _laltZZ8
		nRegE++ // contando alteracoes
		aAdd(aaltZZ8,{_cfilial,_ccodpos,_cgvsos,_ccodpro,_ccimei,_cdpyrep, _codAT, _cmarca,_ddtosgv,_chrosgv,;    //10
		_cnomeop, _cnumcel,_ccodcob,_clocate,_ccproce,_cdtfabr, _codtpse, _cnomate,_cnfentr,;   //19
		_drecpro,_chrrecp,_ddtprev,_cacess,_cnomrev,_cnpjrev,_cnfcomp,_dtnfcom,_nvlrcom,_cdefcon,; //29
		_cestap,_ddtinst,_csofrev,_ddtrepa,_chrrepa,_cobsrep,_netpOS,_cstosgvs,_ddtfatu,_chrfatu,; //39
		_cprodup,_cimeswp,_cdpyimn,_cctroca,_cdefcon,_csintom,_ddtinsf,_chrinsf,_nseqSZ9,_codsint,_coddefe,; //50
		_codsolu,_codgrso,_codsint,_cmotdef,_cnivrep,_cgonogo,_nitmSZ9,_codgrso,_cpeca,_nqtypc,_cpospec,_cprecor,;//62
		_dnfsdt,_cnfshr,_cateent,_cnfsnr,_nitmnf,_nitotnf,_cawb,_dtacom,_cseqaco,_cacomp,_cusacom,; //73
		_cidOS,_cidcli,_cidcomp, _ciddefe,_cidsint,_cidpeca,_cidacom,_cidexpe,_cstcomp,_cstcli,_cstsint,_cstadef,_cstpeca,_cstexpe,_cstacom})//88
	Else
		_lincZZ8  :=.T.
		nRegI++ // contando inclusoes
		aAdd(aIncZZ8,{_cfilial,_ccodpos,_cgvsos,_ccodpro,_ccimei,_cdpyrep, _codAT, _cmarca,_ddtosgv,_chrosgv,;
		_cnomeop, _cnumcel,_ccodcob,_clocate,_ccproce,_cdtfabr, _codtpse, _cnomate,_cnfentr,;
		_drecpro,_chrrecp,_ddtprev,_cacess,_cnomrev,_cnpjrev,_cnfcomp,_dtnfcom,_nvlrcom,_cdefcon,;
		_cestap,_ddtinst,_csofrev,_ddtrepa,_chrrepa,_cobsrep,_netpOS,_cstosgvs,_ddtfatu,_chrfatu,;
		_cprodup,_cimeswp,_cdpyimn,_cctroca,_cdefcon,_csintom,_ddtinsf,_chrinsf,_nseqSZ9,_codsint,_coddefe,;
		_codsolu,_codgrso,_codsint,_cmotdef,_cnivrep,_cgonogo,_nitmSZ9,_codgrso,_cpeca,_nqtypc,_cpospec,_cprecor,;
		_dnfsdt,_cnfshr,_cateent,_cnfsnr,_nitmnf,_nitotnf,_cawb,_dtacom,_cseqaco,_cacomp,_cusacom,;
		_cidOS,_cidcli,_cidcomp, _ciddefe,_cidsint,_cidpeca,_cidacom,_cidexpe,_cstcomp,_cstcli,_cstsint,_cstadef,_cstpeca,_cstexpe,_cstacom})
	EndIf
	_laltZZ8 := .F.
	TRB->(dbSkip())
EndDo
_laltZZ8 := Iif(Len(aaltZZ8) > 0,.T.,.F.)
*
//ConOut("   [INTWGVS] ["+DTOC(Date())+"-"+Time()+"] Finalizando processamentos ZZ4/SZA...")
//ConOut("   [INTWGVS] ["+DTOC(Date())+"-"+Time()+"] Chamando U_ATUZZ8()...")
U_ATUZZ8(_lincZZ8,_laltZZ8)
//ConOut("   [INTWGVS] ["+DTOC(Date())+"-"+Time()+"] FINALIZANDO PROCESSO INTWGVS/U_ATUZZ8()...[X]")
//ConOut("   [INTWGVS] ["+DTOC(Date())+"-"+Time()+"] FECHANDO PROCESSO: "+DTOC(DATE())+" "+TIME())
//ConOut(Replicate("*",40))
//ConOut("*")
//ConOut("*")
//ConOut("*")
*
//RESET ENVIRONMENT
Return(_lret)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณveritnf   บ Autor ณ Edson Rodrigues    บ Data ณ  15/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que o numero do item da nota de saida               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function veritnf(_cfil,_cpv,_cser,_cnf,_ccodc,_cljc,_cimei)
_nitem :=0
dbSelectArea("SD2")
If SD2->(dbSeek(_cfil+_cpv+_cser+_cnf+_ccodc+_cljc))
	While !SD2->(Eof()) .AND. SD2->D2_FILIAL=_cfil .AND. SD2->D2_SERIE=_cser .AND. SD2->D2_DOC=_cnf .AND. SD2->D2_CLIENTE=_ccodc .AND. SD2->D2_LOJA=_cljc
		If AllTrim(SD2->D2_NUMSER)=AllTrim(_cimei)
			_nitem:=val(SD2->D2_ITEM)
		EndIf
		SD2->(dbSkip())
	EndDo
EndIf
Return(_nitem)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณvtotinf   บ Autor ณ Edson Rodrigues    บ Data ณ  15/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao retorna a qtdade total de itens na nota de saida    |ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function vtotinf(_cfil,_cpv,_cser,_cnf,_ccodc,_cljc,_cimei)
_nitotit := 0
dbSelectArea("SD2")
If SD2->(dbSeek(_cfil+_cpv+_cser+_cnf+_ccodc+_cljc))
	While !SD2->(Eof()) .AND. SD2->D2_FILIAL=_cfil .AND. SD2->D2_SERIE=_cser .AND. SD2->D2_DOC=_cnf .AND. SD2->D2_CLIENTE=_ccodc .AND. SD2->D2_LOJA=_cljc
		nitotit++
		SD2->(dbSkip())
	EndDo
EndIf
Return(_nitotit)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณveroper   บ Autor ณ Edson Rodrigues    บ Data ณ  15/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao retorna a o nome correto da operadora               |ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VEROPER(_cOper)
Local _aOpera		:={}
Local _cNewOpera	:= ""
Local nX			:= 0
Local nPosOper		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCadastro dos tipos aceitos 24/08/2015ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(_aOpera,{"AMAZONIA",	"Amazonia"			})
aAdd(_aOpera,{"BRASIL",		"Brasil telecom"	})
aAdd(_aOpera,{"TELECOM",	"Brasil telecom"	})
aAdd(_aOpera,{"CLARO",		"Claro"				})
aAdd(_aOpera,{"CTBC",		"Ctbc"				})
aAdd(_aOpera,{"OI",			"Oi"				})
aAdd(_aOpera,{"SERCOMTEL",	"Sercomtel"			})
aAdd(_aOpera,{"TELEMIG",	"Telemig"			})
aAdd(_aOpera,{"TIM",		"Tim"				})
aAdd(_aOpera,{"VIVO",		"Vivo"				})
aAdd(_aOpera,{"GENERICO",	"Generico"			})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca posi็ใo Tirando acentos e deixando mai๚sculaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nPosOper := Ascan(_aOpera,{|x|x[1]==Alltrim(Upper(FwNoAccent(_cOper)))})   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso nใo encontre nenhuma assume Gen้rico (11) vide cadastro acimaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cNewOpera := _aOpera[Iif(nPosOper>0,nPosOper,11),2]

Return(_cNewOpera)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณverloca   บ Autor ณ Edson Rodrigues    บ Data ณ  15/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao retorna a o nome correto do Local de Atendimento    |ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function verloca(_cloca)
Local _agrlocat :={}
Local _cnewloca :=""
Local nx := 0
Aadd(_agrlocat,{"Interno","Interno","Externo","Externo","Estoque","Estoque","Posto Coleta","PC","Corporativo","Corp","Call Center","CallCenter","MRC","MRC","DOC","DOC"})
For x:=1 to Len(_agrlocat[1])
	If UPPER(_agrlocat[1,x])=UPPER(_cloca)
		nx :=x+ 1
		_cnewloca:=_agrlocat[1,nx]
	EndIf
Next
If Empty(_cnewloca)
	_cnewloca:=_cloca
EndIf
Return(_cnewloca)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณvercproc  บ Autor ณ Edson Rodrigues    บ Data ณ  15/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao retorna a o nome correto do Codigo de Procedencia   |ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function vercproc(_cproc)
Local _agrcproc :={}
Local _cnewproc :=""
Local nx:= 0
Aadd(_agrcproc,{"Consumidor","Consumidor","Lojista","Lojista","Operadora","Operadora","Estoque de loja","Estloja","Posto de coleta","PC","Troca","Troca"})
For x:=1 to Len(_agrcproc[1])
	If UPPER(_agrcproc[1,x])=UPPER(_cproc)
		nx:=x+1
		_cnewproc:=_agrcproc[1,nx]
	EndIf
Next
If Empty(_cnewproc)
	_cnewproc:=_cproc
EndIf
Return(_cnewproc)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณvertpser  บ Autor ณ Edson Rodrigues    บ Data ณ  15/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao retorna a o tipo de Servico correto                 |ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function vertpser(_cCODTPSE)
/*
Local _agrtpser :={}
Local _cnewtpse :=""
Local nx := 0
Aadd(_agrtpser,{"Garantia se","SEG","Reingresso garantia","SEGR","Doa Cliente","SEDOAC","Doa Lote","SEDOAL","Nao DOA","SEDOAN"})
For x:=1 to Len(_agrtpser)
	If UPPER(_agrtpser[1,x])=UPPER(_ctpser)
		nx=x+1
		_cnewtpse:=_agrtpser[1,nx]
	EndIf
Next
If Empty(_cnewtpse)
	_cnewtpse:=_ctpser
EndIf
*/
Local aSerTpCode	:= {}
Local nTpCode		:= 0
Local cTypeCode		:= ""
aAdd(aSerTpCode,{"SEG"	,"GARANTIA SE"			})
aAdd(aSerTpCode,{"EHS"	,"EHS"					})
aAdd(aSerTpCode,{"CESP"	,"CASO ESPECIAL"		})
aAdd(aSerTpCode,{"SESM"	,"ESPECIAL SONY MOBILE"	})
aAdd(aSerTpCode,{"SEFG"	,"EM ORAMENTO"			})
aAdd(aSerTpCode,{"RET"	,"RETENCAO"				})

nTpCode := aScan(aSerTpCode, { |x| Upper(AllTrim(x[1])) == _cCODTPSE})

If nTpCode > 0
	cTypeCode := _cCODTPSE //+ "-" + aSerTpCode[nTpCode,2]
EndIf
Return(cTypeCode)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออหออออออัออออออออปฑฑ
ฑฑบFuncao    ณVERSINT   บ Autor ณ                         บ Data ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออสออออออฯออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VERSINT(cIDSINT)
//dados da codigo do sintoma
_cidsint :=cIDSINT
_nseqSZ9 :=0
_nitmSZ9 :=0
_codsint :=""
_csintom :=""
cQry   := ""
_laltsin:=.F.
If AllTrim(cIDSINT) <> '' .AND. cIDSINT <> NIL
	cQry := "   SELECT Z9_NUMOS,Z9_IMEI, Z9_SYMPTO, Z9_SINTCOD, Z9_SEQ ,Z9_ITEM  "
	cQry += "   FROM "+RETSQLNAME('SZ9')+ " (NOLOCK)   WHERE "
	cQry += "                           Z9_FILIAL = '"+xFilial("SZ9")+"' "
	cQry += "                           AND SubSTRING(Z9_NUMOS,1,6) = '"+AllTrim(SubSTR(cIDSINT,1,6))+"'  "
	cQry += "                           AND Z9_MSEXP =''    "
	cQry += "                           AND Z9_SEQ ='"+SubSTR(cIDSINT,7,2)+"'  "
	cQry += "                           AND Z9_ITEM='"+SubSTR(cIDSINT,9,2)+"'  "
	cQry += "                           AND Z9_SYMPTO <> ''  "
	cQry += "                           AND D_E_L_E_T_ <> '*'  "
	cQry += "   GROUP BY Z9_NUMOS,Z9_IMEI, Z9_SYMPTO, Z9_SINTCOD, Z9_SEQ , Z9_ITEM "
	//MEMOWRIT("c:\a\RSOAM01-sym.SQL",cQry)
	//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TSYM", .F., .T.)
	TCQUERY cQry NEW ALIAS "TSYM"
	dbSelectArea("TSYM")
	dbgotop()
	While !Eof()
		_laltsin := .T.
		_cidsint := TSYM->(SubSTR(Z9_NUMOS,1,6)+AllTrim(Z9_SEQ)+AllTrim(Z9_ITEM)+AllTrim(Z9_SINTCOD))
		_nseqSZ9 := VAL(TSYM->Z9_SEQ)
		_nitmSZ9 := TSYM->Z9_ITEM
		_csintom :=	Iif(!Empty(TSYM->Z9_SYMPTO),TSYM->Z9_SINTCOD,"")
		_codsint := TSYM->Z9_SINTCOD
		dbSkip()
	EndDo
	dbSelectArea("TSYM")
	TSYM->(DBCLOSEArea())
EndIf
Return(_cidsint)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออหออออออัออออออออปฑฑ
ฑฑบFuncao    ณGetQtItNf บ Autor ณHudson de Souza Santos   บ Data ณ23/07/15บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออสออออออฯออออออออนฑฑ
ฑฑบDescricao ณBusca a quantidade de itens na NF de Saida.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico BGH.                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetQtItNf(cFil, cDoc, cSer, cCli, cLoj)
Local nQtItNf	:= 0
Local cQry		:= ""

cQry += "SELECT "
cQry += "	D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, Count(*) AS QUANT "
cQry += "FROM	SD2020(NOLOCK) "
cQry += "WHERE	D_E_L_E_T_ = '' "
cQry += "		AND D2_FILIAL	= '" + cFil + "' "
cQry += "		AND D2_DOC		= '" + cDoc + "' "
cQry += "		AND D2_SERIE	= '" + cSer + "' "
cQry += "		AND D2_CLIENTE	= '" + cCli + "' "
cQry += "		AND D2_LOJA		= '" + cLoj + "' "
cQry += "GROUP BY "
cQry += "	D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA"

If Select("QTDITNF") <> 0 
	dbSelectArea("QTDITNF")
	dbCloseArea()
Endif
TCQUERY cQry NEW ALIAS "QTDITNF"  
If !(QTDITNF->(Eof()))
	nQtItNf := QTDITNF->QUANT
EndIf
dbSelectArea("QTDITNF")
dbCloseArea()
Return nQtItNf
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออหออออออัออออออออปฑฑ
ฑฑบFuncao    ณGetAwb    บ Autor ณHudson de Souza Santos   บ Data ณ03/07/15บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออสออออออฯออออออออนฑฑ
ฑฑบDescricao ณBusca o AWB baseado na tabela Z03.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico BGH.                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetAwb(cNF, cSer)
Local cAwb := ""
cNF		:= Iif(cNF  == Nil,"", AvKey(cNF , "Z03_DOC"  ))
cSer	:= Iif(cSer == Nil,"", AvKey(cSer, "Z03_SERIE"))
If !Empty(cNF) .AND. !Empty(cSer)
	Z03->(dbGoTop())
	If Z03->(dbSeek(xFilial("Z03")+cNF+cSer))
		While xFilial("Z03") == Z03->Z03_FILIAL .AND. cNF == Z03->Z03_DOC .AND. cSer == Z03->Z03_SERIE
			If Z03->Z03_CANCEL <> "S" .AND. !Empty(Z03->Z03_CRPOST)
				cAwb := Z03->Z03_OBJETO
			EndIf
			Z03->(dbSkip())
		EndDo
	EndIf
EndIf
Return(cAwb)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออหออออออัออออออออปฑฑ
ฑฑบFuncao    ณGetNFSwp  บ Autor ณHudson de Souza Santos   บ Data ณ13/07/15บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออสออออออฯออออออออนฑฑ
ฑฑบDescricao ณBusca info da NF na tabela Z03 baseado no PV.               บฑฑ
ฑฑฬออออออออออุออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ 01 ณ N๚mero da NF                                          บฑฑ
ฑฑบde        ณ 02 ณ Serie NF                                              บฑฑ
ฑฑบDevolu็ใo ณ 03 ณ Identifica็ใo sequencial                              บฑฑ
ฑฑบ          ณ 04 ณ Data de expedi็ใo do produto                          บฑฑ
ฑฑบ          ณ 05 ณ Atendente da entrega                                  บฑฑ
ฑฑบ          ณ 06 ณ N๚mero do Item da NF                                  บฑฑ
ฑฑบ          ณ 07 ณ Total de Itens na NF                                  บฑฑ
ฑฑบ          ณ 08 ณ AWB de Saํda                                          บฑฑ
ฑฑบ          ณ 09 ณ Hora da NF                                            บฑฑ
ฑฑฬออออออออออุออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico BGH.                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetNFSwp(cImeiSW)
Local aArea	:= GetArea()
Local aAreaSD2	:= GetArea()
Local aRet	:= {}
cImeiSW := AvKey(cImeiSW, "ZZ4_IMEI")
SC6->(dbGoTop())
SC6->(dbSeek(xFilial("SC6")+cImeiSW))
While !(SC6->(Eof())) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_IMEINOV == cImeiSW
	SA1->(dbGoTop())
	If SA1->(dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA))
		//Cliente Sony ้ referente ao pedido de devolu็ใo a pr๓pria Sony. O correto deve ser o pedido para cliente referente ao Swap
		If !(SA1->A1_PESSOA == "J" .AND. "SONY" $ SA1->A1_NOME .AND. SubSTR(SA1->A1_CGC,1,8) == "04667337")
			// Coloca SD2 na ordem 3 para buscar Infos da NF pelo Pedido de Venda
			SD2->(dbSetOrder(3))
			SD2->(dbGoTop())
			SD2->(dbSeek(xFilial("SD2")+SC6->C6_NOTA+SC6->C6_SERIE+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO))

			aAdd(aRet,SD2->D2_DOC																					)
			aAdd(aRet,SD2->D2_SERIE																					)
			aAdd(aRet,AllTrim(SD2->D2_DOC)+AllTrim(SD2->D2_SERIE)+AllTrim(_clotirl)+"01"							)
			aAdd(aRet,Iif((Empty(SC6->C6_NOTA) .OR. Empty(SD2->D2_EMISSAO)),CTOD("  /  /  "),SD2->D2_EMISSAO)		)
			aAdd(aRet,UsrRetName(SubStr(Embaralha(SD2->D2_USERLGI,1),3,6))											)
			aAdd(aRet,VAL(SD2->D2_ITEM)																				)
			aAdd(aRet,GetQtItNf(xFilial("SD2"),SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA)			)
			aAdd(aRet,GetAwb(SD2->D2_DOC, SD2->D2_SERIE)															)
			aAdd(aRet,"00:00:00"																					)

			//Retorna SD2 para Order original
			SD2->(dbSetOrder(7))
			SD2->(dbGoTop())
			Exit
	    EndIf
    EndIf
	SC6->(dbSkip())
EndDo
RestArea(aAreaSD2)
RestArea(aArea)
Return(aRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออหออออออัออออออออปฑฑ
ฑฑบFuncao    ณVERDEFE   บ Autor ณ                         บ Data ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออสออออออฯออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VERDEFE(_ciddefe)
//dados do defeito x solucao
_cidfalh :=_ciddefe
_nseqSZ9 :=0
_codsolu :=""
_coddefe :=""
_codgrso :=""
_cmotdef :=""
_cnivrep :=""
_laltdef :=.f.
cQry   := ""
If AllTrim(_cidfalh) <> '' .AND. _cidfalh <> NIL
	cQry := "     SELECT Z9_NUMOS, Z9_IMEI, Z9_FAULID, Z9_ACTION , Z9_SEQ,Z9_ITEM, Z9_MOTDEFE, Z9_NIVELRE   "
	cQry += "     FROM "+RETSQLNAME('SZ9')+ " (NOLOCK)  WHERE "
	cQry += "                             Z9_FILIAL = '"+xFilial("SZ9")+"' "
	cQry += "                             AND SubSTRING(Z9_NUMOS,1,6) = '"+SubSTR(_cidfalh,1,6)+"'  "
	cQry += "                             AND Z9_SEQ ='"+SubSTR(_cidfalh,7,2)+"'  "
	cQry += "                             AND Z9_ITEM='"+SubSTR(_cidfalh,9,2)+"'  "
	cQry += "                             AND Z9_MSEXP =''      "
	cQry += "                             AND Z9_FAULID <> ''   "
	cQry += "                             AND D_E_L_E_T_ <> '*'  "
	cQry += "     GROUP BY Z9_NUMOS, Z9_IMEI, Z9_FAULID, Z9_ACTION ,Z9_SEQ,Z9_ITEM, Z9_MOTDEFE, Z9_NIVELRE  "
	TCQUERY cQry NEW ALIAS "TFAU"
	dbSelectArea("TFAU")
	dbgotop()
	While !Eof()
		_laltdef :=.T.
		_cidfalh := TFAU->(SubSTR(Z9_NUMOS,1,6)+AllTrim(Z9_SEQ)+AllTrim(Z9_ITEM)+AllTrim(Z9_FAULID))
		_nseqSZ9 := VAL(TFAU->Z9_SEQ)
		_codsolu := Iif(!Empty(TFAU->Z9_ACTION),TFAU->Z9_ACTION,"")
		_coddefe := Iif(!Empty(TFAU->Z9_FAULID),TFAU->Z9_FAULID,"")
		_codgrso :="NC"
		_cmotdef :=Iif(!Empty(TFAU->Z9_MOTDEFE),TFAU->Z9_MOTDEFE,"")
		_cnivrep :=Iif(!Empty(TFAU->Z9_NIVELRE),TFAU->Z9_NIVELRE,"")
		dbSkip()
	EndDo
	dbSelectArea("TFAU")
	TFAU->(DBCLOSEArea())
EndIf
Return(_cidfalh)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออหออออออัออออออออปฑฑ
ฑฑบFuncao    ณVERPECA   บ Autor ณ                         บ Data ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออสออออออฯออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VERPECA(_cidpeca)
//dados das pecas
_cidpeca :=_cidpeca
_cpeca   :=""
_nqtypc  :=0
_cpospec :=""
_cprecor :=""
_laltpec :=.f.
cQry   := ""
If AllTrim(_cidpeca) <> '' .AND. _cidpeca <> NIL
	cQry := "     SELECT Z9_NUMOS, Z9_IMEI, Z9_PARTNR,Z9_SEQ,Z9_ITEM,Z9_POSESQU,Z9_PREVCOR,SUM(Z9_QTY) AS Z9_QTY   "
	cQry += "     FROM "+RETSQLNAME('SZ9')+ " (NOLOCK)  WHERE "
	cQry += "                             Z9_FILIAL = '"+xFilial("SZ9")+"' "
	cQry += "                             AND SubSTRING(Z9_NUMOS,1,6) = '"+SubSTR(_cidpeca,1,6)+"'  "
	cQry += "                             AND Z9_SEQ ='"+SubSTR(_cidpeca,7,2)+"'  "
	cQry += "                             AND Z9_ITEM='"+SubSTR(_cidpeca,9,2)+"'  "
	cQry += "                             AND Z9_MSEXP =''      "
	cQry += "                             AND Z9_PARTNR <> ''   "
	cQry += "                             AND D_E_L_E_T_ <> '*'  "
	cQry += "     GROUP BY Z9_NUMOS, Z9_IMEI,Z9_PARTNR,Z9_SEQ,Z9_ITEM,Z9_POSESQU,Z9_PREVCOR "
	//MEMOWRIT("c:\a\RSOAM01-FAU.SQL",cQry)
	//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TPEC", .F., .T.)
	TCQUERY cQry NEW ALIAS "TPEC"
	dbSelectArea("TPEC")
	dbgotop()
	While !Eof()
		_laltpec :=.T.
		_cidpeca :=TPEC->(SubSTR(Z9_NUMOS,1,6)+AllTrim(Z9_SEQ)+AllTrim(Z9_ITEM))
		_cpeca  :=Iif(!Empty(TPEC->Z9_PARTNR),TPEC->Z9_PARTNR,"")
		_nqtypc :=Iif(!Empty(TPEC->Z9_PARTNR),ABS(TPEC->Z9_QTY),0)
		_cpospec:=Iif(!Empty(TPEC->Z9_POSESQU),TPEC->Z9_POSESQU,"12")
		_cprecor:=Iif(!Empty(TPEC->Z9_PREVCOR),TPEC->Z9_PREVCOR,"")
		dbSkip()
	EndDo
	dbSelectArea("TPEC")
	TPEC->(DBCLOSEArea())
EndIf
Return(_cidpeca)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    |  ATUZZ8  บ Autor ณ Edson Rodrigues    บ Data ณ  15/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que grava ou inclui os dados na tab ZZ8             |ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function ATUZZ8(_linc,_lalt)
//ConOut("   [ATUZZ8] ["+DTOC(Date())+"-"+Time()+"] Iniciando...")
//Ajusta modelo do produto
SB1Model()

dbSelectArea("ZZ8")////ZZ8_FILIAL+ZZ8_IMEI+ZZ8_NUMOS+ZZ8_CODPRO
//If _linc .AND. Len(aIncZZ8) > 0
	For n:=1 to Len(aIncZZ8)
		//ConOut("   [ATUZZ8] ["+DTOC(Date())+"-"+Time()+"] INCLUINDO: "+StrZero(n,6))
		_cimei:=SubSTR(aIncZZ8[n,5],1,20)
		_cos  :=SubSTR(aIncZZ8[n,74],1,6)
		Reclock("ZZ8",.T.)
		ZZ8->ZZ8_FILIAL := aIncZZ8[n,1]
		ZZ8->ZZ8_CODPOS := aIncZZ8[n,2]
		ZZ8->ZZ8_NUMOS  := aIncZZ8[n,3]
		ZZ8->ZZ8_OSGVSO := aIncZZ8[n,3]
		ZZ8->ZZ8_CODPRO := aIncZZ8[n,4]
		ZZ8->ZZ8_IMEI   := aIncZZ8[n,5]
		ZZ8->ZZ8_DPYNUM := aIncZZ8[n,6]
		ZZ8->ZZ8_CODAT  := aIncZZ8[n,7]
		ZZ8->ZZ8_MARCA  := aIncZZ8[n,8]
		ZZ8->ZZ8_DTOS   := aIncZZ8[n,9]
		ZZ8->ZZ8_HORAOS := aIncZZ8[n,10]
		ZZ8->ZZ8_OPERAD := aIncZZ8[n,11]
		ZZ8->ZZ8_NUMCEL := aIncZZ8[n,12]
		ZZ8->ZZ8_CODCOB := aIncZZ8[n,13]
		ZZ8->ZZ8_LOCATE := aIncZZ8[n,14]
		ZZ8->ZZ8_PROCPR := aIncZZ8[n,15]
		ZZ8->ZZ8_DTFABR := aIncZZ8[n,16]
		ZZ8->ZZ8_CODSER := aIncZZ8[n,17]
		ZZ8->ZZ8_ATNAME := aIncZZ8[n,18]
		ZZ8->ZZ8_NFENTR := aIncZZ8[n,19]
		ZZ8->ZZ8_DTRECE := aIncZZ8[n,20]
		ZZ8->ZZ8_HRRECE := aIncZZ8[n,21]
		ZZ8->ZZ8_DTPREV := aIncZZ8[n,22]
		ZZ8->ZZ8_ACESSO := aIncZZ8[n,23]
		ZZ8->ZZ8_NOMREV := aIncZZ8[n,24]
		ZZ8->ZZ8_CNPJRE := aIncZZ8[n,25]
		ZZ8->ZZ8_NFCOMP := aIncZZ8[n,26]
		ZZ8->ZZ8_DTNFCO := aIncZZ8[n,27]
		ZZ8->ZZ8_VLRNFC := aIncZZ8[n,28]
		ZZ8->ZZ8_DEFCON := aIncZZ8[n,29]
		ZZ8->ZZ8_ESTAPA := aIncZZ8[n,30]
		ZZ8->ZZ8_DTAVAL := aIncZZ8[n,31]
		ZZ8->ZZ8_SFTREV := aIncZZ8[n,32]
		ZZ8->ZZ8_DTREPA := aIncZZ8[n,33]
		ZZ8->ZZ8_HRREPA := aIncZZ8[n,34]
		ZZ8->ZZ8_OBSREP := aIncZZ8[n,35]
		ZZ8->ZZ8_ETAPOS := StrZero(aIncZZ8[n,36],1)
		ZZ8->ZZ8_CODSOS := aIncZZ8[n,37]
		ZZ8->ZZ8_DTSTOS := aIncZZ8[n,38]
		ZZ8->ZZ8_HRETOS := aIncZZ8[n,39]
		ZZ8->ZZ8_CODMNV := aIncZZ8[n,40]
		ZZ8->ZZ8_IMEINV := aIncZZ8[n,41]
		ZZ8->ZZ8_DPYIMN := aIncZZ8[n,42]
		ZZ8->ZZ8_CTROCA := aIncZZ8[n,43]
		ZZ8->ZZ8_DEFREC := aIncZZ8[n,44]
		ZZ8->ZZ8_SINTAV := aIncZZ8[n,45]
		ZZ8->ZZ8_DTINSF := aIncZZ8[n,46]
		ZZ8->ZZ8_HRINSV := aIncZZ8[n,47]
		ZZ8->ZZ8_SEQSIN := aIncZZ8[n,48]
		ZZ8->ZZ8_SINTCO := aIncZZ8[n,49]
		ZZ8->ZZ8_CODDEF := aIncZZ8[n,50]
		ZZ8->ZZ8_CODSOL := aIncZZ8[n,51]
		ZZ8->ZZ8_CGRPSO := aIncZZ8[n,52]
		ZZ8->ZZ8_SINREC := aIncZZ8[n,53]
		ZZ8->ZZ8_MOTDEV := aIncZZ8[n,54]
		ZZ8->ZZ8_NIVREP := aIncZZ8[n,55]
		ZZ8->ZZ8_FGONGO := aIncZZ8[n,56]
		ZZ8->ZZ8_SEQPEC := Iif(ValType(aIncZZ8[n,57])="N",aIncZZ8[n,57],VAL(aIncZZ8[n,57]))
		ZZ8->ZZ8_CGRSO2 := aIncZZ8[n,58]
		ZZ8->ZZ8_CODPEC := aIncZZ8[n,59]
		ZZ8->ZZ8_PECQTD := Iif(ValType(aIncZZ8[n,60])="N",aIncZZ8[n,60],VAL(aIncZZ8[n,60]))
		ZZ8->ZZ8_POSPEC := aIncZZ8[n,61]
		ZZ8->ZZ8_PREVPC := aIncZZ8[n,62]
			If Valtype(aIncZZ8[n,63]) = "D" .OR. !Empty(aIncZZ8[n,63])
				ZZ8->ZZ8_DTEXPE := aIncZZ8[n,63]
			Else
				aIncZZ8[n,63] := aIncZZ8[n,63]
			EndIf
		ZZ8->ZZ8_HREXPE := aIncZZ8[n,64]
		ZZ8->ZZ8_ATEENT := aIncZZ8[n,65]
		ZZ8->ZZ8_NFSAID := aIncZZ8[n,66]
		ZZ8->ZZ8_ITEMNF := aIncZZ8[n,67]
		ZZ8->ZZ8_TOTINF := aIncZZ8[n,68]
		ZZ8->ZZ8_AWB    := aIncZZ8[n,69]
		ZZ8->ZZ8_DTACOM := aIncZZ8[n,70]
		ZZ8->ZZ8_SEQACO := aIncZZ8[n,71]
		ZZ8->ZZ8_ACOMPA := aIncZZ8[n,72]
		ZZ8->ZZ8_USERAC := aIncZZ8[n,73]
		ZZ8->ZZ8_IDOS   := aIncZZ8[n,74]
		ZZ8->ZZ8_IDCLIE := aIncZZ8[n,75]
		ZZ8->ZZ8_IDNFCO := aIncZZ8[n,76]
		ZZ8->ZZ8_IDFALH := aIncZZ8[n,77]
		ZZ8->ZZ8_IDSINT := aIncZZ8[n,78]
		ZZ8->ZZ8_IDPECA := aIncZZ8[n,79]
		ZZ8->ZZ8_IDACOM := aIncZZ8[n,80]
		ZZ8->ZZ8_IDEXPE := aIncZZ8[n,81]
		ZZ8->ZZ8_RESCOD := .F.
		ZZ8->ZZ8_RESMSG := ""
		ZZ8->ZZ8_RCODOS := .F.
		ZZ8->ZZ8_RMSGOS := ""
		ZZ8->ZZ8_GVSASS := ""
		ZZ8->ZZ8_STATUS := "0"
		ZZ8->ZZ8_SEQSTA := 1
		ZZ8->ZZ8_STAPUR := aIncZZ8[n,82]
		ZZ8->ZZ8_STACLI := aIncZZ8[n,83]
		ZZ8->ZZ8_STASYM := aIncZZ8[n,84]
		ZZ8->ZZ8_STAFAU := aIncZZ8[n,85]
		ZZ8->ZZ8_STAPEC := aIncZZ8[n,86]
		ZZ8->ZZ8_STADEL := aIncZZ8[n,87]
		ZZ8->ZZ8_STACOM := aIncZZ8[n,88]
		MsUnLock("ZZ8")
/* Retirado daqui e colocado no retorno do web service para os casos que apresentarem erro terใo que reenviar
		dbSelectArea("ZZ4")
		If ZZ4->(dbSeek(xfilial("ZZ4")+_cimei+_cos))
			Reclock("ZZ4",.F.)
			ZZ4->ZZ4_MSEXP:="1"
			MsUnLock('ZZ4')                     '
		EndIf
		dbSelectArea("SZ9")
		SZ9->(dbSetOrder(2))//Z9_FILIAL, Z9_IMEI+Z9_NUMOS,Z9_SEQ, Z9_ITEM
		If SZ9->(dbSeek(xfilial("SZ9")+_cimei+_cos))
			Reclock("SZ9",.F.)
			SZ9->Z9_MSEXP:="1"
			MsUnLock('SZ9')
		EndIf
*/
	Next
//EndIf
If _lalt .AND. Len(aaltZZ8) > 0
	ZZ8->(dbSetOrder(3))//ZZ8_FILIAL, ZZ8_IMEI+ZZ8_NUMOS+ZZ8_CODPRO
	For N:=1 to Len(aaltZZ8)
		//ConOut("   [ATUZZ8] ["+DTOC(Date())+"-"+Time()+"] ALTERANDO: "+StrZero(n,6))
		_cimei:= AvKey(aaltZZ8[n,5], "ZZ8_IMEI")
		_cos  := SubSTR(aaltZZ8[n,74],1,6)
		If ZZ8->(dbSeek(aaltZZ8[n,1]+_cimei+aaltZZ8[n,3]+aaltZZ8[n,4]))
/*
			_nseq75 := Iif(Empty(aaltZZ8[n,75]),left(AllTrim(aaltZZ8[n,75]),3),val(left(AllTrim(aaltZZ8[n,75]),3))+1)
			_nseq76 := Iif(Empty(aaltZZ8[n,76]),left(AllTrim(aaltZZ8[n,76]),2),val(left(AllTrim(aaltZZ8[n,76]),2))+1)
			_nseq77 := Iif(Empty(aaltZZ8[n,77]),left(AllTrim(aaltZZ8[n,77]),2),val(left(AllTrim(aaltZZ8[n,77]),2))+1)
			_nseq78 := Iif(Empty(aaltZZ8[n,78]),left(AllTrim(aaltZZ8[n,78]),2),val(left(AllTrim(aaltZZ8[n,78]),2))+1)
			_nseq79 := Iif(Empty(aaltZZ8[n,79]),left(AllTrim(aaltZZ8[n,79]),2),val(left(AllTrim(aaltZZ8[n,79]),2))+1)
			_nseq80 := Iif(Empty(aaltZZ8[n,80]),left(AllTrim(aaltZZ8[n,80]),3),val(left(AllTrim(aaltZZ8[n,80]),3))+1)
			_nseq81 := Iif(Empty(aaltZZ8[n,81]),left(AllTrim(aaltZZ8[n,81]),2),val(left(AllTrim(aaltZZ8[n,81]),2))+1)
*/
			Reclock("ZZ8",.F.)
			ZZ8->ZZ8_FILIAL :=aaltZZ8[n,1]
			ZZ8->ZZ8_CODPOS :=aaltZZ8[n,2]
			ZZ8->ZZ8_NUMOS  :=aaltZZ8[n,3]
			ZZ8->ZZ8_CODPRO :=aaltZZ8[n,4]
			ZZ8->ZZ8_IMEI   :=aaltZZ8[n,5]
			ZZ8->ZZ8_DPYNUM :=aaltZZ8[n,6]
			ZZ8->ZZ8_CODAT  :=aaltZZ8[n,7]
			ZZ8->ZZ8_MARCA  :=aaltZZ8[n,8]
			ZZ8->ZZ8_DTOS   :=aaltZZ8[n,9]
			ZZ8->ZZ8_HORAOS :=aaltZZ8[n,10]
			ZZ8->ZZ8_OPERAD :=aaltZZ8[n,11]
			ZZ8->ZZ8_NUMCEL :=aaltZZ8[n,12]
			ZZ8->ZZ8_CODCOB :=aaltZZ8[n,13]
			ZZ8->ZZ8_LOCATE :=aaltZZ8[n,14]
			ZZ8->ZZ8_PROCPR :=aaltZZ8[n,15]
			ZZ8->ZZ8_DTFABR :=aaltZZ8[n,16]
			ZZ8->ZZ8_CODSER :=aaltZZ8[n,17]
			ZZ8->ZZ8_ATNAME :=aaltZZ8[n,18]
			ZZ8->ZZ8_NFENTR :=aaltZZ8[n,19]
			ZZ8->ZZ8_DTRECE :=aaltZZ8[n,20]
			ZZ8->ZZ8_HRRECE :=aaltZZ8[n,21]
			ZZ8->ZZ8_DTPREV :=aaltZZ8[n,22]
			ZZ8->ZZ8_ACESSO :=aaltZZ8[n,23]
			ZZ8->ZZ8_NOMREV :=aaltZZ8[n,24]
			ZZ8->ZZ8_CNPJRE :=aaltZZ8[n,25]
			ZZ8->ZZ8_NFCOMP :=aaltZZ8[n,26]
			ZZ8->ZZ8_DTNFCO :=aaltZZ8[n,27]
			ZZ8->ZZ8_VLRNFC :=aaltZZ8[n,28]
			ZZ8->ZZ8_DEFCON :=aaltZZ8[n,29]
			ZZ8->ZZ8_ESTAPA :=aaltZZ8[n,30]
			ZZ8->ZZ8_DTAVAL :=aaltZZ8[n,31]
			ZZ8->ZZ8_SFTREV :=aaltZZ8[n,32]
			ZZ8->ZZ8_DTREPA :=aaltZZ8[n,33]
			ZZ8->ZZ8_HRREPA :=aaltZZ8[n,34]
			ZZ8->ZZ8_OBSREP :=aaltZZ8[n,35]
			ZZ8->ZZ8_ETAPOS :=StrZero(aaltZZ8[n,36],1)
			ZZ8->ZZ8_CODSOS :=aaltZZ8[n,37]
			ZZ8->ZZ8_DTSTOS :=aaltZZ8[n,38]
			ZZ8->ZZ8_HRETOS :=aaltZZ8[n,39]
			ZZ8->ZZ8_CODMNV :=aaltZZ8[n,40]
			ZZ8->ZZ8_IMEINV :=aaltZZ8[n,41]
			ZZ8->ZZ8_DPYIMN :=aaltZZ8[n,42]
			ZZ8->ZZ8_CTROCA :=aaltZZ8[n,43]
			ZZ8->ZZ8_DEFREC :=aaltZZ8[n,44]
			ZZ8->ZZ8_SINTAV :=aaltZZ8[n,45]
			ZZ8->ZZ8_DTINSF :=aaltZZ8[n,46]
			ZZ8->ZZ8_HRINSV :=aaltZZ8[n,47]
			ZZ8->ZZ8_SEQSIN :=Iif(ValType(aaltZZ8[n,48])="N",aaltZZ8[n,48],VAL(aaltZZ8[n,48]))
			ZZ8->ZZ8_SINTCO :=aaltZZ8[n,49]
			ZZ8->ZZ8_CODDEF :=aaltZZ8[n,50]
			ZZ8->ZZ8_CODSOL :=aaltZZ8[n,51]
			ZZ8->ZZ8_CGRPSO :=aaltZZ8[n,52]
			ZZ8->ZZ8_SINREC :=aaltZZ8[n,53]
			ZZ8->ZZ8_MOTDEV :=aaltZZ8[n,54]
			ZZ8->ZZ8_NIVREP :=aaltZZ8[n,55]
			ZZ8->ZZ8_FGONGO :=aaltZZ8[n,56]
			ZZ8->ZZ8_SEQPEC :=Iif(ValType(aaltZZ8[n,57])="N",aaltZZ8[n,57],VAL(aaltZZ8[n,57]))
			ZZ8->ZZ8_CGRSO2 :=aaltZZ8[n,58]
			ZZ8->ZZ8_CODPEC :=aaltZZ8[n,59]
			ZZ8->ZZ8_PECQTD :=aaltZZ8[n,60]
			ZZ8->ZZ8_POSPEC :=aaltZZ8[n,61]
			ZZ8->ZZ8_PREVPC :=aaltZZ8[n,62]
			If Valtype(aaltZZ8[n,63]) = "D" .OR. !Empty(aaltZZ8[n,63])
				ZZ8->ZZ8_DTEXPE :=aaltZZ8[n,63]
			Else
				aaltZZ8[n,63] := aaltZZ8[n,63]
			EndIf
			ZZ8->ZZ8_HREXPE :=aaltZZ8[n,64]
			ZZ8->ZZ8_ATEENT :=aaltZZ8[n,65]
			ZZ8->ZZ8_NFSAID :=aaltZZ8[n,66]
			ZZ8->ZZ8_ITEMNF :=aaltZZ8[n,67]
			ZZ8->ZZ8_TOTINF :=aaltZZ8[n,68]
			ZZ8->ZZ8_AWB    :=aaltZZ8[n,69]
			ZZ8->ZZ8_DTACOM :=aaltZZ8[n,70]
			ZZ8->ZZ8_SEQACO :=aaltZZ8[n,71]
			ZZ8->ZZ8_ACOMPA :=aaltZZ8[n,72]
			ZZ8->ZZ8_USERAC :=aaltZZ8[n,73]
			ZZ8->ZZ8_IDOS   :=aaltZZ8[n,74]
			ZZ8->ZZ8_IDCLIE :=aaltZZ8[n,75]
			ZZ8->ZZ8_IDNFCO :=aaltZZ8[n,76]
			ZZ8->ZZ8_IDFALH :=aaltZZ8[n,77]
			ZZ8->ZZ8_IDSINT :=aaltZZ8[n,78]
			ZZ8->ZZ8_IDPECA :=aaltZZ8[n,79]
			ZZ8->ZZ8_IDACOM :=aaltZZ8[n,80]
			ZZ8->ZZ8_IDEXPE :=aaltZZ8[n,81]
			ZZ8->ZZ8_RESCOD :=.F.
			ZZ8->ZZ8_RESMSG :=""
			ZZ8->ZZ8_RCODOS :=.F.
			ZZ8->ZZ8_RMSGOS :=""
			ZZ8->ZZ8_GVSASS :=""
			ZZ8->ZZ8_STATUS :="3"
			ZZ8->ZZ8_SEQSTA :=ZZ8->ZZ8_SEQSTA+1
			ZZ8->ZZ8_STAPUR :=aaltZZ8[n,82]
			ZZ8->ZZ8_STACLI :=aaltZZ8[n,83]
			ZZ8->ZZ8_STASYM :=aaltZZ8[n,84]
			ZZ8->ZZ8_STAFAU :=aaltZZ8[n,85]
			ZZ8->ZZ8_STAPEC :=aaltZZ8[n,86]
			ZZ8->ZZ8_STADEL :=aaltZZ8[n,87]
			ZZ8->ZZ8_STACOM :=aaltZZ8[n,88]
			MsUnLock("ZZ8")
		EndIf
/* Retirado daqui e colocado no retorno do web service para os casos que apresentarem erro terใo que reenviar
		dbSelectArea("ZZ4")
		If ZZ4->(dbSeek(xfilial("ZZ4")+_cimei+_cos))
			Reclock("ZZ4",.F.)
			ZZ4->ZZ4_MSEXP:="1"
			MsUnLock("ZZ4")
		EndIf
		dbSelectArea("SZ9")
		SZ9->(dbSetOrder(2))//Z9_FILIAL, Z9_IMEI+Z9_NUMOS,Z9_SEQ, Z9_ITEM
		If SZ9->(dbSeek(xfilial("SZ9")+_cimei+_cos))
			Reclock("SZ9",.F.)
			SZ9->Z9_MSEXP:="1"
			MsUnLock("SZ9")
		EndIf
*/
	Next
EndIf
//ConOut("   [ATUZZ8] ["+DTOC(Date())+"-"+Time()+"] FINALIZANDO ATUALIZACAO ZZ8...[X]")
corrige()
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออัออออออออออหอออออัออออออออออออออออออออออออออออออหออออัอออออออออปฑฑ
ฑฑบProgramaณSB1Model  บAutorณHudson de Souza Santos        บDataณ25/08/15 บฑฑ
ฑฑฬออออออออุออออออออออสอออออฯออออออออออออออออออออออออออออออสออออฯอออออออออนฑฑ
ฑฑบDesc.   ณFuncao que corrige erros de regra de entrada e apontamento    บฑฑ
ฑฑฬออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso     ณ ESPECIFICO BGH                                               บฑฑ
ฑฑศออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SB1Model()
Local cQryU := ""
cQryU := "UPDATE " + RetSqlName("ZZ8") + " SET ZZ8_CODPRO = B1_MODELO "
cQryU += "FROM " + RetSqlName("ZZ8") + " as ZZ8(NOLOCK) "
cQryU += "Inner Join " + RetSqlName("SB1") + " SB1(NOLOCK) "
cQryU +=  "ON SB1.D_E_L_E_T_ = ZZ8.D_E_L_E_T_ "
cQryU +=  "AND B1_COD = ZZ8_DPYNUM "
cQryU += "WHERE ZZ8.D_E_L_E_T_ = '' "
cQryU +=  "AND B1_MODELO <> ZZ8_CODPRO"

TcSqlExec(cQry)
TCRefresh(RetSqlName("ZZ8"))

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณcorrige   บ Autor ณ Edson Rodrigues    บ Data ณ  15/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que corrige erros de regra de entrada e apontamento |ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function corrige()
Local cupdQry:=""
Local cselQry:=""
Local cstring:=""
Local nRECNO :=0
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...")
//corrige problemas de sintoma codificado
cupdQry:= "UPDATE "+RETSQLNAME("SZ9")+" SET Z9_SINTCOD=CASE WHEN Z9_SYMPTO='0' THEN '0001' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='1' THEN '0101' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='2' THEN '0201' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='3' THEN '0301' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='4' THEN '0401' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='5' THEN '0501' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='6' THEN '0601' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='7' THEN '0701' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='8' THEN '0801' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='9' THEN '0901' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='10' THEN '1001' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='11' THEN '1101' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='12' THEN '1201' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='13' THEN '1301' "+CRLF
cupdQry+= "                                  WHEN Z9_SYMPTO='14' THEN '1401' ELSE '0001' END "+CRLF
cupdQry+= " WHERE  Z9_FILIAL='" + xFilial("SZ9") + "' AND D_E_L_E_T_='' AND SubSTRING(Z9_CODTEC,1,1)='S' AND Z9_SYMPTO<>'' AND Z9_SINTCOD='' "+CRLF
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("SZ9"))
//Corrige cadastros errados
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...01")
cupdQry:="UPDATE "+RETSQLNAME("ZZ8")+" SET  ZZ8_CODSER='SEGR' WHERE ZZ8_FILIAL='" + xFilial("ZZ8") + "' AND ZZ8_CODSER LIKE '%REINGRESSO%'  AND D_E_L_E_T_=''"
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...02")
cupdQry:="UPDATE "+RETSQLNAME("SZA")+" SET  ZA_CODTPSE='SEGR' WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND ZA_CODTPSE LIKE '%REINGRESSO%' AND D_E_L_E_T_=''"
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("SZA"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...03")
cupdQry:="UPDATE "+RETSQLNAME("ZZ8")+" SET ZZ8_OPERAD='Generico' WHERE ZZ8_FILIAL='" + xFilial("SZA") + "' AND ZZ8_OPERAD='Genrico' AND D_E_L_E_T_='' "
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...04")
/*
cupdQry:="UPDATE "+RETSQLNAME("SZA")+" SET  ZA_NOMEOPE='Generico' WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND ZA_NOMEOPE='Genrico' AND D_E_L_E_T_=''"
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("SZA"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...05")
cupdQry:="UPDATE "+RETSQLNAME("ZZ8")+" SET ZZ8_OPERAD='Amazonia' WHERE ZZ8_FILIAL='" + xFilial("ZZ8") + "' AND ZZ8_OPERAD='Amaz“nia' AND D_E_L_E_T_='' "
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...06")
cupdQry:="UPDATE "+RETSQLNAME("SZA")+" SET  ZA_NOMEOPE='Amazonia' WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND ZA_NOMEOPE='Amaz“nia' AND D_E_L_E_T_=''"
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("SZA"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...07")
cupdQry:="UPDATE "+RETSQLNAME("ZZ8")+" SET ZZ8_OPERAD='Oi' WHERE ZZ8_FILIAL='" + xFilial("ZZ8") + "' AND ZZ8_OPERAD='TNL PCS (Oi)' AND D_E_L_E_T_='' "
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...08")
cupdQry:="UPDATE "+RETSQLNAME("SZA")+" SET ZA_NOMEOPE='Oi' WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND ZA_NOMEOPE='TNL PCS (Oi)' AND D_E_L_E_T_='' "
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("SZA"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...09")
cupdQry:="UPDATE "+RETSQLNAME("ZZ8")+" SET ZZ8_OPERAD='Ctbc' WHERE ZZ8_FILIAL='" + xFilial("ZZ8") + "' AND ZZ8_OPERAD LIKE '%CTBC%' AND D_E_L_E_T_=''"
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...10")
cupdQry:="UPDATE "+RETSQLNAME("SZA")+" SET ZA_NOMEOPE='Ctbc' WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND ZA_NOMEOPE LIKE '%CTBC%' AND D_E_L_E_T_=''"
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("SZA"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...11")
*/
/* Corrigido HUdson 17/07/2015
cupdQry:=" UPDATE "+RETSQLNAME("ZZ8")+" SET ZZ8_CODPRO=B1_MODELO FROM "+RETSQLNAME("ZZ8")+" A "+CRLF
cupdQry+=" INNER JOIN "+RETSQLNAME("SB1")+" B ON ZZ8_CODPRO=B1_COD "+CRLF
cupdQry+=" WHERE ZZ8_FILIAL='" + xFilial("ZZ8") + "' AND B.B1_FILIAL='" + xFilial("SB1") + "' AND A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND  =='' AND SubSTRING(B1_COD,1,3) IN ('DPY','120','121','122') AND B1_MODELO<>''"+CRLF
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
*/
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...12")
cupdQry:=" UPDATE "+RETSQLNAME("SZA")+" SET ZA_CODPROD=B1_MODELO FROM "+RETSQLNAME("SZA")+" A "+CRLF
cupdQry+=" INNER JOIN "+RETSQLNAME("SB1")+" B ON ZA_CODPROD=B1_COD "+CRLF
cupdQry+=" WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND B.B1_FILIAL='" + xFilial("SB1") + "' AND A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND  ZA_CLIENTE='000146' AND SubSTRING(B1_COD,1,3) IN ('DPY','120','121','122') AND B1_MODELO<>'' "+CRLF
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("SZA"))
/*//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...13")
cupdQry:=" UPDATE "+RETSQLNAME("ZZ8")+" SET ZZ8_CODPRO=B1_GRUPO+'I' FROM  "+RETSQLNAME("ZZ8")+" A "+CRLF
cupdQry+=" INNER JOIN "+RETSQLNAME("SB1")+" B ON ZZ8_CODPRO=B1_COD "+CRLF
cupdQry+=" WHERE ZZ8_FILIAL='" + xFilial("ZZ8") + "' AND B.B1_FILIAL='" + xFilial("SB1") + "' AND A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND  ZZ8_GVSASS='' AND SubSTRING(B1_COD,1,3) IN ('DPY','120','121','122') AND B1_MODELO='' "+CRLF
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))*/
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...14")
/*
cupdQry:=" UPDATE "+RETSQLNAME("SZA")+" SET ZA_CODPROD=B1_GRUPO+'I' FROM "+RETSQLNAME("SZA")+" A "+CRLF
cupdQry+=" INNER JOIN "+RETSQLNAME("SB1")+" B ON ZA_CODPROD=B1_COD "+CRLF
cupdQry+=" WHERE A.ZA_FILIAL='" + xFilial("SZA") + "' AND B.B1_FILIAL='" + xFilial("SB1") + "'  AND A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND  ZA_CLIENTE='000146' AND SubSTRING(B1_COD,1,3) IN ('DPY','120','121','122') AND B1_MODELO='' "+CRLF
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("SZA"))
*/
If Select("QrySZA") > 0
	QrySZA->(dbCloseArea())
EndIf
//retira caracteres com acentros
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...15")
cselQry:="SELECT ZA_NOMEREV,R_E_C_N_O_ FROM "+RETSQLNAME("SZA")+" (nolock) WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND ZA_NOMEREV LIKE '%%' AND D_E_L_E_T_=''"
TCRefresh(RETSQLNAME("SZA"))
TCQUERY cselQry ALIAS "QrySZA" NEW
QrySZA->(dbGoTop())
While !QrySZA->(Eof())
	cstring:=AllTrim(QrySZA->ZA_NOMEREV)
	nRECNO:=QrySZA->R_E_C_N_O_
	cstring:=U_TiraAcento(cstring)
	cupdQry:="UPDATE "+ RETSQLNAME("SZA")+ " SET  ZA_NOMEREV='"+cstring+"' WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND R_E_C_N_O_="+AllTrim(STR(nRECNO))+" AND D_E_L_E_T_=''"
	TCSQLEXEC (cupdQry)
	TCRefresh(RETSQLNAME("SZA"))
	QrySZA->(dbSkip())
EndDo
If Select("QrySZA") > 0
	QrySZA->(dbCloseArea())
EndIf
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...16")
cselQry:="SELECT ZA_DEFCONS,R_E_C_N_O_ FROM "+RETSQLNAME("SZA") +" (nolock) WHERE ZA_FILIAL='" + xFilial("SZA") + "'  AND  ZA_DEFCONS LIKE '%%' AND D_E_L_E_T_=''"
TCRefresh(RETSQLNAME("SZA"))
TCQUERY cselQry ALIAS "QrySZA" NEW
QrySZA->(dbGoTop())
While !QrySZA->(Eof())
	cstring:=AllTrim(QrySZA->ZA_DEFCONS)
	nRECNO:=QrySZA->R_E_C_N_O_
	cstring:=U_TiraAcento(cstring)
	//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...While")
	cupdQry:="UPDATE "+ RETSQLNAME("SZA") +" SET ZA_DEFCONS='"+cstring+"' WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND R_E_C_N_O_="+AllTrim(STR(nRECNO))+" AND D_E_L_E_T_=''"
	TCSQLEXEC (cupdQry)
	TCRefresh(RETSQLNAME("SZA"))
	QrySZA->(dbSkip())
EndDo
If Select("QrySZA") > 0
	QrySZA->(dbCloseArea())
EndIf
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...18")
cselQry:="SELECT ZA_NOMEATE,R_E_C_N_O_ FROM "+RETSQLNAME("SZA")+" (nolock) WHERE ZA_FILIAL='" + xFilial("SZA") + "' AND ZA_NOMEATE LIKE '%%' AND D_E_L_E_T_=''"
TCRefresh(RETSQLNAME("SZA"))
TCQUERY cselQry ALIAS "QrySZA" NEW
QrySZA->(dbGoTop())
While !QrySZA->(Eof())
	cstring:=AllTrim(QrySZA->ZA_NOMEATE)
	nRECNO:=QrySZA->R_E_C_N_O_
	cstring:=U_TiraAcento(cstring)
	//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...While")
	cupdQry:="UPDATE "+RETSQLNAME("SZA")+ " SET ZA_NOMEATE='"+cstring+"' WHERE ZA_FILIAL='"+ xFilial("SZA")+"' AND R_E_C_N_O_="+AllTrim(STR(nRECNO))+" AND D_E_L_E_T_=''"
	TCSQLEXEC (cupdQry)
	TCRefresh(RETSQLNAME("SZA"))
	QrySZA->(dbSkip())
EndDo
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...19")
cupdQry:=" UPDATE "+RETSQLNAME("ZZ8")
cupdQry+=" SET D_E_L_E_T_ = '*' "
cupdQry+=" WHERE R_E_C_N_O_ in (	SELECT Z8_1.R_E_C_N_O_ "
cupdQry+=" 							FROM "+RETSQLNAME("ZZ8")+ " AS Z8_1(NOLOCK) "
cupdQry+=" 								INNER JOIN ZZ8020 AS Z8_2(NOLOCK) "
cupdQry+=" 									ON Z8_1.D_E_L_E_T_		= Z8_2.D_E_L_E_T_ "
cupdQry+=" 										AND Z8_1.ZZ8_FILIAL	= Z8_2.ZZ8_FILIAL "
cupdQry+=" 										AND Z8_1.ZZ8_IMEI	= Z8_2.ZZ8_IMEI "
cupdQry+=" 										AND Z8_1.ZZ8_STATUS	= Z8_2.ZZ8_STATUS "
cupdQry+=" 										AND Z8_1.ZZ8_IDOS	= Z8_2.ZZ8_IDOS "
cupdQry+=" 										AND Z8_2.ZZ8_GVSASS	= '' "
cupdQry+=" 							WHERE Z8_1.D_E_L_E_T_ = '' "
cupdQry+=" 								AND Z8_1.ZZ8_GVSASS = 'ERRO_RETORNO') "
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] FIM...FORAM 19")
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...20")
cupdQry:=" UPDATE "+RETSQLNAME("ZZ8")+ " SET D_E_L_E_T_ = '*' FROM "+RETSQLNAME("ZZ8")+ " ZZ81 "
cupdQry+=" INNER JOIN (SELECT ZZ8_IMEI,LEFT(ZZ8_IDOS,6) AS OSBGH, ZZ8_STATUS FROM "+RETSQLNAME("ZZ8")+" (nolock) "
cupdQry+="             WHERE ZZ8_FILIAL='" + xFilial("ZZ8") + "'  AND D_E_L_E_T_='' AND ZZ8_GVSASS<>'') AS ZZ82 "
cupdQry+=" ON ZZ81.ZZ8_IMEI = ZZ82.ZZ8_IMEI AND LEFT(ZZ81.ZZ8_IDOS,6) = ZZ82.OSBGH AND ZZ81.ZZ8_STATUS = ZZ82.ZZ8_STATUS "
cupdQry+=" WHERE ZZ81.ZZ8_FILIAL='" + xFilial("ZZ8") + "' AND ZZ81.ZZ8_GVSASS='' AND D_E_L_E_T_='' "
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] FIM...FORAM 20")
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] INICIO...21")
cupdQry:=" DELETE FROM "+RETSQLNAME("ZZ8")+ " WHERE D_E_L_E_T_ = '*' "
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZ8"))
//ConOut("   [CORRIGE] ["+DTOC(Date())+"-"+Time()+"] FIM...FORAM 21")
Return()
