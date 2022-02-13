#INCLUDE 'RWMAKE.CH'
#DEFINE OPEN_FILE_ERROR -1

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IMPZ15   �Autor  �M.Munhoz - ERP PLUS � Data �  12/01/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ImpZ15()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa��o de Planilha Excel"
Local cDesc1  := "Este programa executa a importa��o da planilha Excel para o arquivo Z15"
Local cDesc2  := "permitindo o Bloqueio dos imeis."

Private cPerg    := padr("IMPZ15",10)
Private _amens   := {}
Private _acampos := {}
Private _adados  := {}
Private aImeis   := {}

//�����������������������������������������������Ŀ
//�mv_par01 - Motivo                              �
//�������������������������������������������������

u_GerA0003(ProcName())

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

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando Planilha Excel", .T. )

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RUNPROC  �Autor  �M.Munhoz - ERP PLUS � Data �  12/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que executa a importacao da planilha Excel do       ���
���          � cliente para a tabela SZA.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunProc(lEnd)
Local nTipImp   := mv_par02
Local cMotivo	 := Alltrim(mv_par01)
Local _aAreaZ15  := Z15->(GetArea())
Local _nCnt      := 0
Local _nRegImp   := 0
Local _cNomeArq  := ""
Local cPath      := "/BLQIMEI/"						// Local de gera��o do arquivo
Local aDirectory := Directory (cPath + "*.*")      // Tipo de arquivo a serem excluidos
Local lpassou    := .T.

Z12->(dbSetOrder(1))
Z15->(dbSetOrder(1))

If !Z12->(dbseek(xFilial("Z12")+mv_par01))
	Aviso("Motivo Inv�lido!","Favor Informar um motivo valido.",{"Ok"})
EndIf

// Fecha o arquivo temporario caso esteja aberto
If Select("EXC") > 0
	EXC->(dbCloseArea())
endif

// Abre o arquivo DBF gerado pelo Excel do cliente
_cTipo := "Arquivo Cliente (*.CSV)    | *.CSV | "
_cExcelDBF := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
If Empty(_cExcelDBF)
	Aviso("Cancelada a Sele��o!","Voce cancelou a sele��o do arquivo.",{"Ok"})
	Return
Endif
if !file(_cExcelDBF)
	return
else
	CpyT2S(_cExcelDBF,cPath)
endif

_clocalArq := alltrim(_cExcelDBF)
_cNomeArq := alltrim(_cExcelDBF)
_nPos     := rat("\",_cNomeArq)
if _nPos > 0
	_cNomeArq := substr(_cNomeArq,_nPos+1,len(_cNomeArq)-_nPos)
endif

cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

__CopyFile(_clocalArq, cRootPath + cPath + alltrim(_cNomeArq))
cFile :=  cPath + alltrim(_cNomeArq)
LPrim := .T.


ARQDADOS(cFile)

aCampos:={}
AADD(aCampos,{"IMEI"    ,"C",25,0})
_cArqSeq := CriaTrab(aCampos)
dbUseArea(.T.,,_cArqSeq,"EXC",.T.,.F.)

//[GERA A TABELA TEMPORARIA PARA TRANSPOR NA Z15]
IF Len(aImeis) > 0
	For x:=1 to 	Len(aImeis)
		Reclock("EXC",.T.)
		EXC->IMEI  := aImeis[x]
		msunlock()
	Next
Else
	return
Endif

EXC->(dbGoTop())

_nCnt := EXC->(RecCount())
procregua(_nCnt)


While EXC->(!eof())
	IncProc("Processando IMEI: " + EXC->IMEI)
	
	lpassou := .T.
	
	
	If nTipImp == 1 //[IMPORTA IMEIS, NAO IMPORTA OS JA IMPORTADOS]
		
		If Z15->(dbseek(xFilial("Z15")+Alltrim(EXC->IMEI)))
			ApMsgInfo("IMEI : "+Alltrim(EXC->IMEI)+"  Ja Bloqueado. Analisar. ")
			lpassou := .F.
		EndIf
		
		If lpassou
			reclock("Z15",.T.)
			Z15->Z15_FILIAL  := xFilial("Z15")
			Z15->Z15_IMEI    := EXC->IMEI
			Z15->Z15_MOTIVO  := mv_par01
			Z15->Z15_MSBLQL  := "2"
			msunlock()
			_nRegImp++
		EndIf
		
	Else //[REIMPORTA OS IMEIS JA IMPORTADOS]
		
		Reclock("Z15",!( Z15->(dbseek(xFilial("Z15")+Alltrim(EXC->IMEI)))))
		Z15->Z15_FILIAL  := xFilial("Z15")
		Z15->Z15_IMEI    := EXC->IMEI
		Z15->Z15_MOTIVO  := mv_par01
		Z15->Z15_MSBLQL  := "2"
		msunlock()
		
		_nRegImp++
		
	EndIf
	
	
	EXC->(dbSkip())
	
Enddo

If _nRegImp > 0
	ApMsgInfo("Foram bloqueados " + alltrim(str(_nRegImp)) + " IMEI's.")
	
	//Incluso Edson Rodrigues - 01/03/10 para gerar relat�rio com c�digos de Reclama��o do Cliente Nextel n�o cadastrados.
	//if len(_amens) > 0
	// ApMsgInfo("Houve problema na importa��o. Cod. Recl. Cliente N�o Cadastrado. Imprima o Relat. e fa�a as devidas corre��es !.")
	//	U_tecrx037(_amens)
	//   _amens:={}
	//Endif
else
	ApMsgInfo("Nenhum IMEI foi importado. Verificar o arquivo selecionado para importa��o. ")
endif

EXC->(dbCloseArea())
RestArea(_aAreaZ15)


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ARQDADOS �Autor  �M.Munhoz - ERP PLUS � Data �  12/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION ARQDADOS(cFile)
Local cCampo := ""

If FT_FUSE( cfile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " nao encontrado!")
	Return
Else
	nlinha   := 0
	
	While !FT_FEOF()
		cCampo := ""
		nlinha++
		
		xBuffer := FT_FREADLN()
		cCampo:=Substr(alltrim(xBuffer),1)
		
		AAdd(aImeis,cCampo)
		
		FT_FSKIP()
	EndDo
	
Endif
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CRIASX1  �Autor  �M.Munhoz - ERP PLUS � Data �  12/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para a criacao automatica das perguntas no SX1      ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Motivo  ?","Motivo  ?","Motivo 	?","mv_ch1","C",06,0,0,"G","","Z12"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Tipo    ?","Tipo    ?","Tipo     ?","mv_ch2","N",01,0,0,"C","",""	,"",,"mv_par02","Importa","","","","Reimporta"	,"","",""	,"","","","","","","","")
Return Nil
