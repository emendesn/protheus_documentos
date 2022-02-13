#include 'rwmake.ch'
#include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD1100I  ºAutor  ³ M.Munhoz - ERPPLUS º Data ³ 13/05/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada apos confirmar inclusao da NFE.           º±±
±±º          ³ Atualiza Entrada Massiva                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterado por M.Munhoz em 21/08/2011 para substituir o tratamento do D1_NUMSER  ³
//³ pelo D1_ITEM, uma vez que o IMEI deixara de ser gravado no SD1.                ³
//³ Como este ponto de entrada eh executado para cada item do SD1 a logica do      ³
//³ programa que ser totalmente alterada, passando a varrer todo o ZZ4 a partir    ³
//³ de cada item do SD1 (n ZZ4 para 1 SD1)                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

user function SD1100I()

local _aAreaSB1 := SB1->(GetArea())
local _aAreaSD2 := SD2->(GetArea())
local _aAreaZZ4 := ZZ4->(GetArea())
local _aAreaSDA := SDA->(GetArea())  // Carlos Rocha - Incluído 16/03/2010
local _aAreaSBE := SBE->(GetArea())  // Carlos Rocha - Incluído 16/03/2010     
local _aAreaZZO := ZZO->(GetArea())  // Carlos Rocha - Incluído 16/03/2010     
local _dSaida   := ctod("  /  /  ")
Local aCab      := {}
Local aItem     := {}
Local cArmazem  := ''
Local _cctrlote := ''
Local _cContSe  := ''
Local _lvaloper := .f.
Local _lvalloca := .f.

	u_GerA0003(ProcName())
lMSHelpAuto     := .F. // para mostrar os erro na tela
lMserroauto     := .f.
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza ZZ4 com os dados da Nota Fiscal de Entrada + Cad.Produto + Bounce    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if SD1->D1_TIPO == 'B' .and. !empty(SD1->D1_NUMSER)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o BOUNCE              D2NUMSEMIS                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//SD2->(dbSetOrder(10)) // D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO) - Edson Rodrigues - 02/10/10
	SD2->(DBOrderNickName('D2NUMSEMIS')) //D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO)
	if SD2->(dbSeek(xFilial("SD2") + SD1->D1_NUMSER))
		while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_NUMSERI == SD1->D1_NUMSER .and. SD2->D2_EMISSAO < dDataBase
			_dSaida := SD2->D2_EMISSAO
			SD2->(dbSkip())
		enddo
	endif

	SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
	SB1->(dbSeek(xFilial("SB1") + SD1->D1_COD ))
	ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI

	if ZZ4->(dbSeek(xFilial("ZZ4") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_NUMSER ))
        _cctrlote:=POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_CTRLOT")                         	
	
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_STATUS := '3'
		ZZ4->ZZ4_NFEDT  := dDataBase
		ZZ4->ZZ4_NFEHR  := time()
		ZZ4->ZZ4_DOCDTE := SD1->D1_DTDOCA
		ZZ4->ZZ4_DOCHRE := left(SD1->D1_HRDOCA,2)+":"+substr(SD1->D1_HRDOCA,3,2)+":00"
		ZZ4->ZZ4_LOCAL  := SD1->D1_LOCAL
		ZZ4->ZZ4_GRPPRO := SB1->B1_GRUPO
		ZZ4->ZZ4_ITEMD1 := SD1->D1_ITEM
		
		if !empty(_dSaida)   
			IF EMPTY(ZZ4->ZZ4_ETQMEM)
			    ZZ4->ZZ4_BOUNCE := dDataBase - _dSaida
			ENDIF   
			ZZ4->ZZ4_ULTSAI := _dSaida
		endif
		
		if _cctrlote ="S"
		    ZZ4->ZZ4_XLOTE := SD1->D1_XLOTE		
		Endif 
		
		msunlock()

	endif

endif
*/
SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD

// M.Munhoz - 30/04/2015 - Alterado para atender mudanca de Osasco para Alphaville
//if SF1->F1_FORNECE == "Z00403" .and. cFilAnt == "06" // Nao executa para NF de entrada massiva na filial Osasco com BGH Alphaville
//ZZO->(dbSetOrder(5)) // ZZO_FILIAL + ZZO_CLIENT + ZZO_LOJA + ZZO_NF + ZZO_SERIE + ZZO_MODELO + ZZO_STATUS

// Ordena o ZZ4 pelo item de Nota Fiscal de Entrada
ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
ZZO->(dbSetOrder(3)) // ZZO_FILIAL + ZZO_IMEI + ZZO_STATUS
if ZZ4->(dbSeek(xFilial("ZZ4") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD )) .and. ;
(ZZO->(dbSeek(xFilial("ZZO") + ZZ4->ZZ4_IMEI + 'P' )) .or. ZZO->(dbSeek(xFilial("ZZO") + ZZ4->ZZ4_IMEI + 'E' )))

	// Ordena o ZZ4 pelo item de Nota Fiscal de Entrada
	ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI

	if ZZ4->(dbSeek(xFilial("ZZ4") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD ))
	
		// Varre o item do SD1 no ZZ4 abrangendo todos os IMEIs deste item
		while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFENR == SD1->D1_DOC .and. ZZ4->ZZ4_NFESER == SD1->D1_SERIE .and. ;
			ZZ4->ZZ4_CODCLI == SD1->D1_FORNECE .and. ZZ4->ZZ4_LOJA == SD1->D1_LOJA .and. ZZ4->ZZ4_CODPRO == SD1->D1_COD

			if ZZ4->ZZ4_VLRUNI == SD1->D1_VUNIT .and. alltrim(ZZ4->ZZ4_OPEBGH) == alltrim(SD1->D1_XOPEBGH)

				// Importa registros das tabelas ZZ3/SZ9/ZZ7/ZZY/ da filial Alphaville para Osasco
				_lFase := .f.
				_lFase := u_ImpFases(left(ZZ4->ZZ4_OS,6), ZZ4->ZZ4_IMEI, ZZ4->ZZ4_ETQMEM, ZZ4->ZZ4_DOCSEP)
		
				reclock("ZZ4",.f.)
				ZZ4->ZZ4_DOCDTE := SD1->D1_DTDOCA
				ZZ4->ZZ4_DOCHRE := left(SD1->D1_HRDOCA,2)+":"+substr(SD1->D1_HRDOCA,3,2)+":00"
				ZZ4->ZZ4_ITEMD1 := SD1->D1_ITEM
				ZZ4->ZZ4_STATUS := iif(_lFase,"4","3")
				msunlock()

			endif
			
			ZZ4->(dbSkip())
	
		enddo
	
	endif
	
else

	// Ordena o ZZ4 pelo item de Nota Fiscal de Entrada
	ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
	// Se encontrar o ZZ4 significa que a NFE refere-se a uma entrada massiva
	if SD1->D1_TIPO == 'B' .and. ZZ4->(dbSeek(xFilial("ZZ4") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD ))
	
		SB1->(dbSeek(xFilial("SB1") + SD1->D1_COD ))
	
		// Varre o item do SD1 no ZZ4 abrangendo todos os IMEIs deste item
		while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFENR == SD1->D1_DOC .and. ZZ4->ZZ4_NFESER == SD1->D1_SERIE .and. ;
		       ZZ4->ZZ4_CODCLI == SD1->D1_FORNECE .and. ZZ4->ZZ4_LOJA == SD1->D1_LOJA .and. ZZ4->ZZ4_CODPRO == SD1->D1_COD 
		        
		       _lvaloper := .f.
	           _lvalloca := .f.                        
	           _cTESD1   := SD1->D1_TES
	
		       
		       IF !empty(ZZ4->ZZ4_OPEBGH) .AND. !empty(SD1->D1_XOPEBGH)  
		           _lvaloper := .T.                 
		       ENDIF
		       
		       IF !empty(ZZ4->ZZ4_LOCAL)  .AND. !empty(SD1->D1_LOCAL)  
		           _lvalloca := .T.
		       ENDIF
		       
		       IF _lvalloca .AND. !ZZ4->ZZ4_LOCAL==SD1->D1_LOCAL
	          		ZZ4->(dbSkip()) 
		            Loop
		       ENDIF
		       
		       IF _lvaloper .AND. !ZZ4->ZZ4_OPEBGH==SD1->D1_XOPEBGH 
	          		ZZ4->(dbSkip()) 
		            Loop
		       ENDIF
		       
		       //Ajuste efetuado pois existem o mesmo item na nota com valores distintos - Luciano 08/03
		       IF ZZ4->ZZ4_VLRUNI <> SD1->D1_VUNIT
	          		ZZ4->(dbSkip()) 
		            Loop
		       ENDIF
		       
		      
		       _dSaida:=ctod("  /  /  ")
			  		  
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³ Calcula o BOUNCE              D2NUMSEMIS                                                ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   //SD2->(dbSetOrder(10)) // D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO) - Edson Rodrigues - 02/10/10
			   SD2->(DBOrderNickName('D2NUMSEMIS')) //D2_FILIAL + D2_NUMSERI + DTOS(D2_EMISSAO)
			   if SD2->(dbSeek(xFilial("SD2") + ZZ4->ZZ4_IMEI)) .or. SD2->(dbSeek("02" + ZZ4->ZZ4_IMEI))
				while SD2->(!eof()) .and. iif(SD2->D2_FILIAL ="06",.t.,SD2->D2_FILIAL == xFilial("SD2")) .and. SD2->D2_NUMSERI == ZZ4->ZZ4_IMEI .and. SD2->D2_EMISSAO < dDataBase
				    If SD2->D2_FILIAL <> "01"
						 _dSaida := SD2->D2_EMISSAO
					     SD2->(dbSkip())
					Endif     
				enddo
			   endif
	
	          _cctrlote := POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_CTRLOT")                         	
		      
		      reclock("ZZ4",.f.)
	           ZZ4->ZZ4_STATUS := '3'
	           ZZ4->ZZ4_NFEDT  := dDataBase
	           ZZ4->ZZ4_NFEHR  := time()
	           ZZ4->ZZ4_DOCDTE := SD1->D1_DTDOCA
	           ZZ4->ZZ4_DOCHRE := left(SD1->D1_HRDOCA,2)+":"+substr(SD1->D1_HRDOCA,3,2)+":00"
	           ZZ4->ZZ4_LOCAL  := SD1->D1_LOCAL
	           ZZ4->ZZ4_GRPPRO := SB1->B1_GRUPO
	           ZZ4->ZZ4_ITEMD1 := SD1->D1_ITEM
	           
	           IF _cTESD1 == '232' .AND. ZZ4->ZZ4_OPEBGH $ 'P01/I01/V01/I02'
	              ZZ4->ZZ4_GARANT := 'S' 
	           ELSEIF _cTESD1 == '229' .AND. ZZ4->ZZ4_OPEBGH $ 'P01/I01/V01/I02'
	              ZZ4->ZZ4_GARANT := 'N' 
	           ENDIF
	           
	           if !empty(_dSaida) .and. ZZ4->ZZ4_BOUNCE <= 0 .AND. ZZ4->ZZ4_NUMVEZ <= 1
				  IF EMPTY(ZZ4->ZZ4_ETQMEM) 
					ZZ4->ZZ4_BOUNCE := dDataBase - _dSaida
				  ENDIF
				   ZZ4->ZZ4_ULTSAI := _dSaida
			    endif
			
			    if _cctrlote ="S"
			       ZZ4->ZZ4_XLOTE := SD1->D1_XLOTE		
			    Endif 
			
			  msunlock()
	
			ZZ4->(dbSkip())
		enddo
	
	endif

endif
	
_cContSe  := POSICIONE("SB1",1,xFilial("SB1") + SD1->D1_COD,"B1_XCONTSE")                         		

/* Grava endereco automatico para os produtos enderecados 
Claudia 28/06/2009*/                
//If SB1->B1_LOCALIZ = 'S' .AND. SDA->(DBSEEK(XFILIAL("SDA")  + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ  + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA))	 // .AND. SD1->D1_TIPO = 'N' CLAUDIA 14/08/09
SDA->(DBSETORDER(1))
// Carlos Rocha - 10/08/2010
// Não enderença automaticamente no ambiente TESTE
//If Upper(AllTrim(getenvserver())) # "TESTE" .AND. _cContSe <> "S" .AND. SD1->D1_LOCAL <> '08' .AND. SDA->(DBSEEK(XFILIAL("SDA")  + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA  )) // CLAUDIA 28/08/09                                                                                                                        
If _cContSe <> "S" .AND. SD1->D1_LOCAL <> '08' .AND. SDA->(DBSEEK(XFILIAL("SDA")  + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA  )) // CLAUDIA 28/08/09                                                                                                                        
   	//cArmazem := 'DROP AREA' //Alterado conforme solicitacao do Fernando Peratello em 16/12/11 - edson rodrigues 19/12/11
   	cArmazem := 'P999999' 
	SBE->(DbSetOrder(1))
	If ! SBE->(DBSEEK( XFILIAL("SBE")  +  SD1->D1_LOCAL + cArmazem )    )
		RecLock("SBE",.T.)
		SBE->BE_FILIAL  := XFILIAL("SBE")
		SBE->BE_LOCAL   := SD1->D1_LOCAL
		SBE->BE_LOCALIZ := cArmazem
		MsUnlock("SBE")
	EndIf
	
	aCab := {{"DA_PRODUTO"		,SDA->DA_PRODUTO     ,NIL},;
			{"DA_QTDORI"	    ,SDA->DA_QTDORI  	 ,NIL},;
			{"DA_SALDO"	        ,SDA->DA_SALDO 		 ,NIL},;
			{"DA_LOTECTL"		,SDA->DA_LOTECTL	 ,NIL},;
			{"DA_LOCAL"	        ,SDA->DA_LOCAL		 ,NIL},;									
			{"DA_DOC"	        ,SDA->DA_DOC    	 ,NIL},;
			{"DA_SERIE"	        ,SDA->DA_SERIE    	 ,NIL},;
			{"DA_CLIFOR"	    ,SDA->DA_CLIFOR    	 ,NIL},;
			{"DA_LOJA"	        ,SDA->DA_LOJA    	 ,NIL},;
			{"DA_NUMLOTE"	    ,SDA->DA_NUMLOTE  	 ,NIL},;
			{"DA_NUMSEQ"	    ,SDA->DA_NUMSEQ    	 ,NIL}} 

	aItem:={{"DB_ITEM"		    ,"0001"              ,NIL},;
			{"DB_ESTORNO"	    ,' '				 ,NIL},;
			{"DB_NUMSERI"	    ,SD1->D1_NUMSER		 ,NIL},;
			{"DB_QTSEGUM"	    ,' '				 ,NIL},;
			{"DB_LOCALIZ"		, CARMAZEM			 ,NIL},;
			{"DB_QUANT"		    ,SDA->DA_SALDO  	 ,NIL},;
			{"DB_DATA"		    ,SDA->DA_DATA		 ,NIL}}

		MSExecAuto({|x,y| MATA265(x,y)},aCab,{aItem},3)    
		
	if lmserroauto 
		Mostraerro()
	Endif	
	
ENDIF 

restarea(_aAreaSB1)
restarea(_aAreaSD2)
restarea(_aAreaZZ4)
restarea(_aAreaSDA)
restarea(_aAreaSBE)
restarea(_aAreaZZO)

Return()
