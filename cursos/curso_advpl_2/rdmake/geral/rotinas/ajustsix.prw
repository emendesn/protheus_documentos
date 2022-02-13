#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTSIX  ºAutor  ³Hudson Souza        º Data ³  06/25/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para ajuste da tabela SIX                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BGH                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function AjustSIX()
Local aSIXErr := {}
Local cInd		:= ""
Local cOrd		:= ""
Local nX		:= 0
Local cMsg		:= ""
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" 
dbSelectArea("SIX")
SIX->(dbSetOrder(1))
SIX->(dbGoTop())
cMsg := "<p>O processo iniciou- se as " + Time() + ". Foram encontrados os seguintes erros:</p>"
cMsg += "<table><tr><th></th><th>INDICE</th><th>ORDEM</th></tr>"
While !SIX->(Eof())
	If cInd == SIX->INDICE .AND. cOrd == SIX->ORDEM .AND. cInd <> "" .AND. cOrd <> ""
		nX += 1
		aAdd(aSIXErr, {nX, SIX->INDICE, SIX->ORDEM, SIX->CHAVE})
		cMsg += "<tr><th>"+Alltrim(Transform(nX, "@ 999999"))+"</th><th>"+SIX->INDICE+"</th><th>"+SIX->ORDEM+"</th></tr>"
		RecLock("SIX",.F.)
			 SIX->(DbDelete())
		MsUnlock()
	EndIf
	cInd := SIX->INDICE
	cOrd := SIX->ORDEM
	SIX->(dbSkip())
EndDo
cMsg += "</table><p>Processo finalizou-se as "+Time()+"</p>"
Msginfo("Foram encontrados " + Alltrim(Transform(nX, "@ 999999")) + " registro(s) com erro.","SIX com Erro")
u_COMPEMAIL("SIX com erro","uiran.almeida@bgh.com.br","",cMsg,"")
//RESET ENVIRONMENT
Return