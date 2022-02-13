#INCLUDE 'RWMAKE.CH'               
#DEFINE OPEN_FILE_ERROR -1  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ INTERIR2 บAutor  ณE.Rodrigues - BGH   บ Data ณ  23/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para importar o arquivo CSV    Integracao IRL paraบฑฑ
ฑฑบ          ณ a tabela SZA do Protheus.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function INTERIR2()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa็ใo de Planilha CSV"
Local cDesc1  := "Este programa executa a importa็ใo da planilha Excel para o arquivo SZA"
Local cDesc2  := "permitindo sua valida็ใo junto เ Entrada Massiva da NF do cliente."

Private cPerg := "INTIRL"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Cliente                             ณ
//ณmv_par02 - Loja                                ณ
//ณmv_par03 - Nota Fiscal                         ณ
//ณmv_par04 - Serie                               ณ
//ณmv_par05 - Operacao                            ณ
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
EndIf

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando Planilha CSV", .T. )

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
local _aAreaSA1  := SA1->(GetArea())
local _aAreaSB1  := SB1->(GetArea())
local _nCnt      := 0
local _nRegImp   := 0
local _cNomeArq  := ""
Local cNumOS     := Space(10)
Local ddataOS    := Date()   
Local cCodPost   := Space(10)
Local cProdFab   := Space(20)
Local cImei      := space(TamSX3("ZZ4_IMEI")[1])//Space(20)
Local cOpecel    := Space(30)
Local clocaten   := Space(10)
Local cCodcob    := Space(20)
Local cCodProc   := Space(10)
Local cDatfab    := Space(04)
Local ctpserv    := Space(20)
Local cnatend    := Space(10)
Local cNFentr    := Space(10)
Local dDtNfcp    := Date()          
Local cNReven    :=	Space(50)
Local cCompra    := Space(10)
Local nVal	     := 0
Local dtrecpro	 := Date()          
Local cDefrec    := Space(255)
Local cNome      := Space(50)
Local cCpfCnpj   := Space(18)
Local cRgIe      := Space(18)
Local cLogra	 := Space(20)
Local cEnder	 := Space(60)
Local cCompl	 := Space(40)
Local cBair      := Space(30)
Local cCidad	 := Space(40)
Local cCodUf     := Space(3)
Local cCEP	     := Space(9)
Local cDDD1	     := Space(10)
Local cTel1  	 := Space(15)
Local cDDD2      := Space(10)
Local cTel2  	 := Space(15)
Local cDDD3	     := Space(10)
Local cTel3	     := Space(15)
Local cEmail	 := Space(64)
Local cContat	 := Space(64)
Local cCodic     := ""
Local cempres    := ""
Local cLOCAL     := Space(2)
Local nqtde      := 0
local _aCliente  := {}
local _aDados    := {}
Local cPath      := "/IMPIMEI/"          		    // Local de gera็ใo do arquivo
Local aDirectory := Directory (cPath + "*.*")    // Tipo de arquivo   
Local _coper     := Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par05,"ZZJ_OPERA")
Local _calment   := Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par05,"ZZJ_ARMENT")

SZA->(dbSetOrder(1))  
SA1->(dbSetOrder(1))  // A1_FILIAL + A1_COD
SB1->(dbSetOrder(1))  //B1_FILIAL + B1_COD 
ZZJ->(dbSetOrder(1))  //ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB 


//Incluso para validar operacao digitada pelo usuario - edson Rodrigues - 17-08-10
If 	empty(mv_par05)
	ApMsgInfo("Favor informar a operacao.","Operacao Invalida")
    Return                                    
EndIf    
If !ZZJ->(dbSeek(xFilial("ZZJ") + mv_par05))
   	ApMsgInfo("operacao nao cadastrada. Cadastre ou informe uma opera็ใo vแlida.","Operacao Invalida")
    Return                                    
Else
   ZZJ->(dbSeek(xFilial("ZZJ") + mv_par05))
   IF ZZJ->ZZJ_BLOQ="S"
   	    ApMsgInfo("Operacao Bloqueada.","Operacao Invalida")
        Return                                    
   EndIf   
EndIf


// Verifica se ja existe registros no SZA para os parametros informados
if !empty(mv_par03) .and. SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par03 + mv_par04))

	if ApMsgYesNos("Jแ existem IMEI's importados para esta NF. Deseja importแ-los novamente? ","Nota Fiscal jแ importada")
		while SZA->(!eof()) .and. SZA->ZA_FILIAL == xFilial("SZA") .and. SZA->ZA_CLIENTE == mv_par01 .and. SZA->ZA_LOJA == mv_par02 .and. ; 
		      SZA->ZA_NFISCAL == mv_par03 .and. SZA->ZA_SERIE == mv_par04
			RecLock("SZA",.f.)
			dbDelete()
			MsUnlock()
			SZA->(dbSkip())
		enddo
	else
		ApMsgInfo("Voc๊ optou por nใo importar o arquivo novamente. O programa serแ interrompido agora.","Arquivo nใo importado")
		Return
	EndIf 
	
EndIf
// Fecha o arquivo temporario caso esteja aberto
if select("EXC") > 0
	EXC->(dbCloseArea())
EndIf

// Apaga Arquivos .DBF da pasta   -- Paulo Lopez - 12/03/10
//aEval(aDirectory, {|x| FErase(cPath + "*.csv"+ x[1])}) 

// Abre o arquivo DBF gerado pelo Excel do cliente
_cTipo := "Arquivo Cliente (*.CSV)    | *.CSV | "
_cExcelCSV := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
If Empty(_cExcelCSV)                         
	Aviso("Cancelada a Sele็ใo!","Voce cancelou a sele็ใo do arquivo.",{"Ok"})
	Return
EndIf
if !file(_cExcelCSV)
	return
else
	CpyT2S(_cExcelCSV,cPath)
EndIf       

_clocalArq := alltrim(_cExcelCSV)
_nPos     := rat("\",_clocalArq)
if _nPos > 0
	_cNomeArq := substr(_clocalArq,_nPos+1,len(_clocalArq)-_nPos)
EndIf

cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )  
__CopyFile(_clocalArq, cRootPath + cPath + alltrim(_cNomeArq))                
cFile :=   cPath + alltrim(_cNomeArq)
LPrim := .T.



If FT_FUSE( cfile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " nao encontrado!")   
	Return
EndIf                                                         	

ProcRegua( FT_FLASTREC() )

clotirl := GetSx8Num("SZA","ZA_LOTEIRL")     
ConfirmSX8()

cLocal := _calment 

While !FT_FEOF()             
    lPass   := .t.                      
    cNome := cCpfCnpj := cRgIe := cLogra := cEnder := cCompl := cBair := cCidad := cCodUf := cCEP :=  cDDD1 := ""
    cTel1 := cDDD2 := cTel2 := cDDD3 := cTel3 := cEmail := cContat := ""
	lMsErroAuto := .F. 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ L linha do arquivo retorno ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	xBuffer := FT_FREADLN()
	
	IncProc()                   
	
   	/* SEQ */
	nDivi   := At(";",xBuffer)
	cSEQ    := Substr( xBuffer , 1, nDivi - 1)
	If len(alltrim(cNumOS)) < 3
		cSEQ := Replicate("0", 3-(len(alltrim(cSEQ)))) + alltrim(cSEQ)
	EndIf	
	
	/* Numero chave / Controle */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cchave   := Substr( xBuffer , 1, nDivi - 1)
	If len(alltrim(cchave)) < 10
		cchave := Replicate("0", 10-(len(alltrim(cchave)))) + alltrim(cchave)
	EndIf
	
	/* Numero OS */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)

	cNumOS := Substr( xBuffer , 1, nDivi - 1)
	If Len(alltrim(cNumOS)) < 10
		cNumOS := Replicate("0", 10-(len(alltrim(cNumOS)))) + alltrim(cNumOS)
	EndIf
	
	/* Data da OS */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	ddataOS  := Ctod(Substr(xBuffer,1,  nDivi - 1))
	
	/* C๓digo Posto */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCodPost := Substr(xBuffer,1,  nDivi - 1)

	/* Codigo modelo */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cmodel    := Substr(xBuffer,1,  nDivi - 1)
	
	/* Codigo Produto junto ao Fabricante */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cProdFab := Substr(xBuffer,1,  nDivi - 1)
	
    /* Codigo IMEI */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cImei    := Substr(xBuffer,1,  nDivi - 1)
	
	/* Operadora Celular */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cOpecel  := Substr(xBuffer,1,  nDivi - 1)

	/* Local Atendimento */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	clocaten := Substr(xBuffer,1,  nDivi - 1)
	
	/* Codigo Cobertura */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCodCob  := Substr(xBuffer,1,  nDivi - 1)
	
	/* Codigo Procedencia */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCodProc := Substr(xBuffer,1,  nDivi - 1)
	
	/* Data da Fabricacao MMAA */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cDatfab  := Substr(xBuffer,1,  nDivi - 1)
	If len(alltrim(cDatfab)) < 4
		cDatfab := Replicate("0", 4-(len(alltrim(cDatfab)))) + alltrim(cDatfab)
	EndIf                                      
		
	/* Codigo tipo de Servico */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	ctpserv  := Substr(xBuffer,1,  nDivi - 1)
	
	/* Nome do Atendente */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cnatend  := Substr(xBuffer,1,  nDivi - 1)
	
	/* NF Compra */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCompra  := Substr(xBuffer,1,  nDivi - 1)
	
	/* Data da NF Compra */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	ddtNfcp  := Ctod(Substr(xBuffer,1,  nDivi - 1))
	
	/* Nome do Revendedor */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cnreven  := Substr(xBuffer,1,  nDivi - 1)
	
	/* NF Remessa */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cnfreme  := AllTrim(Substr(xBuffer,1,  nDivi - 1))

   	// Carlos Rocha - 17/05/2010
	// Ajusta o tamanho da NF com 6 ou 9 posi็๕es
	// Retirado, pois estava dando problema - Edson Rodrigues - 06/06/10
	// alterado, pois estava dando problema - Edson Rodrigues - 06/06/10
	If !Empty(cnfreme)
	    if Len(cnfreme) < 6 
		    cnfreme := PadL(cnfreme,6,"0")
		EndIf    
	EndIf	
	
	/* AWB */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cawb  := Substr(xBuffer,1,  nDivi - 1)
	
	/*Data Recebimento do Produto */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	dtrecpro := Ctod(Substr(xBuffer,1,  nDivi - 1))
	
	/* Valor do aparelho na NF */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	nVal     :=Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))
	
	/* Defeito Reclamado */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cDefrec  := Substr(xBuffer,1,  nDivi - 1)
	
	/* Sintoma Codificado */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	csincod  := Substr(xBuffer,1,  nDivi - 1)
	
	
	/* Nome do Cliente */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cNome    := Substr(xBuffer,1,  nDivi - 1)
	
	/* CNPJ / CPF */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCpfCnpj := Substr(xBuffer,1,  nDivi - 1)
	
	/* RG / Inscr Estadual */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cRgIe    := Substr(xBuffer,1,  nDivi - 1)
	cRgIe    :=IIF(Substr(cRgIe,1,1)="'","0"+alltrim(substr(cRgIe,2,13)),cRgIe)
	
	/* Logradouro */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cLogra   := Substr(xBuffer,1,  nDivi - 1)
	
	/* Endereco */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cEnder   := Substr(xBuffer,1,  nDivi - 1)
	
	/* Complemento */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCompl   := Substr(xBuffer,1,  nDivi - 1)
	
	/* Bairro */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cBair    := Substr(xBuffer,1,  nDivi - 1)
	
	/* Cidade */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCidad   := Substr(xBuffer,1,  nDivi - 1)
	
	/* UF */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCodUf   := Substr(xBuffer,1,  nDivi - 1)
	
	/* cCEP */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cCEP     := Substr(xBuffer,1,  nDivi - 1)
	cCEP     :=IIF(Substr(cCEP,1,1)="'","0"+alltrim(substr(cCEP,2,7)),cCEP)
	
	/* DDD 1 */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cDDD1   := Substr(xBuffer,1,  nDivi - 1)
	
	/* telefone 1 */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cTel1   := Substr(xBuffer,1,  nDivi - 1)
	
	/* DDD 2 */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cDDD2   := Substr(xBuffer,1,  nDivi - 1)
	
	/* telefone 2 */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cTel2   := Substr(xBuffer,1,  nDivi - 1)
	
	/* DDD 3 */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cDDD3   := Substr(xBuffer,1,  nDivi - 1)
	
	/* telefone 3 */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cTel3   := Substr(xBuffer,1,  nDivi - 1)
	
	/* Email */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cEmail   := Substr(xBuffer,1,  nDivi - 1)
	
	/* Contato */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cContat   := Substr(xBuffer,1,  nDivi - 1)
                                              
    /* logradouro de Entrega  */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	clogentr := Substr(xBuffer,1,  nDivi - 1)

    /* Endereco de Entrega  */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cEndentr := Substr(xBuffer,1,  nDivi - 1)
	
	/* Complemento de Entrega  */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	ccompent := Substr(xBuffer,1,  nDivi - 1)
	
	/* Bairro de Entrega  */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cbairent := Substr(xBuffer,1,  nDivi - 1)

	/* Cidade de Entrega  */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	ccidentr := Substr(xBuffer,1,  nDivi - 1)

	/* UF de Entrega  */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cufentre := Substr(xBuffer,1,  nDivi - 1)

	/* CEP de Entrega  */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	ccepentr := Substr(xBuffer,1,  nDivi - 1)


	/* Fast Track   */
	xBuffer  := Substr(xBuffer , nDivi+1)
	nDivi    := At(";",xBuffer)
	cfastrac := Substr(xBuffer,1,  nDivi - 1)

	
	/* DPY */
	/*
	nDivi   := At(";",xBuffer)
	cProdFab:= Substr( xBuffer , 1, nDivi - 1)
	*/
	
	
	/* QTDE */
	/*
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	nqtde     :=Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	*/
	
	/* Codigo IMEI */                        
	/*
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cImei    := Substr(xBuffer,1,  nDivi - 1)
    */                 

	
	/* Condicao */
	/*
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cCodic := Substr(xBuffer,1,  nDivi - 1)
    */
	
	/* Operadora Celular */
	/*
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cOpecel  := Substr(xBuffer,1,  nDivi - 1)
	*/
		
	
	/* Numero OS */
	/*
	xBuffer  := Substr(xBuffer , nDivi+1)   
	nDivi    := At(";",xBuffer) 
	cNumOS := Substr( xBuffer , 1, nDivi - 1)
	If len(alltrim(cNumOS)) < 10
		cNumOS := Replicate("0", 10-(len(alltrim(cNumOS)))) + alltrim(cNumOS)
	EndIf	
    */
    
    
    
    /* HVC */
    /*
    xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cempres := Substr(xBuffer,1,  nDivi - 1)
	*/
	
	/* NF Remessa */	
	/*
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cnfreme  := AllTrim(Substr(xBuffer,1,  nDivi - 1))
	*/
	
	// Carlos Rocha - 17/05/2010
	// Ajusta o tamanho da NF com 6 ou 9 posi็๕es	
	// alterado, pois estava dando problema - Edson Rodrigues - 06/06/10
	/*
	If !Empty(cnfreme)
	    if Len(cnfreme) < 6 
		    cnfreme := PadL(cnfreme,6,"0")
		EndIf    
	EndIf
	*/
	// Fim - CR	                                 

	/* Valor do aparelho na NF */
	/*
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	nVal     :=Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	*/
	
	/*Data Recebimento do Produto */
	/*
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
    dtrecpro := Ctod(xBuffer)
    */                                
                                    
      
	/* Data da OS */	
	/*
	ddataOS  := ddatabase
	*/
    
    /* C๓digo Posto */
	/*
	cCodPost := "4067"
	*/
	
	
	/* SEQ */
	/*
	cSEQ    := " "                   
    */
        
	
	/* Local Atendimento */
	/*
	clocaten := "UPS"
	*/
	
	                               
    /* Codigo Cobertura */
	/*
	cCodCob  := " "
	*/
	                        
	/* Codigo Procedencia */
	/*
	cCodProc := " "
	*/
	
	/* Data da Fabricacao MMAA */	
	/*
	cDatfab := " "
    */
	                        
	/* Codigo tipo de Servico */
	/*
	ctpserv  := ""
	*/  
	
	/* Nome do Atendente */
	/*
	cnatend  := ""
	*/
	  
    /* NF Compra */
	/*
	cCompra  := ""
	*/
	  
    /* Data da NF Compra */	
	/*
	ddtNfcp  := Ctod("")
	*/
	
    /* Nome do Revendedor */
	/*
	cnreven  := ""                        
	*/
	
    /* AWB */
	/*
	cawb  := ""
	*/
	  
	
   	/* Defeito Reclamado */
	/*
	cDefrec  := ""
    */
    
    If !SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + cnfreme + mv_par04 + cImei)) .and. !empty(cImei)
        
     // Faz verificaao se a nota e igual a que esta vindo no arquivo
      If !EMPTY(MV_PAR03) .AND. alltrim(mv_par03)<>alltrim(cnfreme)
        ApMsgInfo("Nota Fiscal Digitada : "+alltrim(mv_par03)+"/"+mv_par04+" Nใo ้ igual a nota descriminada no arquivo. Favor verificar. ")
         lPass := .f.
      EndIf                                                         
      
      //Faz verificaao se o cliente digitado existe no cadastro de clientes
   	  if !SA1->(dbSeek(xFilial("SA1") + mv_par01+mv_par02))
         ApMsgInfo("C๓digo Cliente : "+mv_par01+"/"+mv_par02+" Nใo cadastrado. Favor Cadastrar esse Cliente. ")
         lPass := .f.
      EndIf
                                                                           
      //Faz verificaao se o produto digitado existe no cadastro de clientes
   	  if !SB1->(dbSeek(xFilial("SB1") + cProdFab))
      	  ApMsgInfo("C๓digo : "+cProdFab+" Nใo cadastrado. Favor Cadastrar esse Produto. ")
          lPass := .f.
      Else
       	If SB1->B1_LOCALIZ=="S"
      	     ApMsgInfo("C๓digo : "+cProdFab+" esta configurado como * Ultiliza Endere็o *. Favor tirar essa opcao no Cadastro de Produto.")
      		     lPass := .f.
        EndIf               
        If SB1->B1_RASTRO $ ("LS")
      	   	 ApMsgInfo("C๓digo : "+cProdFab+" esta configurado como * Ultiliza Lote *. Favor tirar essa opcao no Cadastro de Produto.")
      	     lPass := .f.
        EndIf        
      EndIf
      	
     if  lPass 
    	reclock("SZA",.T.)
		  	SZA->ZA_FILIAL  := xFilial("SZA")
		  	SZA->ZA_CLIENTE := mv_par01
		  	SZA->ZA_LOJA    := mv_par02
		  	SZA->ZA_NFISCAL := cnfreme
		  	SZA->ZA_SERIE   := mv_par04
		  	SZA->ZA_EMISSAO := dtrecpro
		  	SZA->ZA_CODPRO  := cProdFab
		  	SZA->ZA_PRECO   := nVal
		  	SZA->ZA_DATA    := dDataBase
		  	SZA->ZA_IMEI    := cImei
		  	SZA->ZA_STATUS  := "N"  
		  	SZA->ZA_OSGVS   := cNumOS
        	SZA->ZA_DTOSGVS := ddataOS
        	SZA->ZA_HROSGVS := ""                  
			SZA->ZA_CODATEN := cCodPost
	        SZA->ZA_CODPOST := "7474"
    	    SZA->ZA_CODPROD := cmodel
        	SZA->ZA_CODDPY  := cProdFab
	        SZA->ZA_NOMEOPE := cOpecel
    	    SZA->ZA_LOCATEN := clocaten
        	SZA->ZA_CODCOBE := ccodcob 
	        SZA->ZA_CODPROC := cCodProc
    	    SZA->ZA_CODTPSE := ctpserv
        	SZA->ZA_DTFABRI := cDatfab
	        SZA->ZA_NOMEATE := cnatend              
    	    SZA->ZA_NFCOMPR := cCompra 
        	SZA->ZA_DTNFCOM := ddtNfcp	    		
	        SZA->ZA_VALNFCO := nVal
    	    SZA->ZA_NOMEREV := cnreven         
        	SZA->ZA_DEFCONS := u_TiraAcento(alltrim(cDefrec))
	        SZA->ZA_DTRECPR := dtrecpro 
    	    SZA->ZA_HRRECPR := ""	    		
//        	SZA->ZA_MARCA   := IIF(_coper = "SO5","SONY MOBILE","SONY ERICSSON")
        	SZA->ZA_MARCA   := AvKey(Alltrim(Posicione("ZZJ",1,xFilial("ZZJ")+_coper,"ZZJ_DESCRI")),"ZA_MARCA")
    	    SZA->ZA_LOCAL   := cLocal             
        	SZA->ZA_CHAVGVS := cchave
        	SZA->ZA_LOTEIRL := clotirl         
        	SZA->ZA_SINTCOD := csincod
    	    SZA->ZA_OPERBGH := _coper             
        msunlock()
		_nRegImp++
	 EndIf 
	  
	Else
	
	//ApMsgInfo("A Nota Fiscal : "+mv_par03+"/"+mv_par04+" Jแ foi lida para esse cliente. Favor verificar. ")
		//if  lPass
		reclock("SZA",.F.)
		SZA->ZA_FILIAL  := xFilial("SZA")
		SZA->ZA_CODPRO  := cProdFab
		SZA->ZA_OSGVS   := cNumOS
		SZA->ZA_DTOSGVS := ddataOS
		SZA->ZA_HROSGVS := ""
		SZA->ZA_CODPOST := "7474"
		SZA->ZA_CODATEN := cCodPost
		SZA->ZA_CODPROD := cmodel
		SZA->ZA_CODDPY  := cProdFab
		SZA->ZA_NOMEOPE  := cOpecel
		SZA->ZA_LOCATEN  := clocaten
		SZA->ZA_CODCOBE := ccodcob
		SZA->ZA_CODPROC := cCodProc
		SZA->ZA_CODTPSE := ctpserv
		SZA->ZA_DTFABRI := cDatfab
		SZA->ZA_NOMEATE := cnatend
		SZA->ZA_NFCOMPR := cCompra
		SZA->ZA_DTNFCOM := ddtNfcp
		SZA->ZA_VALNFCO := nVal
		SZA->ZA_NOMEREV := cnreven
		SZA->ZA_DEFCONS := u_TiraAcento(alltrim(cDefrec))
		SZA->ZA_HRRECPR := ""
//		SZA->ZA_MARCA   := IIF(_coper = "SO5","SONY MOBILE","SONY ERICSSON")
       	SZA->ZA_MARCA   := AvKey(Alltrim(Posicione("ZZJ",1,xFilial("ZZJ")+_coper,"ZZJ_DESCRI")),"ZA_MARCA")
		SZA->ZA_CHAVGVS := cchave
		SZA->ZA_SINTCOD := csincod
		SZA->ZA_OPERBGH :=_coper
		msunlock()
		_nRegImp++
	
	EndIf

	FT_FSKIP()
EndDo

if _nRegImp > 0
    ConfirmSx8() 
	ApMsgInfo("Foram importados " + alltrim(str(_nRegImp)) + " IMEI's.")
else
	ApMsgInfo("Nenhum IMEI foi importado. Verificar o arquivo selecionado para importa็ใo. ")
EndIf

RestArea(_aAreaSZA)
RestArea(_aAreaSA1)
RestArea(_aAreaSB1)

Return                   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGVS001    บAutor  ณMicrosiga           บ Data ณ  10/22/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function gvscadcli(aVetor,_nOpc)

lMsErroAuto := .F.

MSExecAuto({|x,y| Mata030(x,y)},aVetor,_nOpc) //Inclusao

If lMsErroAuto
	A:=1
	RollBackSXE()
Else
	ConfirmSX8()
EndIf

return(!lMsErroAuto)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ACHADDD  บAutor  ณMicrosiga           บ Data ณ  19/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para encontrar o DDD correspondente ao Estado /     บฑฑ
ฑฑบ          ณ Municipio do cliente                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
   EndIf   
EndIf    

restarea(_aAreaSZb)

return(_cAchaDDD)




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
PutSX1(cPerg,"01","Cliente ?"       	,"Cliente ?"       		,"Cliente ?"       		,"mv_ch1","C",06,0,0,"G","","SA1"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Loja ?"					,"Loja ?"					,"Loja ?"					,"mv_ch2","C",02,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Nr. Nota Fiscal ? "	,"Nr. Nota Fiscal ? "	,"Nr. Nota Fiscal ? "	,"mv_ch3","C",09,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Serie NF ?"			,"Serie NF ?"				,"Serie NF ?"				,"mv_ch4","C",03,0,0,"G","",""		,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Operacao ?"		   ,"Operacao ?"				,"Operacao ?"				,"mv_ch5","C",03,0,0,"G","","ZZJ"	,"",,"mv_par05","","","","","","","","","","","","","","","","")
Return Nil