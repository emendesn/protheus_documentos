#INCLUDE "rwmake.ch"      

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ErroCadCli� Autor � Edson Rodrigues    � Data �  29/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para gravar arquivo texto com mensagens de erros  ���
���          � na insercao de cadastros de clientes.                      ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ErroCadCli(_aErros)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Rela��o de Divergencias"
Local cPict         := ""
Local titulo        := "Rela��o de Divergencias"
Local nLin          := 80
Local Cabec1        := " CPF       MENSAGEM DE ERRO                                               "
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "G"
Private nomeprog    := "ERROCADCL2"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := ""         
Private cString     := "SA1"   
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "ERROCADCLI"


//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                 �
//�����������������������������������������������������������������������
Private _cDiret := lower(AllTrim(__RELDIR))                        
Private cArqTxt := _cDiret+"erro_"+alltrim(nomeprog)+".TXT"
Private nHdl    
Private cEOL    := "CHR(13)+CHR(10)"

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

SetRegua(Len(_aErros)) 

for nm := 1 to len(_aErros)    

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
	

    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������
    //IncProc()

	@nLin,001 PSAY _aErros[nm,1] // CPF
	@nLin,015 PSAY _aErros[nm,2] // mensagem de erro

	cLin := ""
	cLin += _aErros[nm,1] + ";" // CPF
	cLin += _aErros[nm,2] + ";" // mensagem de erro
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
	    
	nLin := nLin + 1
	
	if len(_aErros) > nM .and. _aErros[nM,1] <> _aErros[nM+1,1]
		nLin := nLin + 1
	endif	

next nM



//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

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
          
fClose(nHdl)


MS_FLUSH()

Return
