///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Rotina_Auto.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Rot_Auto()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Demonstracao de rotinas automaticas                             |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#include "rwmake.ch"
#INCLUDE "TBICONN.CH"

User Function Rot_Auto()
LOCAL aSays:={}
LOCAL aButtons:={}

AADD(aSays,"Essa rotina ira efetuar os cadastros utilizados")
AADD(aSays,"para o curso de rotinas automaticas")

AADD(aButtons, { 1,.T.,{|o| (Processa({|lEnd| ProcessaCa(.F.)}),o:oWnd:End()) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch("Inclusao automatica de Cadastros", aSays, aButtons,,200,405 )
RETURN

Static Function ProcessaCa()
LOCAL nProcessos:=6
LOCAL nOpc := 3 // Inclusao
LOCAL aTes := {},aProduto:={},aCliente:={},aFornecedor:={},aCab:={},aItens:={},aLinha:={}
LOCAL nx:=0
LOCAL cTextAviso:="Cadastros incluidos. Rotina encerrada com sucesso !!!"

PRIVATE lMsErroAuto := .F.

ProcRegua(nProcessos)

// Inclui TES de Entrada e Saida
IncProc()
aTes:={{"F4_CODIGO"    ,"011",Nil},;
			{"F4_TIPO"  	,"E",Nil},;
			{"F4_ICM"		,"S",Nil},;
			{"F4_IPI"		,"S",Nil},;
			{"F4_CREDICM"   ,"S",Nil},;
			{"F4_CREDIPI"	,"S",Nil},;
			{"F4_DUPLIC"    ,"S",Nil},;
			{"F4_ESTOQUE"   ,"S",Nil},;
			{"F4_CF"		,"111",Nil},;
			{"F4_TEXTO"		,"COMPRA",Nil},;
			{"F4_PODER3"	,"N",Nil},;
			{"F4_LFICM"		,"T",Nil},;
			{"F4_LFIPI"		,"T",Nil},;
			{"F4_DESTACA"	,"N",Nil},;
			{"F4_INCIDE"	,"N",Nil},;
			{"F4_COMPL"		,"N",Nil}}
MSExecAuto({|x,y| mata080(x,y)},aTes,nOpc)

IncProc()
aTes:={{"F4_CODIGO"    ,"511",Nil},;
			{"F4_TIPO"  	,"S",Nil},;
			{"F4_ICM"		,"S",Nil},;
			{"F4_IPI"		,"S",Nil},;
			{"F4_CREDICM"   ,"S",Nil},;
			{"F4_CREDIPI"	,"S",Nil},;
			{"F4_DUPLIC"    ,"S",Nil},;
			{"F4_ESTOQUE"   ,"S",Nil},;
			{"F4_CF"		,"511",Nil},;
			{"F4_TEXTO"		,"VENDA",Nil},;
			{"F4_PODER3"	,"N",Nil},;
			{"F4_LFICM"		,"T",Nil},;
			{"F4_LFIPI"		,"T",Nil},;
			{"F4_DESTACA"	,"N",Nil},;
			{"F4_INCIDE"	,"N",Nil},;
			{"F4_COMPL"		,"N",Nil}}
MSExecAuto({|x,y| mata080(x,y)},aTes,nOpc)

// Inclui Fornecedor
IncProc()
If !lmsErroAuto
	aFornecedor:={	{"A2_COD"	,"F00001",Nil},;
				{"A2_LOJA"	,"01",Nil},;
				{"A2_NOME"	,"FORNECEDOR VENDE BEM S.A.",Nil},;
				{"A2_NREDUZ","FORNECEDOR VENDE",Nil},;
				{"A2_TIPO"  ,"F",Nil},;
				{"A2_END"   ,"RUA DO CURTUME 100",Nil},;
				{"A2_MUN"   ,"SAO PAULO",Nil},;
				{"A2_EST"   ,"SP",Nil},;
				{"A2_COND"	,"001",Nil}}    
	MSExecAuto({|x,y| mata020(x,y)},aFornecedor,nOpc)			
EndIf

// Inclui Cliente
IncProc()
If !lmsErroAuto
	aCliente:={	{"A1_COD"	,"C00001",Nil},;
				{"A1_LOJA"	,"01",Nil},;
				{"A1_NOME"	,"CLIENTE COMPRA BEM S.A.",Nil},;
				{"A1_NREDUZ","CLIENTE COMPRA",Nil},;
				{"A1_TIPO"  ,"F",Nil},;
				{"A1_END"   ,"RUA DO ROCIO 123",Nil},;
				{"A1_MUN"   ,"SAO PAULO",Nil},;
				{"A1_EST"   ,"SP",Nil},;
				{"A1_COND"	,"001",Nil}}    
	MSExecAuto({|x,y| mata030(x,y)},aCliente,nOpc)			
EndIf
	
// Inclui Produto  
IncProc()
If !lmsErroAuto
	For nx:=1 to 3
		aProduto:={	{"B1_COD"	,"PA"+Str(nx,1,0),Nil},;
					{"B1_DESC"	,"PRODUTO ACABADO "+Str(nx,1,0),Nil},;
					{"B1_TIPO"	,"PA",Nil},;
					{"B1_UM"	,"PC",Nil},;
					{"B1_LOCPAD","01",Nil},;
					{"B1_TS"	,"501",Nil}}    
		MSExecAuto({|x,y| mata010(x,y)},aProduto,nOpc)			
	Next nx    
EndIf	

// Inclui NF de entrada
IncProc()
If !lmsErroAuto
	aCab := {{"F1_TIPO"		,'N'	,NIL},;
	{"F1_FORMUL"	,"N"			,NIL},;
	{"F1_DOC"		,"000001"		,NIL},;
	{"F1_SERIE"		,"UNI"			,NIL},;
	{"F1_EMISSAO"	,dDataBase		,NIL},;									
	{"F1_FORNECE"	,"F00001"    	,NIL},;		
	{"F1_LOJA"	    ,"01"        	,NIL},;		
	{"F1_COND" 	    ,"001"			,NIL},;		
	{"F1_ESPECIE"	,"NF"    		,NIL}}
 
	For nx:=1 to 3 
		aLinha:={}
		AADD(aLinha,{"D1_COD"	,"PA"+Str(nx,1,0)  ,NIL})
		AADD(aLinha,{"D1_UM"	,"PC"				,NIL})
		AADD(aLinha,{"D1_QUANT"	,10000				,NIL})
		AADD(aLinha,{"D1_VUNIT"	,1					,NIL})
		AADD(aLinha,{"D1_TOTAL"	,10000				,NIL})
		AADD(aLinha,{"D1_TES"	,"001"				,NIL})
		AADD(aLinha,{"D1_LOCAL"	,"01"				,NIL})
		AADD(aItens,aLinha)
	Next nx    
	MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,aItens,nOpc)
EndIf

//-- Verifica se houve algum erro
If lmsErroAuto
	cTextAviso:="Erros encontrados na importacao de dados. Verifique o(s) arquivo(s) de log ."	
EndIf
Aviso('Atencao',cTextAviso,{'Ok'})
RETURN