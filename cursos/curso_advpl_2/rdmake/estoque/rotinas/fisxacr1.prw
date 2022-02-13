#INCLUDE "protheus.ch" 
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISXACR1  ºAutor  ³Microsiga           º Data ³  15/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ACERTO DE NFE COM MAIS DE 990 ITENS                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BGH                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION FISXACR1()

Private aBLOQ := {}  

u_GerA0003(ProcName())
	
DocSeq()

// Não permite executar a rotina em ambiente diferente de TESTE/DEVEL_XXXX
If "DEVEL" $ Upper(AllTrim(getenvserver())) .or. "TESTE" $ Upper(AllTrim(getenvserver()))
	PUTMV("MV_ESTNEG","S")
	processa( { || fGera()}, "Analisando Notas...")
	PUTMV("MV_ESTNEG","N")
Else
	MsgAlert ("Rotina disponivel somente para o ambiente/base TESTE !")
	Return
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGera     ºAutor  ³Microsiga           º Data ³  12/21/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA DE APOIO PARA PROCESSAMENTO                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGera()

Local cQry   := ""                   //ARMAZENAR QUERY
Local aStruct1,aStruct2,aStruct2     //ARMAZENA ESTRUTURA DAS TABELAS SF1, SD1 e SE2
Local aCabec := {}                   //ARRAY PARA ARMAZENAR CABEÇALHO DA NOTA
Local aCabec1:= {}                   //ARRAY DE APOIO PARA ARMAZENAR CABEÇALHO DA NOTA
Local aItens := {}                   //ARRAY PARA ARMAZENAR ITENS DA NOTA
Local aItens1:= {}                   //ARRAY DE APOIO PARA ARMAZENAR ITENS DA NOTA
Local aTotIt := {}                   //ARRAY PARA ARMAZENAR ARRAY DOS ITENS DA NOTA
Local aTotIt1:= {}                   //ARRAY PARA ARMAZENAR ARRAY DOS ITENS DA NOTA
Local aNotas := {}                   //ARRAY PARA ARMAZENAR AS NOTAS QUE DEVERÃO SER MANIPULADAS
Local aArea  := {}                   //ARRAY PARA ARMAZENAR ÁREA CORRENTE
Local aArea1 := {}                   //ARRAY PARA ARMAZENAR ÁREA CORRENTE
Local aBKP1  := {}                   //ARRAY PARA ARMAZENAR ÁREA CORRENTE
Local aATES  := {}                   //ARRAY PARA ARMAZENAR ÁREA CORRENTE
Local aTes   := {}                   //ARRAY PARA ARMAZENAR TES MODIFICADAS E CONTEÚDO ORIGINAL
Local aPrSld := {}                   //ARRAY PARA ARMAZENAR SALDO DOS PRODUTOS PARA PERMITIR EXCLUSÃO DE NOTAS
Local aProdC := {}                   //ARRAY PARA ARMAZENAR CÓDIGOS DE PRODUTOS PARA PERMITIR EXCLUSÃO DE NOTAS DEVIDO POSSIBILIDADE DE BLOQUEIO
Local aCCont := ()                   //ARRAY PARA ARMAZENAR CÓDIGOS DE CONTAS CONTÁBEIS PARA PERMITIR EXCLUSÃO DE NOTAS DEVIDO POSSIBILIDADE DE BLOQUEIO
Local dDthj  := dDatabase            //ARMAZENA DATA ATUAL DO SISTEMA
Local cPerg  := "AFISXACR1"          //GRUPO DE PERGUNTA
Local cNfOri := ""                   //ARMAZENAR NÚMERO DA NOTA ORIGINAL
Local cSeOri := ""                   //ARMAZENAR SÉRIE DA NOTA ORIGINAL
Local cProd  := ""                   //ARMAZENAR CÓDIGO DE PRODUTO
Local cLocal := ""                   //ARMAZENAR LOCAL DO PRODUTO
Local cTes   := ""                   //ARMAZENAR NÚMERO DA TES
Local nVuni  := 0                    //ARMAZENAR VALOR UNITÁRIO DO ITEM
Local nQuant := 0                    //ARMAZENAR QUANTIDADE DO PRODUTO
Local nTotal := 0                    //ARMAZENAR VALOR TOTAL DO ITEM
Local dDtDc  := dDatabase            //PARA ARMAZENAR DATA DA DOCA
Local cHrDc  := ""                   //ARMAZENA HORA DA DOCA
Local cCCust := ""                   //ARMAZENA CENTRO DE CUSTO   
Local cE2TMP := CRIATRAB(,.F.)
Local cF1TMP := CRIATRAB(,.F.) 
Local cD1TMP := CRIATRAB(,.F.)   
Local cD1TMP0:= CRIATRAB(,.F.)  
Local lMuda  := .F. //VARIÁVEL PARA CONTROLE DE FORNECEDOR BLOQUEADO

MontaDIR("C:\TEMP")

//CRIA PERGUNTAS
ValidSX1(cPerg)
If !Pergunte(cPerg,.T.)
	MsgAlert ("Operação Cancelada pelo usuário!")
	Return
Endif
        
GRVLOG("iniciando area de trabalho...")
aArea := getArea()                    //ARMAZENA ÁREA DO SISTEMA
dbSelectArea("SF1")                   //ABRE ÁREA DO SF1
aStruct1 := SF1->(DbStruct())         //COPIA A ESTRUTURA DO SF1
dbCloseArea()                         //FECHA ÁREA
dbSelectArea("SD1")                   //ABRE ÁREA SD1
aStruct2 := SD1->(DbStruct())         //COPIA A ESTRUTURA DO SD1
dbCloseArea()                         //FECHA ÁREA
dbSelectArea("SE2")                   //ABRE ÁREA SE2
aStruct3 := SE2->(DbStruct())         //COPIA A ESTRUTURA DO SE2
dbCloseArea()                         //FECHA ÁREA

dbUseArea(.T., "TOPCONN",cF1TMP,"CLSF1",.F.,.F.)
If Select("CLSF1") == 0                  //SE NÃO EXISTIR ALIAS
	DBCREATE(cF1TMP,aStruct1,"TOPCONN") //CRIA TABELA SF1XXX COM A ESTRUTURA DO SF1
	dbUseArea(.T., "TOPCONN",cF1TMP,"CLSF1",.F.,.F.)
Endif

dbUseArea(.T., "TOPCONN",cD1TMP,"CLSD1",.F.,.F.)
If Select("CLSD1") == 0                   //SE NÃO EXISTIR ALIAS
	DBCREATE(cD1TMP,aStruct2,"TOPCONN") //CRIA TABELA SD1XXX COM A ESTRUTURA DO SD1
	dbUseArea(.T., "TOPCONN",cD1TMP,"CLSD1",.F.,.F.)
Endif

dbUseArea(.T., "TOPCONN",cE2TMP,"CLSE2",.F.,.F.)
If Select("CLSE2") == 0                   //SE NÃO EXISTIR ALIAS
	DBCREATE(cE2TMP,aStruct3,"TOPCONN") //CRIA TABELA SD1XXX COM A ESTRUTURA DO SE2
	dbUseArea(.T., "TOPCONN",cE2TMP,"CLSE2",.F.,.F.)
Endif
                   
GRVLOG("iniciando leitura do SF1 TRB0...")                   

cQry := " SELECT COUNT(D1_ITEM) AS CONT , D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA AS CHAVE " +CRLF
cQry += " INTO "+cD1TMP0+"  " +CRLF
cQry += " FROM "+retSqlName("SD1")+" (NOLOCK)  " +CRLF
cQry += " WHERE D_E_L_E_T_ <> '*' " +CRLF
cQry += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " +CRLF
cQry += " GROUP BY D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA " +CRLF
MEMOWRITE("d:\QRY00.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD
TCSQLEXEC(cQry)        
                   
//QUERY PATA SELECIONAR REGISTROS DE CABEÇALHO DE NOTAS DE ENTRADA COM MAIS DE 990 ITENS
cQry := " SELECT DISTINCT SF1.* " +CRLF
cQry += " FROM "+retSqlName("SF1")+" SF1 (NOLOCK) " +CRLF
cQry += " INNER JOIN (SELECT D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO as CHAVE2 ,*  " +CRLF
cQry += " 			FROM "+retSqlName("SD1")+" (NOLOCK)  " +CRLF
cQry += " 			INNER JOIN "+cD1TMP0+" LX1 ON D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA = CHAVE " +CRLF
cQry += " 			WHERE LX1.CONT > 990 ) X " +CRLF
cQry += " ON F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO = CHAVE2 " +CRLF
cQry += " WHERE SF1.D_E_L_E_T_ <> '*' " +CRLF
cQry += " ORDER BY F1_DOC " +CRLF

MEMOWRITE("d:\QRY01.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD

DbUseArea(.T.,"TOPCONN",TcGenqry(,,cQry),"TRB0",.F.,.T.)
GRVLOG("TRB0 OK...")
GRVLOG("INICIANDO COPIA TRB0 SF1...")
//GRAVA REGISTROS DA QUERY NA TABELA CLONE DE CABEÇALHO DE NOTAS DE ENTRADA
TRB0->(dbGotop())
Do While TRB0->(!EOF())
	Reclock("CLSF1",.T.)
	For nI := 1 to len(aStruct1)
		If aStruct1[nI][2] == "D"                                  //SE O CAMPO FOR DO TIPO DATA
			&(aStruct1[nI][1]) := stod(TRB0->(&(aStruct1[nI][1])))  //FAZ A CONVERSÃO DE STRING PARA DATA
		Else                                                       //CASO CONTRÁRIO
			&(aStruct1[nI][1]) := TRB0->(&(aStruct1[nI][1]))        //ARMAZENA NORMALMENTE
		Endif
	Next nI
	Msunlock()   
	
	TRB0->(dbSkip())
Enddo            

GRVLOG("FINALIZADO COPIA TRB0 SF1...")

//QUERY PATA SELECIONAR REGISTROS DE ITENS DE NOTAS DE ENTRADA COM MAIS DE 990 ITENS
cCampos := ""                          //SETA OS NOMES DE CAMPOS COMO VAZIO
For nI := 1 to len(aStruct2)           //PERCORRE O ARRAY QUE POSSUI A ESTRUTURA DA TABELA SD1
	cCampos += aStruct2[nI][1] + ", "  //CONSTROI OS NOMES DOS CAMPOS PARA A QUERY
Next nI
cCampos := cCampos + "R_E_C_N_O_  "    //COLOCA NO FINAL O CAMPO R_E_C_N_O_                             

GRVLOG("INICIANDO SD1XXX ...")
cQry := " INSERT INTO "+cD1TMP+"   " +CRLF
cQry += "       ("+cCampos+")   " +CRLF
cQry += " (SELECT "+cCampos+"   " +CRLF
cQry += "  FROM "+retSqlName("SD1")+" SD1 (NOLOCK) " +CRLF
cQry += " 			INNER JOIN "+cD1TMP0+" LX1 ON D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA = CHAVE " +CRLF
cQry += "  WHERE LX1.CONT > 990 AND SD1.D_E_L_E_T_ <> '*' ) " +CRLF

MEMOWRITE("d:\QRY02.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD
TCSQLEXEC(cQry)        
GRVLOG("RODOU SD1XXX...")
                                             
GRVLOG("SELECT NA SE2 TRB2...")
//QUERY PATA SELECIONAR REGISTROS DE TÍTULOS A PAGAR DE NOTAS DE ENTRADA COM MAIS DE 990 ITENS
cQry := " SELECT SE2.*  " +CRLF
cQry += " FROM "+retSqlName("SE2")+" SE2 (NOLOCK) " +CRLF
cQry += " INNER JOIN ( SELECT DISTINCT SF1.*  " +CRLF
cQry += " 			 FROM "+retSqlName("SF1")+" SF1 (NOLOCK)  " +CRLF
cQry += " 			 INNER JOIN (SELECT D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO as CHAVE2 ,*   " +CRLF
cQry += "  						 FROM "+retSqlName("SD1")+" (NOLOCK) " +CRLF
cQry += " 			             INNER JOIN "+cD1TMP0+" LX1 ON D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA = CHAVE " +CRLF
cQry += "  						 WHERE LX1.CONT > 990 ) X  " +CRLF
cQry += " 			 ON F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO = CHAVE2  " +CRLF
cQry += " 			 WHERE SF1.D_E_L_E_T_ <> '*') X ON E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM = F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC " +CRLF
cQry += " WHERE SE2.D_E_L_E_T_ <> '*' " +CRLF

MEMOWRITE("d:\QRY03.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD

DbUseArea(.T.,"TOPCONN",TcGenqry(,,cQry),"TRB2",.F.,.T.)
GRVLOG("FEITO TRB2...")

//GRAVA REGISTROS DA QUERY NA TABELA CLONE DE TÍTULOS A PAGAR
TRB2->(dbGotop())
Do While TRB2->(!EOF())
	GRVLOG("TRATANDO SE2..."+TRB2->E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
	Reclock("CLSE2",.T.)
	For nI := 1 to len(aStruct1)
		If aStruct3[nI][2] == "D"
			&(aStruct3[nI][1]) := stod(TRB2->(&(aStruct3[nI][1])))
		Else
			&(aStruct3[nI][1]) := TRB2->(&(aStruct3[nI][1]))
		Endif
	Next nI
	Msunlock()
	//VERIFICA SE NÃO EXISTIR BAIXA NO TÍTULO
	If !empty(alltrim(TRB2->E2_BAIXA))
		//EXCLUI A BAIXA DO TÍTULO EM QUESTÃO
		
		// VERIFICA BLOQUEIO FORNECEDOR
		aBKP1   := GETAREA()
		lMuda   :=.F.
		aCCont  := {}
		nSA2REC := 0
		
		dbselectarea("SA2")
		dbsetorder(1)
		dbgotop()
		IF DBSEEK(XFILIAL("SA2")+TRB2->(E2_FORNECE+E2_LOJA))
			IF SA2->A2_MSBLQL == "1"
				nSA2REC := SA2->(RECNO())
				lMuda := .T.
				RECLOCK("SA2",.F.)
				SA2->A2_MSBLQL := "2"
				MSUNLOCK()
				COMMIT
			ENDIF
		ELSE
			dbselectarea("SA1")
			dbsetorder(1)
			dbgotop()
			IF DBSEEK(XFILIAL("SA1")+TRB2->(F1_FORNECE+F1_LOJA))
				IF SA1->A1_MSBLQL == "1"
					nSA2REC := SA2->(RECNO())
					lMuda := .T.
					RECLOCK("SA1",.F.)
					SA1->A1_MSBLQL := "2"
					MSUNLOCK()
					COMMIT
				ENDIF 
			ENDIF	
		ENDIF
        //VERIFICA SE A CONTA CONTÁBIL ESTÁ BLOQUEADA
		dbSelectArea("CT1")
		CT1->(dbSetOrder(1))
		CT1->(dbgotop())
		If CT1->(dbSeek(SA2->A2_FILIAL+SA2->A2_CONTA)) //SE EXISTIR NA TABELA DE PLANO DE CONTA
			If CT1->CT1_BLOQ == "1"                               //SE A CONTA ESTIVER BLOQUEADA
				AADD(aCCont,{CT1->CT1_FILIAL,CT1->CT1_CONTA,CT1->CT1_BLOQ}) //ARMAZENA EM ARRAY A FILIAL, CÓDIGO E BLOQUEIO ORIGINAIS
				reclock("CT1",.F.)
				CT1_BLOQ := "2"                                   //ARMAZENA DESBLOQUEIO
				MSunlock()
			Endif
		Endif
		
		RESTAREA(aBKP1)
		Pergunte("FIN080",.F.)
		MV_PAR03 := 2 // CTB OFFLINE
		lmserroauto := .F.
		aVetor 	:=  {{"E2_PREFIXO"	 ,TRB2->E2_PREFIXO  ,Nil},;
		{"E2_NUM"		 ,TRB2->E2_NUM      ,Nil},;
		{"E2_PARCELA"	 ,TRB2->E2_PARCELA  ,Nil},;
		{"E2_TIPO"	   	 ,TRB2->E2_TIPO     ,Nil},;
		{"AUTVALREC"	 ,TRB2->E2_VALOR    ,Nil }}
		GRVLOG("EXCLUINDO BAIXA...")
		MSExecAuto({|x,y| fina080(x,y)},aVetor,5) //EXCLUI BAIXA VIA EXECAUTO		
		IF lMuda			
			DBSELECTAREA("SA2")
			IF DBSEEK(XFILIAL("SA2")+TRB2->(E2_FORNECE+E2_LOJA))
				SA2->(DBGOTO(NSA2Rec))
				RECLOCK("SA2",.F.)
				SA2->A2_MSBLQL := "1"
				MSUNLOCK()
				COMMIT   
			ELSE
				dbselectarea("SA1")
				IF DBSEEK(XFILIAL("SA1")+TRB2->(F1_FORNECE+F1_LOJA))
					SA1->(DBGOTO(NSA2Rec))
					RECLOCK("SA1",.F.)
					SA1->A1_MSBLQL := "1"
					MSUNLOCK()
					COMMIT   
				ENDIF
			ENDIF		
		ENDIF
        //VERIFICA SE EXISTE CONTA CONTÁBIL BLOQUEADA
		If len(aCCont) > 0                                                    //SE O ARRAY FOR MAIOR ZERO RETORNA CONTA CONTÁBIL ORIGINAL
			For nI := 1 to len(aCCont)                                        //PERCORRE O ARRAY DE CONTA CONTÁBIL
				dbSelectArea("CT1")
				CT1->(dbSetOrder(1))
				CT1->(dbGotop())
				If CT1->(dbSeek(aCCont[nI][1]+aCCont[nI][2]))                 //SE EXISTIR A CONTA CONTÁBIL ARMAZENADA NO ARRAY NA TABELA DE PLANO DE CONTA
					reclock("CT1",.F.)
					CT1_BLOQ := aCCont[nI][3]                                 //ARMAZENA BLOQUEIO ORIGINAL
					MSunlock()
				Endif
			Next nI		
		Endif		
		RESTAREA(aBKP1)		
		If lMsErroAuto
			MOSTRAERRO()
		Endif
	Endif
	TRB2->(dbSkip())
Enddo

//QUERY PARA SELECIONAR REGISTROS DE ITENS DE NOTAS DE ENTRADA COM MAIS DE 900 ITENS AGLUTINANDO POR PRODUTO PARA ACERTAR SB2 NA HORA DA EXCLUSÃO DA NOTA
dbSelectArea("TRB2")
dbCloseArea()                 
GRVLOG("SELECT NO SD1...")
cQry := " SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_LOCAL,SD1.D1_COD, SD1.D1_TES, SD1.D1_VUNIT, COUNT(*) AS QUANT " +CRLF
cQry += " FROM "+retSqlName("SD1")+" SD1 (NOLOCK) " +CRLF
cQry += " INNER JOIN "+cD1TMP0+" LX1 ON D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA = CHAVE " +CRLF
cQry += " WHERE LX1.CONT > 990 AND SD1.D_E_L_E_T_ <> '*' " +CRLF
cQry += " GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_LOCAL,SD1.D1_COD, SD1.D1_TES, SD1.D1_VUNIT " +CRLF
cQry += " ORDER BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_LOCAL,SD1.D1_COD " +CRLF
MEMOWRITE("d:\QRY04.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD

DbUseArea(.T.,"TOPCONN",TcGenqry(,,cQry),"TRB2",.F.,.T.)
GRVLOG("NOVO TRB2...")

//QUERY PARA SELECIONAR REGISTROS DE ITENS DE NOTAS DE ENTRADA COM MAIS DE 900 ITENS AGLUTINANDO POR CHAVE PRIMÁRIA E NF DE ORIGEM
cQry := " SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_LOCAL,D1_CC,D1_DTDOCA,D1_HRDOCA,D1_NFORI,D1_SERIORI,SD1.D1_COD, SD1.D1_TES, SD1.D1_VUNIT, COUNT(*) AS QUANT " +CRLF
cQry += " FROM "+retSqlName("SD1")+" SD1 (NOLOCK) " +CRLF
cQry += " INNER JOIN "+cD1TMP0+" LX1 ON D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA = CHAVE " +CRLF
cQry += " WHERE LX1.CONT > 990 AND SD1.D_E_L_E_T_ <> '*' " +CRLF
cQry += " GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_LOCAL,D1_CC,D1_DTDOCA,D1_HRDOCA,D1_NFORI,D1_SERIORI,SD1.D1_COD, SD1.D1_TES, SD1.D1_VUNIT " +CRLF
cQry += " ORDER BY D1_DOC " +CRLF
MEMOWRITE("d:\QRY05.SQL",cQry) //GRAVA A QUERY EM ALGUM LUGAR DO HD

DbUseArea(.T.,"TOPCONN",TcGenqry(,,cQry),"TRB1",.F.,.T.)
GRVLOG("NOVO TRB1...")

ProcRegua(TRB0->(RecCount()))
//PERCORRE ÁREA DE TRABALHO PARA ARMAZENAR REGISTROS DOS CABEÇALHOS DAS NOTAS E DOS ITENS DAS NOTAS DE ENTRADA
TRB0->(dbGoTop())
GRVLOG("PROCESSANDO TRB0...")
Do While TRB0->(!EOF())
	//BEGIN
	aNotas := {}
	//END
	aCabec := {}
	aTotIt := {}
	aATES  := getArea()
	//ARMAZENA O CABEÇALHO DA NOTA NO ARRAY ACABEC
	For nI := 1 to len(aStruct1)
		If aStruct1[nI][2] == "D"
			Aadd(aCabec,{'"'+(aStruct1[nI][1])+'"',STOD(TRB0->(&(aStruct1[nI][1]))),nil})
		Else
			Aadd(aCabec,{'"'+(aStruct1[nI][1])+'"',TRB0->(&(aStruct1[nI][1])),nil})
		Endif
	Next nI
	aArea1:= getArea()
	TRB1->(dbGoTop())
	//ARMAZENA OS ITENS DA NOTA NO ARRAY ATOTIT COM ITENS JÁ AGLUTINADOS
	Do While TRB1->(!EOF())
		If TRB1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == TRB0->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			aItens := {}
			AADD(aItens,{"D1_FILIAL",TRB1->D1_FILIAL,NIL})
			AADD(aItens,{"D1_COD",TRB1->D1_COD,NIL})
			AADD(aItens,{"D1_CC",TRB1->D1_CC,NIL})
			AADD(aItens,{"D1_DTDOCA",STOD(TRB1->D1_DTDOCA),NIL})
			AADD(aItens,{"D1_HRDOCA",TRB1->D1_HRDOCA,NIL})
			AADD(aItens,{"D1_LOCAL",TRB1->D1_LOCAL,NIL})
			AADD(aItens,{"D1_TES",TRB1->D1_TES,NIL})
			AADD(aItens,{"D1_VUNIT",TRB1->D1_VUNIT,NIL})
			AADD(aItens,{"D1_QUANT",TRB1->QUANT,NIL})
			AADD(aItens,{"D1_NFORI",TRB1->D1_NFORI,NIL})
			AADD(aItens,{"D1_SERIORI",TRB1->D1_SERIORI,NIL})
			AADD(aTotIt,aItens)
		Endif
		TRB1->(dbSkip())
	Enddo
	TRB2->(dbGoTop())
	//ACERTO DA TES E DO SALDO DO PRODUTO PARA EXCLUSÃO DA NOTA
	aTes   := {}
	aPrSld := {}  
	aProdC := {} 
	aCCont := {}
	Do While TRB2->(!EOF())
		If TRB2->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == TRB0->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(TRB2->D1_FILIAL+TRB2->D1_COD))                //SE EXISTIR NA TABELA DE PRODUTO
				If SB1->B1_MSBLQL == "1"                                  //SE O REGISTRO ESTIVER BLOQUEDO 
					AADD(aProdC,{SB1->B1_FILIAL,SB1->B1_COD,SB1->B1_MSBLQL})//ARMAZENA EM ARRAY A FILIAL, CÓDIGO E BLOQUEIO ORIGINAIS
					reclock("SB1",.F.)
					B1_MSBLQL := "2"                                      //ARMAZENA BLOQUEIO NÃO
					MSunlock()
                 Endif
            Endif     
			dbSelectArea("SB2")
			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(TRB2->D1_FILIAL+TRB2->D1_COD+TRB2->D1_LOCAL)) //SE EXISTIR NA TABELA DE SALDO
				If SB2->B2_QATU < TRB2->QUANT                             //SE O SALDO FÍSICO FOR MENOR QUE A QUANTIDADE DA NOTA
					AADD(aPrSld,{SB2->B2_FILIAL,SB2->B2_COD,SB2->B2_LOCAL,SB2->B2_QATU,SB2->B2_VATU1}) //ARMAZENA EM ARRAY A FILIAL, CÓDIGO, LOCAL E SALDO FÍSICO E SALDO FINANCEIRO ORIGINAIS
					reclock("SB2",.F.)
					B2_QATU  := TRB2->QUANT                           //ARMAZENA QUANTIDADE DA NOTA
					B2_VATU1 := TRB2->QUANT*B2_CM1                    //ARMAZENA VALOR DO PRODUTO
					MSunlock()
				Endif
			Endif
			dbSelectArea("SF4")
			SF4->(dbSetOrder(1))
			SF4->(dbGoTop())
			If SF4->(dbSeek("  "+TRB2->D1_TES))                //SE EXISTIR NA TABELA DE TES
				AADD(aTes,{SF4->F4_FILIAL,SF4->F4_CODIGO,SF4->F4_PODER3,SF4->F4_MSBLQL}) //ARMAZENA EM ARRAY A FILIAL, O CÓDIGO DA TES, O CONTEÚDO DO PODER DE TERCEIRO E O BLOQUEIO
				reclock("SF4",.F.)
				F4_MSBLQL := "2"                                      //SETA COMO NÃO BLOQUEADO
				F4_PODER3 := "N"                                      //SETA COMO PODER DE TERCEIRO NÃO CONTROLA
				MSunlock()
			Endif                    
		Endif
		TRB2->(dbSkip())
	Enddo
	RestArea(aArea1)
	aCabec1:= {}
	aItens := {}
	//ARMAZENA OS VALORES DA NOTA ATUAL PARA EXCLUSÃO DA MESMA VIA EXECAUTO
	IncProc("Processando Excluindo Nota: "+aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_DOC'+'"'})][2]+" AGUARDE...")
	aadd(aCabec1,{"F1_FILIAL",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_FILIAL'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_DOC",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_DOC'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_SERIE",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_SERIE'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_FORNECE",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_FORNECE'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_LOJA",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_LOJA'+'"'})][2],NIL})
	
	// VERIFICA BLOQUEIO DO FORNECEDOR
	aBKP1   := GETAREA()
	lMuda   :=.F.
	nSA2REC := 0

	If TRB0->F1_TIPO == "B" .OR. TRB0->F1_TIPO == "D"
		dbselectarea("SA1")
		dbsetorder(1)
		dbgotop()
		IF DBSEEK(XFILIAL("SA1")+TRB0->(F1_FORNECE+F1_LOJA))
			IF SA1->A1_MSBLQL == "1"
				nSA2REC := SA2->(RECNO())
				lMuda := .T.
				RECLOCK("SA1",.F.)
				SA1->A1_MSBLQL := "2"
				MSUNLOCK()
				COMMIT
			ENDIF
		ENDIF
	ELSE
		dbselectarea("SA2")
		dbsetorder(1)
		dbgotop()
		IF DBSEEK(XFILIAL("SA2")+TRB0->(F1_FORNECE+F1_LOJA))
			IF SA2->A2_MSBLQL == "1"
				nSA2REC := SA2->(RECNO())
				lMuda := .T.
				RECLOCK("SA2",.F.)
				SA2->A2_MSBLQL := "2"
				MSUNLOCK()
				COMMIT
			ENDIF
		ENDIF
	ENDIF
    //VERIFICA SE A CONTA CONTÁBIL ESTÁ BLOQUEADA
	dbSelectArea("CT1")
	CT1->(dbSetOrder(1))       
	CT1->(dbgotop())
	If CT1->(dbSeek(SA2->A2_FILIAL+SA2->A2_CONTA)) //SE EXISTIR NA TABELA DE PLANO DE CONTA
		If CT1->CT1_BLOQ == "1"                               //SE A CONTA ESTIVER BLOQUEADA
			AADD(aCCont,{CT1->CT1_FILIAL,CT1->CT1_CONTA,CT1->CT1_BLOQ}) //ARMAZENA EM ARRAY A FILIAL, CÓDIGO E BLOQUEIO ORIGINAIS
			reclock("CT1",.F.)
			CT1_BLOQ := "2"                                   //ARMAZENA DESBLOQUEIO
			MSunlock()
		Endif
	Endif	
	RESTAREA(aBKP1)
		
	Pergunte("MTA103",.F.)
	MV_PAR06 := .F.
	GRVLOG("EXECAUTO EXCLUSAO MATA103..."+aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_DOC'+'"'})][2])
	lMsErroAuto := .F.
	MATA103(aCabec1,aItens,5)
		
	IF lMuda
		If TRB0->F1_TIPO == "B" .OR. TRB0->F1_TIPO == "D"		
			DBSELECTAREA("SA1")
			SA1->(DBGOTO(NSA2Rec))
			RECLOCK("SA1",.F.)
			SA1->A1_MSBLQL := "1"
			MSUNLOCK()
			COMMIT
		ELSE
			DBSELECTAREA("SA2")
			SA2->(DBGOTO(NSA2Rec))
			RECLOCK("SA2",.F.)
			SA2->A2_MSBLQL := "1"
			MSUNLOCK()
			COMMIT
		ENDIF	
	ENDIF
    //VERIFICA SE EXISTE CONTA CONTÁBIL BLOQUEADA
	If len(aCCont) > 0                                                    //SE O ARRAY FOR MAIOR ZERO RETORNA CONTA CONTÁBIL ORIGINAL
		For nI := 1 to len(aCCont)                                        //PERCORRE O ARRAY DE CONTA CONTÁBIL
			dbSelectArea("CT1")
			CT1->(dbSetOrder(1))
			CT1->(dbgotop())
			If CT1->(dbSeek(aCCont[nI][1]+aCCont[nI][2]))                 //SE EXISTIR A CONTA CONTÁBIL ARMAZENADA NO ARRAY NA TABELA DE PLANO DE CONTA
				reclock("CT1",.F.)
				CT1_BLOQ := aCCont[nI][3]                                 //ARMAZENA BLOQUEIO ORIGINAL
				MSunlock()
			Endif
		Next nI		
	Endif	
	RESTAREA(aBKP1)
	
	//EXCLUI NOTA VIA EXECAUTO
	If lMsErroAuto
		MOSTRAERRO()
	Endif
	aArea1 := getArea()
	
	//RETORNA BLOQUEIO ORIGINAL DOS PRODUTOS
	If len(aProdC) > 0                                                    //SE O ARRAY FOR MAIOR ZERO RETORNA BLOQUEIO DE PRODUTOS ORIGINAL
		For nI := 1 to len(aProdC)                                        //PERCORRE O ARRAY DE PRODUTOS
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(aProdC[nI][1]+aProdC[nI][2]))                 //SE EXISTIR O PRODUTO ARMAZENADA NO ARRAY 
				reclock("SB1",.F.)
				B1_MSBLQL := aProdC[nI][3]                                //ARMAZENA BLOQUEIO ORIGINAL
				MSunlock()
			Endif
		Next nI	
	Endif
	//RETORNA SALDO ORIGINAL DOS PRODUTOS
	If len(aPrSld) > 0                                                    //SE O ARRAY FOR MAIOR ZERO RETORNA SALDO DE PRODUTOS ORIGINAL
		For nI := 1 to len(aPrSld)                                        //PERCORRE O ARRAY DE PRODUTOS
			dbSelectArea("SB2")
			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(aPrSld[nI][1]+aPrSld[nI][2]+aPrSld[nI][3]))   //SE EXISTIR O PRODUTO ARMAZENADA NO ARRAY NA TABELA DE SALDOS
				reclock("SB2",.F.)
				B2_QATU  := aPrSld[nI][4]                                 //ARMAZENA SALDO ORIGINAL
				B2_VATU1 := aPrSld[nI][5]                                 //ARMAZENA VALOR ORIGINAL
				MSunlock()
			Endif
		Next nI
	Endif
	//RETORNA CONTEÚDO DE PODER DE TERCEIRO ORIGINAL DAS TES
	If len(aTes) > 0                                                    //SE O ARRAY FOR MAIOR ZERO RETORNA TES ORIGINAL
		For nI := 1 to len(aTes)                                        //PERCORRE O ARRAY DE TES
			dbSelectArea("SF4")                                            			
			SF4->(dbSetOrder(1))                                           
			SF4->(dbGoTop())
			If SF4->(dbSeek(aTes[nI][1]+aTes[nI][2]))                   //SE EXISTIR A TES ARMAZENADA NO ARRAY NA TABELA DE TES
				reclock("SF4",.F.)
				F4_MSBLQL := aTes[nI][4]                                //RETORNA O CONTEÚDO DO BLOQUEIO QUE FOI ARMAZENADO NO ARRAY
				F4_PODER3 := aTes[nI][3]                                //RETORNA O CONTEÚDO DE PODER DE TERCEIRO QUE FOI ARMAZENADO NO ARRAY
				MSunlock()
			Endif
		Next nI                                                            
	Endif
	RestArea(aArea1)
	//ARMAZENA NO ARRAY ANOTAS O CABEÇALHO E OS ITENS DA NOTA ATUAL QUE FOI EXCLUIDA
	aadd(aNotas,{aCabec,aTotIt})

//BEGIN
	IncProc("Processando Incluindo Nota: "+aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_DOC'+'"'})][2]+" AGUARDE...")
	aCabec := {}
	aCabec := aClone(aNotas[1][1])
	aCabec1:= {}
	aItens := {}
	aItens1:= {}
	aTotIt1:= {}
	aPrSld := {}           
	aProdC := {}
	aCCont := {}
	//AGLUTINA ITENS DA NOTA ORIGINAL EM UM SÓ ITEM
	For nA := 1 to len(aNotas[1][2])
		aItens := aClone(aNotas[1][2][nA])
		cFilial:= aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_FILIAL"})][2]
		dDtDc  := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_DTDOCA"})][2]
		cHrDc  := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_HRDOCA"})][2]
		cCCust := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_CC"})][2]
		cNfOri := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_NFORI"})][2]
		cSeOri := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_SERIORI"})][2]
		cProd  := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_COD"})][2]
		cLocal := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_LOCAL"})][2]
		cTes   := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_TES"})][2]
		nVuni  := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_VUNIT"})][2]
		nQuant := aItens[ASCAN(aItens,{|x|AllTrim(x[1]) == "D1_QUANT"})][2]
		nTotal := round(nQuant*nVuni,2)
		aItens1:= {}
		aadd(aItens1,{"D1_DTDOCA",dDtDc,NIL})
		aadd(aItens1,{"D1_HRDOCA",cHrDc,NIL})
		aadd(aItens1,{"D1_CC",cCCust,NIL})
		aadd(aItens1,{"D1_NFORI",cNfOri,NIL})
		aadd(aItens1,{"D1_SERIORI",cSeOri,NIL})
		aadd(aItens1,{"D1_COD",cProd,NIL})
		aadd(aItens1,{"D1_LOCAL",cLocal,NIL})
		aadd(aItens1,{"D1_TES",cTes,NIL})
		aadd(aItens1,{"D1_QUANT",nQuant,NIL})
		aadd(aItens1,{"D1_VUNIT",nVuni,NIL})
		aadd(aItens1,{"D1_TOTAL",nTotal,NIL})
		AADD(aTotIt1,aItens1)
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_FILIAL'+'"'})][2]+cProd)) //SE EXISTIR NA TABELA DE PRODUTO
			If SB1->B1_MSBLQL == "1"                                  //SE O REGISTRO ESTIVER BLOQUEDO 
				AADD(aProdC,{SB1->B1_FILIAL,SB1->B1_COD,SB1->B1_MSBLQL})//ARMAZENA EM ARRAY A FILIAL, CÓDIGO E BLOQUEIO ORIGINAIS
				reclock("SB1",.F.)
				B1_MSBLQL := "2"                                      //ARMAZENA BLOQUEIO NÃO
				MSunlock()
            Endif
        Endif     
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_FILIAL'+'"'})][2]+cProd+cLocal))                        //SE EXISTIR NA TABELA DE SALDO
			AADD(aPrSld,{SB2->B2_FILIAL,SB2->B2_COD,SB2->B2_LOCAL,SB2->B2_QATU,SB2->B2_VATU1}) //ARMAZENA EM ARRAY A FILIAL, CÓDIGO, LOCAL E SALDO FÍSICO E SALDO FINANCEIRO ORIGINAIS
		Endif
	Next nA
	
	aadd(aCabec1,{"F1_FILIAL",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_FILIAL'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_DOC",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_DOC'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_SERIE",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_SERIE'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_FORNECE",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_FORNECE'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_LOJA",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_LOJA'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_EMISSAO",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_EMISSAO'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_TIPO",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_TIPO'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_DTDIGIT",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_DTDIGIT'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_ESPECIE",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_ESPECIE'+'"'})][2],NIL})	
	//SETA A DATA DO SISTEMA COMO SENDO A DATA DE DIGITAÇÃO DA NOTA ORIGINAL
	dDatabase := aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_DTDIGIT'+'"'})][2]
	aadd(aCabec1,{"F1_EST",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_EST'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_FORMUL",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_FORMUL'+'"'})][2],NIL})
	aadd(aCabec1,{"F1_COND",aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_COND'+'"'})][2],NIL})
	                	
	// VERIFICA BLOQUEIO DO FORNECEDOR
	aBKP1   := GETAREA()
	lMuda   :=.F.
	nSA2REC := 0
	
	If TRB0->F1_TIPO == "B" .OR. TRB0->F1_TIPO == "D"
		dbselectarea("SA1")
		dbsetorder(1)
		dbgotop()
		IF DBSEEK(XFILIAL("SA1")+TRB0->(F1_FORNECE+F1_LOJA))
			IF SA1->A1_MSBLQL == "1"
				nSA2REC := SA2->(RECNO())
				lMuda := .T.
				RECLOCK("SA1",.F.)
				SA1->A1_MSBLQL := "2"
				MSUNLOCK()
				COMMIT
			ENDIF
		ENDIF
	ELSE
		dbselectarea("SA2")
		dbsetorder(1)
		dbgotop()
		IF DBSEEK(XFILIAL("SA2")+TRB0->(F1_FORNECE+F1_LOJA))
			IF SA2->A2_MSBLQL == "1"
				nSA2REC := SA2->(RECNO())
				lMuda := .T.
				RECLOCK("SA2",.F.)
				SA2->A2_MSBLQL := "2"
				MSUNLOCK()
				COMMIT
			ENDIF
		ENDIF
	ENDIF
    //VERIFICA SE A CONTA CONTÁBIL ESTÁ BLOQUEADA
	dbSelectArea("CT1")
	CT1->(dbSetOrder(1))    
	CT1->(dbgotop())
	If CT1->(dbSeek(SA2->A2_FILIAL+SA2->A2_CONTA)) //SE EXISTIR NA TABELA DE PLANO DE CONTA
		If CT1->CT1_BLOQ == "1"                               //SE A CONTA ESTIVER BLOQUEADA
			AADD(aCCont,{CT1->CT1_FILIAL,CT1->CT1_CONTA,CT1->CT1_BLOQ}) //ARMAZENA EM ARRAY A FILIAL, CÓDIGO E BLOQUEIO ORIGINAIS
			reclock("CT1",.F.)
			CT1_BLOQ := "2"                                   //ARMAZENA DESBLOQUEIO
			MSunlock()
		Endif
	Endif		
	RESTAREA(aBKP1)		
	Pergunte("MTA103",.F.)
	MV_PAR06 := .F.
		GRVLOG("EXECAUTO GRAVANDO MATA103..."+aCabec[ASCAN(aCabec,{|x|AllTrim(x[1]) == '"'+'F1_DOC'+'"'})][2])
	lMsErroAuto := .F.
	MATA103(aCabec1,aTotIt1,3)                                            //INCLUSÃO POR EXECAUTO		
	IF lMuda
		If TRB0->F1_TIPO == "B" .OR. TRB0->F1_TIPO == "D"		
			DBSELECTAREA("SA1")
			SA1->(DBGOTO(NSA2Rec))
			RECLOCK("SA1",.F.)
			SA1->A1_MSBLQL := "1"
			MSUNLOCK()
			COMMIT
		ELSE
			DBSELECTAREA("SA2")
			SA2->(DBGOTO(NSA2Rec))
			RECLOCK("SA2",.F.)
			SA2->A2_MSBLQL := "1"
			MSUNLOCK()
			COMMIT
		ENDIF	
	ENDIF
    //VERIFICA SE EXISTE CONTA CONTÁBIL BLOQUEADA
	If len(aCCont) > 0                                                    //SE O ARRAY FOR MAIOR ZERO RETORNA CONTA CONTÁBIL ORIGINAL
		For nI := 1 to len(aCCont)                                        //PERCORRE O ARRAY DE CONTA CONTÁBIL
			dbSelectArea("CT1")
			CT1->(dbSetOrder(1))  
			CT1->(dbgotop())
			If CT1->(dbSeek(aCCont[nI][1]+aCCont[nI][2]))                 //SE EXISTIR A CONTA CONTÁBIL ARMAZENADA NO ARRAY NA TABELA DE PLANO DE CONTA
				reclock("CT1",.F.)
				CT1_BLOQ := aCCont[nI][3]                                 //ARMAZENA BLOQUEIO ORIGINAL
				MSunlock()
			Endif
		Next nI		
	Endif		
	RESTAREA(aBKP1)
	If lMsErroAuto
		MOSTRAERRO()
	Endif
	aArea1 := getArea()
	//RETORNA BLOQUEIO ORIGINAL DOS PRODUTOS
	If len(aProdC) > 0                                                    //SE O ARRAY FOR MAIOR ZERO RETORNA BLOQUEIO DE PRODUTOS ORIGINAL
		For nI := 1 to len(aProdC)                                        //PERCORRE O ARRAY DE PRODUTOS
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(aProdC[nI][1]+aProdC[nI][2]))                 //SE EXISTIR O PRODUTO ARMAZENADA NO ARRAY 
				reclock("SB1",.F.)
				B1_MSBLQL := aProdC[nI][3]                                //ARMAZENA BLOQUEIO ORIGINAL
				MSunlock()
			Endif
		Next nI	
	Endif	
	//RETORNA SALDO ORIGINAL DOS PRODUTOS
	If len(aPrSld) > 0                                                    //SE O ARRAY FOR MAIOR ZERO RETORNA SALDO DE PRODUTOS ORIGINAL
		For nA := 1 to len(aPrSld)                                            //PERCORRE O ARRAY DE PRODUTOS
			dbSelectArea("SB2")
			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(aPrSld[nA][1]+aPrSld[nA][2]+aPrSld[nA][3]))       //SE EXISTIR O PRODUTO ARMAZENADA NO ARRAY NA TABELA DE SALDOS
				reclock("SB2",.F.)
				B2_QATU  := aPrSld[nA][4]                                 //ARMAZENA SALDO ORIGINAL
				B2_VATU1 := aPrSld[nA][5]                                 //ARMAZENA VALOR ORIGINAL
				MSunlock()
			Endif
		Next nA
	Endif	
	RestArea(aArea1)
//END
    RestArea(aATES)           
	TRB0->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

dbSelectArea("TRB0")
dbCloseArea()
dbSelectArea("TRB1")
dbCloseArea()
dbSelectArea("TRB2")
dbCloseArea()
dbSelectArea("CLSF1")
dbCloseArea()
dbSelectArea("CLSD1")
dbCloseArea()
dbSelectArea("CLSE2")
dbCloseArea()      

TCSQLEXEC("DROP TABLE "+cF1TMP)
TCSQLEXEC("DROP TABLE "+cD1TMP) 
TCSQLEXEC("DROP TABLE "+cD1TMP0)
TCSQLEXEC("DROP TABLE "+cE2TMP)

//RESTAURA A ÁREA DO SISTEMA
RestArea(aArea)
//SETA A DATA DO SISTEMA COM A VARIÁVEL GUARDADA ANTERIORMENTE
dDatabase := dDthj

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  VALIDSX1   ºAutor  ³Microsiga           º Data ³  12/20/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CRIA PERGUNTAS DA ROTINA                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BGH                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION VALIDSX1(cPerg1)

Local aHelp := {}

// PARA REALIZAR AJUSTES FINOS

dbselectarea("SX1")
dbsetOrder(1)

PutSx1(cPerg1, "01","Data de      ?"," "," ","mv_ch01","D",08,0,0,"G","     ","   ","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg1, "02","Data até     ?"," "," ","mv_ch02","D",08,0,0,"G","     ","   ","","","mv_par02","","","","","","","","","","","","","","","","")

RETURN(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOCSEQ    ºAutor  ³ Paulo Francisco    º Data ³ 28/01/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para verificar a integridade do numero sequencial de º±±
±±º          ³notas fiscais, armazenado no MV_DOCSEQ.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DocSeq()

Local aArea		:= GetArea()				// Armazena o posicionamento atual
Local aAlias	:= {"SD1","SD2","SD3"}		// Tabelas que utilizam controle de sequencia de documentos
Local aAreaTmp	:= {}						// Armazenamento temporario das areas utilizadas
Local cBusca	:= ""						// String para busca pelo ultimo sequencial
Local cMax		:= ""						// Maior documento encontrado entre as tabelas
Local cDoc		:= ""						// Maior documento encontrado para cada tabela
Local nX		:= 0						// Auxiliar de loop
Local nTamSeq	:= 0						// Tamanho do campo de controle de sequencia
 
If !("DEVEL" $ Upper(AllTrim(getenvserver())) .or. "TESTE" $ Upper(AllTrim(getenvserver())))
	MsgAlert ("Rotina disponivel somente para o ambiente/base TESTE !")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Le o tamanho dos campos de sequencial e monta a string      ³
//³com este tamanho para busca pelo ultimo sequencial utilizado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTamSeq	:= TamSx3("D3_NUMSEQ")[1]
cBusca := Replicate("z",nTamSeq)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Le o maior numero sequencial existente entre os documentos³
//³de entrada (SD1), saida (SD2) e movimentacao de materiais ³
//³(SD3)                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aAlias)
	
	DbSelectArea(aAlias[nX])
	aAreaTmp := GetArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordem do DocSeq nas tabelas SD1, SD2 e SD3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSetOrder(4) 
	DbSeek(xFilial(aAlias[nX])+cBusca,.T.)
	DbSkip(-1)
	
	If &(PrefixoCPO(aAlias[nX]) + "_FILIAL") == xFilial(aAlias[nX])
		cDoc := &(PrefixoCPO(aAlias[nX]) + "_NUMSEQ")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Armazena o maior sequencial entre as tres tabelas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cDoc > cMax
		cMax := cDoc
	EndIf
	
	RestArea(aAreaTmp)   
	
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o proximo numero a partir do MV_DOCSEQ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cProx := Soma1(PadR(SuperGetMv("MV_DOCSEQ"),nTamSeq),,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o MV_DOCSEQ esta gravado corretamente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cMax >= cProx
	PUTMV("MV_DOCSEQ",cMax)
EndIf

RestArea(aArea)

Return lRet


STATIC FUNCTION GRVLOG(cVar) 

MEMOWRIT("C:\TEMP\"+CRIATRAB(,.F.)+".TXT",cVar)


RETURN