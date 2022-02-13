#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"  
/*
������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������ͻ��
���Programa  �ACDANFE   �Autor  �Edson Francisco/Gilberto Suzart  � Data �  01/08/2011 ���
��������������������������������������������������������������������������������������͹��
���Desc.     � ROTINA PARA ACESSAR A DANFE FISCAL, VISUALIZACAO OU IMPRESSAO.          ���
���          �                                                                         ���
��������������������������������������������������������������������������������������͹��
���Uso       � FAT                                                                     ���
��������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������
*/

User function acdanfe()
Local aArea     := GetArea()
Local lRetorno  := .T.
Local nVezes    := 0

PRIVATE lBtnFiltro:= .F.

u_GerA0003(ProcName())

While lRetorno
	lBtnFiltro:= .F.
    lRetorno := SpedNfe2(.F.)
    nVezes++
    If !lBtnFiltro
    	Exit
    EndIf
EndDo
RestArea(aArea)
Return Nil

return



Static Function SPEDNFe2(lInit,cAlias)

Local aPerg     := {}
Local aCores    := {}
Local lRetorno  := .T.
Local aIndArq   := {}

PRIVATE cCondicao := ""            
PRIVATE aRotina     := {}
PRIVATE aRotina   := MenuDef()
PRIVATE cCadastro := "Monitoramento da NFe-SEFAZ" //"Monitoramento da NFe-SEFAZ"
PRIVATE bFiltraBrw
PRIVATE afilbrw     := {}

//������������������������������������������������������������������������Ŀ
//�Montagem das perguntas                                                  �
//��������������������������������������������������������������������������
aadd(aPerg,{2,"Tipo de NFe","",{"1-Sa�da","2-Entrada"},120,".T.",.T.,".T."}) //"Tipo de NFe"###"1-Sa�da"###"2-Entrada"
aadd(aPerg,{2,"Filtra","",{"1-Autorizadas","2-Sem filtro","3-N�o Autorizadas","4-Transmitidas","5-N�o Transmitidas"},120,".T.",.T.,".T."}) //"Filtra"###"1-Autorizadas"###"2-Sem filtro"###"3-N�o Autorizadas"###"4-Transmitidas"###"5-N�o Transmitidas"
aadd(aPerg,{1,"Serie da Nota Fiscal",PadR("",Len(SF2->F2_SERIE)),"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"

If !lInit .Or. IsReady()
	If ParamBox(aPerg,"SPED - NFe",,,,,,,,"SPEDNFE",.T.,.T.)
		If SubStr(MV_PAR01,1,1) == "1"
			aCores    := {{"F2_FIMP==' ' .AND. AllTrim(F2_ESPECIE)=='SPED'",'DISABLE' },;	//NF n�o transmitida
						  {"F2_FIMP=='S'",'ENABLE'},;									//NF Autorizada
						  {"F2_FIMP=='T'",'BR_AZUL'},;									//NF Transmitida
						  {"F2_FIMP=='N'",'BR_PRETO'}}									//NF nao autorizada
			//������������������������������������������������������������������������Ŀ
			//�Realiza a Filtragem                                                     �
			//��������������������������������������������������������������������������			
			cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
			If !Empty(MV_PAR03)
				cCondicao += ".AND.F2_SERIE=='"+MV_PAR03+"'"
			EndIf
			If SubStr(MV_PAR02,1,1) == "1" //"1-NF Autorizada"
				cCondicao += ".AND. F2_FIMP$'S' "
			ElseIf SubStr(MV_PAR02,1,1) == "3" //"3-N�o Autorizadas"
				cCondicao += ".AND. F2_FIMP$'N' "
			ElseIf SubStr(MV_PAR02,1,1) == "4" //"4-Transmitidas"
				cCondicao += ".AND. F2_FIMP$'T' "
			ElseIf SubStr(MV_PAR02,1,1) == "5" //"5-N�o Transmitidas"
				cCondicao += ".AND. F2_FIMP$' ' "				
			EndIf                    
			aFilBrw		:=	{'SF2',cCondicao}
			bFiltraBrw := {|| FilBrowse("SF2",@aIndArq,@cCondicao,@afilbrw) }
			Eval(bFiltraBrw)
			mBrowse( 6, 1,22,75,"SF2",,,,,,aCores,/*cTopFun*/,/*cBotFun*/,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.F.,)
			//����������������������������������������������������������������Ŀ
			//�Restaura a integridade da rotina                                �
			//������������������������������������������������������������������
			dbSelectArea("SF2")
			RetIndex("SF2")
			dbClearFilter()
			aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})			
		Else
			If SF1->(FieldPos("F1_FIMP"))>0
				aCores    := {{"F1_FIMP==' ' .AND. AllTrim(F1_ESPECIE)=='SPED'",'DISABLE' },;	//NF n�o transmitida
							  {"F1_FIMP=='S'",'ENABLE'},;									//NF Autorizada
							  {"F1_FIMP=='T'",'BR_AZUL'},;									//NF Transmitida
							  {"F1_FIMP=='N'",'BR_PRETO'}}									//NF nao autorizada		
			Else
				aCores := Nil
			EndIf
			//������������������������������������������������������������������������Ŀ
			//�Realiza a Filtragem                                                     �
			//��������������������������������������������������������������������������
			cCondicao := "F1_FILIAL=='"+xFilial("SF1")+"' .AND. "
			cCondicao += "F1_FORMUL=='S'"
			If !Empty(MV_PAR03)
				cCondicao += ".AND.F1_SERIE=='"+MV_PAR03+"'"
			EndIf
			If SubStr(MV_PAR02,1,1) == "1" .And. SF1->(FieldPos("F1_FIMP"))>0 //"1-NF Autorizada"
				cCondicao += ".AND. F1_FIMP$'S' "
			ElseIf SubStr(MV_PAR02,1,1) == "3" .And. SF1->(FieldPos("F1_FIMP"))>0 //"3-N�o Autorizadas"
				cCondicao += ".AND. F1_FIMP$'N' "
			ElseIf SubStr(MV_PAR02,1,1) == "4" .And. SF1->(FieldPos("F1_FIMP"))>0 //"4-Transmitidas"
				cCondicao += ".AND. F1_FIMP$'T' "
			ElseIf SubStr(MV_PAR02,1,1) == "5" .And. SF1->(FieldPos("F1_FIMP"))>0 //"5-N�o Transmitidas"
				cCondicao += ".AND. F1_FIMP$' ' "				
			EndIf                                          
			aFilBrw		:=	{'SF1',cCondicao}
			bFiltraBrw := {|| FilBrowse("SF1",@aIndArq,@cCondicao,@afilbrw[]) }
			Eval(bFiltraBrw)
			mBrowse( 6, 1,22,75,"SF1",,,,,,aCores,/*cTopFun*/,/*cBotFun*/,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.F.,)
			//����������������������������������������������������������������Ŀ
			//�Restaura a integridade da rotina                                �
			//������������������������������������������������������������������   .
			dbSelectArea("SF1")
			RetIndex("SF1")
			dbClearFilter()
			aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})			
		EndIf	
	Else
		lRetorno := .F.
	EndIf
Else
	HelProg(,"FISTRFNFe")
	lRetorno := .F.
EndIf

Return(lRetorno)
                                   

Static Function MenuDef()

 Private aRotina := {{"DANFE","SpedDanfe"     ,0,2,0 ,NIL}}
	
Return(aRotina)


