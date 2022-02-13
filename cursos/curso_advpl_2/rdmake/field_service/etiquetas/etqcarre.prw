#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºExecblock ³ ETQCARRE º Autor ³ Claudia Cabral     º Data ³  29/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para impressao de Etiquetas - RETAIL - ZEBRA      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EtqCarRE()
Private   ocImei               
Private   ocserial
Private   ccImei   := space(TamSX3("ZZ4_IMEI")[1])//Space(20)  
Private   ccSerial := Space(15)
Private   _oDlgETI      
Private   _cModelo := space(20)
Private   _cbaiest := space(45)
Private   _ccliloj := space(15)
Private   _cNfants := space(30)              
Private   _dEntmas 
Private   _nqtdeti := 0                        
PRIVATE CPERG      := "TIPIMP" 
Private _operdescri    
Private _cLote := ""
Private _operdes
Private lGrava	:= .F.

u_GerA0003(ProcName())

       
CRIASX1()
PERGUNTE(CPERG,.T.)                 


       
DEFINE MSDIALOG _oDlgETI TITLE "ETIQ. RETAIL/GTIA. MOTOROLA" FROM C(276),C(346) TO C(467),C(623) PIXEL
@ C(000),C(001) TO C(097),C(140) LABEL "Dados" PIXEL OF _oDlgETI
@ C(020),C(020) Say "IMEI:" Size C(014),C(008) COLOR CLR_BLACK  PIXEL OF _oDlgETI
@ C(020),C(040) MsGet ocImei Var ccImei Size C(060),C(009) COLOR CLR_BLACK  VALID CHKIMEI()  PIXEL OF _oDlgETI
@ C(044),C(020) Say "SERIAL:" Size C(014),C(008) COLOR CLR_BLACK  PIXEL OF _oDlgETI
@ C(040),C(040) MsGet ocserial Var ccSerial Size C(060),C(009) COLOR CLR_BLACK  VALID CHKSER()  PIXEL OF _oDlgETI

DEFINE SBUTTON FROM C(068),C(045) TYPE 1 ENABLE OF _oDlgETI ACTION ()
DEFINE SBUTTON FROM C(068),C(065) TYPE 2 ENABLE OF _oDlgETI ACTION (_oDlgEti:end())

ACTIVATE MSDIALOG _oDlgETI CENTERED 
Return 



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ckhimei   ³ Autores ³ Claudia Cabral/Edson Rodrigues-16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel validar o codigo do cliente e IMEI        ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ChkImei()      
Local _Lachou := .F.
Local lRet		:= .T.
If Empty(ccImei)
	apMsgStop("Caro usuário, o IMEI nao foi informado.","IMEI não informado")
	return .F.
EndIf                              


/*  
Alterado por Uiran Almeida receber o imei mais recente
A validação anterior estava buscanco O.S. Alfanumerica da matriz  
*/

//ZZ4->(dbSetorder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
ZZ4->(dbSetorder(4)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS

if ZZ4->(dbSeek(xFilial("ZZ4") + ccIMEI))
	/*while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCImei)
		ZZ4->(dbSkip())
	enddo
	ZZ4->(dbSkip(-1)) */
	_lAchou := alltrim(ZZ4->ZZ4_IMEI) == alltrim(ccImei)
elseif !empty(ccIMEI)
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")
endif                                                   
if _lAchou 
	If  !ZZ4->ZZ4_STATUS $ '5'     
		apMsgStop("Caro usuário, o IMEI informado não encontra-se na fase de encerramento. ","IMEI com fase incorreta")
		Return .F.
	endif
	
	If Empty(ZZ4->ZZ4_IETRET)
		lGrava := .T.
	Else
		lRet := u_GerA0001( "Nextellider","Etiqueta já gerada, contate seu supervisor para liberação desta impressão ! -> "+ZZ4->ZZ4_IETRET , .F.)
		If !lRet
			Return .F.
		Else 
			lGrava := .T.
		EndIf
	EndIf
	
	If ZZ4->ZZ4_CODCLI=="Z00403" .AND. !EMPTY(ZZ4->ZZ4_CHVFIL)
		SA1->(dbSeek(xFilial("SA1") + SUBSTR(ZZ4->ZZ4_CHVFIL,7,8)))
	Else
		SA1->(dbSeek(xFilial("SA1") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA ))
	Endif
	_cModelo   := ALLTRIM(ZZ4->ZZ4_CODPRO)
	//_cCliloj   := alltrim(ZZ4->ZZ4_CODCLI) + ' - ' + alltrim(ZZ4->ZZ4_LOJA) + ' - ' + alltrim(SA1->A1_NREDUZ )
	//_cCliloj   := alltrim(ZZ4->ZZ4_CODCLI) + ' - ' + alltrim(ZZ4->ZZ4_LOJA)  
	_cCliloj   := alltrim(SA1->A1_COD) + ' - ' + alltrim(SA1->A1_LOJA)  
	_cNfants   := alltrim(SA1->A1_NREDUZ)
	_dEntmas   := ZZ4->ZZ4_EMDT
	_cbaiest  := alltrim(LEFT(SA1->A1_BAIRRO,40))  + ' - ' + SA1->A1_EST
Else
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")		
	return .F.
EndIf
Return .t.




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ckhser   ³ Autor ³      Edson Rodrigues              16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel validar o Serial                          ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ChkSer()      

Local _Lachou   :=.F.

If Empty(ccImei)
	apMsgStop("Caro usuário, o IMEI nao foi informado.","IMEI não informado")
	return .F.
EndIf                              


If Empty(ccSerial)
	apMsgStop("Caro usuário, o Serial nao foi informado.","IMEI não informado")
	return .F.
EndIf                              

/*  
Alterado por Uiran Almeida receber o imei mais recente
A validação anterior estava buscanco O.S. Alfanumerica da matriz  
*/

//ZZ4->(dbSetorder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
ZZ4->(dbSetorder(4)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS   

if ZZ4->(dbSeek(xFilial("ZZ4") + ccIMEI))
	/*while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(cCImei)
		ZZ4->(dbSkip())
	enddo
	ZZ4->(dbSkip(-1))*/
	_lAchou := alltrim(ZZ4->ZZ4_IMEI) == alltrim(ccImei)
elseif !empty(ccIMEI)
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")
endif       

if _lAchou 
	_cLote :=""
	If Alltrim(ZZ4->ZZ4_OPEBGH)=="N04"
		_cLote := POSICIONE("SD1",1,xFilial("SD1")+ ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_CODPRO + ZZ4->ZZ4_ITEMD1 , "D1_XLOTE") //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If !empty(_cLote)
			_cLote := "(" + Alltrim(_cLote) + ")"
		Endif
	Endif
	_operbgh   	:= 	ZZ4->ZZ4_OPEBGH
    _cvalseri  	:= 	Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_VALSER")
    _nqtdeti   	:= 	Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_QTDRET")
    _cvalcardu 	:=	Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_ETQCDU")
    _operdes	:=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_DESCRI")
	If Left(_operdes,6) $ "NEXTEL"
		_operdescri	:=Substr(_operdes,9,20)
	Else
		_operdescri	:= _operdes
	EndIf
    
    If _cvalseri <> "S"
		apMsgStop("Caro usuário, A operacao desse IMEI informado não valida o serial. ","Operacao Invalida para validar Serial")
		Return .F.
    Else                              
       _clab :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_LAB")           
    Endif                                                            
    
	If !ALLTRIM(ZZ4->ZZ4_CARCAC)==ALLTRIM(ccSerial)
        apMsgStop("Caro usuário, O serial :"+alltrim(ccSerial)+" é diferente do serial da entrada. O serial da entrada é : "+ALLTRIM(ZZ4->ZZ4_CARCAC),"Serial Invalido")
		Return .F.
    EndIf
    
    If _nqtdeti <= 0
        apMsgStop("Caro usuário, Essa Operacao :"+ALLTRIM(_operbgh)+" nao esta parametrizada para imprimir essa Etiqueta. Entre em contato com Administrado do Sistema " ,"Operacao Invalida para Impr. Etiqueta")
		Return .F.
    EndIf
    
    If AllTrim(_cvalcardu) == "S"
    	apMsgStop("Caro usuário, Essa Operacao :"+ALLTRIM(_operbgh)+" nao esta parametrizada para imprimir essa Etiqueta. Entre em contato com Administrado do Sistema " ,"Operacao Invalida para Impr. Etiqueta")
		Return .F.
    EndIf
       
Else     
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")		
	return .F.
EndIf


If _lAchou 
	ImpEti()                        
EndIf	

Return .t.




                                                                
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ImpEti    ³ Autores ³ Claudia Cabral/Edson Rodrigues-16/09/10  ±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel pela impressão da etiqueta Retail         ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpEti()
Local nX
//Local _aLin := {03,06,09,12,15}
//Local _aLin := {03,07,10,14,17}
//Local _aCol := {05,27,30,54}  //05,30
Local _aLin := {}
Local _aCol := {}  //05,30
Local cfont := "0"                                               
Local datab	:= dDataBase
Local hora	:= Time()
Local _afont :={"020,030","030,040","055,075","065,085","090,090","100,100","110,110"}      

If MV_PAR01 == 1
  _aLin := {03,07,11,15,19}
  _aCol := {05,17,20,60}  //05,30
ElseIf  MV_PAR01 == 2
  _aLin := {06,16,22,32,39}
  _aCol := {10,20,23,100}  //05,30
Else	
	_aLin 	:= {02,09,14,21,27,31,35}
	_aCol 	:= {05,17,20,70,90}
Endif   



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura da Matriz                                                         ³
//³ 01 - IMEI                                                                   ³
//³ 02 - Numero da OS                                                           ³
//³ 03 - Item da OS                                                             ³
//³ 04 - Numero da NF de Entrada                                                ³
//³ 05 - Serie da NF de Entrada                                                 ³
//³ 06 - Modelo do aparelho                                                     ³
//³ 07 - Data de Entrada                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Layout da Etiqueta                              ³
//³ Ú--------------- 88 mm -----------------------¿ ³
//³ |  CARD-U: 000000000000000  XXXXXXXXXXXXXX    | ³
//³ |  IMEI: 000000000000000           UF      22 | ³
//³ |  CLIENTE                                 mm ³ ³
//³ À---------------------------------------------Ù ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    

For nx =1 to _nqtdeti

	If MV_PAR01 == 1
     	MSCBPRINTER("S300","LPT1",,022,.F.,,,,,,.T.)
	    MSCBBEGIN(1,6)
        //                                  direcao fonte   tamanho    
	
	    MSCBSAYBAR(_aCol[1],_aLin[1],alltrim(ccImei),"N","MB07",3,.F.,.F.,.F.,,2,1)
        //Alterado Layout da Etiqueta conforme solictacao do Francis - Edson Rodrigues 08/05/10
	    //MSCBSAY(   _aCol[4],_aLin[1],"Modelo: " + _cModelo,"N","0","020,030") 
	    MSCBSAY(_aCol[4],_aLin[1],_cCliloj ,"N",cfont,_afont[1])  

	    MSCBSAY(_aCol[1],_aLin[2],"IMEI: " 		+ alltrim(ccImei) ,"N",cfont,_afont[1])     

		MSCBSAY(_aCol[4],_aLin[2],"Entrada : " + TransForm(_dEntmas, "@E 99/99/99") ,"N",cfont,_afont[1])  
		 //MSCBSAY(_aCol[4],_aLin[3],_cbaiest ,"N","0","020,030")	

	    MSCBSAYBAR(_aCol[1],_aLin[3],_cModelo,"N","MB07",3,.F.,.F.,.F.,,2,1)  
        MSCBSAY(   _aCol[1],_aLin[4],"Modelo: " + _cModelo +' - '+ AllTrim(_operbgh)+ '-'+ Alltrim(_operdescri)+_cLote,"N",cfont,_afont[1]) 
	    MSCBSAY(_aCol[4],_aLin[3],alltrim(__cUserID)+ ' '+ Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[1])  // Coluna 2 - Linha 2	

	    MSCBSAY(_aCol[1],_aLin[5],_cNfants+' - '+_cbaiest ,"N",cfont,_afont[1])
        //MSCBSAY(_aCol[1],_aLin[4],_cCliloj ,"N","0","020,030")  // Coluna 2 - Linha1                                                                             
	
	    //MSCBSAY(_aCol[1],_aLin[5],_cbaiest ,"N","0","020,030")  // Coluna 2 - Linha1
	
	    MSCBEnd()

	    MSCBCLOSEPRINTER()
	    
	ElseIf MV_PAR01 == 2
	
   	    MSCBPRINTER("Z90XI","LPT1",,22,.F.,,,,,,.T.) 
	    MSCBBEGIN(1,6)
        //                                  direcao fonte   tamanho    
	
	    MSCBSAYBAR(_aCol[1],_aLin[1],alltrim(ccImei),"N","MB07",8,.F.,.F.,.F.,,4,2)
        //Alterado Layout da Etiqueta conforme solictacao do Francis - Edson Rodrigues 08/05/10
	    //MSCBSAY(   _aCol[4],_aLin[1],"Modelo: " + _cModelo,"N","0","020,030") 
	    MSCBSAY(_aCol[4],_aLin[1],_cCliloj ,"N",cfont,_afont[3])  
	
	    MSCBSAY(_aCol[1],_aLin[2],"IMEI: " 		+ alltrim(ccImei) ,"N",cfont,_afont[3]) 

   		MSCBSAY(_aCol[4],_aLin[2],"Entrada : " + TransForm(_dEntmas, "@E 99/99/99") ,"N",cfont,_afont[3])      

	    //MSCBSAY(_aCol[4],_aLin[3],_cbaiest ,"N","0","020,030")	

	    MSCBSAYBAR(_aCol[1],_aLin[3],_cModelo,"N","MB07",8,.F.,.F.,.F.,,4,2)  
        MSCBSAY(   _aCol[1],_aLin[4],"Modelo: " + _cModelo +' - '+ AllTrim(_operbgh)+ '-'+ Alltrim(_operdescri)+_cLote,"N",cfont,_afont[3]) 
	    MSCBSAY(_aCol[4],_aLin[3],alltrim(__cUserID)+ ' '+ Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[3])  // Coluna 2 - Linha 2	

	    MSCBSAY(_aCol[1],_aLin[5],_cNfants+' - '+_cbaiest ,"N",cfont,_afont[3])
        //MSCBSAY(_aCol[1],_aLin[4],_cCliloj ,"N","0","020,030")  // Coluna 2 - Linha1                                                                             
	
	    //MSCBSAY(_aCol[1],_aLin[5],_cbaiest ,"N","0","020,030")  // Coluna 2 - Linha1
	
	    MSCBEnd()

	    MSCBCLOSEPRINTER()
	Else
		MSCBPRINTER("S300","LPT1",,022,.F.,,,,,,.T.)
	    MSCBBEGIN(1,6)
        //                                  direcao fonte   tamanho    
	
	    MSCBSAYBAR(_aCol[1],_aLin[1],alltrim(ccImei),"N","MB07",4.5,.F.,.F.,.F.,,2,1)
        //Alterado Layout da Etiqueta conforme solictacao do Francis - Edson Rodrigues 08/05/10
	    //MSCBSAY(   _aCol[4],_aLin[1],"Modelo: " + _cModelo,"N","0","020,030") 
	    MSCBSAY(_aCol[4],_aLin[1],_cCliloj ,"N",cfont,_afont[2])  

	    MSCBSAY(_aCol[1],_aLin[2],"IMEI: " 		+ alltrim(ccImei) ,"N",cfont,_afont[2])     

		MSCBSAY(_aCol[4],_aLin[2],"Entrada : " + TransForm(_dEntmas, "@E 99/99/99") ,"N",cfont,_afont[2])  
		 //MSCBSAY(_aCol[4],_aLin[3],_cbaiest ,"N","0","020,030")	

	    MSCBSAYBAR(_aCol[1],_aLin[3],_cModelo,"N","MB07",4.5,.F.,.F.,.F.,,2,1)  
        MSCBSAY(   _aCol[1],_aLin[4],"Modelo: " + _cModelo +' - '+ AllTrim(_operbgh)+ '-'+ Alltrim(_operdescri)+_cLote,"N",cfont,_afont[2]) 
	    MSCBSAY(_aCol[4],_aLin[3],alltrim(__cUserID)+ ' '+ Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[1])  // Coluna 2 - Linha 2	

	    MSCBSAY(_aCol[1],_aLin[5],_cNfants+' - '+_cbaiest ,"N",cfont,_afont[2])
        //MSCBSAY(_aCol[1],_aLin[4],_cCliloj ,"N","0","020,030")  // Coluna 2 - Linha1                                                                             
	
	    //MSCBSAY(_aCol[1],_aLin[5],_cbaiest ,"N","0","020,030")  // Coluna 2 - Linha1
	
	    MSCBEnd()

	    MSCBCLOSEPRINTER()
	
	EndIf   
	    
NEXT

If lGrava
	RecLock("ZZ4",.F.)
		ZZ4->ZZ4_IETRET := AllTrim(cUserName) +"("+ dToc(date())+" - "+Time()+")"	
	MsUnlock()
EndIf
	
ccImei   := space(TamSX3("ZZ4_IMEI")[1])//space(20)
ccserial := space(11)
ocImei:Setfocus()
Return  .t.                      

Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Impressora","Impressora","Impressora","mv_ch1","N",01,0,0,"C","",""	,"",,"mv_par01","ZEBRA 200 DPI"	,"","","","ZEBRA 600 DPI"		,"","",""	,"","","","","","","","")

Return Nil

