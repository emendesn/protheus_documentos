#INCLUDE "topconn.ch"             

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NSNextel   º Autor ³Antonio Leandro Faveroº Data ³ 05/10/03º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esse programa é responsavel pela impressão dos seriais dos º±±
±±º          ³ aparelhos da Nota Fiscal de Saída.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento/Field Service - BGH                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
                                        
User Function NSNextel
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄcnÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//³ Variaveis utilizadas para parametros                                ³
//³ mv_par01             // Da Nota Fiscal                              ³
//³ mv_par02             // Ate a Nota Fiscal                           ³ 
//³ mv_par03             // Da Serie                                    ³ 
//³ mv_par04             // Ate Serie                                   ³ 
//³ mv_par05             // Nota Fiscal de Entrada/Saida                ³ 

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Numeros de Serie da Nota Fiscal"
Local cPict        := ""
Local titulo       := "Numeros de Serie da Nota Fiscal"
Local nLin         := 80
//Local Cabec1       :="Codigo          Descrição                    NF Origem  Serie        Total 
Local Cabec1       :="Codigo          Descrição                   NF      Serie   Total    Total Saldo"
Local Cabec2       :="                                          Origem            Origem   Saída Total"  
Local imprime      := .T.
Local aOrd         := {}

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "P"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private cString    := "SD2"                          
Private cQuery     := "" 
Private wnrel      := "NSNEXTEL" // Coloque aqui o nome do arquivo usado para impressao em disco
Private nomeprog   := "NSNEXTEL" // Coloque aqui o nome do programa para impressao no cabecalho
Private ImpItens   := 10       // Total de Itens de impressao  
Private cPerg      := "NSNEX"  // Nome da Pergunta em SX1    
Private COMPRESSAO := CHR(15)  // Caracter de Compressao
Private NORMAL     := CHR(18)  // Caracter de impressão Normal


u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
//ValidPerg()          //Verifica os parametros
Pergunte(cPerg,.F.)  //Carrega parametros
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Filtrar()                
RptStatus({|| Imprimir(Titulo,Cabec1,cabec2,nomeProg,tamanho)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN         

dbSelectArea("QRY") //Fecha Alias
//dbCloseArea("QRY")  //Fecha Alias
QRY->(DBCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
Return     

/******************************************************************************/
/* Funcao    : Filtrar    Autor: Antonio Leandro F. Favero  Data: 05/10/2003  */
/* Objetivo  : Gera a Query com os registros de acordo com os parametros.     */
/* Manutencao:                                                                */
/******************************************************************************/
Static Function Filtrar
  cQuery:="Select Distinct D2_DOC,D2_SERIE,D2_NFORI,D2_SERIORI,D1_EMISSAO, D2_COD,D2_NUMSERI,D2_ITEMORI "                //Campos do Cabecalho (SD2) 
  cQuery+=" B1_DESC, D2_QUANT, D2_EMISSAO"                                                     //Campos do Produto (SB1)
  cQuery+=" FROM "+RetSQLName('SD2') + " (nolock) "                                     //Seleciona o cabecalho e itens da NF
  cQuery+=" ,"+RetSQLName('SB1') + " (nolock) "                                        //Seleciona o produto
  cQuery+=" ,"+RetSQLName('SD1') + " (nolock) "                                        //Seleciona o produto
  cQuery+=" WHERE D2_COD=B1_COD AND "// D2_NUMSERI<>'"+Space(20)+"' AND "     //Faz um Join com o produto
  cQuery+=" D2_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' and"        //Da Nota ate a Nota
  cQuery+=" D2_SERIE BETWEEN '"+mv_par03+"' and '"+mv_par04+"' and "     //Da Serie ATE Serie
  cQuery+=" D2_FILIAL='"+xFilial('SD2')+"' AND "                         //Seleciona a filial do SD2 
  cQuery+=" B1_FILIAL='"+xFilial('SB1')+"' AND "                         //Seleciona a filial do SB1  
  cQuery+=" D2_NFORI   = D1_DOC AND "                         			 //Seleciona a filial do SF1  
  cQuery+=" D2_SERIORI = D1_SERIE AND "                        			 //Seleciona a filial do SF1  
  cQuery+=" D1_COD     = D2_COD   AND "                        			 //Seleciona a filial do SF1  
  cQuery+=" D1_FILIAL  =  '"+xFilial('SD1')+"' AND "            			 //Seleciona a filial do SF1    
  cQuery+=RetSQLName('SD2')+".D_E_L_E_T_<>'*' and "                      //Inibe os registros deletados 
  cQuery+=RetSQLName('SB1')+".D_E_L_E_T_<>'*' and "                          //Inibe os registros deletados   
  cQuery+=RetSQLName('SD1')+".D_E_L_E_T_<>'*'"                           //Inibe os registros deletados   
  cQuery+=" Order by D2_DOC, D2_COD, D2_NFORI, D2_SERIORI"                        //Ordena por D2_DOC+D2_SERIE+D2_ITEM

TCQUERY cQuery NEW ALIAS "QRY"                  
Return

/******************************************************************************/
/* Funcao    : Conte      Autor: Antonio Leandro F. Favero  Data: 05/10/2003  */
/* Objetivo  : Conta quantos aparelhos estão sendo devolvidos.                */
/* Manutencao:                                                                */
/******************************************************************************/            
Static Function Conte(cProd,cNF,cSerie)           
Private Result:=0        

  cQuery:="Select count(D2_COD) TOTAL"                //Campos do Cabecalho (SD2) 
  cQuery+=" FROM "+RetSQLName('SD2') + " (nolock) "                                    //Seleciona o cabecalho e itens da NF
  cQuery+=" WHERE D2_NFORI = '"+cNF+"' and"        //Da Nota
  cQuery+=" D2_SERIORI = '"+cSerie+"' and "     //Da Serie 
  cQuery+=" D2_FILIAL='"+xFilial('SD2')+"' AND "                         //Seleciona a filial do SD2 
  cQuery+=" D2_COD='"+cProd+"' AND D2_NUMSERI<>'"+Space(20)+"' AND "                         //Seleciona a filial do SB1 
  cQuery+=RetSQLName('SD2')+".D_E_L_E_T_=' '"                      //Inibe os registros deletados 
  TCQUERY cQuery NEW ALIAS "CNT"                  
  Result:=CNT->TOTAL
  DBSelectArea('CNT')
  CNT->(DBCloseArea())
Return(Result)                                                                  

/******************************************************************************/
/* Funcao    : ConteOri   Autor: Camila Piloto              Data: 23/06/2004  */
/* Objetivo  : Verifica quantos aparelhos constam na nota original e quanto   */
/*           : tenho em estoque                                               */
/******************************************************************************/            
Static Function ConteOri(cProd,cNF,cSerie,cItem)           
   
Local Result0:=0   
Local Result1:=0    
Private ResultOri:=0 

cQuery:=" SELECT SUM(D2_QUANT) TOTALORI"
cQuery+=" FROM "+RetSQLName('SD2') + " (nolock) "
cQuery+=" WHERE D2_COD = '"+cProd+"'
cQuery+=" AND D2_NFORI = '"+cNF+"'
cQuery+=" AND D2_SERIORI = '"+cSerie+"'
cQuery+=" AND D2_DOC  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'
cQuery+=" AND D2_SERIE BETWEEN '"+mv_par03+"' and '"+mv_par04+"'
cQuery+=" AND D_E_L_E_T_ <> '*'"


//cQuery+=" AND D2_DOC NOT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' 
  TCQUERY cQuery NEW ALIAS "CNTORI"                  
  Result0:=CNTORI->TOTALORI 
    Resultori:=CNTORI->TOTALORI
  
  DBSelectArea('CNTORI')
  //DBCloseArea('CNTORI')
  CNTORI->(DBCloseArea())
  
cQuery:=" SELECT SUM(D1_QUANT) QUANTORI"
cQuery+=" FROM "+RetSQLName('SD1') + " (nolock) "
cQuery+=" WHERE D1_COD = '"+cProd+"'
cQuery+=" AND D1_DOC = '"+cNF+"'
cQuery+=" AND D1_SERIE = '"+cSerie+"'
cQuery+=" AND D_E_L_E_T_ <> '*'"

  TCQUERY cQuery NEW ALIAS "CNTORI"                  
  Result1:=CNTORI->QUANTORI
  
  DBSelectArea('CNTORI')
  //DBCloseArea('CNTORI')
  CNTORI->(DBCloseArea())
                                 
  ResultOri := Result1-Result0
Return(ResultOri)


/******************************************************************************/
/* Funcao    : Imprimir   Autor: Antonio Leandro F. Favero  Data: 05/10/2003  */
/* Objetivo  : Criar os parametros de impressao da Nota Fiscal.               */
/* Manutencao:                                                                */
/******************************************************************************/
Static Function Imprimir(Titulo,cCabec1,cabec2,nomeProg,tamanho)
Local cProd:=Space(15)
Local cNF  :=Space(9)    
Local _lCabec := .F. 
Local _cNfAnt := "" 

Cabec(titulo,cCabec1,cabec2,nomeprog,tamanho) //Impressao do cabecalho

_cNfAnt := QRY->D2_DOC 

WHILE !QRY->(EOF())
	
   If _cNfAnt <> QRY->D2_DOC 
	   _cNfAnt := QRY->D2_DOC 
	   _lCabec := .T. 
   End
   
   if pRow()>55  .or. _lCabec 
     Cabec(titulo,cCabec1,cabec2,nomeprog,tamanho) //Impressao do cabecalho
     _lCabec := .F. 
   endif    
   
   if (cProd<>QRY->D2_COD) .OR. (cNF<>QRY->(D2_NFORI+D2_SERIORI))
      cProd:=QRY->D2_COD                                        
      cNF:=QRY->(D2_NFORI+D2_SERIORI) 
      @ pRow()+02,001 Psay "Nota Fiscal : " + QRY->D2_NFORI + ' - ' + QRY->D2_SERIORI + '   Data Emissão: ' + DToC(SToD(QRY->D1_EMISSAO))   /*Substr(cnf,1,6)+"-"+Substr(cnf,7,3)+*/ 
      @ pRow()+01,001 Psay QRY->D2_COD
      @ pRow()   ,016 Psay QRY->B1_DESC                           //Descricao do Produto
      @ pRow()   ,040 Psay QRY->D2_NFORI
      @ pRow()   ,054 Psay QRY->D2_SERIORI                                      
      /*
      @ pRow()   ,062 Psay Conte(cProd,QRY->D2_NFORI,QRY->D2_SERIORI) 
      @ pRow()   ,072 Psay ConteOri(cProd,QRY->D2_NFORI,QRY->D2_SERIORI) 
      @ pRow()   ,079 Psay Conte(cProd,QRY->D2_NFORI,QRY->D2_SERIORI)-ConteOri(cProd,QRY->D2_NFORI,QRY->D2_SERIORI)
      */ 
      @ pRow()   ,062 Psay  0.00 //ConteOri(cProd,QRY->D2_NFORI,QRY->D2_SERIORI)  //retirado para agilizar o processamento - Edson Rodrigues 20-07-07
      @ pRow()   ,072 Psay QRY->D2_QUANT 
      @ pRow()   ,079 Psay QRY->D2_QUANT //ConteOri(cProd,QRY->D2_NFORI,QRY->D2_SERIORI) - QRY->D2_QUANT  //retirado para agilizar o processamento - Edson Rodrigues 20-07-07
      
      @ pRow()+01,001 Psay Replicate('-',80)     
      @ pRow()+01,001 Psay AllTrim(QRY->D2_NUMSERI)  
      Prow()+01
   else         
      @ pRow()+iif(pCol()>60,1,0),iif(pCol()>60,0,pCol()) Psay ','+AllTrim(QRY->D2_NUMSERI) 
      
   endif
      
   QRY->(DBSkip())
EndDo

Return

/******************************************************************************/
/* Funcao    : ValidPerg  Autor: Antonio Leandro F. Favero  Data: 10/07/2002  */
/* Objetivo  : Criar os parametros de impressao da Nota Fiscal.               */
/* Manutencao:                                                                */
/******************************************************************************/
Static Function ValidPerg
dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)

If !SX1->(dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+'01'))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO:=cPerg
	SX1->X1_ORDEM:='01'
	SX1->X1_PERGUNT:='Da Nota ?'
	SX1->X1_PERSPA:='De Factura ?'
	SX1->X1_PERENG:='From Invoice ?'
	SX1->X1_VARIAVL:='mv_ch1'
	SX1->X1_VAR01:='MV_PAR01'
	SX1->X1_GSC:='G'
	SX1->X1_TIPO:='C'
	SX1->X1_TAMANHO:=6
	MsUnlock("SX1")
Endif


If !SX1->(dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+'02'))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO:=cPerg
	SX1->X1_ORDEM:='02'
	SX1->X1_PERGUNT:='Ate a Nota ?'
	SX1->X1_PERSPA:='A Factura ?'
	SX1->X1_PERENG:='To Invoice ?'
	SX1->X1_VARIAVL:='mv_ch2'
	SX1->X1_VAR01:='MV_PAR02'
	SX1->X1_GSC:='G'
	SX1->X1_TIPO:='C'
	SX1->X1_TAMANHO:=6
	MsUnlock("SX1")
Endif

If !SX1->(dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+'03'))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO:=cPerg
	SX1->X1_ORDEM:='03'
	SX1->X1_PERGUNT:='Da Serie ?'
	SX1->X1_PERSPA:='De Serie ?'
	SX1->X1_PERENG:='From Invoice Type?'
	SX1->X1_VARIAVL:='mv_ch3'
	SX1->X1_VAR01:='MV_PAR03'
	SX1->X1_GSC:='G'
	SX1->X1_TIPO:='C'
	SX1->X1_TAMANHO:=3
	MsUnlock("SX1")
Endif

If !SX1->(dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+'04'))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO:=cPerg
	SX1->X1_ORDEM:='04'
	SX1->X1_PERGUNT:='Ate a Serie ?'
	SX1->X1_PERSPA:='A Serie ?'
	SX1->X1_PERENG:='To Invoice Type?'
	SX1->X1_VARIAVL:='mv_ch4'
	SX1->X1_VAR01:='mv_par05'
	SX1->X1_GSC:='G'
	SX1->X1_TIPO:='C'
	SX1->X1_TAMANHO:=3
	MsUnlock("SX1")
Endif

Return