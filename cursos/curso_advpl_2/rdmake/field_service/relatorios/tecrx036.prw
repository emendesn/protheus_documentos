#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TECRX036 º Autor ³ Edson Rodrigues    º Data ³  18/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para gerar relatorio de divergencia               º±±
±±º          ³ no apontamento de producao Sony Refurbish.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH - Sony                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                     




User Function TECRX036(_aErros,lcont)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relação de Divergencias Sony Refurbish"
Local cPict         := ""
Local titulo        := "Relação de Divergencias Sony Refurbish"
Local nLin          := 80
Local Cabec1        := " OS      IMEI            APARELHO/PECA     DIVIRGENCIA                                          SOLUCAO                               "
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "G"
Private nomeprog    := "TECRX036"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "TECRX036"
Private cString     := "ZZ3"             
Private _cDirori    := GetMv("MV_DIRSONR")  
Private _carqnome   :="\Erro_Proc_SERF"+StrZero(year(dDataBase),4)+ StrZero(Month(dDataBase),2) + StrZero(Day(dDataBase),2) + Substr(Time(),1,2) + Substr(Time(),4,2)+".TXT"
Private cArqTxt := _cDirori+_carqnome
Private nHdl  
  
Private cEOL    := "CHR(13)+CHR(10)"


u_GerA0003(ProcName())

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

if File( cArqTxt )
	nHdl := FOpen( cArqTxt, 1 )
	if nHdl >= 0
		FSeek( nHdl, 0, 2 )
	endif
else
	nHdl := FCreate( cArqTxt )
endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

dbSelectArea(cString)
dbSetOrder(1)

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,_aErros,lcont) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  16/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,_aErros,lcont)

Local nOrdem
Local nTamLin, cLin, cCpo
Local _nStatus   := 0
local _aAreaZZ4  := ZZ4->(GetArea())
local _aAreaZZ7  := ZZ7->(GetArea())
local _aAreaAB6  := AB6->(GetArea())
local _aAreaAB7  := AB7->(GetArea())
local _aAreaAB9  := AB9->(GetArea())
local _aAreaZZ3  := ZZ3->(GetArea())   
local _aAreaSZ9  := SZ3->(GetArea())          


ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
ZZ3->(dbSetOrder(1)) // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS+ZZ3_SEQ
ZZ7->(dbSetOrder(3)) // ZZ7_FILIAL + ZZ7_IMEI + ZZ7_NUMOS+ZZ7_SEQ
AB6->(dbSetOrder(1)) // AB6_FILIAL + AB6_NUMOS
AB7->(DBOrderNickName('AB7NUMSER'))//AB7->(dbSetOrder(6)) // AB7_FILIAL + AB7_NUMOS + AB7_NUMSER      
AB9->(DBOrderNickName('AB9SNOSCLI'))//AB9->(dbSetOrder(7)) // AB9_FILIAL + AB9_SN + AB9_NUMOS + AB9_CODCLI + AB9_LOJA
SZ9->(dbSetOrder(2)) // Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Len(_aErros))

For x := 1 to Len(_aErros)
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
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		nLin := 8
	Endif 
	

	@nLin,001 PSAY alltrim(_aErros[x,4]) //OS
	@nLin,008 PSAY ALLtrim(_aErros[x,5]) //IMEI
	IF LEFT(_aErros[x,9],7)='ERRAPON'
	   @nLin,025 PSAY alltrim(_aErros[x,1]) // APARELHO
	ELSE
	   @nLin,025 PSAY alltrim(_aErros[x,2]) // PECA
	ENDIF   
	@nLin,042 PSAY LEFT(alltrim(_aErros[x,9]),60) // DIVERGENCIA
	@nLin,096 PSAY LEFT(alltrim(_aErros[x,10]),60) // SOLUCAO
	
	cLin := ""
	cLin += alltrim(_aErros[x,4]) + ";" // OS
	cLin += ALLtrim(_aErros[x,5]) + ";" // IMEI
	IF LEFT(_aErros[x,9],7)='ERRAPON'
	   cLin += alltrim(_aErros[x,1]) + ";" // APARELHO
	ELSE
	   cLin += alltrim(_aErros[x,2]) + ";" // PECA
	ENDIF   
	cLin += _aErros[x,9] + ";" // DIVIRGENCIA
	cLin += _aErros[x,10] // SOLUCAO
	cLin += cEol
           
    dbselectarea("SZ9")
    IF SZ9->(dbSeek(xFilial("SZ9") + _aErros[x,5] + alltrim(_aErros[x,4]) ))       
    //DELETA APONTAMENTO REFERENTE A FASE ESTORNADA - Edson Rodrigues - 20/07/09
	    While SZ9->(!eof()) .AND. (left(SZ9->Z9_NUMOS,6) == alltrim(_aErros[x,4])) .And. (SZ9->Z9_IMEI == _aErros[x,5]) .And. (SZ9->Z9_SEQ == alltrim(_aErros[x,11]))
	       RecLock("SZ9",.F.)
              SZ9->Z9_STATUS := cValToChar(_nStatus)
		   MsUnlock()
		   
		   dbselectarea("ZZ3")           
           IF ZZ3->(dbSeek(xFilial("ZZ3") + SZ9->Z9_IMEI + left(SZ9->Z9_NUMOS,6))) 
              IF (ZZ3->ZZ3_SEQ == SZ9->Z9_SEQ)           
	           RecLock("ZZ3",.F.)
	  	          ZZ3->ZZ3_STATUS := cValToChar(_nStatus)
	           MsUnlock()  
	          ENDIF      
           ENDIF
 	       
 	       dbselectarea("ZZ4")
           IF ZZ4->(dbSeek(xFilial("ZZ4") + _aErros[x,5] + alltrim(_aErros[x,4]) ))
	           RecLock("ZZ4",.F.)
	  	          ZZ4->ZZ4_STATUS := "4"
	           MsUnlock()       
 	       ENDIF
 	       //If lcont
 	          dbselectarea("AB6")                  
 	          if AB6->(dbSeek(xFilial("AB6") + alltrim(_aErros[x,4]))) .and. AB6->AB6_STATUS == 'B' 
 	             reclock("AB6",.f.)
				    AB6->AB6_STATUS := 'A'
			     msunlock()
		      Endif
		  	 
 	          dbselectarea("AB7")
 	          if AB7->(dbSeek(xFilial("AB7") + alltrim(_aErros[x,4]) + _aErros[x,5] )) .and. AB7->AB7_TIPO == '4' 
          	     reclock("AB7",.f.)
				   AB7->AB7_TIPO   := '3'
			     msunlock()
 	          Endif
 	      
              dbselectarea("AB9")
 	          if AB9->(dbSeek(xFilial("AB9") + _aErros[x,5] + alltrim(_aErros[x,4]+"01" ))) 
          	     reclock("AB9",.f.)
				   dbdelete()
			     msunlock()
 	          Endif	       
 	       //Endif                 
 	      dbselectarea("SZ9") 
 	      SZ9->(dbSkip())
	    EndDo
	Endif  
    dbselectarea("ZZ7")                           
    IF ZZ7->(dbSeek(xFilial("ZZ7") + _aErros[x,5] + alltrim(_aErros[x,4])))                                  
	   While ZZ7->(!eof()) .AND. (left(ZZ7->ZZ7_NUMOS,6) == alltrim(_aErros[x,4])) .And. (ZZ7->ZZ7_IMEI == _aErros[x,5]) .And. (ZZ7->ZZ7_SEQ == alltrim(_aErros[x,11]))
	       RecLock("ZZ7",.F.)
		       ZZ7->ZZ7_STATUS := cValToChar(_nStatus)
		   MsUnlock()                                                   
          ZZ7->(dbSkip())
       Enddo   
    ENDIF
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
       If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
    //³ cao anterior.                                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    
	nLin := nLin + 1
	if len(_aErros) > x .and. _aErros[x,1] <> _aErros[x+1,1]
		nLin := nLin + 1
	endif	
Next x   

fClose(nHdl)
//Close(oGeraTxt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
restarea(_aAreaZZ4)
restarea(_aAreaZZ3)
restarea(_aAreaZZ7)
restarea(_aAreaAB9)
restarea(_aAreaAB6)
restarea(_aAreaAB7)
restarea(_aAreaSZ9)

Return
