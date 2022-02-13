///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | TMS_Printer.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - TMS_Printer()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Este fonte demonstra a utilizacao da funcao TMSPrinter e MsBar()|//
//|           | que eh a impressao de codigo de barra.                          |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"

USER FUNCTION TMS_Printer()
LOCAL oDlg := NIL

PRIVATE cTitulo := "Impressão - Carnê de Pagamento"
PRIVATE oPrn    := NIL
PRIVATE oFont1  := NIL
PRIVATE oFont2  := NIL
PRIVATE oFont3  := NIL
PRIVATE oFont4  := NIL
PRIVATE oFont5  := NIL
PRIVATE oFont6  := NIL

DEFINE FONT oFont1 NAME "Arial" SIZE 0,07 OF oPrn
DEFINE FONT oFont2 NAME "Arial" SIZE 0,09 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,08 OF oPrn BOLD
DEFINE FONT oFont5 NAME "Arial" SIZE 0,16 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

oPrn := TMSPrinter():New(cTitulo)
oPrn:SetLandsCape()
oPrn:StartPage()
Imprimir()
oPrn:EndPage()
oPrn:End()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY "Esta rotina tem por objetivo imprimir" OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "os boletos para formar o carnê de    " OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "pagamento da dívida ativa do estado. " OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

@  6,167 BUTTON "&Imprime" SIZE 036,012 ACTION oPrn:Print()   OF oDlg PIXEL
@ 28,167 BUTTON "&Setup"   SIZE 036,012 ACTION oPrn:Setup()   OF oDlg PIXEL
@ 49,167 BUTTON "Pre&view" SIZE 036,012 ACTION oPrn:Preview() OF oDlg PIXEL
@ 70,167 BUTTON "Sai&r"    SIZE 036,012 ACTION oDlg:End()     OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

oPrn:End()

Return

STATIC FUNCTION Imprimir()
LayOutSup()
LayOutInf()
oPrn:EndPage()
oPrn:StartPage()
ReciboSup()
ReciboInf()
oPrn:EndPage()         
Ms_Flush()
Return

STATIC FUNCTION LayOutSup()
// horizontais da folha recibo, parte superior
oPrn:Line(0150,0080,0150,0790)
oPrn:Line(0260,0080,0260,0790)
oPrn:Line(0330,0080,0330,0790)
oPrn:Line(0400,0080,0400,0790)
oPrn:Line(0470,0080,0470,0790)
oPrn:Line(0540,0080,0540,0790)
oPrn:Line(0610,0080,0610,0790)
oPrn:Line(0680,0080,0680,0790)
oPrn:Line(0750,0080,0750,0790)
oPrn:Line(0820,0080,0820,0790)
oPrn:Line(0890,0080,0890,0790)
oPrn:Line(0960,0080,0960,0790)
oPrn:Line(1030,0080,1030,0790)
oPrn:Line(1100,0080,1100,0790)

// Riscos horizontais da folha ficha de compensacao, parte superior
oPrn:Line(0150,1050,0150,3330)
oPrn:Line(0260,1050,0260,3330)
oPrn:Line(0330,1050,0330,3330)
oPrn:Line(0400,1050,0400,3330)
oPrn:Line(0470,1050,0470,3330)
oPrn:Line(0820,1050,0820,3330)
oPrn:Line(0960,1050,0960,3330)

// Riscos horizontais para valores da folha ficha de compensacao, parte superior
oPrn:Line(0540,2570,0540,3330)
oPrn:Line(0610,2570,0610,3330)
oPrn:Line(0680,2570,0680,3330)
oPrn:Line(0750,2570,0750,3330)

// Risco maior na vertical da folha ficha de compensacao, parte superior
oPrn:Line(0150,2570,0821,2570)

// Riscos na vertical pequenos que dividem os campos, parte superior
oPrn:Line(0080,0430,0150,0430)
oPrn:Line(0080,0570,0150,0570)
oPrn:Line(0330,0410,0400,0410)
oPrn:Line(0470,0410,0540,0410)

oPrn:Line(0080,1450,0150,1450)
oPrn:Line(0080,1590,0150,1590)

oPrn:Line(0330,1330,0400,1330)
oPrn:Line(0330,1860,0400,1860)
oPrn:Line(0330,2060,0400,2060)
oPrn:Line(0330,2190,0400,2190)

oPrn:Line(0400,1240,0470,1240)
oPrn:Line(0400,1430,0470,1430)
oPrn:Line(0400,1590,0470,1590)
oPrn:Line(0400,2060,0435,2060)

// Texto fixo da parte superior, recibo
oPrn:Say(0080,0080,"Nossa Caixa",oFont5)
oPrn:Say(0080,0440,"Banco",oFont1)
oPrn:Say(0155,0090,"Cedente",oFont1)
oPrn:Say(0265,0090,"Sacado",oFont1)
oPrn:Say(0335,0090,"Parcela/Plano",oFont1)
oPrn:Say(0335,0420,"Vencimento",oFont1)
oPrn:Say(0405,0090,"Agência/Código Cedente",oFont1)
oPrn:Say(0475,0090,"Espécie",oFont1)
oPrn:Say(0475,0420,"Quantidade",oFont1)
oPrn:Say(0545,0090,"Nº do Documento",oFont1)
oPrn:Say(0615,0090,"Nosso Número",oFont1)
oPrn:Say(0685,0090,"(=) Valor do Documento",oFont1)
oPrn:Say(0755,0090,"(-) Desconto/Abatimento",oFont1)
oPrn:Say(0825,0090,"(-) Outras Deduções",oFont1)
oPrn:Say(0895,0090,"(+) Mora/Multa",oFont1)
oPrn:Say(0965,0090,"(+) Outros Acréscimo",oFont1)
oPrn:Say(1035,0090,"(=) Valor Cobrado",oFont1)
oPrn:SayBitmap(0405,0800,"AUTENTIC.BMP",30,310)

// Texto fixo da parte superior, compensacao
oPrn:Say(0080,1050,"Nossa Caixa",oFont5)
oPrn:Say(0080,1460,"Banco",oFont1)
oPrn:Say(0155,1060,"Local de Pagamento",oFont1)
oPrn:Say(0155,2580,"Vencimento",oFont1)
oPrn:Say(0265,1060,"Cedente",oFont1)
oPrn:Say(0265,2580,"Agência/Código Cedente",oFont1)
oPrn:Say(0335,1060,"Data Documento",oFont1)
oPrn:Say(0335,1340,"Nº do Documento",oFont1)
oPrn:Say(0335,1870,"Espécie Doc.",oFont1)
oPrn:Say(0335,2070,"Aceite",oFont1)
oPrn:Say(0335,2200,"Data Processamento",oFont1)
oPrn:Say(0335,2580,"Nosso Número",oFont1)
oPrn:Say(0405,1060,"Uso do Banco",oFont1)
oPrn:Say(0405,1250,"Carteira",oFont1)
oPrn:Say(0405,1440,"Espécie",oFont1)
oPrn:Say(0405,1600,"Quantidade",oFont1)
oPrn:Say(0440,2050,"X",oFont4)
oPrn:Say(0405,2100,"Valor",oFont1)
oPrn:Say(0405,2580,"(=) Valor do Documento",oFont1)
oPrn:Say(0475,1060,"Instruções (Texto de Responsabilidade do Cedente)",oFont1)
oPrn:Say(0475,2580,"(-) Desconto/Abatimento",oFont1)
oPrn:Say(0545,2580,"(-) Outras Deduções",oFont1)
oPrn:Say(0615,2580,"(+) Mora/Multa",oFont1)
oPrn:Say(0685,2580,"(+) Outros Acréscimo",oFont1)
oPrn:Say(0755,2580,"(=) Valor Cobrado",oFont1)
oPrn:Say(0825,1060,"Sacado",oFont1)
oPrn:Say(0930,1060,"Sacador/Avalista",oFont1)
oPrn:Say(0930,2580,"Código de Baixa",oFont1)
oPrn:Say(0965,2400,"Autênticação Mecânica",oFont1)
oPrn:Say(0965,2970,"Ficha de Compensação",oFont2)

// Texto variado do recibo, parte superior
oPrn:Say(0120,0450,"151-1",oFont4)
oPrn:Say(0200,0090,Trim(SM0->M0_NOME),oFont4)
oPrn:Say(0230,0090,Trim(SM0->M0_NOMECOM),oFont4)
oPrn:Say(0300,0090,"JOSE DA SILVA",oFont4)
oPrn:Say(0370,0250,"1/10",oFont4)
oPrn:Say(0370,0550,"29/01/2003",oFont4)
oPrn:Say(0440,0400,"0573-8 13 0000115-7",oFont4)
oPrn:Say(0510,0250,"UFESP",oFont4)
oPrn:Say(0510,0550,"10",oFont4)
oPrn:Say(0580,0400,"001845-02",oFont4)
oPrn:Say(0650,0400,"990184501-8",oFont4)
oPrn:Say(0720,0400,"R$ 105,20",oFont4)

// Texto variado da ficha de compensacao, parte superior
oPrn:Say(0080,1650,"15189.90187 45010.573306 00115.151375 3 10",oFont5)
oPrn:Say(0120,1470,"151-1",oFont4)
oPrn:Say(0200,1060,"TEXTO 1 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0230,1060,"TEXTO 2 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0215,2800,"29/01/2003",oFont4)
oPrn:Say(0300,1060,Trim(SM0->M0_NOME)+" - "+Trim(SM0->M0_NOMECOM),oFont4)
oPrn:Say(0300,2800,"0573-8 13 0000115-7",oFont4)
oPrn:Say(0370,1060,"11/12/2002",oFont4)
oPrn:Say(0370,1350,"001845-02",oFont4)
oPrn:Say(0370,1880,"NP",oFont4)
oPrn:Say(0370,2080,"S",oFont4)
oPrn:Say(0370,2210,"11/12/2002",oFont4)
oPrn:Say(0370,2800,"990184501-8",oFont4)
oPrn:Say(0440,1260,"CIDEN",oFont4)
oPrn:Say(0440,1450,"UFESP",oFont4)
oPrn:Say(0440,1670,"10",oFont4)
oPrn:Say(0440,2110,"R$ 10,52",oFont4)
oPrn:Say(0440,2800,"R$ 105,20",oFont4)
oPrn:Say(0500,1060,"- TEXTO 1 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0535,1060,"- TEXTO 2 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0570,1060,"- TEXTO 3 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0605,1060,"- TEXTO 4 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0640,1060,"- TEXTO 5 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0675,1060,"- TEXTO 6 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0710,1060,"- TEXTO 7 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0745,1060,"- TEXTO 8 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0780,1060,"- TEXTO 9 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0825,1170,"JOSE DA SILVA",oFont4)
oPrn:Say(0860,1170,"RUA PLANALTO CENTRAL, 1000 - ASA NORTE",oFont4)
oPrn:Say(0895,1170,"07121-390 - SAO PAULO - SP",oFont4)
oPrn:Say(0930,1270,Trim(SM0->M0_NOME)+" - "+Trim(SM0->M0_NOMECOM),oFont4)
MSBAR("INT25",8.9,9.4,"15189901874501057330600115151375310",oPrn,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)
Return

STATIC FUNCTION LayOutInf()
// Riscos horizontais da folha recibo, parte inferior
oPrn:Line(1390,0080,1390,0790)
oPrn:Line(1500,0080,1500,0790)
oPrn:Line(1570,0080,1570,0790)
oPrn:Line(1640,0080,1640,0790)
oPrn:Line(1710,0080,1710,0790)
oPrn:Line(1780,0080,1780,0790)
oPrn:Line(1850,0080,1850,0790)
oPrn:Line(1920,0080,1920,0790)
oPrn:Line(1990,0080,1990,0790)
oPrn:Line(2060,0080,2060,0790)
oPrn:Line(2130,0080,2130,0790)
oPrn:Line(2200,0080,2200,0790)
oPrn:Line(2270,0080,2270,0790)
oPrn:Line(2340,0080,2340,0790)

// Riscos horizontais da folha ficha de compensacao, parte inferior
oPrn:Line(1390,1050,1390,3330)
oPrn:Line(1500,1050,1500,3330)
oPrn:Line(1570,1050,1570,3330)
oPrn:Line(1640,1050,1640,3330)
oPrn:Line(1710,1050,1710,3330)
oPrn:Line(2060,1050,2060,3330)
oPrn:Line(2200,1050,2200,3330)

// Riscos horizontais para valores da folha ficha de compensacao, parte inferior
oPrn:Line(1780,2570,1780,3330)
oPrn:Line(1850,2570,1850,3330)
oPrn:Line(1920,2570,1920,3330)
oPrn:Line(1990,2570,1990,3330)

// Risco maior na vertical da folha ficha de compensacao, parte inferior
oPrn:Line(1390,2570,2060,2570)

// Riscos na vertical pequenos que dividem os campos, parte inferior
oPrn:Line(1320,0430,1390,0430)
oPrn:Line(1320,0570,1390,0570)
oPrn:Line(1570,0410,1640,0410)
oPrn:Line(1710,0410,1780,0410)

oPrn:Line(1320,1450,1390,1450)
oPrn:Line(1320,1590,1390,1590)

oPrn:Line(1570,1330,1640,1330)
oPrn:Line(1570,1860,1640,1860)
oPrn:Line(1570,2060,1640,2060)
oPrn:Line(1570,2190,1640,2190)

oPrn:Line(1640,1240,1710,1240)
oPrn:Line(1640,1430,1710,1430)
oPrn:Line(1640,1590,1710,1590)
oPrn:Line(1640,2060,1675,2060)

// Texto fixo da parte inferior, recibo
oPrn:Say(1320,0080,"Nossa Caixa",oFont5)
oPrn:Say(1320,0440,"Banco",oFont1)
oPrn:Say(1395,0090,"Cedente",oFont1)
oPrn:Say(1505,0090,"Sacado",oFont1)
oPrn:Say(1575,0090,"Parcela/Plano",oFont1)
oPrn:Say(1575,0420,"Vencimento",oFont1)
oPrn:Say(1645,0090,"Agência/Código Cedente",oFont1)
oPrn:Say(1715,0090,"Espécie",oFont1)
oPrn:Say(1715,0420,"Quantidade",oFont1)
oPrn:Say(1785,0090,"Nº do Documento",oFont1)
oPrn:Say(1855,0090,"Nosso Número",oFont1)
oPrn:Say(1925,0090,"(=) Valor do Documento",oFont1)
oPrn:Say(1995,0090,"(-) Desconto/Abatimento",oFont1)
oPrn:Say(2065,0090,"(-) Outras Deduções",oFont1)
oPrn:Say(2135,0090,"(+) Mora/Multa",oFont1)
oPrn:Say(2205,0090,"(+) Outros Acréscimo",oFont1)
oPrn:Say(2275,0090,"(=) Valor Cobrado",oFont1)
oPrn:SayBitmap(1645,0800,"AUTENTIC.BMP",30,310)

// Texto fixo da parte inferior, compensacao
oPrn:Say(1320,1050,"Nossa Caixa",oFont5)
oPrn:Say(1320,1460,"Banco",oFont1)
oPrn:Say(1395,1060,"Local de Pagamento",oFont1)
oPrn:Say(1395,2580,"Vencimento",oFont1)
oPrn:Say(1505,1060,"Cedente",oFont1)
oPrn:Say(1505,2580,"Agência/Código Cedente",oFont1)
oPrn:Say(1575,1060,"Data Documento",oFont1)
oPrn:Say(1575,1340,"Nº do Documento",oFont1)
oPrn:Say(1575,1870,"Espécie Doc.",oFont1)
oPrn:Say(1575,2070,"Aceite",oFont1)
oPrn:Say(1575,2200,"Data Processamento",oFont1)
oPrn:Say(1575,2580,"Nosso Número",oFont1)
oPrn:Say(1645,1060,"Uso do Banco",oFont1)
oPrn:Say(1645,1250,"Carteira",oFont1)
oPrn:Say(1645,1440,"Espécie",oFont1)
oPrn:Say(1645,1600,"Quantidade",oFont1)
oPrn:Say(1680,2050,"X",oFont4)
oPrn:Say(1645,2100,"Valor",oFont1)
oPrn:Say(1645,2580,"(=) Valor do Documento",oFont1)
oPrn:Say(1715,1060,"Instruções (Texto de Responsabilidade do Cedente)",oFont1)
oPrn:Say(1715,2580,"(-) Desconto/Abatimento",oFont1)
oPrn:Say(1785,2580,"(-) Outras Deduções",oFont1)
oPrn:Say(1855,2580,"(+) Mora/Multa",oFont1)
oPrn:Say(1925,2580,"(+) Outros Acréscimo",oFont1)
oPrn:Say(1995,2580,"(=) Valor Cobrado",oFont1)
oPrn:Say(2065,1060,"Sacado",oFont1)
oPrn:Say(2170,1060,"Sacador/Avalista",oFont1)
oPrn:Say(2170,2580,"Código de Baixa",oFont1)
oPrn:Say(2205,2400,"Autênticação Mecânica",oFont1)
oPrn:Say(2205,2970,"Ficha de Compensação",oFont2)

// Texto variado do recibo, parte inferior
oPrn:Say(1360,0470,"151-1",oFont4)
oPrn:Say(1440,0090,Trim(SM0->M0_NOME),oFont4)
oPrn:Say(1470,0090,Trim(SM0->M0_NOMECOM),oFont4)
oPrn:Say(1540,0090,"JOSE DA SILVA",oFont4)
oPrn:Say(1610,0250,"1/10",oFont4)
oPrn:Say(1610,0550,"29/01/2003",oFont4)
oPrn:Say(1680,0400,"0573-8 13 0000115-7",oFont4)
oPrn:Say(1750,0250,"UFESP",oFont4)
oPrn:Say(1750,0550,"10",oFont4)
oPrn:Say(1820,0400,"001845-02",oFont4)
oPrn:Say(1890,0400,"990184501-8",oFont4)
oPrn:Say(1960,0400,"R$ 105,20",oFont4)

// Texto variado da ficha de compensacao, parte inferior
oPrn:Say(1320,1650,"15189.90187 45010.573306 00115.151375 3 10",oFont5)
oPrn:Say(1360,1470,"151-1",oFont4)
oPrn:Say(1440,1060,"TEXTO 1 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1470,1060,"TEXTO 2 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1455,2800,"29/01/2003",oFont4)
oPrn:Say(1540,1060,Trim(SM0->M0_NOME)+" - "+Trim(SM0->M0_NOMECOM),oFont4)
oPrn:Say(1540,2800,"0573-8 13 0000115-7",oFont4)
oPrn:Say(1610,1060,"11/12/2002",oFont4)
oPrn:Say(1610,1350,"001845-02",oFont4)
oPrn:Say(1610,1880,"NP",oFont4)
oPrn:Say(1610,2080,"S",oFont4)
oPrn:Say(1610,2210,"11/12/2002",oFont4)
oPrn:Say(1610,2800,"990184501-8",oFont4)
oPrn:Say(1680,1260,"CIDEN",oFont4)
oPrn:Say(1680,1450,"UFESP",oFont4)
oPrn:Say(1680,1670,"10",oFont4)
oPrn:Say(1680,2110,"R$ 10,52",oFont4)
oPrn:Say(1680,2800,"R$ 105,20",oFont4)
oPrn:Say(1740,1060,"- TEXTO 1 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1775,1060,"- TEXTO 2 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1810,1060,"- TEXTO 3 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1845,1060,"- TEXTO 4 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1880,1060,"- TEXTO 5 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1915,1060,"- TEXTO 6 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1950,1060,"- TEXTO 7 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(1985,1060,"- TEXTO 8 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(2020,1060,"- TEXTO 9 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(2065,1170,"JOSE DA SILVA",oFont4)
oPrn:Say(2100,1170,"RUA PLANALTO CENTRAL, 1000 - ASA NORTE",oFont4)
oPrn:Say(2135,1170,"07121-390 - SAO PAULO - SP",oFont4)
oPrn:Say(2170,1270,Trim(SM0->M0_NOME)+" - "+Trim(SM0->M0_NOMECOM),oFont4)
MSBAR("INT25",19.3,9.4,"15189901874501057330600115151375310",oPrn,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)
Return

STATIC FUNCTION ReciboSup()
oPrn:Box(0080,1050,1101,3330)
oPrn:Say(0150,1100,"RECIBO DE ENTREGA",oFont3)
oPrn:Say(0300,1100,"Contrato número: 999999  Nome: José da Silva",oFont3)
oPrn:Say(0400,1100,"Declaro que recebi o carnê de pagamento referente ao contrato número: 999999",oFont3)
oPrn:Say(0600,1100,"SAO PAULO, 29 de janeiro de 2003",oFont3)
oPrn:Say(0900,1100,"Assinatura:",oFont3)
Return

STATIC FUNCTION ReciboInf()
oPrn:Box(1320,1050,2341,3330)
oPrn:Say(1390,1100,"RECIBO DE ENTREGA",oFont3)
oPrn:Say(1540,1100,"Contrato número: 999999  Nome: José da Silva",oFont3)
oPrn:Say(1640,1100,"Declaro que recebi o carnê de pagamento referente ao contrato número: 999999",oFont3)
oPrn:Say(1840,1100,"SAO PAULO, 29 de janeiro de 2003",oFont3)
oPrn:Say(2140,1100,"Assinatura:",oFont3)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±± 
±±³          ³ 				EAN13,EAN8,UPCA ,SUP5,CODE128                  ³±±
±±³          ³ 				INT25,MAT25,IND25,CODABAR,CODE3_9              ³±±
±±³          ³ 02 nRow		Numero da Linha em centimentros                ³±±
±±³          ³ 03 nCol		Numero da coluna em centimentros				     ³±±
±±³          ³ 04 cCode		String com o conteudo do codigo                ³±±
±±³          ³ 05 oPr		Obejcto Printer                                ³±±
±±³          ³ 06 lcheck	Se calcula o digito de controle                ³±±
±±³          ³ 07 Cor 		Numero  da Cor, utilize a "common.ch"          ³±±
±±³          ³ 08 lHort		Se imprime na Horizontal                       ³±±
±±³          ³ 09 nWidth	Numero do Tamanho da barra em centimetros      ³±±
±±³          ³ 10 nHeigth	Numero da Altura da barra em milimetros        ³±±
±±³          ³ 11 lBanner	Se imprime o linha em baixo do codigo          ³±±
±±³          ³ 12 cFont		String com o tipo de fonte                     ³±±
±±³          ³ 13 cMode		String com o modo do codigo de barras CODE128  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/