#Include "Protheus.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PROESTR1  �Autor  �Diego Fernandes     � Data �  07/31/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relatorio para analise do custo antes do fechamento        ���
���          � ferramento para ajudar a encontrar diverg�ncias no custo   ���
�������������������������������������������������������������������������͹��
���Uso       � Promaquina                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BGHESTR1()
                        
Local oReport

oReport := ReportDef()
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)
oReport:PrintDialog()

Return               
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � REPORTDEF� Autor � Diego Fernandes       � Data � 31/07/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao Principal de Impressao                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Promaquina                         						  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oSection

oReport := TReport():New("PROESTR1","Diverg�ncias do Estoque",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir as Diverg�ncias do Estoque Referente ao Parametro Informado")

oSection1 := TRSection():New(oReport,OemToAnsi("An�lise de Custo"),{})
         
TRCell():New(oSection1,"cProduto",/*Tabela*/,"Produto","@!"	,45,/*lPixel*/,{|| cProduto	})
TRCell():New(oSection1,"cLocal",/*Tabela*/,"Local","@!"	,02,/*lPixel*/,{|| cLocal })
TRCell():New(oSection1,"nSaldoSB2",/*Tabela*/,"Saldo SB2","@!"	,02,/*lPixel*/,{|| nSaldoSB2 })
TRCell():New(oSection1,"nSaldoSBF",/*Tabela*/,"Saldo SBF","@!"	,02,/*lPixel*/,{|| nSaldoSBF })

Return oReport
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � REPORTDEF� Autor � Diego Fernandes       � Data � 31/07/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao Principal de Impressao                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Promaquina                         						  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cQuery    := ""                    

oSection1:SetTotalInLine(.F.)
oReport:OnPageBreak(,.T.)

cQuery := " SELECT B2_COD, "
cQuery += " 	   B1_DESC, "
cQuery += " 	   B2_LOCAL, "
cQuery += " 	   B2_QFIM, "
cQuery += "        B2_VFIM1, "  
cQuery += " 	   B2_CM1, "
cQuery += " 	   (CASE WHEN B2_QFIM > 0 AND B2_VFIM1 > 0 THEN (B2_VFIM1/B2_QFIM) ELSE 0 END) as UNITARIO "
cQuery += " FROM "+RetSqlName("SB2")+" SB2 (NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (B1_COD = B2_COD AND SB1.D_E_L_E_T_ <> '*' ) "
cQuery += " AND SB2.D_E_L_E_T_ <> '*'  "                                                         
cQuery += " AND SB1.B1_LOCALIZ = 'S' "
cQuery += " AND SB2.B2_COD = '01014962002' "
cQuery += " AND SB2.B2_LOCAL = '03' "
cQuery += " AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "
cQuery += " ORDER BY B2_COD, B2_LOCAL "

//��������������
//�Cria alias  �
//��������������
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TSQL",.F.,.T.)

//���������������������������Ŀ
//�Impressao da Primeira secao�
//�����������������������������
dbSelectArea("TSQL")
dbGoTop()

While  TSQL->(!Eof())

	If oReport:Cancel()
		Exit
	EndIf
	  
    cProduto := TSQL->B2_COD + "-" + TSQL->B1_DESC
    cLocal   := TSQL->B2_LOCAL
	nSaldoSB2 := TSQL->B2_QFIM
	
	//Calcula saldo por endereco 
	aSaldoSBF := {}
	nSaldoSBF := 0
	aSaldoSBF := CalcEstL(TSQL->B2_COD,TSQL->B2_LOCAL,dDataBase,"0800401        ","","","")
	
	If nSaldoSBF <> nSaldoSB2
    
		oSection1:PrintLine()			
		oReport:IncMeter()
		
	EndIf			
	
	TSQL->(dbSkip())	
EndDo

oSection1:Finish()

//��������������������Ŀ
//�Finaliza area Criada�
//����������������������
If Sele("TSQL") <> 0
	TSQL->(DbCloseArea())
Endif

Return