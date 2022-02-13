#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  LIBEAP  ³ Autor ³  CLAUDIA CABRAL       ³ Data ³ 19/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Libera Aparelhos Presos na Senha do Usuario                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  nenhum                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function LiberaAp()
Private cUsu    := Space(15)
Private noBrw1  := 0
Private aApar   := {}
Private nTotApar := 0
Private oOk      := LoadBitmap( GetResources(), "LBOK" )
Private oNo      := LoadBitmap( GetResources(), "LBNO" )
Private oTik     := LoadBitmap( GetResources(), "LBTIK" )

u_GerA0003(ProcName())

SetPrvt("oDlg1","oGrp1","oSay1","oUsu","oBrw1","oSBtn1","oSBtn2")

oDlg1      := MSDialog():New( 089,232,600,930,"Liberação de Aparelhos",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 000,000,248,340,"Aparelhos Presos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 016,004,{||"Usuário:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
oSay2      := TSay():New( 016,112,{||"Total de Aparelhos"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,048,008)
oUsu       := TGet():New( 016,024,{|u| If(PCount()>0,cUsu:=u,cUsu)},oGrp1,060,008,'',{|u| BuscaApa()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"US3","cUsu",,)
oTotapar   := TGet():New( 016,160,{|u| If(PCount()>0,nTotapar:=u,nTotapar)},oGrp1,060,008,'',,CLR_RED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nTotapar",,)
@ 028,006 listbox oListBox fields HEADER " ","IMEI","OS" FIELDSIZES  5,50,50  SIZE 260,180 OF oDlg1 pixel    ON DBLCLICK (nPos:=oListbox:nAt,FS_Marca(),oListbox:Refresh(),oListbox:nAt:=nPos) 
                                                                           
@ 216,132 BUTTON "OK" SIZE 52,12  ACTION If(GravaAp(),(lRet:=.T.,oDlg1:End()),lRet:=.t.) of oDlg1 PIXEL  
@ 216,186 BUTTON "CANCELA" SIZE 52,12  ACTION (oDlg1:End()) OF oDlg1 PIXEL

If !Empty(cUsu)
   	BuscaApa()
EndIF   	

oDlg1:Activate(,,,.T.)

Return



Static Function BuscaApa()       
LOCAL cQryZZ4    := ""                                   

if Select("TRB") > 0
	TRB->(dbCloseArea())
endif


	/* Seleciona Aparelhos Presos */
	cQryZZ4     := "SELECT ZZ4_FILIAL,ZZ4_IMEI,ZZ4_OS "
	cQryZZ4     += "FROM " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK)" 
	cQryZZ4     += "WHERE ZZ4_FILIAL='" +  CFILANT + "' AND "     
	cQryZZ4     += " ZZ4_STATUS='7' AND "
	cQryZZ4     += " ZZ4_PV='' AND "	   
	cQryZZ4     += " ZZ4_SMUSER='" + cUsu + "' AND "	
	cQryZZ4     += " ZZ4.D_E_L_E_T_  = ' '"      
	DbSelectArea("ZZ4")
	astru = dbStruct()

	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQryZZ4), 'TRB', .F., .T.)
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField('TRB', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next      
	
	TRB->(dBGoTop())
	Do While ! TRB->(Eof()) 
		aAdd(aApar,{  .T.,	;
		              TRB->ZZ4_FILIAL,;
					  TRB->ZZ4_IMEI ,;
					  TRB->ZZ4_OS })
		TRB->(DbSkip())
	EndDo     
	
	Asort(aApar,,,{|x,y| x[1] < y[1]})
	DbSelectArea("TRB")      
	dbCloseArea() 
	oListBox:SetArray(aApar)       
	iF lEN(aAPar) > 0
		oListBox:nAt := 1 
	EndIF	
		oListBox:bLine := { || { if(aApar[oListBox:nAt,01] == .f.,oNo,oTik),;
 									aAPar[oListBox:nAt,02]}}            
 							
	oListBox:Refresh()		
		
	nTotApar := len(aApar)
	oTotApar:Refresh()
Return .t.
                                                       

Static Function GravaAp()
Local nMax        
Local nGravou:=0
CHKFILE("ZZ4",.F.)   
nMax := Len(aApar)
For i = 1 to nMax
	If ZZ4->(MsSeek(aApar[nMax,2] + aApar[nMax,3] + aApar[nMax,4],.t.))
	    
		Reclock("ZZ4",.f.)            
		ZZ4->ZZ4_STATUS :='6'
		MsUnlock()
		  
		nGravou++
    EndIF
Next
If nGravou <> nTotApar
	apMsgStop("Total de Aparelhos para liberacao : " + Alltrim(Transform(nTotApar,"999")) + " - Total de Aparelhos liberados: " + Alltrim(Transform(nGravou,"999")) ,"Total de Aparelhos Liberados Invalido")
Else	
	apMsgStop(Alltrim(Transform(nTotApar,"999")) + " Aparelhos Liberados !" ,"Liberacao de Aparelhos")
Endif
Return .t.

Static Function FS_Marca()


oListBox:SetArray(aApar)
oListBox:bLine := { || { if(aApar[oListBox:nAt,01] == .f.,oNo,oTik),;
aApar[oListBox:nAt,02]}}   

Return .t.