#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTR28    บAutor  ณMarcos Zanetti GZ   บ Data ณ  21/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Checagem de fechamento de estoque                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Podem ser feitas as checagens por                          บฑฑ
ฑฑบ          ณ - Produto                                                  บฑฑ
ฑฑบ          ณ - Lotes                                                    บฑฑ
ฑฑบ          ณ - Enderecamento                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Galderma                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function ESTR28()

private cPerg := "ESTR28"
//memowrite("\LOGRDM\"+ALLTRIM(PROCNAME())+".LOG",Dtoc(date()) + " - " + time() + " - " +cusername)

u_GerA0003(ProcName())

validperg()

if pergunte(cPerg,.T.)
	
	if mv_par05 == 1 // Compara Produtos
		U_ESTR28A(mv_par01, mv_par02, mv_par03, mv_par04)
	endif
	
	if mv_par06 == 1 // Compara Lotes
		U_ESTR28B(mv_par01, mv_par02, mv_par03, mv_par04)
	endif
	
	if mv_par07 == 1 // Compara Endereco
		U_ESTR28C(mv_par01, mv_par02, mv_par03, mv_par04)
	endif
	
	if mv_par08 == 1 // Compara Produto x Lote x Endereco
		U_ESTR28D(mv_par02, mv_par03, mv_par04)
	endif
	
	if mv_par09 <> 3 // Previsao de fechamento Produto x Lote x Endereco
		U_ESTR28E(mv_par02, mv_par03, mv_par04, mv_par09 == 1)
	endif
	
endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMarcos Zanetti GZ   บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VALIDPERG()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Fechamento Inicial" 	,"Fechamento Inicial"	,"Fechamento Inicial"	,"mv_ch1","D",08,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Fechamento Final"   	,"Fechamento Final"		,"Fechamento Final"		,"mv_ch2","D",08,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Filial"			      	,"Filial"			   	,"Filial"			   	,"mv_ch3","C",02,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Destino"			   	,"Destino"			   	,"Destino"			   	,"mv_ch4","N",01,0,0,"C","",""		,"",,"mv_par04","Relatorio","","","","Planilha Excel","","","","","","","","","","","")
PutSX1(cPerg,"05","Compara Produto"	   	,"Compara Produto"		,"Compara Produto"		,"mv_ch5","N",01,0,0,"C","",""		,"",,"mv_par05","Sim","","","","Nao","","","","","","","","","","","")
PutSX1(cPerg,"06","Compara Lotes"	    	,"Compara Lotes"	   	,"Compara Lotes"		   ,"mv_ch6","N",01,0,0,"C","",""		,"",,"mv_par06","Sim","","","","Nao","","","","","","","","","","","")
PutSX1(cPerg,"07","Compara Endereco"   	,"Compara Endereco"		,"Compara Endereco"		,"mv_ch7","N",01,0,0,"C","",""		,"",,"mv_par07","Sim","","","","Nao","","","","","","","","","","","")
PutSX1(cPerg,"08","Prod x Lotes x End" 	,"Prod x Lotes x End"	,"Prod x Lotes x End"	,"mv_ch8","N",01,0,0,"C","",""		,"",,"mv_par08","Sim","","","","Nao","","","","","","","","","","","")
PutSX1(cPerg,"09","Previsao Fechamento"	,"Previsao Fechamento"	,"Previsao Fechamento"	,"mv_ch9","N",01,0,0,"C","",""		,"",,"mv_par09","Com Diferencas","","","","Todos","","","Nao","","","","","","","","")

Return