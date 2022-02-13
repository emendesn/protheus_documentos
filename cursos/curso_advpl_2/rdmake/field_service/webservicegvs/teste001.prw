#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �TESTE001  �Autor �Hudson de Souza Santos      �Data �28/01/15���
�������������������������������������������������������������������������͹��
���Desc.    �                                                             ���
���         �                                                             ���
�������������������������������������������������������������������������͹��
���Uso      �Espec�fico BGH                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function Teste001()
Local cMsgEmail := ""
Private oSoa
Public cID := ""
WSDLDbgLevel(2)
Sleep(120)
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06"
oSoa:= WSWSServiceOrder():New()
oSoa:cASCCode  := "0000057685"
oSoa:cPassword := "X7F6H8"
oSoa:Login()
cGVS := oSoa:oWSgvsSession:cID
/*
If cID == Nil
	cMsgEmail += '<p><font face="Courier New" size="4" color="#4F81BD">Caros,<br /><br />'
	cMsgEmail += 'O Acesso ao m&eacute;todo Login do WebService WSServiceOrder n&atilde;o esta retornando se&ccedil;&atilde;o.<br />'
	cMsgEmail += 'Solicita&ccedil;&atilde;o efetuada em <strong>'
	cMsgEmail += DTOC(dDataBase)
	cMsgEmail += '</strong> &agrave;s <strong>'
	cMsgEmail += Time()
	cMsgEmail += '</strong>.<br />'
	cMsgEmail += 'Pe&ccedil;o que verifiquem.<br /><br />'
	cMsgEmail += 'No aguardo.</p>'
	U_ENVIAEMAIL("WSServiceOrder.asmx: Problemas comunica��o","hudson.santos@bgh.com.br; hudson_586@yahoo.com.br; uiran.almeida@bgh.com.br","",cMsgEmail,"")
EndIf
*/
MsgInfo(cGVS,"Teste")
RESET ENVIRONMENT
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TESTE001  �Autor  �Microsiga           � Data �  02/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Teste002()
Local cAux := "358460000046536"
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06"

dbSelectArea("ZZO")
ZZO->(dbSetOrder(1)) // ZZO_FILIAL, ZZO_IMEI, ZZO_CARCAC, ZZO_STATUS
ZZO->(dbSeek(xFilial("ZZO")+AvKey(cAux,"ZZO_IMEI")+AvKey(cAux,"ZZO_CARCAC")))
U_TECAX011("BGHTRIAG"+ZZO->ZZO_OPERA,ZZO->ZZO_NUMCX,.T.)
RESET ENVIRONMENT
Return

User Function HH9HH()
Local aNumber := {1,3,5,7,9,11,13,15}
Local aResult := {}
Local cMsg := ""
Local nA, nB, nC, nX, nCont := 0
For nA:= 1 to Len(aNumber)
	For nB:= 1 to Len(aNumber)
		For nC:= 1 to Len(aNumber)
			If (aNumber[nA] + aNumber[nB] + aNumber[nC]) = 31
				aAdd(aResult,{aNumber[nA], aNumber[nB], aNumber[nC]})
			EndIf
		Next nC
	Next nB
Next nA
For nX := 1 to Len(aResult)
	nCont ++
	cMsg += "["+StrZero(aResult[nX,1],2)+"]+"
	cMsg += "["+StrZero(aResult[nX,2],2)+"]+"
	cMsg += "["+StrZero(aResult[nX,3],2)+"]="
	cMsg += StrZero((aResult[nX,1]+aResult[nX,2]+aResult[nX,3]),2)
	If nCont >= 3
		nCont := 0
		cMsg += CHR(13) + CHR(10)
	Else
		cMsg += Space(5)
	EndIf
Next nX
If !Empty(cMsg)
	MsgInfo(cMsg,"Existe(m) "+Alltrim(Transform(Len(aResult),"@e 999999"))+" possibilidade.")
Else
	MsgInfo("N�o existem evidencias","Impossivel")
EndIf
Return