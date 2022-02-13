/*
Programa	: MODULOS   
Autor  		: Thomas Galvão     
Data		: 16/08/2012   
Descricao  	: FUNCOES APLICADAS NA INICIALIZACAO DOS MODULOS              
Uso        	: GENERICO                                                    
*/
#Include "Totvs.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "RwMake.ch"
                                                    
User Function AfterLogin()
	Local cId	:= ParamIXB[1]
	Local cNome := ParamIXB[2]

//u_GerA0003(ProcName())
	
	IF Upper(GetEnvServer()) == "EMERGENCRH" .AND. ALLTRIM(CMODULO) $ "GPE/PON"
   		MsgAlert("Favor usar o ambiente BDB para acessar esse módulo")
     	KillApp(.T.)
	
	ElseIf !Upper(GetEnvServer()) $ AllTrim(Upper(GetMv("MV_ZZAMBLI")))
		ValidUser()
	
	EndIf
Return

User Function MDIOK()
	IF Upper(GetEnvServer()) == "EMERGENCRH" .AND. ALLTRIM(CMODULO) $ "GPE/PON"
   		MsgAlert("Favor usar o ambiente BDB para acessar esse módulo")
     	KillApp(.T.)

	elseif !Upper(GetEnvServer()) $ ('BDB/UPD/JOB/ACD') //AllTrim(Upper(GetMv("MV_ZZAMBLI"))) Não Lê SX6 na inicialização!
		ValidUser()
	EndIf
Return

&&Validação de Usuários
Static Function ValidUser()    
	Local lValida  		:= .F.
	Local cTexto		:= ''
	Local nOpc			:= 0
	Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
	Private lUsrAdm		:= .F.								 

	&&Valida acesso de usuario                                           
	For i := 1 to Len(aGrupos)		
		&&Usuarios de Autorizado a entrar no Modulo
		If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores"
			Return
		Else
			If Upper(AllTrim(GRPRetName(aGrupos[i]))) $ Upper(GetEnvServer())
				lValida := .T.			
			EndIf				
		EndIf		
	Next i
	
	If !lValida
		cTexto 	:= "Ambiente " + Alltrim(Upper(GetEnvServer()))+ " é de uso Exclusivo para testes, para liberação, contate o Administrador do Sistema!"
		nOpc 	:= Aviso("Acesso Restrito", cTexto, {"Lib. Admin.","Sair"})
		
		If nOpc == 1 
			If VldAdmin()
				Return
			Else 
				KillApp(.T.)
		 		Return	
			EndIf
		Else
			KillApp(.T.)
		 	Return					 
		EndIf
	EndIF
		       
Return 

&&Valida senha do Administrador que está efetuando liberação
Static Function VldAdmin()
	Local oGetSenha
	Local cGetSenha := Space(30)
	Local oGetUser
	Local cGetUser  := Space(30)
	Local oSenha
	Local oTelAdmin
	Local oUser
	Local lRet 	:= .F.
	Local nRet	:= 0
	Local nOpca	:= 0
	Static oDlg

  	DEFINE MSDIALOG oDlg TITLE "Administrador" FROM 000, 000  TO 150, 300 COLORS 0, 16777215 PIXEL
	    @ 001, 003 GROUP oTelAdmin TO 071, 148 PROMPT "Login" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 020, 045 MSGET oGetUser VAR cGetUser SIZE 087, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 040, 045 MSGET oGetSenha VAR cGetSenha SIZE 087, 010 OF oDlg COLORS 0, 16777215 PASSWORD PIXEL 
	    @ 020, 010 SAY oUser PROMPT "Usuário:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 040, 010 SAY oSenha PROMPT "Senha" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
	    DEFINE SBUTTON oSButton1 FROM 055, 075 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON oSButton2 FROM 055, 105 TYPE 2 ACTION (oDlg:End(),nOpca:=2) ENABLE OF oDlg	    
  	ACTIVATE MSDIALOG oDlg CENTERED
  	
  	If nOpca == 1
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
		lRet := .F.
	EndIf
  	
Return lRet  