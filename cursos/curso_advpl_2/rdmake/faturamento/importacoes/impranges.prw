#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpRangesบAutor  ณ Vinicius Leonardo  บ Data ณ  23/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para importar ranges de objetos para o sistema	  บฑฑ
ฑฑบ          ณ para ser usado na impressใo de etiquetas dos correios.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpRanges()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa็ใo de objetos para os Correios. "
Local cDesc1  := "Este programa tem o objetivo de importar os objetos dos  "
Local cDesc2  := "Correios para gerar novas etiquetas."
Local cDesc3  := ""
Local cDesc4  := ""

Private cPerg := "RANPLP"

u_GerA0003(ProcName())

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| IMPRGA(@lEnd)}, "Aguarde...","Gerando importa็ใo de objetos ...", .T. )

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPRGA   บAutor  ณVinicius Leonardo	 บ Data ณ  23/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para importar os ranges						      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IMPRGA(lEnd)

Local FxIni   := mv_par01 
Local FxFin   := mv_par02 
Local cCliente:= mv_par03 
Local cLoja   := mv_par04
Local nNumIni := 0 
Local nNumFin := 0
Local cSigla  := ""
Local cObjeto := ""
Local cCodAdm := ""

If !(SubStr(FxIni,1,2) $ "DM;DN")
	Msgstop("A sigla inicial informada no parametro Faixa Inicial ้ invแlida. Verifique os parametros.","Sigla invแlida","STOP")
	Return
EndIf 
If !(SubStr(FxFin,1,2) $ "DM;DN")
	Msgstop("A sigla inicial informada no parametro Faixa Final ้ invแlida. Verifique os parametros.","Sigla invแlida","STOP")
	Return
EndIf
If Len(FxIni) # 12
	Msgstop("A quantidade de caracteres informada no parametro Faixa Inicial ้ invแlida, terแ que ser 12 caracteres. Verifique os parametros.","Caracteres invแlidos","STOP")
	Return
EndIf
If Len(FxFin) # 12
	Msgstop("A quantidade de caracteres informada no parametro Faixa Final ้ invแlida, terแ que ser 12 caracteres. Verifique os parametros.","Caracteres invแlidos","STOP")
	Return
EndIf
If SubStr(FxIni,1,2) # SubStr(FxFin,1,2) 
	Msgstop("A sigla inicial informada na Faixa Inicial estแ diferente da sigla inicial informada na Faixa Final. Verifique os parametros.","Siglas invแlidas","STOP")
	Return
EndIf
cCodAdm := Alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CODADM"))
If Empty(cCodAdm)
	Msgstop("Codigo administrativo do cliente estแ vazio. Verifique os parametros.","Nใo existe","STOP")
	Return
EndIf

cSigla := SubStr(FxIni,1,2)

DbSelectArea("ZB2")
ZB2->(DbSetOrder(3))

nNumIni := Val(SubStr(FxIni,3,8)) 
nNumFin := Val(SubStr(FxFin,3,8))

For nx := nNumIni To nNumFin
	cObjeto := cSigla+Strzero(nx,8)+"BR"
	ZB2->(DbGoTop())
	If ZB2->(!DbSeek(xFilial("ZB2")+AvKey(cCodAdm,"ZB2_CODADM")+AvKey(cObjeto,"ZB2_OBJETO")))	
		If Reclock("ZB2",.T.)		
			ZB2->ZB2_OBJETO := cObjeto
			ZB2->ZB2_CODADM := cCodAdm		
			ZB2->(MsUnlock())		
		EndIf	
	EndIf
Next nx	

AtuParam(cSigla,cCodAdm)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuParam  บAutor  ณVinicius Leonardo	 บ Data ณ  23/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a contagem de objetos vแlidos e atualiza parametro     บฑฑ
ฑฑบ          ณ auxiliar.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuParam(cSigla,cCodAdm)

Local cQuery  := "" 
Local _cAlias := GetNextAlias()
Local cAliZZJ := ""
Local cPar	  := ""

cQuery := " SELECT COUNT(ZB2_OBJETO) AS QTD FROM " + RetSqlName("ZB2") + CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*' " + CRLF 
cQuery += " AND ZB2_FILIAL = '" + xFilial("ZB2") + "' " + CRLF 
cQuery += " AND ZB2_CODADM = '" + cCodAdm + "' " + CRLF 
cQuery += " AND SUBSTRING(ZB2_OBJETO,1,2) = '" + cSigla + "' " + CRLF
cQuery += " AND ZB2_USADO <> 'S' " + CRLF

cQuery := ChangeQuery(cQuery) 
If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
( _cAlias )->( dbGoTop() )
If ( ( _cAlias )->( !Eof() ) )	
    
	cAliZZJ := GetNextAlias()
	
	cQuery := " SELECT R_E_C_N_O_ AS RECZZJ FROM " + RetSqlName("ZZJ") + CRLF
	cQuery += " WHERE ZZJ_CODADM = '" + cCodAdm + "' AND D_E_L_E_T_ <> '*' AND ZZJ_FILIAL = '" + xFilial("ZZJ") + "' " + CRLF
	
	cQuery := ChangeQuery(cQuery) 
	If Select(cAliZZJ) > 0;( cAliZZJ )->( dbCloseArea() );EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), cAliZZJ, .t., .t.)
	( cAliZZJ )->( dbGoTop() )
	While ( ( cAliZZJ )->( !Eof() ) )
	
		If Select("ZZJ") == 0
			DbSelectArea("ZZJ")
		EndIf	
		DbGoTo(( cAliZZJ )->(RECZZJ))
		If RecLock("ZZJ",.F.)
			ZZJ->ZZJ_QTDOBJ := ( _cAlias )->(QTD)
			ZZJ->(MsUnlock())
		EndIf		
		( cAliZZJ )->(DbSkip())		
	EndDo
	           
EndIf 

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณVinicius Leonardo	 บ Data ณ  23/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','Faixa Inicial?','Faixa Inicial?','Faixa Inicial?','mv_ch1'	,'C',12							,0,0,'G','','',''	,'S'	,'mv_par01',''		,'','','','','','','','','','','','','','','')
PutSX1(cPerg,'02','Faixa Final?','Faixa Final?','Faixa Final?'		,'mv_ch2'	,'C',12							,0,0,'G','','',''	,'S'	,'mv_par02',''		,'','','','','','','','','','','','','','','') 
PutSx1(cPerg,"03","Cliente?"	,"Cliente?" ,"Cliente?"  			,"MV_CH3"	,"C",TamSX3("A1_COD")[01]		,0,0,"G","","A1CORR","","S"	,"MV_PAR03",""		,"","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Loja?"		,"Loja?" 	,"Loja?"  				,"MV_CH4"	,"C",TamSX3("A1_LOJA")[01]		,0,0,"G","",""		,"","S"	,"MV_PAR04",""		,"","","","","","","","","","","","","","","","","","","")

Return Nil
