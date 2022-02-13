#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATR002  บ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  13/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para impressao de etiqueta em impressora termica. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FATR002()

Local aSay     := {}
Local aButton  := {}
Local nOpc     := 0
Local cTitulo  := "Etiqueta Termica"
Local cDesc1   := "Este programa tem como objetivo imprimir a etiqueta termica para embalagem."
Local cDesc2   := ""
Local cDesc3   := ""
Local cDesc4   := ""

Private cPerg  := "FATR02"


u_GerA0003(ProcName())

ValidPerg()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T.)      }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()   }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()              }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
EndIf

ImpEtiq()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpEtiq()

Local nX
Local _cQuery := ""

If mv_par08 = 2  // Nao aglutina
	_cQuery += " SELECT DISTINCT D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_DOC, D2_SERIE, D2_ITEM, D2_PEDIDO, C5_CLIENT, C5_LOJAENT, D2_NUMSERI, "
Else
	_cQuery += " SELECT DISTINCT D2_FILIAL, D2_CLIENTE, D2_LOJA, C5_CLIENT, C5_LOJAENT, D2_DOC, D2_SERIE, "
EndIf   
_cQuery += "        'TIPO'    	= C5_TIPO,    "
_cQuery += "        'NOMENT' 	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_NOME    ELSE A1ENT.A1_NOME    	END, "
_cQuery += "        'ENDENT' 	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_ENDENT  ELSE A1ENT.A1_ENDENT  	END, "
_cQuery += "        'BAIENT' 	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_BAIRROE ELSE A1ENT.A1_BAIRROE 	END, "
_cQuery += "        'CEPENT' 	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_CEPE    ELSE A1ENT.A1_CEPE    	END, "
_cQuery += "        'MUNENT' 	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_MUNE    ELSE A1ENT.A1_MUNE    	END, "
_cQuery += "        'ESTENT' 	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_ESTE    ELSE A1ENT.A1_ESTE    	END, "
_cQuery += "        'NOMENT1'	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_NOME    ELSE A2ENT.A2_NOME		END, "
_cQuery += "        'ENDENT1'	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_ENDENT  ELSE A2ENT.A2_END		END, "
_cQuery += "        'BAIENT1'	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_BAIRROE ELSE A2ENT.A2_BAIRRO	END, "
_cQuery += "        'CEPENT1'	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_CEPE    ELSE A2ENT.A2_CEP		END, "
_cQuery += "        'MUNENT1'	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_MUNE    ELSE A2ENT.A2_MUN		END, "
_cQuery += "        'ESTENT1'	= CASE WHEN C5_CLIENT = '' THEN A1FAT.A1_ESTE    ELSE A2ENT.A2_EST		END  "
_cQuery += " FROM   "+RetSqlName("SD2")+" AS D2 (nolock) "
_cQuery += " JOIN   "+RetSqlName("SC5")+" AS C5 (nolock) "
_cQuery += " ON     C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_  = '' "
_cQuery += " JOIN   "+RetSqlName("SA1")+" AS A1FAT (nolock) "
_cQuery += " ON     A1FAT.A1_COD = D2_CLIENTE AND A1FAT.D_E_L_E_T_  = '' "
_cQuery += " LEFT OUTER JOIN "+RetSqlName("SA1")+" AS A1ENT (nolock) "
_cQuery += " ON     A1ENT.A1_COD = C5_CLIENT  AND A1ENT.A1_LOJA = C5_LOJAENT AND A1ENT.D_E_L_E_T_  = '' "
_cQuery += " LEFT OUTER JOIN "+RetSqlName("SA2")+" AS A2ENT (nolock) "
_cQuery += " ON     A2ENT.A2_COD = C5_CLIENT  AND A2ENT.A2_LOJA = C5_LOJAENT AND A2ENT.D_E_L_E_T_  = '' "
_cQuery += " WHERE  D2.D_E_L_E_T_  = '' "
_cQuery += "        AND D2_FILIAL  = '"+xFilial("SD2")+"' "
_cQuery += "        AND C5_FILIAL  = '"+xFilial("SC5")+"' "                                
_cQuery += "        AND D2_DOC     BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery += "        AND D2_SERIE   BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
_cQuery += "        AND D2_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' "
If mv_par08 = 2  // Nao aglutina
	_cQuery += " ORDER BY D2_DOC, D2_SERIE, D2_ITEM "
else
	_cQuery += " ORDER BY D2_DOC, D2_SERIE, NOMENT "
Endif

TcQuery _cQuery NEW ALIAS "TRC"

dbselectarea("TRC")

MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.)
_cChave := ""

while !TRC->(eof())                     
    
	MSCBBEGIN(mv_par07,6)
	
	If TRC->TIPO $ ("B#D")  // Verifica se o cliente ้ fornecedor - Alterado Paulo Francisco 19/08/10
		_cNome := oemtoansi(alltrim(TRC->NOMENT1))
		_cEnd1 := oemtoansi(alltrim(TRC->ENDENT1))
		_cCep  := iif(len(alltrim(TRC->CEPENT1)) == 8, Left(TRC->CEPENT1,5) + "-" + substr(TRC->CEPENT1,6,3), alltrim(TRC->CEPENT1))
		_cEnd2 := oemtoansi(alltrim(TRC->BAIENT1)) + " - " + oemtoansi(alltrim(TRC->MUNENT1)) + " - " + TRC->ESTENT1
	Else
		_cNome := oemtoansi(alltrim(TRC->NOMENT))
		_cEnd1 := oemtoansi(alltrim(TRC->ENDENT))
		_cCep  := iif(len(alltrim(TRC->CEPENT)) == 8, Left(TRC->CEPENT,5) + "-" + substr(TRC->CEPENT,6,3), alltrim(TRC->CEPENT))
		_cEnd2 := oemtoansi(alltrim(TRC->BAIENT)) + " - " + oemtoansi(alltrim(TRC->MUNENT)) + " - " + TRC->ESTENT
	EndIf
	
	
	MSCBSAY(005,003,_cNome					,"N","0","030,040") // Nome Cliente
	MSCBSAY(005,006,_cEnd1					,"N","0","030,040") // Endereco Entrega
	MSCBSAY(005,009,_cEnd2					,"N","0","030,040") // Endereco Entrega
	MSCBSAY(005,012,"CEP " + _cCep 			,"N","0","030,040") // CEP 
	_cDoc := TRC->D2_DOC + iif(!empty(TRC->D2_SERIE), "-" + alltrim(TRC->D2_SERIE), "")
	MSCBSAY(045,012,"NF. " + _cDoc		,"N","0","030,040") // Numero-Serie Nota Fiscal
	if mv_par08 == 2  // Nao aglutina
		MSCBSAYBAR(005,015,alltrim(TRC->D2_NUMSERI),"N","MB07",2.5,.F.,.F.,.F.,,2,1) // Codigo de Barras do IMEI
		_cChave := TRC->D2_DOC + TRC->D2_SERIE
	endif

	TRC->(dbSkip())

	// Caso seja mesma NF, imprime o segundo IMEI da etiqueta
	if !TRC->(eof()) .and. mv_par08 == 2 .and. _cChave == TRC->D2_DOC + TRC->D2_SERIE
		MSCBSAYBAR(045,015,alltrim(TRC->D2_NUMSERI),"N","MB07",2.5,.F.,.F.,.F.,,2,1) // Codigo de Barras do IMEI
		TRC->(dbSkip())
	endif
 
	// Finaliza etiqueta
	MSCBEND()

enddo

MSCBCLOSEPRINTER()

TRC->(dbCloseArea())

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Da Nota Fiscal"       ,"Da Nota Fiscal"       ,"Da Nota Fiscal"      ,"mv_ch1","C",09,0,0,"G","","SF2" ,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Ate a Nota Fiscal"    ,"Ate a Nota Fiscal"    ,"Ate a Nota Fiscal"   ,"mv_ch2","C",09,0,0,"G","","SF2" ,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Da Serie"             ,"Da Serie"             ,"Da Serie"            ,"mv_ch3","C",03,0,0,"G","",""	  ,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Ate a Serie"          ,"Ate a Serie"          ,"Ate a Serie"         ,"mv_ch4","C",03,0,0,"G","",""	  ,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Da Emissao"           ,"Da Emissao"           ,"Da Emissao"          ,"mv_ch5","D",08,0,0,"G","",""	  ,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Ate a Emissao"        ,"Ate a Emissao"        ,"Ate a Emissao"       ,"mv_ch6","D",08,0,0,"G","",""	  ,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Quant. Etiquetas NF"  ,"Quant. Etiquetas NF"  ,"Quant. Etiquetas NF" ,"mv_ch7","N",02,0,0,"C","",""	  ,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Etiqueta Aglutinada"  ,"Etiqueta Aglutinada"  ,"Etiqueta Aglutinada" ,"mv_ch8","C",01,0,0,"C","",""    ,"",,"mv_par08","Sim","","","","Nใo","","","","","","","","","","","")

Return Nil