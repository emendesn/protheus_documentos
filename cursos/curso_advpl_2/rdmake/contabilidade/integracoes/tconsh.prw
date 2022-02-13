#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function Tconsh()

Private cGet2 := SPACE(4)
Private cGet3 := SPACE(2)

SetPrvt("oDlg1","oSay1","oSay2","oSay3","oBtn1","oBtn2")


oDlg1	:= MSDialog():New( 088,232,312,672,"oDlg1",,,.F.,,,,,,.T.,,,.T. )

oSay1	:= TSay():New( 008,060,{||"Agendamento de execução do CONSHARE"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)
oSay2	:= TSay():New( 037,060,{||"Informe o Ano:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay3	:= TSay():New( 061,060,{||"Informe o Mês:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)

oGet2	:= TGet():New( 036,100,{|u| if(pcount()>0,cGet2:=u,cGet2)},oDlg1,030,008,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",cGet2,,)
oGet3	:= TGet():New( 060,100,{|u| if(pcount()>0,cGet3:=u,cGet3)},oDlg1,020,008,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",cGet3,,)

oBtn1	:= TButton():New( 084,100,"Agendar !",oDlg1,{||u_cosh(cGet2,cGet3)},037,012,,,,.T.,,"",,,,.F. )
oBtn2	:= TButton():New( 084,152,"Sair !",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return



User Function cosh(cGet2,cGet3)

Local CcGet1:= GetMV("ZZ_COSH001",.F.)
Local CcGet2:= cGet2 //Ano
Local CcGet3:= cGet3 //Mes

IF !CcGet1
	PUTMV("ZZ_COSH001",.T.)
	PUTMV("ZZ_COSH002", CcGet2)
	PUTMV("ZZ_COSH003", Ccget3)
	
	MSGINFO("Execução agendada com sucesso aguarde o término da execução e acompanhe o recebimento do status")
	
	oDlg1:end()
	
else
	Alert("A execução do relatório encontra-se agendada. Aguarde o recebimento do status para novo agendamento !")	
	
	oDlg1:end()
	
Endif

Return