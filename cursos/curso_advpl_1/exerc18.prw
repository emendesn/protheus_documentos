#INCLUDE "rwmake.ch"

User Function Exerc18

// Declaracao de Variaveis.

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio de Softwares"
Local cPict         := ""
Local titulo        := "Relatorio de Softwares"

// Var. nLin � o num. da linha a ser impresso. Inicializa com 80 para que, na primeira
// vez, no teste "If nLin>55" na funcao RunReport() j� imprima o primeiro cabecalho.
Local nLin          := 80

Local Cabec1        := "Codigo Nome"
Local Cabec2        := "-------- ---------------------"
Local imprime       := .T.

Private aOrd        := {"C�digo","Nome"}
Private lEnd        := .F.
Private lAbortPrint := .F.  // Usado na RunReport() -> se usuario cancelou, contem .T.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "Exerc18" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18        // Caracter de compressao. Usado em Cabec().
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1} // Preenchido pela SetPrint().
Private nLastKey    := 0
Private cPerg       := "RSZ1"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "Exerc18" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

Pergunte(cPerg,.F.)

// Monta a interface padrao com o usuario.

wnRel := SetPrint(cString, NomeProg, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .T., aOrd, .T., Tamanho, , .T.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)   // Comprimido/Normal.

// RPTSTATUS monta a janela com a regua de processamento.
RptStatus({|| RunReport(Cabec1, Cabec2, Titulo, nLin) }, Titulo)

Return

//----------------------------------------------------------------------------------------------------------------// 
// Funcao auxiliar chamada pela RPTSTATUS.
//----------------------------------------------------------------------------------------------------------------// 
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)

//���������������������������������������������������������������������Ŀ
//� Tratamento das ordens. A ordem selecionada pelo usuario esta contida�
//� na posicao 8 do array aReturn. E um numero que indica a opcao sele- �
//� cionada na mesma ordem em que foi definida no array aOrd. Portanto, �
//� basta selecionar a ordem do indice ideal para a ordem selecionada   �
//� pelo usuario, ou criar um indice temporario para uma que nao exista.�
//� Por exemplo:                                                        �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem < 5                                                       �
//�     dbSetOrder(nOrdem)                                              �
//� Else                                                                �
//�     cInd := CriaTrab(NIL,.F.)                                       �
//�     IndRegua(cString,cInd,"??_FILIAL+??_ESPEC",,,"Selec.Registros") �
//� Endif                                                               �
//�����������������������������������������������������������������������

nOrdem := aReturn[8]
dbSetOrder(nOrdem)

// SETREGUA -> Indica quantos registros serao processados para a regua.
SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Note que o descrito acima deve ser tratado de acordo com as ordens  �
//� definidas. Para cada ordem, o indice muda. Portanto a condicao deve �
//� ser tratada de acordo com a ordem selecionada. Um modo de fazer isto�
//� pode ser como a seguir:                                             �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem == 1                                                      �
//�     dbSetOrder(1)                                                   �
//�     cCond := "A1_COD <= mv_par02"                                   �
//� ElseIf nOrdem == 2                                                  �
//�     dbSetOrder(2)                                                   �
//�     cCond := "A1_NOME <= mv_par02"                                  �
//� ElseIf nOrdem == 3                                                  �
//�     dbSetOrder(3)                                                   �
//�     cCond := "A1_CGC <= mv_par02"                                   �
//� Endif                                                               �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.)                                      �
//� While !EOF() .And. &cCond                                           �
//�                                                                     �
//�����������������������������������������������������������������������

dbGoTop()
//dbSeek(xFilial("SZ1")+mv_Par01,.T.)

While !EOF() //.And. SZ1->Z1_Codigo <= MV_Par02

   // Verifica o cancelamento pelo usuario.

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   // Impressao do cabecalho do relatorio.

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

   @nLin,000 PSay SZ1->Z1_Codigo
   @nLin,008 PSay SZ1->Z1_Nome
   @nLin,061 PSay SZ1->Z1_Emissao
   @nLin,071 PSay SZ1->Z1_DtAquis

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo

   IncRegua()

EndDo

// Finaliza a execucao do relatorio.

SET DEVICE TO SCREEN

// Se impressao em disco, chama o gerenciador de impressao.

If aReturn[5]==1   // Impressao em disco.
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()         // Libera o spool para a efetiva impressao.

Return
