#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATCLI    บAutor  ณLuiz Ferreira       บ Data ณ  05/09/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PROGRAMA  EM EXCELL  GERA RELATORIO DOS CLIENTE QUE        บฑฑ
ฑฑบ          ณ NAO COMPRA A MAIS DE NOVENTA DIAS                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                  
User Function FATCLI()   

Local cQry1 :=""
Local cQuery :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

PRIVATE cPerg	 :="RFC001"  
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))   

u_GerA0003(ProcName())

ValidPerg(cPerg) 

//dbSelectArea(_sAlias)
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

if ! Pergunte(cPerg,.T.)
 Return()
Endif


//cLinha := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
//fWrite(nHandle, cLinha  + cCrLf)
   cLinha := "CLIENTE;LOJA;RAZAO_SOCIAL;NOME_FANTASIA;CNPJ;ENDERECO;MUNICIPIO;BAIRRO;ESTADO;CEP;CODVEND;NOMEVEND;CREDITO_ATRIBUIDO;CREDITO_DISPONIVEL;ULTCOMP;PRICOMP;EMISNOW;COND;DESCPGTO"
fWrite(nHandle, cLinha  + cCrLf)


IF Select("QRY1") <> 0 
DbSelectArea("QRY1")
DbCloseArea()
Endif
		cQuery += " SELECT SA1.A1_COD AS 'COD_CLIENTE', '01' AS LOJA, SA13.A1_NOME AS 'RAZAO',SA13.A1_NREDUZ AS 'NOME_FANTASIA', "
		cQuery += " SA13.A1_CGC AS CNPJ,SA13.A1_END AS ENDERECO,SA13.A1_MUN AS MUNICIPIO,SA13.A1_BAIRRO AS BAIRRO,SA13.A1_EST AS UF,SA13.A1_CEP AS CEP,A1_VEND 'CODVEND',NOME 'NOMEVEND', CRED_ATRIB AS  'CREDITO_ATRIBUIDO', CRED_ATRIB - CRED_UTIL AS 'CREDITO_DISPONIVEL' ,ULTCOMP,PRICOMP,EMISNOW,A1_COND AS COND,DESCPGTO "
		cQuery += " FROM " +Retsqlname ("SA1") + " SA1 (nolock) LEFT OUTER  JOIN  "
		cQuery += "    (SELECT E1_CLIENTE,A1_NOME,SUM(CRED_ATRIB) AS CRED_ATRIB,SUM(CRED_UTIL) AS CRED_UTIL,MAX(ULTCOMPRA) AS ULTCOMP,MAX(PRICOMPRA) AS PRICOMP ,MAX(EMISNOW) AS EMISNOW "
		cQuery += "    FROM (SELECT  E1_CLIENTE,A1_NOME,0.00 AS CRED_ATRIB,SUM(E1_SALDO) AS CRED_UTIL,MAX(A1_ULTCOM) AS ULTCOMPRA,MAX(A1_PRICOM) AS PRICOMPRA,MAX(GETDATE()) AS EMISNOW "
		cQuery += "                  FROM " +Retsqlname ("SE1") + " SE1 (nolock) "
		cQuery += "                  INNER JOIN  (SELECT A1_COD,A1_LOJA,A1_NOME,A1_ULTCOM,A1_PRICOM FROM " +Retsqlname ("SA1") + " SA1 (nolock) WHERE D_E_L_E_T_='' AND (SUBSTRING(A1_COD,1,1) ='Z' OR A1_VEND<>'' OR A1_LC > 0 AND A1_MSBLQL <> '1')) AS SA12  ON E1_CLIENTE = SA12.A1_COD AND E1_LOJA=SA12.A1_LOJA "
		cQuery += "                  WHERE E1_TIPO = 'NF' AND  SE1.D_E_L_E_T_ = ''  AND  E1_PEDIDO IN (SELECT C6_NUM  FROM " +Retsqlname ("SC6") + " SC6 WHERE (C6_LOCAL IN ('80', '81','82','83','84','87')) AND D_E_L_E_T_ = '' AND C6_TES IN ('771','740','758','779','780') AND C6_NOTA <> '') "
		cQuery += "                  GROUP BY E1_CLIENTE,A1_NOME HAVING  DATEDIFF([DAY],MAX(A1_ULTCOM), MAX(GETDATE())) >= '"+str(MV_PAR01)+"' AND MAX(A1_PRICOM) <>	 ''  "
		cQuery += "                  UNION ALL         "
		cQuery += "                  SELECT C6_CLI,A1_NOME,0.00 AS CRED_ATRIB, SUM(C6_VALOR) AS CRED_UTIL,MAX(ULTCOMPRA),MAX(PRICOMPRA),MAX(EMISNOW) "
		cQuery += "                  FROM " +Retsqlname ("SC6") + " (nolock) INNER JOIN  (SELECT A1_COD,A1_LOJA,A1_NOME,MAX(A1_ULTCOM) AS ULTCOMPRA,MAX(A1_PRICOM) AS PRICOMPRA,MAX(GETDATE()) AS EMISNOW FROM " +Retsqlname ("SA1") +" SA1 (nolock) WHERE D_E_L_E_T_='' AND (SUBSTRING(A1_COD,1,1) ='Z' OR A1_VEND<>'' OR A1_LC > 0 AND A1_MSBLQL <> '1') GROUP BY  A1_COD,A1_LOJA,A1_NOME HAVING  DATEDIFF([DAY],MAX(A1_ULTCOM), MAX(GETDATE())) > '"+str(MV_PAR01)+"' AND MAX(A1_PRICOM) <>'' ) AS SA13  ON C6_CLI = SA13.A1_COD AND C6_LOJA = SA13.A1_LOJA "
		cQuery += "                  WHERE  (C6_LOCAL IN ('80', '81','82','83','84','87')) AND D_E_L_E_T_ = '' AND C6_TES IN ('771','740','758','779','780')  AND C6_NOTA = ''       "
		cQuery += "                  GROUP BY C6_CLI,A1_NOME "
		cQuery += "                  UNION ALL           "
		cQuery += "                  SELECT A1_COD,A1_NOME ,SUM(A1_LC) AS CRED_ATRIB, 0.00 AS CRED_UTIL,MAX(A1_ULTCOM) AS ULTCOMPRA,MAX(A1_PRICOM) AS PRICOMPRA,MAX(GETDATE()) AS EMISNOW "
		cQuery += "                  FROM  " +Retsqlname ("SA1") +" SA1 (nolock) WHERE  (SUBSTRING(A1_COD,1,1) ='Z' OR A1_VEND<>'' OR A1_LC > 0 ) AND D_E_L_E_T_='' "
		cQuery += "                  GROUP BY  A1_COD,A1_NOME HAVING  DATEDIFF([DAY],MAX(A1_ULTCOM), MAX(GETDATE())) >= '"+str(MV_PAR01)+"' AND MAX(A1_PRICOM) <> '' ) delivertabl  "
		cQuery += "     GROUP BY E1_CLIENTE,A1_NOME HAVING  DATEDIFF([DAY],MAX(ULTCOMPRA), MAX(GETDATE())) >= '"+str(MV_PAR01)+"' AND MAX(PRICOMPRA) <> '' )  "
		cQuery += " AS SC6 ON E1_CLIENTE=SA1.A1_COD  "
		cQuery += " INNER JOIN (SELECT A1_COD,A1_LOJA,A1_NOME,A1_NREDUZ,A1_CGC,A1_END,A1_MUN,A1_BAIRRO,A1_EST,A1_CEP,A1_MSBLQL FROM " +Retsqlname ("SA1") +" SA1 (nolock) WHERE (SUBSTRING(A1_COD,1,1) ='Z' OR A1_VEND<>'' OR A1_LC > 0 AND  A1_MSBLQL <> '1') AND D_E_L_E_T_='' AND A1_LOJA='01' AND A1_CODPAIS<>'1.0' AND A1_MSBLQL <> '1')  AS SA13 ON SA1.A1_COD=SA13.A1_COD AND SA1.A1_LOJA=SA13.A1_LOJA  "
		cQuery += " LEFT OUTER JOIN (SELECT E4_CODIGO AS CODPGTO,E4_DESCRI AS DESCPGTO FROM " +Retsqlname ("SE4") +" SE4 (nolock) WHERE D_E_L_E_T_='') AS SE4 ON SE4.CODPGTO=A1_COND "
		cQuery += " INNER      JOIN (SELECT A3_COD AS COD, A3_NOME AS NOME FROM " +Retsqlname ("SA3") +" SA3 (nolock) WHERE D_E_L_E_T_='') AS SA31 ON SA31.COD=A1_VEND "
		cQuery += " WHERE SA1.D_E_L_E_T_=''  AND  DATEDIFF([DAY],ULTCOMP,EMISNOW ) >= '"+str(MV_PAR01)+"'  AND A1_CODPAIS<>'1.0' AND A1_PRICOM<>'' "
//    	memowrite('QSLK.sql',cQuery) 
 TCQUERY cQuery NEW ALIAS "QRY1"

TcSetField("QRY1","ULTCOMP","D")    //TRANFORMACAO DAS DATAS
TcSetField("QRY1","PRICOMP","D")       
	

DBSELECTAREA("QRY1")
	QRY1->(DBGOTOP())   
	 	DO WHILE !QRY1->(EOF())
      //cLinha := Transform(QRY1->FAT,"@E 9,999,999,999.99")+";"+QRY1->D2_CCUSTO+";"+QRY1->D2_CF+";"+Transform(nICMS,"@E 9,999,999,999.99")+";"+Transform(QRY1->IPI,"@E 9,999,999,999.99")+";"+Transform(QRY1->ISS,"@E 9,999,999,999.99")+";"+Transform(QRY1->PIS,"@E 9,999,999,999.99")+";"+Transform(QRY1->COFINS,"@E 9,999,999,999.99")                                                                                                                                                                                                                                                                                                                                         
	    cLinha := QRY1->COD_CLIENTE+";"+QRY1->LOJA+";"+QRY1->RAZAO+";"+QRY1->NOME_FANTASIA+";"+QRY1->CNPJ+";"+QRY1->ENDERECO+";"+QRY1->MUNICIPIO+";"+QRY1->BAIRRO+";"+QRY1->UF+";"+QRY1->CEP+";"+QRY1->CODVEND+";"+QRY1->NOMEVEND+";"+transform(QRY1->CREDITO_ATRIBUIDO, "@E 9,999,999,999")+";"+transform(QRY1->CREDITO_DISPONIVEL , "@E 9,999,999,999")+";"+DTOC(QRY1->ULTCOMP)+";"+DTOC(QRY1->PRICOMP)+";"+DTOC(Ddatabase)+";"+QRY1->COND+";"+QRY1->DESCPGTO	 			
        fWrite(nHandle, cLinha  + cCrLf)
		QRY1->(DBSKIP())
    ENDDO

		fClose(nHandle)
		//CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha 	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
                                	
RETURN

  //CRIACAO DOS PARAMENTROS
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
//	2			3			4						5		  		6				7			8		9			10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
  AAdd(aRegs,{cPerg,"01","Nao Compra a mais de ",""   				,""  			,"mv_ch1",	"N",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
//AAdd(aRegs,{cPerg,"02","Mostrar Lancamento: ",""				,""  			,"mv_ch2",	"N",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",	"1-Sim"	,"1-Si"		,	"1-Yes"		,"",		""		,  "2-Nao",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
//AAdd(aRegs,{cPerg,"03","Tipo do Relatorio: ",""				,""  			,"mv_ch3",	"N",   01       ,0       ,		1 ,		"G"  ,		"",		"mv_par03",	"1-Analitico"	,"1-Analitico"		,	"1-Analitico"		,"",		""		,  "2-Sintetico",	"2-Sintetico"		,	"2-Sintetico"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
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