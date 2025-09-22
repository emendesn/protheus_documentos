User Function T650()
Local _aMata650 := {}
Private lmsErroAuto := .f.
/* I N C L U S A O
_aMata650  := {{"C2_NUM"      ,"000001"          ,NIL},;
                {"C2_ITEM"     ,"01"              ,NIL},;
                {"C2_SEQUEN"   ,"001"             ,NIL},;
                {"C2_PRODUTO"  ,"10100          " ,NIL},;
                {"C2_LOCAL"    ,"01"              ,NIL},;
                {"C2_QUANT"    ,55                ,NIL},;
                {"C2_UM"       ,"UN"              ,NIL},;
                {"C2_DATPRI"   ,STOD("20000601") ,NIL},;
                {"C2_DATPRF"   ,STOD("20000630") ,NIL},;
                {"C2_TPOP"     ,"F"              ,NIL},;
                {"AUTEXPLODE"  ,"S"              ,NIL}}
*/                
/* A L T E R A C A O
_aMata650  := {{"C2_NUM"      ,"000001"          ,NIL},;
                {"C2_ITEM"     ,"01"              ,NIL},;
                {"C2_SEQUEN"   ,"001"             ,NIL},;
                {"C2_UM"       ,"UN"              ,NIL},; 
                {"C2_CC"       ,"16121    "       ,NIL},;
                {"C2_DATPRI"   ,STOD("20000601") ,NIL},;
                {"C2_DATPRF"   ,STOD("20000630") ,NIL}}
*/                                                      
_aMata650  := {{"C2_NUM"      ,"000001"          ,NIL},;
                {"C2_ITEM"     ,"01"              ,NIL},;
                {"C2_SEQUEN"   ,"001"             ,NIL}}                

msExecAuto({|x,Y|Mata650(x,Y)},_aMata650,5)
If lmsErroAuto
	msgalert("Deu Erro......")
Else
	msgalert("Ok")
EndIf

Return