#include "totvs.ch"
#include "protheus.ch" 
#Include "Topconn.ch"
// NAO ESQUECER DAS ROTINAS CFOPARM E mt100tok
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function IpTxtGcom()
Local oDlg
Local oSay01
Local oSay02
Local oSay03
Local oGetTXT
Local oBtnFile
Local oBtnOK
Local cType := "Arquivo TXT (*.TXT) |*.txt|"
Local cGetTXT	:= space(200) 

Private lOk := .T.  
Private cMsgRet	:= ""

DEFINE MSDIALOG oDlg TITLE "Importa็ใo de TXT - GCOM" FROM 000, 000  TO 170,400 PIXEL 
	@010,010 SAY oSay01 PROMPT "Este programa farแ a inclusใo de dados vindos do sistema GCOM," SIZE 160,010 OF oDlg PIXEL
	@030,010 SAY oSay02 PROMPT "a partir de um arquivo TXT" SIZE 120,010 OF oDlg PIXEL
	@050,010 SAY oSay03 PROMPT "Arquivo TXT:" SIZE 040,010 OF oDlg PIXEL
	@048,045 MSGET oGetTXT VAR cGetTXT When .F. SIZE 120,010 OF oDlg PIXEL                                                                                                    
	@ 048, 165 BUTTON oBtnFile PROMPT "..." SIZE 010, 010 ACTION (	cGetTXT:=cGetFile(cType,OemToAnsi("Selecione o arquivo a ser importado"),1,,.F., nOR(GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_LOCALFLOPPY ),.F.,.F.)) OF oDlg PIXEL
	@ 070, 010 BUTTON oBtnOK PROMPT "Processa TXT" SIZE 050, 010 ACTION (Iif(!Empty(cGetTXT),LjMsgRun("Aguarde... Processando TXT",,;
	{||lOk:=ImpTXT(cGetTXT)}),lOk:=.F.),Iif(lOk,oDlg:End(),(cMsgRet := "Informa็๕es sobre registros nใo importados" +CRLF+cMsgRet,;
	ShowErr("Registros nใo importados",cMsgRet)))) OF oDlg PIXEL	
	
ACTIVATE MSDIALOG oDlg CENTERED

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELATXT   บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpTXT(cPath) 

Local cLinha  := ""
Local lPrim	  := .T.
Local aCampos := {}
Local aDados  := {}

Private aErro := {}

Private aImpFis := {} 
Private aCadFor := {}
Private aCadCli := {}
Private aNFE	:= {}
Private aDFE	:= {}
Private aNFS	:= {}
Private aDFS	:= {}
Private aCUP 	:= {}
Private aDUP 	:= {}
Private aZ01 	:= {}
Private aZ02 	:= {} 

FT_FUSE(cPath)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()

While !FT_FEOF()

	IncProc("Lendo arquivo texto...")

	cLinha := FT_FREADLN()

	If Alltrim(Substr(cLinha,1,3)) == "ECF" //Tipo de registro     
		Aadd(aImpFis,;
			{	Substr(cLinha,4,20),;	//Modelo do ECF
				Substr(cLinha,24,20),;	//N๚mero de fabrica็ใo
				Substr(cLinha,44,10);	//N๚mero do PDV		
			})
	ElseIf Alltrim(Substr(cLinha,1,3)) == "FOR"  
		Aadd(aCadFor,;
			{	Iif(Substr(cLinha,36,1)=='J',Substr(cLinha,4,14),Substr(cLinha,7,11)),;	//CNPJ/CPF do fornecedor 
				Substr(cLinha,18,18),;	//Inscri็ใo estadual
				Substr(cLinha,36,1),;	//Tipo Pessoa
				Substr(cLinha,37,40),;	//Nome do cliente	
				Substr(cLinha,77,8),;   //Cep
				Substr(cLinha,85,60),;  //Endere็o
				Substr(cLinha,145,30),; //Complemento
				Substr(cLinha,175,40),; //Bairro
				Substr(cLinha,215,40),; //Municํpio
				Substr(cLinha,255,2),;  //Estado
				Substr(cLinha,257,3),;  //DDD 
				Substr(cLinha,260,15),; //Telefone Fixo
				Substr(cLinha,275,15),; //Telefone M๓vel
				Substr(cLinha,290,50);	//E-mail	
			})
	ElseIf Alltrim(Substr(cLinha,1,3)) == "CLI" 	
		Aadd(aCadCli,;
			{	Iif(Substr(cLinha,36,1)=='J',Substr(cLinha,4,14),Substr(cLinha,7,11)),;	//CNPJ/CPF do cliente 
				Substr(cLinha,18,18),;	//Inscri็ใo estadual
				Substr(cLinha,36,1),;	//Tipo Pessoa
				Substr(cLinha,37,40),;	//Nome do cliente	
				Substr(cLinha,77,8),;   //Cep
				Substr(cLinha,85,60),;  //Endere็o
				Substr(cLinha,145,30),; //Complemento
				Substr(cLinha,175,40),; //Bairro
				Substr(cLinha,215,40),; //Municํpio
				Substr(cLinha,255,2),;  //Estado
				Substr(cLinha,257,3),;  //DDD 
				Substr(cLinha,260,15),; //Telefone Fixo
				Substr(cLinha,275,15),; //Telefone M๓vel
				Substr(cLinha,290,50);	//E-mail			
			})
	ElseIf Alltrim(Substr(cLinha,1,3)) == "NFE" 
		Aadd(aNFE,;
			{	STOD(Substr(cLinha,4,8)),;	//Data da Emissใo
				Substr(cLinha,20,9),;   	//N๚mero da Nota Fiscal 
				Substr(cLinha,29,3),;   	//Serie
				Substr(cLinha,32,6),;		//COO			
				Substr(cLinha,38,14),;  	//CNPJ/CPF do fornecedor
				Substr(cLinha,52,44),;  	//Chave NF-E
				Substr(cLinha,96,9),;   	//Cupom referenciado
				Substr(cLinha,105,10),;  	//N๚mero do PDV que efetuou a venda.
				Substr(cLinha,115,10),; 	//N๚mero MAPA
				Substr(cLinha,125,1);		//Status	
			})
	ElseIf Alltrim(Substr(cLinha,1,3)) == "DFE"
		Aadd(aDFE,;
			{	Substr(cLinha,4,9),;                                          //N๚mero da Nota Fiscal
				Substr(cLinha,13,3),;                                         //Serie
				Substr(cLinha,16,14),;                                        //CNPJ/CPF do fornecedor
				Substr(cLinha,30,2),;				                          //Item da nota fiscal
				Substr(cLinha,32,15),;                                        //C๓digo do Produto
				Substr(cLinha,47,3),;   				                      //Unidade
				Transform(Val(Substr(cLinha,50,11)), "@E 99999999.99"),;       //Quantidade 
				Transform(Val(Substr(cLinha,61,14)), "@E 99999999.99999"),;    //Valor Unitแrio
				Transform(Val(Substr(cLinha,75,17)), "@E 99999999999.99999"),; //Total do Item (Quantidade * Valor Unitแrio)
				Transform(Val(Substr(cLinha,92,12)), "@E 999999.99999"),;      //Valor do desconto
				Substr(cLinha,104,5),;                                        //CFOP
				Substr(cLinha,109,3),;                                        //TES
				Substr(cLinha,112,9),;                                        //C๓digo do servi็os ISS
				Transform(Val(Substr(cLinha,118,14)), "@E 99999999999.99"),;   //Base de cแlculo do ISS
				Transform(Val(Substr(cLinha,132,5)), "@E 99.99"),;             //Alํquota ISS
				Transform(Val(Substr(cLinha,137,14)), "@E 99999999999.99"),;   //Valor do ISS
				Transform(Val(Substr(cLinha,151,16)), "@E 9999999999999.99"),; //Base de cแlculo do ICMS
				Transform(Val(Substr(cLinha,167,5)), "@E 99.99"),;             //Alํquota ICMS
				Transform(Val(Substr(cLinha,172,14)), "@E 99999999.99999"),;   //Valor do ICMS
				Transform(Val(Substr(cLinha,186,14)), "@E 99999999999.99"),;   //Base de cแlculo do IPI
				Transform(Val(Substr(cLinha,200,5)), "@E 99.99"),;             //Alํquota IPI
				Transform(Val(Substr(cLinha,205,14)), "@E 99999999.99999"),;   //Valor do IPI 
				Transform(Val(Substr(cLinha,219,14)), "@E 99999999999.99"),;   //Base PIS
				Transform(Val(Substr(cLinha,233,14)), "@E 99999999999.99"),;   //Base COFINS
				Transform(Val(Substr(cLinha,247,14)), "@E 99999999999.99"),;   //Base CSLL
				Transform(Val(Substr(cLinha,261,6)), "@E 999.99"),;            //Alํquota PIS
				Transform(Val(Substr(cLinha,267,6)), "@E 999.99"),;            //Alํquota COFINS
				Transform(Val(Substr(cLinha,273,6)), "@E 999.99"),;            //Alํquota CSLL
				Transform(Val(Substr(cLinha,279,14)), "@E 99999999999.99"),;   //Valor PIS
				Transform(Val(Substr(cLinha,293,14)), "@E 99999999999.99"),;   //Valor COFINS
				Transform(Val(Substr(cLinha,307,14)), "@E 99999999999.99"),;   //Valor CSLL
				Transform(Val(Substr(cLinha,321,14)), "@E 99999999999.99"),;   //Base Substitui็ใo Tributแria 			
				Transform(Val(Substr(cLinha,335,14)), "@E 99999999999.99"),;   //Valor da substitui็ใo tributaria		
				Substr(cLinha,349,10),;		                                  //N๚mero do PDV que efetuou a venda.
				Substr(cLinha,359,10),;		                                  //N๚mero MAPA
				Substr(cLinha,369,1);		                                  //Status
			})
	ElseIf Alltrim(Substr(cLinha,1,3)) == "NFS" 
		Aadd(aNFS,;
			{	STOD(Substr(cLinha,4,8)),;	//Data da Emissใo
				Substr(cLinha,20,9),;   	//N๚mero da Nota Fiscal 
				Substr(cLinha,29,3),;   	//Serie
				Substr(cLinha,32,6),;		//COO			
				Substr(cLinha,38,14),;  	//CNPJ/CPF do fornecedor
				Substr(cLinha,52,44),;  	//Chave NF-E
				Substr(cLinha,96,9),;   	//Cupom referenciado
				Substr(cLinha,105,10),;  	//N๚mero do PDV que efetuou a venda.
				Substr(cLinha,115,10),; 	//N๚mero MAPA
				Substr(cLinha,125,1);		//Status				
			})			
	ElseIf Alltrim(Substr(cLinha,1,3)) == "DFS"
		Aadd(aDFS,;
			{	Substr(cLinha,4,9),;                                          //N๚mero da Nota Fiscal
				Substr(cLinha,13,3),;                                         //Serie
				Substr(cLinha,16,14),;                                        //CNPJ/CPF do fornecedor
				Substr(cLinha,30,2),;				                          //Item da nota fiscal
				Substr(cLinha,32,15),;                                        //C๓digo do Produto
				Substr(cLinha,47,3),;   				                      //Unidade
				Transform(Val(Substr(cLinha,50,11)), "@E 99999999.99"),;       //Quantidade 
				Transform(Val(Substr(cLinha,61,14)), "@E 99999999.99999"),;    //Valor Unitแrio
				Transform(Val(Substr(cLinha,75,17)), "@E 99999999999.99999"),; //Total do Item (Quantidade * Valor Unitแrio)
				Transform(Val(Substr(cLinha,92,12)), "@E 999999.99999"),;      //Valor do desconto
				Substr(cLinha,104,5),;                                        //CFOP
				Substr(cLinha,109,3),;                                        //TES
				Substr(cLinha,112,9),;                                        //C๓digo do servi็os ISS
				Transform(Val(Substr(cLinha,118,14)), "@E 99999999999.99"),;   //Base de cแlculo do ISS
				Transform(Val(Substr(cLinha,132,5)), "@E 99.99"),;             //Alํquota ISS
				Transform(Val(Substr(cLinha,137,14)), "@E 99999999999.99"),;   //Valor do ISS
				Transform(Val(Substr(cLinha,151,16)), "@E 9999999999999.99"),; //Base de cแlculo do ICMS
				Transform(Val(Substr(cLinha,167,5)), "@E 99.99"),;             //Alํquota ICMS
				Transform(Val(Substr(cLinha,172,14)), "@E 99999999.99999"),;   //Valor do ICMS
				Transform(Val(Substr(cLinha,186,14)), "@E 99999999999.99"),;   //Base de cแlculo do IPI
				Transform(Val(Substr(cLinha,200,5)), "@E 99.99"),;             //Alํquota IPI
				Transform(Val(Substr(cLinha,205,14)), "@E 99999999.99999"),;   //Valor do IPI 
				Transform(Val(Substr(cLinha,219,14)), "@E 99999999999.99"),;   //Base PIS
				Transform(Val(Substr(cLinha,233,14)), "@E 99999999999.99"),;   //Base COFINS
				Transform(Val(Substr(cLinha,247,14)), "@E 99999999999.99"),;   //Base CSLL
				Transform(Val(Substr(cLinha,261,6)), "@E 999.99"),;            //Alํquota PIS
				Transform(Val(Substr(cLinha,267,6)), "@E 999.99"),;            //Alํquota COFINS
				Transform(Val(Substr(cLinha,273,6)), "@E 999.99"),;            //Alํquota CSLL
				Transform(Val(Substr(cLinha,279,14)), "@E 99999999999.99"),;   //Valor PIS
				Transform(Val(Substr(cLinha,293,14)), "@E 99999999999.99"),;   //Valor COFINS
				Transform(Val(Substr(cLinha,307,14)), "@E 99999999999.99"),;   //Valor CSLL
				Transform(Val(Substr(cLinha,321,14)), "@E 99999999999.99"),;   //Base Substitui็ใo Tributแria 			
				Transform(Val(Substr(cLinha,335,14)), "@E 99999999999.99"),;   //Valor da substitui็ใo tributaria		
				Substr(cLinha,349,10),;		                                  //N๚mero do PDV que efetuou a venda.
				Substr(cLinha,359,10),;		                                  //N๚mero MAPA
				Substr(cLinha,369,1);		                                  //Status
			})
	ElseIf Alltrim(Substr(cLinha,1,3)) == "CUP" 
		Aadd(aCUP,;
			{	STOD(Substr(cLinha,4,8)),;	//Data da Emissใo
				Substr(cLinha,20,9),;   	//N๚mero da Nota Fiscal 
				Substr(cLinha,29,3),;   	//Serie
				Substr(cLinha,32,6),;		//COO			
				Substr(cLinha,38,14),;  	//CNPJ/CPF do fornecedor
				Substr(cLinha,52,44),;  	//Chave NF-E
				Substr(cLinha,96,9),;   	//Cupom referenciado
				Substr(cLinha,105,10),;  	//N๚mero do PDV que efetuou a venda.
				Substr(cLinha,115,10),; 	//N๚mero MAPA
				Substr(cLinha,125,1);		//Status				
			})			
	ElseIf Alltrim(Substr(cLinha,1,3)) == "DUP"    
		Aadd(aDUP,;
			{	Substr(cLinha,4,9),;                                          //N๚mero da Nota Fiscal
				Substr(cLinha,13,3),;                                         //Serie
				Substr(cLinha,16,14),;                                        //CNPJ/CPF do fornecedor
				Substr(cLinha,30,2),;				                          //Item da nota fiscal
				Substr(cLinha,32,15),;                                        //C๓digo do Produto
				Substr(cLinha,47,3),;   				                      //Unidade
				Transform(Val(Substr(cLinha,50,11)), "@E 99999999.99"),;       //Quantidade 
				Transform(Val(Substr(cLinha,61,14)), "@E 99999999.99999"),;    //Valor Unitแrio
				Transform(Val(Substr(cLinha,75,17)), "@E 99999999999.99999"),; //Total do Item (Quantidade * Valor Unitแrio)
				Transform(Val(Substr(cLinha,92,12)), "@E 999999.99999"),;      //Valor do desconto
				Substr(cLinha,104,5),;                                        //CFOP
				Substr(cLinha,109,3),;                                        //TES
				Substr(cLinha,112,9),;                                        //C๓digo do servi็os ISS
				Transform(Val(Substr(cLinha,118,14)), "@E 99999999999.99"),;   //Base de cแlculo do ISS
				Transform(Val(Substr(cLinha,132,5)), "@E 99.99"),;             //Alํquota ISS
				Transform(Val(Substr(cLinha,137,14)), "@E 99999999999.99"),;   //Valor do ISS
				Transform(Val(Substr(cLinha,151,16)), "@E 9999999999999.99"),; //Base de cแlculo do ICMS
				Transform(Val(Substr(cLinha,167,5)), "@E 99.99"),;             //Alํquota ICMS
				Transform(Val(Substr(cLinha,172,14)), "@E 99999999.99999"),;   //Valor do ICMS
				Transform(Val(Substr(cLinha,186,14)), "@E 99999999999.99"),;   //Base de cแlculo do IPI
				Transform(Val(Substr(cLinha,200,5)), "@E 99.99"),;             //Alํquota IPI
				Transform(Val(Substr(cLinha,205,14)), "@E 99999999.99999"),;   //Valor do IPI 
				Transform(Val(Substr(cLinha,219,14)), "@E 99999999999.99"),;   //Base PIS
				Transform(Val(Substr(cLinha,233,14)), "@E 99999999999.99"),;   //Base COFINS
				Transform(Val(Substr(cLinha,247,14)), "@E 99999999999.99"),;   //Base CSLL
				Transform(Val(Substr(cLinha,261,6)), "@E 999.99"),;            //Alํquota PIS
				Transform(Val(Substr(cLinha,267,6)), "@E 999.99"),;            //Alํquota COFINS
				Transform(Val(Substr(cLinha,273,6)), "@E 999.99"),;            //Alํquota CSLL
				Transform(Val(Substr(cLinha,279,14)), "@E 99999999999.99"),;   //Valor PIS
				Transform(Val(Substr(cLinha,293,14)), "@E 99999999999.99"),;   //Valor COFINS
				Transform(Val(Substr(cLinha,307,14)), "@E 99999999999.99"),;   //Valor CSLL
				Transform(Val(Substr(cLinha,321,14)), "@E 99999999999.99"),;   //Base Substitui็ใo Tributแria 			
				Transform(Val(Substr(cLinha,335,14)), "@E 99999999999.99"),;   //Valor da substitui็ใo tributaria		
				Substr(cLinha,349,10),;		                                  //N๚mero do PDV que efetuou a venda.
				Substr(cLinha,359,10),;		                                  //N๚mero MAPA
				Substr(cLinha,369,1);		                                  //Status
			})
	ElseIf Alltrim(Substr(cLinha,1,3)) == "Z01" 
		Aadd(aZ01,;
			{	STOD(Substr(cLinha,4,8)),; 										//Data do Movimento 
				Substr(cLinha,12,6),; 											//N๚mero do relat๓rio
				Substr(cLinha,18,10),;      									//N๚mero do PDV
				Substr(cLinha,28,5),;											//N๚mero da redu็ใo Z 				
				Transform(Val(Substr(cLinha,33,18)), "@E 999999999999999.99"),;	//GT Inicial
				Transform(Val(Substr(cLinha,51,18)), "@E 999999999999999.99"),;	//GT Final
				Substr(cLinha,69,9),;											//N๚mero documento fiscal inicial
				Substr(cLinha,78,9),;											//N๚mero documento fiscal final
				Transform(Val(Substr(cLinha,87,8)), "@E 99999.99"),;			//Valor do cancelamento
				Transform(Val(Substr(cLinha,95,14)), "@E 99999999999.99"),;		//Valor contแbil
				Transform(Val(Substr(cLinha,109,14)), "@E 99999999999.99"),;		//Valor da substitui็ใo tributaria do resumo daredu็ใo Z
				Transform(Val(Substr(cLinha,123,14)), "@E 99999999999.99"),;		//Descontos
				Transform(Val(Substr(cLinha,137,14)), "@E 99999999999.99"),;		//Acumulado isento
				Transform(Val(Substr(cLinha,151,14)), "@E 99999999999.99"),;		//Valores nใo tributado
				Transform(Val(Substr(cLinha,165,14)), "@E 99999999999.99"),;		//Base ICMS 7%
				Transform(Val(Substr(cLinha,179,14)), "@E 99999999999.99"),;		//Base ICMS 12%
				Transform(Val(Substr(cLinha,193,14)), "@E 99999999999.99"),;		//Base ICMS 18%
				Transform(Val(Substr(cLinha,207,14)), "@E 99999999999.99"),;		//Base ICMS 25%
				Substr(cLinha,221,6),;											//N๚mero do COO
				Transform(Val(Substr(cLinha,227,14)), "@E 99999999999.99"),;		//Base ISS
				Substr(cLinha,241,3),;											//Contador de Reinํcio de Opera็ใo.
				Substr(cLinha,244,30),;											//Observa็ใo do PDV	
				STOD(Substr(cLinha,274,8)),;									//Data da redu็ใo	
				Substr(cLinha,282,6);											//Hora da redu็ใo 								
			})
	ElseIf Alltrim(Substr(cLinha,1,3)) == "Z02" 
		Aadd(aZ02,;
			{	Substr(cLinha,4,20),;                                    //N๚mero de fabrica็ใo
				Substr(cLinha,24,1),;                                    //Letra indicativa de MF adicional
				Substr(cLinha,25,20),;				                     //Modelo do ECF
				Transform(Val(Substr(cLinha,45,2)), "@E 99"),;            //Nบ de ordem do usuแrio do ECF
				Transform(Val(Substr(cLinha,47,6)), "@E 999999"),;        //Nบ do Contador de Redu็ใo Z relativo เ respectiva redu็ใo
				Substr(cLinha,56,7),;                                    //C๓digo do totalizador conforme tabela abaixo
				Transform(Val(Substr(cLinha,63,13)), "@E 9999999999999"); //Valor acumulado no totalizador, relativo เ respectiva Redu็ใo Z, com duas casas decimais.			
			})		
	EndIf

	FT_FSKIP()
EndDo
FT_FUSE()

//Begin Transaction
	//GeraImpFis()
	GeraFor()
	GeraCli()
	/*GeraNFE()
	GeraNFS()	
	GeraCUP()*/	
	GeraZ01()
	AtuTabs()
//End Transaction

If lOk
	ApMsgInfo("Importa็ใo dos Dados concluํda com sucesso!","SUCESSO")
Else	 
	cMsgRet := "Informa็๕es sobre registros nใo importados" +CRLF+cMsgRet
	ShowErr("Registros nใo importados",cMsgRet)	
EndIf	

Return .T.
 
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*Static Function GeraImpFis()

Local aArea:= GetArea()

	ProcRegua(Len(aImpFis))
	For i:=1 to Len(aImpFis)
	
		IncProc("Importando Impressora Fiscal...")
	
		//execauto
		
	Next i

RestArea(aArea)

Return*/
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GeraFor() 

Local aArea:= GetArea()
Local cComp := ""   

Private lMsErroAuto := .F. 

	If Select("SA2") == 0
		DbSelectArea("SA2")
	EndIf
	SA2->(DbSetOrder(3))
	SA2->(DbGoTop())	

	If !Empty(aCadFor)

		ProcRegua(Len(aCadFor))
		For i:=1 to Len(aCadFor) 		
		
			IncProc("Importando Cadastro de Fornecedor...") 
			
			If SA2->(!DbSeek(xFilial("SA2")+aCadFor[i][1]))
			    
				cComp :=""
				cComp := Alltrim(SubStr(Alltrim(aCadFor[i][6]),At(',',Alltrim(aCadFor[i][6]))+1))
				If Empty(cComp)
					cComp :="999"
				EndIf	
					
				aVetor := {	{"A2_COD"		,GETSXENUM("SA2","A2_COD")														,nil},;				
							{"A2_LOJA"		,Avkey(Alltrim("01"),"A2_LOJA")													,nil},;
		                    {"A2_NOME"		,Avkey(Alltrim(aCadFor[i][4]),"A2_NOME")          								,nil},; 
		                    {"A2_TIPO"		,Avkey(Alltrim(aCadFor[i][3]),"A2_TIPO")          								,nil},;
		                    {"A2_CEP"		,Avkey(Alltrim(aCadFor[i][5]),"A2_CEP")              							,nil},; 
		                    {"A2_MUN"		,Avkey(Alltrim(aCadFor[i][9]),"A2_MUN")              							,nil},;   
		                    {"A2_NUMCOMP"	,cComp																			,nil},;                    
		                    {"A2_NREDUZ"	,Avkey(Alltrim(SubStr(aCadFor[i][4],1,20)),"A2_NREDUZ") 						,nil},;  
		                    {"A2_CGC"		,Avkey(Alltrim(aCadFor[i][1]),"A2_CGC")              							,nil},;
		                    {"A2_DDD"		,Iif (!Empty(aCadFor[i][11]),Avkey(Alltrim(aCadFor[i][11]),"A2_DDD"),"011")     ,nil},; 
		                    {"A2_INSCR"		,Avkey(Alltrim(aCadFor[i][2]),"A2_INSCR")              							,nil},;                    
		                    {"A2_TEL"		,Iif (!Empty(aCadFor[i][12]),Avkey(Alltrim(aCadFor[i][12]),"A2_TEL"),"91111111"),nil},;
		                    {"A2_PAIS"		,Avkey(Alltrim("105"),"A2_PAIS")               									,nil},;
		                    {"A2_CODPAIS" 	,Avkey(Alltrim("01058"),"A2_CODPAIS") 		            						,nil},;
		                    {"A2_CONTA" 	,Avkey(Alltrim("2110100001"),"A2_CONTA")		    							,nil},;                     
		                    {"A2_EMAIL"		,Iif (!Empty(aCadFor[i][14]),Avkey(Alltrim(aCadFor[i][14]),"A2_EMAIL"),"xxx@xx.com")	,nil}}  
		                    		        
		        lMsErroAuto := .F. 
		                    
				MSExecAuto({|x,y| Mata020(x,y)},aVetor,3)  
			
				If lMsErroAuto			
					cPath := GetTempPath()
					cArquivo := "ImpTXT.Log"
					MostraErro(cPath,cArquivo)
					cMsgRet += MemoRead(cPath+"\"+cArquivo)
					FErase(cPath+cArquivo) 				
					DisarmTransaction()
					//cMsgRet += "Inconsistencia de informa็๕es para cadastro de Fornecedor.CNPJ: "+aCadFor[i][1]+CRLF
					lOk := .F.				
		        EndIf		        
		        
		        ConfirmSX8() 
		        
			EndIf		        	
		
		Next i
		
	EndIf	

	RestArea(aArea)

Return          
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GeraCli()
 
Local aArea:= GetArea()
Local aVetor := {} 
Local cComp	:= ""  

Private lMsErroAuto := .F.

	If Select("SA1") == 0
		DbSelectArea("SA1")
	EndIf
	SA1->(DbSetOrder(3))
	SA1->(DbGoTop())
    
    If !Empty(aCadCli)
	
		ProcRegua(Len(aCadCli))
		For i:=1 to Len(aCadCli)
		
			IncProc("Importando Cadastro de Cliente...")
			
			If SA1->(!DbSeek(xFilial("SA1")+aCadCli[i][1]))
			
				cComp :=""
				cComp := Alltrim(SubStr(Alltrim(aCadCli[i][6]),At(',',Alltrim(aCadCli[i][6]))+1))
				If Empty(cComp)
					cComp :="999"
				EndIf 		
			
				aVetor := {	{"A1_COD"		,GETSXENUM("SA1","A1_COD")														,nil},;
							{"A1_LOJA"		,Avkey(Alltrim("01"),"A1_LOJA")													,nil},;
		                    {"A1_NOME"		,Avkey(Alltrim(aCadCli[i][4]),"A1_NOME")          								,nil},; 
		                    {"A1_PESSOA"	,Avkey(Alltrim(aCadCli[i][3]),"A1_PESSOA")          							,nil},;
		                    {"A1_NREDUZ"	,Avkey(Alltrim(SubStr(aCadCli[i][4],1,20)),"A1_NREDUZ") 						,nil},;   
		                    {"A1_TIPO"		,Avkey(Alltrim(aCadCli[i][3]),"A1_TIPO")										,nil},; 
		                    {"A1_CEP"		,Avkey(Alltrim(aCadCli[i][5]),"A1_CEP")             							,nil},;
		                    {"A1_BAIRRO"	,Avkey(Alltrim(aCadCli[i][8]),"A1_BAIRRO")              						,nil},; 
		                    {"A1_EST"		,Avkey(Alltrim(aCadCli[i][10]),"A1_EST")             							,nil},;  
		                    {"A1_MUN"		,Avkey(Alltrim(aCadCli[i][9]),"A1_MUN")              							,nil},;   
		                    {"A1_XNUMCOM"	,cComp										             						,nil},; 
		                    {"A1_DDD"		,Iif (!Empty(aCadCli[i][11]),Avkey(Alltrim(aCadCli[i][11]),"A1_DDD"),"011")		,nil},;                    
		                    {"A1_TEL"		,Iif (!Empty(aCadCli[i][12]),Avkey(Alltrim(aCadCli[i][12]),"A1_TEL"),"91111111"),nil},;                    
		                    {"A1_PAIS"		,Avkey(Alltrim("105"),"A1_PAIS")               									,nil},;
		                    {"A1_CODPAIS" 	,Avkey(Alltrim("01058"),"A1_CODPAIS") 		            						,nil},;
		                    {"A1_CGC"		,Avkey(Alltrim(aCadCli[i][1]),"A1_CGC")              							,nil},;
		                    {"A1_INSCR"		,Iif (!Empty(aCadCli[i][2]),Avkey(Alltrim(aCadCli[i][2]),"A1_INSCR"),"ISENTO")	,nil},;
		                    {"A1_CONTA" 	,Avkey(Alltrim("1120100001"),"A1_CONTA")		    							,nil},; 
		                    {"A1_TRANSP" 	,Avkey(Alltrim("01"),"A1_TRANSP")				    							,nil},;
		                    {"A1_MENSAGE" 	,Avkey(Alltrim("024"),"A1_MENSAGE")				    							,nil},; 
		                    {"A1_EMAIL" 	,Iif (!Empty(aCadCli[i][14]),Avkey(Alltrim(aCadCli[i][14]),"A1_EMAIL"),"xxx@xx.com") ,nil},;
		                    {"A1_CONTRIB"	,Avkey(Alltrim("2"),"A1_CONTRIB")			           							,nil}} 
		             				
				lMsErroAuto := .F. 
				
				MSExecAuto({|x,y| Mata030(x,y)},aVetor,3)
				 
				If lMsErroAuto
					cPath := GetTempPath()
					cArquivo := "ImpTXT.Log"
					MostraErro(cPath,cArquivo)
					cMsgRet += MemoRead(cPath+"\"+cArquivo)
					FErase(cPath+cArquivo) 				
					DisarmTransaction()
					//cMsgRet += "Inconsistencia de informa็๕es para cadastro de Cliente.CNPJ: "+aCadCli[i][1]+CRLF
					lOk := .F.				
		        EndIf
		        
		        ConfirmSX8()
	        
	        EndIf			
				
		Next i
		 
	EndIf	

	RestArea(aArea)

Return       
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GeraNFE()

Local aArea		:= GetArea()
Local aCabec	:= {}
Local aItens	:= {}
Local aLinha	:= {}
Local cFornece	:= ""
Local cLoja 	:= ""
Local nCont		:= 1
Local lTemItem  := .F.
Local cCfop 	:= ""
Local cTes		:= ""
Local nAux		:= 0

Private lMsErroAuto := .F.
    
	If !Empty(aNFE)    
	
		ProcRegua(Len(aNFE))
		For nx:=1 to Len(aNFE)
			nAux:=nx	
		
			IncProc("Importando NFE...")
			
			cFornece:= Posicione("SA2", 3, xFilial("SA2") + aNFE[nx][5],"A2_COD")		 
			cLoja 	:= Posicione("SA2", 3, xFilial("SA2") + aNFE[nx][5],"A2_LOJA")
			
			cNF    := Alltrim(aNFE[nx][2]) 
			cSerie := Alltrim(aNFE[nx][3])
												
			aCabec := {	{'F1_TIPO'		,'N'										,NIL},;
						{'F1_FORMUL'	,'N'										,NIL},;
						{'F1_DOC'		,Avkey(Alltrim(aNFE[nx][2]),'F1_DOC')		,NIL},;
						{'F1_SERIE'		,Avkey(Alltrim(aNFE[nx][3]),'F1_SERIE')		,NIL},;
						{'F1_EMISSAO'	,aNFE[nx][1]								,NIL},;
						{'F1_FORNECE'	,cFornece									,NIL},;	
						{'F1_LOJA'		,cLoja										,NIL},;
						{'F1_ESPECIE'	,'SPED'										,NIL},; 
						{'F1_STATUS'	,Avkey(Alltrim(aNFE[nx][10]),'F1_STATUS')	,NIL},; 
						{'F1_CHVNFE'	,Avkey(Alltrim(aNFE[nx][6]),'F1_CHVNFE')	,NIL}}  			 
					    
		    For k:=nCont to Len(aDFE)
		    
		    	If aDFE[k][1]+aDFE[k][2]+aDFE[k][3] == aNFE[nx][2]+aNFE[nx][3]+aNFE[nx][5]
		    	
			    	If Alltrim(aDFE[nx][11]) == "1202"
				    	cCfop := "1202"
				    	cTes  := "413"
				    	//cTes  := "295"
			    	
			    	ElseIf Alltrim(aDFE[nx][11]) == "1411"
			    		cCfop := "1411" 
			    		cTes  := "414"
				    	//cTes  := "331"
			    	Else
			    		cCfop := "1552"
				    	cTes  := "261"
				    EndIf	
		    	
		    		lTemItem := .T.	    
		    
			    	aLinha :={	{'D1_COD'		,Avkey(Alltrim(aDFE[k][5]),'D1_COD')				,NIL},; 
								{'D1_UM'		,Avkey(Alltrim(aDFE[k][6]),'D1_UM')					,NIL},;								
								{'D1_QUANT'		,Val(StrTran(Alltrim(aDFE[k][7]),",","."))			,NIL},;									
								{'D1_VUNIT'		,Val(StrTran(Alltrim(aDFE[k][8]),",","."))			,NIL},;	
								{'D1_TOTAL'		,Val(StrTran(Alltrim(aDFE[k][9]),",","."))			,NIL},;	
								{'D1_VALIPI'	,Val(StrTran(Alltrim(aDFE[k][22]),",","."))			,NIL},;	
								{'D1_VALICM'	,Val(StrTran(Alltrim(aDFE[k][19]),",","."))			,NIL},;	
								{'D1_TES'		,Avkey(Alltrim(cTes),'D1_TES')						,NIL},;	
								{'D1_CF'		,Avkey(Alltrim(cCfop),'D1_CF')						,NIL},;	
								{'D1_IPI'		,Val(StrTran(Alltrim(aDFE[k][21]),",","."))			,NIL},;	
								{'D1_PICM'		,Val(StrTran(Alltrim(aDFE[k][18]),",","."))			,NIL},;	
								{'D1_CC'		,Avkey(Alltrim("1031"),'D1_CC')						,NIL},;
								{'D1_BASEICM'	,Val(StrTran(Alltrim(aDFE[k][17]),",","."))			,NIL},;	
								{'D1_BASEIPI'	,Val(StrTran(Alltrim(aDFE[k][20]),",","."))			,NIL},;	
								{'D1_BASIMP5'	,Val(StrTran(Alltrim(aDFE[k][23]),",","."))			,NIL},;	
								{'D1_BASIMP6'	,Val(StrTran(Alltrim(aDFE[k][24]),",","."))			,NIL},;	
								{'D1_VALIMP5'	,Val(StrTran(Alltrim(aDFE[k][29]),",","."))			,NIL},;	
								{'D1_VALIMP6'	,Val(StrTran(Alltrim(aDFE[k][30]),",","."))			,NIL},;	
								{'D1_ALQIMP5'	,Val(StrTran(Alltrim(aDFE[k][26]),",","."))			,NIL},;	
								{'D1_ALQIMP6'	,Val(StrTran(Alltrim(aDFE[k][27]),",","."))			,NIL},;	
								{'D1_BASEISS'	,Val(StrTran(Alltrim(aDFE[k][14]),",","."))			,NIL},;	
								{'D1_ALIQISS'	,Val(StrTran(Alltrim(aDFE[k][15]),",","."))			,NIL},;	
								{'D1_VALISS'	,Val(StrTran(Alltrim(aDFE[k][16]),",","."))			,NIL},;								
								{'D1_CODISS'	,Val(StrTran(Alltrim(aDFE[k][13]),",","."))			,NIL},;	
								{'D1_BASECSL'	,Val(StrTran(Alltrim(aDFE[k][25]),",","."))			,NIL},;	
								{'D1_VALCSL'	,Val(StrTran(Alltrim(aDFE[k][31]),",","."))			,NIL},;	
								{'D1_ALQCSL'	,Val(StrTran(Alltrim(aDFE[k][28]),",","."))			,NIL}}
				
					AAdd(aItens,aLinha)					
					
				Else
				
					If lTemItem     
				
						lMsErroAuto := .F. 
						
						MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens,3)
						
						nx:=nAux					
						   
						If lMsErroAuto
							cPath := GetTempPath()
							cArquivo := "ImpTXT.Log"
							MostraErro(cPath,cArquivo)
							cMsgRet += MemoRead(cPath+"\"+cArquivo)
							FErase(cPath+cArquivo)
							DisarmTransaction()						
							//cMsgRet += "Inconsistencia de informa็๕es para Nota Fiscal de Entrada.NF: "+cNF+" - Serie: "+cSerie+CRLF
							lOk := .F.				
						EndIf
						lTemItem := .F.
						aItens:= {}	
					Else		
					    cMsgRet += "Sem Item.Inconsistencia de informa็๕es no arquivo para Nota Fiscal de Entrada.NF: "+cNF+" - Serie: "+cSerie+CRLF
						lOk := .F.
						lTemItem := .F.
						aItens:= {}					    
					EndIf
									    
					Exit
					
				EndIf    
			
			Next k
			
			nCont := k
								
		Next nx
		
		If lTemItem
		
			lMsErroAuto := .F. 
						
			MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens,3)		
			   
			If lMsErroAuto
				cPath := GetTempPath()
				cArquivo := "ImpTXT.Log"
				MostraErro(cPath,cArquivo)
				cMsgRet += MemoRead(cPath+"\"+cArquivo)
				FErase(cPath+cArquivo)
				DisarmTransaction()							
				//cMsgRet += "Inconsistencia de informa็๕es para Nota Fiscal de Entrada.NF: "+cNF+" - Serie: "+cSerie+CRLF
				lOk := .F.				
			EndIf
		
		Else		
			cMsgRet += "Sem Item.Inconsistencia de informa็๕es no arquivo para Nota Fiscal de Entrada.NF: "+cNF+" - Serie: "+cSerie+CRLF
			lOk := .F.
			lTemItem := .F.		
		EndIf
	
	EndIf
				
	RestArea(aArea)

Return
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GeraNFS()

Local aArea		:= GetArea()
Local aCabec    := {}
Local aItens	:= {}   
Local aLinha    := {}
Local cCliente	:= ""
Local cLoja		:= "" 
Local nCont		:= 1
Local lTemItem  := .F.

Private lMsErroAuto := .F.

	If !Empty(aNFS)    

		ProcRegua(Len(aNFS))
		For nx:=1 to Len(aNFS)
		
			IncProc("Importando NFS...") 
			
			cCliente:= Posicione("SA1", 3, xFilial("SA1") + aNFS[nx][5],"A1_COD")		 
			cLoja 	:= Posicione("SA1", 3, xFilial("SA1") + aNFS[nx][5],"A1_LOJA")
			
			cNF    := Alltrim(aNFS[nx][2]) 
			cSerie := Alltrim(aNFS[nx][3])
								
			aCabec := { {"F2_TIPO"   	,"N"									,NIL},;
						{"F2_FORMUL" 	,"N"									,NIL},;
						{"F2_DOC"    	,Avkey(Alltrim(aNFS[nx][2]),"F2_DOC")	,NIL},;
						{"F2_SERIE" 	,Avkey(Alltrim(aNFS[nx][3]),"F2_SERIE")	,NIL},;
						{"F2_EMISSAO"	,aNFS[nx][1]							,NIL},;
						{"F2_CLIENTE"	,cCliente								,NIL},;
						{"F2_LOJA"   	,cLoja									,NIL},;
						{"F2_ESPECIE"	,"NFS"									,NIL},;						
						{"F2_COND"		,"001"									,NIL},;
						{"F2_DESCONT"	,0										,NIL},;
						{"F2_FRETE"		,0										,NIL},;
						{"F2_SEGURO"	,0										,NIL},;
						{"F2_DESPESA"	,0										,NIL},;											
						{"F2_PDV"		,Avkey(Alltrim(aImpFis[1][3]),"F2_PDV")	,NIL},;
						{"F2_MAPA"		,Avkey(Alltrim(aNFS[nx][9]),"F2_MAPA")	,NIL},;					
						{"F2_ECF"		,"S"									,NIL}} 
									
			For k:=nCont to Len(aDFS) 
		    
			    If aDFS[k][1]+aDFS[k][2]+aDFS[k][3] == aNFS[nx][2]+aNFS[nx][3]+aNFS[nx][5]
			    
			    	lTemItem := .T.		    			
			           
					aLinha :={	{"D2_COD" 		,Avkey(Alltrim(aDFS[k][5]),"D2_COD")				,Nil},;
								{"D2_QUANT"		,Val(StrTran(Alltrim(aDFS[k][7]),",","."))			,NIL},;		    
								{"D2_PRCVEN"	,Val(StrTran(Alltrim(aDFS[k][8]),",","."))			,NIL},;		    
								{"D2_TOTAL"		,Val(StrTran(Alltrim(aDFS[k][9]),",","."))			,NIL},;		    
								{'D2_VALIPI'	,Val(StrTran(Alltrim(aDFS[k][22]),",","."))			,NIL},;		    
								{'D2_VALICM'	,Val(StrTran(Alltrim(aDFS[k][19]),",","."))			,NIL},;		    
								{"D2_TES"		,Avkey(Alltrim("804"),"D2_TES")						,Nil},; 
								{"D2_CF"		,Avkey(Alltrim(aDFS[k][11]),"D2_CF")				,Nil},;  
								{'D2_IPI'		,Val(StrTran(Alltrim(aDFS[k][21]),",","."))			,NIL},;		    
								{'D2_PICM'		,Val(StrTran(Alltrim(aDFS[k][18]),",","."))			,NIL},;		    
								{'D2_BASEICM'	,Val(StrTran(Alltrim(aDFS[k][17]),",","."))			,NIL},;		    
								{'D2_PDV'		,Avkey(Alltrim(aImpFis[1][3]),"D2_PDV")				,NIL},;								
								{'D2_BASIMP5'	,Val(StrTran(Alltrim(aDFS[k][23]),",","."))			,NIL},;		    
								{'D2_BASIMP6'	,Val(StrTran(Alltrim(aDFS[k][24]),",","."))			,NIL},;		    
								{'D2_VALIMP5'	,Val(StrTran(Alltrim(aDFS[k][29]),",","."))			,NIL},;		    
								{'D2_VALIMP6'	,Val(StrTran(Alltrim(aDFS[k][30]),",","."))			,NIL},;		    
								{'D2_ALIQISS'	,Val(StrTran(Alltrim(aDFS[k][15]),",","."))			,NIL},;		    
								{'D2_BASEIPI'	,Val(StrTran(Alltrim(aDFS[k][20]),",","."))			,NIL},;		    
								{'D2_BASEISS'	,Val(StrTran(Alltrim(aDFS[k][14]),",","."))			,NIL},;		    
								{'D2_VALISS'	,Val(StrTran(Alltrim(aDFS[k][16]),",","."))			,NIL},;		    
								{'D2_ALQIMP5'	,Val(StrTran(Alltrim(aDFS[k][26]),",","."))			,NIL},;		    
								{'D2_ALQIMP6'	,Val(StrTran(Alltrim(aDFS[k][27]),",","."))			,NIL}}		    
					          
					aadd(aItens,aLinha)									
							
				Else
				
					If lTemItem			
				
						lMsErroAuto := .F.					
						
						MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItens,3)
						
						If lMsErroAuto
							cPath := GetTempPath()
							cArquivo := "ImpTXT.Log"
							MostraErro(cPath,cArquivo)
							cMsgRet += MemoRead(cPath+"\"+cArquivo)
							FErase(cPath+cArquivo)
							DisarmTransaction()
							//cMsgRet += "Inconsistencia de informa็๕es para Nota Fiscal de Saํda.NF: "+cNF+" - Serie: "+cSerie+CRLF
							lOk := .F.
						EndIf
						
						lTemItem := .F.
						aItens:= {}
						
					Else		
					    cMsgRet += "Sem Item.Inconsistencia de informa็๕es no arquivo para Nota Fiscal de Saํda.NF: "+cNF+" - Serie: "+cSerie+CRLF
						lOk := .F.
						lTemItem := .F.
						aItens:= {}					    
					EndIf
					
					Exit
					
				EndIf
						
			Next k
			
			nCont := k		 
		
		Next nx
		
		If lTemItem
		
			lMsErroAuto := .F. 
			
			MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItens,3)
			
			If lMsErroAuto
				cPath := GetTempPath()
				cArquivo := "ImpTXT.Log"
				MostraErro(cPath,cArquivo)
				cMsgRet += MemoRead(cPath+"\"+cArquivo)
				FErase(cPath+cArquivo)
				DisarmTransaction()
				//cMsgRet += "Inconsistencia de informa็๕es para Nota Fiscal de Saํda.NF: "+cNF+" - Serie: "+cSerie+CRLF
				lOk := .F.
			EndIf
		
		Else		
			cMsgRet += "Sem Item.Inconsistencia de informa็๕es no arquivo para Nota Fiscal de Saํda.NF: "+cNF+" - Serie: "+cSerie+CRLF
			lOk := .F.
			lTemItem := .F.		
		EndIf
		
	EndIf	

	RestArea(aArea)                   

Return
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GeraCUP() 

Local aArea		:= GetArea()
Local aCabec    := {}
Local aItens	:= {}   
Local aLinha    := {}
Local cCliente	:= ""
Local cLoja		:= "" 
Local nCont		:= 1
Local lTemItem  := .F.

Private lMsErroAuto := .F.

	If !Empty(aCUP)    

		ProcRegua(Len(aCUP))
		For nx:=1 to Len(aCUP)
		
			IncProc("Importando NFS...") 
			
			cCliente:= Posicione("SA1", 3, xFilial("SA1") + aCUP[nx][5],"A1_COD")		 
			cLoja 	:= Posicione("SA1", 3, xFilial("SA1") + aCUP[nx][5],"A1_LOJA")
			
			cNF    := Alltrim(aCUP[nx][2]) 
			cSerie := Alltrim(aCUP[nx][3])
								
			aCabec := { {"F2_TIPO"   	,"N"									,NIL},;
						{"F2_FORMUL" 	,"N"									,NIL},;
						{"F2_DOC"    	,Avkey(Alltrim(aCUP[nx][2]),"F2_DOC")	,NIL},;
						{"F2_SERIE" 	,Avkey(Alltrim(aCUP[nx][3]),"F2_SERIE")	,NIL},;
						{"F2_EMISSAO"	,aCUP[nx][1]							,NIL},;
						{"F2_CLIENTE"	,cCliente								,NIL},;
						{"F2_LOJA"   	,cLoja									,NIL},;
						{"F2_ESPECIE"	,"CF"									,NIL},;						
						{"F2_COND"		,"001"									,NIL},;
						{"F2_DESCONT"	,0										,NIL},;
						{"F2_FRETE"		,0										,NIL},;
						{"F2_SEGURO"	,0										,NIL},;
						{"F2_DESPESA"	,0										,NIL},;											
						{"F2_PDV"		,Avkey(Alltrim(aImpFis[1][3]),"F2_PDV")	,NIL},;
						{"F2_MAPA"		,Avkey(Alltrim(aCUP[nx][9]),"F2_MAPA")	,NIL},;					
						{"F2_ECF"		,"S"									,NIL}} 
									
			For k:=nCont to Len(aDUP) 
		    
			    If aDUP[k][1]+aDUP[k][2]+aDUP[k][3] == aCUP[nx][2]+aCUP[nx][3]+aCUP[nx][5]
			    
			    	lTemItem := .T.		    			
			           
					aLinha :={	{"D2_COD" 		,Avkey(Alltrim(aDUP[k][5]),"D2_COD")				,Nil},;
								{"D2_QUANT"		,Val(StrTran(Alltrim(aDUP[k][7]),",","."))			,NIL},;		    
								{"D2_PRCVEN"	,Val(StrTran(Alltrim(aDUP[k][8]),",","."))			,NIL},;		    
								{"D2_TOTAL"		,Val(StrTran(Alltrim(aDUP[k][9]),",","."))			,NIL},;		    
								{'D2_VALIPI'	,Val(StrTran(Alltrim(aDUP[k][22]),",","."))			,NIL},;		    
								{'D2_VALICM'	,Val(StrTran(Alltrim(aDUP[k][19]),",","."))			,NIL},;		    
								{"D2_TES"		,Avkey(Alltrim("787"),"D2_TES")						,Nil},; 
								{"D2_CF"		,Avkey(Alltrim(aDUP[k][11]),"D2_CF")				,Nil},;  
								{'D2_IPI'		,Val(StrTran(Alltrim(aDUP[k][21]),",","."))			,NIL},;		    
								{'D2_PICM'		,Val(StrTran(Alltrim(aDUP[k][18]),",","."))			,NIL},;		    
								{'D2_BASEICM'	,Val(StrTran(Alltrim(aDUP[k][17]),",","."))			,NIL},;		    
								{'D2_PDV'		,Avkey(Alltrim(aImpFis[1][3]),"D2_PDV")				,NIL},;								
								{'D2_BASIMP5'	,Val(StrTran(Alltrim(aDUP[k][23]),",","."))			,NIL},;		    
								{'D2_BASIMP6'	,Val(StrTran(Alltrim(aDUP[k][24]),",","."))			,NIL},;		    
								{'D2_VALIMP5'	,Val(StrTran(Alltrim(aDUP[k][29]),",","."))			,NIL},;		    
								{'D2_VALIMP6'	,Val(StrTran(Alltrim(aDUP[k][30]),",","."))			,NIL},;		    
								{'D2_ALIQISS'	,Val(StrTran(Alltrim(aDUP[k][15]),",","."))			,NIL},;		    
								{'D2_BASEIPI'	,Val(StrTran(Alltrim(aDUP[k][20]),",","."))			,NIL},;		    
								{'D2_BASEISS'	,Val(StrTran(Alltrim(aDUP[k][14]),",","."))			,NIL},;		    
								{'D2_VALISS'	,Val(StrTran(Alltrim(aDUP[k][16]),",","."))			,NIL},;		    
								{'D2_ALQIMP5'	,Val(StrTran(Alltrim(aDUP[k][26]),",","."))			,NIL},;		    
								{'D2_ALQIMP6'	,Val(StrTran(Alltrim(aDUP[k][27]),",","."))			,NIL}}		    
					          
					aadd(aItens,aLinha)									
							
				Else
				
					If lTemItem			
				
						lMsErroAuto := .F.					
											
						MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItens,3)
						
						If lMsErroAuto
							cPath := GetTempPath()
							cArquivo := "ImpTXT.Log"
							MostraErro(cPath,cArquivo)
							cMsgRet += MemoRead(cPath+"\"+cArquivo)
							FErase(cPath+cArquivo)
							DisarmTransaction()
							//cMsgRet += "Inconsistencia de informa็๕es para Cupom Fiscal.NF: "+cNF+" - Serie: "+cSerie+CRLF
							lOk := .F.
						EndIf
						
						lTemItem := .F.
						aItens:= {}
						
					Else		
					    cMsgRet += "Sem Item.Inconsistencia de informa็๕es no arquivo para Cupom Fiscal.NF: "+cNF+" - Serie: "+cSerie+CRLF
						lOk := .F.
						lTemItem := .F.
						aItens:= {}					    
					EndIf
					
					Exit
					
				EndIf
						
			Next k
			
			nCont := k		 
		
		Next nx
		
		If lTemItem
		
			lMsErroAuto := .F. 
			
			MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItens,3)
			
			If lMsErroAuto
				cPath := GetTempPath()
				cArquivo := "ImpTXT.Log"
				MostraErro(cPath,cArquivo)
				cMsgRet += MemoRead(cPath+"\"+cArquivo)
				FErase(cPath+cArquivo)
				DisarmTransaction()
				//cMsgRet += "Inconsistencia de informa็๕es para Cupom Fiscal.NF: "+cNF+" - Serie: "+cSerie+CRLF
				lOk := .F.
			EndIf
		
		Else		
			cMsgRet += "Sem Item.Inconsistencia de informa็๕es no arquivo para Cupom Fiscal.NF: "+cNF+" - Serie: "+cSerie+CRLF
			lOk := .F.
			lTemItem := .F.		
		EndIf
		
	EndIf	

	RestArea(aArea)

Return
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GeraZ01() 

	Local aArea:= GetArea()

	DbSelectArea("SFI")
	SFI->(DbSetOrder(1))
    
	If !Empty(aZ01)
		
		ProcRegua(Len(aZ01))
		For i:=1 to Len(aZ01)
		
			IncProc("Importando Z01...")   
			
			SFI->(DbGoTop())
			
			If SFI->(!DbSeek(xFilial("SFI")+DTOS(aZ01[i][1])+StrZero(Val(Avkey(Alltrim(aImpFis[1][3]),"FI_PDV")),6)+cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMREDZ"))))) 
			
				If RecLock("SFI",.T.)				
					
					SFI->FI_FILIAL	:= xFilial("SFI")
					SFI->FI_DTMOVTO	:= aZ01[i][1]					 
					SFI->FI_NUMERO	:= StrZero(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMERO")),6) 
					SFI->FI_PDV     := StrZero(Val(Avkey(Alltrim(aImpFis[1][3]),"FI_PDV")),6) 					
					SFI->FI_SERPDV  := Avkey(Alltrim(aImpFis[1][2]),"FI_SERPDV") 					
					SFI->FI_NUMREDZ := cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMREDZ"))) 
					SFI->FI_GTINI   := Val(StrTran(Alltrim(aZ01[i][5]),",","."))
					SFI->FI_GTFINAL := Val(StrTran(Alltrim(aZ01[i][6]),",","."))
					SFI->FI_NUMINI  := cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMINI"))) 
					SFI->FI_NUMFIM  := cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMFIM"))) 
					SFI->FI_COO		:= cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_COO"))) 				
					SFI->FI_CRO     := '2' 				   					
					SFI->FI_DTREDZ  := aZ01[i][1]				 
					
					SFI->(MsUnlock())
				
				EndIf 
			Else
				
				If RecLock("SFI",.F.)				
					
					SFI->FI_FILIAL	:= xFilial("SFI")
					SFI->FI_DTMOVTO	:= aZ01[i][1]					 
					SFI->FI_NUMERO	:= StrZero(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMERO")),6) 
					SFI->FI_PDV     := StrZero(Val(Avkey(Alltrim(aImpFis[1][3]),"FI_PDV")),6) 					
					SFI->FI_SERPDV  := Avkey(Alltrim(aImpFis[1][2]),"FI_SERPDV") 					
					SFI->FI_NUMREDZ := cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMREDZ"))) 
					SFI->FI_GTINI   := Val(StrTran(Alltrim(aZ01[i][5]),",","."))
					SFI->FI_GTFINAL := Val(StrTran(Alltrim(aZ01[i][6]),",","."))
					SFI->FI_NUMINI  := cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMINI"))) 
					SFI->FI_NUMFIM  := cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMFIM"))) 
					SFI->FI_COO		:= cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_COO"))) 				
					SFI->FI_CRO     := '2' 				   					
					SFI->FI_DTREDZ  := aZ01[i][1]				 
					
					SFI->(MsUnlock())
				
				EndIf
				//cMsgRet += "Registro de Redu็ใo Z jแ existente.Data Movimento: "+DTOC(aZ01[i][1])+" - PDV: "+StrZero(Val(Avkey(Alltrim(aImpFis[1][3]),"FI_PDV")),6)+" - Redu็ใo Z: "+cValtoChar(Val(Avkey(Alltrim(aZ01[i][4]),"FI_NUMREDZ")))+CRLF              
				//lOk := .F.	
			EndIf
		
		Next i
	
	EndIf	

	RestArea(aArea)

Return 
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function AtuTabs()

	Local cQuery := "" 

	//--Atualiza SF3
	
	//cQuery := " SELECT F3_ECF, * " + CRLF
	cQuery := " UPDATE SF3020 SET F3_PDV = '"+StrZero(Val(Avkey(Alltrim(aImpFis[1][3]),"F3_PDV")),6)+"', F3_ECF = 'S'  " + CRLF 	
	//cQuery := " UPDATE SF3020 WHERE F3_PDV = '000001', F3_ECF = 'S'  " + CRLF 
	//cQuery += " FROM SF3020  " + CRLF
	cQuery += " WHERE F3_ESPECIE = 'CF'  " + CRLF
	//cQuery += " AND F3_FILIAL = '07'  " + CRLF
	cQuery += " AND F3_FILIAL = '"+xFilial("SF3")+"'  " + CRLF
	cQuery += " AND F3_PDV = ''  " + CRLF
	cQuery += " AND D_E_L_E_T_ = ''  " + CRLF
	
	If TcSqlExec(cQuery) <> 0
		cMsgRet += "Erro ao atualizar PDV e ECF para a tabela SF3."+CRLF
		lOk := .F.
	EndIf	

	//--ATUALIZA TABELA SFT  
	
	//cQuery := " SELECT *  " + CRLF
	cQuery := " UPDATE SFT020 SET FT_PDV = '"+StrZero(Val(Avkey(Alltrim(aImpFis[1][3]),"FT_PDV")),6)+"'  " + CRLF   
	//cQuery := " UPDATE SFT020 WHERE FT_PDV = '000001'  " + CRLF
	//FROM SFT020  " + CRLF
	cQuery += " WHERE FT_ESPECIE = 'CF'  " + CRLF
	//cQuery += " AND FT_FILIAL = '07'  " + CRLF 
	cQuery += " AND FT_FILIAL = '"+xFilial("SFT")+"'  " + CRLF
	cQuery += " AND FT_PDV = ''  " + CRLF
	cQuery += " AND D_E_L_E_T_ = ''  " + CRLF
    
	If TcSqlExec(cQuery) <> 0
		cMsgRet += "Erro ao atualizar PDV para a tabela SFT."+CRLF
		lOk := .F.
	EndIf
    
	/*
	//--ATUALIZA TABELA SF2
	
	//cQuery := " SELECT *  " + CRLF
	cQuery := " UPDATE SF2020 WHERE F2_PDV = '000001', F2_ECF = 'S'  " + CRLF
	//cQuery += " FROM SF2020  " + CRLF
	cQuery += " WHERE F2_ESPECIE = 'CF'  " + CRLF
	cQuery += " AND F2_FILIAL = '07'  " + CRLF
	cQuery += " AND F2_PDV = ''  " + CRLF
	cQuery += " AND D_E_L_E_T_ = ''  " + CRLF
    
	If TcSqlExec(cQuery) <> 0
		cMsgRet += "Erro ao atualizar PDV e ECF para a tabela SF2."
		lOk := .F.
	EndIf*/
    
	/*
	//--ATUALIZA TABELA SD2  
	
	//cQuery := " SELECT *  " + CRLF
	cQuery := " UPDATE SD2020 WHERE D2_PDV = '000001'  " + CRLF
	//cQuery += " FROM SD2020 SD2  " + CRLF
	cQuery += " LEFT JOIN SF2020 SF2 ON ( F2_FILIAL+F2_DOC+F2_SERIE = D2_FILIAL+D2_DOC+D2_SERIE )  " + CRLF
	cQuery += " WHERE  D2_FILIAL = '07'  " + CRLF
	cQuery += " AND D2_PDV = ''  " + CRLF
	cQuery += " AND SD2.D_E_L_E_T_ = ''  " + CRLF
    
	If TcSqlExec(cQuery) <> 0
		cMsgRet += "Erro ao atualizar PDV para a tabela SD2."
		lOk := .F.
	EndIf*/

	//--Atualiza cadastro da impressora fiscal
	
	/*cQuery := " UPDATE SLG020 SET LG_IMPFISC = 'DARUMA FS2000 - V. 01.00',  " + CRLF
	cQuery += " LG_PORTIF = 'COM1',  " + CRLF
	cQuery += " LG_IMPTEF = 'N',  " + CRLF
	cQuery += " LG_IMPTEFC = 'N',  " + CRLF
	cQuery += " LG_TIPTEF = '1',  " + CRLF
	cQuery += " LG_TEFCONS = 'NNNNNNN',  " + CRLF
	cQuery += " LG_RPCINT = '0',  " + CRLF
	cQuery += " LG_INTCNS = 'F',  " + CRLF
	cQuery += " LG_SERIE = '001',  " + CRLF
	cQuery += " LG_PDV = '000001',  " + CRLF
	cQuery += " LG_TERMTEF = '0',  " + CRLF
	cQuery += " LG_GAVSTAT = 'F',  " + CRLF
	cQuery += " LG_CRDIMP = '1',  " + CRLF
	cQuery += " LG_CRDVIAS = '0',  " + CRLF
	cQuery += " LG_CRDXINT = '2',  " + CRLF
	cQuery += " LG_REDES = '000',  " + CRLF
	cQuery += " LG_TAMSER = '6',  " + CRLF
	cQuery += " LG_TIPTELA = '0',  " + CRLF
	cQuery += " LG_SERPDV = 'DR0813BR000000389263',  " + CRLF
	cQuery += " LG_LARGCOL = 40  " + CRLF
	cQuery += " WHERE LG_FILIAL = '07'  " + CRLF
    
	If TcSqlExec(cQuery) <> 0
		cMsgRet += "Erro ao atualizar o cadastro de impressora fiscal."
		lOk := .F.
	EndIf*/
	
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณIpTxtGcom บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function ShowErr(cTitle,cMsgError)
Local oBtFechar
Local oLstErr
Local nLstErr := 1
Local oDlg
Default cTitle := "Registros nใo importados"

  DEFINE MSDIALOG oDlg TITLE cTitle FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL
    
    @ 228, 180 BUTTON oBtFechar PROMPT "Fechar" Action(oDlg:End()) SIZE 059, 013 OF oDlg PIXEL    
    
    oLstErr:= TMULTIGET():New(011,008,{|u|if(Pcount()>0,cMsgError:=u,cMsgError)},oDlg,230,200,,.F.,,,,.T.,,,,,,,,,,,.T.)    

  ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)

/*
Transform(Val(Substr(cLinha,121,14)), "@E 99999999999.99"),;   //Base de cแlculo do ISS
Transform(Val(Substr(cLinha,135,5)), "@E 99.99"),;             //Alํquota ISS
Transform(Val(Substr(cLinha,140,14)), "@E 99999999999.99"),;   //Valor do ISS
Transform(Val(Substr(cLinha,154,16)), "@E 9999999999999.99"),; //Base de cแlculo do ICMS
Transform(Val(Substr(cLinha,170,5)), "@E 99.99"),;             //Alํquota ICMS
Transform(Val(Substr(cLinha,175,14)), "@E 99999999.99999"),;   //Valor do ICMS
Transform(Val(Substr(cLinha,189,14)), "@E 99999999999.99"),;   //Base de cแlculo do IPI
Transform(Val(Substr(cLinha,203,5)), "@E 99.99"),;             //Alํquota IPI
Transform(Val(Substr(cLinha,208,14)), "@E 99999999.99999"),;   //Valor do IPI 
Transform(Val(Substr(cLinha,222,14)), "@E 99999999999.99"),;   //Base PIS
Transform(Val(Substr(cLinha,236,14)), "@E 99999999999.99"),;   //Base COFINS
Transform(Val(Substr(cLinha,250,14)), "@E 99999999999.99"),;   //Base CSLL
Transform(Val(Substr(cLinha,264,6)), "@E 999.99"),;            //Alํquota PIS
Transform(Val(Substr(cLinha,270,6)), "@E 999.99"),;            //Alํquota COFINS
Transform(Val(Substr(cLinha,276,6)), "@E 999.99"),;            //Alํquota CSLL
Transform(Val(Substr(cLinha,282,14)), "@E 99999999999.99"),;   //Valor PIS
Transform(Val(Substr(cLinha,296,14)), "@E 99999999999.99"),;   //Valor COFINS
Transform(Val(Substr(cLinha,310,14)), "@E 99999999999.99"),;   //Valor CSLL
Transform(Val(Substr(cLinha,324,14)), "@E 99999999999.99"),;   //Base Substitui็ใo Tributแria 			
Transform(Val(Substr(cLinha,338,14)), "@E 99999999999.99"),;   //Valor da substitui็ใo tributaria		
Substr(cLinha,352,10),;		                                  //N๚mero do PDV que efetuou a venda.
Substr(cLinha,362,10),;		                                  //N๚mero MAPA
Substr(cLinha,372,1);		                                  //Status*/ 




/*		    
SFI->FI_FILIAL	:= xFilial("SFI")
SFI->FI_DTMOVTO	:= aZ01[i][1]					 
SFI->FI_NUMERO	:= Avkey(Alltrim(aZ01[i][2]),"FI_NUMERO") 
SFI->FI_PDV     := Avkey(Alltrim(aImpFis[1][3]),"FI_PDV") 					
SFI->FI_SERPDV  := Avkey(Alltrim(aImpFis[1][2]),"FI_SERPDV") 					
SFI->FI_NUMREDZ := Avkey(Alltrim(aZ01[i][4]),"FI_NUMREDZ") 
SFI->FI_GTINI   := Val(StrTran(Alltrim(aZ01[i][5]),",","."))
SFI->FI_GTFINAL := Val(StrTran(Alltrim(aZ01[i][6]),",","."))
SFI->FI_NUMINI  := Avkey(Alltrim(aZ01[i][7]),"FI_NUMINI") 
SFI->FI_NUMFIM  := Avkey(Alltrim(aZ01[i][8]),"FI_NUMFIM") 
SFI->FI_CANCEL  := Val(StrTran(Alltrim(aZ01[i][9]),",","."))					
SFI->FI_VALCON	:= Val(StrTran(Alltrim(aZ01[i][10]),",","."))					
SFI->FI_SUBTRIB := Val(StrTran(Alltrim(aZ01[i][11]),",",".")) 					
SFI->FI_DESC 	:= Val(StrTran(Alltrim(aZ01[i][12]),",","."))
SFI->FI_ISENTO 	:= Val(StrTran(Alltrim(aZ01[i][13]),",","."))					
SFI->FI_NTRIB 	:= Val(StrTran(Alltrim(aZ01[i][14]),",","."))
SFI->FI_BAS7    := Val(StrTran(Alltrim(aZ01[i][15]),",","."))
SFI->FI_BAS12	:= Val(StrTran(Alltrim(aZ01[i][16]),",","."))
SFI->FI_BAS18	:= Val(StrTran(Alltrim(aZ01[i][17]),",","."))
SFI->FI_BAS25	:= Val(StrTran(Alltrim(aZ01[i][18]),",","."))
SFI->FI_COO		:= Avkey(Alltrim(aZ01[i][19]),"FI_COO") 				
SFI->FI_ISS     := Val(StrTran(Alltrim(aZ01[i][20]),",","."))
SFI->FI_CRO     := Avkey(Alltrim(aZ01[i][21]),"FI_CRO") 				   
   	SFI->FI_OBS		:= Avkey(Alltrim(aZ01[i][22]),"FI_OBS") 					
SFI->FI_DTREDZ  := aZ01[i][23]
SFI->FI_HRREDZ  := Avkey(Alltrim(aZ01[i][24]),"FI_HRREDZ")*/