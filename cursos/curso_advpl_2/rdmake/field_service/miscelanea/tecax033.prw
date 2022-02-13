#Include "Rwmake.ch"
#include "VKey.ch"
#Include "Colors.ch"
#include "cheque.ch"
#include "topconn.ch"
#define LFRC CHR(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECAX033  ºAutor  ³Microsiga           º Data ³  01/13/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para efetuar encerramento automatico de toda a    º±±
±±º          ³ posicao de aparelhos abertos da Nextel                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function TECAX033(_cCodTec,_cCodFas,_cCodSet,_clab,_cetqmast,codoper,_csaimass,_ctransc)  

Private _lRetTec   := .F.
Private _SerEnt    :={}   
Private _cmudfdes  := GETMV("MV_MUDFDES")
Private _cmudfori  := GETMV("MV_MUDFORI")

If _cCodTec=nil .and. _cCodFas=nil .and. _cCodSet=nil .and._clab=nil .and. _cetqmast=nil .and. codoper=nil .and. _csaimass=nil  
    Private cPerg		:= "ENCOS1"
    ValidPg1() // Ajusta as Perguntas do SX1
    If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	      Return
    Endif
    
    IF MV_PAR01==1
       _lret:=U_TECAX33A()
    Else
       _lret:=u_TECAX33B()
    Endif  

Else
    _ctransc:=iif(_ctransc=nil,space(3),_ctransc)
   _lret:=u_TECAX33C(_cCodTec,_cCodFas,_cCodSet,_clab,_cetqmast,codoper,_csaimass,_ctransc)
endif

Return(_lret)
                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECAX33B  ºAutor  ³Edson Rodrigues     º Data ³  15/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa processo de encerramento Os e Saida massiva para   º±±
±±º            leituras de etiquetas Master de aparelhos em estoque      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function TECAX33B()
  Private cTexto      := ''
  Private _lFechEM    := .F.
  _lret:=U_tecx33D()

Return(_lret)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECAX33C  ºAutor  ³Edson Rodrigues     º Data ³  15/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa processo de encerramento Os e Saida massiva para   º±±
±±º            solicitacao vindo de triagem de aparelhos em processo      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function TECAX33C(_cCodTec,_cCodFas,_cCodSet,_clab,_cetqmast,codoper,_csaimass,_ctransc)


   Local bAcao    := {|lFim| qryencos(@lFim,3,_cetqmast) }
   Local cTitulo  := 'Encerra OS - Filtro Triagem'
   Local cMsg     := 'Filtrando Triagem para execucao dos encerramentos...'
   Local cerroMsg := ""
   Local lAborta  := .T.
   private _cArqlog  := "ENCOS_"+dtos(dDataBase)+"_"+time()+".txt"
   private handle   := fCreate(_cArqlog,0)
   private cartime   :="00000000000000000000"     
   private cnumlin   :="NA"
   private _cCodTec  := _cCodTec                                            
   private _cCodSet  := _cCodSet
   private _cCodFas  := _cCodFas
   private _ctransc  := _ctransc
   private cartime   :="00000000000000000000"     
   private cnumlin   :="NA"  
   Private _cmudfdes  := GETMV("MV_MUDFDES")
   Private _cmudfori  := GETMV("MV_MUDFORI")
    
   //_lret:=Processa( bAcao, cTitulo, cMsg, lAborta )
     _lRetTec:=qryencos(.t.,3,_cetqmast,codoper)


   IF  _lRetTec                                                               
            bAcao   := {|lFim| encOS(@lFim,_clab,_cetqmast,codoper,_cCodTec,_cCodSet,_cCodFas,_ctransc,cartime,cnumlin) }
            cTitulo := 'Encerra OS - Execucao de Encerramentos/Triagem'
            cMsg    := 'executando encerramento das OS-Triagem..aguarde...' 
            //_lret:=Processa( bAcao, cTitulo, cMsg, lAborta )      
            _lRetTec:=encOS(.t.,_clab,_cetqmast,codoper,_cCodTec,_cCodSet,_cCodFas,_ctransc,cartime,cnumlin)
            
            If _lRetTec .and. _csaimass=="S"
               bAcao   := {|lFim| qryencos(@lFim,4,_cetqmast) }
               cTitulo := 'Saida Massiva - Filtro Encerramentos/Triagem'
               cMsg:= 'Filtrando Encerramentos/Triagem para execucao da saidam massiva-triagem...'
               //_lret:=Processa( bAcao, cTitulo, cMsg, lAborta )
               _lRetTec:=qryencos(.t.,4,_cetqmast)

               If _lRetTec
                  bAcao   := {|lFim| qryencos(@lFim,4,_cetqmast) }
                  cTitulo := 'Saida Massiva - Executa Saida Massiva/Triagem'
                  cMsg:= 'Executando saida massiva-triagem, aguarde...'
                  
                  If !_lRetTec
                      cerroMsg:=" Execução da Saida Massiva com erro, verifique erro no arquivo de log "+_cArqlog+"." 
                  Endif
               Else
                  cerroMsg:=" Execução do filtro da Saida Massiva com erro, verifique erro no arquivo de log "+_cArqlog+"."
               Endif 
            Elseif  !_lRetTec 
              cerroMsg:=" Execução dos encerramento das OS com erro, verifique erro no arquivo de log "+_cArqlog+"."           
            Endif
   else         
       cerroMsg:=" Execução do filtro para os encerramentos das OS com erro, verifique erro no arquivo de log "+_cArqlog+"."
   Endif                                                                              
   If !empty(cerroMsg)
           MsgStop(cerroMsg)
   Endif
Return(_lRetTec)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecax33a  ºAutor  ³Microsiga                 ºData ³  /  /  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecax33a()

private _cArqNex := "Nextel_ENCOS_"+dtos(dDataBase)+"_"+time()+".txt"
private handle   := fCreate(_cArqNex,0)
private _cCodTec  := "N15"
private _cCodSet  := "000001"
private _cCodFas  := "04"
private _ctransc  := "IOW"
private cartime   :="00000000000000000000"     
private _clab     := '2'                     
private _cetqmast := space(20)   
private codoper   := space(3)
private cnumlin   :="NA"

u_GerA0003(ProcName())

// Importar posicao de inventario dos IMEIs Nextel
// ImpNextel()
// Importacao realizada atraves do Excel -> BrOffice 3.0 -> DBF -> DTS do SQL

// Efetua atualizacoes para status 3 e 4 => ENCERRAR OS
qryencos(.t.,1)
//alert('executou query 1')
encOS(.t.,_clab,_cetqmast,codoper,_cCodTec,_cCodSet,_cCodFas,_ctransc,cartime,cnumlin)
//alert('encerrou OS')

// Efetua atualizacoes para status 5 => EFETUAR SAIDA MASSIVA
// Esta rotina ja gera o PV automaticamente
qryencos(.t.,2)
//alert('executou query 2')
SaiMas() 			
alert('executou saida massiva')	
// Status 6/7   => GERAR PEDIDO DE VENDA
//qryNex('6','7')
//PedVenNex()

alert('rotina concluida')

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECAX033  ºAutor  ³Microsiga           º Data ³  01/13/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Faz filtros para encerramento da OS e saida Massiva       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function qryencos(lFim,_nVez,_cetqmast,codoper)
 
local _cQuery   := ""
Local _cetqmast :=iif(_cetqmast=nil,space(20),_cetqmast)
local _Enter    := chr(13) + chr(10)

If Select("TRB1") > 0
   TRB1->(dbCloseArea())
ENDIF
If Select("TRB2") > 0
   TRB2->(dbCloseArea())
ENDIF



IF _nVez==1 .or. _nVez==2
      _cQuery := _Enter + " SELECT DISTINCT NEX.*, ZZ4_STATUS, "
      _cQuery += _Enter + "        ZZ4.*, "
      _cQuery += _Enter + "        RECZZ4 = CASE WHEN ZZ4.R_E_C_N_O_ IS NOT NULL THEN ZZ4.R_E_C_N_O_ ELSE 0 END,"
      _cQuery += _Enter + "        RECSD1 = CASE WHEN SD1.R_E_C_N_O_ IS NOT NULL THEN SD1.R_E_C_N_O_ ELSE 0 END "
      _cQuery += _Enter + " FROM   SCRAPSP AS NEX (NOLOCK)" 
      _cQuery += _Enter + " LEFT OUTER JOIN "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK)"
      _cQuery += _Enter + " ON     ZZ4.D_E_L_E_T_ = '' AND ZZ4_FILIAL ='"+xFilial("ZZ4")+"'  AND "
      _cQuery += _Enter + "        ZZ4_CODCLI = NEX.CLIENTE AND "
      _cQuery += _Enter + "        ZZ4_STATUS < '8' AND "
      _cQuery += _Enter + "        NEX.NUMOS = LEFT(ZZ4_OS,6) AND RTRIM(NEX.NFE) = RTRIM(ZZ4_NFENR) AND RTRIM(NEX.SERIE) = RTRIM(ZZ4_NFESER)" 
      _cQuery += _Enter + " LEFT OUTER JOIN "+RetSqlName("SD1")+" AS SD1 (NOLOCK)"
      _cQuery += _Enter + " ON     SD1.D_E_L_E_T_ = '' AND D1_FILIAL ='"+xFilial("SD1")+"'  AND D1_DOC = ZZ4_NFENR AND "
      _cQuery += _Enter + "        D1_SERIE = ZZ4_NFESER AND D1_FORNECE = ZZ4_CODCLI AND D1_LOJA = ZZ4_LOJA AND" 
      _cQuery += _Enter + "        D1_ITEM = ZZ4_ITEMD1 AND D1_LOCAL = NEX.ARMAZEM " //AND D1_TES = '727' AND D1_CF = '5919'"        
      _cQuery += _Enter + " LEFT OUTER JOIN "
      _cQuery += _Enter + "  (SELECT ZZ3_NUMOS FROM ZZ3020  Z3 (NOLOCK) 
      _cQuery += _Enter + "  WHERE Z3.D_E_L_E_T_='' AND Z3.ZZ3_ENCOS='S' AND Z3.ZZ3_USER='edson.rodrigues' AND Z3.ZZ3_ESTORN<>'S' AND Z3.ZZ3_STATUS='1') AS ZZ3 "
      _cQuery += _Enter + "  ON ZZ3_NUMOS=NEX.NUMOS "
      _cQuery += _Enter + "  LEFT OUTER JOIN  "
      _cQuery += _Enter + "  (SELECT ZZ3_NUMOS FROM ZZ3020  Z32 (NOLOCK) "
      _cQuery += _Enter + "  WHERE Z32.D_E_L_E_T_='' AND Z32.ZZ3_ENCOS='S' AND Z32.ZZ3_USER<>'edson.rodrigues' AND Z32.ZZ3_ESTORN<>'S' AND Z32.ZZ3_STATUS='1') AS ZZ32 "
      _cQuery += _Enter + "  ON ZZ32.ZZ3_NUMOS=NEX.NUMOS "
      _cQuery += _Enter + "  LEFT OUTER JOIN  "
      _cQuery += _Enter + "  (SELECT Z9_NUMOS FROM SZ9020  Z9 (NOLOCK) "
      _cQuery += _Enter + "     INNER JOIN (SELECT ZZ4_FILIAL,ZZ4_OS FROM ZZ4020 (NOLOCK) WHERE D_E_L_E_T_='' AND ZZ4_GARANT='S') AS ZZ4S "
      _cQuery += _Enter + "     ON Z9_FILIAL=ZZ4S.ZZ4_FILIAL AND LEFT(Z9_NUMOS,6)=ZZ4S.ZZ4_OS "
      _cQuery += _Enter + "  WHERE Z9.D_E_L_E_T_='' AND Z9.Z9_STATUS='1' AND Z9_PARTNR<>'') AS SZ9 "
      _cQuery += _Enter + "  ON SZ9.Z9_NUMOS=NEX.NUMOS  "
      if _nVez == 1
         _cQuery += _Enter + " WHERE ZZ4.ZZ4_STATUS < '5' AND NEX.PROCESSADO NOT IN ('E','F','P','S','X') "        
//         _cQuery += _Enter +" AND ZZ4_CODPRO='MPI296-U' "
      Else
         _cQuery += _Enter + " WHERE ZZ4.ZZ4_STATUS = '5' AND NEX.PROCESSADO NOT IN ('E','F','P','S','X') "             
//          _cQuery += _Enter +" AND ZZ4_CODPRO='MPI296-U' "
         _cQuery += _Enter + " ORDER BY ZZ4.ZZ4_CODCLI,ZZ4.ZZ4_LOJA,ZZ4.ZZ4_NFENR,ZZ4.ZZ4_NFESER,ZZ4.ZZ4_CODPRO "          
      Endif

Elseif _nVez == 3 .or. _nVez == 4 

    If empty(_cetqmast)
	   _lqrytri:=.f.
	   _cetqmast:=Replicate(' ',20)
	   return(_lqrytri)
    endif
    _cQuery := _Enter + " SELECT ZZO.*,ZZ4.*, "
    _cQuery += _Enter + "        RECZZ4 = CASE WHEN ZZ4.R_E_C_N_O_ IS NOT NULL THEN ZZ4.R_E_C_N_O_ ELSE 0 END,"
    _cQuery += _Enter + "        RECSD1 = CASE WHEN SD1.R_E_C_N_O_ IS NOT NULL THEN SD1.R_E_C_N_O_ ELSE 0 END "
    _cQuery += _Enter + " FROM "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK)"
    _cQuery += _Enter + " INNER JOIN 
    _cQuery += _Enter + "      (   SELECT ZZO_NUMCX,ZZO_IMEI "
    _cQuery += _Enter + "          FROM   "+RetSqlName("ZZO")+" (nolock) "
    _cQuery += _Enter + "          WHERE  ZZO_FILIAL  = '"+xFilial("ZZO")+"' AND "
    _cQuery += _Enter + "          ZZO_NUMCX  = '"+_cetqmast+"'  AND "
    IF codoper="03"    
       _cQuery += _Enter + "          ZZO_STATUS  = 'P'  AND "
    ELSEIF codoper="02"
       _cQuery += _Enter + "          ZZO_STATUS  = 'E'  AND "    
    ENDIF    
    _cQuery += _Enter + "          ZZO_DESTIN  = 'B'  AND "
    _cQuery += _Enter + "          ZZO_SEGREG  = 'N'  AND "
    _cQuery += _Enter + "          ZZO_ENVARQ  = 'N'  AND "
    _cQuery += _Enter + "          D_E_L_E_T_  = '' "
    _cQuery += _Enter + "       ) AS ZZO "
    _cQuery += _Enter + " ON ZZ4_IMEI=ZZO_IMEI "
    _cQuery += _Enter + " LEFT OUTER JOIN "+RetSqlName("SD1")+" AS SD1 (NOLOCK) "
    _cQuery += _Enter + " ON     SD1.D_E_L_E_T_ = '' AND D1_FILIAL ='"+xFilial("SD1")+"'  AND D1_DOC = ZZ4_NFENR AND "
    _cQuery += _Enter + "        D1_SERIE = ZZ4_NFESER AND D1_FORNECE = ZZ4_CODCLI AND D1_LOJA = ZZ4_LOJA AND " 
    _cQuery += _Enter + "        D1_ITEM = ZZ4_ITEMD1                                             " 

    If  _nVez == 3 
        _cQuery += _Enter + " WHERE ZZ4.ZZ4_STATUS >= '3' AND ZZ4.ZZ4_STATUS <= '4' AND ZZ4.D_E_L_E_T_='' " 
    elseif  _nVez == 4
       _cQuery += _Enter + " WHERE ZZ4.ZZ4_STATUS '5' AND ZZ4.D_E_L_E_T_='' " 
       _cQuery += _Enter + " ORDER BY ZZ4.ZZ4_CODCLI,ZZ4.ZZ4_LOJA,ZZ4.ZZ4_NFENR,ZZ4.ZZ4_NFESER,ZZ4.ZZ4_CODPRO "          
    endif
    
Endif


_cQuery := strtran(_cQuery,_Enter,"")

if _nVez == 1 .or. _nVez == 3
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery),"TRB1",.T.,.T.)
	dbSelectArea("TRB1")
    TRB1->(dbGoTop())

elseif _nVez == 2  .or.  _nVez == 4
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cquery),"TRB2",.T.,.T.)
	dbSelectArea("TRB2")
    TRB2->(dbGoTop())

endif

return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECAX033  ºAutor  ³Microsiga           º Data ³  01/13/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function encOS(lfim,_clab,_cetqmast,codoper,_cCodTec,_cCodSet,_cCodFas,_ctransc,cartime,cnumlin)

local _aAreaZZ4 := ZZ4->(getarea())
local _aAreaAB6 := AB6->(getarea())
local _aAreaAB7 := AB7->(getarea())
local _cFilial  := xFilial("ZZ4")
local _cNumOS   := ""
Local _clab     :=iif(_clab=nil,space(1),_clab)
Local _cetqmast :=iif(_cetqmast=nil,space(20),_cetqmast) 
local _lpassou  := .f.


ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
AB6->(dbSetOrder(1)) // AB6_FILIAL + AB6_NUMOS
AB7->(DBOrderNickName('AB7NUMSER'))//AB7->(dbSetOrder(6)) // AB7_FILIAL + AB7_NUMOS + AB7_NUMSER
AB1->(dbSetOrder(1)) // AB1_FILIAL + AB1_NRCHAM

// processa o arquivo todo da query de status 3/4
TRB1->(dbGoTop())
while TRB1->(!eof())
	
	// procura o IMEI no ZZ4 e verifica nr. da NFE
	if TRB1->RECZZ4 > 0 .and. TRB1->RECSD1 > 0 //ZZ4->(dbSeek(_cFilial + TRB1->IMEI))

	
		// Posiciona ZZ4 no registro identificado pela query
		ZZ4->(dbGoTo(TRB1->RECZZ4))
		
		// Verifica se o IMEI está sendo apontado da fase atual por outro tecnico e nao confirmada //  Edson Rodrigues - 26/07/10
		_capontenc :="N"
		//_capontenc := u_VerEncer(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
        _lpeca :=.f.
        
        //IF ZZ4->ZZ4_GARANT == 'S'
        //    _lpeca :=u_Verexipec(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
        //ENDIF


		if _capontenc<>'S' .and. !_lpeca
		

		    _cNumOS := left(ZZ4->ZZ4_OS,6)
		
		    if !ZZ4->ZZ4_STATUS $ "34"
		
			   // Atualiza log de transacoes
			   AtuLog(TRB1->ZZ4_IMEI, _cNumOS, "Status: "+ZZ4->ZZ4_STATUS+" - diferente de 3/4")
		
     		Elseif AB6->(dbSeek(_cFilial + _cNumOS)) .and. AB7->(dbSeek(_cFilial + _cNumOS + ZZ4->ZZ4_IMEI)) 
     		   _lpassou:=.t.

     		Else 
     		                
			                		cContVez := 0
		                			cItens:='01'
						     		//Chamado Tecnico
									cNrCham:= GetSxeNum('AB1','AB1_NRCHAM')
									RecLock('AB1',.T.)
									AB1->AB1_FILIAL:=xFilial('AB1')
									AB1->AB1_NRCHAM:=cNrCham
									AB1->AB1_CODCLI:=ZZ4->ZZ4_CODCLI
									AB1->AB1_LOJA  :=ZZ4->ZZ4_LOJA
									AB1->AB1_EMISSA:= dDataBase
									AB1->AB1_HORA  := Time()
									AB1->AB1_HORAF := Time()
									AB1->AB1_ATEND := cUserName
									AB1->AB1_STATUS:= 'E' //Encerrado
									MsUnLock('AB1')
									ConfirmSX8()
									
									//ORDEM DE SERVICO
									cNumOS:= ZZ4->ZZ4_OS
									RecLock('AB6',.T.)
									AB6->AB6_FILIAL :=xFilial('AB6')
									AB6->AB6_NUMOS  := cNumOS
									AB6->AB6_CODCLI :=ZZ4->ZZ4_CODCLI
									AB6->AB6_LOJA   :=ZZ4->ZZ4_LOJA
									AB6->AB6_OPER	:=ZZ4->ZZ4_OPER
									AB6->AB6_EMISSA :=dDataBase
									AB6->AB6_ATEND  :=cUserName
									AB6->AB6_STATUS :='A'
									AB6->AB6_HORA   := TIME()
									AB6->AB6_CONPAG :='001' //A vista
									AB6->AB6_BGHKIT := ZZ4->ZZ4_KIT
									AB6->AB6_OPER   := ZZ4->ZZ4_OPER
									AB6->AB6_NumVez := StrZero(cContVez+1,1)
									AB6->AB6_SWAPAN := iif(!empty(ZZ4->ZZ4_SWANT),"S","N")
									MsUnLock('AB6')
									ConfirmSX8()
									
									SB1->(DBSeek(xFilial('SB1')+ZZ4->ZZ4_CODPRO))
									//Itens do CHAMADO TECNICO
									RecLock('AB2',.T.)
									AB2->AB2_FILIAL := xFilial('AB2')
									AB2->AB2_NRCHAM := cNrCham
									AB2->AB2_NUMOS  := cNumOS+cItens
									AB2->AB2_STATUS := 'E'
									AB2->AB2_CODCLI := ZZ4->ZZ4_CODCLI
									AB2->AB2_LOJA   := ZZ4->ZZ4_LOJA
									AB2->AB2_EMISSA := dDatabase
									AB2->AB2_BXDATA := dDatabase
									AB2->AB2_BXHORA := TIME()
									AB2->AB2_ITEM   := cItens
									AB2->AB2_CODPRO := ZZ4->ZZ4_CODPRO
									AB2->AB2_NUMSER := ZZ4->ZZ4_IMEI
									AB2->AB2_TIPO   := '3'      //Ordem de Serviço
									AB2->AB2_CLASSI := '006'    //Box Failure
									AB2->AB2_CODPRB := '000001' //Box Failure
									AB2->AB2_TIPOP  := SB1->B1_TIPOP
									MsUnLock('AB2')
									
									//Grava Itens da Ordem de Serviço
									RecLock('AB7',.T.)
									AB7->AB7_FILIAL :=xFilial('AB7')
									AB7->AB7_NUMOS  := cNumOS
									AB7->AB7_NRCHAM :=cNrCham+cItens
									AB7->AB7_ITEM   :=cItens
									AB7->AB7_CODCLI := ZZ4->ZZ4_CODCLI
									AB7->AB7_LOJA   := ZZ4->ZZ4_LOJA
									AB7->AB7_EMISSA := dDatabase
									AB7->AB7_CODPRO :=ZZ4->ZZ4_CODPRO
									AB7->AB7_NUMSER :=ZZ4->ZZ4_IMEI
									AB7->AB7_PRCCOM :=IIf(ZZ4->ZZ4_OPER == "12", ZZ4->ZZ4_VLRUNI, 0)
									AB7->AB7_TIPO   :='1'      //
									AB7->AB7_CODPRB :='000001' //Box Failure
									AB7->AB7_NumVez := StrZero(cContVez+1,1)
									AB7->AB7_SWAPAN := ZZ4->ZZ4_SWANT
									AB7->AB7_CODFAB := ZZ4->ZZ4_CODCLI
									AB7->AB7_LOJAFA := ZZ4->ZZ4_LOJA
									MsUnLock('AB7')
									
									//**********************************************
									//          Geracao da Base Instalada          *
									//**********************************************
									dbSelectArea("AA3")
									dbSetOrder(1)
									
									If !(DBSeek(xFilial('AA3')+ZZ4->(ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI)))
										RecLock('AA3',.T.)
										AA3->AA3_FILIAL := xFilial('AA3')
										AA3->AA3_CODCLI := ZZ4->ZZ4_CODCLI
										AA3->AA3_LOJA   := ZZ4->ZZ4_LOJA
										AA3->AA3_CODPRO := ZZ4->ZZ4_CODPRO
										AA3->AA3_NUMSER := ZZ4->ZZ4_IMEI
										AA3->AA3_DTVEND := dDataBase
										AA3->AA3_STATUS := '05' //EQUIPAMENTO EM NOSSO PODER
										AA3->AA3_SIM    := ZZ4->ZZ4_CARCAC //SIM/Caraça
										AA3->AA3_CODFAB := ZZ4->ZZ4_CODCLI
										AA3->AA3_LOJAFA := ZZ4->ZZ4_LOJA
										MsUnLock('AA3')
									Endif
						
                 _lpassou:=.t.
                 
            Endif
                 
                 
            If _lpassou
				     		
     		
     					
				     		_cNrCham := GetAdvFVal("AB2","AB2_NRCHAM",_cFilial + _cNumOS, 6,"") // AB2_FILIAL + AB2_NUMSER + AB2_NUMOS
			      	        _cSeq    := u_CalcSeq(ZZ4->ZZ4_IMEI, _cNumOS)   
			      	    
			      	        if AB1->(dbSeek(xFilial("AB1") + _cNrCham ))
							  _dChamEmis := AB1->AB1_EMISSA
							  _cChamHora := AB1->AB1_HORA
						    else
							  _dChamEmis := dDataBase
							  _cChamHora := time()
						    endif
						
						    // Status 3 / 4 => EFETUAR ENCERRAMENTO DA OS
						    // Apontar fase de encerramento da OS (ZZ3)
							RecLock("ZZ3",.T.)
							ZZ3->ZZ3_FILIAL := _cFilial
							ZZ3->ZZ3_CODTEC := _cCodTec
							ZZ3->ZZ3_LAB    := _clab
							ZZ3->ZZ3_DATA   := dDataBase
							ZZ3->ZZ3_HORA   := time() //aCols[len(aCols),aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "HORA"})]
							ZZ3->ZZ3_CODSET := _cCodSet
							ZZ3->ZZ3_FASE1  := _cCodFas
							ZZ3->ZZ3_CODSE2 := _cCodSet
							ZZ3->ZZ3_FASE2  := _cCodFas
							ZZ3->ZZ3_DEFINF := "" //iif(ExistCpo("SX5","Z8" + Substr(DEFINF,1,At("/",DEFINF)-2)),Substr(DEFINF,1,At("/",DEFINF)-2),"")
							ZZ3->ZZ3_DEFDET := "" //iif(ExistCpo("SX5","Z8" + Substr(DEFDET,1,At("/",DEFDET)-2)),Substr(DEFDET,1,At("/",DEFDET)-2),"")
							ZZ3->ZZ3_LAUDO  := "" //LAUDO
							ZZ3->ZZ3_COR    := "" //iif(!empty(COR), COR, ZZ4->ZZ4_COR + _cDescCor)
							ZZ3->ZZ3_ENCOS  := "S"//ENCOS
							ZZ3->ZZ3_IMEI   := ZZ4->ZZ4_IMEI
							ZZ3->ZZ3_DPYIME := "" //DPYIMEI
							ZZ3->ZZ3_SWAP   := "" //SWAP
							ZZ3->ZZ3_IMEISW := "" //IMEINOVO
							ZZ3->ZZ3_MODSW  := "" //MODIMEIN
							ZZ3->ZZ3_DPYINV := "" //DPYINOVO
							ZZ3->ZZ3_CTROCA := "" //_cControl
							ZZ3->ZZ3_UPGRAD := "N"//UPGRAD
							ZZ3->ZZ3_STATUS := "1"
							ZZ3->ZZ3_NUMOS  := _cNumOS
							ZZ3->ZZ3_LOTIRL := ZZ4->ZZ4_LOTIRL
							ZZ3->ZZ3_SEQ    := _cSeq //SEQ     
							ZZ3->ZZ3_USER   := cUserName
							ZZ3->ZZ3_TRANSC := IIF(EMPTY(_ctransc),ZZ4->ZZ4_TRANSC,_ctransc)                  
							ZZ3->ZZ3_ARTIME := cArtime
				     		ZZ3->ZZ3_MINUMB := cNumLin
							ZZ3->ZZ3_STATRA :='1' // incluso Edson Rodrigues 27/07/10
							ZZ3->ZZ3_ASCRAP :=getadvfval("ZZ1","ZZ1_SCRAP",xFilial("ZZ1") + _clab + ALLTRIM(LEFT(_cCodSet,6)) + _cCodFas, 1, "N")  // incluso Edson Rodrigues 24/09/10
				
							msUnlock()
							
						    if AB6->AB6_STATUS <> "B" .and. AB7->AB7_TIPO <> "4"
			
							   // Encerra OS no AB6
							   reclock("AB6",.f.)
							     AB6->AB6_STATUS := 'B'
							   msunlock()
							
							   // Encerra OS no AB7
							   reclock("AB7",.f.)
							     AB7->AB7_TIPO   := '4'
						 	   msunlock()
							
							   // Aponta encerramento de OS no AB9
							   reclock("AB9",.t.)
							      AB9->AB9_FILIAL := _cFilial
							      AB9->AB9_SN     := alltrim(ZZ4->ZZ4_IMEI)
							      AB9->AB9_NRCHAM := _cNrCham
								  AB9->AB9_NUMOS  := _cNumOS+"01"
								  AB9->AB9_CODTEC := _cCodTec
								  AB9->AB9_SEQ    := _cSeq
								  AB9->AB9_LINHA  := _cCodFas
								  AB9->AB9_DTCHEG := _dChamEmis
								  AB9->AB9_HRCHEG := _cChamHora
								  AB9->AB9_DTINI  := _dChamEmis
								  AB9->AB9_HRINI  := _cChamHora
								  AB9->AB9_DTSAID := dDataBase
								  AB9->AB9_HRSAID := time()
								  AB9->AB9_DTFIM  := dDataBase
								  AB9->AB9_HRFIM  := time()
								  AB9->AB9_CODPRB := AB7->AB7_CODPRB
								  AB9->AB9_GARANT := "N"
								  AB9->AB9_TIPO   := "1"
								  AB9->AB9_CODCLI := ZZ4->ZZ4_CODCLI
								  AB9->AB9_LOJA   := ZZ4->ZZ4_LOJA
								  AB9->AB9_CODPRO := ZZ4->ZZ4_CODPRO
								  AB9->AB9_TOTFAT := "01:00"
								  AB9->AB9_BGHKIT := AB6->AB6_BGHKIT
								  AB9->AB9_STATAR := "1" // 1=Tarefa encerrada / 2=Tarefa em aberto
								  AB9->AB9_NUMVEZ := AB6->AB6_NUMVEZ
								  AB9->AB9_SERIAL := ZZ4->ZZ4_CARCAC
								  AB9->AB9_XTREPA := time()
								  AB9->AB9_SWAPAN := ZZ4->ZZ4_SWANT
								  AB9->AB9_XTCENC := _cCodTec
								  AB9->AB9_NOVOSN := ZZ4->ZZ4_SWAP
								  AB9->AB9_OPER   := ZZ4->ZZ4_OPER
							   msunlock()
				 		    else
							  // Atualiza log de transacoes
							  AtuLog(ZZ4->ZZ4_IMEI, _cNumOS, "AB6 ou AB7 ja encerrado")
						    endif
						
								//Atualiza o ZZ4 com OS encerrada
								_aFasMax := {,,,}
								_aFasMax := u_FasMax(ZZ4->ZZ4_LOCAL, ZZ4->ZZ4_GRMAX, _cCodFas,_cCodset )
				
								reclock("ZZ4",.f.)
								
								If !codoper $ "03/02"
								    ZZ4->ZZ4_SETATU := _cCodSet  // iif(!empty(_cSetAtu), _cSetAtu, _cSetOri)
								    ZZ4->ZZ4_FASATU := _cCodFas  // iif(!empty(_cFasAtu), _cFasAtu, _cFasOri)
			     					ZZ4->ZZ4_DEFINF := ""        // iif( empty(ZZ4->ZZ4_DEFINF), iif(!empty(ZZ3->ZZ3_DEFINF),ZZ3->ZZ3_DEFINF,ZZ3->ZZ3_DEFDET), ZZ4->ZZ4_DEFINF)
				     				ZZ4->ZZ4_DEFDET := ""        // iif( empty(ZZ4->ZZ4_DEFDET), ZZ3->ZZ3_DEFDET, ZZ4->ZZ4_DEFDET)
					     			ZZ4->ZZ4_ATPRI  := iif( empty(ZZ4->ZZ4_ATPRI) , dtos(dDataBase)+time(), ZZ4->ZZ4_ATPRI)
					  	     		ZZ4->ZZ4_ATULT  := dtos(dDataBase)+time()
			             			ZZ4->ZZ4_DPYINV := ""        // iif(!empty(ZZ3->ZZ3_DPYINV), ZZ3->ZZ3_DPYINV, ZZ4->ZZ4_DPYINV )	
			     					ZZ4->ZZ4_CTROCA := ""        // iif(!empty(ZZ3->ZZ3_CTROCA), ZZ3->ZZ3_CTROCA, ZZ4->ZZ4_CTROCA )
			     					if !empty(_aFasMax[1])
									   ZZ4->ZZ4_FASMAX := _aFasMax[1]
				                     //ZZ4->ZZ4_DFAMAX := _aFasMax[2]
									   ZZ4->ZZ4_GRMAX  := _aFasMax[3]
									   ZZ4->ZZ4_SETMAX := _aFasMax[4]
			     					endif
					             	ZZ4->ZZ4_TRANSC := _ctransc
					            ELSEIF codoper $ "03/02"
					             	ZZ4->ZZ4_ETQMAS := val(_cetqmast)
						        Endif
							
							    ZZ4->ZZ4_STATUS := "5"       // iif(ZZ3->ZZ3_ENCOS == "S" .and. ZZ3->ZZ3_STATUS == "1","5","4")
								ZZ4->ZZ4_SWAP   := ""        // iif(!empty(ZZ3->ZZ3_IMEISW), ZZ3->ZZ3_IMEISW, ZZ4->ZZ4_SWAP  )
								ZZ4->ZZ4_PRODUP := ""        // iif(!empty(ZZ3->ZZ3_IMEISW), ZZ3->ZZ3_MODSW , ZZ4->ZZ4_PRODUP)
								ZZ4->ZZ4_COR    := ""        // iif( empty(ZZ4->ZZ4_COR)   , ZZ3->ZZ3_COR   , ZZ4->ZZ4_COR   )
							  msunlock()
								
								// Atualiza log de transacoes
								AtuLog(ZZ4->ZZ4_IMEI, _cNumOS, "OS encerrada com Sucesso")
						else
								// Atualiza log de transacoes
								AtuLog(ZZ4->ZZ4_IMEI, _cNumOS, "AB6 ou AB7 nao localizado")
						endif
		    Endif
	else
		// Atualiza log de transacoes
		AtuLog(ZZ4->ZZ4_IMEI, _cNumOS, "IMEI x NFE nao localizado")
	endif
	
	TRB1->(dbSkip())
	
enddo

return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECAX033  ºAutor  ³Microsiga           º Data ³  01/13/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Grava os logs gerados durante o processamento das rotinas º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function AtuLog(_cImei, _cNrOS, _cMensagem)

local _cLinha := ""
local _Enter  := chr(13) + chr(10)

_cLinha := _cIMEI + space(2) + _cNrOs + space(2) + _cMensagem + space(2) + _Enter

fWrite(handle, (_cLinha))
fSeek(handle,0,1)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SaiMas    ºAutor  ³Microsiga           º Data ³  01/13/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Executa a rotina automatica de saida massiva              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function SaiMas()

private _SerSai := {}

TRB2->(dbGoTop())
while TRB2->(!eof())
	
	if TRB2->RECZZ4 > 0 .and. TRB2->RECSD1 > 0
	
       // Verifica se o IMEI está sendo apontado da fase atual por outro tecnico e nao confirmada //  Edson Rodrigues - 26/07/10

       ZZ4->(dbGoto(TRB2->RECZZ4))

        _capontenc :="N"
	   //_capontenc := u_VerEncdif(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
       _lpeca :=.f.
        
       //IF ZZ4->ZZ4_GARANT == 'S'
       //     _lpeca :=u_Verexipec(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
       //ENDIF


	   if _capontenc<>'S' .and. !_lpeca

	     	// Incrementa matriz de saida massiva
		    aAdd(_SerSai)
	
	      	// Posiciona ZZ4 no registro identificado pela query
	
     		// Atualiza status para Saida Massiva lida 
	     	reclock("ZZ4",.f.)
		      ZZ4->ZZ4_SMUSER := Substr(cUserName,1,13)
         	  ZZ4->ZZ4_STATUS := "6"
        	  ZZ4->ZZ4_SMDT   := dDataBase // Data da Saida Massiva
              ZZ4->ZZ4_SMHR   := Time()    // Horario da Saida Massiva
		    msunlock()
	
		    // Atualiza log de transacoes
		    AtuLog(ZZ4->ZZ4_IMEI, space(6), "IMEI enviado para saida massiva")
       Endif
	endif

	TRB2->(dbSkip())
	
enddo

// Executa saida massiva
if len(_SerSai) > 0
	u_tecx012c(.t.)
endif

return                            



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Verexipec ºAutor  Edson Rodrigues ³    º Data ³  14/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe peça apontada                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function Verexipec(_cIMEI, _cNumOS)
Local _aAreaSZ9 := SZ9->(GetArea())
Local _lret     := .F.
Local cselQry   := ""

//Alterado Edson Rodrigues em 01/04/09

If Select("QrySZ9") > 0
	QrySZ9->(dbCloseArea())
Endif

cselQry:=" SELECT Z9_PARTNR  FROM "+RETSQLNAME("SZ9")+" (NOLOCK) "
cselQry+=" WHERE  Z9_FILIAL='"+xFilial("SZ9")+"' AND  Z9_IMEI='"+_cIMEI+"' AND LEFT(Z9_NUMOS,6)='"+left(_cNumOS,6)+"' "
cselQry+=" AND Z9_STATUS='1' AND Z9_PARTNR<>'' AND D_E_L_E_T_='' "

TCQUERY cselQry ALIAS "QrySZ9" NEW
TCRefresh(RETSQLNAME("SZ9"))

If Select("QrySZ9") > 0
	QrySZ9->(dbGoTop())
	If QrySZ9->(!eof())
		IF !EMPTY(QrySZ9->Z9_PARTNR)
		   _lret:=.T.
		ENDIF
	Endif
	QrySZ9->(dbCloseArea())
Endif

restarea(_aAreaSZ9)

return(_lret)                                                     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerEncdif  ºAutor  ³Edson Rodrigues     º Data ³  26/07/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ver se o ultimo apontamento esta encerrado e nao estornado  ¹±±
±±      e que esse não seja encerrado por essa rotina conforme parametros º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function VerEncdif(_cIMEI, _cNumOS)
Local _aAreaZZ3 := ZZ3->(GetArea())
Local _cencos   := ""
Local cselQry   := ""
private _cCodTec  := "N15"
private _cCodSet  := "000001"
private _cCodFas  := "04"

If Select("QryZZ3") > 0
	QryZZ3->(dbCloseArea())
Endif

cselQry:=" SELECT ZZ3_ENCOS,ZZ3_CODTEC,ZZ3_FASE1,ZZ3_CODSET FROM ZZ3020 (NOLOCK) INNER JOIN "
cselQry+=" (SELECT MAX(R_E_C_N_O_) AS RECNO FROM ZZ3020 (NOLOCK) 
cselQry+=" WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND  ZZ3_IMEI='"+_cIMEI+"' AND LEFT(ZZ3_NUMOS,6)='"+left(_cNumOS,6)+"' AND D_E_L_E_T_='' 
cselQry+=" AND ZZ3_STATUS='1' AND ZZ3_ESTORN<>'S' ) AS ZZ31 ON RECNO=R_E_C_N_O_ "

TCQUERY cselQry ALIAS "QryZZ3" NEW
TCRefresh("ZZ3020")

If Select("QryZZ3") > 0
	QryZZ3->(dbGoTop())
	If QryZZ3->(!eof())   
	    IF (QryZZ3->ZZ3_CODTEC<> _cCodTec .OR. QryZZ3->ZZ3_FASE1<>_cCodFas .OR. QryZZ3->ZZ3_CODSET<>_cCodSet)
		   _cencos:=QryZZ3->ZZ3_ENCOS
		ELSE
    		_cencos:="N"
		ENDIF   
	endif
	QryZZ3->(dbCloseArea())
Endif

restarea(_aAreaZZ3)

Return(_cencos)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx33D  ºAutor  ³Edson Rodrigues     º Data ³   15/04/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz feitura da Master de aparelhos em estoque para          ¹±±
±±            encerramento apos confirmacao                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function tecx33D()

Local cVarEtm      :=space(20)
local _Enter       := chr(13) + chr(10)
local _nmast       := 0
Private oV1,oV2,oV3
Private cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos fontes                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFnt1  := TFont():New("Arial",18,22,,.T.,,,,.T.,.F.)
oFnt2  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
oFnt3  := TFont():New("Courier New",08,12,,.F.,,,,.F.,.F.)


_cqryl:=" SELECT ZZO_NUMCX FROM "+RETSQLNAME("ZZO")+"   "+_Enter
_cqryl+=" WHERE ZZO_FILIAL = '"+XFILIAL("ZZO")+"' AND   "+_Enter  
_cqryl+="       ZZO_STATUS = 'E' AND   "+_Enter
_cqryl+="      SUBSTRING(ZZO_USRSEP,1,30) = '"+Substr(cUserName,1,30)+"'  "+_Enter
_cqryl+="      AND D_E_L_E_T_ = '' "+_Enter
_cqryl+="      ORDER BY ZZO_NUMCX "+_Enter


dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cqryl),"X02",.T.,.T.)
	
dbSelectArea("X02")
X02->(dbGoTop())
while X02->(!eof())
		
	_nPosmas := Ascan(_SerEnt ,{ |x| x[1] == X02->ZZO_NUMCX })
		
	If _nPosmas <= 0
		   _nmast:=0
		   _nmast++
 		  AADD(_SerEnt,{X02->ZZO_NUMCX,_nmast})
		
	Else      
		   _nmast++
		   _SerEnt[_nPosmas,2]:=_nmast
	Endif		
		
	X02->(dbSkip())
enddo

If len(_SerEnt) > 0
       For xl:=1 to len(_SerEnt)  
    	    tMemo  := "Master já lida anteriormente "+_SerEnt[xl,1]+ " total de IMEIs" +Transf(_SerEnt[xl,2],"@E 999,999")+" ."+LFRC+LFRC
    	    cTexto := tMemo+cTexto
		Next   
		
endIf

If Select("X02") > 0
  X02->(dbCloseArea())                           
endif	                     





_lFechETM:=.F.

While !_lFechETM
		
   @ 0,0 TO 460,520 DIALOG oDlg TITLE "Encerramento Master Estoque"
	oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"CodBar.bmp",.T.,oDlg)
		
	@ 005,077 SAY oV1 var "Passe a leitora da" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
	@ 020,075 SAY oV2 var "Etiqueta Master"   of oDlg FONT oFnt1 PIXEL SIZE 150,012 COLOR CLR_BLUE
	@ 035,010 GET cVarEtm Size 100,080 PICTURE "@!"  valid u_tecx33E(@cVarEtm,@cTexto) Object oEdEtm
	@ 065,010 GET cTexto  Size 250,115 MEMO Object oMemo when .F.
	@ 202,180 BUTTON "CONFIRMA     " 	SIZE 60,13 ACTION Processa({|| u_tecx33F(.f.) })
	@ 217,180 BUTTON "CANCELA" 			SIZE 60,13 ACTION IIF(MSGYESNO("DESEJA REALMENTE CANCELAR? TODAS AS MASTER LIDAS DEVERÃO SER APONTADOS NOVAMENTE."),tecx33h(),tecx33i(.F.))
	
	Activate MSDialog oDlg Centered On Init oEdEtm:SetFocus()  
Enddo

Return                                                                        



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx33E  ºAutor  ³Edson Rodrigues     º Data ³   16/04/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz leitura da master de aparelhos em estoque para          ¹±±
±±            encerramento após confirmação                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function tecx33E(cVarEtm,MEMO)
Local _aAreaZZO := ZZO->(GetArea())
Local tMemo  :=""
Local tMemo1 :=""
Local nvez := 0
ZZO->(dbSetOrder(4)) // ZZO_FILIAL + ZZO_NUMCX + ZZO_IMEI + ZZO_STATUS

If Select("QryZZ4") > 0
  QryZZ4->(dbCloseArea())                           
endif	                     

if empty(cVarEtm)           
   cVarEtm:=Replicate(' ',20)                                
   return
endif


cQRY:=" SELECT * FROM "+RETSQLNAME("ZZ4")+" WHERE ZZ4_ETQMEM='"+cVarEtm+"' AND ZZ4_STATUS='3' AND D_E_L_E_T_='' "

TCQUERY cQRY ALIAS "QryZZ4" NEW
TCRefresh("ZZ4020")

QryZZ4->(dbGoTop())	
	
While QryZZ4->(!eof())   

   IF !ZZO->(dbSeek(xfilial("ZZO") + QryZZ4->ZZ4_ETQMEM + QryZZ4->ZZ4_IMEI+"E"))
        nvez++
        _cOrigem:=Posicione("SA1",1,xFilial("SA1") + QryZZ4->ZZ4_CODCLI+QryZZ4->ZZ4_LOJA, "A1_EST")
        
     	Begin Transaction
				RecLock("ZZO",.T.)
				ZZO->ZZO_FILIAL 	:= xFilial("ZZO")
				ZZO->ZZO_IMEI		:=  QryZZ4->ZZ4_IMEI
				ZZO->ZZO_CARCAC		:=  QryZZ4->ZZ4_CARCAC
				ZZO->ZZO_STATUS		:= 'E'
				ZZO->ZZO_MODELO		:=  QryZZ4->ZZ4_CODPRO
				ZZO->ZZO_GARANT  	:=  QryZZ4->ZZ4_GARANT
				ZZO->ZZO_DTSEPA		:= dDataBase
				ZZO->ZZO_HRSEPA		:= Time()
				ZZO->ZZO_USRSEP		:= cUserName
				ZZO->ZZO_NUMCX		:= QryZZ4->ZZ4_ETQMEM
				ZZO->ZZO_ORIGEM		:= _cOrigem
				ZZO->ZZO_CLIENT		:= SPACE(6)
				ZZO->ZZO_LOJA		:= SPACE(2)
				ZZO->ZZO_NF			:= SPACE(9)
				ZZO->ZZO_SERIE		:= SPACE(3)
				ZZO->ZZO_PRECO		:= QryZZ4->ZZ4_VLRUNI
				ZZO->ZZO_DESTIN		:= "B"
	            ZZO->ZZO_DTDEST     := dDataBase
               	ZZO->ZZO_HRDEST     := Time()
               	ZZO->ZZO_USRDES     := cUserName
           	    ZZO->ZZO_DTCOFE     := dDataBase
            	ZZO->ZZO_HRCOFE     := Time()
              	ZZO->ZZO_USRCOF     := cUserName
				ZZO->ZZO_ENVARQ		:= "N"
     			ZZO->ZZO_SEGREG     := "N"
				ZZO->ZZO_BOUNCE		:= iif(QryZZ4->ZZ4_BOUNCE > 0,"S","N")
				ZZO->ZZO_NVEZ       := QryZZ4->ZZ4_NUMVEZ
				ZZO->ZZO_DBOUNC		:= strzero(QryZZ4->ZZ4_BOUNCE,3)
				ZZO->ZZO_OPBOUN		:= iif(QryZZ4->ZZ4_BOUNCE < 90,"S","N")
				ZZO->ZZO_OPERA		:= QryZZ4->ZZ4_OPEBGH
				IF QryZZ4->ZZ4_OPEBGH="N01" .AND. QryZZ4->ZZ4_BOUNCE<=0 .AND. QryZZ4->ZZ4_BOUNCE>=90
				   crefgar:="2"
				ELSEIF QryZZ4->ZZ4_OPEBGH $ "N10/N11" .AND. QryZZ4->ZZ4_BOUNCE<=0 .AND. QryZZ4->ZZ4_BOUNCE>=90
     				crefgar:="1"
	 		    ELSEIF QryZZ4->ZZ4_BOUNCE<=0 .AND. QryZZ4->ZZ4_BOUNCE>=90
     			  crefgar:="4"
                ELSE
                   crefgar:="3"
                ENDIF				   
				ZZO->ZZO_REFGAR	 := crefgar
				ZZO->ZZO_RECLIC  := QryZZ4->ZZ4_DEFINF
				ZZO->ZZO_SYMPTO  := IIF(EMPTY(QryZZ4->ZZ4_DEFDET),QryZZ4->ZZ4_PROBLE,QryZZ4->ZZ4_DEFDET)
             	ZZO->ZZO_ACTION  := QryZZ4->ZZ4_REPAIR
             	ZZO->ZZO_OSFILI := QryZZ4->ZZ4_OS 
                ZZO->ZZO_CLIENF := QryZZ4->ZZ4_CODCLI
                ZZO->ZZO_LOJCLF := QryZZ4->ZZ4_LOJA
                ZZO->ZZO_NFENRF := QryZZ4->ZZ4_NFENR
                ZZO->ZZO_NFESEF := QryZZ4->ZZ4_NFESER
                ZZO->ZZO_ITEMDF := QryZZ4->ZZ4_ITEMD1
                ZZO->ZZO_MASENF := QryZZ4->ZZ4_ETQMEM
                ZZO->ZZO_ARMZEF := QryZZ4->ZZ4_LOCAL
                ZZO->ZZO_RCZZ3F :=0
				MsUnlock()
		End Transaction
   
   ELSE
   	tMemo += "IMEI -> "+QryZZ4->ZZ4_IMEI+ " Ja Lido nessa master !"+LFRC
   
   
   ENDIF
   QryZZ4->(dbskip())                                           
Enddo   
IF nvez==0
   tMemo1 +="Nao existem IMEIs em estoque dessa Master -> "+cVarEtm+  ". Favor verificar !"+LFRC+LFRC
ENDIF

If !empty(tMemo1)           
   MEMO:=MEMO+tMemo1
Else 
   MEMO:=MEMO+"Foram lidos : "+strzero(nvez,5)+" IMeis para a master : "+cVarEtm+ "."+LFRC+LFRC 
   IF  !empty(tMemo)           
       MEMO:=MEMO+"ATENCAO :"+LFRC 
       MEMO:=MEMO+tMemo
   ENDIF
Endif
restarea(_aAreaZZO)
cVarEtm:=Replicate(' ',20)
oEdEtm:SetFocus()
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx33F  ºAutor  ³Edson Rodrigues      º Data ³  16/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pede Confirmacao das Master Lidas por usuário              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx33F(_lAuto)
  Local _aAreaZZO := ZZO->(GetArea())
  Local nTotal := 0                    
  Local ChaveMAST:=space(20)                                       
  local oDlgConf
  Local cConf :=""
  local _Enter    := chr(13) + chr(10)
  
  oFnt1  := TFont():New("Arial",18,22,,.T.,,,,.T.,.F.)
  oFnt2  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
  oFnt3  := TFont():New("Courier New",08,12,,.F.,,,,.F.,.F.)
	
  ZZO->(dbSetOrder(4)) // ZZO_FILIAL + ZZO_NUMCX + ZZO_IMEI + ZZO_STATUS	
	
  ZZ4->(dbSetOrder(3)) //ZZ4_FILIAL+ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODPRO
  ZZ4->(dbGoTop())
	
  cAliasTop3	:= GetNextAlias()
	
  _cQuery := _Enter + "  SELECT ZZO_NUMCX,ZZO_IMEI "
  _cQuery += _Enter + "          FROM   "+RetSqlName("ZZO")+" (nolock) "
  _cQuery += _Enter + "          WHERE  ZZO_FILIAL  = '"+xFilial("ZZO")+"' AND "
  _cQuery += _Enter + "          ZZO_STATUS  = 'E'  AND "
  _cQuery += _Enter + "          ZZO_DESTIN  = 'B'  AND "
  _cQuery += _Enter + "          ZZO_SEGREG  = 'N'  AND "
  _cQuery += _Enter + "          ZZO_ENVARQ  = 'N'  AND "
  _cQuery += _Enter + "          SUBSTRING(ZZO_USRSEP,1,30) = '"+Substr(cUserName,1,30)+"'  "
  _cQuery += _Enter + "          AND D_E_L_E_T_  = '' "
  _cQuery += _Enter + "  ORDER BY  ZZO_NUMCX,ZZO_IMEI "
  
  
 DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasTop3,.T.,.T.)
 
 (cAliasTop3)->(dbGoTop())
	
  While !((cAliasTop3)->(EOF())) 
		
		nTotal++
		
		IF (cAliasTop3)->(ZZO_NUMCX) <> ChaveMAST       
		    nimei:=0
			ChaveMAST:=(cAliasTop3)->(ZZO_NUMCX) // ZZ4F->(ZZ4_NFENR+ZZ4_NFESER)
			cConf+='Master: '+ (cAliasTop3)->(ZZO_NUMCX) +" "+_Enter
		Endif
		
		If  (cAliasTop3)->(ZZO_NUMCX) == ChaveMAST                            
     		nimei++
		Endif
		
		(cAliasTop3)->(DBSkip())
		
		IF  (cAliasTop3)->(ZZO_NUMCX) <> ChaveMAST                           
			cConf+='Qtde Imeis na Master -> '+strzero(nimei,5)+" "+_Enter+_Enter
		Endif
    EndDo
	
	
	//DbSelectArea(cAliasTop3)
	//DbCloseArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Janela de Conferência                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTotal == 0
		Aviso('Etiq Master Estoque','Não existem itens para conferência!',{'OK'})
	Else
		If  !_lAuto //Edson Rodrigues 28/11/07
			@ 0,0 TO 400,420 DIALOG oDlgConf TITLE "Confirmar Dados"
			@ 05,005 SAY oV1 var Alltrim(cUserName)+',' of oDlgConf FONT oFnt2 PIXEL SIZE 150,010
			@ 15,005 SAY oV2 var "confirme os itens abaixo listados." of oDlgConf FONT oFnt2 PIXEL SIZE 150,012
			@ 25,005 SAY oV3 var "Importante: A responsabilidade dos dados é sua." of oDlgConf FONT oFnt2 PIXEL SIZE 150,012 COLOR CLR_RED
			@ 40,005 Get cConf Size 195,115 MEMO Object oMemoConf
			@ 160,130 BMPBUTTON TYPE 1 ACTION Processa({|| u_tecx33G(oDlgConf,_lAuto) },"Aguarde...","Gerando os Apontamentos de Encerramento",.t.)
			@ 160,165 BMPBUTTON TYPE 2 ACTION tecx33H(oDlgConf)
 			oMemoConf:oFont:=oFnt3
			Activate MSDialog oDlgConf Centered
		Else
			tecx33G(oDlgConf,_lAuto) //Edson Rodrigues
		Endif
	endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx33G  ºAutor  ³Edson Rodrigues      º Data ³  16/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Confirma Master Lidas por usuário                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function tecx33G(oDlgConf,_lAuto)
local _cetqmast   :=space(20)  
Local _ctransc    :=space(3)
Local _cCodTec    :="998"
Local _cCodFas    :="01"
Local _cCodSet    :="000098" 
Local _clab       :="2"
Local codoper     :="02"
Local _csaimass   := "N"
Local _cUpdZZO    :=""
Private _amastenc :={}

ZZO->(dbSetOrder(4)) // ZZO_FILIAL + ZZO_NUMCX + ZZO_IMEI + ZZO_STATUS


(cAliasTop3)->(dbGoTop())   
   
  
While !((cAliasTop3)->(EOF())) 
      
     If   (cAliasTop3)->ZZO_NUMCX <> _cetqmast
           _cetqmast:= (cAliasTop3)->ZZO_NUMCX
          _lret:=u_TECAX33C(_cCodTec,_cCodFas,_cCodSet,_clab,_cetqmast,codoper,_csaimass,_ctransc)
          
          If _lret
             aadd(_amastenc,{(cAliasTop3)->ZZO_NUMCX ,(cAliasTop3)->ZZO_IMEI, "E"})
          Endif
     Endif
     (cAliasTop3)->(dbSKIP())
Enddo
  

IF len(_amastenc) > 0
  For xe:=1 to len(_amastenc)
   
      IF ZZO->(dbSeek(xfilial("ZZO") + _amastenc[xe,1] + _amastenc[xe,2]+ _amastenc[xe,3]))
		  _cUpdZZO := " UPDATE "+RETSQLNAME("ZZO")+" SET ZZO_FILIAL = '"+alltrim(_cmudfdes)+"' "
          _cUpdZZO += " WHERE ZZO_FILIAL = '"+xFilial("ZZO")+"' "
          _cUpdZZO += "       AND ZZO_NUMCX='"+ _amastenc[xe,1] +"'
          _cUpdZZO += "       AND ZZO_STATUS = 'E' "
          _cUpdZZO += "       AND D_E_L_E_T_ = '' "

          tcSqlExec( _cUpdZZO)
          TCREFRESH(RETSQLNAME("ZZO"))
      ENDIF
   Next
Endif   

MsgStop("Processo finalizado")
   
_lFechETM := .T.
Close(oDlgConf)
Close(oDlg)
                   
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx33H  ºAutor  ³Edson Rodrigues      º Data ³  16/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui  imeis / Master Lidas por usuário                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function tecx33H(oDlgConf,_lAuto)

Local _cUpdZZO :=""                                           


_cUpdZZO := " UPDATE "+RETSQLNAME("ZZO")+" SET D_E_L_E_T_ = '*' "
_cUpdZZO += " WHERE ZZO_FILIAL = '"+xFilial("ZZO")+"' "
_cUpdZZO += "       AND ZZO_STATUS = 'E' "
_cUpdZZO += "       AND SUBSTRING(ZZO_USRSEP,1,30) = '"+Substr(cUserName,1,30)+"' "
_cUpdZZO += "       AND D_E_L_E_T_ = '' "

tcSqlExec( _cUpdZZO)
TCREFRESH(RETSQLNAME("ZZO"))


_lFechETM := .T.
Close(oDlg)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³tecx33i  ºAutor  ³Edson Rodrigues      º Data ³  16/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fecha a tela com os Imeis / Master Lidas por usuário       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function tecx33i()

_lFechETM := .T.
Close(oDlg)


Return                     







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPG1  ºAutor  ³Edson Rodrigues     º Data ³   15/04/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Sobe pergunta para o usuario indicar ao sistema qual rotina º±±
±±            será executada                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VALIDPG1()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
cPerg        := PADR(cPerg,len(sx1->x1_grupo))

AAdd(aHelpPor,"Informe operacionalmente com sera executado")
AAdd(aHelpPor,"essa rotina.")
PutSX1(cPerg,'01','Executar rotina via ?'				,'Executar rotina via ?'				,'Executar rotina via ?'				,'mv_ch1','C', 1,0,2,'C','',''		,'','S','mv_par01','Scrap-Imp.Arq'	,'Scrap-Imp.Arq'	,''			,'',' Master Estoque'			,'Master Estoque'				,''				,''			,''			,''			,'','','','','','')
Return
                     
