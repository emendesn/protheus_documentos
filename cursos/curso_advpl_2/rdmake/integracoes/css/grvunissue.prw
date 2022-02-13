#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.Ch"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "XMLXFUN.CH"
                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GrvUnIssueºAutor ³                       Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava a tabela de UnIssue do Webservice                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GrvUnIssue(aParam)

Local nHdlSemaf := 0
Local cRotinExc := "GrvUnIssue"
If !U_SemafWKF(cRotinExc, @nHdlSemaf, .T.)
	Return()
Endif

StartJob("U_GrvUnZ18",GetEnvServer(),.T.,aParam) 

U_SemafWKF(cRotinExc, @nHdlSemaf, .F.)

Return()

User Function GrvUnZ18(aParam)

Local oHeader,oTicket,oUnIssueWS,oLinha
Local aPosZ18	:= {}
Local cLog	 	:= ""  
Local cWarranty	:= ""

Local aFileError :={}
Local aTicketError := {}                       
Local cStatus := "BGH-Success"
Local cUpd	:= ""      
Local cErrors := ""                                               
Local oUnIssue
Local nLenXml	:= 0
Local nX,nY
Local oXmlRet,cArqXml

DEFAULT aParam:={'02','02'}

Private nHdl
               
PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

ConOut("GrvUnIssue - Chamando Metodo!")
oUnIssueWS := WsTicketEventWebservice():New // chamada do Metodo
oXmlRet := oUnIssueWS:GetUnIssueData("BGH") // Preenche o objeto


SAVE oXmlRet XMLSTRING cXml


cArqXml := "\data\css_xml\GrvUnIssued"+dtos(msdate())+replace(time(),":","")+".xml"
ConOut("GrvUnIssue - Salvando XML "+cArqXml)
nHandle := FCreate(cArqXml)
If nHandle > 0
	FWrite(nHandle,cXml)
	FClose(nHandle)
Endif
ConOut("GrvUnIssue - Abrindo "+cArqXml)

nHdl    := fOpen(cArqXml,0)


If nHdl == -1
	ConOut("GrvUnIssue - "+cArqXml+" Problema na abertura do arquivo!")
Else
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	fClose(nHdl)
	
	ConOut("GrvUnIssue - Parser do arquivo "+cArqXml)
	cAviso := ""
	cErro  := ""
	cBuffer := EncodeUTF8( cBuffer)
	oUnIssued := XmlParser(cBuffer,"_",@cAviso,@cErro)
	
	ConOut("GrvUnIssue - "+cArqXml+" "+cAviso+" - "+cErro)
	
	TRYEXCEPTION
		nLenXml := Val(oUnIssued:_GETUNISSUEDATARESPONSE:_GETUNISSUEDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TRAILER:_HEADER:TEXT) //Tamanho do header		
	CATCHEXCEPTION USING oException
		nLenXml := 0
		ConOut("GrvUnIssue - "+cArqXml+" Sem Dados!")
	ENDEXCEPTION
	
Endif


If nLenXml <= 0
	Reset Environment
	RpcClearEnv()
	CoNout("GrvUnIssue - Não exitem novos itens a serem processados 2.")
	Return()
EndIf

oHeader := oUnIssued:_GETUNISSUEDATARESPONSE:_GETUNISSUEDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TICKETEVENTHEADER

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
            
	lNoTag	:= .F.    
	lHeader := .T.                  
	cErrors := ""					

	For nY:=1 to nLim1

		lNoTag := .F.      
		cErrors := ""						

		If lHeader
          
 
			TRYEXCEPTION				
				cWarranty	:= Alltrim(Upper(NoAcento(oLinha:_WARRANTYSTATUS:TEXT)))
			CATCHEXCEPTION USING oException
				cWarranty	:= ""          
			ENDEXCEPTION
						
			TRYEXCEPTION								
				cCssNum	:= Alltrim(Upper(NoAcento(oLinha:_CSSTICKETNUMBER:TEXT)))
			CATCHEXCEPTION USING oException             
				cCssNum := ""
				lNoTag	:= .T.                          
				cErrors += "Mandatory TAG _CSSTICKETNUMBER missing |"								
			ENDEXCEPTION								

			TRYEXCEPTION								
				cArquiv := Alltrim(Upper(oUnIssued:_GETUNISSUEDATARESPONSE:_GETUNISSUEDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TRAILER:_FILE_NAME:TEXT))		
			CATCHEXCEPTION USING oException
				cArquiv := ""
				lNoTag	:= .T.                            
				cErrors += "Mandatory TAG _FILE_NAME missing |"								
			ENDEXCEPTION
			
			lHeader := .F.
		EndIf
         
		TRYEXCEPTION		
			cSEQ		:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_SEQUENCENO:TEXT,oTicket:_SEQUENCENO:TEXT))))
		CATCHEXCEPTION USING oException
			cSEQ	 	:= ""
			lNoTag		:= .T.                                                              
			cErrors += "Mandatory TAG _SEQUENCENO missing |"
		ENDEXCEPTION

		TRYEXCEPTION
			cProdut	:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_PRODUCTNUMBER:TEXT,oTicket:_PRODUCTNUMBER:TEXT))))
		CATCHEXCEPTION USING oException
			cProdut := ""
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
			cSerialN:= ""
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
			cToWh 	:= ""
			lNoTag	:= .T.                      
			cErrors += "Mandatory TAG _TOWAREHOUSE missing |"			
		ENDEXCEPTION

		TRYEXCEPTION			
			cFMWH	:= Alltrim(Upper(NoAcento(IIF(cVariavel=="A",oTicket[nY]:_FROMWAREHOUSE:TEXT,oTicket:_FROMWAREHOUSE:TEXT))))
		CATCHEXCEPTION USING oException
			cFMWH := ""
			lNoTag	:= .T.                        
			cErrors += "Mandatory TAG _FROMWAREHOUSE missing |"			
		ENDEXCEPTION

		Z18->(DbSetOrder(1)) //Filial+Ticket+Numero de serie+Sequencial(unico)
		lSeekZ18		:= Z18->(DbSeek(xFilial("Z18")+cTicket+cSerialN+cSeq))//Padr(cTicket,TamSx3("Z18_CSSNUM")[2]," ")+Padr(cSerialN,TamSx3("Z18_SERIE")[2]," ")+Padr(cSeq,TamSx3("Z18_SEQ")[2]," ")))

		If lSeekZ18 .And. !(Z18->Z18_STATUS $ "E|U")                               
			AADD(aTicketError,{cArquiv,cCssNum,"Success","Unissue Already integrated - Success"})		
			Loop
		EndIf  
		//*****GRAVAÇÃO Z18 ******     - INICIO
		cNumCOD := ""
		RecLock("Z18",!lSeekZ18)

		If !lSeekZ18
       
			Z18->Z18_FILIAL := xFilial("Z18")
			cNumCOD := GetSx8Num("Z18","Z18_CODIGO")
			Z18->Z18_CODIGO := cNumCOD
			ConfirmSX8()
                        
		Else
			cNumCOD := Z18->Z18_CODIGO
		EndIf

		Z18->Z18_CSSNUM	:= cCssNum
		Z18->Z18_SEQ   	:= cSeq
		Z18->Z18_PRODUT	:= cProdut
		Z18->Z18_QUANT 	:= nQuant
		Z18->Z18_SERIE 	:= cSerialN
		Z18->Z18_VUNIT 	:= nVunit
		Z18->Z18_FMWH	:= cFMWH
		Z18->Z18_TOWH  	:= cToWh
		Z18->Z18_WARRAN	:= IIF(Empty(Alltrim(cWarranty)),"E",UPPER(Substr(Alltrim(cWarranty),1,1)) )
		Z18->Z18_STATUS	:= IIF( (cFMWH=="302" .And. cToWh=="301") .OR. (cFMWH=="302" .And. cToWh=="503"),IIF(!lNoTag,"I","E"),"U") // I = Integrar | E = Error | U = Ignorar transação
		Z18->Z18_PROCES := "W"
		Z18->Z18_ARQUIV	:= cArquiv                                                                                             
		Z18->Z18_DTTIME	:= Subs(dTos(dDataBase),1,4)+Subs(dTos(dDataBase),5,2)+Subs(dTos(dDataBase),7,2)+StrTran(Time(),":","")			
		Z18->Z18_LOG	:= cErrors   //Criar MEMO
		Z18->Z18_TICKET	:= "I"                                                    
		Z18->Z18_FILE	:= "I"				
		Z18->(MsUnlock())
		//*****GRAVAÇÃO Z18 ******     - FIM
		cErrors += " Z18RECNO: "+cNumCOD
		AADD(aTicketError,{cArquiv,cCssNum,IIF(lNoTag,"BGH-Failed","BGH-Success"),cErrors})
		cErrors := ""				
	Next

Next                       
                                  
AADD(aFileError,{cArquiv,cStatus})
lRet := u_AckFile(aFileError)
cUpd := "UPDATE "+RetSqlName("Z18")+" SET Z18_FILE = '"+IIF(lRet,"O","I")+"' "
cUpd += " WHERE RTRIM(Z18_ARQUIV) = '"+Alltrim(cArquiv)+"'"
cUpd += " AND D_E_L_E_T_ <> '*'"
TcSqlExec(cUpd)            

If Len(aTicketError) > 0                   
	lRet := u_AckTicket(aTicketError)
Else
	lRet := .T.
EndIf

cUpd := "UPDATE "+RetSqlName("Z18")+" SET Z18_TICKET = '"+IIF(lRet,"O","I")+"' "
cUpd += " WHERE RTRIM(Z18_ARQUIV) = '"+Alltrim(cArquiv)+"'"
cUpd += " AND D_E_L_E_T_ <> '*'"
TcSqlExec(cUpd)                 

U_ACMAILJB("Gravações do metodo UnIssue","Gravações do metodo UnIssue. Finalizado com informações.","GRVUNISSU")
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
