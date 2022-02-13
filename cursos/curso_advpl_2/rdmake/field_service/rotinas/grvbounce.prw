#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"
#include "tbiconn.ch"
#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRVBOUNCE º Autor ³ Edson Rodrigues    º Data ³  04/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige e grava e bounce calculado nos arquivos de entrada º±±
±±º          ³ Massiva - ZZ4                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function grvbounce()

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "ZZ4","SD2"

Private aAlias      := {"ZZ4","SD2"}               
Private cFILIAL     := SPACE(2)

u_GerA0003(ProcName())

cFILIAL   := '02'                                                                
nreczz4   :=  '1431550'
cquery    :=""
nrecqry   :=0                      


dbSelectArea("SD2")
//SD2->(dbSetOrder(10)) // D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO) - Edson Rodrigues - 02/10/10
SD2->(DBOrderNickName('D2NUMSEMIS')) //D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO)

dbSelectArea("ZZ4")
ZZ4->(dbSetorder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS

//Filtra produtos inventariados que estão com saldo diferente do estoque
IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif                        


            
/*
cquery:=" SELECT ZZ4_IMEI,R_E_C_N_O_ AS RECNOZZ4 "+ENTER
cquery+=" FROM "+RETSQLNAME("ZZ4")+" ZZ4 "+ENTER
cquery+=" WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND D_E_L_E_T_='' AND R_E_C_N_O_ >= "+nreczz4+" AND ZZ4_BOUNCE=0 "+ENTER
cquery+=" ORDER BY R_E_C_N_O_ "+ENTER   
*/
/*
cquery:=" SELECT ZZ4.ZZ4_IMEI,ZZ4.R_E_C_N_O_ AS RECNOZZ4 FROM ZZ4020  ZZ4 (NOLOCK)  "+ENTER
cquery+=" WHERE ZZ4_NUMVEZ >= 0 AND D_E_L_E_T_='' AND ZZ4_FILIAL='02' "+ENTER
cquery+=" ORDER BY ZZ4.R_E_C_N_O_ "+ENTER
*/

/*                                   
cquery:=" SELECT ZZ4.ZZ4_IMEI,ZZ4.R_E_C_N_O_ AS RECNOZZ4 FROM ZZ4020  ZZ4 (NOLOCK) LEFT OUTER JOIN "
cquery+=" (SELECT ZZ4_NFSDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA FROM ZZ4020 (NOLOCK) WHERE ZZ4_FILIAL='02' AND D_E_L_E_T_='' AND ZZ4_STATUS='9') AS ZZ42 "
cquery+=" ON ZZ4.ZZ4_IMEI=ZZ42.ZZ4_IMEI AND ZZ4.ZZ4_NFEDT > ZZ42.ZZ4_NFSDT "
cquery+=" WHERE ZZ4_NUMVEZ=1 AND D_E_L_E_T_='' AND ZZ4_FILIAL='02' AND ZZ4_NFEDT>='20060101' AND ZZ4_BOUNCE > 0 "
cquery+=" AND ZZ42.ZZ4_NFSDT IS NOT NULL "
cquery+=" ORDER BY ZZ4.R_E_C_N_O_ "
*/


cquery:=" SELECT ZZ4.ZZ4_IMEI, "
cquery+="       ZZ4.R_E_C_N_O_ AS RECNOZZ4,  "
cquery+="       ZZ4.ZZ4_NFSDT AS ENTRADA1, "
cquery+="       ZZ4.ZZ4_NFSDT AS SAIDA1, "
cquery+="       ZZ4.ZZ4_BOUNCE AS BOUNCE1, "
cquery+="       ZZ4.ZZ4_NUMVEZ AS NUMVEZ1, "
cquery+="       ZZ42.R_E_C_N_O_ AS RECNO2, "
cquery+="       ZZ42.ZZ4_NFEDT AS ENTRADA2, "
cquery+="       ZZ42.ZZ4_NFSDT AS SAIDA2,"
cquery+="       ZZ42.ZZ4_BOUNCE AS BOUNCE2,"
cquery+="       ZZ42.ZZ4_NUMVEZ AS NUMVEZ2,"
cquery+="       ZZ43.R_E_C_N_O_ AS RECNO3, "
cquery+="       ZZ43.ZZ4_NFEDT AS ENTRADA3,"
cquery+="       ZZ43.ZZ4_NFSDT AS SAIDA3,"
cquery+="       ZZ43.ZZ4_BOUNCE AS BOUNCE3,"
cquery+="       ZZ43.ZZ4_NUMVEZ AS NUMVEZ3,"
cquery+="       ZZ44.R_E_C_N_O_ AS RECNO4, "
cquery+="       ZZ44.ZZ4_NFEDT AS ENTRADA4,"
cquery+="       ZZ44.ZZ4_NFSDT AS SAIDA4,"
cquery+="       ZZ44.ZZ4_BOUNCE AS BOUNCE4,"
cquery+="       ZZ44.ZZ4_NUMVEZ AS NUMVEZ4,"
cquery+="       ZZ45.R_E_C_N_O_ AS RECNO5, "
cquery+="       ZZ45.ZZ4_NFEDT AS ENTRADA5,"
cquery+="       ZZ45.ZZ4_NFSDT AS SAIDA5,"
cquery+="       ZZ45.ZZ4_BOUNCE AS BOUNCE5,"
cquery+="       ZZ45.ZZ4_NUMVEZ AS NUMVEZ5,"
cquery+="       ZZ46.R_E_C_N_O_ AS RECNO6, "
cquery+="       ZZ46.ZZ4_NFEDT AS ENTRADA6,"
cquery+="       ZZ46.ZZ4_NFSDT AS SAIDA6,"
cquery+="       ZZ46.ZZ4_BOUNCE AS BOUNCE6,"
cquery+="       ZZ46.ZZ4_NUMVEZ AS NUMVEZ6,"
cquery+="       ZZ47.R_E_C_N_O_ AS RECNO7, "
cquery+="       ZZ47.ZZ4_NFEDT AS ENTRADA7,"
cquery+="       ZZ47.ZZ4_NFSDT AS SAIDA7,"
cquery+="       ZZ47.ZZ4_BOUNCE AS BOUNCE7,"
cquery+="       ZZ47.ZZ4_NUMVEZ AS NUMVEZ7,"
cquery+="       ZZ48.R_E_C_N_O_ AS RECNO8, "
cquery+="       ZZ48.ZZ4_NFEDT AS ENTRADA8,"
cquery+="       ZZ48.ZZ4_NFSDT AS SAIDA8,"
cquery+="       ZZ48.ZZ4_BOUNCE AS BOUNCE8,"
cquery+="       ZZ48.ZZ4_NUMVEZ AS NUMVEZ8"
cquery+=" FROM ZZ4020  ZZ4 (NOLOCK) "
cquery+=" LEFT OUTER JOIN"
cquery+=" (SELECT ZZ4_NFSDT,ZZ4_NFEDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NUMVEZ,ZZ4_BOUNCE,R_E_C_N_O_ FROM ZZ4020 (NOLOCK) WHERE ZZ4_FILIAL='02' AND D_E_L_E_T_='' AND ZZ4_NUMVEZ=2) AS ZZ42 "
cquery+=" ON ZZ4.ZZ4_IMEI=ZZ42.ZZ4_IMEI AND  ZZ4.ZZ4_NFSDT < ZZ42.ZZ4_NFEDT"
cquery+=" LEFT OUTER JOIN"
cquery+=" (SELECT ZZ4_NFSDT,ZZ4_NFEDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NUMVEZ,ZZ4_BOUNCE,R_E_C_N_O_ FROM ZZ4020 (NOLOCK) WHERE ZZ4_FILIAL='02' AND D_E_L_E_T_='' AND ZZ4_NUMVEZ=3) AS ZZ43"
cquery+=" ON ZZ4.ZZ4_IMEI=ZZ43.ZZ4_IMEI AND  ZZ4.ZZ4_NFSDT < ZZ43.ZZ4_NFEDT"
cquery+=" LEFT OUTER JOIN"
cquery+=" (SELECT ZZ4_NFSDT,ZZ4_NFEDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NUMVEZ,ZZ4_BOUNCE,R_E_C_N_O_ FROM ZZ4020 (NOLOCK) WHERE ZZ4_FILIAL='02' AND D_E_L_E_T_='' AND ZZ4_NUMVEZ=4) AS ZZ44"
cquery+=" ON ZZ4.ZZ4_IMEI=ZZ44.ZZ4_IMEI AND  ZZ4.ZZ4_NFSDT < ZZ44.ZZ4_NFEDT"
cquery+=" LEFT OUTER JOIN"
cquery+=" (SELECT ZZ4_NFSDT,ZZ4_NFEDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NUMVEZ,ZZ4_BOUNCE,R_E_C_N_O_ FROM ZZ4020 (NOLOCK) WHERE ZZ4_FILIAL='02' AND D_E_L_E_T_='' AND ZZ4_NUMVEZ=5) AS ZZ45"
cquery+=" ON ZZ4.ZZ4_IMEI=ZZ45.ZZ4_IMEI AND  ZZ4.ZZ4_NFSDT < ZZ45.ZZ4_NFEDT"
cquery+=" LEFT OUTER JOIN"
cquery+=" (SELECT ZZ4_NFSDT,ZZ4_NFEDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NUMVEZ,ZZ4_BOUNCE,R_E_C_N_O_ FROM ZZ4020 (NOLOCK) WHERE ZZ4_FILIAL='02' AND D_E_L_E_T_='' AND ZZ4_NUMVEZ=6) AS ZZ46"
cquery+=" ON ZZ4.ZZ4_IMEI=ZZ46.ZZ4_IMEI AND  ZZ4.ZZ4_NFSDT < ZZ46.ZZ4_NFEDT"
cquery+=" LEFT OUTER JOIN"
cquery+=" (SELECT ZZ4_NFSDT,ZZ4_NFEDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NUMVEZ,ZZ4_BOUNCE,R_E_C_N_O_ FROM ZZ4020 (NOLOCK) WHERE ZZ4_FILIAL='02' AND D_E_L_E_T_='' AND ZZ4_NUMVEZ=7) AS ZZ47"
cquery+=" ON ZZ4.ZZ4_IMEI=ZZ47.ZZ4_IMEI AND  ZZ4.ZZ4_NFSDT < ZZ47.ZZ4_NFEDT"
cquery+=" LEFT OUTER JOIN"
cquery+=" (SELECT ZZ4_NFSDT,ZZ4_NFEDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NUMVEZ,ZZ4_BOUNCE,R_E_C_N_O_ FROM ZZ4020 (NOLOCK) WHERE ZZ4_FILIAL='02' AND D_E_L_E_T_='' AND ZZ4_NUMVEZ=8) AS ZZ48"
cquery+=" ON ZZ4.ZZ4_IMEI=ZZ48.ZZ4_IMEI AND  ZZ4.ZZ4_NFSDT < ZZ48.ZZ4_NFEDT"
cquery+=" WHERE ZZ4.ZZ4_NUMVEZ<=1 AND D_E_L_E_T_='' AND ZZ4_FILIAL='02' AND ZZ4.ZZ4_NFSDT>='20060101' AND ZZ4.ZZ4_BOUNCE = 0"
cquery+=" AND ZZ42.ZZ4_NFEDT IS NULL AND  (ZZ43.ZZ4_NFEDT IS NOT NULL OR ZZ44.ZZ4_NFEDT IS NOT NULL OR ZZ45.ZZ4_NFEDT IS NOT NULL OR ZZ46.ZZ4_NFEDT IS NOT NULL OR ZZ47.ZZ4_NFEDT IS NOT NULL OR ZZ48.ZZ4_NFEDT IS NOT NULL )"
cquery+=" ORDER BY ZZ4.R_E_C_N_O_"


TCQUERY cQuery NEW ALIAS "QRY0"  


dbSelectArea("QRY0")
dbGoTop()

While !QRY0->(EOF())
    
    IF  QRY0->RECNO2 > 0 
         nrecqry   := QRY0->RECNO2
    
    ELSEIF QRY0->RECNO3 > 0 
         nrecqry   := QRY0->RECNO3
    
    ELSEIF QRY0->RECNO4 > 0 
         nrecqry   := QRY0->RECNO4
    
    ELSEIF QRY0->RECNO5 > 0 
         nrecqry   := QRY0->RECNO5
    
    ELSEIF QRY0->RECNO6 > 0 
         nrecqry   := QRY0->RECNO6
    
    ELSEIF QRY0->RECNO7 > 0 
         nrecqry   := QRY0->RECNO7
    
    ELSEIF QRY0->RECNO8 > 0 
         nrecqry   := QRY0->RECNO8
    
    ENDIF     
     
    ZZ4->(DbGoTo(nrecqry))                              
    ccImei    := QRY0->ZZ4_IMEI
    _dSaida   := ctod("  /  /  ")
    _dentrada := ZZ4->ZZ4_NFEDT
    _nvzes    := 0 
    _nVez     := 0
    _cCodPro  := ZZ4->ZZ4_CODPRO    
    _ccodcli  := ZZ4->ZZ4_CODCLI
    _clojcli  := ZZ4->ZZ4_LOJA
    _lAchou   :=.f.
    
    
    If ZZ4->(dbSeek(xFilial("ZZ4") + ccImei))
	   while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCImei) 
	     IF ZZ4->ZZ4_NFEDT < _dentrada
	      	_nvzes++
	     ENDIF 	
	     ZZ4->(dbSkip())
	   enddo
	   ZZ4->(dbSkip(-1))
	   _lAchou   := alltrim(ZZ4->ZZ4_IMEI) == alltrim(ccImei) .and. _nvzes >= 1       
	   _dultimei := ZZ4->ZZ4_NFEDT
    Endif
         
    If _lAchou
	   SD2->(dbgotop())
	   If SD2->(dbSeek(xFilial("SD2") + ccImei))
		  while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_NUMSERI == QRY0->ZZ4_IMEI 
     	         IF SD2->D2_EMISSAO < _dentrada
     			     _dSaida := SD2->D2_EMISSAO
     			  ENDIF   
			SD2->(dbSkip())
	      Enddo
	   Endif                                               
	   
	   
       If !empty(_dSaida)
	      ZZ4->(dbSeek(xFilial("ZZ4") + ccImei))
	      While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(ccImei) 
			   //IF	ZZ4->ZZ4_CODCLI=_ccodcli .and. ZZ4->ZZ4_LOJA=_clojcli .and. alltrim(ZZ4->ZZ4_CODPRO) == alltrim(_cCodPro) .and. ZZ4->ZZ4_NFEDT < _dentrada
			   IF ZZ4->ZZ4_NFEDT < _dentrada
			       _nVez++
			   ENDIF     
			   ZZ4->(dbSkip())
		  Enddo
	   
	      ZZ4->(DbGoTo(nrecqry))
			reclock("ZZ4",.f.)
    		  ZZ4->ZZ4_BOUNCE := _dentrada-_dSaida
	    	  ZZ4->ZZ4_ULTSAI := _dSaida
	    	  ZZ4->ZZ4_NUMVEZ := _nVez+1 
   			msunlock()	
	   Endif
	Else
	
        ZZ4->(DbGoTo(nrecqry))
		  
		IF ZZ4->ZZ4_NUMVEZ == 0 .AND. _nvzes==0
			reclock("ZZ4",.f.)
    		  //	ZZ4->ZZ4_BOUNCE := _dentrada-_dSaida
	    	  //	ZZ4->ZZ4_ULTSAI := _dSaida
	    		ZZ4->ZZ4_NUMVEZ := _nvzes+1 
   			msunlock()		
	    ENDIF
	
	
	Endif
	     
	
    QRY0->(DBSKIP())
                                                                                                           
ENDDO
RETURN()                                              