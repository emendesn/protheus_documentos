#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE 'PROTHEUS.CH' 
#DEFINE OPEN_FILE_ERROR -1  
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE ENTER CHR(10)+CHR(13)                  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��        
���Programa  �CONVARQ   � Autor � Edson Rodrigues    � Data �  27/05/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Faz conversao dos arquivos temporarios gerados pelo sistema���
���          � .DBF ou .DTC (Ctree) e os converte para .CSV               ���
���          � Conversao necessaria, pois a versao 10 em Linux da erro de ���
���          | ADS ou trava quando o prg tenta copiar o temp .dbf ou .dtc ���
���          | direto via "DBFCDXDBS"                                     ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICO BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/




/*
//Funcao      : CONVARQ(cOrigem,cDestino)
//Parametros : cOrigem := Arquivo Origem
//              cDestino := Arquivo Destino
//Retorno     : .T./.F.
//Objetivos   : Copia arquivo
*/
User Function CONVARQ(cOrigem,cDestino,lBack) 
Local lRet := .f. 
Local hFile1, hFile2
Local cBuffer, nBuffer := 0, nRead, nReadTot := 0, nTotal := 0

u_GerA0003(ProcName())

If(lBack==NIL,lBack:=.F.,)
Begin Sequence   
   cOrigem := Upper(cOrigem)
   cDestino := Upper(cDestino)
   DBF2CSV(cOrigem, StrTran(cDestino, ".DBF", ".CSV"),@lRet)
End Sequence
Return lRet



static Function DBF2CSV(cArqOrig,cArqDest,lRet)
Local cLinha
Local aStruct
Local nPos 
Local nHandle
Local cDRVOpen
Local cdadosxls 
Local cCrLf  :=Chr(13)+Chr(10)       
Local nConta := 0  
Local cArq   := "wcms_novo"

Begin Sequence
   If !File(cArqOrig)
      Break
   EndIf
   If RealRDD() == "ADSSERVER"
      cDRVOpen := "DBFCDX"
   Else
      If IsSrvUnix() .or. RealRDD() == "CTREE"
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

   
   //Defini��o do cabecario de Estrutura.
   nHandle := MsfCreate(cArqDest,0)  
   cLinha := ''
   aStruct := Origem->(dbStruct())
   
   For nPos := 1 To Len(aStruct)
      cLinha +=aStruct[nPos][1]+";"
   Next     
   
   fWrite(nHandle, cLinha  + cCrLf)
   //Fim da defini��o do n� de Estrutura.
   
   
   // Defini��o dos Dados.
   
   Origem->(dbGoTop())
   While Origem->(!Eof())
     cLinha :=""                  
     nConta++
      For nPos := 1 To Len(aStruct)
         cLinha  +=XMLEncoding(Origem->&(aStruct[nPos][1]))+ ";" 
      Next              
      fWrite(nHandle, cLinha + cCrLf)
      Origem->(dbSkip())
   End
   
   if nConta > 0 
     lRet:=.t.
   else
     lRet:=.f.
   endif  
   
   //Fim da defini��o dos Dados.
   fClose(nHandle)
   Origem->(dbCloseArea())

     
End Sequence
Return(Nil)                                             

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
        xValue := StrTran(xValue, "&", "E")
        xValue := StrTran(xValue, "<", "&lt" ) 
        xValue := StrTran(xValue, ">", "&gt" )
        xValue := StrTran(xValue, "�", "&gt" )
        xValue := StrTran(xValue, "�", "&gt" )
        xValue := StrTran(xValue, "�", "a" )
        xValue := StrTran(xValue, "�", "a" )
        xValue := StrTran(xValue, "�", "a" )
        xValue := StrTran(xValue, "�", "a" )
        xValue := StrTran(xValue, "�", "a" )
        xValue := StrTran(xValue, "�", "a" )                                
        xValue := StrTran(xValue, "�", "e" )
        xValue := StrTran(xValue, "�", "e" )
        xValue := StrTran(xValue, "�", "e" )
        xValue := StrTran(xValue, "�", "e" )
        xValue := StrTran(xValue, "�", "e" )
        xValue := StrTran(xValue, "�", "e" )                                
        xValue := StrTran(xValue, "�", "i" )
        xValue := StrTran(xValue, "�", "i" )
        xValue := StrTran(xValue, "�", "i" )
        xValue := StrTran(xValue, "�", "i" )
        xValue := StrTran(xValue, "�", "i" )
        xValue := StrTran(xValue, "�", "i" )      
        xValue := StrTran(xValue, "�", "o" )
        xValue := StrTran(xValue, "�", "o" )
        xValue := StrTran(xValue, "�", "o" )
        xValue := StrTran(xValue, "�", "o" )
        xValue := StrTran(xValue, "�", "o" )
        xValue := StrTran(xValue, "�", "o" )                                
        xValue := StrTran(xValue, "�", "o" )                                
        xValue := StrTran(xValue, "�", "o" )                                
        xValue := StrTran(xValue, "�", "o" )                                
        xValue := StrTran(xValue, "�", "u" )                                
        xValue := StrTran(xValue, "�", "u" )                                
        xValue := StrTran(xValue, "�", "u" )                                
        xValue := StrTran(xValue, "�", "u" )                                
        xValue := StrTran(xValue, "�", "u" ) 
        xValue := StrTran(xValue, "�", "u" )                                
        xValue := StrTran(xValue, "�", "u" )
        xValue := StrTran(xValue, "�", "c" )                                
        xValue := StrTran(xValue, "�", "c" ) 
        xValue := StrTran(xValue, "�", "." )                                
        xValue := StrTran(xValue, "�", "a." )
        xValue := StrTran(xValue, "�", "E" )                                
        xValue := StrTran(xValue, "�", "e" ) 
        xValue := StrTran(xValue, "�", "E" )                                
        xValue := StrTran(xValue, "'", "" ) 
        xValue := StrTran(xValue, "?", "C" )                                
        xValue := StrTran(xValue, "�", "C" ) 
        xValue := StrTran(xValue, ",", "" )                                
        xValue := StrTran(xValue, "�", "Y" ) 
        xValue := StrTran(xValue, "�", "O" )                                
        xValue := StrTran(xValue, "�", "C" ) 
        xValue := StrTran(xValue, "�", "O" )                                
        xValue := StrTran(xValue, "�", "" ) 
        xValue := StrTran(xValue, "�", "" )                                
        xValue := StrTran(xValue, "`", "" ) 
        xValue := StrTran(xValue, "�", "O" )                                
        xValue := StrTran(xValue, "�", "C" ) 
        xValue := StrTran(xValue, "�", "O" )                                
        xValue := StrTran(xValue, "�", "I" ) 
        xValue := StrTran(xValue, '"', "" )   
        xValue := StrTran(xValue, ";", "" )     
        xValue := StrTran(xValue, "�", "" )     
        
        
        cValue := xValue
      End Case
End Sequence
Return(cValue)


