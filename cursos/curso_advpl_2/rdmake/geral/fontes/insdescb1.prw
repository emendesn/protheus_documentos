#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#INCLUDE "topconn.ch" 
#include "tbiconn.ch"
#define LFRC CHR(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INDESCB1  º Autor ³ Edson Rodrigues    º Data ³  JAN /13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para descrição memo no cadastro de produto        º±±
±±º          ³  planilha do usuário importada para o banco de dados SQL   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User function INDESCB1()
 

u_GerA0003(ProcName())

// PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "SB1","SYP"

aVetor := {}
cquery := ""


cquery := " SELECT "
cquery += " LEN(RTRIM(DescriptionINGLES)) tamingles, "
cquery += " LEN(RTRIM(Descricaoportugues)) tamportugues, "
cquery += " LEN(RTRIM(DescricaoDI)) TamGI," 
cquery += " B1_COD,B1_DESC_P,B1_DESC_GI,B1_DESC_I,B.* FROM SB1020 INNER JOIN  "
cquery += " (SELECT * FROM [PROTHEUS].dbo.TRADITENS ) AS B "
cquery += " ON ItemNumber=B1_COD "
cquery += " WHERE B1_DESC_I ='' AND B1_DESC_GI='' AND B1_DESC_P='' "
cquery += " order by B1_COD "

if Select("TRD") > 0
	TRAD->(dbCloseArea())
endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cquery),"TRAD",.T.,.T.)


TRAD->(dbGoTop())
While TRAD->(!eof()) 
     lMsErroAuto := .F.
		/*
		aVetor:= {{"B1_COD"     ,"999999999999999",Nil},;
		 				 {"B1_CODITE"  ,"999999999999999999999999999",Nil},;
		 				 {"B1_DESC"    ,"Teste"        ,Nil},;
						 {"B1_TIPO"    ,"PA"           ,Nil},; 
						 {"B1_UM"      ,"UN"           ,Nil},; 
						 {"B1_LOCPAD"  ,"01"           ,Nil},; 
						 {"B1_PICM"    ,0              ,Nil},; 
						 {"B1_IPI"     ,0              ,Nil},; 
						 {"B1_PRV1"    ,100            ,Nil},; 
						 {"B1_TIPOCQ"  ,"M"            ,Nil},; 
						 {"B1_CONTRAT" ,"N"            ,Nil},; 
						 {"B1_LOCALIZ" ,"N"            ,Nil},; 
						 {"B1_CODBAR"  ,'123456'       ,Nil},; 
						 {"B1_IRRF"    ,"N"            ,Nil},; 
						 {"B1_CONTSOC" ,"N"            ,Nil},; 
						 {"B1_MRP"     ,"N"            ,Nil}} 
		MSExecAuto({|x,y| Mata010(x,y)},aVetor,3) //Inclusao
		*/
		
		
		
		aVetor:= {{"B1_COD"     ,TRAD->B1_COD,Nil},;             
				  {"B1_VM_I"  ,ALLTRIM(TRAD->DescriptionINGLES),Nil},;
				  {"B1_VM_GI"  ,ALLTRIM(TRAD->DescricaoDI),Nil},;
 				  {"B1_VM_P"  ,ALLTRIM(TRAD->Descricaoportugues),Nil}} 

		MSExecAuto({|x,y| Mata010(x,y)},aVetor,4) //Alteracao
		
		/*
		aVetor:= {{"B1_COD"     ,"999999999999999",Nil}}
		MSExecAuto({|x,y| Mata010(x,y)},aVetor,5) //Exclusao
		*/
		
		
		If lMsErroAuto
			MostraErro()
		Else
			//Alert("Ok")
		Endif       
		
   TRAD->(Dbskip())		

enddo		


return()                                


