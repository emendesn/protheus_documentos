#include "rwmake.ch"
#include "ap5mail.ch"

/*
+-----------+------------+-------+---------------------+------+----------+
| Função    |WFW120P     | Autor | Ashraf / Crislei    | Data | 06/08/03 |
+-----------+------------+-------+---------------------+------+----------+
|Descrição  | Envia e-mail com Especificacoes tecnicas do produto para   |
|           | fornecedor                                                 |
+-----------+------------------------------------------------------------+
|Parametros | MV_WFACC, MV_WFMAIL, MV_WFPASSW, MV_WFSMTP                 | 
+-----------+------------------------------------------------------------+
| Uso       | Pedido de Compras                                          |
+-----------+------------------------------------------------------------+
|           ALTERACOES REALIZADAS DESDE A CRIACAO                        |
+-----------+---------+--------------------------------------------------+
|Programador| Data    | Descricao                                        |
|-----------+---------+--------------------------------------------------+
|           |         |                                                  |
|-----------+---------+--------------------------------------------------+

*/

User Function WFW120P()

Local aArqAnte  := {Alias(),IndexOrd(),Recno()}
Local cNumePedi := PARAMIXB //Filial+Num. Pedido
Local cCodiForn := ""
Local cContato  := ""
Local cFiliEntr := ""
Local cCondPag  := ""
Local cItens    := ""
Local cTabela   := ""
Local cFiles    := ""
Local cFimPed   := ""
Local dDataEmis := CTOD("")
Local nValrUnit := 0
Local nValrTota := 0
Local nDesc1    := 0
Local nDesc2    := 0
Local nDesc3    := 0
Local nDescProd := 0
Local nLinObs   := 0
Local nTotal    := 0
Local aItens    := {}
Local aFiles    := {}

Local nTotIpi	:= MaFisRet(,'NF_VALIPI')
Local nTotIcms	:= MaFisRet(,'NF_VALICM')
Local nTotDesp	:= MaFisRet(,'NF_DESPESA')
Local nTotFrete	:= MaFisRet(,'NF_FRETE')
Local nTotalNF	:= MaFisRet(,'NF_TOTAL')
Local nTotSeguro:= MaFisRet(,'NF_SEGURO')
Local aValIVA   := MaFisRet(,"NF_VALIMP")

//Estes parametros deverao ser configuranca
Local cAccount  := GetMv("MV_WFACC") 
Local cCtaMail  := GetMv("MV_WFMAIL")
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP")


dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(cNumePedi)

While !Eof() .And. ;
      xFilial("SC7")+SC7->C7_NUM == cNumePedi
   
   cObs01 := " "
   cObs02 := " "
   cObs03 := " "
   cObs04 := " "
   
   //Localiza produto
   dbSelectArea("SB1")
   dbSetOrder(1)
   dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
   
   cCodiForn := SC7->C7_FORNECE+SC7->C7_LOJA
   cContato  := SC7->C7_CONTATO
   cFiliEntr := SC7->C7_FILENT   
   nValrUnit := xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,SC7->C7_MOEDA,SC7->C7_DATPRF)
   nValrTota := xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,SC7->C7_MOEDA,SC7->C7_DATPRF)
   nDesc1    := SC7->C7_DESC1
   nDesc2    := SC7->C7_DESC2
   nDesc3    := SC7->C7_DESC3

   AADD(aItens,{SC7->C7_ITEM, ;
                SC7->C7_PRODUTO, ;
                SC7->C7_DESCRI,  ;
                SC7->C7_UM,      ; 
                SC7->C7_QUANT,   ;
                nValrUnit,       ;
                SC7->C7_IPI,     ;
                nValrTota,       ;
                SC7->C7_DATPRF,  ;
                IIf(Empty(SB1->B1_DOCESP),"Nao","Sim")})
   
   //Atachando arquivos de especificações do produto
   AADD(aFiles,AllTrim(SB1->B1_DOCESP))
     
   //Calcula desconto do pedido
   If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
      nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
   Else
 	  nDescProd+=SC7->C7_VLDESC
   Endif
   
   
   If !EMPTY(SC7->C7_OBS) .And. nLinObs < 5
      nLinObs++
	  cVar:="cObs"+StrZero(nLinObs,2)
	  Eval(MemVarBlock(cVar),SC7->C7_OBS)
   Endif
         
   cCondPag   := SC7->C7_COND  
   dDataEmis  := SC7->C7_EMISSAO   
   nTotal     += SC7->C7_TOTAL
   nReajuste  := SC7->C7_REAJUST
   nMoeda     := SC7->C7_MOEDA
   dDataPrf   := SC7->C7_DATPRF
   cTipoFrete := IIf( SC7->C7_TPFRETE $ "F","FOB",IIF(SC7->C7_TPFRETE $ "C","CIF"," " ))
   
   dbSelectArea("SC7")
   dbSkip()
End 

nTotMerc := MaFisRet(,"NF_TOTAL")
nTotMerc := xMoeda(nTotMerc,nMoeda,nMoeda,dDataPrf)
nTotal   := xMoeda(nTotal,nMoeda,nMoeda,dDataPrf)

For nxI := 1 To Len(aItens)
    cItens += "<tr>"
   	cItens += "<td width='08%'><font size='2' face='Arial'>" + aItens[nxI,01] + "</td>" 
   	cItens += "<td width='08%'><font size='2' face='Arial'><p align='center'>" + aItens[nxI,02] + "</td>" 
   	cItens += "<td width='20%'><font size='2' face='Arial'>" + aItens[nxI,03] + "</td>" 
   	cItens += "<td width='04%'><font size='2' face='Arial'><p align='center'>" + aItens[nxI,04] + "</td>" 
   	cItens += "<td width='08%'><font size='2' face='Arial'><p align='right' >" + Transform(aItens[nxI,05],"999.99") + "</td>"
   	cItens += "<td width='12%'><font size='2' face='Arial'><p align='right' >" + Transform(aItens[nxI,06],"@E 99,999,999.99") + "</td>"
   	cItens += "<td width='05%'><font size='2' face='Arial'><p align='right' >" + Transform(aItens[nxI,07],"999.99") + "</td>"
   	cItens += "<td width='15%'><font size='2' face='Arial'><p align='right' >" + Transform(aItens[nxI,08],"@E 99,999,999.99") + "</td>"
   	cItens += "<td width='10%'><font size='2' face='Arial'><p align='center'>" + DTOC(aItens[nxI,09]) + "</td>"
   	cItens += "<td width='10%'><font size='2' face='Arial'><p align='center'>" + aItens[nxI,10] + "</td>"
    cItens += "</tr>"
Next nxI

//Tratamento para impressao das observacoes
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs := cObs01
		cObs01 := Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf


//monta a tabela onde serao apresentados os itens do pedido
cTabela := "<table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='090%' id='AutoNumber1'> "
cTabela += " <tr>"
cTabela += "   <td width='08%' bgcolor='#333399'> "
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>Item</b></font></td>"
cTabela += "   <td width='08%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>Código</b></font></td>"
cTabela += "   <td width='20%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>Descricao </b></font></td>"
cTabela += "   <td width='04%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>UM</b></font></td>"
cTabela += "   <td width='08%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>Quant.</b></font></td>"
cTabela += "   <td width='12%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>Valor Unitário</b></font></td>"
cTabela += "   <td width='05%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>IPI </b></font></td>"
cTabela += "   <td width='15%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>Valor Total</b></font></td>"
cTabela += "   <td width='10%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>Entrega</b></font></td>"
cTabela += "   <td width='10%' bgcolor='#333399'>"
cTabela += "   <p align='center'><font color='#FFFFFF' size='2' face='Arial'><b>Critico </b></font></td>"
cTabela += "  </tr>"
cTabela += cItens
cTabela += "</table>"

//Posiciona Cadastro de Condicao de Pagamento
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+cCondPag)

cFimPed += "<table border='0' cellpadding='0' cellspacing='0' border-width: 0 width='90%' id='AutoNumber1'>"
cFimPed += "<tr>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Condicao de Pagamento:</b></font></td>"
cFimPed += "<td width='20%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + SubStr(SE4->E4_DESCRI,1,34) + "</font></td>"
cFimPed += "<td width='05%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='center' >&nbsp</font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Data de Emissao:</b></font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + DTOC(dDataEmis) + "</font></td>"
cFimPed += "</tr>"
cFimPed += "<tr>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Total das Mercadorias:</b></font></td>"
cFimPed += "<td width='20%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + Transform(nTotal,"@E 999,999,999.99") + "</font></td>"
cFimPed += "<td width='05%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='center' >&nbsp</font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Total com Impostos:</b></font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + Transform(nTotMerc,"@E 999,999,999.99") + "</font></td>"
cFimPed += "</tr>"
cFimPed += "<tr>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>IPI:</b></font></td>"
cFimPed += "<td width='20%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + Transform(xMoeda(nTotIcms,nMoeda,nMoeda,dDataPrf),"@E 99,999.99") + "</font></td>"
cFimPed += "<td width='05%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='center' >&nbsp</font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>ICMS:</b></font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + Transform(xMoeda(nTotIcms,nMoeda,nMoeda,dDataPrf),"@E 99,999.99") + "</font></td>"
cFimPed += "</tr>"
cFimPed += "<tr>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Frete:</b></font></td>"
cFimPed += "<td width='20%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + Transform(xMoeda(nTotFrete,nMoeda,nMoeda,dDataPrf),"@E 99,999.99") + "</font></td>"
cFimPed += "<td width='05%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='center' >&nbsp</font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Despesas:</b></font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + Transform(xMoeda(nTotDesp,nMoeda,nMoeda,dDataPrf),"@E 99,999.99") + "</font></td>"
cFimPed += "</tr>"
cFimPed += "<tr>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Grupo:</b></font></td>"
cFimPed += "<td width='20%' style='border-style: none; border-width: medium'><font face='Arial' size='2'>&nbsp;</font></td>"
cFimPed += "<td width='05%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='center' >&nbsp</font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Seguro:</b></font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + Transform(xMoeda(nTotSeguro,nMoeda,nMoeda,dDataPrf),"@E 99,999.99") + "</font></td>"
cFimPed += "</tr>"
cFimPed += "<tr>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Total Geral:</b></font></td>"
cFimPed += "<td width='20%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + Transform(xMoeda(nTotalNF,nMoeda,nMoeda,dDataPrf),"@E 999,999,999.99") + "</font></td>"
cFimPed += "<td width='05%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='center' >&nbsp</font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><b>Obs. do Frete:</b></font></td>"
cFimPed += "<td width='25%' style='border-style: none; border-width: medium'><font face='Arial' size='2'><p align='right' >" + cTipoFrete + "</font></td>"
cFimPed += "</tr>"
cFimPed += "</table>"

//Adiciona a cFiles a forma correta para passar para a clausula ATTACHMENT
For nxI := 1 To Len(aFiles)
    If nxI == Len(aFiles)
	   cFiles += aFiles[nxI]
    Else
       cFiles += aFiles[nxI] + ","
    EndIf
Next nxI

//Posiciona Cadastro de Fornecedor
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+cCodiForn)

//Conecta com o servidor de envio
//CONNECT SMTP SERVER "200.213.197.160" ACCOUNT "compras@agrofruit.com.br" PASSWORD "agrocompras123" 
//SEND MAIL FROM "compras@agrofruit.com.br" to  SA2->A2_EMAIL  ; 
CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
SEND MAIL FROM cCtaMail to  SA2->A2_EMAIL  ; 
SUBJECT "PEDIDO DE COMPRA" ;
BODY ;
"<p align='center'><font face= 'Arial' size='2'><b>PEDIDO DE COMPRAS - " + SubStr(cNumePedi,3,6) + "</b></font></p> <br>"  + ;
"<p><font face= 'Arial' size='2'><b>COMPRADOR:</b><br>" + SM0->M0_NOMECOM + "<br>" + SM0->M0_ENDENT + "<br>" + ;
"CEP: " + SM0->M0_CEPENT + " - " + Trim(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT + "<br>" + ;
"TEL: " + SM0->M0_TEL + "FAX: " + SM0->M0_FAX + "<br>" + ;
"CNPJ/CPF: " + SM0->M0_CGC + " - " + InscrEst() + "<br>" + ;
"<b>Local de Entrega :</b> " + SM0->M0_ENDENT + " " + SM0->M0_CIDENT + " " + SM0->M0_ESTENT + " CEP: " + SM0->M0_CEPENT + "<br>" + ;
"<b>Local de Cobranca:</b> " + SM0->M0_ENDCOB + " " + SM0->M0_CIDCOB + " " + SM0->M0_ESTCOB + " CEP: " + SM0->M0_CEPCOB + "<br><br>" + ;
"<b>FORNECEDOR:</b><br>" + Substr(SA2->A2_NOME,1,35)+"-"+SA2->A2_COD+"-"+SA2->A2_LOJA+" I.E.: " + SA2->A2_INSCR + "<br>" + ;
Trim(SA2->A2_END) + " - " + Trim(SA2->A2_BAIRRO) + "<br>" + ;
Trim(SA2->A2_MUN) + " - " + SA2->A2_EST + " - " + "CEP: " + SA2->A2_CEP + " CNPJ/CPF: " + SA2->A2_CGC + "<br>" + ;
cContato + "TEL.: " + Substr(SA2->A2_TEL,1,15) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FAX: " + Substr(SA2->A2_FAX,1,15)  + "</font></p><br><br>" + ;
cTabela + "<br><br>" + ;
"<p><font face='Arial' size='2'><b>Descontos --> </b>" + Transform(nDesc1,"@E 9,999.99") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + Transform(nDesc2,"@E 9,999.99") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + Transform(nDesc3,"@E 9,999.99") + "<br>" + ;
cFimPed + "<br>" + ;
"<p><font face='Arial' size='2'><b>Observações:</b> <br> " + cObs01 + "<br>" + cObs02 + "<br>" + cObs03 + "<br>" + cObs04 + "</font></p><br>" + ;
"<p><font face='Arial' size='3' color='RED'><b>FAVOR ENVIAR LAUDO TECNICO PARA OS ITENS CRITICOS</b></font></p>" ;
ATTACHMENT cFiles
                                                                                      
DISCONNECT SMTP SERVER

dbSelectArea(aArqAnte[01])
dbSetOrder(aArqAnte[02])
dbGoTo(aArqAnte[03])

Return