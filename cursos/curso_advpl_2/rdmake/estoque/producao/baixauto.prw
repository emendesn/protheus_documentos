#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

#define ENTER CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BaixAuto	ºAutor  ³Edson Rodrigues       º Data ³  28/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa Baixa Automatica de Peças                            º±±
±±º          ³ Refurbish para aparelhos que encerraram como SCRAP           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                     

User Function baixAuto(PARAMIXB)

Local cEmp := ""
Local cFil := ""
Local _nopc := 0

DEFAULT PARAMIXB := {'02','02',1}

If len(PARAMIXB) > 0 
	cEmp := PARAMIXB[1]
	cFil := PARAMIXB[2]         
	_nopc := PARAMIXB[3] // Criado esse parametro para o Sistema não ficar sempre buscando os partnumbers antigos para os quais nunca tem saldo para atender e acaba demandando muito tempo de processamento.
Endif

PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES "ZZ4" 


Private cDocumento	:= Space(6)
Private	lRet		:= .T.
Private cLocaliz 	:= ""  
Private cMensagem 	:= ""
Private cTitemail   := ""
Private cQry
Private aItens 		:= {}
Private _aRecnoSZ9 	:= {}
Private	_center   	:= Chr(13)+Chr(10)
Private Path        := "172.16.0.7"
Private _cTm        := "502"
Private ctmsretr    := "508"
Private _abaixret   := {} 
Private _abaixscr   := {}                   
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

u_GerA0003(ProcName())

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf


cQry	:=	"SELECT  ZZ4_FILIAL,ZZ4_NFSNR,ZZ4_NFSDT,ZZ4_NFSTES,ZZ4_ASCRAP,ZZ3_ENCOS,ZZ3_STATUS,ZZ3_ESTORN,ZZ3_LAB, "
cQry	+=	" ZZ3_CODSET,ZZ3_FASE1,ZZ3_CODSE2,ZZ3_FASE2,ZZ4_FASATU,ZZ4_SETATU,ZZ3.ZZ1_SCRAP AS SCRAPZZ3,ZZ1_2.ZZ1_SCRAP AS SCRAPZZ4, "
cQry	+=	" Z9_STATUS,Z9_SYSORIG,Z9_NUMSEQS,Z9_NUMSEQR,Z9_NUMSEQD, "
cQry	+=	" Z9_PARTNR AS PECA, "
cQry	+=	" ZZ4_IMEI AS IMEI, "
cQry	+=	" ZZ4_OS AS NUMOS, "
cQry	+=	" ZZJ_ALMEP AS ALMEP, "
cQry	+=	" ZZJ_ENDFAT AS ENDFAT, "                                                
cQry	+=	" ZZJ_ARMPR AS ALMRET, "
cQry	+=	" QTDPN AS QTDZ9, "                                                                 
cQry	+=  " RECZ9 AS RECNOZ9 "
cQry	+=	" FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock) "
cQry	+=	" INNER JOIN "
cQry	+=  " ( SELECT ZZJ_FILIAL,ZZJ_OPERA,ZZJ_ALMEP,ZZJ_ENDFAT,ZZJ_GPVPEC,ZZJ_ARMPR  FROM "+RetSqlName("ZZJ")+"  WHERE D_E_L_E_T_='' AND ZZJ_GPVPEC='S' ) AS ZZJ  "
cQry	+=	" ON	ZZJ_FILIAL = '"+xFilial("ZZJ")+"' AND " 
cQry	+=	"	ZZJ_OPERA=ZZ4_OPEBGH AND "
cQry	+=	"	ZZJ_ALMEP  <> '' AND "
cQry	+=	"	ZZJ_ENDFAT <> '' "
cQry	+=	" INNER JOIN "
cQry	+=	" (SELECT Z9_FILIAL,Z9_NUMOS,Z9_IMEI,Z9_PARTNR,Z9_STATUS,Z9_SYSORIG, "
cQry	+=	"         Z9_NUMSEQS,Z9_NUMSEQR,Z9_NUMSEQD,SUM(Z9_QTY) AS QTDPN,R_E_C_N_O_ AS RECZ9  "
cQry	+=	"         FROM "+RetSqlName("SZ9")+"  (NOLOCK) " 
cQry	+=	"  WHERE Z9_FILIAL='"+xFilial("SZ9")+"' AND  D_E_L_E_T_='' AND Z9_SYSORIG IN ('1','2') AND  (Z9_PEDPECA='' OR Z9_PEDPECA='ANAED2' )   " 
cQry	+=	"        AND Z9_NUMSEQS='' AND Z9_NUMSEQR='' AND Z9_NUMSEQD='' AND Z9_PARTNR<>'' AND Z9_STATUS='1' "
cQry	+=	"  GROUP BY Z9_FILIAL,Z9_NUMOS,Z9_IMEI,Z9_PARTNR,Z9_STATUS,Z9_SYSORIG,Z9_NUMSEQS,Z9_NUMSEQR,Z9_NUMSEQD,R_E_C_N_O_ 
cQry	+=	"  ) AS Z9 
cQry	+=	"  ON Z9.Z9_FILIAL=ZZ4.ZZ4_FILIAL AND Z9.Z9_NUMOS=ZZ4.ZZ4_OS AND Z9.Z9_IMEI=ZZ4.ZZ4_IMEI 
cQry	+=	" INNER JOIN "                                         
cQry	+=	"    ( SELECT ZZ3_FILIAL,ZZ3_NUMOS,ZZ3_IMEI,ZZ3_ENCOS,ZZ3_STATUS,ZZ3_ESTORN,ZZ3_LAB,
cQry	+=	"        ZZ3_CODSET,ZZ3_FASE1,ZZ1_SCRAP,ZZ3_CODSE2,ZZ3_FASE2 
cQry	+=	"        FROM   "+RetSqlName("ZZ3")+" ZZ3A (nolock)
cQry	+=	"        INNER JOIN
cQry	+=	"           (SELECT * FROM "+RetSqlName("ZZ1")+" (nolock) WHERE ZZ1_FILIAL='"+xFilial("ZZ1")+"' AND D_E_L_E_T_='') AS ZZ1
cQry	+=	"        ON ZZ3_LAB=ZZ1_LAB AND ZZ3_CODSET=ZZ1_CODSET AND ZZ3_FASE1=ZZ1_FASE1 
cQry	+=	"     WHERE ZZ3A.ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND ZZ3A.D_E_L_E_T_='' AND ZZ3_STATUS='1' AND ZZ3_ESTORN<>'S' AND ZZ3_ENCOS='S' ) AS ZZ3
cQry	+=	" ON ZZ4_FILIAL=ZZ3_FILIAL AND ZZ4_OS=ZZ3_NUMOS AND ZZ4_IMEI=ZZ3_IMEI
cQry	+=	" INNER JOIN 
cQry	+=	"        (SELECT * FROM "+RetSqlName("ZZ1")+" (nolock) WHERE ZZ1_FILIAL='"+xFilial("ZZ1")+"' AND D_E_L_E_T_='') AS ZZ1_2
cQry	+=	"  ON ZZ1_2.ZZ1_LAB='2' AND ZZ1_2.ZZ1_CODSET=ZZ4_SETATU AND ZZ1_2.ZZ1_FASE1=ZZ4_FASATU 
//cQry	+=	" INNER JOIN 
//cQry	+=	"        (SELECT OS FROM OSPECADUP)  OSP
//cQry	+=	" ON ZZ4_FILIAL='06' AND RTRIM(ZZ4_OS)=OSP.OS
//cQry	+=	"  INNER JOIN ( SELECT B1_COD,B1_RETRABA FROM SB1020 WHERE D_E_L_E_T_='' AND B1_RETRABA <>'S' ) AS B1 "
//cQry	+=	" ON B1_COD=Z9_PARTNR    "
cQry	+=	" WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND "
cQry	+=	"	ZZ4_NFSDT  >= '20140401' AND "
cQry	+=	"	ZZ4_STATUS  = '9' AND "
cQry	+=	"	ZZ4.D_E_L_E_T_='' AND "
cQry	+=	"	ZZJ_GPVPEC='S' AND  "    
IF _nopc = 1 
    cQry	+=	"	ZZ4_NFSDT>='20141101'  AND  "    
Elseif _nopc = 2
    cQry	+=	"	ZZ4_NFSDT >='20141001'  AND ZZ4_NFSDT < '20141101'  AND  "    
Elseif _nopc = 3
    cQry	+=	"	ZZ4_NFSDT >='20140901'  AND ZZ4_NFSDT < '20141001'  AND  "    
Endif    
//cQry	+=	"   ZZ4_NFSERV>='000483'  AND ZZ4_NFSERV<='000600'
cQry	+=	" (ZZ3.ZZ1_SCRAP='S' OR ZZ1_2.ZZ1_SCRAP='S') "
//cQry	+=	" ZZ4_PVPECA='ANALED' "
cQry	+=	" ORDER BY ZZ4_NFSDT,ZZ4_FILIAL,ZZ4_OS,ZZ4_IMEI,ZZ4_NFSNR,ZZ4_NFSTES "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

QRY->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Grava dados no Array                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QRY")
dbGoTop()


DO WHILE !QRY->(EOF())  
	
	//Pocisiona Produto
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + Left(QRY->PECA,15)))
	
	cLocaliz  :=  SB1->B1_LOCALIZ 
    _cyesret  :=  SB1->B1_RETRABA 
	
	dbselectarea("SB2")
	SB2->(DBSeek(xFilial('SB2') + Left(QRY->PECA,15) + IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP )))
	
	_nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)      
	_salapon:=salapont(IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP ),Left(QRY->PECA,15))                       
	_nSalb2:=_nSalb2-_salapon
    
     dbselectarea("SBF")
	 SBF->(dbsetorder(1))
	 SBF->(DbSeek(XFilial("SBF") + IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP ) + QRY->ENDFAT + QRY->PECA )) 
	
	_nSalBF := SaldoSBF(IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP ), QRY->ENDFAT, Left(QRY->PECA,15), NIL, NIL, NIL, .F.)
	_nSalBF :=_nSalBF-_salapon
	
	
	DbSelectarea("SB2")
	DbSetOrder(1)
	If !DbSeek(xFilial("SB2")+Left(QRY->PECA,15) + IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP ),.F.)
		CriaSb2(Left(QRY->PECA,15),IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP ))
	Endif	
	
	_nPos := aScan(aItens, { |X| X[2] == Left(QRY->PECA,15)})
	
	If _nPos == 0
		If _nSalb2 >= QRY->QTDZ9 .and. _nSalBF >= QRY->QTDZ9
           aadd(aItens,{IIF(_cyesret="S",ctmsretr,_ctm),Left(QRY->PECA,15),IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP ),QRY->QTDZ9, QRY->ENDFAT,IIF(_cyesret="S","R","S"),0,"S"})      
  		   Aadd(_aRecnoSZ9,{ QRY->RECNOZ9, Left(QRY->PECA,15) })// Recno do item na tabela SZ9
		Else
			If Empty(cMensagem)
			 	cTitemail:="Itens com problema de Saldo" 
			 	cMensagem := "Itens com problema de saldo : "+DTOC(date())+" - "+time()+" hrs."+ _center
       		Endif
		     cMensagem += "OS           : " + AllTrim(QRY->NUMOS)+ _center
		     cMensagem += "Peça         : " + AllTrim(QRY->PECA)+ _center
		     cMensagem += "Qtde         : " + STRZERO(QRY->QTDZ9,3)+ _center
		     cMensagem += "Armz Origem  : " + Alltrim(IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP ))+ _center
		     cMensagem += "End Origem   : " + Alltrim(QRY->ENDFAT)+ _center
		    if _nSalb2 < QRY->QTDZ9
              If _nSalb2  > 0 
                  cMensagem += "Saldo do SB2 menor que a quantidade apontada" + _center		    
              Else
                  cMensagem += "Nao ha saldo no SB2 - Saldo negativo ou Zero" + _center		                      
              Endif
            Elseif  _nSalBF < QRY->QTDZ9
              IF _nSalBF > 0
                  cMensagem += "Saldo do SBF menor que a quantidade apontada" + _center		    
              ELSE
                  cMensagem += "Nao ha saldo no SBF - Saldo negativo ou Zero" + _center		                    
              Endif   
            Endif 
              
		      cMensagem += "---------------------------------------   " + _center 
		Endif
		
		
	Else
		If _nSalb2 >= QRY->QTDZ9+aItens[_nPos,4]  .and. _nSalBF >= QRY->QTDZ9+aItens[_nPos,4] 
			aItens[_nPos,4] += QRY->QTDZ9
			Aadd(_aRecnoSZ9,{ QRY->RECNOZ9, Left(QRY->PECA,15)})// Recno do item na tabela SZ9
		Else
			If Empty(cMensagem)
			   	cTitemail:="Itens com problema de Saldo" 
			    cMensagem := "Itens com problema de saldo : "+DTOC(date())+" - "+time()+" hrs."+ _center
       		Endif
		       cMensagem += "OS           : " + AllTrim(QRY->NUMOS)+ _center
		       cMensagem += "Peça         : " + AllTrim(QRY->PECA)+ _center
		       cMensagem += "Qtde         : " + STRZERO(QRY->QTDZ9,3)+ _center
		       cMensagem += "Armz Origem  : " + Alltrim(IIF(_cyesret="S",QRY->ALMRET,QRY->ALMEP ))+ _center
		       cMensagem += "End Origem   : " + Alltrim(QRY->ENDFAT)+ _center
	  	    if _nSalb2 < QRY->QTDZ9+aItens[_nPos,4]
              If _nSalb2  > 0 
                 cMensagem += "Saldo do SB2 menor que a quantidade apontada" + _center		    
              Else
                 cMensagem += "Nao ha saldo no SB2 - Saldo negativo ou Zero" + _center		                      
              Endif
            Elseif  _nSalBF < QRY->QTDZ9+aItens[_nPos,4] 
              IF _nSalBF > 0
                 cMensagem += "Saldo do SBF menor que a quantidade apontada" + _center		    
              ELSE
                 cMensagem += "Nao ha saldo no SBF - Saldo negativo ou Zero" + _center		                    
              Endif   
            Endif 
    
		    
		      cMensagem += "---------------------------------------   " + _center 
		Endif
	Endif
	
	dbSelectArea("QRY")
	
	QRY->(dbSkip())
	
EndDo

If Len(aItens) >0        
  For x:=1 to len(aItens)
    IF aItens[x,6]="R"
       aadd(_abaixret,{aItens[x,1],aItens[x,2],aItens[x,3],aItens[x,4],aItens[x,5],aItens[x,6],aItens[x,7],aItens[x,8]}) 
    Else   
       aadd(_abaixscr,{aItens[x,1],aItens[x,2],aItens[x,3],aItens[x,4],aItens[x,5],aItens[x,6],aItens[x,7],aItens[x,8]}) 
    Endif
   Next
Endif
	//-- Inicializa o numero do Documento com o ultimo + 1

IF len(_abaixret) > 0 
	dbSelectArea("SD3")
	nSavReg     := RecNo()
	cDocumento	:= IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)
	cDocumento	:= A261RetINV(cDocumento)
	aMovSD3     :={}
	dbSetOrder(2)
	dbSeek(xFilial()+cDocumento)
	cMay := "SD3"+Alltrim(xFilial())+cDocumento
	While D3_FILIAL+D3_DOC==xFilial()+cDocumento.Or.!MayIUseCode(cMay)
		If D3_ESTORNO # "S"
			cDocumento := Soma1(cDocumento)
			cMay := "SD3"+Alltrim(xFilial())+cDocumento
		EndIf
		SD3->(dbSkip())
	EndDo                     
	
	
    aCab := {;
              {"D3_DOC"		,cDocumento			,NIL},;
              {"D3_TM"		,ctmsretr     		,NIL},;
              {"D3_EMISSAO"	,dDataBase		,Nil}}

    For i:=1 To Len(_abaixret)
           SB1->(DBSeek(xFilial('SB1')+_abaixret[i,2]))
           _clocal   := _abaixret[i,3]
           SB2->(DBSeek(xFilial('SB2') + SB1->B1_COD + _clocal))
      	   _salapon  := salapont(_clocal,SB1->B1_COD)                       
      	   _nSalb2   := 0
           _nSalb2   := SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
           _nSalb2   :=_nSalb2 -_salapon
           _nSaldoBF := 0 
           _nSaldoBF := SaldoSBF(_clocal,_abaixret[i,5], SB1->B1_COD, NIL, NIL, NIL, .F.)
           _nSaldoBF := _nSaldoBF - _salapon
           
           IF _nSalb2 >=  _abaixret[i,4] .and. _nSaldoBF >= _abaixret[i,4]
              _abaixret[i,8]:="S"
              _abaixret[i,7]:=_abaixret[i,4]
  	
         	
       	       aadd(aMovSD3,{{"D3_COD"  		,_abaixret[i,2],NIL},;
	                         {"D3_LOCAL"		,_abaixret[i,3],NIL},;
	                         {"D3_QUANT"		,_abaixret[i,4],NIL},;
                             {"D3_LOCALIZ"	,_abaixret[i,5],NIL}})
           ELSE
               _abaixret[i,8]:="N"
                _abaixret[i,7]:=_nSaldoBF
        
               IF _nSaldoBF > 0
                    	aadd(aMovSD3,{{"D3_COD"		,_abaixret[i,2],NIL},;
	                      {"D3_LOCAL"	,_abaixret[i,3],NIL},;
	                      {"D3_QUANT"	,_nSaldoBF,NIL},;
	                      {"D3_LOCALIZ"	,_abaixret[i,5],NIL}})
               ENDIF
           ENDIF
    Next i

    If Len(aMovSD3) > 0 	
	     MSExecAuto({|x,y| MATA241(x,y)},aCab,aMovSD3)
	     If lMsErroAuto
     		 cTitemail:="Erro na Baixa Scrap Refurbish" 
	    	 cMensagem := "Favor verificar! Erro na Baixa Scrap Refurbish  : "+DTOC(date())+" - "+time()+" hrs."+ _center

	     Else
           	For i := 1 To Len(_aRecnoSZ9)
		      	dbSelectArea("SZ9")
			        SZ9->(dbGoto(_aRecnoSZ9[i,1]))
			        
			        _nPos     := aScan(aMovSD3, { |X| X[1,2] == _aRecnoSZ9[i,2]})
			        _nqtbaix  := IIf(_nPos > 0,aMovSD3[_nPos,3,2],0)
			        
			        
			        IF _nqtbaix > 0
	                       IF  EMPTY(SZ9->Z9_NUMSEQS) .AND. EMPTY(SZ9->Z9_NUMSEQR) .AND. EMPTY(SZ9->Z9_NUMSEQD) .AND. EMPTY(SZ9->Z9_PEDPECA)
			        
             			        RecLock("SZ9",.F.)
                         			SZ9->Z9_NUMSEQR :=  cDocumento
		    	                MsUnLock()
		    	                aMovSD3[_nPos,3,2]:=aMovSD3[_nPos,3,2]-1
			               ENDIF
			        ENDIF
			        
			Next i	
            
         Endif   
            
	Else
		 cTitemail:="Baixa para Scrap Refurbish nao Efetuada" 
		 cMensagem := "Favor verificar! Baixa para Scrap Refurbish não efetuada  : "+DTOC(date())+" - "+time()+" hrs."+ _center
	Endif
Else
  cTitemail:="Baixa para Scrap Refurbish nao Efetuada" 
Endif


IF len(_abaixscr)> 0
	dbSelectArea("SD3")
	nSavReg     := RecNo()
	cDocumento	:= IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)
	cDocumento	:= A261RetINV(cDocumento)
	aMovSD3     :={}
	dbSetOrder(2)
	dbSeek(xFilial()+cDocumento)
	cMay := "SD3"+Alltrim(xFilial())+cDocumento
	While D3_FILIAL+D3_DOC==xFilial()+cDocumento.Or.!MayIUseCode(cMay)
		If D3_ESTORNO # "S"
			cDocumento := Soma1(cDocumento)
			cMay := "SD3"+Alltrim(xFilial())+cDocumento
		EndIf
		SD3->(dbSkip())
	EndDo                     
	
	
    aCab := {;
              {"D3_DOC"		,cDocumento			,NIL},;
              {"D3_TM"		,_ctm     		,NIL},;
              {"D3_EMISSAO"	,dDataBase		,Nil}}

    For i:=1 To Len(_abaixscr)
           SB1->(DBSeek(xFilial('SB1')+_abaixscr[i,2]))
           _clocal   := _abaixscr[i,3]
           SB2->(DBSeek(xFilial('SB2') + SB1->B1_COD + _clocal))
   	       _salapon  := salapont(_clocal,SB1->B1_COD)                       
      	   _nSalb2   := 0
           _nSalb2   := SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
           _nSalb2   :=_nSalb2 -_salapon
           _nSaldoBF := 0 
           _nSaldoBF := SaldoSBF(_clocal,_abaixscr[i,5], SB1->B1_COD, NIL, NIL, NIL, .F.)
           _nSaldoBF := _nSaldoBF - _salapon

           IF _nSalb2 >=  _abaixscr[i,4] .and. _nSaldoBF >= _abaixscr[i,4]
             _abaixscr[i,8]:="S"
             _abaixscr[i,7]:=_abaixscr[i,4]
  	
         	
       	       aadd(aMovSD3,{{"D3_COD"		,_abaixscr[i,2],NIL},;
	                         {"D3_LOCAL"		,_abaixscr[i,3],NIL},;
	                         {"D3_QUANT"		,_abaixscr[i,4],NIL},;
                             {"D3_LOCALIZ"	,_abaixscr[i,5],NIL}})
           ELSE
               _abaixscr[i,8]:="N"
               _abaixscr[i,7]:=_nSaldoBF
        
               IF _nSaldoBF > 0
                    	aadd(aMovSD3,{{"D3_COD"		,_abaixscr[i,2],NIL},;
	                      {"D3_LOCAL"	,_abaixscr[i,3],NIL},;
	                      {"D3_QUANT"	,_nSaldoBF,NIL},;
	                      {"D3_LOCALIZ"	,_abaixscr[i,5],NIL}})
               ENDIF
           ENDIF
    Next i

    If Len(aMovSD3) > 0 	
	     MSExecAuto({|x,y| MATA241(x,y)},aCab,aMovSD3)
	     If lMsErroAuto
     	  	cTitemail:="Erro na Baixa Scrap Refurbish" 
	     	cMensagem := "Favor verificar! Erro na Baixa Scrap Refurbish  : "+DTOC(date())+" - "+time()+" hrs."+ _center

	     Else
           	For i := 1 To Len(_aRecnoSZ9)
		      	dbSelectArea("SZ9")
			        SZ9->(dbGoto(_aRecnoSZ9[i,1]))
			        
			        _nPos     := aScan(aMovSD3, { |X| X[1,2] == _aRecnoSZ9[i,2]})
			         _nqtbaix  := IIf(_nPos > 0,aMovSD3[_nPos,3,2],0)
			        
			        
			        IF _nqtbaix > 0
			              IF  EMPTY(SZ9->Z9_NUMSEQS) .AND. EMPTY(SZ9->Z9_NUMSEQR) .AND. EMPTY(SZ9->Z9_NUMSEQD) .AND. EMPTY(SZ9->Z9_PEDPECA)
			        
             			        RecLock("SZ9",.F.)
                         			SZ9->Z9_NUMSEQS :=  cDocumento
		    	                MsUnLock()
		    	                aMovSD3[_nPos,3,2]:=aMovSD3[_nPos,3,2]-1
			               ENDIF
			        ENDIF
			        
			Next i	
            
         Endif   
            
	Else
		 cTitemail:="Baixa para Scrap Refurbish nao Efetuada" 
		 cMensagem := "Favor verificar! Baixa para Scrap Refurbish não efetuada  : "+DTOC(date())+" - "+time()+" hrs."+ _center
	Endif
Else
  cTitemail:="Baixa para Scrap Refurbish nao Efetuada" 
Endif
                                                                             

If !empty(cMensagem)
	 U_ENVIAEMAIL(cTitemail,"baixascrap.refurbished@bgh.com.br","",cMensagem,Path)
Endif

QRY->(dbCloseArea())

Return



static function salapont(clocal,cpartnr)                       

nsalapont:=0.00

                 
cQry	:=	" SELECT B2_COD,B2_LOCAL,B2_QATU, "
cQry	+=	" (SELECT ISNULL(COUNT(Z9_NUMOS),0) AS QTDE FROM "+RetSqlName("SZ9")+" Z9 (NOLOCK)  "
cQry	+=	"  INNER JOIN ( SELECT ZZ4_FILIAL,ZZ4_OS,ZZ4_IMEI,ZZ4_STATUS,ZZ4_OPEBGH,ZZ4_PVPECA,ZZ4_CODPRO FROM "+RetSqlName("ZZ4")+" A (NOLOCK) "
// cQry	+=	"              INNER JOIN ( SELECT ZZ3_FILIAL,ZZ3_NUMOS,ZZ3_IMEI,ZZ3_ENCOS,ZZ3_STATUS, "
// cQry	+=	"                           ZZ3_ESTORN,ZZ3_LAB,ZZ3_CODSET,ZZ3_FASE1,ZZ1_SCRAP,ZZ3_CODSE2,ZZ3_FASE2 "
// cQry	+=	"                           FROM  "
// cQry	+=	"                           "+RetSqlName("ZZ3")+" ZZ3A (nolock) "
// cQry	+=	"                           INNER JOIN "
// cQry	+=	"                              (SELECT * FROM "+RetSqlName("ZZ1")+" (nolock) WHERE D_E_L_E_T_='' ) AS ZZ1 "
// cQry	+=	"                           ON ZZ3_LAB=ZZ1_LAB AND ZZ3_CODSET=ZZ1_CODSET AND ZZ3_FASE1=ZZ1_FASE1 "
// cQry	+=	"                          WHERE ZZ3A.D_E_L_E_T_='' AND ZZ3_STATUS='1' "
// cQry	+=	"                          AND ZZ3_ESTORN<>'S' AND ZZ3_ENCOS='S' ) AS ZZ3 "
// cQry	+=	"               ON ZZ4_FILIAL=ZZ3_FILIAL AND ZZ4_OS=ZZ3_NUMOS AND ZZ4_IMEI=ZZ3_IMEI "
cQry	+=	"               INNER JOIN "
cQry	+=	"              (SELECT * FROM "+RetSqlName("ZZ1")+" (nolock) WHERE D_E_L_E_T_='') AS ZZ1_2 "
cQry	+=	"               ON ZZ1_2.ZZ1_LAB='2' AND ZZ1_2.ZZ1_CODSET=ZZ4_SETATU AND ZZ1_2.ZZ1_FASE1=ZZ4_FASATU "
cQry	+=	"               WHERE A.D_E_L_E_T_='' AND ZZ4_STATUS>='3' AND ZZ4_STATUS<='8' 
// cQry	+=	"  AND (ZZ3.ZZ1_SCRAP<>'S' 
cQry	+=	" AND ZZ1_2.ZZ1_SCRAP<>'S' "
cQry	+=	"             ) ZZ4 "
cQry	+=	"  ON ZZ4_FILIAL=Z9_FILIAL AND ZZ4_OS=Z9_NUMOS AND ZZ4_IMEI=Z9_IMEI "
cQry	+=	" WHERE Z9.Z9_FILIAL=B2_FILIAL AND Z9.D_E_L_E_T_='' AND "
cQry	+=	"       Z9_SYSORIG IN ('1','2') AND Z9_STATUS='1' "
cQry	+=	"       AND Z9_PARTNR=B2_COD) AS QTDE_APONT "
cQry	+=	" FROM "+RetSqlName("SB2")+" "
cQry	+=	"WHERE B2_FILIAL='"+xFilial("SB2")+"' AND B2_LOCAL='"+clocal+"' AND B2_COD='"+cpartnr+"' "


// dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRYAPONT", .F., .T.)
TCQUERY cQry NEW ALIAS "QRYAPONT"

QRYAPONT->(dbGoTop())

DO WHILE !QRYAPONT->(EOF())  

   nsalapont += QRYAPONT->QTDE_APONT

   QRYAPONT->(dbskip())
EndDo                     

QRYAPONT->(dbCloseArea())

return(nsalapont)
