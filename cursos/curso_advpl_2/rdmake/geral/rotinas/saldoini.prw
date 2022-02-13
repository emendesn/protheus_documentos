#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SALDOINI ºAutor  ³Edson Rodrigues     º Data ³  12/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Saldo Inicial e saldo em estoque para o produto       º±±
±±º          ³ no armazem indicado                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral - BGH                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Saldoini(cprod,carmaz,lInclui)
  Local cAlias     := ALIAS()        
  Local areaSB9    := SB9->(GetArea())
  Local aDados     := {}
  Local MB9_COD    := cprod    // Codigo do Produto
  Local MB9_LOCAL  := carmaz   // Local ou Almoxarifado
  Local MB9_QINI   := 0        // Quantidade
  Local MB9_MCUSTD := "1"       // Fixo 1 para Custo 1
  Local nOper      := IIF(lInclui,3,5)  // .t. inclui, .f. exclui
  Private lMsErroAuto := .f.            // flag erro execauto               
  Private _lRet       := .T.                                              
  
  DBSELECTAREA("SB9") 
  DBSETORDER(1)
  IF !SB9->(DBSeek(xFilial('SB9')+cprod+carmaz))  

     AADD(aDados,{"B9_FILIAL" ,XFILIAL("SB9") ,NIL})  
     AADD(aDados,{"B9_COD"    ,MB9_COD        ,NIL})  
     AADD(aDados,{"B9_LOCAL"  ,MB9_LOCAL      ,NIL})  
     AADD(aDados,{"B9_QINI"   ,MB9_QINI       ,NIL})    
  
     MSExecAuto({|x,y| mata220(x,y)},aDados,nOper) 

     If lMsErroAuto
       Mostraerro()
	   _lRet := .F.  
     else
	   _lRet := .T.
     EndIf
  ENDIF
  
  IF _lRet
     DBSELECTAREA("SB2")
     IF !SB2->(DBSeek(xFilial('SB2')+cprod+carmaz))   
     	RecLock('SB2',.T.)   
     	   SB2->B2_FILIAL  := xFilial('SB2') 
		   SB2->B2_COD	   := cprod 
		   SB2->B2_LOCAL   := carmaz
		MsUnLock('SB2')
     ENDIF
  ENDIF
  
  RestArea(areaSB9)
  DBSELECTAREA( cAlias ) 
  

Return()