#include "rwmake.ch"
#include "TopConn.ch"
#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FORMPEC   ºAutor  ³ Uiran Almeida      º Data ³  24/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adaptacao do fonte WRDTERACE, para formulario de pecas     º±±
±±º          ³ POSTIVO                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rotina para impressão de formulario de pecas POSITIVO      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FormPec()
	Local cPerg		 	:= "MTR777" && Criar perguntas no SX1 (De pedido a pedido) 
	
	Private waNfori  	:= {} && Nota fiscal de Origem do Cliente
	Private waNfdev		:= {} && Nota fiscal de Devolucao
	Private waCodpro	:= {} && Codigo do Produto
	Private waDescpro	:= {} && Descricao do Produto
	Private waQtdpro	:= {} && Quantidade do Produto
	Private nTotal		:= 0  && Valor total de Produtos
   	Private cAlias	 	:= GetNextAlias()

u_GerA0003(ProcName())
    
		ValidPerg(cPerg)
		Pergunte(cPerg, .T.)
		Processa({|| LoadQuery()},"Carregando dados....")
Return
  




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOADQUERY ºAutor  ³Thomas Quintino     º Data ³  19/07/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Query responsavel por carregar os itens do pedido         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rotina para impressão de formulario de pecas POSITIVO      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/




/**
 * Rotina		:	CarItens
 * Autor		:	Thomas Quintino Galvão
 * Data			:	19/07/2012	
 * Uso			:	SIGAFAT
 * Descricao	:	Carrega Itens Faturados
 */  
Static Function LoadQuery()
                       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a Query que buscara os itens do pedido de acordo com os paramentros³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	#IFDEF TOP
		BeginSQL Alias cAlias
			SELECT 
				C6_NFORI, 
				C6_NOTA, 
				C6_PRODUTO, 
				B1_DESC, 
				C6_QTDVEN,
				C6_VALOR
			 		
			 		FROM %Table:SC6% C6 (NoLock) 
					
					INNER JOIN %Table:SB1% B1(NoLock)
					ON B1_COD = C6_PRODUTO
					AND B1.%NotDel%


					WHERE C6.%NotDel%
					AND C6_FILIAL= %xFilial:SC6%
					AND C6_NUM BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% 
		     EndSQL
	                
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega os Arrays de acordo com retorno da Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  	
		Do While !(cAlias)->(EoF())		
			ProcRegua(RecCount()) 
		   	aAdd(waNfori, 	(cAlias)->C6_NFORI) 	&& Nota de Origem
	    	aAdd(waNfdev, 	(cAlias)->C6_NOTA)  	&& Nota de Devolucao
			aAdd(waCodpro, 	(cAlias)->C6_PRODUTO)  && Codigo do Produto
			aAdd(waDescpro,	(cAlias)->B1_DESC)  	&& Descricao do Produto
			aAdd(waQtdpro, 	(cAlias)->C6_QTDVEN)  	&& Quantidade
			
	    	nTotal 	+= (cAlias)->C6_VALOR  		&& Valor Total dos Produtos
		
			
			(cAlias)->(DbSkip())    
	   	EndDo
	    
	   	If nTotal > 0 
		    PrintWord(@nTotal) 
		Else
			MsgAlert('Nao existe Registro para estes parametros!')
		EndIf
		(cAlias)->(dbCloseArea())
	#ENDIF
Return 

/**
 * Rotina		:	CarItens
 * Autor		:	Thomas Quintino Galvão
 * Data			:	19/07/2012	
 * Uso			:	SIGAFAT
 * Descricao	:	Carrega Itens Faturados
 */  
Static Function PrintWord(nTotal) 
	Local cPathDot	:= AllTrim(GetMv("MV_SC6FORM")) &&"\\BROS-VS-FLS01\Modelos\Form_coleta.docm" 
	Local hWord
    Local nK
    Local cNFPecas 	:= ""
    Local nValDesc 	:= 0
    Local nTotGeral	:= 0
    Local nContGar	:= 0
    Local nContFGar	:= 0
    
    hWord	:= OLE_CreateLink()
	OLE_NewFile(hWord, cPathDot )	
   
   /*		
	&&Montagem das variaveis do cabecalho
	OLE_SetDocumentVar(hWord, 'w_remetente'	, cCliente)			    		
	OLE_SetDocumentVar(hWord, 'w_nfserv'	, cNFServ)			    		
   */
                                                
    &&Montagem das variaveis dos itens. No documento word estas variaveis serao criadas &&dinamicamente da seguinte forma:
	For nK := 1 to Len(waNfori)
		OLE_SetDocumentVar(hWord,"w_nfpos"    +AllTrim(Str(nK)),waNfori[nK])
		OLE_SetDocumentVar(hWord,"w_nfdev"    +AllTrim(Str(nK)),waNfdev[nK])
		OLE_SetDocumentVar(hWord,"w_codpro"   +AllTrim(Str(nK)),waCodpro[nK])
		OLE_SetDocumentVar(hWord,"w_despro"   +AllTrim(Str(nK)),waDescpro[nK])
		OLE_SetDocumentVar(hWord,"w_qtdpro"   +AllTrim(Str(nK)),waQtdpro[nK])
		nContGar ++
	Next nK	 
	
	OLE_SetDocumentVar(hWord, 'w_nroitens'	,nContGar)
	OLE_ExecuteMacro(hWord,"itensform")  
	
	OLE_SetDocumentVar(hWord, 'w_vlrtot'	 , AllTrim(Transform(nTotal,"@E 999,999,999.99")))	
	
	OLE_UpdateFields(hWord)	&& Atualizando as variaveis do documento do Word
	
    If MsgYesNo("Imprime o Documento ?")
	 	Ole_PrintFile(hWord,"ALL",,,1)
   	EndIf		
   	
    If MsgYesNo("Fechar Documento ?")
	   	OLE_CloseLink( hWord )
		OLE_CloseFile( hWord )                                  
	EndIf
 
 
waNfori  	:= {}
waNfdev		:= {}
waCodpro	:= {}
waDescpro	:= {}
waQtdpro	:= {}
nTotal		:= 0 
  	
   	                   
Return


/**
 * Rotina		:	ValidPerg
 * Autor		:	Thomas Quintino Galvão
 * Data			:	23/07/2012	
 * Descricao	:	Cria Grupo de Perguntas
 */  
Static Function ValidPerg(cPerg)
	Local lRetorno := .T.                                                                                                                                                                                                          
	PutSx1(cPerg,"01","De pedido ?  "	, "De pedido ?  "	, "Cliente ?"	, "mv_ch1","C",09,0,0,"G","",""   ,"","","mv_par01")
	PutSx1(cPerg,"02","Ate pedido ? "	, "Ate pedido ? "	, "Nota ?   "	, "mv_ch2","C",09,0,0,"G","","SF2","","","mv_par02")
Return lRetorno       