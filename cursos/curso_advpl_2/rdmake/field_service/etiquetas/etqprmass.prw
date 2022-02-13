#INCLUDE "rwmake.ch" 
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบExecblock ณ EtqPRMassบ Autor ณ Vinicius Leonardo  บ Data ณ  21/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para impressao de Etiquetas.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function EtqPRMass(_aEtiquet,cCarcaca,lPerg,nImp)

Local nX 
Local _a3aLin 	:= {03,06,09,12,15,18,22,25,28,31,34,37,40} 
Local _a3bLin 	:= {03,06,09,12,15,18,21,24,27,30,33,36,39}
Local _a2aLin 	:= {02,04,07,09,11,13,16,18,20,22,24,26,28}
Local _a2bLin 	:= {02,04,07,09,11,13,15,17,19,21,23,25,27}
Local _a3Col 	:= {05,32,35,53}  //05,30  
Local _a2Col 	:= {02,24,27,45}  //05,30 
Local _afont 	:= {"015,015","030,030"}
Local _aTamBar	:= {1.5,1,2}
Local aDefSol 	:= {}
Local aPecas  	:= {}
Local cDef	  	:= "" 
Local cAcao	  	:= ""
Local cPeca	  	:= "" 
Local cImeiNovo := ""
Local cSI		:= "" 
Local cMod		:= ""
Local lDef 		:= .F.
Local lAcao 	:= .F.
Local lAcDef 	:= .F.
Local aCarac	:= {} 
Local lDef      := .F.
Local lAcDef    := .F.
Local lAcao     := .F.
Local nlin		:= 0 

Default lPerg	:= .T.

//Local _aEtiquet := {}
//Local cCarcaca := "" //"NXMFXAL0134056DDD69501" 

PRIVATE cPerg     := "TPPRT" 

If lPerg 
	CRIASX1()
	PERGUNTE(cPerg,.T.) 
	nImp := MV_PAR01
EndIf

IF nImp == 1 //200 DPI                                                 l
	cFonte := _afont[1]
	nTmBar := _aTamBar[1]
	_aLin  := _a2aLin
	_a2Lin := _a2bLin
	_aCol  := _a2Col
	aAdd(aCarac,{66,132,198,264,330,64})
ElseIf nImp == 2 //300 DPI 
	cFonte := _afont[2] 
	nTmBar := _aTamBar[3]
	_aLin  := _a3aLin
	_a2Lin := _a3bLin
	_aCol  := _a3Col
	aAdd(aCarac,{56,112,168,224,280,54})
EndIf

u_GerA0003(ProcName())

/*aAdd (aDefSol,{"NรO LIGA","TROCA DO TELEFONE"})

aAdd (aPecas,{"ALOJAMENTO FRONTAL MONTADO COM"}) 
aAdd (aPecas,{"SUPORTE COM ESPUMAS DE PROTECA"})
aAdd (aPecas,{"ALTO FALANTE MONTADO COM ESPUM"})
aAdd (aPecas,{"ALOJAMENTO FRONTAL DO FLIP MON"})
aAdd (aPecas,{"HOUSING FRONTAL MONTADO COM TE"})
aAdd (aPecas,{"ALOJAMENTO (CHASSIS) FRONTAL"})  
aAdd (aPecas,{"PLACA DE CIRCUITO IMPRESSO FLE"})
aAdd (aPecas,{"CONTATO ELETRICO PARA AP"})      
aAdd (aPecas,{"CHASSI INTERNO DO RADIO"})
aAdd (aPecas,{"HOUSING FRONTAL MONTADO COM TE"}) 
aAdd (aPecas,{"ALTO FALANTE MONTADO COM ESPUM"})        

For nx:=1 to 2
	aAdd(_aEtiquet, {"351867069862586",;
				 "9BEVNX", "01", "000171955", "3","1280-7607",stod("20150515"),0, "Z01V3U", "01",;
				 "0001323",  ,	 ,  ,  ,  ,0,,Iif (nx==1,"351832064130637",""),Iif (nx==1,"1281-5723",""),aDefSol,aPecas}) // M.Munhoz - 16/08/2011
Next nx*/				 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura da Matriz                                                         ณ
//ณ 01 - IMEI                                                                   ณ
//ณ 02 - Numero da OS                                                           ณ
//ณ 03 - Item da OS                                                             ณ
//ณ 04 - Numero da NF de Entrada                                                ณ
//ณ 05 - Serie da NF de Entrada                                                 ณ
//ณ 06 - Modelo do aparelho                                                     ณ
//ณ 07 - Data de Entrada                                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Layout da Etiqueta                              ณ
//ณ ฺ--------------- 88 mm -----------------------ฟ ณ
//ณ |  IMEI: 000000000000000                      | ณ
//ณ |  OS: 000000-0000	Modelo: XXXXXXXXXXXXXX 22 | ณ
//ณ |  NF/Serie: 000000/000	Dt.Entr: 99/99/99  mm ณ ณ
//ณ ภ---------------------------------------------ู ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.)

For nX := 1 to Len(_aEtiquet)

	lDef      := .F.
	lAcDef    := .F.
	lAcao     := .F.

	MSCBBEGIN(1,6)
/*
	// Alimenta flag de impressao da etiqueta no SD1
	if _aEtiquet[nX,8] <> 0
		SD1->(dbGoTo(_aEtiquet[nX,8]))
		reclock("SD1",.f.)
		SD1->D1_XIMPETQ := "S"
		msunlock()
	endif
*/
	// Alimenta flag de impressao da etiqueta no ZZ4 - Alterado por M.Munhoz em 16/08/2011
	if _aEtiquet[nX,17] <> 0
		ZZ4->(dbGoTo(_aEtiquet[nX,17]))
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_IMPETQ := "S"
		msunlock()
	endif

	// Alimenta variaveis
	_cIMEI    := _aEtiquet[nX, 1]
	_cOS      := _aEtiquet[nX, 2] + "/" + _aEtiquet[nX, 3]
	_cNFSer   := _aEtiquet[nX, 4] + "/" + _aEtiquet[nX, 5]
	_cModelo  := _aEtiquet[nX, 6]
	_cDtEntr  := dtoc(_aEtiquet[nX, 7])
	_cCliente := _aEtiquet[nX, 9] + "/" + _aEtiquet[nX,10] 
	cNomeCli  := Alltrim(Posicione("SA1",1,xFilial("SA1")+AvKey(_aEtiquet[nX, 9],"A1_COD")+AvKey(_aEtiquet[nX,10],"A1_LOJA"),"A1_NREDUZ"))
	cImeiNovo := Alltrim(_aEtiquet[nX, 19])
	cSI		  := Alltrim(_aEtiquet[nX, 20])
	cMod	  := Alltrim(Posicione("SB1",1,xFilial("SB1")+AvKey(_cModelo,"B1_COD"),"B1_MODELO"))
	cDef      := ""             
	cAcao     := ""
	cPeca     := ""
	aDefSol   := {}
	aPecas    := {}
	aDefSol	  := _aEtiquet[nX, 21]
	aPecas	  := _aEtiquet[nX, 22]
	
	If Len(aDefSol) > 0
		For y:=1 To Len(aDefSol)
		    If y == Len(aDefSol)
			 	cDef := cDef + aDefSol[y][1]
			 	cAcao := cAcao + aDefSol[y][2]
			Else
			 	cDef := cDef + aDefSol[y][1]+"/" 
			 	cAcao := cAcao + aDefSol[y][2]+"/"
			EndIf		
		Next y		
	EndIf 
	
	If Len(aPecas) > 0
		For y:=1 To Len(aPecas)
		    If y == Len(aPecas)
				cPeca := cPeca + aPecas[y][1]
			Else
				cPeca := cPeca + aPecas[y][1]+"/"
			EndIf		
		Next y		
	EndIf	   	
	
	// Campos da etiqueta
	MSCBSAY(_aCol[1],_aLin[1],"IMEI: " 		+ _cIMEI	,"N","0",cFonte)  // Coluna 1 - Linha 1
	MSCBSAY(_aCol[2]+10,_aLin[1],"Modelo: " 	+ _cModelo	,"N","0",cFonte)  // Coluna 2 - Linha 2
//	MSCBSAYBAR(nXmm, nYmm, cConteudo, cRotacao, cTypePrt, nAltura, lDigVer, lLinha, lLinBaixo, cSubSetIni, nLargura, nRelacao, lCompacta, lSerial, cIncr, lZerosL)
	MSCBSAYBAR(_aCol[1],_aLin[2],_aEtiquet[nX, 1],"N","MB07",nTmBar,.F.,.F.,.F.,,2,1)
//	MSCBSAYBAR(_aCol[1],_aLin[2],_aEtiquet[nX, 1],"N","MB07",2.5,.F.,.F.,.F.,,2,1)
	MSCBSAY(_aCol[1],_aLin[3],"OS: " 		+ _cOS		,"N","0",cFonte)  // Coluna 1 - Linha 3
	MSCBSAY(_aCol[2]-4,_aLin[3],"Cliente: "	+ _cCliente + "-" + cNomeCli	,"N","0",cFonte)  // Coluna 2 - Linha 3
	if !empty(_aEtiquet[nX, 11])
		MSCBSAY(_aCol[2]-4,_aLin[4],"Lote: "	+ _aEtiquet[nX, 11]	,"N","0",cFonte)  // Coluna 4 - Linha 3
	endif
	MSCBSAY(_aCol[1],_aLin[4],oemtoansi("NF/Serie: ") 	+ _cNFSer	,"N","0",cFonte)  // Coluna 1 - Linha 4
	MSCBSAY(_aCol[2]+13,_aLin[4],"Dt.Entr.: " 	+ _cDtEntr	,"N","0",cFonte)  // Coluna 2 - Linha 4
	if alltrim(_aEtiquet[nX, 5]) == "3"
		MSCBSAY(_aCol[2]+5,_aLin[5],"  CORREIO"	,"N","0",cFonte)  // Coluna 4 - Linha 4
	endif
	If !Empty(cMod)
		MSCBSAY(_aCol[2]+16,_aLin[5],"Mod: " + cMod 	,"N","0",cFonte)  // Coluna 4 - Linha 4
	EndIf
	If !Empty(cCarcaca)
		MSCBSAY(_aCol[1],_aLin[5],"MAC ADRESS: " 		+ cCarcaca	,"N","0",cFonte)  // Coluna 1 - Linha 1	
		MSCBSAYBAR(_aCol[1],_aLin[6],cCarcaca,"N","MB07",_aTamBar[2],.F.,.F.,.F.,,1,1)
	EndIF
	
	If !Empty(cImeiNovo)
		MSCBSAY(_aCol[1],_aLin[5],oemtoansi("IMEI NOVO: ") 	+ cImeiNovo	,"N","0",cFonte)  // Coluna 1 - Linha 4 
		MSCBSAYBAR(_aCol[1],_aLin[6],cImeiNovo,"N","MB07",nTmBar,.F.,.F.,.F.,,2,1)   
	EndIf
	If !Empty(cSI) 
		MSCBSAY(_aCol[2]-4,_aLin[7],oemtoansi("S.I.: ") 	+ cSI	,"N","0",cFonte)  // Coluna 1 - Linha 4 
	EndIf
	
	If !Empty(cImeiNovo) .and. !Empty(cSI)
		MSCBSAY(_aCol[1],_aLin[7],"Data: "+ dtoc(dDataBase)	,"N","0",cFonte)  // Coluna 4 - Linha 3	
		If !Empty(cDef)		
			If Len(cDef)<=aCarac[1][6] 	
				MSCBSAY(_aCol[1],_aLin[8],oemtoansi("Defeitos: ") 	+ cDef	,"N","0",cFonte)  // Coluna 1 - Linha 4
			Else
				MSCBSAY(_aCol[1],_aLin[8],oemtoansi("Defeitos: ") 	+ SubStr(cDef,1,aCarac[1][6])	,"N","0",cFonte)  // Coluna 1 - Linha 4
				MSCBSAY(_aCol[1],_aLin[9],SubStr(cDef,aCarac[1][6]+1,aCarac[1][6]+9)		,"N","0",cFonte)  // Coluna 1 - Linha 4 
				lDef := .T.
			EndIf
		EndIf		 
		If !Empty(cAcao)
			If lDef
				If Len(cAcao)<=aCarac[1][1] 	
					MSCBSAY(_aCol[1],_aLin[10],oemtoansi("Acoes: ") 	+ cAcao	,"N","0",cFonte)  // Coluna 1 - Linha 4
				Else
					MSCBSAY(_aCol[1],_aLin[10],oemtoansi("Acoes: ") 	+ SubStr(cAcao,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4
					MSCBSAY(_aCol[1],_aLin[11],SubStr(cAcao,aCarac[1][1]+1,aCarac[1][1]+6)		,"N","0",cFonte)  // Coluna 1 - Linha 4 
					lAcDef := .T.
					lDef   := .F.				
				EndIf
			Else 		
				If Len(cAcao)<=aCarac[1][1] 	
					MSCBSAY(_aCol[1],_aLin[9],oemtoansi("Acoes: ") 	+ cAcao	,"N","0",cFonte)  // Coluna 1 - Linha 4
				Else
					MSCBSAY(_aCol[1],_aLin[9],oemtoansi("Acoes: ") 	+ SubStr(cAcao,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4
					MSCBSAY(_aCol[1],_aLin[10],SubStr(cAcao,aCarac[1][1]+1,aCarac[1][1]+6)		,"N","0",cFonte)  // Coluna 1 - Linha 4 
					lAcao := .T.					
				EndIf
			EndIf	
		EndIf	 
		If !Empty(cPeca)
			nlin := 10
			If lDef
				nlin := 10
			ElseIf lAcao
				nlin := 11
			ElseIf lAcDef 
				nlin := 12
			EndIf					
			If Len(cPeca)<=aCarac[1][1]             
			
				MSCBSAY(_aCol[1],_aLin[nlin],oemtoansi("Pecas: ") 	+ cPeca	,"N","0",cFonte)  // Coluna 1 - Linha 4  
				
			ElseIf Len(cPeca)>aCarac[1][1] .and. Len(cPeca)<=aCarac[1][2]             
			
				MSCBSAY(_aCol[1],_aLin[nlin],oemtoansi("Pecas: ") 	+ SubStr(cPeca,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_aLin[nlin]+1,SubStr(cPeca,aCarac[1][1]+1,aCarac[1][1]+6)		,"N","0",cFonte)  // Coluna 1 - Linha 4 
			    
			ElseIf Len(cPeca)>aCarac[1][2] .and. Len(cPeca)<=aCarac[1][3]  
			
				MSCBSAY(_aCol[1],_aLin[nlin],oemtoansi("Pecas: ") 	+ SubStr(cPeca,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4 				 
			    MSCBSAY(_aCol[1],_aLin[nlin]+1,SubStr(cPeca,aCarac[1][1]+1,aCarac[1][1]+6)		,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_aLin[nlin]+2,SubStr(cPeca,aCarac[1][2]+1,aCarac[1][1]+6)   		,"N","0",cFonte)  // Coluna 1 - Linha 4
			     
			ElseIf Len(cPeca)>aCarac[1][3]       
			
				MSCBSAY(_aCol[1],_aLin[nlin],oemtoansi("Pecas: ") 	+ SubStr(cPeca,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_aLin[nlin]+1,SubStr(cPeca,aCarac[1][1]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_aLin[nlin]+2,SubStr(cPeca,aCarac[1][2]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4   
			    MSCBSAY(_aCol[1],_aLin[nlin]+3,SubStr(cPeca,aCarac[1][3]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4 		 
			EndIf
		EndIf
	Else
		MSCBSAY(_aCol[1],_a2Lin[5],"Data: "+ dtoc(dDataBase)	,"N","0",cFonte)  // Coluna 4 - Linha 3
		If !Empty(cDef)		
			If Len(cDef)<=aCarac[1][6] 	
				MSCBSAY(_aCol[1],_a2Lin[6],oemtoansi("Defeitos: ") 	+ cDef	,"N","0",cFonte)  // Coluna 1 - Linha 4
			Else
				MSCBSAY(_aCol[1],_a2Lin[6],oemtoansi("Defeitos: ") 	+ SubStr(cDef,1,aCarac[1][6])	,"N","0",cFonte)  // Coluna 1 - Linha 4
				MSCBSAY(_aCol[1],_a2Lin[7],SubStr(cDef,aCarac[1][6]+1,aCarac[1][6]+9)		,"N","0",cFonte)  // Coluna 1 - Linha 4 
				lDef := .T.
			EndIf		
		EndIf		 
		If !Empty(cAcao)		
			If lDef
				If Len(cAcao)<=aCarac[1][1] 	
					MSCBSAY(_aCol[1],_a2Lin[8],oemtoansi("Acoes: ") 	+ cAcao	,"N","0",cFonte)  // Coluna 1 - Linha 4
				Else
					MSCBSAY(_aCol[1],_a2Lin[8],oemtoansi("Acoes: ") 	+ SubStr(cAcao,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4
					MSCBSAY(_aCol[1],_a2Lin[9],SubStr(cAcao,aCarac[1][1]+1,aCarac[1][1]+6)		,"N","0",cFonte)  // Coluna 1 - Linha 4 
					lAcDef := .T.
					lDef   := .F.				
				EndIf
			Else 		
				If Len(cAcao)<=aCarac[1][1] 	
					MSCBSAY(_aCol[1],_a2Lin[7],oemtoansi("Acoes: ") 	+ cAcao	,"N","0",cFonte)  // Coluna 1 - Linha 4
				Else
					MSCBSAY(_aCol[1],_a2Lin[7],oemtoansi("Acoes: ") 	+ SubStr(cAcao,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4
					MSCBSAY(_aCol[1],_a2Lin[8],SubStr(cAcao,aCarac[1][1]+1,aCarac[1][1]+6)		,"N","0",cFonte)  // Coluna 1 - Linha 4 
					lAcao := .T.					
				EndIf
			EndIf
		EndIf	 
		If !Empty(cPeca)
			nlin := 8		
			If lDef
				nlin := 8
			ElseIf lAcao
				nlin := 9
			ElseIf lAcDef 
				nlin := 10
			EndIf	 
			If Len(cPeca)<=aCarac[1][1]
				MSCBSAY(_aCol[1],_a2Lin[nlin],oemtoansi("Pecas: ") 	+ cPeca	,"N","0",cFonte)  // Coluna 1 - Linha 4 
			ElseIf Len(cPeca)>aCarac[1][1] .and. Len(cPeca)<=aCarac[1][2]       
			
				MSCBSAY(_aCol[1],_a2Lin[nlin],oemtoansi("Pecas: ") 	+ SubStr(cPeca,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+1,SubStr(cPeca,aCarac[1][1]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4 
			    
			ElseIf Len(cPeca)>aCarac[1][2] .and. Len(cPeca)<=aCarac[1][3] 
			
				MSCBSAY(_aCol[1],_a2Lin[nlin],oemtoansi("Pecas: ") 	+ SubStr(cPeca,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+1,SubStr(cPeca,aCarac[1][1]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+2,SubStr(cPeca,aCarac[1][2]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4 
			    
			ElseIf Len(cPeca)>aCarac[1][3] .and. Len(cPeca)<=aCarac[1][4] 
			
				MSCBSAY(_aCol[1],_a2Lin[nlin],oemtoansi("Pecas: ") 	+ SubStr(cPeca,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+1,SubStr(cPeca,aCarac[1][1]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+2,SubStr(cPeca,aCarac[1][2]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4   
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+3,SubStr(cPeca,aCarac[1][3]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    		
			ElseIf Len(cPeca)>aCarac[1][4] .and. Len(cPeca)<=aCarac[1][5]           
			
				MSCBSAY(_aCol[1],_a2Lin[nlin],oemtoansi("Pecas: ") 	+ SubStr(cPeca,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+1,SubStr(cPeca,aCarac[1][1]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+2,SubStr(cPeca,aCarac[1][2]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4   
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+3,SubStr(cPeca,aCarac[1][3]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4 	
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+4,SubStr(cPeca,aCarac[1][4]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    
			ElseIf Len(cPeca)>aCarac[1][5]                                     
			
				MSCBSAY(_aCol[1],_a2Lin[nlin],oemtoansi("Pecas: ") 	+ SubStr(cPeca,1,aCarac[1][1])	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+1,SubStr(cPeca,aCarac[1][1]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+2,SubStr(cPeca,aCarac[1][2]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4   
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+3,SubStr(cPeca,aCarac[1][3]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4 	
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+4,SubStr(cPeca,aCarac[1][4]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4  
			    MSCBSAY(_aCol[1],_a2Lin[nlin]+5,SubStr(cPeca,aCarac[1][5]+1,aCarac[1][1]+6)	,"N","0",cFonte)  // Coluna 1 - Linha 4         
			EndIf
		EndIf
	EndIf		

	MSCBEND()

Next nX

MSCBCLOSEPRINTER()

Return 
Static Function CriaSX1()
	// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Impressora","Impressora","Impressora","mv_ch1","N",01,0,0,"C","",""	,"",,"mv_par01","ZEBRA 200 DPI"	,"","","","ZEBRA 300 DPI"		,"","",""	,"","","","","","","","")

Return Nil
