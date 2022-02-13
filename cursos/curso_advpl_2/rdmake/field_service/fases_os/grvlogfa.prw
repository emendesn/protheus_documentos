#INCLUDE 'PROTHEUS.CH'
#include "Fileio.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GRVLOGFA   ºAutor  ³Eduardo - Delta    º Data ³  20/03/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravacao de LOG na rotina de apontamento para identificar  º±±
±±º          ³ causa de exclusao indevida do zz3                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function GRVLOGFA(_cSeqPrg)

Local _cLocArq  := GETMV("BH_LOCARQ",.F.,"\LOG\")
Local _cNomArq  := GETMV("BH_NOMARQ",.F.,"LOGFASE")
Local _cQuebra  := Chr(13) + Chr(10)   
Local _nHdlLog  := 0    
Local _cBarra   := " | "
Local _cArq	    := _cLocArq + _cNomArq +".TXT" 
Local _cData    := DTOS(dDataBase)
Local _cHora    := Left(Time(),5)
Local _cUsuario := SubStr(cUsuario,7,15)
Local _cAlias   := Alias()
Local _cRecno   := StrZero(Recno(),10)
Local _cSpace   := Space(3)          
Local _cRecZZ3  := ZZ3->(StrZero(Recno(),10))
Local _cEncOs   := ZZ3->(ZZ3_ENCOS)
Local _cStaZZ3  := ZZ3->(ZZ3_STATUS)
Local _cRecZZ4  := ZZ4->(StrZero(Recno(),10))
Local _cStaZZ4  := ZZ4->(ZZ4_STATUS)

u_GerA0003(ProcName())

DEFAULT _cSeqPrg := "999"
_cSeqPrg := StrZero(Val(_cSeqPrg),5)

_cTexto := _cData+_cBarra+_cHora+_cBarra+_cUsuario+_cBarra+_cSeqPrg+_cBarra+_cAlias+_cBarra+_cRecno+_cBarra+IIF(Deleted(),"Sim","Nao")
_cTexto := _cTexto +_cBarra+_cSpace+_cRecZZ3+_cBarra+_cSpace+_cEncOs+_cBarra+_cSpace+_cStaZZ3+_cBarra+_cSpace+_cRecZZ4+_cBarra+_cSpace+_cStaZZ4

If ! File(_cArq)
   _nHdlLog := FCreate(_cArq,0)
   Fwrite(_nHdlLog,"*********************  LOG REGISTROS DELETADOS APONTAMENTO DE FASE  ********************"+_cQuebra)
   Fwrite(_nHdlLog,_cQuebra)
   Fwrite(_nHdlLog,"Data     |  Hora |   Usuario       |Seq PRG|Alias|   Recno    | Del |    Recno ZZ3  |ENCOS |ZZ3STA| ZZ4_RECNO     | ZZ4_STATUS"+_cQuebra )
                 //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 
                 //          1         2         3         4         5         6         7         8         9
Else
  _nHdlLog := Fopen(_cArq)  
  FSEEK(_nHdlLog, 0, FS_END)  // Move o Ponteiro Para o Final do Arquivo
Endif   

Fwrite(_nHdlLog,_cTexto+_cQuebra)

fClose(_nHdlLog)

Return



