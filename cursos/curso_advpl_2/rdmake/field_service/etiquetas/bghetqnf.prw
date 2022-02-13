#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBGHETQNF  บ Autor ณLuciano Siqueira    บ Data ณ  02/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณIMPRIME ETIQUETA COM DADOS DA LOJA E NOTAS FISCAIS GERADAS  บฑฑ
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


User Function BGHETQNF(_aDados,_cTes,_cLayETQ)

Local _cNFIni  := ""
Local _cNFFim  := ""
Local _cSerIni := ""
Local _cSerFim := ""
Local _nQtdEtq := 1

Local cPorta	:= "LPT1"

Private cPerg    := "BETQNF"

u_GerA0003(ProcName())

/*ValPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
Endif


If !IsPrinter(cPorta)
	Return
Endif


If MV_PAR01 == 0
	_nQtdEtq := 1
Else
	_nQtdEtq := MV_PAR01
Endif*/

If Len(_aDados) <= 0
	apMsgStop("Nใo foi encontrado dados para gera็ใo da Etiqueta. Contate o Administrado do sistema.")
	Return
Endif

_cSerIni := _aDados[1,1]
_cSerFim := _aDados[Len(_aDados),1]
_cNFIni  := _aDados[1,2]
_cNFFim  := _aDados[Len(_aDados),2]
_cNumEtq := _aDados[1,3]

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf


_cQry := " SELECT "
_cQry += " F2_DOC,F2_SERIE,A1_COD,A1_LOJA,A1_CGC,A1_NREDUZ,A1_NOME, "
_cQry += " A1_END,A1_BAIRRO,A1_CEP,A1_MUN,A1_EST "
_cQry += " FROM   " + RetSqlName("SF2") + " AS SF2 (nolock) "
_cQry += " INNER JOIN "+ RetSqlName("SA1") + " AS SA1 ON (F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_ = '') "
_cQry += " WHERE "
_cQry += " F2_FILIAL='"+xFilial("SF2")+"' "
_cQry += " AND F2_DOC BETWEEN '"+_cNFIni+"'    AND '"+_cNFFim+"' "
_cQry += " AND F2_SERIE BETWEEN '"+_cSerIni+"'    AND '"+_cSerFim+"' "
_cQry += " AND F2_XNUMETQ='"+_cNumEtq+"' "
_cQry += " AND SF2.D_E_L_E_T_=' ' "
_cQry += " ORDER BY F2_DOC, F2_SERIE "

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Grava dados no Array                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


dbSelectArea("QRY")
dbGoTop()

If _cLayETQ == "1"
	
	While QRY->(!EOF())
		
		MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)
		
		MSCBCHKSTATUS(.F.)
		
		MSCBBEGIN(_nQtdEtq,6)
		
		_cCompEnd:= Alltrim(QRY->A1_BAIRRO)+" - "+Transform(QRY->A1_CEP,"@R 99999-999")
		
		MSCBBOX(005,007,095,030,4)
		MSCBSAY(006,009+2,"Nome Fantasia: "+Alltrim(QRY->A1_NREDUZ),"N","0","035,045",.T.)
	    
	    If Len(Alltrim(QRY->A1_END)) > 37
			MSCBSAY(006,012+2,"Endere็o: "+SubStr(Alltrim(QRY->A1_END),1,37),"N","0","035,045",.T.)
			MSCBSAY(006,015+2,SubStr(Alltrim(QRY->A1_END),38,74)			,"N","0","035,045",.T.)
			
			MSCBSAY(006,018+2,_cCompEnd,"N","0","035,045",.T.)
			MSCBSAY(006,021+2,Alltrim(QRY->A1_MUN)+" - "+QRY->A1_EST,"N","0","035,045",.T.)
			MSCBSAY(006,024+2,"CNPJ: "+Transform(QRY->A1_CGC, "@R 99.999.999/9999-99"),"N","0","035,045",.T.)
		Else
			MSCBSAY(006,012+2,"Endere็o: "+Alltrim(QRY->A1_END),"N","0","035,045",.T.)  
			MSCBSAY(006,015+2,_cCompEnd,"N","0","035,045",.T.)
			MSCBSAY(006,018+2,Alltrim(QRY->A1_MUN)+" - "+QRY->A1_EST,"N","0","035,045",.T.)
			MSCBSAY(006,021+2,"CNPJ: "+Transform(QRY->A1_CGC, "@R 99.999.999/9999-99"),"N","0","035,045",.T.)	
		EndIf	                                                                                             
		
		MSCBSAY(030,033,"NOTAS FISCAIS ","N","0","035,045",.T.)	
		
		_nLin := 3
		X	  := 1
		
		While QRY->(!EOF())
			MSCBSAY(006,020 + 2*(X +(4*_nLin)-2),QRY->F2_DOC,"N","0","055,065",.T.)
			dbSelectArea("QRY")
			DbSkip()
			If QRY->(!EOF())
				MSCBSAY(030+5,020 + 2*(X +(4*_nLin)-2),QRY->F2_DOC,"N","0","055,065",.T.)
				dbSelectArea("QRY")
				DbSkip()
				If QRY->(!EOF())
					MSCBSAY(060+5,020 + 2*(X +(4*_nLin)-2),QRY->F2_DOC,"N","0","055,065",.T.)
					dbSelectArea("QRY")
					DbSkip()
				Endif
			Endif
			_nLin ++
			X ++
			If X == 9
				Exit
			Endif
		EndDo
		MSCBEND()
		MSCBCLOSEPRINTER()
	EndDo
	
ElseIf _cLayETQ == "2"
	
	If QRY->(!EOF())
		For i:= 1 To _nQtdEtq
			dbSelectArea("QRY")
			dbGoTop()
			While QRY->(!EOF())
				//MSCBPRINTER("Z90XI",cPorta,,22,.F.,,,,,,.T.)
				MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)
				
				MSCBCHKSTATUS(.F.)
				
				//MSCBBEGIN(MV_PAR01,6)
				MSCBBEGIN(1,6)
				
				_cCompEnd:= Alltrim(QRY->A1_BAIRRO)+" - "+Transform(QRY->A1_CEP,"@R 99999-999")
				
				MSCBBOX(005,007,095,030,4)
				MSCBSAY(006,009+2,"Remetente: "+ALLTRIM(SM0->M0_NOME),"N","0","035,045",.T.)
				MSCBSAY(006,012+2,"Destino: "+Alltrim(QRY->A1_NOME),"N","0","035,045",.T.)
				MSCBSAY(006,015+2,"Endere็o: "+Alltrim(QRY->A1_END),"N","0","035,045",.T.)
				MSCBSAY(006,018+2,_cCompEnd,"N","0","035,045",.T.)
				MSCBSAY(006,021+2,Alltrim(QRY->A1_MUN)+" - "+QRY->A1_EST,"N","0","035,045",.T.)
				MSCBSAY(006,024+2,"Volume: "+STRZERO(i,3)+"/"+STRZERO(_nQtdEtq,3),"N","0","035,045",.T.)
				
				MSCBSAY(030,033,"NOTAS FISCAIS ","N","0","035,045",.T.)
				
				_nLin := 3
				X	  := 1
				
				While QRY->(!EOF())
					MSCBSAY(006,020 + 2*(X +(4*_nLin)-2),QRY->F2_DOC,"N","0","055,065",.T.)
					dbSelectArea("QRY")
					DbSkip()
					If QRY->(!EOF())
						MSCBSAY(030+5,020 + 2*(X +(4*_nLin)-2),QRY->F2_DOC,"N","0","055,065",.T.)
						dbSelectArea("QRY")
						DbSkip()
						If QRY->(!EOF())
							MSCBSAY(060+5,020 + 2*(X +(4*_nLin)-2),QRY->F2_DOC,"N","0","055,065",.T.)
							dbSelectArea("QRY")
							DbSkip()
						Endif
					Endif
					_nLin ++
					X ++
					If X == 8
						Exit
					Endif
				EndDo
				
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4")+_cTes)
				
				MSCBSAY(006,020 + 2*(X +(4*_nLin)-2),Alltrim(SF4->F4_MENNOTA),"N","0","045,055",.T.)
				
				MSCBEND()
				MSCBCLOSEPRINTER()
			EndDo
		Next i
	Endif
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf


Return

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Qtde Etiqueta         ?','' ,'' , 'mv_ch1', 'N', 1, 0, 0, 'C', '', '', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')

Return
