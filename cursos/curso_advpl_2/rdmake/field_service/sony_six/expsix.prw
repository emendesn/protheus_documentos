#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EXPSIX   º Autor ³ Edson Rodrigues    º Data ³  01/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exporta dados para integração com SIX                      º±±
±±º          ³ Processo Sony Brasil                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function expsix()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oGeraTxt
Private cPerg := "EXPSIX"

u_GerA0003(ProcName())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01 - atendimento de  :(   / /  )            |
//|mv_par02 - atendimento ate :(   / /  )            |
//|mv_par03 - 1-Abertura / 2-Compra peças GTA,       |
//³           3-Compra Peças FOG / 4-Encerramento    |
//|mv_par04 - Exportar arquivo ? 1 - Novo            |
//|                              2 - Reprocessar     |
//|mv_par05 - Nome do arquivo                        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("ZZ4")
dbSetOrder(1)    //ZZ4_FILIAL+ZZ4_IMEI

CriaSX1()
Pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa gera um arquivo texto, conforme os parametros "
@ 18,018 Say " definidos  pelo usuario,  com os registros dos apontamentos "
@ 26,018 Say " da operação Sony Brasi para exportação ao SIX "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  08/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cArqTxt := lower(AllTrim(__RELDIR)+ Alltrim(mv_par05)) + ".TXT"
Private csoftout,csoftin,cqual,ctransc,cartime,cminumb,_cproblem1,_cproblem2,_crepair1,_crepair2,_cLab,_ccodrecl

If FILE(cArqTxt)
	If !msgbox("Já existe um arquivo com este nome. Deseja substituir?","Atencao!","YESNO")
		Close(oGeraTxt)
		Return
	Endif
Endif
Private nHdl    := fCreate(cArqTxt)
Private cEOL    := "CHR(13)+CHR(10)"
Private cTAB    := CHR(09)
Private aerros :={}

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")

If len(aerros) > 0
    apMsgStop("Ocorreram erros na geracao do arquvio SIX.  Imprima, verifique e corrija os erros encontrados.")
     U_tecrx038(aerros)
    aerros:={}
Endif                                                                                                               

apMsgStop("Processamento Finalizado.")


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  08/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont
Local   cDtcriOS:=substr(dtos(ddatabase),7,2)+'/'+substr(dtos(ddatabase),5,2)+'/'+left(dtos(ddatabase),4)
Local nTamLin, cLin, cCpo
Local  CR        :=""                
Local _larqtxt   :=.f.               
local _apartenc  :={}
local _apartsz9  :={}
Local _aenczz3   :={}
Local _aqryzz3   :={}

dbSelectArea("ZZG")
ZZG->(dbSetOrder(1))
dbSelectArea("SB1")
SB1->(dbsetOrder(1))
dbSelectArea("SZ9")
SZ9->(dbsetOrder(2))  // Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM
dbSelectArea("ZZ4")
ZZ4->(dbsetOrder(1))
dbSelectArea("ZZ3")
ZZ3->(dbsetOrder(1))
dbSelectArea("SA1")
SA1->(dbsetOrder(1))
dbselectarea("ZZ7")
dbsetorder(3) //ZZ7.ZZ7_IMEI + ZZ7.ZZ7_NUMOS + ZZ7.ZZ7_SEQ



IF EMPTY(ALLTRIM(MV_PAR05))
    MsgAlert("Favor informar o nome do arquivo","Atencao!")
    return
ENDIF

_cStr := "SP_PRODSONYB"
if TCSPExist(_cStr)
	TCSqlExec(_cStr)
Else
	conout("Srtore Procedure não encontrada.")
	//Colocado para executar a procedure, pois a funcao TCSPEXIST nao encontra a procedure mesmo a mesma existindo. 13/05/10 Edson Rodrigues
	TCSqlExec(_cStr)
Endif

_cCount := "SELECT COUNT(*) NRREG"
_cSelect:= " SELECT    "+cEOL
If MV_PAR03 == 1
	_cSelect+= " '4' AS TIPO,      "+cEOL
ELSEIF MV_PAR03 == 2
	_cSelect+= " '1' AS TIPO,      "+cEOL
ELSEIF MV_PAR03 == 3
	_cSelect+= " '2' AS TIPO,      "+cEOL
ELSEIF MV_PAR03 == 4
	_cSelect+= " '3' AS TIPO,      "+cEOL
ENDIF
_cSelect+= " '61126' AS CODEASC, "+cEOL
IF MV_PAR03 == 3
	_cSelect+= "  '' AS MODEL,   "+cEOL
	_cSelect+= "  '' AS SERIALNUMBER,   "+cEOL
	_cSelect+= "  '' AS WARRANTYNUMBER, "+cEOL
	_cSelect+= "  '' AS BUYDATE,      "+cEOL
	_cSelect+= "  '' AS SERVICEORDER, "+cEOL
	_cSelect+= "  '' AS STARTDATE,    "+cEOL
	_cSelect+= "  '' AS ENDOFREPAIR,  "+cEOL
	_cSelect+= "  '' AS DELIVERYDATE, "+cEOL
ELSE
	_cSelect+= "   RTRIM(B1_MODELO) AS MODEL, "+cEOL
	_cSelect+= "   SERIALNUMBER=CASE WHEN (ZZ4_NFESER='003' OR D1_XLOTE LIKE '%CORR%') THEN RIGHT(RTRIM(ZZ4_IMEI),7)+'SDX' "
	_cSelect+= "        WHEN LEFT(UPPER(B1_DESC),3) IN ('NOT','NET') THEN RTRIM(ZZ4_IMEI) "+cEOL
	_cSelect+= "        WHEN (ZZ4_NFESER='003' OR D1_XLOTE LIKE '%CORR%') THEN RIGHT(RTRIM(ZZ4_IMEI),7)+'SDX' "+cEOL 
	_cSelect+= "        ELSE RIGHT(RTRIM(ZZ4_IMEI),7)+'IRC' END,"+cEOL
	_cSelect+= "   '1' WARRANTYNUMBER, "+cEOL
	_cSelect+= "   BUYDATE=CASE WHEN ZA_DTNFCOM='' OR ZA_DTNFCOM IS NULL THEN ZZ4_NFEDT ELSE ZA_DTNFCOM END, "+cEOL
	_cSelect+= "   RTRIM(ZZ4_OS) AS SERVICEORDER,   "+cEOL
	_cSelect+= "   LEFT(ZZ4_ATPRI,8) AS STARTDATE,  "+cEOL
	                                       
	IF MV_PAR03 == 4
    	_cSelect+= "   LEFT(ZZ4_ATULT,8) AS ENDOFREPAIR, "+cEOL
	    _cSelect+= "   ZZ4_NFSDT AS DELIVERYDATE, "+cEOL
    ELSE
      	_cSelect+= "  '' AS ENDOFREPAIR,  "+cEOL
      	_cSelect+= "  '' AS DELIVERYDATE, "+cEOL
    ENDIF

ENDIF
If MV_PAR03 == 1
	_cSelect+= "   '1' AS STATUS,      "+cEOL
ELSEIF MV_PAR03 == 2
	_cSelect+= "   '2' AS STATUS,      "+cEOL
ELSEIF MV_PAR03 == 3
	_cSelect+= "   '6' AS STATUS,      "+cEOL
ELSEIF MV_PAR03 == 4
	_cSelect+= "   '4' AS STATUS,      "+cEOL
ENDIF
_cSelect+= " '' AS STOCKCOMERCIO,      "+cEOL
_cSelect+= " '' AS TECNICANID,         "+cEOL
_cSelect+= " '' AS DOMICILIOTALLER,    "+cEOL
IF MV_PAR03 == 3
	_cSelect+= " '' AS CUSTOMERNAME, "+cEOL
	_cSelect+= " '' AS CUSTUMERID,   "+cEOL
	_cSelect+= " '' AS PHONE,        "+cEOL
	_cSelect+= " '' AS EMAIL,        "+cEOL
	_cSelect+= " '' AS ADREESS,      "+cEOL
	_cSelect+= " '' AS  SYMPTONISIS, "+cEOL
	_cSelect+= " '' AS  SYMPTONTEXT, "+cEOL
ELSE
	_cSelect+= "   RTRIM(A1_NOME) AS CUSTOMERNAME, "+cEOL
	_cSelect+= "   '1' AS CUSTUMERID,  "+cEOL
	_cSelect+= "    RTRIM(A1_DDD)+RTRIM(A1_TEL) AS PHONE,"+cEOL
	_cSelect+= "    RTRIM(A1_EMAIL) AS EMAIL,            "+cEOL
	_cSelect+= "    LEFT(RTRIM(A1_END),20) AS ADREESS,            "+cEOL
	_cSelect+= "    left(ZZ3_DEFINF,3)+RTRIM(ZZ3_ISICON) AS  SYMPTONISIS,  "+cEOL
	_cSelect+= "    '000000'+Z8_DESSINT AS  SYMPTONTEXT, "+cEOL
ENDIF
_cSelect+= "    '' AS SECTIONISIS,  "+cEOL
_cSelect+= "    '' AS SECTIONTEXT,  "+cEOL
IF MV_PAR03 == 4
	_cSelect+= "    left(ZZ3_DEFINF,2) AS CAUSEISIS,    "+cEOL
	_cSelect+= "     RTRIM(Z8_DESSINT) AS CAUSETEXT,  "+cEOL
ELSE
	_cSelect+= "    '' AS CAUSEISIS,   "+cEOL
	_cSelect+= "    '' AS CAUSETEXT,   "+cEOL
ENDIF

_cSelect+= "    '' AS REPAIRISIS,     "+cEOL
_cSelect+= "    '' AS REPAIRTEXT,     "+cEOL
_cSelect+= "    '' AS REQUESTNUMBER,  "+cEOL
_cSelect+= "    '' AS DATEREQUEST,    "+cEOL
_cSelect+= "    '' AS POSITIONREQUEST,"+cEOL
_cSelect+= "    '' AS PARTNUMBER,     "+cEOL
_cSelect+= "    '' AS QTYREQUEST,     "+cEOL
_cSelect+= "    '' AS PARTDESCRIPTION,"+cEOL
_cSelect+= "    '' AS CLAVEG,         "+cEOL
_cSelect+= "    '' AS DIFFICULT,      "+cEOL
_cSelect+= "    '' AS ADMINCOST,      "+cEOL
_cSelect+= "    '' AS COUNTRYSALES,   "+cEOL
_cSelect+= "    '' AS EQUIPAMENT,     "+cEOL
IF MV_PAR03 == 3
	_cSelect+= "   '' AS DOCUMENT ,   "+cEOL
ELSE
	_cSelect+= "   DOCUMENT=CASE WHEN A1_RG=''THEN RTRIM(ZZ4_OS) ELSE RTRIM(A1_RG) END , "+cEOL
ENDIF
_cSelect+= "'' AS DEALER,   "+cEOL
_cSelect+= "'' AS ADRESSS,  "+cEOL
_cSelect+= "'' AS NUMBER,   "+cEOL
_cSelect+= "'' AS SHIPTO,   "+cEOL
_cSelect+= "'' AS BRANCH,   "+cEOL
_cSelect+= "'' AS FIRSTCONTACT,  "+cEOL
IF MV_PAR03 == 3
	_cSelect+= "  '' AS SURNAME, "+cEOL
ELSE
	_cSelect+= "   SUBSTRING(RTRIM(A1_NOME),PATINDEX('% %' ,RIGHT(RTRIM(A1_NOME),DATALENGTH(RTRIM(A1_NOME))))+1,DATALENGTH(RTRIM(A1_NOME))) AS SURNAME, "+cEOL
ENDIF
_cSelect+= "'' FILLER, "+cEOL
_cSelect+= "    ZZ4_IMEI AS IMEI,"+cEOL
_cSelect+= "    ZZ4_OS AS OS,  "+cEOL
_cSelect+= "    ZZ3_SEQ AS SEQ,"+cEOL
_cSelect+= "    ZZ3_DATA AS DATA,"+cEOL
_cSelect+= "    ZZ3_LAB  AS LAB, "+cEOL
_cSelect+= "    B1_COD  AS CODPRO, "+cEOL
_cSelect+= "    RECZZ3 "+cEOL
_cFrom:= " FROM "+RETSQLNAME("ZZ4")+" ZZ4 (NOLOCK) "+cEOL
_cJoin:= "      LEFT OUTER JOIN "+cEOL
_cJoin+= "           (SELECT ZA_FILIAL,ZA_IMEI,ZA_NFISCAL,ZA_SERIE,ZA_NFCOMPR,ZA_DTNFCOM  "+cEOL
_cJoin+= "            FROM "+RETSQLNAME("SZA")+" (NOLOCK) WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' AND D_E_L_E_T_='') AS SZA "+cEOL
_cJoin+= "      ON ZA_FILIAL=ZZ4_FILIAL AND ZA_IMEI=ZZ4_IMEI AND ZA_NFISCAL=ZZ4_NFENR AND ZA_SERIE=ZZ4_NFESER "+cEOL
_cJoin+= "      INNER JOIN  "+cEOL
_cJoin+= "           (SELECT A1_COD,A1_LOJA,A1_NOME,A1_DDD,A1_TEL,A1_EMAIL,A1_END,A1_RG,A1_CGC,A1_NREDUZ "+cEOL
_cJoin+= "            FROM "+RETSQLNAME("SA1")+" (NOLOCK) WHERE A1_FILIAL='"+XFILIAL("SA1")+"' AND D_E_L_E_T_='') AS SA1 "+cEOL
_cJoin+= "      ON ZZ4_CODCLI=A1_COD AND ZZ4_LOJA=A1_LOJA "+cEOL
_cJoin+= "      LEFT OUTER JOIN "+cEOL
_cJoin+= "           (SELECT D1_DOC,D1_SERIE,D1_ITEM,D1_XLOTE "+cEOL
_cJoin+= "           FROM "+RETSQLNAME("SD1")+" WHERE D1_FILIAL='"+XFILIAL("SD1")+"' AND D_E_L_E_T_='') AS D1  "+cEOL
_cJoin+= "      ON D1_DOC=ZZ4_NFENR AND D1_SERIE=ZZ4_NFESER AND ZZ4_ITEMD1=D1_ITEM "+cEOL
_cJoin+= "      INNER JOIN  "+cEOL
_cJoin+= "           (SELECT B1_COD,B1_MODELO,B1_DESC "+cEOL
_cJoin+= "           FROM "+RETSQLNAME("SB1")+" (NOLOCK) WHERE B1_FILIAL='"+XFILIAL("SB1")+"' AND D_E_L_E_T_='')  AS B1  "+cEOL
_cJoin+= "      ON B1_COD=ZZ4_CODPRO "+cEOL
_cJoin+= "      INNER JOIN  "+cEOL
_cJoin+= "           (SELECT ZZ3_FILIAL,ZZ3_IMEI,ZZ3_LAB,ZZ3_ESTORN,ZZ3_STATUS,ZZ3_NUMOS,ZZ3_DEFINF,Z8_DESSINT,ZZ3_SEQ,ZZ3_TRANSC,ZZ3_DATA,ZZ3_ISICON,R_E_C_N_O_ AS RECZZ3"+cEOL
_cJoin+= "           FROM "+RETSQLNAME("ZZ3")+" ZZ31 (NOLOCK) "+cEOL
_cJoin+= "                 LEFT OUTER JOIN  "+cEOL
_cJoin+= "                   ( SELECT Z8_CODSINT,Z8_DESSINT "+cEOL
_cJoin+= "                        FROM "+RETSQLNAME("SZ8")+" (NOLOCK) WHERE Z8_FILIAL='"+XFILIAL("SZ8")+"' AND D_E_L_E_T_='' AND Z8_CLIENTE='6' AND Z8_CODSINT<>'') AS SZ8 "+cEOL
_cJoin+= "     ON LEFT(ZZ31.ZZ3_DEFINF,3)=RTRIM(Z8_CODSINT) "+cEOL
_cWhere := "         WHERE ZZ31.ZZ3_FILIAL='"+XFILIAL("ZZ3")+"' AND ZZ31.D_E_L_E_T_='' AND ZZ31.ZZ3_LAB='6' AND ZZ31.ZZ3_STATUS='1' AND ZZ31.ZZ3_ESTORN<>'S' "+cEOL
IF MV_PAR04 == 1 .AND. MV_PAR03 == 1
	_cWhere += "         AND ZZ3_TRANSC<>'ABT' "+cEOL
ELSEIF MV_PAR04 == 1 .AND. MV_PAR03 >= 2
	_cWhere += "         AND ZZ3_TRANSC='ABT' "+cEOL
ENDIF
IF !EMPTY(MV_PAR01)
	_cWhere +="          AND ZZ3_DATA>='"+DTOS(MV_PAR01)+"' "+cEOL
ENDIF
IF !EMPTY(MV_PAR01)
	_cWhere += "         AND ZZ3_DATA<='"+DTOS(MV_PAR02)+"' "+cEOL
ENDIF
//_cWhere += "       AND ZZ3_DEFINF<>''      "+cEOL
_cWhere += " ) AS ZZ3 "+cEOL
_cWhere += " ON ZZ4_IMEI=ZZ3.ZZ3_IMEI  AND ZZ4_OS=LEFT(ZZ3.ZZ3_NUMOS,6) "+cEOL
_cWhere += " WHERE ZZ4.ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' AND ZZ4.ZZ4_OPEBGH='Y01' AND ZZ4.D_E_L_E_T_='' "+cEOL
IF MV_PAR03 == 2
	_cWhere += "  AND ZZ4.ZZ4_GARANT<>'N'  "+cEOL
ENDIF
IF MV_PAR03 == 3
	_cWhere += "  AND ZZ4.ZZ4_GARANT='N' "+cEOL
ENDIF
IF MV_PAR03 == 4
	_cWhere += "  AND ZZ4.ZZ4_STATUS>='5' "+cEOL
ENDIF
_cOrder := " ORDER BY ZZ4_OS "+cEOL



_cQryReg := _cCount + _cFrom + _cJoin + _cWhere
_cQryReg := strtran(_cQryReg, CR, "")
//memowrit("mclaims.sql",_cQryReg)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryReg),"REG",.T.,.T.)
dbselectarea("REG")
REG->(dbgotop())
_nReg := REG->NRREG
Procregua(_nReg)
REG->(dbCloseArea())


If select("QRY") > 0
	QRY->(dbCloseArea())
endif
                                    

 _cQuery := _cSelect + _cFrom + _cJoin + _cWhere + _cOrder
//   memowrite("MCLAIMS.SQL",_cQuery )
 _cQuery := strtran(_cQuery, CR, "")
// Gera arquivos temporario com resultado da Query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)


//CABECALHO
cLin:= "TIPO"+cTAB+"CODEASC"+cTAB+"MODEL"+cTAB+"SERIALNUMBER"+cTAB+"WARRANTYNUMBER"+cTAB+"BUYDATE"+cTAB+"SERVICEORDER"+cTAB+"STARTDATE"+cTAB+"ENDOFREPAIR"+cTAB+"DELIVERYDATE"+cTAB
cLin+= "STATUS"+cTAB+"STOCKCOMERCIO"+cTAB+"TECNICANID"+cTAB+"DOMICILIOTALLER"+cTAB+"CUSTOMERNAME"+cTAB+"CUSTUMERID"+cTAB+"PHONE"+cTAB+"EMAIL"+cTAB+"ADREESS"+cTAB
cLin+= "SYMPTONISIS"+cTAB+"SYMPTONTEXT"+cTAB+"SECTIONISIS"+cTAB+"SECTIONTEXT"+cTAB+"CAUSEISIS"+cTAB+"CAUSETEXT"+cTAB+"REPAIRISIS"+cTAB+"REPAIRTEXT"+cTAB+"REQUESTNUMBER"+cTAB+"DATEREQUEST"+cTAB+"POSITIONREQUEST"+cTAB
cLin+= "PARTNUMBER"+cTAB+"QTYREQUEST"+cTAB+"PARTDESCRIPTION"+cTAB+"CLAVEG"+cTAB+"DIFFICULT"+cTAB+"ADMINCOST"+cTAB+"COUNTRYSALES"+cTAB+"EQUIPAMENT"+cTAB+"DOCUMENT"+cTAB
cLin+= "DEALER"+cTAB+"ADRESSS"+cTAB+"NUMBER"+cTAB+"SHIPTO"+cTAB+"BRANCH"+cTAB+"FIRSTCONTACT"+cTAB+"SURNAME"+cTAB+"FILLER"+cEOL


If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif



dbselectarea("QRY")
QRY->(dbGoTop())
If QRY->(!EOF())
	While QRY->(!EOF())
		_apartnum:={}
	
		IF EMPTY(QRY->MODEL)
	       AADD(aerros,{'ERRO',ALLTRIM(QRY->SERVICEORDER),'',ALLTRIM(QRY->MODEL),"Modelo (B1_MODELO)do Produto : "+ALLTRIM(QRY->CODPRO)+" não cadastrado","Corrija o cadastro do  produto. OK gravado no arquivo."})
		ENDIF
		
	
		
		IF (MV_PAR03==2 .OR. MV_PAR03==3)
			dbselectarea("ZZ7")
			IF ZZ7->(dbseek(xFilial("ZZ7") + QRY->IMEI + QRY->OS))
				DO WHILE ZZ7->(!eof()) .and. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .and. ZZ7->ZZ7_IMEI == QRY->IMEI ;
					.and. left(ZZ7->ZZ7_NUMOS,6) == left(QRY->OS,6) .and. ZZ7->ZZ7_DATA  >= MV_PAR01 .and. ZZ7->ZZ7_DATA <= MV_PAR02
					IF ((MV_PAR04==1 .AND. ZZ7->ZZ7_MSEXP<>'1') .OR. (MV_PAR04==2))
						_cpartnr  := IIF(!EMPTY(ZZ7->ZZ7_PARTNR),ZZ7->ZZ7_PARTNR,ZZ7->ZZ7_PECNEW)
						_cquantnr := STRZERO(ZZ7->ZZ7_QTY,2)
						_cpartnew := ZZ7->ZZ7_PECNEW
						_cSEQZZ7  := ZZ7->ZZ7_SEQ
						_cdtreqst := QRY->DATA
						_cnumbreq := IIF(MV_PAR03==3,ZZ7->ZZ7_NUMOS+ZZ7->ZZ7_SEQ,"")
						_cdtoffreq:=""
						_ccodtec  :=""
						_cdomtall :=""
						_cisissect:=""
						_ctextsect:=""
						_cdifficul:=""
						_cisisrepa:=""
						_ctextrepa:=""
						
						IF ZZ3->(dbseek(xFilial("ZZ3")+ ZZ7->ZZ7_IMEI+ZZ7->ZZ7_NUMOS+ZZ7->ZZ7_SEQ))
							_cdtreqst := DTOS(ZZ3->ZZ3_DATA)
						ENDIF
						
						IF SB1->(dbseek(xFilial("SB1")+ _cpartnr))
							_cdescpartn:=ALLTRIM(SB1->B1_DESC)
						ELSE
							_cdescpartn:=""
						ENDIF
						
						AADD(_apartnum,{_cpartnr,_cquantnr,_cdtreqst,_cnumbreq,_cdescpartn,ZZ7->ZZ7_SEQ,_cdtoffreq,_ccodtec,_cdomtall,_cisissect,_ctextsect,_cdifficul,_cisisrepa,_ctextrepa,ZZ7->(RECNO())})
					ENDIF
					ZZ7->(dbskip())
				Enddo
			ELSE 
			   QRY->(dbSkip())
			   loop
			Endif
		ENDIF
		
		
		IF (MV_PAR03==4)       
		
			
			dbselectarea("SZ9")
			IF SZ9->(dbseek(xFilial("SZ9")+ QRY->IMEI+QRY->OS))
				DO WHILE SZ9->(!eof()) .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and. SZ9->Z9_IMEI == QRY->IMEI .and. left(SZ9->Z9_NUMOS,6) == left(QRY->OS,6)
					IF ((MV_PAR04==1 .AND. SZ9->Z9_MSEXP<>'1') .OR. (MV_PAR04==2))
						
						_cpartnr   := SZ9->Z9_PARTNR
						_cquantnr  := STRZERO(SZ9->Z9_QTY,2)
						_cSEQSZ9   := SZ9->Z9_SEQ
						_cdtreqst  := QRY->DATA
						_cdtoffreq := ""
						_ccodtec   := ""
						_cdomtall  := "40"
						_cisissect := SZ9->Z9_SECTION
						_ctextsect := Posicione("SX5",1,xFilial("SX5") + "ZV"+_cisissect, "X5_DESCRI")
						_cdifficul := ""
						_cisisrepa := SZ9->Z9_ACTION
						_ctextrepa := ALLTRIM(Posicione("SZ8",2,xFilial("SZ8") + QRY->LAB + LEFT(_cisisrepa,5), "Z8_DESSOLU" ))
						
						
						IF ZZ3->(dbseek(xFilial("ZZ3")+ SZ9->Z9_IMEI+SZ9->Z9_NUMOS+SZ9->Z9_SEQ))
							_cdtreqst := DTOS(ZZ3->ZZ3_DATA)
						ENDIF
						
						IF ZZ3->(dbseek(xFilial("ZZ3")+ SZ9->Z9_IMEI+SZ9->Z9_NUMOS))
							DO WHILE ZZ3->(!eof()) .and. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .AND. ZZ3->ZZ3_IMEI == SZ9->Z9_IMEI .AND. LEFT(ZZ3->ZZ3_NUMOS,6) == LEFT(SZ9->Z9_NUMOS,6)
								IF ((MV_PAR04==1 .AND. ZZ3->ZZ3_TRANSC<>'FCH') .OR. (MV_PAR04==2))
									IF ZZ3->ZZ3_STATUS='1' .AND.ZZ3->ZZ3_ESTORN<>'S' .AND. ZZ3->ZZ3_ENCOS='S'
										_cdtoffreq := DTOS(ZZ3->ZZ3_DATA)
										_ccodtec   := ZZ3->ZZ3_CODTEC
										_cdifficul := ZZ3->ZZ3_DIFICU
										
										IF empty(_cisisrepa)
											_cisisrepa := ZZ3->ZZ3_ACAO
											_ctextrepa := ALLTRIM(Posicione("SZ8",2,xFilial("SZ8") + QRY->LAB + LEFT(_cisisrepa,5), "Z8_DESSOLU" ))
										ENDIF
										AADD(_aenczz3,{ZZ3->(RECNO())})
									ENDIF
								ENDIF
								ZZ3->(DBSKIP())
							ENDDO
						ENDIF
						
						
						IF SB1->(dbseek(xFilial("SB1")+ _cpartnr))
							_cdescpartn:=ALLTRIM(SB1->B1_DESC)
						ELSE                                                           
							_cdescpartn:=""
						ENDIF
						
						
						AADD(_apartnum,{_cpartnr,_cquantnr,_cdtreqst,"",_cdescpartn,SZ9->Z9_SEQ,_cdtoffreq,_ccodtec,_cdomtall,_cisissect,_ctextsect,_cdifficul,_cisisrepa,_ctextrepa,SZ9->(RECNO())})
						
					ENDIF
					
					SZ9->(dbskip())
					
					
				Enddo
			ENDIF
		ENDIF
		
		
		If  len(_apartnum) > 0
			For x:=1 to  len(_apartnum)
				IF MV_PAR03 == 4			
			        //Grava solicitação de peça para os encerramentos
		             aadd(_apartsz9,{QRY->TIPO,QRY->CODEASC,IIF(EMPTY(QRY->MODEL),QRY->CODPRO,QRY->MODEL),QRY->SERIALNUMBER,QRY->WARRANTYNUMBER,QRY->BUYDATE,QRY->SERVICEORDER,QRY->STARTDATE,_apartnum[X,7],;
		                             QRY->DELIVERYDATE,QRY->STATUS,QRY->STOCKCOMERCIO,_apartnum[X,8],_apartnum[X,9],QRY->CUSTOMERNAME,QRY->CUSTUMERID,QRY->PHONE,QRY->EMAIL,;
		                             QRY->ADREESS,QRY->SYMPTONISIS,QRY->SYMPTONTEXT,_apartnum[X,10],_apartnum[X,11],QRY->CAUSEISIS,QRY->CAUSETEXT,_apartnum[X,13],_apartnum[X,14],;
					                 _apartnum[X,4],_apartnum[X,3],QRY->POSITIONREQUEST,_apartnum[X,1],_apartnum[X,2],_apartnum[X,5],QRY->CLAVEG,_apartnum[X,12],QRY->ADMINCOST,QRY->COUNTRYSALES,;
					                 QRY->EQUIPAMENT,QRY->DOCUMENT,QRY->DEALER,QRY->ADRESSS,QRY->NUMBER,QRY->SHIPTO,QRY->BRANCH,QRY->FIRSTCONTACT,QRY->SURNAME,QRY->FILLER,.t.,_apartnum[X,15]})
			         
		             aadd(_apartenc,{'1',QRY->CODEASC,IIF(EMPTY(QRY->MODEL),QRY->CODPRO,QRY->MODEL),QRY->SERIALNUMBER,QRY->WARRANTYNUMBER,QRY->BUYDATE,QRY->SERVICEORDER,QRY->STARTDATE,"",;
		                             QRY->DELIVERYDATE,'2',QRY->STOCKCOMERCIO,"","",QRY->CUSTOMERNAME,QRY->CUSTUMERID,QRY->PHONE,QRY->EMAIL,;
		                             QRY->ADREESS,QRY->SYMPTONISIS,QRY->SYMPTONTEXT,"","","","","","",_apartnum[X,4],_apartnum[X,3],QRY->POSITIONREQUEST,;
		                             _apartnum[X,1],_apartnum[X,2],_apartnum[X,5],QRY->CLAVEG,"",QRY->ADMINCOST,QRY->COUNTRYSALES,;
					                 QRY->EQUIPAMENT,QRY->DOCUMENT,QRY->DEALER,QRY->ADRESSS,QRY->NUMBER,QRY->SHIPTO,QRY->BRANCH,QRY->FIRSTCONTACT,QRY->SURNAME,QRY->FILLER,.t.,_apartnum[X,15]})
				ELSE
	                cLin:= QRY->TIPO+cTAB+QRY->CODEASC+cTAB+IIF(EMPTY(QRY->MODEL),QRY->CODPRO,QRY->MODEL)+cTAB+QRY->SERIALNUMBER+cTAB+QRY->WARRANTYNUMBER+cTAB+QRY->BUYDATE+cTAB
					cLin+= QRY->SERVICEORDER+cTAB+QRY->STARTDATE+cTAB+_apartnum[X,7]+cTAB+QRY->DELIVERYDATE+cTAB+QRY->STATUS+cTAB
					cLin+= QRY->STOCKCOMERCIO+cTAB+_apartnum[X,8]+cTAB+_apartnum[X,9]+cTAB+QRY->CUSTOMERNAME+cTAB+QRY->CUSTUMERID+cTAB
					cLin+= QRY->PHONE+cTAB+QRY->EMAIL+cTAB+QRY->ADREESS+cTAB+QRY->SYMPTONISIS+cTAB+QRY->SYMPTONTEXT+cTAB+_apartnum[X,10]+cTAB
					cLin+= _apartnum[X,11]+cTAB+QRY->CAUSEISIS+cTAB+QRY->CAUSETEXT+cTAB+_apartnum[X,13]+cTAB+_apartnum[X,14]+cTAB
					cLin+= _apartnum[X,4]+cTAB+_apartnum[X,3]+cTAB+QRY->POSITIONREQUEST+cTAB+_apartnum[X,1]+cTAB+_apartnum[X,2]+cTAB+_apartnum[X,5]+cTAB
					cLin+= QRY->CLAVEG+cTAB+_apartnum[X,12]+cTAB+QRY->ADMINCOST+cTAB+QRY->COUNTRYSALES+cTAB+QRY->EQUIPAMENT+cTAB
					cLin+= QRY->DOCUMENT+cTAB+QRY->DEALER+cTAB+QRY->ADRESSS+cTAB+QRY->NUMBER+cTAB+QRY->SHIPTO+cTAB+QRY->BRANCH+cTAB
					cLin+= QRY->FIRSTCONTACT+cTAB+QRY->SURNAME+cTAB+QRY->FILLER+cEOL
					_larqtxt:=.t.
			    
			    ENDIF
			
			Next        
		Else
		    IF MV_PAR03 == 4			
                  aadd(_apartsz9,{QRY->TIPO,QRY->CODEASC,IIF(EMPTY(QRY->MODEL),QRY->CODPRO,QRY->MODEL),QRY->SERIALNUMBER,QRY->WARRANTYNUMBER,QRY->BUYDATE,QRY->SERVICEORDER,QRY->STARTDATE,QRY->ENDOFREPAIR,;
                             QRY->DELIVERYDATE,QRY->STATUS,QRY->STOCKCOMERCIO,QRY->TECNICANID,QRY->DOMICILIOTALLER,QRY->CUSTOMERNAME,QRY->CUSTUMERID,QRY->PHONE,QRY->EMAIL,;
                             QRY->ADREESS,QRY->SYMPTONISIS,QRY->SYMPTONTEXT,QRY->SECTIONISIS,QRY->SECTIONTEXT,QRY->CAUSEISIS,QRY->CAUSETEXT,QRY->REPAIRISIS,QRY->REPAIRTEXT,;
			                 QRY->REQUESTNUMBER,QRY->DATEREQUEST,QRY->POSITIONREQUEST,QRY->PARTNUMBER,QRY->QTYREQUEST,QRY->PARTDESCRIPTION,QRY->CLAVEG,QRY->DIFFICULT,QRY->ADMINCOST,QRY->COUNTRYSALES,;
			                 QRY->EQUIPAMENT,QRY->DOCUMENT,QRY->DEALER,QRY->ADRESSS,QRY->NUMBER,QRY->SHIPTO,QRY->BRANCH,QRY->FIRSTCONTACT,QRY->SURNAME,QRY->FILLER,.F.,0})
		    ELSE
				cLin:= QRY->TIPO+cTAB+QRY->CODEASC+cTAB+IIF(EMPTY(QRY->MODEL),QRY->CODPRO,QRY->MODEL)+cTAB+QRY->SERIALNUMBER+cTAB+QRY->WARRANTYNUMBER+cTAB+QRY->BUYDATE+cTAB
				cLin+= QRY->SERVICEORDER+cTAB+QRY->STARTDATE+cTAB+QRY->ENDOFREPAIR+cTAB+QRY->DELIVERYDATE+cTAB+QRY->STATUS+cTAB
				cLin+= QRY->STOCKCOMERCIO+cTAB+QRY->TECNICANID+cTAB+QRY->DOMICILIOTALLER+cTAB+QRY->CUSTOMERNAME+cTAB+QRY->CUSTUMERID+cTAB
				cLin+= QRY->PHONE+cTAB+QRY->EMAIL+cTAB+QRY->ADREESS+cTAB+QRY->SYMPTONISIS+cTAB+QRY->SYMPTONTEXT+cTAB+QRY->SECTIONISIS+cTAB
				cLin+= QRY->SECTIONTEXT+cTAB+QRY->CAUSEISIS+cTAB+QRY->CAUSETEXT+cTAB+QRY->REPAIRISIS+cTAB+QRY->REPAIRTEXT+cTAB+QRY->REQUESTNUMBER+cTAB
				cLin+= QRY->DATEREQUEST+cTAB+QRY->POSITIONREQUEST+cTAB+QRY->PARTNUMBER+cTAB+QRY->QTYREQUEST+cTAB+QRY->PARTDESCRIPTION+cTAB
				cLin+= QRY->CLAVEG+cTAB+QRY->DIFFICULT+cTAB+QRY->ADMINCOST+cTAB+QRY->COUNTRYSALES+cTAB+QRY->EQUIPAMENT+cTAB
				cLin+= QRY->DOCUMENT+cTAB+QRY->DEALER+cTAB+QRY->ADRESSS+cTAB+QRY->NUMBER+cTAB+QRY->SHIPTO+cTAB+QRY->BRANCH+cTAB
				cLin+= QRY->FIRSTCONTACT+cTAB+QRY->SURNAME+cTAB+QRY->FILLER+cEOL
				_larqtxt:=.t.
			ENDIF
		Endif
		
		IF MV_PAR03 == 4			
		   aadd(_aqryzz3,{QRY->RECZZ3})		
		ELSE
		    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		    	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			     	Return
			    Endif
		    Endif
		
		    IF (MV_PAR03==2 .OR. MV_PAR03==3)
			     IF len(_apartnum) > 0
				    For x:=1 to  len(_apartnum)
					   ZZ7->(dbGoTo(_apartnum[X,15]))
				       RecLock("ZZ7",.F.)
				           ZZ7->ZZ7_MSEXP := '1'
				       MsUnlock()
				    Next
			     ENDIF
		    ENDIF
		    /*
			IF MV_PAR03==4
		     	IF  len(_apartnum) > 0
			     	For x:=1 to  len(_apartnum)
				    	SZ9->(dbGoTo(_apartnum[X,15]))
			
			
			
				        RecLock("SZ9",.F.)
				          SZ9->Z9_MSEXP := '1'
				        MsUnlock()
				    Next
			    ENDIF
			
			    IF  len(_aenczz3) > 0
				    For x:=1 to  len(_aenczz3)
					    ZZ3->(dbGoTo(_aenczz3[x,1]))
					    RecLock("ZZ3",.F.)
					        ZZ3->ZZ3_TRANSC := 'FCH'
					    MsUnlock()
				    Next
			    ENDIF     
			
			
			
			
			
			    ZZ3->(dbGoTo(QRY->RECZZ3))
		        RecLock("ZZ3",.F.)
     		      ZZ3->ZZ3_TRANSC := 'FCH'
		        MsUnlock()
		    Else
		    */
			    ZZ3->(dbGoTo(QRY->RECZZ3))
		        RecLock("ZZ3",.F.)
     		      ZZ3->ZZ3_TRANSC := 'ABT'
		        MsUnlock()
		    /*
		    Endif
		    */
		
		
		ENDIF
		
		QRY->(dbSkip())
	Enddo
	
	IF MV_PAR03==4 .AND. (LEN(_apartenc) > 0  .or. LEN(_apartsz9) > 0 )
	
	     If LEN(_apartenc) > 0
	    
	        For x:=1 to len(_apartenc)         
	        
	        	cLin:= _apartenc[x,1]+cTAB+_apartenc[x,2]+cTAB+_apartenc[x,3]+cTAB+_apartenc[x,4]+cTAB+_apartenc[x,5]+cTAB+_apartenc[x,6]+cTAB
				cLin+= _apartenc[x,7]+cTAB+_apartenc[x,8]+cTAB+_apartenc[x,9]+cTAB+_apartenc[x,10]+cTAB+_apartenc[x,11]+cTAB
				cLin+= _apartenc[x,12]+cTAB+_apartenc[x,13]+cTAB+_apartenc[x,14]+cTAB+_apartenc[x,15]+cTAB+_apartenc[x,16]+cTAB
				cLin+= _apartenc[x,17]+cTAB+_apartenc[x,18]+cTAB+_apartenc[x,19]+cTAB+_apartenc[x,20]+cTAB+_apartenc[x,21]+cTAB+_apartenc[x,22]+cTAB
				cLin+= _apartenc[x,23]+cTAB+_apartenc[x,24]+cTAB+_apartenc[x,25]+cTAB+_apartenc[x,26]+cTAB+_apartenc[x,27]+cTAB+_apartenc[x,28]+cTAB
				cLin+= _apartenc[x,29]+cTAB+_apartenc[x,30]+cTAB+_apartenc[x,31]+cTAB+_apartenc[x,32]+cTAB+_apartenc[x,33]+cTAB
				cLin+= _apartenc[x,34]+cTAB+_apartenc[x,35]+cTAB+_apartenc[x,36]+cTAB+_apartenc[x,37]+cTAB+_apartenc[x,38]+cTAB
				cLin+= _apartenc[x,39]+cTAB+_apartenc[x,40]+cTAB+_apartenc[x,41]+cTAB+_apartenc[x,42]+cTAB+_apartenc[x,43]+cTAB+_apartenc[x,44]+cTAB
				cLin+= _apartenc[x,45]+cTAB+_apartenc[x,46]+cTAB+_apartenc[x,47]+cEOL
	
	    
			    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				    	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					     	Return
					    Endif
				Endif
				
				_larqtxt:=.t.
		    Next
		
		 Endif
		 
	     If LEN(_apartsz9) > 0		 
		 
		    For x:=1 to len(_apartsz9)
    	     
        	 	cLin:= _apartsz9[x,1]+cTAB+_apartsz9[x,2]+cTAB+_apartsz9[x,3]+cTAB+_apartsz9[x,4]+cTAB+_apartsz9[x,5]+cTAB+_apartsz9[x,6]+cTAB
				cLin+= _apartsz9[x,7]+cTAB+_apartsz9[x,8]+cTAB+_apartsz9[x,9]+cTAB+_apartsz9[x,10]+cTAB+_apartsz9[x,11]+cTAB
				cLin+= _apartsz9[x,12]+cTAB+_apartsz9[x,13]+cTAB+_apartsz9[x,14]+cTAB+_apartsz9[x,15]+cTAB+_apartsz9[x,16]+cTAB
				cLin+= _apartsz9[x,17]+cTAB+_apartsz9[x,18]+cTAB+_apartsz9[x,19]+cTAB+_apartsz9[x,20]+cTAB+_apartsz9[x,21]+cTAB+_apartsz9[x,22]+cTAB
				cLin+= _apartsz9[x,23]+cTAB+_apartsz9[x,24]+cTAB+_apartsz9[x,25]+cTAB+_apartsz9[x,26]+cTAB+_apartsz9[x,27]+cTAB+_apartsz9[x,28]+cTAB
				cLin+= _apartsz9[x,29]+cTAB+_apartsz9[x,30]+cTAB+_apartsz9[x,31]+cTAB+_apartsz9[x,32]+cTAB+_apartsz9[x,33]+cTAB
				cLin+= _apartsz9[x,34]+cTAB+_apartsz9[x,35]+cTAB+_apartsz9[x,36]+cTAB+_apartsz9[x,37]+cTAB+_apartsz9[x,38]+cTAB
				cLin+= _apartsz9[x,39]+cTAB+_apartsz9[x,40]+cTAB+_apartsz9[x,41]+cTAB+_apartsz9[x,42]+cTAB+_apartsz9[x,43]+cTAB+_apartsz9[x,44]+cTAB
				cLin+= _apartsz9[x,45]+cTAB+_apartsz9[x,46]+cTAB+_apartsz9[x,47]+cEOL
    
    	     
    	       If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				    	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					     	Return
					    Endif
				Endif
				
				_larqtxt:=.t.
    	        
   	        	If _apartsz9[x,48]
         	        SZ9->(dbGoTo(_apartsz9[x,49]))
	     		    RecLock("SZ9",.F.)
		     	       SZ9->Z9_MSEXP := '1'
			        MsUnlock()
			    Endif    
		    Next
         
         Endif
        
         IF  len(_aenczz3) > 0
		    For x:=1 to  len(_aenczz3)
			    ZZ3->(dbGoTo(_aenczz3[x,1]))
			    RecLock("ZZ3",.F.)
			        ZZ3->ZZ3_TRANSC := 'FCH'
			    MsUnlock()
		    Next
		 ENDIF                        
		
		 IF  len(_aqryzz3) > 0
		    For x:=1 to  len(_aqryzz3)
			    ZZ3->(dbGoTo(_aqryzz3[x,1]))
			    RecLock("ZZ3",.F.)
			        ZZ3->ZZ3_TRANSC := 'FCH'
			    MsUnlock()
		    Next
		 ENDIF                        
	ENDIF
	
Else
   MsgAlert("Não foi encontrado dados. Verifique os parametros.","Atencao!")
Endif
QRY->(dbCloseArea())

fClose(nHdl)
Close(oGeraTxt)

If !_larqtxt   
   MsgAlert("Não foi gerado dados para o arquivo : "+ALLTRIM(MV_PAR05)+". Verifique os parametros.","Atencao!")
endif   

Return


//Cria perguntas no SX1
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Dt. Atendimento de  :"	,"Dt. Atendimento de  :"	,"Dt. Atendimento de  :"  ,"mv_ch1","D",08,0,0,"G","",""	,"",,"mv_par01",""	,"","","",""	,"","",""	,"","","","","","","","")
PutSX1(cPerg,"02","Dt. Atendimento Ate :"	,"Dt. Atendimento Ate :"    ,"Dt. Atendimento Ate :"  ,"mv_ch2","D",08,0,0,"G","",""	,"",,"mv_par02",""	,"","","",""	,"","",""	,"","","","","","","","")
PutSX1(cPerg,"03","Exp. arquivo tipo ? "    ,"Exp. arquivo tipo ? "		,"Exp. arquivo tipo ? "	  ,"mv_ch3","N",01,0,0,"C","",""	,"",,"mv_par03","Abertura OS"	,"Abertura OS","Abertura OS","","Compra Peças GAR"	,"Compra Peças GAR","Compra Peças GAR","Compra Peças FOG"	,"Compra Peças FOG","Compra Peças FOG","Fechamento OS","Fechamento OS","Fechamento OS","","","")
PutSX1(cPerg,"04","Exportar arquivo ?  "    ,"Exportar arquivo ?  "   	,"Exportar arquivo ?"	  ,"mv_ch4","N",01,0,0,"C","",""	,"",,"mv_par04","Novo"	,"Novo","Novo","","Reprocessar"	,"Reprocessar","Reprocessar",""	,"","","","","","","","")
PutSX1(cPerg,"05","Nome Arquivo"		    ,"Nome Arquivo"			    ,"Nome Arquivo"			  ,"mv_ch5","C",40,0,0,"G","",""	,"",,"mv_par05",""	 ,"","","",""	,"","",""	,"","","","","","","","")


Return Nil
