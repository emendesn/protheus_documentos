#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDIAND    บAutor  ณGRAZIELLA BIANCHIN  บ Data ณ  01/30/12   บฑฑ
ฑฑบAlterado  ณEDIAND    บAutor  ณMARCO AURELIO       บ Data ณ  06/28/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGERACAO DE ARQUIVO - EDI  / ANDEANI                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ USO EXCLUSIVO BGH                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _EDI001()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cCadastro := "EDI - Movimenta็ใo"
Private aCores    := {}
Private lUsrAut  	:= .T.
Private lUsrAdm  	:= .T.
Private lUsrEDI		:= .T.
Private cString := "SZX"

u_GerA0003(ProcName())

If lUsrEDI
	Private aRotina := {{"Pesquisar" 	,"AxPesqui"   	, 0, 1},;
					{"Visualizar"	,"AxVisual"   	, 0, 2},;
					{"Gera EDI"   	,"U__EDI002()"	, 0, 3},;
					{"Proc.Conhec" 	,"U__EDI003()"	, 0, 4},;
					{"Proc.Ocorr." 	,"U__EDI003()"	, 0, 4},;
					{"Fitr Romaneio","U__EDI008()"	, 0, 2},;
					{"Relat๓rio"  	,"U__EDI003()"	, 0, 3},;
					{"Legenda"   	,"U__EDI010()"	, 0, 2}	}
Else
	Private aRotina := {{"Pesquisar" 	,"AxPesqui"   	, 0, 1},;
					{"Visualizar"	,"AxVisual"   	, 0, 2},;
					{"Fitr Romaneio","U__EDI008()"	, 0, 2},;
					{"Legenda"   	,"U__EDI010()"	, 0, 2}	}

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cores da Legenda                                                    ณ
//ณ                                                                     ณ
//ณ 1 - EDI Gerado, ainda sem Retorno                                   ณ
//ณ 2 - CTRC Recebido, produto em Transito                              ณ
//ณ 3 - CTRC Recebido, com Ocorrencia                                   ณ
//ณ 4 - CTRC Pendente de Validacao                                      ณ
//ณ 5 - CTRC Bloqueio de Validacao                                      ณ
//ณ 6 - CTRC Liberado para Pre-Nota                                     ณ
//ณ 7 - Pre-Nota Gerada                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aAdd(aCores, {"ZX_STATUS == '1' ", "BR_PRETO"  	})    		// 1 - EDI Gerado, ainda sem Retorno 
aAdd(aCores, {"ZX_STATUS == '2' ", "BR_AMARELO" })    		// 2 - CTRC Recebido, produto em Transito
aAdd(aCores, {"ZX_STATUS == '3' ", "BR_LARANJA"  })    		// 3 - CTRC Recebido, com Ocorrencia 
aAdd(aCores, {"ZX_STATUS == '4' ", "BR_AZUL"  })    		// 4 - CTRC Pendente de Validacao
aAdd(aCores, {"ZX_STATUS == '5' ", "BR_BRANCO"  })    		// 5 - CTRC Bloqueio de Validacao 
aAdd(aCores, {"ZX_STATUS == '6' ", "ENABLE"  })    	  		// 6 - CTRC Liberado para Pre-Nota
aAdd(aCores, {"ZX_STATUS == '7' ", "DISABLE"  })    		// 7 - Pre-Nota Gerada

dbSelectArea(cString)
dbSetOrder(1)
dbSelectArea(cString)
mBrowse(6, 1, 22, 75, cString,,,,,, aCores)

Return
 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDI002    บAutor  ณGRAZIELLA BIANCHIN  บ Data ณ  01/30/12   บฑฑ
ฑฑบAlterado  ณEDI002    บAutor  ณMARCO AURELIO       บ Data ณ  06/28/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGERACAO DE ARQUIVO - EDI  / ANDEANI                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ USO EXCLUSIVO BGH                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _EDI002() 

Local cQuery 	:=	cDirDocs :=	cCrLf := _nSeqAndr := cArquivo	:= _csrvapl  :=  cIdentif	:= ""
Local nLin 		:= nSeq		:=nAt 		:=ndigito  	:=_nValTotal:=_ncont	:= 0
Local aDiverge 	:= {}
Local lDiverge 	:= .f.
Local aSaveArea := ""

Private cPerg	:="EDI001" 
Private nOpca	:= 0  

	ValidPerg(cPerg) // Ajusta as Perguntas do SX1
	Pergunte(cPerg,.F.) // Carrega as Perguntas do SX1

	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Gera EDI - NOTFIS") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Esta rotina ira gerar o arquivo de Remessa do EDI com base nos Romaneios") SIZE 268, 8 OF oDlg PIXEL
	@ 38, 15 SAY OemToAnsi("informados nos parametros. Sera gerado por esta rotina o arquivo padrao NOTFIS.") SIZE 268, 8 OF oDlg PIXEL
	@ 48, 15 SAY OemToAnsi("") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 196 TYPE 5 ACTION pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER

	If nOpca == 1
		MsAguarde({|| EDIAndr()},OemtoAnsi("Processando EDI - NOTFIS"))
	Endif                                       


Return




Static Function EDIAndr() 

Local cQuery 	:=""
Local cDirDocs	:=__reldir            
Local cCrLf		:=Chr(13)+Chr(10) 
Local _nSeqAndr := val(GetMV("MV_SEQADR"))+1
Local cArquivo	:="c:\EDI\"+DTOS(dDatabase)+STRZERO(_nSeqAndr,2)+".txt"
Local cIdentif	:=DTOS(dDatabase)+STRZERO(_nSeqAndr,1)
Local _csrvapl  := ALLTRIM(GetMV("MV_SERVAPL"))
Local nLin 		:= 0
Local nMax 		:= 0
Local nSeq		:= 0 
Local aDiverge 	:= {}
Local nAt 		:= 0
Local lDiverge 	:= .f.
Local ndigito  	:= 0     
Local aSaveArea := GetArea()   
Local _nValTotal:= 0  
Local _ncont	:= 0 


nHandle := MsfCreate(cArquivo,0)

IF Select("TRB1") <> 0 
	DbSelectArea("TRB1")
	DbCloseArea()
Endif    

If empty(MV_PAR01)
	MsgAlert("O Numero do Romaneio Deve ser Informado. Verifique!","Atencao")
	return(.F.)
Endif

If empty(MV_PAR02)
	MsgAlert("A data do Romaneio Deve ser Informada. Verifique!","Atencao")
	return(.F.)
Endif


// Monta Query
cQuery := " SELECT * FROM " + RetSqlName("SF2") + " SF2 "
cQuery += " WHERE "
cQuery += " 	NOT EXISTS ( SELECT 1 FROM " + RetSqlName("SZX") + " SZX " 
cQuery += " 				 WHERE (ZX_FILIAL+ZX_ROMAN+ZX_SERIE+ZX_NOTA = F2_FILIAL+F2_NRROMA+F2_SERIE+RIGHT(F2_DOC,8) )  "
cQuery += " 				 AND SZX.D_E_L_E_T_ <> '*'  ) "
cQuery += " AND F2_NRROMA IN " + FormatIn(alltrim(MV_PAR01),";") + " "
cQuery += " AND SF2.F2_DTROMA = '"+dtos(MV_PAR02)+"' "
cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY F2_CLIENTE,F2_NRROMA "	//F2_NRROMA,F2_CLIENTE

TCQUERY cQuery NEW ALIAS "TRB1"  


if TRB1->(EOF())
	Aviso("EDI Nใo Gerado","O Romanei informado nใo estแ apto a ser processado no EDI.  Verifique!",{"OK"})
	Return(.F.)
endif   


// Verifica se Arquivo esta Vazio
nTotsRec := TRB1->(RECCOUNT())    
TRB1->(dbgotop())


//ProcRegua(nTotsRec)               
nSeq	:= nSeq+1
//UNB - CABECALHO DE INTERCAMBIO
cLinha := "000"	// 01
cLinha += PADR(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,35),35)	// 04
cLinha += PADR("ANDREANI",35) // 39
cLinha += substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(DTOS(dDatabase),3,2) //74
cLinha += PADR(substr(TIME(),1,2)+substr(TIME(),4,2),4)	//80
_vIDNOT	:= PADR("NOT"+substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(TIME(),1,2)+substr(TIME(),4,2)+STRZERO(nSeq,1),12)	//84 
cLinha += _vIDNOT
cLinha += SPACE(145) //96
Fwrite(nHandle, cLinha  + cCrLf)	

//UNH CABECALHO DE DOCUMENTO
cLinha := "310"     // 01
cLinha += PADR("NOTFI"+substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(TIME(),1,2)+substr(TIME(),4,2)+STRZERO(nSeq,1),14)	//04
cLinha += SPACE(223) //18
Fwrite(nHandle, cLinha  + cCrLf)	

//DEM - DADOS DA EMBARCADORA 
	
cLinha := "311"	// 01
cLinha += PADR(SUBSTR(SM0->M0_CGC,1,14),14) //04
cLinha += PADR(SUBSTR(SM0->M0_INSC,1,15),15) //18
cLinha += PADR(SUBSTR(SM0->M0_ENDCOB,1,40),40)	//33
cLinha += PADR(SUBSTR(SM0->M0_CIDCOB,1,15),35)	//73
cLinha += PADR(substr(SM0->M0_CEPCOB,1,5)+"-"+substr(SM0->M0_CEPCOB,6,3),9) // 108
cLinha += PADR(SUBSTR(SM0->M0_ESTENT,1,2),9) //117
cLinha += PADR(SUBSTR(TRB1->F2_DTROMA,7,2)+substr(TRB1->F2_DTROMA,5,2)+substr(TRB1->F2_DTROMA,1,4),8) //126   // DATA DO ROMANEIO
cLinha += PADR(SUBSTR(SM0->M0_NOMECOM,1,40),40)	//134
cLinha += SPACE(67) //174
Fwrite(nHandle, cLinha  + cCrLf)	

DbSelectArea("TRB1")
While !TRB1->(Eof())
//	IncProc()       

	//DES - DADOS DO DESTINATARIO DA MERCADORIA
	DbSelectarea("SA1")
	DBSeek(xFilial("SA1")+TRB1->F2_CLIENTE+TRB1->F2_LOJA)
	
	cLinha := "312"	//001
	cLinha += PADR(SUBSTR(SA1->A1_NOME,1,40),40)	//004
	cLinha += PADR(SA1->A1_CGC,14) //044
	cLinha += PADR(SUBSTR(SA1->A1_INSCR,1,15),15) //058
	cLinha += PADR(SUBSTR(SA1->A1_END,1,40),40)	//073
	cLinha += PADR(SUBSTR(SA1->A1_BAIRRO,1,20),20)	//113
	cLinha += PADR(SUBSTR(SA1->A1_MUN,1,35),35)	//133
	cLinha += PADR(substr(SA1->A1_CEP,1,5)+"-"+substr(SA1->A1_CEP,6,3),9)	//168
	cLinha += SPACE(09)	//177
	cLinha += PADR(SUBSTR(SA1->A1_EST ,1,2),9)  // 186
	cLinha += SPACE(04) //195
	cLinha += PADR(SUBSTR(SA1->A1_DDD+SA1->A1_TEL+space(01)+ A1_FAX,1,35),35)   //199
	
	cLinha += iif(len(SA1->A1_CGC) > 11,"1","2")	//234
	cLinha += "C"	//235
	cLinha += SPACE(05) //236
	
	Fwrite(nHandle, cLinha  + cCrLf)	
	

	DbSelectArea("TRB1")
	_cCliAnt	:= TRB1->F2_CLIENTE
	

	While _cCliAnt == TRB1->F2_CLIENTE .and. TRB1->(!eof())

		//DNF - DADOS DA NOTA FISCAL
		cLinha := "313"	//001
		cLinha += STRZERO(Val(TRB1->F2_NRROMA),15)	//015
		cLinha += SPACE(07)	// 019
		cLinha += "1" //RODOVIARIO	//026
		cLinha += "1" //CARGA FECHADA //027
		cLinha += "1" //FRIA	//028
		cLinha += SUBSTR(iif(empty(TRB1->F2_TPFRETE),"C",TRB1->F2_TPFRETE)	,1,1) //029
		cLinha += PADR(SUBSTR(TRB1->F2_SERIE,1,3),3)	//030
		cLinha += PADR(SUBSTR(TRB1->F2_DOC,2,8),8)	//033
		cLinha += PADR(SUBSTR(TRB1->F2_EMISSAO,7,2)+substr(TRB1->F2_EMISSAO,5,2)+substr(TRB1->F2_EMISSAO,1,4),8)   //041
		cLinha += PADR(SUBSTR("ELETRONICOS",1,15),15)	//049
		cLinha += PADR(SUBSTR("CAIXAS",1,15),15)	//064
		cLinha += STRZERO(1*100,7)         //079	(x 100 para considerar decimais)
		cLinha += STRZERO(TRB1->F2_VALBRUT*100,15)	//086 *********************Transform(SZA->ZA_PRECO,'@E 999,999.99999')
		cLinha += STRZERO(1*100,7)	//101	(x 100 para considerar decimais)
		cLinha += STRZERO(1*100,5)	//108   (x 100 para considerar decimais)

		cLinha += iif(TRB1->F2_VALICM >0,"S","N")	//113
		cLinha += "N"	//114

		cLinha += STRZERO(0*100,15)	//115	(x 100 para considerar decimais)
		cLinha += STRZERO(0*100,15)	//130   (x 100 para considerar decimais)
		cLinha += SPACE(07)	//145
		cLinha += SPACE(01)	//152
		cLinha += STRZERO(0*100,15)	// 153   (x 100 para considerar decimais)

		cLinha += STRZERO(0*100,15)	//168  (x 100 para considerar decimais)
		cLinha += STRZERO(0*100,15)	//183  (x 100 para considerar decimais)
		cLinha += STRZERO(0*100,15) //198 (x 100 para considerar decimais)
		cLinha += "I" //213      INCLUSAO VERFICAR

		cLinha += STRZERO(TRB1->F2_VALICM*100 ,12)	//214  (x 100 para considerar decimais)
		cLinha += STRZERO(TRB1->F2_ICMSRET*100,12)  //226 (x 100 para considerar decimais)
		cLinha += "N"	//238
		cLinha += "01" //239  VERIFICAR
	
		Fwrite(nHandle, cLinha  + cCrLf)
		_nValTotal 	:= _nValTotal + TRB1->F2_VALBRUT
		_ncont 		:= _ncont + 1

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGrava Dados na Tabela EDI - SZX ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        _GravSZX()

		
		TRB1->(DbSkip())                                                    

    Enddo
    
EndDo

//TOT - VALORES TOTAIS DOS DOCUMENTOS
cLinha := "318" 	//001
cLinha += STRZERO(_nValTotal*100 ,15)	//004
cLinha += STRZERO(0*100		      ,15)	//019
cLinha += STRZERO(0*100          ,15)	//034
cLinha += STRZERO(_ncont*100     ,15)	//049
cLinha += STRZERO(0*100          ,15)	//064
cLinha += STRZERO(0*100          ,15)	//079
cLinha += SPACE(147) 	//094
Fwrite(nHandle, cLinha  + cCrLf)
MsgAlert("Processo Concluido. Gerado Arquivo: " + cArquivo )
fClose(nHandle)
DbClosearea("TRB1")

PUTMV("MV_SEQADR",STRZERO(_nSeqAndr,1))

Return
 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_GravSZX  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณgrava dados na SZX                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/  
Static Function _GravSZX()


	Begin Transaction 

		RecLock("SZX",.T.)

		SZX->ZX_FILIAL		:=	xfilial("SZX")
		SZX->ZX_SERIE 		:=	PADR(SUBSTR(TRB1->F2_SERIE,1,3),3)
		SZX->ZX_NOTA  		:= 	PADR(SUBSTR(TRB1->F2_DOC,2,8),8)
		SZX->ZX_CLIDEST		:=	TRB1->F2_CLIENTE+TRB1->F2_LOJA
		SZX->ZX_IDDEST		:= 	PADR("ANDREANI",35)
		SZX->ZX_IDINTER		:=	_vIDNOT
		SZX->ZX_DTROMA		:=  stod(TRB1->F2_DTROMA)
		SZX->ZX_ROMAN 		:=	TRB1->F2_NRROMA
		SZX->ZX_DTNOTA		:=	stod(TRB1->F2_EMISSAO)
		SZX->ZX_VOLUME		:=	1	
		SZX->ZX_TOTALNF		:=	TRB1->F2_VALBRUT
		SZX->ZX_STATUS		:=	"1"			// 1 - EDI Gerado, ainda sem Retorno 

  		MSUnlock()

	End Transaction 

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPEG  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCRIA SX1                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
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

PutSX1(cPerg,"01","Romaneio          ?","","","mv_ch1","C",50,0,0,"G","","   ","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Data Romaneio     ?","","","mv_ch2","D",08,0,0,"G","","   ","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","")

Return







User Function _EDI003()

	MsgAlerta("Rotina em Desenvolvimento...","AVISO")

Return






/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDI010    บAutor  ณMarco Aurelio-HF    บ Data ณ28/06/2012   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณLegenda				                                      บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function _EDI010()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Legenda                                                             |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	aCorDesc := {	{"BR_PRETO"     , "EDI Gerado, ainda sem Retorno"      	},;
					{"BR_AMARELO"	, "CTRC Recebido, produto em Transito" 	},;
					{"BR_LARANJA"	, "CTRC Recebido, com Ocorrencia"      	},;
					{"BR_AZUL"		, "CTRC Pendente de Validacao"     		},;
					{"BR_BRANCO"	, "CTRC Bloqueio de Validacao"     		},;
					{"ENABLE"		, "CTRC Liberado para Pre-Nota"     	},;										
					{"DISABLE"   	, "Pre-Nota Gerada"   					} }
	BrwLegenda(cCadastro, "Status", aCorDesc )

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDI008    บAutor  ณMarco Aurelio-HF    บ Data ณ28/06/2012   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFUNCAO FILTRO                                               บฑฑ
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
User Function _EDI008()

Private cFiltro
Private oSelec
Private nOpcao   := 0
Private bOk      := {|| nOpcao := 1, oSelec:End()}
Private bCancel  := {|| nOpcao := 0, oSelec:End()}

aEscolha := {"EDI Gerado", "CTRC Recebido, em Transito", "CTRC com Ocorrencia","CTRC Pendente de Validacao","CTRC Bloqueio de Validacao" ,"CTRC Liberado Pre-Nota","Pre-Nota Gerada","Todos"}        

nEscolha := 8

DEFINE MSDIALOG oSelec TITLE "Filtros" FROM 001,001 TO 195,185 PIXEL
@ 020,010 RADIO aEscolha VAR nEscolha
ACTIVATE MSDIALOG oSelec ON INIT EnchoiceBar(oSelec, bOk, bCancel,,) CENTERED

If nOpcao == 1
	If nEscolha == 1
		Set Filter to &(" @ ZX_STATUS == '1' ")
	ElseIf nEscolha == 2
		Set Filter to &(" @ ZX_STATUS == '2' ")
	ElseIf nEscolha == 3
		Set Filter to &(" @ ZX_STATUS == '3' ")
	ElseIf nEscolha == 4
		Set Filter to &(" @ ZX_STATUS == '4' ")
	ElseIf nEscolha == 5
		Set Filter to &(" @ ZX_STATUS == '5' ")
	ElseIf nEscolha == 6
		Set Filter to &(" @ ZX_STATUS == '6' ")
	ElseIf nEscolha == 7
		Set Filter to &(" @ ZX_STATUS == '7' ")
	ElseIf nEscolha == 8
		Set Filter to  
	Endif
EndIf


dbSelectArea("SZX")
dbGoTop()

Return()