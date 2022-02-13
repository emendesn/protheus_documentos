#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXEMPAPO  ºAutor  ³ Edson Rodrigues    º Data ³  11/03/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo Sony Refurbish - Função que verifica e faz estornoº±± 
±±ºde apontamento de produção e empenhos                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                     
USER FUNCTION EXEMPAPO(CPARTNR,NQTDE,COSOP,cprodaref,_lencrrado,coperac,_clab)
   Local _aAreaSC2  := SC2->(GetArea())
   Local _aAreaSD3  := SD3->(GetArea())
   Local _aAreaSD4  := SD4->(GetArea())                                    
   Local carmproc   :=POSICIONE("ZZJ",1,XFILIAL("ZZJ")+alltrim(coperac),"ZZJ_ALMEP") 
   Local cprefixpa  :=POSICIONE("ZZJ",1,XFILIAL("ZZJ")+alltrim(coperac),"ZZJ_PREFPA") 
   Local carmpeca   :=POSICIONE("ZZJ",1,XFILIAL("ZZJ")+alltrim(coperac),"ZZJ_ALMEP") 
   Local carmpacab  :=POSICIONE("ZZJ",1,XFILIAL("ZZJ")+alltrim(coperac),"ZZJ_ALMPRO") 
   Local cmovprod   :=POSICIONE("ZZJ",1,XFILIAL("ZZJ")+alltrim(coperac),"ZZJ_CODPRO")
   Local cmovcons   :=POSICIONE("ZZJ",1,XFILIAL("ZZJ")+alltrim(coperac),"ZZJ_CODSF5")
   Local carmscrap  :=POSICIONE("ZZJ",1,XFILIAL("ZZJ")+alltrim(coperac),"ZZJ_ALMSCR")
   /*
   Local carmpeca   := GetMV("MV_ARMLPEC")                        
   Local clotesub   := GetMV("MV_LOTESUB")   //Indica o Lote Sublote que será ultilizado no processo. Obs: talves será buscado na tabela ZZJ e vindo atraves do vetor
   Local carmpacab  := GetMV("MV_ARMACAB")
   Local carmproc   := GetMV("MV_ARMPROC")                
   Local cmovprod   := GetMV("MV_MOVPROD")
   */                           
   Local _cnewpro   := IIF(left(cprodaref,3)=="DPY",alltrim(cprefixpa)+substr(alltrim(cprodaref),4,12),alltrim(cprefixpa)+alltrim(cprodaref))
   Local _cnewpro   := Alltrim(_cnewpro)+SPACE(15-len(alltrim(_cnewpro)))
   Local lInclui    := .F.                                                                          
   Local ltransf    := .f.            
   Local _lgertrans := .t.
   Local _lgeraemp  :=.t.
   Local _lgeraapon :=.t.
   Local _lempenh   :=.t.
   Local _laponta   := .F.  
   Local _lvalidD3  := .F.
   Local _lreturn   := .T.
   Local _aAponOP   :={}
   Local _atransp   :={}                                                                                                       
   Local _aEmpenh   :={}
   Local _cunmed    :=POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(_cnewpro),"B1_UM") // unidade medida
   Local _nrecorig  :=0
   Local _nrecdest  :=0                   
   Local _nrecSD3   :=0
   Local nSalb2     :=0                                  
   
   Private nTdocD3  := TAMSX3("D3_DOC")[1]
   Private _cdocd3  := left(COSOP,6)+SPACE(nTdocD3-len(left(COSOP,6)))
   

u_GerA0003(ProcName())

   dbselectarea("SD4")
   dbsetorder(2)
   dbselectarea("SC2")
   dbsetorder(1)    

   If _lencrrado
        //Verifica se a OP já está encerrada e se fez apontamento 
		dbselectarea("SC2")
		IF SC2->(DBSeek(xFilial('SC2')+left(COSOP,6)))  
		   If 	SC2->C2_QUJE >= NQTDE // OP Encerrada
			     dbselectarea("SD3")
	             dbsetorder(1)    
		         IF SD3->(DBSeek(xFilial('SD3')+left(COSOP,6)+'01001  '+_cnewpro+carmproc)) 
		                                                                                  
                      // Faz Estorno da Transferencia do armazém de acabamento para o armazém de processo. 
                      Do While !SD3->(EOF()) .AND. SD3->D3_FILIAL = XFILIAL("SD3") .AND. SD3->D3_OP = left(COSOP,6)+'01001  ' .AND. SD3->D3_COD=_cnewpro  .and.   SD3->D3_LOCAL=carmproc   
                           IF SD3->D3_OP=left(COSOP,6)+'01001  ' .AND.  SD3->D3_COD=_cnewpro .AND. SD3->D3_LOCAL=carmproc .AND.  SD3->D3_TM=cmovprod .AND. SD3->D3_ESTORNO<>'S' 
                                 _lvalidD3:=.t.
                                 _nrecSD3:= SD3->(RECNO())
                            ENDIF
                            SD3->(dbskip())
                      ENDDO
                      
                      
                      //    IF SD3->D3_ESTORNO<>'S'
                      dbselectarea("SD3")
                      dbsetorder(2) //D3_FILIAL+D3_DOC+D3_COD                                      
                      //Verifica se foi feito a transferencia 
                      IF SD3->(DBSeek(xFilial('SD3')+_cdocd3+_cnewpro))  .and. _lvalidD3
                         Do While !SD3->(EOF()) .AND. SD3->D3_FILIAL = XFILIAL("SD3") .AND. SD3->D3_DOC = _cdocd3 .AND. SD3->D3_COD=_cnewpro      
                              IF SD3->D3_DOC=_cdocd3 .AND.  SD3->D3_COD=_cnewpro .AND. SD3->D3_LOCAL=carmproc .AND.  SD3->D3_TM='999' .AND. SD3->D3_ESTORNO<>'S' 
                               _nrecorig:=SD3->(Recno())
                               _nqtde    :=SD3->D3_QUANT
                              ELSEIF SD3->D3_DOC=_cdocd3 .AND.  SD3->D3_COD=_cnewpro .AND. SD3->D3_LOCAL=carmpacab .AND.  SD3->D3_TM='499' .AND. SD3->D3_ESTORNO<>'S'    
                               _nrecdest:=SD3->(Recno())
                               _nqtde    :=SD3->D3_QUANT
                              ENDIF
                              SD3->(dbskip())
                            ENDDO
                            If    _nrecorig > 0 .and.   _nrecdest > 0                                                                                                           
                                 U_SRAdTrans(_cnewpro,carmpacab,_cdocd3,_cnewpro,carmproc,@_atransp,@ltransf,@lInclui,@_lgertrans,_nrecorig,_nrecdest,_nqtde)
                            Else
                               dbselectarea("SB2")
	                            IF SB2->(DBSeek(xFilial('SB2')+_cnewpro+left(carmproc,2)))  //Para garantir, posiciona o SB2 - Edson Rodrigues 03/03/10
                                  //Opção para ver o saldo disponível SB2 através de função do sistema - Edson Rodrigues - 15/03/10          
                                 ltransf:=iif(nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.) >= NQTDE,.t.,.f.)
                               Endif                 
                            Endif   
                      ELSE
                         MsgAlert("Não foi possível Transferir o Produto acabado"+_cnewpro+"/"+left(COSOP,6)+"  do armazém : "+carmpacab+" para o "+carmproc+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                         _lreturn:=.f.
                      ENDIF   
                      // ELSE
                      //     dbselectarea("SB2")
	                  //     IF SB2->(DBSeek(xFilial('SB2')+_cnewpro+left(carmproc,2)))  //Para garantir, posiciona o SB2 - Edson Rodrigues 03/03/10
                      //            //Opção para ver o saldo disponível SB2 através de função do sistema - Edson Rodrigues - 15/03/10          
                      //            ltransf:=iif(nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.) >= NQTDE,.t.,.f.)
                      //   Endif      
                      // ENDIF     
                      IF ltransf   
                           // Faz estorno Encerramento da Ordem de Produção     
                           dbselectarea("SD3")          
                           dbsetorder(1) 
                           SD3->(dbGoto(_nrecSD3))
                           U_SRAdApo(cmovprod,_cnewpro,_cunmed,left(COSOP,6),carmproc,@_laponta,@_aAponOP,@lInclui,@_lgeraapon,SD3->D3_DOC,SD3->D3_NUMSEQ,SD3->D3_CHAVE,_nrecSD3)
                           If _laponta
                              //Exclui os Empenhos já apontados        
                              dbselectarea("SD4")
							         SD4->(dbsetorder(2))
							              IF SD4->(DBSeek(xFilial('SD4')+left(COSOP,6)+'01001  '+cprodaref+left(carmpeca,2)))  
							                 Do While !SD4->(EOF()) .AND. SD4->D4_FILIAL = XFILIAL("SD4") .AND. SD4->D4_OP = left(COSOP,6)+'01001  ' .AND. SD4->D4_LOCAL=left(carmpeca,2)  
										            IF cprodaref <> SD4->D4_COD         
										                 // Desabilitado função de exclusão de apontamento - Edson Rodrigues 20/03/10
										                 // U_SRAdEmp(SD4->D4_COD,left(carmpeca,2),left(COSOP,6),SD4->D4_QUANT,SD4->D4_QUANT,left(clotesub,10),substr(clotesub,11,6),@_aEmpenh,@lInclui,@_lempenh,@_lgeraemp)										                      
                                          Endif
                                          SD4->(dbskip())
                                      Enddo
                                      If !_lempenh
                                           MsgAlert("Não foi possível excluir os empenhos referente a OP/OS : "+left(COSOP,6)+" do Produto/Peça "+SD4->D4_COD+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                                          _lreturn:=.f.
                                      Endif
                               ENDIF
                           Else
                              MsgAlert("Não foi possível estornar a OP/OS : "+left(COSOP,6)+" do Produto acabado "+_cnewpro+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                              _lreturn:=.f.
                           Endif
                      Else      
                          MsgAlert("Não foi possível Transferir o Produto acabado"+_cnewpro+"/"+left(COSOP,6)+"  do armazém : "+carmpacab+" para o "+carmproc+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                          _lreturn:=.f.
                      Endif
                 Else
                   MsgAlert("Não foi possível estornar a OP/OS, nao existe apontamento da mesma. : "+left(COSOP,6)+" do Produto acabado "+_cnewpro+".  Copie essa mensagem e entre em contato com Administrador do sistema !")
                   _lreturn:=.f.
                 Endif                                                              
           Else  //OP Não Encerrrada estorna somente os empenhos       
                 //Exclui os Empenhos já apontados        
                 dbselectarea("SD4")
				 SD4->(dbsetorder(2))
				 IF SD4->(DBSeek(xFilial('SD4')+left(COSOP,6)+'01001  '+cprodaref+left(carmpeca,2)))  
					   Do While !SD4->(EOF()) .AND. SD4->D4_FILIAL = XFILIAL("SD4") .AND. SD4->D4_OP = left(COSOP,6)+'01001  ' .AND. SD4->D4_LOCAL=left(carmpeca,2)  
					   	  IF cprodaref <> SD4->D4_COD                                                                                                      
								          // Desabilitado função de exclusão de apontamento - Edson Rodrigues 20/03/10
										    // U_SRAdEmp(SD4->D4_COD,left(carmpeca,2),left(COSOP,6),SD4->D4_QUANT,SD4->D4_QUANT,left(clotesub,10),substr(clotesub,11,6),@_aEmpenh,@lInclui,@_lempenh,@_lgeraemp)										                      
                          Endif
                          SD4->(dbskip())
                        Enddo
                        If !_lempenh
                            MsgAlert("Não foi possível excluir os empenhos referente a OP/OS : "+left(COSOP,6)+" do Produto/Peça "+SD4->D4_COD+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                            _lreturn:=.f.
                        Endif
                 ENDIF
           Endif
        Else
           MsgAlert("Não foi encontrada OP para a OS : "+left(COSOP,6)+". Copie essa mensagem e entre em contato com Administrador do sistema !")
           _lreturn:=.f.      
        Endif
   Else  
        //Se não encerrado, verifica se a OP está mesmo aberta e excluí os apontamentos já feitos
        //Verifica se a OP já está encerrada e se fez apontamento 
	    dbselectarea("SC2")
		IF SC2->(DBSeek(xFilial('SC2')+left(COSOP,6)))  
			If SC2->C2_QUJE >= NQTDE // OP Encerrada
			      dbselectarea("SD3")
			      dbsetorder(1) 
		         IF SD3->(DBSeek(xFilial('SD3')+left(COSOP,6)+'01001  '+_cnewpro+carmproc))      
		         
		                // Faz Estorno da Transferencia do armazém de acabamento para o armazém de processo. 
                      Do While !SD3->(EOF()) .AND. SD3->D3_FILIAL = XFILIAL("SD3") .AND. SD3->D3_OP = left(COSOP,6)+'01001  ' .AND. SD3->D3_COD=_cnewpro  .and.   SD3->D3_LOCAL=carmproc   
                              IF SD3->D3_OP=left(COSOP,6)+'01001  '   .AND.  SD3->D3_COD=_cnewpro .AND. SD3->D3_LOCAL=carmproc .AND.  SD3->D3_TM='400' .AND. SD3->D3_ESTORNO<>'S' 
                                       _lvalidD3:=.t.
                                       _nrecSD3:= SD3->(RECNO())
                              ENDIF
                              SD3->(dbskip())
                      ENDDO
                                                                             
                      // IF SD3->D3_ESTORNO<>'S'
                      dbselectarea("SD3")
                      dbsetorder(2) //D3_FILIAL+D3_DOC+D3_COD                                      
                      //Verifica se foi feito a transferencia 
                      IF SD3->(DBSeek(xFilial('SD3')+_cdocd3+_cnewpro))  .AND.  _lvalidD3
                            Do While !SD3->(EOF()) .AND. SD3->D3_FILIAL = XFILIAL("SD3") .AND. SD3->D3_DOC = _cdocd3 .AND. SD3->D3_COD=_cnewpro      
                              IF SD3->D3_DOC=_cdocd3 .AND.  SD3->D3_COD=_cnewpro .AND. SD3->D3_LOCAL=carmproc .AND.  SD3->D3_TM='999' .AND. SD3->D3_ESTORNO<>'S' 
                               _nrecorig:=SD3->(Recno())     
                               _nqtde   :=SD3->D3_QUANT
                              ELSEIF SD3->D3_DOC=_cdocd3 .AND.  SD3->D3_COD=_cnewpro .AND. SD3->D3_LOCAL=carmpacab .AND.  SD3->D3_TM='499' .AND. SD3->D3_ESTORNO<>'S'    
                               _nrecdest:=SD3->(Recno())
                               _nqtde   :=SD3->D3_QUANT
                              ENDIF
                              SD3->(dbskip())
                            ENDDO                        
                            if    _nrecorig > 0 .and.   _nrecdest > 0                                       
                                U_SRAdTrans(_cnewpro,carmpacab,_cdocd3,_cnewpro,carmproc,@_atransp,@ltransf,@lInclui,@_lgertrans,_nrecorig,_nrecdest,_nqtde)
                            Else
                               dbselectarea("SB2")
	                            IF SB2->(DBSeek(xFilial('SB2')+_cnewpro+left(carmproc,2)))  //Para garantir, posiciona o SB2 - Edson Rodrigues 03/03/10
                                  //Opção para ver o saldo disponível SB2 através de função do sistema - Edson Rodrigues - 15/03/10          
                                 ltransf:=iif(nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.) >= NQTDE,.t.,.f.)
                               Endif      
                            Endif    
                      ELSE
                           //Retirada esse alert, pois como se trata de OS nao encerrada, entao mesma nao tem apontamento e nao foi transferida- 28/07/10
                           //  MsgAlert("Não foi possível Transferir o Produto acabado"+_cnewpro+"/"+left(COSOP,6)+"  do armazém : "+carmpacab+" para o "+carmproc+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                           _lreturn:=.f.
                      ENDIF   
                  
                      IF ltransf   
                           // Faz estorno Encerramento da Ordem de Produção
                           dbselectarea("SD3")                   
                           dbsetorder(1) 
                           SD3->(dbGoto(_nrecSD3)) 
                           U_SRAdApo(cmovprod,_cnewpro,_cunmed,left(COSOP,6),carmproc,@_laponta,@_aAponOP,@lInclui,@_lgeraapon,SD3->D3_DOC,SD3->D3_NUMSEQ,SD3->D3_CHAVE,_nrecSD3)
                           If _laponta
                              //Exclui os Empenhos já apontados        
                              dbselectarea("SD4")
							         SD4->(dbsetorder(2))
							              IF SD4->(DBSeek(xFilial('SD4')+left(COSOP,6)+'01001  '+cprodaref+left(carmpeca,2)))  
							                 Do While !SD4->(EOF()) .AND. SD4->D4_FILIAL = XFILIAL("SD4") .AND. SD4->D4_OP = left(COSOP,6)+'01001  ' .AND. SD4->D4_LOCAL=left(carmpeca,2)  
										            IF cprodaref <> SD4->D4_COD    
										                // Desabilitado função de exclusão de apontamento - Edson Rodrigues 20/03/10
										                //  U_SRAdEmp(SD4->D4_COD,left(carmpeca,2),left(COSOP,6),SD4->D4_QUANT,SD4->D4_QUANT,left(clotesub,10),substr(clotesub,11,6),@_aEmpenh,@lInclui,@_lempenh,@_lgeraemp)										                      
                                          Endif
                                          SD4->(dbskip())
                                      Enddo
                                      If !_lempenh
                                           MsgAlert("Não foi possível excluir os empenhos referente a OP/OS : "+left(COSOP,6)+" do Produto/Peça "+SD4->D4_COD+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                                          _lreturn:=.f.
                                      Endif
                               ENDIF
                           Else
                              MsgAlert("Não foi possível estornar a OP/OS : "+left(COSOP,6)+" do Produto acabado "+_cnewpro+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                              _lreturn:=.f.
                           Endif
                 Else  
                     //Ocultado essa mensagem, pois a mesma não se justifica, porque o aparelho não está encerrado.   28/07/10 - Edson Rodrigues   
                     //MsgAlert("Não foi possível Transferir o Produto acabado/OP "+_cnewpro+"/"+left(COSOP,6)+" do armazém : "+carmpacab+" para o "+carmproc+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                       _lreturn:=.f.
                 Endif
              Else
                   //Ocultado essa mensagem, pois a mesma não se justifica, porque o aparelho não está encerrado.  28/07/10 - Edson Rodrigues
                   //MsgAlert("Não foi possível estornar a OP/OS, nao existe apontamento da mesma. : "+left(COSOP,6)+" do Produto acabado "+_cnewpro+".  Copie essa mensagem e entre em contato com Administrador do sistema !")
                   _lreturn:=.f.
              Endif                                                              
		    Else
			   //Exclui os Empenhos já apontados        
               dbselectarea("SD4")
			   SD4->(dbsetorder(2))
			   IF SD4->(DBSeek(xFilial('SD4')+left(COSOP,6)+'01001  '+cprodaref+left(carmpeca,2)))  
					  Do While !SD4->(EOF()) .AND. SD4->D4_FILIAL = XFILIAL("SD4") .AND. SD4->D4_OP = left(COSOP,6)+'01001  ' .AND. SD4->D4_LOCAL=left(carmpeca,2)  
					    IF cprodaref <> SD4->D4_COD
             				// Desabilitado função de exclusão de apontamento - Edson Rodrigues 20/03/10
						    // U_SRAdEmp(SD4->D4_COD,left(carmpeca,2),left(COSOP,6),SD4->D4_QUANT,SD4->D4_QUANT,left(clotesub,10),substr(clotesub,11,6),@_aEmpenh,@lInclui,@_lempenh,@_lgeraemp)										                      
                        Endif
                        SD4->(dbskip())
                      Enddo
                      If !_lempenh
                          MsgAlert("Não foi possível Transferir o Produto acabado "+_cnewpro+"/"+left(COSOP,6)+"  do armazém : "+carmpacab+" para o "+carmproc+". Copie essa mensagem e entre em contato com Administrador do sistema !")
                          _lreturn:=.f.
                      Endif
               ENDIF
			Endif                
	    Else
		   MsgAlert("Não foi encontrada OP para a OS : "+left(COSOP,6)+". Copie essa mensagem e entre em contato com Administrador do sistema !")
           _lreturn:=.f. 
	    Endif	
   Endif	                                                                                                  
restarea(_aAreaSD3)
restarea(_aAreaSC2)
restarea(_aAreaSD4)   
   
Return(_lreturn)