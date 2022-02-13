#Include "Totvs.ch"
#Include "tbiconn.ch"
#INCLUDE "APWIZARD.CH"
#Define DEFAULT_FTP 21

User Function JobA0001(lPar)
	Local aAlias  := GetArea()
	Local aDirFTP := {}
	Local lConnect:= .T.
	Local cDireFTP:= "retornos"
	Local cDirRet := "web\FtpTotalExpress\recebidos\"
	Local oArqFtp
	Private lJob := IIF( ValType(lPar)=='L',lPar,.F.)
	Private cHora := ""

	rpcsettype(3)
	rpcsetenv('02','02')  
	
	//u_GerA0003(ProcName())
	
	cHora := Time()
	&&Garante que FTP está desconectado para iniciar nova sessão
	FTPDisconnect()
	
	&&Conexão FTP                           
	If FTPConnect("ftp.totalexpress.com.br" , DEFAULT_FTP , "bgh" , "deeK9Lex")
		ConOut("Importação de arquivos executado às "+Time()+" Via Job")
		aDirFTP := FtpDirectory( "*.*" , "D")
  		If Empty(aDirFTP)
			ConOut("Não há diretórios neste FTP.")		
		Else
			If !FtpDirChange(cDireFTP)
				ConOut("Não foi encontrado o diretório "+Alltrim(cDireFTP)+" .")
			Else
				aDirFTP := FtpDirectory( "*.*" , "D")
  				If !Empty(aDirFTP)
  					For nI:= 1 To Len(aDirFTP)  				
						If FtpDownload(cDirRet+aDirFTP[nI][1], aDirFTP[nI][1])
							ConOut("Download do arquivo "+AllTrim(aDirFTP[nI][1])+" efetuado com sucesso.") 
							If !FtpErase(aDirFTP[nI][1])
								ConOut("Não foi possível excluir o arquivo "+AllTrim(aDirFTP[nI][1])+" .") 
							EndIF
							lTransf:=.T.
						Else
							ConOut("Não há arquivo para download!")					
						EndIf					 		
					Next nI		    
				Else
					ConOut("Não há Arquivos a serem importados neste FTP.")
				EndIf 							
			EndIf
		EndIf
  		If FTPDisconnect()
			ConOut("FTP Desconectado!")		
		EndIf
	EndIf 	

	ImportCsv()
			
	RestArea(aAlias)
	rpcclearenv()
Return

Static Function ImportCsv
	Local aArea		:= GetArea()
	Local cEnvServ	:= GetEnvServer()
	Local cIniFile	:= GetADV97()
	Local cEnd		:= GetPvProfString(cEnvServ,"StartPath","",cIniFile)   
	Local cDtHr 	:= DtoS(Date())+"-"+Substr(time(),1,2)+"-"+Substr(time(),4,2)+"-"+Substr(time(),7,2)  
	Local cPath		:= "\web\FtpTotalExpress\recebidos\"                                                
	Local cExt		:= "*.csv"
	Local cTipoLog	:= "Import_"
	Local cNomeLog	:= cTipoLog+cDtHr+"_Log.txt"
	Local cArq		:= cPath+cNomeLog   
	Local cLinha 	:= ""     
	Local cCdAlias	:= "" 
	Local cDelim	:= ";"
	Local nHdl    	:= 0      	
	Local nCont		:= 0
	Local nX		:= 0
	Local aLog		:= {}
	Local aArq		:= {}
	Local aCols		:= {}
	Local aRegs		:= {}
	Local lGrava	:= .T.	
	Local lFirst	:= .T.
	Local lRet		:= .T.
	Private lErrFst := .F.	
	Private nQtRegG	:= 0
	Private nQtNOkG	:= 0
	Private nQtOkG	:= 0	
	Private nQtReg	:= 0
	Private nQtNOk	:= 0
	Private nQtOk	:= 0
	Private nQtArq	:= 0
	
	MakeDir(cPath)
	
	aArq := Directory(cPath+cExt)
	
	//Validacao do arquivo para importacao            
	If Empty(aArq) 
		RestArea(aArea)
		Return
	EndIf		
	
	cArqAnt := ""
	For nX:=1 To Len(aArq)
		nQtArq ++	
		//Validacao do arquivo para importacao            
		If !File(cPath+aArq[nX][1])
			ConOut("Problemas com arquivo informado! "+aArq[nX][1])
			RestArea(aArea)
			Return
		EndIf

		cArqAnt := ""
		If cArqAnt !=  aArq[nX][1] 	
			cArqAnt := aArq[nX][1]
			
			lErrFst := .T. 		
			//³Inicia Log 
			If lFirst
				lFirst := .F.                           
				CabecLog(@aLog,aArq,nX,cDelim,lGrava)
			Else 
				AAdd(aLog, '' )	
				AAdd(aLog, Replicate( ':', 105 ) )
				AAdd(aLog, 'ARQUIVO IMPORT.....: ' + aArq[nX][1] )
				AAdd(aLog, Replicate( ':', 105 ) )
				AAdd(aLog, '' )	
			EndIf
		EndIF
		
		//³Leitura do arquivo                        ³
		FT_FUSE(cPath+aArq[nX][1])
		nTot := FT_FLASTREC()
		nAtu := 0
		
		FT_FGOTOP()
		Do While !FT_FEOF()
			nAtu++
			cLinha := LeLinha() //FT_FREADLN()
			
			If Empty(cLinha)
				FT_FSKIP()
				Loop
			EndIf 
			aCols := {}
			aCols := TrataCols(cLinha,cDelim)
			If !Empty(aCols)  
				cDoc	:= aCols[2]
				cSerie	:= aCols[3]
				cObjeto := aCols[1]
				cEmiss	:= aCols[4]				
				lRet := GravaZ03(cDoc,cSerie,cObjeto,cEmiss,@aLog)
			EndIf
			FT_FSKIP()
		EndDo 
	
		FT_FUSE()
		
		If lRet
			fErase(cPath+aArq[nX][1])	
		EndIf
		AAdd(aLog, '' )	
		AAdd(aLog, "Import = Total de Registros = "+ Alltrim(Str(nQtReg)))
		AAdd(aLog, "Import = Registros Nao importados = "+ Alltrim(Str(nQtNOk)))
		AAdd(aLog, "Import = Registros importados = "+ Alltrim(Str(nQtOk)))
		
		nQtReg	:= 0
		nQtNOk	:= 0
		nQtOk	:= 0
		
	Next nX
    
	MsgAvul("INFORMAÇÕES GERAIS", @aLog)
	
	AAdd(aLog, "Import = Total de Arquivos Importados = "+ Alltrim(Str(nQtArq)))
	AAdd(aLog, "Import = Total de Registros = "+ Alltrim(Str(nQtRegG)))
	AAdd(aLog, "Import = Registros Nao importados = "+ Alltrim(Str(nQtNOkG)))
	AAdd(aLog, "Import = Registros importados = "+ Alltrim(Str(nQtOkG)))
	AAdd(aLog, "Import = FIM Data "+DtoC(Date())+ " as "+Time() )

	//Finaliza arquivo de Log                         
	nHdl  := 	fCreate(cArq)
	If nHdl == -1
		&&MsgAlert("O arquivo  "+cNomeLog+" nao pode ser criado!","Atencao!")
		fClose(nHdl)
		fErase(cArq)
		RestArea(aArea)
	 	Return()
	EndIf
		
	For nCont:=1 to Len(aLog)			
		fWrite(nHdl,aLog[nCont]+CRLF)
		ConOut(aLog[nCont]+CRLF)
		//fClose(nHdl)
	    //fErase(cArq)
	Next
				
	fClose(nHdl)
	
	MakeDir("C:\edi_totalexpress\logimport")
	__CopyFile(cArq, "C:\edi_totalexpress\logimport\"+cNomeLog)	
	 
	ConOut("Verifique arquivo de log "+cNomeLog+" na pasta "+cPath)
	RestArea(aArea)
Return 

Static Function LeLinha()
	Local cLinhaTmp  := ""
	Local cLinhaM100 := ""
	
	cLinhaTmp := FT_FReadLN()
	
	If !Empty(cLinhaTmp)
		cIdent:= Substr(cLinhaTmp,1,1)
		If Len(cLinhaTmp) < 1023
			cLinhaM100 := cLinhaTmp
		Else
			cLinAnt := cLinhaTmp
			cLinhaM100 += cLinAnt
			Ft_FSkip()
			cLinProx:= Ft_FReadLN()
			If Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent
				While Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent .and. !Ft_fEof()
					cLinhaM100 += cLinProx
					Ft_FSkip()
					cLinProx := Ft_fReadLn()
					If Len(cLinProx) < 1023 .and. Substr(cLinProx,1,1) <> cIdent
						cLinhaM100 += cLinProx
					Endif
				Enddo
			Else
				cLinhaM100 += cLinProx
			Endif
		Endif
	Endif

Return(cLinhaM100)

Static Function TrataCols(cLinha,cSep)
	Local aRet 		:= {}
	Local nPosSep	:= 0
	
	nPosSep	:= At(cSep,cLinha)
	While nPosSep <> 0
		AAdd(aRet, SubStr(cLinha,1,nPosSep-1)  )
		cLinha := SubStr(cLinha,nPosSep+1)
	 	nPosSep	:= At(cSep,cLinha)
	EndDo	
	AAdd(aRet, cLinha )
Return aRet

Static Function GravaZ03(cDoc,cSerie,cObjeto,cEmiss,aLog)
	Local nJ := 0
	Local lRet:=.T.
	dbSelectArea('Z03')		
	Z03->(dbSetOrder(1))  //Z03_FILIAL+Z03_DOC+Z03_SERIE+Z03_OBJETO+Z03_EMISSA                                                                                                              
	
	nQtReg++
	nQtRegG++
		
	If !dbSeek(xFilial("Z03")+ StrZero(Val(cDoc),TamSx3("Z03_DOC")[1]) + PADR(cSerie,TamSx3("Z03_SERIE")[1])+PADR(cObjeto,TamSx3("Z03_OBJETO")[1]))// + SToD(DToS(cToD(cEmiss))) )
		nQtOk++
		nQtOkG++
		lErrFst := .T.
		ConOut(StrZero(val(cSerie)	,TamSx3("Z03_SERIE")[1]))		
		Begin Transaction
			If RecLock("Z03",.T.)
	            Z03->Z03_FILIAL := PADR(xFilial("Z03")	,TamSx3("Z03_FILIAL")[1])
	            Z03->Z03_DOC	:= StrZero(Val(cDoc),TamSx3("Z03_DOC")[1])	
	            Z03->Z03_SERIE	:= StrZero(Val(cSerie)	,TamSx3("Z03_SERIE")[1])
	            Z03->Z03_EMISSA := SToD(DToS(cToD(cEmiss))) //cToD(aRegs[nJ,04])
	            Z03->Z03_HORA	:= cHora
	            Z03->Z03_OBJETO	:= PADR(cObjeto,TamSx3("Z03_OBJETO")[1])
	            //Z03->Z03_USERGI	:=  
				Z03->(MsUnlock())  
				
				AAdd(aLog,  "Z03_FILIAL : "+PADR(xFilial("Z03"),4)  +" "+;
							"Z03_DOC	: "+StrZero(Val(cDoc),9) 	+" "+;
							"Z03_SERIE  : "+StrZero(Val(cSerie),3) 	+" "+;
							"Z03_EMISSA : "+PADR(cEmiss,8)    		+" "+; 
							"Z03_OBJETO : "+PADR(cObjeto,10)	 		)
			Else
				If lErrFst
					MsgAvul("	ERROR ----> RECLOCK ERROR", @aLog)
					lErrFst := .F.
				EndIf					
				lRet := .F.
				nQtNOk++					
				nQtNOkG++					
			EndIf
		End Transaction 
	Else
		/*IF lErrFst
			MsgAvul("	ERROR ----> REGISTRO(S)JÁ EXISTENTE(S) NA BASE DE DADOS", @aLog)
			lErrFst := .F.			
		EndIf*/
		//lRet := .F.			
		AAdd(aLog,  "Z03_FILIAL : "+PADR(xFilial("Z03"),4)  +" "+;
					"Z03_DOC	: "+StrZero(Val(cDoc),9) 	+" "+;
			   		"Z03_SERIE  : "+StrZero(Val(cSerie),3) 	+" "+;
					"Z03_EMISSA : "+PADR(cEmiss,8)    		+" "+; 
					"Z03_OBJETO : "+PADR(cObjeto,10)	 	+" --> Registro Já Existente do Banco de Dados!"	)
		nQtNOk++					
		nQtNOkG++
	EndIf				
	
Return lRet

Static Function CabecLog(aLog,aArq,nX,cDelim,lGrava)
	AAdd(aLog, Replicate( '=', 105 ) )
	AAdd(aLog, 'INICIANDO O LOG - I M P O R T A C A O   D E   D A D O S' )
	AAdd(aLog, Replicate( '-', 105 ) )
	AAdd(aLog, 'DATABASE...........: ' + DtoC( Date() ) )
	AAdd(aLog, 'DATA...............: ' + DtoC( Date() ) )
	AAdd(aLog, 'HORA...............: ' + Time() )
	AAdd(aLog, 'ENVIRONMENT........: ' + GetEnvServer() )
	AAdd(aLog, 'PATCH..............: ' + GetSrvProfString( 'StartPath', '' ) )
	AAdd(aLog, 'ROOT...............: ' + GetSrvProfString( 'RootPath', '' ) )
	AAdd(aLog, 'VERSÃO.............: ' + GetVersao() )
    //AAdd(aLog, 'EMPRESA / FILIAL...: ' + SM0->M0_CODIGO + '/' + SM0->M0_CODFIL )
	//AAdd(aLog, 'NOME EMPRESA.......: ' + Capital( Trim( SM0->M0_NOME ) ) )
	//AAdd(aLog, 'NOME FILIAL........: ' + Capital( Trim( SM0->M0_FILIAL ) ) )
	AAdd(aLog, 'TABELA IMPORT......: ' + "Z03" )
	AAdd(aLog, 'DELIMITADOR........: ' + cDelim )
	AAdd(aLog, 'MODO PROCESSAMENTO.: ' + IIf(lGrava,"Atualizacao","Simulacao") )
	AAdd(aLog, Replicate( ':', 105 ) )
	AAdd(aLog, '' )	
	AAdd(aLog, "Import = INICIO - Data "+DtoC(Date())+ " as "+Time() )
	AAdd(aLog, '' )	
	AAdd(aLog, Replicate( ':', 105 ) )
	AAdd(aLog, 'ARQUIVO IMPORT.....: ' + aArq[nX][1] )
	AAdd(aLog, Replicate( ':', 105 ) ) 
	AAdd(aLog, '' )	
Return         

Static Function MsgAvul(cMsg, aLog)
	AAdd(aLog, '' )	
	AAdd(aLog, Replicate( '-', 105 ) )
	AAdd(aLog, cMsg )
	AAdd(aLog, Replicate( '-', 105 ) ) 
Return