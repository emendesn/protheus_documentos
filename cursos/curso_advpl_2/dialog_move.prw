///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Dialog_Move.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_DialogMov()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que demonstra como mover (expandir) uma dialog           |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#INCLUDE "PROTHEUS.CH"

USER FUNCTION DialogMov()

LOCAL   oDlg
LOCAL   oRadio
LOCAL   aRadio   := {}
LOCAL   nRadio   := 0
LOCAL   lDetail  := .T.
LOCAL   cBco     := Space(Len(SA6->A6_COD))
LOCAL   cAge     := Space(Len(SA6->A6_AGENCIA))
LOCAL   cCta     := Space(Len(SA6->A6_NUMCON))

aAdd(aRadio,"Contrato")
aAdd(aRadio,"Nota Promissória")
aAdd(aRadio,"Carnê de Pagamento")

DEFINE MSDIALOG oDlg FROM 0,0 TO 80,227 PIXEL TITLE "O que deseja imprimir ?"

   @ 001,003 TO 040,080 LABEL "" OF oDlg PIXEL
   @ 008,008 RADIO oRadio VAR nRadio ITEMS aRadio[1],aRadio[2],aRadio[3] SIZE 060,009 ;
         PIXEL OF oDlg ON CHANGE Detail(oDlg,nRadio)                
   DEFINE SBUTTON FROM 003,084 TYPE 1 OF oDlg ENABLE ONSTOP "Confirma o início da impressão escolhida" ACTION oDlg:End()
   DEFINE SBUTTON FROM 020,084 TYPE 2 OF oDlg ENABLE ONSTOP "Sair..." ACTION oDlg:End()
	oDlg:bStart:={||DigBco(@cBco,@cAge,@cCta,@oDlg)}
   
ACTIVATE MSDIALOG oDlg CENTER VALID Iif(nRadio==3,!Empty(cBco),.T.)
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Dialog_Move.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Detail()                                               |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que expande ou nao o msdialog                            |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION Detail(oDlg,nRadio)
oDlg:CoorsUpdate()
If nRadio == 3
	oDlg:Move(oDlg:nTop,oDlg:nLeft,235,169)
Else
	oDlg:Move(oDlg:nTop,oDlg:nLeft,235,107)
Endif
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Dialog_Move.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - DigBco()                                               |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que disponibiliza os campos caso o MsDialog for expandido|//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION DigBco(cBco,cAge,cCta,oDlg)
@ 043,003 TO 070,112 LABEL "" OF oDlg PIXEL
@ 047,006 SAY "Banco"   SIZE 15,7 PIXEL OF oDlg
@ 047,032 SAY "Agência" SIZE 20,7 PIXEL OF oDlg
@ 047,065 SAY "Conta"   SIZE 15,7 PIXEL OF oDlg
@ 056,006 MSGET cBco F3 "SA6" VALID ExistCpo("SA6",cBco) PICTURE "@!" SIZE 10,7 PIXEL OF oDlg
@ 056,032 MSGET cAge PICTURE "@!" WHEN .F. SIZE 10,7 PIXEL OF oDlg
@ 056,065 MSGET cCta PICTURE "@!" WHEN .F. SIZE 10,7 PIXEL OF oDlg
Return