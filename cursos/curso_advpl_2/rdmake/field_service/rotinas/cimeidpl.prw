#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#DEFINE OPEN_FILE_ERROR -1
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Cimeidpl ºAutor  ³Edson Rodrigues     º Data ³  10/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa que corrige imeis duplicados conforme ocorrencia  º±±
±±º          ³ atipica de duplicação de IMEIs nos pedidos gerados pela    º±±
±±º          | saida massiva                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Cimeidpl()
Local  cqry
Local  _nopcao         
Local _aOSIMEI:={}                                     
Local cstatus :="4"

u_GerA0003(ProcName())

PREPARE ENVIRONMENT EMPRESA  '02' FILIAL '02'  TABLES "SD2","SF2","SC6","ZZ4"

//Seleciona os Registros                
// IMeis que estão encerrado, sem saida massiva com as mesmas notas que houveram duplicidade
cqry:=" SELECT ZZ4_FILIAL,ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODPRO,ZZ4_PV,ZZ4_IMEI,ZZ4_OS,ZZ4_STATUS,D1_IDENTB6,R_E_C_N_O_ AS RECNOZZ4 "
cqry+=" FROM "+Retsqlname("ZZ4")+" 
cqry+="     INNER JOIN (SELECT D1_DOC,D1_SERIE,D1_NUMSER,D1_IDENTB6 "
cqry+="                 FROM "+Retsqlname("SD1")+" WHERE D1_FILIAL='"+xfilial("SD1")+"' AND D_E_L_E_T_='') AS D1 "
cqry+=" ON D1_DOC=ZZ4_NFENR AND D1_SERIE=ZZ4_NFESER AND D1_NUMSER=ZZ4_IMEI "
cqry+=" WHERE ZZ4_FILIAL='"+xfilial("ZZ4")+"' AND RTRIM(ZZ4_NFENR)+'/'+RTRIM(ZZ4_NFESER) IN "
cqry+=" ('542001/1','544129/1','550092/1','550108/1','550134/1','550536/1','552395/1','553068/1','553122/1','553723/1','553813/1','559411/1','559418/1','559543/1','560160/1','562698/1','563786/1','566980/1','567077/1','581820/1','581821/1','584252/1','945901/1')"
cqry+=" AND D_E_L_E_T_='' AND ZZ4_STATUS = '"+cstatus+"' "
cqry+=" ORDER BY ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODPRO,ZZ4_IMEI "


DBSelectArea('SD2') //Itens da Nota de Saida
DBSelectArea('SF2') //Cabeçalho da Nota de Saida

SD2->(DBSetOrder(8)) 
SF2->(DBSetOrder(1)) 



if select("TRB") > 0
	TRB->(dbclosearea())
endif


TCQUERY cqry NEW ALIAS "TRB"
ProcRegua(TRB->(reccount()))

TRB->(dbGoTop())
While TRB->(!eof())
	
	// Incrementa a regua
	IncProc()
	
	cnfenum    := TRB->ZZ4_NFENR
	cnfeser    := TRB->ZZ4_NFESER
	codprod    := TRB->ZZ4_CODPRO
	cimeiZZ4   := TRB->ZZ4_IMEI 
	cOSzz4     := TRB->ZZ4_OS
	nreczz4    := TRB->RECNOZZ4
	lachou     := .f.
	
    cqry:= " SELECT A.R_E_C_N_O_ AS RECSC6 ,A.C6_NUMSERI IMEISC6 ,LEFT(A.C6_NUMOS,6) OSSC6 "
    cqry+= " FROM "+Retsqlname("SC6")+"  A "
    cqry+= " INNER JOIN "
    cqry+= "     (SELECT C6_NUM,C6_ITEM,C6_NUMSERI FROM ##SC6DUPL2 AS C6DPL  "
    cqry+= "         LEFT OUTER JOIN  "
    cqry+= "            (SELECT ZZ4_STATUS,ZZ4_IMEI,ZZ4_PV 
    cqry+= "             FROM "+Retsqlname("ZZ4")+" 
    cqry+= "             WHERE ZZ4_FILIAL='"+xfilial("ZZ4")+"' AND  D_E_L_E_T_='' )  AS ZZ4 "
    cqry+= "         ON ZZ4_IMEI=C6_NUMSERI AND LEFT(ZZ4_PV,6)=C6_NUM AND SUBSTRING(LTRIM(RTRIM(ZZ4_PV)),7,2)=C6_ITEM "
    cqry+= "      WHERE ZZ4.ZZ4_IMEI IS NULL "
    cqry+= "      AND LEFT(C6_NUMSERI,15) NOT IN ('000601166881760','000600275951520','000600277977520','000601206891760','000600270276520','000600271330780') "
    cqry+= " ) AS B "
    cqry+= " ON  A.C6_NUM=B.C6_NUM AND A.C6_ITEM=B.C6_ITEM AND A.C6_NUMSERI=B.C6_NUMSERI "
    cqry+= " WHERE C6_FILIAL='"+xfilial("SC6")+"'  AND D_E_L_E_T_='' AND C6_NFORI='"+cnfenum+"' AND C6_SERIORI='"+cnfeser+"' and C6_PRODUTO='"+codprod+"'
    cqry+= " ORDER BY A.C6_NFORI,A.C6_SERIORI,C6_PRODUTO,A.C6_NUMSERI "	 
	
	
	if select("TRB2") > 0
	   TRB2->(dbclosearea())
    endif


    TCQUERY cqry NEW ALIAS "TRB2"
    
    TRB2->(dbGoTop())
    While TRB2->(!eof())
        nrecsc6  := TRB2->RECSC6
 
         
        If Len(_aOSIMEI) > 0
           nSeek := Ascan(_aOSIMEI, { |x| x[1] == ALLTRIM(TRB2->IMEISC6)+ALLTRIM(TRB2->OSSC6)})
        ELSE
          nSeek =0
        Endif   
        
        IF nSeek = 0 .and. !lachou
	     
     	     Dbselectarea("SC6")
	         SC6->(Dbgoto(nrecsc6))
             RecLock('SC6',.F.)
			  SC6->C6_NUMOS	  := cOSzz4
			  SC6->C6_NUMSERI := cimeiZZ4
		     MsUnLock('SC6')
	 
	         Dbselectarea("SD2")
	         If SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM+SC6->C6_ITEM))
	            IF SD2->D2_NUMSERI==TRB2->IMEISC6
	               RecLock('SD2',.F.)
			         SD2->D2_NUMSERI := cimeiZZ4
		           MsUnLock('SD2')
	            ENDIF
	         
	            Dbselectarea("SF2")
	            SF2->(dbSeek(xFilial("SF2") + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA))
	         
	            
                
                IF cstatus > "4"
                   Dbselectarea("ZZ4")
	               ZZ4->(Dbgoto(nreczz4))
             
                   reclock("ZZ4",.f.)
      			      ZZ4->ZZ4_PV := ALLTRIM(SC6->C6_NUM)+ALLTRIM(SC6->C6_ITEM)
	     		      ZZ4->ZZ4_STATUS := "9"
		    	      ZZ4->ZZ4_NFSNR  := SD2->D2_DOC
			          ZZ4->ZZ4_NFSSER := SD2->D2_SERIE
			          ZZ4->ZZ4_NFSDT  := SD2->D2_EMISSAO
			          ZZ4->ZZ4_NFSHR  := SF2->F2_HORA
		              ZZ4->ZZ4_DOCDTS := SF2->F2_SAIROMA
		              ZZ4->ZZ4_DOCHRS := SF2->F2_HSAIROM
		              ZZ4->ZZ4_NFSTES := SD2->D2_TES
		              ZZ4->ZZ4_NFSCLI := SD2->D2_CLIENTE
		              ZZ4->ZZ4_NFSLOJ := SD2->D2_LOJA
	               msunlock()	         
	            Endif
	            
	            AADD(_aOSIMEI,{ALLTRIM(TRB2->IMEISC6)+ALLTRIM(TRB2->OSSC6)})
	            lachou:=.t.
	         Else
	            
	            IF cstatus > "4"
                
	               Dbselectarea("ZZ4")
	               ZZ4->(Dbgoto(nreczz4))
             
                   reclock("ZZ4",.f.)
			         ZZ4->ZZ4_PV := ALLTRIM(SC6->C6_NUM)+ALLTRIM(SC6->C6_ITEM)
			         ZZ4->ZZ4_STATUS := "8"
	               msunlock()	         
	            Endif  
	               
	            AADD(_aOSIMEI,{ALLTRIM(TRB2->IMEISC6)+ALLTRIM(TRB2->OSSC6)})
	            lachou:=.t.
	         Endif
	    
	     Endif
	    
	     TRB2->(dbskip())
	Enddo                         

  TRB->(dbskip())
Enddo	
	
Return()
