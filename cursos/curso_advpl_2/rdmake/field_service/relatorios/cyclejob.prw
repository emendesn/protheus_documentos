#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"      
#include "tbiconn.ch"       

/*                                                                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BGHRL01Y  ºAutor  ³Microsiga           º Data ³  03/19/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para geracao de planilha Excel com os dados de    º±±
±±º          ³ entrada, processo e saida dos produtos para reparos.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                              

User Function cyclejob()

private nConta     := 0
private _csrvapl :=ALLTRIM(GetMV("MV_SERVAPL"))

u_GerA0003(ProcName())

// Comando usado para programas que queremos Schedular
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "SD1","SD2","SZ1","AB9","AA3","SA1","SB1","SBM","SC6","SX5","SZ1"
// Tables = tabelas que são usadas no programa schedulado  
// Comando usado para programas que queremos Schedular

dbSelectArea("SD1")
dbSetOrder(1)

fRl01A()
fRl01B()
fRl01C()
Return

//
//EOF() - BGHRL01.PRW
//***********************************************************************

//*********************************************************************************************************
//mv_par01 -> Data entrada De
//mv_par02 -> Data entrada Ate
//mv_par03 -> Data saida De
//mv_par04 -> Data saida Ate
//mv_par05 -> Opção de normal ou excel
//mv_par06 -> Almox De
//mv_par07 -> Cliente  
//mv_par08 -> Status (1 = Tudo, 2 = Com NF, 3 = Sem NF)

Static Function fRL01A()

Local cAlias := ALIAS()
Local aAlias := {"SD1","SD2","SZ1","AB9","AA3","SA1","SB1","SBM","SC6","SX5","ZZ4","ZZ3"}
Local aAmb   := U_GETAMB( aAlias )
Local nTotal := 0
Private _cArqTrab := CriaTrab(,.f.)
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "G"
Private nomeprog    := "RL01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RL01"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RL01" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SD1"
private CR	 		:= chr(13) + chr(10) 
private _clab       := ""   
private _cdefcli    := ""


dbSelectArea("SC6")
//DbSetOrder(9)  //C6_FILIAL+C6_NUMSERI
SC6->(DBOrderNickName('SC6IMEI'))// C6_FILIAL + C6_NUMSERI

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
DbSetOrder(5) //D2_FILIAL+DTOS(D2_EMISSAO)+D2_NUMSEQ
                                                

dbSelectArea("SF2")
DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

dbSelectArea("SZ1")
DbSetOrder(6) //Z1_FILIAL+Z1_CODBAR+Z1_TIPO

dbSelectArea("AB9")
DbSetOrder(5) //AB9_FILIAL+AB9_SN

dbSelectArea("AA3")
DbSetOrder(6) //AA3_FILIAL+AA3_NUMSER

//ALTERADO PARA CONTEMPLAR AS NOVAS ALTERACOES DO CYCLOTIME - EDSON RODRIGUES 28/09/08
u_qryCycNew(ctod("01/01/09"), dDataBase, ctod("01/01/09"), dDataBase, "2", '22', "", 1, 3, 0, 2,2,.T.)
mv_par11 := 2
mv_par12 := 2     
mv_par10 := 0
_cNFEIMEI:=""
TRB->(dbGoTop())
While TRB->(!eof())             

	
	// Caso passe mais de uma vez pelo mesmo IMEI + NFEntrada, deleta o registro no arquivo gerado
	if TRB->NFE+TRB->IMEI=_cNFEIMEI
		RecLock("TRB",.F.)
		dbdelete()
		MsUnlock()
		TRB->(dbSkip())
		Loop
	else
		_cNFEIMEI:= TRB->NFE+TRB->IMEI
	endif

	if mv_par12 == 1  // Excel 2007
		_diadoca:=SUBSTR(TRB->ENTRDOCA,7,2)
		_mesdoca:=SUBSTR(TRB->ENTRDOCA,5,2)
		_anodoca:=SUBSTR(TRB->ENTRDOCA,1,4)
		_diaentr:=SUBSTR(TRB->ENTRADA,7,2)
		_mesentr:=SUBSTR(TRB->ENTRADA,5,2)
		_anoentr:=SUBSTR(TRB->ENTRADA,1,4)
		_diaemis:=SUBSTR(TRB->SAIDDOCA,7,2)
		_mesemis:=SUBSTR(TRB->SAIDDOCA,5,2)
		_anoemis:=SUBSTR(TRB->SAIDDOCA,1,4)
	endif

	reclock("TRB",.f.)

	// Calcula tempo de reparo a partir da saida massiva
	if !empty(TRB->SAIDDOCA)
//		reclock("TRB",.f.)
		if !empty(TRB->ENTRDOCA)
			TRB->TEMPREP   := iif(empty(TRB->ENTRDOCA),0,iif(mv_par12==1,ctod(_diaemis+"/"+_mesemis+"/"+_anoemis)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca),TRB->SAIDDOCA-TRB->ENTRDOCA))
		else
			TRB->TEMPREP   := iif(empty(TRB->ENTRADA),0,iif(mv_par12==1,ctod(_diaemis+"/"+_mesemis+"/"+_anoemis)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr),TRB->SAIDDOCA-TRB->ENTRADA))
		endif
//		msunlock()
	else
		// Calcula tempo de reparo a partir da database
//		reclock("TRB",.f.)
		if !empty(TRB->ENTRDOCA)
			TRB->TEMPREP   := iif(empty(TRB->ENTRDOCA),0,iif(mv_par12==1,ddatabase-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca),ddatabase-TRB->ENTRDOCA))
		else
			TRB->TEMPREP   := iif(empty(TRB->ENTRADA),0,iif(mv_par12==1,ddatabase-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr),ddatabase-TRB->ENTRADA))
		endif
//		msunlock()
	endif
	
	// Incrementa regua
	//IncRegua()

	// Verifica data da ultima saida do IMEI
	_cDatEnt := iif(mv_par12 == 1, ctod(_diaentr + "/" + _mesentr + "/" + _anoentr) , TRB->ENTRADA)
	_dUltSai := u_UltSai(TRB->IMEI, _cDatEnt)
	_nBounce := 0
	if !empty(_dUltSai)
//		reclock("TRB",.f.)
		TRB->ULTSAIDA := iif(mv_par12 == 1, "20" + Substr(dtoc(_dUltSai),7,2) + Substr(dtoc(_dUltSai),4,2) + Substr(dtoc(_dUltSai),1,2),_dUltSai)
		TRB->BOUNCE   := iif(mv_par12 == 1, iif(ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai > 0, ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai, 0),iif(TRB->ENTRADA - _dUltSai > mv_par10, TRB->ENTRADA - _dUltSai, 0))
//		msunlock()
	endif
	
	// Identificacao da NF e DATA do Swap
	if mv_par11 <> 1 .and. !empty(TRB->NOVOSN)
		// Pesquiso o PV pelo IMEI novo do Swap para descobrir o numero + item do PV
		SC6->(dbSetOrder(11))  // C6_FILIAL + C6_IMEINOV + C6_NUM + C6_ITEM
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
//									reclock("TRB",.f.)
									TRB->NFNOVOSN := SD2->D2_DOC
									TRB->DTNFNSN  := iif(mv_par12==1,SUBSTR(DTOS(SD2->D2_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),5,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),1,4),SD2->D2_EMISSAO)
									TRB->DTSAINSN  :=iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
									if !empty(SD2->D2_EMISSAO)
										if !empty(TRB->ENTRDOCA)
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca)),iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
										else
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
										endif
									endif
//									msunlock()
								endif
								SD2->(dbSkip())
							enddo
						endif
					endif
				else
					if SC5->(dbSeek(xFilial("SC5") + SC6->C6_NUM)) .and. DTOS(SC5->C5_EMISSAO) >= TRB->ENTRADA
						// Pesquiso a NF pelo numero do PV para descobrir o numero da NF que sofreu a saida do IMEI de SWAP
						_dsaidoca:= ctod("  /  /  ")
						SD2->(dbSetOrder(8))  // D2_FILIAL + D2_PEDIDO + D2_ITEMPV
						if SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM + SC6->C6_ITEM))
							_dsaidoca := Posicione("SF2",1,xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_FORMUL,"F2_SAIROMA")
							while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_PEDIDO == SC6->C6_NUM .and. SD2->D2_ITEMPV == SC6->C6_ITEM
								if DTOS(SD2->D2_EMISSAO) >= TRB->ENTRADA
//									reclock("TRB",.f.)
									TRB->NFNOVOSN := SD2->D2_DOC
									TRB->DTNFNSN  := iif(mv_par12==1,SUBSTR(DTOS(SD2->D2_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),5,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),1,4),DTOC(SD2->D2_EMISSAO))
									TRB->DTSAINSN  :=iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
									if !empty(SD2->D2_EMISSAO)
										if !empty(TRB->ENTRDOCA)
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca)),iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
										else
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
										endif
									endif
//									msunlock()
								endif
								SD2->(dbSkip())
							enddo
						endif
					endif
				endif
				SC6->(dbSkip())
			enddo
		endif
	endif

	// Verifica qual fase deve ser reportada de acordo com o ZZ1 e corrige se necessario
	_aFase := VerFase(TRB->IMEI, left(TRB->OS,6))
	if !empty(_aFase[1])
		TRB->FASE     := _aFase[1]
		TRB->DESCFASE := _aFase[2]
	endif  
	
	// Preenche descricao da Reclamacao do cliente --Edson Rodrigues set/09     
	_cLAB:=Posicione("ZZ3",1,xFilial("ZZ3") + TRB->IMEI+ left(TRB->OS,6)+space(2), "ZZ3_LAB" )    
	_cdefcli:=IIF(!EMPTY(TRB->DEFCLIEN),alltrim(TRB->DEFCLIEN)+space(6-LEN(alltrim(TRB->DEFCLIEN))),"")       
    if !empty(_cdefcli)
	   TRB->DESCDEFCL:=Posicione("ZZG",1,xFilial("ZZG") + _cLAB + _cdefcli, "ZZG_DESCRI" )
	Endif    


	TRB->(msunlock())

	TRB->(dbSkip())
	
Enddo

_cArq1  := "CYCLETIME_JOB_22_jcarlos.XLS"  
_cArq2  := "CYCLETIME_JOB_22_dsouza.XLS"
_cArq3  := "CYCLETIME_JOB_22_lcasteluci.XLS"  
_cArq4  := "CYCLETIME_JOB_10_mbaldoino.XLS"  
_cArq5  := "CYCLETIME_JOB_22_msiqueira.XLS" 
_dirrel1 :="Relato\jcarlos\   
_dirrel2 :="Relato\dsouza\
_dirrel3 :="Relato\luiz\
_dirrel4 :="Relato\mbaldoino\
_dirrel5 :="Relato\msiqueira\

_lOPen := .f.

if nConta > 0
	While !_lOpen
		   dbselectarea("TRB")
		   	copy to &(_dirrel1+_cArq1) VIA "DBFCDXADS" 
		   	copy to &(_dirrel2+_cArq2) VIA "DBFCDXADS"
		   	copy to &(_dirrel3+_cArq3) VIA "DBFCDXADS"
		   	copy to &(_dirrel5+_cArq5) VIA "DBFCDXADS"
		   	copy to &(__reldir+_cArq)
		   	ShellExecute( "Open" , "\\"+_csrvapl+__reldir+_cArq ,"", "" , 3 )
			_lOpen := .t.
	EndDo
//else
//	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
endif
TRB->(dbCloseArea())

U_RESTAMB( aAmb )
DBSELECTAREA( cAlias )

Return
                      




Static Function fRL01B()

Local cAlias := ALIAS()
Local aAlias := {"SD1","SD2","SZ1","AB9","AA3","SA1","SB1","SBM","SC6","SX5","ZZ3","ZZ4"}
Local aAmb   := U_GETAMB( aAlias )
Local nTotal := 0
Private _cArqTrab := CriaTrab(,.f.)
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "G"
Private nomeprog    := "RL01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RL01"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RL01" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SD1"
private CR	 		:= chr(13) + chr(10)
private _cLab       := ""
private _cdefcli    := ""

dbSelectArea("SC6")
//DbSetOrder(9)  //C6_FILIAL+C6_NUMSERI
SC6->(DBOrderNickName('SC6IMEI'))// C6_FILIAL + C6_NUMSERI

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
DbSetOrder(5) //D2_FILIAL+DTOS(D2_EMISSAO)+D2_NUMSEQ                  

dbSelectArea("SF2")
DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

dbSelectArea("SZ1")
DbSetOrder(6) //Z1_FILIAL+Z1_CODBAR+Z1_TIPO

dbSelectArea("AB9")
DbSetOrder(5) //AB9_FILIAL+AB9_SN

dbSelectArea("AA3")
DbSetOrder(6) //AA3_FILIAL+AA3_NUMSER

/*
u_qryCycle(ctod("01/01/07"), dDataBase, ctod("01/01/07"), dDataBase, "2", '26-27', "", 1, 3, 0, 3,2,.T.)

TRB->(dbGoTop())
While TRB->(!eof()) 
	
	// Verifica data da ultima saida do IMEI
	_dUltSai := u_VerUltSai(TRB->IMEI, TRB->ENTRADA)
	_nBounce := 0
	if !empty(_dUltSai)
		reclock("TRB",.f.)
		TRB->ULTSAIDA := _dUltSai
		TRB->BOUNCE   := iif(TRB->ENTRADA - _dUltSai > 0, TRB->ENTRADA - _dUltSai, 0)
		msunlock()
	endif                       
	
		// Identificacao da NF e DATA do Swap
	if !empty(TRB->NOVOSN)
		// Pesquiso o PV pelo IMEI novo do Swap para descobrir o numero + item do PV
		SC6->(dbSetOrder(11))  // C6_FILIAL + C6_IMEINOV + C6_NUM + C6_ITEM
		if SC6->(dbSeek(xFilial("SC6") + TRB->NOVOSN))
			while SC6->(!eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. alltrim(SC6->C6_IMEINOV) == alltrim(TRB->NOVOSN)
				SC5->(dbSetOrder(1))
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
								TRB->DTNFNSN  := SD2->D2_EMISSAO
							    TRB->DTSAINSN  :=_dsaidoca
							    IF !EMPTY(SD2->D2_EMISSAO)
							     	IF !EMPTY(TRB->ENTRDOCA)
                           	     	  TRB->TEMPREP   := iif(EMPTY(TRB->ENTRDOCA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA)
                           	     	  TRB->SAIDDOCA  := _dsaidoca  
                           	        ELSE  	                                                                            
                           	          TRB->TEMPREP   := iif(EMPTY(TRB->ENTRADA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA)	   
                           	          TRB->SAIDDOCA  := _dsaidoca 
                                 	ENDIF   
                             	ENDIF 
								msunlock()
							endif
							SD2->(dbSkip())
						enddo
					endif
				endif
				SC6->(dbSkip())
			enddo
		endif
	endif
   TRB->(dbSkip())
Enddo
*/

//ALTERADO PARA CONTEMPLAR AS NOVAS ALTERACOES DO CYCLOTIME - EDSON RODRIGUES 28/09/08
u_qryCycNew(ctod("01/01/09"), dDataBase, ctod("01/01/09"), dDataBase, "2", '26-27', "", 1, 3, 0, 2,2,.T.)
mv_par11 := 2
mv_par12 := 2     
mv_par10 := 0
_cNFEIMEI:=""
TRB->(dbGoTop())
While TRB->(!eof())             

	
	// Caso passe mais de uma vez pelo mesmo IMEI + NFEntrada, deleta o registro no arquivo gerado
	if TRB->NFE+TRB->IMEI=_cNFEIMEI
		RecLock("TRB",.F.)
		dbdelete()
		MsUnlock()
		TRB->(dbSkip())
		Loop
	else
		_cNFEIMEI:= TRB->NFE+TRB->IMEI
	endif

	if mv_par12 == 1  // Excel 2007
		_diadoca:=SUBSTR(TRB->ENTRDOCA,7,2)
		_mesdoca:=SUBSTR(TRB->ENTRDOCA,5,2)
		_anodoca:=SUBSTR(TRB->ENTRDOCA,1,4)
		_diaentr:=SUBSTR(TRB->ENTRADA,7,2)
		_mesentr:=SUBSTR(TRB->ENTRADA,5,2)
		_anoentr:=SUBSTR(TRB->ENTRADA,1,4)
		_diaemis:=SUBSTR(TRB->SAIDDOCA,7,2)
		_mesemis:=SUBSTR(TRB->SAIDDOCA,5,2)
		_anoemis:=SUBSTR(TRB->SAIDDOCA,1,4)
	endif

	reclock("TRB",.f.)

	// Calcula tempo de reparo a partir da saida massiva
	if !empty(TRB->SAIDDOCA)
//		reclock("TRB",.f.)
		if !empty(TRB->ENTRDOCA)
			TRB->TEMPREP   := iif(empty(TRB->ENTRDOCA),0,iif(mv_par12==1,ctod(_diaemis+"/"+_mesemis+"/"+_anoemis)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca),TRB->SAIDDOCA-TRB->ENTRDOCA))
		else
			TRB->TEMPREP   := iif(empty(TRB->ENTRADA),0,iif(mv_par12==1,ctod(_diaemis+"/"+_mesemis+"/"+_anoemis)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr),TRB->SAIDDOCA-TRB->ENTRADA))
		endif
//		msunlock()
	else
		// Calcula tempo de reparo a partir da database
//		reclock("TRB",.f.)
		if !empty(TRB->ENTRDOCA)
			TRB->TEMPREP   := iif(empty(TRB->ENTRDOCA),0,iif(mv_par12==1,ddatabase-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca),ddatabase-TRB->ENTRDOCA))
		else
			TRB->TEMPREP   := iif(empty(TRB->ENTRADA),0,iif(mv_par12==1,ddatabase-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr),ddatabase-TRB->ENTRADA))
		endif
//		msunlock()
	endif
	
	// Incrementa regua
	//IncRegua()

	// Verifica data da ultima saida do IMEI
	_cDatEnt := iif(mv_par12 == 1, ctod(_diaentr + "/" + _mesentr + "/" + _anoentr) , TRB->ENTRADA)
	_dUltSai := u_UltSai(TRB->IMEI, _cDatEnt)
	_nBounce := 0
	if !empty(_dUltSai)
//		reclock("TRB",.f.)
		TRB->ULTSAIDA := iif(mv_par12 == 1, "20" + Substr(dtoc(_dUltSai),7,2) + Substr(dtoc(_dUltSai),4,2) + Substr(dtoc(_dUltSai),1,2),_dUltSai)
		TRB->BOUNCE   := iif(mv_par12 == 1, iif(ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai > 0, ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai, 0),iif(TRB->ENTRADA - _dUltSai > mv_par10, TRB->ENTRADA - _dUltSai, 0))
//		msunlock()
	endif
	
	// Identificacao da NF e DATA do Swap
	if mv_par11 <> 1 .and. !empty(TRB->NOVOSN)
		// Pesquiso o PV pelo IMEI novo do Swap para descobrir o numero + item do PV
		SC6->(dbSetOrder(11))  // C6_FILIAL + C6_IMEINOV + C6_NUM + C6_ITEM
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
//									reclock("TRB",.f.)
									TRB->NFNOVOSN := SD2->D2_DOC
									TRB->DTNFNSN  := iif(mv_par12==1,SUBSTR(DTOS(SD2->D2_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),5,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),1,4),SD2->D2_EMISSAO)
									TRB->DTSAINSN  :=iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
									if !empty(SD2->D2_EMISSAO)
										if !empty(TRB->ENTRDOCA)
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca)),iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
										else
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
										endif
									endif
//									msunlock()
								endif
								SD2->(dbSkip())
							enddo
						endif
					endif
				else
					if SC5->(dbSeek(xFilial("SC5") + SC6->C6_NUM)) .and. DTOS(SC5->C5_EMISSAO) >= TRB->ENTRADA
						// Pesquiso a NF pelo numero do PV para descobrir o numero da NF que sofreu a saida do IMEI de SWAP
						_dsaidoca:= ctod("  /  /  ")
						SD2->(dbSetOrder(8))  // D2_FILIAL + D2_PEDIDO + D2_ITEMPV
						if SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM + SC6->C6_ITEM))
							_dsaidoca := Posicione("SF2",1,xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_FORMUL,"F2_SAIROMA")
							while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_PEDIDO == SC6->C6_NUM .and. SD2->D2_ITEMPV == SC6->C6_ITEM
								if DTOS(SD2->D2_EMISSAO) >= TRB->ENTRADA
//									reclock("TRB",.f.)
									TRB->NFNOVOSN := SD2->D2_DOC
									TRB->DTNFNSN  := iif(mv_par12==1,SUBSTR(DTOS(SD2->D2_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),5,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),1,4),DTOC(SD2->D2_EMISSAO))
									TRB->DTSAINSN  :=iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
									if !empty(SD2->D2_EMISSAO)
										if !empty(TRB->ENTRDOCA)
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca)),iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
										else
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
										endif
									endif
//									msunlock()
								endif
								SD2->(dbSkip())
							enddo
						endif
					endif
				endif
				SC6->(dbSkip())
			enddo
		endif
	endif

	// Verifica qual fase deve ser reportada de acordo com o ZZ1 e corrige se necessario
	_aFase := VerFase(TRB->IMEI, left(TRB->OS,6))
	if !empty(_aFase[1])
		TRB->FASE     := _aFase[1]
		TRB->DESCFASE := _aFase[2]
	endif                  
	
	// Preenche descricao da Reclamacao do cliente --Edson Rodrigues set/09     
	_cLAB:=Posicione("ZZ3",1,xFilial("ZZ3") + TRB->IMEI+ left(TRB->OS,6)+space(2), "ZZ3_LAB" )    
	_cdefcli:=IIF(!EMPTY(TRB->DEFCLIEN),alltrim(TRB->DEFCLIEN)+space(6-LEN(alltrim(TRB->DEFCLIEN))),"")       
    if !empty(_cdefcli)
	   TRB->DESCDEFCL:=Posicione("ZZG",1,xFilial("ZZG") + _cLAB + _cdefcli, "ZZG_DESCRI" )
	Endif    


	TRB->(msunlock())

	TRB->(dbSkip())
	
Enddo

_cArq1  := "CYCLETIME_JOB_26-27_jcarlos.XLS"  
_cArq2  := "CYCLETIME_JOB_26-27_dsouza.XLS"
_cArq3  := "CYCLETIME_JOB_26-27_lcasteluci.XLS"  
_cArq4  := "CYCLETIME_JOB_10_mbaldoino.XLS"  
_cArq5  := "CYCLETIME_JOB_26-27_msiqueira.XLS" 
_dirrel1 :="Relato\jcarlos\   
_dirrel2 :="Relato\dsouza\
_dirrel3 :="Relato\luiz\
_dirrel4 :="Relato\mbaldoino\
_dirrel5 :="Relato\msiqueira\


_lOPen := .f.

if nConta > 0
	While !_lOpen
		dbselectarea("TRB")
		   	copy to &(_dirrel1+_cArq1) VIA "DBFCDXADS"
		   	copy to &(_dirrel2+_cArq2) VIA "DBFCDXADS"
		   	copy to &(_dirrel3+_cArq3) VIA "DBFCDXADS"
		   	copy to &(_dirrel5+_cArq5) VIA "DBFCDXADS"
		   _lOpen := .t.
    EndDo
else
	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
endif
TRB->(dbCloseArea())

U_RESTAMB( aAmb )
DBSELECTAREA( cAlias )

Return



Static Function fRL01C()

Local cAlias := ALIAS()
Local aAlias := {"SD1","SD2","SZ1","AB9","AA3","SA1","SB1","SBM","SC6","SX5","ZZ3","ZZ4"}
Local aAmb   := U_GETAMB( aAlias )
Local nTotal := 0
Private _cArqTrab := CriaTrab(,.f.)
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "G"
Private nomeprog    := "RL01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RL01"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RL01" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SD1"
private CR	 		:= chr(13) + chr(10)          
Private _cLAB       := ""
Private _cdefcli    := ""


dbSelectArea("SC6")
//DbSetOrder(9)  //C6_FILIAL+C6_NUMSERI
SC6->(DBOrderNickName('SC6IMEI'))// C6_FILIAL + C6_NUMSERI

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
DbSetOrder(5) //D2_FILIAL+DTOS(D2_EMISSAO)+D2_NUMSEQ                  

dbSelectArea("SF2")
DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

dbSelectArea("SZ1")
DbSetOrder(6) //Z1_FILIAL+Z1_CODBAR+Z1_TIPO

dbSelectArea("AB9")
DbSetOrder(5) //AB9_FILIAL+AB9_SN

dbSelectArea("AA3")
DbSetOrder(6) //AA3_FILIAL+AA3_NUMSER

/*
u_qryCycle(ctod("01/06/07"), dDataBase, ctod("01/06/07"), dDataBase, "2", '10', "", 1, 3, 0, 3,1,.T.)

TRB->(dbGoTop())
While TRB->(!eof())                   
_diadoca:=SUBSTR(TRB->ENTRDOCA,7,2)
     _mesdoca:=SUBSTR(TRB->ENTRDOCA,5,2)
     _anodoca:=SUBSTR(TRB->ENTRDOCA,1,4)
     _diaentr:=SUBSTR(TRB->ENTRADA,7,2)
     _mesentr:=SUBSTR(TRB->ENTRADA,5,2)
     _anoentr:=SUBSTR(TRB->ENTRADA,1,4)   
     _diaemis:=SUBSTR(TRB->SAIDDOCA,7,2)
     _mesemis:=SUBSTR(TRB->SAIDDOCA,5,2)
     _anoemis:=SUBSTR(TRB->SAIDDOCA,1,4)       
              

	// Verifica data da ultima saida do IMEI
	_dUltSai := VerUltSai(TRB->IMEI, ctod(_diaentr+"/"+_mesentr+"/"+_anoentr))
	_nBounce := 0
	if !empty(_dUltSai)
		reclock("TRB",.f.)
		TRB->ULTSAIDA := "20"+SUBSTR(dtoc(_dUltSai),7,2)+SUBSTR(dtoc(_dUltSai),4,2)+SUBSTR(dtoc(_dUltSai),1,2)
		TRB->BOUNCE   := iif(ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai > 0, ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai, 0)
		msunlock()
	endif                       
	
		// Identificacao da NF e DATA do Swap
	if !empty(TRB->NOVOSN)
		// Pesquiso o PV pelo IMEI novo do Swap para descobrir o numero + item do PV
		SC6->(dbSetOrder(11))  // C6_FILIAL + C6_IMEINOV + C6_NUM + C6_ITEM
		if SC6->(dbSeek(xFilial("SC6") + TRB->NOVOSN))
			while SC6->(!eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. alltrim(SC6->C6_IMEINOV) == alltrim(TRB->NOVOSN)
				SC5->(dbSetOrder(1))
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
								TRB->DTNFNSN  := SD2->D2_EMISSAO
								TRB->DTSAINSN  :=_dsaidoca
							    IF !EMPTY(SD2->D2_EMISSAO)
							     	IF !EMPTY(TRB->ENTRDOCA)
                           	     	  TRB->TEMPREP   := iif(EMPTY(TRB->ENTRDOCA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca))
                           	     	  TRB->SAIDDOCA  := _dsaidoca
                           	        ELSE  	                                                                            
                           	          TRB->TEMPREP   := iif(EMPTY(TRB->ENTRADA),0,iif(EMPTY(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr))	
                           	          TRB->SAIDDOCA  := _dsaidoca
                                 	ENDIF   
                             	ENDIF 
								msunlock()
							endif
							SD2->(dbSkip())
						enddo
					endif
				endif
				SC6->(dbSkip())
			enddo
		endif
	endif
	TRB->(dbSkip())

Enddo
*/

u_qryCycNew(ctod("01/01/09"), dDataBase, ctod("01/01/09"), dDataBase, "2", '10', "", 1, 3, 0, 2,1,.T.)
mv_par11 := 2
mv_par12 := 1     
mv_par10 := 0
_cNFEIMEI:=""
TRB->(dbGoTop())
While TRB->(!eof())             

	
	// Caso passe mais de uma vez pelo mesmo IMEI + NFEntrada, deleta o registro no arquivo gerado
	if TRB->NFE+TRB->IMEI=_cNFEIMEI
		RecLock("TRB",.F.)
		dbdelete()
		MsUnlock()
		TRB->(dbSkip())
		Loop
	else
		_cNFEIMEI:= TRB->NFE+TRB->IMEI
	endif

	if mv_par12 == 1  // Excel 2007
		_diadoca:=SUBSTR(TRB->ENTRDOCA,7,2)
		_mesdoca:=SUBSTR(TRB->ENTRDOCA,5,2)
		_anodoca:=SUBSTR(TRB->ENTRDOCA,1,4)
		_diaentr:=SUBSTR(TRB->ENTRADA,7,2)
		_mesentr:=SUBSTR(TRB->ENTRADA,5,2)
		_anoentr:=SUBSTR(TRB->ENTRADA,1,4)
		_diaemis:=SUBSTR(TRB->SAIDDOCA,7,2)
		_mesemis:=SUBSTR(TRB->SAIDDOCA,5,2)
		_anoemis:=SUBSTR(TRB->SAIDDOCA,1,4)
	endif

	reclock("TRB",.f.)

	// Calcula tempo de reparo a partir da saida massiva
	if !empty(TRB->SAIDDOCA)
//		reclock("TRB",.f.)
		if !empty(TRB->ENTRDOCA)
			TRB->TEMPREP   := iif(empty(TRB->ENTRDOCA),0,iif(mv_par12==1,ctod(_diaemis+"/"+_mesemis+"/"+_anoemis)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca),TRB->SAIDDOCA-TRB->ENTRDOCA))
		else
			TRB->TEMPREP   := iif(empty(TRB->ENTRADA),0,iif(mv_par12==1,ctod(_diaemis+"/"+_mesemis+"/"+_anoemis)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr),TRB->SAIDDOCA-TRB->ENTRADA))
		endif
//		msunlock()
	else
		// Calcula tempo de reparo a partir da database
//		reclock("TRB",.f.)
		if !empty(TRB->ENTRDOCA)
			TRB->TEMPREP   := iif(empty(TRB->ENTRDOCA),0,iif(mv_par12==1,ddatabase-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca),ddatabase-TRB->ENTRDOCA))
		else
			TRB->TEMPREP   := iif(empty(TRB->ENTRADA),0,iif(mv_par12==1,ddatabase-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr),ddatabase-TRB->ENTRADA))
		endif
//		msunlock()
	endif
	
	// Incrementa regua
	//IncRegua()

	// Verifica data da ultima saida do IMEI
	_cDatEnt := iif(mv_par12 == 1, ctod(_diaentr + "/" + _mesentr + "/" + _anoentr) , TRB->ENTRADA)
	_dUltSai := u_UltSai(TRB->IMEI, _cDatEnt)
	_nBounce := 0
	if !empty(_dUltSai)
//		reclock("TRB",.f.)
		TRB->ULTSAIDA := iif(mv_par12 == 1, "20" + Substr(dtoc(_dUltSai),7,2) + Substr(dtoc(_dUltSai),4,2) + Substr(dtoc(_dUltSai),1,2),_dUltSai)
		TRB->BOUNCE   := iif(mv_par12 == 1, iif(ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai > 0, ctod(_diaentr+"/"+_mesentr+"/"+_anoentr) - _dUltSai, 0),iif(TRB->ENTRADA - _dUltSai > mv_par10, TRB->ENTRADA - _dUltSai, 0))
//		msunlock()
	endif
	
	// Identificacao da NF e DATA do Swap
	if mv_par11 <> 1 .and. !empty(TRB->NOVOSN)
		// Pesquiso o PV pelo IMEI novo do Swap para descobrir o numero + item do PV
		SC6->(dbSetOrder(11))  // C6_FILIAL + C6_IMEINOV + C6_NUM + C6_ITEM
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
//									reclock("TRB",.f.)
									TRB->NFNOVOSN := SD2->D2_DOC
									TRB->DTNFNSN  := iif(mv_par12==1,SUBSTR(DTOS(SD2->D2_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),5,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),1,4),SD2->D2_EMISSAO)
									TRB->DTSAINSN  :=iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
									if !empty(SD2->D2_EMISSAO)
										if !empty(TRB->ENTRDOCA)
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca)),iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
										else
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),_dsaidoca)
										endif
									endif
//									msunlock()
								endif
								SD2->(dbSkip())
							enddo
						endif
					endif
				else
					if SC5->(dbSeek(xFilial("SC5") + SC6->C6_NUM)) .and. DTOS(SC5->C5_EMISSAO) >= TRB->ENTRADA
						// Pesquiso a NF pelo numero do PV para descobrir o numero da NF que sofreu a saida do IMEI de SWAP
						_dsaidoca:= ctod("  /  /  ")
						SD2->(dbSetOrder(8))  // D2_FILIAL + D2_PEDIDO + D2_ITEMPV
						if SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM + SC6->C6_ITEM))
							_dsaidoca := Posicione("SF2",1,xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_FORMUL,"F2_SAIROMA")
							while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_PEDIDO == SC6->C6_NUM .and. SD2->D2_ITEMPV == SC6->C6_ITEM
								if DTOS(SD2->D2_EMISSAO) >= TRB->ENTRADA
//									reclock("TRB",.f.)
									TRB->NFNOVOSN := SD2->D2_DOC
									TRB->DTNFNSN  := iif(mv_par12==1,SUBSTR(DTOS(SD2->D2_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),5,2)+"/"+SUBSTR(DTOS(SD2->D2_EMISSAO),1,4),DTOC(SD2->D2_EMISSAO))
									TRB->DTSAINSN  :=iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
									if !empty(SD2->D2_EMISSAO)
										if !empty(TRB->ENTRDOCA)
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diadoca+"/"+_mesdoca+"/"+_anodoca)),iif(empty(TRB->ENTRDOCA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRDOCA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
										else
											TRB->TEMPREP   := iif(mv_par12==1,iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-ctod(_diaentr+"/"+_mesentr+"/"+_anoentr)),iif(empty(TRB->ENTRADA),0,iif(empty(_dsaidoca),ddatabase,_dsaidoca)-TRB->ENTRADA))
											TRB->SAIDDOCA  := iif(mv_par12==1,SUBSTR(DTOS(_dsaidoca),7,2)+"/"+SUBSTR(DTOS(_dsaidoca),5,2)+"/"+SUBSTR(DTOS(_dsaidoca),1,4),DTOC(_dsaidoca))
										endif
									endif
//									msunlock()
								endif
								SD2->(dbSkip())
							enddo
						endif
					endif
				endif
				SC6->(dbSkip())
			enddo
		endif
	endif

	// Verifica qual fase deve ser reportada de acordo com o ZZ1 e corrige se necessario
	_aFase := VerFase(TRB->IMEI, left(TRB->OS,6))
	if !empty(_aFase[1])
		TRB->FASE     := _aFase[1]
		TRB->DESCFASE := _aFase[2]
	endif            
	
	// Preenche descricao da Reclamacao do cliente --Edson Rodrigues set/09     
	_cLAB:=Posicione("ZZ3",1,xFilial("ZZ3") + TRB->IMEI+ left(TRB->OS,6)+space(2), "ZZ3_LAB" )    
	_cdefcli:=IIF(!EMPTY(TRB->DEFCLIEN),alltrim(TRB->DEFCLIEN)+space(6-LEN(alltrim(TRB->DEFCLIEN))),"")       
    if !empty(_cdefcli)
	   TRB->DESCDEFCL:=Posicione("ZZG",1,xFilial("ZZG") + _cLAB + _cdefcli, "ZZG_DESCRI" )
	Endif 

	TRB->(msunlock())

	TRB->(dbSkip())
	
Enddo

_cArq1  := "CYCLETIME_JOB_10_jcarlos.XLS"  
_cArq2  := "CYCLETIME_JOB_10_dsouza.XLS"
_cArq3  := "CYCLETIME_JOB_26-27_lcasteluci.XLS"  
_cArq4  := "CYCLETIME_JOB_10_mbaldoino.XLS"  
_cArq5  := "CYCLETIME_JOB_26-27_msiqueira.XLS" 
_cArq6  := "CYCLETIME_JOB_26-27_WSantos.XLS" 
_dirrel1 :="Relato\jcarlos\   
_dirrel2 :="Relato\dsouza\
_dirrel3 :="Relato\luiz\
_dirrel4 :="Relato\mbaldoino\
_dirrel5 :="Relato\msiqueira\ 
_dirrel6 :="Relato\wsantos\



_lOPen := .f.

if nConta > 0
	While !_lOpen
		dbselectarea("TRB")
		   	copy to &(_dirrel1+_cArq1) VIA "DBFCDXADS"
		   	copy to &(_dirrel2+_cArq2) VIA "DBFCDXADS"
		   	copy to &(_dirrel4+_cArq4) VIA "DBFCDXADS"
		   	copy to &(_dirrel6+_cArq6) VIA "DBFCDXADS"
		   _lOpen := .t.
    EndDo
else
	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
endif
TRB->(dbCloseArea())

U_RESTAMB( aAmb )
DBSELECTAREA( cAlias )

Return                    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECRX022  ºAutor  ³Microsiga           º Data ³  07/29/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function VerFase(_cIMEI, _cNumOS)

local _cQuery  := ""
local _aFase   := {"",""}  // Codigo, Descricao

_cQuery += " SELECT ZZ4_IMEI, "
_cQuery += "        FASEATU  = ZZ4_FASATU, "
_cQuery += "        DESFATU  = ZZ1_4.ZZ1_DESFA1, "
_cQuery += "        FASEFAB  = CASE WHEN ZZ1_3.ZZ1_CODFAB = '' THEN ZZ1_3.ZZ1_FASE1  ELSE ZZ1_3.ZZ1_CODFAB END, "
_cQuery += "        DESFFAB  = CASE WHEN ZZ1_3.ZZ1_DESFAB = '' THEN ZZ1_3.ZZ1_DESFA1 ELSE ZZ1_3.ZZ1_DESFAB END,"
_cQuery += "        GRAU     = ZZ1_3.ZZ1_GRAU, "
_cQuery += "        ZZ3_LAB, ZZ3_CODSET, ZZ3_DATA"
_cQuery += " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQuery += " JOIN   "+RetSqlName("ZZ3")+" AS ZZ3 (nolock) "
_cQuery += " ON     ZZ3_FILIAL = ZZ4_FILIAL AND ZZ3_IMEI = ZZ4_IMEI AND LEFT(ZZ3_NUMOS,6) = LEFT(ZZ4_OS,6) AND ZZ3.D_E_L_E_T_ = '' "
_cQuery += " LEFT OUTER JOIN "+RetSqlName("ZZ1")+" AS ZZ1_4 (nolock) "
_cQuery += " ON     ZZ1_4.D_E_L_E_T_ = '' AND ZZ1_4.ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND ZZ1_4.ZZ1_LAB = ZZ3_LAB "
_cQuery += "        AND ZZ1_4.ZZ1_FASE1 = ZZ4_FASATU "
_cQuery += "        AND ZZ1_4.ZZ1_CODSET = CASE WHEN ZZ1_4.ZZ1_LAB = '1' THEN ZZ3_CODSET ELSE ZZ1_4.ZZ1_CODSET END "
_cQuery += " LEFT OUTER JOIN "+RetSqlName("ZZ1")+" AS ZZ1_3 (nolock) "
_cQuery += " ON     ZZ1_3.D_E_L_E_T_ = '' AND ZZ1_3.ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND ZZ1_3.ZZ1_LAB = ZZ3_LAB "
_cQuery += "        AND ZZ1_3.ZZ1_FASE1 = ZZ3_FASE1 AND ZZ1_3.ZZ1_TIPO = '1' "
_cQuery += "        AND ZZ1_3.ZZ1_CODSET = CASE WHEN ZZ1_3.ZZ1_LAB = '1' THEN ZZ3_CODSET ELSE ZZ1_3.ZZ1_CODSET END "
_cQuery += " WHERE  ZZ4.D_E_L_E_T_ = '' AND "
_cQuery += "        ZZ4_FILIAL     = '"+xFilial("ZZ4")+"' AND "
_cQuery += "        ZZ4_IMEI       = '"+_cIMEI +"' AND "
_cQuery += "        LEFT(ZZ4_OS,6) = '"+_cNumOS+"' "
_cQuery += " ORDER BY ZZ1_3.ZZ1_GRAU DESC"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"FAS",.T.,.T.)
FAS->(dbGoTop())

_aFase[1] := iif(!empty(FAS->FASEFAB), FAS->FASEFAB, FAS->FASEATU)
_aFase[2] := iif(!empty(FAS->FASEFAB), FAS->DESFFAB, FAS->DESFATU)

FAS->(dbCloseArea())

return(_aFase)