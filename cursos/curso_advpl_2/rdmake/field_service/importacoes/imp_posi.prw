#INCLUDE 'RWMAKE.CH'               
#DEFINE OPEN_FILE_ERROR -1  

/*
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : IMP_POSI					| 			Junho de 2012								  					|
|-------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																				|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descri��o : Importa��o de Arquivo da Positivo para tabela SZP											  	|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
*/

user function IMP_POSI()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa��o de Planilha CSV"
Local cDesc1  := "Este programa executa a importa��o da planilha Excel da Positivo para a tabela SZP"

u_GerA0003(ProcName())

//�����������������������������������������������Ŀ
//�mv_par01 - Cliente                             �
//�mv_par02 - Loja                                �
//�mv_par03 - Nota Fiscal                         �
//�mv_par04 - Serie                               �
//�mv_par05 - Operacao                            �
//�������������������������������������������������

aAdd( aSay, cDesc1 )

aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando Planilha CSV", .T. )

Return Nil

/*
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : RunProc						| 			Junho de 2012								  					|
|-------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																				|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descri��o : Seleciona o arquivo e faz a importa��o															  	|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
*/
Static Function RunProc(lEnd)

local _nRegImp   := 0
local _cNomeArq  := ""
Local aDirectory := ""
Local _coper     := Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par01,"ZZJ_OPERA")
Local _calment   := Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par01,"ZZJ_ARMENT")

PswOrder(1)
PswSeek(__cUserID)
_apswdet2 := PswRet(2)
_usrrelat := _aPswDet2[1,3] // diret�rio da pasta relato
cPath := StrTran(alltrim(_usrrelat), "\", "/" )

aDirectory := Directory (cPath + "*.*")    // Tipo de arquivo   

_cTipo := "Arquivo Cliente (*.CSV)    | *.CSV | "
_cExcelCSV := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
If Empty(_cExcelCSV)                         
	Aviso("Cancelada a Sele��o!","Voce cancelou a sele��o do arquivo.",{"Ok"})
	Return
Endif
if !file(_cExcelCSV)
	return
endif       

_clocalArq := alltrim(_cExcelCSV)
_nPos     := rat("\",_clocalArq)
if _nPos > 0
	_cNomeArq := substr(_clocalArq,_nPos+1,len(_clocalArq)-_nPos)
endif

cFile :=   cPath + alltrim(_cNomeArq)

If FT_FUSE( cfile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " nao encontrado!")   
	Return
Endif                                                         	

ProcRegua( FT_FLASTREC() )

dbSelectArea("SZP")
dbSetOrder(3)

FT_FSKIP()      // para pular a linha do cabe�alho
While !FT_FEOF()             
	xBuffer := FT_FREADLN()
	            
	IncProc()                   
	_aDados := {}
	_aDados := strtokarr(xBuffer, ';')
                                                                                      
    if len(_aDados) > 0
	//    if ! dbSeek(xFilial("SZP")+_aDados[1]+_aDados[3])
		   	reclock("SZP",.T.)
		  	SZP->ZP_FILIAL 	:= xFilial("SZP")
		  	SZP->ZP_NUMSER 	:= _aDados[1]
		  	SZP->ZP_ACESS01	:= _aDados[2]
		    
		    _cTipo := ''
			if   upper(substr(_aDados[3],1,4))  == "FORA"
				_cTipo	:= 'FOG'
			elseif  upper(substr(_aDados[3],1,4)) == "PASS"
				_cTipo	:= 'DEV'
			else
				_cTipo := _aDados[3]
			endif	
		  	SZP->ZP_CONDREP	:= _cTipo
		
			msunlock()
			_nRegImp++
	//	endif
	endif		
	FT_FSKIP()
EndDo

if _nRegImp > 0
    ConfirmSx8() 
	ApMsgInfo("Foram importados " + alltrim(str(_nRegImp)) + " IMEI's.")
else
	ApMsgInfo("Nenhum IMEI foi importado. Verificar o arquivo selecionado para importa��o. ")
endif

Return                   

