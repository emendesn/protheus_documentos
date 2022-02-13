#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETQLAUSAM ºAutor  ³ Edson Rodrigues    º Data ³ 09/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para impressao da etiqueta de Serviço/Laudo SAM   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Etqlausam(_aEtiquet, OpcDPI)
	Local nX
	Local cfont := "0"
	
	//parametros para impressora Zebra ZM400 - 400dpi - edson Rodrigues - 14/09/10
	//Local _aLin := {10,22,30,38,46,54,62,70,78,86,94,106,114,126,134,142}
	//Local _aCol := {05,18,25,38,55,68,38}
	//Local _afont :={"035,035","040,040","045,045","050,050","055,055"}
	
	//parametros para impressora Zebra ZM400 - 600dpi - edson Rodrigues - 14/09/10
	Local _aLin := {}
	Local _aCol := {}
	Local _afont :={}

u_GerA0003(ProcName())
	
	Dbselectarea("SA1")
	Dbsetorder(1)  //A1_FILIAL + A1_COD
	
	Dbselectarea("SB1")
	Dbsetorder(1)  //B1_FILIAL + B1_COD
	
	Dbselectarea("SZ8")   // CADASTRO SINTOMAS X SOLUCAO
	SZ8->(dbSetOrder(1))
	SZ8->(dbGoTop())
	
	Dbselectarea("SZM")   // CADASTRO SINTOMAS X SOLUCAO
	SZM->(dbSetOrder(2))
	SZM->(dbGoTop())
	
	Dbselectarea("AA1") // TECNICOS
	AA1->(dbSetOrder(1))
	AA1->(dbGoTop())
	
	Dbselectarea("ZZG") // TABELA RECLAMACAO
	ZZG->(dbSetOrder(2))
	ZZG->(dbGoTop())
	
	Dbselectarea("ZZ1") // CADASTRO DE FASES
	ZZ1->(dbSetOrder(1))
	ZZ1->(dbGoTop())
	
	Dbselectarea("SZ9") //DETALHES ATENDIMENTO
	SZ9->(dbSetOrder(2))  // Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM
	SZ9->(dbGoTop())
	
	Dbselectarea("ZZ3") // APONTAMENTO DE FASES
	ZZ3->(dbSetOrder(1))  // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
	ZZ3->(dbGoTop())
	
	Do Case
 		Case OpcDPI == 1 &&300dpi
			MSCBPRINTER("S300","LPT1",,144,.F.,,,,,,.T.)               		
			_aLin := {14,25,41,066,075,084,093,102,111,120,129,138,147,169,193,208}
			_aCol := {05,26,29,66,100,126,56}
			_afont:= {"035,035","040,040","045,045","055,055","055,055"}
		Case OpcDPI == 2 &&600dpi
			MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)
			_aLin := {20,45,78,92,106,118,130,142,154,166,178,193,210,230,260,275}
			_aCol := {10,36,56,76,110,136,66}
			_afont:= {"070,070","080,080","090,090","100,100","110,110"}
	EndCase
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estrutura da Matriz                                                         ³
	//³ 01 - OS CAR                                                                 ³
	//³ 02 - OS SAM                                                                 ³
	//³ 03 - NF ENTRADA                                                             ³
	//³ 04 - NFE SERIE                                                              ³
	//³ 05 - MODELO                                                                 ³
	//³ 06 - IMEI                                                                   ³                                                                 ³
	//³ 07 - DT RECEBIMENTO                                                         ³
	//³ 08 - NF COMPRA                                                              ³
	//³ 09 - DT REPARO                                                              ³
	//³ 10 - DEFEITO RECLAMADO                                                      ³
	//  11 - NF SAIDA                                                               ³
	//³ 12 - SERIE NF SAIDA                                                         ³
	//³ 13 - DT NF SAIDA                                                            ³
	//³ 14 - LACRE SAIDA                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Layout da Etiqueta                              ³
	//³ Ú--------------- 100 mm ------------------------¿
	//³ |  OS CAR   : 111111111111  OS SAM:111111111111 |
	//³ |  NF ENTR  : 222222222/222 ATEND : GARANTIA    |
	//³ |  PROD ENV : W270 - EURO BLACK                 | 144
	//³ |  DT RECEB : 00/00/00    NF COMPRA : 333333/333|  mm
	//³ |  DEFEITO RECLAMADO : C0022 - NAO LIGA         |
	//³ |  AVALIACAO TECNICA : P0010 - LIGA/DESLIGA     |
	//³ |  TECNICO  : N001 - EDSON RODRIGUES            |
	//³ |  DATA REPARO : 00/00/0000                     |
	//³ |  NF SAIDA    : 222222222/222  DT NFS: 00/00/00|
	//³ |  LACRE SAIDA : XXXXXYYYYY544444555            |
	//³ |                                               |
	//³ |  IMEI : 0006000111222333                      |
	//³ |  |||||||||||||||||||||||||||||||||||||||||||  |
	//³ |  |||||||||||||||||||||||||||||||||||||||||||  |
	//³ À---------------------------------------------Ù ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
	
	If Len(_aEtiquet) > 0
		For nX := 1 to Len(_aEtiquet)
			
	  		MSCBBEGIN(1,6,144)
					
			// Alimenta variaveis
			_coscar   := _aEtiquet[nX, 1]
			_cossam   := _aEtiquet[nX, 2]
			_cNFeNum  := _aEtiquet[nX, 3]
			_cNFeSer  := _aEtiquet[nX, 4]
			_cModelo  := _aEtiquet[nX, 5]
			_cIMEI    := _aEtiquet[nX, 6]
			_cDtrecb  := DTOC(_aEtiquet[nX, 7])
			_cnfcomp  := _aEtiquet[nX, 8]
			_cDtrepa  := DTOC(_aEtiquet[nX, 9])
			_cdefrec  := _aEtiquet[nX, 10]
			_cNFsNum  := _aEtiquet[nX, 11]
			_cNFsSer  := _aEtiquet[nX, 12]
			_cDTNFsai := DTOC(_aEtiquet[nX, 13])
			_clacres  := _aEtiquet[nX, 14]
			_cdescpro := getadvfval("SB1","B1_DESC",xFilial("SB1") + _aEtiquet[nX, 5] , 1, "")
			_cgarant  := getadvfval("ZZ4","ZZ4_GARANT",xFilial("ZZ4") + _aEtiquet[nX,6]+_aEtiquet[nX,1] , 1, "")
			_cclient  := getadvfval("ZZ4","ZZ4_CODCLI",xFilial("ZZ4") + _aEtiquet[nX,6]+_aEtiquet[nX,1] , 1, "")
			_cloja    := getadvfval("ZZ4","ZZ4_LOJA",xFilial("ZZ4") + _aEtiquet[nX,6]+_aEtiquet[nX,1] , 1, "")
			_cCHVFil  := getadvfval("ZZ4","ZZ4_CHVFIL",xFilial("ZZ4") + _aEtiquet[nX,6]+_aEtiquet[nX,1] , 1, "")
			If !empty(_aEtiquet[nX, 10])
			    _cdesdefr := substr(getadvfval("SX5","X5_DESCRI",xFilial("SX5") +"W4"+ _aEtiquet[nX, 10] , 1, ""),1,35)
			Else
			    _cdesdefr := "" 
			Endif    
			_lachsimpt :=.f.
			_lachactio :=.f.
			_cAcumSint := _cAcumSolu := _cAcumDef := _cDescSint := _ctecnico:= _ctecnome := ""
			_coperbgh :=Posicione("ZZ4",1,xFilial("ZZ4") + _cIMEI + LEFT(_coscar,6), "ZZ4_OPEBGH")
			_infaces  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_INFACE")
			_acessori :={}
			_cacesso  :=""
			_cacess2  :=""
			_cacess3  :=""
			_cGrau    :="0"
			_cNexSint :=""
			_cNexSolu :=""
			_cseqz9   :="0"
			_cfase    :=""
			_csetor   :=""
			_ccoment1 :="Este produto foi analisado, testado e higienizado."
			_ccoment2 :="Agradecemos o privilegio em poder atende-lo."
			_cDescSolu :=""
			_cDescSint :=""
			_cnomepost :=""
			_clocapost :=""
			_ccodsamcli:=""
			
			If _cclient=="Z00403" .AND. !EMPTY(_cCHVFil)			
				Dbselectarea("SA1")
				IF SA1->(dbSeek(xFilial("SA1") + SUBSTR(_cCHVFil,7,8)))
					_cnomepost:=ALLTRIM(LEFT(SA1->A1_NOME,40))
					_clocapost:=ALLTRIM(LEFT(SA1->A1_MUN,19))+'-'+ALLTRIM(LEFT(SA1->A1_BAIRRO,17))+'-'+ALLTRIM(SA1->A1_EST)
		            _ccodsamcli:=SA1->A1_XCODSAM
				ENDIF
			Else
				Dbselectarea("SA1")
				IF SA1->(dbSeek(xFilial("SA1") + _cclient + _cloja))
					_cnomepost:=ALLTRIM(LEFT(SA1->A1_NOME,40))
					_clocapost:=ALLTRIM(LEFT(SA1->A1_MUN,19))+'-'+ALLTRIM(LEFT(SA1->A1_BAIRRO,17))+'-'+ALLTRIM(SA1->A1_EST)
		            _ccodsamcli:=SA1->A1_XCODSAM
				ENDIF
			Endif
			
			Dbselectarea("SZ9")
			If SZ9->(dbSeek(xFilial("SZ9") + _cIMEI + left(_coscar,6) ))
				While SZ9->(!eof()) .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and. SZ9->Z9_IMEI == _cIMEI .and. left(SZ9->Z9_NUMOS,6) == left(_coscar,6)
					_cseqz9:=SZ9->Z9_SEQ
					cos:= SZ9->Z9_NUMOS
					_cNexSint:=IIF(EMPTY(SZ9->Z9_SYMPTO),_cNexSint,SZ9->Z9_SYMPTO)
					_cNexSolu:=IIF(EMPTY(SZ9->Z9_ACTION),_cNexSolu,SZ9->Z9_ACTION)
					IF SZ9->Z9_STATUS=='1'
						
						If (ZZ3->(dbSeek(xFilial("ZZ3") + cimei + cos+_cseqz9)) .or. ZZ3->(dbSeek(xFilial("ZZ3") + cimei + left(cos,6)+_cseqz9))  .or.  ZZ3->(dbSeek(xFilial("ZZ3") + cimei + left(cos,6)+'01'+_cseqz9)))
							
							
							While (ZZ3->ZZ3_FILIAL == xFilial("ZZ3")) .And. (ZZ3->ZZ3_IMEI == cimei) .And. (left(ZZ3->ZZ3_NUMOS,6) == left(cos,6)) .AND. (ZZ3->ZZ3_SEQ == _cseqz9)
														
								IF ZZ3->ZZ3_STATUS=='1'
									
									_cfase:=ZZ3->ZZ3_FASE1
									_csetor:=ZZ3->ZZ3_CODSET
									cLab:=ZZ3->ZZ3_LAB
									
									
									IF ZZ1->(dbSeek(xFilial("ZZ1") +cLab+ _csetor+_cfase))
										IF ZZ1->ZZ1_TIPO=="1"
											_cgrazz1:=IIF(empty(ZZ1->ZZ1_GRAU),"0",ZZ1->ZZ1_GRAU)
											
										    //Acrescentado esses Ifs, conforme alteração passada pelo Paulo Francisco - Edson Rodrigues - 30-11-10
											IF EMPTY(_cNexSint)
								               _cNexSint:=ZZ3->ZZ3_DEFDET
								            ENDIF   
								
								            IF EMPTY(_cNexSolu)
								               _cNexSolu:=ZZ3->ZZ3_ACAO
								            ENDIF   
	
											If !empty(_cNexSint) .and. !alltrim(_cNexSint) $ _cAcumSint .and.  _cgrazz1>=_cGrau
												_cAcumSint += "/"+_cNexSint
												_cDescSint := GetAdvFVal("SZ8","Z8_DESCLIS",xFilial("SZ8") + cLab + _cNexSint, 1,"")
												_cDescSint :=IIF (EMPTY(_cDescSint),Posicione("SX5",1,xFilial("SX5")+"W7"+  _cNexSint,"X5_DESCRI"),_cDescSint)
												_lachsimpt :=.t.
												_ctecnico  := SZ9->Z9_CODTEC
												_ctecnome  := getadvfval("AA1","AA1_NOMTEC",xFilial("AA1") + alltrim(SZ9->Z9_CODTEC) , 1, "")
												_cGrau     := ZZ1->ZZ1_GRAU
											Endif
											
											If !empty(_cNexSolu) .and. !alltrim(_cNexSolu) $ _cAcumSolu .and. _cgrazz1 >=_cGrau
												_cAcumSolu += "/"+_cNexSolu
												_cDescSolu := GetAdvFVal("SZ8","Z8_DESCLSO",xFilial("SZ8") + cLab + _cNexSolu, 2,"")
												//_cDescSolu := IIF(EMPTY(_cDescSolu),GetAdvFVal("SZ8","Z8_DESSOLU",xFilial("SZ8") + cLab + _cNexSolu, 2,""),_cDescSolu)
												_cDescSolu := IIF(EMPTY(_cDescSolu),GetAdvFVal("SZM","ZM_DESCPTB",xFilial("SZM")+ _cNexSolu, 2,""),_cDescSolu)
												_lachactio :=.t.
												
											Endif
											
										ENDIF
									ENDIF
									IF ZZ3->ZZ3_ENCOS='S' .AND. ZZ3->ZZ3_ESTORN<>'S'
										_cDtrepa:=DTOC(ZZ3->ZZ3_DATA)
									ENDIF
									
								ENDIF
								ZZ3->(dbSkip())
							ENDDO
						ENDIF
					ENDIF
					SZ9->(dbSkip())
				Enddo
			Endif
			
			If ZZ3->(dbSeek(xFilial("ZZ3") + _cIMEI + left(_coscar,6) )) .and. !_lachsimpt
				While ZZ3->(!eof()) .and. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .and. ZZ3->ZZ3_IMEI == _cIMEI .and. left(ZZ3->ZZ3_NUMOS,6) == left(_coscar,6)
					IF ZZ3->ZZ3_STATUS=='1'
						cLab:=ZZ3->ZZ3_LAB
						_cfase:=ZZ3->ZZ3_FASE1
						_csetor:=ZZ3->ZZ3_CODSET
						
						IF ZZ1->(dbSeek(xFilial("ZZ1") +cLab+ _csetor+_cfase))
							IF ZZ1->ZZ1_TIPO=="1"
								_cgrazz1:=IIF(empty(ZZ1->ZZ1_GRAU),"0",ZZ1->ZZ1_GRAU)
								IF !empty(ZZ3->ZZ3_DEFDET) .and. !alltrim(ZZ3->ZZ3_DEFDET) $ _cAcumDef  .and. _cgrazz1 >=_cGrau  
								//Acrescentado esses Ifs, conforme alteração passada pelo Paulo Francisco - Edson Rodrigues - 30-11-10
									IF EMPTY(_cNexSint)
								    	_cNexSint:=ZZ3->ZZ3_DEFDET
								    ENDIF   
								
								    IF EMPTY(_cNexSolu)
								    _cNexSolu:=ZZ3->ZZ3_ACAO
								    ENDIF   
								            
									_cAcumSint += "/"+ZZ3->ZZ3_DEFDET
									//_cDescSint := getadvfval("ZZG","ZZG_DESCLI",xFilial("ZZG") + ZZ3->ZZ3_DEFDET , 2, "")
									//_cDescSint := IIF(EMPTY(_cDescSint),getadvfval("ZZG","ZZG_DESCRI",xFilial("ZZG") + ZZ3->ZZ3_DEFDET , 2, ""),_cDescSint)
									_cDescSint := GetAdvFVal("SZ8","Z8_DESCLIS",xFilial("SZ8") + cLab + _cNexSint, 1,"")
									_cDescSint :=IIF (EMPTY(_cDescSint),Posicione("SX5",1,xFilial("SX5")+"W7"+  _cNexSint,"X5_DESCRI"),_cDescSint)
									_cDescSolu := GetAdvFVal("SZ8","Z8_DESCLSO",xFilial("SZ8") + cLab + _cNexSolu, 2,"")
									_cDescSolu := IIF(EMPTY(_cDescSolu),GetAdvFVal("SZM","ZM_DESCPTB",xFilial("SZM")+ _cNexSolu, 2,""),_cDescSolu)
									_lachsimpt :=.t.
									_ctecnico  := ZZ3->ZZ3_CODTEC
									_ctecnome  := getadvfval("AA1","AA1_NOMTEC",xFilial("AA1") + alltrim(_ctecnico) , 1, "")
									_cGrau     := ZZ1->ZZ1_GRAU
								Endif
								IF ZZ3->ZZ3_ENCOS='S' .AND. ZZ3->ZZ3_ESTORN<>'S'
									_cDtrepa:=DTOC(ZZ3->ZZ3_DATA)
								ENDIF
							ENDIF
						ENDIF
					ENDIF
					ZZ3->(dbSkip())
				Enddo
			Endif
			
			IF EMPTY(left(_cDtrepa,2))
				If ZZ3->(dbSeek(xFilial("ZZ3") + _cIMEI + left(_coscar,6) ))
					While ZZ3->(!eof()) .and. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .and. ZZ3->ZZ3_IMEI == _cIMEI .and. left(ZZ3->ZZ3_NUMOS,6) == left(_coscar,6)
						IF ZZ3->ZZ3_STATUS=='1'  .AND. ZZ3->ZZ3_ENCOS='S' .AND. ZZ3->ZZ3_ESTORN<>'S'
							_cDtrepa:=DTOC(ZZ3->ZZ3_DATA)
							if empty(_ctecnico)
								_ctecnico  := ZZ3->ZZ3_CODTEC
								_ctecnome  := getadvfval("AA1","AA1_NOMTEC",xFilial("AA1") + alltrim(_ctecnico) , 1, "")
								
							endif
						ENDIF
						ZZ3->(dbSkip())
					Enddo
				ENDIF
			Endif
			
			// Campos da etiqueta
			//	MSCBSAYBAR(nXmm, nYmm, cConteudo, cRotacao, cTypePrt, nAltura, lDigVer, lLinha, lLinBaixo, cSubSetIni, nLargura, nRelacao, lCompacta, lSerial, cIncr, lZerosL)
			
			MSCBSAY(_aCol[3],_aLin[1],"Relatorio de Servico BGH/SAM" ,"N",cfont,_afont[5])  // coluna 3 - Linha 1
	        MSCBSAY(_aCol[1],_aLin[2],"COD SAM: "+_ccodsamcli ,"N",cfont,_afont[3])  // coluna 1 - Linha 1 -INCLUIDO PELO JOSEILDO
			MSCBSAY(_aCol[1],_aLin[2]+08 ,"OS SAM : "+alltrim(_cossam)+"  /  OS CAR : "+alltrim(_coscar),"N",cfont,_afont[3])  // Coluna 1 - Linha 2
			MSCBSAY(_aCol[1],_aLin[3],"Nome SAM : "+_cnomepost,"N",cfont,_afont[2])  // Coluna 1 - Linha 3
			MSCBSAY(_aCol[1],_aLin[3]+06,"Local SAM : "+_clocapost,"N",cfont,_afont[2])  // Coluna 1 - Linha 3
			MSCBSAY(_aCol[1],_aLin[3]+21,"Nf Entr: ","N",cfont,_afont[2])  // Coluna 1 - Linha 3
			MSCBSAY(_aCol[2],_aLin[3]+21,alltrim(_cNFeNum)+"/"+alltrim(_cNFeSer),"N",cfont,_afont[2]) // Coluna 2 - Linha 3
			MSCBSAY(_aCol[4],_aLin[3]+21,"Atendto : " ,"N",cfont,_afont[2])  // Coluna 3 - Linha 3
			MSCBSAY(_aCol[5],_aLin[3]+21,IIF(_cgarant="S","Garantia","Fora de Garantia"),"N",cfont,_afont[2])  // Coluna 4 - Linha 4
			MSCBSAY(_aCol[1],_aLin[4],"MODELO : " ,"N",cfont,_afont[2])  // Coluna 1 - Linha 4
			MSCBSAY(_aCol[2]+2,_aLin[4],alltrim(_cModelo)+' - '+alltrim(_cdescpro),"N",cfont,_afont[2])  // Coluna 2 - Linha 4
			MSCBSAY(_aCol[1],_aLin[5],"Dt.Recbto : " +_cDtrecb	,"N",cfont,_afont[2])  // Coluna 1 - Linha 5
			MSCBSAY(_aCol[1],_aLin[6],"NF Compra : " +_cnfcomp  ,"N",cfont,_afont[2])  // Coluna 1 - Linha 6
			MSCBSAY(_aCol[1],_aLin[7],"Defeito Reclamado :  "+ alltrim(_cdesdefr)	,"N",cfont,_afont[2])  // Coluna 1 - Linha 7
			MSCBSAY(_aCol[1],_aLin[8],"Avaliacao Tecnica :  "+ alltrim(_cDescSint) ,"N",cfont,_afont[2])  // Coluna 1 - Linha 8
			MSCBSAY(_aCol[1],_aLin[9],"Solucao :  "+ alltrim(_cDescSolu) ,"N",cfont,_afont[2])  // Coluna 1 - Linha 8
			MSCBSAY(_aCol[1],_aLin[10],"Tecnico :  "+ alltrim(_ctecnico)+'-'+alltrim(_ctecnome) ,"N",cfont,_afont[2])  // Coluna 1 - Linha 9
			MSCBSAY(_aCol[1],_aLin[11],"Data de Reparo :  "+ _cDtrepa ,"N",cfont,_afont[2])  // Coluna 1 - Linha 10
	
			//MSCBSAY(_aCol[1],_aLin[11],"NF Saida : " ,"N",cfont,_afont[2])  // Coluna 1 - Linha 11
			//MSCBSAY(_aCol[2],_aLin[11],alltrim(_cNFsNum)+" / "+alltrim(_cNFsSer),"N",cfont,_afont[2]) // Coluna 2 - Linha 11
			//MSCBSAY(_aCol[5],_aLin[11],"Dt. NF Saida : " +_cDTNFsai	,"N",cfont,_afont[2])  // Coluna 1 - Linha 11
			//MSCBSAY(_aCol[1],_aLin[12],"Lacre NF Saida :" +_clacres	,"N",cfont,_afont[2])  // Coluna 1 - Linha 11
						
			IF _infaces="S"				
				_acessori:=U_buscaces(_aEtiquet[nX,3],_aEtiquet[nX,4],_cclient,_cloja,_cModelo,_cIMEI,_coperbgh)
				/*
				IF len(_acessori) > 0
				_cacesso:= "Acess.:"
				For xac:=1 to len(_acessori)
				IF xac <= 3
				_cacesso:=_cacesso+' '+strzero(_acessori[xac,1],2)+'-'+_acessori[xac,3]
				
				Elseif xac <= 3
				_cacesso:=_cacesso+' '+strzero(_acessori[xac,1],2)+'-'+_acessori[xac,3]
				
				ELSEIF xac > 3 .and. xac <=6
				_cacess2:=_cacess2+' '+strzero(_acessori[xac,1],2)+'-'+_acessori[xac,3]
				
				ELSEIF xac > 6 .and. xac <=9
				_cacess3:=_cacess3+' '+strzero(_acessori[xac,1],2)+'-'+_acessori[xac,3]
				ENDIF
				Next
				Endif
				*/
				
				
				If len(_acessori) > 0
					_ntamc    := 50
					_ntam2    := 55
					_nmultpl  := 7
					_nlin     := 1
					cCampo    := space(_ntamc*_nmultpl)
					cCompl    := space(50)
					alinaces  :={}
					
					For xac := 1 to len(_acessori)
						
						If !cCampo  =='_caces'+STRZERO(_nlin,2)
							cCampo  :='_caces'+STRZERO(_nlin,2)
	   					    &cCampo :=space(_ntamc*_nmultpl)
	   					Endif
						
						&cCampo:=alltrim(&cCampo)+' '+strzero(_acessori[xac,1],2)+'-'+_acessori[xac,3]
	
						If _nlin==1 .and. len(alltrim(&cCampo)) > _ntamc
							
							cCompl:=substr(alltrim(&cCampo),_ntamc+1)
							&cCampo:=substr(alltrim(&cCampo),1,_ntamc)
							aadd(alinaces,{_nlin,alltrim(&cCampo)})
							
							_nlin++
							cCampo:='_caces'+STRZERO(_nlin,2)
							&cCampo :=space(_ntamc*_nmultpl)
							&cCampo:=alltrim(&cCampo)+alltrim(cCompl)+' '
							If !len(alltrim(&cCampo)) >_ntamc .and. len(_acessori)==xac
							   aadd(alinaces,{_nlin,alltrim(&cCampo)})
							Endif   
						
						Elseif _nlin > 1 .and. len(alltrim(&cCampo)) > _ntam2
						
	                     	cCompl:=substr(alltrim(&cCampo),_ntam2+1)
	                     	&cCampo:=substr(alltrim(&cCampo),1,_ntam2)
							aadd(alinaces,{_nlin,alltrim(&cCampo)})
							
							_nlin++
							cCampo:='_caces'+STRZERO(_nlin,2)
							&cCampo :=space(_ntamc*_nmultpl)
							&cCampo:=alltrim(&cCampo)+alltrim(cCompl)+' '						
						    If !len(alltrim(&cCampo)) >_ntam2 .and. len(_acessori)==xac
							   aadd(alinaces,{_nlin,alltrim(&cCampo)})
							Endif   
						
						Elseif  !len(alltrim(&cCampo)) > _ntam2 .and. len(_acessori)==xac
						    aadd(alinaces,{_nlin,alltrim(alltrim(&cCampo))})
						Endif
						
					Next xac
					
					If _nlin==1 .and. len(alinaces) = 0 .and. len(alltrim(&cCampo)) > 0
						aadd(alinaces,{_nlin,alltrim(alltrim(&cCampo))})
					Endif
					
					
					If len(alinaces) > 0
						
						For x:=1 to  len(alinaces)
							If x==1
								MSCBSAY(_aCol[1],_aLin[12],"Acess.:"+alinaces[x][2],"N",cfont,_afont[1])
							Else
								MSCBSAY(_aCol[1],_aLin[12]+((X-1)*_nmultpl),alinaces[x][2],"N",cfont,_afont[1])
							Endif
						Next
					Endif
				Endif
				/*
				// Linha 6
				MSCBSAY(_aCol[1],_aLin[12],_cacesso,"N",cfont,_afont[1])
				IF !EMPTY(_cacess2)
				MSCBSAY(_aCol[1],_aLin[12]+7,_cacess2,"N",cfont,_afont[1])
				END
				IF !EMPTY(_cacess3)
				MSCBSAY(_aCol[1],_aLin[12]+14,_cacess3,"N",cfont,_afont[1])
				END
				*/
			ENDIF
			
			IF _infaces="S"
				Do Case 
					Case OpcDPI ==1                                                                          
						MSCBSAY(_aCol[1]+5,_aLin[14],"Comentario: " +_ccoment1	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAY(_aCol[1]+19,_aLin[14]+7,_ccoment2	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAY(_aCol[3]+17, _aLin[15]-6,"IMEI :" +_cIMEI	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAYBAR(_aCol[3]+16,_aLin[16]-12,alltrim(_cIMEI),"N","MB07",10,.F.,.F.,.F.,,2,1)
					Case OpcDPI ==2
						MSCBSAY(_aCol[1],_aLin[14],"Comentario: " +_ccoment1	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAY(_aCol[1]+14,_aLin[14]+7,_ccoment2	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAY(_aCol[3]+1,_aLin[15]-6,"IMEI :" +_cIMEI	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAYBAR(_aCol[3],_aLin[16]-12,alltrim(_cIMEI),"N","MB07",15,.F.,.F.,.F.,,5,1)
				EndCase
			ELSE    
				Do Case 
					Case OpcDPI ==1
						MSCBSAY(_aCol[1]+5,_aLin[13],"Comentario: " +_ccoment1	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAY(_aCol[1]+19,_aLin[13]+7,_ccoment2	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAY(_aCol[3]+17, _aLin[14],"IMEI :" +_cIMEI	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAYBAR(_aCol[3]+16,_aLin[14]+8,alltrim(_cIMEI),"N","MB07",10,.F.,.F.,.F.,,2,1)
					Case OpcDPI ==2
						MSCBSAY(_aCol[1]+5,_aLin[12]+9,"Comentario: " +_ccoment1	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAY(_aCol[1]+14,_aLin[13],_ccoment2	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAY(_aCol[3]+1,_aLin[14]+10,"IMEI :" +_cIMEI	,"N",cfont,_afont[2])  // Coluna 1 - Linha 12
						MSCBSAYBAR(_aCol[3],_aLin[15]-11,alltrim(_cIMEI),"N","MB07",15,.F.,.F.,.F.,,5,1)
					EndCase
			ENDIF
			
			MSCBEND()
			
		Next nX
	Endif
	MSCBCLOSEPRINTER()
	_aEtiquet:={}
Return
