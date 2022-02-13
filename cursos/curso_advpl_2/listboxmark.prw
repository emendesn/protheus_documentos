///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxMark.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxMar()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que demonstra a utilizacao de listbox com metodo mark    |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#include "Protheus.Ch"

User Function ListBoxMar()

Local oDlg
Local cVar     := ""
Local cTitulo  := "Consulta Bancos"
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk1
Local oChk2
Local cSaldo 

Private lChk1 := .F.
Private lChk2 := .F.
Private oLbx
Private aVetor := {}

dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial("SA6"))

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
While !Eof() .And. A6_FILIAL == xFilial("SA6")	
	cSaldo := TransForm(A6_SALATU,X3Picture("A6_SALATU"))
   aAdd( aVetor, { 	lMark, ;
   						A6_COD, ;
   						A6_AGENCIA, ;
   						A6_NUMCON, ;
   						A6_NOME, ;
   						A6_NREDUZ, ;
   						A6_BAIRRO, ;
   						A6_MUN,;
   						MsPadL(cSaldo,100) })
	dbSkip()
End

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao existe bancos a consultar", {"Ok"} )
   Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
   
@ 10,10 LISTBOX oLbx FIELDS HEADER ;
   " ", "Banco", "Agencia", "C/C", "Nome Banco", "Fantasia", "Bairro", "Municipio", "Saldo Atual" ;
   SIZE 230,095 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
                       aVetor[oLbx:nAt,2],;
                       aVetor[oLbx:nAt,3],;
                       aVetor[oLbx:nAt,4],;
                       aVetor[oLbx:nAt,5],;
                       aVetor[oLbx:nAt,6],;
                       aVetor[oLbx:nAt,7],;
                       aVetor[oLbx:nAt,8],;
                       aVetor[oLbx:nAt,9]}}
	 
//+----------------------------------------------------------------
//| Para marcar e desmarcar todos existem duas opçoes, acompanhe...
//+----------------------------------------------------------------
//| Chamando uma funcao própria
//+----------------------------------------------------------------
//@ 110,10 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca" SIZE 60,7 PIXEL OF oDlg;
//         ON CLICK( Marca(lChk1) )

//+------------------------------------------------------------------
//| Para inverter a seleção marcada existem duas opçoes, acompanhe...
//+------------------------------------------------------------------
//| Chamando uma funcao própria
//+----------------------------------------------------------------
//@ 110,10 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca" SIZE 60,7 PIXEL OF oDlg;
//         ON CLICK( Inverte() )

//+----------------------------------------------------------------
//| ... ou utilizando a função aEval()
//+----------------------------------------------------------------
@ 110,10 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca Todos" SIZE 70,7 PIXEL OF oDlg ;
         ON CLICK( aEval( aVetor, {|x| x[1] := lChk1 } ),oLbx:Refresh() )

//+----------------------------------------------------------------
//| ... ou utilizando a função aEval()
//+----------------------------------------------------------------
@ 110,95 CHECKBOX oChk2 VAR lChk2 PROMPT "Iverter a seleção" SIZE 70,7 PIXEL OF oDlg ;
         ON CLICK( aEval( aVetor, {|x| x[1] := !x[1] } ), oLbx:Refresh() )

DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxMark.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxMar()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que marca ou desmarca todos os objetos                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
/*
Static Function Marca(lMarca)
Local i := 0
For i := 1 To Len(aVetor)
   aVetor[i][1] := lMarca
Next i
oLbx:Refresh()
Return
*/

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxMark.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxMar()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que inverte a seleção marcada de todos os objetos        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
/*
Static Function Inverte()
Local i := 0
For i := 1 To Len(aVetor)
   aVetor[i][1] := !aVetor[i][1]
Next i
oLbx:Refresh()
Return