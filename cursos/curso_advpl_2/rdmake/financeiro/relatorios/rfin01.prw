#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN01    º Autor ³ Antonio-Erpplus    º Data ³  01/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Comissoes                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFIN01


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Comissão de Vendas por Vendedor"
Local cPict          := ""
Local titulo       := "Comissão de Vendas por Vendedor"
Local nLin         := 80
Local Cabec1       := "TITULO PRF PC EMISSAO  VENCTO     VALOR TOTAL VALOR COMISSAO PAGOU? NOME CLIENTE                   UF VALOR MOVIMENTO %COMISSAO VALOR COMISSAO PEDIDO-IT PRODUTO         "
					 //XXXXXX XXX X  DD/MM/AA DD/MM/AA XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999,999,999.99 999,999,999.99 X      9999,999,999.99 99,999.99 999,999,999.99 XXXXXX    XXXXXXXXXXXXXXX 
//Titulo/NF  Prefixo/Série	Parcela	Emissão	Vencto Real	RFIN01 Cliente	UF	Valor Total	Valor Comissão	Valor Movimento	% Comissão	Valor Comissão	Pedido	Produto	Já Pago?"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFIN01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := padr("RFIN01",10)
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFIN01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SE1"

u_GerA0003(ProcName())

dbSelectArea("SE1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Grupo de Perguntas do relatorio...cperg                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem,nVezImp
Local nE3_COMIS,nE3_BASE,cA3_NOME
Local nVlE3_COMIS,nVlD2_TOTAL,nValCom
Private aTotVend:={}
Private	nGerVen1 := nGerVen2 := nGerVen3 := nGerVen4 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Query do relatorio...                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_fMontaQuery()

TRB1->(SetRegua(RecCount()))
TRB1->(dbGoTop())

While !TRB1->(EOF())
	
		
	cVend1 := TRB1->E1_FILIAL+TRB1->E1_VEND1
	nLin   := 80
	nTtBase1  := 0	
	nTtComis1 := 0
	nTtTotal  := 0
	nTtComis2 := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	cA3_NOME := Posicione("SA3",1,xFilial("SA3")+TRB1->E1_VEND1,"A3_NOME")
	
	@nLin,00 PSAY 	"Periodo: Data Inicial: "+DTOC(mv_par03)+" Data Final: "+DTOC(MV_PAR04)
	nLin++
	
	@nLin,00 PSAY 	"Vendedor: Cod. "+TRB1->E1_VEND1+" Nome: "+cA3_NOME
	nLin++
	nLin++
		
		
	While !TRB1->(EOF()) .And. TRB1->E1_FILIAL+TRB1->E1_VEND1 == cVend1
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//Dados dos títulos a receber (SE1)								Dados das Comissões (SE3)	Dados dos Itens das Notas Fiscais (SD2)
		//Título / NF	Prefixo/Série	Parcela	Emissão	Vencto Real	Nome Cliente	UF	Valor Total	Valor Comissão	Valor Movimento	% Comissão	Valor Comissão	Pedido	Produto	Já Pago?
		
		@nLin,000      PSAY TRB1->E1_NUM
		@nLin,PCOL()+1 PSAY TRB1->E1_PREFIXO
	
		nVlE3_COMIS := 0
		nVlD2_TOTAL := 0
		nVlCom      := 0
		aTitulo     := {}
		
		cTitulo1 := TRB1->E1_FILIAL+TRB1->E1_VEND1+TRB1->E1_PREFIXO+TRB1->E1_NUM//+TRB1->E1_PARCELA
			
		
		While !TRB1->(EOF()) .And. TRB1->E1_FILIAL+TRB1->E1_VEND1+TRB1->E1_PREFIXO+TRB1->E1_NUM == cTitulo1
			
			IncRegua("Imprimindo...")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o cancelamento pelo usuario...                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			//Dados dos títulos a receber (SE1)								Dados das Comissões (SE3)	Dados dos Itens das Notas Fiscais (SD2)
			//Título / NF	Prefixo/Série	Parcela	Emissão	Vencto Real	Nome Cliente	UF	Valor Total	Valor Comissão	Valor Movimento	% Comissão	Valor Comissão	Pedido	Produto	Já Pago?
			AADD(atitulo,{TRB1->E1_PARCELA;
						,TRB1->E1_EMISSAO;
						,TRB1->E1_VENCREAL;
						,SUBSTR(TRB1->A1_NOME,1,30);
						,TRB1->A1_EST;
						,TRB1->E3_BASE; 
						,Round(TRB1->E3_BASE * (TRB1->D2_COMIS1/100),2); 
						,IF(!EMPTY(TRB1->E1_BAIXA),"S","N");
						,TRB1->D2_TOTAL; 
						,TRB1->D2_COMIS1; 
						,Round(TRB1->D2_TOTAL * (TRB1->D2_COMIS1/100),2); 
						,TRB1->D2_PEDIDO;
						,TRB1->D2_ITEM;
						,TRB1->D2_COD;
						,_CalcParc(TRB1->E4_COND)})			
					

			TRB1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
			
		EndDo

		nVlBase1  := 0	
		nVlComis1 := 0
		nVlTotal  := 0
		nVlComis2 := 0

		For _nTit := 1 to Len(atitulo)
		
			IncRegua("Imprimindo...")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o cancelamento pelo usuario...                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			//Dados dos títulos a receber (SE1)								Dados das Comissões (SE3)	Dados dos Itens das Notas Fiscais (SD2)
			//Título / NF	Prefixo/Série	Parcela	Emissão	Vencto Real	Nome Cliente	UF	Valor Total	Valor Comissão	Valor Movimento	% Comissão	Valor Comissão	Pedido	Produto	Já Pago?
			
			lImprime:=.t.
			
			If _ntit > 1
			    
			    _natit:=_ntit-1
			    
			    If atitulo[_natit,12]+atitulo[_natit,13]+atitulo[_natit,14]=atitulo[_ntit,12]+atitulo[_ntit,13]+atitulo[_ntit,14]
				   lImprime:=.f.
                Else
                   lImprime:=.t.
                EndIf
                
            EndIf
			
			nbase1  := atitulo[_ntit,9]/atitulo[_ntit,15]
			nComis1 := atitulo[_ntit,11]/atitulo[_ntit,15]
			
			@nLin,010      PSAY atitulo[_ntit,1]
			@nLin,pcol()+2 PSAY atitulo[_ntit,2]
			@nLin,pcol()+1 PSAY atitulo[_ntit,3]
			@nLin,pcol()+1 PSAY TRANSFORM(nBase1,"@E 999,999,999.99")
			@nLin,pcol()+1 PSAY TRANSFORM(nComis1,"@E 999,999,999.99")
			@nLin,pcol()+1 PSAY atitulo[_ntit,8]
			//@nLin,pcol()+1 PSAY atitulo[_ntit,15] // numero de parcela
			
			If lImprime

				@nLin,pcol()+6 PSAY atitulo[_ntit,4]
				@nLin,pcol()+1 PSAY atitulo[_ntit,5]
				@nLin,pcol()+1 PSAY TRANSFORM(atitulo[_ntit,9],"@E 999,999,999.99")
				@nLin,pcol()+1 PSAY TRANSFORM(atitulo[_ntit,10],"@E 99,999.99")
				@nLin,pcol()+1 PSAY TRANSFORM(atitulo[_ntit,11],"@E 999,999,999.99")
				@nLin,pcol()+1 PSAY atitulo[_ntit,12]
				@nLin,pcol()+1 PSAY atitulo[_ntit,13]
				@nLin,pcol()+1 PSAY atitulo[_ntit,14]

				
				nVlTotal  += atitulo[_ntit,9]
				nVlComis2 += atitulo[_ntit,11]
				nTtTotal  += atitulo[_ntit,9]
				nTtComis2 += atitulo[_ntit,11]

			EndIf
				
			nLin ++ // Avanca a linha de impressao

			nVlBase1  += nBase1
			nVlComis1 += nComis1
			nTtBase1  += nBase1
			nTtComis1 += nComis1

		Next
		
		nLin++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin,031      PSAY Replicate("-",14)
		@nLin,046      PSAY Replicate("-",14)
		@nLin,102      PSAY Replicate("-",14)
		@nLin,pcol()+1 PSAY Space(9)
		@nLin,pcol()+1 PSAY Replicate("-",14)
		
		nLin++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin,031 PSAY TRANSFORM(nVlBase1,"@E 999,999,999.99") 
		@nLin,046 PSAY TRANSFORM(nVlComis1,"@E 999,999,999.99") 
		@nLin,102 PSAY TRANSFORM(nVlTOTAL,"@E 999,999,999.99") 
		@nLin,pcol()+1 PSAY Space(9)
		@nLin,pcol()+1 PSAY TRANSFORM(nVlComis2,"@E 999,999,999.99") 
        
        nLin++
        nLin++
        
	EndDo
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin,000      PSAY "TOTAL DO VENDEDOR "+cVend1
		@nLin,031      PSAY Replicate("-",14)
		@nLin,046      PSAY Replicate("-",14)
		@nLin,102      PSAY Replicate("-",14)
		@nLin,pcol()+1 PSAY Space(9)
		@nLin,pcol()+1 PSAY Replicate("-",14)
		
		nLin++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin,031 PSAY TRANSFORM(nTtBase1,"@E 999,999,999.99") 
		@nLin,046 PSAY TRANSFORM(nTtComis1,"@E 999,999,999.99") 
		@nLin,102 PSAY TRANSFORM(nTtTotal,"@E 999,999,999.99") 
		@nLin,pcol()+1 PSAY Space(9)
		@nLin,pcol()+1 PSAY TRANSFORM(nTtComis2,"@E 999,999,999.99") 
        
        nLin++
        nLin++

        AADD(aTotVend,{cVend1+"-"+SUBSTR(cA3_Nome,1,15),nTtBase1,nTtComis1,nTtTotal,nTtComis2})
        
        
EndDo


If Len(aTotVend) > 0
	
	nLin := 80
	
	For _nTv := 1 to Len(aTotVend)
		
		If _nTv == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,000      PSAY "RESUMO GERAL"
			@nLin,031      PSAY Replicate("-",14)
			@nLin,046      PSAY Replicate("-",14)
			@nLin,102      PSAY Replicate("-",14)
			@nLin,pcol()+1 PSAY Space(9)
			@nLin,pcol()+1 PSAY Replicate("-",14)
			
			nLin++
			nLin++

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin,001 PSAY aTotVend[_nTv,1]
		@nLin,031 PSAY TRANSFORM(aTotVend[_nTv,2],"@E 999,999,999.99")
		@nLin,046 PSAY TRANSFORM(aTotVend[_nTv,3],"@E 999,999,999.99")
		@nLin,102 PSAY TRANSFORM(aTotVend[_nTv,4],"@E 999,999,999.99")
		@nLin,pcol()+1 PSAY Space(9)
		@nLin,pcol()+1 PSAY TRANSFORM(aTotVend[_nTv,5],"@E 999,999,999.99")
		
		nLin++
		nLin++
		
		nGerVen1 += aTotVend[_nTv,2]
		nGerVen2 += aTotVend[_nTv,3]
		nGerVen3 += aTotVend[_nTv,4]
		nGerVen4 += aTotVend[_nTv,5]
		
	Next _nTV
	
EndIf

@nLin,000      PSAY "TODOS GERAL"
@nLin,031      PSAY Replicate("-",14)
@nLin,046      PSAY Replicate("-",14)
@nLin,102      PSAY Replicate("-",14)
@nLin,pcol()+1 PSAY Space(9)
@nLin,pcol()+1 PSAY Replicate("-",14)

nLin++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

@nLin,031 PSAY TRANSFORM(nGerVen1,"@E 999,999,999.99")
@nLin,046 PSAY TRANSFORM(nGerVen2,"@E 999,999,999.99")
@nLin,102 PSAY TRANSFORM(nGerVen3,"@E 999,999,999.99")
@nLin,pcol()+1 PSAY Space(9)
@nLin,pcol()+1 PSAY TRANSFORM(nGerVen4,"@E 999,999,999.99")

nLin++
nLin++

roda(cbcont,cbtxt,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRB1->(dbCloseArea())

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function _fMontaQuery()

Local cQuery
LOcal CR := chr(13) + chr(10)

cQuery := CR + "SELECT SE1.E1_FILIAL,SE1.E1_NUM,SE1.E1_PREFIXO,SE1.E1_PARCELA,SE1.E1_EMISSAO,SE1.E1_VALOR,"
cQuery += CR + "SE1.E1_VENCREA, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PEDIDO, SE1.E1_BAIXA, SA1.A1_EST, "
cQuery += CR + "SE1.E1_VEND1,SE1.E1_VEND2,SE1.E1_VEND3,SE1.E1_VEND4,SE1.E1_VEND5,SF2.F2_COND,SE4.E4_COND,"
cQuery += CR + "SE3.E3_BASE,SE3.E3_COMIS E3_COMIS,SE3.E3_PORC,SE3.E3_PEDIDO,SE3.E3_DATA,SE3.E3_VEND, "
cQuery += CR + "SD2.D2_DOC,SD2.D2_COD,SD2.D2_TOTAL,SD2.D2_COMIS1,SD2.D2_PEDIDO,SD2.D2_ITEM,SA1.A1_NOME "
cQuery += CR + "FROM "+RETSQLNAME('SE1')+" SE1 (nolock) "
cQuery += CR + " INNER JOIN "+RetSqlName('SA1')+" SA1 (nolock) ON SA1.A1_LOJA = SE1.E1_LOJA AND " 
cQuery += CR + "  SA1.A1_COD = SE1.E1_CLIENTE"
cQuery += CR + "  AND SA1.D_E_L_E_T_ = ' ' "
cQuery += CR + " LEFT OUTER JOIN "+RetSqlName('SE3')+" SE3 (nolock) ON SE3.E3_FILIAL = SE1.E1_FILIAL  AND "
cQuery += CR + "  SE3.E3_PREFIXO = SE1.E1_PREFIXO AND SE3.E3_NUM = SE1.E1_NUM AND SE3.E3_PARCELA = SE1.E1_PARCELA "
cQuery += CR + "  AND SE3.E3_VEND = SE1.E1_VEND1 AND SE3.D_E_L_E_T_ = ' ' "
cQuery += CR + " INNER JOIN "+RetSqlName('SD2')+" SD2 (nolock) ON SD2.D2_FILIAL = SE1.E1_FILIAL AND "
cQuery += CR + "  SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_SERIE = SE1.E1_PREFIXO AND SE1.E1_PEDIDO = SD2.D2_PEDIDO
cQuery += CR + "  AND SD2.D2_CLIENTE = SE1.E1_CLIENTE AND SD2.D2_LOJA = SE1.E1_LOJA "
cQuery += CR + "  AND SD2.D2_LOCAL >= '"+mv_par15+"'AND SD2.D2_LOCAL <= '"+mv_par16+"' AND SD2.D_E_L_E_T_ = ' ' " 
cQuery += CR + " INNER JOIN "+RetSqlName('SF2')+" SF2 (nolock) ON SF2.F2_FILIAL = SE1.E1_FILIAL AND "
cQuery += CR + "  SF2.F2_DOC = SE1.E1_NUM AND SF2.F2_SERIE = SE1.E1_PREFIXO "
cQuery += CR + "  AND SF2.F2_CLIENTE = SE1.E1_CLIENTE AND SF2.F2_LOJA = SE1.E1_LOJA
cQuery += CR + "  AND SF2.D_E_L_E_T_ = ' ' "
cQuery += CR + " INNER JOIN "+RetSqlName('SE4')+" SE4 (nolock) ON SE4.E4_FILIAL = '"+xFilial("SE4")+"' AND "
cQuery += CR + "  SF2.F2_COND = SE4.E4_CODIGO "
cQuery += CR + "  AND SF2.F2_CLIENTE = SE1.E1_CLIENTE AND SF2.F2_LOJA = SE1.E1_LOJA
cQuery += CR + "  AND SF2.D_E_L_E_T_ = ' ' "
cQuery += CR + " WHERE SE1.E1_VEND1  >= '"+mv_par01+"' " // Vendedor Inicial
cQuery += CR + "  AND SE1.E1_VEND1   <= '"+mv_par02+"' " // Vendedor Final
cQuery += CR + "  AND SE1.E1_EMISSAO >= '"+dtos(mv_par03)+"' " // Data de Emissão Inicial
cQuery += CR + "  AND SE1.E1_EMISSAO <= '"+dtos(mv_par04)+"' " // Data de Emissão Final
cQuery += CR + "  AND SE1.E1_VENCREA >= '"+dtos(mv_par05)+"' " // Vencimento Inicial
cQuery += CR + "  AND SE1.E1_VENCREA <= '"+dtos(mv_par06)+"' " // Vencimento Final  
cQuery += CR + "  AND SE1.E1_BAIXA >= '"+dtos(mv_par07)+"' " // Vencimento Inicial
cQuery += CR + "  AND SE1.E1_BAIXA <= '"+dtos(mv_par08)+"' " // Vencimento Final
cQuery += CR + "  AND SE1.E1_CLIENTE >= '"+mv_par09+"' " // Cliente Inicial
cQuery += CR + "  AND SE1.E1_CLIENTE <= '"+mv_par10+"' " // Cliente Final
cQuery += CR + "  AND SE1.E1_LOJA    >= '"+mv_par11+"' " // Loja Inicial
cQuery += CR + "  AND SE1.E1_LOJA    <= '"+mv_par12+"' " // Loja Final
cQuery += CR + "  AND SE1.E1_PEDIDO  >= '"+mv_par13+"' " // Pedido de Venda Inicial
cQuery += CR + "  AND SE1.E1_PEDIDO  <= '"+mv_par14+"' " // Pedido de Venda Final
If mv_par17 == 1
	cQuery += CR + "  AND SE1.E1_BAIXA  <> ' ' " // Somente Baixados
ElseIf mv_par17 == 2
	cQuery += CR + "  AND SE1.E1_BAIXA  = ' ' " // Somente Baixados
EndIf
cQuery += CR + "  AND SE1.D_E_L_E_T_ = ' ' "
cQuery += CR + "  AND SE1.E1_VEND1 <> ' ' AND SD2.D2_COMIS1 <> 0 "
cQuery += CR + "    ORDER BY SE1.E1_FILIAL,SE1.E1_VEND1,SD2.D2_PEDIDO,SD2.D2_ITEM,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA "

//memowrite("RFIN01.SQL",cQuery)

cQuery := strtran(cQuery,CR,"")

cQuery := CHANGEQUERY(cQuery)

TcQuery cQuery ALIAS TRB1 NEW

TcSetField("TRB1", "E1_EMISSAO", "D", 8, 0)
TcSetField("TRB1", "E1_VENCREA", "D", 8, 0)
TcSetField("TRB1", "E1_VALOR", "N",17,2)
TcSetField("TRB1", "D2_TOTAL", "N",17,2)
TcSetField("TRB1", "D2_COMIS1", "N",17,2)
TcSetField("TRB1", "E3_VALOR","N",17,2)
TcSetField("TRB1", "E3_BASE","N",17,2)
TcSetField("TRB1", "E3_COMIS","N",17,2)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPERG ºAutor  ³Microsiga           º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria perguntas no SX1                                      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()

Local i,j
Local _sAlias := Alias()
Local aRegs   := {}

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)

/// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

AAdd(aRegs,{cPerg,"01","Do Vendedor         ?",".?",".?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"02","Ate Vendedor        ?",".?",".?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"03","Da  Emissão         ?",".?",".?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"04","Ate Emissão         ?",".?",".?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"05","Do Vencimento       ?",".?",".?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"06","Ate Vencimento      ?",".?",".?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"07","Da Baixa            ?",".?",".?","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"08","Ate Baixa           ?",".?",".?","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"09","Do  Cliente         ?",".?",".?","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"10","Ate Cliente         ?",".?",".?","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"11","Da Loja             ?",".?",".?","mv_chb","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"12","Ate Loja            ?",".?",".?","mv_chc","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"13","Do  Pedido          ?",".?",".?","mv_chd","C",06,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"14","Ate Pedido          ?",".?",".?","mv_che","C",06,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"15","Do  Armazem         ?",".?",".?","mv_chf","C",02,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"16","Ate Armazem         ?",".?",".?","mv_chg","C",02,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"17","Somente Baixados    ?",".?",".?","mv_chh","N",02,0,0,"C","","mv_par17","Sim","","","","","Não","","","","","Ambos","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

//funcção que calcula o numero de parcelas de uma Nota
Static Function _CalcParc(_cCond)

Local n
Local nQtParc := 1
Local nTam1   := Len(_cCond)

_cCond1:=_cCond
For n:=1 To nTam1

	nPos:=AT(",",_cCond1)
    If nPos > 0
       _cCond1:=SubStr(_cCond1,nPos+1,Len(Alltrim(_cCond1))-(nPos))
       nQtParc++
    EndIf
    If nPos == 0
       n:=nTam1
    EndIf   
   
Next

Return(nQtParc)