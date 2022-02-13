#INCLUDE 'RWMAKE.CH'
#DEFINE OPEN_FILE_ERROR -1


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECA002  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para importar a planilha Excel do cliente para a  บฑฑ
ฑฑบ          ณ tabela SZA do Protheus.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function TECA002()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa็ใo de Planilha Excel"
Local cDesc1  := "Este programa executa a importa็ใo da planilha Excel para o arquivo SZA"
Local cDesc2  := "permitindo sua valida็ใo junto เ Entrada Massiva da NF do cliente."

Private cPerg    := padr("TECA02",10)
Private _amens   := {}
Private _acampos := {}
Private _adados  := {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Cliente                             ณ
//ณmv_par02 - Loja                                ณ
//ณmv_par03 - Nota Fiscal                         ณ
//ณmv_par04 - Serie                               ณ
//ณmv_par05 - Emissao NF                          ณ
//ณmv_par06 - Codigo Produto                      ณ
//ณmv_par07 - Preco Unitario                      ณ
//ณmv_par08 - Operacao                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

u_GerA0003(ProcName())

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
ฑฑบPrograma  ณ RUNPROC  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que executa a importacao da planilha Excel do       บฑฑ
ฑฑบ          ณ cliente para a tabela SZA.                                 บฑฑ
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

ZZG->(dbSetOrder(1))                       
SZA->(dbSetOrder(1))
SA1->(dbSetOrder(1))  // A1_FILIAL + A1_COD
SB1->(dbSetOrder(1))  //B1_FILIAL + B1_COD 
ZZJ->(dbSetOrder(1))  //ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB 


//Incluso para validar operacao digitada pelo usuario - edson Rodrigues - 17-08-10
If 	empty(mv_par08)
	ApMsgInfo("Favor informar a operacao.","Operacao Invalida")
    Return                                    
Endif    
If !ZZJ->(dbSeek(xFilial("ZZJ") + mv_par08))
   	ApMsgInfo("operacao nao cadastrada. Cadastre ou informe uma opera็ใo vแlida.","Operacao Invalida")
    Return                                    
Endif
//Incluso para validar c๓digo do produto digitado pelo usuario - Vinicius Leonardo - 30-07-2014
If !('-U' $ UPPER(mv_par06))
	ApMsgInfo("Codigo Produto informado sem '-U'.Favor informar.","Operacao Invalida")
    Return                                    
Endif              



// Verifica se ja existe registros no SZA para os parametros informados
if SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par03 + mv_par04))
	if ApMsgYesNos("Jแ existem IMEI's importados para esta NF. Deseja importแ-los novamente? ","Nota Fiscal jแ importada")
       IF ApMsgYesNos("Deseja apagar os arquivos jแ importados ? ","Nota Fiscal jแ importada")	
		  while SZA->(!eof()) .and. SZA->ZA_FILIAL == xFilial("SZA") .and. SZA->ZA_CLIENTE == mv_par01 .and. SZA->ZA_LOJA == mv_par02 .and. ; 
		      ALLTRIM(SZA->ZA_NFISCAL) == ALLTRIM(mv_par03) .and. SZA->ZA_SERIE == mv_par04
			RecLock("SZA",.f.)
			dbDelete()
			MsUnlock()
			SZA->(dbSkip())
		  enddo
		else             
			// Claudia 25/01/201 - verifica se ja importou o produto e nใo deixa importar novamente, conf. solicitado por Carlos Rocha.
			while SZA->(!eof()) .and. SZA->ZA_FILIAL == xFilial("SZA") .and. SZA->ZA_CLIENTE == mv_par01 .and. SZA->ZA_LOJA == mv_par02 .and. ; 
			      ALLTRIM(SZA->ZA_NFISCAL) == ALLTRIM(mv_par03) .and. SZA->ZA_SERIE == mv_par04   
			      If SZA->ZA_CODPRO = MV_PAR06        
			      	ApMSgInfo("Esse produto ja foi importado. A rotina sera abortada!","Arquivo Nao importado")
			      	Return
			      EndIf
				SZA->(dbSkip())
		  	enddo		  
	   ENDIF	  
	else
		ApMsgInfo("Voc๊ optou por nใo importar o arquivo novamente. O programa serแ interrompido agora.","Arquivo nใo importado")
		Return
	endif
endif 

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

IF Len(_adados) > 0  
   for x:=1 to 	Len(_adados)
      If LEN(_aCampos) = 1         
        reclock("EXC",.t.)
          EXC->IMEI:=_adados[x][1]
        msunlock()  
      Else                 
         reclock("EXC",.t.)    
           EXC->IMEI  :=_adados[x][1]
           EXC->RECCLI:=_adados[x][2]          
         msunlock()     
      Endif
   Next
Else
  	return
Endif

EXC->(dbGoTop())

_nCnt := EXC->(RecCount())
procregua(_nCnt)

while EXC->(!eof())
    //Incluso Edson Rodrigues - 01/03/10 para validar e gravar o c๓digo de Reclama็ใo do Cliente Nextel                                              
    lRecCli := Iif(EXC->(FIELDPOS("RECCLI")) > 0, .T.,.F.)
    lpassou:=.T.
	IncProc("Processando IMEI: " + EXC->IMEI)

   //Incluso Edson Rodrigues - 01/03/10 para validar e gravar o c๓digo de Reclama็ใo do Cliente Nextel 
	if !SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par03 + mv_par04 + EXC->IMEI)) .and. !empty(EXC->IMEI)
	 //  IF MV_PAR08=="N01"  .AND. lRecCli  .AND.  !EMPTY(EXC->RECCLI)       
         If  _cinftcm = "S" .AND. lRecCli  .AND.  !EMPTY(EXC->RECCLI)       
            IF !ZZG->(dbSeek(xFilial("ZZG") + '2' + SUBSTR(EXC->RECCLI,1,5))) 
                 lpassou:=.f.
                 AADD(_amens,{EXC->IMEI,EXC->RECCLI,"C๓digo Recl.Cliente nใo Cadastrado","Cadastre e importe o IMEI novamente"})    
            ENDIF        
         ENDIF             
       
         
         // Acrescentado validacoes abaixo - Edson Rodrigues - 21/07/10
         //Faz verificaao se o cliente digitado existe no cadastro de clientes
   	     if !SA1->(dbSeek(xFilial("SA1") + mv_par01+mv_par02))
              ApMsgInfo("C๓digo Cliente : "+mv_par01+"/"+mv_par02+" Nใo cadastrado. Favor Cadastrar esse Cliente. ")
              lpassou:=.f.
         endif
                                                                           
         //Faz verificaao se o produto digitado existe no cadastro de clientes
   	     If !SB1->(dbSeek(xFilial("SB1") + mv_par06))
      	  ApMsgInfo("C๓digo : "+mv_par06+" Nใo cadastrado. Favor Cadastrar esse Produto. ")
          lpassou:=.f.
         Else
       	    If SB1->B1_LOCALIZ=="S"
      	         ApMsgInfo("C๓digo : "+mv_par06+" esta configurado como * Ultiliza Endere็o *. Favor tirar essa opcao no Cadastro de Produto.")
      		     lpassou:=.f.
            ENDIF               
            If SB1->B1_RASTRO $ ("LS")
      	   	    ApMsgInfo("C๓digo : "+mv_par06+" esta configurado como * Ultiliza Lote *. Favor tirar essa opcao no Cadastro de Produto.")
      	        lpassou:=.f.
            ENDIF        
         Endif

       

       IF lpassou
	   
			reclock("SZA",.t.)
	    	SZA->ZA_FILIAL  := xFilial("SZA")
		    SZA->ZA_CLIENTE := mv_par01
		    SZA->ZA_LOJA    := mv_par02
		    SZA->ZA_NFISCAL := mv_par03
		    SZA->ZA_SERIE   := mv_par04
		    SZA->ZA_EMISSAO := mv_par05
		    SZA->ZA_CODPRO  := mv_par06
		    SZA->ZA_PRECO   := mv_par07
		    SZA->ZA_DATA    := dDataBase
		    SZA->ZA_IMEI    := EXC->IMEI
		    SZA->ZA_STATUS  := "N"
            SZA->ZA_DEFRECL := IIf(lRecCli,SUBSTR(EXC->RECCLI,1,5),"") 
            SZA->ZA_OPERBGH := _coper
		    msunlock()
	   	   _nRegImp++
	   	ENDIF   
	endif

	EXC->(dbSkip())

enddo

if _nRegImp > 0
	ApMsgInfo("Foram importados " + alltrim(str(_nRegImp)) + " IMEI's.")

    //Incluso Edson Rodrigues - 01/03/10 para gerar relat๓rio com c๓digos de Reclama็ใo do Cliente Nextel nใo cadastrados.
    if len(_amens) > 0
       ApMsgInfo("Houve problema na importa็ใo. Cod. Recl. Cliente Nใo Cadastrado. Imprima o Relat. e fa็a as devidas corre็๕es !.")
           	U_tecrx037(_amens)
	       _amens:={}
    Endif 

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
	   cIMEI := cReccli := ""
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
	              AAdd(_aCampos,{alltrim(ccampo),'C',TAMSX3("ZA_IMEI")[1],0})
	              x:=nDivi-1
	              nDivi:=nDivi+1
	              xBuffer  := Substr(xBuffer , nDivi)
	            Else
	             ccampo := Substr(alltrim(xBuffer),1)
	             AAdd(_aCampos,{alltrim(ccampo),'C',TAMSX3("ZA_DEFRECL")[1],0})
	            Endif
	          Next
	      Else     
	         ccampo:=Substr(alltrim(xBuffer),1)
	         AAdd(_aCampos,{alltrim(ccampo),'C',TAMSX3("ZA_IMEI")[1],0})
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
PutSX1(cPerg,"01","Cliente 				?","Cliente 			?","Cliente 			?","mv_ch1","C",06,0,0,"G","","SA1"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Loja 				?","Loja 				?","Loja 				?","mv_ch2","C",02,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Nr. Nota Fiscal 		?","Nr. Nota Fiscal 	?","Nr. Nota Fiscal 	?","mv_ch3","C",09,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Serie NF 			?","Serie NF 			?","Serie NF 			?","mv_ch4","C",03,0,0,"G","",""		,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Emissao NF 			?","Emissao NF 			?","Emissao NF 			?","mv_ch5","D",08,0,0,"G","",""		,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","C๓digo Produto 		?","C๓digo Produto 		?","C๓digo Produto 		?","mv_ch6","C",15,0,0,"G","","SB1"	,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Pre็o Unitแrio 		?","Pre็o Unitแrio 		?","Pre็o Unitแrio 		?","mv_ch7","N",12,2,0,"G","",""		,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Opera็ใo 			?","Opera็ใo 			?","Opera็ใo 			?","mv_ch8","C",03,0,0,"G","","ZZJ"	,"",,"mv_par08","","","","","","","","","","","","","","","","")

Return Nil
