#INCLUDE "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "topconn.ch"
#DEFINE CRLF Chr(13) + Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ImpNfMan ³ Autor ³ Herbert Ayres         ³ Data ³ 16.03.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Interface para importacao da nota fiscal.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Totvs Protheus 10                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³  Data  ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Leonardo   ³21.06.12|Correc³ Capturar o valor de Despesas acessorias  ³±±
±±³            ³        ³      ³ nDespesa(Line: 113)                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ImpNfMan()

Local cConectString := GETMV("MV_XTOPCON")
Local cServer       := GETMV("MV_XTOPSER")
Local nxPort
// para teste
//Local cConectString	:= "MSSQL7/PRODUCAO_11"
//Local cServer			:= "127.0.0.1"

Local cAlias		:= GetNextAlias()	// Variável que contem o proximo alias
Local cPerg			:= PADR ("IMPNFM", Len(SX1->X1_GRUPO))
Local nConexao
Local aErros := {.F.,"OK - impnfman.prw"}
Local lLocal := .F. // colocar .T. para testes
Local J
Local I
Local cxTipo
Local aItem := {}
Local aItens := {}
Local lAuto := .F.
Local nQtdPED := 0
Local nQTDNF  := 0
Local nValMens :=0
Local cPedidos := ""
Local cMensPed
Local nxPort

dbselectarea("SX6")
SX6->(dbsetorder(1))

IF !(SX6->(dbseek( xFilial("SX6")+"MV_XTOPORT") ))
	SX6->(reclock("SX6",.T.) )
	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "MV_XTOPORT"
	SX6->X6_TIPO	:= "C"
	SX6->X6_DESCRIC := "Porta de comunicação DBACCES "
	SX6->X6_DESC1   := "Com Ambiente Producao"
	SX6->X6_DESC2   := ""
	SX6->X6_CONTEUD := "7890"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= "S"
	SX6->( msunlock() )
Endif

nxPort := VAL(ALLTRIM(GETMV("MV_XTOPORT")))

CriaPerg (cPerg)
If Pergunte (cPerg, .T.)
	// Abre uma conexão com o Top Conect da base producao
	nConexao := TCLink (cConectString,cServer,nxPort)
	
	//Valida se a conexão realmente foi estabelecida
	If nConexao < 0 //Conexões com retorno < 0 significam erro
		Alert("Falha de conexão com o TOPConnect: " + Str(nConexao))
		RETURN()
	Else
		// Se o tipo de nota fiscal for de entrada
		If mv_par01 == 1
			MSGSTOP("Por Favor usar Rotina Importar NF SPED")
			Return
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Importacao das notas fiscais de entrada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery	:= " SELECT DISTINCT F1.* FROM " + RetSqlName("SF1") + " AS F1 "
			cQuery	+= " INNER JOIN " + RetSqlName("SD1") + " AS D1 ON D1.D_E_L_E_T_ <> '*' AND D1_FILIAL = F1_FILIAL AND D1_SERIE = F1_SERIE AND D1_DOC = F1_DOC AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA "
			cQuery	+= " INNER JOIN " + RetSqlName("SF4") + " AS F4 ON F4.D_E_L_E_T_ <> '*' AND F4_CODIGO = D1_TES "
			cQuery	+= " WHERE F1.D_E_L_E_T_ <> '*' AND F1_MSEXP = '' AND (F4_LFICM <> 'N' OR F4_LFIPI <> 'N') AND F1_MSFIL = '" + mv_par02 + "' "
			cQuery	+= " 	AND F1_SERIE = '" + PADR(mv_par03, TamSX3("F1_SERIE")[1]) + "' AND F1_DOC = '" + PADR(mv_par04, TamSX3("F1_DOC")[1]) + "' AND F1_FORNECE = '" + PADR(mv_par05, TamSX3("F1_FORNECE")[1]) + "' AND F1_LOJA = '" + PADR(mv_par06, TamSX3("F1_LOJA")[1]) + "' "
			cQuery	+= " ORDER BY F1_DTDIGIT, F1_FORMUL, F1_SERIE, F1_DOC "
			
			If Select(cAlias) > 0
				dbSelectArea(cAlias)
				dbCloseArea()
			EndIf
			
			TcQuery cQuery New Alias &cAlias
			
			(cAlias)->(DBGoTop())
			If (cAlias)->(!EOF())
				//	aErros := STARTJOB("U_ImpCompra",getenvserver(),.T.,cConectString, cServer, cEmpAnt, (cAlias)->F1_MSFIL, (cAlias)->F1_TIPO, (cAlias)->F1_SERIE, (cAlias)->F1_DOC, (cAlias)->F1_FORNECE, (cAlias)->F1_LOJA, StoD((cAlias)->F1_EMISSAO), (cAlias)->F1_ESPECIE, (cAlias)->F1_COND, (cAlias)->F1_FORMUL, (cAlias)->F1_FRETE, (cAlias)->F1_DESPESA,nConexao)
				aErros := U_ImpCompra(cConectString, cServer, cEmpAnt, (cAlias)->F1_MSFIL, (cAlias)->F1_TIPO, (cAlias)->F1_SERIE, (cAlias)->F1_DOC, (cAlias)->F1_FORNECE, (cAlias)->F1_LOJA, StoD((cAlias)->F1_EMISSAO), (cAlias)->F1_ESPECIE, (cAlias)->F1_COND, (cAlias)->F1_FORMUL, (cAlias)->F1_FRETE, (cAlias)->F1_DESPESA,nConexao,nxPort)
				If !aErros[1]
					MsgInfo( "Nota fiscal importada com sucesso!" )
				Else
					MsgAlert(aErros[2])
					//MsgAlert( "Nota fiscal nao importada! Favor entrar em contato com o administrador do sistema!" )
				EndIf
			Else
				MsgAlert( "Nota Fiscal nao localizada!" )
			EndIf
			
			(cAlias)->(dbCloseArea())
		Else
			// Se o tipo de nota fiscal for de saída
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Importacao das notas fiscais de saída  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Traz todas as notas fiscais de entrada que ainda não foram importadas e geraram livro fiscal
			cQuery	:= " SELECT F2_MSFIL,F2_EMISSAO,F2_DOC,F2_SERIE,F2_MSEXP,F2_CLIENTE,F2_LOJA,F2_TIPO,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_COD,D2_ITEM,D2_QUANT FROM " + RetSqlName("SF2") + " AS F2 "
			cQuery	+= " INNER JOIN " + RetSqlName("SD2") + " AS D2 ON D2.D_E_L_E_T_ <> '*' AND D2_FILIAL = F2_FILIAL AND D2_SERIE = F2_SERIE AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
			cQuery	+= " WHERE F2.D_E_L_E_T_ <> '*' AND F2_MSEXP = '' AND D2_ORIGLAN <> 'LO' AND F2_MSFIL = '" + mv_par02 + "' "
			cQuery	+= " AND F2_SERIE = '" + PADR(mv_par03, TamSX3("F2_SERIE")[1]) + "' AND F2_DOC = '" + PADR(mv_par04, TamSX3("F2_DOC")[1]) + "' AND F2_CLIENTE = '" + PADR(mv_par05, TamSX3("F2_CLIENTE")[1]) + "' AND F2_LOJA = '" + PADR(mv_par06, TamSX3("F2_LOJA")[1]) + "' "
			cQuery	+= " ORDER BY F2_MSFIL, F2_EMISSAO, F2_SERIE, F2_DOC "
			
			If Select("QRYPROD") > 0
				dbSelectArea("QRYPROD")
				QRYPROD->(dbCloseArea())
			EndIf
			
			TcQuery cQuery New Alias "QRYPROD"
			
			If QRYPROD->(!EOF())
				
				dbSelectArea("QRYPROD")
				QRYPROD->(DBGoTop())
				While QRYPROD->(!EOF())
					
					aAdd( aItem, {F2_MSFIL   , QRYPROD->F2_MSFIL     } )
					aAdd( aItem, {F2_EMISSAO , QRYPROD->F2_EMISSAO   } )
					aAdd( aItem, {F2_DOC     , QRYPROD->F2_DOC       } )
					aAdd( aItem, {F2_SERIE   , QRYPROD->F2_SERIE     } )
					aAdd( aItem, {F2_MSEXP   , QRYPROD->F2_MSEXP     } )
					aAdd( aItem, {F2_CLIENTE , QRYPROD->F2_CLIENTE   } )
					aAdd( aItem, {F2_LOJA    , QRYPROD->F2_LOJA      } )
					aAdd( aItem, {F2_TIPO    , QRYPROD->F2_TIPO      } )
					aAdd( aItem, {D2_NFORI   , QRYPROD->D2_NFORI     } )
					aAdd( aItem, {D2_SERIORI , QRYPROD->D2_SERIORI   } )
					aAdd( aItem, {D2_ITEMORI , QRYPROD->D2_ITEMORI   } )
					aAdd( aItem, {D2_COD     , QRYPROD->D2_COD       } )
					aAdd( aItem, {D2_ITEM    , QRYPROD->D2_ITEM      } )
					aAdd( aItem, {D2_QUANT   , QRYPROD->D2_QUANT     } )
					aAdd(aItens, aItem)
					aItem := {}
					QRYPROD->(DBSkip())
					
				End
				
				QRYPROD->(DBCLOSEAREA())
				TCUnLink(nConexao)
				
				DBSELECTAREA("SD1")
				IF !(aItens[1][1][2] == XFILIAL("SD1"))
					cFilAtu := cFilAnt //Grava a Filial corrente
					cFilant := aItens[1][1][2]
					lAuto := .T.
					
					dbselectarea("SM0")
					SM0->(dbsetorder(1))
					SM0->(dbseek(SM0->M0_CODIGO + cFilant))
				Endif
				PADR(mv_par04, TamSX3("F2_DOC")[1])
				
				If 	aItens[1][8][2] == "D"
					FOR i := 1 TO Len(aItens)
						cXCHAVE := PADR(alltrim(aItens[i][1][2]) ,TAMSX3("D1_FILIAL")[1])
						cXCHAVE += PADR(ALLTRIM(aItens[i][9][2]) ,TAMSX3("D1_DOC")[1])
						cXCHAVE += PADR(ALLTRIM(aItens[i][10][2]),TAMSX3("D1_SERIE")[1])
						cXCHAVE += PADR(ALLTRIM(aItens[i][6][2]) ,TAMSX3("D1_FORNECE")[1])
						cXCHAVE += PADR(ALLTRIM(aItens[i][7][2]) ,TAMSX3("D1_LOJA")[1])
						cXCHAVE += PADR(SUBSTRING(ALLTRIM(aItens[i][12][2]),1,7),TAMSX3("D1_COD")[1])
						cXCHAVE += PADR(ALLTRIM(aItens[i][11][2]),TAMSX3("D1_ITEM")[1])
						
						SD1->(DBSETORDER(1))
						//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
						If SD1->(DBSEEK( cXCHAVE ))
							IF !(aItens[i][14][2] <= (SD1->D1_QUANT-SD1->D1_QTDEDEV))
								MSGSTOP("Não há quantidade a devolver do codigo: " + PADR(SUBSTRING(ALLTRIM(aItens[i][12][2]),1,7),TAMSX3("D1_COD")[1]) + ", Item: " + ALLTRIM(aItens[i][11][2]) +  CRLF + ;
								"da Nota Fiscal Origem " + ALLTRIM(aItens[i][9][2]) +  " Serie " + ALLTRIM(aItens[i][10][2]) + " no Ambiente TEF!" + CRLF + ;
								"Por favor verificar essa NF de entrada para que possa realizar a" + CRLF + ;
								"Importação da NF de saida do Ambiente Produção!","Importação Cancelada!")
								IF lAuto
									cFilAnt := cFilAtu
									SM0->(dbsetorder(1))
									SM0->(dbseek(SM0->M0_CODIGO + cFilant))
								ENDIF
								RETURN
							ENDIF
							
							// Traz todas as notas fiscais de entrada que ainda não foram importadas e geraram livro fiscal
							cQuery	:= " SELECT C6_NUM,C6_PRODUTO,C6_NFORI,C6_SERIORI,C6_ITEMORI,SUM(C6_QTDVEN) AS 'C6_QTDVEN',SUM(D1_QUANT-D1_QTDEDEV) AS 'D1_QTDEDEV' FROM " + RetSqlName("SC6") + " AS C6 "
							cQuery	+= " INNER JOIN " + RetSqlName("SD1") + " AS D1 ON D1.D_E_L_E_T_ = '' AND C6_NFORI=D1_DOC AND C6_SERIORI=D1_SERIE AND C6_ITEMORI=D1_ITEM "
							cQuery	+= " WHERE C6.D_E_L_E_T_=''   AND C6_NOTA= '' AND C6_FILIAL = '" + mv_par02 + "' AND C6_PRODUTO = '" + PADR(SUBSTRING(ALLTRIM(aItens[i][12][2]),1,7),TAMSX3("C6_PRODUTO")[1]) + "' "
							cQuery	+= " AND C6_ITEMORI = '" + ALLTRIM(aItens[i][11][2]) + "' AND C6_SERIORI = '" + ALLTRIM(aItens[i][10][2]) + "' AND C6_NFORI = '" + ALLTRIM(aItens[i][9][2]) + "' "
							cQuery	+= " AND C6_CLI = '" + PADR(ALLTRIM(aItens[i][6][2]) ,TAMSX3("C6_CLI")[1]) + "' AND C6_LOJA = '" + PADR(ALLTRIM(aItens[i][7][2]) ,TAMSX3("C6_LOJA")[1]) + "' "
							cQuery	+= " GROUP BY C6_NUM,C6_PRODUTO,C6_NFORI,C6_SERIORI,C6_ITEMORI,C6_CLI,C6_LOJA "
							
							If Select("QRYVAL") > 0
								dbSelectArea("QRYVAL")
								QRYVAL->(dbCloseArea())
							EndIf
							
							TcQuery cQuery New Alias "QRYVAL"
							
							dbSelectArea("QRYVAL")
							QRYVAL->(DBGoTop())
							
							IF QRYVAL->(!EOF())
								
								While QRYVAL->(!EOF())
									
									nQtdPED  += QRYVAL->C6_QTDVEN
									nQTDNF   += QRYVAL->D1_QTDEDEV
									cPedidos += QRYVAL->C6_NUM + ", "
									nValMens := nValMens + 1
									QRYVAL->(DBSkip())
								End
								
								
								If nValMens > 1
									cMensPed1 := "Existem Pedidos de Vendas abertos de Números: "
									cMensPed2 := "Por favor verificar os Pedidos de Vendas para que possa realizar a"
								Else
									cMensPed1 := "Existe Pedido de Venda aberto de Números: "
									cMensPed2 := "Por favor verificar o Pedido de Venda para que possa realizar a"
								endif
								
								IF (nQtdPED  >= nQTDNF)
									
									MSGSTOP(cMensPed1 + cPedidos  + " Filial: " + mv_par02  + CRLF + ;
									"referente ao Produto : " + ALLTRIM(aItens[i][12][2]) + ", Item: " + ALLTRIM(aItens[i][11][2]) +  CRLF + ;
									"da Nota Fiscal Origem " + ALLTRIM(aItens[i][9][2]) +  " Serie " + ALLTRIM(aItens[i][10][2]) + " no Ambiente TEF!" + CRLF + ;
									cMensPed2 + CRLF + ;
									"Importação da NF de saida do Ambiente Produção!","Importação Cancelada!")
									IF lAuto
										cFilAnt := cFilAtu
										SM0->(dbsetorder(1))
										SM0->(dbseek(SM0->M0_CODIGO + cFilant))
										lAuto := .F.
									ENDIF
									QRYVAL->(dbCloseArea())
									RETURN
									
								ENDIF
							ENDIF
						Else
							MSGSTOP("Não Existe Nota Fiscal Origem " + ALLTRIM(aItens[i][9][2]) +  " Serie " + ALLTRIM(aItens[i][10][2]) + " no Ambiente TEF!" + CRLF + ;
							"Por favor Lançar essa NF de entrada para que possa realizar a"  + CRLF + ;
							"Importação da NF de saida do Ambiente Produção!","Importação Cancelada!")
							IF lAuto
								cFilAnt := cFilAtu
								SM0->(dbsetorder(1))
								SM0->(dbseek(SM0->M0_CODIGO + cFilant))
								lAuto := .F.
							ENDIF
							RETURN
						Endif
					Next i
					
				Endif
				
				IF lAuto
					cFilAnt := cFilAtu
					SM0->(dbsetorder(1))
					SM0->(dbseek(SM0->M0_CODIGO + cFilant))
				ENDIF
				
				aErros := U_ImpVenda(cConectString, cServer, cEmpAnt,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,nxPort,aItens[1][8][2])
				If !aErros[1]
					MsgInfo ("Nota fiscal importada com sucesso!")
				Else
					MsgAlert(aErros[2])
					//MsgAlert ("Nota fiscal nao importada! Favor entrar em contato com o administrador do sistema!") 
					Return 
				EndIf
			Else
				QRYPROD->(DBCLOSEAREA())
				TCUnLink(nConexao)
				MsgAlert ("Nota Fiscal não Localizada no Ambiente Produção!")
				RETURN
			ENDIF
			//	(cAlias)->(dbCloseArea())
		EndIf
	EndIf
	//	TCUnLink(nConexao)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CriaPerg ³ Autor ³ Herbert Ayres         ³ Data ³ 04/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria grupo de perguntas.                                  .³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄaÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revisao  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaPerg(cPerg)

Local aRegs  := {}
Local aHelps := {}
Local I

// mv_par01 = Almazem

SX1->(dbSetOrder(1))

// Numeracao dos campos:

// 01 -> X1_GRUPO   02 -> X1_ORDEM    03 -> X1_PERGUNT  04 -> X1_PERSPA  05 -> X1_PERENG
// 06 -> X1_VARIAVL 07 -> X1_TIPO     08 -> X1_TAMANHO  09 -> X1_DECIMAL 10 -> X1_PRESEL
// 11 -> X1_GSC     12 -> X1_VALID    13 -> X1_VAR01    14 -> X1_DEF01   15 -> X1_DEFSPA1
// 16 -> X1_DEFENG1 17 -> X1_CNT01    18 -> X1_VAR02    19 -> X1_DEF02   20 -> X1_DEFSPA2
// 21 -> X1_DEFENG2 22 -> X1_CNT02    23 -> X1_VAR03    24 -> X1_DEF03   25 -> X1_DEFSPA3
// 26 -> X1_DEFENG3 27 -> X1_CNT03    28 -> X1_VAR04    29 -> X1_DEF04   30 -> X1_DEFSPA4
// 31 -> X1_DEFENG4 32 -> X1_CNT04    33 -> X1_VAR05    34 -> X1_DEF05   35 -> X1_DEFSPA5
// 36 -> X1_DEFENG5 37 -> X1_CNT05    38 -> X1_F3       39 -> X1_GRPSXG

// Campos:   01     02           03            04  05    06     07 08                      0910 11           12         13          14  		 15 16     17    18      19      20 21     22    23      24      25 26    27     28      29      30 31    32     33      34      35 36    37       38     39
//Monta as perguntas utilizadas no relatorio
AAdd(aRegs,{cPerg, "01", "Tipo NF ?         ", "", "","mv_cha","N", 1 					   ,0,1,"C",""					,"mv_par01","Entrada"	,"","",""		,"","Saida"	 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""})
AAdd(aRegs,{cPerg, "02", "Filial ?          ", "", "","mv_chb","C", TamSX3("F2_FILIAL")[1] ,0,0,"G","NaoVazio(mv_par02)","mv_par02",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"SM0EMP",""})
AAdd(aRegs,{cPerg, "03", "Serie ?           ", "", "","mv_chc","C", TamSX3("F2_SERIE")[1]  ,0,0,"G","NaoVazio(mv_par03)","mv_par03",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""})
AAdd(aRegs,{cPerg, "04", "Nota fiscal ?     ", "", "","mv_chd","C", TamSX3("F2_DOC")[1]	   ,0,0,"G","NaoVazio(mv_par04)","mv_par04",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""})
AAdd(aRegs,{cPerg, "05", "Cliente/Fornecedor", "", "","mv_che","C", TamSX3("F2_CLIENTE")[1],0,0,"G","NaoVazio(mv_par05)","mv_par05",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""})
AAdd(aRegs,{cPerg, "06", "Loja ?            ", "", "","mv_chf","C", TamSX3("F2_LOJA")[1]   ,0,0,"G","NaoVazio(mv_par06)","mv_par06",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""		 	,"","",""		,"",""})

For i := 1 To Len(aRegs)
	
	If ! SX1->(dbSeek(cPerg+aRegs[i,2]))
		SX1->(RecLock("SX1", .T.))
		
		For j :=1 to SX1->(FCount())
			
			If j <= Len(aRegs[i])
				SX1->(FieldPut(j,aRegs[i,j]))
			Endif
		Next
		
		SX1->(MsUnlock())
	Endif
Next

aHelps = {}
//              Ordem   1234567890123456789012345678901234567890    1234567890123456789012345678901234567890    1234567890123456789012345678901234567890
AADD ( aHelps, {"01", {"Informe o tipo da nota fiscal:          ", "1-Entrada ou 2-Saida.                   ", "                                        "}})
AADD ( aHelps, {"02", {"Informe a filial onde a nota fiscal foi ", "lançada.                                ", "                                        "}})
AADD ( aHelps, {"03", {"Informe a serie da nota fiscal.         ", "                                        ", "                                        "}})
AADD ( aHelps, {"04", {"Informe o numero da nota fiscal.        ", "                                        ", "                                        "}})
AADD ( aHelps, {"05", {"Informe o codigo do cliente ou fornecedo", "r.                                      ", "                                        "}})
AADD ( aHelps, {"06", {"Informe a loja do cliente ou fornecedor.", "                                        ", "                                        "}})

// Gera helps das perguntas
For i := 1 to Len (aHelps)
	PutSX1Help ("P." + cPerg + aHelps [i, 1] + ".", aHelps [i, 2], {}, {})
Next

Return nil
