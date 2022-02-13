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
//Incluso Edson Rodrigues 12/03/10 - Par verificação de saldo de lote/sublote e endereço-------------------------
Local clocaliz := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cxCod),"B1_LOCALIZ") // Localizacao
Local crastro  := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cxCod),"B1_RASTRO") // Rastro                 
Local clotesub :=GetMV("MV_LOTESUB")   //Indica o Lote Sublote que será ultilizado no processo. Obs: talves será buscado na tabela ZZJ e vindo atraves do vetor
Local carmpec  :=GetMV("MV_ARMLPEC") // Indica o armazem e endereço usado no processo. Obs: talves será buscado na tabela ZZJ e vindo atraves do vetor
                                    //  Alterado para buscar o disponível no SBF dentro do armazem de peca e de acordo com a quantidade.
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
	            ±±³Parametros³ ExpN1 = Saldo devolvido pela funcao                        ³±±
               ±±³          ³ ExpL1 = Flag que indica se chamada da funcao ‚ utilizada p/³±±
               ±±³          ³ calculo de necessidade. Caso .T. deve considerar quantidade³±±
               ±±³          ³ a distribuir, pois a mesma apenas nao pode ser utilizada,  ³±±
               ±±³          ³ porem ja esta em estoque.                                  ³±±
               ±±³          ³ ExpL2 = Flag que indica se deve substrair o empenho do     ³±±
               ±±³          ³ saldo a ser retornado.                                     ³±±
               ±±³          ³ ExpD1 = Data final para filtragem de empenhos. Empenhos ate³±±
               ±±³          ³ esta data serao considerados no caso de leitura do SD4.    ³±±
               ±±³          ³ ExpL3 = Flag que indica se deve considerar o saldo de terc ³±±
               ±±³          ³ eiros em nosso poder ou nao (B2_QTNP).                     ³±±
               ±±³          ³ ExpL4 = Flag que indica se deve considerar nosso saldo em  ³±±
               ±±³          ³ poder de terceiros ou nao (B2_QNPT).                       ³±±
               ±±³          ³ ExpN1 = Qtd empenhada para esse movimento que nao deve ser ³±±
               ±±³          ³ subtraida                                                  ³±±
               ±±³          ³ ExpN2 = Qtd empenhada do Projeto para esse movimento que   ³±±
               ±±³          ³ nao deve ser subtraida                                     ³±±
               ±±³          ³ ExpL5 = Subtrai a Reserva do Saldo a ser Retornado?        ³±±
               //Function SaldoSB2(lNecessidade,lEmpenho,dDataFim,lConsTerc,lConsNPT,cAliasSB2,nQtdEmp,nQtdPrj,lSaldoSemR)    
                         
               //Opção para ver o saldo disponível SB2 através de função do sistema - Edson Rodrigues - 15/03/10          
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
          
          //Incluso Edson Rodrigues 12/03/10 - Par verificação de saldo de lote/sublote -------------------------------------------------------------------------------------------------
          IF crastro $ "SL"
				 dbselectarea("SB8")
				 SB8->(dbsetorder(3))
				 //IF SB8->(DBSeek(xFilial('SB8')+cCod+cLocal+left(clotesub,10)+substr(clotesub,11,6)))  // Retirado essa opção de procurar por lote e sublote definido
				 IF SB8->(DBSeek(xFilial('SB8')+cCod+cLocal))  
				   Do While !SB8->(EOF()) .AND. SB8->B8_FILIAL = XFILIAL("SB8") .AND. SB8->B8_PRODUTO = cCod .AND. SB8->B8_LOCAL = cLocal
				            nSallote =  QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,lEmpPrevisto,Nil,dEmis260)) 
				            nSalb8 +=  nSallote            
				            AADD(alotes,{nSallote,B8_DTVALID,B8_LOTECTL,B8_NUMLOTE})
				             /*
				                ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
                            ±±³          ³ExpL1 := Flag que indica se considera EMPENHO               ³±±
                            ±±³          ³ExpL2 := Flag que indica se considera Lotes Vencidos        ³±±
                            ±±³          ³ExpL3 := Flag que indica se considera o saldo a Classificar ³±±
                            ±±³          ³ExpL4 := Flag que indica se calcula na 2a Unidade de Medida ³±±
                            ±±³          ³ExpC1 := Caracter com alias do arquivo de query (OPCIONAL)  ³±±
                            ±±³          ³ExpL5 := Flag que indica se esta baixando empenho previsto  ³±±
                            ±±³          ³ExpL6 := Flag que indica se esta em consulta de saldo       ³±±
                            ±±³          ³ExpD1 := Indica a data de referencia do saldo               ³±±
                            ±±³          ³ExpL7 := Flag que indica se considera somente vlr. B8_SALDO ³±±
                            ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
                            SB8Saldo(lBaixaEmp,lConsVenc,lConsClas,lSegUM,cAliasSB8,lEmpPrevisto,lConsulta,dDataRef,lSaldo)
				            */
				            //If 	SB8->B8_DTVALID > ddatabase 
						            //MsgAlert("Data de validade do lote/sublote: "+left(clotesub,10)+"/"+substr(clotesub,11,6)+" ,almoxarifado : "+cLocal+" do Produto "+cCod+"  Está vencida!")
						            //Return(.f.)
						    //  Endif      
				            
				             SB8->(DbSkip())
			      EndDo
		         If    nSalb8 < nQuant
                 		  MsgAlert("Saldo de lotes para o almoxarifado : "+cLocal+" do Produto "+cCod+"  é insuficiente !")
                 		  Return(.f.)
		         Endif
		       Else    
		            MsgAlert("Não há lote para o almoxarifado : "+cLocal+" do Produto "+cCod+", favor verificar !")
					Return(.f.)	
				 ENDIF
			 ENDIF
          
          //Incluso Edson Rodrigues 12/03/10 - Par verificação de saldo de  endereço-------------------------------------------------------------------------------------------------
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
			             	  ±±³³ ExpN1 = Saldo devolvido pela funcao                        ³±±
                          ±±³³ ExpC1 = Local a ter o saldo pesquisado                     ³±±
                          ±±³³ ExpC2 = Localizacao a ter o saldo pesquisado               ³±±
                          ±±³³ ExpC3 = Produto a ter o saldo pesquisado                   ³±±
                          ±±³³ ExpC4 = Numero de Serie do produto                         ³±±
                          ±±³³ ExpC5 = Lote do Produto a ter o saldo pesquisado           ³±±
                          ±±³³ ExpC6 = Sub-Lote do Produto a ter o saldo pesquisado       ³±±
                          ±±³³ ExpL1 = Indica se baixa ou nao o empenho                   ³±±
                          ±±³³ ExpC7 = Codigo da Estrutura Fisica de Armazenagem          ³±±
                          ±±³³ ExpL2 = Indica se calcula o saldo em potencia maxima ou nao³±±
                          Function SaldoSBF(cAlmox,cLocaliza,cCod,cNumSerie,cLoteCtl,cLote,lBaixaEmp,cEstFis,lPotMax)
                          */	            
			            SBF->(DbSkip())
	            	  EndDo
				      IF nSalbf  < nQuant 
				          MsgAlert("O Saldo do(s) endereço(s) no, almoxarifado : "+cLocal+" do Produto "+cCod+" é insuficiente.  Favor verificar !")					  
				          Return(.f.)
					  ENDIF		
				  ELSE
                        MsgAlert("Não Existem endereço cadastrado para o almoxarifado : "+cLocal+" do Produto "+cCod+". favor verificar !")
					    Return(.f.)	
                  ENDIF
             ENDIF
ENDIF	

//=====|| Valida Endereços/Lotes - Edson Rodrigues - 22/03/10
If Len(alocaliz) > 0  .and.  len(alotes) <= 0    //Quando tem endereço e não tem lotes
        nSalend:=0                          
         lfim:=.f.
       For x:=1 to Len(alocaliz)
              nSalend:=alocaliz[x,1] 
             
              Do Case 
                     Case nSalend >= nQuant   //Produto com endereço maior ou igual ao saldo da qtde movimentada 
                                lRet:=montvet(cTM,cCod,cUM,nQuant,cOP,cLocal,dEmissao,_cNSeq,alocaliz[x,4],alocaliz[x,5],ctod(" / / "),alocaliz[x,2],alocaliz[x,3],lRet,nOpcao,_cchave,_nrecno,lprod,cosseq,_ccoper)
                                nQuant-=nQuant
                                 lfim:=.t.
                     Case  nSalend  < nQuant    //Produto com endereço menor que o saldo da qtde movimentada 
                               lRet:=montvet(cTM,cCod,cUM,nSalend,cOP,cLocal,dEmissao,_cNSeq,alocaliz[x,4],alocaliz[x,5],ctod(" / / "),alocaliz[x,2],alocaliz[x,3],lRet,nOpcao,_cchave,_nrecno,lprod,cosseq,_ccoper)
                                nQuant-=nSalend
               EndCase
               
               If lfim
                   Exit
               Endif
       Next

Elseif  Len(alocaliz) <=  0  .and.  len(alotes) <= 0    //Quando não tem endereço e não tem lotes
          lRet:=montvet(cTM,cCod,cUM,nQuant,cOP,cLocal,dEmissao,_cNSeq,"","",ctod(" / / "),"","",lRet,nOpcao,_cchave,_nrecno,lprod,cosseq,_ccoper)

Elseif  Len(alocaliz) >  0  .and.  len(alotes) > 0    //Quando  tem endereço e tem lotes
           // Fazer Tratamento para essa condição Edson Rodrigues 22/03/10
           lRet:=.t.

Elseif  Len(alocaliz) <=  0  .and.  len(alotes) > 0    //Quando não tem endereço e tem lotes
           // Fazer Tratamento para essa condição Edson Rodrigues 22/03/10
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEQMOV    ºAutor  ³ Edson Rodrigues    º Data ³  24/03/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca a sequencia de moviementação para grava na tabela    º±±
±±º          | SZ9 dos Parnumbers apontados                               º±±                                                 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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