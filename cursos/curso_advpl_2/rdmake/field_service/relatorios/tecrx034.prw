#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX034 บAutor  ณM.Munhoz - ERPPLUS  บ Data ณ  09/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para geracao de planilha de RE-REPAIR EXTERNO.    บฑฑ
ฑฑบ          ณ Solicitada pelo Luis - SONY                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TECRX034()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Exportacao dos dados de RE-REPAIR Externo"
Local cDesc1  := "Exportacao dos dados de RE-REPAIR Externo, informando ultima e penultima entrada "
Local cDesc2  := "de cada IMEI, caso ele tenha gerado bounce superior a quantidade de dias informada. "
Local cDesc3  := ""
Local cDesc4  := "Especifico BGH"

Private cPerg := "TECX34"                               
private _csrvapl :=ALLTRIM(GetMV("MV_SERVAPL"))

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| TECRX34A(@lEnd)}, "Aguarde...","Gerando dados de RE-REPAIR EXTERNO ...", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX034 บAutor  ณMicrosiga           บ Data ณ  09/02/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para geracao de planilha Excel com os dados de    บฑฑ
ฑฑบ          ณ RE-REPAIR EXTERNO                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TECRX34A(lEnd)

// Cria arquivo temporario - alias TRB
CriaDBF()

// Consulta 2a entrada (ZZ4 x SZA x SZ9 x ZZ4-BOUNCE) - alias QRY
CriaQRY()

// Processa consulta / Pesquisa dados de part nr da 1a entrada / Alimenta arquivo temporario
ProcQRY()

// Abre Excel
AbreXls()

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIADBF  บAutor  ณMicrosiga           บ Data ณ  09/02/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaDBF()

local _aCampos  := {} // Matriz de campos do arquivo temporario
local _cArqTemp := "" // Nome do arquivo temporario 

// Verifica se o alias TRB esta em uso. Se estiver fecha o alias.
if select("TRB") > 0
	TRB->(dbCloseArea())
endif

// Cria arquivo temporario
_aCampos := {	{"GRUPO"    ,"C",04,0},;
            	{"MODELO"   ,"C",15,0},;
				{"IMEI"	    ,"C",TamSX3("ZZ4_IMEI")[1],0},;
				{"OPERAD"	,"C",30,0},;
				{"COR"	    ,"C",02,0},;
				{"NUMOS1"	,"C",06,0},;
				{"ENTRDOC1"	,"D",08,0},;
				{"SAIDDOC1"	,"D",08,0},;
				{"SYMDESC1"	,"C",50,0},;
				{"SYMCOD1"	,"C",04,0},;
				{"FAUCOD1"	,"C",04,0},;
				{"ACTCOD1"	,"C",04,0},;
				{"QTDPCS1"	,"N",09,0},;
				{"PARTNR1"	,"C",15,0},;
				{"REUSED1"	,"C",01,0},;
				{"NUMOS2"	,"C",06,0},;
				{"ENTRDOC2"	,"D",08,0},;
				{"SAIDDOC2"	,"D",08,0},;
				{"SYMDESC2"	,"C",50,0},;
				{"SYMCOD2"	,"C",04,0},;
				{"FAUCOD2"	,"C",04,0},;
				{"ACTCOD2"	,"C",04,0},;
				{"QTDPCS2"	,"N",09,0},;
				{"PARTNR2"	,"C",15,0},;
				{"REUSED2"	,"C",01,0} } 
				
_cArqTemp := CriaTrab(_aCampos)
dbUseArea(.T.,,_cArqTemp,"TRB",.F.,.F.)        
//cInd1TRB := CriaTrab(Nil, .F.)
//IndRegua("TRB",cInd1TRB,"IMEI",,,"Indexando Arquivo de Trabalho") 
//dbClearIndex()
//dbSetIndex(cInd1TRB + OrdBagExt())

//dbselectarea("TRB")
//TRB->(dbSetOrder(1))  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIATRB  บAutor  ณMicrosiga           บ Data ณ  09/02/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaQRY()

local _cQuery := ""
local _Enter  := chr(13) + chr(10)

_cQuery += _Enter + " SELECT B1_GRUPO, ZZ4.ZZ4_CODPRO, ZZ4.ZZ4_IMEI, SZA.ZA_NOMEOPE, ZZ4.ZZ4_COR, ZZ4.ZZ4_BOUNCE, " 
_cQuery += _Enter + "        BOU.ZZ4_OS 'NUMOS1', BOU.ZZ4_DOCDTE 'ENTRDOC1', BOU.ZZ4_DOCDTS 'SAIDDOC1', " 
_cQuery += _Enter + "        ZZ4.ZZ4_OS 'NUMOS2', ZZ4.ZZ4_DOCDTE 'ENTRDOC2', ZZ4.ZZ4_DOCDTS 'SAIDDOC2', " 
_cQuery += _Enter + "        Z9_SYMPTO, Z9_FAULID, Z9_ACTION, Z9_QTY, Z9_PARTNR, Z9_USED " 
_cQuery += _Enter + " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK) " 
_cQuery += _Enter + " JOIN   "+RetSqlName("SB1")+" AS SB1 (NOLOCK) " 
_cQuery += _Enter + " ON     SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD   = ZZ4.ZZ4_CODPRO " 
_cQuery += _Enter + " JOIN   "+RetSqlName("ZZ4")+" AS BOU (NOLOCK) " 
_cQuery += _Enter + " ON     BOU.D_E_L_E_T_ = '' AND BOU.ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND BOU.ZZ4_IMEI = ZZ4.ZZ4_IMEI AND " 
_cQuery += _Enter + "        BOU.ZZ4_CODCLI = ZZ4.ZZ4_CODCLI AND BOU.ZZ4_LOJA = ZZ4.ZZ4_LOJA AND "
_cQuery += _Enter + "        BOU.ZZ4_CODPRO = ZZ4.ZZ4_CODPRO AND BOU.ZZ4_NUMVEZ = ZZ4.ZZ4_NUMVEZ - 1 " 
_cQuery += _Enter + " LEFT OUTER JOIN "+RetSqlName("SZA")+" AS SZA (NOLOCK) " 
_cQuery += _Enter + " ON     SZA.D_E_L_E_T_ = '' AND SZA.ZA_FILIAL = '"+xFilial("SZA")+"' AND SZA.ZA_IMEI = ZZ4.ZZ4_IMEI AND " 
_cQuery += _Enter + "        SZA.ZA_NFISCAL = ZZ4.ZZ4_NFENR AND SZA.ZA_SERIE = ZZ4.ZZ4_NFESER AND  " 
_cQuery += _Enter + "        SZA.ZA_CLIENTE = ZZ4.ZZ4_CODCLI AND SZA.ZA_LOJA = ZZ4.ZZ4_LOJA " 
_cQuery += _Enter + " LEFT OUTER JOIN "+RetSqlName("SZ9")+" AS SZ9 (NOLOCK) " 
_cQuery += _Enter + " ON     SZ9.D_E_L_E_T_ = '' AND SZ9.Z9_FILIAL = '"+xFilial("SZ9")+"' AND SZ9.Z9_IMEI = ZZ4.ZZ4_IMEI AND  " 
_cQuery += _Enter + "        LEFT(SZ9.Z9_NUMOS,6) = LEFT(ZZ4.ZZ4_OS,6) " 
_cQuery += _Enter + " WHERE  ZZ4.D_E_L_E_T_ = ''  AND ZZ4.ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND "
_cQuery += _Enter + "        ZZ4.ZZ4_NUMVEZ > 1   AND "
_cQuery += _Enter + "        ZZ4.ZZ4_BOUNCE <= "+alltrim(str(mv_par12))+" AND " 
_cQuery += _Enter + "        ZZ4.ZZ4_DOCDTE BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"' AND " 
_cQuery += _Enter + "        ZZ4.ZZ4_DOCDTS BETWEEN '"+dtos(mv_par04)+"' AND '"+dtos(mv_par05)+"' AND " 
_cQuery += _Enter + "        ZZ4.ZZ4_CODPRO BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' AND " 
_cQuery += _Enter + "        ZZ4.ZZ4_IMEI   BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' AND "
if mv_par01 == 1  // Sony
	_cQuery += _Enter + "    '"+alltrim(getmv("MV_XSEDLOC"))+'/'+alltrim(getmv("MV_XSEMLOC"))+"' LIKE '%'+ZZ4.ZZ4_LOCAL+'%' "
else              // Nextel
	_cQuery += _Enter + "    '"+alltrim(getmv("MV_XNEXLOC"))+"' LIKE '%'+ZZ4.ZZ4_LOCAL+'%' "
endif
_cQuery += _Enter + " ORDER BY ZZ4.ZZ4_FILIAL, ZZ4.ZZ4_IMEI, ZZ4.ZZ4_OS " 

if select("QRY") > 0
	QRY->(dbCloseArea())
endif
//memowrite("TECRX034.SQL",_cQuery )
_cQuery := strtran(_cQuery , _Enter, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

TcSetField("QRY","ENTRDOC1" ,"D")
TcSetField("QRY","SAIDDOC1"  ,"D")
TcSetField("QRY","ENTRDOC2" ,"D")
TcSetField("QRY","SAIDDOC2"  ,"D")

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PROCQRY  บAutor  ณMicrosiga           บ Data ณ  09/02/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcQRY()

local _aAreaSZ9 := SZ9->(getarea())
local _cChave   := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 -> Laborat๓rio                                             ณ
//ณ mv_par02 -> Entrada Doca Inicial                                    ณ
//ณ mv_par03 -> Entrada Doca Final                                      ณ
//ณ mv_par04 -> Saํda Doca Inicial                                      ณ
//ณ mv_par05 -> Saํda Doca Final                                        ณ
//ณ mv_par06 -> Modelo Inicial                                          ณ
//ณ mv_par07 -> Modelo Final                                            ณ
//ณ mv_par08 -> Grupo Inicial                                           ณ
//ณ mv_par09 -> Grupo Final                                             ณ
//ณ mv_par10 -> Operadora Inicial                                       ณ
//ณ mv_par11 -> Operadora Final                                         ณ
//ณ mv_par12 -> Dias Bounce                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SZ9->(dbSetOrder(2)) // Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM
QRY->(dbGoTop())
//procregua(100)
while QRY->(!eof())

	if upper(QRY->ZA_NOMEOPE) < upper(mv_par10) .or. upper(QRY->ZA_NOMEOPE) > upper(mv_par11)
		QRY->(dbSkip())
		loop
	endif
		
	_aSZ9    := {}
	_nSZ9    := 0

	// Incrementa a regua de processamento
//	incregua()

	// Pesquisa os part numbers apontados na entrada anterior ao BOUNCE
	_cChave  := QRY->ZZ4_IMEI + QRY->NUMOS2
	if SZ9->(dbSeek(xFilial("SZ9") + QRY->ZZ4_IMEI + left(QRY->NUMOS1,6) ))
		while SZ9->(!eof()) .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and. SZ9->Z9_IMEI == QRY->ZZ4_IMEI .and. ;
		left(SZ9->Z9_NUMOS,6) == left(QRY->NUMOS1,6)

			aAdd(_aSZ9, {SZ9->Z9_SYMPTO, SZ9->Z9_FAULID, SZ9->Z9_ACTION, SZ9->Z9_QTY, SZ9->Z9_PARTNR, SZ9->Z9_USED})
			SZ9->(dbSkip())

		enddo
	endif

	// Processa o IMEI x OS da entrada de BOUNCE
	while QRY->(!eof()) .and. _cChave == QRY->ZZ4_IMEI + QRY->NUMOS2

		_nSZ9++
		reclock("TRB",.t.)
		TRB->GRUPO      := QRY->B1_GRUPO
		TRB->MODELO     := QRY->ZZ4_CODPRO
		TRB->IMEI       := QRY->ZZ4_IMEI
		TRB->OPERAD     := QRY->ZA_NOMEOPE
		TRB->COR        := QRY->ZZ4_COR
		TRB->NUMOS1     := QRY->NUMOS1
		TRB->ENTRDOC1   := QRY->ENTRDOC1
		TRB->SAIDDOC1   := QRY->SAIDDOC1
		TRB->SYMDESC2   := ""
		TRB->SYMCOD2    := QRY->Z9_SYMPTO
		TRB->FAUCOD2    := QRY->Z9_FAULID
		TRB->ACTCOD2    := QRY->Z9_ACTION
		TRB->QTDPCS2    := QRY->Z9_QTY
		TRB->PARTNR2    := QRY->Z9_PARTNR
		TRB->REUSED2    := QRY->Z9_USED
		TRB->NUMOS2     := QRY->NUMOS2
		TRB->ENTRDOC2   := QRY->ENTRDOC2
		TRB->SAIDDOC2   := QRY->SAIDDOC2
		if _nSZ9 <= len(_aSZ9)
			TRB->SYMDESC1   := ""
			TRB->SYMCOD1    := _aSZ9[_nSZ9,1]
			TRB->FAUCOD1    := _aSZ9[_nSZ9,2]
			TRB->ACTCOD1    := _aSZ9[_nSZ9,3]
			TRB->QTDPCS1    := _aSZ9[_nSZ9,4]
			TRB->PARTNR1    := _aSZ9[_nSZ9,5]
			TRB->REUSED1    := _aSZ9[_nSZ9,6]
		endif
		msunlock()

		_cGrupo      := QRY->B1_GRUPO
		_cModelo     := QRY->ZZ4_CODPRO
		_cIMEI       := QRY->ZZ4_IMEI
		_cOperad     := QRY->ZA_NOMEOPE
		_cCor        := QRY->ZZ4_COR
		_cNumOS1     := QRY->NUMOS1
		_dEntrDoc1   := QRY->ENTRDOC1
		_dSaidDoc1   := QRY->SAIDDOC1
		_cSymDesc2   := ""
		_cSymCod2    := QRY->Z9_SYMPTO
		_cFauCod2    := QRY->Z9_FAULID
		_cActCod2    := QRY->Z9_ACTION
		_cQtdPcs2    := QRY->Z9_QTY
		_cPartNr2    := QRY->Z9_PARTNR
		_cReused2    := QRY->Z9_USED
		_cNumOS2     := QRY->NUMOS2
		_dEntrDoc2   := QRY->ENTRDOC2
		_dSaidDoc2   := QRY->SAIDDOC2

		QRY->(dbskip())

	enddo
	// Continua incrementando o TRB caso a quantidade de part numbers da entrada anterior ao BOUNCE seja maior que a da segunda (bounce)
	if len(_aSZ9) > _nSZ9
		// Retorna para o ultimo registro na QRY do IMEI processado 
//		QRY->(dbskip(-1))
		// Passa pelo restante da matriz de part numbers da entrada anterior ao BOUNCE
		for _nSZ9 := _nSZ9 + 1 to len(_aSZ9)
			reclock("TRB",.t.)

			TRB->GRUPO      := _cGrupo
			TRB->MODELO     := _cModelo
			TRB->IMEI       := _cIMEI
			TRB->OPERAD     := _cOperad
			TRB->COR        := _cCor
			TRB->NUMOS1     := _cNumOS1
			TRB->ENTRDOC1   := _dEntrDoc1
			TRB->SAIDDOC1   := _dSaidDoc1
			TRB->SYMDESC2   := _cSymDesc2
			TRB->SYMCOD2    := _cSymCod2
			TRB->FAUCOD2    := _cFauCod2
			TRB->ACTCOD2    := _cActCod2
//			TRB->QTDPCS2    := _cQtdPcs2
//			TRB->PARTNR2    := _cPartNr2
//			TRB->REUSED2    := _cReused2
			TRB->NUMOS2     := _cNumOS2
			TRB->ENTRDOC2   := _dEntrDoc2
			TRB->SAIDDOC2   := _dSaidDoc2
			if _nSZ9 >= len(_aSZ9)
				TRB->SYMDESC2   := ""
				TRB->SYMCOD1    := _aSZ9[_nSZ9,1]
				TRB->FAUCOD1    := _aSZ9[_nSZ9,2]
				TRB->ACTCOD1    := _aSZ9[_nSZ9,3]
				TRB->QTDPCS1    := _aSZ9[_nSZ9,4]
				TRB->PARTNR1    := _aSZ9[_nSZ9,5]
				TRB->REUSED1    := _aSZ9[_nSZ9,6]
			endif
			msunlock()
		next _nSZ9
		// Posiciona o QRY no proximo registro para dar continuidade nos demais IMEIs
//		QRY->(dbskip())
	endif

enddo

restarea(_aAreaSZ9)
//QRY->(dbCloseArea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ABREXLS  บAutor  ณMicrosiga           บ Data ณ  09/02/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AbreXls()

//local _cArquivo  := "rerepair.xls"
local _cArquivo  := "rerepair.csv"
local _lOPen     := .f.
local _cRootPath := getPvProfString(getEnvServer(), "RootPath", "ERROR", GetAdv97() )
local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Local cArqdes  := lower(AllTrim(__RELDIR)+_cNomePlan)
Local cArqorig := cStartPath+_cArqTemp+".dtc"

dbSelectArea("TRB")
TRB->(dbgotop())

//Incluso Edson Rodrigues - 25/05/10
lgerou:=U_CONVARQ(cArqorig,cArqdes)

If lgerou                              
   If !ApOleClient( 'MsExcel' )
      MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
   Else
      ShellExecute( "Open" , "\\"+_csrvapl+cArqdes ,"", "" , 3 )           
   EndIf
	
Else
  msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
Endif


/*
While !_lOpen
	if file(__reldir + _cArquivo) .and. ferase(__reldir + _cArquivo) == -1
		if !ApMsgYesNo("O arquivo " + _cArquivo + " nใo pode ser gerado porque deve estar sendo utilizado. Deseja tentar novamente? " )
			_lOpen := .t.
			ApMsgInfo("O arquivo Excel nใo foi gerado. ")
		endif
	else
		dbselectarea("TRB")
		copy to &(__reldir + _cArquivo) VIA "DBFCDXADS"
		TRB->(dbCloseArea())
		ShellExecute( "Open" , "\\"+_csrvapl+__reldir + _cArquivo ,"", "" , 3 )
		_lOpen := .t.
	endif
EndDo
*/



return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณMicrosiga           บ Data ณ  09/02/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

PutSX1(cPerg,'01','Laborat๓rio'                   ,'Laborat๓rio'                   ,'Laborat๓rio'                   ,'mv_ch1','N',1 ,0,0,'C',''                    ,''      ,'','S','mv_par01','Sony'           ,'Sony'           ,'Sony'           ,'','Nextel'         ,'Nextel'         ,'Nextel'         ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'02','Entrada Doca Inicial'          ,'Entrada Doca Inicial'          ,'Entrada Doca Inicial'          ,'mv_ch2','D',8 ,0,0,'G',''                    ,''      ,'','S','mv_par02',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'03','Entrada Doca Final'            ,'Entrada Doca Final'            ,'Entrada Doca Final'            ,'mv_ch3','D',8 ,0,0,'G',''                    ,''      ,'','S','mv_par03',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'04','Saํda Doca Inicial'            ,'Saํda Doca Inicial'            ,'Saํda Doca Inicial'            ,'mv_ch4','D',8 ,0,0,'G',''                    ,''      ,'','S','mv_par04',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'05','Saํda Doca Final'              ,'Saํda Doca Final'              ,'Saํda Doca Final'              ,'mv_ch5','D',8 ,0,0,'G',''                    ,''      ,'','S','mv_par05',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'06','Modelo Inicial'                ,'Modelo Inicial'                ,'Modelo Inicial'                ,'mv_ch6','C',15,0,0,'G',''                    ,'SB1'   ,'','S','mv_par06',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'07','Modelo Final'                  ,'Modelo Final'                  ,'Modelo Final'                  ,'mv_ch7','C',15,0,0,'G',''                    ,'SB1'   ,'','S','mv_par07',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'08','Grupo Inicial'                 ,'Grupo Inicial'                 ,'Grupo Inicial'                 ,'mv_ch8','C',4 ,0,0,'G',''                    ,'SBM'   ,'','S','mv_par08',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'09','Grupo Final'                   ,'Grupo Final'                   ,'Grupo Final'                   ,'mv_ch9','C',4 ,0,0,'G',''                    ,'SBM'   ,'','S','mv_par09',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'10','Operadora Inicial'             ,'Operadora Inicial'             ,'Operadora Inicial'             ,'mv_cha','C',30,0,0,'G',''                    ,''      ,'','S','mv_par10',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'11','Operadora Final'               ,'Operadora Final'               ,'Operadora Final'               ,'mv_chb','C',30,0,0,'G',''                    ,''      ,'','S','mv_par11',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'12','Dias Bounce'                   ,'Dias Bounce'                   ,'Dias Bounce'                   ,'mv_chc','N',3 ,0,0,'G',''                    ,''      ,'','S','mv_par12',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')

return