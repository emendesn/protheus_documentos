#INCLUDE "PROTHEUS.CH"                                    
#INCLUDE "APWEBSRV.CH"

//����������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos itens dos documentos fiscais.�
//������������������������������������������������������������������
WSSTRUCT STRIT_ITEM
	WSDATA NUMITE								AS INTEGER
	WSDATA CODITE								AS STRING
	WSDATA QTD									AS FLOAT	OPTIONAL
	WSDATA UM									AS STRING
	WSDATA VLRTOTIT								AS FLOAT
	WSDATA VLRDESC								AS FLOAT	OPTIONAL
	WSDATA MOVFIS								AS STRING	//0=SIM, 1=NAO
	WSDATA CFOP									AS STRING
	WSDATA CODNAT								AS STRING
	WSDATA CTACONTABIL							AS STRING	OPTIONAL
	WSDATA OUTVLR								AS FLOAT	OPTIONAL
	WSDATA DESCCOMPL							AS STRING	OPTIONAL
	WSDATA TPAPIPI								AS STRING	OPTIONAL	//0=MENSAL, 1=DECENDIAL
	WSDATA ENQIPI								AS STRING	OPTIONAL
	WSDATA QTDBSPIS								AS FLOAT	OPTIONAL
	WSDATA ALQPISVLR							AS FLOAT	OPTIONAL
	WSDATA QTDBSCOF								AS FLOAT	OPTIONAL
	WSDATA ALQCOFVLR							AS FLOAT	OPTIONAL
ENDWSSTRUCT

//������������������������������������������������Ŀ
//�Estrutura base do cabecalho do documento fiscal.�
//��������������������������������������������������
WSSTRUCT STR_DOCFIS
	WSDATA NFID									AS STRING
	WSDATA TPOPER								AS STRING	//0=ENTRADA, 1=SAIDA
	WSDATA EMIT									AS STRING	//O=EMISSAO PROPRIA, 1=TERCEIROS
	WSDATA ID_PART								AS STRING
	WSDATA MODELO								AS STRING	//MODELO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.1 DO LAYOUT COTEPE 11/2007
	WSDATA SITUACAO								AS INTEGER	//SITUACAO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.2 DO LAYOUT COTEPE 11/2007
	WSDATA SERIE								AS STRING	OPTIONAL
	WSDATA SUBSERIE								AS STRING  	OPTIONAL
	WSDATA NUMERO								AS STRING
	WSDATA CHVNFE								AS INTEGER 	OPTIONAL
	WSDATA DTEMIS								AS DATE
	WSDATA DTENTSAI								AS DATE
	WSDATA VLRTOTAL								AS FLOAT
	WSDATA VLRDESC								AS FLOAT	OPTIONAL
	WSDATA VLRABAT								AS FLOAT	OPTIONAL
	WSDATA VLRMERC								AS FLOAT
	WSDATA TPFRT								AS STRING	//0=POR CONTA TERCEIROS, 1=POR CONTA EMITENTE, 2=POR CONTA DESTINATARIO, 9=SEM FRETE
	WSDATA VLRFRT								AS FLOAT	OPTIONAL
	WSDATA VLRSEG								AS FLOAT	OPTIONAL
	WSDATA VLRDESP								AS FLOAT	OPTIONAL
	WSDATA CTACONTABIL							AS STRING	OPTIONAL
	WSDATA CODOBS								AS STRING	OPTIONAL
	WSDATA ITEM									AS ARRAY OF STRIT_ITEM
ENDWSSTRUCT


// -------------------------------------- ANEXOS AO DOCUMENTO FISCAL (CABECALHO) -------------------------------------- //


//����������������������������������������������������������������������Ŀ
//�Estrutura base das infomacoes de ajustes das observacoes do lancamento�
//� fiscal.                                                              �
//������������������������������������������������������������������������
WSSTRUCT STR_LANCFIS
	WSDATA CODAJUSTE							AS STRING
	WSDATA DESCCOMPL							AS STRING	OPTIONAL
	WSDATA CODITEM								AS STRING	OPTIONAL
	WSDATA BASICMS								AS FLOAT
	WSDATA ALQICMS								AS FLOAT
	WSDATA VLRICMS								AS FLOAT
	WSDATA OUTVLR								AS FLOAT	OPTIONAL
ENDWSSTRUCT

//�������������������������������������������������������������������Ŀ
//�Estrutura base das observacoes complementares por documento fiscal.�
//���������������������������������������������������������������������
WSSTRUCT STR_OBS_LANCFIS
	WSDATA NFID									AS STRING
	WSDATA CODOBS								AS STRING
	WSDATA TXTCOMPL								AS STRING
	WSDATA LANCFIS								AS ARRAY OF STR_LANCFIS	OPTIONAL
ENDWSSTRUCT

//������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares dos documentos�
//�  fiscais de Energia Eletrica, modelo 06.                   �
//��������������������������������������������������������������
WSSTRUCT STR_COMPL_EE
	WSDATA NFID									AS STRING
	WSDATA IDCLCONS								AS INTEGER	OPTIONAL
	WSDATA VLRFORCONS							AS FLOAT	OPTIONAL
	WSDATA VLRTERC								AS FLOAT	OPTIONAL
	WSDATA CONSKWH								AS INTEGER	OPTIONAL
	WSDATA NOMVOL115							AS STRING	OPTIONAL
	WSDATA CHVCD115								AS STRING	OPTIONAL
ENDWSSTRUCT

//��������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos terminais faturados para as notas�
//� fiscais:                                                           �
//�- Nota fiscal de servico de comunicacao(21)                         �
//�- Nota fiscal de servico de telecomunicacao(22)                     �
//����������������������������������������������������������������������
WSSTRUCT STR_TERMINAL
	WSDATA TPSERV								AS STRING	//0=TELEFONIA, 1=COMUNICACAO DE DADOS, 2=TV POR ASSINATURA, 3=PROVIMENTO DE ACESSO A INTERNET, 4=MULTIMIDIA, 9=OUTROS
	WSDATA DTINI								AS DATE
	WSDATA DTFIM								AS DATE
	WSDATA PERFIS								AS STRING
	WSDATA IDAREA								AS STRING
	WSDATA IDTERM								AS STRING
	WSDATA CODMUN								AS STRING
ENDWSSTRUCT

//������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares aos documentos�
//� fiscais de comunicacao (21) e telecomunicacao (22).        �
//��������������������������������������������������������������
WSSTRUCT STR_COMPL_COMTEL
	WSDATA NFID									AS STRING
	//WSDATA IDCLCONS								AS STRING	OPTIONAL
	WSDATA VLRTERC								AS FLOAT	OPTIONAL
	WSDATA NOMVOL115							AS STRING	OPTIONAL
	WSDATA CHVCD115								AS STRING	OPTIONAL
	WSDATA TERMINAL								AS ARRAY OF STR_TERMINAL
ENDWSSTRUCT

//������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares aos documentos�
//� fiscais de fornecimento de GAS (29) e AGUA(28)             �
//��������������������������������������������������������������
WSSTRUCT STR_COMPL_GAS_AGUA
	WSDATA NFID									AS STRING
	WSDATA IDCLCONS				   				AS INTEGER	OPTIONAL
	WSDATA VLRFORCONS			   				AS FLOAT	OPTIONAL
	WSDATA VLRTERC								AS FLOAT	OPTIONAL
ENDWSSTRUCT

//�������������������������������������������������������Ŀ
//�Estrutura base para informacoes sobre os documentos de �
//� importacao referenciado ao documento fiscal.          �
//���������������������������������������������������������
WSSTRUCT STR_COMPL_IMPORT
	WSDATA NFID									AS STRING
	WSDATA TPDOCIMP				  				AS STRING
	WSDATA NUMDOC								AS STRING
	WSDATA VLRPIS								AS FLOAT
	WSDATA VLRCOF								AS FLOAT
ENDWSSTRUCT

//��������������������������������������������������������������Ŀ
//�Estrutura base das informacoes sobre os volumes transportados,�
//� combustiveis ou nao, referenciados ao documento fiscal.      �
//����������������������������������������������������������������
WSSTRUCT STR_COMPL_VOLTRANSP
	WSDATA NFID									AS STRING
	WSDATA IDTRANSP						  		AS STRING	OPTIONAL
	WSDATA IDVEIC						  		AS STRING	OPTIONAL
	WSDATA QTDVOL						  		AS FLOAT	OPTIONAL
	WSDATA PSBRU						  		AS FLOAT	OPTIONAL
	WSDATA PSLIQ						  		AS FLOAT	OPTIONAL
	WSDATA IDAUTSEF						  		AS STRING	OPTIONAL
	WSDATA NUMPASFIS					  		AS STRING	OPTIONAL
	WSDATA HSAIDA						  		AS INTEGER	OPTIONAL
	WSDATA TEMP							  		AS FLOAT	OPTIONAL
	WSDATA NOMMOT						  		AS STRING	OPTIONAL
	WSDATA CPFMOT						  		AS STRING	OPTIONAL
ENDWSSTRUCT

//��������������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes da coleta/entrega dos volumes transportados�
//�  referenciado a observacao complementar do documento fiscal.             �
//|                                                                          |
//| OBS: Estrutura utilizada tanto para as observacoes complementares do     |
//|      documento(01, 1B e 04) quanto para os documentos de transportes     |
//|      (07, 08, 09, 10, 11 e 26)                                           |
//����������������������������������������������������������������������������
WSSTRUCT STR_LOC_COLENT
	WSDATA TP_TRANSP				   			AS STRING	//O=RODOVIARIO, 1=FERROVIARIO, 2=RODO-FERROVIARIO, 3=AQUAVIARIO, 4=DUTOVIARIO, 5=AEREO, 9=OUTROS
	WSDATA CNPJ_COL					   			AS STRING	OPTIONAL
	WSDATA IE_COL					   			AS STRING	OPTIONAL
	WSDATA CPF_COL					   			AS STRING	OPTIONAL
	WSDATA IDMUN_COL	   						AS STRING
	WSDATA CNPJ_ENT				   				AS STRING	OPTIONAL
	WSDATA IE_ENT				   				AS STRING	OPTIONAL
	WSDATA CPF_ENT					   			AS STRING	OPTIONAL
	WSDATA IDMUN_ENT				   			AS STRING
ENDWSSTRUCT

//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de carga transportada por documento�
//� fiscal, para os modelos (07, 08, 09, 10, 11 E 26).               �
//��������������������������������������������������������������������
WSSTRUCT STR_COMPL_CARGATRANSP
	WSDATA NFID									AS STRING
	WSDATA CPFCNPJ_REM							AS STRING
	WSDATA UF_REM								AS STRING
	WSDATA IE_REM								AS STRING
	WSDATA CPFCNPJ_DEST							AS STRING
	WSDATA UF_DEST								AS STRING
	WSDATA IE_DEST								AS STRING
	WSDATA MODELO								AS STRING
	WSDATA SERIE								AS STRING
	WSDATA NUMERO								AS STRING
	WSDATA DTEMIS								AS DATE
	WSDATA CHVNFE								AS INTEGER
	WSDATA VLRTOT								AS FLOAT
	WSDATA VLRMER								AS FLOAT
	WSDATA QTDVOL								AS FLOAT
	WSDATA PSBRU								AS FLOAT
	WSDATA PSLIQ								AS FLOAT
	WSDATA LOC_COLENT							AS STR_LOC_COLENT
ENDWSSTRUCT

//��������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos documentos de transportes, sendo:�
//�- Nota Fiscal servico transporte(07)                                �
//����������������������������������������������������������������������
WSSTRUCT STR_COMPL_NFST
	WSDATA NFID									AS STRING
	WSDATA CODMUNORI					   		AS STRING
	WSDATA CODMUNDES							AS STRING
	WSDATA IDVEIC								AS STRING
ENDWSSTRUCT

//��������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos documentos de transportes, sendo:�
//�- Conhecimento rodoviario de cargas(08)                             �
//����������������������������������������������������������������������
WSSTRUCT STR_COMPL_CTRC
	WSDATA NFID									AS STRING
	WSDATA IDCONSIG								AS STRING	OPTIONAL
	WSDATA IDREDESP								AS STRING	OPTIONAL
	WSDATA TPFRTRED								AS STRING	OPTIONAL	//0=SEM REDESPACHO, 1=POR CONTA EMITENTE, 2=POR CONTA DESTINATARIO, 9=OUTROS
	WSDATA CODMUNORI							AS STRING
	WSDATA CODMUNDES							AS STRING
	WSDATA IDVEIC								AS STRING
	WSDATA VLRLIQ								AS FLOAT	OPTIONAL
	WSDATA VLRSECCAT							AS FLOAT	OPTIONAL
	WSDATA VLRDESP								AS FLOAT	OPTIONAL
	WSDATA VLRPDG								AS FLOAT	OPTIONAL
	WSDATA OUTVLR								AS FLOAT	OPTIONAL
	WSDATA VLRTOT								AS FLOAT	OPTIONAL
ENDWSSTRUCT

//��������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos documentos de transportes, sendo:�
//�- Conhecimento aquaviario de cargas(09)                             �
//����������������������������������������������������������������������
WSSTRUCT STR_COMPL_CTAQC
	WSDATA NFID									AS STRING
	WSDATA IDCONSIG								AS STRING	OPTIONAL
	WSDATA CODMUNORI							AS STRING
	WSDATA CODMUNDES							AS STRING
	WSDATA TPVEIC								AS STRING	OPTIONAL	//0=EMBARCACAO, 1=EMPURRADOR/REBOCADOR
	WSDATA IDVEIC								AS STRING
	WSDATA TPNAVEG								AS STRING	//0=INTERIOR,1=CABOTAGEM
	WSDATA NUMVIAG								AS INTEGER	OPTIONAL
	WSDATA VLRLIQ								AS FLOAT	OPTIONAL
	WSDATA VLRDESPOR							AS FLOAT	OPTIONAL
	WSDATA VLRDESPCD							AS FLOAT	OPTIONAL
	WSDATA OUTVLR								AS FLOAT	OPTIONAL
	WSDATA VLRBRU								AS FLOAT
	WSDATA VLRMM								AS FLOAT	OPTIONAL
ENDWSSTRUCT
                                                       
//��������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos documentos de transportes, sendo:�
//�- Conhecimento aereo(10)                                            �
//����������������������������������������������������������������������
WSSTRUCT STR_COMPL_CTAEC
	WSDATA NFID									AS STRING
	WSDATA CODMUNORI							AS STRING
	WSDATA CODMUNDES							AS STRING
	WSDATA IDVEIC								AS STRING
	WSDATA NUMVOO	 							AS INTEGER	OPTIONAL
	WSDATA TPTAR								AS STRING	OPTIONAL	//0=EXP, 1=ENC, 2=CI, 9=OUTRA
	WSDATA PSTAX								AS FLOAT	OPTIONAL
	WSDATA VLRTER								AS FLOAT	OPTIONAL
	WSDATA VLRRED								AS FLOAT	OPTIONAL
	WSDATA OUTVLR								AS FLOAT	OPTIONAL
	WSDATA VLRADV								AS FLOAT	OPTIONAL
ENDWSSTRUCT

//��������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos documentos de transportes, sendo:�
//�- Multimodal de cargas(26)                                          �
//����������������������������������������������������������������������
WSSTRUCT STR_COMPL_CTMC
	WSDATA NFID									AS STRING
	WSDATA IDCONSIG								AS STRING	OPTIONAL
	WSDATA IDREDESP								AS STRING	OPTIONAL
	WSDATA CODMUNORI							AS STRING
	WSDATA CODMUNDES							AS STRING
	WSDATA ROTM									AS STRING	OPTIONAL
	WSDATA NATFRT								AS STRING	OPTIONAL	//0=NEGOCIAVEL, 1=NAO NEGOCIAVEL
	WSDATA VLRLIQ								AS FLOAT	OPTIONAL
	WSDATA VLRGRIS								AS FLOAT	OPTIONAL
	WSDATA VLRPDG								AS FLOAT	OPTIONAL
	WSDATA OUTVLR								AS FLOAT	OPTIONAL	
	WSDATA VLRTOT								AS FLOAT
	WSDATA IDVEIC								AS STRING		
ENDWSSTRUCT

//�����������������������������������������������������������������������Ŀ
//�Estrutura base para as informacoes dos modais utilizados no transporte.�
//�������������������������������������������������������������������������
WSSTRUCT STR_MODAIS
	WSDATA NFID									AS STRING
	WSDATA NUMSEQ								AS INTEGER
	WSDATA TPEMIT								AS STRING	//0=EMISSAO PROPRIA, 1=TERCEIROS
	WSDATA CNPJEMIT								AS STRING
	WSDATA UFEMIT								AS STRING
	WSDATA IEEMIT								AS STRING
	WSDATA CODMUNORI							AS STRING
	WSDATA CNPJTOM								AS STRING
	WSDATA UFTOM								AS STRING
	WSDATA IETOM								AS STRING
	WSDATA CODMUNDES							AS STRING
	WSDATA MODELO								AS STRING
	WSDATA SERIE								AS STRING
	WSDATA SUBSERIE								AS STRING
	WSDATA NUMERO								AS STRING
	WSDATA DTEMIS								AS DATE
	WSDATA VLRTOT								AS FLOAT
ENDWSSTRUCT

//������������������������������������������������������������
//�Estrutura base das parcelas do titulo do documento fiscal.�
//������������������������������������������������������������
WSSTRUCT STR_PARCELAS
	WSDATA NUMERO								AS INTEGER
	WSDATA DTVENC								AS DATE
	WSDATA VLR									AS FLOAT
ENDWSSTRUCT

//�������������������������������������������������������������Ŀ
//�Estrutura base das informacoes do titulo do documento fiscal.�
//���������������������������������������������������������������
WSSTRUCT STR_TITULO
	WSDATA NFID									AS STRING
	WSDATA TPPGTO								AS STRING 	//0=A VISTA, 1=A PRAZO, 9=SEM PAGAMENTO	
	WSDATA TPEMIT								AS STRING	//O=EMISSAO PROPRIA, 1=TERCEIROS
	WSDATA TPTIT								AS STRING	//00=DUPLICATA, 01=CHEQUE, 02=PROMISSORIA, 03=RECIBO, 99=OUTROS(DESCREVER)
	WSDATA DESCCOMPL							AS STRING  	OPTIONAL
	WSDATA NUMTIT								AS STRING
	WSDATA PARCELA								AS ARRAY OF STR_PARCELAS
ENDWSSTRUCT

//���������������������������������������������������Ŀ
//�Estrutura base dos tributos dos documentos fiscais.�
//�����������������������������������������������������
WSSTRUCT STR_TRIBUTOS
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER	OPTIONAL	//QUANDO ESTE CAMPO ESTIVER EM BRANCO, SIGNIFICA QUE ESTA SENDO ENVIADO ATUALIZACAO PARA O CABECALHO, QUANDO ESTIVER PREENCHIDO, EH PARA O ITEM
	WSDATA TPTRIB								AS STRING 	//01=ICMS, 02=ICMS/ST, 03-IPI, 04=ISS, 05=PIS, 06=PIS/ST, 07=COFINS, 08=COFINS/ST, 09=IR, 10=PREVID�NCIA, 11=FECP
	WSDATA CST									AS STRING
	WSDATA BASE									AS FLOAT
	WSDATA ALIQ									AS FLOAT	OPTIONAL
	WSDATA VLR									AS FLOAT
ENDWSSTRUCT

//���������������������������������������������������������������Ŀ
//�Estrutura base dos processos referenciados ao documento fiscal.�
//�����������������������������������������������������������������
WSSTRUCT STR_PROCREF
	WSDATA NUMERO								AS STRING
	WSDATA INDORI				   				AS STRING	//0=SEFAZ, 1=JUSTICA FEDERAL, 2=JUSTICA ESTADUAL, 3=SECEX/RFB, 9=OUTROS
ENDWSSTRUCT

//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares do documento fiscal.�
//��������������������������������������������������������������������
WSSTRUCT STR_INFCOMPL_PROCREF
	WSDATA NFID									AS STRING
	WSDATA CODIGO								AS STRING
	WSDATA COMPL								AS STRING
	WSDATA PROCREF								AS ARRAY OF STR_PROCREF	OPTIONAL
ENDWSSTRUCT

//��������������������������������������������������������������Ŀ
//�Estrutura base para as informacoes do documento de arrecadacao�
//�   referenciado a informacao complementar do documento fiscal.�
//����������������������������������������������������������������
WSSTRUCT STR_DA
	WSDATA CODMOD				   				AS STRING	//0=DOCUMENTO ESTADUAL DE ARRECADACAO, 1=GNRE
	WSDATA UF					  				AS STRING
	WSDATA NUMDOC								AS STRING
	WSDATA CODAUT								AS STRING
	WSDATA VLR				   					AS FLOAT
	WSDATA DTVCTO				   				AS DATE
	WSDATA DTPGTO								AS DATE
ENDWSSTRUCT

//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares do documento fiscal.�
//��������������������������������������������������������������������
WSSTRUCT STR_INFCOMPL_DA
	WSDATA NFID									AS STRING
	WSDATA CODIGO								AS STRING
	WSDATA COMPL								AS STRING
	WSDATA DA									AS ARRAY OF STR_DA 	OPTIONAL
ENDWSSTRUCT

//��������������������������������������������������������������������������
//�Estrutura base para as informacoes dos documentos fiscais referenciados �
//� ao principal para cada observacao complementar do documento fiscal.    �
//��������������������������������������������������������������������������
WSSTRUCT STR_DFREF
	WSDATA INDOPER		 						AS STRING	//0=ENTRADA/AQUISICAO, 1=SAIDA/PRESTACAO
	WSDATA INDEMIT				   				AS STRING	//0=EMISSAO PROPRIA, 1=TERCEIROS
	WSDATA ID_PART	   			   				AS STRING
	WSDATA MODELO				   				AS STRING
	WSDATA SERIE								AS STRING
	WSDATA SUBSERIE				   				AS STRING
	WSDATA NUMERO								AS STRING
	WSDATA DTEMIS								AS DATE
ENDWSSTRUCT

//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares do documento fiscal.�
//��������������������������������������������������������������������
WSSTRUCT STR_INFCOMPL_DFREF
	WSDATA NFID									AS STRING
	WSDATA CODIGO								AS STRING
	WSDATA COMPL								AS STRING
	WSDATA DFREF								AS ARRAY OF STR_DFREF 	OPTIONAL
ENDWSSTRUCT

//����������������������������������������������������������������������
//�Estrutura base para as informacoes dos cupons fiscais referenciados �
//� a observacao complementar do documento fiscal.                     �
//����������������������������������������������������������������������
WSSTRUCT STR_CFREF
	WSDATA MODELO					  			AS STRING
	WSDATA SERFAB								AS STRING
	WSDATA CXECF								AS INTEGER
	WSDATA NUMERO								AS STRING
	WSDATA DTEMIS					 			AS DATE
ENDWSSTRUCT

//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares do documento fiscal.�
//��������������������������������������������������������������������
WSSTRUCT STR_INFCOMPL_CFREF
	WSDATA NFID									AS STRING
	WSDATA CODIGO								AS STRING
	WSDATA COMPL 								AS STRING
	WSDATA CFREF								AS ARRAY OF STR_CFREF	OPTIONAL
ENDWSSTRUCT

//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares do documento fiscal.�
//��������������������������������������������������������������������
WSSTRUCT STR_INFCOMPL_LOC_COLENT
	WSDATA NFID									AS STRING
	WSDATA CODIGO								AS STRING
	WSDATA COMPL								AS STRING
	WSDATA LOC_COLENT							AS ARRAY OF STR_LOC_COLENT	OPTIONAL
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_DOCFIS
	WSDATA ID_ENT								AS STRING
	WSDATA DOCFIS								AS ARRAY OF STR_DOCFIS
ENDWSSTRUCT

WSSTRUCT SPED_OBS_LANCFIS
	WSDATA ID_ENT							  	AS STRING
	WSDATA OBS_LANCFIS						  	AS ARRAY OF STR_OBS_LANCFIS
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_EE
	WSDATA ID_ENT								AS STRING
	WSDATA COMPL_EE						   		AS ARRAY OF STR_COMPL_EE
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_COMTEL
	WSDATA ID_ENT					  			AS STRING
	WSDATA COMPL_COMTEL							AS ARRAY OF STR_COMPL_COMTEL
ENDWSSTRUCT
              
WSSTRUCT SPED_COMPL_GAS_AGUA
	WSDATA ID_ENT								AS STRING
	WSDATA COMPL_GAS_AGUA						AS ARRAY OF STR_COMPL_GAS_AGUA
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_IMPORT
	WSDATA ID_ENT							  	AS STRING
	WSDATA COMPL_IMPORT						  	AS ARRAY OF STR_COMPL_IMPORT
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_VOLTRANSP
	WSDATA ID_ENT							  	AS STRING
	WSDATA COMPL_VOLTRANSP					 	AS ARRAY OF STR_COMPL_VOLTRANSP
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_CARGATRANSP
	WSDATA ID_ENT							   	AS STRING
	WSDATA COMPL_CARGATRANSP				  	AS ARRAY OF STR_COMPL_CARGATRANSP
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_NFST
	WSDATA ID_ENT								AS STRING
	WSDATA COMPL_NFST							AS ARRAY OF STR_COMPL_NFST
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_CTRC
	WSDATA ID_ENT								AS STRING
	WSDATA COMPL_CTRC							AS ARRAY OF STR_COMPL_CTRC
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_CTAQC
	WSDATA ID_ENT								AS STRING
	WSDATA COMPL_CTAQC							AS ARRAY OF STR_COMPL_CTAQC
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_CTAEC
	WSDATA ID_ENT								AS STRING
	WSDATA COMPL_CTAEC							AS ARRAY OF STR_COMPL_CTAEC
ENDWSSTRUCT

WSSTRUCT SPED_COMPL_CTMC
	WSDATA ID_ENT								AS STRING
	WSDATA COMPL_CTMC							AS ARRAY OF STR_COMPL_CTMC
ENDWSSTRUCT

WSSTRUCT SPED_MODAIS
	WSDATA ID_ENT					   			AS STRING	
	WSDATA MODAIS	 							AS ARRAY OF STR_MODAIS
ENDWSSTRUCT

WSSTRUCT SPED_TITULO
	WSDATA ID_ENT							   	AS STRING
	WSDATA TITULO							  	AS ARRAY OF STR_TITULO
ENDWSSTRUCT

WSSTRUCT SPED_TRIBUTOS
	WSDATA ID_ENT								AS STRING
	WSDATA TRIBUTOS								AS ARRAY OF STR_TRIBUTOS
ENDWSSTRUCT

WSSTRUCT SPED_INFCOMPL_PROCREF
	WSDATA ID_ENT								AS STRING
	WSDATA INFCOMPL_PROCREF						AS ARRAY OF STR_INFCOMPL_PROCREF
ENDWSSTRUCT

WSSTRUCT SPED_INFCOMPL_DA
	WSDATA ID_ENT			  					AS STRING
	WSDATA INFCOMPL_DA							AS ARRAY OF STR_INFCOMPL_DA
ENDWSSTRUCT

WSSTRUCT SPED_INFCOMPL_DFREF
	WSDATA ID_ENT								AS STRING
	WSDATA INFCOMPL_DFREF						AS ARRAY OF STR_INFCOMPL_DFREF
ENDWSSTRUCT

WSSTRUCT SPED_INFCOMPL_CFREF
	WSDATA ID_ENT								AS STRING
	WSDATA INFCOMPL_CFREF						AS ARRAY OF STR_INFCOMPL_CFREF
ENDWSSTRUCT

WSSTRUCT SPED_INFCOMPL_LOC_COLENT
	WSDATA ID_ENT								AS STRING
	WSDATA INFCOMPL_LOC_COLENT					AS ARRAY OF STR_INFCOMPL_LOC_COLENT
ENDWSSTRUCT


// -------------------------------------- ANEXOS AO ITEM DO DOCUMENTO FISCAL -------------------------------------- //


//������������������������������������������������������������������������������
//�Estrutura base das informacoes complementares dos itens dos documentos      �
//�  fiscais de Energia El�trica (06), Comunica��o (21), Telecomunica��o (22), �
//�  �gua (29) e G�s (28) canalizado.                                          �
//������������������������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_IT
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA CODCLASS								AS INTEGER	OPTIONAL
	WSDATA TPREC								AS STRING	OPTIONAL	//0=RECEITA PROPRIA, 1=RECEITA DE TERCEIROS (PARA OS MODELOS 06 e 28) OU 0=RECEITA PROPRIA - SERVICOS PRESTADOS, 1=RECEITA PROPRIA - COBRANCA DE DEBITOS, 2=RECEITA PROPRIA - VENDA DE MERCADORIAS, 3=RECEITA PROPRIA - VENDA DE SERVICO PRE-PAGO, 4=OUTRAS RECEITAS PROPRIAS, 5=RECEITA DE TERCEIROS(CO-FATURAMENTO), 9=OUTRAS RECEITAS DE TERCEIROS (PARA OS MODELOS 21 e 22)
	WSDATA ID_PARTREC							AS STRING	OPTIONAL
ENDWSSTRUCT
                     
//�������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de armazenamento de combustiveis por�
//� item de documento fical.                                          |
//���������������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_ARMCOMB
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA NUMTANQ								AS STRING
	WSDATA QTDARM								AS FLOAT
ENDWSSTRUCT

//����������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de operacoes com medicamentos por�
//� item de documento fiscal.                                      |
//������������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_MEDIC
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA NUMLOT								AS STRING
	WSDATA QTDLOT								AS FLOAT
	WSDATA DTFAB								AS DATE
	WSDATA DTVAL								AS DATE
	WSDATA TPBCICST								AS STRING	//0=BC REFERENTE PRECO TABELADO OU PRECO MAXIMO SUGERIDO, 1=BC, MARGEM DE VALOR AGREGADO, 2=BC REFERENTE LISTA NEGATIVA, 3=BC REFERENTE LISTA POSITIVA, 4=BC REFERENTE LISTA NEUTRA
	WSDATA TPMED								AS STRING	//0=SIMILAR, 1=GENERICO, 2=ETICO OU DE MARCA
	WSDATA PRMAXTAB								AS FLOAT
ENDWSSTRUCT

//�����������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de operacoes com armas de fogo por�
//� item de documento fiscal.                                       |
//�������������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_ARMAS
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA TPARMA								AS STRING	//0=USO PERMITIDO, 1=USO RESTRITO
	WSDATA NUMSER								AS STRING
	WSDATA DESC									AS STRING
ENDWSSTRUCT
                        
//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de operacoes com veiculos novos por�
//� item de documento fiscal.                                        |
//��������������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_VEICULOS
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA TPOPER								AS STRING	//0=VENDA PARA CONCESSIONARIA, 1=FATURAMENTO DIRETO, 2=VENDA DIRETA, 3=VENDA DA CONCESSIONARIA, 9=OUTROS
	WSDATA CNPJCONC								AS STRING
	WSDATA UFCONC								AS STRING
	WSDATA CHASSI								AS STRING
ENDWSSTRUCT

//���������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes das ultimas entradas com ressarcimento�
//� de ICMS nas operacoes com ST por item de documento fiscal.          �
//�����������������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_RESSARC
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA MODELO								AS STRING
	WSDATA NUMERO								AS STRING
	WSDATA SERIE								AS STRING
	WSDATA DTULTENT								AS DATE
	WSDATA ID_PART								AS STRING
	WSDATA QTD									AS FLOAT
	WSDATA VLRUNIT								AS FLOAT
	WSDATA BASEST								AS FLOAT
ENDWSSTRUCT

//��������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de operacoes com produtos sujeitos ao�
//� selo de controle por item de documento fiscal.                     �
//����������������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_SELO
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA CODSELO								AS STRING
	WSDATA QTD									AS FLOAT
ENDWSSTRUCT

//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de operacao com produtos sujeitos a�
//� tributacao do IPI por unidade ou quantidade por item de documento�
//| fiscal.                                                          |
//��������������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_IPI
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA CLASSENQ								AS STRING	//CONFORME TABELA 4.5.1
	WSDATA VLR									AS FLOAT
	WSDATA QTD									AS FLOAT
ENDWSSTRUCT

//���������������������������������������������������������������Ŀ
//�Estrutura base das informacoes complementares de ST por item de�
//� documento fiscal.                                             |
//�����������������������������������������������������������������
WSSTRUCT STRIT_INFCOMPL_ST
	WSDATA NFID									AS STRING
	WSDATA NUMITE								AS INTEGER
	WSDATA BCORIDEST							AS FLOAT	OPTIONAL
	WSDATA VLRREPDED							AS FLOAT	OPTIONAL
	WSDATA VLRCOMPL								AS FLOAT	OPTIONAL
	WSDATA BCRET								AS FLOAT	OPTIONAL
	WSDATA VLRRET			   					AS FLOAT	OPTIONAL
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPEDIT_INFCOMPL_IT
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_IT						AS ARRAY OF STRIT_INFCOMPL_IT
ENDWSSTRUCT

WSSTRUCT SPEDIT_INFCOMPL_ARMCOMB
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_ARMCOMB					AS ARRAY OF STRIT_INFCOMPL_ARMCOMB
ENDWSSTRUCT

WSSTRUCT SPEDIT_INFCOMPL_MEDIC
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_MEDIC					AS ARRAY OF STRIT_INFCOMPL_MEDIC
ENDWSSTRUCT

WSSTRUCT SPEDIT_INFCOMPL_ARMAS
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_ARMAS					AS ARRAY OF STRIT_INFCOMPL_ARMAS
ENDWSSTRUCT

WSSTRUCT SPEDIT_INFCOMPL_VEICULOS
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_VEICULOS					AS ARRAY OF STRIT_INFCOMPL_VEICULOS
ENDWSSTRUCT

WSSTRUCT SPEDIT_INFCOMPL_RESSARC
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_RESSARC					AS ARRAY OF STRIT_INFCOMPL_RESSARC
ENDWSSTRUCT

WSSTRUCT SPEDIT_INFCOMPL_SELO
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_SELO						AS ARRAY OF STRIT_INFCOMPL_SELO
ENDWSSTRUCT

WSSTRUCT SPEDIT_INFCOMPL_IPI
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_IPI						AS ARRAY OF STRIT_INFCOMPL_IPI
ENDWSSTRUCT

WSSTRUCT SPEDIT_INFCOMPL_ST
	WSDATA ID_ENT								AS STRING
	WSDATA IT_INFCOMPL_ST						AS ARRAY OF STRIT_INFCOMPL_ST
ENDWSSTRUCT


// -------------------------------------- ESTRUTURAS DOS RESUMOS DE MOVIMENTO DIARIO -------------------------------------- //


//������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos documentos informados no �
//� Resumo de Movimento Diario.                                �
//��������������������������������������������������������������
WSSTRUCT STRIT_RMD
	WSDATA NUMITE								AS INTEGER	//UTILIZADO PARA RELACIONAR COM O SERVICO DE TRIBUTO
	WSDATA MODELO								AS STRING	//MODELO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.1 DO LAYOUT COTEPE 11/2007
	WSDATA SITUACAO								AS INTEGER	//SITUACAO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.2 DO LAYOUT COTEPE 11/2007
	WSDATA SERIE								AS STRING
	WSDATA SUBSERIE								AS STRING	OPTIONAL
	WSDATA NUMERO								AS STRING
	WSDATA DTEMIS								AS DATE
	WSDATA CFOP									AS STRING
	WSDATA VLRTOTAL								AS FLOAT
	WSDATA VLRDESC								AS FLOAT	OPTIONAL
	WSDATA VLRPRESERV							AS FLOAT	OPTIONAL
ENDWSSTRUCT

//�������������������������������������������������������������Ŀ
//�Estrutura base das informacoes do Resumo de Movimento Diario.�
//���������������������������������������������������������������
WSSTRUCT STR_RMD
	WSDATA NFID									AS STRING
	WSDATA ID_PART								AS STRING
	WSDATA MODELO								AS STRING	//MODELO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.1 DO LAYOUT COTEPE 11/2007
	WSDATA SITUACAO								AS INTEGER	//SITUACAO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.2 DO LAYOUT COTEPE 11/2007
	WSDATA SERIE								AS STRING
	WSDATA SUBSERIE								AS STRING  	OPTIONAL
	WSDATA NUMERO								AS STRING
	WSDATA DTEMIS								AS DATE
	WSDATA VLRTOTAL								AS FLOAT
	WSDATA VLRDESC								AS FLOAT	OPTIONAL
	WSDATA VLRPRESERV							AS FLOAT	OPTIONAL
	WSDATA CTACONTABIL							AS STRING	OPTIONAL
	WSDATA CODMUNORI							AS STRING	OPTIONAL
	WSDATA ITEM									AS ARRAY OF STRIT_RMD
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_RMD
	WSDATA ID_ENT								AS STRING
	WSDATA RMD									AS ARRAY OF STR_RMD
ENDWSSTRUCT


// -------------------------------------- EQUIPAMENTO ECF -------------------------------------- //


//��������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de Reducao Z que complementa  a�
//� estrutura abaixo (ECF).                                      �
//����������������������������������������������������������������
WSSTRUCT STR_REDZ
	WSDATA DTRED								AS DATE
	WSDATA CRO									AS INTEGER
	WSDATA CRZ									AS INTEGER
	WSDATA COOFIM								AS INTEGER
	WSDATA GTFIM								AS FLOAT
	WSDATA VLRBRUT								AS FLOAT
ENDWSSTRUCT

//��������������������������������������������������������������������Ŀ
//�Estrutura base para informar o cadastro dos ECFs do estabelecimentos�
//� e seus respectivo contadores.                                      �
//����������������������������������������������������������������������
//OBS: Este servico monta os registros: (C400, C405) de cupom fiscal, e (D350, D355) de bilhetes
WSSTRUCT STR_ECF
	WSDATA MODELO								AS STRING		//MODELO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.1 DO LAYOUT COTEPE 11/2007
	WSDATA MODECF								AS STRING
	WSDATA SERFAB								AS STRING
	WSDATA CAIXA								AS INTEGER
	WSDATA REDZ									AS ARRAY OF STR_REDZ
ENDWSSTRUCT

//������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes de itens dos totalizadores parciais�
//� de reducao Z (abaixo).                                           �
//��������������������������������������������������������������������
WSSTRUCT STRIT_ECF1
	WSDATA NUMSEQ								AS INTEGER	//UTILIZADO PARA RELACIONAR COM O SERVICO DE FIS_TRIBUTOS (NFID/NUMITE)
	WSDATA CODITE								AS STRING
	WSDATA QTD									AS FLOAT
	WSDATA UM									AS STRING
	WSDATA VLR									AS FLOAT
	WSDATA QTDCANC								AS FLOAT
	WSDATA VLRDESC								AS FLOAT	
	WSDATA VLRCANC								AS FLOAT
	WSDATA VLRACR								AS FLOAT
	WSDATA MUNORI								AS STRING	//UTILIZADO SOMENTE PARA BILHETES
ENDWSSTRUCT

//���������������������������������������������������������������������Ŀ
//�Estrutura base das informacoes parciais de totalizadores de reducao Z�
//� do movimento diario.                                                �
//�����������������������������������������������������������������������
//OBS: Este servico monta os registros: (C410, C420, C425) de cupom fiscal, e (D365, D370) de bilhetes
WSSTRUCT STR_TOTREDZ
	WSDATA CXID									AS STRING	//UTILIZADO PARA RELACIONAR COM O SERVICO DE FIS_TRIBUTOS (NFID)
	WSDATA CAIXA								AS INTEGER
	WSDATA DTRED								AS DATE		//UTILIZADO PARA RELACIONAR COM A RESPECTIVA REDUCAO Z (STR_REDZ)
	WSDATA CODTOT								AS STRING
	WSDATA VLRACTOT								AS FLOAT
	WSDATA SEQ									AS INTEGER
	WSDATA DESC									AS STRING
	WSDATA IT_ECF								AS ARRAY OF STRIT_ECF1
ENDWSSTRUCT

//����������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos itens dos documentos emitidos�
//� por ECF (abaixo)                                               �
//������������������������������������������������������������������
WSSTRUCT STRIT_ECF2
	WSDATA NUMSEQ								AS INTEGER	//UTILIZADO PARA RELACIONAR COM O SERVICO DE TRIBUTO
	WSDATA CODITE								AS STRING
	WSDATA QTD									AS FLOAT	
	WSDATA QTDCANC								AS FLOAT
	WSDATA UM									AS STRING
	WSDATA VLR									AS FLOAT
	WSDATA CFOP									AS STRING
	WSDATA VLRCANC								AS FLOAT
	WSDATA VLRDESC								AS FLOAT
	WSDATA VLRACR								AS FLOAT
	WSDATA CODOBS								AS STRING
ENDWSSTRUCT

//���������������������������������������������������������������Ŀ
//�Estrutura base das informacoes dos documentos emitidos por ECF.�
//�����������������������������������������������������������������
//OBS: Este servico monta os registros: (C460, C470, C490, C495) de cupom fiscal, e (D390) de bilhetes
WSSTRUCT STR_DOCECF
	WSDATA NFID									AS STRING
	WSDATA CAIXA								AS INTEGER
	WSDATA MODELO								AS STRING	//MODELO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.1 DO LAYOUT COTEPE 11/2007
	WSDATA SERIE								AS STRING
	WSDATA SUBSERIE								AS STRING
	WSDATA SITUACAO								AS INTEGER	//SITUACAO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.2 DO LAYOUT COTEPE 11/2007
	WSDATA NUMERO								AS STRING
	WSDATA DTEMIS								AS DATE
	WSDATA IT_ECF								AS ARRAY OF STRIT_ECF2
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_ECF
	WSDATA ID_ENT								AS STRING
	WSDATA ECF									AS ARRAY OF STR_ECF
ENDWSSTRUCT

WSSTRUCT SPED_TOTREDZ
	WSDATA ID_ENT								AS STRING
	WSDATA TOTREDZ								AS ARRAY OF STR_TOTREDZ
ENDWSSTRUCT

WSSTRUCT SPED_DOCECF
	WSDATA ID_ENT								AS STRING
	WSDATA DOCECF								AS ARRAY OF STR_DOCECF
ENDWSSTRUCT


// -------------------------------------- DADOS ANALITICOS DE BILHETES DE PASSAGEM -------------------------------------- //
     

WSSTRUCT STR_BILPASS
	WSDATA NFID									AS STRING
	WSDATA MODELO								AS STRING	//MODELO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.1 DO LAYOUT COTEPE 11/2007
	WSDATA SITUACAO								AS INTEGER	//SITUACAO DO DOCUMENTO FISCAL CONFORME TABELA 4.1.2 DO LAYOUT COTEPE 11/2007
	WSDATA SERIE								AS STRING
	WSDATA SUBSERIE								AS STRING  	OPTIONAL
	WSDATA NUMERO								AS STRING
	WSDATA CFOP									AS STRING
	WSDATA DTEMIS								AS DATE
	WSDATA VLRTOTAL								AS FLOAT
	WSDATA VLRDESC								AS FLOAT	OPTIONAL
	WSDATA VLRPRSERV							AS FLOAT	OPTIONAL
	WSDATA VLRSEG								AS FLOAT	OPTIONAL
	WSDATA VLRDESP								AS FLOAT	OPTIONAL
	WSDATA CODOBS								AS STRING
	WSDATA CTACONTABIL							AS STRING	OPTIONAL
	WSDATA CODMUNORI							AS STRING
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_BILPASS
	WSDATA ID_ENT								AS STRING
	WSDATA BILPASS								AS ARRAY OF STR_BILPASS
ENDWSSTRUCT

// -------------------------------------- INVENARIO -------------------------------------- //

//���������������������������������������Ŀ
//�Informacoes dos produtos de inventario.�
//�- Abrange o registro H010              �
//�����������������������������������������
WSSTRUCT STR_ITINV
	WSDATA CODITE								AS STRING
	WSDATA UM									AS STRING
	WSDATA QTD									AS FLOAT
	WSDATA VLUNIT								AS FLOAT
	WSDATA VLTOT								AS FLOAT
	WSDATA INDPROP								AS STRING	//0-Item de propriedade do informante e em seu poder, 1-Item de propriedade do informante em posse de terceiros e 2-Item de propriedade de terceiros em posse do informante
	WSDATA ID_PART								AS STRING
	WSDATA CODOBS								AS STRING
	WSDATA CTACONTABIL							AS STRING
ENDWSSTRUCT

//�������������������������Ŀ
//�Informacoes de inventario�
//�- Abrange o registro H005�
//���������������������������
WSSTRUCT STR_INV
	WSDATA DT									AS DATE
	WSDATA VLR									AS FLOAT
	WSDATA ITINV								AS ARRAY OF STR_ITINV
ENDWSSTRUCT

//����������������������������������Ŀ
//�Definicao dos arrays de estruturas�
//������������������������������������
WSSTRUCT SPED_INV
	WSDATA ID_ENT								AS STRING
	WSDATA INV									AS ARRAY OF STR_INV
ENDWSSTRUCT

WSSERVICE SPEDFISCALMOVIMENTOS ;
	DESCRIPTION "<b>Servi�o gen�rico de administra��o do Sped Fiscal.</b><br><br>Este servi�o permite a administra��o das tabelas de cadastro do projeto Sped Fiscal."  ;
	NAMESPACE "http://webservices.totvs.com.br/spedfiscalmovimentos.apw"
	
	//VARIAVEIS GERAIS
	WSDATA USERTOKEN       				     	AS STRING
	WSDATA ID_ENT         				     	AS STRING
	WSDATA RETORNO								AS STRING
	
	//CABECALHOS
	WSDATA DOCFIS								AS SPED_DOCFIS
	WSDATA OBS_LANCFIS							AS SPED_OBS_LANCFIS
	WSDATA COMPL_EE								AS SPED_COMPL_EE
	WSDATA COMPL_COMTEL							AS SPED_COMPL_COMTEL
	WSDATA COMPL_GAS_AGUA						AS SPED_COMPL_GAS_AGUA
	WSDATA COMPL_IMPORT							AS SPED_COMPL_IMPORT
	WSDATA COMPL_VOLTRANSP						AS SPED_COMPL_VOLTRANSP
	WSDATA COMPL_CARGATRANSP					AS SPED_COMPL_CARGATRANSP
	WSDATA COMPL_NFST							AS SPED_COMPL_NFST
	WSDATA COMPL_CTRC							AS SPED_COMPL_CTRC
	WSDATA COMPL_CTAQC							AS SPED_COMPL_CTAQC
	WSDATA COMPL_CTAEC							AS SPED_COMPL_CTAEC
	WSDATA COMPL_CTMC							AS SPED_COMPL_CTMC
	WSDATA MODAIS								AS SPED_MODAIS
	WSDATA TITULO								AS SPED_TITULO
	WSDATA TRIBUTOS								AS SPED_TRIBUTOS
	WSDATA INFCOMPL_PROCREF						AS SPED_INFCOMPL_PROCREF
	WSDATA INFCOMPL_DA							AS SPED_INFCOMPL_DA
	WSDATA INFCOMPL_DFREF						AS SPED_INFCOMPL_DFREF
	WSDATA INFCOMPL_CFREF						AS SPED_INFCOMPL_CFREF
	WSDATA INFCOMPL_LOC_COLENT					AS SPED_INFCOMPL_LOC_COLENT
	
	//ITENS
	WSDATA IT_INFCOMPL_IT						AS SPEDIT_INFCOMPL_IT
	WSDATA IT_INFCOMPL_ARMCOMB					AS SPEDIT_INFCOMPL_ARMCOMB
	WSDATA IT_INFCOMPL_MEDIC					AS SPEDIT_INFCOMPL_MEDIC
	WSDATA IT_INFCOMPL_ARMAS					AS SPEDIT_INFCOMPL_ARMAS
	WSDATA IT_INFCOMPL_VEICULOS					AS SPEDIT_INFCOMPL_VEICULOS
	WSDATA IT_INFCOMPL_RESSARC					AS SPEDIT_INFCOMPL_RESSARC
	WSDATA IT_INFCOMPL_SELO						AS SPEDIT_INFCOMPL_SELO
	WSDATA IT_INFCOMPL_IPI						AS SPEDIT_INFCOMPL_IPI
	WSDATA IT_INFCOMPL_ST						AS SPEDIT_INFCOMPL_ST
	
	//RESUMO DE MOVIMENTO DIARIO
	WSDATA RMD									AS SPED_RMD
	
	//ECF
	WSDATA ECF									AS SPED_ECF
	WSDATA TOTREDZ								AS SPED_TOTREDZ
	WSDATA DOCECF								AS SPED_DOCECF
	
	//BILHETES DE PASSAGEM
	WSDATA BILPASS								AS SPED_BILPASS
	
	//INVENTARIO
	WSDATA INV									AS SPED_INV

	//CABECALHO
	WSMETHOD FISDFCAD_DOCFIS					DESCRIPTION	"<b>Servi�o de administra��o dos documentos fiscais do Sped Fiscal.</b><br><br>Este servi�o tem como objetivo cadastrar os documentos fiscais movimentados no per�odo; estes documentos formam uma base de dados para gera��o do Sped Fiscal nos moldes do Ato Cotepe 11/2007.<br><br>Ocorr�ncia:<br>Pode haver v�rios documentos fiscais por servi�o, cuja chave � representada pelo 'NFID' da estrutura deste servi�o. Seu n�vel imediatamente inferior deve representar o(s) item(s) de cada documento fiscal obrigat�riamente, podendo haver v�rios.<br><br>Observa��o:<br>Este m�todo dever� ser utilizado para todos os mod�los de documento fiscais tratados pelo Ato Cotepe 11/07, caso haja necessidade de enviar outras informa��es n�o comportadas neste m�todo, deve-se utilizar outros m�todos de complemento dispon�veis ainda nesta p�gina e efetuar a amarra��o correta pelo 'NFID' de cada documento fiscal."
	WSMETHOD FISDFOBS_LANCFIS					DESCRIPTION	"<b>Servi�o de administra��o das observa��es de lan�amentos fiscais dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas observa��es dos lan�amentos fiscais para cada documento cadastrado na base de dados para gera��o do Sped Fiscal. Esta observa��o est� relacionada aos ajustes dos documentos fiscais ou itens de documentos, os quais podem ou n�o ser informados, ou seja, pode-se informar somente a observa��o do lan�amento fiscal sem ter necess�riamente outras obriga��es de ajustes referenciado.<br><br>Observa��o:<br>(1) quando uma determinada observa��o de lan�amento fiscal for relacionado a um item, dever� ter o campo 'CODITEM' da estrutura deste servi�o preenchido e referenciando o respectivo item do documento fiscal.<br><br>Ocorr�ncia:<br>Pode haver v�rias observa��es de lan�amento fiscal para um mesmo documento fiscal, cuja chave � representada pelo 'NFID + CODOBS' da estrutura deste servi�o. Tamb�m pode haver v�rias obriga��es de ajustes para uma mesma observa��o de lan�amento fiscal que � representado atrav�s de um n�vel imediatamente inferior a este complemento."
	WSMETHOD FISDFCOMPL_EE						DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas do documento fiscal/conta de energia el�trica (modelo 06), obrigadas ou n�o ao Conv�nio 115 (DOU 17/12/2003).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por documento fiscal, cuja chave � representada pelo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDFCOMPL_COMTEL					DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas do documento fiscal de comunica��o/telecomunica��o (modelos 21 e 22), incluindo tamb�m informa��es do terminal faturado.<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por documento fiscal, cuja chave � representada pelo 'NFID' da estrutura deste servi�o, por�m pode haver v�rios terminais faturados atrelados a este complemento atrav�s de um n�vel imediatamente inferior a este complemento."
	WSMETHOD FISDFCOMPL_GAS_AGUA				DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas do documento fiscal/conta fornecimento D'�gua/G�s (modelos 29 e 28), obrigadas ou n�o ao Conv�nio 115 (DOU 17/12/2003).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por documento fiscal, cuja chave � representada pelo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDFCOMPL_IMPORT					DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas do documento fiscal de opera��es de importa��o (modelo 01).<br><br>Ocorr�ncia:<br>Pode haver v�rios documentos de importa��o por documento fiscal (modelo 01), cuja chave � representada pelo 'NFID' da estrutura deste servi�o. Quanto se tratar de v�rios documentos de importa��o a chave 'NFID' pode ser repedida, referenciando um mesmo documento fiscal original."
	WSMETHOD FISDFCOMPL_VOLTRANSP				DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas dos volumes transportados no caso do transporte ser efetuado pelo pr�prio estabelecimento, sendo opera��es de combust�vel (modelos 01 e 55) ou n�o (modelos 01 e 04).<br><br>Ocorr�ncia:<br>(1) Quando se tratar de documentos fiscais modelos 01 e 04 (que n�o sejam opera��es com combust�veis), deve-se informar um complemento por documento fiscal, e sua chave � representada pelo 'NFID' da estrutura deste servi�o;<br>(2) Quando se tratar de documentos fiscais modelos 01 e 55 (caso seja opera��es com combust�veis), pode haver v�rios complementos por documento fiscal, e sua chave � representada pelo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDFCOMPL_CARGATRANSP				DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas da carga transportada nos casos de Conhecimento Rodovi�rio de Cargas (modelo 08), Conhecimento de Transporte de Cargas avulso (modelo 8B), Conhecimento Aquavi�rio de Cargas (modelo 09), Conhecimento A�reo de Cargas (modelo 10), Conhecimento Ferrovi�rio de Cargas (modelo 11) e Conhecimento Multimodal de Cargas (modelo 26). Tamb�m � permitido atrav�s deste servi�o efetuar manuten��es nos locais de coleta/entrega, pois trata-se de um complemento da carga transportada a um nivel imediatamente inferior.<br><br>Ocorr�ncia:<br>Pode haver v�rios documentos fiscais de cargas transportadas relacionados a um �nico documento de transporte (modelos 08, 8B, 09, 10, 11 e 26), por�m somente haver� um local de coleta/entrega (n�vel imediatamente inferior) para cada carga transportada. A chave de relacionamento de v�rias cargas transportadas a um mesmo documento fiscal de transporte � representada pelo campo 'NFID' que deve se repetir."
	WSMETHOD FISDFCOMPL_NFST					DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas da Nota Fiscal de Servi�o de Transporte (modelo 07).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por documento fiscal, cuja chave � representada pelo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDFCOMPL_CTRC					DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas do Conhecimento Rodovi�rio de Cargas (modelo 08).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por documento fiscal, cuja chave � representada pelo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDFCOMPL_CTAQC					DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas do Conhecimento Aquavi�rio de Cargas (modelo 09).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por documento fiscal, cuja chave � representada pelo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDFCOMPL_CTAEC					DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares espec�ficas do Conhecimento A�reo de Cargas (modelo 10).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por documento fiscal, cuja chave � representada pelo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDFCOMPL_CTMC					DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es espec�ficas do Conhecimento Multimodal de Cargas (modelo 26).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por documento fiscal, cuja chave � representada pelo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDF_MODAIS						DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nos Modais relacionados ao Conhecimento Multimodal de Cargas (modelo 26).<br><br>Ocorr�ncia:<br>Pode haver v�rios modais por documento fiscal, que � representado pelo mesmo 'NFID' da estrutura deste servi�o."
	WSMETHOD FISDF_TITULO						DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas faturas dos documentos fiscais (modelos 01, 1B, 04 e 55) e suas respectivas parcelas/vencimentos.<br><br>Observa��o:<br>(1) para que um documento fiscal seja considerado sem fatura/pagamento basta n�o utilizar este servi�o para um determinado documento fiscal.<br><br>Ocorr�ncia:<br>Pode haver somente um t�tulo por documento fiscal, que � representado pelo mesmo 'NFID' da estrutura deste servi�o; o que pode variar � o n�mero de parcelas deste t�tulo, n�vel imediatamente inferior."
	WSMETHOD FIS_TRIBUTOS						DESCRIPTION	"<b>Servi�o de administra��o dos complementos dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nos tributos dos documentos fiscais. Os tributos s�o referenciados atrav�s dos c�digos:<br><br>- 01=ICMS;<br>- 02=ICMS/ST;<br>- 03=IPI;<br>- 04=ISS;<br>- 05=PIS;<br>- 06=PIS/ST;<br>- 07=COFINS;<br>- 08=COFINS/ST;<br>- 09=IR;<br>- 10=PREVID�NCIA.<br><br>Observa��o: <br>(1) estes c�digos devem ser respeitados e informados no campo 'TPTRIB' da estrutura deste servi�o conforme nescessidade;<br>(2) todos os campos desta estrutura s�o opcionais, pois pode haver casos que somente o valor do imposto deve ser informado (FCP) ou somente a Base e Valor deve ser informado ou todos os campos (CST, TP_TRIB, BASE, ALIQ, VLR) terem a mesma nescessidade;<br>(3) este servi�o � utilizado para complementar as informa��es do documento fiscal de forma anal�tica (cabe�alho) e/ou de forma sint�tica (itens), e o campo da estrutura deste servi�o que controla este tratamento � o 'NUMITE', que deve ser preenchido quando significar que um determinado item dever� ter o respectivo complemento, caso contr�rio, se o mesmo estiver em branco estaremos indicando que o documento fiscal dever� ter o tal complemento;<br>(4) como � permitido v�rios complementos de tributos por documento fiscal ou item de documento fiscal, vale lembrar que as chaves dever�o ser repetidas, referenciando um mesmo documento fiscal ('NFID') ou item ('NFID + NUMITE').<br><br>Ocorr�ncia:<br>Pode haver v�rios tributos para um mesmo documento fiscal, que � representado pelo mesmo 'NFID' da estrutura deste servi�o. No caso dos tributos referenciar itens do documento fiscal, a chave ser� representada pelos campos 'NFID + NUMITE' conforme estrutura deste servi�o."	//;<br>- 11=FCP (Fundo de Combate a Pobreza)
	WSMETHOD FISDFINFCOMPL_PROCREF				DESCRIPTION	"<b>Servi�o de administra��o das informa��es complementares dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares dos documentos fiscais, mais especificamente quando se tratar de processo referenciado ao documento fiscal.<br><br>Ocorr�ncia:<br>Pode haver v�rias informa��es complementares relacionadas ao documento fiscal atrav�s da chave informada no campo 'NFID' da estrutura deste servi�o; pode-se tamb�m, haver v�rios processos referenciados relacionados a informa��o complementar atrav�s de seu n�vel imediatamente inferior."
	WSMETHOD FISDFINFCOMPL_DA					DESCRIPTION	"<b>Servi�o de administra��o das informa��es complementares dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares dos documentos fiscais, mais especificamente quando se tratar de documento de arrecada��o referenciado ao documento fiscal.<br><br>Ocorr�ncia:<br>Pode haver v�rias informa��es complementares relacionadas ao documento fiscal atrav�s da chave informada no campo 'NFID' da estrutura deste servi�o; pode-se tamb�m, haver v�rios documentos de arrecada��o referenciados relacionados a informa��o complementar atrav�s de seu n�vel imediatamente inferior."
	WSMETHOD FISDFINFCOMPL_DFREF				DESCRIPTION	"<b>Servi�o de administra��o das informa��es complementares dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares dos documentos fiscais, mais especificamente quando se tratar de documento fiscal referenciado ao documento fiscal original.<br><br>Ocorr�ncia:<br>Pode haver v�rias informa��es complementares relacionadas ao documento fiscal original atrav�s da chave informada no campo 'NFID' da estrutura deste servi�o; pode-se tamb�m, haver v�rios documentos fiscais referenciados relacionados a informa��o complementar atrav�s de seu n�vel imediatamente inferior."
	WSMETHOD FISDFINFCOMPL_CFREF				DESCRIPTION	"<b>Servi�o de administra��o das informa��es complementares dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares dos documentos fiscais, mais especificamente quando se tratar de cupom fiscal referenciado ao documento fiscal.<br><br>Ocorr�ncia:<br>Pode haver v�rias informa��es complementares relacionadas ao documento fiscal atrav�s da chave informada no campo 'NFID' da estrutura deste servi�o; pode-se tamb�m, haver v�rios cupons fiscais referenciados relacionados a informa��o complementar atrav�s de seu n�vel imediatamente inferior."
	WSMETHOD FISDFINFCOMPL_LOC_COLENT			DESCRIPTION	"<b>Servi�o de administra��o das informa��es complementares dos documentos fiscais para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares dos documentos fiscais, mais especificamente quando se tratar do local da coleta/entrega informado no documento fiscal.<br><br>Ocorr�ncia:<br>Pode haver v�rias informa��es complementares relacionadas ao documento fiscal atrav�s da chave informada no campo 'NFID' da estrutura deste servi�o; pode-se tamb�m, haver v�rios locais de coletas/entregas relacionados a informa��o complementar atrav�s de seu n�vel imediatamente inferior."

	//ITEM
	WSMETHOD FISITINFCOMPL_IT					DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal/conta de Energia El�trica (06), Comunica��o (21), Telecomunica��o (22), �gua (29) e G�s (28) canalizado.<br><br>Observa��o:<br>(1) quando o modelo do documento fiscal for 21 ou 22, o campo 'TPREC' dever� conter: 0=Receita pr�pria, 1=Receita de terceiros;<br>(2) quando o modelo do documento fiscal for 06 ou 28, o campo 'TP_REC' dever� conter: 0=Receita pr�pria - Servi�os prestados, 1=Receita pr�pria - Cobran�a de d�bitos, 2=Receita pr�pria - Venda de mercadorias, 3=Receita pr�pria - Venda de servi�o pr�-pago, 4=Outras receitas pr�prias, 5=Receita de terceiros(co-faturamento), 9=Outras receitas de terceiros.<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por item de documento fiscal, cuja chave � representada pelo mesmo 'NFID + NUMITE' da estrutura deste servi�o."
	WSMETHOD FISITINFCOMPL_ARMCOMB				DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal (modelos 01 e 55). Este complemento deve ser utilizado para todos os itens que identifiquem opera��es com combust�veis, onde sua finalidade � identificar as informa��es de armazenagem.<br><br>Ocorr�ncia:<br>Pode haver v�rios complementos para um determinado item do documento fiscal, para se relaciona-los � necess�rio informar a chave 'NFID + NUMITE' na estrutura deste servi�o."
	WSMETHOD FISITINFCOMPL_MEDIC				DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal (modelos 01 e 55). Este complemento deve ser utilizado para todos os itens que identifiquem opera��es com medicamentos.<br><br>Observa��o:<br>(1) o conte�do do campo 'TP_BC_ICMSST' deve indicar o tipo de refer�ncia da base de c�lculo do ICMS/ST do produto farmac�utico, podendo ser: 0- Base de c�lculo referente ao pre�o tabelado ou pre�o m�ximo sugerido; 1=Base c�lculo � Margem de valor agregado; 2=Base de c�lculo referente � Lista Negativa; 3=Base de c�lculo referente � Lista Positiva; 4=Base de c�lculo referente � Lista Neutra.<br>(2) o conte�do do campo 'TP_MEDIC' deve indicar o tipo de produto que est� sendo comercializado, podendo ser: 0=Similar; 1=Gen�rico; 2=�tico ou de marca.<br><br>Ocorr�ncia:<br>Pode haver v�rios complementos para um determinado item do documento fiscal, para se relaciona-los � necess�rio informar a chave 'NFID + NUMITE' na estrutura deste servi�o."
	WSMETHOD FISITINFCOMPL_ARMAS				DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal (modelo 01). Este complemento deve ser utilizado para todos os itens que identifiquem opera��es com armas de fogo.<br><br>Observa��o:<br>(1) o conte�do do campo 'TPARMA' deve indicar o tipo de arma de fogo que est� sendo comercializada, podendo ser: 0=Uso permitido;1=Uso restrito.<br><br>Ocorr�ncia:<br>Pode haver v�rios complementos para um determinado item do documento fiscal, para se relaciona-los � necess�rio informar a chave 'NFID + NUMITE' na estrutura deste servi�o."
	WSMETHOD FISITINFCOMPL_VEICULOS				DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal (modelos 01 e 55). Este complemento deve ser utilizado para todos os itens que identifiquem opera��es com ve�culos novos.<br><br>Observa��o:<br>(1) o conte�do do campo 'TPOPER' deve indicar o tipo de opera��o com ve�culo, podendo ser: 0=Venda para concession�ria; 1=Faturamento direto; 2=Venda direta; 3=Venda da concession�ria; 9=Outros.<br><br>Ocorr�ncia:<br>Pode haver v�rios complementos para um determinado item do documento fiscal, para se relaciona-los � necess�rio informar a chave 'NFID + NUMITE' na estrutura deste servi�o."
	WSMETHOD FISITINFCOMPL_RESSARC				DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal (modelos 01 e 55). Este complemento deve ser utilizado para todos os itens que identifiquem ressarcimento de ICMS em opera��es de Substitui��o Tribut�ria(ST).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por item de documento fiscal, cuja chave � representada pelo mesmo 'NFID + NUMITE' da estrutura deste servi�o."
	WSMETHOD FISITINFCOMPL_SELO					DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal (modelos 01, 1B, 04 e 55). Este complemento deve ser utilizado para todos os itens que identifiquem opera��es com produtos sujeitos ao selo de controle.<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por item de documento fiscal, cuja chave � representada pelo mesmo 'NFID + NUMITE' da estrutura deste servi�o."
	WSMETHOD FISITINFCOMPL_IPI					DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal (modelos 01, 1B, 04 e 55). Este complemento deve ser utilizado para todos os itens que identifiquem opera��es com produtos sujeitos a tributa��o do IPI por unidade ou quantidade de produto.<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por item de documento fiscal, cuja chave � representada pelo mesmo 'NFID + NUMITE' da estrutura deste servi�o."
	WSMETHOD FISITINFCOMPL_ST					DESCRIPTION "<b>Servi�o de administra��o dos complementos de item(s) do documento fiscal para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es complementares do(s) item(s) do documento fiscal (modelo 01). Este complemento deve ser utilizado para todos os itens que identifiquem opera��es com informa��es complementares de Substitui��o Tribut�ria(ST).<br><br>Ocorr�ncia:<br>Pode haver somente um complemento por item de documento fiscal, cuja chave � representada pelo mesmo 'NFID + NUMITE' da estrutura deste servi�o."
	
	//RESUMO DE MOVIMENTO DIARIO
	WSMETHOD FIS_RMD							DESCRIPTION "<b>Servi�o de administra��o do Resumo de Movimento Di�rio (modelo 18) do Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o no resumo de movimento di�rio e seus documentos informados (bilhetes de passagem rodovi�rio (modelo 13), de passagem aquavi�rio (modelo 14), de passagem e nota de bagagem (modelo 15) e de passagem ferrovi�rio (modelo 16)).<br><br>Observa��o:<br>Atrav�s da estrutura definida para este servi�o, os documentos informados no resumo de movimento di�rio s�o declarados atrav�s do nivel imediatamente inferior (item), onde a um n�mero sequencial (podendo seguir a l�gica de numera��o de item) 'NUMITE' que torna poss�vel o relacionamento com o servi�o FIS_TRIBUTOS seguindo as regras impostas pelo mesmo ('NFID' ou 'NFID + NUMITE').<br><br>Ocorr�ncia:<br>Pode haver v�rios resumos de movimento di�rio neste servi�o, cuja chave � representada pelo 'NFID' da estrutura. Seu n�vel imediatamente inferior deve representar o(s) item(s)(documentos informados) do resumo do movimento di�io obrigat�riamente, podendo haver v�rios respeitando a chave 'NFID + NUMITE' da estrutura deste servi�o."
	
	//ECF
	WSMETHOD FISECF_ECF							DESCRIPTION "<b>Servi�o de administra��o dos Emissores de Cupom Fiscal (ECF) e seus contadores para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es cadastrais do ECF e seus contadores. Deve ser utilizado quando o estabelecimento praticar emiss�o de cupom fiscal registrando opera��es de emiss�o de Bilhetes de passagens (rodovi�rio(13), aqu�vi�rio(14), bagagem(15) ou ferrovi�rio(16)) ou outros cupons fiscais destinados ao consumidor final nos modelos 02, 2D ou 2E.<br><br>Observa��o:<br>(1) Atrav�s da estrutura definida para este servi�o podemos informar os dados cadastrais do equipamento ECF, no seu n�vel imediatamente inferior, devemos informar os contadores de redu��o Z deste equipamento.<br>(2) Importante ressaltar que quando se tratar deste servi�o, todos os relacionamentos s�o implementados atrav�s do campo 'CAIXA' dispon�vel na estrutura deste servi�o.<br><br>Ocorr�ncia:<br>Pode haver v�rios equipamentos ECF por movimento, cada qual, com seus respectivos contadores de redu��o Z (geralmente, um por dia), conforme informado neste servi�o atrav�s do n�vel imediatamente inferior."
	WSMETHOD FISECF_TOTREDZ						DESCRIPTION "<b>Servi�o de administra��o dos totalizadores parciais da redu��o Z para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es de totaliza��o parcial da redu��o Z e seus itens comercializados no per�odo. Deve ser utilizado quando o estabelecimento praticar emiss�o de cupom fiscal registrando opera��es de emiss�o de Bilhetes de passagens (rodovi�rio(13), aqu�vi�rio(14), bagagem(15) ou ferrovi�rio(16)) ou outros cupons fiscais destinados ao consumidor final nos modelos 02, 2D ou 2E.<br><br>Observa��o:<br>Atrav�s da estrutura definida para este servi�o podemos informar os valores parciais da redu��o Z por c�digo de totaliza��o (conforme tabela 4.4.6 do Ato Cotepe 11/2007), e no seu n�vel imediatamente inferior, devemos informar os itens comercializados no per�odo.<br><br>Ocorr�ncia:<br>Pode haver v�rios c�digos de totaliza��o no per�odo para cada equipamento ECF, cada qual, com seus respectivos itens comercializados. Para relacionarmos a movimenta��o enviada neste servi�o com o ECF, devemos informar o 'CAIXA' a que se refere este movimento, dispon�vel na estrutura deste servi�o."
	WSMETHOD FISECF_DOCECF						DESCRIPTION "<b>Servi�o de administra��o dos documentos fiscais emitidos por ECF para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es de documentos fiscais emitidos por ECF e seus respectivos itens. Deve ser utilizado quando o estabelecimento praticar emiss�o documentos fiscais atrav�s do equipamento emissor de cupom fiscal, registrando opera��es de emiss�o de Bilhetes de passagens (rodovi�rio(13), aqu�vi�rio(14), bagagem(15) ou ferrovi�rio(16)) ou outros cupons fiscais destinados ao consumidor final nos modelos 02, 2D ou 2E.<br><br>Observa��o:<br>Atrav�s da estrutura definida para este servi�o podemos informar os documentos fiscais emitidos por ECF, e no seu n�vel imediatamente inferior, devemos informar os respectivos itens.<br><br>Ocorr�ncia:<br>Pode haver v�rios documentos fiscais emitidos por um �nico ECF no per�odo, cada qual, com seus respectivos itens. Para relacionarmos a movimenta��o enviada neste servi�o com o ECF, devemos informar o 'CAIXA' a que se refere este movimento, dispon�vel na estrutura deste servi�o."
	
	//BILHETES DE PASSAGEM
	WSMETHOD FIS_BILPASS						DESCRIPTION "<b>Servi�o de administra��o dos bilhetes de passagens e notas de bagagens emitidos por ECF para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es de bilhetes de passagens (rodovi�rio(13), aqu�vi�rio(14), bagagem(15) ou ferrovi�rio(16)) e/ou notas de bagagens que foram emitidas pelo equipamento emissor de cupom fiscal.<br><br>Observa��o:<br>Atrav�s da estrutura definida para este servi�o podemos informar os bilhetes de passagens e/ou notas de bagages que foram emitidos por ECF.<br><br>Ocorr�ncia:<br>Pode haver v�rios bilhetes de passagens e/ou notas de bagagens emitidos por um �nico ECF no per�odo."
	
	//INVENTARIO
	WSMETHOD FIS_INV							DESCRIPTION "<b>Servi�o de administra��o dos itens invent�riados do estabelecimento para o Sped Fiscal.</b><br><br>Este servi�o tem como objetivo dar manuten��o nas informa��es de invent�rio do estabelecimento declarante.<br><br>Observa��o:<br>Atrav�s da estrutura definida para este servi�o podemos informar todos os itens do estoque em determinada data de fechamento.<br><br>Ocorr�ncia:<br>Pode haver itens diferentes por data de fechamento de estoque, cuja chave de ordena��o � o campo 'DT' da estrutura deste servi�o.<br>Seu n�vel imediatamente inferior dever� representar todos os itens inventariados no per�odo respeitando a chave da estrutura do servi�o formada pelo campo 'CODIGO'."
	
ENDWSSERVICE
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCAD_DOCFIS� Autor � Gustavo G. Rueda      � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao de documentos fiscais em geral, ou  ���
���          � seja, de qualquer modelo. Para se caracterizar um modelo especi-���
���          � fico, deve-se utilizar os complementos disponibilizados.        ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �DOCFIS -> Objeto com as informacoes de varios documentos fiscais ���
���          �       e seus itens em seu nivel inferior                        ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCAD_DOCFIS WSRECEIVE USERTOKEN,DOCFIS WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lID_PART	:=	.F.
Local	lMODELO		:=	.F.
Local	lNUMITE		:=	.F.
Local	lCODITE		:=	.F.
Local	lUM			:=	.F.
Local	lITEM		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:DOCFIS:DOCFIS<>Nil .And. Len(Self:DOCFIS:DOCFIS)>0
		If !Empty(Self:DOCFIS:ID_ENT)
		
			For nX := 1 To Len(Self:DOCFIS:DOCFIS)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������
				If Empty(Self:DOCFIS:DOCFIS[nX]:NFID)
					lNFID := .T.
					Loop
				EndIf
				If Empty(Self:DOCFIS:DOCFIS[nX]:ID_PART)
					lID_PART := .T.
					Loop
				EndIf
				If Empty(Self:DOCFIS:DOCFIS[nX]:MODELO)
					lMODELO := .T.
					Loop
				EndIf
				If Self:DOCFIS:DOCFIS[nX]:ITEM==Nil .Or. Len(Self:DOCFIS:DOCFIS[nX]:ITEM)==0
					lITEM := .T.
					Loop
				EndIf
		
				Begin Transaction
			
				//��������������������������������������������������������������Ŀ
				//�                        Documento fiscal                      �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED008")
				cQuery := "DELETE "
				cQuery += "FROM SPED008 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:DOCFIS:ID_ENT,Len(SPED008->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:DOCFIS:DOCFIS[nX]:NFID,Len(SPED008->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//��������������������������������������������������������������Ŀ
				//�                  Itens do documento fiscal                   �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������				
				dbSelectArea("SPED008A")
				cQuery := "DELETE "
				cQuery += "FROM SPED008A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:DOCFIS:ID_ENT,Len(SPED008A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:DOCFIS:DOCFIS[nX]:NFID,Len(SPED008A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED008")
				dbSetOrder(1)
				cChave	:=	PadR(Self:DOCFIS:ID_ENT,Len(SPED008->ID_ENT))
				cChave	+=	PadR(Self:DOCFIS:DOCFIS[nX]:NFID,Len(SPED008->NFID))
				If SPED008->(dbSeek(cChave))
					RecLock("SPED008",.F.)
				Else
					RecLock("SPED008",.T.)
				EndIf
				SPED008->ID_ENT		:=	PadR(Self:DOCFIS:ID_ENT,Len(SPED008->ID_ENT))
				SPED008->CHVNFE		:=	Self:DOCFIS:DOCFIS[nX]:CHVNFE
				SPED008->CODOBS		:=	Self:DOCFIS:DOCFIS[nX]:CODOBS
				SPED008->CTACONT	:=	Self:DOCFIS:DOCFIS[nX]:CTACONTABIL
				SPED008->DTEMIS		:=	Self:DOCFIS:DOCFIS[nX]:DTEMIS
				SPED008->DTES		:=	Self:DOCFIS:DOCFIS[nX]:DTENTSAI
				SPED008->EMIT		:=	Self:DOCFIS:DOCFIS[nX]:EMIT
				SPED008->ID_PART	:=	Self:DOCFIS:DOCFIS[nX]:ID_PART
				SPED008->MODELO		:=	Self:DOCFIS:DOCFIS[nX]:MODELO
				SPED008->NFID		:=	PadR(Self:DOCFIS:DOCFIS[nX]:NFID,Len(SPED008->NFID))
				SPED008->NUMERO		:=	Self:DOCFIS:DOCFIS[nX]:NUMERO
				SPED008->SERIE		:=	Self:DOCFIS:DOCFIS[nX]:SERIE
				SPED008->SITUAC		:=	Self:DOCFIS:DOCFIS[nX]:SITUACAO
				SPED008->SUBSER		:=	Self:DOCFIS:DOCFIS[nX]:SUBSERIE
				SPED008->TPFRT		:=	Self:DOCFIS:DOCFIS[nX]:TPFRT
				SPED008->TPOPER		:=	Self:DOCFIS:DOCFIS[nX]:TPOPER
				SPED008->VLRABAT	:=	Self:DOCFIS:DOCFIS[nX]:VLRABAT
				SPED008->VLRDESC	:=	Self:DOCFIS:DOCFIS[nX]:VLRDESC
				SPED008->VLRDESP	:=	Self:DOCFIS:DOCFIS[nX]:VLRDESP
				SPED008->VLRFRT		:=	Self:DOCFIS:DOCFIS[nX]:VLRFRT
				SPED008->VLRMERC	:=	Self:DOCFIS:DOCFIS[nX]:VLRMERC
				SPED008->VLRSEG		:=	Self:DOCFIS:DOCFIS[nX]:VLRSEG
				SPED008->VLRTOTAL	:=	Self:DOCFIS:DOCFIS[nX]:VLRTOTAL
				MsUnLock()
				FkCommit()
			
				For nI := 1 To Len(Self:DOCFIS:DOCFIS[nX]:ITEM)
				
					//�����������������������������������������������������������������������������Ŀ
					//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
					//�������������������������������������������������������������������������������
					If Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:NUMITE==0
						lNUMITE	:=	.T.
						Loop
					EndIf
					If Empty(Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:CODITE)
						lCODITE	:=	.T.
						Loop
					EndIf
					If Empty(Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:UM)
						lUM	:=	.T.
						Loop
					EndIf
						
					dbSelectArea("SPED008A")
					dbSetOrder(1)
					cChave	:=	SPED008->ID_ENT
					cChave	+=	SPED008->NFID
					cChave	+=	Str(Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:NUMITE,6)
					cChave	+=	PadR(Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:CODITE,Len(SPED008A->CODITE))
					If SPED008A->(dbSeek(cChave))
						RecLock("SPED008A",.F.)
					Else
						RecLock("SPED008A",.T.)
					EndIf
					SPED008A->ID_ENT	:=	SPED008->ID_ENT
					SPED008A->NFID 		:=	SPED008->NFID
					SPED008A->ALCOFVLR	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:ALQCOFVLR
					SPED008A->ALPISVLR	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:ALQPISVLR
					SPED008A->CFOP		:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:CFOP
					SPED008A->CODITE	:=	PadR(Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:CODITE,Len(SPED008A->CODITE))
					SPED008A->CODNAT	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:CODNAT
					SPED008A->CTACONT	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:CTACONTABIL
					SPED008A->DESCRC	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:DESCCOMPL
					SPED008A->ENQIPI	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:ENQIPI
					SPED008A->MOVFIS	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:MOVFIS
					SPED008A->NUMITE	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:NUMITE
					SPED008A->OUTVLR	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:OUTVLR
					SPED008A->QTD		:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:QTD
					SPED008A->QTDBSPIS	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:QTDBSPIS
					SPED008A->QTDBSCOF	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:QTDBSCOF
					SPED008A->TPAPIPI	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:TPAPIPI
					SPED008A->UM		:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:UM
					SPED008A->VLRDESC	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:VLRDESC
					SPED008A->VLRTOTAL	:=	Self:DOCFIS:DOCFIS[nX]:ITEM[nI]:VLRTOTIT
					MsUnLock()
					FkCommit()
	
				Next nI
			
				End Transaction	
				
				lAtualizou	:=	.T.
			Next nX
			
			Self:RETORNO	:=	""
			If lAtualizou			
				Self:RETORNO	+=	"Todos os documentos tiveram suas informa��es cadastradas com sucesso. "
			EndIf
			If lNFID
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com o ID em branco - (NFID). "
			EndIf
			If lID_PART
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com o ID do participante em branco - (ID_PART). "
			EndIf
			If lMODELO
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com o c�digo de mod�lo em branco - (MODELO). "
			EndIf
			If lNUMITE
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com o n�mero do item em branco - (NUMITE). "
			EndIf
			If lCODITE
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com o c�digo do item em branco - (CODITE). "
			EndIf
			If lUM
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com a unidade de medida em branco - (UM). "
			EndIf
			If lItem
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem sem item(s) relacionado(s) - (DOCFIS/ITEM). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFOBS_LANCFIS� Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das observacoes e lancamentos fisca-���
���          � is dos documentos fiscais em geral, ou seja, de qualquer modelo.���
���          �Para se caracterizar um modelo especifico, deve-se utilizar os   ���
���          � complementos disponibilizados.                                  ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �OBS_LANCFIS -> Objeto com as informacoes de varias observacoes   ���
���          �       dos documentos fiscais e seus lancamentos fiscais em seu  ��� 
���          �       nivel inferior.                                           ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFOBS_LANCFIS WSRECEIVE USERTOKEN,OBS_LANCFIS WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lCODITEM	:= 	.F.
Local	lCODAJUSTE 	:= 	.F.
Local	lNFID		:=	.F.
Local	lCODOBS		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:OBS_LANCFIS:OBS_LANCFIS<>Nil .And. Len(Self:OBS_LANCFIS:OBS_LANCFIS)>0
		If !Empty(Self:OBS_LANCFIS:ID_ENT)
			For nX := 1 To Len(Self:OBS_LANCFIS:OBS_LANCFIS)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������
				If Empty(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:NFID)
					lNFID := .T.
					Loop
				EndIf
				
				If Empty(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:CODOBS)
					lCODOBS := .T.
					Loop
				EndIf
	
				Begin Transaction
	
				//��������������������������������������������������������������Ŀ
				//�               Observacoes do documento fiscal                �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED009")
				cQuery := "DELETE "
				cQuery += "FROM SPED009 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:OBS_LANCFIS:ID_ENT,Len(SPED009->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:NFID,Len(SPED009->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				//��������������������������������������������������������������Ŀ
				//�        Lancamentos do documento vinculados a observacao      �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED009A")
				cQuery := "DELETE "
				cQuery += "FROM SPED009A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:OBS_LANCFIS:ID_ENT,Len(SPED009A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:NFID,Len(SPED009A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf			
				                
				//�������������������������������������������������������������Ŀ
				//�Efetuando a gravacao dos novos registros, independente de ser�
				//�  a primeira passagem para o documento ou uma regravacao que �
				//�  teve suas devidas exclusoes efetuadas anteriormente.       �
				//���������������������������������������������������������������
				dbSelectArea("SPED009")
				dbSetOrder(1)
				cChave	:=	PadR(Self:OBS_LANCFIS:ID_ENT,Len(SPED009->ID_ENT))
				cChave	+=	PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:NFID,Len(SPED009->NFID))
				cChave	+=	PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:CODOBS,Len(SPED009->CODOBS))
				If SPED009->(dbSeek(cChave))
					RecLock("SPED009",.F.)
				Else
					RecLock("SPED009",.T.)
				EndIf
				SPED009->ID_ENT		:=	PadR(Self:OBS_LANCFIS:ID_ENT,Len(SPED009->ID_ENT))
				SPED009->NFID		:=	PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:NFID,Len(SPED009->NFID))
				SPED009->CODOBS		:=	PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:CODOBS,Len(SPED009->CODOBS))
				SPED009->TXTCOMPL	:=	Self:OBS_LANCFIS:OBS_LANCFIS[nX]:TXTCOMPL
				MsUnLock()
				FkCommit()			
				
				For nI := 1 To Len(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS)
					//�����������������������������������������������������������������������������Ŀ
					//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
					//�������������������������������������������������������������������������������
					If Empty(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:CODITEM)
						lCODITEM := .T.
						Loop
					EndIf
					
					If Empty(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:CODAJUSTE)
						lCODAJUSTE := .T.
						Loop
					EndIf
				
					dbSelectArea("SPED009A")
					dbSetOrder(1)
					cChave	:=	SPED009->ID_ENT
					cChave	+=	SPED009->NFID
					cChave	+=	SPED009->CODOBS
					cChave	+=	PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:CODITEM,Len(SPED009A->CODITE))
					cChave	+=	PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:CODAJUSTE,Len(SPED009A->CODAJU))
					If SPED009A->(dbSeek(cChave))
						RecLock("SPED009A",.F.)
					Else
						RecLock("SPED009A",.T.)
					EndIf
					SPED009A->ID_ENT	:=	SPED009->ID_ENT
					SPED009A->NFID		:=	SPED009->NFID
					SPED009A->CODOBS	:=	SPED009->CODOBS
					SPED009A->ALQICM	:=	Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:ALQICMS
					SPED009A->BSICM		:=	Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:BASICMS
					SPED009A->CODAJU	:=	PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:CODAJUSTE,Len(SPED009A->CODAJU))
					SPED009A->CODITE	:=	PadR(Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:CODITEM,Len(SPED009A->CODITE))
					SPED009A->DESCCOM	:=	Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:DESCCOMPL
					SPED009A->OUTVLR	:=	Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:OUTVLR
					SPED009A->VLRICMS	:=	Self:OBS_LANCFIS:OBS_LANCFIS[nX]:LANCFIS[nI]:VLRICMS
					MsUnLock()
					FkCommit()
				Next nI
			
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos as observa��es dos documentos fiscais foram cadastradas com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas observa��es n�o foram cadastradas por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lCODOBS
				Self:RETORNO += "Algumas observa��es n�o foram cadastradas por estarem com o c�digo da observa��o em branco - (CODOBS). "
			EndIf			
			If lCODITEM
				Self:RETORNO += "Alguns lan�amentos fiscais n�o foram cadastrados por estarem com o codigo do item em branco - (CODITEM). "
			EndIf
			If lCODAJUSTE
				Self:RETORNO += "Alguns lan�amentos fiscais n�o foram cadastrados por estarem com o codigo de ajuste em branco - (CODAJUSTE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_EE   � Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares dos   ���
���          � documentos fiscais de energia eletrica.                         ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_EE -> Objeto com as informacoes complementares dos docu-   ���
���          �       mentos fiscais de energia eletrica.                       ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_EE WSRECEIVE USERTOKEN,COMPL_EE WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_EE:COMPL_EE<>Nil .And. Len(Self:COMPL_EE:COMPL_EE)>0
		If !Empty(Self:COMPL_EE:ID_ENT)
			For nX := 1 To Len(Self:COMPL_EE:COMPL_EE)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_EE:COMPL_EE[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�    Complementos dos documentos fiscais de Energia Eletrica   �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED010")
				cQuery := "DELETE "
				cQuery += "FROM SPED010 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_EE:ID_ENT,Len(SPED010->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_EE:COMPL_EE[nX]:NFID,Len(SPED010->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED010")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_EE:ID_ENT,Len(SPED010->ID_ENT))
				cChave	+=	PadR(Self:COMPL_EE:COMPL_EE[nX]:NFID,Len(SPED010->NFID))
				If SPED010->(dbSeek(cChave))
					RecLock("SPED010",.F.)
				Else
					RecLock("SPED010",.T.)
				EndIf
				SPED010->ID_ENT		:=	PadR(Self:COMPL_EE:ID_ENT,Len(SPED010->ID_ENT))
				SPED010->NFID 		:=	PadR(Self:COMPL_EE:COMPL_EE[nX]:NFID,Len(SPED010->NFID))
				SPED010->CHVCD115	:=	Self:COMPL_EE:COMPL_EE[nX]:CHVCD115
				SPED010->CONSKWH	:=	Self:COMPL_EE:COMPL_EE[nX]:CONSKWH
				SPED010->IDCLCONS	:=	Self:COMPL_EE:COMPL_EE[nX]:IDCLCONS
				SPED010->NOMV115	:=	Self:COMPL_EE:COMPL_EE[nX]:NOMVOL115
				SPED010->VLRFORC	:=	Self:COMPL_EE:COMPL_EE[nX]:VLRFORCONS
				SPED010->VLRTERC	:=	Self:COMPL_EE:COMPL_EE[nX]:VLRTERC
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))		
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_COMTEL� Autor � Gustavo G. Rueda    � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares dos   ���
���          � documentos fiscais de comunicacao/telecomunicacao               ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_COMTEL -> Objeto com as informacoes complementares dos     ���
���          �       documentos fiscais de comunicacao/telecomunicacao.        ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_COMTEL WSRECEIVE USERTOKEN,COMPL_COMTEL WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_COMTEL:COMPL_COMTEL<>Nil .And. Len(Self:COMPL_COMTEL:COMPL_COMTEL)>0
		If !Empty(Self:COMPL_COMTEL:ID_ENT)
			For nX := 1 To Len(Self:COMPL_COMTEL:COMPL_COMTEL)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_COMTEL:COMPL_COMTEL[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�       Complementos dos documentos fiscais de Comun./Tel.     �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED011")
				cQuery := "DELETE "
				cQuery += "FROM SPED011 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_COMTEL:ID_ENT,Len(SPED011->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_COMTEL:COMPL_COMTEL[nX]:NFID,Len(SPED011->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf

				//��������������������������������������������������������������Ŀ
				//�                         Terminal faturado                    � 
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED011A")
				cQuery := "DELETE "
				cQuery += "FROM SPED011A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_COMTEL:ID_ENT,Len(SPED011A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_COMTEL:COMPL_COMTEL[nX]:NFID,Len(SPED011A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
			
				dbSelectArea("SPED011")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_COMTEL:ID_ENT,Len(SPED011->ID_ENT))
				cChave	+=	PadR(Self:COMPL_COMTEL:COMPL_COMTEL[nX]:NFID,Len(SPED011->NFID))
				If SPED011->(dbSeek(cChave))
					RecLock("SPED011",.F.)
				Else
					RecLock("SPED011",.T.)
				EndIf
				SPED011->ID_ENT		:=	PadR(Self:COMPL_COMTEL:ID_ENT,Len(SPED011->ID_ENT))
				SPED011->NFID		:=	PadR(Self:COMPL_COMTEL:COMPL_COMTEL[nX]:NFID,Len(SPED011->NFID))
				SPED011->CHVCD115	:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:CHVCD115
				SPED011->NOMV115	:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:NOMVOL115
				SPED011->VLRTERC	:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:VLRTERC
				MsUnLock()
				FkCommit()
				
				For nI := 1 To Len(Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL)
					dbSelectArea("SPED011A")
					dbSetOrder(1)
					cChave	:=	SPED011->ID_ENT
					cChave	+=	SPED011->NFID
					cChave	+=	PadR(Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL[nI]:IDTERM,Len(SPED011A->IDTERM))
					If SPED011A->(dbSeek(cChave))
						RecLock("SPED011A",.F.)
					Else
						RecLock("SPED011A",.T.)
					EndIf
					SPED011A->ID_ENT	:=	SPED011->ID_ENT
					SPED011A->NFID		:=	SPED011->NFID
					SPED011A->CODMUN	:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL[nI]:CODMUN
					SPED011A->DTFIM		:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL[nI]:DTFIM
					SPED011A->DTINI		:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL[nI]:DTINI
					SPED011A->IDAREA	:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL[nI]:IDAREA
					SPED011A->IDTERM	:=	PadR(Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL[nI]:IDTERM,Len(SPED011A->IDTERM))
					SPED011A->PERFIS	:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL[nI]:PERFIS
					SPED011A->TPSERV	:=	Self:COMPL_COMTEL:COMPL_COMTEL[nX]:TERMINAL[nI]:TPSERV
					MsUnLock()
					FkCommit()
				Next nI
		
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))			
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_GAS_AGUA� Autor � Gustavo G. Rueda  � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares dos   ���
���          � documentos fiscais de AGUA e GAS canalizado                     ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_GAS_AGUA -> Objeto com as informacoes complementares dos   ���
���          �       documentos fiscais de AGUA e GAS canalizado.              ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_GAS_AGUA WSRECEIVE USERTOKEN,COMPL_GAS_AGUA WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA<>Nil .And. Len(Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA)>0
		If !Empty(Self:COMPL_GAS_AGUA:ID_ENT)
			For nX := 1 To Len(Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�    Complementos dos documentos fiscais de Energia Eletrica   �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED012")
				cQuery := "DELETE "
				cQuery += "FROM SPED012 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_GAS_AGUA:ID_ENT,Len(SPED012->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA[nX]:NFID,Len(SPED012->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED012")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_GAS_AGUA:ID_ENT,Len(SPED012->ID_ENT))
				cChave	+=	PadR(Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA[nX]:NFID,Len(SPED012->NFID))
				If SPED012->(dbSeek(cChave))
					RecLock("SPED012",.F.)
				Else
					RecLock("SPED012",.T.)
				EndIf
				SPED012->ID_ENT		:=	PadR(Self:COMPL_GAS_AGUA:ID_ENT,Len(SPED012->ID_ENT))
				SPED012->NFID 		:=	PadR(Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA[nX]:NFID,Len(SPED012->NFID))
				SPED012->IDCLCONS	:=	Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA[nX]:IDCLCONS
				SPED012->VLRFORC	:=	Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA[nX]:VLRFORCONS
				SPED012->VLRTERC	:=	Self:COMPL_GAS_AGUA:COMPL_GAS_AGUA[nX]:VLRTERC
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_IMPORT� Autor � Gustavo G. Rueda    � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares dos   ���
���          � dos documentos fiscais de importacao.                           ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_IMPORT -> Objeto com as informacoes complementares de      ���
���          �       importacao.                                               ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_IMPORT WSRECEIVE USERTOKEN,COMPL_IMPORT WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_IMPORT:COMPL_IMPORT<>Nil .And. Len(Self:COMPL_IMPORT:COMPL_IMPORT)>0
		If !Empty(Self:COMPL_IMPORT:ID_ENT)
			For nX := 1 To Len(Self:COMPL_IMPORT:COMPL_IMPORT)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_IMPORT:COMPL_IMPORT[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�       Complementos dos documentos fiscais de importacao      �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED013")
				cQuery := "DELETE "
				cQuery += "FROM SPED013 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_IMPORT:ID_ENT,Len(SPED013->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_IMPORT:COMPL_IMPORT[nX]:NFID,Len(SPED013->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED013")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_IMPORT:ID_ENT,Len(SPED013->ID_ENT))
				cChave	+=	PadR(Self:COMPL_IMPORT:COMPL_IMPORT[nX]:NFID,Len(SPED013->NFID))
				cChave	+=	PadR(Self:COMPL_IMPORT:COMPL_IMPORT[nX]:NUMDOC,Len(SPED013->NUMDOC))
				cChave	+=	PadR(Self:COMPL_IMPORT:COMPL_IMPORT[nX]:TPDOCIMP,Len(SPED013->TPDOCIMP))
				If SPED013->(dbSeek(cChave))
					RecLock("SPED013",.F.)
				Else
					RecLock("SPED013",.T.)
				EndIf
				SPED013->ID_ENT		:=	PadR(Self:COMPL_IMPORT:ID_ENT,Len(SPED013->ID_ENT))
				SPED013->NFID		:=	PadR(Self:COMPL_IMPORT:COMPL_IMPORT[nX]:NFID,Len(SPED013->NFID))
				SPED013->NUMDOC		:=	PadR(Self:COMPL_IMPORT:COMPL_IMPORT[nX]:NUMDOC,Len(SPED013->NUMDOC))
				SPED013->TPDOCIMP	:=	PadR(Self:COMPL_IMPORT:COMPL_IMPORT[nX]:TPDOCIMP,Len(SPED013->TPDOCIMP))
				SPED013->VLRCOF		:=	Self:COMPL_IMPORT:COMPL_IMPORT[nX]:VLRCOF
				SPED013->VLRPIS		:=	Self:COMPL_IMPORT:COMPL_IMPORT[nX]:VLRPIS
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_VOLTRANSP� Autor � Gustavo G. Rueda � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares dos   ���
���          � volumes transportados (combustiveis ou nao) dos documentos      ���
���          � fiscais.                                                        ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_VOLTRANSP -> Objeto com as informacoes complementares de   ���
���          �       volumes transportados, combustiveis ou nao.               ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_VOLTRANSP WSRECEIVE USERTOKEN,COMPL_VOLTRANSP WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lIDTRANSP	:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP<>Nil .And. Len(Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP)>0
		If !Empty(Self:COMPL_VOLTRANSP:ID_ENT)
			For nX := 1 To Len(Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:IDTRANSP)
					lIDTRANSP	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//� Complementos de volumes transportados dos documentos fiscais �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED014")
				cQuery := "DELETE "
				cQuery += "FROM SPED014 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_VOLTRANSP:ID_ENT,Len(SPED014->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:NFID,Len(SPED014->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED014")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_VOLTRANSP:ID_ENT,Len(SPED014->ID_ENT))
				cChave	+=	PadR(Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:NFID,Len(SPED014->NFID))
				If SPED014->(dbSeek(cChave))
					RecLock("SPED014",.F.)
				Else
					RecLock("SPED014",.T.)
				EndIf
				SPED014->ID_ENT		:=	PadR(Self:COMPL_VOLTRANSP:ID_ENT,Len(SPED014->ID_ENT))
				SPED014->NFID		:=	PadR(Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:NFID,Len(SPED014->NFID))
				SPED014->CPFMOT		:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:CPFMOT
				SPED014->HSAIDA		:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:HSAIDA
				SPED014->IDAUTSEF	:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:IDAUTSEF
				SPED014->IDTRANSP	:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:IDTRANSP
				SPED014->IDVEIC		:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:IDVEIC
				SPED014->NOMMOT		:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:NOMMOT
				SPED014->NUMPASFI	:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:NUMPASFIS
				SPED014->PSBRU		:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:PSBRU
				SPED014->PSLIQ		:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:PSLIQ
				SPED014->QTDVOL		:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:QTDVOL
				SPED014->TEMP		:=	Self:COMPL_VOLTRANSP:COMPL_VOLTRANSP[nX]:TEMP
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lIDTRANSP
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID da transportadora em branco - (IDTRANSP). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_CARGATRANSP� Autor �Gustavo G. Rueda� Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          � cargas transportadas e locais de coleta/entrega dos documentos  ���
���          � fiscais.                                                        ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_CARGATRANSP -> Objeto com as informacoes complementares das���
���          �       cargas transportadas e em seu nivel inferior os locais    ��� 
���          �       de entrega/coleta.                                        ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_CARGATRANSP WSRECEIVE USERTOKEN,COMPL_CARGATRANSP WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lMODELO		:=	.F.
Local	lAtualizou	:=	.F.
Local	lLOC_COLENT	:=	.F.
Local	lTP_TRANSP	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP<>Nil .And. Len(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP)>0
		If !Empty(Self:COMPL_CARGATRANSP:ID_ENT)
			For nX := 1 To Len(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:MODELO)
					lMODELO	:=	.T.
					Loop
				EndIf
				If Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT==Nil
					lLOC_COLENT	:=	.T.
					Loop
				ElseIf Empty(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:TP_TRANSP)
					lTP_TRANSP	:=	.T.
					Loop				
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//� Complementos de cargas transportadas dos documentos fiscais  �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED015")
				cQuery := "DELETE "
				cQuery += "FROM SPED015 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_CARGATRANSP:ID_ENT,Len(SPED015->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:NFID,Len(SPED015->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				//��������������������������������������������������������������Ŀ
				//�      Locais da coleta/entrega das cargas transportadas       �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED015A")
				cQuery := "DELETE "
				cQuery += "FROM SPED015A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_CARGATRANSP:ID_ENT,Len(SPED015A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:NFID,Len(SPED015A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED015")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_CARGATRANSP:ID_ENT,Len(SPED015->ID_ENT))
				cChave	+=	PadR(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:NFID,Len(SPED015->NFID))
				If SPED015->(dbSeek(cChave))
					RecLock("SPED015",.F.)
				Else
					RecLock("SPED015",.T.)
				EndIf
				SPED015->ID_ENT		:=	PadR(Self:COMPL_CARGATRANSP:ID_ENT,Len(SPED015->ID_ENT))
				SPED015->NFID		:=	PadR(Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:NFID,Len(SPED015->NFID))
				SPED015->CHVNFE		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:CHVNFE
				SPED015->CPFCNPJD	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:CPFCNPJ_DEST
				SPED015->CPFCNPJR	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:CPFCNPJ_REM
				SPED015->DTEMIS		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:DTEMIS
				SPED015->IEDEST		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:IE_DEST
				SPED015->IEREM		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:IE_REM
				SPED015->MODELO		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:MODELO
				SPED015->NUMERO		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:NUMERO
				SPED015->PSBRU		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:PSBRU
				SPED015->PSLIQ		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:PSLIQ
				SPED015->QTDVOL		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:QTDVOL
				SPED015->SERIE		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:SERIE
				SPED015->UFDEST		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:UF_DEST
				SPED015->UFREM		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:UF_REM
				SPED015->VLRMERC	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:VLRMER
				SPED015->VLRTOTAL	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:VLRTOT
				MsUnLock()
				FkCommit()
					
				If SPED015A->(dbSeek(cChave))
					RecLock("SPED015A",.F.)
				Else
					RecLock("SPED015A",.T.)
				EndIf
				SPED015A->ID_ENT	:=	SPED015->ID_ENT
				SPED015A->NFID		:=	SPED015->NFID
				SPED015A->CNPJCOL	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:CNPJ_COL
				SPED015A->CNPJENT	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:CNPJ_ENT
				SPED015A->CPFCOL	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:CPF_COL
				SPED015A->CPFENT	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:CPF_ENT
				SPED015A->CODMUNC	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:IDMUN_COL
				SPED015A->CODMUNE	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:IDMUN_ENT
				SPED015A->IECOL		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:IE_COL
				SPED015A->IEENT		:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:IE_ENT
				SPED015A->TPTRANSP	:=	Self:COMPL_CARGATRANSP:COMPL_CARGATRANSP[nX]:LOC_COLENT:TP_TRANSP
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lMODELO
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o mod�lo em branco - (MODELO). "
			EndIf
			If lLOC_COLENT
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem sem local de coleta/entrega vinculado - (Nivel inferior - LOC_COLENT). "
			EndIf
			If lTP_TRANSP
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o tipo de transporte em branco - (TP_TRANSP). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_NFST � Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares das   ���
���          � Nota Fiscal de Servi�o de Transporte .                          ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_NFST -> Objeto com as informacoes complementares da nota   ���
���          �       fiscal de servico de transporte.                          ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_NFST WSRECEIVE USERTOKEN,COMPL_NFST WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_NFST:COMPL_NFST<>Nil .And. Len(Self:COMPL_NFST:COMPL_NFST)>0
		If !Empty(Self:COMPL_NFST:ID_ENT)
			For nX := 1 To Len(Self:COMPL_NFST:COMPL_NFST)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_NFST:COMPL_NFST[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�   Complementos das notas fiscais de servico de transporte    �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED016")
				cQuery := "DELETE "
				cQuery += "FROM SPED016 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_NFST:ID_ENT,Len(SPED016->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_NFST:COMPL_NFST[nX]:NFID,Len(SPED016->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED016")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_NFST:ID_ENT,Len(SPED016->ID_ENT))
				cChave	+=	PadR(Self:COMPL_NFST:COMPL_NFST[nX]:NFID,Len(SPED016->NFID))
				If SPED016->(dbSeek(cChave))
					RecLock("SPED016",.F.)
				Else
					RecLock("SPED016",.T.)
				EndIf
				SPED016->ID_ENT		:=	PadR(Self:COMPL_NFST:ID_ENT,Len(SPED016->ID_ENT))
				SPED016->NFID		:=	PadR(Self:COMPL_NFST:COMPL_NFST[nX]:NFID,Len(SPED016->NFID))
				SPED016->CODMUND	:=	Self:COMPL_NFST:COMPL_NFST[nX]:CODMUNDES
				SPED016->CODMUNO	:=	Self:COMPL_NFST:COMPL_NFST[nX]:CODMUNORI
				SPED016->IDVEIC		:=	Self:COMPL_NFST:COMPL_NFST[nX]:IDVEIC
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))		
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_CTRC � Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares dos   ���
���          � conhecimentos de transportes rodoviarios.                       ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_CTRC -> Objeto com as informacoes complementares dos conhe-���
���          �       cimentos de transporte rodoviario.                        ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_CTRC WSRECEIVE USERTOKEN,COMPL_CTRC WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_CTRC:COMPL_CTRC<>Nil .And. Len(Self:COMPL_CTRC:COMPL_CTRC)>0
		If Self:COMPL_CTRC:ID_ENT<>Nil .And. !Empty(Self:COMPL_CTRC:ID_ENT)
			For nX := 1 To Len(Self:COMPL_CTRC:COMPL_CTRC)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_CTRC:COMPL_CTRC[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                   Complementos dos CTRs                      �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED017")
				cQuery := "DELETE "
				cQuery += "FROM SPED017 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_CTRC:ID_ENT,Len(SPED017->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_CTRC:COMPL_CTRC[nX]:NFID,Len(SPED017->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED017")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_CTRC:ID_ENT,Len(SPED017->ID_ENT))
				cChave	+=	PadR(Self:COMPL_CTRC:COMPL_CTRC[nX]:NFID,Len(SPED017->NFID))
				If SPED017->(dbSeek(cChave))
					RecLock("SPED017",.F.)
				Else
					RecLock("SPED017",.T.)
				EndIf
				SPED017->ID_ENT		:=	PadR(Self:COMPL_CTRC:ID_ENT,Len(SPED017->ID_ENT))
				SPED017->NFID		:=	PadR(Self:COMPL_CTRC:COMPL_CTRC[nX]:NFID,Len(SPED017->NFID))
				SPED017->CODMUND	:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:CODMUNDES
				SPED017->CODMUNO	:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:CODMUNORI
				SPED017->IDCONSIG	:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:IDCONSIG
				SPED017->IDREDESP	:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:IDREDESP
				SPED017->IDVEIC		:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:IDVEIC
				SPED017->OUTVLR		:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:OUTVLR
				SPED017->TPFRTRED	:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:TPFRTRED
				SPED017->VLRDESP	:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:VLRDESP
				SPED017->VLRLIQ		:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:VLRLIQ
				SPED017->VLRPDG		:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:VLRPDG
				SPED017->VLRSECCA	:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:VLRSECCAT
				SPED017->VLRTOTAL	:=	Self:COMPL_CTRC:COMPL_CTRC[nX]:VLRTOT
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_CTAQC� Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares dos   ���
���          � conhecimentos aquaviarios de cargas.                            ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_CTRC -> Objeto com as informacoes complementares dos conhe-���
���          �       cimentos aquaviarios de cagas.                            ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_CTAQC WSRECEIVE USERTOKEN,COMPL_CTAQC WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_CTAQC:COMPL_CTAQC<>Nil .And. Len(Self:COMPL_CTAQC:COMPL_CTAQC)>0
		If Self:COMPL_CTAQC:ID_ENT<>Nil .And. !Empty(Self:COMPL_CTAQC:ID_ENT)
			For nX := 1 To Len(Self:COMPL_CTAQC:COMPL_CTAQC)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_CTAQC:COMPL_CTAQC[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                  Complementos dos CTAQC                      �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED018")
				cQuery := "DELETE "
				cQuery += "FROM SPED018 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_CTAQC:ID_ENT,Len(SPED018->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_CTAQC:COMPL_CTAQC[nX]:NFID,Len(SPED018->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED018")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_CTAQC:ID_ENT,Len(SPED018->ID_ENT))
				cChave	+=	PadR(Self:COMPL_CTAQC:COMPL_CTAQC[nX]:NFID,Len(SPED018->NFID))
				If SPED018->(dbSeek(cChave))
					RecLock("SPED018",.F.)
				Else
					RecLock("SPED018",.T.)
				EndIf
				SPED018->ID_ENT		:=	PadR(Self:COMPL_CTAQC:ID_ENT,Len(SPED018->ID_ENT))
				SPED018->NFID		:=	PadR(Self:COMPL_CTAQC:COMPL_CTAQC[nX]:NFID,Len(SPED018->NFID))
				SPED018->CODMUND	:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:CODMUNDES
				SPED018->CODMUNO	:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:CODMUNORI
				SPED018->IDCONSIG	:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:IDCONSIG
				SPED018->IDVEIC		:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:IDVEIC
				SPED018->NUMVIAG	:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:NUMVIAG
				SPED018->OUTVLR		:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:OUTVLR
				SPED018->TPNAVEG	:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:TPNAVEG
				SPED018->TPVEIC		:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:TPVEIC
				SPED018->VLRBRU		:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:VLRBRU
				SPED018->VLRDESCD	:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:VLRDESPCD
				SPED018->VLRDESPO	:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:VLRDESPOR
				SPED018->VLRLIQ		:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:VLRLIQ
				SPED018->VLRMM		:=	Self:COMPL_CTAQC:COMPL_CTAQC[nX]:VLRMM
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))		
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_CTAEC� Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares dos   ���
���          � conhecimentos aereo de cargas.                                  ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_CTAEC -> Objeto com as informacoes complementares dos      ���
���          �       conhecimentos aereo de cagas.                             ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_CTAEC WSRECEIVE USERTOKEN,COMPL_CTAEC WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_CTAEC:COMPL_CTAEC<>Nil .And. Len(Self:COMPL_CTAEC:COMPL_CTAEC)>0
		If Self:COMPL_CTAEC:ID_ENT<>Nil .And. !Empty(Self:COMPL_CTAEC:ID_ENT)
			For nX := 1 To Len(Self:COMPL_CTAEC:COMPL_CTAEC)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_CTAEC:COMPL_CTAEC[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                  Complementos dos CTAEC                      �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED019")
				cQuery := "DELETE "
				cQuery += "FROM SPED019 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_CTAEC:ID_ENT,Len(SPED019->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_CTAEC:COMPL_CTAEC[nX]:NFID,Len(SPED019->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED019")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_CTAEC:ID_ENT,Len(SPED019->ID_ENT))
				cChave	+=	PadR(Self:COMPL_CTAEC:COMPL_CTAEC[nX]:NFID,Len(SPED019->NFID))
				If SPED019->(dbSeek(cChave))
					RecLock("SPED019",.F.)
				Else
					RecLock("SPED019",.T.)
				EndIf
				SPED019->ID_ENT		:=	PadR(Self:COMPL_CTAEC:ID_ENT,Len(SPED019->ID_ENT))
				SPED019->NFID		:=	PadR(Self:COMPL_CTAEC:COMPL_CTAEC[nX]:NFID,Len(SPED019->NFID))
				SPED019->CODMUND	:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:CODMUNDES
				SPED019->CODMUNO	:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:CODMUNORI
				SPED019->IDVEIC		:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:IDVEIC
				SPED019->NUMVOO		:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:NUMVOO
				SPED019->OUTVLR		:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:OUTVLR
				SPED019->PSTAX		:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:PSTAX
				SPED019->TPTAR		:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:TPTAR
				SPED019->VLRADV		:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:VLRADV
				SPED019->VLRRED		:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:VLRRED
				SPED019->VLRTER		:=	Self:COMPL_CTAEC:COMPL_CTAEC[nX]:VLRTER
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFCOMPL_CTMC � Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informaces complementares do    ���
���          � conhecimento multimodal de cargas.                              ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �COMPL_CTMC -> Objeto com as informacoes complementares do        ���
���          �       conhecimento multimodal de cagas.                         ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFCOMPL_CTMC WSRECEIVE USERTOKEN,COMPL_CTMC WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:COMPL_CTMC:COMPL_CTMC<>Nil .And. Len(Self:COMPL_CTMC:COMPL_CTMC)>0
		If Self:COMPL_CTMC:ID_ENT<>Nil .And. !Empty(Self:COMPL_CTMC:ID_ENT)
			For nX := 1 To Len(Self:COMPL_CTMC:COMPL_CTMC)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:COMPL_CTMC:COMPL_CTMC[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                   Complementos dos CTMC                      �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED020")
				cQuery := "DELETE "
				cQuery += "FROM SPED020 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:COMPL_CTMC:ID_ENT,Len(SPED020->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:COMPL_CTMC:COMPL_CTMC[nX]:NFID,Len(SPED020->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf

				dbSelectArea("SPED020")
				dbSetOrder(1)
				cChave	:=	PadR(Self:COMPL_CTMC:ID_ENT,Len(SPED020->ID_ENT))
				cChave	+=	PadR(Self:COMPL_CTMC:COMPL_CTMC[nX]:NFID,Len(SPED020->NFID))				
				If SPED020->(dbSeek(cChave))
					RecLock("SPED020",.F.)
				Else
					RecLock("SPED020",.T.)
				EndIf
				SPED020->ID_ENT		:=	PadR(Self:COMPL_CTMC:ID_ENT,Len(SPED020->ID_ENT))
				SPED020->NFID		:=	PadR(Self:COMPL_CTMC:COMPL_CTMC[nX]:NFID,Len(SPED020->NFID))
				SPED020->CODMUND	:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:CODMUNDES
				SPED020->CODMUNO	:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:CODMUNORI
				SPED020->IDCONSIG	:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:IDCONSIG
				SPED020->IDREDESP	:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:IDREDESP
				SPED020->IDVEIC		:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:IDVEIC
				SPED020->NATFRT		:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:NATFRT
				SPED020->OUTVLR		:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:OUTVLR
				SPED020->ROTM		:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:ROTM
				SPED020->VLRGRIS	:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:VLRGRIS
				SPED020->VLRLIQ		:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:VLRLIQ
				SPED020->VLRPDG		:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:VLRPDG
				SPED020->VLRTOTAL	:=	Self:COMPL_CTMC:COMPL_CTMC[nX]:VLRTOT
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os complementos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns complementos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDF_MODAIS    � Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares dos  ���
���          � modais atrelados ao conhecimento multimodal de cargas.          ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �MODAIS -> Objeto com as informacoes complementares dos modais    ���
���          �       atrelados ao conhecimento multimodal de cargas.           ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDF_MODAIS WSRECEIVE USERTOKEN,MODAIS WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:MODAIS:MODAIS<>Nil .And. Len(Self:MODAIS:MODAIS)>0
		If Self:MODAIS:ID_ENT<>Nil .And. !Empty(Self:MODAIS:ID_ENT)
			For nX := 1 To Len(Self:MODAIS:MODAIS)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:MODAIS:MODAIS[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                       Modais do CTMC                         �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED021")
				cQuery := "DELETE "
				cQuery += "FROM SPED021 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:MODAIS:ID_ENT,Len(SPED021->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:MODAIS:MODAIS[nX]:NFID,Len(SPED021->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf

				dbSelectArea("SPED021")
				dbSetOrder(1)
				cChave	:=	PadR(Self:MODAIS:ID_ENT,Len(SPED021->ID_ENT))
				cChave	+=	PadR(Self:MODAIS:MODAIS[nX]:NFID,Len(SPED021->NFID))
				If SPED021->(dbSeek(cChave))
					RecLock("SPED021",.F.)
				Else
					RecLock("SPED021",.T.)
				EndIf
				SPED021->ID_ENT		:=	PadR(Self:MODAIS:ID_ENT,Len(SPED021->ID_ENT))
				SPED021->NFID		:=	PadR(Self:MODAIS:MODAIS[nX]:NFID,Len(SPED021->NFID))
				SPED021->CNPJEMI	:=	Self:MODAIS:MODAIS[nX]:CNPJEMIT
				SPED021->CNPJTOM	:=	Self:MODAIS:MODAIS[nX]:CNPJTOM
				SPED021->CODMUND	:=	Self:MODAIS:MODAIS[nX]:CODMUNDES
				SPED021->CODMUNO	:=	Self:MODAIS:MODAIS[nX]:CODMUNORI
				SPED021->DTEMIS		:=	Self:MODAIS:MODAIS[nX]:DTEMIS
				SPED021->IEEMI		:=	Self:MODAIS:MODAIS[nX]:IEEMIT
				SPED021->IETOM		:=	Self:MODAIS:MODAIS[nX]:IETOM
				SPED021->MODELO		:=	Self:MODAIS:MODAIS[nX]:MODELO
				SPED021->NUMERO		:=	Self:MODAIS:MODAIS[nX]:NUMERO
				SPED021->NUMSEQ		:=	Self:MODAIS:MODAIS[nX]:NUMSEQ
				SPED021->SERIE		:=	Self:MODAIS:MODAIS[nX]:SERIE
				SPED021->SUBSER		:=	Self:MODAIS:MODAIS[nX]:SUBSERIE
				SPED021->TPEMIT		:=	Self:MODAIS:MODAIS[nX]:TPEMIT
				SPED021->UFEMI		:=	Self:MODAIS:MODAIS[nX]:UFEMIT
				SPED021->UFTOM		:=	Self:MODAIS:MODAIS[nX]:UFTOM
				SPED021->VLRTOTAL	:=	Self:MODAIS:MODAIS[nX]:VLRTOT
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os modais dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns modais n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDF_TITULO    � Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao dos titulos dos documentos fiscais  ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �TITULO -> Objeto com as informacoes sobre o titulo do documento  ���
���          �       fiscal; em seu nivel inferior, enconstram-se as parcelas  ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDF_TITULO WSRECEIVE USERTOKEN,TITULO WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lPARCELA	:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:TITULO:TITULO<>Nil .And. Len(Self:TITULO:TITULO)>0
		If Self:TITULO:ID_ENT<>Nil .And. !Empty(Self:TITULO:ID_ENT)
			For nX := 1 To Len(Self:TITULO:TITULO)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:TITULO:TITULO[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:TITULO:TITULO[nX]:TPPGTO<>Nil .And. ;
					(AllTrim(Self:TITULO:TITULO[nX]:TPPGTO)<>"9" .And. (Self:TITULO:TITULO[nX]:PARCELA==Nil .Or. Len(Self:TITULO:TITULO[nX]:PARCELA)==0)) //.Or.;
					//(AllTrim(Self:TITULO:TITULO[nX]:TPPGTO)=="9" .And. (Self:TITULO:TITULO[nX]:PARCELA<>Nil .Or. Len(Self:TITULO:TITULO[nX]:PARCELA)>0))
					lPARCELA	:=	.T.
					Loop					
				EndIf
												
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�               Fatura dos documentos fiscais                  �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED022")
				cQuery := "DELETE "
				cQuery += "FROM SPED022 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:TITULO:ID_ENT,Len(SPED022->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:TITULO:TITULO[nX]:NFID,Len(SPED022->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//��������������������������������������������������������������Ŀ
				//�                   Parcelas dos titulos                       �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������				
				dbSelectArea("SPED022A")
				cQuery := "DELETE "
				cQuery += "FROM SPED022A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:TITULO:ID_ENT,Len(SPED022A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:TITULO:TITULO[nX]:NFID,Len(SPED022A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf

				dbSelectArea("SPED022")
				dbSetOrder(1)
				cChave	:=	PadR(Self:TITULO:ID_ENT,Len(SPED022->ID_ENT))
				cChave	+=	PadR(Self:TITULO:TITULO[nX]:NFID,Len(SPED022->NFID))
				cChave	+=	PadR(Self:TITULO:TITULO[nX]:NUMTIT,Len(SPED022->NUMTIT))
				If SPED022->(dbSeek(cChave))
					RecLock("SPED022",.F.)
				Else
					RecLock("SPED022",.T.)
				EndIf
				SPED022->ID_ENT		:=	PadR(Self:TITULO:ID_ENT,Len(SPED022->ID_ENT))
				SPED022->NFID		:=	PadR(Self:TITULO:TITULO[nX]:NFID,Len(SPED022->NFID))
				SPED022->DESCCOM	:=	Self:TITULO:TITULO[nX]:DESCCOMPL
				SPED022->NUMTIT		:=	PadR(Self:TITULO:TITULO[nX]:NUMTIT,Len(SPED022->NUMTIT))
				SPED022->TPEMIT		:=	Self:TITULO:TITULO[nX]:TPEMIT
				SPED022->TPPGTO		:=	Self:TITULO:TITULO[nX]:TPPGTO
				SPED022->TPTIT		:=	Self:TITULO:TITULO[nX]:TPTIT
				MsUnLock()
				FkCommit()
				
				For nI := 1 To Len(Self:TITULO:TITULO[nX]:PARCELA)
					dbSelectArea("SPED022A")
					dbSetOrder(1)
					cChave	:=	SPED022->ID_ENT
					cChave	+=	SPED022->NFID
					cChave	+=	SPED022->NUMTIT
					cChave	+=	Str(Self:TITULO:TITULO[nX]:PARCELA[nI]:NUMERO,10)
					If SPED022A->(dbSeek(cChave))
						RecLock("SPED022A",.F.)
					Else
						RecLock("SPED022A",.T.)
					EndIf
					SPED022A->ID_ENT	:=	SPED022->ID_ENT
					SPED022A->NFID		:=	SPED022->NFID
					SPED022A->NUMTIT	:=	SPED022->NUMTIT
					SPED022A->DTVENC	:=	Self:TITULO:TITULO[nX]:PARCELA[nI]:DTVENC
					SPED022A->NUMERO	:=	Self:TITULO:TITULO[nX]:PARCELA[nI]:NUMERO
					SPED022A->VLR		:=	Self:TITULO:TITULO[nX]:PARCELA[nI]:VLR
					MsUnLock()
					FkCommit()
				Next nI
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as faturas dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas faturas n�o foram cadastradas por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lPARCELA
				Self:RETORNO += "Algumas faturas n�o foram cadastradas por estarem indicando pagamento 'A VISTA' ou 'A PRAZO' e n�o conterem as parcelas relacionadas - (PARCELA). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FIS_TRIBUTOS    � Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao dos tributos dos documentos fiscais ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �TRIBUTOS -> Objeto com as informacoes sobre o tributo do docu-   ���
���          �       mento fiscal.                                             ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FIS_TRIBUTOS WSRECEIVE USERTOKEN,TRIBUTOS WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lTRIBUTOS	:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:TRIBUTOS:TRIBUTOS<>Nil .And. Len(Self:TRIBUTOS:TRIBUTOS)>0
		If Self:TRIBUTOS:ID_ENT<>Nil .And. !Empty(Self:TRIBUTOS:ID_ENT)
			For nX := 1 To Len(Self:TRIBUTOS:TRIBUTOS)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:TRIBUTOS:TRIBUTOS[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If !AllTrim(Self:TRIBUTOS:TRIBUTOS[nX]:TPTRIB)$"01/02/03/04/05/06/07/08/09/10/"	//				//01=ICMS, 02=ICMS/ST, 03-IPI, 04=ISS, 05=PIS, 06=PIS/ST, 07=COFINS, 08=COFINS/ST, 09=IR, 10=PREVID�NCIA
					lTRIBUTOS	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                       Modais do CTMC                         �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED023")
				cQuery := "DELETE "
				cQuery += "FROM SPED023 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:TRIBUTOS:ID_ENT,Len(SPED023->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:TRIBUTOS:TRIBUTOS[nX]:NFID,Len(SPED023->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf

				dbSelectArea("SPED021")
				dbSetOrder(1)
				cChave	:=	PadR(Self:TRIBUTOS:ID_ENT,Len(SPED023->ID_ENT))
				cChave	+=	PadR(Self:TRIBUTOS:TRIBUTOS[nX]:NFID,Len(SPED023->NFID))
				cChave	+=	Str(Self:TRIBUTOS:TRIBUTOS[nX]:NUMITE,6)
				If SPED023->(dbSeek(cChave))
					RecLock("SPED023",.F.)
				Else
					RecLock("SPED023",.T.)
				EndIf
				SPED023->ID_ENT	:=	PadR(Self:TRIBUTOS:ID_ENT,Len(SPED023->ID_ENT))
				SPED023->NFID	:=	PadR(Self:TRIBUTOS:TRIBUTOS[nX]:NFID,Len(SPED023->NFID))
				SPED023->ALIQ	:=	Self:TRIBUTOS:TRIBUTOS[nX]:ALIQ
				SPED023->BASE	:=	Self:TRIBUTOS:TRIBUTOS[nX]:BASE
				SPED023->CST	:=	Self:TRIBUTOS:TRIBUTOS[nX]:CST
				SPED023->NUMITE	:=	Self:TRIBUTOS:TRIBUTOS[nX]:NUMITE
				SPED023->TPTRIB	:=	Self:TRIBUTOS:TRIBUTOS[nX]:TPTRIB	//01=ICMS, 02=ICMS/ST, 03-IPI, 04=ISS, 05=PIS, 06=PIS/ST, 07=COFINS, 08=COFINS/ST, 09=IR, 10=PREVID�NCIA
				SPED023->VLR	:=	Self:TRIBUTOS:TRIBUTOS[nX]:VLR
				MsUnLock()
				FkCommit()

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os tributos dos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns tributos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lTRIBUTOS
				Self:RETORNO += "Alguns tributos n�o foram cadastrados por estarem com c�digo do tipo de tributo inv�lido - (TPTRIB). Podendo ser: 01=ICMS, 02=ICMS/ST, 03-IPI, 04=ISS, 05=PIS, 06=PIS/ST, 07=COFINS, 08=COFINS/ST, 09=IR, 10=PREVID�NCIA."
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFINFCOMPL_PROCREF� Autor � Gustavo G. Rueda| Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao dos processos referenciados aos     ���
���Descri��o �  documentos fiscais.                                            ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �INFCOMPL_PROCREF -> Objeto com as informacoes sobre os processos ���
���          �       referenciados ao documento fiscal.                        ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFINFCOMPL_PROCREF WSRECEIVE USERTOKEN,INFCOMPL_PROCREF WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lCODIGO		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF<>Nil .And. Len(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF)>0
		If Self:INFCOMPL_PROCREF:ID_ENT<>Nil .And. !Empty(Self:INFCOMPL_PROCREF:ID_ENT)
			For nX := 1 To Len(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:CODIGO)
					lCODIGO	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�         informacao complementar do documento fiscal          �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED024")
				cQuery := "DELETE "
				cQuery += "FROM SPED024 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_PROCREF:ID_ENT,Len(SPED024->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:NFID,Len(SPED024->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//��������������������������������������������������������������Ŀ
				//�       Processos referenciados a informacao complementar      �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED024A")
				cQuery := "DELETE "
				cQuery += "FROM SPED024A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_PROCREF:ID_ENT,Len(SPED024A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:NFID,Len(SPED024A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED024")
				dbSetOrder(1)
				cChave	:=	PadR(Self:INFCOMPL_PROCREF:ID_ENT,Len(SPED024->ID_ENT))
				cChave	+=	PadR(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:NFID,Len(SPED024->NFID))
				cChave	+=	PadR(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:CODIGO,Len(SPED024->CODIGO))
				If SPED024->(dbSeek(cChave))
					RecLock("SPED024",.F.)
				Else
					RecLock("SPED024",.T.)
				EndIf
				SPED024->ID_ENT	:=	PadR(Self:INFCOMPL_PROCREF:ID_ENT,Len(SPED024->ID_ENT))
				SPED024->NFID	:=	PadR(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:NFID,Len(SPED024->NFID))
				SPED024->CODIGO	:=	PadR(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:CODIGO,Len(SPED024->CODIGO))
				SPED024->COMPL	:=	Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:COMPL
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:PROCREF)
					dbSelectArea("SPED024A")
					dbSetOrder(1)
					If SPED024A->(dbSeek(cChave))
						RecLock("SPED024A",.F.)
					Else
						RecLock("SPED024A",.T.)
					EndIf
					SPED024A->ID_ENT	:=	SPED024->ID_ENT
					SPED024A->NFID		:=	SPED024->NFID
					SPED024A->CODIGO	:=	SPED024->CODIGO
					SPED024A->INDORI	:=	Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:PROCREF[nI]:INDORI	//0=SEFAZ, 1=JUSTICA FEDERAL, 2=JUSTICA ESTADUAL, 3=SECEX/RFB, 9=OUTROS
					SPED024A->NUMERO	:=	Self:INFCOMPL_PROCREF:INFCOMPL_PROCREF[nX]:PROCREF[nI]:NUMERO
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos as informa��es complementares/processos referenciados aos documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares/processos referenciados n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lCODIGO
				Self:RETORNO += "Algumas informa��es complementares/processos referenciados n�o foram cadastrados por estarem com o codigo em branco - (CODIGO). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFINFCOMPL_DA� Autor � Gustavo G. Rueda     � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao dos documentos de arrecadacao       ���
���Descri��o �  referenciados aos documentos fiscais.                          ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �INFCOMPL_DA -> Objeto com as informacoes sobre os documentos de  ���
���          �       arrecadacao referenciados ao documento fiscal.            ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFINFCOMPL_DA WSRECEIVE USERTOKEN,INFCOMPL_DA WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lCODIGO		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:INFCOMPL_DA:INFCOMPL_DA<>Nil .And. Len(Self:INFCOMPL_DA:INFCOMPL_DA)>0
		If Self:INFCOMPL_DA:ID_ENT<>Nil .And. !Empty(Self:INFCOMPL_DA:ID_ENT)
			For nX := 1 To Len(Self:INFCOMPL_DA:INFCOMPL_DA)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:CODIGO)
					lCODIGO	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�         informacao complementar do documento fiscal          �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED025")
				cQuery := "DELETE "
				cQuery += "FROM SPED025 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_DA:ID_ENT,Len(SPED025->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:NFID,Len(SPED025->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//�����������������������������������������������������������������Ŀ
				//�Documentos de arrecadacao referenciados a informacao complementar�
				//�No caso de regravacao, excluo as movimentacoes anteriores para   �
				//�  utilizar as novas.                                             �
				//�������������������������������������������������������������������
				dbSelectArea("SPED025A")
				cQuery := "DELETE "
				cQuery += "FROM SPED025A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_DA:ID_ENT,Len(SPED025A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:NFID,Len(SPED025A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED025")
				dbSetOrder(1)
				cChave	:=	PadR(Self:INFCOMPL_DA:ID_ENT,Len(SPED025->ID_ENT))
				cChave	+=	PadR(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:NFID,Len(SPED025->NFID))
				cChave	+=	PadR(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:CODIGO,Len(SPED025->CODIGO))
				If SPED025->(dbSeek(cChave))
					RecLock("SPED025",.F.)
				Else
					RecLock("SPED025",.T.)
				EndIf
				SPED025->ID_ENT	:=	PadR(Self:INFCOMPL_DA:ID_ENT,Len(SPED025->ID_ENT))
				SPED025->NFID	:=	PadR(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:NFID,Len(SPED025->NFID))
				SPED025->CODIGO	:=	PadR(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:CODIGO,Len(SPED025->CODIGO))
				SPED025->COMPL	:=	Self:INFCOMPL_DA:INFCOMPL_DA[nX]:COMPL
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:INFCOMPL_DA:INFCOMPL_DA[nX]:DA)
					dbSelectArea("SPED025A")
					dbSetOrder(1)
					If SPED025A->(dbSeek(cChave))
						RecLock("SPED025A",.F.)
					Else
						RecLock("SPED025A",.T.)
					EndIf
					SPED025A->ID_ENT	:=	SPED025->ID_ENT
					SPED025A->NFID		:=	SPED025->NFID
					SPED025A->CODIGO	:=	SPED025->CODIGO
					SPED025A->CODAUT	:=	Self:INFCOMPL_DA:INFCOMPL_DA[nX]:DA[nI]:CODAUT
					SPED025A->CODMOD	:=	Self:INFCOMPL_DA:INFCOMPL_DA[nX]:DA[nI]:CODMOD	//0=DOCUMENTO ESTADUAL DE ARRECADACAO, 1=GNRE
					SPED025A->DTPGTO	:=	Self:INFCOMPL_DA:INFCOMPL_DA[nX]:DA[nI]:DTPGTO
					SPED025A->DTVCTO	:=	Self:INFCOMPL_DA:INFCOMPL_DA[nX]:DA[nI]:DTVCTO
					SPED025A->NUMDOC	:=	Self:INFCOMPL_DA:INFCOMPL_DA[nX]:DA[nI]:NUMDOC
					SPED025A->UF		:=	Self:INFCOMPL_DA:INFCOMPL_DA[nX]:DA[nI]:UF
					SPED025A->VLR		:=	Self:INFCOMPL_DA:INFCOMPL_DA[nX]:DA[nI]:VLR
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares/documentos de arrecada��o referenciados aos documentos fiscais originais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares/documentos de arrecada��o referenciados n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lCODIGO
				Self:RETORNO += "Algumas informa��es complementares/documentos de arrecada��o referenciados n�o foram cadastrados por estarem com o codigo em branco - (CODIGO). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFINFCOMPL_DFREF� Autor � Gustavo G. Rueda  � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao dos documentos fiscais referenciados���
���Descri��o �   aos documentos fiscais.                                       ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �INFCOMPL_DFREF -> Objeto com as informacoes sobre os documentos  ���
���          �       fiscais referenciados ao documento fiscal.                ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFINFCOMPL_DFREF WSRECEIVE USERTOKEN,INFCOMPL_DFREF WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lCODIGO		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:INFCOMPL_DFREF:INFCOMPL_DFREF<>Nil .And. Len(Self:INFCOMPL_DFREF:INFCOMPL_DFREF)>0
		If Self:INFCOMPL_DFREF:ID_ENT<>Nil .And. !Empty(Self:INFCOMPL_DFREF:ID_ENT)
			For nX := 1 To Len(Self:INFCOMPL_DFREF:INFCOMPL_DFREF)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:CODIGO)
					lCODIGO	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�         informacao complementar do documento fiscal          �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED026")
				cQuery := "DELETE "
				cQuery += "FROM SPED026 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_DFREF:ID_ENT,Len(SPED026->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:NFID,Len(SPED026->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//�����������������������������������������������������������������Ŀ
				//�    Documentos fiscais referenciados a informacao complementar   �
				//�No caso de regravacao, excluo as movimentacoes anteriores para   �
				//�  utilizar as novas.                                             �
				//�������������������������������������������������������������������
				dbSelectArea("SPED026A")
				cQuery := "DELETE "
				cQuery += "FROM SPED026A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_DFREF:ID_ENT,Len(SPED026A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:NFID,Len(SPED026A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED026")
				dbSetOrder(1)
				cChave	:=	PadR(Self:INFCOMPL_DFREF:ID_ENT,Len(SPED026->ID_ENT))
				cChave	+=	PadR(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:NFID,Len(SPED026->NFID))
				cChave	+=	PadR(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:CODIGO,Len(SPED026->CODIGO))
				If SPED026->(dbSeek(cChave))
					RecLock("SPED026",.F.)
				Else
					RecLock("SPED026",.T.)
				EndIf
				SPED026->ID_ENT	:=	PadR(Self:INFCOMPL_DFREF:ID_ENT,Len(SPED026->ID_ENT))
				SPED026->NFID	:=	PadR(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:NFID,Len(SPED026->NFID))
				SPED026->CODIGO	:=	PadR(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:CODIGO,Len(SPED026->CODIGO))
				SPED026->COMPL	:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:COMPL
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF)
					dbSelectArea("SPED026A")
					dbSetOrder(1)
					If SPED026A->(dbSeek(cChave))
						RecLock("SPED026A",.F.)
					Else
						RecLock("SPED026A",.T.)
					EndIf
					SPED026A->ID_ENT	:=	SPED026->ID_ENT
					SPED026A->NFID		:=	SPED026->NFID
					SPED026A->CODIGO	:=	SPED026->CODIGO
					SPED026A->DTEMIS	:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF[nI]:DTEMIS
					SPED026A->IDPART	:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF[nI]:ID_PART
					SPED026A->INDEMIT	:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF[nI]:INDEMIT	//0=EMISSAO PROPRIA, 1=TERCEIROS
					SPED026A->INDOPER	:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF[nI]:INDOPER	//0=ENTRADA/AQUISICAO, 1=SAIDA/PRESTACAO
					SPED026A->MODELO	:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF[nI]:MODELO
					SPED026A->NUMERO	:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF[nI]:NUMERO
					SPED026A->SERIE		:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF[nI]:SERIE
					SPED026A->SUBSER	:=	Self:INFCOMPL_DFREF:INFCOMPL_DFREF[nX]:DFREF[nI]:SUBSERIE
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares/documentos fiscais referenciados aos documentos fiscais originais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares/documentos fiscais referenciados n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lCODIGO
				Self:RETORNO += "Algumas informa��es complementares/documentos fiscais referenciados n�o foram cadastrados por estarem com o codigo em branco - (CODIGO). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFINFCOMPL_CFREF� Autor � Gustavo G. Rueda  � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao dos cupons fiscais referenciados    ���
���Descri��o �   aos documentos fiscais.                                       ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �INFCOMPL_CFREF -> Objeto com as informacoes sobre os cupons      ���
���          �       fiscais referenciados ao documento fiscal.                ��� 
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFINFCOMPL_CFREF WSRECEIVE USERTOKEN,INFCOMPL_CFREF WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lCODIGO		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:INFCOMPL_CFREF:INFCOMPL_CFREF<>Nil .And. Len(Self:INFCOMPL_CFREF:INFCOMPL_CFREF)>0
		If Self:INFCOMPL_CFREF:ID_ENT<>Nil .And. !Empty(Self:INFCOMPL_CFREF:ID_ENT)
			For nX := 1 To Len(Self:INFCOMPL_CFREF:INFCOMPL_CFREF)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CODIGO)
					lCODIGO	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�         informacao complementar do documento fiscal          �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED027")
				cQuery := "DELETE "
				cQuery += "FROM SPED027 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_CFREF:ID_ENT,Len(SPED027->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:NFID,Len(SPED027->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//�����������������������������������������������������������������Ŀ
				//�      Cupons fiscais referenciados a informacao complementar     �
				//�No caso de regravacao, excluo as movimentacoes anteriores para   �
				//�  utilizar as novas.                                             �
				//�������������������������������������������������������������������
				dbSelectArea("SPED027A")
				cQuery := "DELETE "
				cQuery += "FROM SPED027A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_CFREF:ID_ENT,Len(SPED027A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:NFID,Len(SPED027A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED027")
				dbSetOrder(1)
				cChave	:=	PadR(Self:INFCOMPL_CFREF:ID_ENT,Len(SPED027->ID_ENT))
				cChave	+=	PadR(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:NFID,Len(SPED027->NFID))
				cChave	+=	PadR(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CODIGO,Len(SPED027->CODIGO))
				If SPED027->(dbSeek(cChave))
					RecLock("SPED027",.F.)
				Else
					RecLock("SPED027",.T.)
				EndIf
				SPED027->ID_ENT	:=	PadR(Self:INFCOMPL_CFREF:ID_ENT,Len(SPED027->ID_ENT))
				SPED027->NFID	:=	PadR(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:NFID,Len(SPED027->NFID))
				SPED027->CODIGO	:=	PadR(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CODIGO,Len(SPED027->CODIGO))
				SPED027->COMPL	:=	Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:COMPL
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CFREF)
					dbSelectArea("SPED027A")
					dbSetOrder(1)
					If SPED027A->(dbSeek(cChave))
						RecLock("SPED027A",.F.)
					Else
						RecLock("SPED027A",.T.)
					EndIf
					SPED027A->ID_ENT	:=	SPED027->ID_ENT
					SPED027A->NFID		:=	SPED027->NFID
					SPED027A->CODIGO	:=	SPED027->CODIGO
					SPED027A->CXECF		:=	Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CFREF[nI]:CXECF
					SPED027A->DTEMIS	:=	Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CFREF[nI]:DTEMIS
					SPED027A->MODELO	:=	Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CFREF[nI]:MODELO
					SPED027A->NUMERO	:=	Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CFREF[nI]:NUMERO
					SPED027A->SERFAB	:=	Self:INFCOMPL_CFREF:INFCOMPL_CFREF[nX]:CFREF[nI]:SERFAB
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares de cupons fiscais referenciados aos documentos fiscais originais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares de cupons fiscais referenciados n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lCODIGO
				Self:RETORNO += "Algumas informa��es complementares de cupons fiscais referenciados n�o foram cadastrados por estarem com o codigo em branco - (CODIGO). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
���������������������������������������������������������������������������������Ŀ��
���Programa  �FISDFINFCOMPL_LOC_COLENT� Autor � Gustavo G. Rueda� Data �07.05.2008���
���������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes sobre os locais de  ���
���          �   coleta/entrega das mercadorias referenciadas aos documentos   ���
���          �   fiscais.                                                      ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �INFCOMPL_LOC_COLENT -> Objeto com as informacoes sobre os locais ���
���          �       de coleta/entrega das mercadorias referenciadas aos docu- ��� 
���          �       mentos fiscais.                                           ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISDFINFCOMPL_LOC_COLENT WSRECEIVE USERTOKEN,INFCOMPL_LOC_COLENT WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lCODIGO		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT<>Nil .And. Len(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT)>0
		If Self:INFCOMPL_LOC_COLENT:ID_ENT<>Nil .And. !Empty(Self:INFCOMPL_LOC_COLENT:ID_ENT)
			For nX := 1 To Len(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:CODIGO)
					lCODIGO	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�         informacao complementar do documento fiscal          �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED028")
				cQuery := "DELETE "
				cQuery += "FROM SPED028 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_LOC_COLENT:ID_ENT,Len(SPED028->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:NFID,Len(SPED028->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//�����������������������������������������������������������������Ŀ
				//� Local de coleta/entrega referenciados a informacao complementar �
				//�No caso de regravacao, excluo as movimentacoes anteriores para   �
				//�  utilizar as novas.                                             �
				//�������������������������������������������������������������������
				dbSelectArea("SPED028A")
				cQuery := "DELETE "
				cQuery += "FROM SPED028A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INFCOMPL_LOC_COLENT:ID_ENT,Len(SPED028A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:NFID,Len(SPED028A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED028")
				dbSetOrder(1)
				cChave	:=	PadR(Self:INFCOMPL_LOC_COLENT:ID_ENT,Len(SPED028->ID_ENT))
				cChave	+=	PadR(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:NFID,Len(SPED028->NFID))
				cChave	+=	PadR(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:CODIGO,Len(SPED028->CODIGO))
				If SPED028->(dbSeek(cChave))
					RecLock("SPED028",.F.)
				Else
					RecLock("SPED028",.T.)
				EndIf
				SPED028->ID_ENT	:=	PadR(Self:INFCOMPL_LOC_COLENT:ID_ENT,Len(SPED028->ID_ENT))
				SPED028->NFID	:=	PadR(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:NFID,Len(SPED028->NFID))
				SPED028->CODIGO	:=	PadR(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:CODIGO,Len(SPED028->CODIGO))
				SPED028->COMPL	:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:COMPL
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT)
					dbSelectArea("SPED028A")
					dbSetOrder(1)
					If SPED028A->(dbSeek(cChave))
						RecLock("SPED028A",.F.)
					Else
						RecLock("SPED028A",.T.)
					EndIf
					SPED028A->ID_ENT	:=	SPED028->ID_ENT
					SPED028A->NFID		:=	SPED028->NFID
					SPED028A->CODIGO	:=	SPED028->CODIGO
					SPED028A->CNPJCOL	:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:CNPJ_COL
					SPED028A->CNPJENT	:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:CNPJ_ENT
					SPED028A->CPFCOL	:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:CPF_COL
					SPED028A->CPFENT	:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:CPF_ENT
					SPED028A->CODMUNC	:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:IDMUN_COL
					SPED028A->CODMUNE	:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:IDMUN_ENT
					SPED028A->IECOL		:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:IE_COL
					SPED028A->IEENT		:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:IE_ENT
					SPED028A->TPTRANSP	:=	Self:INFCOMPL_LOC_COLENT:INFCOMPL_LOC_COLENT[nX]:LOC_COLENT[nI]:TP_TRANSP	//O=RODOVIARIO, 1=FERROVIARIO, 2=RODO-FERROVIARIO, 3=AQUAVIARIO, 4=DUTOVIARIO, 5=AEREO, 9=OUTROS
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos locais de coleta e entrega referenciados aos documentos fiscais originais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos locais de coleta e entrega referenciados n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lCODIGO
				Self:RETORNO += "Algumas informa��es complementares dos locais de coleta e entrega referenciados n�o foram cadastrados por estarem com o codigo em branco - (CODIGO). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_IT  � Autor � Gustavo G. Rueda   � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens dos documentos fiscais/conta de energia eletrica,       ���
���          �   comunicacao, telecomunicacao, agua/gas canalizado.            ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_IT -> Objeto com as informacoes complementares de itens|��
���          �       dos documentos fiscais/conta de energia eletrica, comuni- ���
���          �       cacao, telecomunicacao, agua/gas canalizado.              ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISITINFCOMPL_IT WSRECEIVE USERTOKEN,IT_INFCOMPL_IT WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT<>Nil .And. Len(Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT)>0
		If Self:IT_INFCOMPL_IT:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_IT:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�         informacao complementar do documento fiscal          �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED029")
				cQuery := "DELETE "
				cQuery += "FROM SPED029 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_IT:ID_ENT,Len(SPED029->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:NFID,Len(SPED029->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED029")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_IT:ID_ENT,Len(SPED029->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:NFID,Len(SPED029->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:NUMITE,6)
				If SPED029->(dbSeek(cChave))
					RecLock("SPED029",.F.)
				Else
					RecLock("SPED029",.T.)
				EndIf
				SPED029->ID_ENT		:=	PadR(Self:IT_INFCOMPL_IT:ID_ENT,Len(SPED029->ID_ENT))
				SPED029->NFID  		:=	PadR(Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:NFID,Len(SPED029->NFID))
				SPED029->NUMITE		:=	Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:NUMITE
				SPED029->CODCLASS	:=	Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:CODCLASS
				SPED029->IDPARTRP	:=	Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:ID_PARTREC
				SPED029->TPREC		:=	Self:IT_INFCOMPL_IT:IT_INFCOMPL_IT[nX]:TPREC
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos documentos fiscais/conta de energia eletrica, comunicacao, telecomunicacao e agua/gas canalizado foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos documentos fiscais/conta de energia eletrica, comunicacao, telecomunicacao e agua/gas canalizado n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos documentos fiscais/conta de energia eletrica, comunicacao, telecomunicacao e agua/gas canalizado n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_ARMCOMB� Autor � Gustavo G. Rueda� Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens de documentos fiscais que identifiquem operacoes com    ���
���          �   combustiveis.                                                 ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_ARMCOMB -> Objeto com as informacoes complementares de���
���          �       itens de documentos fiscais que identifiquem operacoes com���
���          �       combustiveis.                                             ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/				
WSMETHOD FISITINFCOMPL_ARMCOMB WSRECEIVE USERTOKEN,IT_INFCOMPL_ARMCOMB WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB<>Nil .And. Len(Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB)>0
		If Self:IT_INFCOMPL_ARMCOMB:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_ARMCOMB:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�          informacao complementar item combustivel            �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED030")
				cQuery := "DELETE "
				cQuery += "FROM SPED030 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_ARMCOMB:ID_ENT,Len(SPED030->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:NFID,Len(SPED030->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED030")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_ARMCOMB:ID_ENT,Len(SPED030->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:NFID,Len(SPED030->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:NUMITE,6)
				If SPED030->(dbSeek(cChave))
					RecLock("SPED030",.F.)
				Else
					RecLock("SPED030",.T.)
				EndIf
				SPED030->ID_ENT		:=	PadR(Self:IT_INFCOMPL_ARMCOMB:ID_ENT,Len(SPED030->ID_ENT))
				SPED030->NFID  		:=	PadR(Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:NFID,Len(SPED030->NFID))
				SPED030->NUMITE		:=	Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:NUMITE
				SPED030->NUMTANQ	:=	Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:NUMTANQ
				SPED030->QTDARM		:=	Self:IT_INFCOMPL_ARMCOMB:IT_INFCOMPL_ARMCOMB[nX]:QTDARM
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos itens dos documentos fiscais referentes a combust�veis foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a combust�veis n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a combust�veis n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_MEDIC� Autor � Gustavo G. Rueda  � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens de documentos fiscais que identifiquem operacoes com    ���
���          �   medicamentos.                                                 ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_MEDIC -> Objeto com as informacoes complementares  de���
���          �       itens de documentos fiscais que identifiquem operacoes com���
���          �       medicamentos.                                             ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISITINFCOMPL_MEDIC WSRECEIVE USERTOKEN,IT_INFCOMPL_MEDIC WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC<>Nil .And. Len(Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC)>0
		If Self:IT_INFCOMPL_MEDIC:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_MEDIC:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�          informacao complementar item medicamento            �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED031")
				cQuery := "DELETE "
				cQuery += "FROM SPED031 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_MEDIC:ID_ENT,Len(SPED031->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:NFID,Len(SPED031->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED031")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_MEDIC:ID_ENT,Len(SPED031->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:NFID,Len(SPED031->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:NUMITE,6)
				If SPED031->(dbSeek(cChave))
					RecLock("SPED031",.F.)
				Else
					RecLock("SPED031",.T.)
				EndIf
				SPED031->ID_ENT		:=	PadR(Self:IT_INFCOMPL_MEDIC:ID_ENT,Len(SPED031->ID_ENT))
				SPED031->NFID  		:=	PadR(Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:NFID,Len(SPED031->NFID))
				SPED031->NUMITE		:=	Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:NUMITE
				SPED031->DTFAB		:=	Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:DTFAB
				SPED031->DTVAL		:=	Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:DTVAL
				SPED031->NUMLOT		:=	Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:NUMLOT
				SPED031->PRMAXTAB	:=	Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:PRMAXTAB
				SPED031->QTDLOT		:=	Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:QTDLOT
				SPED031->TPBCICST	:=	Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:TPBCICST
				SPED031->TPMED		:=	Self:IT_INFCOMPL_MEDIC:IT_INFCOMPL_MEDIC[nX]:TPMED
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos itens dos documentos fiscais referentes a medicamentos foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a medicamentos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a medicamentos n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_ARMAS� Autor � Gustavo G. Rueda  � Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens de documentos fiscais que identifiquem operacoes com    ���
���          �   armas de fogo.                                                ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_ARMAS -> Objeto com as informacoes complementares  de���
���          �       itens de documentos fiscais que identifiquem operacoes com���
���          �       armas de fogo.                                            ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISITINFCOMPL_ARMAS WSRECEIVE USERTOKEN,IT_INFCOMPL_ARMAS WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS<>Nil .And. Len(Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS)>0
		If Self:IT_INFCOMPL_ARMAS:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_ARMAS:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�          informacao complementar item arma de fogo           �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED032")
				cQuery := "DELETE "
				cQuery += "FROM SPED032 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_ARMAS:ID_ENT,Len(SPED032->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:NFID,Len(SPED032->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED032")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_ARMAS:ID_ENT,Len(SPED032->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:NFID,Len(SPED032->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:NUMITE,6)
				If SPED032->(dbSeek(cChave))
					RecLock("SPED032",.F.)
				Else
					RecLock("SPED032",.T.)
				EndIf
				SPED032->ID_ENT		:=	PadR(Self:IT_INFCOMPL_ARMAS:ID_ENT,Len(SPED032->ID_ENT))
				SPED032->NFID  		:=	PadR(Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:NFID,Len(SPED032->NFID))
				SPED032->NUMITE		:=	Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:NUMITE
				SPED032->DESC		:=	Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:DESC
				SPED032->NUMSER		:=	Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:NUMSER
				SPED032->TPARMA		:=	Self:IT_INFCOMPL_ARMAS:IT_INFCOMPL_ARMAS[nX]:TPARMA
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos itens dos documentos fiscais referentes a armas de fogo foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a armas de fogo n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a armas de fogo n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_VEICULOS� Autor �Gustavo G. Rueda| Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens de documentos fiscais que identifiquem operacoes com    ���
���          �   veiculos novos.                                               ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_ARMAS -> Objeto com as informacoes complementares  de���
���          �       itens de documentos fiscais que identifiquem operacoes com���
���          �       veiculos novos.                                           ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISITINFCOMPL_VEICULOS WSRECEIVE USERTOKEN,IT_INFCOMPL_VEICULOS WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS<>Nil .And. Len(Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS)>0
		If Self:IT_INFCOMPL_VEICULOS:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_VEICULOS:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�          informacao complementar item veiculos novos         �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED033")
				cQuery := "DELETE "
				cQuery += "FROM SPED033 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_VEICULOS:ID_ENT,Len(SPED033->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:NFID,Len(SPED033->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED033")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_VEICULOS:ID_ENT,Len(SPED033->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:NFID,Len(SPED033->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:NUMITE,6)
				If SPED033->(dbSeek(cChave))
					RecLock("SPED033",.F.)
				Else
					RecLock("SPED033",.T.)
				EndIf
				SPED033->ID_ENT		:=	PadR(Self:IT_INFCOMPL_VEICULOS:ID_ENT,Len(SPED033->ID_ENT))
				SPED033->NFID  		:=	PadR(Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:NFID,Len(SPED033->NFID))
				SPED033->NUMITE		:=	Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:NUMITE
				SPED033->CHASSI		:=	Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:CHASSI
				SPED033->CNPJCONC	:=	Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:CNPJCONC
				SPED033->TPOPER		:=	Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:TPOPER
				SPED033->UFCONC		:=	Self:IT_INFCOMPL_VEICULOS:IT_INFCOMPL_VEICULOS[nX]:UFCONC
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos itens dos documentos fiscais referentes a ve�culos novos foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a ve�culos novos n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a ve�culos novos n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_RESSARC� Autor �Gustavo G. Rueda | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens de documentos fiscais que identifiquem ressarcimento    ���
���          �   de ICMS em operacoes de ST.                                   ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_ARMAS -> Objeto com as informacoes complementares  de���
���          �       itens de documentos fiscais que identifiquem ressarcimento���
���          �       de ICMS em operacoes de ST.                               ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISITINFCOMPL_RESSARC WSRECEIVE USERTOKEN,IT_INFCOMPL_RESSARC WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC<>Nil .And. Len(Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC)>0
		If Self:IT_INFCOMPL_RESSARC:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_RESSARC:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�          informacao complementar item ressarcimento          �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED034")
				cQuery := "DELETE "
				cQuery += "FROM SPED034 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_RESSARC:ID_ENT,Len(SPED034->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:NFID,Len(SPED034->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED034")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_RESSARC:ID_ENT,Len(SPED034->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:NFID,Len(SPED034->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:NUMITE,6)
				If SPED034->(dbSeek(cChave))
					RecLock("SPED034",.F.)
				Else
					RecLock("SPED034",.T.)
				EndIf
				SPED034->ID_ENT		:=	PadR(Self:IT_INFCOMPL_RESSARC:ID_ENT,Len(SPED034->ID_ENT))
				SPED034->NFID  		:=	PadR(Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:NFID,Len(SPED034->NFID))
				SPED034->NUMITE		:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:NUMITE
				SPED034->BASEST		:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:BASEST
				SPED034->DTULTENT	:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:DTULTENT
				SPED034->IDPART		:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:ID_PART
				SPED034->MODELO		:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:MODELO
				SPED034->NUMERO		:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:NUMERO
				SPED034->QTD		:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:QTD
				SPED034->SERIE		:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:SERIE
				SPED034->VLRUNIT	:=	Self:IT_INFCOMPL_RESSARC:IT_INFCOMPL_RESSARC[nX]:VLRUNIT
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos itens dos documentos fiscais referentes ressarcimento de ICMS em opera��es de ST foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a ressarcimento de ICMS em opera��es de ST n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a ressarcimento de ICMS em opera��es de ST n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_SELO � Autor �Gustavo G. Rueda   | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens de documentos fiscais que identifiquem operacoes com    ���
���          �   produtos sujeitos ao selo de controle.                        ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_ARMAS -> Objeto com as informacoes complementares  de���
���          �       itens de documentos fiscais que identifiquem operacoes com���
���          �       produtos sujeitos ao selo de controle.                    ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISITINFCOMPL_SELO WSRECEIVE USERTOKEN,IT_INFCOMPL_SELO WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO<>Nil .And. Len(Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO)>0
		If Self:IT_INFCOMPL_SELO:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_SELO:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�   informacao complementar item sujeito ao selo de controle   �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED035")
				cQuery := "DELETE "
				cQuery += "FROM SPED035 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_SELO:ID_ENT,Len(SPED035->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:NFID,Len(SPED035->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED035")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_SELO:ID_ENT,Len(SPED035->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:NFID,Len(SPED035->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:NUMITE,6)
				If SPED035->(dbSeek(cChave))
					RecLock("SPED035",.F.)
				Else
					RecLock("SPED035",.T.)
				EndIf
				SPED035->ID_ENT		:=	PadR(Self:IT_INFCOMPL_SELO:ID_ENT,Len(SPED035->ID_ENT))
				SPED035->NFID  		:=	PadR(Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:NFID,Len(SPED035->NFID))
				SPED035->NUMITE		:=	Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:NUMITE
				SPED035->CODSELO	:=	Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:CODSELO
				SPED035->QTD		:=	Self:IT_INFCOMPL_SELO:IT_INFCOMPL_SELO[nX]:QTD
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos itens dos documentos fiscais referentes produtos sujeitos ao selo de controle foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a produtos sujeitos ao selo de controle n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a produtos sujeitos ao selo de controle n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_IPI  � Autor �Gustavo G. Rueda   | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens de documentos fiscais que identifiquem operacoes com    ���
���          �   produtos sujeitos a tributacao do IPI.                        ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_ARMAS -> Objeto com as informacoes complementares  de���
���          �       itens de documentos fiscais que identifiquem operacoes com���
���          �       produtos sujeitos a tributacao do IPI.                    ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISITINFCOMPL_IPI WSRECEIVE USERTOKEN,IT_INFCOMPL_IPI WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI<>Nil .And. Len(Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI)>0
		If Self:IT_INFCOMPL_IPI:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_IPI:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�   informacao complementar item sujeito a tributacao do IPI   �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED036")
				cQuery := "DELETE "
				cQuery += "FROM SPED036 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_IPI:ID_ENT,Len(SPED036->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:NFID,Len(SPED036->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED036")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_IPI:ID_ENT,Len(SPED036->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:NFID,Len(SPED036->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:NUMITE,6)
				If SPED036->(dbSeek(cChave))
					RecLock("SPED036",.F.)
				Else
					RecLock("SPED036",.T.)
				EndIf
				SPED036->ID_ENT		:=	PadR(Self:IT_INFCOMPL_IPI:ID_ENT,Len(SPED036->ID_ENT))
				SPED036->NFID  		:=	PadR(Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:NFID,Len(SPED036->NFID))
				SPED036->NUMITE		:=	Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:NUMITE
				SPED036->CLASSENQ	:=	Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:CLASSENQ
				SPED036->QTD		:=	Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:QTD
				SPED036->VLR		:=	Self:IT_INFCOMPL_IPI:IT_INFCOMPL_IPI[nX]:VLR
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos itens dos documentos fiscais referentes produtos sujeitos ao IPI foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a produtos sujeitos ao IPI n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a produtos sujeitos ao IPI n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISITINFCOMPL_ST   � Autor �Gustavo G. Rueda   | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes complementares de   ���
���          �   itens de documentos fiscais que identifiquem operacoes com    ���
���          �   ST.                                                           ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �IT_INFCOMPL_ARMAS -> Objeto com as informacoes complementares  de���
���          �       itens de documentos fiscais que identifiquem operacoes com���
���          �       ST.                                                       ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISITINFCOMPL_ST WSRECEIVE USERTOKEN,IT_INFCOMPL_ST WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lNUMITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST<>Nil .And. Len(Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST)>0
		If Self:IT_INFCOMPL_ST:ID_ENT<>Nil .And. !Empty(Self:IT_INFCOMPL_ST:ID_ENT)
			For nX := 1 To Len(Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:NUMITE==0
					lNUMITE	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�         informacao complementar item sujeito a ST            �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED037")
				cQuery := "DELETE "
				cQuery += "FROM SPED037 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:IT_INFCOMPL_ST:ID_ENT,Len(SPED037->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:NFID,Len(SPED037->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED037")
				dbSetOrder(1)
				cChave	:=	PadR(Self:IT_INFCOMPL_ST:ID_ENT,Len(SPED037->ID_ENT))
				cChave	+=	PadR(Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:NFID,Len(SPED037->NFID))
				cChave	+=	Str(Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:NUMITE,6)
				If SPED037->(dbSeek(cChave))
					RecLock("SPED037",.F.)
				Else
					RecLock("SPED037",.T.)
				EndIf
				SPED037->ID_ENT		:=	PadR(Self:IT_INFCOMPL_ST:ID_ENT,Len(SPED037->ID_ENT))
				SPED037->NFID  		:=	PadR(Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:NFID,Len(SPED037->NFID))
				SPED037->NUMITE		:=	Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:NUMITE
				SPED037->BCORID		:=	Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:BCORIDEST
				SPED037->BCRET		:=	Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:BCRET
				SPED037->VLRCOMPL	:=	Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:VLRCOMPL
				SPED037->VLRREP		:=	Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:VLRREPDED
				SPED037->VLRRET		:=	Self:IT_INFCOMPL_ST:IT_INFCOMPL_ST[nX]:VLRRET
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es complementares dos itens dos documentos fiscais referentes a substitui��o tribut�ria foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a substitui��o tribut�ria n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lNUMITE
				Self:RETORNO += "Algumas informa��es complementares dos itens dos documentos fiscais referentes a substitui��o tribut�ria n�o foram cadastrados por estarem com o n�mero do item sem referencia ao item do documento fiscal - (NUMITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FIS_RMD             � Autor � Gustavo G. Rueda | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes sobre o resumo de   ���
���          �   movimento diario.                                             ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �RMD -> Objeto com as informacoes sobre o resumo de movimento     ���
���          �       diario.                                                   ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FIS_RMD WSRECEIVE USERTOKEN,RMD WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lID_PART	:=	.F.
Local	lNUMITE		:=	.F.
Local	lMODELO		:=	.F.
Local	lITEM		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:RMD:RMD<>Nil .And. Len(Self:RMD:RMD)>0
		If Self:RMD:ID_ENT<>Nil .And. !Empty(Self:RMD:ID_ENT)
			For nX := 1 To Len(Self:RMD:RMD)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:RMD:RMD[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:RMD:RMD[nX]:ID_PART)
					lID_PART := .T.
					Loop
				EndIf
				If Empty(Self:RMD:RMD[nX]:MODELO)
					lMODELO := .T.
					Loop
				EndIf
				If Self:RMD:RMD[nX]:ITEM==Nil .Or. Len(Self:RMD:RMD[nX]:ITEM)==0
					lITEM := .T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                informacao complementar do RMD                �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED038")
				cQuery := "DELETE "
				cQuery += "FROM SPED038 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:RMD:ID_ENT,Len(SPED038->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:RMD:RMD[nX]:NFID,Len(SPED038->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//�����������������������������������������������������������������Ŀ
				//�               Item(s) referenciado(s) ao RMD                    �
				//�No caso de regravacao, excluo as movimentacoes anteriores para   �
				//�  utilizar as novas.                                             �
				//�������������������������������������������������������������������
				dbSelectArea("SPED038A")
				cQuery := "DELETE "
				cQuery += "FROM SPED038A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:RMD:ID_ENT,Len(SPED038A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:RMD:RMD[nX]:NFID,Len(SPED038A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED038")
				dbSetOrder(1)
				cChave	:=	PadR(Self:RMD:ID_ENT,Len(SPED038->ID_ENT))
				cChave	+=	PadR(Self:RMD:RMD[nX]:NFID,Len(SPED038->NFID))
				If SPED038->(dbSeek(cChave))
					RecLock("SPED038",.F.)
				Else
					RecLock("SPED038",.T.)
				EndIf
				SPED038->ID_ENT		:=	PadR(Self:RMD:ID_ENT,Len(SPED038->ID_ENT))
				SPED038->NFID		:=	PadR(Self:RMD:RMD[nX]:NFID,Len(SPED038->NFID))
				SPED038->CODMUNO	:=	Self:RMD:RMD[nX]:CODMUNORI
				SPED038->CTACONT	:=	Self:RMD:RMD[nX]:CTACONTABIL
				SPED038->DTEMIS		:=	Self:RMD:RMD[nX]:DTEMIS
				SPED038->IDPART		:=	Self:RMD:RMD[nX]:ID_PART
				SPED038->MODELO		:=	Self:RMD:RMD[nX]:MODELO
				SPED038->NUMERO		:=	Self:RMD:RMD[nX]:NUMERO
				SPED038->SERIE 		:=	Self:RMD:RMD[nX]:SERIE
				SPED038->SITUAC		:=	Self:RMD:RMD[nX]:SITUACAO
				SPED038->SUBSER		:=	Self:RMD:RMD[nX]:SUBSERIE
				SPED038->VLRDESC	:=	Self:RMD:RMD[nX]:VLRDESC
				SPED038->VLRPREST	:=	Self:RMD:RMD[nX]:VLRPRESERV
				SPED038->VLRTOTAL	:=	Self:RMD:RMD[nX]:VLRTOTAL
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:RMD:RMD[nX]:ITEM)
					//�����������������������������������������������������������������������������Ŀ
					//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
					//�������������������������������������������������������������������������������
					If Self:RMD:RMD[nX]:ITEM[nI]:NUMITE==0
						lNUMITE	:=	.T.
						Loop
					EndIf
					
					dbSelectArea("SPED038A")
					dbSetOrder(1)
					cChave	:=	SPED038->ID_ENT
					cChave	+=	SPED038->NFID
					cChave	+=	Str(Self:RMD:RMD[nX]:ITEM[nI]:NUMITE,6)
					If SPED038A->(dbSeek(cChave))
						RecLock("SPED038A",.F.)
					Else
						RecLock("SPED038A",.T.)
					EndIf
					SPED038A->ID_ENT	:=	SPED038->ID_ENT
					SPED038A->NFID		:=	SPED038->NFID
					SPED038A->NUMITE	:=	Self:RMD:RMD[nX]:ITEM[nI]:NUMITE
					SPED038A->CFOP		:=	Self:RMD:RMD[nX]:ITEM[nI]:CFOP
					SPED038A->DTEMIS	:=	Self:RMD:RMD[nX]:ITEM[nI]:DTEMIS
					SPED038A->MODELO	:=	Self:RMD:RMD[nX]:ITEM[nI]:MODELO
					SPED038A->NUMERO	:=	Self:RMD:RMD[nX]:ITEM[nI]:NUMERO
					SPED038A->SERIE 	:=	Self:RMD:RMD[nX]:ITEM[nI]:SERIE
					SPED038A->SITUAC	:=	Self:RMD:RMD[nX]:ITEM[nI]:SITUACAO
					SPED038A->SUBSER	:=	Self:RMD:RMD[nX]:ITEM[nI]:SUBSERIE
					SPED038A->VLRDESC	:=	Self:RMD:RMD[nX]:ITEM[nI]:VLRDESC
					SPED038A->VLRPREST	:=	Self:RMD:RMD[nX]:ITEM[nI]:VLRPRESERV
					SPED038A->VLRTOTAL	:=	Self:RMD:RMD[nX]:ITEM[nI]:VLRTOTAL
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os documentos fiscais foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns documentos fiscais n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lID_PART
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com o ID do participante em branco - (ID_PART). "
			EndIf
			If lMODELO
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com o c�digo de mod�lo em branco - (MODELO). "
			EndIf
			If lNUMITE
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem com o n�mero do item em branco - (NUMITE). "
			EndIf
			If lITEM
				Self:RETORNO	+=	"Alguns documentos fiscais n�o foram enviados por estarem sem item(s) relacionado(s) - (RMD/ITEM). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISECF_ECF          � Autor � Gustavo G. Rueda | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao informacoes de cupom fiscal emitidos���
���          � por estabelecimentos com equipamento ECF                        ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �ECF -> Objeto com as informacoes de cupom fiscal emitidos por    ���
���          �       estabelecimentos com equipamento ECF                      ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISECF_ECF WSRECEIVE USERTOKEN,ECF WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lCAIXA		:=	.F.
Local	lMODELO		:=	.F.
Local	lREDZ		:=	.F.
Local	lDTRED		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:ECF:ECF<>Nil .And. Len(Self:ECF:ECF)>0
		If !Empty(Self:ECF:ID_ENT)
			For nX := 1 To Len(Self:ECF:ECF)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:ECF:ECF[nX]:CAIXA)
					lCAIXA	:=	.T.
					Loop
				EndIf
				If Empty(Self:ECF:ECF[nX]:MODELO)
					lMODELO := .T.
					Loop
				EndIf
				If Self:ECF:ECF[nX]:REDZ==Nil .Or. Len(Self:ECF:ECF[nX]:REDZ)==0
					lREDZ := .T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                informacao complementar do ECF                �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED039")
				cQuery := "DELETE "
				cQuery += "FROM SPED039 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:ECF:ID_ENT,Len(SPED039->ID_ENT))+"' AND "
				cQuery += "CAIXA="+Str(Self:ECF:ECF[nX]:CAIXA,10)+""
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//�����������������������������������������������������������������Ŀ
				//�               REDZ(s) referenciado(s) ao ECF                    �
				//�No caso de regravacao, excluo as movimentacoes anteriores para   �
				//�  utilizar as novas.                                             �
				//�������������������������������������������������������������������
				dbSelectArea("SPED039A")
				cQuery := "DELETE "
				cQuery += "FROM SPED039A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:ECF:ID_ENT,Len(SPED039A->ID_ENT))+"' AND "
				cQuery += "CAIXA="+Str(Self:ECF:ECF[nX]:CAIXA,10)+""
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED039")
				dbSetOrder(1)
				cChave	:=	PadR(Self:ECF:ID_ENT,Len(SPED039->ID_ENT))
				cChave	+=	Str(Self:ECF:ECF[nX]:CAIXA,10)
				If SPED039->(dbSeek(cChave))
					RecLock("SPED039",.F.)
				Else
					RecLock("SPED039",.T.)
				EndIf
				SPED039->ID_ENT		:=	PadR(Self:ECF:ID_ENT,Len(SPED039->ID_ENT))
				SPED039->CAIXA		:=	Self:ECF:ECF[nX]:CAIXA
				SPED039->MODECF		:=	Self:ECF:ECF[nX]:MODECF
				SPED039->MODELO		:=	Self:ECF:ECF[nX]:MODELO
				SPED039->SERFAB		:=	Self:ECF:ECF[nX]:SERFAB
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:ECF:ECF[nX]:REDZ)
					//�����������������������������������������������������������������������������Ŀ
					//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
					//�������������������������������������������������������������������������������
					If Empty(Self:ECF:ECF[nX]:REDZ[nI]:DTRED)
						lDTRED	:=	.T.
						Loop
					EndIf
					
					dbSelectArea("SPED039A")
					dbSetOrder(1)
					cChave	:=	SPED039->ID_ENT
					cChave	+=	Str(SPED039->CAIXA,10)
					cChave	+=	DToS(Self:ECF:ECF[nX]:REDZ[nI]:DTRED)
					If SPED039A->(dbSeek(cChave))
						RecLock("SPED039A",.F.)
					Else
						RecLock("SPED039A",.T.)
					EndIf
					SPED039A->ID_ENT	:=	SPED039->ID_ENT
					SPED039A->CAIXA		:=	SPED039->CAIXA
					SPED039A->COOFIM	:=	Self:ECF:ECF[nX]:REDZ[nI]:COOFIM
					SPED039A->CRO  		:=	Self:ECF:ECF[nX]:REDZ[nI]:CRO
					SPED039A->CRZ  		:=	Self:ECF:ECF[nX]:REDZ[nI]:CRZ
					SPED039A->DTRED		:=	Self:ECF:ECF[nX]:REDZ[nI]:DTRED
					SPED039A->GTFIM 	:=	Self:ECF:ECF[nX]:REDZ[nI]:GTFIM
					SPED039A->VLRBRUT	:=	Self:ECF:ECF[nX]:REDZ[nI]:VLRBRUT
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es do ECF foram cadastradas com sucesso. "
			EndIf
			If lCAIXA
				Self:RETORNO += "Alguns ECFs n�o foram enviadas por estarem com o n�mero do caixa em branco - (CAIXA). "
			EndIf
			If lMODELO
				Self:RETORNO	+=	"Alguns ECFs n�o foram enviados por estarem com o c�digo de mod�lo em branco - (MODELO). "
			EndIf
			If lREDZ
				Self:RETORNO	+=	"Alguns ECFs n�o foram enviados por estarem sem as informa��es da Redu��o Z - (ECF/REDZ). "
			EndIf
			If lDTRED
				Self:RETORNO	+=	"Alguns ECFs n�o foram enviados por estarem sem a data da Redu��o Z - (DTRED). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISECF_TOTREDZ      � Autor � Gustavo G. Rueda | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao informacoes sobre as totalizacoes   ���
���          � parciais da reducao Z e seu itens comercializados               ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �ECF -> Objeto com as informacoes das totalizacoes parciais de re-���
���          �       ducao Z e seus itens comercializados.                     ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISECF_TOTREDZ WSRECEIVE USERTOKEN,TOTREDZ WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lCXID		:=	.F.
Local	lCAIXA		:=	.F.
Local	lIT_ECF		:=	.F.
Local	lNUMSEQ		:=	.F.
Local	lCODITE		:=	.F.
Local	lUM			:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:TOTREDZ:TOTREDZ<>Nil .And. Len(Self:TOTREDZ:TOTREDZ)>0
		If !Empty(Self:TOTREDZ:ID_ENT)
			For nX := 1 To Len(Self:TOTREDZ:TOTREDZ)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:TOTREDZ:TOTREDZ[nX]:CXID)
					lCXID := .T.
					Loop
				EndIf
				If Empty(Self:TOTREDZ:TOTREDZ[nX]:CAIXA)
					lCAIXA	:=	.T.
					Loop
				EndIf
				If Self:TOTREDZ:TOTREDZ[nX]:IT_ECF==Nil .Or. Len(Self:TOTREDZ:TOTREDZ[nX]:IT_ECF)==0
					lIT_ECF := .T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�      informacao complementar do totalizador da reducao Z     �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED040")
				cQuery := "DELETE "
				cQuery += "FROM SPED040 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:TOTREDZ:ID_ENT,Len(SPED040->ID_ENT))+"' AND "
				cQuery += "CXID='"+PadR(Self:TOTREDZ:TOTREDZ[nX]:CXID,Len(SPED040->CXID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//�����������������������������������������������������������������Ŀ
				//�                   Itens movimentados no dia                     �
				//�No caso de regravacao, excluo as movimentacoes anteriores para   �
				//�  utilizar as novas.                                             �
				//�������������������������������������������������������������������
				dbSelectArea("SPED040A")
				cQuery := "DELETE "
				cQuery += "FROM SPED040A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:TOTREDZ:ID_ENT,Len(SPED040A->ID_ENT))+"' AND "
				cQuery += "CXID='"+PadR(Self:TOTREDZ:TOTREDZ[nX]:CXID,Len(SPED040A->CXID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED040")
				dbSetOrder(1)
				cChave	:=	PadR(Self:TOTREDZ:ID_ENT,Len(SPED040->ID_ENT))
				cChave	+=	PadR(Self:TOTREDZ:TOTREDZ[nX]:CXID,Len(SPED040->CXID))
				If SPED040->(dbSeek(cChave))
					RecLock("SPED040",.F.)
				Else
					RecLock("SPED040",.T.)
				EndIf
				SPED040->ID_ENT		:=	PadR(Self:TOTREDZ:ID_ENT,Len(SPED040->ID_ENT))
				SPED040->CXID		:=	PadR(Self:TOTREDZ:TOTREDZ[nX]:CXID,Len(SPED040->CXID))
				SPED040->CAIXA		:=	Self:TOTREDZ:TOTREDZ[nX]:CAIXA
				SPED040->CODTOT		:=	Self:TOTREDZ:TOTREDZ[nX]:CODTOT
				SPED040->DESC		:=	Self:TOTREDZ:TOTREDZ[nX]:DESC
				SPED040->DTRED		:=	Self:TOTREDZ:TOTREDZ[nX]:DTRED	
				SPED040->SEQ		:=	Self:TOTREDZ:TOTREDZ[nX]:SEQ
				SPED040->VLRACTOT	:=	Self:TOTREDZ:TOTREDZ[nX]:VLRACTOT
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:TOTREDZ:TOTREDZ[nX]:IT_ECF)
					//�����������������������������������������������������������������������������Ŀ
					//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
					//�������������������������������������������������������������������������������
					If Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:NUMSEQ==0
						lNUMSEQ	:=	.T.
						Loop
					EndIf
					If Empty(Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:CODITE)
						lCODITE	:=	.T.
						Loop
					EndIf
					If Empty(Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:UM)
						lUM	:=	.T.
						Loop
					EndIf
					
					dbSelectArea("SPED040A")
					dbSetOrder(1)
					cChave	:=	SPED040->ID_ENT
					cChave	+=	SPED040->CXID
					cChave	+=	Str(Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:NUMSEQ,6)
					If SPED040A->(dbSeek(cChave))
						RecLock("SPED040A",.F.)
					Else
						RecLock("SPED040A",.T.)
					EndIf
					SPED040A->ID_ENT	:=	SPED040->ID_ENT
					SPED040A->CXID		:=	SPED040->CXID
					SPED040A->NUMSEQ 	:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:NUMSEQ
					SPED040A->CODITE	:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:CODITE
					SPED040A->MUNORI	:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:MUNORI
					SPED040A->QTD  		:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:QTD
					SPED040A->QTDCANC	:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:QTDCANC
					SPED040A->UM 		:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:UM
					SPED040A->VLR		:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:VLR
					SPED040A->VLRACR	:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:VLRACR
					SPED040A->VLRCANC	:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:VLRCANC
					SPED040A->VLRDESC	:=	Self:TOTREDZ:TOTREDZ[nX]:IT_ECF[nI]:VLRDESC
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todas as informa��es sobre os totalizadores parciais da redu��o Z foram cadastrados com sucesso. "
			EndIf
			If lCXID
				Self:RETORNO += "Alguns totalizadores parciais da redu��o Z n�o foram enviados por estarem com o ID do documento em branco - (CXID). "
			EndIf
			If lCAIXA
				Self:RETORNO += "Alguns totalizadores parciais da redu��o Z n�o foram enviados por estarem com o n�mero do caixa em branco - (CAIXA). "
			EndIf
			If lIT_ECF
				Self:RETORNO += "Alguns totalizadores parciais da redu��o Z n�o foram enviados por estarem sem item(s) movimentado(s) no dia - (TOTREDZ/IT_ECF). "
			EndIf
			If lNUMSEQ
				Self:RETORNO += "Alguns totalizadores parciais da redu��o Z n�o foram enviados por estarem com o n�mero sequencial zerado - (NUMSEQ). "
			EndIf
			If lCODITE
				Self:RETORNO += "Alguns totalizadores parciais da redu��o Z n�o foram enviados por estarem com o c�digo do item em branco - (CODITE). "
			EndIf
			If lUM
				Self:RETORNO += "Alguns totalizadores parciais da redu��o Z n�o foram enviados por estarem com a unidade de medida em branco - (UM). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FISECF_DOCECF       � Autor � Gustavo G. Rueda | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao informacoes sobre os documentos fis-���
���          � cais emitidos por ECF (bilhetes de passagem)                    ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �ECF -> Objeto com as informacoes sobre os documentos fiscais     ���
���          �       emitidos por ECF (bilhetes de passagem)                   ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FISECF_DOCECF WSRECEIVE USERTOKEN,DOCECF WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lCAIXA		:=	.F.
Local	lDTEMIS		:=	.F.
Local	lMODELO		:=	.F.
Local	lIT_ECF		:=	.F.
Local	lNUMSEQ		:=	.F.
Local	lCODITE		:=	.F.
Local	lUM			:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:DOCECF:DOCECF<>Nil .And. Len(Self:DOCECF:DOCECF)>0
		If !Empty(Self:DOCECF:ID_ENT)
			For nX := 1 To Len(Self:DOCECF:DOCECF)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:DOCECF:DOCECF[nX]:NFID)
					lNFID := .T.
					Loop
				EndIf
				If Empty(Self:DOCECF:DOCECF[nX]:CAIXA)
					lCAIXA	:=	.T.
					Loop
				EndIf
				If Empty(Self:DOCECF:DOCECF[nX]:DTEMIS)
					lDTEMIS	:=	.T.
					Loop
				EndIf
				If Empty(Self:DOCECF:DOCECF[nX]:MODELO)
					lMODELO := .T.
					Loop
				EndIf
				If Self:DOCECF:DOCECF[nX]:IT_ECF==Nil .Or. Len(Self:DOCECF:DOCECF[nX]:IT_ECF)==0
					lIT_ECF := .T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�      informacao sobre os documentos emitidos por ECF         �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED041")
				cQuery := "DELETE "
				cQuery += "FROM SPED041 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:DOCECF:ID_ENT,Len(SPED041->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:DOCECF:DOCECF[nX]:NFID,Len(SPED041->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//�����������������������������������������������������������������Ŀ
				//�                   Itens movimentados no dia                     �
				//�No caso de regravacao, excluo as movimentacoes anteriores para   �
				//�  utilizar as novas.                                             �
				//�������������������������������������������������������������������
				dbSelectArea("SPED041A")
				cQuery := "DELETE "
				cQuery += "FROM SPED041A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:DOCECF:ID_ENT,Len(SPED041A->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:DOCECF:DOCECF[nX]:NFID,Len(SPED041A->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED041")
				dbSetOrder(1)
				cChave	:=	PadR(Self:DOCECF:ID_ENT,Len(SPED041->ID_ENT))
				cChave	+=	PadR(Self:DOCECF:DOCECF[nX]:NFID,Len(SPED041->NFID))
				If SPED041->(dbSeek(cChave))
					RecLock("SPED041",.F.)
				Else
					RecLock("SPED041",.T.)
				EndIf
				SPED041->ID_ENT		:=	PadR(Self:DOCECF:ID_ENT,Len(SPED041->ID_ENT))
				SPED041->NFID		:=	PadR(Self:DOCECF:DOCECF[nX]:NFID,Len(SPED041->NFID))
				SPED041->CAIXA		:=	Self:DOCECF:DOCECF[nX]:CAIXA
				SPED041->DTEMIS		:=	Self:DOCECF:DOCECF[nX]:DTEMIS
				SPED041->MODELO		:=	Self:DOCECF:DOCECF[nX]:MODELO
				SPED041->NUMERO		:=	Self:DOCECF:DOCECF[nX]:NUMERO	
				SPED041->SERIE		:=	Self:DOCECF:DOCECF[nX]:SERIE
				SPED041->SITUAC		:=	Self:DOCECF:DOCECF[nX]:SITUACAO
				SPED041->SUBSER		:=	Self:DOCECF:DOCECF[nX]:SUBSERIE
				MsUnLock()
				FkCommit()
                          
				For nI := 1 To Len(Self:DOCECF:DOCECF[nX]:IT_ECF)
					//�����������������������������������������������������������������������������Ŀ
					//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
					//�������������������������������������������������������������������������������
					If Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:NUMSEQ==0
						lNUMSEQ	:=	.T.
						Loop
					EndIf
					If Empty(Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:CODITE)
						lCODITE	:=	.T.
						Loop
					EndIf
					If Empty(Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:UM)
						lUM	:=	.T.
						Loop
					EndIf
					
					dbSelectArea("SPED041A")
					dbSetOrder(1)
					cChave	:=	SPED041->ID_ENT
					cChave	+=	SPED041->NFID
					cChave	+=	Str(Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:NUMSEQ,6)
					If SPED041A->(dbSeek(cChave))
						RecLock("SPED041A",.F.)
					Else
						RecLock("SPED041A",.T.)
					EndIf
					SPED041A->ID_ENT	:=	SPED041->ID_ENT
					SPED041A->NFID		:=	SPED041->NFID
					SPED041A->NUMSEQ 	:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:NUMSEQ
					SPED041A->CFOP 		:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:CFOP
					SPED041A->CODITE	:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:CODITE
					SPED041A->CODOBS 	:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:CODOBS
					SPED041A->QTD  		:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:QTD
					SPED041A->QTDCANC	:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:QTDCANC
					SPED041A->UM 		:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:UM
					SPED041A->VLR		:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:VLR
					SPED041A->VLRACR	:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:VLRACR
					SPED041A->VLRCANC	:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:VLRCANC
					SPED041A->VLRDESC	:=	Self:DOCECF:DOCECF[nX]:IT_ECF[nI]:VLRDESC
					MsUnLock()
					FkCommit()
				Next nI

				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os documentos fiscais emitidos por ECF foram cadastrados com sucesso. "
			EndIf
			If lNFID
				Self:RETORNO += "Alguns documentos fiscais emitidos por ECF n�o foram enviados por estarem com o ID do documento em branco - (NFID). "
			EndIf
			If lCAIXA
				Self:RETORNO += "Alguns documentos fiscais emitidos por ECF n�o foram enviados por estarem com o n�mero do caixa em branco - (CAIXA). "
			EndIf
			If lDTEMIS
				Self:RETORNO += "Alguns documentos fiscais emitidos por ECF n�o foram enviados por estarem com a data de emissao em branco - (DTEMIS). "
			EndIf
			If lMODELO
				Self:RETORNO += "Alguns documentos fiscais emitidos por ECF n�o foram enviados por estarem com o modelo em branco - (MODELO). "
			EndIf
			If lIT_ECF
				Self:RETORNO += "Alguns documentos fiscais emitidos por ECF n�o foram enviados por estarem sem item(s) movimentado(s) no dia - (DOCECF/IT_ECF). "
			EndIf
			If lNUMSEQ
				Self:RETORNO += "Alguns documentos fiscais emitidos por ECF n�o foram enviados por estarem com o n�mero sequencial zerado - (NUMSEQ). "
			EndIf
			If lCODITE
				Self:RETORNO += "Alguns documentos fiscais emitidos por ECF n�o foram enviados por estarem com o c�digo do item em branco - (CODITE). "
			EndIf
			If lUM
				Self:RETORNO += "Alguns documentos fiscais emitidos por ECF n�o foram enviados por estarem com a unidade de medida em branco - (UM). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FIS_BILPASS         � Autor � Gustavo G. Rueda | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao informacoes sobre os bilhetes de    ���
���          � passagens emitidos por ECF                                      ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �ECF -> Objeto com as informacoes sobre os bilhetes de passagens  ���
���          �       emitidos por ECF                                          ���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FIS_BILPASS WSRECEIVE USERTOKEN,BILPASS WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	cChave		:=	""
Local	lNFID		:=	.F.
Local	lMODELO		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:BILPASS:BILPASS<>Nil .And. Len(Self:BILPASS:BILPASS)>0
		If Self:BILPASS:ID_ENT<>Nil .And. !Empty(Self:BILPASS:ID_ENT)
			For nX := 1 To Len(Self:BILPASS:BILPASS)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:BILPASS:BILPASS[nX]:NFID)
					lNFID	:=	.T.
					Loop
				EndIf
				If Empty(Self:BILPASS:BILPASS[nX]:MODELO)
					lMODELO := .T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�         informacao sobre os bilhetes de passagem             �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED042")
				cQuery := "DELETE "
				cQuery += "FROM SPED042 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:BILPASS:ID_ENT,Len(SPED042->ID_ENT))+"' AND "
				cQuery += "NFID='"+PadR(Self:BILPASS:BILPASS[nX]:NFID,Len(SPED042->NFID))+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED042")
				dbSetOrder(1)
				cChave	:=	PadR(Self:BILPASS:ID_ENT,Len(SPED042->ID_ENT))
				cChave	+=	PadR(Self:BILPASS:BILPASS[nX]:NFID,Len(SPED042->NFID))
				If SPED042->(dbSeek(cChave))
					RecLock("SPED042",.F.)
				Else
					RecLock("SPED042",.T.)
				EndIf
				SPED042->ID_ENT		:=	PadR(Self:BILPASS:ID_ENT,Len(SPED042->ID_ENT))
				SPED042->NFID  		:=	PadR(Self:BILPASS:BILPASS[nX]:NFID,Len(SPED042->NFID))
				SPED042->CFOP		:=	Self:BILPASS:BILPASS[nX]:CFOP
				SPED042->CODMUNO	:=	Self:BILPASS:BILPASS[nX]:CODMUNORI
				SPED042->CODOBS		:=	Self:BILPASS:BILPASS[nX]:CODOBS
				SPED042->CTACONT	:=	Self:BILPASS:BILPASS[nX]:CTACONTABIL
				SPED042->DTEMIS		:=	Self:BILPASS:BILPASS[nX]:DTEMIS
				SPED042->MODELO		:=	Self:BILPASS:BILPASS[nX]:MODELO
				SPED042->NUMERO		:=	Self:BILPASS:BILPASS[nX]:NUMERO
				SPED042->SERIE		:=	Self:BILPASS:BILPASS[nX]:SERIE
				SPED042->SITUAC		:=	Self:BILPASS:BILPASS[nX]:SITUACAO
				SPED042->SUBSER		:=	Self:BILPASS:BILPASS[nX]:SUBSERIE
				SPED042->VLRDESC	:=	Self:BILPASS:BILPASS[nX]:VLRDESC
				SPED042->VLRDESP	:=	Self:BILPASS:BILPASS[nX]:VLRDESP
				SPED042->VLRSERV	:=	Self:BILPASS:BILPASS[nX]:VLRPRSERV
				SPED042->VLRSEG		:=	Self:BILPASS:BILPASS[nX]:VLRSEG
				SPED042->VLRTOTAL	:=	Self:BILPASS:BILPASS[nX]:VLRTOTAL
				MsUnLock()
				FkCommit()
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos os bilhetes de passagens foram cadastrados com sucesso. "
			EndIf			
			If lNFID
				Self:RETORNO += "Alguns os bilhetes de passagens n�o foram cadastrados por estarem com o ID do documento fiscal em branco - (NFID). "
			EndIf
			If lMODELO
				Self:RETORNO += "Alguns os bilhetes de passagens n�o foram cadastrados por estarem com o modelo em branco - (MODELO). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Programa  �FIS_INV             � Autor � Gustavo G. Rueda | Data �07.05.2008���
������������������������������������������������������������������������������Ĵ��
���Descri��o �Metodo de inclus�o/alteracao das informacoes de inventario       ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �lRetorno -> .T. para processamento efetuado com sucesso, ou .F.  ���
���          � para o contrario.                                               ���
������������������������������������������������������������������������������Ĵ��
���Parametros�Recebidos:                                                       ���
���          �USERTOKEN -> Token para validacao de geracao da rotina. Sempre   ���
���          �       serah "TOTVS"                                             ���
���          �ECF -> Objeto com as informacoes do inventario do estabelecimento���
���          �                                                                 ���
���          �Enviados:                                                        ���
���          �RETORNO -> String informativa sobre o processamento.             ���
���          �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                              ���
������������������������������������������������������������������������������Ĵ��
���          �               �                                                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
WSMETHOD FIS_INV WSRECEIVE USERTOKEN,INV WSSEND RETORNO WSSERVICE SPEDFISCALMOVIMENTOS
Local	lRetorno	:=	.T.
Local	nX			:=	0
Local	nI			:=	0
Local	cChave		:=	""
Local	lDT			:=	.F.
Local	lITINV		:=	.F.
Local	lCODITE		:=	.F.
Local	lAtualizou	:=	.F.
Local	cQuery		:=	""

InitSped()

If AllTrim(Self:UserToken) == "TOTVS"
	If Self:INV:INV<>Nil .And. Len(Self:INV:INV)>0
		If Self:INV:ID_ENT<>Nil .And. !Empty(Self:INV:ID_ENT)
			For nX := 1 To Len(Self:INV:INV)
				//�����������������������������������������������������������������������������Ŀ
				//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
				//�������������������������������������������������������������������������������			
				If Empty(Self:INV:INV[nX]:DT)
					lDT	:=	.T.
					Loop
				EndIf
				If Self:INV:INV[nX]:ITINV==Nil .Or. Len(Self:INV:INV[nX]:ITINV)==0
					lITINV	:=	.T.
					Loop
				EndIf
				
				Begin Transaction

				//��������������������������������������������������������������Ŀ
				//�                 informacao sobre o inventario                �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED043")
				cQuery := "DELETE "
				cQuery += "FROM SPED043 "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INV:ID_ENT,Len(SPED043->ID_ENT))+"' AND "
				cQuery += "DT='"+DToS(Self:INV:INV[nX]:DT)+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				//��������������������������������������������������������������Ŀ
				//�            informacao sobre os itens do inventario           �
				//�No caso de regravacao, excluo as movimentacoes anteriores para�
				//�  utilizar as novas.                                          �
				//����������������������������������������������������������������
				dbSelectArea("SPED043A")
				cQuery := "DELETE "
				cQuery += "FROM SPED043A "
				cQuery += "WHERE "
				cQuery += "ID_ENT='"+PadR(Self:INV:ID_ENT,Len(SPED043A->ID_ENT))+"' AND "
				cQuery += "DT='"+DToS(Self:INV:INV[nX]:DT)+"'"
				If TcSqlExec(cQuery) <> 0
					SetSoapFault("TOTVS SPED Services",TcSqlError())
					Return(FinishSped(.F.))
				EndIf
				
				dbSelectArea("SPED043")
				dbSetOrder(1)
				cChave	:=	PadR(Self:INV:ID_ENT,Len(SPED043->ID_ENT))
				cChave	+=	DToS(Self:INV:INV[nX]:DT)
				If SPED043->(dbSeek(cChave))
					RecLock("SPED043",.F.)
				Else
					RecLock("SPED043",.T.)
				EndIf
				SPED043->ID_ENT		:=	PadR(Self:INV:ID_ENT,Len(SPED043->ID_ENT))
				SPED043->DT  		:=	Self:INV:INV[nX]:DT
				SPED043->VLR		:=	Self:INV:INV[nX]:VLR
				MsUnLock()
				FkCommit()
				
				For nI := 1 To Len(Self:INV:INV[nX]:ITINV)
					//�����������������������������������������������������������������������������Ŀ
					//�Filtros importantes para amarracao no momento de geracao do arquivo magnetico�
					//�������������������������������������������������������������������������������
					If Empty(Self:INV:INV[nX]:ITINV[nI]:CODITE)
						lCODITE	:=	.T.
						Loop
					EndIf
					
					dbSelectArea("SPED043A")
					dbSetOrder(1)
					cChave	:=	SPED043->ID_ENT
					cChave	+=	DToS(SPED043->DT)
					cChave	+=	PadR(Self:INV:INV[nX]:ITINV[nI]:CODITE,Len(SPED043A->CODITE))
					If SPED043A->(dbSeek(cChave))
						RecLock("SPED043A",.F.)
					Else
						RecLock("SPED043A",.T.)
					EndIf
					SPED043A->ID_ENT	:=	SPED043->ID_ENT
					SPED043A->DT		:=	SPED043->DT
					SPED043A->CODITE	:=	PadR(Self:INV:INV[nX]:ITINV[nI]:CODITE,Len(SPED043A->CODITE))
					SPED043A->CODOBS 	:=	Self:INV:INV[nX]:ITINV[nI]:CODOBS
					SPED043A->CTACONT 	:=	Self:INV:INV[nX]:ITINV[nI]:CTACONTABIL
					SPED043A->IDPART 	:=	Self:INV:INV[nX]:ITINV[nI]:ID_PART
					SPED043A->INDPROP 	:=	Self:INV:INV[nX]:ITINV[nI]:INDPROP
					SPED043A->QTD 		:=	Self:INV:INV[nX]:ITINV[nI]:QTD
					SPED043A->UM	 	:=	Self:INV:INV[nX]:ITINV[nI]:UM
					SPED043A->VLRTOT	:=	Self:INV:INV[nX]:ITINV[nI]:VLTOT
					SPED043A->VLRUNIT	:=	Self:INV:INV[nX]:ITINV[nI]:VLUNIT
					MsUnLock()
					FkCommit()
				Next nI				
				
				End Transaction
				
				lAtualizou	:=	.T.
				
			Next nX

			Self:RETORNO	:= 	""
			If lAtualizou
				Self:RETORNO += "Todos as informa��es sobre o invent�rio foram cadastradas com sucesso. "
			EndIf
			If lDT
				Self:RETORNO += "Algumas informa��es sobre o invent�rio n�o foram cadastradas por estarem com a data em branco - (DT). "
			EndIf
			If lITINV
				Self:RETORNO += "Algumas informa��es sobre o invent�rio n�o foram cadastradas por estarem sem as movimenta��es de item(s) - (INV/ITINV). "
			EndIf
			If lCODITE
				Self:RETORNO += "Algumas informa��es sobre o invent�rio n�o foram cadastradas por estarem com o c�digo do item em branco - (CODITE). "
			EndIf
		Else
			Self:RETORNO	:=	"ID da entidade em branco. (ID_ENT)"
			SetSoapFault("TOTVS SPED Services",Self:RETORNO)
			lRetorno := .F.
		EndIf		
	Else
		Self:RETORNO	:=	"Atualiza��o n�o efetuada, pois n�o possui movimento para este servi�o."
		SetSoapFault("TOTVS SPED Services",Self:RETORNO)
		lRetorno := .F.
	EndIf
Else
	Self:RETORNO	:=	"Invalid Token"
	SetSoapFault("TOTVS SPED Services",Self:RETORNO)
	lRetorno := .F.
EndIf
Return(FinishSped(lRetorno))

