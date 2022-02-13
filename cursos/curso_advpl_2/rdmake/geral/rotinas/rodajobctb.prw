#INCLUDE "protheus.ch"                            
#INCLUDE "TBICONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RodajbCTB       ³ Edson Rodrigues       ³ Data ³ 02/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±|Descricao |Executa o Jobs automatico para contabilidade               |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
                                        


User Function Rodajbctb()            

Private aSM0     := {}
Private aFiles := { "SA1","SA2","SA3","SA6","SAE","SD1","SD2","SD3","SD8","SC2","SM2","MAH","MAL","CTW","CTX","CV8",;
"CT1","CT2","CT3","CT4","CT5","CT6","CT7","CTC","CTT","CTK","CTI","SI1","SI2","SI3","SI5","SI6","SI7","STL","SAN",;
"SB1","SB2","SB3","SB9","SBD","SC7","SE4","SF1","SF2","SF3","SF4","SF5","SF7","SF8","SFC","SX5","CTU","CTV","CTY" }       

If Select("NEWSM0") > 0
   dbSelectArea("NEWSM0")
   NEWSM0->(dbCloseArea())
Endif


dbUseArea(.T.,,"SIGAMAT.EMP", "NEWSM0",.T.,.F.)
DbSetIndex("SIGAMAT.IND")
SET(_SET_DELETED, .T.)

DbSelectArea("NEWSM0")
NEWSM0->( dbSetOrder(1) )
NEWSM0->( dbGotop() )
DO While ! NEWSM0->( Eof() )
    If NEWSM0->M0_CODIGO $ "01/99" .OR. NEWSM0->M0_CODFIL $ "03/04"
     NEWSM0->( dbSkip() )
     Loop
    Endif
        Aadd(aSM0,{ NEWSM0->M0_CODIGO,NEWSM0->M0_CODFIL })
          NEWSM0->( dbSkip() )
EndDo
If Select("NEWSM0") > 0
   dbSelectArea("NEWSM0")
   NEWSM0->(dbCloseArea())
Endif

  For nI := 1 To Len(aSM0)
   //PREPARE ENVIRONMENT EMPRESA aSM0[nI][1] FILIAL aSM0[nI][2] TABLES "SA1","SA2","SA3","SA6","SAE","SD1","SD2","SD3","SD8","SC2","SM2","MAH","MAL","CTW","CTX","CV8",;
   //"CT1","CT2","CT3","CT4","CT5","CT6","CT7","CTC","CTT","CTK","CTI","SI1","SI2","SI3","SI5","SI6","SI7","STL","SAN",;
   //"SB1","SB2","SB3","SB9","SBD","SC7","SE4","SF1","SF2","SF3","SF4","SF5","SF7","SF8","SFC","SX5","CTU","CTV","CTY"  MODULO "CTB"
   
   RPCSetType(3)
   RPCSETENV(aSM0[nI][1], aSM0[nI][2], "", "", "SIGACTB", "WF",{})
   //RPCSETENV("02", "02", "Administrador", "ms1603", "SIGAEST", "WF",{})
   Sleep( 5000 )     // aguarda 5 segundo para que as jobs IPC subam.
   SetHideInd(.T.) // evita problemas com indices temporarios
   __cLogSiga := "NNNNNNN"
   
         //U_JOBCTB350                 //Efetivação
         U_JOBCTB190(aFiles,nI)  //Reprocessamento
   
   
   
   
   __cLogSiga := GetMv("MV_LOGSIGA")
   
  Next nI                                       
 

//  U_JOBCTB220()  //consolidacao

Return                         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JOBCTB350       ³ Edson Rodrigues       ³ Data ³ 21/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±|Descricao |Executa efeivacao  Contabil                         |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function JOBCTB350(_aFiles,nI)
Local lExecuta     := iif(Left(Time(),5)>="00:10".And.Left(Time(),5)<="00:20",.T.,.F.) 
Local dDataIni     := FirstDay(LastDay(Date()-30))
Local dDataFim     := LastDay(Date()) // Date()+1 //

if lExecuta
  ConOut('Inicio Reprocessamento Empresa: '+aSM0[nI][1]+' Filial: ' +aSM0[nI][2]+    ' em '+Dtoc(Date())+' - '+Time())  
For nX:=1 To Len(_aFiles)
     If Select(_aFiles[nX]) == 0
          ChkFile(_aFiles[nX])
     Endif
Next nX

SX1->( DbSetOrder(1) )
SX1->( dbSeek( "CTB350" + "01" ) ) 
RecLock("SX1", .f.)
SX1->X1_CNT01 := "008850"     //Numero do Lote Inicial           
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := "008850"   // Numero do Lote Final  
SX1->(MsUnLock())
SX1->(dbSkip())          

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""+Dtoc(dDataIni)+"" // Data Inicial ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""+Dtoc(dDataFim)+"" // Data Final ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1 // Efetiva sem Bater Lote?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1 // Efetiva sem Bater Documento?       
SX1->(MsUnLock())
SX1->(dbSkip())     

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1 // Efetiva para sald?Real/Gerencial/Orcado  ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 2  // Verifica entidades contabeis? 
SX1->(MsUnLock())
SX1->(dbSkip())                             

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""     // SubLote Inicial? 
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := "ZZZZZZ"   //  SubLote Final?  
SX1->(MsUnLock())
SX1->(dbSkip())               

RecLock("SX1", .f.)
SX1->X1_PRESEL := 2  // Mostra Lanc. Contabeis? 2-Nao
SX1->(MsUnLock())
SX1->(dbSkip())     

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1 // Modo processamento  ?    1-efetivacao
SX1->(MsUnLock())
SX1->(dbSkip())                                    

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""     // SubLote Inicial? 
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := "ZZZZZZZZ"   //  SubLote Final?  
SX1->(MsUnLock())
SX1->(dbSkip())               


pergunte("CTB350",.F.)

ConOut('Incio Efetivacao Pre-Lancamento da Empresa: '+aSM0[nI][1]+' Filial: ' +aSM0[nI][2]+   ' em '+Dtoc(Date())+' - '+Time())
CTBA350()



cQuery := "UPDATE "+RetSqlName("CV8") + " SET CV8_PROC = 'CTBA350        ' "     
cQuery += " WHERE CV8_FILIAL = '" + xFilial("CV8") + "' AND D_E_L_E_T_ <> '*' AND" 
cQuery += " CV8_USER = 'JOBS           ' "
TCSQLExec(cQuery)           
TCRefresh(RetSqlName("CV8"))                  

ConOut('Termino Efetivacao Pre-Lancamento Empresa: '+aSM0[nI][1]+' Filial: ' +aSM0[nI][2]+    ' em '+Dtoc(Date())+' - '+Time())                     
endif
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JOBCTB190       ³ Edson Rodrigues       ³ Data ³ 02/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±|Descricao |Executa o Reprocessamento Contabil                         |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function JOBCTB190(_aFiles,nI)
Local lExecuta     := iif(Left(Time(),5)>="03:30".And.Left(Time(),5)<="03:35",.T.,.F.) 
Local dDataIni     := FirstDay(LastDay(Date()-30))
Local dDataFim     := LastDay(Date()) // Date()+1 //

if lExecuta
  ConOut('Inicio Reprocessamento Empresa: '+aSM0[nI][1]+' Filial: ' +aSM0[nI][2]+    ' em '+Dtoc(Date())+' - '+Time())  
For nX:=1 To Len(_aFiles)
     If Select(_aFiles[nX]) == 0
          ChkFile(_aFiles[nX])
     Endif
Next nX

SX1->( DbSetOrder(1) )
SX1->( dbSeek( "CTB190" + "01" ) ) // Reprocessa a partir ? por data ou ultimo fechamento ?
RecLock("SX1", .f.)
SX1->X1_PRESEL := 1
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""+Dtoc(dDataIni)+"" // Data Inicial ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""+Dtoc(dDataFim)+"" // Data Final ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := "" // Filial de ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := "zz" // Filial Ate ?
SX1->(MsUnLock())
SX1->(dbSkip())

//SX1->( dbSeek( "CTB190" + "06" ) )
RecLock("SX1", .f.)
SX1->X1_CNT01 := '1' // Tipo de Saldo ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 2 // Moedas ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := "01" // Qual Moeda ?
SX1->(MsUnLock())

pergunte("CTB190",.F.)

ConOut('Reprocessando Saldo : 1 da Empresa: '+aSM0[nI][1]+' Filial: ' +aSM0[nI][2]+   ' em '+Dtoc(Date())+' - '+Time())
   CTBA190(.F.,dDataIni,dDataFim," ","ZZ","1",.F.,"01")



cQuery := "UPDATE "+RetSqlName("CV8") + " SET CV8_PROC = 'CTBA190        ' "     
cQuery += " WHERE CV8_FILIAL = '" + xFilial("CV8") + "' AND D_E_L_E_T_ <> '*' AND" 
cQuery += " CV8_USER = 'JOBS           ' "

TCSQLExec(cQuery)                             
TCRefresh(RetSqlName("CV8"))

ConOut('Termino Reprecessamento Empresa: '+aSM0[nI][1]+' Filial: ' +aSM0[nI][2]+    ' em '+Dtoc(Date())+' - '+Time())                     
endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JOBCTB220       ³ Edson Rodrigues       ³ Data ³ 02/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±|Descricao |Executa o Consolidacao de Empresas/Filiais                 |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function JOBCTB220()       
Local lExecuta    := iif(Left(Time(),5)>="04:10".And.Left(Time(),5)<="04:15",.T.,.F.) 
Local dDataIni     :=FirstDay(LastDay(Date()-30)) 
Local dDataFin    := LastDay(Date()) // Date()+1 //                                                                       
Local luserbat     := .t.

if lExecuta
_aFiles := { "SA1","SA2","SA3","SA6","SAE","SD1","SD2","SD3","SD8","SC2","SM2","MAH","MAL","CTW","CTX","CV8",;
"CT1","CT2","CT3","CT4","CT5","CT6","CT7","CTC","CTT","CTK","CTI","SI1","SI2","SI3","SI5","SI6","SI7","STL","SAN",;
"SB1","SB2","SB3","SB9","SBD","SC7","SE4","SF1","SF2","SF3","SF4","SF5","SF7","SF8","SFC","SX5","CTU","CTV","CTY" }

ConOut('Inicio Consolidacao Empresa: 02 Filial: 03 em : '+Dtoc(Date())+' - '+Time())  

//PREPARE ENVIRONMENT  EMPRESA  "02" FILIAL "03"  USER "Administrador"  PASSWORD "ms1603"  TABLES "SA1","SA2","SA3","SA6","SAE","SD1","SD2","SD3","SD8","SC2","SM2","MAH","MAL","CTW","CTX","CV8"  MODULO "CTB"
 RPCSetType(3)
  //RPCSETENV(aSM0[nI][1], aSM0[nI][2], "", "", "SIGACTB", "WF",{})
 RPCSETENV("02", "03", "Administrador", "tv2809", "SIGAEST", "WF",{})
 Sleep( 5000 )     // aguarda 5 segundo para que as jobs IPC subam.
 SetHideInd(.T.) // evita problemas com indices temporarios
  __cLogSiga := "NNNNNNN"
   
   
 Sleep( 1000 )     // aguarda 1 segundos para que as jobs IPC subam.
 __cLogSiga := "NNNNNNN"
   

For nX:=1 To Len(_aFiles)
     If Select(_aFiles[nX]) == 0
          ChkFile(_aFiles[nX])
     Endif
Next nX



SX1->( DbSetOrder(1) )
SX1->( dbSeek( "CTB220" + "01" ) )

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1  // Limpa Consolidacao ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""+Dtoc(dDataIni)+"" // Data Inicial ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""+Dtoc(dDataFin)+"" // Data Final ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1   //Apaga  - periodo
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 2   //Processa Moeda - especifica
SX1->(MsUnLock())
SX1->(dbSkip())
                   
RecLock("SX1", .f.)
SX1->X1_CNT01 := '01'   //Quais Moeda - "Em branco" 
SX1->(MsUnLock())
SX1->(dbSkip())


RecLock("SX1", .f.)
SX1->X1_CNT01 := "1"    // Tipo de Saldo ?
SX1->(MsUnLock())
SX1->(dbSkip())
                   
RecLock("SX1", .f.)
SX1->X1_PRESEL := 2   //Gera Lancamento Saldo Inicial - Nao 
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := '' // Lote ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := '' // SubLote ?
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 := '' // Doc Saldo Inicial ?
SX1->(MsUnLock())

pergunte("CTB220",.F.)

ConOut('Consolidando Filiais : da Empresa Consolidadora: 02 Filial: 03 em '+Dtoc(Date())+' - '+Time())
   CTBA220(luserbat)
   
   
   
cQuery := "UPDATE "+RetSqlName("CV8") + " SET CV8_PROC = 'CTBA220        ' "     
cQuery += " WHERE CV8_FILIAL = '" + xFilial("CV8") + "' AND D_E_L_E_T_ <> '*' AND" 
cQuery += " CV8_USER = 'JOBS           ' "

TCSQLExec(cQuery)                                                                     
TCRefresh(RetSqlName("CV8"))

ConOut('Final Consolidacao Empresa: 02 Filial: 03 em : '+Dtoc(Date())+' - '+Time())  
__cLogSiga := GetMv("MV_LOGSIGA")           


Endif
Return()