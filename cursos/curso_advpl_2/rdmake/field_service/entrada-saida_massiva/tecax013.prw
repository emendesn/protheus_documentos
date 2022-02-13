#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECAX013 ºAutor  ³Antonio L.F. Favero º Data ³  20/10/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Com os dados da Entrada massiva, eh gerada a Base Instaladaº±±
±±º          ³ e o Chamado Tecnico para cada aparelho                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Field Service - BGH                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterado por M.Munhoz em 21/08/2011 para substituir o tratamento do D1_NUMSER  ³
//³ pelo D1_ITEM, uma vez que o IMEI deixara de ser gravado no SD1.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function tecax013()

Local _cQuery := ""
Private nTamNfe  := TAMSX3("D1_DOC")[1]
Private nTamNfs  := TAMSX3("D2_DOC")[1]
Private nTdocD3  := TAMSX3("D3_DOC")[1]
Private nTcodpr  := TAMSX3("B1_COD")[1]


u_GerA0003(ProcName())

//Aviso('Ordens de Serviço',"Neste momento serão geradas as Ordens de Serviços correspondentes a esta Entrada Massiva.",{'OK'})

DBSelectArea('ZZ4') //Entrada Massiva
DBSelectArea('AA3') //Base Instalada
DBSelectArea('AB1') //Chamado Técnico
DBSelectArea('AB2') //Itens do Chamado Técnico
DBSelectArea('AB6') //Cabeçalho de Ordem de Serviço
DBSelectArea('AB7') //Itens da Ordem de Serviço
DBSelectArea('SA1') //Cadastro de Clientes
DBSelectArea('SB1') //Cadastro de Produtos
DBSelectArea('SB2') //Cadastro de Produtos

AA3->(DBSetOrder(1)) //AA3_CLIENTE+AA3_LOJA+AA3_PRODUTO+AA3_SN
SA1->(DBSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
SB1->(DBSetOrder(1)) //B1_FILIAL+B1_COD
SB2->(DBSetOrder(1)) //B1_FILIAL+B1_COD

// Selecao dos registros
DbSelectArea("ZZ4") //Entrada Massiva

//Alterado o select para com campos fixos, a fim de melhorar a performance. Edson Rodrigues - 06/05/10
_cQuery := " SELECT ZZ4_FILIAL,ZZ4_IMEI,ZZ4_OS,ZZ4_CARCAC,ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_CODPRO,ZZ4_VLRUNI,ZZ4_KIT,ZZ4_OPER,ZZ4_OPEBGH, "
_cQuery += "        ZZ4_STATUS,ZZ4_SWANT,R_E_C_N_O_,ZZ4_ITEMD1"
_cQuery += " FROM   "+RetSqlName("ZZ4") + " (nolock) "
_cQuery += " WHERE  ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND "
_cQuery += "        D_E_L_E_T_ = ''  AND "
_cQuery += "        ZZ4_OS     = ''  AND "
_cQuery += "        ZZ4_STATUS = '2' AND "
_cQuery += "        UPPER(ZZ4_EMUSER) = '"+Upper(Alltrim(cUserName))+"' "
_cQuery += " ORDER BY ZZ4_CODCLI "

TCQUERY _cQuery NEW ALIAS "ZZ4O"

Processa( {|| tecx013a() } )

//Limpa Filtro
DBSelectArea('ZZ4O')
//DBCloseArea('ZZ4O')
ZZ4O->(DBCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx013a  º Autor ³Antonio L.Favero    º Data ³  26.01.03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria os registros em AA3,AB1,AB2,AB6 e AB7                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx013a()

Local cAlias  := ALIAS(),;
aAlias := {"SD1","SB2","AA3","AB1","AB2","AB6","AB7"},;
aAmb   := U_GETAMB( aAlias )
Local nOS:=0     //Contador de Ordens de Serviço
Local nITCham  :=0 //Contador de Itens do Chamado
Local cItens   :='01'
Local cChaveOS :=""
Local coperbgh :=""
Local cnfent   :=""
Local cnfser   :=""
Local cclient  :=""
Local clojcli  :=""
Local _aSavZZ4 := {}
Local _ageraop := {} //vetor de geracao da OP
Local cContVez := 0
Local _lgeraop :=.t.
Local carmpacab :=""
Local lRet		:= .T.


SD1->(DbSetOrder(13)) //D1_FILIAL + D1_NUMSER + DTOS(D1_DTDIGIT)
ZZJ->(DbSetOrder(1)) //ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB

ProcRegua(ZZ4O->(RECCOUNT()))
ZZ4O->(DBGoTop())

While !ZZ4O->(EOF())
	
	
	cChaveOS := ZZ4O->(ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA)
	coperbgh   :=ZZ4O->ZZ4_OPEBGH
	cnfent     :=ZZ4O->ZZ4_NFENR
	cnfser     :=ZZ4O->ZZ4_NFESER
	cclient    :=ZZ4O->ZZ4_CODCLI
	clojcli    :=ZZ4O->ZZ4_LOJA
	_cfornsrf  := ""
	_cljforsrf := "" 
   _amovint := {} //vetor de movimentacao interna 
	nOS++
	
	
	//**********************************************
	//          Geracao dos Cabecalhos             *
	//**********************************************
	//CHAMADO TECNICO
	SA1->(DBSeek(xFilial('SA1')+ZZ4O->(ZZ4_CODCLI + ZZ4_LOJA)))
	
	//**********************************************
	//          Geracao dos ITENS                  *
	//**********************************************
	cItens:='01'
	_lvprcval  = .t.
	cNumOS:=""                                                                         
   dbSelectArea('ZZJ')                    
	IF ZZJ->(DBSeek(xFilial('ZZJ')+alltrim(ZZ4O->ZZ4_OPEBGH)))
	       _clab      := ZZJ->ZZJ_LAB    // cria variavel do Laboratorio - Edson Rodrigues - 13/04/10
 	       _lvdaprod  :=U_VLDPROD(coperbgh,_clab) //Valida operações para chamar que envolpe Ordem Produção. Edson Rodrigues 13/04/10          
 	       carmproc  :=ZZJ->ZZJ_ALMEP
		   cprefixpa :=ALLTRIM(ZZJ->ZZJ_PREFPA)  
           carmpeca  :=ZZJ->ZZJ_ALMEP                              
		   carmpacab :=ZZJ->ZZJ_ALMPRO
		   cmovprod  :=ZZJ->ZZJ_CODPRO
		   cmovcons  :=ZZJ->ZZJ_CODSF5
		   carmscrap :=ZZJ->ZZJ_ALMSCR
		   coperac   :=ZZJ->ZZJ_OPERA
	       _ccoper   :=ZZJ->ZZJ_CC                          
   Else
	        ApMsgInfo("Não foi encontrado a operacao cadastrada para OS "+ZZ4O->(ZZ4_OS)+" e IMEI "+ALLTRIM(ZZ4O->(ZZ4_IMEI))+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
	        ZZ4O->(dbSkip())
	        loop
	Endif

   
	
	
	WHILE (cChaveOS==ZZ4O->(ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA)) .and.  cItens <> 'ZZ' .and. !ZZ4O->(EOF())
		
		Begin Transaction
		
		//Verifica quantas vezes houve entrada do produto pelo IMEI
		cContVez := 0
		
				
		//IF ZZ4O->ZZ4_OPEBGH='S03'
		 IF _lvdaprod 
	  	   ZZJ->(DBSeek(xFilial('ZZJ')+alltrim(ZZ4O->ZZ4_OPEBGH)))
	  	    carmproc  :=ZZJ->ZZJ_ALMEP
			cprefixpa :=ALLTRIM(ZZJ->ZZJ_PREFPA)  
            carmpeca  :=ZZJ->ZZJ_ALMEP                              
			carmpacab :=ZZJ->ZZJ_ALMPRO
			carmcomp  :=LEFT(ZZJ->ZZJ_ARMENT,2)
			cmovprod  :=ZZJ->ZZJ_CODPRO
			cmovcons  :=ZZJ->ZZJ_CODSF5
		    carmscrap :=ZZJ->ZZJ_ALMSCR
		    coperac   :=ZZJ->ZZJ_OPERA
		    cLAB      :=ZZJ->ZZJ_LAB
		    _ccoper   :=ZZJ->ZZJ_CC                          
 
			ZZ4->(DbSetOrder(1)) //ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
			if ZZ4->(dbSeek(xFilial("ZZ4") + ZZ4O->ZZ4_IMEI))
				While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(ZZ4O->ZZ4_IMEI)
					if ZZ4->ZZ4_NFENR <> ZZ4O->ZZ4_NFENR .and. _lvdaprod //ZZ4->ZZ4_OPEBGH == 'S03'
						cContVez++
					endif
					ZZ4->(dbSkip())
				Enddo
			endif
			
			
			//Faz validação da quantidade e valores entrando + que os ja entraram com a quantiadade e valores da NFE compra - ] Rodrigues 13/01/10
			_cfornsrf  := SUBSTR(ALLTRIM(GETMV('MV_XFORSRF')),1,6)
			_cljforsrf := SUBSTR(ALLTRIM(GETMV('MV_XFORSRF')),7,2)
			_nqtdeSD1  = 0
			_nvalrSD1  = 0
			_nqtdeZZ4  = 0
			_nvalrZZ4  = 0
			
			
			DbSelectArea("SD1") //Documento de entrada - NFE de compra do Produto
			//			DbSetOrder(12)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER  //M.Munhoz - 21/08/2011 - Substituido D1_NUMSER por D1_ITEM
			DbSetOrder(1)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
			If SD1->(DbSeek(xFilial('SD1')+ZZ4O->(ZZ4_NFENR + ZZ4_NFESER)+_cfornsrf+_cljforsrf+ZZ4O->ZZ4_CODPRO))
				While SD1->(!eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC == ZZ4O->ZZ4_NFENR .and. SD1->D1_SERIE == ZZ4O->ZZ4_NFESER ;
					.and. SD1->D1_FORNECE == _cfornsrf   .and. SD1->D1_LOJA == _cljforsrf .and. SD1->D1_COD == ZZ4O->ZZ4_CODPRO
					_nqtdeSD1 += SD1->D1_QUANT
					_nvalrSD1 += SD1->D1_TOTAL
					
					SD1->(dbSkip())
				Enddo
			Endif
			
			DbSelectArea("ZZ4") //Entrada Massiva
			DbSetOrder(3)       // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
			If ZZ4->(DbSeek(xFilial('ZZ4')+ZZ4O->(ZZ4_NFENR + ZZ4_NFESER+ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO)))
				While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFENR == ZZ4O->ZZ4_NFENR .and. ZZ4->ZZ4_NFESER == ZZ4O->ZZ4_NFESER ;
					.and. ZZ4->ZZ4_CODCLI == ZZ4O->ZZ4_CODCLI   .and. ZZ4->ZZ4_LOJA == ZZ4O->ZZ4_LOJA  .and. ZZ4->ZZ4_CODPRO == ZZ4O->ZZ4_CODPRO
					IF ZZ4->ZZ4_STATUS='3'
						_nqtdeZZ4++
						_nvalrZZ4+=ZZ4->ZZ4_VLRUNI
					ENDIF
					ZZ4->(dbSkip())
				Enddo
			Endif
			
			// Se a Quantidade do produto comprado for menor ou igual a quantida já confirmada, ou
			// Se o valor do produto comprado for menor que o valor já confirmado + o valor à confirmar
			// Mensagem, saí do loop.
			IF (_nqtdeSD1 <=  _nqtdeZZ4) .or. (_nvalrSD1 < (_nvalrZZ4+ZZ4O->ZZ4_VLRUNI))
				
				MsgBox(" Não é possível confirmar a entrada do produto/IMEI " + alltrim(ZZ4O->ZZ4_CODPRO)+"/"+alltrim(ZZ4O->ZZ4_IMEI)+ ;
				" A qtde ou valor do mesmo, mais a qtde ou valor já confirmados são maiores que a qtde ou valor do produto correspondente na NFE de compra !" ,;
				" Divergência entre qtde/valor confirmados com qtde/valor da NFE compra - Verificar ")
				_lvprcval:=.f.
			ENDIF
		ELSE
/*          M.Munhoz - 21/08/2011 - Nao eh possivel executar a contagem pelo IMEI no SD1 uma vez que este deixara de ser gravado no SD1.
			if SD1->(dbSeek(xFilial("SD1") + ZZ4O->ZZ4_IMEI))
				
				While SD1->(!eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. alltrim(SD1->D1_NUMSER) == alltrim(ZZ4O->ZZ4_IMEI)
					if SD1->D1_DOC <> ZZ4O->ZZ4_NFENR .and. SD1->D1_TIPO == 'B'
						cContVez++
					endif
					SD1->(dbSkip())
				Enddo
			endif
*/
						
			_nqtdeSD1  = 0
			_nvalrSD1  = 0
			_nqtdeZZ4  = 0
			_nvalrZZ4  = 0
			
			
			DbSelectArea("SD1") //Documento de entrada - NFE de compra do Produto
			SD1->(DbGoTop())
			//			DbSetOrder(12)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER  //M.Munhoz - 21/08/2011 - Substituido D1_NUMSER por D1_ITEM
			SD1->(DbSetOrder(1))       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
			If SD1->(DbSeek(xFilial('SD1')+cChaveOS))
				While SD1->(!eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC == ZZ4O->ZZ4_NFENR .and. SD1->D1_SERIE == ZZ4O->ZZ4_NFESER ;
					.and. SD1->D1_FORNECE == ZZ4O->ZZ4_CODCLI .and. SD1->D1_LOJA == ZZ4O->ZZ4_LOJA 
					_nqtdeSD1 += SD1->D1_QUANT
					_nvalrSD1 += SD1->D1_TOTAL
					
					SD1->(dbSkip())
				Enddo
			Else
				lRet := .F.	
			Endif
			
			If lRet
				DbSelectArea("ZZ4") //Entrada Massiva  
				ZZ4->(DbGoTop())
				ZZ4->(DbSetOrder(3))       // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
				If ZZ4->(DbSeek(xFilial('ZZ4')+ZZ4O->(ZZ4_NFENR + ZZ4_NFESER+ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO)))
					While ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFENR == ZZ4O->ZZ4_NFENR .and. ZZ4->ZZ4_NFESER == ZZ4O->ZZ4_NFESER ;
						.and. ZZ4->ZZ4_CODCLI == ZZ4O->ZZ4_CODCLI   .and. ZZ4->ZZ4_LOJA == ZZ4O->ZZ4_LOJA
						_nqtdeZZ4:= _nqtdeZZ4 + 1
						_nvalrZZ4+=ZZ4->ZZ4_VLRUNI
						
						ZZ4->(dbSkip())
					Enddo
				Endif
				
				// Se a Quantidade do produto comprado for menor ou igual a quantida já confirmada, ou
				// Se o valor do produto comprado for menor que o valor já confirmado + o valor à confirmar
				// Mensagem, saí do loop.
				IF (_nqtdeSD1 #  _nqtdeZZ4) .or. (_nvalrSD1 # _nvalrZZ4)
					
					MsgBox(" Não é possível confirmar a entrada massiva " ; 
					+ " A qtde ou valor da massiva, está diferente da qtde ou valor da NFE de compra !" ,;
					" Divergência entre qtde/valor confirmados com qtde/valor da NFE compra - Verificar ")
					_lvprcval:=.f.
				ENDIF
			
			EndIf
		
		ENDIF		
		
		lRet := .T. 
		
		IF _lvprcval
			
			
			//Chamado Tecnico
			cNrCham:= GetSxeNum('AB1','AB1_NRCHAM')
			RecLock('AB1',.T.)
			AB1->AB1_FILIAL:=xFilial('AB1')
			AB1->AB1_NRCHAM:=cNrCham
			AB1->AB1_CODCLI:=ZZ4O->ZZ4_CODCLI
			AB1->AB1_LOJA  :=ZZ4O->ZZ4_LOJA
			AB1->AB1_EMISSA:= dDataBase
			AB1->AB1_HORA  := Time()
			AB1->AB1_HORAF := Time()
			AB1->AB1_ATEND := cUserName
			AB1->AB1_STATUS:= 'E' //Encerrado
			MsUnLock('AB1')
			ConfirmSX8()
			
			//ORDEM DE SERVICO
			cNumOS:= GetSxeNum('AB6','AB6_NUMOS')
			RecLock('AB6',.T.)
			AB6->AB6_FILIAL :=xFilial('AB6')
			AB6->AB6_NUMOS  := cNumOS
			AB6->AB6_CODCLI :=ZZ4O->ZZ4_CODCLI
			AB6->AB6_LOJA   :=ZZ4O->ZZ4_LOJA
			AB6->AB6_OPER	:=ZZ4O->ZZ4_OPER
			AB6->AB6_EMISSA :=dDataBase
			AB6->AB6_ATEND  :=cUserName
			AB6->AB6_STATUS :='A'
			AB6->AB6_HORA   := TIME()
			AB6->AB6_CONPAG :='001' //A vista
			AB6->AB6_BGHKIT := ZZ4O->ZZ4_KIT
			AB6->AB6_OPER   := ZZ4O->ZZ4_OPER
			AB6->AB6_NumVez := StrZero(cContVez+1,1)
			AB6->AB6_SWAPAN := iif(!empty(ZZ4O->ZZ4_SWANT),"S","N")
			MsUnLock('AB6')
			ConfirmSX8()
			
			SB1->(DBSeek(xFilial('SB1')+ZZ4O->ZZ4_CODPRO))
			//Itens do CHAMADO TECNICO
			RecLock('AB2',.T.)
			AB2->AB2_FILIAL := xFilial('AB2')
			AB2->AB2_NRCHAM := cNrCham
			AB2->AB2_NUMOS  := cNumOS+cItens
			AB2->AB2_STATUS := 'E'
			AB2->AB2_CODCLI := ZZ4O->ZZ4_CODCLI
			AB2->AB2_LOJA   := ZZ4O->ZZ4_LOJA
			AB2->AB2_EMISSA := dDatabase
			AB2->AB2_BXDATA := dDatabase
			AB2->AB2_BXHORA := TIME()
			AB2->AB2_ITEM   := cItens
			AB2->AB2_CODPRO := ZZ4O->ZZ4_CODPRO
			AB2->AB2_NUMSER := ZZ4O->ZZ4_IMEI
			AB2->AB2_TIPO   := '3'      //Ordem de Serviço
			AB2->AB2_CLASSI := '006'    //Box Failure
			AB2->AB2_CODPRB := '000001' //Box Failure
			AB2->AB2_TIPOP  := SB1->B1_TIPOP
			MsUnLock('AB2')
			
			If ZZ4O->ZZ4_OPER == "12"
				dbSelectArea("SD1")
//				dbSetOrder(12)// D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER  // M.Munhoz - 21/08/2011 - Substituido D1_NUMSER por D1_ITEM
				dbSetOrder(1)// D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
				//dbSeek(xFilial("SD1") + ZZ4O->(ZZ4_NFENR + ZZ4_NFESER) + cForn + cLoja + MV_PAR03)
				//alterado o Dbssek, pois as variáveis cforn e cloja nao existem. Edson Rodrigues - 06/05/11
				dbSeek(xFilial("SD1") + ZZ4O->(ZZ4_NFENR + ZZ4_NFESER) + cclient + clojcli + MV_PAR03)

			EndIf

			//Grava Itens da Ordem de Serviço
			RecLock('AB7',.T.)
			AB7->AB7_FILIAL :=xFilial('AB7')
			AB7->AB7_NUMOS  := cNumOS
			AB7->AB7_NRCHAM :=cNrCham+cItens
			AB7->AB7_ITEM   :=cItens
			AB7->AB7_CODCLI := ZZ4O->ZZ4_CODCLI
			AB7->AB7_LOJA   := ZZ4O->ZZ4_LOJA
			AB7->AB7_EMISSA := dDatabase
			AB7->AB7_CODPRO :=ZZ4O->ZZ4_CODPRO
			AB7->AB7_NUMSER :=ZZ4O->ZZ4_IMEI
			AB7->AB7_PRCCOM :=IIf(ZZ4O->ZZ4_OPER == "12", MV_PAR06, 0)
			AB7->AB7_TIPO   :='1'      //
			AB7->AB7_CODPRB :='000001' //Box Failure
			AB7->AB7_NumVez := StrZero(cContVez+1,1)
			AB7->AB7_SWAPAN := ZZ4O->ZZ4_SWANT
			AB7->AB7_CODFAB := ZZ4O->ZZ4_CODCLI
			AB7->AB7_LOJAFA := ZZ4O->ZZ4_LOJA
			MsUnLock('AB7')
			
			//**********************************************
			//          Geracao da Base Instalada          *
			//**********************************************
			dbSelectArea("AA3")
			dbSetOrder(1)
			
			If !(DBSeek(xFilial('AA3')+ZZ4O->(ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI)))
				RecLock('AA3',.T.)
				AA3->AA3_FILIAL := xFilial('AA3')
				AA3->AA3_CODCLI := ZZ4O->ZZ4_CODCLI
				AA3->AA3_LOJA   := ZZ4O->ZZ4_LOJA
				AA3->AA3_CODPRO := ZZ4O->ZZ4_CODPRO
				AA3->AA3_NUMSER := ZZ4O->ZZ4_IMEI
				AA3->AA3_DTVEND := dDataBase
				AA3->AA3_STATUS := '05' //EQUIPAMENTO EM NOSSO PODER
				AA3->AA3_SIM    := ZZ4O->ZZ4_CARCAC //SIM/Caraça
				AA3->AA3_CODFAB := ZZ4O->ZZ4_CODCLI
				AA3->AA3_LOJAFA := ZZ4O->ZZ4_LOJA
				MsUnLock('AA3')
			Endif
			
			
			//**********************************************
			// Gera OP Operacao Refurbish Sony             *
			//**********************************************
			//IF ZZ4O->ZZ4_OPEBGH ='S03'
			IF _lvdaprod
				_ageraop:={}
				lInclui:=.t.
			   /*
				carmpacab :=GetMV("MV_ARMACAB")
				carmproc  :=GetMV("MV_ARMPROC")
				cmovprod  :=GetMV("MV_MOVPROD")
				clotesub  :=GetMV("MV_LOTESUB")
				*/
								
				//_cnewpro :=ALLTRIM(LEFT(ZZ4O->ZZ4_CODPRO,13))+'-R'
				_cnewpro:=IIF(left(ZZ4O->ZZ4_CODPRO,3)=="DPY",cprefixpa+substr(alltrim(ZZ4O->ZZ4_CODPRO),4,12),cprefixpa+alltrim(ZZ4O->ZZ4_CODPRO))
				_cnewpro:=Alltrim(_cnewpro)+SPACE(nTcodpr-len(_cnewpro))
				IF !SB2->(DBSeek(xFilial('SB2')+_cnewpro+carmproc))
					U_saldoini(_cnewpro,carmproc,.T.)
				ENDIF  
				
				
				
				AADD(_ageraop,cNumOS)
				AADD(_ageraop,cItens)
				AADD(_ageraop,"001")
				AADD(_ageraop,_cnewpro)
				AADD(_ageraop,alltrim(carmproc))
				AADD(_ageraop,alltrim(_ccoper))
				AADD(_ageraop,1)
				AADD(_ageraop,SB1->B1_UM)
				
				
				_lgeraop:=tecx013c(_ageraop,lInclui,ZZ4O->ZZ4_NFENR,ZZ4O->ZZ4_NFESER,ZZ4O->ZZ4_CODCLI,ZZ4O->ZZ4_LOJA,ZZ4O->ZZ4_CODPRO,ZZ4O->ZZ4_IMEI,cNumOS,carmproc,carmpacab,carmscrap,carmpeca,cmovcons,coperac,cLAB,@_amovint,carmcomp,_ccoper)

	         
			ENDIF
			
			
			
			
			
			
			//**********************************************
			//          Flags da Entrada Massiva           *
			//**********************************************
			DbSelectArea("ZZ4")
			ZZ4->(dbGoTo(ZZ4O->R_E_C_N_O_))
			RECLOCK("ZZ4",.F.)
			ZZ4->ZZ4_OS := CNUMOS
			ZZ4->ZZ4_STATUS := IIF(_LVDAPROD .AND. _LGERAOP, "3", ZZ4O->ZZ4_STATUS)
			MSUNLOCK("ZZ4")
/*
			DbSelectArea("ZZ4")
			ZZ4->(dbGoTo(ZZ4O->R_E_C_N_O_))
			RecLock('ZZ4',.F.)
			ZZ4->ZZ4_OS	   := cNumOS
			ZZ4->ZZ4_STATUS := IIF(_lvdaprod .AND. _lgeraop,'3',ZZ4O->ZZ4_STATUS)   /*ZZ4O->ZZ4_OPEBGH ='S03'
			MsUnLock('ZZ4')
*/
		ELSE	
		// ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
          _aOSIMEI:={}
          AADD(_aOSIMEI,{ALLTRIM(ZZ4O->ZZ4_IMEI)+ALLTRIM(ZZ4O->ZZ4_OS)})
		  UPDZZ4(1,ZZ4O->ZZ4_NFENR,ZZ4O->ZZ4_NFESER,ZZ4O->ZZ4_CODCLI,ZZ4O->ZZ4_LOJA,ZZ4O->ZZ4_CODPRO,ZZ4O->ZZ4_IMEI,1,"",carmproc,coperac,_aOSIMEI,_ccoper)

		ENDIF
		
		ZZ4O->(DBSkip())  
		
		
		_cUpdZZ3 := " UPDATE "+RETSQLNAME("ZZ3")+" SET ZZ3_NUMOS = '"+cNumOS+"' "
		_cUpdZZ3 += " WHERE  D_E_L_E_T_ = '' AND ZZ3_NUMOS = '' AND ZZ3_FILIAL = '"+ZZ4->ZZ4_FILIAL+"' AND "
		_cUpdZZ3 += "        ZZ3_IMEI = '"+ZZ4->ZZ4_IMEI+"' AND ZZ3_DATA >= '"+DTOC(ZZ4->ZZ4_DOCDTE)+"' "
		tcSqlExec(_cUpdZZ3)  
		TCREFRESH(RETSQLNAME("ZZ3"))                              
				
		IncProc()
		nITCham++
		End Transaction
		
	EndDo
	
	//*******************************************************************
	// Faz transferencia de armazém Operacao Refurbish Sony             *
	//*******************************************************************
	IF _lvdaprod   //coperbgh ='S03'
      DbSelectArea("ZZ4") //Entrada Massiva
		DbSetOrder(3)       // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
 
      If len(_amovint) > 0
       aSort(_amovint,,,{|x,y| x[1] < y[1]}) // Orderna por produto os IMEIS selecionados . - Edson Rodrigue - 22/04/2010
       cmovProd:=""
       FOR X:=1 to len(_amovint)
           IF cmovProd<>_amovint[x][1] 
              cmovProd:=_amovint[x][1]
              tecx013b(_amovint[x][8],_amovint[x][9],_amovint[x][10],_amovint[x][11],carmproc,carmpacab,carmscrap,carmpeca,cmovprod,coperac,cLAB,cprefixpa,carmcomp,_amovint[x][1],_amovint[x][12],_amovint[x][4],_amovint[x][14])
           END 
	    NEXT 
	    
	    For x:=1 to len(_amovint)
             IF ZZ4->(DbSeek(xFilial('ZZ4')+_amovint[x][8] + _amovint[x][9]+_amovint[x][10] + _amovint[x][11] + _amovint[x][1]+ _amovint[x][12]))
				   WHILE !ZZ4->(EOF()) .AND. ZZ4->ZZ4_FILIAL=xFilial('ZZ4') .AND. ZZ4->ZZ4_NFENR=_amovint[x][8] .AND. ZZ4->ZZ4_NFESER=_amovint[x][9]  .AND. ZZ4->ZZ4_CODCLI=_amovint[x][10] .AND. ;
				          ZZ4->ZZ4_LOJA=_amovint[x][11] .AND. ZZ4->ZZ4_CODPRO=_amovint[x][1]  .AND. ZZ4->ZZ4_IMEI=_amovint[x][12]
						    IF ZZ4->ZZ4_STATUS='3'                         
						       IF !SB2->(DBSeek(xFilial('SB2')+_amovint[x][1]+_amovint[x][2]))
					               U_saldoini(_amovint[x][1],alltrim(_amovint[x][2]),.T.)
		                       ENDIF
		                   IF  SB2->(DBSeek(xFilial('SB2')+_amovint[x][1]+_amovint[x][2]))
		                       nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)    
		                       If  _amovint[x][3] > nSalb2
		                             apMsgStop("Nao e possível fazer a mov. interna do para o produto : "+alltrim(_amovint[x][1])+" Qtde a movimentar maior que saldo disponivel no armazem de processamento: "+alltrim(_amovint[x][2])+ ". Favor verificar ")
		                       Else   
		                            U_REQ_EST(1,_amovint[x][1],_amovint[x][2],_amovint[x][3],_amovint[x][4],_amovint[x][5],_amovint[x][6],_amovint[x][7],NIL,NIL,_lvdaprod,_amovint[x][4],ALLTRIM(_amovint[x][14]))
                                    NMODULO:=28
                               		CMODULO:="TEC"
					              ENDIF
					          ELSE
					             apMsgStop("Nao e possível fazer a mov. interna do para o produto : "+alltrim(_amovint[x][1])+" Nao foi encontrado o produto: "+alltrim(_amovint[x][1])+ " cadastrado no armazem de processamento : "+alltrim(_amovint[x][2])+ ". Favor verificar ")
					          ENDIF           
					       ENDIF
					   ZZ4->(DBSKIP())
					ENDDO       
				Endif
         Next
      Endif
   ENDIF
	
EndDo

//IF nOS==0
//	Aviso('Ordens de Serviço','Nenhuma Ordem de Serviço foi gerada!',{'OK'})
//ELSE
//	_cNota := iif(nOS == 1, " Nota Fiscal ", " Notas Fiscais ")
//	Aviso('Ordens de Serviço','Foram geradas '+AllTrim(Str(nITCham))+' atividades, a partir de '+AllTrim(Str(nOS)) + _cNota,{'OK'})
//endif

U_RESTAMB( aAmb )

DBSELECTAREA( cAlias )

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECAX013bºAutor  ³Edson Rodrigues     º Data ³  10/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz transferencia de armazem da entrada massiva            º±±
±±º          ³ Para o projeto Refurbish Sony Ericson                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Field Service - BGH                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function tecx013b(cnf,cserie,cclie,cloja,carmproc,carmpacab,carmscrap,carmpeca,cmovprod,coperac,cLAB,cprefixpa,carmcomp,cprod,cimei,cos,_ccoper)
Local _cQuery   := ""
Local _atransp  :={}
Local _aOSIMEI  :={}
Local _Ncount   :=0
Local _cdocto   :=Space(nTdocD3)
Local _cnewpro  := ""
Local lInclui   := .T.
Local ltransf   := .T.                                         
Local _lgertrans:=.T.
Local _lok      :=.F.
Local clotesub  :=GetMV("MV_LOTESUB") 
Local nSaltran  := 0.00
Local _nqtde    := 0.00
Local _ctranprd := ""
Local cAlias  := ALIAS(),;
aAlias := {"SD1","SD3","SB1","SB2","AA3","AB1","AB2","AB6","AB7"},;
aAmb   := U_GETAMB( aAlias )
_atransp :={}
/*
Local carmcomp := GetMV("MV_ARMCOMP")
Local carmpeca  :=GetMV("MV_ARMLPEC")
Local carmpacab :=GetMV("MV_ARMACAB")
Local carmproc  :=GetMV("MV_ARMPROC")
Local cmovprod  :=GetMV("MV_MOVPROD")
*/



if select("ZZ4P") > 0
	ZZ4P->(dbCloseArea())
endif

_cQuery := " SELECT ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI,COUNT(ZZ4_CODPRO) AS QTDPRO "
_cQuery += " FROM   "+RetSqlName("ZZ4") + " (nolock) "
_cQuery += " WHERE  ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND "
_cQuery += "        ZZ4_NFENR  = '"+cnf+"'    AND "
_cQuery += "        ZZ4_NFESER = '"+cserie+"' AND "
_cQuery += "        ZZ4_CODCLI = '"+cclie+"'  AND "
_cQuery += "        ZZ4_LOJA   = '"+cloja+"'  AND "
_cQuery += "        ZZ4_CODPRO = '"+cprod+"'  AND "
//_cQuery += "        ZZ4_IMEI   = '"+cimei+"'  AND "
_cQuery += "        ZZ4_STATUS = '3' AND "
_cQuery += "        D_E_L_E_T_ = ''  AND "                               
_cQuery += "        ZZ4_OPEBGH = '"+coperac+"'  AND "
_cQuery += "        UPPER(ZZ4_EMUSER) = '"+Upper(Alltrim(cUserName))+"' "
_cQuery += " GROUP BY ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI "
_cQuery += " ORDER BY ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI "

TCQUERY _cQuery NEW ALIAS "ZZ4P"

While !ZZ4P->(EOF())
	_nqtde   :=_nqtde+ZZ4P->QTDPRO
    AADD(_aOSIMEI,{ALLTRIM(ZZ4P->ZZ4_IMEI)+ALLTRIM(ZZ4P->ZZ4_OS)})
   ZZ4P->(DBSKIP())	
Enddo


   /*
	If left(cnf,5)='00000'                     
	   _cdocto := substr(cnf,6,1)+STRZERO(_ncount,5)
	Elseif left(cnf,4)='0000'
	   _cdocto := substr(cnf,5,2)+STRZERO(_ncount,4)
	Elseif left(cnf,3)='000'                    
	   _cdocto := substr(cnf,4,3)+STRZERO(_ncount,3)
	Elseif left(cnf,2)='00'                      
	   _cdocto := substr(cnf,3,4)+STRZERO(_ncount,2)
	Else 
	   _cdocto := substr(cnf,1,4)+STRZERO(_ncount,2)
	Endif     
	*/               
ZZ4P->(DBGoTop())	
While !ZZ4P->(EOF())

   If _ctranprd<>ZZ4P->ZZ4_CODPRO
      _ctranprd:=ZZ4P->ZZ4_CODPRO
  	   _cdocto  :=RIGHT(alltrim(cnf),nTdocD3)   
  	   _cdocto  :=alltrim(_cdocto)+space(nTdocD3-len(alltrim(_cdocto)))
	   _cnewpro:=IIF(left(ZZ4P->ZZ4_CODPRO,3)=="DPY",cprefixpa+substr(alltrim(ZZ4P->ZZ4_CODPRO),4,12),cprefixpa+alltrim(ZZ4P->ZZ4_CODPRO))
	   _cnewpro:=Alltrim(_cnewpro)+SPACE(nTcodpr-len(_cnewpro))
	   _cprod  :=Alltrim(ZZ4P->ZZ4_CODPRO)+SPACE(nTcodpr-len(ALLTRIM(ZZ4P->ZZ4_CODPRO)))
	   lInclui  :=.T.
	 	
	 	IF SB1->(DBSeek(xFilial('SB1')+_cprod))
		
		    IF !SB2->(DBSeek(xFilial('SB2')+_cprod+carmproc))
			    U_saldoini(_cprod,alltrim(carmproc),.T.)
		    ENDIF
		    
		    IF  SB2->(DBSeek(xFilial('SB2')+_cprod+carmcomp))
		        NMODULO:=04
                CMODULO:="EST"
		        nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)    
		        If  nSalb2 < _nqtde
		          If nSalb2 <=0.00 
		            apMsgStop("Nao sera possível fazer a transferencia do armaz origem:"+carmcomp+ " para o armaz destino: "+carmproc+ " do produto : "+alltrim(_cprod)+". Nao ha saldo no armazem origem "+carmcomp+ ". Favor verificar ")
		            NMODULO:=28
		            CMODULO:="TEC"
		            UPDZZ4(2,cnf,cserie,cclie,cloja,_cprod,ZZ4P->ZZ4_IMEI,_nqtde,_cnewpro,carmproc,coperac,_aOSIMEI,_ccoper)
		          Else
		             U_SRAdtrans(_cprod,carmcomp,_cdocto,_cprod,alltrim(carmproc),@_atransp,@ltransf,@lInclui,@_lgertrans,0,0,nSalb2)  
		            IF !ltransf
			             apMsgStop("Nao foi possível fazer a transferencia do armaz origem:"+carmcomp+ " para o armaz destino: "+carmproc+ " do produto : "+alltrim(_cprod)+" Favor verificar. Duvidas Contate o administrador do sistema")
  	                     NMODULO:=28
		                 CMODULO:="TEC"
  	                     UPDZZ4(2,cnf,cserie,cclie,cloja,_cprod,ZZ4P->ZZ4_IMEI,_nqtde,_cnewpro,carmproc,coperac,_aOSIMEI,_ccoper)
  	                 Else
  	                   nrest:=_nqtde-nSalb2
  	                   apMsgStop("foi Transferido do armaz origem:"+carmcomp+ " para o armaz destino: "+carmproc+ " do produto : "+_cprod+" somente a quantidade de "+strzero(nSalb2,3)+". O restante de "+strzero(nrest,3)+" ficou sem transferir por insuficiencia de saldo no armazem origem.  Favor verificar")
  	                   NMODULO:=28
		               CMODULO:="TEC"
  	                   UPDZZ4(3,cnf,cserie,cclie,cloja,_cprod,ZZ4P->ZZ4_IMEI,nrest,_cnewpro,carmproc,coperac,_aOSIMEI,_ccoper)
  	                 Endif
		          Endif   
		        Else
		              U_SRAdtrans(_cprod,carmcomp,_cdocto,_cprod,alltrim(carmproc),@_atransp,@ltransf,@lInclui,@_lgertrans,0,0,_nqtde)  
		              IF !ltransf
			             apMsgStop("Nao foi possível fazer a transferencia do armaz origem:"+carmcomp+ " para o armaz destino: "+carmproc+ " do produto : "+alltrim(_cprod)+" Favor verificar. Duvidas Contate o administrador do sistema")
			             NMODULO:=28
		                 CMODULO:="TEC"
			             UPDZZ4(2,cnf,cserie,cclie,cloja,_cprod,ZZ4P->ZZ4_IMEI,_nqtde,_cnewpro,carmproc,coperac,_aOSIMEI,_ccoper)
  	                 Endif              
  	                 NMODULO:=28
		             CMODULO:="TEC"
              Endif
		    Else   
		        apMsgStop("Nao foi possível fazer a transferencia do armaz origem:"+carmcomp+ " para o armaz destino: "+carmproc+ " do produto : "+alltrim(_cprod)+" Nao foi encontrado o produto cadastrado no armaz destino : "+carmproc+ ". Favor verificar.")
		         NMODULO:=28
		         CMODULO:="TEC"		     
		        UPDZZ4(2,cnf,cserie,cclie,cloja,_cprod,ZZ4P->ZZ4_IMEI,_nqtde,_cnewpro,carmproc,coperac,_aOSIMEI,_ccoper)
		    ENDIF         
	   Endif	
		/*
		AADD(_atransp,_cprod)
		AADD(_atransp,carmcomp)
		AADD(_atransp,ZZ4P->QTDPRO)
		AADD(_atransp,_cdocto)
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,_cprod)
		AADD(_atransp,alltrim(carmproc))
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'' )
		
	ENDIF
	
	// Begin Transaction
	IF Len(_atransp) > 0
		NMODULO:=04
		CMODULO:="EST"
		ltransf:=U_BGHOP004(_atransp,lInclui)
		NMODULO:=28
		CMODULO:="TEC"
	ENDIF
	// End Transaction
	*/          
	Endif
	   
	ZZ4P->(DBSkip())
	_atransp :={}
	_ncount++
ENDDO
U_RESTAMB(aAmb)
DBSELECTAREA( cAlias )
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECAX013cºAutor  ³Edson Rodrigues     º Data ³  11/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Ordem de Produção                                     º±±
±±º          ³ Para o projeto Refurbish Sony Ericson                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Field Service - BGH                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function tecx013c(_ageraop,lInclui,cnfnr,cnfser,cclient,cloja,cprod,cimei,cnumos,carmproc,carmpacab,carmscrap,carmpeca,cmovcons,coperac,cLAB,_amovint,carmcomp,_ccoper)
Local lretop  :=.t.
Local lretemp :=.t.                
Local	_lgeraemp := .t.  
Local _lempenh :=.t.
Local cAlias  := ALIAS(),;
aAlias := {"SD1","AA3","AB1","AB2","AB6","AB7"},;
aAmb   := U_GETAMB( aAlias )
local _aEmpenh:={}
Local clotesub  :=GetMV("MV_LOTESUB")
Local cprodmob := ALLTRIM(GetMV("MV_PMOBSRF"))+SPACE(nTcodpr-LEN(ALLTRIM(GetMV("MV_PMOBSRF"))))

/*
Local carmpeca  :=GetMV("MV_ARMLPEC")
Local carmpacab :=GetMV("MV_ARMACAB")
Local carmproc  :=GetMV("MV_ARMPROC")
Local cmovprod  :=GetMV("MV_MOVPROD")
*/
lvdadreq:=U_VLDDREQ(coperac,cLAB) //Valida operações para chamar a função de inserção de requisição. Edson Rodrigues 24/03
NMODULO:=04
CMODULO:="EST"
lretop:= U_BGHOP001(_ageraop,lInclui)


IF lretop
	for X:=1 to IIF(empty(cprodmob),1,2)
		
		IF !SB2->(DBSeek(xFilial('SB2')+iif(x==1,cprod,cprodmob)+carmproc))
			U_saldoini(iif(x==1,cprod,cprodmob),carmproc,.T.)
		ENDIF
		IF lretemp
			/*
			_aEmpenh:={}
			AADD(_aEmpenh,IIF(X==1,cprod,cprodmob))
			AADD(_aEmpenh,alltrim(carmproc))
			AADD(_aEmpenh,left(cnumos,6)+'01001')
			AADD(_aEmpenh,dDatabase)
			AADD(_aEmpenh,1)
			AADD(_aEmpenh,1)
			AADD(_aEmpenh,nil)
			AADD(_aEmpenh,nil)
			lretemp := U_BGHOP002(_aEmpenh,lInclui)
			*/
			//Retirada a funcao de empenho para os produtos e adicionada função de movimentacao de interna amarrada a OP - Edson Rodrigues
			//U_SRAdEmp(IIF(X==1,cprod,cprodmob),alltrim(carmproc),left(cnumos,6)+'01001',1,1,"","",@_aEmpenh,@ lInclui,@_lempenh,@_lgeraemp)
         if lvdadreq 
            AADD(_amovint,{IIF(X==1,cprod,cprodmob),alltrim(carmproc),1,left(cnumos,6)+'01001',DATE(),,cmovcons,cnfnr,cnfser,cclient,cloja,cimei,carmcomp,_ccoper})
         Endif
			
		ENDIF
	Next
ENDIF


NMODULO:=28
CMODULO:="TEC"
U_RESTAMB(aAmb)
DBSELECTAREA( cAlias )
Return(_lempenh)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UPDZZ4   ºAutor  ³Edson Rodrigues     º Data ³  22/04/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o status do aparelho como lido quando o mesmo      º±±
±±º          ³ e de operacao de producao e nao passou nas validacoes      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Field Service - BGH                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function updzz4(_nopc,_cnfe,_cserie,_cclient,_cloja,_ccodpro,_cimei,ncount,_cnewpro,carmproc,coperac,_aOSIMEI,_ccoper)

Local _cselZZ4 := ""
Local _cUpdZZ4 := ""
Local _cNumOs  := ""
Local _cNrOS   := ""            
Local cItens   :='01'                  
lOCAL lInclui  :=.F.
Local nSeek    := 0

AB6->(dbSetOrder(1))  // AB6_FILIAL + AB6_NUMOS
AB7->(dbSetOrder(1))  // AB7_FILIAL + AB7_NUMOS + AB7_ITEM
AB2->(dbSetOrder(6))  // AB2_FILIAL + AB2_NUMOS
SB1->(dbSetOrder(1))  // B1_FILIAL + B1_COD

     If select("SELZZ4") > 0
	    SELZZ4->(dbCloseArea())
     Endif

     //IF _nopc==3              
     //   _cselZZ4 := " SELECT TOP "+ncount+" ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI "
     //ELSE
        _cselZZ4 := " SELECT ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI "
     //ENDIF       
        _cselZZ4 += " FROM  "+RETSQLNAME("ZZ4")+"  "
        _cselZZ4 += " WHERE  ZZ4_FILIAL = '"+xFilial('ZZ4')+"' AND ZZ4_NFENR='"+_cnfe+"' AND ZZ4_NFESER='"+_cserie+"' AND "
	    _cselZZ4 += "        ZZ4_CODCLI = '"+_cclient+"' AND ZZ4_LOJA ='"+_cloja+"'  AND ZZ4_CODPRO='"+_ccodpro+"' AND "
	 IF _nopc==1
		_cselZZ4 += " ZZ4_IMEI = '"+_cimei+"' AND "
	 ENDIF     
		_cselZZ4 += " D_E_L_E_T_='' AND  ZZ4_OPEBGH = '"+coperac+"'  AND "
        _cselZZ4 += " UPPER(ZZ4_EMUSER) = '"+Upper(Alltrim(cUserName))+"'  "

	    TCREFRESH(RETSQLNAME("ZZ4"))          
        TCQUERY _cselZZ4 NEW ALIAS "SELZZ4"

     
     SELZZ4->(dbgotop())
     While !SELZZ4->(EOF())
        
        If Len(_aOSIMEI) > 0
           nSeek := Ascan(_aOSIMEI, { |x| x[1] == ALLTRIM(SELZZ4->ZZ4_IMEI)+ALLTRIM(SELZZ4->ZZ4_OS)})
           ncount:=ncount-1
        Endif   
        
       
        IF _nopc==1 .or. ( nSeek > 0 .and. ncount >= 0)                                     
        
           _cUpdZZ4 := " UPDATE "+RETSQLNAME("ZZ4")+" "
           _cUpdZZ4 += " SET ZZ4_STATUS = '1' ,ZZ4_OS='' "
           _cUpdZZ4 += " WHERE  ZZ4_FILIAL = '"+xFilial('ZZ4')+"' AND ZZ4_NFENR='"+_cnfe+"' AND ZZ4_NFESER='"+_cserie+"' AND "
		   _cUpdZZ4 += "        ZZ4_CODCLI = '"+_cclient+"' AND ZZ4_LOJA ='"+_cloja+"'  AND ZZ4_CODPRO='"+_ccodpro+"' AND "
		   _cUpdZZ4 += "        ZZ4_IMEI = '"+SELZZ4->ZZ4_IMEI+"' AND ZZ4_OS = '"+SELZZ4->ZZ4_OS+"' "
		   _cUpdZZ4 += "        AND D_E_L_E_T_='' AND ZZ4_OPEBGH = '"+coperac+"'  AND "
           _cUpdZZ4 += "        UPPER(ZZ4_EMUSER) = '"+Upper(Alltrim(cUserName))+"'  "

           tcSqlExec(_cUpdZZ4)  
		   TCREFRESH(RETSQLNAME("ZZ4"))                             
		                                                     
           //Pega o numero da OS
		   _cNumOs := alltrim(SELZZ4->ZZ4_OS)
		   _ageraop :={}
		   		
		   IF _nopc <> 1                           
		 
              SB1->(dbSeek(xFilial("SB1")+_cnewpro))
		 
		      AADD(_ageraop,_cNumOs)
		      AADD(_ageraop,cItens)
		      AADD(_ageraop,"001")
		      AADD(_ageraop,_cnewpro)
		      AADD(_ageraop,alltrim(carmproc))
		      AADD(_ageraop,alltrim(_ccoper))
		      AADD(_ageraop,1)
		      AADD(_ageraop,SB1->B1_UM)
		
		      U_BGHOP001(_ageraop,lInclui)
              NMODULO:=28
              MODULO:="TEC"
		  
		      If AB6->(dbSeek(xFilial("AB6")+_cNumOs))
			       If AB7->(dbSeek(xFilial("AB7")+AB6->AB6_NUMOS))
						
				         // Passa por todos os itens da OS (geralmente devera existir apenas 1 item por OS)
				         While AB7->(!eof()) .and. AB7->AB7_FILIAL == xFilial("AB7") .and. AB6->AB6_NUMOS == AB7->AB7_NUMOS
					        _cNrOS := AB7->AB7_NUMOS + AB7->AB7_ITEM
							
						    // Posiciona e deleta o item do chamado tecnico
						    If AB2->(dbSeek(xFilial("AB2")+_cNrOS))
								_cNrCham := AB2->AB2_NRCHAM
								Reclock("AB2",.F.)
								DbDelete()
								MsUnlock()
						    EndIf
						
						    // Deleta o item da OS
						    RecLock("AB7",.F.)
							 DbDelete()
						    AB7->(MsUnLock())
				          AB7->(DbSkip())
			             EndDo
						
			             // Posiciona e deleta o cabecalho do chamado tecnico
					     AB1->(dbSetOrder(1))  // AB1_FILIAL + AB1_NRCHAM
					     if AB1->(dbSeek(xFilial("AB1")+_cNrCham))
						    RecLock("AB1",.F.)
						       DbDelete()
						    AB1->(MsUnLock())
					     EndIf
						
			       EndIf
			  Endif		
			  // Deleta o cabecalho da OS
			  Reclock("AB6",.F.)
					DbDelete()
			  AB6->(MsUnLock())
	       EndIf              
	   	Endif 
	    SELZZ4->(DBSKIP())  
     ENDDO		
return
