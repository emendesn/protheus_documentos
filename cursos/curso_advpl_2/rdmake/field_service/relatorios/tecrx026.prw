#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECRX026 ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  04/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para geracao de planilha Excel com os dados de    º±±
±±º          ³ entrada, processo e saida dos produtos para reparos.       º±±
±±º          ³ EXPORTACAO WCMS                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH - SONY/ERICSSON                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TECRX026()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Exportacao dos atendimentos para WCMS através do Excel."
Local cDesc1  := "Este programa exporta os dados de atendimentos para uma   "
Local cDesc2  := "planilha Excel, ja efetuando alguns tratamentos específicos "
Local cDesc3  := "para o WCMS."
Local _cArq	  := ""

Private c_DirDocs   := GetTempPath()//Caminho da pasta temporaria do Cliente.
Private c_Extensao  := ".DBF"//A extensão também pode ser declarada como ".XLS"
Private c_Arquivo  := CriaTrab(,.F.)//Cria um nome aleatório para o arquivo
Private cPerg    := "TECR06"
private _csrvapl :=ALLTRIM(GetMV("MV_SERVAPL"))


u_GerA0003(ProcName())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data entrada De                                  ³
//³ mv_par02 -> Data entrada Ate                                 ³
//³ mv_par03 -> Data saida De                                    ³
//³ mv_par04 -> Data saida Ate                                   ³
//³ mv_par05 -> Almox De                                         ³
//³ mv_par06 -> Cliente                                          ³
//³ mv_par07 -> Status (1 = Tudo, 2 = Com NF, 3 = Sem NF)        ³
//³ mv_par08 -> Formulario Proprio (1 = Todos, 2 = Sim, 3 = Nao) ³
//³ mv_par09 -> Fases                                            ³
//³ mv_par10 -> Operacao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| TECRX026A(@lEnd)}, "Aguarde...","Gerando dados de atendimentos para o WCMS ...", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECRX026 ºAutor  ³Microsiga           º Data ³  19/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para geracao de planilha Excel com os dados de    º±±
±±º          ³ entrada, processo e saida dos produtos para reparos.       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TECRX026A(lEnd)

Local cAlias       := ALIAS()
Local nTotal       := 0
Local _cArqTrab    := CriaTrab(,.f.)
local _cFilCliente := _cFilStatus := _cFilFormul := " "
local _aCampos     := {}
local _cArqSeq
local _cQuery      := ""
local _aAreaSZA    := SZA->(GetArea())
Local _cArq
Local _cArqTmp
//
private CR	 	   := chr(13) + chr(10)
private _copercao  := mv_par10
if SD1->(!DbSeek(xFilial("SD1")+dtos(mv_par01))) .and. SD1->D1_DTDIGIT > mv_par02
	MsgBox("Não Houve entradas no periodo selecionado","Critica Relatório","ALERT")
	Return
endif

// Fecha arquivos temporarios se estiverem abertos
if Select("QRY") > 0
	QRY->(dbCloseArea())
endif
if Select("TRB") > 0
	TRB->(dbCloseArea())
endif

// Cria arquivo temporario
// Colocar aqui os campos da Query
_aCampos := {	{"OS"			,"C",06,00},;
{"POPDATE"		,"C",10,00},;
{"DTCOMPRA"		,"C",10,00},;
{"CLIENTE"		,"C",10,00},;
{"POPSUPPLIE"	,"C",20,00},;
{"DTRECEIVED"	,"C",10,00},;
{"REPCOMPDAT"	,"C",10,00},;
{"REPCOMPTIM"	,"C",08,00},;
{"DTDOCSAI"		,"C",10,00},;
{"PRODUTO"		,"C",15,00},;
{"DESCPROD"		,"C",40,00},;
{"SSNIN"		,"C",20,00},;
{"SSNOUT"		,"C",20,00},;
{"FAUTID"		,"C",02,00},;
{"ACTIONID"		,"C",30,00},;
{"DESCACTION"	,"C",30,00},;
{"MATQTY"		,"C",10,00},;
{"MATNR"		,"C",20,00},;
{"REUSEDID"		,"C",01,00},;
{"SYMPTOMID"	,"C",30,00},;
{"DESCSYMPT"	,"C",30,00},;
{"ARMZ"  		,"C",02,00},;
{"NFEENTR"		,"C",09,00},;
{"SERENTR"		,"C",03,00},;
{"TESENTR"		,"C",03,00},;
{"BOUNCE"		,"N",03,00},;
{"NFESAI"		,"C",09,00},;
{"SERSAI"		,"C",03,00},;
{"TESSAI"		,"C",03,00},;
{"FASATU"		,"C",03,00},;
{"FASMAX"		,"C",03,00},;
{"POSESQ"		,"C",15,00}}


_cArqSeq := CriaTrab(_aCampos)
dbUseArea(.T.,,_cArqSeq,"TRB",.T.,.F.)


If !empty(mv_par06)
	_cFilCliente := " AND D1_FORNECE = '"+MV_PAR06+"' "
EndIf

If mv_par07 == 2 // COM NF DE SAIDA
	_cFilStatus := " AND ZZ4_STATUS = '9' "
ElseIf mv_par07 == 3 // SEM NF DE SAIDA
	_cFilStatus := " AND ZZ4_STATUS < '9' "
EndIf

if mv_par08 == 2 // Apenas formulario proprio
	_cFilFormul := " AND D1_FORMUL = 'S' "
elseif mv_par08 == 3 // Apenas formulario nao proprio
	_cFilFormul := " AND D1_FORMUL <> 'S' "
endif

_cQuery += CR + "  SELECT DISTINCT ZZ4_OS 'OS',  "
IF MV_PAR10 = "S01"
  _cQuery += CR + "         SERVALOCID = '4067',  "
ELSEIF MV_PAR10 = "S05" 
  _cQuery += CR + " SERVALOCID = 'BGH-HVC' "
ELSE                                        
_cQuery += CR + " SERVALOCID = '' "
ENDIF

_cQuery += CR + "         SD1.D1_FORNECE + ' - ' +SD1.D1_LOJA	'CLIENTE', "
_cQuery += CR + "         POPSUPPLIE = A1E.A1_NREDUZ, "
_cQuery += CR + "         POPDATE    = LEFT(D1_DTDIGIT,4)+'-'+SUBSTRING(D1_DTDIGIT,5,2)+'-'+SUBSTRING(D1_DTDIGIT,7,2), "
_cQuery += CR + "         DTRECEIVED = LEFT(ZZ4_EMDT,4)+'-'+SUBSTRING(ZZ4_EMDT,5,2)+'-'+SUBSTRING(ZZ4_EMDT,7,2), "
_cQuery += CR + "         TMRECEIVED = CASE WHEN LEN(ZZ4_EMHR) = 5 THEN ZZ4_EMHR+':00' ELSE ZZ4_EMHR END, "
_cQuery += CR + "         REPCOMPDAT = CASE WHEN ZZ4_STATUS >= '5' THEN LEFT(ZZ4_ATULT,4)+'-'+SUBSTRING(ZZ4_ATULT,5,2)+'-'+SUBSTRING(ZZ4_ATULT,7,2) ELSE '' END, " //-- DATA DO ENCERRAMENTO DA OS - QD AB9_TIPO = '1'
_cQuery += CR + "         REPCOMPTIM = CASE WHEN ZZ4_STATUS >= '5' THEN SUBSTRING(ZZ4_ATULT,9,8) ELSE '' END, " //-- DATA DO ENCERRAMENTO DA OS - QD AB9_TIPO = '1' //ZZ4_SMHR, " //-- HORA DO ENCERRAMENTO DA OS
_cQuery += CR + "         DTDOCSAI   = ZZ4_DOCDTS, "
_cQuery += CR + "         HRDOCSAI   = ZZ4_DOCHRS, "
_cQuery += CR + "         PRODTYPE   = 'P', "
_cQuery += CR + "         B1_GRUPO   'MODELNO', "
_cQuery += CR + "         ZZ4_CODPRO 'PRODUTO', "
_cQuery += CR + "         ZZ4_IMEI   'SSNIN',  "
_cQuery += CR + "         ZZ4_SWAP   'SSNOUT',  "
_cQuery += CR + "         SWREVSTAT  = 'NA', "
_cQuery += CR + "         Z9_QTY 'MATQTY', "
_cQuery += CR + "         FAUTID = '', ACTIONID = '',DESCSYMPT = '', DESCACTION = '',   "
//_cQuery += CR + "         Z9_FAULID  'FAUTID', Z9_ACTION 'ACTIONID', SZ8.Z8_DESSINT 'DESCSYMPT', SZ81.Z8_DESSOLU 'DESCACTION',   "
_cQuery += CR + "         Z9_PARTNR  'MATNR', Z9_USED 'REUSEDID', SYMPTOMID = '',  "
_cQuery += CR + "         STATUSOS   = CASE WHEN ZZ4_STATUS > '4' THEN 'Encerrado' ELSE 'aberto' END,  "
_cQuery += CR + "         STATUS     = CASE WHEN ZZ4_STATUS = '1' THEN 'Entrada Apontada' "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '2' THEN 'Entrada Confirmada'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '3' THEN 'NFE Gerada'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '4' THEN 'Em atendimento'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '5' THEN 'OS Encerrada'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '6' THEN 'Saida Lida'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '7' THEN 'Saida Apontada'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '8' THEN 'PV Gerado'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '9' THEN 'NFS Gerada' ELSE '' END,  "
_cQuery += CR + "         SD1.D1_LOCAL   	'ARMZ', "
_cQuery += CR + "         SD1.D1_LOJA		'LOJA', "
_cQuery += CR + "         SD1.D1_DOC		'NFE',	"
_cQuery += CR + "         SD1.D1_SERIE		'SERIE', "
_cQuery += CR + "         SD1.D1_DOC		'NFEENTR', "
_cQuery += CR + "         SD1.D1_SERIE		'SERENTR', "
_cQuery += CR + "         SD1.D1_TES		'TESENTR', "
_cQuery += CR + "         ZZ4.ZZ4_BOUNCE	'BOUNCE', "
_cQuery += CR + "         ZZ4.ZZ4_NFSNR		'NFESAI', "
_cQuery += CR + "         ZZ4.ZZ4_NFSSER	'SERSAI', "
_cQuery += CR + "         ZZ4.ZZ4_NFSTES	'TESSAI', "
_cQuery += CR + "         ZZ4.ZZ4_FASATU	'FASATU', "
_cQuery += CR + "         ZZ4.ZZ4_FASMAX	'FASMAX', "
_cQuery += CR + "         ZZ31.ZZ3_LAB 'LAB', "
_cQuery += CR + "         POSESQ = '', "
//_cQuery += CR + "         SZ9.Z9_POSESQU	'POSESQ', "
_cQuery += CR + "         B1_DESC			'DESCPROD' "
_cQuery += CR + "  FROM   "+RetSqlName("SD1")+" AS SD1 (NOLOCK) "
_cQuery += CR + "  JOIN   "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK) "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado por M.Munhoz em 16/08/2011 - foi tirado o D1_NUMSER / ZZ4_IMEI do relacionamento das tabelas e criado novo relacionamento ³
//³obedecendo o indice 1 da tabela SD1.                                                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//_cQuery += CR + "  ON     ZZ4_FILIAL  = D1_FILIAL AND ZZ4_IMEI = D1_NUMSER AND ZZ4_NFENR = D1_DOC AND ZZ4_NFESER = D1_SERIE AND ZZ4.D_E_L_E_T_ = '' AND ZZ4_STATUS > '4'  " //-- APENAS OS'S ENCERRADAS
_cQuery += CR + "  ON     ZZ4_FILIAL  = D1_FILIAL AND ZZ4_NFENR = D1_DOC AND ZZ4_NFESER = D1_SERIE AND ZZ4_CODCLI = D1_FORNECE AND ZZ4_LOJA = D1_LOJA 
_cQuery += CR + "  AND ZZ4_CODPRO = D1_COD AND ZZ4_ITEMD1 = D1_ITEM AND ZZ4.D_E_L_E_T_ = '' AND ZZ4_STATUS > '4'  AND ZZ4_OPEBGH ='"+MV_PAR10+"' " //-- APENAS OS'S ENCERRADAS
_cQuery += CR + "  JOIN   "+RetSqlName("SA1")+" AS A1E (NOLOCK) "
_cQuery += CR + "  ON     A1E.A1_FILIAL = '"+xFilial("SA1")+"' AND A1E.A1_COD = D1_FORNECE AND A1E.A1_LOJA = D1_LOJA AND A1E.D_E_L_E_T_ = ''  "
_cQuery += CR + "  JOIN   "+RetSqlName("SB1")+" AS B1E (NOLOCK) "
_cQuery += CR + "  ON     B1E.B1_FILIAL = '"+xFilial("SB1")+"' AND B1E.B1_COD = D1_COD AND B1E.D_E_L_E_T_ = ''  "
_cQuery += CR + "  LEFT OUTER JOIN   "+RetSqlName("SZ9")+" AS SZ9 (NOLOCK) "
_cQuery += CR + "  ON     Z9_FILIAL = D1_FILIAL AND LEFT(Z9_NUMOS,6) = LEFT(ZZ4_OS,6) AND Z9_IMEI = ZZ4_IMEI AND SZ9.D_E_L_E_T_ = ''  "
_cQuery += CR + "  INNER JOIN (SELECT DISTINCT ZZ3.ZZ3_IMEI,ZZ3.ZZ3_NUMOS,ZZ3.ZZ3_LAB FROM " + RetSqlName("ZZ3")+ " AS ZZ3  (NOLOCK) WHERE ZZ3.D_E_L_E_T_ = '' )ZZ31 "
_cQuery += CR + "  	ON (ZZ4.ZZ4_IMEI = ZZ31.ZZ3_IMEI AND ZZ4.ZZ4_OS = ZZ31.ZZ3_NUMOS) "
_cQuery += CR + "  	LEFT JOIN " + RetSqlName("SZ8")+ " AS SZ8 (NOLOCK) "
_cQuery += CR + "  	ON(ZZ31.ZZ3_LAB = SZ8.Z8_CLIENTE AND SZ9.Z9_SYMPTO = SZ8.Z8_CODSINT) "
_cQuery += CR + "  	LEFT JOIN " + RetSqlName("SZ8") + " AS SZ81 (NOLOCK) "
_cQuery += CR + "  	ON(ZZ31.ZZ3_LAB = SZ81.Z8_CLIENTE AND SZ9.Z9_ACTION = SZ81.Z8_CODSOLU) "
_cQuery += CR + "  WHERE  SD1.D_E_L_E_T_ = '' "
_cQuery += CR + "         AND D1_FILIAL = '"+xFilial("SD1")+"' "
_cQuery += CR + "         AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
// Alterado por M.Munhoz em 16/08/2011 - filtro pelo D1_NUMSER eliminado. os registros serao filtrados automaticamente a partir do relacionamento das tabelas SD1 e ZZ4 no JOIN. 
//_cQuery += CR + "         AND D1_NUMSER <> '' "
_cQuery += CR + "         AND D1_TIPO = 'B' "
_cQuery += CR + "         AND '"+mv_par05+"' LIKE '%'+D1_LOCAL+'%' "
_cQuery += CR + _cFilCliente
_cQuery += CR + _cFilStatus
_cQuery += CR + _cFilFormul
//_cQuery += CR + "  ORDER BY D1_DTDIGIT, ZZ4_OS "

_cQuery := strtran(_cQuery, CR, "")

//MemoWrite("c:\sql\tecrx026.sql", _cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)
//TcSetField("QRY","ZZ4_EMDT" ,"D")

SZA->(dbSetOrder(1)) // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
nConta   := 0
_aWcms   := {}
//_cRemarks:= iif(mv_par10 == 1, "MRC", iif(mv_par10 == 2, "DOA", iif(mv_par10 == 3, "Nextel", "")))
_cChave  := _cSintom := _cPosesq := _cDescsy := _cDescac := _cAction := ""
QRY->(dbGoTop())
While !QRY->(eof())
	
	//_cChave  := alltrim(QRY->OS) + alltrim(QRY->SSNIN) desabilitado essa variavel aqui -  Edson Rodrigues 30/11/11
	
	if !empty(QRY->SYMPTOMID) .and. !alltrim(QRY->SYMPTOMID) $ _cSintom
		//	_cSintom 	+= iif(empty(_cSintom), alltrim(QRY->SYMPTOMID), ":"+alltrim(QRY->SYMPTOMID))
		//	_cDescsy	+= iif(empty(_cDescsy), alltrim(QRY->DESCSYMPT), ":"+alltrim(QRY->DESCSYMPT))
		// 	_cAction	+= iif(empty(_cAction), alltrim(QRY->ACTIONID), ":"+alltrim(QRY->ACTIONID))
		//	_cDescac	+= iif(empty(_cDescac), alltrim(QRY->DESCACTION), ":"+alltrim(QRY->DESCACTION))
		//	_cPosesq	+= iif(empty(_cPosesq), alltrim(QRY->POSESQ), ":"+alltrim(QRY->POSESQ))
		
		
	endif
	aAdd(_aWcms, {	QRY->OS			,;//01
	QRY->SERVALOCID	,;//02
	QRY->POPDATE	,;//03
	QRY->CLIENTE	,;//04
	QRY->POPSUPPLIE	,;//05
	QRY->DTRECEIVED	,;//06
	QRY->TMRECEIVED	,;//07
	QRY->REPCOMPDAT	,;//08
	QRY->REPCOMPTIM	,;//09
	QRY->REPCOMPDAT	,;//10 - PHRETDAT
	QRY->REPCOMPTIM	,;//11 - PHRETTIM
	QRY->PRODTYPE	,;//12
	QRY->MODELNO	,;//13
	QRY->SSNIN		,;//14
	QRY->SSNOUT		,;//15
	QRY->SWREVSTAT	,;//16
	QRY->FAUTID		,;//17
	QRY->ACTIONID	,;//18
	Transform(QRY->MATQTY,"@E 999")	,;//19
	QRY->MATNR		,;//20
	QRY->REUSEDID	,;//21
	QRY->SYMPTOMID	,;//22
	""				,;// QRY->REMARKS	,;//23
	QRY->ARMZ   	,;//24      //Adicionado / Colocar Armazem no relatório / Luiz Ferreira 18/11/2008
	QRY->DTDOCSAI  	,;//25
	QRY->HRDOCSAI	,;//26
	QRY->PRODUTO	,;//27
	QRY->LOJA		,;//28
	QRY->NFE		,;//29
	QRY->SERIE		,;//30
	QRY->DESCSYMPT	,;//31
	QRY->DESCACTION ,;//32
	QRY->NFEENTR	,;//33
	QRY->SERENTR	,;//34
	QRY->TESENTR	,;//35
	QRY->BOUNCE		,;//36
	QRY->NFESAI		,;//37
	QRY->SERSAI		,;//38
	QRY->TESSAI		,;//39
	QRY->FASATU		,;//40
	QRY->FASMAX		,;//41
	QRY->POSESQ		,;//42
	QRY->DESCPROD	})//43
	
	//QRY->(dbSkip()) Desabilitado esse SKIP daqui - Edson Rodrigues - 30/11/11
	
	if QRY->(eof()) .or. (alltrim(_cChave) <> alltrim(QRY->OS) + alltrim(QRY->SSNIN)) 
	    _cChave  := alltrim(QRY->OS) + alltrim(QRY->SSNIN) //Incluso essa variavel aqui -  Edson Rodrigues 30/11/11
		for x := 1 to len(_aWcms)
			
			if SZA->(dbSeek(xFilial("SZA") + QRY->PRODUTO + QRY->LOJA + QRY->NFE + QRY->SERIE + QRY->MODELNO ))
				_cDtCompra := dtos(SZA->ZA_DTNFCOM)
				_cDtCompra := left(_cDtCompra,4)+'-'+substr(_cDtCompra,5,2)+'-'+substr(_cDtCompra,7,2)
				_cNomeRev  := SZA->ZA_NOMEREV
			else
				_cDtCompra := space(10)
				_cNomeRev  := space(50)
			endif
			
			SZ9->(dbSetOrder(2))//Z9_FILIAL, Z9_IMEI, Z9_NUMOS, Z9_SEQ
			If SZ9->(dbSeek( xFilial("SZ9") + QRY->SSNIN + QRY->OS))
				
				While SZ9->(!Eof()) .And. xFilial("SZ9") == SZ9->Z9_FILIAL .And. alltrim(QRY->OS) == alltrim(SZ9->Z9_NUMOS) .And. alltrim(SZ9->Z9_IMEI) == alltrim(QRY->SSNIN)
					_cSintom 	+= iif(empty(_cSintom), alltrim(SZ9->Z9_SYMPTO), ":"+alltrim(SZ9->Z9_SYMPTO))
					_cAction	+= iif(empty(_cAction), alltrim(SZ9->Z9_ACTION), ":"+alltrim(SZ9->Z9_ACTION))
					_cPosesq	+= iif(empty(_cPosesq), alltrim(SZ9->Z9_POSESQU), ":"+alltrim(SZ9->Z9_POSESQU))
					
					SZ9->(dbSkip())
					
				EndDo
				
			EndIf
			
			// Alimentar arquivo temporario TRB com resultado da Query, tratando o campo de Sintoma
			reclock("TRB",.t.)
			TRB->OS			:= QRY->OS	//_aWcms[x,01]
			TRB->POPDATE	:= QRY->POPDATE//_aWcms[x,03]
			TRB->CLIENTE	:= QRY->CLIENTE//_aWcms[x,04]
			TRB->POPSUPPLIE	:= QRY->POPSUPPLIE//_aWcms[x,05]
			TRB->DTCOMPRA	:= _cDtCompra
			TRB->DTRECEIVED	:= QRY->DTRECEIVED//_aWcms[x,06]
			TRB->REPCOMPDAT	:= QRY->REPCOMPDAT//_aWcms[x,08]
			TRB->REPCOMPTIM	:= QRY->REPCOMPTIM//_aWcms[x,09]
			TRB->SSNIN		:= QRY->SSNIN
			TRB->SSNOUT		:= iif(EMPTY(QRY->SSNOUT),QRY->SSNIN,QRY->SSNOUT)//_aWcms[x,15]
			TRB->FAUTID		:= QRY->FAUTID//_aWcms[x,17]
			TRB->ACTIONID	:= _cAction
			TRB->DESCACTION	:= Posicione("SZ8",2,xFilial("SZ8") + QRY->LAB + Left(_cAction,4), "Z8_DESSOLU" )//_aWcms[x,32]
			TRB->MATQTY		:= Transform(QRY->MATQTY,"@E 999")//_aWcms[x,19]
			TRB->MATNR		:= QRY->MATNR//_aWcms[x,20]
			TRB->REUSEDID	:= QRY->REUSEDID//_aWcms[x,21]
			TRB->SYMPTOMID	:= _cSintom
			TRB->DESCSYMPT	:= Posicione("SZ8",1,xFilial("SZ8")+ QRY->LAB + Left(_cSintom,4), "Z8_DESSINT" )//_aWcms[x,31]
			TRB->ARMZ   	:= QRY->ARMZ//_aWcms[x,24]
			TRB->DTDOCSAI	:= left(QRY->DTDOCSAI,4)+'-'+substr(QRY->DTDOCSAI,5,2)+'-'+substr(QRY->DTDOCSAI,7,2)//left(_aWcms[x,25],4)+'-'+substr(_aWcms[x,25],5,2)+'-'+substr(_aWcms[x,25],7,2)
			TRB->PRODUTO	:= QRY->PRODUTO//_aWcms[x,27]
			TRB->NFEENTR	:= QRY->NFEENTR//_aWcms[x,33]
			TRB->SERENTR	:= QRY->SERENTR//_aWcms[x,34]
			TRB->TESENTR	:= QRY->TESENTR//_aWcms[x,35]
			TRB->BOUNCE		:= QRY->BOUNCE//_aWcms[x,36]
			TRB->NFESAI		:= QRY->NFESAI//_aWcms[x,37]
			TRB->SERSAI		:= QRY->SERSAI//_aWcms[x,38]
			TRB->TESSAI		:= QRY->TESSAI//_aWcms[x,39]
			TRB->FASATU		:= QRY->FASATU//_aWcms[x,40]
			TRB->FASMAX		:= QRY->FASMAX//_aWcms[x,41]
			TRB->POSESQ		:= _cPosesq
			TRB->DESCPROD	:= QRY->DESCPROD//_aWcms[x,43]
			
			
			
			
			msunlock()
			nConta++
		next x
		_cSintom 	:= ""
		_cAction	:= ""
		_cPosesq	:= ""
		_cDescsy	:= ""
		_cDescac	:= ""
		_aWcms   := {}
	endif
	QRY->(dbSkip()) // incluso do SKIP aqui - Edson Rodrigues 30/11/11
EndDo

QRY->(dbCloseArea())



//_cArq  := "WCMS_NOVO_"+Alltrim(cUserName)+".XLS"
_cArq    := "WCMS_NOVO.XLS"
_cArqTmp := lower(AllTrim(__RELDIR)+_cArq)
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

//Incluso Edson Rodrigues - 25/05/10
cArqorig := cStartPath+_cArqSeq+".dtc"
cArqdest := lower(AllTrim(__RELDIR))+"WCMS_NOVO.CSV"

//ALERT("Arquivo: "+_cArqTmp)

if nConta > 0
	if file(_cArqTmp) .and. ferase(_cArqTmp) == -1
		if !ApMsgYesNo("O arquivo: " + _cArq + " não pode ser gerado porque deve estar sendo utilizado. Deseja tentar novamente? " )
			_lOpen := .t.
			ApMsgInfo("O arquivo Excel não foi gerado. ")
		endif
	else
		
		dbselectarea("TRB")
		dbGoTop()
		
		//copy to (_cArqTmp) VIA "DBFCDXADS"
		//USE (_cArqTmp) VIA "DBFCDXADS" NEW
		//USE
		//CpyS2T(cDirDocs+"\"+_cArq+".CSV" , cPath, .T. )
		
		//Incluso Edson Rodrigues - 25/05/10
		lgerou:=U_CONVARQ(cArqorig,cArqdest)
		
		
		if lgerou
			If !ApOleClient( 'MsExcel' )
				MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
			Else
				//oExcelApp := MsExcel():New()
				//oExcelApp:WorkBooks:Open("\\"+_csrvapl+lower(cArqdest)) // Abre uma planilha
				//oExcelApp:SetVisible(.T.)
				ShellExecute( "Open" , "\\"+_csrvapl+cArqdest ,"", "" , 3 )
			EndIf
			
		else
			msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
		endif
		
		
	endif
else
	msgstop("Não existem dados gerados para esse relatório. Verifique os parâmetros do relatório.","Arquivo Vazio","STOP")
endif

//TRB->(dbCloseArea())

dbselectarea( cAlias )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRIASX1  ºAutor  ³M.Munhoz - ERP PLUS º Data ³  12/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para a criacao automatica das perguntas no SX1      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data entrada De                                  ³
//³ mv_par02 -> Data entrada Ate                                 ³
//³ mv_par03 -> Data saida De                                    ³
//³ mv_par04 -> Data saida Ate                                   ³
//³ mv_par05 -> Almox De                                         ³
//³ mv_par06 -> Cliente                                          ³
//³ mv_par07 -> Status (1 = Tudo, 2 = Com NF, 3 = Sem NF)        ³
//³ mv_par08 -> Formulario Proprio (1 = Todos, 2 = Sim, 3 = Nao) ³
//³ mv_par09 -> Fases da OS                                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Data Entrada Inicial?"	,"Data Entrada Inicial?"	,"Data Entrada Inicial?"	,"mv_ch1","D",08,0,0,"G","",""	,"",,"mv_par01",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"02","Data Entrada Final?"		,"Data Entrada Final?"		,"Data Entrada Final?"		,"mv_ch2","D",08,0,0,"G","",""	,"",,"mv_par02",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"03","Data Saida Inicial?"		,"Data Saida Inicial?"		,"Data Saida Inicial?" 		,"mv_ch3","D",08,0,0,"G","",""	,"",,"mv_par03",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"04","Data Saida Final?"  		,"Data Saida Final?"   		,"Data Saida Final?"   		,"mv_ch4","D",08,0,0,"G","",""	,"",,"mv_par04",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"05","Almoxarifados?"			,"Almoxarifados?"			,"Almoxarifados?"			,"mv_ch5","C",20,0,0,"G","",""	,"",,"mv_par05",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"06","Cod.Cliente?"			,"Cod.Cliente?"				,"Cod.Cliente?"				,"mv_ch6","C",06,0,0,"G","",""	,"",,"mv_par06",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"07","Status?"					,"Status?"					,"Status?"					,"mv_ch7","N",01,0,0,"C","",""	,"",,"mv_par07","Todos"	,"","","","Com NF"	,"","","Sem NF"	,"","","","","","","","")
PutSX1(cPerg,"08","Formulario Proprio?"		,"Formulario Proprio?"		,"Formulario Proprio?"		,"mv_ch8","N",01,0,0,"C","",""	,"",,"mv_par08","Todos"	,"","","","Sim"		,"","","Nao"	,"","","","","","","","")
//PutSX1(cPerg,"09","Fases?"			        ,"Fases?"			        ,"Fases?"       			,"mv_ch9","C",30,0,0,"G","",""	,"",,"mv_par09",""		,"","","",""		,"","",""		,"","","","","","","","")
//PutSX1(cPerg,"10","Laboratorio"				,"Laboratorio"				,"Laboratorio"				,"mv_cha","N",01,0,0,"C","",""	,"",,"mv_par10","MRC"	,"","","","DOA"		,"","","Nextel"	,"","","","","","","","")
PutSX1(cPerg,"10","Operacao"				,"Operacao"				,"Operacao"				,"mv_cha","C",3,0,0,"G","","ZZJ"	,"",,"mv_par10",""	,"","","",""		,"","",""	,"","","","","","","","")
Return Nil
