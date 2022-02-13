#INCLUDE 'RWMAKE.CH'               
#DEFINE OPEN_FILE_ERROR -1  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DIGITINV บAutor  ณE.Rodrigues - BGH   บ Data ณ  1812/08    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para importar o arquivo CSV de digitacao de Inven-บฑฑ
ฑฑบ          ณ tario.                                                     บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function DIGITINV()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa็ใo de Planilha CSV"
Local cDesc1  := "Este programa executa a importa็ใo da planilha Excel de "
Local cDesc2  := "Digitacao do Inventario BGH."

Private cPerg := "DIGINV"

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Documento                           ณ
//ณmv_par02 - Inventario em                       ณ
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

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando Planilha CSV", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RUNPROC  บAutor  ณE.Rodrigues         บ Data ณ  18/12/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que executa a importacao da planilha Excel da       บฑฑ
ฑฑบ          ณ digitacao do Inventario.                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

local _aAreaSB7 := SB7->(GetArea())
local _aAreaSB2 := SB2->(GetArea())
local _aAreaSB1 := SB1->(GetArea())
local _nCnt     := 0
local _nRegImp  := 0
local _cNomeArq := ""
Local cproduto  := Space(15)        
Local nqtde     := 0
Local ccontg    := "001"
Local cescolh   := "S"
Local cok       := "1"
Local cdocum    := ALLTRIM(MV_PAR01)
Local ddatinv   := MV_PAR02
Local ctipmat   := Space(2) 
Local cdescpro  := Space(30)
Local carmaz    := Space(2)
Local clote     := Space(10)
Local csublot   := Space(6)
Local clocaliz  := Space(15)            
Local cPath     := "/temp/"
Local cDrive, cDir, cNome, cExt
//

SB7->(dbSetOrder(1)) //B7_FILIAL+B7_DATA+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE 
SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
SB1->(dbSetOrder(1)) //B1_FILIAL + B1_COD
SBE->(dbsetorder(1)) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
SB8->(dbsetorder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+B8_DTVALID 

// Abre o arquivo DBF gerado pelo Excel do cliente
_cTipo := "Arquivo Cliente (*.CSV)    | *.CSV | "
_cExcelCSV := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
If Empty(_cExcelCSV)                         
	Aviso("Cancelada a Sele็ใo!","Voce cancelou a sele็ใo do arquivo.",{"Ok"})
	Return
Endif
if !file(_cExcelCSV)
	return
Endif


CpyT2S(_cExcelCSV,cPath,.F.)

SplitPath( _cExcelCSV, @cDrive, @cDir, @cNome, @cExt )
_cNomeArq := cPath+cNome+cExt
     
If FT_FUSE( _cNomeArq ) = OPEN_FILE_ERROR
	MSGINFO("Ocorreu um problema na c๓pia do arquivo: " + _cNomeArq + " para o servidor! Importa็ใo nใo concluํda.")   
	Return
Endif                                                         	

ProcRegua( FT_FLASTREC() )

While !FT_FEOF()             
    lPass   := .t.       
          
    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	 //ณ L linha do arquivo retorno ณ
	 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	xBuffer := FT_FREADLN()
	
	IncProc()                   
	/* PRODUTO */
	nDivi   := At(";",xBuffer)
	cproduto:= Substr( xBuffer , 1, nDivi - 1)    
	
	/* TIPO PRODUTO */
	ctipmat   := Posicione("SB1",1,xFilial("SB1")+cproduto,"B1_TIPO")
    
    /* DESCRICAO PRODUTO */
    cdescpro  := Posicione("SB1",1,xFilial("SB1")+cproduto,"B1_DESC")     
                     
    /* ARMAZEM */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	carmaz   := Substr(xBuffer,1,  nDivi - 1)
                        
    /* ENDERECO */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	clocaliz := Substr(xBuffer,1,  nDivi - 1)  
	
	 /* LOTE */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	clote    := Substr(xBuffer,1,  nDivi - 1)
    
		/* QTDE */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	//nqtde     :=Val(xBuffer) 
	nqtde := Val(STRTRAN(xBuffer,",","."))   
	            
	dbSelectarea("SB7") //B7_FILIAL+B7_DATA+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE     
	If !SB7->(dbSeek(xFilial("SB7") + DTOS(ddatinv) + cproduto + carmaz + clocaliz + clote)) 
        
        
      //Faz verificaao se o produto digitado existe no cadastro de produto   
   	  dbSelectarea("SB1")
   	  If !SB1->(dbSeek(xFilial("SB1") + cproduto))
      	  ApMsgInfo("C๓digo : "+cproduto+" Nใo cadastrado. Favor Cadastrar esse Produto. ")
          lPass := .f.
      Else   
         // Acrescentado validacoes abaixo - Edson Rodrigues - 02/07/10
          ccontend  := SB1->B1_LOCALIZ  // Controla endereco S=SIM/N=NAO
          crastro   := SB1->B1_RASTRO   // Rastro S=SUBLOTE / L=LOTE
          
          // Verifica se o produto controla lote e tem lote valido   
          IF crastro $ "SL"
			 dbselectarea("SB8")
			 IF !empty(clote)        
			     _cnewcod:=alltrim(cproduto)+Space(15-len(alltrim(cproduto)))
			     _cnewlot:=alltrim(clote)+Space(10-len(alltrim(clote)))
			     IF !SB8->(DBSeek(xFilial('SB8')+_cnewcod+carmaz+_cnewlot))  
                     ApMsgInfo("Lote : "+clote+ " nao existe para o produto : "+cproduto+" no armazem :"+carmaz+". Digitacao invalida do lote. ")
                     lPass := .f.
                 Endif
             Else           
                 IF crastro = "S"
                      ApMsgInfo("Esse produto : "+cproduto+" / armazem :"+carmaz+" controla sublote, digite o lote/sublote no arquivo de importacao. Lote/Sublote nao digitado ")
                 ELSE
                      ApMsgInfo("Esse produto : "+cproduto+" / armazem :"+carmaz+" controla lote, digite o lote no arquivo de importacao. Lote nao digitado ")
                 ENDIF     
                 lPass := .f.
             Endif
          Endif
          
          IF  ccontend = "S"    
            dbselectarea("SBE")
            IF !empty(clocaliz)
                IF !SBE->(DbSeek(XFilial("SBE")+ carmaz+clocaliz))
                    ApMsgInfo("Endereco : "+clocaliz+ " nao existe para o produto : "+cproduto+" no armazem :"+carmaz+". Digitacao invalida do Endereco. ")
                    lPass := .f.
                ENDIF 
            ELSE
                ApMsgInfo("Esse produto : "+cproduto+" / armazem :"+carmaz+" controla endereco, digite o endereco no arquivo de importacao. Endereco nao digitado ")
                lPass := .f.
            ENDIF 
          Endif    
          
          If  crastro $ "SL" .and. ccontend <> "S" .and. !empty(clocaliz)  //Verifica se controla lote e nao controla endere็o e se tem endereco preenchido
              ApMsgInfo("Esse produto : "+cproduto+" / armazem :"+carmaz+" nao controla endereco e tem o endereco digitado : "+alltrim(clocaliz)+" no arquivo de importacao. O sistema nao vai cadastrar esse Endereco ")
              clocaliz:=space(15)
          Elseif  ccontend = "S"  .and. !crastro $ "SL" .and. !empty(clote)  //Verifica se controla Endereco e nao controla lote e se tem lote preenchido  
              ApMsgInfo("Esse produto : "+cproduto+" / armazem :"+carmaz+" nao controla Lote/Sublote e tem o Lote/Sublote digitado : "+alltrim(clote)+" no arquivo de importacao. O sistema nao vai cadastrar esse lote ")
              clote:=space(10)                                
          Elseif  !crastro $ "SL"  .and. !empty(clote)  //Verifica se nao controla Lote e tem lote preenchido             
              ApMsgInfo("Esse produto : "+cproduto+" / armazem :"+carmaz+" nao controla Lote/Sublote e tem o Lote/Sublote digitado : "+alltrim(clote)+" no arquivo de importacao. O sistema nao vai cadastrar esse lote ")
              clote:=space(10)                                
          Elseif  ccontend <> "S"  .and. !empty(clocaliz)  //Verifica se nao controla Endereco tem endereco preenchido  
              ApMsgInfo("Esse produto : "+cproduto+" / armazem :"+carmaz+" nao controla endereco e tem o endereco digitado : "+alltrim(clocaliz)+" no arquivo de importacao. O sistema nao vai cadastrar esse Endereco ")
              clocaliz:=space(15)                                
          Endif


   	      //
          If  lPass 
            dbSelectArea("SB7")
		    RecLock("SB7",.T.) 
		      SB7->B7_FILIAL  := xFilial("SB7")
	          SB7->B7_COD     := cproduto
		      SB7->B7_TIPO    := ctipmat
		      SB7->B7_LOCAL   := carmaz
		      SB7->B7_DOC     := cdocum
		      SB7->B7_QUANT   := nqtde
		      SB7->B7_DATA    := ddatinv
		      SB7->B7_DTVALID := ddatabase
		      SB7->B7_LOTECTL	:= clote
		      SB7->B7_LOCALIZ	:= clocaliz  
		      SB7->B7_CONTAGE := ccontg 
              SB7->B7_ESCOLHA := cescolh
              SB7->B7_OK      := cok  
            SB7->(MSUnLock())
            _nRegImp++
	      Endif  
	  Endif
	
	Else
     	ApMsgInfo("O produto : "+cproduto+"/"+carmaz+"/"+clocaliz+"/"+dtoc(ddatinv)+" ja foi cadastrado. Favor verificar.")
		FT_FSKIP()
	endif

	FT_FSKIP()
EndDo

if _nRegImp > 0                                                       
	ApMsgInfo("Foram cadastrados: " + alltrim(str(_nRegImp)) + " Produtos/Armazens/Enderecos/Lotes.")
else
	ApMsgInfo("Nenhum Produtos/Armazens/Enderecos/Lotes foi cadastrado. Verifique o arquivo selecionado para importa็ใo.")
endif                                                         

// Fecha o arquivo e apaga
// Carlos Rocha - 18/Maio/2010
FT_FUSE()
FErase(_cNomeArq)
// Fim - CR

RestArea(_aAreaSB7)
RestArea(_aAreaSB2)
RestArea(_aAreaSB1)

Return                   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณE.Rodrigues         บ Data ณ  18/12/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Documento ?"       	,"Documento ?"       		,"Documento"       		,"mv_ch1","C",06,0,0,"G","",""	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Inventario em :"		,"Inventario em :"			,"Inventario em :"   	,"mv_ch2","D",08,0,0,"G","",""	,"",,"mv_par02","","","","","","","","","","","","","","","","")
Return Nil