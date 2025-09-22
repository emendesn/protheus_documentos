#INCLUDE "FIVEWIN.CH"
Function Testeg()
Local oDlg  
Local oNumPed,oNumPedCom
Local oCHProd,oCHPedCom,oCHNotEnt
Local lCHProd:=lCHProd:=lCHPedCom:=lCHNotEnt:=.t.
Private lMsHelpAuto := .t.
Private lMsErroAuto := .f.
PRIVATE cNumPed:=CriaVar("C5_NUM",.T.)
PRIVATE cNumPedCom:=CriaVar("C7_NUM",.T.)
PRIVATE cNota
DEFINE MSDIALOG oDlg TITLE "Teste" From 3,0 to 340,417 PIXEL
@ 05,01 SAY "Numero do Pedido Venda.:" SIZE 55,10 OF oDlg
@ 05,10 MSGET oNumPed var cNumPed PICTURE "@!" SIZE 18,10 OF oDlg

@ 07,01 SAY "Numero do Pedido Compra.:" SIZE 55,10 OF oDlg
@ 07,10 MSGET oNumPedCom var cNumPedCom PICTURE "@!" SIZE 18,10 OF oDlg

/*
@ 01,01 TO 150,100 LABEL OemtoAnsi("Incluir/Excluir") OF oDlg  PIXEL

@ 06,05 CHECKBOX oCHProd VAR lCHProd PROMPT "Inclui/Exclui Produto" ON CLICK msgstop("Click 1")OF oDlg SIZE 60,09
@ 14,05 CHECKBOX oCHForn VAR lCHProd PROMPT "Inclui/Exclui Fornecedor" ON CLICK msgstop("Click 2")OF oDlg SIZE 70,09
@ 22,05 CHECKBOX oCHPedCom VAR lCHPedCom PROMPT "Inclui/Exclui Ped. Compra" ON CLICK msgstop("Click 3")OF oDlg SIZE 70,09
@ 30,05 CHECKBOX oCHNotEnt VAR lCHNotEnt PROMPT "Inclui/Exclui Nota Entrada" ON CLICK msgstop("Click 4")OF oDlg SIZE 70,09
*/
DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION Grava(5) ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION Grava(3)  ENABLE OF oDlg PIXEL //Salva e Apaga

ACTIVATE MSDIALOG oDlg CENTER

Return

Static Function Grava(nOpc)
Begin Transaction 
If nOpc == 3
	Produto(3)
	Fornec(3)
	PedCom(3)
	NotaEntrada(3)
//	TransfProd("01","501")
//	TransfProd("01","001")
	Frete(2)
	TitPagar(3)
	Cliente(3)
	PedVend(3)
	LibCred()
	NotaSaida(3)
	TitReceber(3)
//	BaixaTituloR(3)
Else	
//	BaixaTituloR(5)
	TitReceber(5)
	NotaSaida(5)
	PedVend(5)
	Cliente(5)
	TitPagar(5)
	Frete(1)
	NotaEntrada(5)
	PedCom(5)
	Fornec(5)
	Produto(5)
EndIf
End Transaction 

If lMsErroAuto
   mostraerro() // tela
//   MostraErro('c:\teste\','erro.aut') // job
   Return .f.
Else
   Msgstop("Transacao Finalizada com Sucesso")
Endif

Return .t.   

Static Function Produto(nOpc)
Local aProduto := {}                               

aProduto:= {{"B1_COD"     ,"999999999999999",Nil},;
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
MSExecAuto({|x,y| mata010(x,y)},aProduto,nOpc) 
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return 

Static Function Fornec(nOpc)
Local aFornec :={}

aFornec := {{"A2_COD"    ,"999999"		,nil},;
				{"A2_LOJA"   ,"01" 			,nil},;
				{"A2_NOME"   ,"Fornecedor Teste" ,nil},;
				{"A2_NREDUZ" ,"Teste F" 	,nil},;
				{"A2_END"    ,"Rua teste" 	,nil},;
				{"A2_MUN"    ,"teste" 		,nil},;
				{"A2_EST"    ,"SP" 			,nil}}

MSExecAuto({|x,y| mata020(x,y)},aFornec,nOpc) 
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return 

Static Function NotaEntrada(nOpc)
Local aCab,aItem1

aCab := {{"F1_TIPO"		,'N'			,NIL},;
			{"F1_FORMUL"	,'S'			,NIL},;
			{"F1_DOC"		,"999999"		,NIL},;
			{"F1_SERIE"		,'   '			,NIL},;
			{"F1_EMISSAO"	,dDataBase		,NIL},;									
			{"F1_FORNECE"	,'999999'    	,NIL},;		
			{"F1_LOJA"	   ,'01'        	,NIL},;		
			{"F1_FRETE" 	,'1000'     	,NIL},;		
			{"F1_COND" 	   ,RetCondVei() 	,NIL},;		
			{"F1_ESPECIE"	,'NF'    		,NIL}}

aItem1:={{"D1_COD"	,"999999999999999", NIL},;
			{"D1_UM"		,'PC'				,NIL},;
			{"D1_QUANT"	,1					,NIL},;
			{"D1_VUNIT"	,10000				,NIL},;
			{"D1_TOTAL"	,10000				,NIL},;
			{"D1_VALIPI",100				,NIL},;
			{"D1_VALICM",180				,NIL},;
			{"D1_TES"	,'110'				,NIL},;												
			{"D1_CF"		,'112'				,NIL},;                                                    
			{"D1_RATEIO",'2'				,NIL},;                                                    												
			{"D1_LOCAL"	,'01'				,NIL}}

MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,{aItem1},nOpc)
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return 

Static Function Frete(nOpc)
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   Parametros                                     ³
//³   ==========                                     ³
//³   01 -  Data Inicial         mv_par01            ³
//³   02 -  Data Final           mv_par02            ³
//³   03 -  Quanto a Nota        mv_par03 GeraXExclui³
//³   04 -  Fornecedor/Cliente   mv_par04            ³
//³   05 -  Loja                 mv_par05            ³
//³   06 -  Considera Notas      mv_par06 DevXNormal ³
//³   07 -  Aglutina produtos    mv_par07 Sim x Nao  ³
//³   08 -  Estado NF de Frete   mv_par08            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MV_PAR01		Valor total do frete
MV_PAR02		Formulario proprio S/N
MV_PAR03		Nota amarrada ao frete
MV_PAR04		Série da nota
MV_PAR05		Fornecedor
MV_PAR06		Loja Fornecedor
MV_PAR07		TES
MV_PAR08		Base de ICMS Retido
MV_PAR09		ICMS Retido
*/    
//-----------------------------------------------------

Local aCabNFR   :={}
Local aItensNFR := {}
aadd(aCabNFR,{"MV_PAR11",Ctod('01/01/00') ,nil})
aadd(aCabNFR,{"MV_PAR12",Ctod('31/12/00') ,nil})
aadd(aCabNFR,{"MV_PAR13",nOpc             ,nil})  //2 GERA 1 EXCLUI
aadd(aCabNFR,{"MV_PAR14",'999999'         ,nil})
aadd(aCabNFR,{"MV_PAR15",'01'             ,nil})
aadd(aCabNFR,{"MV_PAR16",1                ,nil})
aadd(aCabNFR,{"MV_PAR17",2                ,nil})
aadd(aCabNFR,{"MV_PAR18",'SP'             ,nil})

aadd(aCabNFR,{"MV_PAR21",150      ,nil})           //so p/ inclusao
aadd(aCabNFR,{"MV_PAR22",1        ,nil})
aadd(aCabNFR,{"MV_PAR23","999999" ,nil})
aadd(aCabNFR,{"MV_PAR24",'FRE'    ,nil})
aadd(aCabNFR,{"MV_PAR25",'999999' ,nil})
aadd(aCabNFR,{"MV_PAR26",'01'     ,nil})
aadd(aCabNFR,{"MV_PAR27",'110'    ,nil})
aadd(aCabNFR,{"MV_PAR28",0        ,nil})
aadd(aCabNFR,{"MV_PAR29",0        ,nil})
aadd(aCabNFR,{"MV_PAR31",RetCondVei() ,nil})

aItensNFR := {	{{"AUTNOTA","999999   ",nil}}}


MsExecAuto({|x,y| MATA116(x,y)},aCabNFR,aItensNFR)
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return 

Static Function TitPagar(nOpc)

Local aTitulo := {	{"E2_PREFIXO"	,'999',Nil},;
 	  				      {"E2_NUM"		,'999999',Nil},;
					      {"E2_PARCELA"	,'1',Nil},;
					      {"E2_TIPO"		,'NDF',Nil},;			
					      {"E2_NATUREZ"	,'   ',Nil},;
					      {"E2_FORNECE"	,'999999',Nil},; 
					      {"E2_LOJA"		,'01',Nil},;      
					      {"E2_EMISSAO"	,dDataBase,NIL},;
					      {"E2_VENCTO"	,dDataBase,NIL},;					 
					      {"E2_VENCREA"	,dDataBase,NIL},;					 					
					      {"E2_VALOR"		,1100,Nil}}
					
MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,nOpc) 		
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return 

Static Function Cliente(nOpc)
Local aMATA030 := {}
aMATA030:={ {"A1_COD"       ,"999999"           ,Nil},; // Codigo       C 06
				 {"A1_LOJA"      ,"00"               ,Nil},; // Loja         C 02
				 {"A1_PESSOA"    ,"F"                ,Nil},; // Pessoa       C 02
				 {"A1_NOME"      ,"INC. AUTOMATICO"  ,Nil},; // Nome         C 40
				 {"A1_NREDUZ"    ,"AUTOMATICO"		 ,Nil},; // Nome reduz.  C 20
				 {"A1_TIPO"      ,"R"				    ,Nil},; // Tipo         C 01 //R Revendedor
				 {"A1_END"       ,"RUA AUTOMATICA"	 ,Nil},; // Endereco     C 40
				 {"A1_MUN"       ,"SAO AUTOMATICO"	 ,Nil},; // Cidade       C 15
				 {"A1_EST"       ,"SP"				    ,Nil}}  // Estado       C 02

MSExecAuto({|x,y| mata030(x,y)},aMATA030,nOpc) 
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return 

Static Function PedVend(nOpc)
Local aCabPV := {}
Local aItemPV:= {}
//Cabecalho
aCabPV:={{"C5_NUM"    ,cNumPed    ,Nil},; // Numero do pedido
			 {"C5_CLIENTE","999999"    ,Nil},; // Codigo do cliente
			 {"C5_LOJAENT","00"        ,Nil},; // Loja para entrada
			 {"C5_LOJACLI","00"        ,Nil},; // Loja do cliente
			 {"C5_EMISSAO",dDatabase   ,Nil},; // Data de emissao
			 {"C5_TIPO"   ,"N"         ,Nil},; // Tipo de pedido
			 {"C5_TABELA" ,"7"        ,Nil},; // Codigo da Tabela de Preco
			 {"C5_CONDPAG","001"       ,Nil},; // Codigo da condicao de pagamanto*
			 {"C5_DESC1"  ,0           ,Nil},; // Percentual de Desconto
			 {"C5_INCISS" ,"N"         ,Nil},; // ISS Incluso
			 {"C5_TIPLIB" ,"1"         ,Nil},; // Tipo de Liberacao
			 {"C5_MOEDA"  ,1           ,Nil},; // Moeda
			 {"C5_LIBEROK","S"         ,Nil}} // Liberacao Total
//Items
aItemPV:={{"C6_NUM"    ,cNumped           ,Nil},; // Numero do Pedido
  			 {"C6_ITEM"   ,"01"              ,Nil},; // Numero do Item no Pedido
			 {"C6_PRODUTO","999999999999999" ,Nil},; // Codigo do Produto
			 {"C6_QTDVEN" ,1                 ,Nil},; // Quantidade Vendida
			 {"C6_PRUNIT"  ,0                ,Nil},; // PRECO DE LISTA
			 {"C6_PRCVEN" ,100               ,Nil},; // Preco Unitario Liquido
			 {"C6_VALOR"  ,100               ,Nil},; // Valor Total do Item
			 {"C6_ENTREG" ,dDataBase         ,Nil},; // Data da Entrega
			 {"C6_UM"     ,"UN"              ,Nil},; // Unidade de Medida Primar.
			 {"C6_TES"    ,"510"             ,Nil},; // Tipo de Entrada/Saida do Item
			 {"C6_LOCAL"  ,"01"              ,Nil},; // Almoxarifado
			 {"C6_DESCONT",1                 ,Nil},; // Percentual de Desconto
			 {"C6_COMIS1" ,0                 ,Nil},; // Comissao Vendedor
			 {"C6_CLI"    ,"000001"          ,Nil},; // Cliente
			 {"C6_LOJA"   ,"00"              ,Nil},; // Loja do Cliente
			 {"C6_QTDEMP" ,1                 ,Nil},; // Quantidade Empenhada
			 {"C6_QTDLIB" ,1                 ,Nil}}  // Quantidade Liberada

//Mata410(aCabPv,{aItemPV},3)

MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,{aItemPV},nOpc)

If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return

Static Function NotaSaida(nOpc)
Local aPvlNfs := {}                                                     
Local aMata520Cab:={}
// Posicionar as Tabelas Necessarias
If nOpc ==3 
	SC9->(DbSetOrder(1))
	SC9->(DbSeek(xFilial("SC9")+cNumPed+"01") )                    //FILIAL+NUMERO+ITEM
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+cNumPed) )                         //FILIAL+NUMERO
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+cNumPed+"01") )                    //FILIAL+NUMERO+ITEM
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial("SE4")+"001") )                           //FILIAL+NUMERO+ITEM+PRODUTO
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+"999999999999999") )               //FILIAL+PRODUTO
	SB2->(DbSetOrder(1))
	SB2->(DbSeek(xFilial("SB2")+"999999999999999"+"01") )          //FILIAL+PRODUTO+LOCAL
	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4")+"510") )                            //FILIAL+CODIGO

	aAdd(aPvlNfs,{cNumPed,;
	   		      "01",;
		    	      "01",;
         	         1,;
			          100,;
     "999999999999999",;
    			      .f.,;
      SC9->(RecNo()),;
	   SC5->(RecNo()),;
 	   SC6->(RecNo()),;
	   SE4->(RecNo()),;
	   SB1->(RecNo()),;
	   SB2->(RecNo()),;
	   SF4->(RecNo())})
	cNota := MaPvlNfs(aPvlNfs,"   ", .F., .F., .T., .T., .F., 0, 0, .T., .F.)
Else
	aMata520Cab   :={{"F2_DOC"      ,cNota    ,Nil},; //numero da nota
      				  {"F2_SERIE"    ,"   "    ,Nil}}  //serie 
	MSExecAuto({|x| MATA520(x)},aMata520Cab)
	If lMsErroAuto
	   DisarmTransaction()
	   break
	EndIf
Endif

Return

Static Function TitReceber(nOpc)
Local aTitulo := {}
aTitulo := {{"E1_PREFIXO" ,"001"           ,Nil},;
             {"E1_NUM"	   ,cNumPed         ,Nil},;
             {"E1_PARCELA" ,"0"             ,Nil},;
             {"E1_TIPO"	   ,"NF "            ,Nil},;
	          {"E1_NATUREZ" ,Space(10)      ,Nil},;
	          {"E1_CLIENTE" ,"999999"        ,Nil},;
             {"E1_LOJA"	   ,"00"            ,Nil},;
	          {"E1_EMISSAO" ,dDataBase       ,Nil},;
		       {"E1_VENCTO"	,dDataBase       ,Nil},;
		       {"E1_VENCREA" ,dDataBase       ,Nil},;
		       {"E1_VALOR"	,100             ,Nil }}
MSExecAuto({|x,y| FINA040(x,y)},aTitulo,nOpc)
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return

Static Function BaixaTituloR(nOpc)
Local aBaixa:={} 
aBaixa := {{"E1_PREFIXO"	 ,"001"             ,Nil},;
				{"E1_NUM"		 ,cNumPed           ,Nil},;
				{"E1_PARCELA"	 ,"0"               ,Nil},;
				{"E1_TIPO"	    ,"NF "             ,Nil},;
				{"AUTMOTBX"	    ,"NOR"             ,Nil},;
				{"AUTDTBAIXA"	 ,dDataBase         ,Nil},;
				{"AUTDTCREDITO" ,dDataBase         ,Nil},;
				{"AUTHIST"	    ,'Baixa Automatica',Nil},;
				{"AUTVALREC"	 ,100               ,Nil }}
MSExecAuto({|x,y| FINA070(x,y)},aBaixa)
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return

Static Function TransfProd(cLocal,cTm)
Local aItens:={}                
aItens:={{"D3_TM"     ,cTm               ,NIL},;
		    {"D3_COD"    ,"999999999999999" ,NIL},;
		    {"D3_UM"     ,"UN"              ,NIL},;
   		 {"D3_QUANT"  ,1                 ,NIL},;
			 {"D3_LOCAL"  ,cLocal            ,NIL},;
			 {"D3_EMISSAO",dDataBase         ,NIL}}

MSExecAuto({|x| MATA240(x)},aItens)       	    
If lMsErroAuto
   DisarmTransaction()
   break
EndIf
Return

Static Function PedCom(nOpc)
Local aCab :={}
Local aItem:={} 


aCab:={{"C7_NUM"     ,cNumPedcom  	  ,Nil},; // Numero do Pedido
	     {"C7_EMISSAO" ,dDataBase  		  ,Nil},; // Data de Emissao
	     {"C7_FORNECE" ,"999999"   		  ,Nil},; // Fornecedor
	     {"C7_LOJA"    ,"01"       		  ,Nil},; // Loja do Fornecedor
	     {"C7_CONTATO" ,"               ",Nil},; // Contato
	     {"C7_COND"    ,RetCondVei()	  ,Nil},; // Condicao de pagamento
	     {"C7_FILENT"  ,"01"       		  ,Nil}} // Filial Entrega

aItem:={{"C7_ITEM"   ,"01"              ,Nil},; //Numero do Item
		   {"C7_PRODUTO","999999999999999" ,Nil},; //Codigo do Produto
		   {"C7_QUANT"  ,10                ,Nil},; //Quantidade
		   {"C7_PRECO"  ,1000              ,Nil},; //Preco
		   {"C7_DATPRF" ,dDataBase			,Nil},; //Data De Entrega
		   {"C7_TES"    ,"110"	    		   ,Nil},; //Tes
		   {"C7_FLUXO"  ,"S"			 		,Nil},; //Fluxo de Caixa (S/N)
		   {"C7_LOCAL"  ,"01"		 		   ,Nil}} //Localizacao

MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCab,{aItem},nOpc)

If lMsErroAuto
   DisarmTransaction()
   break
EndIf 

Return

Static Function LibCred()
SC9->(DbSetOrder(1))
SC9->(DbSeek(xFilial("SC9")+cNumPed) )                    //FILIAL+NUMERO+ITEM
While SC9->(!EOF()) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == cNumPed
// Parametros nOpc: 1 - Libera
//                  2 - Rejeita
//            lAtuCred : Indica se Libera Credito
//            lAtuEst  : Indica se Libera Estoque
   a450Grava(1,.T.,.F.)
   SC9->(DbSkip())
End         

Return

