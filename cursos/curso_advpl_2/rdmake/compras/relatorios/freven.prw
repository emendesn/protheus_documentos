#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FREVEN   ³ Autor ³ CLAUDIA               ³ Data ³ 09/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³COM - AMARRACAO DE FRETE SOBRE VENDAS                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      COMPRAS                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/                  
User Function FreVen()
Local cString    := "Z11"
Local cdesc1     := "Relatorio de Controle de frete de vendas por Nota "
Local cdesc2     := "Fiscal de Entrada. Este programa seleciona as NFE´s conforme"
Local cdesc3     := "parametro selecionado, e lista todas as vendas amarradas."
Local wnrel      := "FREVEN"

Private aReturn  := { "ZEBRADO", 1,"ADMINISTRACAO", 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private nLastKey := 0
Private Titulo   := "Relatorio de Controle de Frete de Vendas "
Private Tamanho  := "G"
Private nomeprog := "FREVEN"
Private lmaqui   := .f.
Private cperg    := "XFREVEN"

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para qarametros!                        ³
//³ mv_par01     // De Nota Fiscal de entrada                    ³
//³ mv_par02     // Ate Nota Fiscal de entrada                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValPerg() // VERIFICA E CRIA A PERGUNTA SE NECESSÁRIO


Pergunte(cperg,.F.)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If nLastKey = 27
   Set Filter To
   Return
EndIf

SetDefault(aReturn,cString)
RptStatus({|lEnd| RCFRETImp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RCFUNImp  ³ Autor ³ CLAUDIA              ³ Data ³ 20/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CUSTFUN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RCFRETImp(lEnd,wnRel,titulo,tamanho)

Local cRodaTxt := "", i 
Local nCntImpr := 0

Private li := 80 ,m_pag := 1
Private CABEC1, CABEC2                                                                                                  
/*/

                     1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9
           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
************************************************************************************************************************************
	       Filial Conhec Serie Emissao    Transportadora/Loja                        QTDE CONHEC       Total Conhecimento NF Venda Serie Emissao    Cliente/Loja                               QTDE VENDA        TOTAL NF VENDA
	       99     XXXXXX XXXXX 99/99/9999 XXXXXX/XX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999999.999999 9.999.999.999.999,99 XXXXXX   XXX   99/99/9999 XXXXXX/XX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999999.99 9,999.999.999.999,99
	       		  TOTAL Conhecimento                                                 9.999.999.999.999,99																       9,999.999.999.999,99
	              TOTAL Vendas                                                    
	              TOTAL GERAL                                                        9.999.999.999.999,99                                                                      9,999.999.999.999,99           
*/
CABEC1 := "FILIAL CONHEC SERIE EMISSAO    TRANSPORTADORA/LOJA                        QTDE CONHEC       TOTAL CONHECIMENTO NF       SERIE EMISSAO    CLIENTE/FORNECEDOR/LOJA                    QTDE              TOTAL NF      "
CABEC2 := "------ ------ ----- ---------- ------------------------------------------ --------------- -------------------- -------- ----- ---------- ------------------------------------------ ----------- --------------------" 

nTipo := IIF(aReturn[4]==1,15,18)

// Alterado de 06 para 09 devido a nova versao P10

aCampos  := {}
AAdd(aCAMPOS,{"FILIAL"   ,"C",02,0})
AAdd(aCAMPOS,{"CONHEC"   ,"C",06,0})
AAdd(aCAMPOS,{"SERIE"    ,"C",03,0})
AAdd(aCAMPOS,{"EMISSAO"  ,"D",08,0})
AAdd(aCAMPOS,{"TRANSPO"  ,"C",06,0})
AAdd(aCAMPOS,{"LOJATRA"  ,"C",02,0})
AAdd(aCAMPOS,{"NOMETRA"  ,"C",30,0})
AAdd(aCAMPOS,{"TOTQTCON" ,"N",17,6})
AAdd(aCAMPOS,{"TOTCONHEC","N",16,2})
AAdd(aCAMPOS,{"NFVENDA"  ,"C",09,0}) 
AAdd(aCAMPOS,{"SERVENDA" ,"C",03,0})
AAdd(aCAMPOS,{"EMISVENDA","D",08,0})
AAdd(aCAMPOS,{"CLIENTE"  ,"C",06,0})
AAdd(aCAMPOS,{"LOJACLI"  ,"C",02,0})
AAdd(aCAMPOS,{"NOMECLI"  ,"C",30,0})
AAdd(aCAMPOS,{"TOTQTVEN" ,"N",11,2})
AAdd(aCAMPOS,{"TOTVENDA" ,"N",16,2})

cTRB1 := CriaTrab(aCAMPOS)
dbUseArea(.T.,,cTRB1,"TRB",.f.)  
cInd1TRB1 := CriaTrab(Nil, .F.)

IndRegua("TRB",cInd1TRB1,"FILIAL+DTOS(EMISSAO)+CONHEC+SERIE+TRANSPO+LOJATRA+NFVENDA+SERVENDA+CLIENTE+LOJACLI",,,"Selecionando Registros...") //"Selecionando Registros..."
          
dbClearIndex()
dbSetIndex(cInd1TRB1 + OrdBagExt())    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Possiciona os arquivos para processamento                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SF1")
DbSetOrder(1)

DbSelectArea("SA2")
DbSetOrder(1)

DbSelectArea("SA1")
DbSetOrder(1)

DbSelectArea("Z11")
DbSetOrder(1)           
DbGoTop()
If !Empty(MV_PAR01)
	DbSeek(MV_PAR01,.t.)
	If !Empty(MV_PAR03)
		DbSeek(MV_PAR01+MV_PAR03,.t.)		
			IF !EMPTY(MV_PAR05)
				DbSeek(MV_PAR01+MV_PAR03+MV_PAR05,.t.)
			ENDIF
	EndIF
EndIf
SetRegua(LastRec())
While !Eof() .And. Z11->Z11_FILIAL >= MV_PAR01 .And. Z11->Z11_FILIAL <= MV_PAR02 .AND. ;
				   Z11->Z11_CTRNFE >= MV_PAR03 .AND. Z11->Z11_CTRNFE <= MV_PAR04 .AND. ;
				   Z11->Z11_SERIE  >= MV_PAR05 .AND. Z11->Z11_SERIE  <= MV_PAR06

	IncRegua()
   	If !EMPTY(MV_PAR07) .AND. Z11->Z11_EMISSAO <= MV_PAR07
    	DbSkip()
      	Loop
	EndIf       
	If !EMPTY(MV_PAR08) .AND. Z11->Z11_EMISSAO >= MV_PAR08
    	DbSkip()
      	Loop
	EndIf              
	DbSelectArea("SF1")     
	MsSeek(Z11->Z11_FILIAL + Z11->Z11_CTRNFE + Z11->Z11_SERIE + Z11->Z11_FORNECE + Z11->Z11_LOJA,.t.)                                                                                        
	DbSelectArea("SD1")     
	DbSetOrder(1)
	MsSeek(Z11->Z11_FILIAL + Z11->Z11_CTRNFE + Z11->Z11_SERIE + Z11->Z11_FORNECE + Z11->Z11_LOJA,.t.)                                                                                        
	ntotcon := 0
	Do While !Eof() .and. SD1->D1_FILIAL+SD1->D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == Z11->Z11_FILIAL + Z11->Z11_CTRNFE + Z11->Z11_SERIE + Z11->Z11_FORNECE + Z11->Z11_LOJA
		nTotcon += SD1->D1_QUANT
		DbSkip()
	EndDo 
	DbSelectArea("SD2")     
	DbSetOrder(3)
	if MsSeek(Z11->Z11_FILIAL + Z11->Z11_DOC + Z11->Z11_SERIESA + Z11->Z11_CLIENTE + Z11->Z11_LOJACLI,.t.)                                                                                        
		ntotven := 0
		Do While !Eof() .and. SD2->D2_FILIAL+SD2->D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == Z11->Z11_FILIAL + Z11->Z11_DOC + Z11->Z11_SERIESA + Z11->Z11_CLIENTE + Z11->Z11_LOJACLI
			nTotVEN += SD2->D2_QUANT
			DbSkip()
		EndDo         
	Else
		DbSelectArea("SD1")              
		MsSeek(Z11->Z11_FILIAL + Z11->Z11_DOC + Z11->Z11_SERIESA + Z11->Z11_CLIENTE + Z11->Z11_LOJACLI,.t.)                                                                                        
		ntotven := 0
		Do While !Eof() .and. SD1->D1_FILIAL+SD1->D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == Z11->Z11_FILIAL + Z11->Z11_DOC + Z11->Z11_SERIESA + Z11->Z11_CLIENTE + Z11->Z11_LOJACLI
			nTotVEN += SD1->D1_QUANT
			DbSkip()
		EndDo         
		
	ENDIF
	DbSetOrder(1)
	DbSelectArea("Z11")
	ckey := Z11->Z11_FILIAL + DTOS(Z11->Z11_EMISSAO)  + Z11->Z11_CTRNFE + Z11->Z11_SERIE + Z11->Z11_FORNECE + Z11->Z11_LOJA + Z11->Z11_DOC + Z11->Z11_SERIESA + Z11->Z11_CLIENTE + Z11->Z11_LOJACLI
    If !TRB->(DbSeek(cKey))
       	TRB->(DbAppend())
       	TRB->FILIAL    := Z11->Z11_FILIAL
       	TRB->CONHEC    := Z11->Z11_CTRNFE
       	TRB->SERIE     := Z11->Z11_SERIE
       	TRB->EMISSAO   := Z11->Z11_EMISSAO
       	TRB->TRANSPO   := Z11->Z11_FORNECE
       	TRB->LOJATRA   := Z11->Z11_LOJA
       	TRB->NOMETRA   := If(SA2->(DbSeek(XFILIAL("SA2")+Z11->Z11_FORNECE+Z11->Z11_LOJA)),SUBSTR(SA2->A2_NOME,1,30),"")
      	TRB->TOTQTCON  := NTOTCON
       	TRB->TOTCONHEC := SF1->F1_VALBRUT
       	TRB->NFVENDA   := Z11->Z11_DOC
       	TRB->SERVENDA  := Z11->Z11_SERIESA
       	TRB->EMISVENDA := Z11->Z11_EMISNFV
       	TRB->CLIENTE   := Z11->Z11_CLIENTE
       	TRB->LOJACLI   := Z11->Z11_LOJACLI
       	TRB->NOMECLI   := If(SA1->(DbSeek(XFILIAL("SA1")+Z11->Z11_CLIENTE+Z11->Z11_LOJACLI)),SUBSTR(SA1->A1_NOME,1,30),"")
       	TRB->TOTQTVEN  := NTOTVEN
       	TRB->TOTVENDA  := Z11->Z11_VLRNFV
    EndIf
	DbSelectArea("Z11")
   	Dbskip()
EndDo
nTOTGERCON := 0
NTOTGERVEN := 0
ntgerQTven := 0
ntgerQTcon := 0
DbSelectArea("TRB")
DbGoTop()
SetRegua(LastRec())
While !Eof()
	IncRegua()
    DbSelectArea("TRB")
    NGSOMALI(58)
    @ Li,000 Psay TRB->Filial 
    @ LI,007 Psay TRB->Conhec
    @ li,014 Psay TRB->Serie
    @ li,020 Psay Dtoc(TRB->Emissao)
    @ li,031 Psay alltrim(TRB->Transpo)+'/'+alltrim(TRB->LojaTra)+' - '+TRB->NomeTra
    @ li,074 Psay TRB->TotQtCon  Picture "@E 99999999.999999"
    @ li,090 Psay TRB->TotConhec Picture "@E 9,999,999,999,999.99"
    nTotCON := 0
    nTotVEN := 0               
    ntotqtven := 0
    ntotqtcon := 0
    CCONHEC := TRB->FILIAL + TRB->CONHEC + TRB->SERIE + TRB->Transpo + TRB->LojaTra
    nTOTCON    += TRB->TOTCONHEC
    ntotqtcon  += TRB->TotQtCon    
    ntgerQTcon += TRB->TotQtCon
    nTOTGERCON += TRB->TOTCONHEC
    While !Eof() .And. TRB->Filial + TRB->CONHEC + TRB->SERIE + TRB->Transpo + TRB->LojaTra  == CCONHEC
    	@ LI,111 Psay TRB->NfVenda
	    @ li,120 Psay TRB->SerVenda
    	@ li,126 Psay Dtoc(TRB->EmisVenda)
	    @ li,137 Psay alltrim(TRB->Cliente)+'/'+alltrim(TRB->LojaCli)+' - '+TRB->NomeCli
	    @ li,180 Psay TRB->TotQtVen Picture "@E 99999999.99"
    	@ li,198 Psay TRB->TotVenda Picture "@E 9,999,999,999,999.99"     
    	NGSOMALI(58)
        nTOTGERVEN += TRB->TOTVENDA    
        nTOTVEN    += TRB->TOTVENDA    
        ntgerQTven += TRB->TotQtVen
        ntotQTven  += TRB->TotQtVen
    	DbSkip()
    End 
                 
    @ li,000 Psay "Total do conhecimento de frete esta " + Iif(NtotCon > NTotVen,"divergente "," OK")
    @ li,074 Psay NTotqtcon Picture "@E 99999999.999999"       
    @ li,090 Psay NTotCon   Picture "@E 9,999,999,999,999.99"       
    @ li,180 Psay NTotqtven Picture "@E 99999999.99"       
    @ li,198 Psay NTotVen   Picture "@E 9,999,999,999,999.99"     
    NGSOMALI(58)      
   	NGSOMALI(58)
End                                          
@ Li,000 Psay "Total Geral "                                     
@ li,074 Psay NTGerqtcon Picture "@E 99999999.999999"       
@ li,090 Psay NTotGerCon Picture "@E 9,999,999,999,999.99"       
@ li,180 Psay NTGerqtven Picture "@E 99999999.99"       
@ li,198 Psay NTotGerVen Picture "@E 9,999,999,999,999.99"     

NGSOMALI(58)
NGSOMALI(58)
Roda(nCntImpr,cRodaTxt,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apaga arquivo de Trabalho                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "TRB" )
Use  
FErase(cTRB1 + GetDbExtension())
FErase(cInd1TRB1 + OrdBagExt()) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("Z11")

Set Filter To
Set device to Screen

If aReturn[5] = 1
   Set Printer To
   dbCommitAll()
   OurSpool(wnrel)
Endif
MS_FLUSH()
Return Nil



Static Function ValPerg()
_cSavAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

//                  1   2                       3    4      5      6  7  8 9  10  1                                                   2       3   4     5    6  7    8  9   20   21   22   23   24   25  26  27   28   29  30  31   32   33  34  35 36    37  38  39  40  41  42
AADD(aRegs,{cPerg,"01","De Filial        ", "" , "" ,"mv_ch1","C",02,0,0,"G","","mv_par01","", "" , "" , "", "", "", "", "" , "" , "" , "" , "" , "", "", "" , "" , "", "", "" , "" , "", "", "","CTT","", "", "", "", "", ""})
AADD(aRegs,{cPerg,"02","Até Filial       ", "" , "" ,"mv_ch2","C",02,0,0,"G","","mv_par02","", "" , "" , "", "", "", "", "" , "" , "" , "" , "" , "", "", "" , "" , "", "", "" , "" , "", "", "","CTT","", "", "", "", "", ""})
AADD(aRegs,{cPerg,"03","De Conhecimento  ", "" , "" ,"mv_ch3","C",06,0,0,"G","","mv_par03","", "" , "" , "", "", "", "", "" , "" , "" , "" , "" , "", "", "" , "" , "", "", "" , "" , "", "", "","SF1","", "", "", "", "", ""})
AADD(aRegs,{cPerg,"04","Até Conhecimento ", "" , "" ,"mv_ch4","C",06,0,0,"G","","mv_par04","", "" , "" , "", "", "", "", "" , "" , "" , "" , "" , "", "", "" , "" , "", "", "" , "" , "", "", "","SF1","", "", "", "", "", ""})
AADD(aRegs,{cPerg,"05","De serie         ", "" , "" ,"mv_ch5","C",03,0,0,"G","","mv_par05","", "" , "" , "", "", "", "", "" , "" , "" , "" , "" , "", "", "" , "" , "", "", "" , "" , "", "", "","CTT","", "", "", "", "", ""})
AADD(aRegs,{cPerg,"06","Até serie        ", "" , "" ,"mv_ch6","C",03,0,0,"G","","mv_par06","", "" , "" , "", "", "", "", "" , "" , "" , "" , "" , "", "", "" , "" , "", "", "" , "" , "", "", "","CTT","", "", "", "", "", ""})
AADD(aRegs,{cPerg,"07","De Data Emissao  ", "" , "" ,"mv_ch7","D",08,0,0,"G","","mv_par07","", "" , "" , "", "", "", "", "" , "" , "" , "" , "" , "", "", "" , "" , "", "", "" , "" , "", "", "",""   ,"", "", "", "", "", ""})
AADD(aRegs,{cPerg,"08","Até Data Emissao ", "" , "" ,"mv_ch8","D",08,0,0,"G","","mv_par08","", "" , "" , "", "", "", "", "" , "" , "" , "" , "" , "", "", "" , "" , "", "", "" , "" , "", "", "",""   ,"", "", "", "", "", ""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_cSavAlias)
Return