#include 'protheus.ch'
#include 'rwmake.ch'
#INCLUDE "APVT100.CH"
#INCLUDE "TopConn.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Vinicius Leonardo  º Data ³  19/02/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 		  													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EtqSony()                


//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "SA1","SB1"

PRIVATE cPerg     := "TPSONY"
PRIVATE LFECHA    :=.T.

CRIASX1()
//PERGUNTE(cPerg,.T.)       
  

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
      
      ENDDO

Endif

 
Return



Static function Exetsony()
Local _aLinH 	:= {08} 
Local _aColH 	:= {05,82} 
Local _aLin 	:= {03,05,10,12,14,16,18} 
Local _aCol 	:= {05,42,52,69,65,15,51,39,55} 
Local _afont 	:= {"023,023","033,033","040,040","027,027","018,018"}
Local _aTamBar	:= {4}
Local aDistrib  := {}
Local aKit		:= {}
Local aFabric	:= {}
Local a2Fabric  := {}
Local _a3Lin	:= {02,05,08,11,13,15,17,19,13} 
Local _a2Lin	:= {02,04,06,08,10,12,14,16,18,15,17,05} 

Local _a1Lin	:= {02,04,06,10,12,14,16,18,20,15,17,05}

Local cSI 		:= ""
Local cModelo	:= ""
Local cImei1	:= ""
Local cImei2	:= ""
Local cSN1		:= ""
Local cSN2		:= ""
Local cSN3		:= ""
Local cSN4		:= ""
Local cCor		:= "" 

cSI 	:= AllTrim(mv_par08)
cModelo	:= AllTrim(mv_par02)
cImei1	:= AllTrim(mv_par03)
cImei2	:= AllTrim(mv_par04)
cSN1	:= AllTrim(mv_par05)
cSN2	:= AllTrim(mv_par06)
cSN3	:= AllTrim(mv_par09)
cSN4	:= AllTrim(mv_par10)
cCor	:= AllTrim(mv_par07)

cFonte := _afont[1] 
cFont2 := _afont[2] 
cFont3 := _afont[4]

 
nTmBar := _aTamBar[1] 

MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.) 


If UPPER(cModelo) $ "D2212/D2243/D6643/D6633/E2124/E2306/D5833" //ESSE E MAIS OUTROS

	////////////////////////////////////////
	//IMPRIME PRIMEIRA ETIQUETA - XPERIA E3
	///////////////////////////////////////  
   
    IF !(UPPER(cModelo) $ "D6643/D6633")

			aAdd(aFabric,{"FABRICADO POR"}) 
			aAdd(aFabric,{"ARIMA COMUNICAÇÕES BRASIL LTDA. Rua Kanebo, 175 -"})
			aAdd(aFabric,{"Business Park Jundiaí #175, Kanebo St. Business Park Jundiai -"}) 
			aAdd(aFabric,{"13213-090 Jundiaí, São Paulo, Brasil. CNPJ: 10.337.888/0001-06"}) 
			aAdd(aFabric,{"Indústria Brasileira"}) 
			aAdd(aFabric,{""}) 
						
	ELSE
	
		    aAdd(aFabric,{"FABRICADO POR"})		    
			aAdd(aFabric,{"FIH do Brasil Ind. e Com. de Eletrônicos Ltda."})			
			aAdd(aFabric,{"Rua Dalizio Silveira Barros, 370"}) 
			aAdd(aFabric,{"Distrito Industrial Domingos Giomi Indaiatuba - SP"}) 
			aAdd(aFabric,{"CNPJ: 04.009.604/0004-00"}) 
			aAdd(aFabric,{"Indústria Brasileira"})	
			
	ENDIF		 
			
			
	MSCBBEGIN(1,6)
	
	MSCBSAY(_aCol[1],_a3Lin[1],UPPER(cModelo)+Space(5)+cCor,"N","0",_afont[3]) 
	
	IF UPPER(cModelo) $ "D2243/D6643/D6633"
        MSCBSAY(_aCol[1],_a3Lin[2],"SI " + cSI + " 2G/3G/LTE","N","0",_afont[2])
	    
	    IF UPPER(cModelo) = "D6643"
	    	MSCBSAY(_aCol[1],_a3Lin[3],"Xperia Z3","N","0",_afont[2]) // DESCRIÇÃO DO MODELO ? 
	    ELSEIF UPPER(cModelo) = "D6633" 
	    	MSCBSAY(_aCol[1],_a3Lin[3],"Xperia Z3 Dual","N","0",_afont[2]) // DESCRIÇÃO DO MODELO ?      
	    ELSE
	   		MSCBSAY(_aCol[1],_a3Lin[3],"Xperia E3","N","0",_afont[2]) // DESCRIÇÃO DO MODELO ?
	    ENDIF
	    
	ELSEIF UPPER(cModelo) $ "E2124"         
		MSCBSAY(_aCol[1],_a3Lin[2],"SI " + cSI + " 2G/3G","N","0",_afont[2])
	    MSCBSAY(_aCol[1],_a3Lin[3],"Xperia TM E4 Dual","N","0",_afont[2]) // DESCRIÇÃO DO MODELO ?  
	    
	    
	ELSEIF UPPER(cModelo) $ "D5833"         
		MSCBSAY(_aCol[1],_a3Lin[2],"SI " + cSI + " 2G/3G/LTE","N","0",_afont[2])
	    MSCBSAY(_aCol[1],_a3Lin[3],"Xperia Z3 Compact","N","0",_afont[2]) // DESCRIÇÃO DO MODELO ?
	    
	    
	ELSEIF UPPER(cModelo) $ "E2306"         
		MSCBSAY(_aCol[1],_a3Lin[2],"SI " + cSI + " Rev 3 2G/3G/LTE","N","0",_afont[2])
	    MSCBSAY(_aCol[1],_a3Lin[3],"Xperia M4 Aqua","N","0",_afont[2]) // DESCRIÇÃO DO MODELO ?
	ELSE
	    MSCBSAY(_aCol[1],_a3Lin[2],"SI " + cSI + " 2G/3G","N","0",_afont[2])
	    MSCBSAY(_aCol[1],_a3Lin[3],"Xperia E3 Dual","N","0",_afont[2]) // DESCRIÇÃO DO MODELO ?
	ENDIF
	MSCBSAY(_aCol[1],_a3Lin[4],aFabric[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_a3Lin[5],aFabric[2][1],"N","0",cFonte)
	MSCBSAY(_aCol[1],_a3Lin[6],aFabric[3][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_a3Lin[7],aFabric[4][1],"N","0",cFonte) 
	MSCBSAY(_aCol[1],_a3Lin[8],aFabric[5][1],"N","0",_afont[4])
	
	MSCBSAYBAR(_aCol[3] ,_a3Lin[3],cImei1,"N","MB07",nTmBar,.F.,.F.,.F.,,2,1)
	MSCBSAY(_aCol[7],_a3Lin[9],"IMEI-1:"+cImei1+"-IMEI-2:"+cImei2,"N","0",_afont[5])
	 
	MSCBSAYBAR(_aCol[5] ,_a3Lin[1],cSN1,"N","MB07",nTmBar,.F.,.T.,.F.,,2,1)
	MSCBSAYBAR(_aCol[4] ,_a3Lin[6],cSN2,"N","MB04",nTmBar,.F.,.T.,.F.,,2,1)
	
	MSCBEND()




ElseIf UPPER(cModelo) $ "D5322" //ESSE E MAIS OUTROS

	////////////////////////////////////////
	//IMPRIME SEGUNDA ETIQUETA - XPERIA T2
	/////////////////////////////////////// 
	
	aAdd(a2Fabric,{"FABRICADO POR"}) 
	aAdd(a2Fabric,{"FIH do Brasil Ind. e Com. de Eletrônicos Ltda."})
	aAdd(a2Fabric,{"Rua Dalizio Silveira Barros, 370"}) 
	aAdd(a2Fabric,{"Distrito Industrial Domingos Giomi Indaiatuba - SP"}) 
	aAdd(a2Fabric,{"CNPJ: 04.009.604/0004-00"}) 
	aAdd(a2Fabric,{"Indústria Brasileira"+Space(5)+"S/N: "+cSN3})
	
	MSCBBEGIN(1,6)
	
	MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia T2 Ultra Dual"+Space(5)+cCor,"N","0",cFonte) 
	MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	MSCBSAY(_aCol[1],_a2Lin[3],"850/900/1800/1900 & UMTS/HSPA bands 1/2/5/8","N","0",cFonte)
	 
	MSCBSAY(_aCol[1],_a2Lin[4],"IMEI-1:"+cImei1,"N","0",cFonte)	
	MSCBSAY(_aCol[2],_a2Lin[2],"SI " + cSI+Space(5)+"PB","N","0",cFonte)
	MSCBSAY(_aCol[2],_a2Lin[4],a2Fabric[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[2],_a2Lin[5],a2Fabric[2][1],"N","0",cFonte)
	MSCBSAY(_aCol[2],_a2Lin[6],a2Fabric[3][1],"N","0",cFonte)  
	MSCBSAY(_aCol[2],_a2Lin[7],a2Fabric[4][1],"N","0",cFonte) 
	MSCBSAY(_aCol[2],_a2Lin[8],a2Fabric[5][1],"N","0",cFonte)
	MSCBSAY(_aCol[2],_a2Lin[9],a2Fabric[6][1],"N","0",cFonte) 
	
	MSCBSAYBAR(_aCol[1] ,_a2Lin[5],cImei1,"N","MB07",nTmBar,.F.,.F.,.F.,,2,1) 
	MSCBSAY(_aCol[1],_a2Lin[10],"IMEI-2:"+cImei2,"N","0",cFonte)
	
	MSCBSAYBAR(_aCol[1] ,_a2Lin[11],cSN2,"N","MB04",nTmBar,.F.,.T.,.F.,,2,1)
	
	MSCBEND()


ElseIf UPPER(cModelo) $ "D5106/D2306/D6543/SGP551/C6943/C6843/C5303/C1604/D2403/C6503/ST26A" //ESSE E MAIS OUTROS

	////////////////////////////////////////
	//IMPRIME SEGUNDA ETIQUETA - XPERIA T2
	///////////////////////////////////////                        
    IF UPPER(cModelo) $ "SGP551"
	
		aAdd(a2Fabric,{"IMPORTADO POR"}) 
		aAdd(a2Fabric,{"Foxconn Brasil - Indaiatuba"})
		aAdd(a2Fabric,{"CNPJ: 04.009.604/0004-00"}) 
		aAdd(a2Fabric,{"Fabricado na China S/N: "+Space(5)+"S/N: "+cSN3}) 
		aAdd(a2Fabric,{""}) 
		aAdd(a2Fabric,{""})
		
	ELSEIF UPPER(cModelo) $ "D2104"
	
		aAdd(a2Fabric,{"FABRICADO POR"}) 
		aAdd(a2Fabric,{"ARIMA COMUNICAÇÕES BRASIL LTDA. Rua Kanebo, 175 -"})
		aAdd(a2Fabric,{"Business Park Jundiaí #175, Kanebo St. Business Park Jundiai -"}) 
		aAdd(a2Fabric,{"13213-090 Jundiaí, São Paulo, Brasil. CNPJ: 10.337.888/0001-06"}) 
		aAdd(a2Fabric,{"Indústria Brasileira"}) 
		aAdd(a2Fabric,{""}) 	
		
	ELSE	
    	aAdd(a2Fabric,{"FABRICADO POR"})
    	If UPPER(cModelo) $ "C2004/C5303/C1604/C6503/ST26A"
    		aAdd(a2Fabric,{"Foxconn do Brasil Ind. e Com. de Eletrônicos Ltda."})
    	Else 
			aAdd(a2Fabric,{"FIH do Brasil Ind. e Com. de Eletrônicos Ltda."})
		EndIf
		aAdd(a2Fabric,{"Rua Dalizio Silveira Barros, 370"}) 
		aAdd(a2Fabric,{"Distrito Industrial Domingos Giomi Indaiatuba - SP"}) 
		aAdd(a2Fabric,{"CNPJ: 04.009.604/0004-00"}) 
		aAdd(a2Fabric,{"Indústria Brasileira"+Space(5)+"S/N: "+cSN3})
	
	ENDIF	
		
	MSCBBEGIN(1,6)
	
	IF  UPPER(cModelo) = "D6543"
    	MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia Z2"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands B1/B2/B3/B4/B5/B7/B8","N","0",cFonte)  
	    
	ELSEIF UPPER(cModelo) = "C6943"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia Z1"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands 1/2/3/4/5/7/8/20","N","0",cFonte) 
	    
	ELSEIF UPPER(cModelo) = "ST26A"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia J"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands 1/2/3/4/5/7/8/20","N","0",cFonte)  
	       
	ELSEIF UPPER(cModelo) = "C6843"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia Z Ultra"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands B1/B2/B3/B4/B5/B7/B8/B20","N","0",cFonte)         
	
	ELSEIF UPPER(cModelo) = "SGP551"
		
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia Z2 Tablet"+Space(5)+cCor,"N","0",cFont2) 
	    MSCBSAY(_aCol[1],_a2Lin[12],"GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA Bands 1/2/4/5/8 & LTE Bands 1/2/3/4/5/7/8","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    //MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands B1/B2/B3/B4/B5/B7/B8","N","0",cFonte)
	
	ELSEIF UPPER(cModelo) = "C5303"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia SP"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/5/8 LTE Bands 1/3/5/7/8/20","N","0",cFonte)    
	
	ELSEIF UPPER(cModelo) = "C6503"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia SP"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/5/8 LTE Bands 1/3/5/7/8/20","N","0",cFonte)    
	    
	ELSEIF UPPER(cModelo) = "D2104"         
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia E1 Dual"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/2/5","N","0",cFonte)
	ELSEIF UPPER(cModelo) = "C2004"         
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia TM M Dual"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/2/4/5","N","0",cFonte) 	    
	ELSEIF UPPER(cModelo) = "D2403"         
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia M2 Aqua"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/5/8 LTE Bands 1/3/5/7/8/20","N","0",cFonte)    
	    
	ELSEIF UPPER(cModelo) = "C1604"    
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) +Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA Band 1/5/8","N","0",cFonte)      
	
	ELSE                  
	    IF UPPER(cModelo) = "D2306"
    	    MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia M2"+Space(5)+cCor,"N","0",cFonte) 
    	ELSE
            MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia T3"+Space(5)+cCor,"N","0",cFonte)     	
    	ENDIF    
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/2/4/5 & LTE band 4/7/17","N","0",cFonte)
	ENDIF 
    
    IF UPPER(cModelo) = "SGP551"
	    MSCBSAY(_aCol[1],_a2Lin[4],"SI:"+cSI+Space(5)+"PB","N","0",cFont3)	
	ELSE
        MSCBSAY(_aCol[1],_a2Lin[4],"SI:"+cSI+Space(5)+"PB","N","0",cFonte)		
	ENDIF     
	     
	//MSCBSAY(_aCol[2],_a2Lin[2],"SI " + cSI+Space(5)+"PB","N","0",cFonte)
	MSCBSAY(_aCol[2],_a2Lin[4],a2Fabric[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[2],_a2Lin[5],a2Fabric[2][1],"N","0",cFonte)
	MSCBSAY(_aCol[2],_a2Lin[6],a2Fabric[3][1],"N","0",cFonte)  
	MSCBSAY(_aCol[2],_a2Lin[7],a2Fabric[4][1],"N","0",cFonte) 
	MSCBSAY(_aCol[2],_a2Lin[8],a2Fabric[5][1],"N","0",cFonte)
	MSCBSAY(_aCol[2],_a2Lin[9],a2Fabric[6][1],"N","0",cFonte) 
	
	IF UPPER(cModelo) = "SGP551"
    
    	MSCBSAYBAR(_aCol[1] ,_a2Lin[5],cImei1,"N","MB07",nTmBar,.F.,.F.,.F.,,2,1) 
     	MSCBSAY(_aCol[1],_a2Lin[10],"IMEI:"+cImei1,"N","0",cFont3)
	
     	MSCBSAYBAR(_aCol[1] ,_a2Lin[11],cSN2,"N","MB04",nTmBar,.F.,.T.,.F.,,2,1)
    ELSE
    
    	MSCBSAYBAR(_aCol[1] ,_a2Lin[5],cImei1,"N","MB07",nTmBar,.F.,.F.,.F.,,2,1) 
     	MSCBSAY(_aCol[1],_a2Lin[10],"IMEI:"+cImei1,"N","0",cFonte)
	
     	MSCBSAYBAR(_aCol[1] ,_a2Lin[11],cSN2,"N","MB04",nTmBar,.F.,.T.,.F.,,2,1)
    ENDIF
	
	MSCBEND() 
	
ElseIf UPPER(cModelo) $ "D2104/C2004" //ESSE E MAIS OUTROS

	////////////////////////////////////////
	//IMPRIME SEGUNDA ETIQUETA - XPERIA T2
	///////////////////////////////////////                        
    IF UPPER(cModelo) $ "SGP551"
	
		aAdd(a2Fabric,{"IMPORTADO POR"}) 
		aAdd(a2Fabric,{"Foxconn Brasil - Indaiatuba"})
		aAdd(a2Fabric,{"CNPJ: 04.009.604/0004-00"}) 
		aAdd(a2Fabric,{"Fabricado na China S/N: "+Space(5)+"S/N: "+cSN3}) 
		aAdd(a2Fabric,{""}) 
		aAdd(a2Fabric,{""})
		
	ELSEIF UPPER(cModelo) $ "D2104"
	
		aAdd(a2Fabric,{"FABRICADO POR"+Space(5)+"SAP: "+cSN4}) 
		aAdd(a2Fabric,{"ARIMA COMUNICAÇÕES BRASIL LTDA. Rua Kanebo, 175 -"})
		aAdd(a2Fabric,{"Business Park Jundiaí #175, Kanebo St. Business Park Jundiai -"}) 
		aAdd(a2Fabric,{"13213-090 Jundiaí, São Paulo, Brasil. CNPJ: 10.337.888/0001-06"}) 
		aAdd(a2Fabric,{"Indústria Brasileira"}) 
		aAdd(a2Fabric,{""}) 	
		
	ELSE	
    	aAdd(a2Fabric,{"FABRICADO POR"+Space(5)+"SAP: "+cSN4})
    	If UPPER(cModelo) $ "C2004/C5303/C1604/C6503"
    		aAdd(a2Fabric,{"Foxconn do Brasil Ind. e Com. de Eletrônicos Ltda."})
    	Else 
			aAdd(a2Fabric,{"FIH do Brasil Ind. e Com. de Eletrônicos Ltda."})
		EndIf
		aAdd(a2Fabric,{"Rua Dalizio Silveira Barros, 370"}) 
		aAdd(a2Fabric,{"Distrito Industrial Domingos Giomi Indaiatuba - SP"}) 
		aAdd(a2Fabric,{"CNPJ: 04.009.604/0004-00"}) 
		aAdd(a2Fabric,{"Indústria Brasileira"+Space(5)+"S/N: "+cSN3})
	
	ENDIF	
		
	MSCBBEGIN(1,6)
	
	IF  UPPER(cModelo) = "D6543"
    	MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia Z2"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands B1/B2/B3/B4/B5/B7/B8","N","0",cFonte)  
	    
	ELSEIF UPPER(cModelo) = "C6943"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia Z1"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands 1/2/3/4/5/7/8/20","N","0",cFonte) 
	ELSEIF UPPER(cModelo) = "C6843"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia Z Ultra"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands B1/B2/B3/B4/B5/B7/B8/B20","N","0",cFonte)         
	
	ELSEIF UPPER(cModelo) = "SGP551"
		
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia Z2 Tablet"+Space(5)+cCor,"N","0",cFont2) 
	    MSCBSAY(_aCol[1],_a2Lin[12],"GSM/GPRS/EDGE 850/900/1800/1900 & UMTS/HSPA Bands 1/2/4/5/8 & LTE Bands 1/2/3/4/5/7/8","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    //MSCBSAY(_aCol[1],_a2Lin[3],"band 1/2/4/5/8 & LTE Bands B1/B2/B3/B4/B5/B7/B8","N","0",cFonte)
	
	ELSEIF UPPER(cModelo) = "C5303"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia SP"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/5/8 LTE Bands 1/3/5/7/8/20","N","0",cFonte) 
	    
	ELSEIF UPPER(cModelo) = "C6503"
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia ZQ"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/5/8 LTE Bands 1/3/5/7/8/20","N","0",cFonte)    
	    
	ELSEIF UPPER(cModelo) = "D2104"         
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia E1 Dual"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/2/5","N","0",cFonte)
	ELSEIF UPPER(cModelo) = "C2004"         
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia TM M Dual"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/2/4/5","N","0",cFonte) 	    
	ELSEIF UPPER(cModelo) = "C2403"         
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia M2 Aqua"+Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/5/8 LTE Bands 1/3/5/7/8/20","N","0",cFonte)    
	    
	ELSEIF UPPER(cModelo) = "C1604"    
	
		MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) +Space(5)+cCor,"N","0",cFonte) 
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA Band 1/5/8","N","0",cFonte)      
	
	ELSE                  
	    IF UPPER(cModelo) = "D2306"
    	    MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia M2"+Space(5)+cCor,"N","0",cFonte) 
    	ELSE
            MSCBSAY(_aCol[1],_a2Lin[1],UPPER(cModelo) + " / Xperia T3"+Space(5)+cCor,"N","0",cFonte)     	
    	ENDIF    
	    MSCBSAY(_aCol[1],_a2Lin[2],"Mobile Phone GSM/GPRS/EDGE 850/900/1800/1900","N","0",cFonte)                       //VERIFICAR DESCRIÇÕES
	    MSCBSAY(_aCol[1],_a2Lin[3],"UMTS/HSPA band 1/2/4/5 & LTE band 4/7/17","N","0",cFonte)
	ENDIF 
    
    IF UPPER(cModelo) = "SGP551"
	    MSCBSAY(_aCol[1],_a2Lin[4],"SI:"+cSI+Space(5)+"PB","N","0",cFont3)	
	ELSE
        MSCBSAY(_aCol[1],_a2Lin[4],"SI:"+cSI+Space(5)+"PB","N","0",cFonte)		
	ENDIF     
	     
	//MSCBSAY(_aCol[2],_a2Lin[2],"SI " + cSI+Space(5)+"PB","N","0",cFonte)
	MSCBSAY(_aCol[8],_a1Lin[4],a2Fabric[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[8],_a1Lin[5],a2Fabric[2][1],"N","0",cFonte)
	MSCBSAY(_aCol[8],_a1Lin[6],a2Fabric[3][1],"N","0",cFonte)  
	MSCBSAY(_aCol[8],_a1Lin[7],a2Fabric[4][1],"N","0",cFonte) 
	MSCBSAY(_aCol[8],_a1Lin[8],a2Fabric[5][1],"N","0",cFonte)
	MSCBSAY(_aCol[8],_a1Lin[9],a2Fabric[6][1],"N","0",cFonte) 
	
	IF UPPER(cModelo) = "SGP551"
    
    	MSCBSAYBAR(_aCol[1] ,_a2Lin[5],cImei1,"N","MB07",nTmBar,.F.,.F.,.F.,,2,1) 
     	MSCBSAY(_aCol[1],_a2Lin[10],"IMEI:"+cImei1,"N","0",cFont3)
	
     	MSCBSAYBAR(_aCol[1] ,_a2Lin[11],cSN2,"N","MB04",nTmBar,.F.,.T.,.F.,,2,1)
    ELSE
    
    	MSCBSAYBAR(_aCol[1] ,_a2Lin[5],cImei1,"N","MB07",nTmBar,.F.,.F.,.F.,,2,1) 
     	MSCBSAY(_aCol[1],_a2Lin[10],"IMEI:"+cImei1,"N","0",cFonte)
	
     	MSCBSAYBAR(_aCol[1] ,_a2Lin[11],cSN2,"N","MB04",nTmBar,.F.,.T.,.F.,,2,1)
     	
     	MSCBSAYBAR(_aCol[9] ,_a2Lin[1],cSN4,"N","MB07",nTmBar,.F.,.F.,.F.,,2,1)
    ENDIF
	
	MSCBEND()	
	


EndIf 

////////////////////////////////////////
//IMPRIME TERCEIRA ETIQUETA - KIT
///////////////////////////////////////

If UPPER(cModelo) $ "D5106/D2306/D6543/SGP551/C5303/D2104/C2004/D2403/D5833/E2306/C6503" //VERIFICAR
    
    IF UPPER(cModelo) = "D6543"
	   aAdd(aKit,{"Kit inclui: Telefone digital, Bateria embutida, Carregador bivolt EP800,"}) 
	   aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Antena TV Digital, Pulseira, Doc. do usuário."}) 
	   
	ELSEIF  UPPER(cModelo) = "SGP551"
	
	   aAdd(aKit,{"Kit inclui: Tablet, Bateria embutida, Carregador EP880, Cabo de Mídia, Handsfree portátil estéreo,"})
	   aAdd(aKit,{"Doc. do usuário."}) 
	   
	   
	ELSEIF UPPER(cModelo) = "D2104"
	   aAdd(aKit,{"Kit inclui: Telefone digital GSM, Doc. do usuário, Bateria BA900, Carregador EP800,"}) 
	   aAdd(aKit,{"Cabo de Mídia, Radio FM"}) 
	   
	ELSEIF UPPER(cModelo) = "C2004"
		aAdd(aKit,{"Kit inclui: Telefone digital GSM, Bateria embutida, Carregador bivolt EP800,"}) 
	   	aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Doc. do usuário."})
	   
	ELSEIF UPPER(cModelo) = "D2403"
	   aAdd(aKit,{"Kit inclui: Telefone digital GSM, Bateria embutida, Carregador bivolt EP800,"}) 
	   aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Doc. do usuário."})   
	   
	ELSEIF UPPER(cModelo) = "D5833"
	   aAdd(aKit,{"Kit inclui: Telefone digital GSM, Bateria embutida, Carregador bivolt EP800,"}) 
	   aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Pulseira, Doc. do usuário."}) 
	   
	ELSEIF UPPER(cModelo) = "E2306"
	   aAdd(aKit,{"Kit inclui: Telefone digital GSM, Bateria embutida, Carregador bivolt EP800,"}) 
	   aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Doc. do usuário."}) 
	   
	ELSE
       aAdd(aKit,{"Kit inclui: Telefone digital, Bateria embutida, Carregador bivolt EP800,"}) 
	   aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Doc. do usuário."}) 	
	ENDIF   
	 
ElseIf UPPER(cModelo) $ "D5322" //VERIFICAR  

	aAdd(aKit,{"Kit inclui: Telefone digital GSM, Bateria embutida, Carregador bivolt (EP800),"}) 
	aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Doc. do usuário."})  
	

ElseIf UPPER(cModelo) $ "D2212/D2243/D6643/D6633/C6943/E2124/C1604/C6843/ST26A" //VERIFICAR   
    
    IF  UPPER(cModelo) = "D6643"
	     aAdd(aKit,{"Kit inclui: Telefone digital GSM,bateria embutida,Carregador (EP880),"}) 
	     aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo,Antena TV Digital, Pulseira, Doc. do usuário."}) 
	ELSEIF  UPPER(cModelo) = "D6633"
		aAdd(aKit,{"Kit inclui: Telefone digital GSM,bateria embutida,Carregador bivolt EP880,"}) 
		aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Pulseira, Doc. do usuário."}) 
	ELSEIF  UPPER(cModelo) = "C6943"
		aAdd(aKit,{"Kit inclui: Telefone digital GSM,bateria embutida,Carregador bivolt EP880,"}) 
	     aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Antena TV Digital, Doc. do usuário."}) 
	ELSEIF  UPPER(cModelo) = "C6843"
		aAdd(aKit,{"Kit inclui: Telefone digital GSM,bateria embutida,Carregador bivolt EP800,"}) 
	     aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Antena TV Digital, Doc. do usuário."})     
	ELSEIF  UPPER(cModelo) = "E2124"     
	 	aAdd(aKit,{"Kit inclui: Telefone digital GSM,bateria embutida,Carregador (EP800),"}) 
     	aAdd(aKit,{"Cabo de Mídia, Doc. do usuário."}) 
    ELSEIF  UPPER(cModelo) = "C1604"
		aAdd(aKit,{"Kit inclui: Telefone Digital GSM, bateria de íon de lítio BA700, Carregador bivolt EP310,"})
		aAdd(aKit,{"Handsfree portátil estéreo, Cabo de Mídia, Doc. do usuário."})	 	
		
	ELSEIF  UPPER(cModelo) = "ST26A"
		aAdd(aKit,{"Kit inclui: Telefone Digital GSM, bateria de íon de lítio BA900, Carregador bivolt EP310,"})
		aAdd(aKit,{"Handsfree portátil estéreo, Cabo de Mídia, Doc. do usuário."})	 	              
	ELSE
	     aAdd(aKit,{"Kit inclui: Telefone digital GSM,bateria embutida,Carregador (EP800),"}) 
     	 aAdd(aKit,{"Cabo de Mídia, Handsfree portátil estéreo, Doc. do usuário."}) 
	ENDIF

EndIf                                                                                  

aAdd(aDistrib,{"DISTRIBUIDO POR"}) 
If UPPER(cModelo) = "C1604"
	aAdd(aDistrib,{"Sony Ericsson Mobile Comm. do Brasil LTDA"}) 
Else
	aAdd(aDistrib,{"Sony Mobile Comm. do Brasil LTDA"}) 
EndIf
aAdd(aDistrib,{"Rua Ramos Batista 198"}) 
aAdd(aDistrib,{"São Paulo - SP"}) 
aAdd(aDistrib,{"CNPJ: 04.667.337/0001-08"}) 
aAdd(aDistrib,{"Este produto atende aos limites de taxa de"})
aAdd(aDistrib,{"absorção especifica (SAR) estabelecidos"})  
aAdd(aDistrib,{"através da Res. 242/2000 e regulamentadas"})  
aAdd(aDistrib,{"pela Res. 303/2002 e 533/2009 da ANATEL"})

If Len(aKit) > 0  

	MSCBBEGIN(1,6)
	
	MSCBLineH(_aColH[1],_aLinH[1],_aColH[2],3,"B") 
	MSCBLineV(40,08,23,3,"B")
	
	MSCBSAY(_aCol[1],_aLin[1],aKit[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_aLin[2],aKit[2][1],"N","0",cFonte) 
	
	MSCBSAY(_aCol[1],_aLin[3],aDistrib[1][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_aLin[4],aDistrib[2][1],"N","0",cFonte) 
	MSCBSAY(_aCol[1],_aLin[5],aDistrib[3][1],"N","0",cFonte)  
	MSCBSAY(_aCol[1],_aLin[6],aDistrib[4][1],"N","0",cFonte)
	MSCBSAY(_aCol[1],_aLin[7],aDistrib[5][1],"N","0",cFonte)
	  
	MSCBSAY(_aCol[2],_aLin[4],aDistrib[6][1],"N","0",cFonte)
	MSCBSAY(_aCol[2],_aLin[5],aDistrib[7][1],"N","0",cFonte)  
	MSCBSAY(_aCol[2],_aLin[6],aDistrib[8][1],"N","0",cFonte)
	MSCBSAY(_aCol[2],_aLin[7],aDistrib[9][1],"N","0",cFonte)  
	
	MSCBEND()
	
	MSCBCLOSEPRINTER()
Else

	apMsgInfo('Modelo desconhecido. Contate seu líder.','Modelo desconhecido')		
	
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Vinicius Leonardo  º Data ³  19/02/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 		  													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function CriaSX1()
	
	// 	cGrupo	,cOrdem,cPergunt,cPerSpa,cPerEng		,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Impressora"	,"Impressora"		,"Impressora"		,"mv_ch1","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par01",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"02","Modelo"	,"Modelo"	,"Modelo"	,"mv_ch2","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par02",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"03","Imei 1"	,"Imei 1"	,"Imei 1"	,"mv_ch3","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par03",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"04","Imei 2"	,"Imei 2"	,"Imei 2"	,"mv_ch4","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par04",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"05","SN 1"	,"SN 1"		,"SN 1"		,"mv_ch5","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par05",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"06","SN 2"	,"SN 2"		,"SN 2"		,"mv_ch6","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par06",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"07","Cor"		,"Cor"		,"Cor"		,"mv_ch7","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par07",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"08","SI."	,    "SI."		,"SI."		,"mv_ch8","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par08",""	,"","","",""		,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"09","SN 3"	,"SN 3"		,"SN 3"		,"mv_ch9","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par09",""	,"","","",""		,"","",""	,"","","","","","","","") 
	PutSX1(cPerg,"10","SN 4"	,"SN 4"		,"SN 4"		,"mv_cha","C"	,15		 ,0		  ,0,"C","",""	,"",,"mv_par10",""	,"","","",""		,"","",""	,"","","","","","","","")

Return Nil
