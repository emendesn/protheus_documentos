#INCLUDE "APWEBSRVl.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Vinicius Leonardo  º Data ³  19/02/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 		  													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSSNFE(aCabec,aItens,cSerNf,lTipo)

Local nHdlSemaf := 0
Local cRotinExc := "NFEBAT"
Local cQuery  	:= ""
Local _cAlias 	:= ""
Local lRet 	  	:= .T.
Local nPosTicket:= 0  

//MAXIMO DE 200 PILHAS DE CHAMADAS
While !U_SemaNFE(cRotinExc, @nHdlSemaf, .T., lProces)
	If lProces .or. nStack >= 190 
		If nStack >= 190
			If !lMsg
				Aadd(aRet,{'Não foi possível realizar a entrada da NF por controle de processamento, tente novamente mais tarde.',.T.,.F.})
				lMsg := .T.
			EndIf
		EndIf
		Return aRet
	EndIf
	nStack:=nStack+1
	Sleep(200)
	U_CSSNFE(aCabec,aItens,cSerNf)
EndDo

lProces := .T. 

_cAlias := GetNextAlias()
nPosTicket := Ascan( aItens[1] ,{ |x| x[1] == "D1_XCSSNUM" })	
cQuery := " SELECT D1_DOC FROM " + RetSqlName("SD1") + CRLF
cQuery += " WHERE D1_FILIAL = '" + xFilial("SD1") + "' AND D_E_L_E_T_ <> '*' " + CRLF
cQuery += " AND D1_XCSSNUM = '" + AvKey(aItens[1][nPosTicket][2],"D1_XCSSNUM") + "' " + CRLF 
cQuery += " AND D1_LOCAL = 'AE' " + CRLF 


cQuery := ChangeQuery(cQuery) 
If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
( _cAlias )->( dbGoTop() )
If( ( _cAlias )->( !Eof() ) ) 
	Aadd(aRet,{'Ticket com entrada já existente',.T.,.T.})    
	lRet := .F.
Else
	lRet := .T.	
EndIf

If lRet
	cNumNf := AvKey(Alltrim(GetSetNF(cSerNf)),"F1_DOC")
	If Empty(cNumNf)
		Aadd(aRet,{'Problemas para buscar NF de entrada',.T.,.F.})
		lRet := .F.
		U_retnfant(cNumNf,cSerNf)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Buscando o número da NF corretamente, ajusta os arrays para MsExecauto³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 to Len(aItens)
			nPosNum	:= Ascan(aItens[nX],{|x|x[1] = "D1_DOC"})
			aItens[nX][nPosNum][2] := cNumNf
		Next nX
		nPosNum	:= Ascan(aCabec,{|x|x[1] = "F1_DOC"})
		aCabec[nPosNum][2] := cNumNf
		lRet := .T.
	EndIf
	If lRet
		lMsErroAuto := .F.
		MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCabec, aItens,3,lTipo)
		If lMsErroAuto
			DisarmTransaction()
			Aadd(aRet,{'Erro no ExecAuto',.T.,.F.})
			U_retnfant(cNumNf,cSerNf)
		EndIf
	EndIf
EndIf	

U_SemaNFE(cRotinExc, @nHdlSemaf, .F.)

Return aRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetSetNF  ºAutor  ³Hudson de Souza Santos  ºData ³ 16/04/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Método diferente para buscar a NF já comitando              º±±
±±º          ³*Melhor deixar NF's inutilizadas a duplicar NF.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetSetNF(cSerNf)
Local cTab		:= "01"
Local cFilSX5	:= xFilial("SF1")
Local cNumNF	:= ""
dbSelectArea("SX5")
dbSetOrder(1)
If ( dbSeek(cFilSX5+cTab+cSerNF) )
	RecLock("SX5",.F.)
	cNumNF			:= SX5->X5_DESCRI
	SX5->X5_DESCRI  := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
	SX5->X5_DESCSPA := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
	SX5->X5_DESCENG := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
	SX5->(MsUnLock())
EndIf
Return(cNumNF)