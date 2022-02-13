#INCLUDE 'PROTHEUS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ OperSedexºAutor  ³Vinicius Leonardo  º Data ³  19/02/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada usado após a geração da NF de saída		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function OperSedex(aMassiva)

	Local aArea := GetArea()
	Local cCartPost	:= "" 
	Local cSedexCod := ""
	Local cESedexCod:= ""
	Local cTxtSedex := ""
	Local cCodAdm	:= ""
	Local cTpPost	:= ""
	Local _aEtiq    := {}
	Local lSedex	:= .T.
	Local aUF		:= {} 
	Local cEstado	:= ""
	Local lRet		:= .T.
	Local lImp		:= .T.
	Local cObjeto	:= ""
	Local lAtend	:= .F.
	Local nCont		:= 0
	Local lNoCep	:= .F.
	
	Private lProces := .F.
	Private nStack  := 0
	Private lMsg    := .F.
	Private cObj	:= "" 
	
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})
	
	If Select("SF2") == 0
		DbSelectArea("SF2")
	EndIf
	SF2->(DbSetOrder(2))	
	If Len(aMassiva) > 0
		For nCont:=1 To Len(aMassiva)	 
			SF2->(DbGoTop())			
			If SF2->(DbSeek(xFilial("SF2")+aMassiva[nCont][3]+aMassiva[nCont][4]+aMassiva[nCont][2]+aMassiva[nCont][1]))  
	
				If !lAtend
				
					If Select("SC6") == 0
						DbSelectArea("SC6")
					EndIf		
					SC6->(DbSetOrder(4))
					SC6->(DbGoTop())
					If SC6->(DbSeek(xFilial("SC6")+SF2->F2_DOC+SF2->F2_SERIE))
					
						If Select("SC5") == 0
							DbSelectArea("SC5")
						EndIf		
						SC5->(DbSetOrder(1))
						SC5->(DbGoTop())
						If SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM)) 
							If !Empty(SC5->C5_PVRET)
								lImp := .F.
							EndIf
						EndIf	
				        
						If lImp
						
							If Select("ZZ4") == 0
								DbSelectArea("ZZ4")
							EndIf			
							ZZ4->(DBOrderNickName('OSIMEI'))// ZZ4_FILIAL+ZZ4_OS+ZZ4_IMEI 
							ZZ4->(DbGoTop())
							If ZZ4->(DbSeek(xFilial("ZZ4")+AvKey(LEFT(SC6->C6_NUMOS,6),"ZZ4_OS")))
								
								If Posicione("ZZJ",1,xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH,"ZZJ_ETQSED") == "S" 															 								

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Operação chumbada temporariamente no programa até que se defina³
									//³a regra a ser parametrizada pelas partes envolvidas.           ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

									If ZZ4->ZZ4_OPEBGH $ 'S05,S06,S07,S08,S09'
									
										If !Empty(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_ENDENT"))
											cEstado := upper(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_ESTE"))
											If aScan(aUF,{|x| x[1] == Alltrim(cEstado)}) == 0
												apMsgInfo('O cadastro de cliente '+SF2->F2_CLIENTE+' está incorreto. O campo de estado está informado como ' +Alltrim(cEstado)+;
												'. A etiqueta não será impressa. Corrija o cadastro primeiro e utilize a rotina de IMPRESSÃO da etiqueta.','Cadastro Incorreto!')	
												lRet := .F.
											EndIf				
										Else
											cEstado := Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_EST")
										EndIf
										
									EndIf						 
								
									If lRet    
									    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Operação chumbada temporariamente no programa até que se defina³
										//³a regra a ser parametrizada pelas partes envolvidas.           ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If ZZ4->ZZ4_OPEBGH $ 'S05,S06,S07,S08,S09'										 
											If (Len(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_CGC")) > 11 .AND. cEstado == "SP" .and. ZZ4->ZZ4_OPEBGH == "S06")  
												lRet := .F.
											Endif										
										EndIf
										
										If lRet	
																				
											cCartPost  := Posicione("ZZJ",1,xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH,"ZZJ_CRPOST")
											cSedexCod  := Posicione("ZZJ",1,xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH,"ZZJ_TSECOD")
											cESedexCod := Posicione("ZZJ",1,xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH,"ZZJ_TESECD")
											cTxtSedex  := Posicione("ZZJ",1,xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH,"ZZJ_TXSED") 
											cCodAdm	   := Posicione("ZZJ",1,xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH,"ZZJ_CODADM")
											cTpPost	   := Posicione("ZZJ",1,xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH,"ZZJ_TPPOST")
											// 1-Sedex / 2- E-Sedex / 3- Pac / 4- Sedex/E-Sedex / 5 - Sedex/Pac / 6 - E-Sedex/Pac / 7 - Todos 
											
											If cTpPost $ "2,4,6,7"																			
												lSedex := U_SchCEP(Alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_CEP")))
											   	cObjeto:= U_GetObj(Iif(!lSedex,"DN","DM"),Alltrim(cCodAdm))											   											   	
										   	Else
										   		If cTpPost $ "1,5"										   	                                            
										   			cObjeto := U_GetObj("DN",Alltrim(cCodAdm))
										   			lNoCep	:= .T.
										   		Else
										   			If cTpPost $ "3"                                            
										   				cObjeto := U_GetObj("PI",Alltrim(cCodAdm))
										   				lNoCep	:= .T.
										   			EndIf
										   		EndIf			
										   	EndIf
										   	lProces := .F.
											nStack  := 0
											lMsg    := .F.
											cObj	:= ""							
																   	
										   	If !Empty(cObjeto) 
										   
												aadd(_aEtiq, { 	alltrim(cValtoChar(SF2->F2_VOLUME1))							,; //1.Volume. 			
																alltrim(U_Calcdigv(cObjeto))									,; //2.Objeto, usado tambem no código de barras
																alltrim(dtoc(dDataBase))										,; //3.Data da Postagem							
																alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_NOME"))	,; //4.Destinatario 
																alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_ENDENT")),; //5.Endereço do Destinatario
																alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_BAIRRO")),; //6.Bairro do Destinatario
																alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_CEP"))	,; //7.CEP do Destinatario, usado tambem no código de barras
																alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_MUN"))	,; //8.Cidade do Destinatario
																alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(SF2->F2_CLIENTE,"A1_COD")+AvKey(SF2->F2_LOJA,"A1_LOJA"),"A1_EST"))	,; //9.Estado do Destinatario
																alltrim(SM0->M0_NOMECOM)										,; //10.Remetente
																alltrim(SM0->M0_ENDENT)											,; //11.Endereço do Remetente
																alltrim(SM0->M0_BAIRENT)										,; //12.Bairro do Remetente
																alltrim(SM0->M0_CEPENT)											,; //13.CEP do Remetente, usado tambem no código de barras
																alltrim(SM0->M0_CIDENT)											,; //14.Cidade do Remetente
																alltrim(SM0->M0_ESTENT)											,; //15.Estado do Remetente							
																alltrim(SF2->F2_DOC)											,; //16.Numero do Documento
																alltrim(cValtoChar(SF2->F2_PBRUTO))								,; //17.Peso Bruto							
																Alltrim(cCartPost)												,; //18. Nr. do Cartao de Postagem							
																alltrim(cSedexCod)												,; //19. Codigo Chancela Sedex 						
																alltrim(cESedexCod)												,; //20. Codigo Chancela E-Sedex  
																alltrim(cTxtSedex)												,; //21. Texto Chancela  
																SF2->F2_SERIE                                                   ,; //22. Serie do Documento
																SF2->F2_EMISSAO                                                 ,; //23. Emissao do Documento
																SF2->F2_CLIENTE                                               	,; //24. Codigo do Cliente
																SF2->F2_LOJA													,; //25. Loja do Cliente 
																alltrim(cCodAdm)												}) //26. Codigo Administrativo        
																						 
												U_ImpEtiq01(_aEtiq,.T.,.F.,lNoCep)
												lAtend := .T.
												If RecLock("SF2",.F.)                                                
													SF2->F2_OBJETO := _aEtiq[1][2]                                   
													SF2->(MsUnlock())                                                
												EndIf 											                                                              
											Else
												apMsgInfo('Não foi possível imprimir etiqueta devido a controle de processamento. Para imprimir a etiqueta, utilize a rotina de IMPRESSÃO.','Controle de Processamento')	
											EndIf						
										EndIf
									EndIf						 
								EndIf								
							EndIf
						EndIf	
					EndIf
				Else
					If RecLock("SF2",.F.)                                                
						SF2->F2_OBJETO := _aEtiq[1][2]                                   
						SF2->(MsUnlock())                                                
					EndIf 	
				EndIf	
			EndIf		
		Next nCont
	EndIf	
	
	RestArea(aArea) 

Return	