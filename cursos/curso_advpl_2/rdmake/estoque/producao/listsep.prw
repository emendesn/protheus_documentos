#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LISTSEP  � Autor � Eduardo Barbosa( Delta)�Data � 08/03/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista de Separa��o Etiqueta Master Para a Produ��o         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PCP - BGH                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function LISTSEP()

Local oReport
Private cPerg := "LISSEP"


u_GerA0003(ProcName())
//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport:= ReportDef()
oReport:SetTotalInLine(.F.)
oReport:PrintDialog()
	
Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Eduardo Barbosa( Delta)�Data � 08/03/12         ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
/*/

Static Function ReportDef()
Local oReport
Local oSection1, oSection2, oSection3
Local cTitle	:= "Lista Separacao Para Producao" 

ValPerg(cPerg)
Pergunte(cPerg,.F.)

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

oReport:= TReport():New("LISTSEP",cTitle,cPerg, {|oReport| ReportPrint(oReport)},OemToAnsi("Este Programa Ira Imprimir a Lista de Separacao Para a Producao")) 

oReport:SetPortrait()     // Define a orientacao de pagina do relatorio como retrato.
oReport:HideParamPage()   // Desabilita a impressao da pagina de parametros.
oReport:nFontBody	:= 10 // Define o tamanho da fonte.
oReport:nLineHeight	:= 50 // Define a altura da linha.

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da secao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a secao.                   �
//�ExpA4 : Array com as Ordens do relatorio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oSection1)                                         �
//����������������������������������������������������������������

oSection1 := TRSection():New(oReport,"Lista Separacao",{"ZZY","SB1"}) // "Ordens de Produ��o"
oSection1:SetLineStyle() //Define a impressao da secao em linha
oSection1:SetReadOnly()

TRCell():New(oSection1,'ZZY_NUMDOC'	,'TRB',"Documento",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ZZY_CODPLA'	,'TRB',"Codigo Planejado",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ZZY_QTDPLA' ,'TRB',"Qtde Planejada",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ZZY_QTDPER' ,'TRB',"Qtde Perda    ",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QTDTOT'  	,'TRB',"Qtde Total    " ,PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLAT")[1],/*lPixel*/,{|| TRB->ZZY_QTDPLA + TRB->ZZY_QTDPER })
TRCell():New(oSection1,'ZZY_DATPLA' ,'TRB',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ZZY_EMISSA' ,'TRB',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ZZY_CELPLA' ,'TRB',"Celula ",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:Cell('B1_DESC'  ):SetCellBreak()
//oSection1:Cell('ZZY_EMISSA' ):SetCellBreak()
//oSection1:Cell('ZZY_QTDPLA' ):SetCellBreak()
//oSection1:Cell('ZZY_QTDPER' ):SetCellBreak()
//oSection1:Cell('ZZY_DATPLA' ):SetCellBreak()
//oSection1:Cell('ZZY_CELPLA' ):SetCellBreak()

//��������������������������������������������������������������Ŀ
//� Sessao 2 (oSection2)                                         �
//����������������������������������������������������������������
oSection2 := TRSection():New(oSection1,"ETIQUETAS MASTER",{"ZZY","SB1"},/*Ordem*/) //"Empenhos"
oSection2:SetHeaderBreak()
oSection2:SetReadOnly()

TRCell():New(oSection2,'ZZY_NUMDOC'	 	,'ZZY',"Documento"   ,PesqPict('ZZY','ZZY_NUMDOC') ,TamSX3('ZZY_NUMDOC')[1]+1    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
//TRCell():New(oSection2,'ZZY_CODMAS'	 	,'ZZY',"Prod Master" ,PesqPict('ZZY','ZZY_CODMAS') ,TamSX3('ZZY_CODMAS')[1]+1    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'B1_DESC' 	,'SB1',"Descricao"       ,PesqPict('SB1','B1_DESC')   ,30 ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
oSection2:Cell("B1_DESC"):SetLineBreak() 
TRCell():New(oSection2,'ZZY_NUMMAS'	 	,'ZZY',"Num Master"  ,PesqPict('ZZY','ZZY_NUMMAS')  ,TamSX3('ZZY_NUMMAS')[1]+1    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'ZZY_QTDMAS' 	,'ZZY',"Quantidade"  ,PesqPict('ZZY','ZZY_QTDMAS')  ,TamSX3('ZZY_QTDMAS')[1]  ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'ZZY_FIFO'   	,'ZZY',"Lote"        ,PesqPict('ZZY','ZZY_FIFO')  ,TamSX3('ZZY_FIFO')[1]  ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'ZZY_ENDES'  	,'ZZY',"Endere�o"    ,PesqPict('ZZY','ZZY_ENDES')  ,TamSX3('ZZY_ENDES')[1]  ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'ZZY_TPRESE' 	,'ZZY',"Tp Sep"      ,PesqPict('ZZY','ZZY_TPRESE')  ,TamSX3('ZZY_TPRESE')[1]  ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
//TRCell():New(oSection2,'ZZY_QTDSEP' 	,'ZZY',"Qtde Sep"    ,PesqPict('ZZY','ZZY_QTDSEP')  ,TamSX3('ZZY_QTDSEP')[1]  ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)


//��������������������������������������������������������������Ŀ
//� Sessao 3 (oSection3)                                         �
//����������������������������������������������������������������
oSection3 := TRSection():New(oSection2,"IMEIS DA MASTER",{"ZZY","SB1"},/*Ordem*/) //"Empenhos"
oSection3:SetHeaderBreak()
oSection3:SetReadOnly()

TRCell():New(oSection3,'ZZ4_IMEI'	 	,'ZZ4',"Imei"   ,PesqPict('ZZ4','ZZ4_IMEI') ,TamSX3('ZZ4_IMEI')[1]+1    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection3,'ZZ4_OS'		 	,'ZZ4',"OS"  	,PesqPict('ZZ4','ZZ4_OS')   ,TamSX3('ZZ4_OS')[1]+1    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection3,'ZZ4_LOCAL'	 	,'ZZ4',"Armaz"  ,PesqPict('ZZ4','ZZ4_LOCAL') ,TamSX3('ZZ4_LOCAL')[1]+1    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection3,'ZZ4_ENDES'	 	,'ZZ4',"End"    ,PesqPict('ZZ4','ZZ4_ENDES') ,TamSX3('ZZ4_ENDES')[1]+1    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Eduardo Barbosa      � Data �08/03/12  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR820                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(1):Section(1)
Local oBreak

// Definindo quebra para secao 2 e ocultando celula utilizada somente para quebra
oBreak := TRBreak():New(oSection2,oSection2:Cell("ZZY_NUMDOC"),Nil,.F.)

oSection2:Cell("ZZY_NUMDOC"):Disable()
oSection1:Cell("ZZY_NUMDOC"):Disable()


cQuery := " SELECT ZZY_NUMDOC,ZZY_CODPLA,ZZY_QTDPLA,ZZY_QTDPER,ZZY_DATPLA,ZZY_EMISSA,ZZY_CELPLA "
cQuery += " FROM "+RetSqlName("ZZY")
cQuery += " WHERE  ZZY_FILIAL='"+xFilial("ZZY")+"'"
cQuery += " AND    ZZY_NUMDOC  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND    ZZY_EMISSA  BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
cQuery += " AND    ZZY_DATPLA  BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'"
cQuery += " AND    ZZY_CELPLA  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
cQuery += " AND    D_E_L_E_T_= '' "
cQuery += " GROUP BY ZZY_NUMDOC,ZZY_CODPLA,ZZY_QTDPLA,ZZY_QTDPER,ZZY_DATPLA,ZZY_EMISSA,ZZY_CELPLA "
cQuery += " ORDER BY ZZY_NUMDOC "

If SELECT("TRB") <> 0
   DbSelectArea("TRB")
   DbCloseArea()
Endif

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

TcSetField("TRB","ZZY_QTDPLA","N",14,2)
TcSetField("TRB","ZZY_QTDPER","N",14,2)
TcSetField("TRB","ZZY_DATPLA","D")
TcSetField("TRB","ZZY_EMISSA","D")
	
//��������������������������Ŀ
//�Posicionamento das tabelas�
//����������������������������
TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1")+TRB->ZZY_CODPLA })

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������
oReport:SetMeter(TRB->(LastRec()))
oSection1:Init()
oSection2:Init()

dbSelectArea("TRB")
While !oReport:Cancel() .And. !TRB->(Eof())
	//-- Valida se a OP deve ser Impressa ou nao
	//�������������������������������Ŀ
	//�Definindo o titulo do Relatorio�
	//���������������������������������
	oReport:SetTitle("L I S T A   D E   S E P A R A C A O   NRO: "+TRB->ZZY_NUMDOC) 

	//Impressao da Section 1
	oSection1:PrintLine()
	oReport:IncMeter()
	//--- Inicio fluxo impressao secao 2
	SB1->(dbSeek(xFilial("SB1")+TRB->ZZY_CODPLA))

    DbSelectArea("ZZY")
    DbSetOrder(1)
    DbSeek(xFilial("ZZY")+TRB->ZZY_NUMDOC,.F.)
    While ! Eof() .AND. ZZY->(ZZY_FILIAL+ZZY_NUMDOC) == xFilial("ZZY")+TRB->ZZY_NUMDOC
	    SB1->(dbSetOrder(1))
	    SB1->(MsSeek(xFilial("SB1")+ZZY->ZZY_CODMAS))
	    
	    If MV_PAR09==1
		    oSection2:Cell("ZZY_TPRESE"    ):SetValue(IIF(ZZY->ZZY_TPRESE=="P","Parcial","Total"))
			oSection2:PrintLine()
		Else
			oSection2:Init()
			oSection2:Cell("ZZY_TPRESE"    ):SetValue(IIF(ZZY->ZZY_TPRESE=="P","Parcial","Total"))
			oSection2:PrintLine()
			dbSelectArea("ZZ4")
			dbSetOrder(13)
			If dbSeek(xFilial("ZZ4")+ZZY->ZZY_NUMMAS)
				oSection3:Init()
				While ZZ4->(!EOF()) .and. ZZ4->(ZZ4_FILIAL+ZZ4_ETQMEM)==xFilial("ZZ4")+ZZY->ZZY_NUMMAS
					oSection3:PrintLine()			
					ZZ4->(dbSkip())
				EndDo		
				oSection2:Finish()
				oSection3:Finish()
			Endif   
		Endif
		ZZY->(DbSkip())
	Enddo	
	oReport:EndPage() //-- Salta Pagina
	dbSelectArea("TRB")
	dbSkip()

EndDo   
oSection2:Finish()
oSection1:Finish()
If SELECT("TRB") <> 0
   DbSelectArea("TRB")
   DbCloseArea()
Endif

Return Nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �VALPERG � Autor � Ricardo Berti         � Data �21/02/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria pergunta para o grupo			                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValPerg(cPerg)

Local aHelp	:= {}

PutSx1(cPerg, '01', 'Documento de        ?','' ,'' , 'mv_ch1', 'C', 9, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Documento Ate       ?','' ,'' , 'mv_ch2', 'C', 9, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Emissao de          ?','' ,'' , 'mv_ch3', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Emissao Ate         ?','' ,'' , 'mv_ch4', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Planejamento de     ?','' ,'' , 'mv_ch5', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Planejamento Ate    ?','' ,'' , 'mv_ch6', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '07', 'Celula de           ?','' ,'' , 'mv_ch7', 'C', 6, 0, 0, 'G', '', '', '', '', 'mv_par07',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '08', 'Celula Ate          ?','' ,'' , 'mv_ch8', 'C', 6, 0, 0, 'G', '', '', '', '', 'mv_par08',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '09', 'Tipo                ?','' ,'' , 'mv_ch9', 'N', 01, 0,01 ,'C','', '' ,'', '', 'mv_par09',"Sintetico"," "," ","","Analitico","","","","","","","","")

Return


