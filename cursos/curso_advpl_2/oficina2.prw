#INCLUDE "PROTHEUS.CH"

#DEFINE cVERSION 	" v.7."
#DEFINE ENTER		Chr(10)+Chr(13)

USER FUNCTION OFICINA2()

LOCAL cAction := ""
LOCAL cCaption := "Oficina de Programação"

LOCAL oDlg
LOCAL oBtn 
LOCAL oBmp
LOCAL oSroll

LOCAL nI := 0
LOCAL nLin := 0
LOCAL nCol := 0

LOCAL aSX6 := {}
LOCAL aBotao := {}

LOCAL bAction := {|| }

PRIVATE cMainPath := ""

aAdd(aSX6,{"MV_PATOFIC","C","PARAMETRO COM O ENDEREÇO DOS FONTES DO OFICINA",""})

For nI:=1 To Len( aSX6 )
	If ! ExisteSX6( aSX6[ nI, 1 ] )
		CriarSX6( aSX6[ nI, 1 ], aSX6[ nI, 2 ], aSX6[ nI, 3 ], aSX6[ nI, 4 ] )
	Endif
Next nI

cMainPath := GetMv( aSX6[1,1] )

/***
 * _________________________________________________________
 * cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
 * ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 * <ExpC1> - Expressao de filtro
 * <ExpC2> - Titulo da janela
 * <ExpN1> - Numero de mascara default 1 para *.Exe
 * <ExpC3> - Diretório inicial se necessário
 * <ExpL1> - .F. botão salvar - .T. botão abrir
 * <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
 */
If Empty( cMainPath )
	cMainPath := cGetFile(,"Informe a pasta do OFICINA",,cMainPath,.T.,GETF_RETDIRECTORY+GETF_LOCALHARD)
	If Empty( cMainPath )
		MsgAlert("Impossível continuar, necessário informar a pasta de trabalho do OFICINA.",cCaption)
		Return
	Else
		PutMv( aSX6[ 1, 1 ], cMainPath )
	Endif
Endif

aAdd(aBotao,{"MsDialog"                        , "u_xMsDialog()"   })
aAdd(aBotao,{"MsDialog"+ENTER+ "Objetos"       , "u_DialogObj()"   })
aAdd(aBotao,{"Calendário"                      , "u_xCalend()"     })
aAdd(aBotao,{"Alertas"                         , "u_Alertas()"     })
aAdd(aBotao,{"ListBox" +ENTER+ "Simples"       , "u_List_Box()"    })
aAdd(aBotao,{"ListBox" +ENTER+ "Semáforo"      , "u_ListBoxSem()"  })
aAdd(aBotao,{"ListBox" +ENTER+ "Mark"          , "u_ListBoxMar()"  })
aAdd(aBotao,{"ListBox" +ENTER+ "Mark um"       , "u_LstBxMr2()"    })
aAdd(aBotao,{"ListBox" +ENTER+ "Mark avaliação", "u_LstBxMr3()"    })
aAdd(aBotao,{"ListBox" +ENTER+ "Duplo Click"   , "u_ListBoxDup()"  })
aAdd(aBotao,{"ListBox" +ENTER+ "Change"        , "u_ListBoxCha()"  })
aAdd(aBotao,{"ListBox" +ENTER+ "Items"         , "u_ListBoxIte()"  })
aAdd(aBotao,{"ListBox" +ENTER+ "Click Direito" , "u_LBoxDir()"     })
aAdd(aBotao,{"TwBrowse"                        , "u_xTwBrowse()"   })
aAdd(aBotao,{"Timer"                           , "u_Timer()"       })
aAdd(aBotao,{"RptStatus"                       , "u_GRptStatus()"  })
aAdd(aBotao,{"Processa"                        , "u_GProces1()"    })
aAdd(aBotao,{"Processa 2"                      , "u_GProces2()"    })
aAdd(aBotao,{"MsAguarde"                       , "u_GMsAguarde()"  })
aAdd(aBotao,{"MsgRun"                          , "u_GMsgRun()"     })
aAdd(aBotao,{"Meter"                           , "u_GMeter()"      })
aAdd(aBotao,{"ScrollBox"                       , "u_Scroll()"      })
aAdd(aBotao,{"Lê arq. txt"                     , "u_LeArqTxt()"    })
aAdd(aBotao,{"Geração Log"                     , "u_Log()"         })
aAdd(aBotao,{"mBrowse"+ENTER+"Ax..."           , "u_mBrowsAx()"    })
aAdd(aBotao,{"MarkBrowse"                      , "u_MarkBrw()"     })
aAdd(aBotao,{"Relaciona"+ENTER+"'Pai e Filho'" , "u_Pai_Filho()"   })
aAdd(aBotao,{"MsGetDados"                      , "u_Get_Dados()"   })
aAdd(aBotao,{"MsGetDados 2"                    , "u_GetDados2()"   })
aAdd(aBotao,{"MsNewGetDados"+ENTER+"c/ BitMap" , "u_NGDBit()"      })
aAdd(aBotao,{"Relatório Padrão"                , "u_Inform()"      })
aAdd(aBotao,{"TMSPrinter"                      , "u_TMS_Printer()" })
aAdd(aBotao,{"New Print"                       , "u_NewPrint()"    })
aAdd(aBotao,{"Protheus"+ENTER+"Ms-Word"        , "u_Ap_Word()"     })
aAdd(aBotao,{"Protheus"+ENTER+"HTML"           , "u_xHTMLAdvPL()"  })
aAdd(aBotao,{"Arquivo"+ENTER+"Temporário"      , "u_Temporar()"    })
aAdd(aBotao,{"Rotinas"+ENTER+"Autómaticas"     , "u_Rot_Auto()"    })
aAdd(aBotao,{"e-Mail"                          , "u_XEMail()"      })
aAdd(aBotao,{"My"+ENTER+"EnchoiceBar"          , "u_MyBar()"       })
aAdd(aBotao,{"Parambox"                        , "u_xParambox()"   })
aAdd(aBotao,{"Wizard"                          , "u_Wizard()"      })
aAdd(aBotao,{"Wizard c/ "+ENTER+"Parambox"     , "u_Wizard2()"     })
aAdd(aBotao,{"Tree"                            , "u_Trees()"       })
aAdd(aBotao,{"Tree c/ SX5"                     , "u_xTrees()"      })
aAdd(aBotao,{"WndBrowse"                       , "u_xWndBrowse()"  })
aAdd(aBotao,{"MsExplorer"                      , "u_xMsExplorer()" })

DEFINE MSDIALOG oDlg FROM 0,0 TO 400,740 TITLE cCaption + cVERSION + LTrim(Str(Len(aBotao)+1)) OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
	oDlg:lEscClose := .F.
	
	@ 0,0 BITMAP oBmp RESNAME "FAIXASUPERIOR" OF oDlg SIZE 1200,50 PIXEL//NOBORDER ADJUST 
	oBmp:Align := CONTROL_ALIGN_TOP
	
   @ 019,006 SCROLLBOX oScroll HORIZONTAL VERTICAL SIZE 131,182 OF oDlg BORDER      
	
   oSroll := TScrollBox():New( oDlg, 10, 10, 10, , .T., .T., .T. )
   oScroll:Align := CONTROL_ALIGN_ALLCLIENT
   
   nLin := 1
   nCol := 1
   
   For nI := 1 To Len( aBotao )
		cAction := "{|| "+aBotao[nI,2]+"}"
		bAction := &cAction
		TButton():New(nLin,nCol,aBotao[nI,1],oScroll,bAction,43,26,,,.F.,.T.,.F.,,.F.,,,.F.)
		nCol := nCol + 45
		If Mod(nI,8)==0
			nCol := 1
			nLin := nLin + 27
		Endif
   Next nI
   
	oTPanel := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel:Align := CONTROL_ALIGN_BOTTOM
   
	oBtn := TButton():New(1,1,"&Sair",oTPanel,{|| oDlg:End()},30,5,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:Align := CONTROL_ALIGN_RIGHT
ACTIVATE MSDIALOG oDlg CENTERED
RETURN
