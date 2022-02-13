#include "protheus.ch"
#include "rwmake.ch"                                       
//#INCLUDE "TBICONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CT220Sel ºAutor  ³Microsiga           º Data ³ 04 /01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada do PRG CTB220   .                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT220SEL(aEmp)
//Local cMVSchedu := Getnewpar('MV_XSCHEDU','' ) --Desabilitado esse parametro não se faz necessário o uso dele.
Local nJ   		:= 0
Local nI   		:= 0
Local lRet 		:= .T.   
Local aBGHEMP	:={}     

u_GerA0003(ProcName())                               

//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"  TABLES "SA1","SA2","SA3","SA6","SAE","SD1","SD2","SD3","SD8","SC2","SM2","MAH","MAL","CTW","CTX","CV8"  MODULO "CTB"

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
     Aadd(aBGHEMP,{NEWSM0->M0_CODIGO,NEWSM0->M0_CODFIL })
    NEWSM0->( dbSkip() )
EndDo

If len(aBGHEMP)> 0 .and. (ValType(aEmp) == 'A' .And. len(aEmp) > 0)
    // zero a array das empresas para somente informar as do parametro
    FOR nI = 1 to len(aEmp)
         aEmp[nI][1] := .F.
    NEXT
  
    // seto como verdadeiro os itens da empresa
    FOR nI = 1 to len(aBGHEMP)
      FOR nJ = 1 to len(aEmp)
         If aEmp[nJ][2]==aBGHEMP[nI][1] .AND. Substr(aEmp[nJ][3],1,2)==aBGHEMP[nI][2]
            aEmp[nJ][1] := .T.
         Endif
      Next
   Next
Endif

Return ( lRet)
