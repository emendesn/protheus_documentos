#Include "PROTHEUS.Ch"
#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#INCLUDE "topconn.ch"
#include "tbiconn.ch"    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINTARCON  บ Autor ณ Edson Rodrigues    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Prgrama para intergrar os dados contabeis para Comshare-AR บฑฑ
ฑฑบ          ณ    Microsiga X Comshare                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
user Function coshpar()



Local CcGet1 := GetMV("ZZ_COSH001",.F.)


PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" TABLES "CT1","CT2","CT3","CTD","CTH","CTS"
	
	If CcGet1
		U_consh()
	endif
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOSH  	บAutor  ณMicrosiga           บ Data ณ  09/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function consh()



U_ENVIAEMAIL("INICIO","CHEGOU NA FUNCAO","uiran.almeida@bgh.com.br","","172.16.0.7")


Private aAlias      := {"CT1","CT2","CT3","CTD","CTH","CTS"}
Private asetofbook  :={}
Private actbmoeda   :={}
Private aSaldoAnt   :={}
Private aconbghar   :={}
Private avisnval    :={}
Private _cregiao    := "0001"
Private _ccompan    := "00029"
Private _ccodvis    := "200"
private CR	 		:= chr(13) + chr(10)
Private nSaldoAnt   := 0
Private nTotal      := 0
Private _cdia       := "01"    
Private _cmes       := IIF(.T.,IIF(DAY(ddatabase) <= 31,STRZERO(MONTH(ddatabase)-1,2),STRZERO(MONTH(ddatabase),2)),GetMV("ZZ_COSH002"))
Private _cano       := IIF(.T.,IIF(MONTH(ddatabase)==1 .AND. DAY(ddatabase) <= 31, STRZERO(YEAR(ddatabase)-1,4),STRZERO(YEAR(ddatabase),4)),GetMV("ZZ_COSH003"))
Private _cfimmes    := IIF(_cmes='02','28',IIF(_cmes $ "01/03/05/07/08/10/12",'31','30'))
Private _cperiod    :=_cano+_cmes
Private _nvalor     := 0.00                            
Private _ncount     := 0.00
Private lR4         := .t.
Private lsalinip    := .F. //Define se vai gerar o mes de dezembro/2010

If  _cano == '2012' .and. _cmes='02'  .and. _cfimmes='28'
   _cfimmes:='29'
Endif

//----Verificar se essas variแveis jแ estใo definidas qdo se carrega o PREPARE ENVIRONMENT EMPRESA
Private otext, oMeter, odlg
Private carqtmp    :=''
Private centgerini :=Space(20)
Private centgerfim :="ZZZZZZZZZZZZZZZZZZZZ"
Private cmoeda     := "01"
Private Ddataini   :=ctod(_cdia+"/"+substr(_cmes,1,2)+"/"+_cano)
Private Ddatafim   :=ctod(_cfimmes+"/"+substr(_cmes,1,2)+"/"+_cano)
Private lNoMov     := .f.
Private csaldo     :='1'
Private lanalitico :=.F.
Private ccodplger  :=_ccodvis
Private lcusto     :=.F.
Private litem      :=.F.
Private lclvl      :=.F.
Private nTotal     := 0
Private lend       := .T.
Private lvalvis    := .t.
Private nMeter     := 0
Private EnvLog	   := GetMv("ZZ_COSH006")  //envia log .T. ou .F.
Private Path       := "172.16.0.7"
Private cDestina   := GetMv("ZZ_COSH004")  //Destinatแrio do envio dos emails de notifica็ใo
Private cCco       := GetMv("ZZ_COSH005")	//C๓pia oculta para o envio de emails de notifica็ใo
Private Cdata	   := ""

    
		PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" TABLES "CT1","CT2","CT3","CTD","CTH","CTS"
             
Cdata := Dtoc(Ddatabase)

//+----------------------------------------------------------
//|Enviando email para notifica็ใo do colaborador sobre o 
//|inํcio da execu็ใo da rotina Alterado Carlos Vieira 04.11.2014
//+----------------------------------------------------------
U_ENVIAEMAIL("INICIANDO A EXECUวรO COMSHARE "+cData,cDestina,cCco,"Iniciando a execu็ใo do Conshare","",Path)
U_ENVIAEMAIL("INICIO","INICIO COMSHARE","uiran.almeida@bgh.com.br","","172.16.0.7")


//-----
// Altera็ใo de Parametros somente para gerar o saldo inicial de janeiro/2011
// Conforme acordado com o Eduardo Corbella em 01/03/2011
If lsalinip
	_cmes       := "01"
	_cano       := "2011"
	_cfimmes    := IIF(_cmes='02','28',IIF(_cmes $ "01/03/05/07/08/10/12",'31','30'))
	_cperiod    :="201012"
	centgerini  :="                    "
	centgerfim  :="ZZZZZZZZZZZZZZZZZZZZ"
	lNoMov      := .T.
Endif

//Pega saldo inicial de todas as contas inclusive as sem movimentos quando inicio de exercicio
If RIGHT(ALLTRIM(_cperiod),2)=="07"
   _ncount      := 3     
Else
   _ncount      := 2
Endif 

//Abre as tabelas a serem usadas
dbSelectArea("CT1")
DbSetOrder(1)

dbSelectArea("CTS")
DbSetOrder(1)

dbSelectArea("CT2")
DbSetOrder(1)

dbSelectArea("CT3")
DBSetOrder(1)

dbSelectArea("CTD")
DBSetOrder(1)

dbSelectArea("CTH")
DbSetOrder(1)



_cStr := "AFTER_MICROSIGA_PROCESS"
if TCSPExist(_cStr)
	TCSqlExec(_cStr)
Else
	//Colocado para executar a procedure, pois a funcao SPEXIST nao encontra a procedure mesmo a mesma existindo. 13/05/10 Edson Rodrigues
	TCSqlExec(_cStr)
Endif

/* deleta tabela OUT_DATOS_CONT      */
_cQuery := " DELETE OUT_DATOS_CONT"
_cQuery += " WHERE PERIODO="+_cperiod+""


TCSQLEXEC ( _cQuery )
TCRefresh("OUT_DATOS_CONT")

asetofbook:=ctbsetof(_ccodvis)

lvalvis :=valvisao(_ccodvis)

IF lvalvis .or. len(avisnval) > 0
	actbmoeda:=ctbmoeda(cmoeda)
	For x:=1  to _ncount
		If x==3
			lNoMov      := .T.
			ccodplger   :="200"
			centgerini  :="                    "
			centgerfim  :="ZZZZZZZZZZZZZZZZZZZZ"
			If select("carqtmp") > 0
				carqtmp->(dbCloseArea())
			Endif
			asetofbook  :={}
			asetofbook  :=ctbsetof(ccodplger)
		ElseIf x==2
			lNoMov      := .F.
			ccodplger   := "201"
			centgerini  := "                    "
			centgerfim  := "ZZZZZZZZZZZZZZZZZZZZ"
			asetofbook  := {}
			If Select("carqtmp") > 0
				carqtmp->(dbCloseArea())
			Endif
			asetofbook  :=ctbsetof(ccodplger)
		Else
			lNoMov      := .F.
			ccodplger   :="200"
			centgerini  :="                    "
			centgerfim  :="ZZZZZZZZZZZZZZZZZZZZ"
		Endif

		odlg := TDialog():New(0,0,400,400,"Teste")
		oText:=oMeter:= tMeter():New(10,10,{|u|if(Pcount()>0,nMeter:=u,nMeter)},100,oDlg,100,16,,.T.)

		U_ENVIAEMAIL("INICIO DE PROCESSAMENTO",cDestina,"","Iniciando o processamento mais demorado","",Path)
		CTBGerRazG( 	ometer,;
	     				otext,;
	     				odlg,;
	     				lend,;
	     				@carqtmp,;
	     				centgerini,;
	     				centgerfim,;
	     				cmoeda,;
	     				ddataini,;
	     				ddatafim,;
	     				asetofbook,;
	     				lnomov,;
	     				csaldo,;
	     				lanalitico,;
	     				ccodplger,;
	     				lcusto,;
	     				litem,;
	     				lclvl,;
	     				lR4 )
		U_etmp()
		
	Next
	
	U_grvbtc()
	
	Private ctitulo   := "Gera็ใo dos dados Contabeis do Comshare em "+DTOC(ddatabase)+" "+time()+"." "
	Private cMensagem := "Os dados Contabeis para o Comshare referente ao periodo : "+right(_cperiod,2)+"/"+left(_cperiod,4)+" foram gerados com sucesso em: "+DTOC(ddatabase)+" "+time()+"." "
Else

	Private ctitulo   := "dados Contabeis do Comshare NAO GERADO em "+DTOC(ddatabase)+" "+time()+"." "
	Private cMensagem := " Os dados Contabeis para o Comshare referente ao periodo : "+right(_cperiod,2)+"/"+left(_cperiod,4)+" NAO FORAM GERADOS em: "+DTOC(ddatabase)+" "+time()+"."+CR+CR
	IF  len(avisnval) > 0
		cMensagem += " Veja abaixo os problemas encontrados : "+CR+CR
		cMensagem += "ENTIDADE             "+"|"+"CONTA      "+"|"+"C.CUSTO    "+"|"+"PROBLEMA"+CR
		For x:=1 to len(avisnval)
			cMensagem += ALLTRIM(avisnval[x,1])+SPACE(len(ALLTRIM(avisnval[x,1]))-20)+"|"
			cMensagem += ALLTRIM(avisnval[x,2])+SPACE(len(ALLTRIM(avisnval[x,2]))-10)+"|"
			cMensagem += ALLTRIM(avisnval[x,3])+SPACE(len(ALLTRIM(avisnval[x,3]))-10)+"|"
			cMensagem += ALLTRIM(avisnval[x,4])+CR
		Next
	ENDIF
Endif


U_ENVIAEMAIL(cTitulo,cDestina,cCco,cMensagem,Path)

//+----------------------------------------------------------
//|Enviando email para notifica็ใo do colaborador sobre o 
//|inํcio da execu็ใo da rotina
//+----------------------------------------------------------
U_ENVIAEMAIL("Finalizando a execu็ใo do CONSHARE "+cData,cDestina,cCco,"Execu็ใo do Conshare finalizada com sucesso","",Path)

PutMV("ZZ_COSH001",.F.)

return     


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ etmp บ Autor ณ Edson Rodrigues    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para filtrar dados e gerar o temporario da contabiบฑฑ
ฑฑบ          ณ lizacao via visao gerencial                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User function etmp()

Local nSaldoAtu  := 0
Local nTotDeb	 := 0
Local nTotCrd	 := 0
Local nVlrDeb    := 0
Local nVlrCrd    := 0
Local li         := 0
Local nDecimais  := DecimalCTB(aSetOfBook,cMoeda)
Local cPicture 	 := aSetOfBook[4]
Local cDescSint  := ""
Local cDescConta := ""
Local dDataAnt	 := CTOD("  /  /  ")

#DEFINE 	COL_NUMERO 			1
#DEFINE 	COL_HISTORICO		2
#DEFINE 	COL_CENTRO_CUSTO 	3
#DEFINE 	COL_ITEM_CONTABIL 	4
#DEFINE 	COL_CLASSE_VALOR  	5
#DEFINE 	COL_VLR_DEBITO		6
#DEFINE 	COL_VLR_CREDITO		7
#DEFINE 	COL_VLR_SALDO  		8
#DEFINE 	TAMANHO_TM       	9
#DEFINE 	COL_VLR_TRANSPORTE  10


	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" TABLES "CT1","CT2","CT3","CTD","CTH","CTS"
		
		
dbselectarea("cArqTmp")
cArqTmp->(dbgotop())

While !cArqTmp->(Eof())
	
	// Impressao do Saldo Anterior da Conta
	dbSelectArea("CTS")
	dbSetOrder(2)
	
	If MsSeek(xFilial("CTS")+cCodPlGer+cArqTmp->CONTA)
		nSaldoAnt	:= 0
		While !CTS->(Eof()) .And. xFilial("CTS") == CTS->CTS_FILIAL .And. CTS->CTS_CODPLA == cCodPlGer .And. ;
			CTS->CTS_CONTAG == cArqTmp->CONTA
			
			aSaldoAnt	:= SaldTotCT7(CTS->CTS_CT1INI,CTS->CTS_CT1FIM,dDataIni,cMoeda,cSaldo,.F.)
			nSaldoAnt	+= aSaldoAnt[6]
	
			dbSkip()
		Enddo
	Endif
	
	If !lNoMov //Se imprime conta sem movimento
		If nSaldoAnt  == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop
		Endif
	Endif
	
	// Conta Sintetica
	cContaSint := Ctr430Sint(cArqTmp->CONTA,@cDescSint,cMoeda,@cDescConta,cCodPlGer)
	cNormal    := cArqTmp->NORMAL
	cclasse    := IIF(EMPTY(cContaSint),"A","S")
	
	
	
	
	dbSelectArea("cArqTmp")
	cContaAnt := cArqTmp->CONTA
	dDataAnt  := cArqTmp->DATAL
	cLOTE     := cArqTmp->LOTE
	cSUBLOTE  := cArqTmp->SUBLOTE
	cDOC      := cArqTmp->DOC
	cLINHA    := cArqTmp->LINHA
	cEMPORI   := cArqTmp->EMPORI
	cFILORI   := cArqTmp->FILORI
	nSaldmovi := 0 
	nTotCrd	  := 0
	nTotDeb   := 0
	nSaldoAtu := nSaldoAnt
              
              	
	li++
	nDivi   := At("/",cContaAnt)
	_cconta := ""
	_ccusto := ""
	
	If  nDivi > 0
		_cconta := alltrim(Substr(cContaAnt, 1, nDivi - 1))
		_ccusto := alltrim(Substr(cContaAnt,nDivi + 1))
	Endif
	
	
	// Pega saldo Inicial se for o inicio do exercicio, no caso - 07-Julho, ou se for a implantacao do saldo inicial de 01/2011
	IF  ((RIGHT(ALLTRIM(_cperiod),2)=="07" .and. lNoMov) .or.  lsalinip) .and. left(alltrim(_cconta),1) $ "123"
		aadd(aconbghar,{li,_cperiod,cContaAnt,_cconta,_ccusto,"A",IIF(lsalinip,"N","S"),cclasse,cNormal,nTotDeb,nTotCrd,nSaldoAtu,nSaldoAnt})
	ENDIF
	
	
	While cArqTmp->(!Eof()) .And. cArqTmp->CONTA == cContaAnt
		nVlrDeb	  += cArqTmp->LANCDEB
		nVlrCrd	  += cArqTmp->LANCCRD
		cArqTmp->(dbSkip())                           
		
	EndDo
	nSaldoAtu	:= nSaldoAtu - nVlrDeb + nVlrCrd
	nTotDeb		+= nVlrDeb
	nTotCrd		+= nVlrCrd
	nSaldmovi   :=nTotCrd-nTotDeb
	nVlrDeb	    := 0
	nVlrCrd	    := 0
	lrateio     := IIF(ccodplger="200",.F.,.T.)               
	
	If !lsalinip .and. !lNoMov  .and. !left(alltrim(_cconta),1) $ "123"
		aadd(aconbghar,{li,_cperiod,cContaAnt,_cconta,_ccusto,iif(lrateio,"D","A"),"N",cclasse,cNormal,nTotDeb,nTotCrd,nSaldoAtu,nSaldmovi})
	Endif
	
	dbSelectArea("cArqTmp")
	
EndDo

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณgrvbtc บ Autor ณ Edson Rodrigues    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPrograma para gravar os dados filtrado na tabela de saida doบฑฑ
ฑฑบ          ณComshare-AR                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User function grvbtc()
                          
	
    		PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" TABLES "CT1","CT2","CT3","CTD","CTH","CTS"

If len(aconbghar) > 0
	For x:=1 to len(aconbghar)               
	     
		_cQuery := " INSERT INTO OUT_DATOS_CONT"
		_cQuery += " (COD_REGION,COD_CIA,PERIODO,VERSION,SAL_INICIAL,COD_CEN_COSTO,COD_CTA_CONT,VALOR) "
		_cQuery += " VALUES('"+_cregiao+"','"+_ccompan+"',"+aconbghar[x,2]+",'"+aconbghar[x,6]+"','"+aconbghar[x,7]+"','"+aconbghar[x,5]+"','"+aconbghar[x,4]+"',"+AllTrim(Str(aconbghar[x,13]))+")"
		TCSQLEXEC ( _cQuery )
		TCRefresh("OUT_DATOS_BI")
	Next
	
	If !lsalinip
		_cStr := "BEFORE_REPLICATION_CONT"
		if TCSPExist(_cStr)
			TCSqlExec(_cStr)
		Else
			
			//Colocado para executar a procedure, pois a funcao TCSPEXIST nao encontra a procedure mesmo a mesma existindo. 13/05/10 Edson Rodrigues
			TCSqlExec(_cStr)
		Endif
	Endif
	
Endif
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvalvisao  บ Autor ณ Edson Rodrigues    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPrograma para validar o cadastro da visao gerencial         บฑฑ
ฑฑบ          ณComshare-AR                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function valvisao(cCodvisao)

Local _lret      :=.t.
Local _contavis :=""
Local _cconta   := ""
Local _ccusto   := ""
                    
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" TABLES "CT1","CT2","CT3","CTD","CTH","CTS"

dbSelectArea("CTS")
dbSetOrder(2)

If MsSeek(xFilial("CTS")+cCodvisao)
	
	While !CTS->(Eof()) .And. xFilial("CTS") == CTS->CTS_FILIAL .And. CTS->CTS_CODPLA == cCodvisao
		_cvisacant:=CTS->CTS_CONTAG
		IF CTS->CTS_CLASSE=="2" .AND.  _cvisacant <> _contavis
			
			_contavis := CTS->CTS_CONTAG
			nDivi     := At("/",_contavis)
			
			IF  nDivi==0
				AADD(avisnval,{_contavis,'','',"Entidade sem barra ('/')"})
				_lret := .f.
			Else
				_cconta := alltrim(Substr(_contavis, 1, nDivi - 1))
				_ccusto := alltrim(Substr(_contavis,nDivi + 1))
			Endif
			
			If _lret
				
				If Select("QryCon") > 0
					QryCon->(dbCloseArea())
				Endif
				
				//valida Conta
				_cQuery := "SELECT COD_CTA_CONT FROM INP_MAE_CTA_CONT (NOLOCK) WHERE COD_CTA_CONT='"+_cconta+"' "
				TCQUERY _cQuery ALIAS "QryCon" NEW
				
				dbSelectArea("QryCon")
				QryCon->(dbgotop())
				
				If QryCon->(EOF())
					AADD(avisnval,{_contavis,_cconta,_ccusto,"Conta nao encontrada na tabela de Contas Contabeis da BGH-AR"})
					_lret:=.f.
				Endif
				
				//valida Centro de Custo
				if Select("QryCc") > 0
					QryCc->(dbCloseArea())
				endif
				
				
				_cQuery := "SELECT COD_CEN_COSTO FROM INP_MAE_CEN_COSTO (NOLOCK) WHERE COD_CEN_COSTO='"+_ccusto+"' "
				TCQUERY _cQuery ALIAS "QryCc" NEW
				
				dbSelectArea("QryCc")
				QryCc->(dbgotop())
				
				if QryCc->(EOF())
					AADD(avisnval,{_contavis,_cconta,_ccusto,"Centro de Custo nao encontrado na tabela de C.Custo da BGH-AR"})
					_lret:=.f.
					
				Endif
				
			Endif
			
		Endif
		
		
		DbSelectArea("CTS")
		DbSkip()
	Enddo
Else
	_lret :=.F.
Endif
Return(_lret)






/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณbrat  บ Autor ณ Edson Rodrigues    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPrograma para buscar lan็amentos de rateios                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function brat(_cconta,dDataAnt,cLOTE,cSUBLOTE,cDOC,cLINHA,cEMPORI,cFILORI)

Local _lret      :=.t.    
					
			PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" TABLES "CT1","CT2","CT3","CTD","CTH","CTS"

dbSelectArea("CT2")
dbSetOrder(1)

Return(_lret)                                   
