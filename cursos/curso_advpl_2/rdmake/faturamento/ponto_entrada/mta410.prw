#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
/*          
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410    ºAutor  ³Edson Rodrigues     º Data ³ 24/03/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico BGH                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³Chamado a partir da funcao a410tudok                        º±±
±±º          ³Revisado - 23/08/04                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA410()
Local _nCntaCols,_nSaldoSB8
Local _lRetaCols 	:= .T.
Local _nPosDel   	:= Len(aHeader) + 1
Local _aAreaAtu	 	:= GetArea()
Local _aAreaSB8	 	:= SB8->( GetArea() )
Local _aAreaSC6	 	:= SC6->( GetArea() )
Local _aAreaSM2	 	:= SM2->( GetArea() )
Local _aAreaSB1	 	:= SB1->( GetArea() )
Local _nPosQtdven	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_QTDVEN" })
Local _nPosQtdLib	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_QTDLIB" })
Local _nPosLocal	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_LOCAL"})
Local _nPosReser	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_RESERVA"})
Local _nPosProd		:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_PRODUTO"})
Local _nPosNFOri	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_NFORI"})
Local _nPosSerOri	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_SERIORI"})
Local _nPosIdent	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_IDENTB6"})
Local _nPosLote		:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_LOTECTL"})
Local _nPositem		:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_ITEM"})
Local _nPosctr		:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_TRANSP" })
Local _nPosNFFat	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_NOTA" })

Private cMenNFOri		:= "" 


u_GerA0003(ProcName())

If M->C5_MOEDA <> 1  //AND M->C5_MOEDA<>"1"
	SM2->(dbSetOrder(1))//M2_DATA
	IF SM2->(dbSeek(DTOS(DDATABASE)))
	 DO CASE	  
	   CASE M->C5_MOEDA==2 .AND. SM2->M2_MOEDA2 <= 0.00
	      _lRetaCols:=.F.                       
	  
	   CASE M->C5_MOEDA==3 .AND. SM2->M2_MOEDA3 <= 0.00  
	    _lRetaCols:=.F.
	  
	   CASE M->C5_MOEDA==4 .AND. SM2->M2_MOEDA4 <= 0.00
	    _lRetaCols:=.F.
      
       CASE M->C5_MOEDA==5 .AND. SM2->M2_MOEDA5 <= 0.00
	    _lRetaCols:=.F.
	    
	   CASE M->C5_MOEDA==6 .AND. SM2->M2_MOEDA6 <= 0.00
	    _lRetaCols:=.F.
	    
	   CASE M->C5_MOEDA==7 .AND. SM2->M2_MOEDA7 <= 0.00
	    _lRetaCols:=.F.
	 ENDCASE
	
	ELSE
	  _lRetaCols:=.F. 
	ENDIF   
ENDIF

IF !_lRetaCols
    apMsgStop("Moeda : "+ALLTRIM(STR(M->C5_MOEDA))+" não cadastrada ou zerada, favor cadastrar","Moeda nao Cadastrada")
    If apMsgYesNo("Deseja alterar a  moeda "+ALLTRIM(STR(M->C5_MOEDA))+" para Moeda 1 ? Depois de cadastrada vc deverá alterar o pedido para a moeda : "+ALLTRIM(STR(M->C5_MOEDA))+" novamente. Confirma troca de moeda?","Moeda nao Cadastrada")
      _lRetaCols:=.t.
      M->C5_MOEDA:=1
    Endif
ENDIF

If (Inclui .OR. Altera) .and. _lRetaCols
	For nElemen := 1 To Len(aCols)
		If !Empty(aCols[nElemen][_nPosNFOri])
			NFORI(aCols[nElemen][_nPosNFOri],aCols[nElemen][_nPosSerOri],aCols[nElemen][_nPosProd],aCols[nElemen][_nPosIdent])		
		EndIf
	Next nElemen
	
	If !empty(cMenNFOri)
		cMenNFOri := " NF(s) Origem - "+Alltrim(cMenNFOri)
		If !AllTrim(cMenNFOri) $ M->C5_MENNOTA
			If len(Alltrim(cMenNFOri)+Alltrim(M->C5_MENNOTA))> TamSX3("C5_MENNOTA")[1]
				MsgAlert("Não será possivel incluir todas as NF(s) de Origem na mensagem do Pedido. Favor diminuir quantidade de itens do Pedido de Venda!")
				_lRetaCols:=.F.		
			Else
				M->C5_MENNOTA:=Alltrim(M->C5_MENNOTA)+ cMenNFOri
			Endif
		Endif
	Endif
Endif
	
RestArea( _aAreaSB8	)
RestArea( _aAreaSC6	)
RestArea( _aAreaAtu	)
RestArea( _aAreaSB1 )

Return(_lRetaCols )

Static Function NFORI(cNFori,cSerOri,cProduto,cIdent)

Local cQuery := ""

cQuery := " SELECT D1_NFORI, D1_SERIORI FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN "+RetSqlName("ZZQ")+" ZZQ " 
cQuery += " ON (ZZQ_FILIAL = '"+xFilial("ZZQ")+"' AND ZZQ_NFENTR=D1_DOC AND "
cQuery += " ZZQ_SERENT=D1_SERIE AND ZZQ_PECA=D1_COD AND ZZQ_NFORI=D1_NFORI AND "
cQuery += " ZZQ_SERORI=D1_SERIORI AND ZZQ.D_E_L_E_T_ = '') "
cQuery += " WHERE SD1.D_E_L_E_T_ <> '*'  "
cQuery += " AND D1_FILIAL = '"+xFilial("SD1")+"'  "
cQuery += " AND D1_DOC = '"+cNFori+"'  "
cQuery += " AND D1_SERIE = '"+cSerOri+"'  "
cQuery += " AND D1_COD = '"+cProduto+"'  "
cQuery += " AND D1_IDENTB6 = '"+cIdent+"'  "
cQuery += " AND D1_NFORI <> ''  "
     

If Select ("TSQL") > 0
	TSQL->(DBCLOSEAREA())
EndIf

TCQUERY cQuery NEW ALIAS "TSQL"

dbSelectArea("TSQL")
TSQL->(dbGotop())

If TSQL->(!Eof())
	If !AllTrim(TSQL->D1_NFORI+"-"+TSQL->D1_SERIORI) $ cMenNFOri
		If Len(cMenNFOri) > 0 .And. SubStr(cMenNFOri, Len(cMenNFOri), 1) <> " "
			cMenNFOri += " "
		EndIf
		cMenNFOri += AllTrim(TSQL->D1_NFORI+"-"+TSQL->D1_SERIORI)+space(1)
	EndIf
Endif

// If Select("TSQL")	<> 0
  //	TSQL->(DbCloseArea())
// Endif

Return