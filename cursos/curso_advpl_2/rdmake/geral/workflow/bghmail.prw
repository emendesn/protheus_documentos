#include "protheus.ch"
#include "ap5mail.ch
/*
rotina para enviar e-mail

*/



USER FUNCTION BGHMAIL(cPara,cCC,cAssunto,cMsg)

Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local lAuth := .f.
Local lOk := .t.
Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
Private cEmail   := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
Private cPass    := Trim(GetMV("MV_RELPSW"))  // 123abc
Default cCC := ""
Default cAssunto := "BGHMAIL"
Default cMsg     := "BGHMAIL"
                                                      
u_GerA0003(ProcName())

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn
   GET MAIL ERROR cError
   memowrit("BGHMAIL_CONNECT_ERROR.LOG",cError)
   Return(.F.)
Endif                    


lAuth    := GetMv("MV_RELAUTH")
If lAuth
	lOk := MailAuth(cEmail,cPass)
 	If !lOk 
        memowrit("BGHMAIL_AUTH_ERROR.LOG","Conta:"+cEMail+" Senha: "+cPass )
	EndIf
EndIf


SEND MAIL FROM cEmail TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend

If !lResulSend
   GET MAIL ERROR cError
   memowrit("BGHMAIL_SEND_ERROR.LOG",cError)
Endif

DISCONNECT SMTP SERVER



return(nil)