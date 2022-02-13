/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: Espelho de Ponto BGH                                                                                                                                                          |
|Autor:                                                                                                                                                                                  |
|Data Aplicação: 06/2013                                                                                                                                                                 |
|Descrição: Gerar arquivo para impressão do Espelho de Ponto com BANCO DE HORAS                                                                                                          |
|Validado por: Luciana                                                                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração:   /  /                                                                                                                                                                  |
|Motivo:                                                                                                                                                                                 |
|Resposável: Anadi                                                                                                                                                                       |
|Validado por: Luciana                                                                                                                                                                   |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function FPONR01()

Local aArea			:= GetArea()
Local cString	    := "SRA"

Private Titulo		:= "Ponto Eletronico - Finder"
Private cPerg		:= "FPONR1"
Private nLastKey	:= 0
Private NomeProg	:= FunName()
Private nColMax		:= 3400
Private nColMin		:= 035
Private nLinMax		:= 2250
Private wnrel		:= ""

m_pag := 1

wnrel := FunName()	//Nome Default do Relatório em Disco

Processa({|| CursorWait(),FPONR01_A(Titulo),CursorArrow()},"Gerando relatório, Aguarde...")

RestArea(aArea)

Return

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function FPONR01_A(Titulo)

Private _cChamada_	:= ProcName()
Private oPrint		:= Nil
Private k			:= 1, _nLimite := 2200
Private nLin		:= 3000, cPerg := PADR("FPNR01",Len(SX1->X1_GRUPO))

//Array com as posições para montar as linhas verticais
//								   1    2    3    4   5    6     7   8     9   10   11   12   13   14   15   16   17   18   19   20     
Private _aColun		:= {0040,0170,0650,0765,0890,1005,1130,1245,1380,1500,1950,2070,2190,2310,2440,2560,2680,2800,2930,3300}

//Array com as posições onde devem ser impressos cada marcação do ponto
//								1					2						3						4
Private _aPos		:= {_aColun[2] + 10,_aColun[2] + 125,_aColun[2] + 255,_aColun[2] + 360} 

//Definição das fontes a serem utilizadas
Private oFont07N	:= tFont():New("ARIAL",07,07,,.t.,,,,.t.,.f.)
Private oFont08		:= tFont():New("ARIAL",08,08,,.f.,,,,.t.,.f.)
Private oFont09		:= tFont():New("ARIAL",09,09,,.f.,,,,.t.,.f.)
Private oFont09N	:= tFont():New("ARIAL",09,09,,.t.,,,,.t.,.f.)

oPrint:= TMSPrinter()	:New(Titulo)
oPrint:SetLandScape() //Modo paisagem
oPrint:SetPaperSize(9) //A4

oPrint:Setup() //definir impressora a ser utilizada

If !oPrint:IsPrinterActive()
	Aviso("Atenção","Não foi Possível Imprimir o Relatório, pois não há Nenhuma Impressora Conectada.",{"OK"})
	Return(Nil)
EndIf

_FValidX1()

If !Pergunte(cPerg,.t.)
	Return
EndIf

nLin := FPONR01_B(oPrint,k,Titulo)

oPrint:Preview()

Set Device To Screen



oPrint := Nil

If Select("xRA") > 0
	DbSelectArea("xRA")
	DbCloseArea()
EndIf

Return(Nil)

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function FPONR01_B(oPrint,k,Titulo)

Local _lCont_		:= .t., _lDia := .f., _lEof := .f., _lDescons := .f.
Local _cSQL			:= cLastFil 	 := nHrAnt		:= _HrEnt1		 := _HrSai1	:= _HrEnt2  := _HrSai2  := _cMotivo := ""
Local nConta		:= nAnt := _nCont	:= _nPos := _nP2	:= _nL := _n := _nAux := _nLiAB := nAntAb := _nQuant := _nLiAtu := 0 
Local dIniPonMes	:= dFimPonMes := _dDtAtu  	:= _dDtLim		 := CTOD("  /  /  ")
Local _aPos2		:= {}, _aMot	 := {}, _aArea := {}, _aCodAbo := {}

Private lFirstPage	:= .t., dDatAux := CTOD("  /  /  ")
Private nSaldo 		:= nSaldoAnt 	:= nSaldoFim := nTotCrd := nTotDeb := nTotSld := nAtraso := nSaiAnt := nFalta := nDSR := _nTotAbo := nHE := 0

//Filtra a tabela de funcionários de acordo com os parametos informados
_cSQL := "Select RA_FILIAL,RA_MAT,RA_NOME,RA_NUMCP,RA_ADMISSA,R6_DESC,RJ_DESC,X5_DESCRI,Q3_DESCSUM,QB_DESCRIC From " + RetSqlName("SRA") + " _RA "
_cSQL += "	Inner Join  " + RetSqlName("SR6") + " _R6 on R6_TURNO = RA_TNOTRAB And _R6.D_E_L_E_T_ = ' ' "
_cSQL += "	Inner Join	" + RetSqlName("SRJ") + " _RJ on RJ_FUNCAO = RA_CODFUNC And _RJ.D_E_L_E_T_ = ' ' "
_cSQL += "	Inner Join  " + RetSqlName("SX5") + " _X5 on X5_TABELA = '28' And X5_CHAVE = RA_CATFUNC And _X5.D_E_L_E_T_ = ' ' "
_cSQL += "	Left Join   " + RetSqlName("SQ3") + " _Q3 on (Q3_CARGO = RA_CARGO Or Q3_CARGO = ' ') And _Q3.D_E_L_E_T_ = ' ' "
_cSQL += "  Left Join   " + RetSqlName("SQB") + " _QB On (QB_DEPTO = RA_DEPTO Or QB_DEPTO = ' ') And _QB.D_E_L_E_T_ = ' ' "
_cSQL += "Where RA_FILIAL Between '" + mv_par11 + "' And '" + mv_par12 + "' And "
_cSQL += "	RA_MAT 		>= '" + mv_par03 + "' And RA_MAT 	 <= '" + mv_par04 + "' And "
_cSQL += "	RA_NOME 	>= '" + mv_par05 + "' And RA_NOME 	 <= '" + mv_par06 + "' And "
_cSQL += "	RA_TNOTRAB  >= '" + mv_par07 + "' And RA_TNOTRAB <= '" + mv_par08 + "' And "
_cSQL += "	RA_CC 		>= '" + mv_par09 + "' And RA_CC		 <= '" + mv_par10 + "' And "
_cSQL += "	(RA_DEMISSA = ' ' Or RA_DEMISSA >= '" + DTOS(mv_par01) + "') And (RA_ADMISSA <= '" + DTOS(mv_par01) + "' Or RA_ADMISSA <= '" + DTOS(mv_par02) + "') And "
_cSQL += "	RA_REGRA	<> ' ' And _RA.D_E_L_E_T_ = ' ' "
_cSQL += "Order By RA_FILIAL,RA_MAT "
_cSQL := ChangeQuery(_cSQL)

If Select("xRA") > 0
	DbSelectArea("xRA")
	DbCloseArea()
EndIf

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cSQL),"xRA", .T., .T.)

DbSelectArea("xRA")
DbGoTop()

If Eof()
	MsgStop("Nao ha dados para exibir, verifique os parametros","ATENCAO")
	Return
EndIf	

//Atualiza a Filial Corrente
cLastFil := xRA->RA_FILIAL

//Obtem datas do Periodo em Aberto
GetPonMesDat(@dIniPonMes, @dFimPonMes, cLastFil)

//Array onde serão gravadas as horas da Jornada
_aPos2 := {"","","",""}

//Grava os códigos que identificam Atraso, Saida Antecipada, DSR e Falta
_aCodAbo := Separa(Alltrim(GetMV("MV__CODABO")),";")

DbSelectArea("xRA")
While !Eof()
	
	_fPlinha(0)
	nAnt 	:= _nL := _nAux := _nLiAB := nAntAb :=  nLin	
	_dDtLim := mv_par01
	_nPos 	:= 5
	_aMot	:= {}
	nSaldo  := nSaldoAnt := nSaldoFim := nTotCrd := nTotDeb := nTotSld := nAtraso := nSaiAnt := nFalta := nDSR := _nLiAtu := _nTotAbo := nHE := 0
	
	//Marcacoes do Ponto e Jornada Realizada
	While _dDtLim <= mv_par02 

		_aPos2  	:= {"","","",""}
		_nCont  	:= nHrAnt := 0
		_dDtAtu 	:= CTOD("  /  /  ")
		_cMotivo 	:= ""
		_lDia   	:= .f. 	
		_lEof 		:= .f.
		_lCont_		:= .f.
		_lDescons	:= .f.	
	
		If _dDtLim < dIniPonMes //Se a data for menor que o período em aberto, busca as informações de apontamento na tabela SPG. Senão busca na SP8
			_cSQL := " Select PG_FILIAL,PG_MAT,PG_DATA,PG_HORA,PG_MOTIVRG,PG_FLAG,PG_TPMARCA,PG_APONTA,PG_TPMCREP,RFD_CODIGO From " + RetSqlName("SPG") + " _PG "
			_cSQL += " Left Join " + RetSqlName("RFD") + " _FD on RFD_DESC = PG_MOTIVRG And _FD.D_E_L_E_T_ = ' ' "
			_cSQL += " Where PG_FILIAL Between '" + mv_par11 + "' And '" + mv_par12 + "' And PG_MAT = '" + xRA->RA_MAT + "' And PG_DATA = '" + DTOS(_dDtLim) + "' And _PG.D_E_L_E_T_ = ' ' And PG_APONTA = 'S' "
			_cSQL += " Order By PG_FILIAL,PG_MAT,PG_DATA,PG_HORA "
			_cSQL := ChangeQuery(_cSQL)
			
			If Select("xPG") > 0
				DbSelectArea("xPG")
				DbCloseArea()
			EndIf
			
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cSQL),"xPG", .T., .T.)			
			
			DbSelectArea("xPG")
			DbGoTop()
			
			While !Eof()
			   
				_lDescons := IIF(Alltrim(xPG->PG_TPMCREP) != "D",.f.,.t.) //Verifica se a marcação deve ser desconsiderada
			
				If _nLiAtu == nLin .And. _dDtLim != mv_par01 
					nLin += 40
					nAnt := nLin
					If nLin > _nLimite
						_fPlinha(_nAux)
						nAnt := nLin
					EndIf
				EndIf			
								
				If _dDtAtu != STOD(xPG->PG_DATA) .And. !_lDia
					oPrint:Say(nLin,_aColun[1] + 20, OemToAnsi(SubStr(xPG->PG_DATA,7,2) + "/" + SubStr(xPG->PG_DATA,5,2))	,oFont08)
					_dDtAtu := STOD(xPG->PG_DATA)
					_nPos := _nP2 := 1
					_lDia := .t.
				EndIf
								
	         	//Marcações do Ponto
				If /*Empty(xPG->PG_MOTIVRG) .Or. */xPG->PG_FLAG == "E"
				
					If !Empty(_aPos2[1] + _aPos2[2] + _aPos2[3] + _aPos2[4] + _cMotivo) .And. _nPos == 1 .And. _lCont_
						_nLiAtu := nLin
						nLin += 40
						If nLin > _nLimite
							_fPlinha(_nAux)
							nAnt := nLin
						EndIf	
						_nCont++
					EndIf
					
					_lCont_ := .t.
					
					oPrint:Say(nLin,_aPos[_nPos], OemToAnsi(StrTran(StrZero(xPG->PG_HORA,5,2),'.',':'))	,oFont08)  //Marcacoes do Ponto
					nHrAnt := xPG->PG_HORA
					
					//Grava o Motivo
					If !Empty(xPG->PG_MOTIVRG) .And. !Empty(xPG->RFD_CODIGO) .And. xPG->RFD_CODIGO != "NULL"
						
						_cMotivo := xPG->RFD_CODIGO
					
						If aScan(_aMot,Alltrim(xPG->RFD_CODIGO) + " - " + Alltrim(xPG->PG_MOTIVRG)) == 0
							AADD(_aMot,Alltrim(xPG->RFD_CODIGO) + " - " + Alltrim(xPG->PG_MOTIVRG))
						EndIf

					EndIf
				
					DbSelectArea("xPG")
					DbSkip()
					
					If _dDtAtu != STOD(xPG->PG_DATA) //Se mudou a data, volta ao inicio da impressão
						
						_nLiAtu := nLin
						nLin += 40
						If nLin > _nLimite
							_fPlinha(_nAux)
							nAnt := nLin
						EndIf	
						
						If _nCont == 0
							_aPos2[_nP2] 	:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						Else
							_aPos2[4] 		:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						EndIf
						
						DbSelectArea("xPG")
						Loop
					EndIf	
					
					If nHrAnt == xPG->PG_HORA
					    
						//If _nCont == 0 .And. _nP2 > 1
						If _nP2 > 1 .And. _nP2 < 4
							_aPos2[_nP2] 	:= IIF(StrTran(StrZero(nHrAnt,5,2),'.',':') == _aPos2[_nP2-1],StrTran(StrZero(xPG->PG_HORA,5,2),'.',':'),StrTran(StrZero(nHrAnt,5,2),'.',':'))
						ElseIf _nCont == 0
							_aPos2[_nP2] 	:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						Else
							_aPos2[4] 		:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						EndIf
									
						//Grava o Motivo
						If !Empty(xPG->PG_MOTIVRG) .And. !Empty(xPG->RFD_CODIGO) .And. xPG->RFD_CODIGO != "NULL"
							
							_cMotivo := xPG->RFD_CODIGO
						
							If aScan(_aMot,Alltrim(xPG->RFD_CODIGO) + " - " + Alltrim(xPG->PG_MOTIVRG)) == 0
								AADD(_aMot,Alltrim(xPG->RFD_CODIGO) + " - " + Alltrim(xPG->PG_MOTIVRG))
							EndIf
		
						EndIf
						
					Else
						
						If _nP2 > 1 .And. _nP2 < 4
							_aPos2[_nP2] 	:= IIF(StrTran(StrZero(nHrAnt,5,2),'.',':') == _aPos2[_nP2-1],StrTran(StrZero(xPG->PG_HORA,5,2),'.',':'),StrTran(StrZero(nHrAnt,5,2),'.',':'))
						ElseIf _nCont == 0
							_aPos2[_nP2] 	:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						Else
							_aPos2[4] 		:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						EndIf
						
					Endif
               
					//Incrementa os contadores
					_nPos := IIF(_nPos >= 4, 1,_nPos + 1)
					
					//Se o registro foi desconsiderado, não incrementa a posição no array
					If !_lDescons
						If _nP2 > 1
							If _aPos2[_nP2] > _aPos2[_nP2-1] .And. _nP2 < 4
								_nP2 := IIF(_nP2 >= 4, 1,_nP2 + 1)
							EndIf
						ElseIf !Empty(_aPos2[_nP2])
							_nP2 := IIF(_nP2 >= 4, 1,_nP2 + 1)
						EndIf
					EndIf
					_lDescons := .f.
					
				Else
				
					If !Empty(_aPos2[1] + _aPos2[2] + _aPos2[3] + _aPos2[4] + _cMotivo) .And. _nPos == 1 .And. _lCont_
						_nCont++
					EndIf

					If _nCont == 0 .Or. _nP2 > 1 .And. _nP2 < 4
						_aPos2[_nP2] 	:= StrTran(StrZero(xPG->PG_HORA,5,2),'.',':') 
					Else
						_aPos2[4] 		:= StrTran(StrZero(xPG->PG_HORA,5,2),'.',':') 
					EndIf

					//Grava o Motivo
					If !Empty(xPG->PG_MOTIVRG) .And. !Empty(xPG->RFD_CODIGO) .And. xPG->RFD_CODIGO != "NULL"
						
						_cMotivo := xPG->RFD_CODIGO
					
						If aScan(_aMot,Alltrim(xPG->RFD_CODIGO) + " - " + Alltrim(xPG->PG_MOTIVRG)) == 0
							AADD(_aMot,Alltrim(xPG->RFD_CODIGO) + " - " + Alltrim(xPG->PG_MOTIVRG))
						EndIf

					EndIf
					
					//Se o registro foi desconsiderado, não incrementa a posição no array
					If !_lDescons
	 					If _nP2 > 1
							If _aPos2[_nP2] > _aPos2[_nP2-1] .And. _nP2 < 4
								_nP2 := IIF(_nP2 >= 4, 1,_nP2 + 1)
							EndIf
						ElseIf !Empty(_aPos2[_nP2])
							_nP2 := IIF(_nP2 >= 4, 1,_nP2 + 1)
						Endif
					EndIf
					_lDescons := .f.
					
					DbSelectArea("xPG")
					DbSkip()
					
					If _dDtAtu != STOD(xPG->PG_DATA) //Se mudou a data, volta ao inicio da impressão
						_nLiAtu := nLin
						nLin += 40
						If nLin > _nLimite
							_fPlinha(_nAux)
							nant := nLin
						EndIf	
						
						DbSelectArea("xPG")
						Loop
					EndIf						
				
				EndIf								
				
				//3a Entrada
				If Alltrim(xPG->PG_TPMARCA) == "3E"
					
					oPrint:Say(nLin,_aColun[7] + 10, OemToAnsi(StrTran(StrZero(xPG->PG_HORA,5,2),'.',':'))	,oFont08) //Jornada Realizada
					oPrint:Say(nLin,_aColun[9] + 10, OemToAnsi(xPG->RFD_CODIGO)	,oFont08)
					
					DbSelectArea("xPG")
					DbSkip()
					
					If _dDtAtu != STOD(xPG->PG_DATA) //Se mudou a data, volta ao inicio da impressão
						_nLiAtu := nLin
						nLin += 40
						If nLin > _nLimite
							_fPlinha(_nAux)
							nant := nLin
						EndIf	
						
						DbSelectArea("xPG")
						Loop
					EndIf
					
				EndIf				
				
				
				//3a Saida
				If Alltrim(xPG->PG_TPMARCA) == "3S"
					
					oPrint:Say(nLin,_aColun[8] + 10, OemToAnsi(StrTran(StrZero(xPG->PG_HORA,5,2),'.',':'))	,oFont08) //Jornada Realizada
					oPrint:Say(nLin,_aColun[9] + 10, OemToAnsi(xPG->RFD_CODIGO)	,oFont08)
					
					DbSelectArea("xPG")
					DbSkip()
					
					If _dDtAtu != STOD(xPG->PG_DATA) //Se mudou a data, volta ao inicio da impressão
						_nLiAtu := nLin
						nLin += 40						
						If nLin > _nLimite
							_fPlinha(_nAux)
							nant := nLin
						EndIf	
						
						DbSelectArea("xPG")
						Loop
					EndIf
					
				EndIf				
			
			EndDo
			
			If !Empty(_aPos2[1]) .Or. !Empty(_aPos2[3]) .Or. !Empty(_aPos2[3]) .Or. !Empty(_aPos2[4])
				oPrint:Say(nAnt,_aColun[3] + 10, OemToAnsi(_aPos2[1])	,oFont08) //1º Expediente
				oPrint:Say(nAnt,_aColun[4] + 10, OemToAnsi(_aPos2[2])	,oFont08) //1º Expediente
				oPrint:Say(nAnt,_aColun[5] + 10, OemToAnsi(_aPos2[3])	,oFont08) //2º Expediente
				oPrint:Say(nAnt,_aColun[6] + 10, OemToAnsi(_aPos2[4])	,oFont08) //2º Expediente
				oPrint:Say(nAnt,_aColun[9] + 10, OemToAnsi(_cMotivo)	,oFont08)
			EndIf			

		Else
			
			_cSQL := " Select P8_FILIAL,P8_MAT,P8_DATA,P8_HORA,P8_MOTIVRG,P8_FLAG,P8_TPMARCA,P8_APONTA,P8_TPMCREP,RFD_CODIGO From " + RetSqlName("SP8") + " _P8 "
			_cSQL += " 		Left Join " + RetSqlName("RFD") + " _FD on RFD_DESC = P8_MOTIVRG And _FD.D_E_L_E_T_ = ' ' "
			_cSQL += " Where P8_FILIAL Between '" + mv_par11 + "' And '" + mv_par12 + "' And P8_MAT = '" + xRA->RA_MAT + "' And P8_DATA = '" + DTOS(_dDtLim) + "' And _P8.D_E_L_E_T_ = ' ' And P8_APONTA = 'S' "
			_cSQL += " Order By P8_FILIAL,P8_MAT,P8_DATA,P8_HORA "
			_cSQL := ChangeQuery(_cSQL)
			
			If Select("xP8") > 0
				DbSelectArea("xP8")
				DbCloseArea()
			EndIf
			
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cSQL),"xP8", .T., .T.)			
			
			DbSelectArea("xP8")
			DbGoTop()
			
			While !Eof()
			
				_lDescons := IIF(Alltrim(xP8->P8_TPMCREP) != "D",.f.,.t.) //Verifica se a marcação deve ser desconsiderada
			
				If _nLiAtu == nLin .And. _dDtLim != mv_par01 
					nLin += 40
					nAnt := nLin
					If nLin > _nLimite
						_fPlinha(_nAux)
						nAnt := nLin
					EndIf
				EndIf			
								
				If _dDtAtu != STOD(xP8->P8_DATA) .And. !_lDia
					oPrint:Say(nLin,_aColun[1] + 20, OemToAnsi(SubStr(xP8->P8_DATA,7,2) + "/" + SubStr(xP8->P8_DATA,5,2))	,oFont08)
					_dDtAtu := STOD(xP8->P8_DATA)
					_nPos := _nP2 := 1
					_lDia := .t.
				EndIf
								
	         //Marcações do Ponto
				If /*Empty(xP8->P8_MOTIVRG) .Or.*/ xP8->P8_FLAG == "E"
				
					If !Empty(_aPos2[1] + _aPos2[2] + _aPos2[3] + _aPos2[4] + _cMotivo) .And. _nPos == 1 .And. _lCont_
						_nLiAtu := nLin
						nLin += 40
						If nLin > _nLimite
							_fPlinha(_nAux)
							nAnt := nLin
						EndIf	
						_nCont++
					EndIf
					
					_lCont_ := .t.
					
					oPrint:Say(nLin,_aPos[_nPos], OemToAnsi(StrTran(StrZero(xP8->P8_HORA,5,2),'.',':'))	,oFont08)  //Marcacoes do Ponto
					nHrAnt := xP8->P8_HORA
					
					//Grava o Motivo
					If !Empty(xP8->P8_MOTIVRG) .And. !Empty(xP8->RFD_CODIGO) .And. xP8->RFD_CODIGO != "NULL"
						
						_cMotivo := xP8->RFD_CODIGO
					
						If aScan(_aMot,Alltrim(xP8->RFD_CODIGO) + " - " + Alltrim(xP8->P8_MOTIVRG)) == 0
							AADD(_aMot,Alltrim(xP8->RFD_CODIGO) + " - " + Alltrim(xP8->P8_MOTIVRG))
						EndIf

					EndIf
				
					DbSelectArea("xP8")
					DbSkip()
					
					If _dDtAtu != STOD(xP8->P8_DATA) //Se mudou a data, volta ao inicio da impressão
						
						_nLiAtu := nLin
						nLin += 40
						If nLin > _nLimite
							_fPlinha(_nAux)
							nAnt := nLin
						EndIf	
						
						If _nCont == 0
							_aPos2[_nP2] 	:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						Else
							_aPos2[4] 		:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						EndIf
						
						DbSelectArea("xP8")
						Loop
					EndIf	
					
					If nHrAnt == xP8->P8_HORA
					    
						//If _nCont == 0 .And. _nP2 > 1
						If _nP2 > 1 .And. _nP2 < 4
							_aPos2[_nP2] 	:= IIF(StrTran(StrZero(nHrAnt,5,2),'.',':') == _aPos2[_nP2-1],StrTran(StrZero(xP8->P8_HORA,5,2),'.',':'),StrTran(StrZero(nHrAnt,5,2),'.',':'))
						ElseIf _nCont == 0
							_aPos2[_nP2] 	:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						Else
							_aPos2[4] 		:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						EndIf
									
						//Grava o Motivo
						If !Empty(xP8->P8_MOTIVRG) .And. !Empty(xP8->RFD_CODIGO) .And. xP8->RFD_CODIGO != "NULL"
							
							_cMotivo := xP8->RFD_CODIGO
						
							If aScan(_aMot,Alltrim(xP8->RFD_CODIGO) + " - " + Alltrim(xP8->P8_MOTIVRG)) == 0
								AADD(_aMot,Alltrim(xP8->RFD_CODIGO) + " - " + Alltrim(xP8->P8_MOTIVRG))
							EndIf
		
						EndIf
						
					Else
						
						If _nP2 > 1 .And. _nP2 < 4
							_aPos2[_nP2] 	:= IIF(StrTran(StrZero(nHrAnt,5,2),'.',':') == _aPos2[_nP2-1],StrTran(StrZero(xP8->P8_HORA,5,2),'.',':'),StrTran(StrZero(nHrAnt,5,2),'.',':'))
						ElseIf _nCont == 0
							_aPos2[_nP2] 	:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						Else
							_aPos2[4] 		:= StrTran(StrZero(nHrAnt,5,2),'.',':') 
						EndIf
						
					Endif
               
					//Incrementa os contadores 
					_nPos := IIF(_nPos >= 4, 1,_nPos + 1)
					
					//Se o registro foi desconsiderado, não incrementa a posição no array
					If !_lDescons
						If _nP2 > 1
							If _aPos2[_nP2] > _aPos2[_nP2-1] .And. _nP2 < 4
								_nP2 := IIF(_nP2 >= 4, 1,_nP2 + 1)
							EndIf
						ElseIf !Empty(_aPos2[_nP2])
							_nP2 := IIF(_nP2 >= 4, 1,_nP2 + 1)
						Endif
					EndIf
					_lDescons := .f.
				
				Else
				
					If !Empty(_aPos2[1] + _aPos2[2] + _aPos2[3] + _aPos2[4] + _cMotivo) .And. _nPos == 1 .And. _lCont_
						_nCont++
					EndIf

					If _nCont == 0 .Or. _nP2 > 1 .And. _nP2 < 4
						_aPos2[_nP2] 	:= StrTran(StrZero(xP8->P8_HORA,5,2),'.',':') 
					Else
						_aPos2[4] 		:= StrTran(StrZero(xP8->P8_HORA,5,2),'.',':') 
					EndIf

					//Grava o Motivo
					If !Empty(xP8->P8_MOTIVRG) .And. !Empty(xP8->RFD_CODIGO) .And. xP8->RFD_CODIGO != "NULL"
						
						_cMotivo := xP8->RFD_CODIGO
					
						If aScan(_aMot,Alltrim(xP8->RFD_CODIGO) + " - " + Alltrim(xP8->P8_MOTIVRG)) == 0
							AADD(_aMot,Alltrim(xP8->RFD_CODIGO) + " - " + Alltrim(xP8->P8_MOTIVRG))
						EndIf

					EndIf

					//Se o registro foi desconsiderado, não incrementa a posição no array
					If !_lDescons
	 					If _nP2 > 1
							If _aPos2[_nP2] > _aPos2[_nP2-1] .And. _nP2 < 4
								_nP2 := IIF(_nP2 >= 4, 1,_nP2 + 1)
							EndIf
						ElseIf !Empty(_aPos2[_nP2])
							_nP2 := IIF(_nP2 >= 4, 1,_nP2 + 1)
						Endif
					EndIf
					_lDescons := .f.
					
					DbSelectArea("xP8")
					DbSkip()
					
					If _dDtAtu != STOD(xP8->P8_DATA) //Se mudou a data, volta ao inicio da impressão
						_nLiAtu := nLin
						nLin += 40
						If nLin > _nLimite
							_fPlinha(_nAux)
							nant := nLin
						EndIf	
						
						DbSelectArea("xP8")
						Loop
					EndIf						
				
				EndIf								
				
				//3a Entrada
				If Alltrim(xP8->P8_TPMARCA) == "3E"
					
					oPrint:Say(nLin,_aColun[7] + 10, OemToAnsi(StrTran(StrZero(xP8->P8_HORA,5,2),'.',':'))	,oFont08) //Jornada Realizada
					oPrint:Say(nLin,_aColun[9] + 10, OemToAnsi(xP8->RFD_CODIGO)	,oFont08)
					
					DbSelectArea("xP8")
					DbSkip()
					
					If _dDtAtu != STOD(xP8->P8_DATA) //Se mudou a data, volta ao inicio da impressão
						_nLiAtu := nLin
						nLin += 40
						If nLin > _nLimite
							_fPlinha(_nAux)
							nant := nLin
						EndIf	
						
						DbSelectArea("xP8")
						Loop
					EndIf
					
				EndIf				
				
				
				//3a Saida
				If Alltrim(xP8->P8_TPMARCA) == "3S"
					
					oPrint:Say(nLin,_aColun[8] + 10, OemToAnsi(StrTran(StrZero(xP8->P8_HORA,5,2),'.',':'))	,oFont08) //Jornada Realizada
					oPrint:Say(nLin,_aColun[9] + 10, OemToAnsi(xP8->RFD_CODIGO)	,oFont08)
					
					DbSelectArea("xP8")
					DbSkip()
					
					If _dDtAtu != STOD(xP8->P8_DATA) //Se mudou a data, volta ao inicio da impressão
						_nLiAtu := nLin
						nLin += 40						
						If nLin > _nLimite
							_fPlinha(_nAux)
							nant := nLin
						EndIf	
						
						DbSelectArea("xP8")
						Loop
					EndIf
					
				EndIf				
			
			EndDo
			
			If !Empty(_aPos2[1]) .Or. !Empty(_aPos2[3]) .Or. !Empty(_aPos2[3]) .Or. !Empty(_aPos2[4])
				oPrint:Say(nAnt,_aColun[3] + 10, OemToAnsi(_aPos2[1])	,oFont08) //1º Expediente
				oPrint:Say(nAnt,_aColun[4] + 10, OemToAnsi(_aPos2[2])	,oFont08) //1º Expediente
				oPrint:Say(nAnt,_aColun[5] + 10, OemToAnsi(_aPos2[3])	,oFont08) //2º Expediente
				oPrint:Say(nAnt,_aColun[6] + 10, OemToAnsi(_aPos2[4])	,oFont08) //2º Expediente
				oPrint:Say(nAnt,_aColun[9] + 10, OemToAnsi(_cMotivo)	,oFont08)
			EndIf								
	
		EndIf
		
		_aArea := GetArea()
		
		//Calcula o saldo do Banco de Horas do Período Anterior
		If _dDtLim == mv_par01
			nSaldoAnt := 0
			dDataAux  := CTOD("  /  /  ")
		
			_cSQL := " Select PI_FILIAL,PI_MAT,PI_DATA,PI_PD,PI_STATUS,PI_QUANT,P9_TIPOCOD From " + RetSqlName("SPI") + " _PI "
			_cSQL += " 	Inner Join " + RetSqlName("SP9") + " _P9 on P9_CODIGO = PI_PD And _P9.D_E_L_E_T_ = ' ' "
			_cSQL += " Where PI_FILIAL Between '" + mv_par11 + "' And '" + mv_par12 + "' And PI_MAT = '" + xRA->RA_MAT + "' And PI_DATA < '" + DTOS(mv_par01) + "' And _PI.D_E_L_E_T_ = ' ' "
			_cSQL += " Order By PI_FILIAL,PI_MAT,PI_DATA,PI_PD "
			
			_cSQL := ChangeQuery(_cSQL)
			
			If Select("xPI") > 0
				DbSelectArea("xPI")
				DbCloseArea()
			EndIf
			
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cSQL),"xPI", .T., .T.)
			
			DbSelectArea("xPI")
			DbGoTop()
			
			While !Eof()
				If xPI->P9_TIPOCOD $  "1/3"
					
					nValor 	 := IIF(xPI->PI_STATUS == "B",0,xPI->PI_QUANT)					
				   dDataAux  := IIF(Empty(nValor), dDataAux, STOD(xPI->PI_DATA)) //Para valor nao nulo considera a Data para Referencia do Saldo
					nSaldoAnt := __TimeSum(nSaldoAnt,nValor)  
					
				Else
				
					nValor 	 := IIF(xPI->PI_STATUS == "B",0,xPI->PI_QUANT)					
				   dDataAux  := IIF(Empty(nValor), dDataAux, STOD(xPI->PI_DATA)) //Para valor nao nulo considera a Data para Referencia do Saldo
					nSaldoAnt := __TimeSub(nSaldoAnt,nValor)
				
				Endif
				nSaldo := nSaldoAnt
				
				DbSelectArea("xPI")
				DbSkip()
							
			EndDo			
			
		EndIf
		
		//Grava o Banco de Horas Nesta Data
		_cSQL := " Select PI_FILIAL,PI_MAT,PI_DATA,PI_PD,PI_STATUS,PI_QUANT,P9_TIPOCOD,P9_DESC From " + RetSqlName("SPI") + " _PI "
		_cSQL += " 	Inner Join " + RetSqlName("SP9") + " _P9 on P9_CODIGO = PI_PD And _P9.D_E_L_E_T_ = ' ' "
		_cSQL += " Where PI_FILIAL Between '" + mv_par11 + "' And '" + mv_par12 + "' And PI_MAT = '" + xRA->RA_MAT + "' And PI_DATA = '" + DTOS(_dDtLim) + "' And _PI.D_E_L_E_T_ = ' ' "
		_cSQL += " Order By PI_FILIAL,PI_MAT,PI_DATA,PI_PD "
		
		_cSQL := ChangeQuery(_cSQL)
		
		If Select("xPI") > 0
			DbSelectArea("xPI")
			DbCloseArea()
		EndIf
		
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cSQL),"xPI", .T., .T.)
		
		DbSelectArea("xPI")
		DbGoTop()
		
		_nL  := _nLiAB := nAnt
		nAnt := nLin
		
		nSaldoFim := IIF(nSaldoFim == 0,nSaldo,nSaldoFim)
		_n := 0 
		
		While !Eof()
		
			If _n > 0
				_nL += 40 
				
				If _nL > _nLimite
					nAnt := nLin
					nLin := _nL
					_fPLinha(_nAux)
					_nL := _nLiAB := nAnt := nLin
				EndIf
				
			EndIf
			
			If !_lDia
				oPrint:Say(_nL,_aColun[1] + 20, OemToAnsi(SubStr(xPI->PI_DATA,7,2) + "/" + SubStr(xPI->PI_DATA,5,2))	,oFont08)
				_lDia := .t.
			EndIf			
			
			oPrint:Say(_nL,_aColun[10] + 10, OemToAnsi(Alltrim(xPI->P9_DESC))	,oFont08)

			If xPI->P9_TIPOCOD $  "1/3" //Creditos
				
				nValor 	 := IIF(xPI->PI_STATUS == "B",0,xPI->PI_QUANT)
				oPrint:Say(_nL,_aColun[12] + 10, OemToAnsi(Transform(nValor,"@E 99999.99"))	,oFont08)
				nTotCrd 	 := __TimeSum(nTotCrd,nValor)
				
				nSaldoFim := __TimeSum(nSaldoFim,nValor)
				oPrint:Say(_nL,_aColun[13] + 10, OemToAnsi(Transform(nSaldoFim,"@E 99999.99"))	,oFont08)	
//				oPrint:Say(_nL,_aColun[14] + 10, OemToAnsi(IIF(xPI->PI_STATUS == "B","Baixado","Pendente"))	,oFont08)
				
			Else //Descontos
			
				nValor 	 := IIF(xPI->PI_STATUS == "B",0,xPI->PI_QUANT)
				oPrint:Say(_nL,_aColun[11] + 10, OemToAnsi(Transform(nValor,"@E 99999.99"))	,oFont08)
				nTotDeb 	 := __TimeSum(nTotDeb,nValor)
				
				nSaldoFim := __TimeSub(nSaldoFim,nValor)
				oPrint:Say(_nL,_aColun[13] + 10, OemToAnsi(Transform(nSaldoFim,"@E 99999.99"))	,oFont08)
//				oPrint:Say(_nL,_aColun[14] + 10, OemToAnsi(IIF(xPI->PI_STATUS == "B","Baixado","Pendente"))	,oFont08)
			EndIf		
			
			_n++
		     
			DbSelectArea("xPI")
			DbSkip()
		EndDo		
		
		If _nL >= nLin .And. _n > 0
			nLin := _nL + 40
			nAnt := nLin
		EndIf
		
		
		//Grava os descontos e motivos de abono
		_n := _nQuant := 0 
				
		If _dDtLim < dIniPonMes //Se a data for menor que o período em aberto, busca as informações de apontamento na tabela SPH. Senão busca na SPC
			_cSQL := "Select PH_FILIAL,PH_MAT,PH_DATA,PH_PD,PH_QUANTI,PH_QUANTC,PH_QTABONO,PH_ABONO,P6_DESC From " + RetSqlName("SPH") + " _PH "
			_cSQL += "	Left Join " + RetSqlName("SP6") + " _P6 on P6_CODIGO = PH_ABONO And _P6.D_E_L_E_T_ = ' ' "
			_cSQL += "Where PH_FILIAL Between '" + mv_par11 + "' And '" + mv_par12 + "' And PH_MAT = '" + xRA->RA_MAT + "' And PH_DATA = '" + DTOS(_dDtLim) + "' And ("
			For nx := 1 To Len(_aCodAbo)
				If nx == 1
					_cSQL += "PH_PD = '" + _aCodAbo[nx] + "' "
				Else
					_cSQL += "Or PH_PD = '" + _aCodAbo[nx] + "' "
				EndIf	
			Next 
			_cSQL += ")	And _PH.D_E_L_E_T_ = ' ' "			
			_cSQL += " Order By PH_FILIAL,PH_MAT,PH_DATA,PH_PD "
			
			_cSQL := ChangeQuery(_cSQL)
			
			If Select("xPH") > 0
				DbSelectArea("xPH")
				DbCloseArea()
			EndIf
			
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cSQL),"xPH", .T., .T.)
			
			DbSelectArea("xPH")
			DbGoTop()
			
			While !Eof()
			
				If _n > 0
					_nLiAB += 40 
					
					If _nLiAB > _nLimite
						nAnt := nLin
						nLin := _nLiAB
						_fPLinha(_nAux)
						_nLiAB := nAnt := nLin
					EndIf
					
				EndIf
				
				If !_lDia
					oPrint:Say(_nLiAB,_aColun[1] + 20, OemToAnsi(SubStr(xPH->PH_DATA,7,2) + "/" + SubStr(xPH->PH_DATA,5,2))	,oFont08)
					_lDia := .t.
				EndIf										

				_nQuant  := IIF(xPH->PH_QUANTI > 0,xPH->PH_QUANTI,xPH->PH_QUANTC)
				_nTotAbo := __TimeSum(_nTotAbo,xPH->PH_QTABONO)
				
				If xPH->PH_PD $ Alltrim(GetMV("MV__CODHE"))
					oPrint:Say(_nLiAB,_aColun[14] + 10, OemToAnsi(Transform(_nQuant,"@E 99999.99"))	,oFont08)
					nHE := __TimeSum(nHE,_nQuant)
				ElseIf xPH->PH_PD $ Alltrim(GetMV("MV__CODSAI"))
				oPrint:Say(_nLiAB,_aColun[15] + 10, OemToAnsi(Transform(_nQuant,"@E 99999.99"))	,oFont08)
					nSaiAnt := __TimeSum(nSaiAnt,_nQuant)
				ElseIf xPH->PH_PD $ Alltrim(GetMV("MV__CODFAL"))
					oPrint:Say(_nLiAB,_aColun[16] + 10, OemToAnsi(Transform(_nQuant,"@E 99999.99"))	,oFont08)
					nFalta := __TimeSum(nFalta,_nQuant)
				ElseIf xPH->PH_PD $ Alltrim(GetMV("MV__CODDSR"))
					oPrint:Say(_nLiAB,_aColun[17] + 10, OemToAnsi(Transform(_nQuant,"@E 99999.99"))	,oFont08)
					nDSR := __TimeSum(nDSR,_nQuant)
				EndIf
				
				If !Empty(xPH->PH_ABONO)
					oPrint:Say(_nLiAB,_aColun[18] + 10, OemToAnsi(Transform(xPH->PH_QTABONO,"@E 99999.99"))	,oFont08)
					oPrint:Say(_nLiAB,_aColun[19] + 10, OemToAnsi(Alltrim(xPH->P6_DESC))	,oFont08)
				EndIF               
            
				_n++
				
				DbSelectArea("xPH")
				DbSkip()
			EndDo
			
		Else
				
			_cSQL := "Select PC_FILIAL,PC_MAT,PC_DATA,PC_PD,PC_QUANTI,PC_QUANTC,PC_QTABONO,PC_ABONO,P6_DESC From " + RetSqlName("SPC") + " _PC "
			_cSQL += "	Left Join " + RetSqlName("SP6") + " _P6 on P6_CODIGO = PC_ABONO And _P6.D_E_L_E_T_ = ' ' "
			_cSQL += "Where PC_FILIAL Between '" + mv_par11 + "' And '" + mv_par12 + "' And PC_MAT = '" + xRA->RA_MAT + "' And PC_DATA = '" + DTOS(_dDtLim) + "' And ("
			For nx := 1 To Len(_aCodAbo)
				If nx == 1
					_cSQL += "PC_PD = '" + _aCodAbo[nx] + "' "
				Else
					_cSQL += "Or PC_PD = '" + _aCodAbo[nx] + "' "
				EndIf	
			Next 
			_cSQL += ")	And _PC.D_E_L_E_T_ = ' ' "			
			_cSQL += " Order By PC_FILIAL,PC_MAT,PC_DATA,PC_PD "
			
			_cSQL := ChangeQuery(_cSQL)
			
			If Select("xPC") > 0
				DbSelectArea("xPC")
				DbCloseArea()
			EndIf
			
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cSQL),"xPC", .T., .T.)
			
			DbSelectArea("xPC")
			DbGoTop()
			
			While !Eof()
			
				If _n > 0
					_nLiAB += 40 
					
					If _nLiAB > _nLimite
						nAnt := nLin
						nLin := _nLiAB
						_fPLinha(_nAux)
						_nLiAB := nAnt := nLin
					EndIf
					
				EndIf
				
				If !_lDia
					oPrint:Say(_nLiAB,_aColun[1] + 20, OemToAnsi(SubStr(xPC->PC_DATA,7,2) + "/" + SubStr(xPC->PC_DATA,5,2))	,oFont08)
					_lDia := .t.
				EndIf										

				_nQuant  := IIF(xPC->PC_QUANTI > 0,xPC->PC_QUANTI,xPC->PC_QUANTC)
				_nTotAbo := __TimeSum(_nTotAbo,xPC->PC_QTABONO)
				
				If xPC->PC_PD $ Alltrim(GetMV("MV__CODHE"))
					oPrint:Say(_nLiAB,_aColun[14] + 10, OemToAnsi(Transform(_nQuant,"@E 99999.99"))	,oFont08)
					nHE := __TimeSum(nHE,_nQuant)
				ElseIf xPC->PC_PD $ Alltrim(GetMV("MV__CODSAI"))
				oPrint:Say(_nLiAB,_aColun[15] + 10, OemToAnsi(Transform(_nQuant,"@E 99999.99"))	,oFont08)
					nSaiAnt := __TimeSum(nSaiAnt,_nQuant)
				ElseIf xPC->PC_PD $ Alltrim(GetMV("MV__CODFAL"))
					oPrint:Say(_nLiAB,_aColun[16] + 10, OemToAnsi(Transform(_nQuant,"@E 99999.99"))	,oFont08)
					nFalta := __TimeSum(nFalta,_nQuant)
				ElseIf xPC->PC_PD $ Alltrim(GetMV("MV__CODDSR"))
					oPrint:Say(_nLiAB,_aColun[17] + 10, OemToAnsi(Transform(_nQuant,"@E 99999.99"))	,oFont08)
					nDSR := __TimeSum(nDSR,_nQuant)
				EndIf
				
				If !Empty(xPC->PC_ABONO)
					oPrint:Say(_nLiAB,_aColun[18] + 10, OemToAnsi(Transform(xPC->PC_QTABONO,"@E 99999.99"))	,oFont08)
					oPrint:Say(_nLiAB,_aColun[19] + 10, OemToAnsi(Alltrim(xPC->P6_DESC))	,oFont08)
				EndIF               
            
				_n++
				
				DbSelectArea("xPC")
				DbSkip()
			EndDo
		Endif
		
		If _nLiAB >= nLin .And. _n > 0
			nLin := _nLiAB + 40
			nAnt := nLin
		EndIf		
					
		RestArea(_aArea)
					
		_dDtLim += 1 //Incrementa a data
		If nLin > _nLimite
			_fPlinha(_nAux)
			nAnt := nLin
		EndIf	
		
	EndDo
	
	oPrint:Line(_nAux- 20,_aColun[1],nLin,_aColun[1]) //Linha Vertical esquerda Dia
	oPrint:Line(_nAux- 20,_aColun[2],nLin,_aColun[2]) //Linha Vertical esquerda Ent
	oPrint:Line(_nAux- 20,_aColun[3],nLin,_aColun[3]) //Linha Vertical direita	Saida
	oPrint:Line(_nAux- 20,_aColun[4],nLin,_aColun[4]) //Linha Vertical direita Ent 1 / Sai 1 (Jornada)
	oPrint:Line(_nAux- 20,_aColun[5],nLin,_aColun[5]) //Linha Vertical direita Sai 1 / Ent 2 (Jornada)
	oPrint:Line(_nAux- 20,_aColun[6],nLin,_aColun[6]) //Linha Vertical direita Ent 2 / Sai 2 (Jornada)
	oPrint:Line(_nAux- 20,_aColun[7],nLin,_aColun[7]) //Linha Vertical direita Sai 2 / Ent 3 (Jornada)
	oPrint:Line(_nAux- 20,_aColun[8],nLin,_aColun[8]) //Linha Vertical direita Ent 3 / Sai 3 (Jornada) 
	oPrint:Line(_nAux- 20,_aColun[9],nLin,_aColun[9]) //Linha Vertical direita Sai 3 / Motivo (Jornada) 
	oPrint:Line(_nAux- 20,_aColun[10],nLin,_aColun[10]) //Linha Vertical direita Motivo
	oPrint:Line(_nAux- 20,_aColun[11],nLin,_aColun[11]) //Linha Vertical direita Evento (Banco)
	oPrint:Line(_nAux- 20,_aColun[12],nLin,_aColun[12]) //Linha Vertical direita Credito (Banco)
	oPrint:Line(_nAux- 20,_aColun[13],nLin,_aColun[13]) //Linha Vertical direita Debito (Banco)
	oPrint:Line(_nAux- 20,_aColun[14],nLin,_aColun[14]) //Linha Vertical direita Saldo (Banco)
	oPrint:Line(_nAux- 20,_aColun[14],nLin,_aColun[14]) //Linha Vertical direita Status (Banco)
	oPrint:Line(_nAux- 20,_aColun[15],nLin,_aColun[15]) //Linha Vertical direita Atraso (Desconto)
	oPrint:Line(_nAux- 20,_aColun[16],nLin,_aColun[16]) //Linha Vertical direita Sai. Ant (Desconto)
	oPrint:Line(_nAux- 20,_aColun[17],nLin,_aColun[17]) //Linha Vertical direita Falta (Desconto)						
	oPrint:Line(_nAux- 20,_aColun[18],nLin,_aColun[18]) //Linha Vertical direita DSR (Desconto)
	oPrint:Line(_nAux- 20,_aColun[19],nLin,_aColun[19]) //Linha Vertical direita DSR (Desconto)
	oPrint:Line(_nAux- 20,_aColun[20],nLin,_aColun[20]) //Linha Vertical direita Justificativa (Abono)	
	
	FPONR01_D(oPrint,k,Titulo,_aMot) //Imprime o Rodapé
	
	DbSelectArea("xRA")
	DbSkip()
EndDo

If Select("xP8") > 0
	DbSelectArea("xP8")
	DbCloseArea()
EndIf

If Select("xPC") > 0
	DbSelectArea("xPC")
	DbCloseArea()
EndIf

If Select("xPG") > 0
	DbSelectArea("xPG")
	DbCloseArea()
EndIf

If Select("xPH") > 0
	DbSelectArea("xPH")
	DbCloseArea()
EndIf

If Select("xPI") > 0
	DbSelectArea("xPI")
	DbCloseArea()
EndIf

If Select("xRA") > 0
	DbSelectArea("xRA")
	DbCloseArea()
EndIf

Return

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function _fPLinha(_nAnt)

If nLin > _nLimite

	If _nAnt > 0
		oPrint:Line(_nAnt- 20,_aColun[1],nLin,_aColun[1]) //Linha Vertical esquerda Dia
		oPrint:Line(_nAnt- 20,_aColun[2],nLin,_aColun[2]) //Linha Vertical esquerda Ent
		oPrint:Line(_nAnt- 20,_aColun[3],nLin,_aColun[3]) //Linha Vertical direita	Saida
		oPrint:Line(_nAnt- 20,_aColun[4],nLin,_aColun[4]) //Linha Vertical direita Ent 1 / Sai 1 (Jornada)
		oPrint:Line(_nAnt- 20,_aColun[5],nLin,_aColun[5]) //Linha Vertical direita Sai 1 / Ent 2 (Jornada)
		oPrint:Line(_nAnt- 20,_aColun[6],nLin,_aColun[6]) //Linha Vertical direita Ent 2 / Sai 2 (Jornada)
		oPrint:Line(_nAnt- 20,_aColun[7],nLin,_aColun[7]) //Linha Vertical direita Sai 2 / Ent 3 (Jornada)
		oPrint:Line(_nAnt- 20,_aColun[8],nLin,_aColun[8]) //Linha Vertical direita Ent 3 / Sai 3 (Jornada) 
		oPrint:Line(_nAnt- 20,_aColun[9],nLin,_aColun[9]) //Linha Vertical direita Sai 3 / Motivo (Jornada) 
		oPrint:Line(_nAnt- 20,_aColun[10],nLin,_aColun[10]) //Linha Vertical direita Motivo
		oPrint:Line(_nAnt- 20,_aColun[11],nLin,_aColun[11]) //Linha Vertical direita Evento (Banco)
		oPrint:Line(_nAnt- 20,_aColun[12],nLin,_aColun[12]) //Linha Vertical direita Credito (Banco)
		oPrint:Line(_nAnt- 20,_aColun[13],nLin,_aColun[13]) //Linha Vertical direita Debito (Banco)
		oPrint:Line(_nAnt- 20,_aColun[14],nLin,_aColun[14]) //Linha Vertical direita Saldo (Banco)
		oPrint:Line(_nAnt- 20,_aColun[14],nLin,_aColun[14]) //Linha Vertical direita Status (Banco)
		oPrint:Line(_nAnt- 20,_aColun[15],nLin,_aColun[15]) //Linha Vertical direita Atraso (Desconto)
		oPrint:Line(_nAnt- 20,_aColun[16],nLin,_aColun[16]) //Linha Vertical direita Sai. Ant (Desconto)
		oPrint:Line(_nAnt- 20,_aColun[17],nLin,_aColun[17]) //Linha Vertical direita Falta (Desconto)						
		oPrint:Line(_nAnt- 20,_aColun[18],nLin,_aColun[18]) //Linha Vertical direita DSR (Desconto)
		oPrint:Line(_nAnt- 20,_aColun[19],nLin,_aColun[19]) //Linha Vertical direita DSR (Desconto)
		oPrint:Line(_nAnt- 20,_aColun[20],nLin,_aColun[20]) //Linha Vertical direita Justificativa (Abono)
	EndIf	


	oPrint:EndPage() 					// Finaliza a Página
	nLin := 50
	FPONR01_C(oPrint,k,Titulo)		// Função que monta o Cabeçalho Padrão
	lFirstPage := .f.
EndIf

Return 

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function FPONR01_C(oPrint,k,Titulo)
Local nAnt := 0

oPrint:StartPage()   //Inicia uma nova página

nAnt := nLin

oPrint:Line(nLin,_aColun[1],nLin,_aColun[20]) //Linha horizontal
nLin += 20

oPrint:SayBitMap(nLin,_aColun[1] + 20,"logo_preto.bmp",0280,_aColun[1] + 30)
nLin += 90

oPrint:Say(nLin,0060, OemToAnsi("EMPRESA:"),oFont09N)
oPrint:Say(nLin,0260, OemToAnsi(Alltrim(SM0->M0_NOMECOM)),oFont09)

oPrint:Say(nLin,1200, OemToAnsi("ENDEREÇO:"),oFont09N)
oPrint:Say(nLin,1430, OemToAnsi(Alltrim(SM0->M0_ENDCOB)),oFont09)

oPrint:Say(nLin,2500, OemToAnsi("CNPJ:"),oFont09N)
oPrint:Say(nLin,2620, OemToAnsi(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")),oFont09)
nLin += 40

oPrint:Line(nLin,_aColun[1],nLin,_aColun[20]) //Linha horizontal
oPrint:Line(nAnt,_aColun[1],nLin,_aColun[1]) //Linha Vertical esquerda
oPrint:Line(nAnt,_aColun[20],nLin,_aColun[20]) //Linha Vertical direita
nAnt := nLin
nLin += 20

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
oPrint:Say(nLin,_aColun[1] + 20, OemToAnsi("FUNCIONÁRIO:"),oFont09N)
oPrint:Say(nLin,0350, OemToAnsi(Alltrim(xRA->RA_NOME)),oFont09)
oPrint:Say(nLin,1200, OemToAnsi("CTPS:"),oFont09N)
oPrint:Say(nLin,1350, OemToAnsi(Alltrim(xRA->RA_NUMCP)),oFont09)
oPrint:Say(nLin,1900, OemToAnsi("CATEGORIA:"),oFont09N)
oPrint:Say(nLin,2160, OemToAnsi(Alltrim(xRA->X5_DESCRI)),oFont09)
oPrint:Say(nLin,2680, OemToAnsi("ADMISSÃO:"),oFont09N)
oPrint:Say(nLin,2930, OemToAnsi(DTOC(STOD(xRA->RA_ADMISSA))),oFont09)
nLin += 50

oPrint:Say(nLin,_aColun[1] + 20, OemToAnsi("FUNÇÃO:"),oFont09N)
oPrint:Say(nLin,0350, OemToAnsi(Alltrim(xRA->RJ_DESC)),oFont09)
oPrint:Say(nLin,1200, OemToAnsi("SETOR:"),oFont09N)
oPrint:Say(nLin,1350, OemToAnsi(Alltrim(xRA->QB_DESCRIC)),oFont09)
oPrint:Say(nLin,1900, OemToAnsi("PERÍODO:"),oFont09N)
oPrint:Say(nLin,2160, OemToAnsi(DTOC(mv_par01) + " a " + DTOC(mv_par02)),oFont09)
oPrint:Say(nLin,2680, OemToAnsi("MATRÍCULA:"),oFont09N)
oPrint:Say(nLin,2930, OemToAnsi(Alltrim(xRA->RA_MAT)),oFont09)
nLin += 50 

oPrint:Say(nLin,_aColun[1] + 20, OemToAnsi("HORÁRIO DE TRABALHO:"),oFont09N)
oPrint:Say(nLin,0530, OemToAnsi(Alltrim(xRA->R6_DESC)),oFont09)
nLin += 50

oPrint:Line(nLin,_aColun[1],nLin,_aColun[20]) //Linha horizontal
oPrint:Line(nLin,_aColun[1],nAnt,_aColun[1]) //Linha Vertical esquerda
oPrint:Line(nLin,_aColun[20],nAnt,_aColun[20]) //Linha Vertical direita
nAnt := nLin
nLin += 20
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

oPrint:Line(nAnt,_aColun[1],nAnt + 200,_aColun[1]) //Linha Vertical esquerda
oPrint:Line(nAnt,_aColun[2],nAnt + 200,_aColun[2]) //Linha Vertical esquerda Antes de MARCACOES DO PONTO
oPrint:Line(nAnt,_aColun[20],nAnt + 200,_aColun[20]) //Linha Vertical direita
oPrint:Line(nAnt + 200,_aColun[1],nAnt + 200,_aColun[20]) //Linha horizontal

oPrint:Say(nLin,0200, OemToAnsi("MARCAÇÕES DO PONTO"),oFont09N)
oPrint:Say(nLin,0870, OemToAnsi("JORNADA REALIZADA"),oFont09N)
//oPrint:Say(nLin,1600, OemToAnsi("BANCO DE HORAS / HORAS EXTRAS"),oFont09N)
oPrint:Say(nLin,1800, OemToAnsi("BANCO DE HORAS"),oFont09N)
oPrint:Say(nLin,2450, OemToAnsi("FOLHA"),oFont09N) //oPrint:Say(nLin,2450, OemToAnsi("DESCONTOS"),oFont09N)
oPrint:Say(nLin,2980, OemToAnsi("ABONOS"),oFont09N)
nLin += 50

//oPrint:Line(nLin,_aColun[2],nLin,_aColun[3]) //Linha horizontal Marcacoes
oPrint:Line(nAnt,_aColun[3],nAnt + 200,_aColun[3]) //Linha Vertical Marcacoes

oPrint:Line(nAnt,_aColun[10],nAnt + 200,_aColun[10]) //Linha Vertical Jornada 
oPrint:Line(nLin,_aColun[3],nLin,_aColun[10]) //Linha horizontal Jornada

oPrint:Line(nAnt,_aColun[14],nAnt + 200,_aColun[14]) //Linha Vertical Bco. Horas

oPrint:Line(nAnt,_aColun[18],nAnt + 200,_aColun[18]) //Linha Vertical Desconto
nAnt := nLin
nlin += 20

//Jornada realizada
oPrint:Say(nLin,_aColun[3] + 10, OemToAnsi("1º Expediente"),oFont09N)
oPrint:Line(nAnt,_aColun[5],nAnt + 130,_aColun[5]) //Linha Vertical

oPrint:Say(nLin,_aColun[5] + 10, OemToAnsi("2º Expediente"),oFont09N)
oPrint:Line(nAnt,_aColun[7],nAnt + 130,_aColun[7]) //Linha Vertical

oPrint:Say(nLin,_aColun[7] + 10, OemToAnsi("3º Expediente"),oFont09N)
oPrint:Line(nAnt,_aColun[9],nAnt + 130,_aColun[9]) //Linha Vertical

nAnt := nLin
nLin += 60

oPrint:Line(nLin,_aColun[1],nLin,_aColun[20]) //Linha horizontal
nAnt := nLin
nLin += 20

oPrint:Say(nLin,_aColun[1] + 20, OemToAnsi("Dia"),oFont07N)

//Marcacoes do Ponto
oPrint:Say(nLin,_aPos[1], OemToAnsi("Ent"),oFont07N) //1º Expediente
oPrint:Say(nLin,_aPos[2], OemToAnsi("Saída"),oFont07N) //1º Expediente
oPrint:Say(nLin,_aPos[3], OemToAnsi("Ent"),oFont07N) //2º Expediente
oPrint:Say(nLin,_aPos[4], OemToAnsi("Saída"),oFont07N) //2º Expediente

//Jornada Realizada
oPrint:Say(nLin,_aColun[3] + 10, OemToAnsi("Ent"),oFont07N) //1º Expediente
oPrint:Say(nLin,_aColun[4] + 10, OemToAnsi("Saída"),oFont07N) //1º Expediente
oPrint:Say(nLin,_aColun[5] + 10, OemToAnsi("Ent"),oFont07N) //2º Expediente
oPrint:Say(nLin,_aColun[6] + 10, OemToAnsi("Saída"),oFont07N) //2º Expediente
oPrint:Say(nLin,_aColun[7] + 10, OemToAnsi("Ent"),oFont07N) //3º Expediente
oPrint:Say(nLin,_aColun[8] + 10, OemToAnsi("Saída"),oFont07N) //3º Expediente
oPrint:Say(nLin,_aColun[9] + 10, OemToAnsi("Motivo"),oFont07N)

//Banco De Horas / Horas extras
oPrint:Say(nLin,1695, OemToAnsi("Evento"),oFont07N) 	
oPrint:Line(nAnt,_aColun[11],nAnt + 50,_aColun[11])	//Linha Vertical
oPrint:Say(nLin,_aColun[11] + 10, OemToAnsi("Debito"),oFont07N) 	
oPrint:Line(nAnt,_aColun[12],nAnt + 50,_aColun[12]) //Linha Vertical
oPrint:Say(nLin,_aColun[12] + 10, OemToAnsi("Credito"),oFont07N) 	
oPrint:Line(nAnt,_aColun[13],nAnt + 50,_aColun[13]) //Linha Vertical
oPrint:Say(nLin,_aColun[13] + 10, OemToAnsi("Saldo"),oFont07N) 	
oPrint:Line(nAnt,_aColun[14],nAnt + 50,_aColun[14])	//Linha Vertical
//oPrint:Say(nLin,_aColun[14] + 10, OemToAnsi("Status"),oFont07N)

//Descontos
oPrint:Say(nLin,_aColun[14] + 10, OemToAnsi("Hora Extra"),oFont07N) //oPrint:Say(nLin,_aColun[14] + 10, OemToAnsi("Atraso")		,oFont07N)
oPrint:Line(nAnt,_aColun[15],nAnt + 50,_aColun[15]) //Linha Vertical
oPrint:Say(nLin,_aColun[15] + 10, OemToAnsi("Atraso"),oFont07N)
oPrint:Line(nAnt,_aColun[16],nAnt + 50,_aColun[16]) //Linha Vertical
oPrint:Say(nLin,_aColun[16] + 10, OemToAnsi("Falta"),oFont07N)
oPrint:Line(nAnt,_aColun[17],nAnt + 50,_aColun[17]) //Linha Vertical
oPrint:Say(nLin,_aColun[17] + 10, OemToAnsi("DSR"),oFont07N)

//Abonos
oPrint:Say(nLin,_aColun[18] + 10, OemToAnsi("Qt Abono"),oFont07N)
oPrint:Line(nAnt,_aColun[19],nAnt + 50,_aColun[19]) //Linha Vertical
oPrint:Say(nLin,3050, OemToAnsi("Justificativa"),oFont07N)

nLin += 50

Return

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function FPONR01_D(oPrint,k,Titulo,_aMot)
Local nAnt := nLin, _nL := 0, _nAux := 0

//nLin += 50 

oPrint:Line(nLin,_aColun[1],nLin,_aColun[20]) //Linha horizontal
nAnt := nLin
nLin += 20

//Previne que haja quebra de página na impressão do rodapé
If (nLin + 250) > _nLimite
	nLin := 4000
	_fPLinha(0)
	nAnt := nLin
	nLin += 20
	_nAux := 20	
EndIf	

oPrint:Say(nLin,_aColun[1] + 30, OemToAnsi("SALDO ANTERIOR:"),oFont09N)
oPrint:Say(nLin,0450, OemToAnsi(Transform(nSaldo,"@E 99999.99")),oFont09N)
oPrint:Line(nAnt - _nAux,_aColun[1],nAnt + 70,_aColun[1]) //Linha Vertical esquerda
oPrint:Line(nAnt - _nAux,0800,nAnt + 70,0800) //Linha Vertical
oPrint:Line(nAnt - _nAux,_aColun[20],nAnt + 70,_aColun[20]) //Linha Vertical direita

oPrint:Say(nLin,0870, OemToAnsi("RESUMO DOS APONTAMENTOS DO PERÍODO ="),oFont09N)
oPrint:Line(nAnt - _nAux,_aColun[11],nAnt + 70,_aColun[11]) //Linha Vertical
oPrint:Say(nLin,_aColun[11] + 10, OemToAnsi(Transform(nTotDeb,"@E 99999.99")),oFont08)
oPrint:Line(nAnt - _nAux,_aColun[12],nAnt + 70,_aColun[12]) //Linha Vertical
oPrint:Say(nLin,_aColun[12] + 10, OemToAnsi(Transform(nTotCrd,"@E 99999.99")),oFont08)
oPrint:Line(nAnt - _nAux,_aColun[13],nAnt + 70,_aColun[13]) //Linha Vertical
oPrint:Line(nAnt - _nAux,_aColun[14],nAnt + 70,_aColun[14]) //Linha Vertical
oPrint:Line(nAnt - _nAux,1720,nAnt + 70,1720) //Linha Vertical
oPrint:Line(nAnt - _nAux,_aColun[14],nAnt + 70,_aColun[14]) //Linha Vertical

If nHE > 0 //Total de HE
	oPrint:Say(nLin,_aColun[14] + 10, OemToAnsi(Transform(nHE,"@E 99999.99")),oFont08)
Endif

oPrint:Line(nAnt - _nAux,_aColun[15],nAnt + 70,_aColun[15]) //Linha Vertical

If nSaiAnt > 0 //Total De Saida antecipada
	oPrint:Say(nLin,_aColun[15] + 10, OemToAnsi(Transform(nSaiAnt,"@E 99999.99")),oFont08)
Endif

oPrint:Line(nAnt - _nAux,_aColun[16],nAnt + 70,_aColun[16]) //Linha Vertical

If nFalta > 0 //Total De Falta
	oPrint:Say(nLin,_aColun[16] + 10, OemToAnsi(Transform(nFalta,"@E 99999.99")),oFont08)
Endif

oPrint:Line(nAnt - _nAux,_aColun[17],nAnt + 70,_aColun[17]) //Linha Vertical

If nDSR > 0 //Total De DSR
	oPrint:Say(nLin,_aColun[17] + 10, OemToAnsi(Transform(nDSR,"@E 99999.99")),oFont08)
Endif

oPrint:Line(nAnt - _nAux,_aColun[18],nAnt + 70,_aColun[18]) //Linha Vertical

If _nTotAbo > 0 //Total de abonos
	//oPrint:Say(nLin,_aColun[18] + 10, OemToAnsi("Total De Abonos: " + Transform(_nTotAbo,"@E 99999.99")),oFont08)
	oPrint:Say(nLin,_aColun[18] + 10, OemToAnsi(Transform(_nTotAbo,"@E 99999.99")),oFont08)
EndIf

oPrint:Line(nAnt - _nAux,_aColun[19],nAnt + 70,_aColun[19]) //Linha Vertical
	
nAnt := nLin
nLin += 50

oPrint:Line(nLin,0800,nLin,_aColun[20]) //Linha horizontal
nAnt := nLin
nLin += 20

oPrint:Say(nLin,_aColun[1] + 30, OemToAnsi("SALDO ACUMULADO:"),oFont09N)
oPrint:Say(nLin,0450, OemToAnsi(Transform(nSaldoFim,"@E 99999.99")),oFont09N)
oPrint:Line(nAnt - _nAux,_aColun[1],nAnt + 70,_aColun[1]) //Linha Vertical esquerda
oPrint:Line(nAnt - _nAux,0800,nAnt + 70,0800) //Linha Vertical
oPrint:Line(nAnt - _nAux,_aColun[20],nAnt + 70,_aColun[20]) //Linha Vertical direita

oPrint:Say(nLin,1025, OemToAnsi("DESCRIÇÃO DOS MOTIVOS"),oFont09N)
_nL := nLin + 50
For nx := 1 To Len(_aMot)
	oPrint:Say(_nL,0870, OemToAnsi(_aMot[nx]),oFont08)	
	_nL += 40
Next
oPrint:Line(nAnt - _nAux,1720,nAnt + 70,1720) //Linha Vertical

oPrint:Say(nLin,1750, OemToAnsi("RESUMO DAS HORAS EXTRAS"),oFont09N)
oPrint:Line(nAnt - _nAux,_aColun[14],nAnt + 70,_aColun[14]) //XXX
/*
_nL := nLin + 50
For nx := 1 To Len(_aMot)
	oPrint:Say(_nL,1750, OemToAnsi(_aMot[nx]),oFont08)
	_nL += 40
Next
*/
oPrint:Say(nLin,2420, OemToAnsi("Reconheço que as marcações foram feitas por mim"),oFont09)
nAnt := nLin 
nLin += 50

oPrint:Line(nLin,_aColun[1],nLin,0800) //Linha horizontal
oPrint:Say(nLin,2420, OemToAnsi("e concordo com os apontamentos registrados acima"),oFont09)
//oPrint:Line(nAnt - _nAux,_aColun[14],nAnt + 90,_aColun[14]) //Linha Vertical
//oPrint:Line(nAnt - _nAux,_aColun[20],nAnt + 90,_aColun[20]) //Linha Vertical
nAnt := nLin
nLin += 35

oPrint:Say(nLin,_aColun[1] + 20, OemToAnsi("OBSERVAÇÃO"),oFont09N)
nLin += 40
oPrint:Say(nLin,_aColun[1] + 20, OemToAnsi("Emissão: " + DTOC(Date())),oFont09)
nLin += 100

oPrint:Say(nLin,2470, OemToAnsi("______________________________________"),oFont09)
nLin += 50
oPrint:Say(nLin,2565, OemToAnsi("ASSINATURA DO FUNCIONÁRIO"),oFont09)
nLin += 50

oPrint:Line(nAnt - _nAux,_aColun[1],nLin,_aColun[1]) //Linha Vertical esquerda
oPrint:Line(nAnt - _nAux,0800,nLin,0800) //Linha Vertical Observação
oPrint:Line(nAnt - _nAux,1720,nLin,1720) //Linha Descrição dos abonos
oPrint:Line(nAnt - _nAux,_aColun[14],nLin,_aColun[14]) //Linha Vertical Resumo das horas
oPrint:Line(nAnt - _nAux,_aColun[20],nLin,_aColun[20]) //Linha Vertical direita
oPrint:Line(nLin,_aColun[1],nLin,_aColun[20]) //Linha horizontal

nLin := 4000

Return

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function _FValidX1()

dbSelectArea("SX1")
dbSetOrder(1)

If !DbSeek(cPerg + "01")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Perido De?"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par01"
	MsUnLock()	
EndIf

If !DbSeek(cPerg + "02")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Perido Ate?"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par02"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "03")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Matricula De?"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_F3		 := "SRA"
	MsUnLock()	
EndIf

If !DbSeek(cPerg + "04")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Matricula Ate?"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3		 := "SRA"
	MsUnLock()	
EndIf

If !DbSeek(cPerg + "05")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Nome De?"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 30
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par05"
	MsUnLock()	
EndIf

If !DbSeek(cPerg + "06")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Nome Ate?"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 30
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par06"
	MsUnLock()	
EndIf

If !DbSeek(cPerg + "07")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Turno De?"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_F3		 := "SR6"
	MsUnLock()	
EndIf

If !DbSeek(cPerg + "08")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Turno Ate?"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par08"
	SX1->X1_F3		 := "SR6"
	MsUnLock()	
EndIf

If !DbSeek(cPerg + "09")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Centro De Custo De?"
	SX1->X1_VARIAVL := "mv_ch9"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 9
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par09"
	SX1->X1_F3		 := "CTT"
	MsUnLock()	
EndIf

If !DbSeek(cPerg + "10")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "10"
	SX1->X1_PERGUNT := "Centro De Custo Ate?"
	SX1->X1_VARIAVL := "mv_cha"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 9
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par10"
	SX1->X1_F3		 := "CTT"
EndIf

If !DbSeek(cPerg + "11")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "11"
	SX1->X1_PERGUNT := "Filial de?"
	SX1->X1_VARIAVL := "mv_chb"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par11"
	SX1->X1_F3		 := "SM0"
EndIf

If !DbSeek(cPerg + "12")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "12"
	SX1->X1_PERGUNT := "Filial ate?"
	SX1->X1_VARIAVL := "mv_chC"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par12"
	SX1->X1_F3		 := "SM0"
EndIf

Return