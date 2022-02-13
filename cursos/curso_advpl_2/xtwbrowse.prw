#Include "Protheus.ch"

User Function xTwBrowse()

Local cTitulo := "TwBrowse()"
Local aCpo := {"A6_COD","A6_AGENCIA","A6_NUMCON","A6_NREDUZ","A6_NOME","A6_SALATU"}
Local aTit := {}
Local aDad := {}
Local aPict := {}
Local i := 0
Local nCpo := 0
Local oDlg
Local oLbx
Local aTAM := {}

dbSelectArea("SX3")
dbSetOrder(2)

/*
For i:=1 To Len(aCpo)
   dbSeek(aCpo[i])
   aAdd( aTit,  AllTrim(SX3->X3_TITULO  ) )
   aAdd( aPict, AllTrim(SX3->X3_PICTURE ) )
   aAdd( aTAM,  CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,SX3->X3_TITULO) )
Next i
*/

// É possível substituir o For/Next acima por esta linha abaixo
aEval(aCpo,{|x,y| dbSeek(x), ;
                  aAdd(aTit ,AllTrim(SX3->X3_TITULO)), ;
                  aAdd(aPict,AllTrim(SX3->X3_PICTURE)),;
                  aAdd(aTAM ,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,SX3->X3_TITULO ) ) } )

dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial("SA6"))

/*
While !Eof() .And. SA6->A6_FILIAL == xFilial("SA6")
   aAdd(aDad,Array(Len(aCpo)))
   nCpo++
   For i:=1 To Len(aCpo)
      If ValType(FieldGet(FieldPos(aCpo[i])))=="N"
      	aDad[nCpo,i] := MsPadL(LTrim(TransForm(FieldGet(FieldPos(aCpo[i])),aPict[i])),100)
      Else
      	aDad[nCpo,i] := TransForm(FieldGet(FieldPos(aCpo[i])),aPict[i])
      Endif
   Next i
   dbSkip()
End
*/

// É possível substituir o While/End acima por esta linha abaixo
dbEval({|| aAdd(aDad,Array(Len(aCpo))),;
           aEval(aCpo,{|nX,nI| aDad[Len(aDad),nI] := TransForm(FieldGet(FieldPos(aCpo[nI])),aPict[nI])})},,;
           {|z| !Eof().And.SA6->A6_FILIAL==xFilial("SA6")})

If Len(aDad) == 0
   Aviso( cTitulo, "Nao existe dados a consultar", {"Ok"} )
   Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

   oLbx := TwBrowse():New(0,0,0,0,,aTit,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
   oLbx:SetArray(aDad)
   oLbx:aColSizes := aTAM
   oLbx:bLine := {|| aEval( aDad[oLbx:nAt],{|z,w| aDad[oLbx:nAt,w]})}

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {||oDlg:End()}, {||oDlg:End()})

Return