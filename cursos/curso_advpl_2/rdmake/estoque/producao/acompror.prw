#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ACOMPROR � Autor � Eduardo Barbosa( Delta)�Data � 08/03/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio Acompanhamento de Produ�ao                        ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � PCP - BGH                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function ACOMPROR()

Local oReport

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
Local oSection1, oSection2
Local cTitle	:= "Acompanhamento de Producao" 


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

oReport:= TReport():New("ACOMPROR",cTitle,, {|oReport| ReportPrint(oReport)},OemToAnsi("Este Programa Ira Imprimir O Acompanhamento de Producao")) 

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

oSection1 := TRSection():New(oReport,"Acompanhamento de Producao",{"TRB"}) 
//oSection1:SetLineStyle() //Define a impressao da secao em linha
//oSection1:SetReadOnly()

TRCell():New(oSection1,'DOCUMENTO'	,'TRB',"Documento"       ,"@!"                        ,09,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'MODELO'		,'TRB',"Codigo Planejado","@!"                        ,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QTDPLA' 	,'TRB',"Qtde Pla+Scrap"  ,PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLA")[1],/*lPixel*/ ,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SCRAP'  	,'TRB',"Scrap"           ,PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLA")[1],/*lPixel*/ ,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QTDPRO' 	,'TRB',"Qtde Produzida"  ,PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLA")[1],/*lPixel*/ ,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SALPRO' 	,'TRB',"Saldo Laborator",PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QTDSEP'  	,'TRB',"Qtde Separada"   ,PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLA")[1],/*lPixel*/ ,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SALSEP' 	,'TRB',"Saldo a Separar" ,PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SCRAPLA' 	,'TRB',"Scrap Planejado" ,PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QTDDEV' 	,'TRB',"Qtde Devolvida"  ,PesqPict("ZZY","ZZY_QTDDEV"),TamSX3("ZZY_QTDDEV")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EMISSAO' 	,'TRB',"Emissao" ,PesqPict("ZZY","ZZY_EMISSA"),TamSX3("ZZY_EMISSA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DESC' 		,'TRB',"Descricao"       ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)


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
Local oBreak

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������

oReport:SetMeter(TRB->(LastRec()))
oSection1:Init()

dbSelectArea("TRB")
DbGoTop()
While !oReport:Cancel() .And. !TRB->(Eof())
	//-- Valida se a OP deve ser Impressa ou nao
	//�������������������������������Ŀ
	//�Definindo o titulo do Relatorio�
	//���������������������������������
	oReport:SetTitle("ACOMPANHAMENTO DE PRODUCAO ") 

	//Impressao da Section 1
	oSection1:PrintLine()
	dbSelectArea("TRB")
	dbSkip()

EndDo
oSection1:Finish()
dbSelectArea("TRB")
DbGoTop()

Return Nil


