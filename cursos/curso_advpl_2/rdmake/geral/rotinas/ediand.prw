#INCLUDE "RWMAKE.CH"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDIAND    บAutor  ณGRAZIELLA BIANCHIN  บ Data ณ  01/30/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCADASTRO DAS OCORRENCIAS DA TRANSPORTADORA ANDREANI         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ USO EXCLUSIVO BGH                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function _CadOcor()

AxCadastro("ZZV","Cadastro de Ocorrencias EDI - Andreoni")

Return 


User Function _ArqAdr() 

Local cQuery 	:=""
Local cDirDocs	:=__reldir            
Local cCrLf		:=Chr(13)+Chr(10)
Local cArquivo	:="c:\"+DTOS(dDatabase)+ALLTRIM(GetMV("MV_SEQADR"))+".txt"
Local _csrvapl  := ALLTRIM(GetMV("MV_SERVAPL"))
Local nLin 		:= 0
Local nMax 		:= 0
Local nSeq		:= 0 
Local aDiverge 	:= {}
Local nAt 		:= 0
Local lDiverge 	:= .f.
Local ndigito  	:= 0     
Local aSaveArea := GetArea()   
Local _nValTotal:= 0  
Local _ncont	:= 0 
Private cPerg	 :="ARQADR"   

if !Pergunte(cPerg,.T.)
	Return()
Endif

nHandle := MsfCreate(cArquivo,0)

IF Select("TRB1") <> 0 
	DbSelectArea("TRB1")
	DbCloseArea()
Endif    

cQuery := " SELECT * " 
cQuery += " FROM " + RetSqlName("SF2") + " "
cQuery += " WHERE "
cQuery += " F2_EMISSAO >= '" + DTOS(MV_PAR01) + "' "
cQuery += " AND F2_EMISSAO <= '" + DTOS(MV_PAR02) + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TRB1"  

nTotsRec := TRB1->(RECCOUNT())
ProcRegua(nTotsRec)               
nSeq	:= nSeq+1
//UNB - CABECALHO DE INTERCAMBIO
cLinha := "000"
cLinha += SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,35)
cLinha += "ANDREANI"+SPACE(31)
cLinha += DTOS(dDatabase)+TIME()
cLinha += "NOT"+DTOS(dDatabase)+TIME()+STRZERO(nSeq,1)+SPACE(145) 
Fwrite(nHandle, cLinha  + cCrLf)	

While !TRB1->(Eof())
	IncProc()       
	//UNH CABECALHO DE DOCUMENTO
	cLinha := "310"
	cLinha += "NOTFI"+SUBSTR(DTOS(dDatabase),5,2)+SUBSTR(DTOS(dDatabase),7,2)+substr(TIME(),1,2)+substr(TIME(),4,2)+STRZERO(nSeq,1)
	cLinha += SPACE(223) 
	Fwrite(nHandle, cLinha  + cCrLf)	
	//DEM - DADOS DA EMBARCADORA 
	DbSelectarea("SA2")
	DBSeek(xFilial("SA2")+"000757"+"01")
	cLinha := "311"+SA2->A2_CGC + LEFT(SA2->A2_INSCR,15) + SUBSTR(SA2->A2_END,1,40) + SUBSTR(SA2->A2_MUN,1,35) + SA2->A2_CEP + SA2->A2_EST 
	DbSelectArea("TRB1")
	cLinha += TRB1->F2_SAIROMA+SUBSTR(POSICIONE("SA4",1,XFILIAL("SA4")+TRB1->F2_TRANSP,"A4_NOME"),1,40)
	cLinha += SPACE(67) 
	Fwrite(nHandle, cLinha  + cCrLf)	
	//DES - DADOS DO DESTINATARIO DA MERCADORIA
	DbSelectarea("SA1")
	DBSeek(xFilial("SA1")+TRB1->F2_CLIENTE+TRB1->F2_LOJA)
	cLinha := "312"+SUBSTR(SA1->A1_NOME,1,40)+	SA1->A1_CGC + LEFT(SA1->A1_INSCR,15) + SUBSTR(SA1->A1_END,1,40) + SUBSTR(SA1->A1_BAIRRO,1,20)
	cLinha += SUBSTR(SA1->A1_MUN,1,35) + SA1->A1_CEP + SA1->A1_COD_MUN + SA1->A1_EST + SPACE(04) + SUBSTR(SA1->A1_DDD+SA1->A1_TEL+A1_FAX,1,35)
	IF LEN(SA1->A1_CGC) > 11
		cLinha += "1"
	ELSE
		cLinha += "2"
	ENDIF
	cLinha += SA1->A1_TIPO+SPACE(05) 
	Fwrite(nHandle, cLinha  + cCrLf)	
	DbSelectArea("TRB1")
	//DNF - DADOS DA NOTA FISCAL
	cLinha := "313"+TRB1->F2_NRROMA+SPACE(07)+"1"+"1"+"1"+TRB1->F2_TPFRETE+TRB1->F2_SERIE+SUBSTR(TRB1->F2_DOC,1,8)+TRB1->F2_EMISSAO
	cLinha += SUBSTR("ELETRONICOS",1,15)+SUBSTR("CAIXAS",1,15)+"1"+TRANSFORM(TRB1->F2_VALBRUT,'@E 9,999,999,999.99')+"001,00"+"1,00"
	IF TRB1->F2_VALICM >0
		cLinha += "S"
	ELSE 
		cLinha += "N"
	ENDIF
	cLinha += "N"+REPLICATE("0",13)+","+"00"+REPLICATE("0",13)+","+"00"+SPACE(08)+REPLICATE("0",13)+","+"00"
	cLinha += "I" //INCLUSAO VERFICAR
	cLinha += TRANSFORM(TRB1->F2_VALICM ,'@E 99,999,999.99')
	cLinha += TRANSFORM(TRB1->F2_ICMSRET,'@E 99,999,999.99')	
	cLinha += "N"+"01"
	
	Fwrite(nHandle, cLinha  + cCrLf)
	_nValTotal 	:= _nValTotal + TRB1->F2_VALBRUT
	//MNF - MERCADORIA DA NOTA FISCAL
	DBSELECTAREA("SD2")
	dbsetorder(3)
	DBSEEK(XFILIAL("SD2")+TRB1->F2_DOC+TRB1->F2_SERIE+TRB1->F2_CLIENTE+TRB1->F2_LOJA)
	WHILE SD2->(!EOF()) .AND. SD2->D2_DOC = TRB1->F2_DOC
		cLinha := "314"+LEFT("1,00",7)+"CAIXAS"
		cLinha += SUBSTR(SD2->D2_COD,1,30)+TRANSFORM(SD2->D2_QUANT,'@E 99,999.99')+"CAIXAS"
		Fwrite(nHandle, cLinha  + cCrLf)
		SD2->(DBSKIP())
	ENDDO
	
	cLinha += SPACE(29) 
	
	_ncont 		:= _ncont + 1
	Fwrite(nHandle, cLinha  + cCrLf)
	TRB1->(DbSkip())
EndDo
//TOT - VALORES TOTAIS DOS DOCUMENTOS
cLinha := "318" 
cLinha += TRANSFORM(_nValTotal ,'@E 99,999,999,999.99')
cLinha += TRANSFORM(_ncont     ,'@E 99,999,999,999.99')
cLinha += replicate("0",13)+",00"
cLinha += TRANSFORM(_ncont     ,'@E 99,999,999,999.99')
cLinha += replicate("0",13)+",00"
cLinha += replicate("0",13)+",00"
cLinha += SPACE(147) 
Fwrite(nHandle, cLinha  + cCrLf)
Alert("Arquivo gerado com sucesso.")
fClose(nHandle)
DbClosearea("TRB1")
MV_SEQADR := STRZERO(Val(MV_SEQADR)+1,3)//
Return
