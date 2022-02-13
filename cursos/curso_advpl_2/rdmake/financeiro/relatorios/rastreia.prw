#INCLUDE "PROTHEUS.CH"

User Function Rastreia()

Local cPerg     := "CFG053"       //Grupo de perguntas que sera utilizado
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 

Return .t.                     



Static Function MyRel( cTabela, cUsuDe, cUsuAte, dDataDe, dDataAte, ;
                            cHoraDe, cHoraAte, nTipoLog )
                            
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())
Local cTipoLog    := ""               //Tipo de LOG para filtro no SXP
Local cArqSXP     := ""               //Alias para o IndRegua do SXP
Local cFiltro     := ""               //Filtro da tabela SXP
Local aStructSXP  := {}               //Estrutura do SXP
Local cChaveOld   := ""               //Chave antiga para adicionar registro no Temporario
Local nX          := 0                //Variavel de contador
Local nCount      := 0                //Contador de campos       
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

u_GerA0003(ProcName())


Default cUsuDe    := ""
Default cUsuAte   := Replicate("Z",15)
Default dDataDe   := CtoD("01/01/2002")
Default dDataAte  := CtoD("31/12/2049")
Default cHoraDe   := "00:00:00"
Default cHoraAte  := "99:99:99"
Default nTipoLog  := 4

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros do programa:                                                   ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³MV_PAR01 -> Familia de arquivos para visualizacao dos LOGS.               ³
//³MV_PAR02 -> Usuario de  ( Codigo de usuario inicial )                     ³
//³MV_PAR03 -> Usuario ate ( Codigo de usuario final )                       ³
//³MV_PAR04 -> Data de     ( Data inicial do LOG )                           ³
//³MV_PAR05 -> Data ate    ( Data final do LOG )                             ³
//³MV_PAR06 -> Hora de     ( Hora Inicial )                                  ³
//³MV_PAR07 -> Hora final  ( Hora final )                                    ³
//³MV_PAR08 -> Tipo de LOG / 1-Inclusao / 2-Alteracao / 3-Ambos              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a tabela nao foi parametrizada, faco a pergunta         				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType( cTabela ) == "U"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualizacao dos parametros.                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTabela   := MV_PAR01
	cUsuDe    := MV_PAR02
	cUsuAte   := MV_PAR03
	dDataDe   := MV_PAR04
	dDataAte  := MV_PAR05
	cHoraDe   := MV_PAR06
	cHoraAte  := MV_PAR07
	nTipoLog  := MV_PAR08
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Passo a escolha do parametro de tipo de LOG para string (Filtro no Indregua  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipoLog == 1
	cTipoLog += "064/"
ElseIf nTipoLog == 2
	cTipoLog += "128/"
ElseIf nTipoLog == 3
	cTipoLog += "256/"
ElseIf nTipoLog == 4
	cTipoLog += "064/128/256/"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Crio o arquivo temporario com a estrutura igual ao SXP   			       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SXP" )
aStructSXP := dbStruct()
cArqSXP    := CriaTrab( aStructSXP, .T. )
dbUseArea( .T.,, cArqSXP, "TMPSXP", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faco o filtro do arquivo SXP para inserir ao temporario  				    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SXP" )

If !Empty(cTabela)
	cFiltro += "XP_ALIAS = '"+cTabela+"'
EndIf                                           
If !Empty(cUsuDe)
	If len(cFiltro) > 0
		cFiltro += " .And. "
	EndIf
	cFiltro += "XP_USER >= '"+cUsuDe+"' 
EndIf
If !Empty(cUsuAte)
	If len(cFiltro) > 0
		cFiltro += " .And. "
	EndIf
	cFiltro += "XP_USER <= '"+cUsuAte+"' 
EndIf

If !Empty(Dtos(dDataDe))
	If len(cFiltro) > 0
		cFiltro += " .And. "
	EndIf
	cFiltro += "DtoS(XP_DATA) >= '"+DtoS(dDataDe)+"' 
EndIf                                              

If !Empty(DtoS(dDataAte))  
	If len(cFiltro) > 0
		cFiltro += " .And. "
	EndIf
	cFiltro += "DtoS(XP_DATA) <= '"+DtoS(dDataAte)+"' 
EndIf                                                 

If !Empty(cHoraDe)
	If len(cFiltro) > 0
		cFiltro += " .And. "
	EndIf
	cFiltro += "XP_TIME >= '"+cHoraDe+"' 
EndIf	

If !Empty(cHoraAte)	
	If len(cFiltro) > 0
		cFiltro += " .And. "
	EndIf
	cFiltro += "XP_TIME <= '"+cHoraAte+"' 
EndIf

If !Empty(cTipoLog)
	If len(cFiltro) > 0
		cFiltro += " .And. "
	EndIf
	cFiltro += "StrZero(XP_OPER,3,0) $ '"+cTipoLog+"'"
EndIf

IndRegua( "SXP", cArqSXP ,"XP_ALIAS+XP_ID",,cFiltro )
dbSetOrder( 1 )
dbGotop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preencho o Temporario com os dados do SXP para o cabecalho do programa   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChaveOld   := ""
Do While !Eof()
	If cChaveOld != XP_ALIAS + XP_ID
		cChaveOld := XP_ALIAS + XP_ID
		
		dbSelectArea( "TMPSXP" )
		nCount := FCount()
		
		RecLock( "TMPSXP" , .T. )
		For nX := 1 to nCount
			FieldPut( nX, SXP->(FieldGet(nX)) )
		Next nX
		MsUnlock()
		
	EndIf
	
	dbSelectArea( "SXP" )
	dbSkip()
EndDo

TMPSXP->( dbGotop() )
ProcRegua(Reccount())
If dbSeek( cTabela )
	dbSeek( cSeekWhile := TMPSXP->XP_ALIAS + TMPSXP->XP_ID )
	clinha := ''
	cLinha += "TABELA " + ';' + ' CHAVE' + ';' + 'OPERACAO' + ';' + 'USUARIO' + ';'  + 'DATA' + ';' + 'HORA' +';' + 'CAMPO' + ';' + 'DE ' + ';'+ 'PARA' + ';'
	fWrite(nHandle, cLinha  + cCrLf)		                                                    
	Do While !Eof()  
		cSeekWhile =XP_ALIAS + XP_ID
		clinha := ''
		cLinha += XP_ALIAS + ';' + alltrim(XP_UNICO) + ';' + Iif(XP_OPER=64,'INCLUSAO',Iif(XP_OPER=128,'ALTERACAO','EXCLUSAO')) + ';' + XP_USER + ';'  + Dtoc(XP_DATA) + ';' + XP_TIME +';' +';' + ';'+ ';' + ';'
		fWrite(nHandle, cLinha  + cCrLf)		                                                    
		Do While !Eof() .And. cSeekWhile = XP_ALIAS + XP_ID            
			IncProc()      
			clinha := ''
			cLinha += '' + ';' + '' + ';' + ''+ ';' + '' + ';'  + '' + ';' + ''+';' +alltrim( XP_CAMPO)+" ;" + ALLTRIM(XP_ANTVAL )+ ';'+ ALLTRIM(XP_NOVVAL) + ';'
			fWrite(nHandle, cLinha  + cCrLf)		                                                    
			dbSkip()
		EndDo

	EndDo	
Else
	MsgStop( "Não existe tabelas para serem selecionados.", "Atenção")
EndIf


		                                
fClose(nHandle)
//CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
Return .t.		
	
dbSelectArea( "TMPSXP" )
dbCloseArea()
FErase( cArqSXP+GetDBExtension() )

dbSelectArea( "SXP" )
FErase( cArqSXP + OrdBagExt() )

Return Nil