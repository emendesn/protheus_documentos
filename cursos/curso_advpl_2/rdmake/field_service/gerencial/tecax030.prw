/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TECAX030 �Autor  � M.Munhoz - ERPPLUS � Data �  09/08/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para calcular e gravar os dias uteis                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function tecax030()

Local aSay     	:= {}
Local aButton   := {}
Local nOpc      := 0
Local cTitulo   := "C�lculo de dias �teis"
Local cDesc1   	:= "Este programa alimenta o cadastro de dias �teis (ZZ6) para ser utilizado nos relat�rios "
Local cDesc2   	:= "gerenciais da SONY/ERICSSON. Os feriados nacionais, estaduais e municipais devem "
Local cDesc3   	:= "estar cadastrados na tabela 63 pelo Configurador."
Local cDesc4   	:= "Espec�fico BGH do Brasil"

Private cPerg   := "TECX30"

u_GerA0003(ProcName())

//���������������������������������������������������������������������Ŀ
//|Cria dicionario de perguntas  - Alterado Paulo Francisco - 18/05/10  �
//�����������������������������������������������������������������������  
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)     
	Return
Endif

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

//Botoes
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T.)			}} ) //Bot�o de par�metros
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()		}} ) //Bot�o Ok
aAdd( aButton, { 2, .T., {|| FechaBatch()					}} ) //Bot�o Cancel

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
EndIf

//Processa( {|lEnd| u_tecax030a( @lEnd , 5 ) }, "Aguarde.....", "Calculando dias �teis.....", .T. )
Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Gerando dados de atendimentos Nextel", .T. )

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TECAX030 �Autor  �Microsiga           � Data �  09/05/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//user function tecax030a()
Static Function RunProc(lEnd)

local _dIni  
local _dFim  
local _dProc 
local _nUtil    := 0
local _aAreaZZ6 := ZZ6->(GetArea())
 
ZZ6->(dbSetOrder(1)) // ZZ6_FILIAL + ZZ6_LAB + DTOS(ZZ6_DATA)

_dIni := mv_par01
_dFim := mv_par02
_dProc:= mv_par03

// Chama funcao da regua 
ProcRegua(mv_par02 - mv_par01)

// Processa os dias do periodo informado verificando se trata-se de dia util ou nao
// Os feriados devem estar cadastrados na tabela 63 pelo Configurador.
while _dProc <= _dFim

	// Incrementa regua
	incproc()

	if _dProc == DataValida(_dProc,.T.) .and. _dProc == DataValida(_dProc,.F.)
 		_nUtil := 1
 	else
 		_nUtil := 0
	endif

	if ZZ6->(dbSeek(xFilial("ZZ6") + "1" + dtos(_dProc) ))
		reclock("ZZ6",.f.)
	else
		reclock("ZZ6",.t.)
		ZZ6->ZZ6_FILIAL := xFilial("ZZ6")
		ZZ6->ZZ6_LAB    := "1"
		ZZ6->ZZ6_DATA   := _dProc
	endif
	ZZ6->ZZ6_UTIL   := _nUtil
	msunlock()

	_dProc++

enddo

restarea(_aAreaZZ6)

return

 /*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FCRIASX1  � Autor �Paulo Lopez         � Data �  18/05/10   ���
�������������������������������������������������������������������������͹��
���Descricao �GERA DICIONARIO DE PERGUNTAS                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fCriaSX1(cPerg)

//���������������������������������������������������������������������Ŀ
//|Declaracao de variaveis                                              �
//�����������������������������������������������������������������������
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Data Inicial         	?","","","mv_ch1","D",08,0,0,"G","","" ,"","S","mv_par01",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Data Final         		?","","","mv_ch2","D",08,0,0,"G","","" ,"","S","mv_par02",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
 
cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe Data Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe Data Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return