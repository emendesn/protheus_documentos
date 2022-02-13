#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ mta410e  ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  09/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na exclusao do Pedido de Venda para       º±±
±±º          ³ cancelar a saida massiva e reabrir a entrada massiva       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function mta410e()

local _aAreaZZ4  := ZZ4->(GetArea())
local _aAreaSZ9  := SZ9->(GetArea())
local _aAreaAB7  := AB7->(GetArea())
local _nPosProd  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO" })
local _nPosItem  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM" })
local _nPosNrSer := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_NUMSERI" })
local _nPosNFOri := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_NFORI" })
local _nPosSerOr := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_SERIORI" })
local _nPostes  :=  aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_TES"})
local _nPosOS   :=  aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_OSGVS"})
Local _nPosLoc  :=  aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_LOCAL"})
local _niteori  :=  aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_ITEMORI"})
local _nposnos  :=  aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_NUMOS"})
local _ccodcli  := M->C5_CLIENTE
local _ccodloj  := M->C5_LOJACLI
Local _carmdist := GetMV("MV_ARMCAMP")
Local _cARMRPG  := GetMV("MV_XARMRPG")
Local _cTESRPG  := GetMV("MV_XTESRPG")

u_GerA0003(ProcName())


ZZ4->(dbSetOrder(3))  // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
SZ9->(dbSetOrder(3))  // Z9_FILIAL + Z9_PARTNR + Z9_PEDPECA
AB7->(DBOrderNickName('AB7NUMSER'))//AB7->(dbSetOrder(6))  // AB7_FILIAL + AB7_NUMOS + AB7_NUMSER

for x := 1 to len(aCols)
	
	If aCols[x,len(aHeader)+1]  .and. ;
		!empty(aCols[x,_nPosNrSer]) .and. ;
		ZZ4->(dbSeek(xFilial("ZZ4") + aCols[x,_nPosNFOri] + aCols[x,_nPosSerOr] + M->C5_CLIENTE + M->C5_LOJACLI + aCols[x,_nPosProd] + aCols[x,_nPosNrSer] )) .and. ;
		alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(M->C5_NUM)
		
		If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(M->C5_NUM)
			// Altera o Status da Entrada Massiva
			reclock("ZZ4",.f.)
			ZZ4->ZZ4_STATUS := '5'  // OS Encerrada
			ZZ4->ZZ4_PV     := ''
			ZZ4->ZZ4_SMDT   := ctod(" /  /  ")
			ZZ4->ZZ4_SMHR   := ''
			ZZ4->ZZ4_NFSNR  := ''
			ZZ4->ZZ4_NFSSER := ''
			ZZ4->ZZ4_NFSDT  := ctod(" /  /  ")
			ZZ4->ZZ4_NFSHR  := ''
			ZZ4->ZZ4_NFSCLI := ''
			ZZ4->ZZ4_NFSLOJ := ''
			ZZ4->ZZ4_NFSTES := ''
			ZZ4->ZZ4_SMUSER := ''
			msUnlock()
			
			
			if AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI))
				reclock("AB7",.f.)
				AB7->AB7_TIPO := "4"  // Atendido - necessario para permitir a nova saida massiva
				msunlock()
			endif
		Endif
		
		//Incluso essa condição para quando o usuário deletar a linha  do item - Edson Rodrigues - 13/04/10
	Elseif !Altera .and. !aCols[x,len(aHeader)+1]  .and. ;
		!empty(aCols[x,_nPosNrSer]) .and. ;
		ZZ4->(dbSeek(xFilial("ZZ4") + aCols[x,_nPosNFOri] + aCols[x,_nPosSerOr] + M->C5_CLIENTE + M->C5_LOJACLI + aCols[x,_nPosProd] + aCols[x,_nPosNrSer] )) .and. ;
		alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(M->C5_NUM) .AND. RIGHT(ALLTRIM(ZZ4->ZZ4_PV),2) == aCols[x,_nPosItem]
		
		If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(M->C5_NUM)
			// Altera o Status da Entrada Massiva
			reclock("ZZ4",.f.)
			ZZ4->ZZ4_STATUS := '5'  // OS Encerrada
			ZZ4->ZZ4_PV     := ''
			ZZ4->ZZ4_SMDT   := ctod(" /  /  ")
			ZZ4->ZZ4_SMHR   := ''
			ZZ4->ZZ4_NFSNR  := ''
			ZZ4->ZZ4_NFSSER := ''
			ZZ4->ZZ4_NFSDT  := ctod(" /  /  ")
			ZZ4->ZZ4_NFSHR  := ''
			ZZ4->ZZ4_NFSCLI := ''
			ZZ4->ZZ4_NFSLOJ := ''
			ZZ4->ZZ4_NFSTES := ''
			ZZ4->ZZ4_SMUSER := ''
			msUnlock()
			
			if AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI))
				reclock("AB7",.f.)
				AB7->AB7_TIPO := "4"  // Atendido - necessario para permitir a nova saida massiva
				msunlock()
			endif
		Endif
		
		
		//Incluso os dois "Else" Abaixo para comtemplar a situacao de o IMEI não estiver preenchido - Edson Rodrigues - 14/04/11
	Elseif  aCols[x,len(aHeader)+1]  .and. ;
		empty(aCols[x,_nPosNrSer]) .and. ;
		ZZ4->(dbSeek(xFilial("ZZ4") + aCols[x,_nPosNFOri] + aCols[x,_nPosSerOr] + M->C5_CLIENTE + M->C5_LOJACLI + aCols[x,_nPosProd] ))
		
		While !ZZ4->(eof()) .AND. ZZ4->ZZ4_NFENR == aCols[x,_nPosNFOri] .AND. ZZ4->ZZ4_NFESER == aCols[x,_nPosSerOr] .AND. ZZ4->ZZ4_CODCLI == M->C5_CLIENTE .and.  ZZ4->ZZ4_LOJA == M->C5_LOJACLI .AND. ZZ4->ZZ4_CODPRO == aCols[x,_nPosProd]
			
			IF  (alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(M->C5_NUM) .AND. RIGHT(ALLTRIM(ZZ4->ZZ4_PV),2) == aCols[x,_nPosItem])  .or. ;
				(alltrim(left(ZZ4->ZZ4_OS,6)) == alltrim(left(aCols[x,_nposnos],6)))
				
				If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(M->C5_NUM)
					// Altera o Status da Entrada Massiva
					reclock("ZZ4",.f.)
					ZZ4->ZZ4_STATUS := '5'  // OS Encerrada
					ZZ4->ZZ4_PV     := ''
					ZZ4->ZZ4_SMDT   := ctod(" /  /  ")
					ZZ4->ZZ4_SMHR   := ''
					ZZ4->ZZ4_NFSNR  := ''
					ZZ4->ZZ4_NFSSER := ''
					ZZ4->ZZ4_NFSDT  := ctod(" /  /  ")
					ZZ4->ZZ4_NFSHR  := ''
					ZZ4->ZZ4_NFSCLI := ''
					ZZ4->ZZ4_NFSLOJ := ''
					ZZ4->ZZ4_NFSTES := ''
					ZZ4->ZZ4_SMUSER := ''
					msUnlock()
					
					if AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI))
						reclock("AB7",.f.)
						AB7->AB7_TIPO := "4"  // Atendido - necessario para permitir a nova saida massiva
						msunlock()
					endif
				Endif
			ENDIF
			ZZ4->(dbSKIP())
		ENDDO
		
		
		
	Elseif !Altera .and. !aCols[x,len(aHeader)+1]  .and. ;
		empty(aCols[x,_nPosNrSer]) .and. ;
		ZZ4->(dbSeek(xFilial("ZZ4") + aCols[x,_nPosNFOri] + aCols[x,_nPosSerOr] + M->C5_CLIENTE + M->C5_LOJACLI + aCols[x,_nPosProd] ))
		
		While !ZZ4->(eof()) .AND. ZZ4->ZZ4_NFENR == aCols[x,_nPosNFOri] .AND. ZZ4->ZZ4_NFESER == aCols[x,_nPosSerOr] .AND. ZZ4->ZZ4_CODCLI == M->C5_CLIENTE .and.  ZZ4->ZZ4_LOJA == M->C5_LOJACLI .AND. ZZ4->ZZ4_CODPRO == aCols[x,_nPosProd]
			
			IF  (alltrim(left(ZZ4->ZZ4_OS,6)) == alltrim(left(aCols[x,_nposnos],6)))  .or. ;
				(alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(M->C5_NUM) .AND. RIGHT(ALLTRIM(ZZ4->ZZ4_PV),2) == aCols[x,_nPosItem])
				
				If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(M->C5_NUM)
					// Altera o Status da Entrada Massiva
					reclock("ZZ4",.f.)
					ZZ4->ZZ4_STATUS := '5'  // OS Encerrada
					ZZ4->ZZ4_PV     := ''
					ZZ4->ZZ4_SMDT   := ctod(" /  /  ")
					ZZ4->ZZ4_SMHR   := ''
					ZZ4->ZZ4_NFSNR  := ''
					ZZ4->ZZ4_NFSSER := ''
					ZZ4->ZZ4_NFSDT  := ctod(" /  /  ")
					ZZ4->ZZ4_NFSHR  := ''
					ZZ4->ZZ4_NFSCLI := ''
					ZZ4->ZZ4_NFSLOJ := ''
					ZZ4->ZZ4_NFSTES := ''
					ZZ4->ZZ4_SMUSER := ''
					msUnlock()
					
					if AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI))
						reclock("AB7",.f.)
						AB7->AB7_TIPO := "4"  // Atendido - necessario para permitir a nova saida massiva
						msunlock()
					endif
				Endif
			ENDIF
			
			ZZ4->(dbSKIP())
		ENDDO
		
	Else
		// Alterado para quando for exclusao de pedido em que o Cliente e loja  sejam diferentes da entrada massiva.
		ZZ4->(dbSetOrder(5))  // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_IMEI
		if  aCols[x,len(aHeader)+1]  .and. ;
			!empty(aCols[x,_nPosNrSer]) .and. ;
			ZZ4->(dbSeek(xFilial("ZZ4") + aCols[x,_nPosNFOri] + aCols[x,_nPosSerOr] + aCols[x,_nPosNrSer] )) .and. ;
			alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(M->C5_NUM)
			If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(M->C5_NUM)
				// Altera o Status da Entrada Massiva
				reclock("ZZ4",.f.)
				ZZ4->ZZ4_STATUS := '5'  // OS Encerrada
				ZZ4->ZZ4_PV     := ''
				ZZ4->ZZ4_SMDT   := ctod(" /  /  ")
				ZZ4->ZZ4_SMHR   := ''
				ZZ4->ZZ4_NFSNR  := ''
				ZZ4->ZZ4_NFSSER := ''
				ZZ4->ZZ4_NFSDT  := ctod(" /  /  ")
				ZZ4->ZZ4_NFSHR  := ''
				ZZ4->ZZ4_NFSCLI := ''
				ZZ4->ZZ4_NFSLOJ := ''
				ZZ4->ZZ4_NFSTES := ''
				ZZ4->ZZ4_SMUSER := ''
				msUnlock()
				
				if AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI))
					reclock("AB7",.f.)
					AB7->AB7_TIPO := "4"  // Atendido - necessario para permitir a nova saida massiva
					msunlock()
				Endif
			Endif
			//Incluso essa condição para quando o usuário deletar a linha do item - Edson Rodrigues - 13/04/10
		Elseif !Altera .and. !aCols[x,len(aHeader)+1]  .and. ;
			!empty(aCols[x,_nPosNrSer]) .and. ;
			ZZ4->(dbSeek(xFilial("ZZ4") + aCols[x,_nPosNFOri] + aCols[x,_nPosSerOr] + aCols[x,_nPosNrSer] )) .and. ;
			alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(M->C5_NUM)
			If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(M->C5_NUM)
				// Altera o Status da Entrada Massiva
				reclock("ZZ4",.f.)
				ZZ4->ZZ4_STATUS := '5'  // OS Encerrada
				ZZ4->ZZ4_PV     := ''
				ZZ4->ZZ4_SMDT   := ctod(" /  /  ")
				ZZ4->ZZ4_SMHR   := ''
				ZZ4->ZZ4_NFSNR  := ''
				ZZ4->ZZ4_NFSSER := ''
				ZZ4->ZZ4_NFSDT  := ctod(" /  /  ")
				ZZ4->ZZ4_NFSHR  := ''
				ZZ4->ZZ4_NFSCLI := ''
				ZZ4->ZZ4_NFSLOJ := ''
				ZZ4->ZZ4_NFSTES := ''
				ZZ4->ZZ4_SMUSER := ''
				msUnlock()
				
				if AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI))
					reclock("AB7",.f.)
					AB7->AB7_TIPO := "4"  // Atendido - necessario para permitir a nova saida massiva
					msunlock()
				Endif
			Endif
			
		Else
			// Incluso para quando for exclusao de pedido em que o Cliente e loja, Nf/item e serie origem  sejam diferentes da entrada massiva, tipo a operacao Sony Refurbish
			ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
			If aCols[x,len(aHeader)+1]  .and. ;
				!empty(aCols[x,_nPosNrSer]) .and. ;
				ZZ4->(dbSeek(xFilial("ZZ4") + aCols[x,_nPosNrSer] ))
				
				While !ZZ4->(eof()) .AND.  ZZ4->ZZ4_FILIAL=xFilial("ZZ4") .AND.  ZZ4->ZZ4_IMEI=aCols[x,_nPosNrSer]
					IF alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(M->C5_NUM) .AND. alltrim(SUBSTR(ZZ4->ZZ4_PV,7))==alltrim(aCols[x,_nPositem])
						If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(M->C5_NUM)
							// Altera o Status da Entrada Massiva
							reclock("ZZ4",.f.)
							ZZ4->ZZ4_STATUS := '5'  // OS Encerrada
							ZZ4->ZZ4_PV     := ''
							ZZ4->ZZ4_SMDT   := ctod(" /  /  ")
							ZZ4->ZZ4_SMHR   := ''
							ZZ4->ZZ4_NFSNR  := ''
							ZZ4->ZZ4_NFSSER := ''
							ZZ4->ZZ4_NFSDT  := ctod(" /  /  ")
							ZZ4->ZZ4_NFSHR  := ''
							ZZ4->ZZ4_NFSCLI := ''
							ZZ4->ZZ4_NFSLOJ := ''
							ZZ4->ZZ4_NFSTES := ''
							ZZ4->ZZ4_SMUSER := ''
							msUnlock()
							
							If AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI))
								reclock("AB7",.f.)
								AB7->AB7_TIPO := "4"  // Atendido - necessario para permitir a nova saida massiva
								msunlock()
							Endif
						Endif
					ENDIF
					ZZ4->(dbSKIP())
				ENDDO
				
				//Incluso essa condição para quando o usuário deletar a linha do item - Edson Rodrigues - 13/04/10
			Elseif !Altera .and. !aCols[x,len(aHeader)+1]  .and. ;
				!empty(aCols[x,_nPosNrSer]) .and. ;
				ZZ4->(dbSeek(xFilial("ZZ4") + aCols[x,_nPosNrSer] ))
				
				While !ZZ4->(eof()) .AND.  ZZ4->ZZ4_FILIAL=xFilial("ZZ4") .AND.  ZZ4->ZZ4_IMEI=aCols[x,_nPosNrSer]
					IF alltrim(left(ZZ4->ZZ4_PV,6)) == alltrim(M->C5_NUM) .AND. alltrim(SUBSTR(ZZ4->ZZ4_PV,7))==alltrim(aCols[x,_nPositem])
						If EMPTY(ZZ4->ZZ4_GVSARQ) .OR. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) <> ALLTRIM(M->C5_NUM)
							// Altera o Status da Entrada Massiva
							reclock("ZZ4",.f.)
							ZZ4->ZZ4_STATUS := '5'  // OS Encerrada
							ZZ4->ZZ4_PV     := ''
							ZZ4->ZZ4_SMDT   := ctod(" /  /  ")
							ZZ4->ZZ4_SMHR   := ''
							ZZ4->ZZ4_NFSNR  := ''
							ZZ4->ZZ4_NFSSER := ''
							ZZ4->ZZ4_NFSDT  := ctod(" /  /  ")
							ZZ4->ZZ4_NFSHR  := ''
							ZZ4->ZZ4_NFSCLI := ''
							ZZ4->ZZ4_NFSLOJ := ''
							ZZ4->ZZ4_NFSTES := ''
							ZZ4->ZZ4_SMUSER := ''
							msUnlock()
							
							If AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI))
								reclock("AB7",.f.)
								AB7->AB7_TIPO := "4"  // Atendido - necessario para permitir a nova saida massiva
								msunlock()
							Endif
						Endif
					ENDIF
					ZZ4->(dbSKIP())
				ENDDO
			Endif
		Endif
	Endif
	
	//CVAR:=IIF(MSGYESNO("Teste OK ?"),.t.,.f.)
	
	//Acrescentado esse IF para limpar o pedido do atendimento de peça quando houver necessidade de excluir o mesmo ou algum item do mesmo - Edson Rodrigues - 09/04/10
	cpartnr:=alltrim(aCols[x,_nPosProd])+space(25-len(alltrim(aCols[x,_nPosProd])))
	cpeditem:=alltrim(M->C5_NUM)+ alltrim(aCols[x,_nPositem])+space(9-len(alltrim(M->C5_NUM)+ alltrim(aCols[x,_nPositem])))
	
	If SZ9->(dbSeek(xFilial("SZ9") + cpartnr +  cpeditem))
	    /*
		While !SZ9->(eof())  .and.  SZ9->Z9_FILIAL=xFilial("SZ9") .AND. SZ9->Z9_PARTNR=cpartnr
			IF LEFT(SZ9->Z9_PEDPECA,6) == LEFT(cpeditem,6) .AND. alltrim(SUBSTR(SZ9->Z9_PEDPECA,7)) == alltrim(SUBSTR(cpeditem,7)) //.AND. !EMPTY(SZ9->Z9_PEDPECA)
				reclock("SZ9",.f.)
				SZ9->Z9_PEDPECA :=''
				msunlock()
			ENDIF
			SZ9->(DBSkip())
		Enddo
		*/
		cupdQry:=" UPDATE "+RETSQLNAME("SZ9")+ " SET Z9_PEDPECA='' "
		cupdQry+=" WHERE Z9_FILIAL='"+ xFilial("SZ9")+"' AND Z9_PARTNR='"+ALLTRIM( cpartnr)+"'  AND Z9_PEDPECA='"+ALLTRIM(cpeditem)+"' AND D_E_L_E_T_=''"
		TCSQLEXEC (cupdQry)
		TCRefresh(RETSQLNAME("SZ9"))
		
		
		
	Endif
	
	
	//Acrescentado esse para apagar o pedido  / data e hora de serviço da tabela de entrada massiva - Edson Rodrigues - 19/08/11
	If aCols[x,len(aHeader)+1]
		cpeditem:=alltrim(M->C5_NUM)+ alltrim(aCols[x,_nPositem])
		cpedido:=alltrim(M->C5_NUM)
		
		ZZ4->(dbSetOrder(10))  // ZZ4_FILIAL + ZZ4_PVSERV + ZZ4_DTPVSE
		ZZ4->(dbgotop())
		
		IF ZZ4->(dbSeek(xFilial("ZZ4") + cpeditem))
			cupdQry:=" UPDATE "+RETSQLNAME("ZZ4")+ " SET ZZ4_PVSERV='', ZZ4_DTPVSE='', ZZ4_HRPVSE=''
			cupdQry+=" WHERE ZZ4_FILIAL='"+ xFilial("ZZ4")+"' AND ZZ4_PVSERV='"+ALLTRIM(cpeditem)+"' AND D_E_L_E_T_=''"
			TCSQLEXEC (cupdQry)
			TCRefresh(RETSQLNAME("ZZ4"))
			
			cupdQry:=" UPDATE "+RETSQLNAME("SZN")+ " SET D_E_L_E_T_='*'
			cupdQry+=" WHERE ZN_FILIAL='"+ xFilial("SZN")+"' AND ZN_PEDVEND='"+ALLTRIM(cpedido)+"' AND D_E_L_E_T_=''"
			TCSQLEXEC (cupdQry)
			TCRefresh(RETSQLNAME("SZN"))
			
		Else
			
			ZZ4->(dbgotop())
			if ZZ4->(dbSeek(xFilial("ZZ4") + cpedido))
				cupdQry:=" UPDATE "+RETSQLNAME("ZZ4")+ " SET ZZ4_PVSERV='', ZZ4_DTPVSE='', ZZ4_HRPVSE=''
				cupdQry+=" WHERE ZZ4_FILIAL='"+ xFilial("ZZ4")+"' AND LEFT(ZZ4_PVSERV,6)='"+ALLTRIM(cpedido)+"' AND D_E_L_E_T_=''"
				TCSQLEXEC (cupdQry)
				TCRefresh(RETSQLNAME("ZZ4"))
						
			    cupdQry:=" UPDATE "+RETSQLNAME("SZN")+ " SET D_E_L_E_T_='*'
			    cupdQry+=" WHERE ZN_FILIAL='"+ xFilial("SZN")+"' AND ZN_PEDVEND='"+ALLTRIM(cpedido)+"' AND D_E_L_E_T_=''"
			    TCSQLEXEC (cupdQry)
			    TCRefresh(RETSQLNAME("SZN"))
			endif
		Endif
		
		
		//Acrescentado esse para apagar o pedido / data e hora de PECAS das tabelas de entrada massiva e ZZQ - Pedido x Peças - Edson Rodrigues - 19/08/11
		cpedido :=M->C5_NUM
		citem   :=aCols[x,_nPositem]
		
		ZZQ->(dbSetOrder(2))  // ZZQ_FILIAL + ZZQ_PV + ZZQ_ITEMPV + ZZQ_MODELO + ZZQ_NFSNR + ZZQ_NFSSER
		ZZQ->(dbgotop())
		IF ZZQ->(dbSeek(xFilial("ZZQ") + cpedido+citem))
			While !ZZQ->(eof())  .and.  ZZQ->ZZQ_FILIAL==xFilial("ZZQ") .AND. ZZQ->ZZQ_PV==cpedido .AND. ZZQ->ZZQ_ITEMPV==citem
				
				ZZ4->(dbSetOrder(9))  // ZZ4_FILIAL + ZZ4_PVPECA + ZZ4_IME + ZZ4_OS
				IF ZZ4->(dbSeek(xFilial("ZZ4") + ALLTRIM(ZZQ->ZZQ_PV) +SPACE(2)+ZZQ->ZZQ_IMEI + ZZQ->ZZQ_NUMOS ))
					Reclock("ZZ4",.F.)
					ZZ4->ZZ4_PVPECA :=''
					ZZ4->ZZ4_DTPPEC :=CTOD(' / / ')
					ZZ4->ZZ4_HRPPEC :=''
					msunlock()



				ELSE
					cupdQry:=" UPDATE "+RETSQLNAME("ZZ4")+ " SET ZZ4_PVPECA='', ZZ4_DTPPEC='', ZZ4_HRPPEC=''  "
					cupdQry+=" WHERE ZZ4_FILIAL='"+ xFilial("ZZ4")+"' AND ZZ4_PVPECA='"+ALLTRIM(cpedido)+"'  "
					cupdQry+=" AND ZZ4_IMEI='"+ZZQ->ZZQ_IMEI+"' AND ZZ4_OS='"+ZZQ->ZZQ_NUMOS+"' AND D_E_L_E_T_=''  AND ZZ4_CODPRO='"+ZZQ->ZZQ_MODELO+"' "
					TCSQLEXEC (cupdQry)
					TCRefresh(RETSQLNAME("ZZ4"))
					
				ENDIF
				
					Reclock("ZZQ",.F.)
        			    dbDelete()
		    		msunlock()

				ZZQ->(DBSkip())


			Enddo
		Endif
	Endif
	
	
	
	
	//Acrescentado esse IF para alterar o status da OS Nextel na tabela ZZL na exclusao do pedido - Edson Rodrigues - 08/07/10
	If aCols[x,_nPosLoc] $ alltrim(_cARMRPG)  .and. aCols[x,_nPostes]  $ alltrim(_cTESRPG)  .and. !empty(aCols[x,_nPosOS])
		Dbselectarea("ZZL")
		DbSetOrder(1) //ZZL_FILIAL, ZZL_DOC, ZZL_SERIE,ZZL_FORNEC,ZZL_LOJA,ZZL_ITEMD1,ZZL_FORMUL,ZZL_ITEGRD
		If ZZL->(dbSeek( xFilial("ZZL") + aCols[x,_nPosNFOri]+aCols[x,_nPosSerOr]+_ccodcli+_ccodloj+aCols[x,_niteori]))
			While ZZL->(!Eof()) .AND. xFilial("ZZL") == ZZL->ZZL_FILIAL .AND. ZZL->(ZZL_DOC+ZZL_SERIE+ZZL_FORNEC+ZZL_LOJA+ZZL_ITEMD1)==aCols[x,_nPosNFOri]+aCols[x,_nPosSerOr]+_ccodcli+_ccodloj+aCols[x,_niteori]
				IF ZZL->ZZL_STATUS = '3' .AND. !EMPTY(ZZL->ZZL_OSNEXT)
					reclock("ZZL",.f.)
					ZZL->ZZL_STATUS := '4'
					msunlock()
					exit
				ENDIF
				ZZL->(dbSkip())
			Enddo
		Else
			Dbselectarea("ZZL")
			DbSetOrder(2) //ZZL_FILIAL, ZZL_DOC, ZZL_SERIE,ZZL_ITEMD1,ZZL_CODPRO
			If ZZL->(dbSeek( xFilial("ZZL") + aCols[x,_nPosNFOri] + aCols[x,_nPosSerOr] + aCols[x,_niteori] + aCols[x,_nPosProd]))
				While ZZL->(!Eof()) .AND. xFilial("ZZL") == ZZL->ZZL_FILIAL .AND. ZZL->(ZZL_DOC+ZZL_SERIE+ZZL_ITEMD1+ZZL_CODPRO)==aCols[x,_nPosNFOri] + aCols[x,_nPosSerOr] + aCols[x,_niteori] + aCols[x,_nPosProd]
					IF ZZL->ZZL_STATUS = '3' .AND. !EMPTY(ZZL->ZZL_OSNEXT)
						reclock("ZZL",.f.)
						ZZL->ZZL_STATUS := '4'
						msunlock()
						exit
					ENDIF
					ZZL->(dbSkip())
				Enddo
			Endif
		Endif
	Endif
	
	if select("QRY1") > 0
		QRY1->(dbCloseArea())
	endif
	
	_cContSe := Posicione("SB1",1,xFilial("SB1")+aCols[x,_nPosProd],"B1_XCONTSE")
	If _cContSe == "S"
		
		_cQryAA3 := " SELECT "
		_cQryAA3 += " AA3_CODCLI, AA3_LOJA, AA3_CODPRO, AA3_NUMSER "
		_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock), "+RetSqlName("SB1")+" AS SB1 (nolock) "
		_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
		_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
		_cQryAA3 += " AND AA3_NUMPED='"+M->C5_NUM+"' "
		_cQryAA3 += " AND AA3_CODCLI='"+M->C5_CLIENTE+"' "
		_cQryAA3 += " AND AA3_LOJA='"+M->C5_LOJACLI+"' "
		_cQryAA3 += " AND AA3_CODPRO='"+aCols[x,_nPosProd]+"' "
		_cQryAA3 += " AND AA3_XCLASS='S' "
		_cQryAA3 += " AND SB1.D_E_L_E_T_ = '' "
		_cQryAA3 += " AND B1_FILIAL='"+xFilial("SB1")+"' "
		_cQryAA3 += " AND B1_COD=AA3_CODPRO "
		_cQryAA3 += " AND B1_XCONTSE='S' "
		
		_cQryAA3 := ChangeQuery(_cQryAA3)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRY1",.T.,.T.)
		
		QRY1->(dbGoTop())
		Do While QRY1->(!Eof())
			dbSelectArea("AA3")
			dbSetOrder(1)
			If dbSeek(xFilial("AA3")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
				RecLock("AA3",.F.)
				AA3->AA3_CODCLI := "191826"
				AA3->AA3_LOJA   := "01"
				AA3->AA3_NUMPED := ""
				MsUnLock()
			Endif
			dbSelectArea("QRY1")
			DbSkip()
		Enddo
		QRY1->(dbCloseArea())
	Endif
	
	aAreaAtu := GetArea()
	dbSelectArea("ZZ4")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZ4")+aCols[x,_nPosNrSer]+left(aCols[x,_nposnos],6))
		If !EMPTY(ZZ4->ZZ4_GVSARQ) .and. Alltrim(left(ZZ4->ZZ4_GVSARQ,6)) == ALLTRIM(M->C5_NUM)
			RecLock('ZZ4',.F.)
			ZZ4->ZZ4_GVSARQ   := ""
			MsUnLock('ZZ4')
		Endif
		
	Endif
	RestArea(aAreaAtu)
	
	
	
	
next x

//Limpa campo onde é gravado o pedido de saída para processos que não envolvem poder de terceiro (seguradoras)
//Vinicius Leonardo - Delta Decisão - 12/08/2015
cupdQry:=" UPDATE "+RETSQLNAME("ZZQ")+ " SET ZZQ_PVRESA = ''
cupdQry+=" WHERE ZZQ_FILIAL='"+ xFilial("ZZQ")+"' AND ZZQ_PVRESA='"+M->C5_NUM+"' AND D_E_L_E_T_ <> '*'"
TCSQLEXEC (cupdQry)
TCRefresh(RETSQLNAME("ZZQ"))

restarea(_aAreaZZ4)
restarea(_aAreaSZ9)
restarea(_aAreaAB7)

return()
