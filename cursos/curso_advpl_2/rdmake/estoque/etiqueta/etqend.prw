#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบExecblock ณ ETQEND   บ Autor ณ Edson Rodrigues    บ Data ณ  17/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para impressao de Etiquetas de enderecamento      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ETQEND()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Impressใo de etiqueta de Endere็os. "
Local cDesc1  := "Este programa tem o objetivo de imprimir as etiquetas de "
Local cDesc2  := "Endere็o p/ identifica็ใo e localizacao das pe็as nas prateleiras "
Local cDesc3  := "Impressora T้rmica: Zebra "
Local cDesc4  := "Etiqueta: 22 x 88 mm "

Private cPerg := "ETQEND"


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

Processa( {|lEnd| ETQENDA(@lEnd)}, "Aguarde...","Gerando os dados para impressใo das etiquetas ...", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQENDA  บAutor  ณ Edson Rodrigues    บ Data ณ  17/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ETQENDA(lEnd)

local _cQuery   := ""
local CR        := chr(13) + chr(10)
local _aImpEtq  := {}
local _nReg     := 0
local _aImpEtiq := {} 
private cPerg := "ETQEND"

_cQuery := CR + " SELECT BE_FILIAL,BE_LOCAL, BE_LOCALIZ, BE_DESCRIC "
_cQuery += CR + " FROM   "+RetSqlName("SBE")+" AS BE (nolock) "
_cQuery += CR + " WHERE BE.D_E_L_E_T_ = '' "
_cQuery += CR + "         AND BE_FILIAL = '"+xFilial("SBE")+"' "
_cQuery += CR + "         AND BE_LOCALIZ   BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'  "
_cQuery += CR + "         AND BE_LOCAL   BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'  " 
//_cQuery += CR + "         AND BE_MSBLQL <> '1' "
_cQuery += CR + " ORDER BY BE_FILIAL,BE_LOCAL, BE_LOCALIZ, BE_DESCRIC "

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

	aAdd(_aImpEtiq, {ALLTRIM(QRY->BE_LOCALIZ),IIF(EMPTY(QRY->BE_DESCRIC),'',' - '+ALLTRIM(QRY->BE_DESCRIC))})
	QRY->(dbSkip())

enddo

// Se matriz nao estiver vazia, executa funcao de impressao de etiquetas
if len(_aImpEtiq) > 0 //.and. ApMsgYesNo("O sistema enviarแ as etiquetas para impressora nesse momento. Confirma impressใo?","Impressใo de Etiquetas")
	U_impEtqen(_aImpEtiq)
endif

QRY->(dbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบExecblock ณ IMPETQEN บ Autor ณ Edson Rodrigues    บ Data ณ  17/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para impressao de Etiquetas de enderecamento      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function impetqen(_aEtiquet)

Local nX
Local cfont := "0"
Local _afont :={"080,080","105,105"}
Local _aLin := {04,08,12}
Local _aCol := {05,27,45}  //05,30

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura da Matriz                                                         ณ
//ณ 01 - Endere็o                                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Layout da Etiqueta                              ณ
//ณ ฺ--------------- 88 mm -----------------------ฟ ณ
//ณ |                RUA A - RUA A                | ณ
//ณ |  |||||||||||||||||||||||||||||||||||||||||| | |
//ณ |  |||||||||||||||||||||||||||||||||||||||||| ณ ณ
//ณ ภ---------------------------------------------ู ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.)

For nX := 1 to Len(_aEtiquet)

	MSCBBEGIN(1,6)

	// Alimenta variaveis
	_codend    := _aEtiquet[nX, 1]
	_cdecend   := _aEtiquet[nX, 2]

    //IF !empty(_cdecend)
	//  MSCBSAY(_aCol[1],_aLin[1],_codend+left(_cdecend,20-len(_codend)) ,"N",cfont,_afont[1])  // Coluna 1 - Linha 1
    // 	MSCBSAYBAR(_aCol[2],_aLin[3],_aEtiquet[nX,1] ,"N","MB07",7.5,.F.,.F.,.F.,,3,1)
	//ELSE
        MSCBSAY(_aCol[2],_aLin[1],_codend ,"N",cfont,_afont[2])  // Coluna 1 - Linha 1	
        MSCBSAYBAR(_aCol[2],_aLin[3],_aEtiquet[nX,1] ,"N","MB07",7.5,.F.,.F.,.F.,,3,1)
	//ENDIF    


	MSCBEND()

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

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','Endere็o de?' ,'Endere็o de?' ,'Endere็o de?' ,'mv_ch1','C',15,0,0,'G','','SBE','' ,'S','mv_par01','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'02','Endere็o Ate?','Endere็o Ate?','Endere็o Ate?','mv_ch2','C',15,0,0,'G','','SBE','' ,'S','mv_par02','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'03','Amaz้m de?'   ,'Amaz้m de??'  ,'Amaz้m de??'  ,'mv_ch3','C',02,0,0,'G','',''   ,'' ,'S','mv_par03','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'04','Amaz้m Ate?'  ,'Amaz้m Ate?'  ,'Amaz้m Ate?'  ,'mv_ch4','C',02,0,0,'G','',''   ,'' ,'S','mv_par04','','','','','','','','','','','','','','','','')

Return Nil