#Include "PROTHEUS.CH"

User Function TabSZK()

Local cAlias  := "SZK"
Local cTitulo := "Cadastro de Celulas"
Local cVldExc := ".T." //Validação para Exclusão
Local cVldAlt := ".T." //Validação para Inclusão/Alteração

dbSelectArea(cAlias)
dbSetOrder(1)
AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)
Return