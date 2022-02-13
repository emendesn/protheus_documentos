#INCLUDE "PROTHEUS.CH"                        
#include "TbiConn.ch"
#include "TbiCode.ch"

#IFNDEF CRLF
#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ENVIAEMAIL�Autor  �Microsiga           � Data �  12/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exp1 - Titulo do email                                      ���
���          �Exp2 - destinantarios                                       ���
���          �Exp3 - Destainatarios ocultos                               ���
���          �Exp4 - Corpo da mensagen                                    ���
���Desc.     �Exp5 - Local do Arquivo                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ENVIAEMAIL(cTitulo,cDestina,cCco,cMensagem,Path)
Local lResult   	:= .F.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cDestin 		:= cDestina
Local cCopia 		:= IIf(cCco==NIL,"",cCco)
Local cTitulo 		:= cTitulo
Local cMensagem		:= cMensagem
Local cAttachment 	:=  Path
Local lAutentica    := GetMV("MV_RELAUTH") //Renato S. Parreira - 29/01/07
Local cdominio := "@bgh.com.br"  // Incluso Edson Rodrigues - 13/03/10
//����������������������������������������Ŀ
//� Tenta conexao com o servidor de E-Mail �
//������������������������������������������
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  Alltrim(SUBSTR(GetMV("MV_RELACNT"),5)); 	// Nome da conta a ser usada no e-mail
PASSWORD Alltrim(GetMV("MV_RELPSW")) ; 	// Senha
RESULT   lResult             	// Resultado da tentativa de conex�o
If !lResult
	//�����������������������������������������������������Ŀ
	//� Nao foi possivel estabelecer conexao com o servidor �
	//�������������������������������������������������������
	Help(" ",1,"ACAA170_01") 	// _cErro := MailGetErr()
Else
	//Renato S. Parreira - 29/01/07 - Verifica se o E-mail necessita de Autenticacao
	if lAutentica	
		MailAuth(Alltrim(SUBSTR(GetMV("MV_RELACNT"),5)),Alltrim(GetMV("MV_RELPSW")))	
	endif
	SEND MAIL;
	FROM 		SUBSTR(GetMV("MV_RELACNT"),5)+cdominio;
	TO 		    cDestin;
	CC			cCopia;
	SUBJECT 	cTitulo;
	BODY 		cMensagem;
	ATTACHMENT cAttachment;
	RESULT 	lResult
	//�������������������������������������������Ŀ
	//� Finaliza conexao com o servidor de E-Mail �
	//���������������������������������������������
	DISCONNECT SMTP SERVER
EndIf

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMPEMAIL �Autor  �                    � Data �    /  /     ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function COMPEMAIL(cTitulo,cDestina,cCco,cMensagem,Path)
Local lResult   	:= .f.	
Local cDestin 		:= cDestina
Local cTitulo 		:= cTitulo
Local cMensagem		:= cMensagem
Local cAttachment 	:=  Path
Local lAutentica    := GetMV("MV_RELAUTH") 
Local cdominio := "@bgh.com.br" 

//����������������������������������������Ŀ
//� Tenta conexao com o servidor de E-Mail �
//������������������������������������������
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  AllTrim(GetMV("MV_MAILCOM")); 	// Nome da conta a ser usada no e-mail
PASSWORD AllTrim(GetMV("MV_PASSCOM")) ; 	// Senha
RESULT   lResult             	// Resultado da tentativa de conex�o
If !lResult
	//�����������������������������������������������������Ŀ
	//� Nao foi possivel estabelecer conexao com o servidor �
	//�������������������������������������������������������
	Help(" ",1,"ACAA170_01") 	// _cErro := MailGetErr()
Else
	if lAutentica	
		MailAuth(AllTrim(GetMV("MV_MAILCOM")),AllTrim(GetMV("MV_PASSCOM")))	
	endif
	SEND MAIL;
	FROM 	AllTrim(GetMV("MV_MAILCOM"))+cdominio;
	TO 		cDestin;
	SUBJECT cTitulo;
	BODY 	cMensagem;
	ATTACHMENT cAttachment;
	RESULT 	lResult
	//�������������������������������������������Ŀ
	//� Finaliza conexao com o servidor de E-Mail �
	//���������������������������������������������
	DISCONNECT SMTP SERVER
EndIf