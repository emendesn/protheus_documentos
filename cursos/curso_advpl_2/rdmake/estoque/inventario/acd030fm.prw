#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ACD030FM   ºAutor  ³Wilker Marçal       º Data ³  15/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para o Mestre de Inventario, carrega primeira Cont. º±±
±±º          ³ Com o saldo em estoque por endereço                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACD030FM()

Local aArea := GetArea()
Private cCodOpe  	:=CBRetOpe()
If MV_PAR05 >= 2 // nao entra no PE com  contagem menor que 2 contagens
	
	If MsgYesno("Processa Inventario com a " +"*PRIMEIRA*"+" Contagem Igual ao Saldo em Estoque?")
		
		dbSelectArea("SBE")
		SBE->(dbSetOrder(1))
		SBE->(dbSeek(xFilial("SBE")+MV_PAR01,.T.))
		While !Eof() .and. xFilial("SBE") == SBE->BE_FILIAL .and. SBE->BE_LOCAL <= MV_PAR02
			
			If !(SBE->BE_LOCALIZ >= MV_PAR03 .and. SBE->BE_LOCALIZ <= MV_PAR04)
				SBE->(dbSkip())
				Loop
			EndIf
			
			CBA->(dbSetOrder(2)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_LOCALI+CBA_DATA
			If  CBA->(dbSeek(xFilial("CBA")+"2"+"0"+SBE->BE_LOCAL+SBE->BE_LOCALIZ+DTOS(MV_PAR06)))
				If CBA->CBA_CONTS >=2
					Begin Transaction
					RecLock("CBA",.F.)
					CBA->CBA_STATUS := "3"   // em andamento
					CBA->CBA_CONTR  :=  1    // Primeira contagem
					CBA->CBA_ANALIS := "2"   // divergente
					MsUnlock()
					
					//GRAVAR CBB
					Reclock("CBB",.T.)
					CBB->CBB_FILIAL := xFilial("CBB")
					CBB->CBB_NUM    := CBProxCod('MV_USUINV')
					CBB->CBB_CODINV := CBA->CBA_CODINV
					CBB->CBB_USU    := cCodOpe
					CBB->CBB_STATUS := "2"
					CBB->(MsUnlock())
					
					/// grava CBC com a primeira contagem
					dbSelectArea("SBF")
					SBF->(dbSetOrder(1))
					SBF->(dbSeek(xFilial("SBF")+SBE->BE_LOCAL+SBE->BE_LOCALIZ,.T.))
					While !Eof() .and. xFilial("SBF")== SBF->BF_FILIAL .and.  SBE->BE_LOCAL == SBF->BF_LOCAL .AND. SBE->BE_LOCALIZ == SBF->BF_LOCALIZ
												
						_nSalBF := SaldoSBF(SBF->BF_LOCAL, SBF->BF_LOCALIZ, Left(SBF->BF_PRODUTO,15), NIL, SBF->BF_LOTECTL, NIL, .F.)
												
						Reclock("CBC",.T.)
						CBC->CBC_FILIAL := xFilial("CBC")
						CBC->CBC_NUM    := CBB->CBB_NUM
						CBC->CBC_COD    := SBF->BF_PRODUTO
						CBC->CBC_LOCAL  := SBF->BF_LOCAL
						CBC->CBC_QUANT  := _nSalBF
						CBC->CBC_LOCALIZ:= SBF->BF_LOCALIZ
						CBC->CBC_LOTECT := SBF->BF_LOTECTL
						CBC->CBC_CODINV := CBA->CBA_CODINV
						CBC->CBC_QTDORI := _nSalBF
						CBC->(MsUnlock())
						
						SBF->(dbSkip())
					EndDo
					End Transaction
				Endif
			EndIf
			
			SBE->(dbSkip())
		EndDo
		
		
	endif
endif
RestArea(aArea)
Return
