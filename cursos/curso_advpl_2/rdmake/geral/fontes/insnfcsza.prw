#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#INCLUDE "topconn.ch"
#include "tbiconn.ch"

#define LFRC CHR(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INSNFCSZA º Autor ³ Edson Rodrigues    º Data ³  JUNH /10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Prgrama para incuir dados no SZA conforme planilha usuário º±±
±±º          ³ importada para o banco de dados SQL                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User function INSNFCSZA()

u_GerA0003(ProcName())

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "ZZ4","SZA","QRY"
lnumser  :=.f.
lSZA  :=.f.
cgaran:=""
_CQRY :=""                                    
QRY := ""
//nrecno:=1545462
nrecno:=1650592
Private aAlias  := {"SZA","ZZ4"}

//dbSelectArea("SZA")
//SZA->(dbSetOrder(1)) // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI

If select("QRY") > 0
   QRY->(dbclosearea())
Endif                          

_CQRY := " SELECT OS,IMEI,TRANS,DTFABRIC,DTCOMPRA,CONVERT(VARCHAR(8),DTCOMPRA,112) AS DTCORRETA,NF,[15A20],ZZ4_FILIAL,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFENR,ZZ4_NFESER,ZZ4_NFEDT,ZZ4_EMDT,ZZ4_IMEI,ZZ4_LOCAL, "
_CQRY += " ZZ4_CODPRO,ZZ4_VLRUNI,'V',ZZ4_CODPRO,ZA_FILIAL,ZA_CLIENTE,ZA_LOJA,ZA_NFISCAL,ZA_SERIE,ZA_CODPRO,RECSZA "
_CQRY += " FROM REJECT3 " 
_CQRY += "      INNER JOIN (SELECT ZZ4_FILIAL,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFENR,ZZ4_NFESER,ZZ4_NFEDT,ZZ4_EMDT,ZZ4_IMEI,ZZ4_CODPRO,ZZ4_VLRUNI,ZZ4_OS,ZZ4_LOCAL FROM ZZ4020 WHERE ZZ4_FILIAL='02'AND D_E_L_E_T_='') AS ZZ4 "
_CQRY += "      ON OS=ZZ4_OS "
_CQRY += "      LEFT OUTER JOIN (SELECT ZA_IMEI,ZA_FILIAL,ZA_CLIENTE,ZA_LOJA,ZA_NFISCAL,ZA_SERIE,ZA_CODPRO,R_E_C_N_O_ AS RECSZA FROM SZA020 WHERE D_E_L_E_T_='' AND ZA_STATUS='V')  AS SZA "
_CQRY += "      ON ZA_FILIAL=ZZ4_FILIAL AND IMEI=ZA_IMEI  "
_CQRY += "      WHERE ZA_NFISCAL IS NULL AND (DTCOMPRA<>'' OR DTCOMPRA IS NOT NULL) "

 TCQUERY _CQRY NEW ALIAS "QRY"

 TcSetField("QRY", "ZZ4_NFEDT","D")
 TcSetField("QRY", "DTCORRETA","D")

_aAreaSZA := SZA->(getarea())
SZA->(dbSetOrder(4)) // ZA_FILIAL + ZA_IMEI + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_STATUS

QRY->(dbgotop())

While !QRY->(eof())  
		//		if SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par04 + mv_par05))
		//IF !SZA->(dbSeek(xFilial("SZA") + QRY->ZZ4_FILIAL + QRY->ZZ4_CODCLI + QRY->ZZ4_LOJA + QRY->ZZ4_NFENR + QRY->ZZ4_NFESER + QRY->ZZ4_IMEI))              
		//IF !SZA->(dbSeek(xFilial("SZA") + left(QRY->ZZ4_IMEI,15) + QRY->ZZ4_CODCLI + QRY->ZZ4_LOJA + QRY->ZZ4_NFENR))
		IF !SZA->(dbSeek(xFilial("SZA") + QRY->ZZ4_IMEI + QRY->ZZ4_CODCLI + QRY->ZZ4_LOJA + QRY->ZZ4_NFENR))
		    reclock("SZA",.t.)
		     SZA->ZA_FILIAL  := xFilial("SZA")
		     SZA->ZA_CLIENTE := QRY->ZZ4_CODCLI
		     SZA->ZA_LOJA    := QRY->ZZ4_LOJA
		     SZA->ZA_NFISCAL := QRY->ZZ4_NFENR
		     SZA->ZA_SERIE   := QRY->ZZ4_NFESER
		     SZA->ZA_EMISSAO := QRY->ZZ4_NFEDT
		     SZA->ZA_CODPRO  := QRY->ZZ4_CODPRO
		     SZA->ZA_PRECO   := QRY->ZZ4_VLRUNI
		     SZA->ZA_DATA    := dDataBase
		     SZA->ZA_IMEI    := QRY->ZZ4_IMEI
		     SZA->ZA_STATUS  := "V"
		     SZA->ZA_LOCAL   := QRY->ZZ4_LOCAL
		     SZA->ZA_NFCOMPR := QRY->NF
		     SZA->ZA_DTNFCOM := QRY->DTCORRETA
		     SZA->ZA_CODRECL := ''
		     SZA->ZA_CODAUTO := ''
		     SZA->ZA_CODTRAN := ''
		     SZA->ZA_TRACKIN := ''
		     SZA->ZA_OSAUTOR := ''
		     SZA->ZA_INFACES := ''
		     SZA->ZA_CTRLACR := ''
		     SZA->ZA_CPFCLI  := ''
		     SZA->ZA_CNPJNFC := ''
		     SZA->ZA_SERNFC  := ''
		     SZA->ZA_NOMUSER := "X"+alltrim(cUserName) + "-" + dtoc(dDataBase) + "-" + time()
		    msunlock()
        ENDIF
      QRY->(dbskip())  
enddo

Return
