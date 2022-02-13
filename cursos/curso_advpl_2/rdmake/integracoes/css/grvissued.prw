#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.Ch"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "XMLXFUN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GrvIssued ºAutor ³                     º Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava a tabela de Issue do Webservice                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                     
User Function GrvIssued(aParam)                       

Local nHdlSemaf := 0
Local cRotinExc := "GrvIssued"
If !U_SemafWKF(cRotinExc, @nHdlSemaf, .T.)
	Return()
Endif

StartJob("U_GrvIsZ17",GetEnvServer(),.T.,aParam) 

U_SemafWKF(cRotinExc, @nHdlSemaf, .F.)

Return()

User Function GrvIsZ17(aParam)

Local oHeader,oTicket,oIssuedWS,oLinha
Local aPosZ17	:= {}                                                     
Local cLog	 	:= ""                                                     
Local cTimeStamp := ""
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
Local cFMWH	:= ""      
//
Local aFileError :={}
Local aTicketError := {}                       
Local cStatus := "BGH-Success"
Local cUpd	:= ""      
Local cErrors := ""                                               
Local oIssued
Local nLenXml	:= 0       
Local nX,nY

Local oXmlRet,cArqXml

Private nHdl

PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

ConOut("GrvIssued - Chamando Metodo!")
oIssuedWS := WsTicketEventWebservice():New // chamada do Metodo
oXmlRet := oIssuedWS:GetIssuedData("BGH") // Preenche o objeto

SAVE oXmlRet XMLSTRING cXml


cArqXml := "\data\css_xml\GrvIssued"+dtos(msdate())+replace(time(),":","")+".xml"
ConOut("GrvIssued - Salvando XML "+cArqXml)
nHandle := FCreate(cArqXml)
If nHandle > 0
	FWrite(nHandle,cXml)
	FClose(nHandle)
Endif
ConOut("GrvIssued - Abrindo "+cArqXml)

nHdl    := fOpen(cArqXml,0)


If nHdl == -1
	ConOut("GrvIssued - "+cArqXml+" Problema na abertura do arquivo!")
Else
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	fClose(nHdl)
	
	ConOut("GrvIssued - Parser do arquivo "+cArqXml)
	cAviso := ""
	cErro  := ""
	cBuffer := EncodeUTF8( cBuffer)
	oIssued := XmlParser(cBuffer,"_",@cAviso,@cErro)
	
	ConOut("GrvIssued - "+cArqXml+" "+cAviso+" - "+cErro)
	
	TRYEXCEPTION
		nLenXml := Val(oIssued:_GETISSUEDDATARESPONSE:_GETISSUEDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TRAILER:_HEADER:TEXT) //Tamanho do header		
	CATCHEXCEPTION USING oException
		nLenXml := 0
		ConOut("GrvIssued - "+cArqXml+" Sem Dados!")
	ENDEXCEPTION
	
Endif


If nLenXml <= 0
	Reset Environment
	RpcClearEnv()
	CoNout("GrvIssued - Não exitem novos itens a serem processados 2.")
	Return()
EndIf

oHeader := oIssued:_GETISSUEDDATARESPONSE:_GETISSUEDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TICKETEVENTHEADER

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
	lNoTag := .F.
	cErrors := ""					

	For nY:=1 to nLim1

		lNoTag := .F.
		cErrors := ""						

		If lHeader


			TRYEXCEPTION				
				cWarranty	:= Alltrim(Upper(NoAcento(oLinha:_WARRANTYSTATUS:TEXT)))
			CATCHEXCEPTION USING oException
				cWarranty	:= ""          
				cErrors += "Mandatory TAG _WARRANTYSTATUS missing |"								
			ENDEXCEPTION

			TRYEXCEPTION								
				cCssNum	:= Alltrim(Upper(NoAcento(oLinha:_CSSTICKETNUMBER:TEXT)))
			CATCHEXCEPTION USING oException             
				cCssNum := "ERRO"
				lNoTag	:= .T.                          
				cErrors += "Mandatory TAG _CSSTICKETNUMBER missing |"								
			ENDEXCEPTION								

			TRYEXCEPTION								
				cArquiv := Alltrim(Upper(oIssued:_GETISSUEDDATARESPONSE:_GETISSUEDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TRAILER:_FILE_NAME:TEXT))		
			CATCHEXCEPTION USING oException
				cArquiv := "ERRO"
				lNoTag	:= .T.                            
				cErrors += "Mandatory TAG _FILE_NAME missing |"								
			ENDEXCEPTION

			lHeader := .F.
		EndIf

		TRYEXCEPTION		
			cSEQ		:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_SEQUENCENO:TEXT,oTicket:_SEQUENCENO:TEXT))))
		CATCHEXCEPTION USING oException
			cSEQ	 	:= "ERRO"
			lNoTag		:= .T.                                                              
			cErrors += "Mandatory TAG _SEQUENCENO missing |"
		ENDEXCEPTION

		TRYEXCEPTION
			cProdut	:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_PRODUCTNUMBER:TEXT,oTicket:_PRODUCTNUMBER:TEXT))))
		CATCHEXCEPTION USING oException
			cProdut := "ERRO"
			lNoTag	:= .T.                       
			cErrors += "Mandatory TAG _PRODUCTNUMBER missing |"
		ENDEXCEPTION

		TRYEXCEPTION			
			nQuant	:= Val(Replace(IIF(cVariavel=="A",oTicket[nY]:_QUANTITY:TEXT,oTicket:_QUANTITY:TEXT) ,",","."))
		CATCHEXCEPTION USING oException
			nQuant 	:= 0
			lNoTag	:= .T.                          
			cErrors += "Mandatory TAG _QUANTITY missing |"			
		ENDEXCEPTION

		TRYEXCEPTION			
			cSerialN:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_SERIALNUMBER:TEXT,oTicket:_SERIALNUMBER:TEXT))))
		CATCHEXCEPTION USING oException
			cSerialN:= "ERRO"
			lNoTag	:= .T.                     
			cErrors += "Mandatory TAG _SERIALNUMBER missing |"			
		ENDEXCEPTION

		TRYEXCEPTION			
			nVunit	:= Val(Replace(IIF(cVariavel=="A",oTicket[nY]:_UNITPRICE:TEXT,oTicket:_UNITPRICE:TEXT),",","."))
		CATCHEXCEPTION USING oException
			nVunit 	:= 0
			lNoTag	:= .T.                         
			cErrors += "Mandatory TAG _UNITPRICE missing |"			
		ENDEXCEPTION

		TRYEXCEPTION			
			cToWh	:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_TOWAREHOUSE:TEXT,oTicket:_TOWAREHOUSE:TEXT))))
		CATCHEXCEPTION USING oException
			cToWh 	:= "ERR"
			lNoTag	:= .T.                      
			cErrors += "Mandatory TAG _TOWAREHOUSE missing |"			
		ENDEXCEPTION

		TRYEXCEPTION			
			cFMWH	:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_FROMWAREHOUSE:TEXT,oTicket:_FROMWAREHOUSE:TEXT))))
		CATCHEXCEPTION USING oException
			cFMWH := "ERR"
			lNoTag	:= .T.                        
			cErrors += "Mandatory TAG _FROMWAREHOUSE missing |"			
		ENDEXCEPTION
		
		Z17->(DbSetOrder(1))
		If Z17->(DbSeek(xFilial("Z17") + PadR(cCssNum,TamSx3("Z17_CSSNUM")[1]," ") + PadR(cSerialN,TamSx3("Z17_SERIE")[1]," ") + PadR(cSeq,TamSx3("Z17_SEQ")[1]," ")))
		    ConOut("GrvIssued - "+cCssNum+"-"+cSerialN+"-"+cSeq+" ja existe na base!")
		    If !Z17->Z17_STATUS $ "U|E"
		       	cErrors += " Z17RECNO: "+cNumCOD
				AADD(aTicketError,{cArquiv,cCssNum,IIF(lNoTag,"BGH-Failed","BGH-Success"),cErrors})
				Loop
		    EndIf
			RecLock("Z17",.F.)
		Else
			RecLock("Z17",.T.)
		Endif  
		cNumCOD := ""
		
		Z17->Z17_FILIAL := xFilial("Z17")
		cNumCOD := GetSx8Num("Z17","Z17_CODIGO")
		Z17->Z17_CODIGO := cNumCOD
		ConfirmSX8()
		Z17->Z17_CSSNUM	:= cCssNum
		Z17->Z17_SEQ   	:= cSeq
		Z17->Z17_PRODUT	:= cProdut
		Z17->Z17_QUANT 	:= nQuant
		Z17->Z17_SERIE 	:= cSerialN
		Z17->Z17_VUNIT 	:= nVunit
		Z17->Z17_FMWH	:= cFMWH
		Z17->Z17_TOWH  	:= cToWh  
		Z17->Z17_WARRAN	:= IIF(Empty(Alltrim(cWarranty)),"E",UPPER(Substr(Alltrim(cWarranty),1,1)) )
		Z17->Z17_STATUS	:= IIF(cFMWH=="301" .And. cToWh=="302",IIF(!lNoTag,"I","E"),"U") // I = Integrar | E = Error | U = Ignorar transação
		Z17->Z17_PROCES := "W"
		Z17->Z17_ARQUIV	:= cArquiv
		Z17->Z17_DTTIME	:= Subs(dTos(dDataBase),1,4)+Subs(dTos(dDataBase),5,2)+Subs(dTos(dDataBase),7,2)+StrTran(Time(),":","")
		Z17->Z17_LOG	:= cErrors   //Criar MEMO
		Z17->Z17_TICKET	:= "I"
		Z17->Z17_FILE	:= "I"
		Z17->(MsUnlock())
		//*****GRAVAÇÃO Z17 ******     - FIM
		cErrors += " Z17RECNO: "+cNumCOD
		AADD(aTicketError,{cArquiv,cCssNum,IIF(lNoTag,"BGH-Failed","BGH-Success"),cErrors})
		cErrors := ""		
	Next
	
Next

AADD(aFileError,{cArquiv,cStatus})
lRet := u_AckFile(aFileError)

cUpd := "UPDATE "+RetSqlName("Z17")+" SET Z17_FILE = '"+IIF(lRet,"O","I")+"' "
cUpd += " WHERE RTRIM(Z17_ARQUIV) = '"+Alltrim(cArquiv)+"'"
cUpd += " AND D_E_L_E_T_ <> '*'"
TcSqlExec(cUpd) 

If Len(aTicketError) > 0                   
	lRet := u_AckTicket(aTicketError)
Else
	lRet := .T.
EndIf

cUpd := "UPDATE "+RetSqlName("Z17")+" SET Z17_TICKET = '"+IIF(lRet,"O","I")+"' "
cUpd += " WHERE RTRIM(Z17_ARQUIV) = '"+Alltrim(cArquiv)+"'"
cUpd += " AND D_E_L_E_T_ <> '*'"
TcSqlExec(cUpd)                 

U_ACMAILJB("Gravações do metodo Issued","Gravações do metodo Issued. Finalizado com registros","GRVISSUED",.F.)
Reset Environment
RpcClearEnv()
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NoAcento ºAutor  ³ Andre Jaar-Erpworks º Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que converte acentos			                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

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
