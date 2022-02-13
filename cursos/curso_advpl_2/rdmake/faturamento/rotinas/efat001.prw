#include "rwmake.ch"
//#Include "Colors.ch"
 #INCLUDE "topconn.ch"

User Function EFAT001()


local _ccodprod := ""
local _ccodkit  := ""
local _nQtde    := 0     

_ccodprod := 	SC6->C6_PRODUTO
_cCodKit  :=    SC5->C5_B_KIT   
_nQtdVen  := 	SC6->C6_QTDVEN


u_GerA0003(ProcName())

If !Empty(_cCodKit)
	
	cQuery := " SELECT B6_DOC, B6_SERIE, B6_PRODUTO, B6_SALDO "
	cQuery += " FROM " + RETSQLNAME("SB6")
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND B6_PRODUTO = '"+_cCodprod+"'"
	cQuery += " AND B6_SALDO > 0 "   
	
	TCQUERY cQuery NEW ALIAS "QRY"
   
    _cMens := ""

   	While !Eof("QRY")	                                                                                                        
		_cMens += "Produto : "+QRY->B6_PRODUTO + Space(04)+"Nota : "+ALLTRIM(QRY->B6_DOC)+SPACE(08)+"Serie : "+ALLTRIm(QRY->B6_SERIE)+SPACE(10)+"Saldo : "+Alltrim(str(QRY->B6_SALDO))+Space(45);
	   //	DbSelectArea("QRY")
		DbSkip()
 	Enddo	

	Alert(_cMens,"Saldo em Poder de Terceiros")    

   //	DbSelectArea("QRY")
   //	DbCloseArea()
EndIf

Return(_nQtdVen)
