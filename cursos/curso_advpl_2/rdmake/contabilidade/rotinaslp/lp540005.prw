USER FUNCTION lp540005()

u_GerA0003(ProcName())

IF alltrim(SE1->E1_SITUACA) == '5'
                _CDEBITO := '11111'
ELSE
                _CDEBITO := '22222'
ENDIF


RETURN(_CDEBITO )