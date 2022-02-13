USER FUNCTION GETAMB( aAlias )
LOCAL f := 0, cAlias := '', aAmb := {}

u_GerA0003(ProcName())

FOR F:= 1 TO LEN( aAlias )
	cAlias := aAlias[f]
	DBSELECTAREA( cAlias )
	AADD( aAmb , { cAlias , recno(), indexord() } )
NEXT
RETURN( aAmb )
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
USER FUNCTION RESTAMB( aAmb )
LOCAL cAlias := ''; F := 0
FOR F := 1 TO LEN( aAmb )
	cAlias := aAmb[f,1]
	DBSELECTAREA(cAlias)     // seleciona o alias
	DBSETORDER( aAmb[f,3] )  // ajusta a ordem
	DBGOTO( aAmb[f,2] )      // posiona no registro
NEXT
RETURN
