#INCLUDE 'PROTHEUS.CH'
//#INCLUDE "rwmake.ch"  
//#INCLUDE "topconn.ch"
//#DEFINE OPEN_FILE_ERROR -1  
//#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#define ENTER CHR(10)+CHR(13)


/*
//Funcao      : MyCpyFile(cOrigem,cDestino)
//Parametros : cOrigem := Arquivo Origem
//              cDestino := Arquivo Destino
//Retorno     : .T./.F.
//Objetivos   : Copia arquivo
*/
User Function MyCpyFile(cOrigem,cDestino,lBack) 
Local lRet := .f. 
Local hFile1, hFile2
Local cBuffer, nBuffer := 0, nRead, nReadTot := 0, nTotal := 0
If(lBack==NIL,lBack:=.F.,)
Begin Sequence   
   cOrigem := Upper(cOrigem)
   cDestino := Upper(cDestino)
   DBF2XML(cOrigem, StrTran(cDestino, ".DBF", ".XML"))
   lRet := .t.
End Sequence
Return lRet


/*
Objetivo   : Converter um arquivo de base de dados (DBF/DTC) para XML.
Parametros : cArqOrig = Caminho + Nome do arquivo de origem.
             cArqDest = Caminho + Nome do arquivo de destino.
Retorno    : Nil 
XML Schema : 
<DataRoot>
   <Estrutura>
      <Campo>
        <Nome></Nome>
        <Tipo></Tipo>
        <Tamanho></Tamanho>
        <Decimal></Decimal> 
      </Campo>
   </Estrutura>
   <Indice>
      <Chave></Chave>
   </Indice>
   <Dados>
      <Registro>
        <#Nome do campo#></#Nome do campo#> 
      </Registro>
   </Dados>
</DataRoot>
*/

static Function DBF2XML(cArqOrig, cArqDest)
Local cXML
Local aStruct
Local nPos 
Local nHandle
Local cDRVOpen
Local cdadosXML //Acrescentado - Edson Rodrigues

Begin Sequence
   If !File(cArqOrig)
      Break
   EndIf
   If RealRDD() == "ADSSERVER"
      cDRVOpen := "DBFCDX"
   Else
      If IsSrvUnix()
        cDRVOpen := ""
      Else
        cDRVOpen := "DBFCDXADS"
      EndIf 
   EndIf
   dbUseArea(.T., cDRVOpen, cArqOrig, "Origem", .T., .T.)
   If Select("Origem") = 0
      Break
   EndIf
   //If File(StrTran(cArqOrig, ".DBF", ".CDX"))
   If File(StrTran(cArqOrig, ".DTC", ".CDX"))
      //Origem->(dbSetIndex(StrTran(cArqOrig, ".DBF", ".CDX")))
       Origem->(dbSetIndex(StrTran(cArqOrig, ".DTC", ".CDX")))
   EndIf
   cXML := '<?xml version="1.0" encoding="ISO-8859-1"?>' + ENTER
   cXML += "<DataRoot>" + ENTER
   /*
   Definição do nó de Estrutura.
   */
   cXML += "<Estrutura>" + ENTER
   aStruct := Origem->(dbStruct())
   For nPos := 1 To Len(aStruct)
      cXML += "<Campo>" + ENTER
      cXML += "<Nome>"    +aStruct[nPos][1]+             "</Nome>" + ENTER
      cXML += "<Tipo>"    +aStruct[nPos][2]+             "</Tipo>" + ENTER 
      cXML += "<Tamanho>" +LTrim(Str(aStruct[nPos][3]))+ "</Tamanho>" + ENTER
      cXML += "<Decimal>" +LTrim(Str(aStruct[nPos][4]))+ "</Decimal>" + ENTER 
      cXML += "</Campo>" + ENTER
   Next
   cXML += "</Estrutura>" + ENTER
   /*
   Fim da definição do nó de Estrutura.
   */
   /*
   Definição do nó de Indice.
   */
   //cXML += "<Indice>" + ENTER
   //cXML += "<Chave>" +StrTran(Origem->(IndexKey()), "+", "</Chave>"+ENTER+"<Chave>")+ "</Chave>" + ENTER 
   //cXML += "</Indice>" + ENTER
   /*
   Fim da definição do nó de Indice.
   */
   /*
   Definição do nó de Dados.
   */
   cXML += "<Dados>" + ENTER
   Origem->(dbGoTop())
   While Origem->(!Eof())
      cXML += "<Registro>" + ENTER
      For nPos := 1 To Len(aStruct)
        cXML += "<"+aStruct[nPos][1]+">" +XMLEncoding(Origem->&(aStruct[nPos][1]))+ "</"+aStruct[nPos][1]+">" + ENTER
      Next
      cXML += "</Registro>" + ENTER
      Origem->(dbSkip())
   End
   cXML += "</Dados>" + ENTER
   /*
   Fim da definição do nó de Dados.
   */
   cXML += "</DataRoot>"
       
   cdadosXML:= '<?xml version="1.0" encoding="ISO-8859-1"?>' + ENTER
   cdadosXML+= "<DataRoot>" + ENTER
   Origem->(dbGoTop())
   While Origem->(!Eof())
      cdadosXML += "<R.>" + ENTER
      For nPos := 1 To Len(aStruct)
        cdadosXML += "<"+aStruct[nPos][1]+">" +XMLEncoding(Origem->&(aStruct[nPos][1]))+ "</"+aStruct[nPos][1]+">" + ENTER
      Next
      cdadosXML += "</R.>" + ENTER
      Origem->(dbSkip())
   End
   /*
   Fim da definição do nó de Dados.
   */
   cdadosXML += "</DataRoot>"
   
   
   Origem->(dbCloseArea())
   /*
   Gravação do arquivo de destino.
   */
   nHandle := fCreate(cArqDest)
   fWrite(nHandle, cdadosXML)
   fClose(nHandle)
End Sequence
Return(Nil)

/*
Objetivo   : Converte dados dos tipos N(numérico), D(data) e L(lógico) em C(character).
Parametros : xValue = Dado a ser convertido.
Retorno    : cValue = xValue convertido para character.
*/
static Function XMLEncoding(xValue)
Local cValue
Begin Sequence
   Do Case
      Case ValType(xValue) = "N"
        cValue := StrTran(Str(xValue), ".", ",")
      Case ValType(xValue) = "D"
        cValue := If(!Empty(xValue), StrZero(Year(xValue), 4)+"/"+StrZero(Month(xValue),2)+"/"+StrZero(Day(xValue), 2), Space(8)) 
      Case ValType(xValue) = "L"
        cValue := If(xValue, "T", "F")
      Otherwise
        xValue := StrTran(xValue, "&", "&amp;")
        xValue := StrTran(xValue, "<", "&lt;" ) 
        xValue := StrTran(xValue, ">", "&gt;" )
        cValue := xValue
   End Case
End Sequence
Return(cValue)
