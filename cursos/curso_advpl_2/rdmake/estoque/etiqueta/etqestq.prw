#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบExecblock ณ ETQESTQ  บ Autor ณ Edson Rodrigues    บ Data ณ  17/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para impressao de Etiquetas de armazenage         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ETQESTQ()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0                                            	
Local cTitulo := "Impressใo de etiqueta de Estocagem. "
Local cDesc1  := "Este programa tem o objetivo de imprimir as etiquetas de "
Local cDesc2  := "armazenagem p/ identifica็ใo e quantidade das pe็as nas prateleiras "
Local cDesc3  := "Impressora T้rmica: Zebra "
Local cDesc4  := "Etiqueta: 22 x 88 mm "

Private cPerg := "ETQEST"

u_GerA0003(ProcName())

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| ETQESTA(@lEnd)}, "Aguarde...","Gerando os dados para impressใo das etiquetas ...", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQESTA  บAutor  ณ Edson Rodrigues    บ Data ณ  17/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ETQESTA(lEnd)

local _cQuery   := ""
local CR        := chr(13) + chr(10)
local _aImpEtq  := {}
local _nReg     := 0
local _aImpEtiq := {} 
Local _cchave   := ""
private cPerg := "ETQEST"

_cQuery := CR + " SELECT B2_FILIAL,B2_COD,B1_DESC,B1_UM,B2_LOCAL,BF_LOCALIZ,B2_QATU,BF_QUANT "
_cQuery += CR + " FROM   "+RetSqlName("SB2")+" AS B2 (nolock) "
_cQuery += CR + "      INNER JOIN (SELECT BF_FILIAL,BF_PRODUTO,BF_LOCAL,BF_LOCALIZ,BF_QUANT FROM  "+RetSqlName("SBF")+" (NOLOCK) WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_LOCALIZ>='"+mv_par03+"' AND BF_LOCALIZ<='"+mv_par04+"' AND D_E_L_E_T_='') AS BF "
_cQuery += CR + "      ON  B2_COD=BF_PRODUTO AND B2_LOCAL=BF_LOCAL  "
_cQuery += CR + "      INNER JOIN (SELECT B1_COD,B1_DESC,B1_UM FROM "+RetSqlName("SB1")+" (NOLOCK) WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND D_E_L_E_T_='') AS B1 "
_cQuery += CR + "      ON B2_COD=B1_COD  "
IF !emptY(mv_par01)
    _cQuery += CR + " WHERE B2_COD='"+mv_par01+"'  AND B2_LOCAL='"+mv_par02+"' "
Else
    _cQuery += CR + " WHERE B2_LOCAL='"+mv_par02+"'  "
Endif    
_cQuery += CR + " ORDER BY B2_FILIAL,B2_COD,B2_LOCAL,BF_LOCALIZ "


_cQuery := strtran(_cQuery, CR, "")

if Select("QRY") > 0
	QRY->(dbCloseArea())
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)


QRY->(dbGoTop())
if QRY->(eof()) .and. QRY->(bof())
	ApMsgInfo("Os parโmetros informados retornaram um resultado vazio. Por favor, revise os parโmetros ou contate o administrador do sistema.", "Etiquetas nใo geradas")
	return
endif                                                      

IF (mv_par05*mv_par06) >   QRY->B2_QATU
   IF  !MSGYESNO("A Qtde por etiq X Qtde Etiqueta impressa ("+STRZERO(mv_par05*mv_par06,9)+") ้ maior que o saldo disponํvel no estoque ("+STRZERO(QRY->B2_QATU,6)+"). Deseja imprimir assim mesmo a(s) Etiqueta(s)  ? ","Etiqueta Estoque ")
      return
   ENDIF
Endif

// Contagem de registros para a Regua
while !QRY->(eof())
	_nReg++
	QRY->(dbSkip())
enddo

// Inicializa a regua de evolucao
ProcRegua(_nReg)

QRY->(dbGoTop())
while !QRY->(eof())
     
	// Incrementa a regua
	IncProc()
    
    If _cchave <> ALLTRIM(QRY->B2_COD)+QRY->B2_LOCAL+QRY->B1_UM
	    aAdd(_aImpEtiq, {ALLTRIM(QRY->B2_COD),IIF(EMPTY(QRY->B1_DESC),'',' - '+ALLTRIM(QRY->B1_DESC)),QRY->B2_LOCAL,QRY->B2_QATU,QRY->B1_UM})
    
       _cchave := ALLTRIM(QRY->B2_COD)+QRY->B2_LOCAL+QRY->B1_UM
	Endif
	
	QRY->(dbSkip())

enddo

// Se matriz nao estiver vazia, executa funcao de impressao de etiquetas
if len(_aImpEtiq) > 0 //.and. ApMsgYesNo("O sistema enviarแ as etiquetas para impressora nesse momento. Confirma impressใo?","Impressใo de Etiquetas")
	U_impEtqesT(_aImpEtiq)
endif

QRY->(dbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบExecblock ณ IMPETQESTบ Autor ณ Edson Rodrigues    บ Data ณ  17/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para impressao de Etiquetas de enderecamento      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function impetqest(_aEtiquet)

Local nX
Local cfont := "0"
Local _afont 
Local _aLin := {04,09,18,20}
Local _aCol := {03,25,45,65}  //05,30
Local _nLargBar
Local _impress := ""                   


if MV_PAR07 == 1
	_afont :={"050,050","040,040"}
	_nLargBar := 3     
	_impress := "Z90XI"   // impressora de 300 dpi
elseif MV_PAR07 == 2
	_afont :={"035,035","030,030"}
	_nLargBar := 1.5
	_impress := "S4M"   // impressora de 200 dpi
endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura da Matriz                                                         ณ
//ณ 01 - Endere็o                                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Layout da Etiqueta                              ณ
//ณ ฺ--------------- 88 mm -----------------------ฟ ณ
//ณ |  PARTNUMBER - DESCR. PARTNUMBER             | ณ
//ณ |  |||||||||||||||||||||||||||||||||||||||||| | |
//ณ |  QTD: 00000  UM:XX  ARM:04  DT_IMP 00/00/00 ณ ณ
//ณ ภ---------------------------------------------ู ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
//MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.)                 

MSCBPRINTER(_impress,"LPT1",,033,.F.,,,,,,.T.)

For nX := 1 to Len(_aEtiquet)	

	// Alimenta variaveis
	_codprod    := _aEtiquet[nX, 1]
	_cdescpro   := _aEtiquet[nX, 2]
	_nqtde      := _aEtiquet[nX, 4]
    _cumed      := _aEtiquet[nX, 5]
    _carmz      := _aEtiquet[nX, 3] 
    _nval       := MV_PAR06

    For x:= 1 to _nval
    
       MSCBBEGIN(1,6)
	    MSCBSAY(_aCol[1],_aLin[1],_codprod+left(_cdescpro,40-len(_codprod)) ,"N",cfont,_afont[1])  // Coluna 1 - Linha 1
     	MSCBSAYBAR(_aCol[2],_aLin[2],_aEtiquet[nX,1] 			,"N","MB07",7.5,.F.,.F.,.F.,,_nLargBar,1)                              
     	
     	MSCBSAY(_aCol[1],_aLin[2],"NF: "+ MV_PAR08	,"N",cfont,_afont[2])  // NOTA
     	
     	MSCBSAY(_aCol[1],_aLin[3]-5,"Qtd: "+strzero(MV_PAR05,6)	,"N",cfont,_afont[2])        
   		
   		MSCBSAY(_aCol[4],_aLin[2],"For: "+ MV_PAR09				,"N",cfont,_afont[2])  // FORNECEDOR
   		
   		MSCBSAY(_aCol[4],_aLin[3]-5,"Dt: "+Dtoc(ddatabase)   		,"N",cfont,_afont[2])  
     	MSCBSAYBAR(_aCol[1],_aLin[4]-2,strzero(MV_PAR05,6) 		,"N","MB07",5,.F.,.F.,.F.,,2)      	 
     	MSCBSAY(_aCol[2],_aLin[3],"Um: "+_cumed            		,"N",cfont,_afont[2])  
     	MSCBSAY(_aCol[3]-8,_aLin[3],"Arm: "+_carmz           		,"N",cfont,_afont[2])    
     
     	MSCBSAY(_aCol[4]-12,_aLin[3],"Usr.: "+upper(alltrim(cUserName))  ,"N",cfont,_afont[2])  
        MSCBEND()
        
        //_aLin := {04,09,18,20}
		//_aCol := {03,25,45,65}
    Next

Next nX

MSCBCLOSEPRINTER()

Return                                                                  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณEdson Rodrigues     บ Data ณ  17/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

PutSX1(cPerg,'01','Partnumber?','Partnumber?','Partnumber?','mv_ch1','C',15,0,0,'G','','SB1','','S','mv_par01','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'02','Armaz้m ?','Armaz้m?','Armaz้m?','mv_ch2','C',2,0,0,'G','','','','S','mv_par02','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'03','Endere็o de?','Endere็o de?','Endere็o de?','mv_ch3','C',15,0,0,'G','','SBE','','S','mv_par03','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'04','Endere็o Ate?','Endere็o Ate?','Endere็o Ate?','mv_ch4','C',15,0,0,'G','','SBE','','S','mv_par04','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'05','Qtde Disp. p/ Etiq?','Qtde Disp. p/ Etiq?','Qtde Disp. p/ Etiq?','mv_ch5','N',13,0,0,'G','','','','S','mv_par05','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'06','Qtde Etiq. imprimir?','Qtde Etiq. imprimir?','Qtde Etiq. imprimir?','mv_ch6','N',13,0,0,'G','','','','S','mv_par06','','','','','','','','','','','','','','','','')
PutSX1(cPerg,"07","Impressora","Impressora","Impressora","mv_ch7","N",01,0,0,"C","",""	,"",,"mv_par07","300 dpi"	,"","","","200 dpi"		,"","",""	,"","","","","","","","")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIncluso para auditoria das pecas - GLPI 18 122ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PutSX1(cPerg,'08','Nota Fiscal'	,'Nota Fiscal'	,'Nota Fiscal'	,'mv_ch8','C',13,0,0,'G','','','','S','mv_par08','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'09','Fornecedor'		,'Fornecedor'		,'Fornecedor'		,'mv_ch9','C',13,0,0,'G','','','','S','mv_par09','','','','','','','','','','','','','','','','')

Return Nil
