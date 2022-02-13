#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TCONSH   º Autor ³ CARLOS VIEIRA        º Data ³OUTUBRO/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Prgrama que verifica constantemente o parâmetro TQRZZ9 paraº±±
±±º          ³ execução da rotina de integração entre emp. CONSHARE       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function ARR01()

Private cGet1 := SPACE(2) //filial
Private cGet2 := SPACE(9) //NF
Private cGet3 := SPACE(3) //SERIE
Private cGet4 := SPACE(6) //FORN
Private cGet5 := SPACE(2) //LOJA


SetPrvt("oDlg1","oSay1","oSay2","oSay3","oBtn1","oBtn2")


oDlg1      := MSDialog():New( 128,559,533,1000,"oDlg1",,,.F.,,,,,,.T.,,,.T. )

oSay1      := TSay():New( 032,064,{||"Filial"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 052,064,{||"NF"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 072,064,{||"Série"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay4      := TSay():New( 092,064,{||"Fornecedor"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 112,064,{||"Loja"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGet1      := TGet():New( 032,116,{|u| if(pcount()>0,cGet1:=u,cGet1)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",cGet1,,)
oGet2      := TGet():New( 052,116,{|u| if(pcount()>0,cGet2:=u,cGet2)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",cGet2,,)
oGet3      := TGet():New( 072,116,{|u| if(pcount()>0,cGet3:=u,cGet3)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",cGet3,,)
oGet4      := TGet():New( 092,116,{|u| if(pcount()>0,cGet4:=u,cGet4)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",cGet4,,)
oGet5      := TGet():New( 112,116,{|u| if(pcount()>0,cGet5:=u,cGet5)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",cGet5,,)
//oGet5      := TGet():New( 152,116,{|u| if(pcount()>0,cGet5:=u,cGet5)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",cGet5,,)
//oGet5      := TGet():New(  01,2  ,3                                  ,4    ,5  ,6  ,7 ,,9        ,10       ,,,,14 ,15,,,18 ,19 ,,21 ,22 ,23,24   ,,)
							

oBtn1	:= TButton():New( 180,100,"Arredondar !",oDlg1,{||arr02(@cGet1,@cGet2,@cGet3,@cGet4,@cGet5)},037,012,,,,.T.,,"",,,,.F. )
oBtn2	:= TButton():New( 180,152,"Sair !",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return



Static Function arr02(cGet1,cGet2,cGet3,cGet4,cGet5)

dbSelectArea("SD1")
SD1->(dbSetOrder(1))	//Filial+Doc+Serie+Fornece+Loja+Cod+Item
SD1->(dbGotop())

IF SD1->(dbSeek(cGet1 + cGet2 + cGet3 + cGet4 + cGet5,.T.))

	while !(SD1->(EOF())) .AND. SD1->D1_DOC == cGet2 .AND. ;
									SD1->D1_SERIE == cGet3 .AND. ;
									SD1->D1_FORNECE == cGet4 .AND. ;
									SD1->D1_LOJA == cGet5
						 
		IF (round((SD1->D1_QUANT * SD1->D1_VUNIT),2)- SD1->D1_TOTAL ) > 0.01 .OR. ;
					(SD1->D1_TOTAL - round((SD1->D1_QUANT * SD1->D1_VUNIT),2)) > 0.01
			
			SD1->(RecLock("SD1",.F.))
			
			SD1->D1_TOTAl := round((SD1->D1_QUANT * SD1->D1_VUNIT),2)
			
			SD1->(MsUnlock())	
									
		Endif
		
		SD1->(DBskip())
			
	ENDDO

	MSGINFO("Arredondamento efetuado com sucesso !")
		
ELSE
	Alert("NF não encontrada, verifique a numeração e tente novamente")	
		
ENDIF

	oDlg1:end()

Return