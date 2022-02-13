#DEFINE OPEN_FILE_ERROR -1      
#INCLUDE "rwmake.ch"   
#INCLUDE "topconn.ch"
USER FUNCTION ATUPRVT()
Private cPerg := "XATUVT"

u_GerA0003(ProcName())

ValidPerg(cPerg)        
Pergunte(cPerg,.F.)
//³Montagem da tela de processamento.        
DEFINE MSDIALOG oLeTxt TITLE OemtoAnsi("Atualizacao de Precos de Vale Transporte") FROM  200,1 TO 380,380 PIXEL
@ 10,018 Say " Este programa tem como objetivo atualizar os valores " 
@ 18,018 Say " de Vale Transporte de acordo com os valores  vigentes  "    
@ 26,018 Say " definidos pelo usuario."    
DEFINE SBUTTON FROM 65,096 TYPE 1 ACTION Processa( { || Letabela() } ) ENABLE OF oLeTxt
DEFINE SBUTTON FROM 65,126 TYPE 2 ACTION oLetxt:End() ENABLE OF oLeTxt    
DEFINE SBUTTON FROM 65,156 TYPE 5 ACTION Pergunte(cPerg, .t.)   ENABLE OF oLeTxt    
Activate Dialog oLeTxt Centered
Return

Static Function Letabela(lEnd)
Pergunte(cPerg,.f.)
DbSelectArea("SRN")
DbSetOrder(1)    
SRN->(DbSeek(XFILIAL("SRN") + MV_PAR01  ))
Do while ! SRN->(EOF())  .AND. SRN->RN_FILIAL = XFILIAL("SRN") .AND. SRN->RN_COD = MV_PAR01 
	RECLOCK("SRN",.F.)
	SRN->RN_UNIANT := SRN->RN_UNIATU
	SRN->RN_UNIATU := MV_PAR02
	MSUNLOCK()
	SRN->(DbSkip())
	INCPROC()
EndDo	
MSGSTOP("Processo de atualizacao de precos finalizado")   
Return       


/*
Funcao para criacao da pergunta, caso a mesma nao exista
*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta                      /Pergunta Espanhol			/Pergunta Ingles		/Variavel	/Tipo	/Tamanho	/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AAdd(aRegs,{cPerg,"01","Codigo : "        ,"Codigo : "   				,"Codigo "  			,"mv_ch1",	"C",		15      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SRN",			""})
AAdd(aRegs,{cPerg,"02","Valor  : "        ,"Valor  : "   				,"Valor  "  			,"mv_ch2",	"N",		08      ,2       ,		0 ,		"G"  ,		"",		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		""   ,			""})

  
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return