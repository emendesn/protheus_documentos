#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

#define ENTER CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TransAuto	ºAutor  ³Paulo Francisco       º Data ³  16/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa Transferencia Automatica de Peças                    º±±
±±º          ³          Producao para Sucata                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TransAuto(PARAMIXB)

Local cEmp := ""
Local cFil := ""

DEFAULT PARAMIXB := {'02','06'}

If len(PARAMIXB) > 0 
	cEmp := PARAMIXB[1]
	cFil := PARAMIXB[2]
Endif

PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES "ZZ4" 


Private cDocumento	:= Space(6)
Private	lRet		:= .T.
Private cLocaliz 	:= ""  
Private cMensagem 	:= ""
Private cQry
Private aItens 		:= {}
Private _aRecnoSZ9 	:= {}
Private	_center   	:= Chr(13)+Chr(10)
Private Path        := "172.16.0.7"

u_GerA0003(ProcName())

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

/*
cQry	:=	" SELECT PECA, ALMEP, ENDAUD, ALMSCR, ENDSCR, SUM(QTDY)SZ9_PECA, SUM(QTD) SBF_PECA, TOTAL = CASE WHEN SUM(QTDY) > SUM(QTD) OR  SUM(QTDY) = SUM(QTD) THEN SUM(QTD) ELSE SUM(QTDY) END " + ENTER

cQry	+=	" FROM( " + ENTER

cQry	+=	" SELECT SZ9.Z9_PARTNR PECA, SUM(SZ9.Z9_QTY) AS QTDY, '' AS QTD, QRY1.ALMEP AS ALMEP, QRY1.ENDAUD AS ENDAUD, QRY1.ALMSCR AS ALMSCR, QRY1.ENDSCR AS ENDSCR " + ENTER
cQry	+=	" FROM " + RetSqlName("SZ9") + " SZ9 " + ENTER
cQry	+=	" INNER JOIN (SELECT	ZZ4.ZZ4_IMEI	AS IMEI, " + ENTER
cQry	+=	" 		ZZ4.ZZ4_OS		AS OS, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_OPERA	AS OPERA, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ALMEP	AS ALMEP, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ENDPRO	AS ENDPRO, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ENDAUD	AS ENDAUD, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ALMSCR	AS ALMSCR, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ENDSCR	AS ENDSCR " + ENTER

cQry	+=	" FROM " + RetSqlName("ZZ4") + " ZZ4 " + ENTER
cQry	+=	" INNER JOIN " + RetSqlname("ZZJ") + " ZZJ " + ENTER
cQry	+=	" ON(ZZ4.ZZ4_OPEBGH = ZZJ.ZZJ_OPERA AND ZZ4.D_E_L_E_T_ = ZZJ.D_E_L_E_T_) " + ENTER
cQry	+=	" WHERE ZZ4.D_E_L_E_T_ = '' " + ENTER
//cQry	+=	" AND ZZJ.ZZJ_OPERA LIKE 'N%' " + ENTER - Comentado linha para considerar todas as operações - Conforme solicitação do Edson 25/10/12
cQry	+=	" AND ZZJ.ZZJ_GEPECA  <> 'S' " + ENTER//TRANSFERIR SOMENTE SE NAO ESTIVER SAINDO AS PEÇAS UTILIZADAS NO EQUIPAMENTO - SOLICTACAO DO EDSON
cQry	+=	" AND ZZJ.ZZJ_ALMEP  <> '' " + ENTER
cQry	+=	" AND ZZJ.ZZJ_ENDPRO <> '' " + ENTER
cQry	+=	" AND ZZJ.ZZJ_ENDAUD <> '' " + ENTER
cQry	+=	" AND ZZJ.ZZJ_ALMSCR <> '' " + ENTER
cQry	+=	" AND ZZJ.ZZJ_ENDSCR <> '' " + ENTER
cQry	+=	" AND ZZ4.ZZ4_NFSDT <= (SELECT CONVERT(VARCHAR(12),GETDATE(),112)) " + ENTER
cQry	+=	" AND ZZ4.ZZ4_NFSDT <> '' " + ENTER
cQry	+=	" )AS QRY1 " + ENTER
cQry	+=	" ON(SZ9.Z9_NUMOS = QRY1.OS) " + ENTER
cQry	+=	" WHERE SZ9.D_E_L_E_T_ = ''  " + ENTER
cQry	+=	" AND SZ9.Z9_PARTNR <> '' " + ENTER
cQry	+=	" GROUP BY SZ9.Z9_PARTNR, ALMEP, ENDAUD, ALMSCR, ENDSCR " + ENTER

cQry	+=	" UNION " + ENTER

cQry	+=	" SELECT SBF.BF_PRODUTO AS PECA, '' QTDY, SBF.BF_QUANT AS QTD, QRY2.ALMEP AS ALMEP, QRY2.ENDAUD AS ENDAUD, QRY2.ALMSCR AS ALMSCR, QRY2.ENDSCR AS ENDSCR " + ENTER
cQry	+=	" FROM " + RetSQlName("SBF") + " SBF " + ENTER
cQry	+=	" INNER JOIN (SELECT	ZZ4.ZZ4_IMEI	AS IMEI, " + ENTER
cQry	+=	" 		ZZ4.ZZ4_OS		AS OS, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_OPERA	AS OPERA, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ALMEP	AS ALMEP, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ENDPRO	AS ENDPRO, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ENDAUD	AS ENDAUD, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ALMSCR	AS ALMSCR, " + ENTER
cQry	+=	" 		ZZJ.ZZJ_ENDSCR	AS ENDSCR " + ENTER

cQry	+=	" FROM " + RetSqlName("ZZ4") + " ZZ4 " + ENTER
cQry	+=	" INNER JOIN " + RetSqlName("ZZJ") + " ZZJ " + ENTER
cQry	+=	" ON(ZZ4.ZZ4_OPEBGH = ZZJ.ZZJ_OPERA AND ZZ4.D_E_L_E_T_ = ZZJ.D_E_L_E_T_) " + ENTER
cQry	+=	" WHERE ZZ4.D_E_L_E_T_ = ''  " + ENTER
//cQry	+=	" AND ZZJ.ZZJ_OPERA LIKE 'N%' " + ENTER - Comentado linha para considerar todas as operações - Conforme solicitação do Edson 25/10/12
cQry	+=	" AND ZZJ.ZZJ_GEPECA  <> 'S' " + ENTER//TRANSFERIR SOMENTE SE NAO ESTIVER SAINDO AS PEÇAS UTILIZADAS NO EQUIPAMENTO - SOLICTACAO DO EDSON
cQry	+=	" AND ZZJ.ZZJ_ALMEP  <> '' " + ENTER
cQry	+=	" AND ZZJ.ZZJ_ENDPRO <> '' " + ENTER
cQry	+=	" AND ZZJ.ZZJ_ENDAUD <> '' " + ENTER
cQry	+=	" AND ZZJ.ZZJ_ALMSCR <> '' " + ENTER
cQry	+=	" AND ZZJ.ZZJ_ENDSCR <> '' " + ENTER
cQry	+=	" AND ZZ4.ZZ4_NFSDT <= (SELECT CONVERT(VARCHAR(12),GETDATE(),112)) " + ENTER
cQry	+=	" AND ZZ4.ZZ4_NFSDT <> '' " + ENTER
cQry	+= " )AS QRY2 " + ENTER
cQry	+=	" ON(QRY2.ALMEP = SBF.BF_LOCAL AND QRY2.ENDAUD = SBF.BF_LOCALIZ) " + ENTER
cQry	+=	" WHERE SBF.D_E_L_E_T_ = '' " + ENTER


cQry	+=	" ) AS QRY " + ENTER

cQry	+=	" GROUP BY PECA, ALMEP, ENDAUD, ALMSCR, ENDSCR " + ENTER
cQry	+=	" HAVING SUM(QTDY) > 0 " + ENTER
cQry	+=	" ORDER BY 1 " + ENTER

MemoWrite("c:\trasauto.sql", cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

QRY->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Grava dados no Array                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QRY")
dbGoTop()

While !EOF("QRY")

If QRY->TOTAL > 0

//Pocisiona Produto
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1") + Left(QRY->PECA,15)))

cLocaliz	:=  SB1->B1_LOCALIZ

dbselectarea("SB2")
SB2->(DBSeek(xFilial('SB2') + Left(QRY->PECA,15) + QRY->ALMEP))

_nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)

_nSalBF := SaldoSBF(QRY->ALMEP, QRY->ENDAUD, Left(QRY->PECA,15), NIL, NIL, NIL, .F.)

If _nSalb2 >= QRY->TOTAL .and. _nSalBF >= QRY->TOTAL

aAdd(aItens,{Left(QRY->PECA,15),;			// Produto Origem
Left(SB1->B1_DESC,30),;                   	// Desc. Produto Origem
AllTrim(SB1->B1_UM),;                     	// Unidade Medida
QRY->ALMEP,;                           		// Local Origem
IIF(cLocaliz=="S",AllTrim(QRY->ENDAUD),SPACE(15)),;             			// Ender Origem
Left(QRY->PECA,15),;	                  	// Produto Destino
Left(SB1->B1_DESC,30),;                   	// Desc. Produto Destino
AllTrim(SB1->B1_UM),;                     	// Unidade Medida
QRY->ALMSCR,;                  				// Local Destino
IIF(cLocaliz=="S",AllTrim(QRY->ENDSCR),SPACE(15)),;     					// Ender Destino
Space(20),;                               	// Num Serie
Space(10),;                               	// Lote
Space(06),;                              	// Sub Lote
CtoD("//"),;                              	// Validade
0,;                                        	// Potencia
QRY->TOTAL,;                       			// Quantidade
0,;                                       	// Qt 2aUM
"N",;                                     	// Estornado
Space(06),;                               	// Sequencia
Space(10),;                               	// Lote Desti
CtoD("//"),;                              	// Validade Lote
Space(3),;                              	// Cod.Servic //Acrescentado edson Rodrigues
Space(03)})									// Item Grade
Endif
EndIf

dbSelectArea("QRY")

dbSkip()

EndDo
*/

cQry	:=	"SELECT "
cQry	+=	"	Z9_PARTNR AS PECA, "
cQry	+=	"	Z9_IMEI AS IMEI, "
cQry	+=	"	Z9_NUMOS AS NUMOS, "
cQry	+=	"	ZZJ_ALMEP AS ALMEP, "
cQry	+=	"	ZZJ_ENDAUD AS ENDAUD, "
cQry	+=	"	ZZJ_ALMSCR AS ALMSCR, "
cQry	+=	"	ZZJ_ENDSCR AS ENDSCR, "
cQry	+=	"	Z9_QTY AS QTDZ9, "
cQry	+=	"	SZ9.R_E_C_N_O_ AS RECNOZ9 "
cQry	+=	"FROM " + RetSqlName("ZZ4") + " ZZ4 "
cQry	+=	"INNER JOIN " + RetSqlName("ZZJ") + " ZZJ ON "
cQry	+=	"	ZZJ_FILIAL = '"+xFilial("ZZJ")+"' AND " //TICKET 13058 - M.Munhoz - 22/05/2013
cQry	+=	"	ZZJ_OPERA=ZZ4_OPEBGH AND "
cQry	+=	"	ZZJ_ALMEP  <> '' AND "
cQry	+=	"	ZZJ_ENDPRO <> '' AND "
cQry	+=	"	ZZJ_ENDAUD <> '' AND "
cQry	+=	"	ZZJ_ALMSCR <> '' AND "
cQry	+=	"	ZZJ_ENDSCR <> '' AND "
cQry	+=	"	ZZJ_GEPECA  <> 'S' AND "
cQry	+=	"	ZZJ.D_E_L_E_T_='' "
cQry	+=	"INNER JOIN " + RetSqlName("SZ9") + " SZ9 ON "
cQry	+=	"	Z9_FILIAL='"+xFilial("SZ9")+"' AND "
cQry	+=	"	Z9_NUMOS=ZZ4_OS AND "
cQry	+=	"	Z9_IMEI=ZZ4_IMEI AND "
cQry	+=	"	Z9_PARTNR<>'' AND "
cQry	+=	"	Z9_NUMSEQS = '' AND "
cQry	+=	"	SZ9.D_E_L_E_T_='' "
cQry	+=	"WHERE "
cQry	+=	"	ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND "
cQry	+=	"	ZZ4_NFSDT >= '20130214' AND "//DATA DE CORTE PARA FATURAMENTO.
cQry	+=	"	ZZ4_ATULT >= '20130214' AND "//DATA DE CORTE PARA ENCERRAMENTO DA OS.
cQry	+=	"	ZZ4.D_E_L_E_T_='' AND "
cQry	+=	"	Z9_SYSORIG = '' AND "
cQry	+=	"	ZZJ_ALMEP NOT IN  ('1P') "
cQry	+=	"ORDER BY Z9_PARTNR, ZZJ_ALMEP,ZZJ_ENDAUD,ZZJ_ALMSCR,ZZJ_ENDSCR "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

QRY->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Grava dados no Array                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QRY")
dbGoTop()

While !EOF("QRY")
	
	//Pocisiona Produto
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + Left(QRY->PECA,15)))
	
	cLocaliz	:=  SB1->B1_LOCALIZ
	
	dbselectarea("SB2")
	SB2->(DBSeek(xFilial('SB2') + Left(QRY->PECA,15) + QRY->ALMEP))
	
	_nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
	
	_nSalBF := SaldoSBF(QRY->ALMEP, QRY->ENDAUD, Left(QRY->PECA,15), NIL, NIL, NIL, .F.)
	
	DbSelectarea("SB2")
	DbSetOrder(1)
	If ! DbSeek(xFilial("SB2")+Left(QRY->PECA,15) + QRY->ALMSCR,.F.)
		CriaSb2(Left(QRY->PECA,15),QRY->ALMSCR)
	Endif	
	
	_nPos := aScan(aItens, { |X| X[1] == Left(QRY->PECA,15)})
	
	If _nPos == 0
		If _nSalb2 >= QRY->QTDZ9 .and. _nSalBF >= QRY->QTDZ9
			aAdd(aItens,{Left(QRY->PECA,15),;			// Produto Origem
			Left(SB1->B1_DESC,30),;                   	// Desc. Produto Origem
			AllTrim(SB1->B1_UM),;                     	// Unidade Medida
			QRY->ALMEP,;                           		// Local Origem
			IIF(cLocaliz=="S",AllTrim(QRY->ENDAUD),SPACE(15)),;             			// Ender Origem
			Left(QRY->PECA,15),;	                  	// Produto Destino
			Left(SB1->B1_DESC,30),;                   	// Desc. Produto Destino
			AllTrim(SB1->B1_UM),;                     	// Unidade Medida
			QRY->ALMSCR,;                  				// Local Destino
			IIF(cLocaliz=="S",AllTrim(QRY->ENDSCR),SPACE(15)),;     					// Ender Destino
			Space(20),;                               	// Num Serie
			Space(10),;                               	// Lote
			Space(06),;                              	// Sub Lote
			CtoD("//"),;                              	// Validade
			0,;                                        	// Potencia
			QRY->QTDZ9,;                       			// Quantidade
			0,;                                       	// Qt 2aUM
			"N",;                                     	// Estornado
			Space(06),;                               	// Sequencia
			Space(10),;                               	// Lote Desti
			CtoD("//"),;                              	// Validade Lote
			Space(3),;                              	// Cod.Servic //Acrescentado edson Rodrigues
			Space(03)})									// Item Grade
			
			Aadd(_aRecnoSZ9, QRY->RECNOZ9)// Recno do item na tabela SZ9
		Else
			
	        If Empty(cMensagem)
				cTitemail:="Itens com problema de Saldo" 
				cMensagem := "Itens com problema de saldo : "+DTOC(date())+" - "+time()+" hrs."+ _center
       		Endif                                
       				    
		    cMensagem += "OS           : " + AllTrim(QRY->NUMOS)+ _center
		    cMensagem += "Peça         : " + AllTrim(QRY->PECA)+ _center
		    cMensagem += "Qtde         : " + STRZERO(QRY->QTDZ9,3)+ _center
		    cMensagem += "Armz Origem  : " + Alltrim(QRY->ALMEP)+ _center
		    cMensagem += "End Origem   : " + Alltrim(QRY->ENDAUD)+ _center
		    cMensagem += "Armz Destino : " + Alltrim(QRY->ALMSCR)+ _center
		    cMensagem += "End Destino  : " + Alltrim(QRY->ENDSCR)+ _center
		    
		    if _nSalb2 < QRY->QTDZ9
              If _nSalb2  > 0 
                  cMensagem += "Saldo do SB2 menor que a quantidade apontada" + _center		    
              Else
                  cMensagem += "Nao ha saldo no SB2 - Saldo negativo ou Zero" + _center		                      
              Endif
            Elseif  _nSalBF < QRY->QTDZ9
              IF _nSalBF > 0
                  cMensagem += "Saldo do SBF menor que a quantidade apontada" + _center		    
              ELSE
                 cMensagem += "Nao ha saldo no SBF - Saldo negativo ou Zero" + _center		                    
              Endif   
            Endif 
              
		    cMensagem += "---------------------------------------   " + _center 
		Endif
	
		
	Else      
	
		If _nSalb2 >= QRY->QTDZ9+aItens[_nPos,16]  .and. _nSalBF >= QRY->QTDZ9+aItens[_nPos,16] 
			aItens[_nPos,16] += QRY->QTDZ9
			Aadd(_aRecnoSZ9, QRY->RECNOZ9)// Recno do item na tabela SZ9
		Else
			If Empty(cMensagem)
				cTitemail:="Itens com problema de Saldo" 
				cMensagem := "Itens com problema de saldo : "+DTOC(date())+" - "+time()+" hrs."+ _center
       		Endif
		    
		    cMensagem += "OS           : " + AllTrim(QRY->NUMOS)+ _center
		    cMensagem += "Peça         : " + AllTrim(QRY->PECA)+ _center
		    cMensagem += "Qtde         : " + STRZERO(QRY->QTDZ9,3)+ _center
		    cMensagem += "Armz Origem  : " + Alltrim(QRY->ALMEP)+ _center
		    cMensagem += "End Origem   : " + Alltrim(QRY->ENDAUD)+ _center
		    cMensagem += "Armz Destino : " + Alltrim(QRY->ALMSCR)+ _center
		    cMensagem += "End Destino  : " + Alltrim(QRY->ENDSCR)+ _center 
	  	    if _nSalb2 < QRY->QTDZ9+aItens[_nPos,16]
              If _nSalb2  > 0 
                  cMensagem += "Saldo do SB2 menor que a quantidade apontada" + _center		    
              Else
                  cMensagem += "Nao ha saldo no SB2 - Saldo negativo ou Zero" + _center		                      
              Endif
            Elseif  _nSalBF < QRY->QTDZ9+aItens[_nPos,16] 
              IF _nSalBF > 0
                  cMensagem += "Saldo do SBF menor que a quantidade apontada" + _center		    
              ELSE
                 cMensagem += "Nao ha saldo no SBF - Saldo negativo ou Zero" + _center		                    
              Endif   
            Endif 
    
		    
		    cMensagem += "---------------------------------------   " + _center 
		    		
		Endif
	
	Endif
	
	dbSelectArea("QRY")
	
	dbSkip()
	
EndDo

If Len(aItens) >0
	//-- Inicializa o numero do Documento com o ultimo + 1
	dbSelectArea("SD3")
	nSavReg     := RecNo()
	cDocumento	:= IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)
	cDocumento	:= A261RetINV(cDocumento)
	dbSetOrder(2)
	dbSeek(xFilial("SD3")+cDocumento)
	cMay := "SD3"+Alltrim(xFilial())+cDocumento
	While D3_FILIAL+D3_DOC==xFilial()+cDocumento.Or.!MayIUseCode(cMay)
		If D3_ESTORNO # "S"
			cDocumento := Soma1(cDocumento)
			cMay := "SD3"+Alltrim(xFilial())+cDocumento
		EndIf
		dbSkip()
	EndDo
	
	lRet := u_BaixPeca(cDocumento,aItens,3)
	
	
	If lRet
		For i := 1 To Len(_aRecnoSZ9)
			dbSelectArea("SZ9")
			SZ9->(dbGoto(_aRecnoSZ9[i]))
			RecLock("SZ9",.F.)
			SZ9->Z9_NUMSEQS :=  cDocumento
			MsUnLock()
		Next i	
	Else
		cTitemail:="Transf Auditoria para Scrap nao Efetuada" 
		cMensagem := "Favor verificar! Transferencia Auditoria para Scrap não efetuada  : "+DTOC(date())+" - "+time()+" hrs."+ _center
	Endif

Endif

If !empty(cMensagem)
	//U_ENVIAEMAIL(cTitemail,"sistemas@bgh.com.br","",cMensagem,Path)
	U_ENVIAEMAIL(cTitemail,"transferencia.scrap@bgh.com.br","",cMensagem,Path)
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

Return
