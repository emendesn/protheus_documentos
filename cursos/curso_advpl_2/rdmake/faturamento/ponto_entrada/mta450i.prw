#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA450I  º Autor ³Edson Rodrigues     º Data ³  09/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava no campo C9_BLINF o bloqueo se C5_XLIBFAT estiver    º±±
±±º          ³ preenchido                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Mta450i()

Local _aSvAlias := {Alias(),IndexOrd(),Recno()}
Local _aArea    := GetArea()
local _cUpdate 	:= '' 
local _clibfat 	:=""
                     

u_GerA0003(ProcName())

DbSelectArea("SC5")
SC5->(DbSetOrder(1))                   
If Dbseek(xFilial("SC9")+SC9->C9_PEDIDO)
   _clibfat:=ALLTRIM(SC5->C5_XLIBFAT)
                                       
   If !empty(_clibfat) .AND. ALLTRIM(_clibfat)=="2"
    _cUpdate += " UPDATE "+RetSqlName("SC9")+" SET C9_BLINF = '"+_clibfat+"-BLOQUEADO PARA FATURAMENTO',C9_RETOPER='2' " 
    _cUpdate += " FROM   "+RetSqlName("SC5")+" AS C5 "
    _cUpdate += " JOIN   "+RetSqlName("SC9")+" AS C9 "
    _cUpdate += " ON     C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND C9_NFISCAL = '' AND C9.D_E_L_E_T_ = '' "
    _cUpdate += " WHERE  C5.D_E_L_E_T_ = '' AND C5_FILIAL = '"+xFilial("SC5")+"' AND C5_NUM = '"+SC5->C5_NUM+"'"
    tcsqlexec(_cUpdate)               
    TCRefresh(RetSqlName("SC9"))
    
   Endif
Endif  
    
	
RestArea(_aArea)

DbSelectArea(_aSvAlias[1])
DbSetOrder(_aSvAlias[2])
DbGoto(_aSvAlias[3])

Return