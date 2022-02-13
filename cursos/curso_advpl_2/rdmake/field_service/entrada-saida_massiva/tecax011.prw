#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "CHEQUE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE LFRC CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ tecax011 ºAutor  ³ERPPLUS - M.Munhoz  º Data ³ 29/04/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que executa a entrada Massiva de Celulares no       º±±
±±º          ³ estoque e Field Service                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGATEC/SIGAEST - BGH do Brasil                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tecax011(cOrigem,cVarmst,_lAuto)

Local cVarBar      := Space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
Local cVarSIM      := Replicate(' ',25)
Local _cvlope      := ""

Default cVarmst    := Replicate(' ',20)
Default _lAuto     := .F.

Public cTexto      := ""
Public cTextac     := ""
Public cBkpTexTac  := ""
Public UltReg      := .F.
Public _lFechEM    := .F.

Private oV1,oV2
Private cPerg       := "BARZZ4"
Private _nqtde      := 0.00
Private cgeraimei   :=""
Private centriage   :="N"
Private cprefixo    :=" "
Private nTamNfe     := TAMSX3("D1_DOC")[1]
Private nTcodpr		:= TAMSX3("ZZ4_IMEI")[1]
Private cStartPath  := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Private cCNPJ       := Space(18)
Private aForm       := {"Nao","Sim"}
Private cForm       := aForm[1]                        
Private aPallet     := {"P1","P2","P3","P4","P5","P6","P7","P8","P9"}
Private cPallet     := aPallet[1]                        
Private cDescr      := Space(40)
Private cEntr       := Space(50)
Private cscrap      := "N"
Private _cSpc	    := ""
Private _cnewoper   := Space(3)
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut     := .F.                             	 //Usuarios de Autorizado a excluir IMEI
Private _aetqentm   := {}   //  array com os codigos master escaneados.
Private lselqrytst  := .F.
Private _lyesema    := .F.
Private _lspc433	:= .F.
Private _cPsq		:= GetMv("MV_PERSPC3") 				 // Periodo Parametrizados para Especifico SPC0000433 - Motorola
Private _cSpr		:= GetMv("MV_SPC0433") 				 // Aparelhos Parametrizados para Especifico SPC0000433 - Motorola
private cNexSpRj    := GetMv("MV_NEXTSP") + "/" + GetMv("MV_NEXTRJ") // Clientes Nextel CD Rio e São Paulo
Private _cOrigem	:= Iif(cOrigem <> NIL,cOrigem,"")
Private _actacess	:= {}
Private oDlg



u_GerA0003(ProcName())
dbSelectArea("ZZ1")  //Cadastro de Fases
dbSelectArea("ZZ3")  //Apontamento de fases
dbSelectArea("SA1")  //Cadastro de Clientes
dbSelectArea("SB1")  //Cadastro de Produtos
dbSelectArea("ZZ4")  //Entrada Massiva
dbSelectArea("AB7")  //Itens da OS
ZZ1->(dbSetorder(1)) // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET
ZZ3->(dbSetorder(1))  // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
SA1->(dbSetorder(1)) //A1_FILIAL+A1_COD+A1_LOJA
SB1->(dbSetorder(1)) //B1_FILIAL+B1_COD
ZZ4->(dbSetorder(2)) //ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI
AB7->(DBOrderNickName("AB7NUMSER")) //AB7_FILIAL+AB7_NUMOS+AB7_NUMSER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 To Len(aGrupos)
//Usuarios de Autorizado a entrar com NF-Compras
	If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores#Explider"
		lUsrAut  := .T.
	Endif
Next i
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apresenta tela para digitar informacoes                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// QUERY AUXILIAR PARA TESTES DE ENTRADA MASSIVA AUTOMATICA
If !Upper(left(_cOrigem,8)) $ "BGHTRIAG"
	If Substr(Alltrim(Upper(GetEnvServer())),1,5) $ "DEVEL" .and.  MSGYESNO("Deseja fazer a Entrada Massiva automatica ? Atualizar o ambiente de desenvolvimento com dados do ambiente de produção.")
		If Select("QRYTST") > 0
			QRYTST->(dbCloseArea())
		Endif
		qauxtest()
		_lyesema:=.T.
	Endif
Endif
If Select("QRYTST") > 0  .and. !Empty(QRYTST->ZZ4_IMEI)
	_lRetTela  :=.T.
	lselqrytst :=.T.
ELSE
	If _lyesema
		MsgBox("Não foi encontrado dados para o processamento da entrada massiva automática !","Sem dados para processamento automático","ALERT")
	Endif
	If !Upper(left(_cOrigem,8)) $ "BGHTRIAG"
		_lRetTela := u_Tecx011A()
	Else
		_lRetTela := .T.
		mv_par09 := right(_cOrigem,3)
	End
Endif
If !_lRetTela
	Return()
Endif
// Incluso para trazer os aparelho ja lidos no nome do usuario e por operacao // Edson Rodrigues 20/04/10.
ZZ4->(dbSetorder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
_SerEnt:={}
_cvlope   := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_TROPEN")  // variavel que indica se deve fazer validação de troca de operação
_cQryent := " SELECT ZZ4_CODCLI,ZZ4_LOJA,ZZ4_CODPRO,ZZ4_NFENR,ZZ4_NFESER,ZZ4_IMEI,ZZ4_CARCAC,ZZ4_VLRUNI,ZZ4_ETQMEM " + LFRC
_cQryent += " FROM   "+RetSqlName("ZZ4")+" (nolock) " + LFRC
_cQryent += " WHERE  ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' AND " + LFRC
_cQryent += "        ZZ4_STATUS  = '1' AND " + LFRC // Entrada Massiva lida
_cQryent += "        D_E_L_E_T_ = ''  AND " + LFRC
If _cvlope <> "S" .or. !lselqrytst
	_cQryent += "        ZZ4_OPEBGH = '"+ALLTRIM(mv_par09)+"'  AND " + LFRC
Endif
If _lAuto
	_cQryent += "        1=2 AND " + LFRC
EndIf
_cQryent += "        Upper(LEFT(ZZ4_EMUSER,13)) = '"+Upper(Left(cUserName,13))+"' " + LFRC
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryEnt),"X02",.T.,.T.)
dbSelectArea("X02")
X02->(dbGoTop())
While X02->(!eof())
	tMemo := "Cliente: "+X02->ZZ4_CODCLI+" Loja: "+ X02->ZZ4_LOJA+LFRC
	tMemo += "Produto: "+ALLTRIM(X02->ZZ4_CODPRO)+" Descricao: "+ALLTRIM(SB1->B1_DESC)+LFRC
	tMemo += "NF: "+ALLTRIM(X02->ZZ4_NFENR)+" Série: "+ALLTRIM(X02->ZZ4_NFESER)+" Valor: "+Transform(X02->ZZ4_VLRUNI,"@E 999,999.99999")+LFRC
	tMemo += "SN: "+ALLTRIM(ZZ4_IMEI)+"   SIM/Carcaça: "+ALLTRIM(ZZ4_CARCAC)+LFRC
	tMemo += "IMEI/SN ja lido"+LFRC+LFRC
	cTexto := tMemo+cTexto
	AADD(_SerEnt,X02->ZZ4_IMEI  )
	AADD(_aetqentm,{X02->ZZ4_ETQMEM})
	X02->(dbSkip())
EndDo
If Len(_SerEnt) > 0
	tMemo  := "Foram incluidos anteriormente "+Transf(Len(_SerEnt),"@E 999,999")+" aparelhos "+LFRC+LFRC
	cTexto := tMemo+cTexto
Endif
X02->(dbCloseArea())
// Volta o indice da tabela no indice que estava - Edson Rodrigues 12/04/10
ZZ4->(dbSetorder(2)) //ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos fontes                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFnt1  := TFont():New("Arial",18,22,,.T.,,,,.T.,.F.)
oFnt2  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
oFnt3  := TFont():New("Courier New",08,12,,.F.,,,,.F.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao das Teclas de Funcao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SetKey(VK_F9 ,{|| Pergunte('BARZZ4',.T.)}) //Tela com todos os parametros
SetKey(VK_F9 ,{|| U_F9ENTR()}) //Tela com todos os parametros
//SetKey(VK_F10,{|| U_ITNFE(@cTexto,cTipo)}) //Permite INSERIR Itens da NF sem numero de Série
//SetKey(VK_F11,{|| U_CLILJ()}) //Permite mudar o Cliente e Loja
//SetKey(VK_F12,{|| U_PRODUTO()}) //Permite mudar o Modelo do Celular
If !Upper(left(_cOrigem,8)) $ "BGHTRIAG"
	If !lselqrytst
		If !Empty(mv_par09)  .AND. mv_par09<>'ZZZ'
			centriage := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_TRIAGE")
			If centriage = "S" .and.  !MSGYESNO("Deseja fazer a entrada massiva pela Etiqueta Master ? ","Operação Triagem")
				centriage:="N"
			Endif
		Endif
	Endif
Else
	centriage := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_TRIAGE")
Endif
While !_lFechEM
	If empty(cVarmst)
		@ 0,0 To 460,520 Dialog oDlg Title "Entrada Massiva"
		oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"CodBar.bmp",.T.,oDlg)
		@ 005,077 Say oV1 var "Passe a leitora de" Of oDlg FONT oFnt1 Pixel Size 150,010 COLOR CLR_BLUE
		@ 020,075 Say oV2 var "código de barras"   Of oDlg FONT oFnt1 Pixel Size 150,012 COLOR CLR_BLUE
		If lselqrytst
			_cchavimei:=""
			While !QRYTST->(EOF())
				If  _cchavimei <> QRYTST->A1_COD+QRYTST->A1_LOJA+QRYTST->ZZ4_NFENR+QRYTST->ZZ4_NFESER+QRYTST->ZZ4_CODPRO+QRYTST->ZZ4_IMEI
					_cchavimei:=QRYTST->A1_COD+QRYTST->A1_LOJA+QRYTST->ZZ4_NFENR+QRYTST->ZZ4_NFESER+QRYTST->ZZ4_CODPRO+QRYTST->ZZ4_IMEI
					mv_par01 := QRYTST->A1_COD
					mv_par02 := QRYTST->A1_LOJA
					mv_par03 := QRYTST->ZZ4_CODPRO
					mv_par04 := QRYTST->ZZ4_NFENR
					mv_par05 := QRYTST->ZZ4_NFESER
					mv_par06 := QRYTST->ZZ4_VLRUNI
					_nqtde   := 0.0000
					mv_par07 := "05"
					mv_par08 := 2
					mv_par09 := QRYTST->ZZ4_OPEBGH
					mv_par10 := QRYTST->ZA_OSAUTOR //OS SAM
					mv_par11 := QRYTST->ZA_CODAUTO // COD. AUTORIZ.
					mv_par12 := QRYTST->ZA_CODRECL  // RECL. CLIENTE
					mv_par13 := QRYTST->ZA_CODAUTO //OPERADORA
					mv_par14 := QRYTST->ZA_CODTRANS //TRANSPORT
					mv_par15 := "N" //ACESSORIO
					mv_par16 := QRYTST->ZZ4_GARANT  // GARANTIA SIM OU NAO
					mv_par17 := QRYTST->ZA_TRACKIN // CONHECIMENTO/LACRE
					mv_par18 := QRYTST->ZA_NFCOMPR // NF de Compra
					mv_par19 := QRYTST->ZA_DTNFCOM  // Data da NF de Compra
					mv_par20 := Space(30) //Descrição do Produto
					mv_par21 := Space(3) // Serie NF Compra
					mv_par22 := Space(18) //CNPJ/CPF NF Compra
					mv_par23 := Space(14) //CPF Cliente
					cVarBar  := QRYTST->ZZ4_IMEI
					cVarSim  := QRYTST->ZZ4_CARCAC
					mv_par24 := Space(9)			// NF de Troca
					mv_par25 := Space(3)			// Serie NF Troca
					mv_par26 := CtoD("  /  / ")		// Data da NF de Troca
					mv_par27 := Space(18)			//CNPJ/CPF NF Troca
					If !Empty(mv_par09)  .AND. mv_par09<>'ZZZ'
						cgeraimei := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_IMEI")
						If cgeraimei=="02" 	.AND. _nqtde > 0 .and. !lselqrytst
							cprefixo :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_PREFIX")
							If MSGYESNO("Confirma a quantidade digitada de: "+STRZERO(_nqtde,4)+" IMEIS a gerar.  Caso nao confirme, devera digitar os parametros novamente.")
								@ 035,010 Get cVarSIM Size 100,080 Picture "@!" when .F. Valid .T. Object oEdSIM
								@ 050,010 Get cVarBar Size 100,080 Picture "@!" when .F. Valid .T. Object oEdBar
								Processa({|| u_tecx11gr2(@cVarBar,@cTexto,@cVarSim,.F.,_nqtde,mv_par09,cprefixo,cgeraimei)}, "Aguarde...","Gerando IMEIs e validando Atendimento", .T. )
							Else
								_lFechEM:=.T.
								loop
							Endif
						ElseIf centriage ="S"
							@ 035,010 Get cVarmst Size 100,080 Picture "@!" Valid u_seltriag(@cVarBar,@cTexto,@cVarSim,@cVarmst,.F.) Object oEdmst
						ELSE
							@ 035,010 Get cVarSIM Size 100,080 Picture "@!" Valid .T. Object oEdSIM
							@ 050,010 Get cVarBar Size 100,080 Picture "@!" Valid u_Tecx011Grv(@cVarBar,@cTexto,@cVarSim,.F.) Object oEdBar
							//Processa({|| u_Tecx011Grv(@cVarBar,@cTexto,@cVarSim,.T.,0)}, "Aguarde...","Lendo Entrada massiva", .T. )
						Endif
					Endif
				Endif
				QRYTST->(DBSKIP())
			EndDo
		Else
			If !Empty(mv_par09)  .AND. mv_par09<>'ZZZ'
				cgeraimei := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_IMEI")
				If cgeraimei=="02" 	.AND. _nqtde > 0
					cprefixo :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_PREFIX")
					If MSGYESNO("Confirma a quantidade digitada de: "+STRZERO(_nqtde,4)+" IMEIS a gerar.  Caso nao confirme, devera digitar os parametros novamente.")
						@ 035,010 Get cVarSIM Size 100,080 Picture "@!" when .F. Valid u_IMEIxModel(cVarSIM, mv_par09,"C") Object oEdSIM//Valid .T. Object oEdSIM
						@ 050,010 Get cVarBar Size 100,080 Picture "@!" when .F. Valid u_IMEIxModel(cVarBar, mv_par03,"I") Object oEdBar
						Processa({|| u_tecx11gr2(@cVarBar,@cTexto,@cVarSim,.F.,_nqtde,mv_par09,cprefixo,cgeraimei)}, "Aguarde...","Gerando IMEIs e validando Atendimento", .T. )
					Else
						_lFechEM:=.T.
						loop
					Endif
				ElseIf centriage ="S"
					@ 035,010 Get cVarmst Size 100,080 Picture "@!" Valid u_seltriag(@cVarBar,@cTexto,@cVarSim,@cVarmst,.F.) Object oEdmst
				ELSE
					@ 035,010 Get cVarSIM Size 100,080 Picture "@!" Valid u_IMEIxModel(cVarSIM, mv_par09,"C") Object oEdSIM//Valid .T. Object oEdSIM
					@ 050,010 Get cVarBar Size 100,080 Picture "@!" Valid u_IMEIxModel(cVarBar, mv_par03,"I") .AND. u_Tecx011Grv(@cVarBar,@cTexto,@cVarSim,.F.) Object oEdBar
					// Processa({|| u_tecx11gr2(@cVarBar,@cTexto,@cVarSim,.F.,_nqtde,mv_par09,cprefixo,cgeraimei)}, "Aguarde...","Gerando IMEIs e validando Atendimento", .T. )
				Endif
			Endif
		Endif
		@ 065,010 Get cTexto  Size 250,115 MEMO Object oMemo when .F.
		@ 202,180 BUTTON "CONFIRMA     " 	Size 60,13 Action Processa({|| U_Tecx011C(.F.) })
		@ 217,180 BUTTON "CANCELA" 			Size 60,13 Action Iif(MSGYESNO("DESEJA REALMENTE CANCELAR? TODOS APARELHOS DEVERÃO SER APONTADOS NOVAMENTE."),Tecx011o(),Tecx011E(.F.))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria legenda de funcoes na tela                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Tecx011Leg()
		If centriage <> "S"
			Activate MsDialog oDlg Centered On Init oEdSIM:SetFocus()
		Else
			Activate MsDialog oDlg Centered On Init oEdmst:SetFocus()
		Endif
	Else
		u_seltriag(@cVarBar,@cTexto,@cVarSim,@cVarmst,.F.)
		U_Tecx011C(_lAuto)
	Endif
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa Filtro                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//DBCloseArea('ZZ4')
ZZ4->(DBCloseArea())
dbSelectArea('ZZ4')
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011A  ºAutor  ³ Edson              º Data ³  20/05/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para digitação das informações iniciais da entrada    º±±
±±º          ³ massiva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tecx011A()
Local _lOk := .F.

Private aPallet     := {"P1","P2","P3","P4","P5","P6","P7","P8","P9"}
Private cPallet     := aPallet[1]                        

// Carrega as variaveis
Pergunte('BARZZ4',.F.)
cNome  := Space(40)
copera := Space(50)
ctrans := Space(50)

cKit   := "N"
cCep   := Space(08)
mv_par01 := Space(06)
mv_par02 := Space(02)
mv_par03 := Space(15)
mv_par04 := Space(nTamNfe)
mv_par05 := Space(03)
mv_par10 := Space(12) //OS SAM
mv_par11 := Space(11) // COD. AUTORIZ.
mv_par12 := "C0022 "  // RECL. CLIENTE
mv_par13 := Space(06) //OPERADORA
mv_par14 := Space(06) //TRANSPORT
mv_par15 := "N" //ACESSORIO
mv_par16 := ""  // GARANTIA SIM OU NAO
mv_par17 := Space(20) // CONHECIMENTO/LACRE
mv_par18 := Space(nTamNfe) // NF de Compra
mv_par19 := CtoD("  /  / ")  // Data da NF de Compra
mv_par20 := Space(30) // Descrição do Produto
mv_par06 := 0.00000
_nqtde   := 0.0000
mv_par07 := "05"
mv_par09 := "ZZZ"
mv_par21 := Space(3) // Serie NF Compra
mv_par22 := Space(18) //CNPJ/CPF NF Compra
mv_par23 := Space(14) //CPF Cliente
mv_par24 := Space(nTamNfe) // NF de Troca
mv_par25 := Space(3) // Serie NF Troca
mv_par26 := CtoD("  /  / ") // Data da NF de Troca
mv_par27 := Space(18) //CNPJ/CPF NF Troca
@ 116,095 To 465,636 Dialog TelaEntra Title OemToAnsi("Informações da Entrada")
@ 002,009 To 039,256 Title OemToAnsi("Cliente")
@ 001,002 Say "CNPJ:" Size 16,8
@ 001,012 Say "Form Proprio:" Size 16,8
@ 001,023 Say OemToAnsi("Pallet:") Size 16,8
@ 002,002 Say "Cliente:" Size 18,8
@ 002,007 Say OemToAnsi("------") Size 13,8
@ 002,012 Say OemToAnsi("Nome:") Size 16,8
@ 042,009 To 080,257 Title OemToAnsi("Produto")
@ 004,002 Say OemToAnsi("Produto:") Size 22,8
@ 004,012 Say OemToAnsi("Descrição:") Size 27,8
@ 005,002 Say OemToAnsi("Valor Unitario:") Size 35,8
@ 005,012 Say OemToAnsi("Qtde:") Size 35,8
@ 083,009 To 155,258 Title OemToAnsi("Entrada")
@ 007,002 Say OemToAnsi("Tipo de Entrada:") Size 41,8
@ 007,012 Say OemToAnsi("Descrição:") Size 26,8
@ 008,002 Say OemToAnsi("Nota Fiscal:") Size 29,8
@ 008,012 Say OemToAnsi("Serie:") Size 14,8
@ 008,018 Say OemToAnsi("KIT S/N:") Size 13,8
@ 009,002 Say OemToAnsi("Operacao:") Size 41,8
@ 009,012 Say OemToAnsi("Descrição:") Size 26,8
@ 010,002 Say OemToAnsi("Transportadora:") Size 29,8
@ 010,012 Say OemToAnsi("Descrição:") Size 26,8
@ 011,002 Say OemToAnsi("CTRC\Lacre:") Size 26,8
//----------------------------------------------------------------------------
@ 011,033 Get cCNPJ Size 59,10 Picture "@R 99.999.999/9999-99" Valid(u_Tecx011B(cCNPJ,"1"))
//@ 011,111 Get cCEP Size 35,10 Picture "@R 99999-999" Valid(u_Tecx011B(cCEP,"7")) Object oCep
@ 001,017 COMBOBOX oCombo VAR cForm ITEMS aForm Size 30 ,50 When Iif(Alltrim(cForm)=aForm[2],.F.,.T.) ON CHANGE Iif(cForm==aForm[2],AtuNF(),.T.)
@ 001,025 COMBOBOX oPallet VAR cPallet ITEMS aPallet Size 30 ,50 
@ 024,033 Get mv_par01 When .F. Size 022,010
@ 024,069 Get mv_par02 When .F. Size 009,010
@ 024,122 Get cNome When .F. Size 123,010
@ 050,036 Get mv_par03 Size 050,010 Picture "@!" Valid(u_Tecx011B(mv_par03,"2") .AND. ExistCpo("SB1",mv_par03)) F3 'SB1'Object oCodProd //Colocado F3 Produto --> Edson Rodrigues - 23/06/10
@ 050,122 Get cDescr Size 124,010 When .F.
@ 063,050 Get mv_par06 Size 042,010 Picture "@E 999,999.99999" Valid(u_Tecx011B(mv_par06,"3")) Object oValUnit
@ 063,122 Get _nqtde Size 042,010 Picture "@E 9999.99999" When Iif( cgeraimei = '02',.T.,.F.) Valid(u_Tecx011B(_nqtde,"15")) Object oqtde
@ 090,055 Get mv_par07 Size 023,010 Picture "@!" Valid ExistCpo("SX5","Z1"+mv_par07) .AND. u_Tecx011B(mv_par07,"4") F3 'Z1' Object oTpEntr
@ 090,122 Get cEntr Size 125,010 When .F.
@ 103,055 Get mv_par04 Size 024,010 Picture "999999999" When Iif(Alltrim(cForm)=aForm[2],.F.,.T.) Valid(u_Tecx011B(mv_par04,"5")) Object oNota
@ 103,122 Get mv_par05 Size 010,010 Picture "!!!" When Iif(Alltrim(cForm)=aForm[2],.F.,.T.)
@ 103,163 Get cKit Size 005,010 Picture "!" Valid(u_Tecx011B(@cKit,"6")) Object oKIT
@ 115,055 Get mv_par09 Size 023,010 Picture "@!" Valid ExistCpo("ZZJ",mv_par09) .AND. u_Tecx011B(mv_par09,"9") F3 'ZZJ' Object operac
@ 115,122 Get copera Size 125,010 When .F.
@ 127,055 Get mv_par14 Size 024,010 Picture "@!" When Iif(SUBSTR(mv_par09,1,1)="N",.T.,.F.) Valid ExistCpo("SA4",mv_par14) .AND. u_Tecx011B(mv_par14,"14") F3 'SA4' Object otrans
@ 127,122 Get ctrans Size 125,010 When .F. Object olacre
@ 140,055 Get mv_par17 Size 125,010
@ 160, 184 BMPBUTTON TYPE 1 Action (_lOk := .T., Close(TelaEntra))
@ 160, 223 BMPBUTTON TYPE 2 Action (_lOk := .F., Close(TelaEntra))
Activate Dialog TelaEntra
If alltrim(cKit) == "S"
	mv_par08 := 1
ElseIf alltrim(cKit) == "N"
	mv_par08 := 2
Endif
Return(_lOk)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011B  ºAutor  ³ Edson              º Data ³  20/05/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetuar criticas na digitação de informacoes iniciais      º±±
±±º          ³ da entrada massiva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tecx011B(cChave,cQual)
Local cAlias  := ALIAS()
Local aAlias  := {"SB1","SA1"}
Local aAmb    := U_GETAMB(aAlias)
Local lRet    := .T.
SA1->(dbSetorder(3)) // A1_FILIAL + A1_CGC
SA1->(dbSeek(xFilial("SA1")+cCNPJ,.F.))
SB1->(dbSetorder(1)) // B1_FILIAL + B1_COD
SB1->(dbSeek(xFilial("SB1")+mv_par03,.F.))
SA4->(dbSetorder(1)) // A4_FILIAL + A4_COD
SA4->(dbSeek(xFilial("SA4")+mv_par14,.F.))
ZZJ->(dbSetorder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
ZZJ->(dbSeek(xFilial("ZZJ")+ALLTRIM(mv_par09),.F.))
If cQual == "1" //CNPJ
	If Empty(cChave)
		MsgBox("CNPJ deve ser digitado !","Informações Entrada","ALERT")
		lRet := .F.
	ElseIf !SA1->(dbSeek(xFilial("SA1")+cChave,.F.))
		MsgBox("Não existe cliente cadastrado com o CNPJ digitado, Favor verificar.","Informações Entrada","ALERT")
		lRet := .F.
	ElseIf !Cgc(cChave)
		MsgBox("CNPJ ou CPF  digitado invalido, Favor verificar.","Informações Entrada","ALERT")
		lRet := .F.
	Else
		mv_par01 := SA1->A1_Cod
		mv_par02 := SA1->A1_Loja
		cNome    := SA1->A1_Nome
		//oCep:SetFocus()
	Endif
ElseIf cQual == "2" //Produto
	If Empty(cChave)
		MsgBox("Codigo do produto deve ser digitado !","Informações Entrada","ALERT")
		lRet := .F.
	ElseIf !SB1->(dbSeek(xFilial("SB1")+cChave,.F.))
		MsgBox("Este produto não esta cadastrado, Favor verificar.","Informações Entrada","ALERT")
		lRet := .F.
	else
		cDescr := SB1->B1_Desc
		oValUnit:SetFocus()
	Endif
ElseIf cQual == "3" //Valor unitario
	If Empty(cChave)
		MsgBox("Valor unitario deve ser digitado !","Informações Entrada","ALERT")
		lRet := .F.
	else
		oTpEntr:SetFocus()
		lRet := .T.
	Endif
ElseIf cQual == "4" //Tipo de entrada
	SX5->(dbSeek("Z1"+mv_par07))
	If Empty(cChave)
		MsgBox("Tipo de entrada deve ser digitado !","Informações Entrada","ALERT")
		lRet := .F.
	ElseIf !ExistCpo("SX5","Z1"+mv_par07)
		MsgBox("Não foi encontrado este código de entrada no sistema, Favor verificar.","Informações Entrada","ALERT")
		lRet := .F.
	else
		cEntr := SX5->X5_DESCRI
		oNota:SetFocus()
	Endif
ElseIf cQual == "5" //Numero da nota fiscal
	If Empty(cChave)
		MsgBox("Numero da nota fiscal deve ser digitado !","Informações Entrada","ALERT")
			lRet := .F.
			//	ElseIf " "$cChave Altearado - Edson Rodrigues - 16/05/10
			// MsgBox("O numero da nota fiscal deve ser digitado por completo !","Informações Entrada","ALERT")
		ElseIf Len(alltrim(cChave)) < 6
			MsgBox("O numero da nota fiscal deve ser maior que 6 digitos !","Informações Entrada","ALERT")
			lRet := .F.
		Endif
ElseIf cQual == "6" //KIT
		If !cChave$"S.N"
			MsgBox("Digite S quando desejar formar um KIT ou N para processo normal.","Informações Entrada","ALERT")
			lRet := .F.
		Endif
ElseIf cQual == "7" //CEP
		If Empty(cChave)
			MsgBox("O CEP deve ser digitado !","Informações Entrada","ALERT")
			lRet := .F.
		ElseIf cChave#SA1->A1_CEP
			MsgBox("CEP do cliente foi digitado errado, Favor verificar.","Informações Entrada","ALERT")
			lRet := .F.
		else
			oCodProd:SetFocus()
		Endif
ElseIf cQual == "9"  .or.  cQual == "10"// Operacoes
		ZZJ->(dbSeek(xFILIAL("ZZJ")+cChave))
		If Empty(cChave)
			MsgBox("Operacao deve ser digitado !","Informações Entrada","ALERT")
			lRet := .F.
			
		ElseIf ZZJ->ZZJ_BLOQ = "S"
			MsgBox("Operacao bloqueada !","Informações Entrada","ALERT")
			lRet := .F.
			
		ElseIf !ExistCpo("ZZJ",cChave)
			MsgBox("Não foi encontrado este código de operacao no sistema, Favor verificar.","Informações Entrada","ALERT")
			lRet := .F.
			
			//ElseIf ExistCpo("SX5","WB"+mv_par09) .AND. mv_par09=="N05" //Alterado Edson Rodrigues
		ElseIf 	 !Empty(cChave)  .AND. cChave<>'ZZZ' .and. ExistCpo("ZZJ",cChave)
			cgeraimei :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(cChave), "ZZJ_IMEI")
			cvlclsam  :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(cChave), "ZZJ_VCLSAM")
			
			
			//Incluso validação conforme solicitação Carlos Rocha - 24/09/10
			If SA1->(dbSeek(xFilial("SA1")+cCNPJ)) .AND. cvlclsam='S'
				If Empty(SA1->A1_XCODSAM)
					MsgBox("Não está preenchido o codigo SAM no cadastro do Cliente/loja : "+SA1->A1_COD+"/"+SA1->A1_LOJA+".       O Cod. SAM deve ser Preenchido no Cad. Cliente para essa operação !","Informações Entrada","ALERT")
					lRet := .F.
				ELSE
					If	cgeraimei ="02"  .and. cQual == "9"
						copera := ZZJ->ZZJ_DESCRI
						oqtde:SetFocus()
					Else
						If  cQual == "9"
							copera := ZZJ->ZZJ_DESCRI
							otrans:SetFocus()
						Endif
					Endif
				Endif
			ELSE
				If	cgeraimei ="02"  .and.  cQual == "9"
					copera := ZZJ->ZZJ_DESCRI
					oqtde:SetFocus()
				Else
					If cQual == "9"
						copera := ZZJ->ZZJ_DESCRI
						otrans:SetFocus()
					Endif
				Endif
			Endif
		Endif
		
ElseIf cQual == "14" // Transportadora
		If !Empty(cChave)
			If !SA4->(dbSeek(xFilial("SA4")+cChave,.F.))
				MsgBox("Não foi encontrado este código da transportadora no sistema, Favor verificar.","Informações Entrada","ALERT")
				lRet := .F.
			else
				ctrans := SA4->A4_NOME
				olacre:SetFocus()
			Endif
		Endif
		
ElseIf cQual == "15" //
		If Empty(cChave) .and. cgeraimei="02"
			MsgBox("Para essa operacao, a quantidade deve ser digitada !","Informações Entrada","ALERT")
			lRet := .F.
		ElseIf Empty(cChave) .and. ! cgeraimei="02"
			oTrans:SetFocus()
			lRet := .T.
		ElseIf !Empty(cChave) .and.  cgeraimei="02"
			oTrans:SetFocus()
			lRet := .T.
		Endif
	Endif
	
	u_RestAmb( aamb )
	dbSelectArea( calias )

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011E  ºAutor  ³ Antonio L.F.Favero º Data ³  28/08/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fecha a janela de devolucao                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011E(_lAuto)
	_lFechEM := .T.
	
	If !_lAuto .or. centriage= "S" .or. lselqrytst
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011D  ºAutor  ³ Antonio L.F.Favero º Data ³  23/11/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca o campo Z1->CONFIRM com 'S'                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011D(WndDlg,_lAuto)

	Local _cQuery    := ""
	Local _cQrySZC   := ""
	Local _aSavNFE   := {}                                                    
	Local cAliasTop1 := ""
	Local cAliasSZC1 := ""
	Local _lrotaut   := .F.  //Edson Rodrigues
	Local _infaces   := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_INFACE")
	Local _cvlope    := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_TROPEN")  // variavel que indica se deve fazer validação de troca de operação
	
	_cVconre  := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ->ZZJ_VCONRE")   // variavel que indica se haverá busca do imei na importação inicial da SZP
	
	If  _lAuto
		_lrotaut:=.T.
	Endif
	
	If _infaces="S"
		
		dbSelectArea('SZC')  //Acessorios
		SZC->(dbSetorder(1))
		cAliasSZC1	:= GetNextAlias()
		_cQrySZC := " SELECT ZC_DOC, ZC_SERIE, ZC_FORNECE, ZC_LOJA, ZC_CODPRO,ZC_IMEI,ZC_STATUS "
		_cQrySZC += " FROM   "+RetSqlName("SZC") + " (nolock) "
		_cQrySZC += " WHERE ZC_FILIAL = "+xFilial("SZC")+" AND "
		_cQrySZC += "       ZC_DOC     = '"+ALLTRIM(mv_par04)+"' AND "
		_cQrySZC += "       ZC_SERIE   = '"+ALLTRIM(mv_par05)+"' AND "
		_cQrySZC += "       ZC_FORNECE = '"+ALLTRIM(mv_par01)+"' AND "
		_cQrySZC += "       ZC_LOJA    = '"+ALLTRIM(mv_par02)+"' AND "
		//_cQrySZC += "       ZC_CODPRO  = '"+ALLTRIM(mv_par03)+"' AND " desabilitado - Edson Rodrigues - 01/10/10
		_cQrySZC += "       ZC_STATUS = '0' AND "
		_cQrySZC += "       D_E_L_E_T_ = '' "
		_cQrySZC += " ORDER BY ZC_DOC, ZC_SERIE, ZC_FORNECE, ZC_LOJA, ZC_CODPRO,ZC_IMEI,ZC_STATUS "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySZC),cAliasSZC1,.T.,.T.)
		(cAliasSZC1)->(dbGoTop())
	Endif
	
	
	
	dbSelectArea('ZZ4')  //Entrada Massiva
	cAliasTop1	:= GetNextAlias()
	
	_cQuery := " SELECT ZZ4_IMEI  "
	_cQuery += " FROM   "+RetSqlName("ZZ4") + " (nolock) "
	_cQuery += " WHERE  ZZ4_FILIAL = '"+xFilial('ZZ4')+"' AND "
	_cQuery += "        ZZ4_STATUS = '1' AND "
	_cQuery += "        D_E_L_E_T_ = ''  AND "
	If _cvlope <> "S"  .or. !lselqrytst
		_cQuery += "        ZZ4_OPEBGH = '"+ALLTRIM(mv_par09)+"'  AND "
	Endif
	_cQuery += "        SUBSTRING(ZZ4_EMUSER,1,13) = '"+Substr(cUserName,1,13)+"' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery),cAliasTop1,.T.,.T.)
	
	(cAliasTop1)->(dbGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha a Janela                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Tecx011E(_lAuto)
	
	ProcRegua((cAliasTop1)->(RECCOUNT()))
	
	While !(cAliasTop1)->(EOF())
		
		ZZ4->(dbSetorder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
		If ZZ4->(dbSeek(xFilial("ZZ4") + (cAliasTop1)->ZZ4_IMEI + "1"))
			
			While ZZ4->(!eof()) .and. ZZ4->ZZ4_IMEI == (cAliasTop1)->ZZ4_IMEI .and. ZZ4->ZZ4_STATUS == "1"  // Adicionado para solucao da gravacao do item reincidente. (11/05/05) Nicoletti
				
				If Upper(alltrim(substr(ZZ4->ZZ4_EMUSER,1,30))) == Upper(alltrim(substr(cUserName,1,30))) // Correcao pro Protheus 11. Nao funcionava quando o cUserName era inferior a 13 caracteres.
														
					Reclock('ZZ4',.F.)
					ZZ4->ZZ4_STATUS  := '2'
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se a NFE ja foi gerada e se foi gerada com formulario proprio  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					/*
					If VerFPro()
						ZZ4->ZZ4_STATUS := '3'
					ELSE
						ZZ4->ZZ4_STATUS  := '2'
					Endif
					*/
					
					MsUnLock('ZZ4')
					IncProc()
				Endif
				ZZ4->(DbSkip())
				
			EndDo
			
			If _cVconre == "S"    // Validação de Importação anterior - Luis Carlos
				dbSelectArea("SZP")
				dbSetorder(2)
				If dbSeek(xFilial("SZP")+trim((cAliasTop1)->ZZ4_IMEI))
					Reclock('SZP',.F.)
					SZP->ZP_ENTRMAS := "S"
					msUnlock("SZP")
				Endif
				dbSelectArea(cAliasTop1)
			Endif
			
		Endif
		(cAliasTop1)->(DBSkip())
		
	EndDo
	
	If _infaces="S"
		ProcRegua((cAliasSZC1)->(RECCOUNT()))
		While !(cAliasSZC1)->(EOF())
			If SZC->(dbSeek(xFilial("SZC") + ((cAliasSZC1)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO))))
				While SZC->(!eof()) .and. SZC->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO) == ((cAliasSZC1)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO))
					If SZC->ZC_IMEI=(cAliasSZC1)->ZC_IMEI .AND. SZC->ZC_STATUS='0'
						Reclock('SZC',.F.)
						SZC->ZC_STATUS  := '1'
						MsUnLock('SZC')
					Endif
					SZC->(DBSkip())
				EndDo
			Endif
			IncProc()
			(cAliasSZC1)->(DBSkip())
		EndDo
	Endif
	
	If !_lAuto
		WndDlg:End()
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa funcao para a criacao de Ordens de Servico (ANTIGA OSNEXTEL)    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	u_tecax013()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alerta usuario para gerar a NFE atraves da rotina de Documento Entrada  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Aviso('Nota Fiscal de Entrada','Utilize a rotina de "Documento de Entrada" para cadastrar a NFE.',{"OK"})
	_aSavNFE := GetArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a rotina de Documento de Entrada                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//MATA103() // Abre tela de digitacao de NFE.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura o ambiente                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(_aSavNFE)
	dbSelectArea(cAliasTop1)
	DBCloseArea()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011C  ºAutor  ³Microsiga           º Data ³  09/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tecx011C(_lAuto)

	Local nConta     := 0
	Local ChaveNF    := ""
	Local ChaveSZC   := ""
	Local cProd      := ""
	Local nProd      := 0
	Local cacess     := ""
	Local nacess     := 0
	Local nTotalNf   := 0.00
	Local cConf      := ""
	Local nTotal     := 0
	Local nTotaces   := 0
	Local _cQuery2   := ""
	Local _cQrySZC   := ""
	Local cAliasTop2 := ""
	Local cAliasSZC  := ""
	Local oDlgConf
	Local _infaces   := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_INFACE")
	Local _cvlope    := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_TROPEN")  // variavel que indica se deve fazer validação de troca de operação
	
	oFnt1  := TFont():New("Arial",18,22,,.T.,,,,.T.,.F.)
	oFnt2  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
	oFnt3  := TFont():New("Courier New",08,12,,.F.,,,,.F.,.F.)
	
	
	
	dbSelectArea('SB1')
	SB1->(dbSetorder(1)) //B1_FILIAL+B1_COD
	dbSelectArea('SX5')
	SX5->(dbSetorder(1))
	dbSelectArea('ZZ4')
	ZZ4->(dbSetorder(3)) //ZZ4_FILIAL+ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODPRO
	ZZ4->(dbGoTop())
	
	cAliasTop2	:= GetNextAlias()
	
	// Incluido comandos abaixos.
	_cQuery2 := " SELECT ZZ4_NFENR, ZZ4_NFESER, ZZ4_CODPRO, ZZ4_VLRUNI, ZZ4_EMUSER "
	_cQuery2 += " FROM   "+RetSqlName("ZZ4") + " (nolock) "
	_cQuery2 += " WHERE ZZ4_FILIAL = "+xFilial("ZZ4")+" AND "
	_cQuery2 += "       ZZ4_STATUS = '1' AND "
	_cQuery2 += "       D_E_L_E_T_ = ''  AND "
	_cQuery2 += "       SUBSTRING(ZZ4_EMUSER,1,13) = '"+Substr(cUserName,1,13)+"'  "
	If _cvlope <> "S"  .or. !lselqrytst
		_cQuery2 += "     AND ZZ4_OPEBGH = '"+ALLTRIM(mv_par09)+"'"
	Endif
//	If _lAuto
//		_cQuery2 += "     AND 1=2"
//	EndIf
	// TCQUERY _cQuery2 NEW ALIAS "ZZ4F"
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery2),cAliasTop2,.T.,.T.)
	While !((cAliasTop2)->(EOF())) //ZZ4F->(EOF())
		nTotal++
		If (cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER) <> ChaveNF
			ChaveNF:=(cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER) // ZZ4F->(ZZ4_NFENR+ZZ4_NFESER)
			cProd:=(cAliasTop2)->ZZ4_CODPRO
			nProd:=0
			cConf+='Nota: '+ (cAliasTop2)->ZZ4_NFENR
			cConf+='  Serie: '+ (cAliasTop2)->ZZ4_NFESER+LFRC
			cConf+='   Quant  Codigo          Descrição                        '+LFRC
		Endif
		
		If  ((cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER) == ChaveNF  .and.  (cAliasTop2)->ZZ4_CODPRO==cProd)
			nProd++
		else
			SB1->(dbSeek(xFilial('SB1')+cProd))
			cConf+=Transform(nProd,'@E 999999')+'    '+cProd+' '+Alltrim(SB1->B1_DESC)+LFRC
			nProd:=1
			cProd:= (cAliasTop2)->ZZ4_CODPRO
		Endif
		
		nTotalNF+= (cAliasTop2)->ZZ4_VLRUNI

		(cAliasTop2)->(DBSkip())
		
		If ((cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER)<>ChaveNF) .or.;
			((cAliasTop2)->ZZ4_EMUSER<>cUserName) .or. (cAliasTop2)->(EOF())
			SB1->(dbSeek(xFilial('SB1')+cProd))
			cConf+=Transform(nProd,'@E 999999')+'    '+cProd+' '+SB1->B1_DESC+LFRC
			nProd:=0
			cProd:=(cAliasTop2)->ZZ4_CODPRO
			cConf+=LFRC+'Total da Nota:'+Transform(nTotalNF,'@E 9,999,999.99')+LFRC+LFRC
			nTotalNf:= 0.00
		Endif
	EndDo

	If _infaces="S"
		cAliasSZC := GetNextAlias()
		
		// Incluso Query para contar quantos acessorios foram escaneados e apresentar para o usuário no
		// final da confirmação total - Edson Rodrigues - 09/09/10
		_cQrySZC := " SELECT ZC_DOC, ZC_SERIE, ZC_FORNECE, ZC_LOJA, ZC_CODPRO,ZC_TPACESS "
		_cQrySZC += " FROM   "+RetSqlName("SZC") + " (nolock) "
		_cQrySZC += " WHERE ZC_FILIAL = "+xFilial("SZC")+" AND "
		_cQrySZC += "       ZC_DOC     = '"+ALLTRIM(mv_par04)+"' AND "
		_cQrySZC += "       ZC_SERIE   = '"+ALLTRIM(mv_par05)+"' AND "
		_cQrySZC += "       ZC_FORNECE = '"+ALLTRIM(mv_par01)+"' AND "
		_cQrySZC += "       ZC_LOJA    = '"+ALLTRIM(mv_par02)+"' AND "
		//   _cQrySZC += "       ZC_CODPRO  = '"+ALLTRIM(mv_par03)+"' AND " desabilidado - Edson Rodrigues - 01/10/10
		_cQrySZC += "       ZC_STATUS = '0' AND "
		_cQrySZC += "       D_E_L_E_T_ = '' "
		_cQrySZC += " ORDER BY ZC_TPACESS    "
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySZC),cAliasSZC,.T.,.T.)
		
		
		While !((cAliasSZC)->(EOF())) //ZZ4F->(EOF())
			
			If ((cAliasSZC)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA)) <> ChaveSZC
				ChaveSZC:=(cAliasSZC)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA)
				cacess  :=(cAliasSZC)->ZC_TPACESS
				nacess  :=0
				cConf+='Acessorios lidos para : '+LFRC
				cConf+='Nota: '+ ALLTRIM((cAliasSZC)->ZC_DOC)+' Serie : '+ (cAliasSZC)->ZC_SERIE+LFRC
				cConf+='  Quant Cod.Acess  Descrição               '+LFRC
			Endif
			
			nTotaces++
			
			If  ((cAliasSZC)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA) == ChaveSZC  .and.  (cAliasSZC)->ZC_TPACESS==cacess)
				nacess++
			Else
				SX5->(dbSeek(xFilial("SX5") + "Z5" + cacess))
				cConf+=Transform(nacess,'@E 999999')+'    '+cacess+'   '+Alltrim(SX5->X5_DESCRI)+LFRC
				nacess:=1
				cacess:= (cAliasSZC)->ZC_TPACESS
			Endif
			
			(cAliasSZC)->(DBSkip())
			
			If ((cAliasSZC)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA)) <> ChaveSZC .or.;
				(cAliasSZC)->(EOF())
				SX5->(dbSeek(xFilial("SX5") + "Z5" + cacess))
				cConf+=Transform(nacess,'@E 999999')+'    '+cacess+'   '+Alltrim(SX5->X5_DESCRI)+LFRC
				nacess:=0
				cacess:= (cAliasSZC)->ZC_TPACESS
				cConf+=LFRC+'Total Acessorio Nota:'+Transform(nTotaces,'@E 9,999,999.99')+LFRC+LFRC
				nTotaces:= 0.00
			Endif
		EndDo
	Endif
	
	
	
	
	dbSelectArea(cAliasTop2)
	DbCloseArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Janela de Conferência                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTotal == 0
		If !_lAuto
			Aviso("Massiva","Não existem itens para conferência!",{"OK"})
		EndIf
	Else
		If AllTrim(mv_par07) == "12"
			lCont := .T.
			
			While lCont
				oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
				@ 0,0 To 200,300 Dialog oDlg2 Title "Massiva"
				oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlg2)
				@ 20,010 Say oV1 var "Informe o fornecedor:" Of oDlg2 FONT oFnt1 Pixel Size 150,010 COLOR CLR_BLUE
				@ 40,010 Get cForn Size 60,080 Picture "@!" F3 'FOR'
				@ 40,080 Get cLoja Size 20,080 Picture "@!"
				@ 80,085 BMPBUTTON TYPE 1 Action (Iif(ExistCpo("SA2", cForn + cLoja), lCont := .F., lCont := .T.), oDlg2:End())
				@ 80,120 BMPBUTTON TYPE 2 Action (lCont := .F., oDlg2:End())
				Activate MsDialog oDlg2 Centered
			EndDo
		Endif
		
		If  !_lAuto //Edson Rodrigues 28/11/07
			@ 0,0 To 400,420 Dialog oDlgConf Title "Confirmar Dados"
			@ 05,005 Say oV1 var Alltrim(cUserName)+',' Of oDlgConf FONT oFnt2 Pixel Size 150,010
			@ 15,005 Say oV2 var "confirme os itens abaixo listados." Of oDlgConf FONT oFnt2 Pixel Size 150,012
			@ 25,005 Say oV3 var "Importante: A responsabilidade dos dados é sua." Of oDlgConf FONT oFnt2 Pixel Size 150,012 COLOR CLR_RED
			@ 40,005 Get cConf Size 195,115 MEMO Object oMemoConf
			@ 160,130 BMPBUTTON TYPE 1 Action Processa({|| Tecx011D(oDlgConf,_lAuto) })
			@ 160,165 BMPBUTTON TYPE 2 Action Tecx011F(oDlgConf)
			//@ 160,165 BMPBUTTON TYPE 2 Action (oDlgConf:End()) - Desabilitado Edson Rodrigues - 15/04/10
			oMemoConf:oFont:=oFnt3
			Activate MsDialog oDlgConf Centered
		Else
			Tecx011D(oDlgConf,_lAuto) //Edson Rodrigues
		Endif
	Endif

	If _lAuto
		_lFechEM := .T.
	EndIf

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011F  ºAutor  ³ Antonio L.F. Faveroº Data ³  20/10/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apagar os registros scanneados                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011F(oDlgAux)

//oDlgConf:End() Altera Edson Rodrigues - 14/04/10
oDlgAux:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011GRVºAutor  ³ Antonio L.F.Favero º Data ³  27/03/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava registro no ZZ4 e atualiza Memo                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tecx011Grv(cCodBar,Memo,cVARSIM,_lAuto,nvez,cVarmst,nbounce)

Local nVlZ1        := 0.00
Local lResult      := .T.
Local tMemo        := ""
Local _cCodPro     := mv_par03
Local _nVlrUnit    := mv_par06
Local _ctipentr    := mv_par07
Local _lvalsza     := .F.
Local _clote       :=""
Local _cdpyim      :=""
Local _cgvsos      :=""
Local _cLocal      :=""
Local _nVez        := 0  //Iif(_lauto,nvez,0)
Local _cVarmst     := Iif(_lauto,cVarmst,"")
Local _nbounce     := 0  //Iif(_lauto,val(nbounce),0)
Local _cITEMD1     := ""
Local _cfornsrf    := ""
Local _cljforsrf   := ""
Local _cultoper    := ""
Local cvlopent     := ""                 	
Local ctravbou     := ""
Local nqtdboun     :=  0
Local lPrtetq      := GETNEWPAR("MV_X011IMP",.T.)
Local lgrvsza      := .F.
Local lvldoper     := .F.
Local _dultsaid    := Date()
Local coperatu     := ""
Local _nQualiVez   := 0
Local _ltrocope    :=.F.
Local _cZZ4_CODREP := ""
Local lVlvInc		:= .F.

ZZJ->(dbSetorder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
// If !_lAuto
If ZZJ->(dbSeek(xFilial("ZZJ")+ALLTRIM(mv_par09),.F.))
	_clab      := ZZJ->ZZJ_LAB
	cOpe       := ZZJ->ZZJ_OPERA
	_loperpro  := Iif(_lAuto,.F.,U_VLDPROD(cOpe,_clab))
	_ccalcgar  := ZZJ->ZZJ_CALGAR // Variavel que diz se a operacao calcula a garantia sim ou nao - Edson Rodrigues 17/04/10
	_cdadoSZA  := ZZJ->ZZJ_DADSZA // Variavel que diz se a opercao busca/inclui dados no SZA - Edson Rodrigues 17/04/10
	cinftrans  := ZZJ->ZZJ_INFTCM  // variavel que informa o Transcode - Processo Mclaims - Edson Rodrigues 15/04/10
	ctransfix  := ZZJ->ZZJ_TRAFIX  // variavel que diz se Transcode e fixo,sim, nao ou condicional - Processo Mclaims - Edson Rodrigues 15/04/10
	cinfNFcom  := ZZJ->ZZJ_INFNFC  // variavel que diz se a na operacao pode ser ou nao informado Nf compra cliente ou fornecedor outros - Edson Rodrigues 15/04/10
	//	cinfNFtro  := ZZJ->ZZJ_INFNFT  // variavel que diz se a na operacao pode ser ou nao informado Nf Troca cliente ou fornecedor outros - Hudson Santos 06/07/2013
	//após cração do campo trocar pela linha de cima.
	cinfNFtro  := Iif(ZZJ->ZZJ_OPERA=="N09","S","N")
	cinfcaut   := ZZJ->ZZJ_INFCAU  // variavel que diz se informa dados da NF compra ou cod. autorizada se ZZJ_TRAFIX=NAO e ZZJ_INFTCM=SIM - Edson Rodrigues 16/04/10
	cinfaces   := ZZJ->ZZJ_INFACE  // variavel que diz se a operacao informará acessório na entrada massiva - Edson Rodrigues 16/04/10
	cvlopent   := ZZJ->ZZJ_TROPEN  // variavel que indica se deve fazer validação de troca de operação
	ctravbou   := ZZJ->ZZJ_TRABEN  // variavel que indica se trava aparelhos bounce na entrada
	nqtdboun   := ZZJ->ZZJ_QTDBEN  // variavel que indica a quantidade de dias para travar o aparelho bounce na entrada massiva
	_cVconre  := ZZJ->ZZJ_VCONRE   // variavel que indica se haverá busca do imei na importação inicial da SZP
	lVlvInc	  := ZZJ->ZZJ_VLVINC == 'S'
Else
	If !_lAuto
		ApMsgInfo("Não foi encontrado a operacao cadastrada para o IMEI "+alltrim(cCodBar)+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
		Return()
	Endif
Endif
// Endif
// So executa a validacao se o codigo de barra estiver preenchido	Return
If Empty(cCodBar)
	Return
Endif

// Validacao do algoritmo do IMEI - claudia - 21/01/2010
If FINDFUNCTION("U_CHKIMEI")
	If !U_CHKIMEI(cCodBar)
		tMemo := '------ Digito do IMEI Invalido --------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
		Return
	Endif
Endif
// ------ FIM VALIDACAO DO  ALGORITMO DO IMEI

// Alterado por M.Munhoz - ERP PLUS - 24/09/07
If "'" $ cCodBar .or. "'" $ cVarSim .or. '"' $ cCodBar .or. '"' $ cVarSim
	tMemo := '------Proibido informar aspas simples ou duplas no IMEI ou Carcaçà.--------'+LFRC+LFRC
	Memo  := tMemo+Memo
	cCodBar:=Space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
	If ValType(oDlg)=="O"
		Close(oDlg)
	Endif
	Return
Endif

If !_lAuto .and. !Empty(cCodBar)
	
	_lErro := .F.
	If Len(AllTrim(cCodBar)) <> nTcodpr .and. !__cUserID $ GetMV('MV_XIMEI15')    //soraia
		If Len(AllTrim(cCodBar)) > nTcodpr
			tMemo := '------Codigo de Barras Inválido - '+AllTrim(cCodBar)+'! MAIS de 15 caracteres.--------'+LFRC+LFRC
		ElseIf Len(AllTrim(cCodBar)) < nTcodpr
			tMemo := '------Codigo de Barras Inválido - '+AllTrim(cCodBar)+'! MENOS de 15 caracteres.--------'+LFRC+LFRC
		Endif
		_lErro := .T.
		Memo  := tMemo+Memo
	Endif
	
	// Validacao do numero de serie (Carcaca) informado pra Nextel
	// Alterado If abaixo - Edson Rodrigues
	//If left(cCodBar,4) $ "0006/0017"
	If _ccalcgar='S'
		
		If alltrim(cCodBar) == alltrim(cVarSim)
			_lErro := .T.
			tMemo := '------O número de série não pode ser igual ao IMEI. Favor fazer a leitura do número de série novamente.--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		ElseIf left(cCodBar,4) == left(cVarSim,4)
			_lErro := .T.
			tMemo := '------Os 4 primeiros digitos do número de série deve ser diferente do IMEI. Favor fazer a leitura do número de série novamente.--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		ElseIf Len(alltrim(cVarSim)) <> 10
			_lErro := .T.
			tMemo := '------O número de série deve conter 10 digitos. Favor fazer a leitura do número de série novamente.--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		ElseIf Space(1) $ left(cVarSim,10)
			_lErro := .T.
			tMemo := '------O número de série não pode conter espaço. Favor fazer a leitura do número de série novamente.--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		Endif
		
	Endif
	
	//Validação de Vinculo - Thomas Galvão - 28/08/2012
	//-------------------------------------------------
	If lVlvInc &&ZZJ_VLVINC == 'S'
		_lErro := u_WSINTCCENT(cCodBar,@tMemo)
		Memo   := tMemo+Memo
	Endif
	//-------------------------------------------------
		
	If _lErro
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
		Return
	Endif
	
Endif

If _lAuto
	If _cdadoSZA $ "S"
		lgrvsza := .T.
	EndIf
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se gerou arq. Entrada Excel e verifica se IMEI consta ou nao no arquivo SZA.|
	//| Valido apenas para clientes UPS / Nextel Operacao Refurbish- Edson Rodrigues 19/09/08|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Alterado If abaixo - Edson Rodrigues 17/04/10
	//If alltrim(mv_par01) $ "000146/036057/110762/000016/000680"  // Codigos de clientes UPS **** Adicionado Luiz Ferreira 26/02/09
	// Incluso condicao C=Condicional para validar o cliente no caso de retorno de Refurbis-Bounce - Solicitação Enio em 20/06/11 - Edson Rodrigues - 22/06/11

 	// Alterado para atender novos Clientes Nextel CD - Uiran Almeida 29.01.2015 
	//If (_cdadoSZA='S')  .or. (_cdadoSZA='C' .and. alltrim(mv_par01) $ "000016/000680") 
	If (_cdadoSZA='S')  .or. (_cdadoSZA='C' .and. alltrim(mv_par01) $ Alltrim(cNexSpRj))
		lgrvsza:=.T.
		//	If alltrim(mv_par01) $ "000146/036057/110762/000016"  // Codigos de clientes UPS
/*
		dbSelectArea("SZA")
		SZA->(dbSetorder(1)) // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
		//		If SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05))
		If SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + cCodBar))
*/
		_aAreaSZA := SZA->(getarea())
		dbSelectArea("SZA")
		SZA->(dbSetorder(4)) // ZA_FILIAL + ZA_IMEI + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_STATUS	 (indice criado apenas com NR da nota fiscal pq ocorre muito erro de digitacao da serie).
		//If SZA->(dbSeek(xFilial("SZA") + left(cCodBar,15) + mv_par01 + mv_par02 + mv_par04)) 
		If SZA->(dbSeek(xFilial("SZA") + cCodBar + mv_par01 + mv_par02 + mv_par04)) 
			If SZA->ZA_STATUS $ 'I'
				//			_lverza := Tecx011M(cCODBAR)
				//			If _lverza
				MsgBox("O IMEI: "+cCODBAR+" ref NF: "+mv_par04+" apresentou inconsistência no arquivo SZA/Excel. Separe o Aparelho","ALERT")
				tMemo += "IMEI: "+cCODBAR+" INCONSISTENTE. NF/SERIE -> "+mv_par04+"/"+mv_par05+" "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
				If ValType(oDlg)=="O"
					Close(oDlg)
				Endif
				Return
			ElseIf SB1->(!dbSeek(xFilial("SB1") + SZA->ZA_CODPRO))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida produto nao cadastrado - M.Munhoz - ERPPLUS - 29/10/2008                    |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("O produto " + alltrim(SZA->ZA_CODPRO) + " correspondente ao IMEI: "+cCODBAR+" não está cadastrado no sistema. Providencei o cadastramento deste produto e faça a entrada massiva novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com produto " + alltrim(SZA->ZA_CODPRO) + " nao cadastrado! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
				If ValType(oDlg)=="O"
					Close(oDlg)
				Endif
				Return

				/* Retirada a validação, pois engessa a entrada massiva - Edson Rodrigues 04/10/10
				ElseIf SB1->(dbSeek(xFilial("SB1") + SZA->ZA_CODPRO)) .AND. !ALLTRIM(SZA->ZA_CODPRO)==alltrim(_cCodPro)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida produto SZA diferente do produto da entrada massiva - Edson Rodrigues - 30/09/2010                    |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("O produto " + alltrim(SZA->ZA_CODPRO) + " é diferente do produto que está entrando : "+_cCodPro+". Corrija o produto nos parâmetros F9 e faça a leitura do IMEI novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com produto " + alltrim(SZA->ZA_CODPRO) + " diferente do produto a entrar: "+_cCodPro+"  ! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=Replicate(' ',20)
				Close(oDlg)
				Return

				ElseIf SB1->(dbSeek(xFilial("SB1") + SZA->ZA_CODPRO)) .AND. SZA->ZA_PRECO <> _nVlrUnit

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida preço SZA diferente do produto da entrada massiva - Edson Rodrigues - 30/09/2010                    |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("O preco: "+Transform(_nVlrUnit,'@E 999,999.99999')+" do produto : " + alltrim(SZA->ZA_CODPRO) + " esta diferente do arquivo SZA/Excel : "+Transform(SZA->ZA_PRECO,'@E 999,999.99999')+". Corrija o preco nos parâmetros F9 e faça a leitura do IMEI novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com produto " + alltrim(SZA->ZA_CODPRO) + " tem preco diferente do produto a entrar: "+_cCodPro+"  ! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=Replicate(' ',20)
				Close(oDlg)
				Return
				*/

			ElseIf SB1->(dbSeek(xFilial("SB1") + SZA->ZA_CODPRO)) .and. (SB1->B1_LOCALIZ == "S" .or. SB1->B1_RASTRO $ "LS" .or. SB1->B1_MSBLQL == "1")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida produto com controle de endereco/lote ou bloqueado - M.Munhoz - ERPPLUS - 29/10/2008 |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("O produto " + alltrim(SZA->ZA_CODPRO) + " correspondente ao IMEI: "+cCODBAR+" possui controle de endereço ou de lote ou está bloqueado. Providencei a correção deste produto e faça a entrada massiva novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com produto " + alltrim(SZA->ZA_CODPRO) + " com controle de endereço ou lote ou bloqueado! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
				If ValType(oDlg)=="O"
					Close(oDlg)
				Endif
				Return
				//Incluso validacao de Operacao - Edson Rodrigues - 17/08/10
			ElseIf ALLTRIM(SZA->ZA_OPERBGH) <> ALLTRIM(mv_par09)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida se operacao cadastrada no arquivo entrada excel é igual a operacao informada na Entr. Massiva |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("A operacao " + alltrim(SZA->ZA_OPERBGH) + " correspondente ao IMEI: "+cCODBAR+" nao é igual a operacao informada : "+ALLTRIM(mv_par09)+". Providencei a correção da operacao no arq. Entr. Excell e faça a entrada massiva novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com operacao " + alltrim(SZA->ZA_OPERBGH) + " é diferente da Operacao informada : "+ALLTRIM(mv_par09)+"! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
				If ValType(oDlg)=="O"
					Close(oDlg)
				Endif
				Return
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida entrada do SZA e Imprime etiqueta de Entrada - M.Munhoz - ERPPLUS - 29/10/2008  |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Reclock("SZA",.F.)
				SZA->ZA_STATUS := 'V'
				MsUnlock()

				_cCodPro   := SZA->ZA_CODPRO
				_nVlrUnit  := SZA->ZA_PRECO
				_lvalsza  := .T.
				_clote    :=SZA->ZA_LOTEIRL
				_cdpyim   :=Iif(SUBSTR(SZA->ZA_CODDPY,1,3)="DPY",SZA->ZA_CODDPY,"")
				_cgvsos   :=SZA->ZA_OSGVS
				_cLocal   :=SZA->ZA_LOCAL

				_aEtiqEntr := {}

				// nao usaod neste processo
				//If lPrtetq
				//	If MsgYesNo('Deseja imprimir a etiqueta de entrada? A impressora termica está conectada a este computador e pronta para impressão?')
				//		aAdd(_aEtiqEntr, {cCodBar, "", "", mv_par04, mv_par05, SZA->ZA_CODPRO, ;
				//		dDataBase, 0, mv_par01, mv_par02, "" })
				//		u_EtqMass2(_aEtiqEntr,"TECAX011")
				//	Endif
				//Endif
				//	_aEtiqEntr := {}
			Endif
		Else
			If _ctipentr<> '04'  //.AND. mv_par09 <> "S03" --> Alterado Edson Rodrigues 17/04/10
				MsgBox("O IMEI: "+cCODBAR+" Nao foi encontrado no arq. excel ref NF : "+mv_par04+" !","Separe o Aparelho","ALERT")
				tMemo += "IMEI: "+cCODBAR+"  NAO ENCONTRADO EXCEL: NF/SERIE -> "+mv_par04+"/"+mv_par05+" "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
				If ValType(oDlg)=="O"
					Close(oDlg)
				Endif
				Return
			Endif
		Endif
		restarea(_aAreaSZA)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//Verifica se o produto possui controle de endereço e bloqueia //Edson Rodrigues - 11/12/09 Ä
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	If SB1->(dbSeek(xFilial("SB1") + _cCodPro))
		If (SB1->B1_LOCALIZ == "S")
			MsgBox("O Produto: "+alltrim(_cCodPro)+" com controle de Localizacao. Rotina não preparada para produtos com controle de localização !","Produtos com controle de localização","ALERT")
			tMemo += "O Produto: "+alltrim(_cCodPro)+" com controle de Localizacao - Rotina não preparada para produtos com controle de localização "+LFRC
			Memo:=tMemo+Memo
			cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
			If ValType(oDlg)=="O"
				Close(oDlg)
			Endif
			Return
		Endif
	ELSE
		//Acrescentado esse "ELSE" --Edson Rodrigues - 21/07/10
		MsgBox("O Produto: "+alltrim(_cCodPro)+" nao foi encontrado no cadastro de produto - Favor cadastrar !","Produtos nao cadastrado","ALERT")
		tMemo += "O Produto: "+alltrim(_cCodPro)+"  nao foi encontrado no cadastro de produto - Favor cadastrar "+LFRC
		Memo:=tMemo+Memo
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
		Return
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se base instalada ja existe                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("AA3")
	dbSetorder(4)
	If dbSeek(xFilial("AA3") + Space(8) + _cCodPro + cCodBar)
		tMemo:='------Ja Existe Base Instalada!------'+LFRC+LFRC
		Memo:=tMemo+Memo
	Endif
	
Endif


If !_lauto .or. centriage = "S" .or. lselqrytst
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se IMEI ja sofreu entrada massiva                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ZZ4->(dbSetorder(2)) //ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI+ZZ4_STATUS
	//	ZZ4->(dbGoTop())
	//If ZZ4->(dbSeek(xFilial('ZZ4')+mv_par01+mv_par02+_cCodPro+cCODBAR)) // Alterado esse If para amarrar a validação por IMEI 22/01/10
	ZZ4->(dbSetorder(1))
	If ZZ4->(dbSeek(xFilial('ZZ4')+cCODBAR)) .or. ZZ4->(dbSeek("02"+cCODBAR))
		If ZZ4->ZZ4_STATUS <> '9' // NFS gerada
			
			tMemo   := '------Esse celular já foi registrado--------'+LFRC+LFRC
			Memo    := tMemo+Memo
			
			If centriage = "S" .or. lselqrytst
				cCodBar := space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
				If ValType(oDlg)=="O"
					Close(oDlg)
				Endif
				Return
			ELSE
				If ValType(oDlg)=="O"
					Close(oDlg)
				Endif
				Return(.F.)
			Endif
		else
		    //Procura IMEI na filial 02 - Luciano - Delta
		    _aOsBounce := {}    
		    _dultsaid  := CTOD(" / / ")
		    ZZ4->(dbSetorder(1))
			If ZZ4->(dbSeek("02"+cCODBAR))
				While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == "02" .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar)
					If ZZ4->ZZ4_STATUS=='9'
						
						//Tratamento para não considerar registros com o mesmo numero de OS - Diego Fernandes - 11/09/2013
						If Ascan(_aOsBounce, ZZ4->ZZ4_OS) == 0
						
							AADD(_aOsBounce, ZZ4->ZZ4_OS)
						
							_nVez++
							_nQualiVez++
							//_cultoper :=Iif(Empty(ZZ4->ZZ4_OPEANT),ZZ4->ZZ4_OPEBGH,ZZ4->ZZ4_OPEANT)														
						EndIf                                                                        
						_cultoper :=ZZ4->ZZ4_OPEBGH
						_dultsaid :=ZZ4->ZZ4_NFSDT
													
					Endif
					ZZ4->(dbSkip())
				EndDo
			Endif
			
			
			//Procura IMEI na filial corrente - Luciano - Delta
		    ZZ4->(dbSetorder(1))
			If ZZ4->(dbSeek(xFilial('ZZ4')+cCODBAR))
				While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar)
				
				//Comentado essa validação por cliente e produto, pois conforme conversado com Fernando Luciano, bounce somente por IMEI - Edson Rodrigues 07/11/11
				//If mv_par01 == ZZ4->ZZ4_CODCLI .and. mv_par02 == ZZ4->ZZ4_LOJA .and. alltrim(_cCodPro) == alltrim(ZZ4->ZZ4_CODPRO)
				
				//Endif
				
					If  ZZ4->ZZ4_STATUS=='9'					
						//Tratamento para não considerar registros com o mesmo numero de OS - Diego Fernandes - 11/09/2013
						If Ascan(_aOsBounce, ZZ4->ZZ4_OS) == 0
						
							AADD(_aOsBounce, ZZ4->ZZ4_OS)
							
					    	_nVez++
						    _nQualiVez++
						    //_cultoper :=Iif(Empty(ZZ4->ZZ4_OPEANT),ZZ4->ZZ4_OPEBGH,ZZ4->ZZ4_OPEANT)
						EndIf                                                                        
					    _cultoper :=ZZ4->ZZ4_OPEBGH
					    
					    //Como o indice e IMEI+OS na filial 06 o numero da OS iniciou do zero
					    //mas registros gerados com as transferencias de filiais 
					    //gravou OS com numero elevado - Diego.					     					    
						If ZZ4->ZZ4_NFSDT > _dultsaid			    
						    _dultsaid :=ZZ4->ZZ4_NFSDT
						EndIf						    
												    
				    Endif
					ZZ4->(dbSkip())
				EndDo
			Endif
		Endif
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a OS esta em atendimento                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !_lAuto .and. !Tecx011G(_cCodPro,cCodBar)
	tMemo := '------Esse aparelho esta em atendimento--------'+LFRC+LFRC
	Memo  := tMemo+Memo
	cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
	If ValType(oDlg)=="O"
		Close(oDlg)
	Endif
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o aparelho é SCRAP - Edson Rodrigues - 23/09/10             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !_lAuto .and. Tecx011p(_cCodPro,cCodBar)
	If MSGYESNO("ESSE APARELHO FOI ENCERRADO COMO SCRAP NA ULTIMA VEZ QUE ESTEVE NA BGH. INFORME AO SUPERVISOR DO LABORATÓRIO URGENTE !!. DESEJA FAZER A ENTRADA MASSIVA DELE  ASSIM MESMO ?.")
		tMemo := '------Esse aparelho é SCRAP..!!!--------'+LFRC+LFRC
		Memo  := tMemo+Memo
	ELSE
		tMemo := '------Esse aparelho é SCRAP..!!!--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
		Return
	Endif
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atendimento do chamado 14101, inclusão do alerta            ³
	//³quando o produto foi encerrado como scrap na última entrada ³
	//³D.FERNANDES - 07/10/2013                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lAuto
		If Tecx011p(_cCodPro,cCodBar)
			MsgInfo("IMEI: "+ cCodBar +"ESSE APARELHO FOI ENCERRADO COMO SCRAP NA ULTIMA VEZ QUE ESTEVE NA BGH. INFORME AO SUPERVISOR DO LABORATÓRIO URGENTE !!")
			tMemo := '------Esse aparelho é SCRAP..!!!--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		EndIf
	EndIf		
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a ultima operacao que o aparelho entrou e abre tela para            ³
//³ alteracao da operacao se o usuário assim quiser - Edson Rodrigues - 27/08/11 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(_dultsaid)
	_dultsaid := MsDate()	
EndIf

ndias:=dDataBase - _dultsaid
_nbounce:=ndias

If cvlopent="S" .and. _nQualiVez > 0 .and. !Empty(_cultoper) .and. alltrim(_cultoper)<>ALLTRIM(mv_par09) .and. nqtdboun > 0
	If ndias <= nqtdboun
		//coperatu :=alltrim(_cultoper)
		
		
		If MSGYESNO("ESSE APARELHO ESTA RETORNANDO PELA "+STRZERO(_nQualiVez+1,2)+"- BOUNCE menor ou igual a : "+STRZERO(nqtdboun,3)+" dias, E SUA ULTIMA OPERAÇÃO FOI A "+_cultoper+". QUER TROCAR POR OUTRA OPERAÇÃO DIFERENTE DA ATUAL : "+ALLTRIM(mv_par09)+" ? ")
			coperatu:=u_tropera(ALLTRIM(mv_par09))
			_ltrocope:=.T.
			If coperatu==ALLTRIM(mv_par09)
				_ltrocope:=.F.
				If !MSGYESNO("VOCE NAO ALTEROU A OPERACAO ATUAL : "+ALLTRIM(mv_par09)+" , CONFIRMA ? ")
					coperatu:=u_tropera(ALLTRIM(mv_par09))
					_ltrocope:=.T.
				Endif
			Endif
		Endif
	Endif
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a operacao valida bounce e se For bounce menor que os dias       ³
//³ parametrizado na operacao solicita ao usuário a separacao do mesmo           ³
//³ Edson Rodrigues - 09/09/11                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ctravbou="S" .and. nqtdboun > 0 .and. _nQualiVez > 0 .and. centriage <> "S" .and. !lselqrytst
	
	If ndias <= nqtdboun
		If _ltrocope
			MsgBox("Foi Trocado a operação atual de "+ALLTRIM(mv_par09)+" para a "+ALLTRIM(_cultoper)+" e O IMEI: "+alltrim(cCodBar)+" é BOUNCE menor ou igual a : "+STRZERO(nqtdboun,3)+" dias. Favor confirmar a seguir e separa-lo !","IMEI BOUNCE menor que :"+STRZERO(nqtdboun,3),"ALERT")
		ELSE
			MsgBox("O IMEI: "+alltrim(cCodBar)+" é BOUNCE menor ou igual a : "+STRZERO(nqtdboun,3)+" dias. Favor confirmar a seguir e separa-lo !","IMEI BOUNCE menor que :"+STRZERO(nqtdboun,3),"ALERT")
		Endif
		U_APBOUNCE(nqtdboun,cCodBar)
	Endif
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz Verificacacoes para os novos Processo de Entrada Sony Ericson-      |
//| Refurbish - Verifica se exite a NF de compra e produto digitado         |
//³ Edson Rodrigues 03/11/09                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If _ctipentr='04'  .AND. mv_par09="S03" --> Alterado If - Edson Rodrigues - 17/04/10
If  _loperpro
	_cfornsrf  := SUBSTR(ALLTRIM(GETMV('MV_XFORSRF')),1,6)
	_cljforsrf := SUBSTR(ALLTRIM(GETMV('MV_XFORSRF')),7,2)
	
	
	// D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD
	If !vernfcom(mv_par04,mv_par05,_cfornsrf,_cljforsrf,_cCodPro,@_nVlrUnit,'1',cCodBar)
		tMemo := '------Nao Encontrada Nfe de compra para Esse aparelho--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
		Return
	Endif
	If !vernfcom(mv_par04,mv_par05,_cfornsrf,_cljforsrf,_cCodPro,@_nVlrUnit,'2',cCodBar)
		tMemo := '------Valor unitario diferente do digitado na Nfe de compra para Esse aparelho--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
		Return
	Endif
	
	If !vernfcom(mv_par04,mv_par05,_cfornsrf,_cljforsrf,_cCodPro,@_nVlrUnit,'3',cCodBar)
		tMemo := '------Produto a reformar nao cadastrado--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
		Return
	Endif
Endif



If _cVconre == "S"    // Validação de Importação anterior - Luis Carlos
	dbSelectArea("SZP")
	dbSetorder(2)         
	If dbSeek(xFilial("SZP")+trim(cCodBar))
		_cZZ4_CODREP := SZP->ZP_CONDREP
	else
		alert ("Número Serial não encontrado na tabela de Pré Lançamento")
		_cZZ4_CODREP := ""
	EndIf   
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz Verificacacoes para os novos Processo de Entrada Nextel-            |
//| para obter informacoes para o Relatorio MCLAIMS                         |
//³ Edson Rodrigues 01/05/09                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//If mv_par07="04" .and.  mv_par09="N01"  //alterado - Edson Rodrigues - 25/11/09



//If  mv_par09="N01" --> Alterado Edson Rodrigues - 17/04/10
//If ctransfix="C" - Retirado daqui e passado essa validação pra baixo - Edson Rodrigues - 26/11/10
//	mv_par16:=U_Vergaran(cVarSim,mv_par09,cCodBar)
//	mv_par13:="NEX"
//EndIf // Fechado esse If para atender todas as condicoes abaixo :

//ElseIf mv_par07<>"04" .and.  mv_par09 $ "N02/N03/N04"--> Alterado Edson Rodrigues - 17/04/10

//ElseIf ctransfix='N' .AND. (cinfNFcom='S' .or. cinfaces='S') .and. !_loperpro --> alteraodo Edson Rodrigues - 22/11/10


Begin Transaction

//******************** Entra somente se não For rotina de Produção, ex: S03 - Sony Ericson Refurbish ******************************

If !_lAuto .AND. !_loperpro
	If ctransfix="C" // Grava variavel de Transportadora Motorola - Edson Rodrigues - 26/11/10
		mv_par13:="NEX"
		lgrvsza:=.T.
	Endif

	//******************** Tratamento quando tem Nota fiscal de Compra / Outros dados da NF de Remessa e ou Codigo de Operadora  **********************************//
	If cinfNFcom='S' .and. !lselqrytst
		_lnfcomp :=Iif(MSGYESNO("Possui a Nota Fiscal de COMPRA"+Iif(cinfNFtro=="S"," e/ou a Nota Fiscal de TROCA","")+" do Aparelho ?"),.T.,.F.)
		_lnfTroca:=Iif(cinfNFtro=="S",_lnfcomp,.F.)
	ElseIf cinfNFcom='O' .and. !lselqrytst // Obriga a digitação dos dados da NF Compra - C. Rocha - 12/01/11
		_lnfcomp :=.T.
		If cinfNFtro=="S"
			_lnfTroca:=Iif(MSGYESNO("Possui a Nota Fiscal de TROCA do Aparelho ?"),.T.,.F.)
		Else
			_lnfTroca:= .F.
		EndIf
	Else
		_lnfcomp:=.F.
	Endif

	If _lnfcomp   //Se informa Nota de Compra, entao Calcula a garantia conforme digitacao da NF Compra e Data - Edson Rodrigues - 26/11/10
		TecaX11N(_lnfcomp,_lnfTroca,cinfcaut)
		lgrvsza:=.T.
		
		//ElseIf !_lnfcomp .AND. mv_par09 = "N03" --> Alterado Edson Rodrigues - 17/04/10
		// Se Nao tem NF de compra mas informa dados da nota de remessa ou codigo da autorizada - Edson Rodrigues - 26/11/10
	ElseIf !_lnfcomp .AND. cinfcaut='S' .and. !lselqrytst
		TecaX11N(_lnfcomp,_lnfTroca,cinfcaut)
		lgrvsza:=.T.
	Endif
	//********************************************************************************//

	// Comentado pois alterei a lógica acima - Edson Rodrigues - 26/11/10
	//ElseIf !_lnfcomp .AND. !mv_par09 = "N03"--> Alterado Edson Rodrigues - 17/04/10
	//ElseIf !_lnfcomp .AND. cinfcaut='N' .and. _ccalcgar='S'  //.and. _ccalcgar='N'//alterado 14/06/10 - Edson Rodrigues
	//mv_par16:=U_Vergaran(cVarSim,mv_par09,cCodBar)
	//Endif

	//**********************Tratamento para calculo de garantia quando não tem nota fiscal de compra e calcula garantia - Edson Rodrigues - 26/11/10 ********************//

	If !_lnfcomp .and. _ccalcgar='S'
		mv_par16:=U_Vergaran(cVarSim,mv_par09,cCodBar)
		lgrvsza :=.T.
		If Empty(mv_par16)
			tMemo := '------Carcaça Invalida--------'+LFRC+LFRC
			Memo  := tMemo+Memo
			cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
			If !_lAuto
				If ValType(oDlg)=="O"
					Close(oDlg)
				Endif
			Endif
			Return
		Endif
	Endif
	//********************************************************************************//
	
	
	
	//***************************************Tratamento para quando a operacao informa acessorios ***************//
	//If !mv_par09 $ "N02/N04" --> Alterado Edson Rodrigues - 17/04/10
	If  cinfaces='S'.and. !lselqrytst
		_lacesso:=Iif(MSGYESNO("O aparelho esta acompanhado de acessorios ?"),.T.,.F.)
	Else
		_lacesso:=.F.
	Endif
	
	If _lacesso
		_lFechCS:= .F.
		lgrvsza := .T.
		_cSepEnt:= Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_SEPENT")//Incluido conforme solicitação do Edson 12/06/2012
		_actacess  := {}		
		u_tecax11m(cCodBar,_cSepEnt,_cCodPro)
		mv_par15:="S"
	Else
		mv_par15:="N"
	Endif
	//********************************************************************************//
	
Endif
//******************************************************************************************************************************************************//


//If mv_par09 $ "N01/N02/N03/N04"
//Alterado esse IF, pois estava muito confuso  de entreder, trocado pela variável lágica lgrvsza - Edson Rodrigues - 26/10/10
//If (cinftrans='S' .AND. _cdadoSZA='S') .OR. (ctransfix='N' .AND. cinfNFcom='S' .and. !_loperpro .and. _lnfcomp) .or. (ctransfix='N' .AND. cinfNFcom='S' .and. !_loperpro .and. cinfcaut='S' .and. _ccalcgar='S')

If Empty(mv_par16) .AND. _ccalcgar='S'
	mv_par16:=U_Vergaran(cVarSim,mv_par09,cCodBar)
	If Empty(mv_par16)
		tMemo := '------Carcaça Invalida--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
		If !_lAuto
			If ValType(oDlg)=="O"
				Close(oDlg)
			Endif
		Endif
		Return
	Endif
Endif

If lgrvsza

	_aAreaSZA := SZA->(getarea())
	SZA->(dbSetorder(4)) // ZA_FILIAL + ZA_IMEI + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_STATUS	 (indice criado apenas com NR da nota fiscal pq ocorre muito erro de digitacao da serie).
	//If !SZA->(dbSeek(xFilial("SZA") + left(cCodBar,15) + mv_par01 + mv_par02 + mv_par04)) .and. !Empty(cCodBar)
	//	If !SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + cCodBar)) .and. !Empty(cCodBar)
	If !SZA->(dbSeek(xFilial("SZA") + cCodBar + mv_par01 + mv_par02 + mv_par04)) .and. !Empty(cCodBar)
		Reclock("SZA",.T.)
		SZA->ZA_FILIAL  := xFilial("SZA")
		SZA->ZA_CLIENTE := mv_par01
		SZA->ZA_LOJA    := mv_par02
		SZA->ZA_NFISCAL := PadL(AllTrim(mv_par04),Iif(Len(AllTrim(mv_par04)) <= 6,6,9),"0")
		SZA->ZA_SERIE   := mv_par05
		SZA->ZA_EMISSAO := dDataBase
		SZA->ZA_CODPRO  := _cCodPro
		SZA->ZA_PRECO   := _nVlrUnit
		SZA->ZA_DATA    := dDataBase
		SZA->ZA_IMEI    := cCodBar
		SZA->ZA_STATUS  := "V"
		SZA->ZA_Local   := _clocal
		SZA->ZA_NFCOMPR := mv_par18
		SZA->ZA_DTNFCOM := mv_par19
		SZA->ZA_CODRECL := mv_par12
		SZA->ZA_CODAUTO := mv_par11
		SZA->ZA_CODTRAN := mv_par14
		SZA->ZA_TRACKIN := mv_par17
		SZA->ZA_OSAUTOR := mv_par10
		SZA->ZA_INFACES := mv_par15
		SZA->ZA_CTRLACR := mv_par17
		SZA->ZA_CPFCLI 	:= mv_par23
		SZA->ZA_CNPJNFC := mv_par22
		SZA->ZA_SERNFC 	:= mv_par21
		SZA->ZA_NFTROCA	:= mv_par24
		SZA->ZA_SERNFTR	:= mv_par25
		SZA->ZA_DTNFTRO	:= mv_par26
		SZA->ZA_CNPJNFT	:= mv_par27

		If !Empty(_cSpc)
			SZA->ZA_SPC		:= _cSpc
		Endif
		MsUnlock()
	Else
		Reclock("SZA",.F.)
		SZA->ZA_FILIAL  := xFilial("SZA")
		SZA->ZA_SERIE   := mv_par05 // Esse campo eh alterado pq ocorre muito erro de digitacao. Assim corrige eventuais erros anteriores.
		SZA->ZA_CODPRO  := _cCodPro // Esse campo eh alterado pq ocorre muito erro de digitacao. Assim corrige eventuais erros anteriores.
		SZA->ZA_NFCOMPR := mv_par18
		SZA->ZA_DTNFCOM := mv_par19
		SZA->ZA_CODRECL := mv_par12
		SZA->ZA_CODAUTO := mv_par11
		SZA->ZA_CODTRAN := mv_par14
		SZA->ZA_TRACKIN := mv_par17
		SZA->ZA_OSAUTOR := mv_par10
		SZA->ZA_INFACES := mv_par15
		SZA->ZA_CTRLACR := mv_par17
		SZA->ZA_CPFCLI  := mv_par23
		SZA->ZA_CNPJNFC := mv_par22
		SZA->ZA_SERNFC  := mv_par21
		SZA->ZA_NFTROCA	:= mv_par24
		SZA->ZA_NFTROCA	:= mv_par25
		SZA->ZA_DTNFTRO	:= mv_par26
		SZA->ZA_CNPJNFT	:= mv_par27
		If !Empty(_cSpc)
			SZA->ZA_SPC		:= _cSpc
		Endif
		MsUnlock()
	Endif
	restarea(_aAreaSZA)
Endif          

Reclock('ZZ4',.T.)
ZZ4->ZZ4_FILIAL 	:= xFilial('ZZ4')
ZZ4->ZZ4_CODCLI 	:= mv_par01 //Cliente?
ZZ4->ZZ4_LOJA   	:= mv_par02 //Loja?
ZZ4->ZZ4_IMEI 		:= cCodBar
ZZ4->ZZ4_CARCAC		:= cVarSIM //SIM/Caraça
ZZ4->ZZ4_CODPRO 	:= _cCodPro //Produto? (mv_par03)
ZZ4->ZZ4_GRPPRO		:= Posicione("SB1",1,xFilial("SB1") + _cCodPro, "B1_GRUPO")
ZZ4->ZZ4_VLRUNI		:= _nVlrUnit //Valor do Produto (mv_par06)
ZZ4->ZZ4_OPER   	:= mv_par07 //Operacao
ZZ4->ZZ4_KIT    	:= Iif(mv_par08==1,"S","N")  // Nicoletti
ZZ4->ZZ4_OS     	:= Space(6)
ZZ4->ZZ4_EMUSER   	:= cUserName //Nome do usuario que gerou registro
ZZ4->ZZ4_EMDT   	:= Date() //Log
ZZ4->ZZ4_EMHR   	:= Time() //Log
ZZ4->ZZ4_NFENR    	:= mv_par04   //Indica a Nota Fiscal de Entrada
ZZ4->ZZ4_NFESER  	:= mv_par05 //Indica a Nota Fiscal de Entrada
ZZ4->ZZ4_STATUS  	:= "1" //Indica que eh uma Entrada Massiva que esta sendo apontada
ZZ4->ZZ4_LOTIRL     := _clote
ZZ4->ZZ4_DPYIME     := _cdpyim
ZZ4->ZZ4_GVSOS      := _cgvsos
ZZ4->ZZ4_Local      := _clocal
ZZ4->ZZ4_NUMVEZ     := _nVez+1  //Iif(_nbounce > 0 .and. _nQualiVez > 0 .and. _nVez==0,_nQualiVez+1,_nVez+1)
ZZ4->ZZ4_OPEBGH     := Iif(Empty(coperatu),mv_par09,coperatu)
ZZ4->ZZ4_GARANT     := mv_par16 //Iif(Empty(mv_par16) .AND. _ccalcgar='S',U_Vergaran(cVarSim,mv_par09,cCodBar),mv_par16)   //Iif(!_lAuto,Iif(Empty(mv_par16) .AND. _ccalcgar='S',U_Vergaran(cVarSim,mv_par09),mv_par16),mv_par16)
ZZ4->ZZ4_OSAUTO     := mv_par10
ZZ4->ZZ4_ITEMD1     := _cITEMD1
ZZ4->ZZ4_ASCRAP     := cscrap
ZZ4->ZZ4_ETQMEM     := _cVarmst
ZZ4->ZZ4_BOUNCE     := _nbounce
ZZ4->ZZ4_GARMCL     := CalcGarMCL(CCODBAR) // M.Munhoz - Ticket 3211 - alterado em 05/03/2012    
ZZ4->ZZ4_CODREP	    := _cZZ4_CODREP
ZZ4->ZZ4_FORMUL		:= Iif(cForm==aForm[2],"S","N") 
ZZ4->ZZ4_PALLET		:= cPallet
MsUnLock('ZZ4')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB1->(dbSeek(xFilial('SB1')+_cCodPro))
If !_lAuto .or. (_lAuto .and. centriage = "S") .or. (_lAuto .and.lselqrytst)
	tMemo := 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
	tMemo += 'Produto: '+_cCodPro+' Descricao: '+SB1->B1_DESC+LFRC
	tMemo += 'SN: '+cCodBar+'   SIM/Carcaça: '+cVarSIM+LFRC
	tMemo += 'NF: '+mv_par04+' Série: '+mv_par05+' Valor: '+Transform(_nVlrUnit,'@E 999,999.99999')+LFRC
	If _nVez > 0
		tMemo += 'Este aparelho já sofreu '+alltrim(str(_nVez))+' entrada(s) anterior(es) a esta.'+LFRC
	Endif
	_nVez := 0
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se eh SWAP ANTECIPADO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !_lAuto
	_aAreaSC6 := SC6->(GetArea())
	SC6->(DBOrderNickName('SC6XIMEOLD'))//SC6->(dbSetorder(10))// C6_FILIAL + C6_XIMEOLD + C6_NUM + C6_ITEM
	If SC6->(dbSeek(xFilial("SC6") + cCodBar))
		ApMsgInfo("Este IMEI refere-se a aparelho em SWAP ANTECIPADO. ","SWAP ANTECIPADO!")
		tMemo += "SWAP ANTECIPADO: PV/ITEM -> "+SC6->C6_NUM+"/"+SC6->C6_ITEM+" == NF/SERIE -> "+SC6->C6_NOTA+"/"+SC6->C6_SERIE+LFRC
		Reclock("ZZ4",.F.)
		ZZ4->ZZ4_SWANT := SC6->C6_NUM+SC6->C6_ITEM
		MsUnlock()
	Endif
	RestArea(_aAreaSC6)
Endif

//Incluso para gravar dados da NF de compra para operacoes de producao - Edson Rorigues 22/04/10
If _loperpro
	vernfcom(mv_par04,mv_par05,_cfornsrf,_cljforsrf,_cCodPro,@_nVlrUnit,'4',cCodBar)
	_dSaida:=CtoD(" / / ")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o BOUNCE                                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//SD2->(dbSetorder(10)) // D2_FILIAL + D2_NUMSERI + DToS(D2_EMISSAO) - Edson Rodrigues - 02/10/10
	SD2->(DBOrderNickName('D2NUMSEMIS')) //D2_FILIAL + D2_NUMSERI + DToS(D2_EMISSAO)
	If SD2->(dbSeek(xFilial("SD2") + cCodBar))
		While SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_NUMSERI == cCodBar .and. SD2->D2_EMISSAO < dDataBase
			_dSaida := SD2->D2_EMISSAO
			SD2->(dbSkip())
		EndDo
	Endif
	If !Empty(_dSaida)
		Reclock("ZZ4",.F.)
		ZZ4->ZZ4_BOUNCE := dDataBase - _dSaida
		ZZ4->ZZ4_ULTSAI := _dSaida
		MsUnlock()
	Endif
Endif

//Incluso para gravar dados da NF de compra para operacoes de producao - Edson Rorigues 10/01/12
If Alltrim(ZZ4->ZZ4_GARANT) == 'N' .And. AllTrim(ZZ4->ZZ4_CODPRO) $ _cSpr .and. !_lspc433
	U_CONSGA09(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
Endif

End Transaction 

If !_lAuto .or. centriage = "S" .or.lselqrytst
	tMemo += LFRC
	Memo  := tMemo + Memo
	If !_lAuto
		If ValType(oDlg)=="O"
			Close(oDlg)
		Endif
	Endif
Endif

cCodBar  := space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
cVarSIM  := Replicate(' ',25)
mv_par18 := Space(nTamNfe) // NF de Compra
mv_par19 := CtoD("  /  / ")  // Data da NF de Compra
mv_par21 := Space(3) // Serie NF Compra
mv_par22 := Space(18) //CNPJ/CPF NF Compra
mv_par23 := Space(14) //CPF Cliente
mv_par12 := "C0022 "  // RECL. CLIENTE
mv_par13 := Space(06) //OPERADORA
mv_par14 := Space(06) //TRANSPORT
mv_par15 := "N" //ACESSORIO
mv_par16 := ""  // GARANTIA SIM OU NAO
mv_par17 := Space(20) // CONHECIMENTO/LACRE
mv_par24 := Space(9) // NF de Troca
mv_par25 := Space(3) // Serie NF Troca
mv_par26 := CtoD("  /  / ") // Data da NF de Troca
mv_par27 := Space(18) //CNPJ/CPF NF Troca

UltReg   := .T.

Return(lResult)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011G  ºAutor  ³Antonio L.F. Favero º Data ³  13/02/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe algum atendimento em andamento          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011G(cProAT,cCodBarAT)

Local cQryAtend
Local lResult

cQryAtend:=' Select COUNT(*) TOTAL '                      //Conta quantos registros
cQryAtend+=' FROM '+RetSQLName('AB7')+' AB7 (nolock) '    //Ordem de Servico +' AB7'
cQryAtend+=" WHERE AB7_FILIAL='"+xFilial('AB7')+"' and "  //Filtra por filial
cQryAtend+=" AB7.D_E_L_E_T_<>'*' AND"                     //Filtra deletados
cQryAtend+=" (AB7_TIPO='1' OR "                           //Filtra OS
cQryAtend+=" AB7_TIPO='3' ) AND"                          //Filtra Em Atendimento
cQryAtend+=" AB7_CODPRO='"+cProAT+"' AND"                 //Filtra Produto
cQryAtend+=" AB7_NUMSER='"+cCodBarAT+"'"                  //Filtra Numero de Serie
TCQUERY cQryAtend NEW ALIAS "QRYAtend"
If QRYAtend->TOTAL==0
	lResult:=.T.
else
	lResult:=.F.
Endif
dbSelectArea('QRYAtend')
QRYAtend->(dbCloseArea())
Return(lResult)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011P  ºAutor  Edson Rodrigues      º Data ³  23/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica ultimo atendimento e se a fase de encerramento é  º±±
±±           ³ SCRAP                                                      ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011p(cProAT,cCodBarAT)

Local cQryAtend
Local lResult:=.F.
Local _clab  :=""
cscrap :="N"

ZZJ->(dbSetorder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB


If Select("QRYAtend") > 0
	QRYAtend->(dbCloseArea())
Endif

cQryAtend:=" SELECT ZZ4_FILIAL, ZZ4_OS,ZZ4_FASATU,ZZ4_SETATU,ZZ4_OPEBGH "
cQryAtend+=" FROM "+RetSQLName('ZZ4')+" A (nolock) "
cQryAtend+=" INNER JOIN "
cQryAtend+="       (SELECT MAX(R_E_C_N_O_) RECNO FROM "+RetSQLName('ZZ4')+" C (NOLOCK) "
cQryAtend+="        WHERE ZZ4_IMEI='"+cCodBarAT+"' AND D_E_L_E_T_='' AND ZZ4_STATUS='9') AS B "
cQryAtend+=" ON A.R_E_C_N_O_ = B.RECNO "
cQryAtend+=" WHERE ZZ4_IMEI='"+cCodBarAT+"' AND D_E_L_E_T_='' AND ZZ4_STATUS='9' "

TCQUERY cQryAtend NEW ALIAS "QRYAtend"

If Select("QRYAtend") > 0
	QRYAtend->(dbGoTop())
	While QRYAtend->(!eof()) .and. !Empty(QRYAtend->ZZ4_FASATU)
		
		If ZZJ->(dbSeek(xFilial("ZZJ")+QRYAtend->ZZ4_OPEBGH))
			_clab:=ZZJ->ZZJ_LAB
		ElseIf  ZZJ->(dbSeek(xFilial("ZZJ")+ALLTRIM(mv_par09)))
			_clab:=ZZJ->ZZJ_LAB
		Endif
		
		dbSelectArea('ZZ1')  //Cadastro de Fases
		If ZZ1->(dbSeek(xFilial("ZZ1")+_clab+QRYAtend->ZZ4_SETATU+QRYAtend->ZZ4_FASATU))
			If ZZ1->ZZ1_SCRAP='S'
				lResult:=.T.
				cscrap :="S"
			Endif
			
		ELSE
			dbSelectArea('ZZ3')  //Apontamento de Fases
			If ZZ3->(dbSeek(QRYAtend->ZZ4_FILIAL + cCodBarAT + QRYAtend->ZZ4_OS))
				_cfase:=ZZ3->ZZ3_FASE1
				_csetor:=ZZ3->ZZ3_CODSET
				                               
				//Ajuste no fonte conforme ajuste no fonte AJBOUNCE realizado pelo Edson - Diego / 12/09/2013
				While (ZZ3->ZZ3_FILIAL == QRYAtend->ZZ4_FILIAL) .And. (ZZ3->ZZ3_IMEI == cCodBarAT) .And. (left(ZZ3->ZZ3_NUMOS,6) == left(QRYAtend->ZZ4_OS,6))
					If ZZ3->ZZ3_STATUS=='1'  .AND. ZZ3_ENCOS='S' .AND. ZZ3_ESTORN<>'S'
						If ZZ1->(dbSeek(xFilial("ZZ1") +_clab+ _csetor+_cfase))
							If ZZ1->ZZ1_SCRAP=="S"
								lResult:=.T.
								cscrap :="S"
							Endif
						Endif
					Endif
					ZZ3->(Dbskip())
				EndDo
			Endif
		Endif
		QRYAtend->(Dbskip())
	EndDo
	QRYAtend->(dbCloseArea())
Endif

Return(lResult)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011I  ºAutor  ³Antonio L.F. Favero º Data ³  23/10/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui os itens scaneados                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011I(cTexto)

Private cCadastro := "Entrada Massiva"
Private cAlias := "ZZ4"
Private aRotina := { 	{'Pesquisar' , "AxPesqui"  , 0,1},;   //"Pesquisar"
{'Visualizar', "AxVisual"  , 0,2},;   //"Visualizar"
{"Excluir"   , "u_Tecx011J(@cTexto)" , 0,5},;
{'Legenda'   , "u_Tecx011H" , 0,5}}      //"Legenda"
// Revisar esta legenda de cores
Private aCores :=  { 	{'ZZ4_STATUS <> "1"' , 'BR_VERDE'   },; //Sucesso
{'ZZ4_STATUS == "1"' , 'BR_VERMELHO'}}  //Não Sucesso

dbSelectArea("ZZ4") //Entrada Massiva
ZZ4->(dbSetorder(1))
mBrowse( 6,1,22,75,cAlias, , , , , ,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011J  ºAutor  ³Antonio L.F. Favero º Data ³  27/03/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui ultimo registro no ZZ4 e atualiza Memo              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tecx011J(Memo)
Local _cinface:="N"
//Local _aAreaSZA := SZA->(getarea())

If ZZ4->ZZ4_STATUS > '1'
	Aviso('Excluir','Não é permitida a exclusão de itens já confirmados!',{'OK'})
else
	_cinface:=Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH, "ZZJ_INFACE")
	SB1->(dbSeek(xFilial('SB1')+ZZ4->ZZ4_CODPRO))
	
	tMemo:='---------------ITEM CANCELADO-----------------------'+LFRC
	tMemo+='Cliente: '+ZZ4->ZZ4_CODCLI+' Loja: '+ZZ4->ZZ4_LOJA+LFRC
	tMemo+='Produto: '+ZZ4->ZZ4_CODPRO+' Descricao: '+ALLTRIM(SB1->B1_DESC)+LFRC
	tMemo+='SN: '+ZZ4->ZZ4_IMEI+'   SIM/Carcaça: '+ZZ4->ZZ4_CARCAC+LFRC
	tMemo+='    NF: '+ZZ4->ZZ4_NFENR+' Série: '+ZZ4->ZZ4_NFESER+' Valor: '+Transform(ZZ4->ZZ4_VLRUNI,'@E 99,999.99')+LFRC
	tMemo+='----------------------------------------------------'+LFRC+LFRC
	Memo:=tMemo+Memo
	
	If _cinface="S"
		dbSelectArea('SZC')  //Acessorios
		SZC->(dbSetorder(1))
		
		If SZC->(dbSeek(xFilial("SZC") + ZZ4->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO)))
			While SZC->(!eof()) .and. SZC->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO) == ZZ4->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO)
				If SZC->ZC_STATUS == '0' .AND. ALLTRIM(SZC->ZC_IMEI ) == ALLTRIM(ZZ4->ZZ4_IMEI)
					_cdestpac:=SX5->(dbSeek(xFilial("SX5") + "Z5" +SZC->ZC_TPACESS))
					
					tMemo:='---------------ACESSORIOS CANCELADO-----------------------'+LFRC
					tMemo+='ACESSORIO: '+SZC->ZC_ACESS+' Descricao: '+ALLTRIM(SZC->ZC_DESACES)+LFRC
					tMemo+='TIPO ACES: '+SZC->ZC_TPACESS+'-'+alltrim(_cdestpac)+' QTDE: '+STRZERO(SZC->ZC_QUANT,2)+LFRC
					tMemo+='----------------------------------------------------'+LFRC+LFRC
					Memo:=tMemo+Memo
					
					
					Reclock("SZC",.F.)
					dbDelete()
					MsUnlock()
				Endif
				
				SZC->(DBSKIP())
			EndDo
		Endif
	Endif
	
	If !Empty(ZZ4->ZZ4_ETQMEM)
		_cUpdZZO := " UPDATE "+RETSQLNAME("ZZO")+" SET ZZO_STATUS = '1' "
		_cUpdZZO += " WHERE ZZO_FILIAL = '"+xFilial("ZZO")+"'    AND "
		_cUpdZZO += "       ZZO_NUMCX  = '"+ZZ4->ZZ4_ETQMEM+"'  AND "
		_cUpdZZO += "       ZZO_STATUS = '2' AND ZZO_SEGREG<>'S' AND "
		_cUpdZZO += "       ZZO_IMEI='"+ZZ4->ZZ4_IMEI+"' AND D_E_L_E_T_ = ''"
		
		tcSqlExec( _cUpdZZO)
		TCREFRESH(RETSQLNAME("ZZO"))
		
	Endif
/*
	SZA->(dbSetorder(1))  // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
	If SZA->(dbSeek(xFilial("SZA") + ZZ4->ZZ4_CLIENTE + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI))
		Reclock("SZA",.F.)
		dbDelete()
		MsUnlock()
	Endif
*/
	Reclock('ZZ4',.F.)
	Delete RECORD ZZ4->(RecNo())
	MsUnLock('ZZ4')
	
Endif

//restarea(_aAreaSZA)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Tecx011K ºAutor  ³ Hudson de Souza Santos    ³  07/08/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Compara as datas e retorna "S" para garantia Sim e "N" paraº±±
±±º          ³ garantia Não.                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam     ³ cOperacao - Operação.                                      º±±
±±º          ³  dEntrada - Data da entrada massiva.                       º±±
±±º          ³ dNFComTro - Data para comparação com entrada massiva.      º±±
±±º          ³     nQual - Informa data a ser comparada. 1=Compra 2=Troca º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tecx011K(cOperacao, dEntrada, dNFComTro, nQual)
Local _aAreaZZJ := ZZJ->(GetArea())
Local __cRetMCL := Iif(dNFComTro==CTOD("01/01/1900"),"","N")
Local nPerGrt := 0
Local _cQryMCL := ""    
Local nDias := 10 // SOlução para adicionar 10 dias além do período em meses descrito no cadastro de operação. Específico para a operação N09.
If Select("TRBMCL") > 0
	TRBMCL->(dbCloseArea())
Endif
ZZJ->(dbSetorder(1))  // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
ZZJ->(dbSeek(xFilial("ZZJ") + cOperacao))
nPerGrt := Iif(nQual==1,ZZJ->ZZJ_PERGRC,ZZJ->ZZJ_PERGRT)
If mv_par09 == "N09" .AND. nQual == 1
	_cQryMCL := "SELECT convert(varchar(8),DATEADD(DAY,"
	_cQryMCL += Transform(nDias,"@e 99999")
	_cQryMCL += ",DATEADD(MONTH,"
	_cQryMCL += Transform(nPerGrt,"@e 99999")
	_cQryMCL += ",convert(Date,'"
	_cQryMCL += DToS(dNFComTro)
	_cQryMCL += "',112))),112) as DATALIM"
Else
	_cQryMCL := "SELECT convert(varchar(8),DATEADD(MONTH,"
	_cQryMCL += Transform(nPerGrt,"@e 99999")
	_cQryMCL += ",convert(Date,'"
	_cQryMCL += DToS(dNFComTro)
	_cQryMCL += "',112)),112) as DATALIM"
EndIf
TcQuery _cQryMCL NEW ALIAS "TRBMCL"  
TcSetField("TRBMCL","DATALIM","D")     //TRANFORMACAO DAS DATAS

If dEntrada <= TRBMCL->DATALIM
	__cRetMCL := "S"
EndIf

RestArea(_aAreaZZJ)
Return(__cRetMCL)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011H  ºAutor  ³Antonio L.F. Favero º Data ³  26/10/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria botao de Legenda                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tecx011H()

BRWLegenda('Legenda','Status',{{'BR_VERDE','Confirmada'},{'BR_VERMELHO','Nao confirmada'}})

Return(nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011LEGºAutor  ³Antonio L.F. Favero º Data ³  27/03/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Legenda de teclas de funcoes na Janela                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011Leg()

nTop:=360
nLeft:=16

oGrp1 				:= TGROUP():Create(oDlg)
oGrp1:cName 		:= "oGrp1"
oGrp1:cCaption 		:= "Teclas de Função"
oGrp1:nLeft 		:= 6+nLeft
oGrp1:nTop 			:= 9+nTop
oGrp1:nWidth 		:= 323
oGrp1:nHeight 		:= 59
oGrp1:lShowHint 	:= .F.
oGrp1:lReadOnly 	:= .F.
oGrp1:Align			:= 0
oGrp1:lVisibleControl := .T.

oF9 				:= TSAY():Create(oDlg)
oF9:cName 			:= "oF9"
oF9:cCaption 		:= "F9 "
oF9:nLeft 			:= 17+nLeft
oF9:nTop 			:= 26+nTop
oF9:nWidth 			:= 25
oF9:nHeight 		:= 17
oF9:lShowHint 		:= .F.
oF9:lReadOnly 		:= .F.
oF9:Align 			:= 0
oF9:lVisibleControl	:= .T.
oF9:lWordWrap 		:= .F.
oF9:lTransparent 	:= .T.

oF10 				:= TSAY():Create(oDlg)
oF10:cName 			:= "oF10"
oF10:cCaption 		:= "F10"
oF10:nLeft 			:= 17+nLeft
oF10:nTop 			:= 44+nTop
oF10:nWidth 		:= 25
oF10:nHeight 		:= 17
oF10:lShowHint 		:= .F.
oF10:lReadOnly 		:= .F.
oF10:Align 			:= 0
oF10:lVisibleControl:= .T.
oF10:lWordWrap 		:= .F.
oF10:lTransparent 	:= .T.

oSay4 				:= TSAY():Create(oDlg)
oSay4:cName 		:= "oSay4"
oSay4:cCaption 		:= "Parâmetros"
oSay4:nLeft 		:= 52+nLeft
oSay4:nTop 			:= 26+nTop
oSay4:nWidth 		:= 65
oSay4:nHeight 		:= 17
oSay4:lShowHint 	:= .F.
oSay4:lReadOnly 	:= .F.
oSay4:Align 		:= 0
oSay4:lVisibleControl:= .T.
oSay4:lWordWrap 	:= .F.
oSay4:lTransparent 	:= .T.

oSay5 				:= TSAY():Create(oDlg)
oSay5:cName 		:= "oSay5"
oSay5:cCaption 		:= "Inserir item da NF"
oSay5:nLeft 		:= 52+nLeft
oSay5:nTop 			:= 44+nTop
oSay5:nWidth 		:= 65
oSay5:nHeight 		:= 17
oSay5:lShowHint 	:= .F.
oSay5:lReadOnly 	:= .F.
oSay5:Align 		:= 0
oSay5:lVisibleControl:= .T.
oSay5:lWordWrap 	:= .F.
oSay5:lTransparent	:= .T.

oF11 				:= TSAY():Create(oDlg)
oF11:cName 			:= "oF11"
oF11:cCaption 		:= "F11"
oF11:nLeft 			:= 157+nLeft
oF11:nTop 			:= 26+nTop
oF11:nWidth 		:= 25
oF11:nHeight 		:= 17
oF11:lShowHint 		:= .F.
oF11:lReadOnly 		:= .F.
oF11:Align 			:= 0
oF11:lVisibleControl:= .T.
oF11:lWordWrap 		:= .F.
oF11:lTransparent 	:= .T.

oF12 				:= TSAY():Create(oDlg)
oF12:cName 			:= "oF12"
oF12:cCaption 		:= "F12"
oF12:nLeft 			:= 157+nLeft
oF12:nTop 			:= 44+nTop
oF12:nWidth 		:= 25
oF12:nHeight 		:= 17
oF12:lShowHint 		:= .F.
oF12:lReadOnly 		:= .F.
oF12:Align 			:= 0
oF12:lVisibleControl:= .T.
oF12:lWordWrap		:= .F.
oF12:lTransparent 	:= .T.

oSay8 				:= TSAY():Create(oDlg)
oSay8:cName 		:= "oSay8"
oSay8:cCaption 		:= "Mudar Cliente e Loja"
oSay8:nLeft 		:= 192+nLeft
oSay8:nTop 			:= 26+nTop
oSay8:nWidth 		:= 101
oSay8:nHeight 		:= 17
oSay8:lShowHint 	:= .F.
oSay8:lReadOnly 	:= .F.
oSay8:Align 		:= 0
oSay8:lVisibleControl:= .T.
oSay8:lWordWrap 	:= .F.
oSay8:lTransparent 	:= .T.

oSay9 				:= TSAY():Create(oDlg)
oSay9:cName 		:= "oSay9"
oSay9:cCaption		:= "Mudar Modelo Celular"
oSay9:nLeft 		:= 192+nLeft
oSay9:nTop 			:= 44+nTop
oSay9:nWidth 		:= 113
oSay9:nHeight 		:= 17
oSay9:lShowHint 	:= .F.
oSay9:lReadOnly 	:= .F.
oSay9:Align 		:= 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap 	:= .F.
oSay9:lTransparent 	:= .T.

oSBtn1 				:= SBUTTON():Create(oDlg)
oSBtn1:cName 		:= "oBtnDEL"
oSBtn1:cCaption 	:= "oSBtn1"
oSBtn1:nLeft 		:= 220
oSBtn1:nTop 		:= 95
oSBtn1:nWidth 		:= 52
oSBtn1:nHeight 		:= 22
oSBtn1:lShowHint 	:= .T.
oSBtn1:lReadOnly 	:= .F.
oSBtn1:Align 		:= 0
oSBtn1:lVisibleControl:= .T.
oSBtn1:nType 		:= 3
oSBtn1:bLClicked 	:= {|| Tecx011I(@cTexto) }

//oEdBar:SetFocus()
If centriage<>"S"
	oEdSIM:SetFocus()
Else
	// oEdmst:SetFocus()
Endif

//ocodbace:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011M  ºAutor  ³Edson Rodrigues     º Data ³  18/09/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se gerou arq. Entrada execel e                    º±±
±±º            verifica se IMEI consta ou nao no arquivo                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011M(cCodBarAT)

Local lResult

cQrySZA:=' SELECT ZA_FILIAL '
cQrySZA+=' FROM '+RetSQLName('SZA')+' SZA (nolock) '
cQrySZA+=" WHERE SZA.ZA_FILIAL='"+xFilial('SZA')+"' AND "
cQrySZA+=" SZA.D_E_L_E_T_<>'*' AND"
cQrySZA+=" SZA.ZA_CLIENTE='"+mv_par01+"' AND "
cQrySZA+=" SZA.ZA_LOJA='"+mv_par02+"'  AND"
cQrySZA+=" SZA.ZA_NFISCAL='"+mv_par04+"' AND "
cQrySZA+=" SZA.ZA_SERIE='"+mv_par05+"'  AND"
cQrySZA+=" SZA.ZA_IMEI='"+cCodBarAT+"'  AND"
cQrySZA+=" SZA.ZA_STATUS IN ('I','N') "

TCQUERY cQrySZA NEW ALIAS "QRYSZA"

If QRYSZA->(EOF())
	lResult:=.T.
else
	lResult:=.F.
Endif

dbSelectArea('QRYSZA')
QRYSZA->(dbCloseArea())
Return(lResult)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VERFPRO  ºAutor  ³                    º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se a NFE foi gerada com formulario proprio        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerFPro()

Local _aAreaSF1 := SF1->(GetArea())
Local _aAreaSD1 := SD1->(GetArea())
Local _lRet     := .F.

SF1->(dbSetorder(1))
_lRet := SF1->(dbSeek(xFilial('SF1') + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA)) .and. SF1->F1_FORMUL == 'S'

If _lRet // Verifica se a nota cadastrada esta com o produto e IMEI iguais a Entrada Massiva - Edson Rodrigues - 08/04/11
	SD1->(DBOrderNickName('D1NUMSER')) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER
	
	If !SD1->(dbSeek(xFilial('SD1')+ZZ4->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+Substr(ZZ4_IMEI,1,TamSX3("ZZ4_IMEI")[1]))) )
		MsgBox("Entr. Massiva refere-se ha uma NFE com formulário proprio igual a Sim. O Produto e ou o IMEI da NFE estao diferentes da E.Massiva. Essa E.Massiva nao sera confirmada, Corrija a NFE !","Produto e ou IMEI da NFE Diferente da E.Massiva","ALERT")
		_lRet:=.F.
	Endif
	
Endif

restarea(_aAreaSF1)
restarea(_aAreaSD1)
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TecaX11N  ºAutor  ³ Edson              º Data ³  03/05/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para digitação das informações iniciais da entrada    º±±
±±º          ³ massiva  - Outras Informacoes                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TecaX11N(_lnfcomp,_lnfTroca,cinfcaut)

Local _lOk	:= .F.
creccli		:=Space(30)
ccodope		:=Space(30)
cdescpf		:=Space(30)
mv_par18	:= Space(nTamNfe) // NF de Compra
mv_par19	:= CtoD("  /  / ")  // Data da NF de Compra
mv_par21	:= Space(3)
mv_par22	:= Space(18)
mv_par23	:= Space(14)
mv_par10	:= Space(12) //OS SAM
mv_par11	:= Space(11) // COD. AUTORIZ.
mv_par12	:= "C0022 "  // RECL. CLIENTE
mv_par13	:= Space(06) //OPERADORA
mv_par14	:= Space(06) //TRANSPORT
mv_par15	:= "N" //ACESSORIO
mv_par16	:= ""  // GARANTIA SIM OU NAO
mv_par17	:= Space(20) // CONHECIMENTO/LACRE
mv_par24	:= Space(nTamNfe) // NF de Troca
mv_par25	:= Space(3) // Serie NF Troca
mv_par26	:= CtoD("  /  / ") // Data da NF de Troca
mv_par27	:= Space(18) //CNPJ/CPF NF Troca

//If _lnfcomp .AND. mv_par09="N03"
If _lnfcomp .AND. cinfcaut='S'

	If _lnfTroca
		@ 116,095 To 605,536 Dialog TelaOutras	Title OemToAnsi("Outras informações")
		@ 150,009 To 225,210 Title OemToAnsi("Dados NF TROCA Aparelho")

		@ 013,002 Say OemToAnsi("NF Troca:")			Size 29,8
		@ 014,002 Say OemToAnsi("Serie NF Troca:")		Size 29,8
		@ 015,002 Say OemToAnsi("Data Troca:")			Size 29,8
		@ 016,002 Say OemToAnsi("CPF/CNPJ Consumidor:")	Size 29,8

		@ 167,057 Get mv_par24 Size 025,010 Picture "@!" When !Empty(mv_par18) Valid(mv_par27:=mv_par23) Object onftro
		@ 180,059 Get mv_par25 Size 010,010 Picture "!!!" When !Empty(mv_par24) 
		@ 193,057 Get mv_par26 Size 025,010 Picture " / / " When !Empty(mv_par24) Valid u_ValtX11N(mv_par26,"6") Object odtnftr
		@ 206,075 Get mv_par27 Size 059,010 Picture "@R 99999999999999" When !Empty(mv_par24)

		@ 230, 140 BMPBUTTON TYPE 1 Action (_lOk := .T., Close(TelaOutras))
		@ 230, 170 BMPBUTTON TYPE 2 Action (_lOk := .F., Close(TelaOutras))
	Else
		@ 116,095 To 460,536 Dialog TelaOutras	Title OemToAnsi("Outras informações")

		@ 155, 140 BMPBUTTON TYPE 1 Action (_lOk := .T., Close(TelaOutras))
		@ 155, 170 BMPBUTTON TYPE 2 Action (_lOk := .F., Close(TelaOutras))
	EndIf

	@ 002,009 To 150,210 Title OemToAnsi("Dados SAM e NF compra Aparelho")

	@ 001,002 Say OemToAnsi("OS SAM:")				Size 41,8
	@ 002,002 Say OemToAnsi("Cod Autorizada:")		Size 26,8
	@ 003,002 Say OemToAnsi("Cod Recl. Cliente:")	Size 29,8
	@ 004,002 Say OemToAnsi("Cod. Operadora:")		Size 29,8
	@ 005,002 Say OemToAnsi("NF Compra:")			Size 29,8
	@ 006,002 Say OemToAnsi("Serie NF Compra:")		Size 29,8
	@ 007,002 Say OemToAnsi("Data Compra:")			Size 29,8
	@ 008,002 Say OemToAnsi("CPF/CNPJ Consumidor:")	Size 29,8
	@ 009,002 Say OemToAnsi("CNPJ Forn. NF Compra")	Size 29,8

//	@ 011,055 Get mv_par10 Size 050,010 Picture "@!" Valid !Empty(mv_par10)	.and. left(mv_par10,2) == "BR" Object ossam
	@ 011,055 Get mv_par10 Size 050,010 Picture "@!" Valid !Empty(mv_par10)	.and. left(mv_par10,2) $ "BR,WO" Object ossam  //Alterado Uiran Almeida - 23/10/2013 Chamado ID - 15 927  
	@ 024,055 Get mv_par11 Size 050,010 Picture "@!" Valid u_ValtX11N(mv_par11,"5") Object ocodaut
	@ 038,065 Get mv_par12 Size 025,010 Picture "@!" Valid u_ValtX11N(alltrim(mv_par12),"1") F3 "W4" Object ocrecli
	@ 038,100 Get creccli  Size 100,010 When .F.
	@ 052,057 Get mv_par13 Size 026,010 Picture "@!" Valid u_ValtX11N(alltrim(mv_par13),"2") F3 "W1" Object ooperad
	@ 052,090 Get ccodope  Size 110,010 When .F.
//	@ 065,057 Get mv_par18 Size 025,010 Picture "@!" Valid !Empty(mv_par18)	 Object onfcom
	@ 065,057 Get mv_par18 Size 025,010 Picture "@!" Object onfcom
//	@ 078,059 Get mv_par21 Size 010,010 Picture "!!!"
	@ 078,059 Get mv_par21 Size 010,010 Picture "!!!" When !Empty(mv_par18)
//	@ 091,057 Get mv_par19 Size 025,010 Picture " / / "   Valid u_ValtX11N(mv_par19,"3") Object odtnfco
	@ 091,057 Get mv_par19 Size 025,010 Picture " / / " Valid u_ValtX11N(mv_par19,"3") Object odtnfco
//	@ 104,075 Get mv_par22 Size 059,010 Picture "@R 99.999.999/9999-99"
	@ 104,075 Get mv_par22 Size 059,010 Picture "@R 99.999.999/9999-99"	When !Empty(mv_par18) 
//	@ 117,075 Get mv_par23 Size 059,010 Picture "@R 99999999999999"  //Valid u_ValtX11N(mv_par23,"4") Object ocpfcli
	@ 117,075 Get mv_par23 Size 059,010 Picture "@R 99999999999999"		When !Empty(mv_par18) //Valid u_ValtX11N(mv_par23,"4") Object ocpfcli
	@ 130,075 Get cdescpf  Size 120,010 When .F.

	ossam:SetFocus()
	//ElseIf _lnfcomp .AND. !mv_par09="N03"
ElseIf _lnfcomp .AND. cinfcaut='N'

	If _lnfTroca
		@ 116,095 To 500,536 Dialog TelaOutras Title OemToAnsi("Outras informações")
		@ 095,009 To 170,210 Title OemToAnsi("Dados NF TROCA Aparelho")

		@ 009,002 Say OemToAnsi("NF Troca:")			Size 29,8
		@ 010,002 Say OemToAnsi("Serie NF Troca:")		Size 29,8
		@ 011,002 Say OemToAnsi("Data Troca:")			Size 29,8
		@ 012,002 Say OemToAnsi("CPF/CNPJ Consumidor:")	Size 29,8

		@ 115,075 Get mv_par24 Size 025,010 Picture "@!" When !Empty(mv_par18) Valid(mv_par27:=mv_par23) Object onftro
		@ 128,075 Get mv_par25 Size 010,010 Picture "!!!" When !Empty(mv_par24)
		@ 141,075 Get mv_par26 Size 025,010 Picture " / / " When !Empty(mv_par24) Valid u_ValtX11N(mv_par26,"6") Object odtnftr
		@ 154,075 Get mv_par27 Size 059,010 Picture "@R 99999999999999" When !Empty(mv_par24)

		@ 175, 140 BMPBUTTON TYPE 1 Action (_lOk := .T., Close(TelaOutras))
		@ 175, 170 BMPBUTTON TYPE 2 Action (_lOk := .F., Close(TelaOutras))
	Else
		@ 116,095 To 380,536 Dialog TelaOutras Title OemToAnsi("Outras informações")

		@ 100, 140 BMPBUTTON TYPE 1 Action (_lOk := .T., Close(TelaOutras))
		@ 100, 170 BMPBUTTON TYPE 2 Action (_lOk := .F., Close(TelaOutras))
	EndIF

	@ 002,009 To 095,210 Title OemToAnsi("Dados NF Compra Aparelho")

	@ 001,002 Say OemToAnsi("NF Compra:")			Size 29,8
	@ 002,002 Say OemToAnsi("Serie NF Compra:")		Size 29,8
	@ 003,002 Say OemToAnsi("Data Compra:")			Size 29,8
	@ 004,002 Say OemToAnsi("CNPJ Forn. NF Compra")	Size 29,8
	@ 005,002 Say OemToAnsi("CPF/CNPJ Consumidor:")	Size 29,8

	@ 011,075 Get mv_par18 Size 025,010 Picture "@!"			Valid !vazio()	 Object onfcom
	@ 024,075 Get mv_par21 Size 010,010 Picture "!!!"
	@ 038,075 Get mv_par19 Size 025,010 Picture " / / "       Valid u_ValtX11N(mv_par19,"3") Object odtnfco
	@ 052,075 Get mv_par22 Size 059,010 Picture "@R 99.999.999/9999-99"
	@ 065,075 Get mv_par23 Size 059,010 Picture "@R 99999999999999" Valid u_ValtX11N(mv_par23,"4") Object ocpfcli
	@ 078,075 Get cdescpf  Size 120,010 When .F.

	onfcom:SetFocus()
	//ElseIf !_lnfcomp .AND. mv_par09="N03"
ElseIf !_lnfcomp .AND. cinfcaut='S'

	@ 116,095 To 350,536 Dialog TelaOutras Title OemToAnsi("Outras informações ")
	@ 002,009 To 115,210 Title OemToAnsi("Dados SAM")

	@ 001,002 Say OemToAnsi("OS SAM:") Size 41,8
	@ 002,002 Say OemToAnsi("Cod Autorizada:")       Size 26,8
	@ 003,002 Say OemToAnsi("Cod Recl. Cliente:")    Size 29,8
	@ 004,002 Say OemToAnsi("Cod. Operadora:")       Size 29,8

	@ 011,055 Get mv_par10 Size 050,010 Picture "@!"  			Valid !vazio()	 Object ossam
	@ 024,055 Get mv_par11 Size 050,010 Picture "@!"           	Valid !vazio()	 Object ocodaut
	@ 038,065 Get mv_par12 Size 025,010 Picture "@!"  			Valid u_ValtX11N(alltrim(mv_par12),"1")  F3 "W4" Object ocrecli
	@ 038,100 Get creccli  Size 100,010 When .F.
	@ 052,057 Get mv_par13 Size 026,010 Picture "@!"           	Valid u_ValtX11N(alltrim(mv_par13),"2")  F3 "W1" Object ooperad
	@ 065,090 Get ccodope  Size 110,010 When .F.

	@ 080, 140 BMPBUTTON TYPE 1 Action (_lOk := .T., Close(TelaOutras))
	@ 080, 170 BMPBUTTON TYPE 2 Action (_lOk := .F., Close(TelaOutras))

Endif

Activate Dialog TelaOutras

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValtX11N  ºAutor  ³ Edson Rodrigues    º Data ³  03/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz as validacoes da tela de Outras informacoes digitadas   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValtX11N(cChave,cQual)
Local lRet		:=.T.
Local aAlias  	:= {"SA1"}
Local aAmb    	:= u_GetAmb(aAlias)
//Local ndias   := Iif(mv_par09="N02",450,396)
Local lRet    	:= .T.
Local _cChav	:= cChave
Local _pergar   := 0
Local _cXcodSam	:= ""
Local _cQryDelet
Local _cQryExec
Local _cQryExec1
Local _cQryGnfco
Local cReceiveDir := "\LOG\"

oLogFile := WFFileSpec( cReceiveDir + "receive.log" )
cMsg := Replicate( "*", 80 )
oLogFile:WriteLN( cMsg )
ConOut( cMsg )

If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif
If Select("TRB") > 0
	TRB->(dbCloseArea())
Endif
If Select("TRB3") > 0
	TRB3->(dbCloseArea())
Endif

If cQual=="3".And. !Empty(DToS(_cChav))      // Alterado 09/06/10 para nao pegar parametro vazio
	_pergar := Posicione("ZZJ", 1, xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_PERGAR")

	//_cQryExec := " SELECT DATEDIFF(MONTH, '" + DToS(_cChav) + "' , GETDATE()) as DATES "
	_cQryExec := " SELECT CONVERT(VARCHAR(10),DATEADD(MONTH, " + Transform(_pergar ,"@E 99") + ",'" + DToS(_cChav) + "' ),112) AS DATES "
	TCQUERY _cQryExec NEW ALIAS "TRB"

	// Nf- compra tem mais 30 dias corrido apos o vencimento inserindo SPC......
	// Sendo todas todas operacoes
	// Removido Transform(_pergar + 1,"@E 99") errado.
	_cQryExec1  := " SELECT CONVERT(VARCHAR(10),DATEADD(DAY, 30,'" + TRB->DATES + "' ),112) AS DIAS "
	TCQUERY _cQryExec1 NEW ALIAS "TRB3"
ElseIf cQual=="6" .AND. !Empty(DToS(_cChav))
//	_pergar := Posicione("ZZJ", 1, xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_PERGRT")
	_pergar := 12

	// Para NF Troca, é necessário o calculo de 12 meses e 10 dias. Por isso foi alterada a forma de tratamento no cadastro de processo ZZJ
	//e o campo agora respeita apenas quantidade de dias (* Ano Bissexto - conversar com Edson) - Hudson de Souza Santos 08/07/2013

	// Solução paleativa para inclusões urgentes da operação N09. Devemos rever a regra de calculo geral - Hudson de Souza Santos 08/07/2013
	If mv_par09 == "N09"
		_cQryExec := " SELECT CONVERT(VARCHAR(10),DATEADD(DAY,10,DATEADD(MONTH,12,'"+DToS(_cChav)+"')),112) AS DATES"
		TCQUERY _cQryExec NEW ALIAS "TRB"

		_cQryExec1  := " SELECT CONVERT(VARCHAR(10),DATEADD(DAY, 30,'" + TRB->DATES + "' ),112) AS DIAS "
		TCQUERY _cQryExec1 NEW ALIAS "TRB3"
	Else	
		_cQryExec := " SELECT CONVERT(VARCHAR(10),DATEADD(MONTH,"+Transform(_pergar,"@E 99")+",'"+DToS(_cChav)+"'),112) AS DATES"
		TCQUERY _cQryExec NEW ALIAS "TRB"

		_cQryExec1  := " SELECT CONVERT(VARCHAR(10),DATEADD(DAY, 30,'" + TRB->DATES + "' ),112) AS DIAS "
		TCQUERY _cQryExec1 NEW ALIAS "TRB3"
	Endif
Endif

If cQual=="4"
	SA1->(dbSetorder(3)) // A1_FILIAL + A1_CGC
	SA1->(dbSeek(xFilial("SA1")+cQual,.F.))
Endif

_cXcodSam	:= Posicione("SA1",1,xFilial("SA1")+AllTrim(mv_par01)+AllTrim(mv_par02),"A1_XCODSAM")

If cQual == "1" // Reclamacao do Cliente
	SX5->(dbSeek("W4"+alltrim(mv_par12)))
	If Empty(cChave)
		MsgBox("Reclamacao do Clinte deve ser digitado !","Outras Informações","ALERT")
		lRet := .F.
	ElseIf !ExistCpo("SX5","W4"+alltrim(mv_par12))
		MsgBox("Não foi encontrado este código de Reclamacao no sistema, Favor verificar.","Outras Informações","ALERT")
		lRet := .F.
	else
		creccli := SX5->X5_DESCRI
		ooperad:SetFocus()
	Endif
ElseIf	cQual == "2" // Operadora
	SX5->(dbSeek("W1"+alltrim(mv_par13)))
	If Empty(cChave)
		MsgBox("Operadora deve ser digitado !","Outras Informações","ALERT")
		lRet := .F.
	ElseIf !ExistCpo("SX5","W1"+alltrim(mv_par13))
		MsgBox("Não foi encontrado este código de Reclamacao no sistema, Favor verificar.","Outras Informações","ALERT")
		lRet := .F.
	else
		ccodope := SX5->X5_DESCRI
		If _lnfcomp
			onfcom:SetFocus()
		Endif
	Endif
ElseIf	cQual == "3" // Data da compra	---sempre operacao Retail
	If Empty(cChave)
		MsgBox("Data da NF de compra deve ser digitado !","Outras Informações","ALERT")
		lRet := .F.
	ElseIf cChave > dDataBase
		MsgBox("Data da NF de compra deve deve ser menor que data do sistema !","Outras Informações","ALERT")
		lRet := .F.
	ElseIf  TRB->DATES < DToS(_cChav) .And. DToS(_cChav) <= TRB3->DIAS
		mv_par16:= "S"
		_cSpc	:= "SPC0000456"
	ElseIf TRB->DATES < DToS(_cChav) .And. DToS(_cChav) > TRB3->DIAS
		mv_par16:= "N"
		_cSpc	:=	""
	Endif
ElseIf cQual == "4" //CNPJ/CPF do Cliente.
	If Empty(cChave)
		MsgBox("CPF/CNPJ do Consumidor deve ser digitado !","Outras Informações","ALERT")
		lRet := .F.
	ElseIf !SA1->(dbSeek(xFilial("SA1")+cChave,.F.))
		MsgBox("Não existe cliente cadastrado com o CNPJ digitado, Favor Cadastrar assim que terminar essa entrada massiva.","Outras Informações","ALERT")
		cdescpf:="Favor Cadastrar Cliente assim que terminar essa entrada massiva"
	else
		cdescpf:="Cliente Ja Cadastrado"
	Endif
ElseIf cQual == "5"
	//If Empty(cChave)
	If Empty(cChave) .And. Substr(mv_par10,1,2)== "BR" // Alterado Uiran Almeida - 23/10/2013 Chamado ID - 15 927  
		MsgBox("Favor Inserir oCodigo do SAM!","Outras Informações","ALERT")
		lRet := .F.
	Endif
	
	If AllTRim(_cXcodSam) <> AllTrim(cChave)
		MsgBox("Codigo Divergente com Cadastro!","Outras Informações","ALERT")
		lRet := .F.
	Endif
ElseIf cQual == "6"
	If Empty(cChave)
		MsgBox("Data da NF de Troca deve ser digitado !","Outras Informações","ALERT")
		lRet := .F.
	ElseIf cChave > dDataBase
		MsgBox("Data da NF de Troca deve deve ser menor que data do sistema !","Outras Informações","ALERT")
		lRet := .F.
	ElseIf  TRB->DATES < DToS(_cChav) .And. DToS(_cChav) <= TRB3->DIAS
		mv_par16:= "S"
		_cSpc	:= "SPC0000456"
	ElseIf TRB->DATES < DToS(_cChav) .And. DToS(_cChav) > TRB3->DIAS
		mv_par16:= "N"
		_cSpc	:=	""
	Endif
Endif

If Select("TRB") > 0
	TRB->(dbCloseArea())
Endif
If Select("TRB3") > 0
	TRB3->(dbCloseArea())
Endif
cMsg :=  "Data " + Transform(_cChav,"@E 99999999") + "SISTEM (S/N) " + mv_par16 + " -  Garantia Operacao (" + TransForm(_pergar,"@E 99") + ")  tecax011  "
WFConOut( cMsg, oLogFile, .F. )
cMsg := Replicate( "*", 80 )
oLogFile:WriteLN( cMsg )
WFConOut( cMsg )

u_RestAmb( aamb )
Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecax11m  ºAutor  ³ Edson Rodrigues    º Data ³  03/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de cadastro de acessorios                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecax11m(ccodbar,_cSepEnt,_cCodPro)
Local lRet:=.T.
Local cVarACE:= Replicate(' ',20)

_acess :={}

If Alltrim(_cSepEnt) == "S"
	Processa({|| u_tecaxSG1(@cVarACE,@cTextac,.F.,ccodbar,_cCodPro) },"Processando Cadastro de Acessorio...")
Endif

While !_lFechCS
	@ 0,0 To 360,520 Dialog oDlgaces Title "Cadastro de Acessorios"
	oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"CodBar.bmp",.T.,oDlgaces)
	@ 005,077 Say oV1 var "Passe a leitora de" Of oDlg FONT oFnt1 Pixel Size 150,010 COLOR CLR_BLUE

	If Alltrim(_cSepEnt) == "S"
		@ 050,010 Get cVarACE Size 100,080 Picture "@!" Valid u_gravaces(@cVarACE,@cTextac,.F.,ccodbar) Object ocodbace when .F.
	Else
		@ 050,010 Get cVarACE Size 100,080 Picture "@!" Valid u_gravaces(@cVarACE,@cTextac,.F.,ccodbar) Object ocodbace
	Endif

	@ 065,010 Get cTexTac  Size 150,115 MEMO Object oMemoaces //when .F.
	@ 150,180 BUTTON "CONFIRMA" Size 60,13 Action Processa({|| U_confaces(_acess,oDlgaces,@cTextac) })
	@ 160,180 BUTTON "CANCELA"  Size 60,13 Action Iif(MSGYESNO("DESEJA REALMENTE CANCELAR? TODOS ACESSORIOS DEVERÃO SER APONTADOS NOVAMENTE."),concaces(.F.,oDlgaces,@cTextac),)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria legenda de funcoes na tela                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Tecx011Leg()
	Activate MsDialog oDlgaces On Init ocodbace:SetFocus()
EndDo
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³gravaces  ºAutor  ³ Edson Rodrigues    º Data ³  03/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtem registro escaneados de acessorios e atualiza Memo    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function gravaces(cCodaces,Memoaces,_lAuto,ccodbar)

Local lResult    := .T.
Local lpartn     := .T.
Local tMemo      := ""
Local _cCodPro   := mv_par03
Local _nVlrUnit  := mv_par06
Local _nVez      := 0
Local _codaces   :=left(cCodaces,15)
Local _ctpacess  := Space(6)

_cdescr    := Space(30)

// So executa a validacao se o codigo de barra nao estiver preenchido
If Empty(cCodaces)
	If MSGYESNO("Não foi escaneado ou digitado o acessório. Quer informar somente o acessório e não informar o partnumber ? ")
		lpartn:=.F.
	ELSE
		// lResult:=.F.
		Return(lResult)
	Endif
Endif

// Alterado Edson Rodrigues
If "'" $ cCodaces  .or. '"' $ cCodaces .and. lpartn
	tMemo := '------Proibido informar aspas simples ou duplas no Codigo de Acesssorios.--------'+LFRC+LFRC
	Memoaces := tMemo+Memoaces
	cCodaces:=Replicate(' ',20)
	If ValType(oDlg)=="O"
		Close(oDlg)
	Endif
	lResult:=.F.
	Return(lResult)
Endif

If !_lAuto .and. !Empty(cCodaces) .and. lpartn
	_lvaldesc   := .T.
	If SB1->(!dbSeek(xFilial("SB1") + _codaces))
		dbSelectArea("SZC")
		dbSetorder(2)
		If dbSeek(xFilial("SZC")+ cCodaces)
			While !SZC->(EOF())	.and. SZC->ZC_FILIAL==xFilial("SZC") .and. ALLTRIM(SZC->ZC_ACESS)==ALLTRIM( cCodaces)
				If  !Empty(SZC->ZC_DESACES) .and. !SZC->ZC_DESACES==ALLTRIM( cCodaces)
					mv_par20:=ALLTRIM(SZC->ZC_DESACES)
					_lvaldesc   := .T.
					exit
				Else
					_lvaldesc   := .F.
				Endif
				SZC->(dbskip())
			EndDo
		ELSE
			_lvaldesc   := .F.
		Endif
		
	ELSE
		SB1->(dbSeek(xFilial("SB1") + _codaces))
		mv_par20:=ALLTRIM(SB1->B1_DESC)
	Endif
ELSE
	_lvaldesc   := .F.
Endif

If !_lvaldesc .and. lpartn
	//Janela de cadastro da descricao de acessorios
	oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
	@ 0,0 To 200,300 Dialog oDlgdesac Title "Cadastro Descricao Acessorio"
	oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlgdesac)
	@ 05,050 Say oV1 var "Digite a Descricao do Acessorio:" Of oDlg FONT oFnt1 Pixel Size 150,010 COLOR CLR_BLUE
	@ 40,010 Get _cdescr Size 100,080 Picture "@!" Valid !Vazio()
	@ 80,085 BMPBUTTON TYPE 1 Action Processa({|lEnd| caddesc(_cdescr,oDlgdesac,.F.,@cCodaces)})
	@ 80,120 BMPBUTTON TYPE 2 Action oDlgdesac:End()
	Activate MsDialog oDlgdesac Centered
	
ElseIf _lvaldesc .and. lpartn
	_cdescr:=ALLTRIM(mv_par20)
Endif

//verifica se  descrição e um código de acessório -Edson Rodrigues -01/10/10 /
// revisado e alterado em 11/11/10 - Edson Rodrigues
If !_lvaldesc .and. !Empty(_cdescr)
	If SB1->(!dbSeek(xFilial("SB1") + ALLTRIM(_cdescr)))
		dbSelectArea("SZC")
		dbSetorder(2)
		If dbSeek(xFilial("SZC")+ ALLTRIM(_cdescr))
			While !SZC->(EOF())	.and. SZC->ZC_FILIAL==xFilial("SZC") .and. ALLTRIM(SZC->ZC_ACESS)==ALLTRIM(_cdescr) .AND. !SZC->ZC_DESACES==ALLTRIM(_cdescr)
				If !Empty(SZC->ZC_DESACES)
					mv_par20:=ALLTRIM(SZC->ZC_DESACES)
					cCodaces:=SZC->ZC_ACESS
					exit
				Endif
				SZC->(dbskip())
			EndDo
		Endif
	Else
		SB1->(dbSeek(xFilial("SB1") + ALLTRIM(_cdescr)))
		mv_par20:=ALLTRIM(SB1->B1_DESC)
		cCodaces:=SB1->B1_COD
	Endif
Endif

//abre tela de escolha do tipo de acessorio - Edson Rodrigues - 08/09/10.
_actacess 	:= U_TPACESS(@_actacess, _codaces, _cdescr)
Memoaces 	:= ""

If  Len(_actacess)  > 0
	ltemtpac:=.F.

	_acess := {}
	For nY:=1 To Len(_actacess)
		_cdesctpa:=Posicione("SX5",1,xFilial("SX5") + "Z5"+_actacess[nY,1], "X5_DESCRI")
		dbSelectArea("SZC")
		dbSetorder(1)

		//Caso o usuário nao informou o partnumber do acessório, entao o sistema assume como
		//codigo e decricao,  o tipo e descricao de acessorio escolhido - Edson 11/11/10
		If !lpartn .and. Empty(cCodaces)
			cCodaces := _actacess[nY,1]
		Endif

		If  !lpartn .and. Empty(_cdescr)
			_cdescr  :=_cdesctpa
		Endif

		If SZC->(dbSeek(xFilial("SZC") + mv_par04+mv_par05+mv_par01+mv_par02+_cCodPro))
			While SZC->(!eof()) .and. SZC->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO) == mv_par04+mv_par05+mv_par01+mv_par02+_cCodPro
				If SZC->ZC_IMEI=cCodBar .AND. SZC->ZC_TPACESS==_actacess[nY,1]
					If !MSGYESNO("O Tipo de Acessorio escolhido : "+_actacess[nY,1]+"-"+alltrim(_cdesctpa)+"  ja foi informado no cod/acess. : "+SZC->ZC_CODACES+" - "+alltrim(SZC->ZC_DESACES)+" Voce quer repetir esse mesmo tipo de acessorio para o cod/acess : "+cCodaces+"-"+alltrim(_cdescr)+" ?")
						ltemtpac:=.T.						
					Endif
				Endif
				SZC->(DBSkip())
			EndDo
		Endif

		If  !ltemtpac			
			aadd(_acess,{mv_par04,mv_par05, mv_par01,mv_par02,cCodBar,Posicione("SA1",1,xFilial("SA1") + mv_par01+mv_par02, "A1_NOME"),;
			_cCodPro,Posicione("SB1",1,xFilial("SB1") + _cCodPro, "B1_DESC"),Iif(!Empty(_actacess[nY,3]),AllTrim(_actacess[nY,3]),""),;
			Iif(!Empty(_actacess[nY,2]),_cdesctpa,""),_actacess[nY,1],""})
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !_lAuto
				tMemo := 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
				If lpartn .And. !Empty(_actacess[nY,2])
					//tMemo += 'Part. Acess: '+AllTrim(_actacess[nY,3])+' Descricao: '+_actacess[nY,2]+LFRC
				Endif
				tMemo += 'Tipo Acess : '+_actacess[nY,1]+'-'+_cdesctpa+LFRC
				tMemo += 'IMEI: '+cCodBar+' NF: '+mv_par04+' Série: '+mv_par05+LFRC
				tMemo += '---------------------------------------------------------------'+LFRC
				Memoaces := tMemo+LFRC+Memoaces+LFRC
			Endif
		Else
			MsgBox("Tipo de acessorio repetido, informe novamente !","Tipo de acessorio repetido ","ALERT")
		Endif
	Next nY
Else
	MsgBox("E obrigatorio informar o tipo de acessorio !","Tipo de acessorio nao selecionado","ALERT")
Endif

cVarACE  := Replicate(' ',20)
cCodaces := Replicate(' ',20)
_cdescr  := Space(30)
mv_par20 := Space(30)
ocodbace:SetFocus()
_cdesctpa:=""
Return(lResult)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Confaces  ºAutor  ³ Edson Rodrigues    º Data ³  03/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Confirma gravacao dos acessorios escaneados                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function confaces(_acess,oDlgaces,memoaces)
_nqtdaces:=0
_nitens:=0


If Len(_acess) > 0
	_nqtdaces:=Len(_acess)
	If ApMsgYesNo('Foram escaneados :'+STRZERO(_nqtdaces,3)+'  Acessórios. Confirma essa quantidade de acessórios?','Confirma Acessorios')
		For x:=1 To Len(_acess)
			Reclock('SZC',.T.)
			SZC->ZC_FILIAL 	  := xFilial('SZC')
			SZC->ZC_DOC    	  := _acess[x,1]
			SZC->ZC_SERIE  	  := _acess[x,2]
			SZC->ZC_FORNECE	  := _acess[x,3]
			SZC->ZC_LOJA   	  := _acess[x,4]
			SZC->ZC_IMEI      := _acess[x,5]
			SZC->ZC_NOME      := _acess[x,6]
			SZC->ZC_ITEMNFE	  := ""
			SZC->ZC_CODPRO    := _acess[x,7]
			SZC->ZC_DESPRO	  := _acess[x,8]
			SZC->ZC_ITEM  	  := STRZERO(_nitens+1,2)
			SZC->ZC_ACESS     := _acess[x,9]
			SZC->ZC_DESACES   := _acess[x,10]
			SZC->ZC_QUANT     := 1
			SZC->ZC_STATUS 	  := "0"
			SZC->ZC_TPACESS   := _acess[x,11]
			SZC->ZC_ACERECE   := _acess[x,12]
			MsUnLock('SZC')
		Next
	Endif
Endif
_acess:={}
memoaces:=""
Close(oDlgaces)
oDlgaces:end()
_lFechCS:=.T.
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Caddesc   ºAutor  ³ Edson Rodrigues    º Data ³  03/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtem descricao cadastrada para o acessorio                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function caddesc(_cdescr,oDlgdesac,_llog,cCodaces)
mv_par20:=_cdescr
Close(oDlgdesac)
cCodaces:=Replicate(' ',20)
ocodbace:setfocus()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³concaces  ºAutor  ³ Edson Rodrigues    º Data ³  03/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fecha a janela de Cadastro Acessorios                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function concaces(_lAuto,oDlg,memoaces)

_lFechCS := .T.

If !_lAuto
	If Len(_acess) > 0
		_acess:={}
	Endif
	memoaces:=""
	If ValType(oDlg)=="O"
		Close(oDlg)
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Vergaran  ºAutor  ³ Edson Rodrigues    º Data ³  03/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula tempo de garantida do aparelho                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³           BGH DO BRASIL                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º16/04/2010ºPaulo Lopez       ºModificado Validacoes                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Vergaran(cVarSim,coper,cimei)


Local _dmes    := SUBSTR(DTOC(dDataBase),4,2)
Local _cdia    := Iif(_dmes='02','28',Iif(_dmes $ "01/03/05/07/08/10/12",'31','30'))
Local _cvmessim:= substr(cVarSim,6,1)
Local _cvanosim:= substr(cVarSim,5,1)
Local _cmes:="01"
Local _cano:= "2000"
Local _ddtfabr := _cano + substr(_cmes,1,2) + _cdia
Local _cgaran  := ""
Local _pergar  := Posicione("ZZJ", 1, xFilial("ZZJ") + AllTrim(coper), "ZZJ_PERGAR")
Local _clab    := Posicione("ZZJ", 1, xFilial("ZZJ") + AllTrim(coper), "ZZJ_LAB")
Local _cQry
Local _cQryDelet
Local _cQryExec
Local cReceiveDir := "\LOG\"
Local _creccli :=""
Local _cimei   :=Iif(cimei=nil,space(TamSX3("ZZ4_IMEI")[1]),cimei)
Local _lvcarc  := .T.

//Local _ddtfabr := CtoD(_cdia+"/"+substr(_cmes,1,2)+"/"+_cano)
//Local _ndiasgar:=Iif(alltrim(coper) = "N02",450,396)

If SX5->(dbSeek(xfilial("SX5")+"WD"+alltrim(_cvmessim)))
	_cmes:= ALLTRIM(SX5->X5_DESCRI)
ELSE
	MsgBox("Carcaça Invalida ou o identificador do mes de fabricação : "+_cvmessim+" não existe na tabela WD dos SX5 !","Digite uma carcaça válida ou entre em contato com Administrador do sistema","ALERT")
	_lvcarc:= .F.
Endif
If SX5->(dbSeek(xfilial("SX5")+"WC"+alltrim(_cvanosim)))
	_cano:= ALLTRIM(SX5->X5_DESCRI)
ELSE
	MsgBox("Carcaça Invalida ou o identificador do ano de fabricação : "+_cvanosim+" não existe na tabela WC dos SX5 !","Digite uma carcaça válida ou entre em contato com Administrador do sistema","ALERT")
	_lvcarc:= .F.
Endif
_cdia    := Iif(substr(_cmes,1,2)='02','28',Iif(substr(_cmes,1,2) $ "01/03/05/07/08/10/12",'31','30'))
_ddtfabr := CtoD(_cdia+"/"+substr(_cmes,1,2)+"/"+_cano)
_ddtfabr := _cano + substr(_cmes,1,2) + _cdia

oLogFile := WFFileSpec( cReceiveDir + "receive.log" )
cMsg := Replicate( "*", 80 )
oLogFile:WriteLN( cMsg )
ConOut( cMsg )

If Select("QRY") > 0
	QRY->(dbCloseArea())
	
Endif
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                           

//Incluso If para não pegar as operacoes iniciadas com N - Edson Rodrigues - 23/07/12
If left(AllTrim(coper),1)<>'N'
  //  Trecho incluido por Luis Carlos - Maintech - Abril / 2012 - Se o aparelho estiver entrando pela primeira vez é garantia
	_cQuery :=	"SELECT COUNT(*) AS total FROM "+RetSqlName("ZZ4")+"  AS ZZ4 (nolock)  WHERE ZZ4_IMEI = '" + _cimei + "'"
	TCQUERY _cQuery NEW ALIAS "TRB1"
	If TRB1->total == 0
		_cgaran:= "S"
	Endif
Endif


If !Empty(_ddtfabr)			// Alterado 09/06/10 para nao pegar parametro vazio
	
	_cQryExec := " SELECT DATEDIFF(MONTH, '" + _ddtfabr + "' , GETDATE()) AS DATES "
	TCQUERY _cQryExec NEW ALIAS "TRB"
	
	If TRB->DATES <= _pergar .and. _lvcarc
		_cgaran:= "S"
	ElseIf TRB->DATES > _pergar  .and. _lvcarc
		_cgaran:= "N"
	Endif

	cMsg :=  "Data Fabricacao - " + _ddtfabr + "SISTEM (S/N) " + cVarSim + _cgaran + " Garantia Operacao (" + TransForm(_pergar,"@E 99") + ")  Vergaran  "
	WFConOut( cMsg, oLogFile, .F. )
	cMsg := Replicate( "*", 80 )
	oLogFile:WriteLN( cMsg )
	WFConOut( cMsg )
	
Endif

If Select("TRB") > 0
	TRB->(dbCloseArea())
Endif
If Select("TRB1") > 0
	TRB1->(dbCloseArea())
Endif

Return(_cgaran)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³vernfcom  ºAutor  ³ Edson Rodrigues    º Data ³  03/09/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica existencia da NFE Compra - Processo Refurbish Sony
º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function vernfcom(cdoc,cser,ccli,cloja,cProd,_nVlrUnit,cver,cimei)
Local _lret    :=.T.
Local _cprefix :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_PREFIX")
Local _cnewpro :=Iif(left(cProd,3)=="DPY",alltrim(_cprefix)+substr(alltrim(cProd),4,12),alltrim(_cprefix)+alltrim(cProd))

dbSelectArea("SD1")
dbSetorder(12)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD

If cver =='1'
	If !SD1->(dbSeek(xFilial('SD1')+cdoc+cser+ccli+cloja+cProd) )
		_lret:=.F.
	Endif
ElseIf cver =='2'
	If SD1->(dbSeek(xFilial('SD1')+cdoc+cser+ccli+cloja+cProd) )
		If SD1->D1_VUNIT<>_nVlrUnit
			// If ApMsgYesNo('Valor digitado : '+STR(_nVlrUnit)+' diferente do digitado na NF de compra : '+STR(SD1->D1_VUNIT)+'. Quer alterar o valor digitado pelo valor da Nfe de compra ?','Confirma Valor')
			_nVlrUnit:=SD1->D1_VUNIT
			// Else
			//  _lret:=.F.
			// Endif
		Endif
	Else
		_lret:=.F.
	Endif
ElseIf cver =='3'
	dbSelectArea("SB1")
	dbSetorder(1)       // B1_FILIAL + B1_COD
	If !SB1->(dbSeek(xFilial('SB1')+_cnewpro))
		MsgBox("Produto a Reformar : "+_cnewpro+" não cadastrado!","Favor cadastrar e depois fazer a entrada massiva novamente","ALERT")
		_lret:=.F.
	Endif
ElseIf cver =='4'
	SB1->(dbSetorder(1)) // B1_FILIAL + B1_COD
	SB1->(dbSeek(xFilial("SB1") + cProd))
	ZZ4->(dbSetorder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
	If SD1->(dbSeek(xFilial('SD1')+cdoc+cser+ccli+cloja+cProd) )
		If ZZ4->(dbSeek(xFilial("ZZ4") + SD1->D1_DOC + SD1->D1_SERIE + mv_par01 + mv_par02 + SD1->D1_COD + cimei ))
			Reclock("ZZ4",.F.)
			ZZ4->ZZ4_NFEDT  := SD1->D1_DTDIGIT
			ZZ4->ZZ4_NFEHR  := Posicione("SF1",1,xFilial("SF1")+cdoc+cser+ccli+cloja+'N',"F1_HORA")
			ZZ4->ZZ4_DOCDTE := SD1->D1_DTDOCA
			ZZ4->ZZ4_DOCHRE := left(SD1->D1_HRDOCA,2)+":"+substr(SD1->D1_HRDOCA,3,2)+":00"
			ZZ4->ZZ4_Local  := SD1->D1_LOCAL
			ZZ4->ZZ4_GRPPRO := SB1->B1_GRUPO
			MsUnlock()
		Endif
	Endif
Endif

Return(_lret)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECX11GR2ºAutor  ³ Edson Rodriguesº Data ³  18/01/2009      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava registro no ZZ4 e atualiza Memo - Operacao Refurbish  ##
## Nextel - Gera os IMEIS                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function tecx11gr2(cCodBar,Memo,cVARSIM,_lAuto,_nqtde,_coper,cprefixo,cgeraimei)

Local nVlZ1      := 0.00
Local lResult    := .T.
Local tMemo      := ""
Local prefix     := cprefixo
Local _cCodPro   := mv_par03
Local _nVlrUnit  := mv_par06
Local _ctipentr  := mv_par07
Local _lvalsza   := .F.
Local _clote     :=""
Local _cdpyim    :=""
Local _cgvsos    :=""
Local _cLocal    :=""
Local _nVez      := 0
Local _cITEMD1   := ""
Local _cfornsrf  := ""
Local _cljforsrf := ""
Local nTam       := 14
Local _ccalcgar  := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_coper), "ZZJ_CALGAR")


// So executa a validacao se o codigo de barra Não estiver preenchido
If ALLTRIM(cCodBar)='' .and. _nqtde >  0  .AND. cgeraimei="02"
	
	For I=1 To _nqtde
		tMemo:=""
		CNEWIMEFL:=''
		//If  (GetMV("MV_XIMEFLI",.T.))  Alterado para buscar o ultimo código gerado na base de dados -- Edson Rodrigues - 23/02/10
		//	cCodBar := Soma1(Subs(GetMV("MV_XIMEFLI"),1,nTam))
		CNEWIMEFL:=ULTIMEFL(prefix)
		If !Empty(CNEWIMEFL)
			If prefix='IT' .AND. ABS(VAL(Subs(CNEWIMEFL,3,12))) < 10000
				CNEWIMEFL:='IT0000000100000'
				cCodBar  := Soma1(Subs(CNEWIMEFL,3,12))
			ELSE
				cCodBar := Soma1(Subs(CNEWIMEFL,3,12))
			Endif
		Else
			//			 ApMsgInfo("Ultimo IMEI nao encontrado. Contate o Administrador. ","IMEI nao cadastrado!")
			//           Conforme e-mail Enviado pelo Edson 21/05/10 se nao achar imei pegar prefixo e gerar novo
			//			 Return
			CNEWIMEFL:= prefix + '000000000000'
			cCodBar  := Soma1(Subs(CNEWIMEFL,3,12))
		Endif
		
		
		
		// Calcula o digito verificador para IMEI Refurbish FLIP
		cCodBar:=prefix+cCodBar+U_GDVan(cCodBar)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//Verifica se o produto possui controle de endereço e bloqueia //Edson Rodrigues - 11/12/09 Ä
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		If SB1->(dbSeek(xFilial("SB1") + _cCodPro)) .and. (SB1->B1_LOCALIZ == "S")
			MsgBox("O Produto: "+alltrim(_cCodPro)+" com controle de Localizacao. Rotina não preparada para produtos com controle de localização !","Produtos com controle de localização","ALERT")
			tMemo += "O Produto: "+alltrim(_cCodPro)+" com controle de Localizacao - Rotina não preparada para produtos com controle de localização "+LFRC
			Memo:=tMemo+Memo
			cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
			If ValType(oDlg)=="O"
				Close(oDlg)
			Endif
			Return
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se base instalada ja existe                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AA3")
		dbSetorder(4)
		If dbSeek(xFilial("AA3") + Space(8) + _cCodPro + cCodBar)
			tMemo+='------Ja Existe Base Instalada!------'+LFRC+LFRC
			Memo:=tMemo+Memo
		Endif
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se IMEI ja sofreu entrada massiva                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ZZ4->(dbSetorder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
		//	ZZ4->(dbGoTop())
		//If ZZ4->(dbSeek(xFilial('ZZ4')+cCODBAR))
		If ZZ4->(dbSeek(xFilial('ZZ4')+cCODBAR)) .or. ZZ4->(dbSeek("02"+cCODBAR))
			If ZZ4->ZZ4_STATUS <> '9' // NFS gerada
				// Coloquei essa condição porque se acaso o IMEI já tenha sido gravado por outro processo ou
				// a query da funcao ULTIMEFL nao encontre o IMEI gravado anteririormente dentro desse for-next
				// Edson Rodrigues - 20/04/10
				CNEWIMEFL:=''
				CNEWIMEFL:=ULTIMEFL(prefix)
				If !Empty(CNEWIMEFL)
					cCodBar := Soma1(Subs(CNEWIMEFL,3,12))
					cCodBar :=prefix+cCodBar+U_GDVan(cCodBar)
				Endif
				//tMemo   += '------Esse celular já foi registrado--------'+LFRC+LFRC
				//Memo:= tMemo+Memo
				//cCodBar += Replicate(' ',20)
				//Close(oDlg)
				//Return
			else
				//Procura IMEI na filial 02 - Luciano - Delta
			    ZZ4->(dbSetorder(1))
				If ZZ4->(dbSeek("02"+cCODBAR))
					While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == "02" .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar)
						If ZZ4->ZZ4_STATUS=='9'
							_nVez++
						Endif
						ZZ4->(dbSkip())
					EndDo
				EndIf   
				
				//Procura IMEI na filial corrente - Luciano - Delta
			    ZZ4->(dbSetorder(1))
				If ZZ4->(dbSeek(xFilial('ZZ4')+cCODBAR))
					While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar)
						If ZZ4->ZZ4_STATUS='9'
							_nVez++
						Endif
						ZZ4->(dbSkip())
					EndDo
				Endif
			    /*
				While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar) .and.;
					mv_par01 == ZZ4->ZZ4_CODCLI .and. mv_par02 == ZZ4->ZZ4_LOJA .and. alltrim(_cCodPro) == alltrim(ZZ4->ZZ4_CODPRO)
					_nVez++
					ZZ4->(dbSkip())
				EndDo
				*/
			Endif
		Endif
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a OS esta em atendimento                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !_lAuto .and. !Tecx011G(_cCodPro,cCodBar)
			tMemo += '------Esse aparelho esta em atendimento--------'+LFRC+LFRC
			Memo:=tMemo+Memo
			cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
			If ValType(oDlg)=="O"
				Close(oDlg)
			Endif
			Return
		Endif
		
		If Empty(mv_par16) .AND. _ccalcgar='S'
			mv_par16:=U_Vergaran(cCodBar,mv_par09,cCodBar)
			If Empty(mv_par16)
				tMemo := '------Carcaça Invalida--------'+LFRC+LFRC
				Memo  := tMemo+Memo
				cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
				If !_lAuto
					If ValType(oDlg)=="O"
						Close(oDlg)
					Endif
				Endif
				Return
			Endif
		Endif
		
		
		
		Reclock('ZZ4',.T.)
		ZZ4->ZZ4_FILIAL 	:= xFilial('ZZ4')
		ZZ4->ZZ4_CODCLI 	:= mv_par01 //Cliente?
		ZZ4->ZZ4_LOJA   	:= mv_par02 //Loja?
		ZZ4->ZZ4_IMEI 		:= cCodBar
		ZZ4->ZZ4_CARCAC		:= cVarSIM //SIM/Caraça
		ZZ4->ZZ4_CODPRO 	:= _cCodPro //Produto? (mv_par03)
		ZZ4->ZZ4_GRPPRO		:= Posicione("SB1",1,xFilial("SB1") + _cCodPro, "B1_GRUPO")
		ZZ4->ZZ4_VLRUNI	    := _nVlrUnit //Valor do Produto (mv_par06)
		ZZ4->ZZ4_OPER   	:= mv_par07 //Operacao
		ZZ4->ZZ4_KIT    	:= Iif(mv_par08==1,"S","N")  // Nicoletti
		ZZ4->ZZ4_OS     	:= Space(6)
		ZZ4->ZZ4_EMUSER   	:= cUserName //Nome do usuario que gerou registro
		ZZ4->ZZ4_EMDT   	:= Date() //Log
		ZZ4->ZZ4_EMHR   	:= Time() //Log
		ZZ4->ZZ4_NFENR    	:= mv_par04   //Indica a Nota Fiscal de Entrada
		ZZ4->ZZ4_NFESER  	:= mv_par05 //Indica a Nota Fiscal de Entrada
		ZZ4->ZZ4_STATUS  	:= "1" //Indica que eh uma Entrada Massiva que esta sendo apontada
		ZZ4->ZZ4_LOTIRL     := _clote
		ZZ4->ZZ4_DPYIME     := _cdpyim
		ZZ4->ZZ4_GVSOS      := _cgvsos
		ZZ4->ZZ4_LOCAL      := _clocal
		ZZ4->ZZ4_NUMVEZ     := _nVez+1
		ZZ4->ZZ4_OPEBGH     := mv_par09
		ZZ4->ZZ4_GARANT     := mv_par16 //Iif(Empty(mv_par16),U_Vergaran(cVarSim,mv_par09),mv_par16)
		ZZ4->ZZ4_OSAUTO     := mv_par10
		ZZ4->ZZ4_ITEMD1     := _cITEMD1
		ZZ4->ZZ4_GARMCL     := CalcGarMCL(CCODBAR) // M.Munhoz - Ticket 3211 - alterado em 05/03/2012
		ZZ4->ZZ4_FORMUL		:= Iif(cForm==aForm[2],"S","N")
		ZZ4->ZZ4_PALLET		:= cPallet
		
		MsUnLock('ZZ4')
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui parametro no SX6.                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//PutMv ("MV_XIMEFLI",SUBSTR(cCodBar,3,12))
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(dbSeek(xFilial('SB1')+_cCodPro))
		If !_lAuto
			tMemo += 'Item: '+STRZERO(I,5)+LFRC
			tMemo += 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
			tMemo += 'Produto: '+_cCodPro+' Descricao: '+SB1->B1_DESC+LFRC
			tMemo += 'SN: '+cCodBar+'   SIM/Carcaça: '+cVarSIM+LFRC
			tMemo += 'NF: '+mv_par04+' Série: '+mv_par05+' Valor: '+Transform(_nVlrUnit,'@E 999,999.99999')+LFRC
			If _nVez > 0
				tMemo += 'Este aparelho já sofreu '+alltrim(str(_nVez))+' entrada(s) anterior(es) a esta.'+LFRC
			Endif
			_nVez := 0
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se eh SWAP ANTECIPADO                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !_lAuto
			_aAreaSC6 := SC6->(GetArea())
			SC6->(DBOrderNickName('SC6XIMEOLD'))//SC6->(dbSetorder(10))// C6_FILIAL + C6_XIMEOLD + C6_NUM + C6_ITEM
			If SC6->(dbSeek(xFilial("SC6") + cCodBar))
				ApMsgInfo("Este IMEI refere-se a aparelho em SWAP ANTECIPADO. ","SWAP ANTECIPADO!")
				tMemo += "SWAP ANTECIPADO: PV/ITEM -> "+SC6->C6_NUM+"/"+SC6->C6_ITEM+" == NF/SERIE -> "+SC6->C6_NOTA+"/"+SC6->C6_SERIE+LFRC
				Reclock("ZZ4",.F.)
				ZZ4->ZZ4_SWANT := SC6->C6_NUM+SC6->C6_ITEM
				MsUnlock()
			Endif
			RestArea(_aAreaSC6)
		Endif
		
		If !_lAuto
			tMemo += LFRC
			Memo:=tMemo+Memo
			If ValType(oDlg)=="O"
				Close(oDlg)
			Endif
		Endif
		
		
	Next
	
	cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
	cVarSIM:=Replicate(' ',25)
	mv_par18 := Space(nTamNfe) // NF de Compra
	mv_par19 := CtoD("  /  / ")  // Data da NF de Compra
	mv_par21 := Space(3)
	mv_par22 := Space(18)
	mv_par23 := Space(14)
	mv_par12 := "C0022 "  // RECL. CLIENTE
	mv_par13 := Space(06) //OPERADORA
	mv_par14 := Space(06) //TRANSPORT
	mv_par15 := "N" //ACESSORIO
	mv_par16 := ""  // GARANTIA SIM OU NAO
	mv_par17 := Space(20) // CONHECIMENTO/LACRE
	mv_par24 := Space(nTamNfe) // NF de Troca
	mv_par25 := Space(3) // Serie NF Troca
	mv_par26 := CtoD("  /  / ") // Data da NF de Troca
	mv_par27 := Space(18) //CNPJ/CPF NF Troca


	UltReg:=.T.
Endif


Return(lResult)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GDVan   ºAutor  ³ Edson Rodriguesº Data ³  18/01/2009     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera digito verificador para o código EAN                   ##
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GDVan(arg1)
/*
* recebe : codigo EAN (12 digitos)
* retorna: digito vereificador (1 digito)
* --------------------------------------------------------------------------- *
*/
Local arg1 :=  strzero(val(arg1),12)
Local y1   :=  val(subs(arg1,2,1)) +val(subs(arg1,4,1)) +val(subs(arg1,6,1)) +;
val(subs(arg1,8,1)) +val(subs(arg1,10,1)) +val(subs(arg1,12,1))
Local y2   :=  val(subs(arg1,1,1)) +val(subs(arg1,3,1)) +val(subs(arg1,5,1)) +;
val(subs(arg1,7,1)) +val(subs(arg1,9,1)) +val(subs(arg1,11,1))
Local y0   := 3 * y1 + y2

y0   := 10 * (int(y0 / 10.0) + 1) - y0
y0   := if(y0 = 10, 0, y0)

Return(str(y0,1))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ULTIMEFL  ºAutor  ³ Edson Rodrigues    º Data ³  23/02/2010º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ busca o ultimo IMEI FLIP gerado- Processo Flip Nextel
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ULTIMEFL(prefix)
CNEWIMEFL:=""
cQryFLI :=  " SELECT MAX(ZZ4_IMEI) AS IMEIFLP FROM  "+RetSQLName('ZZ4')+" ZZ4 (nolock) "
cQryFLI += " WHERE ZZ4_FILIAL='"+xFilial('ZZ4')+"' AND LEFT(ZZ4_IMEI,2)='"+prefix+"' AND D_E_L_E_T_= '' "

TCRefresh(RetSQLName('ZZ4'))
TCQUERY cQryFLI NEW ALIAS "cQryFLI"

If !cQryFLI->(EOF())
	CNEWIMEFL:=cQryFLI->IMEIFLP
Endif

dbSelectArea('cQryFLI')
cQryFLI->(dbCloseArea())

Return(CNEWIMEFL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F9ENTR   ºAutor  ³ Edson Rodrigues    º Data ³  18/08/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro para alteracao dos parametros inciciais via F9 da º±±
±±º          ³ Entrada Massiva.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F9ENTR()

Local cKit    := "N"
Local _lOk    := .F.
Local cvaldsza :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_DADSZA")
Local ltravc  :=Iif(cvaldsza='N',.T.,.F.)


If mv_par08==1
	cKit   := "S"
Endif

If !ltravc
	cDescr:=Space(40)
Endif

@ 116,095 To 345,636 Dialog F9ENTR Title OemToAnsi("F9 Parametros Entrada Massiva")

@ 002,009 To 080,257 Title OemToAnsi("F9 Entrada Massiva")
@ 001,002 Say OemToAnsi("Produto:")         Size 22,8
@ 001,012 Say OemToAnsi("Descrição:")       Size 27,8
@ 002,002 Say OemToAnsi("Nota Fiscal:")     Size 29,8
@ 002,012 Say OemToAnsi("Serie:")           Size 14,8
@ 003,002 Say OemToAnsi("Valor Unitario:")  Size 35,8
@ 004,002 Say OemToAnsi("Tipo de Entrada:") Size 41,8
@ 004,012 Say OemToAnsi("Descrição:")       Size 26,8
@ 005,002 Say OemToAnsi("KIT S/N:")         Size 13,8
@ 005,012 Say OemToAnsi("Pallet:")          Size 13,8

@ 005,016 COMBOBOX oPallet VAR cPallet ITEMS aPallet Size 30 ,50 

@ 011,036 Get mv_par03 	Size 050,010 Picture "@!" 	When ltravc Valid(u_Tecx011B(mv_par03,"2") .and. ExistCpo("SB1",mv_par03))  F3 'SB1'	Object oCodProd  //Colocado F3 Produto --> Edson Rodrigues - 23/06/10
@ 011,122 Get cDescr   	Size 124,010 When .F.
@ 024,050 Get mv_par04  Size 024,010 Picture "999999999"   When ltravc 	Valid(u_Tecx011B(mv_par04,"5"))     							Object oNota
@ 024,122 Get mv_par05  Size 010,010 Picture "!!!" When ltravc
@ 037,050 Get mv_par06 	Size 042,010 Picture "@E 999,999.99999"  When ltravc Valid(u_Tecx011B(mv_par06,"3"))  								Object oValUnit
@ 050,055 Get mv_par07 	Size 023,010 Picture "@!" When ltravc Valid ExistCpo("SX5","Z1"+mv_par07).AND.u_Tecx011B(mv_par07,"4") F3 'Z1' 	Object oTpEntr
@ 050,122 Get cEntr    	Size 125,010 When .F.
@ 063,036 Get cKit      Size 005,010 Picture "!"  When ltravc Valid(u_Tecx011B(@cKit,"6")) 												Object oKIT

@ 083,120 BMPBUTTON TYPE 1 Action (_lOk := .T., Close(F9ENTR))
@ 083,160 BMPBUTTON TYPE 2 Action (_lOk := .F., Close(F9ENTR))

Activate Dialog F9ENTR
If alltrim(cKit) == "S"
	mv_par08 := 1
ElseIf alltrim(cKit) == "N"
	mv_par08 := 2
Endif

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011o  ºAutor  ³ Edson Rodrigues   º Data ³  09/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exluí apontamentos conforme confirmacao do usuario e       º±±
±±º            Fecha a janela de Entrada Massiva                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011o()
Local _cUpdZZ4 :=""
Local _cUpdSZC :=""
Local _infaces := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_INFACE")
Local _cvlope  := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_TROPEN")  // variavel que indica se deve fazer validação de troca de operação

_cUpdZZ4 := " UPDATE "+RETSQLNAME("ZZ4")+" SET D_E_L_E_T_ = '*' "
_cUpdZZ4 += " WHERE ZZ4_FILIAL = "+xFilial("ZZ4")+" AND "
_cUpdZZ4 += "       ZZ4_STATUS = '1' AND "
_cUpdZZ4 += "       D_E_L_E_T_ = ''  AND "
_cUpdZZ4 += "       SUBSTRING(ZZ4_EMUSER,1,13) = '"+Substr(cUserName,1,13)+"' "
If _cvlope <> "S"  .and. !lselqrytst
	_cUpdZZ4 += "       AND ZZ4_OPEBGH = '"+ALLTRIM(mv_par09)+"'"
Endif

tcSqlExec( _cUpdZZ4)
TCREFRESH(RETSQLNAME("ZZ4"))

If _infaces="S"
	_cUpdSZC := " UPDATE "+RETSQLNAME("SZC")+" SET D_E_L_E_T_ = '*' "
	_cUpdSZC += " WHERE ZC_FILIAL  = "+xFilial("SZC")+" AND "
	_cUpdSZC += "       ZC_DOC     = '"+ALLTRIM(mv_par04)+"' AND "
	_cUpdSZC += "       ZC_SERIE   = '"+ALLTRIM(mv_par05)+"' AND "
	_cUpdSZC += "       ZC_FORNECE = '"+ALLTRIM(mv_par01)+"' AND "
	_cUpdSZC += "       ZC_LOJA    = '"+ALLTRIM(mv_par02)+"' AND "
	//      _cUpdSZC += "       ZC_CODPRO  = '"+ALLTRIM(mv_par03)+"' AND " desabilitado - Edson Rodrigues - 01/10/10
	_cUpdSZC += "       ZC_STATUS = '0' AND "
	_cUpdSZC += "       D_E_L_E_T_ = '' "
	
	tcSqlExec( _cUpdSZC)
	TCREFRESH(RETSQLNAME("SZC"))
Endif

If Len(_aetqentm) > 0
	For x:=1 To Len(_aetqentm)
		_cUpdZZO := " UPDATE "+RETSQLNAME("ZZO")+" SET ZZO_STATUS = '1' "
		_cUpdZZO += " WHERE ZZO_FILIAL = '"+xFilial("ZZO")+"'    AND "
		_cUpdZZO += "       ZZO_NUMCX  = '"+_aetqentm[x,1]+"'  AND "
		_cUpdZZO += "       ZZO_STATUS = '2' AND ZZO_SEGREG<>'S' AND "
		_cUpdZZO += "       D_E_L_E_T_ = ''"
	
		tcSqlExec( _cUpdZZO)
		TCREFRESH(RETSQLNAME("ZZO"))
	Next
Endif

_lFechEM := .T.
If ValType(oDlg)=="O"
	Close(oDlg)
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³seltriag  ºAutor  ³ Edson Rodrigues    º Data ³  08/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona e processa aparelhos do processo Triagem         º±±
±±º                                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function seltriag(cCodBar,Memo,cVARSIM,cVarmst,_lAuto)

Local _imeistat := {}
Local _aAreaZZO := ZZO->(GetArea())
Local _lValid   := .F.
Local _lqrytri  := .F.
Local cstattri  := ""
Local oDlgstriag

If Select("XZZO") > 0
	XZZO->(dbCloseArea())
Endif

If Empty(cVarmst)
	_lqrytri:=.T.
	cVarmst:=Replicate(' ',20)
	//oEdmst:SetFocus()
	return
Endif

//_cQrytri := " SELECT ZZO_IMEI,ZZO_CARCAC,ZZO_NVEZ,ZZO_GARANT,ZZO_DBOUNC,ZZO_STATUS,ZZO_MODELO,R_E_C_N_O_ AS RECNOZZO "
_cQrytri := " SELECT *, R_E_C_N_O_ AS RECNOZZO "
_cQrytri += " FROM   "+RetSqlName("ZZO")+" (nolock) "
_cQrytri += " WHERE  ZZO_FILIAL  = '"+xFilial("ZZO")+"' AND "
_cQrytri += "        ZZO_NUMCX  = '"+cVarmst+"'  AND "
_cQrytri += "        ZZO_STATUS  < '2'  AND "
_cQrytri += "        ZZO_DESTIN  = 'B'  AND "
_cQrytri += "        ZZO_SEGREG  <> 'S'  AND "
_cQrytri += "        ZZO_ENVARQ  = 'S'  AND "
_cQrytri += "        D_E_L_E_T_  = '' "
_cQrytri += " ORDER BY ZZO_NUMCX,ZZO_MODELO "

TCQUERY _cQrytri NEW ALIAS "XZZO"
//dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrytri),"XZZO",.T.,.T.)

dbSelectArea("XZZO")
XZZO->(dbGoTop())
While XZZO->(!eof())
	_lqrytri:=.T.
	If XZZO->ZZO_STATUS ='1'
		If Upper(left(_cOrigem,8)) $ "BGHTRIAG"
			mv_par01 := XZZO->ZZO_CLIENT
			mv_par02 := XZZO->ZZO_LOJA
			mv_par03 := XZZO->ZZO_MODELO
			mv_par04 := XZZO->ZZO_NF
			mv_par05 := XZZO->ZZO_SERIE
			mv_par06 := XZZO->ZZO_PRECO
			mv_par07 := "05"
			mv_par08 := 2
			mv_par09 := right(_cOrigem,3)
			mv_par10 := Space(12) //OS SAM
			mv_par11 := Space(11) // COD. AUTORIZ.
			mv_par12 := "C0022 "  // RECL. CLIENTE
			mv_par13 := Space(06) //OPERADORA
			mv_par14 := Space(06) //TRANSPORT
			mv_par15 := "N" //ACESSORIO
			mv_par16 := XZZO->ZZO_GARANT  // GARANTIA SIM OU NAO
			mv_par17 := Space(20) // CONHECIMENTO/LACRE
			mv_par18 := Space(nTamNfe) // NF de Compra
			mv_par19 := CtoD("  /  / ")  // Data da NF de Compra
			mv_par20 := Space(30)
			mv_par21 := Space(3)
			mv_par22 := Space(18)
			mv_par23 := Space(14)
			mv_par24 := Space(nTamNfe) // NF de Troca
			mv_par25 := Space(3) // Serie NF Troca
			mv_par26 := CtoD("  /  / ") // Data da NF de Troca
			mv_par27 := Space(18) //CNPJ/CPF NF Troca

		Endif
		If mv_par03==XZZO->ZZO_MODELO
			cVarBar  :=XZZO->ZZO_IMEI
			cVarSim  :=XZZO->ZZO_CARCAC
			mv_par16 :=XZZO->ZZO_GARANT
			mv_par03 :=XZZO->ZZO_MODELO
			nvez     :=XZZO->ZZO_NVEZ
			nbounce  :=Iif(XZZO->ZZO_DBOUNC='',0,XZZO->ZZO_DBOUNC)
			_lValid   :=u_Tecx011Grv(@cVarBar,@cTexto,@cVarSim,.T.,nvez,cVarmst,nbounce)
		ELSE
			If MSGYESNO("O MODELO : +"+ALLTRIM(XZZO->ZZO_MODELO)+ " DIFERENTE DO MODELO ANTERIOR : "+alltrim(mv_par03)+ ". QUER ALTERAR O VALOR ATUAL :" +Transform(mv_par06,'@E 999,999.99999')+" ? ")
				nprealte:=u_tropreco(mv_par06)
				_ltroprec:=.T.
				If nprealte==mv_par06
					_ltroprec:=.F.
					If !MSGYESNO("VOCE NAO ALTEROU O PREÇO ATUAL : " +Transform(mv_par06,'@E 999,999.99999')+" para o novo modelo : "+ALLTRIM(XZZO->ZZO_MODELO)," CONFIRMA ? ")
						nprealte:=u_tropreco(mv_par06)
						_ltroprec:=.T.
						mv_par06:= nprealte
					Endif
				ELSE
					mv_par06:= nprealte
				Endif
			Endif
			
			cVarBar  :=XZZO->ZZO_IMEI
			cVarSim  :=XZZO->ZZO_CARCAC
			mv_par16 :=XZZO->ZZO_GARANT
			mv_par03 :=XZZO->ZZO_MODELO
			nvez     :=XZZO->ZZO_NVEZ
			nbounce  :=Iif(XZZO->ZZO_DBOUNC='',0,XZZO->ZZO_DBOUNC)
			_lValid   :=u_Tecx011Grv(@cVarBar,@cTexto,@cVarSim,.T.,nvez,cVarmst,nbounce)
		Endif

		If _lvalid
			ZZO->(dbgoto(XZZO->RECNOZZO))
			Reclock("ZZO",.F.)
			ZZO->ZZO_STATUS :='2'
			MsUnLock('ZZO')
		Endif
		
	ELSE
		AADD(_Imeistat,{XZZO->ZZO_IMEI,XZZO->ZZO_STATUS})
	Endif
	XZZO->(dbSkip())
EndDo

If !_lqrytri
	MsgBox("Codigo master de triagem CLA invalido ou já foi processado esse código !","Cod triagem CLA invalido","ALERT")
	_lqrytri:=.T.
	//cVarmst:=Replicate(' ',20)
	//oEdmst:SetFocus()
	return
Endif

If Len(_imeistat) > 0
	For x:=1 To Len(_imeistat)
		If x=1
			cstattri:="IMEI :"+_imeistat[x,1]+" Status :"+_imeistat[x,2]+LFRC
		ELSE
			cstattri+="IMEI :"+_imeistat[x,1]+" Status :"+_imeistat[x,2]+LFRC
		Endif
	Next
	
	MsgBox("Houveram IMEIS que nao passaram por todas as estapas da triagem no CLA. Por favor verifique !","Status Triagem invalido","ALERT")
	
	@ 0,0 To 400,420 Dialog ODlgstriag Title "Imeis Status Invalido na Triagem CLA"
	@ 05,005 Say oV1 var Alltrim(cUserName)+',' Of oDlgstriag FONT oFnt2 Pixel Size 150,010
	@ 15,005 Say oV2 var "confirme os IMEIs  abaixo listados." Of oDlgstriag FONT oFnt2 Pixel Size 150,012
	@ 25,005 Get cstattri Size 195,115 MEMO Object oMemostatr
	@ 140,130 BMPBUTTON TYPE 1 Action (oDlgstriag:End())

	oMemostatr:oFont:=oFnt3
	Activate MsDialog oDlgstriag Centered

Endif

If _lqrytri
	aadd(_aetqentm,{cVarmst})
Endif

cVarmst:=Replicate(' ',20)
//oEdmst:SetFocus()

Return(_lqrytri)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tropera   ºAutor  ³ Edson Rodrigues    º Data ³  08/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Troca operacao                                             º±±
±±º                                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tropera(copatu)
// Variaveis Private da Funcao
Private otrcper
_copatu :=copatu

Define MsDialog oDlgtop Title "Operacoes" FROM C(306),C(324) To C(465),C(534) Pixel
	// Cria as Groups do Sistema
	@ C(001),C(002) To C(080),C(103) LABEL "Operação" Pixel Of oDlgtop
	// Cria Componentes Padroes do Sistema
	@ C(015),C(004) Say "Operacao" Size C(018),C(008) COLOR CLR_BLACK Pixel Of oDlgtop
	@ C(014),C(025) MsGet otrcper Var _copatu F3 "ZZJ"  Valid ExistCpo("ZZJ",_copatu).AND.u_Tecx011B(_copatu,"10")  Size C(052),C(009) COLOR CLR_BLACK Pixel Of oDlgtop
Define SBUTTON FROM C(058),C(043) TYPE 1 ENABLE Of oDlgtop Action (oDlgtop:end())

Activate MsDialog oDlgtop CENTERED

Return(_copatu)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³APBOUNCE  ºAutor  ³Edson Rodrigues     º Data ³  09/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Abre tela para selecionar o(s) aparelho Bounce              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function APBOUNCE(ndias,_capbounc)

Local aSalvAmb  := {}
Local cVar      := Nil
Local oDlg      := Nil
Local cTitulo   := "Aparelho Bounce "+strzero(ndias,3)+" dias"
Local lMark     := .F.
Local oOk       := LoadBitmap( GetResources(), "LBOK" )
Local oNo       := LoadBitmap( GetResources(), "LBNO" )
Local oChk      := Nil

Private lChk   := .F.
Private oLbx   := Nil
Private aVetor := {}
Private _nOpcx := 0
//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
aAdd( aVetor, { lMark,_capbounc, strzero(ndias,3), 0 })

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
	Aviso( cTitulo, "Nao existem ap. bounce a consultar", {"Ok"} )
	Return
Endif

Define MsDialog oDlg Title cTitulo FROM 0,0 To 240,500 Pixel
	@ 10,10 ListBox oLbx VAR cVar FIELDS HEADER " ", "IMEI Bounce", "Qtde Dias","Qde Aparelho" Size 230,095 Of oDlg Pixel ON dblClick(aVetor[oLbx:nAt,1] :=desmarc(oLbx:nAt,aVetor),oLbx:Refresh())
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4]}}
	//	@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" Size 60,007 Pixel Of oDlg ON CLICK(Iif(lChk,Marca(lChk),Marca(lChk)))
	Define SBUTTON FROM 107,173 TYPE 2 Action (_nOpcx:=0,oDlg:End()) ENABLE Of oDlg  // Cancelar
	Define SBUTTON FROM 107,213 TYPE 1 Action (_nOpcx:=1,Iif(marcou(),oDlg:End(),ODlg)) ENABLE Of oDlg  // OK
Activate MsDialog oDlg CENTER

Return ()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Desmarca  ºAutor  ³ Edson Rodrigues   º Data ³  08/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ desmarca os acessorios ja marcados caso seja marcado outro º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function desmarc(n,aArray)
Local lret:=!aArray[n,1]

For i := 1 To Len(aVetor)
	If aVetor[i]==aVetor[n]
		aVetor[i][1] := .F.
		aVetor[i][4] := 1
	Else
		aVetor[i][1] := .F.
		aVetor[i][4] := 0
	Endif
Next i
oLbx:Refresh()

Return lret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ marcou   ºAutor  ³ Edson Rodrigues    º Data ³  11/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se marcous acessorios qdo confirma com OK         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function marcou()
Local lret:=.F.

If Len(aVetor) > 0
	For i:=1 To Len( aVetor)
		If aVetor[i,1]
			lret:=.T.
		Endif
	Next i
Endif

If !lret
	MsgBox("Favor Separar e marcar o Aparelho !","Aparelho nao selecionado","ALERT")
Endif

Return lret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ qauxtest ºAutor  ³ Edson Rodrigues    º Data ³  26/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Query auxiliar para realizacao de testes de entrada massivaº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function qauxtest()

_cQrytest := " SELECT  TOP 1200 ZZ4_FILIAL,A1_CGC,ZZ4_CODPRO,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_VLRUNI,ZZ4_OPER,ZZ4_NFENR,ZZ4_NFESER,ZZ4_OPEBGH,ZZ4_CARCAC,ZZ4_IMEI,ZA_NFCOMPR,ZA_DTNFCOM,ZA_CODRECL,ZA_CODTRAN,ZA_CODAUTO,ZA_TRACKIN,ZA_OSAUTOR,ZA_INFACES,ZA_CTRLACR,ZA_CPFCLI,ZA_CNPJNFC,ZA_SERNFC,ZA_DEFRECL,ZA_NOMUSER,ZA_SPC,ZA_SPC,ZA_NFTROCA,ZA_DTNFTRO,ZA_CNPJNFT,ZA_GARCARC,ZA_GARNFC,ZA_GARNFT,ZA_EXECAO,ZA_OPERBGH,* "
_cQrytest += " FROM [PROTHEUS].dbo."+RetSqlName("ZZ4")+" ZZ4 (NOLOCK) "
_cQrytest += " INNER JOIN "
_cQrytest += "   (SELECT A1_CGC,A1_COD,A1_LOJA FROM [PROTHEUS].dbo."+RetSqlName("SA1")+" (NOLOCK) WHERE A1_FILIAL= '"+XFILIAL("SA1")+"' AND D_E_L_E_T_='') AS A1 "
_cQrytest += "   ON ZZ4_CODCLI=A1_COD AND ZZ4_LOJA=A1_LOJA "
_cQrytest += " LEFT OUTER JOIN
_cQrytest += "   (SELECT * FROM [PROTHEUS].dbo."+RetSqlName("SZA")+" (NOLOCK) WHERE  ZA_FILIAL= '"+XFILIAL("SZA")+"' AND ZA_DATA='" + DToS(dDataBase) + "' AND  D_E_L_E_T_='' ) AS ZZA
_cQrytest += "   ON ZA_NFISCAL=ZZ4_NFENR AND ZA_SERIE=ZZ4_NFESER AND ZA_IMEI=ZZ4_IMEI AND ZA_CLIENTE=ZZ4_CODCLI AND ZA_LOJA=ZZ4_LOJA
_cQrytest += " WHERE ZZ4.ZZ4_FILIAL= '"+XFILIAL("ZZ4")+"' AND ZZ4_EMDT='" + DToS(dDataBase) + "' AND ZZ4.D_E_L_E_T_=''  AND
_cQrytest += " ZZ4.ZZ4_CODPRO+ZZ4.ZZ4_NFENR+ZZ4.ZZ4_NFESER+ZZ4.ZZ4_IMEI+ZZ4.ZZ4_OPEBGH NOT IN
_cQrytest += " (SELECT ZZ4_CODPRO+ZZ4_NFENR+ZZ4_NFESER+ZZ4_IMEI+ZZ4_OPEBGH FROM [PROTHEUS_DVL].dbo."+RetSqlName("ZZ4")+" ZZ41 (NOLOCK)

//_cQrytest += "  WHERE ZZ41.ZZ4_FILIAL= '"+XFILIAL("ZZ4")+"' AND ZZ4_EMDT='" + DToS(dDataBase) + "' AND ZZ41.D_E_L_E_T_='' ) AND ZZ4.ZZ4_NFESER<>'003'
_cQrytest += "  WHERE ZZ41.ZZ4_FILIAL= '"+XFILIAL("ZZ4")+"' AND ZZ4_EMDT='" + DToS(dDataBase) + "' AND ZZ41.D_E_L_E_T_='' ) AND (ZZ4.ZZ4_NFESER<>'003' or ZZ4.ZZ4_NFESER<>'3')

_cQrytest += "  ORDER BY ZZ4.ZZ4_FILIAL,ZZ4.ZZ4_CODCLI,ZZ4.ZZ4_LOJA,ZZ4.ZZ4_NFENR,ZZ4.ZZ4_NFESER,ZZ4.ZZ4_CODPRO


dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrytest),"QRYTST",.T.,.T.)
TcSetField("QRYTST","ZA_DTNFCOM","D")     //TRANFORMACAO DAS DATAS

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Vdefclie ºAutor  ³ Edson Rodrigues    º Data ³  07/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica defeinto informado do Cliente                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Vdefclie(cimei,clab)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Defeito Reclamado Pelo Cliente                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	Local 	cZMTemp		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	_lQuery    	:= .F.
#Endif


#IFDEF TOP
	_lQuery   := .T.
	BeginSql alias cZMTemp
		SELECT ZZM_DEFINF AS DEFEITO
		FROM %table:ZZM% ZZM
		WHERE ZZM.ZZM_FILIAL = %exp: '02'% 		AND
		ZZM.ZZM_IMEI 	= 	%exp: cimei%        	AND
		ZZM.ZZM_LAB  	= 	%exp: clab %  			AND
		ZZM.ZZM_MSBLQL 	= 	%exp: '2' %  			AND
		ZZM.%notDel%
	EndSql
	
#Endif



If (AllTrim((cZMTemp)->DEFEITO) $ "02077#02103#66666#02130#02131#02082#02083" )
	cRecl := ""
Else
	cRecl		:= (cZMTemp)->DEFEITO
Endif


If _lQuery
	(cZMTemp)->( DbCloseArea())
Endif

Return(cRecl)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tropreco  ºAutor  ³ Edson Rodrigues    º Data ³  10/10/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Troca preço                                                º±±
±±º                                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tropreco(nprecatu)
// Variaveis Private da Funcao
Private otrcprc
_nprcatu :=nprecatu

Define MsDialog oDlgtprc Title "Altera Preço" FROM C(306),C(324) To C(465),C(534) Pixel
	// Cria as Groups do Sistema
	@ C(001),C(002) To C(080),C(103) LABEL "PREÇO" Pixel Of oDlgtprc
	// Cria Componentes Padroes do Sistema
	@ C(015),C(004) Say "Preço" Size C(018),C(008) COLOR CLR_BLACK Pixel Of oDlgtprc
	@ C(014),C(025) MsGet otrcprc Var _nprcatu  Size 052,009 Picture "@E 999,999.99999"  COLOR CLR_BLACK Pixel Of oDlgtprc
	//@ 063,050 Get mv_par06 	Size 042,010 Picture "@E 999,999.99999" 													Valid(u_Tecx011B(mv_par06,"3"))  											Object oValUnit
Define SBUTTON FROM C(058),C(043) TYPE 1 ENABLE Of oDlgtprc Action (oDlgtprc:end())

Activate MsDialog oDlgtprc CENTERED

Return(_nprcatu)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CALCGARMCLºAutor  ³ M.Munhoz           º Data ³  05/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calcular Garantia MCL na Entrada Massiva       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcGarMCL(_cCodBar)

Local _cGarMCL  := "N"
Local _aAreaSZA := SZA->(GetArea())
Local _aAreaZZG := ZZG->(GetArea())
Local _aAreaZZM := ZZM->(GetArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par04 -  Numero da Nota Fiscal de Entrada         ³
//³ mv_par05 -  Serie da  Nota Fiscal de Entrada         ³
//³ mv_par01 -  Cliente                                  ³
//³ mv_par02 -  Loja                                     ³
//³ mv_par09 -  Operação                                 ³
//³ cCodBar  -  IMEI                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SZA->(dbSetorder(1))  // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
ZZG->(dbSetorder(1))  // ZZG_FILIAL + ZZG_LAB + ZZG_CODIGO
ZZM->(dbSetorder(1))  // ZZM_FILIAL + ZZM_LAB + ZZM_IMEI + ZZM_DEFINF + ZZM_DATAOS
If mv_par16 == "S" // Com Garantia
	// Verifica se existe defeito no SZA
	If SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + _cCodBar)) .AND. Alltrim(SZA->ZA_CODRECL) <> "C0022"
		_cGarMCL := "S"
	// Verifica se existe defeito no ZZM
	ElseIf ZZM->(dbSeek(xFilial("ZZM") + "2" + Alltrim(_cCodBar)) )
		// Faz um While no ZZM porque este nao possui chave unica compativel com o ZZ4
		While ZZM->(!Eof()) .AND. ZZM->ZZM_FILIAL == xFilial("ZZM") .and. Alltrim(ZZM->ZZM_IMEI) == Alltrim(_cCodBar) .and. _cGarMCL == "N"
			If ZZM->ZZM_MSBLQL <> '1'
				// Procura o defeito informado no ZZG para verificar se eh C0022
				_cDefInf := left(ZZM->ZZM_DEFINF,5)
				If ZZG->(dbSeek(xFilial("ZZG") + "2" + _cDefInf)) .and. ZZG->ZZG_RECCLI <> "C0022"
					_cGarMCL := "S"
				Endif
			Endif
			ZZM->(dbSkip())
		EndDo
	Endif
EndIf
If mv_par16 == "N" .OR. _cGarMCL == "N" // Sem Garantia da carcaça
	// Testando pela NF Compra
	If SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + _cCodBar)) .AND. !Empty(SZA->ZA_DTNFCOM)
		_cGarMCL := U_Tecx011K(mv_par09, Date(), SZA->ZA_DTNFCOM, 1)
	EndIf
	// testrando pela NF Troca caso pela compra não atenda
	If _cGarMCL == "N" .AND. SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + _cCodBar)) .AND. !Empty(SZA->ZA_DTNFTRO) 
		_cGarMCL := U_Tecx011K(mv_par09, Date(), SZA->ZA_DTNFTRO, 2)
	EndIf
EndIf

If SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + _cCodBar))
	Reclock("SZA",.F.)
	 SZA->ZA_GARNFC := U_Tecx011K(mv_par09, Date(), Iif(Empty(SZA->ZA_DTNFCOM),CTOD("01/01/1900"),SZA->ZA_DTNFCOM), 1)
	 SZA->ZA_GARNFT := U_Tecx011K(mv_par09, Date(), Iif(Empty(SZA->ZA_DTNFTRO),CTOD("01/01/1900"),SZA->ZA_DTNFTRO), 2)   
	MsUnlock()	
EndIf

RestArea(_aAreaSZA)
RestArea(_aAreaZZG)
RestArea(_aAreaZZM)
Return(_cGarMCL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECAXSG1 ºAutor  ³                    º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TECAXSG1(cCodaces,Memoaces,_lAuto,ccodbar,_cCodPro)

Local oDlgSG1
Local oDlgKIT
Local cTitulo	:= "Cadastro Acessorios"
Local oOk      	:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      	:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local nOpcA		:= 0
Local _cKit 	:= Space(15)

Private oLbxSG1
Private aEstru	:= {}
Private nEstru	:= 0
Private nX		:= 1
Private aItens	:= {}

oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
@ 0,0 To 200,300 Dialog oDlgKIT Title "Kit"
oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlgKIT)
@ 05,050 Say oV1 var "Selecione um kit:" Of oDlgKIT FONT oFnt1 Pixel Size 150,010 COLOR CLR_BLUE
@ 40,010 Get _cKit Size 100,080 Picture "@!" Valid ExistCPO('SB1',_cKit)  F3 'SB1'
@ 80,085 BMPBUTTON TYPE 1 Action oDlgKIT:End()
@ 80,120 BMPBUTTON TYPE 2 Action oDlgKIT:End()
Activate MsDialog oDlgKIT Centered

aEstru  := Estrut(_cKit)

If Len(aEstru) == 0
	MsgInfo("O Modelo informado não possui B.O.M!","Cadastro Estrutura")
	Return
Endif

Do While nX <= Len(aEstru)
	SG1->(dbSetorder(1))
	SG1->(dbSeek(xFilial()+aEstru[nX,2]+aEstru[nX,3]+aEstru[nX,5]))
	If SG1->(Found()) .and. (SG1->G1_INI <= dDataBase .and. SG1->G1_FIM >= dDataBase) .and. aEstru[nX,4]>0
		nPos := ascan(aItens, {|x| x[2] == aEstru[nX,3]})
		If nPos == 0
			_cDescPro := Posicione("SB1",1,xFilial("SB1") + aEstru[nX,3], "B1_DESC")
			aadd( aItens, {.T.,aEstru[nX,3], _cDescPro} )
		Endif
	Endif
	nX++
EndDo

Define MsDialog oDlgSG1 Title cTitulo FROM 0,0 To 680,1250 Pixel
	@ 15,10 ListBox oLbxSG1 Fields HEADER ;
	" ", "Peça", "Descrição";
	Size 610,330 Of oDlgSG1 Pixel ON dblClick(aItens[oLbxSG1:nAt,1] := !aItens[oLbxSG1:nAt,1])	
	oLbxSG1:SetArray( aItens )
	oLbxSG1:bLine := {|| {Iif(aItens[oLbxSG1:nAt,1],oOk,oNo),;
	aItens[oLbxSG1:nAt,2],;
	aItens[oLbxSG1:nAt,3]}}
Activate MsDialog oDlgSG1 ON INIT EnchoiceBar(oDlgSG1,{||nOpcA:=1,oDlgSG1:End()},{||oDlgSG1:End()})

If nOpcA == 1
	For i:=1 To Len(aItens)
		aadd(_acess,{mv_par04,mv_par05, mv_par01,mv_par02,cCodBar,Posicione("SA1",1,xFilial("SA1") + mv_par01+mv_par02, "A1_NOME"),;
		_cCodPro,Posicione("SB1",1,xFilial("SB1") + _cCodPro, "B1_DESC"),aItens[i,2],aItens[i,3],aItens[i,2],Iif(aItens[i,1],"S","N")})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If !_lAuto
			tMemo := 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
			tMemo += 'Part. Acess: '+aItens[i,2]+' Descricao: '+aItens[i,3]+LFRC
			tMemo += 'Tipo Acess : '+aItens[i,2]+'-'+aItens[i,3]+LFRC
			tMemo += 'IMEI: '+cCodBar+' NF: '+mv_par04+' Série: '+mv_par05+LFRC
			tMemo += '---------------------------------------------------------------'+LFRC
			Memoaces := tMemo+LFRC+Memoaces+LFRC
		Endif
	Next i
Endif

Return

Static Function AtuNF()
If cForm == aForm[2]
	mv_par04:= "999999999"
	mv_par05:= "999"
Endif
Return
