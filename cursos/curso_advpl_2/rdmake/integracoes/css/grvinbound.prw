#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.Ch"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "XMLXFUN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GrvInbound ºAutor³                     º Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava a tabela Z16 pelo metodo INBOUND                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GrvInbound(aParam)
	
	
	Local nHdlSemaf := 0
	Local cRotinExc := "GrvInbound"   
	DEFAULT aParam:={'02','02'}
	
	
	
	If !U_SemafWKF(cRotinExc, @nHdlSemaf, .T.)
		Return()
	Endif
	
	StartJob("U_GrvInZ16",GetEnvServer(),.T.,aParam)
	
	U_SemafWKF(cRotinExc, @nHdlSemaf, .F.)
	
Return()


User Function GrvInZ16(aParam)
	
	Local oInBound,oInBoundWS,oLinha
	Local nLenXml	:= 0
	Local oHeader,oTicket
	Local aPosZ16	:= {}
	Local cLog	 	:= ""
	Local nLim1		:= 0
	Local nLemXml	:= 0
	Local cVariavel	:= ""
	//Header
	Local cNome		:= ""
	Local cEnd		:= ""
	Local cComple	:= ""
	Local cBairro	:= ""
	Local cEstado	:= ""
	Local cCidade	:= ""
	Local cCep		:= ""
	Local ctipoEnd	:= ""
	Local cCnpj		:= ""
	Local cIe		:= ""
	Local cTel		:= ""
	Local cEmail	:= ""
	Local cWarranty	:= ""
	Local cCssNum	:= ""
	Local cArquiv 	:= ""
	//Ticket
	Local cSEQ		:= ""
	Local cProdut	:= ""
	Local nQuant	:= 0
	Local cSerialN	:= ""
	Local NVunit	:= 0
	Local cToWh		:= ""
	
	Local lSeekSN	:= .F.
	Local aRetorno	:= {}
	Local aFileError :={}
	Local aTicketError := {}
	Local cStatus := "BGH-Success"
	Local cUpd	:= ""
	Local cErrors := ""
	Local nX,nY
	Local oXmlRet,cArqXml
	DEFAULT aParam:={'02','02'}

	
	Private nHdl
	
	RpcClearEnv()
	RPCSETTYPE(3)
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	
	ConOut("GrvInbound - Chamando Metodo!")
	oInboundWS := WsTicketEventWebservice():New // chamada do Metodo
	oXmlRet := oInboundWS:GetInBoundData("BGH") // Preenche o objeto
	
	SAVE oXmlRet XMLSTRING cXml
	
	
	cArqXml := "\data\css_xml\GetInBoundData"+dtos(msdate())+replace(time(),":","")+".xml"
	ConOut("GrvInbound - Salvando XML "+cArqXml)
	nHandle := FCreate(cArqXml)
	If nHandle > 0
		FWrite(nHandle,cXml)
		FClose(nHandle)
	Endif
	ConOut("GrvInbound - Abrindo "+cArqXml)
	nHdl    := fOpen(cArqXml,0)
	
	
	If nHdl == -1
		ConOut("GrvInbound - "+cArqXml+" Problema na abertura do arquivo!")
	Else
		nTamFile := fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)
		cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
		nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
		fClose(nHdl)
		
		ConOut("GrvInbound - Parser do arquivo "+cArqXml)
		cAviso := ""
		cErro  := ""
		cBuffer := EncodeUTF8( cBuffer)
		oInbound := XmlParser(cBuffer,"_",@cAviso,@cErro)
		
		ConOut("GrvInbound - "+cArqXml+" "+cAviso+" - "+cErro)
		
		TRYEXCEPTION
			nLenXml := Val(oInbound:_GETINBOUNDDATARESPONSE:_GETINBOUNDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TRAILER:_HEADER:TEXT) //Tamanho do header		
		CATCHEXCEPTION USING oException
			nLenXml := 0
			ConOut("GrvInbound - "+cArqXml+" Sem Dados!")
		ENDEXCEPTION
		
	Endif
	
	If nLenXml <= 0
		//U_ACMAILJB("Gravações do metodo InBound","Gravações do metodo InBound. Finalizado sem registros.","GRVINBOUN",.F.)
		Reset Environment
		RpcClearEnv()
		CoNout("GrvInbound - Não exitem novos itens a serem processados 2.")
		Return
	EndIf
	
	oHeader := oInbound:_GETINBOUNDDATARESPONSE:_GETINBOUNDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TICKETEVENTHEADER
	
	DbSelectArea("Z16")
	For nX:=1 to nLenXml
		
		If ValType(oHeader) == "A"
			oTicket		:= oHeader[nX]:_TICKETEVENTDETAIL
			oLinha		:= oHeader[nX]
			cTicket		:= PADR(oHeader[nX]:_CSSTICKETNUMBER:TEXT,30," ")
		Else
			oTicket		:= oHeader:_TICKETEVENTDETAIL
			oLinha		:= oHeader
			cTicket		:= PADR(oHeader:_CSSTICKETNUMBER:TEXT,30," ")
		Endif
		
		cVariavel	:= ValType(oTicket)
		
		If Valtype(oTicket) == "A"
			nLim1	:= Len(oTicket)
		Else
			nLim1	:= 1
		EndIf
		
		lHeader := .T.
		cErrors := ""
		
		For nY:=1 to nLim1
			
			lNoTag	:= .F.
			cErrors := ""
			
			If lHeader
				
				TRYEXCEPTION
					cNome	:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_CUSTOMERNAME:TEXT),".",""),",",""),"-",""),"/","")))
					If Empty(Alltrim(cNome))
						cNome := ""
						cErrors += "Mandatory TAG _CUSTOMERNAME empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cNome	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _CUSTOMERNAME missing |"
				ENDEXCEPTION
			
				TRYEXCEPTION
					cEnd	:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_CUSTOMERADDRESS:TEXT),".",""),",",""),"-",""),"/","")))
					If Empty(Alltrim(cEnd))
						cEnd 	:= ""
						cErrors += "Mandatory TAG _CUSTOMERADDRESS empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cEnd	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _CUSTOMERADDRESS missing |"
				ENDEXCEPTION
		
				TRYEXCEPTION
					cComple	:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_ADDRESS2:TEXT),".",""),",",""),"-",""),"/","")))
				CATCHEXCEPTION USING oException
					cComple	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _CUSTOMERNAME missing |"
				ENDEXCEPTION
	
				TRYEXCEPTION
					cBairro	:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_DISTRICT:TEXT),".",""),",",""),"-",""),"/","")))
					If Empty(Alltrim(cBairro))
						cBairro 	:= ""
						cErrors += "Mandatory TAG _DISTRICT empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cBairro	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _DISTRICT missing |"
				ENDEXCEPTION

				TRYEXCEPTION
					cEstado	:= Alltrim(Upper(NoAcento(oLinha:_CUSTOMERSTATE:TEXT)))
					If Empty(Alltrim(cEstado))
						cEstado	:= ""
						cErrors += "Mandatory TAG _CUSTOMERSTATE empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cEstado	:= "ER"
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _CUSTOMERSTATE missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cCidade	:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_CITY:TEXT),".",""),",",""),"-",""),"/","")))
					If Empty(Alltrim(cCidade))
						cCidade	:= ""
						cErrors += "Mandatory TAG _CITY empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cCidade	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _CITY missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cCep	:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_ZIPCODE:TEXT),".",""),",",""),"-",""),"/","")))
					If Empty(Alltrim(cCep))
						cCep	:= ""
						cErrors += "Mandatory TAG _ZIPCODE empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cCep	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _ZIPCODE missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cTipoEnd:= Alltrim(Upper(NoAcento(oLinha:_CUSTOMERTYPE:TEXT)))
				CATCHEXCEPTION USING oException
					ctipoEnd:= ""
					cErrors += "Optional TAG _CUSTOMERTYPE missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cCnpj	:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_CPFCNPJNUMBER:TEXT),".",""),",",""),"-",""),"/","")))
					If Empty(Alltrim(cCnpj))
						cCnpj	:= ""
						cErrors += "Mandatory TAG _CPFCNPJNUMBER empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cCnpj	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _CPFCNPJNUMBER missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cIe		:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_STATEREGNUMBER:TEXT),".",""),",",""),"-",""),"/","")))
					If Empty(Alltrim(cIe))
						cIe		:= ""
						cErrors += "Mandatory TAG _STATEREGNUMBER empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cIe		:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _STATEREGNUMBER missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cTel	:= Alltrim(NoAcento(Replace(Replace(Replace(Replace(Upper(oLinha:_PHONENUMBER:TEXT),".",""),",",""),"-",""),"/","")))
					If Empty(Alltrim(cTel))
						cTel	:= ""
						cErrors += "Mandatory TAG _PHONENUMBER empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cTel	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _PHONENUMBER missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cEmail	:= Alltrim(Upper(NoAcento(oLinha:_EMAIL:TEXT)))
					If Empty(Alltrim(cEmail))
						cEmail	:= ""
						cErrors += "Mandatory TAG _EMAIL empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cEmail	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _EMAIL missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cWarranty	:= Alltrim(Upper(NoAcento(oLinha:_WARRANTYSTATUS:TEXT)))
					If Empty(Alltrim(cWarranty))
						cWarranty	:= ""
						cErrors += "Mandatory TAG _WARRANTYSTATUS empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cWarranty	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _WARRANTYSTATUS missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cCssNum	:= Alltrim(Upper(NoAcento(oLinha:_CSSTICKETNUMBER:TEXT)))
					If Empty(Alltrim(cCssNum))
						cCssNum	:= ""
						cErrors += "Mandatory TAG _CSSTICKETNUMBER empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cCssNum	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _CSSTICKETNUMBER missing |"
				ENDEXCEPTION
				
				TRYEXCEPTION
					cArquiv := Alltrim(Upper(oInbound:_GETINBOUNDDATARESPONSE:_GETINBOUNDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TRAILER:_FILE_NAME:TEXT))
					If Empty(Alltrim(cArquiv))
						cArquiv	:= ""
						cErrors += "Mandatory TAG _FILE_NAME empty |"
						lNoTag 	:= .T.
					EndIf
				CATCHEXCEPTION USING oException
					cArquiv	:= ""
					lNoTag 	:= .T.
					cErrors += "Mandatory TAG _FILE_NAME missing |"
				ENDEXCEPTION
				
				lHeader := .F.
			EndIf
			
			TRYEXCEPTION
				cSEQ		:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_SEQUENCENO:TEXT,oTicket:_SEQUENCENO:TEXT))))
				If Empty(Alltrim(cSEQ))
					cSEQ	:= ""
					cErrors += "Mandatory TAG _SEQUENCENO empty |"
					lNoTag 	:= .T.
				EndIf
			CATCHEXCEPTION USING oException
				cSEQ	:= ""
				lNoTag 	:= .T.
				cErrors += "Mandatory TAG _SEQUENCENO missing |"
			ENDEXCEPTION
			
			TRYEXCEPTION
				cProdut		:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_PRODUCTNUMBER:TEXT,oTicket:_PRODUCTNUMBER:TEXT))))
				If Empty(Alltrim(cProdut))
					cProdut := ""
					cErrors += "Mandatory TAG _PRODUCTNUMBER empty |"
					lNoTag 	:= .T.
				EndIf
			CATCHEXCEPTION USING oException
				cProdut	:= ""
				lNoTag 	:= .T.
				cErrors += "Mandatory TAG _PRODUCTNUMBER missing |"
			ENDEXCEPTION
			
			TRYEXCEPTION
				nQuant		:= Val(Replace(IIF(cVariavel=="A",oTicket[nY]:_QUANTITY:TEXT,oTicket:_QUANTITY:TEXT) ,",","."))
				If nQuant <= 0
					nQuant	:= 0
					cErrors += "Mandatory TAG _QUANTITY as or below 0 |"
					lNoTag 	:= .T.
				EndIf
			CATCHEXCEPTION USING oException
				nQuant	:= 0
				lNoTag 	:= .T.
				cErrors += "Mandatory TAG _QUANTITY missing |"
			ENDEXCEPTION
			
			TRYEXCEPTION
				cSerialN	:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_SERIALNUMBER:TEXT,oTicket:_SERIALNUMBER:TEXT))))
				If Empty(Alltrim(cSerialN))
					cSerialN := ""
					cErrors += "Mandatory TAG _SERIALNUMBER empty |"
					lNoTag 	:= .T.
				EndIf
			CATCHEXCEPTION USING oException
				cSerialN	:= ""
				lNoTag 		:= .T.
				cErrors += "Mandatory TAG _SERIALNUMBER missing |"
			ENDEXCEPTION
			
			TRYEXCEPTION
				nVunit		:= Val(Replace(IIF(cVariavel=="A",oTicket[nY]:_UNITPRICE:TEXT,oTicket:_UNITPRICE:TEXT),",","."))
				If nVunit <= 0
					nVunit	:= 0
					cErrors += "Mandatory TAG _UNITPRICE as or below 0 |"
					lNoTag 	:= .T.
				EndIf
			CATCHEXCEPTION USING oException
				nVunit		:= 0
				lNoTag 		:= .T.
				cErrors += "Mandatory TAG _UNITPRICE missing |"
			ENDEXCEPTION
			
			TRYEXCEPTION
				cToWh	 	:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_TOWAREHOUSE:TEXT,oTicket:_TOWAREHOUSE:TEXT))))
				If Empty(Alltrim(cToWh))
					cToWh 	:= ""
					cErrors += "Mandatory TAG _SERIALNUMBER empty |"
					lNoTag 	:= .T.
				EndIf
			CATCHEXCEPTION USING oException
				cToWh		:= "ERR"
				lNoTag 		:= .T.
				cErrors += "Mandatory TAG _TOWAREHOUSE missing |"
			ENDEXCEPTION
			
			lSeekSN := .F.
			/*
			Z16->(DbSetOrder(1)) //Filial+Ticket+Numero de serie
			lSeekSN		:= Z16->(DbSeek(xFilial("Z16")+cTicket+cSerialN))
			
			If lSeekSN .And. !(Z16->Z16_STATUS $ "E|I")
				AADD(aTicketError,{cArquiv,cCssNum,"Success","InBound already integrated - Success"})
				Loop
			EndIf
			*/

			//*****GRAVAÇÃO Z16 ******     - INICIO
			cNumCOD := ""
			RecLock("Z16",!lSeekSN)
			
			If !lSeekSN
				
				Z16->Z16_FILIAL := xFilial("Z16")
				cNumCOD	:= GetSx8Num("Z16","Z16_CODIGO")
				Z16->Z16_CODIGO := cNumCOD
				ConfirmSX8()
				
			Else
				cNumCOD := Z16->Z16_CODIGO
			EndIf
			
			Z16->Z16_NOME	:= cNome
			Z16->Z16_END	:= cEnd
			Z16->Z16_COMPLE	:= cComple
			Z16->Z16_BAIRRO	:= cBairro
			Z16->Z16_ESTADO	:= cEstado
			Z16->Z16_CIDADE	:= cCidade
			Z16->Z16_CEP	:= cCep
			Z16->Z16_TIPEND	:= cTipoEnd
			Z16->Z16_CNPJ	:= cCnpj
			Z16->Z16_IE		:= cIe
			Z16->Z16_TEL	:= cTel
			Z16->Z16_EMAIL	:= cEmail
			Z16->Z16_CSSNUM	:= cCssNum
			Z16->Z16_SEQ	:= cSeq
			Z16->Z16_PRODUT	:= cProdut
			Z16->Z16_QUANT	:= nQuant
			Z16->Z16_SERIE	:= cSerialN
			Z16->Z16_VUNIT	:= nVUnit
			Z16->Z16_PROCES	:= "W"
			Z16->Z16_TOWH 	:= cToWh
			Z16->Z16_WARRAN	:= IIF(Empty(Alltrim(cWarranty)),"E",UPPER(Substr(Alltrim(cWarranty),1,1)) )
			Z16->Z16_STATUS := "I"
			Z16->Z16_ARQUIV := Alltrim(Upper(cArquiv))
			Z16->Z16_DTTIME := Subs(dTos(dDataBase),1,4)+Subs(dTos(dDataBase),5,2)+Subs(dTos(dDataBase),7,2)+StrTran(Time(),":","")
			Z16->Z16_LOG	:= cErrors   //Criar MEMO
			Z16->Z16_TICKET	:= "I"
			Z16->Z16_FILE	:= "I"
			
			Z16->(MsUnlock())
			//*****GRAVAÇÃO Z16 ******     - FIM
			cErrors += " Z16RECNO: "+cNumCOD
			AADD(aTicketError,{cArquiv,cCssNum,IIF(lNoTag,"BGH-Failed","BGH-Success"),cErrors})
			cErrors := ""
		Next

	Next

	AADD(aFileError,{cArquiv,cStatus})
	lRet := u_AckFile(aFileError)
	cUpd := "UPDATE "+RetSqlName("Z16")+" SET Z16_FILE = '"+IIF(lRet,"O","I")+"' "
	cUpd += " WHERE RTRIM(Z16_ARQUIV) = '"+Alltrim(UPPER(cArquiv))+"'"
	cUpd += " AND D_E_L_E_T_ <> '*'"
	TcSqlExec(cUpd)
	
	If Len(aTicketError) > 0
		lRet := u_AckTicket(aTicketError)
	Else
		lRet := .T.
	EndIf
	
	cUpd := "UPDATE "+RetSqlName("Z16")+" SET Z16_TICKET = '"+IIF(lRet,"O","I")+"' "
	cUpd += " WHERE RTRIM(Z16_ARQUIV) = '"+Alltrim(UPPER(cArquiv))+"'"
	cUpd += " AND D_E_L_E_T_ <> '*'"
	TcSqlExec(cUpd)
	
	
	U_ACMAILJB("Gravações do metodo InBound","Gravações do metodo InBound. Finalizado com registros.","GRVINBOUN",.F.)
	Reset Environment
	RpcClearEnv()
	
Return()


static FUNCTION NoAcento(cString)
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõÃÕ"
	Local cApost := "'"
	Local cAspas := '"'
	
	Local cCecid := "çÇ"
	
	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
			nY:= At(cChar,cApost)
			If nY > 0
				cString := StrTran(cString,cChar,"")
			EndIf
			nY:= At(cChar,cAspas)
			If nY > 0
				cString := StrTran(cString,cChar,"")
			EndIf
		Endif
	Next
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If Asc(cChar) < 32 .Or. Asc(cChar) > 123
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
Return cString
