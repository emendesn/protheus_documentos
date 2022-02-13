#Include "Protheus.ch"

/*****
 * 
 * Fun��o principal
 *
 */
User Function LstBxMr3()
	
	Local cTitulo := "Pesquisa de satisfa��o"
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
	aAdd( aVALOR, 10 ) //p�ssio
	aAdd( aVALOR, 20 ) //regular
	aAdd( aVALOR, 30 ) //bom
	AAdd( aVALOR, 40 ) //�timo
	
	AAdd( aHeader, {"1 - Instrutor",1,5} )
	AAdd( aHeader, {"2 - Material did�tico",6,9} )
	AAdd( aHeader, {"3 - Infra-estrutura",10,14} )
	
	AAdd( aDADOS, {"[ 1/1 ]-Pontualidade (in�cio e t�rmino de aula, sa�da e retorno para intervalo)."             ," "," "," "," "} )
	AAdd( aDADOS, {"[ 1/2 ]-Habilidade em promover a participa��o do grupo e/ou aluno."                           ," "," "," "," "} )
	AAdd( aDADOS, {"[ 1/3 ]-Clareza e concis�o de racioc�nio e linguagem (o assunto explicado foi compreens�vel)."," "," "," "," "} )
	AAdd( aDADOS, {"[ 1/4 ]-O instrutor demonstrou conhecimento necess�rio em rela��o ao assunto abordado."       ," "," "," "," "} )
	AAdd( aDADOS, {"[ 1/5 ]-Postura (educa��o, cordialidade, �tica)."                                             ," "," "," "," "} )
	
	AAdd( aDADOS, {"[ 2/1 ]-Exerc�cios (promoveram a fixa��o do aprendizado)."                                    ," "," "," "," "} )
	AAdd( aDADOS, {"[ 2/2 ]-Base de dados /software utilizado."                                                   ," "," "," "," "} )
	AAdd( aDADOS, {"[ 2/3 ]-Utiliza��o pr�tica da apostila (adequado para futuras consultas)."                    ," "," "," "," "} )
	AAdd( aDADOS, {"[ 2/4 ]-Apresenta��o das informa��es (sele��o e organiza��o de f�cil compreens�o)	"           ," "," "," "," "} )
	
	AAdd( aDADOS, {"[ 3/1 ]-Equipamentos (rede, computadores, data show)."                                        ," "," "," "," "} )
	AAdd( aDADOS, {"[ 3/2 ]-M�veis e utens�lios (conserva��o /apresenta��o visual, comodidade). "                 ," "," "," "," "} )
	AAdd( aDADOS, {"[ 3/3 ]-Acomoda��es e instala��es (sala, ac�stica, ilumina��o, espa�o)."                      ," "," "," "," "} )
	AAdd( aDADOS, {"[ 3/4 ]-Atendimento e servi�os em geral."                                                     ," "," "," "," "} )
	AAdd( aDADOS, {"[ 3/5 ]-Processo de divulga��o e inscri��o."                                                  ," "," "," "," "} )
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 350,740 PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
	
		oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPane1:Align := CONTROL_ALIGN_TOP
	
	   @ 10,10 LISTBOX oLbx FIELDS HEADER ;
	   "Descri��o", "P�ssimo", "Regular","Bom", "�timo"  ;
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
 * Fun��o para marcar o quesito
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
 * Fun��o para atualiza o texto quando mudar de linha
 *
 */
Static Function MudaLinha( nLin )
	Local nP := 0
	
	nP := AScan( aHeader, {|x| nLin >= x[2] .And. nLin <= x[3] } )
	oTPane1:SetText( "Quesito: " + aHeader[ nP, 1 ] )
Return

/*****
 * 
 * Fun��o para validar se todos os quesitos est�o marcados
 *
 */
Static Function Valida()
	Local lRet := .T.
	Local nI := 0
	Local nTem := 0
	
	For nI := 1 To Len( aDADOS )
		nTem := AScan( aDADOS[nI], {|x| AllTrim(x)=="X" }, 2 )
		If nTem == 0
			MsgInfo("� necess�rio informar todas as qualifica��es por quesito, informar linha: "+AllTrim(Str(nI)))
			lRet := .F.
			Exit
		Endif
	Next nI
Return( lRet )