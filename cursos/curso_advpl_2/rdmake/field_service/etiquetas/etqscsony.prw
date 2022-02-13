#include 'protheus.ch'
#include 'rwmake.ch'
#INCLUDE "APVT100.CH"
#INCLUDE "TopConn.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EtqSCSony() 

PRIVATE cPerg     := "SCSONY"
PRIVATE LFECHA    :=.T.

CRIASX1() 

If !Pergunte(cPerg,.T.)
	Return
Else
	While LFECHA  
		If !Pergunte(cPerg,.T.)
			Return   
	     	LFECHA:=.F.
	  	Else   
	  		Processa({|| Exetsony()}, "Processando...")	      
	    Endif
	EndDo
Endif 

Processa({|| Exetsony()}, "Processando...")	
 
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function Exetsony()
Local _aLinH 	:= {08} 
Local _aColH 	:= {05,82} 
					
Local _aLin 	:= {34,36,40,42,44,46,48,58,68,78,88,98}
Local _aCol 	:= {05,42,62,69,65,15,51,30,73,33,48} 
Local _afont 	:= {"023,023","033,033","040,040","027,027","018,018","120,120"}
Local _aTamBar	:= {4}
Local aDistrib  := {}
Local aKit		:= {}
Local aFabric	:= {} 
					
Local _a3Lin	:= {05,09,12,15,19,21,23,25,27,28,29,31}

Local lRet 		:= .F.
Local aSAR		:= {}

Local cSI 		:= ""
Local cModelo	:= ""
Local cImei1	:= ""
Local cImei2	:= ""
Local cSN1		:= ""
Local cSN2		:= ""
Local cSN3		:= ""
Local cCor		:= "" 
Local cDescRep	:= ""

cSI 	:= AllTrim(mv_par01)
cModelo	:= AllTrim(mv_par02)
cImei1	:= AllTrim(mv_par03)
cImei2	:= AllTrim(mv_par04)
cSN1	:= AllTrim(mv_par05)
cSN2	:= AllTrim(mv_par06)
cCor	:= AllTrim(mv_par07)
cSN3	:= AllTrim(mv_par08) 
cDescRep:= Upper(AllTrim(mv_par09)) 

cFonte := _afont[1] 
nTmBar := _aTamBar[1] 

aAdd(aSAR,{"Este produto atende aos limites de taxa de"})
aAdd(aSAR,{"absor็ใo especifica (SAR) estabelecidos"})  
aAdd(aSAR,{"atrav้s ICNIRP, e regulamentadas pela"})  
aAdd(aSAR,{"Resolu็ใo 303 da Anatel"})

aAdd(aDistrib,{"DISTRIBUIDO POR"}) 
aAdd(aDistrib,{"Sony Ericsson Mobile Comm. do Brasil LTDA"})
aAdd(aDistrib,{"Rua Ramos Batista 198"}) 
aAdd(aDistrib,{"Sใo Paulo - SP"}) 
aAdd(aDistrib,{"CNPJ: 04.667.337/0001-08"}) 

aAdd(aFabric,{"FABRICADO POR"}) 
aAdd(aFabric,{"Foxconn do Brasil Ind. e Com. de"})
aAdd(aFabric,{"Eletr๔nicos Ltda."})
aAdd(aFabric,{"Rua Dalizio Silveira Barros, 370"}) 
aAdd(aFabric,{"Distrito Industrial Domingos Giomi Indaiatuba - SP"})
aAdd(aFabric,{"CNPJ: 04.009.604/0004-00"}) 
aAdd(aFabric,{"Ind๚stria Brasileira"})

If Upper(cModelo) $ "C5303" 
	lRet := .T.
	
	aAdd(aKit,{"Kit inclui: Telefone digital GSM, Bateria embutida, Carregador bivolt EP800,"}) 
	aAdd(aKit,{"Cabo de Mํdia, Handsfree portแtil est้reo, Doc. do usuแrio."})	
EndIf 	

If lRet

	MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.) 

	MSCBBEGIN(1,6)
	
	MSCBSAY(_aCol[1],_a3Lin[1],Upper(cModelo)+Space(5)+cCor,"N","0",_afont[3])
	MSCBSAY(_aCol[1],_a3Lin[2],"SI " + cSI + "PB","N","0",_afont[2])   
	
	If Upper(cModelo) = "C5303"	       
		MSCBSAY(_aCol[1],_a3Lin[3],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/","N","0",_afont[4])	
		MSCBSAY(_aCol[1],_a3Lin[4],"1900 & UMTS/HSPA Band 1/5/8 & LTE","N","0",_afont[4]) 
	EndIf   
	
	MSCBSAY(_aCol[1],_a3Lin[5] ,aFabric[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_a3Lin[6] ,aFabric[2][1],"N","0",cFonte)
	MSCBSAY(_aCol[1],_a3Lin[7] ,aFabric[3][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_a3Lin[8] ,aFabric[4][1],"N","0",cFonte) 
	MSCBSAY(_aCol[1],_a3Lin[9] ,aFabric[5][1],"N","0",cFonte)
	MSCBSAY(_aCol[1],_a3Lin[11],aFabric[6][1],"N","0",cFonte)
	MSCBSAY(_aCol[1],_a3Lin[12],aFabric[7][1],"N","0",_afont[4])
	
	MSCBSAYBAR(_aCol[3] ,_a3Lin[3],cImei1,"N","MB07",nTmBar,.F.,.T.,.F.,,2,1) 
    
	If !Empty(cImei2)
		MSCBSAY(_aCol[9],_a3Lin[5],"IMEI-2:"+cImei2,"N","0",_afont[5])
	EndIf	
	 
	MSCBSAYBAR(_aCol[5] ,_a3Lin[1],UPPER(cSN1),"N","MB07",nTmBar,.F.,.T.,.F.,,2,1)
	MSCBSAYBAR(_aCol[4] ,_a3Lin[7],UPPER(cSN2),"N","MB04",nTmBar,.F.,.T.,.F.,,2,1)
	
	MSCBSAY(_aCol[1],_aLin[1],aKit[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_aLin[2],aKit[2][1],"N","0",cFonte) 
	
	MSCBSAY(_aCol[1],_aLin[3],aDistrib[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_aLin[4],aDistrib[2][1],"N","0",cFonte) 
	MSCBSAY(_aCol[1],_aLin[5],aDistrib[3][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_aLin[6],aDistrib[4][1],"N","0",cFonte)
	MSCBSAY(_aCol[1],_aLin[7],aDistrib[5][1],"N","0",cFonte)
	  
	MSCBSAY(_aCol[2],_aLin[4],aSAR[1][1],"N","0",cFonte)
	MSCBSAY(_aCol[2],_aLin[5],aSAR[2][1],"N","0",cFonte)  
	MSCBSAY(_aCol[2],_aLin[6],aSAR[3][1],"N","0",cFonte)
	MSCBSAY(_aCol[2],_aLin[7],aSAR[4][1],"N","0",cFonte) 
	
	MSCBSAY(_aCol[8],_aLin[8],"APARELHO"	,"N","0",_afont[6])
	MSCBSAY(_aCol[8],_aLin[9],cDescRep		,"N","0",_afont[6])
	MSCBSAY(_aCol[11],_aLin[10],"-"			,"N","0",_afont[6])
	MSCBSAY(_aCol[8],_aLin[11],"SEM CAIXA"	,"N","0",_afont[6])
	MSCBSAY(_aCol[10],_aLin[12],"ORIGINAL"	,"N","0",_afont[6]) 
	
	MSCBEND()
	
	MSCBCLOSEPRINTER()	
Else
	apMsgInfo('Modelo desconhecido. Contate seu lํder.','Modelo desconhecido')
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function CriaSX1()
	
	// 	cGrupo	,cOrdem,cPergunt,cPerSpa,cPerEng		,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
    
	PutSX1(cPerg,"01","SI."			,"SI."			,"SI."			,"mv_ch1","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par01",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"02","Modelo"		,"Modelo"		,"Modelo"		,"mv_ch2","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par02",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"03","Imei 1"		,"Imei 1"		,"Imei 1"		,"mv_ch3","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par03",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"04","Imei 2"		,"Imei 2"		,"Imei 2"		,"mv_ch4","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par04",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"05","SN 1"		,"SN 1"			,"SN 1"			,"mv_ch5","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par05",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"06","SN 2"		,"SN 2"			,"SN 2"			,"mv_ch6","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par06",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"07","Cor"			,"Cor"			,"Cor"			,"mv_ch7","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par07",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"08","SN 3"		,"SN 3"			,"SN 3"			,"mv_ch8","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par08",""	,"","","",""		,"","",""	,"","","","","","","","") 
	PutSX1(cPerg,"09","Desc.Reparo"	,"Desc.Reparo"	,"Desc.Reparo"	,"mv_ch9","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par09",""	,"","","",""		,"","",""	,"","","","","","","","")

Return Nil