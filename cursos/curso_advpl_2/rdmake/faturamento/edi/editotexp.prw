#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "RwMake.ch"
#DEFINE DEFAULT_FTP 21  

User Function EdiTotExp(lSXZ)
	Local cLinha  		:= ''
	Local cCliAnt  		:= ''
	Local cLoja  		:= ''
	Local cTransp 		:= PADR("TOTALEXPRESS",35)
	Local cPVirg		:= ";"
	Local lIsIcms		:= .F.
	Local lRet			:= .T.
	Local lVldEdi		:= .T.
	Local nSeqTotExp 	:= Val(GetMV("MV_SEQTEXP"))+1 
	Local cDirOrig		:= "web\FtpTotalExpress\enviados"
	Local cDirDest		:= "envios" 
	Local cNomArq		:= DTOS(dDatabase)+STRZERO(nSeqTotExp,2)+".csv"   
	Local cArquivo		:= cDirOrig+"\"+cNomArq
	Local nHandle		:= 0  
	Local nSeq			:= 0
	Local aAreaSF2		:= SF2->(GetArea())
	Local aAreaSC6		:= SC6->(GetArea())
	Local aAreaSA1		:= SA1->(GetArea())
	Local oArqFtp
	Local aFiles		:= {}
	Private cProdPred 	:= ''
	Private cCfopPred 	:= '' 
	Private cMsg 		:= '' 
	Private cDirEdi 	:= "C:\EDI_TotalExpress"
	Private cCrLf		:= Chr(13)+Chr(10)

u_GerA0003(ProcName())	

	SA1->(DbSelectArea("SA1"))		
	SA1->(DbSetOrder(1))
	
	DbSelectArea("TRB1")
    
	&&Valida aquivo do EDI
    lVldEdi := ValEdiTE()
                          
	If lVldEdi
		nHandle		:= MsfCreate(cArquivo,0)
		
	    TRB1->(DbGotop())
		Do While TRB1->(!EoF()) 
			    
			cCliAnt	:= TRB1->F2_CLIENTE
			cLoja	:= TRB1->F2_LOJA
	  		cTransp := TRB1->F2_TRANSP
		
			ProdPredom( TRB1->F2_DOC, TRB1->F2_SERIE, cCliAnt, cLoja)
			
			dbSelectArea("SC6")    
			SC6->(DbSetOrder(4))
			SC6->(DbSeek(xFilial("SC6")+TRB1->F2_DOC+TRB1->F2_SERIE))
				
			cLinha := "TOTAL20"					   		   				&&01 - *Layout - Fixo TOTAL20
			cLinha += cPVirg + PADR(SubStr(SM0->M0_CGC,1,14),14) 		&&02 - *CNPJ do Remetente da Mercadoria 	        
			cLinha += cPVirg + StrZero(Val(TRB1->F2_NRROMA),20)  		&&03 - C�digo da Remessa da Mercaria
			cLinha += cPVirg + '1' 										&&04 - *Servi�o Contratado
			cLinha += cPVirg + '0' 										&&05 - *Tipo de Entrega
			cLinha += cPVirg + PADL(Transform(TRB1->F2_PBRUTO, '@E 999.99'),06) &&06 - Peso
			cLinha += cPVirg + StrZero(TRB1->F2_VOLUME1,2) 		   		&&07 - *Volumes
			cLinha += cPVirg + 'CIF'  									&&08 - *Condi��o de Frete
			cLinha += cPVirg + PADR(SC6->C6_NUM,20) 					&&09 - *C�digo do Pedido
			cLinha += cPVirg + StrZero(Val(TRB1->F2_NRROMA),20) 		&&10 - C�digo Fornecido pelo Cliente
			cLinha += cPVirg + PADR(cProdPred,25) 						&&11 - *Natureza da Mercadoria
			cLinha += cPVirg + Space(3)	 								&&12 - Tipo de Volumes
			
			lIsIcms := VerIsICMS(TRB1->F2_FILIAL, TRB1->F2_DOC, TRB1->F2_SERIE, cCliAnt, cLoja)
			cLinha += cPVirg + IIF(!lIsIcms,'0','1')				 	&&13 - *Indica Mercadoria isenta de ICMS 
			
			Fwrite(nHandle, cLinha)		
			
			&&Informa��es de Coleta												
			cLinha := cPVirg + Space(255)								&&14 - **Descri��o do Material a ser coletado - Obrigat�rio quando o tipo de entrega (Campo 5) = 1 ou 2
			Fwrite(nHandle, cLinha)		
			
			&&Dados do Destinat�rio
			SA1->(DBSeek(xFilial("SA1")+TRB1->F2_CLIENTE+TRB1->F2_LOJA))
			
			cLinha := cPVirg + PADR(SUBSTR(SA1->A1_NOME,1,40),40) 		&&15 - *Nome do Destinat�rio
			cLinha += cPVirg + PADR(SA1->A1_CGC,14)  					&&16 - *CNPJ/CPF Destinatario
			cLinha += cPVirg + PADR(SUBSTR(SA1->A1_INSCR,1,14),14) 		&&17 - **Incri��o Estadual - Obrigat�rio quando Destinatario for contribuinte
			cLinha += cPVirg + PADR(SUBSTR(SA1->A1_ENDENT,1,At(',', SA1->A1_ENDENT)-1),80) 	&&18 - *Endere�o de Entrega 
			
			lRet:=.T.
			cNum := u_RetNuStr(SA1->A1_ENDENT,@lRet)
			If !lRet
				lRet := .T.
				cNum := u_RetNuStr(','+SA1->A1_XNUMCOM,@lRet)
				If Empty(cNum)
					cNum := 'S/N'
				EndIf
			EndIf
			
			cLinha += cPVirg + PADR(cNum,10)							&&19 - *Numero Endere�o de Entrega		
			cLinha += cPVirg + PADR(SA1->A1_XCOMPLE,60)		 			&&20 - *Complemento Endere�o de Entrega
			cLinha += cPVirg + Space(255)			 					&&21 - Muito �til para Localiza��o de Endere�os
			cLinha += cPVirg + PADR(SUBSTR(SA1->A1_BAIRRO,1,40),40)	 	&&22 - *Bairro
			cLinha += cPVirg + PADR(SUBSTR(SA1->A1_MUN,1,40),40) 		&&23 - *Cidade
			cLinha += cPVirg + PADR(SA1->A1_EST,2)  	 				&&24 - *Estado
			cLinha += cPVirg + PADR('BRASIL', 20)		 				&&25 - Pa�s Destino
			Fwrite(nHandle, cLinha)	
			
			&&Dados do Destinat�rio
			cLinha := cPVirg + PADR(SA1->A1_CEP,8)	 					&&26 - *Cep
			cLinha += cPVirg + Space(60)		 						&&27 - EMail
			cLinha += cPVirg + StrTran(IIF( Empty(SA1->A1_TEL),   IIF( '(' $ SA1->A1_TEL,   SubStr(SA1->A1_TEL, At( '(' , SA1->A1_TEL )+1,  2) ,''),SA1->A1_DDD),"(","") &&28 - DDD
			cLinha += cPVirg + PADR( IIF(AllTrim(SA1->A1_DDD) == '11','9','') + Right(StrTran(AllTrim(SA1->A1_TEL), '-',''),8),12)		&&29 - Telefone 1
			cLInha += cPVirg + PADR(Right(StrTran(SA1->A1_FAX, '-',''),8),12) &&30 - Telefone 2
			cLInha += cPVirg + Space(12)		 						&&31 - Telefone 3
			Fwrite(nHandle, cLinha)	
			
			&&Dados do COD(Cash On Delivery)
			cLinha := cPVirg + '0'			 							&&32 - Servi�o Cod
			cLinha += cPVirg + Space(2)	 								&&33 - Forma de Pagamento do Cod
			cLinha += cPVirg + Space(2)		 							&&34 - Numero de Parcelas
			cLinha += cPVirg + SubStr(PADL(StrZero(0,3),8),1,6)+','+SubStr(PADL(StrZero(0,3),8),7,2) &&35 - Valor Total a Ser Coletado
			Fwrite(nHandle, cLinha)	
			
	  		&&Dados do Agendamento
			cLinha := cPVirg + Space(10) 								&&36 - Dados da Entrega agendada
			cLinha += cPVirg + Space(1) 								&&37 - Per�odo da Entrega
			cLinha += cPVirg + Space(1)	 								&&38 - Segundo Per�odo da Entrega 										
			Fwrite(nHandle, cLinha)	
			
			&&Layout para empresas que emitem Nota Fiscal Eletr�nica
			cLinha := cPVirg + PADR(TRB1->F2_DOC,9)	 					&&39 - Nfe N�mero
			cLinha += cPVirg + PADR(TRB1->F2_SERIE,3) 				    &&40 - NFe S�rie
			cLinha += cPVirg + PADR(SUBSTR(TRB1->F2_EMISSAO,7,2)+'/'+substr(TRB1->F2_EMISSAO,5,2)+'/'+substr(TRB1->F2_EMISSAO,1,4),10) 	&&41 - Nfe Dt Emiss�o
			cLinha += cPVirg + PADL(Transform(TRB1->F2_VALBRUT, '@E 999999999.99'),18)  &&42 - Nfe Valor Total
			cLinha += cPVirg + PADL(Transform(TRB1->F2_VALMERC, '@E 999999999.99'),18)  &&43 - Nfe Valor Mercadorias
			cLinha += cPVirg + PADR(cCFOPPred,4) 					    &&44 - Nfe CFOP Predominante
			cLinha += cPVirg + PADR(TRB1->F2_CHVNFE,44) 		       	&&45 - Nfe Chave de Acesso				
			Fwrite(nHandle, cLinha+ cCrLf)
			
			nSeq	:= nSeq+1
			vIDNOT	:= PADR("NOT"+substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(TIME(),1,2)+substr(TIME(),4,2)+STRZERO(nSeq,1),12)
			If !lSXZ
				GravSZX(cTransp, vIDNOT)	
			EndIf
			TRB1->(DbSkip()) 
		EndDo
		PutMv("MV_SEQTEXP",STRZERO(nSeqTotExp+1,1))	   
		
		fClose(nHandle)
		TRB1->(DbCloseArea())
		
		MakeDir(cDirEdi)
		__CopyFile(cArquivo, cDirEdi+"\"+cNomArq) 
		
		&&Conex�o e envio para FTP
		oArqFtp := FtpArq():NewFtpArq()                
	    If oArqFtp:Connect("ftp.totalexpress.com.br" , DEFAULT_FTP , "bgh" , "deeK9Lex")
			oArqFtp:Transfer(cNomArq ,cDirOrig, cDirDest )
			oArqFtp:Disconnect()
		EndIf 
		MsgAlert("Arquivo enviado, para verifica��o entre no diret�rio -> "+cDirEdi+"\"+cNomArq)
	Else
		Aviso("EDI Total Express","N�o Foi poss�vel Gerar o Arquivo, verifique os erros abaixo:"+cCrLf+cMsg,{"OK"})
	EndIf
	
	SA1->(RestArea(aAreaSA1))		
	SC6->(RestArea(aAreaSC6))		
	SF2->(RestArea(aAreaSF2))		
Return 

Static Function ProdPredom(cDoc, cSerie, cCliente, cLoja)	
	Local cAlias	:= GetNextAlias() 
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
    
	BeginSql Alias cAlias
		SELECT TOP 1 B1_DESC, D2_CF, D2_TOTAL
		FROM %Table:SD2% SD2
			INNER JOIN %Table:SB1% SB1
				ON SB1.B1_FILIAL 	= %xFilial:SB1%
				AND B1_COD 		= D2_COD
				AND SB1.%NotDel%
				
		WHERE 	
			SD2.D2_FILIAL 	= %xFilial:SD2%
			AND D2_DOC		= %Exp:cDoc%
			AND D2_SERIE	= %Exp:cSerie%
			AND D2_CLIENTE	= %Exp:cCliente%
			AND D2_LOJA		= %Exp:cLoja%	
			AND SD2.%NotDel%
		ORDER BY D2_TOTAL DESC
	EndSql	
	
	cProdPred 	:= (cAlias)->B1_DESC
	cCFOPPred	:= (cAlias)->D2_CF

	(cAlias)->(dbCloseArea())
	SD2->(RestArea(aAreaSD2))
	SB1->(RestArea(aAreaSB1))
Return       

Static Function VerIsICMS(cFil, cDoc, cSerie, cCliAnt, cLoja)   
	Local cAlias	:= GetNextAlias() 
	Local aAreaSD2	:= SD2->(GetArea())
	Local lIsIcms 	:= .T.
    
	BeginSql Alias cAlias
		SELECT F4_FILIAL, F4_ICM, D2_DOC, D2_SERIE
		FROM %Table:SD2% SD2
			INNER JOIN %Table:SF4% SF4
				ON SF4.F4_FILIAL 	= %xFilial:SF4%
				AND SF4.F4_CODIGO   = SD2.D2_TES 
				AND SF4.F4_ICM		= 'S' &&Calcula ICMS? S=SIM/N=N�O
				AND SF4.%NotDel%				
		WHERE 	
			SD2.D2_FILIAL 	= %Exp:cFil%
			AND D2_DOC		= %Exp:cDoc%
			AND D2_SERIE	= %Exp:cSerie%
			AND D2_CLIENTE	= %Exp:cCliAnt%
			AND D2_LOJA		= %Exp:cLoja%	
			
			AND SD2.%NotDel%
	EndSql	
	
	If !(cAlias)->(EOF())
		lIsIcms := .F. &&.F. Indica que h� pelo menos um item que n�o � isento de ICMS		
	endif 	

	(cAlias)->(dbCloseArea())
	SD2->(RestArea(aAreaSD2))   
Return lIsIcms

Static Function GravSZX(cTransp, vIDNOT)
   	Begin Transaction 
		RecLock("SZX",.T.)
		SZX->ZX_FILIAL		:=	xfilial("SZX")
		SZX->ZX_SERIE 		:=	TRB1->F2_SERIE
		SZX->ZX_NOTA  		:= 	TRB1->F2_DOC
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

Static Function ValEdiTE()
	Local lRet 		:= .T.
	Local lRetNr	:= .T.
	Local cCliente	:= ''
	Local cDocumen	:= ''
	Local nLin		:= 0
	Local nNum  	:= 0
	
	TRB1->(DbGoTop())
	
	cMsg		:= ''   
	SA1->(dbGoTop())
	SA1->(DbSetOrder(1))
	
	Do While TRB1->(!EoF())
		nLin++
		
		SA1->(DBSeek(xFilial("SA1")+TRB1->F2_CLIENTE+TRB1->F2_LOJA))
		
		cCliente := SA1->A1_COD+'/'+SA1->A1_LOJA +' - '+AllTrim(SA1->A1_NOME)
		cDocumen := TRB1->F2_DOC+'/'+TRB1->F2_SERIE
		
		If ValType(TRB1->F2_PBRUTO)  != 'N'
			lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Peso Bruto		 	'+cCliente+cCrLf
		EndIf	

		If ValType(TRB1->F2_VOLUME1) != 'N'
			lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Volume			 	'+cCliente+cCrLf
		EndIf
				
	    &&Retira n�mero da String
	    lRetNr := .T.
	 	nNum := u_RetNuStr(SA1->A1_ENDENT,@lRetNr)
		If !lRetNr
			lRetNr := .T.
			nNum := u_RetNuStr(','+SA1->A1_XNUMCOM,@lRetNr)
			If Empty(nNum)
				nNum := 'S/N'
			EndIf
		EndIf
	    
	    &&Valida��o do Endere�o
		If !',' $ SA1->A1_ENDENT .Or. !nNum $ SA1->A1_ENDENT
			lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Endere�o do Cliente 	'+cCliente+cCrLf
		EndIf 

	    &&Valida��o de N�mero do Endere�o
	 	If nNum == ''
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' N�mero do Endere�o  	'+cCliente+cCrLf
		EndIf 
	    
	 	&&Valida��o  Bairro
	 	If Empty(SA1->A1_BAIRRO)
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Bairro 			 	'+cCliente+cCrLf
	 	EndIf 

		&&Valida��o  Municipio
	 	If Empty(SA1->A1_MUN)
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Munic�pio		   	  	'+cCliente+cCrLf
	 	EndIf
	 	
	 	&&Valida��o UF
	 	If Empty(SA1->A1_EST)
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' UF				  	'+cCliente+cCrLf
	 	EndIf 
	 	
		&&Valida��o CEP
	 	If Empty(SA1->A1_CEP)
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' CEP				  	'+cCliente+cCrLf
	 	EndIf
	 	
	 	&&Valida��o DDD
	 	If Val(SA1->A1_DDD) == 0
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' DDD			  	  	'+cCliente+cCrLf
	 	EndIf	
	 	
		&&Valida��o Telefone
	 	If Val(SA1->A1_TEL) == 0
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Telefone		   	  	'+cCliente+cCrLf
	 	EndIf	 	
	 	
	 	&&Valida��o Doc
	 	If Empty(TRB1->F2_DOC)
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Documento Sa�da	  	'+cDocumen+cCrLf
	 	EndIf	
	 	
	 	&&Valida��o Doc
	 	If Empty(TRB1->F2_SERIE)
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Serie				  	'+cDocumen+cCrLf
	 	EndIf 	
	 	
	 	&&Valida��o Chave NFE
	 	If Empty(TRB1->F2_CHVNFE)
	 		lRet := .F.
			cMsg += '[Inconsist�ncia]-> Linha '+StrZero(nLin,4)+' Chave NFe			  	'+cDocumen+cCrLf
	 	EndIf
	 	
		TRB1->(DbSkip())
	EndDo
Return lRet 