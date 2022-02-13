#include "rwmake.ch" 
#include "TOPCONN.CH"       



/*/
+---------------------------------------------------------------------------+
| Programa  | BGHSX5ZU   | Autor | Delta Decisao          | Data | 21/03/12 |
+-----------+---------------------------------------------------------------+
| Descri��o | Permite dar manuten��o em uma tabela do SX5 atrav�s de uma    |
|           | MBrowse.                                                      |
+---------------------------------------------------------------------------+
| Uso       | Espec�fico BGH                                                |
+---------------------------------------------------------------------------+
/*/

User Function BGHSX5ZU()

//+---------------------------------------------------------------------+
//| Par�metros:                                                         |
//+---------------------------------------------------------------------+
//| Obrigat�rios:                                                       |
//| 1 - _cCodTab - C�digo da Tabela                                     |
//| 2 - _cDscTab - Descri��o da Tabela (Cabe�alho da MBrowse)           |
//| 3 - _lIntRef - Indica se usa Integridade Referencial                |
//|                                                                     |
//| Obrigat�rios apenas para quando o par�metro 3 for .T.               |
//| 4 - _aTabelas - Array com os Alias das Tabelas Referenciadas        |
//| 5 - _aCampos  - Array com os nomes dos campos a serem referenciados |
//+---------------------------------------------------------------------+

Local   _aArea    := GetArea()

Private _cCodTab  := "ZU"
Private _cDscTab  := "RELACIONAMENTO ENTRE ARMAZENS"                          
Private _lIntRef  := .F.
Private _aTabelas := {}//aClone(_xTabelas)
Private _aCampos  := {}//aClone(_xCampos)
Private _cAlias   := ""
Private _lUserZU  := IIF(UPPER(Alltrim(cUsername)) $ UPPER(GETMV("BH_USERZU",.F.,"FERNANDO.PERATELLO")),.T.,.F.)
Private _cMsgZU	  := "Usuario sem acesso. Entre em contato com o Administrador!"

u_GerA0003(ProcName())

dbSelectArea("SX5")
SX5->(dbSetOrder(1))
_cAlias := Alias()

cCadastro := _cDscTab

aRotina := {{"Pesquisar" ,"AxPesqui"           ,0,1},;
			{"Visualizar","U_BGHX5Vis(_cAlias)",0,2},;
			{"Incluir"   ,"U_BGHX5Inc(_cAlias)",0,3},;
			{"Alterar"   ,"U_BGHX5Alt(_cAlias)",0,4},;
			{"Excluir"   ,"U_BGHX5Del(_cAlias,_lIntRef,_aTabelas,_aCampos)",0,5,5} }
			                                                              			 
dbSelectArea(_cAlias)
SX5->(dbSetFilter({|| X5_FILIAL == xFilial("SX5") .And. Alltrim(X5_TABELA) == Alltrim(_cCodTab)},'X5_FILIAL == xFilial("SX5") .And. Alltrim(X5_TABELA) == Alltrim(_cCodTab)'))
SX5->(dbGoTop())

MBrowse(6,1,22,75,_cAlias)

dbSelectArea("SX5")
SX5->(dbSetOrder(1))

RestArea(_aArea)

Return

/*/
+---------------------------------------------------------------------------+
| Fun��o    | BGHX5Vis   | Autor | Delta Decisao          | Data | 21/03/12 |
+-----------+---------------------------------------------------------------+
| Descri��o | Rotina de Visualiza��o da Tabela no SX5.                      |
+-----------+---------------------------------------------------------------+
| Uso       | Espec�fico BGH                                                |
+---------------------------------------------------------------------------+
/*/

User Function BGHX5Vis(_cAlias)

AxVisual(_cAlias,Recno(),2,{"X5_CHAVE","X5_DESCRI","X5_DESCENG","X5_DESCSPA"})
 
Return



/*/
+---------------------------------------------------------------------------+
| Fun��o    | BGHX5Inc   | Autor | Delta Decisao          | Data | 21/03/12 |
+-----------+---------------------------------------------------------------+
| Descri��o | Rotina de Inclus�o da Tabela no SX5.                          |
+-----------+---------------------------------------------------------------+
| Uso       | Espec�fico BGH                                                |
+---------------------------------------------------------------------------+
/*/
       
User Function BGHX5Inc(_cAlias)

Local _nOpc    := 0   
Local _cTabela := SX5->X5_TABELA

If !_lUserZU
	MsgAlert(_cMsgZU)
	Return
Endif
         
RecLock("SX5",.T.)
SX5->X5_TABELA := _cTabela
SX5->(MsUnLock())
 
_nOpc := AxAltera(_cAlias,Recno(),3,{"X5_CHAVE","X5_DESCRI","X5_DESCENG","X5_DESCSPA"},{"X5_CHAVE","X5_DESCRI","X5_DESCENG","X5_DESCSPA"})

If _nOpc <> 1
	RecLock("SX5",.F.)
	SX5->(dbDelete())
	SX5->(MsUnLock())
EndIf
dbSelectArea("SX5")
SX5->(dbGoTop())
 
Return



/*/
+---------------------------------------------------------------------------+
| Fun��o    | BGHX5Alt   | Autor | Delta Decisao          | Data | 21/03/12 |
+-----------+---------------------------------------------------------------+
| Descri��o | Rotina de Altera��o da Tabela no SX5.                         |
+-----------+---------------------------------------------------------------+
| Uso       | Espec�fico BGH                                                |
+---------------------------------------------------------------------------+
/*/
       
User Function BGHX5Alt(_cAlias)

If !_lUserZU
	MsgAlert(_cMsgZU)
	Return
Endif

AxAltera(_cAlias,Recno(),4,{"X5_CHAVE","X5_DESCRI","X5_DESCENG","X5_DESCSPA"},{"X5_CHAVE","X5_DESCRI","X5_DESCENG","X5_DESCSPA"})
 
Return



/*/
+---------------------------------------------------------------------------+
| Fun��o    | BGHX5Del   | Autor | Delta Decisao          | Data | 21/03/12 |
+-----------+---------------------------------------------------------------+
| Descri��o | Rotina de Exclus�o da Tabela no SX5.                          |
+-----------+---------------------------------------------------------------+
| Uso       | Espec�fico BGH                                                |
+---------------------------------------------------------------------------+
/*/
       
User Function BGHX5Del(_cAlias,_lIntRef,_aTabelas,_aCampos)

Local _lDelete := .T.      

If !_lUserZU
	MsgAlert(_cMsgZU)
	Return
Endif
 
If (_lDelete)
	If MsgYesNo("Deseja realmente excluir?")
		RecLock("SX5",.F.)
		SX5->(dbDelete())
		SX5->(MsUnlock())
	EndIf
EndIf

dbSelectArea("SX5")
SX5->(dbGoTop())
 
Return