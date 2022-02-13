#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#define ENTER CHR(10)+ CHR(13)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTDESCRNFEº Autor ³Paulo Lopez         º Data ³  19/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada para Compor a descrição dos serviços       º±±
±±³          ³ prestados na operação. Essa descrição será utilizada para aº±±
±±³          ³ impressão do RPS e para geração do arquivo de exportação   º±±
±±³          ³ para a prefeitura.         								  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO / FISCAL                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTDESCRNFE()

/*========================================================================================|
|Declaração de variáveis                                                                  |
|========================================================================================*/

Private     _cDesc 		:= ""
Private     _cDescr		:= ""
Private		_stemp 		:= "|"
Private		_cNumRPS 	:= SF3->F3_NFISCAL
Private		_cSerRPS 	:= SF3->F3_SERIE
Private		_cCodCli 	:= SF3->F3_CLIEFOR
Private		_cLojaRPS   := SF3->F3_LOJA
Private 	_cQry
Private 	_cQtd		:= 0
Private 	i


u_GerA0003(ProcName())

IF Select("QRY") <> 0
	DbSelectArea("QRY")
	DbCloseArea()
Endif

IF Select("QRY1") <> 0
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

_cQry1   := " SELECT F3_OBSERV AS OBSERV,C5_MENNOTA AS MENSAGEM " + ENTER
_cQry1   += " FROM SF3020 SF3 " + ENTER
_cQry1   += " LEFT JOIN SC5020 SC5 " + ENTER
_cQry1   += " ON(F3_NFISCAL = C5_NOTA AND F3_SERIE = C5_SERIE AND F3_CLIEFOR = C5_CLIENTE AND F3_LOJA = C5_LOJACLI) " + ENTER
_cQry1   += " WHERE SF3.D_E_L_E_T_ = '' " + ENTER
_cQry1   += " AND SC5.D_E_L_E_T_ = '' " + ENTER
_cQry1   += " AND F3_NFISCAL = '" + _cNumRPS  + "' " + ENTER
_cQry1   += " AND F3_SERIE =   '" + _cSerRPS  + "' " + ENTER
_cQry1   += " AND F3_CLIEFOR = '" + _cCodCli  + "' " + ENTER
_cQry1   += " AND F3_LOJA =    '" + _cLojaRPS + "' " + ENTER
_cQry1   += " AND F3_FILIAL =  '" + xFilial("SF3") + "' " + ENTER
_cQry1   += " AND F3_DTCANC = '' " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry1), "QRY1", .F., .T.)


_cQry	:= " SELECT ZN_NFESEFA AS NOTA, ZN_SERSEFA  AS SERIE " + ENTER
_cQry	+= " FROM " + RetSqlName("SZN") + " SZN(NOLOCK) " + ENTER
_cQry	+= " INNER JOIN " + RetSqlName("SC5") + " SC5(NOLOCK) " + ENTER
_cQry	+= " ON(SZN.ZN_PEDVEND = SC5.C5_NUM) " + ENTER
_cQry	+= " WHERE SZN.D_E_L_E_T_ = '' " + ENTER
_cQry	+= " AND C5_NOTA = '" + _cNumRPS  + "' " + ENTER
_cQry	+= " AND C5_SERIE = '" + _cSerRPS  + "' " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)


If LEN(AllTrim(QRY1->MENSAGEM)) > 1
	_cDesc += AllTrim(QRY1->MENSAGEM)
Else
	_cDesc 		:= "Retorno de NF :"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Grava dados                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QRY")
dbGoTop()

While !EOF("QRY")
	
	_cDesc +=  AllTrim(QRY->NOTA)+ '-' + AllTrim(QRY->SERIE) + '/'
	
	If SZN->(dbSeek(xFilial("SZN") + AllTrim(QRY->NOTA) + AllTrim(QRY->SERIE)))
		While SZN->(!eof()) .and. SZN->ZN_FILIAL == xFilial("SZN") .and. SZN->ZN_NFESEFA == AllTrim(QRY->NOTA) .And. SZN->ZN_SERSEFA == AllTrim(QRY->SERIE)
			
			Dbselectarea("SZN")
			
			Begin Transaction
			
			RecLock("SZN",.F.)
			
			SZN->ZN_NFRPS 	:= _cNumRPS
			SZN->ZN_SERRPS 	:=_cSerRPS
			
			msunlock()
			
			End Transaction
			
			SZN->(dbSkip())
			
		EndDo
	EndIf
	
	dbSelectArea("QRY")
	dbSkip()
	
EndDo

_cQtd := LEN(AllTrim(_cDesc))

If _cQtd > 1259
	MsgStop("Erro arquivo contem mais de 1259 caracteres !!!", "Atenção")
	Return
EndIf

If !Empty(_cDesc)
	For i:= 1 to len(AllTrim(_cDesc)) step 98
		_cDescr += allTrim(Subs(_cDesc,i,98)) + _stemp
	next i
	
EndIf

Dbselectarea("SZN")
SZN->(dbSetOrder(1))

QRY->(dbCloseArea())
QRY1->(dbCloseArea())

Return (_cDescr)