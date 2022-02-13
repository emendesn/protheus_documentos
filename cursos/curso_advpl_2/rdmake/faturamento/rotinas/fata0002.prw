#Include 'Totvs.ch'
#Define DS_MODALFRAME   128

/*
*Programa: FatA0002
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 04/10/12   
*Desc.   : Gatilho com Tela para Escolha de CEP  
Acrescentado opçao para trabalhar com o cadastro de forncedor. - Edson Rodrigues - 16/06/13.                     
*/
User Function FatA0002(_nopcao)
    Local _nopcao   := IIF(_nopcao == nil, 1 , _nopcao ) 
	Local aAreaZ07 	:= Z07->(GetArea())	
	Local aAreaCC2 	:= CC2->(GetArea())	
	Local lRet		:= .T.
	Local lRetQry	:= .T.
	Local aCeps		:= {}
	Local nI		:= 0
	Private cAlias 	:= GetNextAlias()    
	Private lInverte:= .F.	
	Private cMarca	:= GetMark() 
	Private cIndxtemp := "INDZ07" 

u_GerA0003(ProcName())
	
	SetPrvt("oDlg1","oGrp1","oBrw1")
	
	IF __cInternet != 'AUTOMATICO' 
	
		IF Select("TRBZ07") <> 0 
			DbSelectArea("TRBZ07")
			TRBZ07->(DBCLOSEAREA())
			FERASE(cIndxtemp+OrdBagExt())
		Endif	
		
		If Empty(iif(_nopcao==1,M->A1_CEP,M->A2_CEP)) 
			Return .F.
		EndIf
		
		lRetQry := QryLoad(@aCeps,_nopcao)	
		
		If !lRetQry
			Alert("Não Existe endereço para o CEP informado!")
		    IF _nopcao ==1 
			   M->A1_END 	 := ""
			   M->A1_BAIRRO  := ""
		       M->A1_EST     := ""
		       M->A1_MUN	 := ""
		       M->A1_COD_MUN := ""  
		    ELSE
		       M->A2_END 	 := ""
			   M->A2_BAIRRO  := ""
		       M->A2_EST     := ""
		       M->A2_MUN	 := ""
		       M->A2_COD_MUN := ""  
		    END   
		       
		       
		       
			Return .F.
		EndIf	
		
		DbSelectArea("CC2")
		CC2->(DbSetOrder(4)) //CC2_FILIAL+CC2_EST+CC2_MUN
		
		If Len(aCeps) > 1
			If !AliasTemp(aCeps,_nopcao)
				Return .F.
			EndIf
		Else	     
		
		   IF _nopcao ==1 
		     	M->A1_END 	 := aCeps[1,4]
			    M->A1_BAIRRO := aCeps[1,5]
			    M->A1_EST    := aCeps[1,2]
			    M->A1_MUN	 := aCeps[1,1]
			    If CC2->(DbSeek(xFilial('CC2')+M->A1_EST+M->A1_MUN))
				   M->A1_COD_MUN:= CC2->CC2_CODMUN
			    EndIf      
           ELSE
             	M->A2_END 	 := aCeps[1,4]
			    M->A2_BAIRRO := aCeps[1,5]
			    M->A2_EST    := aCeps[1,2]
			    M->A2_MUN	 := aCeps[1,1]
			    If CC2->(DbSeek(xFilial('CC2')+M->A2_EST+M->A2_MUN))
				   M->A2_COD_MUN:= CC2->CC2_CODMUN
			    EndIf      
           ENDIF			
		EndIf
	
		If CC2->(DbSeek(xFilial('CC2')+IIF(_nopcao ==1,M->A1_EST+M->A1_MUN,M->A2_EST+M->A2_MUN)))
			IF _nopcao == 1
			   M->A1_COD_MUN:= CC2->CC2_CODMUN
			ELSE
		       M->A2_COD_MUN:= CC2->CC2_CODMUN
			ENDIF   
			   
		Else         
		    IF _nopcao == 1
			    Alert("Codigo do Municipio não encontrado!")
			    M->A1_END 	 := ""
			    M->A1_BAIRRO := ""
			    M->A1_EST    := ""
			    M->A1_COD_MUN:= ""
			    M->A1_MUN	 := ""		
			    lRet:=.F. 
			ELSE
			 Alert("Codigo do Municipio não encontrado!")
			    M->A2_END 	 := ""
			    M->A2_BAIRRO := ""
			    M->A2_EST    := ""
			    M->A2_COD_MUN:= ""
			    M->A2_MUN	 := ""		
			    lRet:=.F. 
			ENDIF    
		EndIf
			
		(cAlias)->(dbCloseArea())
	EndIf
Return lRet 
/*
*Programa: QryLoad
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 04/10/12   
*Desc.   : Query Carrega todos os Municipios com o Cep informado
*/
Static Function QryLoad(aCeps,_nopcao)
	Local cCep 	:= IIF(_nopcao==1,M->A1_CEP,M->A2_CEP)
	Local lRet	:= .T.
	
	BeginSql Alias cAlias
		SELECT '.F.' EC7_BLOQ,* 
		FROM %Table:Z07% Z07 
		WHERE Z07_FILIAL = %xFilial:Z07%
		AND Z07_CEP = %Exp:cCep%
		AND Z07.%NotDel%
	EndSql
	
	aCeps := {}
	
	Do While !(cAlias)->(EoF())
	    aAdd(aCeps,{(cAlias)->Z07_MUNIC,;
	                (cAlias)->Z07_UF,;
	                (cAlias)->Z07_CEP,;
	    			AllTrim((cAlias)->Z07_TPLOGR)+' '+AllTrim((cAlias)->Z07_LOGRAD),;
	    			(cAlias)->Z07_BAIRRO})	
		(cAlias)->(dbSkip())
	EndDo	
	lRet := IIF(Len(aCeps) == 0, .F., .T.)
Return lRet  
/*
*Programa: AliasTemp
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 04/10/12   
*Desc.   : Rotina Cria Alias temporário e tela para seleção do Municipio
*/
Static Function AliasTemp(aCeps,_nopcao)
	Local cArqTrab 	:= ""
	Local aCampos	:= {}
	Local aCpos 	:= {}
    Local aStruTur	:= {}
    Local nX		:= 0
    
	aAdd( aStruTur, { "TRB_OK"   , "C", 2                      	, 0 } )
	aAdd( aStruTur, { "TRBMUNIC" , "C", TamSX3("Z07_MUNIC") [1]-20	, 0 } )
	aAdd( aStruTur, { "TRBUF"	 , "C", TamSX3("Z07_UF") [1]	, 0 } )
	aAdd( aStruTur, { "TRBLOGRAD", "C", TamSX3("Z07_LOGRAD") [1]-15, 0 } )
	aAdd( aStruTur, { "TRBBAIRRO", "C", TamSX3("Z07_BAIRRO") [1]-25, 0 } )
	aAdd( aStruTur, { "TRBCEP"	 , "C", TamSX3("Z07_CEP") [1]	, 0 } )
	cArqTrab := CriaTrab( aStruTur, .T. )
    
    FERASE(cIndxtemp+OrdBagExt())
	    
    dbUseArea( .T.,, cArqTrab, "TRBZ07", .F., .F. )
	cChave		:="TRBCEP+TRBMUNIC"  
	
	IndRegua("TRBZ07",cIndxTemp,cChave,,,"Buscando Titulos...") 
	dbClearIndex()
	dbSelectArea("TRBZ07")
	dbSetIndex(cIndxTemp+OrdBagExt())
	TRBZ07->(dbSetOrder(1))   
    
    aAdd( aCpos, { "TRB_OK"    	,, " "			,""})
	aAdd( aCpos, { "TRBMUNIC"	,, "Municipio"	,""})
	aAdd( aCpos, { "TRBUF" 		,, "UF"			,""})
	aAdd( aCpos, { "TRBLOGRAD"	,, "Logradouro"	,""})
	aAdd( aCpos, { "TRBBAIRRO"  ,, "Bairro"		,""})
	aAdd( aCpos, { "TRBCEP"		,, "CEP"		,""})
    
   	For nX:= 1 To Len(aCeps)
   		RecLock("TRBZ07",.T.)
   			TRBZ07->TRB_OK 		:= ThisMark()
   			TRBZ07->TRBMUNIC	:= aCeps[nX,1]
   			TRBZ07->TRBUF       := aCeps[nX,2]
  			TRBZ07->TRBLOGRAD	:= aCeps[nX,4]
   			TRBZ07->TRBBAIRRO	:= aCeps[nX,5]
   			TRBZ07->TRBCEP		:= aCeps[nX,3]
   		MsUnlock()
   	Next nX
   	TRBZ07->(dbGoTop())
   	
	//MSDialog():New( 095,232,490,1020,"Classificacao de Endereços",,,.F.,,,,,,.T.,,,.T. ) 
	Define MsDialog oDlg1 From 095,232 To 470,1220 Title "Classificacao de Endereços" Pixel Style DS_MODALFRAME // Cria Dialog sem o botão de Fechar.
		oGrp1      := TGroup():New( 005,005,185,490,"Classificacao de Endereços",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		DbSelectArea("TRBZ07")
		oBrW1     :=  MsSelect():New( "TRBZ07", "TRB_OK", , aCpos, @lInverte, @cMarca,{020,008,180,485},,, oGrp1 ) 
		oBrW1:oBrowse:lHasMark    := .t.
		oBrW1:oBrowse:lCanAllMark := .t.                                         
		oBrW1:oBrowse:bLDblClick  :={||MarkBox(oDlg1,oBrW1,_nopcao)}
		oBrW1:oBrowse:Refresh()    
	Activate Dialog oDlg1 Centered
Return .T.
/*
*Programa: MarkBox
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 04/10/12   
*Desc.   : Rotina Responsável pela marcação do Box
*/
Static Function MarkBox(oDlg1,oBrW1,_nopcao)
	Local nReg := TRBZ07->(Recno())
	RecLock("TRBZ07",.F.)
	TRBZ07->TRB_OK  := cMarca
	MsUnlock()
	
	if _nopcao == 1 
    	M->A1_END 	 := TRBZ07->TRBLOGRAD
      	M->A1_BAIRRO := TRBZ07->TRBBAIRRO
    	M->A1_EST    := TRBZ07->TRBUF
    	M->A1_MUN    := TRBZ07->TRBMUNIC
    else
        M->A2_END 	 := TRBZ07->TRBLOGRAD
      	M->A2_BAIRRO := TRBZ07->TRBBAIRRO
    	M->A2_EST    := TRBZ07->TRBUF
    	M->A2_MUN    := TRBZ07->TRBMUNIC    
    endif	
    	

	TRBZ07->(DBCLOSEAREA())
	odlg1:end()   
Return .T.