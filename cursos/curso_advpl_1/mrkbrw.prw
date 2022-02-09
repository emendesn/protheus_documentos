User Function MrkBrw()

Local cCampos
Local aCampos := {}
Private cMarca := GetMark()
Private cCadastro := "Escolher Clientes"
Private aRotina := {}

aAdd( aRotina, { "Pesquisar"  , "AxPesqui" , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "AxVisual" , 0 , 2 })
aAdd( aRotina, { "Incluir"    , "AxInclui" , 0 , 3 })
aAdd( aRotina, { "Alterar"    , "AxAltera" , 0 , 4 })
aAdd( aRotina, { "Excluir"    , "AxDeleta" , 0 , 5 })

AAdd(aCampos, {"A1_Pessoa",,"Pessoa"})
AAdd(aCampos, {"A1_Tipo",,"Tipo"})
AAdd(aCampos, {"A1_Cod",,"Codigo"})
AAdd(aCampos, {"A1_Nome",,"Nome"})
AAdd(aCampos, {"A1_Est",,"Est"})

//MarkBrow("SA1", "A1_Estado", "SA1->A1_Tipo='R'",aCampos, ,cMarca, , , , , "u_Marca(cMarca)")
  MarkBrow("SA1", "A1_Est", "A1_Tipo='R'",aCampos, ,cMarca, , , , , "u_Marca(cMarca)")
//MarkBrow("QML","QML_OK" ,              ,aCampos, ,@cMarca, , ,"xFilial","xFilial")


Return

User Function Marca(cMarca)

MsgAlert(SA1->A1_Cod + " " + SA1->A1_Est + " " + cMarca)

RecLock("SA1")
If IsMark("A1_Est",cMarca)
   SA1->A1_Est := " "
 Else
   SA1->A1_Est := cMarca
EndIf
MSUnlock()

MsgAlert(SA1->A1_Cod + " " + SA1->A1_Est + " " + cMarca)

Return
