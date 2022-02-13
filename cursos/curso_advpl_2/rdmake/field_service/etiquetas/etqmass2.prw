#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETQENTR  ºAutor  ³ M.Munhoz - ERPPLUS º Data ³ 17/10/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para impressao da etiqueta de ENTRADA             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterado por M.Munhoz em 16/08/2011 para transferir o flag de gravacao ³
//³ da etiqueta do SD1 para o ZZ4.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function etqentr()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracoes das variaveis                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
private oDlg   := Nil
private ocimei    := nil
private cIMEI  := space(TamSX3("ZZ4_IMEI")[1])//Space(15)

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da janela e seus conteudos                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Etiqueta de ENTRADA" FROM 0,0 TO 210,420 OF oDlg PIXEL

@ 010,015 SAY   "Informe o IMEI para imprimir a Etiqueta de ENTRADA." 	SIZE 150,008 PIXEL OF oDlg 
@ 035,015 TO 070,180 LABEL "IMEI" PIXEL OF oDlg 
@ 045,025 MSGET ocimei Var cIMEI PICTURE "@!" 	SIZE 080,010 Valid u_impmass2(cImei) PIXEL OF oDlg 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Botoes da MSDialog                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 080,140 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ETQMASS2  ºAutor  ³Microsiga           º Data ³  10/22/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function impmass2(_cImei)

local _aAreaZZ4 := ZZ4->(getarea())
local _aImpEtiq := {}

ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_STATUS

if !empty(_cImei) .and. ZZ4->(dbSeek(xFilial("ZZ4") + _cImei))
	aAdd(_aImpEtiq, {IIF(ALLTRIM(ZZ4->ZZ4_OPEBGH)=="P01",ZZ4->ZZ4_CARCAC,ZZ4->ZZ4_IMEI), ZZ4->ZZ4_OS, "", ZZ4->ZZ4_NFENR, ZZ4->ZZ4_NFESER, ZZ4->ZZ4_CODPRO, ;
					 ZZ4->ZZ4_NFEDT, 0, ZZ4->ZZ4_CODCLI, ZZ4->ZZ4_LOJA, ZZ4->ZZ4_CODPRO, ZZ4->ZZ4_OS,,,,,ZZ4->(recno()) })
	if apmsgyesno('Deseja imprimir a etiqueta ?',"Teste")
		u_EtqMass2(_aImpEtiq)
	else
		alert(ZZ4->ZZ4_IMEI)
	endif
endif

_cImei := cIMEI := space(TamSX3("ZZ4_IMEI")[1])//Space(15)
ocimei:Setfocus()
restarea(_aAreaZZ4)

return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºExecblock ³ ETQMASS  º Autor ³ Marcelo Munhoz     º Data ³  16/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para impressao de Etiquetas.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EtqMass2(_aEtiquet)

Local nX
Local _aLin := {03,05,10,13,16,21,24}

Local _aLin := {01,04,11,14,17,20,25,28}

Local _aCol := {05,27,30,48}  //05,30
Local _aAreaSZA := SZA->(getarea())
                                             
dbselectarea("SZA")
SZA->(dbSetOrder(1)) // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura da Matriz                                                         ³
//³ 01 - IMEI                     ZZ4_IMEI                                      ³
//³ 02 - Numero da OS             ZZ4_OS                                        ³
//³ 03 - Item da OS               ""                                            ³
//³ 04 - Numero da NF de Entrada  ZZ4_NFENR                                     ³
//³ 05 - Serie da NF de Entrada   ZZ4_NFESER                                    ³
//³ 06 - Codigo do aparelho       ZZ4_CODPRO                                    ³
//³ 07 - Data de Entrada          ZZ4_NFEDT                                     ³
//³ 08 - Recno do SD1             0  (desativado - M.Munhoz - 16/08/11)         ³
//³ 09 - Codigo Cliente           ZZ4_CODCLI                                    ³
//³ 10 - Loja Cliente             ZZ4_LOJA                                      ³
//³ 11 - Modelo                   B1_MODELO 								    ³
//³ 12 - Lote                     ""                                            ³
//³ 13 - Cor                                                                    ³
//³ 14 - Dt.Compra                                                              ³
//³ 15 - Data de Entrada                                                        ³
//³ 16 - Data de Entrada                                                        ³
//³ 17 - Recno do ZZ4                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Layout da Etiqueta                              ³
//³ Ú--------------- 88 mm -----------------------¿ ³
//³ |  IMEI: 000000000000000                      | ³
//³ |  OS: 000000-0000	Modelo: XXXXXXXXXXXXXX 22 | ³
//³ |  NF/Serie: 000000/000	Dt.Entr: 99/99/99  mm ³ ³
//³ À---------------------------------------------Ù ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//MSCBPRINTER("Z90XI","LPT1",,040,.F.,,,,,,.T.)
MSCBPRINTER("ELTRON","LPT1",,040,.F.,,,,,,.T.)

For nX := 1 to Len(_aEtiquet)
  
	MSCBBEGIN(1,6)
/*
	// Alimenta flag de impressao da etiqueta no SD1
	if _aEtiquet[nX,8] <> 0
		SD1->(dbGoTo(_aEtiquet[nX,8]))
		reclock("SD1",.f.)
		SD1->D1_XIMPETQ := "S"
		msunlock()
	endif
*/
	// Alimenta flag de impressao da etiqueta no ZZ4 - Alterado por M.Munhoz em 16/08/2011
	if _aEtiquet[nX,17] <> 0
		ZZ4->(dbGoTo(_aEtiquet[nX,17]))
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_IMPETQ := "S"
		msunlock()
	endif

	// Alimenta variaveis
	
	_cIMEI    := _aEtiquet[nX, 1]
	_cOS      := _aEtiquet[nX, 2] + "/" + _aEtiquet[nX, 3]
	_cNFSer   := _aEtiquet[nX, 4] + "/" + _aEtiquet[nX, 5]
	_cCodPro  := _aEtiquet[nX, 6] 
	_cDtEntr  := dtoc(_aEtiquet[nX, 7])
	_cCliente := _aEtiquet[nX, 9] + "/" + _aEtiquet[nX,10]
	_cModelo  := _aEtiquet[nX, 11]                

    _cLote    := POSICIONE("SD1",12,xFilial("SD1")+ _aEtiquet[nX, 4] + _aEtiquet[nX, 5] + _aEtiquet[nX, 9] + _aEtiquet[nX,10] + _aEtiquet[nX, 6] + _aEtiquet[nX, 1] , "D1_XLOTE") //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER 
    _cNomCli  := getadvfval("SA1","A1_NOME",xFilial("SA1") + _aEtiquet[nX, 9] + _aEtiquet[nX,10] , 1, space(10))
	_cCor     := getadvfval("SB1","B1_XCOR",xFilial("SB1") + _aEtiquet[nX, 6] , 1, "") 
	//ACRESCENTADO EDSON RODRIGUES/LUIZ FERREIRA PARA GRAVAR O MODELO,DPY e LOTE - 17/11/08
    _cCodPro  := getadvfval("SB1","B1_COD",xFilial("SB1") + _aEtiquet[nX,6]  , 1, "")
	_cCodPro  := IIF(EMPTY(_cCodPro), _aEtiquet[nX,6],_cCodPro) 
    _cModelo  := getadvfval("SB1","B1_MODELO",xFilial("SB1") + _aEtiquet[nX, 11]  , 1, "")
   	_cModelo  := IIF(EMPTY(_cModelo), _aEtiquet[nX, 11],_cModelo)  
	//-------------------------------------------------------------------------------                 
	_cCor     := iif(!empty(_cCor),tabela("Z3",_cCor), "Nao informado")
    _coperbgh :=Posicione("ZZ4",1,xFilial("ZZ4") + _cIMEI + LEFT(_cOS,6), "ZZ4_OPEBGH")

	_cStatus	:= Posicione("ZZ4",1,xFilial("ZZ4") + _cIMEI + LEFT(_cOS,6), "ZZ4_CODREP")

    _infaces  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_INFACE")
    _clab     :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_LAB")
    _cOper	  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_CODOPE")
    _acessori :={}                                            
    _cacesso:= "Acess.:"
    _cacess2:= ""
    _cacess3:= ""
	if SZA->(dbSeek(xFilial("SZA") + _aEtiquet[nX, 9] + _aEtiquet[nX,10] + _aEtiquet[nX, 4] + _aEtiquet[nX, 5] + _aEtiquet[nX, 1]))
		_cDtCom   := dtoc(SZA->ZA_DTNFCOM)
		_cDtFab   := SZA->ZA_DTFABRI //MMAA
	    
	    If _clab="2" .and. _coperbgh="N03"
		   _ccodrecl:=SZA->ZA_CODRECL
		   _cDefRecl :=left(alltrim(_ccodrecl)+'-'+left(ALLTRIM(Posicione("SX5",1,xFilial("SX5") + "W4"+_ccodrecl, "X5_DESCRI"))),30)
		ElseIf _clab="2" .and. _coperbgh<>"N03"
 		   _ccodrecl:=SZA->ZA_DEFRECL
		   _cDefRecl :=left(alltrim(_ccodrecl)+'-'+ALLTRIM(getadvfval("ZZG","ZZG_DESCRI",xFilial("ZZG") + _aEtiquet[nX, 10] , 2, "")),30) 
		   _cOper    := 'NEX - NEXTEL'
		ELSE
		   _cDefRecl := left(alltrim(SZA->ZA_DEFCONS),30)
           _cOper    := left(alltrim(SZA->ZA_NOMEOPE),25)
		Endif
	else
		_cDtCom   := _cDtFab   := 	_cOper    := _cDefRecl := ""
	endif
	
	// Linha 1
	MSCBSAY(_aCol[1],_aLin[1],"IMEI: " 			+ _cIMEI				,"N","0","030,020")
	MSCBSAY(_aCol[2],_aLin[1],"Cod: "    		+ _cCodPro              ,"N","0","030,020")  //ACRESCENTADO LUIZ FERREIRA PARA GRAVAR O CODIGO + MODELO - 17/11/08
	MSCBSAY(_aCol[4],_aLin[1],"Cor: " 	   		+ _cCor				    ,"N","0","030,020")

	// Linha 2
	MSCBSAYBAR(_aCol[1]+10,_aLin[2],_aEtiquet[nX, 1]						,"N","MB07",6 ,.F.,.F.,.F.,,,,.T.)

	// Linha 3
	MSCBSAY(_aCol[1],_aLin[3],  "Dt.Com.: " 		+ _cDtCom				,"N","0","030,020")
	MSCBSAY(_aCol[2],_aLin[3],  "Dt.Fab.: " 		+ _cDtFab 				,"N","0","030,020") 
	MSCBSAY(_aCol[4]-4,_aLin[3],"Lote: "   	+ _cLote        	    	,"N","0","030,020") //Adicionado Lote - Luiz Ferreira / 17/11/2008

	// Linha 4
	MSCBSAY(_aCol[1],_aLin[4],"NF/Serie: "	 	+ _cNFSer  				,"N","0","030,020")
	MSCBSAY(_aCol[2],_aLin[4],"Dt.Entr.: " 		+ _cDtEntr				,"N","0","030,020") 
	MSCBSAY(_aCol[4],_aLin[4],"Mod.: " 		    + _cModelo				,"N","0","030,020") //ACRESCENTADO LUIZ FERREIRA PARA GRAVAR O CODIGO + MODELO - 17/11/08
	if alltrim(_aEtiquet[nX, 5]) == "3"
		MSCBSAY(_aCol[4],_aLin[4],"CORREIO"								,"N","0","030,020")
	endif

	// Linha 5
	MSCBSAY(_aCol[1],_aLin[5],"Cliente: "		+ _cCliente	+ _cNomCli	,"N","0","030,020") 
	MSCBSAY(_aCol[4],_aLin[5],"NumOs.: "       + _aEtiquet[nX, 2]      ,"N","0","030,020")  
                                                           
    IF _infaces="S"
        _acessori:=U_buscaces(_aEtiquet[nX, 4],_aEtiquet[nX, 5],_aEtiquet[nX, 9],_aEtiquet[nX, 10],_cCodPro,_cIMEI,_coperbgh)
       IF len(_acessori) > 0      
          For xac:=1 to len(_acessori)
          	if _acessori[xac,4] == "N"
          		_cExist := "-(NV)  "
          	else
          		_cExist := "  "
          	endif
            IF xac <= 3 
              _cacesso:=_cacesso+strzero(_acessori[xac,1],2)+'-'+trim(_acessori[xac,3])+_cExist
            ELSEIF xac > 3 .and. xac <=6 
               _cacess2:=_cacess2+strzero(_acessori[xac,1],2)+'-'+trim(_acessori[xac,3])+_cExist
            ELSEIF xac > 6 .and. xac <=9
               _cacess3:=_cacess3+strzero(_acessori[xac,1],2)+'-'+trim(_acessori[xac,3])+_cExist
            ENDIF   
          Next
       Endif    
       
       // Linha 6                                                                                                                                               .
       MSCBSAY(_aCol[1],_aLin[6],_cacesso,"N","0","030,020")  
       IF !EMPTY(_cacess2)
            MSCBSAY(_aCol[1],_aLin[6]+2,_cacess2,"N","0","030,020")  
       ENDIF     
       IF !EMPTY(_cacess3)
            MSCBSAY(_aCol[1],_aLin[6]+4,_cacess3,"N","0","030,020")  
       ENDIF     
            
    ELSE
       // Linha 6
	   MSCBSAY(_aCol[1],_aLin[6],"Acess.: [ ] Bateria [ ] Carregador [ ] Memory Stick [ ] Tampa [ ] Simcard","N","0","030,020")  
    
    ENDIF    

	// Linha 7
	IF !EMPTY(_cacess2)
    	MSCBSAY(_aCol[1],_aLin[7]+3,"Def.Recl: " 	+ _cDefRecl				,"N","0","030,020") 
    	MSCBSAY(_aCol[4]+2,_aLin[7]+3,"Oper: " 		+ _cOper				,"N","0","030,020") 
    ELSE
        MSCBSAY(_aCol[1],_aLin[7],"Def.Recl: " 	+ _cDefRecl				,"N","0","030,020") 
    	MSCBSAY(_aCol[4]+2,_aLin[7],"Oper: " 		+ _cOper				,"N","0","030,020")     
    ENDIF

	MSCBSAY(_aCol[1],_aLin[8],"STATUS:"  + Posicione("SX5",1,xFilial("SX5") + "W1"+_cStatus, "X5_DESCRI") 	,"N","0","030,030")  // Coluna 1 - Linha 5

	MSCBEND()

Next nX

MSCBCLOSEPRINTER()
restarea(_aAreaSZA)
_aEtiquet := {}

Return          





