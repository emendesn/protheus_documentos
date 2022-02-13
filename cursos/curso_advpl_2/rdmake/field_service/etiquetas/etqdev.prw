#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH" 
#include 'TOPCONN.ch' 
#INCLUDE "Fileio.ch"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ETQDEV³ 	  Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ETQDEV()
               
Local oDlg     		:= Nil
Local oGet     		:= Nil
Local nOpcao        := 0 
Local _aRetGroup	:= {}
Local _lUser		:= .F.

Private nOpca 		:= 0
Private _cMsg	  	:= "Usuario sem acesso. Entre em contato com o Administrador!" 
Private cLogError	:= ""
Private cType 		:= "Planilha XLSX (*.XLSX) | *.XLSX | "
Private cArq		:= "" 
Private cFile		:= ""

DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Importação de Peças em Tabela de Preços já existente.") PIXEL
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi("Esta rotina efetua a impressão de etiquetas para os correios") SIZE 268, 8 OF oDlg PIXEL
@ 38, 15 SAY OemToAnsi("utilizando os itens existentes na planilha.") SIZE 268, 8 OF oDlg PIXEL
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	MsAguarde({|| ImpPRC()},OemtoAnsi("Processando itens da Planilha"))
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpPRC  ³ Autor ³ DeltaDecisao          ³ Data ³ 29/03/11  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 												               ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpPRC()

Local cCamDLL      		:= Getmv("BH_DLLEXCE",.F.,"\\172.16.0.5\Microsiga\protheus_data\dll\readexcel.dll") 
Local nHdl	 	   		:= ExecInDLLOpen(cCamDLL)
Local cBuffer			:= ""

Private _aCelulas		:= {}
Private aEtq 			:= {}
Private aLista			:= {}

cFile := cGetFile(cType,OemToAnsi("Selecione o arquivo a ser importado"),0,,.F.,GETF_LOCALHARD,.F.,.F.) 

// Montagem das Celulas   
AADD(_aCelulas,{'NOME        ',"A",2,'C',50,0}) 
AADD(_aCelulas,{'LOGRADOURO  ',"B",2,'C',50,0})
AADD(_aCelulas,{'ENDERECO    ',"C",2,'C',50,0})  
AADD(_aCelulas,{'NUMERO      ',"D",2,'C',50,0})                                                     
AADD(_aCelulas,{'BAIRRO      ',"E",2,'C',50,0})
AADD(_aCelulas,{'CEP         ',"F",2,'C',50,0}) 
AADD(_aCelulas,{'CIDADE      ',"G",2,'C',50,0})  
AADD(_aCelulas,{'ESTADO      ',"H",2,'C',50,0}) 

// Verifica se Conseguiu efetuar a Abertura do Arquivo
If ( nHdl >= 0 )
	
	// Carrega o Excel e Abre o arquivo
	cBuffer := cFile + Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
	If ( nBytes < 0 )
		// Erro critico na abertura do arquivo sem msg de erro
		MsgStop('Não foi possível abrir o arquivo : ' + cFile)
		Return
	ElseIf ( nBytes > 0 )
		// Erro critico na abertura do arquivo com msg de erro
		MsgStop(Subs(cBuffer, 1, nBytes))
		Return
	EndIf
	
	// Seleciona a worksheet
	cBuffer := "SIGEP" + Space(512)
	ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)
	_nSomaLin	:= 0
	
	For _nElemx		:= 1 To 600
		
		MsProcTxt("Proc.Registro: "+StrZero(_nElemx,6))
				
		cNome	  := Alltrim(VERDADOS(nHdl,'_aCelulas',01,_nSomaLin))	
		cLogr	  := Alltrim(VERDADOS(nHdl,'_aCelulas',02,_nSomaLin))	
		cEnder    := Alltrim(VERDADOS(nHdl,'_aCelulas',03,_nSomaLin))
		cNum	  := Alltrim(VERDADOS(nHdl,'_aCelulas',04,_nSomaLin))
		cBairro   := Alltrim(VERDADOS(nHdl,'_aCelulas',05,_nSomaLin))
		cCEP      := Alltrim(VERDADOS(nHdl,'_aCelulas',06,_nSomaLin))
		cCidade   := Alltrim(VERDADOS(nHdl,'_aCelulas',07,_nSomaLin))
		cEstado   := Alltrim(VERDADOS(nHdl,'_aCelulas',08,_nSomaLin)) 
		
		If Empty(cNome) 
			Exit
		EndIf	  
		
		aEtq := {}		
		AADD(aEtq,cNome)
		If Empty(cLogr)
			AADD(aEtq,cEnder+", "+cNum)
		Else
			AADD(aEtq,cLogr+" "+cEnder+", "+cNum)
		EndIf 
		AADD(aEtq,cBairro)
		AADD(aEtq,cCEP)
		AADD(aEtq,cCidade)
		AADD(aEtq,cEstado)
		
		If 	len(aEtq) > 0
			Processa({|| ImpETQ() },"Efetuando importação...")
		Endif
		
		_nSomaLin++
	Next _nElemx
	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	
Else
	MsgStop('Nao foi possivel carregar a DLL')
EndIf

AtuTabObj(aLista)

LiPost(aLista)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VERDADOS   ºAutor  ³Delta Decisao      º Data ³  21/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o Conteudo de Uma celula na planilha Excel         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VERDADOS(_nArq,_cMatriz,_nElemento,_nSoma,_lExtrai)

Local _cRetorno	:= ''
Local _cBufferPl:= ''
Local _nBytesPl	:= 0
Local _cCelula	:=''
Local _cDescCam	:=''
Local _cColuna	:=''
Local _cLinha	:=''
Local _cTipo	:=''
Local _cTamanho	:=''
Local _cDecimal	:=''
Local _cString	:=''

If _lExtrai == Nil
	_lExtrai := .F.
Endif
_cDescCam		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",1]"
_cColuna		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",2]"
_cLinha			:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",3]"
_cTipo   		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",4]"
_cTamanho		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",5]"
_cDecimal		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",6]"

_cDescCam		:= &_cDescCam
_cColuna		:= &_cColuna
_cLinha			:= Alltrim(Str(&_cLinha+_nSoma))
_cTipo   		:= Upper(&_cTipo)
_cTamanho		:= &_cTamanho
_cDecimal		:= &_cDecimal
_cCelula		:= _cColuna+_cLinha

// Efetua Leitura da Planilha
_cBufferPl := _cCelula + Space(1024)
_nBytesPl  := ExeDLLRun2(_nArq, CMD_READCELL, @_cBufferPl)
_cRetorno  := Subs(_cBufferPl, 1, _nBytesPl)
_cRetorno  := Alltrim(_cRetorno)

// Realiza tratamento do campo  de acordo com o Tipo

If _cTipo =='N' // Numerico
	_cString	:=''
	_cNewRet :=''
	For _nElem	:= 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElem,1)
		If _cString ==','
			_cString :='.'
		Endif
		_cNewRet	:=Alltrim(_cNewRet)+_cString
	Next _nElem
	_cNewRet		:= Val(_cNewRet)
	_cRetorno    := Round(_cNewRet,_cDecimal)
Endif

If _cTipo =='D' // Data 21/01/2006
	_cRetorno 	:= Alltrim(_cRetorno)
	_cNewRet 	:= Left(_cRetorno,6)+Right(_cRetorno,2)
	_cRetorno    := CtoD(_cNewRet)
Endif

If _cTipo =='C' .AND. _lExtrai // Caracter e extraçào de caracteres
	_cString	:=''
	_cNewRet :=''
	For _nElem	:= 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElem,1)
		If _cString $ '#/#,#.#-'
			Loop
		Endif
		_cNewRet	:=Alltrim(_cNewRet)+_cString
	Next _nElem
	_cRetorno    := _cNewRet
Endif

// Ajusta O Tamanho da variavel

If _cTipo =='C'
	_cRetorno := Alltrim(_cRetorno)
	_cRetorno := _cRetorno+Space(_cTamanho-Len(_cRetorno))
Endif

Return _cRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpSC6 ºAutor  ³Vinicius Leonardo		 º Data ³  29/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua alteracao do campo do P.O. e item                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpETQ()

Local aArea	 := GetArea() 
Local _aEtiq := {} 

Private lProces := .F.
Private nStack  := 0
Private lMsg    := .F.
Private cObj	:= ""
																				
cCartPost  := Posicione("ZZJ",1,xFilial("ZZJ")+"S05","ZZJ_CRPOST")
cSedexCod  := Posicione("ZZJ",1,xFilial("ZZJ")+"S05","ZZJ_TSECOD")
cESedexCod := Posicione("ZZJ",1,xFilial("ZZJ")+"S05","ZZJ_TESECD")
cTxtSedex  := Posicione("ZZJ",1,xFilial("ZZJ")+"S05","ZZJ_TXSED") 
cCodAdm	   := Posicione("ZZJ",1,xFilial("ZZJ")+"S05","ZZJ_CODADM")
																			
lSedex := U_SchCEP(Alltrim(aEtq[4])) 

cObjeto:= U_GetObj(Iif(!lSedex,"DN","DM"),Alltrim(cCodAdm))											   											   	
   	
lProces := .F.
nStack  := 0
lMsg    := .F.
cObj	:= ""							
					   	
If !Empty(cObjeto) 
   
	aadd(_aEtiq, { 	alltrim(cValtoChar(1))											,; //1.Volume. 			
					alltrim(U_Calcdigv(cObjeto))									,; //2.Objeto, usado tambem no código de barras
					alltrim(dtoc(dDataBase))										,; //3.Data da Postagem							
					alltrim(aEtq[1])												,; //4.Destinatario 
					alltrim(aEtq[2])												,; //5.Endereço do Destinatario
					alltrim(aEtq[3])												,; //6.Bairro do Destinatario
					alltrim(aEtq[4])												,; //7.CEP do Destinatario, usado tambem no código de barras
					alltrim(aEtq[5])												,; //8.Cidade do Destinatario
					alltrim(aEtq[6])												,; //9.Estado do Destinatario
					alltrim(SM0->M0_NOMECOM)										,; //10.Remetente
					alltrim(SM0->M0_ENDENT)											,; //11.Endereço do Remetente
					alltrim(SM0->M0_BAIRENT)										,; //12.Bairro do Remetente
					alltrim(SM0->M0_CEPENT)											,; //13.CEP do Remetente, usado tambem no código de barras
					alltrim(SM0->M0_CIDENT)											,; //14.Cidade do Remetente
					alltrim(SM0->M0_ESTENT)											,; //15.Estado do Remetente							
					alltrim("")														,; //16.Numero do Documento
					alltrim(cValtoChar(500))										,; //17.Peso Bruto							
					Alltrim(cCartPost)												,; //18. Nr. do Cartao de Postagem							
					alltrim(cSedexCod)												,; //19. Codigo Chancela Sedex 						
					alltrim(cESedexCod)												,; //20. Codigo Chancela E-Sedex  
					alltrim(cTxtSedex)												,; //21. Texto Chancela  
					""                                      			            ,; //22. Serie do Documento
					""                          			            	        ,; //23. Emissao do Documento
					""              			                                 	,; //24. Codigo do Cliente
					""																,; //25. Loja do Cliente 
					alltrim(cCodAdm)												}) //26. Codigo Administrativo        
											 
	U_ImpEtiq01(_aEtiq,.F.,.F.,.F.)
	
	aAdd(aLista,{alltrim(_aEtiq[1][7]),alltrim(_aEtiq[1][2]),alltrim(_aEtiq[1][4]),alltrim(_aEtiq[1][18]),alltrim(_aEtiq[1][26])})
										                                                              
Else
	apMsgInfo('Não foi possível imprimir etiqueta devido a controle de processamento. Para imprimir a etiqueta, utilize a rotina de IMPRESSÃO.','Controle de Processamento')	
EndIf 

RestArea(aArea)

Return

Static Function LiPost(aEtiqueta) 
	
	Local cPathDot	:= SuperGetMV("MV_XLPCORR",  ,"\\172.16.0.5\Microsiga\protheus_data\Modelo_Lista_Pos\Postagens_2007.dotx")	
	Local hWord    
    Local nCont		:= 0 
    Local ANF		:= {}
    Local cContrato := Posicione("SA1",1,xFilial("SA1")+AvKey("000129","A1_COD")+AvKey("01","A1_LOJA"),"A1_CONTRT")
	Local cCodadm 	:= Posicione("SA1",1,xFilial("SA1")+AvKey("000129","A1_COD")+AvKey("01","A1_LOJA"),"A1_CODADM") 
    Local cCartPost := Posicione("SA1",1,xFilial("SA1")+AvKey("000129","A1_COD")+AvKey("01","A1_LOJA"),"A1_CRTPOST")
	Local cCliente  := Alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey("000129","A1_COD")+AvKey("01","A1_LOJA"),"A1_NREDUZ")) 
	Local cNumLista := SuperGetMV("BH_SEQPOST",  ,"001")
	Local lSedex	:= .T. 
	Local nx		:= 0

	hWord	:= OLE_CreateLink()
	OLE_NewFile(hWord, cPathDot )
	
	OLE_SetDocumentVar(hWord, 'Dt_Emi'		,Dtoc(dDataBase))
	OLE_SetDocumentVar(hWord, 'Unid_Post'	,"00061937 - GCCAP/CTE JAGUARÉ")
	OLE_SetDocumentVar(hWord, 'CEP_Post'	,"05314-969")
	OLE_SetDocumentVar(hWord, 'Dt_Post'		,Dtoc(dDataBase)) 
	OLE_SetDocumentVar(hWord, 'Cod_Admin'	,cCodadm) 
	OLE_SetDocumentVar(hWord, 'Contrato'	,cContrato)
	OLE_SetDocumentVar(hWord, 'Num_Lista'	,cNumLista)
	OLE_SetDocumentVar(hWord, 'Cliente'		,cCliente)
	
	For nx:=1 to Len(aEtiqueta) 
	  	   	
		lSedex := U_SchCEP(alltrim(aEtiqueta[nx][1]))
	    	
		If !lSedex  				
	                            
			aADD(ANF,{"3",; 								//1. Tipo 3 - Lista de Postagem
			cContrato,;              						//2. Número do Contrato
			cCodadm,;                						//3. Código Administrativo
			alltrim(aEtiqueta[nx][1]),;    					//4. CEP do Destino
			"40444",;                   					//5. Código do Serviço (SFI)
			"00",;                      					//6. Cód. Serv Adic. 1 Conforme Tab. Serv. Adic.
			0,;												//7. Valor Declarado
			alltrim(aEtiqueta[nx][2]),;  					//8. Número da Etiqueta
			cCartPost,;             						//9. Nº do cartão de postagem
			alltrim(""),;			      					//10. Número Nota Fiscal
			"DN",;                      					//11. Sigla do Serviço
			0,;    											//12. Valor a cobrar do destinatario
			alltrim(aEtiqueta[nx][3]),;						//13. Nome do destinatário
			1,;           									//14. Volume
			500,;            								//15. Peso 
			"N",;            								//16. Declara valor?
			0,;           									//17. Valor Bruto			
			lSedex})			           					//18. Serviço
			
			
		Else
		
			aADD(ANF,{"3",; 								//1. Tipo 3 - Lista de Postagem
			cContrato,;              						//2. Número do Contrato
			cCodadm,;                						//3. Código Administrativo
			alltrim(aEtiqueta[nx][1]),;         			//4. CEP do Destino
			"81019",;                   					//5. Código do Serviço (SFI)
			"00",;                      					//6. Cód. Serv Adic. 1 Conforme Tab. Serv. Adic.
			0,;											    //7. Valor Declarado
			alltrim(aEtiqueta[nx][2]),;  					//8. Número da Etiqueta
			cCartPost,;             						//9. Nº do cartão de postagem
			alltrim(""),;			      					//10. Número Nota Fiscal
			"DM",;                      					//11. Sigla do Serviço
			0,;    											//12. Valor a cobrar do destinatario
			alltrim(aEtiqueta[nx][3]),;						//13. Nome do destinatário
			1,;  				         					//14. Volume
			500,;            								//15. Peso
			"N",;            								//16. Declara valor? 			
		    0,;					           					//17. Valor Bruto
		    lSedex})			           					//18. Serviço
		
		EndIf
	Next nx		
	
	For nx:=1 To Len(ANF)
		
		&&Montagem das variaveis do cabecalho
		
		OLE_SetDocumentVar(hWord,;
		'NDestinatario'	+ AllTrim(cValToChar(nx)),;		
		"Destinatário:"+Space(30)+;
		"CEP destino: "+;
		ANF[nx][4]+Space(35)+;
		ANF[nx][13]+Space(42)+;
		"Deseja declarar valor?"+Space(1)+Iif(ANF[nx][16]=="S","Sim","Não")+;	
		"Valor declarado:"+Space(1)+Iif(ANF[nx][16]=="S",Alltrim(Transform(ANF[nx][17],"@E 99999.99" )),"")+;
		"Valor a cobrar do destinatário:"+Space(140)+Iif(ANF[nx][16]=="S",Alltrim(Transform(ANF[nx][17],"@E 99999.99" )),"")+;
		"Inf. compl.:")	
		
		OLE_SetDocumentVar(hWord,;
		'NNum_Obj'+ AllTrim(cValToChar(nx))	,;
		"N"+"º"+"objeto: "+;
		Alltrim(ANF[nx][8])+Space(8)+;
		"N"+"º"+"da N.F.: "+; 		
		Alltrim(ANF[nx][10])+Space(7)+;
		"Volume: "+cValToChar(ANF[nx][14])+Space(23)+;
		"Serviço: "+Iif (!ANF[nx][18],"40444 SEDEX-CONTRATO","81019 E-SEDEX")+Space(100)+;
		"Peso tarifado(g):"+Space(35)+;
		"Serviços Adicionais:"+Space(43)+;
		cValToChar(ANF[nx][15])+Space(140)+;
		"Valor a pagar:")
		
		nCont := nCont+1
	
	Next nx
	
	OLE_SetDocumentVar(hWord, 'cUsuari',Alltrim(cUserName))
	OLE_SetDocumentVar(hWord, 'cTotalizador',nCont)	
	OLE_SetDocumentVar(hWord, 'cCartPost',cCartPost)
	OLE_SetDocumentVar(hWord, 'cRemet',alltrim(SM0->M0_NOMECOM))
	OLE_SetDocumentVar(hWord, 'cEndRemet',alltrim(SM0->M0_ENDENT)+" "+alltrim(SM0->M0_BAIRENT)+" "+alltrim(SM0->M0_CIDENT)+" "+alltrim(SM0->M0_ESTENT))
	OLE_SetDocumentVar(hWord, 'Num_Pagina'	,"1 de "+ cValtoChar(round(nCont/11,0)+1))
		
	OLE_ExecuteMacro(hWord,"Objetos"  )
	
	OLE_UpdateFields(hWord)	// Atualizando as variaveis do documento do Word 
	
	If MsgYesNo("ATENÇÃO!!!! SALVE O DOCUMENTO WORD ANTES DE CLICAR EM SIM. APÓS SALVAR, CLIQUE EM SIM.")
	   	OLE_CloseLink( hWord )
		OLE_CloseFile( hWord )                                  
	EndIf
	
	//Atualiza Numero Sequencial da Lista
	If Select("SX6") == 0
		DbSelectArea("SX6")
	EndIf
	SX6->(DbSetOrder(1))
	If SX6->(DbSeek(xFilial("SX6")+"BH_SEQPOST")) 
		If RecLock("SX6",.F.)
			SX6->X6_CONTEUD:= Soma1(Alltrim(SX6->X6_CONTEUD))
			SX6->(MsUnlock())
		EndIf
	EndIf
	
	u_GerTxtSedex(ANF)
	                   
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Vinicius Leonardo  º Data ³  19/02/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 		  													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuTabObj(_aEtiq)

For nx:=1 To Len(_aEtiq) 

	If Select("Z03") == 0
		DbSelectArea("Z03")
	EndIf	
	Z03->(DbSetOrder(1))
	Z03->(DbGoTop())  
	
	//Z03_FILIAL+Z03_DOC+Z03_SERIE+Z03_OBJETO+Z03_EMISSA
	If Z03->(!DbSeek(xFilial("Z03")+AvKey("","Z03_DOC")+AvKey("","Z03_SERIE")+AvKey(_aEtiq[nx][2],"Z03_OBJETO")+AvKey(dDataBase,"Z03_EMISSA")))
		If Reclock("Z03",.T.)
		
			Z03->Z03_FILIAL := xFilial("Z03")
			Z03->Z03_DOC 	:= ''
			Z03->Z03_SERIE 	:= ''
			Z03->Z03_EMISSA := dDataBase
			Z03->Z03_HORA 	:= Time()
			Z03->Z03_OBJETO := _aEtiq[nx][2] //OBJETO
			Z03->Z03_DESTIN := ''
			Z03->Z03_LOJDST := ''
			Z03->Z03_VOLUME := 1
			Z03->Z03_PESO 	:= 500
			Z03->Z03_CRPOST := _aEtiq[nx][4] //CARTAO DE POSTAGEM
			Z03->Z03_TSECD 	:= _aEtiq[nx][1] //CEP
			Z03->Z03_TESECD := 'DEVOLUCAO'
			Z03->Z03_TXSED  := _aEtiq[nx][3] //NOME DESTINATARIO 
			Z03->Z03_IMPRE  := ''
			//Z03->Z03_CODADM := _aEtiq[nx][5] //CODIGO ADMINISTRATIVO  
		
			Z03->(MsUnlock())
		EndIf
	Else
		If Reclock("Z03",.F.)
		
			Z03->Z03_FILIAL := xFilial("Z03")
			Z03->Z03_DOC 	:= ''
			Z03->Z03_SERIE 	:= ''
			Z03->Z03_EMISSA := dDataBase
			Z03->Z03_HORA 	:= Time()
			Z03->Z03_OBJETO := _aEtiq[nx][2] //OBJETO
			Z03->Z03_DESTIN := ''
			Z03->Z03_LOJDST := ''
			Z03->Z03_VOLUME := 1
			Z03->Z03_PESO 	:= 500
			Z03->Z03_CRPOST := _aEtiq[nx][4] //CARTAO DE POSTAGEM
			Z03->Z03_TSECD 	:= _aEtiq[nx][1] //CEP
			Z03->Z03_TESECD := 'DEVOLUCAO'
			Z03->Z03_TXSED  := _aEtiq[nx][3] //NOME DESTINATARIO 
			Z03->Z03_IMPRE  := ''
			//Z03->Z03_CODADM := _aEtiq[nx][5] //CODIGO ADMINISTRATIVO  
		
			Z03->(MsUnlock())
		EndIf		
	EndIf

Next nx	
	
Return   