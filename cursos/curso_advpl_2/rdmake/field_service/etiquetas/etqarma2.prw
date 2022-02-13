#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQARM2  บAutor  ณ Edson Rodrigues    บ Data ณ  06/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para imprimir etiquetas de Armazenagem apos       บฑฑ
ฑฑบ          ณ ter confirmado a NFE.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ETQARM2()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Impressใo de etiquetas para a Armazenagem "
Local cDesc1  := "Este programa tem o objetivo de imprimir as etiquetas de  "
Local cDesc2  := "Armazenagem ap๓s a inclusใo da Nota Fiscal de Entrada."
Local cDesc3  := "Impressora T้rmica: Zebra "
Local cDesc4  := "Etiqueta: 100 x 144 mm "

Private cPerg := "ETQARM"

u_GerA0003(ProcName())

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| ETQRARMZ(@lEnd)}, "Aguarde...","Gerando os dados para impressใo das etiquetas ...", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQRARMZ บAutor  ณ M.Munhoz - ERP PLUSบ Data ณ  16/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ETQRARMZ(lEnd)

local _cQuery   := ""
local CR        := chr(13) + chr(10)
local _aImpEtq  := {}
local _nReg     := 0
local _aImpEtiq := {} 
Local _cdoc     := MV_PAR01
Local _cserie   := MV_PAR02
Local _cfornec  := MV_PAR03
Local _cloja    := MV_PAR04
Local _cest     :=""
Local _ctipo    :="B"
Local _nqtlotcx :=0

private cPerg := "ETQARM"     

SF1->(dbSetOrder(1)) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
IF  SF1->(DbSeek(xfilial("SF1") + _cdoc + _cserie + _cfornec + _cloja +_ctipo ))
       _cest:=SF1->F1_EST
		ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI

		// Posiciona no arquivo de Entrada Massiva
		IF ZZ4->(dbSeek(xFilial("ZZ4")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		   _cctrlote:=POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_CTRLOT")                         	
		   _nqtlotcx:=POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_QTDLCX") 
		   _coperdesc:=ALLTRIM(ZZ4->ZZ4_OPEBGH)+"-"+POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_DESCRI") 
		             
          IF _cctrlote = "S"
             _aImpEtiq :=u_Etqarmz(_cdoc,_cserie,_cfornec,_cloja,_cest,_nqtlotcx)
             // Se matriz nao estiver vazia, executa funcao de impressao de etiquetas
             If len(_aImpEtiq) > 0 .and. ApMsgYesNo("O sistema enviarแ as etiquetas para impressora nesse momento. Confirma impressใo?","Impressใo de Etiquetas")
                U_Etqarmaz(_aImpEtiq)
             Endif
          Else
              ApMsgInfo("A operacao "+_coperdesc+"  que a NFE/SERIE "+alltrim(_cdoc)+" / "+_cserie+" entrou, nao controla lote Automatico","Sem Controle de lote para entrada Massiva !")
          Endif
        ELSE
             ApMsgInfo("Entrada Massiva nao Encontrada para a NFE/SERIE "+alltrim(_cdoc)+" / "+_cserie+".","Entr. Massiva nใo localizada!")
        ENDIF
ELSE
    ApMsgInfo("Nota Fiscal de Entrada nao Encontrada.","NFE nใo localizada!")
Endif

Return
                                                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEtqarmz   บAutor  ณ Edson Rodrigues    บ Data ณ  02/08/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para filtrar os produtos da nota fiscal e montar    บฑฑ
ฑฑบ          | um array com a quantidade de etiquetas a ser impressa      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Etqarmz(_cdoc,_cserie,_cfornec,_cloja,_cest,_nqtlotcx)

   Local _aselpdD1 := {}            
   Local _nQtRet   := 0
   Local _nqtdprod := 0
   Local _nsldprod := 0
   Local _nReg     := 0
   
   if select("QRYD1") > 0
	 QRYD1->(dbCloseArea())
   endif

   
   _cQryD1 := " SELECT D1_COD,D1_DOC,D1_SERIE,D1_LOCAL,D1_DTDIGIT,D1_XLOTE,SUM(D1_QUANT) QTDE "
   _cQryD1 += " FROM   "+RetSqlName("SD1")+" AS D1 (nolock) "
   _cQryD1 += " WHERE  D1_FILIAL = '"+xFilial("SD1")+"' AND "
   _cQryD1 += "        D1_DOC    = '"+_cdoc+"' AND "
   _cQryD1 += "        D1_SERIE  = '"+_cserie+"' AND "
   _cQryD1 += "        D1_FORNECE  = '"+_cfornec+"' AND "
   _cQryD1 += "        D1_LOJA     = '"+_cloja+"' AND "
   _cQryD1 += "        D1.D_E_L_E_T_  = '' "
   _cQryD1 += " GROUP BY D1_COD,D1_DOC,D1_SERIE,D1_LOCAL,D1_DTDIGIT,D1_XLOTE "
   _cQryD1 += " ORDER BY D1_COD,D1_DOC,D1_SERIE,D1_LOCAL,D1_DTDIGIT,D1_XLOTE "

   TCQUERY _cQryD1 NEW ALIAS "QRYD1"     
   TcSetField("QRYD1", "D1_DTDIGIT","D")


   QRYD1->(dbGoTop())


   // Contagem de registros para a Regua
   While !QRYD1->(eof())
	  _nReg++
	  QRYD1->(dbSkip())
   Enddo

   QRYD1->(dbGoTop())
   
   // Inicializa a regua de evolucao
   ProcRegua(_nReg)

   While QRYD1->(!eof()) 
		_nqtdprod := QRYD1->QTDE
		_lqtdmaior :=.f. 
   	    // Incrementa a regua
	    IncProc()
   
       If _nqtdprod > _nqtlotcx
          _lqtdmaior :=.t.
          _nsldprod :=_nqtdprod 
          While _lqtdmaior .and. _nsldprod > 0              
              _nQtRet   := iif(_nsldprod <= _nqtlotcx,_nsldprod,_nqtlotcx)
  	          If  _nQtRet > 0 
  	              AADD(_aselpdD1,{QRYD1->D1_COD,QRYD1->D1_DOC,QRYD1->D1_SERIE,QRYD1->D1_LOCAL,DTOC(QRYD1->D1_DTDIGIT),QRYD1->D1_XLOTE,_cest,_nQtRet})
     		      _lqtdmaior:= iif(_nsldprod <= _nqtlotcx,.f.,.t.)
     		      _nsldprod:=_nsldprod - _nQtRet
     		  Endif     
     	 Enddo	  		    
       Else
          AADD(_aselpdD1,{QRYD1->D1_COD,QRYD1->D1_DOC,QRYD1->D1_SERIE,QRYD1->D1_LOCAL,DTOC(QRYD1->D1_DTDIGIT),QRYD1->D1_XLOTE,_cest,_nqtdprod})       
       Endif 
      QRYD1->(dbskip()) 
   Enddo    

Return(_aselpdD1)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','NFE ?','NFE ?','NFE ?','mv_ch1','C',9,0,0,'G','','','','S','mv_par01','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'02','Serie ?','Serie ?','Serie ?','mv_ch2','C',3,0,0,'G','','','','S','mv_par02','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'03','Cliente ?','Cliente ?','Cliente ?','mv_ch3','C',6,0,0,'G','','SA1','','S','mv_par03','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'04','Loja ?','Loja ?','Loja ?','mv_ch4','C',2,0,0,'G','','','','S','mv_par04','','','','','','','','','','','','','','','','')
Return Nil