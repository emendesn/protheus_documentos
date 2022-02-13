#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FTSERPEC ºAutor  ³ Edson Rodrigues    º Data ³  12/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para gerar Pedido do servico prestado e das pecas º±±
±±º          ³ usadas baseado nas saidas de retorno de conserto           º±±
±±º          ³ - Verifica tem PV gerado e ou se tem NF de saida gerada de º±±                              
±±º          ³ retorno de conserto.                                       º±±
±±º          ³ - Gerao pedido de servico e ou peça conforme parametros    º±±
±±º          ³ informado pelo usuário.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FTSERPEC()
Local aSay		:= {}
Local aButton	:= {}
Local nOpc		:= 0
Local cTitulo	:= " Geracao de Pedido de Serviço e ou de Pecas baseado nas devolucoes "
Local cDesc1	:= " Geracao de Pedido de Serviço e ou de Pecas ref. a(s) NFS Devolução a Terceiro, "
Local cDesc2	:= " em que essas devoluções já tenham sido faturadas. "
Local cDesc3	:= " Estão sendo considerados somente Operacoes devidamente configuradas no cadastro "
Local cDesc4	:= " ZZJ- Cadastro de Operações BGH. "
Private cPerg 		:= "FTSEPEC"
Private aGrupos		:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut		:= .F.
Private _agpvser	:= {}
Private _agpvpec	:= {}
Private _agrpitm	:= {}
Private _aconfsa	:= {}
Private _aCabSC5	:= {}
Private _aIteSC6	:= {}
Private _aerros		:= {}
Private _afilser	:= {}
Private _apgtomot	:= {}
Private oV1,oV2,oV3
Private nTamNfe		:= TAMSX3("D1_DOC")[1]
Private nTamNfs		:= TAMSX3("D2_DOC")[1]
Private nTamser		:= TAMSX3("D2_SERIE")[1]
Private nTamcli		:= TAMSX3("A1_COD")[1]
Private nTamime		:= TAMSX3("ZZ4_IMEI")[1]
Private cStartPath	:= GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Private _nTotal		:= 0000
Private _cDefRec	:= ""
Private _cTespec	:= Space(3)
Private _cTesser	:= Space(3)
Private _dtcorte	:= CTOD('01/06/2011')
Private _cEmpVal	:= "02"
Private _cFilVal	:= "01/02/06"
Private _lrpvpgt	:= .F.
Private _dtaltfpc	:= CTOD('01/04/2014')
Private _aitpecas	:= {}
Private _abaiscrd	:= {}
Private _abaixret	:= {}
Private _apecprec	:= {}
Public cTexto	:= ""
Public UltReg	:= .F.
Public _lFechSM	:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função de Log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
u_GerA0003(ProcName())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre as tabelas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('ZAB')
ZAB->(DBSetOrder(1)) //ZAB_FILIAL+ZAB_TPVAL+ZAB_ESTRUT+ZAB_TIPOLI+ZAB_PARTNR
dbSelectArea('SA1')  //Cadastro de Clientes
SA1->(dbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
dbSelectArea('SB1')  //Cadastro de Produtos
SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
dbSelectArea("ZZ4")
ZZ4->(dbSetOrder(1))
dbSelectArea("ZZP")
ZZP->(dbSetOrder(1))
dbSelectArea("SF4")
SF4->(dbsetorder(1))
dbSelectArea("ZZQ")
ZZQ->(dbSetOrder(1))  // ZZQ_FILIAL
dbSelectArea("SZ9")
SZ9->(dbSetOrder(2))  // ZZQ_FILIAL
dbSelectArea("DA1")
DA1->(dbSetOrder(1))  // ZZQ_FILIAL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to Len(aGrupos)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Usuarios de Autorizado a baixar saldo terceiro de armazéns obsoletos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Alltrim(GRPRetName(aGrupos[i])) $ "gerapvservpeca#Administradores"
		lUsrAut  := .T.
	EndIf
Next i
If !lUsrAut
	MsgAlert("Voce nao tem autorizacao para executar essa rotina. Contate o administrador do sistema.","Usuario nao Autorizado")
	Return()
EndIf                                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida Empresa / Filial³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cNumEmp)
	If !(left(cNumEmp,2) $ _cEmpVal .AND. right(cNumEmp,2) $ _cFilVal)
		MsgAlert("Nao é permitido executar essa rotina na empresa/filal : "+left(cNumEmp,2)+"/"+right(cNumEmp,2)+"." ,"Alerta Filial")
		Return
	Else
		If !ApMsgYesNo("Você esta na Filial : "+NameFil(left(cNumEmp,2), right(cNumEmp,2))+". Tem certeza que deseja usar essa rotina nessa filial?","Alerta Filial")
			Return
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
CriaSX1()
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mostrar uma mensagem na tela e as opções disponíveis para o usuário.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )
FormBatch( cTitulo, aSay, aButton )
If nOpc <> 1
	Return Nil
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtra saida devolucao a terceiros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	filsdev()
	If Len(_agpvser) > 0  .OR.  Len(_agpvpec) > 0
		If Len(_agpvser) > 0
			pvgera(1)
		EndIf
		If Len(_agpvpec) > 0
			pvgera(2)
		EndIf
	Else
		MsgAlert("Não foi encontrado saldos em aberto. Confira os parâmetros ." ,"Saldos em aberto não encontrado")
	EndIf
	MsgAlert("Processo Encerrado." ,"Processo Encerrado")
EndIf
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ filsdev  ºAutor  ³Edson Rodrigues     º Data ³  12/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que filtra devolucoes de terceiro conforme criteriosº±±
±±º          ³ e que ainda nao foi feito o pedido de servico e ou pecas   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function filsdev()
Local bAcao		:= {|lFim| Runfilt(@lFim) }
Local cTitulo	:= ""
Local cMsg		:= "Filtrando Saida de devolucao a Terceiros em aberto..."
Local lAborta	:= .T.
Processa( bAcao, cTitulo, cMsg, lAborta )
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RUNFILT  ºAutor  ³Edson Rodrigues     º Data ³  12/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que filtra devolucoes de terceiro conforme criteriosº±±
±±º          ³ e que ainda nao foi feito o pedido de servico e ou pecas   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Runfilt(lFim)
Local _cQuery   := " "
Local _cgroup   := " "
Local _nItemPV  := 0
Local _nSalP3   := 0
Local _cItemPV  := "01"
Local _lFirst   := .T.
Local _aAreaZZ4 := ZZ4->(GetArea())
Local _aAreaZZJ := ZZJ->(GetArea())
Local CR        := chr(13) + chr(10)
Local _cimei    := ""
Local _cLocal   := ""
Local _cprod    := ""
Local _cnfe     := ""
Local _ccli     := ""
Local _cloj     := ""
Local _cNumOsTk := ""
Local _lvloper  := .T.
Local _cmodxest := ""
Local _cmodxvfs := ""
Local cMsgErro  := ""
Local _amodestr := {}
Local _aerrnfil := {}
ZZJ->(dbSetOrder(1)) // ZZJ_FILIAL + ZZJ_OPERA
SB1->(DBSetOrder(1)) //B1_FILIAL+B1_COD
SG1->(DBSetOrder(1)) //G1_FILIAL+G1_COD
SD2->(DBSetOrder(8)) //D2_FILIAL+D2_PEDIDO+D2_ITEMPV
Private lMsErroAuto := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Cliente                             ³
//³ mv_par02 - Loja                                ³
//³ mv_par03 - Operacoes                           ³
//³ mv_par04 - Dt. emiss dev Inicial               ³
//³ mv_par05 - Dt. emiss dev final                 ³
//³ mv_par06 - Gera Pedido ? Servico/Peca/ambos    ³
//³ mv_par07 - Modelo ?                            ³
//³ mv_par08 - NF Devol de :                       ³
//³ mv_par09 - NF Devol ate :                      ³
//³ mv_par10 - Serie NF Devol de :                 ³
//³ mv_par11 - Serie NF Devol ate :                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TRA") > 0
	TRA->(dbCloseArea())
EndIf
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
If Select("TRC") > 0
	TRC->(dbCloseArea())
EndIf
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Empty(mv_par03)
	MsgBox("Favor digitar a(s) operacoes BGH (separados por barras '/').","Operacoes","ALERT")
	Return
EndIf
If MV_PAR04 < _dtcorte
	MsgBox("A data inicial de emissao da NF de devolucao não pode ser menor que a data de corte : "+DTOC(_dtcorte)+".","Dt. Inicial Invalida","ALERT")
	Return
EndIf
If MV_PAR05 < _dtcorte
	MsgBox("A data final de emissao da NF de devolucao não pode ser menor que a data de corte : "+DTOC(_dtcorte)+".","Dt. Final Invalida","ALERT")
	Return
EndIf
If MV_PAR06==3 .AND. date() >= _dtaltfpc
	MsgBox("A opção Ambos está bloqueada para uso","ALERT")
	Return
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida Operacoes.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Alltrim(mv_par03))
	_ccontoper:=Alltrim(mv_par03)
	For x:=1 to Len(_ccontoper)
		ndiv:=AT("/",_ccontoper)
		If !ndiv = nil .AND. ndiv > 0
			_coper:=substr(_ccontoper,1,ndiv-1)
			_ccontoper:=substr(_ccontoper,ndiv+1)
			If  ZZJ->(dbSeek(xFilial('ZZJ')+_coper))
				If (MV_PAR06==3 .AND. (ZZJ->ZZJ_GPVSER<>'S' .OR.  ZZJ->ZZJ_GPVPEC<>'S')) .OR. (MV_PAR06==2 .AND. ZZJ->ZZJ_GPVPEC<>'S') .OR. (MV_PAR06==1 .AND. ZZJ->ZZJ_GPVSER<>'S')
					MsgAlert("Operacao : "+_coper+" nao esta configurada para gerar pedido de peca e servico, verifique os parametros ou acerto o cad. de operacoes ZZJ, Favor digitar uma operacao valida","Atencao")
					Return
				Else
					_cTespec  :=Alltrim(ZZJ->ZZJ_TESPVP)
					_cTesser  :=Alltrim(ZZJ->ZZJ_TESSER)
					_carmproc :=Alltrim(ZZJ->ZZJ_ALMEP)
					_ccuspec  :=Alltrim(ZZJ->ZZJ_CUSPEC)
					_codpros  :=Alltrim(ZZJ->ZZJ_CODPRS)
					If (MV_PAR06==3 .OR. MV_PAR06==2) .AND. Empty(_cTespec)
						MsgAlert("TES para o pedido de Peças ref a Operacao : "+_coper+" nao esta configurado, Acerte o cad. de operacoes ZZJ, Favor digitar uma TES PV Peça valida","Atencao")
						Return
					ElseIf (MV_PAR06==3 .OR. MV_PAR06==1) .AND. Empty(_cTesser)
						MsgAlert("TES para o pedido de servico ref a Operacao : "+_coper+" nao esta configurado, Acerte o cad. de operacoes ZZJ, Favor digitar uma TES PV servico valida","Atencao")
						Return
					ElseIf (MV_PAR06==3 .OR. MV_PAR06==2) .AND. !SF4->(dbSeek(xFilial('SF4')+_cTespec))
						MsgAlert("TES : "+_cTespec+" para o pedido de peças ref a Operacao : "+_coper+" nao existe no cadastro de TES SF4", "TES Invalida","Atencao")
						Return
					ElseIf (MV_PAR06==3 .OR. MV_PAR06==1) .AND. !SF4->(dbSeek(xFilial('SF4')+_cTesser))
						MsgAlert("TES : "+_cTesser+" para o pedido de servico ref a Operacao : "+_coper+" nao existe no cadastro de TES SF4", "TES Invalida","Atencao")
						Return
					ElseIf (MV_PAR06==3 .OR. MV_PAR06==2) .AND. Empty(_carmproc)
						MsgAlert("Não esta cadastrado o armazém de processo (peça) ref a Operacao : "+_coper+". Favor cadastrar no cadastro de operacoes ZZJ", "Armazem Peça nao cadastrado","Atencao")
						Return
					ElseIf (MV_PAR06==3 .OR. MV_PAR06==2) .AND. Empty(_ccuspec)
						MsgAlert("Não esta definido o tipo de calculo do custo ( medio, ultima compra, padrao, fifo etc.. ) das peças ref a Operacao : "+_coper+". Favor cadastrar no cadastro de operacoes ZZJ", "tipo de custo nao cadastrado","Atencao")
						Return
					ElseIf (MV_PAR06==3 .OR. MV_PAR06==1) .AND. Empty(_codpros)
						MsgAlert("Não esta definido o codigo de produto que é usado no Pedido de serviços para a Operacao : "+_coper+". Favor cadastrar o codigo produto de serviço", "tipo de custo nao cadastrado","Atencao")
						Return
					EndIf
				EndIf
			Else
				MsgAlert("Operacao : "+_coper+" digitado nao encontrada no cadastro de Operacoes ZZJ, Favor digitar uma operacao valida","Atencao")
				Return
			EndIf
		ElseIf ZZJ->(dbSeek(xFilial('ZZJ')+_ccontoper))
			If (MV_PAR06==3 .AND. (ZZJ->ZZJ_GPVSER<>'S' .OR.  ZZJ->ZZJ_GPVPEC<>'S')) .OR. (MV_PAR06==2 .AND. ZZJ->ZZJ_GPVPEC<>'S') .OR. (MV_PAR06==1 .AND. ZZJ->ZZJ_GPVSER<>'S')
				MsgAlert("Operacao : "+_ccontoper+" nao esta configurada para gerar pedido de peca e servico, verifique os parametros ou acerto o cad. de operacoes ZZJ, Favor digitar uma operacao valida","Atencao")
				Return
			Else
				_cTespec  :=Alltrim(ZZJ->ZZJ_TESPVP)
				_cTesser  :=Alltrim(ZZJ->ZZJ_TESSER)
				_carmproc :=Alltrim(ZZJ->ZZJ_ALMEP)
				_ccuspec  :=Alltrim(ZZJ->ZZJ_CUSPEC)
				_codpros  :=Alltrim(ZZJ->ZZJ_CODPRS)
				If (MV_PAR06==3 .OR. MV_PAR06==2) .AND. Empty(_cTespec)
					MsgAlert("TES para o pedido de Peças ref a Operacao : "+_ccontoper+" nao esta configurado, Acerte o cad. de operacoes ZZJ, Favor digitar uma TES PV Peça valida","Atencao")
					Return
				ElseIf (MV_PAR06==3 .OR. MV_PAR06==1) .AND. Empty(_cTesser)
					MsgAlert("TES para o pedido de servico ref a Operacao : "+_ccontoper+" nao esta configurado, Acerte o cad. de operacoes ZZJ, Favor digitar uma TES PV servico valida","Atencao")
					Return
				ElseIf (MV_PAR06==3 .OR. MV_PAR06==2) .AND. !SF4->(dbSeek(xFilial('SF4')+_cTespec))
					MsgAlert("TES : "+_cTespec+" para o pedido de peças ref a Operacao : "+_ccontoper+" nao existe no cadastro de TES SF4", "TES Invalida","Atencao")
					Return
				ElseIf (MV_PAR06==3 .OR. MV_PAR06==1) .AND. !SF4->(dbSeek(xFilial('SF4')+_cTesser))
					MsgAlert("TES : "+_cTesser+" para o pedido de servico ref a Operacao : "+_ccontoper+" nao existe no cadastro de TES SF4", "TES Invalida","Atencao")
					Return
				ElseIf (MV_PAR06==3 .OR. MV_PAR06==2) .AND. Empty(_carmproc)
					MsgAlert("Não esta cadastrado o armazém de processo (peça) ref a Operacao : "+_ccontoper+". Favor cadastrar no cadastro de operacoes ZZJ", "Armazem Peça nao cadastrado","Atencao")
					Return
				ElseIf (MV_PAR06==3 .OR. MV_PAR06==2) .AND. Empty(_ccuspec)
					MsgAlert("Não esta definido o tipo de calculo do custo ( medio, ultima compra, padrao, fifo etc.. ) das peças ref a Operacao : "+_ccontoper+". Favor cadastrar no cadastro de operacoes ZZJ", "tipo de custo nao cadastrado","Atencao")
					Return
				ElseIf (MV_PAR06==3 .OR. MV_PAR06==1) .AND. Empty(_codpros)
					MsgAlert("Não esta definido o codigo de produto que é usado no Pedido de serviços para a Operacao : "+_ccontoper+". Favor cadastrar o codigo produto de serviço", "tipo de custo nao cadastrado","Atencao")
					Return
				EndIf
			EndIf
		Else
			MsgAlert("Operacao : "+_ccontoper+" digitado nao encontrada no cadastro de Operacoes ZZJ, Favor digitar uma operacao valida","Atencao")
			Return
		EndIf
	Next
Else
	MsgAlert("Deve ser digitado pelo menos uma operacao service BGH valida. Favor digitar uma operacao BGH","Atencao")
	Return
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica e bloqueia se a operacao N11 esta junto com outras operacoes.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(Alltrim(mv_par03)) > 6
	If "N11" $  Alltrim(mv_par03)
		MsgAlert("A Operacao N11 tem que ser gerada separadamente das demais operacoes. Favor digitar a operacao N11 separadamente das demais","Atencao")
		Return
	EndIf
EndIf
_cSele2 :=      " SELECT COUNT(*) 'QTREG' "
_cSele3 :=      " SELECT ZZ4_OPEBGH,ZZ4_CODPRO "
_cSele4 :=      " SELECT ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFSNR,ZZ4_NFSSER,ZZ4_NFSDT,ZZ4_NFSTES "
_cSele5 :=      " SELECT ZZ4_CODCLI,ZZ4_LOJA,C6_NUM,C6_ENTREG,C6_TES"
_cSele1 := CR + " SELECT ZZ4_FILIAL,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_IMEI,ZZ4_CARCAC,ZZ4_CODPRO,ZZ4_VLRUNI,ZZ4_OS,ZZ4_NFENR,ZZ4_NFESER,ZZ4_NFEDT,ZZ4_PV,ZZ4_NFSNR,ZZ4_NFSSER,ZZ4_NFSDT,ZZ4_NFSHR,ZZ4_NFSTES, "
_cSele1 += CR + "       ZZ4_OPEBGH,ZZ4_GARANT,ZZ4_TRANSC,ZZ4_PVPECA,ZZ4_NFSPEC,ZZ4_NFSSEP,ZZ4_PVSERV,ZZ4_NFSSSV,ZZ4_STATUS,ZZ4_LOCAL,ZZ4_ITEMD1,ZZ4_GARMCL,R_E_C_N_O_ AS RECNO,ZZ4_CHVFIL "
_cQuery += CR + "        FROM "+RetSqlName("ZZ4")+" (NOLOCK) "
If (MV_PAR16==3 .OR. MV_PAR16==2)
	_cQuery += CR + " INNER JOIN ( "
	_cQuery += CR + "    SELECT C6_FILIAL,C6_NUM,C6_ITEM,C6_TES,C6_ENTREG "
	_cQuery += CR + "    FROM "+RetSqlName("SC6")+" (NOLOCK) "
	_cQuery += CR + "    WHERE D_E_L_E_T_='' ) AS C6  "
	_cQuery += CR + " ON C6.C6_FILIAL=ZZ4_FILIAL AND C6.C6_NUM=LEFT(ZZ4_PV,6) AND C6.C6_ITEM=RIGHT(ZZ4_PV,2) "
EndIf
If MV_PAR06==2  .AND. date() >= _dtaltfpc
	_cQuery += CR + " LEFT OUTER JOIN ( "
	_cQuery += CR + "    SELECT Z9_FILIAL,Z9_NUMOS,Z9_IMEI "
	_cQuery += CR + "    FROM "+RetSqlName("SZ9")+" (NOLOCK) "
	_cQuery += CR + "    WHERE D_E_L_E_T_='' AND Z9_SYSORIG IN ('1','2') AND Z9_NUMSEQD='' AND Z9_NUMSEQR='' AND Z9_NUMSEQS='' "
	_cQuery += CR + "    AND Z9_STATUS='1'  "
	_cQuery += CR + "    GROUP BY Z9_FILIAL,Z9_NUMOS,Z9_IMEI  ) AS Z9  "
	_cQuery += CR + " ON Z9.Z9_FILIAL=ZZ4_FILIAL AND Z9.Z9_NUMOS=ZZ4_OS AND Z9.Z9_IMEI=ZZ4_IMEI "
EndIf
_cQuery += CR + " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' AND  "
If !Empty(MV_PAR01) .AND. !Empty(MV_PAR02)
	_cQuery += CR + "    ZZ4_CODCLI='"+MV_PAR01+"' AND ZZ4_LOJA='"+MV_PAR02+"' AND  "
EndIf
If MV_PAR16==3
	_cQuery += CR + " ZZ4_NFSDT>="+DTOS(MV_PAR04)+" AND ZZ4_NFSDT<="+DTOS(MV_PAR05)+" AND "
	_cQuery += CR + " ZZ4_SMDT>="+DTOS(MV_PAR12)+" AND ZZ4_SMDT<="+DTOS(MV_PAR13)+" AND "
ElseIf  MV_PAR16==1
	_cQuery += CR + " ZZ4_NFSDT>="+DTOS(MV_PAR04)+" AND ZZ4_NFSDT<="+DTOS(MV_PAR05)+" AND "
	_cQuery += CR + " ZZ4_NFSNR<>'' AND
ElseIf  MV_PAR16==2
	_cQuery += CR + " ZZ4_SMDT>="+DTOS(MV_PAR12)+" AND ZZ4_SMDT<="+DTOS(MV_PAR13)+" AND "
EndIf
_cQuery += CR + "ZZ4_PV<>'' AND  '"+Alltrim(mv_par03)+"' LIKE '%'+ZZ4_OPEBGH+'%' AND "
If MV_PAR06==2  .AND. date() >= _dtaltfpc
	_cQuery += CR + " Z9.Z9_NUMOS IS NOT NULL AND "
EndIf
If MV_PAR06==3
	_cQuery += CR + "   ZZ4_PVPECA='' AND ZZ4_PVSERV='' AND "
ElseIf MV_PAR06==2
	_cQuery += CR + "   ZZ4_PVPECA='' AND   "
ElseIf MV_PAR06==1
	_cQuery += CR + "    ZZ4_PVSERV='' AND "
EndIf
If !Empty(MV_PAR07)
	_cQuery += CR + "    ZZ4_CODPRO='"+MV_PAR07+"' AND "
EndIf
If !Empty(MV_PAR08) .AND. (MV_PAR16==3 .OR. MV_PAR16==1)
	_cQuery += CR + "    ZZ4_NFSNR>='"+MV_PAR08+"' AND "
EndIf
If !Empty(MV_PAR09) .AND. (MV_PAR16==3 .OR. MV_PAR16==1)
	_cQuery += CR + "    ZZ4_NFSNR<='"+MV_PAR09+"' AND "
EndIf
If !Empty(MV_PAR10) .AND. (MV_PAR16==3 .OR. MV_PAR16==1)
	_cQuery += CR + "    ZZ4_NFSSER>='"+MV_PAR10+"' AND "
EndIf
If !Empty(MV_PAR11) .AND. (MV_PAR16==3 .OR. MV_PAR16==1)
	_cQuery += CR + "    ZZ4_NFSSER<='"+MV_PAR11+"' AND "
EndIf
If !Empty(MV_PAR14) .AND. (MV_PAR16==3 .OR. MV_PAR16==2)
	_cQuery += CR + "    LEFT(ZZ4_PV,6)>='"+MV_PAR14+"' AND "
EndIf
If !Empty(MV_PAR15) .AND. (MV_PAR16==3 .OR. MV_PAR16==2)
	_cQuery += CR + "    LEFT(ZZ4_PV,6)<='"+MV_PAR15+"' AND "
EndIf
If MV_PAR16==3 .OR. MV_PAR16==1
	_cQuery += CR + "  ZZ4_NFSTES='727' AND
EndIf
_cQuery += CR + " D_E_L_E_T_=''  "
_cOrder := CR + " ORDER BY ZZ4_OPEBGH,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_CODPRO "
_cgroup := CR + " GROUP BY ZZ4_OPEBGH,ZZ4_CODPRO "
_cOrde2 := CR + " ORDER BY ZZ4_OPEBGH,ZZ4_CODPRO "
_cgrou3 := CR + " GROUP BY ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFSNR,ZZ4_NFSSER,ZZ4_NFSDT,ZZ4_NFSTES "
_cOrde3 := CR + " ORDER BY ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFSNR,ZZ4_NFSSER,ZZ4_NFSDT,ZZ4_NFSTES "
_cgrou4 := CR + " GROUP BY ZZ4_CODCLI,ZZ4_LOJA,C6_NUM,C6_ENTREG,C6_TES "
_cOrde4 := CR + " ORDER BY ZZ4_CODCLI,ZZ4_LOJA,C6_NUM,C6_ENTREG,C6_TES "
//memowrite("fata002.sql",_cSele1 + _cQuery + _cOrder)
_cSele1 := strtran(_cSele1,CR,"")
_cSele5 := strtran(_cSele5,CR,"")
_cQuery := strtran(_cQuery,CR,"")
_cOrder := strtran(_cOrder,CR,"")
_cOrde2 := strtran(_cOrde2,CR,"")
_cgroup := strtran(_cgroup,CR,"")
_cOrde3 := strtran(_cOrde3,CR,"")
_cgrou3 := strtran(_cgrou3,CR,"")
If (MV_PAR16==3 .OR. MV_PAR16==2)
	TCQUERY _cSele5 + _cQuery + _cgrou4 + _cOrde4 NEW ALIAS "QRY"
	//TCQUERY _cSele4 + _cQuery + " and ZZ4_PV In ('99L22901') " + _cgrou3 + _cOrde3 NEW ALIAS "QRY"     // LUIS
Else
	TCQUERY _cSele4 + _cQuery + _cgrou3 + _cOrde3 NEW ALIAS "QRY"
EndIf
If Select("QRY") > 0
	If  (MV_PAR16==3 .OR. MV_PAR16==1)
		u_confsai(1)
	Else
		u_confsai(2)
	EndIf
	If Len(_aconfsa) <= 0
		If MV_PAR16==3
			MsgAlert("Nenhum Pedido/Nota Fiscal selecionado. Favor entrar novamente e selecionar." ,"Pedido/Nota nao selecionada")
		ElseIf MV_PAR16==2
			MsgAlert("Nenhum Pedido selecionado. Favor entrar novamente e selecionar." ,"Pedido nao selecionada")
		Else
			MsgAlert("Nenhum Nota Fiscal selecionada. Favor entrar novamente e selecionar." ,"Nota Fiscal nao selecionada")
		EndIf
		Return
	EndIf
Else
	MsgAlert("Não foi encontrado nenhum registro. Confira os parâmetros ." ,"Registro não encontrado")
	Return
EndIf
TCQUERY _cSele2 + _cQuery NEW ALIAS "TRA"
TRA->(dbGoTop())
Procregua(TRA->QTREG)
TRA->(dbCloseArea())
TCQUERY _cSele3 + _cQuery + _cgroup + _cOrde2  NEW ALIAS "TRC"
TRC->(dbGoTop())
While !TRC->(Eof())
	SB1->(dbSeek(xFilial('SB1')+TRC->ZZ4_CODPRO))
	If Empty(SB1->B1_XCODEST)  .AND. (MV_PAR06==3 .OR. MV_PAR06==2)
		MsgAlert("Nao esta amarrado o codigo de estrutura no modelo : "+Alltrim(TRC->ZZ4_CODPRO)+". Favor amarrar o codigo de estrutura a esse produto no cadastro de produto","Atencao")
		If ApMsgYesNo("Deseja prosseguir ? O sistema ignorará esse modelo no processamento de pedido de peça.","Modelo X Codigo Estrutura")
			_cmodxest :=_cmodxest+"/"+Alltrim(TRC->ZZ4_CODPRO)
		Else
			Return
		EndIf
	ElseIf !SG1->(dbSeek(xFilial('SG1')+SB1->B1_XCODEST)).AND. (MV_PAR06==3 .OR. MV_PAR06==2)
		MsgAlert("O código : "+Alltrim(SB1->B1_XCODEST)+" amarrado ao modelo : "+Alltrim(TRC->ZZ4_CODPRO)+" não existe no cadastro de estruturas. Revise o cad. de produtos ou cadastre a estrutura","Atencao")
		If ApMsgYesNo("Deseja prosseguir ? O sistema ignorará esse modelo no processamento de pedido de peça.","Codigo Estrutura não cadastrada")
			_cmodxest :=_cmodxest+"/"+Alltrim(TRC->ZZ4_CODPRO)
		Else
			Return
		EndIf
	EndIf
	//If !ZZP->(dbSeek(xFilial('ZZP')+TRC->ZZ4_OPEBGH+TRC->ZZ4_CODPRO))  .AND. (MV_PAR06==3 .OR. MV_PAR06==1)
	If (MV_PAR06==3 .OR. MV_PAR06==2)
		_amodestr  := u_FATA003A(SB1->B1_XCODEST,TRC->ZZ4_OPEBGH,TRC->ZZ4_CODPRO)
		If Len(_amodestr)<=0
			MsgAlert("Nao existe nenhum modelo cadastrado da estrutura: "+Alltrim(SB1->B1_XCODEST)+" cadastrado para a operação : "+TRC->ZZ4_OPEBGH+" na tabela de valores de servicos ZZP. Favor amarrar o modelo na tabela de valores ZZP","Atencao")
			If ApMsgYesNo("Deseja prosseguir ? O sistema ignorará esse modelo no processamento de pedido de Serviços.","Modelo nao cadastrado na tab. valores fat. Serviços")
				_cmodxvfs :=_cmodxvfs+"/"+Alltrim(TRC->ZZ4_CODPRO)+Alltrim(TRC->ZZ4_OPEBGH)
			Else
				Return
			EndIf
		EndIf
	EndIf
	TRC->(dbskip())
EndDo
TRC->(dbCloseArea())
TCQUERY _cSele1 + _cQuery + _cOrder NEW ALIAS "TRB"
//CQUERY _cSele1 + _cQuery +  " and ZZ4_PV In ('99L22901') " +  _cOrder NEW ALIAS "TRB"
TRB->(dbGoTop())
While !TRB->(Eof())
	ZZJ->(dbSeek(xFilial('ZZJ')+Alltrim(TRB->ZZ4_OPEBGH)))
	_nPoscli := Ascan(_aconfsa ,{ |x| x[1] == TRB->ZZ4_CODCLI })
	_nPosloj := Ascan(_aconfsa ,{ |x| x[2] == TRB->ZZ4_LOJA   })
	If  MV_PAR16==1
		_nPosnfs := Ascan(_aconfsa ,{ |x| x[3] == TRB->ZZ4_NFSNR  })
		_nPosser := Ascan(_aconfsa ,{ |x| x[4] == TRB->ZZ4_NFSSER })
		_nPosped :=1
	ElseIf  MV_PAR16==2
		_nPosped := Ascan(_aconfsa ,{ |x| x[3] == LEFT(TRB->ZZ4_PV,6)})
		_nPosser :=1
		_nPosnfs :=1
	ElseIf  MV_PAR16==3
		_nPosped := Ascan(_aconfsa ,{ |x| x[3] == LEFT(TRB->ZZ4_PV,6)})
		_nPosnfs := Ascan(_aconfsa ,{ |x| x[3] == TRB->ZZ4_NFSNR  })
		_nPosser := Ascan(_aconfsa ,{ |x| x[4] == TRB->ZZ4_NFSSER })
	EndIf
	_cdocfil := space(9)
	_cserfil := space(3)
	_cclifil := space(6)
	_clojfil := space(2)
	_cOSfil  := space(6)
	_ltrOsas :=.F.
	If _nPoscli > 0 .AND. _nPosloj > 0  .AND. _nPosnfs > 0 .AND. _nPosser > 0 .AND. _nPosped > 0
		If Alltrim(TRB->ZZ4_OPEBGH) $ "N01/N10/N11" .AND. Iif((MV_PAR16==3 .OR. MV_PAR16==1),TRB->ZZ4_NFSTES='727',.T.)
			If TRB->ZZ4_FILIAL='06' .AND. TRB->ZZ4_CODCLI='Z00403' .AND. TRB->ZZ4_LOJA='01'
				_cOSfil := LEFT(TRB->ZZ4_CHVFIL,6)
				If Select("QRYOSFIL") > 0
					QRYOSFIL->(dbCloseArea())
				EndIf
				_cqryOsfil:= " SELECT ZZ4_FILIAL,ZZ4_GVSARQ "
				_cqryOsfil+= " FROM   ZZ4020  "
				_cqryOsfil+= " WHERE  ZZ4_FILIAL = '02' AND ZZ4_OS='"+_cOSfil+"' AND D_E_L_E_T_ = '' "
				TCQUERY _cqryOsfil NEW ALIAS "QRYOSFIL"
				dbSelectArea("QRYOSFIL")
				dbGoTop()
				If Select("QRYOSFIL") > 0
					While !Eof("QRYOSFIL")
						If !Empty(QRYOSFIL->ZZ4_GVSARQ)
							_cpedfil := left(Alltrim(QRYOSFIL->ZZ4_GVSARQ),6)
							_citpvfi := right(Alltrim(QRYOSFIL->ZZ4_GVSARQ),2)
							If SD2->(dbSeek("02" + _cpedfil + _citpvfi ))
								_cdocfil := SD2->D2_DOC
								_cserfil := SD2->D2_SERIE
								_cclifil := SD2->D2_CLIENTE
								_clojfil := SD2->D2_LOJA
								_ltrOsas := .T.
							Else
								aAdd(_aerrnfil,{TRB->ZZ4_NFSNR,TRB->ZZ4_NFSSER,"Não foi faturado a Nf de saida ref. ao ped. saída alphaville : "+_cpedfil+"/"+_citpvfi+" e a OS da Matriz : "+_cOSfil+"  ", "Verifique se foi realizada o faturamento de Saida na Matriz" })
							EndIf
						Else
							aAdd(_aerrnfil,{TRB->ZZ4_NFSNR,TRB->ZZ4_NFSSER,"Não encontrado Pedido de Saida em Alphaville ref. a OS da Matriz : "+_cOSfil+"  ", "Verifique se foi realizada a entrada e a Saida na Matriz Alphaville." })
						EndIf
						QRYOSFIL->(DBSKIP())
					EndDo
				Else
					aAdd(_aerrnfil,{TRB->ZZ4_NFSNR,TRB->ZZ4_NFSSER,"Não encontrado a OS da matriz : "+_cOSfil+" em Alphaville", "Contate o Administrador" })
				EndIf
			EndIf
			_cimei   := TRB->ZZ4_IMEI
			_cos     := TRB->ZZ4_OS
			_cpv     := TRB->ZZ4_PV
			_cpedpc  := TRB->ZZ4_PVPECA
			_cLocal  := TRB->ZZ4_LOCAL
			_cprod   := TRB->ZZ4_CODPRO
			_cnfe    := TRB->ZZ4_NFENR
			_cserie  := TRB->ZZ4_NFESER
			_citem   := TRB->ZZ4_ITEMD1
			//_ccli    := Iif(TRB->ZZ4_OPEBGH="N11","000016",TRB->ZZ4_CODCLI)
			//_cloj    := Iif(TRB->ZZ4_OPEBGH="N11","01",TRB->ZZ4_LOJA)
			_ccli    := Iif(_ltrOsas,_cclifil,TRB->ZZ4_CODCLI)
			_cloj    := Iif(_ltrOsas,_clojfil,TRB->ZZ4_LOJA)
			_nqtde   := 1
			_nvunit  := TRB->ZZ4_VLRUNI
			_divneg  := ZZJ->ZZJ_DIVNEG
			_cstazz4 := TRB->ZZ4_STATUS
			_copebgh := TRB->ZZ4_OPEBGH
			_nreczz4 := TRB->RECNO
			_ddtnfe  := TRB->ZZ4_NFEDT
			_codlab  := ZZJ->ZZJ_LAB
			_carcac  := TRB->ZZ4_CARCAC
			_cdivneg := ZZJ->ZZJ_DIVNEG
			_cnfsnr  := Iif(_ltrOsas,_cdocfil,TRB->ZZ4_NFSNR)
			_cnfsser := Iif(_ltrOsas,_cserfil,TRB->ZZ4_NFSSER)
			_cnfsdt  := TRB->ZZ4_NFSDT
			_cgarant := TRB->ZZ4_GARANT
			_ctransc := TRB->ZZ4_TRANSC
			_cgarmcl := TRB->ZZ4_GARMCL
			IncProc()
			If MV_PAR06==3
				If !(Alltrim(TRB->ZZ4_CODPRO)+Alltrim(TRB->ZZ4_OPEBGH)) $ _cmodxvfs
					_ccli    := Iif(TRB->ZZ4_OPEBGH="N11","000016",TRB->ZZ4_CODCLI)
					_cloj    := Iif(TRB->ZZ4_OPEBGH="N11","01",TRB->ZZ4_LOJA)
					aAdd(_agpvser,{_cimei,_cos,_clocal,_cprod,_cnfe,_cserie,_ccli,_cloj,_nqtde,_nvunit,_cstazz4,_codlab,_cpv,_carcac,_copebgh,_nreczz4,_cdivneg,_citem,_ddtnfe,_cnfsnr,_cnfsser,_cnfsdt,_cgarmcl,_ctransc,.F.})
				EndIf
				If !(Alltrim(TRB->ZZ4_CODPRO)) $ _cmodxest
					aAdd(_agpvpec,{_cimei,_cos,_clocal,_cprod,_cnfe,_cserie,_ccli,_cloj,_nqtde,_nvunit,_cstazz4,_codlab,_cpv,_carcac,_copebgh,_nreczz4,_cdivneg,_citem,_ddtnfe,_cnfsnr,_cnfsser,_cnfsdt,_cgarmcl,_ctransc,.F.})
				EndIf
			ElseIf MV_PAR06==2
				If !(Alltrim(TRB->ZZ4_CODPRO)) $ _cmodxest
					If GetMV("MV_XTABPEC") $ "C/T"
						u_pecaprec(_cos,_cimei,TRB->ZZ4_CODPRO)
					EndIf
					aAdd(_agpvpec,{_cimei,_cos,_clocal,_cprod,_cnfe,_cserie,_ccli,_cloj,_nqtde,_nvunit,_cstazz4,_codlab,_cpv,_carcac,_copebgh,_nreczz4,_cdivneg,_citem,_ddtnfe,_cnfsnr,_cnfsser,_cnfsdt,_cgarmcl,_ctransc,.F.})
				EndIf
			ElseIf MV_PAR06==1
				If !(Alltrim(TRB->ZZ4_CODPRO)+Alltrim(TRB->ZZ4_OPEBGH)) $ _cmodxvfs
					If date() >= _dtaltfpc .AND. Empty(_cpedpc)
						If  Empty(fatpeca(_cos,_cimei,))
							MsgAlert("Existe NF de retorno sem a geração de pedido de peça, não poderá prosseguir. NF Ret : "+_cnfsnr+"/"+_cnfsser+". Favor efeturar primeiramente a geração do pedido de peças" ,"Atencao")
							_agpvser :={}
							Return
						EndIf
					EndIf
					_ccli    := Iif(TRB->ZZ4_OPEBGH="N11","000016",TRB->ZZ4_CODCLI)
					_cloj    := Iif(TRB->ZZ4_OPEBGH="N11","01",TRB->ZZ4_LOJA)
					aAdd(_agpvser,{_cimei,_cos,_clocal,_cprod,_cnfe,_cserie,_ccli,_cloj,_nqtde,_nvunit,_cstazz4,_codlab,_cpv,_carcac,_copebgh,_nreczz4,_cdivneg,_citem,_ddtnfe,_cnfsnr,_cnfsser,_cnfsdt,_cgarmcl,_ctransc,.F.})
				EndIf
			EndIf
		EndIf
	EndIf
	TRB->(dbSkip())
EndDo
If Len(_apecprec) > 0 .AND. GetMV("MV_XTABPEC") $ "C/T"
	aSort(_apecprec,,,{|x,y| x[5] < y[5]})
	If GetMV("MV_XTABPEC") == "C"
		cMsgErro := "Existem inconsistências. Favor analisar o relatório que será gerado na sequência e contate a área Controladoria para problema com Custo médio e a area de Planejamento para problema de cadastro na tabela de preço."
	ElseIf GetMV("MV_XTABPEC") == "T"
		cMsgErro := "Existem Peçs sem tabela de preços cadastrada. Favor analisar o relatório que será gerado na sequência e contate a áreas planejamento / Controladoria ."
	EndIf
	ApMsgInfo(cMsgErro,"Erro no processo.")
	u_errosftps(_apecprec,"2")
	_agpvpec:={}
EndIf
TRB->(dbCloseArea())
RestArea(_aAreaZZ4)
RestArea(_aAreaZZJ)
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ pvgera   ºAutor  ³Edson Rodrigues     º Data ³  14/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que faz validacoes e gera pedido de servicos ou     º±±
±±º            peças.                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function pvgera(nopcao)
Local bAcao   := {|lFim| rungpv(@lFim,nopcao) }
Local cTitulo := ""
Local cMsg    := If(nopcao==1,"Processando Pedido de Serviço...", "Processando Pedido de Peças...")
Local lAborta := .T.
Processa( bAcao, cTitulo, cMsg, lAborta )
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rungpv   ºAutor  ³Edson Rodrigues     º Data ³  15/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que o gera o pedido de servico ou pecas             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function rungpv(lFim,nopcao)
Local _lAltMen  := .F.
Local _cproduct :=SPACE(15)                           
Local _cnewprod :=SPACE(15)
Local _cpropeca :=""
Local _nprcven  :=0.00
Local _lRet     :=.T.           
Local _ctransp  :=""                                         
Local _newnf    := SPACE(nTamNfs)
Local _newsnf   := SPACE(nTamser)
Local _newcli   := SPACE(nTamcli)
Local _newloj   := SPACE(2)
Local _newoper  := SPACE(3)
Local _nConPED  := 0 
Local _cnfssai  :=""          
_aCabSC5 := {}
_aIteSC6 := {}
_agerapv :=Iif(nopcao==1,aclone(_agpvser),aclone(_agpvpec))
Procregua(Len(_agerapv))
For x:=1 to Len(_agerapv)
	IncProc()
	_lRet := .T.
	If (((_newcli  <> _agerapv[x,7]) .OR. (_newloj  <> _agerapv[x,8])) .OR. (nopcao==1 .OR. Iif(nopcao==2 .AND. _cnewprod<>_agerapv[x,4],.T.,.F.)))
		_newoper   := _agerapv[x,15]
		_newcli    := _agerapv[x,7]
		_newloj    := _agerapv[x,8]
		_cnewprod  := _agerapv[x,4]
		SB1->(dbSeek(xFilial('SB1')+_agerapv[x,4]))
		SA1->(dbSeek(xFilial('SA1')+_agerapv[x,7]+_agerapv[x,8]))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Geracao dos Cabecalhos.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cmenpad   :=""
		cKit       :=""
		_cdivneg   :=_agerapv[x,17]
		_aCabSC5   := {}
		_aIteSC6   := {}
		_agrpitm   := {}
		_ctransp   := Iif(nopcao==2,Iif(_newoper="N11","02","56"),"")
		_ctransp   := Iif(Empty(_ctransp),SA1->A1_TRANSP,_ctransp)
		_cmenpad   := Iif(nopcao==2,"024","")
		_cmenpad   := Iif(nopcao==2,Iif(Empty(_cmenpad),SA1->A1_MENSAGE,_cmenpad),'024')
		_cdivneg   := Iif(Empty(_cdivneg),'09',_cdivneg)
		_condpgto  := Iif(nopcao==2,'479','479')
		_aAreaSC5  := SC5->(GetArea())
		_nConPED++
		_cnewloc   := _agerapv[x,3]
		_nqtdetot  := 0
		cItens     := "00"
		_cnfssai   := ""
		//cNrPV:= GetSxeNum('SC5','C5_NUM')
		cNrPV		:= GetSx8Num("SC5","C5_NUM")
		ConfirmSX8()
		_aCabSC5 := {;
		{"C5_TIPO"		,"N"				,Nil},;
		{"C5_NUM"		,cNrPV				,Nil},;
		{"C5_CLIENTE"	,_agerapv[x,7]		,Nil},;
		{"C5_LOJACLI"	,_agerapv[x,8]		,Nil},;
		{"C5_LOJAENT"	,_agerapv[x,8]		,Nil},;
		{"C5_TIPOCLI"	,"F"				,Nil},;
		{"C5_CONDPAG"	,_condpgto			,Nil},;
		{"C5_TIPLIB"	,"1"				,Nil},;
		{"C5_TPCARGA"	,"2"				,Nil},;
		{"C5_B_KIT"		,cKit				,Nil},;
		{"C5_XUSER"		,Alltrim(cusername)	,Nil},;
		{"C5_TRANSP"	,_ctransp			,Nil},;
		{"C5_MENPAD"	,_cmenpad			,Nil},;
		{"C5_DIVNEG"	,_cdivneg			,Nil},;
		{"C5_ACRSFIN"	,0					,Nil},;
		{"C5_MENNOTA"	,""					,Nil},;
		{"C5_DESCFI"	,0					,Nil}}
		For ix:=x to Len(_agerapv)
			//                 1      2    3       4      5     6       7     8      9      10      11       12     13    14       15       16        17      18     19       20     21         22      23     24
			// aAdd(_agpvser,{_cimei,_cos,_clocal,_cprod,_cnfe,_cserie,_ccli,_cloj,_nqtde,_nvunit,_cstazz4,_codlab,_cpv,_carcac,_copebgh,_nreczz4,_cdivneg,_citem,_ddtnfe,_cnfsnr,_cnfsser,_cnfsdt,_cgarant,_ctransc})
			If _newcli == _agerapv[ix,7] .AND. _newloj == _agerapv[ix,8] .AND. !_agerapv[ix,25]
				If  nopcao==1 .OR. Iif(nopcao==2 .AND. _cnewprod==_agerapv[ix,4],.T.,.F.)
					SB1->(dbSeek(xFilial('SB1')+_agerapv[ix,4]))
					SA1->(dbSeek(xFilial('SA1')+_agerapv[ix,7]+_agerapv[ix,8]))
					_citem          := _agerapv[ix,18]
					_nPrcVen        := _agerapv[ix,10]
					_nqtde          := _agerapv[ix,9]
					_citLocal       := _agerapv[ix,3]
					_agerapv[ix,25] := .T.
					If nopcao==2 .AND. !Alltrim(_agerapv[ix,20])+'-'+Alltrim(_agerapv[ix,21]) $ _cnfssai
						_cnfssai :=_cnfssai+Alltrim(_agerapv[ix,20])+'-'+Alltrim(_agerapv[ix,21])+"/"
					EndIf
					_aCabSC5[16,2]  := Iif(nopcao==2,'REF.'+_cnfssai+ ' MODELO: '+Alltrim(_cnewprod)+ '.','')
					aAdd(_agrpitm,{cItens,_agerapv[ix,4],SB1->B1_DESC,Iif(nopcao==1,_cTesser,_ctespec),_nqtde,_nqtde,'','',_nPrcVen,_nqtde*_nPrcVen,0,'','','','',0,_citlocal,ddatabase,'',_agerapv[ix,15],_agerapv[ix,16],_agerapv[ix,23],_agerapv[ix,24],.F.,'',cNrPV,'',NIL,_agerapv[ix,1],_agerapv[ix,2],''})
				EndIf
			EndIf
		Next IX
		If Len(_agrpitm) > 0 .AND. nopcao==1 // servico
			_aErros:={}
			U_filitserv(@cItens)
		EndIf
		If Len(_agrpitm) > 0  .AND. nopcao==2 // Pecas
			_aErros:={}
			U_filitpec(@cItens)
		EndIf
		If Len(_aCabSC5) > 0  .AND. Len(_aIteSC6) > 0
			_lRet := u_geraPV(_aCabSC5,_aIteSC6, 3)  //Inclusao de novo PV
		Else
			If Len(_agrpitm) > 0
				_lRet := .F.
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se gerou erro no PV pela rotina padrao, forca a gravacao pelo RECLOCK.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(_aCabSC5) > 0  .AND. Len(_aIteSC6) > 0 .AND. !_lRet
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Geracao dos Cabecalhos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA1->(dbSeek(xFilial('SA1')+_aCabSC5[2,2]+_aCabSC5[3,2]))
			_cCFIni := "0"
			If Subs(SA1->A1_EST,1,2) == "EX"
				_cCFIni := "7"
			ElseIf Alltrim(GetMV("MV_ESTADO")) <> Alltrim(SA1->A1_EST)
				_cCFIni := "6"
			Else
				_cCFIni := "5"
			EndIf
			Begin Transaction
			RecLock('SC5',.T.)
			SC5->C5_FILIAL  := xFilial('SC5')
			SC5->C5_NUM     := cNrPV
			SC5->C5_TIPO    := _aCabSC5[ 1,2]
			SC5->C5_CLIENTE := _aCabSC5[ 3,2]
			SC5->C5_LOJACLI := _aCabSC5[ 4,2]
			SC5->C5_CLIENT  := _aCabSC5[ 3,2]
			SC5->C5_LOJAENT := _aCabSC5[ 5,2]
			SC5->C5_TIPOCLI := _aCabSC5[ 6,2]
			SC5->C5_CONDPAG := _aCabSC5[ 7,2]
			SC5->C5_EMISSAO := dDatabase
			SC5->C5_MOEDA   := 1
			SC5->C5_TIPLIB  := _aCabSC5[ 8,2]
			SC5->C5_TPCARGA := _aCabSC5[ 9,2]
			SC5->C5_TXMOEDA := 1
			SC5->C5_B_KIT   := _aCabSC5[ 10,2]
			SC5->C5_XUSER   := _aCabSC5[11,2]
			SC5->C5_TRANSP  := _aCabSC5[12,2]
			SC5->C5_MENPAD  := _aCabSC5[13,2]
			SC5->C5_DIVNEG  := _aCabSC5[14,2]
			SC5->C5_ACRSFIN := _aCabSC5[15,2]
			SC5->C5_MENNOTA := _aCabSC5[16,2]
			SC5->C5_DESCFI  := _aCabSC5[17,2]
			MsUnLock('SC5')
			End Transaction
			//ConfirmSX8()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Geracao dos Itens.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For IX := 1 to Len(_aIteSC6)
				SB1->(dbSeek(xFilial('SB1')+_aIteSC6[IX,3,2]))
				SF4->(dbSeek(xFilial('SF4')+_aIteSC6[IX,5,2]))
				Begin Transaction
				RecLock("SC6",.T.)
				SC6->C6_FILIAL := xfilial("SC6")
				SC6->C6_NUM    := _aIteSC6[IX,2,2]
				SC6->C6_ITEM   := _aIteSC6[IX,1,2]
				SC6->C6_PRODUTO:= _aIteSC6[IX,3,2]
				SC6->C6_UM     := SB1->B1_UM
				SC6->C6_QTDVEN := _aIteSC6[IX,6,2]
				SC6->C6_PRCVEN := _aIteSC6[IX,10,2]
				SC6->C6_VALOR  := _aIteSC6[IX,11,2]
				SC6->C6_TES    := _aIteSC6[IX,5,2]
				SC6->C6_Local  := _aIteSC6[IX,19,2]
				SC6->C6_CF     := Alltrim(_cCFIni)+Subs(SF4->F4_CF,2,3)
				SC6->C6_ENTREG := dDataBase
				SC6->C6_DESCRI := SB1->B1_DESC
				SC6->C6_PRUNIT := _aIteSC6[IX,10,2]
				SC6->C6_NFORI  := _aIteSC6[IX,14,2]
				SC6->C6_SERIORI:= _aIteSC6[IX,15,2]
				SC6->C6_ITEMORI:= _aIteSC6[IX,16,2]
				SC6->C6_NUMSERI:= _aIteSC6[IX,8,2]
				SC6->C6_TPOP   := 'F' //FIRME
				SC6->C6_CLI    := _aCabSC5[ 3,2]
				SC6->C6_LOJA   := _aCabSC5[ 4,2]
				SC6->C6_IDENTB6:= _aIteSC6[IX,17,2]
				SC6->C6_PRCCOMP:= _aIteSC6[IX,18,2]
				If nopcao==2 .AND. date() >= _dtaltfpc
					SC6->C6_LOCALIZ:= _aIteSC6[IX,20,2]
				EndIf
				SC6->C6_NUMOS  := _aIteSC6[IX,9,2]
				SC6->C6_DESCONT:= _aIteSC6[IX,13,2]
				SC6->C6_VALDESC:= _aIteSC6[IX,13,2]
				If nopcao==2 .AND. date() >= _dtaltfpc
					SC6->C6_AEXPGVS:= _aIteSC6[IX,22,2]
				Else
					SC6->C6_AEXPGVS:= _aIteSC6[IX,21,2]
				EndIf
				MsUnLock('SC6')
				End Transaction
			next IX
			_lRet:=.T.
		EndIf
		If Len(_apgtomot) > 0
			pvpgtom(2,_aCabSC5[14,2],_aCabSC5[3,2],_aCabSC5[4,2])
		EndIf
	EndIf
	If _lRet
		_copnfacu:=""
		_cchavezz4:=""
		SC5->(dbSetOrder(1))
		SC6->(dbSetOrder(01)) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
		If nopcao==1 .AND. Len(_afilser) > 0
			For z:=1 to Len(_afilser)
				If _afilser[z,24]
					If  SC5->(dbSeek(xFilial("SC5") + _afilser[z,26])) .AND. SC6->(dbSeek(xFilial("SC6") + _afilser[z,26] + _afilser[z,27]))
						ZZ4->(dbgoto(_afilser[z,21]))
						Reclock("ZZ4",.F.)
						ZZ4->ZZ4_PVSERV :=_afilser[z,26]+_afilser[z,27]
						ZZ4->ZZ4_DTPVSE :=date()
						ZZ4->ZZ4_HRPVSE :=Time()
						msunlock()
						If (MV_PAR16==3 .OR. MV_PAR16==1)
							_cchavezz4 := ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+Alltrim(ZZ4->ZZ4_NFSNR)+Alltrim(ZZ4->ZZ4_NFSSER)
						Else
							_cchavezz4 := ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+LEFT(ZZ4->ZZ4_PV,6)+RIGHT(ZZ4->ZZ4_PV,2)
						EndIf
						If !(_cchavezz4) $  _copnfacu
							Begin Transaction
							RecLock("SZN",.T.)
							SZN->ZN_FILIAL 	:= xFilial("SZN")
							SZN->ZN_NFESEFA	:= ZZ4->ZZ4_NFSNR
							SZN->ZN_SERSEFA	:= ZZ4->ZZ4_NFSSER
							SZN->ZN_PEDVEND	:= _afilser[z,26]
							SZN->ZN_PEDNFSA := LEFT(ZZ4->ZZ4_PV,6)
							SZN->ZN_ITEMPSE := RIGHT(ZZ4->ZZ4_PV,2)
							MSUnlock("SZN")
							End Transaction
							_copnfacu:=_copnfacu+"/"+_cchavezz4
						EndIf
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Tratamento para erros.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_nPosimei := Ascan(_aErros ,{ |x| x[4] == _afilser[z,29]})
					_nPosOS   := Ascan(_aErros ,{ |x| x[5] == _afilser[z,30] })
					If _nPosimei <= 0 .AND. _nPosOS <= 0
						aAdd(_aErros,{nopcao,_afilser[z,29],_afilser[z,30],_afilser[z,2],_afilser[z,3],_afilser[z,25],_afilser[z,31],_afilser[z,20],_afilser[z,22]})
					EndIf
				EndIf
			Next
		ElseIf nopcao==2  .AND. Len(_afilser) > 0
			_aestrger:={}
			For z:=1 to Len(_afilser)
				If _afilser[z,24]
					If  SC5->(dbSeek(xFilial("SC5") + _afilser[z,26])) .AND. SC6->(dbSeek(xFilial("SC6") + _afilser[z,26]))
						ZZ4->(dbgoto(_afilser[z,21]))
						Reclock("ZZ4",.F.)
						ZZ4->ZZ4_PVPECA :=_afilser[z,26]
						ZZ4->ZZ4_DTPPEC :=date()
						ZZ4->ZZ4_HRPPEC :=Time()
						msunlock()
						If  date() < _dtaltfpc .AND. Len(_aitpecas) = 0
							_apcgerad:={}
							_apcgerad:=aclone(_afilser[z,28])
							For y:=1 to Len(_apcgerad)
								If Len(_apgtomot) > 0
									_nPospeca := Ascan(_apgtomot ,{ |x| x[2] == _apcgerad[y,3]})
								Else
									_nPospeca := 0
								EndIf
								_nposestr :=  Ascan(_aestrger, { |est| est[1] == _apcgerad[y,1]})
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Carrega array com estruturas para atualização da tabala ZAB para controle de vendas de peças.³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If _nposestr <= 0
									aAdd(_aestrger,{_apcgerad[y,1]})
								EndIf
								If _nPospeca <= 0
									Begin Transaction
									Reclock("ZZQ",.T.)
									ZZQ->ZZQ_FILIAL := XFILIAL("ZZQ")
									ZZQ->ZZQ_IMEI   := ZZ4->ZZ4_IMEI
									ZZQ->ZZQ_NUMOS  := ZZ4->ZZ4_OS
									ZZQ->ZZQ_PV     :=_afilser[z,26]
									ZZQ->ZZQ_ITEMPV :=_apcgerad[y,6]
									ZZQ->ZZQ_MODELO :=_apcgerad[y,2]
									ZZQ->ZZQ_CODEST := SPACE(15)
									ZZQ->ZZQ_NFS    := SPACE(nTamNfs)
									ZZQ->ZZQ_NFSSER := SPACE(nTamser)
									ZZQ->ZZQ_PECA   :=_apcgerad[y,3]
									ZZQ->ZZQ_QTDE   :=_apcgerad[y,5]
									ZZQ->ZZQ_VLRUNI :=_apcgerad[y,7]
									ZZQ->ZZQ_VLRTOT :=_apcgerad[y,5]*_apcgerad[y,7]
									msunlock()
									End Transaction
								Else
									aAdd(_apgtomot[_nPospeca,8],{ZZ4->(RECNO()),ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS})
								EndIf
							Next y
						ElseIf date() >= _dtaltfpc .AND. Len(_aitpecas) > 0
							_apcgerad:={}
							_apcgerad:=aclone(_aitpecas)
							For y:=1 to Len(_apcgerad)
								//SB1->(dbSeek(xFilial('SB1')+_apcgerad[y,3]))
								//Incluso soma de IPI para contemplar o valor total da nota com IPI - Edson Rodrigues - 23/09/14
								//_npercipi := SB1->B1_IPI
								//_npercipi := 1 + ( _npercipi / 100 )
								If _apcgerad[y,12] == "N"  .AND. left(_apcgerad[y,1],6)== left(ZZ4->ZZ4_OS,6) .AND. _apcgerad[y,14]==ZZ4->ZZ4_IMEI
									Begin Transaction
									Reclock("ZZQ",.T.)
									ZZQ->ZZQ_FILIAL := XFILIAL("ZZQ")
									ZZQ->ZZQ_IMEI   :=_apcgerad[y,14]
									ZZQ->ZZQ_NUMOS  :=_apcgerad[y,1]
									ZZQ->ZZQ_PV     :=_afilser[z,26]
									ZZQ->ZZQ_ITEMPV :=_apcgerad[y,6]
									ZZQ->ZZQ_MODELO :=_apcgerad[y,2]
									ZZQ->ZZQ_CODEST :=_apcgerad[y,1]
									ZZQ->ZZQ_NFS    := SPACE(nTamNfs)
									ZZQ->ZZQ_NFSSER := SPACE(nTamser)
									ZZQ->ZZQ_PECA   :=_apcgerad[y,3]
									ZZQ->ZZQ_QTDE   :=_apcgerad[y,5]
									ZZQ->ZZQ_VLRUNI :=_apcgerad[y,7]*_apcgerad[y,15]
									ZZQ->ZZQ_VLRTOT :=_apcgerad[y,5]*(_apcgerad[y,7]*_apcgerad[y,15])
									msunlock()
									SZ9->(dbgoto(_apcgerad[y,13]))
									Reclock("SZ9",.F.)
									SZ9->Z9_PEDPECA :=_afilser[z,26]+_apcgerad[y,6]
									msunlock()
									End Transaction
								EndIf
							Next y
						EndIf
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Tratamento para erros.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_nPosimei := Ascan(_aErros ,{ |x| x[4] == _afilser[z,29]})
					_nPosOS   := Ascan(_aErros ,{ |x| x[5] == _afilser[z,30] })
					If _nPosimei <= 0 .AND. _nPosOS <= 0
						aAdd(_aErros,{nopcao,_afilser[z,29],_afilser[z,30],_afilser[z,2],_afilser[z,3],_afilser[z,25],_afilser[z,31],_afilser[z,20],_afilser[z,22]})
					EndIf
				EndIf
			Next z
			If nopcao==2 .AND. Len(_aestrger) > 0
				For est:=1 to Len(_aestrger)
					u_atulzab(_aestrger[est,1])
				next
			EndIf
		EndIf
		_apcgerad:={}
		_afilser :={}
		_aestrger:={}
	Else
		If nopcao==1
			ApMsgInfo("Não foi possível gerar o Pedido de Serviços : "+cNrPV+" . Favor contatar o administrador do sistema.","Erro na geração do PV de serviços!")
		Else
			ApMsgInfo("Não foi possível gerar o Pedido de Peças : "+cNrPV+" . Favor contatar o administrador do sistema.","Erro na geração do PV de Pecas!")
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz baixa das peças apontadas como retrabalho.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nopcao==2 .AND. date() >= _dtaltfpc .AND. Len(_abaixret) > 0
		Processa( { |lfim| Movbaixa(@lfim,_abaixret[1,1],_abaixret,"R")},'Movimento de Baixa ', 'Baixando Peças Retrabalhadas', .T. )
		// Movbaixa(_abaixret[1,1],_abaixret,"R")
		_abaixret :={}
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz baixa das peças apontadas como duplicidas/perda ou se o rádio é  scrap.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nopcao==2 .AND. date() >= _dtaltfpc .AND. Len(_abaiscrd) > 0
		Processa( { |lfim| Movbaixa(@lfim,_abaiscrd[1,1],_abaiscrd,"SD")},'Movimento de Baixa ', 'Baixando Peças Scrap/Perdas', .T. )
		//Movbaixa(_abaiscrd[1,1],_abaiscrd,"SD")
		_abaiscrd :={}
	EndIf
	If _lrpvpgt .AND. Len(_apgtomot) > 0
		For z:= 1 to Len(_apgtomot)
			If _apgtomot[z,9]
				_aospcdev:={}
				_aospcdev:=aclone(_apgtomot[z,8])
				For y:=1  to Len(_aospcdev)
					ZZ4->(dbgoto(_aospcdev[y,1]))
					If FIELDPOS("ZZ4_PPGMON") > 0
						Reclock("ZZ4",.F.)
						ZZ4->ZZ4_PPGMON :=_apgtomot[z,10]
						msunlock()
					EndIf
					Begin Transaction
					Reclock("ZZQ",.T.)
					ZZQ->ZZQ_FILIAL := XFILIAL("ZZQ")
					ZZQ->ZZQ_IMEI   := ZZ4->ZZ4_IMEI
					ZZQ->ZZQ_NUMOS  := ZZ4->ZZ4_OS
					ZZQ->ZZQ_PV     :=_apgtomot[z,10]
					ZZQ->ZZQ_ITEMPV :=_apgtomot[z,11]
					ZZQ->ZZQ_MODELO :=_apgtomot[z,01]
					ZZQ->ZZQ_CODEST :=_apgtomot[z,12]
					ZZQ->ZZQ_NFS    := SPACE(nTamNfs)
					ZZQ->ZZQ_NFSSER := SPACE(nTamser)
					ZZQ->ZZQ_PECA   :=_apgtomot[z,02]
					ZZQ->ZZQ_QTDE   :=_apgtomot[z,04]/Len(_aospcdev)
					ZZQ->ZZQ_VLRUNI :=_apgtomot[z,05]
					ZZQ->ZZQ_VLRTOT :=(_apgtomot[z,04]/Len(_aospcdev))*_apgtomot[z,05]
					msunlock()
					End Transaction
				Next y
			EndIf
		Next z
		
	ElseIf !_lrpvpgt .AND. Len(_apgtomot) > 0
		ApMsgInfo("Não foi possível gerar o Pedido de pgto Peças motorola a Nextel . Favor contatar o administrador do sistema.","Erro na geração do PV de Pecas!")
	EndIf
	_apgtomot := {}
Next x
If  Len(_aErros) > 0
	ApMsgInfo("Houveram modelos que nao foram gerados. Favor analisar o relatório que será gerado na sequência e contate o administrador do sistema.","Modelos nao geraçãos !")
	u_errosftps(_aErros,"1")
EndIf
Return()                                           
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ filitservºAutor  ³Edson Rodrigues     º Data ³  16/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que agrupa os itens por produto e busca os valores  º±±
±±º          | de seviço na tabela de servico ZZP                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function filitserv(cItens)
Local newgar   := space(1)
Local newtsc   := space(2)
Local newcodp  := space(15)   
Local newoper  := space(15)
Local _nconprd := 0   
Local ctransc  := ""
Local _nPrcVen := 0                                     
Local _nPrctot := 0                
Local _vldesem := GetMV("MV_VLDESEM")                             
Local _vltdesm := 0                    
Local _sumqtot := 0
Local _ccodestr :=""
Local _amodestr := {}
Local _nvlrdesc := 0               		      
_afilser:={}
//                     1        2         3                      4                     5    6    7  8    9              10     11 12 13 14 15 16    17     18       19       20-opbgh     21-reczz4     22-garant       23-transc
//   aAdd(_agrpitm,{cItens,_cnewprod,SB1->B1_DESC,Iif(nopcao==1,_cTesser,_ctespec),_nqtde,_nqtde,'','',_nPrcVen,_nqtde*_nPrcVen,0,'','','','',0,_citlocal,ddatabase,'',_agerapv[ix,15],_agerapv[ix,16],_agerapv[ix,23],_agerapv[ix,24]})
If Len(_agrpitm) > 0
	For srv:=1  to Len(_agrpitm)
		If  newoper<>_agrpitm[srv,20] .OR.  newcodp<>_agrpitm[srv,2] //Alterado lógica para nao separar por operação conf. falado com Marcos Marques e Carlos Souza
			newcodp   :=_agrpitm[srv,2]
			newoper   :=_agrpitm[srv,20]
			SB1->(dbSeek(xFilial('SB1')+newcodp))
			_ccodestr :=SB1->B1_XCODEST
			_amodestr := {}
			_amodestr := u_FATA003A(_ccodestr,newoper,newcodp)
			If Len(_amodestr)>0 .AND. ZZP->(dbSeek(xFilial('ZZP')+ newoper + _amodestr[1,4]))
				For s:=1 to 2
					newgar    :=Iif(s==1,"S","N")
					ctransc   :=Iif(newgar=="S",Alltrim(ZZP->ZZP_TRAGAF),Alltrim(ZZP->ZZP_TRAFOG))
					_nPrctot  :=Iif(newgar=="S",ZZP->ZZP_VLRGAF,ZZP->ZZP_VLRFOG)
					_nPrcVen  :=Iif(newgar=="S",ZZP->ZZP_SRVGAF,ZZP->ZZP_SRVFOG)
					_cgaffog  :=Iif(newgar=="S","GAF","FOG")
					_cTes     := _agrpitm[srv,4]
					_nqtdetot := 0
					_nvlrpeca := 0
					lpass     :=.F.
					_codpros  :=Posicione("ZZJ",1,xFilial("ZZJ") + newoper,"ZZJ_CODPRS")
					SB1->(dbSeek(xFilial('SB1')+_codpros))
					_clocser  :=SB1->B1_LOCPAD
					cItens    := Soma1(cItens,2)
					_aospeca  := {}
					For xmds:=1   to  Len(_agrpitm)
						If newoper==_agrpitm[xmds,20] .AND.  newcodp==_agrpitm[xmds,2] .AND.  newgar==_agrpitm[xmds,22] .AND. !_agrpitm[xmds,24] // .AND. Alltrim(_agrpitm[xmds,23]) $ Alltrim(ctransc)  _citlocal==_agrpitm[xmds,17]
							_nqtdetot++
							_citLocal := _agrpitm[xmds,17]
							lpass:=.T.
							_agrpitm[xmds,24]:=.T.
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Compoe o valor das pecas vendidas.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If  date() >= _dtaltfpc
								ZZ4->(dbgoto(_agrpitm[xmds,21]))
								If !Empty(ZZ4->ZZ4_PVPECA)
									_nvlrpeca += precopeca(ZZ4->ZZ4_OS,ZZ4->ZZ4_IMEI,ZZ4->ZZ4_CODPRO,LEFT(ZZ4->ZZ4_PVPECA,6),ZZ4->ZZ4_GARMCL,ZZ4->ZZ4_OPEBGH)
								EndIf
								aAdd(_aospeca,{_agrpitm[xmds,21],ZZ4->ZZ4_OS,ZZ4->ZZ4_IMEI,ZZ4->ZZ4_CODPRO})
							EndIf
							aAdd(_afilser,{_agrpitm[xmds,1],_agrpitm[xmds,2],_agrpitm[xmds,3],_agrpitm[xmds,4],_agrpitm[xmds,5],_agrpitm[xmds,6],_agrpitm[xmds,7],_agrpitm[xmds,8],_agrpitm[xmds,9],;
							_agrpitm[xmds,10],_agrpitm[xmds,11],_agrpitm[xmds,12],_agrpitm[xmds,13],_agrpitm[xmds,14],_agrpitm[xmds,15],_agrpitm[xmds,16],_agrpitm[xmds,17],_agrpitm[xmds,18],;
							_agrpitm[xmds,19],_agrpitm[xmds,20],_agrpitm[xmds,21],_agrpitm[xmds,22],_agrpitm[xmds,23],.T.,"OK",_agrpitm[xmds,26],cItens,;
							_agrpitm[xmds,28],_agrpitm[xmds,29],_agrpitm[xmds,30],_agrpitm[xmds,31]})
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Tratamento para erros.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If s==2  .AND. newoper==_agrpitm[xmds,20] .AND. newcodp==_agrpitm[xmds,2]
								_nPosimei := Ascan(_afilser ,{ |x| x[29] == _agrpitm[xmds,29]})
								_nPosOS   := Ascan(_afilser ,{ |x| x[30] == _agrpitm[xmds,30] })
								If _nPosimei <= 0 .AND. _nPosOS <= 0
									aAdd(_afilser,{_agrpitm[xmds,1],_agrpitm[xmds,2],_agrpitm[xmds,3],_agrpitm[xmds,4],_agrpitm[xmds,5],_agrpitm[xmds,6],_agrpitm[xmds,7],_agrpitm[xmds,8],_agrpitm[xmds,9],;
									_agrpitm[xmds,10],_agrpitm[xmds,11],_agrpitm[xmds,12],_agrpitm[xmds,13],_agrpitm[xmds,14],_agrpitm[xmds,15],_agrpitm[xmds,16],_agrpitm[xmds,17],_agrpitm[xmds,18],;
									_agrpitm[xmds,19],_agrpitm[xmds,20],_agrpitm[xmds,21],_agrpitm[xmds,22],_agrpitm[xmds,23],.F.,;
									"Transaction Code :"+Alltrim(_agrpitm[xmds,23])+" nao encontrado na tabela de valores de servicos",;
									_agrpitm[xmds,26],cItens,_agrpitm[xmds,28],_agrpitm[xmds,29],_agrpitm[xmds,30],;
									"Cadastre o Transcode na tabela de valores serviços ou corrija o transcode do IMEI"})
								EndIf
							EndIf
						EndIf
					Next xmds
/*
					If _vldesem > 0
						_nPrcVen := _nPrcVen - _vldesem
					EndIf
*/
					If lpass
						_nvaltpec:=0.00
						_nvalupec:=0.00
						_nvalspec:=0.00
						_nqtdminp:=0
/*
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Codigo para tratamento de valores fixo.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If newoper="N11"
							cCMPTab     :='ZAB->ZAB_VLR'+Alltrim(STR(5))
							_nqtdminp   := 5
						Else
							cCMPTab     :='ZAB->ZAB_VLR'+Alltrim(STR(20))
							_nqtdminp   := 20
						EndIf
						dbSelectArea('ZAB')
						ZAB->(DBSetOrder(1)) //ZAB_FILIAL+ZAB_TPVAL+ZAB_ESTRUT+ZAB_TIPOLI+ZAB_PARTNR
						If ZAB->(dbSeek(xFilial('ZAB')+ 'PF'+_ccodestr+'VL'))
							_nvaltpec:=&cCMPTab
							_nvalupec:=_nvaltpec/_nqtdminp
							_nvalspec:=_nqtdetot*_nvalupec
							_nPrcVen := ((_nqtdetot*_nPrctot)-_nvalspec)/_nqtdetot
						Else
							lpass:=.F.
						EndIf
*/
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Compoe o novo preço unitáio do serviço.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  date() >= _dtaltfpc
						_nPrcVen := ((_nqtdetot*_nPrctot)-_nvlrpeca)/_nqtdetot
						If _nPrcVen <= 0
							If  _nPrcVen < 0
								_nPrcVen := (_nqtdetot*_nPrctot)/_nqtdetot
								_nvlrdesc:= _nvlrdesc+(_nqtdetot*_nPrctot)+((_nvlrpeca-(_nqtdetot*_nPrctot)))
							ElseIf _nPrcVen = 0
								_nPrcVen := (_nqtdetot*_nPrctot)/_nqtdetot
								_nvlrdesc:= _nvlrdesc+_nPrcVen
							EndIf
						EndIf
					EndIf
					If lpass .AND. _nPrcVen > 0
						aAdd(_aIteSC6,{{"C6_ITEM" ,cItens	          ,Nil},;
						{"C6_NUM"	            ,_agrpitm[srv,26]    ,Nil},;
						{"C6_PRODUTO"	        ,_codpros            ,Nil},;
						{"C6_DESCRI"	        ,SB1->B1_DESC        ,Nil},;
						{"C6_TES"		        ,_cTes				 ,Nil},;
						{"C6_QTDVEN"	        ,_nqtdetot  		 ,Nil},;
						{"C6_QTDLIB"	        ,_nqtdetot           ,Nil},;
						{"C6_NUMSERI"	        ,''                  ,Nil},;
						{"C6_NUMOS"		        ,''     			 ,Nil},;
						{"C6_PRCVEN"	        ,_nPrcVen			 ,Nil},;
						{"C6_VALOR"		        ,_nqtdetot*_nPrcVen	 ,Nil},;
						{"C6_PRUNIT"	        ,0					 ,Nil},;
						{"C6_VALDESC"	        ,0                 	 ,Nil},;
						{"C6_NFORI"		        ,''                  ,Nil},;
						{"C6_SERIORI"	        ,''                  ,Nil},;
						{"C6_ITEMORI"	        ,''                  ,Nil},;
						{"C6_IDENTB6"	        ,'' 			     ,Nil},;
						{"C6_PRCCOMP"	        , 0        			 ,Nil},;
						{"C6_LOCAL"		        ,_clocser            ,Nil},;
						{"C6_ENTREG"	        ,dDataBase			 ,Nil},;
						{"C6_AEXPGVS"	        ,_cgaffog+'|'+newoper+'|mod: '+Alltrim(newcodp),Nil}})
						// {"C6_LOCALIZ"		    ,Nil                 ,Nil},;
						_vltdesm:=_vltdesm+(_nqtdetot*_vldesem)
						_sumqtot:=_sumqtot+_nqtdetot
					ElseIf date() >= _dtaltfpc .AND. lpass .AND. _nPrcVen <= 0 .AND. Len(_aospeca) > 0
						For os:=1 to Len(_aospeca)
							ZZ4->(dbgoto(_aospeca[os,1]))
							Reclock("ZZ4",.F.)
							ZZ4->ZZ4_PVSERV :="SEMPVS"
							ZZ4->ZZ4_DTPVSE :=date()
							ZZ4->ZZ4_HRPVSE :=Time()
							msunlock()
						next os
					EndIf
				Next s
				If _vltdesm > 0
					_nPosmnot := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENNOTA" })
					If _nPosmnot > 0
						//_aCabSC5[_nPosmnot,2] := "DESCONTO MATERIAL APLICADO EM GARANTIA R$ "+Transform(_vltdesm,'@E 999,999.99')+" /RETORNO DE NF: "
						_aCabSC5[_nPosmnot,2] := "DESCONTO FINANCEIRO  R$ "+Transform(_vltdesm,'@E 999,999.99')+" / QTD. ITENS ENVOLVIDOS "+Transform(_sumqtot,'@E 999999')+" / RETORNO DE NF: "
					EndIf
				EndIf
			Else
				If Len(_amodestr)>0 .AND. !ZZP->(dbSeek(xFilial('ZZP')+ _amodestr[1,3]))
					_nPosimei := Ascan(_afilser ,{ |x| x[29] == _agrpitm[srv,29]})
					_nPosOS   := Ascan(_afilser ,{ |x| x[30] == _agrpitm[srv,30] })
					If _nPosimei <= 0 .AND. _nPosOS <= 0
						aAdd(_afilser,{_agrpitm[srv,1],_agrpitm[srv,2],_agrpitm[srv,3],_agrpitm[srv,4],_agrpitm[srv,5],_agrpitm[srv,6],_agrpitm[srv,7],_agrpitm[srv,8],_agrpitm[srv,9],;
						_agrpitm[srv,10],_agrpitm[srv,11],_agrpitm[srv,12],_agrpitm[srv,13],_agrpitm[srv,14],_agrpitm[srv,15],_agrpitm[srv,16],_agrpitm[srv,17],_agrpitm[srv,18],;
						_agrpitm[srv,19],_agrpitm[srv,20],_agrpitm[srv,21],_agrpitm[srv,22],_agrpitm[srv,23],.F.,;
						"CODIGO DA OPERACAO NAO ENCONTRADO NA ZZP",_agrpitm[srv,26],cItens,_agrpitm[srv,28],_agrpitm[srv,29],_agrpitm[srv,30],;
						"Cadastre a Operação no cadastro de valores de Serviços ou corrija a operação para o IMEI"})
					EndIf
				ElseIf Len(_amodestr)>0 .AND. !ZZP->(dbSeek(xFilial('ZZP')+ _amodestr[1,3] + _amodestr[1,4]))
					_nPosimei := Ascan(_afilser ,{ |x| x[29] == _agrpitm[srv,29]})
					_nPosOS   := Ascan(_afilser ,{ |x| x[30] == _agrpitm[srv,30] })
					If _nPosimei <= 0 .AND. _nPosOS <= 0
						aAdd(_afilser,{_agrpitm[srv,1],_agrpitm[srv,2],_agrpitm[srv,3],_agrpitm[srv,4],_agrpitm[srv,5],_agrpitm[srv,6],_agrpitm[srv,7],_agrpitm[srv,8],_agrpitm[srv,9],;
						_agrpitm[srv,10],_agrpitm[srv,11],_agrpitm[srv,12],_agrpitm[srv,13],_agrpitm[srv,14],_agrpitm[srv,15],_agrpitm[srv,16],_agrpitm[srv,17],_agrpitm[srv,18],;
						_agrpitm[srv,19],_agrpitm[srv,20],_agrpitm[srv,21],_agrpitm[srv,22],_agrpitm[srv,23],.F.,;
						"PRODUTO (REF. ESTRUTURA) NAO ENCONTRADO NA ZZP",_agrpitm[srv,26],cItens,_agrpitm[srv,28],_agrpitm[srv,29],_agrpitm[srv,30],;
						"Cadastre a Operação no cadastro de valores de Serviços ou corrija a operação para o IMEI"})
					EndIf
				ElseIf Len(_amodestr)<=0
					_nPosimei := Ascan(_afilser ,{ |x| x[29] == _agrpitm[srv,29]})
					_nPosOS   := Ascan(_afilser ,{ |x| x[30] == _agrpitm[srv,30] })
					If _nPosimei <= 0 .AND. _nPosOS <= 0
						aAdd(_afilser,{_agrpitm[srv,1],_agrpitm[srv,2],_agrpitm[srv,3],_agrpitm[srv,4],_agrpitm[srv,5],_agrpitm[srv,6],_agrpitm[srv,7],_agrpitm[srv,8],_agrpitm[srv,9],;
						_agrpitm[srv,10],_agrpitm[srv,11],_agrpitm[srv,12],_agrpitm[srv,13],_agrpitm[srv,14],_agrpitm[srv,15],_agrpitm[srv,16],_agrpitm[srv,17],_agrpitm[srv,18],;
						_agrpitm[srv,19],_agrpitm[srv,20],_agrpitm[srv,21],_agrpitm[srv,22],_agrpitm[srv,23],.F.,;
						"NENHUM MODELO (REF. ESTRUTURA) ENCONTRADO NA ZZP",_agrpitm[srv,26],cItens,_agrpitm[srv,28],_agrpitm[srv,29],_agrpitm[srv,30],;
						"Cadastre a Operação no cadastro de valores de Serviços ou corrija a operação para o IMEI"})
					EndIf
				EndIf
			EndIf
		EndIf
	Next srv
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Aplica desconto nos itens do pedido quando há valor de peça maior que o serviço - 13/08/14 - Edson Rodrigues.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nvlrdesc > 0 .AND. Len(_aIteSC6) > 0
		nnvditem:=_nvlrdesc/Len(_aIteSC6)
		For IX:=1 to Len(_aIteSC6)
			If nnvditem  <  _aIteSC6[IX,11,2]
				_aIteSC6[IX,13,2]:=nnvditem
				nnvditem:=(_nvlrdesc/(len(_aIteSC6)-IX))
			Else
				nnvditem:=nnvditem+(nnvditem/Len(_aIteSC6)-I)
			EndIf
		Next
		For t:=1 to 20
			If _nvlrdesc > 0
				nnvditem:=_nvlrdesc/len(_aIteSC6)
				For IX:=1 to len(_aIteSC6)
					If nnvditem  <  (_aIteSC6[IX,11,2]-_aIteSC6[IX,13,2])
						_aIteSC6[IX,13,2]:=_aIteSC6[IX,13,2]+nnvditem
						_nvlrdesc:=_nvlrdesc-nnvditem
					Else
						nnvditem:= (_nvlrdesc/(len(_aIteSC6)-IX))
					Endif
				Next
			Endif
		Next
	EndIf
	If _nvlrdesc <> 0
		ApMsgInfo("Houve problema no calculo de desconto na tentativa de gerar o pedido de Serviço : "+ _aIteSC6[1,2,2]+".","Contate o Administrado do Sistema")
		_aIteSC6:={}
	EndIf
/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Aplica desconto no valor de desconto como desconto financeiro no pedido - 13/08/14  - Edson Rodrigues.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nvalittot := 0.00
	If _nvlrdesc > 0 .AND. Len(_aIteSC6) > 0
		For IX:=1 to Len(_aIteSC6)
			nvalittot :=nvalittot+_aIteSC6[IX,11,2]
		Next
		ndescfin:=_nvlrdesc/nvalittot*100
		_nPosdesf := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_DESCFI" })
		If _nPosdesf > 0
			_aCabSC5[_nPosdesf,2] := ndescfin
		EndIf
	EndIf
*/
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³filitpec  ºAutor  ³Microsiga           º Data ³  09/26/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          | Funcao que filtra as peças baseada na estrutura e monta o  º±±
±±º          | o array dos pedidos de peças                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function filitpec(cItens)
Local newgar    := space(1)
Local newtsc    := space(2)
Local newcodp   := space(15)   
Local newoper   := space(15)
Local _nconprd  := 0   
Local ctransc   := ""
Local _nPrcVen  := 0                                                                              
Local carmproc  := ""    
Local ccuspec   := ""
Local ncusto    := 0   
Local _cestado  := space(2)                        
Local _npcreduz := GetMV("MV_XPCREDU")                  
Local _carmpgtm := "M0"
Local _carmtmot := "00" 
Local _ctespgto := "814"            
Local _nrestdiv := 0.00                   
Local _ntotdesc := 0.00
Local _coper    := ""   
Local _canomes  := SUBSTR((DTOS(ddatabase)),1,4)+SUBSTR(DTOC(ddatabase),4,2)        
_nValTotPec :=0.00
_nValPecas  :=0.00
_afilser  :={}             
_aIteSC6  :={}
_apgtomot :={}
If date() >= _dtaltfpc
	u_filpecnew()
	Return
END
//                     1        2         3                      4                     5    6    7  8    9              10     11 12 13 14 15 16    17     18       19       20-opbgh     21-reczz4     22-garant       23-transc
//   aAdd(_agrpitm,{cItens,_cnewprod,SB1->B1_DESC,Iif(nopcao==1,_cTesser,_ctespec),_nqtde,_nqtde,'','',_nPrcVen,_nqtde*_nPrcVen,0,'','','','',0,_citlocal,ddatabase,'',_agerapv[ix,15],_agerapv[ix,16],_agerapv[ix,23],_agerapv[ix,24]})
If Len(_agrpitm) > 0
	For srv:=1  to Len(_agrpitm)
		//If  (newoper <> _agrpitm[srv,20]) .OR. (newcodp  <> _agrpitm[srv,2])
		If  (newcodp  <> _agrpitm[srv,2])
			newcodp   := _agrpitm[srv,2]
			_cTes     := _agrpitm[srv,4]
			_citLocal := _agrpitm[srv,17]
			_nqtdetot := 0
			_nqtdemod := 0
			_ccodestr :=""
			_aitempc  :={}
			lpass     :=.F.
			newoper   := _agrpitm[srv,20]
			carmproc  :=Posicione("ZZJ",1,xFilial("ZZJ") + newoper, "ZZJ_ALMEP")
			cgrpoper  :=Iif(newoper $ "N01/N10","REFCDS","REFLOJ")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Colocada essa validação pois como a operaçao N10 e N11³
			//³começaram a apontar peca na operacao, o armazem       ³
			//³cadastrado ficou o 15 porem para venda de peca,       ³
			//³temos que usar o 01.                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If newoper $ "N10/N11"
				carmproc:="01"
			EndIf
			ccuspec    :=Posicione("ZZJ",1,xFilial("ZZJ") + newoper, "ZZJ_CUSPEC")
			SB1->(dbSeek(xFilial('SB1')+newcodp))
			SF4->(dbSeek(xFilial('SF4')+_cTes))
			SA1->(dbSeek(xFilial('SA1')+_aCabSC5[3,2]+_aCabSC5[4,2]))
			ZAB->(DBSetOrder(2)) //ZAB_FILIAL+ZAB_TPVAL+ZAB_ANOMES+ZAB_GROPER+ZAB_ESTRUT+ZAB_TIPOLI+ZAB_PARTNR
			_cestado   :=Posicione("SA1",1,xFilial("SA1") + _aCabSC5[3,2]+_aCabSC5[4,2], "A1_EST")
			_ccodestr:=SB1->B1_XCODEST
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se ja houve vendas de aparelho no mes, caso nao houve, entao preenche dados na tabela ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+cgrpoper+_ccodestr+'QO'))
				u_Fata0003(2,_ccodestr,cgrpoper,'',0,newoper)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Filtra a estrutura do modelo.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_aitempc :=U_filtestr(_ccodestr,newcodp,@cItens)
			For xmds:= 1    to  Len(_agrpitm)
				If newcodp==_agrpitm[xmds,2]
					_nqtdemod++
				EndIf
				If newoper==_agrpitm[xmds,20] .AND.  newcodp==_agrpitm[xmds,2]  .AND. !_agrpitm[xmds,24] .AND. Len(_aitempc) > 0 //.AND. _citlocal==_agrpitm[xmds,17]
//                          If   newcodp==_agrpitm[xmds,2]  .AND. !_agrpitm[xmds,24] .AND. Len(_aitempc) > 0 //.AND. _citlocal==_agrpitm[xmds,17]
					_nqtdetot++
					lpass :=.T.
					_agrpitm[xmds,24]:=.T.
					If  !newoper $ _coper
						If Empty(_coper)
							_coper:=newoper
						Else
							_coper:=_coper+"/"+newoper
						EndIf
					EndIf
					aAdd(_afilser,{_agrpitm[xmds,1],_agrpitm[xmds,2],_agrpitm[xmds,3],_agrpitm[xmds,4],_agrpitm[xmds,5],_agrpitm[xmds,6],_agrpitm[xmds,7],_agrpitm[xmds,8],_agrpitm[xmds,9],;
					_agrpitm[xmds,10],_agrpitm[xmds,11],_agrpitm[xmds,12],_agrpitm[xmds,13],_agrpitm[xmds,14],_agrpitm[xmds,15],_agrpitm[xmds,16],_agrpitm[xmds,17],_agrpitm[xmds,18],;
					_agrpitm[xmds,19],_agrpitm[xmds,20],_agrpitm[xmds,21],_agrpitm[xmds,22],_agrpitm[xmds,23],.T.,"OK",_agrpitm[xmds,26],cItens,;
					_aitempc,_agrpitm[xmds,29],_agrpitm[xmds,30],_agrpitm[xmds,31]})
					
				Else
					If newoper==_agrpitm[xmds,20] .AND. newcodp==_agrpitm[xmds,2] .AND. !_agrpitm[xmds,24]
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Tratamento para erros.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_nPosimei := Ascan(_afilser ,{ |a| a[29] == _agrpitm[xmds,29]})
						_nPosOS   := Ascan(_afilser ,{ |b| b[30] == _agrpitm[xmds,30] })
						If _nPosimei <= 0 .AND. _nPosOS <= 0 .AND. newoper==_agrpitm[xmds,20] .AND.  newcodp==_agrpitm[xmds,2]
							aAdd(_afilser,{_agrpitm[xmds,1],_agrpitm[xmds,2],_agrpitm[xmds,3],_agrpitm[xmds,4],_agrpitm[xmds,5],_agrpitm[xmds,6],_agrpitm[xmds,7],_agrpitm[xmds,8],_agrpitm[xmds,9],;
							_agrpitm[xmds,10],_agrpitm[xmds,11],_agrpitm[xmds,12],_agrpitm[xmds,13],_agrpitm[xmds,14],_agrpitm[xmds,15],_agrpitm[xmds,16],_agrpitm[xmds,17],_agrpitm[xmds,18],;
							_agrpitm[xmds,19],_agrpitm[xmds,20],_agrpitm[xmds,21],_agrpitm[xmds,22],_agrpitm[xmds,23],.F.,;
							"Operacao : "+_agrpitm[xmds,20]+" e ou produto :"+Alltrim(_agrpitm[xmds,2])+" nao adicionado para geração do pedido",;
							_agrpitm[xmds,26],@cItens,_agrpitm[xmds,28],_agrpitm[xmds,29],_agrpitm[xmds,30],;
							"Analisar - Contate o Administrador"})
						EndIf
					EndIf
				EndIf
			Next xmds
/*
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Codigo para Preço Fixo - Processo anterior.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If newoper=="N11
				_nrestdiv:=_nqtdemod%5
			ElseIf  newoper $ "N01/N10"
				_nrestdiv:=_nqtdemod%20
			EndIf
			If _nrestdiv > 0
				lpass:=.F.
			EndIf
*/
			If Len(_aitempc) > 0 .AND. SF4->F4_ESTOQUE<>'S' .AND. lpass
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
				//³Atualiza tabela auxiliar de controle de vendas por operacao e pecas.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ
				u_atulzab(_ccodestr)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³FIltra valores de servicoes e pecas na tabela ZZP.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				u_filtzzp(newoper,_agrpitm[srv,2],_agrpitm[srv,22],_ccodestr,@_nValTotPec,@_nValPecas,0)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Busca o custo do produto e calcula x quantidade de aparelho.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				u_buscust(_npcreduz,_cestado,carmproc,carmproc,ccuspec,_carmpgtm,@_nqtde,@_nqtdetot,@_nValTotPec,cgrpoper,_ccodestr)
				_nDiferenca	:= _nValPecas - _nValTotPec
				_nPercDif	:= _nValPecas / _nValTotPec * 100 - 100
				_nrestante  := _nDiferenca
				For xipcd:=1 to Len(_aitempc)
					_larmzpgt :=.F.
					_nqtde :=0.00
					_nquant:=0.00
					_nquatu:=0.00
					_nqtdecalc :=0.00
					_nvaldesc := 0.00
/*
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Codigo para Preco Fixo.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea('ZAB')
					ZAB->(DBSetOrder(1)) //ZAB_FILIAL+ZAB_TPVAL+ZAB_ESTRUT+ZAB_TIPOLI+ZAB_PARTNR
					If ZAB->(dbSeek(xFilial('ZAB')+'PF'+_ccodestr+'PC'+_aitempc[xipcd,3]))
						If newoper="N11"
							cCMPTab     :='ZAB->ZAB_VLR'+Alltrim(STR(5))
							_nqtdminp   := 5
						Else
							cCMPTab     :='ZAB->ZAB_VLR'+Alltrim(STR(20))
							_nqtdminp   := 20
						EndIf
						If &cCMPTab > 0
							_aitempc[xipcd,7] :=ZAB->ZAB_PRECOU
							If _nqtdemod==_nqtdetot
								_nqtde      := _nqtdetot * ((&cCMPTab/ZAB->ZAB_PRECOU)/_nqtdminp)
							Else
								_nquatu      :=_nqtdetot * ((&cCMPTab/ZAB->ZAB_PRECOU)/_nqtdminp)
								_nquant      :=(_nqtdemod-_nqtdetot) * ((&cCMPTab/ZAB->ZAB_PRECOU)/_nqtdminp)
								_nqtdecalc   :=_nqtdemod*((&cCMPTab/ZAB->ZAB_PRECOU)/_nqtdminp)
								_nqtde       :=round(_nquatu,0)
								_nqtde       :=Iif(_nqtde<1,1,_nqtde)
							EndIf
						Else
							_aitempc[xipcd,7]:=0.00
						EndIf
					EndIf
*/
					If  _aitempc[xipcd,7] > 0
/*
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
						//³calculo da quantidade para regras anteriories - Preco variavel e preco fixo.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
						_nqtde      :=Iif(_nqtdetot*_aitempc[xipcd,5] < 1,1,round(_nqtdetot*_aitempc[xipcd,5],0))
						_nqtde  := int(_nqtdetot*_aitempc[xipcd,5],0)
*/
						_nqtde:=_aitempc[xipcd,11]
						_nPercPeca	:= (_aitempc[xipcd,7] / _nValTotPec) * 100
						If _aitempc[xipcd,8] == _carmpgtm
							If SB2->(dbSeek(xFilial('SB2')+_aitempc[xipcd,3]+_carmpgtm))
								nSalb2:=SaldoSB2(nil,nil,dDatabase,.T.,.T.,nil,0,0,.T.)
								nsalc6:=u_salpvab(_aitempc[xipcd,3],_carmpgtm)
								nSalb2:=nSalb2-nsalc6
								If  nSalb2 >= _nqtde
									aAdd(_apgtomot,{newcodp,_aitempc[xipcd,3],_carmpgtm,_nqtde,ncusto,_ctespgto,'Oper: '+newoper+' mod: '+Alltrim(newcodp),{},.F.,SPACE(6),space(2),_aitempc[xipcd,1]})
									_larmzpgt:=.T.
								EndIf
							EndIf
						EndIf
						If !_larmzpgt
							SB1->(dbSeek(xFilial('SB1')+_aitempc[xipcd,3]))
							_npercipi := SB1->B1_IPI
							_npercipi := 1 + ( _npercipi / 100 )
/*
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Codigo para Preço Fixo.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							_aitempc[xipcd,7] := _aitempc[xipcd,7] / _npercipi
							If _nqtdemod<>_nqtdetot
								_nvaldesc :=round(_nqtde*_aitempc[xipcd,7],5)-(_nqtde*(ZAB->ZAB_PRECOU/_npercipi))
								_nvaldesc :=Iif(_nvaldesc > 0,_nvaldesc,0)
								_ntotdesc +=_nvaldesc
								If round(_aitempc[xipcd,7],5)-(ZAB->ZAB_PRECOU/_npercipi) > 0
									_aitempc[xipcd,7]:=_aitempc[xipcd,7]-(round(_aitempc[xipcd,7],5)-(ZAB->ZAB_PRECOU/_npercipi))
								EndIf
							EndIf
*/
							If _nDiferenca > 0    //  lançar acréscimos no ítem
								_aitempc[xipcd,7] :=	_aitempc[xipcd,7]  + (_nDiferenca  * _nPercPeca / 100)
								_aitempc[xipcd,7] := _aitempc[xipcd,7] / _npercipi
								_nrestante := _nrestante - (_nDiferenca  * _nPercPeca / 100)
							Else    // lançar descontos no ítem
								_aitempc[xipcd,7]	:=	_aitempc[xipcd,7]  - (abs(_nDiferenca)  * abs(_nPercPeca) / 100)
								_aitempc[xipcd,7]	:= _aitempc[xipcd,7] / _npercipi
								_nrestante := _nrestante - (abs(_nDiferenca)  * abs(_nPercPeca) / 100)
							EndIf
							//Verifica se o valor Total e menor que 0,01, caso positivo altera o custo para esse valor.
							If round(_nqtde*_aitempc[xipcd,7],5) < 0.01
								_nvlrunit :=  0.01/_nqtde
								_aitempc[xipcd,7]:=_nvlrunit
							EndIf
							aAdd(_aIteSC6,{;
							{"C6_ITEM"		,_aitempc[xipcd,6]						,Nil},;
							{"C6_NUM"		,_agrpitm[srv,26]						,Nil},;
							{"C6_PRODUTO"	,_aitempc[xipcd,3]						,Nil},;
							{"C6_DESCRI"	,_aitempc[xipcd,4]						,Nil},;
							{"C6_TES"		,_cTes									,Nil},;
							{"C6_QTDVEN"	,_nqtde									,Nil},;
							{"C6_QTDLIB"	,_nqtde									,Nil},;
							{"C6_NUMSERI"	,""										,Nil},;
							{"C6_NUMOS"		,"" 									,Nil},;
							{"C6_PRCVEN"	,_aitempc[xipcd,7]						,Nil},;
							{"C6_VALOR"		,round(_nqtde*_aitempc[xipcd,7],5)		,Nil},;
							{"C6_PRUNIT"	,0										,Nil},;
							{"C6_VALDESC"	,_nvaldesc 								,Nil},;
							{"C6_NFORI"		,""										,Nil},;
							{"C6_SERIORI"	,""										,Nil},;
							{"C6_ITEMORI"	,""										,Nil},;
							{"C6_IDENTB6"	,"" 									,Nil},;
							{"C6_PRCCOMP"	,0 										,Nil},;
							{"C6_LOCAL"		,carmproc								,Nil},;
							{"C6_ENTREG"	,dDataBase								,Nil},;
							{"C6_AEXPGVS"	,"Op: "+_coper+" md: "+Alltrim(newcodp)	,Nil}})
							//{"C6_LOCALIZ"		    ,Nil                          ,Nil},;
						EndIf
					EndIf
				Next xipcd
			Else
				_nPosimei := Ascan(_afilser ,{ |x| x[29] == _agrpitm[srv,29]})
				_nPosOS   := Ascan(_afilser ,{ |x| x[30] == _agrpitm[srv,30] })
				If _nPosimei <= 0 .AND. _nPosOS <= 0
					If Len(_aitempc) <= 0
						_cproblem:="Não foi encontrado nenhuma estrutura para o modelo :"+Alltrim(newcodp)
					ElseIf SF4->F4_ESTOQUE='S'
						_cproblem:="TES : "+_cTes+" movimenta estoque - Não permitido"
					ElseIf lpass = .F. .AND. _nrestdiv > 0 .AND. newoper='N11'
						_cproblem:="Quantidade do Modelo : "+Alltrim(newcodp)+" na operação: "+newoper+" nao é multipo de 5 - Não permitido"
					ElseIf lpass = .F. .AND. _nrestdiv > 0 .AND. newoper<>'N11'
						_cproblem:="Quantidade do Modelo : "+Alltrim(newcodp)+" na operação: "+newoper+" nao é multipo de 20 - Não permitido"
					Else
						_cproblem:="Problema no processamento - Nao adicionado no array "
					EndIf
					If Len(_aitempc) <= 0
						_csolucao :="Cadastre a estrutura com o código : "+Alltrim(newcodp)+" ou amarre esse códig no produto : "+newcodp
					Else
						_csolucao :="Analisar - Contate o Administrador"
					EndIf
					aAdd(_afilser,{_agrpitm[srv,1],_agrpitm[srv,2],_agrpitm[srv,3],_agrpitm[srv,4],_agrpitm[srv,5],_agrpitm[srv,6],_agrpitm[srv,7],_agrpitm[srv,8],_agrpitm[srv,9],;
					_agrpitm[srv,10],_agrpitm[srv,11],_agrpitm[srv,12],_agrpitm[srv,13],_agrpitm[srv,14],_agrpitm[srv,15],_agrpitm[srv,16],_agrpitm[srv,17],_agrpitm[srv,18],;
					_agrpitm[srv,19],_agrpitm[srv,20],_agrpitm[srv,21],_agrpitm[srv,22],_agrpitm[srv,23],.F.,_cproblem,;
					_agrpitm[srv,26],@cItens,_agrpitm[srv,28],_agrpitm[srv,29],_agrpitm[srv,30],_csolucao})
				EndIf
			EndIf
		EndIf
	Next srv
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Filtestr ºAutor  ³Edson Rodrigues     º Data ³  15/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para selecionar a estrutura do modelo               º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Filtestr(_codestr,_cCodPro)
Local _aestrut  :={}
Local _ccompnew :=""
Local _ddatanew :=CTOD(" / / ")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se For um pedido de kit, gravar demais produtos que constam na estrutura desse item.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(_codestr)
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
	dbSelectArea("SG1")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordena a tabela no indice mais proximo que sera executada a query - Edson Rodrigues 14/04/10.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT G1_COD, G1_COMP, G1_QUANT,G1_INI,G1_FIM, B1_UM, B1_LOCPAD, B1_DESC, B1_PRV1,G1_XARMPGT "
	cQuery += "FROM "+ RetSqlName("SG1")+" SG1 (nolock) ,"
	cQuery += RetSqlName("SB1") + " SB1 (nolock) "
	cQuery += " WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' AND "
	cQuery += "      SG1.G1_COD = '" +_codestr+"'   AND "
	cQuery += "      SG1.G1_COMP <> '"+_cCodPro+"' AND "
	cQuery += "      SG1.D_E_L_E_T_ <> '*'    AND "
	cQuery += "      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cQuery += "      SB1.B1_COD = SG1.G1_COMP AND "
	cQuery += "      SB1.D_E_L_E_T_ <> '*' AND "
	cQuery += "      SG1.G1_INI<='"+dtos(ddatabase)+"' AND SG1.G1_FIM>='"+dtos(ddatabase)+"' "
	cQuery += "      ORDER BY SG1.G1_COD,SG1.G1_QUANT DESC "
	TCQUERY cQUERY NEW ALIAS "QRY"
	dbSelectArea("QRY")
	QRY->(dbGoTop())
	While QRY->(!Eof())
		If QRY->G1_COMP <> _ccompnew
			_ccompnew := QRY->G1_COMP
			cItens     := Soma1(cItens,2)
			_ccompon   :=QRY->G1_COMP
			_cproddesc :=QRY->B1_DESC
			_nqtde     :=QRY->G1_QUANT
			_carmpgt   :=QRY->G1_XARMPGT
			//                aAdd(_aestrut,{_codestr,_cCodPro,_ccompon,_cproddesc,_nqtde,cItens,0,_carmpgt})
			aAdd(_aestrut,{_codestr,_cCodPro,_ccompon,_cproddesc,_nqtde,cItens,0,_carmpgt, 0, 0,0})
		EndIf
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())
EndIf
Return(_aestrut)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ pvpgtom  ºAutor  ³Edson Rodrigues     º Data ³  13/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que faz validacoes e gera pedido de devolucao de    º±±
±±º            peças a Nextel- pagamento Motorola                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function pvpgtom(nopcao,cdivneg,cclinex,clojnex)
Local bAcao   := {|lFim| runpvpgt(@lFim,nopcao,cdivneg,cclinex,clojnex)}
Local cTitulo := ""
Local cMsg    := If(nopcao==1,'Processando Pedido devolucao de peças a Nextel...', 'Processando Pedido devol. Peças a Nextel...')
Local lAborta := .T.
Processa( bAcao, cTitulo, cMsg, lAborta )
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ runpvpgt ºAutor  ³Edson Rodrigues     º Data ³  13/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que o gera o pedido de pecas pagto motorola a Nextelº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function runpvpgt(lFim,nopcao,cdivneg,cclinex,clojnex)
Local cclimot   := "000008"
Local clojmot   := "01"
Local _cnewloc  := "M0"
Local cItpvpg   := '00'
Local _nConPED  := 0
Local _carmzmot := "00"
SA1->(dbSeek(xFilial('SA1')+cclinex+clojnex))
_cmenpad   :=""
cKit       :=""
_cdivneg   :=cdivneg
_aCabSC5   := {}
_aIteSC6   := {}
_ctransp   := Iif(nopcao==2,"56","")
_ctransp   := Iif(Empty(_ctransp),SA1->A1_TRANSP,_ctransp)
_cmenpad   := Iif(nopcao==2,"024","")
_cmenpad   := Iif(nopcao==2,Iif(Empty(_cmenpad),SA1->A1_MENSAGE,_cmenpad),'024')
_cdivneg   := Iif(Empty(_cdivneg),'09',_cdivneg)
_condpgto  := Iif(nopcao==2,'479','479')
_aAreaSC5  := SC5->(GetArea())
_nConPED++
_nqtdetot  := 0
cItens     := '00'
_cnfssai   :=""
//cNrPV:= GetSxeNum('SC5','C5_NUM')
cNrPV:=GetSx8Num('SC5','C5_NUM')
ConfirmSX8()
_aCabSC5 := { {"C5_TIPO"  ,"N"            ,Nil},;
{"C5_NUM"	      ,cNrPV              ,Nil},;
{"C5_CLIENTE"	  ,cclinex            ,Nil},;
{"C5_LOJACLI"	  ,clojnex            ,Nil},;
{"C5_LOJAENT"	  ,clojnex            ,Nil},;
{"C5_TIPOCLI"	  ,"F"                ,Nil},;
{"C5_CONDPAG"	  ,_condpgto          ,Nil},;
{"C5_TIPLIB"	  ,'1'	   		      ,Nil},;
{"C5_TPCARGA"	  ,'2'	   		      ,Nil},;
{"C5_B_KIT"	  ,cKit   		      ,Nil},;
{"C5_XUSER"	  ,Alltrim(cusername) ,Nil},;
{"C5_TRANSP"    ,_ctransp            ,Nil},;
{"C5_MENPAD"    ,_cmenpad            ,Nil},;
{"C5_DIVNEG"    ,_cdivneg            ,Nil},;
{"C5_MENNOTA"	 ,''      			  ,Nil}}
//aAdd(_apgtomot,{newcodp,_aitempc[xipcd,3],_carmpgtm,_nqtde,ncusto,_ctespgto,'Oper: '+newoper+' mod: '+Alltrim(newcodp)})
For xpgt:=1 to Len(_apgtomot)
	SB1->(dbSeek(xFilial('SB1')+_apgtomot[xpgt,2]))
	_aprodpgm := {}
	_nSaldo   := _apgtomot[xpgt,4]
	_aprodpgm:=salP3pgm(_apgtomot[xpgt,2],cclimot,clojmot,_nSaldo,_carmzmot)
	If Len(_aprodpgm) > 0
		For x:=1 to Len(_aprodpgm)
			_nSPaltp3:=_aprodpgm[x,5]
			_nQtRet3 := Iif(_nSPaltp3 >= _nSaldo, _nSaldo,_nSPaltp3)
			If _nQtRet3 > 0
				_nSaldo  := _nSaldo - _nQtRet3
				_nPrcVen := A410Arred(_aprodpgm[x,6],"C6_VALOR")
				_nValor  := A410Arred(_aprodpgm[x,6] * _nQtRet3,"C6_VALOR")
				cItpvpg    := Soma1(cItpvpg,2)
				aAdd(_aIteSC6,{ {"C6_ITEM"	   , cItpvpg           ,Nil},;
				{"C6_NUM"	   , cNrPV             ,Nil},;
				{"C6_PRODUTO"  , _apgtomot[xpgt,2]  ,Nil},;
				{"C6_DESCRI"   , SB1->B1_DESC       ,Nil},;
				{"C6_TES"	   , _apgtomot[xpgt,6]  ,Nil},;
				{"C6_QTDVEN"   , _nQtRet3           ,Nil},;
				{"C6_QTDLIB"   , _nQtRet3           ,Nil},;
				{"C6_NUMSERI"  , ''                 ,Nil},;
				{"C6_NUMOS"	   ,''     			    ,Nil},;
				{"C6_PRCVEN"   ,_nPrcVen            ,Nil},;
				{"C6_VALOR"	   ,_nValor             ,Nil},;
				{"C6_PRUNIT"   ,0					 ,Nil},;
				{"C6_VALDESC"  ,0               	  ,Nil},;
				{"C6_NFORI"	   ,_aprodpgm[x,1]      ,Nil},;
				{"C6_SERIORI"  ,_aprodpgm[x,2]      ,Nil},;
				{"C6_ITEMORI"  ,''                   ,Nil},;
				{"C6_IDENTB6"  ,_aprodpgm[x,4]      ,Nil},;
				{"C6_PRCCOMP"  , 0        			 ,Nil},;
				{"C6_LOCAL"	   ,_apgtomot[xpgt,3]    ,Nil},;
				{"C6_ENTREG"   ,dDataBase			 ,Nil},;
				{"C6_AEXPGVS"  ,_apgtomot[xpgt,7]   ,Nil}})
				// {"C6_LOCALIZ"  ,space(15)            ,Nil},;
				_apgtomot[xpgt,9] :=.T.
				_apgtomot[xpgt,10]:=cNrPV
				_apgtomot[xpgt,11]:=cItpvpg
			EndIf
		Next
	EndIf
Next
If Len(_aCabSC5) > 0  .AND. Len(_aIteSC6) > 0
	_lrpvpgt := u_geraPV(_aCabSC5,_aIteSC6, 3)  //Inclusao de novo PV
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se gerou erro no PV pela rotina padrao, forca a gravacao pelo RECLOCK.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !_lrpvpgt
	_lrpvpgt:=.T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Geracao dos Cabecalhos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SA1->(dbSeek(xFilial('SA1')+_aCabSC5[2,2]+_aCabSC5[3,2]))
	_cCFIni := "0"
	If Subs(SA1->A1_EST,1,2) == "EX"
		_cCFIni := "7"
	ElseIf Alltrim(GetMV("MV_ESTADO")) <> Alltrim(SA1->A1_EST)
		_cCFIni := "6"
	Else
		_cCFIni := "5"
	EndIf
	Begin Transaction
	RecLock('SC5',.T.)
	SC5->C5_FILIAL  := xFilial('SC5')
	SC5->C5_NUM     := cNrPV
	SC5->C5_TIPO    := _aCabSC5[ 1,2]
	SC5->C5_CLIENTE := _aCabSC5[ 3,2]
	SC5->C5_LOJACLI := _aCabSC5[ 4,2]
	SC5->C5_CLIENT  := _aCabSC5[ 3,2]
	SC5->C5_LOJAENT := _aCabSC5[ 5,2]
	SC5->C5_TIPOCLI := _aCabSC5[ 6,2]
	SC5->C5_CONDPAG := _aCabSC5[ 7,2]
	SC5->C5_EMISSAO := dDatabase
	SC5->C5_MOEDA   := 1
	SC5->C5_TIPLIB  := _aCabSC5[ 8,2]
	SC5->C5_TPCARGA := _aCabSC5[ 9,2]
	SC5->C5_TXMOEDA := 1
	SC5->C5_B_KIT   := _aCabSC5[ 10,2]
	SC5->C5_XUSER   := _aCabSC5[11,2]
	SC5->C5_TRANSP  := _aCabSC5[12,2]
	SC5->C5_MENPAD  := _aCabSC5[13,2]
	SC5->C5_DIVNEG  := _aCabSC5[14,2]
	SC5->C5_MENNOTA := _aCabSC5[15,2]
	MsUnLock('SC5')
	End Transaction
	//ConfirmSX8()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Geracao dos Itens.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For IX := 1 to Len(_aIteSC6)
		SB1->(dbSeek(xFilial('SB1')+_aIteSC6[IX,3,2]))
		SF4->(dbSeek(xFilial('SF4')+_aIteSC6[IX,5,2]))
		Begin Transaction
		RecLock('SC6',.T.)
		SC6->C6_FILIAL := xfilial("SC6")
		SC6->C6_NUM    := _aIteSC6[IX,2,2]
		SC6->C6_ITEM   := _aIteSC6[IX,1,2]
		SC6->C6_PRODUTO:= _aIteSC6[IX,3,2]
		SC6->C6_UM     := SB1->B1_UM
		SC6->C6_QTDVEN := _aIteSC6[IX,6,2]
		SC6->C6_PRCVEN := _aIteSC6[IX,10,2]
		SC6->C6_VALOR  := _aIteSC6[IX,11,2]
		SC6->C6_TES    := _aIteSC6[IX,5,2]
		SC6->C6_Local  := _aIteSC6[IX,18,2]
		// SC6->C6_LOCALIZ  := _aIteSC6[IX,20,2]
		SC6->C6_CF     := Alltrim(_cCFIni)+Subs(SF4->F4_CF,2,3)
		SC6->C6_ENTREG := dDataBase
		SC6->C6_DESCRI := SB1->B1_DESC
		SC6->C6_PRUNIT := _aIteSC6[IX,10,2]
		SC6->C6_NFORI  := _aIteSC6[IX,13,2]
		SC6->C6_SERIORI:= _aIteSC6[IX,14,2]
		SC6->C6_ITEMORI:= _aIteSC6[IX,15,2]
		SC6->C6_NUMSERI:= _aIteSC6[IX,8,2]
		SC6->C6_TPOP   := 'F' //FIRME
		SC6->C6_CLI    := _aCabSC5[ 3,2]
		SC6->C6_LOJA   := _aCabSC5[ 4,2]
		SC6->C6_IDENTB6:= _aIteSC6[IX,16,2]
		SC6->C6_PRCCOMP:= _aIteSC6[IX,17,2]
		SC6->C6_NUMOS  := _aIteSC6[IX,9,2]
		SC6->C6_AEXPGVS:= _aIteSC6[IX,20,2]
		MsUnLock('SC6')
		End Transaction
	Next IX
EndIf
Return(_lrpvpgt)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³salP3pgm  ºAutor  ³ Edson Rodrigues    º Data ³  13/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para filtrar os saldos disponiveis do produto de terº±±
±±º          | ceiro motorola para envio a Nextel                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function salP3pgm(_cprodpgm,_cclifor,_ccliloj,nsalpgm,carmzmot)
Local _aselpgm := {}
Local _nsapalp3 := 0
If Select("P3PGTM") > 0
	P3PGTM->(dbCloseArea())
EndIf
_cQryP3 := " SELECT B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT "
_cQryP3 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
_cQryP3 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
_cQryP3 += "        B6_PRODUTO = '"+_cprodpgm+"' AND "
_cQryP3 += "        B6_CLIFor  = '"+_cclifor+"' AND "
_cQryP3 += "        B6_LOJA    = '"+_ccliloj+"' AND "
_cQryP3 += "        B6_Local    = '"+carmzmot+"' AND "
_cQryP3 += "        B6_SALDO >= CAST('"+Alltrim(str(nsalpgm))+"' AS NUMERIC) AND "   //_cQryP3 += "        B6_SALDO  <> 0 AND "
_cQryP3 += "        B6.D_E_L_E_T_ = '' "
_cQryP3 += " ORDER BY B6_IDENT "
TCQUERY _cQryP3 NEW ALIAS "P3PGTM"
P3PGTM->(dbGoTop())
While P3PGTM->(!Eof()) .AND. nsalpgm > 0
	_nsapalp3 := SalDisP3(P3PGTM->B6_IDENT, P3PGTM->B6_SALDO)
	_nQtRet3 := Iif(_nsapalp3 >= nsalpgm, nsalpgm,_nsapalp3)
	If _nQtRet3 > 0
		_nsapalp3  := _nsapalp3 - _nQtRet3
		aAdd(_aselpgm,{P3PGTM->B6_DOC,P3PGTM->B6_SERIE,P3PGTM->B6_LOCAL,P3PGTM->B6_IDENT,_nQtRet3,P3PGTM->B6_PRUNIT})
	EndIf
	P3PGTM->(dbskip())
EndDo
Return(_aselpgm)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecax015  ºAutor  ³Microsiga           º Data ³  09/26/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calcular saldo disponivel de Terceiros.        º±±
±±º          ³ Desconta PV abertos do SB6->B6_SALDO                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SalDisP3(_cIdent, _nSalSB6)
Local _aAreaSC6  := SC6->(GetArea())
Local _nSalDisP3 := _nQtPV3:= 0
SC6->(dbSetOrder(12))  // C6_FILIAL + C6_IDENTB6
If SC6->(dbSeek(xFilial("SC6") + _cIdent ))
	While SC6->(!Eof()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_IDENTB6 == _cIdent
		_nQtPV3 += ( SC6->C6_QTDVEN - SC6->C6_QTDENT )
		SC6->(dbSkip())
	EndDo
EndIf
_nSalDisP3 := _nSalSB6 - _nQtPV3
restarea(_aAreaSC6)
Return(_nSalDisP3)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³salpvab   ºAutor  ³Microsiga           º Data ³  26/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar a quantidade de pedidos em aberto    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function salpvab(cprod,carmz)
Local nReturn :=0
Local cqrysc6 :=""
If Select("SC6AB") > 0
	SC6AB->(dbCloseArea())
EndIf
cqrysc6:= " SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTDABERT FROM "+RetSqlName("SC6")+" (nolock) "
cqrysc6+= " WHERE C6_FILIAL='"+XFILIAL("SC6")+"' AND C6_PRODUTO='"+cprod+"' AND C6_LOCAL='"+carmz+"' "
cqrysc6+= " AND (C6_QTDVEN-C6_QTDENT) > 0 AND D_E_L_E_T_='' "
TCQUERY cqrysc6 NEW ALIAS "SC6AB"
SC6AB->(dbGoTop())
While SC6AB->(!Eof()) .AND. SC6AB->QTDABERT > 0
	nReturn := SC6AB->QTDABERT
	SC6AB->(dbskip())
EndDo
Return(nReturn)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Confsai  ºAutor  ³Edson Rodrigues     º Data ³  24/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para consultar e selecionar Notas de Saídas         º±±
±±º          ³ conforme criterios passados por query                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Confsai(_nopc)
Local _lMark   		:= .T.
Local y        		:= 1
Local aArea    		:= GetArea()
Local _oDlg
Private _aHeader  	:= {}
Private _aItens   	:= {}
Private _aColumns 	:= {}
Private _lChk     	:= .F.
Private aCores    	:= {}
Private _oOk      	:= LoadBitmap(GetResources(), "LBOK")
Private _oNo      	:= LoadBitmap(GetResources(), "LBNO")
Private _oFont0   	:= TFont():New("Tahoma",, 16,,.F.,,,,,.F.)
nIten  := 0
QRY->(dbGoTop())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Grava dados no Array                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QRY")
dbGoTop()
While !Eof("QRY")
	If (Iif(_nopc==1,QRY->ZZ4_NFSTES='727',QRY->C6_TES='727'))
		nIten++
		If  _nopc==1
			aAdd(_aItens, {_lMark,;
			0,;
			QRY->ZZ4_CODCLI,;
			QRY->ZZ4_LOJA,;
			QRY->ZZ4_NFSNR,;
			QRY->ZZ4_NFSSER,;
			QRY->ZZ4_NFSDT;
			})
		Else
			aAdd(_aItens, {_lMark,;
			0,;
			QRY->ZZ4_CODCLI,;
			QRY->ZZ4_LOJA,;
			QRY->C6_NUM,;
			'',;
			QRY->C6_ENTREG;
			})
		EndIf
	EndIf
	dbSelectArea("QRY")
	dbSkip()
EndDo
CursorArrow()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Fecha Query                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Empty(_aItens)
	MsgAlert("Não foram encontrados dados para a consulta!", "Atenção")
	Return
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Estrutura do MarkBrowse                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _nopc=1
	aAdd(_aHeader , { "", "Seq", "Clie", "Loja","Doc", "Serie", "Emissao"})
	aAdd(_aColumns, { 4, 6, 6, 2, 9, 3, 8})
Else
	aAdd(_aHeader , { "", "Seq", "Clie", "Loja","Pedido",'', "Emissao"})
	aAdd(_aColumns, { 4, 6, 6, 2, 9, 3, 8})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Apresenta o MarkBrowse para o usuario                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_oDlg           := MSDialog():New(000, 000, 350, 500, "Seleção de NFs",,,,,,,, oMainWnd, .T.)
_oDlg:lCentered := .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha os GroupBoxes                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_oGrpo1 := TGroup():New(003, 003, 150, 250,, _oDlg,,, .T.)
_oGrpo2 := TGroup():New(151, 003, 170, 100,, _oDlg,,, .T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha os Botoes.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_oBtn2 := TButton():New(154, 150, 'Confirmar', _oDlg,{||  GravaItem(), _oDlg:End(),}  , 50, 15,,,,.T.)
_oBtn3 := TButton():New(154, 200, 'Sair'     , _oDlg,{|| _oDlg:End()}, 50, 15,,,,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informacoes do Rodape                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_oInf1 := TSay():New(157, 010, {|| "Itens Selecionados:" + Transform(nIten, "@E 999,999") }, _oDlg,, _oFont0,,,, .T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha o MarkBrowse.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBrw3 := TWBrowse():New(012, 010, 235, 135,, _aHeader[1], _aColumns[1], _oDlg,,,,,,,,,,,,,, .T.)
oBrw3:SetArray(_aItens)
oBrw3:bLine := {|| {;
Iif(_aItens[oBrw3:nAt][01], _oOk, _oNo),;
_aItens[oBrw3:nAt][02],;
_aItens[oBrw3:nAt][03],;
_aItens[oBrw3:nAt][04],;
_aItens[oBrw3:nAt][05],;
_aItens[oBrw3:nAt][06],;
_aItens[oBrw3:nAt][07]}}
oBrw3:lAdJustColSize := .T.
oBrw3:lColDrag       := .T.
oBrw3:lMChange       := .F.
oBrw3:lHScroll       := .F.
oBrw3:bLDblClick     := {|| _aItens[oBrw3:nAt,01] := !_aItens[oBrw3:nAt,01],;
Iif(_aItens[oBrw3:nAt,01], _aItens[oBrw3:nAt,02] := y, _aItens[oBrw3:nAt,02] := 0),;
Iif(_aItens[oBrw3:nAt,01], nIten := y , _aItens[oBrw3:nAt,02] := 0),;
_oInf1:Refresh(),;
Iif(_aItens[oBrw3:nAt,01], y++, y--)}
_oDlg:Activate(,,,.T.)
Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRAVAITEM º Autor ³Paulo Francisco     º Data ³  25/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ GRAVAR SELEÇÃO EM TABELAS                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GravaItem()
Local x
For x := 1 to Len(_aItens)
	If _aItens[x,01]
		aAdd(_aconfsa,{_aItens[x][03],_aItens[x][04],_aItens[x][05],_aItens[x][06]})
	EndIf
Next x
Return nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ filtzzp  ºAutor  ³Edson Rodrigues     º Data ³  10/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para filtrar valores na ZZP e assim fazer os        º±±
±±º          ³ calculos das pecas conforme regras de faturamento Nextel   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function filtzzp(newoper,cmodel,cgarant,_ccodestr,_nValTotPec,_nValPecas,nopcfat)
nopcfat:=Iif(nopcfat=nil,0,nopcfat)
_cQuery :=" SELECT ZZP_OPERA,ZZP_MODELO,ZZP_SRVGAF, ZZP_SRVFOG, ZZP_VLRFOG, ZZP_VLRGAF "
_cQuery +=" FROM "+RetSqlName("ZZP")+" "
_cQuery +=" WHERE ZZP_OPERA = '" + newoper  + "' "
_cQuery +=" AND ZZP_MODELO = '" +cmodel+ "' "
_cQuery +=" AND D_E_L_E_T_ <> '*' "
TCQUERY _cQuery NEW ALIAS "QRYZZP"
dbSelectArea("QRYZZP")
dbGoTop()
If  Empty(QRYZZP->ZZP_MODELO) .OR. Empty(QRYZZP->ZZP_OPERA)
	QRYZZP->(dbCloseArea())
	_cQuery :=" SELECT TOP 1 ZZP_SRVGAF, ZZP_SRVFOG, ZZP_VLRFOG, ZZP_VLRGAF "
	_cQuery +=" FROM "+RetSqlName("ZZP")+" "
	_cQuery +=" INNER JOIN
	_cQuery +=" (SELECT B1_COD,B1_XCODEST FROM "+RetSqlName("SB1")+" WHERE B1_XCODEST='"+_ccodestr+"' AND D_E_L_E_T_='' ) AS B1
	_cQuery +=" ON ZZP_MODELO=B1_COD
	_cQuery +=" WHERE ZZP_OPERA = '" + newoper  + "' "
	_cQuery +=" AND D_E_L_E_T_ <> '*'
	TCQUERY _cQuery NEW ALIAS "QRYZZP"
EndIf
If cgarant == "S"
	_nValPcVd	:= 	QRYZZP->ZZP_VLRGAF
	_nValSERV	:=	QRYZZP->ZZP_SRVGAF
Else
	_nValPcVd	:= 	QRYZZP->ZZP_VLRFOG
	_nValSERV	:=	QRYZZP->ZZP_SRVFOG
EndIf
QRYZZP->(dbCloseArea())
_nValTotPec := 0
If nopcfat=0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma a qtde x a diferença do valor de serviço das pecas referente ao armazem proprio.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nValPecas  :=_nqtdetot*(_nValPcVd - _nValSERV)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma a qtde x valor das pecas referente ao armazem proprio.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nValPecas  :=_nqtdetot*_nValPcVd
EndIf
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ buscust  ºAutor  ³Edson Rodrigues     º Data ³  10/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para buscar o custo do produto no sistema e definir º±±
±±º          ³ quantidades/% de peças a serem usadas nessa venda          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function buscust(_npcreduz,_cestado,carmproc,carmpc,ccuspec,_carmpgtm,_nqtde,_nqtdetot,_nValTotPec,cgrpoper,_ccodestr)
_canomes    := SUBSTR((DTOS(ddatabase)),1,4)+SUBSTR(DTOC(ddatabase),4,2)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona na linha de vendas de aparelho no mes total das operacões e atualiza com valores filtrados acima.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+"TODAS "+_ccodestr+'QT'))
	_nqtotapa   := ZAB->ZAB_QAPMES
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆ¿
//³For para pegar o custo do produto e somar x quantidade de aparelho para saber se passa o valor permitido de venda das pecas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆÙ
For xipcd:=1 to Len(_aitempc)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³busca custo conforme regra do laboratorio.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ccuspec == "CM"
		If SB2->(dbSeek(xFilial("SB2")+_aitempc[xipcd,3]+carmproc))
			ncusto:=SB2->B2_CM1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se existe algum percentual de redução sobre o custo - Edson Rodrigues - 13/02/2012.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _npcreduz > 0
				ncusto:=ncusto*_npcreduz
			EndIf
			If  ncusto <= 0
				ncusto:=u_verultcom(_aitempc[xipcd,3],ddatabase,carmproc)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se existe algum percentual de redução sobre o custo - Edson Rodrigues - 13/02/2012.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ncusto:=ncusto*0.7275
				If _npcreduz > 0
					ncusto:=ncusto*_npcreduz
				EndIf
			Else
				ncusto:=Iif(_cestado="SP",ncusto/0.7275,Iif(_cestado="RJ",ncusto/0.7875,ncusto))
			EndIf
		Else
			ncusto:=u_verultcom(_aitempc[xipcd,3],ddatabase,carmproc)
		EndIf
	ElseIf ccuspec =='UC'
		carmpc:=Iif(Empty(carmpc),'01',carmpc)
		ncusto:=verultcom(_aitempc[xipcd,3],ddatabase,carmproc)
	EndIf
	_aitempc[xipcd,7]:=ncusto
/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
	//³calculo da quantidade para regras anteriories - Preco variavel e preco fixo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	_nqtde :=Iif(_nqtdetot*_aitempc[xipcd,5] < 1,1,round(_nqtdetot*_aitempc[xipcd,5],0))
*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pega quantidade conforme controle na tabela ZAB                                                       ³
	//³FORMULA EXCEL :                                                                                       ³
	//³SE($P$2=0;                                                                                            ³
	//³	ARREDONDAR.PARA.BAIXO(H$1*G3;0);                                                                     ³
	//³	SE(N3="N";ARREDONDAR.PARA.BAIXO(H$1*G3;0);                                                           ³
	//³		SE(E(G3<=0,5;O3<=0);ARREDONDAR.PARA.BAIXO(((H$1+O3)*G3);0);ARREDONDAR.PARA.BAIXO(((H$1+O3)*G3);0)³
	//³		)                                                                                                ³
	//³	)                                                                                                    ³
	//³)                                                                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+cgrpoper+_ccodestr+'PC'+_aitempc[xipcd,3]))
		If ZAB->ZAB_QPEMES = 0.00 .OR. ZAB->ZAB_PECONT="N"
			_nqtde :=int(_nqtdetot*_aitempc[xipcd,5])
		ElseIf  ZAB->ZAB_QPEMES > 0.00 .AND. ZAB->ZAB_PECONT<> "N"
			_nqtde :=int(((_nqtotapa+_nqtdetot)*_aitempc[xipcd,5])-ZAB->ZAB_QPEMES)
		Else
			_nqtde :=0.00
		EndIf
	EndIf
	If _nqtde <=0
		//_aitempc[xipcd,5]:=_nqtde/_nqtdetot
		_aitempc[xipcd,7]:=0.00
	Else
		_aitempc[xipcd,11]:=_nqtde
	EndIf
	If  ncusto > 0
		_larmzpgt :=.F.
		If _aitempc[xipcd,8] == _carmpgtm
			If SB2->(dbSeek(xFilial('SB2')+_aitempc[xipcd,3]+_carmpgtm))
				nSalb2:=SaldoSB2(nil,nil,dDatabase,.T.,.T.,nil,0,0,.T.)
				nsalc6:=u_salpvab(_aitempc[xipcd,3],_carmpgtm)
				nSalb2:=nSalb2-nsalc6
				If  nSalb2 >= _nqtde
					_larmzpgt:=.T.
				EndIf
			EndIf
		EndIf
		If ! _larmzpgt
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Soma a qtde x o custo total das pecas referente ao armazem proprio.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_nValTotPec += _aitempc[xipcd,11]*_aitempc[xipcd,7]
		EndIf
	EndIf
Next xipcd
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Aplica pelo menos uma ou mais peca com percentual acima de 80% para poder gerar o pedido quando nao houver nenhuma peca a ser atendida.³
//³Edson Rodrigues - 30/08/13                                                                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _nValTotPec <= 0
	For xipcd:=1 to Len(_aitempc)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca custo conforme regra do laboratorio.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ccuspec =='CM'
			If SB2->(dbSeek(xFilial('SB2')+_aitempc[xipcd,3]+carmproc))
				ncusto:=SB2->B2_CM1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se existe algum percentual de redução sobre o custo - Edson Rodrigues - 13/02/2012.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If _npcreduz > 0
					ncusto:=ncusto*_npcreduz
				EndIf
				If  ncusto <= 0
					ncusto:=u_verultcom(_aitempc[xipcd,3],ddatabase,carmproc)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se existe algum percentual de redução sobre o custo - Edson Rodrigues - 13/02/2012.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ncusto:=ncusto*0.7275
					If _npcreduz > 0
						ncusto:=ncusto*_npcreduz
					EndIf
				Else
					ncusto:=Iif(_cestado="SP",ncusto/0.7275,Iif(_cestado="RJ",ncusto/0.7875,ncusto))
				EndIf
			Else
				ncusto:=u_verultcom(_aitempc[xipcd,3],ddatabase,carmproc)
			EndIf
		ElseIf ccuspec =='UC'
			carmpc:=Iif(Empty(carmpc),'01',carmpc)
			ncusto:=verultcom(_aitempc[xipcd,3],ddatabase,carmproc)
		EndIf
		_aitempc[xipcd,7]:=ncusto
		If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+cgrpoper+_ccodestr+'PC'+_aitempc[xipcd,3]))
			If ZAB->ZAB_QPEMES = 0.00 .OR. ZAB->ZAB_PECONT="N"
				_nqtde :=int(_nqtdetot*_aitempc[xipcd,5])
			ElseIf  ZAB->ZAB_QPEMES > 0.00 .AND. ZAB->ZAB_PECONT<> "N"
				If _aitempc[xipcd,5] < 0.8 .AND. ZAB->ZAB_QPROXV <=0.00
					_nqtde :=int(((_nqtotapa+_nqtdetot)*_aitempc[xipcd,5])-ZAB->ZAB_QPEMES)
				Else
					_nqtde :=(((_nqtotapa+_nqtdetot)*_aitempc[xipcd,5])-ZAB->ZAB_QPEMES) +1-(((_nqtotapa+_nqtdetot)*_aitempc[xipcd,5])-ZAB->ZAB_QPEMES)
				EndIf
			Else
				_nqtde :=0.00
			EndIf
		EndIf
		If _nqtde <=0
			//_aitempc[xipcd,5]:=_nqtde/_nqtdetot
			_aitempc[xipcd,7]:=0.00
		Else
			_aitempc[xipcd,11]:=_nqtde
		EndIf
		If  ncusto > 0
			_larmzpgt :=.F.
			If _aitempc[xipcd,8] == _carmpgtm
				If SB2->(dbSeek(xFilial('SB2')+_aitempc[xipcd,3]+_carmpgtm))
					nSalb2:=SaldoSB2(nil,nil,dDatabase,.T.,.T.,nil,0,0,.T.)
					nsalc6:=u_salpvab(_aitempc[xipcd,3],_carmpgtm)
					nSalb2:=nSalb2-nsalc6
					If  nSalb2 >= _nqtde
						_larmzpgt:=.T.
					EndIf
				EndIf
			EndIf
			If ! _larmzpgt
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Soma a qtde x o custo total das pecas referente ao armazem proprio.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_nValTotPec += _aitempc[xipcd,11]*_aitempc[xipcd,7]
			EndIf
		EndIf
	Next xipcd
EndIf
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ atulzab  ºAutor  ³Edson Rodrigues     º Data ³  10/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para atualizar a tabela de controle de venda mensal º±±
±±º          ³ onde grava quantidades já vendidas por peça/operação/Mes   s±±
±±º          ³ bem como sugere a proxima quantidade de pecas a ser vendida ±±
±±º          ³ por unidade equipamento.                                    ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function atulzab(_ccodestr)
_ddia       := "01"
_dmes       := SUBSTR(DTOC(ddatabase),4,2)
_dano       := SUBSTR(DTOC(ddatabase),7,4)
_cdtini     := _ddia+"/"+_dmes+"/"+_dano
_ddtini     := CTOD(_cdtini)
_canomes    := SUBSTR((DTOS(ddatabase)),1,4)+SUBSTR(DTOC(ddatabase),4,2)
_cgropcds   :="REFCDS"
_cgroploj   :="REFLOJ"
_nqtdvpec   := 0.00
_nqtotapa   := 0.00
_nqapacds   := 0.00
_nqapaloj   := 0.00
_nqpeccds   := 0.00
_nqpecloj   := 0.00
_agrppepc   := {}
_agr2peca   := {}
_agrupzzq   := {}
If Select("QRYAPAR") > 0
	QRYAPAR->(dbCloseArea())
EndIf
If Select("QRYPECA") > 0
	QRYPECA->(dbCloseArea())
EndIf
ZAB->(DBSetOrder(2)) //ZAB_FILIAL+ZAB_TPVAL+ZAB_ANOMES+ZAB_GROPER+ZAB_ESTRUT+ZAB_TIPOLI+ZAB_PARTNR
SC6->(DBSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a quantidade de aparelho vendidos no mës por estrutura/modelo e atualiza a tabela de controle ZAB.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cqryapar:= " SELECT ZZ4_OPEBGH,ZZ4_CODPRO,B1_XCODEST,COUNT(ZZ4_IMEI) AS QTD_AP_VEND "
cqryapar+= " FROM "+RetSqlName("ZZ4")+"  ZZ4 (NOLOCK) "
cqryapar+= " INNER JOIN ( SELECT B1_COD,B1_XCODEST    "
cqryapar+= "              FROM "+RetSqlName("SB1")+" (NOLOCK) WHERE B1_FILIAL='"+XFILIAL("SB1")+"' AND B1_XCODEST='"+_ccodestr+"' AND D_E_L_E_T_='') AS B1 "
cqryapar+= " ON ZZ4_CODPRO=B1_COD "
cqryapar+= " WHERE  ZZ4_DTPPEC>='"+dtos(_ddtini)+"' AND ZZ4_DTPPEC<='"+dtos(ddatabase)+"' AND ZZ4_PVPECA<>'' AND ZZ4_STATUS>='8' AND ZZ4.D_E_L_E_T_='' "
cqryapar+= " GROUP BY ZZ4_OPEBGH,ZZ4_CODPRO,B1_XCODEST
cqryapar+= " ORDER BY B1_XCODEST
TCQUERY cqryapar NEW ALIAS "QRYAPAR"
dbSelectArea("QRYAPAR")
dbGoTop()
While !Eof("QRYAPAR")
	_nqtotapa := _nqtotapa+QRYAPAR->QTD_AP_VEND
	If QRYAPAR->ZZ4_OPEBGH $ "N01/N10"
		_nqapacds :=  _nqapacds+QRYAPAR->QTD_AP_VEND
	ElseIf QRYAPAR->ZZ4_OPEBGH $ "N11"
		_nqapaloj :=  _nqapaloj+QRYAPAR->QTD_AP_VEND
	EndIf
	QRYAPAR->(DBSKIP())
EndDo
If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+_cgropcds+_ccodestr+'QO'))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na linha de vendas de aparelho no mes para as operacões CDs e atualiza com valores filtrados acima.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock('ZAB',.F.)
	ZAB->ZAB_QAPMES := _nqapacds
	MsUnLock('ZAB')
EndIf
If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+_cgroploj+_ccodestr+'QO'))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na linha de vendas de aparelho no mes para as operacões lojas e atualiza com valores filtrados acima.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock('ZAB',.F.)
	ZAB->ZAB_QAPMES := _nqapaloj
	MsUnLock('ZAB')
EndIf
If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+"TODAS "+_ccodestr+'QT'))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na linha de vendas de aparelho no mes total das operacões e atualiza com valores filtrados acima.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock('ZAB',.F.)
	ZAB->ZAB_QAPMES := _nqtotapa
	MsUnLock('ZAB')
EndIf
/*
cqrypeca:= " SELECT ZZ4_OPEBGH,C6_PRODUTO,SUM(C6_QTDVEN) AS QTD_PECA "
cqrypeca+= " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK) "
cqrypeca+= " INNER JOIN      "
cqrypeca+= "      (SELECT ZZ4_OPEBGH,ZZ4_PVPECA "
cqrypeca+= "              FROM "+RetSqlName("ZZ4")+" ZZ4 (NOLOCK) "
cqrypeca+= "                     INNER JOIN ( SELECT B1_COD,B1_XCODEST "
cqrypeca+= "                                  FROM "+RetSqlName("SB1")+" (NOLOCK) "
cqrypeca+= "                                  WHERE D_E_L_E_T_='' AND B1_XCODEST='"+_ccodestr+"' ) AS B1 "
cqrypeca+= "                     ON ZZ4_CODPRO=B1_COD "
cqrypeca+= "       WHERE ZZ4_STATUS>='8' AND ZZ4.D_E_L_E_T_='' "
cqrypeca+= "       AND ZZ4_PVPECA<>'' AND ZZ4_DTPPEC>='"+dtos(_ddtini)+"' AND ZZ4_DTPPEC<='"+dtos(ddatabase)+"' "
cqrypeca+= "        GROUP BY ZZ4_OPEBGH,ZZ4_PVPECA
cqrypeca+= "      ) AS QTDPV
cqrypeca+= " ON C6_NUM=ZZ4_PVPECA
cqrypeca+= " WHERE D_E_L_E_T_=''
cqrypeca+= " GROUP BY ZZ4_OPEBGH,C6_PRODUTO
cqrypeca+= " ORDER BY C6_PRODUTO
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŒ¿
//³Verifica a quantidade de pecas vendidas no mës por estrutura/modelo e atualiza a tabela de controle ZAB.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŒÙ
cqrypeca:= " SELECT ZZQ_FILIAL,ZZ4_OPEBGH,ZZQ_PV,ZZQ_ITEMPV,ZZQ_PECA,SUM(ZZQ_QTDE ) AS QTD_PECA "
cqrypeca+= " FROM "+RetSqlName("ZZQ")+" AS ZZQ "
cqrypeca+= " INNER JOIN (SELECT ZZ4_FILIAL,ZZ4_OPEBGH,ZZ4_OS  "
cqrypeca+= "             FROM "+RetSqlName("ZZ4")
cqrypeca+= "                     INNER JOIN ( SELECT B1_COD,B1_XCODEST "
cqrypeca+= "                                  FROM "+RetSqlName("SB1")+" (NOLOCK) "
cqrypeca+= "                                  WHERE B1_FILIAL='"+XFILIAL("SB1")+"' AND B1_XCODEST='"+_ccodestr+"' AND D_E_L_E_T_='' "
cqrypeca+= "                                ) AS B1 "
cqrypeca+= "                     ON ZZ4_CODPRO=B1_COD "
cqrypeca+= " WHERE  ZZ4_DTPPEC>='"+dtos(_ddtini)+"' AND ZZ4_DTPPEC<='"+dtos(ddatabase)+"'  AND ZZ4_PVPECA<>'' AND ZZ4_STATUS>='8' AND D_E_L_E_T_='' "
cqrypeca+= "             ) AS ZZ4 "
cqrypeca+= " ON ZZQ_FILIAL=ZZ4_FILIAL AND ZZQ_NUMOS=ZZ4_OS  "
cqrypeca+= " WHERE D_E_L_E_T_=''  "
cqrypeca+= " GROUP BY ZZQ_FILIAL,ZZ4_OPEBGH,ZZQ_PV,ZZQ_ITEMPV,ZZQ_PECA "
cqrypeca+= " ORDER BY ZZQ_FILIAL,ZZQ_PECA,ZZQ_PV,ZZQ_ITEMPV,ZZ4_OPEBGH "
TCQUERY cqrypeca NEW ALIAS "QRYPECA"
dbSelectArea("QRYPECA")
dbGoTop()
While !Eof("QRYPECA")
	_nPosgrzzq := Ascan(_agrupzzq ,{ |xq| xq[1] == QRYPECA->ZZQ_FILIAL+Alltrim(QRYPECA->ZZQ_PECA)+QRYPECA->ZZQ_PV+QRYPECA->ZZQ_ITEMPV})
	If _nPosgrzzq > 0
		_agrupzzq[_nPosgrzzq,2]+=QRYPECA->QTD_PECA
	Else
		aAdd(_agrupzzq,{QRYPECA->ZZQ_FILIAL+Alltrim(QRYPECA->ZZQ_PECA)+QRYPECA->ZZQ_PV+QRYPECA->ZZQ_ITEMPV,QRYPECA->QTD_PECA})
	EndIf
	QRYPECA->(DBSKIP())
EndDo
dbSelectArea("QRYPECA")
dbGoTop()
While !Eof("QRYPECA")
	If SC6->(dbSeek(QRYPECA->ZZQ_FILIAL+QRYPECA->ZZQ_PV+QRYPECA->ZZQ_ITEMPV+QRYPECA->ZZQ_PECA))
		_nPosgrzzq := Ascan(_agrupzzq ,{ |yq| yq[1] == QRYPECA->ZZQ_FILIAL+Alltrim(QRYPECA->ZZQ_PECA)+QRYPECA->ZZQ_PV+QRYPECA->ZZQ_ITEMPV})
		If _nPosgrzzq > 0
			_nqtdtzzq:=_agrupzzq[_nPosgrzzq,2]
			_nperczzq:=QRYPECA->QTD_PECA/_nqtdtzzq
		Else
			_nqtdtzzq :=0.00
			_nperczzq := 1
		EndIf
		_nqvenpec  := _nperczzq*SC6->C6_QTDVEN
		If QRYPECA->ZZ4_OPEBGH $ "N01/N10"
			_nqtdvpec  :=_nqtdvpec+_nqvenpec
			_nPosgropc := Ascan(_agrppepc ,{ |xy| xy[1] == _canomes+_cgropcds+_ccodestr+'PC'+SC6->C6_PRODUTO })
			If _nPosgropc > 0
				_agrppepc[_nPosgropc,2]+=_nqvenpec
			Else
				aAdd(_agrppepc,{_canomes+_cgropcds+_ccodestr+'PC'+SC6->C6_PRODUTO,_nqvenpec ,_canomes,_cgropcds,_ccodestr,'PC',SC6->C6_PRODUTO})
			EndIf
		Else
			_nqtdvpec  :=_nqtdvpec+_nqvenpec
			_nPosgropc := Ascan(_agrppepc ,{ |xv| xv[1] == _canomes+_cgroploj+_ccodestr+'PC'+SC6->C6_PRODUTO })
			If _nPosgropc > 0
				_agrppepc[_nPosgropc,2]+=_nqvenpec
			Else
				aAdd(_agrppepc,{_canomes+_cgroploj+_ccodestr+'PC'+SC6->C6_PRODUTO,_nqvenpec,_canomes,_cgroploj,_ccodestr,'PC',SC6->C6_PRODUTO})
			EndIf
		EndIf
	EndIf
	QRYPECA->(DBSKIP())
EndDo
If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+"TODAS "+_ccodestr+'QT'))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlsˆ¿
	//³Posiciona na linha de vendas de aparelho no mes total das operacões e atualiza com valores total de pecas vendidas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlsˆÙ
	RecLock('ZAB',.F.)
	ZAB->ZAB_QPEMES := _nqtdvpec
	MsUnLock('ZAB')
EndIf
If Len(_agrppepc) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava quantidade Total vendida de peca por operacao e somas no array todas operacoes.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For t:=1 to Len(_agrppepc)
		If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_agrppepc[t,3]+_agrppepc[t,4]+_agrppepc[t,5]+_agrppepc[t,6]+_agrppepc[t,7]))
			RecLock('ZAB',.F.)
			ZAB->ZAB_QPEOPE :=_agrppepc[t,2]
			MsUnLock('ZAB')
			If _agrppepc[t,4]="REFCDS"
				_nqpeccds := _nqpeccds+_agrppepc[t,2]
			Else
				_nqpecloj := _nqpecloj+_agrppepc[t,2]
			EndIf
			_nPosgr2pe := Ascan(_agr2peca ,{ |xt| xt[1] == Alltrim(_agrppepc[t,3])+Alltrim(_agrppepc[t,5])+Alltrim(_agrppepc[t,6])+Alltrim(_agrppepc[t,7]) })
			If _nPosgr2pe > 0
				_agr2peca[_nPosgr2pe,2]+=_agrppepc[t,2]
			Else
				aAdd(_agr2peca,{Alltrim(_agrppepc[t,3])+Alltrim(_agrppepc[t,5])+Alltrim(_agrppepc[t,6])+Alltrim(_agrppepc[t,7]),_agrppepc[t,2],_agrppepc[t,3],_agrppepc[t,5],_agrppepc[t,6],_agrppepc[t,7]})
			EndIf
		EndIf
	Next
EndIf
If Len(_agr2peca) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava quantidade Total de peças vendida por peca no mes de todas as operacoes.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For xw:=1 to Len(_agr2peca)
		If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_agr2peca[xw,3]+_cgropcds+_agr2peca[xw,4]+_agr2peca[xw,5]+_agr2peca[xw,6]))
			RecLock('ZAB',.F.)
			ZAB->ZAB_QPEMES := _agr2peca[xw,2]
			MsUnLock('ZAB')
		EndIf
		If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_agr2peca[xw,3]+_cgroploj+_agr2peca[xw,4]+_agr2peca[xw,5]+_agr2peca[xw,6]))
			RecLock('ZAB',.F.)
			ZAB->ZAB_QPEMES := _agr2peca[xw,2]
			MsUnLock('ZAB')
		EndIf
	next
EndIf
If Len(_agrppepc) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava quantidade possivel a vender por unidade de cada aparelho.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For yx:=1 to Len(_agrppepc)
		If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_agrppepc[yx,3]+_agrppepc[yx,4]+_agrppepc[yx,5]+_agrppepc[yx,6]+_agrppepc[yx,7]))
			If ZAB->ZAB_PECONT="N"
				RecLock('ZAB',.F.)
				ZAB->ZAB_QPROXV := 0.00
				MsUnLock('ZAB')
			Else
				nproxven:=INT(((_nqtotapa+1)*ZAB->ZAB_PERCEN)-ZAB->ZAB_QPEMES)
				RecLock('ZAB',.F.)
				ZAB->ZAB_QPROXV :=Iif(nproxven<0,0,nproxven)
				MsUnLock('ZAB')
			EndIf
		EndIf
	Next
EndIf
If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+_cgropcds+_ccodestr+'QO'))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄœ¿
	//³Posiciona na linha de vendas de aparelho no mes para as operacões CDs e atualiza com valores referente a quantidade total de pecas por operacao.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄœÙ
	RecLock('ZAB',.F.)
	ZAB->ZAB_QPEMES := _nqpeccds
	MsUnLock('ZAB')
EndIf
If ZAB->(dbSeek(xFilial('ZAB')+'PV'+_canomes+_cgroploj+_ccodestr+'QO'))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na linha de vendas de aparelho no mes para as operacões lojas e atualiza com valores referente a quantidade total de pecas por operacao.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock('ZAB',.F.)
	ZAB->ZAB_QPEMES := _nqpecloj
	MsUnLock('ZAB')
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Filpecnew ºAutor  ³Edson Rodrigues     º Data ³  19/02/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para filtrar peças baseado no novo processo         º±±
±±º            de apontamento de peças                                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Filpecnew(_codestr,_cCodPro)
Local  newcodp :=space(15)
Local _coper   := ""
_aitpecas   := {}
_abaiscrd   := {}
_abaixret   := {}
If Len(_agrpitm) > 0
	For srv:=1  to Len(_agrpitm)
		If  (newcodp  <> _agrpitm[srv,2])
			newcodp   := _agrpitm[srv,2]
			_cTes     := "704"
			_citLocal := _agrpitm[srv,17]
			_nqtdetot := 0
			_nqtdemod := 0
			_ccodestr :=""
			_aitpecas :={}
			_aitpcret :={}
			_aitempc  :={}
			lpass     :=.F.
			newoper   := _agrpitm[srv,20]
			carmproc  :="1P"  // Posicione("ZZJ",1,xFilial("ZZJ") + newoper, "ZZJ_ARMESF")
			carmprre  :="RE"
			ctmscrap  :="502"
			ctmsretr  :="508"
			cendfat   :="FATURAR"
			ctabela   :="NEX"
			cgrpoper  :=Iif(newoper $ "N01/N10","REFCDS","REFLOJ")
			ccuspec    :=Posicione("ZZJ",1,xFilial("ZZJ") + newoper, "ZZJ_CUSPEC")
			_cestado   :=Posicione("SA1",1,xFilial("SA1") + _aCabSC5[3,2]+_aCabSC5[4,2], "A1_EST")
			SB1->(dbSeek(xFilial('SB1')+newcodp))
			SF4->(dbSeek(xFilial('SF4')+_cTes))
			SA1->(dbSeek(xFilial('SA1')+_aCabSC5[3,2]+_aCabSC5[4,2]))
			ZAB->(DBSetOrder(2)) //ZAB_FILIAL+ZAB_TPVAL+ZAB_ANOMES+ZAB_GROPER+ZAB_ESTRUT+ZAB_TIPOLI+ZAB_PARTNR
			_cestado   :=Posicione("SA1",1,xFilial("SA1") + _aCabSC5[3,2]+_aCabSC5[4,2], "A1_EST")
			_ccodestr:=SB1->B1_XCODEST
			For xmds:= 1    to  Len(_agrpitm)
				If newcodp==_agrpitm[xmds,2]
					_nqtdemod++
				EndIf
				If newoper==_agrpitm[xmds,20] .AND.  newcodp==_agrpitm[xmds,2]  .AND. !_agrpitm[xmds,24]
					_nqtdetot++
					lpass :=.T.
					_agrpitm[xmds,24]:=.T.
					If  !newoper $ _coper
						If Empty(_coper)
							_coper:=newoper
						Else
							_coper:=_coper+"/"+newoper
						EndIf
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Filtra peças apontadas por OS.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//   aAdd(_agrpitm,{cItens,_cnewprod,SB1->B1_DESC,Iif(nopcao==1,_cTesser,_ctespec),_nqtde,_nqtde,'','',_nPrcVen,_nqtde*_nPrcVen,0,'','','','',0,_citlocal,ddatabase,'',_agerapv[ix,15],_agerapv[ix,16],_agerapv[ix,23],_agerapv[ix,24]})
					//   _agpvpec,{_cimei,_cos,_clocal,_cprod,_cnfe,_cserie,_ccli,_cloj,_nqtde,_nvunit,_cstazz4,_codlab,_cpv,_carcac,_copebgh,_nreczz4,_cdivneg,_citem,_ddtnfe,_cnfsnr,_cnfsser,_cnfsdt,_cgarmcl,_ctransc,.F.})
					U_filpcnov(newcodp,@cItens,_agrpitm[xmds,21],carmproc,carmprre,cendfat,ctmscrap,ctabela,ccuspec)
					aAdd(_afilser,{_agrpitm[xmds,1],_agrpitm[xmds,2],_agrpitm[xmds,3],_agrpitm[xmds,4],_agrpitm[xmds,5],_agrpitm[xmds,6],_agrpitm[xmds,7],_agrpitm[xmds,8],_agrpitm[xmds,9],;
					_agrpitm[xmds,10],_agrpitm[xmds,11],_agrpitm[xmds,12],_agrpitm[xmds,13],_agrpitm[xmds,14],_agrpitm[xmds,15],_agrpitm[xmds,16],_agrpitm[xmds,17],_agrpitm[xmds,18],;
					_agrpitm[xmds,19],_agrpitm[xmds,20],_agrpitm[xmds,21],_agrpitm[xmds,22],_agrpitm[xmds,23],.T.,"OK",_agrpitm[xmds,26],cItens,;
					_aitempc,_agrpitm[xmds,29],_agrpitm[xmds,30],_agrpitm[xmds,31]})
				Else
					If newoper==_agrpitm[xmds,20] .AND. newcodp==_agrpitm[xmds,2] .AND. !_agrpitm[xmds,24]
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Tratamento para erros.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_nPosimei := Ascan(_afilser ,{ |a| a[29] == _agrpitm[xmds,29]})
						_nPosOS   := Ascan(_afilser ,{ |b| b[30] == _agrpitm[xmds,30] })
						If _nPosimei <= 0 .AND. _nPosOS <= 0 .AND. newoper==_agrpitm[xmds,20] .AND.  newcodp==_agrpitm[xmds,2]
							aAdd(_afilser,{_agrpitm[xmds,1],_agrpitm[xmds,2],_agrpitm[xmds,3],_agrpitm[xmds,4],_agrpitm[xmds,5],_agrpitm[xmds,6],_agrpitm[xmds,7],_agrpitm[xmds,8],_agrpitm[xmds,9],;
							_agrpitm[xmds,10],_agrpitm[xmds,11],_agrpitm[xmds,12],_agrpitm[xmds,13],_agrpitm[xmds,14],_agrpitm[xmds,15],_agrpitm[xmds,16],_agrpitm[xmds,17],_agrpitm[xmds,18],;
							_agrpitm[xmds,19],_agrpitm[xmds,20],_agrpitm[xmds,21],_agrpitm[xmds,22],_agrpitm[xmds,23],.F.,;
							"Operacao : "+_agrpitm[xmds,20]+" e ou produto :"+Alltrim(_agrpitm[xmds,2])+" nao adicionado para geração do pedido",;
							_agrpitm[xmds,26],@cItens,_agrpitm[xmds,28],_agrpitm[xmds,29],_agrpitm[xmds,30],;
							"Analisar - Contate o Administrador"})
						EndIf
					EndIf
				EndIf
			Next xmds
			If SF4->F4_ESTOQUE = "S" .AND. lpass
				u_filtzzp(newoper,_agrpitm[srv,2],_agrpitm[srv,22],_ccodestr,@_nValTotPec,@_nValPecas,1)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Filtra valores de servicoes e pecas na tabela ZZP.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(_aitpecas) > 0 .AND. _nValPecas > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Orderna por peça.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aSort(_aitpecas,,,{|x,y| x[3] < y[3]})
					//          1    2         3          4        5      6     7       8        9        10        11       12       13     14    15
					//_aitpecas{cos,ccodmod,_ccompon,_cproddesc,_nqtde,citens,ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,recsz9,cimei,percipi}
					For xnv:=1 to Len(_aitpecas)
						_nPospeca := Ascan(_aitempc ,{ |p| p[12]+p[3] == _aitpecas[xnv,12]+_aitpecas[xnv,3]})
						If _nPospeca <= 0
							cItens     := Soma1(cItens,2)
							aAdd(_aitempc,{_aitpecas[xnv,1],_aitpecas[xnv,2],_aitpecas[xnv,3],_aitpecas[xnv,4],_aitpecas[xnv,5],cItens,;
							_aitpecas[xnv,7],_aitpecas[xnv,8],_aitpecas[xnv,9],_aitpecas[xnv,10],_aitpecas[xnv,11],_aitpecas[xnv,12]})
							_aitpecas[xnv,6]:=cItens
						Else
							_aitempc[_nPospeca,5]:=_aitempc[_nPospeca,5]+_aitpecas[xnv,5]
							//_aitpecas[xnv,6]:=cItens
						EndIf
						If  _aitpecas[xnv,12] == "N"
							_nValTotPec+=(_aitpecas[xnv,7]*_aitpecas[xnv,5])
						EndIf
					Next
				EndIf
/*
				_nDiferenca	:= _nValPecas - _nValTotPec
				_nPercDif	:= _nValPecas / _nValTotPec * 100 - 100
				_nrestante  := _nDiferenca
*/
				If Len(_aitempc) >  0
					For xipcd:=1 to Len(_aitempc)
						_larmzpgt  := .F.
						_nqtde     := 0.00
						_nquant    := 0.00
						_nquatu    := 0.00
						_nqtdecalc := 0.00
						_nvaldesc  := 0.00
						_ctm       := Space(3)
						If  _aitempc[xipcd,7] > 0  .AND. _aitempc[xipcd,12] == "N"
							_nqtde:=_aitempc[xipcd,5]
							// _nPercPeca	:= ((_nqtde*_aitempc[xipcd,7]) / _nValTotPec) * 100
							SB1->(dbSeek(xFilial('SB1')+_aitempc[xipcd,3]))
							_npercipi := SB1->B1_IPI
							If  _npercipi > 0
								_cTes:="704"
							Else
								_cTes:="787"
							EndIf
							// _npercipi := 1 + ( _npercipi / 100 )
/*
							If _nDiferenca > 0
								//  lançar acréscimos no ítem  - aplicar somente o percentual de IPI
								// Comentado abaixo para nao aplicar o percentual de desconto no IPI - Edson Rodrigues - 23/09/2014
								// _aitempc[xipcd,7] := _aitempc[xipcd,7] / _npercipi
							Else
								// lançar descontos no ítem
								// Comentado abaixo para nao aplicar o percentual de desconto no IPI - Edson Rodrigues - 23/09/2014
								// _aitempc[xipcd,7] := _aitempc[xipcd,7] / _npercipi
								_nvaldesc:= 0 // (abs(_nDiferenca)  * abs(_nPercPeca) / 100)
								_nrestante := _nrestante - (abs(_nDiferenca)  * abs(_nPercPeca) / 100)
							EndIf
*/
							If (_nqtde * round(_aitempc[xipcd,7],5)) < 0.01
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica se o valor Total e menor que 0,01, caso positivo altera o custo para esse valor.³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								_nvlrunit :=  0.01*_nqtde
								_aitempc[xipcd,7]:=_nvlrunit
							EndIf
							//          1    2         3          4        5      6     7       8        9        10        11       12        13     14
							//_aitpecas{cos,ccodmod,_ccompon,_cproddesc,_nqtde,citens,ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,nrecsz9,cimei}
							aAdd(_aIteSC6,{{"C6_ITEM"	,_aitempc[xipcd,6]           ,Nil},;
							{"C6_NUM"	            ,_agrpitm[srv,26]            ,Nil},;
							{"C6_PRODUTO"	        ,_aitempc[xipcd,3]           ,Nil},;
							{"C6_DESCRI"	        ,_aitempc[xipcd,4]           ,Nil},;
							{"C6_TES"		        ,_cTes				         ,Nil},;
							{"C6_QTDVEN"	        ,_nqtde                      ,Nil},;
							{"C6_QTDLIB"	        ,_nqtde                      ,Nil},;
							{"C6_NUMSERI"	        ,''                          ,Nil},;
							{"C6_NUMOS"		    ,''     			         ,Nil},;
							{"C6_PRCVEN"	        ,round(_aitempc[xipcd,7],5) ,Nil},;
							{"C6_VALOR"		    ,_nqtde*round(_aitempc[xipcd,7],5), Nil},;
							{"C6_PRUNIT"	        ,0					         ,Nil},;
							{"C6_VALDESC"	        ,_nvaldesc                 	 ,Nil},;
							{"C6_NFORI"		    ,''                          ,Nil},;
							{"C6_SERIORI"	        ,''                          ,Nil},;
							{"C6_ITEMORI"	        ,''                          ,Nil},;
							{"C6_IDENTB6"	        ,'' 			             ,Nil},;
							{"C6_PRCCOMP"	        , 0        			         ,Nil},;
							{"C6_LOCAL"		    ,_aitempc[xipcd,8]           ,Nil},;
							{"C6_LOCALIZ"		    ,_aitempc[xipcd,10]          ,Nil},;
							{"C6_ENTREG"	        ,dDataBase			         ,Nil},;
							{"C6_AEXPGVS"	        ,'Op: '+_coper+' md: '+Alltrim(newcodp),Nil}})
						ElseIf _aitempc[xipcd,12] <> "N"
							//          1    2         3          4        5      6     7       8        9        10        11       12        13     14
							//_aitpecas{cos,ccodmod,_ccompon,_cproddesc,_nqtde,citens,ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,nrecsz9,cimei}
							//  ATUSD3(_cTm,_cProdD3,_cLocal,_nQuant,_cLocaliz,_cDoc)
							If  _aitempc[xipcd,12] == "R"
								_ctm:=ctmsretr
								aAdd(_abaixret,{_ctm,_aitempc[xipcd,3],_aitempc[xipcd,9],_aitempc[xipcd,5],_aitempc[xipcd,10],'S',0})
							ElseIf _aitempc[xipcd,12] == "S" .OR. _aitempc[xipcd,12] == "D"
								_ctm:=_aitempc[xipcd,11]
								aAdd(_abaiscrd,{_ctm,_aitempc[xipcd,3],_aitempc[xipcd,8],_aitempc[xipcd,5],_aitempc[xipcd,10],'S',0})
							EndIf
						EndIf
					Next xipcd
				EndIf
			Else
				_nPosimei := Ascan(_afilser ,{ |x| x[29] == _agrpitm[srv,29]})
				_nPosOS   := Ascan(_afilser ,{ |x| x[30] == _agrpitm[srv,30] })
				If _nPosimei <= 0 .AND. _nPosOS <= 0
					If  SF4->F4_ESTOQUE<>'S'
						_cproblem:="TES : "+_cTes+" não movimenta estoque - Não permitido"
					Else
						_cproblem:="Problema no processamento - Nao adicionado no array "
					EndIf
					aAdd(_afilser,{_agrpitm[srv,1],_agrpitm[srv,2],_agrpitm[srv,3],_agrpitm[srv,4],_agrpitm[srv,5],_agrpitm[srv,6],_agrpitm[srv,7],_agrpitm[srv,8],_agrpitm[srv,9],;
					_agrpitm[srv,10],_agrpitm[srv,11],_agrpitm[srv,12],_agrpitm[srv,13],_agrpitm[srv,14],_agrpitm[srv,15],_agrpitm[srv,16],_agrpitm[srv,17],_agrpitm[srv,18],;
					_agrpitm[srv,19],_agrpitm[srv,20],_agrpitm[srv,21],_agrpitm[srv,22],_agrpitm[srv,23],.F.,_cproblem,;
					_agrpitm[srv,26],@cItens,_agrpitm[srv,28],_agrpitm[srv,29],_agrpitm[srv,30],_csolucao})
				EndIf
			EndIf
		EndIf
	Next srv
EndIf
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Filpcnov ºAutor  ³Edson Rodrigues     º Data ³  15/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para selecionar as peças apontadas no novo          º±±
±±º          ³ processo de apontamento                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function filpcnov(ccodmod,cItens,nreczz4,_carmazp,_carmare,_cendfat,_cTMscrap,_CTAB,ccuspec)
Local _cnovaret :=space(1)
Local _ddatanew :=CTOD(" / / ")
Local cimei     := space(TamSX3("ZZ4_IMEI")[1])//space(15)
Local cos       := space(6)
Local _npreco   := 0.00
Local ncusto    := 0.00
Local nCMed		:= 0.00
If !Empty(ccodmod)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se For um pedido de kit, gravar demais produtos que constam na estrutura desse item.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
	ZZ4->(dbgoto(nreczz4))
	cimei     := ZZ4->ZZ4_IMEI
	cos       := Alltrim(ZZ4->ZZ4_OS)
	_cpartold := ""
	dbSelectArea("SZ9")
	If SZ9->(dbSeek(xFilial("SZ9") + cimei + left(cos,6)))
		While SZ9->(!Eof()) .AND. (SZ9->Z9_FILIAL == xFilial("SZ9")) .AND. (SZ9->Z9_IMEI == cimei) .AND. (LEFT(SZ9->Z9_NUMOS,6) == left(cos,6))
			If SZ9->Z9_STATUS=='1'  .AND. !Empty(SZ9->Z9_PARTNR) .AND. SZ9->Z9_SYSORIG $ "1/2"
				_cyesret   := Posicione("SB1",1,xFilial("SB1")+LEFT(SZ9->Z9_PARTNR,15), "B1_RETRABA")
				_npercipi := Posicione("SB1",1,xFilial("SB1")+LEFT(SZ9->Z9_PARTNR,15), "B1_IPI")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Incluso IPI para contemplar o valor total da nota com IPI - Edson Rodrigues - 23/09/14.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_npercipi := 1 + ( _npercipi / 100 )
				_lscrap    := conscrap(cos,cimei)
				_ccompon   := SZ9->Z9_PARTNR
				_cproddesc := SB1->B1_DESC
				_nqtde     := SZ9->Z9_QTY
				_npreco    := 0.00
				_nrecsz9   := SZ9->(RECNO())
				If ccuspec == "CM"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Busca custo conforme regra do laboratorio.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SB2->(dbSeek(xFilial('SB2')+_ccompon+_carmazp))
						ncusto:=SB2->B2_CM1
						If  ncusto <= 0
							ncusto:=u_verultcom(_ccompon,ddatabase,_carmazp)
						EndIf
					EndIf
					If  ncusto <= 0
						ncusto:=u_verultcom(_ccompon,DDATABASE,_carmazp)
					EndIf
				ElseIf ccuspec == "UC"
					ncusto:=u_verultcom(_ccompon,ddatabase,_carmazp)
				EndIf
				If GetMV("MV_XTABPEC") == "C"
					nCMed := CustMed(_ccompon,_carmazp,DDATABASE)
					_npreco := CalcImp(_ccompon,nCMed,ZZ4->ZZ4_CODCLI,ZZ4->ZZ4_LOJA,SF4->F4_CODIGO,SF4->F4_CF)
				ElseIf GetMV("MV_XTABPEC") == "T" .AND. DA1->(dbSeek(xFilial("DA1") + _CTAB+LEFT(SZ9->Z9_PARTNR,15)))
					_npreco := DA1->DA1_PRCVEN
				ElseIf GetMV("MV_XTABPEC") == "X"
					_cestado   :=Posicione("SA1",1,xFilial("SA1") + ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA, "A1_EST")
					_npreco:=Iif(_cestado="SP",ncusto/0.7275,Iif(_cestado="RJ",ncusto/0.7875,ncusto))
				EndIf
				If  _cyesret <> "S"  .AND. !_lscrap
					If !Alltrim(SZ9->Z9_PARTNR) $ Alltrim(_cpartold)
						nposprtn :=  Ascan(_aitpecas, { |X| X[1]+X[3] = SZ9->Z9_NUMOS+SZ9->Z9_PARTNR } )
						If nposprtn > 0   .AND. Empty(SZ9->Z9_NUMSEQD)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Peça apontada em duplicidade.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							_cnovaret := "D"
							aAdd(_aitpecas,{cos,ccodmod,_ccompon,_cproddesc,_nqtde,"0",ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,_nrecsz9,cimei,_npercipi})
						ElseIf  Empty(SZ9->Z9_PEDPECA)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Peça apontada Nova.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							_cnovaret := "N"
							aAdd(_aitpecas,{cos,ccodmod,_ccompon,_cproddesc,_nqtde,cItens,_npreco,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,_nrecsz9,cimei,_npercipi})
						EndIf
					ElseIf  Empty(SZ9->Z9_NUMSEQD)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Peça apontada em duplicidade.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_cnovaret := "D"
						aAdd(_aitpecas,{cos,ccodmod,_ccompon,_cproddesc,_nqtde,"0",ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,_nrecsz9,cimei,_npercipi})
					EndIf
					_cpartold := _cpartold+"/"+Alltrim(SZ9->Z9_PARTNR)
				Else
					If _cyesret = "S"  .AND. Empty(SZ9->Z9_NUMSEQR)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Peça apontada retrabalhada.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_cnovaret := "R"
						aAdd(_aitpecas,{cos,ccodmod,_ccompon,_cproddesc,_nqtde,"0",ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,_nrecsz9,cimei,_npercipi,})
					ElseIf  _lscrap .AND. Empty(SZ9->Z9_NUMSEQS)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Peça apontada porem radio em SCRAP.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_cnovaret := "S"
						aAdd(_aitpecas,{cos,ccodmod,_ccompon,_cproddesc,_nqtde,"0",ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,_nrecsz9,cimei,_npercipi})
					EndIf
				EndIf
			EndIf
			SZ9->(dbSkip())
		EndDo
	EndIf
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011P  ºAutor  Edson Rodrigues      º Data ³  23/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica ultimo atendimento e se a fase de encerramento é  º±±
±±           ³ SCRAP                                                      ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function conscrap(_cos,_cimei)
Local cQryscrap
Local lResult:=.F.
Local _clab  :=""
cscrap :="N"
ZZJ->(dbSetorder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
If Select("QRYSCRAP") > 0
	QRYSCRAP->(dbCloseArea())
EndIf
cQryscrap:=" SELECT ZZ4_FILIAL, ZZ4_OS,ZZ4_FASATU,ZZ4_SETATU,ZZ4_OPEBGH "
cQryscrap+=" FROM "+RetSqlName('ZZ4')+" A (nolock) "
cQryscrap+=" WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' AND ZZ4_OS='"+_cos+"' AND ZZ4_IMEI='"+_cimei+"' AND D_E_L_E_T_='' AND ZZ4_STATUS>='5' "
TCQUERY cQryscrap NEW ALIAS "QRYSCRAP"
If Select("QRYSCRAP") > 0
	QRYSCRAP->(dbGoTop())
	While QRYSCRAP->(!Eof()) .AND. !Empty(QRYSCRAP->ZZ4_FASATU)
		If ZZJ->(dbSeek(xFilial("ZZJ")+QRYSCRAP->ZZ4_OPEBGH))
			_clab:=ZZJ->ZZJ_LAB
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cadastro de Fases.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea('ZZ1')
		If ZZ1->(dbSeek(xFilial("ZZ1")+_clab+QRYSCRAP->ZZ4_SETATU+QRYSCRAP->ZZ4_FASATU))
			If ZZ1->ZZ1_SCRAP='S'
				lResult:=.T.
				cscrap :="S"
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Apontamento de Fases.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea('ZZ3')
			If ZZ3->(dbSeek(QRYSCRAP->ZZ4_FILIAL + _cimei + QRYSCRAP->ZZ4_OS))
				_cfase:=ZZ3->ZZ3_FASE1
				_csetor:=ZZ3->ZZ3_CODSET
				While (ZZ3->ZZ3_FILIAL == QRYSCRAP->ZZ4_FILIAL) .AND. (ZZ3->ZZ3_IMEI == _cimei) .AND. (left(ZZ3->ZZ3_NUMOS,6) == left(QRYSCRAP->ZZ4_OS,6))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ajuste no fonte conforme ajuste no fonte AJBOUNCE realizado pelo Edson - Diego / 12/09/2013.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ZZ3->ZZ3_STATUS=='1'  .AND. ZZ3_ENCOS='S' .AND. ZZ3_ESTORN<>'S'
						If ZZ1->(dbSeek(xFilial("ZZ1") +_clab+ _csetor+_cfase))
							If ZZ1->ZZ1_SCRAP=="S"
								lResult:=.T.
								cscrap :="S"
							EndIf
						EndIf
					EndIf
					ZZ3->(Dbskip())
				EndDo
			EndIf
		EndIf
		QRYSCRAP->(Dbskip())
	EndDo
	QRYSCRAP->(dbCloseArea())
EndIf
Return(lResult)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Movbaixa  ºAutor  ³ Edson Rodrigues   º Data ³ 13 / 03 / 14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Movbaixa(lfim,_ctm,aItens,ctipo)
Local aAreaAnt	:= GetArea()
Private aMovSD3		:= {}
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas pela funcao wmsexedcf³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SB2")
dbSetOrder(1)
dbSelectArea("SD3")
nSavReg     := RecNo()
cDoc		:= space(6)
cDoc    	:= Iif(Empty(cDoc),NextNumero("SD3",2,"D3_DOC",.T.),cDoc)
cDoc    	:= A261RetINV(cDoc)
dbSetOrder(2)
dbSeek(xFilial()+cDoc)
cMay := "SD3"+Alltrim(xFilial())+cDoc
While D3_FILIAL+D3_DOC==xFilial()+cDoc .OR.!MayIUseCode(cMay)
	If D3_ESTORNO # "S"
		cDoc := Soma1(cDoc)
		cMay := "SD3"+Alltrim(xFilial())+cDoc
	EndIf
	dbSkip()
EndDo
aCab := {;
{"D3_DOC"		,cDoc			,NIL},;
{"D3_TM"		,_ctm     		,NIL},;
{"D3_EMISSAO"	,dDataBase		,Nil}}
For i:=1 To Len(aItens)
	SB1->(dbSeek(xFilial('SB1')+aItens[i,02]))
	_cLocal   := aItens[i,03]
	SB2->(dbSeek(xFilial('SB2') + SB1->B1_COD + _clocal))
	_nSalb2   := 0
	_nSalb2   := SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
	_nSaldoBF := 0
	_nSaldoBF := SaldoSBF(_clocal,aItens[i,05], SB1->B1_COD, NIL, NIL, NIL, .F.)
	If _nSalb2 >=  aItens[i,04] .AND. _nSaldoBF >= aItens[i,04]
		aItens[i,06]:="S"
		aItens[i,07]:=aItens[i,04]
		aAdd(aMovSD3,{{"D3_COD"		,aItens[i,02],NIL},;
		{"D3_LOCAL"		,aItens[i,03],NIL},;
		{"D3_QUANT"		,aItens[i,04],NIL},;
		{"D3_LOCALIZ"	,aItens[i,05],NIL}})
	Else
		aItens[i,06]:="N"
		aItens[i,07]:=_nSaldoBF
		If _nSaldoBF > 0
			aAdd(aMovSD3,{{"D3_COD"		,aItens[i,02],NIL},;
			{"D3_LOCAL"	,aItens[i,03],NIL},;
			{"D3_QUANT"	,_nSaldoBF,NIL},;
			{"D3_LOCALIZ"	,aItens[i,05],NIL}})
		EndIf
	EndIf
Next i
If Len(aMovSD3) > 0
	MSExecAuto({|x,y| MATA241(x,y)},aCab,aMovSD3)
	If lMsErroAuto
		MostraErro()
	Else
		For x:=1 To Len(aItens)
			For zx:=1 To Len(_aitpecas)
				_nsalbaix := aItens[x,7]
				If ctipo = "R" .AND. ctipo==_aitpecas[zx,12] .AND. _aitpecas[zx,3]==aItens[x,2]
					_nsalbaix -=_aitpecas[zx,5]
					If  _nsalbaix >= 0
						dbSelectArea("SZ9")
						dbGoto(_aitpecas[zx,13])
						RecLock("SZ9",.F.)
						SZ9->Z9_NUMSEQR := 	cDoc
						MsUnLock()
					EndIf
				ElseIf ctipo = "SD" .AND. _aitpecas[zx,12] $ ctipo .AND. _aitpecas[zx,3]==aItens[x,2]
					_nsalbaix -=_aitpecas[zx,5]
					If  _nsalbaix >= 0
						If _aitpecas[zx,12] =="S"
							dbSelectArea("SZ9")
							dbGoto(_aitpecas[zx,13])
							RecLock("SZ9",.F.)
							SZ9->Z9_NUMSEQS := 	cDoc
							MsUnLock()
						Else
							dbSelectArea("SZ9")
							dbGoto(_aitpecas[zx,13])
							RecLock("SZ9",.F.)
							SZ9->Z9_NUMSEQD := 	cDoc
							MsUnLock()
						EndIf
					EndIf
				EndIf
			Next zx
		Next x
	EndIf
EndIf
RestArea(aAreaAnt)
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ precopeca  ºAutor  ³ Edson Rodrigues  º Data ³ 18 / 03 / 14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   soma o valor das pecas vendicas para desconto no Claim   º±±
±±º          ³   total e para achar o valor de serviço                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function precopeca(_cos,_cimei,_cmodelo,cpvpeca,cgar,copera)
Local _nvalorpc := 0.00
If Select("QRYPRPC") > 0
	QRYPRPC->(dbCloseArea())
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o preco das peças vendidos pela OS.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cqryprpc:= " SELECT ZZQ_NUMOS,ZZQ_MODELO,SUM(ZZQ_QTDE) AS QTDE,SUM(ZZQ_VLRUNI) AS VLRUNIT,SUM(ZZQ_VLRTOT) VLRTOTAL "
cqryprpc+= " FROM "+RetSqlName("ZZQ")+"  ZZQ (NOLOCK) "
cqryprpc+= " INNER JOIN "
cqryprpc+= "     (SELECT ZZ4_FILIAL,ZZ4_OS,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_PVPECA,ZZ4_GARMCL,ZZ4_OPEBGH "
cqryprpc+= "      FROM "+RetSqlName("ZZ4")+"  ZZ41 (NOLOCK) "
cqryprpc+= "      WHERE  ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' AND ZZ4_IMEI='"+_cimei+"' AND ZZ4_OS='"+_cos+"' "
cqryprpc+= "      AND ZZ4_CODPRO='"+_cmodelo+"' AND ZZ4_PVPECA='"+cpvpeca+"'   "
cqryprpc+= "      AND ZZ4_GARMCL = '"+cgar+"'  AND ZZ4_OPEBGH='"+copera+"' AND D_E_L_E_T_='' "
cqryprpc+= "      ) AS ZZ4 "
cqryprpc+= " ON ZZQ_FILIAL=ZZ4_FILIAL AND ZZQ_NUMOS=ZZ4_OS AND ZZQ_IMEI=ZZ4_IMEI AND ZZQ_PV=ZZ4_PVPECA AND ZZQ_MODELO=ZZ4_CODPRO "
cqryprpc+= " INNER JOIN  "
cqryprpc+= "  (SELECT C5_FILIAL,C5_NUM FROM "+RetSqlName("SC5")+" (NOLOCK) WHERE D_E_L_E_T_='') AS SC5 "
cqryprpc+= "  ON ZZQ_FILIAL=C5_FILIAL AND ZZQ_PV=C5_NUM "
cqryprpc+= " WHERE  ZZQ_FILIAL = '"+XFILIAL("ZZQ")+"'  AND ZZQ.D_E_L_E_T_='' "
cqryprpc+= " GROUP BY ZZQ_NUMOS,ZZQ_MODELO "
TCQUERY cqryprpc NEW ALIAS "QRYPRPC"
If Select("QRYPRPC") > 0
	QRYPRPC->(dbGoTop())
	While QRYPRPC->(!Eof())
		_nvalorpc += QRYPRPC->VLRTOTAL
		QRYPRPC->(dbskip())
	EndDo
EndIf
Return(_nvalorpc)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fat peca  ºAutor  ³ Edson Rodrigues  º Data ³ 27 / 03 / 14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Verifica o se tem nf de retorno sem faturar/processar    º±±
±±º          ³   o pedido de peça                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fatpeca(_cos,_cimei)
Local _cpecpec := "XXXXXX"
If Select("QRYFTPC") > 0
	QRYFTPC->(dbCloseArea())
EndIf
_cQRYFTPC := " SELECT ZZ4_OS,ZZ4_PVPECA  FROM  "+RetSqlName("ZZ4")+" "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
//³Verifica o se tem nf de retorno sem faturar/processar  o pedido de peça.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ
_cQRYFTPC += " LEFT OUTER JOIN ( "
_cQRYFTPC += "    SELECT Z9_FILIAL,Z9_NUMOS,Z9_IMEI "
_cQRYFTPC += "    FROM "+RetSqlName("SZ9")+" (NOLOCK) "
_cQRYFTPC += "    WHERE D_E_L_E_T_='' AND Z9_SYSORIG IN ('1','2') AND  Z9_NUMSEQD='' AND Z9_NUMSEQR='' AND Z9_NUMSEQS='' "
_cQRYFTPC += "    AND Z9_STATUS='1'  "
_cQRYFTPC += "    GROUP BY Z9_FILIAL,Z9_NUMOS,Z9_IMEI  ) AS Z9  "
_cQRYFTPC += " ON Z9.Z9_FILIAL=ZZ4_FILIAL AND Z9.Z9_NUMOS=ZZ4_OS AND Z9.Z9_IMEI=ZZ4_IMEI "
/*
_cQRYFTPC += " LEFT OUTER JOIN ( "
_cQRYFTPC += " SELECT * FROM (   "
_cQRYFTPC += " SELECT Z9_FILIAL,Z9_NUMOS,Z9_IMEI FROM "+RetSqlName("SZ9")+" WHERE Z9_FILIAL='"+XFILIAL("SZ9")+"' AND D_E_L_E_T_='' AND Z9_SYSORIG IN ('1','2') AND  Z9_NUMSEQD='' AND Z9_STATUS='1' "
_cQRYFTPC += " UNION ALL
_cQRYFTPC += " SELECT Z9_FILIAL,Z9_NUMOS,Z9_IMEI FROM "+RetSqlName("SZ9")+" WHERE Z9_FILIAL='"+XFILIAL("SZ9")+"' AND D_E_L_E_T_='' AND Z9_SYSORIG IN ('1','2') AND  Z9_NUMSEQR='' AND Z9_STATUS='1' "
_cQRYFTPC += " UNION ALL
_cQRYFTPC += " SELECT Z9_FILIAL,Z9_NUMOS,Z9_IMEI FROM "+RetSqlName("SZ9")+" WHERE Z9_FILIAL='"+XFILIAL("SZ9")+"' AND D_E_L_E_T_='' AND Z9_SYSORIG IN ('1','2') AND  Z9_NUMSEQS='' AND Z9_STATUS='1' "
_cQRYFTPC += " UNION ALL
_cQRYFTPC += " SELECT Z9_FILIAL,Z9_NUMOS,Z9_IMEI  FROM SZ9020 (NOLOCK) Z9 "
_cQRYFTPC += "        INNER JOIN
_cQRYFTPC += "         ( SELECT B1_COD,B1_XMECELE FROM SB1020 WHERE B1_FILIAL='"+XFILIAL("SB1")+"' AND D_E_L_E_T_='' AND B1_XMECELE<>'E') B1 "
_cQRYFTPC += "        ON B1_COD=Z9_PARTNR
_cQRYFTPC += " WHERE Z9_FILIAL='"+XFILIAL("SZ9")+"' AND Z9_PARTNR<>'' AND Z9.D_E_L_E_T_='' AND Z9_STATUS='1'
_cQRYFTPC += "       AND Z9_SYSORIG='' AND Z9_DTAPONT>='20140331' "
_cQRYFTPC += " GROUP BY Z9_FILIAL,Z9_NUMOS,Z9_IMEI "
_cQRYFTPC += " ) DELIVERTABL "
_cQRYFTPC += " GROUP BY Z9_FILIAL,Z9_NUMOS,Z9_IMEI "
_cQRYFTPC += " ) AS Z9 "
_cQRYFTPC += " ON Z9.Z9_FILIAL=ZZ4_FILIAL AND Z9.Z9_NUMOS=ZZ4_OS AND Z9.Z9_IMEI=ZZ4_IMEI "
*/
_cQRYFTPC += " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' AND  ZZ4_OS='"+_cos+"' AND ZZ4_IMEI='"+_cimei+"' AND "
_cQRYFTPC += " Z9.Z9_NUMOS IS NOT NULL AND "
_cQRYFTPC += " D_E_L_E_T_=''  "
TCQUERY _cQRYFTPC NEW ALIAS "QRYFTPC"
If Select("QRYFTPC") > 0
	QRYFTPC->(dbGoTop())
	If !Empty(QRYFTPC->ZZ4_OS)
		_cpecpec := QRYFTPC->ZZ4_PVPECA
	EndIf
EndIf
Return(_cpecpec)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ baixfat  ºAutor  ³ Edson Rodrigues  º Data ³ 31 / 03 / 14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Baixa faturamento anterior ao incio do processo novo de  º±±
±±º          ³   apontamento                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function baixfat()
Local  newcodp :=space(15)
Local _coper   := ""
_aitpecas   := {}
_aitempc    := {}
_abaiscrd   := {}
_abaixret   := {}
_nrantzz4   := 0
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SB2")
dbSetOrder(1)
dbSelectArea("SZ9")
SZ9->(dbSetOrder(2))  // ZZQ_FILIAL
If Select("QRYBXFAT") > 0
	QRYBXFAT->(dbCloseArea())
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o se tem nf de retorno sem faturar/processar  o pedido de peça.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cQRYBXFT := " SELECT ZZ4_OPEBGH,ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI,ZZ4_STATUS,Z9_DTAPONT,Z9_PARTNR,Z9_QTY,Z9_LOCAL, "
_cQRYBXFT += " ZA6_RETRAB,ZZ4_FASATU,ZZ4_SETATU,ZZ3_CODTEC,ZZ3_FASE1,ZZ3_CODSET,ZZ3_FASE2,ZZ3_CODSE2,ZZ4.R_E_C_N_O_  AS RECZZ4 "
_cQRYBXFT += " FROM SZ9020 Z9 "
_cQRYBXFT += " INNER JOIN "
_cQRYBXFT += " (SELECT * FROM ZZ4020 WHERE D_E_L_E_T_='' AND ZZ4_STATUS='9' AND ZZ4_NFSDT<='20140331')  AS ZZ4 "
_cQRYBXFT += " ON Z9_FILIAL=ZZ4_FILIAL AND Z9_NUMOS=ZZ4_OS AND Z9_IMEI=ZZ4_IMEI "
_cQRYBXFT += " INNER JOIN "
_cQRYBXFT += " ( SELECT ZA5.*,ZA6_CODPRO,ZA6_RETRAB FROM ZA5020 ZA5 "
_cQRYBXFT += "  INNER JOIN "
_cQRYBXFT += " (SELECT * FROM ZA6020 WHERE D_E_L_E_T_='') AS ZA6 "
_cQRYBXFT += " ON ZA5_FILIAL=ZA6_FILIAL AND ZA5_IDKIT=ZA6_IDKIT "
_cQRYBXFT += "  WHERE ZA5_STATUS='5' AND ZA5.D_E_L_E_T_='' "
_cQRYBXFT += "  ) AS KIT "
_cQRYBXFT += "  ON Z9_FILIAL=ZA5_FILIAL AND Z9_NUMOS=ZA5_NUMOS AND Z9_IMEI=ZA5_IMEI AND Z9_PARTNR=ZA6_CODPRO "
_cQRYBXFT += "  left outer JOIN "
_cQRYBXFT += "  (SELECT ZZ3_FILIAL,ZZ3_CODTEC,ZZ3_NUMOS,ZZ3_IMEI,ZZ3_FASE1,ZZ3_CODSET,ZZ3_FASE2,ZZ3_CODSE2 "
_cQRYBXFT += "  FROM ZZ3020 WHERE D_E_L_E_T_='' AND ZZ3_ENCOS='S' AND ZZ3_STATUS='1' AND ZZ3_ESTORN<>'S') AS ZZ3 "
_cQRYBXFT += "  ON Z9_FILIAL=ZZ3_FILIAL AND Z9_NUMOS=ZZ3_NUMOS AND Z9_IMEI=ZZ3_IMEI "
_cQRYBXFT += " WHERE Z9_FILIAL='06' AND Z9_PARTNR<>'' AND Z9_SYSORIG = '1' AND Z9.D_E_L_E_T_='' AND Z9_STATUS='1' "
_cQRYBXFT += "       AND Z9_DTAPONT<='20140331' "
_cQRYBXFT += "       AND Z9_NUMSEQD='' AND Z9_NUMSEQR='' AND Z9_NUMSEQS='' "
_cQRYBXFT += " UNION "
_cQRYBXFT += " SELECT ZZ4_OPEBGH,ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI,ZZ4_STATUS,Z9_DTAPONT,Z9_PARTNR,Z9_QTY,Z9_LOCAL, "
_cQRYBXFT += " '' ZA6_RETRAB,ZZ4_FASATU,ZZ4_SETATU,ZZ3_CODTEC,ZZ3_FASE1,ZZ3_CODSET,ZZ3_FASE2,ZZ3_CODSE2,ZZ4.R_E_C_N_O_  AS RECZZ4 "
_cQRYBXFT += " FROM SZ9020 Z9 "
_cQRYBXFT += " INNER JOIN "
_cQRYBXFT += " (SELECT * FROM ZZ4020 WHERE D_E_L_E_T_='' AND ZZ4_STATUS='9' AND ZZ4_NFSDT<='20140331')  AS ZZ4 "
_cQRYBXFT += " ON Z9_FILIAL=ZZ4_FILIAL AND Z9_NUMOS=ZZ4_OS AND Z9_IMEI=ZZ4_IMEI "
_cQRYBXFT += " left outer JOIN "
_cQRYBXFT += " (SELECT ZZ3_FILIAL,ZZ3_CODTEC,ZZ3_NUMOS,ZZ3_IMEI,ZZ3_FASE1,ZZ3_CODSET,ZZ3_FASE2,ZZ3_CODSE2 "
_cQRYBXFT += " FROM ZZ3020 WHERE D_E_L_E_T_='' AND ZZ3_ENCOS='S' AND ZZ3_STATUS='1' AND ZZ3_ESTORN<>'S') AS ZZ3 "
_cQRYBXFT += " ON Z9_FILIAL=ZZ3_FILIAL AND Z9_NUMOS=ZZ3_NUMOS AND Z9_IMEI=ZZ3_IMEI "
_cQRYBXFT += " WHERE Z9_FILIAL='06' AND Z9_PARTNR<>'' AND Z9_SYSORIG = '2' AND Z9.D_E_L_E_T_='' AND Z9_STATUS='1' "
_cQRYBXFT += " AND Z9_DTAPONT<='20140331' "
_cQRYBXFT += " AND Z9_NUMSEQD='' AND Z9_NUMSEQR='' AND Z9_NUMSEQS='' "
_cQRYBXFT += " ORDER BY ZZ4_OS,ZZ4_IMEI,ZZ4_STATUS,Z9_DTAPONT,Z9_PARTNR "
TCQUERY _cQRYBXFT NEW ALIAS "QRYBXFAT"
If Select("QRYBXFAT") > 0
	QRYBXFAT->(dbGoTop())
	While QRYBXFAT->(!Eof())
		If   _nrantzz4 <> QRYBXFAT->RECZZ4
			ccodmod   := QRYBXFAT->ZZ4_CODPRO
			cItens    := "01"
			nreczz4   := QRYBXFAT->RECZZ4
			_nrantzz4 := QRYBXFAT->RECZZ4
			_carmazp  := "1P"
			_carmare  := "RE"
			_cendfat  := "FATURAR"
			_cTMscrap := "502"
			ctmsretr  :="508"
			_CTAB     := "NEX"
			ccuspec    :=Posicione("ZZJ",1,xFilial("ZZJ") + QRYBXFAT->ZZ4_OPEBGH, "ZZJ_CUSPEC")
			U_filpcnov(ccodmod,cItens,nreczz4,_carmazp,_carmare,_cendfat,_cTMscrap,_CTAB,ccuspec)
		EndIf
		QRYBXFAT->(DBSKIP())
	EndDo
EndIf
If Len(_aitpecas) > 0
	aSort(_aitpecas,,,{|x,y| x[3] < y[3]}) // Orderna por peça
	//          1    2         3          4        5      6     7       8        9        10        11       12       13     14
	//_aitpecas{cos,ccodmod,_ccompon,_cproddesc,_nqtde,citens,ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,recsz9,cimei}
	For xnv:=1 to Len(_aitpecas)
		If Alltrim(_aitpecas[xnv,3])  <> '1A22FQE00'
			If  _aitpecas[xnv,12] == "N"
				_aitpecas[xnv,12] := "D"
			EndIf
			_nPospeca := Ascan(_aitempc ,{ |p| p[12]+p[3] == _aitpecas[xnv,12]+_aitpecas[xnv,3]})
			If _nPospeca <= 0
				cItens     := Soma1(cItens,2)
				aAdd(_aitempc,{_aitpecas[xnv,1],_aitpecas[xnv,2],_aitpecas[xnv,3],_aitpecas[xnv,4],_aitpecas[xnv,5],cItens,;
				_aitpecas[xnv,7],_aitpecas[xnv,8],_aitpecas[xnv,9],_aitpecas[xnv,10],_aitpecas[xnv,11],_aitpecas[xnv,12]})
				_aitpecas[xnv,6]:=cItens
			Else
				_aitempc[_nPospeca,5]:=_aitempc[_nPospeca,5]+_aitpecas[xnv,5]
				_aitpecas[xnv,6]:=cItens
			EndIf
		EndIf
	Next
EndIf
If Len(_aitempc) >  0
	For xipcd:=1 to Len(_aitempc)
		_larmzpgt  :=.F.
		_nqtde     :=0.00
		_nquant    :=0.00
		_nquatu    :=0.00
		_nqtdecalc :=0.00
		_nvaldesc  := 0.00
		_ctm       :=Space(3)
		SB1->(dbSeek(xFilial('SB1')+_aitempc[xipcd,3]))
		_cLocal := Iif(_aitempc[xipcd,12] == "R",_aitempc[xipcd,9],_aitempc[xipcd,8])
		SB2->(dbSeek(xFilial('SB2') + SB1->B1_COD + _clocal))
		_nSalb2   := 0
		_nSalb2   := SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
		_nSaldoBF := 0
		_nSaldoBF := SaldoSBF(_clocal, _aitempc[xipcd,10], SB1->B1_COD, NIL, NIL, NIL, .F.)
		//          1    2         3          4        5      6     7       8        9        10        11       12        13     14
		//_aitpecas{cos,ccodmod,_ccompon,_cproddesc,_nqtde,citens,ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,nrecsz9,cimei}
		//  ATUSD3(_cTm,_cProdD3,_cLocal,_nQuant,_cLocaliz,_cDoc)
		If  SB1->B1_LOCALIZ=="S" .AND. _aitempc[xipcd,7] > 0  .AND. _aitempc[xipcd,12] == "N"
			_ctm:=_aitempc[xipcd,11]
			_aitempc[xipcd,12] := "D"
			If _nSalb2 >= _aitempc[xipcd,5]  .AND. _nSaldoBF >= _aitempc[xipcd,5]
				aAdd(_abaiscrd,{_ctm,_aitempc[xipcd,3],_aitempc[xipcd,8],_aitempc[xipcd,5],_aitempc[xipcd,10],'S',0})
			EndIf
		ElseIf SB1->B1_LOCALIZ=="S" .AND. _aitempc[xipcd,12] <> "N"
			If  _aitempc[xipcd,12] == "R"
				_ctm:=ctmsretr
				If _nSalb2 >= _aitempc[xipcd,5]  .AND. _nSaldoBF >= _aitempc[xipcd,5]
					aAdd(_abaixret,{_ctm,_aitempc[xipcd,3],_aitempc[xipcd,9],_aitempc[xipcd,5],_aitempc[xipcd,10],'S',0})
				EndIf
			ElseIf _aitempc[xipcd,12] == "S" .OR. _aitempc[xipcd,12] == "D"
				_ctm:=_aitempc[xipcd,11]
				If _nSalb2 >= _aitempc[xipcd,5]  .AND. _nSaldoBF >= _aitempc[xipcd,5]
					aAdd(_abaiscrd,{_ctm,_aitempc[xipcd,3],_aitempc[xipcd,8],_aitempc[xipcd,5],_aitempc[xipcd,10],'S',0})
				EndIf
			EndIf
		EndIf
	Next xipcd
	If  Len(_abaixret) > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz baixa das peças apontadas como retrabalho.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lfim| Movbaixa(@lfim,_abaixret[1,1],_abaixret,"R")},'Movimento de Baixa ', 'Baixando Peças Retrabalhadas', .T. )
		// Movbaixa(_abaixret[1,1],_abaixret,"R")
		_abaixret :={}
	EndIf
	If Len(_abaiscrd) > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz baixa das peças apontadas como duplicidas/perda ou se o rádio é  scrap.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lfim| Movbaixa(@lfim,_abaiscrd[1,1],_abaiscrd,"SD")},'Movimento de Baixa ', 'Baixando Peças Scrap/Perdas', .T. )
		//Movbaixa(_abaiscrd[1,1],_abaiscrd,"SD")
		_abaiscrd :={}
	EndIf
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ corbaix  ºAutor  ³ Edson Rodrigues  º Data ³ 10 / 04 / 14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Baixa peças que falharam na baixa interna durante o      º±±
±±º          ³   processo de geração do pedido de peças para faturamento  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function corbaix()
Local  newcodp :=space(15)
Local _coper   := ""
_aitpecas   := {}
_aitempc    := {}
_abaiscrd   := {}
_abaixret   := {}        
_nrantzz4   := 0
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SB2")
dbSetOrder(1)
dbSelectArea("SZ9")
SZ9->(dbSetOrder(2))  // ZZQ_FILIAL 
If Select("QRYCORBX") > 0                                                                                     
	QRYCORBX->(dbCloseArea())
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
//³Verifica o se tem nf de retorno sem faturar/processar  o pedido de peça.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ
_cQRYCOBX := " SELECT R_E_C_N_O_,REZ9,Z9_NUMOS,Z9_IMEI,Z9_PARTNR,Z9_QTY,Z9_PEDPECA,ZZ4_CODPRO,ZZ4_OPEBGH FROM SZ9020 SZ9 INNER JOIN "
_cQRYCOBX += " ( "
_cQRYCOBX += " SELECT Z9_FILIAL AS FILIAL,Z9_NUMOS AS OS,Z9_PARTNR AS PARTNR,R_E_C_N_O_ AS REZ9,ZZ4_CODPRO,ZZ4_OPEBGH FROM SZ9020 INNER JOIN "
_cQRYCOBX += " (SELECT ZZ4_FILIAL,ZZ4_OS,ZZ4_PVPECA,ZZ4_ASCRAP,ZZ4_FASATU,ZZ4_SETATU,ZZ4_CODPRO,ZZ4_OPEBGH FROM ZZ4020  "
_cQRYCOBX += " WHERE ZZ4_NFSNR<>'' AND ZZ4_NFSTES='727' AND ZZ4_OPEBGH IN ('N01','N10','N11')  "
_cQRYCOBX += " AND ZZ4_NFSSER='2' AND ZZ4_NFSDT>='20140401' AND D_E_L_E_T_='') AS ZZ4 "
_cQRYCOBX += " ON ZZ4_FILIAL=Z9_FILIAL AND ZZ4_OS=Z9_NUMOS "
_cQRYCOBX += " WHERE D_E_L_E_T_='' AND Z9_STATUS='1'  "
_cQRYCOBX += " AND Z9_PARTNR<>'' AND Z9_SYSORIG IN ('1','2')  "
_cQRYCOBX += " AND (Z9_PEDPECA='' AND Z9_NUMSEQR='' AND Z9_NUMSEQD='') "
_cQRYCOBX += " ) AS Z9 "
_cQRYCOBX += " ON Z9_FILIAL=FILIAL AND Z9_NUMOS=OS AND Z9_PARTNR=PARTNR "
_cQRYCOBX += " WHERE Z9_PEDPECA<>'' AND D_E_L_E_T_='' AND R_E_C_N_O_<>REZ9 "
_cQRYCOBX += " ORDER BY SZ9.Z9_NUMOS "
TCQUERY _cQRYCOBX NEW ALIAS "QRYCORBX"
If Select("QRYCORBX") > 0
	QRYCORBX->(dbGoTop())
	While QRYCORBX->(!Eof())
		cos        := QRYCORBX->Z9_NUMOS
		cItens    := "01"
		cimei      := QRYCORBX->Z9_IMEI
		ccodmod    := QRYCORBX->ZZ4_CODPRO
		_ccompon   := QRYCORBX->Z9_PARTNR
		_cproddesc := Posicione("SB1",1,xFilial("SB1")+LEFT(QRYCORBX->Z9_PARTNR,15), "B1_DESC")
		_nqtde     := QRYCORBX->Z9_QTY
		_carmazp   := "1P"
		_carmare   := "RE"
		_cendfat   := "FATURAR"
		_cTMscrap  := "502"
		ctmsretr   := "508"
		_CTAB      := "NEX"
		ccuspec    :=Posicione("ZZJ",1,xFilial("ZZJ") + QRYCORBX->ZZ4_OPEBGH, "ZZJ_CUSPEC")
		ncusto     := 0
		_cnovaret  := "D"
		_nrecsz9   := REZ9
		aAdd(_aitpecas,{cos,ccodmod,_ccompon,_cproddesc,_nqtde,"0",ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,_nrecsz9,cimei})
/*
	If   _nrantzz4 <> QRYBXFAT->RECZZ4
		ccodmod   := QRYBXFAT->ZZ4_CODPRO
		cItens    := "01"
		nreczz4   := QRYBXFAT->RECZZ4
		_nrantzz4 := QRYBXFAT->RECZZ4
		_carmazp  := "1P"
		_carmare  := "RE"
		_cendfat  := "FATURAR"
		_cTMscrap := "502"
		ctmsretr  :="508"
		_CTAB     := "NEX"
		ccuspec    :=Posicione("ZZJ",1,xFilial("ZZJ") + QRYBXFAT->ZZ4_OPEBGH, "ZZJ_CUSPEC")
		U_filpcnov(ccodmod,cItens,nreczz4,_carmazp,_carmare,_cendfat,_cTMscrap,_CTAB,ccuspec)
	EndIf
*/
		QRYCORBX->(DBSKIP())
	EndDo
EndIf
If Len(_aitpecas) > 0
	aSort(_aitpecas,,,{|x,y| x[3] < y[3]}) // Orderna por peça
	//          1    2         3          4        5      6     7       8        9        10        11       12       13     14
	//_aitpecas{cos,ccodmod,_ccompon,_cproddesc,_nqtde,citens,ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,recsz9,cimei}
	For xnv:=1 to Len(_aitpecas)
//		If Alltrim(_aitpecas[xnv,3])  <> '1A22FQE00'
		If  _aitpecas[xnv,12] == "N"
			_aitpecas[xnv,12] := "D"
		EndIf
		_nPospeca := Ascan(_aitempc ,{ |p| p[12]+p[3] == _aitpecas[xnv,12]+_aitpecas[xnv,3]})
		If _nPospeca <= 0
			cItens     := Soma1(cItens,2)
			aAdd(_aitempc,{_aitpecas[xnv,1],_aitpecas[xnv,2],_aitpecas[xnv,3],_aitpecas[xnv,4],_aitpecas[xnv,5],cItens,;
			_aitpecas[xnv,7],_aitpecas[xnv,8],_aitpecas[xnv,9],_aitpecas[xnv,10],_aitpecas[xnv,11],_aitpecas[xnv,12]})
			_aitpecas[xnv,6]:=cItens
		Else
			_aitempc[_nPospeca,5]:=_aitempc[_nPospeca,5]+_aitpecas[xnv,5]
			_aitpecas[xnv,6]:=cItens
		EndIf
//		EndIf
	Next
EndIf
If Len(_aitempc) >  0
	For xipcd:=1 to Len(_aitempc)
		_larmzpgt  :=.F.
		_nqtde     :=0.00
		_nquant    :=0.00
		_nquatu    :=0.00
		_nqtdecalc :=0.00
		_nvaldesc  := 0.00
		_ctm       :=Space(3)
		SB1->(dbSeek(xFilial('SB1')+_aitempc[xipcd,3]))
		_cLocal := Iif(_aitempc[xipcd,12] == "R",_aitempc[xipcd,9],_aitempc[xipcd,8])
		SB2->(dbSeek(xFilial('SB2') + SB1->B1_COD + _clocal))
		_nSalb2   := 0
		_nSalb2   := SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
		_nSaldoBF := 0
		_nSaldoBF := SaldoSBF(_clocal, _aitempc[xipcd,10], SB1->B1_COD, NIL, NIL, NIL, .F.)
		//          1    2         3          4        5      6     7       8        9        10        11       12        13     14
		//_aitpecas{cos,ccodmod,_ccompon,_cproddesc,_nqtde,citens,ncusto,_carmazp,_carmare,_cendfat,_cTMscrap,_cnovaret,nrecsz9,cimei}
		//  ATUSD3(_cTm,_cProdD3,_cLocal,_nQuant,_cLocaliz,_cDoc)
		If  SB1->B1_LOCALIZ=="S" .AND. _aitempc[xipcd,7] > 0  .AND. _aitempc[xipcd,12] == "N"
			_ctm:=_aitempc[xipcd,11]
			_aitempc[xipcd,12] := "D"
			If _nSalb2 >= _aitempc[xipcd,5]  .AND. _nSaldoBF >= _aitempc[xipcd,5]
				aAdd(_abaiscrd,{_ctm,_aitempc[xipcd,3],_aitempc[xipcd,8],_aitempc[xipcd,5],_aitempc[xipcd,10],'S',0})
			EndIf
		ElseIf SB1->B1_LOCALIZ=="S" .AND. _aitempc[xipcd,12] <> "N"
			If  _aitempc[xipcd,12] == "R"
				_ctm:=ctmsretr
				If _nSalb2 >= _aitempc[xipcd,5]  .AND. _nSaldoBF >= _aitempc[xipcd,5]
					aAdd(_abaixret,{_ctm,_aitempc[xipcd,3],_aitempc[xipcd,9],_aitempc[xipcd,5],_aitempc[xipcd,10],'S',0})
				EndIf
			ElseIf _aitempc[xipcd,12] == "S" .OR. _aitempc[xipcd,12] == "D"
				_ctm:=_aitempc[xipcd,11]
				If _nSalb2 >= _aitempc[xipcd,5]  .AND. _nSaldoBF >= _aitempc[xipcd,5]
					aAdd(_abaiscrd,{_ctm,_aitempc[xipcd,3],_aitempc[xipcd,8],_aitempc[xipcd,5],_aitempc[xipcd,10],'S',0})
				EndIf
			EndIf
		EndIf
	Next xipcd
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz baixa das peças apontadas como retrabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  Len(_abaixret) > 0
		Processa( { |lfim| Movbaixa(@lfim,_abaixret[1,1],_abaixret,"R")},'Movimento de Baixa ', 'Baixando Peças Retrabalhadas', .T. )
		// Movbaixa(_abaixret[1,1],_abaixret,"R")
		_abaixret :={}
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz baixa das peças apontadas como duplicidas/perda ou se o rádio é  scrap³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(_abaiscrd) > 0
		Processa( { |lfim| Movbaixa(@lfim,_abaiscrd[1,1],_abaiscrd,"SD")},'Movimento de Baixa ', 'Baixando Peças Scrap/Perdas', .T. )
		//Movbaixa(_abaiscrd[1,1],_abaiscrd,"SD")
		_abaiscrd :={}
	EndIf
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FTSERPEC  ºAutor  ³Microsiga           º Data ³  11/19/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function pecaprec(cos,cimei,cmod)
Local nCMed	:= 0.00
dbSelectArea("SZ9")
If SZ9->(dbSeek(xFilial("SZ9") + cimei + left(cos,6)))
	While SZ9->(!Eof()) .AND. (SZ9->Z9_FILIAL == xFilial("SZ9")) .AND. (SZ9->Z9_IMEI == cimei) .AND. (LEFT(SZ9->Z9_NUMOS,6) == left(cos,6))
		_cyesret := Posicione("SB1",1,xFilial("SB1")+LEFT(SZ9->Z9_PARTNR,15), "B1_RETRABA")
		If SZ9->Z9_STATUS=="1"  .AND. !Empty(SZ9->Z9_PARTNR) .AND. SZ9->Z9_SYSORIG $ "1/2" .AND. _cyesret<>"S" .AND. Empty(SZ9->Z9_NUMSEQS) .AND. Empty(SZ9->Z9_NUMSEQR) .AND. Empty(SZ9->Z9_NUMSEQD) .AND. Empty(SZ9->Z9_PEDPECA)
			nCMed := CustMed(LEFT(SZ9->Z9_PARTNR,15),"1P",DDATABASE)
//			If GetMV("MV_XTABPEC") == "C" .AND. (ValType(aCMed[8]) <> "N" .OR. aCMed[8] <= 0)
			If GetMV("MV_XTABPEC") == "C" .AND. (ValType(nCMed) <> "N" .OR. nCMed <= 0)
				aAdd(_apecprec,{2,cimei,cos,cmod,SZ9->Z9_PARTNR,"Custo médio da peça negativo","Informar a Controladoria para acerto no Custo médio."  })
			ElseIf GetMV("MV_XTABPEC") == "C" .AND. !(DA1->(dbSeek(xFilial("DA1") + "NEX" +LEFT(SZ9->Z9_PARTNR,15))))
				aAdd(_apecprec,{2,cimei,cos,cmod,SZ9->Z9_PARTNR,"Peça sem cadastro tabela de preço (Valor pelo Custo Médio)","Cadastre essa peça na Tabela de Preço DA0/DA1 tabela NEX "  })
			ElseIf GetMV("MV_XTABPEC") == "T" .AND. !(DA1->(dbSeek(xFilial("DA1") + "NEX" +LEFT(SZ9->Z9_PARTNR,15))))
				aAdd(_apecprec,{2,cimei,cos,cmod,SZ9->Z9_PARTNR,"Peça sem cadastro na taela de Preço","Cadastre essa peça na Tabela de Preço DA0/DA1 tabela NEX"  })
			EndIf
		EndIf
		SZ9->(dbSkip())
	EndDo
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FTSERPEC  ºAutor  ³Microsiga           º Data ³  11/19/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function NameFil(cEmp, cFil)
Local cRet	:= "  "
Local nXX	:= 0
cAux := Posicione("SM0",1,cEmp + cFil,"M0_FILIAL")
cAux := Alltrim(cAux)
cAux := Upper(cAux)
For nXX := 1 to Len(cAux)
	cRet += SubSTR(cAux,nXX,1)
	cRet += " "
Next nXX
cRet += " "
Return(cRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRIASX1  ºAutor  ³Edson Rodrigues     º Data ³  18/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para criacao automatica das perguntas (SX1)         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSx1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Cod. Cliente"			,"Cod. Cliente"				,"Cod. Cliente"				,"mv_ch1","C",06,0,0,"G","","SA1"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Loja"					,"Loja"						,"Loja"						,"mv_ch2","C",02,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Operacao(oes) BGH :"	    ,"Operacao(oes) BGH : "	    ,"Operacao(oes) BGH :"		,"mv_ch3","C",60,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Emis.NF Devol Inic."     ,"Emis.NF Devol Inic. "		,"Emis.NF Devol Inic."		,"mv_ch4","D",8,0,0, "G","",""  	,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Emis.NF Devol final"		,"Emis.NF Devol final "		,"Emis.NF Devol final"		,"mv_ch5","D",8,0,0, "G","",""	    ,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Gera Pedido ? "			,"Gera Pedido ?       "		,"Gera Pedido ?      "		,"mv_ch6","N",01,0,0,"C","",""	    ,"",,"mv_par06","","Serviço","","","","Peças","","","","Ambos","","","","","","")
PutSX1(cPerg,"07","Modelo ?"		        ,"Modelo ? "		        ,"Modelo ?           "		,"mv_ch7","C",15,0,0, "G","",""    ,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","NF devol. de : "        ,"NF devol. de : "		    ,"NF devol. de :    "	  	,"mv_ch8","C",9,0,0, "G","",""  	,"",,"mv_par08","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"09","NF devol. ate: "	        ,"NF devol. ate: "		    ,"NF devol. ate:   "		,"mv_ch9","C",9,0,0, "G","",""	    ,"",,"mv_par09","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"10","Serie NF devol. de : "  ,"Serie NF devol. de : "		,"Serie NF devol. de : "	,"mv_ch10","C",3,0,0, "G","",""  	,"",,"mv_par10","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"11","Serie NF Devol ate : "  ,"Serie NF Devol ate : "		,"Serie NF Devol ate : "	,"mv_ch11","C",3,0,0, "G","",""	    ,"",,"mv_par11","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"12","Emis.PV Devol Inic."     ,"Emis.PV Devol Inic. "		,"Emis.PV Devol Inic."		,"mv_ch12","D",8,0,0, "G","",""  	,"",,"mv_par12","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"13","Emis.PV Devol final"		,"Emis.PV Devol final "		,"Emis.PV Devol final"		,"mv_ch13","D",8,0,0, "G","",""	    ,"",,"mv_par13","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"14","Pedido Devol. de  : "   ,"Pedido Devol. de  : "		,"Pedido devol. de : "	    ,"mv_ch14","C",6,0,0, "G","",""  	,"",,"mv_par14","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"15","Pedido Devol. ate : "   ,"Pedido Devol ate  : "		,"Pedido Devol ate : "	    ,"mv_ch15","C",6,0,0, "G","",""	    ,"",,"mv_par15","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"16","Filtra Devol Por  ? "   ,"Filtra Devol Por  ? "   	,"Filtra Devol Por  ? "     ,"mv_ch16","N",01,0,0,"C","",""	    ,"",,"mv_par16","","NF Devol","","","","Ped Devol","","","","Ambos","","","","","","")
Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CalcImp  ºAutor  ³Hudson de Souza Santos  ºData ³ 18/08/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula imposto baseado na regra (GLPI 20673)              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CalcImp(cProduto,nPrcVen,cCodCli,cLojCli,cTes,cCF)
Local aAreaAtu	:= GetArea()
Local nAlqIPI	:= 0
Local nAlqICM	:= 0
Local nAlqPIS	:= 0
Local nAlqCOF	:= 0
Local nTotal	:= 0
Local nMargem	:= 5
dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+cCodCli+cLojCli)
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Agrega os itens para a funcao fiscal         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAdd(cProduto,;		// 1-Codigo do Produto ( Obrigatorio )
	cTes,;					// 2-Codigo do TES ( Opcional )
	1,;						// 3-Quantidade ( Obrigatorio )
	nPrcVen,;				// 4-Preco Unitario ( Obrigatorio )
	0,;						// 5-Valor do Desconto ( Opcional )
	"",;					// 6-Numero da NF Original ( Devolucao/Benef )
	"",;					// 7-Serie da NF Original ( Devolucao/Benef )
	0,;						// 8-RecNo da NF Original no arq SD1/SD2
	0,;						// 9-Valor do Frete do Item ( Opcional )
	0,;						// 10-Valor da Despesa do item ( Opcional )
	0,;						// 11-Valor do Seguro do item ( Opcional )
	0,;						// 12-Valor do Frete Autonomo ( Opcional )
	nPrcVen,;				// 13-Valor da Mercadoria ( Obrigatorio )
	0,;						// 14-Valor da Embalagem ( Opiconal )
	,;
	,;
	"",;
	0,;						// 18-Despesas nao tributadas - Portugal
	0,;						// 19-Tara - Portugal
	cCF;					// 20-CFO
	)
	nAlqIPI	:= MaFisRet(1,"IT_ALIQIPI")
	nAlqICM	:= MaFisRet(1,"IT_ALIQICM")
	nAlqPIS	:= MaFisRet(1,"IT_ALIQPIS")
	nAlqCOF	:= MaFisRet(1,"IT_ALIQCOF")
	nTotal	:= nPrcVen / (1-((nAlqPIS+nAlqCOF)/100)-(nAlqICM/100))
	If "NEXTEL" $ SA1->A1_NOME
		nTotal	:= nTotal/(1-(nMargem/100))
		nTotal	:= nTotal*(1+(nAlqIPI/100))
	EndIf
	nTotal	:= Round(nTotal,2)
	MaFisEnd()
Else
	nTotal	:= 0.00
Endif
RestArea(aAreaAtu)
Return(nTotal)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Static Function auxiliar para buscar o Custo Médio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function CustMed(cProd, cArm, dData)
Local nRet	:= 0.00
Local aCMed	:= {}
Local aArea	:= {}
aCMed	:= CalcEst(cProd,cArm,dData)
nRet	:= Round((aCMed[2]/aCMed[1]),2)
Return(nRet)