#Include 'Protheus.ch'
#Include "Topconn.ch"
#Include "Rwmake.ch"
#Include "Totvs.ch"

//+-----------------------------------------------------------------+
//| Ponto de entrada para a informação na tela da quantidade de nfs |
//| rejeitadas antes do 5 dia do encerramento do mês                |
//+-----------------------------------------------------------------|  
//| Autor: Carlos Vieira/BGH  | Data: 08/02/2014                    |
//+-----------------------------------------------------------------+
 
User Function FISFILNFE()

Local cData:=''
Local cQuery:=''

// Tratamento para verificar apenas o ultimo dia util
If Dow(date())=2
	cData:= dtos(date()-3)
else
	cData:=dtos(date()-1)
EndIf
//

If Select("SF2JATO") <> 0 
	DbSelectArea("SF2JATO")
	DbCloseArea()
Endif

	cQuery:=" SELECT F2_FILIAL, COUNT(*) AS QTD " 
	cQuery+=" FROM " + RetSqlName("SF2") + "(NOLOCK)"
	cQuery+=" WHERE F2_FILIAL<>'07' AND D_E_L_E_T_='' AND F2_EMISSAO >= '"+cData+"' AND (F2_FIMP='N' OR F2_FIMP=' ')"
	cQuery+=" AND NOT(F2_SERIE IN ('RPS','2D'))"
	cQuery+=" GROUP BY F2_FILIAL"
	cQuery+=" ORDER BY F2_FILIAL"
	
TCQUERY cQuery NEW ALIAS "SF2JATO"

DBSELECTAREA("SF2JATO")
DBGOTOP()
While !Eof()
	MSGINFO('Existem: '+Alltrim(Transform(SF2JATO->QTD,"@e 999999999"))+' nota(s) pendente(s) de transmissão, na filial: '+SF2JATO->F2_FILIAL+ CHR(10)+CHR(13)+;
			'Corrija o problema ou efetue a abertura de chamado.')	
	DBSKIP()
EndDo

DbCloseArea("SF2JATO")

//Retornando a condição selecionada pelo usuário na rotina principal SPEDNFE()
Return(cCondicao)