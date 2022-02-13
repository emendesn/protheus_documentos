#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTPROCP3  ºAutor  ³Graziella Bianchin  º Data ³  03/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criacao do Ponto de Entrada que verifica se o item em       º±±
±±º          ³questao deve ou não compor a tela de NF de Origens.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Uso exclusivo BGH                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTPROCP3()

Local aArea		:= GetArea()  
Local cCliNFE10 := Getmv("BH_CLINFE10",.F.,"19182601")
Local cCliSB6	:= B6_CLIFOR+B6_LOJA   
Local cDocSB6	:= B6_DOC+B6_SERIE
Local nSaldo	:= B6_SALDO
Local lProcessa := .T.
Local cCGCSC5   :=""
Local cCGCZZQ   :=""

u_GerA0003(ProcName())

IF nSaldo > 0
	lProcessa := .T.
	If Upper(Funname()) $ "MATA410"
		If cCliSB6==cCliNFE10
			cCGCSC5   :=Posicione("SA1",1,xFilial("SA1") + C5_CLIENTE+C5_LOJACLI, "A1_CGC")
			dbSelectArea("ZZQ")
			dbSetOrder(5)
			If dbSeek(xFilial("ZZQ")+cDocSB6)
				cCGCZZQ   :=Posicione("SA1",1,xFilial("SA1") + ZZQ->ZZQ_CLIORI+ZZQ->ZZQ_LOJORI, "A1_CGC")
				If  Left(cCGCZZQ,8) <> Left(cCGCSC5,8)
					lProcessa := .F.
				Endif
			Endif
		Endif
	Endif
ELSE
	lProcessa := .F.
ENDIF

RestArea(aArea)

Return(lProcessa)