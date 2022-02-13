#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบExecblock ณ ETQSEPWH  บ Autor ณ Edson Rodrigues    บ Data ณ  30/11/11  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para separa็ao Wherehouse                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ETQSEPWH()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Impressใo de etiqueta de Separa็ใo WH. "
Local cDesc1  := "Este programa tem o objetivo de imprimir as etiquetas de "
Local cDesc2  := "Separa็ใo WhereHouse p/ identifica็ใo e quantidade por Ordem de separa็ใo "
Local cDesc3  := "Impressora T้rmica: Zebra "
Local cDesc4  := "Etiqueta: 22 x 88 mm "

Private cPerg := "ETQSWH"

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
private cPerg := "ETQSWH"
                        

_cQuery := CR + "SELECT CQ_NUM,CQ_NUMSQ,CQ_PRODUTO,CQ_DESCRI,CQ_LOCAL,CQ_QUANT,CQ_QTDISP,CQ_NUMREQ,CQ_DATPRF,'1' AS TIPOFILT,'' AS NUMOS,'' AS USRINCL, '' AS LOTE "
_cQuery += CR + " FROM   "+RetSqlName("SCQ")+" AS CQ (nolock) "
_cQuery += CR + " WHERE CQ_FILIAL='"+XFILIAL("SCQ")+"' AND CQ_NUM>='"+mv_par01+"'  AND CQ_NUM<='"+mv_par02+"' "
_cQuery += CR + " AND CQ_PRODUTO>='"+mv_par03+"'  AND CQ_PRODUTO<='"+mv_par04+"' "
if mv_par05 == 1
   _cQuery += CR + " AND CQ_QTDISP > 0 "
Else
   _cQuery += CR + " AND CQ_QTDISP = 0 " 
endif
_cQuery += CR + " UNION ALL "
_cQuery += CR + " SELECT DCF_DOCTO,DCF_NUMSEQ,DCF_CODPRO,B1_DESC,DCF_LOCAL,DCF_QUANT,DCF_QUANT,DCF_NUMSEQ,DCF_DATA,'2' TIPOFILT,Z9_NUMOS AS NUMOS,Z9_USRINCL AS USRINCL, '' AS LOTE " 
_cQuery += CR + " FROM "+RetSqlName("DCF")+" AS DCF (nolock) "
_cQuery += CR + "    INNER JOIN "
_cQuery += CR + "    ( SELECT B1_COD,B1_DESC FROM "+RetSqlName("SB1")+" WHERE B1_FILIAL='"+XFILIAL("SB1")+"' AND D_E_L_E_T_='') AS B1 "
_cQuery += CR + "    ON DCF_CODPRO=B1_COD "
_cQuery += CR + "    LEFT JOIN "+RetSqlName("SZ9")+" AS SZ9 (nolock) "
_cQuery += CR + "    ON Z9_FILIAL='"+XFILIAL("SZ9")+"' AND DCF_CODPRO=Z9_PARTNR AND DCF_DOCTO=Z9_NUMSEQE AND SZ9.D_E_L_E_T_='' "
_cQuery += CR + " WHERE DCF_FILIAL='"+XFILIAL("DCF")+"' AND DCF_DOCTO>='"+mv_par01+"'  AND DCF_DOCTO<='"+mv_par02+"'  "
_cQuery += CR + " AND DCF_CODPRO >='"+mv_par03+"'  AND DCF_CODPRO<='"+mv_par04+"' AND DCF.D_E_L_E_T_='' "
_cQuery += CR + " AND DCF_ORIGEM <> 'SC9' "
_cQuery += CR + "UNION ALL "
_cQuery += CR + " SELECT DB_DOC, "
_cQuery += CR + "		DB_NUMSEQ, "
_cQuery += CR + "		DB_PRODUTO, "
_cQuery += CR + "		B1_DESC, "
_cQuery += CR + "		DB_LOCAL, "
_cQuery += CR + "		DB_QUANT, "
_cQuery += CR + "		0, "
_cQuery += CR + "		DB_NUMSEQ, "
_cQuery += CR + "		DB_DATA, "
_cQuery += CR + "		'2' TIPOFILT, "
_cQuery += CR + "		'' AS NUMOS, "
_cQuery += CR + "		'' AS USRINCL, "
_cQuery += CR + "		DB_LOTECTL AS LOTE "
_cQuery += CR + " FROM "+RetSqlName("SDB")+" SDB "
_cQuery += CR + " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON (B1_COD = DB_PRODUTO AND SB1.D_E_L_E_T_ = '' ) "
_cQuery += CR + " WHERE DB_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery += CR + " AND DB_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
_cQuery += CR + " AND DB_ORIGEM = 'SC9' "
_cQuery += CR + " AND DB_ESTORNO = '' "
_cQuery += CR + " AND DB_FILIAL = '"+xFilial("SDB")+"' "
_cQuery += CR + " AND SDB.D_E_L_E_T_ = ''  "
_cQuery += CR + " ORDER BY CQ_NUM,CQ_PRODUTO,CQ_LOCAL "    

_cQuery := strtran(_cQuery, CR, "")

if Select("QRY") > 0
	QRY->(dbCloseArea())
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)
TcSetField("QRY","CQ_DATPRF" ,"D")

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
    
    If _cchave <> ALLTRIM(QRY->CQ_NUM)+QRY->CQ_PRODUTO+QRY->CQ_LOCAL+Alltrim(QRY->LOTE)
	    aAdd(_aImpEtiq, {QRY->CQ_NUM,QRY->CQ_NUMSQ,QRY->CQ_PRODUTO,QRY->CQ_DESCRI,QRY->CQ_LOCAL,QRY->CQ_QUANT,QRY->CQ_QTDISP,QRY->CQ_NUMREQ,QRY->CQ_DATPRF,QRY->TIPOFILT,QRY->NUMOS,QRY->USRINCL,QRY->LOTE})
       _cchave := ALLTRIM(QRY->CQ_NUM)+QRY->CQ_PRODUTO+QRY->CQ_LOCAL+Alltrim(QRY->LOTE)
	Endif
	
	QRY->(dbSkip())

enddo

// Se matriz nao estiver vazia, executa funcao de impressao de etiquetas
if len(_aImpEtiq) > 0 //.and. ApMsgYesNo("O sistema enviarแ as etiquetas para impressora nesse momento. Confirma impressใo?","Impressใo de Etiquetas")
	U_impEtqswh(_aImpEtiq)
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

User Function impEtqswh(_aEtiquet)

Local nX
Local cfont  := "0"
Local _afont :={"050,050","040,040","030,030"}
Local _aLin  := {04,09,18,15}
Local _aCol  := {04,25,41,65,28}  //05,30
Local _cLote := ""


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Layout da Etiqueta                              ณ
//ณ ฺ--------------- 88 mm -----------------------ฟ ณ
//ณ |  PARTNUMBER - DESCR. PARTNUMBER             | ณ
//ณ |  |||||||||||||||||||||||||||||||||||||||||| | |
//ณ |  QTD: 00000                 OS : XXXXXX     | |
//ณ |       |||||     ARM:04      DT OS 00/00/00  | ณ
//ณ ภ---------------------------------------------ู ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.)


For nX := 1 to Len(_aEtiquet)

	// Alimenta variaveis
	_codprod    := _aEtiquet[nX, 3]
	_cdescpro   := _aEtiquet[nX, 4]
	_cnumos     := _aEtiquet[nX, 1]
    _carmz      := _aEtiquet[nX, 5]                                                     
    _cnumreq    := _aEtiquet[nX, 8]                                                     
    _dtreq      := _aEtiquet[nX, 9]                                                     
    _cOSZ9      := _aEtiquet[nX, 11]                                                     
    _cUsrZ9     := _aEtiquet[nX, 12]                                                     
    _cLote      := ""
                                      
	//Tratamento do lote para produtos do Quiosque D.FERNANDES - 28/10/2013
	If Len(_aEtiquet[nX]) > 12
	    _cLote     := _aEtiquet[nX, 13]
	EndIf

    
    If Upper(Funname()) $ "U_ETQSEPWH"
    	_cdtos      := iif(MV_PAR05==1 .AND._aEtiquet[nX, 10]=='1',DTOC(POSICIONE("SD3",3,XFILIAL("SD3")+_codprod+_carmz+_cnumreq,"D3_EMISSAO")),DTOC(_dtreq))
    	_nqtde      := iif(MV_PAR05==1,_aEtiquet[nX, 7],_aEtiquet[nX, 6])
    	_nval       := MV_PAR06
    Else
    	_cdtos      := DTOC(_dtreq)
    	_nqtde      := _aEtiquet[nX, 6]
    	_nval       := 1    
    Endif

    For x:= 1 to _nval
    
       MSCBBEGIN(1,6)
       
	    MSCBSAY(_aCol[1],_aLin[1]-1,Alltrim(_codprod)+" - "+left(_cdescpro,35-len(_codprod)) ,"N",cfont,_afont[2])  // Coluna 1 - Linha 1
		
		If !Empty(_cLote)
	   	    MSCBSAY(_aCol[1],_aLin[1]+2,"Lote:" + Alltrim(_cLote) ,"N",cfont,_afont[3])  // Coluna 1 - Linha 1
          	MSCBSAYBAR(_aCol[2],_aLin[1]+2,_cLote ,"N","MB07",2,.F.,.F.,.F.,,2,1)                              
		EndIf	   	    
   	    
	    MSCBSAY(_aCol[4],_aLin[1],"Dt: "+_cdtos   ,"N",cfont,_afont[2])  
	    
     	MSCBSAYBAR(_aCol[1],_aLin[2],_codprod ,"N","MB07",5.5,.F.,.F.,.F.,,3,1)                              
     	MSCBSAY(_aCol[4],_aLin[2],"Qtd: "+strzero(_nqtde,5),"N",cfont,_afont[2])                           
     	
     	MSCBSAYBAR(_aCol[4],_aLin[4]-2,strzero(_nqtde,5) ,"N","MB07",3.5,.F.,.F.,.F.,,2,1)                              
     	
     	MSCBSAY(_aCol[1],_aLin[3]-2,"Doc: "+_cnumos           ,"N",cfont,_afont[2])  
     	MSCBSAY(_aCol[3],_aLin[3]-2,"Arm: "+_carmz           ,"N",cfont,_afont[2])  
     	     	
     	If !EMPTY(_cOSZ9)
     		MSCBSAY(_aCol[1],_aLin[3]+2,"Usuario: "+_cUsrZ9,"N",cfont,_afont[2])  
     		MSCBSAY(_aCol[4],_aLin[3]+2,"OS: "+_cOSZ9          ,"N",cfont,_afont[2])  
     	Endif
     	
        MSCBEND()
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

PutSX1(cPerg,'01','Ord. Separa็ใo de ?','Ord. Separa็ใo de ?','Ord, Separa็ใo de ?','mv_ch1','C',09,0,0,'G','','','','S','mv_par01','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'02','Ord. Separa็ใo ate ?','Ord. Separa็ใo de ?','Ord, Separa็ใo ate ?','mv_ch2','C',09,0,0,'G','','','','S','mv_par02','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'03','Partnumber de?','Partnumber de?','Partnumber de?','mv_ch3','C',15,0,0,'G','','SB1','','S','mv_par03','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'04','Partnumber ate?','Partnumber ate?','Partnumber ate?','mv_ch4','C',15,0,0,'G','','SB1','','S','mv_par04','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'05','Req. Baixadas?','Req. Baixadas?','Req. Baixadas?','mv_ch5','N',01,0,0,'C','','','','','mv_par05','Sim','','','','Nใo','','','','','','','','','','','')
PutSX1(cPerg,'06','Qtde Etiq. imprimir?','Qtde Etiq. imprimir?','Qtde Etiq. imprimir?','mv_ch6','N',13,0,0,'G','','','','S','mv_par06','','','','','','','','','','','','','','','','')

Return Nil