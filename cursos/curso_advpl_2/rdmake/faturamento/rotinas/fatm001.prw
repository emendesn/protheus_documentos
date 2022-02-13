#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"   
#define CRLF Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATM001   บAutor  ณPaulo Francisco     บ Data ณ01/02/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERADOR GNRE                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/  
User Function FATM001()

Private cArq   := "GNRE.txt"
Private cPerg  := "FATM001"
Private cDest  := Iif(SM0->M0_CODIGO == "01", "C:\GNRE\01\", "C:\GNRE\02\")
Private lExec  := .F.
Private nHdl   := FCreate(cDest + cArq)
Private cEOL   := "CHR(13)+CHR(10)"

u_GerA0003(ProcName())

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Caso nao seja informado, define local padrao de instalacao do GNRE      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(mv_par16)
	mv_par16 := "C:\Arquivos de Programas\GNRE\GNRE.exe"
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se o software GNRE esta instalado na maquina ...               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !File(mv_par16)
	cMsg := "O software GNRE nใo foi localizado atraves do caminho informado." + Chr(13)
	cMsg += mv_par16 + Chr(13) + Chr(13)
	cMsg += "Deseja prosseguir com a gera็ใo dos arquivos de integra็ใo ?"
	
	If Str(Aviso("Integra็ใo GNRE", cMsg, {"Ok","Cancela"},3, "Aten็ใo"),1) $ "0|2"
		Return
	EndIf
Else
	lExec := .T.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia processamento ...                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa ({||GeraArq()})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAARQ   บAutor  ณPaulo Francisco     บ Data ณ  01/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Possibilita a geracao do arquivo a ser incorporado pelo    บฑฑ
ฑฑบ          ณ GNRE para posterior impressao da Guia de Recolhimento.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GeraArq

dbSelectArea("SF2")
dbSetOrder(1)      
dbSeek(xFilial("SF2") + mv_par01 + mv_par03, .T.)

ProcRegua(RecCount())

While !Eof() .And. SF2->(F2_DOC+F2_SERIE) <= (Alltrim(mv_par02 + mv_par04))
	
	//Filtra Estado
	If SF2->F2_EST == "SP"
		dbSelectArea("SF2")
		dbSkip()
		Loop
	Endif

	//Filtra Clientes
	If SF2->F2_CLIENTE < mv_par05 .Or. SF2->F2_CLIENTE > mv_par06
		dbSelectArea("SF2")
		dbSkip()
		Loop
	Endif
	
	//Filtra Emissao
	If SF2->F2_EMISSAO < mv_par07 .Or. SF2->F2_EMISSAO > mv_par08
		dbSelectArea("SF2")
		dbSkip()
		Loop
	Endif
	
	//Verifica ICM Retido
	If SF2->F2_ICMSRET <= 0
		dbSelectArea("SF2")
		dbSkip()
		Loop
	Endif
	
	//Verifica Tipo da NF
	If !(SF2->F2_TIPO $ "N/C/I")
		dbSelectArea("SF2")
		dbSkip()
		Loop
	Endif
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona cliente da nota Fiscal ...                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SA1") 
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),.F.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Realiza a criacao do arquivo texto ...                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	IncProc("Gravando Arquivo(s) Integra็ใo GNRE ... ")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Trata as variaveis de processamento ...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCGC   := IIF(mv_par15 == 2, SA1->A1_CGC, SM0->M0_CGC)
	cRazao := IIF(mv_par15 == 2, SA1->A1_NOME, SM0->M0_NOMECOM)
	cEnd   := IIF(mv_par15 == 2, SA1->A1_END, SM0->M0_ENDCOB)
	cMun   := IIF(mv_par15 == 2, SA1->A1_MUN, SM0->M0_CIDCOB)
	cEst   := IIF(mv_par15 == 2, SA1->A1_EST, SM0->M0_ESTCOB)
	cTel   := IIF(mv_par15 == 2, SA1->A1_TEL, SM0->M0_TEL)
	cInf   := Alltrim(mv_par14)
	cCep   := IIF(mv_par15 == 2, SA1->A1_CEP, SM0->M0_CEPCOB)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Imprime dados do cliente nas informacoes complementares quando emitente ณ
	//ณ for empresa.                                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If mv_par15 == 1
		cInf := SA1->(A1_COD+'/'+A1_LOJA+' '+Rtrim(A1_NOME)+' - '+Rtrim(A1_END)+' - '+Rtrim(A1_MUN)+' - '+A1_EST+' - CEP '+Transform(A1_CEP,"@R 99999-999")) + IIF(!Empty(cInf),' - '+cInf,'')
	EndIf
	
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nTamLin  := 2+Len(cEOL)
	cBuffer  := Space(nTamLin)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto
	
	While nBtLidos >= nTamLin
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Leitura da proxima linha do arquivo texto.                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
		
		dbSkip()
		
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicia a gravacao no arquivo texto com separador TAB conforme layout ...ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	fWrite(nHdl,;
	SF2->(F2_EST)	+ Chr(09) +;											// Codigo da UF
	Iif(SF2->F2_EST == "GO","100099",mv_par09)             + Chr(09) +;   // Receita
	cCGC		                                        	+ Chr(09) +;   // CNPJ ou CPF
	AllTrim(Str(Val(SF2->(F2_DOC))))                       + Chr(09) +;   // Documento Origem
	mv_par10+mv_par11										+ Chr(09) +;	// Referencias
	Ltrim(Transform(SF2->F2_ICMSRET,"@E 999999999.99")) 	+ Chr(09) +;	// Valor Principal
	Ltrim(Transform(0,"@E 999999999.99"))					+ Chr(09) +;	// Atualizacao Monetaria
	Ltrim(Transform(0,"@E 999999999.99"))					+ Chr(09) +;	// Juros
	Ltrim(Transform(0,"@E 999999999.99"))					+ Chr(09) +;	// Multa
	Ltrim(Transform(SF2->F2_ICMSRET,"@E 999999999.99"))	    + Chr(09) +;   // Total a Recolher (VP+AM+J+M)
	DTOC(mv_par12)	+ Chr(09) +;											// Vencimento (dd/mm/aaaa)
	mv_par13		+ Chr(09) +;											// Convenio
	Rtrim(cRazao)	+ Chr(09) +;											// Razao Social
	''				+ Chr(09) +;   											// Inscricao Estadual
	Rtrim(cEnd)		+ Chr(09) +;											// Endereco
	Rtrim(cMun)		+ Chr(09) +;											// Municipio
	cEst 			+ Chr(09) +;											// UF
	Transform(cCEP,"@R 99999-999")				+ Chr(09) +;                // CEP (00000-000)
	Rtrim(cTel)		+ Chr(09) +;											// Telefone
	Rtrim(cInf)		+ Chr(09) +;											// Informacoes Complementares
	'' + CRLF) // Opcional - Produto
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha arquivo texto ...                                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea("SF2")
	dbSkip()
End

fClose(nHdl)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Caso exista instalado, executa software GNRE ...                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lExec
	WinExec(mv_par16)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATM001   บAutor  ณPaulo Francisco     บ Data ณ01/02/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCRIA SX1                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/  
Static Function ValidPerg(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Documento De      ?","","","mv_ch1","C",09,0,0,"G","","   ","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Documento Ate     ?","","","mv_ch2","C",09,0,0,"G","","   ","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Serie De          ?","","","mv_ch3","C",03,0,0,"G","","   ","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Serie Ate         ?","","","mv_ch4","C",03,0,0,"G","","   ","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Cliente De        ?","","","mv_ch5","C",06,0,0,"G","","SA1","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Cliente Ate       ?","","","mv_ch6","C",06,0,0,"G","","SA1","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Emissao De        ?","","","mv_ch7","D",08,0,0,"G","","   ","","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Emissao Ate       ?","","","mv_ch8","D",08,0,0,"G","","   ","","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"09","Codigo Receita    ?","","","mv_ch9","C",06,0,0,"G","","   ","","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"10","Intervalo Ref.    ?","","","mv_cha","C",01,0,0,"G","","   ","","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"11","MMAAAA Referencia ?","","","mv_chb","C",06,0,0,"G","","   ","","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"12","Vencimento GNRE   ?","","","mv_chc","D",08,0,0,"G","","   ","","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"13","Convenio          ?","","","mv_chd","C",30,0,0,"G","","   ","","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"14","Inf. Complementar ?","","","mv_che","C",60,0,0,"G","","   ","","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"15","Emitente          ?","","","mv_chf","N",01,0,0,"C","","   ","","","mv_par15","Empresa","","","","","Cliente","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"16","Instalacao GNRE   ?","","","mv_chg","C",50,0,0,"G","","   ","","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","")

Return