#INCLUDE "rwmake.ch"

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � TECRX037 � Autor � Edson Rodrigues    � Data �  01/03/10      ���
���������������������������������������������������������������������������� ���
���Descricao � Programa para gerar relatorio de Codigos de reclama��o        ���
���          |do Cliente|Nextel sem Cadastro na tabela ZZG                   ���
��������������������������������������������������������������������������   ���
���Uso       � Especifico BGH                                                ���
����������������������������������������������������������������������������ͺ��
����������������������������������������������������������������������������� ��
��������������������������������������������������������������������������������
/*/                                     


User Function TECRX037(_aErros)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Rela��o de Recl. Cliente Nextel N�o Cadastrados"
Local cPict         := ""
Local titulo        := "Rela��o de Recl. Cliente Nextel N�o Cadastrados"
Local nLin          := 80
Local Cabec1        := "  IMEI                   CODIGO - DESCR.  RECL. CLIENTE                             DIVIRGENCIA                                                      SOLUCAO                               "
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "G"
Private nomeprog    := "TECRX037"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "TECRX037"
Private cString     := "ZZG"             
private _csrvapl    :=ALLTRIM(GetMV("MV_SERVAPL"))
Private _cDirori    :=__RELDIR //"\\BGH010\MP8\PROTHEUS_DATA\RELATO\LOGISTICA"
Private _carqnome   :="erro_codrecl"+StrZero(year(dDataBase),4)+ StrZero(Month(dDataBase),2) + StrZero(Day(dDataBase),2) + Substr(Time(),1,2) + Substr(Time(),4,2)+".txt"
Private cArqTxt     := _cDirori+_carqnome
Private nHdl  
  
Private cEOL        := "CHR(13)+CHR(10)"   

u_GerA0003(ProcName())

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

if File( cArqTxt )
	nHdl := FOpen( cArqTxt, 1 )
	if nHdl >= 0
		FSeek( nHdl, 0, 2 )
	endif
else
	nHdl := FCreate( cArqTxt )
endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

dbSelectArea(cString)
dbSetOrder(1)

Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,_aErros) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/10/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,_aErros)

Local nOrdem
Local nTamLin, cLin, cCpo
Local _nStatus   := 0
local _aAreaSZA  := SZA->(GetArea())          

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(Len(_aErros))

For x := 1 to Len(_aErros)
    //���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		nLin := 8
	Endif 
	

	@nLin,001 PSAY alltrim(_aErros[x,1]) //IMEI
	@nLin,024 PSAY LEFT(alltrim(_aErros[x,2]),60) //COD. RECL. CLIENTE
	@nLin,082 PSAY LEFT(alltrim(_aErros[x,3]),60) // DIVERGENCIA
	@nLin,145 PSAY LEFT(alltrim(_aErros[x,4]),60) // SOLUCAO
	
	cLin := ""
	cLin += alltrim(_aErros[x,1])  + ";" //IMEI
	cLin += LEFT(alltrim(_aErros[x,2]),60) + ";" //COD. RECL. CLIENTE
	cLin += LEFT(alltrim(_aErros[x,3]),60) // DIVERGENCIA
	cLin += LEFT(alltrim(_aErros[x,4]),60) // SOLUCAO
	cLin += cEol
             
    //���������������������������������������������������������������������Ŀ
    //� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
    //� linha montada.                                                      �
    //�����������������������������������������������������������������������
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
       If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif
	
	//���������������������������������������������������������������������Ŀ
    //� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
    //� cao anterior.                                                       �
    //�����������������������������������������������������������������������

    
	nLin := nLin + 1
	if len(_aErros) > x .and. _aErros[x,1] <> _aErros[x+1,1]
		nLin := nLin + 1
	endif	
Next x   

fClose(nHdl)
//Close(oGeraTxt)

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()    
restarea(_aAreaSZA)

Return