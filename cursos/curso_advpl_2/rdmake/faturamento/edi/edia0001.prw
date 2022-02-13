#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "RwMake.ch"

User Function EdiA0001()
	Private cCadastro 	:= "EDI - Movimentação"
	Private aCores    	:= {} 
	Private aRotina 	:= {}
	Private lUsrAut  	:= .T.
	Private lUsrAdm  	:= .T.
	Private lUsrEDI		:= .T.

u_GerA0003(ProcName())

	If lUsrEDI
		aRotina := {{"Pesquisar" 	,"AxPesqui"   	, 0, 1},;
					{"Visualizar"	,"AxVisual"   	, 0, 2},;
					{"Gera EDI"   	,"u_EdiA001A()"	, 0, 3},;
					{"Proc.Conhec" 	,"u_EdiA001D()"	, 0, 4},;
					{"Proc.Ocorr." 	,"u_EdiA001D()"	, 0, 4},;
					{"Fitr Romaneio","u_EdiA001C()"	, 0, 2},;
					{"Relatório"  	,"u_EdiA001D()"	, 0, 3},;
					{"Legenda"   	,"u_EdiA001B()"	, 0, 2}	}
	Else
		aRotina := {{"Pesquisar" 	,"AxPesqui"   	, 0, 1},;
					{"Visualizar"	,"AxVisual"   	, 0, 2},;
					{"Fitr Romaneio","u_EdiA001C()"	, 0, 2},;
					{"Legenda"   	,"u_EdiA001B()"	, 0, 2}	}
	EndIf

	aAdd(aCores, {"ZX_STATUS == '1' ", "BR_PRETO"  	})    		&& 1 - EDI Gerado, ainda sem Retorno 
	aAdd(aCores, {"ZX_STATUS == '2' ", "BR_AMARELO" })    		&& 2 - CTRC Recebido, produto em Transito
	aAdd(aCores, {"ZX_STATUS == '3' ", "BR_LARANJA"  })    		&& 3 - CTRC Recebido, com Ocorrencia 
	aAdd(aCores, {"ZX_STATUS == '4' ", "BR_AZUL"  })    		&& 4 - CTRC Pendente de Validacao
	aAdd(aCores, {"ZX_STATUS == '5' ", "BR_BRANCO"  })    		&& 5 - CTRC Bloqueio de Validacao 
	aAdd(aCores, {"ZX_STATUS == '6' ", "ENABLE"  })    	  		&& 6 - CTRC Liberado para Pre-Nota
	aAdd(aCores, {"ZX_STATUS == '7' ", "DISABLE"  })    		&& 7 - Pre-Nota Gerada
	
	dbSelectArea("SZX")
	dbSetOrder(1)

	mBrowse(6, 1, 22, 75, "SZX",,,,,, aCores)
Return


User Function EdiA001A() 
	Private cPerg	:= "EdiA0001" 
	Private nOpca	:= 0  
	
	ValidPerg(cPerg) && Ajusta as Perguntas do SX1
	Pergunte(cPerg,.F.) && Carrega as Perguntas do SX1

	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Gera EDI - NOTFIS") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Esta rotina ira gerar o arquivo de Remessa do EDI com base nos Romaneios") SIZE 268, 8 OF oDlg PIXEL
		@ 38, 15 SAY OemToAnsi("informados nos parametros. Sera gerado por esta rotina o arquivo padrao NOTFIS.") SIZE 268, 8 OF oDlg PIXEL
		@ 48, 15 SAY OemToAnsi("") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 196 TYPE 5 ACTION pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER

	If nOpca == 1
		MsAguarde({|| EDIGeral()},OemtoAnsi("Processando EDI - NOTFIS"))
	Endif 
Return


User Function EdiA001B()
	aCorDesc := {	{"BR_PRETO"     , "EDI Gerado, ainda sem Retorno"      	},;
					{"BR_AMARELO"	, "CTRC Recebido, produto em Transito" 	},;
					{"BR_LARANJA"	, "CTRC Recebido, com Ocorrencia"      	},;
					{"BR_AZUL"		, "CTRC Pendente de Validacao"     		},;
					{"BR_BRANCO"	, "CTRC Bloqueio de Validacao"     		},;
					{"ENABLE"		, "CTRC Liberado para Pre-Nota"     	},;										
					{"DISABLE"   	, "Pre-Nota Gerada"   					} }
	BrwLegenda(cCadastro, "Status", aCorDesc )
Return


User Function EdiA001C()
	Private oSelec
	Private nOpcao   := 0
	Private bOk      := {|| nOpcao := 1, oSelec:End()}
	Private bCancel  := {|| nOpcao := 0, oSelec:End()}
	
	aEscolha := {"EDI Gerado", "CTRC Recebido, em Transito", "CTRC com Ocorrencia","CTRC Pendente de Validacao","CTRC Bloqueio de Validacao" ,"CTRC Liberado Pre-Nota","Pre-Nota Gerada","Todos"}        
	
	nEscolha := 8
	
	DEFINE MSDIALOG oSelec TITLE "Filtros" FROM 001,001 TO 195,185 PIXEL
		@ 020,010 RADIO aEscolha VAR nEscolha
	ACTIVATE MSDIALOG oSelec ON INIT EnchoiceBar(oSelec, bOk, bCancel,,) CENTERED
	
	If nOpcao == 1
		If nEscolha == 1
			Set Filter to &(" @ ZX_STATUS == '1' ")
		ElseIf nEscolha == 2
			Set Filter to &(" @ ZX_STATUS == '2' ")
		ElseIf nEscolha == 3
			Set Filter to &(" @ ZX_STATUS == '3' ")
		ElseIf nEscolha == 4
			Set Filter to &(" @ ZX_STATUS == '4' ")
		ElseIf nEscolha == 5
			Set Filter to &(" @ ZX_STATUS == '5' ")
		ElseIf nEscolha == 6
			Set Filter to &(" @ ZX_STATUS == '6' ")
		ElseIf nEscolha == 7
			Set Filter to &(" @ ZX_STATUS == '7' ")
		ElseIf nEscolha == 8
			Set Filter to  
		Endif
	EndIf
	
	dbSelectArea("SZX")
	dbGoTop()

Return() 


User Function EdiA001D()
	MsgAlert("Rotina em Desenvolviemnto!")
Return

Static Function EDIGeral() 
	Local cQuery 	:= ""
	Local cDirDocs	:= __reldir            
	Local cCrLf		:= Chr(13)+Chr(10) 
	Local cSrvApl  	:= AllTrim(GetMV("MV_SERVAPL"))
	Local nSeq		:= 0 
	Local aAreaSF2 	:= SF2->(GetArea())
	Local aAreaSZX 	:= SZX->(GetArea())
	Local lRet		:= .T.
	Local lSXZ		:= .F.
	Local nOpc		:= 0
	
	If empty(MV_PAR01)
		MsgAlert("O Numero do Romaneio Deve ser Informado. Verifique!","Atencao")
		return(.F.)
	Endif
	/*
	//Conforme solicitação do Jeova, retirado a data do romaneio
	//pois é possivel ter o mesmo romaneio em mais de uma data
	If empty(MV_PAR02)
		MsgAlert("A data do Romaneio Deve ser Informada. Verifique!","Atencao")
		return(.F.)
	EndIf	
	*/
	
	IF Select("TRB1") <> 0 
		DbSelectArea("TRB1")
		DbCloseArea()
	Endif   
	
	&& Monta Query
	cQuery := " SELECT * FROM " + RetSqlName("SF2") + " SF2 "
	cQuery += " WHERE "
 	cQuery += " 	NOT EXISTS ( SELECT 1 FROM " + RetSqlName("SZX") + " SZX " 
 	cQuery += " 				 WHERE (ZX_FILIAL+ZX_ROMAN+ZX_SERIE+ZX_NOTA = F2_FILIAL+F2_NRROMA+F2_SERIE+RIGHT(F2_DOC,8) )  "
 	cQuery += " 				 AND SZX.D_E_L_E_T_ <> '*'  ) "
	cQuery += " AND F2_NRROMA IN " + FormatIn(alltrim(MV_PAR01),";") + " "
	//cQuery += " AND SF2.F2_DTROMA = '"+dtos(MV_PAR02)+"' " //Retirado conforme solicitação do Jeova
	cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY F2_CLIENTE, F2_LOJA, F2_TRANSP, F2_NRROMA "
	
	TCQUERY cQuery NEW ALIAS "TRB1"  
	
	If TRB1->(EOF())
		lSXZ := .T.    
		TRB1->(dbCloseArea())
		 
		&& Monta Query
		cQuery := " SELECT * FROM " + RetSqlName("SF2") + " SF2 "
		cQuery += " WHERE "
	 	cQuery += " F2_NRROMA IN " + FormatIn(alltrim(MV_PAR01),";") + " "
		//cQuery += " AND SF2.F2_DTROMA = '"+dtos(MV_PAR02)+"' " //Retirado conforme solicitação do Jeova
		cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
		cQuery += " ORDER BY F2_CLIENTE, F2_LOJA, F2_TRANSP, F2_NRROMA "
		
		TCQUERY cQuery NEW ALIAS "TRB1" 

		If TRB1->(EOF())
			TRB1->(dbCloseArea()) 
			Aviso("EDI Não Gerado", "EDI não gerado, verifique os Parâmetros Informados? ",{"OK"})	
	        Return .F.
		Else
			nOpc := Aviso("EDI Não Gerado", "Este EDI já foi gerado, deseja gerar novamente? ",{"Sim", "Não"})	
   			If nOpc == 2	   			
	   			TRB1->(dbCloseArea())	
	   			Return .F.
	   		EndIf                                                                                   
	  	EndIf   		
	EndIf 	
	
	&& Verifica se Arquivo esta Vazio
	nTotsRec := TRB1->(RECCOUNT())  	  
	TRB1->(dbgotop())	
	
	Do Case
		Case AllTrim(TRB1->F2_TRANSP) == '02'  &&Andreani
			u_EdiAndriane(@nSeq, lSXZ,.F.)			 
		Case AllTrim(TRB1->F2_TRANSP) == '44'  &&TotalExpress
			u_EdiTotExp(lSXZ) 
		//Vinicius - Delta Decisão - Incluido mais este Case, para o tratamento com o transportadora UNIEXPRESS - GLPI 17975	
		Case AllTrim(TRB1->F2_TRANSP) == '024'  &&UNIEXPRESS
			u_EdiAndriane(@nSeq, lSXZ,.T.)	
		&&Case AllTrim(TRB1->F2_TRANSP) == '05'  &&Correios
		  &&	u_EdiCorreios()
		
		OtherWise 	
			MsgAlert("Não Existe Edi para a Transportadora deste Romaneio!")
	EndCase            
	
	DbClosearea("TRB1")
	SF2->(RestArea(aAreaSF2))
	SZX->(RestArea(aAreaSZX))
Return

Static Function ValidPerg(cPerg)
	PutSX1(cPerg,"01","Romaneio       ?","","","mv_ch1","C",06,0,0,"G","","   ","","","mv_par01")
	PutSX1(cPerg,"02","Data Romaneio  ?","","","mv_ch2","D",08,0,0,"G","","   ","","","mv_par02")
Return