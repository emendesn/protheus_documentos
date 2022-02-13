#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


#DEFINE DIRTEMP  "C:\TEMP\"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHIMPSA5  ºAutor  ³ Robson Sanchez     º Data ³ 	 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para tratamento Importação dados SA5                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                     
User Function EXPPO()
	Local cFunction    := FunName()
	Local cTitle       := "Geração da Planilha em Excel"
	Local cDescription := "Este programa tem por objetivo, ler um PO e gerar uma planilha em excel para Motorola"

	Local bProcess     := { |ExpO1| U_ExpXLS( ExpO1,cTitle,MV_PAR01 ) }
	Local aInfoCustom  := {}
	Local cPerg        := "EXPPO"
	Local aHelp        := {}
	Local cDirTXT      := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicao de perguntas ao SX1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aHelp := {}
	AAdd( aHelp, 'Informe o PO  ' )
	PutSx1(cPerg,'01','PO ?' ,'PO ?','PO ?','mv_ch1','C',TamSX3("W2_PO_NUM")[1],,0,'G','','SW2','','',"mv_par01","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

	tNewProcess():New(cFunction,cTitle,bProcess,cDescription,cPerg,aInfoCustom )

	Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExpXLS ºAutor  ³ Robson Sanchez     º Data ³ 25/01/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao dos arquivos no Pedido de Venda                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EDIXFUN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ExpXLS( oRegua,cTitle,cPO )
Local cBuffer			:= ''                      
Local cQuery
Local lGerouXLS := .F.
Local cCaminho := GetSrvProfString("StartPath","")
Local cArqXLS  := CriaTrab(Nil,.F.)+".csv"

If Empty( cPO )
	U_MsgHBox("Codigo do PO deve ser Informado")
	Return Nil
EndIf


MakeDir(DIRTEMP)

If File(cCaminho+cArqXLS)
	FErase(cCaminho+cArqXLS)
EndIf

SA5->(dbsetorder(3))
            
cQuery := "SELECT  " 
cQuery += "   SW3.W3_PO_NUM AS PO, SW3.W3_COD_I AS PRODUTO, SW3.W3_QTDE AS QTDE, SW3.W3_FORN, SW3.W3_FABR "
cQuery += "FROM "+RetSQLName("SW3")+" SW3 "              
cQuery += "WHERE SW3.W3_FILIAL = '"+xFilial("SW3")+"' AND SW3.W3_PO_NUM = '"+cPO+"' AND SW3.W3_SEQ = 0 AND SW3.D_E_L_E_T_ = '' "

TCQUERY cQuery ALIAS "TSW3" NEW
TCSetField("TSW3","W3_QTDE" , "N",TamSX3("W3_QTDE")[1],TamSX3("W3_QTDE")[2])

dbGotop()
dbSelectArea("TSW3")

While ! TSW3->(Eof())  

   lGerouXLS := .t.                    
   cPO       := TSW3->PO
   cProduto  := TSW3->PRODUTO            
   
   nQtde     := TSW3->QTDE
   
   If SA5->(dbseek(xFilial("SA5")+cProduto+TSW3->W3_FABR+TSW3->W3_FORN))  
      If SA5->A5_UNID  == "PK"         // Quando for pacote deve-se multiplicar a qtde unitaria pela qtde de Pacotes
         nQtde *= SA5->A5_QUANT01
      Endif
   Endif
   
   
   oRegua:IncRegua2( "Processando Produto nr: " +cProduto )

                                   
   cQtde     := Alltrim(str(nQtde))
   cQtde     := Strtran(cQtde,'.','')
   cQtde     := StrTran(cQtde,',','')
   
   cLinha :=  '"'+Alltrim(cPO)+","+Alltrim(cProduto)+","+cQtde+'"'
   AcaLog( cCaminho + cArqXLS, cLinha  )

   TSW3->(dbskip())
End
  
If lGerouXLS   
   If CpyS2T( cCaminho + cArqXLS, DIRTEMP, .T. )
      fErase( cCaminho + cArqXLS )
   EndIf
   MsgInfo("Arquivo Motorola gerado com Sucesso em "+DIRTEMP+cArqXLS)
Endif
	   
oExcelApp := MsExcel():New()
Sleep(2000)
oExcelApp:WorkBooks:Open( DIRTEMP+cArqXLS )
Sleep(2000)
oExcelApp:SetVisible( .T. )

Return .t.
