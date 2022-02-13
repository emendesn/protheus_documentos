#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ACOMPRIM � Autor � Eduardo Barbosa( Delta)�Data � 08/03/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio Acompanhamento Dos Imeis                          ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � PCP - BGH                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function ACOMPRIM()

Local oReport
Local aCampos   :={}
Local _aAreaTrb := GetArea()

Private cPergImei := "ACOMPRI"

u_GerA0003(ProcName())

ValPerg(cPergImei)
Pergunte(cPergImei,.T.)
// Criacao do TRB2 Temporario

AADD(aCampos,{"DOCUMENTO"   ,"C",09,0})
AADD(aCampos,{"MODELO"		,"C",15,0})
AADD(aCampos,{"IMEI"		,"C",TamSX3("ZZ4_IMEI")[1],0})
AADD(aCampos,{"SITUACAO"	,"C",10,0})
AADD(aCampos,{"MASTER"		,"C",20,0})

cTrab:=CriaTrab(aCampos)
_cIndex := Criatrab(,.F.)
If SELECT("TRB2") <> 0
	DbSelectArea("TRB2")
	DbCloseArea()
Endif

dbUseArea(.T.,,cTrab,"TRB2",.T.,.F.)
IndRegua("TRB2",_cIndex,"SITUACAO+IMEI",,,"Criando Indice")


//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport:= ReportDef()
oReport:SetTotalInLine(.F.)
oReport:PrintDialog()
Pergunte(cPerg,.F.)

If SELECT("TRB2") <> 0
	DbSelectArea("TRB2")
	DbCloseArea()
Endif                      
RestArea(_aAreaTRB)
	
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
Local cTitle	:= "Detalhes do IMEI" 

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

oReport:= TReport():New("ACOMPRIM",cTitle,, {|oReport| ReportPrint(oReport)},OemToAnsi("Este Programa Ira Imprimir Os Detalhes do IMEI")) 

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

oSection1 := TRSection():New(oReport,"Acompanhamento de Producao",{"TRB1"}) 
//oSection1:SetLineStyle() //Define a impressao da secao em linha
//oSection1:SetReadOnly()

TRCell():New(oSection1,'DOCUMENTO'		,'TRB2',"Documento"       ,"@!"            ,09,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'MODELO'			,'TRB2',"Modelo","@!"                      ,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'IMEI'			,'TRB2',"Imei","@!"                        ,TamSX3("ZZ4_IMEI")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SITUACAO'		,'TRB2',"Situacao","@!"                    ,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'MASTER' 	    ,'TRB2',"Master","@!"                 ,20,/*lPixel*/,/*{|| code-block de impressao }*/)


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

FAtuTRB2()

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������

oReport:SetMeter(TRB2->(LastRec()))
oSection1:Init()

dbSelectArea("TRB2")
DbGoTop()
While !oReport:Cancel() .And. !TRB2->(Eof())
	//-- Valida se a OP deve ser Impressa ou nao
	//�������������������������������Ŀ
	//�Definindo o titulo do Relatorio�
	//���������������������������������
	oReport:SetTitle("ACOMPANHAMENTO DE PRODUCAO ") 

	//Impressao da Section 1
	oSection1:PrintLine()
	dbSelectArea("TRB2")
	dbSkip()

EndDo
oSection1:Finish()

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

Static Function fAtuTRB2()

If MV_PAR01 == 1 // Apenas o documento de Separacao Posicionado
	GrvTrb2(TRB->DOCUMENTO)
Else
  DbSelectArea("TRB")
  DbGoTop()
  While ! Eof()
	  GrvTrb2(TRB->DOCUMENTO)
	  DbSelectArea("TRB")
	  DbSkip()
  Enddo   
Endif	
	

Return


Return

Static Function GrvTRB2(_cNumZZY)
DbSelectArea("ZZY")
DbSetOrder(1)
DbSeek(xFilial("ZZY")+_cNumZZY,.F.)
While ! Eof() .AND. ZZY->(ZZY_FILIAL+ZZY_NUMDOC) == xFilial("ZZY")+_cNumZZY
	_aQtdDoc := u_AnaDocPla(ZZY->ZZY_NUMDOC,IIF(Alltrim(ZZY->ZZY_NUMMAS) <> "SEM_MASTER",ZZY->ZZY_NUMMAS,SPACE(20)),.T.)
	// Retorno Array _aQtdDoc
	// Elemento	Conteudo
	// Elemento [1]Etiqueta Master
	// Elemento [2]Qtde Scrap
	// Elemento [3]Qtde Produzida
	// Elemento [4]Qtde Separada 
	// Elemento [5][1] // Numeros dos Imei
	// Elemento [5][2] // Situacao do Imei
	If Len(_aQtdDoc[5]) > 0
	   For _nElemImei := 1 To Len(_aQtdDoc[5])
	   		_cImei     := _aQtdDoc[5][_nElemImei][1]
	   		_cSituaca  := _aQtdDoc[5][_nElemImei][2]
	   		_lGrava	   := .F.
	   		PutSx1(cPerg, '01', 'Documento Separacao ?','' ,'' , 'mv_ch1', 'N', 1 , 0,1 ,'C', '', '', '','',  'mv_par01',"Posicionado"," "," ","","Todos","","","","","","","","")
PutSx1(cPerg, '02', 'Status Imei         ?','' ,'' , 'mv_ch2', 'N', 1 , 0,1 ,'C', '', '', '','',  'mv_par02',"Produzido"," "," ","","Scrap","","","Pendentes","","","Ambos","","")
             
            If MV_PAR02 == 1 .AND. Alltrim(Upper(_cSituaca)) == "PRODUZIDO" 
               _lGrava := .T.
            Endif
            If MV_PAR02 == 2 .AND. Alltrim(Upper(_cSituaca)) == "SCRAP" 
               _lGrava := .T.
            Endif
            If MV_PAR02 == 3 .AND. Alltrim(Upper(_cSituaca)) == "PENDENTE" 
               _lGrava := .T.
            Endif
            If _lGrava .OR. MV_PAR02 == 4   
		   		DbSelectArea("TRB2")
		   		RecLock("TRB2",.T.)
	   				TRB2->DOCUMENTO		:= ZZY->ZZY_NUMDOC
	   				TRB2->MODELO		:= ZZY->ZZY_CODMAS
	   				TRB2->IMEI			:= _cImei
	   				TRB2->SITUACAO		:= _cSituaca
	   				TRB2->MASTER		:= ZZY->ZZY_NUMMAS
	   			msUnlock() 
	        Endif
	   Next _nElemImei
	Endif
	DbSelectArea("ZZY")
	DbSkip()
Enddo
Return


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

PutSx1(cPerg, '01', 'Documento Separacao ?','' ,'' , 'mv_ch1', 'N', 1 , 0,1 ,'C', '', '', '','',  'mv_par01',"Posicionado"," "," ","","Todos","","","","","","","","")
PutSx1(cPerg, '02', 'Status Imei         ?','' ,'' , 'mv_ch2', 'N', 1 , 0,1 ,'C', '', '', '','',  'mv_par02',"Produzido"," "," ","","Scrap","","","Pendentes","","","Ambos","","")

Return          

