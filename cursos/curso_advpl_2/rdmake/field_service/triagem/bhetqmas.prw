#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBHETQMAS  บ Autor ณLuciano Siqueira    บ Data ณ  12/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณIMPRIME ETIQUETA MASTER DA TRIAGEM EFETUADA NA BGH          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function BHETQMAS(cMaster)

Local cPorta	:= "LPT1"
Local _cMaster	:= IIF(cMaster <> Nil,cMaster,"")
Local _cMotDev  := ""
Private cPerg		:= "BGHETQMA"
//Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
Private cNextSp		:= GetMv("MV_NEXTSP")
Private cNextRj     := GetMv("MV_NEXTRJ")

u_GerA0003(ProcName())

If empty(_cMaster)
	ValPerg(cPerg) // Ajusta as Perguntas do SX1
	If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
		Return()
	Endif
	_cMaster	:= MV_PAR01
Endif

If !IsPrinter(cPorta)
	Return
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

lAchZZ4 := .F.

dbSelectArea("ZZ4")
dbSetOrder(13)
If dbSeek(xFilial("ZZ4")+_cMaster)
	lAchZZ4 := .T.
Endif

cQry := " SELECT COUNT(*) AS QTDREG "
If lAchZZ4
	cQry += " FROM " + RetSQlName("ZZO") + " ZZO(NOLOCK), "+ RetSQlName("ZZ4") + " ZZ4(NOLOCK) "
Else
	cQry += " FROM " + RetSQlName("ZZO") + " ZZO(NOLOCK) "
Endif
cQry += " WHERE ZZO.D_E_L_E_T_ = '' "
cQry += " AND ZZO_FILIAL='"+xFilial("ZZO")+"' "
cQry += " AND ZZO_NUMCX = '"+_cMaster+"' "
If lAchZZ4
	cQry += " AND ZZO_STATUS = '2' "
	cQry += " AND ZZ4_FILIAL='"+xFilial("ZZ4")+"' "
	cQry += " AND ZZ4_IMEI=ZZO_IMEI "
	cQry += " AND ZZ4_CARCAC=ZZO_CARCAC "
	cQry += " AND ZZ4_ETQMEM=ZZO_NUMCX "
	cQry += " AND ZZ4_DOCSEP='' "
	cQry += " AND ZZ4_STATUS='3' "
	cQry += " AND ZZ4.D_E_L_E_T_ ='' "
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Grava dados no Array                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


dbSelectArea("QRY")
dbGoTop()

If QRY->QTDREG == 0
	apMsgStop("Etiqueta Master nใo Encontrada!")
	Return
Else
	dbSelectArea("ZZO")
	dbSetOrder(4)
	If dbSeek(xFilial("ZZO")+_cMaster)
		
		//_cOperacao := ""
		_cOperacao := ZZO->ZZO_OPERA
		If !empty(ZZO->ZZO_ORIGEM)
			If ZZO->ZZO_REFGAR == "5"
				_cOperacao := "PRATA"
			ElseIf ZZO->ZZO_GARANT == "S" .and. ZZO->ZZO_BOUNCE == "N"
				_cOperacao := "GARANTIA"
			ElseIf ZZO->ZZO_GARANT == "N" .and. ZZO->ZZO_BOUNCE == "N"
				_cOperacao := "FORA DE GARANTIA"
			ElseIf ZZO->ZZO_BOUNCE == "S"
				_cOperacao := "BOUNCE"
			Endif
		Else
			If ZZO->ZZO_REFGAR = '1'
				_cOperacao := "REFURBISH GARANTIA"
			ElseIf ZZO->ZZO_REFGAR = '2'
				_cOperacao := "FORA DE GARANTIA"
			ElseIf ZZO->ZZO_REFGAR = '3'
				_cOperacao := "REPARO GARANTIA"
			ElseIf ZZO->ZZO_REFGAR = '4'
				_cOperacao := "BOUNCE"
			ElseIf ZZO->ZZO_REFGAR = '5'
				_cOperacao := "PRATA"
			Endif
		Endif
		
		_cCliente := ZZO->ZZO_CLIENT
		_cLoja 	  := ZZO->ZZO_LOJA
		_cOrigem  := ZZO->ZZO_ORIGEM
		_cOpeBgh  := ZZO->ZZO_OPERA
		_cNF 	  := ZZO->ZZO_NF
		_cSerie   := ZZO->ZZO_SERIE
		_dDtEst   := ZZO->ZZO_DTDEST 
		_cPallet  := ""
		
		
		dbSelectArea("ZZ4")
		dbSetOrder(13)
		If dbSeek(xFilial("ZZ4")+_cMaster)
			If Empty(_cOrigem)
				_cCliente := ZZ4->ZZ4_CODCLI
				_cLoja 	  := ZZ4->ZZ4_LOJA
				_cOpeBgh  := ZZ4->ZZ4_OPEBGH
				_cNF 	  := ZZ4->ZZ4_NFENR
				_cSerie   := ZZ4->ZZ4_NFESER
				_dDtEst   := ZZ4->ZZ4_NFEDT
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1")+_cCliente+_cLoja)
					_cOrigem  := SA1->A1_EST
				Endif
			Endif      
			_cPallet  := ZZ4->ZZ4_PALLET			
		Endif
		
		MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)
		
		MSCBCHKSTATUS(.F.)
		
		MSCBBEGIN(1,6)
		
		//       c   l   c   l
		MSCBBOX(004,007,096,120,4)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Primeira Linha                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//       c   l   c   l
		MSCBBOX(004,007,030,030,4)
		MSCBSAY(010,020,"BGH","N","0","065,075",.T.)
		//       c   l   c   l
		MSCBBOX(030,007,096,030,4)
		MSCBSAYBAR(035,012,Alltrim(_cMaster),"N","MB07",08,.F.,.F.,.F.,,2,1)
		MSCBSAY(038,022,Alltrim(_cMaster),"N","0","035,045",.T.)
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Segunda Linha                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//       c   l   c   l
		MSCBBOX(004,030,055,048,4)
		MSCBSAY(006,032,"DATA ENTRADA: ","N","0","035,045",.T.)
		MSCBSAY(008,040,DTOC(_dDtEst),"N","0","085,095",.T.)
		//       c   l   c   l
		MSCBBOX(055,030,096,048,4)
		MSCBSAY(057,032,"QUANTIDADE: ","N","0","035,045",.T.)
		MSCBSAY(061,040,STRZERO(QRY->QTDREG,3),"N","0","085,095",.T.)
		
		If !ALLTRIM(ZZO->ZZO_ORIGEM) $ "ZZ4/DEV/POS"
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//| Terceira Linha                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//       c   l   c   l
			MSCBBOX(004,048,055,066,4)
			MSCBSAY(006,050,"CODIGO CLIENTE: ","N","0","035,045",.T.)
			MSCBSAY(008,058,Alltrim(_cCliente)+'-'+_cLoja,"N","0","085,095",.T.)
			//       c   l   c   l
			MSCBBOX(055,048,096,066,4)
			MSCBSAY(057,050,"ORIGEM: ","N","0","035,045",.T.)
			MSCBSAY(061,058,ALLTRIM(_cOrigem),"N","0","065,075",.T.)
		Else
			If !Empty(ZZO->ZZO_MOTIVO)
				_cMotDev := AllTrim(Posicione("SX5", 1, xFilial("SX5")+'WG'+ZZO->ZZO_MOTIVO, "X5_DESCRI"))
				MSCBSAY(006,050,"MOTIVO: ","N","0","035,045",.T.)
				MSCBSAY(008,058,Alltrim(_cMotDev),"N","0","085,095",.T.)
			Endif
		Endif
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Quarta Linha                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		_cArmz := ALLTRIM(POSICIONE("ZZJ",1,xFilial("ZZJ") + _cOpeBgh,"ZZJ_ARMENT"))
		
		/* Enio informou que master prata tem que entrar na regra abaixo (SP=Arm 10 RIO=Arm 11)
		If ZZO->ZZO_REFGAR=="5"
		_cArmz :="17"
		Endif
		*/
		
		If len(_cArmz) > 2

			/*If Alltrim(_cOpeBgh)=="N01"
				IF _cCliente =='000680' .and. _cLoja == '01'
					_cArmz :="11"
				Elseif _cCliente =='000016' .and. _cLoja == '01'
					_cArmz :="10"
				Endif*/  
			If Alltrim(_cOpeBgh)=="N01"
				IF _cCliente $ Alltrim(cNextRj) .and. _cLoja == '01'
					_cArmz :="11"
				Elseif _cCliente $ Alltrim(cNextSp) .and. _cLoja == '01'
					_cArmz :="10"
				Endif

			Elseif Alltrim(_cOpeBgh)=="N02"
				dbSelectArea("SA1")
				dbSetOrder(1)
				IF DBSeek(xFilial('SA1')+_cCliente+_cLoja)
					IF '669702290' $ (LEFT(SA1->A1_CGC,9))
						_cArmz :="16"
					Endif
				Endif
			Endif
		Endif
		
		If !ALLTRIM(ZZO->ZZO_ORIGEM) $ "POS"
			//       c   l   c   l
			MSCBBOX(004,066,055,084,4)
			MSCBSAY(006,068,"MODELO: ","N","0","035,045",.T.)
			MSCBSAY(008,075,Alltrim(ZZO->ZZO_MODELO),"N","0","065,075",.T.)
		Else
			//       c   l   c   l
			MSCBBOX(004,066,055,084,4)
			MSCBSAY(006,068,"PALLET: ","N","0","035,045",.T.)
			MSCBSAY(008,075,_cPallet,"N","0","065,075",.T.)
		Endif
		//       c   l   c   l
		MSCBBOX(055,066,096,084,4)
		MSCBSAY(057,068,"ARMAZEM: ","N","0","035,045",.T.)
		MSCBSAY(061,075,ALLTRIM(_cArmz),"N","0","065,075",.T.)
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Quinta Linha                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//       c   l   c   l
		MSCBBOX(004,084,096,102,4)
		MSCBSAY(006,086,"OPERACAO: ","N","0","035,045",.T.)
		MSCBSAY(008,093,_cOperacao,"N","0","085,095",.T.)
		
		If ALLTRIM(ZZO->ZZO_ORIGEM) $ "ZZ4/DEV/POS"
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//| Sexta Linha                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//       c   l   c   l
			MSCBBOX(004,102,096,120,4)
			MSCBSAY(006,104,"NRO MASTER: ","N","0","035,045",.T.)
			MSCBSAY(008,110,Alltrim(ZZO->ZZO_NUMCX),"N","0","085,095",.T.)
			
			MSCBBOX(004,120,096,138,4)
			MSCBSAY(006,122,"USUARIO: ","N","0","035,045",.T.)
			MSCBSAY(008,130,Alltrim(ZZO->ZZO_USRSEP),"N","0","085,095",.T.)
		Else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//| Sexta Linha                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//       c   l   c   l
			MSCBBOX(004,102,096,120,4)
			MSCBSAY(006,104,"NOTA FISCAL: ","N","0","035,045",.T.)
			MSCBSAY(008,110,Alltrim(_cNF)+'/'+Alltrim(_cSerie),"N","0","085,095",.T.)
			
			
			MSCBBOX(004,120,096,138,4)
			MSCBSAY(006,122,"USUARIO ENTRADA: ","N","0","035,045",.T.)
			MSCBSAY(008,130,Alltrim(ZZO->ZZO_USRSEP),"N","0","085,095",.T.)
		Endif
		
		
		MSCBEND()
		
		MSCBCLOSEPRINTER()
		
	Endif
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg   บ Autor ณLuciano Siqueira    บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPerguntas                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Etq Master    ?','' ,'' , 'mv_ch1', 'C', 20, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')

Return
