#INCLUDE "PROTHEUS.CH"                                  
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GerTxtSedex(aListPost)

//******************************************************************
// GERA ARQUIVO TXT
//******************************************************************

Private cDirProt  := "\saraftp\"
Private cArqTxt   := ""
Private cLocDir   := ""
Private nHdl      := 0
Private nSeqAux	  := 0 

If Len(aListPost) > 0

	If !File(cDirProt)
		MakeDir(cDirProt)
	EndIf
	
	cArqTxt   := "BGHMD"+SubStr(DtoS(Date()),7,2)+SubStr(DtoS(Date()),5,2)+SubStr(DtoS(Date()),3,2)+SubStr(TIME(),1,2)+SubStr(TIME(),4,2)+SubStr(TIME(),7,2)+".TXT"  
	cLocDir   := "\\172.16.0.5\Microsiga\protheus_data"+cDirProt 
	
	//cLocDir := "C:\000000\teste"+cDirProt
	
	nHdl      := fCreate(cLocDir+cArqTxt)
	
	//Lay-out do arquivo de importa็ใo da Lista de Postagem do Sistema SARA 
	 
	//*****************************************************************************************************************
	// TIPO DE REGISTRO: 3  (Lista de Postagem)
	//*****************************************************************************************************************
	
	For nx:= 1 to Len(aListPost)
	
		nTamLin:= 228
		cLin   := Space(nTamLin) 
		cLin   := Stuff(cLin,001,001, aListPost[nx][1])                                            					//01-Tipo 3 - Lista de Postagem
		cLin   := Stuff(cLin,002,002, Strzero(0,2) )                                								//02-Filler 
		cLin   := Stuff(cLin,004,004, Strzero(0,4) )                                 								//03-Filler
		cLin   := Stuff(cLin,008,004, Strzero(0,4) )                                 								//04-Filler
		cLin   := Stuff(cLin,012,008, Strzero(0,8) )                                								//05-Filler
		cLin   := Stuff(cLin,020,004, Strzero(0,4))                    												//06-Filler
		cLin   := Stuff(cLin,024,010, aListPost[nx][2] )                                          					//07-N๚mero do Contrato
		cLin   := Stuff(cLin,034,008, aListPost[nx][3] )                                   							//08-C๓digo Administrativo
		cLin   := Stuff(cLin,042,008, strTran(aListPost[nx][4],"-") )          										//09-CEP do Destino
		cLin   := Stuff(cLin,050,005, aListPost[nx][5] )                         									//10-C๓digo do Servi็o (SFI)
		cLin   := Stuff(cLin,055,002, Strzero(0,2))                                             					//11-Grupo Paํs Conforme Tab. Grupo Paํs
		cLin   := Stuff(cLin,057,002, aListPost[nx][6])                                                 			//12-C๓d. Serv Adic. 1 Conforme Tab. Serv. Adic.
		cLin   := Stuff(cLin,059,002, Strzero(0,2) )                                            					//13-C๓d. Serv Adic. 2 Conforme Tab. Serv. Adic.
		cLin   := Stuff(cLin,061,002, Strzero(0,2) )                                            					//14-C๓d. Serv Adic. 3 Conforme Tab. Serv. Adic.	
		cLin   := Stuff(cLin,063,008, Strzero(0,Len(Alltrim(Transform(aListPost[nx][7],"@E 99999.99" ))))+Alltrim(Transform(aListPost[nx][7],"@E 99999.99" )) )	//15-Valor Declarado
		cLin   := Stuff(cLin,071,009, Strzero(0,9) )                                            					//16-Filler
		cLin   := Stuff(cLin,080,002, Strzero(0,2) )                                            					//17-Filler
		cLin   := Stuff(cLin,082,009, Strzero(Val(SubStr(aListPost[nx][8],3,9)),9))                					//18-N๚mero da Etiqueta	
		cLin   := Stuff(cLin,091,005, Strzero(aListPost[nx][15],5) )               									//19-PESO Peso (gr)		
		cLin   := Stuff(cLin,096,008, Strzero(0,8) )                                            					//20-Filler
		cLin   := Stuff(cLin,104,002, Strzero(0,2) )                                            					//21-Filler	
		cLin   := Stuff(cLin,106,002, Strzero(0,2) )                                   								//22-Filler
		cLin   := Stuff(cLin,108,008, Strzero(0,8) ) 																//23-Filler
		cLin   := Stuff(cLin,116,003, Strzero(0,3) )                                            					//24-Filler
		cLin   := Stuff(cLin,119,002, Strzero(0,2) )                                            					//25-Filler
		cLin   := Stuff(cLin,121,008, Strzero(0,8) )                                            					//26-Filler
		cLin   := Stuff(cLin,129,008, Strzero(0,8) )                                            					//27-Filler
		cLin   := Stuff(cLin,137,002, Strzero(0,2) )                                            					//28-Filler	
		cLin   := Stuff(cLin,139,011, aListPost[nx][9] )                                       						//29-Nบ do cartใo de postagem	
		cLin   := Stuff(cLin,150,007, SubStr(aListPost[nx][10],3))	                            					//30-N๚mero Nota Fiscal	
		cLin   := Stuff(cLin,157,002, aListPost[nx][11] )															//31-Sigla do Servi็o
		cLin   := Stuff(cLin,159,005, Strzero(20,5) )                                            					//32-Comprimento do objeto
		cLin   := Stuff(cLin,164,005, Strzero(12,5) ) 																//33-Largura do objeto
		cLin   := Stuff(cLin,169,005, Strzero(7,5) )                                            					//34-Altura do objeto	
		cLin   := Stuff(cLin,174,008, Strzero(0,Len(Alltrim(Transform(aListPost[nx][12],"@E 99999.99" ))))+Alltrim(Transform(aListPost[nx][12],"@E 99999.99" )))//35-Valor a cobrar do destinatario 	
		cLin   := Stuff(cLin,182,040, PADL(aListPost[nx][13],40) )                               					//36-Nome do destinatแrio	
		cLin   := Stuff(cLin,222,003, Strzero(2,3) )                                 		   						//37-C๓digo do Tipo de Objeto conforme 01 - Envelope / 02 - Pacote / 03 - Rolo
		cLin   := Stuff(cLin,225,005, Strzero(0,5) )  																//38-Diโmetro do objeto
		cLin   += CRLF 
	      
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert(OemToAnsi("Ocorreu um erro na grava็ใo do arquivo. Continua ? "),OemToAnsi("Aten็ใo ! "))
				RETURN
			Endif
		Endif
	    
	    nSeqAux:= nSeqAux+1
	    	    
	Next nx
	
	nSeqAux:= nSeqAux+1
	
	// TIPO DE REGISTRO: 9 (TRAILER)
	//*****************************************************************************************************************
	nTamLin:= 138
	cLin   := Space(nTamLin) 
	cLin   := Stuff(cLin,001,001, "9")                                                   //01-TIPO 9 = Trailer
	cLin   := Stuff(cLin,002,008, StrZero(nSeqAux,8))                                    //02-Quantidade de Registros
	//cLin   := Stuff(cLin,010,129, Space(129) )                                         //03-FILLER
	
	cLin   += CRLF 
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert(OemToAnsi("Ocorreu um erro na grava็ใo do arquivo. Continua ? "),OemToAnsi("Aten็ใo ! "))
			RETURN
		Endif
	Endif  
	
	//FECHA O ARQUIVO TXT
	fClose(nHdl) 
	
	//GRAVA ARQUIVO NO FTP DOS CORREIOS
	If GravaFTP(cLocDir,cArqTxt)
		Aviso(OemToAnsi("Gera็ใo Finalizada"),"Arquivo "+cArqTxt+" gerado com sucesso!",{"&Ok"}) 
	Else
		Alert(OemToAnsi("Ocorreu um erro no upload do arquivo ao FTP."),OemToAnsi("Aten็ใo ! "))
	EndIf	
EndIf	

Return                                                            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaFTP(cDir,cFile)
                                
Local cServer	:= 	"transferspm.correios.com.br"
Local nPorta  	:=	21
Local cUser   	:= 	"saraftpsongap"
Local cPass   	:= 	"SON384gap" 
Local cDirAtual	:= 	"" 
Local lRet		:= 	.T.                                     

//DESCONECTA DO FTP 
FTPDisconnect()

//CONECTA NO FTP 
If !FtpConnect(cServer, nPorta, cUser, cPass)
	MsgAlert(" Erro! Nใo foi possํvel estabelecer a conexใo com o SERVIDOR FTP!")
    Return (.F.)
EndIf                                 

//BUSCA O DIRETORIO ATUAL DO FTP
cDirAtual := FTPGetCurDir()

//MUDA PARA O DIRETORIO ATUAL DO FTP
FTPDirChange(cDirAtual)

//FAZ O UPLOAD DO ARQUIVO NO FTP	
If !FTPUpLoad( cDirProt+cFile , Lower(cFile) )
	ConOut('Arquivo nใo transmitido para o FTP.! '+ cFile)
	lRet		:= 	.F.                                    	
EndIf

//DESCONECTA DO FTP 
FTPDisconnect()
                                                                      
Return( lRet )