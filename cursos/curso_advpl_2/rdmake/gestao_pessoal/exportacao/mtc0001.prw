#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTC003   ºAutor  ³Maintech-Roberto Marques º Data ³26/07/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O Calendário de Turnos gera as cargas horárias previstas   º±±
±±º          ³ de acordo com as regras impostas no cadastro de turnos.	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


	User Function MTC003()

		/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±± Declaração de Variaveis Private dos Objetos                             ±±
		Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
		Local cSql :=""
		SetPrvt("oDlg1","oGrp","oList1","oGrp1","oSair","oGerar","oDet")
		Private aCaixas := {}

u_GerA0003(ProcName())


		If Select( "TMP" ) > 0
			TMP->( dbCloseArea() )
		EndIf
        
    	
		cSql := " Select ZA1_TURNO,Count(ZA1_HRTOTA)DIA_UTIL ,SUM(ZA1_HRTOTA)ZA1_HRTOTA " 
		cSql += " From "+RetSQLName("ZA1") 
		cSql += " WHERE ZA1_FILIAL='"+xFilial("ZA1")+"' AND D_E_L_E_T_<> '*' AND ZA1_HRTOTA > 0"
		cSql += " GROUP BY ZA1_TURNO "
		
                                                                             

       
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cSQL), "TMP", .F., .T. )
		dbSelectArea("TMP")
		TMP->(dbGoTop())
	    
	    aCaixas := {}
	        
		While TMP->(!Eof())
			aAdd(aCaixas,{TMP->ZA1_TURNO,Transform(TMP->DIA_UTIL, "@E 999"),Transform(TMP->ZA1_HRTOTA, "@E 999.99")})
			TMP->(DbSkip())
		EndDo
		
		If Len(aCaixas) == 0
			aCaixas := {{"","",""}}
		EndIf
		
		/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±± Definicao do Dialog e todos os seus componentes.                        ±±
		Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
		oDlg1      := MSDialog():New( 091,232,545,630	,"Calendario de Turnos"			,,,.F.,,,,,,.T.,,,.T. )
		oGrp       := 	TGroup():New( 004,004,188,195	,"Totais de Horas dos Turnos" 	, oDlg1 ,CLR_BLACK , CLR_WHITE ,.T.,.F. )
		@ 016,008 LISTBOX oList1 FIELDS HEADER "Turno","Total Dias","Total Horas" COLSIZES 60,60,60 SIZE 180,164 OF oGrp PIXEL  
		oList1:SetArray(aCaixas)
		oList1:bLine   := {||{aCaixas[oList1:nAt,1],aCaixas[oList1:nAt,2],aCaixas[oList1:nAt,3]}} 
		oList1:aArray := {}
		oList1:Refresh()
		oList1:aArray := aClone(aCaixas)
		oList1:Refresh()
		
		oGrp1      := TGroup():New( 192,004,216,195,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
		oGerar     := TButton():New( 200,010,"Gerar Calend   16-15"		,oGrp1	,{||Processa({||MTC002(1,1)},"Processando...")},065,012,,,,.T.,,"",,,,.F. )
		oDet       := TButton():New( 200,080,"Gerar Cal.Bene 01-30" 	,oGrp1	,{||Processa({||MTC002(1,2)},"Processando...")},065,012,,,,.T.,,"",,,,.F. )
		oSair      := TButton():New( 200,150,"Sair"						,oGrp1	,{||oDlg1:End()							   },040,012,,,,.T.,,"",,,,.F. )

		oDlg1:Activate(,,,.T.)
		

	Return
  
	// - Cadastro do Calendario
	Static Function RoZA1()
		AxCadastro("ZA1","Calendario de Turno")    
	Return
	
	// - Geraçao do Calendario
	User Function GeraTurn()
		Local cPerg 	:= "MTC001"
		ValidPerg(cPerg)
		
		If Pergunte(cPerg,.t.)
			Processa({||MTC002(2,1)},"Processando...")
		Endif

	Return()

    Static Function MTC002(nTP,nBene)
    	Local mSQL := ""
    	Local vSeq    
    	//---->    Limpa o Calendario de Turnos    <----//
		mSql := "Delete From "+ RetSQLName("ZA1") 
		mSql +=	" Where ZA1_FILIAL ='" + xFilial("ZA1") + "' "  
		IF nTP == 2
			mSql += " AND ZA1_TURNO >='"+ MV_PAR01  +"' AND ZA1_TURNO <='" + MV_PAR02 + "'"
		ENDIF
		TcSQLExec( mSql ) 
		TcSQLExec( 'COMMIT' )
		
		
		
		mSql := " SELECT R6_TURNO "
		mSql +=	" FROM " + RetSqlName("SR6")   
		mSql += " WHERE D_E_L_E_T_ <> '*'  AND "                              
		mSql += " R6_FILIAL ='" + xFilial("SR6") + "' " 
		
		IF nTP == 2
			mSql += "AND R6_TURNO >='" + MV_PAR01  + "' " 
			mSql += "AND R6_TURNO <='" + MV_PAR02  + "' " 
		Endif
		
		TCQUERY mSQL NEW ALIAS "TSR6"
	
		DBSELECTAREA("TSR6")     
		TSR6->(DBGOTOP())   
		DO WHILE !TSR6->(EOF())
        	
 			IF Select("TSPF") <> 0 
				DbSelectArea("TSPF")
				TSPF->(DbCloseArea())
			Endif
				   
			mSql := " SELECT MAX(PF_DATA)PF_DATA,PF_TURNODE,PF_SEQUEDE,PF_TURNOPA,PF_SEQUEPA " 
			mSql +=	" FROM " + RetSqlName("SPF")      
			mSql += " WHERE D_E_L_E_T_ <> '*' " 
			mSql += " AND PF_FILIAL ='" + xFilial("SPF") + "' "
			mSql += " AND PF_TURNOPA ='" + TSR6->R6_TURNO  + "' "
			mSQL += " AND PF_TURNODE=PF_TURNOPA "
			mSQL += " GROUP BY PF_TURNODE,PF_SEQUEDE,PF_TURNOPA,PF_SEQUEPA "
			mSQL += " ORDER BY PF_TURNODE,PF_SEQUEDE,PF_DATA DESC "
				
			TCQUERY mSql NEW ALIAS "TSPF"
		
			DBSELECTAREA("TSPF")     
			TSPF->(DBGOTOP())   
			IF !TSPF->(EOF())
				vSeq   := TSPF->PF_SEQUEPA
			Endif
				
		
  			MTC001(TSR6->R6_TURNO,vSeq,nBene)
                
        TSR6->( DbSkip() )
		EndDo
	
		TSR6->( DbCloseArea() )
		 
		Alert("Calendario de Turnos Processados com sucesso.")       
		MontaGrid()
			 	
   	Return


	Static Function MTC001(vTurno,cSeqPa,nBene)   
		Local nDia		:=0
		Local nDat		:=0
		Local nC
		Local cDt 
		Local nuteis 	:= 0         
		Local ntothoras := 0 
	    Local cRet
	 	Local dDataRef  
	    Local cTurno     :="" 
	    Local cSEQ       :=""
	    Local dDtRef
	    Local mSQL 		:= "" 
		Local vDia
		Local cPerg 	:= "MTC001"
		Local id
		Private dRet
		Private vRetTur
		
        IF nBene == 1 
			if Val(SubStr(dtos(dDataBase),7,2)) < 15
				dDtRef := SubStr(dtos(dDatabase),1,6) + "16"
			Else
				dDtRef := SubStr(dtos(dDatabase - 30),1,6) + "16"         //dDtRef := SubStr(dtos(dDataRef - 30),1,6) + "16"     
			Endif 		 
		Else
			dDtRef := SubStr(dtos(dDatabase),1,6) + "01"
		Endif
		
		
  		dDataRef :=	stod(dDtRef)
		cSEQ  := cSeqPa
		
		   For id := 1 to 30
		    
		 		If Alltrim(Upper(Cdow(dDataRef))) = "SUNDAY"
					cRet	:= "1"           
				ElseIf  Alltrim(Upper(Cdow(dDataRef))) = "MONDAY"
					cRet	:= "2"
				ElseIf  Alltrim(Upper(Cdow(dDataRef))) = "TUESDAY"
					cRet	:= "3"
					ElseIf  Alltrim(Upper(Cdow(dDataRef))) = "WEDNESDAY"
					cRet	:= "4"
				ElseIf  Alltrim(Upper(Cdow(dDataRef))) = "THURSDAY"
					cRet	:= "5"
				ElseIf  Alltrim(Upper(Cdow(dDataRef))) = "FRIDAY"
					cRet	:= "6"
				ElseIf  Alltrim(Upper(Cdow(dDataRef))) = "SATURDAY" 
					cRet	:= "7"
				Endif
			    
							
	   			IF Select("TMP") <> 0 
					DbSelectArea("TMP")
					TMP->(DbCloseArea())
				Endif   
		
				
				mSql := " SELECT PJ_TURNO,PJ_SEMANA,PJ_DIA,PJ_HRSINT1,PJ_HRTOTAL "
				mSql +=	" FROM " + RetSqlName("SPJ")   
				mSql += " WHERE D_E_L_E_T_ <> '*' "
				mSql += " AND PJ_FILIAL='" + xFilial("SPJ") + "' "
				mSql += " AND PJ_TURNO='"+ vTurno + "' "
				mSql += " AND PJ_SEMANA='" + cSeq + "' "
				mSql += " AND PJ_DIA='" + cRet + "' "		
				
			
				TCQUERY mSql NEW ALIAS "TMP"
		
				DBSELECTAREA("TMP")     
				TMP->(DBGOTOP())   
				IF !TMP->(EOF())
					
					dbSelectArea("ZA1")    
					RecLock("ZA1", .T.)
					ZA1->ZA1_FILIAL := xFilial("ZA1")
					ZA1->ZA1_TURNO  := TMP->PJ_TURNO
					ZA1->ZA1_SEQ    := TMP->PJ_SEMANA 		
					ZA1->ZA1_DATA   := dDataRef
					ZA1->ZA1_SEMANA	:= TMP->PJ_DIA
					RO_Feri(DTOS(dDataRef))
					ZA1->ZA1_HRTOTA := IIF(dRet == 'S',0, (TMP->PJ_HRTOTAL - TMP->PJ_HRSINT1) )
					ZA1->(MsUnlock())
				    
					
				 
				 Endif
                
                
                IF vTurno == "018" .Or. vTurno == "019"
					IF cRET == "7"  
						If cSeq == "01"
							cSeq := "02"
						Else
							cSeq := "01"
						Endif
					Endif 
				Else
					cSeq := "01"
				EndIf	
				dDataRef := dDataRef + 1

			Next
		 	
	 
	                       
	Return  
    
    // Checar se é Feriados 
	Static Function RO_Feri(dDtRef)  
	  	dbSelectArea("SP3")
		dbSetOrder(1)  
		If dbSeek(xFilial("SP3")+dDtRef)
		   	dRet := 'S'
	    Else
		    dRet := 'N'
	    Endif
	Return


	Static Function ValidPerg(cPerg)
		
			Local aRegs  	:= {}
			Local nSX1Order	:= SX1->(IndexOrd())
		
			cPerg		:= PADR(cPerg,len(SX1->X1_GRUPO))
			
			SX1->(dbSetOrder(1))
			
			AADD( aRegs, {cPerg  ,"01","Turno De :"            ,"","","MV_CH01"  ,"C",03,00,0,"G","", "MV_PAR01",""              ,"","","","",""                ,"","","","",""       ,"","","","","","","","","","","","","","SR6"} )
			aAdd( aRegs, {cPerg  ,"02","Turno Ate:"            ,"","","MV_CH02"  ,"C",03,00,0,"G","", "MV_par02",""              ,"","","","",""                ,"","","","",""       ,"","","","","","","","","","","","","","SR6"} )
//			AADD( aRegs, {cPerg  ,"03","Data Inicial :"        ,"","","MV_CH03"  ,"D",08,00,0,"G","", "MV_PAR03",""              ,"","","","",""                ,"","","","",""       ,"","","","","","","","","","","","","",""   } )
//			AADD( aRegs, {cPerg  ,"04","Data Final   :"        ,"","","MV_CH04"  ,"D",08,00,0,"G","", "MV_PAR04",""              ,"","","","",""                ,"","","","",""       ,"","","","","","","","","","","","","",""   } )
	
			For nX := 1 to Len(aRegs)
				If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
					RecLock('SX1',.T.)
					For nY:=1 to FCount()
						If nY <= Len(aRegs[nX])
							SX1->(FieldPut(nY,aRegs[nX,nY]))
						Endif
					Next nY
					MsUnlock()
				Endif
			Next nX
			
			SX1->(dbSetOrder(nSX1Order))
		
	Return  	
	
	Static Function MontaGrid()
		Local aCampos := {}
		Local cSQL := ""
		aCaixas := {}
	 	
		If Select( "TMP" ) > 0
			TMP->( dbCloseArea() )
		EndIf
        
    	
		cSql := " Select ZA1_TURNO,Count(ZA1_HRTOTA)DIA_UTIL ,SUM(ZA1_HRTOTA)ZA1_HRTOTA " 
		cSql += " From "+RetSQLName("ZA1")                                                      
		cSql += " WHERE ZA1_FILIAL='"+xFilial("ZA1")+"' AND D_E_L_E_T_<> '*' AND ZA1_HRTOTA > 0 "
		cSql += " GROUP BY ZA1_TURNO "
    
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cSQL), "TMP", .F., .T. )
		dbSelectArea("TMP")
		TMP->(dbGoTop())
	    
	    aCaixas := {}
	        
		While TMP->(!Eof())
			aAdd(aCaixas,{TMP->ZA1_TURNO,Transform(TMP->DIA_UTIL, "@E 999"),Transform(TMP->ZA1_HRTOTA, "@E 999.99")})
			TMP->(DbSkip())
		EndDo
		
		If Len(aCaixas) == 0
			aCaixas := {{"","",""}}
		EndIf

		
		oList1:aArray := {}
		oList1:Refresh()
		oList1:aArray := aClone(aCaixas)
		oList1:Refresh()
	    
	Return

	User Function MTCalTur(cTurno)
		Local nHoras 
	   	Local mSql 	:= ""
	   
		if Select( "TMP" ) > 0
			TMP->( dbCloseArea() )
		EndIf
	        
	    	
		mSql := " Select ZA1_TURNO,Count(ZA1_HRTOTA)DIA_UTIL ,SUM(ZA1_HRTOTA)ZA1_HRTOTA " 
		mSql += " From "+RetSQLName("ZA1")                                                      
		mSql += " WHERE ZA1_FILIAL='"+xFilial("ZA1")+"' AND D_E_L_E_T_<> '*' AND ZA1_HRTOTA > 0 "
		mSql += " AND ZA1_TURNO ='"+ cTurno +"' "                                               
		mSql += " GROUP BY ZA1_TURNO "


			
	       
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL), "TMP", .F., .T. )
		dbSelectArea("TMP")
		TMP->(dbGoTop())
		nHoras := TMP->ZA1_HRTOTA
		TMP->( dbCloseArea() )
	
	Return(nHoras)
	
