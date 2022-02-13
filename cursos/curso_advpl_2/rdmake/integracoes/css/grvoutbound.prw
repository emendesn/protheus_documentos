#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.Ch"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "XMLXFUN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GrvOutBoundºAutor³                     º Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava a tabela de InBound do Webservice                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GrvOutBoun(aParam)

Local nHdlSemaf := 0
Local cRotinExc := "GrvOutBound"   

If upper(FunName()) # 'U_EXCC6'

	If !U_SemafWKF(cRotinExc, @nHdlSemaf, .T.)
		Return()
	Endif
	
	StartJob("U_GrvOuZ19",GetEnvServer(),.T.,aParam) 
	
	U_SemafWKF(cRotinExc, @nHdlSemaf, .F.)
EndIf	

Return()

User Function GrvOuZ19(aParam)

Local oHeader,oTicket,oOutBoundWS,oLinha
Local aPosZ19	:= {}
Local cLog	 	:= ""
Local cWarranty	:= ""
 
Local aFileError :={}
Local aTicketError := {}                       
Local cStatus := "BGH-Success"
Local cUpd	:= ""      
Local cErrors := ""                                               
Local oOutbound
Local nLenXml	:= 0
Local nX
Local nY

Local oXmlRet,cArqXml

Private nHdl


PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

ConOut("GrvOutBound - Chamando Metodo!")
oOutBoundWS := WsTicketEventWebservice():New // chamada do Metodo
oXmlRet := oOutBoundWS:GetOutBoundData("BGH") // Preenche o objeto       


SAVE oXmlRet XMLSTRING cXml


cArqXml := "\data\css_xml\GrvOutBound"+dtos(msdate())+replace(time(),":","")+".xml"
ConOut("GrvOutBound - Salvando XML "+cArqXml)
nHandle := FCreate(cArqXml)
If nHandle > 0
	FWrite(nHandle,cXml)
	FClose(nHandle)
Endif
ConOut("GrvOutBound - Abrindo "+cArqXml)

nHdl    := fOpen(cArqXml,0)


If nHdl == -1
	ConOut("GrvOutBound - "+cArqXml+" Problema na abertura do arquivo!")
Else
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	fClose(nHdl)
	
	ConOut("GrvOutBound - Parser do arquivo "+cArqXml)
	cAviso := ""
	cErro  := ""
	cBuffer := EncodeUTF8( cBuffer)
	oOutBound := XmlParser(cBuffer,"_",@cAviso,@cErro)
	
	ConOut("GrvOutBound - "+cArqXml+" "+cAviso+" - "+cErro)
	
	TRYEXCEPTION
		nLenXml := Val(oOutBound:_GETOUTBOUNDDATARESPONSE:_GETOUTBOUNDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TRAILER:_HEADER:TEXT) //Tamanho do header		
	CATCHEXCEPTION USING oException
		nLenXml := 0
		ConOut("GrvOutBound - "+cArqXml+" Sem Dados!")
	ENDEXCEPTION
	
Endif


If nLenXml <= 0
	Reset Environment
	RpcClearEnv()
	CoNout("GrvOutBound - Não exitem novos itens a serem processados 2.")
	Return()
EndIf
                    
oHeader := oOutBound:_GETOUTBOUNDDATARESPONSE:_GETOUTBOUNDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TICKETEVENTHEADER

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
				cArquiv := Alltrim(Upper(oOutBound:_GETOUTBOUNDDATARESPONSE:_GETOUTBOUNDDATARESULT:_S11_ENVELOPE:_S11_BODY:_XML_ABBS_HEADER:_TRAILER:_FILE_NAME:TEXT))		
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

		Z19->(DbSetOrder(1)) //Filial+Ticket+Numero de serie
		lSeekSN		:= Z19->(DbSeek(xFilial("Z16")+cTicket+cSerialN))

		If lSeekSN .And. !(Z19->Z19_STATUS $ "E|U")
			AADD(aTicketError,{cArquiv,cCssNum,"Success","Outbound already integrated - success"})
			Loop
		EndIf
		//*****GRAVAÇÃO Z19 ******     - INICIO
		cNumCOD := ""
		RecLock("Z19",!lSeekSN)

		If !lSeekSN

			Z19->Z19_FILIAL := xFilial("Z19")
			cNumCOD := GetSx8Num("Z19","Z19_CODIGO")
			Z19->Z19_CODIGO := cNumCOD
			ConfirmSX8()
                        
		Else
			cNumCOD	:= Z19->Z19_CODIGO
		EndIf

		Z19->Z19_CSSNUM	:= cCssNum
		Z19->Z19_SEQ	:= cSeq
		Z19->Z19_PRODUT	:= cProdut
		Z19->Z19_QUANT	:= nQuant
		Z19->Z19_SERIE	:= cSerialN
		Z19->Z19_VUNIT	:= nVUnit
		Z19->Z19_PROCES	:= "W"
		Z19->Z19_WARRAN	:= IIF(Empty(Alltrim(cWarranty)),"E",UPPER(Substr(Alltrim(cWarranty),1,1)) )
		Z19->Z19_STATUS := "I"
		Z19->Z19_ARQUIV := cArquiv
		Z19->Z19_DTTIME := Subs(dTos(dDataBase),1,4)+Subs(dTos(dDataBase),5,2)+Subs(dTos(dDataBase),7,2)+StrTran(Time(),":","")
		Z19->Z19_LOG	:= cErrors   //Criar MEMO
		Z19->Z19_TICKET	:= "I"
		Z19->Z19_FILE	:= "I"		

		Z19->(MsUnlock())
		//*****GRAVAÇÃO Z19 ******     - FIM    
		cErrors += " Z19RECNO: "+cNumCOD
		
		Conout("GrvOutBound -> "+cErrors)
		
		AADD(aTicketError,{cArquiv,cCssNum,"BGH-Success",cErrors})
		cErrors := ""				
	Next

Next

AADD(aFileError,{cArquiv,cStatus})

lRet := u_AckFile(aFileError)


cUpd := "UPDATE "+RetSqlName("Z19")+" SET Z19_FILE = '"+IIF(lRet,"O","I")+"' "
cUpd += " WHERE RTRIM(Z19_ARQUIV) = '"+Alltrim(cArquiv)+"'"
cUpd += " AND D_E_L_E_T_ <> '*'"
TcSqlExec(cUpd) 

If Len(aTicketError) > 0
	lRet := u_AckTicket(aTicketError)
Else
	lRet := .T.
EndIf         

cUpd := "UPDATE "+RetSqlName("Z19")+" SET Z19_TICKET = '"+IIF(lRet,"O","I")+"' "
cUpd += " WHERE RTRIM(Z19_ARQUIV) = '"+Alltrim(cArquiv)+"'"
cUpd += " AND D_E_L_E_T_ <> '*'"
TcSqlExec(cUpd)                 

U_ACMAILJB("Gravações do metodo Outbound","Gravações do metodo Outbound. Finalizado com informações.","GRVOUTBOU")
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
