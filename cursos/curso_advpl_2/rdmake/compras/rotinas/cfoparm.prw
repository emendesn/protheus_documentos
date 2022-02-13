/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CFOPARM  บAutor  ณClaudia Cabral      บ Data ณ  11/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para amarracao de CFOP x ARMAZEM                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL - sera utilizado no Ped.de Comprasบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
User Function CFOPARM()

axCadastro("ZZI", "Cadastro de CFOP x Armazens")

return             
*/

USER FUNCTION XVALCFOP(cTipo)
/* fUNCAO QUE VERIFICA SE EXISTE AMARRACAO DO CFOP COM O ARMAZEM, CASO EXISTA, VERIFICA SE O QUE FOI
DIGITADO PELO USUARIO EH VALIDO COM A TABELA DE AMARRACOES ZZI  */
Local cCfop:= ''
Local aArea := GetArea()                                       
Local lRet   := .t.
Local cTes   := ''
Local cLocal := ''
Local _nPosTES := 0
Local _nPosLoc := 0
Local lCFOParm := ""
u_GerA0003(ProcName())

If upper(Alltrim(funname())) <> 'IPTXTGCOM'
	lCFOParm := GetMV("ZZ_CFOPARM",.F.)
	If lCFOParm
	 dbSelectArea('ZZI')
	 dbSetOrder(1)    
	 If cTipo = "SC7" // ORIGEM DO PEDIDO DE COMPRAS
	  _nPosTES := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_TES"   })
	  _nPosLoc := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_LOCAL" })
	  cLocal := aCols[n,_nPosLoc]
	  IF READVAR() = 'M->C7_LOCAL' .AND. cLocal <> M->C7_LOCAL
	   cLocal := M->C7_LOCAL
	  Endif
	 ELSE // ORIGEM DA NF DE ENTRADA 
	  _nPosTES :=  aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_TES"   })
	  _nPosLoc := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_LOCAL" })  
	  cLocal := aCols[n,_nPosLoc]
	  IF READVAR() = 'M->D1_LOCAL'  .AND. cLocal <> M->D1_LOCAL
	   cLocal := M->D1_LOCAL
	  Endif
	 ENDIF                           
	 If _nPosTES > 0 
	  cTes   := aCols[n,_nPosTES]
	  SF4->(DBSeek(xFilial('SF4')+cTes)) // BUSCA TES PARA ACHAR O CFOP
	  cCfop := SF4->F4_CF      
	  IF ZZI->(DBSeek(xFilial('ZZI')+ cCfop ))// BUSCA O CFOP  PARA VERIFICAR SE EXISTE AMARRACAO, SE EXISTIR EH FEITA A VALIDACAO
	   lRet := .F. // so voltara a ser .T. se achar a amarracao correta com o armazem
	   Do While !ZZI->(EOF()) .AND. alltrim(cCfop) = alltrim(ZZI->ZZI_CFOP) // VERIFICA SE O ARMAZEM QUE FOI DIGITADO PELO USUARIO EXISTE NA TABELA DE AMARRACOES COM O CFOP
	    If ZZI->ZZI_LOCAL = cLocal
	     lRet := .t.     
	     exit
	    EndIf
	    ZZI->(DbSkip())
	   EndDo
	  EndIF
	 Endif
	 RestArea(aArea)    
	 if !lRet 
	  ApMsgStop('TES/CFOP nใo permitida para o armaz้m informado (bloqueio de regra de neg๓cio BGH).ENTRE EM CONTATO COM O SETOR DE CONTROLADORIA para esclarecimento(s).')
	 Endif
	EndIf
EndIf	
Return lRet