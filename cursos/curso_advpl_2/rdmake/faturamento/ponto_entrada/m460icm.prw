#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460ICM  ºAutor  ³MICROSIGA           º Data ³  14/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na geracao da nota fiscal - altera ICMS   º±±
±±º          ³ Permite alteracao da aliquota de icms e calcula o valor    º±±
±±º          ³ das notas fiscais de saida.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function M460ICM()

Local aAreaAtu		:= GetArea() 
Local nAliqPadr     := 0

private _oDlg
private _nBaseICM	:= _BASEICM // Variavel private disponibilizada para uso no ponto de entrada - Base do ICMS
private _nAliqICM	:= _ALIQICM // Variavel private disponibilizada para uso no ponto de entrada - Aliquota do ICMS
private _nValICM	:= _VALICM  // Variavel private disponibilizada para uso no ponto de entrada - Valor do ICMS
private _nLin 		:= 10

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para atualizar aliquota da nota de saída ³
//³para produto com origem importado e fora do estado. ³
//³com aliquota da nota de entrada diferente de 4      ³
//³Diego Fernandes - 13/09/2013						   ³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nAliqPadr := BGAliqIC(SC6->C6_IDENTB6, SB1->B1_ORIGEM, Substr(SC6->C6_CF,1,1) == "6" ) 
If nAliqPadr > 0
	
	_ALIQICM	:= nAliqPadr
	_VALICM		:= _BASEICM * (nAliqPadr/100)
	
	RestArea(aAreaAtu)
	Return				
EndIf


// Se TES for diferennte de 736/737 e 738, abandona a rotina
if !SC6->C6_TES $ "736/737/738/763/781/782/783"
	return
endif
/*
@ 20,60 to 230, 360 DIALOG _oDlg TITLE "Alteracao de aliquota/valor de ICMS"

@ _nLin, 005 SAY "PEDIDO:   " + SC6->C6_NUM
_nLin := _nLin + 15

@ _nLin, 005 SAY "PRODUTO:  " + SC6->C6_PRODUTO
_nLin := _nLin + 15

@ _nLin, 005 SAY "Base ICMS"
@ _nLin, 50 GET _nBaseICM PICTURE PesqPict("SD2","D2_BASEICM") when .f. Size 76,10
_nLin := _nLin + 15

@ _nLin, 005 SAY "Aliq ICMS (%)"
@ _nLin, 50 GET _nAliqICM PICTURE PesqPict("SD2","D2_PICM") VALID positivo() .and. RecalcICMS() Size 76,10
_nLin := _nLin + 15

@ _nLin, 005 SAY "Valor ICMS"
@ _nLin, 50 GET _nValICM PICTURE PesqPict("SD2","D2_VALICM") WHEN .F. Size 76,10
_nLin := _nLin + 15

@ _nLin,080 BMPBUTTON TYPE 1 ACTION AlteraICMS()
@ _nLin,115 BMPBUTTON TYPE 2 ACTION close(_oDlg)

_oDlg:Refresh()
ACTIVATE DIALOG _oDlg CENTERED

return

// Recalcula o valor do ICMS
static function RecalcICMS()
_nValICM := round(_nBaseICM * _nAliqICM /100 , TamSX3("D2_VALICM")[2])
return(.T.)

// Funcao para alterar as variaveis que serao retornadas para o programa 
static function AlteraICMS()
_BASEICM  	:= _nBaseICM	
_ALIQICM 	:= _nAliqICM
_VALICM 	:= _nValICM 
close(_oDlg)
return
*/    
                    
dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA)	
	If SA1->A1_EST <> "SP" //( São Paulo) a operação é normal
		If SA1->A1_CONTRIB <> "1" //NÃO CONTRUENTES DO ICMS ( Pessoa física e pessoa jurídica sem Inscrição Estadual) - 18%
			_nAliqICM := 18		
		Else
			Do Case
				Case Alltrim(SA1->A1_EST) $ "DF#GO#MS#MT#AC#AM#AP#PA#RO#RR#TO#AL#BA#CE#MA#PB#PE#PI#RN#SE#ES" //7% (sete por cento) para as mercadorias ou bens destinados para as  Regiões Norte, Nordeste e Centro-Oeste e do Estado do Espírito Santo
					_nAliqICM := 7		
				Case Alltrim(SA1->A1_EST) $ "MG#RJ" //12% (doze por cento) para as mercadorias ou bens procedentes das Regiões Sul e Sudeste
					_nAliqICM := 12	
			EndCase
		
		Endif
		_nValICM := round(_nBaseICM * _nAliqICM /100 , TamSX3("D2_VALICM")[2])
		_BASEICM  	:= _nBaseICM	
		_ALIQICM 	:= _nAliqICM
		_VALICM 	:= _nValICM 
	Endif
Endif
	
RestArea(aAreaAtu)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BGAliqIC  ºAutor  ³Diego Fernandes     º Data ³  09/13/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tratamento para atualizar aliquota da nota de saída         º±±
±±º          ³para produto com origem importado e fora do estado,         º±±
±±º          ³onde aliquota da nota de entrada e diferente de 4           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BGAliqIC(cIdentB6, cOrigem, lInterEst )
                  
Local cQuery   := ""

Local aAreaATU := GetArea()

Local nAliICMS := 0
Local nAliqPadr:= 4

If lInterEst .And. !Empty(cIdentB6) .And. Alltrim(cOrigem) $ "1/2/3/4"//Incluido origem 4 - Solicitado pelo carlão

	cQuery := " SELECT D1_PICM FROM "+RetSqlName("SD1")+" "
	cQuery += " WHERE D1_IDENTB6 = '"+cIdentB6+"' "
	cQuery += " AND D1_FILIAL = '"+xFilial("SD1")+"' "
	cQuery += " AND D_E_L_E_T_ = '' "
	                           
	If Select("TSQL") > 0
		TSQL->(dbCloseArea())
	EndIf
		                                 
	TCQUERY cQuery NEW ALIAS "TSQL"  
	
	dbSelectArea("TSQL")
	TSQL->(dbGotop())
	
	If TSQL->(!Eof())
		//If TSQL->D1_PICM <> nAliqPadr
			nAliICMS := nAliqPadr
		//EndIf
	EndIf             

EndIf

RestArea(aAreaATU)
   	
Return( nAliICMS )