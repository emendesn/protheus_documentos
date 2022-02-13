#INCLUDE "rwmake.ch"                                         
#INCLUDE 'TOPCONN.CH' 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CATPACESS � Autor � Edson rodrigues    � Data �  07/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �  Cadastro de Tipo de Acessorios                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CATPACESS()

Local cfiltro     := "X5_TABELA='Z5'"
Local cAlias    := "SX5"
Private cCadastro := "Tipo de Acessorios"
Private ctabela   := 'Z5   '
Private aRotina   := { 	{'Pesquisar' , "AxPesqui"  , 0,1},;   //"Pesquisar"
{'Visualizar', "AxVisual"  , 0,2},;   //"Visualizar"
{"Incluir"   , "u_Inclsx5()" , 0,3},;  //"Inclusao"
{"Alterar"    ,'u_altesx5()',0,4}}

u_GerA0003(ProcName())

DbSelectArea("SX5") //Entrada Massiva
dbSetOrder(1) 
SX5->(dbsetfilter({|| &(cFiltro)} ,cFiltro))
mBrowse( 6,1,22,75,cAlias, , , , , ,)

Return          



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Inclaces  � Autor � Edson rodrigues    � Data �  07/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user Function Inclsx5(cAlias,nReg, nOpc)

Local cTitulo	:= "Inclusao de itens - Arquivo de Tabelas"
Local aCab		:= {} // Array com descricao dos campos do Cabecalho do Modelo 2
Local aRoda		:= {} // Array com descricao dos campos do Rodape do Modelo 2
Local aGrid		:= {80,005,050,300}  //Array com coordenadas da GetDados no modelo2 - Padrao: {44,5,118,315}               
// Linha Inicial - Coluna Inicial - +Qts Linhas - +Qts Colunas : {080,005,050,300}
Local cLinhaOk	:= "u_vlinhok(3)" // Validacoes na linha da GetDados da Modelo 2
Local cTudoOk	:= "u_vtudook(3)" // Validacao geral da GetDados da Modelo 2
Local lRetMod2  := .F. // Retorno da fun��o Modelo2 - .T. Confirmou / .F. Cancelou
Local nColuna	:= 0
Local cnewchav  := SPACE(6)
Local lvalinfo  :=.t.   


Private cultchav  := SPACE(6)        

// Variaveis para GetDados()
Private aCols	:= {}
Private aHeader	:= {}

// Variaveis para campos da Enchoice()
Private cX5Filial := xFilial("SX5")
Private cX5Tabela := IIF(EMPTY(ctabela),SPACE(5),ctabela)

// Montagem do array de cabe�alho
// AADD(aCab,{"Vari�vel"	,{L,C} ,"T�tulo","Picture","Valid","F3",lEnable})
AADD(aCab,{"cX5Filial"	,{015,010} ,"Filial","@!",,,.F.})
IF EMPTY(ctabela)
    AADD(aCab,{"cX5Tabela"	,{015,080} ,"Tabela","@!",,,.T.})
ELSE
    AADD(aCab,{"cX5Tabela"	,{015,080} ,"Tabela","@!",,,.F.})
ENDIF    

// Montagem do aHeader
AADD(aHeader,{"Chave"		,"X5_CHAVE","@!",6,0,"AllwaysTrue()",;
			   "","C","","R"})
AADD(aHeader,{"Descricao"	,"X5_DESCRI","@!",40,0,"AllwaysTrue()",;
			   "","C","","R"})

// Montagem do aCols
aCols := Array(1,Len(aHeader)+1)

// Inicializa��o do aCols
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

aCols[1][Len(aHeader)+1] := .F. // Linha n�o deletada

IF !EMPTY(ctabela) .and. alltrim(ctabela) $ "Z5" 
   cultchav:=ultrecx5(ctabela)
   If !empty(cultchav) .and. len(cultchav)=6
     cnewchav:=strzero(val(cultchav)+1,6)
     aCols[1][1]:=cnewchav                             
   Endif
ENDIF

DbSelectArea("SX5") //Entrada Massiva

lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,nOpc,cLinhaOk,cTudoOk)






IF lRetMod2
    //MsgInfo("Voc� confirmou a opera��o","MBRW2SX5")
	For nLinha := 1 to len(aCols)
	 IF !aCols[nLinha,len(aHeader)+1]  
		// Campos de Cabe�alho
		Reclock("SX5",.T.)
		SX5->X5_FILIAL := cX5Filial
		SX5->X5_TABELA := cX5Tabela
		// Campos do aCols
		//SX5->X5_CHAVE  := aCols[nLinha][1]
		//SX5->X5_DESCRI := aCols[nLinha][2]		
   
		For nColuna := 1 to Len(aHeader) 
		
			SX5->&(aHeader[nColuna][2]) := aCols[nLinha][nColuna]		
		    IF aHeader[nColuna][2]=="X5_DESCRI"
		       SX5->X5_DESCSPA := aCols[nLinha][nColuna]		
		       SX5->X5_DESCENG := aCols[nLinha][nColuna]		
		    ENDIF
		Next nColuna
		MsUnLock()
	  ENDIF
	Next nLinha
ELSE
	MsgAlert("Voc� cancelou a opera��o","Inclsx5")
ENDIF

Return  
         
                              
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ultrecx5  � Autor � Edson rodrigues    � Data �  07/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          � Busca ultimo registro no SX5 da tabela selecionada         ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


Static function ultrecx5(ctab)
Local culchav:="0"         


If Select("QrySX5") > 0
	QrySX5->(dbCloseArea())
Endif

cselQry:="SELECT MAX(X5_CHAVE) AS CHAVE FROM "+RetSqlName("SX5")+" (NOLOCK) "
cselQry+="WHERE X5_FILIAL='"+xFilial("SX5")+"' AND  X5_TABELA='"+ctab+"' AND D_E_L_E_T_='' "


TCQUERY cselQry ALIAS "QrySX5" NEW
TCRefresh(RetSqlName("SX5"))

If Select("QrySX5") > 0
   QrySX5->(dbGoTop())
   IF QrySX5->(!eof()) 
	   culchav:=QrySX5->CHAVE
   Endif	   
   QrySX5->(dbCloseArea())
Endif

return(culchav)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �vlinhok  � Autor � Edson rodrigues    � Data �  13/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          � Valida linha digitada da chave do registro                 ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User function vlinhok(nopc)

Local _nPoschv  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "X5_CHAVE"   })
Local _nPosDsc  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "X5_DESCRI" })
Local lret:=.t.
       
xCols := aCols  // carrego com os campos contidos no aCols do cadastro

if nopc==3 .and. !aCols[n,len(aHeader)+1] 
   If empty(acols[n,_nPoschv]) 
      MsgAlert("Chave sequencial em branco, digite a chave sequencial de 6 n�meros","Chave Invalida")
      lret:=.f.

   Elseif empty(acols[n,_nPosDsc])   
      MsgAlert("Descri��o em Branco, digite uma descri�ao","Descricao em branco")
      lret:=.f.

   Elseif n==1 .and. !alltrim(acols[n,_nPoschv])==strzero(val(cultchav)+1,6)
      MsgAlert("A proxima chave sequencial �: "+strzero(val(cultchav)+1,6)+", digite a chave sequencial correta","Chave Invalida")
      lret:=.f.

   Elseif n > 1 .and. val(acols[n,_nPoschv]) < val(cultchav)+n
      cnewchav:=strzero(val(cultchav)+n,6)
      MsgAlert("A proxima chave sequencial �: "+cnewchav+", digite a chave sequencial correta","Chave Invalida")
      lret:=.f.
   Endif

   If lret .and. n >= 1                                              
   
   
      IF n == len(acols) .and. !aCols[n,len(aHeader)+1]
	     //-----------------------------------------------------------
	     // Adiciona mais uma linha no aCols com os campos originais |
	     //-----------------------------------------------------------
	     AADD(aCols,Array(Len(aheader)+1))
	     For _ni:=1 to Len(aheader)
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
			aCols[Len(aCols),_ni]:=xCols[n,_ni]    
	     Next
	     aCols[Len(aCols),Len(aheader)+1]:=.F.  
         cnewchav:=strzero(val(cultchav)+n+1,6)
         aCols[n+1][1]:=cnewchav
      
      Endif                               

   Endif
Elseif nopc==4 .and. n > 1
     MsgAlert("N�o � permitido incluir linha na op��o altera��o","Opera��o Invalida")
     lret:=.f.
Endif   

return(lret)





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �vtudook  � Autor � Edson rodrigues    � Data �  13/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          � Valida todas as linhas digitadas da chave do registro      ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User function vtudook(nopc)

Local _nPoschv  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "X5_CHAVE"   })
Local _nPosDsc  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "X5_DESCRI" })
Local lret      :=.t.
Local _cdescr   :=""
       
xCols := aCols  // carrego com os campos contidos no aCols do cadastro
                     

For x:= 1 to len(acols)

  if nopc==3 .and. !aCols[x,len(aHeader)+1] 
     
     If empty(acols[x,_nPoschv]) 
         MsgAlert("Chave sequencial em branco, digite a chave sequencial de 6 n�meros","Chave Invalida")
         lret:=.f.

     Elseif empty(acols[x,_nPosDsc])   
         MsgAlert("Descri��o em Branco, digite uma descri�ao","Descricao em branco")
         lret:=.f.

     Elseif x==1 .and. !alltrim(acols[x,_nPoschv])==strzero(val(cultchav)+1,6)
         //MsgAlert("A proxima chave sequencial �: "+strzero(val(cultchav)+1,6)+", digite a chave sequencial correta","Chave Invalida")
         aCols[x][1]:=strzero(val(cultchav)+1,6)
     
     Elseif x > 1 .and. val(acols[x,_nPoschv]) < val(cultchav)+x
         cnewchav:=strzero(val(cultchav)+x,6)
         //MsgAlert("A proxima chave sequencial �: "+cnewchav+", digite a chave sequencial correta","Chave Invalida")
         aCols[x][1]:=strzero(val(cultchav)+1,6)
         //lret:=.f.
     Endif
  
     IF lret .and. alltrim(aCols[x][2]) $ _cdescr
        MsgAlert("A Descricao do acessorio : "+alltrim(aCols[x][1])+ " / "+alltrim(aCols[x][2])+ " est� repetido nesse cadastro. Favor Alterar a Descricao","Descricao em duplicidade")
        lret:=.f.
     ENDIF
     
     _cdescr:=_cdescr+alltrim(aCols[x][2])+"/"

  Elseif  nopc==4 .and. x > 1
     MsgAlert("N�o � permitido mais de uma linha na op��o altera��o","Opera��o Invalida")
     lret:=.f.
  
  Elseif  nopc==4 .and. !aCols[x,len(aHeader)+1]  .and.  empty(acols[x,_nPosDsc])   
     MsgAlert("Descri��o em Branco, digite uma descri�ao","Descricao em branco")
     lret:=.f.
  Endif   

Next

return(lret)




/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �altesx5  � Autor � Edson rodrigues    � Data �  07/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user Function altesx5(cAlias,nReg, nOpc)

Local cTitulo	:= "Altera��o de Itens - Arquivo de Tabelas"
Local aCab		:= {} // Array com descricao dos campos do Cabecalho do Modelo 2
Local aRoda		:= {} // Array com descricao dos campos do Rodape do Modelo 2
Local aGrid		:= {80,005,050,300}  //Array com coordenadas da GetDados no modelo2 - Padrao: {44,5,118,315}               
// Linha Inicial - Coluna Inicial - +Qts Linhas - +Qts Colunas : {080,005,050,300}
Local cLinhaOk	:= "u_vlinhok(4)" // Validacoes na linha da GetDados da Modelo 2
Local cTudoOk	:= "u_vtudook(4)" // Validacao geral da GetDados da Modelo 2
Local lRetMod2  := .F. // Retorno da fun��o Modelo2 - .T. Confirmou / .F. Cancelou
Local nColuna	:= 0
Local cnewchav  := SPACE(6)
Local lvalinfo  :=.t.   


Private cultchav  := SPACE(6)        

// Variaveis para GetDados()
Private aCols	:= {}
Private aHeader	:= {}

// Variaveis para campos da Enchoice()
Private cX5Filial := xFilial("SX5")
Private cX5Tabela := IIF(EMPTY(ctabela),SPACE(5),ctabela)
Private cX5chave  := SX5->X5_CHAVE

// Montagem do array de cabe�alho
// AADD(aCab,{"Vari�vel"	,{L,C} ,"T�tulo","Picture","Valid","F3",lEnable})
AADD(aCab,{"cX5Filial"	,{015,010} ,"Filial","@!",,,.F.})
IF EMPTY(ctabela)
    AADD(aCab,{"cX5Tabela"	,{015,080} ,"Tabela","@!",,,.T.})
    AADD(aCab,{"cX5CHAVE"	,{015,150} ,"Chave ","@!",,,.T.})
ELSE
    AADD(aCab,{"cX5Tabela"	,{015,080} ,"Tabela","@!",,,.F.})
    AADD(aCab,{"cX5CHAVE"	,{015,150} ,"Chave ","@!",,,.F.})
ENDIF    

// Montagem do aHeader

AADD(aHeader,{"Descricao"	,"X5_DESCRI","@!",40,0,"AllwaysTrue()",;
			   "","C","","R"})

// Montagem do aCols
aCols := Array(1,Len(aHeader)+1)

// Inicializa��o do aCols
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

aCols[1][Len(aHeader)+1] := .F. // Linha n�o deletada
aCols[1][1]:=SX5->X5_DESCRI                             

DbSelectArea("SX5") //Entrada Massiva

lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,nOpc,cLinhaOk,cTudoOk)

IF lRetMod2
	For nLinha := 1 to len(aCols)
	  IF !aCols[nLinha,len(aHeader)+1]  
		// Campos de Cabe�alho
		Reclock("SX5",.F.)
		For nColuna := 1 to Len(aHeader) 
			SX5->&(aHeader[nColuna][2]) := aCols[nLinha][nColuna]		
		    IF aHeader[nColuna][2]=="X5_DESCRI"
		       SX5->X5_DESCSPA := aCols[nLinha][nColuna]		
		       SX5->X5_DESCENG := aCols[nLinha][nColuna]		
		    ENDIF
		Next nColuna
		MsUnLock()
	  ENDIF
	Next nLinha
ELSE
	MsgAlert("Voc� cancelou a opera��o","Altesx5")
ENDIF
Return  
