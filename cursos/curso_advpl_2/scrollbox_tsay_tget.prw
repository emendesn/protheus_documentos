///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ScrollBox_TSay_TGet  | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Scroll                                               |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Demonstracao de como montar uma enchoice so com variaveis       |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#INCLUDE "PROTHEUS.CH"

USER FUNCTION Scroll()

LOCAL oDlg := NIL
LOCAL oScroll := NIL
LOCAL oLbx1 := NIL
LOCAL oLbx2 := NIL
LOCAL bGet := NIL
LOCAL oGet := NIL
LOCAL aAIIPM := {}
LOCAL aTitulo := {}

LOCAL nTop := 5
LOCAL nWidth := 0
LOCAL n := 0

LOCAL cGet := ""
LOCAL cPict := ""
LOCAL cVar := ""

PRIVATE cTitulo := "Consulta Parcelamento"
PRIVATE aSay := {}
PRIVATE cProcesso,cPrefixo,cTipo,cCliente,cLoja,cNome,cCGC,dData,nTotal,nUFESP,cStatus,cCond

cProcesso := "P00001"
cPrefixo  := "UNI"
cTipo     := "MAN"
cCliente  := "000001"
cLoja     := "01"
cNome     := "JOSE DA SILVA SANTOS SOARES"
cCGC      := "00.000.000/0001-91"
dData     := "26/03/03"
nTotal    := 5922.00
nUFESP    := 1000.00
cStatus   := "Z"
cCond     := "001"

// Vetor para os campos no Scroo Box
//+-------------------------------+
//| aSay[n][1] - Titulo           |
//| aSay[n][2] - Tipo             |
//| aSay[n][3] - Tamanho          |
//| aSay[n][4] - Decimal          |
//| aSay[n][5] - Conteudo/Variavel|
//| aSay[n][6] - Formato          |
//+-------------------------------+
aAdd(aSay,{"Processo"    ,"C",06,0,"cProcesso" ,"@!"})
aAdd(aSay,{"Prefixo"     ,"C",03,0,"cPrefixo"  ,"@!"})
aAdd(aSay,{"Tipo"        ,"C",03,0,"cTipo"     ,"@!"})
aAdd(aSay,{"Cliente"     ,"C",06,0,"cCliente"  ,"@!"})
aAdd(aSay,{"Loja"        ,"C",02,0,"cLoja"     ,"@!"})
aAdd(aSay,{"Nome"        ,"C",30,0,"cNome"     ,"@!"})
aAdd(aSay,{"CNPJ/CPF"    ,"C",14,0,"cCGC"      ,"@!"})
aAdd(aSay,{"Dt.Processo" ,"D",08,0,"dData"     ,"@!"})
aAdd(aSay,{"Total R$"    ,"N",17,2,"nTotal"    ,"@!"})
aAdd(aSay,{"Total UFESP" ,"N",17,2,"nUFESP"    ,"@!"})
aAdd(aSay,{"Status"      ,"C",01,0,"cStatus"   ,"@!"})
aAdd(aSay,{"Cond.Pagto"  ,"C",03,0,"cCond"     ,"@!"})

// Vetor para List Box
aAdd(aAIIPM,{"1234","DCD9815","26/03/03"})
aAdd(aAIIPM,{"1234","DCD9815","26/03/03"})
aAdd(aAIIPM,{"1234","DCD9815","26/03/03"})

// Vetor para List Box
aAdd(aTitulo,{"A","26/03/03","26/03/03","1.974,00","100,00"})
aAdd(aTitulo,{"A","26/03/03","26/03/03","1.974,00","100,00"})
aAdd(aTitulo,{"A","26/03/03","26/03/03","1.974,00","100,00"})

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 122,0 TO 432,600 OF oDlg PIXEL
   @ 013,002 TO 154,192 LABEL "Parcelamento"  OF oDlg PIXEL
   @ 013,195 TO 082,298 LABEL "Títulos"       OF oDlg PIXEL
   @ 083,195 TO 154,298 LABEL "AIIPM"         OF oDlg PIXEL
   
   //scroll box
   @ 019,006 SCROLLBOX oScroll HORIZONTAL VERTICAL SIZE 131,182 OF oDlg BORDER      
   For n:=1 TO Len(aSay)
      bGet := &("{|| '"+aSay[n,1]+"'}")
      cVar := aSay[n,5]
      cGet  := "{|u| iif(PCount()>0,"+cVar+":=u,"+cVar+")}"
      cPict := aSay[n,6]      
      TSay():New(nTop,5,bGet,oScroll,,,.F.,.F.,.F.,.T.,,,GetTextWidth(0,Trim(aSay[n,1])),15,.F.,.F.,.F.,.F.,.F.)
      oGet:=TGet():New(nTop-2,40,&cGet,oScroll,,7,cPict,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,(cVar),,,,.T.)
      nTop+=11
   Next n
   
   //list box titulos
   @ 019,199 LISTBOX oLbx1 FIELDS HEADER ;
     "Parcela","Vencto","Vencto.Real","Valor R$","Qtd.UFESP";
     COLSIZES 21,24,33,63,100;
     SIZE 095,059 OF oDlg PIXEL
   oLbx1:SetArray( aTitulo )
   oLbx1:bLine := {||{aTitulo[oLbx1:nAt,1],aTitulo[oLbx1:nAt,2],;
   aTitulo[oLbx1:nAt,3],aTitulo[oLbx1:nAt,4],aTitulo[oLbx1:nAt,5]}}   
   
   //list box aiipm
   @ 089,199 LISTBOX oLbx2 FIELDS HEADER "AIIPM","Placa","Data Multa" ;
   COLSIZES 24,21,30 SIZE 095,061 OF oDlg PIXEL
   oLbx2:SetArray( aAIIPM )
   oLbx2:bLine := {||{aAIIPM[oLbx2:nAt,1],aAIIPM[oLbx2:nAt,2],aAIIPM[oLbx2:nAt,3]}}   
   
ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

RETURN