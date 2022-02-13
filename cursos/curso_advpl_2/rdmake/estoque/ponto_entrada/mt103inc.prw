#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch" 
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103INC  ºAutor ³Vinicius Leonardo º Data ³  09/04/12	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada responsavel por validar a NFE com a   	  º±±
±±º          ³ Entrada Massiva no momento da classificação da Pre-Nota    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT103INC()

	Local lRet := .T.
	Local nQtd := 0 
	Local nPrcUni := 0
	Local cNExist := ""
	Local aVerPos := {}	
	If !Upper(Funname()) $ "IPTXTGCOM" 
		If SF1->F1_TIPO == 'B'     
	
			If Select("SD1") == 0
				DbSelectArea("SD1")
			EndIf
			SD1->(DbSetOrder(1))	
			
			If Select("ZZ4") == 0
				DbSelectArea("ZZ4")
			EndIf
			ZZ4->(DbSetOrder(3))	
			
			SD1->(DbGoTop())	
			
			If SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			
				While SD1->(!EOF()) .and. ;
					SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA 
					
					ZZ4->(DbGoTop())    
				
					If ZZ4->(dbSeek(xFilial("ZZ4") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD ))
				
						// Varre o item do SD1 no ZZ4 abrangendo todos os IMEIs deste item
						While ZZ4->(!EOF()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFENR == SD1->D1_DOC .and. ZZ4->ZZ4_NFESER == SD1->D1_SERIE .and. ;
						       ZZ4->ZZ4_CODCLI == SD1->D1_FORNECE .and. ZZ4->ZZ4_LOJA == SD1->D1_LOJA .and. ZZ4->ZZ4_CODPRO == SD1->D1_COD						       
						       						
								nQtd := nQtd+1
								nPrcUni := nPrcUni + ZZ4->ZZ4_VLRUNI						
								
						        If aScan(aVerPos,{|x| x[1] == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD}) == 0 
						    		aAdd(aVerPos,{SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD,0,0,0,0,SD1->D1_COD})				    			
								EndIf
						       
						   	ZZ4->(dbSkip())
						   	
						EndDo 
						
						nPos := aScan(aVerPos,{|x| x[1] == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD}) 
						If nPos > 0 
							aVerPos[nPos][2] := aVerPos[nPos][2] + SD1->D1_QUANT 
							aVerPos[nPos][3] := nQtd  
							aVerPos[nPos][4] := aVerPos[nPos][4] + SD1->D1_TOTAL
							aVerPos[nPos][5] := nPrcUni
						EndIf
						nQtd := 0
						nPrcUni := 0
						
					Else  
						cNExist += Alltrim(aVerPos[nx][6]) + CRLF 										
					Endif						
				
					SD1->(DbSkip())
								
				EndDo			
			EndIf
		EndIf 
		
		If Len(aVerPos) > 0
		
			For nx:=1 To Len(aVerPos)
			
				If aVerPos[nx][2] <> aVerPos[nx][3]		
					MsgStop("Quantidade de Imeis do modelo " + Alltrim(aVerPos[nx][6]) + " informada na Entrada Massiva está diferente da NFE. Nao sera classificada." ;
					+ " Verifique e corrija a Entrada Massiva.","Quantidade Invalida","STOP")		
					lRet := .F.
					Exit
				ElseIf aVerPos[nx][4] <> aVerPos[nx][5]		
					MsgStop("Preco Unitario do modelo " + Alltrim(aVerPos[nx][6]) + " informado na Entrada Massiva está diferente da NFE. Nao sera classificada." ;
					+ " Verifique e corrija a Entrada Massiva.","Preço Unitario Invalido","STOP")		
					lRet := .F.
					Exit
				EndIf  
			
			Next nx	
		
		Else
		
			If !Empty(cNExist)		
				MsgBox("Entr. Massiva nao foi feita para esta NFE. " ;  
			    	+ "Nota será classificada. Lembre-se de informar a Entrada Massiva. " , ;  
			    	+ "E.Massiva não existente.","ALERT")		
			EndIf
			
		EndIf	 
    EndIf
Return lRet