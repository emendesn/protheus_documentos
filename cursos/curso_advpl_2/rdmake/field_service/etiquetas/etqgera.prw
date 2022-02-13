#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EtqGera   º Autor ³Paulo Lopez         º Data ³  02/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³IMPRIME ETIQUETA MASTER                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function EtqGera()

Private oDlgMass
Private _cNumEtq		:= Space(12) 
Private _ocodimei		:= '1'  
Private _lRet			:= .F.
Private CPERG           := "TIPMAS" 
Private _center         := CHR(10)+CHR(13)

u_GerA0003(ProcName())

CRIASX1()
PERGUNTE(CPERG,.T.)                 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da janela e seus conteudos                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgMass TITLE "Etiquetas Master" FROM 0,0 TO 210,420 OF oDlgMass PIXEL

//@ 010,015 SAY   "Informe o Numero Master para Impressão." 	SIZE 150,008 PIXEL OF oDlgMass
@ 035,015 TO 070,180 LABEL "Master" PIXEL OF oDlgMass
@ 045,025 GET _cNumEtq PICTURE "@!" 	SIZE 080,010 Valid U_EtqGera1(@_cNumEtq,_ocodimei,strzero(mv_par01,1)) Object ocodimei

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Botoes da MSDialog                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//@ 080,140 BUTTON "&CANCELAR" SIZE 36,16  PIXEL ACTION (oDlgMass:End())
@ 080,140 BUTTON "Sai&r"       SIZE 036,012 ACTION oDlgMass:End() OF oDlgMass PIXEL

Activate MSDialog oDlgMass CENTER

return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EtqGera1  º Autor ³Paulo Lopez         º Data ³  02/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³IMPRIME ETIQUETA MASTER                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function EtqGera1(_cNumEtq,_ocodimei,_cmodetq)

Local datab		:= dDataBase
Local hora		:= Time()
Local cPorta	:= "LPT1"
Local _aDados	:= {}
Local _cQry       
Local _ocodimei
Local _lRet		:= .F.
lOCAL _nqtdetq  := 0
Local cstatus   := ""
Local cstante   := ""




If !IsPrinter(cPorta)
	If _ocodimei == '1'
		_cNumEtq:=SPACE(12)
		ocodimei:SetFocus()
		Return
  	Else
		Return
	Endif
Endif     



If _ocodimei == '1' .And. Empty(AllTrim(_cNumEtq))
	Return()
EndIf


_cNumEtq := TransForm(_cNumEtq,"@E 999999999999")             

//If  Empty(AllTrim(_cNumEtq))
//    MsgBox("Etiqueta invalida ou nao preenchida","ALERT")
//	Return()
//EndIf



If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

_cQry	:= " SELECT DISTINCT ZZ4.ZZ4_IMEI IMEI, ZZ4.ZZ4_CARCAC CARC, ZZ4.ZZ4_CARDU CARDU, ZZ4.ZZ4_CODPRO CODPRO, ZZ4.ZZ4_ETQMAS ETQ, ZZ4.ZZ4_OPEBGH OPERA, SA1.A1_EST EST,ZZ4_FASATU,ZZ4_SETATU,ZZ4.ZZ4_OS AS OS, "
_cQry	+= " ZZ4.ZZ4_GARANT GARANT,SA1.A1_NREDUZ NOMEREDUZ "
_cQry	+= " FROM " + RetSqlName("ZZ4") + " AS ZZ4  WITH(NOLOCK)"
_cQry	+= " INNER JOIN " + RetSQlName("SA1") + " AS SA1 WITH(nolock) "
_cQry	+= " ON(ZZ4.ZZ4_CODCLI = SA1.A1_COD AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA AND A1_FILIAL = '  ') "
_cQry	+= " WHERE ZZ4.D_E_L_E_T_ = '' "
_cQry	+= " AND ZZ4_FILIAL='" + xFilial("ZZ4") + "' "
_cQry	+= " AND ZZ4.ZZ4_ETQMAS = '" +_cNumEtq + "' "
//_cQry	+= " AND ZZ4.ZZ4_STATUS <= '5' "
_cQry	+= " ORDER BY ZZ4.ZZ4_IMEI "

MemoWrite("c:\master1.sql", _cQry)

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Grava dados no Array                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QRY")
dbGoTop()

While !EOF("QRY")                                      
	ZZJ->(dbsetOrder(1)) // ZZJ_FILIAL + ZZJ_OPEBGH+ ZZJ_LAB
	ZZJ->(dbseek(xFilial("ZZJ")+ QRY->OPERA))
    _cvalfas := ZZJ->ZZJ_VLSFAS  
    _clab    := ZZJ->ZZJ_LAB
    _nqtdetq++ 
	
	IF _cvalfas =='S' .AND. _nqtdetq==1
	      cstatus :=Statfase(_clab,QRY->IMEI,QRY->OS)
	      cstante :=cstatus            
	                                  
	Elseif _cvalfas =='S' .and. _nqtdetq > 1  
	      cstatus :=Statfase(_clab,QRY->IMEI,QRY->OS)
	      
    ENDIF
	
	IF  _cvalfas =='S' .and. cstatus == cstante .and. !empty(cstatus)  
	      aAdd(_aDados,{	QRY->IMEI, QRY->CARC, QRY->CARDU, QRY->CODPRO, QRY->ETQ, QRY->OPERA, QRY->EST,QRY->GARANT,QRY->NOMEREDUZ,cstatus })
	ELSE             
	  // IF _cvalfas =='S' .and. empty(cstatus)
	  IF  _cvalfas =='S' .and. cstatus != cstante
	        MsgBox("Status de reparo misturado nessa Master : '"+ALLTRIM(QRY->ETQ)+"', Favor verificar com seu superior.","Encerramento Master com problema","ALERT")
	        Return()
	   
	   Elseif _cvalfas =='S' .and. empty(cstatus) 
            MsgBox("Não foi encontrar Fase configuradas com Status Status de reparo, Favor verificar com seu superior.","Encerramento Master com problema","ALERT")	        
  	        Return()
	   ELSE
	      aAdd(_aDados,{	QRY->IMEI, QRY->CARC, QRY->CARDU, QRY->CODPRO, QRY->ETQ, QRY->OPERA, QRY->EST,QRY->GARANT,QRY->NOMEREDUZ,cstatus })

	   ENDIF
	ENDIF      
	      
	
	dbSelectArea("QRY")
	dbSkip()
EndDo

QRY->(dbCloseArea())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estrutura da Matriz                                                         ³
		//³ 01 - Modelo                                                                 ³
		//³ 02 - Etiqueta                                                               ³
		//³ 03 - Data Hora                                                              ³
		//³ 04 - Operacao                                                               ³
		//³ 05 - Qtd Etiqueta                                                           ³
		//³ 06 - Local Dev.                                                             ³
		//³ 07 - IMEI                                                                   ³
		//³ 07 - Card-U                                                                 ³
		//³ 08 - GARANTIA                                                               ³
		//³ 09 - NOME CLIENTE REDUZIDO                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if len(_aDados) <= 0
   _lRet:=.f.
   apMsgStop("Não foi encontrado dados para geração da Etiqueta. Contate o Administrado do sistema.")
   return(_lRet)
Endif


If _cmodetq == "1"
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Layout da Etiqueta                              ³
		//³ Ú---------------------------------------------¿ ³
		//³ | Modelo     | Num Etq          | Data / Hora | ³
		//³ | --------------------------------------------| ³
		//³ | Operacao   | Qtd Equip        | Local       ³ ³
		//³ | --------------------------------------------³ ³
		//³ | IMEI      CARD-U           IMEI    CARD-U   ³ ³
		//³ |                                             | ³
		//³ À---------------------------------------------Ù ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processa impressao                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSCBPRINTER("Z90XI",cPorta,,22,.F.,,,,,,.T.)
		
		MSCBCHKSTATUS(.F.)
		
		MSCBBEGIN(1,6)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Primeira Linha                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MSCBBOX(002,007,075,030,4)
		MSCBSAY(003,009,"Data ","N","0","065,075",.T.)
		MSCBSAY(019,019,Transform(datab, "@E 99/99/99") + " - "+ (hora),"N","0","065,075",.T.)
		//MSCBBOX(075,007,130,030,4)
		//MSCBSAY(076,009,"Data","N","0","065,075",.T.)
		//MSCBSAY(077,019,Transform(datab, "@E 99/99/99") + " - "+ (hora),"N","0","065,075",.T.)
		//MSCBBOX(130,007,198,030,4)
		//MSCBSAY(131,009,"Etq. Master ","N","0","065,075",.T.)
		//MSCBSAY(131,019,TransForm(_aDados[1,5], "@E 999999999999"),"N","0","065,075",.T.)
		MSCBBOX(075,007,198,030,4)
		MSCBSAY(076,009,"Modelo :  ","N","0","065,075",.T.)
		//MSCBSAY(077,019,TransForm(_aDados[1,5], "@E 999999999999"),"N","0","065,075",.T.)         
		MSCBSAYBAR	(085,019,AllTrim(_aDados[1,4]),"N","MB07",5,.F.,.T.,.T.,,7,2)
		 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Segunda Linha                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSCBBOX(002,030,075,048,4)
		MSCBSAY(003,031,"Local Dest. ","N","0","065,075",.T.)
		MSCBSAY(025,039,AllTrim(_aDados[1,7]),"N","0","085,095",.T.)
		MSCBBOX(075,030,130,048,4)
		MSCBSAY(076,031,"Qtd. Etq. ","N","0","065,075",.T.)
		MSCBSAY(086,039,"20","N","0","065,075",.T.)
		MSCBBOX(130,030,198,048,4)
		MSCBSAY(131,031,"Operacao: ","N","0","065,075",.T.)
		MSCBSAY(145,039,AllTrim(_aDados[1,6]),"N","0","065,075",.T.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Terceira Linha - IMEI - CARD-U     				             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSCBSAY(040,050,"IMEI ","N","0","065,075",.T.)
		MSCBSAY(140,050,"CARD-U ","N","0","065,075",.T.)
		
		_nLin := 3
		
		For X := 1 to len(_aDados)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| Terceira Linha - IMEI                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			MSCBSAYBAR	(004,039 + 2*(X +(4*_nLin)-2),IIF(Alltrim(_aDados[X,6])=="P01",_aDados[X,2],_aDados[X,1]),"N","MB07",5,.F.,.T.,.T.,,4,2)
			//MSCBSAYBAR	(004,039 + 2*(X +(4*_nLin)-2),_aDados[X,1],"N","MB07",5,.F.,.T.,.T.,,4,2)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| Terceira Linha - CARD-U  				                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			MSCBSAYBAR	(115,039 + 2*(X +(4*_nLin)-2),_aDados[X,3],"N","MB07",5,.F.,.T.,.T.,,4,2)
			
			_nLin ++
			
		next X
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Quarta Linha Etiqueta Master                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSCBSAYBAR	(050,270,TransForm(_aDados[1,5], "@E 999999999999"),"N","MB07",6,.F.,.T.,.T.,,8,2)
		MSCBSAY		(085,277,"Etiqueta Master ","N","0","055,065",.T.)
		
		MSCBEND()
		
		MSCBCLOSEPRINTER()
Elseif  _cmodetq == "2" 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Layout da Etiqueta                              ³
		//³ Ú---------------------------------------------¿ ³
		//³ | Data / hora|  Garatia / fora de garantia    | ³
		//³ | --------------------------------------------| ³
		//³ | Cliente    | Qtd Equip        | Operacao    ³ ³
		//³ | --------------------------------------------³ ³
		//³ | NUM SERIE               MODELO              ³ ³
		//³ |                                             | ³
		//³ À---------------------------------------------Ù ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processa impressao                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSCBPRINTER("Z90XI",cPorta,,144,.F.,,,,,,.T.)
		
		MSCBCHKSTATUS(.F.)
		
		MSCBBEGIN(1,6)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Primeira Linha                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MSCBBOX(002,003,055,015,4)
		MSCBSAY(003,006,"Data ","N","0","030,040",.T.)
		MSCBSAY(012,006,Transform(datab, "@E 99/99/99") + " - "+ (hora),"N","0","030,040",.T.)
		//MSCBBOX(075,007,130,030,4)
		//MSCBSAY(076,009,"Data","N","0","065,075",.T.)
		//MSCBSAY(077,019,Transform(datab, "@E 99/99/99") + " - "+ (hora),"N","0","065,075",.T.)
		//MSCBBOX(130,007,198,030,4)
		//MSCBSAY(131,009,"Etq. Master ","N","0","065,075",.T.)
		//MSCBSAY(131,019,TransForm(_aDados[1,5], "@E 999999999999"),"N","0","065,075",.T.)
		MSCBBOX(055,003,098,015,4)
		MSCBSAY(056,006,"Gar:","N","0","030,040",.T.)
		//MSCBSAY(077,019,TransForm(_aDados[1,5], "@E 999999999999"),"N","0","065,075",.T.)         
		//MSCBSAYBAR	(075,006,IIF(AllTrim(_aDados[1,4])=="S","SIM","NAO"),"N","MB07",2,.F.,.T.,.T.,,2,4)
        MSCBSAY(063,006,IIF(AllTrim(_aDados[1,8])=="S","SIM","NAO")  ,"N","0","030,035",.T.)
        MSCBSAY(072,006,"Status:","N","0","030,040",.T.)		 
        MSCBSAY(082,006,AllTrim(_aDados[1,10])  ,"N","0","025,035",.T.)		 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Segunda Linha                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSCBBOX(002,009,055,015,4)
		MSCBSAY(003,011,"Local Dest.","N","0","030,040",.T.)
		MSCBSAY(018,011,AllTrim(_aDados[1,9]),"N","0","029,038",.T.)
		MSCBBOX(055,009,075,015,4)
		MSCBSAY(056,010,"Qtd. Etq. ","N","0","030,040",.T.)
		MSCBSAY(069,010,strzero(_nqtdetq,2),"N","0","030,040",.T.)
		MSCBBOX(070,003,098,009,4)
		MSCBSAY(076,010,"Operacao: ","N","0","030,040",.T.)
		MSCBSAY(090,010,AllTrim(_aDados[1,6]),"N","0","030,040",.T.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Terceira Linha - IMEI - CARD-U     				             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSCBSAY(016,015,"NUM SERIE ","N","0","030,040",.T.)
		MSCBSAY(067,015,"MODELO ","N","0","030,040",.T.)
		
		_nLin := 3
		
		For X := 1 to len(_aDados)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| Terceira Linha - IMEI                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			MSCBSAYBAR	(004,014 + 1.6*(X +(2*_nLin)-3),IIF(Alltrim(_aDados[X,6])=="P01",_aDados[X,2],_aDados[X,1]),"N","MB07",2,.F.,.T.,.T.,,2,1)
			//MSCBSAYBAR	(004,014 + 1.6*(X +(2*_nLin)-3),_aDados[X,1],"N","MB07",2,.F.,.T.,.T.,,2,1)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| Terceira Linha - CARD-U  				                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			MSCBSAYBAR	(060,014 + 1.6*(X +(2*_nLin)-3),_aDados[X,4],"N","MB07",2,.F.,.T.,.T.,,2,1)
			
			_nLin ++
			
		next X
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Quarta Linha Etiqueta Master                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSCBSAYBAR	(033,136,TransForm(_aDados[1,5], "@E 999999999999"),"N","MB07",2,.F.,.T.,.T.,,3,1)
		MSCBSAY		(045,138,"Etiqueta Master ","N","0","025,035",.T.)
		
		MSCBEND()
		
		MSCBCLOSEPRINTER()
Endif


If _ocodimei == '1'
	
	_cNumEtq:=SPACE(12)
   	ocodimei:SetFocus()
EndIf
            
_lRet := .T.  

Return(_lRet)                                    



Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Etiqueta Master ?","Etiqueta Master ?","Etiqueta Master ?","mv_ch1","N",01,0,0,"C","",""	,"",,"mv_par01","Nextel-Card-u"	,"","","","Informatica"		,"","",""	,"","","","","","","","")

Return Nil


Static function Statfase(_clab,cimei,cos)

Local qry := "" 
Local _cstatus := "" 

If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf

qry:=" SELECT ZZ3_FILIAL,ZZ3_NUMOS,ZZ3_IMEI,ZZ3_FASE1,ZZ3_CODSET,ZZ1_STFIMP AS STATUSFAS,DESCSTATUS=CASE WHEN ZZ1_STFIMP='1' THEN 'SCRAP' WHEN ZZ1_STFIMP='2' THEN 'REPARADO' WHEN ZZ1_STFIMP='3' THEN 'DSR' ELSE '' END "+_center
qry+=" FROM " + RetSqlName("ZZ3") + " (NOLOCK) "+_center 
qry+=" INNER JOIN "+_center
qry+=" (SELECT ZZ1_STFIMP,ZZ1_FASE1,ZZ1_CODSET,ZZ1_LAB  FROM " + RetSqlName("ZZ1") + " (NOLOCK) WHERE D_E_L_E_T_='' AND ZZ1_FILIAL='" + xFilial("ZZ1") + "' AND ZZ1_STFIMP<>'') AS ZZ1 "+_center
qry+=" ON ZZ3_LAB=ZZ1_LAB AND ZZ3_FASE1=ZZ1_FASE1 AND ZZ3_CODSET=ZZ1_CODSET "+_center
qry+=" WHERE ZZ3_FILIAL='" + xFilial("ZZ3") + "' AND ZZ3_NUMOS='"+cos+"' AND ZZ3_IMEI='"+cimei+"' AND ZZ3_ENCOS='S' AND ZZ3_ESTORN<>'S' AND D_E_L_E_T_='' "+_center


dbUseArea(.T., "TOPCONN", TCGenQry(,, qry), "QRY2", .F., .T.)

dbSelectArea("QRY2")
dbGoTop()

While !EOF("QRY2")
   IF !EMPTY(QRY2->DESCSTATUS)
       _cstatus :=QRY2->DESCSTATUS     
   ELSE   
      apMsgStop("Fase/Setor : '"+ALLTRIM(QRY2->ZZ3_FASE1)+"/"+ALLTRIM(QRY2->ZZ3_CODSET)+"' apontado nao esta classificado o status de reparo para impressao da etiqueta. Favor corrigir a fase e tentar a re-impressao da etiqueta. Contate seu supervisor.")
      exit
   ENDIF 
   
   dbSelectArea("QRY2")
   dbSkip()
Enddo

Return(_cstatus) 



