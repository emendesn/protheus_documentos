#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CONFPARAM³ Autor ³   CLAUDIA CABRAL      ³ Data ³  11/11/08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ ATUALIZA O MV_DATAFIN E MV_DATAFIS                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³  CONTABIL E FISCAL                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ConfParam()

//*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Declaração de cVariable dos componentes
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/                  
Local ncount := 0
Private cDtFin := dDatabase
Private cDtFis := dDatabase
Private aGrupos := aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut := .F.  //Usuarios de Autorizado a entrar com NF-Compras
Private lUsrAdm	:= .F.	 //Usuarios de Autorizado a entrar com NF-Compras
Private lUsrfinAut := .F.
Private lUsrestAut := .F.
Private lUsrfisAut := .F.
Private lUsrbloqAut := .F.          

u_GerA0003(ProcName())              


cDtFin   := GetNewPar("MV_DATAFIN")
cDtFis   := GetNewPar("MV_DATAFIS")
cDtEst   := GetNewPar("MV_ULMES")
cDtBlEst := GetNewPar("MV_DBLQMOV")

//*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Declaração de Variaveis Private dos Objetos
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oGet1","oGet2","oGet3","oGet4","oSBtn1","oSBtn2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to Len(aGrupos)
	
	If AllTrim(GRPRetName(aGrupos[i])) $ "FinanParam"
		lUsrfinAut := .T.
		ncount:=ncount+1
	EndIf
	
	//Next i
	
	If AllTrim(GRPRetName(aGrupos[i])) $ "FiscParam"
		lUsrfisAut := .T.
		ncount:=ncount+1
	EndIf
	
	//Next i
	
	If AllTrim(GRPRetName(aGrupos[i])) $ "EstqParam"
		lUsrestAut := .T.  
		ncount:=ncount+1
	EndIf
	
	///Next i
	
	If AllTrim(GRPRetName(aGrupos[i])) $ "BloqParam"
		lUsrbloqAut := .T.
		ncount:=ncount+1
	EndIf
	                                                                                   
Next i

lUsrfinAut := .T.
lUsrestAut := .T.
lUsrfisAut := .T.
lUsrbloqAut := .T.          
ncount := 4

If ncount == 0 
  MsgAlert("Você não pertence a nenhum grupo especifico para usar essa rotina. Contate o Administrado do Sistema")
  return 
Endif

//*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Definicao do Dialog e todos os seus componentes.
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

If ncount == 4

  oDlg1 := MSDialog():New( 089,232,310,576,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
  oGrp1 := TGroup():New( 000,000,104,164,"Parâmetros",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )//* Utilize a classe tGroup para criar um painel onde controles visuais podem ser agrupados ou classificados. Criada uma borda com título em volta dos controles agrupados.

Elseif ncount == 3

    oDlg1 := MSDialog():New( 089,232,310,576,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
    oGrp1 := TGroup():New( 000,000,104,164,"Parâmetros",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )//* Utilize a classe tGroup para criar um painel onde controles visuais podem ser agrupados ou classificados. Criada uma borda com título em volta dos controles agrupados.

Elseif  ncount == 2
    oDlg1 := MSDialog():New( 089,232,310,576,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
    oGrp1 := TGroup():New( 000,000,104,164,"Parâmetros",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )//* Utilize a classe tGroup para criar um painel onde controles visuais podem ser agrupados ou classificados. Criada uma borda com título em volta dos controles agrupados.

Elseif  ncount == 1

    oDlg1 := MSDialog():New( 089,232,310,576,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
    oGrp1 := TGroup():New( 000,000,104,164,"Parâmetros",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )//* Utilize a classe tGroup para criar um painel onde controles visuais podem ser agrupados ou classificados. Criada uma borda com título em volta dos controles agrupados.

Endif

if lUsrfinAut 
    oSay1 := TSay():New( 020,024,{||"Financeiro :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet1 := TGet():New( 020,086,{|u| If(PCount()>0,cDtFin:=u,cDtFin)},oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtFin",,)
Else
	oGet1 := TGet():New( 020,086,{|u| If(PCount()>0,cDtFin:=u,cDtFin)},oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.F.,"",,,.F.,.F.,,.F.,.F.,"","cDtFin",,)
Endif

if	lUsrfisAut 
	oSay2      := TSay():New( 035,024,{||"Fiscal :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet2      := TGet():New( 035,086,{|u| If(PCount()>0,cDtFis:=u,cDtFis)},oGrp1,044,008,'',, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtFis",,)
Else
	oGet2      := TGet():New( 035,086,{|u| If(PCount()>0,cDtFis:=u,cDtFis)},oGrp1,044,008,'',, CLR_BLACK,CLR_WHITE,,,,.F.,"",,,.F.,.F.,,.F.,.F.,"","cDtFis",,)
Endif

if 	lUsrestAut     
	oSay3      := TSay():New( 050,024,{||"Fechamento Estoque :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet3      := TGet():New( 050,086,{|u| If(PCount()>0,cDtEst:=u,cDtEst)},oGrp1,044,008,'',{ |X| CHKPARAM(cDtEst)},CLR_BLACK,CLR_WHITE,,,,.F.,"",,,.F.,.F.,,.F.,.F.,"","cDtEst",,)  // campo desabilitado em 01//02/2010, conf. solicitado p. Carlos Rocha.	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Bloqueio do parâmetro MV_ULMES³
	//³D.FERNANDES - GLPI 15738      ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	cMens := "o campo  FECHAMENTO DE ESTOQUE não pode mais ser alterado pelo usuário "
	cMens += "qualquer dúvida entre em contato com departamento de T.I."	
	Aviso("Fechamento Estoque",cMens,{"OK"})

Else
	oGet3      := TGet():New( 050,086,{|u| If(PCount()>0,cDtEst:=u,cDtEst)},oGrp1,044,008,'',{ |X| CHKPARAM(cDtEst)},CLR_BLACK,CLR_WHITE,,,,.F.,"",,,.F.,.F.,,.F.,.F.,"","cDtEst",,)  // campo desabilitado em 01//02/2010, conf. solicitado p. Carlos Rocha.
Endif

if	lUsrbloqAut  
    oSay4      := TSay():New( 065,024,{||"Bloqueio Estoque   :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet4      := TGet():New( 065,086,{|u| If(PCount()>0,cDtBlEst:=u,cDtBlEst)},oGrp1,044,008,'',{ |X| CHKBLEST(cDtBLEst)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtBLEst",,)
Else
	oGet4      := TGet():New( 065,086,{|u| If(PCount()>0,cDtBlEst:=u,cDtBlEst)},oGrp1,044,008,'',{ |X| CHKBLEST(cDtBLEst)},CLR_BLACK,CLR_WHITE,,,,.F.,"",,,.F.,.F.,,.F.,.F.,"","cDtBLEst",,)
Endif

oSBtn1 := SButton():New( 086,056,1,{|| SaveParam()},oGrp1,,"", )
oSBtn2 := SButton():New( 086,092,2,{|| Fim()},oGrp1,,"", )

oDlg1:Activate(,,,.T.)

Return

Static Function SaveParam
Local cDataFin
Local cDataFis
Local cDataEst       
Local ncount :=0 

cDataFin := GravaData(cDtFin,.F.,8)
cDataFis := GravaData(cDtFis,.F.,8)
cDataEst := GravaData(cDtEst,.F.,8)
PutMv ("MV_DATAFIN", cDataFin)
PutMv ("MV_DATAFIS", cDataFis)
PutMv ("MV_ULMES"  , cDataEst)
PutMv ("MV_DBLQMOV", cDtBLEst)
odlg1:end()
Return .t.

Static Function CHKPARAM(cDtEst) 
Local ncount :=0
Local lRet      := .t.
Local cQuery    := ''
Local dDataMax  := GetMv("MV_ULMES")       
IF Select("QRY0") <> 0
	DbSelectArea("QRY0")
	DbCloseArea()
Endif

cQuery := " SELECT TOP 1  B9_FILIAL,B9_LOCAL,MAX(B9_DATA) 'B9_DATA'   "
cQuery += " FROM " + RetSqlName("SB9") + " SB9 (NOLOCK) "
cQuery += " WHERE  SB9.D_E_L_E_T_ = ' '  "
cQuery += " AND  SB9.B9_FILIAL >= '" + Xfilial('SB9') + "' "
cQuery += " AND  SB9.B9_FILIAL <= '" + Xfilial('SB9') + "' "
cQuery += " GROUP BY B9_FILIAL,B9_LOCAL"
TCQUERY cQuery NEW ALIAS "QRY0"

nTotsRec := QRY0->(RECCOUNT())
ProcRegua(nTotsRec)
While !QRY0->(Eof())
	dDataMax := QRY0->B9_DATA
	QRY0->(DbSkip())
EndDo
If DtoS(cDtEst) < dDataMax .or. DtoS(cDtEst) == '' // Data digitada menor que o ultimo fechamento - NAO PODE
	MsgAlert("O parametro do estoque nao pode se menor que o ultimo fechamento ou estar em branco. Data do ultimo fechamento "+DTOC(stod(DDATAMAX)))
    
EndIf

oGet3:Refresh() 

IF Select("QRY0") <> 0
	DbSelectArea("QRY0")
	DbCloseArea()
Endif

Return lRet

Static Function CHKBLEST(cDtBLEst)
Local lRet := .t.      
Local ncount :=0

If cDtBlEst < cDtEst
	lRet := .F.
	MsgAlert("A data de bloqueio de estoque nao pode ser anterior ao fechamento do estoque !" )
EndIf
Return lRet

Static Function Fim()    

odlg1:end()
Return .t.
