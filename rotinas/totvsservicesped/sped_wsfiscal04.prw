#INCLUDE "PROTHEUS.CH"                                    
#INCLUDE "APWEBSRV.CH"

/* --------------------------------------------- INFORMACOES SOBRE EXPORTACOES */
//��������������������������������������������������������������
//�Informacoes das operacoes de exportacao indireta de produtos�
//�  NAO industrializados pelo estabelecimento emitente.       �
//�- Registro abrangido: 1110                                  �
//��������������������������������������������������������������
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

//��������������������������������������������������Ŀ
//�Informacoes dos documentos fiscais de exportacoes.�
//�- Registro abrangido: 1105                        �
//����������������������������������������������������
WSSTRUCT STR_DFE
	WSDATA MODELO		AS STRING
	WSDATA SERIE		AS STRING
	WSDATA NUMERO		AS STRING
	WSDATA CHVNFE		AS STRING
	WSDATA DTEMISS		AS DATE
	WSDATA CODITEM		AS STRING
	WSDATA EXPIND		AS ARRAY OF STR_EXPIND
ENDWSSTRUCT

//��������������������������������������������Ŀ
//�Informacoes dos registros sobre exportacoes.�
//�- Registros abrangidos: 1100, 1105 e 1110   �
//����������������������������������������������
WSSTRUCT STR_INFEXP
	WSDATA TPDOC		AS INTEGER	//0-Bloco com dados informados e 1-Bloco sem dados informados
	WSDATA NRODE		AS INTEGER
	WSDATA DTDE			AS DATE
	WSDATA NATEXP		AS INTEGER	//0-Exporta��o Direta ou 1-Exporta��o Indireta
	WSDATA NRORE		AS INTEGER
	WSDATA DTRE			AS DATE
	WSDATA CHCEMB		AS INTEGER
	WSDATA DTCHC		AS DATE
	WSDATA DTAVB		AS DATE
	WSDATA TPCHC		AS STRING	//Tipo de documento de carga da tabela SISCOMEX
	WSDATA PAIS			AS INTEGER
	WSDATA DFE			AS ARRAY OF STR_DFE
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_INFEXP
	WSDATA ID_ENT		AS STRING
	WSDATA INFEXP		AS ARRAY OF STR_INFEXP
ENDWSSTRUCT

/* --------------------------------------------- INFORMACOES SOBRE CONTROLE DE CREDITOS FISCAIS */

//��������������������������������������������Ŀ
//�Informacoes de utilizacao do credito fiscal.�
//�- Registro abrangido: 1210                  �
//����������������������������������������������
WSSTRUCT STR_UTILCRD
	WSDATA TPUTIL		AS INTEGER	//0-Dedu��o do ICMS normal, 1-Compensa��o de auto de infra��o, 2-Transfer�ncia de cr�dito, 3-Restitui��o de cr�dito em moeda, 4-Dedu��o do ICMS Substitui��o Tribut�ria apurado no m�s (Substituto), 5-Compensa��o com documento de arrecada��o � (Substitui��o Tribut�ria) e 9-Outros.
	WSDATA NRDOC		AS STRING
	WSDATA VLRCRD		AS FLOAT
ENDWSSTRUCT

//�����������������������������������Ŀ
//�Informacoes dos creditos fiscais.  �
//�- Registros abrangidos: 1200 e 1210�
//�������������������������������������
WSSTRUCT STR_CCF
	WSDATA CODAJ		AS STRING
	WSDATA SLDCRD		AS FLOAT
	WSDATA CRDAPR		AS FLOAT
	WSDATA CRDREC		AS FLOAT
	WSDATA SLDCRDFIM	AS FLOAT
	WSDATA UTILCRD		AS ARRAY OF STR_UTILCRD
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_CCF
	WSDATA ID_ENT		AS STRING
	WSDATA CCF			AS ARRAY OF STR_CCF
ENDWSSTRUCT

/* --------------------------------------------- INFORMACOES SOBRE MOVIMENTACOES DE COMBUSTIVEIS */

//�������������������������������������Ŀ
//�Informacoes sobre o volume de vendas.�
//�- Abrange registro 1310              �
//���������������������������������������
WSSTRUCT STR_VOLVENDAS
	WSDATA NUMTQ		AS STRING
	WSDATA BOMBA		AS STRING
	WSDATA BICO			AS INTEGER
	WSDATA VLRFECH		AS FLOAT
	WSDATA VLRABER		AS FLOAT
	WSDATA AFERICOES	AS FLOAT
	WSDATA VOLVENDLT	AS FLOAT
ENDWSSTRUCT

//�������������������������������������������������������������
//�Informacoes sobre a conciliacao do estoque de combustiveis.�
//�- Abrange o registro 1300.                                 �
//�������������������������������������������������������������
WSSTRUCT STR_CONSCEST
	WSDATA NUMTQ		AS STRING
	WSDATA FECHFIS		AS FLOAT
ENDWSSTRUCT

//������������������������������������������������Ŀ
//�Informacoes sobre movimentacoes de combustiveis.�
//�- Abrange os registros: 1300, 1310 e 1320.      �
//��������������������������������������������������
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

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_MOVCOMB
	WSDATA ID_ENT		AS STRING
	WSDATA MOVCOMB		AS ARRAY OF STR_MOVCOMB
ENDWSSTRUCT
	
/* --------------------------------------------- INFORMACOES SOBRE VALORES AGREGADOS */	

//������������������������������������Ŀ
//�Informacoes sobre valores agregados.�
//�- Abrange o registro 1400           �
//��������������������������������������
WSSTRUCT STR_VLRAGREG
	WSDATA CODITEM		AS STRING
	WSDATA MUN			AS STRING
	WSDATA VLR			AS FLOAT
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_VLRAGREG
	WSDATA ID_ENT		AS STRING
	WSDATA VLRAGREG		AS ARRAY OF STR_VLRAGREG
ENDWSSTRUCT

/* --------------------------- INFORMACOES DE OPERACOES INTERESTADUAIS PELAS EMPRESAS DE ENERGIA ELETRICA SUJEITAS AO CONV.115 */	

//���������������������������������������������������Ŀ
//�Estrutura base dos tributos dos documentos fiscais.�
//�����������������������������������������������������
WSSTRUCT STR_TRIBEE
	WSDATA TPTRIB								AS STRING 	//01=ICMS, 02=ICMS/ST, 03-IPI, 04=ISS, 05=PIS, 06=PIS/ST, 07=COFINS, 08=COFINS/ST, 09=IR, 10=PREVID�NCIA, 11=FECP
	WSDATA CST									AS STRING
	WSDATA BASE									AS FLOAT
	WSDATA ALIQ									AS FLOAT	OPTIONAL
	WSDATA VLR									AS FLOAT
ENDWSSTRUCT

//����������������������������������������������������������������������������������Ŀ
//�Informacoes dos itens das notas fiscais/conta de fornecimento de energia eletrica.�
//�- Abrange os registros: 1500 e 1510                                               �
//������������������������������������������������������������������������������������
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

//������������������������������������������������������������������������Ŀ
//�Informacoes das notas fiscais/conta de fornecimento de energia eletrica.�
//�- Abrange os registros: 1500 e 1510                                     �
//��������������������������������������������������������������������������
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

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_NFCTAEE
	WSDATA ID_ENT		AS STRING
	WSDATA NFCTAEE		AS ARRAY OF STR_NFCTAEE
ENDWSSTRUCT


//�������������������������Ŀ
//�Definicao do WEB SERVICE.�
//���������������������������
WSSERVICE SPEDFISCALOUTRASINF ;
	DESCRIPTION "<b>Servi�o gen�rico de administra��o do Sped Fiscal.</b><br><br>Este servi�o permite a administra��o das tabelas de outras informa��es exigidas pelo FISCO e que n�o se enquadram em nenhum dos servi�os do Sped Fiscal disponibilizados at� o momento."  ;
	NAMESPACE "http://webservices.totvs.com.br/spedfiscaloutrasinf.apw"
	
	WSDATA USERTOKEN       				     		AS STRING
	WSDATA RETORNO        				     		AS BOOLEAN
	
	WSDATA INFEXP									AS SPED_INFEXP
	WSDATA CCF										AS SPED_CCF
	WSDATA MOVCOMB									AS SPED_MOVCOMB
	WSDATA VLRAGREG									AS SPED_VLRAGREG
	WSDATA NFCTAEE									AS SPED_NFCTAEE
	
	WSMETHOD FIS_INFEXP					   			DESCRIPTION "<b>M�todo de administra��o do cadastro de informa��es de exporta��o do Sped Fiscal.</b><br><br>Este m�todo deve ser utilizado para informar ao Sped Fiscal as informa��es de exporta��o direta ou indireta ocorridas no per�odo e que n�o s�o declaradas atrav�s dos servi�os dispon�veis at� o momento.<br><br>Ocorr�ncia:<br>Pode haver v�rios registros sobre exporta��o no per�odo.<br><br>Observa��o:<br>Em seu n�vel imediatamente inferior, devemos informar todos os documentos de exporta��o vinculados, e em caso de exporta��o indireta de produtos n�o industrializados pelo estabelecimento emitente, devemos informar o outro registro imediatamente inferior ao anterior."
	WSMETHOD FIS_CCF		  						DESCRIPTION "<b>M�todo de administra��o do cadastro de informa��es sobre o controle de cr�ditos fiscais de ICMS do Sped Fiscal.</b><br><br>Este m�todo deve ser utilizado para informar ao Sped Fiscal as informa��es de cr�dito de ICMS e sua utiliza��o no per�odo e que n�o s�o declaradas atrav�s dos servi�os dispon�veis at� o momento.<br><br>Ocorr�ncia:<br>Pode haver v�rios registros sobre cr�ditos fiscais de ICMS no per�odo, desde que seja respeitado a chave de identifica��o do registro formada pelo campo 'CODAJ'.<br><br>Observa��o:<br>Em seu n�vel imediatamente inferior, devemos informar a utiliza��o deste cr�dito, podendo ser subdivido conforme op��es do 'TPUTIL'."
	WSMETHOD FIS_MOVCOMB			  				DESCRIPTION	"<b>M�todo de administra��o do cadastro de movimenta��es de combust�veis do Sped Fiscal.</b><br><br>Este m�todo deve ser utilizado para informar ao Sped Fiscal as informa��es de movimenta��es de combust�veis ocorridas no per�odo e que n�o s�o declaradas atrav�s dos servi�os dispon�veis at� o momento.<br><br>Ocorr�ncia:<br>Pode haver v�rios registros sobre movimenta��es de combust�veis no per�odo, desde que se respeite a chave de grava��o das informa��es atrav�s dos campos 'CODITEM + DTFECH' deste m�todo.<br><br>Observa��o:<br>Em seus n�veis imediatamente inferiores, podemos informar o volume de vendas e a concilia��o de estoque f�sico por tanque."
	WSMETHOD FIS_VLRAGREG							DESCRIPTION	"<b>M�todo de administra��o do cadastro de valores agregados do Sped Fiscal.</b><br><br>Este m�todo deve ser utilizado para informar ao Sped Fiscal o calculo do valor adicional por munic�pio, sendo utilizado para subsidiar c�lculo de �ndices de participa��o. Dever� ser preenchido pelo seguintes contribuintes:<br><br>-Empresas que adquirirem, diretamente de produtor, produtos agr�colas, pastoris, extrativos minerais, pescados ou outros produtos extrativos ou agropecu�rio.<br>-Empresas que emitem documentos fiscais de entrada de produ��o pr�pria, de produtos agr�colas, pastoris, extrativos minerais, pescados ou outros produtos extrativos ou agropecu�rio;<br>-Empresas de transporte intermunicipal e interestadual;<br>-Empresas de telecomunica��o e comunica��o;<br>-Empresas de energia;<br>-Servi�o de utilidade p�blica de distribui��o de �gua."
	WSMETHOD FIS_NFCTAEE							DESCRIPTION "<b>M�todo de administra��o do cadastro das notas fiscais/contas de energia el�trica do Sped Fiscal.</b><br><br>Este m�todo deve ser utilizado para informar ao Sped Fiscal as informa��es das opera��es interestaduais efetuadas pelas empresas de energia el�trica, que emitem os documentos em via �nica conforme Conv. 115/03.<br><br>Ocorr�ncia:<br>Pode haver v�rios registros de notas fiscais/conta de energia el�trica no per�odo, desde que seja respeitado a chave de identifica��o do registro formada pelos campos 'TPOPER + EMIT + ID_PART + MODELO + SITUACAO + SERIE + SUBSERIE + CODCONS + NUMERO + DT_EMISSAO + DT_ENTSAI' da estrutura deste m�todo.<br><br>Observa��o:<br>Em seu n�vel imediatamente inferior (ITEM) devemos informar os itens da nota fiscal/conta de energia eletr�ca, que dever� conter caso seja calculado os tributos (ICMS, ICMS/ST, PIS e COFINS) amarrados no n�vel imediatamente inferior ao 'ITEM', identificado como 'TRIBEE'. Os tributos s�o referenciados atrav�s dos c�digos:<br><br>- 01=ICMS;<br>- 02=ICMS/ST;<br>- 03=IPI;<br>- 04=ISS;<br>- 05=PIS;<br>- 06=PIS/ST;<br>- 07=COFINS;<br>- 08=COFINS/ST;<br>- 09=IR;<br>- 10=PREVID�NCIA."
ENDWSSERVICE

WSMETHOD FIS_INFEXP WSRECEIVE USERTOKEN,INFEXP WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

WSMETHOD FIS_CCF WSRECEIVE USERTOKEN,CCF WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

WSMETHOD FIS_MOVCOMB WSRECEIVE USERTOKEN,MOVCOMB WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

WSMETHOD FIS_VLRAGREG WSRECEIVE USERTOKEN,VLRAGREG WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

WSMETHOD FIS_NFCTAEE WSRECEIVE USERTOKEN,NFCTAEE WSSEND RETORNO WSSERVICE SPEDFISCALOUTRASINF

