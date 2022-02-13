#include 'rwmake.ch'
#include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ                           
ฑฑบPrograma  ณ AB2      บAutor  ณLuiz Ferreira       บ Data ณ  02/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio AB2 - Mostra F4 por Produto - ESTOQUE            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                      
User Function RELAB2() 
	Processa( { || reliAB2() } ) 
Return .t.
Static Function reliAB2()
Local cQry1   :=""
Local _cQuery1 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

PRIVATE cPerg	 :="PERGB2"   
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))  

u_GerA0003(ProcName())


ValidPerg(cPerg) 
if ! Pergunte(cPerg,.T.)
 Return()
Endif 

//dbSelectArea(_sAlias)
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

   cLinha := "CODIGO;ARMZ;SALDO ATUAL;QTD RESERVA;QTD PEDIDO VENDA;QTD ACLASSI;QTD TER NS PD;QTD NS PD TER;QUANTIDADE DISPONIVEL"


fWrite(nHandle, cLinha  + cCrLf)

IF Select("QRY1") <> 0 
DbSelectArea("QRY1")
DbCloseArea()
Endif


//BUSCA TABELA COM DATAS

_cQuery1 := " SELECT B2_COD 'COD' ,B2_LOCAL 'ARMZ' "
_cQuery1 += "       ,B2_QATU 'SLDOATU',B2_RESERVA 'QTDRESER',B2_QPEDVEN 'QTPDVEND',B2_QACLASS 'QTACLAS' "
_cQuery1 += "       ,B2_QTNP'QTTERPD' "
_cQuery1 += "       ,B2_QNPT 'QTNSPDTER',(B2_QATU - B2_RESERVA)'QTDISP'  "
_cQuery1 += " FROM " +Retsqlname ("SB2") + " SB2 (NOLOCK) "
_cQuery1 += " WHERE  SB2.B2_COD BETWEEN '" +alltrim(MV_PAR01)+ "'  AND '" +alltrim(MV_PAR02)+ "' "
_cQuery1 += "   AND SB2.B2_LOCAL = '" +alltrim(MV_PAR03)+ "' "
_cQuery1 += "   AND B2_FILIAL    = '" +alltrim(MV_PAR04)+ "' "
_cQuery1 += "   AND D_E_L_E_T_   ='' "

	if mv_par05 == 1
 _cQuery1 += "  AND B2_QATU > '0' " 
	endif

//		memowrite('saldodispo.sql',_cQuery1) 
		_cQuery := CHANGEQUERY(_cQuery1)
		TcQuery _cQuery1 ALIAS "QRY1" NEW

procregua(reccount())

DO WHILE !QRY1->(EOF())  

			cLinha := QRY1->COD+";"+QRY1->ARMZ+";"+transform(QRY1->SLDOATU , "@E 9,999,999.999")+";"+transform(QRY1->QTDRESER ,"@E 9,999,999.999")+";"+transform(QRY1->QTPDVEND ,"@E 9,999,999.999")+";"+transform(QRY1->QTACLAS , "@E 9,999,999.999")+";"+transform(QRY1->QTTERPD , "@E 9,999,999.999")+";"+transform(QRY1->QTNSPDTER , "@E 9,999,999.999")+";"+transform(QRY1->QTDISP , "@E 9,999,999.999")
			fWrite(nHandle, cLinha  + cCrLf)

QRY1->(dbskip())
	IncProc()
 Enddo

   fClose(nHandle)
//CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )-- Removido a pedido do Carlos Rocha 14/07/10 --

If ! ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
                                	
return()
 
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
//	2			3			4						5		  		6				7			8		9			10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
  AAdd(aRegs,{cPerg,"01","Considere Data De?  ",""   				,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"02","At้ a Data: ",""				,""  			,"mv_ch2",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",	""	,""		,	""		,"",		""		,  "",	""		,	""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"03","Armazen ",""				,""  			,"mv_ch3",	"N",   01       ,0       ,		1 ,		"G"  ,		"",		"mv_par03",	"1-Analitico"	,"1-Analitico"		,	"1-Analitico"		,"",		""		,  "2-Sintetico",	"2-Sintetico"		,	"2-Sintetico"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
//AAdd(aRegs,{cPerg,"04","Lancamento On-line: ",""   				,""  			,"mv_ch4",	"N",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",	"1-Sim"	,"1-Si"		,	"1-Yes"		,"",		""		,  "2-Nao",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
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