///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBox.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBox()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que demonstra a utilizacao de listbox                    |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function List_Box()

Local aVetor := {}
Local oDlg
Local oLbx
Local cTitulo := "Cadastro de Bancos"
Local aCab := {}
Local cSaldo 

dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial("SA6"))

// Carrega o vetor conforme a condicao.
While !Eof() .And. A6_FILIAL == xFilial("SA6")
   cSaldo := TransForm(A6_SALATU,X3Picture("A6_SALATU"))
   aAdd( aVetor, { 	A6_COD, ;
   						A6_AGENCIA, ;
   						A6_NUMCON, ;
   						A6_NOME, ;
   						A6_NREDUZ, ;
   						A6_BAIRRO, ;
   						A6_MUN, ;
   						MsPadL(cSaldo,100) } )
	dbSkip()
End

// Se não houver dados no vetor, avisar usuário e abandonar rotina.
If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao existe dados a consultar", {"Ok"} )
   Return
Endif

// Monta a tela para usuário visualizar consulta.
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

   // Primeira opção para montar o listbox.
   @ 10,10 LISTBOX oLbx FIELDS HEADER ;
   "Banco", "Agencia", "C/C", "Nome Banco", "Fantasia", "Bairro", "Municipio", "Saldo Atual" ;
   SIZE 230,95 OF oDlg PIXEL	

   oLbx:SetArray( aVetor )
   oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;
                      aVetor[oLbx:nAt,2],;
                      aVetor[oLbx:nAt,3],;
                      aVetor[oLbx:nAt,4],;
                      aVetor[oLbx:nAt,5],;
                      aVetor[oLbx:nAt,6],;
                      aVetor[oLbx:nAt,7],;
                      aVetor[oLbx:nAt,8]}}
                   
   // Segunda opção para monta o listbox
   /*
	aCab := {RetTitle("A6_COD"),RetTitle("A6_AGENCIA"),RetTitle("A6_NUMCON"),;
				RetTitle("A6_NOME"),RetTitle("A6_NREDUZ"),RetTitle("A6_BAIRRO"),RetTitle("A6_MUN")}   
   oLbx := TWBrowse():New(10,10,230,95,,aCab,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
   oLbx:SetArray( aVetor )
   oLbx:bLine := {|| aEval(aVetor[oLbx:nAt],{|z,w| aVetor[oLbx:nAt,w] } ) }
   */
	                    
DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

Return