///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxMark2.prw     | AUTOR | Robson Luiz  | DATA | 30/08/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxMar()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que demonstra a utilizacao de listbox com metodo mark,   |//
//|           | podendo marcar somente um registro.                             |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#include "Protheus.Ch"

User Function LstBxMr2()

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
   SIZE 230,095 OF oDlg PIXEL ON dblClick( Marca() )

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
	 
@ 110,10 SAY "Somente será possível marcar um registro." SIZE 160,7 PIXEL OF oDlg

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
Static Function Marca()
Local i := 0
Local nPos := 0

// Verificar se há algum item marcado
// Há item marcado?
// 	Não, então marque.
// 	Sim, o item marcado é o mesmo que já está marcado?
//			Sim, então inverta a marca.
//			Não, então desmaque o item marcado e marque o item desejado.
nPos := AScan( aVetor, {|x| x[1] == .T. } )

If nPos == 0
	aVetor[ oLbx:nAt, 1 ] := .T.
Else
	If nPos == oLbx:nAt
		aVetor[ nPos, 1 ] := ! aVetor[ nPos, 1 ]
	Else
		aVetor[ nPos, 1 ] := .F.
		aVetor[ oLbx:nAt, 1 ] := .T.
	Endif
Endif

oLbx:Refresh()
Return