#INCLUDE "PROTHEUS.CH"
 
 /*
REQUISICAO AO ARMAZEM CONFORME OP E SZ9 
nOpcao := 
1 - INCLUSAO
2 - ALTERACAO
3 - EXCLUSAO
*/                                                


USER FUNCTION REQ_EST(nOpcao,cxCod,cxLocal,nxQtd,cxOP,dxEmis,cxNumSeq,cxTpMv,_cchave,_nrecno,lprod,cosseq,_ccoper)
// edson, ver enderecamento e lote   
//return nil
//static function naousar   
                                              
Local _aArea1  := GetArea()
Local _aArea2  := {}
Local lRet     := .T.   
Local cTM      := cxTpMv // tipo movimento
Local cCod     := LEFT(cxCod+SPACE(15),15) // codigo produto 
Local cUM      := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cxCod),"B1_UM") // unidade medida
//Incluso Edson Rodrigues 12/03/10 - Par verifica��o de saldo de lote/sublote e endere�o-------------------------
Local clocaliz := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cxCod),"B1_LOCALIZ") // Localizacao
Local crastro  := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cxCod),"B1_RASTRO") // Rastro                 
Local clotesub :=GetMV("MV_LOTESUB")   //Indica o Lote Sublote que ser� ultilizado no processo. Obs: talves ser� buscado na tabela ZZJ e vindo atraves do vetor
Local carmpec  :=GetMV("MV_ARMLPEC") // Indica o armazem e endere�o usado no processo. Obs: talves ser� buscado na tabela ZZJ e vindo atraves do vetor
                                    //  Alterado para buscar o dispon�vel no SBF dentro do armazem de peca e de acordo com a quantidade.
//--------------------------------------------------------------------------------------------------------------------------------------------------------
Local nQuant   := nxQtd // quantidade
Local cOP      := cxOP // codigo op
Local cLocal   := cxLocal //local armazem
Local dEmissao := dxEmis // emissao  
Local _cNSeq   := iif(cxNumSeq==nil,"",cxNumSeq)  // NUMSEQ
Local _cchave  := iif(_cchave ==nil,"",_cchave )  // CHAVE
Local _nrecno  := iif(_nrecno==nil,0,_nrecno)  // RECNO
Local cTMMEM   := "" 
Local nSallote := 0.00
Local nSalend  := 0.00
Local nSalb8   := 0.00
Local nSalbf   := 0.00
Local nSalb2   := 0.00    
Local alocaliz :={} 
Local alotes   :={}

u_GerA0003(ProcName())

IF nOpcao == 1                                                                                     
           //  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
           //-----|| VALIDA ESTOQUE PARA BAIXA
	        DBSELECTAREA("SB2")              
	        _aArea2 := GetArea()
	        dbsetorder(1)
	        dbgotop()
	        If !dbseek(xfilial("SB2")+cCod+cLocal)
		          MsgAlert("Almoxarifado "+cLocal+" do Produto "+cCod+" nao Localizado!")
	              Return(.f.)
	        Else       
	            /*                                                  
	            ���Parametros� ExpN1 = Saldo devolvido pela funcao                        ���
               ���          � ExpL1 = Flag que indica se chamada da funcao � utilizada p/���
               ���          � calculo de necessidade. Caso .T. deve considerar quantidade���
               ���          � a distribuir, pois a mesma apenas nao pode ser utilizada,  ���
               ���          � porem ja esta em estoque.                                  ���
               ���          � ExpL2 = Flag que indica se deve substrair o empenho do     ���
               ���          � saldo a ser retornado.                                     ���
               ���          � ExpD1 = Data final para filtragem de empenhos. Empenhos ate���
               ���          � esta data serao considerados no caso de leitura do SD4.    ���
               ���          � ExpL3 = Flag que indica se deve considerar o saldo de terc ���
               ���          � eiros em nosso poder ou nao (B2_QTNP).                     ���
               ���          � ExpL4 = Flag que indica se deve considerar nosso saldo em  ���
               ���          � poder de terceiros ou nao (B2_QNPT).                       ���
               ���          � ExpN1 = Qtd empenhada para esse movimento que nao deve ser ���
               ���          � subtraida                                                  ���
               ���          � ExpN2 = Qtd empenhada do Projeto para esse movimento que   ���
               ���          � nao deve ser subtraida                                     ���
               ���          � ExpL5 = Subtrai a Reserva do Saldo a ser Retornado?        ���
               //Function SaldoSB2(lNecessidade,lEmpenho,dDataFim,lConsTerc,lConsNPT,cAliasSB2,nQtdEmp,nQtdPrj,lSaldoSemR)    
                         
               //Op��o para ver o saldo dispon�vel SB2 atrav�s de fun��o do sistema - Edson Rodrigues - 15/03/10          
                    nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)    
                    IF  nSalb2 < nQuant
                        MsgAlert("Almoxarifado "+cLocal+" do Produto "+cCod+" sem estoque!")
		                       Return(.f.)
                    Endif
                */                                      
                 nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)    
		           If  nSalb2 < nQuant
		              MsgAlert("Almoxarifado "+cLocal+" do Produto "+cCod+" sem estoque!")
		              Return(.f.)
		           endif
	       Endif       
          
          //Incluso Edson Rodrigues 12/03/10 - Par verifica��o de saldo de lote/sublote -------------------------------------------------------------------------------------------------
          IF crastro $ "SL"
				 dbselectarea("SB8")
				 SB8->(dbsetorder(3))
				 //IF SB8->(DBSeek(xFilial('SB8')+cCod+cLocal+left(clotesub,10)+substr(clotesub,11,6)))  // Retirado essa op��o de procurar por lote e sublote definido
				 IF SB8->(DBSeek(xFilial('SB8')+cCod+cLocal))  
				   Do While !SB8->(EOF()) .AND. SB8->B8_FILIAL = XFILIAL("SB8") .AND. SB8->B8_PRODUTO = cCod .AND. SB8->B8_LOCAL = cLocal
				            nSallote =  QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,lEmpPrevisto,Nil,dEmis260)) 
				            nSalb8 +=  nSallote            
				            AADD(alotes,{nSallote,B8_DTVALID,B8_LOTECTL,B8_NUMLOTE})
				             /*
				                �������������������������������������������������������������������������Ĵ��
                            ���          �ExpL1 := Flag que indica se considera EMPENHO               ���
                            ���          �ExpL2 := Flag que indica se considera Lotes Vencidos        ���
                            ���          �ExpL3 := Flag que indica se considera o saldo a Classificar ���
                            ���          �ExpL4 := Flag que indica se calcula na 2a Unidade de Medida ���
                            ���          �ExpC1 := Caracter com alias do arquivo de query (OPCIONAL)  ���
                            ���          �ExpL5 := Flag que indica se esta baixando empenho previsto  ���
                            ���          �ExpL6 := Flag que indica se esta em consulta de saldo       ���
                            ���          �ExpD1 := Indica a data de referencia do saldo               ���
                            ���          �ExpL7 := Flag que indica se considera somente vlr. B8_SALDO ���
                            �������������������������������������������������������������������������Ĵ��
                            SB8Saldo(lBaixaEmp,lConsVenc,lConsClas,lSegUM,cAliasSB8,lEmpPrevisto,lConsulta,dDataRef,lSaldo)
				            */
				            //If 	SB8->B8_DTVALID > ddatabase 
						            //MsgAlert("Data de validade do lote/sublote: "+left(clotesub,10)+"/"+substr(clotesub,11,6)+" ,almoxarifado : "+cLocal+" do Produto "+cCod+"  Est� vencida!")
						            //Return(.f.)
						    //  Endif      
				            
				             SB8->(DbSkip())
			      EndDo
		         If    nSalb8 < nQuant
                 		  MsgAlert("Saldo de lotes para o almoxarifado : "+cLocal+" do Produto "+cCod+"  � insuficiente !")
                 		  Return(.f.)
		         Endif
		       Else    
		            MsgAlert("N�o h� lote para o almoxarifado : "+cLocal+" do Produto "+cCod+", favor verificar !")
					Return(.f.)	
				 ENDIF
			 ENDIF
          
          //Incluso Edson Rodrigues 12/03/10 - Par verifica��o de saldo de  endere�o-------------------------------------------------------------------------------------------------
          IF  clocaliz = "S"
                  dbselectarea("SBF")
			      SBF->(dbsetorder(2))
				  //IF SBF->(DBSeek(xFilial('SBF')+cLocal+substr(carmpec,3,15)+cCod))
				  IF SBF->(DbSeek(XFilial("SBF") + cCod + cLocal))
		              Do While ! SBF->(EOF()) .AND. SBF->BF_FILIAL = XFILIAL("SBF") .AND. SBF->BF_PRODUTO = cCod  .AND. SBF->BF_LOCAL = cLocal
			              nSalend := QtdComp(SaldoSBF(cLocal,SBF->BF_LOCALIZ,cCod,SBF->BF_NUMSERI,SBF->BF_LOTECTL,If(Rastro(cCod, 'S'),SBF->BF_NUMLOTE,'')))     
			              nSalbf+=nSalend
			              aadd(alocaliz,{nSalend,SBF->BF_LOCALIZ,SBF->BF_NUMSERI,SBF->BF_LOTECTL,SBF->BF_NUMLOTE}) 			                  
			              /*
			             	  ���� ExpN1 = Saldo devolvido pela funcao                        ���
                          ���� ExpC1 = Local a ter o saldo pesquisado                     ���
                          ���� ExpC2 = Localizacao a ter o saldo pesquisado               ���
                          ���� ExpC3 = Produto a ter o saldo pesquisado                   ���
                          ���� ExpC4 = Numero de Serie do produto                         ���
                          ���� ExpC5 = Lote do Produto a ter o saldo pesquisado           ���
                          ���� ExpC6 = Sub-Lote do Produto a ter o saldo pesquisado       ���
                          ���� ExpL1 = Indica se baixa ou nao o empenho                   ���
                          ���� ExpC7 = Codigo da Estrutura Fisica de Armazenagem          ���
                          ���� ExpL2 = Indica se calcula o saldo em potencia maxima ou nao���
                          Function SaldoSBF(cAlmox,cLocaliza,cCod,cNumSerie,cLoteCtl,cLote,lBaixaEmp,cEstFis,lPotMax)
                          */	            
			            SBF->(DbSkip())
	            	  EndDo
				      IF nSalbf  < nQuant 
				          MsgAlert("O Saldo do(s) endere�o(s) no, almoxarifado : "+cLocal+" do Produto "+cCod+" � insuficiente.  Favor verificar !")					  
				          Return(.f.)
					  ENDIF		
				  ELSE
                        MsgAlert("N�o Existem endere�o cadastrado para o almoxarifado : "+cLocal+" do Produto "+cCod+". favor verificar !")
					    Return(.f.)	
                  ENDIF
             ENDIF
ENDIF	

//=====|| Valida Endere�os/Lotes - Edson Rodrigues - 22/03/10
If Len(alocaliz) > 0  .and.  len(alotes) <= 0    //Quando tem endere�o e n�o tem lotes
        nSalend:=0                          
         lfim:=.f.
       For x:=1 to Len(alocaliz)
              nSalend:=alocaliz[x,1] 
             
              Do Case 
                     Case nSalend >= nQuant   //Produto com endere�o maior ou igual ao saldo da qtde movimentada 
                                lRet:=montvet(cTM,cCod,cUM,nQuant,cOP,cLocal,dEmissao,_cNSeq,alocaliz[x,4],alocaliz[x,5],ctod(" / / "),alocaliz[x,2],alocaliz[x,3],lRet,nOpcao,_cchave,_nrecno,lprod,cosseq,_ccoper)
                                nQuant-=nQuant
                                 lfim:=.t.
                     Case  nSalend  < nQuant    //Produto com endere�o menor que o saldo da qtde movimentada 
                               lRet:=montvet(cTM,cCod,cUM,nSalend,cOP,cLocal,dEmissao,_cNSeq,alocaliz[x,4],alocaliz[x,5],ctod(" / / "),alocaliz[x,2],alocaliz[x,3],lRet,nOpcao,_cchave,_nrecno,lprod,cosseq,_ccoper)
                                nQuant-=nSalend
               EndCase
               
               If lfim
                   Exit
               Endif
       Next

Elseif  Len(alocaliz) <=  0  .and.  len(alotes) <= 0    //Quando n�o tem endere�o e n�o tem lotes
          lRet:=montvet(cTM,cCod,cUM,nQuant,cOP,cLocal,dEmissao,_cNSeq,"","",ctod(" / / "),"","",lRet,nOpcao,_cchave,_nrecno,lprod,cosseq,_ccoper)

Elseif  Len(alocaliz) >  0  .and.  len(alotes) > 0    //Quando  tem endere�o e tem lotes
           // Fazer Tratamento para essa condi��o Edson Rodrigues 22/03/10
           lRet:=.t.

Elseif  Len(alocaliz) <=  0  .and.  len(alotes) > 0    //Quando n�o tem endere�o e tem lotes
           // Fazer Tratamento para essa condi��o Edson Rodrigues 22/03/10
           lRet:=.t.                  
Endif           

Restarea(_aArea1)

RETURN(lRet)


//=====|| MONTANDO VETOR
Static Function  montvet(cTM,cCod,cUM,nQuant,cOP,cLocal,dEmissao,_cNSeq,clote,csublot,ddtvalilot,cend,cnumseri,lret,nOpcao,_cchave,_nrecno,lprod,cosseq,cccusto)
aProc := {}
AADD(aProc,cTM)
AADD(aProc,cCod)
AADD(aProc,cUM)
AADD(aProc,nQuant)
AADD(aProc,cOP)
AADD(aProc,cLocal)
AADD(aProc,dEmissao)
AADD(aProc,_cNSeq)         
AADD(aProc,clote)
AADD(aProc,csublot)
AADD(aProc,ddtvalilot)
AADD(aProc,cend)          
AADD(aProc,cnumseri)
AADD(aProc,_cchave)          
AADD(aProc,_nrecno)
AADD(aProc,cosseq)
AADD(aProc,cccusto)
         
//=====|| operacoes de requisicao via execauto
DO CASE
//-----|| INCLUSAO
   CASE nOpcao == 1
      lRet := U_BGHOP007(aProc,.t.,"0",lprod)
      IF !lRet
         cMsgErr := "falha no processo de inclusao da requisicao!"
      ENDIF
      
//-----|| ALTERACAO
   CASE nOpcao == 2 
      lRet := U_BGHOP007(aProc,.f.,"0",lprod)
      IF lRet
         lRet := U_BGHOP007(aProc,.T.,"0",lprod)
         IF !lRet
            cMsgErr := "falha no processo de alteracao da requisicao [INCLUSAO]!"
         ENDIF
      
      ELSE
      	cMsgErr := "falha no processo de alteracao requisicao[EXCLUSAO]!"
      ENDIF
      
//-----|| EXCLUSAO
   CASE nOpcao == 3
      lRet := U_BGHOP007(aProc,.f.,"0",lprod)
      IF !lRet
      	cMsgErr := "falha no processo de exclusao requisicao[EXCLUSAO]!"
      ENDIF

//-----|| FALHA PARAMETROS
   OTHERWISE
   lRet := .F.	
   cMsgErr := "falha nos parametros da requisicao, defina(1-inclusao/2-alteracao/3-exclusao), codigo interno..."	
ENDCASE
RETURN(lRet)                                                   



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEQMOV    �Autor  � Edson Rodrigues    � Data �  24/03/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca a sequencia de moviementa��o para grava na tabela    ���
���          | SZ9 dos Parnumbers apontados                               ���                                                 
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION SEQMOV(cxCod,cxLocal,cxOP,dxEmis,cxTpMv,lprod,cosseq)

Local  cTM          := cxTpMv // tipo movimento
Local  _cnewpro  := LEFT(cxCod+SPACE(15),15) // codigo produto 
Local  COSOP    := cxOP // codigo op
Local  carmproc  := cxLocal //local armazem
Local  dEmissao := dxEmis // emissao  
Local _cseqSD3  := ""

If lprod 

   Dbselectarea("SD3")
   Dbsetorder(1)    
   IF SD3->(DBSeek(xFilial('SD3')+COSOP+_cnewpro+carmproc)) 
      Do While !SD3->(EOF()) .AND. SD3->D3_FILIAL = XFILIAL("SD3") .AND. SD3->D3_OP = COSOP .AND. SD3->D3_COD=_cnewpro  .and.   SD3->D3_LOCAL=carmproc   
           IF SD3->D3_OP=COSOP .AND.  SD3->D3_COD=_cnewpro .AND. SD3->D3_LOCAL=carmproc .AND.  SD3->D3_TM=cxTpMv    .AND. SD3->D3_EMISSAO=dxEmis .AND. SD3->D3_ESTORNO<>'S'  
               _lvalidD3   :=.t.
               _cseqSD3 := SD3->D3_NUMSEQ
           ENDIF
          SD3->(dbskip())
    ENDDO
   ENDIF
Else
  Dbselectarea("SD3")
   Dbsetorder(7)    
   IF SD3->(DBSeek(xFilial('SD3')+_cnewpro+carmproc+Dtos(dxEmis))) 
      Do While !SD3->(EOF()) .AND. SD3->D3_FILIAL = XFILIAL("SD3") .AND. SD3->D3_COD=_cnewpro  .and.   SD3->D3_LOCAL=carmproc  .and. DTOS(SD3->D3_EMISSAO) = Dtos(dxEmis) 
           IF SD3->D3_OSTEC=cosseq .AND.  SD3->D3_COD=_cnewpro .AND. SD3->D3_LOCAL=carmproc .AND.  SD3->D3_TM=cxTpMv    .AND. DTOS(SD3->D3_EMISSAO)=DTOS(dxEmis) .AND. SD3->D3_ESTORNO<>'S'  
               _lvalidD3   :=.t.
               _cseqSD3 := SD3->D3_NUMSEQ
           ENDIF
          SD3->(dbskip())
    ENDDO
   ENDIF
Endif   
Return(_cseqSD3)