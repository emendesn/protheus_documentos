#INCLUDE "PROTHEUS.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TBICONN.CH"

/*
	Workflow de Liberação de Pedido de Compras 
*/

/* É necessário cadastrar o processo e os status conforme usado na função Track */

User Function WFW120P()
Local oProcess
Local lAprovado := .t.
Local xpedido := SC7->C7_NUM 
Local cxxpath := getPvProfString(getenvserver(),"ROOTPATH","ERROR", GETADV97())
// \\172.16.0.10\MP8\Protheus_DataTST


Private amailto    := {}
Private ntotaprova := 0
Private aAprova:={}                                       
Private nAt := 1
Private cXmail := ''

u_GerA0003(ProcName())

/* Verifica se e necessario enviar e-mail de aprovacao do pedido de compras */
SC7->(DBSETORDER(1))
SC7->(dbSeek(xFilial('SC7')+xPedido))
While ! SC7->(Eof()) .and. SC7->C7_NUM = xPedido .AND.  XFILIAL("SC7") = SC7->C7_FILIAL
	If   SC7->C7_CONAPRO <> 'L'
		lAprovado := .F.
		Exit
	Endif	
	SC7->(DBSKIP())
EndDo       
If lAprovado .OR.  "TST" $ ALLTRIM(cXXPath) // Pedido esta totalmente aprovado e nao e necessario enviar workflow de aprovacao
	Return // sai da rotina de workflow	
Endif
/* -------------------------------------------------------------------------*/ 


/*Monta a lista de e-mails dos aprovadores */
WF1->(DBSEEK(XFILIAL("WF1") + "PEDCOM" ))
cXmail:= alltrim(WF1->WF1_XEMAIL)
Do While .t.
	nAt:= At(';',cXmail)
	If nAt > 0        
		AADD (aMailto,substr(cXmail,1,At(';',cXmail) -1))
		cXmail := substr(cXmail,At(';',cXmail) + 1 )
		ntotaprova++
	Else                     
		ntotaprova++
		AADD (aMailto,cXmail)
		exit
	Endif
EndDo

/* Monta a lista de Aprovadores  e e-mails*/
DbSelectArea('SAL')
DbSetOrder(1)
DbSeek(XFilial("SAL") + "000001" ) // GRUPO DE APROVACAO ADMINISTRACAO GERAL
Do While ! SAL->(Eof()) .and. SAL->AL_COD = '000001'
	aadd(aAprova,ALLTRIM(SAL->AL_NOME) + ' - ' + SAL->AL_USER)
	SAL->(DbSkip())
EndDO




//Iniciou o Processo 

For nAt := 1 to nTotAprova                                     
	dbSelectArea('SC7')
	dbSetOrder(1)
	dbSeek(xFilial('SC7')+ xPedido)

	ConOut("Iniciando Processo - Aprovador " + alltrim(str(nat)) + ' - Pedido '  + xPedido )

	oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )    

	oProcess:NewTask( "Aprovação", "\WORKFLOW\APROVAPC.HTM" )
   
	oProcess:Track("100100",,"","PROCESSO")	
      
	oProcess:Track("100200",,"","DECISAO")	
	ConOut("INICIA_PC")


  //?	U_INICIAPC(oProcess,nAt)
	
Next
Return
                   
User Function INICIAPC(oProcess,nAt) 
Local aCond:={},nTotal := 0,cMailID,cSubject ,nfrete := 0, nipi := 0, NVALICMS := 0,NDESPESA:=0,NSEGURO:=0,NBASEICMS:= 0
oProcess:Track("100300",,"","ENVIAR MENSAGEM")	       
oProcess:cSubject := "Aprovacao de Pedido de Compra"
oProcess:bReturn := "U_RETORNO_PC"
oProcess:bTimeOut := {{"U_TIMEOUT_PC(1)",0, 2, 2 },{"U_TIMEOUT_PC(2)",0, 2, 4 }}
//oHTML := oProcess:oHTML
	                                        
cSubject := "APROVACAO DO PEDIDO No " + SC7->C7_NUM                                     
	
/*** Preenche os dados do cabecalho ***/
oProcess:oHtml:ValByName( "EMISSAO", SC7->C7_EMISSAO )
oProcess:oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE )    
dbSelectArea('SA2')
dbSetOrder(1)
dbSeek(xFilial('SA2')+SC7->C7_FORNECE) 
//Pego a condicao de Pagamento
dbSelectArea('SE4')
dbSeek(xFilial('SE4')+SC7->C7_COND)
oProcess:oHtml:ValByName( "lb_nome", SA2->A2_NOME )    
oProcess:oHtml:ValByName( "lb_cond", SC7->C7_COND + '-' + alltrim(SE4->E4_DESCRI) )    	
oProcess:oHtml:ValByName( "c7aprova", aAprova )    	
dbSelectArea('SC7')
oProcess:oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
oProcess:oHtml:ValByName( "COTACAO", IIF(EMPTY(SC7->C7_NUMCOT),' *** SEM COTACAO DE COMPRAS *** ', SPACE(1) + SC7->C7_NUMCOT) )
cNum := SC7->C7_NUM
oProcess:fDesc := "Pedido de Compras No "+ cNum
cAssunto := "Pedido de Compras No "+ cNum
dbSetOrder(1)
dbSeek(xFilial('SC7')+cNum)
While !Eof() .and. C7_NUM = cNum
	nTotal := nTotal + C7_TOTAL            
    nfrete := nfrete + C7_VALFRE
    nIpi   := nIPI   + C7_VALIPI
    nValICMS := nValIcms + C7_VALICM
    nDespesa := nDespesa + C7_DESPESA
    nSeguro := nSeguro + C7_SEGURO
    nBaseIcms := nBaseIcms + C7_BASEICMS
    AAdd( (oProcess:oHtml:ValByName( "produto.item" )),C7_ITEM )		
    AAdd( (oProcess:oHtml:ValByName( "produto.codigo" )),C7_PRODUTO )		       
    dbSelectArea('SB1')
    dbSetOrder(1)
    dbSeek(xFilial('SB1')+SC7->C7_PRODUTO)
    dbSelectArea('SC7')
    AAdd( (oProcess:oHtml:ValByName( "produto.produto" )),SB1->B1_DESC )		              
    AAdd( (oProcess:oHtml:ValByName( "produto.quant" )),TRANSFORM( C7_QUANT,'@E 999,999.99' ) )		              
    AAdd( (oProcess:oHtml:ValByName( "produto.preco" )),TRANSFORM( C7_PRECO,'@E 999,999,999.99' ) )		                     
    AAdd( (oProcess:oHtml:ValByName( "produto.total" )),TRANSFORM( C7_TOTAL,'@E 999,999,999.99' ) )		                     
    AAdd( (oProcess:oHtml:ValByName( "produto.unid" )),SB1->B1_UM )		              
    AAdd( (oProcess:oHtml:ValByName( "produto.entrega" )),DTOC(C7_DATPRF) )		                     
    WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)
    dbSkip()
Enddo
oProcess:oHtml:ValByName( "lbValor"   ,TRANSFORM( nTotal,  '@E 999,999,999.99' ) )		              	
oProcess:oHtml:ValByName( "lbDespesa" ,TRANSFORM( nDespesa,'@E 999,999,999.99' ) )		              	        
oProcess:oHtml:ValByName( "lbSeguro"  ,TRANSFORM( nSeguro ,'@E 999,999,999.99' ) )		              	    
oProcess:oHtml:ValByName( "lbIpi"     ,TRANSFORM( nIPI    ,'@E 999,999,999.99' ) )		              	    
oProcess:oHtml:ValByName( "lbIcms"    ,TRANSFORM( nValIcms,'@E 999,999,999.99' ) )		              	    
oProcess:oHtml:ValByName( "lbFrete"   ,TRANSFORM( nFrete  ,'@E 999,999,999.99' ) )		              	    
oProcess:oHtml:ValByName( "lbTotal"   ,TRANSFORM( nBaseIcms + nIpi + nvalicms,'@E 999,999,999.99' ) )		              	    
oProcess:ClientName( Subs(cUsuario,7,15) )

oProcess:UserSiga:=WFCodUser( SUBSTR(cUsuario,7,15))

oProcess:cTo := "PEDCOM"
/* monta um processo para cada aprovador */
	cMailId := oProcess:Start()            
	
	cHtmlModelo := "\workflow\wflink.htm"
	
	oProcess:NewTask(cAssunto, cHtmlModelo)
	
	oProcess:cSubject := cAssunto
	
	
	oProcess:cto := 'pedcom'
	
	oProcess:oHtml:ValByName("usuario","usuario")	
	
	oProcess:oHtml:ValByName("proc_link","http://172.16.0.10:8085/messenger/emp"+cempant+"/pedcom/"+ cMailID + ".htm")
	
	// Informe o endereço eletrônico do destinatário.
	WF1->(DBSEEK(XFILIAL("WF1") + "PEDCOM" ))
	If WF1->(FieldPos("WF1_XEMAIL")) > 0
		oProcess:cTo := aMailto[nat]  //Alltrim(WF1->WF1_XEMAIL)//"claudia.cabral@bgh.com.br"
	ELSE	
		oProcess:cTo := "claudia.cabral@bgh.com.br;edson.rodrigues@bgh.com.br"
	ENDIF	
	
	
		oProcess:oHtml:ValByName("referente",cAssunto)
		
		// Apos ter repassado todas as informacoes necessarias para o workflow, solicite a
		// a ser executado o método Start() para se gerado todo processo e enviar a mensagem
		// ao destinatário.
		oProcess:Start()

	
Return .T.

User Function RETORNO_PC(oProcess)
 local lSCR := .f.
 private cNumero := oProcess:oHtml:RetByName('Pedido') 
 ca097User := oProcess:oHtml:RetByName('c7aprova') // RetCodUsr() // retorna o numero do usuário no sistema
 ca097User := Right(ca097User,6)                                                      
 
 DBSelectarea("SCR")                   // Posiciona a Liberacao
 DBSetorder(2)
 If DBSeek(xFilial("SCR")+"PC" + oProcess:oHtml:RetByName('Pedido') )  
 	Do WhiLe ! SCR->(EOF()) .AND. SCR->CR_FILIAL = XFILIAL("SCR") .AND. SCR->CR_NUM = cNumero .AND. SCR->CR_TIPO = 'PC'
 		IF SCR->CR_USER = ca097User  
 			lscr := .t.
 			Exit
 		Endif
	 	SCR->(DBSKIP())
 	ENDDO
 EndIf
 if oProcess:oHtml:RetByName('RBAPROVA') <> 'Sim' .and. lSCR
      RecLock("SCR",.f.)
      SCR->CR_DataLib := dDataBase
      SCR->CR_Obs     := ""
      SCR->CR_STATUS  := "04"  //Bloqueado
      SCR->CR_OBS := oProcess:oHtml:RetByName('lbmotivo')
      MsUnLock()
      return .t.             
  endif  
  //Acerto o pedido
  oProcess:Track("100500",,"","APROVACAO")	         
//  DBSelectar("SCR")                   // Posiciona a Liberacao
//  DBSetorder(2)                    
 // DBSeek(xFilial("SCR")+"PC"+oProcess:oHtml:RetByName('Pedido')+ca097User)
  dbselectarea("SC7")
  DBSETORDER(1)
  DBSeek(xFilial("SC7")+oProcess:oHtml:RetByName('Pedido'))      // Posiciona o Pedido
  ConOut("********************************APROVACAO DO PEDIDO  " + SC7->C7_NUM )
  if lSCR
	  CONOUT("APROVADOR  DO SCR  " + SCR->CR_USER)	
  else                                              
  	 CONOUT("NAO ENCONTROU APROVADOR  NO SCR  " )	
  endif	  
  xLibera("SC7",SCR->(RECNO()))
  
  ConOut("Aprovando o Pedido")
  
  dbSelectArea('SC7')
  dbSetOrder(1)
  dbSeek(xFilial('SC7')+oProcess:oHtml:RetByName('Pedido'))
  
  oProcess:Track("100700",,"","TERMINADO")	          
   
Return .T.

User Function TIMEOUT_PC(n,oProcess)
   ConOut("Executando TimeOut:"+Str(n))
Return .T.                     

/* FUNCAO DE APROVACAO DO PEDIDO DE COMPRAS*/
Static Function  XLibera(cAlias,nReg)
Local aArea		:= GetArea()
Local aHeadCpos := {}
Local aHeadSize := {}
Local aArrayNF	:= {}
Local aCampos   := {}
Local aRetSaldo := {}

Local cObs 		:= IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
Local cTipoLim  := ""
Local CRoeda    := ""
Local cAprov    := ""
Local cName     := ""
Local cSavColor := ""
Local cGrupo	:= ""
Local cCodLiber := SCR->CR_APROV
Local cDocto    := SCR->CR_NUM
Local cTipo     := SCR->CR_TIPO
Local dRefer 	:= dDataBase
Local cPCLib	:= ""
Local cPCUser	:= ""
Local lMta097   := ExistBlock("MTA097")
Local lAprov    := .F.
Local lLiberou	:= .F.
Local lLibOk    := .F.
Local lContinua := .T.
Local lShowBut  := .T.

Local nSavOrd   := IndexOrd()
Local nSaldo    := 0
Local nOpc      := 2
Local nSalDif	:= 0
Local nTotal    := 0
Local nMoeda	:= 1
Local nX        := 1
Local nRecnoAS400:= 1

Local oDlg
Local oDataRef
Local oSaldo
Local oSalDif
Local oBtn1
Local oBtn2
Local oBtn3
Local oQual

If ExistBlock("MT097LIB")
	ExecBlock("MT097LIB",.F.,.F.)
EndIf

If ExistBlock("MT097LOK")
	lContinua := ExecBlock("MT097LOK",.F.,.F.)
	If ValType(lContinua) # 'L'
		lContinua := .T.
	Endif
EndIf

If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
	Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
	lContinua := .F.
ElseIf lContinua .And. SCR->CR_STATUS$"01"
	Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"aguardando outros niveis"}) //Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
	lContinua := .F.
EndIf
ConOut("********************************USUARIO DA APROVACAO DO PEDIDO  " + cA097user)
If lContinua
	dbSelectArea("SAL")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa as variaveis utilizadas no Display.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetSaldo := MaSalAlc(cCodLiber,dRefer)
	nSaldo 	  := aRetSaldo[1]
	CRoeda 	  := A097Moeda(aRetSaldo[2])
	cName  	  := UsrRetName(ca097User)
	nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	
	Do Case
	Case SAK->AK_TIPO == "D"
		cTipoLim :=OemToAnsi("Diario") // "Diario"
	Case  SAK->AK_TIPO == "S"
		cTipoLim := OemToAnsi("Semanal") //"Semanal"
	Case  SAK->AK_TIPO == "M"
		cTipoLim := OemToAnsi("Mensal") //"Mensal"
	Case  SAK->AK_TIPO == "A"
		cTipoLim := OemToAnsi("Anual") //"Anual"
	EndCase
	dbSelectArea("SC7")
	dbSetOrder(1)
	MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
	cGrupo := SC7->C7_APROV
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
	dbSelectArea("SAL")
	dbSetOrder(3)
	MsSeek(xFilial("SAL")+SC7->C7_APROV+SAK->AK_COD)
	
	If SAL->AL_LIBAPR != "A"
		lAprov := .T.
		cAprov := OemToAnsi("VISTO / LIVRE") // 
	EndIf
	nSalDif := nSaldo - IIF(lAprov,0,nTotal)
	If (nSalDif) < 0
		Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
		lContinua := .F.
	EndIf
EndIf

If lContinua
ConOut("continua "  )	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000055")
	If nOpc == 2 .Or. nOpc == 3
		SCR->(dbGoTo(nReg))
		lLibOk := .f. //A097Lock(Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)),SCR->CR_TIPO)
		dbSelectArea("SC7")
		dbSetOrder(1)
		If MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)))
			While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+cNumero
				If RecLock("SC7")
					lLibOk := .T.
				Else
					lLibOk := .F.
					Exit
				Endif
				dbSkip()
			EndDo
		EndIf
		dbSelectArea("SAL")
		If lLibOk
			Begin Transaction
				If lMta097 .And. nOpc == 2
					If ExecBlock("MTA097",.F.,.F.)
						lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
					EndIf
				Else
					lLiberou :=  MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,4)
					
				EndIf
				If lLiberou     
					CONOUT ("ENTROU NA SEGUNDA FASE DE LIBERACAO" )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PcoDetLan("000055","02","MATA097")
	
					If SuperGetMv("MV_EASY")=="S" .AND. SC7->(FieldPos("C7_PO_EIC"))<>0 .And. !Empty(SC7->C7_PO_EIC)
							If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. SW2->(FieldPos("W2_CONAPRO"))<>0 .AND. !Empty(SW2->W2_CONAPRO)
								Reclock("SW2",.F.)
								SW2->W2_CONAPRO := "L"
								MsUnlock()
							EndIf
					EndIf
					dbSelectArea("SC7")
					dbSetOrder(1)
				    MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)))
					cPCLib := SC7->C7_NUM
					cPCUser:= SC7->C7_USER
					While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
						Reclock("SC7",.F.)
						SC7->C7_CONAPRO := "L"
						MsUnlock()
						If ExistBlock("MT097APR")
							ExecBlock("MT097APR",.F.,.F.)
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						PcoDetLan("000055","01","MATA097")
						dbSkip()
					EndDo

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				    //³ Envia e-mail ao comprador ref. Liberacao do pedido para compra- 034³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					MEnviaMail("034",{cPCLib,SCR->CR_TIPO},cPCUser)
				EndIf
			End Transaction
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoFinLan("000055")
		Else
			Help(" ",1,"A097LOCK")
		Endif
		SC7->(MsUnlockAll())
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)             
	
	
	PcoFreeBlq("000055")
EndIf
dbSelectArea("SC7")
If ExistBlock("MT097END")
	ExecBlock("MT097END",.F.,.F.,{cDocto,cTipo,nOpc})
EndIf
RestArea(aArea)

Return Nil