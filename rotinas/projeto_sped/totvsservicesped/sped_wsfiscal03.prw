#INCLUDE "PROTHEUS.CH"                                    
#INCLUDE "APWEBSRV.CH"

/* --------------------------------------------------------------- ICMS */
                                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³informacoes da apuracao de ICMS sobre obrigacoes a recolher³
//³- Abrange os registros E116 e E250.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_ICOBRREC
	WSDATA CODIGO		AS STRING
	WSDATA VLR			AS FLOAT
	WSDATA DTVECTO		AS DATE
	WSDATA CODREC		AS STRING
	WSDATA NUMPROC		AS STRING	OPTIONAL
	WSDATA INDPROC		AS STRING	OPTIONAL	//0-Sefaz, 1-Justiça Federal, 2-Justiça Estadual, 9-Outros
	WSDATA DESPROC		AS STRING	OPTIONAL
	WSDATA TXTCOMPL		AS STRING	OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³informacoes adicionais a apuracao de ICMS³
//³- Abrange o registro E115                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_ICINFAD
	WSDATA CODIGO		AS 	INTEGER
	WSDATA VLR			AS	FLOAT
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes dos ajustes da apuracao de ICMS      ³
//³- Abrange o registro E111, E220                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_ICAJBEIN
	WSDATA AJUSTEID		AS 	STRING
	WSDATA CODAJ		AS 	STRING
	WSDATA DESCAJ		AS 	STRING
	WSDATA VLRAJ		AS 	FLOAT
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes das operacoes proprias da apuracao de ICMS ³
//³- Abrange os registros: E110, E111, E115, E116, E210,  ³
//³  E220, E230, E240, E250.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_ICOPPRO
	WSDATA SLDCRDANT	AS 	FLOAT OPTIONAL
	WSDATA VLREXTRA		AS 	FLOAT OPTIONAL
	WSDATA VLRSTDEVOL	AS 	FLOAT OPTIONAL
	WSDATA VLRSTRESS	AS 	FLOAT OPTIONAL
	WSDATA ICAJBEIN		AS 	ARRAY OF STR_ICAJBEIN OPTIONAL
	WSDATA ICINFAD		AS 	ARRAY OF STR_ICINFAD OPTIONAL
	WSDATA ICOBRREC		AS	ARRAY OF STR_ICOBRREC OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes da apuracao de ICMS do movimento.          ³
//³- Abrange os registros: E100, E110, E111, E115, E116   ³
//³  E200, E210, E220, E230, E240, E250.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_APURICMS
	WSDATA APID			AS 	STRING
	WSDATA UFST			AS 	STRING
	WSDATA DTINI		AS 	DATE
	WSDATA DTFIM		AS 	DATE
	WSDATA TPIMP		AS 	INTEGER	//0-ICMS, 1=ICMS/ST
	WSDATA ICOPPRO		AS 	STR_ICOPPRO
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³informacoes adicionais da apuracao de ICMS referente a documentos de arrecadacao³
//³- Abrange os registros E112, E230.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_ICAJ
	WSDATA AJUSTEID		AS 	STRING
	WSDATA NUMDA		AS	STRING OPTIONAL
	WSDATA NUMPROC		AS 	STRING OPTIONAL
	WSDATA INDPROC		AS	INTEGER OPTIONAL	//0-Sefaz, 1-Justiça Federal, 2-Justiça Estadual, 9-Outros
	WSDATA DESPROC		AS 	STRING OPTIONAL
	WSDATA CODOBS		AS 	STRING OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³informacoes adicionais da apuracao de ICMS referente a identificacao dos documentos fiscais³
//³- Abrange os registros E113 e E240.                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_ICIDF
	WSDATA AJUSTEID		AS 	STRING
	WSDATA ID_PART		AS STRING
	WSDATA MODELO		AS STRING	//MODELO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.1 DO LAYOUT COTEPE 11/2007
	WSDATA SERIE		AS STRING
	WSDATA SUBSERIE		AS STRING  	OPTIONAL
	WSDATA NUMERO		AS STRING
	WSDATA DTEMISS		AS DATE
	WSDATA CHVNFE		AS STRING 	OPTIONAL
	WSDATA CODITE		AS STRING
	WSDATA VLR			AS FLOAT
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos arrays de estruturas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
WSSTRUCT SPED_APURICMS
	WSDATA ID_ENT		AS STRING
	WSDATA APURICMS		AS ARRAY OF STR_APURICMS
ENDWSSTRUCT

WSSTRUCT SPED_ICAJ
	WSDATA ID_ENT		AS STRING
	WSDATA ICAJ			AS ARRAY OF STR_ICAJ
ENDWSSTRUCT

WSSTRUCT SPED_ICIDF
	WSDATA ID_ENT		AS STRING
	WSDATA ICIDF		AS ARRAY OF STR_ICIDF
ENDWSSTRUCT

/* --------------------------------------------------------------- IPI */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes dos ajustes da apuracao do IPI.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_IPAJ
	WSDATA INDAJ  		AS STRING	//0-Ajuste a debito, 1-Ajuste a credito
	WSDATA VLR			AS FLOAT
	WSDATA CODAJ		AS STRING 	//Tabela 4.5.4
	WSDATA INDDOC		AS STRING	//0-Processo Judicial, 1-Processo administrativo, 2-PER/DCOMP ou 9-Outros.
	WSDATA NUMDOC		AS STRING
	WSDATA DESAJ		AS STRING
ENDWSSTRUCT 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informacoes da apuracao de IPI do movimento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT STR_APURIPI
	WSDATA APID			AS 	STRING
	WSDATA INDAPUR		AS 	STRING	//0-Mensal, 1-Decendial
	WSDATA DTINI		AS 	DATE
	WSDATA DTFIM		AS 	DATE
	WSDATA SLDCRDANT	AS 	FLOAT OPTIONAL
	WSDATA IPAJ			AS ARRAY OF STR_IPAJ OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos arrays de estruturas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
WSSTRUCT SPED_APURIPI
	WSDATA ID_ENT		AS STRING
	WSDATA APURIPI		AS STR_APURIPI
ENDWSSTRUCT

WSSERVICE SPEDFISCALAPURACAO ;
	DESCRIPTION "<b>Serviço genérico de administração do Sped Fiscal.</b><br><br>Este serviço permite a administração das tabelas de Apuração de ICMS e/ou do IPI do projeto Sped Fiscal."  ;
	NAMESPACE "http://webservices.totvs.com.br/spedfiscalapuracao.apw"
	
	//VARIAVEIS GERAIS
	WSDATA USERTOKEN    AS STRING
	WSDATA ID_ENT       AS STRING
	WSDATA MSG			AS STRING
	
	WSDATA APURICMS		AS SPED_APURICMS
	WSDATA APURIPI		AS SPED_APURIPI
	WSDATA ICAJ			AS SPED_ICAJ
	WSDATA ICIDF		AS SPED_ICIDF

	WSMETHOD FIS_APURICMS	DESCRIPTION	"<b>Serviço de administração da Apuração de ICMS do Sped Fiscal.</b><br><br>Este serviço tem como objetivo cadastrar os lançamentos fiscais da Apuração de ICMS do período; estas informações formam uma base de dados para geração do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorrência:<br>- Para o ICMS, pode haver somente um cadastro por período, representado pela chave 'APID + TPIMP + DTINI + DTFIM' formada pelo campos da estrutura deste serviço;<br>- Para o ICMS/ST, pode haver várias Apurações por serviço, cuja chave é 'APID + TPIMP + UFST + DTINI + DTFIM' formada pelos campos da estrutura deste serviço. <br><br>Seu nível imediatamente inferior deve representar o(s) ajustes da Apuração de ICMS, podendo haver vários para cada lançamento fiscal.<br><br>Observação:<br>Para diferenciar uma Apuração de ICMS de uma Apuração de ICMS/ST utilizamos o campo 'TPIMP' contido na estrutura deste serviço, onde quando seu conteúdo estiver como 0, indicará ICMS, quando estiver como 1, indicará ICMS/ST."
	WSMETHOD FIS_APURIPI	DESCRIPTION	"<b>Serviço de administração da Apuração de IPI do Sped Fiscal.</b><br><br>Este serviço tem como objetivo cadastrar os lançamentos fiscais da Apuração de IPI do período; estas informações formam uma base de dados para geração do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorrência:<br>Pode haver somente um cadastro de Apuração de IPI por período, representado pela chave 'APID + DTINI + DTFIM' formada pelo campos da estrutura deste serviço.<br><br>Seu nível imediatamente inferior deve representar o(s) ajustes da Apuração de IPI, podendo haver vários para cada lançamento fiscal."
	WSMETHOD FIS_ICAJ		DESCRIPTION	"<b>Serviço de administração da Apuração de ICMS do Sped Fiscal.</b><br><br>Este serviço tem como objetivo cadastrar os detalhamentos dos ajustes enviados através do serviço FIS_APURICMS (nesta página) quando forem relacionados a processos judiciais ou fiscais ou a documentos de arrecadação, observada a legislação estadual pertinente; estas informações formam uma base de dados para geração do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorrência:<br>Pode haver vários detalhamentos para cada ajuste relacionado no nível imediatamente inferior do serviço FIS_APURICMS, desde que o campo 'AJUSTEID' faça referência entre eles."
	WSMETHOD FIS_ICIDF		DESCRIPTION	"<b>Serviço de administração da Apuração de ICMS do Sped Fiscal.</b><br><br>Este serviço tem como objetivo cadastrar os ajustes dos documentos fiscais que não foram declarados através do serviço SPEDFISCALMOVIMENTOS/FISDFOBS_LANCFIS; estas informações formam uma base de dados para geração do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorrência:<br>Pode haver vários ajustes de documentos fiscais relacionado no nível imediatamente inferior do serviço FIS_APURICMS, desde que o campo 'AJUSTEID' faça referência entre eles."
ENDWSSERVICE

WSMETHOD FIS_APURICMS WSRECEIVE USERTOKEN,APURICMS WSSEND MSG WSSERVICE SPEDFISCALAPURACAO

WSMETHOD FIS_APURIPI WSRECEIVE USERTOKEN,APURIPI WSSEND MSG WSSERVICE SPEDFISCALAPURACAO

WSMETHOD FIS_ICAJ WSRECEIVE USERTOKEN,ICAJ WSSEND MSG WSSERVICE SPEDFISCALAPURACAO

WSMETHOD FIS_ICIDF WSRECEIVE USERTOKEN,ICIDF WSSEND MSG WSSERVICE SPEDFISCALAPURACAO

