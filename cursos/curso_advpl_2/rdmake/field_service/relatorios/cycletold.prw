#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBGHRL01   บAutor  ณMicrosiga           บ Data ณ  19/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para geracao de planilha Excel com os dados de    บฑฑ
ฑฑบ          ณ entrada, processo e saida dos produtos para reparos.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function cycletold()

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio   "
Local cDesc2        := "para efetuar um controle da entrada, processo e saida"
Local cDesc3        := "dos produtos recebidos para reparos                  "
Local cPict         := ""
Local titulo        := "Relat๓rio Cycle Time"
Local nLin          := 80
Local imprime       := .T.
Local aOrd := {}
Local Cabec1        := "IMEI                 Carcaca              Novo SN         Produto         N.F.E.     Emissao  Entrada  Cliente              Val.Unit. Quant. Cliente Saida          Laboratorio     Num.OS  Status   Fase       "
Local Cabec2        := "LC Sint Fal A็ใo Pedido    Grupo                                                                                                                                  Entrada   Saida                               "
//                      12345678901234567890 12345678901234567890 12345678901234567890 123456789012345 123456/123 12/12/12 12/12/12 12345678901234567890 12.123,12 12.123 123456/123 12/12/12 12/12/12 12/12/12 12345678 Encerrado 1234567890
//                      12 000  123 456  123456/12 1234-12345678901234567890

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "G"
Private nomeprog    := "RL01"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RL01  "
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RL01"
Private cString     := "SD1"
private CR	 		:= chr(13) + chr(10)
private _lret       :=.t.                                    
private _csrvapl    :=ALLTRIM(GetMV("MV_SERVAPL"))


u_GerA0003(ProcName())

// Executa funcao para criar as perguntas (SX1) adicionais para o relatorio
CriaSX1()

pergunte(cPerg,.F.)

dbSelectArea("SD1")
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| fRl01A(Cabec1,Cabec2,Titulo,nLin,@_lret) },Titulo)

Return

//***********************************************************************
//mv_par01 -> Data entrada De
//mv_par02 -> Data entrada Ate
//mv_par03 -> Data saida De
//mv_par04 -> Data saida Ate
//mv_par05 -> Op็ใo de normal ou excel
//mv_par06 -> Almox De
//mv_par07 -> Cliente  
//mv_par08 -> Status (1 = Tudo, 2 = Com NF, 3 = Sem NF)
//mv_par09 -> Formulario Proprio?
//mv_par10 -> Dias para Bounce
//mv_par11 -> Nextel x Sony / 1 = Nextel , 2 = Sony/Ericsson
//mv_par12 -> Versao excel maior que 2003 ?/ 1 = Sim , 2 = Nใo
//***********************************************************************
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FRL01A   บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de processamento do Cycle Time                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRL01A(Cabec1,Cabec2,Titulo,nLin,_lret)

Local cAlias      := ALIAS()
Local aAlias      := {"SD1","SD2","SZ1","AB9","AA3","SA1","SB1","SBM","SC6"}
Local aAmb        := U_GETAMB( aAlias )
Local nTotal      := 0
private _cArqTrab := CriaTrab(,.f.)
private nConta    := 0



dbSelectArea("SC6")
DbSetOrder(13)  //C6_FILIAL+C6_NUMSERI

dbSelectArea("SA1")
DbSetOrder(1) //A1_FILIAL+A1_Cod+A1_Loja

dbSelectArea("SA2")
DbSetOrder(1) //A2_FILIAL+A2_Cod+A2_Loja

dbSelectArea("SD1")
DbSetOrder(6) //D1_FILIAL+DTOS(D1_DTDIGITE)+D1_NUMSEG

dbSelectArea("SB1")
DbSetOrder(1) //D1_FILIAL+D1_Cod

dbSelectArea("SBM")
DbSetOrder(1) //BM_FILIAL+BM_Grupo

dbSelectArea("SD2")
//SD2->(dbSetOrder(10)) // D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO) - Edson Rodrigues - 02/10/10
SD2->(DBOrderNickName('D2NUMSEMIS')) //D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO)

dbSelectArea("SF2")
DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

dbSelectArea("SZ1")
DbSetOrder(6) //Z1_FILIAL+Z1_CODBAR+Z1_TIPO

dbSelectArea("AB9")
DbSetOrder(5) //AB9_FILIAL+AB9_SN

dbSelectArea("AA3")
DbSetOrder(6) //AA3_FILIAL+AA3_NUMSER

if SD1->(!DbSeek(xFilial("SD1")+DTOS(mv_par01))) .and. SD1->D1_DTDIGIT > mv_par02
	MsgBox("Nใo Houve entradas no periodo selecionado","Critica Relat๓rio","ALERT")
	Return
endif

Processa( {|| u_qryCycle(mv_par01, mv_par02, mv_par03, mv_par04, mv_par05, mv_par06, mv_par07, mv_par08, mv_par09, mv_par10, mv_par11,mv_par12, .F.,@_lret )}, "Aguarde...","Filtrando E/S (SD1-SZ1) e AB9-Atend. Lab...", .T. )
//u_qryCycle(mv_par01, mv_par02, mv_par03, mv_par04, mv_par05, mv_par06, mv_par07, mv_par08, mv_par09, mv_par10, mv_par11,mv_par12, .F. )
If !_lret
	MsgBox("Nใo Houve movimenta็ใo no periodo selecionado","Critica Relat๓rio","ALERT")
	Return
Endif
 

SetRegua(nConta)

TRB->(dbGoTop())
While TRB->(!eof())         

    iF mv_par12==1
      _diadoca:=SUBSTR(TRB->ENTRDOCA,7,2)
      _mesdoca:=SUBSTR(TRB->ENTRDOCA,5,2)
      _anodoca:=SUBSTR(TRB->ENTRDOCA,1,4)
      _diaentr:=SUBSTR(TRB->ENTRADA,7,2)
      _mesentr:=SUBSTR(TRB->ENTRADA,5,2)
      _anoentr:=SUBSTR(TRB->ENTRADA,1,4)   
      _diaemis:=SUBSTR(TRB->SAIDDOCA,7,2)
      _mesemis:=SUBSTR(TRB->SAIDDOCA,5,2)
      _anoemis:=SUBSTR(TRB->SAIDDOCA,1,4)
	Endif 
	IncRegua()
	
	// Aborta impressao 
	If lAbortPrint
		@ nLin,00 pSay "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	// Imprime cabecalho
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	// Verifica data da ultima saida do IMEI
	 
	_dUltSai := iif(mv_par12==1,u_VerUltSai(TRB->IMEI,ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),u_VerUltSai(TRB->IMEI, TRB->ENTRADA))
	_nBounce := 0
	if !empty(_dUltSai)
		reclock("TRB",.f.)
		TRB->ULTSAIDA := iif(mv_par12==1,"20"+SUBSTR(dtoc(_dUltSai),7,2)+SUBSTR(dtoc(_dUltSai),4,2)+SUBSTR(dtoc(_dUltSai),1,2),_dUltSai)
		TRB->BOUNCE   := iif(mv_par12==1,iif(ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai > 0, ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai, 0),iif(TRB->ENTRADA - _dUltSai > mv_par10, TRB->ENTRADA - _dUltSai, 0))
		msunlock()
	endif

	// Identificacao da NF e DATA do Swap
	if mv_par11 <> 1 .and. !empty(TRB->NOVOSN)
		// Pesquiso o PV pelo IMEI novo do Swap para descobrir o numero + item do PV
		SC6->(DBOrderNickName('SC6IMEINOV'))//SC6->(dbSetOrder(11))  // C6_FILIAL + C6_IMEINOV + C6_NUM + C6_ITEM
		if SC6->(dbSeek(xFilial("SC6") + TRB->NOVOSN))
			while SC6->(!eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. alltrim(SC6->C6_IMEINOV) == alltrim(TRB->NOVOSN)
				SC5->(dbSetOrder(1))
				
				if MV_PAR12==2 
				   if SC5->(dbSeek(xFilial("SC5") + SC6->C6_NUM)) .and. SC5->C5_EMISSAO >= TRB->ENTRADA
					// Pesquiso a NF pelo numero do PV para descobrir o numero da NF que sofreu a saida do IMEI de SWAP
					_dsaidoca:= ctod("  /  /  ")
					SD2->(dbSetOrder(8))  // D2_FILIAL + D2_PEDIDO + D2_ITEMPV
					if SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM + SC6->C6_ITEM)) 
					   _dsaidoca := Posicione("SF2",1,xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_FORMUL,"F2_SAIROMA")
						while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_PEDIDO == SC6->C6_NUM .and. SD2->D2_ITEMPV == SC6->C6_ITEM
							if SD2->D2_EMISSAO >= TRB->ENTRADA
								reclock("TRB",.f.)
								TRB->NFNOVOSN := SD2->D2_DOC
								TRB->DTNFNSN  := iif(mv_par12==1,SUBSTR(DTOS(SD2->D2_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),5,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),1,4),SD2->D2_EMISSAO)
								TRB->DTSAINSN  :=iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
							    IF !EMPTY(SD2->D2_EMISSAO)
							     	IF !EMPTY(TRB->ENTRDOCA)
                           	     	  TRB->TEMPREP   := iif(mv_par12==1,iif(EMPTY(TRB->ENTRDOCA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca)),iif(EMPTY(TRB->ENTRDOCA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA))
                           	     	  TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
                           	        ELSE  	                                                                            
                           	          TRB->TEMPREP   := iif(mv_par12==1,iif(EMPTY(TRB->ENTRADA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),iif(EMPTY(TRB->ENTRADA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA))	   
                           	          TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
                                 	ENDIF   
                             	ENDIF 
								msunlock()
							endif
							SD2->(dbSkip())
						enddo
					endif
				   endif
				Else 
				  if SC5->(dbSeek(xFilial("SC5") + SC6->C6_NUM)) .and. DTOS(SC5->C5_EMISSAO) >= TRB->ENTRADA
					// Pesquiso a NF pelo numero do PV para descobrir o numero da NF que sofreu a saida do IMEI de SWAP
					_dsaidoca:= ctod("  /  /  ")
					SD2->(dbSetOrder(8))  // D2_FILIAL + D2_PEDIDO + D2_ITEMPV
					if SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM + SC6->C6_ITEM)) 
					   _dsaidoca := Posicione("SF2",1,xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_FORMUL,"F2_SAIROMA")
						while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_PEDIDO == SC6->C6_NUM .and. SD2->D2_ITEMPV == SC6->C6_ITEM
							if DTOS(SD2->D2_EMISSAO) >= TRB->ENTRADA
								reclock("TRB",.f.)
								TRB->NFNOVOSN := SD2->D2_DOC
								TRB->DTNFNSN  := iif(mv_par12==1,SUBSTR(DTOS(SD2->D2_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),5,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),1,4),DTOC(SD2->D2_EMISSAO))
								TRB->DTSAINSN  :=iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
							    IF !EMPTY(SD2->D2_EMISSAO)
							     	IF !EMPTY(TRB->ENTRDOCA)
                           	     	  TRB->TEMPREP   := iif(mv_par12==1,iif(EMPTY(TRB->ENTRDOCA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca)),iif(EMPTY(TRB->ENTRDOCA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA))
                           	     	  TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
                           	        ELSE  	                                                                            
                           	          TRB->TEMPREP   := iif(mv_par12==1,iif(EMPTY(TRB->ENTRADA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),iif(EMPTY(TRB->ENTRADA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA))	   
                           	          TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
                                 	ENDIF   
                             	ENDIF 
								msunlock()
							endif
							SD2->(dbSkip())
						enddo
					endif
				  endif
				Endif     
				SC6->(dbSkip())
			enddo
		endif
	endif

    If  mv_par11 == 3	
       _cAB9Sint := iif(!Empty(TRB->SINTOMA),STRZERO(TRB->SINTOMA,3),"---")
	   _cAB9Falh := iif(!Empty(TRB->FALHA),STRZERO(TRB->FALHA,3),"---")
	   _cAB9Acao := iif(!Empty(TRB->ACAO),STRZERO(TRB->ACAO,3),"---")
	

//	_cNumSer := TRB->IMEI
/*
	@ nLin,000 pSay TRB->IMEI + " " + TRB->CARCACA + " " + TRB->NOVOSN + " " + TRB->PRODUTO + " " + TRB->NFE + ;
	IIF(!empty(TRB->SERIENF),"/"+TRB->SERIENF+" ",Space(5) ) + Transf(TRB->EMISENT,"@D") + " " + Transf(TRB->ENTRADA,"@D") + " " + ;
	TRB->NOMEENT + " " + Transf(TRB->VALUNIT,"@E 99,999.99") + " " + ;
	Transf(TRB->QUANT,"@E 99,999") + " " + ;  //TRB->NOMESAI + " " + 
	Transf(TRB->EMISSAI,"@D") + " " + ;
	Transf(TRB->ENTRCHAM,"@D") + " " + TRB->OS + " " + TRB->STATUS + " " + ;
	TRB->DESCFASE
	nLin++
	@ nLin,000 pSay TRB->ARMAZEM + " " + _cAB9Sint + "  " + _cAB9Falh + " " + _cAB9Acao + " " + TRB->PEDIDO + " " + TRB->GRUPO
*/
	@ nLin,000 pSay TRB->ARMAZEM + " " + _cAB9Sint + "  " + _cAB9Falh + " " + _cAB9Acao + " " + TRB->PEDIDO + " " + TRB->GRUPO
	
	Endif   
	nLin++
	TRB->(dbSkip())

	nLin++
	
Enddo

_cArq  := "cycleold_"+Alltrim(cUserName)+".csv"
_lOPen := .f.   
_cArqSeq   :=CriaTrab(,.f.)
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

dbselectarea("TRB")
TRB->(dbgotop())
copy to &(cStartPath+_cArqSeq)
TRB->(dbCloseArea())

_cArqTmp := lower(AllTrim(__RELDIR)+_cArq)
cArqorig := cStartPath+_cArqSeq+".dtc"


//Incluso Edson Rodrigues - 25/05/10
lgerou:=U_CONVARQ(cArqorig,_cArqTmp)

If lgerou                              
   If !ApOleClient( 'MsExcel' )
      MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
   Else
      ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )           
   EndIf
	
Else
  msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
Endif

//Copy to &_cArqTmp VIA "DBFCDXADS"
//ApMsgInfo("Fim do Processamento. A planilha "+_cNomePlan+" foi gerada em " + __reldir)


/*
if nConta > 0
	While !_lOpen
		if file(__reldir+_cArq) .and. ferase(__reldir+_cArq) == -1
			if !ApMsgYesNo("O arquivo " + _cArq + " nใo pode ser gerado porque deve estar sendo utilizado. Deseja tentar novamente? " )
				_lOpen := .t.
				ApMsgInfo("O arquivo Excel nใo foi gerado. ")
			endif
		else
			dbselectarea("TRB")
			copy to &(__reldir+_cArq)
			ShellExecute( "Open" , "\\BGH001\MP8\PROTHEUS_DATA\"+__reldir+_cArq ,"", "" , 3 )
//			ShellExecute( "Open" , "C:\AP8\PROTHEUS_DATA\BGH\"+__reldir+_cArq ,"", "" , 3 )
			_lOpen := .t.
		endif
	EndDo
else
	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
endif

*/                      

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

U_RESTAMB( aAmb )
DBSELECTAREA( cAlias )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FRL01B   บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui caracteres invalidos de uma palavra.                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRL01B(cPalavra)
Local cValido  := "QWERTYUIOPASDFGHJKLZXCVBNM1234567890/- ",;
cPalavra := Upper(cPalavra),;
i        := 0,;
cPalNovo := ""

For i:=1 to Len(cPalavra)
	
	IF Substr(cPalavra,I,1)$cValido
		cPalNovo += Substr(cPalavra,I,1)
	endif
	
Next

if len(cPalNovo)<20
	cPalNovo += Space(20-len(cPalNovo))
endif

Return(cPalNovo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VERULTSAIบAutor  ณM.Munhoz - ERPPLUS  บ Data ณ  15/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para verificar data de ultima saida do IMEI para    บฑฑ
ฑฑบ          ณ calcular BOUNCE.                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VerUltSai(_cSaiIMEI, _dEmisSai)

local _dSaida   := ctod("  /  /  ")
local _aAreaSD2 := SD2->(GetArea())

dbSelectArea("SD2")
//SD2->(dbSetOrder(10)) // D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO) - Edson Rodrigues - 02/10/10
SD2->(DBOrderNickName('D2NUMSEMIS')) //D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO)
if SD2->(dbSeek(xFilial("SD2") + _cSaiIMEI))
	while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_NUMSERI == _cSaiIMEI .and. SD2->D2_EMISSAO < _dEmisSai
		_dSaida := SD2->D2_EMISSAO
		SD2->(dbSkip())
	enddo
endif

restarea(_aAreaSD2)

return(_dSaida)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas utilizadas  บฑฑ
ฑฑบ          ณ pela rotina.                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','Entrada de'			,'Entrada de'			,'Entrada de'			,'mv_ch1','D', 8,0,0,'G','',''		,'','S','mv_par01',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'02','Entrada Ate'			,'Entrada Ate'			,'Entrada Ate'			,'mv_ch2','D', 8,0,0,'G','',''		,'','S','mv_par02',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'03','Saida de'			,'Saida de'				,'Saida de'				,'mv_ch3','D', 8,0,0,'G','',''		,'','S','mv_par03',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'04','Saida ate'			,'Saida ate'			,'Saida ate'			,'mv_ch4','D', 8,0,0,'G','',''		,'','S','mv_par04',''		,''			,''			,'',''				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'05','Padrao'				,'Padrao'				,'Padrao'				,'mv_ch5','C', 1,0,2,'C','',''		,'','S','mv_par05','Normal'	,'Normal'	,''			,'','Excel'			,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'06','Almoxarifados'		,'Almoxarifados'		,'Almoxarifados'		,'mv_ch6','C',15,0,0,'G','',''		,'','S','mv_par06',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'07','Cliente ?'			,'Cliente ?'			,'Cliente ?'			,'mv_ch7','C', 6,0,0,'G','','CLI'	,'','S','mv_par07',''		,''			,''			,'',''				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'08','Status ?'			,'Status ?'				,'Status ?'				,'mv_ch8','N', 1,0,1,'C','',''		,'','S','mv_par08','Tudo'	,'Tudo'		,'Tudo'		,'','Com NF'		,'Com NF'		,'Com NF'		,'Sem NF'	,'Sem NF'	,'Sem NF'	,'','','','','','')
PutSX1(cPerg,'09','Formulario Proprio?'	,'Formulario Proprio ?'	,'Formulario Proprio ?'	,'mv_ch9','N', 1,0,3,'C','',''		,'','S','mv_par09','Sim'	,'Sim'		,'Sim'		,'','Nao'			,'Nao'			,'Nao'			,'Ambos'	,'Ambos'	,'Ambos'	,'','','','','','')
PutSX1(cPerg,'10','Dias para Bounce'	,'Dias para Bounce'		,'Dias para Bounce'		,'mv_cha','N', 3,0,0,'G','',''		,'','S','mv_par10',''		,''			,''			,'',''				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'11','Nextel, Sony, Todos'	,'Nextel, Sony, Todos'	,'Nextel, Sony, Todos'	,'mv_chb','N', 1,0,0,'C','',''		,'','S','mv_par11','Nextel'	,'Nextel'	,'Nextel'	,'','Sony/Ericsson'	,'Sony/Ericsson','Sony/Ericsson','Todos'	,'Todos'	,'Todos'	,'','','','','','')
PutSX1(cPerg,'12','Versใo Excel maior que 2003 ?'	,'Versใo Excel maior que 2003 ?'	,'Versใo Excel maior que 2003 ?'	,'mv_chc','N', 1,0,0,'C','',''		,'','S','mv_par12','Sim'	,'Sim'	,'Sim'	,'','Nao','Nao','Nao',''	,''	,''	,'','','','','','')

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QRYCICLE บAutor  ณ M.Munhoz - ERPPLUS บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para desenvolver a query utilizada no CycleTime     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function qryCycle(mv_par01, mv_par02, mv_par03, mv_par04, mv_par05, mv_par06, mv_par07, mv_par08, mv_par09, mv_par10, mv_par11,mv_par12, _lJob,_lret )

local _cQuery   := _cFilCliente := _cFilStatus := _cFilFormul := " "
local _cNfeImei := ""    
Local _nRegab9  :=0
Local _nRegtrb  :=0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Trata alguns parametros para montagem do filtro                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !empty(mv_par07) 
	_cFilCliente := " AND D1_FORNECE = '"+MV_PAR07+"' "
EndIf

If mv_par08 == 2 // COM NF DE SAIDA
	_cFilStatus := " AND D2_DOC IS NOT NULL "
ElseIf mv_par08 == 3 // SEM NF DE SAIDA 
	_cFilStatus := " AND D2_DOC IS NULL "
EndIf

if mv_par09 == 1 // Apenas formulario proprio
	_cFilFormul := " AND D1_FORMUL = 'S' "
elseif mv_par09 == 2 // Apenas formulario nao proprio
	_cFilFormul := " AND D1_FORMUL <> 'S' "
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a query para utilizacao pelo CYCLETIME                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery := CR + " SELECT D1_COD 'PRODUTO', D1_LOCAL 'ARMAZEM', NFE = D1_DOC, "
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	_cQuery += CR + " D1_FORMUL 'FORMUL', "
endif
if mv_par11 == 3 // TODOS
	_cQuery += CR + " D1_SERIE  'SERIENF', "
endif
_cQuery += CR + " D1_EMISSAO 'EMISENT',D1_DTDOCA 'ENTRDOCA', D1_HRDOCA 'HORADOCA',  /*F2_SAIROMA*/ SPACE(08) AS 'SAIDDOCA',D1_DTDIGIT 'ENTRADA',"
_cQuery += CR + "  ULTSAIDA = '00000000', BOUNCE = 0,D1_VUNIT 'VALUNIT', D1_QUANT 'QUANT' ,GRUPO = B1_GRUPO,D1_FORNECE 'CLIENTE', "
_cQuery += CR + "  D1_LOJA 'LOJA', A1E.A1_NREDUZ 'NOMEENT', A1E.A1_EST 'ESTADO',Z1_CODBAR  AS 'IMEI',  Z1_SIM	 AS 'CARCACA', "
_cQuery += CR + " SPACE(06) AS PEDIDO /*= CASE WHEN D2.D2_PEDIDO IS NOT NULL THEN D2.D2_PEDIDO WHEN C6_NUM IS NOT NULL THEN C6_NUM ELSE Z1_PV END, */, "
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	_cQuery += CR + "SPACE(20) AS NOMESAI /*= CASE WHEN A1S.A1_NREDUZ IS NOT NULL THEN A1S.A1_NREDUZ ELSE D2.D2_CLIENTE+'/'+D2.D2_LOJA+SPACE(11) END, */, "
endif
_cQuery += CR + " SPACE(12) AS NFBGH /*= D2.D2_DOC+'/'+D2.D2_SERIE */, "
_cQuery += CR + "   /*D2.D2_EMISSAO*/ SPACE(08) AS 'EMISSAI', "
_cQuery += CR + "   /*D2.D2_TES*/ SPACE(03) AS 'TES',         "
_cQuery += CR + "  Z1_OS AS 'OS',                             "
_cQuery += CR + "  SPACE(08) AS ENTRCHAM/*=AB9.AB9_DTCHEG*/,  "
_cQuery += CR + "  SPACE(12) AS FASE /*=AB9.AB9_LINHA*/,      "
_cQuery += CR + "  /*X5.X5_DESCRI*/ SPACE(30) AS 'DESCFASE',  "
_cQuery += CR + "  SPACE(08) AS DTENCCHA /*= AB9.AB9_DTSAID*/,"
_cQuery += CR + "  SPACE(05) AS HRENCCHA /*=AB9.AB9_HRSAID*/, "
_cQuery += CR + "  SPACE(10) AS STATUS /*= CASE WHEN AB9.AB9_TIPO = 1  THEN 'Encerrado' WHEN AB9.AB9_TIPO = 2 AND D2.D2_DOC IS NOT NULL THEN 'Encerrado' WHEN AB9.AB9_TIPO = 2 AND D2.D2_DOC IS NULL THEN 'Aberto' "
_cQuery += CR + "                 WHEN AB9.AB9_TIPO IS NULL AND D2.D2_DOC IS NOT NULL  THEN 'Encerrado' ELSE '------' END, */,"
_cQuery += CR + "  X52.X5_DESCRI 'MOTDOCA' ,D1_XLOTE 'LOTE', "
if mv_par11 <> 2 // Nextel e outros
	_cQuery += CR + "        SPACE(06) AS NEXTSIN/*=AB9.AB9_NEXSIN*/, " 
	_cQuery += CR + "        SPACE(05) AS NEXTSOL/*=AB9.AB9_RESOLU*/, " 
endif
if mv_par11 == 3 // todos
	_cQuery += CR + "        '000' AS SINTOMA/*= AB9.AB9_SYMPTO*/, "
	_cQuery += CR + "        '000' AS FALHA/*= AB9.AB9_FAULID*/,   "
	_cQuery += CR + "        '000' AS ACAO/*= AB9.AB9_ACTION*/ ,   "
	_cQuery += CR + "        SPACE(15) AS PECA1/*= AB9.AB9_PARTN1*/,   "
    _cQuery += CR + "        SPACE(15) AS PECA2/*= AB9.AB9_PARTN2*/,   "
    _cQuery += CR + "        SPACE(15) AS PECA3/*= AB9.AB9_PARTN3*/,   "
    _cQuery += CR + "        SPACE(15) AS PECA4/*= AB9.AB9_PARTN4*/,   "
	_cQuery += CR + "        SPACE(04) AS DEFEITO/*= AB9.AB9_DEFECT*/, "
	_cQuery += CR + "        SPACE(04) AS RESOLUCA/*= AB9.AB9_RESOLU*/,"
	_cQuery += CR + "        SPACE(05) AS MOTOSIN/*= AB9.AB9_MOTSIN*/, "
	_cQuery += CR + "        SPACE(05) AS MOTOSOL/*= AB9.AB9_NEXSOL*/, "
	_cQuery += CR + "        SPACE(15) AS AB9_NRCHAM/*=AB9.AB9_NRCHAM*/," 
endif
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	_cQuery += CR + "       SPACE(15) AS NOVOSN /*= AB9.AB9_NOVOSN*/, " 
	_cQuery += CR + "        NFNOVOSN = '      ', DTNFNSN = '00000000',DTSAINSN = '00000000', "
endif
_cQuery += CR + "        Z1_OPER 'GARANTIA', "
_cQuery += CR + "        SPACE(90) AS CRITICA/*=CASE WHEN AB9.AB9_TIPO = 1 AND D2.D2_DOC IS NULL   THEN 'CHAMADO ENCERRADO - FALTA EMISSAO DE NF DE SAIDA'  "
_cQuery += CR + "                WHEN D2.D2_DOC IS NOT NULL AND Z1_CODBAR<>D2_NUMSERI THEN 'IMEI DOC.ENTR <> IMEI NF_SAIDA' " 
_cQuery += CR + "                WHEN D2.D2_DOC IS NULL AND C6_NUM IS NOT NULL AND Z1_CODBAR<>C6_NUMSERI THEN 'IMEI DOC.ENTR <> IMEI PED_SAIDA'  " 
_cQuery += CR + "                WHEN D2.D2_DOC IS NULL AND D2.C6_OS<>Z1_OS THEN 'NUM OS DOC.ENTR <> NUM OS PED_SAIDA'  " 
_cQuery += CR + "                WHEN AB9.AB9_SN IS NOT NULL AND D2.D2_DOC IS NULL AND (AB9.AB9_CODCLI<>D1_FORNECE OR AB9.AB9_CODCLI<>Z1_CODCLI) THEN 'COD.CLIENTE DOC.ENTR <> COD.CLIENTE ENT.MASSIVA,OS e ATENDIMENTO' "
_cQuery += CR + "                WHEN AB9.AB9_SN IS NOT NULL AND D2.D2_DOC IS NOT NULL AND (AB9.AB9_CODCLI<>D1_FORNECE OR AB9.AB9_CODCLI<>Z1_CODCLI) THEN 'COD.CLIENTE ENT.MASSIVA <> ATENDIMENTO' "
_cQuery += CR + "                WHEN AB9.AB9_SN IS NOT NULL AND AB9.AB9_LINHA=''  THEN  'ATENDIMENTO SEM FASE PREECHIDO' " 
_cQuery += CR + "                WHEN AB9.AB9_SN IS NOT NULL AND D2.D2_DOC IS NOT NULL AND D2_ITEMORI<>D1_ITEM  AND D2_EMISSAO >= D1_EMISSAO AND D2_IDENTB6=D1_NUMSEQ THEN 'NUM DO ITEM ORIGEM <> NUM DO ITEM ORIGEM SAIDA' "  
_cQuery += CR + "                WHEN AB9.AB9_SN IS NOT NULL AND D2.D2_DOC IS NOT NULL AND D2_NFORI<>D1_DOC AND D2_EMISSAO >= D1_EMISSAO AND D2_IDENTB6=D1_NUMSEQ THEN 'NUM DA NFENTRADA <> NUM DA NF-ORIGEM SAIDA' " 
_cQuery += CR + "                WHEN AB9.AB9_SN IS NOT NULL AND D2.D2_DOC IS NOT NULL AND D2_LOCAL<>D1_LOCAL AND D2_EMISSAO >= D1_EMISSAO AND D2_IDENTB6=D1_NUMSEQ THEN 'ARMAZEN DA NFENTRADA <> ARMAZEN NF SAIDA' " 
_cQuery += CR + "                WHEN AB9.AB9_SN IS NOT NULL AND D2.D2_DOC IS NOT NULL AND D2_SERIORI<>D1_SERIE AND D2_EMISSAO >= D1_EMISSAO AND D2_IDENTB6=D1_NUMSEQ THEN 'SERIE DA NFENTRADA <> NUM DA SERIE NF-ORIGEM SAIDA' "
_cQuery += CR + "                WHEN AB9.AB9_SN IS NOT NULL AND Z1_OS<>AB9.NUMOS THEN 'NUM OS ENTR. MASSIVA <> NUM OS ATENDIMENTO' " 
_cQuery += CR + "                WHEN D1_DTDIGIT>D2_EMISSAO THEN 'DT DIGITACAO NF-ENTRADA MENOR DT EMISSAO NF-SAIDA' ELSE '' END , */,"
_cQuery += CR + "                TEMPREP = 0,Z1_CODCLI,Z1_LOJA,C6_NUM,C6_NUMSERI,C6_NUMOS,D1_ITEM,D1_SERIE,D1_NUMSEQ,D1_IDENTB6,D1_LOCAL,Z1_PV "
_cQuery += CR + " FROM   "+RetSqlName("SD1")+" AS D1 (NOLOCK) "
_cQuery += CR + " JOIN   "+RetSqlName("SA1")+" AS A1E (NOLOCK) "
_cQuery += CR + " ON     A1E.A1_FILIAL = '"+xFilial("SA1")+"' AND A1E.A1_COD = D1_FORNECE AND A1E.A1_LOJA = D1_LOJA AND A1E.D_E_L_E_T_ = '' "
_cQuery += CR + " JOIN   "+RetSqlName("SB1")+" AS B1E (NOLOCK) "
_cQuery += CR + " ON     B1E.B1_FILIAL = '"+xFilial("SB1")+"' AND B1E.B1_COD = D1_COD AND B1E.D_E_L_E_T_ = '' "
_cQuery += CR + " JOIN   "+RetSqlName("SZ1")+" AS Z1 (NOLOCK) "
_cQuery += CR + " ON     Z1_FILIAL  = '"+xFilial("SZ1")+"' AND Z1_CODBAR = D1_NUMSER AND Z1_TIPO IN ('E','T','X') AND Z1_NFE = D1_DOC AND Z1_SERIE = D1_SERIE AND Z1.D_E_L_E_T_ = '' "
_cQuery += CR + " AND    D1_COD = Z1_CODPRO AND Z1_OS <> '' AND Z1_CODCLI <> '' "
_cQuery += CR + " LEFT OUTER JOIN   "+RetSqlName("SC6")+" AS C6 (NOLOCK) "
_cQuery += CR + " ON     C6_FILIAL  = '"+xFilial("SC6")+"' AND C6_NUMSERI = D1_NUMSER AND C6_IDENTB6 = D1_IDENTB6 AND C6_QTDVEN > C6_QTDENT AND C6.D_E_L_E_T_ = '' "
//_cQuery += CR + " LEFT OUTER JOIN   
//_cQuery += CR + "                     SELECT CH2.*, LEFT(AB9_NUMOS,6) NUMOS "
//_cQuery += CR + "                     FROM   ( SELECT MAX(R_E_C_N_O_) 'AB9RECNO'  "
//_cQuery += CR + "                              FROM   "+RetSqlName("AB9")+"  "
//_cQuery += CR + "                              WHERE  AB9_FILIAL = '"+xFilial("AB9")+"' AND D_E_L_E_T_ = '' AND AB9_DTCHEG >= '"+DTOS(MV_PAR01)+"' "
//_cQuery += CR + "                              GROUP BY AB9_FILIAL, AB9_SN, AB9_NUMOS, AB9_NRCHAM  "
//_cQuery += CR + "     ( SELECT * FROM "+RetSqlName("AB9")+"  AS CH2 (NOLOCK) INNER JOIN "
//_cQuery += CR + "         (SELECT AB9_FILIAL FILIAL, AB9_SN SN, AB9_NUMOS NUMOS, AB9_NRCHAM NRCHAM ,MAX(R_E_C_N_O_) AS AB9RECNO  "
//_cQuery += CR + "          FROM "+RetSqlName("AB9")+" (NOLOCK) "
//_cQuery += CR + "          WHERE AB9_FILIAL='"+xFilial("AB9")+"' AND AB9_DTCHEG > '"+DTOS(MV_PAR01)+"'  AND D_E_L_E_T_='' "
//_cQuery += CR + "          GROUP BY AB9_FILIAL, AB9_SN, AB9_NUMOS, AB9_NRCHAM ) AS CH1 "
//_cQuery += CR + "          ON AB9RECNO=R_E_C_N_O_  "
//_cQuery += CR + "       WHERE CH2.AB9_FILIAL='"+xFilial("AB9")+"'  AND AB9_DTCHEG >'"+DTOS(MV_PAR01)+"' AND D_E_L_E_T_='' ) AS AB9 "
//_cQuery += CR + "   ON  LEFT(AB9.AB9_SN,15) = LEFT(D1_NUMSER,15) AND LEFT(AB9.NUMOS,6) = LEFT(Z1_OS,6) AND AB9.AB9_CODCLI = CASE WHEN AB9.AB9_CODCLI=D1_FORNECE THEN D1_FORNECE ELSE Z1_CODCLI  END "
//_cQuery += CR + "       AND AB9.AB9_LOJA = CASE WHEN AB9.AB9_CODCLI=D1_FORNECE THEN D1_LOJA  ELSE Z1_LOJA  END "
//_cQuery += CR + " LEFT OUTER JOIN  (SELECT SD2.D2_FILIAL,SD2.D2_DOC,SD2.D2_COD,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_EMISSAO,SD2.D2_SERIE,SD2.D2_NUMSERI,SD2.D2_SERIORI,SD2.D2_NFORI,SD2.D2_ITEMORI,SD2.D2_TES,SD2.D2_PEDIDO,SD2.D_E_L_E_T_,SD2.D2_LOCAL,D2_IDENTB6,SC6.C6_OS "
//_cQuery += CR + "                   FROM "+RetSqlName("SD2")+" AS SD2 (NOLOCK) "
//_cQuery += CR + "                          INNER JOIN (SELECT C6_FILIAL,C6_NUM,C6_NUMSERI,C6_ITEM,LEFT(C6_NUMOS,6) AS C6_OS "
//_cQuery += CR + "                                      FROM "+RetSqlName("SC6")+" (NOLOCK)  WHERE C6_FILIAL  = '"+xFilial("SC6")+"' AND D_E_L_E_T_='' ) AS SC6 
//_cQuery += CR + "                          ON SD2.D2_FILIAL=C6_FILIAL AND SD2.D2_PEDIDO=C6_NUM AND SD2.D2_ITEMPV=C6_ITEM AND SD2.D2_NUMSERI=C6_NUMSERI "
//_cQuery += CR + "                    WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D2_EMISSAO>='"+DTOS(MV_PAR01)+"' AND SD2.D2_EMISSAO<='"+DTOS(MV_PAR04)+"' AND SD2.D_E_L_E_T_ = '') AS D2  "
//_cQuery += CR + " ON  D2_NUMSERI = D1_NUMSER AND Z1_OS+Z1_CODBAR=CASE WHEN Z1_OS+Z1_CODBAR=C6_OS+D2_NUMSERI THEN C6_OS+D2_NUMSERI ELSE AB9.NUMOS+AB9.AB9_SN END "
//_cQuery += CR + "     AND D2_ITEMORI=CASE WHEN D2_ITEMORI=D1_ITEM THEN D1_ITEM ELSE D2_ITEMORI END AND D2_NFORI = CASE WHEN D2_NFORI=D1_DOC THEN D1_DOC ELSE D2_NFORI END "
//_cQuery += CR + "     AND D2_LOCAL=CASE WHEN D1_LOCAL=D2_LOCAL THEN D1_LOCAL ELSE D2_LOCAL END " 
//_cQuery += CR + "     AND D2_SERIORI=CASE WHEN D2_SERIORI = D1_SERIE THEN D1_SERIE ELSE D2_SERIORI END  AND D2_EMISSAO >=D1_DTDIGIT "
//_cQuery += CR + "     AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR04)+"' AND D2.D_E_L_E_T_ = '' "
//_cQuery += CR + "     AND D2_IDENTB6=CASE WHEN ((D2_IDENTB6<>'' OR D1_NUMSEQ<>'') AND D2_IDENTB6=D1_NUMSEQ)  THEN D1_NUMSEQ  ELSE D2_IDENTB6 END "
//_cQuery += CR + " LEFT OUTER JOIN   "+RetSqlName("SA1")+" AS A1S  (NOLOCK) "
//_cQuery += CR + " ON     A1S.A1_FILIAL  = '"+xFilial("SA1")+"' AND A1S.A1_COD = D2_CLIENTE AND A1S.A1_LOJA = D2_LOJA AND A1S.D_E_L_E_T_ = '' "
//_cQuery += CR + " LEFT OUTER JOIN   "+RetSqlName("SF2")+" AS SF2 (NOLOCK) "
//_cQuery += CR + " ON     SF2.F2_FILIAL  = '"+xFilial("SF2")+"' AND SF2.F2_DOC = D2_DOC AND SF2.F2_SERIE = D2_SERIE  AND SF2.F2_CLIENTE = D2_CLIENTE AND SF2.F2_LOJA = D2_LOJA AND SF2.D_E_L_E_T_ = '' AND F2_EMISSAO>='"+DTOS(MV_PAR01)+"' "
_cQuery += CR + " LEFT OUTER JOIN   "+RetSqlName("SBM")+" AS BM (NOLOCK) "
_cQuery += CR + " ON     BM_FILIAL  = '"+xFilial("SBM")+"' AND BM_GRUPO = D1_GRUPO AND BM.D_E_L_E_T_ = '' "
//_cQuery += CR + " LEFT OUTER JOIN   "+RetSqlName("SX5")+" AS X5 (NOLOCK)"
//_cQuery += CR + " ON     X5.X5_FILIAL  = '"+xFilial("SX5")+"' AND X5.X5_TABELA = 'Z9' AND X5.X5_CHAVE = AB9.AB9_LINHA  AND X5.D_E_L_E_T_ = '' "
_cQuery += CR + " LEFT OUTER JOIN   "+RetSqlName("SX5")+" AS X52 (NOLOCK) "
_cQuery += CR + " ON     X52.X5_FILIAL  = '"+xFilial("SX5")+"' AND X52.X5_TABELA = 'ZD' AND X52.X5_CHAVE = CASE WHEN D1.D1_MOTDOCA='' THEN '01' ELSE D1.D1_MOTDOCA END  AND X52.D_E_L_E_T_ = '' "
_cQuery += CR + " WHERE  D1_FILIAL = '"+xFilial("SD1")+"' "
_cQuery += CR + "        AND D1_DTDIGIT >= '"+DTOS(MV_PAR01)+"' AND D1_DTDIGIT <='"+DTOS(MV_PAR02)+"' "
_cQuery += CR + "        AND D1_NUMSER <> '' "
_cQuery += CR + "        AND D1_TIPO = 'B' "
if !empty(mv_par06)
	_cQuery += CR + "        AND '"+mv_par06+"' LIKE '%'+D1_LOCAL+'%' "
endif
_cQuery += CR + "        AND D1.D_E_L_E_T_ = '' "
_cQuery += CR + _cFilCliente
_cQuery += CR + _cFilStatus
_cQuery += CR + _cFilFormul
_cQuery += CR + " ORDER BY Z1_CODBAR,D1_DOC,D1_SERIE "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha arquivos temporarios que serao utilizados pelo CYCLETIME     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if Select("TRBTOP") > 0
	TRBTOP->(dbCloseArea())
endif

if Select("TRB") > 0
	TRB->(dbCloseArea())
endif

if Select("TEMPAB9") > 0
	TEMPAB9->(dbCloseArea())
endif

if Select("TRBAB9") > 0
	TRBAB9->(dbCloseArea())
endif


//if !_lJob
//	memowrite("BGHRL01.SQL",_cQuery )
//endif

_cQuery := strtran(_cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBTOP",.T.,.T.)
if MV_PAR12==2 
 TcSetField("TRBTOP","EMISENT" ,"D")
 TcSetField("TRBTOP","ENTRADA" ,"D")
 TcSetField("TRBTOP","EMISSAI" ,"D")
 TcSetField("TRBTOP","ENTRCHAM","D")
 TcSetField("TRBTOP","ENTRDOCA","D")
 TcSetField("TRBTOP","ULTSAIDA","D")
 TcSetField("TRBTOP","DTNFNSN" ,"D")
 TcSetField("TRBTOP","DTENCCHA","D") 
 TcSetField("TRBTOP","SAIDDOCA","D")
 TcSetField("TRBTOP","DTSAINSN" ,"D")
Endif


if !_lJob
	dbSelectArea("TRBTOP")
	TRBTOP->(dbGoTop())
	if TRBTOP->(eof()) .and. TRBTOP->(bof())
		ApMsgInfo("Os parโmetros informados retornaram um resultado vazio. Por favor, revise os parโmetros ou contate o administrador do sistema.", "Arquivo nใo gerado")
		_lret:=.f.
		return(_lret)
	endif
	_lret:=.T.
Else
_lret:=.T.
Endif            


_cQuery := CR + " SELECT AB9_FILIAL,AB9_SN,AB9_NUMOS,AB9_NRCHAM,AB9_DTCHEG,AB9_LINHA,AB9_TIPO,AB9_CODCLI,AB9_LOJA,AB9_NOVOSN,AB9_DTSAID,AB9_HRSAID,NUMOS,        "
_cQuery += CR + " AB9_NEXSIN,AB9_RESOLU,AB9_SYMPTO,AB9_FAULID,AB9_ACTION,AB9_PARTN1,AB9_PARTN2,AB9_PARTN3,AB9_PARTN4,AB9_DEFECT,AB9_MOTSIN,AB9_NEXSOL "
_cQuery += CR + "      FROM "+RetSqlName("AB9")+"  AS CH2 (NOLOCK) INNER JOIN  "
_cQuery += CR + "          (SELECT AB9_FILIAL FILIAL, AB9_SN SN,LEFT(AB9_NUMOS,6) NUMOS, AB9_NRCHAM NRCHAM ,MAX(R_E_C_N_O_) AS AB9RECNO  "
_cQuery += CR + "            FROM "+RetSqlName("AB9")+" (NOLOCK)  "
_cQuery += CR + "           WHERE AB9_FILIAL='"+xFilial("AB9")+"' AND AB9_DTCHEG > '"+DTOS(MV_PAR01)+"'  AND D_E_L_E_T_='' "
_cQuery += CR + "           GROUP BY AB9_FILIAL, AB9_SN, AB9_NUMOS, AB9_NRCHAM ) AS CH1  "
_cQuery += CR + "           ON AB9RECNO=R_E_C_N_O_ "
_cQuery += CR + "        WHERE CH2.AB9_FILIAL='"+xFilial("AB9")+"'  AND AB9_DTCHEG > '"+DTOS(MV_PAR01)+"' AND D_E_L_E_T_='' "
_cQuery += CR + " ORDER BY AB9_FILIAL,AB9_SN,AB9_NUMOS,AB9_NRCHAM,AB9_DTCHEG "
       
_cQuery := strtran(_cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBAB9",.T.,.T.)

if MV_PAR12==2 
 TcSetField("TRBAB9","AB9_DTCHEG" ,"D")
 TcSetField("TRBAB9","AB9_DTSAID" ,"D")
Endif



// Cria arquivo temporario  AB9
_aCampos := {	{"AB9FILIAL"		,"C",2,0} ,;
{"AB9IMEI"	 ,"C",TamSX3("ZZ4_IMEI")[1],0},;
{"NUMOS"	 ,"C",06,0},;
{"AB9NUMOS"	 ,"C",08,0},;
{"AB9CODCLI" ,"C",06,0},;
{"AB9LOJA"   ,"C",02,0},;
{"AB9NRCHAM" ,"C",15,0},;
{"AB9DTCHEG" ,"D",08,0},;
{"AB9LINHA"	 ,"C",02,0},;
{"AB9TIPO"	 ,"C",01,0},;
{"AB9NOVOSN" ,"C",20,0},;
{"AB9DTSAID" ,"D",08,0},;
{"AB9HRSAID" ,"C",05,0},;
{"AB9NEXSIN" ,"C",06,0},;
{"AB9RESOLU" ,"C",04,0},;
{"AB9SYMPTO" ,"N",03,0},;
{"AB9FAULID" ,"N",03,0},;
{"AB9ACTION" ,"N",03,0},;
{"AB9PARTN1" ,"C",15,0},;
{"AB9PARTN2" ,"C",15,0},;
{"AB9PARTN3" ,"C",15,0},;
{"AB9PARTN4" ,"C",15,0},;
{"AB9DEFECT" ,"C",04,0},;
{"AB9MOTSIN" ,"C",05,0},;
{"AB9NEXSOL" ,"C",05,0}}
  

_cArqSeq := CriaTrab(_aCampos)
dbUseArea(.T.,,_cArqSeq,"TEMPAB9",.T.,.F.)
cInd1TRB := CriaTrab(Nil, .F.)
IndRegua("TEMPAB9",cInd1TRB,"AB9IMEI+NUMOS+AB9CODCLI+AB9LOJA",,,"Indexando Arquivo de Trabalho")
dbClearIndex()
cindarqt :=cInd1TRB + OrdBagExt()
dbSetIndex(cInd1TRB + OrdBagExt())

DbSelectArea("SD2")
SD2->(DBOrderNickName('D2NUMSEMIS')) //SD2->(dbSetOrder(10)) // D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO)

DbSelectArea("SC6")
SC6->(dbSetOrder(1))  // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO

dbSelectArea("SA1")
DbSetOrder(1) //A1_FILIAL+A1_Cod+A1_Loja

dbSelectArea("SF2")
DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

dbSelectArea("SX5")
DbSetOrder(1) //X5_FILIAL+X5_TABELA+X5_CHAVE

// Contagem de registros para a Regua
TRBAB9->(dbGoTop())
While !TRBAB9->(eof())
  _nRegAB9++
  TRBAB9->(dbSkip())
Enddo



// Inicializa a regua de evolucao
ProcRegua(_nRegAB9)

TRBAB9->(dbGoTop())
While !TRBAB9->(eof())
  IncProc("Inserindo dados (AB9) no temp. IMEI : " + alltrim(TRBAB9->AB9_SN))


  	reclock("TEMPAB9",.t.)   
      TEMPAB9->AB9FILIAL := TRBAB9->AB9_FILIAL
      TEMPAB9->AB9IMEI   := TRBAB9->AB9_SN
      TEMPAB9->NUMOS     := TRBAB9->NUMOS
      TEMPAB9->AB9NUMOS  := TRBAB9->AB9_NUMOS
      TEMPAB9->AB9CODCLI := TRBAB9->AB9_CODCLI
      TEMPAB9->AB9LOJA   := TRBAB9->AB9_LOJA
      TEMPAB9->AB9NRCHAM := TRBAB9->AB9_NRCHAM
      TEMPAB9->AB9DTCHEG := TRBAB9->AB9_DTCHEG
      TEMPAB9->AB9LINHA  := TRBAB9->AB9_LINHA
      TEMPAB9->AB9TIPO   := TRBAB9->AB9_TIPO
      TEMPAB9->AB9NOVOSN := TRBAB9->AB9_NOVOSN
      TEMPAB9->AB9DTSAID := TRBAB9->AB9_DTSAID
      TEMPAB9->AB9HRSAID := TRBAB9->AB9_HRSAID
      TEMPAB9->AB9NEXSIN := TRBAB9->AB9_NEXSIN
      TEMPAB9->AB9NEXSOL := TRBAB9->AB9_NEXSOL
      TEMPAB9->AB9RESOLU := TRBAB9->AB9_RESOLU
      TEMPAB9->AB9SYMPTO := TRBAB9->AB9_SYMPTO
      TEMPAB9->AB9FAULID := TRBAB9->AB9_FAULID
      TEMPAB9->AB9ACTION := TRBAB9->AB9_ACTION
      TEMPAB9->AB9PARTN1 := TRBAB9->AB9_PARTN1
      TEMPAB9->AB9PARTN2 := TRBAB9->AB9_PARTN2
      TEMPAB9->AB9PARTN3 := TRBAB9->AB9_PARTN3
      TEMPAB9->AB9PARTN4 := TRBAB9->AB9_PARTN4
      TEMPAB9->AB9DEFECT := TRBAB9->AB9_DEFECT
      TEMPAB9->AB9MOTSIN := TRBAB9->AB9_MOTSIN
 
  	msunlock()  	 
  
  TRBAB9->(DBSKIP())
ENDDO

dbSelectArea("TRBTOP")
Copy To &_cArqTrab
dbUseArea(.t.,,_cArqTrab,"TRB",.f.,.f.)
TRBTOP->(dbCloseArea())


// Contagem de registros para a Regua
TRB->(dbGoTop())
While !TRB->(eof())
  _nRegTRB++
  TRB->(dbSkip())
Enddo


// Inicializa a regua de evolucao
ProcRegua(_nRegTRB)


TRB->(dbGoTop())
While !TRB->(eof())
	nConta++   
    IncProc("Proc. dados E/S-Mass IMEI: " + alltrim(TRB->IMEI))
	lachouab9 :=.f.  
    lachouac6 :=.f.
    lachouad2 :=.f.
    lachouaA1 :=.f.
    lachouaf2 :=.f.     
    lIENTXISD2:=.F.                     
    lOENTXISC6:=.F.
    lIENTXISC6:=.F.
    _CPEDSC6  :=""
    _CPEDSD2  :=""
    _CIMEIOS  :=""
    _cimeiSC6 :=""
    _cimeiSD2 :=""
    _demisSD2 :=CTOD(" / / ")
    _demisSC6 :=CTOD(" / / ")
    _cITEMORI :="" 
    _cLOCAL   :="" 
    _cSERIORI :="" 
    _cIDENTB6 :="" 
    _cNFORI   :=""          
    _cSC6ITORI:="" 
    _cSC6LOCAL:="" 
    _cSC6SEORI:="" 
    _cSC6IDTB6:="" 
    _cSC6NFORI:=""              
    _cDESCFASE:=""      
    _cNFSERD2 :=""
    _cCliljD2 :=""
    _ctesD2   :=""
    _cstatus  :='------'    
    _ccritica :=""
    if MV_PAR12==1
      _diadoca  :=SUBSTR(TRB->ENTRDOCA,7,2)
      _mesdoca  :=SUBSTR(TRB->ENTRDOCA,5,2)
      _anodoca  :=SUBSTR(TRB->ENTRDOCA,1,4)
      _diaentr  :=SUBSTR(TRB->ENTRADA,7,2)
      _mesentr  :=SUBSTR(TRB->ENTRADA,5,2)
      _anoentr  :=SUBSTR(TRB->ENTRADA,1,4)   
      _diaemis  :=SUBSTR(TRB->SAIDDOCA,7,2)
      _mesemis  :=SUBSTR(TRB->SAIDDOCA,5,2)
      _anoemis  :=SUBSTR(TRB->SAIDDOCA,1,4)
      _dEmisSai :=ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)
    else                                                    
      _dEmisSai :=TRB->ENTRADA
    Endif	
    IF !EMPTY(TRB->SAIDDOCA)
    	reclock("TRB",.f.)   
    	  IF !EMPTY(TRB->ENTRDOCA)
     		  TRB->TEMPREP   := iif(EMPTY(TRB->ENTRDOCA),0,iif(mv_par12==1,ctod(_diaemis+"/"+_mesemis+"/"+_anoemis)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca),TRB->SAIDDOCA-TRB->ENTRDOCA))
     	  ELSE  	                                                                           
     	      TRB->TEMPREP   := iif(EMPTY(TRB->ENTRADA),0,iif(mv_par12==1,ctod(_diaemis+"/"+_mesemis+"/"+_anoemis)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr),TRB->SAIDDOCA-TRB->ENTRADA))	   
     	  ENDIF    
		msunlock()  
    ELSE		
		reclock("TRB",.f.)
		 IF !EMPTY(TRB->ENTRDOCA)                                               
		    TRB->TEMPREP   := iif(EMPTY(TRB->ENTRDOCA),0,iif(mv_par12==1,ddatabase-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca),ddatabase-TRB->ENTRDOCA))
		 ELSE   
		    TRB->TEMPREP   := iif(EMPTY(TRB->ENTRADA),0,iif(mv_par12==1,ddatabase-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr),ddatabase-TRB->ENTRADA))
		 ENDIF   
		msunlock()  	 
    ENDIF
	          
    IF TRB->NFE+TRB->IMEI=_cNFEIMEI 	
      	  RecLock("TRB",.F.)
		  dbdelete()
		  MsUnlock()   
    ELSE
     _cNFEIMEI:= TRB->NFE+TRB->IMEI     
    ENDIF	                                                 
    
    DbSelectArea("TEMPAB9")
    If TEMPAB9->(DBSEEK(TRB->IMEI+LEFT(TRB->OS,6)+TRB->CLIENTE+TRB->LOJA))
      lachouab9:=.t.
      _CIMEIOS :=TEMPAB9->AB9IMEI+TEMPAB9->NUMOS
    Elseif TEMPAB9->(DBSEEK(TRB->IMEI+LEFT(TRB->OS,6)+TRB->Z1_CODCLI+TRB->Z1_LOJA))
      lachouab9:=.t.
      _CIMEIOS :=TEMPAB9->AB9IMEI+TEMPAB9->NUMOS 
    Endif
                                                 
    DbSelectArea("SD2")
	//SD2->(dbSetOrder(10)) // D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO) - Edson Rodrigues - 02/10/10
	SD2->(DBOrderNickName('D2NUMSEMIS')) //D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO)

    If SD2->(dbSeek(xFilial("SD2") + TRB->IMEI))
       While SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_NUMSERI == TRB->IMEI 
          IF  SD2->D2_EMISSAO >= _dEmisSai .and. SD2->D2_EMISSAO <= MV_PAR04
                  _CPEDSD2  :=SD2->D2_PEDIDO	
                  lIENTXISD2:=.T.
                  lachouad2 :=.T.
                  _cimeiSD2 :=SD2->D2_NUMSERI
                  _demisSD2 :=SD2->D2_EMISSAO
                  _cNFORI   :=SD2->D2_NFORI
                  _cSERIORI :=SD2->D2_SERIORI
                  _cITEMORI :=SD2->D2_ITEMORI           
                  _cLOCAL   := SD2->D2_LOCAL
                  _cIDENTB6 :=SD2->D2_IDENTB6              
                  _cNFSERD2:=SD2->D2_DOC+'/'+SD2->D2_SERIE                                                 
                  _cCliljD2:=SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+SPACE(11)
                  _ctesD2  :=SD2->D2_TES

          	DbSelectArea("SC6")
            SC6->(dbSetOrder(01)) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO 
	        If SC6->(dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV)) 
	           While SC6->(!eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SD2->D2_PEDIDO .and. SC6->C6_ITEM = SD2->D2_ITEMPV 
            
                   IF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6)  .AND. LEFT(SC6->C6_NUMOS,6)=LEFT(TRB->OS,6)
         	          lachouac6  :=.T.  
	                  lIENTXISC6 :=.T.
	                  lOENTXISC6 :=.T.  
	                  _CPEDSC6   :=SC6->C6_NUM        
                      _cimeiSC6  :=SC6->C6_NUMSERI
                      _cSC6ITORI :=SC6->C6_ITEMORI
                      _cSC6LOCAL :=SC6->C6_LOCAL
                      _cSC6SEORI :=SC6->C6_SERIORI
                      _cSC6IDTB6 :=SC6->C6_IDENTB6
                      _cSC6NFORI :=SC6->C6_NFORI
                      _demisSC6  :=SC6->C6_ENTREG

	               ELSEIF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI  .AND. LEFT(SC6->C6_NUMOS,6)=LEFT(TRB->OS,6)
                      lachouac6  :=.T.  
	                  lIENTXISC6 :=.T. 
	                  lOENTXISC6 :=.T.   
	                  _CPEDSC6   :=SC6->C6_NUM   
	                  _cimeiSC6  :=SC6->C6_NUMSERI
                      _cSC6ITORI :=SC6->C6_ITEMORI
                      _cSC6LOCAL :=SC6->C6_LOCAL
                      _cSC6SEORI :=SC6->C6_SERIORI
                      _cSC6IDTB6 :=SC6->C6_IDENTB6
                      _cSC6NFORI :=SC6->C6_NFORI
                      _demisSC6  :=SC6->C6_ENTREG
                                            	                  
                   ELSEIF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI  .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND.  SC6->C6_SERIORI=TRB->SERIENF .AND. SC6->SC6_IDENTB6=TRB->D1_IDENTB6
	 	               lachouac6 :=.T.  
	                   lIENTXISC6:=.T.
	                   lOENTXISC6:=.F.                                                                                                     
	                  _CPEDSC6   :=SC6->C6_NUM
	                  _cimeiSC6  :=SC6->C6_NUMSERI
                      _cSC6ITORI :=SC6->C6_ITEMORI
                      _cSC6LOCAL :=SC6->C6_LOCAL
                      _cSC6SEORI :=SC6->C6_SERIORI
                      _cSC6IDTB6 :=SC6->C6_IDENTB6
                      _cSC6NFORI :=SC6->C6_NFORI
                      _demisSC6  :=SC6->C6_ENTREG
                      	                  
                   ELSEIF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI  .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND. SC6->SC6_IDENTB6=TRB->D1_IDENTB6
	 	               lachouac6 :=.T.  
	                   lIENTXISC6:=.T.
	                   lOENTXISC6:=.F.                                                                                                     
	                  _CPEDSC6   :=SC6->C6_NUM
	                  _cimeiSC6  :=SC6->C6_NUMSERI
                      _cSC6ITORI :=SC6->C6_ITEMORI
                      _cSC6LOCAL :=SC6->C6_LOCAL
                      _cSC6SEORI :=SC6->C6_SERIORI
                      _cSC6IDTB6 :=SC6->C6_IDENTB6
                      _cSC6NFORI :=SC6->C6_NFORI	                  
                      _demisSC6  :=SC6->C6_ENTREG
                      	                  
                   ELSEIF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI  .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND. SC6->C6_SERIORI=TRB->SERIENF .AND. SC6->SC6_ITEMORI=TRB->D1_ITEM
	 	               lachouac6 :=.T.  
	                   lIENTXISC6:=.T.
	                   lOENTXISC6:=.F.      
	                  _CPEDSC6   :=SC6->C6_NUM	                                                                                                                  
	                  _cimeiSC6  :=SC6->C6_NUMSERI
                      _cSC6ITORI :=SC6->C6_ITEMORI
                      _cSC6LOCAL :=SC6->C6_LOCAL
                      _cSC6SEORI :=SC6->C6_SERIORI
                      _cSC6IDTB6 :=SC6->C6_IDENTB6
                      _cSC6NFORI :=SC6->C6_NFORI	                  
                      _demisSC6  :=SC6->C6_ENTREG
	                  
                   ENDIF	             
	             
                 SC6->(DBSKIP()) 
               ENDDO
            Endif
            
            DbSelectArea("SA1")
            If SA1->(dbSeek(xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA)) 
               lachouaA1:=.T.
            ENDIF  
            
            dbSelectArea("SF2")
            If SF2->(dbSeek(xFilial("SF2") + SD2->D2_DOC + SD2->D2_SERIE+SD2->D2_CLIENTE + SD2->D2_LOJA)) 
               IF SF2->F2_EMISSAO >= MV_PAR01
                  lachouaf2:=.T.
               Endif   
            ENDIF  
          ENDIF
          DbSelectArea("SD2") 
          SD2->(DBSKIP())
	   Enddo
	ELSE
       DbSelectArea("SC6")
	   SC6->(DBOrderNickName('SC6IMEI'))// C6_FILIAL + C6_NUMSERI
	   If SC6->(dbSeek(xFilial("SC6") + TRB->IMEI)) 
	     While SC6->(!eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI 
           IF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6)  .AND. LEFT(SC6->C6_NUMOS,6)=LEFT(TRB->OS,6)
	          lachouac6 :=.T.  
	          lIENTXISC6:=.T.
	          lOENTXISC6:=.T.
              _CPEDSC6  :=SC6->C6_NUM
              _cimeiSC6 :=SC6->C6_NUMSERI       
              _cSC6ITORI :=SC6->C6_ITEMORI
              _cSC6LOCAL :=SC6->C6_LOCAL
              _cSC6SEORI :=SC6->C6_SERIORI
              _cSC6IDTB6 :=SC6->C6_IDENTB6
              _cSC6NFORI :=SC6->C6_NFORI              
              _demisSC6  :=SC6->C6_ENTREG
              
	       ELSEIF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI  .AND. LEFT(SC6->C6_NUMOS,6)=LEFT(TRB->OS,6)
              lachouac6 :=.T.  
	          lIENTXISC6:=.T. 
	          lOENTXISC6:=.T.   
              _CPEDSC6  :=SC6->C6_NUM   
              _cimeiSC6 :=SC6->C6_NUMSERI
              _cSC6ITORI :=SC6->C6_ITEMORI
              _cSC6LOCAL :=SC6->C6_LOCAL
              _cSC6SEORI :=SC6->C6_SERIORI
              _cSC6IDTB6 :=SC6->C6_IDENTB6
              _cSC6NFORI :=SC6->C6_NFORI
              _demisSC6  :=SC6->C6_ENTREG
                            
           ELSEIF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI  .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND.  SC6->C6_SERIORI=TRB->SERIENF .AND. SC6->SC6_IDENTB6=TRB->D1_IDENTB6
	 	      lachouac6 :=.T.  
	          lIENTXISC6:=.T.
	          lOENTXISC6:=.F.                                                                                                     
              _CPEDSC6  :=SC6->C6_NUM   
              _cimeiSC6 :=SC6->C6_NUMSERI
              _cSC6ITORI :=SC6->C6_ITEMORI
              _cSC6LOCAL :=SC6->C6_LOCAL
              _cSC6SEORI :=SC6->C6_SERIORI
              _cSC6IDTB6 :=SC6->C6_IDENTB6
              _cSC6NFORI :=SC6->C6_NFORI
              _demisSC6  :=SC6->C6_ENTREG
              
           ELSEIF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI  .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND. SC6->SC6_IDENTB6=TRB->D1_IDENTB6
	 	      lachouac6 :=.T.  
	          lIENTXISC6:=.T.
	          lOENTXISC6:=.F.                                                                                                     
              _CPEDSC6  :=SC6->C6_NUM
              _cimeiSC6 :=SC6->C6_NUMSERI
              _cSC6ITORI :=SC6->C6_ITEMORI
              _cSC6LOCAL :=SC6->C6_LOCAL
              _cSC6SEORI :=SC6->C6_SERIORI
              _cSC6IDTB6 :=SC6->C6_IDENTB6
              _cSC6NFORI :=SC6->C6_NFORI
              _demisSC6  :=SC6->C6_ENTREG
              
           ELSEIF SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == TRB->IMEI  .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND. SC6->C6_SERIORI=TRB->SERIENF .AND. SC6->SC6_ITEMORI=TRB->D1_ITEM
	 	      lachouac6 :=.T.  
	          lIENTXISC6:=.T.
	          lOENTXISC6:=.F.                                                                                                     
              _CPEDSC6  :=SC6->C6_NUM
              _cimeiSC6 :=SC6->C6_NUMSERI
              _cSC6ITORI :=SC6->C6_ITEMORI
              _cSC6LOCAL :=SC6->C6_LOCAL
              _cSC6SEORI :=SC6->C6_SERIORI
              _cSC6IDTB6 :=SC6->C6_IDENTB6
              _cSC6NFORI :=SC6->C6_NFORI
              _demisSC6  :=SC6->C6_ENTREG
              
           ENDIF
	       DbSelectArea("SD2")
           SD2->(dbSetOrder(08)) // D2_FILIAL + D2_PEDIDO + D2_ITEMPV
	       If SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM+SC6->C6_ITEM))
	          lIENTXISD2:=.F.
	          lachouad2 :=.t.
              _CPEDSD2  :=SD2->D2_PEDIDO	
              _cimeiSD2 :=SD2->D2_NUMSERI
              _demisSD2 :=SD2->D2_EMISSAO
              _cNFORI   :=SD2->D2_NFORI
              _cSERIORI :=SD2->D2_SERIORI
              _cITEMORI :=SD2->D2_ITEMORI           
              _cLOCAL   := SD2->D2_LOCAL
              _cIDENTB6 :=SD2->D2_IDENTB6              
              _cNFSERD2:=SD2->D2_DOC+'/'+SD2->D2_SERIE                                                 
              _cCliljD2:=SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+SPACE(11)
              _ctesD2  :=SD2->D2_TES

              
	          
	          DbSelectArea("SA1")
              If SA1->(dbSeek(xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA)) 
                 lachouaA1:=.T.
              ENDIF  
            
              DbSelectArea("SF2")
              If SF2->(dbSeek(xFilial("SF2") + SD2->D2_DOC + SD2->D2_SERIE+SD2->D2_CLIENTE + SD2->D2_LOJA)) 
                IF SF2->F2_EMISSAO >= MV_PAR01
                  lachouaf2:=.T.
                Endif   
              ENDIF  
           ENDIF
	       SC6->(DBSKIP()) 
	     ENDDO	
	   
	   ELSE
	     IF !EMPTY(TRB->Z1_PV)
	         DbSelectArea("SC6")
             SC6->(dbSetOrder(01)) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO 
	         If SC6->(dbSeek(xFilial("SC6") + LEFT(TRB->Z1_PV,6))) 
	            While SC6->(!eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == LEFT(TRB->Z1_PV,6)
                      IF SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == LEFT(TRB->Z1_PV,6) .AND. LEFT(SC6->C6_NUMOS,6)=LEFT(TRB->OS,6)
             	          lachouac6  :=.T.  
	                      lIENTXISC6 :=.F.
               	          lOENTXISC6 :=.T.
                          _CPEDSC6    :=SC6->C6_NUM
                          _cimeiSC6   :=SC6->C6_NUMSERI
                          _cSC6ITORI :=SC6->C6_ITEMORI
                          _cSC6LOCAL :=SC6->C6_LOCAL
                          _cSC6SEORI :=SC6->C6_SERIORI
                          _cSC6IDTB6 :=SC6->C6_IDENTB6
                          _cSC6NFORI :=SC6->C6_NFORI
                          _demisSC6  :=SC6->C6_ENTREG
                          
                      ELSEIF SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND.  SC6->C6_SERIORI=TRB->SERIENF .AND. SC6->SC6_IDENTB6=TRB->D1_IDENTB6
            	 	      lachouac6  :=.T.  
	                      lIENTXISC6 :=.F.
	                      lOENTXISC6 :=.F.                                                                                                     
                          _CPEDSC6   :=SC6->C6_NUM
                          _cimeiSC6  :=SC6->C6_NUMSERI
                          _cSC6ITORI :=SC6->C6_ITEMORI
                          _cSC6LOCAL :=SC6->C6_LOCAL
                          _cSC6SEORI :=SC6->C6_SERIORI
                          _cSC6IDTB6 :=SC6->C6_IDENTB6
                          _cSC6NFORI :=SC6->C6_NFORI
                          _demisSC6  :=SC6->C6_ENTREG
                          

                      ELSEIF SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND. SC6->SC6_IDENTB6=TRB->D1_IDENTB6
	 	                   lachouac6  :=.T.  
	                       lIENTXISC6 :=.F.
	                       lOENTXISC6 :=.F.                                                                                                     
                           _CPEDSC6   :=SC6->C6_NUM
                           _cimeiSC6  :=SC6->C6_NUMSERI
                           _cSC6ITORI :=SC6->C6_ITEMORI
                           _cSC6LOCAL :=SC6->C6_LOCAL
                           _cSC6SEORI :=SC6->C6_SERIORI
                           _cSC6IDTB6 :=SC6->C6_IDENTB6
                           _cSC6NFORI :=SC6->C6_NFORI
                           _demisSC6  :=SC6->C6_ENTREG

                      ELSEIF SC6->C6_FILIAL == xFilial("SC6")  .AND. SC6->C6_NUM=LEFT(TRB->Z1_PV,6) .AND. SC6->SC6_LOCAL=TRB->ARMAZEM .AND. SC6->C6_NFORI=TRB->NFE  .AND. SC6->C6_SERIORI=TRB->SERIENF .AND. SC6->SC6_ITEMORI=TRB->D1_ITEM
	 	                   lachouac6  :=.T.  
	                       lIENTXISC6 :=.F.
	                       lOENTXISC6 :=.F.                                                                                   
                           _CPEDSC6   :=SC6->C6_NUM
                           _cimeiSC6  :=SC6->C6_NUMSERI
                           _cSC6ITORI :=SC6->C6_ITEMORI
                           _cSC6LOCAL :=SC6->C6_LOCAL
                           _cSC6SEORI :=SC6->C6_SERIORI
                           _cSC6IDTB6 :=SC6->C6_IDENTB6
                           _cSC6NFORI :=SC6->C6_NFORI
                           _demisSC6  :=SC6->C6_ENTREG
                           

	                  ENDIF
	                  DbSelectArea("SD2")
                      SD2->(dbSetOrder(08)) // D2_FILIAL + D2_PEDIDO + D2_ITEMPV
                      If SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM+SC6->C6_ITEM))
	                    lIENTXISD2:=.F.
	                    lachouad2 :=.t.
	                    _CPEDSD2  :=SD2->D2_PEDIDO	
                        _cimeiSC6 :=SC6->C6_NUMSERI
                        _cimeiSD2 :=SD2->D2_NUMSERI
                        _demisSD2 :=SD2->D2_EMISSAO
                        _cNFORI   :=SD2->D2_NFORI
                        _cSERIORI :=SD2->D2_SERIORI
                        _cITEMORI :=SD2->D2_ITEMORI           
                        _cLOCAL   := SD2->D2_LOCAL
                        _cIDENTB6 :=SD2->D2_IDENTB6              
                        _cNFSERD2:=SD2->D2_DOC+'/'+SD2->D2_SERIE                                                 
                        _cCliljD2:=SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+SPACE(11)
                        _ctesD2  :=SD2->D2_TES



	                    DbSelectArea("SA1")
                        If SA1->(dbSeek(xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA)) 
                             lachouaA1:=.T.
                         ENDIF  
            
                        DbSelectArea("SF2")
                        If SF2->(dbSeek(xFilial("SF2") + SD2->D2_DOC + SD2->D2_SERIE+SD2->D2_CLIENTE + SD2->D2_LOJA)) 
                           IF SF2->F2_EMISSAO >= MV_PAR01
                             lachouaf2:=.T.
                           Endif   
                        ENDIF  
                      ENDIF
	              SC6->(DBSKIP()) 
	            ENDDO	
	         ELSE
	 	       lachouac6 :=.F.  
	           lIENTXISC6:=.F.
	           lOENTXISC6:=.F.        
	           lIENTXISD2:=.F.
               lachouad2 :=.F.                                                                                                              
	         ENDIF
	     ELSE
	       lachouac6 :=.F.  
	       lIENTXISC6:=.F.
	       lOENTXISC6:=.F.        
	       lIENTXISD2:=.F.
           lachouad2 :=.F.                                                                                                              
	     ENDIF
	   ENDIF  
	ENDIF     
	                 
    DbSelectArea("TRB")
    IF lachouaD2  
       IF !lIENTXISD2 .AND. lachouac6  .AND. lIENTXISC6 .AND. _cimeiSD2<>TRB->IMEI
           _ccritica := "IMEI DOC.ENTR DIFERENTE IMEI NF_SAIDA"

       ELSEIF !lIENTXISD2 .AND. lachouac6 .AND. lIENTXISC6 .AND. _cimeiSD2<>_cimeiSC6
           _ccritica := "IMEI PEDIDO SAIDA DIFERENTE IMEI NF_SAIDA"   

       ELSEIF lachouac6 .AND. LEFT(TRB->Z1_PV,6)<>_CPEDSD2
           _ccritica := "PEDIDO NF SAIDA DIFERENTE DO PEDIDO GRAVADO DA ENTRADA MASSIVA"              
       
       ELSEIF lachouac6 .AND. LEFT(TRB->Z1_PV,6)<>_CPEDSC6
           _ccritica := "PEDIDO PED_SAIDA DIFERENTE DO PEDIDO GRAVADO DA ENTRADA MASSIVA"              

       ELSEIF !lachouac6 .AND. LEFT(TRB->Z1_PV,6)<>_CPEDSD2
           _ccritica := "PEDIDO NF SAIDA NAO ENCONTRADO NA TAB. DE PEDIDOS E DIFERENTE DO PEDIDO GRAVADO DA ENTRADA MASSIVA"              
       
       ELSEIF !lachouac6 .AND. LEFT(TRB->Z1_PV,6)=_CPEDSD2
           _ccritica := "PEDIDO NF SAIDA NAO ENCONTRADO NA TAB. DE PEDIDOS E IGUAL AO PEDIDO GRAVADO DA ENTRADA MASSIVA"              
           
       ELSEIF  TRB->ENTRADA > _demisSD2
            _ccritica :="DT DIGITACAO NF-ENTRADA MAIOR DT EMISSAO NF-SAIDA" 

       ELSEIF _cNFORI<>TRB->NFE .OR. TRB->D1_SERIE<>_cSERIORI
             _ccritica := "NF OU SERIE ORIGEM DA NF SAIDA DIFERENTE DA NF OU SERIE DO DOC. ENTRADA"   

       ELSEIF _cITEMORI<>TRB->D1_ITEM  
          _ccritica := "ITEM ORIGEM NF SAIDA DIFERENTE ITEM DO DOC. ENTRADA"  
      
       ELSEIF TRB->D1_LOCAL<>_cLOCAL
          _ccritica := "ARMAZEM NF SAIDA DIFERENTE DO ARMAZEM DO DOC. ENTRADA"  
       
       ELSEIF (_cIDENTB6<>'' .OR. TRB->D1_NUMSEQ<>'') .AND. _cIDENTB6<>TRB->D1_NUMSEQ    
            _ccritica := "IDENT. TERCEIRO NF SAIDA DIFERENTE DA IDENT. TERCEIRO DO DOC. ENTRADA"  
       
       ENDIF  
    ENDIF
       
    
    IF !lachouaD2 .AND. EMPTY(_ccritica)
        IF lachouac6
           IF  (!EMPTY(TRB->C6_NUM) .AND. TRB->C6_NUM <>'NULL') .AND. TRB->IMEI<>_cimeiSC6
               _ccritica := "IMEI DOC.ENTR DIFERENTE IMEI PED_SAIDA"
    
           ELSEIF  lIENTXISC6 .AND. _cimeiSC6<>TRB->IMEI
               _ccritica := "IMEI DOC.ENTR DIFERENTE IMEI PED_SAIDA"  
           
           ELSEIF  LEFT(TRB->Z1_PV,6)<>_CPEDSC6                                                                            
               _ccritica := "PEDIDO GRAVADO NO DOC.ENTR DIFERENTE PED_SAIDA"          

           ELSEIF  TRB->ENTRADA > _demisSC6
              _ccritica :="DT DIGITACAO NF-ENTRADA MAIOR DT EMISSAO PED_SAIDA" 

           ELSEIF _cSC6NFORI<>TRB->NFE .OR. TRB->D1_SERIE<>_cSC6SEORI
              _ccritica := "NF OU SERIE ORIGEM DO PED_SAIDA DIFERENTE DA NF OU SERIE DO DOC. ENTRADA"   
            
           ELSEIF _cSC6ITORI<>TRB->D1_ITEM  
              _ccritica := "ITEM ORIGEM DO PED_SAIDA DIFERENTE ITEM DO DOC. ENTRADA"  
       
           ELSEIF TRB->D1_LOCAL<>_cSC6LOCAL
              _ccritica := "ARMAZEM DO PED_SAIDA DIFERENTE DO ARMAZEM DO DOC. ENTRADA"  
       
           ELSEIF (_cSC6IDTB6<>'' .OR. TRB->D1_NUMSEQ<>'') .AND. _cSC6IDTB6<>TRB->D1_NUMSEQ    
            _ccritica := "IDENT. TERCEIRO DO PED_SAIDA DIFERENTE DA IDENT. TERCEIRO DO DOC. ENTRADA"  

           ENDIF                     
        ELSEIF !lachouac6
           IF !EMPTY(TRB->Z1_PV,6)
               _ccritica := "PEDIDO GRAVADO NO DOC.ENTR IDENVIDAMENTO, NAO ENCONTRADO NA BASE DE PED_SAIDA E NF_SAIDA"          
           ENDIF
        ENDIF
    ENDIF
    
     
    IF lachouab9  
       
       dbSelectArea("SX5")
       If SX5->(dbSeek(xFilial("SX5") + 'Z9' + TEMPAB9->AB9LINHA)) 
         _cDESCFASE:=SX5->X5_DESCRI
       Endif            
       
       IF TEMPAB9->AB9TIPO = '1'  
          _cstatus:="Encerrado"
       ELSEIF TEMPAB9->AB9TIPO = '2' .AND. lachouaD2 
         _cstatus:="Encerrado" 
       ELSEIF TEMPAB9->AB9TIPO = '2' .AND. !lachouaD2 
         _cstatus:="Aberto" 
       ENDIF
        
       If empty(_ccritica)
       
          IF TEMPAB9->AB9TIPO = '1' .AND. !lachouaD2
             _ccritica := "CHAMADO ENCERRADO - FALTA EMISSAO DE NF DE SAIDA" 
        
          ELSEIF !lachouaD2 .AND. (TEMPAB9->AB9CODCLI<>TRB->CLIENTE .OR. TEMPAB9->AB9CODCLI<>TRB->Z1_CODCLI) 
             _ccritica := "COD.CLIENTE DOC.ENTR DIFERENTE COD.CLIENTE ENT.MASSIVA,OS e ATENDIMENTO" 
      
          ELSEIF lachouaD2 .AND. (TEMPAB9->AB9CODCLI<>TRB->CLIENTE .OR. TEMPAB9->AB9CODCLI<>TRB->Z1_CODCLI) 
            _ccritica := "COD.CLIENTE ENT.MASSIVA DIFERENTE ATENDIMENTO" 
       
          ELSEIF TEMPAB9->AB9LINHA='' 
            _ccritica :=  "ATENDIMENTO SEM FASE PREECHIDO" 
       
          ELSEIF lachouaD2 .AND. _cITEMORI<>TRB->D1_ITEM  .AND. _demisSD2 >= TRB->EMISENT .AND.  _cIDENTB6=TRB->D1_NUMSEQ 
            _ccritica := "NUM DO ITEM ORIGEM DIFERENTE NUM DO ITEM-ORIGEM SAIDA" 
       
          ELSEIF lachouaD2 .AND. _cNFORI<>TRB->NFE .AND. _demisSD2 >= TRB->EMISENT .AND.  _cIDENTB6=TRB->D1_NUMSEQ 
            _ccritica := "NUM DA NFENTRADA DIFERENTE NUM DA NF-ORIGEM SAIDA" 
       
          ELSEIF lachouaD2 .AND. _cLOCAL<>TRB->ARMAZEM .AND. _demisSD2 >= TRB->EMISENT .AND.  _cIDENTB6=TRB->D1_NUMSEQ 
            _ccritica :=  "ARMAZEN DA NFENTRADA DIFERENTE ARMAZEN NF SAIDA"
       
          ELSEIF lachouaD2 .AND. _cSERIORI<>TRB->D1_SERIE .AND. _demisSD2 >= TRB->EMISENT .AND. _cIDENTB6=TRB->D1_NUMSEQ 
            _ccritica := "SERIE DA NFENTRADA DIFERENTE NUM DA SERIE NF-ORIGEM SAIDA" 
         
          ELSEIF LEFT(TRB->OS,6)<>TEMPAB9->NUMOS 
            _ccritica := "NUM OS ENTR. MASSIVA DIFERENTE NUM OS ATENDIMENTO" 
          ENDIF  
       ENDIF
       
       
       RecLock("TRB",.F.)
         TRB->ENTRCHAM:=TEMPAB9->AB9DTCHEG
         TRB->FASE    :=TEMPAB9->AB9LINHA
         TRB->DTENCCHA:=TEMPAB9->AB9DTSAID                
         TRB->HRENCCHA:=TEMPAB9->AB9HRSAID
         TRB->STATUS  :=_cstatus             
         IF mv_par11 <> 2
             TRB->NEXTSIN :=TEMPAB9->AB9NEXSIN
	         TRB->NEXTSOL :=TEMPAB9->AB9RESOLU
	     ENDIF    
	     IF mv_par11 == 3 // todos    
            TRB->SINTOMA :=TEMPAB9->AB9SYMPTO
	        TRB->FALHA   :=TEMPAB9->AB9FAULID
            TRB->ACAO    :=TEMPAB9->AB9ACTION
            TRB->PECA1   :=TEMPAB9->AB9PARTN1
            TRB->PECA2   :=TEMPAB9->AB9PARTN2
            TRB->PECA3   :=TEMPAB9->AB9PARTN3
            TRB->PECA4   :=TEMPAB9->AB9PARTN4
            TRB->DEFEITO :=TEMPAB9->AB9DEFECT
            TRB->RESOLUCA:=TEMPAB9->AB9RESOLU
            TRB->MOTOSIN :=TEMPAB9->AB9MOTSIN
            TRB->MOTOSOL :=TEMPAB9->AB9NEXSOL
            TRB->AB9_NRCHAM :=TEMPAB9->AB9NRCHAM 
         ENDIF   
         
         IF mv_par11 <> 1
            TRB->NOVOSN   :=TEMPAB9->AB9NOVOSN 
         Endif   
         TRB->CRITICA  :=_ccritica
         TRB->DESCFASE :=_cDESCFASE
         TRB->SAIDDOCA :=IIF(lachouaf2,SF2->F2_SAIROMA,TRB->SAIDDOCA)
         TRB->PEDIDO   :=IIF(lachouaD2,_CPEDSD2,IIF(lachouaC6,_CPEDSC6,TRB->Z1_PV))
         TRB->NOMESAI  :=IIF(lachouaA1,SA1->A1_NREDUZ,_cCliljD2) 
         TRB->NFBGH    :=IIF(lachouaD2,_cNFSERD2,TRB->NFBGH)
         TRB->EMISSAI  :=IIF(lachouaD2,_demisSD2,TRB->EMISSAI)
         TRB->TES      :=IIF(lachouaD2,_ctesD2,TRB->TES)
       MsUnlock()   
   
    Else

       If lachouaD2             
           _cstatus:='Encerrado'
           RecLock("TRB",.F.) 
             TRB->STATUS  :=_cstatus
             TRB->CRITICA  :=_ccritica         
             TRB->SAIDDOCA:=IIF(lachouaf2,SF2->F2_SAIROMA,TRB->SAIDDOCA)
             TRB->PEDIDO  :=IIF(lachouaD2,_CPEDSD2,IIF(lachouaC6,_CPEDSC6,TRB->Z1_PV))
             TRB->NOMESAI :=IIF(lachouaA1,SA1->A1_NREDUZ,_cCliljD2) 
             TRB->NFBGH   :=IIF(lachouaD2,_cNFSERD2,TRB->NFBGH)
             TRB->EMISSAI :=IIF(lachouaD2,_demisSD2,TRB->EMISSAI)
             TRB->TES     :=IIF(lachouaD2,_ctesD2,TRB->TES)
           MsUnlock()   
       Else                    
           _cstatus:='------'
           RecLock("TRB",.F.)      
             TRB->STATUS  :=_cstatus
             TRB->CRITICA  :=_ccritica          
             TRB->SAIDDOCA:=IIF(lachouaf2,SF2->F2_SAIROMA,TRB->SAIDDOCA)
             TRB->PEDIDO  :=IIF(lachouaD2,_CPEDSD2,IIF(lachouaC6,_CPEDSC6,TRB->Z1_PV))
             TRB->NOMESAI :=IIF(lachouaA1,SA1->A1_NREDUZ,_cCliljD2) 
             TRB->NFBGH   :=IIF(lachouaD2,_cNFSERD2,TRB->NFBGH)
             TRB->EMISSAI :=IIF(lachouaD2,_demisSD2,TRB->EMISSAI)
             TRB->TES     :=IIF(lachouaD2,_ctesD2,TRB->TES)
           MsUnlock()                              
           

           
           
       Endif
    Endif
   	TRB->(dbSkip())
EndDo

return(_lret)
