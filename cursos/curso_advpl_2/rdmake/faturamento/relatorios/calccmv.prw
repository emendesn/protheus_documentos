#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CALCCMV   º Autor ³ Edson Rodrigues    º Data ³  06/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Calculo de CMV                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CALCCMV


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Calculo o CMV "
Local cPict          := ""
Local titulo       := "Relatório de Calculo de CMV "
Local nLin         := 80
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "CALCCMV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CALCMV"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CALCCMV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private _cNFSD1:=Space(6)
Private _aProdnf:={}
Private _adivneg:={}
Private cString := "SD2"
Private _Ddataini   := GetMV("MV_DINIRAR")
Private _cinprbgh	:= GetMV("MV_INPROBG")
Private _carmdist	:= GetMV("MV_ARMDIST")
Private _carmprop	:= GetMV("MV_ARMPBGH")
Private _carmpven	:= GetMV("MV_ARMPVEN")
Private _cfventot	:= GetMV("MV_CFTVEND")
Private _cfdevtot	:= GetMV("MV_CFTDEV")
Private nTamNfs   := TAMSX3("D2_DOC")[1]

u_GerA0003(ProcName())


dbSelectArea("SD2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Grupo de Perguntas do relatorio...cperg                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec1       := "Dt Inic. : "+DTOC(mv_par03)+ " Dt Fin.: "+DTOC(MV_PAR04)+ " D A D O S   D A S   V E N D A S                          R E C E I T A S        V A L O R E S   C M V S"
//12345678901234567890123456789012345678901234567890123456789012345678901234567891234567890123456789012345678901234567890123456789012345678901234566789012345678901234
Cabec2       := "PRODUTO           DESCRICAO                       CAMPANHA  NF.VENDA   EMISSAO    QTDE    VALOR     ICMS  PIS/COF    REC. LIQ.   MC    %MC  CMV-CONTABIL  CMV-VENDA"
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem,nVezImp
Local _ccodpro:=""
Local _ccodnfe:=""
local _cprod:=SPACE(20)
local _cnota:=SPACE(nTamNfs) // Alterado de 06 para 09 devido a nova versao P10
local _demiss:=SPACE(8)
local _cLocal:=SPACE(2)
local _cpedido:=""
local _cdivneg:=""                 
local _calldivn
local _cnfori:=""
local _cserori:=""
local _ccampsai:=""
Local _ncont:=0
Local _nitem:=0
Local nLin := 80
Local _limpr :=.t.



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Query do relatorio...                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_fMontaQuery()

TRB1->(SetRegua(RecCount()))
TRB1->(dbGoTop())

While !TRB1->(EOF())
	
	IF _ccodpro<>TRB1->D2_COD
		_ncont=_ncont+1
	ENDIF
	
	
	_cprod:=TRB1->D2_COD
	_cnota:=TRB1->D2_DOC
	_demiss:=TRB1->D2_EMISSAO
	_cLocal:=TRB1->D2_LOCAL
	_cpedido:=TRB1->D2_PEDIDO
	
	_nfcomp:=getcompra(_cprod,_demiss,_cLocal)
	
	_nqtcomp:=0.00
	_ncomp :=0.00
	_ncms := 0.00
	_nipi := 0.00
	_npipi := 0.00
	_ccampent:=""
	_cpedpc:=""
	_citmpc:=""
	_ncustger:=0.00
	
	
	dbSelectArea("SD1")
	dbSetOrder(2)
	if SD1->(dbSeek(xFilial("SD1") + _cprod + _nfcomp))
		_nqtcomp :=SD1->D1_QUANT
		_ncomp :=SD1->D1_TOTAL
		_ncms :=SD1->D1_VALICM
		_nipi :=SD1->D1_VALIPI
		_npipi :=SD1->D1_IPI
		_cpedpc:=SD1->D1_PEDIDO
		_citmpc:=SD1->D1_ITEMPC
	Else
		_cprodnew:="Z"+SUBSTR(_cprod,2,14)
		if SD1->(dbSeek(xFilial("SD1") + _cprodnew +_nfcomp))
			_nqtcomp :=SD1->D1_QUANT
			_ncomp :=SD1->D1_TOTAL
			_ncms :=SD1->D1_VALICM
			_nipi :=SD1->D1_VALIPI
			_npipi :=SD1->D1_IPI
			_cpedpc:=SD1->D1_PEDIDO
			_citmpc:=SD1->D1_ITEMPC
		Endif
	Endif
	_cdivneg := Posicione("SC5",1,xFilial("SC5")+ _cpedido,"C5_DIVNEG")
	_ccampsai := Posicione("SC6",2,xFilial("SC6")+_cprod+_cpedido,"C6_CAMPANH")
	_ccampent := Posicione("SC7",1,xFilial("SC7")+_cpedpc+_citmpc,"C7_CAMPANH")
	IF empty(_ccampsai)
		_ccampsai:="00"
	ENDIF
	IF empty(_ccampsai)
		_ccampent:="00"
	ENDIF
	
	_ncustger:= Posicione("SZH",1,xFilial("SZH")+_cprod+_cpedido+_ccampent,"ZH_CUSTO")
	
	IF  EMPTY(_cdivneg)
		DO CASE
			CASE  _cLocal $ "80/81"
				_cdivneg:="06"
			CASE  _cLocal $ "83/84"
				_cdivneg:="01"
			CASE  _cLocal $ "87/88"
				_cdivneg:="07"
			CASE  _cLocal $ "01/1A/1B"
				_cdivneg:="04"
			CASE  _cLocal $ "21"
				_cdivneg:="03"
			Otherwise
				_cdivneg:="09"
		ENDCASE
	ENDIF
	
	
	//                1     2            3             4                 5            6           7               8      9       10    11    12            13      14          15          16        17
	   aAdd(_aProdnf,{_cdivneg,TRB1->D2_COD,TRB1->D2_DOC, TRB1->D2_EMISSAO,TRB1->QTDE,SD1->D1_DOC,SD1->D1_DTDIGIT,_nqtcomp,_ncomp,_ncms,_nipi,TRB1->TOTAL,TRB1->ICMS,_npipi,SD1->D1_PICM,TRB1->PIS,TRB1->COFINS,_ncustger})
	dbSelectArea("TRB1")
	TRB1->(dbSkip())
	_ccodpro:=TRB1->D2_COD
	
Enddo


TRB2->(SetRegua(RecCount()))
TRB2->(dbGoTop())

While !TRB2->(EOF())
	
	IF _ccodpro<>TRB2->D1_COD
		_ncont=_ncont+1
	ENDIF
	
	_cprod:=TRB2->D1_COD
	_cnota:=TRB2->D1_DOC
	_demiss:=TRB2->D1_DTDIGIT
	_cLocal:=TRB2->D1_LOCAL
	_cnfori:=TRB2->D1_NFORI
	_ciseror:=TRB2->D1_SERIORI
	
	_nfcomp:=getcompra(_cprod,_demiss,_cLocal)
	
	_nqtcomp:=0.00
	_ncomp :=0.00
	_ncms := 0.00
	_nipi := 0.00
	_npipi := 0.00
	_ccampent:=""
	_cpedpc:=""
	_citmpc:=""
	_ncustger:=0.00
	
	dbSelectArea("SD1")
	dbSetOrder(2)
	if SD1->(dbSeek(xFilial("SD1")+_cprod+substr(_nfcomp,1,6)+SUBSTR(_nfcomp,7,3)+SUBSTR(_nfcomp,10,6)+SUBSTR(_nfcomp,16,2)))
		_nqtcomp :=SD1->D1_QUANT
		_ncomp :=SD1->D1_TOTAL
		_ncms :=SD1->D1_VALICM
		_nipi :=SD1->D1_VALIPI
		_npipi :=SD1->D1_IPI
		_cpedpc:=SD1->D1_PEDIDO
		_citmpc:=SD1->D1_ITEMPC
		
	Else
		_cprodnew:="Z-"+SUBSTR(_cprod,3,15)
		if SD1->(dbSeek(xFilial("SD1")+_cprodnew+substr(_nfcomp,1,6)+SUBSTR(_nfcomp,7,3)+SUBSTR(_nfcomp,10,6)+SUBSTR(_nfcomp,16,2)))
			_nqtcomp :=SD1->D1_QUANT
			_ncomp :=SD1->D1_TOTAL
			_ncms :=SD1->D1_VALICM
			_nipi :=SD1->D1_VALIPI
			_npipi :=SD1->D1_IPI
			_cpedpc:=SD1->D1_PEDIDO
			_citmpc:=SD1->D1_ITEMPC
		Endif
	Endif
	_ccampent:=""
	_cpedido := Posicione("SD2",3,xFilial("SD2")+_cnfori+_ciseror+SUBSTR(_nfcomp,10,6)+SUBSTR(_nfcomp,16,2),"D2_PEDIDO")
	_cdivneg := Posicione("SC5",1,xFilial("SC5")+ _cpedido,"C5_DIVNEG")
	_ccampsai := Posicione("SC6",2,xFilial("SC6")+_cprod+_cpedido,"C6_CAMPANH")
	_ccampent := Posicione("SC7",1,xFilial("SC7")+_cpedpc+_citmpc,"C7_CAMPANH")
	IF empty(_ccampsai)
		_ccampsai:="00"
	ENDIF
	IF empty(_ccampsai)
		_ccampent:="00"
	ENDIF
	_ncustger:= Posicione("SZH",1,xFilial("SZH")+_cprod+_cpedido+_ccampent,"ZH_CUSTO")
	
	IF  EMPTY(_cdivneg)
		DO CASE
			CASE  _cLocal $ "80/81"
				_cdivneg:="06"
			CASE  _cLocal $ "83/84"
				_cdivneg:="01"
			CASE  _cLocal $ "87/88"
				_cdivneg:="07"
			CASE  _cLocal $ "01/1A/1B"
				_cdivneg:="04"
			CASE  _cLocal $ "21"
				_cdivneg:="03"
			Otherwise
				_cdivneg:="09"
		ENDCASE
	ENDIF
	
	//                1        2            3             4                 5             6           7               8      9       10    11        12            13         14          15              16       17
	    aAdd(_aProdnf,{_cdivneg,TRB2->D1_COD,TRB2->D1_DOC, TRB2->D1_DTDIGIT,-1*TRB2->QTDE,SD1->D1_DOC,SD1->D1_DTDIGIT,_nqtcomp,_ncomp,_ncms,_nipi,-1*TRB2->TOTAL,-1*TRB2->ICMS,_npipi,SD1->D1_PICM,-1*TRB2->PIS,-1*TRB2->COFINS,_ncustger})

	dbSelectArea("TRB2")
	TRB2->(dbSkip())
	_ccodpro:=TRB2->D1_COD	
Enddo                                             
// Alterado de 06 para 09 devido a nova versao P10 

aStru := {}
AADD(aStru,{ "DIVNEG" , "C", 2, 0})
AADD(aStru,{ "PRODUTO" , "C", 15, 0})
AADD(aStru,{ "NFSAIDA" , "C", 9, 0})  
AADD(aStru,{ "DTNFSSAI", "D", 8, 0})
AADD(aStru,{ "QTDSAI" , "N", 14, 2})  
AADD(aStru,{ "TOTSAI" , "N", 14, 2})
AADD(aStru,{ "ICMSSAI" , "N", 14, 2})
AADD(aStru,{ "IPISAI" , "N", 14, 2})
AADD(aStru,{ "PISSAI" , "N", 14, 2})
AADD(aStru,{ "COFSAI" , "N", 14, 2})
AADD(aStru,{ "NFENTR", "C", 6, 0})
AADD(aStru,{ "DTNFEENT", "D", 8, 0})
AADD(aStru,{ "QTDENT" , "N", 14, 2})
AADD(aStru,{ "TOTENT" , "N", 14, 2})
AADD(aStru,{ "ICMSENT" , "N", 14, 2})
AADD(aStru,{ "PICMENT" , "N", 4, 2})
AADD(aStru,{ "IPIENT" , "N", 14, 2}) 
AADD(aStru,{ "PIPIENT" , "N", 4, 2})
AADD(aStru,{ "CUSTGER" , "N", 10,2})


_cArqSeq := CriaTrab(aStru,.t.)
dbUseArea(.T.,,_cArqSeq,"PRODNF",.T.,.F.)
_cAlias  := "PRODNF"
_cIndice := criatrab(,.f.)
_cChave  := "DIVNEG+PRODUTO+NFSAIDA"
_cWhile  := ""
_cFor    := ""
_cTexto  := "Criando arquivo temporário"
indregua(_cAlias,_cIndice,_cChave,_cWhile,_cFor,_cTexto)

_cdivneg=""                            

For _ndv := 1 to Len(_aProdnf)    
   _cdivn1:=_aProdnf[_ndv,1]
  if _cdivn1 $ _cdivneg 
      AADD(_adivneg,{_aProdnf[_ndv,1]})
      _cdivneg:=_cdivneg+_aProdnf[_ndv,1]+"/"
   endif
Next _ndv     

ASORT(_adivneg)    

If Len(_adivneg) > 0 
  For _ndv:=1 to len(_adivneg)
	_cprod:=space(15)
	_cnota:=space(6)
	_cdivneg:=_adivneg[_ndv,1]
	_calldivn:=space(1)
	 nGerqtdv  :=0.00
	 nGerqtdc  :=0.00
	 nGertotc  :=0.00
	 nGericms  :=0.00
	 nGerpisc  :=0.00
	 nGeripi   :=0.00
	 nGercmv   :=0.00
	 nGerucmv  :=0.00
	 nGervven  :=0.00
	
	 For _nprod := 1 to Len(_aProdnf) 
		
		nGerqtdv  += _aProdnf[_nprod,5]
		nGerqtdc  += _aProdnf[_nprod,8]
		nGertotc  += _aProdnf[_nprod,9]
		nGericms  += _aProdnf[_nprod,13]
		nGerpisc  += (_aProdnf[_nprod,16]+_aProdnf[_nprod,17])
		nGeripi   += (_aProdnf[_nprod,9]*(_aProdnf[_nprod,14]/100))
		nGerucmv  += (((_aProdnf[_nprod,9]/_aProdnf[_nprod,8])*(_aProdnf[_nprod,14]/100))+((_aProdnf[_nprod,9]/_aProdnf[_nprod,8])*(1-0.0925-(_aProdnf[_nprod,15]/100))))  // (((Total Geral Compras/Qtde Total Geral Compras)*(Total Geral IPI Compra)/100))+ 
		nGercmv   += ((((_aProdnf[_nprod,9]/_aProdnf[_nprod,8])*(_aProdnf[_nprod,14]/100))+((_aProdnf[_nprod,9]/_aProdnf[_nprod,8])*(1-0.0925-(_aProdnf[_nprod,15]/100))))*_aProdnf[_nprod,5])
		nGervven  +=_aProdnf[_nprod,12]
		
		
		IF MV_PAR07==1  
		   IF !_aProdnf[_nprod,1] $ _calldivn
		      _cnota:=_aProdnf[_nprod,3]
			  _cdivneg:=_aProdnf[_nprod,1]
			  _cproant:=""
		      _cdesdivn := Posicione("SX5",1,xFilial("SX5")+"ZM"+_aProdnf[_nprod,1],"X5_DESCRI")
			  nvalpcmv   :=0.00
			  nvalpucmv  :=0.00
			  ntotpqtdv  :=0.00
			  ntotptotc  :=0.00
			  ntotpicms  :=0.00
			  ntotpisc   :=0.00
			  ntotpipi   :=0.00
			  ntotpcmv   :=0.00
			  ntotpucmv  :=0.00
			  ntotpqtdc  :=0.00
			  ntotvenda  :=0.00
			  nvaldcmv   :=0.00
			  nvalducmv  :=0.00
			  ntotdqtdv  :=0.00
			  ntotdtotc  :=0.00
			  ntotdicms  :=0.00
			  ntotdisc   :=0.00
			  ntotdipi   :=0.00
			  ntotdcmv   :=0.00
			  ntotducmv  :=0.00
			  ntotdqtdc  :=0.00
			  ntotdven   :=0.00
			  _ccabdiv   :=.f.

			  For _ndiv := _nprod to Len(_aProdnf)			        
				  If _aProdnf[_ndiv,1]==_cdivneg //.and. _aProdnf[_nit,1] $ _cdivnfil:=verdivneg(_aProdnf[_nit,1])
         			    _cprod:=_aProdnf[_ndiv,2]
						ntotdqtdv  += _aProdnf[_ndiv,5]
						ntotdqtdc  += _aProdnf[_ndiv,8]
						ntotdtotc  += _aProdnf[_ndiv,9]
						ntotdicms  += _aProdnf[_ndiv,13]
						ntotdisc   += (_aProdnf[_ndiv,16]+_aProdnf[_ndiv,17])
						ntotdipi   += (_aProdnf[_ndiv,9]*(_aProdnf[_ndiv,14]/100))
						ntotducmv  += nvalpucmv
						ntotdcmv   += nvalpcmv
						ntotdven  += _aProdnf[_ndiv,12]
			
						
					   For _nit:=_ndiv to  Len(_aProdnf)
					     If 	_cproant<>_cprod
						   If _aProdnf[_nit,2]==_cprod .and. _aProdnf[_nit,1]==_cdivneg
						       _cproant:=_aProdnf[_nit,2]
						      _cdescpro := Posicione("SB1",1,xFilial("SB1")+_aProdnf[_nit,2],"B1_DESC")
						      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						      //³ Impressao do cabecalho do relatorio. . .                            ³
						      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						      If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
							    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							    nLin := 9
							    @nLin,000  PSAY "Divisão de Negócio :"+ _aProdnf[_nit,1]+"-"+SUBSTR(_cdesdivn,1,30) //Divisao de Negócio - Descricao
							    nLin++
						      Else
						          if !_ccabdiv 
						             @nLin,000  PSAY "Divisão de Negócio :"+ _aProdnf[_nit,1]+"-"+SUBSTR(_cdesdivn,1,30) //Divisao de Negócio - Descricao					   
						             nLin++
						           endif  
						           If nLin > 55
						              Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							          nLin := 9
							          nLin++
							       Endif   
						      Endif
							  @nLin,000      PSAY _aProdnf[_nit,2]+space(2)+SUBSTR(_cdescpro,1,30) //Produto - Descricao
							  @nLin,000      PSAY _aProdnf[_nit,2]+space(2)+SUBSTR(_cdescpro,1,30) //Produto - Descricao
							  @nLin,050      PSAY _aProdnf[_nit,3]  //NF de Vendas
							  @nLin,060      PSAY _aProdnf[_nit,4]  // Emissao Venda
							  @nLin,068      PSAY TRANSFORM(_aProdnf[_nit,5],"@E 99,999.99")  // qtde vend
							  @nLin,080      PSAY TRANSFORM(_aProdnf[_nit,12],"@E 999,999.99")  // R$ Venda
							  @nLin,095      PSAY _aProdnf[_nit,13] // Total ICMS VENDA
							  @nLin,108      PSAY (_aProdnf[_nit,16]+_aProdnf[_nit,17])  // Total PIS/COF VENDA
							  @nLin,120      PSAY _aProdnf[_nit,6] //NF Compra
							  @nLin,132      PSAY _aProdnf[_nit,7] //Digitacao Compra
							  @nLin,143      PSAY TRANSFORM(_aProdnf[_nit,8],"@E 99,999.99")  // qtde compra
							  @nLin,155      PSAY TRANSFORM(_aProdnf[_nit,9],"@E 999,999.99") // total compra
							  @nLin,170      PSAY TRANSFORM ((_aProdnf[_nit,9]*(_aProdnf[_nit,14]/100)),"@E 999,999.99") // Total IPI COMPRA
							  nvalpucmv :=(((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(_aProdnf[_nit,14]/100))+((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(1-0.0925-(_aProdnf[_nit,15]/100))))
							  nvalpcmv  :=((((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(_aProdnf[_nit,14]/100))+((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(1-0.0925-(_aProdnf[_nit,15]/100))))*_aProdnf[_nit,5])
							  @nLin,185      PSAY TRANSFORM(nvalpcmv,"@E 999,999,999.99") // CMV 	TOTAL
							
							  ntotpqtdv  += _aProdnf[_nit,5]
							  ntotpqtdc  += _aProdnf[_nit,8]
							  ntotptotc  += _aProdnf[_nit,9]
							  ntotpicms  += _aProdnf[_nit,13]
							  ntotpisc   += (_aProdnf[_nit,16]+_aProdnf[_nit,17])
							  ntotpipi   += (_aProdnf[_nit,9]*(_aProdnf[_nit,14]/100))
							  ntotpucmv  +=nvalpucmv
							  ntotpcmv   +=nvalpcmv
							  ntotvenda  +=_aProdnf[_nit,12]
							
							  nLin++
						   EndIf			
						 Endif 
						next _nit  
                        If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
          				    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		          		    nLin := 9
				            @nLin,000  PSAY "Divisão de Negócio :"+ _cdivneg +"-"+SUBSTR(_cdesdivn,1,30) //Divisao de Negócio - Descricao
				            nLin++				        
                  	    @nLin,066      PSAY Replicate("-",11)
				        @nLin,078      PSAY Replicate("-",12)
				        @nLin,092      PSAY Replicate("-",12)
			 	        @nLin,106      PSAY Replicate("-",12)
				        @nLin,141      PSAY Replicate("-",11)
				        @nLin,153      PSAY Replicate("-",12)
				        @nLin,168      PSAY Replicate("-",12)
				        @nLin,183      PSAY Replicate("-",15)
				        //@nLin,200      PSAY Replicate("-",10)
				        nLin++								
				        If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				          Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				          nLin := 9
				          @nLin,000  PSAY "Divisão de Negócio :"+ _cdivneg+"-"+SUBSTR(_cdesdivn,1,30) //Divisao de Negócio - Descricao
				         nLin++
				        Endif							
						@nLin,000      PSAY "Total do Produto  "+_cprod+"........... :"
						@nLin,066      PSAY TRANSFORM(ntotpqtdv,"@E 999,999.99")  // qtde vend
						@nLin,076      PSAY TRANSFORM(ntotvenda,"@E 999,999,999.99")  // R$ Venda
						@nLin,091      PSAY TRANSFORM(ntotpicms,"@E 999,999.99") // total ICMS Venda
						@nLin,101      PSAY TRANSFORM(ntotpisc,"@E 999,999,999.99") // total PIS/COFINS	Venda
						@nLin,136      PSAY TRANSFORM(ntotpqtdc,"@E 999,999,999.99") // Total Qtde Compra
						@nLin,151      PSAY TRANSFORM(ntotptotc,"@E 999,999,999.99") // Total R$ Compra
						@nLin,165      PSAY TRANSFORM(ntotpipi,"@E 999,999,999.99") // Total IPI Compra
						@nLin,184      PSAY TRANSFORM(ntotpcmv,"@E 999,999,999.99") // CMV TOTAL
						nLin++
						nLin++
						nLin++
                  Endif
                 Endif
			  Next  _ndiv                     
			  _calldivn:=_calldivn+_cdivneg+"/"
			  If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				    nLin := 9
					@nLin,000  PSAY "Divisão de Negócio :"+ _cdivneg+"-"+SUBSTR(_cdesdivn,1,30) //Divisao de Negócio - Descricao
					nLin++
			  Endif
			  @nLin,066      PSAY Replicate("-",11)
			  @nLin,078      PSAY Replicate("-",12)
			  @nLin,092      PSAY Replicate("-",12)
			  @nLin,106      PSAY Replicate("-",12)
			  @nLin,141      PSAY Replicate("-",11)
			  @nLin,153      PSAY Replicate("-",12)
			  @nLin,168      PSAY Replicate("-",12)
			  @nLin,183      PSAY Replicate("-",15)
			  //@nLin,200      PSAY Replicate("-",10)
			  nLin++
										
			  If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				    @nLin,000  PSAY "Divisão de Negócio :"+  _cdivneg+"-"+SUBSTR(_cdesdivn,1,30) //Divisao de Negócio - Descricao
					nLin++
			  Endif
										
			  @nLin,000      PSAY "Total da Div Negocio : "+_cprod+"........... :"
			  @nLin,066      PSAY TRANSFORM(ntotdqtdv,"@E 999,999.99")  // qtde vend
			  @nLin,076      PSAY TRANSFORM(ntotdven,"@E 999,999,999.99")  // R$ Venda
			  @nLin,091      PSAY TRANSFORM(ntotdicms,"@E 999,999.99") // total ICMS Venda
			  @nLin,101      PSAY TRANSFORM(ntotdisc,"@E 999,999,999.99") // total PIS/COFINS	Venda
			  @nLin,136      PSAY TRANSFORM(ntotdqtdc,"@E 999,999,999.99") // Total Qtde Compra
			  @nLin,151      PSAY TRANSFORM(ntotdtotc,"@E 999,999,999.99") // Total R$ Compra
			  @nLin,165      PSAY TRANSFORM(ntotdipi,"@E 999,999,999.99") // Total IPI Compra
			  @nLin,184      PSAY TRANSFORM(ntotdcmv,"@E 999,999,999.99") // CMV TOTAL
			  nLin++
			  nLin++
			  nLin++
				
				
		
		Else
		
		   If _cnota <> _aProdnf[_nprod,3] 
					Cabec2:="Periodo: Data Inicial: "+DTOC(mv_par03)+" Data Final: "+DTOC(MV_PAR04)
					_cdescpro := Posicione("SB1",1,xFilial("SB1")+_aProdnf[_nprod,2],"B1_DESC")
					_cdesdivn := Posicione("SX5",1,xFilial("SX5")+"ZM"+_aProdnf[_nprod,1],"X5_DESCRI")
					_cprod:=_aProdnf[_nprod,2]
					_cnota:=_aProdnf[_nprod,3]
					_cdivneg:=_aProdnf[_nprod,1]
					nvalpcmv   :=0.00
					nvalpucmv  :=0.00
					ntotpqtdv  :=0.00
					ntotptotc  :=0.00
					ntotpicms  :=0.00
					ntotpisc   :=0.00
					ntotpipi   :=0.00
					ntotpcmv   :=0.00
					ntotpucmv  :=0.00
					ntotpqtdc  :=0.00
					ntotvenda  :=0.00
					_ldiv :=.f.
					
					
					For _nit := _nprod to Len(_aProdnf)
						
						If _aProdnf[_nit,3]==_cnota 
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Impressao do cabecalho do relatorio. . .                            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
								nLin := 9
								@nLin,000  PSAY "Divisão de Negócio :"+ _aProdnf[_nit,1]+"-"+SUBSTR(_cdesdivn,1,30) //Divisao de Negócio - Descricao
								_ldiv :=.t.
								nLin++
								
							Else
								if !_ldiv
									@nLin,000  PSAY "Divisão de Negócio :"+ _aProdnf[_nit,1]+"-"+SUBSTR(_cdesdivn,1,30) //Divisao de Negócio - Descricao
								Endif
							Endif
							
							
							@nLin,000      PSAY _aProdnf[_nit,2]+space(2)+SUBSTR(_cdescpro,1,30)
							@nLin,050      PSAY _aProdnf[_nit,3]  //NF de Vendas
							@nLin,060      PSAY _aProdnf[_nit,4]  // Emissao Venda
							@nLin,068      PSAY TRANSFORM(_aProdnf[_nit,5],"@E 99,999.99")  // qtde vend
							@nLin,080      PSAY TRANSFORM(_aProdnf[_nit,12],"@E 999,999.99")  // R$ Venda
							@nLin,095      PSAY _aProdnf[_nit,13] // Total ICMS VENDA
							@nLin,108      PSAY (_aProdnf[_nit,16]+_aProdnf[_nit,17])  // Total PIS/COF VENDA
							@nLin,120      PSAY _aProdnf[_nit,6] //NF Compra
							@nLin,132      PSAY _aProdnf[_nit,7] //Digitacao Compra
							@nLin,143      PSAY TRANSFORM(_aProdnf[_nit,8],"@E 99,999.99")  // qtde compra
							@nLin,155      PSAY TRANSFORM(_aProdnf[_nit,9],"@E 999,999.99") // total compra
							@nLin,170      PSAY TRANSFORM ((_aProdnf[_nit,9]*(_aProdnf[_nit,14]/100)),"@E 999,999.99") // Total IPI COMPRA
							nvalpucmv :=(((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(_aProdnf[_nit,14]/100))+((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(1-0.0925-(_aProdnf[_nit,15]/100))))
							nvalpcmv  :=((((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(_aProdnf[_nit,14]/100))+((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(1-0.0925-(_aProdnf[_nit,15]/100))))*_aProdnf[_nit,5])
							@nLin,185      PSAY TRANSFORM(nvalpcmv,"@E 999,999,999.99") // CMV 	TOTAL
							
							
							ntotpqtdv  += _aProdnf[_nit,5]
							ntotpqtdc  += _aProdnf[_nit,8]
							ntotptotc  += _aProdnf[_nit,9]
							ntotpicms  += _aProdnf[_nit,13]
							ntotpisc  += (_aProdnf[_nit,16]+_aProdnf[_nit,17])
							ntotpipi   += (_aProdnf[_nit,9]*(_aProdnf[_nit,14]/100))
							ntotpucmv   +=nvalpucmv
							ntotpcmv   +=nvalpcmv
							ntotvenda +=_aProdnf[_nit,12]
							
							
							nLin++
						EndIf
					Next _nit
					
					If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif
					
					
					@nLin,066      PSAY Replicate("-",11)
					@nLin,078      PSAY Replicate("-",12)
					@nLin,092      PSAY Replicate("-",12)
					@nLin,106      PSAY Replicate("-",12)
					@nLin,141      PSAY Replicate("-",11)
					@nLin,153      PSAY Replicate("-",12)
					@nLin,168      PSAY Replicate("-",12)
					@nLin,183      PSAY Replicate("-",15)
					//@nLin,200      PSAY Replicate("-",10)
					nLin++
					
					If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif
					
					@nLin,000      PSAY "Total da Nota  "+_aProdnf[_nprod,3]+"........... :"
					@nLin,066      PSAY TRANSFORM(ntotpqtdv,"@E 999,999.99")  // qtde vend
					@nLin,076      PSAY TRANSFORM(ntotvenda,"@E 999,999,999.99")  // R$ Venda
					@nLin,091      PSAY TRANSFORM(ntotpicms,"@E 999,999.99") // total ICMS Venda
					@nLin,101      PSAY TRANSFORM(ntotpisc,"@E 999,999,999.99") // total PIS/COFINS	Venda
					@nLin,136      PSAY TRANSFORM(ntotpqtdc,"@E 999,999,999.99") // Total Qtde Compra
					@nLin,151      PSAY TRANSFORM(ntotptotc,"@E 999,999,999.99") // Total R$ Compra
					@nLin,165      PSAY TRANSFORM(ntotpipi,"@E 999,999,999.99") // Total IPI Compra
					@nLin,184      PSAY TRANSFORM(ntotpcmv,"@E 999,999,999.99") // CMV TOTAL
					nLin++
					nLin++
					nLin++
				endif
		
		   ENDIF 
		ENDIF
	Next _nprod     
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		nLin++
	Endif
	nLin++
	nLin++
	@nLin,063      PSAY Replicate("-",10)
	@nLin,075      PSAY Replicate("-",13)
	@nLin,090      PSAY Replicate("-",14)
	@nLin,105      PSAY Replicate("-",14)
	@nLin,134      PSAY Replicate("-",13)
	@nLin,151      PSAY Replicate("-",14)
	@nLin,167      PSAY Replicate("-",13)
	@nLin,185      PSAY Replicate("-",15)
	nLin++
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		nLin++
	Endif
    @nLin,000      PSAY "Total Geral.................. :"
    @nLin,062      PSAY TRANSFORM(nGerqtdv,"@E 999,999.99")  // qtde Total Geral venda
    @nLin,074      PSAY TRANSFORM(nGervven,"@E 999,999,999.99") // R$ total  Geral Venda
    @nLin,090      PSAY TRANSFORM(nGericms,"@E 999,999,999.99") // R$ total Geral ICMS Venda
    @nLin,105      PSAY TRANSFORM(nGerpisc,"@E 999,999,999.99") //R$ total PIS/COFINS Venda
    @nLin,137      PSAY TRANSFORM(nGerqtdc,"@E 999,999.99") //  Qtde Total Geral compra
    @nLin,151      PSAY TRANSFORM(nGertotc,"@E 999,999,999.99") // R$ total Geral compra
    @nLin,167      PSAY TRANSFORM(nGeripi,"@E  999,999,999.99") // R$ Total Geral IPI Compra
    //@nLin,182      PSAY TRANSFORM(nGerucmv,"@E 999,999,999.99") // CMV UNIT
    @nLin,185      PSAY TRANSFORM(nGercmv,"@E 999,999,999.99") // CMV TOTAL
    nLin++
    nLin++
  

 Next _ndv

EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRB1->(dbCloseArea())

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return






Static Function _fMontaQuery()
Local cQuery
Local cQuer2
LOcal CR := chr(13) + chr(10)

if select("TRB1") > 0
	TRB1->(dbCloseArea())
endif
if select("TRB2") > 0
	TRB2->(dbCloseArea())
endif



cQuery := CR + " SELECT D2_FILIAL,D2_COD,D2_LOCAL,D2_DOC,D2_EMISSAO,D2_PEDIDO,SUM(D2_QUANT) AS QTDE,SUM(D2_TOTAL) AS TOTAL,SUM(D2_VALICM) AS ICMS,SUM(D2_VALIMP5) AS COFINS,SUM(D2_VALIMP6) AS PIS"
cQuery += CR + " FROM "+RETSQLNAME('SD2')+" SD2 (nolock) "
cQuery += CR + " INNER JOIN ( SELECT B1_COD,B1_TIPOP FROM "+RETSQLNAME('SB1')+" (nolock) WHERE B1_FILIAL  = '"+ xFilial("SB1") +"' AND  D_E_L_E_T_='' ) AS B1 ON B1_COD=SD2.D2_COD  "
cQuery += CR + " WHERE SD2.D2_FILIAL  = '"+ xFilial("SD2") +"' " // Filial
cQuery += CR + " AND SD2.D2_COD  >= '"+mv_par01+"' " // Produto Inicial
cQuery += CR + " AND SD2.D2_COD   <= '"+mv_par02+"' " // Produto Final
cQuery += CR + " AND SD2.D2_EMISSAO >= '"+dtos(mv_par03)+"' " // Data de Emissão NFS Inicial
cQuery += CR + " AND SD2.D2_EMISSAO <= '"+dtos(mv_par04)+"' " // Data de Emissão NFS Final
cQuery += CR + " AND SD2.D2_DOC >= '"+mv_par05+"' " //  NFS Inicial
cQuery += CR + " AND SD2.D2_DOC <= '"+mv_par06+"' " //  NFS Final
cQuery += CR + " AND SD2.D_E_L_E_T_ = ' ' "
cQuery += CR + " AND SD2.D2_CF IN "+_cfventot+" "
IF MV_PAR08==1
	cQuery += CR + " AND B1.B1_TIPOP='C' "
ENDIF
IF MV_PAR08==2
	cQuery += CR + " AND B1.B1_TIPOP='A' "
ENDIF
IF !EMPTY(MV_PAR09)
	cQuery += CR + " AND B1.B1_FABRIC LIKE '%"+MV_PAR09+"%' "
ENDIF
if MV_PAR07==1
	cQuery += CR + " GROUP BY SD2.D2_FILIAL,SD2.D2_COD,SD2.D2_LOCAL,SD2.D2_DOC,D2_EMISSAO,D2_PEDIDO"
	cQuery += CR + " ORDER BY SD2.D2_FILIAL,SD2.D2_COD,SD2.D2_LOCAL,SD2.D2_DOC,D2_EMISSAO,D2_PEDIDO"
else
	cQuery += CR + " GROUP BY SD2.D2_FILIAL,SD2.D2_DOC,SD2.D2_LOCAL,SD2.D2_COD,D2_EMISSAO,D2_PEDIDO"
	cQuery += CR + " ORDER BY SD2.D2_FILIAL,SD2.D2_DOC,SD2.D2_LOCAL,SD2.D2_COD,D2_EMISSAO,D2_PEDIDO"
Endif


cQuery := strtran(cQuery,CR,"")
cQuery := CHANGEQUERY(cQuery)
TcQuery cQuery ALIAS TRB1 NEW

//TcSetField("TRB1", "D2_EMISSAO", "D", 8, 0)
TcSetField("TRB1", "QTDE", "N",13,2)
TcSetField("TRB1", "TOTAL", "N",13,2)
TcSetField("TRB1", "ICMS", "N",13,2)
TcSetField("TRB1", "PIS", "N",13,2)
TcSetField("TRB1", "COFINS", "N",13,2)

cQuer2 := CR + " SELECT D1_FILIAL,D1_COD,D1_LOCAL,D1_DOC,D1_DTDIGIT,D1_NFORI,D1_SERIORI,SUM(D1_QUANT) AS QTDE,SUM(D1_TOTAL) AS TOTAL,SUM(D1_VALICM) AS ICMS,SUM(D1_VALIMP5) AS COFINS,SUM(D1_VALIMP6) AS PIS "
cQuer2 += CR + " FROM "+RETSQLNAME('SD1')+" SD1 (nolock) "
cQuery += CR + " INNER JOIN ( SELECT B1_COD,B1_TIPOP FROM "+RETSQLNAME('SB1')+" (nolock) WHERE B1_FILIAL  = '"+ xFilial("SB1") +"' AND D_E_L_E_T_='' ) AS B1 ON B1_COD=SD1.D1_COD "
cQuer2 += CR + " WHERE SD1.D1_FILIAL  = '"+ xFilial("SD1") +"' " // Filial
cQuer2 += CR + " AND SD1.D1_COD  >= '"+mv_par01+"' " // Produto Inicial
cQuer2 += CR + " AND SD1.D1_COD   <= '"+mv_par02+"' " // Produto Final
cQuer2 += CR + " AND SD1.D1_DTDIGIT >= '"+dtos(mv_par03)+"' " // Data de digitacao NF Devol Inicial
cQuer2 += CR + " AND SD1.D1_DTDIGIT <= '"+dtos(mv_par04)+"' " // Data de Emissão NF Devol Final
cQuer2 += CR + " AND SD1.D_E_L_E_T_='' AND SD1.D1_TIPO='D' AND D1_CF IN "+_cfdevtot+" "
IF MV_PAR08==1
	cQuery += CR + " AND B1.B1_TIPOP='C' "
ENDIF
IF MV_PAR08==2
	cQuery += CR + " AND B1.B1_TIPOP='A' "
ENDIF
IF !EMPTY(MV_PAR09)
	cQuery += CR + " AND B1.B1_FABRIC LIKE '%"+MV_PAR09+"%' "
ENDIF
if MV_PAR07==1
	cQuer2 += CR + " GROUP BY SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_LOCAL,SD1.D1_DOC,D1_DTDIGIT,D1_NFORI,D1_SERIORI"
	cQuer2 += CR + " ORDER BY SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_LOCAL,SD1.D1_DOC,D1_DTDIGIT,D1_NFORI,D1_SERIORI"
else
	cQuer2 += CR + " GROUP BY SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_LOCAL,SD1.D1_COD,D1_DTDIGIT,D1_NFORI,D1_SERIORI"
	cQuer2 += CR + " ORDER BY SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_LOCAL,SD1.D1_COD,D1_DTDIGIT,D1_NFORI,D1_SERIORI"
Endif


cQuer2 := strtran(cQuer2,CR,"")
cQuer2 := CHANGEQUERY(cQuer2)
TcQuery cQuer2 ALIAS TRB2 NEW

//TcSetField("TRB2", "D1_DTDIGIT", "D", 8, 0)
TcSetField("TRB2", "QTDE", "N",13,2)
TcSetField("TRB2", "TOTAL", "N",13,2)
TcSetField("TRB2", "ICMS", "N",13,2)
TcSetField("TRB2", "PIS", "N",13,2)
TcSetField("TRB2", "COFINS", "N",13,2)

Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPERG ºAutor  ³Microsiga           º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria perguntas no SX1                                      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Do Produto"	 ,"Do Produto"  ,"Do Produto"	,"mv_ch1","C",15,0,0,"G","","SB1","",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Ate Produto"  ,"Ate Produto" ,"Ate Produto"	,"mv_ch2","C",15,0,0,"G","","SB1","",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Da Emis NFS"	 ,"Da Emis NFS"	 ,"Da Emis NFS"	,"mv_ch3","D",08,0,0,"G","",""	  ,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Ate Emis NFS" ,"Ate Emis NFS" ,"Ate Emis NFS","mv_ch4","D",08,0,0,"G","",""	  ,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Da NF Saida"	 ,"Da NF Saida"	 ,"Da NF Saida"	,"mv_ch5","C",09,0,0,"G","","SF2","",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Ate NF Saida" ,"Ate NF Saida" ,"Ate NF Saida","mv_ch6","C",09,0,0,"G","","SF2","",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Ordena Por  " ,"Ordena Por  " ,"Ordena Por  ","mv_ch7","N",01,0,0,"C","",""	  ,"",,"mv_par07","Produto","","","","Nota","","","","","","","","","","","")
PutSX1(cPerg,"08","Tipo Produto" ,"Tipo Produto" ,"Tipo Produto","mv_ch8","N",01,0,0,"C","",""	  ,"",,"mv_par08","Aparelho","","","","Acessório","","","Ambos","","","","","","","","")
PutSX1(cPerg,"09","Fabricante  " ,"Fabricante  " ,"Fabricante  ","mv_ch9","C",06,0,0,"G","","Z6" ,"",,"mv_par09","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"10","Div. Negocio" ,"Div. Negocio" ,"Div. Negocio","mv_chA","C",02,0,0,"G","","ZM" ,"",,"mv_par10","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"11","Digite Div. Neg.","Digite as Div. Neg.","Digite as Div. Neg.","mv_chB","C",15,0,0,"G","","" ,"",,"mv_par11","","","","","","","","","","","","","","","","")
Return Nil





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Getcompra(_cprod,_demis,_clocal)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aArea  := GetArea()
Local _cprodnew:= Space(15)


if select("QrySD1") > 0
	QrySD1->(dbCloseArea())
endif

cQuery := " SELECT SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,MAX(SD1.D1_DTDIGIT) DTDIGIT "
cQuery += " FROM "+RETSQLNAME('SD1')+" SD1 (nolock) "
cQuery += " INNER JOIN "+RETSQLNAME('SF4')+" AS SF4 (nolock) ON D1_TES=SF4.F4_CODIGO "
cQuery += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' "
cQuery += " AND SD1.D1_LOCAL = '"+_cLocal+"' "
cQuery += " AND SD1.D_E_L_E_T_ <> '*' AND SD1.D1_COD = '"+_cProd+"' "
cQuery += " AND SD1.D1_DTDIGIT <= '"+DTOS(_Demis)+"'"
cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += " AND SF4.F4_PODER3 = 'N' AND SF4.D_E_L_E_T_ <> '*' AND SD1.D1_TIPO IN ('N') AND SF4.F4_TEXTO LIKE '%COMPR%' "
cQuery += " GROUP BY SD1.D1_DTDIGIT,SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA "

TCQUERY cQuery ALIAS "QrySD1" NEW


if !QrySD1->(EOF())
	_cNFSD1:=QrySD1->D1_DOC+SUBSTR(QrySD1->D1_SERIE,1,3)+QrySD1->D1_FORNECE+D1_LOJA
else
	
	QrySD1->(dbCloseArea())
	
	_cprodnew:="Z"+SUBSTR(_cprod,2,14)
	cQuery := " SELECT SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,MAX(SD1.D1_DTDIGIT) DTDIGIT "
	cQuery += " FROM "+RETSQLNAME('SD1')+" SD1 (nolock) "
	cQuery += " INNER JOIN "+RETSQLNAME('SF4')+" AS SF4 (nolock) ON D1_TES=SF4.F4_CODIGO "
	cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "
	cQuery += " AND SD1.D1_LOCAL IN ('80','81') "
	cQuery += " AND SD1.D_E_L_E_T_ <> '*' AND SD1.D1_COD = '"+_cprodnew+"' "
	cQuery += " AND SD1.D1_DTDIGIT <= '"+DTOS(Ctod(_Demis))+"' "
	cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
	cQuery += " AND SF4.F4_PODER3 = 'N' AND SF4.D_E_L_E_T_ <> '*' AND SD1.D1_TIPO IN ('N') AND SF4.F4_TEXTO LIKE '%COMPR%' "
	cQuery += " GROUP BY SD1.D1_DTDIGIT,SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA "
	
	
	TCQUERY cQuery ALIAS "QrySD1" NEW
endif

	if !QrySD1->(EOF())
		_cNFSD1:=QrySD1->D1_DOC+SUBSTR(QrySD1->D1_SERIE,1,3)+QrySD1->D1_FORNECE+D1_LOJA
/*  else	// Retirada mensagem - Luiz Ferreira 31/10/2008
        _cNFSD1:=""	 
          alert("NF de compra nao encontrada para o produto : "+_cprod+ "!") 
*/
Endif

TCSETFIELD( "QrySD1","DTDGIT","D")
dUltemis := QrySD1->DTDIGIT

DBSelectArea('QrySD1')
//DBCloseArea('QrySD1')     
QrySD1->(DBCloseArea())     
RestArea(aArea)
Return(_cNFSD1)


//********************************
//********************************
//********************************
//********************************
STATIC FUNCTION TESTE()

Local cQry := ""
cQry := "  " 
cQry += "  " 
cQry += "  " 
cQry += "  "

if nOrder == 1
	cQry += "  ORDER BY SD1.D1_DOC "
ELSE
	CqRY += " ORDER BY SC5.C5_DIVNEG "
ENDIF
 





dbusearea(tcgenqry(CQRY),"TMP")
dbselectarea("TMP")
DBGOTOP()

//WHILE 


RETURN(NIL)