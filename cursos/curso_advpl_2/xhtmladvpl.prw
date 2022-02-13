User Function xHTMLAdvPL()
Local aSay := {}
Local aButton := {}
Local nOpc := 0
Private cTitulo := "Integração Protheus com HTML"

aAdd( aSay , "Este programa exemplifica de como utilizar a integração do Protheus com HTML" )

aAdd( aButton , { 1 , .T. , { | | nOpc := 1 , FechaBatch() } } )
aAdd( aButton , { 2 , .T. , { | | FechaBatch()             } } )

FormBatch( cTitulo , aSay , aButton )

If nOpc == 1
   Process()
Endif

Return

Static Function Process()
Local i := 0
Local aPBox := {}
Local aRet := {}
Local cPedido := ""
Local cFile := ""
Local cCod
Local cLoja
Local cNome
Local cNumPed
Local cTpPedido
Local cCodCond
Local cDescCond
Local cTpFrete
Local cMoeda
Local cEmissao
Local aITEM := {}
Local nQtdeTotal := 0
Local nVlrTotal := 0
Local cFileHTML
Local oHTML

aAdd( aPBox , { 1 , "Nº Pedido de venda" , Space(6) , "" , "" , "SC5" , "" , 0 , .T. })
aAdd( aPBox , { 6 , "Selecione o arquivo" , Space(50) , "" , "" , "" , 50 , .T. , "Arquivo HTML |*.htm", cMainPath })

If !ParamBox(aPBox,"Parâmetros",@aRet)
   Return
Endif

cPedido := aRet[1]
cFile   := aRet[2]

If !File( cFile )
   MsgInfo( "Arquivo não localizado" , cTitulo )
   Return
Endif

dbSelectArea( "SC5" )
dbSetOrder( 1 )
If !dbSeek( xFilial( "SC5" ) + cPedido )
   MsgInfo( "Pedido de venda não localizado" , cTitulo )
   Return
Endif

cCod      := SC5->C5_CLIENTE
cLoja     := SC5->C5_LOJACLI
cNome     := Posicione( "SA1" , 1 , xFilial( "SA1" ) + cCod + cLoja , "A1_NREDUZ" )
cNumPed   := SC5->C5_NUM
cTpPedido := X3Combo( "C5_TIPO" , SC5->C5_TIPO )
cCodCond  := SC5->C5_CONDPAG
cDescCond := Posicione( "SE4" , 1 , xFilial( "SE4" ) + cCodCond , "E4_DESCRI" )
cTpFrete  := X3Combo( "C5_TPFRETE" , SC5->C5_TPFRETE )
cMoeda    := RTrim( GetMv( "MV_MOEDA" + LTrim( Str( SC5->C5_MOEDA ) ) ) )
cEmissao  := Dtoc( SC5->C5_EMISSAO )

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+cPedido)
While !Eof() .And. SC6->( C6_FILIAL + C6_NUM ) == xFilial( "SC6" ) + cPedido 

   aAdd( aITEM , { SC6->C6_ITEM, ;
                   SC6->C6_PRODUTO, ;
                   SC6->C6_UM, ;
                   LTrim(Transform(SC6->C6_QTDVEN,"@E 999,999,999.99")), ;
                   LTrim(Transform(SC6->C6_PRCVEN,"@E 999,999,999.99")), ;
                   LTrim(Transform(SC6->C6_VALOR,"@E 999,999,999.99")), ;
                   SC6->C6_TES } )
                   
   nQtdeTotal += SC6->C6_QTDVEN
   nVlrTotal  += SC6->C6_VALOR

   dbSkip()
End

cFileHTML := CriaTrab( NIL , .F. ) + ".htm"

oHTML := TWFHTML():New( cFile )

oHTML:ValByName( "cCod"      , cCod      )
oHTML:ValByName( "cLoja"     , cLoja     )
oHTML:ValByName( "cNome"     , cNome     )
oHTML:ValByName( "cNumPed"   , cNumPed   )
oHTML:ValByName( "cTpPedido" , cTpPedido )
oHTML:ValByName( "cCodCond"  , cCodCond  )
oHTML:ValByName( "cDescCond" , cDescCond )
oHTML:ValByName( "cTpFrete"  , cTpFrete  )
oHTML:ValByName( "cMoeda"    , cMoeda    )
oHTML:ValByName( "dEmissao"  , cEmissao  )

For i:=1 To Len(aITEM)
   aAdd(oHTML:ValByName( "a.Item"    ) , aITEM[i,1] )
   aAdd(oHTML:ValByName( "a.Produto" ) , aITEM[i,2] )
   aAdd(oHTML:ValByName( "a.UM"      ) , aITEM[i,3] )
   aAdd(oHTML:ValByName( "a.Qtde"    ) , aITEM[i,4] )
   aAdd(oHTML:ValByName( "a.Unit"    ) , aITEM[i,5] )
   aAdd(oHTML:ValByName( "a.Total"   ) , aITEM[i,6] )
   aAdd(oHTML:ValByName( "a.TES"     ) , aITEM[i,7] )
Next i

oHTML:ValByName( "nQtdeTotal" , LTrim( TransForm( nQtdeTotal , "@E 999,999,999.99" ) ) )
oHTML:ValByName( "nVlrTotal"  , LTrim( TransForm( nVlrTotal  , "@E 999,999,999.99" ) ) )

oHTML:SaveFile( cFileHTML )

MsgInfo( "Foi gerado o arquivo " + cFileHTML , cTitulo )

Return