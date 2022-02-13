#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"
#include "tbiconn.ch"
#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCORINV1   บ Autor ณ Edson Rodrigues    บ Data ณ  23/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Corrige problemas de ajustes de inventario para            บฑฑ
ฑฑบ          ณ produtos que controlam lotes                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CORINV1()

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" TABLES "SD1","SD2","SBJ","SB1","SB8","SD5","SD3","SB9"

Private aAlias      := {"SD1","SD2","SBJ","SB1","SB8","SD5","SD3","SB9"}               
Private cDATAINV   := SPACE(8)
Private cDTULFECH  := SPACE(8)
Private cDOCINV    := SPACE(6)
Private cLOCAL     := SPACE(2)
Private cPRODUTO   := SPACE(15)
Private cFILIAL    := SPACE(2)
cFILIAL   := '01' 
cDATAINV  :='20100928'
cDOCINV   :='INVCOL' 
cDTULFECH :='20100831' 
cquery    :=""            


u_GerA0003(ProcName())          


DBSelectArea("SBJ")     
DBSetOrder(1) // BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL+BJ_NUMLOTE+DTOS(BJ_DATA)


//Filtra produtos inventariados que estใo com saldo diferente do estoque
IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif                        


cPRODUTO:="B-1205-7437"                  
cLOCAL:="85"
               

cquery:=" SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,QTDINV "+ENTER
cquery+=" FROM SB2020                                     "+ENTER
cquery+=" INNER JOIN                                      "+ENTER
cquery+=" (SELECT B7_FILIAL,B7_COD,B7_LOCAL,SUM(B7_QUANT) QTDINV "+ENTER 
cquery+=" FROM SB7020 WHERE B7_FILIAL='"+cFILIAL+"' AND B7_DATA='"+cDATAINV+"'  AND B7_DOC='"+cDOCINV+"' AND D_E_L_E_T_='' "+ENTER
If !empty(cPRODUTO)
    cquery+=" AND  B7_COD='"+cPRODUTO+"' "+ENTER 
ENDIF    
If !empty(cLOCAL)
    cquery+=" AND  B7_LOCAL='"+cLOCAL+"' "+ENTER 
ENDIF    
cquery+=" GROUP BY B7_FILIAL,B7_COD,B7_LOCAL) AS SB7  "+ENTER
cquery+=" ON B2_FILIAL=B7_FILIAL AND B2_LOCAL=B7_LOCAL AND B2_COD=B7_COD "+ENTER   
cquery+=" WHERE B2_FILIAL='"+cFILIAL+"' AND D_E_L_E_T_='' AND B2_QATU<>QTDINV   "+ENTER
If !empty(cPRODUTO)
    cquery+=" AND  B2_COD='"+cPRODUTO+"' "+ENTER 
ENDIF    
If !empty(cLOCAL)
    cquery+=" AND  B2_LOCAL='"+cLOCAL+"' "+ENTER 
ENDIF    

cquery+=" ORDER BY B2_FILIAL,B2_COD,B2_LOCAL  "+ENTER

TCQUERY cQuery NEW ALIAS "QRY0"  
dbSelectArea("QRY0")
dbGoTop()

While !QRY0->(EOF())

cLOCAL    :=QRY0->B2_LOCAL  
cPRODUTO  :=QRY0->B2_COD

                                     

  //Verifica se o produto esta com problema de saldo ap๓s o ajuste do inventario 
  IF Select("QRY1") <> 0 
  	DbSelectArea("QRY1")
	DbCloseArea()
  Endif                



  cquery :=" SELECT B2_FILIAL,B2_COD,B2_LOCAL,QTDINISB9,ENTRSD3,SAIDSD3,B2_QATU,((QTDINISB9+ENTRSD3)-SAIDSD3) AS SALATUESTQ,QTDINV,  "+ENTER 
  cquery +=" QTDINISBJ,ENTRSD5,SAIDSD5,((QTDINISBJ+ENTRSD5)-SAIDSD5) AS SALATULOTES,                                                 "+ENTER 
  cquery +=" OBSERV=CASE WHEN ((QTDINISBJ+ENTRSD5)-SAIDSD5)<>((QTDINISB9+ENTRSD3)-SAIDSD3) THEN 'SALDO ESTOQUE DIFERENTE SALDO LOTE' "+ENTER 
  cquery +="            WHEN ((QTDINISB9+ENTRSD3)-SAIDSD3)<> QTDINV THEN 'SALDO ESTOQUE DIFERENTE DO SALDO INVENTARIADO'             "+ENTER
  cquery +="            WHEN ((QTDINISBJ+ENTRSD5)-SAIDSD5)<> QTDINV THEN 'SALDO LOTE DIFERENTE SALDO INVENTARIADO'                   "+ENTER
  cquery +="            WHEN (((QTDINISBJ+ENTRSD5)-SAIDSD5)=((QTDINISB9+ENTRSD3)-SAIDSD3)) AND (((QTDINISBJ+ENTRSD5)-SAIDSD5)<>QTDINV) THEN 'SALDO LOTE IGUAL A SALDO ESTOQUE E SALDO LOTE DIFERENTE SALDO INVENTARIADO'    "+ENTER
  cquery +="            WHEN (((QTDINISBJ+ENTRSD5)-SAIDSD5)=((QTDINISB9+ENTRSD3)-SAIDSD3)) AND (((QTDINISB9+ENTRSD3)-SAIDSD3)<>QTDINV) THEN 'SALDO LOTE IGUAL A SALDO ESTOQUE E SALDO ESTOQUE DIFERENTE SALDO INVENTARIADO' "+ENTER 
  cquery +="            WHEN (((QTDINISBJ+ENTRSD5)-SAIDSD5)=((QTDINISB9+ENTRSD3)-SAIDSD3)) AND (((QTDINISB9+ENTRSD3)-SAIDSD3)=QTDINV) THEN 'SALDOS OK'                                                                      "+ENTER
  cquery +="            WHEN (QTDINISBJ < 0 OR  QTDINISB9 < 0 OR  B2_QATU < 0) THEN 'SALDO INICIAIS OU ESTOQUE NEGATIVO' END                                                                                                "+ENTER
  cquery +=" FROM SB2020                                                                                                                                                                                                    "+ENTER
  cquery +=" INNER JOIN                                                                                                                                                                                                     "+ENTER
  cquery +=" (SELECT B7_FILIAL,B7_COD,B7_LOCAL,SUM(B7_QUANT) QTDINV                                                                                                                                                         "+ENTER
  cquery +="  FROM SB7020 WHERE B7_FILIAL='"+cFILIAL+"' AND B7_LOCAL='"+cLOCAL+"' AND B7_COD='"+cPRODUTO+"' AND B7_DATA='"+cDATAINV+"'  AND B7_DOC='"+cDOCINV+"' AND D_E_L_E_T_=''                                         "+ENTER
  cquery +="  GROUP BY B7_FILIAL,B7_COD,B7_LOCAL) AS SB7                                                                                                                                                                    "+ENTER
  cquery +=" ON B2_FILIAL=B7_FILIAL AND B2_LOCAL=B7_LOCAL AND B2_COD=B7_COD                                                                                                                                                 "+ENTER
  cquery +=" INNER JOIN                                                                                                                                                                                                     "+ENTER
  cquery +=" (SELECT B9_FILIAL,B9_COD,B9_LOCAL,SUM(B9_QINI) AS  QTDINISB9                                                                                                                                                   "+ENTER       
  cquery +=" FROM SB9020                                                                                                                                                                                                    "+ENTER
  cquery +=" WHERE B9_FILIAL='"+cFILIAL+"' AND B9_LOCAL='"+cLOCAL+"' AND B9_COD='"+cPRODUTO+"' AND B9_DATA='"+cDTULFECH+"'  AND D_E_L_E_T_='' GROUP BY B9_FILIAL,B9_COD,B9_LOCAL ) AS SB9                                  "+ENTER
  cquery +=" ON B2_FILIAL=B9_FILIAL AND B2_LOCAL=B9_LOCAL AND B2_COD=B9_COD                                                                                                                                                 "+ENTER   
  cquery +=" LEFT OUTER JOIN  "+ENTER   
  cquery +="(SELECT D3_FILIAL,D3_COD,D3_LOCAL,ENTRSD3,SAIDSD3  FROM "+ENTER   
  cquery +="    (SELECT D3_FILIAL,D3_COD,D3_LOCAL,SUM(D3_QUANT) ENTRSD3,0 AS SAIDSD3 FROM SD3020 "+ENTER   
  cquery +="    WHERE D3_FILIAL='"+cFILIAL+"' AND D3_LOCAL='"+cLOCAL+"' AND D3_COD='"+cPRODUTO+"' AND D3_EMISSAO>='"+cDTULFECH+"'  AND D3_ESTORNO<>'S' AND D_E_L_E_T_='' AND D3_TM < '500'  "+ENTER   
  cquery +="    GROUP BY  D3_FILIAL,D3_COD,D3_LOCAL "+ENTER   
  cquery +="    UNION ALL"+ENTER   
  cquery +="    SELECT D3_FILIAL,D3_COD,D3_LOCAL,0 AS ENTRSD3,SUM(D3_QUANT) SAIDSD3 FROM SD3020 "+ENTER   
  cquery +="    WHERE D3_FILIAL='"+cFILIAL+"' AND D3_LOCAL='"+cLOCAL+"' AND D3_COD='"+cPRODUTO+"' AND D3_EMISSAO>='"+cDTULFECH+"'  AND D3_ESTORNO<>'S' AND D_E_L_E_T_='' AND D3_TM >= '500'  "+ENTER   
  cquery +="    GROUP BY  D3_FILIAL,D3_COD,D3_LOCAL) DELIVERTABL ) AS SD3  "+ENTER   
  cquery +=" ON B2_FILIAL=D3_FILIAL AND B2_LOCAL=D3_LOCAL AND B2_COD=D3_COD "+ENTER   
  cquery +=" LEFT OUTER JOIN"+ENTER   
  cquery +=" (SELECT BJ_FILIAL,BJ_COD,BJ_LOCAL,SUM(BJ_QINI) AS QTDINISBJ FROM SBJ020 "+ENTER   
  cquery +=" WHERE BJ_FILIAL='"+cFILIAL+"' AND BJ_LOCAL='"+cLOCAL+"' AND BJ_COD='"+cPRODUTO+"' AND BJ_DATA='"+cDTULFECH+"' AND D_E_L_E_T_='' "+ENTER   
  cquery +=" GROUP BY BJ_FILIAL,BJ_COD,BJ_LOCAL) AS SBJ "+ENTER   
  cquery +=" ON B2_FILIAL=BJ_FILIAL AND B2_LOCAL=BJ_LOCAL AND B2_COD=BJ_COD      "+ENTER   
  cquery +=" LEFT OUTER JOIN "+ENTER   
  cquery +=" (SELECT D5_FILIAL,D5_PRODUTO,D5_LOCAL,ENTRSD5,SAIDSD5  FROM "+ENTER   
  cquery +="  (SELECT D5_FILIAL,D5_PRODUTO,D5_LOCAL,SUM(D5_QUANT) AS ENTRSD5,0 AS SAIDSD5 FROM SD5020 "+ENTER   
  cquery +="    WHERE D5_FILIAL='"+cFILIAL+"' AND D5_LOCAL='"+cLOCAL+"' AND D5_PRODUTO='"+cPRODUTO+"' AND D5_DATA>='"+cDTULFECH+"'  AND D5_ESTORNO<>'S' AND D_E_L_E_T_='' AND D5_ORIGLAN < '500' "+ENTER   
  cquery +="    GROUP BY  D5_FILIAL,D5_PRODUTO,D5_LOCAL "+ENTER   
  cquery +="     UNION ALL"+ENTER   
  cquery +="    SELECT D5_FILIAL,D5_PRODUTO,D5_LOCAL,0 AS ENTRSD5,SUM(D5_QUANT) AS SAIDSD5 FROM SD5020 "+ENTER   
  cquery +="    WHERE D5_FILIAL='"+cFILIAL+"' AND D5_LOCAL='"+cLOCAL+"' AND D5_PRODUTO='"+cPRODUTO+"' AND D5_DATA>='"+cDTULFECH+"'  AND D5_ESTORNO<>'S' AND D_E_L_E_T_='' AND D5_ORIGLAN >= '500'  "+ENTER   
  cquery +="    GROUP BY  D5_FILIAL,D5_PRODUTO,D5_LOCAL) DELIVERTABL) AS SD5 "+ENTER   
  cquery +=" ON B2_FILIAL=D5_FILIAL AND B2_LOCAL=D5_LOCAL AND B2_COD=D5_PRODUTO "+ENTER   
  cquery +=" WHERE B2_FILIAL='"+cFILIAL+"' AND B2_LOCAL='"+cLOCAL+"' AND B2_COD='"+cPRODUTO+"' AND D_E_L_E_T_='' "+ENTER   


  TCQUERY cQuery NEW ALIAS "QRY1"  
  dbSelectArea("QRY1")
  dbGoTop()

  IF !QRY1->(Eof()) .AND. !EMPTY(QRY1->OBSERV) .AND. ALLTRIM(QRY1->OBSERV) <> 'SALDOS OK'
     //Verifica se o produto esta com problema de saldo ap๓s o ajuste do inventario
     IF Select("QRY2") <> 0 
	    DbSelectArea("QRY2")
	    DbCloseArea()
     Endif                
     //------Ve qual foi o ultimo fechamento onde os saldos Iniciais estavam iguais
     cquery :=" SELECT B2_FILIAL,B2_COD,B2_LOCAL,SUM(QTDINISB9) QINIB9,SUM(QTDINISBJ) QINIBJ ,MAX(DATASB9) B9DATA,MAX(DATASBJ) BJDATA "+ENTER   
     cquery +=" FROM SB2020 "+ENTER   
     cquery +=" INNER JOIN  "+ENTER   
     cquery +=" (SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA AS DATASB9,SUM(B9_QINI) AS  QTDINISB9 "+ENTER   
     cquery +=" FROM SB9020 "+ENTER   
     cquery +=" WHERE B9_FILIAL='"+cFILIAL+"' AND B9_LOCAL='"+cLOCAL+"' AND B9_COD='"+cPRODUTO+"' AND B9_DATA<'"+cDTULFECH+"'  AND D_E_L_E_T_='' "+ENTER   
     cquery +=" GROUP BY B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA ) AS SB9 "+ENTER   
     cquery +=" ON B2_FILIAL=B9_FILIAL AND B2_LOCAL=B9_LOCAL AND B2_COD=B9_COD "+ENTER      
     cquery +=" INNER JOIN "+ENTER   
     cquery +=" (SELECT BJ_FILIAL,BJ_COD,BJ_LOCAL,BJ_DATA DATASBJ,SUM(BJ_QINI) AS QTDINISBJ FROM SBJ020  "+ENTER
     cquery +=" WHERE BJ_FILIAL='"+cFILIAL+"' AND BJ_LOCAL='"+cLOCAL+"' AND BJ_COD='"+cPRODUTO+"' AND BJ_DATA<'"+cDTULFECH+"' AND D_E_L_E_T_=''  "+ENTER 
     cquery +=" GROUP BY BJ_FILIAL,BJ_COD,BJ_LOCAL,BJ_DATA) AS SBJ  "+ENTER
     cquery +=" ON B2_FILIAL=BJ_FILIAL AND B2_LOCAL=BJ_LOCAL AND B2_COD=BJ_COD  "+ENTER   
     cquery +=" WHERE B2_FILIAL='"+cFILIAL+"' AND B2_LOCAL='"+cLOCAL+"' AND B2_COD='"+cPRODUTO+"' AND D_E_L_E_T_=''  "+ENTER
     cquery +=" AND QTDINISB9=QTDINISBJ AND DATASB9=DATASBJ "+ENTER
     cquery +=" GROUP BY  B2_FILIAL,B2_COD,B2_LOCAL  "+ENTER  
   
     TCQUERY cQuery NEW ALIAS "QRY2"  
     dbSelectArea("QRY2")
     dbGoTop()
                                                             
   
     IF !QRY2->(Eof()) .AND. !EMPTY(ALLTRIM(QRY2->B9DATA))
      _cdtinref:=QRY2->B9DATA
      _saldinib9:=QRY2->QINIB9
      //Filtra todos os fechamentos apartir da data em que os fechamentos estavam iguais
      //Verifica se o produto esta com problema de saldo ap๓s o ajuste do inventario
      IF Select("QRY3") <> 0 
	    DbSelectArea("QRY3")
	    DbCloseArea()
      Endif                
   
      cquery :=" SELECT * FROM  SB9020 "+ENTER  
      cquery +=" WHERE B9_FILIAL='"+cFILIAL+"' AND B9_LOCAL='"+cLOCAL+"' AND B9_COD='"+cPRODUTO+"'  AND B9_DATA>='"+_cdtinref+"' AND D_E_L_E_T_='' "+ENTER  
      cquery +=" ORDER BY B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA "+ENTER  
      
      
      TCQUERY cQuery NEW ALIAS "QRY3"  
      dbSelectArea("QRY3")
      dbGoTop()
                        
      While !QRY3->(EOF())
         
          nsaldob9   :=QRY3->B9_QINI
          cdiniini   :=QRY3->B9_DATA 
          cdinifim   :=B9NEXDT(cFILIAL,cLOCAL,cPRODUTO,cdiniini)
          cdinifim   :=IIF(empty(cdinifim),cDATAINV,cdinifim) 

          
          nsalmovd3  :=U_SALDOD3(1,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
          nsalmovd2  :=U_SALDOD2(1,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)          
          nsalmovd1  :=U_SALDOD1(1,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)          
          nsaldobj   :=U_SALDOBJ(1,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
          nsalmovd5  :=U_SALDOD5(1,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
          saldfimb9  :=0
          adadosD3   :=U_SALDOD3(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
          adadosD2   :=U_SALDOD2(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
          adadosD1   :=U_SALDOD1(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
          adadosbj   :=U_SALDOBJ(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
          adadosd5   :=U_SALDOD5(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
          lcompmovi  :=.f.
          lcompsini  :=.f.
          lmovsublD3 :=.f.
          lmovsublD5 :=.f.
          lmovsublD2 :=.f.
                    
          
          // verifica se o saldo inicial do produto X lote sao iguais         
          If nsaldob9=nsaldobj
            lcompsini:=.t.
          Endif               
         
                  
          // verifica se as movimentacoes do produto X lote sao iguais
          IF ((nsalmovd3-nsalmovd2)+nsalmovd1)=nsalmovd5
            lcompmovi:=.t.
          Endif
                                      
         
          // verifica se houve movimentacoes no SD3 com o lote inicial e se o sublote e igual ao inicial 
          IF len(adadosbj) > 0 .and. len(adadosD3) > 0
             clotebj   := ""
             csblotebj := ""

           FOR xbj:=1 TO len(adadosBJ) 
              IF  adadosBJ[xbj,4] <> 0
                 IF aScan( adadosD3,{|x| x[4]==adadosBJ[xbj,1]}) > 0 .AND. aScan( adadosD3,{|x| x[5]==adadosBJ[xbj,2]}) == 0  
                            
                  nposlot    :=aScan( adadosD3,{|x| x[4]==adadosBJ[xbj,1]})
                  If !empty(clotebj) .and. !empty(csblotebj)
                       ligualsbl  :=IIf(adadosD3[nposlot,4]==clotebj .and. adadosD3[nposlot,5]==csblotebj,.t.,.f.)
                  Else
                       ligualsbl  :=IIf(adadosD3[nposlot,4]==adadosBJ[xbj,1] .and. adadosD3[nposlot,5]==adadosBJ[xbj,2],.t.,.f.)
                  Endif     
                  
                  If !ligualsbl 
                      If aScan( adadosD3,{|x| x[4]==adadosBJ[xbj,1]}) > 0 .AND. aScan( adadosD3,{|x| x[5]<>iif(empty(csblotebj),adadosBJ[xbj,2],csblotebj)}) > 0  
                         nposlot    :=aScan( adadosD3,{|x| x[4]==adadosBJ[xbj,1]})
                         ligualsbl  :=.f.
                      ENDIF   
                  Endif 
                  
                  IF   !ligualsbl
                     lmovsublD3 :=.t.
                     adadosD3[nposlot,5]:=adadosbj[xbj,2]               
                  
                     dbSelectArea("SD3") 
                     SD3->(dbgoto(adadosD3[nposlot,6]))
					 reclock("SD3",.f.)
					   SD3->D3_NUMLOTE :=adadosbj[xbj,2]               
			         msunlock()
                  ENDIF 
                  clotebj   := adadosBJ[xbj,1]
                  csblotebj := adadosBJ[xbj,2]

               ENDIF
             ENDIF    
           NEXT
          Endif
          
          // verifica se houve movimentacoes no SD3 com o lote inicial e se o sublote e igual ao inicial 
          If len(adadosbj) > 0 .and. len(adadosD2) > 0
             clotebj   := ""
             csblotebj := ""
             FOR xbj:=1 TO len(adadosBJ)
		       IF  adadosBJ[xbj,4] <> 0
		          IF aScan( adadosD2,{|x| x[4]==adadosBJ[xbj,1]}) > 0 .AND. aScan( adadosD2,{|x| x[5]==adadosBJ[xbj,2]}) == 0
          
                     nposlot    :=aScan( adadosD2,{|x| x[4]==adadosBJ[xbj,1]})
                  
                     If !empty(clotebj) .and. !empty(csblotebj)
                        ligualsbl  :=IIf(adadosD2[nposlot,4]==clotebj .and. adadosD2[nposlot,5]==csblotebj,.t.,.f.)
                     Else
                        ligualsbl  :=IIf(adadosD2[nposlot,4]==adadosBJ[xbj,1] .and. adadosD2[nposlot,5]==adadosBJ[xbj,2],.t.,.f.)
                     Endif   
                  
                     If !ligualsbl 
                        If aScan( adadosD2,{|x| x[4]==adadosBJ[xbj,1]}) > 0 .AND. aScan( adadosD2,{|x| x[5]<>iif(empty(csblotebj),adadosBJ[xbj,2],csblotebj)}) > 0  
                           nposlot    :=aScan( adadosD2,{|x| x[4]==adadosBJ[xbj,1]})
                           ligualsbl  :=.f.
                        ENDIF   
                     Endif 
                  
                     IF   !ligualsbl
                       lmovsublD2:=.t.
                       adadosD2[nposlot,5]:=adadosbj[xbj,2]               
                  
                       dbSelectArea("SD2") 
                       SD2->(dbgoto(adadosD2[nposlot,6]))
					   reclock("SD2",.f.)
					      SD2->D2_NUMLOTE :=adadosbj[xbj,2]               
			           msunlock()
                     ENDIF 
                     clotebj   := adadosBJ[xbj,1]
                     csblotebj := adadosBJ[xbj,2]

                  ENDIF     
               ENDIF
             Next
          Endif

         
          // verifica se houve movimentacoes no SD5 com o lote inicial e se o sublote e igual ao inicial 
          If len(adadosbj) > 0 .and. len(adadosD5) > 0
           FOR xbj:=1 TO len(adadosBJ)         
             clotebj   := ""
             csblotebj := ""
           
             IF  adadosBJ[xbj,4] <> 0
			     IF aScan( adadosD5,{|x| x[1]==adadosBJ[xbj,1]}) > 0 .AND. aScan( adadosD5,{|x| x[2]==adadosBJ[xbj,2]}) == 0
                     nposlot    := aScan( adadosD5,{|x| x[1]==adadosBJ[xbj,1]})
                 
                     If !empty(clotebj) .and. !empty(csblotebj)
                        ligualsbl  := iif(adadosD5[nposlot,1]==clotebj .and. adadosD5[nposlot,2]==csblotebj,.t.,.f.)
                     Else
                        ligualsbl  := iif(adadosD5[nposlot,1]==adadosBJ[xbj,1] .and. adadosD5[nposlot,2]==adadosBJ[xbj,2],.t.,.f.)
                     Endif
                    
                     If !ligualsbl 
                        If aScan( adadosD5,{|x| x[1]==adadosBJ[xbj,1]}) > 0 .AND. aScan( adadosD5,{|x| x[2]<>iif(empty(csblotebj),adadosBJ[xbj,2],csblotebj)}) > 0  
                           nposlot    :=aScan( adadosD5,{|x| x[1]==adadosBJ[xbj,1]})
                           ligualsbl  :=.f.
                        ENDIF   
                     Endif 
                  
                     IF !ligualsbl
                 
                        lmovsublD5:=.t.
                        adadosD5[nposlot,2]:=adadosbj[xbj,2]               
               
                        dbSelectArea("SD5") 
                        SD5->(dbgoto(adadosD5[nposlot,3]))
				        reclock("SD5",.f.)
					      SD5->D5_NUMLOTE :=adadosbj[xbj,2]               
			            msunlock()               
                     ENDIF
                     clotebj   := adadosBJ[xbj,1]
                     csblotebj := adadosBJ[xbj,2]
                 ENDIF    
              ENDIF
           	            
           Next
          Endif
         
          //Avisa que os saldos iniciais do estoque X lotes nao estao iguais                                 
          If !lcompsini
         	//MsgAlert("A soma do saldo Inicial (SB9) do produto :'"+cPRODUTO+"' armazem : '"+cLOCAL+"' esta diferente da soma do saldo inicial (SBJ) em "+QRY3->B9_DATA+" , verifique!")
	        //return(.f.)
            dbSelectArea("QRY3")
            QRY3->(DBSKIP())
            loop
          Endif
         
          //Avisa que os saldos finais do estoque X lotes nao estao iguais
          If !lcompmovi
         	 //MsgAlert("O saldo das movimentacoes do produto :'"+cPRODUTO+"' armazem : '"+cLOCAL+"' esta diferente do saldo das movimentacoes dos lotes"+cdinifim+" , verifique!")
	         //return(.f.)
             If len(adadosD1) > 0 
                For xd1:=1 to len(adadosD1) 
                    IF aScan( adadosD5,{|x| x[1]+x[5]==adadosD1[xd1,4]+adadosD1[xd1,8]}) ==0 
                       dDataValid := CTOD("  /  /  ")
                       DBSelectArea("SB8")
                       DBSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
                       IF DBSeek(xFilial("SB8")+cPRODUTO+cLOCAL+adadosD1[xd1,4])
                           dDataValid := SB8->B8_DTVALID
                       Endif     

                                       
                        dbSelectArea("SD1") 
                        SD1->(dbgoto(adadosD1[xd1,6])) 
                        cOp:=NIL   
                        cLoteFor  := Nil
                        cTm:= "499"
                        nQuant2UM := Nil 
                         nPotencia := 0
                        
                        GravaSD5("SD5",cProduto,cLocal,adadosD1[xd1,4],adadosD1[xd1,5],SD1->D1_NUMSEQ,SD1->D1_DOC,SD1->D1_SERIE,cOp,cTm,SD1->D1_FORNECE,SD1->D1_LOJA,cLoteFor,SD1->D1_QUANT,nQuant2UM,SD1->D1_DTDIGIT,dDataValid,nPotencia)
                        
                        dbSelectArea("SD5") 
                        aadd(adadosD5,{SD5->D5_LOTECTL,SD5->D5_NUMLOTE,SD5->(RECNO()),SD5->D5_QUANT,SD5->D5_NUMSEQ})     
                        nsalmovd5:=nsalmovd5+SD5->D5_QUANT 
			        //Else
                    //   nsalmovd5:=nsalmovd5+adadosD1[xd1,7]  
		            Endif
                Next
             Endif
             
             If len(adadosD2) > 0 
                For xd2:=1 to len(adadosD2)                     
                    
                    IF aScan( adadosD5,{|x| x[1]+x[5]==adadosD2[xd2,4]+adadosD2[xd2,8]}) ==0 
                       dDataValid := CTOD("  /  /  ")
                       DBSelectArea("SB8")
                       DBSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
                       IF DBSeek(xFilial("SB8")+cPRODUTO+cLOCAL+adadosD2[xd2,4])
                           dDataValid := SB8->B8_DTVALID
                       Endif     

                                       
                       dbSelectArea("SD2") 
                        SD2->(dbgoto(adadosD2[xd2,6])) 
                        cOp:=NIL   
                        cLoteFor  := Nil
                        cTm:= "999"
                        nQuant2UM := Nil 
                         nPotencia := 0
                        
                        GravaSD5("SD5",cProduto,cLocal,adadosD2[xd2,4],adadosD2[xd2,5],SD2->D2_NUMSEQ,SD2->D2_DOC,SD2->D2_SERIE,cOp,cTm,SD2->D2_CLIENTE,SD2->D2_LOJA,cLoteFor,SD2->D2_QUANT,nQuant2UM,SD2->D2_EMISSAO,dDataValid,nPotencia)
                        
                        dbSelectArea("SD5") 
                        aadd(adadosD5,{SD5->D5_LOTECTL,SD5->D5_NUMLOTE,SD5->(RECNO()),SD5->D5_QUANT,SD5->D5_NUMSEQ})     
                        nsalmovd5:=nsalmovd5-SD5->D5_QUANT 
			        //Else
			        //   nsalmovd5:=nsalmovd5-adadosD2[xd2,7] 
			        Endif
                Next
             Endif
             
             If len(adadosD3) > 0 
                For xd3:=1 to len(adadosD3) 
                    IF aScan( adadosD5,{|x| x[1]+x[5]==adadosD3[xd3,4]+adadosD3[xd3,9]}) ==0
                       dDataValid := CTOD("  /  /  ")
                       DBSelectArea("SB8")
                       DBSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
                       IF DBSeek(xFilial("SB8")+cPRODUTO+cLOCAL+adadosD3[xd3,4])
                           dDataValid := SB8->B8_DTVALID
                       Endif     

                                       
                       dbSelectArea("SD3") 
                        SD3->(dbgoto(adadosD3[xd3,6])) 
                        cOp:=NIL   
                        cLoteFor  := Nil
                        cTm:= SD3->D3_TM
                        nQuant2UM := Nil 
                         nPotencia := 0
                        
                        GravaSD5("SD5",cProduto,cLocal,adadosD3[xd3,4],adadosD3[xd3,5],SD3->D3_NUMSEQ,SD3->D3_DOC,nil,cOp,cTm,nil,nil,cLoteFor,SD3->D3_QUANT,nQuant2UM,SD3->D3_EMISSAO,dDataValid,nPotencia)
                        
                        dbSelectArea("SD5") 
                        aadd(adadosD5,{SD5->D5_LOTECTL,SD5->D5_NUMLOTE,SD5->(RECNO()),SD5->D5_QUANT,SD5->D5_NUMSEQ})     
                        nsalmovd5:=iif(cTm < '500',nsalmovd5+SD5->D5_QUANT,nsalmovd5-SD5->D5_QUANT)
			        //Else
			        //   nsalmovd5:=(nsalmovd5+adadosD3[xd3,7])-adadosD3[xd3,8]
			        Endif
                Next
              Endif
          Endif
             
             
          // verifica novamente se as movimentacoes do produto X lote sao iguais
          If ((nsalmovd3-nsalmovd2)+nsalmovd1)=nsalmovd5
                lcompmovi:=.t.
             
          Elseif len(adadosD3)=0 .and. len(adadosD2)=0 .and. len(adadosD1)=0 .and. len(adadosD5)>0
                For xd5:=1 to len(adadosD5)
                    dbSelectArea("SD5") 
                    SD5->(dbgoto(adadosD5[xd5,3])) 
				    reclock("SD5",.f.)
					  SD5->D5_ESTORNO :='S'
			        msunlock()               
                    adadosD5[xd5,4]:=0
                Next
                lcompmovi:=.t.
          Endif
         
          
          
                              
          //Se o Saldos Inciciais e do Movimento forem iguais, atualizar o saldo incial do fechamento seguinte
          If lcompsini .and. lcompmovi
          
            //zera os saldos iniciais dos lotes do fechamento seguinte
            UPDATBJ(1,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","",0)          
            If len(adadosD5) > 0
                  cloted5    :=""
                  csublotd5  :=""
                  nsalmvd5lt :=0
                  nsalinbjlt :=0
                  nsalfimvlt :=0
               for xd5:=1 to  len(adadosD5)
               
                 If cloted5+csublotd5 <>adadosD5[xd5,1]+adadosD5[xd5,2] 
                    cloted5   :=adadosD5[xd5,1]
                    csublotd5 :=adadosD5[xd5,2] 
                    nsalmvd5lt :=U_SALDOD5(3,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,cloted5,csublotd5)          
                    nsalinbjlt :=U_SALDOBJ(3,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,cloted5,csublotd5)                  
                    nsalfimvlt :=nsalinbjlt+nsalmvd5lt
                    If nsalfimvlt >= 0   .or. (nsalfimvlt< 0 .and.  stod(cdinifim)< stod(cDTULFECH))
                       UPDATBJ(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,adadosD5[xd5,1],adadosD5[xd5,2],nsalfimvlt)          
                    Endif   
                 
                 Else
                     cloted5   :=adadosD5[xd5,1]
                     csublotd5 :=adadosD5[xd5,2] 
                 Endif  
               Next
                                                              
               IF len(adadosBJ) > 0
                  clotebj    :=""
                  csublotbj  :=""
                  nsalmvd5lt :=0
                  nsalinbjlt :=0
                  nsalfimvlt :=0
 
                  for xbj:=1 to  len(adadosBJ)
                      If clotebj+csublotbj <>adadosBJ[xbj,1]+adadosBJ[xbj,2] 
                         clotebj   :=adadosBJ[xbj,1]
                         csublotbj :=adadosBJ[xbj,2] 

                         If aScan( adadosD5,{|x| x[1]+x[2]==adadosBJ[xbj,1]+adadosBJ[xbj,2]}) == 0 
                             nsalinbjlt :=U_SALDOBJ(3,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,adadosBJ[xbj,1],adadosBJ[xbj,2])                  
                             nsalfimvlt :=nsalinbjlt+nsalmvd5lt
                             If nsalfimvlt >= 0 .or. (nsalfimvlt< 0 .and.  stod(cdinifim)< stod(cDTULFECH))
                                 UPDATBJ(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,adadosBJ[xbj,1],adadosBJ[xbj,2],nsalfimvlt)          
                             Endif    
                         Endif
                      Else  
                         clotebj   :=adadosBJ[xbj,1]
                         csublotbj :=adadosBJ[xbj,2] 
                      Endif   
                  Next                                               
               Endif
               
            Else
              If len(adadosBJ) > 0
                FOR xbj:=1 TO len(adadosBJ) 
                    UPDATBJ(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,adadosBJ[xbj,1],adadosBJ[xbj,2],adadosBJ[xbj,4])          
                NEXT
              Endif
            Endif
          
          Endif 
         
         QRY3->(DBSKIP())
      ENDDO
     ENDIF
  ENDIF
 QRY0->(DBSKIP())
ENDDO
Return





//-----Movimento Prod SD3 ultimo fechamento 
USER FUNCTION SALDOD3(nfilt,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
Local cquery:=""
Local adadsd3:={}
Local nsald3:= 0

IF Select("QRY4") <> 0 
	    DbSelectArea("QRY4")
	    DbCloseArea()
Endif                


IF nfilt = 1
   cquery:="(SELECT D3_FILIAL,D3_COD,D3_LOCAL,ENTRSD3,SAIDSD3  FROM "+ENTER   
   cquery +="    (SELECT D3_FILIAL,D3_COD,D3_LOCAL,SUM(D3_QUANT) ENTRSD3,0 AS SAIDSD3 FROM SD3020 "+ENTER   
Else
  cquery:="(SELECT D3_FILIAL,D3_COD,D3_LOCAL,D3_LOTECTL,D3_NUMLOTE,D3_NUMSEQ,RECNO,ENTRSD3,SAIDSD3  FROM "+ENTER   
  cquery +="    (SELECT D3_FILIAL,D3_COD,D3_LOCAL,D3_LOTECTL,D3_NUMLOTE,D3_NUMSEQ,R_E_C_N_O_ AS RECNO,SUM(D3_QUANT) ENTRSD3,0 AS SAIDSD3 FROM SD3020 "+ENTER   
Endif   

   cquery +="    WHERE D3_FILIAL='"+cFILIAL+"' AND D3_LOCAL='"+cLOCAL+"' AND D3_COD='"+cPRODUTO+"' AND D3_EMISSAO>'"+cdiniini+"' AND D3_EMISSAO<='"+cdinifim+"' AND D3_ESTORNO<>'S' AND D_E_L_E_T_='' AND D3_TM < '500'  "+ENTER   
IF nfilt = 3    
    cquery +="   AND D3_DOC<>'INVENT'  "+ENTER   
ENDIF                        
IF nfilt = 4    
    cquery +="   AND D3_DOC='INVENT'  "+ENTER   
ENDIF                        

IF nfilt = 1
   cquery +="    GROUP BY  D3_FILIAL,D3_COD,D3_LOCAL "+ENTER   
Else
   cquery +="    GROUP BY  D3_FILIAL,D3_COD,D3_LOCAL,D3_LOTECTL,D3_NUMLOTE,D3_NUMSEQ,R_E_C_N_O_ "+ENTER   
Endif   

cquery +="    UNION ALL"+ENTER   

IF nfilt = 1
    cquery +="    SELECT D3_FILIAL,D3_COD,D3_LOCAL,0 AS ENTRSD3,SUM(D3_QUANT) SAIDSD3 FROM SD3020 "+ENTER   
Else
    cquery +="    SELECT D3_FILIAL,D3_COD,D3_LOCAL,D3_LOTECTL,D3_NUMLOTE,D3_NUMSEQ,R_E_C_N_O_ AS RECNO,0 AS ENTRSD3,SUM(D3_QUANT) SAIDSD3 FROM SD3020 "+ENTER   
Endif
cquery +="    WHERE D3_FILIAL='"+cFILIAL+"' AND D3_LOCAL='"+cLOCAL+"' AND D3_COD='"+cPRODUTO+"' AND D3_EMISSAO>'"+cdiniini+"' AND D3_EMISSAO<='"+cdinifim+"'  AND D3_ESTORNO<>'S' AND D_E_L_E_T_='' AND D3_TM >= '500'  "+ENTER   
IF nfilt = 3  .or. nfilt = 5
    cquery +="   AND D3_DOC<>'INVENT'  "+ENTER   
ENDIF                        
IF nfilt = 4  .or. nfilt = 6  
    cquery +="   AND D3_DOC='INVENT'  "+ENTER   
ENDIF                        
IF nfilt = 1
   cquery +="    GROUP BY  D3_FILIAL,D3_COD,D3_LOCAL) DELIVERTABL)  "+ENTER 
Else
   cquery +="    GROUP BY  D3_FILIAL,D3_COD,D3_LOCAL,D3_LOTECTL,D3_NUMLOTE,D3_NUMSEQ,R_E_C_N_O_) DELIVERTABL) "+ENTER 
Endif


TCQUERY cQuery NEW ALIAS "QRY4"  
dbSelectArea("QRY4")
dbGoTop()
                        
While !QRY4->(EOF())
  IF nfilt = 1 .or. nfilt = 3 .or. nfilt = 4    
    nsald3:=(nsald3+QRY4->ENTRSD3)-QRY4->SAIDSD3
  ELSE
    aadd(adadsd3,{QRY4->D3_FILIAL,QRY4->D3_COD,QRY4->D3_LOCAL,QRY4->D3_LOTECTL,QRY4->D3_NUMLOTE,QRY4->RECNO,QRY4->ENTRSD3,QRY4->SAIDSD3,QRY4->D3_NUMSEQ})     
  ENDIF 
  QRY4->(DBSKIP())
Enddo  

RETURN(IIF(nfilt = 1 .or. nfilt = 3 .or. nfilt = 4,nsald3,adadsd3))








//-----Movimento Prod SD2  ultimo fechamento 
USER FUNCTION SALDOD2(nfilt,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
Local cquery:=""
Local adadsd2:={}
lOCAL nsald2 := 0

IF Select("QRY5") <> 0 
	    DbSelectArea("QRY5")
	    DbCloseArea()
Endif                

IF nfilt=1
   cquery:= " SELECT D2_FILIAL,D2_COD,D2_LOCAL,SUM(D2_QUANT) AS D2QUANT FROM SD2020 "+ENTER 
Else
   cquery:= " SELECT D2_FILIAL,D2_COD,D2_LOCAL,D2_LOTECTL,D2_NUMLOTE,D2_NUMSEQ,R_E_C_N_O_ AS RECNO,SUM(D2_QUANT) AS D2QUANT FROM SD2020 "+ENTER 
Endif
cquery+= "    WHERE D2_FILIAL='"+cFILIAL+"' AND D2_LOCAL='"+cLOCAL+"' AND D2_COD='"+cPRODUTO+"'  AND D2_EMISSAO>'"+cdiniini+"'  AND D2_EMISSAO<='"+cdinifim+"'   AND D_E_L_E_T_='' "+ENTER 
IF nfilt=1
  cquery+= "  GROUP BY D2_FILIAL,D2_COD,D2_LOCAL "+ENTER 
  cquery+= "  ORDER BY D2_FILIAL,D2_COD,D2_LOCAL "+ENTER 
ELSE
  cquery+= "  GROUP BY D2_FILIAL,D2_COD,D2_LOCAL,D2_LOTECTL,D2_NUMLOTE,D2_NUMSEQ,R_E_C_N_O_ "+ENTER 
  cquery+= "  ORDER BY R_E_C_N_O_  
ENDIF

TCQUERY cQuery NEW ALIAS "QRY5"  
dbSelectArea("QRY5")
dbGoTop()
                        
While !QRY5->(EOF())
  IF nfilt = 1    
    nsald2:=nsald2+QRY5->D2QUANT
  ELSE
    aadd(adadsd2,{QRY5->D2_FILIAL,QRY5->D2_COD,QRY5->D2_LOCAL,QRY5->D2_LOTECTL,QRY5->D2_NUMLOTE,QRY5->RECNO,QRY5->D2QUANT,QRY5->D2_NUMSEQ})     
  ENDIF 
  QRY5->(DBSKIP())
Enddo  

RETURN (IIF(nfilt=1,nsald2,adadsd2))







//-----Movimento Prod SD1 ultimo fechamento 
USER FUNCTION SALDOD1(nfilt,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
Local cquery:=""
Local adadsd1:={}
lOCAL nsald1 := 0

IF Select("QRY6") <> 0 
	    DbSelectArea("QRY6")
	    DbCloseArea()
Endif                

IF nfilt=1
   cquery:= " SELECT D1_FILIAL,D1_COD,D1_LOCAL,SUM(D1_QUANT) AS D1QUANT FROM SD1020 "+ENTER 
Else
   cquery:= " SELECT D1_FILIAL,D1_COD,D1_LOCAL,D1_LOTECTL,D1_NUMLOTE,D1_NUMSEQ,R_E_C_N_O_ AS RECNO,SUM(D1_QUANT) AS D1QUANT FROM SD1020 "+ENTER 
Endif
cquery+= "    WHERE D1_FILIAL='"+cFILIAL+"' AND D1_LOCAL='"+cLOCAL+"' AND D1_COD='"+cPRODUTO+"'  AND D1_DTDIGIT>'"+cdiniini+"'  AND D1_DTDIGIT<='"+cdinifim+"'   AND D_E_L_E_T_='' "+ENTER 
IF nfilt=1
  cquery+= "  GROUP BY D1_FILIAL,D1_COD,D1_LOCAL "+ENTER 
  cquery+= "  ORDER BY D1_FILIAL,D1_COD,D1_LOCAL "+ENTER 
ELSE
  cquery+= "  GROUP BY D1_FILIAL,D1_COD,D1_LOCAL,D1_LOTECTL,D1_NUMLOTE,D1_NUMSEQ,R_E_C_N_O_ "+ENTER 
  cquery+= "  ORDER BY R_E_C_N_O_ "+ENTER  
ENDIF

TCQUERY cQuery NEW ALIAS "QRY6"  
dbSelectArea("QRY6")
dbGoTop()
                        
While !QRY6->(EOF())
  IF nfilt = 1    
    nsald1:=nsald1+QRY6->D1QUANT
  ELSE
    aadd(adadsd1,{QRY6->D1_FILIAL,QRY6->D1_COD,QRY6->D1_LOCAL,QRY6->D1_LOTECTL,QRY6->D1_NUMLOTE,QRY6->RECNO,QRY6->D1QUANT,QRY6->D1_NUMSEQ})     
  ENDIF 
  QRY6->(DBSKIP())
Enddo  

RETURN (IIF(nfilt=1,nsald1,adadsd1))


                       








//-------Saldo Inicial Prod/lote/sublote ultimo fechamento
USER FUNCTION SALDOBJ(nfilt,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,cloted5,csublotd5)

Local cquery:=""
Local adadsBJ:={}
lOCAL nsalBJ := 0

IF Select("QRY7") <> 0 
	    DbSelectArea("QRY7")
	    DbCloseArea()
Endif                

cquery:=" SELECT BJ_LOTECTL,BJ_NUMLOTE,R_E_C_N_O_ AS RECNO,SUM(BJ_QINI) AS SALDINI FROM SBJ020  "+ENTER 
cquery+=" WHERE BJ_FILIAL='"+cFILIAL+"' AND BJ_LOCAL='"+cLOCAL+"' AND BJ_COD='"+cPRODUTO+"' AND BJ_DATA='"+cdiniini+"' AND D_E_L_E_T_=''  "+ENTER 
IF nfilt = 3
cquery+=" AND BJ_LOTECTL='"+cloted5+"' AND BJ_NUMLOTE='"+csublotd5+"'
ENDIF 
cquery+=" GROUP BY BJ_LOTECTL,BJ_NUMLOTE,R_E_C_N_O_  "+ENTER 

TCQUERY cQuery NEW ALIAS "QRY7"  
dbSelectArea("QRY7")
dbGoTop()
                        
While !QRY7->(EOF())
  IF nfilt = 1 .OR. nfilt = 3    
    nsalbj:=nsalBJ+QRY7->SALDINI
  ELSE
    //If QRY7->SALDINI <> 0
       aadd(adadsbj,{QRY7->BJ_LOTECTL,QRY7->BJ_NUMLOTE,QRY7->RECNO,QRY7->SALDINI})     
    //Endif   
  ENDIF 
  QRY7->(DBSKIP())
Enddo  

RETURN (IIF(nfilt=1 .OR. nfilt=3,nsalBJ,adadsBJ))




//-------Movimento Prod/lote/sublote ultimo fechamento @DTFINI
USER FUNCTION SALDOD5(nfilt,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,cloted5,csublotd5)

Local cquery:=""
Local adadsD5:={}
lOCAL nsalD5 := 0

IF Select("QRY8") <> 0 
	    DbSelectArea("QRY8")
	    DbCloseArea()
Endif                

cquery:=" SELECT D5_ORIGLAN,D5_LOTECTL,D5_NUMLOTE,D5_NUMSEQ,R_E_C_N_O_ AS RECNO,SUM(D5_QUANT) AS QTDED5 FROM SD5020 "+ENTER 
cquery+=" WHERE D5_FILIAL='"+cFILIAL+"' AND D5_LOCAL='"+cLOCAL+"' AND D5_PRODUTO='"+cPRODUTO+"' AND D5_DATA>'"+cdiniini+"' AND D5_DATA<='"+cdinifim+"' AND D5_ESTORNO<>'S' AND D_E_L_E_T_='' "+ENTER 
IF nfilt = 3
cquery+=" AND D5_LOTECTL='"+cloted5+"' AND D5_NUMLOTE='"+csublotd5+"'
ENDIF
IF nfilt = 4 .OR. nfilt = 6 
   cquery+=" AND D5_DOC<>'INVENT' "
ENDIF  
IF nfilt = 5  .OR. nfilt = 7
   cquery+=" AND D5_DOC='INVENT' "
ENDIF  
cquery+=" GROUP BY D5_ORIGLAN,D5_LOTECTL,D5_NUMLOTE,D5_NUMSEQ,R_E_C_N_O_ "+ENTER 


TCQUERY cQuery NEW ALIAS "QRY8"  
dbSelectArea("QRY8")
dbGoTop()
                        
While !QRY8->(EOF())
  IF nfilt = 1 .OR. nfilt = 3  .OR. nfilt = 4 .OR.  nfilt = 5 
    If D5_ORIGLAN < '500'
         nsald5:=nsald5+QRY8->QTDED5
    Else
         nsald5:=nsald5-QRY8->QTDED5
    Endif     
  ELSE
    If QRY8->QTDED5 <> 0
       aadd(adadsd5,{QRY8->D5_LOTECTL,QRY8->D5_NUMLOTE,QRY8->RECNO,QRY8->QTDED5,QRY8->D5_NUMSEQ})     
    Endif   
  ENDIF 
  QRY8->(DBSKIP())
Enddo  

RETURN (IIF(nfilt = 1 .OR. nfilt = 3  .OR. nfilt = 4 .OR.  nfilt = 5,nsald5,adadsd5))





//-------Saldo Inicial Prod/lote/sublote ultimo fechamento
STATIC FUNCTION UPDATBJ(nfilt,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,cloted5,csublotd5,nsalfimvlt)

Local cquery:=""
lOCAL lret  := .f.

IF Select("QRY9") <> 0 
	    DbSelectArea("QRY9")
	    DbCloseArea()
Endif                

cquery:=" SELECT BJ_LOTECTL,BJ_NUMLOTE,R_E_C_N_O_ AS RECNO,SUM(BJ_QINI) AS SALDINI FROM SBJ020  "+ENTER 
cquery+=" WHERE BJ_FILIAL='"+cFILIAL+"' AND BJ_LOCAL='"+cLOCAL+"' AND BJ_COD='"+cPRODUTO+"' AND BJ_DATA='"+cdinifim+"' AND D_E_L_E_T_=''  "+ENTER 
IF nfilt = 2
cquery+=" AND BJ_LOTECTL='"+cloted5+"' AND BJ_NUMLOTE='"+csublotd5+"'
ENDIF 
cquery+=" GROUP BY BJ_LOTECTL,BJ_NUMLOTE,R_E_C_N_O_  "+ENTER 

TCQUERY cQuery NEW ALIAS "QRY9"  
dbSelectArea("QRY9")
dbGoTop()

If Select("QRY9") > 0 .AND. !EMPTY(QRY9->RECNO)                        
   While !QRY9->(EOF())
      cquery := " UPDATE "+ RetSQLName("SBJ") +" "
      cquery += " SET BJ_QINI="+ALLTRIM(STR(nsalfimvlt))+"  "
      cquery += " WHERE R_E_C_N_O_="+ALLTRIM(STR(QRY9->RECNO))+" "
      TCSQLEXEC (cquery)
      TCRefresh("SBJ")
      lret:=.t.
     QRY9->(DBSKIP())
   Enddo

Else
  If nfilt = 2      
     dDataValid := CTOD("  /  /  ")
     DBSelectArea("SB8")
     DBSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
     IF DBSeek(xFilial("SB8")+cPRODUTO+cLOCAL+cloted5)
        dDataValid := SB8->B8_DTVALID
     Endif     
    
     If stod(cdinifim) < stod(cDTULFECH)
     
        RecLock("SBJ",.T.)
          SBJ->BJ_FILIAL  := xFilial("SBJ")
          SBJ->BJ_COD     := cPRODUTO
          SBJ->BJ_LOCAL   := cLOCAL        
          SBJ->BJ_DATA    := STOD(cdinifim)
          SBJ->BJ_DTVALID := dDataValid
          SBJ->BJ_LOTECTL := cloted5
          SBJ->BJ_NUMLOTE := csublotd5
          SBJ->BJ_QINI    := nsalfimvlt
          SBJ->BJ_QISEGUM := ConvUM(cPRODUTO,nsalfimvlt,0,2) // 2UM
        MsUnlock()
     
     Endif
     
     lret:=.t.
  Endif 

Endif     
     
RETURN (lret)                                              


//-------Saldo Inicial Prod/lote/sublote ultimo fechamento
STATIC FUNCTION B9NEXDT(cFILIAL,cLOCAL,cPRODUTO,_cdtinref)
Local cquery:=""
Local cdatab9:=""
lOCAL lret  := .f.

IF Select("QRY10") <> 0 
	    DbSelectArea("QRY10")
	    DbCloseArea()
Endif                



cquery :=" SELECT TOP 1 B9_DATA FROM  SB9020 "+ENTER  
cquery +=" WHERE B9_FILIAL='"+cFILIAL+"' AND B9_LOCAL='"+cLOCAL+"' AND B9_COD='"+cPRODUTO+"'  AND B9_DATA>'"+_cdtinref+"' AND D_E_L_E_T_='' "+ENTER  
cquery +=" ORDER BY B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA "+ENTER  
      
TCQUERY cQuery NEW ALIAS "QRY10"  
dbSelectArea("QRY10")
dbGoTop()

If Select("QRY10") > 0                        
   While !QRY10->(EOF()) .AND. !EMPTY(QRY10->B9_DATA)
       cdatab9:=QRY10->B9_DATA
   QRY10->(DBSKIP())
   Enddo                
Endif                   
                                                                                                           
RETURN(cdatab9)                                              

