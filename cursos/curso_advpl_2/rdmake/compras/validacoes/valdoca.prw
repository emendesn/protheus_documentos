#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VALDOCA  ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  02/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao dos campos de doca da NFE (D1_DTDOCA e D1_HRDOCA)º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function VALDOCA()

local _lRet    := .t.
local _nPosDat := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DTDOCA" })
local _nPosHor := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_HRDOCA" })
local _nNumSer := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_NUMSER" })
local _npospro := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_COD" })
local _cTime   := strtran(time(),":","")                                   
local _cusdoca :=GETMV('MV_UDTDOCA')
local _cOper
local _nPer  := 0
local _cLab

u_GerA0003(ProcName())
       
_cOper	:= Posicione("ZZ4",3,xFilial("ZZ4") + CNFISCAL + CSERIE + CA100FOR + cLoja +  aCols[n,_npospro] ,"ZZ4_OPEBGH")
_clab	:= POSICIONE("ZZJ",1,xFilial("ZZJ") + _cOper,"ZZJ_LAB") 
_nPer	:= Posicione("ZZJ",1,xFilial("ZZJ") + _cOper + _clab ,"ZZJ_PERDOC")


If readvar() == "M->D1_DTDOCA"         
     
     If (_cusdoca $ __cUserID) .or. (_nPer <= 0)
	 
	   _lRet := dtos(&(readvar())) <= dtos(dDataBase) 
	 
	 ElseIf _nPer > 0                                                                                  
	 
	   _lRet := dtos(&(readvar()))  <= dtos(dDataBase) .and. dDataBase - (&(readvar())) >= _nPer
	 
	 Endif  
endif           

//Habilitado variável logica com verdadeiro conforme necessidade do Claudio Biale.
//Desabilitado em 05/01/11
//_lret:=.t.    

//desabilitado "IF" conforme necessidade do Claudio Biale.
//Retornado em 05/01/11
If !_lRet
  IF _nPer > 0
    Aviso('Data da Doca','Data da Doca nao pode ser inferior a '+AllTrim(Transform(_nPer, "@E 999")) + ' dias ou maior que a data do sistema, peca para um usuario autorizado a incluir o Doc. de Entrada ou contate o administrador do sistema',{'OK'})  
  Else
    Aviso('Data da Doca','Data da Doca nao pode ser maior que a data do sistema, peca para um usuario autorizado a incluir o Doc. de Entrada ou contate o administrador do sistema',{'OK'})    
  Endif  
Endif          

If readvar() == "M->D1_HRDOCA" 
   If left(&(readvar()),2) > '23' .or.  substr(&(readvar()),3,2) > '59' .or. substr(&(readvar()),5,2) > '59'
      _lRet :=.f.
      Msgalert('Hora digitada inválida. Digite uma hora válida','Hora Entr. Doca Inválida')
   Endif   
Endif


return(_lRet)