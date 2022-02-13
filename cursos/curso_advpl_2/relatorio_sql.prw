///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relatorio_SQL.prw    | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Rel_SQL()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Programa que demonstra a utiliacao das funcao para SQL          |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*Lay-Out do Relatorio -> SQL
---------------------------------------------------------------------------------------------------------------------------------
| PREFIXO | TITULO | PARCELA | TIP | EMISSAO | VENCTO | VENCTO REAL |     VLR. ORIGINAL |              PAGO |             SALDO |
---------------------------------------------------------------------------------------------------------------------------------
| Cod/Loj/Nome: 999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                        |
|   UNI   | 999999 |    A    | NFX |99/999/99|99/99/99|   99/99/99  | 99,999,999,999.99 | 99,999,999,999.99 | 99,999,999,999.99 |
|   UNI   | 999999 |    A    | NFX |99/999/99|99/99/99|   99/99/99  | 99,999,999,999.99 | 99,999,999,999.99 | 99,999,999,999.99 |
|   UNI   | 999999 |    A    | NFX |99/999/99|99/99/99|   99/99/99  | 99,999,999,999.99 | 99,999,999,999.99 | 99,999,999,999.99 |
---------------------------------------------------------------------------------------------------------------------------------
| TOTAL.....
---------------------------------------------------------------------------------------------------------------------------------
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
          1         2         3         4         5         6         7         8         9        10        11        12
*/

User Function Rel_SQL()

//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------

Local cDesc1  := "Este relatorio ira imprimir informacoes do contas a pagar conforme"         
Local cDesc2  := "parametros informado."
Local cDesc3  := "Será gerado um arquivo no Spool - REL_DBF????.XLS, onde ???? e o usuario."

Private cString  := "SE2"
Private Tamanho  := "M"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RELSQL"
Private NomeProg := "RELSQL"
Private nLastKey := 0
Private Limite   := 132
Private Titulo   := "Titulo a Pagar - Ordem de "
Private cPerg    := "RELSQL"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {}
Private Cabec1   := "  PREFIXO   TITULO   PARCELA   TIP   EMISSAO   VENCTO   VENCTO REAL       VLR. ORIGINAL                PAGO               SALDO  "
Private Cabec2   := ""

#IFNDEF TOP
   MsgInfo("Não é possível executar este programa, está base de dados não é TopConnect","Incompatibilidade")
   RETURN
#ENDIF

/*+----------------------
  | Parametros do aReturn 
  +----------------------
aReturn - Preenchido pelo SetPrint()
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

aAdd( aOrd, "Fornecedor"   )
aAdd( aOrd, "Titulo"       )
aAdd( aOrd, "Emissão"      )
aAdd( aOrd, "Vencimento"   )
aAdd( aOrd, "Vencto. Real" )

//Parametros de perguntas para o relatorio
//+-------------------------------------------------------------+
//| mv_par01 - Fornecedor de      ? 999999                      |
//| mv_par02 - Fornecedor ate     ? 999999                      |
//| mv_par03 - Tipo de            ? XXX                         |
//| mv_par04 - Tipo ate           ? XXX                         |
//| mv_par05 - Vencimento de      ? 99/99/99                    |
//| mv_par06 - Vencimento ate     ? 99/99/99                    |
//| mv_par07 - Aglut.Fornecedor   ? Ativados/Nao Ativados Ambos |
//+-------------------------------------------------------------+
CriaSx1()

//+-------------------------------------------------------------------------------
//| Disponibiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------
Pergunte(cPerg,.F.)

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
RptStatus({|lEnd| RelSQLImp(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relatorio_SQL.prw    | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_RelSQLImp()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de impressao                                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function RelSQLImp(lEnd,wnrel,cString)
Local cFilSE2   := xFilial(cString)
Local cQuery    := ""
Local aCol      := {}
Local cFornec   := ""
Local nValor    := 0
Local nPago     := 0
Local nSaldo    := 0
Local nT_Valor  := 0
Local nT_Pago   := 0
Local nT_Saldo  := 0
Local cArqExcel := ""

//+-----------------------
//| Cria filtro temporario
//+-----------------------
cQuery := "SELECT "
cQuery += "E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, "
cQuery += "E2_EMISSAO, E2_VENCTO, E2_VENCREA, E2_VALOR, E2_SALDO "
cQuery += "FROM "+RetSqlName("SE2")+" "
cQuery += "WHERE E2_FILIAL = '"+cFilSE2+"' "
cQuery += "AND E2_FORNECE >= '"+mv_par01+"' "
cQuery += "AND E2_FORNECE <= '"+mv_par02+"' "
cQuery += "AND E2_TIPO >= '"+mv_par03+"' "
cQuery += "AND E2_TIPO <= '"+mv_par04+"' "
cQuery += "AND E2_VENCTO >= '"+Dtos(mv_par05)+"' "
cQuery += "AND E2_VENCTO <= '"+Dtos(mv_par06)+"' "
cQuery += "AND D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY "
//+-----------------------
//| Cria indice temporario
//+-----------------------
If aReturn[8] == 1            //Fornecedor
   cQuery += "E2_FORNECE,E2_LOJA,E2_NUM"
Elseif aReturn[8] == 2        //Titulo
   cQuery += "E2_NUM,E2_FORNECE,E2_LOJA"
Elseif aReturn[8] == 3        //Emissao
   cQuery += "E2_EMISSAO,E2_FORNECE,E2_LOJA"
Elseif aReturn[8] == 4        //Vencimento
   cQuery += "E2_VENCTO,E2_FORNECE,E2_LOJA"
Elseif aReturn[8] == 5        //Vencimento Real
   cQuery += "E2_VENCREA,E2_FORNECE,E2_LOJA"
Endif

Titulo += aOrd[aReturn[8]]

//+-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
dbSelectArea("TRB")
dbGoTop()
SetRegua( RecCount() )

//+--------------------
//| Coluna de impressao
//+--------------------
aAdd( aCol, 004 ) //Prefixo
aAdd( aCol, 012 ) //Titulo
aAdd( aCol, 024 ) //Parcela
aAdd( aCol, 031 ) //Tipo
aAdd( aCol, 036 ) //Emissao
aAdd( aCol, 046 ) //Vencimento
aAdd( aCol, 058 ) //Vencimento Real
aAdd( aCol, 070 ) //Valor Original
aAdd( aCol, 090 ) //Pago
aAdd( aCol, 110 ) //Saldo

cFornec := TRB->E2_FORNECE+TRB->E2_LOJA

While !Eof() .And. !lEnd
   
   If Li > 55
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   Endif
   
   @ Li, aCol[1] PSay "Cod/Loj/Nome: "+TRB->E2_FORNECE+"-"+TRB->E2_LOJA+" "+TRB->E2_NOMFOR
   Li ++
   
   While !Eof() .And. !lEnd .And. TRB->E2_FORNECE+TRB->E2_LOJA == cFornec
   
      IncRegua()
      
      If Li > 55
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      Endif
   
      If mv_par07 == 2
         @ Li, aCol[1]  PSay TRB->E2_PREFIXO
         @ Li, aCol[2]  PSay TRB->E2_NUM
         @ Li, aCol[3]  PSay TRB->E2_PARCELA
         @ Li, aCol[4]  PSay TRB->E2_TIPO
         @ Li, aCol[5]  PSay TRB->E2_EMISSAO
         @ Li, aCol[6]  PSay TRB->E2_VENCTO
         @ Li, aCol[7]  PSay TRB->E2_VENCREA
         @ Li, aCol[8]  PSay TRB->E2_VALOR               PICTURE "@E 99,999,999,999.99"
         @ Li, aCol[9]  PSay TRB->E2_VALOR-TRB->E2_SALDO PICTURE "@E 99,999,999,999.99"
         @ Li, aCol[10] PSay TRB->E2_SALDO               PICTURE "@E 99,999,999,999.99"
         Li ++
      Endif
      
      nValor += TRB->E2_VALOR
      nPago  += (TRB->E2_VALOR-TRB->E2_SALDO)
      nSaldo += TRB->E2_SALDO
   
      nT_Valor += TRB->E2_VALOR
      nT_Pago  += (TRB->E2_VALOR-TRB->E2_SALDO)
      nT_Saldo += TRB->E2_SALDO

      dbSkip()
   End
   
   @ Li, 000 PSay Replicate("-",Limite)
   Li ++
   @ Li, aCol[1]  PSay "TOTAL....."
   @ Li, aCol[8]  PSay nValor PICTURE "@E 99,999,999,999.99"
   @ Li, aCol[9]  PSay nPago  PICTURE "@E 99,999,999,999.99"
   @ Li, aCol[10] PSay nSaldo PICTURE "@E 99,999,999,999.99"
   Li +=2
   
   cFornec := TRB->E2_FORNECE+TRB->E2_LOJA
   nValor  := 0
   nPago   := 0
   nSaldo  := 0
      
End

If lEnd
   @ Li, aCol[1] PSay cCancel
   Return
Endif

@ Li, 000 PSay Replicate("=",Limite)
Li ++
@ Li, aCol[1]  PSay "TOTAL GERAL....."
@ Li, aCol[8]  PSay nT_Valor PICTURE "@E 99,999,999,999.99"
@ Li, aCol[9]  PSay nT_Pago  PICTURE "@E 99,999,999,999.99"
@ Li, aCol[10] PSay nT_Saldo PICTURE "@E 99,999,999,999.99"
   
If Li <> 80
   Roda(cbCont,cbTxt,Tamanho)
Endif

//+-------------------------------------------------------------------------------
//| Gera arquivo do tipo .DBF com extensao .XLS p/ usuario abrir no Excel.
//+-------------------------------------------------------------------------------
cArqExcel := __RELDIR+NomeProg+Substr(cUsuario,7,4)+".XLS"
Copy To &cArqExcel

dbSelectArea("TRB")
dbCloseArea()

If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   Ourspool(wnrel)
EndIf

Ms_Flush()

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relatorio_SQL.prw    | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaSX1()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que cria o grupo de perguntas se caso nao existir        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()
Local aP := {}
Local i := 0
Local cSeq
Local cMvCh
Local cMvPar
Local aHelp := {}

/******
Parametros da funcao padrao
---------------------------
PutSX1(cGrupo,;
       cOrdem,;
       cPergunt,cPerSpa,cPerEng,;
       cVar,;
       cTipo,;
       nTamanho,;
       nDecimal,;
       nPresel,;
       cGSC,;
       cValid,;
       cF3,;
       cGrpSxg,;
       cPyme,;
       cVar01,;
       cDef01,cDefSpa1,cDefEng1,;
       cCnt01,;
       cDef02,cDefSpa2,cDefEng2,;
       cDef03,cDefSpa3,cDefEng3,;
       cDef04,cDefSpa4,cDefEng4,;
       cDef05,cDefSpa5,cDefEng5,;
       aHelpPor,aHelpEng,aHelpSpa,;
       cHelp)

Característica do vetor p/ utilização da função SX1
---------------------------------------------------
[n,1] --> texto da pergunta
[n,2] --> tipo do dado
[n,3] --> tamanho
[n,4] --> decimal
[n,5] --> objeto G=get ou C=choice
[n,6] --> validacao
[n,7] --> F3
[n,8] --> definicao 1
[n,9] --> definicao 2
[n,10] -> definicao 3
[n,11] -> definicao 4
[n,12] -> definicao 5
***/
aAdd(aP,{"Fornecedor de"             ,"C",6,0,"G",""                    ,"SA2",""   ,""   ,"","",""})
aAdd(aP,{"Fornecedor ate"            ,"C",6,0,"G","(mv_par02>=mv_par01)","SA2",""   ,""   ,"","",""})
aAdd(aP,{"Tipo de"                   ,"C",3,0,"G",""                    ,"05" ,""   ,""   ,"","",""})
aAdd(aP,{"Tipo ate"                  ,"C",3,0,"G","(mv_par04>=mv_par03)","05" ,""   ,""   ,"","",""})
aAdd(aP,{"Vencimento de"             ,"D",8,0,"G",""                    ,""   ,""   ,""   ,"","",""})
aAdd(aP,{"Vencimento ate"            ,"D",8,0,"G","(mv_par06>=mv_par05)",""   ,""   ,""   ,"","",""})
aAdd(aP,{"Aglutinar pagto.de fornec.","N",1,0,"C",""                    ,""   ,"Sim","Nao","","",""})

aAdd(aHelp,{"Informe o código do fornecedor.","inicial."})
aAdd(aHelp,{"Informe o código do fornecedor.","final."})
aAdd(aHelp,{"Tipo de título inicial."})
aAdd(aHelp,{"Tipo de título final."})
aAdd(aHelp,{"Digite a data do vencimento incial."})
aAdd(aHelp,{"Digite a data do vencimento final."})
aAdd(aHelp,{"Aglutinar os títulos do mesmo forne-","cedor totalizando seus valores."})

For i:=1 To Len(aP)
	cSeq   := StrZero(i,2,0)
	cMvPar := "mv_par"+cSeq
	cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	
	PutSx1(cPerg,;
	cSeq,;
	aP[i,1],aP[i,1],aP[i,1],;
	cMvCh,;
	aP[i,2],;
	aP[i,3],;
	aP[i,4],;
	0,;
	aP[i,5],;
	aP[i,6],;
	aP[i,7],;
	"",;
	"",;
	cMvPar,;
	aP[i,8],aP[i,8],aP[i,8],;
	"",;
	aP[i,9],aP[i,9],aP[i,9],;
	aP[i,10],aP[i,10],aP[i,10],;
	aP[i,11],aP[i,11],aP[i,11],;
	aP[i,12],aP[i,12],aP[i,12],;
	aHelp[i],;
	{},;
	{},;
	"")
Next i

Return