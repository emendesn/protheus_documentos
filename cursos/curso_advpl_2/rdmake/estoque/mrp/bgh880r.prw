#Include "MATR880.CH"
#Include "FIVEWIN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATR880   � Autor �Felipe Nunes Toledo    � Data � 11/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � MRP                                                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������           
*/
User Function BGH880R(lUsed)
Local   oReport

u_GerA0003(ProcName())

Default lUsed      := .F.

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |                 
//| nestes fontes. NAO REMOVER !!!                                  �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!")
EndIf
If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRX !!!")
EndIf
If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRX !!!")
EndIf

//�������������������������������������Ŀ
//�Ajuste da(s) pergunta(s)				�
//���������������������������������������
AjustaSX1()

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef(lUsed)
	oReport:PrintDialog()
Else
	BGH880R3(lUsed)
EndIf

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Felipe Nunes Toledo    � Data �11/07/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATR880			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(lUsed)
Local oReport
Local oSection1
Local cTitle    := OemToAnsi(STR0001) //"MRP"

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR880",cTitle,"MTR880", {|oReport| ReportPrint(oReport,cTitle,lUsed)},OemToAnsi(STR0002)) //"Este programa ira imprimir a Rela��o do MRP"
oReport:SetPortrait() //Define a orientacao de pagina do relatorio como paisagem.

//������������������������������������������������������������������������Ŀ
//�Criacao das secoes utilizadas pelo relatorio                            �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//�������������������������������������������������������������Ŀ
//� oSection1                                                   �
//���������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0027,{"SB1"},/*Ordem*/) //"Produtos"
oSection1:SetHeaderPage()

TRCell():New(oSection1,'B1_COD'    	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_UM'   	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_LE'   	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,  {|| RetFldProd(SB1->B1_COD,"B1_LE") })
TRCell():New(oSection1,'B1_ESTSEG' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,  {|| RetFldProd(SB1->B1_COD,"B1_ESTSEG") })
TRCell():New(oSection1,'B1_TIPO' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Felipe Nunes Toledo  � Data �11/07/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR880			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cTitle,lUsed)
Local oSection1   := oReport:Section(1)
Local oSection2
Local oSection3
Local oSection4
Local oSection5
Local oBreak
Local oFunction

Local lContinua   := .T.
Local aPeriodos   := {}
Local aPerOri     := {}
Local cDrvSHA     := ""
Local nTipo       := 0
Local aListaNec   := {}
Local cNecEstrAtu := ""
Local j           := 0
Local nCusto      := 0
Local cCondSH5    := "H5_PRODUTO != '"+Criavar("B1_COD",.F.)+"'"
Local aTam        := TamSX3("B2_QFIM")
Local nTotValor   := 0
Local lLogMrp
Local nParRel
Local cArquivo, cArquivo2
Local cSeekLog
Local i
Local cCampo
Local nQtdPer
Local lVNecesEst
Local lLista
Local lAchou     := .T.
Local cField
Local cFilUsrSB1 := ""  
Local nH5_Quant:=0                    
Local lPrograma  := .F.

Private aPerQuebra  := {}
Private cPerg       := "MTR880"
Private nPeriodos   := 0
Private nTipoCusto  := 1
Private lQuebraPer
Private nNumPer


#IFDEF WNTX
	cDrvSHA := "DBFNTX"
#ENDIF
#IFDEF WCDX
	cDrvSHA := "DBFCDX"
#ENDIF
#IFDEF WAXS
	cDrvSHA := "DBFCDXAX"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas (MTR880)                  �
//����������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                    �
//� mv_par01 - Lista ? Tudo     So' c/ Saidas   So' c/ Neces.               �
//� mv_par02 - De Produto                                                   �
//� mv_par03 - Ate Produto                                                  �
//� mv_par04 - Lista log de eventos  1 = sim 2 = nao                        �
//� mv_par05 - Custo Produto: 1-Custo Standard;2-Custo Medio;3-Preco Compra �
//� mv_par06 - Aglutina Periodos     1 = sim 2 = nao                        �
//� mv_par07 - Periodos para aglutina                                       �
//� mv_par08 - Lista a Necess. da Estrutura? 1 = sim 2 = nao                �
//���������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ
//� Inclui pergunta no SX1                                                  �
//���������������������������������������������������������������������������
PutSx1("MTR880","05","Custo Produto   "             ,"Costo Producto"			,"Product Cost"   		,"mv_ch5","N", 1,0,1,"C","",""   ,"","","mv_par05","Custo Standard","Costo Estandar","Standard Cost","","Custo Medio","Costo Promedio","Average Cost","Preco Compra","Precio Compra","Average Cost","","","","","", "", {"1) Custo Standard " , "2) Custo Medio "   , "3) Preco Compra" }, {"1) Costo Estandar", "2) Costo Promedio", "3) Precio Compra"}, {"1) Standard Cost" , "2) Average Cost"  , "3) Average Cost" })
PutSx1("MTR880","06","Aglutina Periodos"            ,"Agrupa Periodos ?"       	,"Group periods ?" 		,"mv_ch6","N", 1,0,2,"C","",""   ,"","","mv_par06","Sim"           ,"Si"            ,"Yes"          ,"","Nao"        ,"No"            ,"No"           ,""            ,""             ,""            ,"","","","","", "", {"Se informado Sim soma mais de um "        , "periodo na mesma coluna"}, {}, {})
PutSx1("MTR880","07","Periodos para aglutinar"      ,"Periodos para agrupar ?" 	,"Periods to group ?" 	,"mv_ch7","N", 3,0,8,"G","",""   ,"","","mv_par07",""              ,""              ,""             ,"",""           ,""              ,""            ,""            ,""             ,""            ,"","","","","", "", {"Numero de periodos a serem somados e "    , "exibidos em cada coluna"}, {}, {})
PutSx1("MTR880","08","Lista a Necess. da Estrutura?","Lista a Necess. da Estrutura?"              ,"Lista a Necess. da Estrutura?"               ,"mv_ch8","N", 1,0,2,"C","",""   ,"","","mv_par08","Sim"           ,"Si"              ,"Yes"             ,"","Nao"        ,"No"              ,"No"            ,""            ,""             ,""            ,"","","","","", "", {"Permite listar a necessidade da estru-" , "tura do produto caso exista"}, {}, {})

Pergunte(oReport:GetParam(),.F.)

nParRel     := mv_par01
nTipoCusto  := mv_par05
lLogMrp     := mv_par04==1
lQuebraPer  := mv_par06 == 1
nNumPer     := mv_par07
lVNecesEst  := mv_par08 ==1
nNumColPer	:= 0

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
If lUsed != .t.
	lContinua := A710OpenFMRP(.T.)
EndIf

If lContinua
	lPrograma := (SHA->(RecCount()) % 7) == 0

	dbSelectArea("SH5")
	If !Empty(dbFilter())
		dbClearFilter()
	EndIf
	dbSetOrder(1)
	dbGotop()
	
	//�������������������������������Ŀ
	//�Definindo o titulo do relatorio�
	//���������������������������������
	oReport:SetTitle(cTitle+" - "+STR0018+" "+SH5->H5_NUMMRP) //"MRP"##"Programacao"
	
	aPeriodos:=R880PER(@nTipo)
	
	If lQuebraPer
		aPerOri    := aClone(aPeriodos)
		aPerQuebra := R880DivPeriodo(aPeriodos, .T.)
		aPeriodos  := R880DivPeriodo(aPeriodos)
	EndIf
	
	dbSelectArea("SH5")
	Set Filter to &cCondSH5
EndIf

//�������������������������������������������������������������Ŀ
//� oSection2                                                   �
//���������������������������������������������������������������
oSection2 := TRSection():New(oSection1,cTitle,{"SHA","SB1","SH5"},/*Ordem*/) //"MRP"
oSection2:SetHeaderPage()

TRCell():New(oSection2,'HA_TEXTO','SHA','Periodos','',25,/*lPixel*/,/*{|| code-block de impressao }*/)
For i := 1 to Len(aPeriodos)
	cCampo := "HA_PER"+StrZero(i,3)
	TRCell():New(oSection2,cCampo,'SHA',DtoC(aPeriodos[i]),PesqPict("SB2","B2_QFIM"),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	oSection2:Cell(cCampo):SetLineBreak() // Define quebra de linha caso as colunas nao couberem na pagina
Next i
TRCell():New(oSection2,'HA_PRODUTO','SHA','Produto','',/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

//�������������������������������������������������������������Ŀ
//� oSection3                                                   �
//���������������������������������������������������������������
oSection3 := TRSection():New(oSection2,cTitle,{"SHA","SB1","SH5"},/*Ordem*/) //"MRP"
oSection3:SetHeaderPage(.F.)
oSection3:SetHeaderSection(.F.)

TRCell():New(oSection3,'HA_TEXTO','SHA',STR0026,'',25,/*lPixel*/,/*{|| code-block de impressao }*/)
For i := 1 to Len(aPeriodos)
	cCampo := "HA_PER"+StrZero(i,3)
	TRCell():New(oSection3,cCampo,'SHA',DtoC(aPeriodos[i]),PesqPict("SB2","B2_QFIM"),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	oSection2:Cell(cCampo):SetLineBreak() // Define quebra de linha caso as colunas nao couberem na pagina
Next i

If lVNecesEst //-- Lista Neces. da Estrutura
	//�������������������������������������������������������������Ŀ
	//� oSection4                                                   �
	//���������������������������������������������������������������
	oSection4 := TRSection():New(oSection2,cTitle,{"SHA","SB1","SH5"},/*Ordem*/) //"MRP"
	oSection4:SetHeaderPage(.F.)
	oSection4:SetHeaderSection(.F.)

	TRCell():New(oSection4,'H5_DOC','SH5',STR0026,'',25,/*lPixel*/,/*{|| code-block de impressao }*/)
	For i := 1 to Len(aPeriodos)
		cCampo := "H5_PER"+StrZero(i,3)
		TRCell():New(oSection4,cCampo,'SH5',DtoC(aPeriodos[i]),PesqPict("SB2","B2_QFIM"),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		oSection4:Cell(cCampo):SetLineBreak() // Define quebra de linha caso as colunas nao couberem na pagina
	Next i
EndIf

If lLogMRP //-- Lista Log do MRP
	//�������������������������������������������������������������Ŀ
	//� oSection5 (Log do MRP)                                      �
	//���������������������������������������������������������������
	oSection5 := TRSection():New(oSection3,cTitle,{"SHA","SHG"},/*Ordem*/) //"MRP"
	oSection5:SetHeaderPage(.F.)
	oSection5:SetHeaderSection(.F.)
	
	TRCell():New(oSection5,'HG_LOGMRP','SHG',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	oSection5:Cell('HG_LOGMRP'):SetLineBreak() // Define quebra de linha caso as colunas nao couberem na pagina
EndIf

//��������������������
//�Definindo a Quebra�
//��������������������
oBreak := TRBreak():New(oSection2,oSection2:Cell("HA_PRODUTO"),NIL,.F.)

If lContinua
	dbSelectArea("SHA")
	dbGotop()

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao ADVPL                          �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:GetParam())

	//�����������������������������Ŀ
	//�Posicionamento da tabela SB1 �
	//�������������������������������
	TRPosition():New(oSection1,"SB1",1,{||xFilial("SB1")+SHA->HA_PRODUTO })

	//�����������������
	//�Inibindo Celula�
	//�����������������
	oSection2:Cell("HA_PRODUTO"):Hide()
	oSection2:Cell("HA_PRODUTO"):HideHeader()
	
	//������������������������������������������������������������������������Ŀ
	//�Inicio da impressao do fluxo do relatorio                               �
	//��������������������������������������������������������������������������
	oReport:SetMeter( SHA->(LastRec()) )
	oSection1:Init()
	oSection2:Init()
	oSection3:Init()
	
	cFilUsrSB1:= oSection1:GetAdvplExp()
	nNumColPer := Len(aPeriodos)
	
	While !oReport:Cancel() .And. !SHA->(Eof())
		If !Empty(cFilUsrSB1)
		    SB1->(MsSeek(xFilial("SB1")+SHA->HA_PRODUTO))
		    If !(&("SB1->"+cFilUsrSB1))
		       SHA->(dbSkip())
	    	   Loop
	    	EndIf   
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Condicao de Filtragem do SHA                                 �
		//���������������������������������������������������������������� 
		lLista := (SHA->HA_PRODUTO >= MV_PAR02 .And. SHA->HA_PRODUTO <= MV_PAR03)
		If lLista
			lLista := R880FILTRO(nParRel,nTipo) //-- Filtro conforme MV_PAR01
		EndIf
		If lLista
			oSection1:PrintLine() //-- Impressao da secao 1
			oReport:SkipLine()
	        cProdAnt := SHA->HA_PRODUTO
	        cSeekLog := SHA->HA_NUMMRP+SHA->HA_PRODUTO
    	   	nPerIni  := 1
	        While SHA->HA_PRODUTO == cProdAnt
				If SHA->HA_TIPO == '7'
					SHA->(dbSkip())
					Loop
				EndIf
    	        If lQuebraPer
					For i := 1 to 6
						For j := 1 to 6
							If j > Len(aPeriodos)
								Exit
							EndIf
							nQtdPer := R880ValField(j)
							cCampo  := "HA_PER"+StrZero(j,3)
							oSection2:Cell(cCampo):SetValue( nQtdPer )
						Next
						oReport:IncMeter()
						oSection2:PrintLine() //-- Impressao da secao 2
						SHA->(dbSkip())
					Next
				Else
					oReport:IncMeter()
					oSection2:PrintLine() //-- Impressao da secao 2
					SHA->(dbSkip())
				EndIf
			EndDo
			
			//��������������������������������Ŀ
			//�Definindo o Valor da Necessidade�
			//����������������������������������
			nTotValor := 0
			SHA->(dbSkip(If(lPrograma,-2,-1)))
		   	oSection3:Cell('HA_TEXTO'):SetValue("Valor")
			For i:= 1 To Len(aPeriodos)
	  			nCusto	:= R880Custo(SHA->HA_PRODUTO)
	  			nQtdPer := R880ValField(i)
	  			cCampo  := "HA_PER"+StrZero(i,3)
				oSection3:Cell(cCampo):SetValue( nQtdPer * nCusto )
				nTotValor += oSection3:Cell(cCampo):GetValue()
	        Next i	
			oSection3:PrintLine() //-- Impressao da secao 3
			SHA->(dbSkip(If(lPrograma,2,1)))    
			
		    //�������������������������������������������������������������������������Ŀ
			//� Lista a necessidade da estrutura do produto possicionado a partir da    �
			//� da tabela SH5 com H5_ALIAS igual a "SHA".                               �
			//���������������������������������������������������������������������������
			aAreaAtu := GetArea()
			If lVNecesEst 
				oSection4:Init()
				SH5->(dbSetOrder(3))
				If (lAchou:=SH5->(dbSeek(cProdAnt+"SHA")))
					oReport:SkipLine()
					oReport:PrintText(STR0022)
				EndIf
				nH5_Quant:=0
				
				_aStru	:= {}

				AADD(_aStru,{"MODELO","C",15,0})
				
				For nx:=1 To nNumColPer
					cCampo  := "H5_PER"+StrZero(nx,3) 
					AADD(_aStru,{cCampo,"N",14,4})
				Next nx
				
				_cArq     := CriaTrab(_aStru,.T.)
				
				_cIndice  := CriaTrab(Nil,.F.)
								
				If Sele("TRB") <> 0
					TRB->(DbCloseArea())
				Endif
				
				_cChaveInd	:= "MODELO"
							
				dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
				
				IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")
								
				While SH5->(!Eof() .AND. H5_PRODUTO+H5_ALIAS==cProdAnt+"SHA")
					
					dbSelectArea("TRB")
					If !dbSeek(SH5->H5_DOC)
						RecLock("TRB",.T.)
						TRB->MODELO := SH5->H5_DOC
					Else
						RecLock("TRB",.F.)					
					Endif
										
					For i:= 1 To nNumColPer
						cCampo  := "H5_PER"+StrZero(i,3) 
						If SH5->H5_PRODUTO+SH5->H5_ALIAS==cProdAnt+"SHA" .And. SH5->H5_PER==StrZero(i,3) //(LASTDAY(SH5->H5_DATAORI)==LASTDAY(aPeriodos[i]))
						 	if !lQuebraPer
						 		&("TRB->"+cCampo) := SH5->H5_QUANT
						 	else
						 		nH5_Quant+=SH5->H5_QUANT
							Endif
							Exit
						EndIf
					Next i 
					MsUnlock()
				
					SH5->(dbSkip())
				
				EndDo
				
				dbSelectArea("TRB")				
				dbGotop()
				While TRB->(!Eof())
					oSection4:Cell('H5_DOC'):SetValue( TRB->MODELO )
					For i:= 1 To nNumColPer
						cCampo  := "H5_PER"+StrZero(i,3) 
						oSection4:Cell(cCampo):SetValue(&("TRB->"+cCampo))  
					Next i 
					if !lQuebraPer
						oSection4:PrintLine() //-- Impressao da secao 4
					EndIf
					TRB->(dbSkip())
				EndDo
				/*
				While SH5->(!Eof() .AND. H5_PRODUTO+H5_ALIAS==cProdAnt+"SHA")
					oSection4:Cell('H5_DOC'):SetValue( SH5->H5_DOC )
					For i:= 1 To nNumColPer
						cCampo  := "H5_PER"+StrZero(i,3) 
						If SH5->H5_PRODUTO+SH5->H5_ALIAS==cProdAnt+"SHA" .And. (SH5->H5_DATAORI==aPeriodos[i] .Or.;
						 (i==1 .And. nNumColPer>1 .And. SH5->H5_DATAORI < aPeriodos[i+1]) .Or.;
						 (i >1 .And. nNumColPer>1 .And. i< nNumColPer .And. SH5->H5_DATAORI < aPeriodos[i+1] .And. SH5->H5_DATAORI > aPeriodos[i-1]))
							if !lQuebraPer
						 		oSection4:Cell(cCampo):SetValue( SH5->H5_QUANT )  
						 	else
						 		nH5_Quant+=SH5->H5_QUANT
							Endif
							If SH5->(!Eof())  
								SH5->(dbSkip())
							Endif
						Elseif !lQuebraPer
							oSection4:Cell(cCampo):SetValue( 0 )
							If i == nNumColPer  // Encontra-se fora do aPeriodos
								If SH5->(!Eof())  
									SH5->(dbSkip())
								Endif
							EndIf
						EndIf
					Next i 
					if !lQuebraPer
						oSection4:PrintLine() //-- Impressao da secao 4
					EndIf
				EndDo
				*/
				if lQuebraPer .And. lAchou
					oSection4:Cell(cCampo):SetValue( nH5_Quant )  
					oSection4:PrintLine() //-- Impressao da secao 4
				EndIf
				
				If Sele("TRB") <> 0
					TRB->(DbCloseArea())
				Endif
				
				oSection4:Finish()
			EndIf
			RestArea(aAreaAtu)
   			oReport:SkipLine()
		    //�������������������������������Ŀ
			//�Imprime o Vlr. Total do Produto�
			//���������������������������������
		    oReport:PrintText(STR0021+"          "+Str(nTotValor,aTam[1],aTam[2]))
		    
 			// Lista os eventos de log desse produto
			If lLogMrp
				oSection5:Init()
				dbSelectArea("SHG")
				If dbSeek(xFilial("SHG")+cSeekLog)
					oReport:PrintText(STR0019) //"Eventos relacionados ao produto"
					While !EOF() .AND. xFilial("SHG")+cSeekLog == HG_FILIAL+HG_SEQMRP+HG_COD
						oSection5:PrintLine() //-- Impressao da secao 5
						SHG->(dbSkip())
					EndDo
				EndIf
				oSection5:Finish()
				oReport:SkipLine()
				dbSelectArea("SHA")
			EndIf
			oReport:ThinLine()
		Else
	    	SHA->(dbSkip(If(lPrograma,7,6)))
	    EndIf
	EndDo
	oSection3:Finish()
	oSection2:Finish()
	oSection1:Finish()

EndIf
If lContinua .And. lUsed != .t.
	dbSelectArea("SHA")
	dbCloseArea()
	dbSelectArea("SH5")
	dbCloseArea()
ElseIf lContinua
	SHA->(dbClearFilter())
	SH5->(dbClearFilter())
EndIF

dbSelectArea("SB1")
dbClearFilter()
dbSetOrder(1)

Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA        �Programa    MATR880.PRW ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data          |BOPS             ���
�������������������������������������������������������������������������Ĵ��
���      01  �Flavio Luiz Vicco         � 27/04/2006    |   00000097325   ���
���      02  �Flavio Luiz Vicco         � 18/01/2006    |                 ���
���      03  �Erike Yuri da Silva       � 02/06/2006    |   00000099418   ��� <-- Devido os arquivos principais serem binarios nao foi incluida nenhuma query
���      04  �Erike Yuri da Silva       � 02/06/2006    |   00000099418   ���
���      05  �Flavio Luiz Vicco         � 27/04/2006    |   00000097325   ���
���      06  �Flavio Luiz Vicco         � 16/03/2006    |   00000094092   ���
���      07  �Flavio Luiz Vicco         � 15/02/2006    |   00000089829   ���
���      08  �Flavio Luiz Vicco         � 16/03/2006    |   00000094092   ���
���      09  �Flavio Luiz Vicco         � 15/02/2006    |   00000089829   ���
���      10  �Flavio Luiz Vicco         � 18/01/2006    |                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR880  � Autor �Rodrigo de A Sartorio  � Data � 02/09/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �  MRP                                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR880(void)                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function BGH880R3(lUsed)
Local titulo   := STR0001  // "MRP"
LOCAL cString  := "SB1"
Local wnrel    := "MATR880"
Local cDesc    := STR0002  //"Este programa ira imprimir a Rela��o do MRP"
Local tamanho  := "M"
Local aArea    := GetArea()
Local aAreaSHA := {}
Local aAreaSH5 := {}
Local nParRel,cProdIni,cProdFim,lLogMrp,lVNecesEst
Local lContinua:= .T.
DEFAULT lUsed       := .F.
PRIVATE aReturn     := {STR0003,1,STR0004, 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nLastKey    := 0
PRIVATE cPerg       := "MTR880"
Private nTipoCusto  := 1
Private nPeriodos   := 0

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!                                  �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!")
EndIf
If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRX !!!")
EndIf
If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRX !!!")
EndIf

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                    �
//� mv_par01 - Lista ? Tudo     So' c/ Saidas   So' c/ Neces.               �
//� mv_par02 - De Produto                                                   �
//� mv_par03 - Ate Produto                                                  �
//� mv_par04 - Lista log de eventos  1 = sim 2 = nao                        �
//� mv_par05 - Custo Produto: 1-Custo Standard;2-Custo Medio;3-Preco Compra �
//� mv_par06 - Aglutina Periodos     1 = sim 2 = nao                        �
//� mv_par07 - Periodos para aglutina                                       �
//� mv_par08 - Lista a Necess. da Estrutura? 1 = sim 2 = nao                �
//���������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ
//� Inclui pergunta no SX1                                                  �
//���������������������������������������������������������������������������

PutSx1("MTR880","05","Custo Produto   "             ,"Costo Producto"			,"Product Cost"   		,"mv_ch5","N", 1,0,1,"C","",""   ,"","","mv_par05","Custo Standard","Costo Estandar","Standard Cost","","Custo Medio","Costo Promedio","Average Cost","Preco Compra","Precio Compra","Average Cost","","","","","", "", {"1) Custo Standard " , "2) Custo Medio "   , "3) Preco Compra" }, {"1) Costo Estandar", "2) Costo Promedio", "3) Precio Compra"}, {"1) Standard Cost" , "2) Average Cost"  , "3) Average Cost" })
PutSx1("MTR880","06","Aglutina Periodos"            ,"Agrupa Periodos ?"       	,"Group periods ?" 		,"mv_ch6","N", 1,0,2,"C","",""   ,"","","mv_par06","Sim"           ,"Si"            ,"Yes"          ,"","Nao"        ,"No"            ,"No"           ,""            ,""             ,""            ,"","","","","", "", {"Se informado Sim soma mais de um "        , "periodo na mesma coluna"}, {}, {})
PutSx1("MTR880","07","Periodos para aglutinar"      ,"Periodos para agrupar ?" 	,"Periods to group ?" 	,"mv_ch7","N", 3,0,8,"G","",""   ,"","","mv_par07",""              ,""              ,""             ,"",""           ,""              ,""            ,""            ,""             ,""            ,"","","","","", "", {"Numero de periodos a serem somados e "    , "exibidos em cada coluna"}, {}, {})
PutSx1("MTR880","08","Lista a Necess. da Estrutura?","Lista a Necess. da Estrutura?"              ,"Lista a Necess. da Estrutura?"               ,"mv_ch8","N", 1,0,2,"C","",""   ,"","","mv_par08","Sim"           ,"Si"              ,"Yes"             ,"","Nao"        ,"No"              ,"No"            ,""            ,""             ,""            ,"","","","","", "", {"Permite listar a necessidade da estru-" , "tura do produto caso exista"}, {}, {})

Pergunte(cPerg,.F.)

wnrel       := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,"",,Tamanho)
nParRel     := mv_par01
cProdIni    := mv_par02
cProdFim    := mv_par03
lLogMrp     := mv_par04==1
nTipoCusto  := mv_par05
lQuebraPer  := mv_par06 == 1
nNumPer     := mv_par07
lVNecesEst  := mv_par08 ==1

If nLastKey = 27
	dbClearFilter()
	lContinua := .F.
EndIf

If lContinua
	SetDefault(aReturn,cString)
EndIf

If lContinua .And. nLastKey = 27
	dbClearFilter()
	lContinua := .F.
EndIf

If lContinua
	If lUsed
		aAreaSHA:=SHA->(GetArea());aAreaSH5:=SH5->(GetArea())
	EndIf
	RptStatus({|lEnd| R880Imp(@lEnd,wnRel,titulo,tamanho,lUsed,nParRel,cProdIni,cProdFim,lLogMrp,lVNecesEst)},titulo)
	If lUsed
		RestArea(aAreaSHA)
		RestArea(aAreaSH5)
	EndIf
EndIf

RestArea(aArea)
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R880Imp  � Autor �Rodrigo de A Sartorio  � Data � 02/09/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR880                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R880Imp(lEnd,wnRel,titulo,tamanho,lUsed,nParRel,cProdIni,cProdFim,lLogMrp,lVNecesEst)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt,j
LOCAL CbCont,cabec1,cabec2,i
LOCAL limite    := 132
LOCAL nomeprog  := "MATR880"
LOCAL cArquivo,cArquivo2,nTotLin,cSeekLog:="",cNecEstrAtu := ""
LOCAL aOrdem    := Array(6), lLista, lImprimiu
LOCAL cCondSH5  := "H5_PRODUTO != '"+Criavar("B1_COD",.F.)+"'"
LOCAL aPeriodos := {}
Local aPerOri   := {}
LOCAL nTotProd  := 0
LOCAL nTotal    := 0
LOCAL cDrvSHA   := ""
LOCAL nTipo     := 0
Local aNeces    := {}
Local nNecEstr  := 0
Local nCusto    := 0
Local nQtdPer   := 0
Local aListaNec := {}
Local nC        := 0
Local lContinua	:= .T.
Local lPrograma := .F.

Private aPerQuebra := {}

#IFDEF WNTX
	cDrvSHA := "DBFNTX"
#ENDIF
#IFDEF WCDX
	cDrvSHA := "DBFCDX"
#ENDIF
#IFDEF WAXS
	cDrvSHA := "DBFCDXAX"
#ENDIF

aOrdem[1] := STR0005
aOrdem[2] := STR0006
aOrdem[3] := STR0007
aOrdem[4] := STR0017
aOrdem[5] := STR0008
aOrdem[6] := STR0009

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
If lUsed != .t.
	lContinua := A710OpenFMRP(.T.)
EndIf

If lContinua
	lPrograma := (SHA->(RecCount()) % 7) == 0
	
	dbSelectArea("SH5")
	If !Empty(dbFilter())
		dbClearFilter()
	EndIf
	dbSetOrder(1)
	dbGotop()
	
	dbSelectArea("SHG")
	dbSetOrder(1)
	
	aPeriodos:=R880PER(@nTipo)
	
	If lQuebraPer
		aPerOri    := aClone(aPeriodos)
		aPerQuebra := R880DivPeriodo(aPeriodos, .T.)
		aPeriodos  := R880DivPeriodo(aPeriodos)
	EndIf
	
	dbSelectArea("SH5")
	Set Filter to &cCondSH5
EndIf	

If lContinua
	dbSelectArea("SHA")
	dbGotop()
	SetRegua(LastRec())
	Titulo  := Titulo+" - "+STR0018+" "+SHA->HA_NUMMRP
	NTotLin := Len(aPeriodos) / 5
	nTotLin := If(Len(aPeriodos) % 6 > 0,++nTotLin,nTotLin)
	While !Eof()
		If lEnd
			@ Prow()+1,001 PSay STR0011	//"CANCELADO PELO OPERADOR"
			Exit
		EndIf
		IncRegua()
		nRec := Recno()
		cSeekLog  := SHA->HA_NUMMRP+SHA->HA_PRODUTO
		lImprimiu := .F.
		If SHA->HA_PRODUTO >= cProdIni .And. SHA->HA_PRODUTO <= cProdFim .And. SB1->(dbSeek(xFilial("SB1")+SHA->HA_PRODUTO))
			If li > 50
				cabec(titulo,"","",nomeprog,tamanho,18)
				@ li,00 PSay __PrtFatLine()
				li++
			EndIf
			lLista		:= R880FILTRO(nParRel,nTipo)
			lImprimiu	:= .f.
			If lLista
				nTotProd	:= 0
				lImprimiu	:= .t.
				nCusto		:= R880Custo(SB1->B1_COD)
				@ li,00 PSay STR0012 +SB1->B1_COD +SPACE(3) + Substr(SB1->B1_DESC,1,30) + SPACE(3) +STR0013;	//"PRODUTO: "###"UM:"
				+ SB1->B1_UM + SPACE(3)+STR0014 + Str(RetFldProd(SB1->B1_COD,"B1_LE"), Posicione("SX3", 2, "B1_LE", "X3_TAMANHO"), Posicione("SX3", 2, "B1_LE", "X3_DECIMAL")) + SPACE(3) + Upper(AllTrim(RetTitle("B1_ESTSEG"))) + ": " + Str(RetFldProd(SB1->B1_COD,"B1_ESTSEG"), Posicione("SX3", 2, "B1_ESTSEG", "X3_TAMANHO"), Posicione("SX3", 2, "B1_ESTSEG", "X3_DECIMAL")) + Space(3) + STR0015+ SB1->B1_TIPO	//"LOTE ECON: "### "TIPO: "
				li++
				dbSelectArea("SHA")
				nPerIni := 1
				While .t.
					dbGoto(nRec)
					nCol := 23
					li++
					// ---- Imprime Periodos
					@ li,00 PSay STR0016  //"Periodos"
					If lQuebraPer .And. nNumPer > 1
						@ li,10 PSay STR0024  //"(inicial)"
					EndIf
					For i:= nPerIni to nPerIni+5
						If i > Len(aPeriodos)
							Exit
						EndIf
						@ li,nCol PSay DtoC(aPeriodos[i])
						nCol += 15
					Next i
					// ---- Se Aglutina em mais de 1 periodo, Imprime data final do periodo
					If lQuebraPer .And. nNumPer > 1
						nCol := 23
						li++
						@ li,10 PSay STR0025  //"(final)"
						For i:= nPerIni to nPerIni+5
							If i > Len(aPeriodos)
								Exit
							EndIf
							// ---- Calcula posicao no array de periodos
							// ---- = (coluna-1)*nro.periodos p/ aglutinar+len(array periodos aglutinados)
							nC := (i-1)*nNumPer+Len(aPerQuebra[i,2])
							@ li,nCol PSay DtoC(aPerOri[nC])
							nCol += 15
						Next i
					EndIf
					// ----
					li += 2
					aNeces := {}
					For i := 1 to 6
						nCol := 16
						@ li,00 PSay aOrdem[i]
						For j := nPerIni to nPerIni+5
							If j > Len(aPeriodos)
								Exit
							EndIf
	
							@ li,nCol PSay nQtdPer := R880ValField(j) Picture "999999999999.99"
							nCol+=15
							If i == 6
								aAdd(aNeces, nQtdPer)
								nTotProd+=nQtdPer
							EndIf
						Next
						SHA->(dbSkip())
						li++
					Next
					If SHA->HA_TIPO == '7'
						SHA->(dbSkip())
					EndIf
	
					nCol := 16
					@ li,00 PSay STR0020 // "Valor"
					For j := 1 to Len(aNeces)
						@ li,nCol PSay aNeces[j] * nCusto Picture "999999999999.99"
						nCol+=15
					Next
	
					//�������������������������������������������������������������������������Ŀ
					//� Lista a necessidade da estrutura do produto possicionado a partir da    �
					//� da tabela SH5 com H5_ALIAS igual a "SHA".                               �
					//���������������������������������������������������������������������������
					If lVNecesEst
						//Reposiciono no produto
						DbSelectArea("SHA")
						DbGoto(nRec)
						aListaNec := R880LstNec(SHA->HA_PRODUTO+"SHA",aPeriodos,nPerIni)
						If !Empty(aListaNec)
							li+=2
							@ li,00 PSay STR0022
							cNecEstrAtu := ""
							For i:=1 To Len(aListaNec)
								If cNecEstrAtu<>aListaNec[i,1] .Or. !lQuebraPer
									cNecEstrAtu := aListaNec[i,1]
									li++
								EndIf
								@ li,000 PSay aListaNec[i,1]
								nCol := 16
								For j := nPerIni to nPerIni+5
									If j > Len(aPeriodos)
										Exit
									EndIf
									nNecEstr := 0
									If aPeriodos[j]==aListaNec[i,3]
										nNecEstr := aListaNec[i,2]
									EndIf
									@ li,nCol PSay nNecEstr Picture "999999999999.99"
									nCol+=15
								Next
	
								If li > 60
									cabec(titulo,"","",nomeprog,tamanho,18)
									@ li,00 PSay __PrtFatLine()
									li++
								EndIf
							Next
							li++
						EndIf
					EndIf
					nPerIni+=6
					If nPerIni > Len(aPeriodos)
						Exit
					EndIf
					If li > 50
						cabec(titulo,"","",nomeprog,tamanho,18)
						@ li,00 PSay __PrtFatLine()
						li++
					EndIf
					li++
				Enddo
				li+= 2
	
				nCol := 16
				@ li,00 PSay STR0021	//"Tot Vl. Produto:"
				@ li,nCol PSay nTotProd * nCusto Picture "999999999999.99"
	
				li+= 2
				nTotProd := 0
			EndIf
	
			// Lista os eventos de log desse produto
			If lLogMrp
				dbSelectArea("SHG")
				If dbSeek(xFilial("SHG")+cSeekLog)
					If li > 50
						cabec(titulo,"","",nomeprog,tamanho,18)
					EndIf
					@ li,00 PSay OemToAnsi(STR0019) //"Eventos relacionados ao produto"
					li++
					li++
					While !EOF() .AND. xFilial("SHG")+cSeekLog == HG_FILIAL+HG_SEQMRP+HG_COD
						If li > 50
							cabec(titulo,"","",nomeprog,tamanho,18)
						EndIf
						@ li,00 PSay HG_LOGMRP
						li++
						dbSkip()
					End
					li++
				EndIf
			EndIf
			dbSelectArea("SHA")
		EndIf
		DbGoto(nRec)
		DbSkip(If(lPrograma,7,6))
		If lImprimiu
			@ li,00 PSay __PrtThinLine()
			li++
		EndIf
	End
	
	If li != 80
		roda(cbcont,cbtxt)
	EndIf

EndIf	
If lContinua .And. lUsed != .t.
	dbSelectArea("SHA")
	dbCloseArea()
	dbSelectArea("SH5")
	dbCloseArea()
EndIf
dbSelectArea("SB1")
dbClearFilter()
dbSetOrder(1)
If aReturn[5] = 1
	Set Printer TO
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()
Return NIL

/*
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � R880Per    � Autor �Rodrigo de A. Sartorio� Data � 03/02/97 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de montagem de array aperiodos para Impressao        ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � MATR880                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function R880PER(nTipo)
Local i, dInicio
Local aRet:={}
Local nPosAno, nTamAno, cForAno
Local lConsSabDom:=Nil
Pergunte("MTA712",.F.)
lConsSabDom:=mv_par12 == 1
Pergunte(cPerg, .F.)
If __SetCentury()
	nPosAno := 1
	nTamAno := 4
	cForAno := "ddmmyyyy"
Else
	nPosAno := 3
	nTamAno := 2
	cForAno := "ddmmyy"
EndIf
//�����������������������������������������������������������Ŀ
//� Adiciona registro em array totalizador utilizado no TREE  �
//�������������������������������������������������������������
dbSelectArea("SH5")
dbSetOrder(1)
dbGotop()
While !Eof()
	// Recupera parametrizacao gravada no ultimo processamento
	// A T E N C A O
	// Quando utilizado o processamento por periodos variaveis o sistema monta o array com
	// os periodos de maneira desordenada, por causa do indice do arquivo SH5
	// O array aRet � corrigido logo abaixo
	If H5_ALIAS == "PAR"
		nTipo       := H5_RECNO
		dInicio     := H5_DATAORI
		nPeriodos   := H5_QUANT
		If nTipo == 7
			AADD(aRet,DTOS(CTOD(Alltrim(H5_OPC))))
		EndIf
		//��������������������������������������������������������������Ŀ
		//� NUMERO DO MRP                                                �
		//����������������������������������������������������������������
		c711NumMRP:=H5_NUMMRP
	EndIf
	dbSkip()
End

//Somente para nTipo==7 (Periodos Diversos) re-ordena aRet
//pois como o H5_OPC esta gravado a data como caracter ex:(09/10/05)
//o arquivo esta indexado incorretamente (diferente de 20051009)
If !Empty(aRet)
	ASort(aRet)
	For i:=1 To Len(aRet)
		aRet[i] := STOD(aRet[i])
	Next i
EndIf

If (nTipo == 2)                         // Semanal
	While Dow(dInicio)!=2
		dInicio--
	EndDo
ElseIf (nTipo == 3) .or. (nTipo=4)      // Quinzenal ou Mensal
		dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6),cForAno)
ElseIf (nTipo == 5)                     // Trimestral
	If Month(dInicio) < 4
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
		dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >=10)
		dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7),cForAno)
	EndIf
ElseIf (nTipo == 6)                     // Semestral
	If Month(dInicio) <= 6
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
	Else
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
	EndIf
EndIf
If nTipo != 7
	For i := 1 to nPeriodos
		AADD(aRet,dInicio)
		If nTipo == 1
			dInicio ++
			While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
				dInicio++
			EndDo
		ElseIf nTipo == 2
			dInicio+=7
		ElseIf nTipo == 3
			dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
	 		If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
			Str(Year(dInicio)+1,4)+"0101")),cForAno)			
		ElseIf nTipo == 4
			dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 5
			dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 6
			dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		EndIf
	Next i
EndIf
Return aRet

Static Function R880FILTRO(nParRel,nTipo)
Local ni,lRet := .f.,cAlias := Alias(),nReg:=0
dbSelectArea("SHA")
nReg:=Recno()
If nParRel == 1
	lRet := .T.
ElseIf nParRel == 2
	dbSkip(2)
	For ni := 1 to nPeriodos
		cCampo := "HA_PER"+StrZero(ni,3)
		If &(cCampo) != 0
			lRet := .t.
			Exit
		EndIf
	Next
	If !lRet
		dbSkip()
		For ni := 1 to nPeriodos
			cCampo := "HA_PER"+StrZero(ni,3)
			If &(cCampo) != 0
				lRet := .t.
				Exit
			EndIf
		Next
	EndIf
ElseIf nParRel == 3
	dbSkip(5)
	For ni := 1 to nPeriodos
		cCampo := "HA_PER"+StrZero(ni,3)
		If &(cCampo) != 0
			lRet := .t.
			Exit
		EndIf
	Next
EndIf
dbGoto(nReg)
dbSelectArea(cAlias)
Return (lRet)



/*
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � R880LstNec     � Autor � Erike Y. da Silva� Data � 09/05/05 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Lista a estrutura da necessidade do produto                 ���
��������������������������������������������������������������������������Ĵ��
���Parametros� cChave  - Codigo do produto filho que sera usado na explosao���
���          �           da necessidade.                                   ���
���          � aPeriodos- Array com os periodos definidos pela parametrizac���
���          � nPerIni  - Periodo inicial a ser analisado no array aPeriodos��
��������������������������������������������������������������������������Ĵ��
��� Uso      � MATR880                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function R880LstNec(cChave,aPeriodos,nPerIni)
Local nPos,nI
Local nTamPer   := Len(aPeriodos)
Local lContinua := .F.
Local aLista    := {}
Local cAlias    := Alias()
Local aAreaSH5  := SH5->(GetArea())

DbSelectArea("SH5")
SH5->(dbSetOrder(3))
SH5->(dbSeek(cChave))
While SH5->(!Eof() .AND. H5_PRODUTO+H5_ALIAS==cChave)
	lContinua := .F.
	For nI:=nPerIni To nPerIni+5
		If nI> nTamPer
			Exit
		EndIf
		If aPeriodos[nI]==SH5->H5_DATAORI
			lContinua := .T.
			Exit
		EndIf
	Next

	If !lContinua
		SH5->(DbSkip())
		Loop
	EndIf

	nPos := AsCan(aLista,{|x|x[1]==SH5->H5_DOC .and. x[3]==SH5->H5_DATAORI})
	If Empty(nPos) .Or. !lQuebraPer
		SB1->(MsSeek(xFilial("SB1") + SH5->H5_DOC))
		Aadd(aLista,{SH5->H5_DOC,SH5->H5_QUANT,SH5->H5_DATAORI})
	Else
		aLista[nPos,2] += SH5->H5_QUANT
	EndIf
	SH5->(DbSkip())
EndDo

If !Empty(aLista)
	aLista := aSort(aLista,,,{|x,y|x[1]<y[1]})
EndIf

RestArea(aAreaSH5)           
DbSelectArea(cAlias)
Return aClone(aLista)

/*
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1      � Autor � Andre Anjos		 � Data � 21/10/08 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta as perguntas do relatorio                 		   ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � MATR880                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function AjustaSX1()

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek("MTR880    01") .And. AllTrim(X1_DEF03) == "S� c/ Nec."
	RecLock("SX1",.F.)
	Replace X1_DEF03 With "S� c/ Nec."
	MsUnLock()
EndIf

Return
