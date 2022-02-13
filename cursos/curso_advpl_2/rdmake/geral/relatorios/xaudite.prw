#Include "PROTHEUS.CH"
#include 'topconn.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XAUDIT   ³ Autor ³ Claudia Cabral        ³ Data ³ 01/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o DO LOG DO AUDIT TRAIL             - especifico      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.	/  .F.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Xaudit()
Local nSavRec:=Recno(),cOldAlias := Alias()
Local oDlg,oLbx,lRet := .F.
pRIVATE aArqs := {},cFilter := "",cArq := "",nArq         
Private cCadastro := "Consulta Log Audit Trail"  
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
PRIVATE aRotina := {{ OemToAnsi("Pesquisar") ,"AxPesqui"  , 0 , 1},; //"Pesquisar" 
	{ OemToAnsi("Imprimir"),"U_AudImp" 	, 0 , 2}  }	// "Imprimir"

u_GerA0003(ProcName())

DbSelectarea("SX2")
cFilter := DbFilter()
DbClearFil()
dbGotop()

SX3->(dbSetOrder(2))
While !Eof()
	AADD(aArqs,{X2_CHAVE ,OemToAnsi(Capital(X2Nome()))})
	DbSkip()
End
SX3->(dbSetOrder(1))
IF Len(aArqs) == 0
	Help(" ",1,"NOUSERLOG")
	Return .t.
Endif
While .T.
	lRet := .F.
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Monta a tela de Bancos de Dados                              ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg FROM  10,15 TO 23,53 TITLE OemToAnsi("CONSULTA LOG AUDIT TRAIL") 

	@ 11,12 LISTBOX oLbx FIELDS HEADER OemToAnsi("ARQUIVO"),OemToAnsi("DESCRICAO")  SIZE 131, 69 OF oDlg PIXEL ; 
				ON CHANGE (nArq:=oLbx:nAt) ON DBLCLICK (lRet := .T.,nArq := oLbx:nAt,oDlg:End()) 
	oLbx:SetArray(aArqs)
	oLbx:bLine := { || {aArqs[oLbx:nAt,1],aArqs[oLbx:nAt,2]}}

	DEFINE SBUTTON FROM 83, 88  TYPE 1  ENABLE OF oDlg ACTION (lRet := .T.,nArq := oLbx:nAt,oDlg:End()) 
	DEFINE SBUTTON FROM 83, 116 TYPE 2  ENABLE OF oDlg ACTION (lRet := .F.,oDlg:End()) 

	ACTIVATE MSDIALOG oDlg CENTERED
	If !lRet
		Exit
	Endif
			
	cArq := SubStr(aArqs[nArq,1],1,3)
	If !SelArq(cArq)
		Loop
	Endif
	
	mBrowse( 6, 1,22,75,cArq,,,,"!Deleted()")

	dbSelectArea(cArq)
	dbCloseArea()
Enddo
dbSelectArea("SX2")	
Set FIlter to &cFilter
DbSelectarea(cOldAlias)
dbgoto(nSavRec)                 

Return .t.

User function AudImp()
Local cQry1 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local cQuery := ''         
Local nTotsRec  := 0                   
Local cChave := ''
Local cMostra := ''
Local nat := 0
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif                               
/*
_nCon1 := TCLink("MSSQL7/AUDIT", "TOPAUDIT")
_nCon2 := TCLink("MSSQL7/PROTHEUS", "TOPPV10")

If (_nCon1 < 0)
   CONOUT("Falha Conexao TOPCONN 1 - Erro: "+ str(_nCon1, 10, 0))
EndIf
If (_nCon2 < 0)
   CONOUT("Falha Conexao TOPCONN 2 - Erro: "+ str(_nCon2, 10, 0))
EndIf

//USE CLIENTES VIA "TOPCONN" NEW // Tabela de clientes será aberto em _nCon1
//TCSETCONN(_nCon1)
*/
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
cQuery := " SELECT AT_RECID,AT_DATE,AT_TIME,AT_NAME,AT_FIELD,AT_CONTENT,AT_TABLE "
cQuery += " FROM [AUDIT].[dbo].AUDIT_TRAIL AUD (NOLOCK) "
//cQuery += " INNER JOIN " + RETSQLNAME(&CARQ) + " ZZ8 (NOLOCK) "
//cQuery += " ON AT_RECID ='" + CARQ +"'.R_E_C_N_O_"
cQuery += " WHERE AT_TABLE  = '" + RETSQLNAME(CARQ) + "' AND AUD.D_E_L_E_T_ = '' "
//cQuery += "AND AT_RECID ='" + CARQ ->(RECNO()) + "' " 
cQuery += " GROUP BY AT_RECID,AT_DATE,AT_NAME,AT_TIME,AT_FIELD,AT_CONTENT,AT_TABLE "
TCQUERY cQuery NEW ALIAS "QRY1"  

//USE CLIENTES VIA "TOPCONN" NEW // Tabela de clientes será aberto em _nCon2
//TCSETCONN(_nCon2)


cLinha := " ************* LOG AUDIT TRAIL  ************* " 
fWrite(nHandle, cLinha  + cCrLf)
cLinha := 'Tabela'           + ';'
cLinha += 'Data'       + ';'
cLinha += 'Hora'             + ';'
cLinha += 'Usuario'     + ';'
cLinha += 'Registro alterado'          + ';'
cLinha += 'Chave'          + ';'
cLinha += 'Conteudo'
fWrite(nHandle, cLinha  + cCrLf)

DbSelectArea(cArq)      
DbSetOrder(1)
cMostra := Indexkey()
	
DbSelectArea("QRY1")
nTotsRec := QRY1->(RECCOUNT())
ProcRegua(nTotsRec)               
cChave := "#$#$#$#$#$#"
While !QRY1->(Eof())
	IncProc()                                               
	If cchave <> QRY1->(AllTrim(str(AT_RECID))+ AT_DATE+AT_NAME+AT_TIME)	
		cLinha := QRY1->AT_TABLE + ';'    
		cLinha += QRY1->AT_DATE + ';'
		cLinha += QRY1->AT_TIME+ ';'
		cLinha += QRY1->AT_NAME +';'	
		cLinha += ' ' + ';'
		DbSelectArea(cArq)
		(DbGoto(QRY1->AT_RECID))
		cLinha += cMostra + ';' 		
		cLinha += &cMostra  +';'                     
		fWrite(nHandle, cLinha  + cCrLf)
		cChave = QRY1->(AllTrim(str(AT_RECID))+ AT_DATE+AT_NAME+AT_TIME)	
		nAt := 0
	Endif
	Do While !Eof() .and. cChave = QRY1->(AllTrim(str(AT_RECID))+ AT_DATE+AT_NAME+AT_TIME)	
              
		cLinha := '' + ';'    
		cLinha += '' + ';'
		cLinha += ''+ ';'
		cLinha += '' +';'		
		cLinha += QRY1->AT_FIELD + ';'
		cLinha += QRY1->AT_CONTENT + ';'
		fWrite(nHandle, cLinha  + cCrLf)
		QRY1->(DbSkip())
	EndDo	
	//fWrite(nHandle, cLinha  + cCrLf)						
	//QRY1->(DBSKIP())
Enddo               
fClose(nHandle)
//CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
   //	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) // Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   

RETURN .T.


Static Function SelArq(cArq)
Local  i
DbSelectArea("SX2")
DbSeek(cArq)
cArquivo := RetArq(__cRdd,AllTrim(x2_path)+AllTrim(x2_arquivo),.t.)
If !MSFile(cArquivo)
	Help("",1,"NOFILE")
	Return .F.
Else
	If Select(cArq) == 0
		If !ChkFile(cArq,.F.)
			Help("",1,"ABREEXCL")
			Return .F.		
		Endif
	Else
		dbselectarea(cArq)
	endif
Endif
Return .T.