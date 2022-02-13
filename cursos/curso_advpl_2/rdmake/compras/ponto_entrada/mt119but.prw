#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT119BUT ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  13/05/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada que inclui um botao na enchoice da Nota   º±±
±±º          ³ Fiscal de Entrada                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT119BUT()


Local aButtons := {} // Botoes a adicionar 
Local aRet := {}

	u_GerA0003(ProcName())

aAdd(aRet,{"D.I.", "U_DIImp()",0,5})

Return (aRet)    


User Function DIImp()  
/*ALTERACAO CRIADA PARA TRAZER OS DADOS CADASTRADOS PELO USUARIO NO MOMENTO DA INCLUSAO DA D.I.
  GRAZIELLA 07/11/2011
*/
Public cF1Numdi    := ""
Public cF1DtDi     := ""
Public cF1LcDm     := ""
Public cF1UfDe     := ""
Public cF1DtDe     := ""

DbSelectArea("CD5")
DbSetOrder(1)
DBSEEK(xFilial("CD5") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
cF1Numdi:= IIf(Inclui,CriaVar("CD5_NDI")	,CD5->CD5_NDI)
cF1DtDi := IIf(Inclui,CriaVar("CD5_DTDI")	,CD5->CD5_DTDI)
cF1LcDm := IIf(Inclui,CriaVar("CD5_LOCDES"),CD5->CD5_LOCDES)
cF1UfDe := IIf(Inclui,CriaVar("CD5_UFDES") ,CD5->CD5_UFDES)
cF1DtDe := IIf(Inclui,CriaVar("CD5_DTDES") ,CD5->CD5_DTDES)

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oGet1","oGet2","oGet3","oGet4","oGet5","oSBtn1")    

oDlg1      := MSDialog():New( 089,232,266,575,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 000,000,080,164,"Dados da Importacao",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 012,004,{||"D.I. nº"}     ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay2      := TSay():New( 012,090,{||"Data da D.I."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 025,004,{||"Local Desem."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay4      := TSay():New( 025,090,{||"Uf. Desemb."} ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 037,004,{||"Data Desem."} ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGet1      := TGet():New( 012,024,{|u| If(PCount()>0,cF1numdi :=u,cF1numdi)},oGrp1,060,008,''        ,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cF1numdi",,)
oGet2      := TGet():New( 012,126,{|u| If(PCount()>0,cF1dtdi  :=u,cF1dtdi)} ,oGrp1,030,008,'99/99/99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cF1dtdi",,)
oGet3      := TGet():New( 025,024,{|u| If(PCount()>0,cF1LcDm  :=u,cF1LcDm)} ,oGrp1,060,008,''        ,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cF1LcDm",,)
oGet4      := TGet():New( 025,126,{|u| If(PCount()>0,cF1UfDe  :=u,cF1UfDe)} ,oGrp1,030,008,''        ,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cF1UfDe",,)
oGet5      := TGet():New( 037,054,{|u| If(PCount()>0,cF1DtDe  :=u,cF1DtDe)} ,oGrp1,030,008,'99/99/99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cF1DtDe",,)
oSBtn1     := SButton():New( 060,044,1,{|| oDlg1:end()},oGrp1,,"", )
                                              
oDlg1:Activate(,,,.T.)

Return .t.