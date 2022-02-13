#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A261TOK �Autor  �Eduardo Barbosa     � Data �  02/12/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. Executado para confirmar a consistencia da transferencia Mod2 . Ex ( 01 s� pode ir para 1P...)      ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT241TOK()

Local _lRet		  := .T.
local _nPosLOCOri		:= AScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOCAL"})
Local _cArmzPr  := GETMV("BH_ARMZPR",.F.,"15")//Armazem de Processo

Private cSenhAce := GETMV("BH_PLIBPR",.F.,"processo")//Armazem de Processo

u_GerA0003(ProcName())

For _nElem  := 1 To Len(aCols)
	
	cLocal   			:= aCols[_nElem,_nPosLocOri]
	If Alltrim(cLocal) $ _cArmzPr
		If !Upper(Funname()) $ "U_APONTACD" .and. !Upper(Funname()) $ "U_AXZZ3" .AND. !IsBlind() 
			lUsrAut  	:= .F.
			aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
			For i := 1 to Len(aGrupos)
				If AllTrim(GRPRetName(aGrupos[i])) $ "MOVPROC"
					lUsrAut  := .T.
				EndIf
			Next i
			If !lUsrAut 
				If ApMsgYesNo('Usuario n�o autorizado para efetuar movimenta��o em Armazem de Processo! Possui senha de libera��o?','Movimenta��o')
					IF !u_VldSenha()
                    	_lRet := .F.
                    Endif					
				Else
					_lRet := .F.
				Endif
				If !_lRet
					Alert("Usuario n�o informado ou n�o autorizado! Favor verificar com o responsavel!")
				Endif
		    Endif
		Endif
	Endif
Next _nElem                  

   
Return _lRet

