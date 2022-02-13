#include "Protheus.ch"
#include "Rwmake.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHRETPO ³ Autor ³ Luciano Siqueira      ³ Data ³ 09/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerar pedido de Venda com base nos parametros informados e  ±±
±±³          ³ dados da planilha de acordo com layout definido pelo TI     ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BGHRETPO()

Private cPerg		:= "BGHRETPO"

ValidPerg() // Ajusta as Perguntas do SX1
If Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	MsAguarde({|| GERAPV()},OemtoAnsi("Processando..."))
Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERAPV    ºAutor  ³Luciano Siqueira    º Data ³  10/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera Pedidos de Venda e NF de Saida                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GERAPV()        

Local aAreaAtu  	:= GetArea()
Local aCabPV      	:=	{}
Local aItemPV     	:=	{}
Local aItem       	:=	{}
Local nOpc		    :=	3
Local nItPv	 	    := 	'00'

//Filtra dados para gerar pedido de venda de retorno
cQuery := " SELECT CODIGO AS PRODUTO, TOTAL AS QUANT "
cQuery += " FROM TERC_MOT "
cQuery += " ORDER BY PRODUTO "                        

If Select("TSQL") > 0
	TSQL->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL",.T.,.T.)

dbSelectArea("TSQL")
TSQL->(dbGotop())

While TSQL->(!EOF())
		
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+TSQL->PRODUTO)
		
		//Busca os saldos em estoque
		aSaldoB2 := {}
		
		cQryB2 := " SELECT B2_COD, B2_LOCAL, (B2_QATU-B2_RESERVA-B2_QEMP-B2_QACLASS) AS SALDO "
		cQryB2 += " FROM SB2020  "
		cQryB2 += " WHERE B2_FILIAL = '"+xFilial("SB2")+"' "
		cQryB2 += " AND D_E_L_E_T_ = '' "
		cQryB2 += " AND B2_COD = '"+SB1->B1_COD+"' "
		
		If Select("TSB2") > 0
			TSB2->(dbCloseArea())
		EndIf

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryB2),"TSB2",.T.,.T.)
		
		dbSelectArea("TSB2")
		TSB2->(dbGotop())
		
		While TSB2->(!Eof())
		
			AADD( aSaldoB2, { TSB2->B2_COD, TSB2->B2_LOCAL, TSB2->SALDO })
						
			TSB2->(dbSkip())
		EndDo
				
		nSaldo := TSQL->QUANT
		
		dbSelectArea("SB6")
		SB6->(dbSetOrder(1)) //B6_FILIAL + B6_PRODUTO + B6_CLIFOR + B6_LOJA + B6_IDENT
		
		_cQrySB6 := " SELECT B6_TPCF, B6_PRODUTO,B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT, B6_TES "
		_cQrySB6 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
		_cQrySB6 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
		_cQrySB6 += "        B6_PRODUTO = '"+SB1->B1_COD+"' AND "
		_cQrySB6 += "        B6_CLIFOR  = '"+MV_PAR01+"' AND "
		_cQrySB6 += "        B6_LOJA    = '"+MV_PAR02+"' AND "
		//_cQrySB6 += "		 B6_LOCAL ='"+fMark->ARMORI+"' AND "
		_cQrySB6 += "        B6_SALDO > 0 AND "    
		_cQrySB6 += "		 B6_TES  <> '491' AND "
		_cQrySB6 += "		 B6.D_E_L_E_T_ = '' "
		_cQrySB6 += " ORDER BY B6_IDENT DESC "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySB6),"TSQLSB6",.T.,.T.)
		
		TSQLSB6->(DBGoTop())
		
		While TSQLSB6->(!EOF()) .and. nSaldo > 0
		
			//Monta cabeçalho do pedido de venda
			If Len(aCabPv) == 0 .and. Len(aItem) == 0
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				
				MsSeek(xFilial("SA1")+MV_PAR01+MV_PAR02)
				
				aCabPV := {;
				{"C5_TIPO"   ,IIF(TSQLSB6->B6_TPCF=="C","N","B")	,Nil},;
				{"C5_CLIENTE",SA1->A1_COD   			,Nil},;
				{"C5_LOJACLI",SA1->A1_LOJA	  			,Nil},;
				{"C5_CONDPAG","001"			   			,Nil},;
				{"C5_TRANSP" ,"01"  		  			,Nil},;
				{"C5_DIVNEG" ,MV_PAR03    				,Nil},;
				{"C5_CLIENT",SA1->A1_COD   				,Nil},;
				{"C5_LOJAENT",SA1->A1_LOJA 	  			,Nil}}
				
			Endif
			
			nSalP3  := SalDisP3(TSQLSB6->B6_IDENT, TSQLSB6->B6_SALDO)
			nQtRet3 := iif(nSalP3 >= nSaldo, nSaldo, nSalP3)
			aSldPed := {}
			
			IF nQtRet3 > 0
			    
			    //Verifica saldo disponivel no estoque
			     nPosPR  := aScan(aSaldoB2,{|x| x[1]+x[2] == TSQLSB6->B6_PRODUTO+TSQLSB6->B6_LOCAL })
			     If nPosPR > 0
			                  
					If aSaldoB2[nPosPR][3] >= nQtRet3//Tem saldo em estoque para atender 					
						cTesOri := Posicione("SF4",1,xFilial("SF4")+TSQLSB6->B6_TES,"F4_TESDV")
						AADD( aSldPed, {nQtRet3, cTesOri}  )						
						aSaldoB2[nPosPR][3] -= nQtRet3
					Else//Não tem saldo suficiente
						If aSaldoB2[nPosPR][3] > 0 
	
							cTesOri := Posicione("SF4",1,xFilial("SF4")+TSQLSB6->B6_TES,"F4_TESDV")
							AADD( aSldPed, {aSaldoB2[nPosPR][3], cTesOri}  )
							
							nResto := nQtRet3 - aSaldoB2[nPosPR][3]
							                               
							//Define TES de destino 							
							If Alltrim(TSQLSB6->B6_TES) $ "267/233"
								cSemEst := "917"            															
							EndIf							       
							
							If Alltrim(TSQLSB6->B6_TES) $ "232"
								cSemEst := "918"
							EndIf							
							
							If Alltrim(TSQLSB6->B6_TES) $ "329"
								cSemEst := "919"
							EndIf							                                
							
							AADD( aSldPed, {nResto, cSemEst}  )  
							
							aSaldoB2[nPosPR][3] := 0
							
						Else//saldo zerado 
							//Define TES de destino 							
						     If Alltrim(TSQLSB6->B6_TES) $ "267/233"
								cSemEst := "917"
	  						 EndIf							
	  						 
 							If Alltrim(TSQLSB6->B6_TES) $ "232"
								cSemEst := "918"
							EndIf							
							
							If Alltrim(TSQLSB6->B6_TES) $ "329"
								cSemEst := "919"
							EndIf							                                
							
							 AADD( aSldPed, {nQtRet3, cSemEst}  )
						EndIf
					EndIf 
								     			     
			     Else//Não existe saldo disponivel no estoque			
					//Define TES de destino 							
				    If Alltrim(TSQLSB6->B6_TES) $ "267/233"
						cSemEst := "917"             						
	  				EndIf							 
	  				
					If Alltrim(TSQLSB6->B6_TES) $ "232"
						cSemEst := "918"
					EndIf							
					
					If Alltrim(TSQLSB6->B6_TES) $ "329"
						cSemEst := "919"
					EndIf							   
  									
					 AADD( aSldPed, {nQtRet3, cSemEst}  )					 				
			     EndIf
			     
   			     nItPv	 := Soma1(nItPv,2)
   				 nSaldo  := nSaldo - nQtRet3
				 nPreco  := A410Arred(TSQLSB6->B6_PRUNIT,"C6_VALOR")
				 nValor  := A410Arred(TSQLSB6->B6_PRUNIT * nQtRet3,"C6_VALOR")
			    							
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+TSQLSB6->B6_PRODUTO)

				//Busca o item do pedido de venda
				cQuer2 := " SELECT D1_ITEM FROM SD1020 "
				cQuer2 += " WHERE D1_IDENTB6 = '"+TSQLSB6->B6_IDENT+"'  "
				cQuer2 += " AND D_E_L_E_T_ = '' "
				cQuer2 += " AND D1_FILIAL = '"+xFilial("SD1")+"' "
				
				If Select("TSD1") > 0
					TSD1->(dbCloseArea())
				EndIf
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuer2),"TSD1",.T.,.T.)
				
				dbSelectArea("TSD1")
				TSD1->(dbGotop())
				                           
				cIteOri := ""
				While TSD1->(!Eof())
					cIteOri := TSD1->D1_ITEM
					Exit
				EndDo
                                                        
				//Adiona itens no pedido de venda
				For nPS := 1 To Len(aSldPed)
				         
					If nPS > 1
		   			     nItPv	 := Soma1(nItPv,2)
					EndIf
							   			     
					aItemPV:={;
					{"C6_ITEM"   	,	nItPv	   				,Nil},;
					{"C6_PRODUTO"	,	SB1->B1_COD				,Nil},;
					{"C6_QTDVEN" 	,	aSldPed[nPS,1]			,Nil},;
					{"C6_QTDLIB"	,	aSldPed[nPS,1]			,Nil},;
					{"C6_PRCVEN" 	,	nPreco					,Nil},;
					{"C6_VALOR"		,   ROUND(aSldPed[nPS,1]*nPreco,5) ,Nil},;
					{"C6_TES"		,	aSldPed[nPS,2]			,Nil},;
					{"C6_NFORI"		,	TSQLSB6->B6_DOC			,Nil},;
					{"C6_SERIORI"	,	TSQLSB6->B6_SERIE		,Nil},;
					{"C6_ITEMORI"	,	cIteOri					,Nil},;
					{"C6_IDENTB6"	,	TSQLSB6->B6_IDENT		,Nil},;
					{"C6_LOCAL" 	,	TSQLSB6->B6_LOCAL		,Nil},;
					{"C6_PRUNIT"	,	0						,Nil}}
					
					aADD(aItem,aItempv)
					
				Next nPS					
				
				If len(aItem) == 65
					If 	Len(aCabPv) > 0 .and. Len(aItem) > 0
						lMsErroAuto := .F.
						MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)
						If lMsErroAuto
							//MostraErro()
							GERPVMAN(aCabPv,aItem) 
						Else
							MsgAlert("Pedido gerado - "+SC5->C5_NUM)
						Endif
						aCabPV      	:=	{}
						aItemPV     	:=	{}
						aItem       	:=	{}
						nItPv	 	    := 	'00'
					Endif
				Endif
				
			Endif
			TSQLSB6->(dbSkip())
		Enddo
		
		If nSaldo > 0              
			cLog := Transform(nSaldo,"@E 999,999,999.99") + " - Não tem saldo de terceiro: "+ SB1->B1_COD
		Endif
				
		If Select("TSQLSB6") > 0
			dbSelectArea("TSQLSB6")
			DbCloseArea()
		EndIf
		
	Else
		Alert("Produto: "+TSQL->PRODUTO+" - não localizado no cadastro.")
	Endif
	
	dbSelectArea("TSQL")
	TSQL->(dbSkip())
EndDo

If Len(aCabPv) > 0 .and. Len(aItem) > 0

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)
	
	If lMsErroAuto
		//MostraErro()
		GERPVMAN(aCabPv,aItem) 
	Else
		MsgAlert("Pedido gerado - "+SC5->C5_NUM)
	Endif
Endif

RestArea(aAreaAtu)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SalDisP3  ºAutor  ³Microsiga           º Data ³  09/26/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calcular saldo disponivel de Terceiros.        º±±
±±º          ³ Desconta PV abertos do SB6->B6_SALDO                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function SalDisP3(_cIdent, _nSalSB6)

local _aAreaSC6  := SC6->(GetArea())
local _nSalDisP3 := _nQtPV3:= 0
Local _cqry      := ""

SC6->(dbSetOrder(12))

If Select("Qrysc6") > 0
	Qrysc6->(dbCloseArea())
Endif

_cqry := " SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTDSC6 "
_cqry += " FROM "+RETSQLNAME("SC6")+" (NOLOCK) WHERE C6_FILIAL='"+xFILIAL("SC6")+"' AND C6_IDENTB6='"+_cIdent+"' AND D_E_L_E_T_='' AND (C6_QTDVEN-C6_QTDENT) > 0 "

TCQUERY _cqry ALIAS "Qrysc6" NEW

dbSelectArea("Qrysc6")

If Select("Qrysc6") > 0
	_nQtPV3 :=Qrysc6->QTDSC6
Endif

_nSalDisP3 := _nSalSB6 - _nQtPV3

restarea(_aAreaSC6)

return(_nSalDisP3)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPEXC    ºAutor  ³Luciano Siqueira    º Data ³  12/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Log das Inconsistencias encontradas                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPEXC()

Local oReport

Private _cQuebra := " "

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()
EndIf
Return


Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("IMPEXC","Log",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir Log")


oSection1 := TRSection():New(oReport,OemToAnsi("Log"),{"TRB"})

TRCell():New(oSection1,"LOG","TRB","LOG","@!",90)


Return oReport


// Impressao do Relatorio

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText("Total Geral  ")  // Imprime Titulo antes do Totalizador da Secao
oReport:OnPageBreak(,.T.)


// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	
	DbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPERG  ºAutor  ³Delta Decisao      º Data ³  21/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Perguntas                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALIDPERG()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
cPerg        := PADR(cPerg,len(sx1->x1_grupo))

aHelpPor :={}
AAdd(aHelpPor,"Cliente/Fornecedor ")
PutSx1(cPerg,"01","Cliente/Fornecedor ?","Cliente/Fornecedor ?","Cliente/Fornecedor ?","mv_ch1","C",06,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Loja do Pedido de Venda")
PutSx1(cPerg,"02","Loja PV ?","Loja PV ?","Loja PV ?","mv_ch2","C",02,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Divisao Negocio")
PutSx1(cPerg,"03","Div. Neg. ?","Div. Neg. ?","Div. Neg. ?","mv_ch3","C",02,0,0,"G","","ZM","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


Return

Static Function GERPVMAN(aCabPv,aItem)

Local aAreaAtu	:= GetArea()
Local cNrPV		:= GetSxeNum('SC5','C5_NUM')

dbSelectArea("SA1")
dbSetOrder(1)
SA1->(DBSeek(xFilial('SA1')+aCabPv[2,2]+aCabPv[3,2]))

_cCFIni := "0"
If Subs(SA1->A1_EST,1,2) == "EX"
	_cCFIni := "7"
ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
	_cCFIni := "6"
Else
	_cCFIni := "5"
EndIf

BEGIN TRANSACTION 

dbSelectArea("SC5")
RecLock('SC5',.T.)
SC5->C5_FILIAL  := xFilial('SC5')
SC5->C5_NUM     := cNrPV
SC5->C5_TIPO    := aCabPv[1,2]
SC5->C5_CLIENTE := aCabPv[2,2]
SC5->C5_LOJACLI := aCabPv[3,2]
SC5->C5_CLIENT  := aCabPv[2,2]
SC5->C5_LOJAENT := aCabPv[3,2]
SC5->C5_TIPOCLI := 'F'   //Consumidor Final
SC5->C5_CONDPAG := aCabPv[4,2]
SC5->C5_TRANSP  := aCabPv[5,2]
SC5->C5_DIVNEG  := aCabPv[6,2]
SC5->C5_EMISSAO := dDatabase
SC5->C5_MOEDA   := 1
SC5->C5_TIPLIB  := '1'   //Liberacao por Pedido
SC5->C5_TPCARGA := '2'
SC5->C5_TXMOEDA := 1
SC5->C5_LIBEROK := "S"
MsUnLock('SC5')
ConfirmSX8()

for nX := 1 to len(aItem)
	SB1->(DBSeek(xFilial('SB1')+aItem[nX,2,2]))
	SF4->(DBSeek(xFilial('SF4')+aItem[nX,7,2])) 
	dbSelectArea("SC6")
	RecLock('SC6',.T.)
	SC6->C6_FILIAL := xFilial('SC6')
	SC6->C6_NUM    := cNrPV
	SC6->C6_ITEM   := aItem[nX,1,2]
	SC6->C6_PRODUTO:= aItem[nX,2,2]
	SC6->C6_UM     := SB1->B1_UM
	SC6->C6_QTDVEN := aItem[nX,3,2]
	SC6->C6_QTDLIB := aItem[nX,4,2]
	SC6->C6_PRCVEN := aItem[nX,5,2]
	SC6->C6_VALOR  := aItem[nX,6,2]
	SC6->C6_TES    := aItem[nX,7,2]
	SC6->C6_LOCAL  := aItem[nX,12,2]
	SC6->C6_CF     := AllTrim(_cCFIni)+Subs(SF4->F4_CF,2,3)
	SC6->C6_ENTREG := dDataBase
	SC6->C6_DESCRI := SB1->B1_DESC
	SC6->C6_PRUNIT := 0.00
	SC6->C6_NFORI  := aItem[nX,8,2]
	SC6->C6_SERIORI:= aItem[nX,9,2]
	SC6->C6_ITEMORI:= aItem[nX,10,2]
	SC6->C6_TPOP   := 'F' //FIRME
	SC6->C6_CLI    := aCabPv[2,2]
	SC6->C6_LOJA   := aCabPv[3,2]
	SC6->C6_IDENTB6:= aItem[nX,11,2]
	MsUnLock('SC6')
	
	MaLibDoFat(SC6->(RECNO()),aItem[nX,4,2],@.T.,@.T.,.F.,.F.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,NIL,aItem[nX,4,2])
next nX

END TRANSACTION 

RestArea(aAreaAtu)
