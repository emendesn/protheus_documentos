#Include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

#define CMD_OPENWORKBOOK	   		1
#define CMD_CLOSEWORKBOOK		 	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAB5    บEDSON ESTEVAM               บ Data ณ  02/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria็ใo de registros que estejam no SB1 e nใo no SB5 para   บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DIVERSOS                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function GERAB5()

u_GerA0003(ProcName())

Private oDlg

@ 96,042 TO 343,680 DIALOG oDlg TITLE "Cria SB5"
@ 08,010 TO 84,310

@ 100,010 Button "Criar" 	When .T.	SIZE 35,13 OF oDlg PIXEL ACTION	{Processa	({|| GERANDO()	})}
@ 100,130 Button "Sair"  				SIZE 35,13 OF oDlg PIXEL ACTION	Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return



Static Function GERANDO()

cQuery := "SELECT R_E_C_N_O_ AS RECNOB1 FROM " + RetSqlName("SB1")+" SB1 "
cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += "	AND D_E_L_E_T_ = '' "
cQuery += "	AND B1_LOCPAD IN ('01','03') "
cQuery += "	AND B1_MSBLQL <> '1' "
cQuery += "	AND B1_LOCALIZ = 'S' "



cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSB1",.F.,.T.)

While !TRBSB1->(Eof())
	dbSelectArea("SB1")
	dbSetOrder(1)
	SB1->(dbGoTo(TRBSB1->RECNOB1))
	
	cProduto:= B1_COD
	cFilDes := "02"
	DbSelectarea ("SB5")
	DbSetorder(1)
	If !SB5->(dbSeek(xFilial("SB5") + cProduto ))
		
		//CriaSB5
		RecLock("SB5",.T.)
		SB5->B5_FILIAL  := cFilDes
		SB5->B5_COD     := cProduto
		SB5->B5_CEME    := cProduto
		SB5->B5_CODZON  := "000001"
		
		
		MsUnLock()
		
	ENDIF
	TRBSB1->(dbSkip())
Enddo


Return
   