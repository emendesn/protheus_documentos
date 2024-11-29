#INCLUDE "PROTHEUS.CH"                                    
#INCLUDE "APWEBSRV.CH"

/* --------------------------------------------------------------- ICMS */
                                     
//�����������������������������������������������������������Ŀ
//�informacoes da apuracao de ICMS sobre obrigacoes a recolher�
//�- Abrange os registros E116 e E250.                        �
//�������������������������������������������������������������
WSSTRUCT STR_ICOBRREC
	WSDATA CODIGO		AS STRING
	WSDATA VLR			AS FLOAT
	WSDATA DTVECTO		AS DATE
	WSDATA CODREC		AS STRING
	WSDATA NUMPROC		AS STRING	OPTIONAL
	WSDATA INDPROC		AS STRING	OPTIONAL	//0-Sefaz, 1-Justi�a Federal, 2-Justi�a Estadual, 9-Outros
	WSDATA DESPROC		AS STRING	OPTIONAL
	WSDATA TXTCOMPL		AS STRING	OPTIONAL
ENDWSSTRUCT

//�������������������������������������������
//�informacoes adicionais a apuracao de ICMS�
//�- Abrange o registro E115                �
//�������������������������������������������
WSSTRUCT STR_ICINFAD
	WSDATA CODIGO		AS 	INTEGER
	WSDATA VLR			AS	FLOAT
ENDWSSTRUCT

//�������������������������������������������������Ŀ
//�Informacoes dos ajustes da apuracao de ICMS      �
//�- Abrange o registro E111, E220                  �
//���������������������������������������������������
WSSTRUCT STR_ICAJBEIN
	WSDATA AJUSTEID		AS 	STRING
	WSDATA CODAJ		AS 	STRING
	WSDATA DESCAJ		AS 	STRING
	WSDATA VLRAJ		AS 	FLOAT
ENDWSSTRUCT

//�������������������������������������������������������Ŀ
//�Informacoes das operacoes proprias da apuracao de ICMS �
//�- Abrange os registros: E110, E111, E115, E116, E210,  �
//�  E220, E230, E240, E250.                              �
//���������������������������������������������������������
WSSTRUCT STR_ICOPPRO
	WSDATA SLDCRDANT	AS 	FLOAT OPTIONAL
	WSDATA VLREXTRA		AS 	FLOAT OPTIONAL
	WSDATA VLRSTDEVOL	AS 	FLOAT OPTIONAL
	WSDATA VLRSTRESS	AS 	FLOAT OPTIONAL
	WSDATA ICAJBEIN		AS 	ARRAY OF STR_ICAJBEIN OPTIONAL
	WSDATA ICINFAD		AS 	ARRAY OF STR_ICINFAD OPTIONAL
	WSDATA ICOBRREC		AS	ARRAY OF STR_ICOBRREC OPTIONAL
ENDWSSTRUCT

//�������������������������������������������������������Ŀ
//�Informacoes da apuracao de ICMS do movimento.          �
//�- Abrange os registros: E100, E110, E111, E115, E116   �
//�  E200, E210, E220, E230, E240, E250.                  �
//���������������������������������������������������������
WSSTRUCT STR_APURICMS
	WSDATA APID			AS 	STRING
	WSDATA UFST			AS 	STRING
	WSDATA DTINI		AS 	DATE
	WSDATA DTFIM		AS 	DATE
	WSDATA TPIMP		AS 	INTEGER	//0-ICMS, 1=ICMS/ST
	WSDATA ICOPPRO		AS 	STR_ICOPPRO
ENDWSSTRUCT

//��������������������������������������������������������������������������������Ŀ
//�informacoes adicionais da apuracao de ICMS referente a documentos de arrecadacao�
//�- Abrange os registros E112, E230.                                              �
//����������������������������������������������������������������������������������
WSSTRUCT STR_ICAJ
	WSDATA AJUSTEID		AS 	STRING
	WSDATA NUMDA		AS	STRING OPTIONAL
	WSDATA NUMPROC		AS 	STRING OPTIONAL
	WSDATA INDPROC		AS	INTEGER OPTIONAL	//0-Sefaz, 1-Justi�a Federal, 2-Justi�a Estadual, 9-Outros
	WSDATA DESPROC		AS 	STRING OPTIONAL
	WSDATA CODOBS		AS 	STRING OPTIONAL
ENDWSSTRUCT

//�������������������������������������������������������������������������������������������Ŀ
//�informacoes adicionais da apuracao de ICMS referente a identificacao dos documentos fiscais�
//�- Abrange os registros E113 e E240.                                                        �
//���������������������������������������������������������������������������������������������
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

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������ 
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

//�������������������������������������������Ŀ
//�Informacoes dos ajustes da apuracao do IPI.�
//���������������������������������������������
WSSTRUCT STR_IPAJ
	WSDATA INDAJ  		AS STRING	//0-Ajuste a debito, 1-Ajuste a credito
	WSDATA VLR			AS FLOAT
	WSDATA CODAJ		AS STRING 	//Tabela 4.5.4
	WSDATA INDDOC		AS STRING	//0-Processo Judicial, 1-Processo administrativo, 2-PER/DCOMP ou 9-Outros.
	WSDATA NUMDOC		AS STRING
	WSDATA DESAJ		AS STRING
ENDWSSTRUCT 

//��������������������������������������������Ŀ
//�Informacoes da apuracao de IPI do movimento.�
//����������������������������������������������
WSSTRUCT STR_APURIPI
	WSDATA APID			AS 	STRING
	WSDATA INDAPUR		AS 	STRING	//0-Mensal, 1-Decendial
	WSDATA DTINI		AS 	DATE
	WSDATA DTFIM		AS 	DATE
	WSDATA SLDCRDANT	AS 	FLOAT OPTIONAL
	WSDATA IPAJ			AS ARRAY OF STR_IPAJ OPTIONAL
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������ 
WSSTRUCT SPED_APURIPI
	WSDATA ID_ENT		AS STRING
	WSDATA APURIPI		AS STR_APURIPI
ENDWSSTRUCT

WSSERVICE SPEDFISCALAPURACAO ;
	DESCRIPTION "<b>Servi�o gen�rico de administra��o do Sped Fiscal.</b><br><br>Este servi�o permite a administra��o das tabelas de Apura��o de ICMS e/ou do IPI do projeto Sped Fiscal."  ;
	NAMESPACE "http://webservices.totvs.com.br/spedfiscalapuracao.apw"
	
	//VARIAVEIS GERAIS
	WSDATA USERTOKEN    AS STRING
	WSDATA ID_ENT       AS STRING
	WSDATA MSG			AS STRING
	
	WSDATA APURICMS		AS SPED_APURICMS
	WSDATA APURIPI		AS SPED_APURIPI
	WSDATA ICAJ			AS SPED_ICAJ
	WSDATA ICIDF		AS SPED_ICIDF

	WSMETHOD FIS_APURICMS	DESCRIPTION	"<b>Servi�o de administra��o da Apura��o de ICMS do Sped Fiscal.</b><br><br>Este servi�o tem como objetivo cadastrar os lan�amentos fiscais da Apura��o de ICMS do per�odo; estas informa��es formam uma base de dados para gera��o do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorr�ncia:<br>- Para o ICMS, pode haver somente um cadastro por per�odo, representado pela chave 'APID + TPIMP + DTINI + DTFIM' formada pelo campos da estrutura deste servi�o;<br>- Para o ICMS/ST, pode haver v�rias Apura��es por servi�o, cuja chave � 'APID + TPIMP + UFST + DTINI + DTFIM' formada pelos campos da estrutura deste servi�o. <br><br>Seu n�vel imediatamente inferior deve representar o(s) ajustes da Apura��o de ICMS, podendo haver v�rios para cada lan�amento fiscal.<br><br>Observa��o:<br>Para diferenciar uma Apura��o de ICMS de uma Apura��o de ICMS/ST utilizamos o campo 'TPIMP' contido na estrutura deste servi�o, onde quando seu conte�do estiver como 0, indicar� ICMS, quando estiver como 1, indicar� ICMS/ST."
	WSMETHOD FIS_APURIPI	DESCRIPTION	"<b>Servi�o de administra��o da Apura��o de IPI do Sped Fiscal.</b><br><br>Este servi�o tem como objetivo cadastrar os lan�amentos fiscais da Apura��o de IPI do per�odo; estas informa��es formam uma base de dados para gera��o do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorr�ncia:<br>Pode haver somente um cadastro de Apura��o de IPI por per�odo, representado pela chave 'APID + DTINI + DTFIM' formada pelo campos da estrutura deste servi�o.<br><br>Seu n�vel imediatamente inferior deve representar o(s) ajustes da Apura��o de IPI, podendo haver v�rios para cada lan�amento fiscal."
	WSMETHOD FIS_ICAJ		DESCRIPTION	"<b>Servi�o de administra��o da Apura��o de ICMS do Sped Fiscal.</b><br><br>Este servi�o tem como objetivo cadastrar os detalhamentos dos ajustes enviados atrav�s do servi�o FIS_APURICMS (nesta p�gina) quando forem relacionados a processos judiciais ou fiscais ou a documentos de arrecada��o, observada a legisla��o estadual pertinente; estas informa��es formam uma base de dados para gera��o do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorr�ncia:<br>Pode haver v�rios detalhamentos para cada ajuste relacionado no n�vel imediatamente inferior do servi�o FIS_APURICMS, desde que o campo 'AJUSTEID' fa�a refer�ncia entre eles."
	WSMETHOD FIS_ICIDF		DESCRIPTION	"<b>Servi�o de administra��o da Apura��o de ICMS do Sped Fiscal.</b><br><br>Este servi�o tem como objetivo cadastrar os ajustes dos documentos fiscais que n�o foram declarados atrav�s do servi�o SPEDFISCALMOVIMENTOS/FISDFOBS_LANCFIS; estas informa��es formam uma base de dados para gera��o do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorr�ncia:<br>Pode haver v�rios ajustes de documentos fiscais relacionado no n�vel imediatamente inferior do servi�o FIS_APURICMS, desde que o campo 'AJUSTEID' fa�a refer�ncia entre eles."
ENDWSSERVICE

WSMETHOD FIS_APURICMS WSRECEIVE USERTOKEN,APURICMS WSSEND MSG WSSERVICE SPEDFISCALAPURACAO

WSMETHOD FIS_APURIPI WSRECEIVE USERTOKEN,APURIPI WSSEND MSG WSSERVICE SPEDFISCALAPURACAO

WSMETHOD FIS_ICAJ WSRECEIVE USERTOKEN,ICAJ WSSEND MSG WSSERVICE SPEDFISCALAPURACAO

WSMETHOD FIS_ICIDF WSRECEIVE USERTOKEN,ICIDF WSSEND MSG WSSERVICE SPEDFISCALAPURACAO

