#Include "Totvs.ch"
#Include "tbiconn.ch"
#INCLUDE "APWIZARD.CH"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

User Function JobA0002()   
	Local cAlias 	:= ''
	Local cTitulo	:= 'Pendencias de Retorno TotalExpress'
	Local cDestina	:= ''
	Local cCco  	:= ''
	Local cMensagem	:= ''
	Local Path	 	:= ''

//u_GerA0003(ProcName())
	
	rpcsettype(3)
 	rpcsetenv('02','02')
	cDestina	:= GetMv("ZZ_EDIMAIL")
	cAlias := GetNextAlias()   
	
	BeginSql Alias cAlias
		Select Distinct ZX_ROMAN, ZX_NOTA, ZX_SERIE, ZX_DTROMA
		From %Table:SZX% SZX
		
			Inner Join %Table:SF2% SF2
				On F2_FILIAL 	= %xFilial:SF2%
 				And F2_DOC 		= ZX_NOTA
				And F2_SERIE 	= ZX_SERIE
				And	SF2.%NotDel%
								
			Left JoIn %Table:Z03%  Z03
				on Z03_FILIAL		= %xFilial:Z03%
				And Z03_DOC			= ZX_NOTA
				And Z03_SERIE		= ZX_SERIE
				And Z03.%NotDel%
		Where 
			ZX_FILIAL			= %xFilial:SZX%
			And ZX_IDDEST		= '44'
			And SZX.%NotDel%
			And Z03_DOC Is Null
	EndSql   

	If (cAlias)->(EOF())
		ConOut("Nenhuma Pendencia junto a Total Express!")     
		(cAlias)->(dbCloseArea())
		rpcclearenv()
		Return	
	EndIf
	
	cMensagem := "Prezados, "+CRLF+CRLF
	cMensagem += "As notas descritas abaixo estão pendentes de retorno da TotalExpress, é aconselhavel o reenvio dos Romaneios indicados!"+CRLF+CRLF
	Do While !(cAlias)->(EoF())	                     
		If (cAlias)->ZX_DTROMA >= DTOS(Date()) 
			Return
		EndIf
		cMensagem += 'Nota Fiscal: '+(cAlias)->ZX_NOTA + '  	Série: ' + (cAlias)->ZX_SERIE  + '	Romaneio: '+(cAlias)->ZX_ROMAN+'	Dt. Roman.: '+DToC(StoD((cAlias)->ZX_DTROMA))+CRLF
		(cAlias)->(dbSkip())	
	Enddo

	ConOut(cMensagem)                                                                
	
	cMensagem += CRLF+CRLF
	cMensagem += 'Atenciosamente,'+CRLF+CRLF 
	cMensagem += 'Protheus - BGH do Brasil'+CRLF	
	
	u_ENVIAEMAIL(cTitulo,cDestina,cCco,cMensagem,Path)	
	(cAlias)->(dbCloseArea())
	rpcclearenv()
Return