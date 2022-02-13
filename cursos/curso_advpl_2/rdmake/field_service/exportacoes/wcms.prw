#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#DEFINE OPEN_FILE_ERROR -1
#define ENTER CHR(10)+CHR(13)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WCMS  ºAutor  ³ Edson Rodrigues       º Data ³  05/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa p/ geracao de WCMS 2 - Batch Upload Data Requirem º±±
±±º          ³ entrada, processo e saida dos produtos para reparos.       º±±
±±º          ³ EXPORTACAO WCMS                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EspecIfico BGH - SONY MOBILE                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WCMS(aParam)
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Exportacao dos atendimentos para WCMS através arquivo especIfico."
Local cDesc1  := "Este programa exporta os dados de atendimentos para um   "
Local cDesc2  := "especIfico, ja efetuando alguns tratamentos específicos "
Local cDesc3  := "para o WCMS."
Local _cArq	  := ""
Default aParam := {'02','02'}

Private c_DirDocs   := GetTempPath()//Caminho da pasta temporaria do Cliente.
Private c_Extensao  := ".DBF"//A extensão também pode ser declarada como ".XLS"
Private c_Arquivo   := CriaTrab(,.F.)//Cria um nome aleatório para o arquivo
Private cPerg       := "TECR06"
Private _csrvapl    :=ALLTRIM(GetMV("MV_SERVAPL"))
Private cArqTxt     := "WCMSSONY"+dtos(msdate())+replace(time(),":","")"
Private aerros   :={}

u_GerA0003(ProcName())
SD1->(dbSetOrder(6)) // D1_FILIAL + D1_EMISSAO+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA

//----------------------------------------------------------------
//³ mv_par01 -> Data entrada De                                  -
//³ mv_par02 -> Data entrada Ate                                 -
//³ mv_par03 -> Data saida De                                    -
//³ mv_par04 -> Data saida Ate                                   -
//³ mv_par05 -> Armazens Entr. Eqto                              -
//³ mv_par06 -> Cliente                                          -
//³ mv_par07 -> Status (1 = Tudo, 2 = Com NF, 3 = Sem NF)        -
//³ mv_par08 -> Formulario Proprio (1 = Todos, 2 = Sim, 3 = Nao) -
//³ mv_par09 -> Fases                                            -
//³ mv_par10 -> Operacao                                         -
//----------------------------------------------------------------

CriaSX1()

// Pergunte(cPerg,.f.)
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
EndIf

Processa( {|lEnd| WCMSA(@lEnd)}, "Aguarde...","Gerando dados de atendimentos para o WCMS ...", .T. )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WCMSA ºAutor  ³Microsiga           º Data ³  19/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para geracao de planilha Excel com os dados de    º±±
±±º          ³ entrada, processo e saida dos produtos para reparos.       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function WCMSA(lEnd)

Local cAlias       	:= ALIAS()
Local nTotal       	:= 0
Local _cArqTrab    	:= CriaTrab(,.f.)
Local _cFilCliente 	:= _cFilStatus := _cFilFormul := _cFilOS  := _cfildtsai := " "
Local _aCampos     	:= {}
Local _cArqSeq      := ""
Local _cQuery      	:= ""
Local _aAreaSZA    	:= SZA->(GetArea())
Local _cArq         := ""
Local nTamLin		:= 0
Local cLin          := ""
Local cCpo          := ""
Local  CR        	:= ""
Local _larqtxt   	:=.f.
Local _cQryrem		:= ""

Private CR	 	   := chr(13) + chr(10)
Private _copercao  := mv_par10
Private nHdl    := fCreate(lower(AllTrim(__RELDIR)+cArqTxt+".TXT"))
Private cEOL    := "CHR(13)+CHR(10)"
Private cTAB    := CHR(09)


// Fecha arquivos temporarios se estiverem abertos
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
EndIf

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! VerIfique com Administrado do Sistema.","Atencao!")
	Return
EndIf

// Cria arquivo temporario
// Colocar aqui os campos da Query
_aCampos := {	{"OS"			,"C",06,00},;
{"SERVLOCID"	,"C",08,00},;
{"POPDATE"		,"C",10,00},;
{"POPSUPPLIE"	,"C",20,00},;
{"DTRECEIVED"	,"C",10,00},;
{"TIMERECVED"	,"C",08,00},;
{"REPCOMPDAT"	,"C",10,00},;
{"REPCOMPTIM"	,"C",08,00},;
{"PHONRETDAT"	,"C",10,00},;
{"PHONRETIME"	,"C",08,00},;
{"PRODCTYPE"	,"C",01,00},;
{"MODELNO"	    ,"C",20,00},;
{"SSNIN"		,"C",20,00},;
{"SSNOUT"		,"C",20,00},;
{"SWREVSTAT"    ,"C",20,00},;
{"FAUTID"		,"C",02,00},;
{"ACTIONID"		,"C",30,00},;
{"MATQTY"		,"C",10,00},;
{"MATNR"		,"C",20,00},;
{"REUSEDID"		,"C",01,00},;
{"SYMPTOMID"	,"C",30,00},;
{"REMARKS"	,    "C",50,00}}
/*
{"DESCACTION"	,"C",30,00},;
{"DESCSYMPT"	,"C",30,00},;
{"CLIENTE"		,"C",10,00},;
{"DTCOMPRA"		,"C",10,00},;
{"DTDOCSAI"		,"C",10,00},;
{"PRODUTO"		,"C",15,00},;
{"DESCPROD"		,"C",40,00},;
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
*/

_cArqSeq := CriaTrab(_aCampos)
dbUseArea(.T.,,_cArqSeq,"TRB",.T.,.F.)

If !empty(mv_par06)
	_cFilCliente := " AND D1_FORNECE = '"+MV_PAR06+"' "
EndIf

If mv_par07 == 2 // COM NF DE SAIDA
	_cFilStatus := " AND ( ZZ4_STATUS = '9' OR ( ZZ4_STATUS ='8' AND ZZ4_SWAP<>'') ) "//  AND  ZZ4_OS='9BEGQV'  "
ElseIf mv_par07 == 3 // SEM NF DE SAIDA
	_cFilStatus := " AND ZZ4_STATUS < '9' "//  AND  ZZ4_OS='9BEGQV'  "
EndIf

If mv_par08 == 2 // Apenas formulario proprio
	_cFilFormul := " AND D1_FORMUL = 'S' "
ElseIf mv_par08 == 3 // Apenas formulario nao proprio
	_cFilFormul := " AND D1_FORMUL <> 'S' "
EndIf

If !empty(mv_par09)
	_cFilOS := " AND ZZ4_FILIAL='"+xFilial("ZZ4")+"'  AND ZZ4_OS IN "+FormatIn(alltrim(mv_par09),";")
Else
	_cFilOS := " AND ZZ4_FILIAL='"+xFilial("ZZ4")+"'  AND ZZ4_OS <> ''
EndIf

If !empty(mv_par03) .and. !empty(mv_par04)
	_cfildtsai := " AND ((ZZ4_NFSDT <> '' AND ZZ4_NFSDT>='"+DTOS(MV_PAR03)+"' AND  ZZ4_NFSDT<='"+DTOS(MV_PAR04)+"') OR ( ZZ4_NFSDT = '' AND (ZZ4_SWNFDT='' OR ( ZZ4_SWNFDT>='"+DTOS(MV_PAR03)+"' AND ZZ4_SWNFDT<='"+DTOS(MV_PAR04)+"' )))) "
	
ElseIf empty(mv_par03) .and. !empty(mv_par04)
	_cfildtsai := " AND ((ZZ4_NFSDT <> '' AND ZZ4_NFSDT>='20150101' AND  ZZ4_NFDST<='"+DTOS(MV_PAR04)+"') OR ( ZZ4_NFSDT = '' AND (ZZ4_SWNFDT='' OR (ZZ4_SWNFDT>='20150101' AND ZZ4_SWNFDT<='"+DTOS(MV_PAR04)+"')))) "
	
ElseIf !empty(mv_par03) .and. empty(mv_par04)
	_cfildtsai := " AND ((ZZ4_NFSDT <> '' AND ZZ4_NFSDT>='"+DTOS(MV_PAR03)+"' AND  ZZ4_NFSDT<='"+DTOS(DDATABASE)+"') OR ( ZZ4_NFSDT = '' AND (ZZ4_SWNFDT='' OR ( ZZ4_SWNFDT>='"+DTOS(MV_PAR03)+"' AND ZZ4_SWNFDT<='"+DTOS(DDATABASE)+"')))) "
	
ElseIf empty(mv_par03) .and. empty(mv_par04)
	
	_cfildtsai := " AND ((ZZ4_NFSDT <> '' AND ZZ4_NFSDT>='20150101' AND  ZZ4_NFSDT<='"+DTOS(DDATABASE)+"') OR ( ZZ4_NFSDT = '' AND (ZZ4_SWNFDT='' OR ( ZZ4_SWNFDT>='20150101' AND ZZ4_SWNFDT<='"+DTOS(DDATABASE)+"')))) "
EndIf

_cQuery += CR + "  SELECT DISTINCT ZZ4_OS 'OS',  "
If MV_PAR10 = "S01"
	_cQuery += CR + "         SERVALOCID = '4067',  "
ElseIf MV_PAR10 $ "S05/S06/S07/S08"
	_cQuery += CR + " SERVALOCID = CASE WHEN SD1.D1_FORMUL='S' AND ZZ4_OPEBGH='S05' THEN '7475' Else '7477' END, "
Else
	_cQuery += CR + " SERVALOCID = '', "
EndIf

_cQuery += CR + "         SD1.D1_FORNECE + ' - ' +SD1.D1_LOJA	'CLIENTE', "
_cQuery += CR + "         POPSUPPLIE = A1E.A1_NREDUZ, "
_cQuery += CR + "         POPDATE    = SUBSTRING(D1_DTDIGIT,3,2)+'-'+SUBSTRING(D1_DTDIGIT,5,2)+'-'+RIGHT(RTRIM(D1_DTDIGIT),2), "
_cQuery += CR + "         DTRECEIVED = SUBSTRING(ZZ4_EMDT,3,2)+'-'+SUBSTRING(ZZ4_EMDT,5,2)+'-'+RIGHT(RTRIM(ZZ4_EMDT),2), "
_cQuery += CR + "         TMRECEIVED = CASE WHEN LEN(ZZ4_EMHR) = 5 THEN ZZ4_EMHR+':00' Else ZZ4_EMHR END, "
_cQuery += CR + "         REPCOMPDAT = CASE WHEN ZZ4_ATULT ='' THEN '' WHEN ZZ4_STATUS >= '5' THEN SUBSTRING(ZZ4_ATULT,3,2)+'-'+SUBSTRING(ZZ4_ATULT,5,2)+'-'+SUBSTRING(ZZ4_ATULT,7,2) Else '' END, " //-- DATA DO ENCERRAMENTO DA OS - QD AB9_TIPO = '1'
_cQuery += CR + "         REPCOMPTIM = CASE WHEN ZZ4_STATUS >= '5' THEN SUBSTRING(ZZ4_ATULT,9,8) Else '' END, " //-- DATA DO ENCERRAMENTO DA OS - QD AB9_TIPO = '1' //ZZ4_SMHR, " //-- HORA DO ENCERRAMENTO DA OS
_cQuery += CR + "         DTDOCSAI   = CASE WHEN ZZ4_DOCDTS<>'' THEN SUBSTRING(ZZ4_DOCDTS,3,2)+'-'+SUBSTRING(ZZ4_DOCDTS,5,2)+'-'+RIGHT(RTRIM(ZZ4_DOCDTS),2) Else ZZ4_DOCDTS END, "
_cQuery += CR + "         HRDOCSAI   = ZZ4_DOCHRS, "
_cQuery += CR + "         PRODTYPE   = 'P', "
_cQuery += CR + "         B1_GRUPO   'MODELNO', "
_cQuery += CR + "         ZZ4_CODPRO 'PRODUTO', "
_cQuery += CR + "         ZZ4_IMEI   'SSNIN',  "
_cQuery += CR + "         ZZ4_SWAP    'SSNOUT',  "
_cQuery += CR + "         ZZ4_PRODUP  'PRODOUT',  "
_cQuery += CR + "         ZZ4_MODCOM  'MODELCOM',  "
_cQuery += CR + "         SWREVSTAT  = '', "
_cQuery += CR + "         Z9_QTY 'MATQTY', "
_cQuery += CR + "         FAUTID = '', ACTIONID = '',DESCSYMPT = '', DESCACTION = '',   "
//_cQuery += CR + "         Z9_FAULID  'FAUTID', Z9_ACTION 'ACTIONID', SZ8.Z8_DESSINT 'DESCSYMPT', SZ81.Z8_DESSOLU 'DESCACTION',   "
_cQuery += CR + "         Z9_PARTNR  'MATNR', Z9_USED 'REUSEDID', SYMPTOMID = '',  "
_cQuery += CR + "         STATUSOS   = CASE WHEN ZZ4_STATUS > '4' THEN 'Encerrado' Else 'aberto' END,  "
_cQuery += CR + "         STATUS     = CASE WHEN ZZ4_STATUS = '1' THEN 'Entrada Apontada' "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '2' THEN 'Entrada Confirmada'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '3' THEN 'NFE Gerada'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '4' THEN 'Em atendimento'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '5' THEN 'OS Encerrada'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '6' THEN 'Saida Lida'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '7' THEN 'Saida Apontada'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '8' THEN 'PV Gerado'  "
_cQuery += CR + "                           WHEN ZZ4_STATUS = '9' THEN 'NFS Gerada' Else '' END,  "
_cQuery += CR + "         SD1.D1_LOCAL   	'ARMZ', "
_cQuery += CR + "         SD1.D1_LOJA		'LOJA', "
_cQuery += CR + "         SD1.D1_FORNECE	'FORNECE', "
_cQuery += CR + "         SD1.D1_DOC		'NFE',	"
_cQuery += CR + "         SD1.D1_SERIE		'SERIE', "
_cQuery += CR + "         SD1.D1_DOC		'NFEENTR', "
_cQuery += CR + "         SD1.D1_SERIE		'SERENTR', "
_cQuery += CR + "         SD1.D1_TES		'TESENTR', "
_cQuery += CR + "         ZZ4.ZZ4_BOUNCE	'BOUNCE', "
_cQuery += CR + "         ZZ4.ZZ4_NFSNR		'NFESAI', "
_cQuery += CR + "         NFSDAT  =   CASE  WHEN  ZZ4.ZZ4_NFSDT='' THEN '' Else  SUBSTRING(ZZ4.ZZ4_NFSDT,3,2)+'-'+SUBSTRING(ZZ4.ZZ4_NFSDT,5,2)+'-'+RIGHT(RTRIM(ZZ4.ZZ4_NFSDT),2)  END, "
_cQuery += CR + "         ZZ4.ZZ4_NFSSER	'SERSAI', "
_cQuery += CR + "         ZZ4.ZZ4_STATUS	'STATBGH', "
_cQuery += CR + "         SWNFDT =   CASE  WHEN  ZZ4.ZZ4_SWNFDT='' THEN '' Else  SUBSTRING(ZZ4.ZZ4_SWNFDT,3,2)+'-'+SUBSTRING(ZZ4.ZZ4_SWNFDT,5,2)+'-'+RIGHT(RTRIM(ZZ4.ZZ4_SWNFDT),2) END, "
_cQuery += CR + "         ZZ4.ZZ4_NFSSER	'SERSAI', "
_cQuery += CR + "         ZZ4.ZZ4_NFSTES	'TESSAI', "
_cQuery += CR + "         ZZ4.ZZ4_FASATU	'FASATU', "
_cQuery += CR + "         ZZ4.ZZ4_FASMAX	'FASMAX', "
_cQuery += CR + "         ZZ31.ZZ3_LAB 'LAB', "
_cQuery += CR + "         POSESQ = '', "
//_cQuery += CR + "         SZ9.Z9_POSESQU	'POSESQ', "
_cQuery += CR + "         B1_DESC			'DESCPROD', "
_cQuery += CR + "         SD1.D1_FORMUL			'FORMUL' "
_cQuery += CR + "  FROM   "+RetSqlName("SD1")+" AS SD1 (NOLOCK) "
_cQuery += CR + "  JOIN   "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK) "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado por M.Munhoz em 16/08/2011 - foi tirado o D1_NUMSER / ZZ4_IMEI do relacionamento das tabelas e criado novo relacionamento ³
//³obedecendo o indice 1 da tabela SD1.                                                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//_cQuery += CR + "  ON     ZZ4_FILIAL  = D1_FILIAL AND ZZ4_IMEI = D1_NUMSER AND ZZ4_NFENR = D1_DOC AND ZZ4_NFESER = D1_SERIE AND ZZ4.D_E_L_E_T_ = '' AND ZZ4_STATUS > '4'  " //-- APENAS OS'S ENCERRADAS
_cQuery += CR + "  ON     ZZ4_FILIAL  = D1_FILIAL AND ZZ4_NFENR = D1_DOC AND ZZ4_NFESER = D1_SERIE AND ZZ4_CODCLI = D1_FORNECE AND ZZ4_LOJA = D1_LOJA
_cQuery += CR + "  AND ZZ4_CODPRO = D1_COD AND ZZ4_ITEMD1 = D1_ITEM AND ZZ4.D_E_L_E_T_ = '' AND ZZ4_STATUS > '4' AND " // --  ZZ4_SWAP<> '' AND "
_cQuery += CR + " ZZ4_OPEBGH IN ('S05','S06','S07','S08') AND RTRIM(ZZ4_USREPR) NOT IN ('FAMZ3','BOUNCE','#ME006') "+_cfildtsai +_cFilOS  // AND ZZ4_OPEBGH ='"+MV_PAR10+"' " //-- APENAS OS'S ENCERRADAS
_cQuery += CR + "  JOIN   "+RetSqlName("SA1")+" AS A1E (NOLOCK) "
_cQuery += CR + "  ON     A1E.A1_FILIAL = '"+xFilial("SA1")+"' AND A1E.A1_COD = D1_FORNECE AND A1E.A1_LOJA = D1_LOJA AND A1E.D_E_L_E_T_ = ''  "
_cQuery += CR + "  JOIN   "+RetSqlName("SB1")+" AS B1E (NOLOCK) "
_cQuery += CR + "  ON     B1E.B1_FILIAL = '"+xFilial("SB1")+"' AND B1E.B1_COD = D1_COD AND B1E.D_E_L_E_T_ = ''  "
_cQuery += CR + "  LEFT OUTER JOIN   "+RetSqlName("SZ9")+" AS SZ9 (NOLOCK) "
_cQuery += CR + "  ON     Z9_FILIAL = D1_FILIAL AND LEFT(Z9_NUMOS,6) = LEFT(ZZ4_OS,6) AND Z9_IMEI = ZZ4_IMEI AND SZ9.D_E_L_E_T_ = ''  "
_cQuery += CR + "  LEFT OUTER JOIN (SELECT DISTINCT ZZ3.ZZ3_FILIAL,ZZ3.ZZ3_IMEI,ZZ3.ZZ3_NUMOS,ZZ3.ZZ3_LAB FROM " + RetSqlName("ZZ3")+ " AS ZZ3  (NOLOCK) WHERE ZZ3.D_E_L_E_T_ = '' )ZZ31 "
_cQuery += CR + "  	ON (ZZ4.ZZ4_FILIAL = ZZ31.ZZ3_FILIAL AND ZZ4.ZZ4_IMEI = ZZ31.ZZ3_IMEI AND ZZ4.ZZ4_OS = ZZ31.ZZ3_NUMOS) "
_cQuery += CR + "  	LEFT JOIN " + RetSqlName("SZ8")+ " AS SZ8 (NOLOCK) "
_cQuery += CR + "  	ON(ZZ31.ZZ3_LAB = SZ8.Z8_CLIENTE AND SZ9.Z9_SYMPTO = SZ8.Z8_CODSINT) "
_cQuery += CR + "  	LEFT JOIN " + RetSqlName("SZ8") + " AS SZ81 (NOLOCK) "
_cQuery += CR + "  	ON(ZZ31.ZZ3_LAB = SZ81.Z8_CLIENTE AND SZ9.Z9_ACTION = SZ81.Z8_CODSOLU) "

// QUERY PARA DISTINGUIR OSs QUE ESTÃO APROVADAS E VALIDAS NO SISTEMA
_cQuery += CR + "  	LEFT OUTER JOIN "
_cQuery += CR + "  (SELECT Distinct [Work Order] AS OSWCMS FROM WCMSTODAS WHERE rtrim([Claim Status]) In ('Approved','Valid','Authorized')) AS WCMS "
_cQuery += CR + "  ON OSWCMS=ZZ4_OS "

//  QUERY ESPECIfICA PARA GERAR NOVAMENTE OS INVALIDAS,  REJEITADAS E ERROS DE UPLOADS NAO IDENTIfICADOS
//  _cQuery += CR + " INNER JOIN (SELECT OS FROM  OSWCMS_ERROS) AS WCMS_INV ON RTRIM(OS)=RTRIM(ZZ4_OS) "
//  QUERY ESPECIfICA PARA GRAVAR REMARKS ESPECIfICOS EM OS REJEITDAS E INVALIDAS.
// _cQuery += CR + " INNER JOIN (SELECT OS FROM INCLREMARKS ) AS WCMS_REM ON  RTRIM(OS)=RTRIM(ZZ4_OS) "
//  QUERY ESPECIfICA PARA ALTERAR PECAS INVALIDAS
// _cQuery += CR +  " INNER JOIN ( SELECT DISTINCT OS  FROM NEWMATERIAL ) AS WCMS_MAT ON  RTRIM(OS)=RTRIM(ZZ4_OS) "
//  QUERY ESPECIfICA PARA ALTERAR QUANTIDADE APONTADAS A MAIOR
// _cQuery += CR +  " INNER JOIN ( SELECT DISTINCT OS  FROM NEWQUANT ) AS WCMS_QTD ON  RTRIM(OS)=RTRIM(ZZ4_OS) "
//  QUERY ESPECIfICA PARA GERAR NOVAMENTE OS OXIDADAS
// _cQuery += CR + " INNER JOIN (SELECT OS FROM  OSOXIDADAS) AS WCMS_OXI ON RTRIM(OS)=RTRIM(ZZ4_OS) "
//  QUERY ESPECIfICA PARA TRATA CASOS REFEITADOS E ERROS CÓDIGOS ESPECIfICOS
// _cQuery += CR + " INNER JOIN (SELECT OS FROM  WCMS_ERRORCODE_RETIRAR) AS WCMS_ERRCODE ON RTRIM(OS)=RTRIM(ZZ4_OS) "
// QUERY PARA SELECTIONAR OSs ESPECIfICAS
//_cQuery += CR + " INNER JOIN "
//_cQuery += CR + " ( SELECT ZZ4_OS AS OSWCMS FROM DIf_PROT_WCMS "
//_cQuery += CR + " INNER JOIN ( SELECT B1_MODELO,B1_COD,B1_DESC FROM SB1020 WHERE D_E_L_E_T_='') AS B1 "
//_cQuery += CR + " ON ZZ4_CODPRO=B1_COD "
//_cQuery += CR + " LEFT OUTER JOIN ( SELECT ZA_CODTPSE,ZA_FILIAL,ZA_IMEI,ZA_CLIENTE,ZA_LOJA,ZA_NFISCAL,ZA_SERIE,ZA_OSGVS,ZA_NFCOMPR,ZA_DTNFCOM FROM SZA020 WHERE D_E_L_E_T_='' AND ZA_OPERBGH IN ('S05','S06','S07','S08','S09') ) AS ZA "
//_cQuery += CR + " ON ZA_FILIAL=ZZ4_FILIAL AND ZA_IMEI=ZZ4_IMEI AND ZA_NFISCAL=ZZ4_NFENR AND ZA_SERIE=ZZ4_NFESER AND ZA_CLIENTE=ZZ4_CODCLI AND ZA_LOJA=ZZ4_LOJA "
//_cQuery += CR + " WHERE B1_MODELO NOT IN ('D6503','C6833','C6843','C6906') "
//_cQuery += CR + " AND B1_MODELO IN ('','2','C1604','C1904','C2004','D6643','C5303','C6943','D2212','D2243','D2306','D5106', "
//_cQuery += CR + " 'D2403','D5322','D5833','D6543','D6633','E2124','SGP55') ) AS DIfWCM "
//_cQuery += CR + "  ON OSWCMS=ZZ4_OS "

_cQuery += CR + "  WHERE  SD1.D_E_L_E_T_ = '' "
_cQuery += CR + "         AND D1_FILIAL = '"+xFilial("SD1")+"' "
_cQuery += CR + "         AND D1_DTDIGIT >= '"+DTOS(MV_PAR01)+"' AND D1_DTDIGIT <= '"+DTOS(MV_PAR02)+"' "
// Alterado por M.Munhoz em 16/08/2011 - filtro pelo D1_NUMSER eliminado. os registros serao filtrados automaticamente a partir do relacionamento das tabelas SD1 e ZZ4 no JOIN.
//_cQuery += CR + "         AND D1_NUMSER <> '' "
_cQuery += CR + "         AND D1_TIPO = 'B' "
_cQuery += CR + "         AND '"+mv_par05+"' LIKE '%'+D1_LOCAL+'%' "
_cQuery += CR + "         AND OSWCMS IS NULL "
//_cQuery += CR + " AND ZZ4_OS  IN ('9BEM69','9BEZ69','9BEN5U','9BEXPO','9BEZON','9BEZ3S','9BF3DF','9BF0P4','9BETWZ','9BENGY','9BEZ42','9BEHLF','9BEXP6','9BEW2U','9BEWWS','9BEWNS','9BF2CZ','9BF1BB') "
_cQuery += CR + _cFilCliente
_cQuery += CR + _cFilStatus
_cQuery += CR + _cFilFormul
_cQuery += CR + "  ORDER BY ZZ4_OS,ZZ4_IMEI "

_cQuery := strtran(_cQuery, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

nConta   := 0
_aWcms   := {}

_cChave  := _cSintom := _cPosesq := _cDescsy := _cDescac := _cAction  :=_coddefe := ""
QRY->(dbGoTop())
While !QRY->(eof())
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
	
	If QRY->(eof()) .or. (alltrim(_cChave) <> alltrim(QRY->OS) + alltrim(QRY->SSNIN))
		_cChave   := alltrim(QRY->OS) + alltrim(QRY->SSNIN) //Incluso essa variavel aqui -  Edson Rodrigues 30/11/11
		_adefalPN := {}
		_aPNs     := {}
		_CMODEL   := ""
		lswap     := iIf(empty(QRY->SSNOUT),.f.,.t.)
		cpartsw   := iIf(lswap,QRY->PRODOUT,"")
		cpartsw   := iIf(RIGHT(ALLTRIM(cpartsw),2)='-S',SUBSTR(ALLTRIM(cpartsw),1,LEN(ALLTRIM(cpartsw))-2),cpartsw)
		
		lnaosofw  := .t.
		
		If !EMPTY(QRY->MODELCOM)
			
			_CMODEL := QRY->MODELCOM
			
		EndIf
		
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If EMPTY(_CMODEL) .AND. SB1->(DBSeek(xFilial("SB1")+QRY->PRODUTO))
			If !EMPTY(SB1->B1_MODELO)
				_CMODEL := SB1->B1_MODELO
			ElseIf !EMPTY(SB1->B1_XMODELO)
				_CMODEL := SB1->B1_XMODELO
			EndIf
		EndIf
		
		If !EMPTY(cpartsw) .AND. SB1->(DBSeek(xFilial("SB1")+cpartsw))
			If !EMPTY(SB1->B1_XCODFAB) .AND. B1_XCODFAB<>cpartsw
				cpartsw := SB1->B1_XCODFAB
			EndIf
		EndIf
		
		SZA->(dbSetOrder(1)) // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
		If SZA->(dbSeek(xFilial("SZA") + QRY->FORNECE + QRY->LOJA + QRY->NFE + QRY->SERIE + QRY->SSNIN ))
			_cDtCompra := dtos(SZA->ZA_DTNFCOM)
			_cDtCompra := left(_cDtCompra,4)+'-'+substr(_cDtCompra,5,2)+'-'+substr(_cDtCompra,7,2)
			_cNomeRev  := SZA->ZA_NOMEREV
			_CMODEL    := IIf(EMPTY(_CMODEL),SZA->ZA_CODPROD,_CMODEL)
		Else
			dbSelectArea("SZA")
			SZA->(dbSetorder(4)) // ZA_FILIAL + ZA_IMEI + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_STATUS	 (indice criado apenas com NR da nota fiscal pq ocorre muito erro de digitacao da serie).
			If SZA->(dbSeek(xFilial("SZA") + QRY->SSNIN + QRY->FORNECE + QRY->LOJA + QRY->NFE + "V"))
				_cDtCompra := dtos(SZA->ZA_DTNFCOM)
				_cDtCompra := left(_cDtCompra,4)+'-'+substr(_cDtCompra,5,2)+'-'+substr(_cDtCompra,7,2)
				_cNomeRev  := SZA->ZA_NOMEREV
				_CMODEL    := IIf(EMPTY(_CMODEL),SZA->ZA_CODPROD,_CMODEL)
			Else
				_cDtCompra := space(10)
				_cNomeRev  := space(50)
			EndIf
		EndIf
		
		SZ9->(dbSetOrder(2))//Z9_FILIAL, Z9_IMEI, Z9_NUMOS, Z9_SEQ
		If SZ9->(dbSeek( xFilial("SZ9") + QRY->SSNIN + QRY->OS))
			While SZ9->(!Eof()) .And. xFilial("SZ9") == SZ9->Z9_FILIAL .And. alltrim(QRY->OS) == alltrim(SZ9->Z9_NUMOS) .And. alltrim(SZ9->Z9_IMEI) == alltrim(QRY->SSNIN)
				If SZ9->Z9_NIVELRE <> "X"
					If   empty(SZ9->Z9_SINTCOD) .AND. !empty(_cSintom)
						_cSintom	:= _cSintom
					ElseIf !empty(SZ9->Z9_SINTCOD) .and. !empty(_cSintom) .and. !EMPTY(SZ9->Z9_PARTNR)
						If  !alltrim(SZ9->Z9_SINTCOD) $ _cSintom
							_cSintom :=  _cSintom+":"+alltrim(SZ9->Z9_SINTCOD)
						EndIf
					ElseIf !empty(SZ9->Z9_SINTCOD) .and. empty(_cSintom)
						_cSintom	:= SZ9->Z9_SINTCOD
					EndIf
					
					dbSelectArea("ZZ3")
					ZZ3->(dbsetorder(1))  // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
					dbSeek(xFilial("ZZ3") + SZ9->Z9_IMEI  + SZ9->Z9_NUMOS + SZ9->Z9_SEQ  )
					
					clab      := ZZ3->ZZ3_LAB
					cZ8act    :=""
					cZBcfal   :=""
					cZ8falh   :=""
					cZ8actfal :=""
					cpartnr   :=""
					lactvalid := .f.
					lfalvalid := .f.
					lvlfalact := .f.
					llaudo    := .f.
					
					If !EMPTY(SZ9->Z9_PARTNR) .AND. SB1->(DBSeek(xFilial("SB1")+SZ9->Z9_PARTNR))
						cpartnr  := IIf(empty(SB1->B1_XCODFAB),SZ9->Z9_PARTNR,SB1->B1_XCODFAB)
					Else
						cpartnr  := IIf(!empty(SZ9->Z9_PARTNR),SZ9->Z9_PARTNR,"")
					EndIf
					
					dbSelectArea('SX5')
					SX5->(dbSetOrder(1))
					
					If !EMPTY(SZ9->Z9_FAULID) .AND. (((SX5->(dbSeek(xFilial("SX5") + 'ZB' + SZ9->Z9_FAULID)) ) .OR. (SX5->(dbSeek(xFilial("SX5") + 'ZB' + '0'+ALLTRIM(SZ9->Z9_FAULID))) )))
						cZBcfal := SX5->X5_CHAVE
						lfalvalid := .t.
					EndIf
					
					SZ8->(dbSetOrder(2))  // Z8_FILIAL + Z8_CLIENTE + Z8_CODSOLU
					If !EMPTY(SZ9->Z9_ACTION) .AND. (SZ8->(dbSeek(xFilial("SZ8") + clab + SZ9->Z9_ACTION)))
						cZ8falh   := alltrim(SZ8->Z8_CODSINT)
						cZ8act    := alltrim(SZ8->Z8_CODSOLU)
						lactvalid := .t.
					EndIf
					
					SZ8->(dbSetOrder(1))  // Z8_FILIAL + Z8_CLIENTE + Z8_SINT
					If !EMPTY(SZ9->Z9_FAULID) .AND. ((SZ8->(dbSeek(xFilial("SZ8") + clab + '0'+ALLTRIM(SZ9->Z9_FAULID))))  .or. (SZ8->(dbSeek(xFilial("SZ8") + clab + ALLTRIM(SZ9->Z9_FAULID)))))
						cZ8falh   := alltrim(SZ8->Z8_CODSINT)
						cZ8actfal := alltrim(SZ8->Z8_CODSOLU)
						lvlfalact := .t.
					EndIf
					
					cZ8falh := IIf(lfalvalid,cZ8falh,(IIf(lvlfalact,cZ8falh,"")))
					cZ8act  := IIf(lactvalid,cZ8act,(IIf(lvlfalact,cZ8actfal,"")))
					
					If lfalvalid .and. lactvalid .and. lvlfalact
						
						_newaction :=AllTrim(cZ8act) + Space(TamSX3("Z8_CODSOLU")[1]-Len(AllTrim(cZ8act)))
						_newfalha  :=AllTrim(cZ8falh) + Space(TamSX3("Z8_CODSINT")[1]-Len(AllTrim(cZ8falh)))
						SZ8->(dbSetOrder(2))  // Z8_FILIAL + Z8_CLIENTE + Z8_CODSOLU
						
						If !SZ8->(dbSeek(xFilial("SZ8") + clab + _newaction + _newfalha))
							If  alltrim(cZ8act) = "AC09
								cZ8falh := "0106"
							ElseIf   alltrim(cZ8act) $ "AC11/AC36"
								cZ8falh := "0109"
							ElseIf  alltrim(cZ8act) =  "AC05"
								cZ8falh := "0108"
							ElseIf  alltrim(cZ8act) = "AC01"
								cZ8falh := "0101"
							ElseIf  alltrim(cZ8act) = "AC22"
								cZ8falh := "0105"
							Else
								cZ8falh:=""
							EndIf
						EndIf
					Else
						AADD(aerros,{'ERR0',ALLTRIM(SZ9->Z9_NUMOS),ALLTRIM(SZ9->Z9_IMEI),SZ9->Z9_SEQ,"ACTION CODE E OU CODIGO DE FALHA NAO APONTADOS" ,"Inclua o Action code e a Falha no Apontamento. Não gerado no Arquivo WCMS",'1',''})
					EndIf
					
					If  !empty(cZ8act) .and.  alltrim(cZ8act) == "AC25"
						llaudo    := .t.
					EndIf
					If lswap // VALIDA SWAPS / BOARD / KIT
						
						If Select("QRYEXCH") > 0
							QRYEXCH->(dbCloseArea())
						EndIf
						
						CEXQUERY:="SELECT EXCHANGEKIT,EXCHANGEPBAKIT FROM SONYCROSSREFLIST20150513 WHERE RTRIM(UPPER(MODEL))='"+_CMODEL+"' "
						
						TCQUERY CEXQUERY NEW ALIAS QRYEXCH
						
						dbSelectArea("QRYEXCH")
						dbGoTop()
						_lencdpy := .F.
						While !QRYEXCH->(EOF())
							If alltrim(cZ8act) $  "AC09/AC11"  .AND. !Empty(QRYEXCH->EXCHANGEKIT) .AND. ALLTRIM(QRYEXCH->EXCHANGEKIT)== ALLTRIM(cpartsw)
								_lencdpy := .T.
							ElseIf  alltrim(cZ8act) =  "AC36"  .AND. !Empty(QRYEXCH->EXCHANGEPBAKIT) .AND. ALLTRIM(QRYEXCH->EXCHANGEPBAKIT)== ALLTRIM(cpartsw)
								_lencdpy := .T.
							EndIf
							
							If alltrim(cZ8act) $  "AC09/AC11" .AND. !Empty(QRYEXCH->EXCHANGEKIT) .AND. !_lencdpy
								cpartsw := ALLTRIM(QRYEXCH->EXCHANGEKIT)
							ElseIf alltrim(cZ8act) =  "AC36" .AND.  !Empty(QRYEXCH->EXCHANGEPBAKIT) .AND. !_lencdpy
								cpartsw := ALLTRIM(QRYEXCH->EXCHANGEPBAKIT)
							EndIf
							QRYEXCH->(dbSkip())
						EndDo
						
						If empty(cpartsw) .or. cpartsw == "Not available yet"
							If Select("QRYUNIEX") > 0
								QRYUNIEX->(dbCloseArea())
							EndIf
							
							CUNIEXCH:="SELECT * FROM NEWEXCHUNIT WHERE RTRIM(UPPER(OS))='"+ALLTRIM(SZ9->Z9_NUMOS)+"' "
							
							TCQUERY CUNIEXCH NEW ALIAS QRYUNIEX
							
							dbSelectArea("QRYUNIEX")
							dbGoTop()
							While !QRYUNIEX->(EOF()) .AND. !EMPTY(QRYUNIEX->OS)
								cpartsw := ALLTRIM(QRYUNIEX->PARTSW)
								QRYUNIEX->(dbSkip())
							EndDo
						EndIf
						
						cpartnr :=""
						If alltrim(cZ8act) $  "AC09/AC11/AC36"
							_nPosactd := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+SUBSTR(alltrim(cZ8act),3,2)})
							If _nPosactd <= 0
								If  !empty(cZ8falh)
									_nPospnsw := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[8] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+cpartsw})
									If _nPospnsw <= 0
										AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,iIf(lswap,cpartsw,cpartnr),IIf(lswap,1,SZ9->Z9_QTY),SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
									EndIf
								Else
									If  alltrim(cZ8act) = "AC09
										cZ8falh := "0106"
									ElseIf   alltrim(cZ8act) $ "AC11/AC36"
										cZ8falh := "0109"
									EndIf
									_nPospnsw := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[8] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+cpartsw})
									If _nPospnsw <= 0
										AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,iIf(lswap,cpartsw,cpartnr),IIf(lswap,1,SZ9->Z9_QTY),SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
									EndIf
								EndIf
							EndIf
						Else
							AADD(aerros,{'ERR0',ALLTRIM(SZ9->Z9_NUMOS),ALLTRIM(SZ9->Z9_IMEI),SZ9->Z9_SEQ,"ACTION CODE "+cZ8act+" INVALIDO. NAO É ACTION DE SWAP","Corrija o codigo no apontamento. Possiveis cod. corretos  AC09/AC11/AC36. Nao gerado no Arquivo WCMS",'2',''})
						EndIf
					ElseIf llaudo // VALIDA LAUDO
						// Colocar regra, nao esta definido operacionalmente e muito menos no Sistema - Edson Rodrigues
						_nPosactd := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+"25"})
						If _nPosactd > 0
							//_adefalPN[_nPosactd,12]:="X"
						Else
							If EMPTY(cZ8falh)
								If  alltrim(cZ8act) = "AC25"
									cZ8falh := "0115"
								EndIf
							EndIf
							AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,iIf(lswap,cpartsw,cpartnr),IIf(lswap,1,SZ9->Z9_QTY),SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
						EndIf
						
						lnaosofw := IIf(lnaosofw,.f.,lnaosofw)
					Else  // VALIDA OUTROS - REPAROS
						If cZ8act =  "AC05" // VALIDA SE JA FOI INCLUSO APONTAMENTO DE SOTWARE PARA OUROS REPAROS
							If lnaosofw
								_nPosactd := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+SUBSTR(alltrim(cZ8act),3,2)})
								If _nPosactd <= 0
									If  !empty(cZ8falh)
										AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,"",SZ9->Z9_QTY,SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
										lnaosofw := .f.
									Else
										cZ8falh := "0108"
										AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,"",SZ9->Z9_QTY,SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
										lnaosofw := .f.
									EndIf
								EndIf
							EndIf
						ElseIf !EMPTY(cpartnr) // VALIDA QUANDO TEM PARTNUMBER APONTADO PARA OUTROS REPAROS
							If cZ8act $ "AC01/AC22"
								If  !empty(cZ8falh)
									_nPospart := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6]+p[8] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+cZ8act+cpartnr})
									If _nPospart <=0
										AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,cpartnr,SZ9->Z9_QTY,SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
									Else
										_adefalPN[_nPospart,9]:=_adefalPN[_nPospart,9]+SZ9->Z9_QTY
									EndIf
								Else
									cZ8falh := IIf(cZ8act = "AC01","0101","0105")
									_nPospart := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6]+p[8] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+cZ8act+cpartnr})
									If _nPospart <=0
										AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,cpartnr,SZ9->Z9_QTY,SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
									Else
										_adefalPN[_nPospart,9]:=_adefalPN[_nPospart,9]+SZ9->Z9_QTY
									EndIf
								EndIf
							Else
								cZ8act  := "AC01"
								cZ8falh := "0101"
								_nPospart := Ascan(_aPNs ,{ |p| p[1]+p[2]+p[3]+p[8] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+cpartnr})
								
								If _nPospart <=0
									AADD(_aPNs,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,cpartnr,SZ9->Z9_QTY,SZ9->Z9_USED,SZ9->Z9_LOCAL,''})
								Else
									_aPNs[_nPospart,9]:=_aPNs[_nPospart,9]+SZ9->Z9_QTY
								EndIf
							EndIf
						ElseIf EMPTY(cpartnr) // VALIDA QUANDO NAO TEM PARTNUMBER APONTADO PARA OUTROS REPAROS
							// altera status para inclusao de Software quando o action code for C041.
							If cZ8act = "AC41"
								lnaosofw := .f.
							EndIf
							
							_nPosactd := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+SUBSTR(alltrim(cZ8act),3,2)})
							
							If _nPosactd <= 0
								If !EMPTY(cZ8act) .and.  !EMPTY(cZ8falh)
									_nPospart := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6]+p[8] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+cZ8act+cpartnr})
									If _nPospart <=0
										AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,cpartnr,SZ9->Z9_QTY,SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
									Else
										_adefalPN[_nPospart,9]:=_adefalPN[_nPospart,9]+SZ9->Z9_QTY
									EndIf
								ElseIf !EMPTY(cZ8act) .and.  EMPTY(cZ8falh)
									SZ8->(dbSetOrder(2))  // Z8_FILIAL + Z8_CLIENTE + Z8_CODSOLU
									If SZ8->(dbSeek(xFilial("SZ8") + clab + cZ8act))
										cZ8falh   :=SZ8->Z8_CODSINT
										_nPospart := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6]+p[8] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+cZ8act+cpartnr})
										If _nPospart <=0
											AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,cpartnr,SZ9->Z9_QTY,SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
										Else
											_adefalPN[_nPospart,9]:=_adefalPN[_nPospart,9]+SZ9->Z9_QTY
										EndIf
									Else
										AADD(aerros,{'ERR0',ALLTRIM(SZ9->Z9_NUMOS),ALLTRIM(SZ9->Z9_IMEI),SZ9->Z9_SEQ,"FAULT CODE: "+ALLTRIM(SZ9->Z9_FAULID)+" INVALIDO PARA O ACTION CODE : "+cZ8act,"Corrija o codigo no apontamento. Possiveis cod. corretos  AC09/AC11/AC36. Nao gerado no Arquivo WCMS",'3',''})
									EndIf
								ElseIf EMPTY(cZ8act) .and.  !EMPTY(cZ8falh)
									SZ8->(dbSetOrder(1))  // Z8_FILIAL + Z8_CLIENTE + Z8_SINT
									If (SZ8->(dbSeek(xFilial("SZ8") + clab + '0'+ALLTRIM(cZ8falh))))  .or. (SZ8->(dbSeek(xFilial("SZ8") + clab + ALLTRIM(cZ8falh))))
										cZ8act    :=SZ8->Z8_CODSOLU
										_nPospart := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6]+p[8] == SZ9->Z9_FILIAL+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+cZ8act+cpartnr})
										If _nPospart <=0
											If !empty(SZ9->Z9_MOTIVO)
												conout("Teste de Motivo")
											EndIf
											AADD(_adefalPN,{SZ9->Z9_FILIAL,SZ9->Z9_IMEI,SZ9->Z9_NUMOS,SZ9->Z9_SEQ,SZ9->Z9_ITEM,SUBSTR(alltrim(cZ8act),3,2),cZ8falh,cpartnr,SZ9->Z9_QTY,SZ9->Z9_USED,SZ9->Z9_LOCAL,SZ9->Z9_MOTIVO})
										Else
											_adefalPN[_nPospart,9]:=_adefalPN[_nPospart,9]+SZ9->Z9_QTY
										EndIf
									Else
										AADD(aerros,{'ERR0',ALLTRIM(SZ9->Z9_NUMOS),ALLTRIM(SZ9->Z9_IMEI),SZ9->Z9_SEQ,"ACTION CODE: "+ALLTRIM(SZ9->Z9_ACTION)+" INVALIDO PARA O FAULT CODE : "+cZ8falh,"Corrija o codigo no apontamento. Possiveis cod. corretos  AC09/AC11/AC36. Nao gerado no Arquivo WCMS",'3',''})
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					If   empty(SZ9->Z9_POSESQU) .AND. !empty(_cPosesq)
						_cPosesq	:=_cPosesq
					ElseIf !empty(SZ9->Z9_POSESQU) .and. !empty(_cPosesq) .and. !EMPTY(SZ9->Z9_PARTNR)
						If  !alltrim(SZ9->Z9_POSESQU) $ _cPosesq
							//_cPosesq := _cPosesq+":"+alltrim(SZ9->Z9_POSESQU)
							_cPosesq := _cPosesq+":"+alltrim(SZ9->Z9_POSESQU)
						EndIf
					ElseIf !empty(SZ9->Z9_POSESQU) .and. empty(_cPosesq)
						_cPosesq	:= SZ9->Z9_POSESQU
					EndIf
				EndIf
				SZ9->(dbSkip())
			EndDo
			// ADICIONA APONTAMENTO DE SOFTWARE QUANDO O MESMO NAO EXISTE
			If  lnaosofw  .and. !lswap
				If len(_adefalPN) > 0
					_nPosactd:=1
					AADD(_adefalPN,{_adefalPN[_nPosactd,1],_adefalPN[_nPosactd,2],_adefalPN[_nPosactd,3],_adefalPN[_nPosactd,4],_adefalPN[_nPosactd,5],"05","0108","",0,_adefalPN[_nPosactd,10],_adefalPN[_nPosactd,11],SZ9->Z9_MOTIVO})
					_nPosactd:=0
				EndIf
			EndIf
			//---------&&&&&&& If QUE CONDICIONA A GERAÇÃO DO ARQUIVO SE TIVER POPULADO O ARRAY _adefalPN[]
			If len(_adefalPN) > 0
				SZ8->(dbSetOrder(2))
				SB2->(dbSetOrder(1))
				//---------&&&&&&& If PARA ACRESCENTAR AS PEÇAS APONTADAS NO ARRAY _adefalPN[], QUE FORAM INCLUSAS NO ARRAY _aPNs[] &&&&&&&& -------------------
				If  len(_aPNs) > 0   .and. len(_adefalPN) > 0
					_nPosactd := 0
					_ltempeca := .f.
					
					For y:=1 to len(_adefalPN)
						If !empty(_adefalPN[y,8])
							_nPosactd:=y
							_ltempeca := .t.
						EndIf
						
						If !_ltempeca
							If (alltrim(_adefalPN[y,6]) $ "01/22") .or. (lswap .and. alltrim(_adefalPN[y,6])="36")
								_nPosactd:=y
							EndIf
						EndIf
					Next
					
					For  x:=1 to len(_aPNs)
						If _nPosactd > 0
							If !empty(_adefalPN[_nPosactd,8])
								_nPospart := Ascan(_adefalPN ,{ |p| p[1]+p[2]+p[3]+p[6]+p[8] == _aPNs[x,1]+_aPNs[x,2]+_aPNs[x,3]+_aPNs[x,6]+_aPNs[x,8]})
								If _nPospart <= 0
									AADD(_adefalPN,{_adefalPN[_nPosactd,1],_adefalPN[_nPosactd,2],_adefalPN[_nPosactd,3],_adefalPN[_nPosactd,4],_adefalPN[_nPosactd,5],_adefalPN[_nPosactd,6],_adefalPN[_nPosactd,7],_aPNs[x,8],_aPNs[x,9],_aPNs[x,10],_aPNs[x,11],_aPNs[x,12]})
								Else
									_adefalPN[_nPospart,9]:=_adefalPN[_nPospart,9]+_aPNs[x,9]
								EndIf
							Else
								_adefalPN[_nPosactd,8]:=_aPNs[x,8]
								_adefalPN[_nPosactd,9]:=_aPNs[x,9]
								_adefalPN[_nPosactd,10]:=_aPNs[x,10]
							EndIf
						Else
							_nPosactd :=1
							AADD(_adefalPN,{_adefalPN[_nPosactd,1],_adefalPN[_nPosactd,2],_adefalPN[_nPosactd,3],_adefalPN[_nPosactd,4],_adefalPN[_nPosactd,5],"01","0101",_aPNs[x,8],_aPNs[x,9],_aPNs[x,10],_aPNs[x,11],_aPNs[x,12]})
							_nPosactd :=len(_adefalPN)
						EndIf
					Next
				EndIf
				
				_lsympadd := .f.
				_chavact  := ""
				_ncustpc  := 0.00
				ncusto    := 0.00
				
				// Query que busca nas tabelas SONYSYMPTOMCODE e SX5  para detectar codigo de sintomas codIficados que não existem.
				If !empty(_cSintom)
					If Select("QRYSYMP") > 0
						QRYSYMP->(dbCloseArea())
					EndIf
					
					cQRYSYMP := " SELECT X5_CHAVE FROM "+RetSqlName("SX5")+"  "
					cQRYSYMP += " INNER JOIN (SELECT * FROM SONYSYMPTOMCODE) AS SYPSONY "
					cQRYSYMP += " ON RTRIM(X5_CHAVE)=RTRIM(SYMPTOMCODEID)"
					cQRYSYMP += " WHERE X5_TABELA='ZS' AND X5_CHAVE='"+ALLTRIM(_cSintom)+"' AND D_E_L_E_T_='' "
					
					TCQUERY cQRYSYMP NEW ALIAS QRYSYMP
					
					dbSelectArea("QRYSYMP")
					dbGoTop()
					If QRYSYMP->(EOF()) .OR. EMPTY(QRYSYMP->X5_CHAVE)
						_cSintom := ""
					EndIf
				EndIf
				
				// Query que busca na tabela OSOXIDADAS as OSs e tiveram apontamento como oxidadas e deverão ser acrescentdos os action code corretos e retirado o ACTION CODE 05
				If Select("QRYOXI") > 0
					QRYOXI->(dbCloseArea())
				EndIf
				lvaloxi    := .f.
				lac11fc102 := .f.
				lac23fc102 := .f.
				lac41fc113 := .f.
				
				_cQryoxi :=  " SELECT OS FROM OSOXIDADAS WHERE RTRIM(OS) =  '"+QRY->OS+"' "
				
				TCQUERY _cQryoxi NEW ALIAS QRYOXI
				
				dbSelectArea("QRYOXI")
				dbGoTop()
				If !QRYOXI->(EOF()) .AND. !EMPTY(QRYOXI->OS)
					lvaloxi := .t.
				EndIf
				
				// Query que busca na tabela WCMS_ERRORCODE_RETIRAR as OSs que de acordo com o errcode deverão ser retirada os action codes divergentes
				If Select("QRYERRCOD") > 0
					QRYERRCOD->(dbCloseArea())
				EndIf
				
				lverrcode := .f.
				_cQryERCD :=  " SELECT * FROM WCMS_ERRORCODE_RETIRAR WHERE RTRIM(OS) =  '"+QRY->OS+"' "
				
				TCQUERY _cQryERCD NEW ALIAS QRYERRCOD
				
				dbSelectArea("QRYERRCOD")
				dbGoTop()
				If !QRYERRCOD->(EOF()) .AND. !EMPTY(QRYERRCOD->OS)
					lverrcode := .t.
				EndIf
				
				For Z:=1 to len(_adefalPN)
					_cact:= alltrim(_adefalPN[z,6])
					_cfal:= iIf(len(alltrim(_adefalPN[z,7]))>=4,right(alltrim(_adefalPN[z,7]),3),alltrim(_adefalPN[z,7]))
					
					//---------&&&&&&& If PARA RETIRAR ACTION CODES, FALHAS OU AMBOS CONFORME DETECTADOS NA QUERY :  WCMS_ERRORCODE_RETIRAR &&&&&&&& -------------------
					If lverrcode .and. (!empty(alltrim(QRYERRCOD->RET_ACTID)) .or. !empty(alltrim(QRYERRCOD->RET_FALTID)))
						If !empty(alltrim(QRYERRCOD->RET_ACTID)) .and. !empty(alltrim(QRYERRCOD->RET_FALTID))
							If  alltrim(QRYERRCOD->RET_ACTID) ==  _cact  .and.  alltrim(QRYERRCOD->RET_FALTID) == _cfal
								_adefalPN[Z,12]:="X"
							EndIf
						ElseIf !empty(alltrim(QRYERRCOD->RET_ACTID)) .and. empty(alltrim(QRYERRCOD->RET_FALTID))
							If  alltrim(QRYERRCOD->RET_ACTID) ==  _cact
								_adefalPN[Z,12]:="X"
							EndIf
						ElseIf empty(alltrim(QRYERRCOD->RET_ACTID)) .and. !empty(alltrim(QRYERRCOD->RET_FALTID))
							If  alltrim(QRYERRCOD->RET_FALTID) == _cfal
								_adefalPN[Z,12]:="X"
							EndIf
						EndIf
					EndIf
					
					//---------&&&&&&& If PARA AACRESCENTAR ACTION CODES, FALHAS OU AMBOS, RETIRAR O ACTION CODE 05 CONFORME DETECTADOS NA QUERY :  OSOXIDADAS - OS OXIDADAS &&&&&&&& -------------------
					If lvaloxi .and. Z < len(_adefalPN)
						If _cact = "05"
							_adefalPN[Z,12]:="X"
						ElseIf _cact = "11" .and. _cfal="102"
							lac11fc102 := .t.
						ElseIf _cact = "23" .and. _cfal="102"
							lac23fc102 := .t.
						ElseIf _cact = "41" .and. _cfal="113"
							lac41fc113 := .t.
						EndIf
					ElseIf lvaloxi .and. Z = len(_adefalPN)
						If _cact = "05"
							_adefalPN[Z,12]:="X"
						EndIf
						If  !lac11fc102 .AND. (_cact <> "11" .OR. _cfal <> "102" )
							_nPosactd:=1
							AADD(_adefalPN,{_adefalPN[_nPosactd,1],_adefalPN[_nPosactd,2],_adefalPN[_nPosactd,3],_adefalPN[_nPosactd,4],_adefalPN[_nPosactd,5],"11","0102","",0,_adefalPN[_nPosactd,10],_adefalPN[_nPosactd,11],''})
							_nPosactd:=0
						EndIf
						
						If  !lac23fc102  .AND. (_cact <> "23" .OR. _cfal <> "102" )
							_nPosactd:=1
							AADD(_adefalPN,{_adefalPN[_nPosactd,1],_adefalPN[_nPosactd,2],_adefalPN[_nPosactd,3],_adefalPN[_nPosactd,4],_adefalPN[_nPosactd,5],"23","0102","",0,_adefalPN[_nPosactd,10],_adefalPN[_nPosactd,11],''})
							_nPosactd:=0
						EndIf
						
						If  !lac41fc113  .AND. (_cact <> "41" .OR. _cfal <> "113" )
							_nPosactd:=1
							AADD(_adefalPN,{_adefalPN[_nPosactd,1],_adefalPN[_nPosactd,2],_adefalPN[_nPosactd,3],_adefalPN[_nPosactd,4],_adefalPN[_nPosactd,5],"41","0113","",0,_adefalPN[_nPosactd,10],_adefalPN[_nPosactd,11],''})
							_nPosactd:=0
							
						EndIf
					EndIf
					
					//---------&&&&&&& If PARA CORRECOES DE SINTORMAS &&&&&&&& -------------------
					If empty(_cSintom)  .AND. !empty(_adefalPN[z,6]) .AND. !empty(_adefalPN[z,7])
						If _cact $ "01/05/23/25"  .and. _cfal $ "101/107/108/102"
							If  Z = 1 .OR. EMPTY(_cSintom)
								_cSintom := "0501"
							Else
								If  !"0501" $  _cSintom
									_cSintom :=  _cSintom+":"+"0501"
								EndIf
							EndIf
						ElseIf _cact ="14/44"  .and. _cfal = "114"
							If  Z = 1 .OR. EMPTY(_cSintom)
								_cSintom := "1602"
							Else
								If  !"1602" $  _cSintom
									_cSintom :=  _cSintom+":"+"1602"
									
								EndIf
							EndIf
							
						ElseIf _cact ="23"  .and. _cfal = "115"
							If  Z = 1 .OR. EMPTY(_cSintom)
								_cSintom := "0199"
							Else
								If  !"0199" $  _cSintom
									_cSintom :=  _cSintom+":"+"0199"
								EndIf
							EndIf
						ElseIf _cact ="25"  .and. _cfal = "115"
							If  Z = 1 .OR. EMPTY(_cSintom)
								_cSintom := "0701"
							Else
								If  !"0701" $  _cSintom
									_cSintom :=  _cSintom+":"+"0701"
								EndIf
							EndIf
						ElseIf _cact  $ "11/36/09"  .and. _cfal $ "102/109/110/109/119/117/113/111"
							If  Z = 1 .OR. EMPTY(_cSintom)
								_cSintom := "0599"
							Else
								If  !"0599" $  _cSintom
									_cSintom :=  _cSintom+":"+"0599"
								EndIf
							EndIf
						ElseIf  _cact  $ "41"   .AND. _cfal $ "113"
							If  Z = 1 .OR. EMPTY(_cSintom)
								_cSintom := "0799"
							Else
								If  !"0799" $  _cSintom
									_cSintom :=  _cSintom+":"+"0799"
								EndIf
							EndIf
						EndIf
					EndIf
					
					If  !empty(_cSintom) .and. _cSintom='0710'
						_cSintom := "0799"
					ElseIf !empty(_cSintom) .and. _cSintom $ '0502/0504/0508'
						_cSintom := "0599"
					EndIf
					
					If len(_aPNs) <= 0  .and. ((alltrim(_adefalPN[z,6]) $ "01/22") .or. (lswap .and. alltrim(_adefalPN[z,6]) $ "36/11/09")) .and. empty(alltrim(_adefalPN[z,8]))
						_adefalPN[Z,12]:="X"
					EndIf
				Next Z
				
				// -----********* FOR PARA GRAVACAO DO ARQUIVO TEMPORARIO E GERACAO DO ARQUIVO TXT  ********************----------------
				For Z:=1 to len(_adefalPN)
					If _adefalPN[Z,12] <> "X"
						//If empty(_adefalPN[z,8]) .or. _adefalPN[z,12]=="S"
						cPODATE  := ""
						cRETDATE := ""
						cdtsaida := ""
						cremarks := ""
						
						If !empty(QRY->DTDOCSAI)
							cdtsaida := QRY->DTDOCSAI
						ElseIf !EMPTY(QRY->NFSDAT)
							cdtsaida := QRY->NFSDAT
						ElseIf  !EMPTY(QRY->SWNFDT)
							cdtsaida := QRY->SWNFDT
						ElseIf  EMPTY(QRY->SWNFDT) .AND. EMPTY(QRY->NFSDAT) .AND.  EMPTY(QRY->DTDOCSAI) .AND. !EMPTY(QRY->REPCOMPDAT) .AND. (QRY->STATBGH ='8' .AND. !EMPTY(QRY->SSNOUT)) .OR. (QRY->STATBGH ='9')
							cdtsaida := QRY->REPCOMPDAT
						EndIf
						
						If (STOD(QRY->POPDATE) <= STOD(QRY->DTRECEIVED) .AND. STOD(QRY->POPDATE) <= STOD(QRY->REPCOMPDAT) .AND.  STOD(QRY->POPDATE) <= STOD(cdtsaida))
							cPODATE := QRY->POPDATE
						ElseIf  (STOD(QRY->POPDATE) > STOD(QRY->DTRECEIVED) .AND. STOD(QRY->POPDATE) <= STOD(QRY->REPCOMPDAT) .AND.  STOD(QRY->POPDATE) <= STOD(cdtsaida))
							cPODATE := QRY->DTRECEIVED
						ElseIf  (STOD(QRY->POPDATE) <= STOD(QRY->DTRECEIVED) .AND. STOD(QRY->POPDATE) > STOD(QRY->REPCOMPDAT) .AND. STOD(QRY->POPDATE) <= STOD(cdtsaida))
							cPODATE := QRY->REPCOMPDAT
						ElseIf  (STOD(QRY->POPDATE) <= STOD(QRY->DTRECEIVED) .AND. STOD(QRY->POPDATE) <= STOD(QRY->REPCOMPDAT) .AND. STOD(QRY->POPDATE) >  STOD(cdtsaida))
							If empty(QRY->DTDOCSAI) .AND. empty(QRY->NFSDAT)
								cPODATE := QRY->POPDATE
							ElseIf !empty(QRY->DTDOCSAI) .AND. empty(QRY->NFSDAT)
								cPODATE := QRY->DTDOCSAI
							ElseIf empty(QRY->DTDOCSAI) .AND. !empty(QRY->NFSDAT)
								cPODATE := QRY->NFSDAT
							EndIf
						EndIf
						
						If !empty(QRY->DTDOCSAI)
							cRETDATE := QRY->DTDOCSAI
						ElseIf  !empty(QRY->NFSDAT)
							cRETDATE :=  QRY->NFSDAT
						ElseIf  !empty(QRY->SWNFDT)
							cRETDATE :=  QRY->SWNFDT
						ElseIf (QRY->STATBGH ='8' .AND. !EMPTY(QRY->SSNOUT)) .OR. (QRY->STATBGH ='9')
							cRETDATE :=  QRY->REPCOMPDAT
						Else
							cRETDATE := DTOC(DATE())
						EndIf
						_nPoserro := Ascan(aerros ,{ |e| alltrim(e[2])+alltrim(e[3]) == alltrim(QRY->OS)+alltrim(QRY->SSNIN)})
						If _nPoserro > 0
							For d:=1 to len(aerros)
								If   alltrim(aerros[d,2])+alltrim(aerros[d,3]) == alltrim(QRY->OS)+alltrim(QRY->SSNIN) .AND. aerros[d,7]='1'
									aerros[d,8]:="X"
								ElseIf  alltrim(aerros[d,2])+alltrim(aerros[d,3]) == alltrim(QRY->OS)+alltrim(QRY->SSNIN) .AND. aerros[d,7]='2' .AND. (lswap .and. alltrim(_adefalPN[z,6]) $ "36/11/09")
									aerros[d,8]:="X"
								EndIf
							Next
						EndIf
						
						// Query que busca na tabela SZ9 as OSs que deverao ter incluso o codigo  ou uma descriçao no campo Z9_MOTIVO
						If Select("QRYREM") > 0
							QRYREM->(dbCloseArea())
						EndIf
						
						_cQryrem := "SELECT Z9_NUMOS, Z9_MOTIVO FROM SZ9020 WHERE RTRIM(Z9_NUMOS) = '" + QRY->OS + "'"
						
						TCQUERY _cQryrem NEW ALIAS QRYREM
						
						dbSelectArea("QRYREM")
						dbGoTop()
						If !QRYREM->(EOF()) .AND. !EMPTY(QRYREM->Z9_MOTIVO)
							cremarks := ALLTRIM(QRYREM->Z9_MOTIVO)
						EndIf
						
						// Query que busca na tabela NEWMATERIAL as OSs e pecas que deverao ter o codigo de peca substituido por outro
						If Select("QRYMAT") > 0
							QRYMAT->(dbCloseArea())
						EndIf
						
						_cQrymat :=  " SELECT * FROM NEWMATERIAL WHERE RTRIM(OS) =  '"+QRY->OS+"' AND RTRIM(OLDPECA)='"+ALLTRIM(_adefalPN[z,8])+"' "
						
						TCQUERY _cQrymat NEW ALIAS QRYMAT
						
						dbSelectArea("QRYMAT")
						dbGoTop()
						If !QRYMAT->(EOF()) .AND. !EMPTY(QRYMAT->NEWPECA)
							_adefalPN[z,8] := ALLTRIM(QRYMAT->NEWPECA)
						EndIf
						
						// Query que busca na tabela NEWQUANT as OSs e pecas que deverao ter a quantidade alterada.
						If Select("QRYQTD") > 0
							QRYQTD->(dbCloseArea())
						EndIf
						
						_cQryqtd :=  " SELECT OS,PECA,QTDEORI,QTDENEW FROM NEWQUANT WHERE RTRIM(OS) =  '"+QRY->OS+"' AND RTRIM(PECA)='"+ALLTRIM(_adefalPN[z,8])+"' "
						
						TCQUERY _cQryqtd NEW ALIAS QRYQTD
						
						dbSelectArea("QRYQTD")
						dbGoTop()
						If !QRYQTD->(EOF()) .AND. !EMPTY(QRYQTD->PECA)
							_adefalPN[z,9] := ALLTRIM(QRYQTD->QTDENEW)
						EndIf
						
						// Alimentar arquivo temporario TRB com resultado da Query, tratando o campo de Sintoma
						reclock("TRB",.t.)
						TRB->OS			:= QRY->OS	//_aWcms[x,01]
						TRB->SERVLOCID  := QRY->SERVALOCID //_aWcms[x,02]
						TRB->POPDATE	:= cPODATE
						TRB->POPSUPPLIE	:= QRY->POPSUPPLIE//_aWcms[x,05]
						TRB->DTRECEIVED	:= QRY->DTRECEIVED//_aWcms[x,06]
						TRB->TIMERECVED := QRY->REPCOMPTIM//_aWcms[x,09] ****Melhorar
						TRB->REPCOMPDAT	:= QRY->REPCOMPDAT//_aWcms[x,08]
						TRB->REPCOMPTIM	:= QRY->REPCOMPTIM//_aWcms[x,09]
						TRB->PHONRETDAT := cRETDATE //left(_aWcms[x,25],4)+'-'+substr(_aWcms[x,25],5,2)+'-'+substr(_aWcms[x,25],7,2)
						TRB->PHONRETIME := QRY->REPCOMPTIM//_aWcms[x,09]****Melhorar
						TRB->PRODCTYPE  := QRY->PRODTYPE  //_aWcms[x,12]
						TRB->MODELNO    := _CMODEL     //_aWcms[x,13]
						TRB->SSNIN		:= QRY->SSNIN
						TRB->SSNOUT		:= QRY->SSNOUT
						TRB->SWREVSTAT  := QRY->SWREVSTAT//_aWcms[x,16]
						TRB->FAUTID		:= iIf(len(alltrim(_adefalPN[z,7]))>=4,right(alltrim(_adefalPN[z,7]),3),alltrim(_adefalPN[z,7]))
						TRB->ACTIONID	:= _adefalPN[z,6]
						TRB->MATQTY		:= Transform(iIf(empty(_adefalPN[z,9]) .and. !empty(_adefalPN[z,8]) ,1,_adefalPN[z,9]),"@E 999")//_aWcms[x,19]
						TRB->MATNR		:= ALLTRIM(_adefalPN[z,8])//_aWcms[x,20]
						TRB->REUSEDID	:= _adefalPN[z,10]//_aWcms[x,21]
						TRB->SYMPTOMID	:= _cSintom
						TRB->REMARKS	:= cremarks
						
						/*
						TRB->DESCACTION	:= Posicione("SZ8",2,xFilial("SZ8") + QRY->LAB + Left(_cAction,4), "Z8_DESSOLU" )//_aWcms[x,32]
						TRB->DESCSYMPT	:= Posicione("SZ8",1,xFilial("SZ8")+ QRY->LAB + Left(_cSintom,4), "Z8_DESSINT" )//_aWcms[x,31]
						TRB->DTCOMPRA	:= _cDtCompra
						TRB->CLIENTE	:= QRY->CLIENTE//_aWcms[x,04]
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
						*/
						
						msunlock()
						nConta++
						
						cLin:= QRY->OS+cTAB+QRY->SERVALOCID+cTAB+cPODATE+cTAB+QRY->POPSUPPLIE+cTAB+QRY->DTRECEIVED+cTAB+QRY->REPCOMPTIM+cTAB
						cLin+= QRY->REPCOMPDAT+cTAB+QRY->REPCOMPTIM+cTAB+cRETDATE+cTAB
						cLin+=QRY->REPCOMPTIM+cTAB+QRY->PRODTYPE+cTAB+_CMODEL+cTAB+QRY->SSNIN+cTAB+QRY->SSNOUT+cTAB+QRY->SWREVSTAT+cTAB+iIf(len(alltrim(_adefalPN[z,7]))>=4,right(alltrim(_adefalPN[z,7]),3),alltrim(_adefalPN[z,7]))+cTAB
						cLin+=_adefalPN[z,6]+cTAB+Transform(iIf(empty(_adefalPN[z,9]) .and. !empty(_adefalPN[z,8]) ,1,_adefalPN[z,9]),"@E 999")+cTAB+alltrim(_adefalPN[z,8])+cTAB+_adefalPN[z,10]+cTAB+_cSintom+cTAB+cremarks+cEOL
						
						If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
							If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
								Return
							EndIf
						EndIf
						_larqtxt:=.t.
						
						//next x
						_cAction	:= ""
						_cPosesq	:= ""
						_cDescsy	:= ""
						_cDescac	:= ""
						_aWcms   := {}
						
						//EndIf
					EndIf
				Next Z
				
				_cSintom 	:= ""
				
			EndIf
		Else
			AADD(aerros,{'ERR0',ALLTRIM(QRY->OS),ALLTRIM(QRY->SSNIN),SZ9->Z9_SEQ,"NAO HOUVE NENHUM APONTAMENTO DE ACTION CODE, CODIGO DE FALHA, OU PEÇAS" ,"Inclua apontamento para a OS. Não gerado no Arquivo WCMS",'2',''})
		EndIf
	EndIf
	QRY->(dbSkip()) // incluso do SKIP aqui - Edson Rodrigues 30/11/11
EndDo

QRY->(dbCloseArea())

fClose(nHdl)

If !_larqtxt
	MsgAlert("Não foi gerado dados para o arquivo : "+ALLTRIM(cArqTxt)+". VerIfique os parametros.","Atencao!")
EndIf

//_cArq  := "WCMS_NOVO_"+Alltrim(cUserName)+".XLS"
_cArq    := "WCMS_NOVO.XLS"
_cArqTmp := lower(AllTrim(__RELDIR)+_cArq)
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

//Incluso Edson Rodrigues - 25/05/10
cArqorig := cStartPath+_cArqSeq+".dtc"
cArqdest := lower(AllTrim(__RELDIR))+"WCMS_NOVO.CSV"

//ALERT("Arquivo: "+_cArqTmp)

If nConta > 0
	If file(_cArqTmp) .and. ferase(_cArqTmp) == -1
		If !ApMsgYesNo("O arquivo: " + _cArq + " não pode ser gerado porque deve estar sendo utilizado. Deseja tentar novamente? " )
			_lOpen := .t.
			ApMsgInfo("O arquivo Excel não foi gerado. ")
		EndIf
	Else
		dbselectarea("TRB")
		dbGoTop()
		
		//copy to (_cArqTmp) VIA "DBFCDXADS"
		//USE (_cArqTmp) VIA "DBFCDXADS" NEW
		//USE
		//CpyS2T(cDirDocs+"\"+_cArq+".CSV" , cPath, .T. )
		
		//Incluso Edson Rodrigues - 25/05/10
		lgerou:=  U_CONVARQ(cArqorig,cArqdest)
		
		If lgerou
			If !ApOleClient( 'MsExcel' )
				MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
			Else
				//oExcelApp := MsExcel():New()
				//oExcelApp:WorkBooks:Open("\\"+_csrvapl+lower(cArqdest)) // Abre uma planilha
				//oExcelApp:SetVisible(.T.)
				ShellExecute( "Open" , "\\"+_csrvapl+cArqdest ,"", "" , 3 )
			EndIf
			
			If len(aerros) > 0
				_nPoserro := Ascan(aerros ,{ |e| alltrim(e[8]) == ''})
				If _nPoserro > 0
					apMsgStop("Ocorreram erros na geracao do arquivo WCMS.  Imprima e verIfique e corrija os erros encontrados.")
					U_ERROWCMS(aerros)
					aerros:={}
				EndIf
			EndIf
		Else
			msgstop("Nao existem dados gerados para esse relatorio. VerIfique os parametros do relatorio.","Arquivo Vazio","STOP")
			If len(aerros) > 0
				_nPoserro := Ascan(aerros ,{ |e| alltrim(e[8]) == ''})
				If _nPoserro > 0
					apMsgStop("Ocorreram erros na geracao do arquivo WCMS.  Imprima e verIfique e corrija os erros encontrados.")
					U_ERROWCMS(aerros)
					aerros:={}
				EndIf
			EndIf
		EndIf
	EndIf
Else
	msgstop("Não existem dados gerados para esse relatório. VerIfique os parâmetros do relatório.","Arquivo Vazio","STOP")
	If len(aerros) > 0
		_nPoserro := Ascan(aerros ,{ |e| alltrim(e[8]) == ''})
		If _nPoserro > 0
			apMsgStop("Ocorreram erros na geracao do arquivo WCMS.  Imprima e verIfique e corrija os erros encontrados.")
			U_ERROWCMS(aerros)
			aerros:={}
		EndIf
	EndIf
EndIf

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
PutSX1(cPerg,"05","Armz Entrada Eqto?"		,"Armz Entrada Eqto?"		,"Armz Entrada Eqto?"		,"mv_ch5","C",20,0,0,"G","",""	,"",,"mv_par05",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"06","Cod.Cliente?"			,"Cod.Cliente?"				,"Cod.Cliente?"				,"mv_ch6","C",06,0,0,"G","",""	,"",,"mv_par06",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"07","Status?"					,"Status?"					,"Status?"					,"mv_ch7","N",01,0,0,"C","",""	,"",,"mv_par07","Todos"	,"","","","Com NF"	,"","","Sem NF"	,"","","","","","","","")
PutSX1(cPerg,"08","Formulario Proprio?"		,"Formulario Proprio?"		,"Formulario Proprio?"		,"mv_ch8","N",01,0,0,"C","",""	,"",,"mv_par08","Todos"	,"","","","Sim"		,"","","Nao"	,"","","","","","","","")
PutSX1(cPerg,"09","OSs? (Separado ;) "		,"OSs? (Separado ;) "		,"OSs? (Separado ;) "		,"mv_ch9","C",60,0,0,"G","",""	,"",,"mv_par09",""		,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"10","Operacao"				,"Operacao"				    ,"Operacao" 				,"mv_cha","C",3,0,0,"G","","ZZJ"	,"",,"mv_par10",""	,"","","",""		,"","",""	,"","","","","","","","")

Return NIL