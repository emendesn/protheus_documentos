#INCLUDE "PROTHEUS.CH"                                    
#INCLUDE "APWEBSRV.CH"

/* --------------------------------------------- INFORMACOES SOBRE EXPORTACOES */
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes das operacoes de exportacao indireta de produtos³
//³  NAO industrializados pelo estabelecimento emitente.       ³
//³- Registro abrangido: 1110                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_EXPIND
	WSDATA ID_PART		AS STRING
	WSDATA MODELO		AS STRING
	WSDATA SERIE		AS STRING
	WSDATA NUMERO		AS STRING
	WSDATA DTEMISS		AS DATE
	WSDATA CHVNFE		AS STRING
	WSDATA NRMEMO		AS INTEGER
	WSDATA QTD			AS FLOAT
	WSDATA UM			AS STRING
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes dos documentos fiscais de exportacoes.³
//³- Registro abrangido: 1105                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_DFE
	WSDATA MODELO		AS STRING
	WSDATA SERIE		AS STRING
	WSDATA NUMERO		AS STRING
	WSDATA CHVNFE		AS STRING
	WSDATA DTEMISS		AS DATE
	WSDATA CODITEM		AS STRING
	WSDATA EXPIND		AS ARRAY OF STR_EXPIND
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes dos registros sobre exportacoes.³
//³- Registros abrangidos: 1100, 1105 e 1110   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_INFEXP
	WSDATA TPDOC		AS INTEGER	//0-Bloco com dados informados e 1-Bloco sem dados informados
	WSDATA NRODE		AS INTEGER
	WSDATA DTDE			AS DATE
	WSDATA NATEXP		AS INTEGER	//0-Exportação Direta ou 1-Exportação Indireta
	WSDATA NRORE		AS INTEGER
	WSDATA DTRE			AS DATE
	WSDATA CHCEMB		AS INTEGER
	WSDATA DTCHC		AS DATE
	WSDATA DTAVB		AS DATE
	WSDATA TPCHC		AS STRING	//Tipo de documento de carga da tabela SISCOMEX
	WSDATA PAIS			AS INTEGER
	WSDATA DFE			AS ARRAY OF STR_DFE
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos arrays de estruturas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT SPED_INFEXP
	WSDATA ID_ENT		AS STRING
	WSDATA INFEXP		AS ARRAY OF STR_INFEXP
ENDWSSTRUCT

/* --------------------------------------------- INFORMACOES SOBRE CONTROLE DE CREDITOS FISCAIS */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes de utilizacao do credito fiscal.³
//³- Registro abrangido: 1210                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_UTILCRD
	WSDATA TPUTIL		AS INTEGER	//0-Dedução do ICMS normal, 1-Compensação de auto de infração, 2-Transferência de crédito, 3-Restituição de crédito em moeda, 4-Dedução do ICMS Substituição Tributária apurado no mês (Substituto), 5-Compensação com documento de arrecadação – (Substituição Tributária) e 9-Outros.
	WSDATA NRDOC		AS STRING
	WSDATA VLRCRD		AS FLOAT
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes dos creditos fiscais.  ³
//³- Registros abrangidos: 1200 e 1210³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_CCF
	WSDATA CODAJ		AS STRING
	WSDATA SLDCRD		AS FLOAT
	WSDATA CRDAPR		AS FLOAT
	WSDATA CRDREC		AS FLOAT
	WSDATA SLDCRDFIM	AS FLOAT
	WSDATA UTILCRD		AS ARRAY OF STR_UTILCRD
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos arrays de estruturas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT SPED_CCF
	WSDATA ID_ENT		AS STRING
	WSDATA CCF			AS ARRAY OF STR_CCF
ENDWSSTRUCT

/* --------------------------------------------- INFORMACOES SOBRE MOVIMENTACOES DE COMBUSTIVEIS */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes sobre o volume de vendas.³
//³- Abrange registro 1310              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_VOLVENDAS
	WSDATA NUMTQ		AS STRING
	WSDATA BOMBA		AS STRING
	WSDATA BICO			AS INTEGER
	WSDATA VLRFECH		AS FLOAT
	WSDATA VLRABER		AS FLOAT
	WSDATA AFERICOES	AS FLOAT
	WSDATA VOLVENDLT	AS FLOAT
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes sobre a conciliacao do estoque de combustiveis.³
//³- Abrange o registro 1300.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_CONSCEST
	WSDATA NUMTQ		AS STRING
	WSDATA FECHFIS		AS FLOAT
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes sobre movimentacoes de combustiveis.³
//³- Abrange os registros: 1300, 1310 e 1320.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_MOVCOMB
	WSDATA CODITEM		AS STRING
	WSDATA DTFECH		AS DATE
	WSDATA NRINTER		AS INTEGER
	WSDATA ESTAB		AS FLOAT
	WSDATA TOTENTR		AS FLOAT
	WSDATA PRCBOMBA		AS FLOAT	//Campo utilizado para calcular o campo 09-VAL_SAIDAS(layout)
	WSDATA VLRPERDA		AS FLOAT
	WSDATA VLRGANHO		AS FLOAT
	WSDATA VOLVENDAS	AS ARRAY OF STR_VOLVENDAS
	WSDATA CONSCEST		AS ARRAY OF STR_CONSCEST
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos arrays de estruturas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT SPED_MOVCOMB
	WSDATA ID_ENT		AS STRING
	WSDATA MOVCOMB		AS ARRAY OF STR_MOVCOMB
ENDWSSTRUCT
	
/* --------------------------------------------- INFORMACOES SOBRE VALORES AGREGADOS */	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes sobre valores agregados.³
//³- Abrange o registro 1400           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_VLRAGREG
	WSDATA CODITEM		AS STRING
	WSDATA MUN			AS STRING
	WSDATA VLR			AS FLOAT
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos arrays de estruturas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT SPED_VLRAGREG
	WSDATA ID_ENT		AS STRING
	WSDATA VLRAGREG		AS ARRAY OF STR_VLRAGREG
ENDWSSTRUCT

/* --------------------------- INFORMACOES DE OPERACOES INTERESTADUAIS PELAS EMPRESAS DE ENERGIA ELETRICA SUJEITAS AO CONV.115 */	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura base dos tributos dos documentos fiscais.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_TRIBEE
	WSDATA TPTRIB								AS STRING 	//01=ICMS, 02=ICMS/ST, 03-IPI, 04=ISS, 05=PIS, 06=PIS/ST, 07=COFINS, 08=COFINS/ST, 09=IR, 10=PREVIDÊNCIA, 11=FECP
	WSDATA CST									AS STRING
	WSDATA BASE									AS FLOAT
	WSDATA ALIQ									AS FLOAT	OPTIONAL
	WSDATA VLR									AS FLOAT
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes dos itens das notas fiscais/conta de fornecimento de energia eletrica.³
//³- Abrange os registros: 1500 e 1510                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_ITEM
	WSDATA NUMITE		AS INTEGER
	WSDATA CODITEM		AS STRING
	WSDATA CODCLASS		AS STRING
	WSDATA QTD			AS FLOAT
	WSDATA UM			AS STRING
	WSDATA VLRTOTAL		AS FLOAT
	WSDATA VLRDESC		AS FLOAT OPTIONAL
	WSDATA CFOP			AS STRING
	WSDATA TPREC		AS STRING	OPTIONAL	//0=RECEITA PROPRIA, 1=RECEITA DE TERCEIROS (PARA OS MODELOS 06 e 28) OU 0=RECEITA PROPRIA - SERVICOS PRESTADOS, 1=RECEITA PROPRIA - COBRANCA DE DEBITOS, 2=RECEITA PROPRIA - VENDA DE MERCADORIAS, 3=RECEITA PROPRIA - VENDA DE SERVICO PRE-PAGO, 4=OUTRAS RECEITAS PROPRIAS, 5=RECEITA DE TERCEIROS(CO-FATURAMENTO), 9=OUTRAS RECEITAS DE TERCEIROS (PARA OS MODELOS 21 e 22)
	WSDATA ID_PARTREC	AS STRING	OPTIONAL
	WSDATA CTACONTABIL	AS STRING
	WSDATA TRIBEE		AS ARRAY OF STR_TRIBEE
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes das notas fiscais/conta de fornecimento de energia eletrica.³
//³- Abrange os registros: 1500 e 1510                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_NFCTAEE
	WSDATA TPOPER		AS STRING	//0=ENTRADA, 1=SAIDA
	WSDATA EMIT			AS STRING	//O=EMISSAO PROPRIA, 1=TERCEIROS
	WSDATA ID_PART		AS STRING
	WSDATA MODELO		AS STRING	//MODELO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.1 DO LAYOUT COTEPE 11/2007
	WSDATA SITUACAO		AS STRING	//SITUACAO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.2 DO LAYOUT COTEPE 11/2007
	WSDATA SERIE		AS STRING
	WSDATA SUBSERIE		AS STRING OPTIONAL
	WSDATA CODCONS		AS STRING
	WSDATA NUMERO		AS STRING
	WSDATA DTEMISS		AS DATE
	WSDATA DTENTSAI		AS DATE
	WSDATA VLRTOTAL		AS FLOAT
	WSDATA VLRDESC		AS FLOAT OPTIONAL
	WSDATA VLRFORCONS	AS FLOAT
	WSDATA VLRSERVNT	AS FLOAT OPTIONAL
	WSDATA VLRTERC		AS FLOAT
	WSDATA VLRDESP		AS FLOAT OPTIONAL
	WSDATA CODINF		AS STRING
	WSDATA ITEM			AS ARRAY OF STR_ITEM
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos arrays de estruturas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT SPED_NFCTAEE
	WSDATA ID_ENT		AS STRING
	WSDATA NFCTAEE		AS ARRAY OF STR_NFCTAEE
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do WEB SERVICE.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE SPEDFISCALOUTRASINF ;
	DESCRIPTION "<b>Serviço genérico de administração do Sped Fiscal.</b><br><br>Este serviço permite a administração das tabelas de outras informações exigidas pelo FISCO e que não se enquadram em nenhum dos serviços do Sped Fiscal disponibilizados até o momento."  ;
	NAMESPACE "http://webservices.totvs.com.br/spedfiscaloutrasinf.apw"
	
	WSDATA USERTOKEN       				     		AS STRING
	WSDATA RETORNO        				     		AS BOOLEAN
	
	WSDATA INFEXP									AS SPED_INFEXP
	WSDATA CCF										AS SPED_CCF
	WSDATA MOVCOMB									AS SPED_MOVCOMB
	WSDATA VLRAGREG									AS SPED_VLRAGREG
	WSDATA NFCTAEE									AS SPED_NFCTAEE
	
	WSMETHOD FIS_INFEXP					   			DESCRIPTION "<b>Método de administração do cadastro de informações de exportação do Sped Fiscal.</b><br><br>Este método deve ser utilizado para informar ao Sped Fiscal as informações de exportação direta ou indireta ocorridas no período e que não são declaradas através dos serviços disponíveis até o momento.<br><br>Ocorrência:<br>Pode haver vários registros sobre exportação no período.<br><br>Observação:<br>Em seu nível imediatamente inferior, devemos informar todos os documentos de exportação vinculados, e em caso de exportação indireta de produtos não industrializados pelo estabelecimento emitente, devemos informar o outro registro imediatamente inferior ao anterior."
	WSMETHOD FIS_CCF		  						DESCRIPTION "<b>Método de administração do cadastro de informações sobre o controle de créditos fiscais de ICMS do Sped Fiscal.</b><br><br>Este método deve ser utilizado para informar ao Sped Fiscal as informações de crédito de ICMS e sua utilização no período e que não são declaradas através dos serviços disponíveis até o momento.<br><br>Ocorrência:<br>Pode haver vários registros sobre créditos fiscais de ICMS no período, desde que seja respeitado a chave de identificação do registro formada pelo campo 'CODAJ'.<br><br>Observação:<br>Em seu nível imediatamente inferior, devemos informar a utilização deste crédito, podendo ser subdivido conforme opções do 'TPUTIL'."
	WSMETHOD FIS_MOVCOMB			  				DESCRIPTION	"<b>Método de administração do cadastro de movimentações de combustíveis do Sped Fiscal.</b><br><br>Este método deve ser utilizado para informar ao Sped Fiscal as informações de movimentações de combustíveis ocorridas no período e que não são declaradas através dos serviços disponíveis até o momento.<br><br>Ocorrência:<br>Pode haver vários registros sobre movimentações de combustíveis no período, desde que se respeite a chave de gravação das informações através dos campos 'CODITEM + DTFECH' deste método.<br><br>Observação:<br>Em seus níveis imediatamente inferiores, podemos informar o volume de vendas e a conciliação de estoque físico por tanque."
	WSMETHOD FIS_VLRAGREG							DESCRIPTION	"<b>Método de administração do cadastro de valores agregados do Sped Fiscal.</b><br><br>Este método deve ser utilizado para informar ao Sped Fiscal o calculo do valor adicional por município, sendo utilizado para subsidiar cálculo de índices de participação. Deverá ser preenchido pelo seguintes contribuintes:<br><br>-Empresas que adquirirem, diretamente de produtor, produtos agrícolas, pastoris, extrativos minerais, pescados ou outros produtos extrativos ou agropecuário.<br>-Empresas que emitem documentos fiscais de entrada de produção própria, de produtos agrícolas, pastoris, extrativos minerais, pescados ou outros produtos extrativos ou agropecuário;<br>-Empresas de transporte intermunicipal e interestadual;<br>-Empresas de telecomunicação e comunicação;<br>-Empresas de energia;<br>-Serviço de utilidade pública de distribuição de água."
	WSMETHOD FIS_NFCTAEE							DESCRIPTION "<b>Método de administração do cadastro das notas fiscais/contas de energia elétrica do Sped Fiscal.</b><br><br>Este método deve ser utilizado para informar ao Sped Fiscal as informações das operações interestaduais efetuadas pelas empresas de energia elétrica, que emitem os documentos em via única conforme Conv. 115/03.<br><br>Ocorrência:<br>Pode haver vários registros de notas fiscais/conta de energia elétrica no período, desde que seja respeitado a chave de identificação do registro formada pelos campos 'TPOPER + EMIT + ID_PART + MODELO + SITUACAO + SERIE + SUBSERIE + CODCONS + NUMERO + DT_EMISSAO + DT_ENTSAI' da estrutura deste método.<br><br>Observação:<br>Em seu nível imediatamente inferior (ITEM) devemos informar os itens da nota fiscal/conta de energia eletríca, que deverá conter caso seja calculado os tributos (ICMS, ICMS/ST, PIS e COFINS) amarrados no nível imediatamente inferior ao 'ITEM', identificado como 'TRIBEE'. Os tributos são referenciados através dos códigos:<br><br>- 01=ICMS;<br>- 02=ICMS/ST;<br>- 03=IPI;<br>- 04=ISS;<br>- 05=PIS;<br>- 06=PIS/ST;<br>- 07=COFINS;<br>- 08=COFINS/ST;<br>- 09=IR;<br>- 10=PREVIDÊNCIA."
ENDWSSERVICE

WSMETHOD FIS_INFEXP WSRECEIVE USERTOKEN,INFEXP WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

WSMETHOD FIS_CCF WSRECEIVE USERTOKEN,CCF WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

WSMETHOD FIS_MOVCOMB WSRECEIVE USERTOKEN,MOVCOMB WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

WSMETHOD FIS_VLRAGREG WSRECEIVE USERTOKEN,VLRAGREG WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

WSMETHOD FIS_NFCTAEE WSRECEIVE USERTOKEN,NFCTAEE WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

