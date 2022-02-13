#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE VISUALIZAR	1
#DEFINE EXCLUIR		2
#DEFINE ALTERAR		3
#DEFINE INCLUIR		4
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadDePara �Autor  �Hudson de Souza Santos�Data  � 11/07/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CadDePara()
Private aRotina := {}
Private aGrupos := aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private	lUsrAut :=.F.
//���������������������������������Ŀ
//�Fun��o para log do uso de rotina.�
//�����������������������������������
u_GerA0003(ProcName())
//���������������������������������������������������������������������Ŀ
//� Valida acesso de usuario                                            �
//�����������������������������������������������������������������������
For nX := 1 to Len(aGrupos)
	//Usuarios de Autorizado a fazer troca de IMEI
	If Upper(AllTrim(GRPRetName(aGrupos[nX]))) $ "CONTABIL/ADMINISTRADORES"
		lUsrAut  := .T.
		Exit
	EndIf
Next nX
//����������������������������������������������Ŀ
//�Caso grupo n�o atenda para manuten��o retorna.�
//������������������������������������������������
If !lUsrAut
	MsgAlert("Voce n�o tem autoriza��o para executar essa rotina. Contate o administrador do sistema.","Usuario n�o Autorizado")
	Return
Endif
aAdd(aRotina, { "Visualizar"	, "u_CDPCad"	,	0, 2 })
aAdd(aRotina, { "Incluir"		, "u_CDPCad"	,	0, 3 })
aAdd(aRotina, { "Alterar"		, "u_CDPCad"	,	0, 4 })
aAdd(aRotina, { "Excluir"		, "u_CDPCad"	,	0, 5 })
mBrowse(6,1,22,75,"SZW")
Return
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CDPCad    �Autor  �Hudson de Souza Santos�Data  � 11/07/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CDPCad(cAlias, nReg, nOpc)
Local aCpsGet	:= {"ZW_ARMPARA","ZW_ENDPARA","ZW_MSBLQL"}
Local aCpsCot	:= {}
Private cTitulo	:= "Configura��o De/Para Estoque"
Private aC		:= {}
Private aCols	:= {}
Private cArmDe	:= ""
Private cEndDe	:= ""
Private cDescri	:= ""
//�������������������������������������������Ŀ
//�Altera a parametro de mbrowse para modelo2.�
//���������������������������������������������
If nOpc == 1
	nOpc := VISUALIZAR
ElseIf nOpc == 2
	nOpc := INCLUIR
ElseIf nOpc == 3
	nOpc := ALTERAR
ElseIf nOpc == 4
	nOpc := EXCLUIR
EndIf
//�����������������������������������Ŀ
//�Variaveis do Cabecalho do Modelo 2.�
//�������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
If nOpc <> INCLUIR
	dbSelectArea(cAlias)
	dbSetOrder(2)
	SZW->(dbGoTo(nReg))
EndIf
SX3->(dbSeek("ZW_ARMDE"))
cArmDe := Iif(nOpc <> INCLUIR, SZW->ZW_ARMDE,Space(SX3->X3_TAMANHO))
aAdd(aC,{"cArmDe" ,{15,10} ,AllTrim(SX3->X3_TITULO),SX3->X3_PICTURE,'cArmDe <> "*"',SX3->X3_F3,Iif(SX3->X3_VISUAL=="A" .AND. nOpc == INCLUIR, .T., .F.)})
SX3->(dbSeek("ZW_ENDDE"))
cEndDe := Iif(nOpc <> INCLUIR, SZW->ZW_ENDDE,Space(SX3->X3_TAMANHO))
aAdd(aC,{"cEndDe" ,{15,200} ,AllTrim(SX3->X3_TITULO),SX3->X3_PICTURE,"u_CDPValCab()",SX3->X3_F3,Iif(SX3->X3_VISUAL=="A" .AND. nOpc == INCLUIR, .T., .F.)})
SX3->(dbSeek("ZW_DESCRI"))
cDescri := Iif(nOpc <> INCLUIR, SZW->ZW_DESCRI,Space(SX3->X3_TAMANHO))
aAdd(aC,{"cDescri" ,{35,10} ,AllTrim(SX3->X3_TITULO),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_F3,Iif(SX3->X3_VISUAL=="A" .AND. nOpc == INCLUIR, .T., .F.)})
//���������������������������������Ŀ
//�Montando aHeader para a Getdados.�
//�����������������������������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
nUsado:=0
aHeader:={}
While !Eof() .AND. (SX3->X3_ARQUIVO == cAlias)
	If Ascan(aCpsGet,Alltrim(SX3->X3_CAMPO)) > 0 .AND. X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
		nUsado++
		aAdd(aHeader,{;
			AllTrim(SX3->X3_TITULO),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT;
		})
	Endif
	SX3->(dbSkip())
EndDo
//�������������������������������Ŀ
//�Montando aCols para a GetDados.�
//���������������������������������
If nOpc == INCLUIR
	aCols:=Array(1,nUsado+1)
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)
	nUsado:=0
	While !Eof() .AND. (SX3->X3_ARQUIVO == cAlias)
		If Ascan(aCpsGet,Alltrim(SX3->X3_CAMPO)) > 0 .AND. X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			nUsado++
			If SX3->X3_TIPO == "C"
				aCols[1][nUsado] := SPACE(SX3->X3_TAMANHO)
			Elseif SX3->X3_TIPO == "N"
				aCols[1][nUsado] := 0
			Elseif SX3->X3_TIPO == "D"
				aCols[1][nUsado] := dDataBase
			Elseif SX3->X3_TIPO == "M"
				aCols[1][nUsado] := ""
			Else
				aCols[1][nUsado] := .F.
			Endif
		Endif
		dbSkip()
	EndDo
	aCols[1][nUsado+1] := .F.
Else
	aCols := {}
	nUsado:=0
	SZW->(dbGoTop())
	SZW->(dbSeek(xFilial("SZW")+cArmDe+cEndDe))
	While !(SZW->(Eof())) .AND. SZW->ZW_FILIAL == xFilial("SZW") .AND. SZW->ZW_ARMDE == cArmDe .AND. SZW->ZW_ENDDE == cEndDe
		nUsado++
		aCpsCot := {}
		For nX := 1 to Len(aCpsGet)
			aAdd(aCpsCot, &("SZW->"+Alltrim(aCpsGet[nX])) )
		Next nX
		aAdd(aCpsCot, nUsado)
		aAdd(aCpsCot, .F.)
		aAdd(aCols, aCpsCot)
		SZW->(dbSkip())
	EndDo
EndIf
//������������������������������������������
//�Array com descri��o dos campos do Rodap�
//������������������������������������������
aR:={}
//���������������������������������������������������������
//�Array com as posi��es para edi��o dos itens (GETDADOS).�
//���������������������������������������������������������
aCGD:={64,5,118,315}
//����������������������������������Ŀ
//�Valida��es na GetDados da Modelo 2�
//������������������������������������
//cLinhaOk := "ExecBlock('Md2LinOk',.f.,.f.)"
cLinhaOk := ".T."
cTudoOk  := "u_CDPValTok("+STR(nOpc)+")"
//��������������������
//�Chamada da Modelo2�
//��������������������
lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpc,cLinhaOk,cTudoOk,,,,,,,.T.)
If lRet .AND. nOpc <> VISUALIZAR
   Begin Transaction
    u_CDPGra(nOpc)
   End Transaction
EndIf
Return
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CDPGra    �Autor  �Hudson de Souza Santos�Data  � 16/07/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CDPGra(nOpc)
Local aSaveArea := GetArea()
If nOpc == ALTERAR .OR. nOpc == EXCLUIR
	dbSelectArea("SZW")
	dbSetOrder(2)
	dbGoTop()
	dbSeek(xFilial("SZW")+cArmDe+cEndDe)
	While !(Eof()) .AND. SZW->ZW_FILIAL == xFilial("SZW") .AND. SZW->ZW_ARMDE == cArmDe .AND. SZW->ZW_ENDDE == cEndDe
		RecLock("SZW",.F.)
			dbDelete()
		MsUnLock()
		dbSkip()
	EndDo
EndIf
If nOpc == INCLUIR .OR. nOpc == ALTERAR
	For nX := 1 to Len(aCols)
		If !(aCols[nX,Len(aCols[nX])])
			RecLock("SZW",.T.)
			 SZW->ZW_FILIAL		:= xFilial("SZW")
			 SZW->ZW_ARMDE 		:= cArmDe
			 SZW->ZW_ENDDE 		:= cEndDe
			 SZW->ZW_ARMPARA	:= aCols[nX,1]
			 SZW->ZW_ENDPARA	:= aCols[nX,2]
			 SZW->ZW_DESCRI		:= cDescri
			 SZW->ZW_MSBLQL		:= aCols[nX,3]
			MsUnLock()
		EndIf
	Next nX
EndIf
RestArea(aSaveArea)
Return
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CDPValLin �Autor  �Hudson de Souza Santos�Data  � 16/07/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CDPValTok(nOpc)
Local lRet	:= .T.
Local nX	:= 0
Local nY	:= 0
If nOpc == EXCLUIR .OR. nOpc == VISUALIZAR
	Return(lRet)
EndIf
For nX := 1 to Len(aCols)
	If !(aCols[nX,Len(aCols[nX])])
		For nY := 1 to Len(aCols)
			If !(aCols[nY,Len(aCols[nY])])
				//���������������������������������������������������������Ŀ
				//�Primeira Regra� N�o pode ter o armaz�m+endere�o duplicado�
				//�����������������������������������������������������������
				If (nX <> nY) .AND. (Alltrim(aCols[nX, 1]) == Alltrim(aCols[nY, 1]) .AND. Alltrim(aCols[nX, 2]) == Alltrim(aCols[nY, 2]))
					lRet := .F.
					Msgbox ( "N�o podem haver registros duplicados. Linha '" + Alltrim(STR(nX)) + "' e '" + Alltrim(STR(nY)) + "'", "Primeira Regra",  "ALERT" )
					Exit
				EndIf
				//������������������������������������������������������������������Ŀ
				//�Segunda Regra � Usado '*' no armaz�m n�o poder� ter outro endere�o�
				//��������������������������������������������������������������������
				If (nX <> nY) .AND. (Alltrim(aCols[nX, 1]) == "*" .AND. Alltrim(aCols[nX, 2]) == Alltrim(aCols[nY, 2]))
					lRet := .F.
					Msgbox ( "Regra com '*' no armaz�m esta divergente. Linha '" + Alltrim(STR(nX)) + "' e '" + Alltrim(STR(nY)) + "'", "Segunda Regra",  "ALERT" )
					Exit
				EndIf
				//��������������������������������������������������������������������Ŀ
				//�Terceira Regra � Usado '*' no endere�o n�o poder� ter outro endere�o�
				//����������������������������������������������������������������������
				If (nX <> nY) .AND. (Alltrim(aCols[nX, 2]) == "*" .AND. Alltrim(aCols[nX, 1]) == Alltrim(aCols[nY, 1]))
					lRet := .F.
					Msgbox ( "Regra com '*' no endere�o esta divergente. Linha '" + Alltrim(STR(nX)) + "' e '" + Alltrim(STR(nY)) + "'", "Terceira Regra",  "ALERT" )
					Exit
				EndIf
			EndIf
		Next nY
	EndIf
	If !lRet
		Exit
	EndIf
Next nX

Return(lRet)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CDPValCab �Autor  �Hudson de Souza Santos�Data  � 16/07/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CDPValCab()
Local _lRet := .T.
Local _aArea := GetArea()
Local _cArmDe := AvKey(cArmDe,"ZW_ARMDE")
Local _cEndDe := AvKey(cEndDe,"ZW_ENDDE")
dbSelectArea("SZW")
dbGoTop()
dbSetOrder(2)
If dbSeek(xFilial("SZW") + _cArmDe + _cEndDe)
	_lRet := .F.
	Msgbox ( "J� exite registro para esse armaz�m + endere�o.", "Duplicado",  "ALERT" )
EndIf
RestArea(_aArea)
Return(_lRet)