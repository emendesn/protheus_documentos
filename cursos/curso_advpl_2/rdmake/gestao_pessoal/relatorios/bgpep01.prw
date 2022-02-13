#Include "Rwmake.ch"
#Include "Ap5Mail.ch"
#include "topconn.ch"
#Include "TbiConn.ch"
#Include "Protheus.ch"
#include "prtopdef.ch"
#INCLUDE "MSOLE.CH"

/*
+------------+---------+--------+---------------+-------+-------------------+
| Programa:  | BGPE01  | Autor: | Rog�rio Alves | Data: |  Novembro/2013    |
+------------+---------+--------+---------------+-------+-------------------+
| Descri��o: | E-mail para gestores para controle de programa��o de F�rias  |
+------------+--------------------------------------------------------------+
| Uso:       | BGH                                                          |
+------------+-----------------------+--------------------------------------+
*/

User Function BGPE01()

Local _cMsg			:= _cMsg1 	:= ""
Local _cTo 			:= ""
Local _cCC	   		:= "" 
Local _cGestor		:= ""
Local _cSubject		:= "Programa��o de F�rias"
Local _lExc 		:= _lMail := .F.
Local _nTry 		:= 1
Local cQUERY		:= ""
Local _aStru1		:= {}
Local TMP1			:= ""
Local aCenCus		:= {}
Local nDias			:= MonthSum( date() , 17 ) - date()
Local cSRW			:= ""
Local lOk			:= .F.
//Local cAcessaSRA	:= &( " { || " + ChkRH( "BGPE01" , "SRA" , "2" ) + " } " )

PREPARE ENVIRONMENT Empresa "02" Filial "06" 
                                                                  
cQuery 	:= "SELECT RW_IDUSER, RW_USUARIO, RW_FILBROW, RW__RECEMA "
cQuery 	+= "FROM SRW020 AS SRW "
cQuery 	+= "WHERE SRW.D_E_L_E_T_ = '' "
cQuery 	+= "ORDER BY RW_IDUSER "

If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP1"

cQuery := ""

DBSELECTAREA("TMP1")
TMP1->(DBGOTOP())

While !EOF("TMP1")

	If TMP1->RW__RECEMA != "S"
		dbSelectArea("TMP1")
		dbSkip()
		Loop	
	EndIf
	
	_cMsg1 := ;
	"<TR><TD>MATR</TD>" +;
	"<TD>CC</TD>" +;
	"<TD>DESC</TD>" +;
	"<TD>CELULA</TD>" +;
	"<TD>NOME</TD>" +;
	"<TD>TURNO</TD>" +;
	"<TD>DESC.TURNO</TD>" +;
	"<TD>FUNCAO</TD>" +;
	"<TD>ADMISSAO</TD>" +;
	"<TD>PER.AQUI</TD>" +;
	"<TD>VENC</TD>" +;
	"<TD>LIMITE</TD>" +;
	"</TR>"
	
	_cMsg := ""
	
	cAcessaSRA := &( " { || " + Alltrim(TMP1->RW_FILBROW) + " } " )
	
	DBSELECTAREA("SRA")
	Set Filter To SRA->RA_FILIAL != "03" .and. SRA->RA_SITFOLH != "D" .and. SRA->RA_CATFUNC $ ('M,H')
	
	Dbselectarea("SRA")
	DBGOTOP()
	
	PswOrder(2)
	
	If PswSeek( TMP1->RW_IDUSER, .T. )
		_cTo 		:= PswRet()[1][14]
		_cGestor	:= PswRet()[1][4]
	EndIf
	
//	_cTo := "luiscarlos@anadi.com.br"
	
	While !EOF("SRA")
		
		IF !(Eval(cAcessaSRA ))
			dbSelectArea("SRA")
			dbSkip()
			Loop
		EndIF
		
		DBSELECTAREA("SRF")
		DbSetOrder(1)
		If DbSeek(SRA->RA_FILIAL + SRA->RA_MAT,.f.)
			
			If !EMPTY(SRF->RF_DATAINI)
				dbSelectArea("SRA")
				dbSkip()
				Loop
			EndIf
			
			IF MonthSum(SRF->RF_DATABAS, 17 ) > LASTDAY(dDatabase)
				dbSelectArea("SRA")
				dbSkip()
				Loop
			EndIF
			
		Else
			
			dbSelectArea("SRA")
			dbSkip()
			Loop
			
		EndIf
		
		DBSELECTAREA("SQB")
		DbSetOrder(1)
		DbSeek(xFilial("SQB") + SRA->RA__DEPTO,.f.)
		
		DBSELECTAREA("SZK")
		DbSetOrder(1)
		DbSeek(xFilial("SZK") + SRA->RA__CELULA,.f.)
		
		DBSELECTAREA("SR6")
		DbSetOrder(1)
		DbSeek(xFilial("SR6") + SRA->RA_TNOTRAB,.f.)
		
		DBSELECTAREA("SRJ")
		DbSetOrder(1)
		DbSeek(xFilial("SRJ") + SRA->RA_CODFUNC,.f.)
		
		lOk	:= .T.
		
		_cMsg1 += ;
		"<TR><TD>"+ALLTRIM(Substr(SRA->RA_MAT,1,tamsx3("RA_MAT")[1]))+"</TD>" +;															//MATR
		"<TD>" + ALLTRIM(Substr(SRA->RA_CC,1,tamsx3("RA_CC")[1])) + "</TD>" +;																//CC
		"<TD>" + ALLTRIM(Substr(Alltrim(SQB->QB_DESCRIC),1,tamsx3("QB_DESCRIC")[1])) + "</TD>" +;											//DESC.AREA
		"<TD>" + ALLTRIM(Substr(Alltrim(SZK->ZK_DESCRIC),1,tamsx3("ZK_DESCRIC")[1])) + "</TD>" +;											//CELULA
		"<TD>" + ALLTRIM(Substr(Alltrim(SRA->RA_NOME),1,tamsx3("RA_NOME")[1])) + "</TD>" +;													//NOME
		"<TD>" + ALLTRIM(Substr(SRA->RA_TNOTRAB,1,tamsx3("RA_TNOTRAB")[1])) + "</TD>" +;													//TURNO
		"<TD>" + ALLTRIM(Substr(Alltrim(SR6->R6_DESC),1,tamsx3("R6_DESC")[1])) + "</TD>" +;													//DESC.TURNO
		"<TD>" + ALLTRIM(Substr(Alltrim(SRJ->RJ_DESC),1,tamsx3("RJ_DESC")[1])) + "</TD>" +;													//FUNCAO
		"<TD><DIV ALIGN=right>" + Substr(Transform(SRA->RA_ADMISSA, "@D"),1,tamsx3("RA_ADMISSA")[1]) + "</DIV></TD>" +;						//ADMISSAO
		"<TD><DIV ALIGN=right>" + Substr(Transform((SRF->RF_DATABAS + 364), "@D"),1,tamsx3("RF_DATABAS")[1]) + "</DIV></TD>" +;				//PER.AQUI
		"<TD>" + ALLTRIM(TRANSFORM (SRF->RF_DFERVAT, "@E 99999999" )) + "</TD>" +;															//VENC
		"<TD><DIV ALIGN=right>" + Substr(Transform(SRF->RF_DATABAS + nDias, "@D"),1,tamsx3("RF_DATABAS")[1]) + "</DIV></TD>" +;				//LIMITE
		"</TR>"
		
		DbSelectArea("SRA")
		DbSkip()
		
	EndDo
		
	_cMsg := ;
	"<TABLE><p><font color='red'>" + UPPER(_cGestor) + " </font>" + chr(13)+chr(10) +  chr(13)+chr(10) + " Os funcion�rios abaixo ter�o suas f�rias venciadas " + chr(13)+chr(10) + chr(13)+chr(10) + ;
	" - As F�rias que n�o forem programadas pelo gestor e que estiverem pr�ximas ao limite, ser�o agendadas compulsoriamente para evitar o pagamento em dobro (multa) " + chr(13)+chr(10) + ;
	" - As f�rias dever�o se iniciar preferencialmente na 2� feira ou no 1� dia �til da semana, conforme orienta��o do sindicato, salvo se solicitado por escrito de pr�prio punho pelo empregado (a). " + chr(13)+chr(10) + ;
	" - A solicita��o da 1� Parcela do 13� Sal�rio por ocasi�o das f�rias entre os meses de fevereiro e novembro ou a convers�o de 1/3 das F�rias em Abono Pecuni�rio, dever� ser feita por escrito e de pr�prio punho. " + chr(13)+chr(10) + chr(13)+chr(10) + ;
	" Contamos com a colabora��o de todos. Essas orienta��es s�o para melhor atend�-los dentro do que preceitua a lei, as normas da empresa e as necessidades dos empregados. " + chr(13)+chr(10) + ;
	" As sugest�es ser�o benvindas. " + chr(13)+chr(10) + chr(13)+chr(10) + ;
	" Muito Obrigado " + chr(13)+chr(10) + chr(13)+chr(10) + ;
	" <p><font color='blue'>BGH - Adm. de Pessoal </font> " + chr(13)+chr(10) + ;
	" <p><font color='blue'>Tel.: 55 11 2608-9858 - Ramal: 9958 </font> " + chr(13)+chr(10) + ;		
	"<TABLE border='1' width='90%' align='center' cellpadding='3' cellspacing='0' bordercolor='#CCCCCC'>" + ;
	"<TR><TD colspan='2'><table border='1' width='100%' align='center' cellpadding='3' cellspacing='0' bordercolor='#CCCCCC'><font size=1>" + _cMsg1 + ;
	"</TD></TR></TABLE></FONT></TABLE>"
	
	If lOk
//		U_ENVIAEMAIL(AllTrim(_cSubject),AllTrim(_cTo),AllTrim(_cCC),_cMsg,"")

		U_ENVIAEMAIL(AllTrim(_cSubject),AllTrim("luiscarlos@anadi.com.br"),AllTrim(_cCC),_cMsg,"")
		U_ENVIAEMAIL(AllTrim(_cSubject),AllTrim("claudio.bispo@bgh.com.br"),AllTrim(_cCC),_cMsg,"")
		U_ENVIAEMAIL(AllTrim(_cSubject),AllTrim("lilian.riegel@bgh.com.br"),AllTrim(_cCC),_cMsg,"")

		_cMsg1 := ""
		lOk	:= .F.
	EndIf
	
	Dbselectarea("SRA")
	Set Filter To
	
	DbSelectArea("TMP1")
	DbSkip()
	
EndDo

If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()
EndIf

RESET ENVIRONMENT

