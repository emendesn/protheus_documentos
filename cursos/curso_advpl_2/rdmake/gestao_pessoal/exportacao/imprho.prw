#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"
#DEFINE ENTER chr(13)+chr(10)

/*
Funcao      : CargaCT1
Objetivos   : Função chamada para realizar a conversão de XLS para um array
Parâmetros  : cArqE    - Nome do arquivo XLS a ser carregado
              cOrigemE - Local onde está o arquivo XLS
              nLinTitE - Quantas linhas de cabeçalho que não serão integradas possui o arquivo
Autor       : Daniel Cardoso    
Data/Hora   : 10/10/2013
*/
*-------------------------*
User Function CARGARHO(cArqE,cOrigemE,nLinTitE,lTela)   
*-------------------------*
Local bOk        := {||lOk:=.T.,oDlg:End()}
Local bCancel    := {||lOk:=.F.,oDlg:End()}
Local lOk        := .F.
Local nLin       := 20
Local nCol1      := 15
Local nCol2      := nCol1+30
Local cMsg       := ""
Local oDlg
Local oArq
Local oOrigem
Local oMacro  

Default lTela := .T.

Private cArq       := If(ValType(cArqE)=="C",cArqE,"")
Private cArqMacro  := "XLS2DBF.XLA"
Private cTemp      := GetTempPath() //pega caminho do temp do client
Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema
Private cOrigem    := If(ValType(cOrigemE)=="C",cOrigemE,"")
Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
Private aArquivos  := {}
Private aRet       := {}


cArq       += Space(20-(Len(cArq)))
cOrigem    += Space(99-(Len(cOrigem)))

If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem)) 

   Define MsDialog oDlg Title 'Integração de Excel' From 7,10 To 30,70 OF oMainWnd         
      
      
      @ nLin,nCol1  Say      'Arquivo :'                                Of oDlg Pixel  
      @ nLin,nCol2  MsGet    oArq   Var cArq                 Size 60,09 Of oDlg Pixel  

      nLin += 15
  
      @ nLin,nCol1  Say      'Caminho do arquivo :'                     Of oDlg Pixel  
      nLin += 10
      @ nLin,nCol1  MsGet    oOrigem Var cOrigem            Size 130,09 Of oDlg Pixel  

      nLin += 15

      @ nLin,nCol1  Say      'Nome da Macro :'                          Of oDlg Pixel  
      nLin += 10
      @ nLin,nCol1  MsGet    oMacro  Var cArqMacro When .F. Size 130,09 Of oDlg Pixel  

   Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel) Centered
Else
   lOk := .T.
EndIf

If lOk 
   cMsg := validaCpos()
   If Empty(cMsg) 
      aAdd(aArquivos, cArq)
      IntegraArq()
   Else
      MsgStop(cMSg)
      Return
   EndIf
EndIf
//
Return aRet


/*
Funcao      : IntegraArq
Objetivos   : Faz a chamada das rotinas referentes a integração
Autor       : Daniel Cardoso    
Data/Hora   : 10/10/2013
*/
*-------------------------*
Static Function IntegraArq()
*-------------------------*
Local lConv      := .F.
//converte arquivos xls para csv copiando para a pasta temp
MsAguarde( {|| ConOut("Começou conversão do arquivo "+cArq+ " - "+Time()),;
               lConv := convArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )
If lConv
   //carrega do xls no array
   ConOut("Terminou conversão do arquivo "+cArq+ " - "+Time())   
   ConOut("Começou carregamento do arquivo "+cArq+ " - "+Time())
   Processa( {|| aRet:= CargaArray(AllTrim(cArq)) } ,;
                  "Aguarde, carregando planilha..."+ENTER+"Pode demorar") 
   ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
   //
EndIf
//
Return

/*
Funcao      : convArqs
Objetivos   : converte os arquivos .xls para .csv
Autor       : Daniel Cardoso
Data/Hora   : 10/10/2013
*/
*-------------------------*
Static Function convArqs(aArqs)
*-------------------------*
Local oExcelApp
Local cNomeXLS  := ""
Local cFile     := ""
Local cExtensao := ".csv"
Local i         := 1
Local j         := 1
Local aExtensao := {}

cOrigem := AllTrim(cOrigem)

//Verifica se o caminho termina com "\"
If !Right(cOrigem,1) $ "\"
   cOrigem := AllTrim(cOrigem)+"\"
EndIf


//loop em todos arquivos que serão convertidos
For i := 1 To Len(aArqs)      


   If !"." $ AllTrim(aArqs[i])
      //passa por aqui para verificar se a extensão do arquivo é .xls ou .xlsx
      aExtensao := Directory(cOrigem+AllTrim(aArqs[i])+".*")
      For j := 1 To Len(aExtensao)
         If "CSV" $ Upper(aExtensao[j][1])
            cExtensao := SubStr(aExtensao[j][1],Rat(".",aExtensao[j][1]),Len(aExtensao[j][1])+1-Rat(".",aExtensao[j][1]))
            Exit
         EndIf
      Next j
   EndIf
   //recebe o nome do arquivo corrente
   cNomeXLS := AllTrim(aArqs[i])
   cFile    := cOrigem+cNomeXLS+cExtensao
   
   If !File(cFile)
      MsgInfo("O arquivo "+cFile+" não foi encontrado!" ,"Arquivo")      
      Return .F.
   EndIf
     
   //verifica se existe o arquivo na pasta temporaria e apaga
   If File(cTemp+cNomeXLS+cExtensao)
      fErase(cTemp+cNomeXLS+cExtensao)
   EndIf                 
  
   //Copia o arquivo XLS para o Temporario para ser executado
   If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.) 
      MsgInfo("Problemas na copia do arquivo "+cFile+" para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
      Return .F.
   EndIf                                       
   
   //apaga macro da pasta temporária se existir
//   If File(cTemp+cArqMacro)
//      fErase(cTemp+cArqMacro)
//   EndIf

Next i

Return .T. 

/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Parâmetros  : cArq - nome do arquivo que será usado      
Autor       : Daniel Cardoso
Data/Hora   : 10/10/2013
*/
*-------------------------*
Static Function CargaArray(cArq)
*-------------------------*
Local cLinha  := ""
Local nLin    := 1 
Local nTotLin := 0
Local cFile   := cTemp + cArq + ".csv"
Local nHandle := 0

static aDados  := {}

//abre o arquivo csv gerado na temp
nHandle := Ft_Fuse(cFile)
If nHandle == -1
   Return aDados
EndIf
Ft_FGoTop()                                                         
nLinTot := FT_FLastRec()-1
ProcRegua(nLinTot)
//Pula as linhas de cabeçalho
While nLinTit > 0 .AND. !Ft_FEof()
   Ft_FSkip()
   nLinTit--
EndDo

//percorre todas linhas do arquivo csv
Do While !Ft_FEof()
   //exibe a linha a ser lida
   IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
   nLin++
   //le a linha
   cLinha := Ft_FReadLn()
   //verifica se a linha está em branco, se estiver pula
   If Empty(AllTrim(StrTran(cLinha,';','')))
      Ft_FSkip()
      Loop
   EndIf
   //transforma as aspas duplas em aspas simples
   cLinha := StrTran(cLinha,'"',"'")
   cLinha := '{"'+cLinha+'"}' 
   //adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array 
   cLinha := StrTran(cLinha,';','","')
   aAdd(aDados, &cLinha)
   
   //passa para a próxima linha
   FT_FSkip()
   //
EndDo

//libera o arquivo CSV
FT_FUse()             

//Exclui o arquivo csv
If File(cFile)
   FErase(cFile)
EndIf

aRet:= aClone(aDados)

Return aDados


/*
Funcao      : validaCpos
Objetivos   : faz a validação dos campos da tela de filtro
Autor       : Daniel Cardoso
Data/Hora   : 10/10/2013
*/
*-------------------------*
Static Function validaCpos()
*-------------------------*
Local cMsg := ""

If Empty(cArq)
   cMsg += "Campo Arquivo deve ser preenchido!"+ENTER
EndIf                            

If Empty(cOrigem)
   cMsg += "Campo Caminho do arquivo deve ser preenchido!"+ENTER
EndIf

If Empty(cArqMacro)
   cMsg += "Campo Nome da Macro deve ser preenchido!"
EndIf

Return cMsg





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³impfun1  º Autor ³ Daniel Cardoso º Data ³  10/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de funcionarios de uma planilha excel           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo da Empresa DLK                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function IMPRHO()

Local 	acliente:= u_CARGARHO()
Local 	aVetor 	:= {}
Local 	cCnpj   := ""
Local	nDif	:= 0
Local 	cTpPess := ""
Local	cDDD, cTel := ""
Local	cCodigo, cLoja	:= ""

Private lMsHelpAuto := .F. // para mostrar os erro na tela             
Private lMsErroAuto := .t.    

mesfol1 := GetMv("MV_FOLMES")

//Limpa tabelas   
/*
DbSelectArea("SRC")
SRC->(DbSetOrder(1)) 
While SRC->(!EoF()) 

	If SRC->RC_PD  $ "511 512 513 514 515"
   	   SRC->(RecLock("SRC",.F.))
	   SRC->(DbDelete())
	   SRC->(MsUnLock())
	EndIf
	SRC->(DbSkip())
EndDo
*/
//Limpa tabela RHO

DbSelectArea("RHO")
RHO->(DbSetOrder(1)) 
While RHO->(!EoF()) 

	If RHO->RHO_PD  $ "511 512 513 514 515" .AND. RHO->RHO_COMPPG = mesfol1
   	   RHO->(RecLock("RHO",.F.))
	   RHO->(DbDelete())
	   RHO->(MsUnLock())
	EndIf
	RHO->(DbSkip())
EndDo

mesfol := CTOD("01/"+SUBSTR(GetMv("MV_FOLMES"),5,2)+"/"+SUBSTR(GetMv("MV_FOLMES"),1,4))

dtdesc := LastDay(mesfol)+5


For  i:= 1 to len(acliente)             
	
	//PESQUISA SE A FUNCAO JA EXISTE, PARA QUE POSSAMOS INCLUI-LO
    DbSelectArea("SRC")
	dbSetOrder(1)

//	aLinha := separa(acliente[i,1], ",")

COD := Alltrim(acliente[I,2])	 
MAT := strzero(val(COD),6)
FILIAL := Alltrim(acliente[I,1])
FILIAL := strzero(val(FILIAL),2)

DbSelectArea("SRA")
DbSetOrder(1)      	
/*
	DbSeek(FILIAL + MAT)

		If Alltrim(acliente[I,3]) > "0"

			Reclock("SRC",.T.)
			
		RC_FILIAL  :=  FILIAL
 		RC_MAT     :=  MAT	 
		RC_PD      :=  "511"				 
		RC_TIPO1   :=  "V"
		RC_VALOR   :=  val(Alltrim(acliente[I,3]))
		RC_DATA    :=  dtdesc
		RC_CC      :=  SRA->RA_CC
		RC_TIPO2   :=  "G"
																								
			SRC->(MsUnlock())
	Endif
         
		If Alltrim(acliente[I,4]) > "0"

			Reclock("SRC",.T.)
			
		RC_FILIAL  :=  FILIAL
 		RC_MAT     :=  MAT	 
		RC_PD      :=  "512"				 
		RC_TIPO1   :=  "V"
		RC_VALOR   :=  val(Alltrim(acliente[I,4]))
		RC_DATA    :=  dtdesc
		RC_CC      :=  SRA->RA_CC
		RC_TIPO2   :=  "G"
																								
			SRC->(MsUnlock())
	Endif
	                                                                  
		If Alltrim(acliente[I,5]) > "0"

			Reclock("SRC",.T.)
			
		RC_FILIAL  :=  FILIAL
 		RC_MAT     :=  MAT	 
		RC_PD      :=  "513"				 
		RC_TIPO1   :=  "V"
		RC_VALOR   :=  val(Alltrim(acliente[I,5]))
		RC_DATA    :=  dtdesc
		RC_CC      :=  SRA->RA_CC
		RC_TIPO2   :=  "G"
																								
			SRC->(MsUnlock())
	Endif	

		If Alltrim(acliente[I,6]) > "0"

			Reclock("SRC",.T.)
			
		RC_FILIAL  :=  FILIAL
 		RC_MAT     :=  MAT	 
		RC_PD      :=  "514"				 
		RC_TIPO1   :=  "V"
		RC_VALOR   :=  val(Alltrim(acliente[I,6]))
		RC_DATA    :=  dtdesc
		RC_CC      :=  SRA->RA_CC
		RC_TIPO2   :=  "G"
																								
			SRC->(MsUnlock())
	Endif	
 
		If Alltrim(acliente[I,7]) > "0"

			Reclock("SRC",.T.)
			
		RC_FILIAL  :=  FILIAL
 		RC_MAT     :=  MAT	 
		RC_PD      :=  "515"				 
		RC_TIPO1   :=  "V"
		RC_VALOR   :=  val(Alltrim(acliente[I,7]))
		RC_DATA    :=  dtdesc
		RC_CC      :=  SRA->RA_CC
		RC_TIPO2   :=  "G"
																								
			SRC->(MsUnlock())
	Endif	
*/

// Matricula 1 - 511 2 - 512 3 - 513 4  dtocor 5 		

DbSelectArea("RHO")
DbSetOrder(1)      	



	If Alltrim(acliente[i,3]) > "0"

valor := val(Alltrim(acliente[I,3]))
	
		Reclock("RHO",.T.)


		RHO_FILIAL := FILIAL
		RHO_MAT    := MAT
		RHO_DTOCOR := date()
		RHO_ORIGEM := "1"
		RHO_TPFORN := "1"
		RHO_CODFOR := "001"
		RHO_TPLAN  := "1"
		RHO_PD     := "511"
		RHO_VLRFUN := valor
		RHO_COMPPG := mesfol1

		RHO->(MsUnlock())
    Endif

	If Alltrim(acliente[I,4]) > "0"

valor := val(Alltrim(acliente[i,4]))
	
		Reclock("RHO",.T.)


		RHO_FILIAL := FILIAL
		RHO_MAT    := MAT
		RHO_DTOCOR := date()
		RHO_ORIGEM := "1"
		RHO_TPFORN := "1"
		RHO_CODFOR := "001"
		RHO_TPLAN  := "1"
		RHO_PD     := "512"
		RHO_VLRFUN := valor
		RHO_COMPPG := mesfol1

		RHO->(MsUnlock())
    Endif

	If Alltrim(acliente[i,5]) > "0"

valor := val(Alltrim(acliente[i,5]))
	
		Reclock("RHO",.T.)


		RHO_FILIAL := FILIAL
		RHO_MAT    := MAT
		RHO_DTOCOR := date()
		RHO_ORIGEM := "1"
		RHO_TPFORN := "1"
		RHO_CODFOR := "001"
		RHO_TPLAN  := "1"
		RHO_PD     := "513"
		RHO_VLRFUN := valor
		RHO_COMPPG := mesfol1

		RHO->(MsUnlock())
    Endif

	If Alltrim(acliente[i,6]) > "0"

valor := val(Alltrim(acliente[i,6]))
	
		Reclock("RHO",.T.)


		RHO_FILIAL := FILIAL
		RHO_MAT    := MAT
		RHO_DTOCOR := date()
		RHO_ORIGEM := "1"
		RHO_TPFORN := "1"
		RHO_CODFOR := "001"
		RHO_TPLAN  := "1"
		RHO_PD     := "514"
		RHO_VLRFUN := valor
		RHO_COMPPG := mesfol1

		RHO->(MsUnlock())

    Endif

	If Alltrim(acliente[i,7]) > "0"

valor := val(Alltrim(acliente[i,7]))
	
		Reclock("RHO",.T.)


		RHO_FILIAL := FILIAL
		RHO_MAT    := MAT
		RHO_DTOCOR := date()
		RHO_ORIGEM := "1"
		RHO_TPFORN := "1"
		RHO_CODFOR := "001"
		RHO_TPLAN  := "1"
		RHO_PD     := "515"
		RHO_VLRFUN := valor
		RHO_COMPPG := mesfol1

		RHO->(MsUnlock())

    Endif

Next i 	

Return()
