#INCLUDE "rwmake.ch"                                         
#INCLUDE 'TOPCONN.CH' 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADLPCON  บ Autor ณ Edson rodrigues    บ Data ณ  20/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de LP X CC X Conta                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CADLPCON()

Local cfiltro     := ""
Local cAlias    := "ZZN"
Private cCadastro := "Cad Lp X Ccusto X Conta"
Private ctabela   := 'ZZN'
Private aRotina   :=   {{'Pesquisar' , "AxPesqui"  , 0,1},;   //"Pesquisar"
						{'Visualizar', "AxVisual"  , 0,2},;   //"Visualizar"
						{"Incluir"   , "u_InclZZN()" , 0,3},;  //"Inclusao"
						{"Alterar"    ,'u_alteZZN()',0,4},;                   
						{"Excluir"    ,"AxDeleta" ,0,5},;
						{"Copiar"    , 'u_copZZN()',0,6}}      

Private	lUsrAut     :=.F.
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
 

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado a fazer troca de IMEI
	If upper(AllTrim(GRPRetName(aGrupos[i]))) $ "CONTCADCONTAXLP"
		lUsrAut  := .T.
	EndIf
	
Next i         


If !lUsrAut
	MsgAlert("Voce nao tem autorizacao para executar essa rotina. Contate o administrador do sistema.","Usuario nao Autorizado")
	return
Endif


Dbselectarea("CT5")    
Dbsetorder(1)



Dbselectarea("CTT")
Dbsetorder(1)

DbSelectArea("ZZN") //Cad Lp X Ccusto X Conta
dbSetOrder(1) 
//ZZN->(dbsetfilter({|| &(cFiltro)} ,cFiltro))
mBrowse( 6,1,22,75,cAlias, , , , , ,)

Return          



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInclzzn   บ Autor ณ Edson rodrigues    บ Data ณ  20/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
user Function Inclzzn(cAlias,nReg, nOpc)

Local cTitulo	:= "Inclusao de itens - Cadatro LP X C.Custo X Conta"
Local aCab		:= {} // Array com descricao dos campos do Cabecalho do Modelo 2
Local aRoda		:= {} // Array com descricao dos campos do Rodape do Modelo 2
Local aGrid		:= {80,005,050,300}  //Array com coordenadas da GetDados no modelo2 - Padrao: {44,5,118,315}               
// Linha Inicial - Coluna Inicial - +Qts Linhas - +Qts Colunas : {080,005,050,300}
Local cLinhaOk	:= "u_vlizzn(3)" // Validacoes na linha da GetDados da Modelo 2
Local cTudoOk	:= "u_vlitzzn(3)" // Validacao geral da GetDados da Modelo 2
Local lRetMod2  := .F. // Retorno da fun็ใo Modelo2 - .T. Confirmou / .F. Cancelou
Local nColuna	:= 0
Local cnewchav  := SPACE(6)
Local lvalinfo  :=.t.   

Private cultchav  := SPACE(6)        
// Variaveis para GetDados()
Private aCols	:= {}
Private aHeader	:= {}


// Variaveis para campos da Enchoice()
Private cZZNCCSOP := SPACE(9)
Private cZZNDCSOP := SPACE(40)

// Montagem do array de cabe็alho
// AADD(aCab,{"Variแvel"	,{L,C} ,"Tํtulo","Picture","Valid","F3",lEnable})
AADD(aCab,{"cZZNCCSOP",{015,023} ,"CC.SUP/GRUPO","@!","naovazio() .and. existcpo('CTT')","CTTSUP",.T.})
AADD(aCab,{"cZZNDCSOP",{015,110} ,"DESCRICAO","@!",,,.F.})
                            



//If empty(acab[n,_nPoscsop]) 
//MsgAlert("Centro de Custo Superior (operacao) nao digitado, digite um Centro de Custo Superior (operacao)","C.Custo Sup. Invalido")
//lret:=.f.
 
//Elseif !empty(acab[n,_nPoscsop]) .and. empty(aCab[n,_nPosdsop]) 
//Procurar a descricao na tabela CTT
//
    

// Montagem do aHeader
AADD(aHeader,{"LP"		   ,"ZZN_LANPAD"   ,"@!" ,3,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"SEQ"		   ,"ZZN_SEQLP"      ,"@!" ,3,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"Desc. LP"   ,"ZZN_DESCLP"   ,"@!" ,40,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"Funcao/PRG" ,"ZZN_FUNCAO"   ,"@!" ,20,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"Conta"      ,"ZZN_CONTA"    ,"@!" ,20,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"Natureza"   ,"ZZN_CODNAT"   ,"@!" ,10,0,"AllwaysTrue()","","C","","R"})

// Montagem do aCols
aCols := Array(1,Len(aHeader)+1)

// Inicializa็ใo do aCols
For nColuna := 1 to Len(aHeader)

	If aHeader[nColuna][8] == "C"
		aCols[1][nColuna] := SPACE(aHeader[nColuna][4])
	ElseIf aHeader[nColuna][8] == "N"
		aCols[1][nColuna] := 0
	ElseIf aHeader[nColuna][8] == "D"
		aCols[1][nColuna] := CTOD("")
	ElseIf aHeader[nColuna][8] == "L"
		aCols[1][nColuna] := .F.
	ElseIf aHeader[nColuna][8] == "M"
		aCols[1][nColuna] := ""
	Endif

Next nColuna

aCols[1][Len(aHeader)+1] := .F. // Linha nใo deletada

DbSelectArea("ZZN") 

lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,nOpc,cLinhaOk,cTudoOk)


IF CTT->(dbSeek(xFilial("CTT") +cZZNCCSOP)) 
   IF  ALLTRIM(cZZNDCSOP) <> ALLTRIM(CTT->CTT_DESC01)
       cZZNDCSOP:=ALLTRIM(CTT->CTT_DESC01)
   ENDIF
ELSE
   lRetMod2:=.F.
	MsgAlert("Centro de Custo Superior Invalido "," CC. Sup Invalido")
ENDIF

DbSelectArea("ZZN") 


IF lRetMod2
    //MsgInfo("Voc๊ confirmou a opera็ใo","MBRW2SX5")
  	 For nLinha := 1 to len(aCols)
	 IF !aCols[nLinha,len(aHeader)+1]  
		// Campos de Cabe็alho
		Reclock("ZZN",.T.)
		ZZN->ZZN_FILIAL  := XFILIAL("ZZN")
		ZZN->ZZN_CCSOPE  := cZZNCCSOP
		ZZN->ZZN_DESCOP  := cZZNDCSOP
		For nColuna := 1 to Len(aHeader) 
		    ZZN->&(aHeader[nColuna][2]) := aCols[nLinha][nColuna]		
		Next nColuna
		MsUnLock()
	  ENDIF
	Next nLinha
ELSE
	MsgAlert("Voc๊ cancelou a opera็ใo","Inclzzn")
ENDIF

Return  
         
/*                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvlizzn    บ Autor ณ Edson rodrigues    บ Data ณ  13/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ Valida linha digitada da chave do registro                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function vlizzn(nopc)



Local _nPoslanp := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_LANPAD" })
Local _nPosseql := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_SEQLP" })
Local _nPosdesl := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_DESCLP" })
Local _nPosfunc := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_FUNCAO" })
Local _nPoscnat := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_CODNAT" })
Local lret:=.t.



IF CTT->(dbSeek(xFilial("CTT") +cZZNCCSOP)) 
   IF  ALLTRIM(cZZNDCSOP) <> ALLTRIM(CTT->CTT_DESC01)
       cZZNDCSOP:=ALLTRIM(CTT->CTT_DESC01)
   ENDIF
ELSE
   lRet:=.F.
   MsgAlert("Centro de Custo Superior Invalido "," CC. Sup Invalido")
ENDIF


xCols := aCols  // carrego com os campos contidos no aCols do cadastro


if nopc==3 .and. !aCols[n,len(aHeader)+1] 

   if empty(acols[n,_nPoslanp])   
      MsgAlert("Codigo do Lanc. Padrao nao digitado, digite um Codigo de Lanc. padrao","Lanc. Padrao Invalido")
      lret:=.f.

   Elseif empty(acols[n,_nPosseql])   
      MsgAlert("Sequencia do Lanc. Padrao nao digitado, digite uma Sequencia de Lanc. padrao","Sequencia Lanc. Padrao Invalido")
      lret:=.f.

   Elseif empty(acols[n,_nPosfunc])   
      MsgAlert("Funcao nใo digitada, digite a funcao","funcao Invalido")
      lret:=.f.

   
   Elseif !empty(acols[n,_nPoslanp]) .and. !empty(acols[n,_nPosseql]) 
       IF CT5->(dbSeek(xFilial("CT5")+acols[n,_nPoslanp]+acols[n,_nPosseql]))
          If empty(acols[n,_nPosdesl])
             acols[n,_nPosdesl]:=ALLTRIM(CT5->CT5_DESC)
          Endif
       Else
          MsgAlert("Lanc. Padrao e ou Sequencia digitada nao existe, digite o Lanc Padrใo ou Sequencia correta","Lan. Padrao e ou Sequencia Invalido")
          lret:=.f.
       Endif
  Endif

Endif
  
return(lret)





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvlitzzn   บ Autor ณ Edson rodrigues    บ Data ณ  13/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ Valida todas as linhas digitadas da chave do registro      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

user function vlitzzn(nopc)

Local _nPoslanp := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_LANPAD" })
Local _nPosseql := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_SEQLP" })
Local _nPosdesl := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_DESCLP" })
Local _nPosfunc := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_FUNCAO" })
Local _nPoscnat := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "ZZN_CODNAT" })
Local lret      :=.t.
Local _cdescr   :=""


IF CTT->(dbSeek(xFilial("CTT") +cZZNCCSOP)) 
   IF  ALLTRIM(cZZNDCSOP) <> ALLTRIM(CTT->CTT_DESC01)
       cZZNDCSOP:=ALLTRIM(CTT->CTT_DESC01)
   ENDIF
ELSE
   lRet:=.F.
   MsgAlert("Centro de Custo Superior Invalido "," CC. Sup Invalido")
ENDIF

       
xCols := aCols  // carrego com os campos contidos no aCols do cadastro
                     

For x:= 1 to len(acols)

 If nopc==3 .and. !aCols[x,len(aHeader)+1] 
     
   If empty(acols[n,_nPoslanp])   
      MsgAlert("Codigo do Lanc. Padrao nao digitado, digite um Codigo de Lanc. padrao","Lanc. Padrao Invalido")
      lret:=.f.

   Elseif empty(acols[n,_nPosseql])   
      MsgAlert("Sequencia do Lanc. Padrao nao digitado, digite uma Sequencia de Lanc. padrao","Sequencia Lanc. Padrao Invalido")
      lret:=.f.

   Elseif empty(acols[n,_nPosfunc])   
      MsgAlert("Funcao nใo digitada, digite a funcao","funcao Invalido")
      lret:=.f.

   
   Elseif !empty(acols[n,_nPoslanp]) .and. !empty(acols[n,_nPosseql]) 
       IF CT5->(dbSeek(xFilial("CT5")+acols[n,_nPoslanp]+acols[n,_nPosseql]))
          If empty(acols[n,_nPosdesl])
             acols[n,_nPosdesl]:=ALLTRIM(CT5->CT5_DESC)
          Endif
       Else
          MsgAlert("Lanc. Padrao e ou Sequencia digitada nao existe, digite o Lanc Padrใo ou Sequencia correta","Lan. Padrao e ou Sequencia Invalido")
          lret:=.f.
       Endif
   Endif
 Endif
Next

return(lret)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณaltezzn   บ Autor ณ Edson rodrigues    บ Data ณ  07/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
user Function altezzn(cAlias,nReg, nOpc)

Local cTitulo	:= "Altera็ใo de Itens - Arquivo de Tabelas"
Local aCab		:= {} // Array com descricao dos campos do Cabecalho do Modelo 2
Local aRoda		:= {} // Array com descricao dos campos do Rodape do Modelo 2
Local aGrid		:= {80,005,050,300}  //Array com coordenadas da GetDados no modelo2 - Padrao: {44,5,118,315}               
// Linha Inicial - Coluna Inicial - +Qts Linhas - +Qts Colunas : {080,005,050,300}
Local cLinhaOk	:= ".t." // Validacoes na linha da GetDados da Modelo 2
Local cTudoOk	:= ".t." // Validacao geral da GetDados da Modelo 2
Local lRetMod2  := .F. // Retorno da fun็ใo Modelo2 - .T. Confirmou / .F. Cancelou
Local nColuna	:= 0
Local cnewchav  := SPACE(6)
Local lvalinfo  :=.t.   


Private cultchav  := SPACE(6)        

// Variaveis para GetDados()
Private aCols	:= {}
Private aHeader	:= {}


// Variaveis para campos da Enchoice()
Private cZZNCCSOP := ALLTRIM(ZZN->ZZN_CCSOPE)
Private cZZNDCSOP := ALLTRIM(ZZN->ZZN_DESCOP)

// Montagem do array de cabe็alho
// AADD(aCab,{"Variแvel"	,{L,C} ,"Tํtulo","Picture","Valid","F3",lEnable})
AADD(aCab,{"cZZNCCSOP",{015,023} ,"CC.SUP/GRUPO","@!",,,.F.})
AADD(aCab,{"cZZNDCSOP",{015,110} ,"DESCRICAO","@!",,,.F.})


// Montagem do aHeader
AADD(aHeader,{"LP"		   ,"ZZN_LANPAD"   ,"@!" ,03,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"SEQ"		   ,"ZZN_SEQLP"    ,"@!" ,03,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"Desc. LP"   ,"ZZN_DESCLP"   ,"@!" ,40,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"Funcao/PRG" ,"ZZN_FUNCAO"   ,"@!" ,20,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"Conta"      ,"ZZN_CONTA"    ,"@!" ,20,0,"AllwaysTrue()","","C","","R"})
AADD(aHeader,{"Natureza"   ,"ZZN_CODNAT"   ,"@!" ,10,0,"AllwaysTrue()","","C","","R"})



// Montagem do aCols
aCols := Array(1,Len(aHeader)+1)


// Inicializa็ใo do aCols
For nColuna := 1 to Len(aHeader)

	If aHeader[nColuna][8] == "C"
		aCols[1][nColuna] := SPACE(aHeader[nColuna][4])
	ElseIf aHeader[nColuna][8] == "N"
		aCols[1][nColuna] := 0
	ElseIf aHeader[nColuna][8] == "D"
		aCols[1][nColuna] := CTOD("")
	ElseIf aHeader[nColuna][8] == "L"
		aCols[1][nColuna] := .F.
	ElseIf aHeader[nColuna][8] == "M"
		aCols[1][nColuna] := ""
	Endif

Next nColuna

aCols[1][Len(aHeader)+1] := .F. // Linha nใo deletada
aCols[1][1]:=ZZN->ZZN_LANPAD   
aCols[1][2]:=ZZN->ZZN_SEQLP   
aCols[1][3]:=ZZN->ZZN_DESCLP   
aCols[1][4]:=ZZN->ZZN_FUNCAO   
aCols[1][5]:=ZZN->ZZN_CONTA   
aCols[1][6]:=ZZN->ZZN_CODNAT   

DbSelectArea("ZZN") //Cad Lp X Ccusto X Conta

lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,nOpc,cLinhaOk,cTudoOk)

Dbselectarea("CTT")
Dbsetorder(1)

IF CTT->(dbSeek(xFilial("CTT") +cZZNCCSOP)) 
   IF  ALLTRIM(cZZNDCSOP) <> ALLTRIM(CTT->CTT_DESC01)
       cZZNDCSOP:=ALLTRIM(CTT->CTT_DESC01)    
       
   ENDIF
ELSE
   lRetMod2:=.F.
	MsgAlert("Centro de Custo Superior Invalido "," CC. Sup Invalido")
ENDIF

DbSelectArea("ZZN") 


IF lRetMod2
    //MsgInfo("Voc๊ confirmou a opera็ใo","MBRW2SX5")
	For nLinha := 1 to len(aCols)
	 IF !aCols[nLinha,len(aHeader)+1]  
		// Campos de Cabe็alho
		Reclock("ZZN",.F.)
		For nColuna := 1 to Len(aHeader) 
		    ZZN->&(aHeader[nColuna][2]) := aCols[nLinha][nColuna]		
		Next nColuna
		MsUnLock()
	  ENDIF
	Next nLinha
ELSE
	MsgAlert("Voc๊ cancelou a opera็ใo","altezzn")
ENDIF

Return  
                  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcopZZN    บ Autor ณ Edson rodrigues    บ Data ณ  05/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que copia  registros por Centro de Custo superior   บฑฑ
ฑฑบ          ณ e abre uma tela para alteracao somente das contas          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User function copZZN()

	MsgAlert("rotina em desenvolvimento","copzzn")                       
	
return