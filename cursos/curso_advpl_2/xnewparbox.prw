User Function xNewParBox(aParametros,cTitle,aRet,bOk,aButtons,lCentered,nPosx,nPosy, oDlgWizard, cLoad, lCanSave,lUserSave)

Local nx
Local oDlg
Local cPath     := ""
Local oPanel
Local oPanelB
Local cTextSay
Local lOk			:= .F.
Local nLinha		:= 8
Local cArquivos := ""
Local nBottom
Local oFntVerdana
Local cOpcoes	:=	""
Local lWizard  := .F.

DEFAULT bOk			:= {|| (.T.)}
DEFAULT aButtons	:= {}
DEFAULT lCentered	:= .T.
DEFAULT nPosX		:= 0
DEFAULT nPosY		:= 0
DEFAULT cLoad     := ProcName(1)
DEFAULT lCanSave	:= .T.
DEFAULT lUserSave	:= .F.

If Type("cCadastro") == "U"
	cCadastro := ""
EndIf

If !lCanSave
	cLoad := "99_NOSAVE_"
Else                 
	//Se nao esta bloqueado
	If ParamLoad(cLoad,aParametros,0,"1")== "2" 
		lUserSave:= .F.
	//Se o usuario pode ter a sua propria configuracao
	ElseIf lUserSave	
		cLoad	:=	__cUserID+"_"+cLoad
	Endif         
Endif

DEFINE FONT oFntVerdana NAME "Verdana" SIZE 0, -10 BOLD

If oDlgWizard == NIL
	DEFINE MSDIALOG oDlg TITLE cCadastro+" - "+cTitle FROM nPosX,nPosY TO nPosX+300,nPosY+445 OF oMainWnd Pixel
	lWizard := .F.
Else
	oDlg := oDlgWizard
	lWizard := .T.
EndIf

oPanel := TScrollBox():New( oDlg, 8,10,104,203)
oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	
//oPanel := TPanel():New(8,10,'',oDlg, oDlg:oFont, .F., .F.,, ,203 ,104 ,.T.,.T. )

For nx := 1 to Len(aParametros)
	Do Case 
		Case aParametros[nx][1]==1 // SAY + GET
			If ! lWizard
				SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
				&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			EndIf	
         cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+" ? "+"'}"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][9],CLR_HBLUE,CLR_BLACK),,100,,,,,,)
			cWhen	:= Iif(Empty(aParametros[nx][7]),".T.",aParametros[nx][7])
			cValid	:=Iif(Empty(aParametros[nx][5]),".T.",aParametros[nx][5])
			cF3		:=Iif(Empty(aParametros[nx][6]),NIL,aParametros[nx][6])
			If ! lWizard
				cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			Else
				cBlkGet := "{ | u | If( PCount() == 0, "+"aRet["+AllTrim(STRZERO(nx,2,0))+"],"+"aRet["+AllTrim(STRZERO(nx,2,0))+"] := "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			EndIf	
			cBlKVld := "{|| "+cValid+"}"
			cBlKWhen := "{|| "+cWhen+"}"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			//*****************************************************
			// Auto Ajusta da Get para Campos Caracter e Numerico *
			// Somente para o Modulo PCO - Acacio Egas            *
			//*****************************************************
			If Type("cModulo")=="C" .and. cModulo=="PCO" .and. FindFunction("CalcFieldSize") .and. !lWizard
				cType := Type("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
				If cType $ "C"
					nWidth	:= CalcFieldSize(cType,Len(aParametros[nx][3]),,aParametros[nx][4],"") + 10 + If(!Empty(cF3),10,0)
				ElseIf cType $ "N"
					nWidth	:= CalcFieldSize(cType,,,aParametros[nx][4],"") + 10
				Else
					nWidth	:= aParametros[nx][8]
				EndIf
			Else
				nWidth	:= aParametros[nx][8]
			EndIf
			TGet():New( nLinha,95,&cBlKGet,oPanel,nWidth,,aParametros[nx][4], &(cBlkVld),,,, .T.,, .T.,, .T., &(cBlkWhen), .F., .F.,, .F., .F. ,cF3,"MV_PAR"+AllTrim(STRZERO(nx,2,0)),,,,.T.)
		Case aParametros[nx][1]==2 // SAY + COMBO
			If ! lWizard
				SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
				&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			EndIf	
    		cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+" ? "+"'}"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][7],CLR_HBLUE,CLR_BLACK),,100,,,,,,)
			cWhen   := ".T."
			If Len(aParametros[nx]) > 7
				If aParametros[nx][8] != NIL .And. ValType(aParametros[nx][8])=="L"
					cWhen	:=If(aParametros[nx][8],".T.",".F.")
				EndIf	
			EndIf	
			cValid	:=Iif(Empty(aParametros[nx][6]),".T.",aParametros[nx][6])
			cBlKVld := "{|| "+cValid+"}"
			If ! lWizard
				cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
         Else
				cBlkGet := "{ | u | If( PCount() == 0, "+"aRet["+AllTrim(STRZERO(nx,2,0))+"],"+"aRet["+AllTrim(STRZERO(nx,2,0))+"] := "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			EndIf         
			cBlkWhen := "{|| "+cWhen+" }"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TComboBox():New( nLinha,95, &cBlkGet,aParametros[nx][4], aParametros[nx][5], 10, oPanel, ,,       ,,,.T.,,,.F.,&(cBlkWhen),.T.,,,,"MV_PAR"+AllTrim(STRZERO(nx,2,0)))

		Case aParametros[nx][1]==3 // SAY + RADIO
			nLinha += 8
			If ! lWizard
				SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
				&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			EndIf	
			cTextSay:= "{||'"+aParametros[nx][2]+" ? "+"'}"
			TGroup():New( nLinha-8,15, nLinha+(Len(aParametros[nx][4])*9)+7,205,aParametros[nx][2]+ " ? ",oPanel,If(aParametros[nx][7],CLR_HBLUE,CLR_BLACK),,.T.)
//			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][7],CLR_HBLUE,CLR_BLACK),,,,,,,,)
//			@ nLinha-5,75 TO nLinha+(Len(aParametros[nx][4])*9)+5,80+aParametros[nx][5]+1 LABEl "" of oPanel PIXEL
			cWhen   := ".T."
			If Len(aParametros[nx]) > 7
				If aParametros[nx][8] != NIL .And. ValType(aParametros[nx][8])=="L"
					cWhen	:=If(aParametros[nx][8],".T.",".F.")
				EndIf	
			EndIf	
			If ! lWizard
				cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
            Else
				cBlkGet := "{ | u | If( PCount() == 0, "+"aRet["+AllTrim(STRZERO(nx,2,0))+"],"+"aRet["+AllTrim(STRZERO(nx,2,0))+"] := "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			EndIf         
			cBlkWhen := "{|| " + cWhen  +  "}"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TRadMenu():New( nLinha, 30, aParametros[nx][4],&cBlkGet, oPanel,,,,,,,&(cBlkWhen),aParametros[nx][5],9, ,,,.T.)
			nLinha += (Len(aParametros[nx][4])*10)-3

		Case aParametros[nx][1]==4 // SAY + CheckBox
			If ! lWizard
				SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
				&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			EndIf	
         cTextSay:= "{||'"+aParametros[nx][2]+"  "+"'}"
			If ! lWizard
				cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
         Else
				cBlkGet := "{ | u | If( PCount() == 0, "+"aRet["+AllTrim(STRZERO(nx,2,0))+"],"+"aRet["+AllTrim(STRZERO(nx,2,0))+"] := "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			EndIf         
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][7],CLR_HBLUE,CLR_BLACK),,100,,,,,,)
			cBlkWhen := Iif(Len(aParametros[nx]) > 7 .And. !Empty(aParametros[nx][8]),aParametros[nx][8],"{|| .T. }")			 
			If (Len(aParametros[nx]) > 6 .And. aParametros[nx][7]).Or. ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TCheckBox():New(nLinha,95,aParametros[nx][4], &cBlkGet,oPanel, aParametros[nx][5],10,,,,,,,,.T.,,,&(cBlkWhen))

		Case aParametros[nx][1]==5 // CheckBox Linha Inteira
			If ! lWizard
				SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
				&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			EndIf         
			If ! lWizard
				cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
            Else
				cBlkGet := "{ | u | If( PCount() == 0, "+"aRet["+AllTrim(STRZERO(nx,2,0))+"],"+"aRet["+AllTrim(STRZERO(nx,2,0))+"] := "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			EndIf         
			cBlkWhen := "{|| .T. }"
			If (Len(aParametros[nx]) > 6 .And. aParametros[nx][7]) .Or. ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TCheckBox():New(nLinha,15,aParametros[nx][2], &cBlkGet,oPanel, aParametros[nx][4],10,,,,,,,,.T.,,,&(cBlkWhen))

		Case aParametros[nx][1]==6 // File + Procura de Arquivo
			If ! lWizard
				SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
				&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			EndIf
			cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+" ? "+"'}"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][8],CLR_HBLUE,CLR_BLACK),,,,,,,,)
			cWhen	    := Iif(Empty(aParametros[nx][6]),".T.",aParametros[nx][6])
			cValid	  := Iif(Empty(aParametros[nx][5]),".T.","("+aParametros[nx][5]+").Or.Vazio("+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+")")
			If ! lWizard
				cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
            Else
				cBlkGet := "{ | u | If( PCount() == 0, "+"aRet["+AllTrim(STRZERO(nx,2,0))+"],"+"aRet["+AllTrim(STRZERO(nx,2,0))+"] := "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			EndIf         
			cBlKVld   := "{|| " + cValid + "}"
			cBlKWhen  := "{|| " + cWhen + "}"
			cArquivos := aParametros[nx][9]
			
			If Len(aParametros[nx]) >= 10
				cPath := aParametros[nx][10]
			EndIf			
			
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			If Len(aParametros[nX]) >= 11
				cOpcoes := AllTrim(Str(aParametros[nx][11]))
			Else
				cOpcoes := AllTrim(Str(GETF_LOCALHARD+GETF_LOCALFLOPPY))
			Endif			
			
			cGetfile := "{|| MV_PAR"+AllTrim(STRZERO(nx,2,0))+" := cGetFile(cArquivos,'"+;
								"STR0176"+"',0,cPath,.T.,"+cOpcoes+;
								")+SPACE(40), If(Empty(MV_PAR"+AllTrim(STRZERO(nx,2,0))+;
								"), MV_PAR"+AllTrim(STRZERO(nx,2,0))+" := '"+;
								aParametros[nx][3]+"',)  }"
	
			
			TGet():New( nLinha,95 ,&cBlKGet,oPanel,aParametros[nx][7],,aParametros[nx][4], &(cBlkVld),,,, .T.,, .T.,, .T., &(cBlkWhen), .F., .F.,, .F., .F. ,,"MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			TButton():New( nLinha,95+aParametros[nx][7], "STR0175", oPanel,&(cGetFile), 29, 12, , oDlg:oFont, ,.T.,.F.,,.T., ,, .F.)
		
		Case aParametros[nx][1]==7 .And. ! lWizard// Filtro de Arquivos
			nLinha += 8
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][4])
			SetPrvt("MV_FIL"+AllTrim(STRZERO(nx,2,0)))
			&("MV_FIL"+AllTrim(STRZERO(nx,2,0))) := MontDescr(aParametros[nx][3],ParamLoad(cLoad,aParametros,nx,aParametros[nx][4]))
				
			TGroup():New( nLinha-8,15, nLinha+40,170,aParametros[nx][2]+ " ? ",oPanel,,,.T.)		
			cWhen	:= ".T."
			If Len(aParametros[nx])>4
				If Type(aParametros[nx][5])=="L" .And. !Empty(aParametros[nx][5])
					cWhen	:= aParametros[nx][5]
				EndIf
			EndIf	
			cValid	:=".T."
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_FIL"+AllTrim(STRZERO(nx,2,0))+","+"MV_FIL"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlKVld := "{|| "+cValid+"}"
			cBlKWhen := "{|| "+cWhen+"}"
			If ParamLoad(cLoad,aParametros,0,"1")=="2" 
				cBlKWhen := "{|| .F. }"
			EndIf
			cGetFilter := "{|| MV_PAR"+AllTrim(STRZERO(nx,2,0))+" := BuildExpr('"+aParametros[nx,3]+"',,MV_PAR"+AllTrim(STRZERO(nx,2,0))+"),MV_FIL"+AllTrim(STRZERO(nx,2,0))+":=MontDescr('"+aParametros[nx,3]+"',MV_PAR"+AllTrim(STRZERO(nx,2,0))+") }"
			TButton():New( nLinha,18, "Editar", oPanel,MontaBlock(cGetFilter), 35, 14, , oDlg:oFont, ,.T.,.F.,,.T.,&(cBlkWhen),, .F.)
			TMultiGet():New( nLinha, 55, &cBlKGet,oPanel,109,33,,,,,,.T.,,.T.,&(cBlkWhen),,,.T.,&(cBlkVld),,.T.,.F., )
			nLinha += 31
		Case aParametros[nx][1]==8 // SAY + GET PASSWORD
			If ! lWizard
				SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
				&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			EndIf         
			cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+" ? "+"'}"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][9],CLR_HBLUE,CLR_BLACK),,100,,,,,,)
			cWhen	:= Iif(Empty(aParametros[nx][7]),".T.",aParametros[nx][7])
			cValid	:=Iif(Empty(aParametros[nx][5]),".T.",aParametros[nx][5])
			cF3		:=Iif(Empty(aParametros[nx][6]),NIL,aParametros[nx][6])
			If ! lWizard
				cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
            Else
				cBlkGet := "{ | u | If( PCount() == 0, "+"aRet["+AllTrim(STRZERO(nx,2,0))+"],"+"aRet["+AllTrim(STRZERO(nx,2,0))+"] := "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			EndIf         
			cBlKVld := "{|| "+cValid+"}"
			cBlKWhen := "{|| "+cWhen+"}"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TGet():New( nLinha,95 ,&cBlKGet,oPanel,aParametros[nx][8],,aParametros[nx][4], &(cBlkVld),,,, .T.,, .T.,, .T., &(cBlkWhen), .F., .F.,, .F., .T. ,cF3,"MV_PAR"+AllTrim(STRZERO(nx,2,0)),,,,.T.)
		Case aParametros[nx][1]==9 // SAY
            cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+"'}"
			If aParametros[nx][5]
				TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,oFntVerdana,,,,.T.,CLR_BLACK,,aParametros[nx][3],aParametros[nx][4],,,,,)
			Else
				TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,CLR_BLACK,,aParametros[nx][3],aParametros[nx][4],,,,,)
			EndIf
		Case aParametros[nx][1]==10 // Range (fase experimental)
			nLinha += 8
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			SetPrvt("MV_RAN"+AllTrim(STRZERO(nx,2,0)))
			&("MV_RAN"+AllTrim(STRZERO(nx,2,0))) := PMSRangeDesc(	&("MV_PAR"+AllTrim(STRZERO(nx,2,0))),aParametros[nx,7])
			TGroup():New( nLinha-8,15, nLinha+40,170,"Range de "+aParametros[nx][2],oPanel,,,.T.)
			If Type(aParametros[nx][8])=="L" .And. !Empty(aParametros[nx][8])
				cWhen	:= aParametros[nx][8]
			EndIf	
			cValid	:=".T."
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_RAN"+AllTrim(STRZERO(nx,2,0))+","+"MV_RAN"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlKWhen := "{|| "+cWhen+"}"
			If ParamLoad(cLoad,aParametros,0,"1")=="2" 
				cBlKWhen := "{|| .F. }"
			EndIf
			cGetRange := "{|| MV_PAR"+AllTrim(STRZERO(nx,2,0))+" := PmsRange('"+aParametros[nx,2]+"','"+aParametros[nx,4]+"',"+Str(aParametros[nx,5])+",MV_PAR"+AllTrim(STRZERO(nx,2,0))+",'"+aParametros[nx,6]+"',"+Str(aParametros[nx,7])+"),	MV_RAN"+AllTrim(STRZERO(nx,2,0))+" := PMSRangeDesc( MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+Str(aParametros[nx,7])+") }"	   		
	   		TButton():New( nLinha-2,18, "Editar", oPanel,MontaBlock(cGetRange), 35, 14, , oDlg:oFont, ,.T.,.F.,,.T.,&(cBlkWhen),, .F.)
			TMultiGet():New( nLinha, 55, &cBlKGet,oPanel,109,33,,,,,,.T.,,.T.,&(cBlkWhen),,,.T.,/*&(cBlkVld)*/,,.T.,.F., )
			nLinha += 31

		Case aParametros[nx][1]==11 // MultiGet
			nLinha += 8
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][4])
			
			//SetPrvt("MV_FIL"+AllTrim(STRZERO(nx,2,0)))
			//&("MV_FIL"+AllTrim(STRZERO(nx,2,0))) := MontDescr(aParametros[nx][3],ParamLoad(cLoad,aParametros,nx,aParametros[nx][4]))				
			//TGroup():New( nLinha-8,15, nLinha+40,170,aParametros[nx][2]+ " ? ",oPanel,,,.T.)		
			
			cWhen	:= ".T."
			If Len(aParametros[nx])>4
				If Type(aParametros[nx][5])=="L" .And. !Empty(aParametros[nx][5])
					cWhen	:= aParametros[nx][5]
				EndIf
			EndIf	
			
			cValid	:=".T."
			
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			
			cBlKVld := "{|| "+cValid+"}"
			
			cBlKWhen := "{|| "+cWhen+"}"
			
			If ParamLoad(cLoad,aParametros,0,"1")=="2" 
				cBlKWhen := "{|| .F. }"
			EndIf
			
			//cGetFilter := "{|| MV_PAR"+AllTrim(STRZERO(nx,2,0))+" := BuildExpr('"+aParametros[nx,3]+"',,MV_PAR"+AllTrim(STRZERO(nx,2,0))+"),MV_FIL"+AllTrim(STRZERO(nx,2,0))+":=MontDescr('"+aParametros[nx,3]+"',MV_PAR"+AllTrim(STRZERO(nx,2,0))+") }"
			//TButton():New( nLinha,18, "Editar", oPanel,MontaBlock(cGetFilter), 35, 14, , oDlg:oFont, ,.T.,.F.,,.T.,&(cBlkWhen),, .F.)
			
			TMultiGet():New( nLinha, 55, &cBlKGet,oPanel,109,33,,,,,,.T.,,.T.,&(cBlkWhen),,,.T.,&(cBlkVld),,.T.,.F., )
			nLinha += 31

    EndCase
	nLinha += 17
Next

If !lWizard .And. __cUserID=="000000" .And. lCanSave
	@ nlinha+8,10 BUTTON oButton PROMPT "+" SIZE 10 ,7   ACTION {|| ParamSave(cLoad,aParametros,"1") } OF oPanel PIXEL
	@ nlinha+8,22 SAY "Administrador: Salvar configuações" SIZE 120,7 Of oPanel FONT oFntVerdana COLOR RGB(80,80,80) PIXEL
	oButton:cToolTip := "Clique aqui para salvar as configurações de: " + cTitle
	
	@ nlinha+15,10 BUTTON oButton PROMPT "+" SIZE 10 ,7   ACTION {|| ParamSave(cLoad,aParametros,"2"),Alert("Bloqueio efetuado. Os parametros estarão bloqueados a partir da próxima chamada.") } OF oPanel PIXEL
	@ nlinha+15,22 SAY "Administrador: Bloquear" SIZE 120,7 Of oPanel FONT oFntVerdana COLOR RGB(80,80,80) PIXEL
	oButton:cToolTip := "Clique aqui para bloquear as configurações de: " + cTitle
	
	@ nlinha+22,10 BUTTON oButton PROMPT "+" SIZE 10 ,7   ACTION {|| ParamSave(cLoad,aParametros,"1"),Alert("Desbloqueio efetuado. Os parametros estarão desbloqueados a partir da próxima chamada.")  } OF oPanel PIXEL
	@ nlinha+22,22 SAY "Administrador: Desbloquear" SIZE 120,7 Of oPanel FONT oFntVerdana COLOR RGB(80,80,80) PIXEL
	oButton:cToolTip := "Clique aqui para desbloquear as configurações de: " + cTitle
EndIf	

oMainWnd:CoorsUpdate()
If ! lWizard
	oPanelB := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,40,20,.T.,.T. )
	oPanelB:Align := CONTROL_ALIGN_BOTTOM

	For nx := 1 to Len(aButtons)
		SButton():New( 4, 157-(nx*33), aButtons[nx][1],aButtons[nx,2],oPanelB,.T.,IIf(Len(aButtons[nx])==3,aButtons[nx,3],Nil),)
	Next
	
	DEFINE SBUTTON FROM 4, 157   TYPE 1 ENABLE OF oPanelB ACTION (If(ParamOk(aParametros,@aRet).And.Eval(bOk),(oDlg:End(),lOk:=.T.),(lOk:=.F.)))
	DEFINE SBUTTON FROM 4, 190   TYPE 2 ENABLE OF oPanelB ACTION (lOk:=.F.,oDlg:End())

	If (nLinha*2) + 80 > oMAinWnd:nBottom-oMAinWnd:nTop
		nBottom  := oDLg:nTop + oMAinWnd:nBottom-oMAinWnd:nTop - 5
	Else
		nBottom := oDLg:nTop + (nLinha*2) + 80
	EndIf
	
	nBottom := MAX(310,nBottom)
	oDlg:nBottom := nBottom
EndIf

If ! lWizard
	ACTIVATE MSDIALOG oDlg CENTERED 
	If lOk .And. lUserSave
		ParamSave(cLoad,aParametros,"1")
	Endif	
EndIf

Return lOk