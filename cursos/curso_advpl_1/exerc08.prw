#Include "PROTHEUS.CH"

User Function Exerc08()

Private aRotina := {}
Private cCadastro := "Solicita��o de Software"

AAdd(aRotina, {"Pesquisar" , "AxPesqui"   , 0, 1})
AAdd(aRotina, {"Visualizar", "u_Mod2Manut", 0, 2})
AAdd(aRotina, {"Incluir"   , "u_Mod2Manut", 0, 3})
AAdd(aRotina, {"Alterar"   , "u_Mod2Manut", 0, 4})
AAdd(aRotina, {"Excluir"   , "u_Mod2Manut", 0, 5})
                                               
dbSelectArea("SZ4")
dbSetOrder(1)
dbGoTop()

mBrowse(,,,,"SZ4")

Return Nil
