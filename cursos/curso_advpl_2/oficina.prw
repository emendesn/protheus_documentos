///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Oficina.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Oficina()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Esta funcao funciona como funciona o objeto tButton executado   |//
//|           | dentro de um for/next, aqui eh demonstrado tambem a utilizazao  |//
//|           | para coordenadas sem varias compilacoes.                        |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER Chr(10)+Chr(13)

USER FUNCTION OFICINA()

LOCAL cCaption := "Oficina de Programação"
LOCAL aBotao   := {}
LOCAL oDlg     := NIL
LOCAL cAction  := ""
LOCAL bAction  := NIL
LOCAL nLin     := 0
LOCAL nCol     := 0
LOCAL i        := 0
LOCAL j        := 0
LOCAL y        := 1
LOCAL oMainWnd := NIL
LOCAL oBmp     := NIL
LOCAL cCoord   := ""
LOCAL aX       := {}
LOCAL aSX6     := {}
LOCAL aUsers   := {}

PRIVATE cMainPath := ""

// ------------------------------------------------------
// O que significa cada conjunto de números do MV_OFICINA
// ------------------------------------------------------

// NOVO -> 055,003,005,027,047,045,026,405,850

// 040,003,005,027,047,045,026,380,760
// |   |   |   |   |   |   |   |   |
// |   |   |   |   |   |   |   |   +-> 9º Largura da MsDialog
// |   |   |   |   |   |   |   +-----> 8º Altura da MsDialog
// |   |   |   |   |   |   +---------> 7º Altura do botão
// |   |   |   |   |   +-------------> 6º Largura do botão
// |   |   |   |   +-----------------> 5º Espaço entre um botao e outro verticalmente
// |   |   |   +---------------------> 4º Espaço entre um botao e outro horizontalmente
// |   |   +-------------------------> 3º Quantidade de botões na vetical
// |   +-----------------------------> 2º Coluna inicial do 1º botão 
// +---------------------------------> 1º Linha inicial do 1º botao
aAdd(aSX6,{"MV_OFICINA","C","PARAMETRO COM AS COORDENADAS DO FONTE OFICINA.PRW","040,003,005,027,047,045,026,380,760"})
aAdd(aSX6,{"MV_PATOFIC","C","PARAMETRO COM O ENDEREÇO DOS FONTES DO OFICINA",""})

For i:=1 To Len(aSX6)
	If ! ExisteSX6( aSX6[i,1] )
		CriarSX6( aSX6[i,1], aSX6[i,2], aSX6[i,3], aSX6[i,4] )
	Endif
Next i

cCoord    := GetMv( aSX6[1,1] )
cMainPath := GetMv( aSX6[2,1] )

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
		PutMv( aSX6[2,1], cMainPath )
	Endif
Endif

While !Empty(cCoord)
   aAdd(aX,Val(SubStr(cCoord,1,3)))
   cCoord := SubStr(cCoord,5)
End

//1
aAdd(aBotao,{"MsDialog"                       , "u_xMsDialog()"   })
aAdd(aBotao,{"MsDialog"+ENTER+ "Objetos"      , "u_DialogObj()"   })
aAdd(aBotao,{"Alertas"                        , "u_Alertas()"     })
aAdd(aBotao,{"ListBox" +ENTER+ "Simples"      , "u_List_Box()"    })
aAdd(aBotao,{"ListBox" +ENTER+ "Semáforo"     , "u_ListBoxSem()"  })
//2
aAdd(aBotao,{"ListBox" +ENTER+ "Mark"         , "u_ListBoxMar()"  })
aAdd(aBotao,{"ListBox" +ENTER+ "Mark apenas 1", "u_LstBxMr2()"    })
aAdd(aBotao,{"ListBox" +ENTER+ "Duplo Click"  , "u_ListBoxDup()"  })
aAdd(aBotao,{"ListBox" +ENTER+ "Change"       , "u_ListBoxCha()"  })
aAdd(aBotao,{"ListBox" +ENTER+ "Items"        , "u_ListBoxIte()"  })
//3
aAdd(aBotao,{"ListBox" +ENTER+ "Click Direito", "u_LBoxDir()"     })
aAdd(aBotao,{"TwBrowse"                       , "u_xTwBrowse()"   })
aAdd(aBotao,{"RptStatus"                      , "u_GRptStatus()"  })
aAdd(aBotao,{"Processa"                       , "u_GProces1()"    })
aAdd(aBotao,{"Processa 2"                     , "u_GProces2()"    })
//4
aAdd(aBotao,{"MsAguarde"                      , "u_GMsAguarde()"  })
aAdd(aBotao,{"MsgRun"                         , "u_GMsgRun()"     })
aAdd(aBotao,{"ScrollBox"                      , "u_Scroll()"      })
aAdd(aBotao,{"Lê arq. txt"                    , "u_LeArqTxt()"    })
aAdd(aBotao,{"Geração Log"                    , "u_Log()"         })
//5
aAdd(aBotao,{"mBrowse"+ENTER+"Ax..."          , "u_mBrowsAx()"    })
aAdd(aBotao,{"MarkBrowse"                     , "u_MarkBrw()"     })
aAdd(aBotao,{"Relaciona"+ENTER+"'Pai e Filho'", "u_Pai_Filho()"   })
aAdd(aBotao,{"MsGetDados"                     , "u_Get_Dados()"   })
aAdd(aBotao,{"MsGetDados 2"                   , "u_GetDados2()"   })
//6
aAdd(aBotao,{"Relatório Padrão"               , "u_Inform()"      })
aAdd(aBotao,{"TMSPrinter"                     , "u_TMS_Printer()" })
aAdd(aBotao,{"New Print"                      , "u_NewPrint()"    })
aAdd(aBotao,{"Protheus"+ENTER+"Ms-Word"       , "u_Ap_Word()"     })
aAdd(aBotao,{"Protheus"+ENTER+"HTML"          , "u_xHTMLAdvPL()"  })
//7
aAdd(aBotao,{"Arquivo"+ENTER+"Temporário"     , "u_Temporar()"    })
aAdd(aBotao,{"Rotinas"+ENTER+"Autómaticas"    , "u_Rot_Auto()"    })
aAdd(aBotao,{"e-Mail"                         , "u_e_Mail()"      })
aAdd(aBotao,{"My"+ENTER+"EnchoiceBar"         , "u_MyBar()"       })
aAdd(aBotao,{"Wizard"                         , "u_Wizard()"      })
//8
aAdd(aBotao,{"Parambox"                       , "u_xParambox()"   })
aAdd(aBotao,{"Tree"                           , "u_Trees()"       })
aAdd(aBotao,{"Timer"                          , "u_Timer()"       })
aAdd(aBotao,{"WndBrowse"                      , "u_xWndBrowse()"  })
aAdd(aBotao,{"MsExplorer"                     , "u_xMsExplorer()" })
//9
aAdd(aBotao,{"MsNewGetDados"                  , "u_MsNwGtDs()"    })
aAdd(aBotao,{"Meter"                          , "u_GMeter()"      })
aAdd(aBotao,{"Mark apenas um"                 , "u_LstBxMr2()"    })
aAdd(aBotao,{"Mark Tree"                      , "u_LstBxMr3()"    })
aAdd(aBotao,{"MsNewGetDados"+ENTER+"c/ BitMap", "u_NGDBit()"      })
aAdd(aBotao,{"Botão Teste"                    , "Alert('teste')"  })

DEFINE MSDIALOG oDlg FROM 0,0 TO aX[8],aX[9] TITLE cCaption OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
	oDlg:lEscClose := .F.
	
	@ 0,0 BITMAP oBmp RESNAME "FAIXASUPERIOR" OF oDlg SIZE 1200,50 NOBORDER ADJUST PIXEL
	oBmp:Align := CONTROL_ALIGN_TOP
	
	nLin := aX[1]
	nCol := aX[2]
	
	For j:=1 To (Len(aBotao)/aX[3])
		For i:=1 To aX[3]
			cAction := "{|| "+aBotao[y,2]+"}"
			bAction := &cAction
			TButton():New(nLin,nCol,aBotao[y,1],oDlg,bAction,aX[6],aX[7],,,.F.,.T.,.F.,,.F.,,,.F.)
			nLin += aX[4]
			y++
		Next i
		nCol += aX[5]
		nLin := aX[1]
	Next j
	
	TButton():New(190,aX[2],"&Sair",oDlg,{|| oDlg:End()},nCol-5,15,,,.F.,.T.,.F.,,.F.,,,.F.)
ACTIVATE MSDIALOG oDlg CENTERED

RETURN