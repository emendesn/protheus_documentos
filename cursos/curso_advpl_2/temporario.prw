User Function Temporar()

Local aAssoc := {}
Local aArqTRB := {}

Local nI := 0

Local cIndTRB
Local cNomArq

aAdd( aAssoc, { "PRODUTO"   ,"B1_COD"     } )
aAdd( aAssoc, { "DESCRICAO" ,"B1_DESC"    } )
aAdd( aAssoc, { "GRUPO"     ,"BM_GRUPO"   } )
aAdd( aAssoc, { "DESCGRUPO" ,"BM_DESC"    } )
aAdd( aAssoc, { "TIPO"      ,"B1_TIPO"    } )
aAdd( aAssoc, { "DESCTIPO"  ,"B1_DESC"    } )
aAdd( aAssoc, { "CC"        ,"CTT_CC"     } )
aAdd( aAssoc, { "DESC_CC"   ,"CTT_DESC"   } )
aAdd( aAssoc, { "SERIE"     ,"D2_SERIE"   } )
aAdd( aAssoc, { "DOCTO"     ,"D2_COD"     } )
aAdd( aAssoc, { "TIPONOTA"  ,"D2_TP"      } )
aAdd( aAssoc, { "EMISSAO"   ,"D2_EMISSAO" } )
aAdd( aAssoc, { "CLIENTE"   ,"D2_CLIENTE" } )
aAdd( aAssoc, { "LOJA"      ,"D2_LOJA"    } )
aAdd( aAssoc, { "NOME"      ,"A1_NOME"    } )
aAdd( aAssoc, { "QTDE"      ,"D2_QUANT"   } )
aAdd( aAssoc, { "UNIT"      ,"D2_PRCVEN"  } )
aAdd( aAssoc, { "TOTAL"     ,"D2_TOTAL"   } )
aAdd( aAssoc, { "ALIQICMS"  ,"D2_PICM"    } )
aAdd( aAssoc, { "VALICMS"   ,"D2_VALICM"  } )
aAdd( aAssoc, { "ALIQIPI"   ,"D2_IPI"     } )
aAdd( aAssoc, { "VALIPI"    ,"D2_VALIPI"  } )
aAdd( aAssoc, { "VALMERC"   ,"D2_TOTAL"   } )
aAdd( aAssoc, { "TOTSEMICMS","D2_TOTAL"   } )
aAdd( aAssoc, { "VALPIS"    ,"D2_TOTAL"   } )
aAdd( aAssoc, { "LIQUIDO"   ,"D2_TOTAL"   } )
aAdd( aAssoc, { "CUSTO"     ,"D2_TOTAL"   } )

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len( aAssoc )
	dbSeek( aAssoc[nI,2] )
	aAdd( aArqTRB, { aAssoc[nI,1], X3_TIPO, X3_TAMANHO, X3_DECIMAL } )
Next nI

// �ndice que ser� criado
cIndTRB := "PRODUTO+DTOS(EMISSAO)"

// Par�metros da fun��o CriaTrab( aCampos, lCriar, cExt )
// aCampo -> vetor com o nome, tipo, tamanho e decimal do campo a ser criado no arquivo
// lCriar -> verdadeiro criar o arquivo, falso somente devolve o nome
// cExt   -> com qual extens�o dever� ser criado o arquivo
cNomArq := CriaTrab( aArqTRB, .T. )

// Par�metros da fun��o dbUsearea( lNewArea, cDriver, cName, cAlias, lShared, lReadOnly )
// lNewArea  -> Indica se � um novo alias no conjunto de alias aberto
// cDriver   -> Drive (RddName()) do arquivo -> DBFCDX / TOPCONN / DBFNTX
// cName     -> Nome f�sico da tabela que ser� usado
// cAlias    -> Alias que ser� usado enquanto estive aberto
// lShared   -> A tabela ter� acesso exclusivo ou compartilhado
// lReadOnly -> Se verdadeiro a tabela ser� somente leitura
dbUseArea( .T., "DBFCDX", cNomArq, "TRB", .T. ,.T. )

// Par�metros da fun��o IndRegua( cAlias, cNIndex, cExpress, xOrdem, cFor, cMens, lShow)
// cAlias   -> Alias da tabela onde ser� efetuada o �ndice/filtro tempor�rio
// cNIndex  -> Nome f�sico do �ndice
// cExpress -> Express�o do �ndice
// xOrdem   -> Par�metro nulo
// cFor     -> Express�o do filtro
// cMens    -> Par�metro nulo
// lShow    -> Apresentar a tela de progresso do �ndice/filtro tempor�rio
IndRegua( "TRB", cNomArq, cIndTRB )
dbSetOrder(1)

// ...fazer o processamento necess�rio

dbSelectArea("TRB")
dbCloseArea()

If MsgYesNo("Apagar o arquivo gerado \system\"+cNomArq+".dbf ?",FunName())
	Ferase(cNomArq+".dbf")
	Ferase(cNomArq+OrdBagExt())
Endif

Return