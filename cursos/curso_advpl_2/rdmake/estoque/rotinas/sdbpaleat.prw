#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SDBPaleat ºAutor  ³Hudson de Souza Santosº Data ³ 23/07/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BGH                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SDBPaleat()
Local cQry := ""
Local aEmail := {}
Local cMsg := ""
Local lResult := .T.
Private cServer  := AllTrim(GetMV("MV_RELSERV"))
Private cEmail   := SubSTR(AllTrim(GetMV("MV_RELACNT")),5) 
Private cPass    := AllTrim(GetMV("MV_RELPSW"))
cEmail := Alltrim(cEmail) + "@bgh.com.br"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query que lista os casos errôneos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQry += " SELECT"
cQry += "  SDB.DB_FILIAL,"
cQry += "  SDB.DB_PRODUTO,"
cQry += "  SDB.DB_LOCAL,"
cQry += "  SDB.DB_LOCALIZ,"
cQry += "  'UPDATE SDB020 SET DB_ESTORNO = ''S'' WHERE R_E_C_N_O_ = ' + convert(VARCHAR(25),SDB.R_E_C_N_O_) as COMANDO"
cQry += " FROM " + RetSQLName("SDB") + " as SDB(NOLOCK)"
cQry += " inner join " + RetSQLName("SD3") + " as SD3(NOLOCK) ON SD3.D_E_L_E_T_ = ''"
cQry += "  AND SDB.DB_FILIAL = SD3.D3_FILIAL"
cQry += "  AND SDB.DB_DOC = SD3.D3_DOC"
cQry += "  AND SDB.DB_PRODUTO = SD3.D3_COD"
cQry += "  AND SDB.DB_NUMSEQ = SD3.D3_NUMSEQ"
cQry += "  AND SDB.DB_TM = SD3.D3_TM"
cQry += "  AND SDB.DB_LOCAL = SD3.D3_LOCAL"
cQry += "  AND SDB.DB_LOCALIZ = SD3.D3_LOCALIZ"
cQry += "  AND SD3.D3_ESTORNO = 'S'"
cQry += " WHERE SDB.D_E_L_E_T_ = ''"
cQry += "  AND SDB.DB_FILIAL = '" + xFilial("SDB") + "'"
cQry += "  AND SDB.DB_ORIGEM = 'SD3'"
cQry += "  AND SDB.DB_ESTORNO = ''"
cQry += "  AND SDB.DB_DATA > (SELECT max(B9_DATA) FROM " + RetSQLName("SB9") + "(NOLOCK) WHERE D_E_L_E_T_ = '' AND B9_FILIAL = DB_FILIAL)"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso Alias esteja em uso, Fecha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("DBQRY") <> 0 
	dbSelectArea("DBQRY")
	dbCloseArea()
Endif                         
TCQUERY cQry NEW ALIAS "DBQRY"
dbSelectArea("DBQRY")
dbGoTop()
While !Eof()
	TcSqlExec(DBQRY->COMANDO)
    aAdd(aEmail,{DBQRY->DB_FILIAL,DBQRY->DB_PRODUTO,DBQRY->DB_LOCAL})
	dbSkip()
EndDo
dbSelectArea("DBQRY")
dbCloseArea()
If Len(aEmail) > 0

	cMsg := "<p>A rotina SDBPaleat encontrou registro(s) na SDB com estorno em branco por&eacute;m o registro referente na SD3 esta marcado como estornado.</p>"
	cMsg += "<p>O campo DB_ESTORNO foi marcado como 'S' por&eacute;m é necess&aacute;rio ajustar o saldo atual.</p>"
	cMsg += "<p>Segue caso(s):</p>"
	cMsg += '<table border="1"><tr><th>FILIAL</th><th>PRODUTO</th><th>ARMAZ&Eacute;M</th></tr>'
	For nX := 1 to Len(aEmail)
		cMsg += "<tr>"
		cMsg += "<td>"+aEmail[nX,1]+"</td>"
		cMsg += "<td>"+aEmail[nX,2]+"</td>"
		cMsg += "<td>"+aEmail[nX,3]+"</td>"
		cMsg += "</tr>"
	Next nX
	cMsg += "</table>"
Else
	cMsg := "<p>A rotina SDBPaleat rodou e não encontrou nenhuma anomalia. Segue Query utilizada:</p>"
	cMsg += "<cite>" + cQry + "</cite>"
EndIf

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResult
SEND MAIL FROM cEmail TO "sistemas@bgh.com.br" SUBJECT "Rotina de estorno SDB" BODY cMsg RESULT lResult
DISCONNECT SMTP SERVER
Return