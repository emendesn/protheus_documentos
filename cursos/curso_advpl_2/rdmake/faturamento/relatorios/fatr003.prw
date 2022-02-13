#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATR003  บ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  05/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Remessas Sony (Luiz)                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FATR003()

Local aSay     := {}
Local aButton  := {}
Local nOpc     := 0
Local cTitulo  := "Remessa Sony"
Local cDesc1   := "Este programa tem como objetivo gerar o arquivo REMSONY.XLS no diret๓rio de "
Local cDesc2   := "relat๓rios do usuแrio."
Local cDesc3   := "Especํfico BGH"
Local cDesc4   := ""

Private cPerg  := "FATR03"                            
private _csrvapl:= ALLTRIM(GetMV("MV_SERVAPL"))

u_GerA0003(ProcName())


CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T.)      	}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()   	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()              	}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
EndIf

GrvRemSony()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณGRVREMSONYบ Autor ณ AP6 IDE            บ Data ณ  05/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao para gerar o arquivo com os dados de PV e cliente   บฑฑ
ฑฑบ          ณ das Remessas Sony.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GrvRemSony()

Local _cquery   := ""
Local CR        := chr(13) + chr(10)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametros da rotina                                                ณ
//ณ mv_par01 -> Emissao PV Inicial                                      ณ
//ณ mv_par02 -> Emissao PV Final                                        ณ
//ณ mv_par03 -> Mensagem Nota                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha os arquivos temporarios, caso estejam abertos          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if select("TRB") > 0
	TRB->(dbCloseArea())
endif

_cquery +=      " SELECT C5.C5_NUM   'NUMPV' , C5_EMISSAO 'EMISPV', C5_MENNOTA    'MENNOTA', C5_NOTA    'NRNF'  , C6_TES     'TES', C6_IMEINOV   'IMEINOVO', C6.F2_SAIROMA SAIDOCNOV, "
_cquery += CR + "        C6_XIMEOLD  'IMEIOLD', D2.D2_DOC 'NFIMEIOLD',D2.F2_SAIROMA SAIDOCOLD,C6.C6_PRODUTO 'PRODUTO', C5_CLIENTE  'CLIFAT', C5_LOJACLI 'LOJFAT',  "
_cquery += CR + "        A1A.A1_NOME 'NOMFAT', A1A.A1_END 'ENDFAT', A1A.A1_BAIRRO 'BAIFAT' , A1A.A1_MUN 'MUNFAT', A1A.A1_EST 'ESTFAT', A1A.A1_PESSOA 'PESFAT', A1A.A1_CGC 'CGCFAT', A1A.A1_INSCR 'INSFAT',  "
_cquery += CR + "        C5_CLIENT   'CLIENT', C5_LOJAENT 'LOJENT', "
_cquery += CR + "        A1B.A1_NOME 'NOMENT', A1B.A1_END 'ENDENT', A1B.A1_BAIRRO 'BAIENT' , A1B.A1_MUN 'MUNENT', A1B.A1_EST 'ESTENT', A1B.A1_PESSOA 'PESENT', A1B.A1_CGC 'CGCENT', A1B.A1_INSCR 'INSENT' "
_cquery += CR + " FROM   "+RetSqlName("SC5")+" AS C5 (nolock) "
_cquery += CR + " JOIN   "+RetSqlName("SA1")+" AS A1A (nolock) "
_cquery += CR + " ON     A1A.A1_FILIAL = '"+xFilial("SA1")+"' AND A1A.A1_COD = C5_CLIENTE AND A1A.A1_LOJA = C5_LOJACLI AND A1A.D_E_L_E_T_ = '' "
_cquery += CR + " LEFT OUTER JOIN "+RetSqlName("SA1")+" AS A1B (nolock) "
_cquery += CR + " ON     A1B.A1_FILIAL = '"+xFilial("SA1")+"' AND A1B.A1_COD = C5_CLIENT  AND A1B.A1_LOJA = C5_LOJAENT AND A1B.D_E_L_E_T_ = '' "
_cquery += CR + " JOIN   ( "
_cquery += CR + "         SELECT DISTINCT C6_FILIAL, C6_NUM, C6_TES, C6_PRODUTO, C6_XIMEOLD,C6_IMEINOV,F2.F2_SAIROMA "
_cquery += CR + "         FROM   "+RetSqlName("SC5")+" AS C5 (nolock) "
_cquery += CR + "         JOIN   "+RetSqlName("SC6")+" AS C6 (nolock) "
_cquery += CR + "         ON     C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C6.D_E_L_E_T_ = '' AND C6_TES IN ('736','737','738','781','782','783') "
_cquery += CR + "         LEFT OUTER JOIN "+RetSqlName("SF2")+" AS F2 (nolock) "
_cquery += CR + "         ON C5_FILIAL=F2_FILIAL AND C5_NOTA=F2_DOC AND C5_SERIE=F2_SERIE AND C5_CLIENTE=F2_CLIENTE AND C5_LOJACLI=F2_LOJA AND F2.D_E_L_E_T_='' "
_cquery += CR + "         WHERE  C5.D_E_L_E_T_ = '' AND C5_FILIAL = '"+xFilial("SC5")+"' "
_cquery += CR + "                AND C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
_cquery += CR + "                AND C5_MENNOTA LIKE '"+alltrim(mv_par03)+"' AND C6_TES IN ('736','737','738','781','782','783') "
_cquery += CR + "        ) AS C6 "
_cquery += CR + " ON     C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "
_cquery += CR + " LEFT OUTER JOIN ( SELECT D2_DOC,D2_FILIAL,D2_CLIENTE,D2_LOJA,D2_NUMSERI,D2_SERIE,F2_SAIROMA FROM "+RetSqlName("SD2")+" SD2 (nolock)  INNER JOIN "+RetSqlName("SF2")+" SF2 (nolock) "
_cquery += CR + " ON  F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE  AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA "
_cquery += CR + " WHERE SF2.D_E_L_E_T_ = '' AND SD2.D_E_L_E_T_ = '' AND D2_FILIAL = '"+xFilial("SD2")+"' AND F2_FILIAL = '"+xFilial("SF2")+"' AND D2_TES IN ('735','736','737','738','781','782','783') AND D2_NUMSERI <> '') "
_cquery += CR + " AS D2  ON D2.D2_NUMSERI = C6_XIMEOLD "
_cquery += CR + " WHERE  C5.D_E_L_E_T_ = '' AND C5_FILIAL = '"+xFilial("SC5")+"' "
_cquery += CR + "        AND C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
_cquery += CR + "        AND C5_MENNOTA LIKE '"+alltrim(mv_par03)+"' "

//memowrite("FATR003.SQL",_cQuery )
_cQuery := strtran(_cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.) 
TcSetField("TRB","EMISPV" ,"D")
TcSetField("TRB","SAIDOCOLD" ,"D")
TcSetField("TRB","SAIDOCNOV" ,"D")

dbselectarea("TRB")
TRB->(dbgotop())

nConta := 0

While !TRB->(eof())
	nConta++
	TRB->(dbSkip())
EndDo

_cNomePlan := "REMSONY.CSV"
_lOPen    := .f.
_cArqSeq   :=CriaTrab(,.f.)
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

dbselectarea("TRB")
TRB->(dbgotop())
copy to &(cStartPath+_cArqSeq)
TRB->(dbCloseArea())

_cArqTmp := lower(AllTrim(__RELDIR)+_cNomePlan)
cArqorig := cStartPath+_cArqSeq+".dtc"

//Incluso Edson Rodrigues - 25/05/10
lgerou:=U_CONVARQ(cArqorig,_cArqTmp)

If lgerou                              
   If !ApOleClient( 'MsExcel' )
      MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
   Else
      ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )           
   EndIf

Else
  msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
Endif


/*
if nConta > 0
	While !_lOpen
		if file(__reldir+_cArq) .and. ferase(__reldir+_cArq) == -1
			if !ApMsgYesNo("O arquivo " + _cArq + " nใo pode ser gerado porque deve estar sendo utilizado. Deseja tentar novamente? " )
				_lOpen := .t.
				ApMsgInfo("O arquivo Excel nใo foi gerado. ")
			endif
		else
			dbselectarea("TRB")                                                                                              
			copy to &(__reldir+_cArq)   VIA "DBFCDXADS"
			ShellExecute( "Open" , "\\"+csrvapl+__reldir+_cArq ,"", "" , 3 )
			_lOpen := .t.
		endif
	EndDo
else
	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
endif
*/


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Emissao PV Inicial"		,"Emissao PV Inicial"		,"Emissao PV Inicial"		,"mv_ch1","D",08,0,0,"G","",""   ,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Emissao PV Final"		,"Emissao PV Final"			,"Emissao PV Final"			,"mv_ch2","D",08,0,0,"G","",""	  ,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Mensagem Nota"			,"Mensagem Nota"			,"Mensagem Nota"			,"mv_ch3","C",20,0,0,"G","",""   ,"",,"mv_par03","","","","","","","","","","","","","","","","")
Return Nil