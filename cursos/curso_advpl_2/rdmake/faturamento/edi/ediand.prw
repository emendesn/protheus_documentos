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
Local _nSeqAndr := val(GetMV("MV_SEQADR"))+1
Local cArquivo	:="c:\"+DTOS(dDatabase)+STRZERO(_nSeqAndr,1)+".txt"
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

u_GerA0003(ProcName())

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
cQuery += " AND F2_TRANSP = '02' AND F2_CLIENTE = '000126' "
cQuery += " AND D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TRB1"  

nTotsRec := TRB1->(RECCOUNT())
ProcRegua(nTotsRec)               
nSeq	:= nSeq+1
//UNB - CABECALHO DE INTERCAMBIO
cLinha := "000"
cLinha += LEFT(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,35),35)
cLinha += LEFT("ANDREANI",35)
cLinha += substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(DTOS(dDatabase),3,2)
cLinha += substr(TIME(),1,2)+substr(TIME(),4,2)
cLinha += "NOT"+substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(TIME(),1,2)+substr(TIME(),4,2)+STRZERO(nSeq,1)
cLinha += SPACE(145) 
Fwrite(nHandle, cLinha  + cCrLf)	

//UNH CABECALHO DE DOCUMENTO
cLinha := "310"
cLinha += "NOTFI"+substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(TIME(),1,2)+substr(TIME(),4,2)+STRZERO(nSeq,1)
cLinha += SPACE(223) 
Fwrite(nHandle, cLinha  + cCrLf)	

//DEM - DADOS DA EMBARCADORA 
DbSelectarea("SA2")
DBSeek(xFilial("SA2")+"000757"+"01") 
	
cLinha := "311"
cLinha += LEFT(SA2->A2_CGC,14) 
cLinha += LEFT(SA2->A2_INSCR,15) 
cLinha += LEFT(SUBSTR(SA2->A2_END,1,40),40)
cLinha += LEFT(SUBSTR(SA2->A2_MUN,1,15),15) + SPACE(20)
cLinha += LEFT(substr(SA2->A2_CEP,1,5)+"-"+substr(SA2->A2_CEP,6,3),9)
cLinha += LEFT(SUBSTR(SA2->A2_EST,1,9),9)
	
cLinha += substr(DTOS(dDatabase),7,2)+substr(DTOS(dDatabase),5,2)+substr(DTOS(dDatabase),3,2)
cLinha += LEFT(SUBSTR(POSICIONE("SA4",1,XFILIAL("SA4")+"02","A4_NOME"),1,40),40)
cLinha += SPACE(67) 
Fwrite(nHandle, cLinha  + cCrLf)	

DbSelectArea("TRB1")
While !TRB1->(Eof())
	IncProc()       

	//DES - DADOS DO DESTINATARIO DA MERCADORIA
	DbSelectarea("SA1")
	DBSeek(xFilial("SA1")+TRB1->F2_CLIENTE+TRB1->F2_LOJA)
	
	cLinha := "312"
	cLinha += LEFT(SUBSTR(SA1->A1_NOME,1,40),40)
	cLinha += LEFT(SA1->A1_CGC,14) 
	cLinha += LEFT(SA1->A1_INSCR,15) 
	cLinha += LEFT(SUBSTR(SA1->A1_END,1,40),40)
	cLinha += LEFT(SUBSTR(SA1->A1_BAIRRO,1,20),20)
	cLinha += LEFT(SUBSTR(SA1->A1_MUN,1,35),35)
	cLinha += LEFT(substr(SA1->A1_CEP,1,5)+"-"+substr(SA1->A1_CEP,6,3),9)
	cLinha += SPACE(09)
	cLinha += LEFT(SUBSTR(SA1->A1_EST ,1,9),9)
	cLinha += SPACE(04) 
	cLinha += LEFT(SUBSTR(SA1->A1_DDD+SA1->A1_TEL+A1_FAX,1,35),35)
	
	IF LEN(SA1->A1_CGC) > 11
		cLinha += "1"
	ELSE
		cLinha += "2"
	ENDIF
	
	cLinha += "C"
	cLinha += SPACE(05) 
	
	Fwrite(nHandle, cLinha  + cCrLf)	
	
	DbSelectArea("TRB1")
	//DNF - DADOS DA NOTA FISCAL
	cLinha := "313"
	cLinha += LEFT(SUBSTR(TRB1->F2_NRROMA,1,15),15)
	cLinha += SPACE(07)
	cLinha += "111" //RODOVIARIO / CARGA FECHADA / FRIA
	cLinha += TRB1->F2_TPFRETE
	cLinha += TRB1->F2_SERIE
	cLinha += SUBSTR(TRB1->F2_DOC,1,8)
	cLinha += SUBSTR(TRB1->F2_EMISSAO,7,2)+substr(TRB1->F2_EMISSAO,5,2)+substr(TRB1->F2_EMISSAO,3,2)
	cLinha += LEFT(SUBSTR("ELETRONICOS",1,15),15)
	cLinha += LEFT(SUBSTR("CAIXAS",1,15),15)
	cLinha += STRZERO(1,7)
	cLinha += STRZERO(TRB1->F2_VALBRUT,15)
	cLinha += STRZERO(1,7)
	cLinha += STRZERO(1,5)
	
	IF TRB1->F2_VALICM >0
		cLinha += "S"
	ELSE 
		cLinha += "N"
	ENDIF
	
	cLinha += "N"
	cLinha += STRZERO(0,15)
	cLinha += STRZERO(0,15)
	cLinha += SPACE(08)
	cLinha += STRZERO(0,15)
	cLinha += STRZERO(0,15)
	cLinha += STRZERO(0,15)
	cLinha += STRZERO(0,15)
	cLinha += "I" //INCLUSAO VERFICAR
	cLinha += STRZERO(TRB1->F2_VALICM ,12)
	cLinha += STRZERO(TRB1->F2_ICMSRET,12)
	cLinha += "N"
	cLinha += "01" //VERIFICAR
	
	Fwrite(nHandle, cLinha  + cCrLf)
	_nValTotal 	:= _nValTotal + TRB1->F2_VALBRUT
	//MNF - MERCADORIA DA NOTA FISCAL
	DBSELECTAREA("SD2")
	dbsetorder(3)
	DBSEEK(XFILIAL("SD2")+TRB1->F2_DOC+TRB1->F2_SERIE+TRB1->F2_CLIENTE+TRB1->F2_LOJA)
	WHILE SD2->(!EOF()) .AND. SD2->D2_DOC = TRB1->F2_DOC
	
		cLinha := "314"
		cLinha += STRZERO(1,7)
		cLinha += LEFT(SUBSTR("CAIXAS",1,15),15)
		cLinha += LEFT(SUBSTR(SD2->D2_COD,1,30),30)
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
cLinha += STRZERO(_nValTotal ,15)
cLinha += STRZERO(_ncont     ,15)
cLinha += STRZERO(0          ,15)
cLinha += STRZERO(_ncont     ,15)
cLinha += STRZERO(0          ,15)
cLinha += STRZERO(0          ,15)
cLinha += SPACE(147) 
Fwrite(nHandle, cLinha  + cCrLf)
Alert("Arquivo gerado com sucesso.")
fClose(nHandle)
DbClosearea("TRB1")
GetMV("MV_SEQADR"):= STRZERO(_nSeqAndr,1)//
Return
