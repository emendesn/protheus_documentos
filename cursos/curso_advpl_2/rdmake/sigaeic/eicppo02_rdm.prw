#include "protheus.ch"


User Function EICPPO02
              
If Paramixb == "28"  // Adicionar campo no Browse da Tela de Itens da SI
   AADD(aSelItem,{"WKTPPROD",,AVSX3("A5_TPPROD",5)})
Endif   

If ParamIxb == "SEMFILTRO"   // Desabilita o Filtro por CC + SI
   Return .f.
Endif

Return .t.