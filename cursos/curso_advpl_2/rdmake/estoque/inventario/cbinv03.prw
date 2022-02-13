#Include "Protheus.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBINV03   บAutor  ณDelta Decisao DF    บ Data ณ  05/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para o inventario rotativo, lista os enderecos      บฑฑ
ฑฑบ          ณ a serem inventariados dos produtos                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CBINVROT(aTemp)

Local aCab,aSize,aSave := VTSAVE()
//Local aTemp			   := {}
Local cAmz 			   := CBA->CBA_LOCAL
Local aCab  		   := {"Endereco"} //Endereco
Local aSize 		   := {30}

Local cQuery:=""
                                                   
cQuery := "SELECT BF_LOCALIZ "
cQuery += "FROM "+RetSqlName("SBF")+" SBF "
cQuery += "WHERE SBF.BF_FILIAL = '"+xFilial("SBF")+"' AND "
cQuery += "BF_LOCAL = '"+CBA->CBA_LOCAL+"' AND BF_PRODUTO = '"+CBA->CBA_PROD+"' AND "
cQuery += "BF_QUANT <> 0  AND "
cQuery += "NOT EXISTS (SELECT 1 FROM "+RetSqlName("CBC")+" CBC  WHERE CBC_COD=BF_PRODUTO AND CBC_LOCALI=BF_LOCALIZ AND CBC_LOCAL=BF_LOCAL " 
                           
VTClear()
VTClearBuffer() 

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCondicao para nใo mostrar 2x a tela de enderecos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ValType(cArmazem) == "U"

	VTClear()
	VTClearBuffer()
	VtRestore(,,,,aSave)

	Return cAmz

EndIf
*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz filtro para verificar os armazens disponiveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery += "AND CBC_FILIAL='"+xFilial("CBC")+"' AND CBC.D_E_L_E_T_=' ' AND CBC_CODINV='"+cCodInv+"' AND CBC_QTDORI <> 0) "
cQuery += " ORDER BY BF_LOCALIZ "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL",.T.,.T.)

dbSelectArea("TSQL")
TSQL->(dbGotop())

While TSQL->(!Eof())
	
	AADD(aTemp, { TSQL->BF_LOCALIZ } )
	
	TSQL->(dbSkip())
	
EndDo

TSQL->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta Browse para selecao dos enderecos 			ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aTemp) > 0
//	nPosicao := VTaBrowse(0,0,7,19,aCab,aTemp,aSize,,1)
//	cEndereco := aTemp[nPosicao][1]
Else
	cEndereco:= Space(TamSx3("BF_LOCALIZ")[1])
EndIf
	
VTClear()
VTClearBuffer()
VtRestore(,,,,aSave)

Return cAmz