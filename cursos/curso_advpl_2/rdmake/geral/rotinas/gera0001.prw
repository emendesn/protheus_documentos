/*
Programa	: Modulos   
Autor  		: Thomas Galvão     
Data		: 17/10/2012   
Descricao  	: Função Genérica para validação de Usuários não correntes           
Uso        	: Generico                                                    
*/
#Include "Totvs.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "RwMake.ch"

&&Validação de Usuários
User Function GerA0001(cUsrGroup, cMsg,lVld)    
	Local lValida  		:= .F.
	Local lRet  		:= .F.
	Local cTexto		:= ''
	Local nOpc			:= 0
	Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
	Private lUsrAdm		:= .F.
	Private	lVldAdmin	:= IIF(ValType(lVld)=='L',lVld,.F.)
	Private cUsrGrup 	:= IIF(ValType(cUsrGroup) == 'C',cUsrGroup,"") 								 
    
	If lVldAdmin
		&&Valida acesso de usuario                                           
		For i := 1 to Len(aGrupos)		
			&&Usuarios de Autorizado a entrar no Modulo
			If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores/"+cUsrGrup 
		  		Return .T.
			Else
				If Upper(AllTrim(GRPRetName(aGrupos[i]))) $ Upper(cUsrGrup)
					lValida := .T.			
				EndIf				
			EndIf		
		Next i
	EndIf
		
	If !lValida
		cTexto 	:= cMsg
		nOpc 	:= Aviso("Acesso Restrito", cTexto, {"Lib. Admin.","Sair"})
		
		If nOpc == 1 
			lRet := VldAdmin()
			If lRet
				Return .T.
			EndIf
		EndIf
	EndIF
		       
Return lRet

&&Valida senha do Administrador que está efetuando liberação
Static Function VldAdmin()
	Local oGetSenha
	Local cGetSenha := Space(30)
	Local oGetUser
	Local cGetUser  := Space(30)
	Local oSenha
	Local oTelAdmin
	Local oUser
	Local lRet 		:= .F.
	Local nRet		:= 0
	Local nOpca		:= 0
	Local cMsgLogIn := ""
	Local aGrupLib	:= {} 
	Static oDlg

  	DEFINE MSDIALOG oDlg TITLE "Administrador" FROM 000, 000  TO 150, 300 COLORS 0, 16777215 PIXEL
	    @ 001, 003 GROUP oTelAdmin TO 071, 148 PROMPT "Login" 	  OF oDlg COLOR 0, 16777215 PIXEL
	    @ 020, 045 MSGET oGetUser 	VAR cGetUser 	SIZE 087, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 040, 045 MSGET oGetSenha 	VAR cGetSenha 	SIZE 087, 010 OF oDlg COLORS 0, 16777215 PASSWORD PIXEL 
	    @ 020, 010 SAY oUser 	PROMPT "Usuário:" 	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 040, 010 SAY oSenha 	PROMPT "Senha" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
	    DEFINE SBUTTON oSButton1 FROM 055, 075 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON oSButton2 FROM 055, 105 TYPE 2 ACTION (oDlg:End(),nOpca:=2) ENABLE OF oDlg	    
  	ACTIVATE MSDIALOG oDlg CENTERED
  	
  	If nOpca == 1		
  	
  	    If lVldAdmin
	  	  	nRet := PswAdmin(cGetUser, cGetSenha)
		  	Do Case
			  	Case nRet == 0
			  		lRet := .T.
			  	Case nRet == 1
			   		MsgAlert("Usuário não pertence ao grupo de Administradores")
			  		lRet := .F.
			  	Case nRet == 2 
			  		MsgAlert("Usuário não encontrado")
		  			lRet := .F.
			 	Case nRet == 3
			 		MsgAlert("Arquivo de senha sendo utilizado por outra estação")
		  			lRet := .F.
		  	EndCase
	  	
	  	Else
   //  		aGrupLib :=	aClone(UsrRetGRP(, cGetUser) )
     		aGrupLib :=	aClone(UsrRetGRP(cGetUser, ) )
	  		
		  	For i := 1 to Len(aGrupLib)		
				&&Usuarios de Autorizado a entrar no Modulo
				If AllTrim(GRPRetName(aGrupLib[i])) $ "Administradores/"+cUsrGrup
					PswOrder(2)      
					If PswSeek(cGetUser, .T.)             
						If PswName(cGetSenha)
							lRet := .T.								
						EndIf
					EndIf					
				EndIf		
			Next i
			
			If !lRet
				apMsgStop("Não foi possivel efetuar logIn, verifique Usuário e Senha informado!")			
			EndIf
		EndIf		
	EndIf
  	
Return lRet  