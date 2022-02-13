#Include "Rwmake.ch"
#include "VKey.ch"
#Include "Colors.ch"
#include "cheque.ch"
#include "topconn.ch"
#define LFRC CHR(13)+Chr(10)
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
User Function tecax011(cOrigem)

	Local cVarBar      := Replicate(' ',20)
	Local cVarSIM      := Replicate(' ',25)
	Local cVarmst      := Replicate(' ',20)
	Local _cvlope      := ''
	
	Public cTexto      := ''
	Public cTextac     := ''
	Public cBkpTexTac  := ''
	Public UltReg      := .F.
	Public _lFechEM    := .F.
	
	Private oV1,oV2
	Private cPerg       := 'BARZZ4'
	Private _nqtde      := 0.00
	Private cgeraimei   :=''
	Private centriage   :='N'
	Private cprefixo    :=' '
	Private nTamNfe     := TAMSX3("D1_DOC")[1]
	Private nTcodpr     := TAMSX3("B1_COD")[1]
	Private cStartPath  := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
	Private cCNPJ       := Space(18)
	Private aForm       := {"Nao","Sim"}	
	Private cForm       := aForm[1]                        
	Private cDescr      := Space(40)
	Private cEntr       := Space(50)
	Private cscrap      := "N"
	Private _cSpc	    := ""
	Private _cnewoper   := Space(3)
	Private aGrupos  	:= aClone(UsrRetGRP())
	Private lUsrAut     := .F.                             	 //Usuarios de Autorizado a excluir IMEI
	Private _aetqentm   := {}   //  array com os codigos master escaneados.
	Private lselqrytst  :=.f.
	Private _lyesema    :=.f.
	Private _lspc433  := .F.
	Private _cPsq	  := GetMv("MV_PERSPC3") 				 // Periodo Parametrizados para Especifico SPC0000433 - Motorola
	Private _cSpr	  := GetMv("MV_SPC0433") 				 // Aparelhos Parametrizados para Especifico SPC0000433 - Motorola
	Private _cOrigem  := IIF(cOrigem <> NIL,cOrigem,"")
	Private _actacess  := {}

u_GerA0003(ProcName())
	
	DBSelectArea('ZZ1')  //Cadastro de Fases
	Dbselectarea("ZZ3")  //Apontamento de fases
	DBSelectArea('SA1')  //Cadastro de Clientes
	DBSelectArea('SB1')  //Cadastro de Produtos
	DBSelectArea('ZZ4')  //Entrada Massiva
	DBSelectArea('AB7')  //Itens da OS
	
	ZZ1->(DbSetOrder(1)) // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET
	ZZ3->(dbSetOrder(1))  // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
	SA1->(DBSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
	SB1->(DBSetOrder(1)) //B1_FILIAL+B1_COD
	ZZ4->(DBSetOrder(2)) //ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI
	AB7->(DBOrderNickName('AB7NUMSER')) //AB7_FILIAL+AB7_NUMOS+AB7_NUMSER
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida acesso de usuario                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i := 1 to Len(aGrupos)
		
		//Usuarios de Autorizado a entrar com NF-Compras
		If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores#Explider"
			lUsrAut  := .T.
		EndIf
		
	Next i
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apresenta tela para digitar informacoes                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// QUERY AUXILIAR PARA TESTES DE ENTRADA MASSIVA AUTOMATICA
	If !UPPER(left(_cOrigem,8)) $ "BGHTRIAG"
		If Substr(Alltrim(Upper(GetEnvServer())),1,5) $ "DEVEL" .and.  MSGYESNO("Deseja fazer a Entrada Massiva automatica ? Atualizar o ambiente de desenvolvimento com dados do ambiente de produção.")
			IF SELECT("QRYTST") > 0
				QRYTST->(dbCloseArea())
			ENDIF
			qauxtest()
			_lyesema:=.t.
		Endif
	Endif
	IF SELECT("QRYTST") > 0  .and. !empty(QRYTST->ZZ4_IMEI)
		_lRetTela  :=.T.
		lselqrytst :=.T.
	ELSE
		IF _lyesema
			MsgBox("Não foi encontrado dados para o processamento da entrada massiva automática !","Sem dados para processamento automático","ALERT")
		ENDIF
		If !UPPER(left(_cOrigem,8)) $ "BGHTRIAG"
			_lRetTela := u_tecx011a()
		Else
			_lRetTela := .T.
			MV_PAR09 := right(_cOrigem,3)
		Endif
	ENDIF
	
	
	If !_lRetTela
		Return()
	endIf
	
	// Incluso para trazer os aparelho ja lidos no nome do usuario e por operacao // Edson Rodrigues 20/04/10.
	ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
	_SerEnt:={}
	_cvlope   := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_TROPEN")  // variavel que indica se deve fazer validação de troca de operação
	
	
	_cQryent := " SELECT ZZ4_CODCLI,ZZ4_LOJA,ZZ4_CODPRO,ZZ4_NFENR,ZZ4_NFESER,ZZ4_IMEI,ZZ4_CARCAC,ZZ4_VLRUNI,ZZ4_ETQMEM "
	_cQryent += " FROM   "+RetSqlName("ZZ4")+" (nolock) "
	_cQryent += " WHERE  ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' AND "
	_cQryent += "        ZZ4_STATUS  = '1' AND " // Entrada Massiva lida
	_cQryent += "        D_E_L_E_T_ = ''  AND "
	IF _cvlope <> "S" .or. !lselqrytst
		_cQryent += "        ZZ4_OPEBGH = '"+ALLTRIM(MV_PAR09)+"'  AND "
	ENDIF
	_cQryent += "        UPPER(LEFT(ZZ4_EMUSER,13)) = '"+Upper(Left(cUserName,13))+"' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryEnt),"X02",.T.,.T.)
	
	dbSelectArea("X02")
	X02->(dbGoTop())
	while X02->(!eof())
		tMemo := 'Cliente: '+X02->ZZ4_CODCLI+' Loja: '+ X02->ZZ4_LOJA+LFRC
		tMemo += 'Produto: '+ALLTRIM(X02->ZZ4_CODPRO)+' Descricao: '+ALLTRIM(SB1->B1_DESC)+LFRC
		tMemo += 'NF: '+ALLTRIM(X02->ZZ4_NFENR)+' Série: '+ALLTRIM(X02->ZZ4_NFESER)+' Valor: '+Transform(X02->ZZ4_VLRUNI,'@E 999,999.99999')+LFRC
		tMemo += 'SN: '+ALLTRIM(ZZ4_IMEI)+'   SIM/Carcaça: '+ALLTRIM(ZZ4_CARCAC)+LFRC
		tMemo += "IMEI/SN ja lido"+LFRC+LFRC
		cTexto := tMemo+cTexto
		AADD(_SerEnt,X02->ZZ4_IMEI  )
		AADD(_aetqentm,{X02->ZZ4_ETQMEM})
		X02->(dbSkip())
	enddo
	If len(_SerEnt) > 0
		tMemo  := "Foram incluidos anteriormente "+Transf(len(_SerEnt),"@E 999,999")+" aparelhos "+LFRC+LFRC
		cTexto := tMemo+cTexto
	endIf
	X02->(dbCloseArea())
	
	// Volta o indice da tabela no indice que estava - Edson Rodrigues 12/04/10
	ZZ4->(dbSetOrder(2)) //ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI
	
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
	If !UPPER(left(_cOrigem,8)) $ "BGHTRIAG"
		IF !lselqrytst
			IF !Empty(MV_PAR09)  .AND. MV_PAR09<>'ZZZ'
				centriage := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_TRIAGE")
				IF centriage = "S" .and.  !MSGYESNO("Deseja fazer a entrada massiva pela Etiqueta Master ? ","Operação Triagem")
					centriage:="N"
				ENDIF
			ENDIF
		ENDIF
	Else
		centriage := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_TRIAGE")
	Endif
	
	While !_lFechEM
		
		@ 0,0 TO 460,520 DIALOG oDlg TITLE "Entrada Massiva"
		oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"CodBar.bmp",.T.,oDlg)
		
		@ 005,077 SAY oV1 var "Passe a leitora de" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
		@ 020,075 SAY oV2 var "código de barras"   of oDlg FONT oFnt1 PIXEL SIZE 150,012 COLOR CLR_BLUE
		
		IF lselqrytst
			_cchavimei:=""
			While !QRYTST->(EOF())
				IF  _cchavimei <> QRYTST->A1_COD+QRYTST->A1_LOJA+QRYTST->ZZ4_NFENR+QRYTST->ZZ4_NFESER+QRYTST->ZZ4_CODPRO+QRYTST->ZZ4_IMEI
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
					MV_PAR09 := QRYTST->ZZ4_OPEBGH
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
					mv_par20 := Space(30)
					MV_PAR21 := SPACE(3)
					MV_PAR22 := SPACE(18)
					MV_PAR23 := SPACE(14)
					cVarBar  := QRYTST->ZZ4_IMEI
					cVarSim  := QRYTST->ZZ4_CARCAC
					
					IF !Empty(MV_PAR09)  .AND. MV_PAR09<>'ZZZ'
						cgeraimei := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_IMEI")
						
						
						IF cgeraimei=="02" 	.AND. _nqtde > 0 .and. !lselqrytst
							cprefixo :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_PREFIX")
							IF MSGYESNO("Confirma a quantidade digitada de: "+STRZERO(_nqtde,4)+" IMEIS a gerar.  Caso nao confirme, devera digitar os parametros novamente.")
								@ 035,010 GET cVarSIM Size 100,080 PICTURE "@!" when .f. valid .T. Object oEdSIM
								@ 050,010 GET cVarBar Size 100,080 PICTURE "@!" when .f. valid .T. Object oEdBar
								Processa({|| u_tecx11gr2(@cVarBar,@cTexto,@cVarSim,.F.,_nqtde,MV_PAR09,cprefixo,cgeraimei)}, "Aguarde...","Gerando IMEIs e validando Atendimento", .T. )
							Else
								_lFechEM:=.T.
								loop
							EndIf
							
						ELSEIF centriage ="S"
							@ 035,010 GET cVarmst Size 100,080 PICTURE "@!" valid u_seltriag(@cVarBar,@cTexto,@cVarSim,@cVarmst,.F.) Object oEdmst
						ELSE
							@ 035,010 GET cVarSIM Size 100,080 PICTURE "@!" valid .T. Object oEdSIM
							@ 050,010 GET cVarBar Size 100,080 PICTURE "@!" valid u_tecx011grv(@cVarBar,@cTexto,@cVarSim,.F.) Object oEdBar
							//Processa({|| u_tecx011grv(@cVarBar,@cTexto,@cVarSim,.T.,0)}, "Aguarde...","Lendo Entrada massiva", .T. )
						ENDIF
					ENDIF
				ENDIF
				QRYTST->(DBSKIP())
			Enddo
			
		Else
			
			IF !Empty(MV_PAR09)  .AND. MV_PAR09<>'ZZZ'
				cgeraimei := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_IMEI")
				
				IF cgeraimei=="02" 	.AND. _nqtde > 0
					cprefixo :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_PREFIX")
					IF MSGYESNO("Confirma a quantidade digitada de: "+STRZERO(_nqtde,4)+" IMEIS a gerar.  Caso nao confirme, devera digitar os parametros novamente.")
						@ 035,010 GET cVarSIM Size 100,080 PICTURE "@!" when .f. valid .T. Object oEdSIM
						@ 050,010 GET cVarBar Size 100,080 PICTURE "@!" when .f. valid .T. Object oEdBar
						Processa({|| u_tecx11gr2(@cVarBar,@cTexto,@cVarSim,.F.,_nqtde,MV_PAR09,cprefixo,cgeraimei)}, "Aguarde...","Gerando IMEIs e validando Atendimento", .T. )
					Else
						_lFechEM:=.T.
						loop
					EndIf
					
				ELSEIF centriage ="S"
					@ 035,010 GET cVarmst Size 100,080 PICTURE "@!" valid u_seltriag(@cVarBar,@cTexto,@cVarSim,@cVarmst,.F.) Object oEdmst
				ELSE
					@ 035,010 GET cVarSIM Size 100,080 PICTURE "@!" valid .T. Object oEdSIM
					@ 050,010 GET cVarBar Size 100,080 PICTURE "@!" valid u_tecx011grv(@cVarBar,@cTexto,@cVarSim,.F.) Object oEdBar
					// Processa({|| u_tecx11gr2(@cVarBar,@cTexto,@cVarSim,.F.,_nqtde,MV_PAR09,cprefixo,cgeraimei)}, "Aguarde...","Gerando IMEIs e validando Atendimento", .T. )
				ENDIF
			ENDIF
			
			
			
			
		Endif
		@ 065,010 GET cTexto  Size 250,115 MEMO Object oMemo when .F.
		@ 202,180 BUTTON "CONFIRMA     " 	SIZE 60,13 ACTION Processa({|| U_tecx011c(.f.) })
		@ 217,180 BUTTON "CANCELA" 			SIZE 60,13 ACTION IIF(MSGYESNO("DESEJA REALMENTE CANCELAR? TODOS APARELHOS DEVERÃO SER APONTADOS NOVAMENTE."),tecx011o(),tecx011e(.F.))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria legenda de funcoes na tela                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		tecx011leg()
		
		If centriage <> "S"
			Activate MSDialog oDlg Centered On Init oEdSIM:SetFocus()
		Else
			Activate MSDialog oDlg Centered On Init oEdmst:SetFocus()
		Endif
		
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Filtro                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//DBCloseArea('ZZ4')
	ZZ4->(DBCloseArea())
	DBSelectArea('ZZ4')

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011a  ºAutor  ³ Edson              º Data ³  20/05/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para digitação das informações iniciais da entrada    º±±
±±º          ³ massiva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx011a()

	Local _lOk := .f.
	
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
	mv_par19 := ctod("  /  / ")  // Data da NF de Compra
	mv_par20 := Space(30)
	mv_par06 := 0.00000
	_nqtde   := 0.0000
	mv_par07 := "05"
	mv_par09 := "ZZZ"
	MV_PAR21 := SPACE(3)
	MV_PAR22 := SPACE(18)
	MV_PAR23 := SPACE(14)
	
	
	@ 116,095 To 465,636 Dialog TelaEntra Title OemToAnsi("Informações da Entrada")
	
	
	@ 002,009 To 039,256 Title OemToAnsi("Cliente")
	@ 001,002 Say "CNPJ:"      Size 16,8
	@ 001,012 Say "Form Proprio:"       Size 16,8
	@ 002,002 Say "Cliente:"   Size 18,8
	@ 002,007 Say OemToAnsi("------")      Size 13,8
	@ 002,012 Say OemToAnsi("Nome:")      Size 16,8
	
	@ 042,009 To 080,257 Title OemToAnsi("Produto")
	@ 004,002 Say OemToAnsi("Produto:")        Size 22,8
	@ 004,012 Say OemToAnsi("Descrição:")      Size 27,8
	@ 005,002 Say OemToAnsi("Valor Unitario:") Size 35,8
	@ 005,012 Say OemToAnsi("Qtde:") Size 35,8
	
	@ 083,009 To 155,258 Title OemToAnsi("Entrada")
	@ 007,002 Say OemToAnsi("Tipo de Entrada:") Size 41,8
	@ 007,012 Say OemToAnsi("Descrição:")       Size 26,8
	
	@ 008,002 Say OemToAnsi("Nota Fiscal:")     Size 29,8
	@ 008,012 Say OemToAnsi("Serie:")           Size 14,8
	@ 008,018 Say OemToAnsi("KIT S/N:")         Size 13,8
	@ 009,002 Say OemToAnsi("Operacao:")        Size 41,8
	@ 009,012 Say OemToAnsi("Descrição:")       Size 26,8
	@ 010,002 Say OemToAnsi("Transportadora:")  Size 29,8
	@ 010,012 Say OemToAnsi("Descrição:")       Size 26,8
	@ 011,002 Say OemToAnsi("CTRC\Lacre:")      Size 26,8
	
	//----------------------------------------------------------------------------
	@ 011,033 Get cCNPJ  Size 59,10  Picture "@R 99.999.999/9999-99" 													Valid(u_tecx011b(cCNPJ,"1"))
	//@ 011,111 Get cCEP   Size 35,10  Picture "@R 99999-999"          													Valid(u_tecx011b(cCEP,"7")) 												Object oCep
	@ 001,017 COMBOBOX oCombo VAR cForm ITEMS aForm SIZE 30 ,50 When IIF(Alltrim(cForm)=aForm[2],.F.,.T.) ON CHANGE Iif(cForm==aForm[2],AtuNF(),.T.)
			
	@ 024,033 Get mv_par01 When .f.  Size 022,010
	@ 024,069 Get mv_par02 When .f.  Size 009,010
	@ 024,122 Get cNome    When .f.  Size 123,010
	
	@ 050,036 Get mv_par03 	Size 050,010 Picture "@!"  																	Valid(u_tecx011b(mv_par03,"2") .and. ExistCpo("SB1",mv_par03))  F3 'SB1'	Object oCodProd  //Colocado F3 Produto --> Edson Rodrigues - 23/06/10
	@ 050,122 Get cDescr   	Size 124,010 								When .f.
	@ 063,050 Get mv_par06 	Size 042,010 Picture "@E 999,999.99999" 													Valid(u_tecx011b(mv_par06,"3"))  											Object oValUnit
	@ 063,122 Get _nqtde 	Size 042,010 Picture "@E 9999.99999" 		When IIF( cgeraimei = '02',.T.,.F.)    		Valid(u_tecx011b(_nqtde,"15"))  											Object oqtde
	@ 090,055 Get mv_par07 	Size 023,010 Picture "@!"  																	Valid ExistCpo("SX5","Z1"+mv_par07).AND.u_tecx011b(mv_par07,"4") F3 'Z1' 	Object oTpEntr
	@ 090,122 Get cEntr    	Size 125,010 								When .f.
	
	@ 103,055 Get mv_par04 Size 024,010 Picture "999999999"  			When IIF(Alltrim(cForm)=aForm[2],.F.,.T.)  	Valid(u_tecx011b(mv_par04,"5")) 											Object oNota
	@ 103,122 Get mv_par05 Size 010,010 Picture "!!!"					When IIF(Alltrim(cForm)=aForm[2],.F.,.T.)
	@ 103,163 Get cKit     Size 005,010 Picture "!"       																Valid(u_tecx011b(@cKit,"6")) 												Object oKIT
	@ 115,055 Get mv_par09 Size 023,010 Picture "@!"                													Valid ExistCpo("ZZJ",mv_par09).AND.u_tecx011b(mv_par09,"9") F3 'ZZJ' 		Object operac
	@ 115,122 Get copera   Size 125,010 								When .f.
	@ 127,055 Get mv_par14 Size 024,010 Picture "@!"  					When IIF(SUBSTR(MV_PAR09,1,1)="N",.T.,.F.)  	Valid ExistCpo("SA4",mv_par14).AND.u_tecx011b(mv_par14,"14") F3 'SA4'	    Object otrans
	@ 127,122 Get ctrans   Size 125,010 								When .f.                        																							Object olacre
	@ 140,055 Get mv_par17 Size 125,010
			
	@ 160, 184 BMPBUTTON TYPE 1 ACTION (_lOk := .T., Close(TelaEntra))
	@ 160, 223 BMPBUTTON TYPE 2 ACTION (_lOk := .f., Close(TelaEntra))
	
	Activate Dialog TelaEntra
	
	If alltrim(cKit) == "S"
		mv_par08 := 1
	elseIf alltrim(cKit) == "N"
		mv_par08 := 2
	endIf

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011b  ºAutor  ³ Edson              º Data ³  20/05/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetuar criticas na digitação de informacoes iniciais      º±±
±±º          ³ da entrada massiva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx011b(cChave,cQual)

	Local cAlias  := ALIAS()
	Local aAlias  := {"SB1","SA1"}
	Local aAmb    := U_GETAMB(aAlias)
	Local lRet    := .t.
	
	SA1->(DbSetOrder(3)) // A1_FILIAL + A1_CGC
	SA1->(DbSeek(xFilial("SA1")+cCNPJ,.f.))
	
	SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
	SB1->(DbSeek(xFilial("SB1")+mv_par03,.f.))
	
	SA4->(DbSetOrder(1)) // A4_FILIAL + A4_COD
	SA4->(DbSeek(xFilial("SA4")+mv_par14,.f.))
	
	ZZJ->(DbSetOrder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
	ZZJ->(DbSeek(xFilial("ZZJ")+ALLTRIM(MV_PAR09),.f.))
	
	
	If cQual == "1" //CNPJ
		If Empty(cChave)
			MsgBox("CNPJ deve ser digitado !","Informações Entrada","ALERT")
			lRet := .f.
		ElseIf !SA1->(DbSeek(xFilial("SA1")+cChave,.f.))
			MsgBox("Não existe cliente cadastrado com o CNPJ digitado, Favor verificar.","Informações Entrada","ALERT")
			lRet := .f.
			
		ElseIf !Cgc(cChave)
			MsgBox("CNPJ ou CPF  digitado invalido, Favor verificar.","Informações Entrada","ALERT")
			lRet := .f.
		Else
			mv_par01 := SA1->A1_Cod
			mv_par02 := SA1->A1_Loja
			cNome    := SA1->A1_Nome
			//oCep:SetFocus()
		EndIf
	elseIf cQual == "2" //Produto
		If Empty(cChave)
			MsgBox("Codigo do produto deve ser digitado !","Informações Entrada","ALERT")
			lRet := .f.
		elseIf !SB1->(DbSeek(xFilial("SB1")+cChave,.f.))
			MsgBox("Este produto não esta cadastrado, Favor verificar.","Informações Entrada","ALERT")
			lRet := .f.
		else
			cDescr := SB1->B1_Desc
			oValUnit:SetFocus()
		endIf
	elseIf cQual == "3" //Valor unitario
		If Empty(cChave)
			MsgBox("Valor unitario deve ser digitado !","Informações Entrada","ALERT")
			lRet := .f.
		else
			oTpEntr:SetFocus()
			lRet := .t.
		endIf
	elseIf cQual == "4" //Tipo de entrada
		SX5->(dbseek("Z1"+mv_par07))
		If Empty(cChave)
			MsgBox("Tipo de entrada deve ser digitado !","Informações Entrada","ALERT")
			lRet := .f.
		elseIf !ExistCpo("SX5","Z1"+mv_par07)
			MsgBox("Não foi encontrado este código de entrada no sistema, Favor verificar.","Informações Entrada","ALERT")
			lRet := .f.
		else
			cEntr := SX5->X5_DESCRI
			oNota:SetFocus()
		endIf
	elseIf cQual == "5" //Numero da nota fiscal
		If Empty(cChave)
			MsgBox("Numero da nota fiscal deve ser digitado !","Informações Entrada","ALERT")
			lRet := .f.
			//	elseif " "$cChave Altearado - Edson Rodrigues - 16/05/10
			// MsgBox("O numero da nota fiscal deve ser digitado por completo !","Informações Entrada","ALERT")
		elseIf len(alltrim(cChave)) < 6
			MsgBox("O numero da nota fiscal deve ser maior que 6 digitos !","Informações Entrada","ALERT")
			lRet := .f.
		endIf
	elseIf cQual == "6" //KIT
		If !cChave$"S.N"
			MsgBox("Digite S quando desejar formar um KIT ou N para processo normal.","Informações Entrada","ALERT")
			lRet := .f.
		endIf
	elseIf cQual == "7" //CEP
		If Empty(cChave)
			MsgBox("O CEP deve ser digitado !","Informações Entrada","ALERT")
			lRet := .f.
		elseIf cChave#SA1->A1_CEP
			MsgBox("CEP do cliente foi digitado errado, Favor verificar.","Informações Entrada","ALERT")
			lRet := .f.
		else
			oCodProd:SetFocus()
		endIf
	elseIf cQual == "9"  .or.  cQual == "10"// Operacoes
		ZZJ->(dbseek(xFILIAL("ZZJ")+cChave))
		If Empty(cChave)
			MsgBox("Operacao deve ser digitado !","Informações Entrada","ALERT")
			lRet := .f.
			
		Elseif ZZJ->ZZJ_BLOQ = "S"
			MsgBox("Operacao bloqueada !","Informações Entrada","ALERT")
			lRet := .f.
			
		ElseIf !ExistCpo("ZZJ",cChave)
			MsgBox("Não foi encontrado este código de operacao no sistema, Favor verificar.","Informações Entrada","ALERT")
			lRet := .f.
			
			//elseif ExistCpo("SX5","WB"+mv_par09) .AND. mv_par09=="N05" //Alterado Edson Rodrigues
		ElseIf 	 !Empty(cChave)  .AND. cChave<>'ZZZ' .and. ExistCpo("ZZJ",cChave)
			cgeraimei :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(cChave), "ZZJ_IMEI")
			cvlclsam  :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(cChave), "ZZJ_VCLSAM")
			
			
			//Incluso validação conforme solicitação Carlos Rocha - 24/09/10
			IF SA1->(DbSeek(xFilial("SA1")+cCNPJ)) .AND. cvlclsam='S'
				IF EMPTY(SA1->A1_XCODSAM)
					MsgBox("Não está preenchido o codigo SAM no cadastro do Cliente/loja : "+SA1->A1_COD+"/"+SA1->A1_LOJA+".       O Cod. SAM deve ser Preenchido no Cad. Cliente para essa operação !","Informações Entrada","ALERT")
					lRet := .f.
				ELSE
					If	cgeraimei ="02"  .and. cQual == "9"
						copera := ZZJ->ZZJ_DESCRI
						oqtde:SetFocus()
					Else
						If  cQual == "9"
							copera := ZZJ->ZZJ_DESCRI
							otrans:SetFocus()
						Endif
					EndIf
				ENDIF
			ELSE
				If	cgeraimei ="02"  .and.  cQual == "9"
					copera := ZZJ->ZZJ_DESCRI
					oqtde:SetFocus()
				Else
					IF cQual == "9"
						copera := ZZJ->ZZJ_DESCRI
						otrans:SetFocus()
					Endif
				EndIf
			ENDIF
		ENDIF
		
	ElseIf cQual == "14" // Transportadora
		if !Empty(cChave)
			If !SA4->(DbSeek(xFilial("SA4")+cChave,.f.))
				MsgBox("Não foi encontrado este código da transportadora no sistema, Favor verificar.","Informações Entrada","ALERT")
				lRet := .f.
			else
				ctrans := SA4->A4_NOME
				olacre:SetFocus()
			endIf
		EndIf
		
	elseIf cQual == "15" //
		If Empty(cChave) .and. cgeraimei="02"
			MsgBox("Para essa operacao, a quantidade deve ser digitada !","Informações Entrada","ALERT")
			lRet := .f.
		elseIf Empty(cChave) .and. ! cgeraimei="02"
			oTrans:SetFocus()
			lRet := .t.
		elseIf !Empty(cChave) .and.  cgeraimei="02"
			oTrans:SetFocus()
			lRet := .t.
		endif
	endif
	
	u_RestAmb( aamb )
	dbSelectArea( calias )

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011E  ºAutor  ³ Antonio L.F.Favero º Data ³  28/08/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fecha a janela de devolucao                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011e(_lAuto)
	_lFechEM := .T.
	
	if !_lAuto .or. centriage= "S" .or. lselqrytst
		Close(oDlg)
	endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011D  ºAutor  ³ Antonio L.F.Favero º Data ³  23/11/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca o campo Z1->CONFIRM com 'S'                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011d(WndDlg,_lAuto)

	Local _cQuery    := ""
	Local _cQrySZC   := ""
	Local _aSavNFE   := {}
	Local cAliasTop1 := ""
	Local cAliasSZC1 := ""
	Local _lrotaut   := .f.  //Edson Rodrigues
	Local _infaces   := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_INFACE")
	Local _cvlope    := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_TROPEN")  // variavel que indica se deve fazer validação de troca de operação
	
	_cVconre  := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ->ZZJ_VCONRE")   // variavel que indica se haverá busca do imei na importação inicial da SZP
	
	If  _lAuto
		_lrotaut:=.t.
	Endif
	
	if _infaces="S"
		
		dbSelectArea('SZC')  //Acessorios
		SZC->(dbSetOrder(1))
		cAliasSZC1	:= GetNextAlias()
		_cQrySZC := " SELECT ZC_DOC, ZC_SERIE, ZC_FORNECE, ZC_LOJA, ZC_CODPRO,ZC_IMEI,ZC_STATUS "
		_cQrySZC += " FROM   "+RetSqlName("SZC") + " (nolock) "
		_cQrySZC += " WHERE ZC_FILIAL = "+xFilial("SZC")+" AND "
		_cQrySZC += "       ZC_DOC     = '"+ALLTRIM(MV_PAR04)+"' AND "
		_cQrySZC += "       ZC_SERIE   = '"+ALLTRIM(MV_PAR05)+"' AND "
		_cQrySZC += "       ZC_FORNECE = '"+ALLTRIM(MV_PAR01)+"' AND "
		_cQrySZC += "       ZC_LOJA    = '"+ALLTRIM(MV_PAR02)+"' AND "
		//_cQrySZC += "       ZC_CODPRO  = '"+ALLTRIM(MV_PAR03)+"' AND " desabilitado - Edson Rodrigues - 01/10/10
		_cQrySZC += "       ZC_STATUS = '0' AND "
		_cQrySZC += "       D_E_L_E_T_ = '' "
		_cQrySZC += " ORDER BY ZC_DOC, ZC_SERIE, ZC_FORNECE, ZC_LOJA, ZC_CODPRO,ZC_IMEI,ZC_STATUS "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySZC),cAliasSZC1,.T.,.T.)
		(cAliasSZC1)->(DBGoTop())
	Endif
	
	
	
	dbSelectArea('ZZ4')  //Entrada Massiva
	cAliasTop1	:= GetNextAlias()
	
	_cQuery := " SELECT ZZ4_IMEI  "
	_cQuery += " FROM   "+RetSqlName("ZZ4") + " (nolock) "
	_cQuery += " WHERE  ZZ4_FILIAL = '"+xFilial('ZZ4')+"' AND "
	_cQuery += "        ZZ4_STATUS = '1' AND "
	_cQuery += "        D_E_L_E_T_ = ''  AND "
	IF _cvlope <> "S"  .or. !lselqrytst
		_cQuery += "        ZZ4_OPEBGH = '"+ALLTRIM(MV_PAR09)+"'  AND "
	ENDIF
	_cQuery += "        SUBSTRING(ZZ4_EMUSER,1,13) = '"+Substr(cUserName,1,13)+"' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery),cAliasTop1,.T.,.T.)
	
	(cAliasTop1)->(DBGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha a Janela                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	tecx011e(_lAuto)
	
	ProcRegua((cAliasTop1)->(RECCOUNT()))
	
	While !(cAliasTop1)->(EOF())
		
		ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
		If ZZ4->(DbSeek(xFilial("ZZ4") + (cAliasTop1)->ZZ4_IMEI + "1"))
			
			While ZZ4->(!eof()) .and. ZZ4->ZZ4_IMEI == (cAliasTop1)->ZZ4_IMEI .and. ZZ4->ZZ4_STATUS == "1"  // Adicionado para solucao da gravacao do item reincidente. (11/05/05) Nicoletti
				
				If upper(alltrim(substr(ZZ4->ZZ4_EMUSER,1,30))) == upper(alltrim(substr(cUserName,1,30))) // Correcao pro Protheus 11. Nao funcionava quando o cUserName era inferior a 13 caracteres.
					
					RecLock('ZZ4',.F.)
					ZZ4->ZZ4_STATUS  := '2'
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se a NFE ja foi gerada e se foi gerada com formulario proprio  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					if VerFPro()
						ZZ4->ZZ4_STATUS := '3'
					ELSE
						ZZ4->ZZ4_STATUS  := '2'
					endif
					
					MsUnLock('ZZ4')
					IncProc()
				EndIf
				ZZ4->(DbSkip())
				
			EndDo
			
			if _cVconre == "S"    // Validação de Importação anterior - Luis Carlos
				dbSelectArea("SZP")
				dbSetOrder(2)
				if dbSeek(xFilial("SZP")+trim((cAliasTop1)->ZZ4_IMEI))
					RecLock('SZP',.F.)
					SZP->ZP_ENTRMAS := "S"
					msUnlock("SZP")
				endif
				dbSelectArea(cAliasTop1)
			endif
			
		EndIf
		(cAliasTop1)->(DBSkip())
		
	Enddo
	
	If _infaces="S"
		ProcRegua((cAliasSZC1)->(RECCOUNT()))
		While !(cAliasSZC1)->(EOF())
			If SZC->(DbSeek(xFilial("SZC") + ((cAliasSZC1)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO))))
				While SZC->(!eof()) .and. SZC->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO) == ((cAliasSZC1)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO))
					IF SZC->ZC_IMEI=(cAliasSZC1)->ZC_IMEI .AND. SZC->ZC_STATUS='0'
						RecLock('SZC',.F.)
						SZC->ZC_STATUS  := '1'
						MsUnLock('SZC')
					ENDIF
					SZC->(DBSkip())
				Enddo
			EndIf
			IncProc()
			(cAliasSZC1)->(DBSkip())
		Enddo
	Endif
	
	If !_lAuto
		WndDlg:End()
	endif
	
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
	DbSelectArea(cAliasTop1)
	DBCloseArea()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011C  ºAutor  ³Microsiga           º Data ³  09/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx011c(_lAuto)

	Local nConta     := 0
	Local ChaveNF    := ""
	Local ChaveSZC   := ""
	Local cProd      := ""
	Local nProd      := 0
	Local cacess     := ""
	Local nacess     :=0
	Local nTotalNf   := 0.00
	Local cConf      := ""
	Local nTotal     := 0
	Local nTotaces   := 0
	Local _cQuery2   := ""
	Local _cQrySZC   := ""
	Local cAliasTop2 := ""
	Local cAliasSZC  := ""
	local oDlgConf
	Local _infaces   := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_INFACE")
	Local _cvlope    := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_TROPEN")  // variavel que indica se deve fazer validação de troca de operação
	
	oFnt1  := TFont():New("Arial",18,22,,.T.,,,,.T.,.F.)
	oFnt2  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
	oFnt3  := TFont():New("Courier New",08,12,,.F.,,,,.F.,.F.)
	
	
	
	DBSelectArea('SB1')
	SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
	DBSelectArea('SX5')
	SX5->(dbSetOrder(1))
	DBSelectArea('ZZ4')
	ZZ4->(dbSetOrder(3)) //ZZ4_FILIAL+ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODPRO
	ZZ4->(dbGoTop())
	
	cAliasTop2	:= GetNextAlias()
	
	// Incluido comandos abaixos.
	_cQuery2 := " SELECT ZZ4_NFENR, ZZ4_NFESER, ZZ4_CODPRO, ZZ4_VLRUNI, ZZ4_EMUSER "
	_cQuery2 += " FROM   "+RetSqlName("ZZ4") + " (nolock) "
	_cQuery2 += " WHERE ZZ4_FILIAL = "+xFilial("ZZ4")+" AND "
	_cQuery2 += "       ZZ4_STATUS = '1' AND "
	_cQuery2 += "       D_E_L_E_T_ = ''  AND "
	_cQuery2 += "       SUBSTRING(ZZ4_EMUSER,1,13) = '"+Substr(cUserName,1,13)+"'  "
	IF _cvlope <> "S"  .or. !lselqrytst
		_cQuery2 += "     AND ZZ4_OPEBGH = '"+ALLTRIM(MV_PAR09)+"'"
	ENDIF
	
	// TCQUERY _cQuery2 NEW ALIAS "ZZ4F"
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery2),cAliasTop2,.T.,.T.)
	
	While !((cAliasTop2)->(EOF())) //ZZ4F->(EOF())
		
		nTotal++
		
		IF (cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER) <> ChaveNF
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
			SB1->(DBSeek(xFilial('SB1')+cProd))
			cConf+=Transform(nProd,'@E 999999')+'    '+cProd+' '+Alltrim(SB1->B1_DESC)+LFRC
			nProd:=1
			cProd:= (cAliasTop2)->ZZ4_CODPRO
		Endif
		
		nTotalNF+= (cAliasTop2)->ZZ4_VLRUNI
		
		(cAliasTop2)->(DBSkip())
		
		IF ((cAliasTop2)->(ZZ4_NFENR+ZZ4_NFESER)<>ChaveNF) .or.;
			((cAliasTop2)->ZZ4_EMUSER<>cUserName) .or. (cAliasTop2)->(EOF())
			SB1->(DBSeek(xFilial('SB1')+cProd))
			cConf+=Transform(nProd,'@E 999999')+'    '+cProd+' '+SB1->B1_DESC+LFRC
			nProd:=0
			cProd:=(cAliasTop2)->ZZ4_CODPRO
			cConf+=LFRC+'Total da Nota:'+Transform(nTotalNF,'@E 9,999,999.99')+LFRC+LFRC
			nTotalNf:= 0.00
		Endif
	EndDo
	
	IF _infaces="S"
		cAliasSZC := GetNextAlias()
		
		// Incluso Query para contar quantos acessorios foram escaneados e apresentar para o usuário no
		// final da confirmação total - Edson Rodrigues - 09/09/10
		_cQrySZC := " SELECT ZC_DOC, ZC_SERIE, ZC_FORNECE, ZC_LOJA, ZC_CODPRO,ZC_TPACESS "
		_cQrySZC += " FROM   "+RetSqlName("SZC") + " (nolock) "
		_cQrySZC += " WHERE ZC_FILIAL = "+xFilial("SZC")+" AND "
		_cQrySZC += "       ZC_DOC     = '"+ALLTRIM(MV_PAR04)+"' AND "
		_cQrySZC += "       ZC_SERIE   = '"+ALLTRIM(MV_PAR05)+"' AND "
		_cQrySZC += "       ZC_FORNECE = '"+ALLTRIM(MV_PAR01)+"' AND "
		_cQrySZC += "       ZC_LOJA    = '"+ALLTRIM(MV_PAR02)+"' AND "
		//   _cQrySZC += "       ZC_CODPRO  = '"+ALLTRIM(MV_PAR03)+"' AND " desabilidado - Edson Rodrigues - 01/10/10
		_cQrySZC += "       ZC_STATUS = '0' AND "
		_cQrySZC += "       D_E_L_E_T_ = '' "
		_cQrySZC += " ORDER BY ZC_TPACESS    "
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySZC),cAliasSZC,.T.,.T.)
		
		
		
		
		While !((cAliasSZC)->(EOF())) //ZZ4F->(EOF())
			
			IF ((cAliasSZC)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA)) <> ChaveSZC
				ChaveSZC:=(cAliasSZC)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA)
				cacess  :=(cAliasSZC)->ZC_TPACESS
				nacess  :=0
				cConf+='Acessorios lidos para : '+LFRC
				cConf+='Nota: '+ ALLTRIM((cAliasSZC)->ZC_DOC)+' Serie : '+ (cAliasSZC)->ZC_SERIE+LFRC
				cConf+='  Quant Cod.Acess  Descrição               '+LFRC
			ENDIF
			
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
			
			IF ((cAliasSZC)->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA)) <> ChaveSZC .or.;
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
	
	
	
	
	DbSelectArea(cAliasTop2)
	DbCloseArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Janela de Conferência                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTotal == 0
		Aviso('Massiva','Não existem itens para conferência!',{'OK'})
	Else
		If AllTrim(mv_par07) == "12"
			lCont := .T.
			
			While lCont
				oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
				@ 0,0 TO 200,300 DIALOG oDlg2 TITLE "Massiva"
				oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlg2)
				@ 20,010 SAY oV1 var "Informe o fornecedor:" of oDlg2 FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
				@ 40,010 GET cForn Size 60,080 PICTURE "@!" F3 'FOR'
				@ 40,080 GET cLoja Size 20,080 PICTURE "@!"
				@ 80,085 BMPBUTTON TYPE 1 ACTION (IIf(ExistCpo("SA2", cForn + cLoja), lCont := .F., lCont := .T.), oDlg2:End())
				@ 80,120 BMPBUTTON TYPE 2 ACTION (lCont := .F., oDlg2:End())
				Activate MSDialog oDlg2 Centered
			EndDo
		EndIf
		
		If  !_lAuto //Edson Rodrigues 28/11/07
			@ 0,0 TO 400,420 DIALOG oDlgConf TITLE "Confirmar Dados"
			@ 05,005 SAY oV1 var Alltrim(cUserName)+',' of oDlgConf FONT oFnt2 PIXEL SIZE 150,010
			@ 15,005 SAY oV2 var "confirme os itens abaixo listados." of oDlgConf FONT oFnt2 PIXEL SIZE 150,012
			@ 25,005 SAY oV3 var "Importante: A responsabilidade dos dados é sua." of oDlgConf FONT oFnt2 PIXEL SIZE 150,012 COLOR CLR_RED
			@ 40,005 Get cConf Size 195,115 MEMO Object oMemoConf
			@ 160,130 BMPBUTTON TYPE 1 ACTION Processa({|| tecx011d(oDlgConf,_lAuto) })
			@ 160,165 BMPBUTTON TYPE 2 ACTION tecx011f(oDlgConf)
			//@ 160,165 BMPBUTTON TYPE 2 ACTION (oDlgConf:End()) - Desabilitado Edson Rodrigues - 15/04/10
			oMemoConf:oFont:=oFnt3
			Activate MSDialog oDlgConf Centered
		Else
			tecx011d(oDlgConf,_lAuto) //Edson Rodrigues
		Endif
	endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011F  ºAutor  ³ Antonio L.F. Faveroº Data ³  20/10/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apagar os registros scanneados                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011f(oDlgAux)

//oDlgConf:End() Altera Edson Rodrigues - 14/04/10
oDlgAux:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECX011GRVºAutor  ³ Antonio L.F.Favero º Data ³  27/03/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava registro no ZZ4 e atualiza Memo                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx011grv(cCodBar,Memo,cVARSIM,_lAuto,nvez,cVarmst,nbounce)

Local nVlZ1        := 0.00
Local lResult      := .T.
Local tMemo        := ""
Local _cCodPro     := mv_par03
Local _nVlrUnit    := mv_par06
Local _ctipentr    := mv_par07
Local _lvalsza     := .f.
Local _clote       :=""
Local _cdpyim      :=""
Local _cgvsos      :=""
Local _clocal      :=""
Local _nVez        := 0  //iif(_lauto,nvez,0)
local _cVarmst     := iif(_lauto,cVarmst,"")
local _nbounce     := 0  //iif(_lauto,val(nbounce),0)
Local _cITEMD1     := ""
Local _cfornsrf    := ""
Local _cljforsrf   := ""
Local _cultoper    := ""
Local cvlopent     := ""
Local ctravbou     := ""
Local nqtdboun     :=  0
Local lPrtetq      := GETNEWPAR("MV_X011IMP",.T.)
Local lgrvsza      := .f.
Local lvldoper     := .f.
Local _dultsaid    := date()
Local coperatu     := ""
Local _nQualiVez   := 0
Local _ltrocope    :=.f.
Local _cZZ4_CODREP := ""
Local lVlvInc		:= .F.

ZZJ->(DbSetOrder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
IF ZZJ->(DbSeek(xFilial("ZZJ")+ALLTRIM(MV_PAR09),.f.))
	_clab      := ZZJ->ZZJ_LAB
	cOpe       := ZZJ->ZZJ_OPERA
	_loperpro  := U_VLDPROD(cOpe,_clab)
	_ccalcgar  := ZZJ->ZZJ_CALGAR // Variavel que diz se a operacao calcula a garantia sim ou nao - Edson Rodrigues 17/04/10
	_cdadoSZA  := ZZJ->ZZJ_DADSZA // Variavel que diz se a opercao busca/inclui dados no SZA - Edson Rodrigues 17/04/10
	cinftrans  := ZZJ->ZZJ_INFTCM  // variavel que informa o Transcode - Processo Mclaims - Edson Rodrigues 15/04/10
	ctransfix  := ZZJ->ZZJ_TRAFIX  // variavel que diz se Transcode e fixo,sim, nao ou condicional - Processo Mclaims - Edson Rodrigues 15/04/10
	cinfNFcom  := ZZJ->ZZJ_INFNFC  // variavel que diz se a na operacao pode ser ou nao informado Nf compra cliente ou fornecedor outros - Edson Rodrigues 15/04/10
	cinfcaut   := ZZJ->ZZJ_INFCAU  // variavel que diz se informa dados da NF compra ou cod. autorizada se ZZJ_TRAFIX=NAO e ZZJ_INFTCM=SIM - Edson Rodrigues 16/04/10
	cinfaces   := ZZJ->ZZJ_INFACE  // variavel que diz se a operacao informará acessório na entrada massiva - Edson Rodrigues 16/04/10
	cvlopent   := ZZJ->ZZJ_TROPEN  // variavel que indica se deve fazer validação de troca de operação
	ctravbou   := ZZJ->ZZJ_TRABEN  // variavel que indica se trava aparelhos bounce na entrada
	nqtdboun   := ZZJ->ZZJ_QTDBEN  // variavel que indica a quantidade de dias para travar o aparelho bounce na entrada massiva
	_cVconre  := ZZJ->ZZJ_VCONRE   // variavel que indica se haverá busca do imei na importação inicial da SZP
	lVlvInc	  := ZZJ->ZZJ_VLVINC == 'S'
ELSE
	ApMsgInfo("Não foi encontrado a operacao cadastrada para o IMEI "+alltrim(cCodBar)+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
	return()
ENDIF
// So executa a validacao se o codigo de barra estiver preenchido	Return
If Empty(cCodBar)
	Return
endif



// Validacao do algoritmo do IMEI - claudia - 21/01/2010
IF FINDFUNCTION("U_CHKIMEI")
	IF !U_CHKIMEI(cCodBar)
		tMemo := '------ Digito do IMEI Invalido --------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=Replicate(' ',20)
		Close(oDlg)
		Return
	Endif
ENDIF
// ------ FIM VALIDACAO DO  ALGORITMO DO IMEI


// Alterado por M.Munhoz - ERP PLUS - 24/09/07
if "'" $ cCodBar .or. "'" $ cVarSim .or. '"' $ cCodBar .or. '"' $ cVarSim
	tMemo := '------Proibido informar aspas simples ou duplas no IMEI ou Carcaçà.--------'+LFRC+LFRC
	Memo  := tMemo+Memo
	cCodBar:=Replicate(' ',20)
	Close(oDlg)
	Return
endif

If !_lAuto .and. !empty(cCodBar)
	
	_lErro := .F.
	if Len(AllTrim(cCodBar)) <> nTcodpr .and. !__cUserID $ GetMV('MV_XIMEI15')    //soraia
		if Len(AllTrim(cCodBar)) > nTcodpr
			tMemo := '------Codigo de Barras Inválido - '+AllTrim(cCodBar)+'! MAIS de 15 caracteres.--------'+LFRC+LFRC
		elseif Len(AllTrim(cCodBar)) < nTcodpr
			tMemo := '------Codigo de Barras Inválido - '+AllTrim(cCodBar)+'! MENOS de 15 caracteres.--------'+LFRC+LFRC
		endif
		_lErro := .t.
		Memo  := tMemo+Memo
	endif
	
	// Validacao do numero de serie (Carcaca) informado pra Nextel
	// Alterado IF abaixo - Edson Rodrigues
	//if left(cCodBar,4) $ "0006/0017"
	If _ccalcgar='S'
		
		If alltrim(cCodBar) == alltrim(cVarSim)
			_lErro := .t.
			tMemo := '------O número de série não pode ser igual ao IMEI. Favor fazer a leitura do número de série novamente.--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		elseif left(cCodBar,4) == left(cVarSim,4)
			_lErro := .t.
			tMemo := '------Os 4 primeiros digitos do número de série deve ser diferente do IMEI. Favor fazer a leitura do número de série novamente.--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		elseif len(alltrim(cVarSim)) <> 10
			_lErro := .t.
			tMemo := '------O número de série deve conter 10 digitos. Favor fazer a leitura do número de série novamente.--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		elseif space(1) $ left(cVarSim,10)
			_lErro := .t.
			tMemo := '------O número de série não pode conter espaço. Favor fazer a leitura do número de série novamente.--------'+LFRC+LFRC
			Memo  := tMemo+Memo
		endif
		
	endif
	
	&&Validação de Vinculo - Thomas Galvão - 28/08/2012
	&&-------------------------------------------------
	If lVlvInc &&ZZJ_VLVINC == 'S'
		_lErro := u_WSINTCCENT(cCodBar,@tMemo)
		Memo   := tMemo+Memo
	EndIf
	&&-------------------------------------------------
		
	if _lErro
		cCodBar:=Replicate(' ',20)
		Close(oDlg)
		Return
	endif
	
endif

If !_lAuto
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se gerou arq. Entrada Excel e verifica se IMEI consta ou nao no arquivo SZA.|
	//| Valido apenas para clientes UPS / Nextel Operacao Refurbish- Edson Rodrigues 19/09/08|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Alterado IF abaixo - Edson Rodrigues 17/04/10
	//IF alltrim(mv_par01) $ "000146/036057/110762/000016/000680"  // Codigos de clientes UPS **** Adicionado Luiz Ferreira 26/02/09
	// Incluso condicao C=Condicional para validar o cliente no caso de retorno de Refurbis-Bounce - Solicitação Enio em 20/06/11 - Edson Rodrigues - 22/06/11
	IF (_cdadoSZA='S')  .or. (_cdadoSZA='C' .and. alltrim(mv_par01) $ "000016/000680")
		lgrvsza:=.T.
		//	IF alltrim(mv_par01) $ "000146/036057/110762/000016"  // Codigos de clientes UPS
/*
		dbSelectArea("SZA")
		SZA->(dbSetOrder(1)) // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
		//		if SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05))
		If SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + cCodBar))
*/
		_aAreaSZA := SZA->(getarea())
		dbSelectArea("SZA")
		SZA->(dbSetOrder(4)) // ZA_FILIAL + ZA_IMEI + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_STATUS	 (indice criado apenas com NR da nota fiscal pq ocorre muito erro de digitacao da serie).
		if SZA->(dbSeek(xFilial("SZA") + left(cCodBar,15) + mv_par01 + mv_par02 + mv_par04)) 

			If SZA->ZA_STATUS $ 'I'
				//			_lverza := tecx011M(cCODBAR)
				//			If _lverza
				MsgBox("O IMEI: "+cCODBAR+" ref NF: "+MV_PAR04+" apresentou inconsistência no arquivo SZA/Excel. Separe o Aparelho","ALERT")
				tMemo += "IMEI: "+cCODBAR+" INCONSISTENTE. NF/SERIE -> "+MV_PAR04+"/"+MV_PAR05+" "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=Replicate(' ',20)
				Close(oDlg)
				Return
			Elseif SB1->(!dbSeek(xFilial("SB1") + SZA->ZA_CODPRO))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida produto nao cadastrado - M.Munhoz - ERPPLUS - 29/10/2008                    |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("O produto " + alltrim(SZA->ZA_CODPRO) + " correspondente ao IMEI: "+cCODBAR+" não está cadastrado no sistema. Providencei o cadastramento deste produto e faça a entrada massiva novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com produto " + alltrim(SZA->ZA_CODPRO) + " nao cadastrado! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=Replicate(' ',20)
				Close(oDlg)
				Return
				
				
				/* Retirada a validação, pois engessa a entrada massiva - Edson Rodrigues 04/10/10
				Elseif SB1->(dbSeek(xFilial("SB1") + SZA->ZA_CODPRO)) .AND. !ALLTRIM(SZA->ZA_CODPRO)==alltrim(_cCodPro)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida produto SZA diferente do produto da entrada massiva - Edson Rodrigues - 30/09/2010                    |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("O produto " + alltrim(SZA->ZA_CODPRO) + " é diferente do produto que está entrando : "+_cCodPro+". Corrija o produto nos parâmetros F9 e faça a leitura do IMEI novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com produto " + alltrim(SZA->ZA_CODPRO) + " diferente do produto a entrar: "+_cCodPro+"  ! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=Replicate(' ',20)
				Close(oDlg)
				Return
				
				
				Elseif SB1->(dbSeek(xFilial("SB1") + SZA->ZA_CODPRO)) .AND. SZA->ZA_PRECO <> _nVlrUnit
				
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
				
				
			Elseif SB1->(dbSeek(xFilial("SB1") + SZA->ZA_CODPRO)) .and. (SB1->B1_LOCALIZ == "S" .or. SB1->B1_RASTRO $ "LS" .or. SB1->B1_MSBLQL == "1")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida produto com controle de endereco/lote ou bloqueado - M.Munhoz - ERPPLUS - 29/10/2008 |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("O produto " + alltrim(SZA->ZA_CODPRO) + " correspondente ao IMEI: "+cCODBAR+" possui controle de endereço ou de lote ou está bloqueado. Providencei a correção deste produto e faça a entrada massiva novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com produto " + alltrim(SZA->ZA_CODPRO) + " com controle de endereço ou lote ou bloqueado! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=Replicate(' ',20)
				Close(oDlg)
				Return
				//Incluso validacao de Operacao - Edson Rodrigues - 17/08/10
			Elseif ALLTRIM(SZA->ZA_OPERBGH) <> ALLTRIM(MV_PAR09)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida se operacao cadastrada no arquivo entrada excel é igual a operacao informada na Entr. Massiva |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MsgBox("A operacao " + alltrim(SZA->ZA_OPERBGH) + " correspondente ao IMEI: "+cCODBAR+" nao é igual a operacao informada : "+ALLTRIM(MV_PAR09)+". Providencei a correção da operacao no arq. Entr. Excell e faça a entrada massiva novamente. Separe o Aparelho!","ALERT")
				tMemo += "IMEI: "+cCODBAR+" com operacao " + alltrim(SZA->ZA_OPERBGH) + " é diferente da Operacao informada : "+ALLTRIM(MV_PAR09)+"! "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=Replicate(' ',20)
				Close(oDlg)
				Return
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida entrada do SZA e Imprime etiqueta de Entrada - M.Munhoz - ERPPLUS - 29/10/2008  |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				reclock("SZA",.f.)
				SZA->ZA_STATUS := 'V'
				msunlock()
				
				_cCodPro   := SZA->ZA_CODPRO
				_nVlrUnit  := SZA->ZA_PRECO
				_lvalsza  := .t.
				_clote    :=SZA->ZA_LOTEIRL
				_cdpyim   :=IIF(SUBSTR(SZA->ZA_CODDPY,1,3)="DPY",SZA->ZA_CODDPY,"")
				_cgvsos   :=SZA->ZA_OSGVS
				_clocal   :=SZA->ZA_LOCAL
				
				_aEtiqEntr := {}
				
				// nao usaod neste processo
				//IF lPrtetq
				//	if MsgYesNo('Deseja imprimir a etiqueta de entrada? A impressora termica está conectada a este computador e pronta para impressão?')
				//		aAdd(_aEtiqEntr, {cCodBar, "", "", mv_par04, mv_par05, SZA->ZA_CODPRO, ;
				//		dDataBase, 0, mv_par01, mv_par02, "" })
				//		u_EtqMass2(_aEtiqEntr,"TECAX011")
				//	endif
				//endif
				//	_aEtiqEntr := {}
			Endif
		Else
			IF _ctipentr<> '04'  //.AND. mv_par09 <> "S03" --> Alterado Edson Rodrigues 17/04/10
				MsgBox("O IMEI: "+cCODBAR+" Nao foi encontrado no arq. excel ref NF : "+MV_PAR04+" !","Separe o Aparelho","ALERT")
				tMemo += "IMEI: "+cCODBAR+"  NAO ENCONTRADO EXCEL: NF/SERIE -> "+MV_PAR04+"/"+MV_PAR05+" "+LFRC
				Memo:=tMemo+Memo
				cCodBar:=Replicate(' ',20)
				Close(oDlg)
				Return
			ENDIF
		Endif
		restarea(_aAreaSZA)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//Verifica se o produto possui controle de endereço e bloqueia //Edson Rodrigues - 11/12/09 Ä
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	IF SB1->(dbSeek(xFilial("SB1") + _cCodPro))
		IF (SB1->B1_LOCALIZ == "S")
			MsgBox("O Produto: "+alltrim(_cCodPro)+" com controle de Localizacao. Rotina não preparada para produtos com controle de localização !","Produtos com controle de localização","ALERT")
			tMemo += "O Produto: "+alltrim(_cCodPro)+" com controle de Localizacao - Rotina não preparada para produtos com controle de localização "+LFRC
			Memo:=tMemo+Memo
			cCodBar:=Replicate(' ',20)
			Close(oDlg)
			Return
		ENDIF
	ELSE
		//Acrescentado esse "ELSE" --Edson Rodrigues - 21/07/10
		MsgBox("O Produto: "+alltrim(_cCodPro)+" nao foi encontrado no cadastro de produto - Favor cadastrar !","Produtos nao cadastrado","ALERT")
		tMemo += "O Produto: "+alltrim(_cCodPro)+"  nao foi encontrado no cadastro de produto - Favor cadastrar "+LFRC
		Memo:=tMemo+Memo
		cCodBar:=Replicate(' ',20)
		Close(oDlg)
		Return
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se base instalada ja existe                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("AA3")
	dbSetOrder(4)
	If dbSeek(xFilial("AA3") + Space(8) + _cCodPro + cCodBar)
		tMemo:='------Ja Existe Base Instalada!------'+LFRC+LFRC
		Memo:=tMemo+Memo
	EndIf
	
endif


IF !_lauto .or. centriage = "S" .or. lselqrytst
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se IMEI ja sofreu entrada massiva                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ZZ4->(DBSetOrder(2)) //ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI+ZZ4_STATUS
	//	ZZ4->(DBGoTop())
	//if ZZ4->(DBSeek(xFilial('ZZ4')+mv_par01+mv_par02+_cCodPro+cCODBAR)) // Alterado esse IF para amarrar a validação por IMEI 22/01/10
	ZZ4->(DBSetOrder(1))
	if ZZ4->(DBSeek(xFilial('ZZ4')+cCODBAR)) .or. ZZ4->(DBSeek("02"+cCODBAR))
		if ZZ4->ZZ4_STATUS <> '9' // NFS gerada
			
			tMemo   := '------Esse celular já foi registrado--------'+LFRC+LFRC
			Memo    := tMemo+Memo
			
			IF centriage = "S" .or. lselqrytst
				cCodBar := Replicate(' ',20)
				Close(oDlg)
				Return
			ELSE
				Close(oDlg)
				Return(.F.)
			ENDIF
		else
		    //Procura IMEI na filial 02 - Luciano - Delta
		    ZZ4->(DBSetOrder(1))
			If ZZ4->(DBSeek("02"+cCODBAR))
				while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == "02" .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar)
					If ZZ4->ZZ4_STATUS=='9'
						_nVez++
						_nQualiVez++
						//_cultoper :=IIF(EMPTY(ZZ4->ZZ4_OPEANT),ZZ4->ZZ4_OPEBGH,ZZ4->ZZ4_OPEANT)
						_cultoper :=ZZ4->ZZ4_OPEBGH
						_dultsaid :=ZZ4->ZZ4_NFSDT
					Endif
					ZZ4->(dbSkip())
				Enddo
			Endif
			
			
			//Procura IMEI na filial corrente - Luciano - Delta
		    ZZ4->(DBSetOrder(1))
			If ZZ4->(DBSeek(xFilial('ZZ4')+cCODBAR))
				while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar)
				
				//Comentado essa validação por cliente e produto, pois conforme conversado com Fernando Luciano, bounce somente por IMEI - Edson Rodrigues 07/11/11
				//IF mv_par01 == ZZ4->ZZ4_CODCLI .and. mv_par02 == ZZ4->ZZ4_LOJA .and. alltrim(_cCodPro) == alltrim(ZZ4->ZZ4_CODPRO)
				
				//ENDIF
				
					IF  ZZ4->ZZ4_STATUS=='9'
				    	_nVez++
					    _nQualiVez++
					    //_cultoper :=IIF(EMPTY(ZZ4->ZZ4_OPEANT),ZZ4->ZZ4_OPEBGH,ZZ4->ZZ4_OPEANT)
					    _cultoper :=ZZ4->ZZ4_OPEBGH
					    _dultsaid :=ZZ4->ZZ4_NFSDT
				    ENDIF
					ZZ4->(dbSkip())
				enddo
			Endif
		endif
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a OS esta em atendimento                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !_lAuto .and. !tecx011g(_cCodPro,cCodBar)
	tMemo := '------Esse aparelho esta em atendimento--------'+LFRC+LFRC
	Memo  := tMemo+Memo
	cCodBar:=Replicate(' ',20)
	Close(oDlg)
	Return
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o aparelho é SCRAP - Edson Rodrigues - 23/09/10             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !_lAuto .and. tecx011p(_cCodPro,cCodBar)
	IF MSGYESNO("ESSE APARELHO FOI ENCERRADO COMO SCRAP NA ULTIMA VEZ QUE ESTEVE NA BGH. INFORME AO SUPERVISOR DO LABORATÓRIO URGENTE !!. DESEJA FAZER A ENTRADA MASSIVA DELE  ASSIM MESMO ?.")
		tMemo := '------Esse aparelho é SCRAP..!!!--------'+LFRC+LFRC
		Memo  := tMemo+Memo
	ELSE
		tMemo := '------Esse aparelho é SCRAP..!!!--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=Replicate(' ',20)
		Close(oDlg)
		Return
	ENDIF
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a ultima operacao que o aparelho entrou e abre tela para            ³
//³ alteracao da operacao se o usuário assim quiser - Edson Rodrigues - 27/08/11 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ndias:=dDataBase - _dultsaid
_nbounce:=ndias

If cvlopent="S" .and. _nQualiVez > 0 .and. !empty(_cultoper) .and. alltrim(_cultoper)<>ALLTRIM(MV_PAR09) .and. nqtdboun > 0
	IF ndias <= nqtdboun
		//coperatu :=alltrim(_cultoper)
		
		
		IF MSGYESNO("ESSE APARELHO ESTA RETORNANDO PELA "+STRZERO(_nQualiVez+1,2)+"- BOUNCE menor ou igual a : "+STRZERO(nqtdboun,3)+" dias, E SUA ULTIMA OPERAÇÃO FOI A "+_cultoper+". QUER TROCAR POR OUTRA OPERAÇÃO DIFERENTE DA ATUAL : "+ALLTRIM(MV_PAR09)+" ? ")
			coperatu:=u_tropera(ALLTRIM(MV_PAR09))
			_ltrocope:=.t.
			If coperatu==ALLTRIM(MV_PAR09)
				_ltrocope:=.f.
				IF !MSGYESNO("VOCE NAO ALTEROU A OPERACAO ATUAL : "+ALLTRIM(MV_PAR09)+" , CONFIRMA ? ")
					coperatu:=u_tropera(ALLTRIM(MV_PAR09))
					_ltrocope:=.t.
				ENDIF
			ENDIF
		Endif
	ENDIF
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a operacao valida bounce e se for bounce menor que os dias       ³
//³ parametrizado na operacao solicita ao usuário a separacao do mesmo           ³
//³ Edson Rodrigues - 09/09/11                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ctravbou="S" .and. nqtdboun > 0 .and. _nQualiVez > 0 .and. centriage <> "S" .and. !lselqrytst
	
	IF ndias <= nqtdboun
		IF _ltrocope
			MsgBox("Foi Trocado a operação atual de "+ALLTRIM(MV_PAR09)+" para a "+ALLTRIM(_cultoper)+" e O IMEI: "+alltrim(cCodBar)+" é BOUNCE menor ou igual a : "+STRZERO(nqtdboun,3)+" dias. Favor confirmar a seguir e separa-lo !","IMEI BOUNCE menor que :"+STRZERO(nqtdboun,3),"ALERT")
		ELSE
			MsgBox("O IMEI: "+alltrim(cCodBar)+" é BOUNCE menor ou igual a : "+STRZERO(nqtdboun,3)+" dias. Favor confirmar a seguir e separa-lo !","IMEI BOUNCE menor que :"+STRZERO(nqtdboun,3),"ALERT")
		ENDIF
		U_APBOUNCE(nqtdboun,cCodBar)
	ENDIF
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz Verificacacoes para os novos Processo de Entrada Sony Ericson-      |
//| Refurbish - Verifica se exite a NF de compra e produto digitado         |
//³ Edson Rodrigues 03/11/09                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//IF _ctipentr='04'  .AND. mv_par09="S03" --> Alterado IF - Edson Rodrigues - 17/04/10
IF  _loperpro
	_cfornsrf  := SUBSTR(ALLTRIM(GETMV('MV_XFORSRF')),1,6)
	_cljforsrf := SUBSTR(ALLTRIM(GETMV('MV_XFORSRF')),7,2)
	
	
	// D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD
	If !vernfcom(mv_par04,mv_par05,_cfornsrf,_cljforsrf,_cCodPro,@_nVlrUnit,'1',cCodBar)
		tMemo := '------Nao Encontrada Nfe de compra para Esse aparelho--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=Replicate(' ',20)
		Close(oDlg)
		Return
	Endif
	If !vernfcom(mv_par04,mv_par05,_cfornsrf,_cljforsrf,_cCodPro,@_nVlrUnit,'2',cCodBar)
		tMemo := '------Valor unitario diferente do digitado na Nfe de compra para Esse aparelho--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=Replicate(' ',20)
		Close(oDlg)
		Return
	Endif
	
	If !vernfcom(mv_par04,mv_par05,_cfornsrf,_cljforsrf,_cCodPro,@_nVlrUnit,'3',cCodBar)
		tMemo := '------Produto a reformar nao cadastrado--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=Replicate(' ',20)
		Close(oDlg)
		Return
	Endif
ENDIF



if _cVconre == "S"    // Validação de Importação anterior - Luis Carlos
	dbSelectArea("SZP")
	dbSetOrder(2)         
	if dbSeek(xFilial("SZP")+trim(cCodBar))
		_cZZ4_CODREP := SZP->ZP_CONDREP
	else
		alert ("Número Serial não encontrado na tabela de Pré Lançamento")
		_cZZ4_CODREP := ""
	endif   
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz Verificacacoes para os novos Processo de Entrada Nextel-            |
//| para obter informacoes para o Relatorio MCLAIMS                         |
//³ Edson Rodrigues 01/05/09                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//IF mv_par07="04" .and.  mv_par09="N01"  //alterado - Edson Rodrigues - 25/11/09



//IF  mv_par09="N01" --> Alterado Edson Rodrigues - 17/04/10
//IF ctransfix="C" - Retirado daqui e passado essa validação pra baixo - Edson Rodrigues - 26/11/10
//	MV_PAR16:=U_Vergaran(cVarSim,mv_par09,cCodBar)
//	mv_par13:="NEX"
//ENDIF // Fechado esse IF para atender todas as condicoes abaixo :

//ELSEIF mv_par07<>"04" .and.  mv_par09 $ "N02/N03/N04"--> Alterado Edson Rodrigues - 17/04/10

//ELSEIF ctransfix='N' .AND. (cinfNFcom='S' .or. cinfaces='S') .and. !_loperpro --> alteraodo Edson Rodrigues - 22/11/10


Begin Transaction

//******************** Entra somente se não for rotina de Produção, ex: S03 - Sony Ericson Refurbish ******************************

IF  !_loperpro
	IF ctransfix="C" // Grava variavel de Transportadora Motorola - Edson Rodrigues - 26/11/10
		mv_par13:="NEX"
		lgrvsza:=.T.
	ENDIF
	
	
	
	//******************** Tratamento quando tem Nota fiscal de Compra / Outros dados da NF de Remessa e ou Codigo de Operadora  **********************************//
	If cinfNFcom='S' .and. !lselqrytst
		_lnfcomp:=IIF(MSGYESNO("Possui a Nota Fiscal de compra do Aparelho ?"),.t.,.f.)
	ElseIf cinfNFcom='O' .and. !lselqrytst // Obriga a digitação dos dados da NF Compra - C. Rocha - 12/01/11
		_lnfcomp:=.t.
	Else
		_lnfcomp:=.f.
	Endif
	
	
	If _lnfcomp   //Se informa Nota de Compra, entao Calcula a garantia conforme digitacao da NF Compra e Data - Edson Rodrigues - 26/11/10
		tecax11n(_lnfcomp,cinfcaut)
		lgrvsza:=.T.
		
		//Elseif !_lnfcomp .AND. mv_par09 = "N03" --> Alterado Edson Rodrigues - 17/04/10
		// Se Nao tem NF de compra mas informa dados da nota de remessa ou codigo da autorizada - Edson Rodrigues - 26/11/10
	Elseif !_lnfcomp .AND. cinfcaut='S' .and. !lselqrytst
		tecax11n(_lnfcomp,cinfcaut)
		lgrvsza:=.T.
	Endif
	//********************************************************************************//
	
	
	
	// Comentado pois alterei a lógica acima - Edson Rodrigues - 26/11/10
	//Elseif !_lnfcomp .AND. !mv_par09 = "N03"--> Alterado Edson Rodrigues - 17/04/10
	//Elseif !_lnfcomp .AND. cinfcaut='N' .and. _ccalcgar='S'  //.and. _ccalcgar='N'//alterado 14/06/10 - Edson Rodrigues
	//MV_PAR16:=U_Vergaran(cVarSim,mv_par09,cCodBar)
	//Endif
	
	
	
	//**********************Tratamento para calculo de garantia quando não tem nota fiscal de compra e calcula garantia - Edson Rodrigues - 26/11/10 ********************//
	IF !_lnfcomp .and. _ccalcgar='S'
		MV_PAR16:=U_Vergaran(cVarSim,mv_par09,cCodBar)
		lgrvsza :=.T.
		IF EMPTY(MV_PAR16)
			tMemo := '------Carcaça Invalida--------'+LFRC+LFRC
			Memo  := tMemo+Memo
			cCodBar:=Replicate(' ',20)
			if !_lAuto
				Close(oDlg)
			endif
			Return
		ENDIF
	Endif
	//********************************************************************************//
	
	
	
	//***************************************Tratamento para quando a operacao informa acessorios ***************//
	//if !mv_par09 $ "N02/N04" --> Alterado Edson Rodrigues - 17/04/10
	If  cinfaces='S'.and. !lselqrytst
		_lacesso:=IIF(MSGYESNO("O aparelho esta acompanhado de acessorios ?"),.t.,.f.)
	Else
		_lacesso:=.f.
	Endif
	
	If _lacesso
		_lFechCS:= .F.
		lgrvsza := .T.
		_cSepEnt:= Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_SEPENT")//Incluido conforme solicitação do Edson 12/06/2012
		_actacess  := {}		
		u_tecax11m(cCodBar,_cSepEnt,_cCodPro)
		MV_PAR15:="S"
	Else
		MV_PAR15:="N"
	Endif
	//********************************************************************************//
	
ENDIF
//******************************************************************************************************************************************************//


//IF mv_par09 $ "N01/N02/N03/N04"
//Alterado esse IF, pois estava muito confuso  de entreder, trocado pela variável lágica lgrvsza - Edson Rodrigues - 26/10/10
//IF (cinftrans='S' .AND. _cdadoSZA='S') .OR. (ctransfix='N' .AND. cinfNFcom='S' .and. !_loperpro .and. _lnfcomp) .or. (ctransfix='N' .AND. cinfNFcom='S' .and. !_loperpro .and. cinfcaut='S' .and. _ccalcgar='S')

IF EMPTY(mv_par16) .AND. _ccalcgar='S'
	mv_par16:=U_Vergaran(cVarSim,mv_par09,cCodBar)
	IF EMPTY(MV_PAR16)
		tMemo := '------Carcaça Invalida--------'+LFRC+LFRC
		Memo  := tMemo+Memo
		cCodBar:=Replicate(' ',20)
		if !_lAuto
			Close(oDlg)
		endif
		Return
	ENDIF
ENDIF

IF  lgrvsza

	_aAreaSZA := SZA->(getarea())
	SZA->(dbSetOrder(4)) // ZA_FILIAL + ZA_IMEI + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_STATUS	 (indice criado apenas com NR da nota fiscal pq ocorre muito erro de digitacao da serie).
	if !SZA->(dbSeek(xFilial("SZA") + left(cCodBar,15) + mv_par01 + mv_par02 + mv_par04)) .and. !empty(cCodBar)
//	IF !SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + cCodBar)) .and. !empty(cCodBar)
		reclock("SZA",.t.)
		SZA->ZA_FILIAL  := xFilial("SZA")
		SZA->ZA_CLIENTE := mv_par01
		SZA->ZA_LOJA    := mv_par02
		SZA->ZA_NFISCAL := PadL(AllTrim(mv_par04),iif(Len(AllTrim(mv_par04)) <= 6,6,9),"0")
		SZA->ZA_SERIE   := mv_par05
		SZA->ZA_EMISSAO := dDataBase
		SZA->ZA_CODPRO  := _cCodPro
		SZA->ZA_PRECO   := _nVlrUnit
		SZA->ZA_DATA    := dDataBase
		SZA->ZA_IMEI    := cCodBar
		SZA->ZA_STATUS  := "V"
		SZA->ZA_LOCAL   := _clocal
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
		If !Empty(_cSpc)
			SZA->ZA_SPC		:= _cSpc
		EndIf
		msunlock()
	Else
		reclock("SZA",.f.)
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
		If !Empty(_cSpc)
			SZA->ZA_SPC		:= _cSpc
		EndIf
		msunlock()
	Endif
	restarea(_aAreaSZA)
Endif



RecLock('ZZ4',.T.)
ZZ4->ZZ4_FILIAL 	:= xFilial('ZZ4')
ZZ4->ZZ4_CODCLI 	:= mv_par01 //Cliente?
ZZ4->ZZ4_LOJA   	:= mv_par02 //Loja?
ZZ4->ZZ4_IMEI 		:= cCodBar
ZZ4->ZZ4_CARCAC		:= cVarSIM //SIM/Caraça
ZZ4->ZZ4_CODPRO 	:= _cCodPro //Produto? (mv_par03)
ZZ4->ZZ4_GRPPRO		:= Posicione("SB1",1,xFilial("SB1") + _cCodPro, "B1_GRUPO")
ZZ4->ZZ4_VLRUNI		:= _nVlrUnit //Valor do Produto (mv_par06)
ZZ4->ZZ4_OPER   	:= mv_par07 //Operacao
ZZ4->ZZ4_KIT    	:= IIF(mv_par08==1,"S","N")  // Nicoletti
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
ZZ4->ZZ4_NUMVEZ     := _nVez+1  //iif(_nbounce > 0 .and. _nQualiVez > 0 .and. _nVez==0,_nQualiVez+1,_nVez+1)
ZZ4->ZZ4_OPEBGH     := iif(empty(coperatu),mv_par09,coperatu)
ZZ4->ZZ4_GARANT     := mv_par16 //IIF(EMPTY(mv_par16) .AND. _ccalcgar='S',U_Vergaran(cVarSim,mv_par09,cCodBar),mv_par16)   //iif(!_lAuto,IIF(EMPTY(mv_par16) .AND. _ccalcgar='S',U_Vergaran(cVarSim,mv_par09),mv_par16),mv_par16)
ZZ4->ZZ4_OSAUTO     := mv_par10
ZZ4->ZZ4_ITEMD1     := _cITEMD1
ZZ4->ZZ4_ASCRAP     := cscrap
ZZ4->ZZ4_ETQMEM     := _cVarmst
ZZ4->ZZ4_BOUNCE     := _nbounce
ZZ4->ZZ4_GARMCL     := CalcGarMCL(CCODBAR) // M.Munhoz - Ticket 3211 - alterado em 05/03/2012    
ZZ4->ZZ4_CODREP	    := _cZZ4_CODREP
ZZ4->ZZ4_FORMUL		:= IIF(cForm==aForm[2],"S","N")
MsUnLock('ZZ4')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB1->(DBSeek(xFilial('SB1')+_cCodPro))
if !_lAuto .or. (_lAuto .and. centriage = "S") .or. (_lAuto .and.lselqrytst)
	tMemo := 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
	tMemo += 'Produto: '+_cCodPro+' Descricao: '+SB1->B1_DESC+LFRC
	tMemo += 'SN: '+cCodBar+'   SIM/Carcaça: '+cVarSIM+LFRC
	tMemo += 'NF: '+mv_par04+' Série: '+mv_par05+' Valor: '+Transform(_nVlrUnit,'@E 999,999.99999')+LFRC
	if _nVez > 0
		tMemo += 'Este aparelho já sofreu '+alltrim(str(_nVez))+' entrada(s) anterior(es) a esta.'+LFRC
	endif
	_nVez := 0
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se eh SWAP ANTECIPADO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !_lAuto
	_aAreaSC6 := SC6->(GetArea())
	SC6->(DBOrderNickName('SC6XIMEOLD'))//SC6->(dbSetOrder(10))// C6_FILIAL + C6_XIMEOLD + C6_NUM + C6_ITEM
	if SC6->(dbSeek(xFilial("SC6") + cCodBar))
		ApMsgInfo("Este IMEI refere-se a aparelho em SWAP ANTECIPADO. ","SWAP ANTECIPADO!")
		tMemo += "SWAP ANTECIPADO: PV/ITEM -> "+SC6->C6_NUM+"/"+SC6->C6_ITEM+" == NF/SERIE -> "+SC6->C6_NOTA+"/"+SC6->C6_SERIE+LFRC
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_SWANT := SC6->C6_NUM+SC6->C6_ITEM
		msunlock()
	endif
	RestArea(_aAreaSC6)
endif

//Incluso para gravar dados da NF de compra para operacoes de producao - Edson Rorigues 22/04/10
IF _loperpro
	
	vernfcom(mv_par04,mv_par05,_cfornsrf,_cljforsrf,_cCodPro,@_nVlrUnit,'4',cCodBar)
	_dSaida:=CTOD(" / / ")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o BOUNCE                                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//SD2->(dbSetOrder(10)) // D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO) - Edson Rodrigues - 02/10/10
	SD2->(DBOrderNickName('D2NUMSEMIS')) //D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO)
	if SD2->(dbSeek(xFilial("SD2") + cCodBar))
		while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_NUMSERI == cCodBar .and. SD2->D2_EMISSAO < dDataBase
			_dSaida := SD2->D2_EMISSAO
			SD2->(dbSkip())
		enddo
	endif
	if !empty(_dSaida)
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_BOUNCE := dDataBase - _dSaida
		ZZ4->ZZ4_ULTSAI := _dSaida
		msunlock()
	endif
Endif

//Incluso para gravar dados da NF de compra para operacoes de producao - Edson Rorigues 10/01/12
If Alltrim(ZZ4->ZZ4_GARANT) == 'N' .And. AllTrim(ZZ4->ZZ4_CODPRO) $ _cSpr .and. !_lspc433
	U_CONSGA09(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
ENDIF

End Transaction 

If !_lAuto .or. centriage = "S" .or.lselqrytst
	tMemo += LFRC
	Memo  := tMemo + Memo
	Close(oDlg)
endif

cCodBar:=Replicate(' ',20)
cVarSIM:=Replicate(' ',25)
mv_par18 := Space(nTamNfe) // NF de Compra
mv_par19 := ctod("  /  / ")  // Data da NF de Compra
MV_PAR21 := SPACE(3)
MV_PAR22 := SPACE(18)
MV_PAR23 := SPACE(14)
mv_par12 := "C0022 "  // RECL. CLIENTE
mv_par13 := Space(06) //OPERADORA
mv_par14 := Space(06) //TRANSPORT
mv_par15 := "N" //ACESSORIO
mv_par16 := ""  // GARANTIA SIM OU NAO
mv_par17 := Space(20) // CONHECIMENTO/LACRE
UltReg:=.T.

Return(lResult)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011G  ºAutor  ³Antonio L.F. Favero º Data ³  13/02/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe algum atendimento em andamento          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011g(cProAT,cCodBarAT)

Local cQryAtend
Local lResult

cQryAtend:=' Select COUNT(*) TOTAL '                      //Conta quantos registros
cQryAtend+=' FROM '+RetSQLName('AB7')+' AB7 (nolock) '    //Ordem de Servico +' AB7'
cQryAtend+=" where AB7_FILIAL='"+xFilial('AB7')+"' and "  //Filtra por filial
cQryAtend+=" AB7.D_E_L_E_T_<>'*' AND"                     //Filtra deletados
cQryAtend+=" (AB7_TIPO='1' OR "                           //Filtra OS
cQryAtend+=" AB7_TIPO='3' ) AND"                          //Filtra Em Atendimento
cQryAtend+=" AB7_CODPRO='"+cProAT+"' AND"                 //Filtra Produto
cQryAtend+=" AB7_NUMSER='"+cCodBarAT+"'"                  //Filtra Numero de Serie

TCQUERY cQryAtend NEW ALIAS "QRYAtend"

if QRYAtend->TOTAL==0
	lResult:=.T.
else
	lResult:=.F.
endif

dbSelectArea('QRYAtend')
QRYAtend->(dbCloseArea())
Return(lResult)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011P  ºAutor  Edson Rodrigues      º Data ³  23/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica ultimo atendimento e se a fase de encerramento é  º±±
±±           ³ SCRAP                                                      ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011p(cProAT,cCodBarAT)

Local cQryAtend
Local lResult:=.F.
Local _clab  :=""
cscrap :="N"


ZZJ->(DbSetOrder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB


If Select("QRYAtend") > 0
	QRYAtend->(dbCloseArea())
ENDIF

cQryAtend:=" SELECT ZZ4_OS,ZZ4_FASATU,ZZ4_SETATU,ZZ4_OPEBGH "
cQryAtend+=" FROM "+RetSQLName('ZZ4')+" A (nolock) "
cQryAtend+=" INNER JOIN "
cQryAtend+="       (SELECT MAX(R_E_C_N_O_) RECNO FROM "+RetSQLName('ZZ4')+" C (NOLOCK) "
cQryAtend+="        WHERE ZZ4_FILIAL='"+xFilial('ZZ4')+"' AND ZZ4_IMEI='"+cCodBarAT+"' AND D_E_L_E_T_='' AND ZZ4_STATUS='9') AS B "
cQryAtend+=" ON A.R_E_C_N_O_ = B.RECNO "
cQryAtend+=" WHERE ZZ4_FILIAL='"+xFilial('ZZ4')+"' AND ZZ4_IMEI='"+cCodBarAT+"' AND D_E_L_E_T_='' AND ZZ4_STATUS='9' "

TCQUERY cQryAtend NEW ALIAS "QRYAtend"

If Select("QRYAtend") > 0
	QRYAtend->(dbGoTop())
	While QRYAtend->(!eof()) .and. !empty(QRYAtend->ZZ4_FASATU)
		
		IF ZZJ->(DbSeek(xFilial("ZZJ")+QRYAtend->ZZ4_OPEBGH))
			_clab:=ZZJ->ZZJ_LAB
		ELSEIF  ZZJ->(DbSeek(xFilial("ZZJ")+ALLTRIM(MV_PAR09)))
			_clab:=ZZJ->ZZJ_LAB
		ENDIF
		
		DBSelectArea('ZZ1')  //Cadastro de Fases
		IF ZZ1->(DbSeek(xFilial("ZZ1")+_clab+QRYAtend->ZZ4_SETATU+QRYAtend->ZZ4_FASATU))
			IF ZZ1->ZZ1_SCRAP='S'
				lResult:=.T.
				cscrap :="S"
			ENDIF
			
		ELSE
			DBSelectArea('ZZ3')  //Apontamento de Fases
			If ZZ3->(dbSeek(xFilial("ZZ3") + cCodBarAT + QRYAtend->ZZ4_OS))
				_cfase:=ZZ3->ZZ3_FASE1
				_csetor:=ZZ3->ZZ3_CODSET
				
				While (ZZ3->ZZ3_FILIAL == xFilial("ZZ3")) .And. (ZZ3->ZZ3_IMEI == cCodBarAT) .And. (left(ZZ3->ZZ3_NUMOS,6) == left(QRYAtend->ZZ4_OS,6))
					IF ZZ3->ZZ3_STATUS=='1'  .AND. ZZ3_ENCOS='S' .AND. ZZ3_ESTORN<>'S'
						IF ZZ1->(dbSeek(xFilial("ZZ1") +_clab+ _csetor+_cfase))
							IF ZZ1->ZZ1_SCRAP=="S"
								lResult:=.T.
								cscrap :="S"
							ENDIF
						ENDIF
					ENDIF
					ZZ3->(Dbskip())
				ENDDO
			ENDIF
		ENDIF
		QRYAtend->(Dbskip())
	Enddo
	QRYAtend->(dbCloseArea())
Endif

Return(lResult)







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011I  ºAutor  ³Antonio L.F. Favero º Data ³  23/10/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui os itens scaneados                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011i(cTexto)

Private cCadastro := "Entrada Massiva"
Private cAlias := "ZZ4"
Private aRotina := { 	{'Pesquisar' , "AxPesqui"  , 0,1},;   //"Pesquisar"
{'Visualizar', "AxVisual"  , 0,2},;   //"Visualizar"
{"Excluir"   , "u_tecx011j(@cTexto)" , 0,5},;
{'Legenda'   , "u_tecx011h" , 0,5}}      //"Legenda"
// Revisar esta legenda de cores
Private aCores :=  { 	{'ZZ4_STATUS <> "1"' , 'BR_VERDE'   },; //Sucesso
{'ZZ4_STATUS == "1"' , 'BR_VERMELHO'}}  //Não Sucesso

DbSelectArea("ZZ4") //Entrada Massiva
ZZ4->(DBSetOrder(1))
mBrowse( 6,1,22,75,cAlias, , , , , ,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011J  ºAutor  ³Antonio L.F. Favero º Data ³  27/03/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui ultimo registro no ZZ4 e atualiza Memo              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx011j(Memo)
LOCAL _cinface:="N"
//local _aAreaSZA := SZA->(getarea())

if ZZ4->ZZ4_STATUS > '1'
	Aviso('Excluir','Não é permitida a exclusão de itens já confirmados!',{'OK'})
else
	_cinface:=Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH, "ZZJ_INFACE")
	SB1->(DBSeek(xFilial('SB1')+ZZ4->ZZ4_CODPRO))
	
	tMemo:='---------------ITEM CANCELADO-----------------------'+LFRC
	tMemo+='Cliente: '+ZZ4->ZZ4_CODCLI+' Loja: '+ZZ4->ZZ4_LOJA+LFRC
	tMemo+='Produto: '+ZZ4->ZZ4_CODPRO+' Descricao: '+ALLTRIM(SB1->B1_DESC)+LFRC
	tMemo+='SN: '+ZZ4->ZZ4_IMEI+'   SIM/Carcaça: '+ZZ4->ZZ4_CARCAC+LFRC
	tMemo+='    NF: '+ZZ4->ZZ4_NFENR+' Série: '+ZZ4->ZZ4_NFESER+' Valor: '+Transform(ZZ4->ZZ4_VLRUNI,'@E 99,999.99')+LFRC
	tMemo+='----------------------------------------------------'+LFRC+LFRC
	Memo:=tMemo+Memo
	
	IF _cinface="S"
		dbSelectArea('SZC')  //Acessorios
		SZC->(dbSetOrder(1))
		
		If SZC->(DbSeek(xFilial("SZC") + ZZ4->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO)))
			While SZC->(!eof()) .and. SZC->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO) == ZZ4->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO)
				IF SZC->ZC_STATUS == '0' .AND. ALLTRIM(SZC->ZC_IMEI ) == ALLTRIM(ZZ4->ZZ4_IMEI)
					_cdestpac:=SX5->(dbSeek(xFilial("SX5") + "Z5" +SZC->ZC_TPACESS))
					
					tMemo:='---------------ACESSORIOS CANCELADO-----------------------'+LFRC
					tMemo+='ACESSORIO: '+SZC->ZC_ACESS+' Descricao: '+ALLTRIM(SZC->ZC_DESACES)+LFRC
					tMemo+='TIPO ACES: '+SZC->ZC_TPACESS+'-'+alltrim(_cdestpac)+' QTDE: '+STRZERO(SZC->ZC_QUANT,2)+LFRC
					tMemo+='----------------------------------------------------'+LFRC+LFRC
					Memo:=tMemo+Memo
					
					
					reclock("SZC",.f.)
					dbDelete()
					msunlock()
				ENDIF
				
				SZC->(DBSKIP())
			Enddo
		ENDIF
	ENDIF
	
	IF !EMPTY(ZZ4->ZZ4_ETQMEM)
		_cUpdZZO := " UPDATE "+RETSQLNAME("ZZO")+" SET ZZO_STATUS = '1' "
		_cUpdZZO += " WHERE ZZO_FILIAL = '"+xFilial("ZZO")+"'    AND "
		_cUpdZZO += "       ZZO_NUMCX  = '"+ZZ4->ZZ4_ETQMEM+"'  AND "
		_cUpdZZO += "       ZZO_STATUS = '2' AND ZZO_SEGREG<>'S' AND "
		_cUpdZZO += "       ZZO_IMEI='"+ZZ4->ZZ4_IMEI+"' AND D_E_L_E_T_ = ''"
		
		tcSqlExec( _cUpdZZO)
		TCREFRESH(RETSQLNAME("ZZO"))
		
	ENDIF
/*
	SZA->(dbSetOrder(1))  // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
	if SZA->(dbSeek(xFilial("SZA") + ZZ4->ZZ4_CLIENTE + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI))
		reclock("SZA",.f.)
		dbDelete()
		msunlock()
	endif
*/
	RecLock('ZZ4',.F.)
	Delete RECORD ZZ4->(RecNo())
	MsUnLock('ZZ4')
	
Endif

//restarea(_aAreaSZA)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011H  ºAutor  ³Antonio L.F. Favero º Data ³  26/10/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria botao de Legenda                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx011h()

BRWLegenda('Legenda','Status',{{'BR_VERDE','Confirmada'},{'BR_VERMELHO','Nao confirmada'}})

Return(nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECX011LEGºAutor  ³Antonio L.F. Favero º Data ³  27/03/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Legenda de teclas de funcoes na Janela                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011leg()

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
oSBtn1:bLClicked 	:= {|| tecx011i(@cTexto) }

//oEdBar:SetFocus()
IF centriage<>"S"
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
±±ºPrograma  ³tecx011M  ºAutor  ³Edson Rodrigues     º Data ³  18/09/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se gerou arq. Entrada execel e                    º±±
±±º            verifica se IMEI consta ou nao no arquivo                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011m(cCodBarAT)

Local lResult

cQrySZA:=' SELECT ZA_FILIAL '
cQrySZA+=' FROM '+RetSQLName('SZA')+' SZA (nolock) '
cQrySZA+=" WHERE SZA.ZA_FILIAL='"+xFilial('SZA')+"' AND "
cQrySZA+=" SZA.D_E_L_E_T_<>'*' AND"
cQrySZA+=" SZA.ZA_CLIENTE='"+MV_PAR01+"' AND "
cQrySZA+=" SZA.ZA_LOJA='"+MV_PAR02+"'  AND"
cQrySZA+=" SZA.ZA_NFISCAL='"+MV_PAR04+"' AND "
cQrySZA+=" SZA.ZA_SERIE='"+MV_PAR05+"'  AND"
cQrySZA+=" SZA.ZA_IMEI='"+cCodBarAT+"'  AND"
cQrySZA+=" SZA.ZA_STATUS IN ('I','N') "

TCQUERY cQrySZA NEW ALIAS "QRYSZA"

if QRYSZA->(EOF())
	lResult:=.T.
else
	lResult:=.F.
endif

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
static function VerFPro()

local _aAreaSF1 := SF1->(GetArea())
local _aAreaSD1 := SD1->(GetArea())
local _lRet     := .f.

SF1->(dbSetOrder(1))
_lRet := SF1->(dbSeek(xFilial('SF1') + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA)) .and. SF1->F1_FORMUL == 'S'

IF _lRet // Verifica se a nota cadastrada esta com o produto e IMEI iguais a Entrada Massiva - Edson Rodrigues - 08/04/11
	SD1->(DBOrderNickName('D1NUMSER')) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER
	
	If !SD1->(DbSeek(xFilial('SD1')+ZZ4->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+Substr(ZZ4_IMEI,1,20))) )
		MsgBox("Entr. Massiva refere-se ha uma NFE com formulário proprio igual a Sim. O Produto e ou o IMEI da NFE estao diferentes da E.Massiva. Essa E.Massiva nao sera confirmada, Corrija a NFE !","Produto e ou IMEI da NFE Diferente da E.Massiva","ALERT")
		_lRet:=.F.
	ENDIF
	
Endif

restarea(_aAreaSF1)
restarea(_aAreaSD1)
return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecax11n  ºAutor  ³ Edson              º Data ³  03/05/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para digitação das informações iniciais da entrada    º±±
±±º          ³ massiva  - Outras Informacoes                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function tecax11n(_lnfcomp,cinfcaut)

Local _lOk := .f.
creccli:=Space(30)
ccodope:=Space(30)
cdescpf:=Space(30)
mv_par18 := Space(nTamNfe) // NF de Compra
mv_par19 := ctod("  /  / ")  // Data da NF de Compra
MV_PAR21 := SPACE(3)
MV_PAR22 := SPACE(18)
MV_PAR23 := SPACE(14)
mv_par10 := Space(12) //OS SAM
mv_par11 := Space(11) // COD. AUTORIZ.
mv_par12 := "C0022 "  // RECL. CLIENTE
mv_par13 := Space(06) //OPERADORA
mv_par14 := Space(06) //TRANSPORT
mv_par15 := "N" //ACESSORIO
mv_par16 := ""  // GARANTIA SIM OU NAO
mv_par17 := Space(20) // CONHECIMENTO/LACRE




//if _lnfcomp .AND. MV_PAR09="N03"
If _lnfcomp .AND. cinfcaut='S'
	@ 116,095 To 460,536 Dialog TelaOutras Title OemToAnsi("Outras informações ")
	@ 002,009 To 165,210 Title OemToAnsi("Dados SAM e NF compra Aparelho")
	
	@ 001,002 Say OemToAnsi("OS SAM:") Size 41,8
	@ 002,002 Say OemToAnsi("Cod Autorizada:")       Size 26,8
	@ 003,002 Say OemToAnsi("Cod Recl. Cliente:")     Size 29,8
	@ 004,002 Say OemToAnsi("Cod. Operadora:")           Size 29,8
	@ 005,002 Say OemToAnsi("NF Compra:")         Size 29,8
	@ 006,002 Say OemToAnsi("Serie NF Compra:")         Size 29,8
	@ 007,002 Say OemToAnsi("Data Compra:")         Size 29,8
	@ 009,002 Say OemToAnsi("CNPJ Forn. NF Compra")         Size 29,8
	@ 008,002 Say OemToAnsi("CPF/CNPJ Consumidor:")         Size 29,8
	
	
	@ 011,055 Get mv_par10 Size 050,010 Picture "@!"  	 valid !empty(mv_par10)	.and. left(mv_par10,2) == "BR" Object ossam
	@ 024,055 Get mv_par11 Size 050,010 Picture "@!"      valid u_valtx11n(mv_par11,"5")	 Object ocodaut
	@ 038,065 Get mv_par12 Size 025,010 Picture "@!"  	 valid u_valtx11n(alltrim(mv_par12),"1")  F3 "W4" Object ocrecli
	@ 038,100 Get creccli  Size 100,010 When .f.
	@ 052,057 Get mv_par13 Size 026,010 Picture "@!"      valid u_valtx11n(alltrim(mv_par13),"2")  F3 "W1" Object ooperad
	@ 052,090 Get ccodope  Size 110,010 When .f.
//	@ 065,057 Get mv_par18 Size 025,010 Picture "@!"		 valid !empty(mv_par18)	 Object onfcom
	@ 065,057 Get mv_par18 Size 025,010 Picture "@!" Object onfcom
//	@ 078,059 Get mv_par21 Size 010,010 Picture "!!!" 
	@ 078,059 Get mv_par21 Size 010,010 Picture "!!!" When !empty(mv_par18) 
//	@ 091,057 Get mv_par19 Size 025,010 Picture " / / "   valid u_valtx11n(mv_par19,"3") Object odtnfco
	@ 091,057 Get mv_par19 Size 025,010 Picture " / / " valid u_valtx11n(mv_par19,"3") Object odtnfco
//	@ 104,075 Get mv_par22 Size 059,010 Picture "@R 99.999.999/9999-99"
	@ 104,075 Get mv_par22 Size 059,010 Picture "@R 99.999.999/9999-99" When !empty(mv_par18) 
//	@ 117,075 Get mv_par23 Size 059,010 Picture "@R 99999999999999"  //valid u_valtx11n(mv_par23,"4") Object ocpfcli
	@ 117,075 Get mv_par23 Size 059,010 Picture "@R 99999999999999" When !empty(mv_par18) //valid u_valtx11n(mv_par23,"4") Object ocpfcli
	@ 130,075 Get cdescpf  Size 120,010 When .f.
	
	@ 150, 140 BMPBUTTON TYPE 1 ACTION (_lOk := .T., Close(TelaOutras))
	@ 150, 170 BMPBUTTON TYPE 2 ACTION (_lOk := .f., Close(TelaOutras))
	
	
	//Elseif _lnfcomp .AND. !MV_PAR09="N03"
ElseIf _lnfcomp .AND. cinfcaut='N'
	
	@ 116,095 To 380,536 Dialog TelaOutras Title OemToAnsi("Outras informações ")
	@ 002,009 To 115,210 Title OemToAnsi("Dados NF Compra Aparelho")
	
	@ 001,002 Say OemToAnsi("NF Compra:")         Size 29,8
	@ 002,002 Say OemToAnsi("Serie NF Compra:")         Size 29,8
	@ 003,002 Say OemToAnsi("Data Compra:")         Size 29,8
	@ 004,002 Say OemToAnsi("CNPJ Forn. NF Compra")         Size 29,8
	@ 005,002 Say OemToAnsi("CPF/CNPJ Consumidor:")         Size 29,8
	
	
	@ 011,057 Get mv_par18 Size 025,010 Picture "@!"			valid !vazio()	 Object onfcom
	@ 024,059 Get mv_par21 Size 010,010 Picture "!!!"
	@ 038,057 Get mv_par19 Size 025,010 Picture " / / "       valid u_valtx11n(mv_par19,"3") Object odtnfco
	@ 052,075 Get mv_par22 Size 059,010 Picture "@R 99.999.999/9999-99"
	@ 065,075 Get mv_par23 Size 059,010 Picture "@R 99999999999999" valid u_valtx11n(mv_par23,"4") Object ocpfcli
	@ 078,075 Get cdescpf  Size 120,010 When .f.
	
	
	@ 100, 140 BMPBUTTON TYPE 1 ACTION (_lOk := .T., Close(TelaOutras))
	@ 100, 170 BMPBUTTON TYPE 2 ACTION (_lOk := .f., Close(TelaOutras))
	
	//Elseif !_lnfcomp .AND. MV_PAR09="N03"
ElseIf !_lnfcomp .AND. cinfcaut='S'
	
	@ 116,095 To 350,536 Dialog TelaOutras Title OemToAnsi("Outras informações ")
	@ 002,009 To 115,210 Title OemToAnsi("Dados SAM")
	
	@ 001,002 Say OemToAnsi("OS SAM:") Size 41,8
	@ 002,002 Say OemToAnsi("Cod Autorizada:")       Size 26,8
	@ 003,002 Say OemToAnsi("Cod Recl. Cliente:")    Size 29,8
	@ 004,002 Say OemToAnsi("Cod. Operadora:")       Size 29,8
	
	@ 011,055 Get mv_par10 Size 050,010 Picture "@!"  			valid !vazio()	 Object ossam
	@ 024,055 Get mv_par11 Size 050,010 Picture "@!"           	valid !vazio()	 Object ocodaut
	@ 038,065 Get mv_par12 Size 025,010 Picture "@!"  			valid u_valtx11n(alltrim(mv_par12),"1")  F3 "W4" Object ocrecli
	@ 038,100 Get creccli  Size 100,010 When .f.
	@ 052,057 Get mv_par13 Size 026,010 Picture "@!"           	valid u_valtx11n(alltrim(mv_par13),"2")  F3 "W1" Object ooperad
	@ 065,090 Get ccodope  Size 110,010 When .f.
	
	@ 080, 140 BMPBUTTON TYPE 1 ACTION (_lOk := .T., Close(TelaOutras))
	@ 080, 170 BMPBUTTON TYPE 2 ACTION (_lOk := .f., Close(TelaOutras))
	
Endif


Activate Dialog TelaOutras

Return(_lOk)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Valtx11n  ºAutor  ³ Edson Rodrigues    º Data ³  03/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz as validacoes da tela de Outras informacoes digitadas   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function valtx11n(cChave,cQual)
Local lRet		:=.t.
local aAlias  	:= {"SA1"}
local aAmb    	:= U_GETAMB(aAlias)
//local ndias   := iif(MV_PAR09="N02",450,396)
local lRet    	:= .t.
Local _cChav		:= cChave
Local _pergar   := Posicione("ZZJ", 1, xFilial("ZZJ") + ALLTRIM(mv_par09), "ZZJ_PERGAR")
local _cXcodSam
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
EndIf
If Select("TRB") > 0
	TRB->(dbCloseArea())
endif
If Select("TRB3") > 0
	TRB3->(dbCloseArea())
endif


if cQual=='3'.And. !Empty(DTOS(_cChav))      // Alterado 09/06/10 para nao pegar parametro vazio
	
	//_cQryExec := " SELECT DATEDIFF(MONTH, '" + DTOS(_cChav) + "' , GETDATE()) as DATES "
	
	_cQryExec := " SELECT CONVERT(VARCHAR(10),DATEADD(MONTH, " + Transform(_pergar ,"@E 99") + ",'" + DTOS(_cChav) + "' ),112) AS DATES "
	
	TCQUERY _cQryExec NEW ALIAS "TRB"
	
	// Nf- compra tem mais 30 dias corrido apos o vencimento inserindo SPC......
	// Sendo todas todas operacoes
	// Removido Transform(_pergar + 1,"@E 99") errado.


	_cQryExec1  := "	SELECT CONVERT(VARCHAR(10),DATEADD(DAY, 30,'" + TRB->DATES + "' ),112) AS DIAS "
	
	TCQUERY _cQryExec1 NEW ALIAS "TRB3"
	
Endif

If cQual=="4"
	SA1->(DbSetOrder(3)) // A1_FILIAL + A1_CGC
	SA1->(DbSeek(xFilial("SA1")+cQual,.f.))
Endif

If cQual == "1" // Reclamacao do Cliente
	SX5->(dbseek("W4"+alltrim(mv_par12)))
	if Empty(cChave)
		MsgBox("Reclamacao do Clinte deve ser digitado !","Outras Informações","ALERT")
		lRet := .f.
	elseif !ExistCpo("SX5","W4"+alltrim(mv_par12))
		MsgBox("Não foi encontrado este código de Reclamacao no sistema, Favor verificar.","Outras Informações","ALERT")
		lRet := .f.
	else
		creccli := SX5->X5_DESCRI
		ooperad:SetFocus()
	endif
Elseif	cQual == "2" // Operadora
	SX5->(dbseek("W1"+alltrim(mv_par13)))
	if Empty(cChave)
		MsgBox("Operadora deve ser digitado !","Outras Informações","ALERT")
		lRet := .f.
	elseif !ExistCpo("SX5","W1"+alltrim(mv_par13))
		MsgBox("Não foi encontrado este código de Reclamacao no sistema, Favor verificar.","Outras Informações","ALERT")
		lRet := .f.
	else
		ccodope := SX5->X5_DESCRI
		if _lnfcomp
			onfcom:SetFocus()
		Endif
	endif
	
Elseif	cQual == "3" // Data da compra	---sempre operacao Retail
	if Empty(cChave)
		MsgBox("Data da NF de compra deve ser digitado !","Outras Informações","ALERT")
		lRet := .f.
	elseif cChave > ddatabase
		MsgBox("Data da NF de compra deve deve ser menor que data do sistema !","Outras Informações","ALERT")
		lRet := .f.
	elseif  TRB->DATES < DTOS(_cChav) .And. DTOS(_cChav) <= TRB3->DIAS
		mv_par16:= "S"
		_cSpc	:= "SPC0000456"
	elseif TRB->DATES < DTOS(_cChav) .And. DTOS(_cChav) > TRB3->DIAS
		mv_par16:= "N"
		_cSpc	:=	""
	Endif
	
Elseif cQual == "4" //CNPJ/CPF do Cliente.
	if Empty(cChave)
		MsgBox("CPF/CNPJ do Consumidor deve ser digitado !","Outras Informações","ALERT")
		lRet := .f.
	elseif !SA1->(DbSeek(xFilial("SA1")+cChave,.f.))
		MsgBox("Não existe cliente cadastrado com o CNPJ digitado, Favor Cadastrar assim que terminar essa entrada massiva.","Outras Informações","ALERT")
		cdescpf:="Favor Cadastrar Cliente assim que terminar essa entrada massiva"
	else
		cdescpf:="Cliente Ja Cadastrado"
	endif
Endif

cXcodSam :=	Posicione("SA1",1,xFilial("SA1")+AllTrim(mv_par01)+AllTrim(mv_par02),"A1_XCODSAM")

If cQual == "5"
	If Empty(cChave)
		MsgBox("Favor Inserir oCodigo do SAM!","Outras Informações","ALERT")
		lRet := .f.
	Endif
	
	If AllTRim(cXcodSam) <> AllTrim(cChave)
		MsgBox("Codigo Divergente com Cadastro!","Outras Informações","ALERT")
		lRet := .f.
	EndIf
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
endif
If Select("TRB3") > 0
	TRB3->(dbCloseArea())
endif
cMsg :=  "Data " + Transform(_cChav,"@E 99999999") + "SISTEM (S/N) " + mv_par16 + " -  Garantia Operacao (" + TransForm(_pergar,"@E 99") + ")  tecax011  "
WFConOut( cMsg, oLogFile, .f. )
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
User function tecax11m(ccodbar,_cSepEnt,_cCodPro)
Local lRet:=.t.
Local cVarACE:= Replicate(' ',20)

_acess :={}

If Alltrim(_cSepEnt) == "S"
	Processa({|| u_tecaxSG1(@cVarACE,@cTextac,.F.,ccodbar,_cCodPro) },"Processando Cadastro de Acessorio...")
Endif


While !_lFechCS
	
	@ 0,0 TO 360,520 DIALOG oDlgaces TITLE "Cadastro de Acessorios"
	oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"CodBar.bmp",.T.,oDlgaces)
	
	@ 005,077 SAY oV1 var "Passe a leitora de" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
	
	If Alltrim(_cSepEnt) == "S"
		@ 050,010 GET cVarACE Size 100,080 PICTURE "@!" valid u_gravaces(@cVarACE,@cTextac,.F.,ccodbar) Object ocodbace when .F.
	Else
		@ 050,010 GET cVarACE Size 100,080 PICTURE "@!" valid u_gravaces(@cVarACE,@cTextac,.F.,ccodbar) Object ocodbace
	Endif

	@ 065,010 GET cTexTac  Size 150,115 MEMO Object oMemoaces //when .F.
	
	@ 150,180 BUTTON "CONFIRMA     " 	SIZE 60,13 ACTION Processa({|| U_confaces(_acess,oDlgaces,@cTextac) })
	@ 160,180 BUTTON "CANCELA" 			SIZE 60,13 ACTION IIF(MSGYESNO("DESEJA REALMENTE CANCELAR? TODOS ACESSORIOS DEVERÃO SER APONTADOS NOVAMENTE."),concaces(.f.,oDlgaces,@cTextac),)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria legenda de funcoes na tela                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//tecx011leg()
	
	Activate MSDialog oDlgaces On Init ocodbace:SetFocus()
	
Enddo
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
local lpartn     := .T.
Local tMemo      := ""
Local _cCodPro   := mv_par03
Local _nVlrUnit  := mv_par06
Local _nVez      := 0
Local _codaces   :=left(cCodaces,15)
Local _ctpacess  := SPACE(6)

_cdescr    := SPACE(30)


// So executa a validacao se o codigo de barra nao estiver preenchido
if Empty(cCodaces)
	IF MSGYESNO("Não foi escaneado ou digitado o acessório. Quer informar somente o acessório e não informar o partnumber ? ")
		lpartn:=.F.
	ELSE
		// lResult:=.F.
		Return(lResult)
	ENDIF
Endif

// Alterado Edson Rodrigues
If "'" $ cCodaces  .or. '"' $ cCodaces .and. lpartn
	tMemo := '------Proibido informar aspas simples ou duplas no Codigo de Acesssorios.--------'+LFRC+LFRC
	Memoaces := tMemo+Memoaces
	cCodaces:=Replicate(' ',20)
	Close(oDlg)
	lResult:=.F.
	Return(lResult)
Endif

If !_lAuto .and. !empty(cCodaces) .and. lpartn
	_lvaldesc   := .T.
	IF SB1->(!dbSeek(xFilial("SB1") + _codaces))
		dbSelectArea("SZC")
		dbSetOrder(2)
		If dbSeek(xFilial("SZC")+ cCodaces)
			While !SZC->(EOF())	.and. SZC->ZC_FILIAL==xFilial("SZC") .and. ALLTRIM(SZC->ZC_ACESS)==ALLTRIM( cCodaces)
				IF  !empty(SZC->ZC_DESACES) .and. !SZC->ZC_DESACES==ALLTRIM( cCodaces)
					mv_par20:=ALLTRIM(SZC->ZC_DESACES)
					_lvaldesc   := .T.
					exit
				Else
					_lvaldesc   := .F.
				Endif
				SZC->(dbskip())
			Enddo
		ELSE
			_lvaldesc   := .F.
		Endif
		
	ELSE
		SB1->(dbSeek(xFilial("SB1") + _codaces))
		mv_par20:=ALLTRIM(SB1->B1_DESC)
	ENDIF
ELSE
	_lvaldesc   := .F.
Endif


IF !_lvaldesc .and. lpartn
	
	//Janela de cadastro da descricao de acessorios
	oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
	@ 0,0 TO 200,300 DIALOG oDlgdesac TITLE "Cadastro Descricao Acessorio"
	oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlgdesac)
	@ 05,050 SAY oV1 var "Digite a Descricao do Acessorio:" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
	@ 40,010 GET _cdescr Size 100,080 PICTURE "@!" valid !Vazio()
	@ 80,085 BMPBUTTON TYPE 1 ACTION Processa({|lEnd| caddesc(_cdescr,oDlgdesac,.f.,@cCodaces)})
	@ 80,120 BMPBUTTON TYPE 2 ACTION oDlgdesac:End()
	Activate MSDialog oDlgdesac Centered
	
ELSEIF _lvaldesc .and. lpartn
	_cdescr:=ALLTRIM(mv_par20)
ENDIF

//verifica se  descrição e um código de acessório -Edson Rodrigues -01/10/10 /
// revisado e alterado em 11/11/10 - Edson Rodrigues
If !_lvaldesc .and. !empty(_cdescr)
	
	If SB1->(!dbSeek(xFilial("SB1") + ALLTRIM(_cdescr)))
		dbSelectArea("SZC")
		dbSetOrder(2)
		If dbSeek(xFilial("SZC")+ ALLTRIM(_cdescr))
			While !SZC->(EOF())	.and. SZC->ZC_FILIAL==xFilial("SZC") .and. ALLTRIM(SZC->ZC_ACESS)==ALLTRIM(_cdescr) .AND. !SZC->ZC_DESACES==ALLTRIM(_cdescr)
				If !empty(SZC->ZC_DESACES)
					mv_par20:=ALLTRIM(SZC->ZC_DESACES)
					cCodaces:=SZC->ZC_ACESS
					exit
				Endif
				SZC->(dbskip())
			Enddo
		EndIf
	Else
		SB1->(dbSeek(xFilial("SB1") + ALLTRIM(_cdescr)))
		mv_par20:=ALLTRIM(SB1->B1_DESC)
		cCodaces:=SB1->B1_COD
	EndIf
EndIf

//abre tela de escolha do tipo de acessorio - Edson Rodrigues - 08/09/10.
_actacess 	:= U_TPACESS(@_actacess, _codaces, _cdescr)
Memoaces 	:= ""

If  Len(_actacess)  > 0
	ltemtpac:=.F.
	
	_acess := {}	
	For nY:=1 To Len(_actacess)
		
		_cdesctpa:=Posicione("SX5",1,xFilial("SX5") + "Z5"+_actacess[nY,1], "X5_DESCRI")
		
		dbSelectArea("SZC")
		dbSetOrder(1)
		
		//Caso o usuário nao informou o partnumber do acessório, entao o sistema assume como
		//codigo e decricao,  o tipo e descricao de acessorio escolhido - Edson 11/11/10
		If !lpartn .and. empty(cCodaces)
			cCodaces := _actacess[nY,1]
		endif
		
		IF  !lpartn .and. empty(_cdescr)
			_cdescr  :=_cdesctpa
		Endif
		
		IF SZC->(DbSeek(xFilial("SZC") + mv_par04+mv_par05+mv_par01+mv_par02+_cCodPro))
			While SZC->(!eof()) .and. SZC->(ZC_DOC+ZC_SERIE+ZC_FORNECE+ZC_LOJA+ZC_CODPRO) == mv_par04+mv_par05+mv_par01+mv_par02+_cCodPro
				IF SZC->ZC_IMEI=cCodBar .AND. SZC->ZC_TPACESS==_actacess[nY,1]
					IF !MSGYESNO("O Tipo de Acessorio escolhido : "+_actacess[nY,1]+"-"+alltrim(_cdesctpa)+"  ja foi informado no cod/acess. : "+SZC->ZC_CODACES+" - "+alltrim(SZC->ZC_DESACES)+" Voce quer repetir esse mesmo tipo de acessorio para o cod/acess : "+cCodaces+"-"+alltrim(_cdescr)+" ?")
						ltemtpac:=.t.						
						//ELSE
						//    IF !MSGYESNO(" TEM CERTEZA ABSOLUTA que voce quer repetir o mesmo tipo de acessorio para o cod/acess : "+cCodaces+"-"+alltrim(_cdescr)+" ?")
						//        ltemtpac:=.t.
						//ENDIF
					ENDIF
				ENDIF
				SZC->(DBSkip())
			Enddo
		Endif
		
		IF  !ltemtpac			
			
			aadd(_acess,{mv_par04,mv_par05, mv_par01,mv_par02,cCodBar,Posicione("SA1",1,xFilial("SA1") + mv_par01+mv_par02, "A1_NOME"),;
			_cCodPro,Posicione("SB1",1,xFilial("SB1") + _cCodPro, "B1_DESC"),IIF(!Empty(_actacess[nY,3]),AllTrim(_actacess[nY,3]),""),;
			IIF(!Empty(_actacess[nY,2]),_cdesctpa,""),_actacess[nY,1],""})
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			if !_lAuto
				tMemo := 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
				if lpartn .And. !Empty(_actacess[nY,2])
					//tMemo += 'Part. Acess: '+AllTrim(_actacess[nY,3])+' Descricao: '+_actacess[nY,2]+LFRC
				Endif
				tMemo += 'Tipo Acess : '+_actacess[nY,1]+'-'+_cdesctpa+LFRC
				tMemo += 'IMEI: '+cCodBar+' NF: '+mv_par04+' Série: '+mv_par05+LFRC
				tMemo += '---------------------------------------------------------------'+LFRC
				Memoaces := tMemo+LFRC+Memoaces+LFRC
			endif
		Else
			MsgBox("Tipo de acessorio repetido, informe novamente !","Tipo de acessorio repetido ","ALERT")
		Endif
	Next nY
Else
	MsgBox("E obrigatorio informar o tipo de acessorio !","Tipo de acessorio nao selecionado","ALERT")
Endif

cVarACE  := Replicate(' ',20)
cCodaces := Replicate(' ',20)
_cdescr  := SPACE(30)
mv_par20 := SPACE(30)
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


IF len(_acess) > 0
	_nqtdaces:=len(_acess)
	if ApMsgYesNo('Foram escaneados :'+STRZERO(_nqtdaces,3)+'  Acessórios. Confirma essa quantidade de acessórios?','Confirma Acessorios')
		for x:=1 to len(_acess)
			RecLock('SZC',.T.)
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
Static function caddesc(_cdescr,oDlgdesac,_llog,cCodaces)
MV_par20:=_cdescr
Close(oDlgdesac)
cCodaces:=Replicate(' ',20)
ocodbace:setfocus()
return()

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

if !_lAuto
	If len(_acess) > 0
		_acess:={}
	Endif
	memoaces:=""
	Close(oDlg)
endif

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


Local _dmes    := SUBSTR(DTOC(ddatabase),4,2)
Local _cdia    := IIF(_dmes='02','28',IIF(_dmes $ "01/03/05/07/08/10/12",'31','30'))
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
Local _cimei   :=iif(cimei=nil,Replicate(' ',20),cimei)
Local _lvcarc  := .t.

//Local _ddtfabr := ctod(_cdia+"/"+substr(_cmes,1,2)+"/"+_cano)
//Local _ndiasgar:=IIF(alltrim(coper) = "N02",450,396)

IF SX5->(dbseek(xfilial("SX5")+"WD"+alltrim(_cvmessim)))
	_cmes:= ALLTRIM(SX5->X5_DESCRI)
ELSE
	MsgBox("Carcaça Invalida ou o identificador do mes de fabricação : "+_cvmessim+" não existe na tabela WD dos SX5 !","Digite uma carcaça válida ou entre em contato com Administrador do sistema","ALERT")
	_lvcarc:= .f.
ENDIF
IF SX5->(dbseek(xfilial("SX5")+"WC"+alltrim(_cvanosim)))
	_cano:= ALLTRIM(SX5->X5_DESCRI)
ELSE
	MsgBox("Carcaça Invalida ou o identificador do ano de fabricação : "+_cvanosim+" não existe na tabela WC dos SX5 !","Digite uma carcaça válida ou entre em contato com Administrador do sistema","ALERT")
	_lvcarc:= .f.
Endif
_cdia    := IIF(substr(_cmes,1,2)='02','28',IIF(substr(_cmes,1,2) $ "01/03/05/07/08/10/12",'31','30'))
_ddtfabr := ctod(_cdia+"/"+substr(_cmes,1,2)+"/"+_cano)
_ddtfabr := _cano + substr(_cmes,1,2) + _cdia

oLogFile := WFFileSpec( cReceiveDir + "receive.log" )
cMsg := Replicate( "*", 80 )
oLogFile:WriteLN( cMsg )
ConOut( cMsg )

If Select("QRY") > 0
	QRY->(dbCloseArea())
	
EndIf
If Select("TRB") > 0
	TRB->(dbCloseArea())
endif                           

//Incluso IF para não pegar as operacoes iniciadas com N - Edson Rodrigues - 23/07/12
if left(AllTrim(coper),1)<>'N'
  //  Trecho incluido por Luis Carlos - Maintech - Abril / 2012 - Se o aparelho estiver entrando pela primeira vez é garantia
	_cQuery :=	"SELECT COUNT(*) AS total FROM "+RetSqlName("ZZ4")+"  AS ZZ4 (nolock)  WHERE ZZ4_IMEI = '" + _cimei + "'"
	TCQUERY _cQuery NEW ALIAS "TRB1"
	if TRB1->total == 0
		_cgaran:= "S"
	endif
Endif


If !Empty(_ddtfabr)			// Alterado 09/06/10 para nao pegar parametro vazio
	
	_cQryExec := " SELECT DATEDIFF(MONTH, '" + _ddtfabr + "' , GETDATE()) AS DATES "
	TCQUERY _cQryExec NEW ALIAS "TRB"
	
	If TRB->DATES <= _pergar .and. _lvcarc
		_cgaran:= "S"
	ELSEIF TRB->DATES > _pergar  .and. _lvcarc
		_cgaran:= "N"
	EndIf
	
	
	cMsg :=  "Data Fabricacao - " + _ddtfabr + "SISTEM (S/N) " + cVarSim + _cgaran + " Garantia Operacao (" + TransForm(_pergar,"@E 99") + ")  Vergaran  "
	WFConOut( cMsg, oLogFile, .f. )
	cMsg := Replicate( "*", 80 )
	oLogFile:WriteLN( cMsg )
	WFConOut( cMsg )
	
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
endif
If Select("TRB1") > 0
	TRB1->(dbCloseArea())
endif

return(_cgaran)


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
Local _lret    :=.t.
Local _cprefix :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_PREFIX")
Local _cnewpro :=IIF(left(cProd,3)=="DPY",alltrim(_cprefix)+substr(alltrim(cProd),4,12),alltrim(_cprefix)+alltrim(cProd))

DbSelectArea("SD1")
DbSetOrder(12)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD

IF cver =='1'
	If !SD1->(DbSeek(xFilial('SD1')+cdoc+cser+ccli+cloja+cProd) )
		_lret:=.F.
	Endif
ELSEIF cver =='2'
	If SD1->(DbSeek(xFilial('SD1')+cdoc+cser+ccli+cloja+cProd) )
		IF SD1->D1_VUNIT<>_nVlrUnit
			// If ApMsgYesNo('Valor digitado : '+STR(_nVlrUnit)+' diferente do digitado na NF de compra : '+STR(SD1->D1_VUNIT)+'. Quer alterar o valor digitado pelo valor da Nfe de compra ?','Confirma Valor')
			_nVlrUnit:=SD1->D1_VUNIT
			// Else
			//  _lret:=.F.
			// Endif
		Endif
	Else
		_lret:=.F.
	Endif
ELSEIF cver =='3'
	DbSelectArea("SB1")
	DbSetOrder(1)       // B1_FILIAL + B1_COD
	If !SB1->(DbSeek(xFilial('SB1')+_cnewpro))
		MsgBox("Produto a Reformar : "+_cnewpro+" não cadastrado!","Favor cadastrar e depois fazer a entrada massiva novamente","ALERT")
		_lret:=.F.
	Endif
Elseif cver =='4'
	SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
	SB1->(dbSeek(xFilial("SB1") + cProd))
	ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
	If SD1->(DbSeek(xFilial('SD1')+cdoc+cser+ccli+cloja+cProd) )
		If ZZ4->(dbSeek(xFilial("ZZ4") + SD1->D1_DOC + SD1->D1_SERIE + mv_par01 + mv_par02 + SD1->D1_COD + cimei ))
			Reclock("ZZ4",.f.)
			ZZ4->ZZ4_NFEDT  := SD1->D1_DTDIGIT
			ZZ4->ZZ4_NFEHR  := Posicione("SF1",1,xFilial("SF1")+cdoc+cser+ccli+cloja+'N',"F1_HORA")
			ZZ4->ZZ4_DOCDTE := SD1->D1_DTDOCA
			ZZ4->ZZ4_DOCHRE := left(SD1->D1_HRDOCA,2)+":"+substr(SD1->D1_HRDOCA,3,2)+":00"
			ZZ4->ZZ4_LOCAL  := SD1->D1_LOCAL
			ZZ4->ZZ4_GRPPRO := SB1->B1_GRUPO
			Msunlock()
		Endif
	ENDIF
ENDIF

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
Local _lvalsza   := .f.
Local _clote     :=""
Local _cdpyim    :=""
Local _cgvsos    :=""
Local _clocal    :=""
Local _nVez      := 0
Local _cITEMD1   := ""
Local _cfornsrf  := ""
Local _cljforsrf := ""
Local nTam       := 14
Local _ccalcgar  := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_coper), "ZZJ_CALGAR")


// So executa a validacao se o codigo de barra Não estiver preenchido
If ALLTRIM(cCodBar)='' .and. _nqtde >  0  .AND. cgeraimei="02"
	
	FOR I=1 TO _nqtde
		tMemo:=""
		CNEWIMEFL:=''
		//If  (GetMV("MV_XIMEFLI",.T.))  Alterado para buscar o ultimo código gerado na base de dados -- Edson Rodrigues - 23/02/10
		//	cCodBar := Soma1(Subs(GetMV("MV_XIMEFLI"),1,nTam))
		CNEWIMEFL:=ULTIMEFL(prefix)
		IF !EMPTY(CNEWIMEFL)
			IF prefix='IT' .AND. ABS(VAL(Subs(CNEWIMEFL,3,12))) < 10000
				CNEWIMEFL:='IT0000000100000'
				cCodBar  := Soma1(Subs(CNEWIMEFL,3,12))
			ELSE
				cCodBar := Soma1(Subs(CNEWIMEFL,3,12))
			ENDIF
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
		IF SB1->(dbSeek(xFilial("SB1") + _cCodPro)) .and. (SB1->B1_LOCALIZ == "S")
			MsgBox("O Produto: "+alltrim(_cCodPro)+" com controle de Localizacao. Rotina não preparada para produtos com controle de localização !","Produtos com controle de localização","ALERT")
			tMemo += "O Produto: "+alltrim(_cCodPro)+" com controle de Localizacao - Rotina não preparada para produtos com controle de localização "+LFRC
			Memo:=tMemo+Memo
			cCodBar:=Replicate(' ',20)
			Close(oDlg)
			Return
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se base instalada ja existe                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AA3")
		dbSetOrder(4)
		If dbSeek(xFilial("AA3") + Space(8) + _cCodPro + cCodBar)
			tMemo+='------Ja Existe Base Instalada!------'+LFRC+LFRC
			Memo:=tMemo+Memo
		EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se IMEI ja sofreu entrada massiva                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ZZ4->(DBSetOrder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
		//	ZZ4->(DBGoTop())
		//If ZZ4->(DBSeek(xFilial('ZZ4')+cCODBAR))
		If ZZ4->(DBSeek(xFilial('ZZ4')+cCODBAR)) .or. ZZ4->(DBSeek("02"+cCODBAR))
			If ZZ4->ZZ4_STATUS <> '9' // NFS gerada
				// Coloquei essa condição porque se acaso o IMEI já tenha sido gravado por outro processo ou
				// a query da funcao ULTIMEFL nao encontre o IMEI gravado anteririormente dentro desse for-next
				// Edson Rodrigues - 20/04/10
				CNEWIMEFL:=''
				CNEWIMEFL:=ULTIMEFL(prefix)
				IF !EMPTY(CNEWIMEFL)
					cCodBar := Soma1(Subs(CNEWIMEFL,3,12))
					cCodBar :=prefix+cCodBar+U_GDVan(cCodBar)
				ENDIF
				//tMemo   += '------Esse celular já foi registrado--------'+LFRC+LFRC
				//Memo:= tMemo+Memo
				//cCodBar += Replicate(' ',20)
				//Close(oDlg)
				//Return
			else
				//Procura IMEI na filial 02 - Luciano - Delta
			    ZZ4->(DBSetOrder(1))
				If ZZ4->(DBSeek("02"+cCODBAR))
					while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == "02" .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar)
						If ZZ4->ZZ4_STATUS=='9'
							_nVez++
						Endif
						ZZ4->(dbSkip())
					Enddo
				Endif   
				
				//Procura IMEI na filial corrente - Luciano - Delta
			    ZZ4->(DBSetOrder(1))
				If ZZ4->(DBSeek(xFilial('ZZ4')+cCODBAR))
					while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar)
						If ZZ4->ZZ4_STATUS='9'
							_nVez++
						Endif
						ZZ4->(dbSkip())
					Enddo
				Endif
			    /*
				while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCodBar) .and.;
					mv_par01 == ZZ4->ZZ4_CODCLI .and. mv_par02 == ZZ4->ZZ4_LOJA .and. alltrim(_cCodPro) == alltrim(ZZ4->ZZ4_CODPRO)
					_nVez++
					ZZ4->(dbSkip())
				enddo
				*/
			endif
		endif
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a OS esta em atendimento                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if !_lAuto .and. !tecx011g(_cCodPro,cCodBar)
			tMemo += '------Esse aparelho esta em atendimento--------'+LFRC+LFRC
			Memo:=tMemo+Memo
			cCodBar:=Replicate(' ',20)
			Close(oDlg)
			Return
		endif
		
		IF EMPTY(mv_par16) .AND. _ccalcgar='S'
			mv_par16:=U_Vergaran(cCodBar,mv_par09,cCodBar)
			IF EMPTY(MV_PAR16)
				tMemo := '------Carcaça Invalida--------'+LFRC+LFRC
				Memo  := tMemo+Memo
				cCodBar:=Replicate(' ',20)
				if !_lAuto
					Close(oDlg)
				endif
				Return
			ENDIF
		ENDIF
		
		
		
		RecLock('ZZ4',.T.)
		ZZ4->ZZ4_FILIAL 	:= xFilial('ZZ4')
		ZZ4->ZZ4_CODCLI 	:= mv_par01 //Cliente?
		ZZ4->ZZ4_LOJA   	:= mv_par02 //Loja?
		ZZ4->ZZ4_IMEI 		:= cCodBar
		ZZ4->ZZ4_CARCAC		:= cCodBar //SIM/Caraça
		ZZ4->ZZ4_CODPRO 	:= _cCodPro //Produto? (mv_par03)
		ZZ4->ZZ4_GRPPRO		:= Posicione("SB1",1,xFilial("SB1") + _cCodPro, "B1_GRUPO")
		ZZ4->ZZ4_VLRUNI	    := _nVlrUnit //Valor do Produto (mv_par06)
		ZZ4->ZZ4_OPER   	:= mv_par07 //Operacao
		ZZ4->ZZ4_KIT    	:= IIF(mv_par08==1,"S","N")  // Nicoletti
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
		ZZ4->ZZ4_GARANT     := mv_par16 //IIF(EMPTY(mv_par16),U_Vergaran(cVarSim,mv_par09),mv_par16)
		ZZ4->ZZ4_OSAUTO     := mv_par10
		ZZ4->ZZ4_ITEMD1     := _cITEMD1
		ZZ4->ZZ4_GARMCL     := CalcGarMCL(CCODBAR) // M.Munhoz - Ticket 3211 - alterado em 05/03/2012
		ZZ4->ZZ4_FORMUL		:= IIF(cForm==aForm[2],"S","N")
		
		MsUnLock('ZZ4')
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui parametro no SX6.                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//PutMv ("MV_XIMEFLI",SUBSTR(cCodBar,3,12))
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(DBSeek(xFilial('SB1')+_cCodPro))
		if !_lAuto
			tMemo += 'Item: '+STRZERO(I,5)+LFRC
			tMemo += 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
			tMemo += 'Produto: '+_cCodPro+' Descricao: '+SB1->B1_DESC+LFRC
			tMemo += 'SN: '+cCodBar+'   SIM/Carcaça: '+cVarSIM+LFRC
			tMemo += 'NF: '+mv_par04+' Série: '+mv_par05+' Valor: '+Transform(_nVlrUnit,'@E 999,999.99999')+LFRC
			if _nVez > 0
				tMemo += 'Este aparelho já sofreu '+alltrim(str(_nVez))+' entrada(s) anterior(es) a esta.'+LFRC
			endif
			_nVez := 0
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se eh SWAP ANTECIPADO                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if !_lAuto
			_aAreaSC6 := SC6->(GetArea())
			SC6->(DBOrderNickName('SC6XIMEOLD'))//SC6->(dbSetOrder(10))// C6_FILIAL + C6_XIMEOLD + C6_NUM + C6_ITEM
			if SC6->(dbSeek(xFilial("SC6") + cCodBar))
				ApMsgInfo("Este IMEI refere-se a aparelho em SWAP ANTECIPADO. ","SWAP ANTECIPADO!")
				tMemo += "SWAP ANTECIPADO: PV/ITEM -> "+SC6->C6_NUM+"/"+SC6->C6_ITEM+" == NF/SERIE -> "+SC6->C6_NOTA+"/"+SC6->C6_SERIE+LFRC
				reclock("ZZ4",.f.)
				ZZ4->ZZ4_SWANT := SC6->C6_NUM+SC6->C6_ITEM
				msunlock()
			endif
			RestArea(_aAreaSC6)
		endif
		
		if !_lAuto
			tMemo += LFRC
			Memo:=tMemo+Memo
			Close(oDlg)
		endif
		
		
	Next
	
	cCodBar:=Replicate(' ',20)
	cVarSIM:=Replicate(' ',25)
	mv_par18 := Space(nTamNfe) // NF de Compra
	mv_par19 := ctod("  /  / ")  // Data da NF de Compra
	MV_PAR21 := SPACE(3)
	MV_PAR22 := SPACE(18)
	MV_PAR23 := SPACE(14)
	mv_par12 := "C0022 "  // RECL. CLIENTE
	mv_par13 := Space(06) //OPERADORA
	mv_par14 := Space(06) //TRANSPORT
	mv_par15 := "N" //ACESSORIO
	mv_par16 := ""  // GARANTIA SIM OU NAO
	mv_par17 := Space(20) // CONHECIMENTO/LACRE
	UltReg:=.T.
ENDIF


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
local arg1 :=  strzero(val(arg1),12)
Local y1   :=  val(subs(arg1,2,1)) +val(subs(arg1,4,1)) +val(subs(arg1,6,1)) +;
val(subs(arg1,8,1)) +val(subs(arg1,10,1)) +val(subs(arg1,12,1))
Local y2   :=  val(subs(arg1,1,1)) +val(subs(arg1,3,1)) +val(subs(arg1,5,1)) +;
val(subs(arg1,7,1)) +val(subs(arg1,9,1)) +val(subs(arg1,11,1))
Local y0   := 3 * y1 + y2

y0   := 10 * (int(y0 / 10.0) + 1) - y0
y0   := if(y0 = 10, 0, y0)

return(str(y0,1))


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

if !cQryFLI->(EOF())
	CNEWIMEFL:=cQryFLI->IMEIFLP
endif

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

LOCAL cKit    := "N"
Local _lOk    := .f.
LOCAL cvaldsza :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_DADSZA")
Local ltravc  :=IIF(cvaldsza='N',.t.,.f.)


IF MV_PAR08==1
	cKit   := "S"
ENDIF

IF !ltravc
	cDescr:=SPACE(40)
ENDIF

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

@ 011,036 Get mv_par03 	Size 050,010 Picture "@!" 	When ltravc Valid(u_tecx011b(mv_par03,"2") .and. ExistCpo("SB1",mv_par03))  F3 'SB1'	Object oCodProd  //Colocado F3 Produto --> Edson Rodrigues - 23/06/10
@ 011,122 Get cDescr   	Size 124,010 When .f.
@ 024,050 Get mv_par04  Size 024,010 Picture "999999999"   When ltravc 	Valid(u_tecx011b(mv_par04,"5"))     							Object oNota
@ 024,122 Get mv_par05  Size 010,010 Picture "!!!" When ltravc
@ 037,050 Get mv_par06 	Size 042,010 Picture "@E 999,999.99999"  When ltravc Valid(u_tecx011b(mv_par06,"3"))  								Object oValUnit
@ 050,055 Get mv_par07 	Size 023,010 Picture "@!" When ltravc Valid ExistCpo("SX5","Z1"+mv_par07).AND.u_tecx011b(mv_par07,"4") F3 'Z1' 	Object oTpEntr
@ 050,122 Get cEntr    	Size 125,010 When .f.
@ 063,036 Get cKit      Size 005,010 Picture "!"  When ltravc Valid(u_tecx011b(@cKit,"6")) 												Object oKIT

@ 083,120 BMPBUTTON TYPE 1 ACTION (_lOk := .T., Close(F9ENTR))
@ 083,160 BMPBUTTON TYPE 2 ACTION (_lOk := .f., Close(F9ENTR))

Activate Dialog F9ENTR
If alltrim(cKit) == "S"
	mv_par08 := 1
elseIf alltrim(cKit) == "N"
	mv_par08 := 2
endIf

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx011o  ºAutor  ³ Edson Rodrigues   º Data ³  09/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exluí apontamentos conforme confirmacao do usuario e       º±±
±±º            Fecha a janela de Entrada Massiva                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx011o()
Local _cUpdZZ4 :=""
Local _cUpdSZC :=""
Local _infaces := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_INFACE")
Local _cvlope  := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_TROPEN")  // variavel que indica se deve fazer validação de troca de operação

_cUpdZZ4 := " UPDATE "+RETSQLNAME("ZZ4")+" SET D_E_L_E_T_ = '*' "
_cUpdZZ4 += " WHERE ZZ4_FILIAL = "+xFilial("ZZ4")+" AND "
_cUpdZZ4 += "       ZZ4_STATUS = '1' AND "
_cUpdZZ4 += "       D_E_L_E_T_ = ''  AND "
_cUpdZZ4 += "       SUBSTRING(ZZ4_EMUSER,1,13) = '"+Substr(cUserName,1,13)+"' "
IF _cvlope <> "S"  .and. !lselqrytst
	_cUpdZZ4 += "       AND ZZ4_OPEBGH = '"+ALLTRIM(MV_PAR09)+"'"
ENDIF

tcSqlExec( _cUpdZZ4)
TCREFRESH(RETSQLNAME("ZZ4"))

IF _infaces="S"
	_cUpdSZC := " UPDATE "+RETSQLNAME("SZC")+" SET D_E_L_E_T_ = '*' "
	_cUpdSZC += " WHERE ZC_FILIAL  = "+xFilial("SZC")+" AND "
	_cUpdSZC += "       ZC_DOC     = '"+ALLTRIM(MV_PAR04)+"' AND "
	_cUpdSZC += "       ZC_SERIE   = '"+ALLTRIM(MV_PAR05)+"' AND "
	_cUpdSZC += "       ZC_FORNECE = '"+ALLTRIM(MV_PAR01)+"' AND "
	_cUpdSZC += "       ZC_LOJA    = '"+ALLTRIM(MV_PAR02)+"' AND "
	//      _cUpdSZC += "       ZC_CODPRO  = '"+ALLTRIM(MV_PAR03)+"' AND " desabilitado - Edson Rodrigues - 01/10/10
	_cUpdSZC += "       ZC_STATUS = '0' AND "
	_cUpdSZC += "       D_E_L_E_T_ = '' "
	
	tcSqlExec( _cUpdSZC)
	TCREFRESH(RETSQLNAME("SZC"))
ENDIF

IF Len(_aetqentm) > 0
	For x:=1 to Len(_aetqentm)
		_cUpdZZO := " UPDATE "+RETSQLNAME("ZZO")+" SET ZZO_STATUS = '1' "
		_cUpdZZO += " WHERE ZZO_FILIAL = '"+xFilial("ZZO")+"'    AND "
		_cUpdZZO += "       ZZO_NUMCX  = '"+_aetqentm[x,1]+"'  AND "
		_cUpdZZO += "       ZZO_STATUS = '2' AND ZZO_SEGREG<>'S' AND "
		_cUpdZZO += "       D_E_L_E_T_ = ''"
	
		tcSqlExec( _cUpdZZO)
		TCREFRESH(RETSQLNAME("ZZO"))
	Next
ENDIF

_lFechEM := .T.
Close(oDlg)

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
Local _lvalid   := .f.
Local _lqrytri  := .f.
local cstattri  := ""
Local oDlgstriag

If Select("XZZO") > 0
	XZZO->(dbCloseArea())
endif

If empty(cVarmst)
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
while XZZO->(!eof())
	_lqrytri:=.t.
	IF XZZO->ZZO_STATUS ='1'
		If UPPER(left(_cOrigem,8)) $ "BGHTRIAG"
			mv_par01 := XZZO->ZZO_CLIENT
			mv_par02 := XZZO->ZZO_LOJA
			mv_par03 := XZZO->ZZO_MODELO
			mv_par04 := XZZO->ZZO_NF
			mv_par05 := XZZO->ZZO_SERIE
			mv_par06 := XZZO->ZZO_PRECO
			mv_par07 := "05"
			mv_par08 := 2
			MV_PAR09 := right(_cOrigem,3)
			mv_par10 := Space(12) //OS SAM
			mv_par11 := Space(11) // COD. AUTORIZ.
			mv_par12 := "C0022 "  // RECL. CLIENTE
			mv_par13 := Space(06) //OPERADORA
			mv_par14 := Space(06) //TRANSPORT
			mv_par15 := "N" //ACESSORIO
			mv_par16 := XZZO->ZZO_GARANT  // GARANTIA SIM OU NAO
			mv_par17 := Space(20) // CONHECIMENTO/LACRE
			mv_par18 := Space(nTamNfe) // NF de Compra
			mv_par19 := ctod("  /  / ")  // Data da NF de Compra
			mv_par20 := Space(30)
			MV_PAR21 := SPACE(3)
			MV_PAR22 := SPACE(18)
			MV_PAR23 := SPACE(14)
		Endif
		IF MV_PAR03==XZZO->ZZO_MODELO
			cVarBar  :=XZZO->ZZO_IMEI
			cVarSim  :=XZZO->ZZO_CARCAC
			MV_PAR16 :=XZZO->ZZO_GARANT
			MV_PAR03 :=XZZO->ZZO_MODELO
			nvez     :=XZZO->ZZO_NVEZ
			nbounce  :=IIF(XZZO->ZZO_DBOUNC='',0,XZZO->ZZO_DBOUNC)
			_lvalid   :=u_tecx011grv(@cVarBar,@cTexto,@cVarSim,.T.,nvez,cVarmst,nbounce)
		ELSE
			IF MSGYESNO("O MODELO : +"+ALLTRIM(XZZO->ZZO_MODELO)+ " DIFERENTE DO MODELO ANTERIOR : "+alltrim(MV_PAR03)+ ". QUER ALTERAR O VALOR ATUAL :" +Transform(MV_PAR06,'@E 999,999.99999')+" ? ")
				nprealte:=u_tropreco(MV_PAR06)
				_ltroprec:=.t.
				If nprealte==MV_PAR06
					_ltroprec:=.f.
					IF !MSGYESNO("VOCE NAO ALTEROU O PREÇO ATUAL : " +Transform(MV_PAR06,'@E 999,999.99999')+" para o novo modelo : "+ALLTRIM(XZZO->ZZO_MODELO)," CONFIRMA ? ")
						nprealte:=u_tropreco(MV_PAR06)
						_ltroprec:=.t.
						MV_PAR06:= nprealte
					ENDIF
				ELSE
					MV_PAR06:= nprealte
				ENDIF
			Endif
			
			cVarBar  :=XZZO->ZZO_IMEI
			cVarSim  :=XZZO->ZZO_CARCAC
			MV_PAR16 :=XZZO->ZZO_GARANT
			MV_PAR03 :=XZZO->ZZO_MODELO
			nvez     :=XZZO->ZZO_NVEZ
			nbounce  :=IIF(XZZO->ZZO_DBOUNC='',0,XZZO->ZZO_DBOUNC)
			_lvalid   :=u_tecx011grv(@cVarBar,@cTexto,@cVarSim,.T.,nvez,cVarmst,nbounce)
		ENDIF

		If _lvalid
			ZZO->(dbgoto(XZZO->RECNOZZO))
			Reclock("ZZO",.F.)
			ZZO->ZZO_STATUS :='2'
			MsUnLock('ZZO')
		Endif
		
	ELSE
		AADD(_imeistat,{XZZO->ZZO_IMEI,XZZO->ZZO_STATUS})
	ENDIF
	XZZO->(dbSkip())
enddo

If !_lqrytri
	MsgBox("Codigo master de triagem CLA invalido ou já foi processado esse código !","Cod triagem CLA invalido","ALERT")
	_lqrytri:=.T.
	//cVarmst:=Replicate(' ',20)
	//oEdmst:SetFocus()
	return
Endif

if LEN(_imeistat) > 0
	For x:=1 to len(_imeistat)
		IF x=1
			cstattri:="IMEI :"+_imeistat[x,1]+" Status :"+_imeistat[x,2]+LFRC
		ELSE
			cstattri+="IMEI :"+_imeistat[x,1]+" Status :"+_imeistat[x,2]+LFRC
		ENDIF
	Next
	
	MsgBox("Houveram IMEIS que nao passaram por todas as estapas da triagem no CLA. Por favor verifique !","Status Triagem invalido","ALERT")
	
	@ 0,0 TO 400,420 DIALOG ODlgstriag TITLE "Imeis Status Invalido na Triagem CLA"
	@ 05,005 SAY oV1 var Alltrim(cUserName)+',' of oDlgstriag FONT oFnt2 PIXEL SIZE 150,010
	@ 15,005 SAY oV2 var "confirme os IMEIs  abaixo listados." of oDlgstriag FONT oFnt2 PIXEL SIZE 150,012
	@ 25,005 Get cstattri Size 195,115 MEMO Object oMemostatr
	@ 140,130 BMPBUTTON TYPE 1 ACTION (oDlgstriag:End())

	oMemostatr:oFont:=oFnt3
	Activate MSDialog oDlgstriag Centered
	
Endif

IF _lqrytri
	aadd(_aetqentm,{cVarmst})
ENDIF

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

DEFINE MSDIALOG oDlgtop TITLE "Operacoes" FROM C(306),C(324) TO C(465),C(534) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(080),C(103) LABEL "Operação" PIXEL OF oDlgtop
	// Cria Componentes Padroes do Sistema
	@ C(015),C(004) Say "Operacao" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlgtop
	@ C(014),C(025) MsGet otrcper Var _copatu F3 "ZZJ"  Valid ExistCpo("ZZJ",_copatu).AND.u_tecx011b(_copatu,"10")  Size C(052),C(009) COLOR CLR_BLACK PIXEL OF oDlgtop
DEFINE SBUTTON FROM C(058),C(043) TYPE 1 ENABLE OF oDlgtop ACTION (oDlgtop:end())

ACTIVATE MSDIALOG oDlgtop CENTERED

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

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER " ", "IMEI Bounce", "Qtde Dias","Qde Aparelho" SIZE 230,095 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] :=desmarc(oLbx:nAt,aVetor),oLbx:Refresh())
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4]}}
	//	@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ON CLICK(Iif(lChk,Marca(lChk),Marca(lChk)))
	DEFINE SBUTTON FROM 107,173 TYPE 2 ACTION (_nOpcx:=0,oDlg:End()) ENABLE OF oDlg  // Cancelar
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (_nOpcx:=1,iif(marcou(),oDlg:End(),ODlg)) ENABLE OF oDlg  // OK
ACTIVATE MSDIALOG oDlg CENTER

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
local lret:=!aArray[n,1]

For i := 1 To Len(aVetor)
	If aVetor[i]==aVetor[n]
		aVetor[i][1] := .f.
		aVetor[i][4] := 1
	Else
		aVetor[i][1] := .f.
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
Local lret:=.f.

If len(aVetor) > 0
	For i:=1 to len( aVetor)
		IF aVetor[i,1]
			lret:=.t.
		ENDIF
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
_cQrytest += "   (SELECT * FROM [PROTHEUS].dbo."+RetSqlName("SZA")+" (NOLOCK) WHERE  ZA_FILIAL= '"+XFILIAL("SZA")+"' AND ZA_DATA='" + DtoS(dDataBase) + "' AND  D_E_L_E_T_='' ) AS ZZA
_cQrytest += "   ON ZA_NFISCAL=ZZ4_NFENR AND ZA_SERIE=ZZ4_NFESER AND ZA_IMEI=ZZ4_IMEI AND ZA_CLIENTE=ZZ4_CODCLI AND ZA_LOJA=ZZ4_LOJA
_cQrytest += " WHERE ZZ4.ZZ4_FILIAL= '"+XFILIAL("ZZ4")+"' AND ZZ4_EMDT='" + DtoS(dDataBase) + "' AND ZZ4.D_E_L_E_T_=''  AND
_cQrytest += " ZZ4.ZZ4_CODPRO+ZZ4.ZZ4_NFENR+ZZ4.ZZ4_NFESER+ZZ4.ZZ4_IMEI+ZZ4.ZZ4_OPEBGH NOT IN
_cQrytest += " (SELECT ZZ4_CODPRO+ZZ4_NFENR+ZZ4_NFESER+ZZ4_IMEI+ZZ4_OPEBGH FROM [PROTHEUS_DVL].dbo."+RetSqlName("ZZ4")+" ZZ41 (NOLOCK)
_cQrytest += "  WHERE ZZ41.ZZ4_FILIAL= '"+XFILIAL("ZZ4")+"' AND ZZ4_EMDT='" + DtoS(dDataBase) + "' AND ZZ41.D_E_L_E_T_='' ) AND ZZ4.ZZ4_NFESER<>'003'
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
#ENDIF


#IFDEF TOP
	_lQuery   := .T.
	BeginSql alias cZMTemp
		SELECT ZZM_DEFINF AS DEFEITO
		FROM %table:ZZM% ZZM
		WHERE   ZZM.ZZM_FILIAL = %exp: '02'% 		AND
		ZZM.ZZM_IMEI 	= 	%exp: cimei%        	AND
		ZZM.ZZM_LAB  	= 	%exp: clab %  			AND
		ZZM.ZZM_MSBLQL 	= 	%exp: '2' %  			AND
		ZZM.%notDel%
	EndSql
	
#ENDIF



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

DEFINE MSDIALOG oDlgtprc TITLE "Altera Preço" FROM C(306),C(324) TO C(465),C(534) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(080),C(103) LABEL "PREÇO" PIXEL OF oDlgtprc
	// Cria Componentes Padroes do Sistema
	@ C(015),C(004) Say "Preço" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlgtprc
	@ C(014),C(025) MsGet otrcprc Var _nprcatu  Size 052,009 Picture "@E 999,999.99999"  COLOR CLR_BLACK PIXEL OF oDlgtprc
	//@ 063,050 Get mv_par06 	Size 042,010 Picture "@E 999,999.99999" 													Valid(u_tecx011b(mv_par06,"3"))  											Object oValUnit
DEFINE SBUTTON FROM C(058),C(043) TYPE 1 ENABLE OF oDlgtprc ACTION (oDlgtprc:end())

ACTIVATE MSDIALOG oDlgtprc CENTERED

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
static function CalcGarMCL(_cCodBar)

local _cGarMCL  := "N"
local _aAreaSZA := SZA->(getarea())
local _aAreaZZG := ZZG->(getarea())
local _aAreaZZM := ZZM->(getarea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par04 -  Numero da Nota Fiscal de Entrada         ³
//³ mv_par05 -  Serie da  Nota Fiscal de Entrada         ³
//³ mv_par01 -  Cliente                                  ³
//³ mv_par02 -  Loja                                     ³
//³ cCodBar  -  IMEI                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if mv_par16 == "S" // Com Garantia
	
	SZA->(dbSetOrder(1))  // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
	ZZG->(dbSetOrder(1))  // ZZG_FILIAL + ZZG_LAB + ZZG_CODIGO
	ZZM->(dbSetOrder(1))  // ZZM_FILIAL + ZZM_LAB + ZZM_IMEI + ZZM_DEFINF + ZZM_DATAOS
	
	// Verifica se existe defeito no SZA
	if SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05 + _cCodBar)) .and. ;
		alltrim(SZA->ZA_CODRECL) <> "C0022"

		_cGarMCL := "S"

		// Verifica se existe defeito no ZZM
	elseif ZZM->(dbSeek(xFilial("ZZM") + "2" + alltrim(_cCodBar)) )
		
		// Faz um WHILE no ZZM porque este nao possui chave unica compativel com o ZZ4
		while ZZM->(!eof()) .and. ZZM->ZZM_FILIAL == xFilial("ZZM") .and. alltrim(ZZM->ZZM_IMEI) == alltrim(_cCodBar) .and. _cGarMCL == "N"
			
			if ZZM->ZZM_MSBLQL <> '1'
				// Procura o defeito informado no ZZG para verificar se eh C0022
				_cDefInf := left(ZZM->ZZM_DEFINF,5)
				if ZZG->(dbSeek(xFilial("ZZG") + "2" + _cDefInf)) .and. ZZG->ZZG_RECCLI <> "C0022"
					_cGarMCL := "S"
				endif
				
			endif
			ZZM->(dbSkip())
		enddo
		
	endif
	
	restarea(_aAreaSZA)
	restarea(_aAreaZZG)
	restarea(_aAreaZZM)

endif

If mv_par16 == "N" .OR. _cGarMCL == "N"
	/*
	Se existir NFC e não existir NFT calcular data (Regra: Data de compra digitada somada ao ZZJ_GARNFC deve ser
	menor ou igual que a DATABASE) - Garantia _cGarMCL := "S"
	*/

	/*
	Se existir NFT obrigatoriamente deve existir NFC. Dt da NFT nunca menor que Dt NFC e menor que Dt fabricação
	também nunca maior que DATABASE. Calcular período ou pela NFT ou pela NFC.
	*/

EndIf

return(_cGarMCL)


User Function TECAXSG1(cCodaces,Memoaces,_lAuto,ccodbar,_cCodPro)

Local oDlgSG1
Local oDlgKIT
Local cTitulo	:= "Cadastro Acessorios"
Local oOk      	:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      	:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local nOpcA		:= 0
Local _cKit 	:= space(15)

Private oLbxSG1
Private aEstru	:= {}
Private nEstru	:= 0
Private nX		:= 1
Private aItens	:= {}

oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
@ 0,0 TO 200,300 DIALOG oDlgKIT TITLE "Kit"
oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlgKIT)
@ 05,050 SAY oV1 var "Selecione um kit:" of oDlgKIT FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
@ 40,010 GET _cKit Size 100,080 PICTURE "@!" valid ExistCPO('SB1',_cKit)  F3 'SB1'
@ 80,085 BMPBUTTON TYPE 1 ACTION oDlgKIT:End()
@ 80,120 BMPBUTTON TYPE 2 ACTION oDlgKIT:End()
Activate MSDialog oDlgKIT Centered

aEstru  := Estrut(_cKit)

If Len(aEstru) == 0
	MsgInfo("O Modelo informado não possui B.O.M!","Cadastro Estrutura")
	Return
Endif

Do While nX <= Len(aEstru)
	SG1->(dbSetorder(1))
	SG1->(dbSeek(xFilial()+aEstru[nX,2]+aEstru[nX,3]+aEstru[nX,5]))
	If SG1->(Found()) .and. (SG1->G1_INI <= dDatabase .and. SG1->G1_FIM >= dDatabase) .and. aEstru[nX,4]>0
		nPos := ascan(aItens, {|x| x[2] == aEstru[nX,3]})
		If nPos == 0
			_cDescPro := Posicione("SB1",1,xFilial("SB1") + aEstru[nX,3], "B1_DESC")
			aadd( aItens, {.T.,aEstru[nX,3], _cDescPro} )
		Endif
	Endif
	nX++
Enddo

DEFINE MSDIALOG oDlgSG1 TITLE cTitulo FROM 0,0 TO 680,1250 PIXEL
	@ 15,10 LISTBOX oLbxSG1 FIELDS HEADER ;
	" ", "Peça", "Descrição";
	SIZE 610,330 OF oDlgSG1 PIXEL ON dblClick(aItens[oLbxSG1:nAt,1] := !aItens[oLbxSG1:nAt,1])	
	oLbxSG1:SetArray( aItens )
	oLbxSG1:bLine := {|| {Iif(aItens[oLbxSG1:nAt,1],oOk,oNo),;
	aItens[oLbxSG1:nAt,2],;
	aItens[oLbxSG1:nAt,3]}}
ACTIVATE MSDIALOG oDlgSG1 ON INIT EnchoiceBar(oDlgSG1,{||nOpcA:=1,oDlgSG1:End()},{||oDlgSG1:End()})

If nOpcA == 1
	For i:=1 To Len(aItens)
		aadd(_acess,{mv_par04,mv_par05, mv_par01,mv_par02,cCodBar,Posicione("SA1",1,xFilial("SA1") + mv_par01+mv_par02, "A1_NOME"),;
		_cCodPro,Posicione("SB1",1,xFilial("SB1") + _cCodPro, "B1_DESC"),aItens[i,2],aItens[i,3],aItens[i,2],IIF(aItens[i,1],"S","N")})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if !_lAuto
			tMemo := 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
			tMemo += 'Part. Acess: '+aItens[i,2]+' Descricao: '+aItens[i,3]+LFRC
			tMemo += 'Tipo Acess : '+aItens[i,2]+'-'+aItens[i,3]+LFRC
			tMemo += 'IMEI: '+cCodBar+' NF: '+mv_par04+' Série: '+mv_par05+LFRC
			tMemo += '---------------------------------------------------------------'+LFRC
			Memoaces := tMemo+LFRC+Memoaces+LFRC
		endif
	Next i
Endif

Return
Static Function AtuNF()

If cForm == aForm[2]
	MV_PAR04:= "999999999"
	MV_PAR05:= "999"
Endif

Return
