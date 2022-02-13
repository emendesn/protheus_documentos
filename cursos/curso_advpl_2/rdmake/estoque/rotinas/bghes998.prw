#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

#define ENTER CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BGHES998	ºAutor  ³Luciano Siqueira      º Data ³  26/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa Estorno do documento original após execução do item  º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BGHES998()

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" TABLES "SD3"

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

cQry	:=	" SELECT "
cQry	+=	" 	D3_DOC,D3_COD, D3_QUANT AS QTD3, "
cQry	+=	"	SD3.R_E_C_N_O_ AS RECD3 "
cQry	+=	" FROM " + RetSqlName("SD3") + " SD3 "
cQry	+=	" INNER JOIN " + RetSqlName("DCF") + " DCF ON "
cQry	+=	"		(DCF_NUMSEQ=D3_NUMSEQ AND DCF_DOCTO=D3_DOC AND DCF_CODPRO=D3_COD AND DCF_STSERV='3' AND DCF.D_E_L_E_T_ = '') "
cQry	+=	" WHERE "
cQry	+=	"		D3_FILIAL = '"+xFilial("SD3")+"' "
cQry	+=	"		AND D3_TM = '998' "  
cQry	+=	"		AND D3_QUANT > 0 "  
cQry	+=	"		AND D3_ESTORNO <> 'S' " 
cQry	+=	"		AND D3_SERVIC <> '' "  
cQry	+=	"		AND D3_STSERV='3' "  
cQry	+=	"		AND SD3.D_E_L_E_T_ = '' "
cQry	+=	" ORDER BY D3_DOC,D3_NUMSEQ "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

dbSelectArea("QRY")
QRY->(dbGoTop())

While !EOF("QRY")

	If Select("QRY1") > 0
		QRY1->(dbCloseArea())
	EndIf

	cQry1	:=	" SELECT "
	cQry1	+=	" 	SUM(DB_QUANT) AS QTDB "
	cQry1	+=	" FROM " + RetSqlName("SDB") + " SDB "
	cQry1	+=	" WHERE "
	cQry1	+=	" 	DB_FILIAL='"+xFilial("SDB")+"' AND "
	cQry1	+=	" 	DB_DOC='"+QRY->D3_DOC+"' AND "
	cQry1	+=	" 	DB_PRODUTO='"+QRY->D3_COD+"' AND "
	cQry1	+=	" 	DB_TM > '500' AND "
	cQry1	+=	" 	DB_ESTORNO = '' AND "
	cQry1	+=	" 	DB_ATUEST = 'N' AND "
	cQry1	+=	" 	DB_STATUS='1' AND "
	cQry1	+=	" 	SDB.D_E_L_E_T_ = '' "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry1), "QRY1", .F., .T.)

	dbSelectArea("QRY1")
	
	If QRY->QTD3==QRY1->QTDB
		dbSelectArea("SD3")
		SD3->(dbGoto(QRY->RECD3))
		RecLock("SD3",.F.)
		SD3->D3_QUANT	:= 0
		SD3->D3_ESTORNO	:= "S"
		MsUnLock()
	Endif
	
	If Select("QRY1") > 0
		QRY1->(dbCloseArea())
	EndIf
		
	dbSelectArea("QRY")
	
	dbSkip()
	
EndDo

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

Return
