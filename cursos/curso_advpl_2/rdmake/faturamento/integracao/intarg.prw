#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#INCLUDE "topconn.ch"
#include "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ        
ฑฑบPrograma  ณINTARG    บ Autor ณ Edson Rodrigues    บ Data ณ  ABRIL/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Prgrama para intergrar os dados para Comshare-AR           บฑฑ
ฑฑบ          ณ    Microsiga X Comshare                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User function INTARG()      

// u_GerA0003(ProcName()) Desabilitado apos entrada da versao p11 - Edson Rodrigues - 19/03/13


SLEEP(180)
                                              
ConOut("*")
ConOut("*")
ConOut("*")
ConOut(Replicate("*",40)) 
ConOut("   [INTARG] - "+dtoc(date())+" "+time()) 
ConOut("   [INTARG] Montando ambiente Enviroment empresa/filial 02/01...")


PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" TABLES "SD1","SD2","SC5","SC6","SF1","SD1","SB1","SBM","SA1","SX5","SA3","SC9","SC7","SZI","SZJ","ZZH"

Private aAlias      := {"SD1","SD2","SC5","SC6","SF1","SD1","SB1","SBM","SA1","SX5","SA3","SC9","SC7"}
Private _ageral     :={}
Private _avenda     :={}
Private _aestoq     :={}
Private _aResult    :={}
Private _cArqTrab   := CriaTrab(,.f.)
Private _cArqTra7  := CriaTrab(,.F.)
Private _Ddataini   := GetMV("MV_DINIRAR")
Private _cinprbgh	:= GetMV("MV_INPROBG")
Private _carmdist	:= GetMV("MV_ARMDIST")
Private _carmprop	:= GetMV("MV_ARMPBGH")
Private _carmpven	:= GetMV("MV_ARMPVEN")
Private _cfventot	:= GetMV("MV_CFTVEND")
Private _cfdevtot	:= GetMV("MV_CFTDEV")
Private _cfiliais	:= GetMV("MV_FILIAIS")
Private _carmpv2    := SUBSTR(_carmpven,3,len(alltrim(_carmpven))-4)+","+SUBSTR(_carmdist,3,len(alltrim(_carmdist))-4)
Private _cregiao    := "0001"
Private _ccompan    := "00029"
Private _cunmval    := "REA"
Private _cunmuni    := "UNI"
//conceitos de vendas possiveis usuados pela BGH //
Private _cconc1     :="VENTA"  /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
Private _cconc2     :="RSFAC"  /*(PEDIDOS APROVADOS) - Sใo vendas onde a  mercadoria ja foi remitidas e ainda nใo faturadas exemplo B2W (consigna็ใo/Venda futura) */
Private _cconc3     :="PPAPR"  /* (PEDIDOS APROVADOS) - Sใo Pedidos liberados sem nenhuma restri็ใo (cr้dito ou estoque), porem ainda nao faturados */
Private _cconc4     :="PPCRE"  /*// 	(PEDIDOS NรO APROVADOS)  Pedidos Liberados ou nใo, nใo faturados e que necessitam de aprovacao de credito  */
Private _cconc5     :="PPBOSR" /*  (PEDIDOS NรO APROVADOS)  Pedidos Liberados, nใo faturados e que necessitam de  aprovacao de Estoque */
Private _cconc6     :="PPBOCR" /*	(PEDIDOS NรO APROVADOS) - Sใo Pedidos Liberados, nใo faturados e que necessitam aprova็ใo de cr้dito e Estoque )*/
//conceitos de Estoque possiveis usuados pela BGH //
Private  _cconc7    :="STKEMS"  /*Estoque comprometido, jแ descontado do estoque disponํvel, ou seja Reservas e e Pedidos Empenhados*/
Private  _cconc8    :="STKDIS"  /*Estoque Disponํvel para Vendas */
Private  _cconc9    :="STTRFA"  /*Estoque em transito que devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
Private  _ccon10    :="STTRNF"  /*Pendente sem pedidos de compra que nใo devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
Private  _ccon11    :="SPFISF"  /*Pendente sem pedidos de compra que devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
Private  _ccon12    :="SPFINF"  /*Estoque Pendente de Fabricao/importacao que NAO devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
Private  _ccon13    :="FISFAB"  /*Estoque disponivel na fแbrica do Fabricante, mas que ainda nใo esta sendo transportado*/
Private _lLibSC7    :=.f.
Private _lLibSC9    :=.f.
Private _lblqcred   :=.t.
Private _lblqestq   :=.t.
private CR	 		:= chr(13) + chr(10)
Private _carmpv3    :=""
Private _cchave     :=""
Private _nctr       :=0
Private nTotal      := 0
Private _nperiod    := SUBSTR(_Ddataini,1,4)+SUBSTR(_Ddataini,5,2)
Private _dmes       := SUBSTR(DTOC(ddatabase),4,2)
Private _ddia       := SUBSTR(DTOC(ddatabase),1,2)
Private _nperi2     := SUBSTR((DTOS(ddatabase)),1,4)+SUBSTR(DTOC(ddatabase),4,2)
Private _lvper      :=iif((_ddia < '30' .or.  (_ddia < '28' .and.  _dmes ='02')),.t.,.f.)
Private _nvalor     := 0.00                                            
                                                                                                        



//Remove os aspas e virgulas da variavel e substitui por barras
for x:=1 to len(_carmpv2)
	if !substr(_carmpv2,x,1) $ "'/,"
		_carmpv3 +=substr(_carmpv2,x,1)
		_nctr :=0
	else
		_nctr += 1
		If _nctr = 1
			_carmpv3 +="/"
			_nctr += 1
		Endif
	Endif
Next

if (_nperiod <> _nperi2) .and. _ddia > '01'

	PutMv("MV_DINIRAR",_nperi2+"01")
	
Endif

*
ConOut("   [INTARG] Posicionando tabelas acessorias...")
*                                                       

//Abre as tabelas a serem usadas
dbSelectArea("SC6")
//DbSetOrder(9)  //C6_FILIAL+C6_NUMSERI
SC6->(DBOrderNickName('SC6IMEI'))// C6_FILIAL + C6_NUMSERI

dbSelectArea("SA1")
DbSetOrder(1) //A1_FILIAL+A1_COD+A1_LOJA

dbSelectArea("SA3")
DbSetOrder(1) //A3_FILIAL+A3_COD+A3_LOJA


dbSelectArea("SC9")
DBSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

dbSelectArea("SC7")
DBSetOrder(2) //C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM

dbSelectArea("SD1")
DbSetOrder(6) //D1_FILIAL+DTOS(D1_DTDIGITE)+D1_NUMSEG

dbSelectArea("SB1")
DbSetOrder(1) //B1_FILIAL+B1_COD

dbSelectArea("SBM")
DbSetOrder(1) //BM_FILIAL+BM_Grupo

dbSelectArea("SD2")
DbSetOrder(5) //D2_FILIAL+DTOS(D2_EMISSAO)+D2_NUMSEQ

dbSelectArea("SF2")
DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

dbSelectArea("SZI")
DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

dbSelectArea("SZJ")
DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
                              
dbSelectArea("ZZH")
DbSetOrder(1) 


*
ConOut("   [INTARG] Executando a store Procedure AFTER_MICROSIGA_PROCESS...")
*

_cStr := "AFTER_MICROSIGA_PROCESS"
if TCSPExist(_cStr)
	TCSqlExec(_cStr)
Else
	conout("Srtore Procedure nใo encontrada.")
	//Colocado para executar a procedure, pois a funcao TCSPEXIST nao encontra a procedure mesmo a mesma existindo. 13/05/10 Edson Rodrigues
	TCSqlExec(_cStr)
Endif                


*
ConOut("   [INTARG] Executando a store Procedure ACERTA_CADASTROS...")
*                                         
_cStr := "ACERTA_CADASTROS"
if TCSPExist(_cStr)
	TCSqlExec(_cStr)
Else
	conout("Srtore Procedure nใo encontrada.")
	//Colocado para executar a procedure, pois a funcao TCSPEXIST nao encontra a procedure mesmo a mesma existindo. 13/05/10 Edson Rodrigues
	TCSqlExec(_cStr)
Endif


*
ConOut("   [INTARG] Deletando dados do periodo das tabelas de Saida de dados para Replicacao : OUT_MAE_PRODUCTOS,OUT_MAE_CLIENTES,OUT_MAE_VENDEDORES e DELETE OUT_DATOS_BI ")
*                                         
/* deleta tabela OUT_MAE_PRODUCTOS      */
_cQuery := " DELETE OUT_MAE_PRODUCTOS"
TCSQLEXEC ( _cQuery )
TCRefresh("OUT_MAE_PRODUCTOS")

/* deleta tabela OUT_MAE_CLIENTES      */
_cQuery := " DELETE OUT_MAE_CLIENTES"
TCSQLEXEC ( _cQuery )
TCRefresh("OUT_MAE_CLIENTES")

/* deleta tabela OUT_MAE_VENDEDORES      */
_cQuery := " DELETE OUT_MAE_VENDEDORES"
TCSQLEXEC ( _cQuery )
TCRefresh("OUT_MAE_VENDEDORES")

/* deleta tabela OUT_DATOS_BI      */
_cQuery := " DELETE OUT_DATOS_BI"
_cQuery += " WHERE PERIODO="+_nperiod+""
TCSQLEXEC ( _cQuery )
TCRefresh("OUT_DATOS_BI")



*
ConOut("   [INTARG] Deletando dados do periodo das tabelas Acessoria de conferencia : SZI  e SZJ ")
*                                         
/* Marca como deletado a tabela SZI - Vendas     */
_cQuery := " UPDATE "+ RetSQLName("SZI") +" "
_cQuery += " SET D_E_L_E_T_='*' "
_cQuery += " WHERE ZI_FILIAL='"+xFilial("SZI")+"' AND ZI_ANOMES="+_nperiod+" "
TCSQLEXEC ( _cQuery )
TCRefresh("SZI")

/* Marca como deletado a tabela SZJ- Estoque     */
_cQuery := " UPDATE "+ RetSQLName("SZJ") +" "
_cQuery += " SET D_E_L_E_T_='*'  "
_cQuery += " WHERE ZJ_FILIAL='"+xFilial("SZJ")+"' AND ZJ_ANOMES="+_nperiod+" "
TCSQLEXEC ( _cQuery )
TCRefresh("SZJ")
                                                   


ConOut("   [INTARG] FINALIZANDO PROCESSO DE PREPARACAO DO AMBIENTE E TABELAS ")
ConOut("   [INTARG] INICIANDO PROCESSO U_VENDAR2(.T.) VENDAS TOTALMENTE FATURADAS - : "+DTOC(DATE())+" "+TIME())
U_VENDAR2(.T.) //PROCESSA AS VENDAS TOTALMENTE FATURADAS   

ConOut("   [INTARG] FINALIZANDO PROCESSO U_VENDAR2(.T.) VENDAS TOTALMENTE FATURADAS - : "+DTOC(DATE())+" "+TIME())
ConOut("   [INTARG] INICIANDO PROCESSO U_VENDAR2(.F.) VENDAS NAO FATURADAS - : "+DTOC(DATE())+" "+TIME()) 
U_VENDAR2(.F.) //PROCESSA AS VENDAS NAO FATURADAS

ConOut("   [INTARG] FINALIZANDO PROCESSO U_VENDAR2(.T.) VENDAS NAO FATURADAS - : "+DTOC(DATE())+" "+TIME())
ConOut("   [INTARG] INICIANDO PROCESSO U_DEVLAR2() DEVOLUCOES - : "+DTOC(DATE())+" "+TIME()) 
U_DEVLAR2()    //PROCESSA AS DEVOLUCOES  


ConOut("   [INTARG] FINALIZANDO PROCESSO U_DEVLAR2() DEVOLUCOES - : "+DTOC(DATE())+" "+TIME())
ConOut("   [INTARG] INICIANDO PROCESSO U_FATPNEX() FATURAMENTO NEXTEL DESC. IMPOSTOS - : "+DTOC(DATE())+" "+TIME()) 
U_FATPNEX()    //PROCESSA FATURAMENTO NEXTEL - SOMENTE PARA DESCONTAR IMPOSTOS


ConOut("   [INTARG] FINALIZANDO PROCESSO U_FATPNEX() FATURAMENTO NEXTEL DESC. IMPOSTOS : "+DTOC(DATE())+" "+TIME())
ConOut("   [INTARG] INICIANDO PROCESSO U_ESTQBGH() DISP/INDISP ESTOQUE - : "+DTOC(DATE())+" "+TIME()) 
U_ESTQBGH()    //PROCESSA DISPONIBILIDADE E INDISPONIBILIDADE DO ESTOQUE  

ConOut("   [INTARG] FINALIZANDO PROCESSO U_ESTQBGH() DISP/INDISP ESTOQUE : "+DTOC(DATE())+" "+TIME())
ConOut("   [INTARG] INICIANDO PROCESSO U_ATUADAD() ATUALIZACAO DOS DADOS NAS TABELAS REPLIC E APOIO - : "+DTOC(DATE())+" "+TIME()) 
U_ATUADAD()   //ATUALIZA DADOS DE VENDAS E ESTOQUE NAS TABELAS DE REPLICACAO BGH-AR E NAS TABELAS DE APOIO BGH-BR     

Private ctitulo := "Gera็ใo dos Dados do Comshare em "+DTOC(ddatabase)+" "+time()+"." "
Private cDestina := "edson.rodrigues@bgh.com.br;julia.schreurs@bgh.com.br"
Private cCco := ""
Private cMensagem := "Os dados para o Comshare referente ao periodo : "+SUBSTR(_Ddataini,5,2)+"/"+SUBSTR(_Ddataini,1,4)+" foram gerados com sucesso em: "+DTOC(ddatabase)+" "+time()+"." "
Private Path := "172.16.0.7"
                  


U_ENVIAEMAIL(cTitulo,cDestina,cCco,cMensagem,Path)
return
      
  
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VENDAAR  บAutor  ณ EDSON RODRIGUES    บ Data ณ  12/03/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Separa as vends faturadas da BGH-BR para o Comshare bgh-AR บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                       

USER FUNCTION VENDAR2(lfat)  

if Select("TRB") > 0
	TRB->(dbCloseArea())
endif


cQuery := CR + " SELECT  TOP 100 PERCENT C6_FILIAL,C6_NUM,C6_CLI,C6_LOJA,A3_COD,A3_NOME,C6_PRODUTO,C6_ITEM,C6_LOCAL,C6_DESCRI, "
cQuery += CR + " C6_CF   =CASE WHEN D2_CF IS NOT NULL THEN D2_CF ELSE C6_CF END, "
cQuery += CR + " SUM(C6_QTDVEN)/COUNT(C6_PRODUTO) AS 'QTVEND', "
cQuery += CR + " QTFAT   = CASE WHEN SUM(D2_QUANT) IS NOT NULL THEN SUM(D2_QUANT) ELSE 0.00 END, "   
//Alterado Edson Rodrigues 22/01/10
If RIGHT(_nperiod,2) < '11' .and. LEFT(_nperiod,4)<='2009'
   cQuery += CR + " VALBRUT=SUM(D2_VALBRUT)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END,"
   cQuery += CR + " TOTABRUIPI=SUM(D2_TOTAL)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END+SUM(D2_VALFRE)+SUM(D2_VALIPI),"
   cQuery += CR + " LIQVALBRIPI=(SUM(D2_VALBRUT)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END)  - (SUM(D2_VALICM) + SUM(D2_VALIMP5) + SUM(D2_VALIMP6) + SUM(D2_VALISS)+SUM(D2_DESCON)+SUM(D2_VALIPI)),"
   
   // Alterado Edson Rodrigues 03/12/10 -- Pois conforme foi detectado,  o sistema calcula o campo ICMS mesmo sendo NF de servi็o.                                                                                                                                                                                                       
   //   cQuery += CR + " LIQTOTIPI=(SUM(D2_TOTAL)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END+SUM(D2_VALFRE)+SUM(D2_VALIPI))    - (SUM(D2_VALICM) + SUM(D2_VALIMP5) + SUM(D2_VALIMP6) + SUM(D2_VALISS)+SUM(D2_DESCON)+SUM(D2_VALIPI)),"
   cQuery += CR + " LIQTOTIPI=(SUM(D2_TOTAL)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END+SUM(D2_VALFRE)+SUM(D2_VALIPI))    - (CASE WHEN D2_CF IN ('5933','6933','7409') THEN 0.00 ELSE  SUM(D2_VALICM) END + SUM(D2_VALIMP5) + SUM(D2_VALIMP6) +SUM(D2_VALISS)+SUM(D2_DESCON)+SUM(D2_VALIPI)),"

ELSE   
   cQuery += CR + " VALBRUT=SUM(D2_VALBRUT),"
   cQuery += CR + " TOTABRUIPI=SUM(D2_TOTAL)+SUM(D2_VALFRE)+SUM(D2_VALIPI),"
   cQuery += CR + " LIQVALBRIPI=SUM(D2_VALBRUT)  - (SUM(D2_VALICM) + SUM(D2_VALIMP5) + SUM(D2_VALIMP6) + SUM(D2_VALISS)+SUM(D2_DESCON)+SUM(D2_VALIPI)),"                                                                                                                                                                              
   // Alterado Edson Rodrigues 22/02/10
   // cQuery += CR + " LIQTOTIPI=(SUM(D2_TOTAL)+SUM(D2_VALFRE)+SUM(D2_VALIPI))    - (SUM(D2_VALICM) + SUM(D2_VALIMP5) + SUM(D2_VALIMP6) + SUM(D2_VALISS)+SUM(D2_DESCON)+SUM(D2_VALIPI)),"
   // Alterado Edson Rodrigues 12/03/10 -- Pois para CFOP 5403 e 6403 deve-se deduzir o ICMSRET do valor bruto para compor o valor liquido - Conforme conversa com Denilza e Andr้.
   // cQuery += CR + " LIQTOTIPI=(SUM(D2_TOTAL)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END+SUM(D2_VALFRE)+SUM(D2_VALIPI))    - (SUM(D2_VALICM) + SUM(D2_VALIMP5) + SUM(D2_VALIMP6) + SUM(D2_VALISS)+SUM(D2_DESCON)+SUM(D2_VALIPI)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END),"
   
   // Alterado Edson Rodrigues 03/12/10 -- Pois conforme foi detectado,  o sistema calcula o campo ICMS mesmo sendo NF de servi็o.                                                                                                                                                                                                       
   // Alterado Edson Rodrigues 01/02/11 -- Pois conforme Katia Santos, nao e para ser descontado o ICMSRET do faturamento                                                                                                                                                                                                       
   //cQuery += CR + " LIQTOTIPI=(SUM(D2_TOTAL)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END+SUM(D2_VALFRE)+SUM(D2_VALIPI))    - (CASE WHEN D2_CF IN ('5933','6933','7409') THEN 0.00 ELSE  SUM(D2_VALICM) END + SUM(D2_VALIMP5) + SUM(D2_VALIMP6) +SUM(D2_VALISS)+SUM(D2_DESCON)+SUM(D2_VALIPI)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END),"
   cQuery += CR + " LIQTOTIPI=(SUM(D2_TOTAL)+CASE WHEN D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END+SUM(D2_VALFRE)+SUM(D2_VALIPI))    - (CASE WHEN D2_CF IN ('5933','6933','7409') THEN 0.00 ELSE  SUM(D2_VALICM) END + SUM(D2_VALIMP5) + SUM(D2_VALIMP6) +SUM(D2_VALISS)+SUM(D2_DESCON)+SUM(D2_VALIPI)+CASE WHEN D2_CF IN ('5403','6403')   THEN 0.00 ELSE 0.00 END),"

ENDIF   
cQuery += CR + " VALVEND =CASE WHEN SUM(D2_PRCVEN) IS NOT NULL THEN SUM(D2_PRCVEN)/COUNT(C6_PRODUTO) ELSE  SUM(C6_PRCVEN)/COUNT(C6_PRODUTO) END, "
cQuery += CR + " VALVFAT =CASE WHEN SUM(D2_PRCVEN) IS NOT NULL THEN SUM(D2_PRCVEN)/COUNT(C6_PRODUTO) ELSE  0 END, "
cQuery += CR + " VALVVEN =CASE WHEN SUM(D2_PRCVEN) IS NOT NULL THEN 0 ELSE  SUM(C6_PRCVEN)/COUNT(C6_PRODUTO) END, "
cQuery += CR + " TOTAL   = CASE WHEN SUM(D2_TOTAL) IS NOT NULL THEN SUM(D2_TOTAL) ELSE SUM(C6_VALOR)/COUNT(C6_PRODUTO) END, "
cQuery += CR + " TOTFAT  = CASE WHEN SUM(D2_TOTAL) IS NOT NULL THEN SUM(D2_TOTAL) ELSE 0 END, "
cQuery += CR + " C6_NOTA =CASE WHEN C6_NOTA IS NULL THEN '' ELSE C6_NOTA END, "
cQuery += CR + " C6_DATFAT AS 'EMISNF',D2_SERIE, "
cQuery += CR + " VALICM  = CASE WHEN SUM(D2_VALICM) IS NOT NULL  AND D2_CF IN ('5933','6933','7409') THEN 0.00 WHEN SUM(D2_VALICM) IS NOT NULL  AND D2_CF NOT IN ('5933','6933','7409') THEN SUM(D2_VALICM) ELSE (SUM(C6_VALOR)/COUNT(C6_PRODUTO))*(SUM(B1_PICM)/100) END, "
cQuery += CR + " VALCOFIN= CASE WHEN SUM(D2_VALIMP5) IS NOT NULL THEN SUM(D2_VALIMP5) ELSE (SUM(C6_VALOR)/COUNT(C6_PRODUTO))*(7.60/100) END, "
cQuery += CR + " VALPIS  = CASE WHEN SUM(D2_VALIMP6) IS NOT NULL THEN SUM(D2_VALIMP6) ELSE  (SUM(C6_VALOR)/COUNT(C6_PRODUTO))*(1.65/100) END, "
cQuery += CR + " VALISS  = CASE WHEN SUM(D2_VALISS) IS NOT NULL THEN SUM(D2_VALISS) WHEN C6_CF IN ('5933','6933','7949') THEN (SUM(C6_VALOR)/COUNT(C6_PRODUTO))*(2.00/100) ELSE 0.00 END, "
cQuery += CR + " FRETE   = CASE WHEN  SUM(D2_VALFRE)  IS NOT NULL THEN SUM(D2_VALFRE) ELSE 0.00 END, "
cQuery += CR + " ICMSRET = CASE WHEN SUM(D2_ICMSRET)  IS NOT NULL AND D2_CF IN ('5403','6403')   THEN SUM(D2_ICMSRET) ELSE 0.00 END, "
cQuery += CR + " DESCONT =CASE WHEN SUM(D2_DESCON) IS NOT NULL THEN SUM(D2_DESCON) ELSE 0.00 END, "
cQuery += CR + " IPI     =CASE WHEN SUM(D2_VALIPI) IS NOT NULL THEN SUM(D2_VALIPI) ELSE 0.00 END "
cQuery += CR + " FROM  " + RetSQLName("SC6") +" (nolock) "
cQuery += CR + "                  INNER JOIN "+ RetSQLName("SA1") +" (nolock)  ON C6_CLI    = A1_COD AND C6_LOJA=A1_LOJA "
cQuery += CR + "                  INNER JOIN "+ RetSQLName("SB1") +" (nolock)  ON B1_COD    = C6_PRODUTO AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += CR + "                  INNER JOIN "+ RetSQLName("SC5") +" (nolock)  ON C6_FILIAL = C5_FILIAL AND C6_NUM=C5_NUM "
cQuery += CR + "                  INNER JOIN "+ RetSQLName("SE4") +" (nolock)  ON E4_CODIGO = C5_CONDPAG "
cQuery += CR + "                  INNER JOIN "+ RetSQLName("SF4") +" (nolock)  ON F4_CODIGO = C6_TES AND F4_DUPLIC='S' "  
cQuery += CR + "                  LEFT OUTER  JOIN( SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CF,D2_PEDIDO,D2_COD,D2_ITEMPV,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_VALBRUT, "
cQuery += CR + "                                           D2_VALICM,D2_VALIMP5,D2_VALIMP6,D2_VALISS,D2_VALFRE,D2_ICMSRET,D2_DESCON,D2_VALIPI " 
cQuery += CR + "                                           FROM "+ RetSQLName("SD2") +" (nolock)   "
cQuery += CR + "                                    WHERE D2_FILIAL IN "+_cfiliais+"  AND D2_CF IN "+_cfventot+" "
cQuery += CR + "                                          AND "+RetSQLName("SD2")+".D_E_L_E_T_='' AND  ( (MONTH(D2_EMISSAO) = "+SUBSTR(_Ddataini,5,2)+" AND YEAR(D2_EMISSAO)="+SUBSTR(_Ddataini,1,4)+"))) AS SD2  "
cQuery += CR + "                               ON D2_FILIAL=C6_FILIAL AND D2_DOC=C6_NOTA AND D2_PEDIDO=C6_NUM AND D2_COD=C6_PRODUTO AND D2_ITEMPV=C6_ITEM "
cQuery += CR + "                  LEFT OUTER JOIN (SELECT A3_COD,A3_NOME FROM "+ RetSQLName("SA3") +" (nolock)  WHERE A3_FILIAL='"+xFilial("SA3")+"' AND D_E_L_E_T_='') AS SA3 "
cQuery += CR + "                               ON C5_VEND1=A3_COD "
cQuery += CR + " WHERE  C6_FILIAL IN "+_cfiliais+"  AND "+ RetSQLName("SC6") +".D_E_L_E_T_ = ''  AND "+ RetSQLName("SA1") +".D_E_L_E_T_ = ''  AND "+ RetSQLName("SF4") +".D_E_L_E_T_ = '' " 
cQuery += CR + "        AND C6_CF IN "+_cfventot+"    AND "+RetSQLName("SB1")+".D_E_L_E_T_='' AND  ( (MONTH(C6_DATFAT) = "+SUBSTR(_Ddataini,5,2)+" AND YEAR(C6_DATFAT)="+SUBSTR(_Ddataini,1,4)+") OR ((MONTH(C6_ENTREG) = "+SUBSTR(_Ddataini,5,2)+" AND YEAR(C6_ENTREG)="+SUBSTR(_Ddataini,1,4)+") AND C6_DATFAT='' )) "
cQuery += CR + "        AND "+RetSQLName("SC5")+".D_E_L_E_T_='' AND "+RetSQLName("SE4")+".D_E_L_E_T_='' "
If lfat
cQuery += CR + " AND C6_NOTA<>'' "
Else 
cQuery += CR + " AND C6_NOTA='' "
Endif
cQuery += CR + " GROUP BY C6_FILIAL,C6_NUM, C6_CLI,C6_LOJA,A3_COD,A3_NOME,C6_PRODUTO,C6_ITEM,C6_LOCAL,C6_DESCRI,C6_CF,D2_CF,C6_NOTA,C6_DATFAT,D2_SERIE "
cQuery += CR + " ORDER BY C6_FILIAL,C6_NUM, C6_CLI,C6_LOJA,A3_COD,A3_NOME,C6_PRODUTO,C6_ITEM,C6_LOCAL,C6_DESCRI,C6_CF,D2_CF,C6_NOTA,C6_DATFAT,D2_SERIE "

cQuery := strtran(cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
TcSetField("TRB","EMISNF" ,"D")

TRB->(dbGoTop())
While !TRB->(eof()) 

   _lLibSC9:=.f.
   _lVdtSticm :=.f. //Verifica data para considerar ou nใo o desconto ICMS para composicao do valor liquido           
   _lDescSticm :=.f.  //Confirma se o produtos St tera ou nao o desconto de ICMS para composicao do valor liquido 
   _ntotven := 0
   _ntotimp := 0                                 
   _cperinew:=RIGHT(_nperiod,2)+'/'+LEFT(_nperiod,4)                                                                     

    //Cliente Permuta -> Nใo Considerar, conforme Helcio - Edson Rodrigues 03/10
   IF  TRB->C6_CLI $ "192542/192739" .OR. TRB->C6_NUM='812032'
            TRB->(dbSkip())
            loop
   ENDIF
   
	dbSelectArea("SC9")                                
	DBSetOrder(1)	
	If dbSeek(TRB->C6_FILIAL+TRB->C6_NUM+ALLTRIM(TRB->C6_ITEM))
		_lblqcred :=IIF((EMPTY(SC9->C9_BLCRED) .OR. alltrim(SC9->C9_BLCRED)= "10"),.t.,.f.)
		IF _lblqcred
	    	_lblqestq :=IIF((EMPTY(SC9->C9_BLEST) .OR. alltrim(SC9->C9_BLEST)= "10"),.t.,.f.)
	    ELSE
	    	_lblqestq :=.T.
	    ENDIF	
		_lLibSC9  :=.t.
	Endif                 
	dbSelectArea("SA1")   
	dbSeek(xFilial("SA1")+TRB->C6_CLI+TRB->C6_LOJA)                                                    
	                  
    If !empty(TRB->A3_COD) .or. ALLTRIM(TRB->A3_COD) <>'NULL'	                                                                                                                                                      
	     dbSelectArea("SF2")   
	         If dbSeek(TRB->C6_FILIAL+TRB->C6_NOTA+ALLTRIM(TRB->D2_SERIE))                                                   
	            _cvdedor:=SF2->F2_VEND1
	         Else   
	            _cvdedor:=TRB->A3_COD
	        Endif    
	Else
	    _cvdedor:=''
	Endif
	
    _lblqcred :=Vercred(TRB->C6_FILIAL,TRB->C6_NUM,ALLTRIM(TRB->C6_ITEM))
    _lblqestq :=Verestq(TRB->C6_FILIAL,TRB->C6_NUM,ALLTRIM(TRB->C6_ITEM))
    _lVdtSticm:=IIf(RIGHT(_nperiod,2)>='07' .and. LEFT(_nperiod,4)>='2009',.t.,.f.)   
    _nvalorliq:=TRB->LIQTOTIPI
    
     
    //Retirado essa Regra conforme Denilza, pois a mesma disse que vai avaliar melhor junto com Andr้ - Edson 12/03/10

    //Verifica se o produto e ST e desconta ou nao o ICMS para compor o valor liquido               
    /*    
    if _lVdtSticm
      dbSelectArea("SB1")   
	  dbSeek(xFilial("SB1")+TRB->C6_PRODUTO)
	  
	  
	  IF (SB1->B1_PICMENT > 0 .OR. SB1->B1_PICMRET > 0)
         dbSelectArea("ZZH")   
	     IF !dbSeek(xFilial("ZZH")+TRB->C6_FILIAL+_cperinew+TRB->C6_PRODUTO+TRB->C6_LOCAL)
            _nvalorliq:=TRB->LIQTOTIPI+TRB->VALICM
         ENDIF    
      ENDIF     	  
	ENDIF                                                     
    */
    
	dbSelectArea("TRB")
	Do case
		
		Case lfat .AND. ABS(TRB->QTVEND)-ABS(TRB->QTFAT) = 0	
				// "VENTA" /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
				// Unidade de Medida = UNI
				aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc1,TRB->QTFAT})
				
				// "VENTA" /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
				// Unidade de Medida = REA
				//aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc1,ABS(TRB->TOTAL-TRB->IPI+TRB->FRETE+TRB->ICMSRET)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)})
			    aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc1,_nvalorliq})
								
				aAdd(_avenda,{_nperiod,_cconc1,"",TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,IIF(TRB->QTFAT=0,0,TRB->VALVEND),IIF(TRB->QTFAT=0,0,TRB->TOTAL),TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
		
		
		Case lfat .AND. ABS(TRB->QTVEND)-ABS(TRB->QTFAT) > 0				
					// "VENTA" /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
					// Unidade de Medida = UNI
					aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc1,TRB->QTFAT})
					
					// "VENTA" /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
					// Unidade de Medida = REA
					//aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc1,IIF((TRB->TRB->VALVFAT) < 0,-1*(ABS(TRB->QTFAT*TRB->VALVFAT)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS)),ABS(TRB->QTFAT*TRB->VALVFAT)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS))})		
			        //aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc1,ABS(TRB->TOTFAT+TRB->IPI+TRB->FRETE+TRB->ICMSRET)-(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)})                                    
					aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc1,_nvalorliq})	
					
				  If  _lblqcred .and. _lblqestq
					     //"PPAPR"  /* (PEDIDOS APROVADOS) - Sใo Pedidos liberados sem nenhuma restri็ใo (cr้dito ou estoque), porem ainda nao faturados */
					     // Unidade de Medida =UNI
					     aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc3,TRB->QTVEND-TRB->QTFAT})
										
					      //"PPAPR"  /* (PEDIDOS APROVADOS) - Sใo Pedidos liberados sem nenhuma restri็ใo (cr้dito ou estoque), porem ainda nao faturados */
					      // Unidade de Medida = REA                                                                          
					     _ntotven:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALVEND)+(ABS(TRB->IPI+TRB->FRETE+TRB->ICMSRET)/TRB->QTFAT))

					     //01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
					     //_ntotimp:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)/TRB->QTFAT)
                         _ntotimp:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)/TRB->QTFAT)

				         aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc3,_ntotven-_ntotimp})
					     aAdd(_avenda,{_nperiod,_cconc1,_cconc3,TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
					     
				  Elseif   !_lblqcred .and. !_lblqestq 
				  
				         //"PPBOCR" /*	(PEDIDOS NรO APROVADOS) - Sใo Pedidos Liberados, nใo faturados e que necessitam aprova็ใo de cr้dito e Estoque 
                         // Unidade de Medida = UNI
			             aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc6,TRB->QTVEND-TRB->QTFAT})
			             
			             //"PPBOCR" /*	(PEDIDOS NรO APROVADOS) - Sใo Pedidos Liberados, nใo faturados e que necessitam aprova็ใo de cr้dito e Estoque 
			             // Unidade de Medida = REA
   					     
   					     _ntotven:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALVEND)+(ABS(TRB->IPI+TRB->FRETE+TRB->ICMSRET)/TRB->QTFAT))
					     
					     //01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
					     //_ntotimp:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)/TRB->QTFAT)
				         _ntotimp:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)/TRB->QTFAT)
				         
				         
				         aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc6,_ntotven-_ntotimp})
					     aAdd(_avenda,{_nperiod,_cconc1,_cconc6,TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})        

			      Elseif  !_lblqcred .and. _lblqestq       
			               
       		             // "PPCRE" /* 	(PEDIDOS NรO APROVADOS)  Pedidos Liberados ou nใo, nใo faturados e que necessitam de aprovacao de credito */
			             // Unidade de Medida = UNI 
			             aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc4,TRB->QTVEND-TRB->QTFAT})
			            
   					       					     
   					     // "PPCRE" /* 	(PEDIDOS NรO APROVADOS)  Pedidos Liberados ou nใo, nใo faturados e que necessitam de aprovacao de credito */ 
   					     // Unidade de Medida = REA
   					     _ntotven:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALVEND)+(ABS(TRB->IPI+TRB->FRETE+TRB->ICMSRET)/TRB->QTFAT))
					     
					     //01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
					     //_ntotimp:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)/TRB->QTFAT)
				         _ntotimp:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)/TRB->QTFAT)
				         
				         aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc4,_ntotven-_ntotimp})
                         aAdd(_avenda,{_nperiod,_cconc1,_cconc4,TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})        
                         
                  Elseif  _lblqcred .and. !_lblqestq       
			               
       		             // "PPBOSR" /*  (PEDIDOS NรO APROVADOS)  Pedidos Liberados, nใo faturados e que necessitam de  aprovacao de Estoque */
			             // Unidade de Medida = UNI  
			              aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc5,TRB->QTVEND-TRB->QTFAT})
			            
 	                     // "PPBOSR" /*  (PEDIDOS NรO APROVADOS)  Pedidos Liberados, nใo faturados e que necessitam de  aprovacao de Estoque */
		                 // Unidade de Medida = REA
   					     _ntotven:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALVEND)+(ABS(TRB->IPI+TRB->FRETE+TRB->ICMSRET)/TRB->QTFAT))
					     
					     //01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
					     //_ntotimp:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)/TRB->QTFAT)
					     _ntotimp:=ABS(TRB->QTVEND-TRB->QTFAT)* (ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)/TRB->QTFAT)

				         aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc5,_ntotven-_ntotimp})
                         aAdd(_avenda,{_nperiod,_cconc1,_cconc5,TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})        
			             
				  Endif

			
			//"PPAPR"  /* (PEDIDOS APROVADOS) - Sใo Pedidos liberados sem nenhuma restri็ใo (cr้dito ou estoque), porem ainda nao faturados */
		Case !lfat .AND. TRB->QTVEND-TRB->QTFAT > 0 .AND. _lLibSC9 .AND. _lblqcred  .AND. _lblqestq
			// Unidade de Medida = UNI
			aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc3,TRB->QTVEND})
			
			// Unidade de Medida = REA
			_ntotven:=ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE+TRB->ICMSRET)

			//01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
			//_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)
            _ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)
            
            aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc3,_ntotven-_ntotimp})
			aAdd(_avenda,{_nperiod,_cconc3,"",TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})        
			
			
			// "PPCRE" /* 	(PEDIDOS NรO APROVADOS)  Pedidos Liberados ou nใo, nใo faturados e que necessitam de aprovacao de credito */
	    Case !lfat .AND. TRB->QTVEND-TRB->QTFAT > 0 .AND.  !_lLibSC9 
			// Unidade de Medida = UNI
			aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc4,TRB->QTVEND})
			
			// Unidade de Medida = REA
			_ntotven:=ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE+TRB->ICMSRET)                           
			
			//01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
			//_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)
            _ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)
            
            aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc4,_ntotven-_ntotimp})
			aAdd(_avenda,{_nperiod,_cconc4,"",TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
		
           	// "PPCRE" /* 	(PEDIDOS NรO APROVADOS)  Pedidos Liberados ou nใo, nใo faturados e que necessitam de aprovacao de credito */		
        Case !lfat  .AND. TRB->QTVEND-TRB->QTFAT > 0 .AND.  _lLibSC9 .AND.  !_lblqcred  .AND. _lblqestq 
			// Unidade de Medida = UNI
			aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc4,TRB->QTVEND})
			
			// Unidade de Medida = REA
			_ntotven:=ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE+TRB->ICMSRET)

			//01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
			//_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)
			_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT)

            aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc4,_ntotven-_ntotimp})
			aAdd(_avenda,{_nperiod,_cconc4,"",TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})		
		
		 
			//"PPBOSR" /* (PEDIDOS NรO APROVADOS)  Pedidos Liberados, nใo faturados e que necessitam de  aprovacao de Estoque */
		Case !lfat  .AND. TRB->QTVEND-TRB->QTFAT > 0 .AND. _lLibSC9 .AND. _lblqcred  .AND. !_lblqestq
			// Unidade de Medida = UNI
			aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc5,TRB->QTVEND})
			
			
			// Unidade de Medida = REA
			_ntotven:=ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE+TRB->ICMSRET)                           
			
			//01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
			//_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)
			_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)
			
            aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc5,_ntotven-_ntotimp})
			aAdd(_avenda,{_nperiod,_cconc5,"",TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
			
        
        	//"PPBOCR" /*	(PEDIDOS NรO APROVADOS) - Sใo Pedidos Liberados, nใo faturados e que necessitam aprova็ใo de cr้dito e Estoque 
	    Case  !lfat  .AND. TRB->QTVEND-TRB->QTFAT > 0 .AND. _lLibSC9 .AND. !_lblqcred  .AND. !_lblqestq
			// Unidade de Medida = UNI
			aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc6,TRB->QTVEND})
			
			// Unidade de Medida = REA
			_ntotven:=ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE+TRB->ICMSRET)                           
			
            //01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
			//_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)
            _ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)            
            
            aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc6,_ntotven-_ntotimp})
		    aAdd(_avenda,{_nperiod,_cconc6,"",TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
		
					
			
		Otherwise                
			//"PPAPR"  /* (PEDIDOS APROVADOS) - Sใo Pedidos liberados sem nenhuma restri็ใo (cr้dito ou estoque), porem ainda nao faturados */
			// Unidade de Medida = UNI
			aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmuni,_cconc3,TRB->QTVEND})
		   
			// Unidade de Medida = REA
			_ntotven:=ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE+TRB->ICMSRET)

            //01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
		   //_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET)
           	_ntotimp:=ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI)
           
           
            aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->C6_PRODUTO,TRB->C6_CLI,_cunmval,_cconc3,_ntotven-_ntotimp})
			aAdd(_avenda,{_nperiod,_cconc3,"",TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->C6_PRODUTO,TRB->C6_ITEM,TRB->C6_LOCAL,TRB->C6_DESCRI,TRB->C6_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->C6_NOTA,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
			
	EndCase
	
	TRB->(dbSkip())
EndDo
Return()   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DEVOLAR  บAutor  ณ EDSON RODRIGUES    บ Data ณ  12/03/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Separa Devolucoes da BGH-BR para o Comshare bgh-AR         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/       

USER FUNCTION DEVLAR2()   

if Select("TRB") > 0
	TRB->(dbCloseArea())
endif

               
cQuery := CR + " SELECT  TOP 100 PERCENT D1_FILIAL,D1_DOC,D1_FORNECE,D1_LOJA,A3_COD,A3_NOME,D1_COD,D1_ITEM,D1_LOCAL,B1_DESC,D1_CF, "
cQuery += CR + " -1*SUM(D1_QUANT) AS 'QTVEND', "
cQuery += CR + " -1*SUM(D1_QUANT) AS 'QTFAT', "           
cQuery += CR + " -1*(SUM(D1_VUNIT)/COUNT(D1_COD)) AS 'VALVEND', "
cQuery += CR + " -1*(SUM(D1_VUNIT)/COUNT(D1_COD)) VALVFAT, "
cQuery += CR + " 0  VALVVEN, "
cQuery += CR + " -1*SUM(D1_TOTAL) AS 'TOTAL', "
cQuery += CR + " D1_NFORI,D1_SERIORI,D1_DTDIGIT AS 'EMISNF', "
cQuery += CR + " -1*SUM(D1_VALICM) AS 'VALICM', "
cQuery += CR + " -1* SUM(D1_VALIMP5) AS 'VALCOFIN', "
cQuery += CR + " -1*SUM(D1_VALIMP6) AS 'VALPIS', "
cQuery += CR + " -1*SUM(D1_VALISS) AS 'VALISS', "
cQuery += CR + " -1*SUM(D1_VALFRE) AS 'FRETE', "
cQuery += CR + " -1*SUM(D1_ICMSRET) AS 'ICMSRET', "
cQuery += CR + " -1*SUM(D1_DESC) AS 'DESCONT', "
cQuery += CR + " -1*SUM(D1_VALIPI) AS 'IPI' "
cQuery += CR + " FROM  " + RetSQLName("SD1") + " (nolock)    INNER JOIN " + RetSQLName("SA1") + " (nolock)   ON D1_FORNECE=A1_COD AND D1_LOJA=A1_LOJA "
cQuery += CR + "                 INNER JOIN " + RetSQLName("SB1") + " (nolock)   ON B1_COD=D1_COD AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += CR + "                 LEFT OUTER JOIN (SELECT A3_COD,A3_NOME FROM " + RetSQLName("SA3") + " (nolock)  WHERE "+ RetSQLName("SA3")+".D_E_L_E_T_='') AS SA3 ON A1_VEND=A3_COD "
cQuery += CR + " WHERE D1_FILIAL IN "+_cfiliais+"  AND "+RetSQLName("SD1")+".D_E_L_E_T_='' AND D1_CF IN "+_cfdevtot+"  AND (MONTH(D1_DTDIGIT) = "+SUBSTR(_Ddataini,5,2)+" AND YEAR(D1_DTDIGIT)="+SUBSTR(_Ddataini,1,4)+")  "
cQuery += CR + " GROUP BY D1_FILIAL,D1_DOC,D1_SERIORI,D1_FORNECE,D1_LOJA,A3_COD,A3_NOME,D1_COD,D1_ITEM,D1_LOCAL,B1_DESC,D1_CF,D1_NFORI,D1_DTDIGIT "
cQuery += CR + " ORDER BY D1_FILIAL,D1_DOC,D1_SERIORI,D1_FORNECE,D1_LOJA,A3_COD,A3_NOME,D1_COD,D1_ITEM,D1_LOCAL,B1_DESC,D1_CF,D1_NFORI,D1_DTDIGIT "

cQuery := strtran(cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
TcSetField("TRB","EMISNF" ,"D")  

TRB->(dbGoTop())
While !TRB->(eof())
   
 //Cliente Permuta -> Nใo Considerar, conforme Helcio - Edson Rodrigues 03/10
 IF  TRB->D1_FORNECE $ "192542/192739"
            TRB->(dbSkip())
            loop
 ENDIF


	dbSelectArea("SA1")   
	dbSeek(xFilial("SA1")+TRB->D1_FORNECE+TRB->D1_LOJA)                                                    
	                  
    If !empty(TRB->A3_COD) .or. ALLTRIM(TRB->A3_COD) <>'NULL'	                                                                                                                                                      
	     dbSelectArea("SF2")   
	         If dbSeek(TRB->D1_FILIAL+TRB->D1_NFORI+ALLTRIM(TRB->D1_SERIORI))                                                   
	            _cvdedor:=SF2->F2_VEND1
	         Else   
	            _cvdedor:=TRB->A3_COD
	        Endif    
	Else
	    _cvdedor:=''
	Endif 
	// "VENTA" /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
	// Unidade de Medida = UNI
	aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->D1_COD,TRB->D1_FORNECE,_cunmuni,_cconc1,TRB->QTFAT})
				
	// "VENTA" /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
	// Unidade de Medida = REA 
	//Alterado Edosn Rodrigues 22/01/10                                                                        
	//aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->D1_COD,TRB->D1_FORNECE,_cunmval,_cconc1,-1*(ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI))})
	/* CLAUDIA 26/01/2010 - CORRECAO DOS VALORES DE TOTAL LIQUIDO  IGUAL AO RELATORIO GERENCIAL
	aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->D1_COD,TRB->D1_FORNECE,_cunmval,_cconc1,-1*(ABS(TRB->TOTAL+TRB->FRETE)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI))})
	*/
	// Alterado Edson Rodrigues 12/03/10 -- Pois para CFOP 5403 e 6403 deve-se deduzir o ICMSRET do valor bruto para compor o valor liquido e a mesma regra para as devolu็oes - Conforme conversa com Denilza e Andr้.
	//aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->D1_COD,TRB->D1_FORNECE,_cunmval,_cconc1,-1*(ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI))})

    //01/02/11 Conforme solicitacao de katia Santos - alterado para nao descontar o ICMSRET
    //aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->D1_COD,TRB->D1_FORNECE,_cunmval,_cconc1,-1*(ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI+TRB->ICMSRET))})
    aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->D1_COD,TRB->D1_FORNECE,_cunmval,_cconc1,-1*(ABS(TRB->TOTAL+TRB->IPI+TRB->FRETE)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->DESCONT+TRB->IPI))})

	aAdd(_avenda,{_nperiod,_cconc1,"",TRB->D1_DOC,TRB->D1_FORNECE,TRB->D1_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->D1_COD,TRB->D1_ITEM,TRB->D1_LOCAL,TRB->B1_DESC,TRB->D1_CF,TRB->QTVEND,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->D1_DOC,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
		
    TRB->(dbSkip())
EndDo
return()   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATPNEX()บAutor  ณ EDSON RODRIGUES    บ Data ณ  29/09/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Separa Faturamento Pecas Nextel - Somente Impostos         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/       

USER FUNCTION FATPNEX()

if Select("TRB") > 0
	TRB->(dbCloseArea())
endif



cQuery := CR + " SELECT  TOP 100 PERCENT D2_FILIAL,D2_PEDIDO,D2_CLIENTE,D2_LOJA,A3_COD,A3_NOME,D2_COD,D2_ITEM,D2_LOCAL,B1_DESC,D2_CF,"
cQuery += CR + " QTFAT   =SUM(D2_QUANT), "
cQuery += CR + " VALVEND =0, "
cQuery += CR + " VALVFAT =0, "
cQuery += CR + " VALVVEN =0, "
cQuery += CR + " TOTAL   =0, "
cQuery += CR + " TOTFAT  =0, "
cQuery += CR + " D2_DOC  =D2_DOC,D2_EMISSAO AS 'EMISNF',D2_SERIE, "
cQuery += CR + " VALICM  = SUM(D2_VALICM), "
cQuery += CR + " VALCOFIN= SUM(D2_VALIMP5), "
cQuery += CR + " VALPIS  = SUM(D2_VALIMP6), "
cQuery += CR + " VALISS  = SUM(D2_VALISS), "
cQuery += CR + " FRETE   = SUM(D2_VALFRE), "
cQuery += CR + " ICMSRET = SUM(D2_ICMSRET), "
cQuery += CR + " DESCONT = SUM(D2_DESCON), "
cQuery += CR + " IPI     = SUM(D2_VALIPI)"
cQuery += CR + " FROM  " + RetSQLName("SD2") + " (nolock) "
cQuery += CR + "                  INNER JOIN " + RetSQLName("SA1") + " (nolock)  ON D2_CLIENTE    = A1_COD AND D2_LOJA=A1_LOJA "
cQuery += CR + "                  INNER JOIN " + RetSQLName("SB1") + " (nolock)  ON B1_COD    = D2_COD AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += CR + "                  INNER JOIN " + RetSQLName("SC5") + " (nolock)  ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO=C5_NUM "
cQuery += CR + "                  INNER JOIN " + RetSQLName("SE4") + " (nolock)  ON E4_CODIGO = C5_CONDPAG "
cQuery += CR + "                  LEFT OUTER JOIN (SELECT A3_COD,A3_NOME FROM "+RetSQLName("SA3")+" (nolock)  WHERE A3_FILIAL='  ' AND "+RetSQLName("SA3")+".D_E_L_E_T_='') AS SA3 "
cQuery += CR + "                               ON C5_VEND1=A3_COD "
cQuery += CR + " WHERE  D2_FILIAL IN "+_cfiliais+"  AND " + RetSQLName("SD2") +".D_E_L_E_T_ = ''  AND "+ RetSQLName("SA1")+".D_E_L_E_T_ = '' "   
//cQuery += CR + "        AND D2_CF IN ('5949','6949')  AND "+RetSQLName("SB1")+".D_E_L_E_T_=''  AND D2_CLIENTE IN ('000016','000680') AND D2_TES='827' AND D2_LOCAL IN ('01') "          
cQuery += CR + "        AND D2_CF IN ('5949','6949')  AND "+RetSQLName("SB1")+".D_E_L_E_T_=''  AND D2_CLIENTE IN ('000016','000680','Z01EUO') AND D2_TES='827' AND D2_LOCAL IN ('01') "          
cQuery += CR + "        AND "+RetSQLName("SC5")+".D_E_L_E_T_='' AND "+RetSQLName("SE4")+".D_E_L_E_T_='' "
cQuery += CR + "        AND MONTH(D2_EMISSAO) = "+SUBSTR(_Ddataini,5,2)+" AND YEAR(D2_EMISSAO)="+SUBSTR(_Ddataini,1,4)+" "
cQuery += CR + " GROUP BY D2_FILIAL,D2_PEDIDO,D2_CLIENTE,D2_LOJA,A3_COD,A3_NOME,D2_COD,D2_ITEM,D2_LOCAL,B1_DESC,D2_CF,D2_DOC,D2_EMISSAO,D2_SERIE "
cQuery += CR + " ORDER BY D2_FILIAL,D2_PEDIDO,D2_CLIENTE,D2_LOJA,A3_COD,A3_NOME,D2_COD,D2_ITEM,D2_LOCAL,B1_DESC,D2_CF,D2_DOC,D2_EMISSAO,D2_SERIE "

cQuery := strtran(cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
TcSetField("TRB","EMISNF" ,"D")  

TRB->(dbGoTop())
While !TRB->(eof())


	dbSelectArea("SA1")   
	dbSeek(xFilial("SA1")+TRB->D2_CLIENTE+TRB->D2_LOJA)                                                    
	                  
    If !empty(TRB->A3_COD) .or. ALLTRIM(TRB->A3_COD) <>'NULL'	                                                                                                                                                      
	     dbSelectArea("SF2")   
	         If dbSeek(TRB->D2_FILIAL+TRB->D2_DOC+ALLTRIM(TRB->D2_SERIE))                                                   
	            _cvdedor:=SF2->F2_VEND1
	         Else   
	            _cvdedor:=TRB->A3_COD
	        Endif    
	Else
	    _cvdedor:=''
	Endif 
	// "VENTA" /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
	// Unidade de Medida = UNI
	aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->D2_COD,TRB->D2_CLIENTE,_cunmuni,_cconc1,TRB->QTFAT})
				
	// "VENTA" /*(PEDIDOS APROVADOS) - Sใo Pedidos Totalmente Faturados*/
	// Unidade de Medida = REA
	aAdd(_ageral,{_cregiao,_ccompan,_nperiod,_cvdedor,TRB->D2_COD,TRB->D2_CLIENTE,_cunmval,_cconc1,(ABS(TRB->TOTAL)-ABS(TRB->VALICM+TRB->VALCOFIN+TRB->VALPIS+TRB->VALISS+TRB->IPI))})
	aAdd(_avenda,{_nperiod,_cconc1,"",TRB->D2_DOC,TRB->D2_CLIENTE,TRB->D2_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->D2_COD,TRB->D2_ITEM,TRB->D2_LOCAL,TRB->B1_DESC,TRB->D2_CF,TRB->QTFAT,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->D2_DOC,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
		
    TRB->(dbSkip())
EndDo
Return() 
                                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ESTQBGH  บAutor  ณ EDSON RODRIGUES    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa doados de estoque disponibilidade, indisponibili   บฑฑ
ฑฑบ          ณdade, compras, em transito etc...                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                           


User Function estqbgh()

if Select("TRB") > 0
	TRB->(dbCloseArea())
endif

_cQuery := " SELECT B2_FILIAL,B2_COD AS PRODUTO,B2_LOCAL AS ARMAZ,SUM(B2_QATU) AS QTDEDISP,SUM(B2_RESERVA+B2_QPEDVEN) AS ESTQIND "
_cQuery += " FROM  "+ RetSQLName("SB2") +" (nolock) "
_cQuery += " WHERE B2_FILIAL IN "+_cfiliais+" AND (B2_LOCAL IN "+_carmpven+" OR  B2_LOCAL IN "+_carmdist+" OR B2_LOCAL IN ('13','03','30','31','74') )  AND D_E_L_E_T_='' "
_cQuery += " GROUP BY B2_FILIAL,B2_COD,B2_LOCAL "

TCRefresh(RetSQLName("SB2"))  
_cQuery := strtran(_cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)

dbselectarea("TRB")
TRB->(dbgotop())
While !TRB->(eof())
	_ncompra=0.00
	_cprod:=ALLTRIM(TRB->PRODUTO)
	_armaz:=ALLTRIM(TRB->ARMAZ)
	_cdescpro := Posicione("SB1",1,xFilial("SB1")+_cprod,"B1_DESC")                       
	_clinea := Posicione("SB1",1,xFilial("SB1")+_cprod,"B1_CODLINH")
	                                                                                            
	//ignorar estoque de  produtos sem linha 
	dbselectarea("TRB")
	If  empty(_clinea) .or. _clinea="999"
	   TRB->(dbSkip())
	    loop
	Endif                       
	
	//ignorar o armazen 51/61/13/O3 de produtos que nใo sใo de servi็os/Complemento de valor e ICMS/8571515M01-ANTENA I570                                  
    If 	_armaz $ "51/61/13/03" .and. !_cprod $ "500121/500122/500124/500125/500126/600048/800001/800002/'800004/800005/800006/800007/800014/800013/800015/800019/800020/800031/800071/8571515M01/900006/900007/900011/900061/900062/900088/900093/900097/900099/900115/900157/COLMEIAS/CXTRIPLEX/CXMULTI5"
        TRB->(dbSkip())
	    loop
	Endif
	
	dbSelectArea("SC7")
	If dbSeek(TRB->B2_FILIAL+_cprod)
		while SC7->(eof()) .and. SC7->C7_PRODUTO==_cprod .and. SC7->C7_LOCAL==_armaz
			If  SC7->C7_ENCER<>'E' .and. SC7->C7_RESIDUO<>'S' .and. SC7->C7_QUANT>SC7->C7_QUJE .and. SC7->C7_CONAPRO <>'B'
				_ncompra+=SC7->C7_QUANT
				_lLibSC7 := .T.
			Endif
			SC7->(dbSkip())
		enddo
	Endif                                                                           

	dbSelectArea("TRB")
	IF  !_lLibSC7  // QUANDO NAO TIVER PEDIDO DE COMPRA
		DO CASE
			CASE (TRB->QTDEDISP-TRB->ESTQIND) > 0
			   			
				IF TRB->ESTQIND <> 0.00
				 
				   //"STKEMS"  /*Estoque comprometido, jแ descontado do estoque disponํvel, ou seja Reservas e os Pedidos em Aberto*/
				   // Unidade de Medida = UNI
					aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc7,TRB->ESTQIND})
				
				   //"STKDIS"  /*Estoque Disponํvel para Vendas */
				   // Unidade de Medida = UNI
				    aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc8,TRB->QTDEDISP-TRB->ESTQIND})
				  
				    aAdd(_aestoq,{_nperiod,_cconc7,_cconc8,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})
			    Else			
				   //"STKDIS"  /*Estoque Disponํvel para Vendas */
				   // Unidade de Medida = UNI
				  aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc8,TRB->QTDEDISP-TRB->ESTQIND})
				  
				  aAdd(_aestoq,{_nperiod,_cconc8,"","",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})  
				
				
			   Endif
				
			CASE (TRB->QTDEDISP-TRB->ESTQIND) = 0.00
				//"STKEMS"  /*Estoque comprometido, jแ descontado do estoque disponํvel, ou seja Reservas e os Pedidos em Aberto*/
				// Unidade de Medida = UNI
				IF TRB->ESTQIND <> 0.00
					aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc7,TRB->ESTQIND})
				    aAdd(_aestoq,{_nperiod,_cconc7,"","",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})
			     ENDIF 	    
				
				
			CASE (TRB->QTDEDISP-TRB->ESTQIND) < 0.00
				//"STKEMS"  /*Estoque comprometido, jแ descontado do estoque disponํvel, ou seja Reservas e os Pedidos em Aberto*/
				// Unidade de Medida = UNI
				IF TRB->QTDEDISP <> 0.00
					aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc7,ABS(TRB->QTDEDISP)})
				    
				    
				    IF (TRB->ESTQIND-TRB->QTDEDISP) > 0  .AND. _lvper .AND. !_lLibSC7
					    //"SPFISF"  /*Pendente sem pedidos de compra que devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					    // Unidade de Medida = UNI
					    aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon11,TRB->ESTQIND-TRB->QTDEDISP})
					    aAdd(_aestoq,{_nperiod,_cconc7,_ccon11,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->QTDEDISP,_ncompra,0.00})
					
				    ELSEIF (TRB->ESTQIND-TRB->QTDEDISP) > 0  .AND. !_lvper .AND. !_lLibSC7
					   //"SPFINF"  /*Pendente sem pedidos de compra que nใo devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					   // Unidade de Medida = UNI
					   aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon12,TRB->ESTQIND-TRB->QTDEDISP})
					   aAdd(_aestoq,{_nperiod,_cconc7,_ccon12,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND-TRB->QTDEDISP,_ncompra,0.00})
				    ENDIF
			    ELSE				                                                                   
				   	IF (TRB->ESTQIND-TRB->QTDEDISP) > 0  .AND. _lvper .AND. !_lLibSC7
					    //"SPFISF"  /*Pendente sem pedidos de compra que devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					    // Unidade de Medida = UNI
					    aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon11,TRB->ESTQIND-TRB->QTDEDISP})
					    aAdd(_aestoq,{_nperiod,_ccon11,"","",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->QTDEDISP,_ncompra,0.00})
					
				    ELSEIF (TRB->ESTQIND-TRB->QTDEDISP) > 0  .AND. !_lvper .AND. !_lLibSC7
					   //"SPFINF"  /*Pendente sem pedidos de compra que nใo devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					   // Unidade de Medida = UNI
					   aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon12,TRB->ESTQIND-TRB->QTDEDISP})
					   aAdd(_aestoq,{_nperiod,_ccon12,"","",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND-TRB->QTDEDISP,_ncompra,0.00})
				    ENDIF
				 ENDIF
				
		ENDCASE
		
	ELSE   // QUANDO TIVER PEDIDO DE COMPRA
		DO CASE
			CASE (TRB->QTDEDISP-TRB->ESTQIND) > 0
				
				IF TRB->ESTQIND <> 0.00
				    //"STKEMS"  /*Estoque comprometido, jแ descontado do estoque disponํvel, ou seja Reservas e os Pedidos em Aberto*/
				    // Unidade de Medida = UNI
					aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc7,TRB->ESTQIND})
				
				    //"STKDIS"  /*Estoque Disponํvel para Vendas */
				    // Unidade de Medida = UNI
				    aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc8,TRB->QTDEDISP-TRB->ESTQIND})
				
				    //IF (TRB->QTDEDISP-TRB->ESTQIND) > 0  .AND. _lvper .AND. _lLibSC7
					//"STTRFA"  /*Estoque em transito que devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					// Unidade de Medida = UNI
				    //	aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon9,_ncompra})
				    //	aAdd(_aestoq,{_nperiod,_cconc7,_cconc8,_cconc9,_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})
					
				    //ELSEIF (TRB->QTDEDISP-TRB->ESTQIND) > 0  .AND. !_lvper .AND. _lLibSC7
					//"STTRNF"  /*Estoque em transito que NAO devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					// Unidade de Medida = UNI
				    //	aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon10,_ncompra})
				     aAdd(_aestoq,{_nperiod,_cconc7,_cconc8,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})
				    //ENDIF
				 ELSE
   				     aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc8,TRB->QTDEDISP-TRB->ESTQIND})				                                                                                                                                                                                                                       
 				     aAdd(_aestoq,{_nperiod,_cconc8,"","",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})
  				 ENDIF
			CASE (TRB->QTDEDISP-TRB->ESTQIND) = 0.00
				//"STKEMS"  /*Estoque comprometido, jแ descontado do estoque disponํvel, ou seja Reservas e os Pedidos em Aberto*/
				// Unidade de Medida = UNI                7
				IF TRB->ESTQIND <> 0.00
					aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc7,TRB->ESTQIND})
					aAdd(_aestoq,{_nperiod,_cconc7,"","",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})
				ENDIF
				
    			
				
				//IF (TRB->QTDEDISP-TRB->ESTQIND) = 0  .AND. _lvper .AND. _lLibSC7
					//"STTRFA"  /*Estoque em transito que devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					// Unidade de Medida = UNI                   ///////
				//	aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon9,_ncompra})
				//	aAdd(_aestoq,{_nperiod,_cconc7,_cconc9,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})
					
				//ELSEIF (TRB->QTDEDISP-TRB->ESTQIND) = 0  .AND. !_lvper .AND. _lLibSC7
					//"STTRNF"  /*Estoque em transito que NAO devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					// Unidade de Medida = UNI
				//  aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon10,_ncompra})
				//	aAdd(_aestoq,{_nperiod,_cconc7,_ccon10,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->ESTQIND,_ncompra,0.00})
				//ENDIF
				
			CASE (TRB->QTDEDISP-TRB->ESTQIND) < 0.00

			  	//IF  (TRB->QTDEDISP-TRB->ESTQIND) < 0.00  .AND. _lvper .AND. _lLibSC7
			  	    //"STKEMS"  /*Estoque comprometido, jแ descontado do estoque disponํvel, ou seja Reservas e os Pedidos em Aberto*/
				    // Unidade de Medida = UNI
				    aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_cconc7,ABS(TRB->QTDEDISP)})                   
				    aAdd(_aestoq,{_nperiod,_cconc7,"","",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->QTDEDISP,_ncompra-(TRB->ESTQIND-TRB->QTDEDISP),0.00})                                    
								
			  		//"STTRFA"  /*Estoque em transito que devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					// Unidade de Medida = UNI
			  		//aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon9,ABS(_ncompra-(TRB->ESTQIND-TRB->QTDEDISP))})
			  		//aAdd(_aestoq,{_nperiod,_cconc7,_cconc9,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->QTDEDISP,_ncompra-(TRB->ESTQIND-TRB->QTDEDISP),0.00})
			  		
			  	    //ELSE (TRB->QTDEDISP-TRB->ESTQIND) < 0.00  .AND. !_lvper .AND. _lLibSC7
					//"STTRNF"  /*Estoque em transito que NAO devera chegar na BGH a tempo de se tornar disponํvel dentro do mes*/
					// Unidade de Medida = UNI
			        //	aAdd(_ageral,{_cregiao,_ccompan,_nperiod,"", _cprod,"",_cunmuni,_ccon10,ABS(_ncompra-(TRB->ESTQIND-TRB->QTDEDISP))})
			        //	aAdd(_aestoq,{_nperiod,_cconc7,_ccon10,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->QTDEDISP,_ncompra-(TRB->ESTQIND-TRB->QTDEDISP),0.00})
			     //ENDIF
		ENDCASE
	ENDIF
	TRB->(dbSkip())
Enddo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ATUADAD  บAutor  ณ EDSON RODRIGUES    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa  e atualiza os dados de vendas e estoque           บฑฑ
ฑฑบ          ณnas tabelas de replicacao BGH-AR e nas de conferencia BGH-BRบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                           
USER FUNCTION ATUADAD()

/*Grava dados do array geral na tabela OUT_DATOS_BI */
ASORT(_ageral)
FOR XG:=1 TO LEN(_ageral)
	_cregiao  :=_ageral[XG,1]
	_ccodvend :=_ageral[XG,4]
	_ccodpro  :=_ageral[XG,5]
	_ccodcli  :=_ageral[XG,6]
	_lins :=.f.
	
	
	_cchav2:=_ageral[XG,1]+ _ageral[XG,2]+ _ageral[XG,3]+ _ageral[XG,4]+ _ageral[XG,5]+ _ageral[XG,6]+ _ageral[XG,7]+ _ageral[XG,8]
	
	IF _cchav2 <> _cchave
		_cchave:= _ageral[XG,1]+ _ageral[XG,2]+ _ageral[XG,3]+ _ageral[XG,4]+ _ageral[XG,5]+ _ageral[XG,6]+ _ageral[XG,7]+ _ageral[XG,8]
		_nit:=XG
		_nvalor:=0.00
		
		
		for itg:=_nit to LEN(_ageral)
			_cchav2:=_ageral[itg,1]+ _ageral[itg,2]+ _ageral[itg,3]+ _ageral[itg,4]+ _ageral[itg,5]+ _ageral[itg,6]+ _ageral[itg,7]+ _ageral[itg,8]
			
			IF _cchav2 ==_cchave
				_lins :=.t.
				_ccreg  :=_ageral[itg,1]
				_ccia   :=_ageral[itg,2]
				_cper   :=_ageral[itg,3]
				_cvend  :=_ageral[itg,4]
				_cprod  :=_ageral[itg,5]
				_clien  :=_ageral[itg,6]
				_cunid  :=_ageral[itg,7]
				_cconce :=_ageral[itg,8]
				_nvalor +=_ageral[itg,9]
				
			ENDIF
		next itg
		IF _lins
			_cQuery := " INSERT INTO OUT_DATOS_BI"
			_cQuery += " (COD_REGION,COD_CIA,PERIODO,COD_VENDEDOR,COD_PRODUCTO,COD_CLIENTE,UNIDAD_MEDIDA,CONCEPTO,VALOR) "
			_cQuery += " VALUES('"+_ccreg+"','"+_ccia+"',"+_cper+",'"+_cvend+"','"+_cprod+"','"+_clien+"','"+_cunid+"','"+_cconce+"',"+AllTrim(Str(_nvalor))+")"
			TCSQLEXEC ( _cQuery )
			TCRefresh("OUT_DATOS_BI")
			
			/*-------Processa e Alimenta Cadastro de Produtos --------------------------------------------------*/
			IF SB1->(DBSeek(xFilial('SB1')+ALLTRIM(_cprod)))
				_cQuery := " SELECT  * FROM OUT_MAE_PRODUCTOS (nolock) "
				_cQuery += " WHERE COD_REGION = '"+_cregiao+"' AND COD_PRODUCTO ='"+_cprod+"' "
				
				TCQUERY _cQuery ALIAS "QryPROD" NEW
				TCRefresh("OUT_MAE_PRODUCTOS")
				
				If QryPROD->(EOF())
					_ccodpro:=ALLTRIM(SB1->B1_COD)
					_cdespro:=ALLTRIM(SB1->B1_DESC)
					_ccodlin:=ALLTRIM(SB1->B1_CODLINH)
					_ccodmar:=ALLTRIM(SB1->B1_CODMARC)
					_ccodfam:=ALLTRIM(SB1->B1_CODFAMI)
					_ccodsub:=ALLTRIM(SB1->B1_CODSUBF)
					_cshcn  :=ALLTRIM(SB1->B1_SHCN)
					_cestoc :=ALLTRIM(SB1->B1_ESTOCAV)
					
					_cQuery := " INSERT INTO OUT_MAE_PRODUCTOS "
					_cQuery += " (COD_REGION,COD_PRODUCTO,DES_PRODUCTO,COD_LINEA,COD_MARCA,COD_FAMILIA,COD_SUBFAMILIA,COD_SHCN,PROD_STOCKEABLE) "
					_cQuery += " VALUES('"+_cregiao+"','"+_ccodpro+"','"+_cdespro+"','"+_ccodlin+"','"+_ccodmar+"','"+_ccodfam+"','"+_ccodsub+"','"+_cshcn+"','"+_cestoc+"') "
					
					TCSQLEXEC ( _cQuery )
					TCRefresh("OUT_MAE_PRODUCTOS")
					
				ENDIF
				IF Select("QryPROD") > 0
					QryPROD->(dbCloseArea())
				ENDIF
			ENDIF
			
			/*-------Processa e Alimenta Cadastro de Clientes --------------------------------------------------*/
			IF SA1->(DBSeek(xFilial('SA1')+ALLTRIM(_clien)))
				_cQuery := " SELECT  * FROM OUT_MAE_CLIENTES (nolock) "
				_cQuery += " WHERE COD_REGION = '"+_cregiao+"' AND COD_CLIENTE ='"+_clien+"' "
				
				TCQUERY _cQuery ALIAS "QryCLI" NEW
				TCRefresh("OUT_MAE_CLIENTES")
				if QryCLI->(EOF())
					_ccodcli := SA1->A1_COD
					_cdescnom := SA1->A1_NOME
					_ccodger := SA1->A1_CODGER
					_ccodcan := SA1->A1_CODCANA
					
					_cQuery := " INSERT INTO OUT_MAE_CLIENTES "
					_cQuery += " (COD_REGION,COD_CLIENTE,RAZ_SOC_CLIENTE,COD_GCIA,COD_CANAL,COD_CANAL2) "
					_cQuery += " VALUES('"+_cregiao+"','"+_ccodcli+"','"+_cdescnom+"','"+_ccodger+"','"+_ccodcan+"','') "
					TCSQLEXEC ( _cQuery )
					TCRefresh("OUT_MAE_CLIENTES")
				Endif
				If Select("QryCLI") > 0
					QryCLI->(dbCloseArea())
				Endif
			ENDIF
			
			/*-------Processa e Alimenta Cadastro de Vendedores  --------------------------------------------------*/
			IF SA3->(DBSeek(xFilial('SA3')+ALLTRIM(_cvend)))
				_cQuery := " SELECT  * FROM OUT_MAE_VENDEDORES (nolock) "
				_cQuery += " WHERE COD_REGION = '"+_cregiao+"' AND COD_VENDEDOR ='"+_cvend+"' "
				
				TCRefresh("OUT_MAE_VENDEDORES")
				TCQUERY _cQuery ALIAS "QryVEN" NEW
				if QryVEN->(EOF())
					_ccodvend := SA3->A3_COD
					_cdesvnom := SA3->A3_NOME
					_ccodforv := SA3->A3_FORVEN
					
					_cQuery := " INSERT INTO OUT_MAE_VENDEDORES "
					_cQuery += " (COD_REGION,COD_VENDEDOR,APE_Y_NOM_VEND,COD_FZA_VTA) "
					_cQuery += " VALUES('"+_cregiao+"','"+_ccodvend+"','"+_cdesvnom+"','"+_ccodforv+"') "
					TCSQLEXEC ( _cQuery )
					TCRefresh("OUT_MAE_VENDEDORES")
				Endif
				if Select("QryVEN") > 0
					QryVEN->(dbCloseArea())
				Endif
			ENDIF
		ENDIF
	ENDIF
NEXT XG

/*Grava dados do array vendas na tabela SZI */
dbSelectArea("SZI")    
FOR XV:=1 TO LEN(_avenda)
	RecLock('SZI',.T.)
	SZI->ZI_FILIAL   := xFilial('SZI')
	SZI->ZI_PEDIDO   := _avenda[XV,4]
	SZI->ZI_CLIENTE  := _avenda[XV,5]
	SZI->ZI_LOJACLI  := _avenda[XV,6]
	SZI->ZI_NOME     := _avenda[XV,7]
	SZI->ZI_CODVEN   := _avenda[XV,10]
	SZI->ZI_NOMEVEN  := _avenda[XV,11]
	SZI->ZI_PRODUTO  := _avenda[XV,12]
	SZI->ZI_DESCPRO  :=_avenda[XV,15]
	SZI->ZI_ITEM     :=_avenda[XV,13]
	SZI->ZI_ARMAZEN  :=_avenda[XV,14]
	SZI->ZI_QTDVEN   :=_avenda[XV,17]
	SZI->ZI_QTDFAT   :=_avenda[XV,18]
	SZI->ZI_VALUNIF  :=IIF(_avenda[XV,18]<>0,_avenda[XV,19],0.00)
	SZI->ZI_VALUNIV  :=_avenda[XV,19]
	SZI->ZI_ICMS     :=_avenda[XV,23]
	SZI->ZI_PIS      :=_avenda[XV,25]
	SZI->ZI_COFINS   :=_avenda[XV,24]
	SZI->ZI_ISS      :=_avenda[XV,26]
	IF _avenda[XV,20]== 0
	   SZI->ZI_VLRTOT   :=_avenda[XV,20]
      
      // Alterado Edson Rodrigues 03/12/10 -- Pois conforme foi detectado,  o sistema calcula o campo ICMS mesmo sendo NF de servi็o.                                                                                                                                                                                                       
      IF alltrim(_avenda[XV,16]) $ "5933/6933/7409"
	        SZI->ZI_VLRLIQU  :=IIF((_avenda[XV,20]) < 0,-1*(ABS(_avenda[XV,20])-ABS(_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,30])),ABS(_avenda[XV,20])-ABS(_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,30]))
	   ELSE
	        SZI->ZI_VLRLIQU  :=IIF((_avenda[XV,20]) < 0,-1*(ABS(_avenda[XV,20])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,30])),ABS(_avenda[XV,20])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,30]))
	   ENDIF     
	
	ELSE
	   //Alterado Edson Rodrigues 22/01/10
	   //SZI->ZI_VLRTOT   :=_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30]	
	   //SZI->ZI_VLRLIQU  :=IIF((_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30]) < 0,-1*(ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,29]+_avenda[XV,30])),ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,29]+_avenda[XV,30]))
	   //                               1            2       3            4                        5                      6                        7                        8                  9                  10                     11                     12               13                        14                         15              16                    17               18                   19                   20                   21                    22                   23                    24                   25                      26                27                   28                     29                  30
	   //	aAdd(_avenda,{_nperiod,_cconc1,"",TRB->D2_DOC,TRB->D2_CLIENTE,TRB->D2_LOJA,SA1->A1_NOME,SA1->A1_MUN,SA1->A1_EST,_cvdedor,TRB->A3_NOME,TRB->D2_COD,TRB->D2_ITEM,TRB->D2_LOCAL,TRB->B1_DESC,TRB->D2_CF,TRB->QTFAT,TRB->QTFAT,TRB->VALVEND,TRB->TOTAL,TRB->D2_DOC,TRB->EMISNF,TRB->VALICM,TRB->VALCOFIN,TRB->VALPIS,TRB->VALISS,TRB->FRETE,TRB->ICMSRET,TRB->DESCONT,TRB->IPI})
	   // Alterado Edson Rodrigues 12/03/10 -- Pois para CFOP 5403 e 6403 deve-se deduzir o ICMSRET do valor bruto para compor o valor liquido e a mesma regra para as devolu็oes - Conforme conversa com Denilza e Andr้.
	   //SZI->ZI_VLRTOT   :=IIF((_avenda[XV,20]) < 0,-1*(ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28])),_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30])
	   //SZI->ZI_VLRLIQU  :=IIF((_avenda[XV,20]) < 0,-1*(ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,29]+_avenda[XV,30])),ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,29]+_avenda[XV,30]))

	  
	   SZI->ZI_VLRTOT   :=IIF((_avenda[XV,20]) < 0,-1*(ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,30])),_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30])

      // Alterado Edson Rodrigues 03/12/10 -- Pois conforme foi detectado,  o sistema calcula o campo ICMS mesmo sendo NF de servi็o.                                                                                                                                                                                                       
      // Alterado Edson Rodrigues 01/02/11 -- Pois conforme Katia Santos, nao e para ser descontado o ICMSRET do faturamento                                                                                                                                                                                                       
      // SZI->ZI_VLRLIQU  :=IIF((_avenda[XV,20]) < 0,-1*(ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,30])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,28]+_avenda[XV,29]+_avenda[XV,30])),ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,28]+_avenda[XV,29]+_avenda[XV,30]))
	  IF alltrim(_avenda[XV,16]) $ "5933/6933/7409"
          SZI->ZI_VLRLIQU  :=IIF((_avenda[XV,20]) < 0,-1*(ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,30])-ABS(_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,29]+_avenda[XV,30])),ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30])-ABS(_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,29]+_avenda[XV,30]))
      ELSE
          SZI->ZI_VLRLIQU  :=IIF((_avenda[XV,20]) < 0,-1*(ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,30])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,29]+_avenda[XV,30])),ABS(_avenda[XV,20]+_avenda[XV,27]+_avenda[XV,28]+_avenda[XV,30])-ABS(_avenda[XV,23]+_avenda[XV,24]+_avenda[XV,25]+_avenda[XV,26]+_avenda[XV,29]+_avenda[XV,30]))
      ENDIF   
	
	ENDIF                                                                            
	
	SZI->ZI_NOTA     :=_avenda[XV,21]
	SZI->ZI_DTEMINF  :=_avenda[XV,22]
	SZI->ZI_CFOP     :=_avenda[XV,16]
	SZI->ZI_CONCAR   :=_avenda[XV,2]
	SZI->ZI_CONCAR2  :=_avenda[XV,3]
	SZI->ZI_DTPROCE  :=dDataBase
	SZI->ZI_FRETE    :=_avenda[XV,27]
	SZI->ZI_ICMSRET  :=_avenda[XV,28]
	SZI->ZI_DESCONT  :=_avenda[XV,29]
	SZI->ZI_IPI      :=_avenda[XV,30]
	SZI->ZI_ANOMES   :=_avenda[XV,1]
	MsUnLock('SZI')
Next

//aAdd(_aestoq,{_nperiod,_cconc7,_ccon10,"",_cprod,_cdescpro,TRB->ARMAZ,TRB->QTDEDISP-TRB->ESTQIND,TRB->QTDEDISP,_ncompra-(TRB->ESTQIND-TRB->QTDEDISP),0.00})
/*Grava dados do array Estoque na tabela SZJ */
dbSelectArea("SZJ")
FOR XE:=1 TO LEN(_aestoq)
	RecLock('SZJ',.T.)
	SZJ->ZJ_FILIAL   :=  xFilial('SZJ')
	SZJ->ZJ_CODPRO   := _aestoq[XE,5]
	SZJ->ZJ_DESCPRO  := _aestoq[XE,6]
	SZJ->ZJ_ARMAZEN  := _aestoq[XE,7]
	SZJ->ZJ_QTDDISP  := _aestoq[XE,8]
	SZJ->ZJ_QTDIND   := _aestoq[XE,9]
	SZJ->ZJ_QTDCOMP  := _aestoq[XE,10]
	SZJ->ZJ_QTDNEGC  := iif(_aestoq[XE,8] < 0.00 .AND. _aestoq[XE,9]<=0.00 .AND. _aestoq[XE,10] == 0.00,iif(abs(_aestoq[XE,8])>=abs(_aestoq[XE,9]),abs(_aestoq[XE,8]),abs(_aestoq[XE,9])),0.00)
	SZJ->ZJ_QTDPENC  := iif(_aestoq[XE,8] < 0.00 .AND. _aestoq[XE,9] > 0.00 .AND.  _aestoq[XE,10] == 0.00,abs(_aestoq[XE,8]),0.00)
	SZJ->ZJ_CONC1   := _aestoq[XE,2]
	SZJ->ZJ_CONC2   := _aestoq[XE,3]
	SZJ->ZJ_CONC3   := _aestoq[XE,4]
	SZJ->ZJ_DTPROCE  := dDataBase
	SZJ->ZJ_ANOMES   := _aestoq[XE,1]
	MsUnLock('SZJ')
Next




dbSelectArea("SZJ")
SZJ->(dbgotop())
While !SZJ->(eof())
	_ccodpro:=ALLTRIM(SZJ->ZJ_CODPRO)
	
	/*-------Processa e Alimenta Cadastro de Produtos --------------------------------------------------*/
	IF SB1->(DBSeek(xFilial('SB1')+_ccodpro))
		
		_cQuery := " SELECT  * FROM OUT_MAE_PRODUCTOS (nolock) "
		_cQuery += " WHERE COD_REGION = '"+_cregiao+"' AND COD_PRODUCTO ='"+_ccodpro+"' "
		
		TCRefresh("OUT_MAE_PRODUCTOS")
		TCQUERY _cQuery ALIAS "QryPROD" NEW
		
		if QryPROD->(EOF())
			_ccodpro:=ALLTRIM(SB1->B1_COD)
			_cdespro:=ALLTRIM(SB1->B1_DESC)
			_ccodlin:=ALLTRIM(SB1->B1_CODLINH)
			_ccodmar:=ALLTRIM(SB1->B1_CODMARC)
			_ccodfam:=ALLTRIM(SB1->B1_CODFAMI)
			_ccodsub:=ALLTRIM(SB1->B1_CODSUBF)
			_cshcn  :=ALLTRIM(SB1->B1_SHCN)
			_cestoc :=ALLTRIM(SB1->B1_ESTOCAV)
			
			_cQuery := " INSERT INTO OUT_MAE_PRODUCTOS "
			_cQuery += " (COD_REGION,COD_PRODUCTO,DES_PRODUCTO,COD_LINEA,COD_MARCA,COD_FAMILIA,COD_SUBFAMILIA,COD_SHCN,PROD_STOCKEABLE) "
			_cQuery += " VALUES('"+_cregiao+"','"+_ccodpro+"','"+_cdespro+"','"+_ccodlin+"','"+_ccodmar+"','"+_ccodfam+"','"+_ccodsub+"','"+_cshcn+"','"+_cestoc+"') "
			TCSQLEXEC ( _cQuery )
			TCRefresh("OUT_MAE_PRODUCTOS")
		Endif
		if Select("QryPROD") > 0
			QryPROD->(dbCloseArea())
		endif
	Endif
	SZJ->(dbSkip())
Enddo
                   


dbSelectArea("SZI")
SZI->(dbgotop())
While !SZI->(eof())
	_ccodpro:=ALLTRIM(SZI->ZI_PRODUTO)
	_clien:=ALLTRIM(SZI->ZI_CLIENTE)
	_cvend:=ALLTRIM(SZI->ZI_CODVEN)
	
	/*-------Processa e Alimenta Cadastro de Produtos --------------------------------------------------*/
	IF SB1->(DBSeek(xFilial('SB1')+_ccodpro))
		
		_cQuery := " SELECT  * FROM OUT_MAE_PRODUCTOS (nolock) "
		_cQuery += " WHERE COD_REGION = '"+_cregiao+"' AND COD_PRODUCTO ='"+_ccodpro+"' "
		
		TCRefresh("OUT_MAE_PRODUCTOS")
		TCQUERY _cQuery ALIAS "QryPROD" NEW
		
		if QryPROD->(EOF())
			_ccodpro:=ALLTRIM(SB1->B1_COD)
			_cdespro:=ALLTRIM(SB1->B1_DESC)
			_ccodlin:=ALLTRIM(SB1->B1_CODLINH)
			_ccodmar:=ALLTRIM(SB1->B1_CODMARC)
			_ccodfam:=ALLTRIM(SB1->B1_CODFAMI)
			_ccodsub:=ALLTRIM(SB1->B1_CODSUBF)
			_cshcn  :=ALLTRIM(SB1->B1_SHCN)
			_cestoc :=ALLTRIM(SB1->B1_ESTOCAV)
			
			_cQuery := " INSERT INTO OUT_MAE_PRODUCTOS "
			_cQuery += " (COD_REGION,COD_PRODUCTO,DES_PRODUCTO,COD_LINEA,COD_MARCA,COD_FAMILIA,COD_SUBFAMILIA,COD_SHCN,PROD_STOCKEABLE) "
			_cQuery += " VALUES('"+_cregiao+"','"+_ccodpro+"','"+_cdespro+"','"+_ccodlin+"','"+_ccodmar+"','"+_ccodfam+"','"+_ccodsub+"','"+_cshcn+"','"+_cestoc+"') "
			TCSQLEXEC ( _cQuery )
			TCRefresh("OUT_MAE_PRODUCTOS")
		Endif
		if Select("QryPROD") > 0
			QryPROD->(dbCloseArea())
		endif
	Endif             
	
	/*-------Processa e Alimenta Cadastro de Clientes --------------------------------------------------*/
	IF SA1->(DBSeek(xFilial('SA1')+ALLTRIM(_clien)))
	   _cQuery := " SELECT  * FROM OUT_MAE_CLIENTES (nolock) "
		_cQuery += " WHERE COD_REGION = '"+_cregiao+"' AND COD_CLIENTE ='"+_clien+"' "
				
				TCRefresh("OUT_MAE_CLIENTES")
				TCQUERY _cQuery ALIAS "QryCLI" NEW
				
				if QryCLI->(EOF())
					_ccodcli := SA1->A1_COD
					_cdescnom := SA1->A1_NOME
					_ccodger := SA1->A1_CODGER
					_ccodcan := SA1->A1_CODCANA
					
					_cQuery := " INSERT INTO OUT_MAE_CLIENTES "
					_cQuery += " (COD_REGION,COD_CLIENTE,RAZ_SOC_CLIENTE,COD_GCIA,COD_CANAL,COD_CANAL2) "
					_cQuery += " VALUES('"+_cregiao+"','"+_ccodcli+"','"+_cdescnom+"','"+_ccodger+"','"+_ccodcan+"','') "
					TCSQLEXEC ( _cQuery )
					TCRefresh("OUT_MAE_CLIENTES")
				Endif
				If Select("QryCLI") > 0
					QryCLI->(dbCloseArea())
				Endif
	ENDIF
			
	/*-------Processa e Alimenta Cadastro de Vendedores  --------------------------------------------------*/
	IF SA3->(DBSeek(xFilial('SA3')+ALLTRIM(_cvend)))
				_cQuery := " SELECT  * FROM OUT_MAE_VENDEDORES (nolock) "
				_cQuery += " WHERE COD_REGION = '"+_cregiao+"' AND COD_VENDEDOR ='"+_cvend+"' "
				
				TCRefresh("OUT_MAE_VENDEDORES")
				TCQUERY _cQuery ALIAS "QryVEN" NEW

			if QryVEN->(EOF())
					_ccodvend := SA3->A3_COD
					_cdesvnom := SA3->A3_NOME
					_ccodforv := SA3->A3_FORVEN
					
					_cQuery := " INSERT INTO OUT_MAE_VENDEDORES "
					_cQuery += " (COD_REGION,COD_VENDEDOR,APE_Y_NOM_VEND,COD_FZA_VTA) "
					_cQuery += " VALUES('"+_cregiao+"','"+_ccodvend+"','"+_cdesvnom+"','"+_ccodforv+"') "
					TCSQLEXEC ( _cQuery )
					TCRefresh("OUT_MAE_VENDEDORES")
			Endif
			if Select("QryVEN") > 0
					QryVEN->(dbCloseArea())
			Endif
	ENDIF
	SZI->(dbSkip())
Enddo

/* faz ultima verifica็ใo para confirmar se todos regitros estใo iguais */
_cQuery := "SELECT DISTINCT BI_COD_CLIENTE FROM V_OUT_DATOS_BI (nolock) WHERE BI_COD_CLIENTE<>'' AND BI_COD_CLIENTE NOT IN "
_cQuery +=" (SELECT BI_COD_CLIENTE FROM V_OUT_MAE_CLIENTES (nolock) ) "

//TCRefresh("REP_DATOS_BI")
TCQUERY _cQuery ALIAS "QryCLI" NEW

dbSelectArea("QryCLI")                               
QryCLI->(dbgotop())                                  
If Select("QryCLI") > 0
   While !QryCLI->(eof())

         IF SA1->(DBSeek(xFilial('SA1')+ALLTRIM(QryCLI->BI_COD_CLIENTE)))      
             _ccodcli := SA1->A1_COD
             _cdescnom := SA1->A1_NOME
             _ccodger := SA1->A1_CODGER
             _ccodcan := SA1->A1_CODCANA
	
             _cQuery := " INSERT INTO OUT_MAE_CLIENTES "
             _cQuery += " (COD_REGION,COD_CLIENTE,RAZ_SOC_CLIENTE,COD_GCIA,COD_CANAL,COD_CANAL2) "
             _cQuery += " VALUES('"+_cregiao+"','"+_ccodcli+"','"+_cdescnom+"','"+_ccodger+"','"+_ccodcan+"','') "
             TCSQLEXEC ( _cQuery )      
             TCRefresh("OUT_MAE_CLIENTES")
         Endif
         QryCLI->(dbSkip())		
   Enddo    
Endif 
QryCLI->(dbCloseArea())                                                                                                                                                         


_cQuery := "SELECT DISTINCT BI_COD_PRODUCTO FROM V_OUT_DATOS_BI (nolock) WHERE BI_COD_PRODUCTO<>'' AND BI_COD_PRODUCTO NOT IN "
_cQuery +=" (SELECT BI_COD_PRODUCTO FROM V_OUT_MAE_PRODUCTOS (nolock) ) "

//TCRefresh("REP_MAE_PRODUCTOS")
TCQUERY _cQuery ALIAS "QryPro" NEW

dbSelectArea("QryPro")
QryPro->(dbgotop())                                    

If Select("QryPro") > 0 
   While !QryPro->(eof())    
   	dbSelectArea("SB1")
      DbSetOrder(1) //B1_FILIAL+B1_COD
      IF SB1->(DBSeek(xFilial('SB1')+alltrim(QryPro->BI_COD_PRODUCTO)))
	     	_ccodpro:=ALLTRIM(SB1->B1_COD)
			_cdespro:=ALLTRIM(SB1->B1_DESC)
			_ccodlin:=ALLTRIM(SB1->B1_CODLINH)
			_ccodmar:=ALLTRIM(SB1->B1_CODMARC)
			_ccodfam:=ALLTRIM(SB1->B1_CODFAMI)
			_ccodsub:=ALLTRIM(SB1->B1_CODSUBF)
			_cshcn  :=ALLTRIM(SB1->B1_SHCN)
			_cestoc :=ALLTRIM(SB1->B1_ESTOCAV)
			
			_cQuery := " INSERT INTO OUT_MAE_PRODUCTOS "
			_cQuery += " (COD_REGION,COD_PRODUCTO,DES_PRODUCTO,COD_LINEA,COD_MARCA,COD_FAMILIA,COD_SUBFAMILIA,COD_SHCN,PROD_STOCKEABLE) "
			_cQuery += " VALUES('"+_cregiao+"','"+_ccodpro+"','"+_cdespro+"','"+_ccodlin+"','"+_ccodmar+"','"+_ccodfam+"','"+_ccodsub+"','"+_cshcn+"','"+_cestoc+"') "
			TCSQLEXEC ( _cQuery )
			TCRefresh("OUT_MAE_PRODUCTOS")
      Endif
      QryPro->(dbSkip())		
    Enddo
Endif        
QryPro->(dbCloseArea())                                                                                                                                                         
                                                                                                                                                                                               

_cQuery := "SELECT DISTINCT BI_COD_VENDEDOR FROM  V_OUT_DATOS_BI (nolock) WHERE BI_COD_VENDEDOR<>'' AND BI_COD_VENDEDOR NOT IN "
_cQuery +=" (SELECT BI_COD_VENDEDOR FROM V_OUT_MAE_VENDEDORES (nolock) ) "

//TCRefresh("REP_MAE_VENDEDORES")
TCQUERY _cQuery ALIAS "QryVen" NEW

dbSelectArea("QryVen")                               
QryVen->(dbgotop())                                  
If Select("QryVen") > 0
   While !QryVen->(eof())
    	 IF SA3->(DBSeek(xFilial('SA3')+ALLTRIM(QryVen->BI_COD_VENDEDOR)))
					_ccodvend := SA3->A3_COD
					_cdesvnom := SA3->A3_NOME
					_ccodforv := SA3->A3_FORVEN
					
					_cQuery := " INSERT INTO OUT_MAE_VENDEDORES "
					_cQuery += " (COD_REGION,COD_VENDEDOR,APE_Y_NOM_VEND,COD_FZA_VTA) "
					_cQuery += " VALUES('"+_cregiao+"','"+_ccodvend+"','"+_cdesvnom+"','"+_ccodforv+"') "
					TCSQLEXEC ( _cQuery )
					TCRefresh("OUT_MAE_VENDEDORES")   
					
					/*
					_cQuery := " INSERT INTO [BI].dbo.REP_MAE_VENDEDORES "
					_cQuery += " (COD_REGION,COD_VENDEDOR,APE_Y_NOM_VEND,COD_FZA_VTA) "
					_cQuery += " VALUES('"+_cregiao+"','"+_ccodvend+"','"+_cdesvnom+"','"+_ccodforv+"') "
					TCSQLEXEC ( _cQuery )
					TCRefresh("[BI].dbo.REP_MAE_VENDEDORES")  
					*/
         Endif
         QryVen->(dbSkip())		
   Enddo    
Endif 
QryVen->(dbCloseArea())                                      


                                                                                                                   
_cStr := "BEFORE_REPLICATION_OUT"
if TCSPExist(_cStr)
	TCSqlExec(_cStr)
Else
	conout("Store Procedure nใo encontrada.")
	//Colocado para executar a procedure, pois a funcao TCSPEXIST nao encontra a procedure mesmo a mesma existindo. 13/05/10 Edson Rodrigues
	TCSqlExec(_cStr)
Endif                                                           
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ verestq  บAutor  ณ EDSON RODRIGUES    บ Data ณ  12/03/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se pedido esta liberado ou bloqueado por estoque   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                           
Static function verestq(_cfilial,_cpedido,_citem)
  Local _lret :=.t.
 
   _cQuery := " SELECT * FROM  "+ RetSQLName("SC9") +" (nolock) "
   _cQuery+= " WHERE C9_BLEST NOT IN ('','10')  AND D_E_L_E_T_='' AND C9_NFISCAL=''  "
   _cQuery+= " AND C9_FILIAL='"+_cfilial+"'  AND  C9_PEDIDO='"+_cpedido+"'  AND C9_ITEM='"+_citem+"' "
   
	TCRefresh(RetSQLName("SC9"))   
   TCQUERY _cQuery ALIAS "QryEstq" NEW
   dbSelectArea("QryEstq")                               
   QryEstq->(dbgotop())                                  
   If Select("QryEstq") > 0                                                                                                                         
     _lret :=.f.
   Endif                                      
  QryEstq->(dbCloseArea())                                      
  
return(_lret)      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ vercred  บAutor  ณ EDSON RODRIGUES    บ Data ณ  12/03/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se pedido esta liberado ou bloqueado por cr้dito   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                           
Static function vercred(_cfilial,_cpedido,_citem)
   Local _lret :=.t.
 
   _cQuery := " SELECT * FROM  "+ RetSQLName("SC9") +" (nolock) "
   _cQuery+= " WHERE C9_BLCRED NOT IN ('','10')  AND D_E_L_E_T_='' AND C9_NFISCAL=''  "
    _cQuery+= " AND C9_FILIAL='"+_cfilial+"'  AND  C9_PEDIDO='"+_cpedido+"'  AND C9_ITEM='"+_citem+"' "   

	TCRefresh(RetSQLName("SC9"))  
   TCQUERY _cQuery ALIAS "QryCred" NEW
   dbSelectArea("QryCred")                               
   QryCred->(dbgotop())                                  
   If Select("QryCred") > 0                                                                                                                         
     _lret :=.f.
   Endif
   QryCred->(dbCloseArea())                            
   
             
return(_lret)                    


