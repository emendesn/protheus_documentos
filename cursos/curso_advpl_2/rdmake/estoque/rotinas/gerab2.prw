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
ฑฑบPrograma  ณGERAB2   บEDSON ESTEVAM               บ Data ณ  24/11/11    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria็ใo de Saldo Inicial no Sb2                             บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DIVERSOS                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function GERAB2()

Private oDlg

u_GerA0003(ProcName())


@ 96,042 TO 343,680 DIALOG oDlg TITLE "Cria SB2"
@ 08,010 TO 84,310

@ 100,010 Button "Criar" 	When .T.	SIZE 35,13 OF oDlg PIXEL ACTION	{Processa	({|| _CRIANDO()	})}
@ 100,130 Button "Sair"  				SIZE 35,13 OF oDlg PIXEL ACTION	Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return



Static Function _CRIANDO()



cQuery := "SELECT R_E_C_N_O_ AS RECNOB1 FROM " + RetSqlName("SB1")+" SB1 "
cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND B1_MSBLQL <> '1' "
cQuery += " AND B1_LOCPAD ='55' "
cQuery += " AND D_E_L_E_T_ <> '*'"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSB1",.F.,.T.)

While !TRBSB1->(Eof())
    
	//Abre a tabela e posiciona no registro	
	dbSelectArea("SB1")
	dbSetOrder(1)	
	SB1->(dbGoTo(TRBSB1->RECNOB1))
	 
    // RT
    // RE
	carmaz  :='55'
	cprod:= SB1->B1_COD
	
	  
	u_Saldoini(cprod,carmaz,.t.)
	
	
	TRBSB1->(dbSkip())
Enddo


Return
   
