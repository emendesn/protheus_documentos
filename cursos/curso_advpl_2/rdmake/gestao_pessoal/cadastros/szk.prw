#Include "PROTHEUS.CH"

User Function TabSZK()

Local cAlias  := "SZK"
Local cTitulo := "Cadastro de Celulas"
Local cVldExc := ".T." //Valida��o para Exclus�o
Local cVldAlt := ".T." //Valida��o para Inclus�o/Altera��o

dbSelectArea(cAlias)
dbSetOrder(1)
AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)
Return