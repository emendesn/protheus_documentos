///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | New_Print.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_NewPrint()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Este programa demonstra a utilizacao das funcoes: __PrtLeft(),  |//
//|           | __PrtRight(), PrtThinLine() e __PrtFatLine junto com a funcao   |//
//|           | SetPrint()                                                      |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function NewPrint()

//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------

Local cDesc1  := "Relatório de impressão utilizando as funções:"
Local cDesc2  := "__PrtLeft(), __PrtRight(), __PrtCenter()"
Local cDesc3  := "__PrtThinLine() e __PrtFatLine()"

Private cString  := ""
Private Tamanho  := "P"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "NewPrint"
Private NomeProg := "NewPrint"
Private nLastKey := 0
Private Limite   := 80
Private Titulo   := "Cadastro de bancos"
Private cPerg    := ""
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {}

/*
+-------------------------------------
| Parametros do aReturn 
+-------------------------------------
| aReturn - Preenchido pelo SetPrint()
+-------------------------------------
aReturn[1] - Reservado para formulario
aReturn[2] - Reservado para numero de vias
aReturn[3] - Destinatario
aReturn[4] - Formato 1=Comprimido 2=Normal
aReturn[5] - Midia 1-Disco 2=Impressora
aReturn[6] - Prota ou arquivo 1-Lpt1... 4-Com1...
CReturn[7] - Expressao do filtro
aReturn[8] - Ordem a ser selecionada
aReturn[9] [10] [n] - Campos a processar se houver
*/

//+-------------------------------------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio.
//+-------------------------------------------------------------------------------
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,.F.,.F.)
//SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
   Return
Endif

//+-------------------------------------------------------------------------------
//| Estabelece os padroes para impressao, conforme escolha do usuario
//+-------------------------------------------------------------------------------
SetDefault(aReturn,cString)

//+-------------------------------------------------------------------------------
//| Verificar se sera reduzido ou normal
//+-------------------------------------------------------------------------------
nTipo := Iif(aReturn[4] == 1, 15, 18)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
   Return
Endif

//+-------------------------------------------------------------------------------
//| Chama funcao que processa os dados
//+-------------------------------------------------------------------------------
RptStatus({|lEnd| RelNewImp(@lEnd) }, "Aguarde...", "Imprimindo registros...", .T. )

Return

/******
 *
 * Funcao de impressao
 *
 */
Static Function RelNewImp(lEnd)
LOCAL nVez := 1

dbSelectArea("SA6")
dbSetOrder(1)
dbGoTop()
SetRegua( RecCount() )

While !Eof() .And. !lEnd
	
	IncRegua()
	
	If lEnd
		MsgInfo(cCancel,Titulo)
		Exit
	Endif
	
	If Li > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	Endif
		
	If nVez==1
		@ Li,001 PSay __PrtLeft("Banco.........: "+SA6->A6_COD)
		Li++
		@ Li,001 PSay __PrtLeft("Agência.......: "+SA6->A6_AGENCIA)
		Li++
		@ Li,001 PSay __PrtLeft("Conta Corrente: "+SA6->A6_NUMCON)
		Li++
		@ Li,001 PSay __PrtLeft("Endereço......: "+SA6->A6_END)
		Li++
		@ Li,001 PSay __PrtLeft("Bairro........: "+SA6->A6_BAIRRO)
		Li++
		@ Li,001 PSay __PrtLeft("CEP...........: "+SA6->A6_CEP)
		Li++
		@ Li,001 PSay __PrtLeft("Municipio.....: "+SA6->A6_MUN)
		Li++
		@ Li,001 PSay __PrtLeft("Estado........: "+SA6->A6_EST)
		Li++
		@ Li,001 PSay __PrtThinLine()
		Li++
	Elseif nVez==2
		@ Li,001 PSay __PrtFatLine()
		Li++
		@ Li,001 PSay __PrtRight("Banco.........: "+SA6->A6_COD)
		Li++
		@ Li,001 PSay __PrtRight("Agência.......: "+SA6->A6_AGENCIA)
		Li++
		@ Li,001 PSay __PrtRight("Conta Corrente: "+SA6->A6_NUMCON)
		Li++
		@ Li,001 PSay __PrtRight("Endereço......: "+SA6->A6_END)
		Li++
		@ Li,001 PSay __PrtRight("Bairro........: "+SA6->A6_BAIRRO)
		Li++
		@ Li,001 PSay __PrtRight("CEP...........: "+SA6->A6_CEP)
		Li++
		@ Li,001 PSay __PrtRight("Municipio.....: "+SA6->A6_MUN)
		Li++
		@ Li,001 PSay __PrtRight("Estado........: "+SA6->A6_EST)
		Li++
		@ Li,001 PSay __PrtThinLine()
		Li++
	Elseif nVez==3
		@ Li,001 PSay __PrtFatLine()
		Li++
		@ Li,001 PSay __PrtCenter("Banco.........: "+SA6->A6_COD)
		Li++
		@ Li,001 PSay __PrtCenter("Agência.......: "+SA6->A6_AGENCIA)
		Li++
		@ Li,001 PSay __PrtCenter("Conta Corrente: "+SA6->A6_NUMCON)
		Li++
		@ Li,001 PSay __PrtCenter("Endereço......: "+SA6->A6_END)
		Li++
		@ Li,001 PSay __PrtCenter("Bairro........: "+SA6->A6_BAIRRO)
		Li++
		@ Li,001 PSay __PrtCenter("CEP...........: "+SA6->A6_CEP)
		Li++
		@ Li,001 PSay __PrtCenter("Municipio.....: "+SA6->A6_MUN)
		Li++
		@ Li,001 PSay __PrtCenter("Estado........: "+SA6->A6_EST)
		Li++
		@ Li,001 PSay __PrtThinLine()
		Li++
	Elseif nVez==4
		@ Li,001 PSay __PrtFatLine()
		Li++
		@ Li,001 PSay "Banco.........: "+SA6->A6_COD
		Li++
		@ Li,001 PSay "Agência.......: "+SA6->A6_AGENCIA
		Li++
		@ Li,001 PSay "Conta Corrente: "+SA6->A6_NUMCON
		Li++
		@ Li,001 PSay "Endereço......: "+SA6->A6_END
		Li++
		@ Li,001 PSay "Bairro........: "+SA6->A6_BAIRRO
		Li++
		@ Li,001 PSay "CEP...........: "+SA6->A6_CEP
		Li++
		@ Li,001 PSay "Municipio.....: "+SA6->A6_MUN
		Li++
		@ Li,001 PSay "Estado........: "+SA6->A6_EST
		Li++
		@ Li,001 PSay __PrtThinLine()
		Li++
	Endif
	nVez++
	dbSkip()
End

If Li <> 80
   Roda(cbCont,cbTxt,Tamanho)
Endif

If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   Ourspool(wnrel)
EndIf

Ms_Flush()

Return