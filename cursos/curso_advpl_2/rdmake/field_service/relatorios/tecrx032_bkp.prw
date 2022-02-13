#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"              
#include "tbiconn.ch"                                
#DEFINE OPEN_FILE_ERROR -1  
#define ENTER CHR(10)+CHR(13)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX032 บAutor  ณMicrosiga           บ Data ณ  19/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para geracao de planilha Excel com os dados de    บฑฑ
ฑฑบ          ณ entrada, processo e saida dos produtos para reparos.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TECRX032(_APARAMS)

Local aSay        := {}
Local aButton     := {}
Local nOpc        := 0
Local ctitulo     := "Relat๓rio Cycle Time"
Local cDesc1      := "Este programa tem como objetivo imprimir relat๓rio para efetuar um controle da entrada, "
Local cDesc2      := "processo e saํda dos produtos recebidos para reparos. "
Local cDesc3      := ""
Local _cstruser   := ""
private _center   := Chr(13)+Chr(10)
Private cPerg     := "RL01  "
Private cTitemail := "Relatorio Cycle Time automatico"
Private _ausers   := {} 
Private _cparm    := ""
Private _tFile    := .t.



If _APARAMS == NIL .or. len(_APARAMS) <= 0
    _APARAMS := {}
  //_APARAMS:={"02","02",CTOD("11/01/2010"),DATE(),CTOD("11/01/2010"),DATE(),"1","22/26/27"," ",1,3,0,2,1,.T.,"000169/000654/000809"}
  //_APARAMS:={"02","02",CTOD("12/01/10"),DATE(),CTOD("12/01/10"),DATE(),"1","10/11/17"," ",1,3,0,1,1,.T.,"000695/000641/000378"}                                                                           
Endif
lbat := iif(len(_APARAMS)>=15,_APARAMS[15],nil)
lBat := If(lBat == NIL, .F., lBat)

                      
If !lBat //.and. !IsBlind()
     // PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "SD1","SD2","SZ1","AB9","AA3","SA1","SB1","SBM","SC6","SX5","SZ1"
     // ConOut("CycleTime Job - Empresa: "+cEmpAnt+"/"+cFilAnt)
      aAdd( aSay, cDesc1 )
      aAdd( aSay, cDesc2 )
      aAdd( aSay, cDesc3 )

      aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
      aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
      aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

      FormBatch( cTitulo, aSay, aButton )

      If nOpc <> 1
     	Return Nil
      Endif
      Processa( {|lEnd| fRL01A(@lEnd)}, "Aguarde...","Gerando os dados do CYCLETIME ...", .T. )
Else                            

  PREPARE ENVIRONMENT EMPRESA  _APARAMS[1] FILIAL  _APARAMS[2] TABLES "SD1","SD2","SZ1","AB9","AA3","SA1","SB1","SBM","SC6","SX5","SZ1"
 
  mv_par01:=IIF(_APARAMS[3]  == NIL,mv_par01,_APARAMS[3])
  mv_par02:=IIF(_APARAMS[4]  == NIL,mv_par02,_APARAMS[4])  
  mv_par03:=IIF(_APARAMS[5]  == NIL,mv_par03,_APARAMS[5])
  mv_par04:=IIF(_APARAMS[6]  == NIL,mv_par04,_APARAMS[6])
  mv_par05:=IIF(_APARAMS[7]  == NIL,mv_par05,_APARAMS[7])    // Op็ใo de normal ou excel
  mv_par06:=IIF(_APARAMS[8]  == NIL,mv_par06,_APARAMS[8])   // Almoxarifados
  mv_par07:=IIF(_APARAMS[9]  == NIL,mv_par07,_APARAMS[9])     // Cliente
  mv_par08:=IIF(_APARAMS[10]  == NIL,mv_par08,_APARAMS[10])    // Status (1 = Tudo, 2 = Com NF, 3 = Sem NF)
  mv_par09:=IIF(_APARAMS[11]  == NIL,mv_par09,_APARAMS[11])    // Formulario Proprio 1=Sim/2=Nao/3=todos
  mv_par10:=IIF(_APARAMS[12] == NIL,mv_par10,_APARAMS[12])    // Dias para Bounce
  mv_par11:=IIF(_APARAMS[13] == NIL,mv_par11,_APARAMS[13])    //  -> Nextel x Sony / 1 = Nextel , 2 = Sony/Ericsson
  mv_par12:=IIF(_APARAMS[14] == NIL,mv_par12,_APARAMS[14])    //  -> Versao excel maior que 2003 ?/ 1 = Sim , 2 = Nใo  

  _cstruser:=alltrim(_APARAMS[16])
  PswOrder(1) // pesquisa por c๓digo
  Path := "172.16.0.7"
  cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
  
  
  for x:=1 to len(_cstruser)
           ndiv:=AT("/",_cstruser)
           If !ndiv = nil .and. ndiv > 0
              _cusr:=substr(_cstruser,1,ndiv-1)
              _cstruser:=substr(_cstruser,ndiv+1)
              If PswSeek(alltrim(_cusr)) // Ex: c๓digo do usuแrio
                _aPswDet1 := PswRet(1) // Retorna um array multidimensional contendo os dados do usuแrio
                _apswdet2 := PswRet(2) // Retorna um array multidimensional contendo os dados do usuแrio
                _csrname := _aPswDet1[1,2]
                _usrmail := _aPswDet1[1,14]  // e-mail do usuแrio
                _usrrelat := _aPswDet2[1,3] // diret๓rio da pasta relato
                aadd(_ausers,{_cusr,_csrname,_usrmail,_usrrelat})
              Endif  
           Else   
              IF PswSeek(alltrim(_cstruser)) // Ex: c๓digo do usuแrio
               _cstruser:="" 
               _aPswDet1 := PswRet(1) // Retorna um array multidimensional contendo os dados do usuแrio
               _apswdet2 := PswRet(2) // Retorna um array multidimensional contendo os dados do usuแrio
               _csrname := _aPswDet1[1,2]
               _usrmail := _aPswDet1[1,14]  // e-mail do usuแrio
               _usrrelat := _aPswDet2[1,3] // diret๓rio da pasta relato
               aadd(_ausers,{_cstruser,_csrname,_usrmail,_usrrelat})
             Endif  
           Endif
  Next   
  
  
  FOR X:=1 TO len(_ausers)
     IF X=1
       _csrname:=alltrim(_ausers[X][2])
     ELSE
       _csrname=_csrname+"/"+alltrim(_ausers[X][2])
     ENDIF   
  NEXT                                               
  
  IF len(_ausers) <=0
     ConOut("Nenhum usuario cadstrado, verifique os parametros")
     Return  
  Endif
  
  ConOut("*")
  ConOut("*")               
  ConOut(Replicate("*",40)) 
  ConOut("Excluindo os arquivos Cycletimes anteriores a "+dtoc(date()))
  ConOut("*")
  ConOut("*")                            

  For x:=1 to len(_ausers)
     _aArqCYCL   :={}                                   
     cpath := StrTran(alltrim(_ausers[x][4]), "\", "/" )
     _aArqCYCL   := Directory (cpath+ "CYCLETIME_AUTO_*.csv")
 
     If len(_aArqCYCL) > 0                        
        for i:=1 to len(_aArqCYCL) 
            IF DTOS(_aArqCYCL[i][3]) < DTOS(DATE())
              //IF SUBSTR(_aArqCYCL[i][1],16,8) < DTOS(DATE())
               FERASE(cpath+ _aArqCYCL[i][1]) 
            ENDIF   
        Next
     Endif  
  Next
  
  
   
  ConOut(Replicate("*",40)) 
  ConOut("   [CYCLETIME] - "+dtoc(date())+" "+time()+_center) 
  ConOut("   [CYCLETIME] Parametros usuario(s) :"+_csrname+"..."+_center)





  ConOut("*")
  ConOut("*")
  ConOut("*")                                            
  ConOut(Replicate("*",40)) 
  ConOut("   [CYCLETIME] - "+dtoc(date())+" "+time()+_center) 
  ConOut("   [CYCLETIME] Parametros usuario(s) :"+_csrname+"..."+_center)   
   
 _cparm:="  Empresa / Filial :  "+_APARAMS[1]+"/"+_APARAMS[2]+ _center+; 
         "  Entrada de :  "+DTOC(_APARAMS[3])+ _center+;
         "  Entrada ate : "+DTOC(_APARAMS[4])+ _center+;
         "  Saida de :  "+DTOC(_APARAMS[5])+ _center+; 
         "  Saida ate :  "+DTOC(_APARAMS[6])+ _center+;
         "  Opcao (1-excel/2-normal) ? :  "+_APARAMS[7]+ _center+;
         "  Almoxarifados ? :  "+_APARAMS[8]+ _center+;
         "  Cliente ? :  "+IIF(EMPTY(_APARAMS[9]),'TODOS',_APARAMS[9])+_center+;
         "  Status (1-Tudo/2-Com NF/3-Sem NF)? :  "+STRZERO(_APARAMS[10],1)+ _center+;
         "  Formulario (1-SIM/2-NAO/3-Todos) ? :  "+STRZERO(_APARAMS[11],1)+ _center+;
         "  Dias de Bounce ? :  "+STRZERO(_APARAMS[12],1)+ _center+;
         "  Layout (1-Nextel/2-Sony) ? :  "+STRZERO(_APARAMS[13],1)+_center+; 
         "  Versao Excel maior que 2003 (1-sim/2-nao) ? :  "+STRZERO(_APARAMS[14],1)+_center

   
      ConOut(_cparm)      
       
  fRL01A(.t.)
EndIf

Return Nil

//***********************************************************************
//mv_par01 -> Data entrada De
//mv_par02 -> Data entrada Ate
//mv_par03 -> Data saida De
//mv_par04 -> Data saida Ate
//mv_par05 -> Op็ใo de normal ou excel
//mv_par06 -> Almox De
//mv_par07 -> Cliente  (Branco para todos)
//mv_par08 -> Status (1 = Tudo, 2 = Com NF, 3 = Sem NF)
//mv_par09 -> Formulario Proprio?
//mv_par10 -> Dias para Bounce
//mv_par11 -> Layou Nextel ou Sony / 1 = Nextel , 2 = Sony/Ericsson
//mv_par12 -> Versao excel maior que 2003 ?/ 1 = Sim , 2 = Nใo
//***********************************************************************
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FRL01A   บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de processamento do Cycle Time                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRL01A(lEnd)

Local cAlias 	:= ALIAS()
Local aAlias 	:= {"SD1","SD2","SZ1","AB9","AA3","SA1","SB1","SBM","SC6"}
Local aAmb   	:= U_GETAMB( aAlias )
Local nTotal 	:= 0
//Local _cNFEIMEI := ""

//Local cPath:=AllTrim(GetTempPath())     // claudia 19/01/2010 - solicitado pelo Carlos Rocha para gerar arquivo CSV
Local cDirDocs:= IIf(!lbat,__RelDir,Alltrim(_ausers[1][4]))          // claudia 19/01/2010 - solicitado pelo Carlos Rocha para gerar arquivo CSV
Local _cArq     := IIf(!lbat,"CYCLETIME_"+Alltrim(cUserName),"CYCLETIME_AUTO_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)+SUBSTR(time(),7,2)+"_"+Alltrim(_ausers[1][2]))    
Local _cArqTmp  := iif(!lbat,lower(AllTrim(__RELDIR)+_cArq),lower(AllTrim(_ausers[1][4])+_cArq))
Local _cArq2    := IIf(!lbat,"CYCLETIME_CONT_"+Alltrim(cUserName),"CYCLETIME_AUTO_CONT_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)+SUBSTR(time(),7,2)+"_"+Alltrim(_ausers[1][2]))   
Local _cArqt2   := iif(!lbat,lower(AllTrim(__RELDIR)+_cArq2),lower(AllTrim(_ausers[1][4])+_cArq2))
Local _cRel		:= GetMv("MV_RELATO") 				 // Diretorio do compartilhamento pasta relato
Local _lex2007  := .f.

//private _cArqTrab := CriaTrab(,.f.)
Private cCrLf       :=Chr(13)+Chr(10)   
Private _carqcycle  := ""
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
private nConta 	    := 0
Private cMensagem   :=""
private _cHrReg     := ""
private _cHrDBF     := ""
private _cHrQRY     := ""
private _cHrTRBI    := ""
private _cHrTRBF    := ""
private _cHrFASI    := ""
private _cHrFASF    := ""
private _cLAB       := ""
private _cdefcli    := ""
private _cdesprod   :=""
private _inicio     := time()
Private carmproc    :=ALLTRIM(GetMV("MV_ARMPROC")) 
Private cmovprod    :=ALLTRIM(GetMV("MV_MOVPROD"))
Private nHandle     := 0

if mv_par11 == 2  // SONY
	ZZ1->(dbSetOrder(1))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
else              // NEXTEL
	ZZ1->(dbSetOrder(2))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_FASE1 + ZZ1_CODSET
endif

u_query(.F.)

IF lBat
    ConOut("Gravando arquivo na pasta de impressao : "+ AllTrim(_ausers[1][4])+" do usuario: "+ AllTrim(_ausers[1][2])+"."+_center) 
ENDIF

/*----------------------- fim alteracao claudia 19/01/2010 - solicitado pelo Carlos Rocha para gerar arquivo CSV ---------------------*/

//Incluso funcใo - Edson Rodrigues - 27/06/11
criacsv(cDirDocs,_cArq)

ProcRegua(TRB1->(reccount()))

TRB1->(dbGoTop())
While TRB1->(!eof())
	
	// Incrementa a regua
	IncProc()

	// Carlos Rocha - 07/02/2010
	// Eliminado o trecho abaixo, inserida condi็ใo na query para retornar apenas UM IMEI por NFE.
	//	
	// Caso passe mais de uma vez pelo mesmo IMEI + NFEntrada, deleta o registro no arquivo gerado
	//if TRB1->NFE + TRB1->IMEI = _cNFEIMEI
	//	TRB1->(dbSkip())
	//	Loop
	//else
	//	_cNFEIMEI := TRB1->NFE + TRB1->IMEI
	//endif
	//
	// Fim - CR
	
	_dEntra    := iif(empty(TRB1->ENTRDOCA), TRB1->ENTRADA, TRB1->ENTRDOCA)
	_dSaida    := iif(empty(TRB1->SAIDDOCA), dDataBase    , TRB1->SAIDDOCA)
	_cNomeSai  := _cTES := ""
	
	reclock("TRB1",.f.)
	TRB1->MOTDOCA  := GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + "ZD" + TRB1->CODMOTDOC,1,"Normal")
	
	// Calcula tempo de reparo a partir da saida massiva
	TRB1->TEMPREP  := Iif(type("_dSaida") = 'C',ctod( _dSaida), _dSaida ) - IIF(type("_dEntra") = 'C',ctod(_dEntra),_dEntra)
	
	// Verifica data da ultima saida do IMEI
	if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
		TRB1->NOMESAI  := Posicione("SA1",1,xFilial("SA1")+TRB1->CLISAI+TRB1->LOJSAI,"A1_NREDUZ")
	endif
	
	// Preenche descricao da Reclamacao do cliente --Edson Rodrigues set/09
	If mv_par11 == 1
	//_cLAB:=Posicione("ZZ3",1,xFilial("ZZ3") + TRB1->IMEI+ left(TRB1->OS,6)+space(2), "ZZ3_LAB" )
	_cLAB:= "2"
	Else
	_cLAB:="1"
	EndIf
	//_cdefcli:=IIF(!EMPTY(TRB1->DEFCLIEN),alltrim(TRB1->DEFCLIEN)+space(6-LEN(alltrim(TRB1->DEFCLIEN))),"")
	_cdefcli := TRB1->DEFCLIEN
	if !empty(_cdefcli)
		TRB1->DESCDEFCL:=Posicione("ZZG",1,xFilial("ZZG") + _cLAB + _cdefcli, "ZZG_DESCRI" )
	Endif              
	            
	If !Empty(TRB1->DEFCONST) .And. !Empty(TRB1->SOLCONST)
	
	_cdefcon := TRB1->DEFCONST
	If !Empty(_cdefcon) 
		TRB1->DESCDEFCO := Posicione("SZ8",3,xFilial("SZ8") + _cdefcon , "Z8_DESSINT" )
	EndIf
	        
	_cdefsol := TRB1->SOLCONST
	If !Empty(_cdefsol)
		TRB1->DESCSOLCO := Posicione("SZL",2,xFilial("SZL")+ _cLAB + _cdefcon +  _cdefsol, "ZL_DESCSIN")
	EndIf
	
	Else
	
	_cdefcon := TRB1->DEFCONST1
	If !Empty(_cdefcon) 
		TRB1->DESCDEFCO := Posicione("SZ8",3,xFilial("SZ8") + _cdefcon , "Z8_DESSINT" )
		TRB1->DEFCONST	:= TRB1->DEFCONST1
	EndIf
	        
	_cdefsol := TRB1->SOLCONST1
	If !Empty(_cdefsol)
		TRB1->DESCSOLCO := Posicione("SZ8",2,xFilial("SZ8")+ _cLAB  +  _cdefsol, "Z8_DESSOLU")
		TRB1->SOLCONST	:= TRB1->SOLCONST1
	EndIf
	EndIf
	
	nConta++
	
	TRB1->(msunlock())
	/*-------------------------- claudia 19/01/2010 - solicitado pelo Carlos Rocha para gerar arquivo CSV -------------------*/
	cLinha := ''
	cLinha += TRB1->PRODUTO 			+ ';'
	
	// Preenche descricao do Produto --Edson Rodrigues 14/out/10
	_cdesprod:=Posicione("SB1",1,xFilial("SB1") + TRB1->PRODUTO, "B1_DESC" )
	cLinha += _cdesprod + ';'
		
	If !alltrim(mv_par06) $ carmproc
		cLinha += TRB1->ARMAZEM + ';'
	Else
		cLinha += TRB1->ARM_ENTR + ';'
		cLinha += TRB1->ARM_PROC + ';'
		cLinha += TRB1->ARM_SAI  + ';'
	Endif
	cLinha += TRB1->NFE 			    + ';'
	cLinha += TRB1->SERIENF 		+ ';'
	if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
		cLinha +=  TRB1->FORMUL + ';'
	endif
	cLinha += RIGHT(TRB1->EMISENT,2)+'/'+SUBSTR(TRB1->EMISENT,5,2)+'/'+LEFT(TRB1->EMISENT,4) + ';'
	cLinha += RIGHT(TRB1->ENTRDOCA,2)+'/'+SUBSTR(TRB1->ENTRDOCA,5,2)+'/'+LEFT(TRB1->ENTRDOCA,4) + ';'
	cLinha += TRB1->HORADOCA 			+ ';'
	cLinha += RIGHT(TRB1->SAIDDOCA,2)+'/'+SUBSTR(TRB1->SAIDDOCA,5,2)+'/'+LEFT(TRB1->SAIDDOCA,4) + ';'
	cLinha += RIGHT(TRB1->ENTRADA,2)+'/'+SUBSTR(TRB1->ENTRADA,5,2)+'/'+LEFT(TRB1->ENTRADA,4) + ';'
	cLinha += RIGHT(TRB1->ULTSAIDA,2)+'/'+SUBSTR(TRB1->ULTSAIDA,5,2)+'/'+LEFT(TRB1->ULTSAIDA,4)  + ';'
	cLinha += TRANSFORM(TRB1->BOUNCE,'@E 99999999.99999999') 			+ ';'
	cLinha += TRANSFORM(TRB1->VALUNIT,'@E 99999999.99999999') 			+ ';'
	cLinha += TRANSFORM(TRB1->QUANT,'@E 99999999.99999999') 			+ ';'
	cLinha += TRB1->GRUPO 			+ ';'
	cLinha += TRB1->CLIENTE 			+ ';'
	cLinha += TRB1->LOJA 			+ ';'
	cLinha += TRB1->NOMEENT 			+ ';'
	cLinha += TRB1->ESTADO 			+ ';'
	cLinha += SPACE(1)+ TRANSFORM(TRB1->IMEI,"AAAAAAAAAAAAAAA") 			+ ';'
	cLinha += SPACE(1)+ TRANSFORM(TRB1->CARCACA,"AAAAAAAAAAAAAAA")			+ ';'
	cLinha += TRB1->PEDIDO 			+ ';'
	if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
		cLinha += TRB1->NOMESAI + ';'
	endif
	cLinha += TRB1->NFBGH 				+ ';'
	cLinha += RIGHT(TRB1->EMISSAI,2)+'/'+SUBSTR(TRB1->EMISSAI,5,2)+'/'+LEFT(TRB1->EMISSAI,4)		+ ';'
	cLinha += TRB1->TES 				+ ';'
	cLinha += TRB1->OS 					+ ';'
	cLinha += STRZERO(TRB1->NUMVEZ,2) + ';'
	cLinha +=  RIGHT(TRB1->ENTRCHAM,2)+'/'+SUBSTR(TRB1->ENTRCHAM,5,2)+'/'+LEFT(TRB1->ENTRCHAM,4)  			+ ';'
	cLinha += TRB1->FASEMAX 			+ ';'
	cLinha += TRB1->DESFAMAX 			+ ';'
	cLinha += TRB1->FASEATU 			+ ';'
	cLinha += TRB1->DESFAATU 			+ ';'
	cLinha += RIGHT(TRB1->DTENCCHA,2)+'/'+SUBSTR(TRB1->DTENCCHA,5,2)+'/'+LEFT(TRB1->DTENCCHA,4) 		+ ';'
	cLinha += TRB1->HRENCCHA 			+ ';'
	cLinha += TRB1->STATUSOS 			+ ';'
	cLinha += TRB1->MOTDOCA 			+ ';'
	cLinha += TRB1->LOTE 				+ ';'
	cLinha += TRB1->DEFCLIEN 			+ ';'
	cLinha += TRB1->DESCDEFCL 			+ ';'
	cLinha += TRB1->DEFCONST			+ ';'
	cLinha += TRB1->DESCDEFCO			+ ';'
	cLinha += TRB1->SOLCONST			+ ';'
	cLinha += TRB1->DESCSOLCO			+ ';'
	if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
		cLinha +=  TRB1->NOVOSN   + ';'
		cLinha +=  TRB1->NFNOVOSN + ';'
		cLinha +=  RIGHT(TRB1->DTNFNSN,2)+'/'+SUBSTR(TRB1->DTNFNSN,5,2)+'/'+LEFT(TRB1->DTNFNSN,4)    + ';'
		cLinha +=  RIGHT(TRB1->DTSAINSN,2)+'/'+SUBSTR(TRB1->DTSAINSN,5,2)+'/'+LEFT(TRB1->DTSAINSN,4)  + ';'
	endif
	cLinha += TRB1->TIPOENTR 			+ ';'
	cLinha += TRB1->OPERACBGH 			+ ';'
	IF mv_par11 = 1 //  Nextel               
		clinha += TRB1->OPERAANTE			+ ';'
		clinha += TRB1->TRANSAC				+ ';'
	    cLinha += TRB1->GARANTIA 			+ ';'  
	    cLinha += TRB1->GARCLAIM	        + ';'
	    cLinha += TRB1->SPC      			+ ';' 
	Endif
	cLinha += TRB1->STATUS 			+ ';'
	cLinha += TRANSFORM(TRB1->TEMPREP,'@E 99999999.99999999') 			+ ';'
	cLinha += TRB1->CODMOTDOC 			+ ';'
	cLinha += TRB1->IDENTB6 			+ ';'
	cLinha += TRB1->CLISAI 			+ ';'
	cLinha += TRB1->LOJSAI 			+ ';'
	cLinha += TRB1->COR 			+ ';'
	fWrite(nHandle, cLinha  + cCrLf)
	/* --------------------- fim  claudia 19/01/2010 - solicitado pelo Carlos Rocha para gerar arquivo CSV  ------------------------------- */
	
	IF nConta >= IIF(!lbat .and. MV_PAR12==2,65534,1048574)
		cLinha := ''
   	    cLinha += 'CONTINUACAO NA PLANILHA :'+IIf(!lbat,"CYCLETIME_CONT_"+Alltrim(cUserName),"CYCLETIME_AUTO_CONT_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)+SUBSTR(time(),7,2)+"_Seu Usuแrio")+ ';'
        fWrite(nHandle, cLinha  + cCrLf)
        fClose(nHandle) 
	    criacsv(cDirDocs,_cArq2)
	    nConta := 1 
	    _lex2007 := .T.
	Endif
	
	TRB1->(dbSkip())
	
Enddo

//_lOPen := .f.

fClose(nHandle) // claudia 19/01/2010  - - solicitado pelo Carlos Rocha para gerar arquivo CSV

//if _lOpen
TRB1->(dbCloseArea())
If File(_carqcycle+GetDBExtension())
	FErase(_carqcycle+GetDBExtension())
EndIf
If File(_carqcycle+OrdBagExt())
	Ferase(_carqcycle+OrdBagExt())
EndIf
//endif

if nConta > 0 .and. !lBat
	
	//CpyS2T(cDirDocs+"\"+_cArq+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
	If !ApOleClient( 'MsExcel' )
		MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
	Else
		oExcelApp := MsExcel():New()
		//oExcelApp:WorkBooks:Open( cPath+_cArq+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 -- 
		oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) // Abre uma planilha 	-- Alterado a pedido do Carlos Rocha 14/07/10 --
		If _lex2007
     	   oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqt2+".CSV" ) // Abre uma planilha 	-- Alterado a pedido do Carlos Rocha 14/07/10 --
		Endif
		
		oExcelApp:SetVisible(.T.)
		
	EndIf
	
else                 
  IF !lBat
	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
  ENDIF  	                   
endif

       
IF !lBat
   _fim := time()
   alert('inicio: '+_inicio+' fim: '+_fim)
   apmsgstop("Cycletime concluํdo" + time(),"Fim de processamento")

ELSE

  

      FOR x:=1 to len(_ausers)           
          
              
          IF x > 1
             
             IF _lex2007
                __CopyFile(_cArqTmp+".CSV",Alltrim(_ausers[x][4]) + alltrim(_cArq)+".CSV")                
                __CopyFile(_cArqt2+".CSV",Alltrim(_ausers[x][4]) + alltrim(_cArq2)+".CSV")                
                cFile :=   Alltrim(_ausers[x][4]) + alltrim(_cArq)+".CSV"
                If !FT_FUSE( cfile ) = OPEN_FILE_ERROR
                   _tFile :=.t.
                   FRENAME(Alltrim(_ausers[x][4]) + alltrim(_cArq)+".CSV",Alltrim(_ausers[x][4]) + "CYCLETIME_AUTO_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)+SUBSTR(time(),7,2)+"_"+Alltrim(_ausers[x][2])+".CSV") 
                Else
                   _tFile :=.f.
                Endif
                cFile :=   Alltrim(_ausers[x][4]) + alltrim(_cArq2)+".CSV"
                If !FT_FUSE( cfile ) = OPEN_FILE_ERROR
                   FRENAME(Alltrim(_ausers[x][4]) + alltrim(_cArq2)+".CSV",Alltrim(_ausers[x][4]) + "CYCLETIME_AUTO_CONT"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)+SUBSTR(time(),7,2)+"_"+Alltrim(_ausers[x][2])+".CSV") 
                Endif 
                 
             Else
                __CopyFile(_cArqTmp+".CSV",Alltrim(_ausers[x][4]) + alltrim(_cArq)+".CSV")                
                cFile :=   Alltrim(_ausers[x][4]) + alltrim(_cArq)+".CSV"
                If !FT_FUSE( cfile ) = OPEN_FILE_ERROR
                   _tFile :=.t.
                   FRENAME(Alltrim(_ausers[x][4]) + alltrim(_cArq)+".CSV",Alltrim(_ausers[x][4]) + "CYCLETIME_AUTO_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)+SUBSTR(time(),7,2)+"_"+Alltrim(_ausers[x][2])+".CSV") 
                 Else
                   _tFile :=.f.
                 Endif
             Endif
          
          
          Endif   

          IF _tFile

                 cMensagem := "O Relatorio Cycletime foi gerado automaticamente em : "+DTOC(date())+" - "+time()+" hrs."+ _center        
                 cMensagem += "Pasta destino: "+alltrim(_ausers[x][4])+_center  
                 cMensagem += "Parametros : "+_center
                 cMensagem += _cparm+_center 
 
                 _fim := time()
                 
                 ConOut("Cycletime " + "inicio: "+_inicio+" fim: "+_fim +".") 
                 ConOut("Cycletime automatico do usuแrio : "+alltrim(_ausers[x][2])+" concluํdo as : " + time()+ ". Fim de processamento") 
          
                 U_ENVIAEMAIL(cTitemail,alltrim(_ausers[x][3])+";helpdesk@bgh.com.br","",cMensagem,Path)
          
                 ConOut("*")
                 ConOut("*")
                 ConOut("*")
          Endif     
  
      Next


ENDIF   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas utilizadas  บฑฑ
ฑฑบ          ณ pela rotina.                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','Entrada de'			,'Entrada de'			,'Entrada de'			,'mv_ch1','D', 8,0,0,'G','',''		,'','S','mv_par01',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'02','Entrada Ate'			,'Entrada Ate'			,'Entrada Ate'			,'mv_ch2','D', 8,0,0,'G','',''		,'','S','mv_par02',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'03','Saida de'			,'Saida de'				,'Saida de'				,'mv_ch3','D', 8,0,0,'G','',''		,'','S','mv_par03',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'04','Saida ate'			,'Saida ate'			,'Saida ate'			,'mv_ch4','D', 8,0,0,'G','',''		,'','S','mv_par04',''		,''			,''			,'',''				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'05','Padrao'				,'Padrao'				,'Padrao'				,'mv_ch5','C', 1,0,2,'C','',''		,'','S','mv_par05','Normal'	,'Normal'	,''			,'','Excel'			,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'06','Almoxarifados'		,'Almoxarifados'		,'Almoxarifados'		,'mv_ch6','C',15,0,0,'G','',''		,'','S','mv_par06',''		,''			,''			,'','' 				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'07','Cliente ?'			,'Cliente ?'			,'Cliente ?'			,'mv_ch7','C', 6,0,0,'G','','CLI'	,'','S','mv_par07',''		,''			,''			,'',''				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'08','Status ?'			,'Status ?'				,'Status ?'				,'mv_ch8','N', 1,0,1,'C','',''		,'','S','mv_par08','Tudo'	,'Tudo'		,'Tudo'		,'','Com NF'		,'Com NF'		,'Com NF'		,'Sem NF'	,'Sem NF'	,'Sem NF'	,'','','','','','')
PutSX1(cPerg,'09','Formulario Proprio?'	,'Formulario Proprio ?'	,'Formulario Proprio ?'	,'mv_ch9','N', 1,0,3,'C','',''		,'','S','mv_par09','Sim'	,'Sim'		,'Sim'		,'','Nao'			,'Nao'			,'Nao'			,'Ambos'	,'Ambos'	,'Ambos'	,'','','','','','')
PutSX1(cPerg,'10','Dias para Bounce'	,'Dias para Bounce'		,'Dias para Bounce'		,'mv_cha','N', 3,0,0,'G','',''		,'','S','mv_par10',''		,''			,''			,'',''				,''				,''				,''			,''			,''			,'','','','','','')
PutSX1(cPerg,'11','Layout:Nextel,Sony/Ericsson ou Sony/BR'		,'Nextel, Sony/Ericsson ou Sony/BR'		,'Nextel, Sony/Ericsson ou Sony/BR'		,'mv_chb','N', 1,0,0,'C','',''		,'','S','mv_par11','Nextel'	,'Nextel'	,'Nextel'	,'','Sony/Ericsson'	,'Sony/Ericsson','Sony/Ericsson','Sony/BR'			,'Sony/BR'			,'Sony/BR'			,'','','','','','')
PutSX1(cPerg,'12','Versใo Excel maior que 2003 ?'	,'Versใo Excel maior que 2003 ?'	,'Versใo Excel maior que 2003 ?'	,'mv_chc','N', 1,0,0,'C','',''		,'','S','mv_par12','Sim'	,'Sim'	,'Sim'	,'','Nao','Nao','Nao',''	,''	,''	,'','','','','','')

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX032  บAutor  ณMicrosiga           บ Data ณ  10/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function query(_lJob)

local _cqry   := ""
local _inicio := time()
local _cFilCliente := _cFilStatus := _cFilFormul := ""
local CR := chr(13) + chr(10)
//local _cLabor := iif(mv_par11 == 1, "2", "1")
local _cLabor := ""
                   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Trata alguns parametros para montagem do filtro                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If mv_par11 == 1
	_cLabor := "2"
ElseIf mv_par11 == 2
	_cLabor := "1"
Else
	_cLabor := "6"
Endif


if !empty(mv_par07)
	_cFilCliente := " AND ZZ4.ZZ4_CODCLI = '"+MV_PAR07+"' " + ENTER
endif

if mv_par08 == 2 // COM NF DE SAIDA
	_cFilStatus := " AND ZZ4.ZZ4_NFSNR<>'' AND ZZ4.ZZ4_STATUS = '9' " + ENTER
ElseIf mv_par08 == 3 // SEM NF DE SAIDA
	_cFilStatus := " AND ZZ4.ZZ4_NFSNR=''  AND ZZ4.ZZ4_STATUS <> '9' " + ENTER
endif

if mv_par09 == 1 // Apenas formulario proprio
	_cFilFormul := " AND D1_FORMUL = 'S' " + ENTER
elseif mv_par09 == 2 // Apenas formulario nao proprio
	_cFilFormul := " AND D1_FORMUL <> 'S' " + ENTER
endif

_cqry += " SELECT * FROM (SELECT ROW_NUMBER() OVER (PARTITION BY ZZ4.ZZ4_FILIAL,ZZ4.ZZ4_NFENR,ZZ4.ZZ4_IMEI ORDER BY ZZ4.ZZ4_FILIAL,ZZ4.ZZ4_NFENR,ZZ4.ZZ4_IMEI) rowrank, " + ENTER
//_cqry += " SELECT ZZ4.ZZ4_CODPRO 'PRODUTO', " + ENTER
_cqry += " ZZ4.ZZ4_CODPRO 'PRODUTO', " + ENTER
If !alltrim(mv_par06) $ carmproc
	_cqry += CR + "         SD1.D1_LOCAL   'ARMAZEM', " + ENTER
Else
	_cqry += CR + "         SD1.D1_LOCAL   'ARM_ENTR' , " + ENTER
	_cqry += CR + "         '"+carmproc+"'   'ARM_PROC' , " + ENTER
	_cqry += CR + "         ARM_SAI='', " + ENTER
Endif
_cqry += CR + "        ZZ4.ZZ4_NFENR  'NFE'," + ENTER
//if mv_par11 == 3 // TODOS
_cqry += CR + "        ZZ4.ZZ4_NFESER 'SERIENF'," + ENTER
//endif
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	_cqry += CR + "        SD1.D1_FORMUL  'FORMUL'," + ENTER
endif
_cqry += CR + "        SD1.D1_EMISSAO 'EMISENT'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_DOCDTE 'ENTRDOCA'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_DOCHRE 'HORADOCA'," + ENTER
_cqry += CR + "        SAIDDOCA = CASE WHEN ZZ4.ZZ4_SWSADC <> '' THEN ZZ4.ZZ4_SWSADC WHEN ZZ4.ZZ4_DOCDTS <> '' THEN ZZ4.ZZ4_DOCDTS ELSE '' END," + ENTER
_cqry += CR + "        ZZ4.ZZ4_NFEDT  'ENTRADA'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_ULTSAI 'ULTSAIDA'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_BOUNCE 'BOUNCE'," + ENTER
_cqry += CR + "        SD1.D1_VUNIT   'VALUNIT'," + ENTER
//_cqry += CR + "        SD1.D1_QUANT	  'QUANT'," + ENTER
_cqry += CR + "        1	  'QUANT'," + ENTER  // M.Munhoz - 25/08/2011 -Forca quantidade igual a 1 (um) uma vez que o D1_QUANT passou a ser gravado com quantidade total de aparelhos de um determinado modelo.
_cqry += CR + "        ZZ4.ZZ4_GRPPRO 'GRUPO'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_CODCLI 'CLIENTE'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_LOJA   'LOJA'," + ENTER
_cqry += CR + "        SA1.A1_NREDUZ 'NOMEENT', " + ENTER
_cqry += CR + "        SA1.A1_EST 'ESTADO', " + ENTER
_cqry += CR + "        ZZ4.ZZ4_IMEI   'IMEI', " + ENTER
_cqry += CR + "        ZZ4.ZZ4_CARCAC 'CARCACA'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_PV     'PEDIDO'," + ENTER
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	_cqry += CR + "        NOMESAI  = SPACE(30)," + ENTER
endif
_cqry += CR + "        NFBGH = ZZ4.ZZ4_NFSNR + '/' + ZZ4.ZZ4_NFSSER," + ENTER
_cqry += CR + "        ZZ4.ZZ4_NFSDT  'EMISSAI'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_NFSTES 'TES'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_OS     'OS'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_NUMVEZ   'NUMVEZ'," + ENTER
_cqry += CR + "        LEFT(ZZ4.ZZ4_ATPRI,8) 'ENTRCHAM'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_FASMAX 'FASEMAX'," + ENTER
_cqry += CR + "        ZZ1_1.ZZ1_DESFA1 'DESFAMAX'," + ENTER
//_cqry += CR + "        FASE     = SPACE(06)," + ENTER
//_cqry += CR + "        DESCFASE = SPACE(30)," + ENTER
_cqry += CR + "        ZZ4.ZZ4_FASATU 'FASEATU'," + ENTER
_cqry += CR + "        ZZ1.ZZ1_DESFA1 'DESFAATU'," + ENTER
_cqry += CR + "        LEFT(ZZ4.ZZ4_ATULT,8) 'DTENCCHA'," + ENTER
_cqry += CR + "        HRENCCHA = CASE WHEN ZZ4.ZZ4_STATUS > '4' THEN SUBSTRING(ZZ4.ZZ4_ATULT,9,8) ELSE SPACE(8) END," + ENTER
_cqry += CR + "        STATUSOS = CASE WHEN ZZ4.ZZ4_STATUS > '4' THEN 'Encerrado' ELSE 'Aberto' END, " + ENTER
_cqry += CR + "        MOTDOCA  = SPACE(30)," + ENTER
_cqry += CR + "        SD1.D1_XLOTE   'LOTE'," + ENTER
_cqry += CR +  "       DEFCLIEN = CASE WHEN LEN(RTRIM(ZZ4.ZZ4_DEFINF))> 0 THEN ZZ4.ZZ4_DEFINF ELSE ZA_DEFRECL	END, " + ENTER
//_cqry += CR +  "       ZZ4.ZZ4_DEFINF  	'DEFCLIEN' ," + ENTER
_cqry += CR +  "       DESCDEFCL=  SPACE(50) ," + ENTER
_cqry += CR +  "       'DEFCONST'=	(SELECT  TOP 1 Z3.ZZ3_DEFDET FROM ZZ3020 Z3 (nolock) WHERE Z3.D_E_L_E_T_ = '' AND Z3.ZZ3_DEFDET != '' AND ZZ4.ZZ4_OS = Z3.ZZ3_NUMOS ORDER BY ZZ3_SEQ), " + ENTER
_cqry += CR +  "       'DEFCONST1' = (SELECT TOP 1 Z9.Z9_SYMPTO FROM SZ9020 Z9 (nolock) WHERE Z9.D_E_L_E_T_ = '' AND Z9.Z9_NUMOS =  ZZ4.ZZ4_OS AND Z9.Z9_SYMPTO != ''), " + ENTER
_cqry += CR +  "       	DESCDEFCO =	SPACE(50), " + ENTER
_cqry += CR +  "       'SOLCONST'=	(SELECT  TOP 1  Z3.ZZ3_ACAO   FROM ZZ3020 Z3 (nolock) WHERE Z3.D_E_L_E_T_ = '' AND Z3.ZZ3_ACAO	 != '' AND ZZ4.ZZ4_OS = Z3.ZZ3_NUMOS ORDER BY ZZ3_SEQ), " + ENTER
_cqry += CR +  "       'SOLCONST1' = (SELECT TOP 1 Z9.Z9_ACTION   FROM SZ9020 Z9 (nolock) WHERE Z9.D_E_L_E_T_ = '' AND Z9.Z9_NUMOS =  ZZ4.ZZ4_OS AND Z9.Z9_ACTION != ''), " + ENTER
_cqry += CR +  "       	DESCSOLCO =	SPACE(50), " + ENTER
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	_cqry += CR + "        ZZ4.ZZ4_SWAP   'NOVOSN'," + ENTER
	_cqry += CR + "        ZZ4.ZZ4_SWNFNR 'NFNOVOSN'," + ENTER
	_cqry += CR + "        ZZ4.ZZ4_SWNFDT 'DTNFNSN'," + ENTER
	_cqry += CR + "        ZZ4.ZZ4_SWSADC 'DTSAINSN'," + ENTER
endif
_cqry += CR + "        ZZ4.ZZ4_OPER   'TIPOENTR',"   + ENTER //Alterado o nome de Garantia para Tipo de entrada - Edson Rodrigues 23/06/10
_cqry += CR + "        ZZ4.ZZ4_OPEBGH   'OPERACBGH'," + ENTER //Incluso Esse campo - Edson Rodrigues 23/06/10
if mv_par11 = 1 // Nextel  -->
 _cqry += CR + "        ZZ4.ZZ4_GARANT   'GARANTIA'," + ENTER                                                
 _cqry += CR + "        ZZ4.ZZ4_GARMCL   'GARCLAIM'," + ENTER                                                
 _cqry += CR + "        ZZ4.ZZ4_OPEANT   'OPERAANTE'," + ENTER
 _cqry += CR + "        ZZ4.ZZ4_TRANSC   'TRANSAC', " + ENTER
 _cqry += CR + "        ISNULL(SZA.ZA_SPC,'')	SPC, " + ENTER
Endif
_cqry += CR + "        STATUS     = CASE WHEN ZZ4.ZZ4_STATUS = '1' THEN 'Entrada Apontada'" + ENTER
_cqry += CR + "                          WHEN ZZ4.ZZ4_STATUS = '2' THEN 'Entrada Confirmada' " + ENTER
_cqry += CR + "                          WHEN ZZ4.ZZ4_STATUS = '3' THEN 'NFE Gerada' " + ENTER
_cqry += CR + "                          WHEN ZZ4.ZZ4_STATUS = '4' THEN 'Em atendimento' " + ENTER
_cqry += CR + "                          WHEN ZZ4.ZZ4_STATUS = '5' THEN 'OS Encerrada' " + ENTER
_cqry += CR + "                          WHEN ZZ4.ZZ4_STATUS = '6' THEN 'Saida Lida' " + ENTER
_cqry += CR + "                          WHEN ZZ4.ZZ4_STATUS = '7' THEN 'Saida Apontada' " + ENTER
_cqry += CR + "                          WHEN ZZ4.ZZ4_STATUS = '8' THEN 'PV Gerado' " + ENTER
_cqry += CR + "                          WHEN ZZ4.ZZ4_STATUS = '9' THEN 'NFS Gerada' else '' END, " + ENTER
_cqry += CR + "        TEMPREP  = 0," + ENTER
_cqry += CR + "        SD1.D1_MOTDOCA 'CODMOTDOC'," + ENTER
_cqry += CR + "        SD1.D1_IDENTB6 'IDENTB6'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_NFSCLI 'CLISAI'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_NFSLOJ 'LOJSAI'," + ENTER
_cqry += CR + "        ZZ4.ZZ4_COR    'COR'" + ENTER
_cqry += CR + " FROM   "+retsqlname("ZZ4")+" AS ZZ4 (nolock) " + ENTER
_cqry += CR + " JOIN   "+retsqlname("SD1")+" AS SD1 (nolock) " + ENTER
If !alltrim(mv_par06) $ carmproc
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alterado por M.Munhoz em 16/08/2011 - Substituicao do D1_NUMSER por D1_ITEM. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	_cqry += CR + " ON     SD1.D_E_L_E_T_ = '' AND SD1.D1_FILIAL = ZZ4.ZZ4_FILIAL AND SD1.D1_NUMSER = ZZ4.ZZ4_IMEI AND " + ENTER
	_cqry += CR + " ON     SD1.D_E_L_E_T_ = '' AND SD1.D1_FILIAL = ZZ4.ZZ4_FILIAL AND SD1.D1_ITEM = ZZ4.ZZ4_ITEMD1 AND " + ENTER
	_cqry += CR + "        SD1.D1_DOC = ZZ4.ZZ4_NFENR AND SD1.D1_SERIE = ZZ4.ZZ4_NFESER AND SD1.D1_FORNECE = ZZ4.ZZ4_CODCLI AND SD1.D1_LOJA = ZZ4.ZZ4_LOJA" + ENTER
	_cqry += CR + " JOIN   "+retsqlname("SA1")+" AS SA1 (nolock) " + ENTER
	_cqry += CR + " ON     SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '"+xfilial("SA1")+"' AND SA1.A1_COD = ZZ4.ZZ4_CODCLI AND SA1.A1_LOJA = ZZ4.ZZ4_LOJA " + ENTER
	
ELSE
	_cqry += CR + " ON     SD1.D_E_L_E_T_ = '' AND SD1.D1_FILIAL = ZZ4.ZZ4_FILIAL AND " + ENTER
	_cqry += CR + "        SD1.D1_DOC = ZZ4.ZZ4_NFENR AND SD1.D1_SERIE = ZZ4.ZZ4_NFESER  AND SD1.D1_COD = ZZ4.ZZ4_CODPRO " + ENTER
	_cqry += CR + " JOIN   "+retsqlname("SA1")+" AS SA1 (nolock) " + ENTER
	_cqry += CR + " ON     SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '"+xfilial("SA1")+"' AND SA1.A1_COD = ZZ4.ZZ4_CODCLI AND SA1.A1_LOJA = ZZ4.ZZ4_LOJA " + ENTER
Endif 
_cqry += CR + " LEFT JOIN "+retsqlname("ZZ3")+" AS ZZ3 (nolock) " + ENTER
_cqry += CR + " ON     ZZ3.ZZ3_NUMOS = ZZ4.ZZ4_OS AND ZZ3.ZZ3_FILIAL = ZZ4.ZZ4_FILIAL " + ENTER
_cqry += CR + " LEFT JOIN " +RetSqlName("SZA") + " SZA (nolock) " + ENTER
_cqry += CR + " ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI " + ENTER
_cqry += CR + " AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_) " + ENTER
_cqry += CR + " LEFT JOIN   "+retsqlname("ZZ1")+" AS ZZ1 (nolock) " + ENTER
_cqry += CR + " ON     ZZ1.D_E_L_E_T_ = '' AND ZZ1.ZZ1_FILIAL = '  ' AND ZZ1.ZZ1_LAB = ZZ3.ZZ3_LAB AND ZZ1.ZZ1_FASE1 = ZZ4.ZZ4_FASATU AND ZZ1.ZZ1_CODSET = ZZ4.ZZ4_SETATU " + ENTER
_cqry += CR + " LEFT JOIN   "+retsqlname("ZZ1")+" AS ZZ1_1 (nolock) " + ENTER
_cqry += CR + " ON     ZZ1_1.D_E_L_E_T_ = '' AND ZZ1_1.ZZ1_FILIAL = '  ' AND ZZ1_1.ZZ1_LAB = ZZ3.ZZ3_LAB AND ZZ1_1.ZZ1_FASE1 = ZZ4.ZZ4_FASMAX AND ZZ1_1.ZZ1_CODSET = ZZ4.ZZ4_SETMAX " + ENTER
_cqry += CR + " WHERE  ZZ4.D_E_L_E_T_ = ''" + ENTER
_cqry += CR + "        AND ZZ4.ZZ4_FILIAL = '"+xfilial("ZZ4")+"'" + ENTER
_cqry += CR + "        AND ZZ4.ZZ4_NFEDT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' " + ENTER
If !alltrim(mv_par06) $ carmproc
	_cqry += CR + "        AND '"+alltrim(mv_par06)+"' LIKE '%'+SD1.D1_LOCAL+'%'" + ENTER
	_cqry += CR + "        AND SD1.D1_TIPO = 'B' " + ENTER
ELSE
	_cqry += CR + "        AND '"+alltrim(mv_par06)+"' LIKE '%'+SD1.D1_LOCAL+'%'" + ENTER
	_cqry += CR + "        AND ZZ4.ZZ4_OPEBGH='S03' " + ENTER
	_cqry += CR + "        AND SD1.D1_TIPO = 'N' " + ENTER
ENDIF
_cqry += CR + _cFilCliente
_cqry += CR + _cFilStatus
_cqry += CR + _cFilFormul
_cqry += CR + ") temp_a WHERE rowrank <= 1 " + ENTER
_cqry += CR + " ORDER BY IMEI" + ENTER

_cqry := strtran(_cqry,CR,"")

if select("TRB2") > 0
	TRB2->(dbclosearea())
endif
if select("TRB1") > 0
	TRB1->(dbclosearea())
endif

If lbat
	ConOut(" Processando Query Cycletime "+_center) 
Endif

MemoWrite("D:\cycletime_Motorrola.sql", _cqry)
TCQUERY _cqry NEW ALIAS "TRB2"                   

If lbat
	ConOut(" Query cycletime Processsada"+_center) 
	ConOut(" Criando tabela temporaria e inserindo dados filtrados pela query............"+_center)
Endif

/*
TcSetField("TRB2","ENTRDOCA" ,"C",8)
TcSetField("TRB2","SAIDDOCA" ,"C",8)
TcSetField("TRB2","ENTRADA"  ,"C",8)
TcSetField("TRB2","EMISSAI"  ,"C",8)
TcSetField("TRB2","DTENCCHA" ,"C",8)
TcSetField("TRB2","ENRTCHAM" ,"C",8)
TcSetField("TRB2","EMISENT"  ,"C",8)
TcSetField("TRB2","ULTSAIDA" ,"C",8)
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	TcSetField("TRB2","DTNFNSN"  ,"C")
	TcSetField("TRB2","DTSAINSN" ,"C")
endif
*/

dbselectarea("TRB2")
_carqcycle := criatrab(,.f.)
Copy To &(_carqcycle)  //VIA "DBFCDXADS"
dbUseArea(.t.,,_carqcycle,"TRB1",.t.,.f.)
TRB1->(dbgotop())                                          
If lbat
ConOut("...tabela temporaria criada com sucesso"+_center)
endif
return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcriacsv   บAutor  ณEdson Rodrigues     บ Data ณ  27/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao statica para criacao do arquiivo csv                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function criacsv(cDirDocs,cArq)

nHandle := MsfCreate(cDirDocs+"\"+cArq+".CSV",0)     

cLinha := ''
cLinha += 'PRODUTO' 			+ ';'
cLinha += 'DESCR_PRODUTO'   	+ ';'
If !alltrim(mv_par06) $ carmproc
	cLinha += 'ARMAZEM' + ';'
Else
	cLinha += 'ARM_ENTR' + ';'
	cLinha += 'ARM_PROC' + ';'
	cLinha += 'ARM_SAI' + ';'
Endif
cLinha += 'NFE' 			+ ';'
cLinha += 'SERIENF' 			+ ';'
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	cLinha += 'FORMUL' + ';'
endif
cLinha += 'EMISENT' 			+ ';'
cLinha += 'ENTRDOC' 			+ ';'
cLinha += 'HORADOCA' 			+ ';'
cLinha += 'SAIDDOCA' 			+ ';'
cLinha += 'ENTRADA' 			+ ';'
cLinha += 'ULTSAIDA' 			+ ';'
cLinha += 'BOUNCE' 			+ ';'
cLinha += 'VALUNIT' 			+ ';'
cLinha += 'QUANT' 			+ ';'
cLinha += 'GRUPO' 			+ ';'
cLinha += 'CLIENTE' 			+ ';'
cLinha += 'LOJA' 			+ ';'
cLinha += 'NOMEENT' 			+ ';'
cLinha += 'ESTADO' 			+ ';'
cLinha += 'IMEI' 			+ ';'
cLinha += 'CARCACA' 			+ ';'
cLinha += 'PEDIDO' 			+ ';'
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	cLinha += 'NOMESAI' + ';'
endif
cLinha += 'NFBGH' 			+ ';'
cLinha += 'EMISSAI' 			+ ';'
cLinha += 'TES' 			+ ';'
cLinha += 'OS' 			+ ';'          
cLinha += 'NUMVEZ' 			+ ';'          
cLinha += 'ENTRCHAM' 			+ ';'
cLinha += 'FASEMAX' 			+ ';'
cLinha += 'DESFAMAX' 			+ ';'
cLinha += 'FASEATU' 			+ ';'
cLinha += 'DESFAATU' 			+ ';'
cLinha += 'DTENCCHA' 			+ ';'
cLinha += 'HRENCCHA' 			+ ';'
cLinha += 'STATUSOS' 			+ ';'
cLinha += 'MOTDOCA' 			+ ';'
cLinha += 'LOTE' 			+ ';'
cLinha += 'DEFCLIEN' 			+ ';'
cLinha += 'DESCDEFCL' 			+ ';'
cLinha += 'DEFCONST'			+ ';'
cLinha += 'DESCDEFCO'			+ ';'
cLinha += 'SOLCONST'			+ ';'
cLinha += 'DESCSOLCO'			+ ';'
if mv_par11 <> 1 // Sony ou outros (diferente de Nextel)
	cLinha +=  'NOVOSN'   + ';'
	cLinha +=  'NFNOVOSN' + ';'
	cLinha +=  'DTNFNSN'  + ';'
	cLinha +=  'DTSAINSN' + ';'
endif
cLinha += 'TIPO_ENTRADA' 		+ ';'
cLinha += 'OPERACAO_BGH'	+ ';'
if mv_par11 = 1 //  Nextel 
  cLinha += 'OPERAANT_BGH'	+ ';'
  cLinha += 'TRANSACTION'	+ ';' 
  cLinha += 'GARANTIA'		+ ';'
  cLinha += 'GARCLAIM'		+ ';'  
  cLinha += 'SPC'			+ ';'
  
Endif
cLinha += 'STATUS' 			+ ';'
cLinha += 'TEMPREP' 			+ ';'
cLinha += 'CODMOTDOC' 			+ ';'
cLinha += 'IDENTB6' 			+ ';'
cLinha += 'CLISAI' 			+ ';'
cLinha += 'LOJSAI' 			+ ';'
cLinha += 'COR' 			+ ';'
fWrite(nHandle, cLinha  + cCrLf)

return
