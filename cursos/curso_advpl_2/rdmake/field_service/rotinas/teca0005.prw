#Include "Protheus.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TecA0005 บAutor  ณ D.FERNANDES        บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para gerar pedido de venda conforme retorno 		  บฑฑ
ฑฑบ          ณ do relat๓rio MCLAIN                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH - MOTOROLA                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TecA0005()

Local cPerg   := PADR("TECA000005",10)
Local aBrowse := {}

Private oMark   := Nil
Private aRotina := {}
                     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria as perguntas 				 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return
EndIf

aAdd( aRotina ,{"Gerar Pedido"      ,'u_TecM1005()',0,3})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria arquivo temporario 			 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MsAguarde({ || CRIARQ() }, "Aguarde - Criando arquivo temporario . . . ")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBrowse do saldo dos fornecedores  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aBrowse,{"Os","ZR_OS", "C", TamSx3("ZR_OS")[1], 0, "@!"})
AADD(aBrowse,{"Modelo","ZR_MODELO", "C", TamSx3("ZR_MODELO")[1], 0, "@!"} )
AADD(aBrowse,{"Cidade","ZR_CIDADE", "C", TamSx3("ZR_CIDADE")[1], 0, "@!" } )
AADD(aBrowse,{"Valor","ZR_TPRICE", "N", 14, 2, "@ 999,999,999.99" } )

oMark := FWMarkBrowse():New()
oMark:SetAlias("TMP")  
oMark:SetFields( aBrowse )
oMark:SetSemaphore(.F.)        // Define se utiliza marcacao exclusiva 
oMark:SetFieldMark("ZR_OK")    // Define o campo utilizado para a marcacao
//oMark:SetAfterMark({|| VLMARK() })
//oMark:SetAllMark({|| VLMARK() })

oMark:AddLegend( "ZR_STATUS=='A'" , "BR_VERDE" , "OS Aprovado")
oMark:AddLegend( "ZR_STATUS=='R'" , "BR_VERMELHO" , "OS Rejeitada")

oMark:Activate()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSX1   บAutor  ณD.FERNANDES         บ Data ณ  01/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para criar as perguntas                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Ano			    	?","","","mv_ch1","C",04,0,0,"G","","" ,"","","mv_par01",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Mes			    	?","","","mv_ch2","C",02,0,0,"G","","" ,"","","mv_par02",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Batch    	    	?","","","mv_ch3","C",01,0,0,"G","","" ,"","","mv_par03",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Status 				?","","","mv_ch4","N",01,0,0,"C","",""	,"",,"mv_par04","Aprovadas","","","","Rejeitadas"	,"","",""	,"","","","","","","","")
PutSX1(cPerg,"05","Cliente		    	?","","","mv_ch5","C",06,0,0,"G","","SA1" ,"","","mv_par05",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Loja			    	?","","","mv_ch6","C",02,0,0,"G","","" ,"","","mv_par06",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Cond. Pagto      	?","","","mv_ch7","C",03,0,0,"G","","SE4" ,"","","mv_par07",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Div. Negocio      	?","","","mv_ch8","C",02,0,0,"G","","ZM" ,"","","mv_par08",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRIARQ    บAutor  ณD.FERNANDES         บ Data ณ  01/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para criar arquivo temporario                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CRIARQ()

Local aTmp := { {"ZR_OK", "C", 02, 0},;
{"ZR_STATUS", "C", 01, 0},;
{"ZR_OS", "C", TamSx3("ZR_OS")[1], 0},;
{"ZR_MODELO", "C", TamSx3("ZR_MODELO")[1], 0},;
{"ZR_OSZZ4", "C", TamSx3("ZR_OSZZ4")[1], 0},;
{"ZR_CIDADE", "C", TamSx3("ZR_CIDADE")[1], 0},;
{"ZR_RECNO", "N", 10, 0},;
{"ZR_TPRICE", "N", 14, 2}}
Local cQuery := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria tabela temporariaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFileWork := CriaTrab(aTmp,.T.)
_cArqInd  := CriaTrab(,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o alias existe ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

dbUseArea( .T.,__LocalDriver, cFileWork, "TMP", .T., .F. )
IndRegua("TMP",_cArqInd,"ZR_OS+ZR_MODELO",,,)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFiltra dados SZR		 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT  "
cQuery += " 		ZR_CODIGO, "
cQuery += " 		ZR_STATUS ZRSTATUS, "
cQuery += " 		ZR_OS, "
cQuery += " 		ZR_MODELO, "
cQuery += " 		ZR_OSZZ4, "
cQuery += " 		ZR_CIDADE, "   
cQuery += " 		ZR_TPRICE, "   
cQuery += " 		R_E_C_N_O_ AS ZRRECNO "
cQuery += " FROM "+RetSqlName("SZR")+"  "
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND ZR_PEDIDO = '' "
cQuery += " AND ZR_ANOMCL = '"+MV_PAR01+"' "
cQuery += " AND ZR_MESMCL = '"+MV_PAR02+"' "
cQuery += " AND ZR_FILIAL = '"+xFilial("SZR")+"' "

If MV_PAR04 == 1 //Aprovadas
	cQuery += " AND ZR_STATUS = 'A' "
Else//Rejeitadas
	cQuery += " AND ZR_STATUS = 'R' "
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o alias existe ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TSQL") > 0
	TSQL->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL",.T.,.T.)

dbSelectArea("TSQL")
TSQL->(dbGotop())

dbSelectArea("ZZ4")
dbSetOrder(11)

While TSQL->(!Eof())
	                   		
	dbSelectArea("TSQL")
		
	TMP->(RecLock("TMP",.T.))
	TMP->ZR_OK     := Space(2)
	TMP->ZR_STATUS := TSQL->ZRSTATUS
	TMP->ZR_OS	   := TSQL->ZR_OS
	TMP->ZR_MODELO := TSQL->ZR_MODELO
	TMP->ZR_OSZZ4  := TSQL->ZR_OSZZ4
	TMP->ZR_CIDADE := TSQL->ZR_CIDADE
	TMP->ZR_TPRICE := TSQL->ZR_TPRICE
	TMP->ZR_RECNO  := TSQL->ZRRECNO
	TMP->(MsUnLock())
	
	TSQL->(dbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFinaliza area 			  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TSQL->(dbCloseArea())

dbSelectArea("TMP")
TMP->(dbGotop())

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VLMARK   บAutor  ณ D.FERNANDES        บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validacao na marca็ใo dos itens 		 		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH - MOTOROLA                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VLMARK()

If Alltrim(TMP->ZR_STATUS) <> "A"
	TMP->(RecLock("TMP",.F.))
	TMP->ZR_OK := Space(2)
	TMP->(MsUnLock())
Else
	TMP->(RecLock("TMP",.F.))
	TMP->ZR_OK := GetMark()
	TMP->(MsUnLock())		
EndIf	
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTecM1005  บAutor  ณD.FERNANDES         บ Data ณ  01/16/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para gerar os pedido de venda referente   	      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TecM1005()

Local oBar			:= Nil
Local aBtn 	    	:= Array(10)
Local _cCliente  	:= MV_PAR05
Local _cLoja 	    := MV_PAR06
Local _cNome 	    := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_NOME")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de cVariable dos componentesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private _cMarca		:= GetMark()
Private nOpc		:= 2
Private aObjects    := {},aPosObj  :={}
Private aSize       := MsAdvSize()
Private aHeader     := {}
Private aCols       := {}
Private aIteMod     := {}

//Montando tela do Fluxo de Equipamentos
aObjects	:= {}
aAdd( aObjects, {100,090, .t., .F.})
aAdd( aObjects, {100,100, .t., .T.})
aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj		:= MsObjSize( ainfo, aObjects )

//Ajustando tela as dimen็๕es do Munitor configurado
oDlgPed	:= MSDialog():New( 000,000,aSize[6],aSize[5],"Faturamento MCLAIN",,,.F.,,,,,,.T.,,,.T. )
oDlgPed:lMaximized := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta os Botoes da Barra Superior.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE BUTTONBAR oBar SIZE 25,25 3D OF oDlgPed

DEFINE BUTTON aBtn[01] RESOURCE "pedido"		When .T. OF oBar TOOLTIP "Confirma Pedido"						ACTION Processa({|| TecM2005(_cCliente, _cLoja) })
aBtn[01]:cTitle := ""

DEFINE BUTTON aBtn[10] RESOURCE "FINAL_MDI" 	When .T. OF oBar TOOLTIP "Sair"		   							ACTION oDlgPed:End()
aBtn[10]:cTitle := ""

oGrp1       := TGroup():New( aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],"Pedidos Gerados",oDlgPed,CLR_BLACK,CLR_WHITE,.T.,.F. )

oGrp2       := TGroup():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]+10,aPosObj[2,4],"Itens do Pedido",oDlgPed,CLR_BLACK,CLR_WHITE,.T.,.F. )
oFld1       := TFolder():New( aPosObj[2,1]+10,aPosObj[2,2]+5,{"Faturamento MCLAIN"},{},oGrp2,,,,.T.,.F.,aPosObj[2,4]-15,(aPosObj[2,3]-aPosObj[2,1])-20,)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o aHeader com base no SX3 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("SC6"))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SC6"
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT <> "V"
		Aadd(aHeader,{AllTrim(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		SX3->X3_VISUAL,;
		SX3->X3_VLDUSER	,;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT})
	EndIf
	
	SX3->(dbSkip())
EndDo

_nCol := 8
@ aPosObj[1,1]+8 ,_nCol      SAY "Cliente" 	OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
@ aPosObj[1,1]+8 ,_nCol+=045 SAY "Loja" 	OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
@ aPosObj[1,1]+8 ,_nCol+=105 SAY "Nome" 	OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL

_nCol := 8
@ aPosObj[1,1]+16,_nCol		 MSGET oCliente  VAR _cCliente   SIZE 040,07 OF oGrp1 PIXEL WHEN .F.
@ aPosObj[1,1]+16,_nCol+=045 MSGET oLoja VAR _cLoja 		 SIZE 100,07 OF oGrp1 PIXEL WHEN .F.
@ aPosObj[1,1]+16,_nCol+=105 MSGET oNome VAR _cNome 		 SIZE 100,07 OF oGrp1 PIXEL WHEN .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ<ฟ
//ณAlimenta acols com os dados da tabela temporariaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ<ู        
aTotais := {}

dbSelectArea("TMP") 
TMP->(dbGotop())

While TMP->(!Eof())
	
	If !oMark:IsMark(TMP->ZR_OK)
	           
		//Calcula por modelo
		/*nPosItem  := aScan(aTotais,{|x| x[1] == TMP->ZR_MODELO })
		If nPosItem > 0
			aTotais[nPosItem][2]++
		Else	
			AADD(aTotais,{ TMP->ZR_MODELO, 1, TMP->ZR_TPRICE} )
		EndIf*/
		
		If Len(aTotais) == 0
			AADD(aTotais,{ TMP->ZR_MODELO, TMP->ZR_TPRICE} )
		Else	
        	aTotais[1][2]+=TMP->ZR_TPRICE        	
		EndIf
	
	EndIf
	
	TMP->(dbSkip())	     
EndDo

//Verifica os valores de debito 
If Len(aTotais) > 0 
	//Busca o valor do debita se jแ digitado
	dbSelectArea("SZR")
	dbSetOrder(5)
	
	If MsSeek(xFilial("SZR")+MV_PAR01+MV_PAR02+"D")
		aTotais[1][2] -= SZR->ZR_DEBITO
	EndIf	
EndIf

//Busca posi็๕es dos campos para monta rotina automatica
nPosITE := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM" })
nPosPRD := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO" })
nPosDES := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_DESCRI" })
nPosUN  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_UM" })
nPosQTD := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN" })
nPosPRC := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRCVEN" })
nPosTOT := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_VALOR" })
nPosTES := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_TES" })
nPosLOC := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_LOCAL" })
nPosMOD := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_AEXPGVS" })

cItem   := StrZero(0,TamSx3("C6_ITEM")[1])    
cProduto := PADR(GetNewPar("MV_XFATSER","800071"),TamSx3("B1_COD")[1])

For nX := 1 To Len(aTotais) 

	AAdd(aCols, Array(Len(aHeader)+1))	
	cItem  := Soma1(cItem)	
	nLinha := Len(aCols)          
	
	For nY := 1 To Len(aHeader)                    
		If !Alltrim(aHeader[nY][2]) $ "C6_ITEM/C6_PRODUTO/C6_DESCRI/C6_UM/C6_QTDVEN/C6_PRCVEN/C6_VALOR/C6_TES/C6_LOCAL"
			aCols[nLinha][nY] := CriaVar(aHeader[nY][2])
		EndIf
	Next nY

	nPos := aScan(aIteMod,{|x| x[1]+x[2] == aTotais[nX][1]+cItem })
	If 	nPos == 0
		AADD( aIteMod,{ aTotais[nX][1], cItem })
	EndIf

	aCols[nLinha][nPosITE] := cItem
	aCols[nLinha][nPosPRD] := cProduto
	aCols[nLinha][nPosDES] := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")
	aCols[nLinha][nPosUN]  := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_UM")
	aCols[nLinha][nPosQTD] := 1
	aCols[nLinha][nPosPRC] := aTotais[nX][2]
	aCols[nLinha][nPosTOT] := aTotais[nX][2]
	aCols[nLinha][nPosMOD] := "MOD:"+aTotais[nX][1]
	aCols[nLinha][nPosTES] := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_TS")
	aCols[nLinha][nPosLOC] := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_LOCPAD")
		
	aCols[nLinha][Len(aHeader)+1] := .F.
	
Next nX
                               
oGetItens   := MsNewGetDados():New(3,3,(oFld1:aDialogs[1]:nClientHeight/2)-3,oFld1:aDialogs[1]:nClientWidth/2-3,0,/*"u_CVALC03L()"*/,,/*"+PZC_SEQ"*/,,1,9999,,,,oFld1:aDialogs[1],aHeader,aCols,/*{|| VerMemo() }*/)

oDlgPed:Activate(,,,)

TMP->(dbGotop())

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTecM2005  บAutor  ณD.FERNANDES         บ Data ณ  01/30/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para executar a gera็ใo do pedido de venda          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TecM2005(_cCliente, _cLoja)

Local aitem := {}

//Transaction para defini็ใo do MCLAIN                                      
//ZR_TRANS IN ( 'IFV', 'IPF')
                        
If TMP->ZR_STATUS == "R"//Rejeitados
	Alert("Nใo ้ possํvel gerar pedido de itens rejeitados")
	Return
EndIf

dbSelectArea("SA1")                              
dbSetOrder(1)
MsSeek(xFilial("SA1")+_cCliente+_cLoja)

aCabPV:={    {"C5_TIPO"   ,"N"        ,Nil},; // Tipo de pedido
		{"C5_CLIENTE",SA1->A1_COD     ,Nil},; // Codigo do cliente
		{"C5_LOJACLI",SA1->A1_LOJA    ,Nil},; // Loja do cliente
		{"C5_CONDPAG",MV_PAR07	  	  ,Nil},;
		{"C5_DIVNEG",MV_PAR08			  ,Nil}}

ProcRegua(Len(oGetItens:aCols))
	
For nInt := 1 To Len(oGetItens:aCols)     
	
		aItemPV:={{"C6_ITEM"   	,StrZero(nInt,TamSx3("C6_ITEM")[1])	 ,Nil},; 
		{"C6_PRODUTO"	,oGetItens:aCols[nInt][nPosPRD]   			 ,Nil},; 
		{"C6_QTDVEN" 	,oGetItens:aCols[nInt][nPosQTD]    		 	 ,Nil},; 
		{"C6_PRUNIT" 	,oGetItens:aCols[nInt][nPosPRC]  			 ,Nil},; 
		{"C6_PRCVEN" 	,oGetItens:aCols[nInt][nPosPRC] 			 ,Nil},; 
		{"C6_VALOR"  	,Round(oGetItens:aCols[nInt][nPosTOT],2)	 ,Nil},; 		
		{"C6_DESCRI" 	,oGetItens:aCols[nInt][nPosDES]		         ,Nil},;
		{"C6_TES" 		,oGetItens:aCols[nInt][nPosTES]		         ,Nil},;
		{"C6_LOCAL" 	,oGetItens:aCols[nInt][nPosLOC]		         ,Nil}} 
		
		aadd(aitem,aitempv)

Next nInt

LMSERROAUTO := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPV, aitem, 3)

If lMsErroAuto
	Mostraerro()
	RollBackSX8()
	MsgInfo("Ocorreu um erro na gera็ใo do PV, consulte o depto de TI.")
Else

	//Atualiza status da tabela do MCLAIN
	dbSelectArea("TMP")
	TMP->(dbGotop())
	
	ProcRegua(0)
	
	While TMP->(!Eof())
	  
		If !oMark:IsMark(TMP->ZR_OK)
			
			IncProc("Atualizando registros, aguarde...")
			
			dbSelectArea("SZR")
			dbGoto(TMP->ZR_RECNO)
			
			SZR->(RecLock("SZR",.F.))
			SZR->ZR_PEDIDO :=  SC5->C5_NUM
			SZR->(MsUnLock())  
			
			//Atualiza status da ZZ4 
			dbSelectArea("ZZ4")
			dbSetOrder(11)
			
			If MsSeek(xFilial("ZZ4")+SZR->ZR_OSZZ4)				           			
				
				nPos := aScan(aIteMod,{|x| x[1] == TMP->ZR_MODELO})
				
				ZZ4->(RecLock("ZZ4",.F.))
				If nPos > 0 
					//Grava o item do pedido na ZZ4
					ZZ4->ZZ4_PVSERV := SC5->C5_NUM+aIteMod[nPos][2]
				Else
					ZZ4->ZZ4_PVSERV := SC5->C5_NUM
				EndIf					
				ZZ4->(MsUnLock())				
			
			EndIf						
			
		EndIf
		
		TMP->(dbSkip())	
	EndDo              
	
	MsgInfo("Pedido gerado com sucesso: " + SC5->C5_NUM)	
EndIf 

oDlgPed:End()

Return