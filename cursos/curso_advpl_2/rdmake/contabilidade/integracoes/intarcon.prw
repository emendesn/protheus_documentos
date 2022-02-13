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


User function INTARCON(_APARAMS)


//u_GerA0003(ProcName())

SLEEP(180)

ConOut("*")
ConOut("*")
ConOut("*")
ConOut(Replicate("*",40))
ConOut("   [INTARCON] - "+dtoc(date())+" "+time())
ConOut("   [INTARCON] Montando ambiente Enviroment empresa/filial 02/04...")


If _APARAMS == NIL .or. len(_APARAMS) <= 0
    _APARAMS := {}
Endif

lbat := iif(len(_APARAMS)>=2,_APARAMS[1],.F.)


If lbat
    PREPARE ENVIRONMENT EMPRESA "02" FILIAL "04" TABLES "CT1","CT2","CT3","CTD","CTH","CTS"
Else

   lUsrAut     :=.F.
   aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Valida acesso de usuario                                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   For i := 1 to Len(aGrupos)
	
     	//Usuarios de Autorizado a fazer troca de IMEI
	    If upper(AllTrim(GRPRetName(aGrupos[i]))) $ "GERA_COMSHARE_CONT"
		   lUsrAut  := .T.
	    EndIf
   Next i         


   If !lUsrAut
    	MsgAlert("Voce nao tem autorizacao para executar essa rotina. Contate o administrador do sistema.","Usuario nao Autorizado")
	    return
   Endif

   cPerg       := "INTCON"
   fCriaSX1(cPerg)
   If !Pergunte(cPerg,.T.)     
       Return
   Endif
Endif



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
Private _cmes       := IIF(lbat,IIF(DAY(ddatabase) <= 31,STRZERO(MONTH(ddatabase)-_APARAMS[2],2),STRZERO(MONTH(ddatabase),2)),MV_PAR01)
Private _cano       := IIF(lbat,IIF(MONTH(ddatabase)==1 .AND. DAY(ddatabase) <= 31, STRZERO(YEAR(ddatabase)-1,4),STRZERO(YEAR(ddatabase),4)),MV_PAR02)
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
Private lend
Private otext, oDlg, oMeter, nMeter:=0, oBtn1, oBtn2
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
Private lend       :=.t.
Private lvalvis    := .t.
Private Path      := "172.16.0.7"
Private cDestina  := "edson.rodrigues@bgh.com.br;katia.santos@bgh.com.br;helpdesk@bgh.com.br"
//Private cDestina  := "edson.rodrigues@bgh.com.br"
Private cCco      := ""


//-----
// Altera็ใo de Parametros somente para gerar o saldo inicial de janeiro/2011
// Conforme acordado com o Eduardo Corbella em 01/03/2011
If lsalinip
	_cmes       := "01"
	_cano       := "2011"
	_cfimmes    := IIF(_cmes='02','28',IIF(_cmes $ "01/03/05/07/08/10/12",'31','30'))
	_cperiod    :="201012"
	centgerini  :="                    "
	centgerfim  :="3ZZZZZZZZZZZZZZZZZZZ"
	lNoMov      := .T.
Endif

//Pega saldo inicial de todas as contas inclusive as sem movimentos quando inicio de exercicio
If RIGHT(ALLTRIM(_cperiod),2)=="07"
   _ncount      := 3     
Else
   _ncount      := 2
Endif 


DEFINE MSDIALOG oDlg FROM 0,0 TO 400,400 TITLE 'Teste' Pixel
oText:=oMeter:= tMeter():New(10,10,{|u|if(Pcount()>0,nMeter:=u,nMeter)};
,100,oDlg,100,16,,.T.) // cria a r้gua

*
ConOut("   [INTARCON] Posicionando tabelas acessorias...")
*

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


*
ConOut("   [INTARCON] Executando a store Procedure AFTER_MICROSIGA_PROCESS...")
*

_cStr := "AFTER_MICROSIGA_PROCESS"
if TCSPExist(_cStr)
	TCSqlExec(_cStr)
Else
	conout("Srtore Procedure nใo encontrada.")
	//Colocado para executar a procedure, pois a funcao SPEXIST nao encontra a procedure mesmo a mesma existindo. 13/05/10 Edson Rodrigues
	TCSqlExec(_cStr)
Endif


*
ConOut("   [INTARCON] Deletando dados do periodo da tabela Geral de Informacoes Contabeis : OUT_DATOS_CONT,")
*

/* deleta tabela OUT_DATOS_CONT      */

_cQuery := " DELETE OUT_DATOS_CONT"
_cQuery += " WHERE PERIODO="+_cperiod+""
//_cQuery += " AND VERSION='D'"

TCSQLEXEC ( _cQuery )
TCRefresh("OUT_DATOS_CONT")


ConOut("   [INTARCON] INICIANDO FILTRO DOS DADOS DA VISAO GERENCIAL - : "+DTOC(DATE())+" "+TIME())
asetofbook:=ctbsetof(_ccodvis)

ConOut("   [INTARCON] VALIDA O CADASTRO DAS VISAO GERENCIAL - : "+DTOC(DATE())+" "+TIME())
lvalvis :=valvisao(_ccodvis)

IF lvalvis .or. len(avisnval) > 0
	
	ConOut("   [INTARCON] INICIANDO FILTRO DA MOEDA ULTILIZADA - : "+DTOC(DATE())+" "+TIME())
	actbmoeda:=ctbmoeda(cmoeda)
	
	For x:=1  to _ncount
	   IF x==3
	      lNoMov      := .T.
          ccodplger   :="200"
	      centgerini  :="                    "
          centgerfim  :="3ZZZZZZZZZZZZZZZZZZZ"
          If select("carqtmp") > 0
   	         carqtmp->(dbCloseArea())
   	      Endif 
          asetofbook  :={}
   	      asetofbook  :=ctbsetof(ccodplger)
	   ELSEIF  x==2
	      lNoMov      := .F.                 
	      ccodplger   :="201"
	      centgerini  :="                    "
          centgerfim  :="ZZZZZZZZZZZZZZZZZZZZ"
   	      asetofbook  :={}                         
   	      If select("carqtmp") > 0
   	         carqtmp->(dbCloseArea())
   	      Endif 
   	      asetofbook  :=ctbsetof(ccodplger)
	   ELSE
          lNoMov      := .F. 
	      ccodplger   :="200"
	      centgerini  :="                    "
          centgerfim  :="ZZZZZZZZZZZZZZZZZZZZ"	   
	   Endif
	   
	  // IF  x==2
	     ConOut("   [INTARCON] INICIANDO FILTRO DOS DADOS E MONTANDO O ARQUIVO TEMPORARIO - : "+DTOC(DATE())+" "+TIME())
	     CTBGerRazG(ometer,otext,odlg,lend,@carqtmp,centgerini,centgerfim,cmoeda,ddataini,ddatafim,asetofbook,lnomov,csaldo,;
	     lanalitico,ccodplger,lcusto,litem,lclvl,lR4)

	     ConOut("   [INTARCON] Executando o processamento, agrupando e filtrando dados do arquivo temporario - : "+DTOC(DATE())+" "+TIME())
        U_excatmp()
	
	
	Next
	       //ConOut("   [INTARCON] Executando o processamento de rateios : "+DTOC(DATE())+" "+TIME())
	      //U_buscarat() aguardando definicao correta para fazer o tratamento de busca de rateios.
	
    	   ConOut("   [INTARCON] Executando a gravacao dos arquivos filtrado na tabela do comshare, gravando dados filtrados - : "+DTOC(DATE())+" "+TIME())
	       U_grvtbcom()
      // ENDIF
	
	
	
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

IF !lbat
  MSGBOX("O processamento do Comshare Contabil referente ao mes : " +MV_PAR01+"/"+MV_PAR02+ " foi concluido com sucesso !!","Aten็ใo !","INFO")
Endif

return     


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Excatmp  บ Autor ณ Edson Rodrigues    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para filtrar dados e gerar o temporario da contabiบฑฑ
ฑฑบ          ณ lizacao via visao gerencial                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User function Excatmp()

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
	
	
	//Colocado para inverter os valores da conta                                   
	// Retirado, pois foi acertado as visoes e nใo faz sentido usar essa regra mais. - Edson Rodrigues - 11/04/2011
	//IF lrateio .and. _cconta="56102 24"
	//   nTotDeb=nTotDeb*-1                
	//   nTotCrd=nTotCrd*-1
    //   nSaldmovi   :=nTotCrd-nTotDeb
	//ENDIF
	
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
ฑฑบPrograma  ณgrvtbcom  บ Autor ณ Edson Rodrigues    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPrograma para gravar os dados filtrado na tabela de saida doบฑฑ
ฑฑบ          ณComshare-AR                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User function grvtbcom()

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
			conout("Store Procedure nใo encontrada.")
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
ฑฑบPrograma  ณbuscarat  บ Autor ณ Edson Rodrigues    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPrograma para buscar lan็amentos de rateios                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function buscarat(_cconta,dDataAnt,cLOTE,cSUBLOTE,cDOC,cLINHA,cEMPORI,cFILORI)

Local _lret      :=.t.

dbSelectArea("CT2")
dbSetOrder(1)

Return(_lret)                                   


 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณEdson Rodrigues     บ Data ณ  11/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERA DICIONARIO DE PERGUNTAS                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fCriaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Mes :","","","mv_ch1","C",02,0,0,"G","","" ,"","","mv_par01",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Ano :","","","mv_ch2","C",04,0,0,"G","","" ,"","","mv_par02",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
  
cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe mes - 2 digitos.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o ano - 4 digitos.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return
