#include 'Protheus.ch'
#Include 'TOTVS.ch'

#define ENTER chr(13)+chr(10)

/****************************************************************************
** Programa: ACESSOUSERК * Autor:Kanaуm L. R. R.     * Data: 11/06/12     ***
*****************************************************************************
** Desc.: Verifica o acesso dos usuсrios do sistema.                      ***
*****************************************************************************
** DATA      * ANALISTA *  MOTIVO                                         ***
*****************************************************************************
** 11/06/12  * Kanaуm   * Desenvolvimento da Rotina                       ***
*****************************************************************************
** 26/02/13  * Kanaуm   * adiчуo de tela de filtro                        ***
****************************************************************************/
*------------------------*
User Function AcessoUser()
*------------------------*
Local   oDlg,;
        oReport,;
        bOk        := {|| oDlg:End()},;
        bCancel    := {|| oDlg:End()},;
        aTb_Campos := {},;
        aButtons   := {{"",;
                        {|| Processa({|| oReport := ReportDef(),oReport:PrintDialog()},'Imprimindo Dados...')},;
                         "Imprimir",;
                         "Imprimir"}}
Private aUsers     := {},;
        aModulos   := {},;
        oMarkUser,;
        oMarkModulo,;
        oMarkAcesso,;
        cMarca     := GetMark(),;
        lInverte   := .F.,;
        aSize      := MsAdvSize() // pega o tamanho da tela

Private lMarca    := .T.,;
        lRetrato  := .T.,;
        cModDe    := Space(2),;
        cModAte   := "99",;
        cUserDe   := Space(6),;
        cUserAte  := "999999",;
        cRotDe    := Space(12),;
        cRotAte   := "ZZZZZZZZZZZZ",;
        aColPrint := {.T.,.T.,.T.,.T.,.T.,.T.,.T.,.T.}//variсveis de filtro

If !Filtro()
   Return
Else
   cModDe    := StrZero(Val(cModDe),2)
   cModAte   := StrZero(Val(cModAte),2)
   cUserDe   := StrZero(Val(cUserDe),6)
   cUserAte  := StrZero(Val(cUserAte),6)
EndIf

Processa({|| aUsers := AllUsers(),;
             aModulos := retModName(),;
             aAdd(aModulos,{99,"SIGACFG","Configurador",.T.,"CFGIMG",99}),;
             aGroup := AllGroups(),;
             CriaWork(),;
             PreencheWk()},;
             'Preparando Ambiente...')

WKUSERS->(dbGoTop())
WKMODULOS->(dbGoTop())
WKACESSO->(dbGoTop())

oMainWnd:ReadClientCoords()
Define MsDialog oDlg Title "Acesso de Usuсrios" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

   aPos := {oMainWnd:nTop+12,oMainWnd:nLeft,oMainWnd:nBottom*0.48,(oMainWnd:nRight-10)*0.1}
   aTb_Campos      := CriaTbCpos("USERS")
   oMarkUser       := MsSelect():New("WKUSERS","WKMARCA",,aTb_Campos,.F.,@cMarca,aPos)
   oMarkUser:bAval := {|| MarcaCpo(.F.,"WKUSERS")}
   oMarkUser:oBrowse:lCanAllMark := .T.
   oMarkUser:oBrowse:lHasMark    := .T.
   oMarkUser:oBrowse:bAllMark := {|| MarcaCpo(.T.,"WKUSERS")}
   oMarkUser:oBrowse:bChange := {||oMarkModulo:oBrowse:SetFilter("CODUSER",WKUSERS->CODUSER,WKUSERS->CODUSER),;
                                   oMarkModulo:oBrowse:Refresh(),;
                                   oMarkAcesso:oBrowse:SetFilter("CODUSMOD",WKMODULOS->(CODUSER+CODMODULO),WKMODULOS->(CODUSER+CODMODULO)),;
                                   oMarkAcesso:oBrowse:Refresh()}
   //
   aPos := {oMainWnd:nTop+12,(oMainWnd:nRight-10)*0.1,oMainWnd:nBottom*0.48,(oMainWnd:nRight-10)*0.2}
   aTb_Campos        := CriaTbCpos("MODULOS")
   oMarkModulo       := MsSelect():New("WKMODULOS","WKMARCA",,aTb_Campos,.F.,@cMarca,aPos)
   oMarkModulo:bAval := {|| MarcaCpo(.F.,"WKMODULOS")}
   oMarkModulo:oBrowse:lCanAllMark := .T.
   oMarkModulo:oBrowse:lHasMark    := .T.
   oMarkModulo:oBrowse:bAllMark := {|| MarcaCpo(.T.,"WKMODULOS")}
   oMarkModulo:oBrowse:SetFilter("CODUSER",WKUSERS->CODUSER,WKUSERS->CODUSER)
   oMarkModulo:oBrowse:bChange := {||oMarkAcesso:oBrowse:SetFilter("CODUSMOD",WKMODULOS->(CODUSER+CODMODULO),WKMODULOS->(CODUSER+CODMODULO)),;
                                     oMarkAcesso:oBrowse:Refresh()}
   //   
   aPos := {oMainWnd:nTop+12,(oMainWnd:nRight-10)*0.2,oMainWnd:nBottom*0.48,oMainWnd:nRight*0.5}
   aTb_Campos        := CriaTbCpos("ACESSO")
   oMarkAcesso       := MsSelect():New("WKACESSO","WKMARCA",,aTb_Campos,.F.,@cMarca,aPos)
   oMarkAcesso:bAval := {|| MarcaCpo(.F.,"WKACESSO")}
   oMarkAcesso:oBrowse:lCanAllMark := .T.   
   oMarkAcesso:oBrowse:lHasMark    := .T.
   oMarkAcesso:oBrowse:bAllMark := {|| MarcaCpo(.T.,"WKACESSO")}
   oMarkAcesso:oBrowse:SetFilter("CODUSMOD",WKMODULOS->(CODUSER+CODMODULO),WKMODULOS->(CODUSER+CODMODULO))

Activate MsDialog oDlg On Init ( EnchoiceBar(oDlg,bOk,bCancel,,aButtons), ,, )//
//
WKUSERS->(dbCloseArea())
WKMODULOS->(dbCloseArea())
WKACESSO->(dbCloseArea())
//
Return

/*
Funcao      : Filtro
Objetivos   : Filtra os dados que serуo buscados
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 26/02/2013
*/
*----------------------*
Static Function Filtro()
*----------------------*
Local lOk     := .F.
Local bOk     := {|| lOk := .T., oDlg:End()}
Local bCancel := {|| lOk := .F., oDlg:End()}
Local nLin    := 15
Local nCol    := 15
Local lChk1   := lChk2 := lChk3 := lChk4 := lChk5 := lChk6 := lChk7 := lChk8 := lChk9 := lChk10 := .T.
Local oDlg, oChkBox1, oChkBox2, oChkBox3, oChkBox4, oChkBox5, oChkBox6, oChkBox7, oChkBox8, oPanel,;
      oModDe, oModAte, oUserDe, oUserAte, oRotDe, oRotAte

oMainWnd:ReadClientCoords()
Define MsDialog oDlg Title "Acesso de Usuсrios" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
    *
    oPanel = TPanel():New(nLin,nCol-5,"Colunas a serem impressas",oDlg,,.F.,,,,175,45,.F.,.T.)
    nLin += 15
    @ nLin,nCol     CheckBox oChkBox1 Var lChk1 Prompt "Usuсrio"    On Click ( aColPrint[1] := !aColPrint[1] ) Size 130,9 Of oDlg Pixel 
    @ nLin,nCol+40  CheckBox oChkBox2 Var lChk2 Prompt "Mѓdulo"     On Click ( aColPrint[2] := !aColPrint[2] ) Size 130,9 Of oDlg Pixel 
    @ nLin,nCol+80  CheckBox oChkBox3 Var lChk3 Prompt "Menu"       On Click ( aColPrint[3] := !aColPrint[3] ) Size 130,9 Of oDlg Pixel     
    @ nLin,nCol+120 CheckBox oChkBox4 Var lChk4 Prompt "Sub-Menu"   On Click ( aColPrint[4] := !aColPrint[4] ) Size 130,9 Of oDlg Pixel 
    nLin += 15
    @ nLin,nCol     CheckBox oChkBox5 Var lChk5 Prompt "Rotina"     On Click ( aColPrint[5] := !aColPrint[5] ) Size 130,9 Of oDlg Pixel 
    @ nLin,nCol+40  CheckBox oChkBox6 Var lChk6 Prompt "Acesso"     On Click ( aColPrint[6] := !aColPrint[6] ) Size 130,9 Of oDlg Pixel 
    @ nLin,nCol+80  CheckBox oChkBox7 Var lChk7 Prompt "Funчуo"     On Click ( aColPrint[7] := !aColPrint[7] ) Size 130,9 Of oDlg Pixel 
    @ nLin,nCol+120 CheckBox oChkBox8 Var lChk8 Prompt "Menu(.xnu)" On Click ( aColPrint[8] := !aColPrint[8] ) Size 130,9 Of oDlg Pixel     
    *
    nLin += 30
    *
    @ nLin,nCol     CheckBox oChkBox9 Var lChk9 Prompt "Marcado/Desmarcado?" On Click ( lMarca := !lMarca ) Size 130,9 Of oDlg Pixel 
    nLin += 15
    @ nLin,nCol     CheckBox oChkBox10 Var lChk10 Prompt "Retrato/Paisagem" On Click ( lRetrato := !lRetrato ) Size 130,9 Of oDlg Pixel     
	*
	nLin += 30
    @ nLin,nCol    Say  'Mѓdulo De: '                                                         Of oDlg Pixel                                  	
    @ nLin,nCol+45 MsGet oModDe  Var cModDe  VALID (Vazio() .OR. cModDe >="01")   Size 60,09  Of oDlg Pixel  
  	nLin += 15
    @ nLin,nCol    Say  'Mѓdulo Atщ: '                                                         Of oDlg Pixel                                  	
    @ nLin,nCol+45 MsGet oModAte Var cModAte VALID (!Vazio() .AND. cModAte <="99") Size 60,09  Of oDlg Pixel  
    nLin += 30
    @ nLin,nCol    Say  'Usuсrio De: '                                                               Of oDlg Pixel                                  	
    @ nLin,nCol+45 MsGet oUserDe  Var cUserDe  VALID (Vazio() .OR. cUserDe >="000001")   Size 60,09  Of oDlg Pixel  
  	nLin += 15
    @ nLin,nCol    Say  'Usuсrio Atщ: '                                                               Of oDlg Pixel                                  	
    @ nLin,nCol+45 MsGet oUserAte Var cUserAte VALID (!Vazio() .AND. cUserAte <="999999") Size 60,09  Of oDlg Pixel  
    nLin += 30
    @ nLin,nCol    Say  'Rotina De: '                                                                    Of oDlg Pixel                                  	
    @ nLin,nCol+45 MsGet oRotDe  Var cRotDe Picture "@!"                                     Size 60,09  Of oDlg Pixel  
  	nLin += 15
    @ nLin,nCol    Say  'Rotina Atщ: '                                                                                Of oDlg Pixel
    @ nLin,nCol+45 MsGet oRotAte Var cRotAte Picture "@!" VALID (!Vazio() .AND. cRotAte <="ZZZZZZZZZZZZ") Size 60,09  Of oDlg Pixel  
    *
Activate MsDialog oDlg On Init ( EnchoiceBar(oDlg,bOk,bCancel,,), ,, )

Return lOk

/*
Funcao      : CriaWork
Objetivos   : Cria Works para criaчуo dos msselects
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 11/06/2012
*/
*--------------------------*
Static Function CriaWork()
*--------------------------*
Local aSemSx3 := {}
Local cFile   := ""
//
//Cria work da coluna Usuсrios
aAdd(aSemSx3,{"WKMARCA","C",02,0})
aAdd(aSemSx3,{"CODUSER","C",06,0})
aAdd(aSemSx3,{"USER"   ,"C",30,0})
//
cFile := E_CriaTrab(,aSemSX3,"WKUSERS")
IndRegua("WKUSERS",cFile+OrdBagExt(),"CODUSER")
Set Index To (cFile+OrdBagExt())

//Cria work da coluna Mѓdulos
aSemSx3 := {}
cFile   := ""
aAdd(aSemSx3,{"WKMARCA"  ,"C",02,0})
aAdd(aSemSx3,{"CODUSER"  ,"C",06,0})
aAdd(aSemSx3,{"CODMODULO","C",02,0})
aAdd(aSemSx3,{"MODULO"   ,"C",30,0})
aAdd(aSemSx3,{"GRUPO"    ,"C",28,0}) // adicionado por Fhilipe Rotta (20140820) -> Nome do grupo de usuarios relacionado ao menu
cFile := E_CriaTrab(,aSemSX3,"WKMODULOS")
IndRegua("WKMODULOS",cFile+OrdBagExt(),"CODUSER+CODMODULO")
Set Index To (cFile+OrdBagExt())

//Cria work da coluna Acessos
aSemSx3 := {}
cFile   := ""
aAdd(aSemSx3,{"WKMARCA"  ,"C",02,0})
aAdd(aSemSx3,{"CODUSMOD" ,"C",08,0})
aAdd(aSemSx3,{"USER"     ,"C",30,0})
aAdd(aSemSx3,{"MODULO"   ,"C",30,0})
aAdd(aSemSx3,{"GRUPO"    ,"C",28,0}) // adicionado por Fhilipe Rotta (20140820) -> Nome do grupo de usuarios relacionado ao menu
aAdd(aSemSx3,{"MENU"     ,"C",12,0})
aAdd(aSemSx3,{"SUBMENU"  ,"C",25,0})
aAdd(aSemSx3,{"ROTINA"   ,"C",25,0})
aAdd(aSemSx3,{"FUNCAO"   ,"C",25,0})
aAdd(aSemSx3,{"XNU"      ,"C",40,0})
aAdd(aSemSx3,{"ACESSO"   ,"C",10,0})
cFile := E_CriaTrab(,aSemSX3,"WKACESSO")
IndRegua("WKACESSO",cFile+OrdBagExt(),"CODUSMOD")
Set Index To (cFile+OrdBagExt())
//
Return

/*
Funcao      : CriaTbCpos
Objetivos   : Cria tbCampos para os msSelects
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 11/06/2012
*/
*--------------------------*
Static Function CriaTbCpos(cTipo)
*--------------------------*
Local aTbCpos := {}
//
aAdd(aTbCpos,{"WKMARCA",,""       ,""} )
//
If cTipo == "USERS"
   //
   aAdd(aTbCpos,{"USER"   ,,"Usuсrio",""} )
   //
ElseIf cTipo == "MODULOS"                  
   //
   aAdd(aTbCpos,{"MODULO" ,,"Mѓdulo",""} )
   aAdd(aTbCpos,{"GRUPO"  ,,"Grupo", ""} ) // adicionado por Fhilipe Rotta (20140820) -> Nome do grupo de usuarios relacionado ao menu
   //
ElseIf cTipo == "ACESSO"
   //
   aAdd(aTbCpos,{"MENU"   ,,"Menu"    ,""} )
   aAdd(aTbCpos,{"SUBMENU",,"Sub-Menu",""} )
   aAdd(aTbCpos,{"ROTINA" ,,"Rotina"  ,""} )
   aAdd(aTbCpos,{"ACESSO" ,,"Acesso"  ,""} )   
   //
EndIf
//
Return aTbCpos

/*
Funcao      : PreencheWk
Objetivos   : Preenche works com dados de usuсrios, mѓdulos e menus.
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 11/06/2012
*/
*--------------------------*
Static Function PreencheWk()
*--------------------------*
Local   nTamMod  := 0//ref 26/02/13 - adicionadas as 2 variсveis de controle para melhoria de performance.
Local   nTamUser := Len(aUsers)
Local   aMnuRet  := {} // adicionado por Fhilipe Rotta (20140820) -> array que recebe informacoes de grupo de usuarios, nos casos em que o grupo e priorizado

Private i        := 2 //comeчa em 2 para pular o adm que tem acesso full
Private j        := 1       
Private lAppUser := .F.
Private lAppMod  := .F.

ProcRegua(nTamUser-1)
//Loop nos usuсrios
For i := 2 To nTamUser
   IncProc("Carregando Usuсrio "+AllTrim(Str(i-1))+" de "+AllTrim(Str(nTamUser-1)))
   //se user estiver inativo ou fora do range de filtro passa direto
   If !aUsers[i][1][17] .AND. cUserDe <= aUsers[i][1][1] .AND. cUserAte >= aUsers[i][1][1]
      lAppUser := .F.
      nTamMod := Len(aUsers[i][3])

      //**********************************************************************************
      //* adicionado por Fhilipe Rotta (20140820)                                        *
      //* Identifica se no cadastro de usuario foi marcada a opcao Priorizar Grupos.     *
      //**********************************************************************************
      If aUsers[i][2][11] // prioriza grupos
         //**********************************************************************************************
         //* adicionado por Fhilipe Rotta (20140820)                                                    *
         //* Busca menus dos grupos de usuario, identificando a relacao Grupo X Modulo X Menu.          *
         //**********************************************************************************************
         aMnuRet := frMnuRet(aUsers[i][1][10])
         If Len(aMnuRet)#0
            For j:=1 To Len(aMnuRet)
               lAppMod := .F.
               //preenche work de acesso passando o nome do xnu, codigo do modulo e codigo do grupo de usuarios
               preencMenu(aMnuRet[j][3],aMnuRet[j][2],aMnuRet[j][1])
               If lAppMod
                  //preenche work de mѓdulos
                  WKMODULOS->(dbAppend())
                  WKMODULOS->WKMARCA   := If(lMarca,cMarca,"")
                  WKMODULOS->CODUSER   := aUsers[i][1][1] //Cѓdigo do user
                  WKMODULOS->CODMODULO := aMnuRet[j][2] //Cѓdigo do mѓdulo
                  WKMODULOS->MODULO    := retModulo(Val(WKMODULOS->CODMODULO)) //funчуo que retorna a descriчуo do mѓdulo de acordo com o cѓdigo passado.
                  WKMODULOS->GRUPO     := retGrupo(aMnuRet[j][1]) //retorna o nome do grupo de acordo com o codigo passado
                  lAppUser := .T.
               EndIf
            Next j
         EndIf
      Else
         //Loop nѓs mѓdulos
         For j:=1 To nTamMod
            //Verifica se o usuсrio tem acesso a esse mѓdulo e o mѓdulo estс no ragen do filtro
            If SubStr(aUsers[i][3][j],3,1) != "X" .AND. cModDe <= SubStr(aUsers[i][3][j],1,2) .AND. cModAte >= SubStr(aUsers[i][3][j],1,2)
               lAppMod := .F.
               //preenche work de acesso passando o nome do xnu
               preencMenu(SubStr(aUsers[i][3][j],4,Len(aUsers[i][3][j])-3))
               If lAppMod
                  //preenche work de mѓdulos
                  WKMODULOS->(dbAppend())
                  WKMODULOS->WKMARCA   := If(lMarca,cMarca,"")
                  WKMODULOS->CODUSER   := aUsers[i][1][1] //Cѓdigo do user
                  WKMODULOS->CODMODULO := SubStr(aUsers[i][3][j],1,2) //Cѓdigo do mѓdulo
                  WKMODULOS->MODULO    := retModulo(Val(WKMODULOS->CODMODULO)) //funчуo que retorna a descriчуo do mѓdulo de acordo com o cѓdigo passado.
                  WKMODULOS->GRUPO     := "Sem Grupo"
                  lAppUser := .T.
               EndIf
            EndIf
         Next j
      EndIf

      If lAppUser
         //preenche work de usuсrios
         WKUSERS->(dbAppend())
         WKUSERS->WKMARCA := If(lMarca,cMarca,"")
         WKUSERS->USER    := aUsers[i][1][4] //Nome do user
         WKUSERS->CODUSER := aUsers[i][1][1] //Cѓdigo do user
      EndIf
   EndIf
Next i

Return

/*
Funcao      : retModulo
Objetivos   : retorna a descriчуo do mѓdulo de acordo com o cѓdigo passado.
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 11/06/2012
*/
*--------------------------*
Static Function retModulo(nModulo)
*--------------------------*
Local nPos     := 0
//
nPos := aScan(aModulos, {|x| x[1]==nModulo})
//
Return If(nPos>0,aModulos[nPos][3],"Indefinido")


/*
Funcao      : preencMenu
Objetivos   : preenche as informaчѕes de acesso de acordo com o xnu
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 11/06/2012
*/
*--------------------------*
Static Function preencMenu(cFile, cMod, cGrupo)
*--------------------------*
Local nHandle  := -1
Local lMenu    := .F.
Local lSubMenu := .F.
Local lAppMenu := .T.
Local lAppSub  := .T.
Local cMenu    := ""
Local cSubMenu := ""
Local cRotina  := ""
Local cAcesso  := ""
Local cFuncao  := ""
Local cVisual  := "xx"+Space(3)+"xxxxx/xx"+Space(4)+"xxxx/xx"+Space(5)+"xxx/xx"+Space(6)+"xx/xx"+Space(7)+"x/xx"+Space(8)
Default cMod   := "" // adicionado por Fhilipe Rotta (20140820) -> codigo do Modulo relacionado ao XNU
Default cGrupo := "" // adicionado por Fhilipe Rotta (20140820) -> codigo do Grupo de Usuarios relacionado ao XNU

//abre o arquivo xnu
nHandle := Ft_FUse(cFile)
//se for -1 ocorreu erro na abertura
If nHandle != -1
   Ft_FGoTop()
   While !Ft_FEof() 
      //
      cAux := Ft_FReadLn()
      //fechando alguma tag, se for menu ou sub-menu muda a flag
      If "</MENU>" $ Upper(cAux)
         If lSubMenu
            lSubMenu := .F.
            lAppSub  := .T.
         ElseIf lMenu
            lMenu    := .F.
            lAppMenu := .T.
         EndIf
      //encontrou tag menu (serve para menu e sub-menu) e nуo щ fechamento
      ElseIf "MENU " $ Upper(cAux)//o espaчo depois de "MENU " щ para definir a abertura NУO REMOVER
         //verifica flag de abertura e fechamento de menu/sub-menu
         If !lMenu
            lMenu := .T.
         ElseIf !lSubMenu
            lSubMenu := .T.
         EndIf
         If "HIDDEN" $ Upper(cAux) .OR. "DISABLE" $ Upper(cAux)
            If lMenu .AND. !lSubMenu
               lAppMenu := .F.
            ElseIf lSubMenu
               lAppSub  := .F.
            EndIf
         EndIf
         Ft_FSkip()
         cAux := Ft_FReadLn()
         //captura o que estс entre as tags 
         cAux := retTag(cAux)
         If lMenu .AND. !lSubMenu
            cMenu := StrTran(cAux,"&","")
         ElseIf lSubMenu
            cSubMenu := StrTran(cAux,"&","")
         EndIf
      //Faz o tratamento das rotinas de menu e appenda a work
      ElseIf "MENUITEM " $ Upper(cAux)
         If "HIDDEN" $ Upper(cAux) .OR. "DISABLE" $ Upper(cAux) .OR. !lAppSub .OR. !lAppMenu
            cAcesso := "Sem Acesso"
            Ft_FSkip()
            cAux := Ft_FReadLn()
            nIni := At(">", cAux)+1
            nFim := Rat("<",cAux)
            //captura o que estс entre as tags 
            cRotina := RetTag(cAux)
            //captura o nome da funчуo
            While !("FUNCTION" $ Upper(Ft_FReadLn())) .AND. !Ft_FEof()
               Ft_FSkip()
            EndDo
            cAux := Ft_FReadLn()
            cFuncao := RetTag(cAux)
         Else
            Ft_FSkip()
            cAux := Ft_FReadLn()
            //captura o que estс entre as tags 
            cRotina := RetTag(cAux)   
            //captura o nome da funчуo
            While !("FUNCTION" $ Upper(Ft_FReadLn())) .AND. !Ft_FEof()
               Ft_FSkip()
            EndDo
            cAux := Ft_FReadLn()
            cFuncao := RetTag(cAux)
            //captura o acesso da rotina
            While !("ACCESS" $ Upper(Ft_FReadLn())) .AND. !Ft_FEof()
               Ft_FSkip()
            EndDo
            cAux := Ft_FReadLn()
            cAux := RetTag(cAux)
            If cAux == "xxxxxxxxxx"
               cAcesso := "Manutenчуo"
            ElseIf cAux $ cVisual
               cAcesso := "Visualizar"
            Else
               cAcesso := "Sem Acesso"
            EndIf
         EndIf
         If AllTrim(cRotDe) <= AllTrim(cFuncao) .AND. AllTrim(cRotAte) >= AllTrim(cFuncao)
			cMod := Iif(!Empty(cMod), cMod, SubStr(aUsers[i][3][j],1,2) )
            WKACESSO->(dbAppend())
            WKACESSO->WKMARCA   := If(lMarca,cMarca,"")
            WKACESSO->CODUSMOD  := aUsers[i][1][1]+cMod //Cѓdigo do user + Cѓdigo do mѓdulo
            WKACESSO->USER      := aUsers[i][1][4] //Nome do user
            WKACESSO->MODULO    := retModulo(Val(cMod)) //Nome do Mѓdulo
            WKACESSO->GRUPO     := Iif(Empty(cGrupo), "Sem Grupo", retGrupo(cGrupo)) //Nome do Grupo
            WKACESSO->MENU      := cMenu
            WKACESSO->SUBMENU   := cSubMenu
            WKACESSO->ROTINA    := cRotina
            WKACESSO->ACESSO    := cAcesso
            WKACESSO->FUNCAO    := cFuncao
            WKACESSO->XNU       := cFile
            lAppMod := .T.
         EndIf
      EndIf
      Ft_FSkip()      
   EndDo
   Ft_Fuse()
EndIf

Return

/*
Funcao      : RetTag
Objetivos   : Retorna o conteњdo das tags da linha passada EX:<Title lang="pt">TESTE</Title> o retorno serс "TESTE"
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 07/11/2012
*/
*----------------------------*
Static Function RetTag(cLinha)  
*----------------------------*
Local nIni := At(">", cLinha)+1
Local nFim := Rat("<",cLinha)
//
Return (SubStr(cLinha,nIni,(nFim-nIni)))
                            

/*
Funcao      : MarcaCpo
Objetivos   : Marca/Desmarca Campos
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 13/06/2012
*/
*------------------------------*
Static Function MarcaCpo(lTodos, cAlias)
*------------------------------*
Local nRegUser  := WKUSERS->(RecNo())
Local nRegMod   := WKMODULOS->(RecNo())
Local nRegAcess := WKACESSO->(RecNo())
Local cMark     := If(Empty((cAlias)->WKMARCA),cMarca,"")
Local cChave    := ""
//
If lTodos
   If cAlias == "WKUSERS"
      WKUSERS->(dbGoTop())
      While WKUSERS->(!Eof())
         RecLock("WKUSERS",.F.)
         WKUSERS->WKMARCA := cMark
         WKUSERS->(MsUnlock())
         WKUSERS->(dbSkip())
      EndDo
      WKMODULOS->(dbGoTop())
      While WKMODULOS->(!Eof())
         RecLock("WKMODULOS",.F.)
         WKMODULOS->WKMARCA := cMark
         WKMODULOS->(MsUnlock())
         WKMODULOS->(dbSkip())
      EndDo
      WKACESSO->(dbGoTop())
      While WKACESSO->(!Eof())
         RecLock("WKACESSO",.F.)
         WKACESSO->WKMARCA := cMark
         WKACESSO->(MsUnlock())
         WKACESSO->(dbSkip())
      EndDo
   ElseIf cAlias == "WKMODULOS" 
      WKMODULOS->(dbGoTop())
      WKMODULOS->(dbSeek(WKUSERS->CODUSER))
      While WKMODULOS->(!Eof()) .AND. WKMODULOS->CODUSER == WKUSERS->CODUSER
         RecLock("WKMODULOS",.F.)
         WKMODULOS->WKMARCA := cMark
         WKMODULOS->(MsUnlock())
         WKACESSO->(dbSeek(WKMODULOS->(CODUSER+CODMODULO)))
         While WKACESSO->(!Eof()) .AND. WKACESSO->CODUSMOD == WKMODULOS->(CODUSER+CODMODULO)
            RecLock("WKACESSO",.F.)
            WKACESSO->WKMARCA := cMark
            WKACESSO->(MsUnlock())
            WKACESSO->(dbSkip())
         EndDo
         WKMODULOS->(dbSkip())
      EndDo
      RecLock("WKUSERS",.F.)
      WKUSERS->WKMARCA := cMark
      WKUSERS->(MsUnlock())
   ElseIf cAlias == "WKACESSO"
      WKACESSO->(dbGoTop())
      WKACESSO->(dbSeek(WKMODULOS->(CODUSER+CODMODULO)))
      While WKACESSO->(!Eof()) .AND. WKACESSO->CODUSMOD == WKMODULOS->(CODUSER+CODMODULO)
         RecLock("WKACESSO",.F.)
         WKACESSO->WKMARCA := cMark
         WKACESSO->(MsUnlock())
         WKACESSO->(dbSkip())
      EndDo
      If !Empty(cMark)
         RecLock("WKUSERS",.F.)
         WKUSERS->WKMARCA := cMark
         WKUSERS->(MsUnlock())      
      EndIf
         RecLock("WKMODULOS",.F.)
         WKMODULOS->WKMARCA := cMark
         WKMODULOS->(MsUnlock())
   EndIf
Else
   RecLock(cAlias,.F.)
   (cAlias)->WKMARCA := cMark
   (cAlias)->(MsUnlock())
   If Empty(cMark) .AND. cAlias == "WKUSERS"
      WKMODULOS->(dbSeek(WKUSERS->CODUSER))
      While WKMODULOS->CODUSER == WKUSERS->CODUSER .AND. WKMODULOS->(!Eof())
         RecLock("WKMODULOS",.F.)
         WKMODULOS->WKMARCA := cMark
         WKMODULOS->(MsUnlock())
         WKACESSO->(dbSeek(WKMODULOS->(CODUSER+CODMODULO)))
         While WKACESSO->CODUSMOD == WKMODULOS->(CODUSER+CODMODULO) .AND. WKACESSO->(!Eof())
            RecLock("WKACESSO",.F.)
            WKACESSO->WKMARCA := cMark
            WKACESSO->(MsUnlock())
            WKACESSO->(dbSkip())
         EndDo
         WKMODULOS->(dbSkip())
      EndDo
   ElseIf Empty(cMark) .AND. cAlias == "WKMODULOS"
      WKACESSO->(dbSeek(WKMODULOS->(CODUSER+CODMODULO)))
      While WKACESSO->CODUSMOD == WKMODULOS->(CODUSER+CODMODULO) .AND. WKACESSO->(!Eof())
         RecLock("WKACESSO",.F.)
         WKACESSO->WKMARCA := cMark
         WKACESSO->(MsUnlock())
         WKACESSO->(dbSkip())
      EndDo
   ElseIf !Empty(cMark) .AND. cAlias == "WKACESSO"
     RecLock("WKMODULOS",.F.)
     WKMODULOS->WKMARCA := cMark
     WKMODULOS->(MsUnlock())
     RecLock("WKUSERS",.F.)
     WKUSERS->WKMARCA := cMark
     WKUSERS->(MsUnlock())         
   ElseIf !Empty(cMark) .AND. cAlias == "WKMODULOS"     
     RecLock("WKUSERS",.F.)
     WKUSERS->WKMARCA := cMark
     WKUSERS->(MsUnlock())         
   EndIf
EndIf
//
WKUSERS->(dbGoTo(nRegUser))
WKMODULOS->(dbGoTo(nRegMod))
WKACESSO->(dbGoTo(nRegAcess))
oMarkUser:oBrowse:Refresh()
oMarkModulo:oBrowse:Refresh()
oMarkAcesso:oBrowse:Refresh()
//
Return


/*
Funcao      : ReportDef
Objetivos   : Define estrutura de impressуo
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 13/06/2012
*/
*--------------------------*
Static Function ReportDef()
*--------------------------*
//
oReport := TReport():New("RELACESSO","Relatѓrio de Acesso de Usuсrios","",;
                         {|oReport| ReportPrint(oReport)},"Este relatorio irс Imprimir o Relatѓrio de Acesso de Usuсrios")

//Inicia o relatѓrio como retrato
If lRetrato
   oReport:oPage:lLandScape := .F. 
   oReport:oPage:lPortRait := .T. 
Else
   oReport:oPage:lLandScape := .T. 
   oReport:oPage:lPortRait := .F. 
EndIf

//Define o objeto com a seчуo do relatѓrio
oSecao  := TRSection():New(oReport,"LOG","WKACESSO",{})
//
If aColPrint[1]
   TRCell():New(oSecao,"USER"   ,"WKACESSO","Usuсrio"         ,""            ,30,,,"LEFT")
EndIf
//
If aColPrint[2]
   TRCell():New(oSecao,"MODULO" ,"WKACESSO","Mѓdulo"          ,""            ,30,,,"LEFT")
   TRCell():New(oSecao,"GRUPO"  ,"WKACESSO","Grupo"           ,""            ,30,,,"LEFT") // adicionado por Fhilipe Rotta (20140820) -> Nome do grupo de usuarios relacionado ao menu foi adicionado ao Report
EndIf
//
If aColPrint[3]
   TRCell():New(oSecao,"MENU"   ,"WKACESSO","Menu"            ,""            ,12,,,"LEFT")
EndIf
//
If aColPrint[4]
   TRCell():New(oSecao,"SUBMENU","WKACESSO","Sub-Menu"        ,""            ,25,,,"LEFT")
EndIf
//
If aColPrint[5]
   TRCell():New(oSecao,"ROTINA" ,"WKACESSO","Rotina"          ,""            ,25,,,"LEFT")
EndIf
//
If aColPrint[6]
   TRCell():New(oSecao,"ACESSO" ,"WKACESSO","Acesso"          ,""            ,10,,,"LEFT")
EndIf
//
If aColPrint[7]
   TRCell():New(oSecao,"FUNCAO" ,"WKACESSO","Funчуo"          ,""            ,15,,,"LEFT")
EndIf
//
If aColPrint[8]
   TRCell():New(oSecao,"XNU"    ,"WKACESSO","XNU"             ,""            ,40,,,"LEFT")
EndIf
//
Return oReport


/*
Funcao      : ReportPrint
Objetivos   : Imprime os dados filtrados
Autor       : Kanaуm L. R. Rodrigues 
Data/Hora   : 05/06/2012
*/
*----------------------------------*
Static Function ReportPrint(oReport)
*----------------------------------*
//Inicio da impressуo da seчуo.
oReport:Section("LOG"):Init()
oReport:SetMeter(WKACESSO->(RecCount()))

WKACESSO->(dbGoTop())
oReport:SkipLine(2)
Do While WKACESSO->(!EoF()) .And. !oReport:Cancel()
   If !Empty(WKACESSO->WKMARCA)
      oReport:Section("LOG"):PrintLine() //Impressуo da linha
      oReport:IncMeter()                 //Incrementa a barra de progresso
   EndIf
   WKACESSO->( dbSkip() )
EndDo

//Fim da impressуo da seчуo 
oReport:Section("LOG"):Finish()      
WKACESSO->(dbSeek(WKMODULOS->(CODUSER+CODMODULO)))
oMarkAcesso:oBrowse:Refresh()
Return .T.

/*
Funcao      : retGrupo
Objetivos   : retorna o nome do grupo de acordo com o codigo passado
Autor       : Fhilipe Rotta
Data/Hora   : 20/08/2014
*/
*--------------------------*
Static Function retGrupo(cGrupo)
*--------------------------*
Local nPos     := 0
//
nPos := aScan(aGroup, {|x| AllTrim(x[1][1])==AllTrim(cGrupo)})
//
Return Iif(nPos>0,aGroup[nPos][1][2],"Indefinido")

/*
Funcao      : frMnuRet
Objetivos   : Retorna informacoes do(s) grupo(s) de usuario: codigo do grupo de usuario, codigo do modulo, caminho do XNU
Autor       : Fhilipe Rotta
Data/Hora   : 20/08/2014
*/
*------------------------------*
Static Function frMnuRet(aGrupos)
*------------------------------*
Local cCodMod   := ""
Local nTam      := Len(aGrupos)
Local nI        := 0
Local nJ        := 0
Local aVet      := {}
Local aRet      := {}
//
If nTam#0
   If nTam==1
      aVet := FwGrpMenu(aGrupos[1]) // menus relacionados ao grupo de usuario
      For nI:=1 To Len(aVet)
         cCodMod := SubStr(aVet[nI],1,2)
         If SubStr(aVet[nI],3,1) <> "X" .And. cModDe <= cCodMod .And. cModAte >= cCodMod
            aAdd(aRet, {aGrupos[1], cCodMod, SubStr(aVet[nI],4,Len(aVet[nI])-3)} )
         EndIf
      Next nI
   Else
      aVet := Array( Len(aGrupos) )
      For nI:=1 To Len(aGrupos)
         aVet[nI] := FwGrpMenu(aGrupos[nI]) // menus relacionados ao grupo de usuario
      Next nI
      //*********************************************************************************************
      //* Baseado na ordenacao dos grupos de usuario, pega os codigos do modulo e caminho dos XNUs. *
      //*********************************************************************************************
      For nI:=Iif(Val(cModDe)<1,1,Val(cModDe)) To Val(cModAte)
         For nJ:=1 To nTam
            If ( nPos := aScan(aVet[nJ],{ |x| SubStr(x,1,2)==StrZero(nI,2) }) ) # 0
               If SubStr(aVet[nJ][nPos],3,1) <> "X"
                  cCodMod := StrZero(nI,2)
                  aAdd(aRet, {aGrupos[nJ], cCodMod, SubStr(aVet[nJ][nPos],4,Len(aVet[nJ][nPos])-3)} )
                  Exit
               EndIf
            EndIf
         Next nJ
      Next nI
   EndIf
EndIf
//
Return aRet

AcessoUser.prw
Exibindo AcessoUser.prw…