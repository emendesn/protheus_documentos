#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa  ³ EICPO400    ³ Autor ³  Delta-Decisao   ³ Data ³ 26/07/13   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Ponto de Entrada para tratamento das rotinas de Gravacao   ³±±
±±³           ³ da SI para atender as regras da BGH                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ IMPORTACAO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static lPesqSI:=.f.

*---------------------*
User Function EICPO400 
*---------------------*
Local lIntFin := GetMv("MV_EASYFIN",,"N")== "S" .AND. GetMv("MV_EASY",,"N")== "S"

do case
   case paramixb == "SelecionaSI"

        PESQSI()
        Return .f. // Retornando .f. inibe a abertura da Tela de SI padrao   
        
   case paramixb == "PO_PesqSI_Sel"                      
        SA5->(DBSETORDER(3))
        If EICSFabFor(xFilial("SA5")+SW1->W1_COD_I+M->W2_FORN+M->W2_FORN, EICRetLoja("M", "W2_FORLOJ"), EICRetLoja("M", "W2_FORLOJ"))
           If SA5->A5_TPPROD <> M->W2_TPPROD
              lLoop := .t.
           Endif   
        Endif   
             
   case paramixb == "COORDENADA_TELA_ITENS"
        M->W3_FABR   := M->W2_FORN

        If EICLoja()
           M->W3_FABLOJ:= EICRetLoja("M", "W2_FORLOJ")   
        EndIf
   
   case paramixb == "GRAVA_PO_PC"
        lPesqSI := .f.  // Para habilitar que o Tipo de Produto Possa ser modificado pelo usuário
                  
   case paramixb == "ANTES_MARCA_ITEM"  
   
   		lMarcaItem:=.t.
        Work->WKTPPROD:=RetTpProd(M->W2_TPPROD)
        Work->WKDT_EMB:=M->W2_PO_DT+SA5->A5_LEAD_T//Alteração efetuada conforme solicitação do Victor 
        Work->WKDT_ENTR:=M->W2_PO_DT+SA5->A5_LEAD_T+SA5->A5_TEMPTRA//Inclusão efetuada conforme solicitação do Victor 
        Work->WKFABR  :=SA5->A5_FABR  
        Work->WKFORN  :=M->W2_FORN

       If EICLoja()
          Work->W3_FABLOJ := EICRetLoja("M", "W2_FORLOJ")
          Work->W3_FORLOJ := EICRetLoja("M", "W2_FORLOJ")
       EndIf

   
   case paramixb == "ADICIONA_WORK"
        AADD(aDBF_Stru,{"WKTPPROD", "C",8, 0})             
        
   case paramixb == "ANTES_GRAVAR"  .and. Inclui// EOB - 17/09/13 
		IF lIntFin //.AND. SW3->(DBSEEK(XFilial("SW3")+SW2->W2_PO_NUM)) 
			EICFI400("POS_GRV_PO","I")
//			Processa({|| FI400POS_PO(SW3->W3_PO_NUM,.F.) })
//			Processa({|| AVPOS_PO(SW3->W3_PO_NUM,"PO") })  
		ENDIF                  

   case paramixb == "ANTES_ESTORNO_PO"  // EOB - 17/09/13 
		IF lIntFin 
			EICFI400("ANT_GRV_PO","E")
		ENDIF                  

   case paramixb == "DEPOIS_ESTORNO_PO"  // EOB - 17/09/13 
		IF lIntFin 
			EICFI400("POS_GRV_PO","E")
		ENDIF                  
	
END CASE

Return .t.



Static Function PESQSI()
LOCAL nOpc         := 0
LOCAL aMarked      := {}
Local _lRetorno := .F. //Validacao da dialog criada oDlg
Local _nOpca := 0 //Opcao da confirmacao
Local bOk := {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
Local bCancel := {|| _nOpca:=0,oDlg:End() } //botao de cancelamento
Local _cArqEmp := "" //Arquivo temporario com as empresas a serem escolhidas
Local _aStruTrb := {} //estrutura do temporario
Local _aBrowse := {} //array do browse para demonstracao das empresas
Local _aEmpMigr := {} //array de retorno com as empresas escolhidas
Local aOpcoes := {}
Local nOpcaoProd   

Local aStruTrb := {}

Private lInverte := .F. //Variaveis para o MsSelect
Private xMarca := GetMark() //Variaveis para o MsSelect
Private oBrwTrb //objeto do msselect Private oDlg

//Filtro para montar a tela de seleção de títulos
Private cIndexName	:= Criatrab(Nil,.F.)
Private cIndexKey	:= "DTOS(W0__DT)+W0__CC+W0__NUM"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta area de trabalho                                                  ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(aStruTrb,{"TRB_OK"    ,"C",2,0})
aadd(aStruTrb,{"TRB_DT"    ,"D",TamSx3("W0__DT")[1],TamSx3("W0__DT")[2]})
aadd(aStruTrb,{"TRB_CC"    ,"C",TamSx3("W0__CC")[1],TamSx3("W0__CC")[2]})
aadd(aStruTrb,{"TRB_NUM"   ,"C",TamSx3("W0__NUM")[1],TamSx3("W0__NUM")[2]})
aadd(aStruTrb,{"TRB_NUMSC" ,"C",TamSX3("W0_C1_NUM")[1], TamSx3("W0_C1_NUM")[2]})
aadd(aStruTrb,{"TRB_TPPROD","C",8,TamSx3("A5_TPPROD")[2]})

aadd(_aBrowse,{"TRB_OK"    ,,"" })                               
aadd(_aBrowse,{"TRB_DT"    ,,"Emissao", })
aadd(_aBrowse,{"TRB_CC"    ,,"Unid. Req.", })
aadd(_aBrowse,{"TRB_NUM"   ,,"No. SI" ,})
aadd(_aBrowse,{"TRB_NUMSC" ,,"No. SC" ,})
aadd(_aBrowse,{"TRB_TPPROD",,"Tipo" ,})

dDataI :=ctod('')
dDataF :=ctod('')  

//M->W2_FORN    := 'Z0065I'
//M->W2_FORLOJ  := '01'
//M->W2_TPPROD  := '2'

aAdd(aOpcoes, "1 - IDEN   ")
aAdd(aOpcoes, "2 - MD     ")
aAdd(aOpcoes, "3 - OUTROS ")

cArquivo := CriaTrab(aStruTrb,.T.)
dbUseArea(.T.,__localDriver,cArquivo,"TRBSI",.F.,.F.)
__DBZAP()
                                      
DEFINE MSDIALOG oDlg TITLE "Seleção de SI´s" From 0,0 To 37,123 OF oMainWnd   //ALT,LARG

@10.2,15.3 SAY   "Emissão Inicial"  SIZE    40,8 PIXEL //"Data Inicial : "
@10.2,55.3 MSGET oDataI    VAR dDataI    Picture "@D" SIZE 050,10 OF oDlg PIXEL 

@30.2,15.3 SAY   "Emissão Final"  SIZE    40,8 PIXEL //"Data Inicial : "
@30.2,55.3 MSGET oDataF    VAR dDataF    Picture "@D" SIZE 050,10 OF oDlg PIXEL 

@ 10.2,150.3  SAY "Tipo Produto: "  PIXEL SIZE 55,9 OF oDlg
@ 10.2,190.3  MSGET aOpcoes[VAL(M->W2_TPPROD)] VAR aOpcoes[VAL(M->W2_TPPROD)] SIZE 40,8 PIXEL OF oDlg WHEN .F.
 
//oCombo := TComboBox():New(10.2,190.2,{|u|if(PCount()>0,nOpcaoProd:=Val(u),nOpcaoProd)},aOpcoes,50,20,oDlg,,{||.t.},,,,.T.,,,,,,,,,'nOpcaoProd')	

@ 30.2,150.3 BUTTON "Pesquisar SI" SIZE 50,012 ACTION U_ValData(dDAtaI,dDataF) OF oDlg PIXEL

oBrwTrb := MsSelect():New("TRBSI","TRB_OK","",_aBrowse,@lInverte,@xMarca,{60,10,255,475})
oBrwTrb:oBrowse:lCanAllmark := .T.
oBrwTrb:oBrowse:lHasMark	 	:=.T.
oBrwTrb:bMark 				:= {|| .t.}
oBrwTrb:oBrowse:bAllMark		:= {|| MsAguarde({||U_MarDesSI()}),Eval(oBrwTrb:oBrowse:bGoTop),oBrwTrb:oBrowse:Refresh() }

Eval(oBrwTrb:oBrowse:bGoTop)
oBrwTrb:oBrowse:Refresh()

//Aadd(aButtons,{"NOTE",    {||Edita006()},"Altera Necessidade","Edita"}) 
//Aadd(aButtons,{"DESTINOS",{||Ordem006()},"Altera Ordem","Ordem"}) 
	
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||If(MsgNoYes( "Confirma a Geração do PO para estas SI's ?", "Geração PO" ),(MsAguarde({||If(GeraPO(),oDlg:End(),) }),),)},{||oDlg:End()},,/*aButtons*/)
TRBSI->(dbclosearea())
Return .t.

*---------------------------------------*
Static Function FiltraSI(dDataI,dDataF)  
*---------------------------------------*
Local cFilter    := ''        
Local cQuery

DBSELECTAREA("TRBSI")
__DBZAP()            

cQuery := " SELECT  DISTINCT  " 
cQuery += "   W0__DT, "
cQuery += "   W0__CC, "
cQuery += "   W0__NUM,"
cQuery += "   W0_C1_NUM,"
cQuery += "   CASE WHEN SA5.A5_TPPROD = '1' THEN '1-IDEN' ELSE (CASE WHEN SA5.A5_TPPROD = '2' THEN '2-MD' ELSE '3-Outros' END) END AS TIPOPROD "
cQuery += "FROM "+RetSQLName("SW0")+" SW0 "              
cQuery += "   INNER JOIN "+RetSQLName("SW1")+" SW1 "
cQuery += "   ON SW1.W1_FILIAL = '"+xFilial("SW1")+"' AND SW1.W1_CC = SW0.W0__CC AND SW1.W1_SI_NUM = SW0.W0__NUM  AND SW1.W1_SEQ = 0 AND SW1.W1_SALDO_Q <> 0 AND SW1.D_E_L_E_T_ = '  ' "

cQuery += "INNER JOIN "+RetSQLName("SA5")+" SA5 "
cQuery += "   ON SA5.A5_FILIAL = '"+xFilial("SA5")+"' AND SA5.A5_FORNECE = '"+M->W2_FORN+"' AND SA5.A5_LOJA = '"+M->W2_FORLOJ+"' AND SA5.A5_PRODUTO = SW1.W1_COD_I AND SA5.A5_TPPROD = '"+M->W2_TPPROD+"' AND SA5.D_E_L_E_T_ = '' "   
//cQuery += "      AND SA5.D_E_L_E_T_ = '  ' AND SW1.W1_FORN = '"+M->W2_FORN+"' AND SW1.W1_FORLOJ = '"+M->W2_FORLOJ+"' "
cQuery += "WHERE SW0.W0_FILIAL  = '"+xFilial("SW0")+"' AND SW0.W0__DT BETWEEN  '"+dtos(dDataI)+"' AND '"+dtos(dDataF)+"' AND   SW0.D_E_L_E_T_ = ' '  "
cQuery += "ORDER BY SW0.W0__DT, SW0.W0__CC, SW0.W0__NUM "

TCQUERY cQuery ALIAS "TSW0" NEW
TCSetField("TSW0","W0__DT" , "D",8,0)
dbGotop()
dbSelectArea("TSW0")

While ! TSW0->(Eof())
 
  lPesqSI := .T.  // Para Inbir que o Tipo de Produto Possa ser modificado pelo usuário
   
  IncProc("Gravando SI Nr "+TSW0->W0__NUM)
  
  TRBSI->(RecLock("TRBSI",.T.))
  TRBSI->TRB_OK     := ""
  TRBSI->TRB_DT     := TSW0->W0__DT
  TRBSI->TRB_CC     := TSW0->W0__CC
  TRBSI->TRB_NUM    := TSW0->W0__NUM
  TRBSI->TRB_NUMSC  := TSW0->W0_C1_NUM
  TRBSI->TRB_TPPROD := TSW0->TIPOPROD
  TSW0->(dbskip())
End
 
TRBSI->(dbgotop())
Eval(oBrwTrb:oBrowse:bGoTop)
oBrwTrb:oBrowse:Refresh()

TSW0->(dbclosearea())

   
Return .t.

     
*-----------------------*
User Function MarDesSI()
*-----------------------*                         
TRBSI->(dbgotop())
While ! TRBSI->(Eof()) 
   TRBSI->TRB_OK	= If(!Empty(TRBSI->TRB_OK), "",xMarca)     
   TRBSI->(MsUnlock())
   TRBSI->(dbskip())
End
TRBSI->(dbgotop())
Return .t.                                                      
                     
*------------------------------------*                 
User Function ValData(dDataI,dDataF) 
*------------------------------------*
If Empty( dDataI )
   MsgStop("Data Emissao Inicial deve ser Informada para Pesquisa","Atenção")
   Return .f.
Endif

If Empty( dDataF )
   MsgStop("Data Emissao Final deve ser Informada para Pesquisa","Atenção")
   Return .f.
Endif                         

If dDataI > dDataF
   MsgStop("Data Final deve ser Superior a Data Inicial","Atenção")
   Return .f.
Endif
 
MsAguarde({||FiltraSI(dDataI,dDataF)})
Return .t.                                                                                                 


*------------------------*
Static Function GeraPO()  
*------------------------*
Local lMarcados:=.f.
Local lValidSI

TRBSI->(dbgotop())  

While ! TRBSI->(Eof())
  If ! Empty( TRBSI->TRB_OK ) 
     lMarcados:=.t.
     Exit
  Endif   
  TRBSI->(dbskip())
End       

TRBSI->(dbgotop())
If ! lMarcados
   MsgStop("Nenhuma SI foi selecionada","Atenção")
   Return .f.
Endif                                          


While ! TRBSI->(Eof())

  If Empty( TRBSI->TRB_OK ) 
     TRBSI->(dbskip()) ; Loop
  Endif
  
  TCC       := TRBSI->TRB_CC
  TSi_Num   := TRBSI->TRB_NUM

  IncProc("Gerando PO para SI No: "+TCC+"/"+TSi_Num)
  
  lValidSI:=PO_ValidSI(.f.)
   
  TRBSI->(dbskip())
End
            
Return .t.
                    



                           
*--------------------------------*
Static Function RetTpProd(cTipo)
*--------------------------------*
Local cRet:=""

Do Case
   Case cTipo == '1' ; cRet:="1-IDEN  "
   Case cTipo == '2' ; cRet:="2-MD    "
   Case cTipo == '3' ; cRet:="3-Outros" 
End Case

Return cRet        


*--------------------------------*
User Function VerLctoSI()        
*--------------------------------*
 
/*                         
If Type("M->W2_PO_NUM") <> "U" .and. Empty (M->W2_PO_NUM)
   Return .t.
Endif              
*/

If (Type("TSi_Num") <> "U" .and. !Empty(TSi_Num)) .or. lPesqSI
   Return .f.
Endif
  
Return .t.