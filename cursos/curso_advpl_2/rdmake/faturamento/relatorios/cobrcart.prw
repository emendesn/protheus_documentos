#INCLUDE "topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CobrCart  ºAutor  ³Claudia Cabral      º Data ³  19/11/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINANCEIRO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                                  
User Function CobrCart()        
	Processa( { || MyCart() } ) 
Return .t.
Static Function MyCart()
Local cQry1 :=""
Local cQry2 :=""
Local cQry3 :=""
Local cQry4 :=""
Local cQry5 :=""
Local cQry6 :=""
Local cQry7 :=""
Local cQry8 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())
Local aNewDados := {}                   
Local aTotCart  := {}
Local zz := 0  
Local yy := 0
Local nMax := 0       
Local nTotVenci := 0
Local nTotVencer := 0      
Local nBanVencer :=0
Local nBanVencido := 0
Local ntotb01 := 0
Local ntotb02 := 0
Local ntotb03 := 0
Local ntotb04 := 0
Local ntotb05 := 0
Local ntotb06 := 0
Local ntotb07 := 0
Local ntotb08 := 0
Local ntotb09 := 0
Local ntotb10 := 0
Local ntotb11 := 0
Local ntotb12 := 0
Local ntotb13 := 0
Local ntotb14 := 0
Local ntotG01 := 0
Local ntotG02 := 0
Local ntotG03 := 0
Local ntotG04 := 0
Local ntotG05 := 0
Local ntotG06 := 0
Local ntotG07 := 0
Local ntotG08 := 0
Local ntotG09 := 0
Local ntotG10 := 0
Local ntotG11 := 0
Local ntotG12 := 0
Local ntotG13 := 0
Local ntotG14 := 0
Local cBanco  := "#@@"    
Local dDtbase := dtos(ddatabase)
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
PRIVATE cPerg	 := padr("XMAPCAR",10)
Private cQuery :=""   
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))

u_GerA0003(ProcName())

//

ValidPerg(cPerg) 

//dbSelectArea(_sAlias)
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
/*
if ! Pergunte(cPerg,.T.)
 Return()
Endif
*/
cLinha := "                              ;                       ;>=360 DIAS      ;>=180 e < 360 DIAS;>=90 e < 180 DIAS;>=60 e < 90 DIAS;>=30 e < 60 DIAS;>=0 e < 30 DIAS;   TOTAL VENCIDOS  ;>= 0 e < 30 DIAS;>=30 e < 60 DIAS;>=60 e < 90 DIAS;>=90 e < 180 DIAS;>=180 e < 360 DIAS;>=360 DIAS;TOTAL A VENCER     "
fWrite(nHandle, cLinha  + cCrLf)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   
   
IF Select("QRY2") <> 0 
	DbSelectArea("QRY2")
	DbCloseArea()
Endif   

IF Select("QRY3") <> 0 
	DbSelectArea("QRY3")
	DbCloseArea()
Endif   
             
IF Select("QRY4") <> 0                                         
	DbSelectArea("QRY4")
	DbCloseArea()
Endif          

IF Select("QRY5") <> 0                                         
	DbSelectArea("QRY5")
	DbCloseArea()    
Endif   

IF Select("QRY6") <> 0                                         
	DbSelectArea("QRY6")
	DbCloseArea()
Endif                 

IF Select("QRY7") <> 0                                         
	DbSelectArea("QRY7")
	DbCloseArea()
Endif                 

IF Select("QRY8") <> 0                                         
	DbSelectArea("QRY8")
	DbCloseArea()
Endif   

/*
If !empty(MV_PAR01)
	dDtBase := Dtos(MV_PAR01)
EndIF                        
*/

//cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO, SUM(E1_SALDO+E1_SDACRES-E1_SDDECRE) SALDO "
cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO,SUM(E1_SALDO+E1_SDACRES-E1_SDDECRE) SALDO  "
cQuery += " FROM " + RetSqlName("SE1") + " SE1 (nolock) " // , " +   RetSqlName("SC5") + " SC5 "     
cQuery += " WHERE 	SE1.D_E_L_E_T_ = ' ' AND "
  
//Myfilter()

cQuery += "	SE1.E1_SALDO > 0  AND "                     
cQuery += "	SE1.E1_SITUACA NOT IN ('0')  AND"                     
cQuery += "	SE1.E1_TIPO  <> 'NCC' AND "                     
cQuery += "	SE1.E1_PORTADO <> ' '  "                     
cQuery += " GROUP BY E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"')
TCQUERY cQuery NEW ALIAS "QRY1"
                                          
// SOMA CARTEIRA - COM PORTADOR - SITUACAO 0 - TEM QUE x POR -1
//cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO,SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO  "
cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO, SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO "
cQuery += " FROM " + RetSqlName("SE1") + " SE1 (nolock) " // , " +   RetSqlName("SC5") + " SC5 "
cQuery += " WHERE 	SE1.D_E_L_E_T_ = ' ' AND "

//MyFilter()

cQuery += "	SE1.E1_SALDO > 0 AND  "                     
cQuery += "	SE1.E1_SITUACA = '0' AND "                     
cQuery += "	SE1.E1_PORTADO <> ' '  AND "                     
cQuery += "	SE1.E1_TIPO  <> 'NCC'  "  
cQuery += " GROUP BY E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"')
TCQUERY cQuery NEW ALIAS "QRY2"

// SOMA CARTEIRA SEM PORTADOR - SITUACAO 0
//cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO,SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO  "
cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO, SUM(E1_SALDO+E1_SDACRES-E1_SDDECRE) SALDO  "
cQuery += " FROM " + RetSqlName("SE1") + " SE1 (nolock) " //, " +   RetSqlName("SC5") + " SC5 "
cQuery += " WHERE 	SE1.D_E_L_E_T_ = ' ' AND "

//MyFilter()

cQuery += "	SE1.E1_SALDO > 0 AND  "                     
cQuery += "	SE1.E1_SITUACA = '0' AND "                     
cQuery += "	SE1.E1_PORTADO = ' '  AND  "                     
cQuery += "	SE1.E1_TIPO  <> 'NCC'  "  
cQuery += " GROUP BY E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"')
TCQUERY cQuery NEW ALIAS "QRY3"

// SOMA CARTEIRA - NCC - TEM QUE x POR -1
//cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO, '" + dDtBase +"') ATRASO,SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO  "
cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO, SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO"
cQuery += " FROM " + RetSqlName("SE1") + " SE1 (nolock) " //, " +   RetSqlName("SC5") + " SC5 "
cQuery += " WHERE 	SE1.D_E_L_E_T_ = ' ' AND "

//MyFilter()

cQuery += "	SE1.E1_SALDO > 0 AND  "                     
cQuery += "	SE1.E1_TIPO = 'NCC' AND "                                               
cQuery += "	SE1.E1_SITUACA NOT IN ('0') AND "                                               
cQuery += "	SE1.E1_PORTADO <> ' '  "                     
cQuery += " GROUP BY E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"')
TCQUERY cQuery NEW ALIAS "QRY4"

// SOMA CARTEIRA - NCC - TEM QUE x POR -1
//cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO, '" + dDtBase +"') ATRASO,SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO  "
cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO, SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO   "
cQuery += " FROM " + RetSqlName("SE1") + " SE1 (nolock) " //, " +   RetSqlName("SC5") + " SC5 "
cQuery += " WHERE 	SE1.D_E_L_E_T_ = ' ' AND "

//MyFilter()

cQuery += "	SE1.E1_SALDO > 0 AND  "                     
cQuery += "	SE1.E1_TIPO = 'NCC' AND "                                               
cQuery += "	SE1.E1_SITUACA IN ('0') AND "                                               
cQuery += "	SE1.E1_PORTADO <> ' '   "                     
cQuery += " GROUP BY E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"')
TCQUERY cQuery NEW ALIAS "QRY5"


// SOMA CARTEIRA - NCC - TEM QUE x POR -1
//cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO, '" + dDtBase +"') ATRASO,SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO  "
cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO,SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO  "
cQuery += " FROM " + RetSqlName("SE1") + " SE1 (nolock) " //, " +   RetSqlName("SC5") + " SC5 "
cQuery += " WHERE 	SE1.D_E_L_E_T_ = ' ' AND "

//Filter()

cQuery += "	SE1.E1_SALDO > 0 AND  "                     
cQuery += "	SE1.E1_TIPO = 'NCC' AND "                                               
cQuery += "	SE1.E1_SITUACA IN ('0') AND "                                               
cQuery += "	SE1.E1_PORTADO = ' '  "                     
cQuery += " GROUP BY E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"')
TCQUERY cQuery NEW ALIAS "QRY6"

//cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO, '" + dDtBase +"') ATRASO,SUM(E1_SALDO+E1_SDACRES-E1_SDDECRE) SALDO  "
cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO, SUM(E1_SALDO+E1_SDACRES-E1_SDDECRE) SALDO "
cQuery += " FROM " + RetSqlName("SE1") + " SE1 (nolock) " //, " +   RetSqlName("SC5") + " SC5 "
cQuery += " WHERE 	SE1.D_E_L_E_T_ = ' ' AND "

//Filter()

cQuery += "	SE1.E1_SALDO > 0 AND  "                     
cQuery += "	SE1.E1_TIPO NOT IN ('NCC') AND "                                               
cQuery += "	SE1.E1_SITUACA NOT IN ('0') AND "                                               
cQuery += "	SE1.E1_PORTADO = ' '  "                     
cQuery += " GROUP BY E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"')
TCQUERY cQuery NEW ALIAS "QRY7"


// SOMA CARTEIRA - NCC - TEM QUE x POR -1
//cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO, '" + dDtBase +"') ATRASO,SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO  "
cQuery := " SELECT E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"') ATRASO, SUM((E1_SALDO+E1_SDACRES-E1_SDDECRE)*-1) SALDO "
cQuery += " FROM " + RetSqlName("SE1") + " SE1 (nolock) " //, " +   RetSqlName("SC5") + " SC5 "
cQuery += " WHERE 	SE1.D_E_L_E_T_ = ' ' AND "

//Filter()

cQuery += "	SE1.E1_SALDO > 0 AND  "                     
cQuery += "	SE1.E1_TIPO = 'NCC' AND "                                               
cQuery += "	SE1.E1_SITUACA NOT IN ('0') AND "                                               
cQuery += "	SE1.E1_PORTADO = ' '  "                     
cQuery += " GROUP BY E1_PORTADO,E1_SITUACA,DATEDIFF(day, E1_VENCTO,'" + dDtBase +"')
TCQUERY cQuery NEW ALIAS "QRY8"

DBSELECTAREA("QRY1")     
procregua(reccount())
QRY1->(DBGOTOP())   

DO WHILE !QRY1->(EOF())
	zz := Ascan(aNewDados , {|x| x[1] = QRY1->E1_PORTADO .AND. X[2] = QRY1->E1_SITUACA })
	If ZZ = 0
		AAdd(aNewDados,{QRY1->E1_PORTADO ,;
						QRY1->E1_SITUACA ,;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif
	yy := Ascan(aTotCart , {|x| x[1] =  QRY1->E1_SITUACA })
	If yy = 0
		AAdd(aTotCart,{QRY1->E1_SITUACA ,'',;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif  
	yy := Ascan(aTotCart , {|x| x[1] =  QRY1->E1_SITUACA })
	zz := Ascan(aNewDados , {|x| x[1] = QRY1->E1_PORTADO .AND. X[2] = QRY1->E1_SITUACA })
	IF QRY1->ATRASO >= 360                   
		aNewdados[zz,3] += QRY1->SALDO 
		aTotCart[yy,3] += QRY1->SALDO     
		nTotVenci += QRY1->SALDO		
	Elseif QRY1->ATRASO >= 180 .and. QRY1->ATRASO < 360
		aNewdados[zz,4] += QRY1->SALDO	 
		aTotCart[yy,4] += QRY1->SALDO	
		nTotVenci += QRY1->SALDO		
	Elseif QRY1->ATRASO >= 90  .and. QRY1->ATRASO < 180
		aNewdados[zz,5] += QRY1->SALDO      
		aTotCart[yy,5] += QRY1->SALDO      
		nTotVenci += QRY1->SALDO			
	Elseif QRY1->ATRASO >= 60  .and. QRY1->ATRASO < 90
		aNewdados[zz,6] += QRY1->SALDO  
		aTotCart[yy,6] += QRY1->SALDO  
		nTotVenci += QRY1->SALDO			
	Elseif QRY1->ATRASO >= 30  .and. QRY1->ATRASO < 60
		aNewdados[zz,7] += QRY1->SALDO  
		aTotCart[yy,7] += QRY1->SALDO  
		nTotVenci += QRY1->SALDO			
	Elseif QRY1->ATRASO >= 1 .and. QRY1->ATRASO < 30 
		aNewdados[zz,8] += QRY1->SALDO	
		aTotCart[yy,8] += QRY1->SALDO
		nTotVenci += QRY1->SALDO			
	ElseIF QRY1->ATRASO < 1  .and. QRY1->ATRASO > -30  
		aNewdados[zz,10] += QRY1->SALDO		
		aTotCart[yy,10] += QRY1->SALDO		
		nTotVencer += QRY1->SALDO		
	ElseIF QRY1->ATRASO <= -30 .and. QRY1->ATRASO > -60
		aNewdados[zz,11] += QRY1->SALDO	
		aTotCart[yy,11] += QRY1->SALDO	
		nTotVencer += QRY1->SALDO					
	ElseIF QRY1->ATRASO <= -60 .and. QRY1->ATRASO > -90
		aNewdados[zz,12] += QRY1->SALDO	
		aTotCart[yy,12] += QRY1->SALDO	
		nTotVencer += QRY1->SALDO			
	ElseIF QRY1->ATRASO <= -90 .and. QRY1->ATRASO > -180
		aNewdados[zz,13] += QRY1->SALDO		
		aTotCart[yy,13] += QRY1->SALDO		
		nTotVencer += QRY1->SALDO		
	ElseIF QRY1->ATRASO <= -180 .and. QRY1->ATRASO > -360
		aNewdados[zz,14] += QRY1->SALDO		
		aTotCart[yy,14] += QRY1->SALDO		
		nTotVencer += QRY1->SALDO		
	ElseIF QRY1->ATRASO <= -360                
		aNewdados[zz,15] += QRY1->SALDO		
		aTotCart[yy,15] += QRY1->SALDO		
		nTotVencer += QRY1->SALDO		
	ENDIF
	QRY1->(DBSKIP())  
	IncProc()
ENDDO                

DBSELECTAREA("QRY2")
procregua(reccount())
QRY2->(DBGOTOP())   

DO WHILE !QRY2->(EOF())
	zz := Ascan(aNewDados , {|x| x[1] = QRY2->E1_PORTADO .AND. X[2] = QRY2->E1_SITUACA })
	If ZZ = 0
		AAdd(aNewDados,{QRY2->E1_PORTADO ,;
						QRY2->E1_SITUACA ,;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif
	yy := Ascan(aTotCart , {|x| x[1] =  QRY2->E1_SITUACA })
	If yy = 0
		AAdd(aTotCart,{QRY2->E1_SITUACA ,'',;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif  
	yy := Ascan(aTotCart , {|x| x[1] =  QRY2->E1_SITUACA })
	zz := Ascan(aNewDados , {|x| x[1] = QRY2->E1_PORTADO .AND. X[2] = QRY2->E1_SITUACA })
	IF QRY2->ATRASO >= 360                   
		aNewdados[zz,3] += QRY2->SALDO 
		aTotCart[yy,3] += QRY2->SALDO     
		nTotVenci += QRY2->SALDO		
	Elseif QRY2->ATRASO >= 180 .and. QRY2->ATRASO < 360
		aNewdados[zz,4] += QRY2->SALDO	 
		aTotCart[yy,4] += QRY2->SALDO	
		nTotVenci += QRY2->SALDO		
	Elseif QRY2->ATRASO >= 90  .and. QRY2->ATRASO < 180
		aNewdados[zz,5] += QRY2->SALDO      
		aTotCart[yy,5] += QRY2->SALDO      
		nTotVenci += QRY2->SALDO			
	Elseif QRY2->ATRASO >= 60  .and. QRY2->ATRASO < 90
		aNewdados[zz,6] += QRY2->SALDO  
		aTotCart[yy,6] += QRY2->SALDO  
		nTotVenci += QRY2->SALDO			
	Elseif QRY2->ATRASO >= 30  .and. QRY2->ATRASO < 60
		aNewdados[zz,7] += QRY2->SALDO  
		aTotCart[yy,7] += QRY2->SALDO  
		nTotVenci += QRY2->SALDO			
	Elseif QRY2->ATRASO >= 1 .and. QRY2->ATRASO < 30 
		aNewdados[zz,8] += QRY2->SALDO	
		aTotCart[yy,8] += QRY2->SALDO
		nTotVenci += QRY2->SALDO			
	ElseIF QRY2->ATRASO < 1  .and. QRY2->ATRASO > -30  
		aNewdados[zz,10] += QRY2->SALDO		
		aTotCart[yy,10] += QRY2->SALDO		
		nTotVencer += QRY2->SALDO		
	ElseIF QRY2->ATRASO <= -30 .and. QRY2->ATRASO > -60
		aNewdados[zz,11] += QRY2->SALDO	
		aTotCart[yy,11] += QRY2->SALDO	
		nTotVencer += QRY2->SALDO					
	ElseIF QRY2->ATRASO <= -60 .and. QRY2->ATRASO > -90
		aNewdados[zz,12] += QRY2->SALDO	
		aTotCart[yy,12] += QRY2->SALDO	
		nTotVencer += QRY2->SALDO			
	ElseIF QRY2->ATRASO <= -90 .and. QRY2->ATRASO > -180
		aNewdados[zz,13] += QRY2->SALDO		
		aTotCart[yy,13] += QRY2->SALDO		
		nTotVencer += QRY2->SALDO		
	ElseIF QRY2->ATRASO <= -180 .and. QRY2->ATRASO > -360
		aNewdados[zz,14] += QRY2->SALDO		
		aTotCart[yy,14] += QRY2->SALDO		
		nTotVencer += QRY2->SALDO		
	ElseIF QRY2->ATRASO <= -360                
		aNewdados[zz,15] += QRY2->SALDO		
		aTotCart[yy,15] += QRY2->SALDO		
		nTotVencer += QRY2->SALDO		
	ENDIF
	QRY2->(DBSKIP()) 
	IncProc()
ENDDO                

DBSELECTAREA("QRY3")
procregua(reccount())
QRY3->(DBGOTOP())   

DO WHILE !QRY3->(EOF())
	zz := Ascan(aNewDados , {|x| x[1] = QRY3->E1_PORTADO .AND. X[2] = QRY3->E1_SITUACA })
	If ZZ = 0
		AAdd(aNewDados,{QRY3->E1_PORTADO ,;
						QRY3->E1_SITUACA ,;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif
	yy := Ascan(aTotCart , {|x| x[1] =  QRY3->E1_SITUACA })
	If yy = 0
		AAdd(aTotCart,{QRY3->E1_SITUACA ,'',;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif  
	yy := Ascan(aTotCart , {|x| x[1] =  QRY3->E1_SITUACA })
	zz := Ascan(aNewDados , {|x| x[1] = QRY3->E1_PORTADO .AND. X[2] = QRY3->E1_SITUACA })
	IF QRY3->ATRASO >= 360                   
		aNewdados[zz,3] += QRY3->SALDO 
		aTotCart[yy,3] += QRY3->SALDO     
		nTotVenci += QRY3->SALDO		
	Elseif QRY3->ATRASO >= 180 .and. QRY3->ATRASO < 360
		aNewdados[zz,4] += QRY3->SALDO	 
		aTotCart[yy,4] += QRY3->SALDO	
		nTotVenci += QRY3->SALDO		
	Elseif QRY3->ATRASO >= 90  .and. QRY3->ATRASO < 180
		aNewdados[zz,5] += QRY3->SALDO      
		aTotCart[yy,5] += QRY3->SALDO      
		nTotVenci += QRY3->SALDO			
	Elseif QRY3->ATRASO >= 60  .and. QRY3->ATRASO < 90
		aNewdados[zz,6] += QRY3->SALDO  
		aTotCart[yy,6] += QRY3->SALDO  
		nTotVenci += QRY3->SALDO			
	Elseif QRY3->ATRASO >= 30  .and. QRY3->ATRASO < 60
		aNewdados[zz,7] += QRY3->SALDO  
		aTotCart[yy,7] += QRY3->SALDO  
		nTotVenci += QRY3->SALDO			
	Elseif QRY3->ATRASO >= 1 .and. QRY3->ATRASO < 30 
		aNewdados[zz,8] += QRY3->SALDO	
		aTotCart[yy,8] += QRY3->SALDO
		nTotVenci += QRY3->SALDO			
	ElseIF QRY3->ATRASO < 1  .and. QRY3->ATRASO > -30  
		aNewdados[zz,10] += QRY3->SALDO		
		aTotCart[yy,10] += QRY3->SALDO		
		nTotVencer += QRY3->SALDO		
	ElseIF QRY3->ATRASO <= -30 .and. QRY3->ATRASO > -60
		aNewdados[zz,11] += QRY3->SALDO	
		aTotCart[yy,11] += QRY3->SALDO	
		nTotVencer += QRY3->SALDO					
	ElseIF QRY3->ATRASO <= -60 .and. QRY3->ATRASO > -90
		aNewdados[zz,12] += QRY3->SALDO	
		aTotCart[yy,12] += QRY3->SALDO	
		nTotVencer += QRY3->SALDO			
	ElseIF QRY3->ATRASO <= -90 .and. QRY3->ATRASO > -180
		aNewdados[zz,13] += QRY3->SALDO		
		aTotCart[yy,13] += QRY3->SALDO		
		nTotVencer += QRY3->SALDO		
	ElseIF QRY3->ATRASO <= -180 .and. QRY3->ATRASO > -360
		aNewdados[zz,14] += QRY3->SALDO		
		aTotCart[yy,14] += QRY3->SALDO		
		nTotVencer += QRY3->SALDO		
	ElseIF QRY3->ATRASO <= -360                
		aNewdados[zz,15] += QRY3->SALDO		
		aTotCart[yy,15] += QRY3->SALDO		
		nTotVencer += QRY3->SALDO		
	ENDIF
	QRY3->(DBSKIP()) 
	IncProc()
ENDDO   


DBSELECTAREA("QRY4")
procregua(reccount())
QRY4->(DBGOTOP())   

DO WHILE !QRY4->(EOF())
	zz := Ascan(aNewDados , {|x| x[1] = QRY4->E1_PORTADO .AND. X[2] = QRY4->E1_SITUACA })
	If ZZ = 0
		AAdd(aNewDados,{QRY4->E1_PORTADO ,;
						QRY4->E1_SITUACA ,;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif
	yy := Ascan(aTotCart , {|x| x[1] =  QRY4->E1_SITUACA })
	If yy = 0
		AAdd(aTotCart,{QRY4->E1_SITUACA ,'',;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif  
	yy := Ascan(aTotCart , {|x| x[1] =  QRY4->E1_SITUACA })
	zz := Ascan(aNewDados , {|x| x[1] = QRY4->E1_PORTADO .AND. X[2] = QRY4->E1_SITUACA })
	IF QRY4->ATRASO >= 360                   
		aNewdados[zz,3] += QRY4->SALDO 
		aTotCart[yy,3] += QRY4->SALDO     
		nTotVenci += QRY4->SALDO		
	Elseif QRY4->ATRASO >= 180 .and. QRY4->ATRASO < 360
		aNewdados[zz,4] += QRY4->SALDO	 
		aTotCart[yy,4] += QRY4->SALDO	
		nTotVenci += QRY4->SALDO		
	Elseif QRY4->ATRASO >= 90  .and. QRY4->ATRASO < 180
		aNewdados[zz,5] += QRY4->SALDO      
		aTotCart[yy,5] += QRY4->SALDO      
		nTotVenci += QRY4->SALDO			
	Elseif QRY4->ATRASO >= 60  .and. QRY4->ATRASO < 90
		aNewdados[zz,6] += QRY4->SALDO  
		aTotCart[yy,6] += QRY4->SALDO  
		nTotVenci += QRY4->SALDO			
	Elseif QRY4->ATRASO >= 30  .and. QRY4->ATRASO < 60
		aNewdados[zz,7] += QRY4->SALDO  
		aTotCart[yy,7] += QRY4->SALDO  
		nTotVenci += QRY4->SALDO			
	Elseif QRY4->ATRASO >= 1 .and. QRY4->ATRASO < 30 
		aNewdados[zz,8] += QRY4->SALDO	
		aTotCart[yy,8] += QRY4->SALDO
		nTotVenci += QRY4->SALDO			
	ElseIF QRY4->ATRASO < 1  .and. QRY4->ATRASO > -30  
		aNewdados[zz,10] += QRY4->SALDO		
		aTotCart[yy,10] += QRY4->SALDO		
		nTotVencer += QRY4->SALDO		
	ElseIF QRY4->ATRASO <= -30 .and. QRY4->ATRASO > -60
		aNewdados[zz,11] += QRY4->SALDO	
		aTotCart[yy,11] += QRY4->SALDO	
		nTotVencer += QRY4->SALDO					
	ElseIF QRY4->ATRASO <= -60 .and. QRY4->ATRASO > -90
		aNewdados[zz,12] += QRY4->SALDO	
		aTotCart[yy,12] += QRY4->SALDO	
		nTotVencer += QRY4->SALDO			
	ElseIF QRY4->ATRASO <= -90 .and. QRY4->ATRASO > -180
		aNewdados[zz,13] += QRY4->SALDO		
		aTotCart[yy,13] += QRY4->SALDO		
		nTotVencer += QRY4->SALDO		
	ElseIF QRY4->ATRASO <= -180 .and. QRY4->ATRASO > -360
		aNewdados[zz,14] += QRY4->SALDO		
		aTotCart[yy,14] += QRY4->SALDO		
		nTotVencer += QRY4->SALDO		
	ElseIF QRY4->ATRASO <= -360                
		aNewdados[zz,15] += QRY4->SALDO		
		aTotCart[yy,15] += QRY4->SALDO		
		nTotVencer += QRY4->SALDO		
	ENDIF
	QRY4->(DBSKIP())
	IncProc()
ENDDO                

DBSELECTAREA("QRY5")
procregua(reccount())
QRY5->(DBGOTOP())   

DO WHILE !QRY5->(EOF())
	zz := Ascan(aNewDados , {|x| x[1] = QRY5->E1_PORTADO .AND. X[2] = QRY5->E1_SITUACA })
	If ZZ = 0
		AAdd(aNewDados,{QRY5->E1_PORTADO ,;
						QRY5->E1_SITUACA ,;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif
	yy := Ascan(aTotCart , {|x| x[1] =  QRY5->E1_SITUACA })
	If yy = 0
		AAdd(aTotCart,{QRY5->E1_SITUACA ,'',;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif  
	yy := Ascan(aTotCart , {|x| x[1] =  QRY5->E1_SITUACA })
	zz := Ascan(aNewDados , {|x| x[1] = QRY5->E1_PORTADO .AND. X[2] = QRY5->E1_SITUACA })
	IF QRY5->ATRASO >= 360                   
		aNewdados[zz,3] += QRY5->SALDO 
		aTotCart[yy,3] += QRY5->SALDO     
		nTotVenci += QRY5->SALDO		
	Elseif QRY5->ATRASO >= 180 .and. QRY5->ATRASO < 360
		aNewdados[zz,4] += QRY5->SALDO	 
		aTotCart[yy,4] += QRY5->SALDO	
		nTotVenci += QRY5->SALDO		
	Elseif QRY5->ATRASO >= 90  .and. QRY5->ATRASO < 180
		aNewdados[zz,5] += QRY5->SALDO      
		aTotCart[yy,5] += QRY5->SALDO      
		nTotVenci += QRY5->SALDO			
	Elseif QRY5->ATRASO >= 60  .and. QRY5->ATRASO < 90
		aNewdados[zz,6] += QRY5->SALDO  
		aTotCart[yy,6] += QRY5->SALDO  
		nTotVenci += QRY5->SALDO			
	Elseif QRY5->ATRASO >= 30  .and. QRY5->ATRASO < 60
		aNewdados[zz,7] += QRY5->SALDO  
		aTotCart[yy,7] += QRY5->SALDO  
		nTotVenci += QRY5->SALDO			
	Elseif QRY5->ATRASO >= 1 .and. QRY5->ATRASO < 30 
		aNewdados[zz,8] += QRY5->SALDO	
		aTotCart[yy,8] += QRY5->SALDO
		nTotVenci += QRY5->SALDO			
	ElseIF QRY5->ATRASO < 1  .and. QRY5->ATRASO > -30  
		aNewdados[zz,10] += QRY5->SALDO		
		aTotCart[yy,10] += QRY5->SALDO		
		nTotVencer += QRY5->SALDO		
	ElseIF QRY5->ATRASO <= -30 .and. QRY5->ATRASO > -60
		aNewdados[zz,11] += QRY5->SALDO	
		aTotCart[yy,11] += QRY5->SALDO	
		nTotVencer += QRY5->SALDO					
	ElseIF QRY5->ATRASO <= -60 .and. QRY5->ATRASO > -90
		aNewdados[zz,12] += QRY5->SALDO	
		aTotCart[yy,12] += QRY5->SALDO	
		nTotVencer += QRY5->SALDO			
	ElseIF QRY5->ATRASO <= -90 .and. QRY5->ATRASO > -180
		aNewdados[zz,13] += QRY5->SALDO		
		aTotCart[yy,13] += QRY5->SALDO		
		nTotVencer += QRY5->SALDO		
	ElseIF QRY5->ATRASO <= -180 .and. QRY5->ATRASO > -360
		aNewdados[zz,14] += QRY5->SALDO		
		aTotCart[yy,14] += QRY5->SALDO		
		nTotVencer += QRY5->SALDO		
	ElseIF QRY5->ATRASO <= -360                
		aNewdados[zz,15] += QRY5->SALDO		
		aTotCart[yy,15] += QRY5->SALDO		
		nTotVencer += QRY5->SALDO		
	ENDIF
	QRY5->(DBSKIP()) 
	IncProc()
ENDDO                
                                              
DBSELECTAREA("QRY6")
procregua(reccount())
QRY6->(DBGOTOP())   

DO WHILE !QRY6->(EOF())
	zz := Ascan(aNewDados , {|x| x[1] = QRY6->E1_PORTADO .AND. X[2] = QRY6->E1_SITUACA })
	If ZZ = 0
		AAdd(aNewDados,{QRY6->E1_PORTADO ,;
						QRY6->E1_SITUACA ,;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif
	yy := Ascan(aTotCart , {|x| x[1] =  QRY6->E1_SITUACA })
	If yy = 0
		AAdd(aTotCart,{QRY6->E1_SITUACA ,'',;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif  
	yy := Ascan(aTotCart , {|x| x[1] =  QRY6->E1_SITUACA })
	zz := Ascan(aNewDados , {|x| x[1] = QRY6->E1_PORTADO .AND. X[2] = QRY6->E1_SITUACA })
	IF QRY6->ATRASO >= 360                   
		aNewdados[zz,3] += QRY6->SALDO 
		aTotCart[yy,3] += QRY6->SALDO     
		nTotVenci += QRY6->SALDO		
	Elseif QRY6->ATRASO >= 180 .and. QRY6->ATRASO < 360
		aNewdados[zz,4] += QRY6->SALDO	 
		aTotCart[yy,4] += QRY6->SALDO	
		nTotVenci += QRY6->SALDO		
	Elseif QRY6->ATRASO >= 90  .and. QRY6->ATRASO < 180
		aNewdados[zz,5] += QRY6->SALDO      
		aTotCart[yy,5] += QRY6->SALDO      
		nTotVenci += QRY6->SALDO			
	Elseif QRY6->ATRASO >= 60  .and. QRY6->ATRASO < 90
		aNewdados[zz,6] += QRY6->SALDO  
		aTotCart[yy,6] += QRY6->SALDO  
		nTotVenci += QRY6->SALDO			
	Elseif QRY6->ATRASO >= 30  .and. QRY6->ATRASO < 60
		aNewdados[zz,7] += QRY6->SALDO  
		aTotCart[yy,7] += QRY6->SALDO  
		nTotVenci += QRY6->SALDO			
	Elseif QRY6->ATRASO >= 1 .and. QRY6->ATRASO < 30 
		aNewdados[zz,8] += QRY6->SALDO	
		aTotCart[yy,8] += QRY6->SALDO
		nTotVenci += QRY6->SALDO			
	ElseIF QRY6->ATRASO < 1  .and. QRY6->ATRASO > -30  
		aNewdados[zz,10] += QRY6->SALDO		
		aTotCart[yy,10] += QRY6->SALDO		
		nTotVencer += QRY6->SALDO		
	ElseIF QRY6->ATRASO <= -30 .and. QRY6->ATRASO > -60
		aNewdados[zz,11] += QRY6->SALDO	
		aTotCart[yy,11] += QRY6->SALDO	
		nTotVencer += QRY6->SALDO					
	ElseIF QRY6->ATRASO <= -60 .and. QRY6->ATRASO > -90
		aNewdados[zz,12] += QRY6->SALDO	
		aTotCart[yy,12] += QRY6->SALDO	
		nTotVencer += QRY6->SALDO			
	ElseIF QRY6->ATRASO <= -90 .and. QRY6->ATRASO > -180
		aNewdados[zz,13] += QRY6->SALDO		
		aTotCart[yy,13] += QRY6->SALDO		
		nTotVencer += QRY6->SALDO		
	ElseIF QRY6->ATRASO <= -180 .and. QRY6->ATRASO > -360
		aNewdados[zz,14] += QRY6->SALDO		
		aTotCart[yy,14] += QRY6->SALDO		
		nTotVencer += QRY6->SALDO		
	ElseIF QRY6->ATRASO <= -360                
		aNewdados[zz,15] += QRY6->SALDO		
		aTotCart[yy,15] += QRY6->SALDO		
		nTotVencer += QRY6->SALDO		
	ENDIF
	QRY6->(DBSKIP()) 
	IncProc()
ENDDO                
        
DBSELECTAREA("QRY7")
procregua(reccount())
QRY7->(DBGOTOP())   

DO WHILE !QRY7->(EOF())
	zz := Ascan(aNewDados , {|x| x[1] = QRY7->E1_PORTADO .AND. X[2] = QRY7->E1_SITUACA })
	If ZZ = 0
		AAdd(aNewDados,{QRY7->E1_PORTADO ,;
						QRY7->E1_SITUACA ,;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif
	yy := Ascan(aTotCart , {|x| x[1] =  QRY7->E1_SITUACA })
	If yy = 0
		AAdd(aTotCart,{QRY7->E1_SITUACA ,'',;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif  
	yy := Ascan(aTotCart , {|x| x[1] =  QRY7->E1_SITUACA })
	zz := Ascan(aNewDados , {|x| x[1] = QRY7->E1_PORTADO .AND. X[2] = QRY7->E1_SITUACA })
	IF QRY7->ATRASO >= 360                   
		aNewdados[zz,3] += QRY7->SALDO 
		aTotCart[yy,3] += QRY7->SALDO     
		nTotVenci += QRY7->SALDO		
	Elseif QRY7->ATRASO >= 180 .and. QRY7->ATRASO < 360
		aNewdados[zz,4] += QRY7->SALDO	 
		aTotCart[yy,4] += QRY7->SALDO	
		nTotVenci += QRY7->SALDO		
	Elseif QRY7->ATRASO >= 90  .and. QRY7->ATRASO < 180
		aNewdados[zz,5] += QRY7->SALDO      
		aTotCart[yy,5] += QRY7->SALDO      
		nTotVenci += QRY7->SALDO			
	Elseif QRY7->ATRASO >= 60  .and. QRY7->ATRASO < 90
		aNewdados[zz,6] += QRY7->SALDO  
		aTotCart[yy,6] += QRY7->SALDO  
		nTotVenci += QRY7->SALDO			
	Elseif QRY7->ATRASO >= 30  .and. QRY7->ATRASO < 60
		aNewdados[zz,7] += QRY7->SALDO  
		aTotCart[yy,7] += QRY7->SALDO  
		nTotVenci += QRY7->SALDO			
	Elseif QRY7->ATRASO >= 1 .and. QRY7->ATRASO < 30 
		aNewdados[zz,8] += QRY7->SALDO	
		aTotCart[yy,8] += QRY7->SALDO
		nTotVenci += QRY7->SALDO			
	ElseIF QRY7->ATRASO < 1  .and. QRY7->ATRASO > -30  
		aNewdados[zz,10] += QRY7->SALDO		
		aTotCart[yy,10] += QRY7->SALDO		
		nTotVencer += QRY7->SALDO		
	ElseIF QRY7->ATRASO <= -30 .and. QRY7->ATRASO > -60
		aNewdados[zz,11] += QRY7->SALDO	
		aTotCart[yy,11] += QRY7->SALDO	
		nTotVencer += QRY7->SALDO					
	ElseIF QRY7->ATRASO <= -60 .and. QRY7->ATRASO > -90
		aNewdados[zz,12] += QRY7->SALDO	
		aTotCart[yy,12] += QRY7->SALDO	
		nTotVencer += QRY7->SALDO			
	ElseIF QRY7->ATRASO <= -90 .and. QRY7->ATRASO > -180
		aNewdados[zz,13] += QRY7->SALDO		
		aTotCart[yy,13] += QRY7->SALDO		
		nTotVencer += QRY7->SALDO		
	ElseIF QRY7->ATRASO <= -180 .and. QRY7->ATRASO > -360
		aNewdados[zz,14] += QRY7->SALDO		
		aTotCart[yy,14] += QRY7->SALDO		
		nTotVencer += QRY7->SALDO		
	ElseIF QRY7->ATRASO <= -360                
		aNewdados[zz,15] += QRY7->SALDO		
		aTotCart[yy,15] += QRY7->SALDO		
		nTotVencer += QRY7->SALDO		
	ENDIF            
	QRY7->(DBSKIP())
	IncProc()
ENDDO                

DBSELECTAREA("QRY8")
procregua(reccount())
QRY8->(DBGOTOP())   

DO WHILE !QRY8->(EOF())
	zz := Ascan(aNewDados , {|x| x[1] = QRY8->E1_PORTADO .AND. X[2] = QRY8->E1_SITUACA })
	If ZZ = 0
		AAdd(aNewDados,{QRY8->E1_PORTADO ,;
						QRY8->E1_SITUACA ,;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif
	yy := Ascan(aTotCart , {|x| x[1] =  QRY8->E1_SITUACA })
	If yy = 0
		AAdd(aTotCart,{QRY8->E1_SITUACA ,'',;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0, ;
						0 })
	Endif  
	yy := Ascan(aTotCart , {|x| x[1] =  QRY8->E1_SITUACA })
	zz := Ascan(aNewDados , {|x| x[1] = QRY8->E1_PORTADO .AND. X[2] = QRY8->E1_SITUACA })
	IF QRY8->ATRASO >= 360                   
		aNewdados[zz,3] += QRY8->SALDO 
		aTotCart[yy,3] += QRY8->SALDO     
		nTotVenci += QRY8->SALDO		
	Elseif QRY8->ATRASO >= 180 .and. QRY8->ATRASO < 360
		aNewdados[zz,4] += QRY8->SALDO	 
		aTotCart[yy,4] += QRY8->SALDO	
		nTotVenci += QRY8->SALDO		
	Elseif QRY8->ATRASO >= 90  .and. QRY8->ATRASO < 180
		aNewdados[zz,5] += QRY8->SALDO      
		aTotCart[yy,5] += QRY8->SALDO      
		nTotVenci += QRY8->SALDO			
	Elseif QRY8->ATRASO >= 60  .and. QRY8->ATRASO < 90
		aNewdados[zz,6] += QRY8->SALDO  
		aTotCart[yy,6] += QRY8->SALDO  
		nTotVenci += QRY8->SALDO			
	Elseif QRY8->ATRASO >= 30  .and. QRY8->ATRASO < 60
		aNewdados[zz,7] += QRY8->SALDO  
		aTotCart[yy,7] += QRY8->SALDO  
		nTotVenci += QRY8->SALDO			
	Elseif QRY8->ATRASO >= 1 .and. QRY8->ATRASO < 30 
		aNewdados[zz,8] += QRY8->SALDO	
		aTotCart[yy,8] += QRY8->SALDO
		nTotVenci += QRY8->SALDO			
	ElseIF QRY8->ATRASO < 1  .and. QRY8->ATRASO > -30  
		aNewdados[zz,10] += QRY8->SALDO		
		aTotCart[yy,10] += QRY8->SALDO		
		nTotVencer += QRY8->SALDO		
	ElseIF QRY8->ATRASO <= -30 .and. QRY8->ATRASO > -60
		aNewdados[zz,11] += QRY8->SALDO	
		aTotCart[yy,11] += QRY8->SALDO	
		nTotVencer += QRY8->SALDO					
	ElseIF QRY8->ATRASO <= -60 .and. QRY8->ATRASO > -90
		aNewdados[zz,12] += QRY8->SALDO	
		aTotCart[yy,12] += QRY8->SALDO	
		nTotVencer += QRY8->SALDO			
	ElseIF QRY8->ATRASO <= -90 .and. QRY8->ATRASO > -180
		aNewdados[zz,13] += QRY8->SALDO		
		aTotCart[yy,13] += QRY8->SALDO		
		nTotVencer += QRY8->SALDO		
	ElseIF QRY8->ATRASO <= -180 .and. QRY8->ATRASO > -360
		aNewdados[zz,14] += QRY8->SALDO		
		aTotCart[yy,14] += QRY8->SALDO		
		nTotVencer += QRY8->SALDO		
	ElseIF QRY8->ATRASO <= -360                
		aNewdados[zz,15] += QRY8->SALDO		
		aTotCart[yy,15] += QRY8->SALDO		
		nTotVencer += QRY8->SALDO		
	ENDIF
	QRY8->(DBSKIP()) 
	IncProc()
ENDDO                

ASORT(aNewDados,,, { |x, y| x[1] < y[1] })

zz := 0
nMax := Len(aNewDados)
ProcRegua(nMax)
SA6->(DbSetOrder(1))
For zz = 1 to nMax   
	If zz = 1
		cBanco := aNewDados[zz,1]
	EndIf
	SA6->( DbSeek( xFilial("SA6") + aNewDados[zz,1] ) ) 
	SX5->( dbSeek(xFilial()+"07"+ aNewDados[zz,2]) )
	If aNewDados[zz,1] <> cBanco 
		cLinha := ""+";"+"T O T A L "+";"
	    cLinha += transform(nTotb01, "@E 99,999,999,999.99")+";"+transform(nTotb02, "@E 99,999,999,999.99")+";"+transform(nTotb03 ,"@E 99,999,999,999.99")+";"+transform(nTotb04 ,"@E 99,999,999,999.99")+";"+transform(nTotb05 ,"@E 99,999,999,999.99")+";"+transform(nTotb06 ,"@E 99,999,999,999.99")+";"+transform(nTotb07, "@E 9,999,999,999,999.99")+";"+transform(nTotb08 ,"@E 99,999,999,999.99")+";"+transform(nTotb09 ,"@E 99,999,999,999.99")+";"+transform(nTotb10 ,"@E 99,999,999,999.99")+";"+transform(nTotb11 ,"@E 99,999,999,999.99")+";"+transform(nTotb12 ,"@E 99,999,999,999.99")+";"+transform(nTotb13 ,"@E 99,999,999,999.99")+";"+transform(nTotb14 ,"@E 9,999,999,999,999.99")	 			
		fWrite(nHandle, cLinha  + cCrLf)
		ntotb01 := 0
		ntotb02 := 0
		ntotb03 := 0
		ntotb04 := 0
		ntotb05 := 0
		ntotb06 := 0
		ntotb07 := 0
		ntotb08 := 0
		ntotb09 := 0
		ntotb10 := 0
		ntotb11 := 0
		ntotb12 := 0
		ntotb13 := 0
		ntotb14 := 0
		ntotb15 := 0
		cBanco := aNewDados[zz,1]   
		cLinha := ""+";"+""+";"
		fWrite(nHandle, cLinha  + cCrLf)
	EndIF
   	nbanvencer  :=  aNewDados[zz,10]+aNewDados[zz,11]+aNewDados[zz,12]+aNewDados[zz,13]+aNewDados[zz,14]+aNewDados[zz,15]
	nbanvencido :=  aNewDados[zz,3]+aNewDados[zz,4]+aNewDados[zz,5]+aNewDados[zz,6]+aNewDados[zz,7]+aNewDados[zz,8]
	cLinha := SA6->A6_NOME+";"+Alltrim(Left(X5Descri(),20))+";"
    cLinha += transform(aNewDados[zz,3], "@E 99,999,999,999.99")+";"+transform(aNewDados[zz,4], "@E 99,999,999,999.99")+";"+transform(aNewDados[zz,5] ,"@E 99,999,999,999.99")+";"+transform(aNewDados[zz,6] ,"@E 99,999,999,999.99")+";"+transform(aNewDados[zz,7] ,"@E 99,999,999,999.99")+";"+transform(aNewDados[zz,8] ,"@E 99,999,999,999.99")+";"+transform(nBanVencido, "@E 9,999,999,999,999.99")+";"+transform(aNewDados[zz,10] ,"@E 99,999,999,999.99")+";"+transform(aNewDados[zz,11] ,"@E 99,999,999,999.99")+";"+transform(aNewDados[zz,12] ,"@E 99,999,999,999.99")+";"+transform(aNewDados[zz,13] ,"@E 99,999,999,999.99")+";"+transform(aNewDados[zz,14] ,"@E 99,999,999,999.99")+";"+transform(aNewDados[zz,15] ,"@E 99,999,999,999.99")+";"+transform(nBanVencer ,"@E 9,999,999,999,999.99")	 			
	fWrite(nHandle, cLinha  + cCrLf)
		ntotb01 += aNewDados[zz,3]
		ntotb02 += aNewDados[zz,4]
		ntotb03 += aNewDados[zz,5]
		ntotb04 += aNewDados[zz,6]
		ntotb05 += aNewDados[zz,7]
		ntotb06 += aNewDados[zz,8]
		ntotb07 += nBanVencido
		ntotb08 += aNewDados[zz,10]
		ntotb09 += aNewDados[zz,11] 
		ntotb10 += aNewDados[zz,12]
		ntotb11 += aNewDados[zz,13]
		ntotb12 += aNewDados[zz,14]
		ntotb13 += aNewDados[zz,15]
		ntotb14 += nBanVencer
	 	ntotG01 += aNewDados[zz,3]
		ntotG02 += aNewDados[zz,4]
		ntotG03 += aNewDados[zz,5]
		ntotG04 += aNewDados[zz,6]
		ntotG05 += aNewDados[zz,7]
		ntotG06 += aNewDados[zz,8]
		ntotG07 += nBanVencido
		ntotG08 += aNewDados[zz,10]
		ntotG09 += aNewDados[zz,11] 
		ntotG10 += aNewDados[zz,12]
		ntotG11 += aNewDados[zz,13]
		ntotG12 += aNewDados[zz,14]
		ntotG13 += aNewDados[zz,15]
		ntotG14 += nBanVencer	
		IncProc()
Next         
cLinha := SA6->A6_NOME+";"+"T O T A L "+";"
cLinha += transform(nTotb01, "@E 99,999,999,999.99")+";"+transform(nTotb02, "@E 99,999,999,999.99")+";"+transform(nTotb03 ,"@E 99,999,999,999.99")+";"+transform(nTotb04 ,"@E 99,999,999,999.99")+";"+transform(nTotb05 ,"@E 99,999,999,999.99")+";"+transform(nTotb06 ,"@E 99,999,999,999.99")+";"+transform(nTotb07, "@E 9,999,999,999,999.99")+";"+transform(nTotb08 ,"@E 99,999,999,999.99")+";"+transform(nTotb09 ,"@E 99,999,999,999.99")+";"+transform(nTotb10 ,"@E 99,999,999,999.99")+";"+transform(nTotb11 ,"@E 99,999,999,999.99")+";"+transform(nTotb12 ,"@E 99,999,999,999.99")+";"+transform(nTotb13 ,"@E 99,999,999,999.99")+";"+transform(nTotb14 ,"@E 9,999,999,999,999.99")	 			
fWrite(nHandle, cLinha  + cCrLf)       
cLinha := ""+";"+""+";"
fWrite(nHandle, cLinha  + cCrLf)   
nMax :=Len(aTotCart)
For zz = 1 to nMax   
	If zz = 1
		cBanco := aNewDados[zz,1]
	EndIf
	SX5->( dbSeek(xFilial()+"07"+ aTotCart[zz,1]) )
	ncarvencer  :=  aTotCart[zz,10]+aTotCart[zz,11]+aTotCart[zz,12]+aTotCart[zz,13]+aTotCart[zz,14]+aTotCart[zz,15]
	ncarvencido :=  aTotCart[zz,3]+aTotCart[zz,4]+aTotCart[zz,5]+aTotCart[zz,6]+aTotCart[zz,7]+aTotCart[zz,8]
	cLinha := "T O T A L " +";"+Alltrim(Left(X5Descri(),20))+";"
    cLinha += transform(aTotCart[zz,3], "@E 99,999,999,999.99")+";"+transform(aTotCart[zz,4], "@E 99,999,999,999.99")+";"+transform(aTotCart[zz,5] ,"@E 99,999,999,999.99")+";"+transform(aTotCart[zz,6] ,"@E 99,999,999,999.99")+";"+transform(aTotCart[zz,7] ,"@E 99,999,999,999.99")+";"+transform(aTotCart[zz,8] ,"@E 99,999,999,999.99")+";"+transform(nCarVencido, "@E 9,999,999,999,999.99")+";"+transform(aTotCart[zz,10] ,"@E 99,999,999,999.99")+";"+transform(aTotCart[zz,11] ,"@E 99,999,999,999.99")+";"+transform(aTotCart[zz,12] ,"@E 99,999,999,999.99")+";"+transform(aTotCart[zz,13] ,"@E 99,999,999,999.99")+";"+transform(aTotCart[zz,14] ,"@E 99,999,999,999.99")+";"+transform(atotcart[zz,15] ,"@E 99,999,999,999.99")+";"+transform(nCarVencer ,"@E 9,999,999,999,999.99")	
    fWrite(nHandle, cLinha  + cCrLf) 
Next	
clinha := ''+";"+""+";"
fWrite(nHandle, cLinha  + cCrLf)       
cLinha := ""+";"+""+";"
fWrite(nHandle, cLinha  + cCrLf)   
cLinha := "T O T A L   G E R A L  "+";"+""+";"
cLinha += transform(nTotG01, "@E 99,999,999,999.99")+";"+transform(nTotG02, "@E 99,999,999,999.99")+";"+transform(nTotG03 ,"@E 99,999,999,999.99")+";"+transform(nTotG04 ,"@E 99,999,999,999.99")+";"+transform(nTotG05 ,"@E 99,999,999,999.99")+";"+transform(nTotG06 ,"@E 99,999,999,999.99")+";"+transform(nTotG07, "@E 9,999,999,999,999.99")+";"+transform(nTotG08 ,"@E 99,999,999,999.99")+";"+transform(nTotG09 ,"@E 99,999,999,999.99")+";"+transform(nTotG10 ,"@E 99,999,999,999.99")+";"+transform(nTotG11 ,"@E 99,999,999,999.99")+";"+transform(nTotG12 ,"@E 99,999,999,999.99")+";"+transform(nTotG13 ,"@E 99,999,999,999.99")+";"+transform(nTotG14 ,"@E 9,999,999,999,999.99")	 			
fWrite(nHandle, cLinha  + cCrLf)
fClose(nHandle)
//CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
                                	
RETURN

//CRIACAO DA PERGUNTA
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
          //	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
  AAdd(aRegs,{cPerg,"01","Dt.Referencia   : "        ,""   				,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"02","Filial de       : "        ,""   				,""  			,"mv_ch2",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"03","Filial ate      : "        ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  //AAdd(aRegs,{cPerg,"04","Divisao Neg. de : "        ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"ZM",			""})  
  //AAdd(aRegs,{cPerg,"05","Divisao Neg. ate: "        ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"ZM",			""})  
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return


Static Function MyFilter()
If !empty(mv_par01)
	cQuery +=  " SE1.E1_EMISSAO <= '" + DTOS(MV_PAR01) + "' AND "
EndIf
IF ! EMPTY(MV_PAR02) .OR. !EMPTY(MV_PAR03) // FILIAL
	cQuery +=  " SE1.E1_FILIAL >= '" + MV_PAR02 + "' AND "	
	cQuery +=  " SE1.E1_FILIAL <= '" + MV_PAR03 + "' AND "	  	
ENDIF   
/*
IF ! EMPTY(MV_PAR04) .OR. !EMPTY(MV_PAR05)
	cQuery +=  " SE1.E1_PEDIDO = SC5.C5_NUM AND "
	cQuery +=  " SC5.C5_DIVNEG >= '" + MV_PAR04 + "' AND "	
	cQuery +=  " SC5.C5_DIVNEG <= '" + MV_PAR05 + "' AND "		
	cQuery +=  " SC5.D_E_L_E_T_ = ' ' AND "
ENDIF
*/
Return