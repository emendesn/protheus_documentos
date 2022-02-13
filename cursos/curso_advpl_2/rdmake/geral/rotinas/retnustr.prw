#Include 'Totvs.ch'

User Function RetNuStr(cString,lRet)
	Local cNum := ''
	Local lEsp := .F.
	
	If 'S/N' $ cString .Or. !(',' $ cString) .Or. ' SN ' $ cString 
		//cNum := "S/N"
		lRet := .F.	
	Else
		cString := SubStr(cString,at(',',cstring)+1)
		For nI := 1 To Len(cString)
			cTemp := SubStr(cString, nI, 1)
			
			If lEsp .And. Empty(cTemp)
				Exit
			End
			
			If cTemp $ '0123456789'                    
				lEsp := .T.
				cNum += cTemp
			EndIf	
		Next nI 
		lRet := .T.                                             
	EndIf
Return cNum