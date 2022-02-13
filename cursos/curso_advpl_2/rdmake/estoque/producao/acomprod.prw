#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ACOMPROD ³ Autor ³ Delta Decisao(Eduardo B.)Data³ 30/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de Acompanhamento de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BGH - Especifico                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function ACOMPROD( )
PRIVATE cOldAlias:=Alias()
PRIVATE lContinua:= .T.
PRIVATE	cTrab 	:= ""
PRIVATE	cIndex	:= CriaTrab(NIL,.F.)
PRIVATE	cKey	:= ""
PRIVATE cCondicao := ""
PRIVATE cPictQuant:=PesqPictQt("ZZY_QTDSEP",12)
PRIVATE oDlgProd
PRIVATE nTamCod   := TamSX3("B1_COD")[1]
PRIVATE _aFasScrap  := {} // Fases que possuem Scrap

PRIVATE 	aRotina   := { { "" , "        ", 0 , 2}}
PRIVATE aTela[0][0],aGets[0]
PRIVATE bCampo := { |nField| Field(nField) }
PRIVATE CurLen,nPosAtu:=0,nPosAnt:=9999,nColAnt:=9999
PRIVATE cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP
Private cPerg := "ACOMPRO"

PRIVATE cCadastro:=OemToAnsi("Acompanhamento Producao Radios ")	//"Acompanhamento de Produ‡„o"

u_GerA0003(ProcName())

ValPerg(cPerg)
If !Pergunte(cPerg,.T.)
   Return
Endif

MsgRun("Selecionando Documentos ","Aguarde....",{||fGeraTrb()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do AHeader.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aHeader := {}
aAdd(aHeader,{" ","LEGENDA","@BMP",2,0,,,"C",,"V"})
Aadd(aHeader,{"Documento"      ,"DOCUMENTO"  ,PesqPict("ZZY","ZZY_NUMDOC",09),09,0,"",USADO,"C",,""})
Aadd(aHeader,{"Modelo"         ,"MODELO"     ,PesqPict("ZZY","ZZY_CODPLA",15),15,0,"",USADO,"C",,""})
Aadd(aHeader,{"Qtd Pla+Scrap"  ,"QTDPLA"     ,PesqPictQt("ZZY_QTDSEP",14)    ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Qtd Produzida"  ,"QTDPRO"     ,PesqPictQt("ZZY_QTDSEP",14)    ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Scrap"          ,"SCRAP"      ,PesqPictQt("ZZY_QTDSEP",14)    ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Saldo Laborator"  ,"SALPRO"    ,PesqPictQt("ZZY_QTDSEP",14)  ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Qtd Separada  " ,"QTDSEP"     ,PesqPictQt("ZZY_QTDSEP",14)    ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Saldo a Separar","SALSEP"     ,PesqPictQt("ZZY_QTDSEP",14)    ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Scrap Planejado","SCRAPLA"    ,PesqPictQt("ZZY_QTDSEP",14)    ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Qtd Devolvida"  ,"QTDDEV"     ,PesqPictQt("ZZY_QTDDEV",14)    ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Emissao"        ,"EMISSAO"    ,PesqPictQt("ZZY_QTDSEP",14)    ,14,0,"",USADO,"N",,""})
Aadd(aHeader,{"Descricao"      ,"DESC"       ,PesqPict("SB1","B1_DESC",20)   ,20,0,"",USADO,"C",,""})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aCols := {}
Curlen:=70-( TRB->(FCount()) )

oMainWnd:CoorsUpdate()

DEFINE MSDIALOG oDlgProd TITLE cCadastro From 9,0 to oMainWnd:nHeight - 160,oMainWnd:nWidth - 20 OF oMainWnd PIXEL

aColBut := A710PosButton(oDlgProd, 6, 46)
nLinBut := (oDlgProd:nBottom/2)-35

oGetDb := MsGetDB():New(20,1,(oDlgProd:nHeight / 2) - 50,(oDlgProd:nWidth / 2) - 4,1,"AllwaysTrue","AllwaysTrue",,,,,,,"TRB")

//@ nLinBut, aColBut[1] BUTTON "Master" SIZE 46 ,10  FONT oDlgProd:oFont ACTION M080Emp()   OF oDlgProd PIXEL
@ nLinBut, aColBut[1] BUTTON "Legenda"      SIZE 46 ,10  FONT oDlgProd:oFont ACTION ACOMLEG() OF oDlgProd PIXEL
@ nLinBut, aColBut[2] BUTTON "Relatorio"    SIZE 46 ,10  FONT oDlgProd:oFont ACTION U_ACOMPROR() OF oDlgProd PIXEL   //"Perdas"
@ nLinBut, aColBut[3] BUTTON "Prod.Diaria"  SIZE 46 ,10  FONT oDlgProd:oFont ACTION U_ACOMPRDI() OF oDlgProd PIXEL   //"Perdas"
@ nLinBut, aColBut[4] BUTTON "Detalhe Imei" SIZE 46 ,10  FONT oDlgProd:oFont ACTION U_ACOMPRIM() OF oDlgProd PIXEL   //"Perdas"


//DEFINE SBUTTON FROM nLinBut,aColBut[6] + 15  TYPE 6 ACTION (C080Rel(),oDlgProd:End())	ENABLE OF oDlgProd

ACTIVATE MSDIALOG oDlgProd CENTERED ON INIT EnchoiceBar(oDlgProd,{|| oDlgProd:End()},{||oDlgProd:End()})

If SELECT("TRB") <> 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif


RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACOMLEG    ºAutor ³Eduardo Barbosa-Deltaº Data ³  02/03/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Legenda do Browser                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ACOMLEG()

Local aCores := {}

aCores := {{"ENABLE",OemToAnsi("Produção Finalizada")},;
{"BR_AZUL",OemToAnsi("Produção Iniciada")},;
{"BR_AMARELO",OemToAnsi("Nao Separado")},;
{"DISABLE",OemToAnsi("Produçao Nao Iniciada")}}

BrwLegenda(OemToAnsi("Acompanhamento de Produção"),OemToAnsi("Status Produção"),aCores)

Return(.T.)



Static Function FGeraTRB()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho para mostrar consulta               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aCampos   :={}

AADD(aCampos,{"LEGENDA"     ,"C",15,0})
AADD(aCampos,{"DOCUMENTO"   ,"C",09,0})
AADD(aCampos,{"MODELO"		,"C",nTamCod,0})
AADD(aCampos,{"QTDPLA"		,"N",14,0})
AADD(aCampos,{"QTDPRO"		,"N",14,0})
AADD(aCampos,{"SALPRO"		,"N",14,0})
AADD(aCampos,{"QTDSEP"		,"N",14,0})
AADD(aCampos,{"SALSEP"		,"N",14,0})
AADD(aCampos,{"DESC"		,"C",20,0})
AADD(aCampos,{"SCRAP"		,"N",14,0})
AADD(aCampos,{"QTDMAS"		,"N",14,0})
AADD(aCampos,{"SCRAPLA"		,"N",14,0})
AADD(aCampos,{"QTDDEV"		,"N",14,0})
AADD(aCampos,{"EMISSAO"		,"D",08,0})


cTrab:=CriaTrab(aCampos)
_cIndex := Criatrab(,.F.)
If SELECT("TRB") <> 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

dbUseArea(.T.,,cTrab,"TRB",.T.,.F.)
IndRegua("TRB",_cIndex,"DOCUMENTO",,,"Criando Indice")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho Para Armazenar dados da Produção Diaria
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos   :={}

AADD(aCampos,{"DOCUMENTO"   ,"C",09,0})
AADD(aCampos,{"MODELO"		,"C",nTamCod,0})
AADD(aCampos,{"DESC"		,"C",20,0})
AADD(aCampos,{"DATALANC" 	,"D",08,0})
AADD(aCampos,{"CELULA"		,"C",06,0})
AADD(aCampos,{"TURNO"		,"C",20,0})
AADD(aCampos,{"QTDPROD"		,"N",14,2})
AADD(aCampos,{"QTDSCRA"		,"N",14,2})


cTrabDi:=CriaTrab(aCampos)
_cIndex := Criatrab(,.F.)
If SELECT("TRB1") <> 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif

dbUseArea(.T.,,cTrabDi,"TRB1",.T.,.F.)
//IndRegua("TRB1",_cIndex,"CHAVE",,,"Criando Indice")
IndRegua("TRB1",_cIndex,"DOCUMENTO+DTOS(DATALANC)+CELULA",,,"Criando Indice")

// Montagem da Query Para Selecao Das Fases que são de Scrap

cQuery := " SELECT ZZ1_LAB+ZZ1_CODSET+ZZ1_FASE1 as FASE"
cQuery += " FROM "+RetSqlName("ZZ1")
cQuery += " WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"'"
cQuery += " AND ZZ1_SCRAP='S'"
cQuery += " AND    D_E_L_E_T_= '' "

If SELECT("TRBZZ1") <> 0
	DbSelectArea("TRBZZ1")
	DbCloseArea()
Endif
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBZZ1",.T.,.T.)
DbSelectArea("TRBZZ1")
While ! Eof()
    AADD(_aFasScrap,TRBZZ1->FASE)
    DbSkip()
Enddo

If SELECT("TRBZZ1") <> 0
	DbSelectArea("TRBZZ1")
	DbCloseArea()
Endif


// Montagem da Query Para Selecao dos documentos.

cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName("ZZY")
cQuery += " WHERE  ZZY_FILIAL = '"+xFilial("ZZY")+"'"
cQuery += " AND    ZZY_NUMDOC  BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"
cQuery += " AND    ZZY_EMISSA  BETWEEN '"+DTOS(MV_PAR04)+"' AND '"+DTOS(MV_PAR05)+"'"
cQuery += " AND    ZZY_DATPLA  BETWEEN '"+DTOS(MV_PAR06)+"' AND '"+DTOS(MV_PAR07)+"'"
cQuery += " AND    D_E_L_E_T_= '' "
cQuery += " ORDER BY ZZY_NUMDOC , ZZY_NUMMAS"

If SELECT("TRBSQL") <> 0
	DbSelectArea("TRBSQL")
	DbCloseArea()
Endif

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSQL",.T.,.T.)

TcSetField("TRBSQL","ZZY_QTDPLA","N",14,2)
TcSetField("TRBSQL","ZZY_QTDPER","N",14,2)
TcSetField("TRBSQL","ZZY_DATPLA","D")
TcSetField("TRBSQL","ZZY_EMISSA","D")
TcSetField("TRBSQL","ZZY_QTDSEP","N",14,2)
TcSetField("TRBSQL","ZZY_QTDMAS","N",14,2)


DbSelectArea("TRBSQL")

_lVerProd := IIF(MV_PAR08 == 1,.T.,.F.)

While ! Eof()
	/// Montagem de Query Para Retornar a Quantidades Separadas e Produzidas do Documento.
	_aQtdDoc := U_AnaDocPla(TRBSQL->ZZY_NUMDOC,IIF(Alltrim(TRBSQL->ZZY_NUMMAS) <> "SEM_MASTER",TRBSQL->ZZY_NUMMAS,SPACE(20)),_lVerProd )
	// Retorno Array _aQtdDoc
	// Elemento	Conteudo
	// Elemento [1]Etiqueta Master
	// Elemento [2]Qtde Scrap
	// Elemento [3]Qtde Produzida
	// Elemento [4]Qtde Separada
	
	_nQtdScra:= 0
	_nQtdSep := 0
	_nQtdPro := 0
	If  Len(_aQtdDoc) > 0
		_nQtdScra := _nQtdScra  + _aQtdDoc[2]
		_nQtdPro  := _nQtdPro   + _aQtdDoc[3]
		_nQtdSep  := _nQtdSep   + _aQtdDoc[4]
		
	Endif                
	//_nQtdSep := TRBSQL->ZZY_QTDSEP
	
	DbSelectArea("TRB")
	If DbSeek(TRBSQL->ZZY_NUMDOC)
		RecLock("TRB",.F.)
	Else
		RecLock("TRB",.T.)
		TRB->DOCUMENTO := TRBSQL->ZZY_NUMDOC
		TRB->MODELO	   := TRBSQL->ZZY_CODPLA
		TRB->QTDPLA	   := TRBSQL->(ZZY_QTDPLA+ZZY_QTDPER)
		TRB->EMISSAO   := TRBSQL->ZZY_EMISSA
		TRB->SCRAPLA   := TRBSQL->ZZY_QTDPER
	Endif
	//If TRB->QTDPRO + _nQtdPro > TRB->QTDPLA
	//   TRB->QTDPLA := TRB->QTDPRO + _nQtdPro
	//Endif   
	TRB->SCRAP	   := TRB->SCRAP +  _nQtdScra
	TRB->QTDPRO	   := TRB->QTDPRO + _nQtdPro
	TRB->QTDMAS	   := TRB->QTDMAS + TRBSQL->ZZY_QTDMAS
	TRB->QTDSEP	   := TRB->QTDSEP + _nQtdSep
	TRB->QTDDEV    := TRB->QTDDEV + TRBSQL->ZZY_QTDDEV
	//TRB->SALSEP	   := TRB->QTDMAS - TRB->QTDSEP
	TRB->SALSEP	   := TRB->QTDPLA - TRB->QTDSEP  
	If TRB->SALSEP < 0
	   TRB->SALSEP := 0
	Endif   
	TRB->SALPRO	   := TRB->(QTDPLA - QTDPRO-SCRAP-SALSEP)
	//If TRB->SALPRO < 0
	//   TRB->SALPRO := 0
	//   TRB->QTD
	//Endif
	
	
	If TRB->QTDPLA == TRB->(QTDPRO+SCRAP)
		_cLegenda := "BR_VERDE"
	ElseIf (TRB->QTDPLA <> TRB->(QTDPRO+SCRAP) .AND. TRB->(QTDPRO+SCRAP)) <> 0
		_cLegenda := "BR_AZUL"
	ElseIf TRB->QTDSEP = 0
		_cLegenda := "BR_AMARELO"
	ElseIf TRB->QTDSEP <> 0 .AND. TRB->(QTDPRO+SCRAP) == 0
		_cLegenda := "BR_VERMELHO"
	Endif
	TRB->LEGENDA   := _cLegenda 
	TRB->DESC	   := Posicione("SB1",1,xFilial("SB1")+TRBSQL->ZZY_CODPLA,"B1_DESC")
	msUnlock()
	DbSelectArea("TRBSQL")
	DbSkip()
Enddo
If SELECT("TRBSQL") <> 0
	DbSelectArea("TRBSQL")
	DbCloseArea()
Endif

Return


// Seleciona a quantidade separada e produzida da Master

USER Function AnaDocPla(_cNumDoc,_cMaster,_lDemoProd)

Local _aRet := {_cMaster,0,0,0,{}}
Local _aArea:= GetArea()
DEFAULT _lDemoProd := .F.

// Elementos de Retorno
// Elemento [1]Etiqueta Master
// Elemento [2]Qtde Separada
// Elemento [3]Qtde Produzida

// Montagem da Query Para Selecao da Master

If _lDemoProd  // Demonstra a Producao
	cQuery := " SELECT ZZ4_ETQMEM,ZZ4_OPEBGH,ZZ4_STATUS,ZZ4_SETATU,ZZ4_FASATU,ZZ4_IMEI,ZZ4_OS, 1 AS QTDE ,ZZ4_CODPRO "
Else // analitico
	cQuery := " SELECT ZZ4_ETQMEM,ZZ4_OPEBGH,ZZ4_STATUS,ZZ4_SETATU,ZZ4_FASATU,COUNT(*) AS QTDE  "
Endif
cQuery += " FROM "+RetSqlName("ZZ4")
cQuery += " WHERE ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
cQuery += " AND ZZ4_DOCSEP = '"+_cNumDoc+"'"
cQuery += " AND ZZ4_ETQMEM = '"+_cMaster+"'"
cQuery += " AND ZZ4_STATUS >= '4'"
cQuery += " AND    D_E_L_E_T_= '' "
If !_lDemoProd  // Sintetico
  cQuery += " GROUP BY ZZ4_ETQMEM,ZZ4_OPEBGH,ZZ4_STATUS,ZZ4_SETATU,ZZ4_FASATU "
Endif

If SELECT("TRBZZ4") <> 0
	DbSelectArea("TRBZZ4")
	DbCloseArea()
Endif

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBZZ4",.T.,.T.)

TcSetField("TRBZZ4","QTDE","N",14,0)
DbSelectArea("TRBZZ4")

While ! Eof()
	dbSelectArea("ZZJ")
	dbSetOrder(1)
	dbSeek(xFilial("ZZJ")+TRBZZ4->ZZ4_OPEBGH)
	// Verifica se esta na Fase de Scrap
	_nPosScrap := Ascan(_aFasScrap,ZZJ->ZZJ_LAB+TRBZZ4->(ZZ4_SETATU+ZZ4_FASATU))
	// Qtde Scrap                                                  
	_lScrap := .F.
	_lProd  := .F.
	
	If _nPosScrap > 0 
	   _aRet[2] := _aRet[2] + TRBZZ4->QTDE
	   _lScrap := .T.
	Else
		//Qtde Produzida
		If TRBZZ4->ZZ4_SETATU == "000017"
			_aRet[3] := _aRet[3] + TRBZZ4->QTDE
			_lProd := .T.
		Else
			If TRBZZ4->ZZ4_STATUS >= "5"       
				_aRet[3] := _aRet[3] + TRBZZ4->QTDE
				_lProd := .T.
			Endif
		Endif
	Endif
	// Qtde Separada
	_aRet[4] := _aRet[4] + TRBZZ4->QTDE
	
	If _lDemoProd  // Analitico
	    // Carrega a Matriz Com dados do IMEI
	    Do Case
	       Case _lProd 
	         _cSituaca := "Produzido"
	       Case _lScrap 
	         _cSituaca := "Scrap"
	       OtherWise  
	    	 _cSituaca := "Pendente"
	    Endcase
	    AADD(_aRet[5],{TRBZZ4->ZZ4_IMEI,_cSituaca})
		// Detalhes do Apontamento Diario de Producao ou Scrap
		If _lProd .OR. _lScrap
		   _cChaveZZ3 := xFilial("ZZ3")+TRBZZ4->(ZZ4_IMEI+ZZ4_OS)
		   _lPegaScra := .F.
		   DbSelectArea("ZZ3")
		   DbSetOrder(1)  // ZZ3_FILIAL, ZZ3_IMEI, ZZ3_NUMOS, ZZ3_SEQ, R_E_C_N_O_, D_E_L_E_T_   
		   DbSeek(_cChaveZZ3,.F.)
		   While ! Eof() .AND. ZZ3->(ZZ3_FILIAL+ZZ3_IMEI+ZZ3_NUMOS) == _cChaveZZ3
		         If ZZ3->ZZ3_ENCOS == 'S' .AND. ZZ3->ZZ3_ESTORN <> "S" .OR. _lPegaScra
		            DbSelectArea("TRB1")
		            dbSetOrder(1)
		            If !DbSeek(ZZ3->(_cNumDoc+DTOS(ZZ3->ZZ3_DATA)+ZZ3->ZZ3_CODANA),.F.)
		                _cTurno := Posicione("AA1",1,xFilial("AA1")+ZZ3->ZZ3_CODANA,"AA1_NOMTEC")
			            RecLock("TRB1",.T.)
				            TRB1->DOCUMENTO := _cNumdoc
							TRB1->MODELO	:= TRBZZ4->ZZ4_CODPRO
							TRB1->DESC	    := Posicione("SB1",1,xFilial("SB1")+TRBZZ4->ZZ4_CODPRO,"B1_DESC")
							TRB1->DATALANC  := ZZ3->ZZ3_DATA
							//TRB1->CHAVE  	:= TRBSQL->ZZY_NUMDOC+DTOS(ZZ3->ZZ3_DATA)+ZZ3->ZZ3_CODANA
							TRB1->CELULA	:= ZZ3->ZZ3_CODANA 
							TRB1->TURNO		:= _cTurno
							If _lProd       
								TRB1->QTDPROD := 1
							Else
						   		 TRB1->QTDSCRA:= 1
						   		 _lPegaScra := .T.
							Endif	
		            	MsUnlock()
		            Else
		            	RecLock("TRB1",.F.)
							If _lProd       
								TRB1->QTDPROD := TRB1->QTDPROD  + 1 
							Else
						   		TRB1->QTDSCRA:= TRB1->QTDSCRA + 1 
						   		_lPegaScra := .T.
							Endif	
	        	    	MsUnlock()
	            	Endif
		            Exit
		         Endif
		         DbSelectArea("ZZ3")
		         DbSkip()
		         // Pega Scrap Caso o Apontamento seja de Scrap mas a Ordem de Servico nao esta encerrada
		         If ZZ3->(ZZ3_FILIAL+ZZ3_IMEI+ZZ3_NUMOS) <>  _cChaveZZ3 .AND. _lScrap .AND. ! _lPegaScra
		            _lPegaScra := .T.
		            DbSkip(-1)
		         Endif
		   Enddo
		Endif
	Endif
	DbSelectArea("TRBZZ4")
	DbSkip()
Enddo

If SELECT("TRBZZ4") <> 0
	DbSelectArea("TRBZZ4")
	DbCloseArea()
Endif
RestArea(_aArea)


Return _aRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VALPERG ³ Autor ³ Ricardo Berti         ³ Data ³21/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria pergunta para o grupo			                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValPerg(cPerg)

Local aHelp	:= {}

PutSx1(cPerg, '01', 'Status Producao     ?','' ,'' , 'mv_ch1', 'N', 1 , 0,1 ,'C', '', '', '','',  'mv_par01',"Em Aberto"," "," ","","Fechado","","","Ambos","","","","","")
PutSx1(cPerg, '02', 'Documento de        ?','' ,'' , 'mv_ch2', 'C', 9, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Documento Ate       ?','' ,'' , 'mv_ch3', 'C', 9, 0, 0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Emissao de          ?','' ,'' , 'mv_ch4', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Emissao Ate         ?','' ,'' , 'mv_ch5', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Planejamento de     ?','' ,'' , 'mv_ch6', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '07', 'Planejamento Ate    ?','' ,'' , 'mv_ch7', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par07',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '08', 'Producao Diaria     ?','' ,'' , 'mv_ch8', 'N', 1 , 0,1 ,'C', '', '', '','',  'mv_par08',"Sim"," "," ","","Nao","","","","","","","","")
PutSx1(cPerg, '09', 'Producao de         ?','' ,'' , 'mv_ch9', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par09',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '10', 'Producao Ate        ?','' ,'' , 'mv_cha', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par10',,,'','','','','','','','','','','','','','')


Return          
