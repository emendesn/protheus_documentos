#include 'rwmake.ch'
#include "Protheus.Ch"
/*
���Programa  �TpAcess �Autor  �Edson Rodrigues       � Data �  08/09/10   ���
���Desc.     �Abre tela com os acessorios a selecionar                    ���

���Obs.      �Modificado por Thomas Galv�o Data 10/07/2012 				  ���
���Obs.      �Inclus�o de V�rios Acess�rios de uma s� vez  GLPI - ID 6773 ���
*/
User Function TpAcess(_actacess, _codaces, _cdescr)
	Local cVar      := Nil
	Local cTitulo   := "Tipo de Acess�rio"
	Local oDlg      := Nil
	Local oOk       := LoadBitmap( GetResources(), "LBOK" )
	Local oNo       := LoadBitmap( GetResources(), "LBNO" )
	Local lMark     := .F.
	Local _aAreaSX5 := SX5->(GetArea())
	
	Private oLbx   := Nil
	Private aVetor := {}
	Private _nOpcx := 0

u_GerA0003(ProcName())
	
	&& Carrega o vetor conforme a condicao |
	SZC->(dbSetOrder(1))&&ZC_FILIAL + ZC_DOC + ZC_SERIE + ZC_FORNECE + ZC_LOJA + ZC_CODPRO + ZC_ITEMNFE + ZC_ACESS
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5") + "Z5"))
	Do While SX5->(!eof()) .and. alltrim(SX5->X5_TABELA) == 'Z5'
		aAdd( aVetor, { lMark, SX5->X5_CHAVE, SX5->X5_DESCRI, 0 })
		SX5->(dbSkip())
	Enddo
	
	&& Monta a tela para usuario visualizar consulta |
	If Len( aVetor ) == 0
		Aviso( cTitulo, "Nao existem acess�rios a consultar", {"Ok"} )
		Return
	EndIf
	
	If Empty(_cdescr)
		&&Verifica se Item j� havia sido marcado antes e j� retorna marcado
		If Len(_actacess) > 0
			For nT := 1 To Len(_actacess)
				For nX := 1 To Len(aVetor)
					If  aVetor[nX,2] == _actacess[nT,1]
						aVetor[nX,1] := .T. 
				    	aVetor[nX,4] := 1
				    EndIf
				Next		
			Next nT 
		EndIf
	EndIf
		
	Define MsDialog oDlg Title cTitulo From 0,0 TO 240,500 Pixel
		@ 10,10 ListBox oLbx Var cVar Fields HEADER " ", "Codigo", "Acessorio","Quantidade" Size 230,095 Of oDlg Pixel On dblClick(@aVetor[oLbx:nAt,1] :=desmarc(oLbx:nAt,@aVetor,_codaces, _cdescr),oLbx:Refresh())
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {IIf(aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4]}}
		Define SButton From 107,173 Type 2 Action (_nOpcx:=0,oDlg:End()) Enable Of oDlg  && Cancelar
		Define SButton From 107,213 Type 1 Action (_nOpcx:=1,IIf(marcou(@aVetor),oDlg:End(),ODlg)) Enable Of oDlg  && OK
	Activate MsDialog oDlg Center
		
	RestArea(_aAreaSX5)

Return _actacess

/*
���Programa  � Desmarca  �Autor  � Edson Rodrigues   � Data �  08/09/10   ���
���Desc.     � desmarca os acessorios ja marcados caso seja marcado outro ���
*/
Static Function desmarc(n,aVetor,_codaces, _cdescr)
	local lret		:=!aVetor[n,1]
	Local nPos		:= 0 
		
	aVetor[n,1] := !aVetor[n][1]
	
	&&Desmarcado
	If !aVetor[n][1]
		aVetor[n][4] := 0
		If Len(_actacess) > 0
			nPos := aScan(_actacess,{|x| AllTrim(x[1]) == aVetor[n][2]})
			If nPos > 0
				ADel(_actacess, nPos )
				ASize(_actacess, Len(_actacess)-1 )
			EndIf
		EndIf

	&&Marcado
	Else
		&&Confere se j� foi inclu�do para n�o duplicar 
		If Len(_actacess) > 0
			nPos := aScan(_actacess,{|x| AllTrim(x[1]) == aVetor[n][2]})
			If nPos > 0
				aVetor[n,1] := .F.
				oLbx:Refresh()
				MsgAlert("Acess�rio j� incluso!")
				Return .F.
			EndIf
		EndIf
		aVetor[n][4] := 1 
		
		If !Empty(_cdescr)
			aadd(_actacess,{aVetor[n,2],_cdescr	, _codaces	})
		Else
			aadd(_actacess,{aVetor[n,2],Nil		, Nil		})
		EndIf
	EndIf
	oLbx:Refresh()
Return lret

/*
���Programa  � marcou   �Autor  � Edson Rodrigues    � Data �  11/11/10   ���
���Desc.     � VerIfica se marcous acessorios qdo confirma com OK         ���
*/
Static Function marcou(aVetor)
	Local lret:=.f.
	
	If len(aVetor) > 0
		For i:=1 to len( aVetor)
			If aVetor[i,1]
				lret:=.t.
			EndIf
		Next i
	EndIf
	
	If !lret
		MsgBox("Favor escolher o tipo de acessorio !","Tipo de acessorio nao selecionado","ALERT")
	EndIf

Return lret