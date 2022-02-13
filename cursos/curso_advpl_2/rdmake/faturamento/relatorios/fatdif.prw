#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATDIF    บAutor  ณLuiz Ferreira       บ Data ณ  15/09/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PROGRAMA  EM EXCELL  GERA RELATORIO DAS PESQUISAS          บฑฑ
ฑฑบ          ณ POR CLIENTES                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMERCIAL\FATURAMENTO                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                   

User function FATDIF ()

Local cQry1 :=""
Local cQuery :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath()) 
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

PRIVATE cPerg := "FATDIF" 

u_GerA0003(ProcName())


Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))  
ValidPerg(cPerg) 

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

if ! Pergunte(cPerg,.T.)
 Return()
Endif
             
If   MV_PAR01 ==1 .OR. MV_PAR01 ==3 //Relatorio de clientes que nao compraram e que comecaram a comprar
     cLinha := "CLIENTE;LOJA;RAZAO_SOCIAL;NREDUZ;CNPJ;ENDERECO;BAIRRO;MUNICIPIO;UF;VEND;REPRESEN;COND;ULTCOM;PRICOM;EMISNOW;CRED_ATRIB"
Else            //Relatorio Compras X 7 dias
     cLinha := "CLIENTE;LOJA;RAZAO_SOCIAL;NREDUZ;CNPJ;ENDERECO;BAIRRO;MUNICIPIO;UF;TEL;VEND;COND;ULTCOM;PRICOM;EMISNOW;CRED_ATRIB;CRED_UTIL;CRED_DISPO"
   Endif

fWrite(nHandle, cLinha  + cCrLf)


IF Select("QRY1") <> 0 
DbSelectArea("QRY1")
DbCloseArea()
Endif

IF Select("QRY2") <> 0 
DbSelectArea("QRY2")
DbCloseArea()
Endif

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฑฑ                                                PARAMENTROS  - 19/09/2008                                              ฑฑฑ
ฑฑฑฑ 1 - Lista o Relatorio de INATIVOS clientes que numca compraram e comeracas a comprar de acordo com o PARAMETRO        ฑฑฑ
ฑฑฑฑ 2 - Relatorio de Clientes reativados, ficaram mais de noventas dias sem compras foram reativados                      ฑฑฑ   
ฑฑฑฑ 3 - PROSPECT clientes cadastrados no SIGA sem compras                                                                 ฑฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
  IF MV_PAR01 <> 2       //Relatorio de clientes que nao compraram e que comecaram a comprar
		   cQuery := " SELECT A1_COD AS 'CLIENTE',A1_LOJA AS 'LOJA',A1_NOME AS 'RAZAO',A1_NREDUZ AS 'NREDUZ',A1_CGC AS 'CNPJ',A1_END AS 'ENDER',A1_MUN AS 'MUNIC',A1_BAIRRO AS 'BAIRRO' ,A1_EST AS 'UF',A1_VEND AS 'VEND',SA3.A3_NOME AS 'REPRESEN',A1_COND AS 'COND',MAX(A1_ULTCOM) AS 'ULTCOM', "
		   cQuery += " MAX(A1_PRICOM) AS 'PRICOM',(GETDATE()) AS 'EMISNOW',A1_LC AS 'CREDA'  FROM " +Retsqlname("SA1") + " SA1 (nolock)  "
		   cQuery += " LEFT JOIN (SELECT * FROM " +Retsqlname("SA3")	 + " SA3 (nolock) WHERE D_E_L_E_T_='') AS SA3 ON A3_COD=A1_VEND "
      IF MV_PAR01==1
		   cQuery += " WHERE SA1.D_E_L_E_T_='' AND SUBSTRING(A1_COD,1,1) ='Z' OR A1_VEND<>'' OR A1_LC > 0 
		   cQuery += " GROUP BY A1_COD,A1_FILIAL,A1_LOJA,A1_NOME,A1_NREDUZ,A1_CGC,A1_END,A1_MUN,A1_BAIRRO,A1_TEL,A1_EST,A1_VEND,A1_COND,A1_LC,A1_TEL,A3_NOME "
	       cQuery += " HAVING DATEDIFF([DAY],MAX(A1_PRICOM),(GETDATE())) <= '"+str(MV_PAR02)+"'"  
      ELSEIF MV_PAR01 ==3       //Relatorios Prospect-Comericial     19/09/2008       
		   cQuery += " WHERE SA1.D_E_L_E_T_='' AND A1_PRICOM='' AND (SUBSTRING(A1_COD,1,1) ='Z' OR A1_VEND<>'' OR A1_LC > 0 ) "
		   cQuery += " GROUP BY A1_COD,A1_LOJA,A1_NOME,A1_NREDUZ,A1_CGC,A1_END,A1_MUN,A1_BAIRRO,A1_TEL,A1_EST,A1_VEND,SA3.A3_NOME,A1_COND,A1_LC	"
      ENDIF
//memowrite('QSLK.sql',cQuery) 
TCQUERY cQuery NEW ALIAS "QRY1"          	       

TcSetField("QRY1","ULTCOM","D")
TcSetField("QRY1","PRICOM","D")

	
ELSE 					//Relatorio Compras X 7 dias
	cQuery := " SELECT E1_CLIENTE AS 'CLIENTE',E1_LOJA AS 'LOJA',RAZAO,NREDUZ,CNPJ,ENDER,BAIRRO,MUNIC,UF,TEL,VEND,COND,MAX(ULTCOM) AS ULTCOM,MAX(PRICOM)AS PRICOM,(GETDATE ()) AS EMISNOW,
	cQuery += " A1_LC AS CREDA,
	cQuery += " SUM(E1_VALOR) - 0.00 AS CREDU,((A1_LC)- SUM(E1_VALOR)) AS 'CREDD' FROM " +Retsqlname("SE1") +" SE1 (nolock) INNER JOIN (SELECT A1_COD AS CLIENTE,A1_FILIAL AS FILIAL,A1_LOJA AS LOJA,A1_NOME AS RAZAO,A1_NREDUZ AS NREDUZ,A1_CGC AS CNPJ,A1_END AS ENDER,A1_MUN AS MUNIC,A1_VEND AS VEND,A1_COND AS COND, "
	cQuery += " A1_PRICOM AS PRICOM,A1_ULTCOM AS ULTCOM,A1_EST AS UF,A1_BAIRRO AS BAIRRO ,A1_TEL AS TEL,A1_LC FROM " +Retsqlname("SA1") +" SA1 (nolock) WHERE SUBSTRING(A1_COD,1,1) ='Z' OR A1_VEND<>'' OR A1_LC > 0 AND D_E_L_E_T_='')AS SA1 ON E1_CLIENTE=CLIENTE AND E1_LOJA=LOJA "
	cQuery += " GROUP BY E1_CLIENTE,E1_LOJA,RAZAO,NREDUZ,CNPJ,ENDER,BAIRRO,MUNIC,UF,VEND,COND,A1_LC,TEL HAVING DATEDIFF([DAY],MAX(ULTCOM), MAX(GETDATE())) < '"+str(MV_PAR02)+"' "
	cQuery += " UNION ALL "
	cQuery += " SELECT C6_CLI,C6_LOJA,RAZAO,NREDUZ,CNPJ,ENDER,BAIRRO,MUNIC,UF,TEL,VEND,COND ,MAX(ULTCOM)AS ULTCOM,MAX(PRICOM)AS PRICOM,(GETDATE ()) AS EMISNOW,0.00 AS 'CRED_ATRIB',SUM(C6_VALOR),(SUM(C6_VALOR)- 0.00 ) AS 'CRED_DISPO'  "
	cQuery += " FROM " +Retsqlname("SC6") +" SC6 (nolock) INNER JOIN (SELECT A1_COD AS CLIENTE,A1_FILIAL AS FILIAL,A1_LOJA AS LOJA,A1_NOME AS RAZAO,A1_NREDUZ AS NREDUZ,A1_CGC AS CNPJ,A1_END AS ENDER,A1_MUN AS MUNIC,A1_VEND AS VEND,A1_COND AS COND,
	cQuery += " A1_PRICOM AS PRICOM,A1_ULTCOM AS ULTCOM,A1_EST AS UF,A1_BAIRRO AS BAIRRO ,A1_TEL AS TEL FROM " +Retsqlname("SA1") +" SA1 (nolock) WHERE SUBSTRING(A1_COD,1,1) ='Z' OR A1_VEND<>'' OR A1_LC > 0 AND D_E_L_E_T_='')AS SA13 ON C6_CLI=SA13.CLIENTE AND C6_LOJA=LOJA  "
	cQuery += " WHERE D_E_L_E_T_='' AND (C6_LOCAL IN ('80', '81','82','83','84','87')) AND SC6.D_E_L_E_T_ = '' AND C6_TES IN ('771','740','758','779','780')  AND C6_NOTA = ''       "
	cQuery += " GROUP BY C6_CLI,C6_LOJA,RAZAO,CNPJ,NREDUZ,ENDER,MUNIC,BAIRRO,UF,VEND,COND,TEL "
	cQuery += " HAVING DATEDIFF([DAY],MAX(ULTCOM),(GETDATE())) <= '"+str(MV_PAR02)+"' "
//memowrite('QSLK.sql',cQuery) 
TCQUERY cQuery NEW ALIAS "QRY1"

TcSetField("QRY1","ULTCOM","D")
TcSetField("QRY1","PRICOM","D")

        
Endif
           
DBSELECTAREA("QRY1")
 QRY1->(DBGOTOP())    
  	DO WHILE !QRY1->(EOF())
        IF MV_PAR01 ==1 .OR. MV_PAR01 ==3 //Relatorio de clientes que nao compraram e que comecaram a comprar
	       cLinha := QRY1->CLIENTE+";"+QRY1->LOJA+";"+QRY1->RAZAO+";"+QRY1->NREDUZ+";"+QRY1->CNPJ+";"+QRY1->ENDER+";"+QRY1->MUNIC+";"+QRY1->BAIRRO+";"+QRY1->UF+";"+QRY1->VEND+";"+QRY1->REPRESEN+";"+QRY1->COND+";"+DTOC(QRY1->ULTCOM)+";"+DTOC(QRY1->PRICOM)+";"+DTOC(Ddatabase)+";"+transform(QRY1->CREDA ,"@E 9,999,999,999") 
        ELSE    
           cLinha := QRY1->CLIENTE+";"+QRY1->LOJA+";"+QRY1->RAZAO+";"+QRY1->NREDUZ+";"+QRY1->CNPJ+";"+QRY1->ENDER+";"+QRY1->MUNIC+";"+QRY1->BAIRRO+";"+QRY1->UF+";"+QRY1->TEL+";"+QRY1->VEND+";"+QRY1->COND+";"+DTOC(QRY1->ULTCOM)+";"+DTOC(QRY1->PRICOM)+";"+DTOC(Ddatabase)+";"+transform(QRY1->CREDA ,"@E 9,999,999,999")+";"+transform(QRY1->CREDU , "@E 9,999,999,999")+";"+transform(QRY1->CREDD , "@E 9,999,999,999") 
		ENDIF
      	  fWrite(nHandle, cLinha  + cCrLf)
		QRY1->(DBSKIP())
    ENDDO
	  fClose(nHandle)
	  //CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --

If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
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
  AAdd(aRegs,{cPerg,"01","Qual relatorio? ",""   				,""  			,"mv_ch1",	"N",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		"1-Clientes que nao Comprar"	,	"1-Clientes que nao Comprar"		,		"1-Clientes que nao Comprar"		,"2-Compra x 7 dias",		"2-Compra x 7 dias"		,		"2-Compra x 7 dias",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"02","Quantos dias?   ",""				    ,""  			,"mv_ch2",	"N",		03      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",	""	,""		,	""		,"",		""		,  "","","","","",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
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
