#INCLUDE 'RWMAKE.CH'               
#INCLUDE 'TOPCONN.CH'               

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TECRX041 �Autor  � Marcelo Munhoz     � Data �  20/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para exportar as movimentacoes de estoque e os    ���
���          � part numbers de laboratorio de acordo com status do IMEI.  ��� 
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function TECRX041()

Local aSay    := {}
Local aButton	 := {}
Local nOpc    := 0
Local cTitulo := "Gera��o de arquivo Excel com Movimenta��es de Estoque"
Local cDesc1  := "Este programa gera um arquivo Excel contendo as movimenta��es"
Local cDesc2  := "de estoque e as pe�as apontadas no laborat�rio."

Private cPerg := "TECRX040"
  u_GerA0003(ProcName())  
//�����������������������������������������������Ŀ
//�mv_par01 - Data Fase Inicial                   �
//�mv_par02 - Data Fase Final                     �
//�������������������������������������������������
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

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Gerando planilha Excel com moviment.estoque ...", .T. )

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RUNPROC  �Autor  � Marcelo Munhoz     � Data �  20/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que executa a geracao da planilha Excel             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunProc(lEnd)

Local _cDirDocs	:= alltrim(__RelDir)
Local _cArq		:= "Pecas_Estoque_Laboratorio"
Local _cArqTmp	:= lower(_cDirDocs+_cArq)
Local _nLinhas	:= 0
Local _cQuery		:= ""
Local _csrvapl	:= alltrim(getmv("MV_SERVAPL")) 

Private cCrLf   := Chr(13)+Chr(10)
Private nHandle   

// Executa stored procedure para criar a tabela com dados das fases x part number e efetua UPDATE com movimentos de estoque 
tcsqlexec("EXEC PROTHEUS.dbo.SP_PECAS_ESTOQUE_LAB '"+dtos(mv_par01)+"','"+dtos(mv_par02)+"','"+xFilial("SD3")+"'")

// Executa query para retornar valores da stored procedure
_cQuery += "SELECT * FROM PROTHEUS.dbo.##PCESTxLAB ORDER BY Produto"
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
	cLinha += TRB->Produto 			+ ';'
	cLinha += TRB->Descricao 		+ ';'
	cLinha += alltrim(str(TRB->L033P_E)) 		+ ';'
	cLinha += alltrim(str(TRB->L033P_S)) 		+ ';'
	cLinha += alltrim(str(TRB->L15PROC_E)) 	+ ';'
	cLinha += alltrim(str(TRB->L15PROC_S)) 	+ ';'
	cLinha += alltrim(str(TRB->L15AUDIT_E)) 	+ ';'
	cLinha += alltrim(str(TRB->L15AUDIT_S)) 	+ ';'
	cLinha += alltrim(str(TRB->L04_E))			+ ';'
	cLinha += alltrim(str(TRB->L04_S))			+ ';'
	cLinha += alltrim(str(TRB->EM_ATEND)) 	+ ';'
	cLinha += alltrim(str(TRB->OS_ENCER)) 	+ ';'
	cLinha += alltrim(str(TRB->FATURADO))

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � criacsv  �Autor  �                    � Data �    /  /     ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao statica para criacao do arquiivo csv                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static function CriaCSV(_cDirDocs,cArq)

nHandle := MsfCreate(_cDirDocs+"\"+cArq+".CSV",0)     

cLinha := ''
cLinha += 'Produto' 				+ ';'
cLinha += 'Descri��o' 			+ ';'
cLinha += 'ARM_033P_E' 			+ ';'
cLinha += 'ARM_033P_S' 			+ ';'
cLinha += 'ARM_15PROC_E' 		+ ';'
cLinha += 'ARM_15PROC_S' 		+ ';'
cLinha += 'ARM_15AUDIT_E' 		+ ';'
cLinha += 'ARM_15AUDIT_S' 		+ ';'
cLinha += 'ARM_04_E' 			+ ';'
cLinha += 'ARM_04_S' 			+ ';'
cLinha += 'EM_ATEND' 			+ ';'
cLinha += 'OS_ENCER' 			+ ';'
cLinha += 'FATURADO' 

fWrite(nHandle, cLinha  + cCrLf)

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CRIASX1  �Autor  �Microsiga           � Data �    /  /     ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para a criacao automatica das perguntas utilizadas  ���
���          � pela rotina.                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaSX1()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','Data Fase Inicial'			,'Data Fase Inicial'			,'Data Fase Inicial'			,'mv_ch1','D', 8,0,0,'G','',''		,'','S','mv_par01',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'02','Data Fase Final'			,'Data Fase Final'			,'Data Fase Final'			,'mv_ch2','D', 8,0,0,'G','',''		,'','S','mv_par02',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')

return()
