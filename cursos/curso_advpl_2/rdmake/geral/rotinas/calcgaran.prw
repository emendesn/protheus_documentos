#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#INCLUDE "topconn.ch"
#include "tbiconn.ch"

#define LFRC CHR(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CALCGARAN º Autor ³ Edson Rodrigues    º Data ³  MAIO /08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Prgrama para Calcular se o aparelho esta ou nao em garantiaº±±
±±º          ³ Especifico Laboratorio Nextel - Aparelhos Motorola         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User function CALCGARAN()



PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "ZZ4","SZA"
lnumser  :=.f.
lSZA  :=.f.
cgaran:=""
//nrecno:=1545462
nrecno:=1650592
Private aAlias  := {"SZA","ZZ4"}


u_GerA0003(ProcName())

dbSelectArea("ZZ4")
DbSetOrder(1) //ZZ4_FILIAL+ZZ4_CONTA

ZZ4->(dbgoto(nrecno))
While !ZZ4->(eof())  //.AND. LEN(ZZ4->ZZ4_CARCAC)=10 .AND. DTOC(ZZ4->ZZ4_NFEDT)  >='04/05/10'
	lnumser:=IIF(LEN(ALLTRIM(ZZ4->ZZ4_CARCAC))=10,.T.,.F.)
	IF lnumser  .and. EMPTY(ZZ4_GARANT)    .and. ( LEFT(ZZ4->ZZ4_IMEI,4) $ "0006/0017" .OR.  LEFT(ZZ4->ZZ4_IMEI,2) $ "RF")
		DBSELECTAREA("SZA")
		IF SZA->(dbSeek(xFilial("SZA") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI)) .and. !empty(ZZ4->ZZ4_IMEI)
			lSZA:=IIF(!EMPTY(SZA->ZA_DTNFCOM),.T.,.F.)
			IF lSZA
				cgaran:=valgarnfc(SZA->ZA_DTNFCOM,ZZ4->ZZ4_OPEBGH)
			ELSE
				cgaran:=U_Vergaran(ALLTRIM(ZZ4->ZZ4_CARCAC),ZZ4->ZZ4_OPEBGH,ZZ4->ZZ4_IMEI)
			ENDIF
		ELSE
			cgaran:=U_Vergaran(ALLTRIM(ZZ4->ZZ4_CARCAC),ZZ4->ZZ4_OPEBGH,ZZ4->ZZ4_IMEI)
		ENDIF
		RecLock('ZZ4',.F.)
		ZZ4->ZZ4_GARANT:=cgaran
		MsUnLock('ZZ4')
	ENDIF
	DBSELECTAREA("ZZ4")
	nrecno++
	ZZ4->(dbgoto(nrecno))
	//ZZ4->(dbSkip())
ENDDO
RETURN




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³valgarnfc º Autor ³ Edson Rodrigues    º Data ³  17/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a data de compra do aparelho Garantia Sim ou Nao     º±±
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
Static function valgarnfc(ddtnfc,coper)
Local _cgaran    	:= "N"
Local _pergar   	:= Posicione("ZZJ", 1, xFilial("ZZJ") + AllTrim(coper), "ZZJ_PERGAR")
Local _cQry
Local cReceiveDir := "\LOG\"
Local cGarant		:= DtoS(ddtnfc)

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

If !Empty(cGarant)		// Alterado 09/06/10 para nao pegar parametro vazio
	
	_cQryExec := " SELECT DATEDIFF(MONTH, '" + cGarant + "' , GETDATE()) AS DATES "
	
	TCQUERY _cQryExec NEW ALIAS "TRB"
	
	
	If TRB->DATES + 1 <= _pergar
		_cgaran:= "S"
	ElseIf TRB->DATES + 1 > _pergar
		_cgaran:= "N"
	EndIf
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	endif
	
	cMsg := "Data Nf" + cGarant + "  Garantia S/N  " + _cgaran + " - " + TRB->DATES + 1 + " Garantia Operacao (" + TransForm(_pergar,"@E 99") + ")  valgarnfc"
	WFConOut( cMsg, oLogFile, .f. )
	cMsg := Replicate( "*", 80 )
	oLogFile:WriteLN( cMsg )
	WFConOut( cMsg )
EndIf


Return(_cgaran)