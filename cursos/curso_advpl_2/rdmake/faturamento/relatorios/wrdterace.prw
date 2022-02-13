/**
 * Classe		:	WrdTerAce
 * Autor		:	Thomas Quintino Galvão
 * Data			:	31/07/2012	
 * Descricao	:   Rotina de Impressão do Termo de Aceitação
 */
#include "rwmake.ch"
#include "TopConn.ch"
#Include "Totvs.ch"
User Function WrdTerAce(lPe, wcData,wcDoc,wcSerie,wcCliente,wcLoja)
	Local cPerg		 	:= "ZZWRTAC"
	Private lVPe	 	:= IIF(ValType(lPe)=="L", .T., .F.)
	Private waCliente	:= {}
	Private waNfServ 	:= {}
   	Private waCodPro 	:= {}
   	Private waQuant	 	:= {}
   	Private waVlGFGar	:= {}
   	Private waVlrPecas	:= {}
   	Private waVlrMo		:= {}
   	Private waTotal  	:= {}
	Private cAlias	 	:= GetNextAlias()
	Private nQuant	 	:= 0
	Private nTotal 		:= 0
	Private nTotPecas 	:= 0
	Private nTotMo 		:= 0
	Private dDataIni    := cToD(space(8))
	Private dDataFim 	:= cToD(space(8))    
	Private _dtaltfpc   :=CTOD('01/04/2014')
	Private _dDtSai     := cToD(space(8))    

u_GerA0003(ProcName())

	If lVPe
		LoadQuery(wcData,wcDoc,wcSerie,wcCliente,wcLoja)
		PrintWord()
	&&Rotina de Menú		
	Else
		ValidPerg(cPerg)
		Pergunte(cPerg, .T.)
		Processa({|| LoadQuery()},"Carregando dados....")
	EndIf
Return
/**
 * Rotina		:	CarItens
 * Autor		:	Thomas Quintino Galvão
 * Data			:	19/07/2012	
 * Uso			:	SIGAFAT
 * Descricao	:	Carrega Itens Faturados
 */  
Static Function LoadQuery(wcData,wcDoc,wcSerie,wcCliente,wcLoja)
   	Local lValid 	:= .F.
	Local cQuery	:= ""
	Local cWord  	:= ""
	Local cNfServ  	:= ""
	Local cWhere 	:= ""
	Local cWher2 	:= ""
	Local cCliente 	:= ""
    
	SF2->(dbSetOrder(1))
    
    &&.T. = &&Chamada via Ponto de Entrada
	If lVPe
		cWhere :=     "% ZZ4_NFSDT  >= '20120701' "		
		cWhere += "  And ZZ4_CODCLI = '"+wcCliente	+"' "
		cWhere += "  And ZZ4_LOJA   = '"+wcLoja		+"' "
		cWhere += "  And ZZ4_NFSERV = '"+wcDoc		+"' "
		cWhere += "  And ZZ4_NFSSSV = '"+wcSerie	+"'%"
			
	Else 
		cWhere :=     "% ZZ4_NFSDT  >= '20120701' "
//		cWhere += "  And ZZ4_CODCLI = '" + IIF(mv_par01 == 1, "000680","000016") +"' " 
		If mv_par01 == 1 // RJ
			cWhere += "  And ZZ4_CODCLI in ('000680','Z01EUO') "
		Else
			cWhere += "  And ZZ4_CODCLI in ('000016','Z01FY6') "
		EndIf
		cWhere += "  And ZZ4_LOJA   = '01' "
		cWhere += "  And ZZ4_NFSERV = '" + mv_par02 +"'" 
		cWhere += "  And ZZ4_NFSSSV = 'RPS' %"
	EndIf
	      
	
	    cWher2 := "% C6_NOTA='" + mv_par02 +"' AND C6_SERIE='RPS' %"
	
	#IFDEF TOP
	
	
//	SF2->(dbSeek(xFilial("SF2") + mv_par02 + 'RPS' +IIF(mv_par01 == 1, "000680","000016")+ "01"))
		If mv_par01 == 1 // RJ
			//F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
			If !(SF2->(dbSeek(xFilial("SF2") + mv_par02 + "RPS" + "000680" + "01")))
				SF2->(dbSeek(xFilial("SF2") + mv_par02 + "RPS" + "Z01EUO" + "01"))
			EndIf
		Else
			If !(SF2->(dbSeek(xFilial("SF2") + mv_par02 + "RPS" + "Z01FY6" + "01")))
				SF2->(dbSeek(xFilial("SF2") + mv_par02 + "RPS" + "000016" + "01"))
			EndIf
		EndIf
	_dDtSai := SF2->F2_EMISSAO
	
	IF _dDtSai >= _dtaltfpc	
		BeginSQL Alias cAlias
			Select GAR, OPERAC,ZZ4_CODCLI, ZZ4_NFSERV, MODELO, SUM(QUANT) QUANT, PRCUNIT, 
			       VLRPECAS=ISNULL(SUM(VLRPECAS),0) ,
 	               VLRMO=ISNULL(SUM(VLRMO),0),
 	               TOTAL=ISNULL(SUM(TOTAL),0) 
			From
				(
				Select  	
					ZZ4_CODCLI, ZZ4_LOJA, ZZ4_NFSERV, 
            	    ZZ4_NFSSSV, ZZ4_CODPRO  MODELO, 
		            ZZ4_NFSSER,  
		            CASE WHEN LEFT(C6_AEXPGVS,3)='GAF' THEN SUM(ZZP_VLRGAF)/COUNT(ZZ4_GARMCL) ELSE SUM(ZZP_VLRFOG)/COUNT(ZZ4_GARMCL) END  AS  PRCUNIT,
		            CASE WHEN LEFT(C6_AEXPGVS,3)='GAF' THEN 'S' ELSE 'N' END GAR,   
		            ZZP_OPERA AS OPERAC,
		            COUNT(ZZ4_GARMCL) QUANT, 
		            /*SUM(VLRTOTAL)/COUNT(ZZ4.ZZ4_GARMCL)*/ 0 AS VLRPECAS,
		            SUM(C6_PRCVEN) VLRMO,
		            CASE WHEN LEFT(C6_AEXPGVS,3)='GAF' THEN SUM(ZZP_VLRGAF) ELSE SUM(ZZP_VLRFOG) END AS TOTALZZP ,
		            /*(SUM(VLRTOTAL)/COUNT(ZZ4.ZZ4_GARMCL))*/ 0 +SUM(C6_PRCVEN)  AS TOTAL
				From %Table:ZZ4% ZZ4 (NoLock)
					Inner Join %Table:ZZP% ZZP (NoLock)
						On  ZZP_FILIAL		= %xFilial:ZZP%
						And ZZP_MODELO		= ZZ4_CODPRO
						And ZZP_OPERA		= ZZ4_OPEBGH			
						And ZZP.%NotDel% 
						And ZZ4.R_E_C_N_O_ > 3320000
					inner Join
	                (Select 
	                    C6_FILIAL,C6_NUM,C6_ITEM,C6_AEXPGVS,C6_QTDVEN,C6_PRCVEN,C6_VALOR 
	                  FROM %Table:SC6%  SC6 (Nolock)
                     Where C6_FILIAL=%xFilial:SC6% AND SC6.%NotDel% AND  %Exp:cWher2%
                    ) AS SC6
                    ON ZZ4_FILIAL=C6_FILIAL AND LEFT(ZZ4_PVSERV,6)=C6_NUM AND RIGHT(ZZ4_PVSERV,2)=C6_ITEM
                    
                    /*left outer Join
                    ( Select ZZQ_FILIAL,ZZQ_MODELO,SUM(ZZQ_QTDE) AS QTDE,SUM(ZZQ_VLRUNI) AS VLRUNIT,SUM(ZZQ_VLRTOT) VLRTOTAL  
                      FROM %Table:ZZQ%  ZZQ (Nolock)
                      Inner Join 
                      ( Select ZZ4_FILIAL AS FILIAL,ZZ4_OS AS OS,ZZ4_IMEI AS IMEI,ZZ4_PVPECA AS PVPECA,ZZ4_CODPRO AS CODPRO 
                        From %Table:ZZ4% ZZ41 (Nolock)
                        Where ZZ4_FILIAL = %xFilial:ZZ4%  And %Exp:cWhere% 	And ZZ41.%NotDel%
                      ) AS ZZ42
                      ON ZZQ_FILIAL=FILIAL AND ZZQ_NUMOS=OS AND ZZQ_IMEI=IMEI AND ZZQ_PV=PVPECA AND ZZQ_MODELO=CODPRO
                      WHERE  ZZQ_FILIAL = %xFilial:ZZQ%  AND ZZQ.%NotDel% 
                      GROUP BY ZZQ_FILIAL,ZZQ_MODELO
                    ) AS ZZQ
                    ON ZZ4_FILIAL=ZZQ_FILIAL AND ZZ4_CODPRO=ZZQ_MODELO	
                    */
				Where
				ZZ4_FILIAL = %xFilial:ZZ4%	
				And %Exp:cWhere%
				And ZZ4.%NotDel%
				Group By 
			 	ZZ4_CODCLI, ZZ4_LOJA, ZZ4_NFSERV, 
        	    ZZ4_NFSSSV, ZZ4_CODPRO, ZZ4_NFSSER,C6_AEXPGVS,ZZP_OPERA
             	)TMP
			Group By GAR,OPERAC, ZZ4_CODCLI, ZZ4_NFSERV, MODELO, PRCUNIT	
		EndSql		
	ELSE
     	BeginSQL Alias cAlias
			Select GAR, ZZ4_CODCLI, ZZ4_NFSERV, MODELO, SUM(QUANT) QUANT, PRCUNIT, SUM(VLRPECAS) VLRPECAS, SUM(VLRMO) VLRMO, SUM(TOTAL) TOTAL
			From
				(
				Select  	
					ZZ4_CODCLI, ZZ4_LOJA, ZZ4_NFSERV, 
					ZZ4_NFSSSV, ZZ4_CODPRO MODELO, 
					ZZ4_NFSSER,  
					CASE ZZ4_GARMCL WHEN 'N' THEN ZZP_VLRFOG ELSE ZZP_VLRGAF END PRCUNIT,
					CASE ZZP_VLRFOG WHEN ZZP_VLRGAF THEN 'S' ELSE 'N' END GAR,
					COUNT(ZZ4_GARMCL) QUANT, 
					SUM(ZZP_VLRFOG)*0.4 VLRPECAS,
					SUM(ZZP_VLRFOG)*0.6 VLRMO,
					SUM(ZZP_VLRFOG)TOTAL 
				From %Table:ZZ4% ZZ4 (NoLock)
					Inner Join %Table:ZZP% ZZP (NoLock)
						On  ZZP_FILIAL		= %xFilial:ZZP%
						And ZZP_MODELO		= ZZ4_CODPRO
						And ZZP_OPERA		= ZZ4_OPEBGH			
						And ZZP.%NotDel% 
						And ZZ4.R_E_C_N_O_ > 3320000
				Where
					ZZ4_FILIAL = %xFilial:ZZ4%	
					And %Exp:cWhere%
					And ZZ4.%NotDel%
				Group By 
			 		ZZ4_CODCLI, ZZ4_LOJA, ZZ4_NFSERV, 
			 		ZZ4_NFSSSV, ZZ4_CODPRO,ZZP_VLRGAF, 
			 		ZZ4_NFSSER, ZZP_VLRFOG,ZZ4_GARMCL 
			 	)TMP
			Group By GAR, ZZ4_CODCLI, ZZ4_NFSERV, MODELO, PRCUNIT	
		EndSql		
	
	ENDIF			
		lValid:= .F.
		cWord := ""
		nvalpec := 0.00 
		ntotlin := 0.00 
		
		Do While !(cAlias)->(EoF())		   
		   DbSelectArea(cAlias)
		   ProcRegua(RecCount())                          
		   nvalpec := 0.00 
	       ntotlin := 0.00
	       nposmod := 0   
	       nvclaim := 0.00
	       nvdesco := 0.00
	       nvlserv := 0.00         
	       
		   nvalpec :=iif(_dDtSai >= _dtaltfpc,LoadvlPec((cAlias)->ZZ4_NFSERV,(cAlias)->MODELO,(cAlias)->GAR,(cAlias)->OPERAC) ,(cAlias)->VLRPECAS)
		   nvclaim :=(cAlias)->QUANT * (cAlias)->PRCUNIT
		   ntotlin  += (cAlias)->VLRMO+nvalpec
		   nvdesco := nvclaim -  ntotlin
		   nvlserv := (cAlias)->VLRMO + nvdesco
           ntotlin += nvdesco
		   	
		   nposmod:=Ascan(waCodPro ,{|x| x == (cAlias)->MODELO }) 	
			
		   IF nposmod <= 0
			
			   	aAdd(waNfServ, 	(cAlias)->ZZ4_NFSERV)
		    	aAdd(waCodPro, 	(cAlias)->MODELO)
		    	//aAdd(waVlGFGar,	Transform((cAlias)->PRCUNIT,"@E 999,999,999.99"))
		    	//aAdd(waQuant , 	Transform((cAlias)->QUANT, "@E 999999.99"))	    
		    	//aAdd(waVlrPecas,Transform(nvalpec,"@E 999,999,999.99"))
		    	//aAdd(waVlrMo,	Transform((cAlias)->VLRMO,"@E 999,999,999.99"))	    	
		    	//aAdd(waTotal , 	Transform(ntotlin,"@E 999,999,999.99"))    
		    	
		    	aAdd(waVlGFGar,	(cAlias)->PRCUNIT)
		    	aAdd(waQuant , 	(cAlias)->QUANT)	    
		    	aAdd(waVlrPecas,nvalpec)
		    	aAdd(waVlrMo,	nvlserv)	    	
		    	aAdd(waTotal , 	ntotlin)
		   Else
                
                //waQuant[nposmod]   :=Transform((cAlias)->QUANT+val(strtran(waQuant[nposmod],'.','')), "@E 999999.99")
                //waVlrPecas[nposmod]:=Transform(nvalpec+val(strtran(waVlrPecas[nposmod],'.','')),"@E 999,999,999.99")   
                //waVlrMo[nposmod]   :=Transform((cAlias)->VLRMO+val(strtran(waVlrMo[nposmod],'.','')),"@E 999,999,999.99")
		        //waTotal[nposmod]   :=Transform(ntotlin+val(strtran(waTotal[nposmod],'.','')),"@E 999,999,999.99")
		       
		        waQuant[nposmod]   := (cAlias)->QUANT+waQuant[nposmod]
                waVlrPecas[nposmod]:= nvalpec+waVlrPecas[nposmod]   
                waVlrMo[nposmod]   := nvlserv+waVlrMo[nposmod]
		        waTotal[nposmod]   := ntotlin+waTotal[nposmod]
		     
		   Endif	
		   
		   nQuant 		+= (cAlias)->QUANT
		   nTotal 		+= ntotlin
		   nTotPecas 	+= nvalpec
		   nTotMo 		+= nvlserv	    	
		    	
		   If (cAlias)->ZZ4_NFSERV <> cWord
	   		    	cCliente := IIF(AllTrim((cAlias)->ZZ4_CODCLI) $ '000016/Z01FY6', GetMv("MV_ZZCL016"), GetMv("MV_ZZCL680"))
		    		cWord 	 := (cAlias)->ZZ4_NFSERV
		   EndIf    				
				(cAlias)->(DbSkip())    
		EndDo
	    
	   	FOR Y:=1  TO Len(waCodPro)
	   	
	   	   waQuant[Y]    :=Transform(waQuant[Y], "@E 999999.99")
           waVlrPecas[Y] :=Transform(waVlrPecas[Y],"@E 999,999,999.99")   
           waVlrMo[Y]    :=Transform(waVlrMo[Y],"@E 999,999,999.99")
		   waTotal[Y]    :=Transform(waTotal[Y],"@E 999,999,999.99")
		      
	   	NEXT
	   	
	   	
	   	
	   	If !Empty(cCliente) 
		      PrintWord(cWord,@nTotal,cCliente) 
		Else
		      MsgAlert('Não existe Registro para estes parametros!')
		EndIf
		(cAlias)->(dbCloseArea())
	#ENDIF
Return 

/**
 * Rotina		:	CarItens
 * Autor		:	Thomas Quintino Galvão
 * Data			:	19/07/2012	
 * Uso			:	SIGAFAT
 * Descricao	:	Carrega Itens Faturados
 */  
Static Function PrintWord(cNFServ, nTotal, cCliente) 
	Local cPathDot	:= AllTrim(GetMv("MV_ZZDIWRD")) &&"C:\Protheus_devel\Modelo_Word\Mod_Termo_Aceitacao.docm"
	Local hWord
    Local nK
    Local cNFPecas 	:= ""
    Local nValDesc 	:= 0
    Local nTotGeral	:= 0
    Local nContGar	:= 0
    Local nContFGar	:= 0
    
    hWord	:= OLE_CreateLink()
	OLE_NewFile(hWord, cPathDot )	
		
	&&Montagem das variaveis do cabecalho
	OLE_SetDocumentVar(hWord, 'w_remetente'	, cCliente)			    		
	OLE_SetDocumentVar(hWord, 'w_nfserv'	, cNFServ)			    		
	                                              
    &&Montagem das variaveis dos itens. No documento word estas variaveis serao criadas &&dinamicamente da seguinte forma:
	For nK := 1 to Len(waCodPro)
		OLE_SetDocumentVar(hWord,"w_codprogar"  +AllTrim(Str(nK)),'IND '+waCodPro[nK])
		OLE_SetDocumentVar(hWord,"w_vlrunigar"  +AllTrim(Str(nK)),waVlGFGar[nK])
		OLE_SetDocumentVar(hWord,"w_qntdegar"   +AllTrim(Str(nK)),waQuant[nK])
		OLE_SetDocumentVar(hWord,"w_vlrpecas"   +AllTrim(Str(nK)),waVlrPecas[nK])
		OLE_SetDocumentVar(hWord,"w_vlrmo"   	  +AllTrim(Str(nK)),waVlrMo[nK])
		OLE_SetDocumentVar(hWord,"w_prcungar"   +AllTrim(Str(nK)),waTotal[nK])
		nContGar ++
	Next nK	
	OLE_SetDocumentVar(hWord, 'w_nroitensgar'	,nContGar)
	OLE_ExecuteMacro(hWord,"itensgar"  )  
	
	cNFPecas := LoadNFPec(cNFServ)	
	OLE_SetDocumentVar(hWord, 'w_dtde'	 , DtoC(sToD(dDataIni)))			    		
	OLE_SetDocumentVar(hWord, 'w_dtate'  , DtoC(sToD(dDataFim)))
	OLE_SetDocumentVar(hWord, 'w_nfpecas', cNFPecas)
	OLE_SetDocumentVar(hWord, 'w_total'	 , AllTrim(Transform(nTotal,"@E 999,999,999.99")))	
	
	nValDesc := nQuant * GetMv("MV_ZZDESCO") &&49.75
	//OLE_SetDocumentVar(hWord, 'w_desconto'	, AllTrim(Transform(nValDesc,"@E 999,999,999.99")))
	
	nTotGeral :=  nTotal - nValDesc	
	OLE_SetDocumentVar(hWord, 'w_totgeral'	, AllTrim(Transform(nTotGeral,"@E 999,999,999.99")))	
	OLE_SetDocumentVar(hWord, 'w_qntapa'	, AllTrim(Transform(nQuant   ,"@E 999999.99")))	
	OLE_SetDocumentVar(hWord, 'w_totpecas'	, AllTrim(Transform(nTotPecas,"@E 999,999,999.99")))	
	OLE_SetDocumentVar(hWord, 'w_totmo'	, AllTrim(Transform(nTotMo   ,"@E 999,999,999.99")))	
	
	OLE_UpdateFields(hWord)	&& Atualizando as variaveis do documento do Word
	
    If MsgYesNo("Imprime o Documento ?")
	 	Ole_PrintFile(hWord,"ALL",,,1)
   	EndIf		
   	
    If MsgYesNo("Fechar Documento ?")
	   	OLE_CloseLink( hWord )
		OLE_CloseFile( hWord )                                  
	EndIf
   	
	waCliente	:= {}		
	waNfServ 	:= {}		
   	waCodPro 	:= {}		
   	waGouFGar	:= {}
   	waTotal  	:= {}
   	nTotal 	:= 0 
   	nTotPecas 	:= 0
	nTotMo 	:= 0
	nQuant 	:= 0                    
Return

/**
 * Rotina		:	LoadNFPec
 * Autor		:	Thomas Quintino Galvão
 * Data			:	30/07/2012	
 * Descricao	:	Cria Grupo de Perguntas
 */  
Static Function LoadNFPec(cNFServ)
	Local cAliasNFP := GetNextAlias()
	Local cNFPecas	:= ""
	Local cWhere	:= ""
	Local lVld		:= .F.

	If lVPe
		cWhere :=     "% ZZ4_NFSDT  >= '20120701' "		
		cWhere += "  And ZZ4_CODCLI = '"+wcCliente	+"' "
		cWhere += "  And ZZ4_LOJA   = '"+wcLoja		+"' "
		cWhere += "  And ZZ4_NFSERV = '"+cNFServ	+"' "
		cWhere += "  And ZZ4_NFSSSV = '"+wcSerie	+"' %"
	Else
		cWhere :=     "% ZZ4_NFSDT  >= '20120701' "
//		cWhere += "	 And ZZ4_CODCLI = '" + IIF(mv_par01 == 1, "000680","000016") +"' " 
		If mv_par01 == 1 // RJ
			cWhere += "  And ZZ4_CODCLI in ('000680','Z01EUO') "
		Else
			cWhere += "  And ZZ4_CODCLI in ('000016','Z01FY6') "
		EndIf
		cWhere += "  And ZZ4_LOJA   = '01' "
		cWhere += "  And ZZ4_NFSERV = '"+cNFServ	+"' "
		cWhere += "  And ZZ4_NFSSSV = 'RPS' %"
	EndIF
		
	BeginSQL Alias cAliasNFP
		Select Distinct 
			ZZ4_NFSNR, ZZ4_SMDT
		From %Table:ZZ4% ZZ4 (NoLock)
		Where
			ZZ4_FILIAL = %xFilial:ZZ4%	
			And %Exp:cWhere%
			And ZZ4.%NotDel%
		Order By ZZ4_NFSNR
	EndSql

	Do While !(cAliasNFP)->(EoF())
		If lVld
			cNFPecas +=' | '			
		Else
			dDataIni := (cAliasNFP)->ZZ4_SMDT
		EndIf
		dDataFim := (cAliasNFP)->ZZ4_SMDT
		lVld := .T. 
		cNFPecas += AllTrim((cAliasNFP)->ZZ4_NFSNR)
		
		(cAliasNFP)->(dbSkip())	
	End	
	(cAliasNFP)->(dbCloseArea())
Return cNFPecas


Static Function LoadvlPec(cNFServ,cmodelo,cgar,copera)
	Local cAliasvlP := GetNextAlias()
	Local nvalorpc	:= 0.00
	Local cWhere	:= ""
	Local lVld		:= .F.

	If lVPe
		cWhere :=     "% ZZ4_NFSDT  >= '20120701' "		
		cWhere += "  And ZZ4_CODCLI = '"+wcCliente	+"' "
		cWhere += "  And ZZ4_LOJA   = '"+wcLoja		+"' "
		cWhere += "  And ZZ4_NFSERV = '"+cNFServ	+"' "
		cWhere += "  And ZZ4_NFSSSV = '"+wcSerie	+"' "
		cWhere += "  And ZZ4_CODPRO = '"+cmodelo    +"' "
		cWhere += "  And ZZ4_GARMCL = '"+cgar+"' AND ZZ4_OPEBGH='"+copera+"'  %"
	Else
		cWhere :=     "% ZZ4_NFSDT  >= '20120701' "
//		cWhere += "	 And ZZ4_CODCLI = '" + IIF(mv_par01 == 1, "000680","000016") +"' " 
		If mv_par01 == 1 // RJ
			cWhere += "  And ZZ4_CODCLI in ('000680','Z01EUO') "
		Else
			cWhere += "  And ZZ4_CODCLI in ('000016','Z01FY6') "
		EndIf
		cWhere += "  And ZZ4_LOJA   = '01' "
		cWhere += "  And ZZ4_NFSERV = '"+cNFServ	+"' "
		cWhere += "  And ZZ4_NFSSSV = 'RPS' "
		cWhere += "  And ZZ4_CODPRO = '"+cmodelo    +"' "
		cWhere += "  And ZZ4_GARMCL = '"+cgar+"'  AND ZZ4_OPEBGH='"+copera+"'  %"
	EndIF
		
	BeginSQL Alias cAliasvlP
	   Select ZZQ_FILIAL,ZZQ_MODELO,SUM(ZZQ_QTDE) AS QTDE,SUM(ZZQ_VLRUNI) AS VLRUNIT,SUM(ZZQ_VLRTOT) VLRTOTAL  
          FROM %Table:ZZQ%  ZZQ (Nolock)
         Inner Join 
         ( Select ZZ4_FILIAL AS FILIAL,ZZ4_OS AS OS,ZZ4_IMEI AS IMEI,ZZ4_PVPECA AS PVPECA,ZZ4_CODPRO AS CODPRO 
             From %Table:ZZ4% ZZ41 (Nolock)
             Where ZZ4_FILIAL = %xFilial:ZZ4%  And %Exp:cWhere% 	And ZZ41.%NotDel%
          ) AS ZZ42
          ON ZZQ_FILIAL=FILIAL AND ZZQ_NUMOS=OS AND ZZQ_IMEI=IMEI AND ZZQ_PV=PVPECA AND ZZQ_MODELO=CODPRO
          WHERE  ZZQ_FILIAL = %xFilial:ZZQ%  AND ZZQ.%NotDel% 
          GROUP BY ZZQ_FILIAL,ZZQ_MODELO
         
	EndSql

	Do While !(cAliasvlP)->(EoF())
		nvalorpc := nvalorpc+(cAliasvlP)->VLRTOTAL
		(cAliasvlP)->(dbSkip())	
	End	
	(cAliasvlP)->(dbCloseArea())
Return nvalorpc





/**
 * Rotina		:	ValidPerg
 * Autor		:	Thomas Quintino Galvão
 * Data			:	23/07/2012	
 * Descricao	:	Cria Grupo de Perguntas
 */  
Static Function ValidPerg(cPerg)
	Local lRetorno := .T.                                                                                                                                                                                                          
	PutSx1(cPerg,"01","Cliente ?"	, "Cliente ?"	, "Cliente ?"	, "mv_ch1","N",01,0,0,"C","",""   ,"","","mv_par01","1=Rio de Janeiro","1=Rio de Janeiro","1=Rio de Janeiro","","2=São Paulo","2=São Paulo","2=São Paulo")
	PutSx1(cPerg,"02","Nota ?   "	, "Nota ?  "	, "Nota ?   "	, "mv_ch2","C",09,0,0,"G","","SF2","","","mv_par02")
Return lRetorno       