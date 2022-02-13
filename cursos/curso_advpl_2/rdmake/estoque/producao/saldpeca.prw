#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

#define ENTER CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SaldPeca  ºAutor  ³Paulo Francisco       º Data ³  29/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa Inclussão de Peças                                   º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SaldPeca(cComp,cQtd,cImei,cNumOs,cArm,cEnd)

Local 	nSalb2		:=	0.00
Local 	nSalbf		:= 	0.00
Local 	cQtdLtmi
Local 	cMensagem
Local 	cTitemail 	:= "Transferencia Estoque "
Local 	Path 		:= "172.16.0.7"
Local 	_center   	:= Chr(13)+Chr(10)
//Local 	cComp		:= cComp
Local	lRet		:= .T.
Local   cLocaliz	:= ""  
//Incluso O Parametro para desafixar os e-mails do Fonte
Local   cDestinatario := GetMv("MV_GESPEC")
 

u_GerA0003(ProcName())

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1") + Left(cComp,15)))

cQtdLtmi	:=	SB1->B1_LOTEMPR
cLocaliz	:=  SB1->B1_LOCALIZ
cultlote	:=  SB1->B1_RASTRO

dbselectarea("SB2")
SB2->(DBSeek(xFilial('SB2') + Left(cComp,15) + Left(cArm,2)))
_calias=alias()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Chama Funcao Padra para Consultar Saldo do Produto           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)

If nSalb2 > 0
	
	If nSalb2 >= cQtd
		
		If cLocaliz=="S"
			dbselectarea("SBF")
			SBF->(dbsetorder(7))
			
			If SBF->(DBSeek(xFilial('SBF') + Left(cComp,15) + Left(cArm,2) + AllTrim(cEnd)))
				
				If SBF->BF_QUANT > 0
					
					If !Empty(AllTrim(cQtdLtmi))
						
						If SBF->BF_QUANT <= cQtdLtmi
							
							cMensagem := "Problemas Transferencia : "+DTOC(date())+" - "+time()+" hrs." + _center
							cMensagem += "Produto Atingiu Estoque Minimo Armazem: " + Left(cArm,2) + _center
							cMensagem += "Produto: " + cComp +_center
							cMensagem += "Equipamento Sendo Apontado : "+cImei+ "  - Os.: " + cNumOs + _center
							cMensagem += "Usuario Apontando " + AllTrim(cUsername)
							
							//U_ENVIAEMAIL(cTitemail,"LiderancaNextel@bgh.com.br;PCP@bgh.com.br;natalia.santos@bgh.com.br;fernando.medeiros@bgh.com.br;paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
							U_ENVIAEMAIL(cTitemail,cDestinatario,"",cMensagem,Path)
							lRet	:= .F.
							
						EndIf
					EndIf
				Else
					
					cMensagem := "Problemas Transferencia : "+DTOC(date())+" - "+time()+" hrs."+ _center
					cMensagem += "Produto Sem Saldo no Endereço: " +  AllTrim(cEnd) + _center
					cMensagem += "Produto: " + cComp +_center
					cMensagem += "Equipamento Sendo Apontado : "+cImei+ "  - Os.: " + cNumOs + _center
					cMensagem += "Usuario Apontando " + AllTrim(cUsername)
					
					//U_ENVIAEMAIL(cTitemail,"LiderancaNextel@bgh.com.br;PCP@bgh.com.br;rodrigo.bazzo@bgh.com.br;paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
					U_ENVIAEMAIL(cTitemail,cDestinatario,"",cMensagem,Path)
					lRet	:= .F.
					
				EndIf
				
			Else
				
				cMensagem := "Problemas Transferencia : "+DTOC(date())+" - "+time()+" hrs."+ _center
				cMensagem += "Produto Não Existe no Endereço: " +  AllTrim(cEnd) + _center
				cMensagem += "Produto: " + cComp +_center
				cMensagem += "Equipamento Sendo Apontado : "+cIMEI+ "  - Os.: " + cNumOs + _center
				cMensagem += "Usuario Apontando " + AllTrim(cUsername)
				
				//U_ENVIAEMAIL(cTitemail,"LiderancaNextel@bgh.com.br;PCP@bgh.com.br;rodrigo.bazzo@bgh.com.br;paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
			    U_ENVIAEMAIL(cTitemail,cDestinatario,"",cMensagem,Path)
				lRet	:= .F.
				
			EndIf
			
		Endif
		//Incluso Edson Rodrigues 23/02/15 - Para verificação de saldo de lote/sublote -------------------------------------------------------------------------------------------------
        IF cultlote $ "SL"        
           alotes   := {}              
           nSalb8   := 0.00                 
           nSallote := 0.00
           
		   dbselectarea("SB8")
				 SB8->(dbsetorder(3))
				 //IF SB8->(DBSeek(xFilial('SB8')+cCod+cLocal+left(clotesub,10)+substr(clotesub,11,6)))  // Retirado essa opção de procurar por lote e sublote definido
				 IF SB8->(DBSeek(xFilial('SB8')+Left(cComp,15) + Left(cArm,2)))  
				   Do While !SB8->(EOF()) .AND. SB8->B8_FILIAL = XFILIAL("SB8") .AND. SB8->B8_PRODUTO = Left(cComp,15) .AND. SB8->B8_LOCAL = Left(cArm,2)
				            nSallote :=  QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,.F.,Nil,date())) 
				            nSalb8 :=  nSalb8+nSallote            
				            AADD(alotes,{nSallote,B8_DTVALID,B8_LOTECTL,B8_NUMLOTE})
			         SB8->(DbSkip())
			      EndDo
		          If    nSalb8 < cQtd
                 		  
                 		  cMensagem := "Problemas Transferencia : "+DTOC(date())+" - "+time()+" hrs."+ _center
				          cMensagem += "Saldo de lotes para o almoxarifado : "+cArm+" do Produto "+Left(cComp,15)+"  é insuficiente !" + _center
				          cMensagem += "Produto: " + cComp +_center
				          cMensagem += "Equipamento Sendo Apontado : "+cIMEI+ "  - Os.: " + cNumOs + _center
				          cMensagem += "Usuario Apontando " + AllTrim(cUsername)
				
				          U_ENVIAEMAIL(cTitemail,cDestinatario,"",cMensagem,Path)
				          lRet	:= .F.
 		  
	  	          Endif
		       Else    
		            MsgAlert("Não há lote para o almoxarifado : "+cLocal+" do Produto "+cCod+", favor verificar !")
		            
		            cMensagem := "Problemas Transferencia : "+DTOC(date())+" - "+time()+" hrs."+ _center
				    cMensagem += "Não há lote para o almoxarifado : "+cArm+" do Produto "+Left(cComp,15)+", favor verificar !" + _center
				    cMensagem += "Produto: " + cComp +_center
				    cMensagem += "Equipamento Sendo Apontado : "+cIMEI+ "  - Os.: " + cNumOs + _center
				    cMensagem += "Usuario Apontando " + AllTrim(cUsername)
				
				    U_ENVIAEMAIL(cTitemail,cDestinatario,"",cMensagem,Path)
					lRet	:= .F.	
				ENDIF
			 ENDIF
	Else
		cMensagem := "Problemas Transferencia : "+DTOC(date())+" - "+time()+" hrs."+ _center
		cMensagem += "Saldo disponível SB2 :"+strzero(nSalb2,3)+" < Qtde apontada : " +  strzero(cQtd,3) + _center
		cMensagem += "Produto: " + cComp +_center
		cMensagem += "Equipamento Sendo Apontado : "+cIMEI+ "  - Os.: " + cNumOs + _center
		cMensagem += "Usuario Apontando " + AllTrim(cUsername)
		
		//U_ENVIAEMAIL(cTitemail,"LiderancaNextel@bgh.com.br;PCP@bgh.com.br;rodrigo.bazzo@bgh.com.br;paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
		U_ENVIAEMAIL(cTitemail,cDestinatario,"",cMensagem,Path)
		lRet	:= .F.
	EndIf
Else
	
	cMensagem := "Problemas Transferencia : "+DTOC(date())+" - "+time()+" hrs."+ _center
	cMensagem += "Produto Sem Saldo Armaze: " + Left(cArm,2) + _center
	cMensagem += "Produto: " + cComp + _center
	cMensagem += "Equipamento Sendo Apontado : "+cImei+ "  - Os.: " + cNumOs + _center
	cMensagem += "Usuario Apontando " + AllTrim(cUsername)
	
	//U_ENVIAEMAIL(cTitemail,"LiderancaNextel@bgh.com.br;PCP@bgh.com.br;rodrigo.bazzo@bgh.com.br;paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
	U_ENVIAEMAIL(cTitemail,cDestinatario,"",cMensagem,Path)
	lRet	:= .F.
	
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TransPeca ºAutor  ³Paulo Francisco       º Data ³  31/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa Inclussão de Peças                                   º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TransPeca(aDados)

Local 	i
Local	x
Local	u
Local	_nCount
Local 	_yQry
Local	_yQry1
Local	_cRet
Local	cArmPeca
Local 	cEndProd
Local	cEndAudi
Local	cArmScra
Local	cEndScra
Local 	aItens		:=	{}
Local	cDoc		:= ""
Local   cLocaliz	:= ""

/* Array para Transferencia de Armazem - Endereçamento. */
/* Array aDados
1-> Operação,
2-> ParNumber,
3-> Num. Seq.,
4-> Num. O.S.,
5-> Quantidade,
6-> Arm. Origem,
7-> End. Origem,
8-> Arm. Destino,
9-> End. Destino
10->RECNO SZ9
11->lote transferencia estoque para Processo
12->Sub lote transferencia estoque para Processo
13->Data validade lote transferencia estoque para Processo
*/

For i = 1 To Len(aDados)
	If !Empty(aDados[i,03])
		_cRet	:= .T.
		If Empty(cDoc)
			
			If Select("QRYY") > 0
				QRYY->(dbCloseArea())
			EndIf

			_yQry	:= "SELECT TOP 1 Z9_NUMSEQ SEQ FROM "+RetSqlName("SZ9") + " WHERE D_E_L_E_T_ = '' AND Z9_STATUS = '1' AND Z9_PARTNR <> '' AND Z9_NUMOS = '"+ aDados[i,04] +"' ORDER BY R_E_C_N_O_ DESC "
			dbUseArea(.T., "TOPCONN", TCGenQry(,, _yQry), "QRYY", .F., .T.)
			
			If Len(AllTRim(QRYY->SEQ)) >0
				cDoc := Soma1(QRYY->SEQ)
			Else
				cDoc := AllTrim(aDados[i,04])
				cDoc += "AAA"
			EndIf
			
			If Select("QRYY") > 0
				QRYY->(dbCloseArea())
			EndIf
		Endif
		
		SZ9->(DBOrderNickName('Z9PROCESSO')) //Z9_FILIAL+Z9_NUMOS+Z9_SEQ+Z9_PARTNR
		If SZ9->(dbSeek(xFilial("SZ9") + aDados[i,04] + AllTrim(aDados[i,03]) + Left(aDados[i,02],15) ))
			
			IF Len(aItens)>0
				For x := 1 To Len(aItens)
					If Left(aDados[i,02],15) == Left(aItens[x,01],15) .and. aDados[i,11] ==  aItens[x,12] .and. aDados[i,12] ==  aItens[x,13] .and. aDados[i,13] ==  aItens[x,14]
						aItens[x,16] += aDados[i,05]
						_cRet	:= .F.
					EndIf
				Next x
			Endif
			
			If _cRet
				//Pocisiona Produto
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1") + AllTrim(aDados[i,02])))
				cLocaliz	:=  SB1->B1_LOCALIZ
				If cLocaliz == "S" .OR. Alltrim(aDados[i,06]) <> Alltrim(aDados[i,08])
					aAdd(aItens,{Left(aDados[i,02],15),; 		// 1 Produto Origem
					Left(SB1->B1_DESC,30),;                   	// 2 Desc. Produto Origem
					AllTrim(SB1->B1_UM),;                     	// 3 Unidade Medida
					aDados[i,06],;                            	// 4 Local Origem
					IIF(cLocaliz=="S",aDados[i,07],space(15)),;	// 5 Ender Origem
					Left(aDados[i,02],15),;                  	// 6 Produto Destino
					Left(SB1->B1_DESC,30),;                   	// 7 Desc. Produto Destino
					AllTrim(SB1->B1_UM),;                     	// 8 Unidade Medida
					aDados[i,08],;                            	// 9 Local Destino
					IIF(cLocaliz=="S",aDados[i,09],space(15)),; // 10 Ender Destino
					Space(20),;                               	// 11 Num Serie
					aDados[i,11],;                             	// 12 Lote
					aDados[i,12],;                             	// 13 Sub Lote
					aDados[i,13],;                             	// 14 Validade
					0,;                                        	// 15 Potencia
					aDados[i,05],;                            	// 16 Quantidade
					0,;                                       	// 17 Qt 2aUM
					"N",;                                     	// 18 Estornado
					Space(06),;                               	// 19 Sequencia
					aDados[i,11],;                             	// 20 Lote Desti
    				aDados[i,13],;                             	// 21 Validade Lote
					Space(3),;                              	// 22 Cod.Servic //Acrescentado edson Rodrigues
					Space(03)})									// 23 Item Grade
				Endif
			EndIf
			/* Gravar somente depois que gerou movimento no D3 - Conforme solicitação do Edson - 27/07/2012
			RecLock("SZ9",.F.)
			
			SZ9->Z9_NUMSEQ :=  cDoc
			
			MsUnLock()
			*/
		EndIf
	EndIf
Next i

If Len(aItens) >0
	lRet := u_BaixPeca(cDoc,aItens,3)
	//Atualizar NUMSEQ e ATUSD3 na tabela SZ9 - Conforme solicitação do Edson - 27/07/2012
	If lRet
		For i := 1 To Len(aDados)
			dbSelectArea("SZ9")
			SZ9->(dbGoto(aDados[i,10]))
			RecLock("SZ9",.F.)
			SZ9->Z9_NUMSEQ :=  cDoc
			SZ9->Z9_ATUSD3 :='S'
			MsUnLock()
		Next i	
	Else
		For i := 1 To Len(aDados)
			dbSelectArea("SZ9")
			SZ9->(dbGoto(aDados[i,10]))
			RecLock("SZ9",.F.)
			SZ9->Z9_ATUSD3 :='N'
			MsUnLock()
		Next i
	Endif
Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BaixPeca  ºAutor  ³Paulo Francisco       º Data ³  29/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa Inclussão de Peças                                   º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BaixPeca(cDoc,aItens,nOpcAuto)

Local lRet := .T.

Private	cTitemail 	:= "Erro na Transferencia "
Private	Path 		:= "172.16.0.7"
Private	_center   	:= Chr(13)+Chr(10)
Private lMsErroAuto	:= 	.F.
Private lMsHelpAuto	:= 	.F.
Private aMata261 	:= 	{}
Private i

If nOpcAuto == 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Transfere Quantidades para Almoxarifado de Processo          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aMata261, {AllTrim(cDoc), dDataBase}) //Desabilitado pois  não tem necessidade desse cabeçalho. 02/01/12
	For i := 1 To Len(aItens)
		SB2->(DBSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
		If !SB2->(dbSeek(xFilial("SB2") + Left(aItens[i,01],15) + Left(aItens[i,09],2) , .F.))
			RecLock("SB2", .T.)
			SB2->B2_FILIAL	:= xFilial("SB2")
			SB2->B2_COD		:= aItens[i,01]
			SB2->B2_LOCAL	:= aItens[i,09]
			DbCommit()
			MsUnlock()
		EndIf
		aAdd(aMata261,{;
		aItens[i,01],;
		aItens[i,02],;
		aItens[i,03],;
		aItens[i,04],;
		aItens[i,05],;
		aItens[i,06],;
		aItens[i,07],;
		aItens[i,08],;
		aItens[i,09],;
		aItens[i,10],;
		aItens[i,11],;
		aItens[i,12],;
		aItens[i,13],;
		aItens[i,14],;
		aItens[i,15],;
		aItens[i,16],;
		aItens[i,17],;
		aItens[i,18],;
		aItens[i,19],;
		aItens[i,20],;
		aItens[i,21],;
		aItens[i,22],;
		aItens[i,23]})
	Next i

	If Len(aMata261) > 0
		If !Upper(Funname()) $ "U_APONTACD#DLGV001"
			//MATA261(aMata261, nOpcAuto)
			Processa({|lEnd| MSExecAuto({|x| mata261(x)},aMata261,nOpcAuto)},'Efetuando Transferencias...', 'Aguarde...', .T.)
			If lMsErroAuto
				//cMensagem := "Problemas Transferencia : "+DTOC(date())+" - "+time()+" hrs."+ _center
				//cMensagem += "Documento : " + AllTrim(cDoc) + _center
				//cMensagem += "Usuario Apontando " + AllTrim(cUsername)
				//U_ENVIAEMAIL(cTitemail,"paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
				//ApMsgStop("Corrija o Erro na Transferência!")
				_cerro:=MostraErro()
				Return
			EndIf
		Else
			MSExecAuto({|x| MATA261(x)},aMata261)
			If lMsErroAuto
				lRet := .F.
				VTALERT("Falha na Gravação da Transferência","Erro",.T.,4000,3) //"Falha na gravacao da transferencia"###"ERRO"
				DisarmTransaction()
				Break
			EndIf
		EndIf
	EndIf
EndIf

Return(lRet)