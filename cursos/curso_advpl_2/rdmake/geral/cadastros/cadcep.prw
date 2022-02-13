#INCLUDE "rwmake.ch"
#INCLUDE 'TOPCONN.CH'

/*
±±ºPrograma  ³CADACEP   º Autor ³ Edson rodrigues    º Data ³  30/04/11 
±±ºDescricao ³ Cadastro de CEP 
*/
User Function CADCEP()
	
	Private cCadastro := "Cadastro de CEP"
	Private cAlias := "Z07"
	Private aRotina := { 	{'Pesquisar' , "AxPesqui"  , 0,1},;   //"Pesquisar"
	{'Visualizar', "AxVisual"  , 0,2},;   //"Visualizar"
	{'Incluir', "u_Incaltc(3)"  , 0,3},;   //"Incluir"
	{'Alterar', "u_Incaltc(4)"  , 0,4},;   //"alterar"
	{"Excluir"    ,"AxDeleta" ,0,5}}
	
	DbSelectArea("Z07") //Cadastro de Acessórios
	Z07->(DBSetOrder(1))
	mBrowse( 6,1,22,75,cAlias, , , , , ,)

Return

/*
±±ºPrograma  ³Incaltc   º Autor ³ Edson rodrigues    º Data ³  30/04/11   
±±ºDescricao ³ Inclusao, alteracao e Validacao do CEP                     
*/
User Function IncAltc(nOpc)
	Local ocbair
	Local oclogr
	Private cZ07CEP  := SPACE(TAMSX3("Z07_CEP")[1])
	Private cZ07UF   := SPACE(TAMSX3("Z07_UF")[1])
	Private cZ07MUN  := SPACE(TAMSX3("Z07_MUNIC")[1])
	Private cZ07BAR  := SPACE(TAMSX3("Z07_BAIRRO")[1])
	Private cZ07TLGR := SPACE(TAMSX3("Z07_TPLOGR")[1])
	Private cZ07LGRD := SPACE(TAMSX3("Z07_LOGRAD")[1])
	Private OdlCadcep
	Private nReg     := 0

u_GerA0003(ProcName())

	
	DbSelectArea("Z07")
	Dbsetorder(4)
	
	If nOpc==4		
		nReg   := Z07->(recno())
		cZ07CEP  := Z07->Z07_CEP
		cZ07UF   := Z07->Z07_UF
		cZ07MUN  := Z07->Z07_MUNIC
		cZ07BAR  := Z07->Z07_BAIRRO
		cZ07TLGR := Z07->Z07_TPLOGR
		cZ07LGRD := Z07->Z07_LOGRAD
	EndIf
	
	@ 116,095 To 370,605 Dialog OdlCadcep Title OemToAnsi("Cadastro de CEP ")
	@ 002,009 To 115,250 Title OemToAnsi("Dados")
	
	@ 011,015 Say OemToAnsi("CEP :")             Size 29,8
	@ 024,015 Say OemToAnsi("Estado : ")          Size 29,8
	@ 038,015 Say OemToAnsi("Municipio :")       Size 29,8
	@ 051,015 Say OemToAnsi("Bairro :")            Size 29,8
	@ 064,015 Say OemToAnsi("Tipo Logradouro :")  Size 41,8
	@ 078,015 Say OemToAnsi("Logradouro :")       Size 33,8
	
	@ 011,042 Get cZ07CEP  Size 050,015 Picture "@!" when iif(nOpc==4,.f.,.t.)  valid !vazio() .And. CarMun(cZ07CEP,@cZ07UF,@cZ07MUN, @ocbair)   Object occep
	@ 024,042 Get cZ07UF   Size 020,015 Picture "@!" valid ExistCpo('SX5','12'+cZ07UF) F3 "12" Object ocuf
	@ 038,042 Get cZ07MUN  Size 095,015 Picture "@!" valid ExistCpo('CC2',cZ07UF+cZ07MUN,4) F3 "CC2COD" Object ocmun
	@ 051,042 Get cZ07BAR  Size 095,015 Picture "@!" valid !Vazio()  Object ocbair
	@ 064,057 Get cZ07TLGR Size 060,015 Picture "@!" valid ExistCpo('Z08') F3 "Z08" Object octplgr
	@ 078,057 Get cZ07LGRD Size 190,015 Picture "@!" valid !Vazio().And. VldLograd(cZ07LGRD, @oclogr) Object oclogr
	
	@ 100, 140 BMPBUTTON TYPE 1 ACTION (u_ValdCep(nOpc,nReg),Close(OdlCadcep))
	@ 100, 170 BMPBUTTON TYPE 2 ACTION (.f., Close(OdlCadcep))
	
	Activate MSDialog OdlCadcep Centered

return

/*
±±ºPrograma  ³valdcep   º Autor ³ Edson rodrigues    º Data ³  31/04/11   º±±
±±ºDescricao ³ Validacao dos dados digitados do cadastro de  CEP          º±±
*/
User Function ValdCep(nOpc,nReg)
	local lret:=.f.              
	
	Z07->(dbSetOrder(4))
	If !Empty(cZ07CEP) .And. !Empty(cZ07UF) .And. !Empty(cZ07MUN) .And. !Empty(cZ07BAR) .And. !Empty(cZ07TLGR) .And. !Empty(cZ07LGRD)
		If nOpc==3 .And. Z07->(Dbseek(xfilial("Z07") + cZ07CEP + cZ07TLGR + cZ07LGRD + cZ07BAR + cZ07MUN +  cZ07UF))
			MsgAlert("Esse cadastro de CEP ja existe. Verifique se o cadastro esta correto, consulte o site dos correios "," Cadastro de CEP invalido")
		Else
			lret:=.t.
		EndIf
	ELSE
		MsgAlert("Um ou mais campos estao sem preencher "," Campos nao preenchidos")
	EndIf
		
	If lRet
		If nOpc==3
			Reclock("Z07",.T.)
			Z07->Z07_FILIAL  := XFILIAL("Z07")
			Z07->Z07_CEP     := AllTrim(cZ07CEP)
			Z07->Z07_UF      := AllTrim(cZ07UF)
			Z07->Z07_MUNIC   := AllTrim(cZ07MUN)
			Z07->Z07_BAIRRO  := AllTrim(cZ07BAR)
			Z07->Z07_TPLOGR  := AllTrim(cZ07TLGR)
			Z07->Z07_LOGRAD  := AllTrim(cZ07LGRD)
			MsUnLock()
			
		ELSE
			Z07->(dbGoTo(nReg))
			Reclock("Z07",.F.)
			Z07->Z07_FILIAL  := xFilial("Z07")
			Z07->Z07_CEP     := AllTrim(cZ07CEP)
			Z07->Z07_UF      := AllTrim(cZ07UF)
			Z07->Z07_MUNIC   := AllTrim(cZ07MUN)
			Z07->Z07_BAIRRO  := AllTrim(cZ07BAR)
			Z07->Z07_TPLOGR  := AllTrim(cZ07TLGR)
			Z07->Z07_LOGRAD  := AllTrim(cZ07LGRD)
			MsUnLock()
		EndIf
	EndIf
	
Return(lRet)

Static Function VldLograd(cZ07LGRD, oclogr)
	Local aArea := Z08->(GetArea())
	Local lRet := .F.
	Local CRLF	:=Chr(13)+Chr(10)
	Local MsgErro := ''
	
	If ',' $ cZ07LGRD
		MsgErro += 'Não é Permitido Endereço com número ou Complemento'+CRLF 
		lRet := .T.
	EndIf
	
	DbSelectArea("Z08")
	Z08->(dbSetOrder(1))
	If Z08->(DbSeek(xFilial("Z08")+Substr(cZ07LGRD,1,At(' ',cZ07LGRD))))
		If AllTrim(Z08_TPLOGR) == AllTrim(Substr(cZ07LGRD,1,At(' ',cZ07LGRD)))
			MsgErro += 'Não é Permitido Endereço com Tipo de Logradouro, Ex, Rua, Avenida, Rodovia, etc...'+CRLF
			lRet := .T.
		EndIf
	EndIf
	                               
	If lRet
		MsgAlert(MsgErro)
		oclogr:Setfocus() 
	EndIf
	
	RestArea(aArea)
Return Empty(MsgErro)
	
Static Function CarMun(cZ07CEP, cZ07UF, cZ07MUN, ocbair)
	Local aArea := Z07->(GetArea())
	
	DbSelectArea('Z07')
	Z07->(DbSetOrder(1))
	If Z07->(DbSeek(xFilial('Z07')+cZ07CEP))
		cZ07UF 	:= AllTrim(Z07->Z07_UF)         	
		cZ07MUN := AllTrim(Z07->Z07_MUNIC)		
		ocbair:Setfocus() 
		OdlCadcep:Refresh()
	EndIf

Return .T.
