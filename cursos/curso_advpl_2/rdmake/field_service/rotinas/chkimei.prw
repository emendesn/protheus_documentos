#Include "PROTHEUS.CH"
#include 'topconn.ch'

/*
Funcao para fazer a validacao do IMEI - codigo original abaixo (em JAVA)
Claudia Cabral 13/01/2009
*/
User Function ChkImei(cImei)
Local lRet   := .T.        
Local nL     := 15
Local nMul   := 2 
Local nSum   := 0
Local nMax   := 0
Local cDigit := ''
Local ntp    := 0 
Local nChk   := 0                              
Local i      := 0
Local lRF := .f.
Local nVal := 0                   
Local aSaveArea := GetArea()   

u_GerA0003(ProcName())

// Ticket 5983 - Rodrigo Salomao - Bloquear IMEI SWAP com mais ou menos de 15 digitos apenas para a Nextel
nMax := len(alltrim(cImei))
If upper(alltrim(funname())) == "AXZZ3" .and. !empty(cImei) .and. LAB == '2' .and. nMax <> 15 
	apMsgStop('O IMEI deve possuir 15 digitos. Código inválido.','IMEI inválido')
	Return .f.
Endif

   

IF Upper(Left(cIMEI,2)) $ "RF/IT"   
	lRf := .t.   // flag para não fazer o algoritimo do IMEI para os codigos que comecam com  EF
	cIMEI := SUBSTRING(cIMEI,3,13)
	
	If Val(alltrim(cImei)) < 10000 // Carlos Rocha Solicitou para retornar sempre verdadeiro
		Return .t.
	Endif	

	nChk := U_GDVan(SUBSTRING(cIMEI,3,12)) // Algoritmo do EAN

	If Val(nChk) != Val(Substring(cImei,13,1))  
		lRet := .F.
	Endif		
		
Else // RETIRAR DEPOIS, QUANDO FOR VALIDAR TODOS OS IMEIS 
 	// CONFORME DETERMINADO POR CARLOS SEMPRE  RETORNAR VERDADEIRO POR ENQUANTO, PARA VALIDR SOMENTE OS IMEIS QUE COMECAM COM "RF" 19/01/2010
	RETURN .T.	
Endif

If lRet .and. ! lRF // Valida inicio do IMEI
	nVal := Val(Substring(cImei,1,2))
// 00 até 09 (inclusive)
	If nVal <> 10 .and. nVal <> 30 .and.  nVal < 0 .and. ! nVal <= 9 .and. nVal <> 33 .and. nVal <> 35 .and. nVal <> 44 .and. nval <> 45 .and. nVal <> 49 ;
		.and. nval > 50 .and. nval > 54 .and. nval <> 86 .and. nval <> 91 .and. nVal <> 98 .and. nval <> 99
		lRet := .F.
	ENDIF
	
//10
//30
//33
//35
//44
//45
//49
//50 até 54 (inclusive)
//86
//91
//98
//99


endif

If LRet  .and. !lRf  // comeca a validar o IMEI se tiver pelo menos 15 posicoes
	For x = 1 to nMax
		cDigit := Substring(cImei,  x , 1 )	
		If ! cDigit $ '0123456789' // todos os caracteres do IMEI devem ser números
			lRet := .f.
			Exit
		endif
	Next  
EndIf

If lRet .and. !lRf // solicitacao de Carlos para nao validar digito Zero
	// colocado antes para nao calcular o algoritrimo e ser mais rapido 
	If Val(Substring(cImei,nL,1)) = 0 
		return .t.	
	Endif
Endif

if lRet .and. !lRf // passou nas validacoes anteriores valida o digito verificador  (14º com 13º )

	do while  i < (nl -1) 
		cDigit := Substring(cImei, nL - i - 1 ,1 )
		nTp    :=  VAL(cDigit) * nMul 
		
		If nTp >= 10 
			nsum += (ntp % 10) + 1
		Else                  
			nSum += nTp
		Endif         
		             
	
		If nMul = 1 
			nMul++
		else 
			nMul--
		endif	    
		i++
	EndDo	
	nChk = 10 - (nSum % 10)   
	
	If nChk = 10 .or. nchk = 5  // modulo 10 + 5 
		nChk := 0
	endIf
	
	If  nChk <> 0 .and. nChk != Val(Substring(cImei,nL,1))   
		lRet := .F.
	Endif	
ENDIF	    
If !lRet .and. FUNNAME() <> "XVERIFIMEI"  .and. FUNNAME() <> "TECAX011"
	MsgAlert(" Codigo do IMEI invalido! -  Verificar ","Atencao")
Endif

RestArea(aSaveArea)
Return  lRet      



/* ------------------------------------------------------------
Função que verifica e gera EXCEL dos IMEIS Inválidos da base de dados
Claudia Cabral - 118/01/2010
*/
User Function xVerifImei()    
Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()        
Local cQuery :=""
Local cDirDocs:=__reldir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.f.)
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local cPath:=AllTrim(GetTempPath())     
Local nLin := 0
Local nMax := 0
//Local dData := DTOS( FIRSTDAY(dDatabase) - 1 )
//Local dDtfecha := DTOS(GetMv("MV_ULMES") )
Local aDiverge := {}
Local nAt := 0
Local lDiverge := .f.
Local ndigito  := 0     
Local aSaveArea := GetArea()   
         
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif                 


cQuery := " SELECT DISTINCT ZZ4_IMEI " 
cQuery += " FROM " + RetSqlName("ZZ4") + " ZZ4 "
cQuery += " WHERE D_E_L_E_T_ = ''  "
cQuery += " AND ZZ4_STATUS <> '9' "
cQuery += " AND ZZ4_FILIAL = '" + xFilial("ZZ4")   + "'"
TCQUERY cQuery NEW ALIAS "QRY1"  


nTotsRec := QRY1->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY1->(Eof())
	IncProc()       
	If ! U_ChKImei(QRY1->ZZ4_IMEI)
		aadd(aDiverge,{QRY1->ZZ4_IMEI})
	Endif	
	QRY1->(DbSkip())
EndDo

cLinha := 'IMEI '      					+ ';'
Fwrite(nHandle, cLinha  + cCrLf)

nMax := Len(aDiverge)             
ProcRegua(nMax)               
For x =1 to nMax   
	IncProc()
	cLinha := ''
	cLinha += aDiverge[x,1] + ';'
	fWrite(nHandle, cLinha  + cCrLf)						
Next	

fClose(nHandle)
//CpyS2T(cdirdocs+carquivo+".CSV" , cPath, .T. )        	-- Removido a pedido do Carlos Rocha 14/07/10 --
//ferase(cdirdocs+carquivo+".CSV") 
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( Cpath+cArquivo+".CSV" ) // Abre uma planilha -- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) // Abre uma planilha 	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   

RestArea(aSaveArea)

Return .t.


/*-------- FUNCAO ORIGINAL EM JAVA -------------------------*/
/*
function isIMEI (s) {
var etal = /^[0-9]{15}$/;
  if (!etal.test(s))
    return false;
  sum = 0; mul = 2; l = 14;
  for (i = 0; i < l; i++) {
    digit = s.substring(l-i-1,l-i);
    tp = parseInt(digit,10)*mul;
    if (tp >= 10)
         sum += (tp % 10) +1;
    else
         sum += tp;
    if (mul == 1)
         mul++;
    else
         mul--;
    }
  chk = ((10 - (sum % 10)) % 10);
  if (chk != parseInt(s.substring(14,15),10))
    return false;
  return true;
}
  
*/
