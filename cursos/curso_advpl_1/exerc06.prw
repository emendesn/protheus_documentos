User Function Exerc06()

Private aRotina := {}
Private cCadastro := "Cadastro de Produtos"

aAdd( aRotina, { "Pesquisar"  , "AxPesqui" , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "AxVisual" , 0 , 2 })
aAdd( aRotina, { "Incluir"    , "AxInclui" , 0 , 3 })
aAdd( aRotina, { "Alterar"    , "AxAltera" , 0 , 4 })
aAdd( aRotina, { "Excluir"    , "AxDeleta" , 0 , 5 })
aAdd( aRotina, { "Compl.Prod.", "MATA180"  , 0 , 6 })

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()

// Primeiro exemplo sem nehuma atribui��o
mBrowse(,,,,"SB1")

// Lengenda informando se o campo Pre�o de Venda est� ou nao preenchido.
//mBrowse(6,1,22,75,"SB1",,"B1_PRV1")

// Lengenda: Pre�o >=100 Vermelho, Pre�o < 100 Verde.
//mBrowse(6,1,22,75,"SB1",,"B1_PRV1>=100")

Return Nil