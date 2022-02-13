#include "protheus.ch"                       
#Include "topconn.ch"
#Define LFRC CHR(13)+Chr(10)


User Function AJBOUNCE()
Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New("AJBOUNCE","AJUSTAR BOUNCE/BOUNCE-SCRAP","",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir IMEIS que passaram mais de uma vez na BGH.")

oSection1 := TRSection():New(oReport,OemToAnsi("AJUSTAR BOUNCE"),{"TRB"})

TRCell():New(oSection1,"IMEI","TRB","IMEI","@!",20)
TRCell():New(oSection1,"NVEZATU","TRB","Num Vez Atual","@E 9999999999",10)
TRCell():New(oSection1,"BOUATU","TRB","Bounce Atual","@E 9999999999",10)
TRCell():New(oSection1,"NVEZNOV","TRB","Num Vez Novo","@E 9999999999",10)
TRCell():New(oSection1,"BOUNOV","TRB","Bounce Novo","@E 9999999999",10)
TRCell():New(oSection1,"ASCRATU","TRB","Ascrap Atual"," ",1)
TRCell():New(oSection1,"ASCRNOV","TRB","Ascrap Novo"," ",1)
TRCell():New(oSection1,"STATUS","TRB","Status","@!",20)
TRCell():New(oSection1,"STATSCR","TRB","Status Scrap","@!",20)

Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

// Selecao dos dados a Serem Impressos
MsAguarde({|| fSelReg()},"Selecionando Registros")


dbSelectArea("TRB")
dbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()

Do While TRB->(!Eof())
	If oReport:Cancel()
		Exit
	EndIf
	
	_nNvezAtu   := 0 
	_nBouAtu    := 0 
	_nNvezNov   := 0 
	_nBouNov    := 0 
	_cscratu    := "" 
	_cscrnov    := ""
	_cStatus	:= ""                                 
	cscrap      :="N"
	_cStscrap   :="OK"
	
	dbSelectArea("ZZ4")
	ZZ4->(dbGoto(TRB->RECNO06))
	
	_nNvezAtu   := ZZ4->ZZ4_NUMVEZ
	_nBouAtu    := ZZ4->ZZ4_BOUNCE
	_dNFEDT		:= ZZ4->ZZ4_NFEDT
	_cscratu    := ZZ4->ZZ4_ASCRAP
	 
	_cQuery := " SELECT "
	_cQuery += " 	ZZ4.ZZ4_OS AS OS "
	_cQuery += " FROM ZZ4020 ZZ4 "
	_cQuery += " WHERE "
	_cQuery += "	ZZ4.ZZ4_FILIAL IN ('02','06') AND "
	_cQuery += "	ZZ4.ZZ4_IMEI='"+ZZ4->ZZ4_IMEI+"'  AND "
	_cQuery += "	ZZ4.ZZ4_STATUS='9' AND "
	_cQuery += "	ZZ4.ZZ4_NFSDT < '"+DTOS(ZZ4->ZZ4_NFEDT)+"' AND "
	_cQuery += "	ZZ4.R_E_C_N_O_< "+ALLTRIM(STR(TRB->RECNO06))+" AND "
	_cQuery += "	ZZ4.D_E_L_E_T_ = '' "
	_cQuery += "	ORDER BY ZZ4.ZZ4_OS "
	
	//* Verifica se a Query Existe, se existir fecha
	If Select("TRB1") > 0
		dbSelectArea("TRB1")
		DbCloseArea()
	EndIf
	
	//* Cria a Query e da Um Apelido
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB1",.F.,.T.)    
	
	_cOSAnt := ""
	dbSelectArea("TRB1")
	dbGotop()
	Do While TRB1->(!Eof())
	 	If _cOSAnt<>TRB1->OS   
	 		_nNvezNov   += 1//ANTERIORES 
	 	Endif	
	 	_cOSAnt := TRB1->OS   
		dbSelectArea("TRB1")
		DbSkip()
	EndDo
	_nNvezNov   += 1 //proximo	
	
	_cQuery := " SELECT "
	_cQuery += "	MAX(ZZ4.R_E_C_N_O_)  AS RECNFSDT "
	_cQuery += " FROM ZZ4020 ZZ4 "
	_cQuery += " WHERE "
	_cQuery += "	ZZ4.ZZ4_FILIAL IN ('02','06') AND "
	_cQuery += "	ZZ4.ZZ4_IMEI='"+ZZ4->ZZ4_IMEI+"'  AND "
	_cQuery += "	ZZ4.ZZ4_STATUS='9' AND "
	_cQuery += "	ZZ4.ZZ4_NFSDT < '"+DTOS(ZZ4->ZZ4_NFEDT)+"' AND "
	_cQuery += "	ZZ4.R_E_C_N_O_< "+ALLTRIM(STR(TRB->RECNO06))+" AND "
	_cQuery += "	ZZ4.D_E_L_E_T_ = '' "
	
	//* Verifica se a Query Existe, se existir fecha
	If Select("TRB1") > 0
		dbSelectArea("TRB1")
		DbCloseArea()
	EndIf
	
	//* Cria a Query e da Um Apelido
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB1",.F.,.T.)    
		
	dbSelectArea("TRB1")
	dbGotop()
	
	dbSelectArea("ZZ4")
	ZZ4->(dbGoto(TRB1->RECNFSDT))
	
	_dNFSDT		:= IIF(EMPTY(ZZ4->ZZ4_NFSDT),_dNFEDT,ZZ4->ZZ4_NFSDT)
		
	_nBouNov    := IIF(_nNvezNov > 0,_dNFEDT-_dNFSDT,0)	
	
	If (_nNvezNov <> _nNvezAtu) .or. (_nBouNov <> _nBouAtu)
		//CASO QUEIRA AJUSTAR A TABELA TIRAR O COMENTARIO
		dbSelectArea("ZZ4")
		ZZ4->(dbGoto(TRB->RECNO06))
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_BOUNCE := _nBouNov
	    ZZ4->ZZ4_NUMVEZ := _nNvezNov 
	   	msunlock()
	   	
	   	
	   	_cStatus := "ANALISAR"
	Else
	 	_cStatus := "OK"
	Endif	
	
	if  Tecx011p(ZZ4->ZZ4_CODPRO,ZZ4->ZZ4_IMEI,@cscrap,TRB->RECNO06)
	    if cscrap <> _cscratu
	     
	       //CASO QUEIRA AJUSTAR A TABELA TIRAR O COMENTARIO
		 	dbSelectArea("ZZ4")
		   ZZ4->(dbGoto(TRB->RECNO06))
		   reclock("ZZ4",.f.)
		     ZZ4->ZZ4_ASCRAP := cscrap
	       msunlock()	      
	       _cStscrap := "ANALISAR"
	   	Else
	   	   _cStscrap := "OK"
	   	
	   	endif
	
	endif
	 
	oSection1:Cell("NVEZATU"):SetBlock( { ||_nNvezAtu})
	oSection1:Cell("BOUATU"):SetBlock( { ||_nBouAtu})
	oSection1:Cell("NVEZNOV"):SetBlock( { ||_nNvezNov})
	oSection1:Cell("BOUNOV"):SetBlock( { ||_nBouNov})
	oSection1:Cell("ASCRATU"):SetBlock( { ||_cscratu})
	oSection1:Cell("ASCRNOV"):SetBlock( { ||cscrap})
	oSection1:Cell("STATUS"):SetBlock( { ||_cStatus})
	oSection1:Cell("STATSCR"):SetBlock( { ||_cStscrap})

	
	
	oSection1:PrintLine()
	
	dbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()


If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

Return

Static Function fSelReg()

_cQuery := " SELECT "
_cQuery += " 	TRB.IMEI,TRB.RECNO06,TRB.BOUNCE "
_cQuery += " FROM "
_cQuery += " 	(  "
_cQuery += " 		SELECT "
_cQuery += " 			ZZ4_6.ZZ4_IMEI AS IMEI, "
_cQuery += " 			ZZ4_6.R_E_C_N_O_ AS RECNO06, "
_cQuery += " 		(	"
_cQuery += " 			SELECT COUNT(*) "
_cQuery += " 			FROM ZZ4020 ZZ4 (NOLOCK) "
_cQuery += " 			WHERE "
_cQuery += " 				ZZ4.ZZ4_FILIAL IN ('02','06') AND "
_cQuery += " 				ZZ4.D_E_L_E_T_='' AND "
_cQuery += " 				ZZ4.ZZ4_IMEI=ZZ4_6.ZZ4_IMEI "
_cQuery += " 		)  AS BOUNCE "
_cQuery += " 		FROM ZZ4020 ZZ4_6 (NOLOCK) "
_cQuery += " 		WHERE "
_cQuery += " 			ZZ4_6.ZZ4_FILIAL='06' AND "
_cQuery += "			ZZ4_6.ZZ4_CHVFIL = '' AND "
_cQuery += " 			ZZ4_6.ZZ4_STATUS>='3' AND "
_cQuery += " 			ZZ4_6.ZZ4_NFEDT>='20130911' AND "
_cQuery += " 			ZZ4_6.D_E_L_E_T_ = '' "
_cQuery += " 	) AS TRB "
_cQuery += " WHERE TRB.BOUNCE > 1 "
_cQuery += " ORDER BY TRB.IMEI,TRB.RECNO06 "

//* Verifica se a Query Existe, se existir fecha
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)     

Return                                                                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tecx011P  ºAutor  Edson Rodrigues      º Data ³  23/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica ultimo atendimento e se a fase de encerramento é  º±±
±±           ³ SCRAP                                                      ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tecx011p(cProAT,cCodBarAT,cscrap,_nreczz4)

Local cQryAtend
Local lResult:=.F.
Local _clab  :=""
cscrap :="N"


ZZJ->(dbSetorder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB


If Select("QRYAtend") > 0
	QRYAtend->(dbCloseArea())
Endif

cQryAtend:=" SELECT ZZ4_FILIAL,ZZ4_OS,ZZ4_FASATU,ZZ4_SETATU,ZZ4_OPEBGH "
cQryAtend+=" FROM "+RetSQLName('ZZ4')+" A (nolock) "
cQryAtend+=" INNER JOIN "
cQryAtend+="       (SELECT MAX(R_E_C_N_O_) RECNO FROM "+RetSQLName('ZZ4')+" C (NOLOCK) "
cQryAtend+="        WHERE ZZ4_IMEI='"+cCodBarAT+"' AND R_E_C_N_O_ < "+ALLTRIM(STR(_nreczz4))+" AND D_E_L_E_T_='' AND ZZ4_STATUS='9') AS B "
cQryAtend+=" ON A.R_E_C_N_O_ = B.RECNO "
cQryAtend+=" WHERE ZZ4_IMEI='"+cCodBarAT+"' AND R_E_C_N_O_ < "+ALLTRIM(STR(_nreczz4))+" AND D_E_L_E_T_='' AND ZZ4_STATUS='9' "

TCQUERY cQryAtend NEW ALIAS "QRYAtend"

If Select("QRYAtend") > 0
	QRYAtend->(dbGoTop())
	While QRYAtend->(!eof()) .and. !Empty(QRYAtend->ZZ4_FASATU)
		
		If ZZJ->(dbSeek(xFilial("ZZJ")+QRYAtend->ZZ4_OPEBGH))
			_clab:=ZZJ->ZZJ_LAB
		ElseIf  ZZJ->(dbSeek(xFilial("ZZJ")+ALLTRIM(mv_par09)))
			_clab:=ZZJ->ZZJ_LAB
		Endif
		
		dbSelectArea('ZZ1')  //Cadastro de Fases
		If ZZ1->(dbSeek(xFilial("ZZ1")+_clab+QRYAtend->ZZ4_SETATU+QRYAtend->ZZ4_FASATU))
			If ZZ1->ZZ1_SCRAP='S'
				lResult:=.T.
				cscrap :="S"
			Endif
			
		ELSE
			dbSelectArea('ZZ3')  //Apontamento de Fases
			If ZZ3->(dbSeek(QRYAtend->ZZ4_FILIAL + cCodBarAT + QRYAtend->ZZ4_OS))
				_cfase:=ZZ3->ZZ3_FASE1
				_csetor:=ZZ3->ZZ3_CODSET
				
				While (ZZ3->ZZ3_FILIAL == QRYAtend->ZZ4_FILIAL) .And. (ZZ3->ZZ3_IMEI == cCodBarAT) .And. (left(ZZ3->ZZ3_NUMOS,6) == left(QRYAtend->ZZ4_OS,6))
					If ZZ3->ZZ3_STATUS=='1'  .AND. ZZ3_ENCOS='S' .AND. ZZ3_ESTORN<>'S'
						If ZZ1->(dbSeek(xFilial("ZZ1") +_clab+ _csetor+_cfase))
							If ZZ1->ZZ1_SCRAP=="S"
								lResult:=.T.
								cscrap :="S"
							Endif
						Endif
					Endif
					ZZ3->(Dbskip())
				EndDo
			Endif
		Endif
		QRYAtend->(Dbskip())
	EndDo
	QRYAtend->(dbCloseArea())
Endif

Return(lResult)
