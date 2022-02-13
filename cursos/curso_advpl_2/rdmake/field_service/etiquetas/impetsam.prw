#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPETSAM  ºAutor  ³ Edson Rodrigues   º Data ³ 10/09/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para impressao da etiqueta de Laudo SAM           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function impetsam(_cimei)
private oDlg      := Nil
private ocimei    := nil
private cIMEI     := IIf(_cimei = nil,Space(TamSX3("ZZ4_IMEI")[1]),_cimei)
private lIMEI     := IIf(_cimei = nil,.F.,.T.)
private _aImpEtiq := {}
Private cPerg 	  := 'ETLAUSAM'             

u_GerA0003(ProcName())

CriaSX1(cPerg)
Pergunte(cPerg)
    
IF !lIMEI
  DEFINE MSDIALOG oDlg TITLE "Etiqueta de Laudo SAM" FROM 0,0 TO 210,420 OF oDlg PIXEL

  @ 010,015 SAY   "Informe o IMEI para imprimir a Etiqueta Laudo SAM." 	SIZE 150,008 PIXEL OF oDlg 
  @ 035,015 TO 070,180 LABEL "IMEI" PIXEL OF oDlg 
  @ 045,025 MSGET ocimei Var cIMEI PICTURE "@!" 	SIZE 080,010 Valid u_fimeisam(cImei) PIXEL OF oDlg 
  @ 080,140 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER
ELSE
   u_fimeisam(cImei)
ENDIF  

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fimeisam  ºAutor  ³Edson Rodrigues     º Data ³  10/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. Filtra dados Imei etiqueta Laudo SAM                            ³º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function fimeisam(_cImei)

local _aAreaZZ4 := ZZ4->(getarea())
local _aAreaSZA := SZA->(getarea())
Local _lachou   :=.f.
Local _lencerr  :=.f.
Local _loKimpr  :=.t.       
Local _grupoEtiq := "000036"  // ImpEtqPosEncSAM
Local _lPermSAM := .F.

SZA->(dbSetOrder(1))  // ZA_FILIAL + ZZ4_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI 
ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS
ZZ4->(dbGoTop())

//se estiver no grupo ImpEtqPosEncSAM imprime status >= 5, senão somente 5.

_codUser := RetCodUsr()
PswOrder(1) 
If PswSeek(_codUser,.T.)
   _aRetUser := PswRet(1)
   for x:=1 to len(_aRetUser[1][10])
   		if _aRetUser[1][10][x] == _grupoEtiq
   			_lPermSAM := .T.
   		endif  
   next                                  
endif                                     

If !empty(_cImei) .and. ZZ4->(dbSeek(xFilial("ZZ4") + _cImei))
   While ZZ4->(!eof()) .AND. ZZ4->ZZ4_FILIAL=xFilial("ZZ4") .AND. ZZ4->ZZ4_IMEI=_cImei 
      _lachou=.T.
      
      IF  ZZ4->ZZ4_STATUS >= '5' .and.  _lPermSAM .or.  ZZ4->ZZ4_STATUS == '5' .and. !  _lPermSAM
           _lencerr:=.t.
           
      	If Empty(ZZ4->ZZ4_DOCDTS) &&Incluída Condição para evitar impressão de Etiquetas já com processo encerrado - Thomas Galvao - 09/08/2012 - GLPI ID 7929
       		If SZA->(dbSeek(xFilial("SZA") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI))
	    		aAdd(_aImpEtiq, {ZZ4->ZZ4_OS, SZA->ZA_OSAUTOR,ZZ4->ZZ4_NFENR,ZZ4->ZZ4_NFESER,ZZ4->ZZ4_CODPRO,ZZ4->ZZ4_IMEI, ;
					 ZZ4->ZZ4_NFEDT,SZA->ZA_NFCOMPR+"/"+SZA->ZA_SERNFC,CTOD(SUBSTR(ZZ4->ZZ4_ATULT,7,2)+"/"+SUBSTR(ZZ4->ZZ4_ATULT,5,2)+"/"+LEFT(ZZ4->ZZ4_ATULT,4)), SZA->ZA_CODRECL, ZZ4->ZZ4_NFSNR, ZZ4->ZZ4_NFSSER,ZZ4->ZZ4_NFSDT,''})
          	Else        
         		aAdd(_aImpEtiq, {ZZ4->ZZ4_OS, ZZ4->ZZ4_OSAUTOR,ZZ4->ZZ4_NFENR,ZZ4->ZZ4_NFESER,ZZ4->ZZ4_CODPRO,ZZ4->ZZ4_IMEI, ;
					 ZZ4->ZZ4_NFEDT,'',CTOD(SUBSTR(ZZ4->ZZ4_ATULT,7,2)+"/"+SUBSTR(ZZ4->ZZ4_ATULT,5,2)+"/"+LEFT(ZZ4->ZZ4_ATULT,4)), '', ZZ4->ZZ4_NFSNR, ZZ4->ZZ4_NFSSER,ZZ4->ZZ4_NFSDT,''})
          	Endif
      	EndIf
     
      ENDIF
      ZZ4->(dbskip())
   Enddo
endif

if !_lachou
  ApMsgInfo("Imei não encotrado no arquivo de Entradas e Saidas, não é posssível imprimir a etiqueta de laudo SAM . ")
  _loKimpr:=.f.
elseif !_lencerr
  ApMsgInfo("Imei não encerrado, não é posssível imprimir a etiqueta de laudo SAM. ") 
  _loKimpr:=.f.
Endif 

If  _loKimpr
	U_Etqlausam(_aImpEtiq, Mv_Par01)
ENDIF

_cImei := cIMEI := Space(TamSX3("ZZ4_IMEI")[1])
ocimei:Setfocus()
_aImpEtiq:={}      


restarea(_aAreaZZ4)    
restarea(_aAreaSZA)

return(_loKimpr)

Static Function CriaSX1(cPerg)
	PutSX1(cPerg,"01","DPI ?","","","mv_ch1","N",1,0,0,"C","","" ,"","","mv_par01","1=300 dpi","","","","2=600 dpi","","","","","","","","","","","","","","","","","","")
Return