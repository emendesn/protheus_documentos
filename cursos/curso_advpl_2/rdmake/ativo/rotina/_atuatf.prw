#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_ATUATF   ºAutor  ³Graziella Bianchin  º Data ³  01/26/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de atualizacao de Identif.Bem de Acordo com o Grupo  º±±
±±º          ³que o Ativo faz parte                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Rotina de uso exclusivo BGH                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function _ATUATF()

u_GerA0003(ProcName())

DbSelectarea("SN1")
Dbgotop()
While SN1->(!Eof())
	reclock("SN1",.F.)
	IF (alltrim(SN1->N1_GRUPO)=="BENF")
		SN1->N1_DETPATR:= "01"
	ELSEIF (alltrim(SN1->N1_GRUPO)=="IGER")
		SN1->N1_DETPATR:= "03"
	ELSEIF (alltrim(SN1->N1_GRUPO)=="COMP") .OR. (alltrim(SN1->N1_GRUPO)=="FEAC") .OR. (alltrim(SN1->N1_GRUPO)=="MAQE")
		SN1->N1_DETPATR:= "04"
	ELSEIF (alltrim(SN1->N1_GRUPO)=="APIN")
		SN1->N1_DETPATR:= "05"
	ELSEIF (alltrim(SN1->N1_GRUPO)=="VEIC")
		SN1->N1_DETPATR:= "06"
	ELSEIF (alltrim(SN1->N1_GRUPO)=="MOVU") .OR. (alltrim(SN1->N1_GRUPO)=="SOFT") 
		SN1->N1_DETPATR:= "99"
	ENDIF
	msunlock()
	SN1->(DbSkip())
Enddo
Alert("Campos atualizados com sucesso!!!")
Return