#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA261TOK บAutor  ณEduardo Barbosa     บ Data ณ  02/12/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E. Executado para confirmar a consistencia da transferencia Mod2 . Ex ( 01 s๓ pode ir para 1P...)      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
				If ApMsgYesNo('Usuario nใo autorizado para efetuar movimenta็ใo em Armazem de Processo! Possui senha de libera็ใo?','Movimenta็ใo')
					IF !u_VldSenha()
                    	_lRet := .F.
                    Endif					
				Else
					_lRet := .F.
				Endif
				If !_lRet
					Alert("Usuario nใo informado ou nใo autorizado! Favor verificar com o responsavel!")
				Endif
		    Endif
		Endif
	Endif
Next _nElem                  

   
Return _lRet

