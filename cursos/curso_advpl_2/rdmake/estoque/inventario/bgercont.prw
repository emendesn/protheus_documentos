#Include "Protheus.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BGERCONT  �Autor  �D.FERNANDES         � Data �  12/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para listar diferen�as de contagens e gerar         ���
���          � proxima contagem dos itens batidos                         ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BGERCONT()

Local aPergs  := {}
Local aRet 	  := {}

Private aElege := {}

aAdd( aPergs ,{1,"Invent�rio em",dDataBase,"@!",'.T.','','.T.',40,.F.})

If ParamBox(aPergs ,"Parametros ",aRet)	
	//����������������������������������Ŀ
	//�Verifica as diferencas na contagem�
	//������������������������������������
	Processa({||ProcCont(aRet[1])})
EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcCont  �Autor  �D.FERNANDES         � Data �  12/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que processa analise dos itens			          ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcCont(dDataInv)

Local cQuery  	 := ""

Local  nCont   	 := 0
Local  nContagem := 0 
Local  nPos      := 0
Local _aCampos   := {}
Local _cArqSeq   := ""

//Cria tabela temporaria	
_aCampos := {{"PRODUTO"		,"C",15,0},;
{"AMZ"		,"C",2,0} ,;
{"ENDERE"	,"C",15,0} ,;
{"LOTECT"	,"C",15,0} ,;
{"SLDEST"	,"N",14,2},;
{"CONT"		,"N",14,2},;
{"MESTRE"	,"C",15,0},;
{"CONTAG"	,"C",6,0},;
{"USERCO" 	,"C",15,0}}
                         
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

_cArqSeq := CriaTrab(_aCampos)
dbUseArea(.T.,,_cArqSeq,"TRB",.T.,.F.)

//Verifica divergencia nas contagens
cQuery := " SELECT "
cQuery += " 	CBC_CODINV,  "
cQuery += " 	CBC_NUM, "
cQuery += "  	CBC_COD,  "
cQuery += "  	CBC_LOCAL,  "
cQuery += "  	CBC_LOCALI,  "
cQuery += "  	CBC_LOTECT,  "
cQuery += "  	SUM(CBC_QUANT) AS CBC_QUANT  "
cQuery += "  FROM "+RetSqlName("CBC")+" CBC (NOLOCK)  "
cQuery += "  LEFT JOIN "+RetSqlName("CBA")+" CBA ON (CBA_CODINV = CBC_CODINV AND CBA_FILIAL = CBC_FILIAL AND CBA.D_E_L_E_T_ = '')  "
cQuery += "  WHERE   "
cQuery += "  	CBC_FILIAL = '"+xFilial("CBA")+"' AND  "
cQuery += "  	CBC.D_E_L_E_T_='' AND  "
cQuery += "     CBA.CBA_DATA = '"+DTOS(dDataInv)+"' AND "
cQuery += "  	CBA.CBA_CONTS >= '2' AND  "
cQuery += "  	CBA.CBA_STATUS = '3' "
cQuery += " GROUP BY CBC_CODINV, CBC_NUM, CBC_COD, CBC_LOCAL, CBC_LOCALI, CBC_LOTECT "
cQuery += " ORDER BY CBC_CODINV, CBC_COD, CBC_LOCAL, CBC_LOCALI, CBC_LOTECT,CBC_NUM "

If Select("TSQL") > 0
	TSQL->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL",.T.,.T.)

//Mostra tela de visualizacao
dbSelectArea("TSQL")
TSQL->(dbGotop())
	
While TSQL->(!Eof())
	
	//elege a quantidade batida	
	_nPos  := Ascan( aElege,{ |x| x[1]+x[2]+x[3]+x[4]+x[5]+Alltrim(Str(x[6])) ==;
		    TSQL->(CBC_CODINV+CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT)+Alltrim(Str(TSQL->CBC_QUANT)) } )
				    
	If _nPos == 0				    
		AADD(aElege,{TSQL->CBC_CODINV,;
					TSQL->CBC_COD,;
					TSQL->CBC_LOCAL,;
					TSQL->CBC_LOCALI,;
					TSQL->CBC_LOTECT,;
					TSQL->CBC_QUANT,;					
					1,;
					TSQL->CBC_NUM} )
	Else 
		aElege[_nPos][7]++
	EndIf					
					
	TSQL->(dbSkip())
EndDo
                     
aEleito := {}
aExclui := {}

For nY := 1 To Len(aElege)

	dbSelectArea("CBA")
	dbSetOrder(1)           
	If MsSeek(xFilial("CBA")+aElege[nY][1])
	
		If !aElege[nY][7] < CBA->CBA_CONTS  
			AADD(aEleito,{aElege[nY][1],;
							aElege[nY][2],;
							aElege[nY][3],;
							aElege[nY][4],;
							aElege[nY][5],;
							aElege[nY][6],;
							aElege[nY][7],;
							aElege[nY][8] })			
					
		Endif
		
	EndIf
		
Next nY           

//Grava os produtos com diverg�ncias 
For nEle := 1 To Len(aElege)

	dbSelectArea("CBA")
	dbSetOrder(1)           
	If MsSeek(xFilial("CBA")+aElege[nEle][1])
	
		If aElege[nEle][7] < CBA->CBA_CONTS  
			
			//Verifica se o item est� com a contagem batida
			_nPos  := Ascan( aEleito,{ |x| x[1]+x[2]+x[3]+x[4]+x[5] ==;
		     aElege[nEle][1]+aElege[nEle][2]+aElege[nEle][3]+aElege[nEle][4]+aElege[nEle][5] } )
		     
			If _nPos == 0			
			
				dbSelectArea("CBB") 
				dbSetOrder(3)
				MsSeek(xFilial("CBB")+aElege[nEle][1]+aElege[nEle][8])
			
				dbSelectArea("TRB")
				TRB->(RecLock("TRB",.T.))
				TRB->MESTRE  := aElege[nEle][1]
				TRB->PRODUTO := aElege[nEle][2]
				TRB->AMZ	 := aElege[nEle][3]
				TRB->ENDERE	 := aElege[nEle][4]
				TRB->LOTECT	 := aElege[nEle][5]
				TRB->CONT    := aElege[nEle][6]
				TRB->CONTAG  := aElege[nEle][8]
				TRB->SLDEST  := SaldoSBF(aElege[nEle][3], aElege[nEle][4], aElege[nEle][2], NIL, aElege[nEle][5], NIL, .F.)
				TRB->USERCO  := Posicione("CB1",1,xFilial("CB1")+CBB->CBB_USU,"CB1_NOME")
				TRB->(MsUnLock())
			
			EndIf
	
		EndIf
	
	EndIf
	
Next nEle
      
dbSelectArea("TRB")
TRB->(dbGotop())

If TRB->(!Eof())	
	MosTela()
Else
	Aviso("Invent�rio","N�o existem diverg�ncias para analise!",{"OK"})
EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MosTela   �Autor  �D.FERNANDES         � Data �  12/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para listagem das divergencias 				          ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MosTela()

Local _aBrowse := {}
Local aButtons := {}

AADD(_aBrowse,{"MESTRE"			,,	"Mestre"})
AADD(_aBrowse,{"PRODUTO"		,,	"Produto"})
AADD(_aBrowse,{"AMZ"   			,,	"Local"})
AADD(_aBrowse,{"ENDERE"			,,	"Endereco"})
AADD(_aBrowse,{"LOTECT"			,,	"Lote"})
AADD(_aBrowse,{"CONT"			,,	"Qtd. Inv."})
AADD(_aBrowse,{"SLDEST"			,,	"Saldo Estoque"})
AADD(_aBrowse,{"CONTAG"			,,	"N� Contagem"})
AADD(_aBrowse,{"USERCO"			,,	"Usu�rio"})

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{160,200,240,265}} )
nGetLin := aPosObj[3,1]

//Botao para recontagem
Aadd(aButtons,{"GRAVAR",{|| Processa( { || Recont() } ) },"Recontagem","Recontagem"})

//Relat�rio de analise
Aadd(aButtons,{"GRAVAR",{|| ImpRel() },"Relat�rio","Relat�rio"})


DEFINE MSDIALOG _oDlg TITLE "Gera��o de NF Saida" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

oBrwTrb := MsSelect():New("TRB","","",_aBrowse,,,{aPosObj[1][1],aPosObj[1][2],aPosObj[2][3],aPosObj[1][4]})

Activate MsDialog _oDlg On Init (EnchoiceBar(_oDlg,{|| _oDlg:End() },{|| _oDlg:End() },,aButtons)) Centered

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Recont    �Autor  �D.FERNANDES         � Data �  12/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para gerar recontagem 					          ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Recont()   

Local cCodOpe  := CBRetOpe()

If MsgYesNo("Confirma recontagem?")

	Begin Transaction

	_cCodInv := ""

	For nEle := 1 To Len(aElege)
	    	
		dbSelectArea("CBA")
		dbSetOrder(1)
		MsSeek(xFilial("CBA")+aElege[nEle][1])				
		
		RecLock("CBA",.F.)
		CBA->CBA_STATUS := "2"//pausa
		CBA->CBA_CONTR  :=  CBA->CBA_CONTR+1 
		CBA->CBA_ANALIS := "1"
		MsUnlock()
		
		If aElege[nEle][7] >= CBA->CBA_CONTS
		    
			If 	_cCodInv <> aElege[nEle][1]
			
				_cCodInv := aElege[nEle][1]
							
				//GRAVAR CBB
				dbSelectArea("CBB") 
				dbSetOrder(3)
				MsSeek(xFilial("CBB")+TRB->MESTRE+TRB->CONTAG)
				
				Reclock("CBB",.T.)
				CBB->CBB_FILIAL := xFilial("CBB")
				CBB->CBB_NUM    := CBProxCod('MV_USUINV')
				CBB->CBB_CODINV := CBA->CBA_CODINV
				CBB->CBB_USU    := cCodOpe
				CBB->CBB_STATUS := "1"
				CBB->(MsUnlock())
				
			EndIf				

			ProcRegua(0)	
	
			//Gera as contagens ja batidas
			IncProc("Gerando contagem, aguarde...")
			
			CBC->(Reclock("CBC",.T.))
			CBC->CBC_FILIAL := xFilial("CBC")
			CBC->CBC_NUM    := CBB->CBB_NUM
			CBC->CBC_COD    := aElege[nEle][2]
			CBC->CBC_LOCAL  := aElege[nEle][3]
			CBC->CBC_QUANT  := aElege[nEle][6]
			CBC->CBC_LOCALIZ:= aElege[nEle][4]
			CBC->CBC_CODINV := aElege[nEle][1]
			CBC->CBC_QTDORI := aElege[nEle][6]
			CBC->CBC_LOTECT := aElege[nEle][5]
			CBC->(MsUnlock())		        						                                
			
		EndIf					
	Next
	
	End Transaction
	
	MsgInfo("Contagem gerada com sucesso, realize a contagem dos itens divergentes!!!")

EndIf
	  
If Type("_oDlg") <> "U"
	_oDlg:End()	
EndIf
				
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpRel    �Autor  �D.FERNANDES         � Data �  12/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�ro de conferencia		 					          ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpRel()          
Local oReport

oReport := ReportDef()
oReport:SetTotalInLine(.T.)
oReport:PrintDialog()

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � Impressao do relat�rio personalizavel		              |��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH					                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ReportDef()
	
Local oReport
Local oSection

oReport := TReport():New("ImpRel","Diverg�ncias do Invent�rio",,{|oReport| PrintReport(oReport)},"Diverg�ncia do invent�rio referente as contagens")
oSection1 := TRSection():New(oReport,OemToAnsi("Diverg�ncia Invent�rio"),{"TRB"})

Return oReport
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintRepor�Autor  �D.FERNANDES         � Data �  12/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�ro de conferencia		 					          ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

oSection1:SetTotalInLine(.F.)
oReport:OnPageBreak(,.T.)
		                                                  
TRCell():New(oSection1,"MESTRE", "TRB","Mestre","@!",15)
TRCell():New(oSection1,"PRODUTO","TRB","Produto","@!",15)
TRCell():New(oSection1,"AMZ"    ,"TRB","Local","@!",02)
TRCell():New(oSection1,"ENDERE" ,"TRB","Endere�o","@!",15)
TRCell():New(oSection1,"LOTECT" ,"TRB","Lote","@!",20)
TRCell():New(oSection1,"SLDEST" ,"TRB","Saldo Estoque","@E 999,999,999.99",14)
TRCell():New(oSection1,"CONT"   ,"TRB","Contagem","@E 999,999,999.99",14)
TRCell():New(oSection1,"CONTAG" ,"TRB","N� Contagem","@!",6)
TRCell():New(oSection1,"USERCO" ,"TRB","Usu�rio","@!",15)

dbSelectArea("TRB")
TRB->(dbGoTop())

oReport:SetMeter(RecCount())
oSection1:Init()            

cProduto := TRB->PRODUTO

While TRB->(!Eof())
                        
	If cProduto <> TRB->PRODUTO
		cProduto := TRB->PRODUTO
		oReport:SkipLine()
	EndIf 
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:PrintLine()	
	
	
	TRB->(dbSkip())
	
	oReport:IncMeter()
	
EndDo

oSection1:Finish()

dbSelectArea("TRB")
TRB->(dbGoTop())

Return