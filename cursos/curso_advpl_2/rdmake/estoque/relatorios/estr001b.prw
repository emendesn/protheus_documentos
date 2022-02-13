#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ESTR001  � Autor � M.Munhoz - ERPPLUS � Data �  09/04/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Posicao de estoque para a area Comercial                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ESTR001B()

Local aSay     := {}
Local aButton  := {}
Local nOpc     := 0
Local cTitulo  := "Posi��o de Estoque - �rea de Log�stica"
Local cDesc1   := "Este programa tem como objetivo gerar um relat�rio da Posi��o de Estoque para a "
Local cDesc2   := "�rea Comercial."
Local cDesc3   := "Espec�fico BGH"
Local cDesc4   := ""

Private cPerg  := "ESTR01"

u_GerA0003(ProcName())

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T.)      }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()   }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()              }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
EndIf

GrvRemSony()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �GRVREMSONY� Autor � AP6 IDE            � Data �  05/01/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao para gerar o arquivo com os dados de PV e cliente   ���
���          � das Remessas Sony.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GrvRemSony()

Local   _cquery      := ""
Local   CR           := chr(13) + chr(10)                               
private _csrvapl     :=ALLTRIM(GetMV("MV_SERVAPL"))

//���������������������������������������������������������������������Ŀ
//� Parametros da rotina                                                �
//� mv_par01 -> Emissao PV Inicial                                      �
//� mv_par02 -> Emissao PV Final                                        �
//� mv_par03 -> Mensagem Nota                                           �
//�����������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Fecha os arquivos temporarios, caso estejam abertos          �
//����������������������������������������������������������������
if select("TRB") > 0
	TRB->(dbCloseArea())
endif

_cquery +=      " SELECT C5.C5_NUM   'NUMPV' , C5_EMISSAO 'EMISPV', C5_MENNOTA    'MENNOTA', C5_NOTA    'NRNF'  , C6_TES     'TES', C6_XIMEOLD  'IMEIOLD', "
_cquery += CR + "        C5_CLIENTE  'CLIFAT', C5_LOJACLI 'LOJFAT',  "
_cquery += CR + "        A1A.A1_NOME 'NOMFAT', A1A.A1_END 'ENDFAT', A1A.A1_BAIRRO 'BAIFAT' , A1A.A1_MUN 'MUNFAT', A1A.A1_EST 'ESTFAT', A1A.A1_PESSOA 'PESFAT', A1A.A1_CGC 'CGCFAT', A1A.A1_INSCR 'INSFAT',  "
_cquery += CR + "        C5_CLIENT   'CLIENT', C5_LOJAENT 'LOJENT', "
_cquery += CR + "        A1B.A1_NOME 'NOMENT', A1B.A1_END 'ENDENT', A1B.A1_BAIRRO 'BAIENT' , A1B.A1_MUN 'MUNENT', A1B.A1_EST 'ESTENT', A1B.A1_PESSOA 'PESENT', A1B.A1_CGC 'CGCENT', A1B.A1_INSCR 'INSENT' "
_cquery += CR + " FROM   "+RetSqlName("SC5")+" AS C5 "
_cquery += CR + " JOIN   "+RetSqlName("SA1")+" AS A1A "
_cquery += CR + " ON     A1A.A1_COD = C5_CLIENTE AND A1A.A1_LOJA = C5_LOJACLI AND A1A.D_E_L_E_T_ = '' "
_cquery += CR + " LEFT OUTER JOIN "+RetSqlName("SA1")+" AS A1B "
_cquery += CR + " ON     A1B.A1_COD = C5_CLIENT  AND A1B.A1_LOJA = C5_LOJAENT AND A1B.D_E_L_E_T_ = '' "
_cquery += CR + " JOIN   ( "
_cquery += CR + "         SELECT DISTINCT C6_FILIAL, C6_NUM, C6_TES, C6_XIMEOLD "
_cquery += CR + "         FROM   "+RetSqlName("SC5")+" AS C5 "
_cquery += CR + "         JOIN   "+RetSqlName("SC6")+" AS C6 "
_cquery += CR + "         ON     C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C6.D_E_L_E_T_ = '' "
_cquery += CR + "         WHERE C6.C6_FILIAL='"+xFilial('SC6')+"' AND C5.D_E_L_E_T_ = '' "
_cquery += CR + "                AND C5.C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
_cquery += CR + "                AND C5.C5_MENNOTA LIKE '"+alltrim(mv_par03)+"' "
_cquery += CR + "        ) AS C6 "
_cquery += CR + " ON     C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "
_cquery += CR + " WHERE C5_FILIAL='"+xFilial('SC5')+"' AND C5.D_E_L_E_T_ = '' "
_cquery += CR + "        AND C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
_cquery += CR + "        AND C5_MENNOTA LIKE '"+alltrim(mv_par03)+"' "

//memowrite("ESTR001.SQL",_cQuery )
_cQuery := strtran(_cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
dbselectarea("TRB")
TRB->(dbgotop())

nConta := 0

While !TRB->(eof())
	nConta++
	TRB->(dbSkip())
EndDo

//_cArq  := "REMSONY.XLS"
_cArq  := "REMSONY.CSV"
_lOPen := .f.

_cArqSeq   :=CriaTrab(,.f.)
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

dbselectarea("TRB")
TRB->(dbgotop())
copy to &(cStartPath+_cArqSeq)
TRB->(dbCloseArea())

_cArqTmp := lower(AllTrim(__RELDIR)+_cArq)
cArqorig := cStartPath+_cArqSeq+".dtc"

//Incluso Edson Rodrigues - 25/05/10
lgerou:=U_CONVARQ(cArqorig,_cArqTmp)

If lgerou                              
   If !ApOleClient( 'MsExcel' )
      MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
   Else
      ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )           
   EndIf

Else
  msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
Endif



/*
if nConta > 0
	While !_lOpen
		if file(__reldir+_cArq) .and. ferase(__reldir+_cArq) == -1
			if !ApMsgYesNo("O arquivo " + _cArq + " n�o pode ser gerado porque deve estar sendo utilizado. Deseja tentar novamente? " )
				_lOpen := .t.
				ApMsgInfo("O arquivo Excel n�o foi gerado. ")
			endif
		else
			dbselectarea("TRB")
			copy to &(__reldir+_cArq)  VIA "DBFCDXADS"
			ShellExecute( "Open" , "\\"+_csrvapl+__reldir+_cArq ,"", "" , 3 )
			_lOpen := .t.
		endif
	EndDo
else
	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
endif
*/


TRB->(dbCloseArea())

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATA001   �Autor  �Microsiga           � Data �  09/24/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaSx1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Fornecedor Inicial"		,"Fornecedor Inicial"		,"Fornecedor Inicial"		,"mv_ch1","C",06,0,0,"G","","SA2","",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Fornecedor Final"		,"Fornecedor Final"			,"Fornecedor Final"			,"mv_ch2","C",06,0,0,"G","","SA2","",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Produto Inicial"			,"Produto Inicial"			,"Produto Inicial"			,"mv_ch3","C",15,0,0,"G","","SB1","",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Produto Final"			,"Produto Final"		   	,"Produto Final"		   	,"mv_ch4","C",15,0,0,"G","","SB1","",,"mv_par04","","","","","","","","","","","","","","","","")
Return Nil