#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"

/****************************************************************************
** Programa: TGFArray    * Autor:Luis Henrique Robusto * Data: 10/08/2018 ***
*****************************************************************************
** Desc.: Rotina revisa funcoes existentes no repositorio de sistemas     ***
**        conforme parametro passado para pesquisa                        ***
*****************************************************************************
** DATA      * ANALISTA *  MOTIVO                                         ***
*****************************************************************************
**           *          *                                                 ***
****************************************************************************/
User Function LerRpo()
  Local aRetLocal, nCount
  // Para retornar a origem da funcoo: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
  Local aType
  // Para retornar o nome do arquivo onde foi declarada a funcao
  Local aFile
  // Para retornar o n�mero da linha no arquivo onde foi declarada a funcao
  Local aLine
  // Para retornar a data da �ltima modificacao do codigo fonte compilado
  Local aDate
  // Para retornar a hora da �ltima modificacao do codigo fonte compilado
  Local aTime
  // Local
  Local cDir    := "C:\"
  // Arquivo
  Local cArq    := "leitura_rpo.txt"
  // FCreate comando responsavel pela criacao do arquivo
  Local nHandle := FCreate(cDir+cArq)
  Local nCount  := 0
  // Buscar informacoes de todas as funcoes contidas no APO
  // tal que tenham a substring 'test' em algum lugar de seu nome
  aRet := GetFuncArray('U_*', aType, aFile, aLine, aDate,aTime)
  for nCount := 1 To Len(aRet)
    conout("Funcao " + cValtoChar(nCount)  + " ; " + aRet[nCount])
    conout("Arquivo " + cValtoChar(nCount) + " ; " + aFile[nCount])
    conout("Linha " + cValtoChar(nCount)   + " = " + aLine[nCount])
    conout("Tipo " + cValtoChar(nCount)    + " = " + aType[nCount])
    conout("Data " + cValtoChar(nCount)    + " = " + DtoC(aDate[nCount]))
    conout("Hora " + cValtoChar(nCount)    + " = " + aTime[nCount])
  Next

	//*****************************************************************************************************************
	// nHandle - A funcao FCreate retorna o handle, que indica se foi possivel ou nao criar o arquivo. Se o valor for *
	// menor que zero, nao foi possivel criar o arquivo.                                                              *
	//*****************************************************************************************************************
	If nHandle < 0
		MsgAlert("Erro durante criacao do arquivo.")
	Else
		//******************************************************************************
		// FWrite - Comando reponsavel pela gravacao do texto.                         *
		//******************************************************************************

		//For nLinha := 1 to 10
		//	FWrite(nHandle, "Gravando linha " + StrZero(nLinha, 2) + CRLF)
		//Next nLinha

		  for nCount := 1 To Len(aRet)
	        FWrite(nHandle, "Gravando linha " + ;	    
		    "Funcao  ; " + cValtoChar(nCount) + " ; " + aRet[nCount]        +" ; "+;
		    "Arquivo ; " + cValtoChar(nCount) + " ; " + aFile[nCount]       +" ; "+;
		    "Linha   ; " + cValtoChar(nCount) + " ; " + aLine[nCount]       +" ; "+;
		    "Tipo    ; " + cValtoChar(nCount) + " ; " + aType[nCount]       +" ; "+;
		    "Data    ; " + cValtoChar(nCount) + " ; " + DtoC(aDate[nCount]) +" ; "+;
		    "Hora    ; " + cValtoChar(nCount) + " ; " + aTime[nCount]       +" ; "+CRLF)
		  Next

		    //Como o rpo tem problemas na gravacao de data nao posso melhorar a captacao dia mes e ano
		    //"Data2    ; " + cValtoChar(nCount) + " ; " + ;
            //DtoC(Day(aDate[nCount])+"/"+Year(aDate[nCount])+"/"+Month(aDate[nCount])) +" ; "+;
		    //"Ano     ; " + cValtoChar(nCount) + " ; " + Year(aDate[nCount]) +" ; "+;		    
		    //"Mes     ; " + cValtoChar(nCount) + " ; " + Month(aDate[nCount])+" ; "+;
		    //"Dia     ; " + cValtoChar(nCount) + " ; " + Day(aDate[nCount])  +" ; "+;

		//******************************************************************************
		// FClose - Comando que fecha o arquivo, liberando o uso para outros programas *
		//******************************************************************************
		FClose(nHandle)
	EndIf


Return

/****************************************************************************
** Programa: LerRpo      * Autor:Luis Henrique Robusto * Data: 10/08/2018 ***
*****************************************************************************
** Desc.: Chamada e criacao do arquivo texto como log dos programas       ***
**        encontrados com a insignea U_                                   ***
*****************************************************************************
** DATA      * ANALISTA *  MOTIVO                                         ***
*****************************************************************************
** 31/07/18  * Luis     * procedimentos conforme TDN                      ***
****************************************************************************/
Static Function LerRpo()
  Local aRetType, aRetFile, aRetLine, aRetDate, aRetBType
  aRet := GetFuncArray("u_", aRetType, aRetFile, aRetLine, aRetDate, aRetBType)
  conout("Funcao U_:")
  conout("aRetType  - " + aRetType[1])
  conout("aRetFile  - " + aRetFile[1])
  conout("aRetLine  - " + aRetLine[1])
  conout("aRetDate  - " + cvaltochar(aRetDate[1]))
  conout("aRetBType - " + aRetBType[1])
Return