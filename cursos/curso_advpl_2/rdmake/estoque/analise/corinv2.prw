#INCLUDE "PROTHEUS.CH"                                                         
#INCLUDE "TopConn.ch"
#include "tbiconn.ch"
#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCORINV2   บ Autor ณ Edson Rodrigues    บ Data ณ  23/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ apos a correcao dos problemas de ajustes de inventario paraบฑฑ
ฑฑบ          ณ produtos que controlam lotes na funcao CORINV1, ajusta-se  บฑฑ
ฑฑบ          | as movimentacoes feitas pelo ajuste de invetario que       บฑฑ
ฑฑบ          | deixaram o saldo (SD2) desbalanceado com a quantidade digi-บฑฑ
ฑฑบ          | tada para invetario (SB7)                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CORINV2()

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" TABLES "SD1","SD2","SBJ","SB1","SB8","SD5","SD3","SB9"

Private aAlias     := {"SD1","SD2","SBJ","SB1","SB8","SD5","SD3","SB9"}               
Private cDATAINV   := SPACE(8)
Private cDTULFECH  := SPACE(8)
Private cDOCINV    := SPACE(6)
Private cLOCAL     := SPACE(2)
Private cPRODUTO   := SPACE(15)
Private cFILIAL    := SPACE(2)              
Private ccontg     := "001"
Private cescolh    := "S"
Private cok        := "1"
cFILIAL   := '01' 
cDATAINV  :='20100831'
cDOCINV   :='INVCOL' 
cDTULFECH :='20100731' 
cquery    :=""                      


u_GerA0003(ProcName())

DBSelectArea("SBJ")     
DBSetOrder(1) // BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL+BJ_NUMLOTE+DTOS(BJ_DATA)

DbSelectarea("SB7") 
DBSetOrder(1) //B7_FILIAL+B7_DATA+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE     

DbSelectarea("SB1")                            
DBSetOrder(1) //B1_FILIAL+B1_COD

//Filtra produtos inventariados que estใo com saldo diferente do estoque
IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif                        


cPRODUTO:="B-SGH-M310AALZT"                  
cLOCAL:="83"
               
cquery:= " SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA,B9_QINI,B2_QATU,QTDINV,QTDINISBJ "+ENTER 
cquery+= " FROM SB9020 INNER JOIN "+ENTER 
cquery+= " (SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,QTDINV "+ENTER
cquery+= " FROM SB2020                                     "+ENTER
cquery+= " INNER JOIN                                      "+ENTER
cquery+= " (SELECT B7_FILIAL,B7_COD,B7_LOCAL,SUM(B7_QUANT) QTDINV "+ENTER 
cquery+= " FROM SB7020 WHERE B7_FILIAL='"+cFILIAL+"' AND B7_DATA='"+cDATAINV+"'  AND B7_DOC='"+cDOCINV+"' AND D_E_L_E_T_='' "+ENTER
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
cquery+=") AS SB2 "+ENTER
cquery+= " ON B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND B9_LOCAL=B2_LOCAL "+ENTER
cquery+= " INNER JOIN  "+ENTER
cquery+= " (SELECT BJ_FILIAL,BJ_COD,BJ_LOCAL,SUM(BJ_QINI) AS QTDINISBJ FROM SBJ020 "+ENTER
cquery+= "  WHERE BJ_DATA="+cDTULFECH+" AND D_E_L_E_T_='' "+ENTER
If !empty(cPRODUTO)
    cquery+=" AND  BJ_COD='"+cPRODUTO+"' "+ENTER 
ENDIF    
If !empty(cLOCAL)
    cquery+=" AND  BJ_LOCAL='"+cLOCAL+"' "+ENTER 
ENDIF    
cquery+= "  GROUP BY BJ_FILIAL,BJ_COD,BJ_LOCAL) AS SBJ "+ENTER
cquery+= "  ON B9_FILIAL=BJ_FILIAL AND B9_LOCAL=BJ_LOCAL AND B9_COD=BJ_COD  "+ENTER  
cquery+= "  WHERE D_E_L_E_T_='' AND B9_DATA="+cDTULFECH+" AND  "+ENTER
cquery+= "  B9_QINI=QTDINISBJ  "+ENTER                                
If !empty(cPRODUTO)
    cquery+=" AND  B9_COD='"+cPRODUTO+"' "+ENTER 
ENDIF    
If !empty(cLOCAL)
    cquery+=" AND  B9_LOCAL='"+cLOCAL+"' "+ENTER 
ENDIF    
cquery+= "ORDER BY B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA "+ENTER





TCQUERY cQuery NEW ALIAS "QRY0"  
dbSelectArea("QRY0")
dbGoTop()

While !QRY0->(EOF())

  cLOCAL    :=QRY0->B9_LOCAL  
  cPRODUTO  :=QRY0->B9_COD
  _csubltb7 :=""
   nsaldob9 :=QRY0->B9_QINI                               
   nsalatu  :=QRY0->B2_QATU
   nsalinv  :=QRY0->QTDINV 
   cdiniini :=QRY0->B9_DATA 
   cdinifim :=cDATAINV
   nsaldobj :=QRY0->QTDINISBJ 
   _alotsbJ :={}

  //Corrige o lote e sublote digitado de acordo com o ultimo fechamento
  IF Select("QRY1") <> 0 
  	DbSelectArea("QRY1")
	DbCloseArea()
  Endif                




  cquery :=" SELECT BJ_FILIAL,BJ_COD,BJ_LOCAL,BJ_DATA,BJ_QINI,BJ_LOTECTL,BJ_NUMLOTE "+ENTER
  cquery +=" FROM SBJ020 "+ENTER 
  cquery +=" WHERE BJ_FILIAL='"+cFILIAL+"' AND BJ_DATA="+cDTULFECH+" AND BJ_COD='"+cPRODUTO+"' "+ENTER 
  cquery +=" AND BJ_LOCAL="+cLOCAL+" AND BJ_QINI <> 0 "+ENTER 
  cquery += " ORDER BY BJ_FILIAL,BJ_COD,BJ_LOCAL,BJ_DATA "+ENTER

  TCQUERY cQuery NEW ALIAS "QRY1"  
  dbSelectArea("QRY1")
  dbGoTop()
 
  While !QRY1->(EOF())   
    aadd(_alotsbJ,{QRY1->BJ_LOTECTL,QRY1->BJ_NUMLOTE})
    QRY1->(DBSKIP())   
  Enddo
  
  
  dbSelectArea("QRY1")
  dbGoTop()

  While !QRY1->(EOF())             
  
  
      IF QRY1->BJ_QINI <> 0
        _clozali :=""
        _cnumser :=""
        _clotebj :=""
        _csubltbj:=""
        nqtde    := 0
        ctipmat  := Posicione("SB1",1,xFilial("SB1")+cPRODUTO,"B1_TIPO")
        ccontend := Posicione("SB1",1,xFilial("SB1")+cPRODUTO,"B1_LOCALIZ") // Controla endereco S=SIM/N=NAO
        crastro  := Posicione("SB1",1,xFilial("SB1")+cPRODUTO,"B1_RASTRO")  // Rastro S=SUBLOTE / L=LOTE
        _alotsb7 :={}        
        _asb7lot :={}           
        _asb7tot :={}
        
        IF crastro $ "SL"
		   _clotebj :=QRY1->BJ_LOTECTL
           _csubltbj:=QRY1->BJ_NUMLOTE
        ENDIF
        IF  ccontend = "S"    
            ApMsgInfo("Endereco nao existe nessa operacao", "Favor verificar !. ")
            Return(.f.)
        ENDIF 
        IF !crastro $ "SL" .or. empty(_clotebj)
            ApMsgInfo("Produto nao controla lote/sublote ou o lote esta em branco", "Favor verificar !. ")
            Return(.f.)
        ENDIF     
     
        //Atualiza SB7 - digitacao do invetario conforme lotes existentes no saldo inicial 
        dbSelectArea("SB7") //B7_FILIAL+B7_DATA+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE     
        IF SB7->(DBSeek(xFilial("SB7")+cDATAINV+cPRODUTO+cLOCAL))
           While !SB7->(EOF()) .AND. SB7->B7_FILIAL=xFilial("SB7") .AND. SB7->B7_COD=cPRODUTO .AND. SB7->B7_LOCAL=cLOCAL 
             IF SB7->B7_DATA=STOD(cDATAINV) .AND. SB7->B7_DOC=cDOCINV .AND. SB7->B7_LOTECTL=_clotebj
                 IF !(ALLTRIM(SB7->B7_LOTECTL)+ALLTRIM(SB7->B7_NUMLOTE)) $ _csubltb7
                    aadd(_alotsb7,{SB7->B7_LOTECTL,SB7->B7_NUMLOTE,SB7->(RECNO())})
                   _csubltb7:=_csubltb7+ALLTRIM(SB7->B7_LOTECTL)+ALLTRIM(SB7->B7_NUMLOTE)+"/"
                 ENDIF
             ENDIF
             IF SB7->B7_DATA=STOD(cDATAINV) .AND. SB7->B7_DOC=cDOCINV 
                    aadd(_asb7lot,{SB7->B7_LOTECTL,SB7->B7_NUMLOTE,SB7->(RECNO())})
             ENDIF
             aadd(_asb7tot,{SB7->B7_LOTECTL,SB7->B7_NUMLOTE,SB7->(RECNO()),SB7->B7_QUANT})
            SB7->(DBSKIP())
           Enddo
   
           IF len(_alotsb7) > 0
              IF aScan(_alotsb7,{|x| x[1]+x[2]<>_clotebj+_csubltbj}) > 0 
                 npossb7:=aScan(_alotsb7,{|x| x[1]+x[2]<>_clotebj+_csubltbj})
                 IF len(_alotsbJ) > 0 .and. aScan(_alotsbj,{|x| x[1]+x[2]==_alotsb7[npossb7,1]+_alotsb7[npossb7,2]}) = 0
                    SB7->(dbgoto(_alotsb7[npossb7,3]))
	                   reclock("SB7",.f.)
			             SB7->B7_NUMLOTE :=_csubltbj
		               msunlock()
                 
                 Else
                   DbSelectArea("SB7") //B7_FILIAL+B7_DATA+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE     
                   IF !SB7->(DBSeek(xFilial("SB7")+cDATAINV+cPRODUTO+cLOCAL+space(15)+space(20)+_clotebj+_csubltbj))
               
               
                    RecLock("SB7",.T.) 
		              SB7->B7_FILIAL  := xFilial("SB7")
	                  SB7->B7_COD     := cPRODUTO
		              SB7->B7_TIPO    := ctipmat
		              SB7->B7_LOCAL   := cLOCAL
		              SB7->B7_DOC     := cDOCINV
		              SB7->B7_QUANT   := nqtde
		              SB7->B7_DATA    := STOD(cDATAINV)
		              SB7->B7_DTVALID := ddatabase
		              SB7->B7_LOTECTL := _clotebj  
		              SB7->B7_NUMLOTE := _csubltbj  
		              SB7->B7_LOCALIZ := _clozali  
		              SB7->B7_CONTAGE := ccontg 
                      SB7->B7_ESCOLHA := cescolh
                      SB7->B7_OK      := cok  
                     SB7->(MSUnLock())
                   ENDIF
                 
                 ENDIF
              ENDIF
           ELSE         
            IF len(_asb7lot) > 0 .and. aScan(_asb7lot,{|x| x[1]+x[2] = _clotebj+_csubltbj}) = 0
               DbSelectArea("SB7") //B7_FILIAL+B7_DATA+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE     
               IF !SB7->(DBSeek(xFilial("SB7")+cDATAINV+cPRODUTO+cLOCAL+space(15)+space(20)+_clotebj+_csubltbj))
            
                  RecLock("SB7",.T.) 
		            SB7->B7_FILIAL  := xFilial("SB7")
	                SB7->B7_COD     := cPRODUTO
		            SB7->B7_TIPO    := ctipmat
		            SB7->B7_LOCAL   := cLOCAL
		            SB7->B7_DOC     := cDOCINV
		            SB7->B7_QUANT   := nqtde
		            SB7->B7_DATA    := STOD(cDATAINV)
		            SB7->B7_DTVALID := ddatabase
		            SB7->B7_LOTECTL := _clotebj  
		            SB7->B7_NUMLOTE := _csubltbj  
		            SB7->B7_LOCALIZ := _clozali  
		            SB7->B7_CONTAGE := ccontg 
                    SB7->B7_ESCOLHA := cescolh
                    SB7->B7_OK      := cok  
                    SB7->(MSUnLock())
               ENDIF
            ENDIF  
           ENDIF                  
        ENDIF
      ENDIF       
   QRY1->(DBSKIP())
  ENDDO                                              
  
  
  dbSelectArea("QRY0")

  
  
  nsalmovd3  :=U_SALDOD3(3,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
  nsalmovd2  :=U_SALDOD2(1,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)          
  nsalmovd1  :=U_SALDOD1(1,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)          
  nsalmovd5  :=U_SALDOD5(4,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
  nsalinvd3  :=U_SALDOD3(4,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
  nmovinvd5  :=U_SALDOD5(5,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
  saldfim    :=0
  adadosD3   :=U_SALDOD3(5,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
  adadosD2   :=U_SALDOD2(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
  adadosD1   :=U_SALDOD1(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
  adadosbj   :=U_SALDOBJ(2,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
  adadosd5   :=U_SALDOD5(6,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
  adinvenD3  :=U_SALDOD3(6,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim)
  adinvenD5  :=U_SALDOD5(7,cFILIAL,cLOCAL,cPRODUTO,cdiniini,cdinifim,"","")          
  lcompmovi  :=.f.
  lcompsini  :=.f.
  lmovsublD3 :=.f.
  lmovsublD5 :=.f.
  lmovsublD2 :=.f.

  
  
  // verifica se o saldo inicial do produto X lote sao iguais         
  If nsaldob9=nsaldobj
     lcompsini:=.t.
  Endif               
         
  // verifica se somente as  movimentacoes normais deixara o saldo igual ao iventariado 
  IF (nsaldob9-((nsalmovd3-nsalmovd2)+nsalmovd1)) = nsalinv
     lcompmovi:=.t.
  Endif
  
  If lcompmovi 
    If len(adinvenD5) > 0         
    
       for xd5:=1 to len(adinvenD5)
          dbSelectArea("SD5") 
          SD5->(dbgoto(adinvenD5[xd5,3])) 
		  reclock("SD5",.f.)
		     SD5->D5_ESTORNO :='S'
		  msunlock()               
       Next  
    Endif
    If len(adinvenD3) > 0     
      for xd3:=1 to len(adinvenD3)
        dbSelectArea("SD3") 
        SD3->(dbgoto(adinvenD3[xd3,6])) 
          reclock("SD3",.f.)
		     SD3->D3_ESTORNO :='S'
		  msunlock()               
      Next
    Endif
  Else
    saldfim  :=nsaldob9-((nsalmovd3-nsalmovd2)+nsalmovd1)
    If len(adinvenD3) > 0
       ndiferen :=saldfim-nsalinv
       for xd3:=1 to len(adinvenD3)
          IF len(_asb7tot) > 0 .and. aScan(_asb7tot,{|x| x[1] = adinvenD3[xd3,4]}) > 0
             nposltb7:=aScan(_asb7tot,{|x| x[1] = adinvenD3[xd3,4]})
             If _asb7tot[nposltb7,2]<>adinvenD3[xd3,5]
                dbSelectArea("SD3") 
                SD3->(dbgoto(adinvenD3[xd3,6])) 
                 reclock("SD3",.f.)
		            SD3->D3_NUMLOTE :=_asb7tot[nposltb7,2]
		       msunlock()                             
		       adinvenD3[xd3,5]:=_asb7tot[nposltb7,2]
		     Endif
		  Endif   
	   Next     
    Endif
    
    
    
    
    If len(adinvenD5) > 0
        ndiferen :=saldfim-nsalinv
       for xd5:=1 to len(adinvenD5)
            IF len(_asb7tot) > 0 .and. aScan(_asb7tot,{|x| x[1] = adinvenD5[xd5,1]}) > 0
                nposltb7:=aScan(_asb7tot,{|x| x[1] = adinvenD5[xd5,1]})
                If _asb7tot[nposltb7,2]<>adinvenD5[xd5,2]
                   dbSelectArea("SD5") 
                   SD5->(dbgoto(adinvenD5[xd5,3])) 
                     reclock("SD5",.f.)
		                SD5->D5_NUMLOTE :=_asb7tot[nposltb7,2]
		             msunlock()
		             adinvenD5[xd5,2]:=_asb7tot[nposltb7,2] 
		        Endif
		    Endif   
		    
		    SD5->(dbgoto(adinvenD5[xd5,3]))
		    nsinibj:=0             
		  
    		If  len(adadosbj) > 0  .and. aScan(adadosbj,{|x| x[1]+x[2] = adinvenD5[xd5,1]+adinvenD5[xd5,2]}) > 0
		      nposltbj := aScan(adadosbj,{|x| x[1]+x[2] = adinvenD5[xd5,1]+adinvenD5[xd5,2]})
		      nsinibj  := adadosbj[nposltbj,4]
		    Endif
		  
		  
		    If (SD5->D5_ORIGLAN < '500'  .and. ndiferen < 0) .or. (SD5->D5_ORIGLAN >= '500'  .and. ndiferen > 0)
		        IF nsinibj=0 
                     reclock("SD5",.f.)
              		     SD5->D5_ESTORNO :='S'
		             msunlock()                
	
		        ELSE   
		           reclock("SD5",.f.)
		               SD5->D5_QUANT :=abs(nsinibj)
		           msunlock()                       
		        ENDIF
		        
		        
		        IF len(adinvenD3) > 0 .and. aScan(adinvenD3,{|x| x[4]+x[5] = adinvenD5[xd5,1]+adinvenD5[xd5,2]}) > 0
		           nposD3:=aScan(adinvenD3,{|x| x[4] = adinvenD5[xd5,1]})
		        
		           If (adinvenD3[nposD3,7] > 0  .and. ndiferen < 0) .or. (adinvenD3[nposD3,8] > 0  .and. ndiferen > 0)
      		         IF nsinibj=0
		                 SD3->(dbgoto(adinvenD3[nposD3,6])) 
                         reclock("SD3",.f.)
		                    SD3->D3_ESTORNO :='S'
		                 msunlock()
		              
		             ELSE 
		                SD3->(dbgoto(adinvenD3[nposD3,6])) 
                         reclock("SD3",.f.)
		                    SD3->D3_QUANT :=abs(nsinibj)
		                 msunlock()
		             ENDIF    
		           Endif
		        Else              
		           aProc := {}   
		           If SD5->D5_ORIGLAN='999'
		               ctm   :='600'
		           Elseif  SD5->D5_ORIGLAN='499'        
		               ctm   :='100'
		           ELSE    
		               ctm   :=SD5->D5_ORIGLAN
		           ENDIF    
		           
		           SB1->(DBSeek(xFilial('SB1')+SD5->D5_PRODUTO)) 
		                                                         
                   AADD(aProc,ctm)
                   AADD(aProc,SD5->D5_PRODUTO)
                   AADD(aProc,SB1->B1_UM)
                   AADD(aProc,abs(nsinibj))
                   AADD(aProc,SD5->D5_OP)
                   AADD(aProc,SD5->D5_LOCAL)
                   AADD(aProc,SD5->D5_DATA)
                   AADD(aProc,SD5->D5_NUMSEQ)         
                   AADD(aProc,SD5->D5_LOTECTL)
                   AADD(aProc,SD5->D5_NUMLOTE)
                   AADD(aProc,SD5->D5_DTVALID)
                   AADD(aProc,"")               
                   AADD(aProc,"")
                   AADD(aProc,nil)          
                   AADD(aProc,0)
                   AADD(aProc,"")
                   AADD(aProc,"")
         
                   lRet := U_BGHOP007(aProc,.t.,"0",.f.)
                   IF !lRet
                      cMsgErr := "falha no processo de inclusao da requisicao!"
                   ENDIF
      	        Endif 
      	         ndiferen:=ndiferen-abs(nsinibj)
      	        
		    Elseif  SD5->D5_ORIGLAN < '500' .and. ndiferen>=0
		        dbSelectArea("SD5") 
                reclock("SD5",.f.)
          		     SD5->D5_ORIGLAN :='999'
          		     SD5->D5_QUANT :=abs(nsinibj)
		        msunlock()                                      
		        
		    Elseif  SD5->D5_ORIGLAN >= '500' .and. ndiferen<=0
		        dbSelectArea("SD5") 
                reclock("SD5",.f.)
          		     SD5->D5_ORIGLAN :='499'
          		     SD5->D5_QUANT :=abs(nsinibj)
		        msunlock()                                           
		    Endif
		    
		    
		    IF len(adinvenD3) > 0 .and. aScan(adinvenD3,{|x| x[4]+x[5] = adinvenD5[xd5,1]+adinvenD5[xd5,2]}) > 0
		           nposD3:=aScan(adinvenD3,{|x| x[4] = adinvenD5[xd5,1]})
		        
		           If  adinvenD3[nposD3,7] > 0  .and. ndiferen >=0 
		               SD3->(dbgoto(adinvenD3[nposD3,6])) 
                         reclock("SD3",.f.)
		                    SD3->D3_TM    :='999'       
		                    SD3->D3_CF    :='RE0'
		                    SD3->D3_QUANT :=abs(nsinibj)
		                 msunlock()
		          
		           Elseif adinvenD3[nposD3,8] > 0  .and. ndiferen <=0
		               SD3->(dbgoto(adinvenD3[nposD3,6])) 
                         reclock("SD3",.f.)
		                    SD3->D3_TM    :='499'       
		                    SD3->D3_CF    :='DE0'
		                    SD3->D3_QUANT :=abs(nsinibj)
		                 msunlock()
		           Endif              
	        Endif
	        
	        
	        
	        ndiferen:=ndiferen-abs(nsinibj)
	        
	   Next     
    Endif
  Endif             
 QRY0->(DBSKIP())
ENDDO
Return


