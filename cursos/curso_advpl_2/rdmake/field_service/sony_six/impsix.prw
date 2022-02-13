#INCLUDE 'RWMAKE.CH'
#DEFINE OPEN_FILE_ERROR -1


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPSIX   บAutor  ณEdson Rodrigues     บ Data ณ  10/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para importar da planilha Excel do SIX para a     บฑฑ
ฑฑบ          ณ tabela SZA do Protheus.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function IMPSIX()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa็ใo de Planilha Excel"
Local cDesc1  := "Este programa executa a importa็ใo da planilha Excel SIX "
Local cDesc2  := "para o arquivo SZA microsiga."

Private cPerg    := padr("IMPSIX",10)
Private _amens   := {}
Private _acampos := {}
Private _adados  := {}

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Tipo : OS SIX / Pedido Pe็as  SIX   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando Planilha Excel", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RUNPROC  บAutor  ณEdson Rodrigues     บ Data ณ  10/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que executa a importacao da planilha Excel do       บฑฑ
ฑฑบ          ณ SIX para a tabela SZA.                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

local _aAreaSZA  := SZA->(GetArea())
local _nCnt      := 0
local _nRegImp   := 0
local _cNomeArq  := ""  
Local cPath      := "/IMPIMEI/"						// Local de gera็ใo do arquivo
Local aDirectory := Directory (cPath + "*.*")      // Tipo de arquivo a serem excluidos              
Local _cinftcm   := Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par08,"ZZJ_INFTCM")     
Local _coper     := Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par08,"ZZJ_OPERA")


SZA->(dbSetOrder(1))
ZZJ->(dbSetOrder(1))  //ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB 
ZZ4->(dbSetOrder(11)) //ZZ4_FILIAL + ZZ4_OS + ZZ4_IMEI 3
ZZS->(dbSetOrder(1))  //ZZS_FILIAL + ZZS_OSBGH + ZZS_PEDSIX 



// Fecha o arquivo temporario caso esteja aberto
if select("EXC") > 0
	EXC->(dbCloseArea())
endif

 // Apaga Arquivos .DBF da pasta   -- Paulo Lopez - 12/03/10
//aEval(aDirectory, {|x| FErase(cPath + x[1])}) 

// Abre o arquivo DBF gerado pelo Excel do cliente
_cTipo := "Arquivo Cliente (*.CSV)    | *.CSV | "
_cExcelDBF := cGetFile(_cTipo,"Selecione o arquivo a ser importado") 
If Empty(_cExcelDBF)
	Aviso("Cancelada a Sele็ใo!","Voce cancelou a sele็ใo do arquivo.",{"Ok"})
	Return
Endif
if !file(_cExcelDBF)
	return
else 

	CpyT2S(_cExcelDBF,cPath)
endif

_clocalArq := alltrim(_cExcelDBF)                    
_cNomeArq := alltrim(_cExcelDBF)
_nPos     := rat("\",_cNomeArq)
if _nPos > 0
	_cNomeArq := substr(_cNomeArq,_nPos+1,len(_cNomeArq)-_nPos)
endif                

cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

__CopyFile(_clocalArq, cRootPath + cPath + alltrim(_cNomeArq))
cFile :=  cPath + alltrim(_cNomeArq)
LPrim := .T.

//dbUseArea(.t.,"",cPath+_cNomeArq,"EXC",.f.,.f.)

ARQDADOS(cFile)

If Len(_aCampos) > 0
   _cArqSeq := CriaTrab(_aCampos)
   dbUseArea(.T.,,_cArqSeq,"EXC",.T.,.F.)
Else
  	return
Endif

IF MV_PAR01 == 1
  IF Len(_adados) > 0  
     for x:=1 to 	Len(_adados)

         reclock("EXC",.t.)    
           EXC->OSSIX  :=_adados[x][1]
           EXC->OSBGH  :=_adados[x][2]          
         msunlock()     
      Next
  Else
  	return
  Endif
ELSE
  IF Len(_adados) > 0  
     for x:=1 to 	Len(_adados)
         reclock("EXC",.t.)    
           EXC->PEDSIX  :=_adados[x][1]
           EXC->OSBGH   :=_adados[x][2]          
         msunlock()     
      Next
  Else
  	return
  Endif
ENDIF



EXC->(dbGoTop())

_nCnt := EXC->(RecCount())
procregua(_nCnt)

while EXC->(!eof())
    //Incluso Edson Rodrigues - 01/03/10 para validar e gravar o c๓digo de Reclama็ใo do Cliente Nextel                                              
    lospedsix := Iif(EXC->(FIELDPOS("OSSIX")) > 0 .or. EXC->(FIELDPOS("PEDSIX")) > 0 , .T.,.F.)
    lpassou:=.T.      
        
	IncProc("Processando OS BGH : " + EXC->OSBGH)
    
                                           
	IF ZZ4->(dbSeek(xFilial("ZZ4") + EXC->OSBGH)) .AND. lospedsix 
	  
	   IF MV_PAR01 == 1 
	   
			// Ticket 4988 - Duplicidade SZA - M.Munhoz. Nova pesquisa para nao utilizar SERIE ja q muitas vezes este campo eh informado errado.
			_aAreaSZA2 := SZA->(getarea())
			SZA->(dbSetOrder(4)) // ZA_FILIAL + ZA_IMEI + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_STATUS
			//IF !SZA->(dbSeek(xFilial("SZA") + left(ZZ4->ZZ4_IMEI,15) + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_NFENR)) 
			IF !SZA->(dbSeek(xFilial("SZA") + ZZ4->ZZ4_IMEI + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_NFENR)) 
        	//IF !SZA->(dbSeek(xFilial("SZA") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_IMEI)) 
			   reclock("SZA",.T.)
	    	    SZA->ZA_FILIAL  := xFilial("SZA")
		        SZA->ZA_CLIENTE := ZZ4->ZZ4_CODCLI
		        SZA->ZA_LOJA    := ZZ4->ZZ4_LOJA
		        SZA->ZA_NFISCAL := ZZ4->ZZ4_NFENR
		        SZA->ZA_SERIE   := ZZ4->ZZ4_NFESER
		        SZA->ZA_EMISSAO := ZZ4->ZZ4_EMDT
		        SZA->ZA_CODPRO  := ZZ4->ZZ4_CODPRO
		        SZA->ZA_PRECO   := ZZ4->ZZ4_VLRUNI
		        SZA->ZA_DATA    := dDataBase
		        SZA->ZA_IMEI    := ZZ4->ZZ4_IMEI
    		    SZA->ZA_STATUS  := "V"
                SZA->ZA_OPERBGH := ZZ4->ZZ4_OPEBGH
                SZA->ZA_OSAUTOR := EXC->OSSIX
		       msunlock()
	   	       _nRegImp++
	   	    ELSE
               reclock("SZA",.F.)
                SZA->ZA_OSAUTOR := EXC->OSSIX
		        SZA->ZA_SERIE   := ZZ4->ZZ4_NFESER
		        SZA->ZA_CODPRO  := ZZ4->ZZ4_CODPRO
		       msunlock()
	   	    
	   	       reclock("ZZ4",.F.)
                ZZ4->ZZ4_OSAUTO := EXC->OSSIX
		       msunlock()
	   	      _nRegImp++	   	    
	   	    
	   	    ENDIF   
	   	    restarea(_aAreaSZA2)
	   ELSE
	      IF ZZS->(dbSeek(xFilial("ZZS") + EXC->OSBGH + EXC->PEDSIX )) 
	            lpassou:=.F.      
          ENDIF
            
          IF lpassou	   
		     reclock("ZZS",.T.)                  
     	        ZZS->ZZS_FILIAL  := xFilial("ZZS")
                ZZS->ZZS_OSBGH   := EXC->OSBGH
                ZZS->ZZS_PEDSIX  := EXC->PEDSIX
		     msunlock()
    	   	_nRegImp++
	      ENDIF
	   ENDIF

    ENDIF
    EXC->(dbSkip())
enddo

if _nRegImp > 0
	ApMsgInfo("Foram importados " + alltrim(str(_nRegImp)) + " OS's.")

else
	ApMsgInfo("Nenhum IMEI foi importado. Verificar o arquivo selecionado para importa็ใo. ")
endif

EXC->(dbCloseArea())
RestArea(_aAreaSZA)
Return           



STATIC FUNCTION ARQDADOS(cFile)

If FT_FUSE( cfile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " nao encontrado!")
	Return
Else
    lPrim    := .f.
    nlinha   := 0
    nDivi    := 0
    nultdiv  := 0
     
    While !FT_FEOF()
	   cOSBGH := cOSSIX := cPEDSIX := ""
	   lPass :=.t.
	   nlinha++
	   
	   if nlinha==1 
	      //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ-------------------
	      //ณ L primeira linha - cabelho do arquivo retorno ณ
	      //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ-------------------ู
	      xBuffer := FT_FREADLN()            
	      nultdiv := rat(";",xBuffer)
	        
	      If nultdiv > 0
	         
	          For x:=1 to nultdiv
	           
	            nDivi   := At(";",xBuffer)
	           
	            If nDivi > 0
	              ccampo := Substr( xBuffer , 1, nDivi - 1)
                  IF MV_PAR01 == 1
	                 AAdd(_aCampos,{'OSSIX','C',TAMSX3("ZA_OSAUTOR")[1],0})
	              ELSE
                     AAdd(_aCampos,{'PEDSIX','C',TAMSX3("ZZS_PEDSIX")[1],0})	               
	              ENDIF       
	              x:=nDivi-1
	              nDivi:=nDivi+1
	              xBuffer  := Substr(xBuffer , nDivi)
	            Else
	             ccampo := Substr(alltrim(xBuffer),1)
	             AAdd(_aCampos,{'OSBGH','C',TAMSX3("ZZ4_OS")[1],0})
	            Endif
	          Next
	      Else     
	         ccampo:=Substr(alltrim(xBuffer),1)
             IF MV_PAR01 == 1
	                 AAdd(_aCampos,{'OSSIX','C',TAMSX3("ZA_OSAUTOR")[1],0})
             ELSE
                     AAdd(_aCampos,{'PEDSIX','C',TAMSX3("ZZS_PEDSIX")[1],0})	               
             ENDIF       
	      Endif    
	   Else   
          //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ---------------------------
	      //ณ L segunda linha ate ao fim - dados do arquivo retorno ณ
	      //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ---------------------------ู
	      xBuffer := FT_FREADLN()            
	      nultdiv := rat(";",xBuffer)
	        
	      If  nultdiv > 0
	      
	          For X:=1 to nultdiv
	           
	             nDivi   := At(";",xBuffer)
	           
	             If nDivi > 0  //.and. X > nultdiv
	              	cCampo:='ccampo'+STRZERO(X,2)
	                &cCampo:=Substr( xBuffer , 1, nDivi - 1)
	                AAdd(_adados,{&cCampo,''}) 
	                X:=nDivi-1
	                nDivi:=nDivi+1
	                xBuffer  := Substr(xBuffer , nDivi)
	              ELse
                    _nPosimei  := Ascan(_adados,{ |x| x[1] == &cCampo})
                    cCampo:='ccampo'+STRZERO(X,2)
	                &cCampo:=Substr(alltrim(xBuffer),1)
	                _adados[_nPosimei][2]:=&cCampo
	              Endif
	          Next                   
	      Else 
              nDivi   := At(";",xBuffer)
	          cCampo:='ccampo01'
	          &cCampo:=Substr(alltrim(xBuffer),1)
	          AAdd(_adados,{ccampo01})
	      
	      Endif
	     
	   Endif   
	   FT_FSKIP()
    EndDo
Endif      
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Imp. arquivo tipo ? "    ,"Imp. arquivo tipo ? "		,"Imp. arquivo tipo ? "	  ,"mv_ch1","N",01,0,0,"C","",""	,"",,"mv_par01","OS SIX"	,"OS SIX","OS SIX","","PEDIDO SIX"	,"PEDIDO SIX","PEDIDO SIX",""	,"","","","","","","","")

Return Nil
