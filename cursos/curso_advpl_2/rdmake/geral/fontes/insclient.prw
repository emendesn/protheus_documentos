#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#INCLUDE "topconn.ch" 
#include "tbiconn.ch"
#define LFRC CHR(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INSCLIENT º Autor ³ Edson Rodrigues    º Data ³  JUNH /10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para incuir dados no cadastro do Cliente conforme º±±
±±º          ³  planilha do usuário importada para o banco de dados SQL   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User function INSCLIENT()
 

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "SA1","Z07","CC2","QRY"
lnumser  :=.f.
lSZA  :=.f.
cgaran:=""
_CQRY :=""                                    
QRY := ""
_nregnotp := 0           
_ncount:=0           
Private  aAlias  := {"SA1"}
Private _aAreaSA1 := SA1->(GetArea())
Private _aCliente := {}
Private _aDados   := {}            
Private _aErros   := {}

u_GerA0003(ProcName())

dbSelectArea("SA1")
SA1->(dbSetOrder(1)) // SA1_FILIAL + A1_COD + A1_LOJA

dbSelectArea("Z07")
Z07->(dbSetOrder(1)) // Z07_FILIAL + Z07_CEP 

If select("QRY") > 0
   QRY->(dbclosearea())
Endif                          


If select("QRY") > 0
   QRY->(dbclosearea())
Endif                          

_CQRY := " SELECT * FROM CLIENTE_ASC ORDER BY CGC "
 TCQUERY _CQRY NEW ALIAS "QRY"

QRY->(dbgotop())
While !QRY->(eof())  
   _cCNPJ:=ALLTRIM(QRY->CGC)
   lexiste:=.f.
   linclui:=.f.                           
   lnewloj:=.f.
   _ndiv  := 0
   _clograd:= ""

    SA1->(dbSetOrder(3))  // A1_FILIAL + A1_CGC
    
   	If SA1->(dbSeek(xFilial("SA1") + _cCNPJ ))
    	   lexiste:=.t.                           
	Else
		If SA1->(dbSeek(xFilial("SA1") + left(_cCNPJ,9)))
		   lexiste:=.t.                      
    	   linclui:=.t.
		   lnewloj:=.t.
		Else
		   linclui:=.t.
		Endif
	Endif

    
    If (!lexiste .and. linclui)  .or.  (lexiste .and. linclui .and. lnewloj) 
        // Incrementa regua
        ProcRegua(RecCount())
       _ncount++
	   IncProc( "Processando Registros de Clientes ..." +strzero(_ncount,5))
	
	   If len(ALLTRIM(QRY->CGC)) > 11 .and. len(ALLTRIM(QRY->CGC))<=14
	       _cCNPJ :=strzero(val(ALLTRIM(QRY->CGC)),14)  
	       _cpessoa  :="J"			    
	   Elseif len(ALLTRIM(QRY->CGC)) <= 11 
	       _cCNPJ :=strzero(val(ALLTRIM(QRY->CGC)),11)  
	       _cpessoa  :="F"			       
	   Else
	       _cCNPJ :=""
	       _cpessoa:=""			   
	   Endif

	   If !empty(_cCNPJ) 
				
		    // Executa as principais validacoes do Protheus
		    _cEnd     := UPPER(ALLTRIM(QRY->ENDERECO))
		    _ndiv     := AT(",",ALLTRIM(QRY->ENDERECO))
		    if _ndiv > 0  
		       _ccompl :=Substr(ALLTRIM(QRY->ENDERECO),_ndiv+1)
		    Else
               _ccompl:=0
                _cmensag:="Cadastrado CNPJ, porem falta corrigir endereco, Endereco sem virgula de separacao do numero e complementos."
				aAdd(_aErros, {_cCNPJ,_cmensag})
		    Endif   
		    
		    _cnome    := UPPER(ALLTRIM(QRY->RAZSOC))
		    _cCEP     := strzero(val(ALLTRIM(QRY->CEP)),8)
		    _cNFant   := UPPER(iif(empty(ALLTRIM(QRY->NOMEFANT)), substr(_cnome,1,30),ALLTRIM(QRY->NOMEFANT))) 
		    _cTel1    := UPPER(iif(empty(ALLTRIM(QRY->TELEF1)), "00000000",ALLTRIM(QRY->TELEF1)))
		    _cTel2    := UPPER(iif(empty(ALLTRIM(QRY->TELEF2)), "",ALLTRIM(QRY->TELEF2)))
		    _cBAIRR   := UPPER(iif(empty(ALLTRIM(QRY->BAIRRO)), "XXXXXXXXX",ALLTRIM(QRY->BAIRRO)))
		    _cDDD     := STRZERO(VAL(ALLTRIM(QRY->DDD)),3)
		    _cmuni    := iif(!empty(ALLTRIM(QRY->CIDADE)),ALLTRIM(QRY->CIDADE),"")
		    //_cmuni    := U_TIRACENTO(_cmuni)
		    _cUF      := iif(!empty(ALLTRIM(QRY->UF)),ALLTRIM(QRY->UF),"")
		    _cemail   := iif(!empty(ALLTRIM(QRY->EMAIL)),ALLTRIM(QRY->EMAIL),IIF(_cpessoa == "F","bgh@bgh.com.br","")) 
		    _cinsest  := iif(!empty(ALLTRIM(QRY->IEST)),ALLTRIM(QRY->IEST),"")
		    _cinsmun  := iif(!empty(ALLTRIM(QRY->IMUN)),ALLTRIM(QRY->IMUN),"")
		    _cpais    := iif(!empty(ALLTRIM(QRY->PAIS)),ALLTRIM(QRY->PAIS),"105")
		    _cpbacen  := iif(!empty(ALLTRIM(QRY->PAISBACEN)),ALLTRIM(QRY->PAISBACEN),"01058")
		    _cmenpad  := iif(!empty(ALLTRIM(QRY->MENSAG)),ALLTRIM(QRY->MENSAG),"002")
		    _ctransp  := iif(!empty(ALLTRIM(QRY->TRANSP)),ALLTRIM(QRY->TRANSP),"03")
		    _ccontrib := iif(!empty(ALLTRIM(QRY->CONTRIB)),IIF(LEFT(QRY->CONTRIB,1)='S' .OR. LEFT(QRY->CONTRIB,1)='1' ,"1", "2"),'1')
		    _clograd  := Posicione("Z07", 1, xFilial("Z07") +_cCEP,"Z07_TPLOGR")
		    _cfax     := iif(!empty(ALLTRIM(QRY->FAX)),ALLTRIM(QRY->FAX),"")
		    _ccontat  := iif(!empty(ALLTRIM(QRY->CONTATO)),ALLTRIM(QRY->CONTATO),"")
		    _cregiao  := iif(!empty(ALLTRIM(QRY->REGIAO)),ALLTRIM(QRY->REGIAO),"")
		    		    
		    DbSelectArea("CC2")
		    CC2->(dbSetOrder(2))
            
            IF CC2->(dbSeek(xfilial("CC2")+UPPER(alltrim(_Cmuni))))
		       _ccodmun :=CC2->CC2_CODMUN
		    ELSE 
		      CC2->(dbSetOrder(1))
		      IF CC2->(dbSeek(xfilial("CC2")+UPPER(_CUF)))
		        _ccodmun :=CC2->CC2_CODMUN
		      ELSE
		        _ccodmun :="99999"
		      ENDIF
		    ENDIF   
				
	        
		    If empty(_cDDD) .OR. _cDDD='000'
		      _cDDD := AchaDDD(UPPER(alltrim(_Cmuni)), UPPER(alltrim(_CUF)))
		    endif
		     _lCGC     :=CGC(_cCNPJ)
		    IF _lCGC = .f.
		     	CRLF 
		    endif
		    _lEst     := Tabela("12",UPPER(alltrim(_CUF)),.f.) <> Nil
		
		    If  _cpessoa == "J"
			   _lIE      := IE(iif(alltrim(_cinsest)=="NT" .OR. empty(alltrim(_cinsest)),"ISENTO",alltrim(_cinsest)), UPPER(alltrim(_CUF)))
			   _cInscr   := iif(alltrim(_cinsest)=="NT" .OR. empty(alltrim(_cinsest)),"ISENTO",alltrim(_cinsest))
			   _cRG      := ""
		    Else
			   _lIE      := .t.
			   _cInscr   := ""
			   _cRG      := iif(alltrim(_cinsest)=="NT" .OR. empty(alltrim(_cinsest)),"",alltrim(_cinsest))
		    Endif                    
		
		    _lPess    := _cpessoa $ "FJ"
		    _lObrigat := !empty(_cnome) .and. ;
		    !empty(_cNFant)  .and. ;
		    !empty(_cEnd)    .and. ;	
		    !empty(_cmuni)   .and. ;
		    !empty(_CUF)     .and. ;
		    !empty(_cCEP)    .and. ;
		    !empty(_cDDD) 	  .and. ;
		    !empty(_cBAIRR)   .and. ;
		    !empty(_Cemail)   .and. ;
		    !empty(_cTel1)    .and. ;
		    !empty(_ccodmun)  .and. ;
		    !empty(_cpais)    .and. ;
   		    !empty(_cpbacen)    .and. ;
		    !empty(_cmenpad)   .and. ;
		    !empty(_ctransp)   .and. ;
		    !empty(_ccontrib) 
		    
		    // Verifica se é inclusao ou alteracao
			If linclui
			  _nOpc    := 3
			else
			  _nOpc    := 4	
            Endif
            
            If !empty(_cCEP)
               _lcep:=.f.
               IF Z07->(dbSeek(xfilial("Z07")+_cCEP))
                  _lcep:=.T.
               ELSEIF  Z07->(dbSeek(xfilial("Z07")+LEFT(_cCEP,5))) 
                  _cCEP:=Z07->Z07_CEP
                  _lcep:=.T.
               ENDIF   
            Endif                                 
            
            // Verifica se é um novo código de cliente ou uma nova loja de cliente.
            If lnewloj
               _cCliloj:= VerA1LOJ(_cCNPJ)
               _cCodCli:=left(_cCliloj,6)
               _cLoja  :=substr(_cCliloj,7)
            Else 
               //_cCodCli:= VerA1COD()
               _cLoja  := '01'
            Endif     
            
            If !_lIE
			    _cInscr:="ISENTO"  
			    _cmensag:="Cadastrado, porem Inscr. Estadual inválida, cadastrado como ISENTO"
			    aAdd(_aErros, {_cCNPJ,_cmensag})
			    _lIE:=.T.
			Endif                     
            
            
            
            If lnewloj 
  	    	        _aDados := {{"A1_COD"   , _cCodCli   		  	 		 		,Nil},;
                    {"A1_LOJA"      , _cLoja		 	  		 			    	,Nil},;
					{"A1_NOME"      , UPPER(alltrim(_cnome))	                    ,Nil},;
					{"A1_PESSOA"    , UPPER(_cpessoa)                           	,Nil},;
					{"A1_NREDUZ"    , alltrim(_cNFANT)	                            ,Nil},;
					{"A1_TIPO"      , "F"			 	 		 				    ,Nil},;
					{"A1_CEP"       , alltrim(_cCEP)						     	,Nil},;
					{"A1_END"       , UPPER(alltrim(_cEnd)) 	                    ,Nil},;
    				{"A1_BAIRRO"    , UPPER(alltrim(_cBAIRR))                      ,Nil},;
					{"A1_EST"       , UPPER(alltrim(_CUF))                      	,Nil},;
					{"A1_MUN"       , UPPER(alltrim(_cmuni))	                    ,Nil},;
					{"A1_XNUMCOM"   , UPPER(alltrim(_ccompl))	                    ,Nil},;
					{"A1_DDD"       , alltrim(_cDDD)						    	,Nil},;
					{"A1_TEL"       , alltrim(_cTEL1)	                            ,Nil},;
					{"A1_TEL2"      , alltrim(_cTel2)                           	,Nil},;
    				{"A1_FAX"       , alltrim(_cfax)          	                    ,Nil},;
    				{"A1_PAIS"      , UPPER(alltrim(_cpais))	                    ,Nil},;
					{"A1_CGC"       , _cCNPJ									    ,Nil},;
    				{"A1_CONTATO"   , alltrim(_ccontat)       	                    ,Nil},;
					{"A1_INSCR"     , _cInscr									    ,Nil},;
					{"A1_PFISICA"   , _cRG										    ,Nil},;
					{"A1_INSCRM"    , alltrim(_cinsmun)                            ,Nil},;
					{"A1_EMAIL"     , alltrim(_Cemail)                           	,Nil},;
					{"A1_COMPLEM"   , UPPER(alltrim(_ccompl))+" - "+UPPER(alltrim(_cregiao)) ,Nil},;
					{"A1_CODPAIS"   , UPPER(alltrim(_cpbacen))	                    ,Nil},;
					{"A1_ENDENT"    , UPPER(alltrim(_cEnd))						    ,Nil},;
					{"A1_BAIRROE"   , UPPER(alltrim(_cBAIRR))                      ,Nil},;
					{"A1_MUNE"      , UPPER(alltrim(_cmuni))                    	,Nil},;
					{"A1_ESTE"      , UPPER(alltrim(_CUF))                      	,Nil},;
					{"A1_COD_MUN"	, _ccodmun          							,Nil},;
					{"A1_CEPE"      , alltrim(_cCEP)							    ,Nil},;	
   					{"A1_CONTRIB"   , UPPER(alltrim(_ccontrib))	                    ,Nil},;
					{"A1_TRANSP"    , alltrim(_ctransp)						     	,Nil},;
					{"A1_MENSAGE"   , alltrim(_cmenpad)								,Nil}}
					//{"A1_XLOGRAC"   , UPPER(alltrim(_clograd))                   	,Nil},;
					//{"A1_XENDERC"   , UPPER(alltrim(_cEnd))                     	,Nil},;
					//{"A1_XCOMPLC"   , UPPER(alltrim(_ccompl))	                    ,Nil},;
					//{"A1_XBAIRRC"   , UPPER(alltrim(_cBAIRR))                   	,Nil},;
					//{"A1_XMUNC"     , UPPER(alltrim(_cmuni))	                    ,Nil},;
					//{"A1_XNOME"     , UPPER(alltrim(_cnome))                     	,Nil},;
					//{"A1_XLOGRA"    , UPPER(alltrim(_clograd))                     	,Nil},;
					//{"A1_XENDER"    , UPPER(alltrim(_cEnd))                      	,Nil},;
					//{"A1_XCOMPL"    , UPPER(alltrim(_ccompl))	                    ,Nil},;
					//{"A1_XLOGRE"    , UPPER(alltrim(_clograd))                   	,Nil},;
					//{"A1_XENDERE"   , UPPER(alltrim(_cEnd))                        	,Nil},;
					//{"A1_XCOMPLE"   , UPPER(alltrim(_ccompl))                    	,Nil},;
					//{"A1_XMUNE"     , UPPER(alltrim(_cmuni))	                    ,Nil}}
					
		    Else  
				_aDados :={{"A1_LOJA"      , _cLoja		 	  		 				,Nil},;
					{"A1_NOME"      , UPPER(alltrim(_cnome))	                    ,Nil},;
					{"A1_PESSOA"    , UPPER(_cpessoa)                           	,Nil},;
					{"A1_NREDUZ"    , alltrim(_cNFANT)	                            ,Nil},;
					{"A1_TIPO"      , "F"			 	 		 				    ,Nil},;
					{"A1_CEP"       , alltrim(_cCEP)						     	,Nil},;
					{"A1_END"       , UPPER(alltrim(_cEnd)) 	                    ,Nil},;
    				{"A1_BAIRRO"    , UPPER(alltrim(_cBAIRR))                      ,Nil},;
					{"A1_EST"       , UPPER(alltrim(_CUF))                      	,Nil},;
					{"A1_MUN"       , UPPER(alltrim(_cmuni))	                    ,Nil},;
					{"A1_XNUMCOM"   , UPPER(alltrim(_ccompl))	                    ,Nil},;
					{"A1_DDD"       , alltrim(_cDDD)						    	,Nil},;
					{"A1_TEL"       , alltrim(_cTEL1)	                            ,Nil},;
					{"A1_TEL2"      , alltrim(_cTel2)                           	,Nil},;
    				{"A1_FAX"       , alltrim(_cfax)          	                    ,Nil},;
    				{"A1_PAIS"      , UPPER(alltrim(_cpais))	                    ,Nil},;
					{"A1_CGC"       , _cCNPJ									    ,Nil},;
    				{"A1_CONTATO"   , alltrim(_ccontat)       	                    ,Nil},;
					{"A1_INSCR"     , _cInscr									    ,Nil},;
					{"A1_PFISICA"   , _cRG										    ,Nil},;
					{"A1_INSCRM"    , alltrim(_cinsmun)                            ,Nil},;
					{"A1_EMAIL"     , alltrim(_Cemail)                           	,Nil},;
					{"A1_COMPLEM"   , UPPER(alltrim(_ccompl))+" - "+UPPER(alltrim(_cregiao)) ,Nil},;
					{"A1_CODPAIS"   , UPPER(alltrim(_cpbacen))	                    ,Nil},;
					{"A1_ENDENT"    , UPPER(alltrim(_cEnd))						    ,Nil},;
					{"A1_BAIRROE"   , UPPER(alltrim(_cBAIRR))                      ,Nil},;
					{"A1_MUNE"      , UPPER(alltrim(_cmuni))                    	,Nil},;
					{"A1_ESTE"      , UPPER(alltrim(_CUF))                      	,Nil},;
					{"A1_COD_MUN"	, _ccodmun          							,Nil},;
					{"A1_CEPE"      , alltrim(_cCEP)							    ,Nil},;	
   					{"A1_CONTRIB"   , UPPER(alltrim(_ccontrib))	                    ,Nil},;
					{"A1_TRANSP"    , alltrim(_ctransp)						     	,Nil},;
					{"A1_MENSAGE"   , alltrim(_cmenpad)								,Nil}}
					//{"A1_XLOGRAC"   , UPPER(alltrim(_clograd))                   	,Nil},;
					//{"A1_XENDERC"   , UPPER(alltrim(_cEnd))                     	,Nil},;
					//{"A1_XCOMPLC"   , UPPER(alltrim(_ccompl))	                    ,Nil},;
					//{"A1_XBAIRRC"   , UPPER(alltrim(_cBAIRR))                   	,Nil},;
					//{"A1_XMUNC"     , UPPER(alltrim(_cmuni))	                    ,Nil},;
					//{"A1_XNOME"     , UPPER(alltrim(_cnome))                     	,Nil},;
					//{"A1_XLOGRA"    , UPPER(alltrim(_clograd))                     	,Nil},;
					//{"A1_XENDER"    , UPPER(alltrim(_cEnd))                      	,Nil},;
					//{"A1_XCOMPL"    , UPPER(alltrim(_ccompl))	                    ,Nil},;
					//{"A1_XLOGRE"    , UPPER(alltrim(_clograd))                   	,Nil},;
					//{"A1_XENDERE"   , UPPER(alltrim(_cEnd))                        	,Nil},;
					//{"A1_XCOMPLE"   , UPPER(alltrim(_ccompl))                    	,Nil},;
					//{"A1_XMUNE"     , UPPER(alltrim(_cmuni))	                    ,Nil}}
			
			Endif

            

		    // Se passou por todos os testes, executa funcao de atualizacao do SA1
		    If _lEst .and. _lIE .and. _lPess .and. _lObrigat .and. _lCGC  .and. _lcep
			   // Se retornar False, alimenta matriz de erros
			   If !CadCli(_aDados,_nOpc)
				  _cmensag:="Nao foi possivel cadastrar esse CNPJ, Erro na rotina automática."
				  aAdd(_aErros, {_cCNPJ,_cmensag})
			    Endif
		    Else 
			     If !_lEst
				     _cmensag:= "Estado inválido "
				     aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif
			     If !_lIE
                     _cmensag:="Inscr. Estadual inválida "
                     aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif			     
			     If !_lPess
				     _cmensag:= "Tipo de pessoa inválido "
				     aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif
			     If !_lCGC
				     _cmensag:= "CNPJ/CPF inválido " 
				     aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif
			     If !_lcep
			        _cmensag:= "CEP inválido " 
				    aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif
			     
			     
			     If empty(_cNFANT)
				     _cmensag:= "Nome Fantasia ou nome do cliente não informado"
				     aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif
			     If empty(_cTEL1)					 
				     _cmensag:= "Numero de telefone em branco ou invalido"
				     aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif
			     IF empty(_cBAIRR) .OR. _cBAIRR="XXXXXXXXX"
				     _cmensag:= "Bairro em branco ou invalido"
				     aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif
			     If empty(_cDDD)
				     _cmensag:= "Campo DDD invalido."
				     aAdd(_aErros, {_cCNPJ,_cmensag})
			     Endif                                                                
			     
			     
			Endif
	        RollBackSXE()
	   Else
	     _cmensag:="Nao foi possivel cadastrar esse CNPJ, CNPJ Invalido ou em branco."
		 aAdd(_aErros, {_cCNPJ,_cmensag})
	   Endif
	Else
	   _cmensag:="Nao foi possivel cadastrar esse CNPJ, CNPJ ja cadastrado."
	   aAdd(_aErros, {_cCNPJ,_cmensag})
	Endif
	_nregnotp++
	
  QRY->(dbskip())
Enddo


if len(_aErros) > 0
	alert("Erro na geracao de clientes")
	U_ERROCADCLI(_aErros)
endif

IF _nregnotp > 0
   apMsgStop( "Houveram " +strzero(_nregnotp,5)+ " Registros não processados - Favor verificar.", "Atenção" ) 
ENDIF   

restarea(_aAreaSA1)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CadCLI    ºAutor  ³Microsiga           º Data ³  10/22/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function cadcli(aVetor,_nOpc)

lMsErroAuto := .F.

MSExecAuto({|x,y| Mata030(x,y)},aVetor,_nOpc) //Inclusao

If lMsErroAuto
	A:=1
	RollBackSXE()
//	mostraerro()
Else
	A:=1
	//	Alert("Ok")
	ConfirmSX8()
Endif
A:=1
return(!lMsErroAuto)                          




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACHADDD  ºAutor  ³Microsiga           º Data ³  19/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para encontrar o DDD correspondente ao Estado /     º±±
±±º          ³ Municipio do cliente                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function AchaDDD(_cAchaMun, _cAchaUF)

local _aAreaSZb := SZB->(GetArea())
local _cAchaDDD := ""

SZB->(dbSetOrder(1))  // ZB_FILIAL +

if SZB->(dbSeek(xFilial("SZB") + _cAchaUF + _cAchaMun))
	_cAchaDDD := SZB->ZB_DDD	  
else
   if SZB->(dbSeek(xFilial("SZB") + _cAchaUF ))
      _cAchaDDD := SZB->ZB_DDD	  
   endif   
endif    

restarea(_aAreaSZb)

return(_cAchaDDD)

/*                                           

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VERA1COD ºAutor  ³Microsiga           º Data ³  20/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar o proximo codigo de cliente          º±±
±±º          ³ disponivel para uso                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function VerA1COD()

local _cA1COD   := GetSXENum("SA1")
local _aAreaSA1 := SA1->(GetArea())

SA1->(dbSetOrder(1))
while SA1->(dbSeek(xFilial("SA1") + _cA1COD))
	_cA1COD := soma1(_cA1COD)
enddo

restarea(_aAreaSA1)

return(_cA1COD)                                

/*                                           
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VERA1LOJ ºAutor  ³Edson Rodrigues     º Data ³  29/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar o proximo codigo/loja de cliente     º±±
±±º          ³ com 9 digitos do CNPJ inicial ja existente ou seja mesmo   º±±
±±º          | cliente porem com estabelicimentos diferentes.             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function VerA1LOJ(_cCNPJ)

local _aAreaSA1 := SA1->(GetArea())
Local _CQRYCNPJ     := ""
Local _ccliloj  := ""

If select("QRYCNPJ") > 0
   QRYCNPJ->(dbclosearea())
Endif                      

SA1->(dbSetOrder(3))

_CQRYCNPJ     := " SELECT A1_COD,A1_LOJA,MAX(A1_LOJA) AS MAXLOJA FROM SA1020     "
_CQRYCNPJ     += " WHERE D_E_L_E_T_='' AND LEFT(A1_CGC,9)='"+left(_cCNPJ,9)+"'  "
_CQRYCNPJ     += " GROUP BY A1_COD,A1_LOJA "
_CQRYCNPJ     += " ORDER BY A1_COD,A1_LOJA "

 TCQUERY _CQRYCNPJ NEW ALIAS "QRYCNPJ"

QRYCNPJ->(dbgotop())
While !QRYCNPJ->(eof())  
   _ccliloj:=QRYCNPJ->A1_COD+soma1(QRYCNPJ->A1_LOJA)
   QRYCNPJ->(dbskip())                                                                          
Enddo
restarea(_aAreaSA1)

return(_ccliloj)                                


