#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATR001  º Autor ³ M.Munhoz - ERPPLUS º Data ³  24/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Romaneio para a Transportadora                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FATR001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Romaneio para Transportadora"
Local cPict         := ""
Local titulo        := "Romaneio para Transportadora"
Local Cabec1        := "cabec1"
Local Cabec2        := "cabec2"
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 150
Private tamanho     := "G"
Private nomeprog    := "FATR001"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "FATR01"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATR01"
Private nLin        := 80  
Private c_DirDocs   := GetTempPath()//Caminho da pasta temporaria do Cliente.
Private c_Extensao  := ".DBF"//A extensão também pode ser declarada como ".XLS"
Private c_Arquivo1  := CriaTrab(,.F.)//Cria um nome aleatório para o arquivo
Private cString   	:= "SF2"
private _csrvapl    :=ALLTRIM(GetMV("MV_SERVAPL"))                                                                         

u_GerA0003(ProcName())


dbSelectArea("SF2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria as perguntas no SX1                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSX1()

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
EndIf
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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  24/09/06   º±±
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

Local nOrdem
Local _aAreaSA1 	:= SA1->(GetArea())
Local _cquery   	:= ""
Local CR        	:= chr(13) + chr(10)

Private _nLin     	:= 80
Private _lImpRoda 	:= .f.
Private _aCampos  	:= {}
Private _aCamp2 	:= {}

SA1->(dbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros da rotina                                                ³
//³ mv_par01 -> Do Romaneio                                             ³
//³ mv_par02 -> Ate o Romaneio                                          ³
//³ mv_par03 -> Da Transportadora                                       ³
//³ mv_par04 -> Ate a Transportadora                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha os arquivos temporarios, caso estejam abertos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if select("TRD") > 0
	TRD->(dbCloseArea())
endif
if select("RMN") > 0
	RMN->(dbCloseArea())
endif                      
if select("TRE") > 0
	TRE->(dbCloseArea())
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao de arquivo temporario receber dados.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Alterado de 06 para 09 para nova versao P10
_aCampos := {{"ROMANEIO"	,"C",06,0},; 
			{"EMISSAO"		,"C",08,0},;
			{"SAIDOCA"		,"C",08,0},;
			{"CLIENTE"		,"C",40,0},;
			{"ENDERECO"		,"C",40,0},;
			{"BAIRRO"		,"C",30,0},;
			{"CIDADE"		,"C",15,0},;
			{"ESTADO"		,"C",02,0},;
			{"CEP"			,"C",08,0},;
			{"NFISCAL"		,"C",09,0},;   
			{"SERIE"		,"C",03,0},;
			{"VALTOT"		,"N",14,2},;
			{"QTDITENS"		,"N",14,2}}

_ctrcArqSeq := CriaTrab(_aCampos)                                                                                                                                                                                 
dbUseArea(.T.,,_ctrcArqSeq,"TRD",.T.,.F.)

_aCamp2:={{"F2_NRROMA"	,"C",06,0},; 
              {"NOME"	           ,"C" ,30,0},; 
			{"F2_DTROMA"		,"C",08,0},;
			{"F2_SAIROMA"		,"C",08,0},;
			{"F2_HSAIROM"     , "C",08,0},;
			{"F2_TRANSP"		,"C",06,0},;
			{"A4_NOME"         ,"C",30,0},;
			{"F2_DOC"		       ,"C",09,0},; // Alterado de 06 para 09 para nova versao P10
			{"F2_SERIE"		   ,"C",03,0},;
			{"F2_EMISSAO"	  ,"C",08,0},;
			{"F2_CLIENTE"	 ,"C",06,0},;
			{"F2_LOJA"       ,"C",02,0},;
			{"C5_CLIENT"       ,"C",06,0},;
			{"C5_LOJAENT"       ,"C",02,0},;
			{"C5_TIPO"       ,"C",01,0},;
			{"D2_QUANT"        ,"N",14,2},;
			{"F2_VALMERC"		,"N",14,2},;
			{"F2_VALBRUT"		,"N",14,2}}                                                                                                                                                                                 


_cArqSeq := CriaTrab(_aCamp2)                                                                                                                                                                             
dbUseArea(.T.,,_cArqSeq,"RMN",.T.,.F.)	 	

_cquery += CR + " SELECT F2_TRANSP, F2_NRROMA, F2_DTROMA,F2_SAIROMA,F2_HSAIROM, F2_DOC, F2_SERIE, F2_EMISSAO, F2_VALMERC, F2_VALBRUT, "
_cquery += CR + "        A4_NOME, D2.D2_QUANT, F2_CLIENTE, F2_LOJA, "
_cquery += CR + "        C5_CLIENT, C5_LOJAENT, C5_TIPO "
_cquery += CR + " FROM   "+RetSqlName("SF2")+" AS F2 (nolock) "
_cquery += CR + " LEFT OUTER JOIN "+RetSqlName("SA4")+" AS A4 (nolock) "
_cquery += CR + " ON     A4_COD = F2_TRANSP AND A4.D_E_L_E_T_ = '' "
_cquery += CR + " JOIN   ( "
_cquery += CR + "         SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, SUM(D2_QUANT) D2_QUANT, MAX(D2_PEDIDO) D2_PEDIDO "
_cquery += CR + "         FROM   "+RetSqlName("SD2")+" AS D2 (nolock) "
_cquery += CR + "         WHERE  D2_FILIAL='"+xFilial("SD2")+"' AND D2.D_E_L_E_T_ = '' "
_cquery += CR + "         GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA "
_cquery += CR + "         ) AS D2 "
_cquery += CR + " ON     D2.D2_FILIAL = F2.F2_FILIAL AND D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2.D2_LOJA = F2.F2_LOJA  "
_cquery += CR + " JOIN   "+RetSqlName("SC5")+" AS C5 (nolock) "
_cquery += CR + " ON     C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_ = '' "
_cquery += CR + " WHERE  F2.D_E_L_E_T_ = '' "
_cquery += CR + "        AND F2_FILIAL  = '"+xFilial("SF2")+"' "
_cquery += CR + "        AND F2_NRROMA  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cquery += CR + "        AND F2_TRANSP  BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
_cquery += CR + "        AND F2_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"' "
_cquery += CR + " ORDER BY  F2_CLIENTE,F2_LOJA,F2_NRROMA "
//_cquery += CR + " ORDER BY  F2_NRROMA 	-- Alterado para atender GLPI 14 392 - Uiran Almeida 07.11.2013

_cQuery := strtran(_cQuery, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRE",.T.,.F.)
dbselectarea("TRE")
TRE->(dbgotop())

_cTransp  := TRE->F2_TRANSP
_cNrRoma  := TRE->F2_NRROMA
_nTotalNF := 0
_nTotitens := 0
_nPagina  := 0         

While TRE->(!Eof())
    _cCliLoja  := iif(!empty(TRE->C5_CLIENT), TRE->C5_CLIENT + TRE->C5_LOJAENT, TRE->F2_CLIENTE + TRE->F2_LOJA)
	if TRE->C5_TIPO $ "DB"
		SA2->(dbSetOrder(1))  // A2_FILIAL + A2_COD + A2_LOJA
		SA2->(dbSeek(xFilial("SA2") + _cCliLoja))             
		
		_cNomEnt := alltrim(SA2->A2_NOME)
	else
		SA1->(dbSetOrder(1))  // A1_FILIAL + A1_COD + A1_LOJA
		SA1->(dbSeek(xFilial("SA1") + _cCliLoja))
		_cNomEnt := alltrim(SA1->A1_NOME)
	endif                    
	
	RecLock("RMN",.t.)                          
        RMN->F2_NRROMA   	:= TRE->F2_NRROMA
        RMN->NOME          	:= _cNomEnt
		RMN->F2_DTROMA   	:= TRE->F2_DTROMA
		RMN->F2_SAIROMA  	:= TRE->F2_SAIROMA
		RMN->F2_HSAIROM  	:= TRE->F2_HSAIROM
		RMN->F2_TRANSP    	:= TRE->F2_TRANSP
		RMN->A4_NOME       	:= TRE->A4_NOME
		RMN->F2_DOC        	:= TRE->F2_DOC
		RMN->F2_SERIE		:= TRE->F2_SERIE
		RMN->F2_EMISSAO   	:= TRE->F2_EMISSAO
		RMN->F2_CLIENTE   	:= TRE->F2_CLIENTE
		RMN->C5_CLIENT     	:= TRE->C5_CLIENT
		RMN->C5_LOJAENT    	:= TRE->C5_LOJAENT
		RMN->C5_TIPO       	:= TRE->C5_TIPO
		RMN->F2_LOJA       	:= TRE->F2_LOJA
		RMN->D2_QUANT      	:= TRE->D2_QUANT
		RMN->F2_VALMERC   	:= TRE->F2_VALMERC
		RMN->F2_VALBRUT   	:= TRE->F2_VALBRUT
		MsUnlock()

TRE->(dbSkip())
Enddo

dbselectarea("RMN")
_cAlias  := "RMN"
_cIndice := criatrab(,.f.)
_cChave  := "F2_NRROMA+NOME+F2_TRANSP+F2_SERIE+F2_DOC"
_cWhile  := ""
_cFor    := ""
_cTexto  := "Criando arquivo temporário"
indregua(_cAlias,_cIndice,_cChave,_cWhile,_cFor,_cTexto) 

dbselectarea("RMN")
RMN->(dbgotop())

While RMN->(!Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@_nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nLin > 50 .or. _cTransp <> RMN->F2_TRANSP .or. _cNrRoma <> RMN->F2_NRROMA
		if _lImpRoda 
			RomaRodap()
		EndIf
		RomaCabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf
	
	_cEmissao  := Right(RMN->F2_EMISSAO,2) + "/" + Substr(RMN->F2_EMISSAO,5,2) + "/" + Substr(RMN->F2_EMISSAO,3,2)   
	_dEmisRoma := Right(RMN->F2_DTROMA,2)  + "/" + Substr(RMN->F2_DTROMA,5,2)  + "/" + Substr(RMN->F2_DTROMA,3,2)
    _dSaidoca  := Right(RMN->F2_SAIROMA,2) + "/" + Substr(RMN->F2_SAIROMA,5,2) + "/" + Substr(RMN->F2_SAIROMA,3,2)
	_cCliLoja  := iif(!empty(RMN->C5_CLIENT), RMN->C5_CLIENT + RMN->C5_LOJAENT, RMN->F2_CLIENTE + RMN->F2_LOJA)
	
	if RMN->C5_TIPO $ "DB"
		SA2->(dbSetOrder(1))  // A2_FILIAL + A2_COD + A2_LOJA
		SA2->(dbSeek(xFilial("SA2") + _cCliLoja))             
		
		_cNomEnt := alltrim(SA2->A2_NOME)
		_cEndEnt := alltrim(SA2->A2_END)
		_cMunEnt := alltrim(SA2->A2_MUN)
		_cEstEnt := alltrim(SA2->A2_EST)
		_cCepEnt := alltrim(SA2->A2_CEP)
		_cBaiEnt := alltrim(SA2->A2_BAIRRO)
	else
		SA1->(dbSetOrder(1))  // A1_FILIAL + A1_COD + A1_LOJA
		SA1->(dbSeek(xFilial("SA1") + _cCliLoja))
		_cNomEnt := alltrim(SA1->A1_NOME)
		_cEndEnt := alltrim(SA1->A1_ENDENT)
		_cMunEnt := alltrim(SA1->A1_MUNE)
		_cEstEnt := alltrim(SA1->A1_ESTE)
		_cCepEnt := alltrim(SA1->A1_CEPE)
		_cBaiEnt := alltrim(SA1->A1_BAIRROE)
	endif                    

	@_nLin,001 PSAY RMN->F2_DOC
	@_nLin,011 PSAY RMN->F2_SERIE
	@_nLin,017 PSAY _cEmissao 
	@_nLin,028 PSAY _cNomEnt
	@_nLin,071 PSAY _cMunEnt
	@_nLin,096 PSAY _cEstEnt
	@_nLin,104 PSAY RMN->F2_VALBRUT  Picture "@E 999,999,999.99"
	@_nLin,122 PSAY 0                Picture "@E 999,999.999"
	@_nLin,138 PSAY 0                Picture "@E 999.99"
    @_nLin,146 PSAY RMN->D2_QUANT    Picture "@E 999,999.99" //Edson Rodrigues
	
	_nLin     := _nLin + 1
	_cTransp  := RMN->F2_TRANSP
	_cNrRoma  := RMN->F2_NRROMA
	_nTotalNF += RMN->F2_VALBRUT
	_nTotitens+= RMN->D2_QUANT

	RecLock("TRD",.t.)
	TRD->ROMANEIO := RMN->F2_NRROMA     
	TRD->EMISSAO  := _dEmisRoma
	TRD->SAIDOCA  := _dSaidoca 
	TRD->CLIENTE  := _cNomEnt
	TRD->ENDERECO := _cEndEnt
	TRD->BAIRRO   := _cBaiEnt
	TRD->CIDADE   := _cMunEnt
	TRD->ESTADO   := _cEstEnt
	TRD->CEP      := _cCepEnt
	TRD->NFISCAL  := RMN->F2_DOC
	TRD->SERIE    := RMN->F2_SERIE
	TRD->VALTOT   := RMN->F2_VALBRUT
	TRD->QTDITENS := RMN->D2_QUANT
	MsUnlock()
	
	RMN->(dbSkip())

EndDo

RomaRodap()

RMN->(dbCloseArea())
TRD->(dbCloseArea())
TRE->(dbCloseArea())

cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

_cArqTmp := lower(AllTrim(__RELDIR)+"x"+c_Arquivo1+".csv")
cArqorig := cStartPath+_ctrcArqSeq+".dtc"

//Incluso Edson Rodrigues - 25/05/10
lgerou:=U_CONVARQ(cArqorig,_cArqTmp)

If lgerou                              
   If !ApOleClient( 'MsExcel' )
      MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
   Else
      ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )           
   EndIf
	
Else
  msgstop("Gerado")
Endif

//SELECT E FECHA O ARQ. DE TRAB.
If (Select("RMN")!= 0)
     dbSelectArea("RMN")
     dbCloseArea()
     If File("RMN"+GetDBExtension())
          FErase("RMN"+GetDBExtension())
     EndIf
EndIf

//Return

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
EndIf
MS_FLUSH()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATA001   ºAutor  ³Microsiga           º Data ³  09/24/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RomaCabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
_nLin := 2
@ _nLin, 001 PSAY " "
_nLin++
@ _nLin, 001 PSAY SM0->M0_NOMECOM
_nLin++                           
@ _nLin, 001 PSAY SM0->M0_ENDCOB
//@ _nLin, 001 PSAY "Av. Jurua,320"
_nLin++
//@ _nLin, 001 PSAY "Alphaville Industrial - Barueri - SP"
@ _nLin, 001 PSAY Alltrim(SM0->M0_BAIRCOB)+" - "+alltrim(SM0->M0_CIDCOB)+" - "+alltrim(SM0->M0_ESTCOB)
_nLin++
@ _nLin, 001 PSAY "CNPJ: " + SM0->M0_CGC  Picture "@R 99.999.999/9999-99"
_nLin++
@ _nLin, 001 PSAY "I.E.: " + SM0->M0_INSC //Picture "@R 999.999.999-99"
_nLin++
//@ _nLin, 001 PSAY "Tel.: (11) 3488-0700 (11) 3488-0737"
@ _nLin, 001 PSAY "Fone: " + TRANSFORM(val(SM0->M0_TEL),"@R (99)9999-9999")
_nLin++
_nLin++
_cDtRoma := Right(RMN->F2_DTROMA,2) + "/" + Substr(RMN->F2_DTROMA,5,2) + "/" + Substr(RMN->F2_DTROMA,3,2)
_cSaidoca := Right(RMN->F2_SAIROMA,2) + "/" + Substr(RMN->F2_SAIROMA,5,2) + "/" + Substr(RMN->F2_SAIROMA,3,2)
@ _nLin, 001 PSAY "Transportadora: " + alltrim(RMN->F2_TRANSP) + " / " + alltrim(RMN->A4_NOME)
@ _nLin, 076 PSAY "Nr. Romaneio: "   + alltrim(RMN->F2_NRROMA)
@ _nLin, 105 PSAY "Emissao: " + _cDtRoma       
@ _nLin, 120 PSAY "Saida Doca: " + _cSaidoca
_nLin++
_nLin++
@ _nLin, 001 PSAY "N.F.      Serie   Emissao    Cliente                                    Municipio                Estado        Valor NF   Peso Liquido   Qtd.Vols   Qtd.Itens/NF"
_nLin++
_nLin++
_lImpRoda := .t.
If _cNrRoma <> RMN->F2_NRROMA
	_nPagina := 1
else
	_nPagina++
endif
// N.F.    Serie  Emissao     Cliente                Municipio                Estado        Valor NF   Peso Liquido   Qtd.Vols
// 999999  999    99/99/99    xxxxxxxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxx     xx      999,999,999.99    999,999.999     999.99
// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
// 0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATA001   ºAutor  ³Microsiga           º Data ³  09/24/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RomaRodap()
//  Nome Motorista: _____________________ RG: _________________ Data Coleta: ___/___/___ Hora Coleta: ___:___ Placas Veiculo: ________
//  Assinatura Motorista: ______________________________                                                             Pagina : ________
// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
// 0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
_nLin := 52
If _cNrRoma <> RMN->F2_NRROMA
	@_nLin, 001 PSAY "Total: "
	@_nLin, 084 PSAY _nTotalNF  Picture "@E 999,999,999.99"  // Total da Nota
	@_nLin, 102 PSAY mv_par05   Picture "@E 999,999.999"     // Peso
	@_nLin, 118 PSAY mv_par06   Picture "@E 999.99"          // Volume
    @_nLin, 126 PSAY _nTotitens Picture "@E 999,999,999.999"     // total Itens // Edson Rodrigues 02/08/08
	_nLin++
	_nLin++
	@ _nLin, 001 PSAY "Nome Motorista: ____________________________________________________ RG: __________________________ Data Coleta: ___/___/___ "
	_nLin++
	_nLin++
	@ _nLin, 001 PSAY "Hora Coleta: ___:___ Placas Veiculo: _________________ Nome Expedidor: ______________________________________________________ "
	_nLin++
	_nLin++
	@ _nLin, 001 PSAY "N. de Lacres: _______________________________________________________________________________________________________________ "
	_nLin++
	_nLin++
	@ _nLin, 001 PSAY "Nome Seguranca: ________________________________________________________ RG: ____________________________________ "
	_nTotalNF := 0
//	_nPagina  := 1
Else
	_nLin := _nLin + 8
EndIf
_nLin++
_nLin++
@ _nLin, 001 PSAY "Assinatura Motorista: ______________________________ Assinatura Expedidor: ______________________________ "
@ _nLin, 117 PSAY "Pagina: "
@ _nLin, 126 PSAY _nPagina
_nLin++
//_nPagina++

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATA001   ºAutor  ³Microsiga           º Data ³  09/24/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Do Romaneio"				,"Do Romaneio"			 ,"Do Romaneio"				,"mv_ch1","C",06,0,0,"G","",""   ,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Ate o Romaneio"			,"Ate o Romaneio"		 ,"Ate o Romaneio"			,"mv_ch2","C",06,0,0,"G","",""	  ,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Da Transportadora"		,"Da Transportadora "	 ,"Da Transportadora "	  	,"mv_ch3","C",06,0,0,"G","","SA4","",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Ate a Transportadora"	,"Ate a Transportadora " ,"Ate a Transportadora " 	,"mv_ch4","C",06,0,0,"G","","SA4","",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Peso Liquido"     	  	,"Peso Liquido"      	 ,"Peso Liquido"      	  	,"mv_ch5","N",10,3,0,"G","",""	  ,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Volume"               	,"Volume"                ,"Volume"                	,"mv_ch6","N",10,0,0,"G","",""	  ,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Emissao Inicial"        	,"Emissao Inicial"		 ,"Emissao Inicial"			,"mv_ch7","D",08,0,0,"G","",""	  ,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Emissao Final"         	,"Emissao Final"         ,"Emissao Final"         	,"mv_ch8","D",08,0,0,"G","",""	  ,"",,"mv_par08","","","","","","","","","","","","","","","","")
Return Nil