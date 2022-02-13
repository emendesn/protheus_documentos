#INCLUDE "PROTHEUS.CH"
                 
User Function FtpArq; Return

Class FtpArq       
	Method NewFtpArq() constructor
	Method connect(cServerFTP , nPortaFTP , cUserFTP , cSenhaFTP)   
	Method transfer(aFiles,cDirOri,cDirDest)
	Method disconnect()
EndClass

Method NewFtpArq() Class FtpArq

Return Self
	
Method connect(cServerFTP,nPortaFTP,cUserFTP,cSenhaFTP)   Class FtpArq
	Local lConnect := .F.
	lConnect := FTPConnect(cServerFTP , nPortaFTP , cUserFTP , cSenhaFTP)
	If lConnect 
	   ConOut("Conectado ao FTP")	
	Else
		ConOut("N�o foi poss�vel conectar no ftp")
	EndIf
Return lConnect

Method transfer(cArquivo,cDirOri,cDirDest)  Class FtpArq
	Local ni		:= 0
	Local cArq 		:= "" 
	Local cNomeArq  := ""
	
	Default cDirDest:= ""			
	
	If !Empty(cDirDest)
	    If	FTPDirChange(cDirDest)  
	    	ConOut("Troca de diret�rio efetuada com sucesso !")	    
	    EndIf
	EndIf	

	If	FTPUpload(cDirOri+'\'+cArquivo , cArquivo)
	    ConOut("Upload do arquivo "+cArquivo+" Efetuado com sucesso!!") 
	    If fErase(cDirOri+'\'+cArquivo) == -1
	    	ConOut("N�o foi poss�vel excluir o arquivo!! "+cArquivo)
	    Else 
	    	ConOut("Arquivo exclu�do com sucesso!! "+cArquivo)
	    EndIf
	EndIf
Return Self 

Method disconnect()Class FtpArq
	FTPDisconnect()	
Return