#include 'rwmake.ch'
#include 'topconn.ch'
#include "tbiconn.ch"                                
#DEFINE OPEN_FILE_ERROR -1  
#define ENTER CHR(10)+CHR(13)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Fata0003 ºAutor  ³ Edson Rodrigues    º Data ³  03/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para atualizar lista de preco peças Nextel        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function Fata0003(_nopc,_codestr,_cgroper,_cPro,nqtd,coperac)


//PREPARE ENVIRONMENT EMPRESA  "02" FILIAL "02" TABLES "SG1","ZZP","ZA8","SB1"
  
_codestr  := iif(_codestr=nil,Space(15),_codestr)
_cCodPro  := iif(_cPro=nil,Space(15),_cPro)
_ccompnew := ""
_ddatanew := CTOD(" / / ")   
_nqtdapar := iif(nqtd=nil,0,nqtd)
_avlrclai := {}                      
_nvalpc40 := 0.00
_avaltpeca:= {}                                 
_ccodestr := Space(15) 
_nopc     := iif(_nopc = nil,1,_nopc)
_cgroper  := iif(_cgroper = nil,"",_cgroper)


SG1->(DBSetOrder(1)) //G1_FILIAL+G1_COD
ZZP->(DBSetOrder(2)) //ZZP_FILIAL+ZZP_MODELO
ZAB->(DBSetOrder(1)) //ZAB_FILIAL+ZAB_TPVAL+ZAB_ESTRUT+ZAB_TIPOLI+ZAB_PARTNR


                    
If select("QRY") > 0
   	QRY->(dbCloseArea())
Endif

        
DbSelectArea("SG1")
 // Ordena a tabela no indice mais proximo que sera executada a query - Edson Rodrigues 14/04/10     
cQuery := " SELECT G1_COD, G1_COMP, G1_QUANT,G1_INI,G1_FIM, SB1.B1_UM, SB1.B1_LOCPAD, SB1.B1_DESC, SB1.B1_PRV1,G1_XARMPGT,SG1.R_E_C_N_O_ AS RECSG1 "
cQuery += " FROM "+ RETSQLNAME("SG1")+" SG1 (nolock) "
cQuery += " INNER JOIN (SELECT B1_COD,B1_DESC,B1_UM,B1_LOCPAD,B1_PRV1 "
cQuery += "             FROM "+RETSQLNAME("SB1") + " B1 (nolock) " 
cQuery += "             WHERE B1_FILIAL='"+xFilial("SB1")+"' AND D_E_L_E_T_=''  ) AS SB1 "
cQuery += " ON G1_COMP=SB1.B1_COD  "
cQuery += " INNER JOIN (SELECT B1_XCODEST  "
cQuery += "             FROM "+RETSQLNAME("SB1") + " B12 (nolock) "
cQuery += "             WHERE B1_FILIAL='"+xFilial("SB1")+"' AND D_E_L_E_T_='' " 
IF !empty(_codestr)           
    cQuery += "                AND B1_XCODEST='"+_codestr+"' "
ELSE
    cQuery += "                AND B1_XCODEST<>'' " 
ENDIF
cQuery += "              GROUP BY B1_XCODEST) AS SB12 "
cQuery += " ON G1_COD=SB12.B1_XCODEST    "
cQuery += " WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' AND "
IF !empty(_codestr)
cQuery += "      SG1.G1_COD = '" +_codestr+"'  AND "
ENDIF
IF !empty(_cCodPro)
cQuery += "      SG1.G1_COMP <> '"+_cCodPro+"' AND "   
ENDIF
cQuery += "      SG1.D_E_L_E_T_ <> '*'    AND "
cQuery += "      SG1.G1_INI<='"+dtos(ddatabase)+"' AND SG1.G1_FIM>='"+dtos(ddatabase)+"' "
cQuery += "     ORDER BY SG1.G1_COD,G1_QUANT DESC"
		                                                           
		
TCQUERY cQUERY NEW ALIAS "QRY"
		    
DbSelectArea("QRY")    
QRY->(dbGoTop())              


IF _nopc==2         
   ZAB->(DBSetOrder(2)) //ZAB_FILIAL+ZAB_TPVAL+ZAB_ANOMES+ZAB_GROPER+ZAB_ESTRUT+ZAB_TIPOLI+ZAB_PARTNR
   U_FATA003B(_nopc,_cgroper,coperac)             
   RETURN
ENDIF
		 
While QRY->(!eof())    
		     
    IF ALLTRIM(QRY->G1_COD)+ALLTRIM(QRY->G1_COMP) <> _ccompnew 
        _ccompnew  := ALLTRIM(QRY->G1_COD)+ALLTRIM(QRY->G1_COMP)
		_ccodestr  := QRY->G1_COD
		_ccompon   := QRY->G1_COMP         
		_cproddesc := QRY->B1_DESC
		_npercent  := QRY->G1_QUANT     
		_nprecoun  := QRY->B1_PRV1     
		_avlrclai  := u_FATA003A(_ccodestr,coperac)
		
		
			    
		IF len(_avlrclai) > 0  
		   IF _avlrclai[1,1] > 0 .and. _avlrclai[1,2] > 0
		        
		        //For x:=1 to _nqtdapar  
		        For fx:=1 to 20 //Fixado valor para definir para as quantidades de 5 e 20 aparelhos
			       IF fx=5 .or. fx=20
			          _nqtdetot   :=_npercent*fx
			          _nqtde      :=IIF(_nqtdetot< 1,0,noround(_nqtdetot,0))  
			      	  _nvalpc40   :=fx*(_avlrclai[1,1]-_avlrclai[1,2])  
		           	  _ntotprcoun :=(_nqtde*_nprecoun)
		              AADD(_avaltpeca,{fx,_ccodestr,_ccompon,_ntotprcoun})
		              _nvaltpeca:=0
		              		              
		              for z:=1 to len(_avaltpeca)
		                 
		                 If fx==_avaltpeca[z,1]
		                    _nvaltpeca  :=_nvaltpeca+_avaltpeca[z,4]    	     			    
		                 Endif
		              next 
		     
		           	  
			          cCMPTab     :='ZAB->ZAB_VLR'+ALLTRIM(STR(fx))
     				 
     				  IF _nvaltpeca > _nvalpc40
     				     _ntotprcoun := 0.00                       
     				     _avaltpeca[len(_avaltpeca),4]:=0.00
     				  
     				  ELSEIF  fx=5 .AND. _npercent < 0.20  
     				     _ntotprcoun := 0.00         
     				     _avaltpeca[len(_avaltpeca),4]:=0.00
     				  ELSEIF  fx=20 .AND. _npercent < 0.05   
     				     _ntotprcoun := 0.00 
     				     _avaltpeca[len(_avaltpeca),4]:=0.00
     				  Endif
     				 
     				 
		     	      
		     	      IF ZAB->(DBSeek(xFilial('ZAB')+'PF'+_ccodestr+'PC'+_ccompon))			      
		     	         RecLock('ZAB',.F.)
                 			ZAB->ZAB_PERCEN := _npercent
                        	ZAB->ZAB_PRECOU := _nprecoun 
                           	&cCMPTab   := _ntotprcoun
			              MsUnLock('ZAB')
		     	      ELSE
			              RecLock('ZAB',.T.)
                 			ZAB->ZAB_FILIAL := xfilial("ZAB")
	                        ZAB->ZAB_ESTRUT := _ccodestr
	                        ZAB->ZAB_TPVAL  := "PF"
	                        ZAB->ZAB_TIPOLI := "PC"
	                        ZAB->ZAB_PARTNR := _ccompon
                         	ZAB->ZAB_DESCRI := _cproddesc
                         	ZAB->ZAB_PERCEN := _npercent
                        	ZAB->ZAB_PRECOU := _nprecoun
                           	&cCMPTab   := _ntotprcoun
			              MsUnLock('ZAB')
			          ENDIF           
			                    
			       ENDIF
			    Next  
		   ENDIF
                       
        ENDIF     
    ENDIF
    QRY->(dbSkip())
	IF (ALLTRIM(QRY->G1_COD)+ALLTRIM(QRY->G1_COMP) <> _ccompnew) .and. ; 
        ALLTRIM(QRY->G1_COD)<>ALLTRIM(_ccodestr)
		   IF  len(_avlrclai) > 0  .and. len(_avaltpeca) > 0

		 
		      //For fx:=1 to _nqtdapar  
		      For fx:=1 to 20 //Fixado valor para definir para as quantidades de 5 e 20 aparelhos
			       IF fx=5 .or. fx=20
			          
			          cCMPTab     :='ZAB->ZAB_VLR'+ALLTRIM(STR(fx))
			 
			 
			          _nvaltpeca:=0
		              		              
		              for z:=1 to len(_avaltpeca)
		                 
		                 If fx==_avaltpeca[z,1]
		                    _nvaltpeca  :=_nvaltpeca+_avaltpeca[z,4]    	     			    
		                 Endif
		              next 
		     
			          
			          
			          
			          For y:=1 to 2
			         
     				     IF y=1 .and. ZAB->(DBSeek(xFilial('ZAB')+'PF'+_ccodestr+'VL'+'VALOR'))	
		     	            RecLock('ZAB',.F.)
                 	     	 &cCMPTab    := _nvaltpeca
                 	        MsUnLock('ZAB')
		     	         
		     	         ELSEIF y=2 .and.  ZAB->(DBSeek(xFilial('ZAB')+'PF'+_ccodestr+'PT'+'PERCENTUAL'))		      
		     	         
		                    RecLock('ZAB',.F.)
                 	     	 &cCMPTab    :=(_nvaltpeca/(fx*(_avlrclai[1,1]-_avlrclai[1,2])))*100
			                MsUnLock('ZAB')
		     	         
		     	         
		     	         ELSE
			                IF Y=1
			                    RecLock('ZAB',.T.)
                 			      ZAB->ZAB_FILIAL := XFILIAL("ZAB")
	                              ZAB->ZAB_ESTRUT  := _ccodestr
	                              ZAB->ZAB_TPVAL  := "PF"
	                              ZAB->ZAB_TIPOLI := "VL"
	                              ZAB->ZAB_PARTNR  := "VALOR"
                         	      ZAB->ZAB_DESCRI := "VALOR TOTAL ESTRUTURA"
                         	      &cCMPTab    := _nvaltpeca
			                   MsUnLock('ZAB')
			                ELSE
			                   RecLock('ZAB',.T.)
                 			      ZAB->ZAB_FILIAL := XFILIAL("ZAB")
	                              ZAB->ZAB_ESTRUT  := _ccodestr
	                              ZAB->ZAB_TPVAL  := "PF"
	                              ZAB->ZAB_TIPOLI := "PT"
	                              ZAB->ZAB_PARTNR  := "PERCENTUAL"
                         	      ZAB->ZAB_DESCRI := "PERCENTUAL TOTAL ESTRUTURA X 40% PECAS"
                         	      &cCMPTab   := (_nvaltpeca/(fx*(_avlrclai[1,1]-_avlrclai[1,2])))*100
			                   MsUnLock('ZAB')
			                
			                ENDIF   
			             ENDIF           
			          Next          
			       ENDIF
		      Next
		     _avaltpeca :={}
		   ENDIF
		 
		   
	ENDIF                   

Enddo 

QRY->(dbCloseArea())


Return	   	





/*
*Programa: FATA003A 
*Autor	 : Edson Rodrigues  
*Data 	 : 03/03/13   
*Desc.   : Buscar os modelos e os valores cadastrados na tabela ZZP                      
*/
User function Fata003A(_cestr,coperac,ccodpro)

_avalclaim:={}	   	
_aAreaZZP := ZZP->(GetArea())

ZZP->(DBSetOrder(1)) //ZZP_FILIAL+ZZP+_OPERA+ZZP_MODELO+ZZP_TRAFAG+ZZP_TRAFOG+ZZP_SETOR+ZZP_FASE

	   	
If select("QR2") > 0
   	QRY2->(dbCloseArea())
Endif
                                         

cQuery := " SELECT B1_XCODEST,B1_COD FROM "+ RETSQLNAME("SB1")+" " 
cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XCODEST='"+_cestr+"' "
cQuery += " ORDER BY B1_XCODEST,B1_COD  "

TCQUERY cQUERY NEW ALIAS "QRY2"
		    
DbSelectArea("QRY2")    
QRY2->(dbGoTop())    
		 
While QRY2->(!eof())    

  IF ZZP->(DBSeek(xFilial('ZZP')+coperac+QRY2->B1_COD))			     
     IF len(_avalclaim) <=0  .and. ZZP->ZZP_OPERA ==coperac .and. ZZP->ZZP_MODELO ==ccodpro
       AADD(_avalclaim,{ZZP->ZZP_VLRGAF,ZZP->ZZP_SRVGAF,ZZP->ZZP_OPERA,ZZP->ZZP_MODELO})
     ENDIF  
  ENDIF

 QRY2->(dbSkip())

Enddo
                                                                                           

if len(_avalclaim) <=0

  QRY2->(dbGoTop())    
		 
  While QRY2->(!eof())    

    IF ZZP->(DBSeek(xFilial('ZZP')+coperac+QRY2->B1_COD))			     
       IF len(_avalclaim) <=0  .and. ZZP->ZZP_OPERA ==coperac 
         AADD(_avalclaim,{ZZP->ZZP_VLRGAF,ZZP->ZZP_SRVGAF,ZZP->ZZP_OPERA,ZZP->ZZP_MODELO})
       ENDIF  
    ENDIF

    QRY2->(dbSkip())

  Enddo

eNDIF

QRY2->(dbCloseArea())
restarea(_aAreaZZP)
return(_avalclaim)	   	                        





/*
*Programa: FATA003B 
*Autor	 : Edson Rodrigues  
*Data 	 : 10/04/13   
*Desc.   : Cadastra as pecas na ZAB para controle de venda do mes                     
*/
User function Fata003B(_nopc,_cgroper,coperac)
_ccodestr := Space(15) 
_ccompnew := ""
_avlrclai := {}                      
_nvalpc40 := 0.00
_avaltpeca:= {}          
_canomes  := SUBSTR((DTOS(ddatabase)),1,4)+SUBSTR(DTOC(ddatabase),4,2)
                       


While QRY->(!eof())  .and.  _nopc==2 
    IF ALLTRIM(QRY->G1_COD)+ALLTRIM(QRY->G1_COMP) <> _ccompnew 
    	_ccompnew  := ALLTRIM(QRY->G1_COD)+ALLTRIM(QRY->G1_COMP)    
    	_ccodestr  := QRY->G1_COD
		_ccompon   := QRY->G1_COMP         
		_cproddesc := QRY->B1_DESC
		_npercent  := QRY->G1_QUANT     
		_nprecoun  := QRY->B1_PRV1     
        
        
		IF !ZAB->(DBSeek(xFilial('ZAB')+'PV'+_canomes+cgrpoper+_ccodestr+'PC'+_ccompon))			      
         RecLock('ZAB',.T.)
           ZAB->ZAB_FILIAL := xfilial("ZAB")
	       ZAB->ZAB_ESTRUT := _ccodestr
	       ZAB->ZAB_TPVAL  := "PV"
	       ZAB->ZAB_TIPOLI := "PC"
	       ZAB->ZAB_ANOMES := _canomes
	       ZAB->ZAB_GROPER := _cgroper
	       ZAB->ZAB_PARTNR := _ccompon
           ZAB->ZAB_DESCRI := _cproddesc
           ZAB->ZAB_PERCEN := _npercent
           ZAB->ZAB_PRECOU := _nprecoun
           ZAB->ZAB_VLR5   := 0.00
           ZAB->ZAB_VLR20  := 0.00
           ZAB->ZAB_QAPMES := 0.00
           ZAB->ZAB_QPEOPE := 0.00
           ZAB->ZAB_QPEMES := 0.00
           ZAB->ZAB_PECONT := IIF(_npercent > 1.00,"N","S")
           ZAB->ZAB_QPROXV := 0.00           
         MsUnLock('ZAB')
	   
	   ENDIF
	   

	   IF !ZAB->(DBSeek(xFilial('ZAB')+'PV'+_canomes+"TODAS "+_ccodestr+'QT'))                                     
          RecLock('ZAB',.T.)
	       ZAB->ZAB_FILIAL := xfilial("ZAB")
	       ZAB->ZAB_ESTRUT := _ccodestr
	       ZAB->ZAB_TPVAL  := "PV"
	       ZAB->ZAB_TIPOLI := "QT"
	       ZAB->ZAB_ANOMES := _canomes
	       ZAB->ZAB_GROPER := "TODAS"
	       ZAB->ZAB_PARTNR := 'QTDAPARVENTOTAL'
           ZAB->ZAB_DESCRI := 'QUANTIDADE DE APARELHOS VENDIDOS TOTAL'
           ZAB->ZAB_PERCEN := _npercent
           ZAB->ZAB_PRECOU := _nprecoun
           ZAB->ZAB_VLR5   := 0.00
           ZAB->ZAB_VLR20  := 0.00
           ZAB->ZAB_QAPMES := 0.00
           ZAB->ZAB_QPEOPE := 0.00
           ZAB->ZAB_QPEMES := 0.00
           ZAB->ZAB_PECONT := "-" 
           ZAB->ZAB_QPROXV := 0.00           
	      MsUnLock('ZAB')
	   ENDIF
	   IF !ZAB->(DBSeek(xFilial('ZAB')+'PV'+_canomes+cgrpoper+_ccodestr+'QO'))                                     
          RecLock('ZAB',.T.)
	       ZAB->ZAB_FILIAL := xfilial("ZAB")
	       ZAB->ZAB_ESTRUT := _ccodestr
	       ZAB->ZAB_TPVAL  := "PV"
	       ZAB->ZAB_TIPOLI := "QO"
	       ZAB->ZAB_ANOMES := _canomes
	       ZAB->ZAB_GROPER := _cgroper
	       ZAB->ZAB_PARTNR := 'QTDAPARVENDOPER'
           ZAB->ZAB_DESCRI := 'QUANTIDADE DE APARELHOS VENDIDOS POR OPERACAO'
           ZAB->ZAB_PERCEN := _npercent
           ZAB->ZAB_PRECOU := _nprecoun
           ZAB->ZAB_VLR5   := 0.00
           ZAB->ZAB_VLR20  := 0.00
           ZAB->ZAB_QAPMES := 0.00
           ZAB->ZAB_QPEOPE := 0.00
           ZAB->ZAB_QPEMES := 0.00
           ZAB->ZAB_PECONT := "-" 
           ZAB->ZAB_QPROXV := 0.00           
	      MsUnLock('ZAB')
	   ENDIF
   
	ENDIF

	QRY->(dbSkip())
	
Enddo 
                           
QRY->(dbCloseArea())

Return
