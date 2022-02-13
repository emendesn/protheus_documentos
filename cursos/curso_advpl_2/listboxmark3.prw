#Include "Protheus.ch"

/*****
 * 
 * Função principal
 *
 */
User Function LstBxMr3()
	
	Local cTitulo := "Pesquisa de satisfação"
	Local oDlg
	Local oLbx
	Local oTBtn
	
	Private oTPane1
	Private oTPane2	
	Private aVALOR := {}
	Private aHeader := {}
	Private aDADOS := {}
	Private nValor := 0
	
	aAdd( aVALOR, 0 )  //nada, criado apenas para coincidir o elemento do vetor na busca.
	aAdd( aVALOR, 10 ) //péssio
	aAdd( aVALOR, 20 ) //regular
	aAdd( aVALOR, 30 ) //bom
	AAdd( aVALOR, 40 ) //ótimo
	
	AAdd( aHeader, {"1 - Instrutor",1,5} )
	AAdd( aHeader, {"2 - Material didático",6,9} )
	AAdd( aHeader, {"3 - Infra-estrutura",10,14} )
	
	AAdd( aDADOS, {"[ 1/1 ]-Pontualidade (início e término de aula, saída e retorno para intervalo)."             ," "," "," "," "} )
	AAdd( aDADOS, {"[ 1/2 ]-Habilidade em promover a participação do grupo e/ou aluno."                           ," "," "," "," "} )
	AAdd( aDADOS, {"[ 1/3 ]-Clareza e concisão de raciocínio e linguagem (o assunto explicado foi compreensível)."," "," "," "," "} )
	AAdd( aDADOS, {"[ 1/4 ]-O instrutor demonstrou conhecimento necessário em relação ao assunto abordado."       ," "," "," "," "} )
	AAdd( aDADOS, {"[ 1/5 ]-Postura (educação, cordialidade, ética)."                                             ," "," "," "," "} )
	
	AAdd( aDADOS, {"[ 2/1 ]-Exercícios (promoveram a fixação do aprendizado)."                                    ," "," "," "," "} )
	AAdd( aDADOS, {"[ 2/2 ]-Base de dados /software utilizado."                                                   ," "," "," "," "} )
	AAdd( aDADOS, {"[ 2/3 ]-Utilização prática da apostila (adequado para futuras consultas)."                    ," "," "," "," "} )
	AAdd( aDADOS, {"[ 2/4 ]-Apresentação das informações (seleção e organização de fácil compreensão)	"           ," "," "," "," "} )
	
	AAdd( aDADOS, {"[ 3/1 ]-Equipamentos (rede, computadores, data show)."                                        ," "," "," "," "} )
	AAdd( aDADOS, {"[ 3/2 ]-Móveis e utensílios (conservação /apresentação visual, comodidade). "                 ," "," "," "," "} )
	AAdd( aDADOS, {"[ 3/3 ]-Acomodações e instalações (sala, acústica, iluminação, espaço)."                      ," "," "," "," "} )
	AAdd( aDADOS, {"[ 3/4 ]-Atendimento e serviços em geral."                                                     ," "," "," "," "} )
	AAdd( aDADOS, {"[ 3/5 ]-Processo de divulgação e inscrição."                                                  ," "," "," "," "} )
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 350,740 PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
	
		oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPane1:Align := CONTROL_ALIGN_TOP
	
	   @ 10,10 LISTBOX oLbx FIELDS HEADER ;
	   "Descrição", "Péssimo", "Regular","Bom", "Ótimo"  ;
	   ON DBLCLICK( Marcar(oLbx:nAt,oLbx:nColPos,@oLbx) ) ;
	   ON CHANGE MudaLinha(oLbx:nAt) ;
	   SIZE 230,95 OF oDlg PIXEL	
	
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:SetArray( aDADOS )
	
		oLbx:bLine := {|| {	aDADOS[oLbx:nAt,1],;
	 								aDADOS[oLbx:nAt,2],;
									aDADOS[oLbx:nAt,3],;
									aDADOS[oLbx:nAt,4],;
									aDADOS[oLbx:nAt,5]}}
	
		oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPane2:Align := CONTROL_ALIGN_BOTTOM
		
		oTBtn := TButton():New( 1, 1, "Sair", oTPane2, {|| iif(valida(),oDlg:End(),nil) }, 36, 36, , , .T., .T., , , , , , )
		oTBtn:Align := CONTROL_ALIGN_RIGHT								
	ACTIVATE MSDIALOG oDlg CENTER
Return

/*****
 * 
 * Função para marcar o quesito
 *
 */
Static Function Marcar( nLin, nCol, oObj )
	Local nTem := 0
	
	If nCol == 1
		Return
	Endif
	
	nTem := AScan( aDADOS[nLin], {|x| AllTrim(x)=="X" }, 2 )	
   If nTem > 0
		aDADOS[ nLin, nTem ] := " "  	
  		nValor := nValor - aValor[nTem]
		If nTem <> nCol
			aDADOS[ nLin, nCol ] := PadC("X",9)
  			nValor := nValor + aValor[nCol]
  		Endif
   Elseif nCol > 1
   	aDADOS[ nLin, nCol ] := PadC("X",9)
   	nValor += aValor[nCol]
   Endif
   
	oObj:Refresh()
	oTPane2:SetText("Total de pontos: "+Transform(nValor,"@E 9,999"))
Return

/*****
 * 
 * Função para atualiza o texto quando mudar de linha
 *
 */
Static Function MudaLinha( nLin )
	Local nP := 0
	
	nP := AScan( aHeader, {|x| nLin >= x[2] .And. nLin <= x[3] } )
	oTPane1:SetText( "Quesito: " + aHeader[ nP, 1 ] )
Return

/*****
 * 
 * Função para validar se todos os quesitos estão marcados
 *
 */
Static Function Valida()
	Local lRet := .T.
	Local nI := 0
	Local nTem := 0
	
	For nI := 1 To Len( aDADOS )
		nTem := AScan( aDADOS[nI], {|x| AllTrim(x)=="X" }, 2 )
		If nTem == 0
			MsgInfo("É necessário informar todas as qualificações por quesito, informar linha: "+AllTrim(Str(nI)))
			lRet := .F.
			Exit
		Endif
	Next nI
Return( lRet )