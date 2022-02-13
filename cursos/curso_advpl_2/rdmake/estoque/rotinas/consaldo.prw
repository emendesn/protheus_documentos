#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �CONSALDO  � Autor � Edson Rodrigues - BGH � Data � 01/04/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Fun��o para consultar e validar saldo em estoque por produto���
���                                                                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �  .t. - True  ou .f. - False                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                


USER FUNCTION CONSALDO(cxCod,cxLocal,nxQtd)
// edson, ver enderecamento e lote   
//return nil
//static function naousar   
                                              
Local _aArea1  := GetArea()             
Local lRet     := .T.   
Local cCod     := LEFT(cxCod+SPACE(15),15) // codigo produto 
Local cUM      := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cxCod),"B1_UM") // unidade medida                            
Local cLocal   := cxLocal //local armazem                                       
Local nQuant   := nxQtd // quantidade                                     
//Incluso Edson Rodrigues 12/03/10 - Par verifica��o de saldo de lote/sublote e endere�o-------------------------
Local clocaliz := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cxCod),"B1_LOCALIZ") // Localizacao
Local crastro  := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cxCod),"B1_RASTRO") // Rastro                 
Local clotesub :=GetMV("MV_LOTESUB")   //Indica o Lote Sublote que ser� ultilizado no processo. Obs: talves ser� buscado na tabela ZZJ e vindo atraves do vetor
Local  carmpec :=GetMV("MV_ARMLPEC") // Indica o armazem e endere�o usado no processo. Obs: talves ser� buscado na tabela ZZJ e vindo atraves do vetor
//--------------------------------------------------------------------------------------------------------------------------------------------------------
Local nSallote := 0.00
Local nSalend  := 0.00
Local nSalb8   := 0.00
Local nSalbf   := 0.00
Local nSalb2   := 0.00    


u_GerA0003(ProcName())

 //  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 //-----|| VALIDA ESTOQUE PARA BAIXA
 DBSELECTAREA("SB2")              
dbsetorder(1)
dbgotop()
IF !dbseek(xfilial("SB2")+cCod+cLocal)
    MsgAlert("Almoxarifado "+cLocal+" do Produto "+cCod+" nao Localizado!")
     Return(.f.)
Else       
     nSalb2:=SaldoSB2(nil,nil,dDatabase,.t.,.t.,nil,0,0,.t.)    
     If  nSalb2 < nQuant
         MsgAlert("Almoxarifado "+cLocal+" do Produto "+cCod+" sem saldo ou insuficiente!")
         Return(.f.)
     endif
Endif       
          

 IF crastro $ "SL"
    dbselectarea("SB8")
	 SB8->(dbsetorder(3))
				 //IF SB8->(DBSeek(xFilial('SB8')+cCod+cLocal+left(clotesub,10)+substr(clotesub,11,6)))  // Retirado essa op��o de procurar por lote e sublote definido
	 IF SB8->(DBSeek(xFilial('SB8')+cCod+cLocal))  
		   Do While !SB8->(EOF()) .AND. SB8->B8_FILIAL = XFILIAL("SB8") .AND. SB8->B8_PRODUTO = cCod .AND. SB8->B8_LOCAL = cLocal
		        nSallote =  QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,lEmpPrev,Nil,dEmis260)) 
              nSalb8 +=  nSallote            
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
          

IF  clocaliz = "S"
     dbselectarea("SBF")
     SBF->(dbsetorder(2))
	  IF SBF->(DbSeek(XFilial("SBF") + cCod + cLocal))
	      Do While ! SBF->(EOF()) .AND. SBF->BF_FILIAL = XFILIAL("SBF") .AND. SBF->BF_PRODUTO = cCod  .AND. SBF->BF_LOCAL = cLocal
			              nSalend := QtdComp(SaldoSBF(cLocal,SBF->BF_LOCALIZ,cCod,SBF->BF_NUMSERI,SBF->BF_LOTECTL,If(Rastro(cCod, 'S'),SBF->BF_NUMLOTE,'')))     
			              nSalbf+=nSalend
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
Restarea(_aArea1)

Return( lRet)


	