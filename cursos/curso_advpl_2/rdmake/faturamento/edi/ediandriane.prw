#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "RwMake.ch"



User Function EdiAndriane(nHandle, lSXZ,lUniExp)
	Local cLinha 	:= ""
	Local cCliAnt 	:= ""
	Local cTransp 	:= ""
	Local nValTotal	:= 0
	Local nSeq		:= 0
	Local nCont		:= 0
	Local vIDNOT	:= ""
	Local nSeqAndri:= ""
	Local cArquivo	:=""
	Local nHandle	:= 0 

	u_GerA0003(ProcName())
    If !lUniExp
		cTransp 	:= PADR("ANDREANI",35)
		nSeqAndri:= Val(GetMV("MV_SEQADR"))+1
		cArquivo	:="C:\edi andreani\"+DTOS(dDatabase)+STRZERO(nSeqAndri,2)+".txt"  
		MakeDir("C:\EDI Andreani")
	Else
		cTransp 	:= PADR("UNIEXPRESS",35)
		nSeqAndri:= Val(GetMV("MV_SEQUEXP"))+1
		cArquivo	:="C:\edi uniexpress\"+DTOS(dDatabase)+STRZERO(nSeqAndri,2)+".txt"  
		MakeDir("C:\EDI UniExpress")
	EndIf	
		
	&&ProcRegua(nTotsRec)               
	nSeq	:= nSeq+1
	
	nHandle	:= MsfCreate(cArquivo,0)
	
	&&UNB - CABECALHO DE INTERCAMBIO
	cLinha := "000"	&& 01
	cLinha += PADR(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,35),35)	&& 04
	If !lUniExp 
		cLinha += PADR("ANDREANI",35) && 39 
	Else
		cLinha += PADR("UNIEXPRESS",35) && 39 
	EndIf
	cLinha += substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(DTOS(dDatabase),3,2) &&74
	cLinha += PADR(substr(TIME(),1,2)+substr(TIME(),4,2),4)	&&80
	vIDNOT:= PADR("NOT"+substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(TIME(),1,2)+substr(TIME(),4,2)+STRZERO(nSeq,1),12)	&&84 
	cLinha += vIDNOT
	cLinha += SPACE(145) &&96
	Fwrite(nHandle, cLinha  + CRLF)	
	
	&&UNH CABECALHO DE DOCUMENTO
	cLinha := "310"     && 01
	cLinha += PADR("NOTFI"+substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(TIME(),1,2)+substr(TIME(),4,2)+STRZERO(nSeq,1),14)	&&04
	cLinha += SPACE(223) &&18
	Fwrite(nHandle, cLinha  + CRLF)	
	
	&&DEM - DADOS DA EMBARCADORA 		
	cLinha := "311"	&& 01
	cLinha += PADR(SUBSTR(SM0->M0_CGC,1,14),14) &&04
	cLinha += PADR(SUBSTR(SM0->M0_INSC,1,15),15) &&18
	cLinha += PADR(SUBSTR(SM0->M0_ENDCOB,1,40),40)	&&33
	cLinha += PADR(SUBSTR(SM0->M0_CIDCOB,1,15),35)	&&73
	cLinha += PADR(substr(SM0->M0_CEPCOB,1,5)+"-"+substr(SM0->M0_CEPCOB,6,3),9) && 108
	cLinha += PADR(SUBSTR(SM0->M0_ESTENT,1,2),9) &&117
	cLinha += PADR(SUBSTR(TRB1->F2_DTROMA,7,2)+substr(TRB1->F2_DTROMA,5,2)+substr(TRB1->F2_DTROMA,1,4),8) &&126   && DATA DO ROMANEIO
	cLinha += PADR(SUBSTR(SM0->M0_NOMECOM,1,40),40)	&&134
	cLinha += SPACE(67) &&174
	Fwrite(nHandle, cLinha  + CRLF)	
	
	DbSelectArea("TRB1")
	While !TRB1->(Eof())
	&&	IncProc()       
	
		&&DES - DADOS DO DESTINATARIO DA MERCADORIA
		DbSelectarea("SA1")
		DBSeek(xFilial("SA1")+TRB1->F2_CLIENTE+TRB1->F2_LOJA)
		
		cLinha := "312"	&&001
		cLinha += PADR(SUBSTR(SA1->A1_NOME,1,40),40)	&&004
		cLinha += PADR(SA1->A1_CGC,14) &&044
		cLinha += PADR(SUBSTR(SA1->A1_INSCR,1,15),15) &&058
		cLinha += PADR(SUBSTR(SA1->A1_END,1,40),40)	&&073
		cLinha += PADR(SUBSTR(SA1->A1_BAIRRO,1,20),20)	&&113
		cLinha += PADR(SUBSTR(SA1->A1_MUN,1,35),35)	&&133
		cLinha += PADR(substr(SA1->A1_CEP,1,5)+"-"+substr(SA1->A1_CEP,6,3),9)	&&168
		cLinha += SPACE(09)	&&177
		cLinha += PADR(SUBSTR(SA1->A1_EST ,1,2),9)  && 186
		cLinha += SPACE(04) &&195
		cLinha += PADR(SUBSTR(SA1->A1_DDD+SA1->A1_TEL+space(01)+ A1_FAX,1,35),35)   &&199		
		cLinha += iif(len(SA1->A1_CGC) > 11,"1","2")	&&234
		cLinha += "C"	&&235
		cLinha += SPACE(05) &&236
		
		Fwrite(nHandle, cLinha  + CRLF)		
	
		DbSelectArea("TRB1")
		cCliAnt	:= TRB1->F2_CLIENTE+TRB1->F2_LOJA		
	
		While cCliAnt == TRB1->F2_CLIENTE+TRB1->F2_LOJA .and. TRB1->(!eof())	        
			
			&&DNF - DADOS DA NOTA FISCAL
			cLinha := "313"	&&001
			cLinha += STRZERO(Val(TRB1->F2_NRROMA),15)	&&004
			cLinha += SPACE(07)	&& 019
			cLinha += "1" &&RODOVIARIO	&&026
			cLinha += "1" &&CARGA FECHADA &&027
			cLinha += "1" &&FRIA	&&028
			cLinha += SUBSTR(iif(empty(TRB1->F2_TPFRETE),"C",TRB1->F2_TPFRETE)	,1,1) &&029
			cLinha += PADR(SUBSTR(TRB1->F2_SERIE,1,3),3)	&&030
			cLinha += PADR(SUBSTR(TRB1->F2_DOC,2,8),8)	&&033
			cLinha += PADR(SUBSTR(TRB1->F2_EMISSAO,7,2)+substr(TRB1->F2_EMISSAO,5,2)+substr(TRB1->F2_EMISSAO,1,4),8)   &&041
			cLinha += PADR(SUBSTR("ELETRONICOS",1,15),15)	&&049
			cLinha += PADR(SUBSTR("CAIXAS",1,15),15)	&&064
			cLinha += STRZERO(0,7)         &&079	(x 100 para considerar decimais)
			cLinha += STRZERO(TRB1->F2_VALBRUT*100,15)	&&086 *********************Transform(SZA->ZA_PRECO,'@E 999,999.99999')
			cLinha += STRZERO(1*100,7)	&&101	(x 100 para considerar decimais)
			cLinha += STRZERO(1*100,5)	&&108   (x 100 para considerar decimais)
	
			cLinha += iif(TRB1->F2_VALICM >0,"S","N")	&&113
			cLinha += "N"	&&114
	
			cLinha += STRZERO(0*100,15)	&&115	(x 100 para considerar decimais)
			cLinha += STRZERO(0*100,15)	&&130   (x 100 para considerar decimais)
			cLinha += SPACE(07)	&&145
			cLinha += SPACE(01)	&&152
			cLinha += STRZERO(0*100,15)	&& 153   (x 100 para considerar decimais)
	
			cLinha += STRZERO(0*100,15)	&&168  (x 100 para considerar decimais)
			cLinha += STRZERO(0*100,15)	&&183  (x 100 para considerar decimais)
			cLinha += STRZERO(0*100,15) &&198 (x 100 para considerar decimais)
			cLinha += "I" &&213      INCLUSAO VERFICAR
	
			cLinha += STRZERO(TRB1->F2_VALICM*100 ,12)	&&214  (x 100 para considerar decimais)
			cLinha += STRZERO(TRB1->F2_ICMSRET*100,12)  &&226 (x 100 para considerar decimais)
			cLinha += "N"	&&238
			cLinha += "01" &&239  VERIFICAR
		
			Fwrite(nHandle, cLinha  + CRLF)
			nValTotal 	:= nValTotal + TRB1->F2_VALBRUT
			nCont 		:= nCont + 1
	
			&&³Grava Dados na Tabela EDI - SZX ³
			If !lSXZ
				GravSZX(cTransp, vIDNOT)	
			EndIf
			
			TRB1->(DbSkip())  
	    Enddo	    
	EndDo 
	
	&&TOT - VALORES TOTAIS DOS DOCUMENTOS
	cLinha := "318" 	&&001
	cLinha += STRZERO(nValTotal*100 ,15)	&&004
	cLinha += STRZERO(0*100		      ,15)	&&019
	cLinha += STRZERO(0*100          ,15)	&&034
	cLinha += STRZERO(nCont*100     ,15)	&&049
	cLinha += STRZERO(0*100          ,15)	&&064
	cLinha += STRZERO(0*100          ,15)	&&079
	cLinha += SPACE(147) 	&&094 

	Fwrite(nHandle, cLinha  + CRLF) 
	fClose(nHandle) 

	MsgAlert("Processo Concluido. Gerado Arquivo: " + cArquivo )
    
    If !lUniExp 
		PutMv("MV_SEQADR",STRZERO(nSeqAndri,1))	 
	Else
		PutMv("MV_SEQUEXP",STRZERO(nSeqAndri,1))	 
	EndIf
Return  

Static Function GravSZX(cTransp, vIDNOT)
   	Begin Transaction 
		RecLock("SZX",.T.)
		SZX->ZX_FILIAL		:=	xfilial("SZX")
		SZX->ZX_SERIE 		:=	PADR(SUBSTR(TRB1->F2_SERIE,1,3),3)
		SZX->ZX_NOTA  		:= 	PADR(SUBSTR(TRB1->F2_DOC,2,8),8)
		SZX->ZX_CLIDEST		:=	TRB1->F2_CLIENTE+TRB1->F2_LOJA
		SZX->ZX_IDDEST		:= 	cTransp
		SZX->ZX_IDINTER		:=	vIDNOT
		SZX->ZX_DTROMA		:=  stod(TRB1->F2_DTROMA)
		SZX->ZX_ROMAN 		:=	TRB1->F2_NRROMA
		SZX->ZX_DTNOTA		:=	stod(TRB1->F2_EMISSAO)
		SZX->ZX_VOLUME		:=	1	
		SZX->ZX_TOTALNF		:=	TRB1->F2_VALBRUT
		SZX->ZX_STATUS		:=	"1"			&& 1 - EDI Gerado, ainda sem Retorno 
  		MSUnlock()
	End Transaction 
Return 