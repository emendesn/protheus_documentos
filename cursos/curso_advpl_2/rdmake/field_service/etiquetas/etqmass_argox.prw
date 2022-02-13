#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
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
User Function etqentr1(_a)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracoes das variaveis                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
private oDlg   := Nil                    
private ocimei := nil
private cIMEI  := space(TamSX3("ZZ4_IMEI")[1])//Space(15)

u_GerA0003(ProcName())

default _a := {}

if len(_a) >= 1
	EtqMass2(_a)
	RETURN(.T.)
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da janela e seus conteudos                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Etiqueta de ENTRADA" FROM 0,0 TO 210,420 OF oDlg PIXEL

@ 010,015 SAY   "Informe o IMEI para imprimir a Etiqueta de ENTRADA." 	SIZE 150,008 PIXEL OF oDlg 
@ 035,015 TO 070,180 LABEL "IMEI" PIXEL OF oDlg 
@ 045,025 MSGET ocimei Var cIMEI PICTURE "@!" 	SIZE 080,010 Valid impmass2(cImei) PIXEL OF oDlg 

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
static function impmass2(_cImei)

local _aAreaZZ4 := ZZ4->(getarea())
local _aImpEtiq := {}

ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_STATUS

if !empty(_cImei) .and. ZZ4->(dbSeek(xFilial("ZZ4") + _cImei))
	aAdd(_aImpEtiq, {IIF(ALLTRIM(ZZ4->ZZ4_OPEBGH)=="P01",ZZ4->ZZ4_CARCAC,ZZ4->ZZ4_IMEI), ZZ4->ZZ4_OS, "", ZZ4->ZZ4_NFENR, ZZ4->ZZ4_NFESER, ZZ4->ZZ4_CODPRO, ;
					 ZZ4->ZZ4_NFEDT, 0, ZZ4->ZZ4_CODCLI, ZZ4->ZZ4_LOJA, ZZ4->ZZ4_CODPRO, ZZ4->ZZ4_OS,,,,,ZZ4->(RECNO()), ZZ4->ZZ4_ITEMD1 })
	if apmsgyesno('deseja imprimir a etiqueta?')
		EtqMass2(_aImpEtiq)
	else
		alert('Etiqueta não impressa. IMEI: '+ZZ4->ZZ4_IMEI)
	endif
endif

_cImei := cIMEI := Space(TamSX3("ZZ4_IMEI")[1])//Space(15)
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

Static Function EtqMass2(_aEtiquet)

Local nX 
Local aAreaAtu := {}
Local _aLin := {41,35,32,28,24,20,16,05,01}//{42,32,28,24,20,16,5,01}
Local _aCol := {03,35,43,68}  //05,30
//Local _aCol := {05,27,30,48}      // correcao
Local _aAreaSZA := SZA->(getarea())
Local cDef:="" 
Local cDef2:=""
Local cDef3:=""


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

For nX := 1 to Len(_aEtiquet)
// Alimenta flag de impressao da etiqueta no SD1
/*
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
	_cModelo  := _aEtiquet[nX, 6]                
    _cLote    := POSICIONE("SD1",1,xFilial("SD1")+ _aEtiquet[nX, 4] + _aEtiquet[nX, 5] + _aEtiquet[nX, 9] + _aEtiquet[nX,10] + _aEtiquet[nX, 6] + _aEtiquet[nX, 18] , "D1_XLOTE") //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
    _cNomCli  := getadvfval("SA1","A1_NOME",xFilial("SA1") + _aEtiquet[nX, 9] + _aEtiquet[nX,10] , 1, space(10))
	_cCor     := getadvfval("SB1","B1_XCOR",xFilial("SB1") + _aEtiquet[nX, 6] , 1, "") 
    _cCodPro  := getadvfval("SB1","B1_COD",xFilial("SB1") + _aEtiquet[nX,6]  , 1, "")
	_cCodPro  := IIF(EMPTY(_cCodPro), _aEtiquet[nX,6],_cCodPro) 
    _cModelo  := getadvfval("SB1","B1_MODELO",xFilial("SB1") + _aEtiquet[nX, 6]  , 1, "")
   	_cModelo  := IIF(EMPTY(_cModelo), _aEtiquet[nX, 6],_cModelo)  

	_cCor     := iif(!empty(_cCor),tabela("Z3",_cCor), "Nao informado")              
	_coperbgh :=Posicione("ZZ4",1,xFilial("ZZ4") + _cIMEI + LEFT(_cOS,6), "ZZ4_OPEBGH")
	
	_nBounce := Posicione("ZZ4",1,xFilial("ZZ4") + _cIMEI + LEFT(_cOS,6), "ZZ4_BOUNCE")

	_cStatus	:= Posicione("ZZ4",1,xFilial("ZZ4") + _cIMEI + LEFT(_cOS,6), "ZZ4_CODREP")

    _infaces  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_INFACE")
    _clab     :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_LAB")    
    _cOper	  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_CODOPE")
    _cNomeOper	  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_DESCRI")
    _acessori :={}

    _cacesso:= "Acess.:"
    _cacess2:= ""
    _cacess3:= ""    


	if SZA->(dbSeek(xFilial("SZA") + _aEtiquet[nX, 9] + _aEtiquet[nX,10] + _aEtiquet[nX, 4] + _aEtiquet[nX, 5] + _aEtiquet[nX, 1]))
		_cDtCom   := dtoc(SZA->ZA_DTNFCOM)
		_cDtFab   := SZA->ZA_DTFABRI //MMAA
		If _clab="2" .and. _coperbgh="N03"
		   _ccodrecl:=SZA->ZA_CODRECL
		   _cDefRecl :=alltrim(_ccodrecl)+'-'+ALLTRIM(Posicione("SX5",1,xFilial("SX5") + "W4"+_ccodrecl, "X5_DESCRI"))
		ElseIf _clab="2" .and. _coperbgh<>"N03"
 		   _ccodrecl:=SZA->ZA_DEFRECL
		   _cDefRecl :=alltrim(_ccodrecl)+'-'+ALLTRIM(getadvfval("ZZG","ZZG_DESCRI",xFilial("ZZG") + _aEtiquet[nX, 10] , 2, ""))
		   _cOper    := 'NEX - NEXTEL'
		ELSE
		   _cDefRecl := Alltrim(SZA->ZA_DEFCONS)
           _cOper    := left(alltrim(SZA->ZA_NOMEOPE),25)
		Endif
		   
	else
		_cDtCom   := _cDtFab   := 	_cOper    := _cDefRecl := ""
	endif     
	
	aAreaAtu := GetArea()
	
	If Alltrim(_coperbgh)=="P04"//Buscar Defeito conforme solicitação do Edson - Luciano 11/10/2012
		_cDefRecl := ""
		
		_cQuery := " SELECT "
		_cQuery += " 	RTRIM(CAST(CustomerComplaintDescription AS VARCHAR))  AS DEFRECL "  
		_cQuery += " FROM [BGH_CALLCENTER].[dbo].[Incident] (nolock) " 
		_cQuery += " INNER JOIN "
		_cQuery += " 	(SELECT ZZ4_OS FROM "+RETSQLNAME("ZZ4")+" "
		_cQuery += "     WHERE "
		_cQuery += " 	 ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "             
		_cQuery += " 	 AND ZZ4_IMEI = '"+_cIMEI+"' " 
		_cQuery += " 	 AND ZZ4_OS = '"+LEFT(_cOS,6)+"' " 
		_cQuery += " 	 AND D_E_L_E_T_ = ''  ) AS ZZ4 " 
		_cQuery += " ON (OsId COLLATE Latin1_General_BIN = ZZ4_OS) "
		
		
		If Select("TSQLDEF") > 0
			dbSelectArea("TSQLDEF")
			DbCloseArea()
		EndIf	
		
		//dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TSQLDEF",.T.,.T.)
		
		TCQUERY _cQuery NEW ALIAS "TSQLDEF"
	
		TSQLDEF->(DBGoTop())
		
		While TSQLDEF->(!EOF())
			_cDefRecl := IIF(EMPTY(_cDefRecl), Alltrim(TSQLDEF->DEFRECL), _cDefRecl+space(1)+Alltrim(TSQLDEF->DEFRECL))
			TSQLDEF->(DBSkip())	
		EndDo 
		If Select("TSQLDEF") > 0
			dbSelectArea("TSQLDEF")
			DbCloseArea()
		EndIf	
	Endif
	RestArea(aAreaAtu)
	
	if  substr(_cNomeOper,1,4) == "SONY"
		_nTotImp := GetMv("MV_QTDETQ")
	else
		_nTotImp := 1
	endif
    
 	for zzx := 1 to _nTotImp
	    _caces	:= "Acess.:"
	
		MSCBPRINTER("OS 214","LPT1",,104,.F.,,,,,,.T.)  //esta linha esta funcionando a impressora ARGOX
		MSCBChkStatus(.f.)
		
    	MSCBBEGIN(1,3)
		// Linha 1 _aLin := {42,38,32,28,24,20,18,5,01}
		MSCBSAY(_aCol[1],_aLin[1],"IMEI: " 			+ _cIMEI				,"N","2","01,01")
		MSCBSAY(_aCol[2],_aLin[1],"Cod: "    		+ _cCodPro              ,"N","2","01,01")  //ACRESCENTADO LUIZ FERREIRA PARA GRAVAR O CODIGO + MODELO - 17/11/08
		MSCBSAY(_aCol[4],_aLin[1],"Cor: " 	   		+ _cCor				    ,"N","2","01,01")
	
		// Linha 2
		MSCBSAYBAR(_aCol[1]+1,_aLin[2],Alltrim(_aEtiquet[nX, 1])					,"N","MB07",5,.F.,.F.,.F.,NIL)
	
		// Linha 3
		MSCBSAY(_aCol[1],_aLin[3],  "Dt.Com.: " 		+ _cDtCom			,"N","2","01,01")
		MSCBSAY(_aCol[2],_aLin[3],  "Dt.Fab.: " 		+ _cDtFab 			,"N","2","01,01") 
		MSCBSAY(_aCol[4]-4,_aLin[3],"Lote: "   	+ _cLote        	    	,"N","2","01,01") //Adicionado Lote - Luiz Ferreira / 17/11/2008
	
		// Linha 4
		MSCBSAY(_aCol[1],_aLin[4],"NF/Serie: "	 	+ _cNFSer  				,"N","2","01,01")
		MSCBSAY(_aCol[2]+4,_aLin[4],"Dt.Entr.: " 	  	+ _cDtEntr				,"N","2","01,01") 
		MSCBSAY(_aCol[4],_aLin[4],"Mod:" 		 +Alltrim(_cModelo)				,"N","2","01,01") //ACRESCENTADO LUIZ FERREIRA PARA GRAVAR O CODIGO + MODELO - 17/11/08
		if alltrim(_aEtiquet[nX, 5]) == "3"
			MSCBSAY(_aCol[4],_aLin[5],"CORREIO"								,"N","2","01,01")
		endif
	
		// Linha 5
		MSCBSAY(_aCol[1],_aLin[5],"Cliente: "		+ _cCliente	+' '+ left(_cNomCli,25)	,"N","2","01,01")
		 
		MSCBSAY(_aCol[1],_aLin[6],"NumOs.: "       + _aEtiquet[nX, 2]      ,"N","2","01,01")  
		MSCBSAYBAR(_aCol[2]-5,_aLin[6],Alltrim(_aEtiquet[nX, 2])					,"N","MB07",3,.F.,.F.,.F.,NIL)//Incluido a Pedido Jose Rocha - 27/09/12 - Thomas Galvão
		
	    /*IF _infaces="S"
	        _acessori:=U_buscaces(_aEtiquet[nX, 4],_aEtiquet[nX, 5],_aEtiquet[nX, 9],_aEtiquet[nX, 10],_cCodPro,_cIMEI,_coperbgh)
	       IF len(_acessori) > 0                                                                                                                                   
	          For xac:=1 to len(_acessori)
		          	if _acessori[xac,4] == "N"
		          		_cExist := "-(NV)  "
		          	else
		          		_cExist := "  "
		          	endif		          	
	          	    _caces	+= strzero(_acessori[xac,1],2)+'-'+trim(_acessori[xac,3])+_cExist
	          Next
              
			                            
	          For xac:=1 to len(_caces)
		            IF xac <= 62 
		              _cacesso:= substr(_caces,1,62)
		            ELSEIF xac > 62 .and. xac <=124 
		              _cacess2:= substr(_caces,63,62)
		            ELSEIF xac > 124
		              _cacess3:= substr(_caces,124)
		            ENDIF   
	          Next
	       Endif

	     	// Linha 6
	       MSCBSAY(_aCol[1],_aLin[7],_cacesso,"N","2","01,01")  
	      IF !EMPTY(_cacess2)
	         MSCBSAY(_aCol[1],_aLin[7]-4,_cacess2,"N","2","01,01")  
	      ENDIF 
	      IF !EMPTY(_cacess3)
	         MSCBSAY(_aCol[1],_aLin[7]-7,_cacess3,"N","2","01,01")  
	      ENDIF 
	       
	    ELSE
	     	// Linha 6
	     	MSCBSAY(_aCol[1],_aLin[7],"Acess.: [ ] Bateria [ ] Carregador [ ] Memory Stick [ ] Tampa  [ ] Simcard","N","2","01,01")  
	    ENDIF*/
		
		
	   	/*If Alltrim(_coperbgh)=="P04"
			If len(Alltrim(_cDefRecl)) >= _aCol[3]
				MSCBSAY(_aCol[1]+13,_aLin[8]+8,"Def.Recl: " 	+ substr(_cDefRecl,1,_aCol[3])				,"N","2","01,01") 
				MSCBSAY(_aCol[1],_aLin[8]+8,"Oper: " 		+ _cOper									,"N","2","01,01") 
				MSCBSAY(_aCol[1],_aLin[8]+4,substr(_cDefRecl,_aCol[3]+1,len(Alltrim(_cDefRecl)))		,"N","2","01,01") 
			Else 
				MSCBSAY(_aCol[1],_aLin[8],"Def.Recl: " 	+ _cDefRecl			,"N","2","01,01") 
				MSCBSAY(_aCol[4]+2,_aLin[8],"Oper: " 	+ _cOper			,"N","2","01,01") 
			Endif    	
		Else
			// Linha 7
			MSCBSAY(_aCol[1],_aLin[8],"Def.Recl: " 	+ _cDefRecl				,"N","2","01,01") 
			MSCBSAY(_aCol[4]-2,_aLin[8],"Oper: " 		+ _cOper			,"N","2","01,01") 
		Endif*/  
		
		//Alteração Vinicius Leonardo - Delta Decisao - 30/07/2015 ///////////////////////////////
		cDef:="" 
		cDef2:=""
		cDef3:="" 
		If Empty(_cDefRecl)
			_cDefRecl := "DEFEITO NAO INFORMADO PELO CLIENTE"
		EndIf	
		For xac:=1 to len(_cDefRecl)
			IF xac <= 45 
				cDef:= substr(_cDefRecl,1,45)
			ELSEIF xac > 45 .and. xac <=100 
				cDef2:= substr(_cDefRecl,46,55)
			ELSEIF xac > 100
				cDef3:= substr(_cDefRecl,101)
			ENDIF   
		Next xac
		// Linha 6
		MSCBSAY(_aCol[1],_aLin[7],"Def.Recl: " 	+ cDef,"N","2","01,01")  
		IF !EMPTY(cDef2)
			MSCBSAY(_aCol[1],_aLin[7]-4,cDef2,"N","2","01,01")  
		ENDIF 
		IF !EMPTY(cDef3)
			MSCBSAY(_aCol[1],_aLin[7]-8,cDef3,"N","2","01,01")  
		ENDIF	
		// Linha 7		
		MSCBSAY(_aCol[1],_aLin[8],"Acess.:" 							,"N","2","01,01") 
		MSCBSAY(_aCol[4]-2,_aLin[8],"Oper: " 		+ _cOper			,"N","2","01,01") 
        /////////////////////////////////////////////////////////////////////////////////////////
        
		If _nBounce > 0 
        	MSCBSAY(_aCol[4],_aLin[9],"BOUNCE - " + Alltrim(str(_nBounce)) + " dias"	,"N","2","01,01") 
		Endif
		
		MSCBSAY(_aCol[1],_aLin[9],"STATUS:"  + Alltrim(Posicione("SX5",1,xFilial("SX5") + "W1"+_cStatus, "X5_DESCRI")) 	,"N","2","01,01") 	
	    
		MSCBEND()
		MSCBCLOSEPRINTER()
		
	Next zzx
	        
Next nX

restarea(_aAreaSZA)
_aEtiquet := {}

Return
