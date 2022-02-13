#include 'rwmake.ch'
#include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � COMA001  �Autor  � M.Munhoz - ERPPLUS � Data �  17/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para informar os acessorios de cada item da NF de ���
���          � Entrada.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH (Sony)                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//��������������������������������������������������������������������������������Ŀ
//� Alterado por M.Munhoz em 21/08/2011 para substituir o tratamento do D1_NUMSER  �
//� pelo D1_ITEM, uma vez que o IMEI deixara de ser gravado no SD1.                �
//����������������������������������������������������������������������������������
user function COMA001()

local _nPosAcess := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_XACESS"})
local _nPosIMEI  := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_NUMSER"})
local _nPosD1Q   := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_QUANT"})

u_GerA0003(ProcName())

// Sai do programa caso nao tenha acessorio
if aCols[n,_nPosAcess] <> 'S'
	return() 
endif

// Sai do programa caso o IMEI nao esteja informado. Caso de excesso apos a mudanca de gravacao do SD1 seo o IMEI. 
// Neste caso o usuario sera obrigado a informar o D1_NUMSER para atualizar os acessorios (SZC) corretamente.
if empty(aCols[n,_nPosIMEI]) .or. aCols[n,_nPosD1Q] <> 1
	apMsgInfo('Caro usu�rio, para informar os acess�rios � necess�rio informar o IMEI no campo de Numero de Serie da NFE e a quantidade do item deve ser igual a 1 (um).','IMEI obrigat�rio para informar os acess�rios')
	return() 
endif

// Verifica se existe arquivo. Caso nao exista, cria.
if select("TRB") <= 0
	CriaArq()
endif

//Apresenta markbrowse com opcoes de acessorios
u_com01mark()

//TRB->(dbCloseArea())
M->D1_XACESS := "S"

return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CRIAARQ  �Autor  �M.Munhoz - ERPPLUS  � Data �  17/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para criar arquivo temporario                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function CriaArq()

local _aCampos := {}

// Cria arquivo temporario
_aCampos := {	{"DOC"		,"C",09,0},; // Alterado de 06 para 09 devido a nova versao P10
				{"SERIE"	,"C",03,0},;
				{"FORNECE"	,"C",06,0},;
				{"LOJA"		,"C",02,0},;
				{"CODPRO"	,"C",15,0},;
				{"ITEMNFE"	,"C",04,0},;
				{"ITEM"		,"C",04,0},;
				{"ACESS"	,"C",06,0},;
				{"IMEI"		,"C",TamSX3("ZZ4_IMEI")[1],0},;
				{"QUANT"	,"N",12,2} }

_cArqSeq := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,,_cArqSeq,"TRB",.T.,.F.)
_cAlias  := "TRB"
_cIndice := criatrab(,.f.)
_cChave  := "DOC+SERIE+ITEMNFE+ACESS"
_cWhile  := ""
_cFor    := ""
_cTexto  := "Selecionando acess�rios"
indregua(_cAlias,_cIndice,_cChave,_cWhile,_cFor,_cTexto)

return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COM01MARK �Autor  �Microsiga           � Data �  11/02/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Abre tela com os acessorios a selecionar                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function com01mark()

Local aSalvAmb  := {}
Local cVar      := Nil
Local oDlg      := Nil
Local cTitulo   := "Controle de Acess�rios"
Local lMark     := .F.
Local oOk       := LoadBitmap( GetResources(), "LBOK" )
Local oNo       := LoadBitmap( GetResources(), "LBNO" )
Local oChk      := Nil
Local cAlias    := "SX5"
Local _aAreaSX5 := SX5->(GetArea())

Private lChk   := .F.
Private oLbx   := Nil
Private aVetor := {}
Private _nOpcx := 0

Private _nPosItem := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_ITEM"	})
Private _nPosProd := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_COD" 	})
Private _nPosIMEI := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_NUMSER"	})

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
SZC->(dbSetOrder(1))//ZC_FILIAL + ZC_DOC + ZC_SERIE + ZC_FORNECE + ZC_LOJA + ZC_CODPRO + ZC_ITEMNFE + ZC_ACESS
SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5") + "Z5"))
while SX5->(!eof()) .and. alltrim(SX5->X5_TABELA) == 'Z5'

	if Inclui .and. TRB->(dbSeek(cNFiscal + cSerie + aCols[n,_nPosItem] + alltrim(SX5->X5_CHAVE) )) .or.;
	!Inclui .and. !Altera .and. SZC->(dbSeek(xFilial("SZC") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + aCols[n,_nPosProd] + aCols[n,_nPosItem] + alltrim(SX5->X5_CHAVE) )) 
		lMark := .t.
	else
		lMark := .f.
	endif
	aAdd( aVetor, { lMark, SX5->X5_CHAVE, SX5->X5_DESCRI, 0 })
	SX5->(dbSkip())

enddo

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
	Aviso( cTitulo, "Nao existem acess�rios a consultar", {"Ok"} )	
	Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
   
@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER " ", "Codigo", "Acessorio","Quantidade" SIZE 230,095 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := iif(Inclui,!aVetor[oLbx:nAt,1],aVetor[oLbx:nAt,1]),oLbx:Refresh())

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
                       aVetor[oLbx:nAt,2],;
                       aVetor[oLbx:nAt,3],;
                       aVetor[oLbx:nAt,4]}}
	 
if Inclui
	@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ON CLICK(Iif(lChk,Marca(lChk),Marca(lChk)))
endif

DEFINE SBUTTON FROM 107,173 TYPE 2 ACTION (_nOpcx:=0,oDlg:End()) ENABLE OF oDlg  // Cancelar
DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (_nOpcx:=1,oDlg:End()) ENABLE OF oDlg  // OK

ACTIVATE MSDIALOG oDlg CENTER

if _nOpcx == 1 .and. Inclui
	u_com01grv()
endif

//oDlg:End()

RestArea(_aAreaSX5)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MARCA    �Autor  � M.Munhoz - ERPPLUS � Data �  11/02/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Marca ou desmarca os acessorios                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Marca(lMarca)

Local i := 0

if Inclui
	For i := 1 To Len(aVetor)
	   aVetor[i][1] := lMarca
	Next i
	oLbx:Refresh()
endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � COM01GRV �Autor  � M.Munhoz - ERPPLUS � Data �  11/02/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava os itens selecionados no arquivo temporario          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function com01grv()

local _cItem := "01"

for x := 1 to len(aVetor)

	if aVetor[x,1] .and. TRB->(!dbSeek(cNFiscal + cSerie + aCols[n,_nPosItem] + alltrim(aVetor[x,2]) ))
		reclock("TRB",.t.)
		TRB->DOC       := cNFiscal
		TRB->SERIE     := cSerie
		TRB->FORNECE   := cA100For
		TRB->LOJA      := cLoja
		TRB->CODPRO    := aCols[n,_nPosProd]
		TRB->ITEMNFE   := aCols[n,_nPosItem]
		TRB->ITEM      := _cItem
		TRB->ACESS     := aVetor[x,2]
		TRB->IMEI      := aCols[n,_nPosIMEI]
		TRB->QUANT     := aVetor[x,4]
		msunlock()
		_cItem := Soma1(_cItem)
	elseif !aVetor[x,1] .and. TRB->(dbSeek(cNFiscal + cSerie + aCols[n,_nPosItem] + alltrim(aVetor[x,2]) ))
		reclock("TRB",.f.)
		dbDelete()
		msunlock()
	endif

next x

return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZC    �Autor  �Microsiga           � Data �  02/18/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � AXCADASTRO DO SZC - CONTROLE DE ACESSORIOS                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function axSZC()

AxCadastro("SZC","Controle de Acess�rios - SONY")

return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VALACESS �Autor  �Microsiga           � Data �  02/18/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida digitacao dos acessorios pra cada item da NFE       ���
�������������������������������������������������������������������������͹��
���Uso       � P.E.MT100LOK()                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function ValAcess()

local _lRet      := .t.
local _nPosAcess := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_XACESS"})
local _nPosItem  := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_ITEM"	})
local _nPosProd  := Ascan(aHeader, {|X| AllTrim(X[2]) == "D1_COD" 	})

if aCols[n,_nPosAcess] == "S" .and. (select("TRB") <= 0 .or. TRB->(!dbSeek(cNFiscal + cSerie + aCols[n,_nPosItem])))
	_lRet := .f.
	apMsgStop('Caro usu�rio, este produto exige que seja informado ao menos 1 acess�rio SONY.','Informar acess�rio SONY.')
endif

if aCols[n,_nPosAcess] <> "S" .and. select("TRB") > 0 .and. TRB->(dbSeek(cNFiscal + cSerie + aCols[n,_nPosItem] ))
	_lRet := .f.
	if apMsgYesNo('Caro usu�rio, foram encontrados acess�rios informados neste item, por�m o mesmo encontra-se marcado como N�O cont�m acess�rios, portanto os acess�rios ser�o apagados. Continua ? ','Informar acess�rio SONY.')
		while TRB->(!eof()) .and. TRB->DOC + TRB->SERIE + TRB->ITEMNFE == cNFiscal + cSerie + aCols[n,_nPosItem]
			reclock("TRB",.f.)
			dbDelete()
			msunlock()
			TRB->(dbSkip())
		enddo
		_lRet := .t.
	endif
endif

return(_lRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GRVACESS �Autor  � M.Munhoz - ERPPLUS � Data �  18/02/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava acessorios para aparelhos SONY                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH - SONY                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function GrvAcess()

local _aAreaSD1 := SD1->(GetArea())

SD1->(dbSetOrder(1))  // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM

// Sai da rotina caso nao encontre arquivo temporario
if Inclui .and. select("TRB") <= 0
	return()
endif

// Passa por todos os itens do arquivo temporario (Acessorios) e grava no SZC
TRB->(dbGoTop())
while TRB->(!eof())

	if SD1->(dbSeek(xFilial("SD1") + TRB->DOC + TRB->SERIE + TRB->FORNECE + TRB->LOJA + TRB->CODPRO + TRB->ITEMNFE)) .and. SD1->D1_XACESS == "S"

		reclock("SZC",.t.)
		SZC->ZC_FILIAL   := xFilial("SZC")
		SZC->ZC_DOC      := TRB->DOC
		SZC->ZC_SERIE    := TRB->SERIE
		SZC->ZC_FORNECE  := TRB->FORNECE
		SZC->ZC_LOJA     := TRB->LOJA
		SZC->ZC_ITEMNFE  := TRB->ITEMNFE
		SZC->ZC_CODPRO   := TRB->CODPRO
		SZC->ZC_ITEM     := TRB->ITEM
		SZC->ZC_ACESS    := TRB->ACESS
		SZC->ZC_QUANT    := TRB->QUANT
		SZC->ZC_IMEI     := SD1->D1_NUMSER
		msunlock()

	endif
	TRB->(dbSkip())

enddo

restarea(_aAreaSD1)
TRB->(dbCloseArea())

return()
