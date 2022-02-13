#Include "Rwmake.ch"

/*
+------------+---------+--------+---------------+-------+--------------+
| Programa:  |GPE10BTN | Autor: | Rogerio Alves | Data: |  Agosto/2013 |
+------------+---------+--------+---------------+-------+--------------+
| Descrição: | Ponto de entrada para cadastro de funcionarios a partir |
|            | do cadastro de temporários da filial 03                 |
+------------+---------------------------------------------------------+
| Uso:       | BGH                                                     |
+------------+---------------------------------------------------------+
*/

User Function GPE10BTN

Local nOpc

Private cMatricula := ""

If Inclui .and. cFilant != "03"
	
	If MsgYesNo("Importar de temporários ?")
		nOpc := .T.
	Else
		nOpc := .F.
	EndIf
	
	If nOpc
		
		DbSelectArea("SRA")
		DbSetOrder(1)
		
		U_MkBrow()
		
		If !Empty(cMatricula)
			
			DbSelectArea("SRA")
			DbSetOrder(1)
			Dbseek ("03" + cMatricula , .T.)
			
			RECLOCK("SRA",.F.)
			SRA->RA_SITFOLH := "D"
			SRA->RA_DEMISSA := dDataBase
			MSUNLOCK()
			
			M->RA_PIS        	:= SRA->RA_PIS
			M->RA_NOME		 	:= SRA->RA_NOME
			M->RA_CIC		 	:= SRA->RA_CIC
			M->RA_RG		 	:= SRA->RA_RG
			M->RA_NUMCP		 	:= SRA->RA_NUMCP
			M->RA_SERCP		 	:= SRA->RA_SERCP
			M->RA_UFCP		 	:= SRA->RA_UFCP
			M->RA_HABILIT		:= SRA->RA_HABILIT
			M->RA_RESERVI		:= SRA->RA_RESERVI
			M->RA_TITULOE		:= SRA->RA_TITULOE
			M->RA_ZONASEC		:= SRA->RA_ZONASEC
			M->RA_ENDEREC		:= SRA->RA_ENDEREC
			M->RA_COMPLEM		:= SRA->RA_COMPLEM
			M->RA_BAIRRO		:= SRA->RA_BAIRRO
			M->RA_MUNICIP		:= SRA->RA_MUNICIP
			M->RA_ESTADO		:= SRA->RA_ESTADO
			M->RA_CEP		 	:= SRA->RA_CEP
			M->RA_TELEFON		:= SRA->RA_TELEFON
			M->RA_PAI		 	:= SRA->RA_PAI
			M->RA_MAE		 	:= SRA->RA_MAE
			M->RA_SEXO		 	:= SRA->RA_SEXO
			M->RA_ESTCIVI		:= SRA->RA_ESTCIVI
			M->RA_NATURAL		:= SRA->RA_NATURAL
			M->RA_NACIONA		:= SRA->RA_NACIONA
			M->RA_ANOCHEG		:= SRA->RA_ANOCHEG
			M->RA_NASC		 	:= SRA->RA_NASC
//			M->RA_BCDEPSA		:= SRA->RA_BCDEPSA
//			M->RA_CTDEPSA		:= SRA->RA_CTDEPSA
			M->RA_ADTPOSE		:= SRA->RA_ADTPOSE
			M->RA_CESTAB		:= SRA->RA_CESTAB
			M->RA_PENSALI		:= SRA->RA_PENSALI
			M->RA_ASMEDIC		:= SRA->RA_ASMEDIC
			M->RA_FAIXA		 	:= SRA->RA_FAIXA
			M->RA_PERCADT		:= SRA->RA_PERCADT
			M->RA_VALEREF		:= SRA->RA_VALEREF
			M->RA_SEGUROV		:= SRA->RA_SEGUROV
			M->RA_TIPOPGT		:= SRA->RA_TIPOPGT
			M->RA_RGORG		 	:= SRA->RA_RGORG
			M->RA_RACACOR		:= SRA->RA_RACACOR
			M->RA_RECMAIL		:= SRA->RA_RECMAIL
			M->RA_EMAIL		 	:= SRA->RA_EMAIL
			M->RA_TPMAIL		:= SRA->RA_TPMAIL
			M->RA__PLR		 	:= SRA->RA__PLR
			M->RA_TPDEFFI		:= SRA->RA_TPDEFFI
			M->RA_NOMECMP		:= SRA->RA_NOMECMP
			M->RA_RGEXP		 	:= SRA->RA_RGEXP
			M->RA_RGUF		 	:= SRA->RA_RGUF
			M->RA_NUMINSC		:= SRA->RA_NUMINSC
			M->RA_SERVICO		:= SRA->RA_SERVICO
			M->RA_ORGEMRG		:= SRA->RA_ORGEMRG
			M->RA_CODUNIC		:= SRA->RA_CODUNIC
			M->RA_DTCPEXP		:= SRA->RA_DTCPEXP
			M->RA_REGIME		:= SRA->RA_REGIME
			M->RA_FWIDM		 	:= SRA->RA_FWIDM
			M->RA_DTRGEXP		:= SRA->RA_DTRGEXP
			M->RA_HOPARC		:= SRA->RA_HOPARC
			M->RA_CLAURES		:= SRA->RA_CLAURES
			M->RA_MUNNASC		:= SRA->RA_MUNNASC
			M->RA_COMPSAB		:= SRA->RA_COMPSAB
			M->RA_ASSIST		:= SRA->RA_ASSIST
			M->RA_CONFED		:= SRA->RA_CONFED
			M->RA_MENSIND		:= SRA->RA_MENSIND
			M->RA__VRTOT1		:= SRA->RA__VRTOT1
			M->RA__VRTOT2		:= SRA->RA__VRTOT2
			M->RA_BCDPFGT 		:= SRA->RA_BCDPFGT
			M->RA_CTDPFGT		:= SRA->RA_CTDPFGT
			M->RA_SITFOLH 		:= " "
			M->RA_DEMISSA 		:= ctod("  /  /  ")
			
		EndIf
		
	EndIf
	
EndIf

Return


User Function MkBrow()

Local _astru:={}
Local _afields:={}
Local _carq
Local oMark
Local cIndex
Local cAlias := "SRA"

Private arotina := {}
Private cCadastro
Private cMark := GetMark()


Private aRotina   := { 	{ "Sair"  			, "U_FechaA"	, 0 , 1},;
						{ "Efetivar"		, "U_Fecha" 	, 0	, 2}}


cCadastro := "Arquivo Temporario"

//ª Estrutura da tabela temporaria

AADD(_astru,{"RA_OK"		,"C",2	,0})
aTam:=TamSX3("RA_FILIAL")
AADD(_astru,{"RA_FILIAL"	,aTam[3],aTam[1],aTam[2]})
aTam:=TamSX3("RA_MAT")
AADD(_astru,{"RA_MAT"		,aTam[3],aTam[1],aTam[2]})
aTam:=TamSX3("RA_NOME")
AADD(_astru,{"RA_NOME"		,aTam[3],aTam[1],aTam[2]})

// cria a tabela temporária
_carq:="T_"+Criatrab(,.F.)
MsCreate(_carq,_astru,"DBFCDX")

cIndex := E_Create(_cArq,.F.)

// atribui a tabela temporária ao alias TRB1
dbUseArea(.T.,"DBFCDX",_cARq,"TRB1",.T.,.F.)

IndRegua("TRB1",cIndex,"RA_FILIAL+RA_MAT",,,"Criando Indice...")
DbSetIndex(cIndex+OrdBagExt())

//cria indice temporário
Dbselectarea("SRA")
Set Filter To SRA->RA_FILIAL == "03" .and. SRA->RA_SITFOLH != "D"

Dbselectarea("SRA")
DBGOTOP()

WHILE !EOF()
	
	DBSELECTAREA("TRB1")
	If SRA->RA_FILIAL != "03"
		DBSELECTAREA("SRA")
		DBSKIP()
		Loop
	EndIf
	
	RECLOCK("TRB1",.T.)
	TRB1->RA_OK 	:= "  "
	TRB1->RA_FILIAL	:= SRA->RA_FILIAL
	TRB1->RA_MAT	:= SRA->RA_MAT
	TRB1->RA_NOME	:= SRA->RA_NOME
	MSUNLOCK()
	DBSELECTAREA("SRA")
	DBSKIP()
	
ENDDO

AADD(_afields,{"RA_OK","",""})
AADD(_afields,{"RA_FILIAL","","Filial"})
AADD(_afields,{"RA_MAT","","Matricula"})
AADD(_afields,{"RA_NOME","","Nome"})

DbSelectArea("TRB1")

MarkBrow( 'TRB1','RA_OK',/*3*/,_afields,/*5*/, cMark,/*'u_MarkAll()'*/,/*8*/,/*9*/,/*10*/,'u_Mark()',/*{|| u_MarkAll()}*/,/*13*/,/*14*/,/*aCores*/,/*16*/,/*17*/,/*18*/,.F.)

DbSelectArea("TRB1")
DbCloseArea()

// apaga a tabela temporário
MsErase(_carq+GetDBExtension(),,"DBFCDX")

Dbselectarea("SRA")
Set Filter To

Return


// Grava marca no campo
User Function Mark()

Local cMat	:= TRB1->RA_MAT

If IsMark( 'RA_OK', cMark )
	
	RecLock( 'TRB1', .F. )
	Replace RA_OK With Space(2)
	MsUnLock()
	
	cMatricula := ""
	
Else
	
	RecLock( 'TRB1', .F. )
	Replace RA_OK With cMark
	MsUnLock()
	
	cMatricula := TRB1->RA_MAT
	
EndIf

Return


// Grava marca em todos os registros validos
User Function MarkAll()

Local oMark := GetMarkBrow()

dbSelectArea('TRB1')
dbGotop()

While !Eof()
	RecLock( 'TRB1', .F. )
	Replace RA_OK With Space(2)
	MsUnLock()
	dbSkip()
EndDo

MarkBRefresh( )
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return

User Function Fecha

cMatricula := TRB1->RA_MAT

CloseBrowse()

Return

User Function FechaA

If !Empty(cMatricula)
	
	M->RA_PIS        	:= ""
	M->RA_NOME		 	:= ""
	M->RA_CIC		 	:= ""
	M->RA_RG		 	:= ""
	M->RA_NUMCP		 	:= ""
	M->RA_SERCP		 	:= ""
	M->RA_UFCP		 	:= ""
	M->RA_HABILIT		:= ""
	M->RA_RESERVI		:= ""
	M->RA_TITULOE		:= ""
	M->RA_ZONASEC		:= ""
	M->RA_ENDEREC		:= ""
	M->RA_COMPLEM		:= ""
	M->RA_BAIRRO		:= ""
	M->RA_MUNICIP		:= ""
	M->RA_ESTADO		:= ""
	M->RA_CEP		 	:= ""
	M->RA_TELEFON		:= ""
	M->RA_PAI		 	:= ""
	M->RA_MAE		 	:= ""
	M->RA_SEXO		 	:= ""
	M->RA_ESTCIVI		:= ""
	M->RA_NATURAL		:= ""
	M->RA_NACIONA		:= ""
	M->RA_ANOCHEG		:= ""
	M->RA_NASC		 	:= ""
	M->RA_BCDEPSA		:= ""
	M->RA_CTDEPSA		:= ""
	M->RA_ADTPOSE		:= ""
	M->RA_CESTAB		:= ""
	M->RA_PENSALI		:= ""
	M->RA_ASMEDIC		:= ""
	M->RA_FAIXA		 	:= ""
	M->RA_PERCADT		:= ""
	M->RA_VALEREF		:= ""
	M->RA_SEGUROV		:= ""
	M->RA_TIPOPGT		:= ""
	M->RA_RGORG		 	:= ""
	M->RA_RACACOR		:= ""
	M->RA_RECMAIL		:= ""
	M->RA_EMAIL		 	:= ""
	M->RA_TPMAIL		:= ""
	M->RA__PLR		 	:= ""
	M->RA_TPDEFFI		:= ""
	M->RA_NOMECMP		:= ""
	M->RA_RGEXP		 	:= ""
	M->RA_RGUF		 	:= ""
	M->RA_NUMINSC		:= ""
	M->RA_SERVICO		:= ""
	M->RA_ORGEMRG		:= ""
	M->RA_CODUNIC		:= ""
	M->RA_DTCPEXP		:= ""
	M->RA_REGIME		:= ""
	M->RA_FWIDM		 	:= ""
	M->RA_DTRGEXP		:= ""
	M->RA_HOPARC		:= ""
	M->RA_CLAURES		:= ""
	M->RA_MUNNASC		:= ""
	M->RA_COMPSAB		:= ""
	M->RA_ASSIST		:= ""
	M->RA_CONFED		:= ""
	M->RA_MENSIND		:= ""
	M->RA__VRTOT1		:= ""
	M->RA__VRTOT2		:= ""
	M->RA_BCDPFGT 		:= ""
	M->RA_CTDPFGT		:= ""
	M->RA_SITFOLH 		:= ""
	M->RA_DEMISSA 		:= ctod("  /  /  ")
	
EndIf

DbSelectArea("SRA")
DbSetOrder(1)
Dbseek ("03" + cMatricula , .T.)

RECLOCK("SRA",.F.)
SRA->RA_SITFOLH := ""
SRA->RA_DEMISSA := CtoD("  /  /  ")
MSUNLOCK()

cMatricula := ""

CloseBrowse()

Return         
