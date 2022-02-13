#include 'protheus.ch'
#include 'rwmake.ch'
#INCLUDE "APVT100.CH"
#INCLUDE "TopConn.ch"
#include "tbiconn.ch"

User Function ExcC6()

Local aArea   := {}
Local aCab    := {}
Local aItem   := {}
Local aLinha  := {}
Local cQuery  := ""
Local _cAlias := ""

Private lMSErroAuto:= .F. 

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "SC5","SC6" 

aArea   := GetArea()
_cAlias := GetNextAlias()

DbSelectArea("SC9")
DbSelectArea("SC5")
DbSelectArea("SC6")

SC9->(DbSetOrder(1))
SC5->(DbSetOrder(1)) 
SC6->(DbSetOrder(1))

MsgInfo("Inicio processamento")

/*cQuery := " SELECT DISTINCT(C6_NUM) FROM "+RetSqlName("SC6")+" C6 (NOLOCK) " + CRLF 
cQuery += " INNER JOIN (  " + CRLF 
cQuery += " 		SELECT MAX(SC6.R_E_C_N_O_) AS C6RECNO, Z9_NUMOS, Z9_PARTNR FROM "+RetSqlName("SZ9")+" SZ9 (NOLOCK) " + CRLF 
cQuery += " 		INNER JOIN "+RetSqlName("ZZ4")+" ZZ4 (NOLOCK) ON  " + CRLF 
cQuery += " 		RTRIM(LTRIM(ZZ4_OS)) = RTRIM(LTRIM(Z9_NUMOS))  " + CRLF 
cQuery += " 		AND RTRIM(LTRIM(ZZ4_IMEI)) = RTRIM(LTRIM(Z9_IMEI))  " + CRLF 
cQuery += " 		AND ZZ4.D_E_L_E_T_ <> '*' " + CRLF 
cQuery += " 		AND ZZ4_FILIAL = Z9_FILIAL " + CRLF 
cQuery += " 		INNER JOIN "+RetSqlName("SC6")+" SC6 (NOLOCK) ON  " + CRLF 
cQuery += " 		(RTRIM(LTRIM(C6_NUMOS)) = RTRIM(LTRIM(Z9_NUMOS)) OR RTRIM(LTRIM(C6_NUMOS)) = RTRIM(LTRIM(Z9_NUMOS+' 01'))) " + CRLF 
cQuery += " 		AND RTRIM(LTRIM(C6_PRODUTO)) = (RTRIM(LTRIM(Z9_PARTNR)))   " + CRLF 
cQuery += " 		AND SC6.D_E_L_E_T_ <> '*' " + CRLF 
cQuery += " 		AND C6_FILIAL = Z9_FILIAL " + CRLF 
cQuery += " 		WHERE SZ9.D_E_L_E_T_ = '' " + CRLF 
cQuery += " 		 AND Z9_FILIAL = '"+xFilial("SZ9")+"' " + CRLF 
cQuery += " 		 AND Z9_PARTNR <> '' " + CRLF
cQuery += " 		 AND C6_NOTA = ''  " + CRLF
cQuery += " 		 AND C6_BLQ = ''  " + CRLF  

//cQuery += " 		 AND Z9_NUMOS = '9BF5ZI' " + CRLF 
//cQuery += " 		 AND Z9_IMEI = '353256067367947' " + CRLF 
//cQuery += " 		 AND Z9_PARTNR = '78P7130001NI' " + CRLF 

cQuery += " 		 GROUP BY Z9_NUMOS, Z9_PARTNR) A " + CRLF 
cQuery += "  ON (RTRIM(LTRIM(C6.C6_NUMOS)) = RTRIM(LTRIM(A.Z9_NUMOS)) OR RTRIM(LTRIM(C6.C6_NUMOS)) = RTRIM(LTRIM(A.Z9_NUMOS+' 01'))) " + CRLF 
cQuery += "  AND RTRIM(LTRIM(C6.C6_PRODUTO)) = (RTRIM(LTRIM(A.Z9_PARTNR)))  " + CRLF 
cQuery += "  WHERE C6.C6_NOTA = '' " + CRLF 
cQuery += "  AND A.C6RECNO <> C6.R_E_C_N_O_ " + CRLF 
cQuery += "  AND C6.D_E_L_E_T_ <> '*' AND C6.C6_FILIAL = '"+xFilial("SZ9")+"' " + CRLF
cQuery += "  AND C6_BLQ = '' " + CRLF*/

cQuery := "  SELECT C6_NUM FROM SC6020 WHERE D_E_L_E_T_ <> '*' AND C6_FILIAL = '02' AND C6_NOTA = '' AND C6_NUM IN  " + CRLF
cQuery += "	('9A8H12',	 " + CRLF 
cQuery += "	'9A8H0M',	 " + CRLF 
cQuery += "	'9A8H32',	 " + CRLF 
cQuery += "	'9A8H0Q',	 " + CRLF 
cQuery += "	'9A8H16',	 " + CRLF 
cQuery += "	'9A8H26',	 " + CRLF 
cQuery += "	'9A8H2A',	 " + CRLF 
cQuery += "	'9A8H2I',	 " + CRLF 
cQuery += "	'9A8GZE',	 " + CRLF 
cQuery += "	'9A8H1M',	 " + CRLF 
cQuery += "	'9A8GYA',	 " + CRLF 
cQuery += "	'9A8H22',	 " + CRLF 
cQuery += "	'9A8H2E',	 " + CRLF 
cQuery += "	'9A8H36',	 " + CRLF 
cQuery += "	'9A8H0U',	 " + CRLF 
cQuery += "	'9A8GZI',	 " + CRLF 
cQuery += "	'9A8H0I',	 " + CRLF 
cQuery += "	'9A8H1I',	 " + CRLF 
cQuery += "	'9A8MLH',	 " + CRLF 
cQuery += "	'9A8H3E',	 " + CRLF 
cQuery += "	'9A8H1E',	 " + CRLF 
cQuery += "	'9A8GYU',	 " + CRLF 
cQuery += "	'9A8GYI',	 " + CRLF 
cQuery += "	'9A8H0E',	 " + CRLF 
cQuery += "	'9A8H3I',	 " + CRLF 
cQuery += "	'9A8H1A',	 " + CRLF 
cQuery += "	'9A8H3A',	 " + CRLF 
cQuery += "	'9A8GYY',	 " + CRLF 
cQuery += "	'9A8H0A',	 " + CRLF 
cQuery += "	'9A8GYE',	 " + CRLF 
cQuery += "	'9A8GZ6',	 " + CRLF 
cQuery += "	'9A8GYM',	 " + CRLF 
cQuery += "	'9A6M10',	 " + CRLF 
cQuery += "	'9A8GZY',	 " + CRLF 
cQuery += "	'9A8H2U',	 " + CRLF 
cQuery += "	'9A8H0Y',	 " + CRLF 
cQuery += "	'9A8H1U',	 " + CRLF 
cQuery += "	'9A8H2M',	 " + CRLF 
cQuery += "	'9A8GZQ',	 " + CRLF 
cQuery += "	'9A8GY6',	 " + CRLF 
cQuery += "	'9A8H06',	 " + CRLF 
cQuery += "	'9A8H02',	 " + CRLF 
cQuery += "	'9A8GY2',	 " + CRLF 
cQuery += "	'9A8H3M',	 " + CRLF 
cQuery += "	'9A8H1Q',	 " + CRLF 
cQuery += "	'9A8H2Q',	 " + CRLF 
cQuery += "	'9A8GZM',	 " + CRLF 
cQuery += "	'9A8GXY',	 " + CRLF 
cQuery += "	'9A8GZ2',	 " + CRLF 
cQuery += "	'9A5LSA',	 " + CRLF 
cQuery += "	'9A8GZA',	 " + CRLF 
cQuery += "	'9A8H2Y',	 " + CRLF 
cQuery += "	'9A5MN0',	 " + CRLF 
cQuery += "	'9A8H1Y',	 " + CRLF 
cQuery += "	'9A8GZU',	 " + CRLF 
cQuery += "	'9A8GYQ')	 " + CRLF  

cQuery := ChangeQuery(cQuery) 
If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
( _cAlias )->( dbGoTop() )
If( ( _cAlias )->( !Eof() ) ) 
	While ( ( _cAlias )->( !Eof() ) ) 
	
		SC9->(DbGoTop())
	
		If SC9->(DbSeek(xFilial("SC9")+( _cAlias )->C6_NUM))		
			While SC9->(!Eof()) .AND. SC9->C9_FILIAL == xFilial("SC9") .AND. SC9->C9_PEDIDO == ( _cAlias )->C6_NUM
			   SC9->(A460Estorna())
			   SC9->(DbSkip())
			EndDo
		EndIf		
	
		SC5->(DbGoTop()) 
		
		If SC5->(DbSeek(xFilial("SC5")+( _cAlias )->C6_NUM))
		
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//쿒era o cabecalho do pedido de venda.    				       �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			/*AAdd(aCab,{"C5_FILIAL"  ,SC5->C5_FILIAL				,Nil})
			AAdd(aCab,{"C5_NUM"   	,SC5->C5_NUM				,Nil})
			AAdd(aCab,{"C5_TIPO" 	,SC5->C5_TIPO				,Nil})
			AAdd(aCab,{"C5_CLIENTE"	,SC5->C5_CLIENTE			,Nil})
			AAdd(aCab,{"C5_LOJACLI"	,SC5->C5_LOJACLI			,Nil})
			AAdd(aCab,{"C5_TIPOCLI"	,SC5->C5_TIPOCLI			,Nil})
			AAdd(aCab,{"C5_CONDPAG"	,SC5->C5_CONDPAG			,Nil})*/
			
			SC6->(DbGoTop()) 
		
			If SC6->(DbSeek(xFilial("SC6")+( _cAlias )->C6_NUM))
			
				While ( _cAlias )->C6_NUM == SC6->C6_NUM
				
					If Empty(SC6->C6_NOTA)
					    
						Begin Transaction
							MaResDoFat(nil, .T., .F., 0)
							MaLiberOk({ SC5->C5_NUM }, .T.)						
						End Transaction  
				
						/*AAdd(aItem,{"C6_FILIAL" 	,SC6->C6_FILIAL			,Nil})
						AAdd(aItem,{"C6_NUM"    	,SC6->C6_NUM			,Nil})
						AAdd(aItem,{"C6_ITEM"   	,SC6->C6_ITEM			,Nil})
						AAdd(aItem,{"C6_PRODUTO"	,SC6->C6_PRODUTO		,Nil})
						AAdd(aItem,{"C6_QTDVEN" 	,SC6->C6_QTDVEN			,Nil})
						AAdd(aItem,{"C6_TES"    	,SC6->C6_TES			,Nil})
						AAdd(aItem,{"C6_PRCVEN" 	,SC6->C6_PRCVEN			,Nil})
						AAdd(aItem,{"C6_PRUNIT" 	,SC6->C6_PRUNIT			,Nil})
						AAdd(aItem,{"C6_VALOR"  	,SC6->C6_VALOR 			,Nil})*/
					
					EndIf				
					
					SC6->(DbSkip())   
				
				EndDo
				
				/*AAdd(aLinha,aItem)
				
				lMSErroAuto:= .F.						
				Begin Transaction	
					MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aLinha,5) 
					If lMSErroAuto
						DisarmTransaction()
					EndIf
				End Transaction
				aCab  := {}
				aItem := {}
				aLinha:= {}*/ 
			EndIf
		EndIf
		( _cAlias )->(dbSkip())
	EndDo
EndIf

MsgInfo("Fim processamento")
RESET ENVIRONMENT			

Return