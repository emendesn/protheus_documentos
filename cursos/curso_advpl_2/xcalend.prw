/*****
 *
 * Modelo usando a classe MsCalend.
 *
 */
#include "protheus.ch"

User Function xCalend()
	Local oDlg
	Local oCalend
	
	DEFINE MSDIALOG oDlg TITLE "Classe MsCalend" FROM 0,0 TO 130,280 PIXEL

		oCalend := MsCalend():New(1,1,oDlg)
		oCalend:dDiaAtu := dDataBase
		oCalend:ColorDay(1,CLR_HRED) //nome do dia da semana, neste caso o n�mero 1 � domingo.
		oCalend:bChangeMes := {|a,b| MsgAlert("Mudou...") }
		oCalend:bChange := {|| MsgAlert( DiaExtenso( oCalend:dDiaAtu )+" - "+Dtoc( oCalend:dDiaAtu ) ) }
		
		//Para determinar um dia do m�s como restrito � preciso utilizar este met�do.
		//Quando for determinado o dia a data ficar� na cor vermelha.
		oCalend:AddRestri( Day( dDataBase+1 ),CLR_HRED, CLR_WHITE )

	ACTIVATE MSDIALOG oDlg CENTER	
Return