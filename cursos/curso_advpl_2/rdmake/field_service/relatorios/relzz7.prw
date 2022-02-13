#include 'rwmake.ch'
#include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ                           
ฑฑบPrograma  ณ ZZ7      บAutor  ณLuiz Ferreira       บ Data ณ  22/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio ZZ7 - Pecas Faltantes                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                      
User Function RELZZ7() 
	Processa( { || relizz7() } ) 
Return .t.

Static Function relizz7()
Local cQry1    :=""
Local _cQuery1 :=""
Local _cDir    := __RelDir
Local cCrLf    := Chr(13)+Chr(10)
Local cArquivo :=CriaTrab(,.F.)  
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
Local cPath    := AllTrim(GetTempPath())
Local _cpartnr :="" 
Local _cpartfn :=""
Local _cmodelo :=""
Local _cpartnew:=""
Local _cquantnr:=""
Local _nTotOs  := 0

PRIVATE cPerg  :="PERGZ7"   
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))    

u_GerA0003(ProcName())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Cria dicionario de perguntas  - Alterado Paulo Francisco - 18/05/10  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)     
	Return
Endif

//dbSelectArea(_sAlias)

if MV_PAR06 == 1
	nHandle := MsfCreate(_cDir+"\"+cArquivo+".CSV",0)
else
	nHandle := MsfCreate(_cDir+"\"+cArquivo+".xls",0)
	clinha := '<html>' + cCRLF 
	clinha += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252">' + cCRLF 
	clinha += '<body>' + cCRLF 
	fWrite(nHandle, cLinha) 


	clinha :=  "<table border=1>"
	fWrite(nHandle, cLinha + cCrLf)
endif

   
if MV_PAR06 == 1
	if ALLTRIM(MV_PAR03) = "1"
	     cLinha := "IMEI;OS;PARTN_BGH;PARTN_FORN;PARTN_NOVO;QTDADE;DATA;TECNICO;FASE;SETOR"
	Else  
	     cLinha := "IMEI;OS;PARTN_BGH;PARTN_NOVO;MODELO;QTDADE;DATA;TECNICO;FASE;SETOR"
	Endif
	fWrite(nHandle, cLinha  + cCrLf)
endif

IF Select("QRY1") <> 0 
DbSelectArea("QRY1")
DbCloseArea()
Endif
//
DBSELECTAREA ("ZZ3")
DBSETORDER (1)
DBSELECTAREA ("ZZ7")
DBSETORDER (1)                    
DBSELECTAREA ("SB1")
DBSETORDER (1)  
DBSELECTAREA ("ZZ4")
DBSETORDER (1)


if MV_PAR06 == 1
	_cQuery1 := " SELECT ZZ3.ZZ3_IMEI 'IMEI' ,ZZ3.ZZ3_NUMOS 'OS',ZZ3.ZZ3_DATA 'DATA' , ZZ3.ZZ3_SEQ 'SEQ', ZZ3.ZZ3_CODTEC 'TEC',ZZ3.ZZ3_FASE1 'FASE', ZZ3.ZZ3_CODSET 'SETOR' "
	_cQuery1 += " FROM " +Retsqlname ("ZZ3") + " ZZ3 (NOLOCK) "
	_cQuery1 += " WHERE ZZ3.ZZ3_DATA BETWEEN '" +dtos(MV_PAR01)+ "' AND '" +dtos(MV_PAR02)+ "' "
	_cQuery1 += "  AND ZZ3.ZZ3_FASE2   ='"+MV_PAR04+"'  "    
	_cQuery1 += "  AND ZZ3.ZZ3_CODSE2   ='"+MV_PAR05+"'  "  
	_cQuery1 += "  AND ZZ3.ZZ3_FILIAL  ='"+xfilial("ZZ3")+"' "  
	_cQuery1 += "  AND ZZ3.ZZ3_LAB     ='"+ALLTRIM(MV_PAR03)+"'  "  
	_cQuery1 += "  AND ZZ3.ZZ3_STATUS  ='1'  "
	_cQuery1 += "  AND ZZ3.D_E_L_E_T_  =''   "

	_cQuery := CHANGEQUERY(_cQuery1)
	TcQuery _cQuery1 ALIAS "QRY1" NEW
	TcSetField("QRY1","DATA","D")     //TRANFORMACAO DAS DATAS
else
	_cQuery1 := " SELECT DISTINCT ZZ3.ZZ3_IMEI 'IMEI' ,ZZ3.ZZ3_NUMOS 'OS'"
	_cQuery1 += " FROM " +Retsqlname ("ZZ3") + " ZZ3 (NOLOCK) "
	_cQuery1 += " WHERE ZZ3.ZZ3_DATA BETWEEN '" +dtos(MV_PAR01)+ "' AND '" +dtos(MV_PAR02)+ "' "
	_cQuery1 += "  AND ZZ3.ZZ3_FASE2   ='"+MV_PAR04+"'  "    
	_cQuery1 += "  AND ZZ3.ZZ3_CODSE2   ='"+MV_PAR05+"'  "  
	_cQuery1 += "  AND ZZ3.ZZ3_FILIAL  ='"+xfilial("ZZ3")+"' "  
	_cQuery1 += "  AND ZZ3.ZZ3_LAB     ='"+ALLTRIM(MV_PAR03)+"'  "  
	_cQuery1 += "  AND ZZ3.ZZ3_STATUS  ='1'  "
	_cQuery1 += "  AND ZZ3.D_E_L_E_T_  =''   "

	_cQuery := CHANGEQUERY(_cQuery1)
	TcQuery _cQuery1 ALIAS "QRY1" NEW
endif
	
clinha 	:= ""         
_nTot	:= 0
procregua(reccount())
	
	DO WHILE !QRY1->(EOF())  

		if MV_PAR06 == 1

			   if ZZ3->(dbseek(xFilial("ZZ3") + QRY1->IMEI + QRY1->OS + QRY1->SEQ)) //ZZ7.ZZ7_IMEI .and. ZZ7.ZZ7_NUMOS .and. ZZ7.ZZ7_SEQ
					lOK = .T.
					DO WHILE !ZZ3->(EOF()) .and. ZZ3->ZZ3_IMEI == QRY1->IMEI .and. ZZ3->ZZ3_NUMOS == QRY1->OS  
				       //	if(ZZ3->ZZ3_IMEI == QRY1->IMEI .and. ZZ3->ZZ3_NUMOS == QRY1->OS .and. (ZZ3->ZZ3_ENCOS == 'S' .or. (ZZ3->ZZ3_FASE2 <> MV_PAR04 .or. ZZ3->ZZ3_CODSE2 <> MV_PAR05)  .and. (ZZ3->ZZ3_ESTORN <> 'S' ))) 
				            if(ZZ3->ZZ3_ESTORN <> 'S' .and. (Alltrim(ZZ3->ZZ3_FASE2) <> Alltrim(MV_PAR04) .or. Alltrim(ZZ3->ZZ3_CODSE2) <> Alltrim(MV_PAR05)  .or. Alltrim(ZZ3->ZZ3_ENCOS) == 'S'))       //alterado por Rodrigo Salomใo 06/12/2012 chamado ID 9080
				           	lOK = .F. //verifica se encontra na ZZ3 o ZZ3_ENCOS = S
							exit                                                                  
				        endif             
						ZZ3->(dbskip())                         
					Enddo
			 		If lOK = .T.   
					    	dbselectarea("ZZ7")
					 	  	dbsetorder(3) //ZZ7.ZZ7_IMEI .and. ZZ7.ZZ7_NUMOS .and. ZZ7.ZZ7_SEQ
			        		if (dbseek(xFilial("ZZ7") + QRY1->IMEI + QRY1->OS + QRY1->SEQ))
						       		DO WHILE ZZ7->(!eof()) .and. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .and. ZZ7->ZZ7_IMEI == QRY1->IMEI ;
						                              .and. left(ZZ7->ZZ7_NUMOS,6) == left(QRY1->OS,6) .and. ZZ7->ZZ7_SEQ = QRY1->SEQ  ;
				     		                          .and. ZZ7->ZZ7_DATA  >= MV_PAR01 .and. ZZ7->ZZ7_DATA <= MV_PAR02 //;
					     	                         // .and. ZZ7->ZZ7_LOCAL == MV_PAR03 
					     	                                                                       	
									        _cpartnr  := ZZ7->ZZ7_PARTNR
									        _cquantnr := ZZ7->ZZ7_QTY      
									        
									        DBSELECTAREA ("SB1")
				                            IF SB1->(DBSeek(xFilial('SB1')+ZZ7->ZZ7_PARTNR))
									           _cpartfn  := SB1->B1_XCODFAB
									        ELSE   
									          dbsetorder(9)                                 
									          IF SB1->(DBSeek(xFilial('SB1')+ZZ7->ZZ7_PARTNR))
									            _cpartfn  := SB1->B1_XCODFAB
									          ENDIF
									        ENDIF   
									        DBSELECTAREA ("ZZ7")
									        
									        _cmodelo  := POSICIONE("ZZ4",1,XFILIAL("ZZ4")+ZZ7->ZZ7_IMEI+left(ZZ7->ZZ7_NUMOS,6),"ZZ4_CODPRO" ) 
									        _cpartnew := ZZ7->ZZ7_PECNEW                                                                      
									        
									        
								           if ALLTRIM(MV_PAR03) = "1"                                      
											clinha :=  QRY1->IMEI+";"+QRY1->OS+";"+_cpartnr+";"+_cpartfn+";"+_cpartnew+";"+transform(_cquantnr ,"@E 9,999,999.999")+";"+dtoc(ZZ7->ZZ7_DATA)+";"+QRY1->TEC+";"+QRY1->FASE+";"+QRY1->SETOR
										   Else
										    clinha :=  QRY1->IMEI+";"+QRY1->OS+";"+_cpartnr+";"+_cpartnew+";"+_cmodelo+";"+transform(_cquantnr ,"@E 9,999,999.999")+";"+dtoc(ZZ7->ZZ7_DATA)+";"+QRY1->TEC+";"+QRY1->FASE+";"+QRY1->SETOR
										   Endif	
		
											fWrite(nHandle, cLinha + cCrLf)
						         			ZZ7->(dbskip())
					            	Enddo  
				      		endif
			     	Endif 
				endif
		
		else
			                                                                  
				_nTot1 := 0
			   if ZZ3->(dbseek(xFilial("ZZ3") + QRY1->IMEI + QRY1->OS))
					lOK = .T.
					DO WHILE !ZZ3->(EOF()) .and. ZZ3->ZZ3_IMEI == QRY1->IMEI .and. ZZ3->ZZ3_NUMOS == QRY1->OS  
				    	if(ZZ3->ZZ3_IMEI == QRY1->IMEI .and. ZZ3->ZZ3_NUMOS == QRY1->OS .and. (ZZ3->ZZ3_ENCOS == 'S' .or. (ZZ3->ZZ3_FASE2 <> MV_PAR04 .and. ZZ3->ZZ3_CODSE2 <> MV_PAR05)  .and. (ZZ3->ZZ3_ESTORN <> 'S' ))) 
			               	lOK = .F. //verifica se encontra na ZZ3 o ZZ3_ENCOS = S
							exit                                                                  
				        endif             
						ZZ3->(dbskip())                         
					Enddo
			 		If lOK = .T.   
					    	dbselectarea("ZZ7")
					 	  	dbsetorder(3) //ZZ7.ZZ7_IMEI .and. ZZ7.ZZ7_NUMOS .and. ZZ7.ZZ7_SEQ
			        		if (dbseek(xFilial("ZZ7") + QRY1->IMEI + QRY1->OS))
					      		
									_cQuery := "select B1_DESC "
									_cQuery += "from ZZ4020 AS ZZ4 "
									_cQuery += "inner join SB1020 AS SB1 ON B1_COD = ZZ4_CODPRO and SB1.D_E_L_E_T_ <> '*' "
									_cQuery += "where ZZ4.ZZ4_OS = '" + QRY1->OS + "' and ZZ4.D_E_L_E_T_ <> '*' "
									TCQUERY _cQuery NEW ALIAS "QRY0"  
									_cdesc	:= QRY0->B1_DESC
									QRY0->(dbCloseArea())
									
									_nTotOs ++
									
									clinha +=  "<tr>"
									clinha +=  "	<td>" + QRY1->IMEI+ "</td>"
									clinha +=  "	<td>" + QRY1->OS + "</td>"
									clinha +=  "	<td>" + _cdesc + "</td>"
									
					      		
						       		DO WHILE ZZ7->(!eof()) .and. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .and. ZZ7->ZZ7_IMEI == QRY1->IMEI ;
						                              .and. left(ZZ7->ZZ7_NUMOS,6) == left(QRY1->OS,6)
					     	                                                                       	
									        _cpartnr  := ZZ7->ZZ7_PARTNR
									        _cquantnr := ZZ7->ZZ7_QTY      
									        
									        DBSELECTAREA ("SB1")
				                            IF SB1->(DBSeek(xFilial('SB1')+ZZ7->ZZ7_PARTNR))
									           _cpartfn  := SB1->B1_XCODFAB
									        ELSE   
									          dbsetorder(9)                                 
									          IF SB1->(DBSeek(xFilial('SB1')+ZZ7->ZZ7_PARTNR))
									            _cpartfn  := SB1->B1_XCODFAB
									          ENDIF
									        ENDIF   
									        DBSELECTAREA ("ZZ7")
									        
									        _cmodelo  := POSICIONE("ZZ4",1,XFILIAL("ZZ4")+ZZ7->ZZ7_IMEI+left(ZZ7->ZZ7_NUMOS,6),"ZZ4_CODPRO" ) 
									        _cpartnew := ZZ7->ZZ7_PECNEW                                                                      
									        
									        _nTot1++
									        
								           	if ALLTRIM(MV_PAR03) == "1"                                      
												clinha +=  "	<td>" + _cpartnr + "</td>"
												clinha +=  "	<td>" + _cpartfn + "</td>" 
												clinha +=  "	<td>" + _cpartnew + "</td>"
										   	Else
												clinha +=  "	<td>" + _cpartnr + "</td>"
												clinha +=  "	<td>" + _cpartnew + "</td>"
										   	Endif	
											clinha +=  "		<td>" + transform(_cquantnr ,"@E 9,999,999.999") + "</td>"
		
						         			ZZ7->(dbskip())
					            	Enddo  
					      		
									clinha +=  "</td>"
				      		endif
			     	Endif 
				endif
				if _nTot < _nTot1
					_nTot := _nTot1
				endif
		endif                               
		
		QRY1->(dbskip())
		IncProc()
	Enddo                  
	if MV_PAR06 == 2 
	
		clinha +=  "<tr>"
		clinha +=  "	<td><b>TOTAL DE OSดs</td>"
		clinha +=  "	<td><b>" + transform(_nTotOs ,"@E 9,999,999") + "</td>" 
		clinha +=  "</tr>"		
		clinha +=  "</table>"
		
		cTitulo := "<tr>"
		ctitulo += "	<td><b> IMEI </td>"
		ctitulo += "	<td><b> OS </td>"
		ctitulo += "	<td><b> Descri็ใo </td>"

		for xc:=1 to _ntot
			ctitulo += "<td colspan='3' align='center'><b>  Pe็a Faltante " + str(xc) + "</td>"
		next xc
		cTitulo += "</tr>"
		
		cTitulo += "<tr>"
		ctitulo += "	<td colspan='3'> </td>"

		for xc:=1 to _ntot
			ctitulo += "<td><b>  Partnumber BGH </td>"
			ctitulo += "<td><b>  Partnumber Novo </td>"
			ctitulo += "<td><b>  Quantidade </td>"
		next xc
		cTitulo += "</tr>"
		
		fWrite(nHandle, cTitulo + cCrLf)
		fWrite(nHandle, cLinha + cCrLf)
   	endif

   fClose(nHandle)
//CpyS2T( _cDir+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 -- 

If ! ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
   //	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 -- 
	if MV_PAR06 == 1
		oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) // Abre uma planilha 	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	else
		oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".xls" ) // Abre uma planilha 	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	endif
	oExcelApp:SetVisible(.T.)
EndIf
                                	
return()
 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณPaulo Lopez         บ Data ณ  18/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERA DICIONARIO DE PERGUNTAS                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fCriaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Considere Data De    	?","","","mv_ch1","D",08,0,0,"G","","" ,"","","mv_par01",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","At้ a Data:        		?","","","mv_ch2","D",08,0,0,"G","","" ,"","","mv_par02",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
//PutSX1(cPerg,"03","Laboratorio       		?","","","mv_ch3","C",01,0,1,"G","","" ,"","","mv_par03","1-SONY"	,"","","","","2-Nextel"	,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Laboratorio ?","Laboratorio ?","Laboratorio ?",'mv_ch3',"C",6,0,0,"G","","LB","","S","mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Fase Aguardando Peca		?","","","mv_ch4","C",02,0,0,"G","","" ,"","","mv_par04",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Setor Aguardando Peca	?","","","mv_ch5","C",06,0,0,"G","","" ,"","","mv_par05",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Tipo de Relatorio        ?","","","mv_ch6","N",01,0,0,"C","",""	,"",,"mv_par06","Normal","","","","Resumido"	,"","",""	,"","","","","","","","")
  
cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe Data Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe Data Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe Laboratorio.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "04."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Fase que esta Aguardando a Pe็a.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "05."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Setor que esta Aguardando a Pe็a.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "06."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o tipo de relat๓rio que sera gerado.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return