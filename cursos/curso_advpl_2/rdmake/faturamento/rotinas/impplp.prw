#include "rwmake.ch"
#include "TopConn.ch"
#Include "Totvs.ch"  
#Include "Protheus.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpPLP()

Local aSay     := {}
Local aButton  := {}
Local nOpc     := 0
Local cTitulo  := "Lista de Postagem Correios"
Local cDesc1   := "Este programa tem como objetivo gerar a Lista de Postagem para os Correios"
Local cDesc2   := "e enviar a mํdia ao seu FTP."
Local cDesc3   := ""
Local cDesc4   := ""

Private cPerg  := "FATLSP"

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T.)   	}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()           	}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
EndIf

Processa( {|lEnd| U_ListPost( @lEnd , 5 ) }, "Aguarde.....", "Executando rotina.....", .T. )

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ListPost() 

	Local _cQuery	:= ""
	Local cPathDot	:= SuperGetMV("MV_XLPCORR",  ,"\\172.16.0.5\Microsiga\protheus_data\Modelo_Lista_Pos\Postagens_2007.dotx")	
	Local hWord    
    Local nCont		:= 0 
    Local ANF		:= {}
    Local _cEnter   := chr(13) + chr(10)
    Local cContrato := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par11,"A1_COD")+AvKey(mv_par12,"A1_LOJA"),"A1_CONTRT")
	Local cCodadm 	:= Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par11,"A1_COD")+AvKey(mv_par12,"A1_LOJA"),"A1_CODADM") 
    Local cCartPost := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par11,"A1_COD")+AvKey(mv_par12,"A1_LOJA"),"A1_CRTPOST")
	Local cSedexCod := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par11,"A1_COD")+AvKey(mv_par12,"A1_LOJA"),"A1_TSECOD") 
	Local cESedexCod:= Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par11,"A1_COD")+AvKey(mv_par12,"A1_LOJA"),"A1_TESECOD")
	Local cTxtSedex := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par11,"A1_COD")+AvKey(mv_par12,"A1_LOJA"),"A1_TXSED")
	Local cCliente  := Alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par11,"A1_COD")+AvKey(mv_par12,"A1_LOJA"),"A1_NREDUZ")) 
	Local cNumLista := SuperGetMV("BH_SEQPOST",  ,"001")
	Local lSedex	:= .T. 
	Local cTpPost	:= Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par11,"A1_COD")+AvKey(mv_par12,"A1_LOJA"),"A1_TPPOST")
	// 1-Sedex / 2- E-Sedex / 3- Pac / 4- Sedex/E-Sedex / 5 - Sedex/Pac / 6 - E-Sedex/Pac / 7 - Todos 
	    	
	_cQuery += _cEnter + " SELECT D2.*, "
	_cQuery += _cEnter + "        A1_NOME, "
	_cQuery += _cEnter + "        F2_VOLUME1, "	
	_cQuery += _cEnter + "        F2_PBRUTO, " 
	_cQuery += _cEnter + "        A1_DECVAL, "
	_cQuery += _cEnter + "        F2_VALBRUT, "
	_cQuery += _cEnter + "        Z03_OBJETO, "
	_cQuery += _cEnter + "        ENDER  = CASE WHEN A1_ENDENT = '' THEN A1_END    ELSE A1_ENDENT  END, "
	_cQuery += _cEnter + "        BAIRRO = CASE WHEN A1_ENDENT = '' THEN A1_BAIRRO ELSE A1_BAIRROE END, "
	_cQuery += _cEnter + "        CEP    = CASE WHEN A1_ENDENT = '' THEN A1_CEP    ELSE A1_CEPE    END, "
	_cQuery += _cEnter + "        MUNIC  = CASE WHEN A1_ENDENT = '' THEN A1_MUN    ELSE A1_MUNE    END, "
	_cQuery += _cEnter + "        EST    = CASE WHEN A1_ENDENT = '' THEN A1_EST    ELSE A1_ESTE    END  "
	_cQuery += _cEnter + " FROM   ( "
	_cQuery += _cEnter + " 	SELECT D2_DOC, D2_EMISSAO, D2_SERIE, COUNT(*) QTDITENS, D2_CLIENTE, D2_LOJA "
	_cQuery += _cEnter + " 	FROM   "+RetSqlName("SD2")+" AS D2 "
	_cQuery += _cEnter + " 	WHERE  D2.D_E_L_E_T_ = '' "
	_cQuery += _cEnter + " 	       AND D2_FILIAL = '"+xFilial("SD2")+"' "                    
	_cQuery += _cEnter + " 	       AND D2_DOC     BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	_cQuery += _cEnter + " 	       AND D2_SERIE   BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	_cQuery += _cEnter + " 	       AND D2_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' " 
	_cQuery += _cEnter + " 	       AND D2_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "  
	_cQuery += _cEnter + " 	       AND D2_LOJA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "	 
	_cQuery += _cEnter + " 	       AND D2_TIPO = 'N' "
	_cQuery += _cEnter + " 	GROUP BY D2_DOC, D2_EMISSAO, D2_SERIE, D2_CLIENTE, D2_LOJA "
	_cQuery += _cEnter + " 	) AS D2 "	
	_cQuery += _cEnter + " JOIN   "+RetSqlName("SF2")+" AS F2 "
	_cQuery += _cEnter + " ON     F2.F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE " 
	_cQuery += _cEnter + " AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2.D_E_L_E_T_ = '' "   
	
	If mv_par15 = 2
		_cQuery += _cEnter + " AND F2_NRROMA = '"+mv_par14+"'  "
	EndIf	                                                                                        
	
	_cQuery += _cEnter + " JOIN   "+RetSqlName("SA1")+" AS A1 "
	_cQuery += _cEnter + " ON     A1.A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_ = ''  " 
	_cQuery += _cEnter + " JOIN   "+RetSqlName("Z03")+" AS Z03 "
	_cQuery += _cEnter + " ON     Z03.Z03_FILIAL = '"+xFilial("Z03")+"' AND Z03_DOC = D2_DOC AND Z03_SERIE = D2_SERIE " 
	_cQuery += _cEnter + " AND Z03_DESTIN = D2_CLIENTE AND Z03_LOJDST = D2_LOJA AND Z03.D_E_L_E_T_ = ''  " 
	
	If mv_par15 = 1
		_cQuery += _cEnter + " AND Z03_IMPRE = 'S'
	Else
		_cQuery += _cEnter + " AND F2_OBJETO = Z03_OBJETO "	
	EndIf	
	
	_cQuery += _cEnter + " ORDER BY Z03_OBJETO, D2_SERIE, D2_DOC, D2_EMISSAO "

	memowrite('listpost.sql',_cQuery)
	_cQuery := strtran(_cQuery,_cEnter,"")
	
	// Fecha arquivo temporario caso ele esteja aberto
	if Select("TRB") > 0
		TRB->(dbCloseArea())
	endif
	
	// Cria ARQUIVO TEMPORARIO com o resultado da QUERY
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
	dbselectarea("TRB")
	TRB->(dbgotop())
	
	If TRB->(!eof()) 
	
		hWord	:= OLE_CreateLink()
		OLE_NewFile(hWord, cPathDot )
		
		OLE_SetDocumentVar(hWord, 'Dt_Emi'		,Dtoc(dDataBase))	 
		OLE_SetDocumentVar(hWord, 'Unid_Post'	,"00061937 - GCCAP/CTE JAGUARษ")
		OLE_SetDocumentVar(hWord, 'CEP_Post'	,"05314-969")
		OLE_SetDocumentVar(hWord, 'Dt_Post'		,Dtoc(dDataBase)) 
		OLE_SetDocumentVar(hWord, 'Cod_Admin'	,cCodadm) 
		OLE_SetDocumentVar(hWord, 'Contrato'	,cContrato)
		OLE_SetDocumentVar(hWord, 'Num_Lista'	,cNumLista)
		OLE_SetDocumentVar(hWord, 'Cliente'		,cCliente)
		  
		while TRB->(!eof())
							
			If cTpPost $ "2,4,6,7"																			
				lSedex := U_SchCEP(alltrim(TRB->CEP))
		   	Else
		   		lSedex := .F.		
		   	EndIf
		   				
			If mv_par13 == 1
			
				If !lSedex  				
			                            
					aADD(ANF,{"3",; 								//1. Tipo 3 - Lista de Postagem
					cContrato,;              						//2. N๚mero do Contrato
					cCodadm,;                						//3. C๓digo Administrativo
					alltrim(TRB->CEP),;         					//4. CEP do Destino
					"40444",;                   					//5. C๓digo do Servi็o (SFI)
					"00",;                      					//6. C๓d. Serv Adic. 1 Conforme Tab. Serv. Adic.
					Iif(TRB->A1_DECVAL=="S",TRB->F2_VALBRUT,0),;	//7. Valor Declarado
					alltrim(TRB->Z03_OBJETO),;  					//8. N๚mero da Etiqueta
					cCartPost,;             						//9. Nบ do cartใo de postagem
					alltrim(TRB->D2_DOC),;      					//10. N๚mero Nota Fiscal
					"DN",;                      					//11. Sigla do Servi็o
					Iif(TRB->A1_DECVAL=="S",TRB->F2_VALBRUT,0),;    //12. Valor a cobrar do destinatario
					alltrim(TRB->A1_NOME),;							//13. Nome do destinatแrio
					TRB->F2_VOLUME1,;           					//14. Volume
					TRB->F2_PBRUTO,;            					//15. Peso 
					TRB->A1_DECVAL,;            					//16. Declara valor?
					TRB->F2_VALBRUT})           					//17. Valor Bruto
					
				EndIf
			Else		
				If lSedex 
				
					aADD(ANF,{"3",; 								//1. Tipo 3 - Lista de Postagem
					cContrato,;              						//2. N๚mero do Contrato
					cCodadm,;                						//3. C๓digo Administrativo
					alltrim(TRB->CEP),;         					//4. CEP do Destino
					"81019",;                   					//5. C๓digo do Servi็o (SFI)
					"00",;                      					//6. C๓d. Serv Adic. 1 Conforme Tab. Serv. Adic.
					Iif(TRB->A1_DECVAL=="S",TRB->F2_VALBRUT,0),;    //7. Valor Declarado
					alltrim(TRB->Z03_OBJETO),;  					//8. N๚mero da Etiqueta
					cCartPost,;             						//9. Nบ do cartใo de postagem
					alltrim(TRB->D2_DOC),;      					//10. N๚mero Nota Fiscal
					"DM",;                      					//11. Sigla do Servi็o
					Iif(TRB->A1_DECVAL=="S",TRB->F2_VALBRUT,0),;    //12. Valor a cobrar do destinatario
					alltrim(TRB->A1_NOME),;							//13. Nome do destinatแrio
					TRB->F2_VOLUME1,;           					//14. Volume
					TRB->F2_PBRUTO,;            					//15. Peso
					TRB->A1_DECVAL,;            					//16. Declara valor? 			
				    TRB->F2_VALBRUT})           					//17. Valor Bruto
				
				EndIf
			EndIf			
			
			TRB->(dbSkip())	
		enddo	
		
		For nx:=1 To Len(ANF)
			
			&&Montagem das variaveis do cabecalho
			
			OLE_SetDocumentVar(hWord,;
			'NDestinatario'	+ AllTrim(cValToChar(nx)),;		
			"Destinatแrio:"+Space(30)+;
			"CEP destino: "+;
			ANF[nx][4]+Space(35)+;
			ANF[nx][13]+Space(42)+;
			"Deseja declarar valor?"+Space(1)+Iif(ANF[nx][16]=="S","Sim","Nใo")+;	
			"Valor declarado:"+Space(1)+Iif(ANF[nx][16]=="S",Alltrim(Transform(ANF[nx][17],"@E 99999.99" )),"")+;
			"Valor a cobrar do destinatแrio:"+Space(140)+Iif(ANF[nx][16]=="S",Alltrim(Transform(ANF[nx][17],"@E 99999.99" )),"")+;
			"Inf. compl.:")	
			
			OLE_SetDocumentVar(hWord,;
			'NNum_Obj'+ AllTrim(cValToChar(nx))	,;
			"N"+"บ"+"objeto: "+;
			Alltrim(ANF[nx][8])+Space(8)+;
			"N"+"บ"+"da N.F.: "+; 		
			Alltrim(ANF[nx][10])+Space(7)+;
			"Volume: "+cValToChar(ANF[nx][14])+Space(23)+;
			"Servi็o: "+Iif (mv_par13 == 1,"40444 SEDEX-CONTRATO","81019 E-SEDEX")+Space(100)+;
			"Peso tarifado(g):"+Space(35)+;
			"Servi็os Adicionais:"+Space(43)+;
			cValToChar(ANF[nx][15])+Space(140)+;
			"Valor a pagar:")
			
			nCont := nCont+1
		
		Next nx
		
		OLE_SetDocumentVar(hWord, 'cUsuari',Alltrim(cUserName))
		OLE_SetDocumentVar(hWord, 'cTotalizador',nCont)	
		OLE_SetDocumentVar(hWord, 'cCartPost',cCartPost)
		OLE_SetDocumentVar(hWord, 'cRemet',alltrim(SM0->M0_NOMECOM))
		OLE_SetDocumentVar(hWord, 'cEndRemet',alltrim(SM0->M0_ENDENT)+" "+alltrim(SM0->M0_BAIRENT)+" "+alltrim(SM0->M0_CIDENT)+" "+alltrim(SM0->M0_ESTENT))
		OLE_SetDocumentVar(hWord, 'Num_Pagina'	,"1 de "+ cValtoChar(round(nCont/11,0)+1))
			
		OLE_ExecuteMacro(hWord,"Objetos"  )
		
		OLE_UpdateFields(hWord)	// Atualizando as variaveis do documento do Word  
		
	    /*If MsgYesNo("Imprime o Documento ?")
		 	Ole_PrintFile(hWord,"ALL",,,1)
	   	EndIf*/		
	   	
	    If MsgYesNo("Fechar Documento ?")
		   	OLE_CloseLink( hWord )
			OLE_CloseFile( hWord )                                  
		EndIf
		
		//Atualiza Numero Sequencial da Lista
		If Select("SX6") == 0
			DbSelectArea("SX6")
		EndIf
		SX6->(DbSetOrder(1))
		If SX6->(DbSeek(xFilial("SX6")+"BH_SEQPOST")) 
			If RecLock("SX6",.F.)
				SX6->X6_CONTEUD:= Soma1(Alltrim(SX6->X6_CONTEUD))
				SX6->(MsUnlock())
			EndIf
		EndIf
		
		//If MsgYesNo("Deseja gerar arquivo a ser enviado ao FTP dos Correios ?")
			//cria arquivo e envia ao ftp dos correios
			u_GerTxtSedex(ANF)
		//EndIf
	Else
		Alert("Nใo hแ registros com as informa็๕es informadas nos parโmetros. Revise os parโmetros.")
	EndIf
	                   
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

PutSX1(cPerg,"01","Da Nota"     		,"Da Nota"     			,"Da Nota"     			,"mv_ch1" ,"C",09,0,0,"G","",""   		,"",,"mv_par01",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"02","Ate Nota"    		,"Ate Nota"    			,"Ate Nota"    			,"mv_ch2" ,"C",09,0,0,"G","",""   		,"",,"mv_par02",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"03","Da S้rie"    		,"Da S้rie"    			,"Da S้rie"    			,"mv_ch3" ,"C",03,0,0,"G","",""   		,"",,"mv_par03",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"04","Ate S้rie"   		,"Ate S้rie"   			,"Ate S้rie"   			,"mv_ch4" ,"C",03,0,0,"G","",""   		,"",,"mv_par04",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"05","Da Emissao"  		,"Da Emissao"  			,"Da Emissao"  			,"mv_ch5" ,"D",08,0,0,"G","",""   		,"",,"mv_par05",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"06","Ate Emissao" 		,"Ate Emissao" 			,"Ate Emissao" 			,"mv_ch6" ,"D",08,0,0,"G","",""   		,"",,"mv_par06",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"07","Do Destinatario"		,"Do Destinatario"		,"Do Destinatario"		,"mv_ch7" ,"C",06,0,0,"G","","SA1"		,"",,"mv_par07",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"08","Ate Destinatario" 	,"Ate Destinatario" 	,"Ate Destinatario" 	,"mv_ch8" ,"C",06,0,0,"G","","SA1"		,"",,"mv_par08",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"09","Da Loja Dest."  		,"Da Loja Dest."  		,"Da Loja Dest."  		,"mv_ch9" ,"C",02,0,0,"G","",""   		,"",,"mv_par09",""   	 ,"","","",""   	,"","","","","","","","","","","") 
PutSX1(cPerg,"10","Ate Loja Dest." 		,"Ate Loja Dest."    	,"Ate Loja Dest."   	,"mv_cha" ,"C",02,0,0,"G","",""   		,"",,"mv_par10",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"11","Cliente Operacใo"  	,"Cliente Operacใo"     ,"Cliente Operacใo"     ,"mv_chb" ,"C",06,0,0,"G","","A1CORR"	,"",,"mv_par11",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"12","Loja Cli.Opera็ใo"	,"Loja Cli.Opera็ใo"	,"Loja Cli.Opera็ใo"	,"mv_chc" ,"C",02,0,0,"G","",""   		,"",,"mv_par12",""   	 ,"","","",""   	,"","","","","","","","","","","")
PutSX1(cPerg,"13","Servi็o?"			,"Servi็o?"				,"Servi็o?"				,"mv_chd" ,"N",01,0,0,"C","",""   		,"",,"mv_par13","Sedex"	 ,"","","","e_Sedex","","","","","","","","","","","") 
PutSX1(cPerg,"14","Romaneio?"			,"Romaneio?"			,"Romaneio?"			,"mv_che" ,"C",06,0,0,"G","",""   		,"",,"mv_par14",""	 	 ,"","","",""		,"","","","","","","","","","","") 
PutSX1(cPerg,"15","Reenvio?"			,"Reenvio?"				,"Reenvio?"				,"mv_chf" ,"N",01,0,0,"C","",""   		,"",,"mv_par15","Sim"	 ,"","","","Nใo"	,"","","","","","","","","","","") 

Return()