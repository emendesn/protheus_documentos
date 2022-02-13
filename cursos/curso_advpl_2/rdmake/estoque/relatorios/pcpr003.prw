#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"  
#define ENTER chr(13) + chr(10) 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCPR003   � Autor �Paulo Francisco     � Data �  06/12/10   ���
�������������������������������������������������������������������������͹��
���Descricao �RELATORIO DE PECAS EM ARMAZEM                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PCPR003()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private Titulo    := "Relacao de Produtos Aguardando Pecas"
Private cDesc1    := "Este programa ira emitir a relacao dos Equipamentos Aguardando."
Private cDesc2    := ""
Private cDesc3    := ""
Private cString   := "ZZ7"
Private tamanho   := "M"
Private wnrel     := "PCPR003"
Private lEnd      := .F.
Private aReturn   := {"Zebrado", 1,"Administracao", 1, 2, 1, "", 1}
Private nomeprog  := "PCPR003"
Private cPerg     := "PCPR003"
Private cArqTrab  := ""
Private cFilTrab  := ""
Private nLastKey  := 0   
Private aOrd      := {}
Private Cabec1    := ""
Private Cabec2    := ""                         
Private nLin      := 80
Private limite    := 132      
Private CONTFL    := 01
Private m_pag     := 01

u_GerA0003(ProcName())

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas 				    	     �
//����������������������������������������������������������������
fCriaSX1(cPerg)
Pergunte(cPerg, .F.)

wnrel := SetPrint(cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., aOrd,, Tamanho)

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return   

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RUNREPORT � Autor �Paulo Francisco     � Data �  07/12/10   ���
�������������������������������������������������������������������������͹��
���Descricao �CHAMADA DO RELATORIO                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport()

Local cQry     := ""
Local cQryExec
Local nTotal   := 0
Local cQtd     := .t.
Local cQtd1
Local nQTY1
Local cIMEI1
Local cPARTNR1
Local cDESCRI1
Local cOS1
Local cLOCALI1
Local aImei    := {}

Private cImei
Private cOs

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf

//���������������������������������������������������������������������Ŀ
//� Selecao dos dados do relatorio                                      �
//�����������������������������������������������������������������������
cQryExec := " IF OBJECT_ID(N'tempdb..##RELZ4', N'U') IS NOT NULL " + ENTER
cQryExec += " DROP TABLE ##RELZ4 " + ENTER
cQryExec += "SELECT Z4.ZZ4_IMEI, Z4.ZZ4_OS, Z4.ZZ4_FASMAX, " + ENTER
cQryExec += "(SELECT TOP 1 Z3.ZZ3_FASE2 FROM ZZ3020 Z3 (NOLOCK) WHERE Z3.D_E_L_E_T_ = Z4.D_E_L_E_T_  AND Z4.ZZ4_OS = Z3.ZZ3_NUMOS AND Z4.ZZ4_FILIAL = Z3.ZZ3_FILIAL ORDER BY Z3.ZZ3_SEQ DESC ) AS FASE2 " + ENTER
cQryExec += "INTO ##RELZ4 " + ENTER
cQryExec += "FROM "+RetSqlName("ZZ4") + " Z4 (NOLOCK) " + ENTER
cQryExec += "WHERE Z4.D_E_L_E_T_ = '' " + ENTER
cQryExec += "AND Z4.ZZ4_FILIAL = '" +xFilial("ZZ4")+ "' " + ENTER
cQryExec += "AND Z4.ZZ4_FASMAX = '32' " + ENTER
cQryExec += "AND Z4.ZZ4_STATUS < = '5' " + ENTER

If !Empty(mv_par01)
   cQryExec += "AND Z4.ZZ4_OS = '" +mv_par01+ "' " + ENTER
EndIf

cQryExec += "DELETE ##RELZ4 " + ENTER
cQryExec += "WHERE ZZ4_FASMAX != FASE2 " + ENTER
                              
MemoWrite("pcpr003_1.sql", cQryExec)
TcSqlExec(cQryExec)

cQry := "SELECT Z7.ZZ7_QTY QTY, Z7.ZZ7_IMEI IMEI, Z7.ZZ7_PARTNR PARTNR, B1.B1_DESC DESCRI, ZZ7_NUMOS OS, ZZ7_LOCAL LOCALI, B2.B2_QATU QTDATU" + ENTER
cQry += "FROM " + RetSqlName("ZZ7") + " Z7 (NOLOCK) " + ENTER
cQry += "INNER JOIN ##RELZ4 " + ENTER
cQry += "ON(Z7.ZZ7_NUMOS = ZZ4_OS) " + ENTER
cQry += "INNER JOIN  " + RetSqlName("SB1") + " B1 (NOLOCK) " + ENTER
cQry += "ON(B1.B1_COD = ZZ7_PARTNR) " + ENTER
cQry += "INNER JOIN  " + RetSqlName("SB2") + " B2 (NOLOCK) " + ENTER //Verifica as quantidades na SB2
cQry += "ON(B2.B2_COD = ZZ7_PARTNR AND B2.B2_LOCAL = '21') " + ENTER
cQry += "WHERE Z7.ZZ7_FILIAL = '" +xFilial("ZZ7")+ "' " + ENTER
//cQry += "WHERE Z7.ZZ7_FILIAL = '02' " + ENTER
cQry += "AND Z7.D_E_L_E_T_ = '' " + ENTER
cQry += "AND Z7.ZZ7_LOCAL = '21' " + ENTER
Do case 										// filtra com qtde = 0 ou # 0 
   Case mv_par03 == 1
       cQry += "AND B2.B2_QATU > 0"
   Case mv_par03 == 2
       cQry += "AND B2.B2_QATU = 0"
Endcase   
cQry += "AND B2.D_E_L_E_T_ = '' " + ENTER
If mv_par02 == 1
	cQry += " ORDER BY ZZ7_IMEI " + ENTER 
Else                                        
	cQry += " ORDER BY ZZ7_PARTNR " + ENTER 
EndIf
MemoWrite("pcpr003.sql", cQry)
TCQUERY cQry NEW ALIAS QRY         
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape	 �
//����������������������������������������������������������������
dbSelectArea("QRY")
SetRegua(RecCount())
dbGoTop()
Do Case      
    //Por IMEI   
	Case mv_par02 = 1
		titulo  += " - Por IMEI"
		cQuebra := "QRY->IMEI = cNum"
        cabec1  := "  IMEI              PartNumber        Neces.   Disp.   Descricao do PartNumber                     Num. OS   Local     Neces."		
        cNum	:= QRY->IMEI
	//Por produto PartNumber
	Case mv_par02 = 2             
		titulo  += " - Por PARTNR"
		cQuebra := "QRY->PARTNR = cPrt"
        cabec1  := "  PartNumber        IMEI              Neces.   Disp.   Descricao do PartNumber                     Num. OS   Local     Neces."				
        cPrt    := QRY->PARTNR
EndCase
//��������������������������������������������������������Ŀ
//� Verifica o se o relatorio � com disponibilidade ou nao �
//����������������������������������������������������������
Do case 
   Case mv_par03 == 1
       cQtd1 := "QRY->QTDATU > 0"
   Case mv_par03 == 2
       cQtd1 := "QRY->QTDATU = 0"
Endcase   
While !QRY->(EOF()) 
   //�����������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario... �
   //�������������������������������������������
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
             
   If nLin > 58 
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
	//������������������������������������Ŀ
	//� Alimenta as variaveis de impressao �
	//��������������������������������������
    nQTY1    := QRY->QTDATU     //Quantidade no SB2
    cIMEI1   := QRY->IMEI
    cPARTNR1 := QRY->PARTNR
    cDESCRI1 := QRY->DESCRI
    cOS1     := QRY->OS
    cLOCALI1 := QRY->LOCALI
    nTotal   := 0		        
	cImei 	 := QRY->IMEI
	cNos	 := QRY->OS

	IncRegua()
	//����������������������������Ŀ
	//� Verifica campo para quebra �									 �
	//������������������������������

    If !&cQuebra			
       nLin++
       @nLin, 000 PSAY __PrtThinLine() 										      
       nLin++
       Do Case
          Case mv_par02 == 1
          cNum	   	:= QRY->IMEI
       Case mv_par02 == 2             
	      cPrt    	:= QRY->PARTNR
       EndCase                    
    endif

	//��������������������������������������������������������������������������Ŀ
	//� Faz a aglutina��o do itens que serao impressos conforme a ordem escolhida�
	//����������������������������������������������������������������������������

    While &cQuebra			       
          nTotal+=QRY->QTY      
          QRY->(dbSkip())
          Do Case
             Case mv_par02 == 1
                  aadd(aImei,{QRY->PARTNR,nTotal,QTDATU,QRY->DESCRI})
             Case mv_par02 == 2             
                  aadd(aImei,{QRY->IMEI})
          EndCase          
    Enddo    

	//�������������������������������������������������Ŀ
	//� Verifica a ordem e muda a posicao no relatorio	�
	//���������������������������������������������������

    if mv_par02 == 1
       @nLin, 002 PSAY cIMEI1
       @nLin, 020 PSAY cPARTNR1                   
    elseif mv_par02 == 2
       @nLin, 002 PSAY cPARTNR1                   
       @nLin, 020 PSAY cIMEI1
    endif
    @nLin, 042 PSAY nTotal
    @nLin, 049 PSAY nQTY1
    @nLin, 056 PSAY cDESCRI1
    @nLin, 100 PSAY cOS1
    @nLin, 112 PSAY cLOCALI1
    nLin++

	//����������������������������������������Ŀ
	//� Faz a impressao dos itens aglutinados  �
	//������������������������������������������

    for i=2 to len(aImei) 
        Do Case
           Case mv_par02 == 1
                @nLin, 019 PSAY aImei[i,1]                
                @nLin, 042 PSAY aImei[i,2]                
                @nLin, 049 PSAY aImei[i,3]                
                @nLin, 056 PSAY aImei[i,4]
           Case mv_par02 == 2             
                @nLin, 019 PSAY aImei[i,1]
        EndCase          
        nLin++        
    next    
    aImei:={}
    cqtd:=.t.
    nTotal := 0        
Enddo
QRY->(dbCloseArea())
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FCRIASX1  � Autor �Paulo Francisco     � Data �  07/12/10   ���
�������������������������������������������������������������������������͹��
���Descricao �GERA DICIONARIO DE PERGUNTAS                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fCriaSX1(cPerg)

Local cKey     := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Filtro por Num. OS ","","","mv_ch1","C",06,0,0,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Filtro por         ","","","mv_ch2","N",01,0,0,"C","",""   ,"","","mv_par02","IMEI","","","","PartNumber","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Filtro por Qtde    ","","","mv_ch3","N",04,0,0,"C","",""   ,"","","mv_par03","Dispon�vel","","","","N�o Dispon�vel","","","","","","","","","","","","","","","","","","")

cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Numero da OS.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P." + cPerg + "02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Forma de Filtro.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Escolha a disponibilidade do estoque.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


