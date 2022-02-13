#include "rwmake.ch"
#include "TopConn.ch"
#Include "Totvs.ch"  
#Include "Protheus.ch" 

User Function ImpListPost() 

	//Local cPathDot	:= AllTrim(GetMv("MV_ZZDIWRD")) &&"C:\Protheus_devel\Modelo_Word\Mod_Termo_Aceitacao.docm"
	Local cPathDot	:= "C:\000000\_000\Postagens_2007.dotx"
	Local hWord    
    Local nCont		:= 0 
    Local ANF		:= {}
    
    hWord	:= OLE_CreateLink()
	OLE_NewFile(hWord, cPathDot )
	
	OLE_SetDocumentVar(hWord, 'Dt_Emi'		,Dtoc(dDataBase))	 
	OLE_SetDocumentVar(hWord, 'Num_Pagina'	,"1 de 1")	 
	OLE_SetDocumentVar(hWord, 'Unid_Post'	,"6193 - CTE Jaguaré")
	OLE_SetDocumentVar(hWord, 'CEP_Post'	,alltrim(SM0->M0_CEPENT))
	OLE_SetDocumentVar(hWord, 'Dt_Post'		,Dtoc(dDataBase))
	OLE_SetDocumentVar(hWord, 'Cod_Admin'	,"10044256")
	OLE_SetDocumentVar(hWord, 'Contrato'	,"9912250688")
	OLE_SetDocumentVar(hWord, 'Num_Lista'	,"958")
	OLE_SetDocumentVar(hWord, 'Cliente'		,"SONY MOB COMMUN BR LTDA") 
	
	aADD(ANF,{'000718','01216-012',"PORTO SEGURO TELECOMUNICACOES"}) 
	aADD(ANF,{'000719','06233-200',"NEXTEL TELECOMUNICACOES LTDA"})
	aADD(ANF,{'000720','06233-200',"NEXTEL TELECOMUNICACOES LTDA"})
	aADD(ANF,{'000722','8131000',"POSITIVO INFORMATICA S/A"})
	aADD(ANF,{'000723','04547-005',"GFK MARKET R BRASIL PESQ MAERCADO LTDA"})
	
	For nx:=1 To Len(ANF)	
		
		&&Montagem das variaveis do cabecalho
		
		OLE_SetDocumentVar(hWord,;
		'NDestinatario'	+ AllTrim(cValToChar(nx)),;		
		"Destinatário:"+Space(30)+;
		"CEP destino: "+;
		ANF[nx][2]+Space(35)+;
		ANF[nx][3]+Space(42)+;
		"Deseja declarar valor?"+Space(1)+;
		"Valor declarado:"+Space(1)+;
		"Valor a cobrar do destinatário:"+Space(1)+;
		"Não"+Space(140)+;
		"Inf. compl.:")		
		
		OLE_SetDocumentVar(hWord,;
		'NNum_Obj'+ AllTrim(cValToChar(nx))	,;
		"N"+"º"+"objeto: "+;
		"SW940709375BR"+Space(14)+;
		"N"+"º"+"da N.F.: "+;
		ANF[nx][1]+Space(7)+;
		"Volume: "+;
		"1/1"+Space(23)+;
		"Serviço: "+;
		"81019 E-SEDEX"+Space(100)+;
		"Peso tarifado(g):"+Space(35)+;
		"Serviços Adicionais:"+Space(43)+;
		"0,8000"+Space(140)+;
		"Valor a pagar:")
		
		nCont := nCont+1
	
	Next nx
	
	OLE_SetDocumentVar(hWord, 'cUsuari',Alltrim(""))
	OLE_SetDocumentVar(hWord, 'cTotalizador',nCont)	
	OLE_SetDocumentVar(hWord, 'cCartPost',"0066861926")
	OLE_SetDocumentVar(hWord, 'cRemet',alltrim(SM0->M0_NOMECOM))
	OLE_SetDocumentVar(hWord, 'cEndRemet',alltrim(SM0->M0_ENDENT)+" "+alltrim(SM0->M0_BAIRENT)+" "+alltrim(SM0->M0_CIDENT)+" "+alltrim(SM0->M0_ESTENT))
		
	OLE_ExecuteMacro(hWord,"Objetos"  )
	
	OLE_UpdateFields(hWord)	&& Atualizando as variaveis do documento do Word
	
    /*If MsgYesNo("Imprime o Documento ?")
	 	Ole_PrintFile(hWord,"ALL",,,1)
   	EndIf*/		
   	
    If MsgYesNo("Fechar Documento ?")
	   	OLE_CloseLink( hWord )
		OLE_CloseFile( hWord )                                  
	EndIf
	                   
Return