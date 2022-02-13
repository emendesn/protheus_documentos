#Include "Rwmake.ch"
#include "VKey.ch"
#Include "Colors.ch"
#include "cheque.ch"
#include "topconn.ch"
#define LFRC CHR(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TecaxOsasบAutor  ณ Microsiga          บ Data ณ 29/04/08    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que executa a entrada Massiva de Celulares na       บฑฑ
ฑฑบ          ณ filial Osasco com aparelhos da BGH Alphaville              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGATEC/SIGAEST - BGH do Brasil                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TecaxOsas(cOrigem)
//Local cPergMud		 := "OPEMUD" //Pergunta Oper็ใo
Local cFilialDestino := Alltrim(GetMv("MV_MUDFDES")) // Filial Destino e/ou xFilial
Local cVarBar      := space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
Local cVarBar      := AvKey(cVarBar,"ZZ4_IMEI")
Local cVarSIM      := Replicate(' ',25)
Local cVarmst      := Replicate(' ',20)
Local _cvlope      := ''

local _cCodCli     := "" 
local _cLoja       := ""
local _cNfeNr      := ""
local _cNfeSer     := ""
 
Public cTexto      := ''
Public cTextac     := ''
Public cBkpTexTac  := ''
Public UltReg      := .F.
Public _lFechEM    := .F.

Private oV1,oV2
Private cPerg       := 'BARZZ4'
Private _nqtde      := 0.00
Private cgeraimei   :=''
Private centriage   :='S'
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
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut     := .F.                             	 //Usuarios de Autorizado a excluir IMEI
Private _aetqentm   := {}   //  array com os codigos master escaneados.
Private lselqrytst  :=.f.
Private _lyesema    :=.f.
Private _lspc433    := .F.
Private _cPsq	    := GetMv("MV_PERSPC3") 				 // Periodo Parametrizados para Especifico SPC0000433 - Motorola
Private _cSpr	    := GetMv("MV_SPC0433") 				 // Aparelhos Parametrizados para Especifico SPC0000433 - Motorola
Private _cOrigem    := IIF(cOrigem <> NIL,cOrigem,"")
Private _actacess   := {}
Private cNexSpRj    := GetMv("MV_NEXTSP") +"/"+GetMv("MV_NEXTRJ") //Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015 
Private aPallet     := {"P1","P2","P3","P4","P5","P6","P7","P8","P9"}
Private cPallet     := aPallet[1]

private _aItMast   := {}

DBSelectArea('ZZ1')  //Cadastro de Fases
Dbselectarea("ZZ3")  //Apontamento de fases
DBSelectArea('SA1')  //Cadastro de Clientes
DBSelectArea('SB1')  //Cadastro de Produtos
DBSelectArea('ZZ4')  //Entrada Massiva
DBSelectArea('AB7')  //Itens da OS

ZZ1->(DbSetOrder(1)) 	// ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET
ZZ3->(dbSetOrder(1))  	// ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
SA1->(DBSetOrder(1)) 	// A1_FILIAL+A1_COD+A1_LOJA
SB1->(DBSetOrder(1)) 	// B1_FILIAL+B1_COD
ZZ4->(DBSetOrder(2)) 	// ZZ4_FILIAL+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI
AB7->(DBOrderNickName('AB7NUMSER')) //AB7_FILIAL+AB7_NUMOS+AB7_NUMSER

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado a entrar com NF-Compras
	If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores#Explider#MUDANCA"
		lUsrAut  := .T.
	EndIf
	
Next i

If cFilial <> Alltrim(cFilialDestino)
	apMsgStop('Esta rotina ้ exclusiva para processamento na Matriz. Rotina interrompida!','Rotina interrompida')
	return()
elseif !apMsgYesNo('Esta rotina executa a Entrada Massiva apenas atrav้s de etiqueta master exclusiva para os aparelhos de Osasco que estใo entrando na Matriz Alphaville. Deseja continuar?','Entrada Massiva na filial Osasco')
	return()
endif
/*
If( _cOrigem == Nil .Or. _cOrigem == "" .Or. Empty(_cOrigem))
	Pergunte(cPergMud, .T.)
	_cOrigem := mv_par01
EndIf
*/
IF SELECT("QRYTST") > 0  .and. !empty(QRYTST->ZZ4_IMEI)
	_lRetTela  :=.T.
	lselqrytst :=.t.
ELSE
	IF _lyesema
		MsgBox("Nใo foi encontrado dados para o processamento da entrada massiva automแtica !","Sem dados para processamento automแtico","ALERT")
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
_cvlope   := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_TROPEN")  // variavel que indica se deve fazer valida็ใo de troca de opera็ใo

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
	tMemo += 'NF: '+ALLTRIM(X02->ZZ4_NFENR)+' S้rie: '+ALLTRIM(X02->ZZ4_NFESER)+' Valor: '+Transform(X02->ZZ4_VLRUNI,'@E 999,999.99999')+LFRC
	tMemo += 'SN: '+ALLTRIM(ZZ4_IMEI)+'   SIM/Carca็a: '+ALLTRIM(ZZ4_CARCAC)+LFRC
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao dos fontes                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oFnt1  := TFont():New("Arial",18,22,,.T.,,,,.T.,.F.)
oFnt2  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
oFnt3  := TFont():New("Courier New",08,12,,.F.,,,,.F.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao das Teclas de Funcao                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SetKey(VK_F9 ,{|| U_F9ENTR()}) //Tela com todos os parametros

While !_lFechEM
	
	@ 0,0 TO 460,520 DIALOG oDlg TITLE "Entrada Massiva"
	oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"CodBar.bmp",.T.,oDlg)
	
	@ 005,077 SAY oV1 var "Passe a leitora de" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
	@ 020,075 SAY oV2 var "c๓digo de barras"   of oDlg FONT oFnt1 PIXEL SIZE 150,012 COLOR CLR_BLUE
	
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
						@ 035,010 GET cVarmst Size 100,080 PICTURE "@!" valid u_triagosas(@cVarBar,@cTexto,@cVarSim,@cVarmst,.F.) Object oEdmst
					ELSE
//						@ 035,010 GET cVarSIM Size 100,080 PICTURE "@!" valid .T. Object oEdSIM
//						@ 050,010 GET cVarBar Size 100,080 PICTURE "@!" valid u_tecx011grv(@cVarBar,@cTexto,@cVarSim,.F.) Object oEdBar
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
				@ 035,010 GET cVarmst Size 100,080 PICTURE "@!" valid u_triagosas(@cVarBar,@cTexto,@cVarSim,@cVarmst,.f.,@_aItMast, @_cCodCli, @_cLoja, @_cNfeNr, @_cNfeSer,.F.) Object oEdmst
			ELSE
//				@ 035,010 GET cVarSIM Size 100,080 PICTURE "@!" valid .T. Object oEdSIM
//				@ 050,010 GET cVarBar Size 100,080 PICTURE "@!" valid u_tecx011grv(@cVarBar,@cTexto,@cVarSim,.F.) Object oEdBar
			ENDIF
		ENDIF
		
	Endif
	@ 065,010 GET cTexto  Size 250,115 MEMO Object oMemo when .F.
	@ 202,180 BUTTON "CONFIRMA     " 	SIZE 60,13 ACTION Processa({|| u_GravTab(cVarmst, _aItMast, _cCodCli, _cLoja, _cNfeNr, _cNfeSer) }) // Executa funcao que copia os registros das tabelas de entrada massiva da filial Alphaville pra filial Osasco
	@ 217,180 BUTTON "CANCELA" 			SIZE 60,13 ACTION IIF(MSGYESNO("DESEJA REALMENTE CANCELAR? TODOS APARELHOS DEVERรO SER APONTADOS NOVAMENTE."),tecx011o(),tecx011e(.F.))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria legenda de funcoes na tela                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	tecx011leg()
	
	If centriage <> "S"
		Activate MSDialog oDlg Centered On Init oEdSIM:SetFocus()
	Else
		Activate MSDialog oDlg Centered On Init oEdmst:SetFocus()
	Endif
	
Enddo

//fechentmas(.f.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Limpa Filtro                                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ZZ4->(DBCloseArea())
DBSelectArea('ZZ4')

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECX011LEGบAutor  ณAntonio L.F. Favero บ Data ณ  27/03/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Legenda de teclas de funcoes na Janela                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function tecx011leg()

nTop:=360
nLeft:=16

oGrp1 				:= TGROUP():Create(oDlg)
oGrp1:cName 		:= "oGrp1"
oGrp1:cCaption 		:= "Teclas de Fun็ใo"
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
oSay4:cCaption 		:= "Parโmetros"
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

IF centriage<>"S"
	oEdSIM:SetFocus()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtecx011o  บAutor  ณ Edson Rodrigues    บ Data ณ  09/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exluํ apontamentos conforme confirmacao do usuario e       บฑฑ
ฑฑบ            Fecha a janela de Entrada Massiva                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function tecx011o()
Local _cUpdZZ4 :=""
Local _cUpdSZC :=""
Local _infaces := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_INFACE")
Local _cvlope  := Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(MV_PAR09), "ZZJ_TROPEN")  // variavel que indica se deve fazer valida็ใo de troca de opera็ใo
/*
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
*/
/*
IF _infaces="S"
	_cUpdSZC := " UPDATE "+RETSQLNAME("SZC")+" SET D_E_L_E_T_ = '*' "
	_cUpdSZC += " WHERE ZC_FILIAL  = "+xFilial("SZC")+" AND "
	_cUpdSZC += "       ZC_DOC     = '"+ALLTRIM(MV_PAR04)+"' AND "
	_cUpdSZC += "       ZC_SERIE   = '"+ALLTRIM(MV_PAR05)+"' AND "
	_cUpdSZC += "       ZC_FORNECE = '"+ALLTRIM(MV_PAR01)+"' AND "
	_cUpdSZC += "       ZC_LOJA    = '"+ALLTRIM(MV_PAR02)+"' AND "
	_cUpdSZC += "       ZC_STATUS = '0' AND "
	_cUpdSZC += "       D_E_L_E_T_ = '' "
	
	tcSqlExec( _cUpdSZC)
	TCREFRESH(RETSQLNAME("SZC"))
ENDIF
*/
/*
IF Len(_aetqentm) > 0
	For x:=1 to Len(_aetqentm)
		_cUpdZZO := " UPDATE "+RETSQLNAME("ZZO")+" SET ZZO_STATUS = '1' "
		_cUpdZZO += " WHERE ZZO_FILIAL = '"+xFilial("ZZO")+"'    AND "
		_cUpdZZO += "       ZZO_NUMCX  = '"+_aetqentm[x,1]+"'  AND "
		_cUpdZZO += "       ZZO_STATUS IN ('E','P') AND ZZO_SEGREG <> 'S' AND "
		_cUpdZZO += "       D_E_L_E_T_ = ''"
	
		tcSqlExec( _cUpdZZO)
		TCREFRESH(RETSQLNAME("ZZO"))
	Next
ENDIF
*/
_lFechEM := .T.
Close(oDlg)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtriagosas บAutor  ณ Edson Rodrigues    บ Data ณ  08/08/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona e processa aparelhos do processo Triagem         บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function triagosas(cCodBar,Memo,cVARSIM,cVarmst,_lAuto,_aItMast, _cCodCli, _cLoja, _cNfeNr, _cNfeSer)

Local _imeistat := {}
Local _aAreaZZO := ZZO->(GetArea())
Local _lvalid   := .f.
Local _lqrytri  := .f.
local cstattri  := ""
Local oDlgstriag
Local cFilialOrigem := Alltrim(GetMv("MV_MUDFORI"))

If Select("XZZO") > 0
	XZZO->(dbCloseArea())
endif


If empty(cVarmst)
	_lqrytri:=.T.
	cVarmst:=Replicate(' ',20)
	return
Endif

/*
 First Init WorkAround :[Retornar Parametros para Query na ZZO]
*/
/*
If Select("WAZZ4") > 0
	WAZZ4->(dbCloseArea())
endif

cQryWa :="	SELECT TOP 1	"
cQryWa +="	 [CLIENTE] 	= [ZZ4].[ZZ4_NFSCLI] "
cQryWa +="	,[LOJA] 	= [ZZ4].[ZZ4_NFSLOJ] "
cQryWa +="	,[NOTA]		= [ZZ4].[ZZ4_NFSNR] "
cQryWa +="	,[SERIE]	= [ZZ4].[ZZ4_NFSSER] "
cQryWa +="	FROM [PROTHEUS].[dbo].[ZZ4020](NOLOCK) AS [ZZ4] "
cQryWa +="	WHERE	[ZZ4].[D_E_L_E_T_] = '' "
cQryWa +="	AND		[ZZ4].[ZZ4_FILIAL] = '"+cFilialOrigem+"' "
cQryWa +="	AND		[ZZ4].[ZZ4_ETQMAS] = '"+Alltrim(cVarmst)+"'	"

TCQUERY cQryWa NEW ALIAS "WAZZ4"


dbSelectArea("WAZZ4")
WAZZ4->(dbGoTop())
while WAZZ4->(!eof())
	mv_par01 := WAZZ4->CLIENTE
	mv_par02 := WAZZ4->LOJA  
	mv_par04 := WAZZ4->NOTA
	mv_par05 := WAZZ4->SERIE
		WAZZ4->(dbSkip())
EndDo      
*/
/*End WorkAround*/

_cCodCli := mv_par01
_cLoja   := mv_par02    
_cNfeNr  := mv_par04 //XZZO->ZZO_NF
_cNfeSer := mv_par05 //XZZO->ZZO_SERIE

cpallet  := ""

IF apMsgYesNo("Existe Pallet associado a essa Master : '"+cVarmst+"' ? . Informa Pallet associado " )
    cpallet:= u_spallet()
ENDIF

_cQrytri := " SELECT *, R_E_C_N_O_ AS RECNOZZO "
_cQrytri += " FROM   "+RetSqlName("ZZO")+" (nolock) "
_cQrytri += " WHERE  ZZO_FILIAL  = '"+xFilial("ZZO")+"' AND "
_cQrytri += "        ZZO_NUMCX  = '"+cVarmst+"'  AND "
_cQrytri += "        ZZO_STATUS  IN ('E','P') AND "
_cQrytri += "        ZZO_DESTIN  = 'B'  AND "
_cQrytri += "        ZZO_SEGREG  <> 'S'  AND "
//_cQrytri += "        ZZO_ENVARQ  = 'S'  AND "
//Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
//IF _cCodCli $ "000680/00016" 
IF Alltrim(_cCodCli) $ Alltrim(cNexSpRj) 
  _cQrytri += "        ZZO_CLIENT= '"+_cCodCli+"'  AND  ZZO_LOJA= '"+_cLoja+"' AND "
ELSE
  _cQrytri += "        ZZO_NF= '"+_cNfeNr+"'  AND  ZZO_SERIE= '"+_cNfeSer+"' AND "
ENDIF
IF !empty(cpallet)
   _cQrytri += "   ZZO_PALLET='"+cpallet+"'  AND "
ENDIF
_cQrytri += "        D_E_L_E_T_  = '' "
_cQrytri += " ORDER BY ZZO_NUMCX,ZZO_MODELO "

TCQUERY _cQrytri NEW ALIAS "XZZO"

dbSelectArea("XZZO")
XZZO->(dbGoTop())
while XZZO->(!eof())

	//_cCodCli  "Z00403"
	//_cLoja   := "01"    
	//_cNfeNr  := mv_par04 //XZZO->ZZO_NF
	//_cNfeSer := mv_par05 //XZZO->ZZO_SERIE

	aAdd(_aItMast, {XZZO->ZZO_OSFILI, XZZO->ZZO_IMEI, "", "", "",XZZO->ZZO_MODELO,XZZO->ZZO_CARCAC})

	_lqrytri:=.t.
	
	IF XZZO->ZZO_STATUS $ 'E/P'
		If UPPER(left(_cOrigem,8)) $ "BGHTRIAG"
			mv_par01 := _cCodCli
			mv_par02 := _cLoja
			mv_par03 := XZZO->ZZO_MODELO
			mv_par04 := _cNfeNr
			mv_par05 := _cNfeSer
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
			_lvalid   := tecx011grv(@cVarBar,@cTexto,@cVarSim,.T.,nvez,cVarmst,nbounce)
		ELSE
/*
			IF MSGYESNO("O MODELO : +"+ALLTRIM(XZZO->ZZO_MODELO)+ " DIFERENTE DO MODELO ANTERIOR : "+alltrim(MV_PAR03)+ ". QUER ALTERAR O VALOR ATUAL :" +Transform(MV_PAR06,'@E 999,999.99999')+" ? ")
				nprealte:=u_tropreco(MV_PAR06)
				_ltroprec:=.t.
				If nprealte==MV_PAR06
					_ltroprec:=.f.
					IF !MSGYESNO("VOCE NAO ALTEROU O PREวO ATUAL : " +Transform(MV_PAR06,'@E 999,999.99999')+" para o novo modelo : "+ALLTRIM(XZZO->ZZO_MODELO)," CONFIRMA ? ")
						nprealte:=u_tropreco(MV_PAR06)
						_ltroprec:=.t.
						MV_PAR06:= nprealte
					ENDIF
				ELSE
					MV_PAR06:= nprealte
				ENDIF
			Endif
*/			
			cVarBar  :=XZZO->ZZO_IMEI
			cVarSim  :=XZZO->ZZO_CARCAC
			MV_PAR16 :=XZZO->ZZO_GARANT
			MV_PAR03 :=XZZO->ZZO_MODELO
			nvez     :=XZZO->ZZO_NVEZ  
			mv_par06 := XZZO->ZZO_PRECO
			nbounce  :=IIF(XZZO->ZZO_DBOUNC='',0,XZZO->ZZO_DBOUNC)
			_lvalid   := tecx011grv(@cVarBar,@cTexto,@cVarSim,.T.,nvez,cVarmst,nbounce)
		ENDIF

		If _lvalid
			ZZO->(dbgoto(XZZO->RECNOZZO))
			Reclock("ZZO",.F.)
			//ZZO->ZZO_STATUS :='2'
			MsUnLock('ZZO')
		Endif
		
	ELSE
		//AADD(_imeistat,{XZZO->ZZO_IMEI,XZZO->ZZO_STATUS})
	ENDIF
	
	XZZO->(dbSkip())
enddo

If !_lqrytri
	MsgBox("Codigo master de triagem CLA invalido ou jแ foi processado esse c๓digo !","Cod triagem CLA invalido","ALERT")
	_lqrytri:=.T.
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

Return(_lqrytri)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECX011GRVบAutor  ณ Antonio L.F.Favero บ Data ณ  27/03/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava registro no ZZ4 e atualiza Memo                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function tecx011grv(cCodBar,Memo,cVARSIM,_lAuto,nvez,cVarmst,nbounce)

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
Local lVlvInc   	:= .F.               
Local _cpessoa      := Posicione("SA1",1,xFilial("SA1") + mv_par01+mv_par02, "A1_PESSOA")


ZZJ->(DbSetOrder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
IF ZZJ->(DbSeek(xFilial("ZZJ")+ALLTRIM(MV_PAR09),.f.))
	_clab      := ZZJ->ZZJ_LAB
	cOpe       := ZZJ->ZZJ_OPERA
	_loperpro  := U_VLDPROD(cOpe,_clab)
	_ccalcgar  := ZZJ->ZZJ_CALGAR // Variavel que diz se a opercao calcula a garantia sim ou nao - Edson Rodrigues 17/04/10
	_cdadoSZA  := ZZJ->ZZJ_DADSZA // Variavel que diz se a opercao busca/inclui dados no SZA - Edson Rodrigues 17/04/10
	cinftrans  := ZZJ->ZZJ_INFTCM  // variavel que informa o Transcode - Processo Mclaims - Edson Rodrigues 15/04/10
	ctransfix  := ZZJ->ZZJ_TRAFIX  // variavel que diz se Transcode e fixo,sim, nao ou condicional - Processo Mclaims - Edson Rodrigues 15/04/10
	cinfNFcom  := ZZJ->ZZJ_INFNFC  // variavel que diz se a na operacao pode ser ou nao informado Nf compra cliente ou fornecedor outros - Edson Rodrigues 15/04/10
	cinfcaut   := ZZJ->ZZJ_INFCAU  // variavel que diz se informa dados da NF compra ou cod. autorizada se ZZJ_TRAFIX=NAO e ZZJ_INFTCM=SIM - Edson Rodrigues 16/04/10
	cinfaces   := ZZJ->ZZJ_INFACE  // variavel que diz se a operacao informarแ acess๓rio na entrada massiva - Edson Rodrigues 16/04/10
	cvlopent   := ZZJ->ZZJ_TROPEN  // variavel que indica se deve fazer valida็ใo de troca de opera็ใo
	ctravbou   := ZZJ->ZZJ_TRABEN  // variavel que indica se trava aparelhos bounce na entrada
	nqtdboun   := ZZJ->ZZJ_QTDBEN  // variavel que indica a quantidade de dias para travar o aparelho bounce na entrada massiva
	_cVconre  := ZZJ->ZZJ_VCONRE   // variavel que indica se haverแ busca do imei na importa็ใo inicial da SZP
	lVlvInc	  := (ZZJ->ZZJ_VLVINC == "S") .OR. (ZZJ->ZZJ_VLVINC == "C" .AND. _cpessoa<>"J")
ELSE
	ApMsgInfo("Nใo foi encontrado a operacao cadastrada para o IMEI "+alltrim(cCodBar)+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao nใo localizada!")
	return()
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta campo MEMO com confirmacao de leitura do IMEI                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SB1->(DBSeek(xFilial('SB1')+_cCodPro))
if !_lAuto .or. (_lAuto .and. centriage = "S") .or. (_lAuto .and.lselqrytst)
	tMemo := 'Cliente: '+mv_par01+' Loja: '+mv_par02+LFRC
	tMemo += 'Produto: '+_cCodPro+' Descricao: '+SB1->B1_DESC+LFRC
	tMemo += 'SN: '+cCodBar+'   SIM/Carca็a: '+cVarSIM+LFRC
	tMemo += 'NF: '+mv_par04+' S้rie: '+mv_par05+' Valor: '+Transform(_nVlrUnit,'@E 999,999.99999')+LFRC
	_nVez := 0
endif


If !_lAuto .or. centriage = "S" .or.lselqrytst
	tMemo += LFRC
	Memo  := tMemo + Memo
	Close(oDlg)
endif

cCodBar:=space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',20)
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtecx011E  บAutor  ณ Antonio L.F.Favero บ Data ณ  28/08/2002 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fecha a janela de devolucao                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//static Function fechentmas(_lAuto)
user Function fechentmas(_lAuto)

_lFechEM := .T.

if !_lAuto .or. centriage= "S" .or. lselqrytst
	Close(oDlg)
endif

Return
                 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณspallet   บAutor  ณ Edson Rodrigues    บ Data ณ  08/05/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ seleciona Pallet                                           บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function spallet()
// Variaveis Private da Funcao
Private ospallet
_cpallet :=Space(3)

DEFINE MSDIALOG oDlgtop TITLE "Pallet" FROM C(306),C(324) TO C(465),C(534) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(080),C(103) LABEL "Seleciona Pallet" PIXEL OF oDlgtop
	// Cria Componentes Padroes do Sistema
	@ C(015),C(004) Say "Pallet" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlgtop
	@ C(014),C(025) MsGet ospallet Var _cpallet   Size C(052),C(009) COLOR CLR_BLACK PIXEL OF oDlgtop

DEFINE SBUTTON FROM C(058),C(043) TYPE 1 ENABLE OF oDlgtop ACTION (oDlgtop:end())

ACTIVATE MSDIALOG oDlgtop CENTERED

Return(_cpallet)

