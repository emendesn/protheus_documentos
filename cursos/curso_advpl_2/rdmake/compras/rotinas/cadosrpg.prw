#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CADOSPRG  ³ Autor ³ Edson Rodrigues       ³ Data ³ 23/06/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastra OS Nextel do Processo RPG                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CADOSPRG(_cNF,_cSERIE,_cODCLI,_cLOJA,_cFORMUL,_CITEM,_CGRADE,_CPRODUT,_DDTEMIS,_DDTDIGT,_NDTDE,_copcao)
Local oGetD
Local oSay                                       
Local nOpcA    := 0
Local aArea    := GetArea()
Local aSavAcols:= {}
Local aSavAHead:= {}
Local nSavN    := 0
Local cCadastro:= OemToAnsi("Cadastra OS Nextel Processo RPG")
Local nUsado   := 0
Local nTotDesp := 0
Local nTotDCli := 0
Local nTotDFab := 0
Local nPosSer  := 0
Local nPosVlr  := 0
Local lRet     := .T.
Local nOpcx    := iif(inclui, 3, iif(altera, 4, 2))
Local nOper    := aRotina[ nOpcx, 4 ]
Local nCntFor  := 0
Local lExibe   := .t.


Private aHeaderZZL := {}
Private aColsZZL   := {}                     
Private _cnfe      :=_cNF
Private _cnfeser   :=_cSERIE
Private _cclifor   :=_cODCLI
Private _cljclif   :=_cLOJA
Private _cformp    :=IIF(_cFORMUL='N',' ',_cFORMUL)
Private _citemD1   :=_CITEM
Private _cgradD1   :=_CGRADE
Private _cprodD1   :=_CPRODUT
private _ddatadg   :=_DDTDIGT
private _ddataem   :=_DDTEMIS
private _nqtdeD1   := _NDTDE
private _copcent   :=_copcao                                                                                            
private oDlgnex
Private oGetosnex
Private _cseq	    := '00'
Private aSavAcols := {}
Private	aSavAhead := {}
Private _lTudoOk  := .F.
Private	nSavN
Private cSEQUENCIA := _cseq

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Aheader ZZL                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Empty(aHeaderZZL))
	// Inclusao dos campos usados no aHeader
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("ZZL")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZZL") )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			aadd(aHeaderZZL,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
			//			nUsado++
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ--¿
//³Monta aCols ZZL                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado := Len(aHeaderZZL)
ZZL->(dbSetOrder(1))//ZZL_FILIAL, ZZL_DOC, ZZL_SERIE,ZZL_FORNEC,ZZL_LOJA,ZZL_ITEMD1,ZZL_FORMUL,ZZL_ITEGRD
_cChave := _cnfe+_cnfeser+_cclifor+_cljclif+_citemD1+_cformp+_cgradD1

If ZZL->(dbSeek( xFilial("ZZL") + _cChave + '01' ))
	
	While ZZL->(!Eof()) .AND. xFilial("ZZL") == ZZL->ZZL_FILIAL .AND. ZZL->(ZZL_DOC+ZZL_SERIE+ZZL_FORNEC+ZZL_LOJA+ZZL_ITEMD1+ZZL_FORMUL+ZZL_ITEGRD)==_cChave 
	  IF ZZL->ZZL_STATUS $ '0/1'
	     aadd(aColsZZL,Array(nUsado+1))
		 For nCntFor := 1 To nUsado
			If ( aHeaderZZL[nCntFor][10] == "V" )
				aColsZZL[Len(aColsZZL)][nCntFor] := CriaVar(aHeaderZZL[nCntFor][2])
			Else
				aColsZZL[Len(aColsZZL)][nCntFor] := ZZL->(FieldGet(FieldPos(aHeaderZZL[nCntFor][2])))
			EndIf
		 Next nCntFor
		
		 aColsZZL[Len(aColsZZL)][nUsado+1] := .F.
		 _cseq := ZZL->ZZL_SEQ
		 
	  Endif
	  ZZL->(dbSkip())
	EndDo         
	
	
EndIf

If ( lExibe )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Salva o aCols   de Entrada e Desabilita o Paint da Primeira GetDados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSavAcols:= aClone(aCols)
	aSavAhead:= aClone(aHeader)
	aHeader  := aClone(aHeaderZZL)
	aCols    := aClone(aColsZZL)
	nSavN    := N
	N        := 1
  //	aCols[2][N] :=_nqtdeD1
	_cosnext     := ""
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a GetDados                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If inclui .and. _copcao=='0'
     	DEFINE MSDIALOG oDlgnex TITLE cCadastro From 020,0 to 38,80
	      @ 015,005 SAY RetTitle("ZZL_DOC")   + ": " + alltrim(_cnfe) OF oDlgnex PIXEL
	      @ 015,100 SAY RetTitle("ZZL_SERIE") + ": " + alltrim(_cnfeser) OF oDlgnex PIXEL
	      @ 025,005 SAY RetTitle("ZZL_FORNEC")+ ": " + ALLTRIM(_cclifor) OF oDlgnex PIXEL
	      @ 025,100 SAY RetTitle("ZZL_LOJA")  + ": " + ALLTRIM(_cljclif) OF oDlgnex PIXEL
	      @ 015,200 SAY RetTitle("ZZL_CODPRO")+ ": " + alltrim(_cprodD1) OF oDlgnex PIXEL
	      @ 025,200 SAY RetTitle("ZZL_ITEMD1")+ ": " + alltrim(_citemD1) OF oDlgnex PIXEL
	
	      oGetosnex := MsGetDados():New(034,001,120,316,nOpcx,,"AllwaysTrue","+ZZL_SEQ", ( nOper == 4 .Or. nOper == 3 ) )
	      //acols[1][1]:=soma1(_cseq,2)
	      //ACTIVATE MSDIALOG oDlgnex ON INIT EnchoiceBar(oDlgnex, {|| if(oGetosnex:TudoOk() .and. inclui .and. _copcao='0' , if(Grava(_citemD1,_cprodD1,_cItem,_cChave),oDlgnex:End(),oDlgnex),oDlgnex:End())} , {|| DelOsNex(_citemD1,_cprodD1,_cItem,_cChave)})
	      ACTIVATE MSDIALOG oDlgnex ON INIT EnchoiceBar(oDlgnex, {|| if(inclui .and. _copcao='0' , if(Grava(_citemD1,_cprodD1,_cseq,_cChave),oDlgnex:End(),oDlgnex),oDlgnex:End())} , {|| DelOsNex(_citemD1,_cprodD1,_cseq,_cChave)})
    
    
    Elseif ((inclui .and. _copcao=='1') .or.  (!inclui .and. _copcao=='2'))
         Grava(_citemD1,_cprodD1,_cseq,_cChave)
    Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retorna ao Estado de Entrada                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader  := aClone(aSavAHead)
	aCols    := aClone(aSavACols)
	N        := nSavN
	
EndIf

RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Grava     ºAutor  ³Edson Rodrigues     º Data ³  23/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava temporariamente os dados inseridos no ZZL             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grava(_citemD1,_cprodD1,_cseq,_cChave)

local _nPoscseq   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_SEQ"})   
local _nPosqtde   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_QTDE"})
local _nPosOSNX   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_OSNEXT"})
local _nPosmode   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_MODELO"})
local _nPosprom   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_PROMOT"})
local _lret      :=.T.

ZZL->(dbSetOrder(1))   //ZZL_FILIAL, ZZL_DOC, ZZL_SERIE,ZZL_FORNEC,ZZL_LOJA,ZZL_ITEMD1,ZZL_FORMIL,ZZL_ITEGRD

If len(aCols) > 0
   // Grava todos os Part Numbers apontados neste momento
   nqtde:=0
   For _nI := 1 To len(aCols)
      IF !acols[_ni,len(aCols[_nI])]
		   lNovo := .t. 
		   aCols[_nI,_nPoscseq]:=IIF(EMPTY(aCols[_nI,_nPoscseq]),_cseq,aCols[_nI,_nPoscseq])
	       aCols[_nI,_nPosprom]:=Posicione("SB1",1,xFilial("SB1") + _cprodD1, "B1_CODMOTO")
	       aCols[_nI,_nPosmode]:=Posicione("SB1",1,xFilial("SB1") + _cprodD1, "B1_GRUPO")
	 	   _coldosnex:="" 
	       
	       IF (_nqtdeD1 > 0 .and. aCols[_nI,_nPosqtde]  > 0) .or.   (_nqtdeD1= 0)
	       
	          nqtde+=aCols[_nI,_nPosqtde] 
	             
	          If nqtde <= _nqtdeD1
	             If ZZL->(dbSeek(xFilial("ZZL") + _cChave + aCols[_nI,_nPoscseq] ))
				   If EMPTY(ZZL->ZZL_OSNEXT) .AND. ZZL->ZZL_STATUS='0' .AND. ZZL->ZZL_QTDE <= 0 
				      lNovo := .T.
				   Else
				    lNovo := .F.     
				    _coldosnex:=IIF(!EMPTY(ZZL->ZZL_OSNEXT),ZZL->ZZL_OSNEXT,"")
				   Endif   
				   U_ADDZZL(.F.,lNovo)
		         Else 
		           U_ADDZZL(.T.,lNovo) 
		         Endif
		      Else
		        _lret:=.F.
		        MsgAlert("A soma das Quantidades digitadas é superior ao digitado no item da NF . Favor digitar uma quantidade válida ! ")
		      Endif     
		   Else
		      _lret:=.F.
		      MsgAlert("A Quantidade digitada deve ser maior que zero  . Favor digitar uma quantidade válida ! ")
		   Endif         
	  ELSE
	     IF ZZL->(dbSeek(xFilial("ZZL") + _cChave + aCols[_nI,_nPoscseq] )) //.and. !acols[_ni,len(aCols[_nI])]
        	reclock("ZZL",.f.)
			   dbDelete()
			msunlock()
	     ENDIF
	  ENDIF	   
   Next    
   If  nqtde > 0 .and. nqtde < _nqtdeD1
       _lret:=.F.
	   MsgAlert("A soma das Quantidades digitadas é inferior ao digitado no item da NF . Favor digitar uma quantidade válida ! ")   
   Endif
   

   //oDlgnex:End()
   //_lTudoOk := .T.
Else
  MsgAlert("Favor digitar a OS Nextel, caso deseje sair sem gravar, ultilize o botao SAIR. Digitar OS Nextel! ")
  _lret:=.F.
Endif

Return(_lret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelOSNex  ºAutor  ³Edson Rodrigues     º Data ³  24/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DelOsNex(_citemD1,_cprodD1,_cseq,_cChave)

If !(oGetosnex:TudoOk())
	If ApMsgYesNo("Nao deseja cadastrar as OS para esse Produto?")
		_lValidPartNO := .F.
		oDlgnex:End()
	EndIf
Else
	oDlgnex:End()
EndIf

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADDZZL    ºAutor  ³Edson Rodrigues     º Data ³  24/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona dados na tabela ZZL                                º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function ADDZZL(Inclui,lNovo)                                 
local _nPoscseq   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_SEQ"})     
local _nPosqtde   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_QTDE"})
local _nPosOSNX   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_OSNEXT"})
local _nPosCLNX   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_CLINEX"})
local _nPosOBGH   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_OBSBGH"})
local _nPosmode   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_MODELO"})
local _nPosprom   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_PROMOT"})


If Inclui .AND. lNovo	 		
   RecLock("ZZL",.T.)
     ZZL->ZZL_FILIAL := xFilial("ZZL")
	 ZZL->ZZL_DOC    := _cnfe
	 ZZL->ZZL_SERIE  := _cnfeser
	 ZZL->ZZL_FORNEC := _cclifor
	 ZZL->ZZL_LOJA   := _cljclif
	 ZZL->ZZL_FORMUL := IIF(_cformp=='N','',_cformp)
     ZZL->ZZL_ITEMD1 := _citemD1
     ZZL->ZZL_ITEGRD := _cgradD1
     ZZL->ZZL_CODPRO := _cprodD1
     ZZL->ZZL_DTEMIS := _ddataem
     ZZL->ZZL_DTDIGT := _ddatadg
     ZZL->ZZL_SEQ    := aCols[_nI,_nPoscseq]
     ZZL->ZZL_QTDE   := aCols[_nI,_nPosqtde]
     ZZL->ZZL_OSNEXT := aCols[_nI,_nPosOSNX]
     ZZL->ZZL_STATUS := _copcent
     ZZL->ZZL_CLINEX := aCols[_nI,_nPosCLNX]
     ZZL->ZZL_OBSBGH := aCols[_nI,_nPosOBGH]
     ZZL->ZZL_MODELO := aCols[_nI,_nPosmode]
     ZZL->ZZL_PROMOT := aCols[_nI,_nPosprom]

Else
   RecLock("ZZL",.F.)
     ZZL->ZZL_FILIAL := xFilial("ZZL")
	 ZZL->ZZL_DOC    := _cnfe
	 ZZL->ZZL_SERIE  := _cnfeser
	 ZZL->ZZL_FORNEC := _cclifor
	 ZZL->ZZL_LOJA   := _cljclif
	 ZZL->ZZL_FORMUL := _cformp
     ZZL->ZZL_ITEMD1 := _citemD1
     ZZL->ZZL_ITEGRD := _cgradD1
     ZZL->ZZL_CODPRO := _cprodD1
     ZZL->ZZL_DTEMIS := _ddataem
     ZZL->ZZL_DTDIGT := _ddatadg
     ZZL->ZZL_SEQ    := aCols[_nI,_nPoscseq]
     ZZL->ZZL_QTDE   := aCols[_nI,_nPosqtde]
     ZZL->ZZL_OSNEXT := aCols[_nI,_nPosOSNX]
     ZZL->ZZL_STATUS := _copcent                  
     ZZL->ZZL_CLINEX := aCols[_nI,_nPosCLNX]  
     ZZL->ZZL_OBSBGH := aCols[_nI,_nPosOBGH]   
     ZZL->ZZL_MODELO := aCols[_nI,_nPosmode]
     ZZL->ZZL_PROMOT := aCols[_nI,_nPosprom]
ENDIF			   
MsUnlock()
commit
return()                                                          




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³vldzzl  ºAutor  Edson Rodrigues        º Data ³  08/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida variáveis de memória da tabela ZZL                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function vldZZL()

local _lRet     := .t.
local _aAreaSB1 := SB1->(GetArea())


if readvar() == "M->ZZL_QTDE"  .OR. readvar() == "M->ZZL_OSNEXT" 

       _nPosmode   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_MODELO"})
       _nPosprom   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZL_PROMOT"})
	   
	   if Empty(aCols[n,_nPosprom])
           aCols[n,_nPosprom]:=Posicione("SB1",1,xFilial("SB1") + _cprodD1, "B1_CODMOTO")
	   ENDIF
	
	   if Empty(aCols[n,_nPosmode])
           aCols[n,_nPosmode]:=Posicione("SB1",1,xFilial("SB1") + _cprodD1, "B1_GRUPO")
	   ENDIF
	
Endif	   
	 

RestArea(_aAreaSB1)

return(_lRet)
