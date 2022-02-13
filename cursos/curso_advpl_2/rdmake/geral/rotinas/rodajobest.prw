//#include "rwmake.ch"
#INCLUDE "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch" 




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RodaJBESTQ      ³ Edson Rodrigues       ³ Data ³ 02/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function RodaJBESTQ()       
Local lExecuta     := iif(Left(Time(),5)>="00:01".And.Left(Time(),5)<="00:10",.T.,.F.) 
Local dDataIni     := FIRSTDAY(Date()-30) //
Local dDataFim     :=LastDay(Date()) 
Local aBGHFIL      :={}

iF lExecuta


 
_aFiles := { "SA1","SA2","SA3","SA6","SAE","SD1","SD2","SD3","SD8","SC2","SM2","MAH","MAL","CTW","CTX","CV8",;
"CT1","CT2","CT3","CT4","CT5","CT6","CT7","CTC","CTT","CTK","CTI","SI1","SI2","SI3","SI5","SI6","SI7","STL","SAN",;
"SB1","SB2","SB3","SB9","SBD","SC7","SE4","SF1","SF2","SF3","SF4","SF5","SF7","SF8","SFC","SX5","CTU","CTV","CTY" }

ConOut('Inicio Recalculo Custo Medio em : '+Dtoc(Date())+' - '+Time())  

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02"  TABLES "SA1","SA2","SA3","SA6","SAE","SD1","SD2","SD3","SD8","SC2","SM2","MAH","MAL","CTW","CTX","CV8" 



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
     AADD(aBGHFIL,(NEWSM0->M0_CODFIL))
    NEWSM0->( dbSkip() )
EndDo


For nX:=1 To Len(_aFiles)
     If Select(_aFiles[nX]) == 0
          ChkFile(_aFiles[nX])
     Endif
Next nX

SX1->( DbSetOrder(1) )
SX1->( dbSeek( "MTA330" + "01" ) )

RecLock("SX1", .f.)
SX1->X1_CNT01 := ""+Dtoc(dDataFim)+""  // Data Limite Final ?           
SX1->(MsUnLock())
SX1->(dbSkip())    

RecLock("SX1", .f.)
SX1->X1_PRESEL := 2   //Mostra Lanc Contabeis ? - 2=Nao
SX1->(MsUnLock())
SX1->(dbSkip())     

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1   //Aglutina Lanctos. Contabeis ?  - 1=SIM
SX1->(MsUnLock())
SX1->(dbSkip())     
                   
RecLock("SX1", .f.)
SX1->X1_PRESEL := 1   //Atualizar Arq. de Movimentos ? - 1=SIM
SX1->(MsUnLock())
SX1->(dbSkip())           

RecLock("SX1", .f.)
SX1->X1_PRESEL := 0   //% de Aumento da MOD ? - 0 
SX1->(MsUnLock())
SX1->(dbSkip())   

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1   //Centro de Custo ? - 1 - Contabil
SX1->(MsUnLock())
SX1->(dbSkip())                

RecLock("SX1", .f.)
SX1->X1_CNT01 := ''  //Conta Contabil a Inibir de ? - branco 
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_CNT01 :='ZZZZZZZZZZZZZZZ'     //Conta Contabil a Inibir ate ? - ZZZZZZZZZZZ  
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1   //Apaga Estornos ? // - SIM
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1   //Gera Lanc Contabil ?  - SIM 
SX1->(MsUnLock())
SX1->(dbSkip())
                   
RecLock("SX1", .f.)
SX1->X1_PRESEL := 1   //Gerar Estrut.pela Moviment. ?  - SIM
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 3   //Contabilizacao On-Line Por ?  - AMBAS
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 2   //Calcula Mao-de-Obra ?  - NAO
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 3   //Metodo de Apropriacao ? - DIARIA
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1   //Recalcula Niveis da Estrut. ? -SIM
SX1->(MsUnLock())
SX1->(dbSkip())
                   
RecLock("SX1", .f.)
SX1->X1_PRESEL := 2   //Mostra Sequencia do Calculo ? -Nao mostrar
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 2 // Seq Processamento FIFO   ? -Custo Medio
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1 // Mov Internos Valorizados ?  - Antes
SX1->(MsUnLock())
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 2 // Recalcula custos Transportes ? - Nao
SX1->(MsUnLock())           
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL :=3  // Calculo de Custos por ?  - Seleciona Filiais     
SX1->(MsUnLock())           
SX1->(dbSkip())

RecLock("SX1", .f.)
SX1->X1_PRESEL := 1 // Calcular Custo em Partes ?  - Sim     
SX1->(MsUnLock())           
SX1->(dbSkip())



   

pergunte("MTA330",.F.)

ConOut('Recalculando Custo medio das Filiais 01 e 02 em '+Dtoc(Date())+' - '+Time())
   MATA330(.T.,aBGHFIL)
cQuery := "UPDATE "+RetSqlName("CV8") + " SET CV8_PROC = 'MATA330        ' "     
cQuery += " WHERE CV8_FILIAL = '" + xFilial("CV8") + "' AND D_E_L_E_T_ <> '*' AND" 
cQuery += " CV8_USER = 'JOBS           ' "

TCSQLExec(cQuery)                                                                     
TCRefresh(RetSqlName("CV8"))

ConOut('Final Recalculo do Custo médio Empresa: 02 Filial: 01 e 02 em : '+Dtoc(Date())+' - '+Time())                

Endif

Return