#INCLUDE 'RWMAKE.CH' 
#INCLUDE "topconn.ch"              
#include "tbiconn.ch" 
#DEFINE OPEN_FILE_ERROR -1
#define ENTER CHR(13)+CHR(10)           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPPLNREFºAutor  ³ M.Munhoz           º Data ³  18/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para importar a amarracao do plano de contas da   º±±
±±º          ³ empresa com o plano de contas referencial do SPED contabil º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function IMPPLNREF()

local _aAreaCT1 := CT1->(getarea())
local _aAreaCVD := CVD->(getarea())
local _aAreaCVN := CVN->(getarea())
local _cEntRef  := '10'
local _cCodPla  := '100   '
local _lRet     := .t.

CT1->(dbSetOrder(1)) // CT1_FILIAL, CT1_CONTA 
CVD->(dbSetOrder(1)) // CVD_FILIAL, CVD_CONTA, CVD_ENTREF, CVD_CTAREF, CVD_CUSTO
CVN->(dbSetOrder(2)) // CVN_FILIAL, CVN_CODPLA, CVN_CTAREF

cDirArq := 'D:\PLANOREF.CSV'
if !file(cDirArq)  
	ALERT('nao encontrou arquivo d:\planoref.csv')
endif		                                    

If FT_FUSE( cDirArq ) = OPEN_FILE_ERROR 
	alert('erro na abertura do arquivo d:\planoref.csv')
Endif 

if !apMsgYesNo('Confirma importação da Amarração Conta BGH x Conta Referencial. Arquivo: ' + alltrim(cDirArq) + '?','Importação Amarração Conta BGH x Conta Referencial')
	return()
endif

While !FT_FEOF()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ linha do arquivo retorno ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer := FT_FREADLN()
	
	nDivi    := At(";",xBuffer)
  	_cCtaBGH := left(xBuffer,nDivi-1)
	_cCtaRef := substr(xBuffer,nDivi+1,len(xBuffer)-nDivi)

	if !empty(_cCtaBGH) .and. !empty(_cCtaRef)

		if CT1->(!dbSeek(xFilial('CT1')+_cCtaBGH))
			alert('conta BGH nao existe no CT1: ' + _cCtaBGH)
			_lRet := .f.
		endif
		if CVN->(!dbSeek(xFilial('CVN')+_cCodPla + _cCtaRef))
			alert('conta REFERENCIAL nao existe no CVN: ' + _cCtaRef)
			_lRet := .f.
		endif
		//CVD->(dbSetOrder(1)) // CVD_FILIAL, CVD_CONTA, CVD_ENTREF, CVD_CTAREF, CVD_CUSTO
		if CVD->(dbSeek(xFilial('CVD')+left(_cCtaBGH+space(20),20) + _cEntRef + left(_cCtaRef+space(30),30) ))// CVD_FILIAL, CVD_CONTA, CVD_ENTREF, CVD_CTAREF, CVD_CUSTO
			alert('Chave Unica: amarracao conta BGH x conta REFERENCIAL ja existe no CVD: ' + _cCtaBGH + '/' + _cCtaRef)
			_lRet := .f.

/*
			_xCtaBGH := CVD->CVD_CONTA
			_xCtaRef := CVD->CVD_ENTREF
			_xEntRef := CVD->CVD_CTAREF
			while CVD->(!eof()) .and. CVD->CVD_FILIAL == xFilial("CVD") .and. ;
			_xCtaBGH == CVD->CVD_CONTA .and. ;
			_xCtaRef == CVD->CVD_ENTREF .and. ;
			_xEntRef == CVD->CVD_CTAREF 
			
				if _cCodPla == CVD->CVD_CODPLA // Ja existe amarracao Conta BGH x Conta Referencial para este PLANO REFERENCIAL
					alert('amarracao conta BGH x conta REFERENCIAL ja existe no CVD: ' + _cCtaBGH + '/' + _cCtaRef)
					_lRet := .f.
					exit
				endif
				CVD->(dbSkip())

			enddo
*/
		endif
/*
		CVD->(dbSetOrder(2)) // CVD_FILIAL, CVD_CODPLA, CVD_CTAREF
		if CVD->(dbSeek(xFilial('CVD')+_cCodPla + left(_cCtaRef+space(30),30) ))// CVD_FILIAL, CVD_CONTA, CVD_ENTREF, CVD_CTAREF, CVD_CUSTO
			alert('codigo do plano x conta REFERENCIAL ja existe no CVD: ' + _cCodPla + '/' + _cCtaRef)
			_lRet := .f.
		endif
*/
		if !_lRet
			FT_FSKIP()
			_lRet := .t.
			loop
		endif

		reclock("CVD",.t.)
		CVD->CVD_FILIAL := xFilial("CVD")
		CVD->CVD_ENTREF := _cEntRef
		CVD->CVD_CTAREF := _cCtaRef
		CVD->CVD_CONTA  := _cCtaBGH
		CVD->CVD_CODPLA := '100'
		CVD->CVD_TPUTIL := CVN->CVN_TPUTIL
		CVD->CVD_CLASSE := CVN->CVN_CLASSE
		CVD->CVD_NATCTA := CVN->CVN_NATCTA
		CVD->CVD_CTASUP := CVN->CVN_CTASUP
		msunlock()

	endif
	FT_FSKIP()

EndDo
		
alert("Fim de processamento de Importação de Arquivo .CSV ") 

return
