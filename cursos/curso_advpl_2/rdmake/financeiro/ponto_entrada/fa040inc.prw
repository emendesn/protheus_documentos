#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

User Function FA040INC()

Local aArea 	:= GetArea() 
Local cPrefixo	:= Getmv("MV_XPREACE",.F.,"ACE")

If M->E1_PREFIXO == cPrefixo//M->E1_XTITACE == "S"
	PESQCSS()
Endif

RestArea(aArea)

Return .T.

Static Function PESQCSS()
LOCAL nOpc         	:= 0
LOCAL aMarked      	:= {}
Local _lRetorno 	:= .F. //Validacao da dialog criada oDlg
Local _nOpca 		:= 0 //Opcao da confirmacao
Local bOk 			:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
Local bCancel 		:= {|| _nOpca:=0,oDlg:End() } //botao de cancelamento
Local _cArqEmp 		:= "" //Arquivo temporario com as empresas a serem escolhidas
Local _aStruTrb 	:= {} //estrutura do temporario
Local _aBrowse 		:= {} //array do browse para demonstracao das empresas
Local _aEmpMigr 	:= {} //array de retorno com as empresas escolhidas
Local aOpcoes 		:= {}
Local nOpcaoProd   

Local aStruTrb 		:= {}

Private lInverte := .F. //Variaveis para o MsSelect
Private xMarca := GetMark() //Variaveis para o MsSelect
Private oBrwTrb //objeto do msselect Private oDlg

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Monta area de trabalho                                                  � 
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

aadd(aStruTrb,{"OK"    ,"C",2,0})
aadd(aStruTrb,{"CSSNUM"    ,"C",TamSx3("Z14_CSSNUM")[1],TamSx3("Z14_CSSNUM")[2]})
aadd(aStruTrb,{"PRODUT"    ,"C",TamSx3("Z14_PRODUT")[1],TamSx3("Z14_PRODUT")[2]})
aadd(aStruTrb,{"SERIE"     ,"C",TamSx3("Z14_SERIE")[1],TamSx3("Z14_SERIE")[2]})

aadd(_aBrowse,{"TRB_OK"    ,,"" })                               
aadd(_aBrowse,{"CSSNUM"    ,,"Ticket", })
aadd(_aBrowse,{"PRODUT"    ,,"Produto", })
aadd(_aBrowse,{"SERIE"   ,,"No. Serie" ,})


cArquivo := CriaTrab(aStruTrb,.T.)
dbUseArea(.T.,__localDriver,cArquivo,"TRB",.F.,.F.)
__DBZAP()

	If Select("TSZ14") > 0
		TSZ14->(dbCloseArea())
	endif


cQuery := " SELECT    " 
cQuery += "		Z14_CSSNUM, "
cQuery += "   	Z14_PRODUT, "
cQuery += "   	Z14_SERIE "
cQuery += "	FROM "+RetSQLName("Z14")+" Z14 "              
cQuery += "	WHERE 
cQuery += "		Z14_FILIAL  = '"+xFilial("Z14")+"' AND "
cQuery += "		Z14_CLIENT = '"+M->E1_CLIENTE+"' AND "
cQuery += "		Z14_PEDIDO = '' AND "
cQuery += "		Z14.D_E_L_E_T_ = ' '  "
cQuery += "	ORDER BY 1 "

TCQUERY cQuery ALIAS "TSZ14" NEW

dbGotop()
dbSelectArea("TSZ14")

While ! TSZ14->(Eof())
  TRB->(RecLock("TRB",.T.))
  TRB->OK    		:= ""
  TRB->CSSNUM     := TSZ14->Z14_CSSNUM
  TRB->PRODUT     := TSZ14->Z14_PRODUT
  TRB->SERIE      := TSZ14->Z14_SERIE
  TSZ14->(dbskip())
End


TSZ14->(dbCloseArea())


dbSelectArea("TRB")
dbGotop()
If TRB->(!EOF())
                                      
	DEFINE MSDIALOG oDlg TITLE "Sele豫o de Ticket" From 0,0 To 37,123 OF oMainWnd
	
	oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@lInverte,@xMarca,{60,10,255,475})
	oBrwTrb:oBrowse:lCanAllmark := .T.
	oBrwTrb:oBrowse:lHasMark	 	:=.T.
	oBrwTrb:bMark 				:= {|| .t.}
	oBrwTrb:oBrowse:bAllMark		:= {|| MsAguarde({||U_MarCSS()}),Eval(oBrwTrb:oBrowse:bGoTop),oBrwTrb:oBrowse:Refresh() }
	
	Eval(oBrwTrb:oBrowse:bGoTop)
	oBrwTrb:oBrowse:Refresh()
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||If(MsgNoYes( "Confirma ticket selecionado para esse titulo ?", "CSS" ),(MsAguarde({||If(AtuTicket(),oDlg:End(),) }),),)},{||oDlg:End()},,/*aButtons*/)
Endif

TRB->(dbclosearea())

Return .t.     
*-----------------------*
User Function MarCSS()
*-----------------------*                         
TRB->(dbgotop())
While ! TRB->(Eof()) 
   TRB->OK	= If(!Empty(TRB->OK), "",xMarca)     
   TRB->(MsUnlock())
   TRB->(dbskip())
End
TRB->(dbgotop())
Return .t.                                                      


*------------------------*
Static Function AtuTicket()  
*------------------------*
Local lMarcados:=.f.

TRB->(dbgotop())  

While ! TRB->(Eof())
  If ! Empty( TRB->OK ) 
     lMarcados:=.t.
     Exit
  Endif   
  TRB->(dbskip())
End       

TRB->(dbgotop())
If ! lMarcados
   MsgStop("Nenhum ticket foi selecionado","Aten豫o")
   Return .f.
Endif                                          


While ! TRB->(Eof())
  If Empty( TRB->OK ) 
     TRB->(dbskip()) ; Loop
  Endif    
  M->E1_XCSSNUM := TRB->CSSNUM
  EXIT     
  TRB->(dbskip())
End
            
Return .t.