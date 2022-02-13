#Include "Protheus.ch"
#Include "ApWizard.ch"
 
User Function Wizard2()
Local oWizard, oPanel, oSexo
Local cNome := Space(30)
Local dNasc := Ctod(Space(8))
Local nIdade := 0
Local nCivil := 0
Local aCivil := {"Solteiro","Casado"}
Local aRet := {}
Local aParamBox := {}
Local aCombo := {}
 
DEFINE WIZARD oWizard TITLE "Exemplo Wizard" ;
       HEADER "Wizard utilizado no curso oficina de programa��o" ;
       MESSAGE "Est� classe tende a ser uma das mais utilizada na programa��o AdvPL" ;
       TEXT "Este exemplo mostra a utiliza��o desta classe e seus poss�veis recursos, sendo assim f�cil e pr�tico." ;
       NEXT {||.T.} ;
   FINISH {|| .T. } ;
       PANEL
 
   // Primeira etapa
   CREATE PANEL oWizard ;
          HEADER "Informe o nome completo" ;
          MESSAGE "Somente ser� poss�vel nomes com at� trinta caracteres" ;
          BACK {|| .T. } ;
          NEXT {|| .T. } ;
          FINISH {|| .F. } ;
          PANEL
   oPanel := oWizard:GetPanel(2)
   @ 15,15 SAY "Nome completo" SIZE 45,8 PIXEL OF oPanel
   @ 25,15 MSGET cNome PICTURE "@!" SIZE 160,10 PIXEL OF oPanel
 
   // Segunda etapa
   CREATE PANEL oWizard ;
          HEADER "Digite a data de nascimento" ;
          MESSAGE "A data de nascimento dever� ser menor que "+Dtoc(dDataBase)+" a baixo ser� informado a idade" ;
          BACK {|| .T. } ;
          NEXT {|| .T. } ;
          FINISH {|| .F. } ;
          PANEL    
   oPanel := oWizard:GetPanel(3)
   @ 15,15 SAY "Data nascimento" SIZE 45,8 PIXEL OF oPanel
   @ 25,15 MSGET dNasc PICTURE "99/99/99" VALID Eval({||dNasc<dDataBase,nIdade:=Year(dDataBase)-Year(dNasc)}) ;
   SIZE 40,10 PIXEL OF oPanel
   @ 40,15 SAY "Idade" SIZE 45,8 PIXEL OF oPanel
   @ 50,15 MSGET nIdade PICTURE "99" WHEN .F. SIZE 40,10 PIXEL OF oPanel
   
   // Terceira etapa
   CREATE PANEL oWizard ;
          HEADER "Informe o seu estado civil" ;
          MESSAGE "" ;
          BACK {|| .T. } ;
          NEXT {|| .T. } ;
          FINISH {|| .F. } ;
          PANEL
   oPanel := oWizard:GetPanel(4)
   @ 30,10 RADIO oCivil VAR nCivil ITEMS aCivil[1],aCivil[2] SIZE 65,8 PIXEL OF oPanel
   
   // Quarto etapa
   CREATE PANEL oWizard ;
          HEADER "Parambox" ;
          MESSAGE "mensagem..." ;
          BACK {|| .T. } ;
          NEXT {|| .F. } ;
          FINISH {|| .T. } ;
          PANEL
   oPanel := oWizard:GetPanel(5)
   
 aCombo := {"Janeiro","Fevereiro","Mar�o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
 aRET := {"",0,Ctod(Space(8)),"",0,.f.,.f.,"","","",""}
 
 aAdd(aParamBox,{1,"Produto",Space(15),"","","SB1","",0,.F.})
 aAdd(aParamBox,{1,"Valor",0,"@E 9,999.99","mv_par02>0","","",20,.F.})
 aAdd(aParamBox,{1,"Data"  ,Ctod(Space(8)),"","","","",20,.F.})
 aAdd(aParamBox,{2,"Informe o m�s",1,aCombo,50,"",.F.})
 aAdd(aParamBox,{3,"Mostra deletados",1,{"Sim","N�o"},50,"",.F.})
 aAdd(aParamBox,{4,"Marca todos ?",.F.,"Marque todos se necess�rio for.",90,"",.F.})
 aAdd(aParamBox,{5,"Marca todos ?",.F.,50,"",.F.})
 aAdd(aParamBox,{6,"Buscar arquivo",Space(50),"","","",50,.F.,"Todos os arquivos (*.*) |*.*"})
 aAdd(aParamBox,{7,"Monte o filtro","SX5","X5_FILIAL==xFilial('SX5')"})
 aAdd(aParamBox,{8,"Digite a senha",Space(15),"","","","",80,.F.})
 aAdd(aParamBox,{9,"Texto aleat�rio, apenas demonstrativo.",150,7,.T.})

 ParamBox(aParamBox,"Teste Par�metros...",@aRet,,,,,,oPanel)
 
ACTIVATE WIZARD oWizard CENTERED
 
Return