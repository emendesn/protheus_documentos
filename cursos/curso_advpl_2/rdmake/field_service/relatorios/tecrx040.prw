#INCLUDE 'RWMAKE.CH'               
#INCLUDE 'TOPCONN.CH'               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX040 บAutor  ณ Marcelo Munhoz     บ Data ณ  20/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para exportar as pecas apontadas no laboratorio   บฑฑ
ฑฑบ          ณ demonstrando as movimentacoes de estoque geradas.          บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function TECRX040()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Gera็ใo de arquivo Excel com Pe็as Apontadas"
Local cDesc1  := "Este programa gera um arquivo Excel contendo os part numbers"
Local cDesc2  := "apontados no Laborat๓rio e as respectivas movimenta็๕es de estoque."

Private cPerg := "TECRX040"

     u_GerA0003(ProcName()) //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Data Fase Inicial                   ณ
//ณmv_par02 - Data Fase Final                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Gerando planilha Excel com pe็as apontadas...", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RUNPROC  บAutor  ณ Marcelo Munhoz     บ Data ณ  20/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que executa a geracao da planilha Excel             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

Local _cDirDocs	:= alltrim(__RelDir)
Local _cArq		:= "Pecas_Laboratorio_Estoque"
Local _cArqTmp	:= lower(_cDirDocs+_cArq)
Local _nLinhas	:= 0
Local _cQuery		:= ""
Local _csrvapl	:= alltrim(getmv("MV_SERVAPL")) 

Private cCrLf   := Chr(13)+Chr(10)
Private nHandle   

// Executa stored procedure para criar a tabela com dados das fases x part number e efetua UPDATE com movimentos de estoque 
tcsqlexec("EXEC PROTHEUS.dbo.SP_PECAS_LAB_ESTOQUE '"+dtos(mv_par01)+"','"+dtos(mv_par02)+"','" + xFilial("SD3") + "'")

// Executa query para retornar valores da stored procedure
_cQuery += "SELECT * FROM PROTHEUS.dbo.PCLABxEST"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)

// Cria arquivo CSV 
CriaCSV(_cDirDocs,_cArq)

// Alimenta arquivo CSV com dados da Query
ProcRegua(TRB->(reccount()))

TRB->(dbGoTop())
While TRB->(!eof())
	
	// Incrementa a regua
	IncProc()

	cLinha := ''
	cLinha += TRB->ZZ4_IMEI 			+ ';'
	cLinha += TRB->ZZ4_OS 			+ ';'
	cLinha += TRB->ZZ4_OPEBGH 		+ ';'
	cLinha += TRB->ZZ4_TRANSC 		+ ';'
	cLinha += TRB->ZZ4_STATUS 		+ ';'
	cLinha += TRB->ZZ4_MCLGER 		+ ';'
	cLinha += TRB->ZZ3_SEQ 			+ ';'
	cLinha += DTOC(STOD(TRB->ZZ3_DATA))+ ';'
	cLinha += TRB->ZZ3_ENCOS 		+ ';'
	cLinha += TRB->ZZ3_ESTORN 		+ ';'
	cLinha += TRB->Z9_ITEM 			+ ';'
	cLinha += TRB->Z9_PARTNR 		+ ';'
	cLinha += ALLTRIM(STR(TRB->Z9_QTY))		+ ';'
	cLinha += TRB->Z9_NUMSEQP 		+ ';'
	cLinha += DTOC(STOD(TRB->DATA_MOVP)) 		+ ';'
	cLinha += TRB->ARM_SAIP 			+ ';'
	cLinha += TRB->END_SAIP 			+ ';'
	cLinha += TRB->ARM_ENTP 			+ ';'
	cLinha += TRB->END_ENTP 			+ ';'
	cLinha += TRB->Z9_NUMSEQ 		+ ';'
	cLinha += DTOC(STOD(TRB->DATA_MOVE)) 		+ ';'
	cLinha += TRB->ARM_SAIE 			+ ';'
	cLinha += TRB->END_SAIE 			+ ';'
	cLinha += TRB->ARM_ENTE 			+ ';'
	cLinha += TRB->END_ENTE

	fWrite(nHandle, cLinha + cCrLf)
	_nLinhas++

	TRB->(dbSkip())
	
Enddo

fClose(nHandle)

TRB->(dbCloseArea())

// Abre Excel automaticamente
if _nLinhas > 0
	
	If !ApOleClient( 'MsExcel' )
		MsgAlert( "Excel nao Instalado. Abrir manualmente o arquivo "+alltrim(_cArq)+" gerado na pasta "+alltrim(__reldir)+"." ) //'MsExcel nao instalado'
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf
	
else
	MsgAlert( "Arquivo vazio. Excel nao gerado. " )
endif

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ criacsv  บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao statica para criacao do arquiivo csv                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function CriaCSV(_cDirDocs,cArq)

nHandle := MsfCreate(_cDirDocs+"\"+cArq+".CSV",0)     

cLinha := ''
cLinha += 'IMEI' 				+ ';'
cLinha += 'OS' 				+ ';'
cLinha += 'OPERACAO' 		+ ';'
cLinha += 'TRANSC' 			+ ';'
cLinha += 'STATUS' 			+ ';'
cLinha += 'ARQ_MCLGER' 		+ ';'
cLinha += 'SEQ_FASE' 		+ ';'
cLinha += 'DATA_FASE' 		+ ';'
cLinha += 'ENCERRA_OS' 		+ ';'
cLinha += 'ESTORNO' 			+ ';'
cLinha += 'ITEM' 				+ ';'
cLinha += 'PARTNR' 			+ ';'
cLinha += 'QTY' 				+ ';'
cLinha += 'NUMSEQ_PROC' 		+ ';'
cLinha += 'DATA_MOV_PROC' 	+ ';'
cLinha += 'ARM_SAI_PROC' 	+ ';'
cLinha += 'END_SAI_PROC' 	+ ';'
cLinha += 'ARM_ENT_PROC' 	+ ';'
cLinha += 'END_ENT_PROC' 	+ ';'
cLinha += 'NUMSEQ_ENC' 		+ ';'
cLinha += 'DATA_MOV_ENC' 	+ ';'
cLinha += 'ARM_SAI_ENC' 		+ ';'
cLinha += 'END_SAI_ENC' 		+ ';'
cLinha += 'ARM_ENT_ENC' 		+ ';'
cLinha += 'END_ENT_ENC'

fWrite(nHandle, cLinha  + cCrLf)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas utilizadas  บฑฑ
ฑฑบ          ณ pela rotina.                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','Data Fase Inicial'			,'Data Fase Inicial'			,'Data Fase Inicial'			,'mv_ch1','D', 8,0,0,'G','',''		,'','S','mv_par01',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'02','Data Fase Final'			,'Data Fase Final'			,'Data Fase Final'			,'mv_ch2','D', 8,0,0,'G','',''		,'','S','mv_par02',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')

return()
