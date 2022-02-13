#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "CHEQUE.CH"
#DEFINE LFRC CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ tecax015 บAutor  ณ Antonio L.F.Favero บ Data ณ  12/11/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Pedido de Vendas a partir da saida massiva          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Field Service - BGH                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function tecax015(_lrotaut, lRf)
Local oDlg
Local cVARTes		:= Space(3)
Local lValtra		:= .T.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Adapta็ใo para o coletor de dados                                      ณ
//ณ Delta Decisao - DF - 11/10/2011                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Default lRf			:= .F.
Private cAliasTop5	:= ""
Private cKit		:= Space(15)
Private cFornece	:= Space(8)
Private cQuery		:= ""
Private _cCodPro	:= Space(20)
private CTRL		:= chr(13) + chr(10)
private _aitpcSC6	:= {} // array com as pecas apontadas - Edson Rodrigues
private _nqtdppec	:= 0  //Conta quantos pedidos de pecas foram gerados - Edson Rodrigues 15/04/10
private _nqtpcped	:= 0  //Conta quantas pecas foram gerados por pedido - Edson Rodrigues 15/04/10
private _nqtditpc	:= 0  //Conta quantas pecas foram gerados no total - Edson Rodrigues 15/04/10
private  cpcnIt		:= "00"
Private nTamNfe		:= TAMSX3("D1_DOC")[1]
Private nTamNfs		:= TAMSX3("D2_DOC")[1]
Private cStartPath	:= GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97())
Private _lRetSld	:= .T.
//Incluso Retornar Clientes Nextel CD  Uiran Almeida 29.01.2015
Private cNextSp		:= GetMv("MV_NEXTSP")
Private cNextRj     := GetMv("MV_NEXTRJ")

u_GerA0003(ProcName())
// A variแvel lRf veio com valor nulo. Ajuste para validar novamente.
lRf		:= Iif(lRf == Nil .OR. Valtype(lRf) <> "L", IsTelNet(), lRf)
dbSelectArea("ZZ4") //Entrada Massiva
dbSelectArea("AA3") //Base Instalada
//dbSelectArea("AB1") //Chamado T้cnico
dbSelectArea("AB2") //Itens do Chamado T้cnico
dbSelectArea("AB6") //Cabe็alho de Ordem de Servi็o
dbSelectArea("AB7") //Itens da Ordem de Servi็o
dbSelectArea("SA1") //Cadastro de Clientes
dbSelectArea("SC5") //Cabecalho de Pedido de Venda
dbSelectArea("SC6") //Itens do Pedido de Venda
dbSelectArea("SF4") //Cadastro de TES
dbSelectArea("SD1") //Nota Fiscal de Entrada
dbSelectArea("SC9") //Pedidos Liberados
dbSelectArea("AA5") //Cadastro de Servicos
dbSelectArea("AB8") //Apontamentos da OS
dbSelectArea("AB9") //Atendimento da OS
dbSelectArea("ABC") //Despesas da OS
dbSelectArea("AA1") //Cadastro de T้cnicos
dbSelectArea("SZ9") //Apontamento de pe็as
dbSelectArea("ZZ3") //Apontamento de pe็as
dbSelectArea("SC2") //Ordem de Producao
dbSelectArea("SD3") //Movimenta็๕ess de Ordem de Producao
dbSelectArea("ZZJ") //Tabela de Operacoes Industrial
dbSelectArea("SG1") //Tabela de estruturas
AA3->(dbSetOrder(1)) //AA3_CLIENTE+AA3_LOJA+AA3_PRODUTO+AA3_SN
SA1->(dbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO
AA5->(dbSetOrder(1)) //AA5_FILIAL+AA5_CODSER
AB8->(dbSetOrder(1)) //AB8_FILIAL+AB8_NUMOS+AB8_ITEM
AB9->(dbOrderNickName("AB9SNOSCLI"))//AB9->(dbSetOrder(7)) //AB9_FILIAL+AB9_SN+AB9_NUMOS+AB9_CODCLI+AB9_LOJA
AA1->(dbSetOrder(1)) //AA1_FILIAL+AA1_CODTEC
SC9->(dbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
AB2->(dbOrderNickName("AB2NUMSER")) //AB2_FILIAL+AB2_NUMSER
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlterado por M.Munhoz em 16/08/2011 - Posicionar SD1 sem utilizar o D1_NUMSER. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//SD1->(dbOrderNickName("D1NUMSER")) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER
SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
AB7->(dbOrderNickName("AB7NUMSER")) //AB7_FILIAL+AB7_NUMOS+AB7_NUMSER
ABC->(dbOrderNickName("ABCOS"))     //ABC_FILIAL+ABC_NUMOS+ABC_SUBOS
SZ9->(dbSetOrder(2)) //Z9_FILIAL+Z9_IMEI+Z9_NUMOS+Z9_SEQ
ZZ3->(dbSetOrder(1)) //ZZ3_FILIAL+ZZ3_IMEI+ZZ3_NUMOS+ZZ3_SEQ
SC2->(dbSetOrder(1)) //C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQ+C2_ITEMGRD
SD3->(dbSetOrder(1)) //D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
ZZJ->(dbSetOrder(1)) //ZZJ_FILIAL+ZZJ_OPERA+ZZJ_LAB
SG1->(dbSetOrder(1)) //G1_FILIAL+G1_COD+G1_COMP+G1_TRT
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlterado o Where do select para filtrar por sequencia de ordem de indice,  no intuido da mesma ficar mais rแpida - Edson Rodrigues - 13/04/10ณ
//ณOrdena a tabela no indice mais proximo que sera executada a query - Edson Rodrigues 12/04/10.                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("ZZ4")
ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
cAliasTop5	:= GetNextAlias()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNICOLETTI - AJUSTES DE PERFORMANCE - 12/04/05                                       ณ
//ณIncluso campos fixo para melhora na performance da query - Edson Rodrigues 13/04/10.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT ZZ4_FILIAL,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFENR, ZZ4_NFESER,ZZ4_IMEI,ZZ4_OS,ZZ4_STATUS,ZZ4_PV,ZZ4_SMUSER,ZZ4_OPEBGH,"
cQuery += " ZZ4_CODPRO,ZZ4_VLRUNI,ZZ4_LOCAL,ZZ4_OPER,ZZ4_GVSOS,ZZ4_GVSARQ,ZZ4_FASATU, ZZ4_ITEMD1,ZZO_NUMCX "
cQuery += " FROM "+ RETSQLNAME("ZZ4")+" ZZ4 (nolock) "
cQuery += " LEFT JOIN " + RetSqlName("ZZO") + " ZZO (NOLOCK) "
cQuery += " ON (ZZO_IMEI=ZZ4_IMEI AND ZZO_CARCAC=ZZ4_CARCAC AND ZZO_NUMCX=ZZ4_ETQMAS AND ZZO_OSFILI=ZZ4_OS AND ZZO_STATUS IN ('P','E') AND ZZO.D_E_L_E_T_ ='') "
cQuery += " WHERE ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' AND "
cQuery += "      ZZ4_STATUS  = '7' AND "  // OS Encerrada
cQuery += "      ZZ4_PV      = ''  AND "
cQuery += "      ZZ4.D_E_L_E_T_  = ''  AND "
cQuery += "      SUBSTRING(ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' "
cQuery += "ORDER BY ZZ4_CODCLI, ZZ4_LOJA, ZZ4_NFENR, ZZ4_NFESER" // MUNHOZ 03/08/07
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cquery),cAliasTop5,.T.,.T.)
(cAliasTop5)->(dbGoTop())
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRotina de travamento do radio - GLPI 14467ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !((cAliasTop5)->(Eof()))
	If !U_VLDTRAV((cAliasTop5)->ZZ4_FILIAL, (cAliasTop5)->ZZ4_IMEI, (cAliasTop5)->ZZ4_OS, {Iif(lRf,"C","P"),"TECAX015","Tecax015"})
		lValtra := .F.
	EndIf
	(cAliasTop5)->(dbSkip())
EndDo
If !lValtra
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLimpa Filtro.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAliasTop5)
	dbCloseArea()
	Return()
EndIf
(cAliasTop5)->(dbGoTop())
If !_lrotaut		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adapta็ใo para o coletor de dados                                      ณ
	//ณ Delta Decisao - DF - 11/10/2011                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !lRf
		_cSepEnt	:= Posicione("ZZJ",1,xFilial("ZZJ") + (cAliasTop5)->ZZ4_OPEBGH, "ZZJ_SEPENT")
		If AllTrim(_cSepEnt)=="S"
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica se existe kit e qual o kit em referencia.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If ApMsgYesNo("Deseja gerar os Pedidos de Vendas para Kit?","Pedido de Venda")
			oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
			@ 0,0 TO 200,300 DIALOG oDlg TITLE "Kit"
			oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlg)
			@ 05,050 SAY oV1 var "Selecione um kit:" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
				@ 40,010 GET cKit Size 100,080 PICTURE "@!" valid ExistCPO("SB1",cKit)  F3 "SB1"
			@ 80,085 BMPBUTTON TYPE 1 ACTION oDlg:End()
			@ 80,120 BMPBUTTON TYPE 2 ACTION oDlg:End()
			Activate MSDialog oDlg Centered
			If !empty(cKit)
				_lRetSld := .T.
			     Processa({|| _lRetSld := VERIFSLD(cKit)}, "Processando valida็ใo do KIT...")
			     If !_lRetSld
				     	If !ApMsgYesNo("Existem componentes com problema de saldo. Deseja prosseguir mesmo assim?","Pedido de Venda")
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณLimpa Filtro.ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
						dbSelectArea(cAliasTop5)
						dbCloseArea()
						Return()
					Else
						If !UPPER(Alltrim(cUsername)) $ UPPER(GETMV("BH_SEMSLDK"))
							MsgInfo("Usuario sem acesso para gerar pedidos com componentes faltantes. Favor entrar em contato o administrador do sistema.","Saldo")
								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณLimpa Filtro.ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
							dbSelectArea(cAliasTop5)
							dbCloseArea()
							Return()
						Endif
			     	Endif
			     Endif
			Endif
			EndIf
		Endif
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Adapta็ใo para o coletor de dados                                      ณ
		//ณ Delta Decisao - DF - 11/10/2011                                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If DLVTAviso("Pedido de Venda", "Deseja gerar os Pedidos de Vendas para Kit?", {"NAO","SIM"}) == 2
			cKit := MostraKit()
			If !empty(cKit)    
				_lRetSld := .T.
			     _lRetSld := VERIFSLD(cKit)
			     If !_lRetSld
			     	If DLVTAviso("Existem componentes com problema de saldo. Deseja prosseguir mesmo assim?", {"NAO","SIM"}) == 1
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณLimpa Filtro.ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
						dbSelectArea(cAliasTop5)
						dbCloseArea()
						Return()
					Else
						If !UPPER(Alltrim(cUsername)) $ UPPER(GETMV("BH_SEMSLDK")) 
							DLVTAviso("Usuario sem acesso para gerar pedidos com componentes faltantes. Favor entrar em contato o administrador do sistema.")
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณLimpa Filtro.ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
							dbSelectArea(cAliasTop5)
							dbCloseArea()
							Return()
						Endif
					Endif
			     Endif
			Endif
		Endif
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adapta็ใo para o coletor de dados                                      ณ
	//ณ Delta Decisao - DF - 11/10/2011                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !lRf
		//Janela
		oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
		@ 0,0 TO 200,300 DIALOG oDlg TITLE "Tipo de Saida"
		oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlg)
		@ 05,050 SAY oV1 var "Informe o TES a ser usado:" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
		@ 40,010 GET cVarTes Size 100,080 PICTURE "@!" valid ExistCPO("SF4",cVarTES) .AND. cVarTES>="500"  F3 "SF4"
		@ 80,085 BMPBUTTON TYPE 1 ACTION Processa({|lEnd| tecx015a(cVarTes,odlg,.f.)})
//		@ 80,120 BMPBUTTON TYPE 2 ACTION oDlg:End()
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณIncluso funcao no botao abaixo para voltar o status do aparelho para lido caso o usuario saia da tela de inclusao de Kit.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		@ 80,120 BMPBUTTON TYPE 2 ACTION tecx015b(odlg)
		Activate MSDialog oDlg Centered
	Else
		VTClear()
		VTClearBuffer()
		DLVTCabec("Tipo de Saida",.F.,.F.,.T.)
		@ 01, 00 VTSay "Informe o TES a ser usado:"	VTGet cVarTes Pict "@!" Valid (ExistCPO("SF4",cVarTES) .AND. cVarTES>="500")
		VTREAD
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecu็ใo dos pedidos de vendasณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If DLVTAviso("Pedido de Venda", "Confirma os Pedidos de Vendas?", {"OK","CANCELAR"}) == 1
			VTClear()
			VTClearBuffer()
			VTMsg("Processando, Aguarde...")
			tecx015a(cVarTes,odlg,.F.,.T.)
		Else
			tecx015b(odlg,.T.)
		Endif
	Endif
Else
	While !(cAliasTop5)->(Eof())
		_cIMEI   := alltrim((cAliasTop5)->ZZ4_IMEI)
		_cIMEI   := AllTrim(_cIMEI)+ space(TamSX3("ZZ4_IMEI")[1]-len(AllTrim(_cIMEI)))
		_cOSab9  := alltrim((cAliasTop5)->ZZ4_OS)
		_ccliab9 := alltrim((cAliasTop5)->ZZ4_CODCLI)
		_clojb9  := alltrim((cAliasTop5)->ZZ4_LOJA)
		cVarTes  := IIF(funname() == "BESTQPED",ALLTRIM(MV_PAR06),"727")  //TES Default
		cVarTes  := IIF(funname() == "TECAX033","729",cVarTes)  //TES Default
		ctesswp := Posicione("ZZJ",1,xFilial("ZZJ") + alltrim((cAliasTop5)->ZZ4_OPEBGH), "ZZJ_TESSWP")    // cria variavel da TES SWAP - Edson Rodrigues - 13/04/10
		dbSelectArea("AB9")
		if AB9->(dbSeek(xFilial("AB9") +_cIMEI+_cOSab9))
			While  !AB9->(Eof()) .and. AB9->AB9_FILIAL == xFilial("AB9") .and. AB9->AB9_SN == _cIMEI .and. ;
				left(AB9->AB9_NUMOS,6) == _cOSab9 .and. AB9->AB9_CODCLI==_ccliab9 .and. AB9->AB9_LOJA==_clojb9 .and. ;
				AB9->AB9_TIPO == "1"  // Atendimento da OS Encerrado
				If EMPTY(AB9->AB9_NOVOSN)
					cVarTes:="727"//TES Default
				Else
//					alert("pegou o tes 735")
					cVarTes:=ctesswp//TES SWAP
				Endif
				if funname() == "TECAX033"
					cVarTes:="729"  // TES ESPECIFICA PARA ENCERRAMENTO AUTOMATICO - USO MUITO ESPORADICO
				Elseif funname() == "BESTQPED"
					cVarTes:=ALLTRIM(MV_PAR06)	 // TES ESPECIFICA PARA ENCERRAMENTO AUTOMATICO - USO MUITO ESPORADICO
				Endif
				AB9->(dbSkip())
			Enddo
		Endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria os registros em AA3,AB1,AB2,AB6 e AB7.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		tecx015a(cVarTes,oDlg,_lrotaut)
		dbSelectArea(cAliasTop5)
		(cAliasTop5)->(dbSkip())
	Enddo
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLimpa Filtro.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cAliasTop5)
dbCloseArea()
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ tecx015a บAutor ณ Antonio Leandro Favero  บData ณ 26/01/03 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria os registros em AA3,AB1,AB2,AB6 e AB7                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function tecx015a(cTes,oDlg,_lrotaut,lRf)
Local Handle,cLinha,cArq //Variaveis para criacao do arquivo TXT
Local nOS			:= 0     	// Contador de Ordens de Servi็o
Local nITCham		:= 0 		// Contador de Itens do Chamado
Local cItens		// := "01"
Local cPath			:= "\IMPMASS\"                    // Local de gera็ใo do arquivo
Local aDirectory	:= Directory (cPath + "*.*")      // Tipo de arquivo a serem excluidos
Local _aSavZZ4		:= {}
Local _aSavSC6		:= {}
Local _aSavAB9		:= {}
Local _aSavSC9		:= {}
Local _aCabSC5		:= {}
Local _aIteSC6		:= {}
Local _aCPCSC5		:= {}
Local _aIMPSC6		:= {} //Array com IMEI para ordernar por produto e selecinar as pe็as apontadas - Edson Rodrigues - 23/10/09
Local _aIteSB1		:= {}
Local _lRet			:= .T.
Local _nConIMEI		:= 0  //Conta quantos IMEIS gerado os pedidos - Incluso Edson Rodrigues - 15/04/10
Local _nConPED		:= 0  //Conta quantos Pedidos gerados - Incluso Edson Rodrigues - 15/04/10
Local _ncItkit		:= 0  //Conta quantos itens de Kit foram gerados no total - Edson Rodrigues 15/04/10
Local  nItkit		:= 0  //Conta quantos itens de Kit foram gerados por produto - Edson Rodrigues 15/04/10
Local _nPrcVen		:= 0
Local _cMensOp      := ALLTRIM(GetMV("MV_MENOPER"))// Parametro com as operacoes cujo a Mensagem complementar deve ser a partir do F4_formula
Private _cMenSC5	:= ""
Private aNfOk		:= 	{}
Private aPedido		:= 	{}
Private aPedZZQ		:= 	{}
Private aZZQPec		:=  {}
Private aKit		:= 	{}
Private aB6KIT		:= 	{}
Private _cTesEtq	:= cTes
Private _cgeraNF	:= "N"
Private _cgNFpec	:= "N"
Private lPVSwp      := .F.
Private cTesImOld	:= "" 
Private cZZ4Cli	 	:= ""
Private	cZZ4LjCl 	:= ""
Private cMsgNF		:= ""
Private cSwpOp		:= ""
Private cImeiNovo	:= ""  
Private cmodNovo    := ""
Private cgernfsw    := ""
Private aC5SwpCab	:= {}
Private aC6SwpIt	:= {}

Private _cGePeca	:= "N"
Private _cSerNF		:= "1"
Private _cMenNota	:= "N"
Private _cAglPed	:= "N"
Private	_cLayETQ	:= ""
Private	_clab		:= ""
Private	_lvdaprod	:= .F.
Private	_loper		:= .T.
Private	_ctransp	:= ""
Private	_cmenpad	:= ""
Private	_cmenpTES	:= ""
Private	_cdivneg	:= ""
Private	_clibPvS	:= "N"
Private	_carmzen	:= ""
Private	_cSepEnt	:= ""
Private cChaveOS	:= ""
Private _cmudfdes   := ALLTRIM(GETMV("MV_MUDFDES"))
Private _cmudfori   := ALLTRIM(GETMV("MV_MUDFORI"))
Private _copmubgh   := ALLTRIM(GETMV("MV_OPMUBGH"))
Private _cfornbgh   := ALLTRIM(GETMV("MV_FORBGHM"))
Private _ctesultf   := ALLTRIM(GETMV("MV_TESULTF"))
Private _ctesretc   := ALLTRIM(GETMV("MV_TESRETC"))


Default lRf			:= .F.




If !_lrotaut .And. !lRf
	oDlg:end()
Endif
If !lRf
	ProcRegua((cAliasTop5)->(RECCOUNT()))
	(cAliasTop5)->(dbGoTop())
Endif
//Begin Transaction
While !(cAliasTop5)->(Eof())
	cChaveOS	:= (cAliasTop5)->(ZZ4_CODCLI+ZZ4_LOJA+ZZ4_NFENR+ZZ4_NFESER) // Alterado 17/05/05 Nicoletti
	cItens		:= "00"
	nContIt		:= 0
	_lAltMen	:= .F.
	_coperbgh	:= AllTrim((cAliasTop5)->ZZ4_OPEBGH)
	_cgerapvpc	:= "N"
	_cgeraNF	:= "N"
	_cgNFpec    := "N"
	_cGePeca	:= "N"
	
	//Adequa็ใo Carlos
	//_cSerNF		:= Iif((cAliasTop5)->ZZ4_FILIAL="02","001","1")
	//_cSerNF		:= Iif((cAliasTop5)->ZZ4_FILIAL="02","1","1")
	_cSerNF		:= GetSerie(AllTrim(_coperbgh)) // Alterado para adequar o retorno de n๚mero de s้rie de saํda - GLPI 20422
	_cMenNota	:= "N"
	_cAglPed	:= "N"
	_cLayETQ	:= ""
	_clab		:= ""
	_lvdaprod	:= .F.
	_loper		:= .T.
	_ctransp	:= ""
	_cmenpad	:= ""
	_cmenpTES	:= ""
	_cdivneg	:= ""
	_clibPvS	:= "N"
	_carmzen	:= ""
	_cSepEnt	:= ""
	
	
	dbSelectArea("ZZJ")
	If ZZJ->(DBSeek(xFilial("ZZJ")+AllTrim((cAliasTop5)->ZZ4_OPEBGH)))
		_coperbgh  := ZZJ->ZZJ_OPERA  // cria variavel da operacao - Edson Rodrigues - 20/03/10
		_cgerapvpc := ZZJ->ZZJ_PVPECA // cria variavel de gera pedido de pe็as sim ou nao - Edson Rodrigues - 20/03/10
		_cgeraNF   := ZZJ->ZZJ_GERANF // cria variavel de gera NF de Saida sim ou nao - Luciano - 30/04/12
        _cgNFpec   := ZZJ->ZZJ_GERNFP // cria variavel de gera NF de Saida s๓ para pedido de pe็as sim ou nao - E.Rodrigues - 03/03/15
		_cSepNfPC  := ZZJ->ZZJ_SEPPC  // Indica se deve separar a notas fiscal de acessorios - Diego - 19/09/2013
		_cGePeca   := ZZJ->ZZJ_GEPECA 
		lSwpPri	   := ZZJ->ZZJ_SWPPRI == 'S' 
		cSwpCli	   := ZZJ->ZZJ_SWPCL
		cgernfsw   := ZZJ->ZZJ_GENFSW
		/*
		 IF (cAliasTop5)->ZZ4_FILIAL="02"
		  
		   //Adequacao Carlos
		  //_cSerNF	   := IIF(AllTrim(_coperbgh) $ GetMV("BH_SERI004"),"004","001")
		  _cSerNF	   := IIF(AllTrim(_coperbgh) $ GetMV("BH_SERI004"),"4","1")
		  
		  
		 Else      
		     If AllTrim(_coperbgh) $ "N02/N04/N05/N06/N9/N11"
    	          _cSerNF	   := "1"
    	     ElseIf AllTrim(_coperbgh) $ "N01/N10" 
    	          _cSerNF	   := "2"
    	     ElseIf AllTrim(_coperbgh) $ "N03/N07/N08/P02/P03" 
    	          _cSerNF	   := "4"
    	     Else     
    	          _cSerNF	   := "1"
    	     Endif         
		EndIf*/
		_cSerNF	    := GetSerie(AllTrim(_coperbgh)) // Alterado para adequar o retorno de n๚mero de s้rie de saํda - GLPI 20422  
		_cMenNota	:= ZZJ->ZZJ_MENNOT // cria variavel de Mensagem para nota sim ou nao - Luciano - 20/05/12
		_cAglPed	:= ZZJ->ZZJ_AGLPED // cria variavel de Aglutina Pedidos Venda sim ou nao - Luciano - 17/05/12
		_cLayETQ	:= ZZJ->ZZJ_LAYETQ // cria variavel de Layout Etiqueta - Luciano - 17/05/12
		_clab		:= ZZJ->ZZJ_LAB    // cria variavel do Laboratorio - Edson Rodrigues - 13/04/10
		_lvdaprod	:= U_VLDPROD(_coperbgh,_clab) //Valida opera็๕es para chamar que envolpe Ordem Produ็ใo. Edson Rodrigues 13/04/10
		_ctransp	:= ZZJ->ZZJ_TRANSP
		_cmenpTES	:= Posicione("SF4",1,xFilial("SF4") + cTes, "F4_FORMULA")//Alterado conforme solicita็ใo do Carlos - Luciano 10/05/12
		
		// Alterada a validacao conforme GLPI-[18.733] Uiran Almeida 14.10.2014
		If( AllTrim(_coperbgh) $ _cMensOp )
			_cmenpad := (ZZJ->ZZJ_MENPAD)
		Else
		_cmenpad	:= IIF(Empty(_cmenpTES),ZZJ->ZZJ_MENPAD,_cmenpTES)
		End
		
		_cdivneg	:= ZZJ->ZZJ_DIVNEG
		_clibPvS	:= ZZJ->ZZJ_LIBPVS
		_carmzen	:= AllTrim(ZZJ->ZZJ_ARMENT)
		_cSepEnt	:= Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_SEPENT")//Incluido conforme solicita็ใo do Edson 13/06/2012
	Else
		If !lRf //Implantacao Radio Frequencia
			ApMsgInfo("Nใo foi encontrado a operacao cadastrada para OS "+(cAliasTop5)->(ZZ4_OS)+" e IMEI "+(cAliasTop5)->(ZZ4_IMEI)+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao nใo localizada!")
		Else
			VTBEEP(3)
			VTAlert("Nใo foi encontrado a operacao cadastrada para OS "+(cAliasTop5)->(ZZ4_OS)+" e IMEI "+(cAliasTop5)->(ZZ4_IMEI)+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao nใo localizada!",.t.,2500)
		Endif
		(cAliasTop5)->(dbSkip())
		_loper:=.F.
		loop
		
	Endif
	
	IF _lvdaprod .and. _loper
		_citlocal :=ZZJ->ZZJ_ALMPRO
		_cprefix  :=ALLTRIM(ZZJ->ZZJ_PREFPA)
		_cproduto :=IIF(left((cAliasTop5)->ZZ4_CODPRO,3)=="DPY",_cprefix+substr(alltrim((cAliasTop5)->ZZ4_CODPRO),4,12),_cprefix+alltrim((cAliasTop5)->ZZ4_CODPRO))
	Else
		_citlocal :=(cAliasTop5)->ZZ4_LOCAL
		_cproduto :=(cAliasTop5)->ZZ4_CODPRO
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGeracao dos Cabecalhos                                                                   ณ
	//ณIncluso DBseek no SB1 para buscar o Local padrao do produto - Edson Rodrigues - 26/04/07.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SB1->(DBSeek(xFilial("SB1")+_cproduto))
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(DBSeek(xFilial("SA1")+(cAliasTop5)->(ZZ4_CODCLI+ZZ4_LOJA)))
	_aCabSC5  := {}
	_aIteSC6  := {}
	_ctransp  := IIF(_lrotaut,"03", IIF(Empty(_ctransp),SA1->A1_TRANSP,_ctransp))
	
	// Alterada a validacao conforme GLPI-[18.733] Uiran Almeida 14.10.2014
	If( AllTrim(_coperbgh) $ _cMensOp )
		_cmenpad := (ZZJ->ZZJ_MENPAD)
	Else
	_cmenpad  := IIF(Empty(_cmenpad),SA1->A1_MENSAGE,_cmenpad)
	End
	
	_cdivneg  := IIF(Empty(_cdivneg),"09",_cdivneg)
	_aAreaSC5 := SC5->(GetArea())
	_nConPED++
	
	If _cMenNota == "S"  .and. !_lrotaut
		If !lRf
			If ApMsgYesNo("Informar mensagem para NF?","Mensagem Padrใo")
				MENNOTA()	
			Endif	
		Else
			If DLVTAviso("Mensagem Padrao", "Informar mensagem para NF?", {"SIM","NAO"}) == 1
				cFile := space(50)
				VTClear()
				VTClearBuffer()   
				@ 01, 00 VTSay PadR("Mensagem Padrao" , VTMaxCol())
				@ 02, 00 VTGet cFile  Pict "@!"
				VTREAD
				_cMenSC5:= Alltrim(cFile)
				VTClear()
				VTClearBuffer()
				VTMsg("Processando, Aguarde...")
			Endif
		Endif
	Endif
	
	If Alltrim(_coperbgh) $ UPPER(GetMv("MV_ZZOPTRA"))//    "N04/N07"  &&Incluido para parametrizar opera็๕es que podem mudar transportadora na entrada massiva
		If !lRf
			If ApMsgYesNo("Deseja informar transportadora?","Transportadora")
				TRANSP()	
			Endif
		Else
			If DLVTAviso("Transportadora", "Informar transportadora?", {"SIM","NAO"}) == 1
				cFile := space(6)
				VTClear()
				VTClearBuffer()   
				@ 01, 00 VTSay PadR("Informe a Transportadora: " , VTMaxCol())
				@ 02, 00 VTGet cFile  Pict "@!" VALID ExistCPO("SA4",cFile)
				VTREAD
				_cTransp:= Alltrim(cFile)
				VTClear()
				VTClearBuffer()
				VTMsg("Processando, Aguarde...")
			Endif			
		Endif
		
	Endif
	

	If !Empty(cKit) .and. (!Empty((cAliasTop5)->ZZO_NUMCX) .AND. !(cAliasTop5)->ZZ4_OPEBGH $ _copmubgh )
		cKit := ""
	Endif
	
	aImNovo := {}
	If SchZZ3Swp(@aImNovo) .and. lSwpPri .and. !Empty(cSwpCli)
		cZZ4Cli	 := IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. ALLTRIM((cAliasTop5)->ZZ4_OPEBGH) $ _copmubgh ,_cfornbgh,(cAliasTop5)->ZZ4_CODCLI)
		cZZ4LjCl := IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. ALLTRIM((cAliasTop5)->ZZ4_OPEBGH) $ _copmubgh ,"01",(cAliasTop5)->ZZ4_LOJA)  			
		cCliente := SubStr(cSwpCli,1,6)
		cLoja	 := SubStr(cSwpCli,7,2)
		cSwpOp	 := (cAliasTop5)->ZZ4_OPEBGH	
		lPVSwp	 := .T. 
		cTesImOld:= Posicione("ZZJ",1,xFilial("ZZJ") + cSwpOp, "ZZJ_SWPTES")		
		If Len(aImNovo) > 0 
			For nx:=1 To Len(aImNovo) 								
				_cMenSC5 := Alltrim(_cMenSC5 + " IMEI NOVO " + aImNovo[nx][1] + " SI " + aImNovo[nx][2] + ". " + " IMEI ANTIGO " + Alltrim((cAliasTop5)->ZZ4_IMEI)+ ". ")	
			Next nx
		EndIf		
	Else
		cCliente := IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. ALLTRIM((cAliasTop5)->ZZ4_OPEBGH) $ _copmubgh ,_cfornbgh,(cAliasTop5)->ZZ4_CODCLI)
		cLoja	 := IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. ALLTRIM((cAliasTop5)->ZZ4_OPEBGH) $ _copmubgh ,"01",(cAliasTop5)->ZZ4_LOJA) 
	EndIf
	                                                                       
	_aCabSC5  := {	{"C5_TIPO",IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh,"B","N")			,Nil},;
	{"C5_CLIENTE"	,cCliente				,Nil},;
	{"C5_LOJACLI"	,cLoja					,Nil},;
	{"C5_LOJAENT"	,cLoja					,Nil},;
	{"C5_TIPOCLI"	,"F"					,Nil},;
	{"C5_CONDPAG"	,"001"	   				,Nil},;
	{"C5_TIPLIB"	,"1"	   				,Nil},;
	{"C5_TPCARGA"	,"2"	   				,Nil},;
	{"C5_B_KIT"		,cKit   				,Nil},;
	{"C5_XUSER"		,alltrim(cusername)		,Nil},;
	{"C5_TRANSP"   ,IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh,"56",_ctransp),Nil},;
	{"C5_MENPAD"   ,_cmenpad                ,Nil},;
	{"C5_DIVNEG"   ,_cdivneg                ,Nil},;
	{"C5_MENNOTA"	,_cMenSC5      			,Nil}}
	
	If lPVSwp
		aC5SwpCab := _aCabSC5
		_cMenSC5  := ""
	EndIf		
	
	//Alterado Edson Rodrigues - 14/04/10
	/*
	{"C5_TRANSP"	,iif(EMPTY(_citlocal),IIF(SB1->B1_LOCPAD $ "22/26/27/35",SA1->A1_TRANSP,iif(!_lrotaut,"","03")),IIF(_citlocal $ "22/26/27",SA1->A1_TRANSP,iif(!_lrotaut,"","03"))),Nil},;// Alterado por Edson Rodrigues - 13/12/2007 - 02/12/2008
	{"C5_MENPAD"	,iif(EMPTY(_citlocal),IIF(SB1->B1_LOCPAD $ "22/26/27",SA1->A1_MENSAGE ,"")	,IIF(_citlocal $ "22/26/27",SA1->A1_MENSAGE ,"")),Nil},; //Alterado por Edson Rodrigues - 02/12/2008
	{"C5_DIVNEG"	,iif(EMPTY(_citlocal),IIF(SB1->B1_LOCPAD $ "22/26/27/35","03",iif(SB1->B1_LOCPAD $ "10","04","09")),IIF(_citlocal $ "22/26/27/35","03",iif(SB1->B1_LOCPAD $ "10","04","09"))),Nil}, ;// Alterado por Edson Rodrigues - 26/12/2007  - 02/12/2008
	{"C5_MENNOTA"	,""      					,Nil}}
	*/
	//**********************************************
	//          Gera Arquivo TXT para Nextel       *
	//**********************************************
	// Apaga Arquivos .DBF da pasta   -- Paulo Lopez - 29/03/10
	//	aEval(aDirectory, {|x| FErase(cPath + x[1])})
	//
	//cArq := cPath + "\BGH"+ALLTRIM((cAliasTop5)->ZZ4_NFENR)+AllTrim((cAliasTop5)->ZZ4_NFESER)+".TXT"  // Alterado Local para gera็ใo do Arquivo - Paulo Lopez - 29/03/10
	//
	//If FILE(cArq)
	//	FERASE(cArq)
	//Endif
	//
	//HANDLE := FCREATE (cArq,0)

	
	
	
	//**********************************************
	//          Geracao dos ITENS                  *
	//**********************************************
	If !Empty((cAliasTop5)->ZZO_NUMCX) .AND. !(cAliasTop5)->ZZ4_OPEBGH $ _copmubgh
		_cFiltro := "!Empty((cAliasTop5)->ZZO_NUMCX) .and. !(cAliasTop5)->(Eof()) .and. !alltrim((cAliasTop5)->ZZ4_OPEBGH) $ '"+_copmubgh+"' "
	ElseIf !Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh
		_cFiltro := "!Empty((cAliasTop5)->ZZO_NUMCX) .and. !(cAliasTop5)->(Eof()) .and. alltrim((cAliasTop5)->ZZ4_OPEBGH) $ '"+_copmubgh+"' "
	Else
		_cFiltro := "(cChaveOS == (cAliasTop5)->(ZZ4_CODCLI+ZZ4_LOJA+ZZ4_NFENR+ZZ4_NFESER) ) .and. !(cAliasTop5)->(Eof())"
	Endif
	
	_cB6Acum   := ""
	_aB6Acum   := {} // Acumula IDENT de poder de terceiros utilizados e calcula saldo disponivel para novos registros - Munhoz 01/11/2011
	_cMenMast  := ""
	dbSelectArea(cAliasTop5)
	//WHILE (cChaveOS == (cAliasTop5)->(ZZ4_CODCLI+ZZ4_LOJA+ZZ4_NFENR+ZZ4_NFESER) ) .and. !(cAliasTop5)->(Eof()) // Nicoletti 17/05/05
	WHILE &_cFiltro
	
		If !EMPTY((cAliasTop5)->ZZO_NUMCX) .and.  !RIGHT((cAliasTop5)->ZZO_NUMCX,5)	 $ Alltrim(_cMenMast)
			If Empty(_cMenMast)
				_cMenMast  := " Master(s): " + RIGHT((cAliasTop5)->ZZO_NUMCX,5)
				_aCabSC5[14,2] := Alltrim(_aCabSC5[14,2])+Alltrim(_cMenMast)+space(1)
			Else
				_cMenMast  := Alltrim(_cMenMast)+"/"+RIGHT((cAliasTop5)->ZZO_NUMCX,5)	
				_aCabSC5[14,2] := Alltrim(_aCabSC5[14,2])+"/"+RIGHT((cAliasTop5)->ZZO_NUMCX,5)+space(1)	
			Endif
		Endif
		
		_cItemOri := Space(2)
		_citLocal := (cAliasTop5)->ZZ4_LOCAL//Space(2) //Edson Rodrigues -- 03/11/08
		_cIdentB6 := Space(6)
		_coperbgh  := alltrim((cAliasTop5)->ZZ4_OPEBGH)
		_cSepEnt  := ""
		
		dbSelectArea("ZZJ")
		If ZZJ->(DBSeek(xFilial("ZZJ")+AllTrim((cAliasTop5)->ZZ4_OPEBGH)))
			_coperbgh := ZZJ->ZZJ_OPERA  // cria variavel da operacao - Edson Rodrigues - 20/03/10
			_cgerapvpc:= ZZJ->ZZJ_PVPECA // cria variavel de gera pedido de pe็as sim ou nao - Edson Rodrigues - 20/03/10
			_cgeraNF   := ZZJ->ZZJ_GERANF // cria variavel de gera NF de Saida sim ou nao - Luciano - 30/04/12
			_cgNFpec   := ZZJ->ZZJ_GERNFP // cria variavel de gera NF de Saida s๓ para pedido de pe็as sim ou nao - E.Rodrigues - 03/03/15
			_cGePeca  :=  ZZJ->ZZJ_GEPECA
			ctesswp    := ZZJ->ZZJ_TESSWP
		    /*
    		IF (cAliasTop5)->ZZ4_FILIAL="02"
    		
    		 //Adequa็ใo Carlos
			 //_cSerNF	   := IIF(AllTrim(_coperbgh) $ GetMV("BH_SERI004"),"004","001")
               _cSerNF	   := IIF(AllTrim(_coperbgh) $ GetMV("BH_SERI004"),"4","1")
               			 
			Else
    		    If AllTrim(_coperbgh) $ "N02/N04/N05/N06/N9/N11"
    	          _cSerNF	   := "1"
    	          
					
    	        ElseIf AllTrim(_coperbgh) $ "N01/N10" 
    	          _cSerNF	   := "2"

    	        ElseIf AllTrim(_coperbgh) $ "N03/N07/N08/P02/P03" 
    	          _cSerNF	   := "4"
    	        Else     
    	          _cSerNF	   := "1"
    	        Endif 
			EndIf*/
			_cSerNF	  := GetSerie(AllTrim(_coperbgh)) // Alterado para adequar o retorno de n๚mero de s้rie de saํda - GLPI 20422  	   
			_cMenNota  := ZZJ->ZZJ_MENNOT // cria variavel de Mensagem para nota sim ou nao - Luciano - 20/05/12
			_cAglPed   := ZZJ->ZZJ_AGLPED // cria variavel de Aglutina Pedidos Venda sim ou nao - Luciano - 17/05/12
			_cLayETQ   := ZZJ->ZZJ_LAYETQ // cria variavel de Layout Etiqueta - Luciano - 17/05/12
			_clab     := ZZJ->ZZJ_LAB    // cria variavel do Laboratorio - Edson Rodrigues - 13/04/10
			_lvdaprod :=U_VLDPROD(_coperbgh,_clab) //Valida opera็๕es para chamar que envolpe Ordem Produ็ใo. Edson Rodrigues 13/04/10
			_ctransp  := ZZJ->ZZJ_TRANSP
			_cmenpTES :=Posicione("SF4",1,xFilial("SF4") + cTes, "F4_FORMULA")//Alterado conforme solicita็ใo do Carlos - Luciano 10/05/12
			
			// Alterada a validacao conforme GLPI-[18.733] Uiran Almeida 14.10.2014
			If( AllTrim(_coperbgh) $ _cMensOp )
				_cmenpad := (ZZJ->ZZJ_MENPAD)
			Else
			_cmenpad  := IIF(EMPTY(_cmenpTES),ZZJ->ZZJ_MENPAD,_cmenpTES)
			EndIf
			
			_cdivneg  := ZZJ->ZZJ_DIVNEG
			_clibPvS  := ZZJ->ZZJ_LIBPVS
			_carmzen  :=  ALLTRIM(ZZJ->ZZJ_ARMENT)
			_cSepEnt  := Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_SEPENT")//Incluido conforme solicita็ใo do Edson 13/06/2012
		
		Else
			If !lRf //Implanta็ใo Radio Frequencia
				ApMsgInfo("Nใo foi encontrado a operacao cadastrada para OS "+(cAliasTop5)->(ZZ4_OS)+" e IMEI "+(cAliasTop5)->(ZZ4_IMEI)+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao nใo localizada!")
			Else
				VTBEEP(3)
				VTAlert("Nใo foi encontrado a operacao cadastrada para OS "+(cAliasTop5)->(ZZ4_OS)+" e IMEI "+(cAliasTop5)->(ZZ4_IMEI)+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao nใo localizada!",.t.,2500)
			Endif
			
			(cAliasTop5)->(dbSkip())
			_loper:=.F.
			Loop
		Endif
		If _lvdaprod .and. _loper
			_cprefix  :=ALLTRIM(ZZJ->ZZJ_PREFPA)
			_cproduto :=IIF(left((cAliasTop5)->ZZ4_CODPRO,3)=="DPY",_cprefix+substr(alltrim((cAliasTop5)->ZZ4_CODPRO),4,12),_cprefix+alltrim((cAliasTop5)->ZZ4_CODPRO))
		Else
			_cproduto :=(cAliasTop5)->ZZ4_CODPRO
		Endif
		SB1->(DBSeek(xFilial("SB1")+_cproduto))
		SF4->(DBSeek(xFilial("SF4")+cTes))
		If !_lvdaprod
			// Verifica item e IDENTB6 na Nota Fiscal de Entrada para informar nos campos de NF Original no Pedido de Venda
			_lAchouSB6 := .f.
			dbSelectArea("SD1")
			//dbSetOrder(12)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER
			// Alterado pois assim poderemos ter problema num possํvel atualizacao da TOTVS - Edson Rodrigues - 08/04/11
			//             SD1->(dbOrderNickName("D1NUMSER")) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAlterado por M.Munhoz em 16/08/2011 - Posicionar SD1 sem utilizar o D1_NUMSER. ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			//		     If SD1->(DbSeek(xFilial("SD1")+(cAliasTop5)->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+Substr(ZZ4_IMEI,1,20))) )
			If SD1->(DbSeek(xFilial("SD1")+(cAliasTop5)->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_ITEMD1)) )
				
				// Identifico o IDENTB6 do item que esta sendo retornado
				If SD1->D1_ITEM == (cAliasTop5)->ZZ4_ITEMD1  //M.Munhoz 16/08/2011
					_cItemOri := SD1->D1_ITEM
					_cIdentB6 := SD1->D1_IDENTB6
					_citlocal := SD1->D1_LOCAL
				Endif
				// Verifica primeiro a matriz de saldos de terceiros // Munhoz 01/11/2011
				_nPosTerc := aScan(_aB6Acum, { |X| X[1] == _cIdentB6 })
				if _nPosTerc > 0 .and. _aB6Acum[_nPosTerc,2] >= 1
					_lAchouSB6 := .t.
					_aB6Acum[_nPosTerc,2] := _aB6Acum[_nPosTerc,2] - 1
				Else
					// Verifico se o IDENTB6 encontrado possui saldo na tabela SB6 (primeira pesquisa no SB6 pelo IDENT correto do SD1)
					SB6->(dbSetOrder(5)) //B6_FILIAL + B6_SERIE + B6_DOC + B6_CLIFOR + B6_LOJA + B6_IDENT + B6_PRODUTO + B6_PODER3
					If _nPosTerc == 0 .and. SB6->(dbSeek(xFilial("SB6") + (cAliasTop5)->(ZZ4_NFESER + ZZ4_NFENR + ZZ4_CODCLI + ZZ4_LOJA) + _cIdentB6 + (cAliasTop5)->ZZ4_CODPRO + "R")) .AND. SD1->(!Eof())  //M.Munhoz 16/08/2011
						// Calculo saldo disponivel de Terceiros
						IF SB6->B6_SALDO > 0
						    _nSalP3  := SalDisP3(SB6->B6_IDENT , SB6->B6_SALDO)
						Else
						    _nSalP3  := 0
						Endif
						if _nSalP3 >= 1
							_lAchouSB6 := .t.
							aAdd(_aB6Acum, {SB6->B6_IDENT, _nSalP3 - 1 }) // Calcula saldo disponivel (B6_SALDO - PVs em aberto) e desconta 1 do item processado neste momento
						Endif
					//Else Retirado esse Else e acrescentado o Endif / If para fazer validacao quando o produto nใo tiver saldo pelo ident e tiver que buscar pela nota - Edson Rodrigues 09/11/11
					Endif	
					If 	 !_lAchouSB6
						// Se o IDENTB6 nao estiver na matriz e nao for encontrado no SB6 ou nao possuir saldo, procuro pelo primeiro item da NF com mesmo produto no SB6 com saldo maior que 1
						SB6->(dbSetOrder(5)) //B6_FILIAL + B6_SERIE + B6_DOC + B6_CLIFOR + B6_LOJA + B6_IDENT + B6_PRODUTO + B6_PODER3
						If SB6->(dbSeek(xFilial("SB6") + (cAliasTop5)->(ZZ4_NFESER + ZZ4_NFENR + ZZ4_CODCLI + ZZ4_LOJA) ))
							While SB6->(!Eof()) .and. SB6->B6_FILIAL == xFilial("SB6") .and. ;
								SB6->B6_SERIE  == (cAliasTop5)->ZZ4_NFESER  .and. SB6->B6_DOC  == (cAliasTop5)->ZZ4_NFENR .and. ;
								SB6->B6_CLIFOR == (cAliasTop5)->ZZ4_CODCLI .and. SB6->B6_LOJA == (cAliasTop5)->ZZ4_LOJA
								_nPosTerc := aScan(_aB6Acum, { |X| X[1] == SB6->B6_IDENT })
								If _nPosTerc == 0 .and. alltrim(SB6->B6_PRODUTO) == alltrim((cAliasTop5)->ZZ4_CODPRO)
                                   If  SB6->B6_SALDO > 0
									    _nSalP3 := SalDisP3(SB6->B6_IDENT , SB6->B6_SALDO)
								   Else
								        _nSalP3 :=  0
								   Endif	    
									If _nSalP3 >= 1 .and. SB6->B6_PODER3 == "R" 
										_lAchouSB6 := .t.
										_cItemOri  := ""
										_cIdentB6  := SB6->B6_IDENT
										_citlocal  := SB6->B6_LOCAL
										aAdd(_aB6Acum, {SB6->B6_IDENT, _nSalP3 - 1 }) // Calcula saldo disponivel (B6_SALDO - PVs em aberto) e desconta 1 do item processado neste momento
									exit
									Endif
								ElseIf _nPosTerc > 0 .and. _aB6Acum[_nPosTerc,2] >= 1 .and. alltrim(SB6->B6_PRODUTO) == alltrim((cAliasTop5)->ZZ4_CODPRO)//Adicionado para resolver problema de Saldo - Luciano Delta Decisao 08/05/2012
									_lAchouSB6 := .t.
									_cItemOri  := ""
									_cIdentB6  := _aB6Acum[_nPosTerc,1]
								    _citlocal  := SB6->B6_LOCAL
									_aB6Acum[_nPosTerc,2] := _aB6Acum[_nPosTerc,2] - 1
									exit
								Endif
								SB6->(dbSkip())
							Enddo
						Endif
					Endif
				Endif
			Endif
		Else
			_citlocal :=ZZJ->ZZJ_ALMPRO
			_lAchouSB6 := .t.
		Endif
		// Se nao encontrou saldo disponivel no SB6, pula item da saida massiva e nao gera PV pra ele
		If !_lAchouSB6
			If !_lrotaut
				If !lRf //Implanta็ใo radio frequencia
					ApMsgInfo("Nใo foi possํvel localizar saldo de terceiros para o IMEI " + alltrim((cAliasTop5)->ZZ4_IMEI) + ". Por favor, contate RESPONSมVEL pelo almoxarifado e solicite anแlise.","Saldo insuficiente de Terceiros")
				Else
					VTBEEP(3)
					VTAlert("Nใo foi possํvel localizar saldo de terceiros para o IMEI " + alltrim((cAliasTop5)->ZZ4_IMEI) + ". Por favor, contate RESPONSมVEL pelo almoxarifado e solicite anแlise.","Saldo insuficiente de Terceiros",.t.,2500)
				Endif
			Endif
			
			//Incluso por Edson Rodrigues para melhor gerenciamento do que nใo foi gerado por falta de saldo - 03/10/07
			dbSelectArea("ZZ4")
			_aSavZZ4 := ZZ4->(GetArea())
			//			dbSetOrder(10)  // ZZ4_FILIAL + ZZ4_OS + ZZ4_IMEI + ZZ4_TIPO + ZZ4_STNFE
			//If dbSeek(xFilial("ZZ4")+(cAliasTop5)->ZZ4_TIPO+(cAliasTop5)->ZZ4_CODCLI+(cAliasTop5)->ZZ4_LOJA+(cAliasTop5)->ZZ4_CODPRO+(cAliasTop5)->ZZ4_IMEI)
			
			ZZ4->(dbSetOrder(1))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
			If ZZ4->(dbSeek(xFilial("ZZ4") + (cAliasTop5)->ZZ4_IMEI  + (cAliasTop5)->ZZ4_OS )) .and. Empty(ZZ4->ZZ4_PV)
				//				If Empty(ZZ4->ZZ4_PV)
				// Checar a ultima saida massiva para gravar o ZZ4 pv.. quando o Pv = branco e o confirm = s
				Begin Transaction
				RecLock("ZZ4",.F.)
				//					ZZ4->ZZ4_CONFIRM:= "Z"
				ZZ4->ZZ4_STATUS := "6"
				MsUnLock("ZZ4")
				End Transaction
				//				Endif
			Endif
			RestArea(_aSavZZ4)
			(cAliasTop5)->(dbSkip())
			//			nOS-1
			//Loop -- Retirado esse loop - Edson Rodrigues - 14/06/10
		Endif
		//Verifica se o saldo total do estoque SB2 ้ menor que o saldo saldo total disponivel //Desabilitado - Edson Rodrigues
		//_lretsterc:=Sestterc((cAliasTop5)->ZZ4_CODPRO,IIF(EMPTY(_citlocal),SB1->B1_LOCPAD,_citlocal),1)
		_lretsterc:=.t.
		If !_lretsterc .and. _lAchouSB6  //Incluso variavael _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
			If !lRf //Implanta็ใo Radio Frequencia
				If !ApMsgYesNo("Nใo hแ saldo disponivel no Estoque(SB2) para atender o estoque de terceiro(SB6) do IMEI/PRODUTO : "+alltrim((cAliasTop5)->(ZZ4_IMEI))+"/"+(cAliasTop5)->ZZ4_CODPRO+". Hแ um desbalanceamento de tabelas SB2 X SB6","Deseja Gerar o Pedido de venda para esse IMEI ?")
					(cAliasTop5)->(dbSkip())
					//Loop  Retirado esse loop - Edson Rodrigues - 14/06/10
					_lAchouSB6:= .f. //Incluso variavel _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
				Endif
			Else
				If DLVTAviso("Nใo hแ saldo disponivel no Estoque(SB2) para atender o estoque de terceiro(SB6) do IMEI/PRODUTO : "+AllTrim((cAliasTop5)->(ZZ4_IMEI))+"/"+(cAliasTop5)->ZZ4_CODPRO+". Hแ um desbalanceamento de tabelas SB2 X SB6", "Deseja Gerar o Pedido de venda para esse IMEI", {"NAO", "SIM"}) == 1
					(cAliasTop5)->(dbSkip())
					_lAchouSB6:= .f. //Incluso variavel _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
				Endif
			Endif
			
		Endif
		// Avisa usuario caso nao seja possivel localizar OS + IMEI
		If AB7->(!dbSeek(xFilial("AB7")+left((cAliasTop5)->(ZZ4_OS),6)+(cAliasTop5)->(ZZ4_IMEI))) .and. _lAchouSB6
			If !lRf
				ApMsgInfo("Nใo foi possํvel localizar a OS "+(cAliasTop5)->(ZZ4_OS)+" para o IMEI "+(cAliasTop5)->(ZZ4_IMEI)+" no arquivo de OS's (AB7) do sistema. Favor contatar o administrador do sistema.","OS nใo localizada!")
			Else
				VTBEEP(3)
				VTAlert("Nใo foi possํvel localizar a OS "+(cAliasTop5)->(ZZ4_OS)+" para o IMEI "+(cAliasTop5)->(ZZ4_IMEI)+" no arquivo de OS's (AB7) do sistema. Favor contatar o administrador do sistema.","OS nใo localizada!",.t.,2500)
			Endif
			(cAliasTop5)->(dbSkip())
			//			nOS-1
			//Loop
			_lAchouSB6:= .f. //Incluso variavel _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
		Endif	
		If _lAchouSB6 //Incluso variavel _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
			cItens := Soma1(cItens,2)
			_cNumOsTk := (cAliasTop5)->ZZ4_OS+AB7->AB7_ITEM+"01"
			
			IF  _lvdaprod .and. _loper
				_cCodPro  := _cproduto
				_cproduto := alltrim(_cproduto)+space(15-len(alltrim(_cproduto)))
				_cnoprod  := LEFT((cAliasTop5)->ZZ4_OS,6)+"01001  "
				_citlocal := ZZJ->ZZJ_ALMSCR //armazem de scrap - Edson Rodrigues 13/04/10
				_nvalmob  := GetMV("MV_XVALMOB") //Valor mao de obra - Edson Rodrigues 22/01/10
				_cfasscrp := ALLTRIM(ZZJ->ZZJ_FASSCR) // Fases de Scrap
				_ccliscrp := ALLTRIM(ZZJ->ZZJ_CLISCR) // cliente/loja de scrap
				
				If SD3->(DbSeek(xFilial("SD3")+_cnoprod+_cproduto+_citlocal))
					SC2->(DBSEEK(xFilial("SC2")+LEFT((cAliasTop5)->ZZ4_OS,6)))
					_nPrcVen  := A410Arred(IIF(SC2->C2_APRATU1 > 0,SC2->C2_APRATU1,(cAliasTop5)->ZZ4_VLRUNI),"C6_VALOR")
					//Conforme solicita็ใo Carlos Rocha - Edson Rodrigues 22/01/10
				Else
					_nPrcVen  := A410Arred(IIf((cAliasTop5)->ZZ4_OPER == "12", SB1->B1_PRV1, (cAliasTop5)->ZZ4_VLRUNI),"C6_VALOR")
				Endif
				
				//Conforme solicita็ใo Carlos Rocha - Edson Rodrigues 22/01/10
				_nPrcVen += _nvalmob
				
				IF !EMPTY((cAliasTop5)->ZZ4_FASATU)
					IF alltrim((cAliasTop5)->ZZ4_FASATU) $ alltrim(_cfasscrp)
						_cnewcli  :=left(_ccliscrp,6)
						_cnewloj  :=substr(_ccliscrp,7,2)
						_nPosCcli := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_CLIENTE" })
						_nPosLcli := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_LOJACLI" })
						If _nPosCcli > 0
							_aCabSC5[_nPosCcli,2] := _cnewcli
							_aCabSC5[_nPosLcli,2] := _cnewloj
						Endif
						
					Endif
				Else
					If ZZ3->(DbSeek(xFilial("ZZ3")+(cAliasTop5)->ZZ4_IMEI+LEFT((cAliasTop5)->ZZ4_OS,6)))
						While ZZ3->(!Eof()) .and. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .and. ;
							ZZ3->ZZ3_IMEI  == (cAliasTop5)->ZZ4_IMEI  .and. LEFT(ZZ3->ZZ3_NUMOS,6)  == LEFT((cAliasTop5)->ZZ4_OS,6)
							If ZZ3->ZZ3_ENCOS="S" .AND. ZZ3->ZZ3_ESTORN<>"S" .AND. ZZ3_STATUS="1" .AND. AllTrim(ZZ3->ZZ3_FASE1) $ AllTrim(_cfasscrp)
								_cnewcli  :=left(_ccliscrp,6)
								_cnewloj  :=substr(_ccliscrp,7,2)
								_nPosCcli := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_CLIENTE" })
								_nPosLcli := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_LOJACLI" })
								If _nPosCcli > 0
									_aCabSC5[_nPosCcli,2] := _cnewcli
									_aCabSC5[_nPosLcli,2] := _cnewloj
								Endif
							Endif
							ZZ3->(DBSKIP())
						ENDDO
					Endif
				Endif
			Else
				_cCodPro   := (cAliasTop5)->ZZ4_CODPRO
				_nPrcVen   := A410Arred(IIf((cAliasTop5)->ZZ4_OPER == "12", SB1->B1_PRV1, (cAliasTop5)->ZZ4_VLRUNI),"C6_VALOR")
			Endif
			
			
			//_nPrcVen  := A410Arred(IIf((cAliasTop5)->ZZ4_OPER == "12", SB1->B1_PRV1, (cAliasTop5)->ZZ4_VLRUNI),"C6_VALOR")
			//{"C6_PRCVEN"		,IIf((cAliasTop5)->ZZ4_OPER == "12", SB1->B1_PRV1, (cAliasTop5)->ZZ4_VLRUNI)	,Nil},;
			//{"C6_VALOR"		,IIf((cAliasTop5)->ZZ4_OPER == "12", SB1->B1_PRV1, (cAliasTop5)->ZZ4_VLRUNI)	,Nil},;
			// alterado esse campo do vetor - Edson Rodrigues - 14/04/10
			//{"C6_QTDLIB"	,iif(EMPTY(_citlocal),IIF(SB1->B1_LOCPAD $ "22/26/27", 1, 0),IIF(_citlocal $ "22/26/27", 1, 0)),Nil},;
			
			If !Empty((cAliasTop5)->ZZO_NUMCX) .AND. !(cAliasTop5)->ZZ4_OPEBGH $ _copmubgh .and. AllTrim(cTes) <> _ctesretc
				cTes:=_ctesretc
			ElseIf !Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh .and. AllTrim(cTes) <> _ctesultf
				cTes:=_ctesultf
			END
			
			If lPVSwp 
				If !Empty(cTesImOld)
					cTes := cTesImOld
				EndIf					
				If Len(aImNovo) > 0 
					For nx:=1 To Len(aImNovo)					
						If aImNovo[nx][3] == Alltrim((cAliasTop5)->ZZ4_IMEI) .and. aImNovo[nx][4] == Alltrim((cAliasTop5)->ZZ4_OS)   
							cImeiNovo:= aImNovo[nx][1]
						EndIf 
					Next nx
				EndIf	
			EndIf	 		
			
			Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens	  								,Nil},;
			{"C6_PRODUTO"	,_cCodPro 				   								,Nil},;
			{"C6_DESCRI"	,SB1->B1_DESC	 		  								,Nil},;
			{"C6_TES"		,cTes													,Nil},;
			{"C6_QTDVEN"	,1						  								,Nil},;
			{"C6_QTDLIB"	,iif(_clibPvS="S", 1, 0) 								,Nil},;
			{"C6_NUMSERI"	,(cAliasTop5)->ZZ4_IMEI	  								,Nil},;
			{"C6_NUMOS"		,_cNumOsTk				  								,Nil},;
			{"C6_PRCVEN"	,_nPrcVen    			  								,Nil},;
			{"C6_VALOR"		,_nPrcVen 				  								,Nil},;
			{"C6_PRUNIT"	,0						  								,Nil},;
			{"C6_NFORI"		,IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh ,"",IIf((cAliasTop5)->ZZ4_OPER == "12", "", (cAliasTop5)->ZZ4_NFENR))	,Nil},;
			{"C6_SERIORI"	,IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh ,"",IIf((cAliasTop5)->ZZ4_OPER == "12", "", (cAliasTop5)->ZZ4_NFESER))	,Nil},;
			{"C6_ITEMORI"	,IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh ,"",IIf((cAliasTop5)->ZZ4_OPER == "12", "", _cItemOri ))				,Nil},;
			{"C6_IDENTB6"	,IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh ,"",IIf((cAliasTop5)->ZZ4_OPER == "12", "", _cIdentB6 ))				,Nil},;
			{"C6_PRCCOMP"	,IIF(!Empty((cAliasTop5)->ZZO_NUMCX) .AND. (cAliasTop5)->ZZ4_OPEBGH $ _copmubgh ,0,IIf((cAliasTop5)->ZZ4_OPER == "12", AB7->AB7_PRCCOM,0))				,Nil},;
			{"C6_LOCAL"		,IIF(EMPTY(_citlocal),SB1->B1_LOCPAD,_citlocal)         ,Nil},;
			{"C6_ENTREG"	,dDataBase				  								,Nil},;
			{"C6_OSGVS"		,(cAliasTop5)->ZZ4_GVSOS  								,Nil},;
			{"C6_AIMPGVS"	,(cAliasTop5)->ZZ4_GVSARQ 								,Nil},;
			{				,	                      								,Nil},;
			{"C6_XIMEOLD"	,Iif(lPVSwp,(cAliasTop5)->ZZ4_IMEI,"")	  				,Nil},;
			{"C6_IMEINOV"	,Iif(lPVSwp,cImeiNovo,"") 				  				,Nil}})
			
			If lPVSwp  
				aC6SwpIt := _aIteSC6				
				cMsgNF   := Alltrim(cMsgNF+" IMEI ANTIGO " + Alltrim((cAliasTop5)->ZZ4_IMEI) + " SI " + Alltrim((cAliasTop5)->ZZ4_CODPRO) + ". " + " IMEI NOVO " + cImeiNovo+ ". ")
				cImeiNovo:= ""   
			EndIf
			
			If !_lvdaprod
				//VERIFICA NOVAMENTE O ARMAZEM ORIGINAL - EDSON RODRIGUES - 02/12/08
				dbSelectArea("SD1")
				//		       dbSetOrder(12)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER  // M.Munhoz - 16/08/2011
				dbSetOrder(1)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER
				If SD1->(DbSeek(xFilial("SD1")+(cAliasTop5)->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_ITEMD1)) )
					//		         	If Substr(SD1->D1_NUMSER,1,20) == substr((cAliasTop5)->ZZ4_IMEI,1,20)  // M.Munhoz - 16/08/2011
					If SD1->D1_ITEM == (cAliasTop5)->ZZ4_ITEMD1
						_citlocal := SD1->D1_LOCAL
					Else
						If SD1->(DbSeek(xFilial("SD1")+(cAliasTop5)->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO)) )
							_citlocal := SD1->D1_LOCAL
						Endif
					Endif
				Endif
			Endif
			
			/* Comentado esse bloco de codigo e substiuido pelo codigo abaixo - Edson Rodrigues
			************************************************************************************************************************
			// Se Local 23, encontra NF original e verifica se eh 7% de ICMS. Caso afirmativo usa mensagem "023", caso contrario, usa "024".
			IF EMPTY(_citlocal)
			If SB1->B1_LOCPAD == "23"
			If SD1->D1_PICM == 7
			_cMensag := "023"
			Else
			_cMensag := "024"
			Endif
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			If _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			Endif
			// Se Local = 10 e TES 715 sair com Transp:024 e Mens. Padrใo: 002 --> Edson Rodrigues 29/05/09
			If SB1->B1_LOCPAD == "10" .and. cTes == AllTrim(GetMV("MV_TESSAIM"))
			_cMensag := "002"  //alterado de 006 para 002, conf Carlos Souza em 17/02/09
			_ctransp := "024"
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			if _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			if _nPostran > 0
			_aCabSC5[_nPostran,2] := _ctransp
			Endif
			// Se Local = 10 e TES 727 sair com Transp:024 e Mens. Padrใo: 007 --> Edson Rodrigues 29/05/09 - Conforme E-mail Carlos
			ElseIf  SB1->B1_LOCPAD == "10" .and. cTes == "727"
			_cMensag := "007"  //alterado de 006 para 002, conf Carlos Souza em 17/02/09
			_ctransp := "024"
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			if _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			if _nPostran > 0
			_aCabSC5[_nPostran,2] := _ctransp
			Endif
			
			ElseIf SB1->B1_LOCPAD =="11" .and. (cAliasTop5)->ZZ4_CODCLI =="000680"
			_cMensag  := "002"
			_ctransp  := "024"
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			if _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			if _nPostran > 0
			_aCabSC5[_nPostran,2] := _ctransp
			Endif
			Endif
			Else
			If _citLocal == "23"
			If SD1->D1_PICM == 7
			_cMensag := "023"
			Else
			_cMensag := "024"
			Endif
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			
			
			If _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			
			// Se Local = 10 e TES 715 sair com Transp:003 e Mens. Padrใo: 006 --> Edson Rodrigues 17/01/08
			ElseIf _citLocal == "10" .and. cTes == AllTrim(GetMV("MV_TESSAIM"))
			_cMensag := "002"  //alterado de 006 para 002, conf Carlos Souza em 17/02/09
			_ctransp := "024"  //alterado de 003 para 024, conr Carlos Souza em 29/05/09
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			if _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			if _nPostran > 0
			_aCabSC5[_nPostran,2] := _ctransp
			Endif
			// Se Local = 10 e TES 729 sair com Transp:024 e Mens. Padrใo: 007 --> Edson Rodrigues 29/05/09 - Conforme E-mail Carlos
			ElseIf _citLocal == "10" .and. cTes == AllTrim(GetMV("MV_TESUSAN")) //Parametro Definido a TES 729 - Enio 05/03/09
			_cMensag  := "007"
			_ctransp  := "024"
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			if _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			if _nPostran > 0
			_aCabSC5[_nPostran,2] := _ctransp
			Endif
			ElseIf _citLocal == "11" .and. (cAliasTop5)->ZZ4_CODCLI =="000680" .and. !cTes == AllTrim(GetMV("MV_TESUSAN")) //Parametro Definido a TES 729 - Enio 22/04/09
			_cMensag  := "002"
			_ctransp  := "024"
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			if _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			if _nPostran > 0
			_aCabSC5[_nPostran,2] := _ctransp
			Endif
			ElseIf _citLocal == "11" .and. (cAliasTop5)->ZZ4_CODCLI =="000680" .and. cTes == AllTrim(GetMV("MV_TESUSAN")) //Parametro Definido a TES 729 - Enio 22/04/09
			_cMensag  := "007"
			_ctransp  := "024"
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			if _nPosMens > 0
			_aCabSC5[_nPosMens,2] := _cMensag
			Endif
			if _nPostran > 0
			_aCabSC5[_nPostran,2] := _ctransp
			Endif
			
			Elseif  	_citlocal $ "22/26/27"
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			_nPosdivn := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_DIVNEG" })
			
			If _nPosMens > 0
			_aCabSC5[_nPosMens,2] := SA1->A1_MENSAGE
			Endif
			If _nPostran > 0
			_aCabSC5[_nPostran,2] := SA1->A1_TRANSP
			Endif
			If _nPosdivn > 0
			_aCabSC5[_nPosdivn,2] := "03"
			Endif
			
			Elseif  _lrotaut
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			If _nPostran > 0
			_aCabSC5[_nPostran,2] := "03"
			Endif
			
			Elseif  _citlocal $ "10/11"
			_nPosdivn := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_DIVNEG" })
			If _nPosdivn > 0
			_aCabSC5[_nPosdivn,2] := "04"
			Endif
			
			Elseif !_lrotaut .AND. !_citlocal $ "10/11/22/27/26"
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPosdivn := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_DIVNEG" })
			
			If _nPosMens > 0
			_aCabSC5[_nPosMens,2] := ""
			Endif
			If _nPostran > 0
			_aCabSC5[_nPostran,2] := ""
			Endif
			If _nPosdivn > 0
			_aCabSC5[_nPosdivn,2] := "09"
			Endif
			Endif
			Endif
			***************************************************************************************************************
			*/// Substituido o bloco de codigo acima por esse abaixo - Edson Rodrigues - 14/04/10
			_citlocal:=IIF(empty(_citlocal),IIF(EMPTY(_carmzen),SB1->B1_LOCPAD,LEFT(_carmzen,2)),_citlocal)
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPosdivn := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_DIVNEG" })
			
			//Faz algumas validacoes conforme regras acima - Edson 14/04/10
			If SD1->D1_PICM == 7 .AND. _citlocal=="23" .AND. _aCabSC5[_nPosMens,2]<>"023"
				_aCabSC5[_nPosMens,2]:="023"
				
			ElseIf SD1->D1_PICM <> 7 .AND. _citlocal=="23" .AND. _aCabSC5[_nPosMens,2]<>"024"
				_aCabSC5[_nPosMens,2]:="024"
				
			ElseIf _citLocal == "10" .and. cTes == AllTrim(GetMV("MV_TESSAIM")) .AND. (_aCabSC5[_nPosMens,2]<>"002" .OR. _aCabSC5[_nPostran,2]<>"56")
				_aCabSC5[_nPosMens,2]:="002"
				_aCabSC5[_nPostran,2]:="56"
				
			ElseIf _citLocal == "10" .and. cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. (_aCabSC5[_nPosMens,2]<>"007" .OR. _aCabSC5[_nPostran,2]<>"56")
				_aCabSC5[_nPosMens,2]:="007"
				_aCabSC5[_nPostran,2]:="56"
				
		  //ElseIf _citLocal == "11" .and. !cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. (cAliasTop5)->ZZ4_CODCLI =="000680" .and. (_aCabSC5[_nPosMens,2]<>"002" .OR. _aCabSC5[_nPostran,2]<>"56")
		    ElseIf _citLocal == "11" .and. !cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. (cAliasTop5)->ZZ4_CODCLI $ Alltrim(cNextRj) .and. (_aCabSC5[_nPosMens,2]<>"002" .OR. _aCabSC5[_nPostran,2]<>"56")
				_aCabSC5[_nPosMens,2]:="002"
				_aCabSC5[_nPostran,2]:="56"
				
		  //ElseIf _citLocal == "11" .and.  cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. (cAliasTop5)->ZZ4_CODCLI =="000680" .and. (_aCabSC5[_nPosMens,2]<>"007" .OR. _aCabSC5[_nPostran,2]<>"56")
			ElseIf _citLocal == "11" .and.  cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. (cAliasTop5)->ZZ4_CODCLI $ Alltrim(cNextRj) .and. (_aCabSC5[_nPosMens,2]<>"007" .OR. _aCabSC5[_nPostran,2]<>"56")
				_aCabSC5[_nPosMens,2]:="007"
				_aCabSC5[_nPostran,2]:="56"
			Endif
			
			
			//**********************************************
			//          Gera Arquivo TXT para Nextel       *
			//**********************************************
			//cLinha := (cAliasTop5)->ZZ4_IMEI+LFRC
			//FWRITE(HANDLE, cLinha)
			//FSEEK(HANDLE,0,1) 
			
			If Alltrim(_cGePeca) == "S" .AND. EMPTY((cAliasTop5)->ZZO_NUMCX)
				Processa({|| ADDPECA(@_aIteSC6,@cItens)	}, "Processando Pe็as...")
			Endif
			
			(cAliasTop5)->(dbSkip())
			
			If !lRf //Implantacao Radio Frequencia
				IncProc()
			Endif
			
			nITCham++
			nContIt++
			_nConIMEI++                                                                                                                                    
			
		Endif
	EndDo
	
	aKit := {}
	_cNumOS := ""
	If Alltrim(_cSepEnt)=="S"
		For i:=1 To Len(_aIteSC6)
			_nPosAces := aScan(aKit, { |X| X[1] == "*"+_aIteSC6[i,2,2] })
			If _nPosAces  > 0
				aKit[_nPosAces,2] += 1
			Else
				AADD(aKit,{"*"+_aIteSC6[i,2,2],1})
			Endif			
		Next i
	Else
		For i:=1 To Len(_aIteSC6)
			If !Empty(_aIteSC6[i,8,2])
				_cNumOS := IIF(Empty(_cNumOS),Left(_aIteSC6[i,8,2],6),_cNumOS+";"+Left(_aIteSC6[i,8,2],6))
			Endif
		Next i
		If !Empty(_cNumOS)
			cQuery := " SELECT COUNT(1) AS QTDAC "
			cQuery += " FROM "+ RETSQLNAME("SZ9")+" SZ9 (nolock) "
			cQuery += " WHERE Z9_FILIAL = '"+xFilial("SZ9")+"' AND "
			cQuery += " Z9_NUMOS IN "+FormatIn(_cNumOS,";")+" AND "
			cQuery += " Z9_SYSORIG = '3' AND "
			cQuery += " SZ9.D_E_L_E_T_ = '' "
			
			TCQUERY cQUERY NEW ALIAS "QRY"
			
			dbSelectArea("QRY")
			QRY->(dbGoTop())
			If QRY->QTDAC > 0
				AADD(aKit,{"ACES",nContIt})
			Endif
			QRY->(dbCloseArea())
		Endif
				
		If !Empty(cKit) .and. Len(aKit)==0
			AADD(aKit,{cKit,nContIt})		
		Endif
	Endif

	
	//cKit	  := IIF(Alltrim(_cSepEnt)=="S","*"+_cCodPro,cKit)//Conforme solicita็ใo do Enio para opera็ใo P03 - Luciano 28/06
	
	//Verifica se for um pedido de kit, gravar demais produtos que constam na estrutura desse item
	//If !Empty(ckit) 
	For nKit:=1 To Len(aKit)	
		If select("QRY") > 0
			QRY->(dbCloseArea())
		Endif       
		
		If Empty(_cNumOS)
		dbSelectArea("SG1")
		// Ordena a tabela no indice mais proximo que sera executada a query - Edson Rodrigues 14/04/10
		cQuery := "SELECT G1_COD, G1_COMP, G1_QUANT, B1_UM, B1_LOCPAD, B1_DESC, B1_PRV1 "
		cQuery += "FROM "+ RETSQLNAME("SG1")+" SG1 (nolock) ,"
		cQuery += RETSQLNAME("SB1") + " SB1 (nolock) "
		cQuery += "WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' AND "
		cQuery += "      SG1.G1_COD = '" + aKit[nKit,1] +"'   AND "
		cQuery += "      SG1.G1_COMP <> '"+_cCodPro+"' AND "
			cQuery += "      SG1.D_E_L_E_T_ = ''    AND "
		cQuery += "      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
		cQuery += "      SB1.B1_COD = SG1.G1_COMP AND "
			cQuery += "      SB1.D_E_L_E_T_ = ''"
			

		Else
			cQuery := "SELECT Z9_PARTNR G1_COMP, B1_UM, B1_LOCPAD, B1_DESC, B1_PRV1,SUM(Z9_QTY) AS QTDAC "
			cQuery += "FROM "+ RETSQLNAME("SZ9")+" SZ9 (nolock) ,"
			cQuery += RETSQLNAME("SB1") + " SB1 (nolock) "
			cQuery += "WHERE SZ9.Z9_FILIAL = '"+xFilial("SZ9")+"' AND "
			cQuery += "      SZ9.Z9_NUMOS IN "+FormatIn(_cNumOS,";")+" AND "
			cQuery += "      SZ9.Z9_SYSORIG='3' AND "
			cQuery += "      SZ9.D_E_L_E_T_ = ''    AND "
			cQuery += "      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
			cQuery += "      SB1.B1_COD = SZ9.Z9_PARTNR AND "
			cQuery += "      SB1.D_E_L_E_T_ = ''"
			cQuery += "GROUP BY Z9_PARTNR, B1_UM, B1_LOCPAD, B1_DESC, B1_PRV1 "
				
		Endif
		
		TCQUERY cQUERY NEW ALIAS "QRY"
		
		
		_lAchb6kit := .f.
		dbSelectArea("QRY")
		QRY->(dbGoTop())
		While QRY->(!Eof())
			
			nItens     := IIF(EMPTY(_cNumOS),aKit[nKit,2],QRY->QTDAC)
			cItens     := Soma1(cItens,2)
			nItkit     := 0
			_ccompon   :=QRY->G1_COMP
			_cproddesc :=QRY->B1_DESC
			_lqrypdalt :=.f.
			if select("P3") > 0
				P3->(dbCloseArea())
			Endif
			
			// Ordenado a tabela no indice mais proximo e colocado campos fixos para que query fique um pouco mais rapida - Edson Rodrigues 14/04/10
			dbSelectArea("SB6")
			SB6->(dbSetOrder(1)) //B6_FILIAL + B6_PRODUTO + B6_CLIFOR + B6_LOJA + B6_IDENT
			
			_cQryP3 := " SELECT B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT "
			_cQryP3 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
			_cQryP3 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
			_cQryP3 += "        B6_PRODUTO = '"+_ccompon+"' AND "
			_cQryP3 += "        B6_CLIFOR  = '"+left(cChaveOS,6)+"' AND "
			_cQryP3 += "        B6_LOJA    = '"+substr(cChaveOS,7,2)+"' AND "
			If Alltrim(_cSepEnt) == "S"
				_cQryP3 += "        B6_DOC    = '"+substr(cChaveOS,9,9)+"' AND "
				_cQryP3 += "        B6_SERIE   = '"+substr(cChaveOS,18,3)+"' AND "
			Endif
			//If left(cChaveOS,6)=="000016" Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
			If left(cChaveOS,6) $ Alltrim(cNextSp)
				_cQryP3 += "        B6_LOCAL  = '10' AND "
			//ElseIf left(cChaveOS,6)=="000680"
			ElseIf left(cChaveOS,6) $ Alltrim(cNextRj)
				_cQryP3 += "        B6_LOCAL  = '11' AND "
			Endif			
			_cQryP3 += "        B6_SALDO >= CAST('"+alltrim(str(nItens))+"' AS NUMERIC) AND "   //_cQryP3 += "        B6_SALDO  <> 0 AND "
			_cQryP3 += "        B6.D_E_L_E_T_ = '' "
			_cQryP3 += " ORDER BY B6_IDENT DESC "
			TCQUERY _cQryP3 NEW ALIAS "P3"
			P3->(dbGoTop())
			
			
			
			//Acrescentao IF para buscar o poduto saldo pelo produto alternativo conforme  Carlos Rocha - 12/07/10
			IF !select("P3") > 0
				IF P3->(Eof()) .and. empty(P3->B6_IDENT)
					_cprodalt  :=Posicione("SB1",1,xFilial("SB1") + QRY->G1_COMP, "B1_ALTER")
					_ccompon   :=_cprodalt
			    	_cproddesc :=Posicione("SB1",1,xFilial("SB1") + _ccompon, "B1_DESC")
					_lqrypdalt :=.T.
					
					
					_cQryP3 := " SELECT B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT "
					_cQryP3 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
					_cQryP3 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
					_cQryP3 += "        B6_PRODUTO = '"+_cprodalt+"' AND "
					_cQryP3 += "        B6_CLIFOR  = '"+left(cChaveOS,6)+"' AND "
					_cQryP3 += "        B6_LOJA    = '"+substr(cChaveOS,7,2)+"' AND "
					If Alltrim(_cSepEnt) == "S"
						_cQryP3 += "        B6_DOC    = '"+substr(cChaveOS,9,9)+"' AND "
						_cQryP3 += "        B6_SERIE   = '"+substr(cChaveOS,18,3)+"' AND "
					Endif
															
					_cQryP3 += "        B6_SALDO >= CAST('"+alltrim(str(nItens))+"' AS NUMERIC) AND "   //_cQryP3 += "        B6_SALDO  <> 0 AND "
					_cQryP3 += "        B6.D_E_L_E_T_ = '' "
					_cQryP3 += " ORDER BY B6_IDENT DESC "
					TCQUERY _cQryP3 NEW ALIAS "P3"
					P3->(dbGoTop())
				Endif
			Endif
			
			_nSaldo := nItens


		    // Verifica primeiro a matriz de saldos de terceiros // Edson Rodrigues
    			  _nPostkit := aScan(aB6KIT, { |X| X[1] == _ccompon })
			  
			  if _nPostkit  > 0 .and. aB6KIT[_nPostkit,2] >= 1
					_lAchb6kit := .t.
			  Endif			
			
			// Pega a NF de Terceiros mais recente, conforme definicao da Sra. Denilza
			// Alterado por M.Munhoz - ERP PLUS - 24/09/07
			While P3->(!Eof()) .and. _nSaldo > 0
			

				
				_nSalP3  := SalDisP3(P3->B6_IDENT, P3->B6_SALDO)
				_nSalP3  := _nSalP3-iif(_lAchb6kit,aB6KIT[_nPostkit,2],0)
				_nQtRet3 := iif(_nSalP3 >= _nSaldo, _nSaldo, _nSalP3)
				
				_cArmPSP := GetMv("MV_XARMPSP",.F.,"1S")
				_cArmPRJ := GetMv("MV_XARMPRJ",.F.,"1R")
				_cEndKit := ""
			  // Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
		      //_cArmKIT := IIF(left(cChaveOS,6)=="000016",_cArmPSP,IIF(left(cChaveOS,6)=="000680",_cArmPRJ,P3->B6_LOCAL))
				_cArmKIT := IIF(left(cChaveOS,6) $ Alltrim(cNextSp),_cArmPSP,IIF(left(cChaveOS,6)$ Alltrim(cNextRj),_cArmPRJ,P3->B6_LOCAL))
				If _cArmKIT==_cArmPSP .or. _cArmKIT==_cArmPRJ
					_cEndKit := GetMv("MV_XENDFAT",.F.,"FATURAR")
				Endif
								
				IF _nQtRet3 > 0
					
					_nSaldo  := _nSaldo - _nQtRet3
					_nPrcVen := A410Arred(P3->B6_PRUNIT,"C6_VALOR")
					_nValor  := A410Arred(P3->B6_PRUNIT * _nQtRet3,"C6_VALOR")
					// Alterado Edson Rodrigues 14/04/10
					//{"C6_QTDLIB"	,iif(SB1->B1_LOCPAD $ "22/26/27", _nQtRet3, 0),Nil},;
					Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens			        ,Nil},;
					{"C6_PRODUTO"	,_ccompon			 				    ,Nil},;
					{"C6_DESCRI"	,_cproddesc	 			   		        ,Nil},;
					{"C6_TES"		,cTes								    ,Nil},;
					{"C6_QTDVEN"	,_nQtRet3				  				,Nil},;
					{"C6_QTDLIB"	,iif(_clibPvS="S", _nQtRet3, 0)        ,Nil},;
					{"C6_NUMSERI"	,""										,Nil},;
					{"C6_NUMOS"		,""										,Nil},;
					{"C6_PRCVEN"	,_nPrcVen								,Nil},;
					{"C6_VALOR"		,_nValor			   					,Nil},;
					{"C6_PRUNIT"	,_nPrcVen								,Nil},;
					{"C6_NFORI"		,P3->B6_DOC								,Nil},;
					{"C6_SERIORI"	,P3->B6_SERIE							,Nil},;
					{"C6_ITEMORI"	,""										,Nil},;
					{"C6_IDENTB6"	,P3->B6_IDENT							,Nil},;
					{"C6_PRCCOMP"	,0										,Nil},;
					{"C6_LOCAL"		,_cArmKit								,Nil},;//P3->B6_LOCAL
					{"C6_ENTREG"	,dDataBase								,Nil},;
					{"C6_OSGVS"		,""										,Nil},;
					{"C6_AIMPGVS"	,""										,Nil},;
					{"C6_LOCALIZ"	,_cEndKit								,Nil} })
					
					
					cItens := Soma1(cItens,2) //Incluso pois repetia o mesmo item para o Kit, quando o mesmo se dividia no saldo - Edson Rodrigues 30/01/08.
					_ncItkit++
					nItkit++             
					
					//Adicionado valida็ใo de saldo para Kit - Edson Rodrigues - 21/06/12
					if _lAchb6kit
					   aB6KIT[_nPostkit,2]:=aB6KIT[_nPostkit,2]+_nQtRet3
					Else
					   AADD(aB6KIT,{_ccompon,_nQtRet3})
					Endif   
					
				Endif
				P3->(dbSkip())
			Enddo
			P3->(dbCloseArea())
			
			
			
			IF _nSaldo > 0 .AND. !_lqrypdalt
				_cprodalt  := Posicione("SB1",1,xFilial("SB1") + QRY->G1_COMP, "B1_ALTER")
				_ccompon   := _cprodalt
				_cproddesc := Posicione("SB1",1,xFilial("SB1") + _ccompon, "B1_DESC")
				_cclifor   := left(cChaveOS,6)
				_ccliloj   := substr(cChaveOS,7,2)
				_aprodalt  :={}
				_lqrypdalt :=.T.
				
				_aprodalt:=salp3alt(_cprodalt,_cclifor,_ccliloj,_nSaldo)
				
				IF len(_aprodalt) > 0
					For x:=1 to len(_aprodalt)
						_nSPaltp3 :=_aprodalt[x,5]
						_nSPaltp3 := _nSPaltp3-iif(_lAchb6kit,aB6KIT[_nPostkit,2],0)
						_nQtRet3 := iif(_nSPaltp3 >= _nSaldo, _nSaldo,_nSPaltp3)
						
						_cArmPSP := GetMv("MV_XARMPSP",.F.,"1S")
						_cArmPRJ := GetMv("MV_XARMPRJ",.F.,"1R")
						_cEndKit := ""
					  //Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
					  //_cArmKIT := IIF(left(cChaveOS,6)=="000016",_cArmPSP,IIF(left(cChaveOS,6)=="000680",_cArmPRJ,P3->B6_LOCAL))
						_cArmKIT := IIF(left(cChaveOS,6) $ Alltrim(cNextSp),_cArmPSP,IIF(left(cChaveOS,6)$ Alltrim(cNextRj),_cArmPRJ,P3->B6_LOCAL))
						If _cArmKIT==_cArmPSP .or. _cArmKIT==_cArmPRJ
							_cEndKit := GetMv("MV_XENDFAT",.F.,"FATURAR")
						Endif
																		
						IF _nQtRet3 > 0
							_nSaldo  := _nSaldo - _nQtRet3
							_nPrcVen := A410Arred(_aprodalt[x,6],"C6_VALOR")
							_nValor  := A410Arred(_aprodalt[x,6] * _nQtRet3,"C6_VALOR")
							// Alterado Edson Rodrigues 14/04/10
							//{"C6_QTDLIB"	,iif(SB1->B1_LOCPAD $ "22/26/27", _nQtRet3, 0),Nil},;
							Aadd(_aIteSC6,  {{"C6_ITEM" ,cItens			        ,Nil},;
							{"C6_PRODUTO"	,_ccompon			 				        ,Nil},;
							{"C6_DESCRI"	,_cproddesc	     			   		        ,Nil},;
							{"C6_TES"		,cTes								        ,Nil},;
							{"C6_QTDVEN"	,_nQtRet3		    		  				,Nil},;
							{"C6_QTDLIB"	,iif(_clibPvS="S", _nQtRet3, 0)            ,Nil},;
							{"C6_NUMSERI"	,""										    ,Nil},;
							{"C6_NUMOS"	,""										,Nil},;
							{"C6_PRCVEN"	,_nPrcVen						     		,Nil},;
							{"C6_VALOR"	,_nValor			   					    ,Nil},;
							{"C6_PRUNIT"	,_nPrcVen							    	,Nil},;
							{"C6_NFORI"	,_aprodalt[x,1] 						,Nil},;
							{"C6_SERIORI"	,_aprodalt[x,2]							    ,Nil},;
							{"C6_ITEMORI"	,""										    ,Nil},;
							{"C6_IDENTB6"	,_aprodalt[x,4]							    ,Nil},;
							{"C6_PRCCOMP"	,0										    ,Nil},;
							{"C6_LOCAL"		,_cArmKit       							,Nil},;//_aprodalt[x,3]
							{"C6_ENTREG"	,dDataBase								    ,Nil},;
							{"C6_OSGVS"		,""										,Nil},;
							{"C6_AIMPGVS"	,""										    ,Nil},;
							{"C6_LOCALIZ"	,_cEndKIT									,Nil} })
							
							cItens := Soma1(cItens,2) //Incluso pois repetia o mesmo item para o Kit, quando o mesmo se dividia no saldo - Edson Rodrigues 30/01/08.
							_ncItkit++
							nItkit++
							if _lAchb6kit
					            aB6KIT[_nPostkit,2]:=aB6KIT[_nPostkit,2]+_nQtRet3
					        Else
					           AADD(aB6KIT,{_ccompon,_nQtRet3})
					        Endif   
						Endif
					Next
				Else
					_nSaldo:=0
				Endif
			Endif
			dbSelectArea("QRY")
			QRY->(dbSkip())
		Enddo
		QRY->(dbCloseArea())
	Next nKit
	//Endif
	Begin Transaction //Alterado conforme solicita็ใo do Edson - 02/05/12 - Luciano Delta
	// Se existir cabec e itens, gera PV
	IF len(_aCabSC5) > 0 .and. len(_aIteSC6) > 0


//-------------------------------- INCLUSรO DO อTEM MรO DE OBRA SE OPERAวรO ESTIVER CONFIGURADA PARA ISSO

		if POSICIONE("ZZJ",1,xFilial("ZZJ")+_coperbgh, "ZZJ_INCMOB") == "S"   
            
			ALERT ("ESSA OPERAวรO ESTม CADASTRADA PARA TER A MAO DE OBRA INCLUIDA NO PEDIDO !!")

			_aMO := {}
			for xzx:= 1 to len(_aIteSC6)
					_loc := ascan(_aMO, {|x| x[1] == _aIteSC6[xzx][2][2]})
					if _loc > 0
						_aMO[_loc][2] ++
					Else				
						aadd(_aMO, {_aIteSC6[xzx][2][2], 1})							
					Endif		
			next xzx		
			
			_aMOB := {}
		 	for xzx := 1 to len(_aMO)
					_loc := ascan(_aMOB, {|x| x[1] == _aMO[xzx][1]})
					if _loc > 0
						_aMO[_loc][2] ++
					Else				     
						_cQuery := "	SELECT ZZP_VLRGAF "
						_cQuery += "	FROM ZZP020 AS ZZP "
						_cQuery += "	WHERE ZZP_FILIAL='"+xFilial("ZZP")+"'  AND ZZP.ZZP_MODELO = '" + POSICIONE("SB1",1,xFilial("SB1")+_aMO[xzx][1], "B1_MODELO" ) + "' "
						_cQuery += "	 	 AND ZZP.D_E_L_E_T_ = '' "
						TCQUERY _cQuery NEW ALIAS "TMPZZP"
					                                      
						if TMPZZP->ZZP_VLRGAF == 0
							ALERT ("ESSA OPERAวรO ENCONTROU ITENS NรO CADASTRADOS NA TABELA ZZP. ENTRE EM CONTATO COM O ADMINISTRADOR DO SISTEMA !!")
							Return
						Endif					                                              
						_cCodServico := POSICIONE("ZZJ",1,xFilial("ZZJ")+_coperbgh, "ZZJ_CODMOB")
						aadd(_aMOB, {_cCodServico, _aMO[xzx][2], TMPZZP->ZZP_VLRGAF, POSICIONE("SB1",1,xFilial("SB1")+_cCodServico, "B1_DESC" ), POSICIONE("SB1",1,xFilial("SB1")+_cCodServico, "B1_LOCPAD" )})							
						TMPZZP->(dbCloseArea())
					Endif		
			next xzx	
		
			for xzx := 1 to len(_aMOB)
			
				cItens := Soma1(cItens,2) 		
			
				Aadd(_aIteSC6,{	{"C6_ITEM"				,cItens  				,Nil},;
											{"C6_PRODUTO"	,	_aMOB[xzx][1] 	,Nil},;
											{"C6_DESCRI"	,		_aMOB[xzx][4] 	,Nil},;
											{"C6_TES"	,				POSICIONE("ZZJ",1,xFilial("ZZJ")+_coperbgh, "ZZJ_TESSER" )	    ,Nil},;
											{"C6_QTDVEN",			_aMOB[xzx][2] 	,Nil},;
											{"C6_QTDLIB",			_aMOB[xzx][2] 	,Nil},;
											{"C6_NUMSERI",		""	 					,Nil},;
											{"C6_NUMOS"	,		""	 					,Nil},;
											{"C6_PRCVEN"	,		_aMOB[xzx][3] ,Nil},;
											{"C6_VALOR"	,		_aMOB[xzx][3] * _aMOB[xzx][2]	,Nil},;
											{"C6_PRUNIT"	,		_aMOB[xzx][3] 	,Nil},;
											{"C6_NFORI"		,		""						,Nil},;
											{"C6_SERIORI"	,		""						,Nil},;
											{"C6_ITEMORI"	,		""						,Nil},;
											{"C6_IDENTB6"	,		""						,Nil},;
											{"C6_PRCCOMP"	,	0						,Nil},;
											{"C6_LOCAL"		,	_aMOB[xzx][5]	,Nil},;
											{"C6_ENTREG"	,		dDataBase		,Nil},;
											{"C6_OSGVS"		,	""						,Nil},;
											{"C6_AIMPGVS"	,	""						,Nil},;
											{	,							,Nil}})						
											
			next xzx
		
		Endif
		
//----------------------------------------------------------------------------------------------------------------------
		
		If !lRf //Implantacao Radio Frequencia
			//_lRet := u_geraPV(_aCabSC5, _aIteSC6, 3)  //Inclusao de novo PV    //Retirado para fixar abaixo gravacao do pedido no prg, 12/10/07 - Edson Rodrigues
			_lRet := .f.
			If _lRet
				aadd(aPedido,{SC5->C5_NUM,aB6KIT})
			   aadd(aPedZZQ,SC5->C5_NUM)			
				aB6KIT:={}
			Endif
		Else
			//_lRet := u_geraPV(_aCabSC5, _aIteSC6, 3, .T.)  //Inclusao de novo PV    //Retirado para fixar abaixo gravacao do pedido no prg, 12/10/07 - Edson Rodrigues
			_lRet := .f.
			If _lRet     
				If !lPVSwp    
				aadd(aPedido,{SC5->C5_NUM,aB6KIT})
				aadd(aPedZZQ,SC5->C5_NUM)						
				EndIf						
			    aB6KIT:={}
			Endif
		Endif
		
		// Se gerou erro no PV pela rotina padrao, forca a gravacao pelo RECLOCK, cfe exigido pela BGH em 15/10/2007 - M.Munhoz
		if !_lRet
			_lRet:=.t.
			
			//**********************************************
			//          Geracao dos Cabecalhos             *
			//**********************************************
			If Alltrim(_aCabSC5[ 1,2]) <> "B"
			 
				SA1->(DBSeek(xFilial("SA1")+_aCabSC5[2,2]+_aCabSC5[3,2]))
				_cCFIni := "0"
				If Subs(SA1->A1_EST,1,2) == "EX"
					_cCFIni := "7"
				ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
					_cCFIni := "6"
				Else
					_cCFIni := "5"
				Endif
				
			Else
				dbSelectArea("SA2")
				dbSetOrder(1)
				SA2->(DBSeek(xFilial("SA2")+_aCabSC5[2,2]+_aCabSC5[3,2]))
				
				_cCFIni := "0"
				If Subs(SA2->A2_EST,1,2) == "EX"
					_cCFIni := "7"
				ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA2->A2_EST)
					_cCFIni := "6"
				Else
					_cCFIni := "5"
				Endif
			Endif
								
			cNrPV:= GetSxeNum("SC5","C5_NUM")
			If _lRet
				If !lPVSwp
				aadd(aPedido,{cNrPV,aB6KIT})			
				aadd(aPedZZQ,cNrPV)			
				EndIf			
			Endif
			RecLock("SC5",.T.)
			SC5->C5_FILIAL  := xFilial("SC5")
			SC5->C5_NUM     := cNrPV
			SC5->C5_TIPO    := _aCabSC5[ 1,2]//"N" //Normal
			SC5->C5_CLIENTE := cCliente
			SC5->C5_LOJACLI := cLoja
			SC5->C5_CLIENT  := cCliente
			SC5->C5_LOJAENT := cLoja
			SC5->C5_TIPOCLI := "F"   //Consumidor Final
			SC5->C5_CONDPAG := "001" //A VISTA
			SC5->C5_EMISSAO := dDatabase
			SC5->C5_MOEDA   := 1
			SC5->C5_TIPLIB  := "1"   //Liberacao por Pedido
			SC5->C5_TPCARGA := "2"
			SC5->C5_TXMOEDA := 1
			SC5->C5_B_KIT   := _aCabSC5[ 9,2]
			SC5->C5_XUSER   := _aCabSC5[10,2]
			SC5->C5_TRANSP  := _aCabSC5[11,2]
			SC5->C5_MENPAD  := _aCabSC5[12,2]
			SC5->C5_DIVNEG  := _aCabSC5[13,2]
			SC5->C5_MENNOTA := _aCabSC5[14,2]
			MsUnLock("SC5")
			ConfirmSX8()
			
			//**********************************************
			//          Geracao dos Itens                  *
			//**********************************************
			for nX := 1 to len(_aIteSC6)
				SB1->(DBSeek(xFilial("SB1")+_aIteSC6[nX,2,2]))
				SF4->(DBSeek(xFilial("SF4")+_aIteSC6[nX,4,2]))
				RecLock("SC6",.T.)
				SC6->C6_FILIAL := xFilial("SC6")
				SC6->C6_NUM    := cNrPV
				SC6->C6_ITEM   := _aIteSC6[nX,1,2]
				SC6->C6_PRODUTO:= _aIteSC6[nX,2,2]
				SC6->C6_UM     := SB1->B1_UM
				SC6->C6_QTDVEN := _aIteSC6[nX,5,2]
				SC6->C6_PRCVEN := _aIteSC6[nX,9,2]
				SC6->C6_VALOR  := _aIteSC6[nX,10,2]
				// SC6->C6_QTDEMP := 1
				SC6->C6_TES    := _aIteSC6[nX,4,2]
				SC6->C6_LOCAL  := _aIteSC6[nX,17,2]
				SC6->C6_LOCALIZ:= _aIteSC6[nX,21,2]
				SC6->C6_CF     := AllTrim(_cCFIni)+Subs(SF4->F4_CF,2,3)
				SC6->C6_ENTREG := dDataBase
				SC6->C6_DESCRI := SB1->B1_DESC
				SC6->C6_PRUNIT := 0.00
				SC6->C6_NFORI  := _aIteSC6[nX,12,2]
				SC6->C6_SERIORI:= _aIteSC6[nX,13,2]
				SC6->C6_ITEMORI:= _aIteSC6[nX,14,2]
				SC6->C6_NUMSERI:= _aIteSC6[nX,7,2]
				SC6->C6_TPOP   := "F" //FIRME
				SC6->C6_CLI    := _aCabSC5[2,2]
				SC6->C6_LOJA   := _aCabSC5[3,2]
				SC6->C6_IDENTB6:= _aIteSC6[nX,15,2]
				SC6->C6_PRCCOMP:= _aIteSC6[nX,16,2]
				SC6->C6_NUMOS  := _aIteSC6[nX,8,2]
				MsUnLock("SC6")
				If _clibPvS="S"//libera item do pedido de venda
					MaLibDoFat(SC6->(RECNO()),_aIteSC6[nX,5,2],@.T.,@.T.,.F.,.F.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,NIL,_aIteSC6[nX,5,2])
				Endif
			next nX
			If !lRf //Implanta็ใo Radio Frequencia - 11/10/2011
			    aB6KIT:={}
				//apMsgInfo("Tentativa OK !. Pedido gerado com sucesso.")
			Else          
			    aB6KIT:={}
				VTBEEP(3)
				VTAlert("Tentativa OK !. Pedido gerado com sucesso.","Alerta",.t.,2500)
			Endif  
		Endif
		
	Endif
	If !_lRet
		If !lRf //Implanta็ใo Radio Frequencia - 11/10/2011
			ApMsgInfo("Nใo foi possํvel gerar o Pedido de Venda. Favor contatar o administrador do sistema.","Erro na gera็ใo do PV!")
		Else
			VTBEEP(3)
			VTAlert("Nใo foi possํvel gerar o Pedido de Venda. Favor contatar o administrador do sistema.","Erro na gera็ใo do PV!",.t.,2500)
		Endif
		_nConPED :=_nConPED-1
		_nConIMEI:=_nConIMEI-nContIt
		_ncItkit :=_ncItkit-nItkit
		//Loop Retirado loop // Edson Rodrigues 14/06/10
	Endif
	IF _lRet
		// Alimenta numero de serie e de OS no item do PV, ja que o msExecAuto nao esta fazendo isso
		// Atualiza outras tabelas do sistema, de acordo com os itens gerados pelo msExecAuto
		dbSelectArea("AB9")
		_aSavAB9 := GetArea()
		AB9->(dbOrderNickName("AB9SNOSCLI"))//dbSetOrder(7) //AB9_FILIAL+AB9_SN+AB9_NUMOS+AB9_CODCLI+AB9_LOJA
		For nX := 1 to len(_aIteSC6)
			If _lrotaut //Edson Rodrigues 15/12/08
				_cIMEI  := _aIteSC6[nX,7,2]
				_cIMEI  := AllTrim(_cIMEI)+ space(TamSX3("ZZ4_IMEI")[1]-len(AllTrim(_cIMEI)))
				_cOSab9 := SUBSTR(_aIteSC6[nX,8,2],1,8)
				ctes    := IIF(funname() $ "BESTQPED/TECAX033",ctes,"727")
				if AB9->(dbSeek(xFilial("AB9") +_cIMEI+left(_cOSab9,6)))
					While  !AB9->(Eof()) .and. AB9->AB9_FILIAL == xFilial("AB9") .and. AB9->AB9_SN == _cIMEI .and. ;
						left(AB9->AB9_NUMOS,6) == left(_cOSab9,6)
						If AB9->AB9_TIPO == "1"  // Atendimento da OS Encerrado
							If EMPTY(AB9->AB9_NOVOSN)
								ctes:=IIF(funname() $ "BESTQPED/TECAX033",ctes,"727")
							Else
								ctes:=IIF(funname() $ "BESTQPED/TECAX033",ctes,"735")
							Endif
						Endif
						AB9->(dbSkip())
					Enddo
				Endif
			Endif
			// Atualiza SC6 com numero de serie e OS
			dbSelectArea("SC6")
			_aSavSC6 := GetArea()
			dbSetOrder(1)
			If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM + _aIteSC6[nX,1,2] )) .and. (!empty(_aIteSC6[nX,7,2]) .or. !empty(_aIteSC6[nX,8,2]) )
				reclock("SC6",.f.)
				SC6->C6_NUMSERI := _aIteSC6[nX,7,2]
				SC6->C6_NUMOS   := _aIteSC6[nX,8,2]
				SC6->C6_TES     :=	ctes
				msunlock()
				// Alimenta OS com Pedido Gerado apenas em caso de sucesso na geracao do PV
				//				If AB7->(!dbSeek(xFilial("AB7")+(cAliasTop5)->(ZZ4_OS+ZZ4_IMEI)))
				If AB7->(dbSeek(xFilial("AB7")+ left(_aIteSC6[nX,8,2],6) + _aIteSC6[nX,7,2]))
					RecLock("AB7",.F.)
					AB7->AB7_TIPO	:=	"2" //Pedido Gerado
					MsUnLock("AB7")
				Endif
				//**********************************************
				//          Flag da Saida Massiva              *
				//**********************************************
				dbSelectArea("ZZ4")
				_aSavZZ4 := GetArea()
				dbSetOrder(1)  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
				
				If ZZ4->(dbSeek(xFilial("ZZ4") + _aIteSC6[nX,7,2] + left(_aIteSC6[nX,8,2],8) )) .and. Empty(ZZ4->ZZ4_PV)
					// Adicionado para solucao da gravacao do item reincidente. (11/05/05) Nicoletti
					//				While ZZ4->(!Eof()) .and. ZZ4->ZZ4_CODCLI == SC5->C5_CLIENTE .and. ;
					//					ZZ4->ZZ4_LOJA == SC5->C5_LOJACLI .and. ZZ4->ZZ4_CODPRO == SC6->C6_PRODUTO .and. ZZ4->ZZ4_IMEI == _aIteSC6[nX,7,2]
					
					//					If Empty(ZZ4->ZZ4_PV)
					// Checar a ultima saida massiva para grava o ZZ4 pv.. quando o Pv = branco e o confirm = s
					RecLock("ZZ4",.F.)
					ZZ4->ZZ4_PV     := SC5->C5_NUM + SC6->C6_ITEM
					ZZ4->ZZ4_STATUS := "8"  // PV Gerado
					If !EMPTY(SC5->C5_B_KIT) .AND. EMPTY(ZZ4->ZZ4_CODKIT)
						ZZ4->ZZ4_CODKIT := SC5->C5_B_KIT
					Endif
					MsUnLock("ZZ4")
					//					Endif
					//					ZZ4->(DbSkip())
					//				EndDo
				Endif
				dbSelectArea("SC9")
				_aSavSC9 := GetArea()
				dbSetOrder(1)  // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
				If SC9->(dbSeek(xFilial("SC9") + SC5->C5_NUM + _aIteSC6[nX,1,2] ))
					reclock("SC9",.f.)
					SC9->C9_XTES := ctes
					msunlock()
				Endif
				RestArea(_aSavZZ4)
				RestArea(_aSavSC6)
				RestArea(_aSavAB9)
				RestArea(_aSavSC9)
			Endif
		Next nX
		If !lPVSwp
		If _cgerapvpc=="S"    //V๊ se gera pe็a - Edson Rodrigues 20/03/10
			gerapeca(_aIteSC6)
		Endif
		EndIf		
	Endif
	End Transaction//Alterado conforme solicita็ใo do Edson - 02/05/12 - Luciano Delta
EndDo
FCLOSE(HANDLE) //Fecha Arquivo TXT
//End Transaction
If len(_aitpcSC6) > 0
	gerapvpc(_aCabSC5,_aitpcSC6)
Endif
If Len(aPedZZQ) > 0 
	If _cGePeca == "S"
		Processa({|| GERAZZQ(aPedZZQ)}, "Atualizando tabela de Pecas...") 
	Endif
Endif
//Vinicius Leonardo - Delta Decisao
If Len(aZZQPec) > 0 
	If _cgerapvpc == "S" 
		Processa({|| GRPCZZQ(aZZQPec)}, "Atualizando tabela de Pecas...")
	EndIf
EndIf 

If lPVSwp
	If Len(aC5SwpCab) > 0 .and. Len(aC6SwpIt) > 0
		GrPVSwp(aC5SwpCab,aC6SwpIt,lRf)
	EndIf 
EndIf
//GERAR NF PARA PEDIDOS LIBERADOS	


If (_cgeraNF == "S" .and. _clibPvS == "S"  .and.  !lPVSwp) .OR.  (lPVSwp .and. cgernfsw $ "2/3") .OR. (lPVSwp .and. cgernfsw $ "1/3"  .AND. Len(aC5SwpCab) > 0 .and. Len(aC6SwpIt) > 0)
  
	If ApMsgYesNo("Deseja gerar NF?","Nota Fiscal")
		If _cAglPed == "S"
			If ApMsgYesNo("Aglutinar Pedidos?","Aglutinar Pedidos")
				_cAglPed := "S"
			Else
				_cAglPed := "N"
			Endif			
		Endif
		If Len(aPedido) > 0 
			GERANF(aPedido,_cAglPed, _cSepNfPC)
			//Imprime Etiqueta com as Notas Fiscais geradas - Luciano 03/05/12
			If len(aNFOK) > 0 .and. !lRf
				U_BGHETQNF(aNfOk,_cTesEtq,_cLayETQ)
			Endif	
		Endif
	Endif
Endif

If !lRf //Implanta็ใo Radio Frequencia - 11/10/2011
	If len(_aIteSC6) == 0
		//	Aviso("Pedidos de Venda","Nใo existe Pedido de venda gerado!",{"OK"})
	Elseif !_lRet .and. _nConPED=0
		Aviso("Pedidos Saida","Nใo foi possํvel gerar nenhum Pedidos de Saida!",{"OK"})
	Else
		If !_lrotaut //Edson Rodrigues 28/11/07  // 17//11/2008
			IF _ncItkit > 0
				Aviso("Pedidos Saida","Foram Gerados "+STRZERO(_nConPED,3)+" Pedidos de Saida e "+STRZERO(_nConIMEI,4)+" Imeis .",{"OK"})
			Else
				Aviso("Pedidos Saida","Foram Gerados "+STRZERO(_nConPED,3)+" Pedidos de Saida e "+STRZERO(_nConIMEI,4)+" Imeis e "+STRZERO(_ncItkit,3)+"  .",{"OK"})
			Endif
			IF _nqtdppec > 0 .and. _nqtditpc > 0
				Aviso("Pedidos Saida","Foram Gerados "+STRZERO(_nqtdppec,3)+" Pedidos de Saida e "+STRZERO(_nqtditpc,4)+" Pecas .",{"OK"})
			Endif
		Endif
	Endif
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMensagens para o coletor de dadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(_aIteSC6) == 0
		//	Aviso("Pedidos de Venda","Nใo existe Pedido de venda gerado!",{"OK"})
	ElseIf !_lRet .and. _nConPED=0
		VTBEEP(3)
		VTAlert("Nใo foi possํvel gerar nenhum Pedidos de Saida!","Pedidos Saida",.T.,2500)
	Else
		If !_lrotaut //Edson Rodrigues 28/11/07  // 17//11/2008
			IF _ncItkit > 0
				VTBEEP(3)
				VTAlert("Foram Gerados "+STRZERO(_nConPED,3)+" Pedidos de Saida e "+STRZERO(_nConIMEI,4)+" Imeis .!","Pedidos Saida",.T.,2500)
			Else
				VTBEEP(3)
				VTAlert("Foram Gerados "+STRZERO(_nConPED,3)+" Pedidos de Saida e "+STRZERO(_nConIMEI,4)+" Imeis e "+STRZERO(_ncItkit,3)+"  .","Pedidos Saida",.T.,2500)
			Endif
			IF _nqtdppec > 0 .and. _nqtditpc > 0
				VTBEEP(3)
				VTAlert("Foram Gerados "+STRZERO(_nqtdppec,3)+" Pedidos de Saida e "+STRZERO(_nqtditpc,4)+" Pecas .","Pedidos Saida",.T.,2500)
			Endif
		Endif
	Endif
Endif
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ GrPVSwp   ณ Autor ณ Vinicius Leonardo   ณ Data ณ 01/06/15  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera PV para cliente final, quando SWAP			           ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GrPVSwp(aC5SwpCab,aC6SwpIt,lRf)

Local aArea   := GetArea()
Local nPosCli := Ascan( aC5SwpCab ,{ |x| x[1] == "C5_CLIENTE" })
Local nPosLoj := Ascan( aC5SwpCab ,{ |x| x[1] == "C5_LOJACLI" })  
Local nPsELoj := Ascan( aC5SwpCab ,{ |x| x[1] == "C5_LOJAENT" }) 
Local nPsmNF  := Ascan( aC5SwpCab ,{ |x| x[1] == "C5_MENNOTA" })
Local nPsPad  := Ascan( aC5SwpCab ,{ |x| x[1] == "C5_MENPAD" })
Local cTesOp  := Posicione("ZZJ",1,xFilial("ZZJ") + cSwpOp, "ZZJ_TESSWP") 
Local cLocal  := Posicione("ZZJ",1,xFilial("ZZJ") + cSwpOp, "ZZJ_ARMSWP")
Local cEnder  := Posicione("ZZJ",1,xFilial("ZZJ") + cSwpOp, "ZZJ_ENDSWP")
Local _cAlias := GetNextAlias()
Local lvldsld := .t.
Local cItens  := "00" 
Local cCliEnd := "" 
Local cLojEnd := ""

If Select("SBE") == 0
	DbSelectArea("SBE")
EndIf
SBE->(DbSetOrder(1))
SBE->(DbGoTop())

If Select("SB1") == 0
	dbSelectArea("SB1")
EndIf
SB1->(dbSetOrder(1))

If Select("SB2") == 0
	dbSelectArea("SB2")
EndIf
SB2->(dbSetOrder(1))

If Select("SA1") == 0
	DbSelectArea("SA1")
EndIf
SA1->(DbSetOrder(1))
SA1->(DbGoTop())

If SBE->(DbSeek(xFilial("SBE")+cLocal+cEnder))	

	aC5SwpCab[nPosCli,2] := cZZ4Cli 
	aC5SwpCab[nPosLoj,2] := cZZ4LjCl 
	aC5SwpCab[nPsELoj,2] := cZZ4LjCl 
	
	If SA1->(DbSeek(xFilial("SA1")+cZZ4Cli+cZZ4LjCl))	
		If SA1->A1_PESSOA == "J" .and. Len(SA1->A1_CGC) > 11 
			If !Empty(SA1->A1_INSCR) .and. !(Upper(Alltrim(SA1->A1_INSCR)) $ 'ISENTO;ISENTA') 
				cTesOp := "905"	
			EndIf	
		EndIf	
	EndIf	
	
	aC5SwpCab[nPsmNF,2]  := cMsgNF	
	cMsgNF := ""
	aC5SwpCab[nPsPad,2]  := Posicione("SF4",1,xFilial("SF4") + cTesOp, "F4_FORMULA") 	
	
	cCliEnd := SubStr(SBE->BE_CLP3SW,1,6) 
	cLojEnd := SubStr(SBE->BE_CLP3SW,7,2)

	For nx:= 1 To Len(aC6SwpIt)
		
		cmodNovo := ""
		If Len(aImNovo) > 0 
			For ny:=1 To Len(aImNovo)					
				If aC6SwpIt[nx,23,2] == aImNovo[ny][1] 
					cmodNovo := aImNovo[ny][2]
				EndIf
			Next ny
		EndIf		
		If Posicione("SF4",1,xFilial("SF4") + cTesOp, "F4_PODER3") <> "N" 
			nSaldo := aC6SwpIt[nx,5,2]			
			cQuery := " SELECT B6_PRODUTO,B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT,D1_ITEM " + CRLF
			cQuery += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) " + CRLF
			cQuery += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 (nolock) "  + CRLF
			cQuery += " ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD=B6_CLIFOR AND A1_LOJA=B6_LOJA " + CRLF
			cQuery += " AND SA1.D_E_L_E_T_='' " + CRLF
			cQuery += " INNER JOIN "+RetSqlName("SD1")+" AS SD1 (nolock) "  + CRLF
			cQuery += " ON D1_FILIAL = '"+xFilial("SD1")+"' AND D1_COD=B6_PRODUTO AND D1_FORNECE=B6_CLIFOR " + CRLF
			cQuery += " AND D1_LOJA=B6_LOJA  AND D1_DOC=B6_DOC AND D1_SERIE=B6_SERIE AND D1_IDENTB6=B6_IDENT  AND SD1.D_E_L_E_T_='' " + CRLF			
			cQuery += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND " + CRLF
			cQuery += "        (B6_PRODUTO = '"+cmodNovo+"-S' OR B6_PRODUTO = '"+cmodNovo+"') AND " + CRLF
			cQuery += "        B6_SALDO > 0 AND "  + CRLF
			cQuery += " B6_LOCAL ='"+cLocal+"' AND "     + CRLF
			cQuery += " B6.D_E_L_E_T_ = '' AND " + CRLF
			cQuery += " SA1.A1_COD = '" + cCliEnd + "' AND SA1.A1_LOJA = '" + cLojEnd + "' "  + CRLF
			cQuery += " ORDER BY B6_IDENT "    
			
			cQuery := ChangeQuery(cQuery)  
			
			If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
			dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
			( _cAlias )->( dbGoTop() )
			
			If ( _cAlias )->( !Eof() )
				While ( _cAlias )->( !Eof() ) 
					nSalP3  := SalDisP3(( _cAlias )->B6_IDENT, ( _cAlias )->B6_SALDO)
					nQtRet3 := iif(nSalP3 >= nSaldo, nSaldo, nSalP3)
					IF nQtRet3 > 0
						cItens   := Soma1(cItens,2)
						nSaldo  := nSaldo - nQtRet3
						nPrcVen := Round(A410Arred(( _cAlias )->B6_PRUNIT,"C6_VALOR"),2)
						nValor  := Round(A410Arred(( _cAlias )->B6_PRUNIT * nQtRet3,"C6_VALOR"),2)			
						SB1->(DbGoTop())
						SB1->(dbSeek(xFilial("SB1")+( _cAlias )->B6_PRODUTO))
						SB2->(DbGoTop())
						SB2->(DBSeek(xFilial("SB2") + SB1->B1_COD + cLocal))
						nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
						nSaldoBF := 0
						nSaldoBF :=  SaldoSBF(cLocal, cEnder, SB1->B1_COD, NIL, NIL, NIL, .F.)						
                         
                        aC6SwpIt[nx,2,2]  := SB1->B1_COD
                        aC6SwpIt[nx,3,2]  := SB1->B1_DESC
                        aC6SwpIt[nx,4,2]  := cTesOp
                        aC6SwpIt[nx,7,2]  := ""
                        aC6SwpIt[nx,9,2]  := nPrcVen
                        aC6SwpIt[nx,10,2] := nValor
                        aC6SwpIt[nx,12,2] := ( _cAlias )->B6_DOC
                        aC6SwpIt[nx,13,2] := ( _cAlias )->B6_SERIE
                        aC6SwpIt[nx,14,2] := ( _cAlias )->D1_ITEM
                        aC6SwpIt[nx,15,2] := ( _cAlias )->B6_IDENT
                        aC6SwpIt[nx,17,2] := ( _cAlias )->B6_LOCAL
                        If SB1->B1_LOCALIZ=="S"
                             aC6SwpIt[nx,21,1] := "C6_LOCALIZ"
                             aC6SwpIt[nx,21,2] := AvKey(cEnder,"C6_LOCALIZ")                            
                        Endif
					Endif
					( _cAlias )->(dbSkip())
				Enddo 
			Else
				If !lRf //Implanta็ใo radio frequencia
					ApMsgInfo("Nใo foi possํvel localizar saldo de terceiros para o produto " + cmodNovo + " do imei novo "+aC6SwpIt[nx,23,2]+". Por favor, contate RESPONSมVEL pelo almoxarifado e solicite anแlise.","Saldo insuficiente de Terceiros")
					lvldsld := .f.
				Else
					VTBEEP(3)
					VTAlert("Nใo foi possํvel localizar saldo de terceiros para o produto " + cmodNovo + " do imei novo "+aC6SwpIt[nx,23,2]+". Por favor, contate RESPONSมVEL pelo almoxarifado e solicite anแlise.","Saldo insuficiente de Terceiros",.t.,2500)
					lvldsld := .f.
				Endif
			
			EndIf		
		Else  
			// se tes nใo controla poder 3, alterar aC6SwpIt com os dados necessแrios
			SB1->(DbGoTop())
			SB1->(dbSeek(xFilial("SB1")+cmodNovo))     
			
			SB2->(DbGoTop())
			SB2->(DBSeek(xFilial("SB2") + SB1->B1_COD + cLocal))
			nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
			nSaldoBF := 0
			nSaldoBF :=  SaldoSBF(cLocal, cEnder, SB1->B1_COD, NIL, NIL, NIL, .F.)

              aC6SwpIt[nx,2,2]  := SB1->B1_COD
              aC6SwpIt[nx,3,2]  := SB1->B1_DESC
              aC6SwpIt[nx,4,2]  := cTesOp
              aC6SwpIt[nx,7,2]  := ""
              aC6SwpIt[nx,9,2]  := SB2->B2_CM1
              aC6SwpIt[nx,10,2] := SB2->B2_CM1*aC6SwpIt[nx,5,2]
              aC6SwpIt[nx,12,2] := ""
              aC6SwpIt[nx,13,2] := ""
              aC6SwpIt[nx,14,2] := ""
              aC6SwpIt[nx,15,2] := ""
              aC6SwpIt[nx,17,2] := AvKey(cLocal,"C6_LOCAL")
              If SB1->B1_LOCALIZ=="S"
                  aC6SwpIt[nx,21,1] := "C6_LOCALIZ"
                  aC6SwpIt[nx,21,2] := AvKey(cEnder,"C6_LOCALIZ")                            
              Endif
		EndIf
	Next nx
EndIf
//Inclusao do PV
IF lvldsld
    lRet := u_geraPV(aC5SwpCab, aC6SwpIt, 3, .T.)      
     If lRet     
	     aadd(aPedido,{SC5->C5_NUM,{}})
     Endif
ENDIF
	
RestArea(aArea)	

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ SchZZ3Swp ณ Autor ณ Vinicius Leonardo   ณ Data ณ 01/06/15  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Busca Defeitos e A็๕es							           ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function SchZZ3Swp(aImNovo) 

Local aArea   := GetArea()
Local cQuery  := ""
Local _cAlias := GetNextAlias()
Local lRet 	  := .F.

cQuery := " SELECT ZZ3_IMEISW,ZZ3_MODSW FROM " + RetSqlName("ZZ3") + " ZZ3 " + CRLF
cQuery += " WHERE ZZ3_FILIAL = '" + xFilial("ZZ3") + "' AND ZZ3.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " AND ZZ3_IMEI = '" + (cAliasTop5)->ZZ4_IMEI + "' AND ZZ3_NUMOS = '" + (cAliasTop5)->ZZ4_OS + "' " + CRLF
cQuery += " AND ZZ3_IMEISW <> '' " + CRLF 

cQuery := ChangeQuery(cQuery) 
If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
( _cAlias )->( dbGoTop() )
If( ( _cAlias )->( !Eof() ) ) 
	While ( ( _cAlias )->( !Eof() ) )
		aAdd(aImNovo,{Alltrim(( _cAlias )->ZZ3_IMEISW),Alltrim(( _cAlias )->ZZ3_MODSW),Alltrim(( cAliasTop5 )->ZZ4_IMEI),Alltrim(( cAliasTop5 )->ZZ4_OS)}) 
		( _cAlias )->(dbSkip())
	EndDo	    
	lRet := .T.
EndIf 

Restarea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtecax015  บAutor  ณMicrosiga           บ Data ณ  09/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para calcular saldo disponivel de Terceiros.        บฑฑ
ฑฑบ          ณ Desconta PV abertos do SB6->B6_SALDO                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function SalDisP3(_cIdent, _nSalSB6)
local _aAreaSC6  := SC6->(GetArea())
local _nSalDisP3 := _nQtPV3:= 0
Local _cqry      := "" 
SC6->(dbSetOrder(12))  // C6_FILIAL + C6_IDENTB6
//Alterardo Wile abaixo e substituido pela consulta SQL - Edson / Rodrigo Saloma - 14/06/12
//if SC6->(dbSeek(xFilial("SC6") + _cIdent ))
//	while SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_IDENTB6 == _cIdent
//		_nQtPV3 += ( SC6->C6_QTDVEN - SC6->C6_QTDENT )
//		SC6->(dbSkip())
//	enddo
//Endif                                               
If Select("Qrysc6") > 0
	Qrysc6->(dbCloseArea())
Endif
_cqry := " SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTDSC6 "+CTRL
_cqry += " FROM "+RETSQLNAME("SC6")+" (NOLOCK) WHERE C6_FILIAL='"+xFILIAL("SC6")+"' AND C6_IDENTB6='"+_cIdent+"' AND D_E_L_E_T_='' AND (C6_QTDVEN-C6_QTDENT) > 0 "+CTRL
TCQUERY _cqry ALIAS "Qrysc6" NEW
dbSelectArea("Qrysc6")
If Select("Qrysc6") > 0
	_nQtPV3 :=Qrysc6->QTDSC6
Endif
_nSalDisP3 := _nSalSB6 - _nQtPV3
restarea(_aAreaSC6)
Return(_nSalDisP3)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSestterc  บAutor  ณEdson Rodrigues     บ Data ณ  28/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para calcular saldo disponivel de Terceiros         บฑฑ
ฑฑบ          ณ e confrontar com a diponibilidade em estoque               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function Sestterc(_cprod,_clocal,_nqtdreq)
local _aAreaSC6  := SC6->(GetArea())
local _aAreaSB6  := SB6->(GetArea())
local _aAreaSB2  := SB2->(GetArea())
local _nSalDisP3 := _nQtSB2:= _nQtSB6:= _nQtPV3:= 0
local _cquery := ""
local _lret := .T.
SC6->(dbSetOrder(2))  // C6_FILIAL + C6_PRODUTO
SB6->(dbSetOrder(2))  // B6_FILIAL + B6_PRODUTO
If Select("QryPed") > 0
	QryPed->(dbCloseArea())
Endif
If Select("Qryterc") > 0
	Qryterc->(dbCloseArea())
Endif
//pega saldo do SB2
_nQtSB2:=Posicione("SB2",1,xFilial("SB2") + _cprod + _clocal,"B2_QATU")
//soma as quantidade de pedidos
_cquery:= " SELECT C6_FILIAL,C6_PRODUTO,C6_LOCAL,SUM(C6_QTDVEN-C6_QTDENT) QTDPEDVEN "+CTRL
_cquery+= " FROM "+ RETSQLNAME("SC6")+"  (NOLOCK) WHERE C6_FILIAL='"+xFilial("SC6")+"' AND "+CTRL
_cquery+= " C6_PRODUTO = '"+_cprod+"' AND C6_LOCAL = '"+_clocal+"' AND D_E_L_E_T_='' AND C6_QTDVEN-C6_QTDENT > 0 "+CTRL
_cquery+= " GROUP BY C6_FILIAL,C6_PRODUTO,C6_LOCAL "+CTRL
TCQUERY _cquery ALIAS "QryPed" NEW
//TcSetField("QryPed","QTDPEDVEN" ,"N",13,4)
dbSelectArea("QryPed")
QryPed->(dbGoTop())
If Select("QryPed") > 0
	_nQtPV3 :=QryPed->QTDPEDVEN
Endif
QryPed->(dbCloseArea())
//Soma a quantidade de terceiro por produto e por local
_cquery:= " SELECT B6_PRODUTO,B6_LOCAL,SUM(B6_SALDO)  AS SALDOB6 "+CTRL
_cquery+= " FROM "+ RETSQLNAME("SB6")+" (NOLOCK) WHERE B6_FILIAL='"+xFilial("SB6")+"' AND B6_PRODUTO = '"+_cprod+"'  AND B6_LOCAL='"+_clocal+"' "+CTRL
_cquery+= " AND D_E_L_E_T_='' "+CTRL
_cquery+= " GROUP BY B6_PRODUTO,B6_LOCAL "+CTRL
TCQUERY _cquery ALIAS "QryTerc" NEW
//TcSetField("QryTerc","SALDOB6" ,"N",13,4)
dbSelectArea("QryTerc")
QryTerc->(dbGoTop())
If Select("QryTerc") > 0
	_nQtSB6 :=QryTerc->SALDOB6
Endif
QryTerc->(dbCloseArea())
If _nQtSB2 >=_nQtSB6
	_nSalDisP3 := _nQtSB2- (_nQtPV3 + (_nQtSB6 - _nQtPV3)) // Calcula saldo disponํvel para terceiro, conforme SB2
Else
	_nSalDisP3 := _nQtSB2- (_nQtPV3 + (_nQtSB2 - _nQtPV3)) // Calcula saldo disponํvel para terceiro, conforme SB2
Endif
IF _nSalDisP3-_nqtdreq < 0
	_lret:=.F.
Endif
restarea(_aAreaSC6)
restarea(_aAreaSB6)
restarea(_aAreaSB2)
Return(_lret)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณverultcom บAutor  ณEdson Rodrigues     บ Data ณ  02/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para buscar o ultimo custo de compra                บฑฑ
ฑฑบ          ณ das Pecas apontadas                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function verultcom(_cprod,_demis,_clocal)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aArea  := GetArea()
Local cquery :=""
Local ncusto :=0

if select("QrySD1") > 0
	QrySD1->(dbCloseArea())
Endif

//cQuery := " SELECT SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,MAX(SD1.D1_DTDIGIT) DTDIGIT "
cQuery := " SELECT MAX(SD1.R_E_C_N_O_) AS RECNOD1,SUM(SD1.D1_TOTAL/SD1.D1_QUANT) AS CUSTO "
cQuery += " FROM "+RETSQLNAME("SD1")+" SD1 (nolock) "
cQuery += " INNER JOIN "+RETSQLNAME("SF4")+" AS SF4 (nolock) ON SD1.D1_TES=SF4.F4_CODIGO "
cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "
cQuery += " AND SD1.D1_LOCAL = '"+_cLocal+"' "
cQuery += " AND SD1.D_E_L_E_T_ = '' AND SD1.D1_COD = '"+_cProd+"' "
cQuery += " AND SD1.D1_DTDIGIT <= '"+DTOS(_Demis)+"'"
cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += " AND SF4.F4_PODER3 = 'N' AND SF4.D_E_L_E_T_ = '' AND SD1.D1_TIPO IN ('N') AND SF4.F4_TEXTO LIKE '%COMPR%' "
//cQuery += " GROUP BY SD1.D1_DTDIGIT,SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA "

TCQUERY cQuery ALIAS "QrySD1" NEW

if select("QrySD1") > 0
	dbSelectArea("SD1")
	SD1->(dbGoTo(QrySD1->RECNOD1))
	ncusto:=SD1->D1_VUNIT
Endif

If ncusto = 0
	if select("QrySD1") > 0
		QrySD1->(dbCloseArea())
	Endif
	cQuery := " SELECT MAX(SD1.R_E_C_N_O_) AS RECNOD1,SUM(SD1.D1_TOTAL/SD1.D1_QUANT) AS CUSTO "
	cQuery += " FROM "+RETSQLNAME("SD1")+" SD1 (nolock) "
	cQuery += " INNER JOIN "+RETSQLNAME("SF4")+" AS SF4 (nolock) ON SD1.D1_TES=SF4.F4_CODIGO "
	cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "
	cQuery += " AND SD1.D_E_L_E_T_ = '' AND SD1.D1_COD = '"+_cProd+"' "
	cQuery += " AND SD1.D1_DTDIGIT <= '"+DTOS(_Demis)+"'"
	cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
	cQuery += " AND SF4.F4_PODER3 = 'N' AND SF4.D_E_L_E_T_ = '' AND SD1.D1_TIPO IN ('N') AND SF4.F4_TEXTO LIKE '%COMPR%' "
	
	TCQUERY cQuery ALIAS "QrySD1" NEW
	if select("QrySD1") > 0
		dbSelectArea("SD1")
		SD1->(dbGoTo(QrySD1->RECNOD1))
		ncusto:=SD1->D1_VUNIT
	Endif
	If ncusto = 0
		if select("QrySD1") > 0
			QrySD1->(dbCloseArea())
		Endif
		cQuery := " SELECT MAX(SD1.R_E_C_N_O_) AS RECNOD1,SUM(SD1.D1_TOTAL/SD1.D1_QUANT) AS CUSTO "
		cQuery += " FROM "+RETSQLNAME("SD1")+" SD1 (nolock) "
		cQuery += " INNER JOIN "+RETSQLNAME("SF4")+" AS SF4 (nolock) ON SD1.D1_TES=SF4.F4_CODIGO "
		cQuery += " AND SD1.D_E_L_E_T_ = '' AND SD1.D1_COD = '"+_cProd+"' "
		cQuery += " AND SD1.D1_DTDIGIT <= '"+DTOS(_Demis)+"'"
		cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
		cQuery += " AND SF4.F4_PODER3 = 'N' AND SF4.D_E_L_E_T_ = '' AND SD1.D1_TIPO IN ('N') AND SF4.F4_TEXTO LIKE '%COMPR%' "
		
		TCQUERY cQuery ALIAS "QrySD1" NEW
		if select("QrySD1") > 0
			dbSelectArea("SD1")
			SD1->(dbGoTo(QrySD1->RECNOD1))
			ncusto:=SD1->D1_VUNIT
		Endif
	Endif
Endif

//if !QrySD1->(Eof())
//	_cNFSD1:=QrySD1->D1_DOC+SUBSTR(QrySD1->D1_SERIE,1,3)+QrySD1->D1_FORNECE+D1_LOJA
//    dbSelectArea("SD1")
//	dbSetOrder(2)
//	SD1->(dbSeek(xFilial("SD1") + _cprod + QrySD1->D1_DOC+QrySD1->D1_SERIE+QrySD1->D1_FORNECE+D1_LOJA))
//	ncusto :=SD1->D1_TOTAL/SD1->D1_QUANT
//Endif

Return(ncusto)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณversaldo  บAutor  ณEdson Rodrigues     บ Data ณ  03/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar o saldo disponveil no estoque fisicao  บฑฑ
ฑฑบ          ณ e por endere็o das Pecas apontadas                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function versaldo(clab,cpartn,nqtde,_carmaz,cendaud)

Local cQry1   :=""
Local _cQuery1 :=""
Local cCrLf:=Chr(13)+Chr(10)
//Local _carmaz:=iif(clab=="1",left(carmense,2),left(carmenne,2))
//Local _clocaliz:=iif(clab=="1",substr(carmense,3,15),substr(carmenne,3,15))
local _aSavAB9 :={}
local _cReturn :="OK"
Local  nSalb2  := 0.00
Local _nSalBF  := 0.00                            
Local _aSavSBF :={}

cendaud  := AllTrim(cendaud)+ space(TamSX3("BE_LOCALIZ")[1]-len(AllTrim(cendaud)))
SBE->(dbsetorder(1)) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ

/*
IF Select("QRY1") <> 0
	dbSelectArea("QRY1")
	dbCloseArea()
Endif


_cQuery1 := " SELECT B2_COD 'COD' ,B2_LOCAL 'ARMZ' "
_cQuery1 += "       ,B2_QATU 'SLDOATU',B2_RESERVA 'QTDRESER',B2_QPEDVEN 'QTPDVEND',B2_QACLASS 'QTACLAS' "
_cQuery1 += "       ,B2_QTNP'QTTERPD' "
_cQuery1 += "       ,B2_QNPT 'QTNSPDTER',(B2_QATU - (B2_RESERVA+B2_QPEDVEN))'QTDISP'  "
_cQuery1 += " FROM " +Retsqlname ("SB2") + " SB2 (NOLOCK) "
_cQuery1 += " WHERE  SB2.B2_COD  = '" +alltrim(cpartn)+ "' "
_cQuery1 += "   AND SB2.B2_LOCAL = '" +_carmaz+ "' "
_cQuery1 += "   AND B2_FILIAL    = '"+xFilial("SB2")+"' "
_cQuery1 += "   AND D_E_L_E_T_   ='' "

//memowrite("saldispo.sql",_cQuery1)
cQuery := CHANGEQUERY(_cQuery1)
TcQuery _cQuery1 ALIAS "QRY1" NEW

*/



IF SB2->(DBSeek(xFilial('SB2')+cpartn+_carmaz))
    nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)

    if nSalb2 >= nqtde 
    	dbSelectArea("SBF")
		_aSavSBF := GetArea()
		dbSetOrder(1) //BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO
		If SBF->(dbSeek(xFilial("SBF")+_carmaz+ cendaud + AllTrim(cpartn)))
		   _nSalBF := SaldoSBF(_carmaz, cendaud,cpartn, NIL, NIL, NIL, .F.)
        
           If _nSalBF < nqtde
        
              _creturn:="NOTSALBF"
           
           Endif
        Else
          IF !SBE->(DbSeek(XFilial("SBE")+_carmaz+alltrim(cendaud)))
          _creturn:="NOTLOCALIZ"
          Else
              _creturn:="NOTSALBF"
          Endif      
        
        Endif
        restarea(_aSavSBF)
    Else
       _creturn:="NOTSALB2"
    Endif
    
Else
   _creturn:="NOTSB2"
Endif
    
    	/*
If !Qry1->(Eof()) .AND. Qry1->QTDISP > 0
	dbSelectArea("SBF")
	_aSavSBF := GetArea()
	dbSetOrder(1) //BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO
	IF SBF->(dbSeek(xFilial("SBF")+_carmaz+ _clocaliz+alltrim(cpartn)))
		IF SBF->BF_QUANT <= 0
			_cReturn:="NOTSALBF"
			
		ElseIF nqtde - SBF->BF_QUANT > 0
			_cReturn:="NOTSALBF"
			
		ElseIF nqtde - Qry1->QTDISP > 0
			_cReturn:="NOTSALB2"
			
		Else
			_cReturn:="OK"
		Endif
	Else
		_cReturn:="NOTLOCALIZ"
	Endif
    restarea(_aSavSBF)
ENDIF
		*/



Return(_cReturn)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerapeca  บAutor  ณEdson Rodrigues     บ Data ณ  23/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para montar array de pecas apontas                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Gerapeca(_aIteSC6)
_aIMPSC6  := aClone(_aIteSC6)
_cnewprod :=space(15)        
_lgerapec := .t. 

dbSelectArea("SC6")
_aSavSC6:= GetArea()
dbSetOrder(1)

dbSelectArea("AB9")
_aSavAB9:= GetArea()
AB9->(dbOrderNickName("AB9SNOSCLI"))//dbSetOrder(7)

dbSelectArea("ZZ4")
_aSavZZ4 := GetArea()
dbSetOrder(1)  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS

dbSelectArea("SZ9")
_aSavSZ9 := GetArea()
dbSetOrder(2)  // Z9_FILIAL+Z9_IMEI+Z9_NUMOS+Z9_SEQ


aSort(_aIMPSC6,,,{|x,y| x[2,2] < y[2,2]}) // Orderna por produto os IMEIS selecionados por cliente. - Edson Rodrigue - 23/10/2009
for nX := 1 to len(_aIMPSC6)
	_cproduct:=_aIMPSC6[nX,2,2]
	_cNUMSER :=_aIMPSC6[nX,7,2]
	_cIMEI   :=_aIMPSC6[nX,7,2]
	_cIMEI   := AllTrim(_cIMEI)+ space(TamSX3("ZZ4_IMEI")[1]-len(AllTrim(_cIMEI)))
	
	dbSelectArea("ZZ4")
	If 	ZZ4->(DBSeek(xFilial("ZZ4")+_cIMEI+left(_aIMPSC6[NX,8,2],6)))
		If ZZ4->ZZ4_STATUS = "8"
			IF _cproduct<>_cnewprod .and. !empty(_cNUMSER)
				_cnewprod:=_aIMPSC6[nX,2,2]
				
				dbSelectArea("SZ9")
				For IX := nX to len(_aIMPSC6)
					If _aIMPSC6[IX,2,2]==_cnewprod .and. !empty(_aIMPSC6[IX,7,2])
						If SZ9->(DBSeek(xFilial("SZ9")+_aIMPSC6[IX,7,2]+left(_aIMPSC6[IX,8,2],6)))
							cSZ9Chav:=xFilial("SZ9")+_aIMPSC6[IX,7,2]+left(_aIMPSC6[IX,8,2],6)
							//Alterado Edson Rodrigues - 14/04/10
							//cTESPecs:=AllTrim(GetMV("MV_TESPART"))
							cTESPecs:=Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH, "ZZJ_TESPVP")
							//filtpeca(cSZ9Chav,cTESPecs,_cnewprod)
							_lgerapec:=filtpeca(cSZ9Chav,cTESPecs,_cnewprod,ZZ4->ZZ4_OPEBGH,ZZ4->ZZ4_IMEI,ZZ4->ZZ4_CODPRO)
							
						Endif
					Endif
				
				    IF !_lgerapec
					   exit
					Endif
				
				
				Next IX
				
		Endif
	Endif
	EndIf

	IF !_lgerapec
	    exit
	Endif


next nX

RestArea(_aSavZZ4)
RestArea(_aSavSC6)
RestArea(_aSavAB9)
RestArea(_aSavSZ9)

Return()





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfiltpeca  บAutor  ณEdson Rodrigues     บ Data ณ  23/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Filtrar as pecas apontadas conforme            บฑฑ
ฑฑบ          ณ Parametros                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function filtpeca(cSZ9Chav,cTESPecs,cprodIMEI,copebgh,cImei,cCodPro)
local _aSavSB1   := SB1->(GetArea())
local _aSavSB2   := SB2->(GetArea())
//alterado Edson - 14/04/10
//local carmense  :=AllTrim(GetMV("MV_ARMENSE")) //armazem e localizacao para baixa da Sony Ericson
//local carmenne  :=AllTrim(GetMV("MV_ARMENNE")) //armazem e localizacao para baixa da Nextel
Local carmproc   := Posicione("ZZJ",1,xFilial("ZZJ") + copebgh, "ZZJ_ALMEP")
Local ccuspec    := Posicione("ZZJ",1,xFilial("ZZJ") + copebgh, "ZZJ_CUSPEC")     
local cendaud    := Posicione("ZZJ",1,xFilial("ZZJ") + copebgh, "ZZJ_ENDAUD")  
local cTESPnac   := Posicione("ZZJ",1,xFilial("ZZJ") + copebgh, "ZZJ_TESPVP")  // TES PARA ITENS NACIONAIS
local cTESPimp   := Posicione("ZZJ",1,xFilial("ZZJ") + copebgh, "ZZJ_TESPIM")  // TES PARA ITENS IMPORTADO
local cTESPst    := Posicione("ZZJ",1,xFilial("ZZJ") + copebgh, "ZZJ_TESPST")  // TES PARA ITENS COM ICMS ST
local _cvalisald :="OK"
local _nPrcVen   := 0
Local _nValor    := 0
local _lvalidad  := .T.             

cendaud  := AllTrim(cendaud)// + space(TamSX3("BE_LOCALIZ")[1]-len(AllTrim(cendaud)))
_clibPvS := Posicione("ZZJ",1,xFilial("ZZJ") + copebgh, "ZZJ_LIBPVS")


dbSelectArea ("SB1")
dbSetOrder(1)

dbSelectArea ("SB2")
dbSetOrder(1)

dbSelectArea ("SZ9")
//Varre atrav้s do SubItem do SZ9

While SZ9->(Z9_FILIAL+Z9_IMEI+LEFT(Z9_NUMOS,6)) == cSZ9Chav .and. !SZ9->(Eof()) .and. !empty(cTESPecs)
	If SZ9->Z9_STATUS == "1" .AND. !Empty(SZ9->Z9_PARTNR) .AND. SZ9->Z9_USED="0".AND. !Empty(cTESPecs)  .AND.  Empty(SZ9->Z9_PEDPECA)
		clab       :=Posicione("ZZ3",1,xFilial("ZZ3")+SZ9->Z9_IMEI+SZ9->Z9_NUMOS+SZ9->Z9_SEQ, "ZZ3_LAB") //Busca o laboratorio
		carmpc     :=IIF(EMPTY(carmproc),SZ9->Z9_LOCAL,carmproc) //Busca o armazem apontado
		cestq      :=Posicione("SF4",1,xFilial("SF4")+cTESPecs, "F4_ESTOQUE") //Busca se a TES atualiza o estoque
		cpartn     :=ALLTRIM(SZ9->Z9_PARTNR)
		cnumos     :=LEFT(SZ9->Z9_NUMOS,6)
		ciMEIZ9    :=SZ9->Z9_IMEI
		cseqZ9     :=SZ9->Z9_SEQ
		
		
		If SB1->(DBSeek(xFilial("SB1")+cpartn)) //.and. carmpc $ left(carmense,2) desabilitado ate comecarem o apontamento correto, informando o armazem.
			nqtde :=IIF(SZ9->Z9_QTY=0,1,SZ9->Z9_QTY)
			IF  SB1->B1_ORIGEM = "1"
			      cTESPecs :=cTESPimp
			ELSE       
			      cTESPecs :=cTESPnac
			ENDIF          
			
			
			//Verifica se tem o armazem criado.
			If !SB2->(DBSeek(xFilial("SB2")+SB1->B1_COD+carmpc))
				U_saldoini(SB1->B1_COD,alltrim(carmpc))
			Endif
			
			//busca custo conforme regra do laboratorio.
			//Alterado regras de custo - Edson Rodrigues 10/04/10
			If ccuspec =="CM"
				//carmpc:=IIF(Empty(carmpc),"21",carmpc)
				//carmpc:=IIF(Empty(carmpc),carmproc,carmpc)
				
				If SB2->(DBSeek(xFilial("SB2")+SB1->B1_COD+carmpc))
					ncusto:=SB2->B2_CM1
				Else
					ncusto:=u_verultcom(SB1->B1_COD,ddatabase,carmpc)
				Endif
			ElseIf ccuspec =="UC"
				//carmpc:=IIF(Empty(carmpc),"01",carmpc)
				//carmpc:=IIF(Empty(carmpc),carmproc,carmpc)
				ncusto:=verultcom(SB1->B1_COD,ddatabase,carmpc)
			Endif
			
			//Vinicius Leonardo - Delta Decisใo 
			ncusto :=IIF(SZ9->Z9_PRCCALC>0,SZ9->Z9_PRCCALC,ncusto)
			
			//Alterar e melhorar essa validacao de saldo de estoque, pois nao esta confiavel - Edson Rodrigues 14/04/10
			If  cestq=="S"
				_cvalisald:=versaldo(clab,SB1->B1_COD,nqtde,carmpc,cendaud)
				

				// Fazer as validacoes devidas
				if _cvalisald == "NOTSALBF"
					MsgInfo("Sem saldo suficiente no Endere็o :"+alltrim(cendaud)+" para o PN: "+alltrim(SB1->B1_COD)+", nใo sera possivel gerar a NF do PV de Pe็as. O PV pe็as ficarแ bloqueado para analise e libera็ใo.","Saldo Insuficiente")
				    cendaud:=""
				    _clibPvS :="N"
				Elseif _cvalisald == "NOTSALB2"
					MsgInfo("Sem saldo suficiente para o PN: "+alltrim(SB1->B1_COD)+", nใo sera possivel gerar a NF do PV de Pe็as. O PV pe็as ficarแ bloqueado para analise e libera็ใo.","Saldo Insuficiente")
  				    cendaud:=""
  				    _clibPvS :="N"
				Elseif _cvalisald == "NOTLOCALIZ"
					 MsgInfo("Endere็o : "+cendaud+"nใo cadastrado para o armazem : "+carmpc+", nใo sera possivel gerar a NF do PV de Pe็as. Favor entrar em contato o responsavel pelos estoque.","End nao cadastrado")
			         cendaud:=""
			         _clibPvS :="N"
		        Elseif _cvalisald == "NOTSB2"
       				 MsgInfo("Sem saldo suficiente para o PN: "+alltrim(SB1->B1_COD)+", nใo sera possivel gerar a NF do PV de Pe็as. O PV pe็as ficarแ bloqueado para analise e libera็ใo.","Saldo Insuficiente")
       				 U_saldoini(SB1->B1_COD,alltrim(carmpc))
                     cendaud:=""
                     _clibPvS :="N"
			    Endif      
			Else
			  cendaud:=""
			  _clibPvS :="N"
			Endif
			
			
			If _lvalidad
				
				cpcnIt := Soma1(cpcnIt,2)
				_nPrcVen := A410Arred(ncusto,"C6_VALOR")
				_nValor  := A410Arred(ncusto * nqtde,"C6_VALOR")
				
				Aadd(_aitpcSC6,{{"C6_ITEM"	   ,cpcnIt	        ,Nil},;//1
				{"C6_PRODUTO"	               ,cpartn 		,Nil},;    //2
				{"C6_DESCRI"	               ,SB1->B1_DESC   ,Nil},; //3
				{"C6_TES"		               ,cTESPecs	    ,Nil},;//4
				{"C6_QTDVEN"	               ,nqtde		  	,Nil},;//5
				{"C6_QTDLIB"	               ,IIF(_clibPvS="S",nqtde,0),Nil},;//6
				{"C6_NUMSERI"	               ,""    		,Nil},;//7
				{"C6_NUMOS"		               ,cnumos         ,Nil},;//8
				{"C6_PRCVEN"	               ,_nPrcVen		,Nil},;//9
				{"C6_VALOR"		               ,_nValor	    ,Nil},;    //10
				{"C6_PRUNIT"	               ,0  		 	,Nil},;    //11
				{"C6_NFORI"		               ,""             ,Nil},; //12
				{"C6_SERIORI"	               ,""             ,Nil},; //13
				{"C6_ITEMORI"	               ,""             ,Nil},; //14
				{"C6_IDENTB6"	               ,""				,Nil},;//15
				{"C6_PRCCOMP"	               ,0				,Nil},;//16
				{"C6_LOCAL"		               ,carmpc         ,Nil},; //17
				{"C6_ENTREG"	               ,dDataBase  	,Nil},;    //18
				{"C6_OSGVS"		               ,""             ,Nil},; //19
				{"C6_AIMPGVS"	               ,""		        ,Nil},;//20
				{"C6_LOCALIZ"	               ,cendaud      ,Nil},;   //21
				{"PRODIMEI"	                   ,cprodIMEI      ,Nil},; //22
				{"SEQSZ9"	                   ,cseqZ9         ,Nil},; //23 
				{"IMEI"	                       ,ciMEIZ9       ,Nil},;  //24				
     			{"C6_PVRET"	                   ,SC5->C5_NUM     ,Nil}})//25  
				
			
			    _clibPvS := Posicione("ZZJ",1,xFilial("ZZJ") + copebgh, "ZZJ_LIBPVS")
			Endif
		Endif
	Endif
	SZ9->(DBSkip())
Enddo
restarea(_aSavSB1)
restarea(_aSavSB2)
RETURN(_lvalidad)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerapvpc  บAutor  ณEdson Rodrigues     บ Data ณ  23/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Gerar Pedido de pecas apontadas                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Gerapvpc(_aCabSC5,_aitpcSC6)
Local _cproduct:=SPACE(15)
Local _cnewprod:=SPACE(15)
Local _cpropeca:=""
Local _nprcven :=0.00
Local _lRet:=.t.
Local cTpReent :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TPRENT")
Local nXEmezenc, nYEmezenc := 0
dbSelectArea("SZ9")
_aSavSZ9 := GetArea()
dbSetOrder(2)  // Z9_FILIAL+Z9_IMEI+Z9_NUMOS+Z9_SEQ

aSort(_aitpcSC6,,,{|x,y| x[22,2]+x[2,2] < y[22,2]+y[2,2]})
//  aSort(aordprod,,,{|x,y| x[22,2] < y[22,2]})
_aCPCSC5  :=aclone(_aCabSC5)
aadd(_aCPCSC5,{"C5_NUM"   ,"",Nil})
aadd(_aCPCSC5,{"C5_PVRET" ,"",Nil})

_nPosMens := Ascan( _aCPCSC5 ,{ |x| x[1] == "C5_MENPAD" })
_nPostran := Ascan( _aCPCSC5 ,{ |x| x[1] == "C5_TRANSP" })
_nPosdivn := Ascan( _aCPCSC5 ,{ |x| x[1] == "C5_DIVNEG" })
_nPosment := Ascan( _aCPCSC5 ,{ |x| x[1] == "C5_MENNOTA" })
_nPoskit  := Ascan( _aCPCSC5 ,{ |x| x[1] == "C5_B_KIT" })
_nPosnum  := Ascan( _aCPCSC5 ,{ |x| x[1] == "C5_NUM" })
_nPosPVRet:= Ascan( _aCPCSC5 ,{ |x| x[1] == "C5_PVRET" })

//comentado pois nao tem mais necessidade - Edson Rodrigues - 14/04/10
//descomentado por solicita็ใo de Carlos Souza do Faturamento. Vinicius Leonardo - Delta Decisใo - 20/05/15
If _nPosMens > 0
_aCPCSC5[_nPosMens,2] := "024"
Endif
If !lPVSwp
	If _nPosPVRet > 0
		_aCPCSC5[_nPosPVRet,2] := _aitpcSC6[1,25,2]
	EndIf
EndIf
/*
If _nPostran > 0
_aCPCSC5[_nPostran,2] := "024"
Endif
If _nPoskit > 0
_aCPCSC5[_nPoskit,2] := ""
Endif
*/


For nXEmezenc:=1 to len(_aitpcSC6)
	_cproduct:=_aitpcSC6[nXEmezenc,22,2]
	_aitpcprod:={} //array para agrupar por produto/pe็a - Edson Rodrigues
	_aosimsz9:={} //array separar OS/IMEIs/Partnumbers que gerarm os pedidos - Edson Rodrigues	 - 07/04/10
	cpcnIt    :="00"
	_npospec:=0
	_cnewpeca:=SPACE(15)
	cNrPV:=space(6)
	
	
	//comentado pois nao tem mais necessidade - Edson Rodrigues - 14/04/10
	If _nPosdivn > 0
		_aCPCSC5[_nPosdivn,2] := iif(_aitpcSC6[1,17,2]="21","03" ,"04")
	Endif
	
	
	IF _cproduct<>_cnewprod
		_cnewprod:=_cproduct
		//cNrPV := GetSX8Num("SC5")
		
		cNrPV:=GetSx8Num("SC5","C5_NUM")
		ConfirmSX8()
		If _nPosment > 0
			_aCPCSC5[_nPosment,2] := "REF. MODELO: "+AllTrim(_cnewprod)+ "."
		Endif
		If _nPosnum > 0
			_aCPCSC5[_nPosnum,2] :=cNrPV
		Endif
		_nqtdppec++
		_nqtpcped:=0
		
		//For ni:= nXEmezenc to len(aordprod)
		//        If aordprod[ni,22,2]+aordprod[ni,2,2]==_cnewprod
		//Incluso para aglutinar por pe็a - Edson Rodrigues - 31/03/10
		For nYEmezenc := nXEmezenc to len(_aitpcSC6)
			IF _aitpcSC6[nYEmezenc,22,2]==_cnewprod
				IF  (_aitpcSC6[nYEmezenc,22,2]+_aitpcSC6[nYEmezenc,2,2]<>_cpropeca) .or. ( _aitpcSC6[nYEmezenc,9,2]<>_nprcven)
					_cpropeca:=_aitpcSC6[nYEmezenc,22,2]+_aitpcSC6[nYEmezenc,2,2]
					_cnewpeca :=_aitpcSC6[nYEmezenc,2,2]
					_nqtde:=_aitpcSC6[nYEmezenc,5,2]
					_nqtdlib:=_aitpcSC6[nYEmezenc,6,2]
					_nprcven:=_aitpcSC6[nYEmezenc,9,2]
					_nvalor:=_aitpcSC6[nYEmezenc,10,2]
					_nprunit:=_aitpcSC6[nYEmezenc,11,2]
					_npospec++
					cpcnIt := Soma1(cpcnIt,2)
					_nqtpcped++  //Conta quantas pecas foram gerados por pedido - Edson Rodrigues 15/04/10
					_nqtditpc++  //Conta quantas pecas foram gerados no total - Edson Rodrigues 15/04/10
					
					Aadd(_aitpcprod,{{"C6_FILIAL"	 ,xFilial("SC6")      ,Nil},;
					{"C6_NUM"	     ,cNrPV			       ,Nil},;
					{"C6_ITEM"	     ,cpcnIt			   ,Nil},;
					{"C6_PRODUTO"	 ,_aitpcSC6[nYEmezenc,2,2]   ,Nil},;
					{"C6_DESCRI"	 ,_aitpcSC6[nYEmezenc,3,2]   ,Nil},;
					{"C6_TES"		 ,_aitpcSC6[nYEmezenc,4,2]   ,Nil},;
					{"C6_QTDVEN"	 ,_aitpcSC6[nYEmezenc,5,2]	   ,Nil},;
					{"C6_QTDLIB"	 ,_aitpcSC6[nYEmezenc,6,2]   ,Nil},;
					{"C6_NUMSERI"	 ,_aitpcSC6[nYEmezenc,7,2]   ,Nil},;
					{"C6_NUMOS"	     ,_aitpcSC6[nYEmezenc,8,2]	   ,Nil},;
					{"C6_PRCVEN"	 ,_aitpcSC6[nYEmezenc,9,2]	   ,Nil},;
					{"C6_VALOR"	     ,_aitpcSC6[nYEmezenc,10,2]  ,Nil},;
					{"C6_PRUNIT"	 ,_aitpcSC6[nYEmezenc,11,2]  ,Nil},;
					{"C6_NFORI"	     ,_aitpcSC6[nYEmezenc,12,2]  ,Nil},;
					{"C6_SERIORI"	 ,_aitpcSC6[nYEmezenc,13,2]  ,Nil},;
					{"C6_ITEMORI"	 ,_aitpcSC6[nYEmezenc,14,2]  ,Nil},;
					{"C6_IDENTB6"	 ,_aitpcSC6[nYEmezenc,15,2]  ,Nil},;
					{"C6_PRCCOMP"	 ,_aitpcSC6[nYEmezenc,16,2]  ,Nil},;
					{"C6_LOCAL"	     ,_aitpcSC6[nYEmezenc,17,2]  ,Nil},;
					{"C6_ENTREG"	 ,_aitpcSC6[nYEmezenc,18,2]  ,Nil},;
					{"C6_OSGVS"	     ,_aitpcSC6[nYEmezenc,19,2]  ,Nil},;
					{"C6_AIMPGVS"	 ,_aitpcSC6[nYEmezenc,20,2]  ,Nil},;
					{"C6_LOCALIZ"	 ,Iif(cTpReent<>"2",_aitpcSC6[nYEmezenc,21,2],"")  ,Nil}})
					
				Else
					IF _aitpcSC6[nYEmezenc,22,2]+_aitpcSC6[nYEmezenc,2,2]=_cpropeca .and.  _aitpcSC6[nYEmezenc,9,2]=_nprcven
						
						// Adiciona ao arrray _aosimsz9 o pedido e itens do pedido para sere gravados  no apontaento de p็as SZ9 -- Edson Rodrigues 08/04/10.
						aadd(_aosimsz9,{_aitpcSC6[nYEmezenc,24,2],_aitpcSC6[nYEmezenc,8,2],_aitpcSC6[nYEmezenc,23,2],_aitpcSC6[nYEmezenc,2,2],cNrPV,cpcnIt})
						
						_aitpcprod[_npospec,7,2]:=_aitpcprod[_npospec,7,2] +_aitpcSC6[nYEmezenc,5,2]
						_aitpcprod[_npospec,8,2] :=_aitpcprod[_npospec,8,2] +_aitpcSC6[nYEmezenc,6,2]
						_aitpcprod[_npospec,12,2] :=_aitpcprod[_npospec,12,2]+_aitpcSC6[nYEmezenc,10,2]
						_nqtpcped++  //Conta quantas pecas foram gerados por pedido - Edson Rodrigues 15/04/10
						_nqtditpc++  //Conta quantas pecas foram gerados no total - Edson Rodrigues 15/04/10
					Endif
					
				Endif
			Endif
		Next nYEmezenc
		
		//      Endif
		//next ni
		If len(_aCPCSC5) > 0  .and. len(_aitpcprod) > 0
			_lRet := u_geraPV(_aCPCSC5,_aitpcprod, 3)  //Inclusao de novo PV
			//If   lRet
			//    ConfirmSX8()
			//Endif
			If _lRet
				aadd(aPedido,{SC5->C5_NUM,aB6KIT})
				aadd(aZZQPec,SC5->C5_NUM)
			EndIf	 
		Endif
		
		// Se gerou erro no PV pela rotina padrao, forca a gravacao pelo RECLOCK
		If !_lRet
			_lRet:=.t.
			
			//**********************************************
			//          Geracao dos Cabecalhos             *
			//**********************************************
			If Alltrim(_aCPCSC5[ 1,2]) <> "B"
			 
				SA1->(DBSeek(xFilial("SA1")+_aCPCSC5[2,2]+_aCPCSC5[3,2]))
				_cCFIni := "0"
				If Subs(SA1->A1_EST,1,2) == "EX"
					_cCFIni := "7"
				ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
					_cCFIni := "6"
				Else
					_cCFIni := "5"
				Endif
				
			Else
				dbSelectArea("SA2")
				dbSetOrder(1)
				SA2->(DBSeek(xFilial("SA2")+_aCPCSC5[2,2]+_aCPCSC5[3,2]))
				
				_cCFIni := "0"
				If Subs(SA2->A2_EST,1,2) == "EX"
					_cCFIni := "7"
				ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA2->A2_EST)
					_cCFIni := "6"
				Else
					_cCFIni := "5"
				Endif
			Endif
			
			RecLock("SC5",.T.)
			SC5->C5_FILIAL  := xFilial("SC5")
			SC5->C5_NUM     := cNrPV
			SC5->C5_TIPO    := _aCPCSC5[ 1,2]//"N" //Normal
			SC5->C5_CLIENTE := _aCPCSC5[ 2,2]
			SC5->C5_LOJACLI := _aCPCSC5[ 3,2]
			SC5->C5_CLIENT  := _aCPCSC5[ 2,2]
			SC5->C5_LOJAENT := _aCPCSC5[ 4,2]
			SC5->C5_TIPOCLI := "F"   //Consumidor Final
			SC5->C5_CONDPAG := "001" //A VISTA
			SC5->C5_EMISSAO := dDatabase
			SC5->C5_MOEDA   := 1
			SC5->C5_TIPLIB  := "1"   //Liberacao por Pedido
			SC5->C5_TPCARGA := "2"
			SC5->C5_TXMOEDA := 1
			SC5->C5_B_KIT   := ""
			SC5->C5_XUSER   := _aCPCSC5[10,2]
			SC5->C5_TRANSP  := _aCPCSC5[11,2]
			SC5->C5_MENPAD  := _aCPCSC5[12,2]
			SC5->C5_DIVNEG  := _aCPCSC5[13,2]
			SC5->C5_MENNOTA := _aCPCSC5[14,2]
			If !lPVSwp 
				SC5->C5_PVRET	:= _aitpcSC6[1,25,2]
			EndIf
			MsUnLock("SC5")
			//ConfirmSX8()
			
			//**********************************************
			//          Geracao dos Itens                  *
			//**********************************************
			for nYEmezenc := 1 to len(_aitpcprod)
				
				SB1->(DBSeek(xFilial("SB1")+_aitpcprod[nYEmezenc,2,2]))
				SF4->(DBSeek(xFilial("SF4")+_aitpcprod[nYEmezenc,4,2]))
				RecLock("SC6",.T.)
				SC6->C6_FILIAL := _aitpcprod[nYEmezenc,1,2]
				SC6->C6_NUM    := _aitpcprod[nYEmezenc,2,2]
				SC6->C6_ITEM   := _aitpcprod[nYEmezenc,3,2]
				SC6->C6_PRODUTO:= _aitpcprod[nYEmezenc,4,2]
				SC6->C6_UM     := SB1->B1_UM
				SC6->C6_QTDVEN := _aitpcprod[nYEmezenc,7,2]
				SC6->C6_PRCVEN := _aitpcprod[nYEmezenc,11,2]
				SC6->C6_VALOR  := _aitpcprod[nYEmezenc,12,2]
				SC6->C6_TES    := _aitpcprod[nYEmezenc,6,2]
				SC6->C6_LOCAL  := _aitpcprod[nYEmezenc,19,2]
				SC6->C6_CF     := AllTrim(_cCFIni)+Subs(SF4->F4_CF,6,2)
				SC6->C6_ENTREG := dDataBase
				SC6->C6_DESCRI := SB1->B1_DESC
				SC6->C6_PRUNIT := _aitpcprod[nYEmezenc,11,2]
				SC6->C6_NFORI  := _aitpcprod[nYEmezenc,14,2]
				SC6->C6_SERIORI:= _aitpcprod[nYEmezenc,15,2]
				SC6->C6_ITEMORI:= _aitpcprod[nYEmezenc,16,2]
				SC6->C6_AEXPGVS:= _aitpcprod[nYEmezenc,9,2]
				SC6->C6_TPOP   := "F" //FIRME
				SC6->C6_CLI    := _aCPCSC5[ 2,2]
				SC6->C6_LOJA   := _aCPCSC5[ 3,2]
				SC6->C6_IDENTB6:= _aitpcprod[nYEmezenc,17,2]
				SC6->C6_PRCCOMP:= _aitpcprod[nYEmezenc,18,2]
				SC6->C6_NUMOS  := _aitpcprod[nYEmezenc,10,2]
				MsUnLock("SC6")
			next nYEmezenc
			
			aadd(aPedido,{cNrPV,aB6KIT})
			aadd(aZZQPec,cNrPV)
		Endif
		
		If _lRet .and.  Len(_aosimsz9) > 0
			For px:=1 to Len(_aosimsz9)
				If (SZ9->(DBSeek(xFilial("SZ9")+_aosimsz9[px,1]+left(_aosimsz9[px,2],6)+"  "+_aosimsz9[px,3])) .or. SZ9->(DBSeek(xFilial("SZ9")+_aosimsz9[px,1]+left(_aosimsz9[px,2],6)+"01"+_aosimsz9[px,3])))
					While !SZ9->(Eof())  .and.  SZ9->Z9_FILIAL=xFilial("SZ9") .AND. SZ9->Z9_IMEI=_aosimsz9[px,1] .AND. LEFT(SZ9->Z9_NUMOS,6)=_aosimsz9[px,2]
						IF SZ9->Z9_PARTNR=_aosimsz9[px,4] .AND.  SZ9->Z9_SEQ == _aosimsz9[px,3] .AND. EMPTY(SZ9->Z9_PEDPECA)
							reclock("SZ9",.f.)
							SZ9->Z9_PEDPECA :=alltrim(_aosimsz9[px,5])+alltrim(_aosimsz9[px,6])
							msunlock()
						Endif
						SZ9->(DBSkip())
					Enddo
				Endif
			Next px
		Else
			_nqtdppec:=_nqtdppec-1
			_nqtditpc:=_nqtditpc-_nqtpcped
			RollBackSx8()
		Endif
	Endif
Next nXEmezenc
Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtecx015b  บAutor  ณ Edson Rodrigues    บ Data ณ  14/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Voltar registros dos IMEIs ao status antigo caso usuario   บฑฑ
ฑฑบ          | venha a clicar em cancelar na tela de TES                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function tecx015b(oDlgAx, lRf)

Local _aAreaZZ4 := ZZ4->(GetArea())

Default lRf := .F.

ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS
_cUpdate := " UPDATE " + RetSqlName("ZZ4")
_cUpdate += " SET    ZZ4_STATUS = '6' "  // Saida Massiva confirmada
_cUpdate += " WHERE  ZZ4_FILIAL = '"+xFilial('ZZ4')+"' AND "
_cUpdate += "        ZZ4_STATUS = '7' AND "  // Saida Massiva lida/apontada
_cUpdate += "        D_E_L_E_T_ = ''  AND "
_cUpdate += "        UPPER(SUBSTRING(ZZ4_SMUSER,1,13)) = '"+Upper(Substr(cUserName,1,13))+"'"

tcSqlExec(_cUpdate)
TCRefresh(RetSqlName("ZZ4"))
RestArea(_aAreaZZ4)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Adapta็ใo para o coletor de dados                                      ณ
//ณ Delta Decisao - DF - 11/10/2011                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRf
	oDlgAx:End()
Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณsalP3alt  บAutor  ณ Edson Rodrigues    บ Data ณ  03/08/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para filtrar os saldos disponiveis do produto alter บฑฑ
ฑฑบ          | nativo                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function salp3alt(_cprodalt,_cclifor,_ccliloj,nsalpalt)

Local _aselpalt := {}
Local _nsapalp3 := 0

if select("P3PALT") > 0
	P3PALT->(dbCloseArea())
Endif


_cQryP3 := " SELECT B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT "
_cQryP3 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
_cQryP3 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
_cQryP3 += "        B6_PRODUTO = '"+_cprodalt+"' AND "
_cQryP3 += "        B6_CLIFOR  = '"+_cclifor+"' AND "
_cQryP3 += "        B6_LOJA    = '"+_ccliloj+"' AND "
_cQryP3 += "        B6_SALDO >= CAST('"+alltrim(str(nsalpalt))+"' AS NUMERIC) AND "   //_cQryP3 += "        B6_SALDO  <> 0 AND "
_cQryP3 += "        B6.D_E_L_E_T_ = '' "
_cQryP3 += " ORDER BY B6_IDENT DESC "
TCQUERY _cQryP3 NEW ALIAS "P3PALT"

P3PALT->(dbGoTop())

While P3PALT->(!Eof()) .and. nsalpalt > 0
	_nsapalp3 := SalDisP3(P3PALT->B6_IDENT, P3PALT->B6_SALDO)
	_nQtRet3 := iif(_nsapalp3 >= nsalpalt, nsalpalt,_nsapalp3)
	
	IF _nQtRet3 > 0
		nsalpalt  := nsalpalt - _nQtRet3
		AADD(_aselpalt,{P3PALT->B6_DOC,P3PALT->B6_SERIE,P3PALT->B6_LOCAL,P3PALT->B6_IDENT,_nQtRet3,P3PALT->B6_PRUNIT})
	Endif
	P3PALT->(dbskip())
Enddo
Return(_aselpalt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMostraKit บAutor  ณDiego Fernandes     บ Data ณ  10/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Lista KITดs cadastrados                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MostraKit(cKit)

Local aSave    := {}
Local nPosicao := 1
Local aCabec   := {"Produto","Descricao"}
Local aKits    := {}
Local aSize    := {15,40}
Local cQuery   := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFiltra produtos que estใo no grupo KITณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT B1_COD, B1_DESC  FROM "+RETSQLNAME("SB1")+" SB1  "
cQuery += " WHERE D_E_L_E_T_ = ''  "
cQuery += " AND  B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " AND LEFT(B1_COD,1) = '*' "
cQuery += " ORDER BY B1_COD  "

If Select("TKIT") > 0
	TKIT->(dbCloseArea())
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), "TKIT", .F., .T.)

dbSelectArea("TKIT")
TKIT->(dbGoTop())

While TKIT->(!Eof())
	AADD( aKits, { TKIT->B1_COD, TKIT->B1_DESC })
	TKIT->(dbSkip())
EndDo

aSave := VTSAVE()
VTClear()
nPosicao := VTaBrowse(0,0,7,19,aCabec,aKits,aSize,,nPosicao)
VtRestore(,,,,aSave)
VTClearBuffer()

Return aKits[nPosicao][1]


Static Function GeraNF(aPedido,_cAglPed, _cSepNfPC)

Local aAreaAtu  := GetArea()
Local aPvlNfs   := {}
Local aBloqueio := {{"","","","","","","",""}}
Local aNotas    := {}
Local cSerie	:=	_cSerNF//"001"
Local aAuxNF	:= {}
Private _cNumEtq:= GETSXENUM("SF2","F2_XNUMETQ") 
ConfirmSX8()                                                                                                      

If _cAglPed == "S"//ApMsgYesNo("Aglutinar Pedidos de Venda na mesma NF?","Aglutinar Pedido de Venda")
	For i:=1 to len(aPedido)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+aPedido[i,1])
			//Liberando Bloqueios do Pedido
			SC9->(dbSetOrder(1))
			If SC9->(dbSeek(xFilial("SC9")+SC5->C5_NUM))
				While !SC9->(Eof()) .AND. xFilial("SC9")+SC9->C9_PEDIDO==xFilial("SC9")+SC5->C5_NUM
					RecLock("SC9",.F.)
					If SC9->C9_BLEST <> "10"
						SC9->C9_BLEST  := ""
					Endif
					If SC9->C9_BLCRED <> "10"
						SC9->C9_BLCRED := ""
					Endif
					SC9->(MsUnlock())
					SC9->(DbSkip())
				EndDo
			Endif
			
			// Checa itens liberados
			IncProc( "Verificando bloqueios para Pedido " + SC5->C5_NUM)
			Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
		Endif
	Next i
	//Verifica se Existe Itens Liberados para gerar a Nota Fiscal
	cNotaFeita :=""
	If Empty(aBloqueio) .And. !Empty(aPvlNfs)
		nItemNf  := a460NumIt(cSerie)
		aadd(aNotas,{})
		// Efetua as quebras de acordo com o numero de itens
		For nX := 1 To Len(aPvlNfs)
			If Len(aNotas[Len(aNotas)])>=nItemNf
				aadd(aNotas,{})
			Endif
			aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
		Next nX
		For nX := 1 To Len(aNotas)
			//Gera a Nota Fiscal
			IncProc( "Gerando Nota Fiscal " )
			cNotaFeita := MaPvlNfs(aNotas[nX],cSerie)
			aADD(aNfOk,{SF2->F2_SERIE,SF2->F2_DOC,_cNumEtq})
			RecLock("SF2",.F.)
			SF2->F2_XNUMETQ := _cNumEtq
			SF2->(MsUnlock())
		Next nX
	Endif 
Else
	For i:=1 to len(aPedido)
		aPvlNfs   := {}
		aBloqueio := {{"","","","","","","",""}}
		aNotas    := {}
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+aPedido[i,1])
			//Liberando Bloqueios do Pedido
			SC9->(dbSetOrder(1))
			If SC9->(dbSeek(xFilial("SC9")+SC5->C5_NUM))
				While !SC9->(Eof()) .AND. xFilial("SC9")+SC9->C9_PEDIDO==xFilial("SC9")+SC5->C5_NUM
					RecLock("SC9",.F.)
					If SC9->C9_BLEST <> "10"
						SC9->C9_BLEST  := ""
					Endif
					If SC9->C9_BLCRED <> "10"
						SC9->C9_BLCRED := ""
					Endif
					SC9->(MsUnlock())
					SC9->(DbSkip())
				EndDo
			Endif
			
			// Checa itens liberados
			IncProc( "Verificando bloqueios para Pedido " + SC5->C5_NUM)
			Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
			
			//Verifica se Existe Itens Liberados para gerar a Nota Fiscal
			cNotaFeita :=""
			If Empty(aBloqueio) .And. !Empty(aPvlNfs)
				nItemNf  := a460NumIt(cSerie)
				aadd(aNotas,{})
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณSepara nota fiscal de pe็as e equipamento ณ
				//ณTICKET: 14057 -D.FERNANDES - 19/09/2013   ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If _cSepNfPC == "S"

					aNfPeca   := {}
					aNfEquip  := {}
     				acomkit   := {}
	            	acomkit   := aclone(aPedido[i,2])
					
				For nX := 1 To Len(aPvlNfs)
                    							
                   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณPosiciona na SC6 para separar equipamento e acessorios ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						dbSelectArea("SC6")
						dbGoto(aPvlNfs[nX][10])
                                                                          
						//Valida a numeracao do pedido, em caso de troca da estrutura do array pela Microsiga
						If Alltrim(SC6->C6_NUM) == Alltrim(aPvlNfs[nX,1])
							If !Empty(SC6->C6_NUMSERI)     
								If len(aNfEquip) == 0 
									aadd(aNfEquip,{})
					Endif
								If Len(aNfEquip[Len(aNfEquip)])>=nItemNf
									aadd(aNfEquip,{})
								EndIf
								//Equipamento
								aadd(aNfEquip[Len(aNfEquip)],aClone(aPvlNfs[nX]))

							// Adicionado Elseif para incluir acessorios / pe็as que vem junto com equipamento e que deverใo sair juntos - Edson Rodrigues - 22/05/14
							Elseif Empty(SC6->C6_NUMSERI) .and. len(acomkit) > 0
							    _nPosckit := aScan(acomkit, { |X| X[1] == SC6->C6_PRODUTO })
							   
							    IF  _nPosckit > 0
							
	                                If len(aNfEquip) == 0 
										aadd(aNfEquip,{})
									Endif							
									If Len(aNfEquip[Len(aNfEquip)])>=nItemNf
										aadd(aNfEquip,{})
									EndIf
									//Equipamento
									aadd(aNfEquip[Len(aNfEquip)],aClone(aPvlNfs[nX]))
							    Else
							    
                                   If len(aNfPeca) == 0 
								     	aadd(aNfPeca,{})								
								   Endif
								   If Len(aNfPeca[Len(aNfPeca)])>=nItemNf
									aadd(aNfPeca,{})
								   EndIf
								   //Acessorios
								   aadd(aNfPeca[Len(aNfPeca)],aClone(aPvlNfs[nX]))							    
							    Endif
							
							Else                                                
								If len(aNfPeca) == 0 
									aadd(aNfPeca,{})								
								Endif
								If Len(aNfPeca[Len(aNfPeca)])>=nItemNf
									aadd(aNfPeca,{})
								EndIf
								//Acessorios
								aadd(aNfPeca[Len(aNfPeca)],aClone(aPvlNfs[nX]))
							EndIf
						Else
							Alert("Erro na separacao da Peca / Equipamento, consulte depto. de T.I.")								
						EndIf							
							
				Next nX
					
					For nX := 1 To Len(aNfEquip)
						//Gera a Nota Fiscal do equipamento
						IncProc( "Gerando Nota Equipamento para Pedido " + SC5->C5_NUM)
						cNotaFeita := MaPvlNfs(aNfEquip[nX],cSerie)
						aADD(aNfOk,{SF2->F2_SERIE,SF2->F2_DOC,_cNumEtq})
						RecLock("SF2",.F.)
						SF2->F2_XNUMETQ := _cNumEtq    
						SF2->(MsUnlock())
						
						//Atualiza mensagem no pedido                            
						nSpace := 0
						If Len(Alltrim(SC5->C5_MENNOTA)) > 0
							nSpace := 1
						EndIf
						
						SC5->(RecLock("SC5",.F.))
						SC5->C5_MENNOTA := Alltrim(SC5->C5_MENNOTA)+Space(nSpace)+"MSG1 referente a nota: " + SF2->F2_DOC
						SC5->(MsUnLock())
					Next nX
					
					For nX := 1 To Len(aNfPeca)
						//Gera a Nota Fiscal dos acessoriso
						IncProc( "Gerando Nota Pe็as para Pedido " + SC5->C5_NUM)
						cNotaFeita := MaPvlNfs(aNfPeca[nX],cSerie)
					aADD(aNfOk,{SF2->F2_SERIE,SF2->F2_DOC,_cNumEtq})
					RecLock("SF2",.F.)
					SF2->F2_XNUMETQ := _cNumEtq
					SF2->(MsUnlock())
				Next nX
																								
				Else           
					If !lPVSwp           
						If Empty(SC5->C5_PVRET)//referente ao pedido de retorno 
							GrvPecRet()// grava o pedido de pe็a no pedido de retorno 
						Else//referente ao pedido de pe็a 
							GrvMNFPC(aAuxNF,nX)	// grava na mensagem para nota do pedido de pe็a, a nota de do pedido de retorno						
						EndIf
					EndIf	
					// Efetua as quebras de acordo com o numero de itens
					For nX := 1 To Len(aPvlNfs)
						If Len(aNotas[Len(aNotas)])>=nItemNf
							aadd(aNotas,{})
						EndIf
						aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
					Next nX
					aAuxNF := {}
					For nX := 1 To Len(aNotas)
						//Gera a Nota Fiscal
						IncProc( "Gerando Nota para Pedido " + SC5->C5_NUM)
						cNotaFeita := MaPvlNfs(aNotas[nX],cSerie)
						aADD(aNfOk,{SF2->F2_SERIE,SF2->F2_DOC,_cNumEtq})
						aADD(aAuxNF,{SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,_cNumEtq})
					Next nX
					AtuSF2(aAuxNF)// grava numero de etiqueta na NF   					
				EndIf
									
			Endif 
		Endif
	Next i
Endif						
RestArea(aAreaAtu)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvPecRet บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvPecRet()
	Local aArea  := GetArea()
	Local cQuery := ""
	
	cQuery := " SELECT C5_NUM FROM " + RetSqlName("SC5") + CRLF
	cQuery += " WHERE C5_PVRET = '" + SC5->C5_NUM + "' " + CRLF
	cQuery += " AND D_E_L_E_T_ <> '*' AND C5_FILIAL = '" + xFilial("SC5") + "' " + CRLF	
	If Select("PCRET") > 0
		PCRET->(dbCloseArea())
	EndIf	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), "PCRET", .F., .T.)	
	dbSelectArea("PCRET")
	PCRET->(dbGoTop())	
	If PCRET->(!Eof()) 
		If RecLock("SC5",.F.)
			SC5->C5_PVPEC := PCRET->C5_NUM
			SC5->(MsUnlock())
		EndIf	
	EndIf	
	RestArea(aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvMNFPC  บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvMNFPC(aAuxNF,nX)
	Local aArea  := GetArea()
	Local cQuery := ""
    
	If Len(aAuxNF) > 0
		If RecLock("SC5",.F.)
			SC5->C5_MENNOTA := Alltrim(SC5->C5_MENNOTA)+" NF: " + Alltrim(aAuxNF[nX-1][2]) + " SERIE: " + Alltrim(aAuxNF[nX-1][1])
			SC5->(MsUnlock())
		EndIf
	EndIf	

	RestArea(aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuSF2   บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuSF2(aAuxNF)
    
	Local aArea := GetArea() 
	
	If Select("SF2") == 0
		DbSelectArea("SF2")
	EndIf
	SF2->(DbSetOrder(2))	
	If Len(aAuxNF) > 0
		For nx:=1 To Len(aAuxNF)	 
			SF2->(DbGoTop())			
			If SF2->(DbSeek(xFilial("SF2")+aAuxNF[nx][3]+aAuxNF[nx][4]+aAuxNF[nx][2]+aAuxNF[nx][1]))				
				If RecLock("SF2",.F.)
					SF2->F2_XNUMETQ := aAuxNF[nx][5]
					SF2->(MsUnlock())
				EndIf
			EndIf 
		Next nx
	EndIf	
	RestArea(aArea)	 
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMENNOTA   บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MENNOTA()
Local aAreaAtu := GetArea()
Local oDlg
Local cFile   := Space( 180 )
Local nOpc    := 0
Local bOk     := { || If( !Empty( cFile ),(nOpc := 1, oDlg:End()), MsgStop( "Informe a Mensagem!" ) ) }
Local bCancel := { || oDlg:End() }
Local cTitle  := "Mensagem Padrใo"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializa tela para selecionar arquivo.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define MSDialog oDlg Title cTitle From 1 , 1 To 100 , 550 Of oMainWnd Pixel
oPanel := TPanel():New( ,,, oDlg )
oPanel:Align := CONTROL_ALIGN_ALLCLIENT
TGroup():New( 02 , 02 , 134 , 274 , "" , oPanel ,,, .T. )
@10 , 05 Say "Informe a Mensagem:" Of oPanel Pixel
@20 , 05 MsGet oGet Var cFile Size 255 , 10 Of oPanel Pixel
Activate MSDialog oDlg On Init EnchoiceBar( oDlg , bOk , bCancel ) Centered
_cMenSC5:= Alltrim(cFile)
RestArea(aAreaAtu)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTRANSP    บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TRANSP()
Local aAreaAtu := GetArea()
Local oDlg
Local cFile   := Space(6)
Local nOpc    := 0
Local bOk     := { || If( !Empty( cFile ),(nOpc := 1, oDlg:End()), MsgStop( "Informe a Transportadora!" ) ) }
Local bCancel := { || oDlg:End() }
Local cTitle  := "Transportadora"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ4ฟ
//ณInicializa tela para selecionar arquivo.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ4ู
Define MSDialog oDlg Title cTitle From 1 , 1 To 100 , 550 Of oMainWnd Pixel
oPanel := TPanel():New( ,,, oDlg )
oPanel:Align := CONTROL_ALIGN_ALLCLIENT
TGroup():New( 02 , 02 , 134 , 274 , "" , oPanel ,,, .T. )
@10 , 05 Say "Informe a Transportadora:" Of oPanel Pixel
@20 , 05 MsGet oGet Var cFile Size 255,10 PICTURE "@!" valid ExistCPO("SA4",cFile)  F3 "SA4" Of oPanel Pixel
Activate MSDialog oDlg On Init EnchoiceBar( oDlg , bOk , bCancel ) Centered
_cTransp:= Alltrim(cFile)
RestArea(aAreaAtu)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERIFSLD  บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VERIFSLD(cKit) 
Local aAreaAtu := GetArea()
Local _cAlmKIT := ""
Local _nQtdZZ4 := 0
Local _nQtdSB6 := 0
Local _nQtdSC6 := 0
Private aEstru 	:= {}
Private nEstru 	:= 0
Private nX 		:= 1
aEstru  := Estrut(cKit)
If Len(aEstru) == 0
	If !lRf
		MsgInfo("O Kit informado nใo possui BOM!","Valida็ใo KIT")
	Else
		DLVTAviso("Valida็ใo KIT", "O Kit informado nใo possui BOM!")
	Endif
	Return(.F.)
Endif
cQryZZ4 := " SELECT ZZ4_CODPRO AS CODPRO, ZZ4_CODCLI AS CODCLI, "
cQryZZ4 += " ZZ4_LOJA AS LOJA, ZZ4_OPEBGH AS OPEBGH, COUNT(*) AS QTDREG  "
cQryZZ4 += " FROM "+ RETSQLNAME("ZZ4")+" (nolock) "
cQryZZ4 += " WHERE ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' AND "
cQryZZ4 += "      ZZ4_STATUS  = '7' AND "  // OS Encerrada
cQryZZ4 += "      ZZ4_PV      = ''  AND "
cQryZZ4 += "      D_E_L_E_T_  = ''  AND "
cQryZZ4 += "      SUBSTRING(ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' "
cQryZZ4 += " GROUP BY ZZ4_CODPRO, ZZ4_CODCLI, ZZ4_LOJA, ZZ4_OPEBGH "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZZ4),"TSQLZZ4",.T.,.T.)
TSQLZZ4->(dbGoTop())
If TSQLZZ4->(!Eof())
	_cAlmKIT := Posicione("ZZJ",1,xFilial("ZZJ") + TSQLZZ4->OPEBGH, "ZZJ_ALMKIT")
	_nQtdZZ4 := TSQLZZ4->QTDREG
	Do While nX <= Len(aEstru)
		_nQtdSB6 := 0
		_nQtdSC6 := 0
		If Alltrim(aEstru[nX,2]) == Alltrim(cKit)  .and. Alltrim(aEstru[nX,3]) <> Alltrim(TSQLZZ4->CODPRO)
			cQrySB6 := " SELECT SUM(B6_SALDO) AS SALDO "
			cQrySB6 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
			cQrySB6 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
			cQrySB6 += "        B6_PRODUTO = '"+aEstru[nX,3]+"' AND "
			cQrySB6 += "        B6_CLIFOR  = '"+TSQLZZ4->CODCLI+"' AND "
			cQrySB6 += "        B6_LOJA    = '"+TSQLZZ4->LOJA+"' AND "
			cQrySB6 += "        B6_SALDO    > 0 AND "
			If !Empty(_cAlmKIT)
				cQrySB6 += "	B6_LOCAL    IN "+FormatIn(_cAlmKIT,";")+" AND "
			Endif
			cQrySB6 += "        B6.D_E_L_E_T_ = '' "
			//* Verifica se a Query Existe, se existir fecha
			If Select("TSQLSB6") > 0
				dbSelectArea("TSQLSB6")
				dbCloseArea()
			Endif
			//* Cria a Query e da Um Apelido
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQrySB6),"TSQLSB6",.F.,.T.)
			dbSelectArea("TSQLSB6")
			dbGoTop()
			If TSQLSB6->SALDO > 0 
				_nQtdSB6 += TSQLSB6->SALDO
				cQrySC6 := " SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTDPED "
				cQrySC6 += " FROM   "+RetSqlName("SC6")+" AS C6 (nolock) "
				cQrySC6 += " INNER JOIN "+RetSqlName("SF4")+" AS SF4 (nolock) "
				cQrySC6 += " 	ON (F4_FILIAL='"+xFilial("SF4")+"' AND F4_CODIGO=C6_TES "
				cQrySC6 += " 	AND SF4.D_E_L_E_T_ = '') "
				cQrySC6 += " WHERE  C6_FILIAL = '"+xFilial("SC6")+"' AND "
				cQrySC6 += "   	C6_CLI	  = '"+TSQLZZ4->CODCLI+"' AND "
				cQrySC6 += "   	C6_LOJA    = '"+TSQLZZ4->LOJA+"' AND "
				cQrySC6 += "	C6_PRODUTO = '"+aEstru[nX,3]+"' AND "
				cQrySC6 += "   	C6_QTDVEN-C6_QTDENT > 0 AND "
				cQrySC6 += "   	F4_PODER3 = 'D' AND " 
				If !Empty(_cAlmKIT)
					cQrySC6 += "	C6_LOCAL    IN "+FormatIn(_cAlmKIT,";")+" AND "
				Endif
				cQrySC6 += "   	C6.D_E_L_E_T_ = '' "
				cQrySC6 += " GROUP BY C6_LOCAL "
				//* Verifica se a Query Existe, se existir fecha
				If Select("TSQLSC6") > 0
					dbSelectArea("TSQLSC6")
					dbCloseArea()
				Endif
				//* Cria a Query e da Um Apelido
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQrySC6),"TSQLSC6",.F.,.T.)
				dbSelectArea("TSQLSC6")
				dbGoTop()
				If TSQLSC6->QTDPED > 0 
					_nQtdSC6 += TSQLSC6->QTDPED
				Endif
				If Select("TSQLSC6") > 0
					dbSelectArea("TSQLSC6")
					dbCloseArea()
				Endif
			Endif
			If Select("TSQLSB6") > 0
				dbSelectArea("TSQLSB6")
				dbCloseArea()
			Endif	
			If (_nQtdSB6-_nQtdSC6) < _nQtdZZ4
				If !lRf
					MsgInfo("O Componente "+Alltrim(aEstru[nX,3])+" nใo possui saldo suficiente!","Saldo")
				Else
					DLVTAviso("Saldo", "O Componente "+AllTrim(aEstru[nX,3])+" nใo possui saldo suficiente!")
				Endif
				_lRetSld := .F.
			Endif
		Endif
		nX++
	Enddo
Endif
If Select("TSQLZZ4") > 0
	dbSelectArea("TSQLZZ4")
	dbCloseArea()
Endif	
RestArea(aAreaAtu)
Return(_lRetSld)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ADDPECA บAutor  ณ                     บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADDPECA(_aIteSC6,cItens)
Local aAreaAtu := GetArea()
Local carmproc :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_ALMEP")
Local cEndAud  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_ENDAUD")
Local cCliDev  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_CLIDEV")
Local cLojDev  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_LOJDEV")
Local cTSPeca  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TSPECA")
Local cAmPeca  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_ARMEST")
Local cTpReent :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TPRENT")  
local cTESPnac :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TESPVP")  // TES PARA ITENS NACIONAIS
local cTESPimp :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TESPIM")  // TES PARA ITENS IMPORTADO
Local cCGCDev  :=Posicione("SA1",1,xFilial("SA1") + cCliDev + cLojDev, "A1_CGC")
Local nSaldoBF := 0
Local ltesp3 := .F.
If Posicione("SF4",1,xFilial("SF4") + cTSPeca, "F4_PODER3") <> "N" 
     ltesp3 := .T.
endif     
     

cQrySZ9 := " SELECT "
cQrySZ9 += " Z9_PARTNR,Z9_NUMOS,Z9_SEQ,Z9_PRCCALC, SUM(Z9_QTY) AS Z9_QTY " 	
cQrySZ9 += " FROM  "+ RETSQLNAME("SZ9")+" SZ9 (nolock) "
cQrySZ9 += " WHERE Z9_FILIAL = '"+xFilial("SZ9")+"' "              
cQrySZ9 += " AND SZ9.D_E_L_E_T_ = '' "
cQrySZ9 += " AND Z9_PARTNR<>'' "
cQrySZ9 += " AND Z9_NUMOS='"+(cAliasTop5)->ZZ4_OS+"' " 
cQrySZ9 += " AND Z9_IMEI='"+(cAliasTop5)->ZZ4_IMEI+"' " 
cQrySZ9 += " GROUP BY Z9_PARTNR,Z9_NUMOS,Z9_SEQ,Z9_PRCCALC "	
cQrySZ9 += " ORDER BY Z9_PARTNR "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySZ9),"TSQLSZ9",.T.,.T.)
TSQLSZ9->(dbGoTop())


While TSQLSZ9->(!Eof())
	_nSaldo := TSQLSZ9->Z9_QTY
	
	
	IF ltesp3
	dbSelectArea("SB6")
	SB6->(dbSetOrder(1)) //B6_FILIAL + B6_PRODUTO + B6_CLIFOR + B6_LOJA + B6_IDENT
			
			
			
	_cQrySB6 := " SELECT B6_PRODUTO,B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT "
	_cQrySB6 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
	_cQrySB6 += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 (nolock) " 
	_cQrySB6 += " ON (A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD=B6_CLIFOR AND A1_LOJA=B6_LOJA "
	_cQrySB6 += " AND LEFT(A1_CGC,8)='"+LEFT(cCGCDev,8)+"' AND SA1.D_E_L_E_T_='') "
	_cQrySB6 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
	_cQrySB6 += "        B6_PRODUTO = '"+TSQLSZ9->Z9_PARTNR+"' AND "
/*
	_cQrySB6 += "        B6_CLIFOR  = '"+cCliDev+"' AND "
	_cQrySB6 += "        B6_LOJA    = '"+cLojDev+"' AND "
	_cQrySB6 += "        B6_SALDO >= CAST('"+AllTrim(str(_nSaldo))+"' AS NUMERIC) AND "
*/
	_cQrySB6 += "        B6_SALDO > 0 AND " 
	_cQrySB6 += "B6_LOCAL ='"+cAmPeca+"' AND "    // Corrigido por Rodrigo Salomใo devido a tratamento de armazem que nao possuia
	_cQrySB6 += "B6.D_E_L_E_T_ = '' "
	_cQrySB6 += " ORDER BY B6_IDENT "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySB6),"TSQLSB6",.T.,.T.)
			
			
	TSQLSB6->(dbGoTop())
			
			
			IF(TSQLSB6->(Eof()))  .AND. _coperbgh=="P04"
			
			     If Select("TSQLSB6") > 0
             		dbSelectArea("TSQLSB6")
               		dbCloseArea()
                 Endif	
			
				_cQrySB6 := " SELECT B6_PRODUTO,B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT "
				_cQrySB6 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
				_cQrySB6 += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 (nolock) " 
				_cQrySB6 += " ON (A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD=B6_CLIFOR AND A1_LOJA=B6_LOJA "
				_cQrySB6 += " AND LEFT(A1_CGC,8)='"+LEFT(cCGCDev,8)+"' AND SA1.D_E_L_E_T_='') "
				_cQrySB6 += " INNER JOIN 
                _cQrySB6 += " ( SELECT * FROM NFPOSITIVOETICKET48) AS NF48
                _cQrySB6 += " ON B6_FILIAL='"+xFilial("SB6")+"' AND RTRIM(B6_DOC)=RTRIM(NF) AND RTRIM(SERIE)=RTRIM(B6_SERIE) AND RTRIM(B6_LOCAL)=RTRIM(ARMAZEM) AND RTRIM(B6_PRODUTO)=RTRIM(PRODUTO)
     			_cQrySB6 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
				_cQrySB6 += "        B6_PRODUTO = '"+TSQLSZ9->Z9_PARTNR+"' AND "
				_cQrySB6 += "        B6_SALDO > 0 AND " 
				_cQrySB6 += "B6_LOCAL ='48' AND "  
				_cQrySB6 += "B6.D_E_L_E_T_ = '' "
				_cQrySB6 += " ORDER BY B6_IDENT "
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySB6),"TSQLSB6",.T.,.T.)
				
			ENDIF	
			TSQLSB6->(dbGoTop())
			
			
			
	While TSQLSB6->(!Eof()) .and. _nSaldo > 0 
		_nSalP3  := SalDisP3(TSQLSB6->B6_IDENT, TSQLSB6->B6_SALDO)
		_nQtRet3 := iif(_nSalP3 >= _nSaldo, _nSaldo, _nSalP3)
		IF _nQtRet3 > 0
			cItens   := Soma1(cItens,2)
			_nSaldo  := _nSaldo - _nQtRet3
			_nPrcVen := A410Arred(TSQLSB6->B6_PRUNIT,"C6_VALOR")
			_nValor  := A410Arred(TSQLSB6->B6_PRUNIT * _nQtRet3,"C6_VALOR")
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+TSQLSB6->B6_PRODUTO)
			dbSelectArea("SB2")
			dbSetOrder(1)
			SB2->(DBSeek(xFilial("SB2") + SB1->B1_COD + carmproc))
			_nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
			_nSaldoBF := 0
			_nSaldoBF :=  SaldoSBF(carmproc, cEndAud, SB1->B1_COD, NIL, NIL, NIL, .F.)
			If SB1->B1_LOCALIZ=="S"
				Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens			        ,Nil},;
						{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
						{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
						{"C6_TES"		,cTSPeca						,Nil},;
						{"C6_QTDVEN"	,_nQtRet3				  		,Nil},;
						{"C6_QTDLIB"	,IIF(_clibPvS="S" .and. _nSaldoBF >= _nQtRet3, _nQtRet3, 0) ,Nil},;
						{"C6_NUMSERI"	,""                 			,Nil},;
						{"C6_NUMOS"		,""						        ,Nil},;
						{"C6_PRCVEN"	,_nPrcVen						,Nil},;
						{"C6_VALOR"		,_nValor			   			,Nil},;
						{"C6_PRUNIT"	,_nPrcVen						,Nil},;
						{"C6_NFORI"		,TSQLSB6->B6_DOC				,Nil},;
						{"C6_SERIORI"	,TSQLSB6->B6_SERIE				,Nil},;
						{"C6_ITEMORI"	,""								,Nil},;
						{"C6_IDENTB6"	,TSQLSB6->B6_IDENT				,Nil},;
						{"C6_PRCCOMP"	,0								,Nil},;
						{"C6_LOCAL"		,carmproc						,Nil},;
						{"C6_ENTREG"	,dDataBase						,Nil},;
						{"C6_OSGVS"		,""								,Nil},;
						{"C6_AIMPGVS"	,""								,Nil},;
						{"C6_LOCALIZ"	,cEndAud						,Nil}})
			Else 
				Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens			        ,Nil},;
						{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
						{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
						{"C6_TES"		,cTSPeca						,Nil},;
						{"C6_QTDVEN"	,_nQtRet3				  		,Nil},;
						{"C6_QTDLIB"	,IIF(_clibPvS="S" .and. _nSalb2 >= _nQtRet3, _nQtRet3, 0) ,Nil},;
						{"C6_NUMSERI"	,""                 			,Nil},;
						{"C6_NUMOS"		,""					            ,Nil},;
						{"C6_PRCVEN"	,_nPrcVen						,Nil},;
						{"C6_VALOR"		,_nValor			   			,Nil},;
						{"C6_PRUNIT"	,_nPrcVen						,Nil},;
						{"C6_NFORI"		,TSQLSB6->B6_DOC				,Nil},;
						{"C6_SERIORI"	,TSQLSB6->B6_SERIE				,Nil},;
						{"C6_ITEMORI"	,""								,Nil},;
						{"C6_IDENTB6"	,TSQLSB6->B6_IDENT				,Nil},;
						{"C6_PRCCOMP"	,0								,Nil},;
						{"C6_LOCAL"		,carmproc						,Nil},;
						{"C6_ENTREG"	,dDataBase						,Nil},;
						{"C6_OSGVS"		,""								,Nil},;
						{"C6_AIMPGVS"	,""								,Nil},;
						{	,											,Nil}})
			Endif
		Endif
		TSQLSB6->(dbSkip())
	Enddo
			
	ENDIF
	
	
	
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺฟ
	//ณNao encontrou nota origem.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺู
	If _nSaldo > 0 .and. !ltesp3
	
		cItens   := Soma1(cItens,2)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+TSQLSZ9->Z9_PARTNR)
		If cTpReent <> "2"
		If SB1->B1_LOCALIZ=="S"				
			Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens			        ,Nil},;
					{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
					{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
					{"C6_TES"		,cTSPeca						,Nil},;
					{"C6_QTDVEN"	,_nSaldo				  		,Nil},;
					{"C6_QTDLIB"	,0								,Nil},;
					{"C6_NUMSERI"	,""                 			,Nil},;
					{"C6_NUMOS"		,""					            ,Nil},;
					{"C6_PRCVEN"	,1								,Nil},;
					{"C6_VALOR"		,_nSaldo*1			   			,Nil},;
					{"C6_PRUNIT"	,1								,Nil},;
					{"C6_NFORI"		,""								,Nil},;
					{"C6_SERIORI"	,""								,Nil},;
					{"C6_ITEMORI"	,""								,Nil},;
					{"C6_IDENTB6"	,""								,Nil},;
					{"C6_PRCCOMP"	,0								,Nil},;
					{"C6_LOCAL"		,carmproc						,Nil},;
					{"C6_ENTREG"	,dDataBase						,Nil},;
					{"C6_OSGVS"		,""								,Nil},;
					{"C6_AIMPGVS"	,""								,Nil},;
					{"C6_LOCALIZ"	,cEndAud						,Nil}})
		Else 
				Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens			        ,Nil},;
					{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
					{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
					{"C6_TES"		,cTSPeca						,Nil},;
					{"C6_QTDVEN"	,_nSaldo				  		,Nil},;
					{"C6_QTDLIB"	,0								,Nil},;
					{"C6_NUMSERI"	,""                 			,Nil},;
					{"C6_NUMOS"		,""					            ,Nil},;
					{"C6_PRCVEN"	,1								,Nil},;
					{"C6_VALOR"		,_nSaldo*1			   			,Nil},;
					{"C6_PRUNIT"	,1								,Nil},;
					{"C6_NFORI"		,""								,Nil},;
					{"C6_SERIORI"	,""								,Nil},;
					{"C6_ITEMORI"	,""								,Nil},;
					{"C6_IDENTB6"	,""								,Nil},;
					{"C6_PRCCOMP"	,0								,Nil},;
					{"C6_LOCAL"		,carmproc						,Nil},;
					{"C6_ENTREG"	,dDataBase						,Nil},;
					{"C6_OSGVS"		,""								,Nil},;
					{"C6_AIMPGVS"	,""								,Nil},;
					{	,											,Nil}})
		Endif
		Else
			IF  SB1->B1_ORIGEM = "1"
			      cTSPeca :=cTESPimp
			ELSE       
			      cTSPeca :=cTESPnac
			ENDIF
			cendaud  := AllTrim(cendaud)+ space(TamSX3("BE_LOCALIZ")[1]-len(AllTrim(cendaud)))
			Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens	        				,Nil},;
							{"C6_PRODUTO"	,SB1->B1_COD 					,Nil},;
							{"C6_DESCRI"	,SB1->B1_DESC   				,Nil},;
							{"C6_TES"		,cTSPeca	    				,Nil},;
							{"C6_QTDVEN"	,_nSaldo		  				,Nil},;
							{"C6_QTDLIB"	,IIF(_clibPvS="S",_nSaldo,0)	,Nil},;
							{"C6_NUMSERI"	,""    							,Nil},;				
							{"C6_NUMOS"		,LEFT(TSQLSZ9->Z9_NUMOS,6)      ,Nil},;
							{"C6_PRCVEN"	,TSQLSZ9->Z9_PRCCALC			,Nil},;
							{"C6_VALOR"		,TSQLSZ9->Z9_PRCCALC*_nSaldo	,Nil},;
							{"C6_PRUNIT"	,TSQLSZ9->Z9_PRCCALC  		 	,Nil},;
							{"C6_NFORI"		,""             				,Nil},;
							{"C6_SERIORI"	,""             				,Nil},;
							{"C6_ITEMORI"	,""             				,Nil},;
							{"C6_IDENTB6"	,""								,Nil},;
							{"C6_PRCCOMP"	,0								,Nil},;
							{"C6_LOCAL"		,carmproc        				,Nil},;
							{"C6_ENTREG"	,dDataBase  					,Nil},;
							{"C6_OSGVS"		,""             				,Nil},;
							{"C6_AIMPGVS"	,""		        				,Nil},;
							{"C6_LOCALIZ"	,""		      					,Nil},;
							{"PRODIMEI"	    ,SB1->B1_COD      				,Nil},;
							{"SEQSZ9"	    ,TSQLSZ9->Z9_SEQ   				,Nil}})
		EndIf
	Endif
	If Select("TSQLSB6") > 0
		dbSelectArea("TSQLSB6")
		dbCloseArea()
	Endif	
	TSQLSZ9->(DBSkip())	
EndDo
If Select("TSQLSZ9") > 0
	dbSelectArea("TSQLSZ9")
	dbCloseArea()
Endif	
RestArea(aAreaAtu)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GERAZZQ บAutor  ณ                     บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GERAZZQ()
Local aAreaAtu := GetArea()
Local cTSPeca  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TSPECA")



For i:=1 To Len(aPedZZQ)
	cQrySC6 := " SELECT "
	cQrySC6 += " C6_NUM AS PEDPA,C6_PRODUTO AS PRODUTO, "
	cQrySC6 += " C6_NUMSERI AS IMEI,C6_NUMOS AS NUMOS "
	cQrySC6 += " FROM "+ RETSQLNAME("SC6")+" SC6 (nolock) "
	cQrySC6 += " WHERE "
	cQrySC6 += " C6_FILIAL = '"+xFilial("SC6")+"' "              
	cQrySC6 += " AND SC6.D_E_L_E_T_ = '' "
	cQrySC6 += " AND C6_NUM = '"+aPedZZQ[i]+"' "
	cQrySC6 += " AND C6_NUMSERI+C6_NUMOS <> '' "
	cQrySC6 += " AND C6_TES <> '"+cTSPeca+"' " 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC6),"TSQLSC6",.T.,.T.)
	TSQLSC6->(dbGoTop())
	If TSQLSC6->(!Eof())
	
	
	
		cQryPec := " SELECT "
		cQryPec += " C6_PRODUTO AS PECA,C6_QTDVEN AS QTDE,C6_PRCVEN AS VLUNIT,C6_VALOR AS VLTOTAL, "
		cQryPec += " C6_NUM AS PEDPECA,C6_ITEM AS ITPECA,C6_NFORI AS NFORI,C6_SERIORI AS SERIORI, "
		cQryPec += " C6_IDENTB6 AS IDENT, C6_CLI AS CLISAI, C6_LOJA AS LOJSAI "
		cQryPec += " FROM "+ RETSQLNAME("SC6")+" SC6 (nolock) "
		cQryPec += " WHERE "
		cQryPec += " C6_FILIAL ='"+xFilial("SC6")+"' "             
		cQryPec += " AND C6_NUM='"+TSQLSC6->PEDPA+"' " 
		cQryPec += " AND C6_TES = '"+cTSPeca+"' " 
		cQryPec += " AND SC6.D_E_L_E_T_ = '' "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPec),"TSQLPEC",.T.,.T.)
		TSQLPEC->(dbGoTop())
		While TSQLPEC->(!Eof())
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+TSQLSC6->PRODUTO)
			dbSelectArea("SB6")
			dbSetOrder(3)
			dbSeek(xFilial("SB6")+TSQLPEC->IDENT+TSQLPEC->PECA+"R")
			Begin Transaction
		    Reclock("ZZQ",.t.)
		    ZZQ->ZZQ_FILIAL := xFilial("ZZQ")
		    ZZQ->ZZQ_IMEI   := TSQLSC6->IMEI
		    ZZQ->ZZQ_NUMOS  := LEFT(TSQLSC6->NUMOS,6)
			ZZQ->ZZQ_MODELO := TSQLSC6->PRODUTO
			ZZQ->ZZQ_CODEST := SB1->B1_GRUPO
			ZZQ->ZZQ_DTSAID := dDataBase
			ZZQ->ZZQ_PV     := TSQLPEC->PEDPECA
			ZZQ->ZZQ_ITEMPV := TSQLPEC->ITPECA
			ZZQ->ZZQ_CLISAI := TSQLPEC->CLISAI
			ZZQ->ZZQ_LOJSAI := TSQLPEC->LOJSAI
			ZZQ->ZZQ_PECA   := TSQLPEC->PECA
			ZZQ->ZZQ_QTDE   := TSQLPEC->QTDE
			ZZQ->ZZQ_VLRUNI := TSQLPEC->VLUNIT
			ZZQ->ZZQ_VLRTOT := TSQLPEC->VLTOTAL
			ZZQ->ZZQ_NFORI  := TSQLPEC->NFORI
			ZZQ->ZZQ_SERORI := TSQLPEC->SERIORI
			ZZQ->ZZQ_CLIORI := SB6->B6_CLIFOR
			ZZQ->ZZQ_LOJORI := SB6->B6_LOJA
			ZZQ->ZZQ_OPEBGH := _coperbgh
			msunlock()
			End Transaction 
			TSQLPEC->(DBSkip())	
		EndDo 
		If Select("TSQLPEC") > 0
			dbSelectArea("TSQLPEC")
			dbCloseArea()
		Endif	
	Endif
	If Select("TSQLSC6") > 0
		dbSelectArea("TSQLSC6")
		dbCloseArea()
	Endif	
Next i
RestArea(aAreaAtu)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GRPCZZQ บAutor  ณ                     บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GRPCZZQ(aPVZZQ)

Local aAreaAtu := GetArea()
Local cTSPeca  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TSPECA")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤWฟ
//ณVinicius Leonardo - Delta Decisใo                        ณ
//ณInserindo a verifica็ใo do TES informado na opera็ใo,    ณ
//ณo tipo de reentrada ( asseguradoras, poder de terceiro,  ณ
//ณdevolu็ใo, etc), com a finalidade de fazer uma integra็ใoณ
//ณno processamento entre os tipos , para tornar o processo ณ
//ณmais dinโmico e de fแcil manuseio.                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤWู

Local cTESPnac :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TESPVP")  // TES PARA ITENS NACIONAIS
Local cTESPimp :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TESPIM")  // TES PARA ITENS IMPORTADO
Local cTpReent :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_TPRENT")  // 1=P3 ; 2=ASSEGURADORAS(SEM P3) ; 3=DEVOLUวรO

For i:=1 To Len(aPVZZQ)	
	
	cQryPec := " SELECT " + CRLF
	cQryPec += " C5_PVRET AS PVRETORNO,C6_PRODUTO AS PECA,C6_QTDVEN AS QTDE,C6_PRCVEN AS VLUNIT,C6_VALOR AS VLTOTAL, " + CRLF
	cQryPec += " C6_NUM AS PEDPECA,C6_ITEM AS ITPECA,C6_NFORI AS NFORI,C6_SERIORI AS SERIORI, " + CRLF
	cQryPec += " C6_IDENTB6 AS IDENT, C6_CLI AS CLISAI, C6_LOJA AS LOJSAI " + CRLF
	cQryPec += " FROM "+ RETSQLNAME("SC6")+" SC6 (nolock) " + CRLF
	cQryPec += " INNER JOIN "+ RETSQLNAME("SC5")+" SC5 (nolock) " + CRLF
	cQryPec += " ON SC5.C5_NUM = SC6.C6_NUM " + CRLF  
	cQryPec += " WHERE " + CRLF
	cQryPec += " C6_FILIAL ='"+xFilial("SC6")+"' " + CRLF 
	cQryPec += " AND C5_FILIAL ='"+xFilial("SC5")+"' " + CRLF
	cQryPec += " AND C6_NUM='"+aPVZZQ[i]+"' " + CRLF
	cQryPec += " AND C6_TES IN ('"+cTSPeca+"','"+cTESPnac+"','"+cTESPimp+"') " + CRLF
	cQryPec += " AND SC6.D_E_L_E_T_ = '' " + CRLF 
	cQryPec += " AND SC5.D_E_L_E_T_ = '' " + CRLF
	 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPec),"TSQLPEC",.T.,.T.) 
	
	TSQLPEC->(dbGoTop())
	While TSQLPEC->(!Eof())
	
		cQrySC6 := " SELECT " + CRLF
		cQrySC6 += " C6_NUM AS PEDPA,C6_PRODUTO AS PRODUTO, " + CRLF
	    cQrySC6 += " C6_NUMSERI AS IMEI,C6_NUMOS AS NUMOS " + CRLF
	    cQrySC6 += " FROM "+ RETSQLNAME("SC6")+" SC6 (nolock) " + CRLF 
	    cQrySC6 += " INNER JOIN "+ RETSQLNAME("SC5")+" SC5 (nolock) " + CRLF
	    cQrySC6 += " ON SC5.C5_NUM = SC6.C6_NUM " + CRLF  
		cQrySC6 += " WHERE " + CRLF
		cQrySC6 += " C6_FILIAL ='"+xFilial("SC6")+"' " + CRLF 
		cQrySC6 += " AND C5_FILIAL ='"+xFilial("SC5")+"' " + CRLF
		cQrySC6 += " AND C5_NUM='"+TSQLPEC->PVRETORNO+"' " + CRLF 
		cQrySC6 += " AND C6_TES NOT IN ('"+cTSPeca+"','"+cTESPnac+"','"+cTESPimp+"') " + CRLF
		cQrySC6 += " AND SC6.D_E_L_E_T_ = '' " + CRLF	
		cQrySC6 += " AND SC5.D_E_L_E_T_ = '' " + CRLF
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC6),"TSQLSC6",.T.,.T.) 
		
		TSQLSC6->(dbGoTop())
		If TSQLSC6->(!Eof())
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+TSQLSC6->PRODUTO)
			dbSelectArea("SB6")
			dbSetOrder(3)
			dbSeek(xFilial("SB6")+TSQLPEC->IDENT+TSQLPEC->PECA+"R")
			Begin Transaction
			Reclock("ZZQ",.T.)
			ZZQ->ZZQ_FILIAL := xFilial("ZZQ")
			ZZQ->ZZQ_IMEI   := TSQLSC6->IMEI
			ZZQ->ZZQ_NUMOS  := LEFT(TSQLSC6->NUMOS,6)
			ZZQ->ZZQ_MODELO := TSQLSC6->PRODUTO
			ZZQ->ZZQ_CODEST := SB1->B1_GRUPO
			ZZQ->ZZQ_DTSAID := dDataBase
			ZZQ->ZZQ_PV     := TSQLPEC->PEDPECA
			ZZQ->ZZQ_ITEMPV := TSQLPEC->ITPECA
			ZZQ->ZZQ_CLISAI := TSQLPEC->CLISAI
			ZZQ->ZZQ_LOJSAI := TSQLPEC->LOJSAI
			ZZQ->ZZQ_PECA   := TSQLPEC->PECA
			ZZQ->ZZQ_QTDE   := TSQLPEC->QTDE
			ZZQ->ZZQ_VLRUNI := TSQLPEC->VLUNIT
			ZZQ->ZZQ_VLRTOT := TSQLPEC->VLTOTAL
			ZZQ->ZZQ_NFORI  := TSQLPEC->NFORI
			ZZQ->ZZQ_SERORI := TSQLPEC->SERIORI
			If cTpReent <> "2"
				ZZQ->ZZQ_CLIORI := SB6->B6_CLIFOR
				ZZQ->ZZQ_LOJORI := SB6->B6_LOJA 
			EndIf
			ZZQ->ZZQ_OPEBGH := _coperbgh
			msunlock()
			End Transaction			
		EndIf
		If Select("TSQLSC6") > 0
			dbSelectArea("TSQLSC6")
			dbCloseArea()
		EndIf
		TSQLPEC->(dbSkip())
	EndDo
	If Select("TSQLPEC") > 0
		dbSelectArea("TSQLPEC")
		dbCloseArea()
	EndIf
Next i
RestArea(aAreaAtu)
Return   

/*                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GetSerie บAutor  ณ Uiran Almeida      บ Data ณ 17 /10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao utilizada para Validar qual o numero de serie sera  บฑฑ
ฑฑบ          ณ usada na nota fiscal                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetSerie(cOperacao)

Local cSerie   := ""
Local Ope	   := Alltrim(cOperacao)
Local aAreaZZJ := GetArea("ZZJ")
Local cMvSerie := Alltrim(GetMV("BH_SERI004"))

DbSelectArea("ZZJ")
ZZJ->(DbSetOrder(1)) //ZZJ_FILIAL, ZZJ_OPERA, ZZJ_LAB

If ZZJ->(DbSeek( xFilial("ZZJ") + Ope))
   cSerie := (ZZJ->ZZJ_NFSSER)
   IF empty(cSerie)
	If(cFilAnt == "02")
		cSerie := IIF(Ope $ cMvSerie,"4","1")
	Else
    		MsgInfo("Nao existe a serie da NF de saida definida para a operacao : "+Ope+" . Favor entrar em contato o administrador do sistema.","Serie NFS")
	EndIf
EndIf
EndIf

RestArea(aAreaZZJ)
Return cSerie
