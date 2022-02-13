#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*                                                                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETQARMAZ ºAutor  ³ Edson Rodrigues    º Data ³ 02/08/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para impressao da etiqueta de Armazenagem         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Etqarmaz(_aEtiquet)
//User Function Etqarmaz()

Local nX
Local _aLin := {15,30,45,60,75,90,105,120,135}
Local _aCol := {03,40}  //05,30

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura da Matriz                                                         ³
//³ 01 - ARMAZEM                                                                ³
//³ 02 - LOTE                                                                   ³
//³ 03 - ORIGEM                                                                 ³
//³ 04 - MODELO                                                                 ³
//³ 05 - NFE ENTRADA                                                            ³                                                                 ³
//³ 06 - SERIE NFE                                                              ³
//³ 07 - DATA ENTRADA                                                           ³
//³ 08 - QUANTIDADE PROD POR CAIXA                                              |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Layout da Etiqueta                              ³
//³ Ú--------------- 100 mm -----------------------¿³
//³ |  NOTA ENTRADA : XXXXXXXXX  SERIE : XXX      | ³
//³ |  MODELO : XXXXXXXXXXXXXXX                 144³
//³ |  ARMAZEM : XX                               mm³
//³ |  ORIGEM  : XX                               ³ ³
//³ |  LOTE    : XXXXXXX                          ³ ³
//³ |  QTDE CAIXA : 999                           ³ ³
//³ À---------------------------------------------Ù ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)

//_aEtiquet:={}
//AADD(_aEtiquet,{'XXXXXXXXXXXXXXX','999999999','999','10',DATE(),'YYYYYYY','SP',300})       

If Len(_aEtiquet) > 0
   For nX := 1 to Len(_aEtiquet)

	MSCBBEGIN(1,6,144)


	// Alimenta variaveis
	_cModelo  := _aEtiquet[nX, 1]
	_cNFNum   := _aEtiquet[nX, 2] 
	_cNFSer   := _aEtiquet[nX, 3] 
	_carmaz   := _aEtiquet[nX, 4]
	_cDtEntr  := _aEtiquet[nX, 5]
	_clote    := _aEtiquet[nX, 6]
	_corigem  := _aEtiquet[nX,7]
	_cqtdecx  := STRZERO(_aEtiquet[nX,8],3)
		
	// Campos da etiqueta
//	MSCBSAYBAR(nXmm, nYmm, cConteudo, cRotacao, cTypePrt, nAltura, lDigVer, lLinha, lLinBaixo, cSubSetIni, nLargura, nRelacao, lCompacta, lSerial, cIncr, lZerosL)
	

	MSCBSAY(_aCol[1],_aLin[1],"ARMAZEM : " ,"N","0","090,090")  // Coluna 1 - Linha 1
	MSCBSAY(_aCol[2],_aLin[1],_carmaz      ,"N","0","125,125")  // Coluna 2 - Linha 1
	MSCBSAY(_aCol[1],_aLin[2],"LOTE    : " ,"N","0","080,080")  // Coluna 1 - Linha 2
	MSCBSAY(_aCol[2],_aLin[2],_clote       ,"N","0","115,115")  // Coluna 2 - Linha 2
	MSCBSAY(_aCol[1],_aLin[3],"ORIGEM  : " ,"N","0","080,080")  // Coluna 1 - Linha 3
	MSCBSAY(_aCol[2],_aLin[3],_corigem 	    ,"N","0","125,125")  // Coluna 2 - Linha 3
	MSCBSAY(_aCol[1],_aLin[4],"MODELO : "  ,"N","0","080,080")  // Coluna 1 - Linha 4
	MSCBSAY(_aCol[2],_aLin[4],_cModelo 	    ,"N","0","090,090")  // Coluna 1 - Linha 4
	MSCBSAY(_aCol[1],_aLin[5],"ENTRADA :  "	 +_cDtEntr	,"N","0","080,080")  // Coluna 1 - Linha 5
	MSCBSAY(_aCol[1],_aLin[6],"NFE :  "	+ _cNFNum       ,"N","0","080,080")  // Coluna 1 - Linha 6
	MSCBSAY(_aCol[1],_aLin[7],"SERIE :  " 	+ _cNFSer	,"N","0","080,080")  // Coluna 1 - Linha 7
	MSCBSAY(_aCol[1],_aLin[8],"QTDE CAIXA : ","N","0","080,080")  // Coluna 1 - Linha 8
	MSCBSAY(_aCol[2],_aLin[8],_cqtdecx 	 ,"N","0","105,105")  // Coluna 1 - Linha 8
	MSCBEND()

   Next nX
Endif


MSCBCLOSEPRINTER()

Return