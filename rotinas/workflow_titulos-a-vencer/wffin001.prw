#INCLUDE "TBICONN.CH "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFFIN001  º Autor ³Paulo Bindo         º Data ³  19/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Programa que gera workflow dos titulos a vencer conforme pa-º±±
±±º          ³metro e cadastro do cliente                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function WFFIN()
Local nDias := 0
Local dDias := Date() - nDias  //calcula a data para envio
Local cLojaCli, cDescri,oProcess,oHtml

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ConOut(Repl("-",80))
ConOut(PadC("WorkFlow de Envio de Títulos a Receber",80))

PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "01" ) MODULO "FIN"

nDias := GetMV("MV_DIASF") //parametro com o numero de dias que sera subtraido da database



dbSelectArea("SE1")
dbGoTop()
dbSetOrder(7)
If dbSeek(xFilial("SE1")+ DtoS(dDias))
	
	While !EOF() .And. E1_VENCREA == dDias
		//caso o titulo nao seja do tipo NF ou DP da um skip
		If !E1_TIPO $ "NF |DP "
			dbSkip()
			Loop
		EndIf
		
		//caso o cliente não deseja receber e-mail retorna
		cEnvMail:= Posicione("SA1",1,xFilial("SA1")+E1_CLIENTE+E1_LOJA,"A1_ENVMAIL")
		If cEnvMail == "N"
			dbSkip()
			Loop
		EndIf
		
		//FUNCOES PARA ENVIO DE HTML
		oProcess:=TWFProcess():New("WF_FIN","Títulos a Vencer")
		oProcess:NewTask('Inicio',"\WORKFLOW\HTM\FINWF001.htm")
		oHtml   := oProcess:oHtml
		
		dbSelectArea("SE1")
		oHtml:ValByName("cliente"   ,E1_CLIENTE+"-"+E1_NOMCLI) //codigo e nome reduzido do cliente
		
		//titulos
		oHtml:ValByName("it1.nota" 	     , {})
		oHtml:ValByName("it1.serie"      , {})
		oHtml:ValByName("it1.emissao"    , {})
		oHtml:ValByName("it1.vencto"     , {})
		oHtml:ValByName("it1.total"      , {})
		//itens da nota
		oHtml:ValByName("it.nota"   	, {})
		oHtml:ValByName("it.item"   	, {})
		oHtml:ValByName("it.produto"    , {})
		oHtml:ValByName("it.qtde"      	, {})
		oHtml:ValByName("it.vunit"      , {})
		oHtml:ValByName("it.total"      , {})
		
		
		cLojaCli := E1_CLIENTE+E1_LOJA //armazena os codigos iniciais
		
		//enquanto for o mesmo cliente adiociona os dados
		While !EOF() .And. E1_CLIENTE+E1_LOJA == cLojaCli .And. E1_VENCREA == dDias
			
			//caso o titulo nao seja do tipo NF ou DP da um skip
			If !E1_TIPO $ "NF |DP "
				dbSkip()
				Loop
			EndIf
			
			aadd(oHtml:ValByName("it1.nota"		) 	, E1_NUM)
			aadd(oHtml:ValByName("it1.serie"	)  	, E1_SERIE)
			aadd(oHtml:ValByName("it1.emissao"	) 	, DtoC(E1_EMISSAO))
			aadd(oHtml:ValByName("it1.vencto"	)  	, DtoC(E1_VENCREA))
			aadd(oHtml:ValByName("it1.total"	)  	, TRANSFORM( E1_VALOR ,'@R 9999,999.99'))
			
			//busca os itens da nota de saida
			dbSelectArea("SD2")
			dbSetOrder(3)
			If dbSeek(xFilial()+SE1->E1_NUM+SE1->E1_SERIE)
				
				While !EOF() .And. SE1->E1_NUM+SE1->E1_SERIE == D2_DOC+D2_SERIE
					cDescri := IIF(!Empty(Posicione("SB5",1,xFilial("SB5")+D2_COD,"B5_CEME")),Posicione("SB5",1,xFilial("SB5")+D2_COD,"B5_CEME"),Posicione("SB1",1,xFilial("SB1")+D2_COD,"B1_DESC")) //pega a descricao do produto
					
					aadd(oHtml:ValByName("it.nota"		)     , D2_DOC)
					aadd(oHtml:ValByName("it.item"		)     , D2_ITEM)
					aadd(oHtml:ValByName("it.produto"	)	, D2_COD+"-"+cDescri)
					aadd(oHtml:ValByName("it.qtde"		)	, TRANSFORM( D2_QUANT  ,'@E 9999999.99'  ))
					aadd(oHtml:ValByName("it.vunit"		)  	, TRANSFORM( D2_PRCVEN ,'@R 9999,999.99' ))
					aadd(oHtml:ValByName("it.total"		)  	, TRANSFORM( D2_TOTAL  ,'@R 9999,999.99' ))
					dbSkip()
				End
				dbSelectArea("SE1")
			EndIf
			//coloca espaco em branco entre uma nota e outra
			aadd(oHtml:ValByName("it.nota")    	,"")
			aadd(oHtml:ValByName("it.item")    	,"")
			aadd(oHtml:ValByName("it.produto")	,"")
			aadd(oHtml:ValByName("it.qtde")   	,"")
			aadd(oHtml:ValByName("it.vunit")  	,"")
			aadd(oHtml:ValByName("it.total")  	,"")
			
			cLojaCli := E1_CLIENTE+E1_LOJA
			dbSkip()
		End
		oHtml:ValByName("observacao"   ,"Teste de mensagem") //observacao
		//envia o e-mail
		cUser 				:= Subs(cUsuario,7,15)
		oProcess:ClientName(cUser)
		oProcess:cTo    	:= Posicione("SA1",1,xFilial("SA1")+E1_CLIENTE+E1_LOJA,"A1_EMAIL")
		subj 				:= "Títulos a Vencer"
		oProcess:cSubject  	:= subj
		oProcess:Start()
		
		dbSkip()
	End
EndIf

//fecha a conexão
ConOut("Fim  : "+Time())
RESET ENVIRONMENT

Return
