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

// Índice que será criado
cIndTRB := "PRODUTO+DTOS(EMISSAO)"

// Parâmetros da função CriaTrab( aCampos, lCriar, cExt )
// aCampo -> vetor com o nome, tipo, tamanho e decimal do campo a ser criado no arquivo
// lCriar -> verdadeiro criar o arquivo, falso somente devolve o nome
// cExt   -> com qual extensão deverá ser criado o arquivo
cNomArq := CriaTrab( aArqTRB, .T. )

// Parâmetros da função dbUsearea( lNewArea, cDriver, cName, cAlias, lShared, lReadOnly )
// lNewArea  -> Indica se é um novo alias no conjunto de alias aberto
// cDriver   -> Drive (RddName()) do arquivo -> DBFCDX / TOPCONN / DBFNTX
// cName     -> Nome físico da tabela que será usado
// cAlias    -> Alias que será usado enquanto estive aberto
// lShared   -> A tabela terá acesso exclusivo ou compartilhado
// lReadOnly -> Se verdadeiro a tabela será somente leitura
dbUseArea( .T., "DBFCDX", cNomArq, "TRB", .T. ,.T. )

// Parâmetros da função IndRegua( cAlias, cNIndex, cExpress, xOrdem, cFor, cMens, lShow)
// cAlias   -> Alias da tabela onde será efetuada o índice/filtro temporário
// cNIndex  -> Nome físico do índice
// cExpress -> Expressão do índice
// xOrdem   -> Parâmetro nulo
// cFor     -> Expressão do filtro
// cMens    -> Parâmetro nulo
// lShow    -> Apresentar a tela de progresso do índice/filtro temporário
IndRegua( "TRB", cNomArq, cIndTRB )
dbSetOrder(1)

// ...fazer o processamento necessário

dbSelectArea("TRB")
dbCloseArea()

If MsgYesNo("Apagar o arquivo gerado \system\"+cNomArq+".dbf ?",FunName())
	Ferase(cNomArq+".dbf")
	Ferase(cNomArq+OrdBagExt())
Endif

Return