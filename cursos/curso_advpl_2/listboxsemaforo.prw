///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxSemaforo.prw  | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxSemaforo()                                    |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Programa exemplo usando Listbox com semaforo                    |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function ListBoxSem()

Local oDlg
Local oLbx
Local aVetor := {}
Local cTitulo := "Consulta Banco"
Local oOk := LoadBitmap( GetResources(), "BR_VERDE" )
Local oNo := LoadBitmap( GetResources(), "BR_VERMELHO" )
Local cSaldo

dbSelectArea("SA6") 
dbSetOrder(1)
dbSeek(xFilial("SA6"))

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
While !Eof() .And. A6_FILIAL == xFilial("SA6")
	cSaldo := TransForm(A6_SALATU,X3Picture("A6_SALATU"))
   aAdd( aVetor, { 	(A6_SALATU>1000), ;
   						A6_COD, ;
   						A6_AGENCIA, ;
   						A6_NUMCON, ;
   						A6_NOME, ;
   						A6_NREDUZ, ;
   						A6_BAIRRO, ;
   						A6_MUN, ;
   						MsPadL(cSaldo,100) } )
	dbSkip()
End

If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao existe bancos a consultar", {"Ok"} )
   Return
Endif

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
@ 10,10 LISTBOX oLbx FIELDS HEADER ;
   " ", "Banco", "Agencia", "C/C", "Nome Banco", "Fantasia", "Bairro", "Municipio","Saldo Atual" ;
   SIZE 230,095 OF oDlg PIXEL	

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {IIF(aVetor[oLbx:nAt,1],oOk,oNo),;
                   aVetor[oLbx:nAt,2],;
                   aVetor[oLbx:nAt,3],;
                   aVetor[oLbx:nAt,4],;
                   aVetor[oLbx:nAt,5],;
                   aVetor[oLbx:nAt,6],;
                   aVetor[oLbx:nAt,7],;
                   aVetor[oLbx:nAt,8],;
                   aVetor[oLbx:nAt,9]}}
	                    
DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER
Return