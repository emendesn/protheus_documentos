/**
 * Classe		:	WrdCartSony
 * Autor		:	Thomas Quintino Galvão
 * Data			:	10/08/2012	
 * Descricao	:   Rotina de Impressão da Carta Sony
 */
#Include "TopConn.ch"
#Include "Totvs.ch"
User Function WrdCarSony()
	Local cPerg		 := "ZZWRCSO"  
	Private cOS	     := ""
	Private cCliente := ""
    Private cProduto := ""
    Private cSerie	 := ""
    Private cDefRecl := ""
    Private cDefCons := ""
    Private cSolucao := ""
	Private waPartNum:= {}
	Private waPecas	 := {}
	Private cAcess	 := ""


u_GerA0003(ProcName())

	ValidPerg(cPerg)
	If !Pergunte(cPerg, .T.)
		Return
	EndIf
	
	&&Carrega dados para Impressão Word    
    Processa({|| LoadItens()},"Carregando Dados...")
    
    If !Empty(cOS)
    	PrintCartSony()
    Else 
		MsgAlert("Não há dados para esta OS!")	
	EndIf   
Return
    
/**
 * Rotina		:	PrintCartSony
 * Autor		:	Thomas Quintino Galvão
 * Data			:	10/08/2012
 * Uso			:	SIGAFAT
 * Descricao	:	Integração Word
 */  
Static Function PrintCartSony()
    Local nCont 	:= 0                       
    Local nK		:= 0
    Local cPathDot 	:= AllTrim(GetMv("MV_ZZCSONY"))      
    Local hWord
                           
    hWord	:= OLE_CreateLink()
	OLE_NewFile(hWord, cPathDot )		
		
	&&Montagem das variaveis do cabecalho
	OLE_SetDocumentVar(hWord, 'w_cOS'		, cOS	  )			    		
	OLE_SetDocumentVar(hWord, 'w_cCliente'	, cCliente)    
	OLE_SetDocumentVar(hWord, 'w_cDescri'	, cProduto)    
	OLE_SetDocumentVar(hWord, 'w_cNumSerie'	, AllTrim(cSerie))
	OLE_SetDocumentVar(hWord, 'w_cDefRecl'	, cDefRecl)    
	OLE_SetDocumentVar(hWord, 'w_cDefConst'	, cDefCons)    
	OLE_SetDocumentVar(hWord, 'w_cSolucao'	, cSolucao)    
	                                              
    &&Montagem das variaveis dos itens. No documento word estas variaveis serao criadas &&dinamicamente da seguinte forma:
	For nK := 1 to Len(waPecas)                                            
		OLE_SetDocumentVar(hWord,"w_partnum"   +AllTrim(Str(nK)),waPartNum[nK])
		OLE_SetDocumentVar(hWord,"w_pecatroc"  +AllTrim(Str(nK)),waPecas[nK])
		nCont ++
	Next nK	
	
	OLE_SetDocumentVar(hWord, 'w_cAcess' , IIf(!Empty(cAcess),'Acessórios: '+cAcess,""))
	
	OLE_SetDocumentVar(hWord, 'w_nropecas'	,nCont)
	OLE_ExecuteMacro(hWord,"pecastroc")  
	
	OLE_UpdateFields(hWord)	&& Atualizando as variaveis do documento do Word
	
    If MsgYesNo("Imprime o Documento ?")
	 	Ole_PrintFile(hWord,"ALL",,,1)
   	EndIf		
   	
    If MsgYesNo("Fechar Documento ?")
	   	OLE_CloseLink( hWord )
		OLE_CloseFile( hWord )                                  
	EndIf              
Return
/**
 * Rotina		:	LoadItens
 * Autor		:	Thomas Quintino Galvão
 * Data			:	10/08/2012
 * Uso			:	SIGAFAT
 * Descricao	:	Carrega Dados OS
 */  
Static Function LoadItens()
	Local cAlias := GetNextAlias()
	Local nCont	 := 0 
	Local lVld 	 := .F.
		
	BeginSql Alias cAlias
		Select Distinct
	   		ZZ4.ZZ4_OS 		OS,
			ZZ4_NFENR 		NFENTRADA,
			ZZ4_NFESER		NFESERIE,
			ZZ4_IMEI		IMEI,
	   		A1_NOME 		CLIENTE, 
	   		RTrim(SB1A.B1_DESC)+' - '+SB1A.B1_MODELO MODELO,
	   		ZZ4.ZZ4_IMEI 	SERIE, 
	   		SZ8A.Z8_DESSINT DEFINF,
	   		ZZ4.ZZ4_DEFDET 	DEFDET,  
	   		SZ8B.Z8_DESSINT DESSINT, 
	   		SZ9.Z9_PARTNR 	PARTNUM, 
	   		SB1B.B1_DESC 	PECATROC, 
	   		SZ8C.Z8_DESSOLU SOLUCAO	
		From %Table:ZZ4% ZZ4 (NOLOCK)		
			Inner Join %Table:SA1% SA1 (NOLOCK)
				On  A1_FILIAL 	= %xFilial:SA1%
				And A1_COD 	 	= ZZ4_CODCLI
				And SA1.%NotDel%				
			Inner Join %Table:SZ9% SZ9 (NOLOCK)
				On  ZZ4_FILIAL	= %xFilial:ZZ4%
				And ZZ4_IMEI	= Z9_IMEI
				And ZZ4_OS		= Z9_NUMOS
				And ZZ4.%NotDel%				
			Inner Join %Table:ZZ3% ZZ3  (NOLOCK)
				On  ZZ3_FILIAL	= %xFilial:ZZ3%
				And ZZ3_IMEI	= Z9_IMEI		
				And ZZ3_NUMOS	= Z9_NUMOS	 
				And ZZ3_SEQ		= Z9_SEQ		
				And ZZ3_ACAO	<> ' '	
				And ZZ3.%NotDel%		
			Inner Join (Select * From %Table:SB1% NOLOCK) SB1A 
				On  SB1A.B1_FILIAL	= %xFilial:SB1%
				And SB1A.B1_COD		= ZZ4_CODPRO
				And SB1A.%NotDel%					
			Inner Join (Select * From %Table:SB1% NOLOCK) SB1B 
				On  SB1B.B1_FILIAL	= %xFilial:SB1%
				And SB1B.B1_COD		= Z9_PARTNR	
				And SB1B.%NotDel%				
			Inner Join (Select * From %Table:SZ8% NOLOCK) SZ8A
				On  SZ8A.Z8_FILIAL 	= %xFilial:SZ8%
				And SZ8A.Z8_CODSINT = SUBSTRING(ZZ4_DEFINF,1,3)
				And SZ8A.%NotDel%				
			Inner Join (Select * From SZ8020 NOLOCK) SZ8B
				On  SZ8B.Z8_FILIAL 	= %xFilial:SZ8%
				And SZ8B.Z8_CODSINT = SUBSTRING(ZZ4_DEFDET,1,3)	
				And SZ8B.%NotDel%				
			Inner Join (Select * From SZ8020 NOLOCK) SZ8C
				On  SZ8C.Z8_FILIAL 	= %xFilial:SZ8%
				And SZ8C.Z8_CODSOLU = ZZ3_ACAO
				And SZ8C.%NotDel%				
		Where 
			ZZ4_FILIAL = %xFilial:ZZ4%
			And ZZ4_OS = %Exp:MV_PAR01%
			And ZZ4.%NotDel%
	EndSql
	
	cOS 	 := (cAlias)->OS	
	cCliente := (cAlias)->CLIENTE	
    cProduto := (cAlias)->MODELO
    cSerie   := cValToChar(Val((cAlias)->SERIE))
    cDefRecl := (cAlias)->DEFINF
    cDefCons := (cAlias)->DEFDET	
    cSolucao := (cAlias)->SOLUCAO
    
    DbSelectArea("SZC")
    SZC->(dbSetOrder(1))
    SZC->(dbSeek(xFilial("SZC")+(cAlias)->(NFENTRADA+NFESERIE)))
    
    Do While !SZC->(EoF()) .And. SZC->ZC_FILIAL == xFilial("SZC") .And. SZC->ZC_DOC == (cAlias)->NFENTRADA .And. SZC->ZC_SERIE == (cAlias)->NFESERIE
	    If lVld
			cAcess +=', ' 
		EndIf
		lVld := .T.
		cAcess += AllTrim(Posicione("SX5", 1, xFilial("SX5")+'Z5'+SZC->ZC_TPACESS, "X5_DESCRI"))
    	SZC->(DbSkip())  
    EndDo
    	  
	Do While !(cAlias)->(EoF())		
		ProcRegua(RecCount()) 
		nCont++
		aAdd( waPartNum ,AllTrim((cAlias)->PARTNUM ))		
		aAdd( waPecas	,AllTrim((cAlias)->PECATROC))		
		(cAlias)->(DbSkip())    
    EndDo
    (cAlias)->(dbCloseArea())
    
Return 
/**
 * Rotina		:	ValidPerg
 * Autor		:	Thomas Quintino Galvão
 * Data			:	10/08/2012	
 * Descricao	:	Cria Grupo de Perguntas
 */  
Static Function ValidPerg(cPerg)
	Local lRetorno := .T.                                                                                                                                                                                                          
	PutSx1(cPerg,"01","Nr. OS "	, "Nr. OS "	, "Nr. OS "	, "mv_ch1","C",08,0,0,"C","","","","","mv_par01")
Return lRetorno       