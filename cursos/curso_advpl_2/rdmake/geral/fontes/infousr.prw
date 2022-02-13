#Include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Infousr  � Autor �Edson/Gilberto      � Data �  10/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera relatorio com informacoes de  Acessos as rotinas e    ���
���          � menus dos usu�rios                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico  BGH                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                         

User Function Infousr2()

//�������������������������Ŀ
//� Declaracao de Variaveis �
//���������������������������
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {"ID Usuario","Nome Usuario"}
Private titulo       := "Relatorio Especifico de Acesso a menus e rotinas do sistema pelos Usuarios"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private tamanho      := "M"
Private nomeprog     := "Infousr"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private cPerg        := "INFOUSR"
Private m_pag        := 01
Private wnrel        := "Infousr"
Private cString      := ""

u_GerA0003(ProcName())

//AjustSXB()  // SXB => Consulta padrao baseada no Dicionario de Dados .

AjustSX1()

Pergunte(cPerg,.F.)

//�������������������������������������������Ŀ
//� Monta a interface padrao com o usuario... �
//���������������������������������������������
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.) // tela para digitar parametro >> Usuario De/Ate, digito ou branco para rotina e modulo  

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)  // tela ja existe relatorio, deseja substituir ?

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
 
//
// Aqui voce vai montar os seu arquivo .csv atraves de um array que ser� alimentado atraves da fun�ao Runreport, que abrira em excel.
//

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/02/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem   := aReturn[8]
Local aIdiomas := {"Portugues","Ingles","Espanhol"}
Local aTipoImp := {"Em Disco","Via Spool","Direto na Porta","E-Mail"}
Local aFormImp := {"Retrado","Paisagem"}
Local aAmbImp  := {"Servidor","Cliente"}
Local aColAcess:= {000,040,080}
Local aColMenus:= {000,044,088}
Local aAllUsers:= AllUsers()// A funcao AllUsers() retorna um vetor principal onde cada elemento refere-se a um usuario do sistema,
							//estes elementos sao compostos de um vetor multidimensional subdividindo as informacoes dos usuarios.
Local aUser    := {}
Local i        := 0 // for de Usuarios == 895 /    ( 837  //* 29/09/2011	lFiltroGrp := .F. // 838 )
Local k        := 0 // for de modulos
Local j        := 0 // for de menus
Local aMenu
Local nID

aModulos := fModulos() // "K"
aAcessos := fAcessos() // "J"
                                   

For i:= 1 to len(aAllUsers)// "len" => Retorna o tamanho da string especificada no parametro.
lFiltroGrp := .F.
	  				 
		If (aAllUsers[i][01][01]) >= AllTrim(mv_par01) .and. (aAllUsers[i][01][01]) <= AllTrim(mv_par02) // mesmo apos ter encontrado o usuario continua lendo ate o fim.     
	             
	    //�����������������������������������������������������������Ŀ
		//� Se o usuario nao tiver um grupo, inclui um elemento vazio �
		//�������������������������������������������������������������
		If Len(aAllUsers[i][01][10])==0
			aAdd(aAllUsers[i][01][10],Space(06)) // ([1],[1],[10],[1] cria espaco de 6 caracteres em branco 
		Endif
		
	   	For k := 1 to Len(aAllUsers[i][01][10])// "len" => Retorna o tamanho da string especificada no parametro.     
	   		If	aAllUsers[i][01][01] >= AllTrim(mv_par01) .and. aAllUsers[i][01][01] <= AllTrim(mv_par02)   // procura ID do usuario pela funcao allusers 
			//If aAllUsers[i][01][10][k] >= mv_par05 .and.;
			//	aAllUsers[i][01][10][k] <= mv_par06
				aAdd(aUser,aAllUsers[i]) // adiciona em aUser a linha do laco "I" que esta posicionado no aAllUsers
			  exit
			Endif
			
		Next k      // penso que neste ponto ele deveria pegar apenas os usuarios que estao no mv_par01 e mv_par02 para incluir no array 
	Endif
 Next i // le todos usuarios que existem cadastrados.
//���������������
//� Indexa Aray �
//���������������
If nOrdem==1      //ID
	aSort(aUser,,,{ |aVar1,aVar2| aVar1[1][1] < aVar2[1][1]})  // organiza usuarios
  Else            //Usuario
	aSort(aUser,,,{ |aVar1,aVar2| aVar1[1][2] < aVar2[1][2]})
Endif

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(Len(aUser))

//�������������������Ŀ
//� Processa Usuarios �
//���������������������
For i:=1 to Len(aUser)  // a letra "i" == 838 usuarios encontrados 
	IncRegua()
	
	//����������������������������������Ŀ
	//� Desconsidera Usu�rios Bloqueados �
	//������������������������������������
	//If aUser[i][01][17] .and. mv_par12==1
	//	Loop
	//Endif
	 
//* Comeco aqui a deslocar para baixo:
// * ===============================================================================================================================	

   IF aUser[i][01][01] >= AllTRim(MV_PAR01)  .AND. aUser[i][01][01] <= AllTrim(MV_PAR02)// abaixo mostra todos usuarios encontrados que fora informados no De/Para.

		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
		
		@ nLin,000 pSay "I N F O R M A C O E S   D O   U S U A R I O"
		nLin+=1
		@ nLin,000 pSay "User ID.........................: "+aUser[i][01][01] //ID   // neste ponto mesmo que usuario nao tem a rotina mata020 ele traz o usuario e deixa em 
		nLin+=1                                                //\\ branco a parte de baixo do menu, caso objetivo e nao aparecer usuario que nao tem a rotina tera que ser interceptado aqui.
		@ nLin,000 pSay "Usuario.........................: "+aUser[i][01][02] //Usuario
		nLin+=1
		@ nLin,000 pSay "Nome Completo...................: "+aUser[i][01][04] //Nome Completo
		nLin+=1
		@ nLin,000 pSay "Validade........................: "+DTOC(aUser[i][01][06]) //Validade
		nLin+=1
		@ nLin,000 pSay "Acessos para Expirar............: "+AllTrim(Str(aUser[i][01][07])) //Expira em n acessos
		nLin+=1
		@ nLin,000 pSay "Autorizado a Alterar Senha......: "+If(aUser[i][01][08],"Sim","Nao") //Autorizado a Alterar Senha
		nLin+=1
		@ nLin,000 pSay "Alterar Senha no Proximo LogOn..: "+If(aUser[i][01][09],"Sim","Nao") //Alterar Senha no Proximo LogOn
		nLin+=1
		
		PswOrder(1)     
		PswSeek(aUser[i][1][11],.t.)
		aSuperior := PswRet(NIL)
		@ nLin,000 pSay "Superior........................: "+If(!Empty(aSuperior),aSuperior[01][02],"") //Superior
		nLin+=1
		@ nLin,000 pSay "Departamento....................: "+aUser[i][01][12] //Departamento
		nLin+=1
		@ nLin,000 pSay "Cargo...........................: "+aUser[i][01][13] //Cargo
		nLin+=1
		@ nLin,000 pSay "E-Mail..........................: "+aUser[i][01][14] //E-Mail
		nLin+=1
		@ nLin,000 pSay "Acessos Simultaneos.............: "+AllTrim(Str(aUser[i][01][15])) //Acessos Simultaneos
		nLin+=1
		@ nLin,000 pSay "Ultima Alteracao................: "+DTOC(aUser[i][01][16]) //Data da Ultima Alteracao
		nLin+=1
		@ nLin,000 pSay "Usuario Bloqueado...............: "+If(aUser[i][01][17],"Sim","Nao") //Usuario Bloqueado
		nLin+=1
		@ nLin,000 pSay "Digitos p/o Ano.................: "+AllTrim(STR(aUser[i][01][18])) //Numero de Digitos Para o Ano
		nLin+=1
		@ nLin,000 pSay "Idioma..........................: "+aIdiomas[aUser[i][02][02]] //Idioma
		nLin+=1
		@ nLin,000 pSay "Diretorio do Relatorio..........: "+aUser[i][02][03] //Diretorio de Relatorio
		nLin+=1
		@ nLin,000 pSay "Tipo de Impressao...............: "+aTipoImp[aUser[i][02][08]] // Tipo de Impressao
		nLin+=1
		@ nLin,000 pSay "Formato de Impressao............: "+aFormImp[aUser[i][02][09]] // Formato
		nLin+=1
		@ nLin,000 pSay "Ambiente de Impressao...........: "+aAmbImp[aUser[i][02][10]] // Ambiente
		nLin+=2  
		
//* ==============================================================================================================================
		//����������������Ŀ
		//� Imprime Grupos �
		//������������������
 //*		@ nLin,000 pSay Replic("-",132)
 //*		nLin+=1
	
 //*		@nLin,000 pSay "G R U P O S"
 //*		nLin+=2
	    For k:=1 to Len(aUser[i][01][10])  // for de modulo     // aArray posicao /1/,/1/,/10/ => codigo de 6 digitos do usuario ex: 000000
		  
		  
   //*	  fCabec(@nLin,55)
			
			//�������������������������������������������������������������������������������������������������������Ŀ
			//� Verifica se Grupo eh vazio, pois em casos do usuario nao ter nenhum grupo sera adicionado um elemento �
			//� no Array com Space(06) para poder serconsiderado                                                      �
			//���������������������������������������������������������������������������������������������������������
			If !Empty(aUser[i][01][10][k]) 
			    PswOrder(1)
				PswSeek(aUser[i][01][10][k],.f.)
				aGroup := PswRet(NIL)
				
 			    //*	@ nLin,005 pSay aGroup[01][2] //Grupos
 				nLin+=1
 			Endif
		Next k

		//�����������������
		//� Imprime Menus �
		//�����������������
		
				fCabec(@nLin,50)      
				@ nLin,000 pSay Replic("-",132)
				nLin+=1
				@ nLin,000 pSay "M E N U S"
				nLin+=2
				nCol := 1
			//                        1         2         3         4         5         6         7         8
			//               123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			If nLin > 55 // linha acrescentada.
				@ nLin,000 pSay "    TITULO       PROGRAMA                     TITULO          PROGRAMA                  TITULO         PROGRAMA          "
				nLin+=1
				@ nLin,000 pSay "--------------  ----------              ------------------    ----------          ------------------   ----------           "
				nLin+=1                
			Endif   
			                                    
			For k:=1 to Len(aUser[i][03])//Len(aModulos)procura todas as rotinas do modulo apontado no for/next
				If Substr(aUser[i][03][k],3,1) <> "X" // \\ k=Acessos  // K saio no 28  (quando nao tem o X sai em branco no relatorio sem a rotina mata020
					aMenu := fGetMnu(Substr(aUser[i][03][k],4),aUser[i][01][02]) // sai quando alinha usuario informado no parametro com menu de acesso deste
					
					nPos := aScan(aModulos,{|x| x[1]==Left(aUser[i][03][k],2)})
					If !Empty(nPos) .and. len(aModulos) >=k  // "len" => Retorna o tamanho da string especificada no parametro.
		 					
							  For j:=1 to Len(aMenu)  // for de Menu
						            
						            IF EMPTY(MV_PAR04) 
						                
						                 //If  ALLTRIM(aMenu[j][03]) <> NIL // == " "
     					          	     //   Loop
     					          	     //Endif  	
					       	           
					       	           If (Empty(MV_PAR03)) .or. (ALLTRIM(MV_PAR03) $ ALLTRIM(aMenu[j][03]))  // <>NIL //"" //NIL  // .or. Len(aMenu[j][03])) // .and. ALLTRIM(aMenu[j][03]) <> NIL) // falta tratar na situacao em que esta em branco -> $ ALLTRIM(aMenu[j][03]) 
     					          	            // Dia 03/10/2011          // como fazer se ALLTRIM(aMenu[j][03] estiver em branco nao prosseguir e pegar o proximo usuario ?
     					          	      //If  ALLTRIM(aMenu[j][03])== NIL
     					          	      //  	Skip //  EXIT  //Loop
     					          	      //Endif  	
///////////////////////////////// ENTRA AQUI A PAGINA DE CIMA ///////////////////////////////////////////////////////////////////////////     					          	 
     					          	 
     					          	  //* 03/10/2011  If (Empty(MV_PAR03)) .or. (ALLTRIM(MV_PAR03) .and. ALLTRIM(aMenu[j][03]))<> " " 
     					          	     // nLin+=1
	     					     		    @ nLin,000 pSay aModulos[k][02]+" - "+AllTrim(aModulos[k][3])+"  -->  "+Substr(aUser[i][03][k],4) //conta da esquerda para direita e pega da 4quarta para frente
		     				     		    //*  nLin+=1
			     			     		  nCol := 2
			     			     		Endif                                               
						   
						            ELSEIF ALLTRIM(MV_PAR04) $ ALLTRIM(Substr(aUser[i][03][k],4)) // $-> Comparacao de Substrings (contido em)
                                       If (Empty (MV_PAR03)) .or. (ALLTRIM(MV_PAR03) $ ALLTRIM(aMenu[j][03]))
				             		   
						     		      @ nLin,000 pSay aModulos[k][02]+" - "+AllTrim(aModulos[k][3])+"  -->  "+Substr(aUser[i][03][k],4) // termina aqui a aUser dia 12/08/2011( 
						     		       nLin-=1
						     		      nCol := 1                                            
						     		   Endif     
						     		      
					                ENDIF 
						            
						            If nLin > 55 
							   		   fCabec(@nLin,55)      
							   		   @ nLin,000 pSay "    TITULO         PROGRAMA                  TITULO         PROGRAMA                     TITULO           PROGRAMA       "       // 014  //040
							   		   nLin+=1       
						 	   		   @ nLin,000 pSay "---------------   ----------             ---------------   ----------                 --------------     ----------     "     //042
						 	   		   nLin+=1   
						 	        Endif
							
							    	If !(aMenu[j][4] $ "T|F|E|D")
							        	Loop
							    	Endif
							
						         	IF EMPTY(ALLTRIM(MV_PAR03))         
	     				 		      //@ nLin,aColMenus[nCol]+000 pSay If(Empty(aMenu[j][02])," ",aMenu[j][02]) //* Cadastro
		     					   	  @ nLin,aColMenus[nCol]+019 pSay If(Empty(aMenu[j][03])," ",aMenu[j][03])
			     				 	  //@ nLin,aColMenus[nCol]+030 pSay If(Empty(aMenu[j][06])," ",aMenu[j][06])  
			     				 	  If nCol==3    
							 	         nCol:=1  
							 	         nLin+=1  
							           Else
								         nCol+=1     
							          Endif
							           
							        ELSEIF  ALLTRIM(MV_PAR03) $ ALLTRIM(aMenu[j][03])   // Enquanto Mata020 estiver contido no Menu ele fica no if, se o aMenu estiver em branco deve sair, como fazer isto ? 
							          //* @ nLin,aColMenus[nCol]+000 pSay If(Empty(aMenu[j][02])," ",aMenu[j][02]) // Eliminado Cadastro repeticao.
							       	  @ nLin,aColMenus[nCol]+019 pSay If(Empty(aMenu[j][03])," ",aMenu[j][03]) 
			     				 	  //@ nLin,aColMenus[nCol]+030 pSay If(Empty(aMenu[j][06])," ",aMenu[j][06])  
			     				 	  
			     				 	  If nCol==3    
							 	         nCol:=1  
							 	         nLin+=1  
							           Else
								         nCol+=1     
							          Endif
									
							      	ENDIF
							        							        
							  Next
					nLin+=1
				    Endif
           
			 	Endif
			Next k
			nLin+=1
		 // Endif
		
		Roda(,,"M")     
   ENDIF		
		
Next i

//�������������������������������������Ŀ
//� Finaliza a execucao do relatorio... �
//���������������������������������������
SET DEVICE TO SCREEN

//������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao... �
//��������������������������������������������������������������
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fModulos �Autor  �Carlos G. Berganton � Data �  16/02/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Array com Codigos e Nomes dos Modulos              ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fModulos()

Local aReturn

aReturn := {{"01","SIGAATF ","Ativo Fixo                       "},;
{"02","SIGACOM ","Compras                           "},;
{"03","SIGACON ","Contabilidade                     "},;
{"04","SIGAEST ","Estoque/Custos                    "},;
{"05","SIGAFAT ","Faturamento                       "},;
{"06","SIGAFIN ","Financeiro                        "},;
{"07","SIGAGPE ","Gestao de Pessoal                 "},;
{"08","SIGAFAS ","Faturamento Servico               "},;
{"09","SIGAFIS ","Livros Fiscais                    "},;
{"10","SIGAPCP ","Planej.Contr.Producao             "},;
{"11","SIGAVEI ","Veiculos                          "},;
{"12","SIGALOJA","Controle de Lojas                 "},;
{"13","SIGATMK ","Call Center                       "},;
{"14","SIGAOFI ","Oficina                           "},;
{"15","SIGARPM ","Gerador de Relatorios Beta1       "},;
{"16","SIGAPON ","Ponto Eletronico                  "},;
{"17","SIGAEIC ","Easy Import Control               "},;
{"18","SIGAGRH ","Gestao de R.Humanos               "},;
{"19","SIGAMNT ","Manutencao de Ativos              "},;
{"20","SIGARSP ","Recrutamento e Selecao Pessoal    "},;
{"21","SIGAQIE ","Inspecao de Entrada               "},;
{"22","SIGAQMT ","Metrologia                        "},;
{"23","SIGAFRT ","Front Loja                        "},;
{"24","SIGAQDO ","Controle de Documentos            "},;
{"25","SIGAQIP ","Inspecao de Projetos              "},;
{"26","SIGATRM ","Treinamento                       "},;
{"27","SIGAEIF ","Importacao - Financeiro           "},;
{"28","SIGATEC ","Field Service                     "},;
{"29","SIGAEEC ","Easy Export Control               "},;
{"30","SIGAEFF ","Easy Financing                    "},;
{"31","SIGAECO ","Easy Accounting                   "},;
{"32","SIGAAFV ","Administracao de Forca de Vendas  "},;
{"33","SIGAPLS ","Plano de Saude                    "},;
{"34","SIGACTB ","Contabilidade Gerencial           "},;
{"35","SIGAMDT ","Medicina e Seguranca no Trabalho  "},;
{"36","SIGAQNC ","Controle de Nao-Conformidades     "},;
{"37","SIGAQAD ","Controle de Auditoria             "},;
{"38","SIGAQCP ","Controle Estatistico de Processos "},;
{"39","SIGAOMS ","Gestao de Distribuicao            "},;
{"40","SIGACSA ","Cargos e Salarios                 "},;
{"41","SIGAPEC ","Auto Pecas                        "},;
{"42","SIGAWMS ","Gestao de Armazenagem             "},;
{"43","SIGATMS ","Gestao de Transporte              "},;
{"44","SIGAPMS ","Gestao de Projetos                "},;
{"45","SIGACDA ","Controle de Direitos Autorais     "},;
{"46","SIGAACD ","Automacao Coleta de Dados         "},;
{"47","SIGAPPAP","PPAP                              "},;
{"48","SIGAREP ","Replica                           "},;
{"49","SIGAGAC ","Gerenciamento Academico           "},;
{"50","SIGAEDC ","Easy DrawBack Control             "},;
{"51","SIGAHSP ","Gest�o Hospitalar                 "},;
{"52","SIGADOC ","Viewer                            "},;
{"53","SIGAAPD ","Avalia��o e Pesquisa de Desempenho"},;
{"54","SIGAGSP ","Gest�o de Servi�os P�blicos       "},;
{"55","SIGACRD ","Sistema de Fidel.e Analise Cr�dito"},;
{"97","SIGAESP ","Especificos                       "},;
{"98","SIGAESP1","Especificos I                     "}}      // 57 modulo

Return(aReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fAcessos �Autor  �Carlos G. Berganton � Data �  16/02/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna os Acessos dos Sistema                             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fAcessos()

Local aReturn

aReturn := {"Excluir Produtos             ",;
"Alterar Produtos             ",;
"Excluir Cadastros            ",;
"Alterar Solicit. Compras     ",;
"Excluir Solicit. Compras     ",;
"Alterar Pedidos Compras      ",;
"Excluir Pedidos Compras      ",;
"Analisar Cotacoes            ",;
"Relat Ficha Cadastral        ",;
"Relat Bancos                 ",;
"Relacao Solicit. Compras     ",;
"Relacao de Pedidos de Compras",;
"Alterar Estruturas           ",;
"Excluir Estruturas           ",;
"Alterar TES                  ",;
"Excluir TES                  ",;
"Inventario                   ",;
"Fechamento Mensal            ",;
"Proc Diferenca de Inventario ",;
"Alterar Pedidos de Venda     ",;
"Excluir Pedidos de Venda     ",;
"Alterar Helps                ",;
"Substituicao de Titulos      ",;
"Inclusao de Dados Via F3     ",;
"Rotina de Atendimento        ",;
"Proc. Troco                  ",;
"Proc. Sangria                ",;
"Bordero Cheques Pre-Datado   ",;
"Rotina de Pagamento          ",;
"Rotina de Recebimento        ",;
"Troca de Mercadorias         ",;
"Acesso Tabela de Precos      ",;
"Abortar c/ Alt-C/Ctrl-Brk    ",;
"Retorno Temporario p/ o DOS  ",;
"Acesso Condicao Negociada    ",;
"Alterar DataBase do Sistema  ",;
"Alterar Empenhos de OP's     ",;
"Pode Utilizar Debug          ",;
"Form. Precos Todos os Niveis ",;
"Configura Venda Rapida       ",;
"Abrir/Fechar Caixa           ",;
"Excluir Nota/Orc LOJA        ",;
"Alterar Bem Ativo Fixo       ",;
"Excluir Bem Ativo Fixo       ",;
"Incluir Bem Via Copia        ",;
"Tx Juros Condicao Negociada  ",;
"Liberacao Venda Forcad TEF   ",;
"Cancelamento Venda TEF       ",;
"Cadastra Moeda na Abertura   ",;
"Altera Num. da NF            ",;
"Emitir NF Retroativa         ",;
"Excluir Baixa - Receber      ",;
"Excluir Baixa - Pagar        ",;
"Incluir Tabelas              ",;
"Alterar Tabelas              ",;
"Excluir Tabelas              ",;
"Incluir Contratos            ",;
"Alterar Contratos            ",;
"Excluir Contratos            ",;
"Uso Integracao SIGAEIC       ",;
"Inclui Emprestimo            ",;
"Alterar Emprestimo           ",;
"Excluir Emprestimo           ",;
"Incluir Leasing              ",;
"Alterar Leasing              ",;
"Excluir Leasing              ",;
"Incluir Imp. Nao Financ.     ",;
"Alterar Imp. Nao Financ.     ",;
"Excluir Imp. Nao Financ.     ",;
"Incluir Imp. Financ.         ",;
"Alterar Imp. Financ.         ",;
"Excluir Imp. Financ.         ",;
"Incluir Imp. Fin.Export      ",;
"Alterar Imp. Fin.Export      ",;
"Excluir Imp. Fin.Export      ",;
"Incluir Contrato             ",;
"Alterar Contrato             ",;
"Excluir Contrato             ",;
"Lancar Taxa Libor            ",;
"Consolidar Empresas          ",;
"Incluir Cadastros            ",;
"Alterar Cadastros            ",;
"Incluir Cotacao Moedas       ",;
"Alterar Cotacao Moedas       ",;
"Excluir Cotacao Moedas       ",;
"Incluir Corretoras           ",;
"Alterar Corretoras           ",;
"Excluir Corretoras           ",;
"Incluir Imp./Exp./Cons       ",;
"Alterar Imp./Exp./Cons       ",;
"Excluir Imp./Exp./Cons       ",;
"Baixar Solicitacoes          ",;
"Visualiza Arquivo Limite     ",;
"Imprime Doctos. Cancelados   ",;
"Reativa Doctos. Cancelados   ",;
"Consulta Doctos. Obsoletos   ",;
"Imprime Doctos. Obsoletos    ",;
"Consulta Doctos. Vencidos    ",;
"Imprime Doctos. Vencidos     ",;
"Def. Laudo Final Entrega     ",;
"Imprime Param Relatorio      ",;
"Transfere Pendencias         ",;
"Usa Relatorio por E-Mail     "}    // 103

Return(aReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fCabec   �Autor  �Carlos G. Berganton � Data �  18/02/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Quebra de Pagina e Imprime Cabecalho                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabec(nLin,nLimite)

//������������������������������������������Ŀ
//� Impressao do cabecalho do relatorio. . . �
//��������������������������������������������
If nLin > nLimite    
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)  
	nLin := 6    
Endif

Return  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetMnu   �Autor  �Carlos G. Berganton � Data �  15/03/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Obtem dados de um arquivo .mnu                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetMnu(cArq,cUsuario)

Local   aRet := {}
Local   aMenu:= {}
Private aTmp := {}

//���������������������������Ŀ
//� Verifica a Vers�o do Menu �
//�����������������������������
If Upper(Right(AllTrim(cArq),3))=="MNU"  //* UPPER()-> Retorna uma string com todos os caracteres maiusculos, tendo como base a string passada como par�metro.
	//������������������
	//� Abre o Arquivo �
	//������������������
	If File(cArq)
		ft_fuse(cArq)
	Else
		ApMsgAlert("Arquivo "+AllTrim(cArq)+" nao foi encontrado. Usuario "+AllTrim(cUsuario)+".")
		Return({})
	Endif
	
	While ! ft_feof()
		
		//���������������������Ŀ
		//� Le linha do Arquivo �
		//�����������������������
		cBuff := ft_freadln()
		aTmp := {}
		
		//��������������������������������Ŀ
		//� Monta Array com Dados da Linha �
		//����������������������������������
		aAdd(aTmp,Substr(cBuff,01,02))
		aAdd(aTmp,Substr(cBuff,03,18))
		aAdd(aTmp,Substr(cBuff,21,10))
		aAdd(aTmp,Substr(cBuff,31,01))
		aAdd(aTmp,{})
		For i:=32 to 89 Step 3
			If Substr(cBuff,i,3)<>"..."
				aAdd(aTmp[5],Substr(cBuff,i,3))
			Endif
		Next
		aAdd(aTmp,Substr(cBuff,122,10))
		
		//���������������������������Ŀ
		//� Abastece Array de Retorno �
		//�����������������������������
		aAdd(aRet,aTmp)
		
		ft_fskip()
	EndDo
	
	ft_fuse()
 Elseif Upper(Right(AllTrim(cArq),3))=="XNU"   //* UPPER()-> Retorna uma string com todos os caracteres maiusculos, tendo como base a string passada como par�metro.
	aMenu := XNULOAD(cArq)
	//aMenu[i]					//-> Sub itens
	//aMenu[i][1][1]			//Nome -> Atualizacoes, etc
	//aMenu[i][3]	     	    //-> Sub/Sub Itens
	//aMenu[i][3][k][1]			//Nome -> Cadastros
	//aMenu[i][3][k][3][j]		//Item do Menu
	//aMenu[i][3][k][3][j][2]	//Nome
	//aMenu[i][3][k][3][j][2]	//Status E=Enable
	//aMenu[i][3][k][3][j][3]	//Rotina
	//aMenu[i][3][k][3][j][4]	//Aliases (Array)
	//aMenu[i][3][k][3][j][5]	//Acessos xxxxxxxxxx
	//aMenu[i][3][k][3][j][6]	//Modulo
	//aMenu[i][3][k][3][j][7]	//Tipo
	
	
	For i:=1 to Len(aMenu) //Atualizacoes,Consultas,Relatorios,Miscelanea
		
		aAdd(aRet,fAddMnu(StrZero(i,2),aMenu[i][1][1],Space(10),aMenu[i][2],{},Space(10)))
		
		For k:=1 to Len(aMenu[i][3])//Cadastros,Solicitar/cotar,etc
			
			//������������������������������������Ŀ
			//� Verifica se � um Topico ou um Item �
			//��������������������������������������
			If Len(aMenu[i][3][k])==7
				aAdd(aRet,fAddMnu(StrZero(i,2),aMenu[i][3][k][1][1],aMenu[i][3][k][3],aMenu[i][3][k][2],aMenu[i][3][k][4],aMenu[i][3][k][5]))
			Else
				aAdd(aRet,fAddMnu(StrZero(i,2),aMenu[i][3][k][1][1],Space(10),aMenu[i][3][k][2],{},Space(10)))
				
				IF VALTYPE(aMenu[i][3][k][3]) == "A"  // "VALTYPE" => Determina o tipo do conteudo de uma variavel, a qual nao foi definida na funcao em execucao.
					_CONTADOR := Len(aMenu[i][3][k][3])
				ELSE
					_CONTADOR := 0 
				ENDIF

				For _j:=1 to _CONTADOR // quantidade do array vai do 7 ate 22    //pesquisar 
					//������������������������������������Ŀ
					//� Verifica se � um Topico ou um Item �
					//��������������������������������������
					If Len(aMenu[i][3][k][3][_j])==7
						aAdd(aRet,fAddMnu(StrZero(i,2),aMenu[i][3][k][3][_j][1][1],aMenu[i][3][k][3][_j][3],aMenu[i][3][k][3][_j][2],aMenu[i][3][k][3][_j][4],aMenu[i][3][k][3][_j][5]))
				   		// se (A)aMenu[i][3][k][3][_j][1][1] e (B)aMenu[i][3][k][3][_j][3] forem iguais ao A=Menu e B=Rotina(mv_par03)armazena e sai 
					Else   
			  			aAdd(aRet,fAddMnu(StrZero(i,2),aMenu[i][3][k][3][_j][1][1],Space(10),aMenu[i][3][k][3][_j][2],{},Space(10)))
						//* For l:=1 to Len(aMenu[i][3][k][3][_j][3])
						///	aAdd(aRet,fAddMnu(StrZero(i,2),aMenu[i][3][k][3][j][3][l][1][1],aMenu[i][3][k][3][j][3][l][3],aMenu[i][3][k][3][j][3][l][2],aMenu[i][3][k][3][j][3][l][4],aMenu[i][3][k][3][j][3][l][5]))
		  				aAdd(aRet,fAddMnu(StrZero(i,2),aMenu[i][3][k][1][1],aMenu[i][3][k][3][_j][3],aMenu[i][3][k][2],{},Space(10))) // pesquisar linha
						//* Next l
		  			Endif
				Next _j
			Endif
		Next k
	Next i
Else
	Aviso("Inconsistencia...","Tipo de arquivo n�o suportado",{"Ok"})
Endif

Return(aRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fAddMnu  �Autor  � Gustavo Berganton  � Data �  15/03/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta Array de Item do Menu                                ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fAddMnu(cSubMenu,cNome,cFuncao,cStatus,aAlias,cAcessos) // Variaveis estaticas funcionam basicamente como as variaveis locais, mas mantem seu valor atraves da
											   							 //	execucao. Variaveis estaticas devem ser declaradas explicitamente no codigo com o identificador STATIC.
																		 //	O escopo das variaveis estaticas depende de onde sao declaradas. Se forem declaradas dentro do corpo de
																		 //	uma funcao ou procedimento, seu escopo sera limitado aquela rotina. Se forem declaradas fora do corpo de
 																		 //	qualquer rotina, seu escopo e todo o arquivo de programa.
Local aRet := {}
Local aTmp := {}

aAdd(aTmp,cSubMenu)
aAdd(aTmp,cNome)
aAdd(aTmp,cFuncao)
aAdd(aTmp,cStatus) // 
aAdd(aTmp,aAlias)
aAdd(aTmp,cAcessos)

//���������������������������Ŀ
//� Abastece Array de Retorno �
//�����������������������������
//aAdd(aRet,aTmp)

Return(aTMP)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1� Autor � Carlos G. Berganton   � Data � 15/03/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustSX1()             
/*/Variaveis estaticas funcionam basicamente como as variaveis locais, mas mantem seu valor atraves da
execucao. Variaveis estaticas devem ser declaradas explicitamente no codigo com o identificador STATIC.
O escopo das variaveis estaticas depende de onde sao declaradas. Se forem declaradas dentro do corpo de
uma funcao ou procedimento, seu escopo sera limitado aquela rotina. Se forem declaradas fora do corpo de
qualquer rotina, seu escopo � todo o arquivo de programa.
/*/


Local aArea	    := GetArea()
Local cPerg		:= padr("INFOUSR",10)
Local aRegs		:= {}
Local i

aadd(aRegs,{"01","Do Usu�rio.........?","mv_ch1","C",15,0,0,"G","mv_par01",""   ,""       ,"USN"})
aadd(aRegs,{"02","Ate Usu�rio........?","mv_ch2","C",15,0,0,"G","mv_par02",""   ,""       ,"USN"})
AAdd(aRegs,{"03","Programa             ","mv_ch3","C",20,0,0,"G","mv_par03",""   ,""       ,""   })
AAdd(aRegs,{"04","Menu ?              ","mv_ch4","C",20,0,0,"G","mv_par04",""   ,""       ,""   })

dbSelectArea("SX1")
dbSetOrder(1)
For i:=1 to Len(aRegs)
	dbSeek(cPerg+aRegs[i][1])
	If !Found() .or. aRegs[i][2]<>X1_PERGUNT .or. aRegs[i][01]<>X1_ORDEM
		RecLock("SX1",!Found()) //* RECLOCK()-> Efetua o travamento do registro posicionado na �rea de trabalho ativa, permitindo a inclus�o ou altera��o das informa��es do mesmo.
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := aRegs[i][01]
		SX1->X1_PERGUNT := aRegs[i][02]
		SX1->X1_VARIAVL := aRegs[i][03]
		SX1->X1_TIPO    := aRegs[i][04]
		SX1->X1_TAMANHO := aRegs[i][05]
		SX1->X1_DECIMAL := aRegs[i][06]
		SX1->X1_PRESEL  := aRegs[i][07]
		SX1->X1_GSC     := aRegs[i][08]
		SX1->X1_VAR01   := aRegs[i][09]
		SX1->X1_DEF01   := aRegs[i][10]
		SX1->X1_DEF02   := aRegs[i][11]
		SX1->X1_F3      := aRegs[i][12]
		MsUnlock()//* MSUNLOCK()-> Libera o travamento (lock) do registro posicionado confirmando as atualiza��es efetuadas neste registro.
	Endif
Next

//������������������������������Ŀ
//� Deleta Parametros Excedentes �
//��������������������������������
While .t.
	dbSeek(cPerg+StrZero(Len(aRegs)+1,2),.t.)  //(ARETURN) cria um "array" e armazena na 'ARETURN'
	If X1_GRUPO==cPerg .and. Val(X1_ORDEM)>Val(aRegs[Len(aRegs)][1])
		RecLock("SX1",.f.)
		dbDelete()
		MsUnlock()
	Else
		Exit
	Endif
End

RestArea(aArea)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSXB� Autor � Marcos R. Coelho      � Data � 31/03/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as consultas inclu�ndo-as caso n�o existam        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustSXB()// Variaveis estaticas funcionam basicamente como as variaveis locais, mas mantem seu valor atraves da
						  // execucao. Variaveis estaticas devem ser declaradas explicitamente no codigo com o identificador STATIC.
						  // O escopo das variaveis estaticas depende de onde sao declaradas. Se forem declaradas dentro do corpo de
						  // uma funcao ou procedimento, seu escopo sera limitado aquela rotina. Se forem declaradas fora do corpo de
						  // qualquer rotina, seu escopo e todo o arquivo de programa.

local nXX
local aAreaSXB	:= SXB->( GetArea() )
Local aRegsSXB  := {}
Local cAliasSXB := "USN"

//				|ALIAS	|TIPO	|SEQ	|COLUNA	|DESCRI		|DESCSPA	|DESCENG	|CONTEM
aadd(aRegsSXB,	{	cAliasSXB, "1",	"01",	"US",	"Usu�rios",	"Usu�rios",	"Users",	""		})
aadd(aRegsSXB,	{	cAliasSXB, "5",	"01",	"",		"",			"",			"",			"NAME"	})

SXB->( dbsetorder(1) )
for nXX := 1 to len( aRegsSXB )
	if ! SXB->( dbseek( aRegsSXB[nXX,1] + aRegsSXB[nXX,2] + aRegsSXB[nXX,3] ) )
		RecLock("SXB",.T.)
		SXB->XB_ALIAS	:= aRegsSXB[nXX,1]
		SXB->XB_TIPO	:= aRegsSXB[nXX,2]
		SXB->XB_SEQ		:= aRegsSXB[nXX,3]
		SXB->XB_COLUNA	:= aRegsSXB[nXX,4]
		SXB->XB_DESCRI	:= aRegsSXB[nXX,5]
		SXB->XB_DESCSPA	:= aRegsSXB[nXX,6]
		SXB->XB_DESCENG	:= aRegsSXB[nXX,7]
		SXB->XB_CONTEM	:= aRegsSXB[nXX,8]
		SXB->( MsUnlock() )
	endif
next nXX         

SXB->( RestArea( aAreaSXB ) )

return Nil

