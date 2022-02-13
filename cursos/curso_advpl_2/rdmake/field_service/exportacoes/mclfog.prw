#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCLAIMS   º Autor ³ Edson Rodrigues    º Data ³  27/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera arquivo MCLAIMS fora de garantia                      º±±
±±º          ³ Processo Nextel                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MCLFOG()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Private oGeraTxt	
	Private cString    := "ZZ4"
	Private cPerg      := "MCLAIM"             
	Private _dtcortf02 :=CTOD('18/04/2013')
//	Private _cProble
//	Private _cRepair                                                                           

u_GerA0003(ProcName())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³mv_par01 - Data de Atend Inicial                      ³
    //³mv_par02 - Data de Atend Final                        ³
    //³mv_par03 - Data de Saida Inicial                      ³
    //³mv_par04 - Data de Saida Final          
    //|mv_par05 - Nome do Arquivo                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("ZZ4")
	dbSetOrder(1)
	
	CriaSX1()
	Pergunte(cPerg,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo Texto")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
	@ 18,018 Say " tros definidos  pelo usuario,  com os registros de OS Encerradas"
	@ 26,018 Say " dos processos BGH para o arquivo de MCLAIMS Motorola            "
	
	@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
	
	Activate Dialog oGeraTxt Centered
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  08/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o arquivo texto                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Private cArqTxt := "C:\Relato\MClaims\" + Alltrim(mv_par05) + ".TXT" 
	Private csoftout,csoftin,cqual,ctransc,cartime,cminumb,_cproblem1,_cproblem2,_crepair1,_crepair2,_cLab,_ccodrecl
	Private apartnum := {}
	Private aerros   :={}
	
	If FILE(cArqTxt)//Se já existe o arquivo com mesmo nome
		If !msgbox("Já existe um arquivo com este nome. Deseja substituir?","Atencao!","YESNO")
			Close(oGeraTxt)
			Return
		Endif
	Endif
	Private nHdl    := fCreate(cArqTxt)
	
	Private cEOL    := "CHR(13)+CHR(10)"
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a regua de processamento                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Processa({|| RunCont() },"Processando...")
	
	If len(aerros) > 0
	apMsgStop("Ocorreram erros na geracao do arquivo MClaims. Imprima, verifique e corrija os erros encontrados.")
	     U_tecrx038(aerros)
	    aerros:={}
	Endif     

	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  08/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont       

    Local _ccpfclie,_cnomcons,_cendcons,_ccidcons,_cestcons,_ccepcons,_ctelcons,_cemacons,_cendcons3,_cendcons4,_ccompcon,_ctranspo
    Local _cstrepmo,_ctrakout,_ctemprep,_ctcycler,_ctcyclec,_cflagnfc,_cdtnfcom,ccpfclie,_cnomcons,_cendcons,_ccidcons,_ccompcon
	Local  cidregL1  :='HDR'
	Local  cidregL2  :='HDR2'
	Local  cidregL3  :='HDR3'
	Local  cidregL4  :='CLM'		
	Local  cidregL5  :='CMP'//Detalhes do Componente (pecas)		
	Local  cidregL6  :='CLD'
	Local  cidregL7  :='CCD'
	Local  cidregL8  :='SLK'
	Local  cidregL9  :='TRA'
	Local  cCLMCRT   :='CLMCRT'
	Local  ccodmask  :='BR000536'	
	Local  CR        :=chr(13)+chr(10)
	Local coperac:=""     
	Local aoperac:={}                  

	
	//Local cDtcriOS:=substr(QRY->ZZ4_EMDT,7,2)+'/'+substr(QRY->ZZ4_EMDT,5,2)+'/'+substr(QRY->ZZ4_EMDT,1,4)+substr(QRY->ZZ4_EMHR,1,5)                                                                                                                               
    Local   cDtcriOS:=substr(dtos(ddatabase),7,2)+'/'+substr(dtos(ddatabase),5,2)+'/'+left(dtos(ddatabase),4)
	Local nTamLin, cLin, cCpo                                    
	Local _cSepara := iif(mv_par08==1,"|",";|;")
Local _aMCLEnv := {}
  
	
	// Incluso para filtrar operações usadas no filtro desse relatório - Edson Rodrigues 23/03/10
   // Incluso variavel _clab para ser usada no filtro do laboratório - Edson Rodrigues - 16/04/10 
	nloop:=0

	dbselectarea("ZZJ")
   dbsetorder(1)
   ZZJ->(dbgotop())         
   While ZZJ->(!eof()) .and. ZZJ->ZZJ_FILIAL == xFilial("ZZJ") 
       IF ZZJ->ZZJ_INFTCM = 'S'
             nloop++
             AADD(aoperac,ALLTRIM(ZZJ->ZZJ_OPERA))
             IF nloop==1
               //IF ZZJ->ZZJ_LAB $ _cLab
               _cLab:="('"+ZZJ->ZZJ_LAB+"'"
             Else
                If !ZZJ->ZZJ_LAB $ _cLab
                   _cLab:=_cLab+",'"+ZZJ->ZZJ_LAB+"'"
                 Endif  
             Endif  
             
        ENDIF      
      ZZJ->(DBSKIP())
   Enddo     
                
   _cLab:=_cLab+")"
   
   IF Len(aoperac) > 0
       For nop:=1 to Len(aoperac)
          IF (right(cNumEmp,2) ='06' .and. MV_PAR03>=_dtcortf02) .OR. (right(cNumEmp,2) ='02' .and. MV_PAR03<_dtcortf02) .or.   (right(cNumEmp,2) ='02' .and. aoperac[nop] $ "N01/N10/N11" )
       
             if nop==1
               coperac:="('"+aoperac[nop]
             Elseif  nop==Len(aoperac)  
               coperac:=coperac+"','"+aoperac[nop]+"')"
             Else  
               coperac:=coperac+"','"+aoperac[nop]
             Endif  
          ENDIF
        Next 
   Else
      ApMsgInfo("Não foi encontrado a operacao cadastrada no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
		return
   Endif
   
	                                   
	
	dbSelectArea("ZZ3")
	ZZ3->(dbSetOrder(1))
	dbSelectArea("ZZ1")
	ZZ1->(dbSetOrder(1))
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))	
	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))
    dbSelectArea("SF1")
	SF1->(dbSetOrder(1))
	dbSelectArea("SD2")
	SD2->(dbSetOrder(1))
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))	
	dbSelectArea("SZ9")
	SZ9->(dbSetOrder(2))
	                            
    _cCount  := CR + " SELECT COUNT(*) NRREG "
    _cSelect := CR + "  SELECT  ZZ4_CODCLI,ZZ4_LOJA, "
	_cSelect += CR + "  NFCOMPR=CASE WHEN ZA_NFCOMPR IS NULL THEN '' ELSE ZA_NFCOMPR END, "
	_cSelect += CR + "  DTNFCOM=CASE WHEN ZA_DTNFCOM IS NULL THEN '' ELSE ZA_DTNFCOM END, "
	_cSelect += CR + "  CODRECL=CASE WHEN ZG.ZZG_RECCLI  IS NULL THEN '' ELSE ZG.ZZG_RECCLI  END, "
    _cSelect += CR +  " DEFRECL=CASE WHEN ZA_DEFRECL IS NULL THEN '' ELSE ZA_DEFRECL END,"
    _cSelect += CR + "  CODTRAN=CASE WHEN ZA_CODTRAN IS NULL THEN '' ELSE ZA_CODTRAN END, "
//	_cSelect += CR + "  CODAUTO=CASE WHEN ZA_CODAUTO IS NULL THEN '' ELSE ZA_CODAUTO END, "
	_cSelect += CR + "  CODAUTO=CASE WHEN A1_XCODSAM <> '' THEN A1_XCODSAM "
	_cSelect += CR + "               WHEN ZA_CODAUTO IS NULL THEN '' ELSE ZA_CODAUTO END, "
    _cSelect += CR + "  TRACKIN=CASE WHEN ZA_TRACKIN IS NULL THEN '' ELSE ZA_TRACKIN END, "
//	_cSelect += CR + "  OSAUTOR=CASE WHEN ZA_OSAUTOR IS NULL THEN '' ELSE ZA_OSAUTOR END,"
	_cSelect += CR + "  OSAUTOR=CASE WHEN ZZ4_OSAUTO IS NULL THEN '' ELSE ZZ4_OSAUTO END,"
    _cSelect += CR + "  INFACES=CASE WHEN ZA_INFACES IS NULL THEN '' ELSE ZA_INFACES END, "
    _cSelect += CR + "  CTRLACR=CASE WHEN ZA_CTRLACR IS NULL THEN '' ELSE ZA_CTRLACR END,"
    _cSelect += CR + "  CPFCLI=CASE WHEN ZA_CPFCLI IS NULL THEN '' ELSE ZA_CPFCLI END, "
    _cSelect += CR + "  CNPJNFC=CASE WHEN ZA_CNPJNFC IS NULL THEN '' ELSE ZA_CNPJNFC END, "
    _cSelect += CR + "  SERNFC=CASE WHEN ZA_SERNFC IS NULL THEN '' ELSE ZA_SERNFC END, "
    _cSelect += CR + "  SPCPROJ=CASE WHEN ZA_SPC IS NULL THEN '0' ELSE ZA_SPC END, "
    _cSelect += CR + "  ZZ4_OS, ZZ4_TRANSC, ZZ4_SOFIN,ZZ4_SOFOUT, "
    _cSelect += CR + " 'BR5360'+ LEFT(ZZ4_OS,6) AS 'MASC_CODE','' AS 'TRANS_CODE',ZZ4_IMEI,ZZ4_SWAP,ZZ4_CARCAC,ZZ4_CODPRO,"
    _cSelect += CR + " B1_XCODAPC,B1_CREFDES,B1_NREFDES,ZZ4_NFEDT,ZZ4_NFEHR,ZZ4_DOCDTE,ZZ4_DOCHRE,ZZ4_DOCDTS,ZZ4_DOCHRS,ZZ4_NFSNR, ZZ4_PROBLE, ZZ4_REPAIR, "
_cSelect += CR + " ZZ4_NFSSER,ZZ4_NFSDT,ZZ4_NFSHR,ZZ4_NFSCLI,ZZ4_NFSLOJ,ZZ4_MCLGER,ZZ3_CODTEC,ZZ3_DATA,ZZ3_HORA,ZZ3_ENCOS,ZZ3_ARTIME,"
    _cSelect += CR + " ZZ3_MINUMB,ZZ3_NUMOS,ZZ3_IMEI,ZZ4_ATPRI,ZZ4_ATULT,ZZ4_OPEBGH,ZZ3_FASE2,ZZ3_CODSE2,ZZ3_LAB,ZZ4_GARANT,ZZ3_DEFINF, ZZ4_DEFINF "

    // EDUARDO 3.2.2010 - DADOS CLIENTE
    _cSelect += CR + " , ZZ4_NFENR NFENTRADA,ZZ4_NFESER SERIE,A1.A1_NOME, A1.A1_NREDUZ,A1.A1_XCODSAM, ZZ4_CHVFIL "
    _cFrom   := CR + " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
/*  Alterado por M.Munhoz em 27/03/2012 - ticket 4818
    Join original antes da alteracao para evitar registros duplicados do SZA
    _cJoin   := CR + " LEFT OUTER JOIN ( SELECT ZA_FILIAL,ZA_CLIENTE,ZA_LOJA,ZA_NFISCAL,ZA_SERIE,ZA_IMEI,ZA_NFCOMPR,ZA_DTNFCOM,ZA_CODRECL,ZA_CODTRAN,ZA_CODAUTO,ZA_TRACKIN,ZA_OSAUTOR,ZA_INFACES,ZA_CTRLACR,ZA_CPFCLI,ZA_CNPJNFC,ZA_SERNFC,ZA_DEFRECL,ZA_SPC "
    _cJoin   += CR + " FROM  "+RetSqlName("SZA")+"  ZA (NOLOCK)  WHERE ZA.D_E_L_E_T_='' AND ZA_FILIAL='"+xFilial("SZA")+"')" 
    _cJoin   += CR + " AS SZA ON ZA_FILIAL=ZZ4_FILIAL AND ZA_CLIENTE=ZZ4_CODCLI AND ZA_LOJA=ZZ4_LOJA AND ZA_NFISCAL=ZZ4_NFENR AND ZA_SERIE=ZZ4_NFESER AND ZA_IMEI=ZZ4_IMEI "
*/
    _cJoin   := CR + " LEFT OUTER JOIN ( "
    _cJoin   += CR + "               SELECT ZA.ZA_FILIAL,ZA_CLIENTE,ZA_LOJA,ZA.ZA_NFISCAL,ZA_SERIE,ZA.ZA_IMEI,ZA_NFCOMPR,"
	_cJoin   += CR + "                      ZA_DTNFCOM,ZA_CODRECL,ZA_CODTRAN,SZA2.ZA_CODAUTO,ZA_TRACKIN,SZA2.ZA_OSAUTOR,ZA_INFACES,"
	_cJoin   += CR + "                      ZA_CTRLACR,ZA_CPFCLI,ZA_CNPJNFC,ZA_SERNFC,ZA_DEFRECL,ZA_SPC,ZA.ZA_CODPRO "
    _cJoin   += CR + "               FROM   "+RetSqlName("SZA")+"  ZA (NOLOCK)  "
    _cJoin   += CR + "               JOIN   ("
	_cJoin   += CR + "                      SELECT ZA_FILIAL, ZA_IMEI, ZA_NFISCAL, ZA_CODPRO, MAX(ZA_CODAUTO) ZA_CODAUTO, MAX(ZA_OSAUTOR) ZA_OSAUTOR, MAX(R_E_C_N_O_) SZARECNO"
    _cJoin   += CR + "                      FROM   "+RetSqlName("SZA")+"  ZA (NOLOCK)  "
    _cJoin   += CR + "                      WHERE  ZA.D_E_L_E_T_='' AND ZA_FILIAL='"+xFilial("SZA")+"' "
	_cJoin   += CR + "                      GROUP  BY ZA_FILIAL, ZA_IMEI, ZA_NFISCAL, ZA_CODPRO"
    _cJoin   += CR + "                      ) AS SZA2"
    _cJoin   += CR + "               ON     ZA.R_E_C_N_O_ = SZA2.SZARECNO
    _cJoin   += CR + "               WHERE ZA.D_E_L_E_T_='' AND ZA.ZA_FILIAL='"+xFilial("SZA")+"' " 
    _cJoin   += CR + "                ) AS SZA "
    _cJoin   += CR + " ON   ZA_FILIAL=ZZ4_FILIAL AND ZA_CLIENTE=ZZ4_CODCLI AND ZA_LOJA=ZZ4_LOJA AND ZA_NFISCAL=ZZ4_NFENR "
	_cJoin   += CR + "      AND ZA_SERIE=ZZ4_NFESER AND ZA_IMEI=ZZ4_IMEI AND ZA_CODPRO = ZZ4_CODPRO"
    _cJoin   += CR + " INNER JOIN ( SELECT B1_COD,B1_XCODAPC,B1_CREFDES,B1_NREFDES FROM "+RetSqlName("SB1")+" B1 (NOLOCK)  WHERE B1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"') " 
	_cJoin   += CR + " AS SB1 ON B1_COD=ZZ4_CODPRO "
    _cJoin   += CR + " INNER JOIN ( SELECT ZZ3_FILIAL,ZZ3_LAB,ZZ3_NUMOS,ZZ3_IMEI,ZZ3_SEQ,ZZ3_STATUS,ZZ3_FASE2,ZZ3_CODSE2,ZZ3_CODTEC,ZZ3_DATA,ZZ3_HORA,ZZ3_ENCOS,ZZ3_ARTIME,ZZ3_MINUMB,ZZ3_DEFINF "    
    _cJoin   += CR + " FROM "+RetSqlName("ZZ3")+" ZZ3_1 (NOLOCK)  INNER JOIN (SELECT MAX(R_E_C_N_O_) AS RECNO FROM "+RetSqlName("ZZ3")+"  (NOLOCK) "
	_cJoin   += CR + "                                                         WHERE ZZ3_ENCOS='S' AND D_E_L_E_T_='' AND ZZ3_DATA>='"+dtos(MV_PAR01)+"' AND ZZ3_DATA<='"+dtos(MV_PAR02)+"'  "
	_cJoin   += CR + "                                                         AND ZZ3_STATUS='1' AND  ZZ3_ESTORN<>'S' AND ZZ3_LAB IN "+_cLab+" AND ZZ3_FILIAL='"+xFilial("ZZ3")+"' "
	_cJoin   += CR + "                                                         GROUP BY ZZ3_FILIAL,ZZ3_IMEI,ZZ3_NUMOS) AS ZZ3_2   "
	_cJoin   += CR + "                                             ON ZZ3_1.R_E_C_N_O_=ZZ3_2.RECNO ) "
	_cJoin   += CR + " AS ZZ3 ON ZZ3_FILIAL=ZZ4_FILIAL AND LEFT(ZZ3_NUMOS,6) = LEFT(ZZ4_OS,6) AND LEFT(ZZ3_IMEI,15)=LEFT(ZZ4_IMEI,15) "

    // EDUARDO 3.2.2010 - BUSCANDO CLIENTE
    _cJoin   += CR + " INNER JOIN "+RETSQLNAME("SA1")+" A1 ON A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+XFILIAL("SA1")+"'  "                    
    _cJoin   += CR + "                                    AND A1.A1_COD = ZZ4.ZZ4_CODCLI AND A1.A1_LOJA = ZZ4.ZZ4_LOJA " 
    _cJoin   += CR + " LEFT OUTER JOIN "+RetSQlName("ZZG")+" ZG (NOLOCK) " 
    _cJoin   += CR + " ON ZZG_FILIAL = '"+xFilial("ZZG")+"' AND ZZ4.ZZ4_DEFINF = ZG.ZZG_CODIGO AND ZG.ZZG_LAB = '2' AND ZG.D_E_L_E_T_ = '' "

    _cWhere  := CR + " WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"'  "
    If mv_par07 == 1
    _cWhere  += CR + " AND LEFT(ZA_SPC,3) = 'SPC'  "
    ElseIf mv_par07 == 2
    _cWhere  += CR + " AND ISNULL(SZA.ZA_SPC,'0') IN ('0','')   "
    EndIf
    _cWhere  += CR + " AND ZZ4_STATUS>='5' " 
    _cWhere  += CR + " AND ZZ4_NFSDT>='"+dtos(mv_par03)+"' AND ZZ4_NFSDT<='"+dtos(mv_par04)+"' " 

    // Incluso filtro - Edson Rodrigues 23/03/10
    _cWhere  += CR + " AND ZZ4_OPEBGH IN "+coperac+" "      
    // Incluso filtro - M.Munhoz - 07/05/2013
    _cWhere  += CR + " AND ZZ4_NFSTES NOT IN ('798','880') "
	_cWhere  += CR + " AND ZZ4_GARMCL ='N' "

     If !empty(mv_par06)
         _cWhere  += CR + " AND '"+alltrim(mv_par06)+"' LIKE '%'+RTRIM(ZZ4.ZZ4_OS)+'%' AND ZZ4.ZZ4_OS<>'' "
     Endif    

	// M.Munhoz - 03/04/2012 - Ticket 4757
	// Inclusao de filtro para eliminar IMEIs de Orcamento
	_cWhere  += CR + " AND ZZ4_OS NOT IN (SELECT DISTINCT ZZ3_NUMOS FROM "+RetSqlName("ZZ3")+" (NOLOCK) "
	_cWhere  += CR + "                    WHERE D_E_L_E_T_ = '' AND ZZ3_FILIAL = '"+xFilial("ZZ3")+"' AND ZZ3_ESTORN <> 'S' "
	_cWhere  += CR + "                          AND ZZ3_STATUS = '1' AND ZZ3_FASE1 = '39' AND ZZ3_FASE2 = '15' AND ZZ3_CODSET = '000005')"

    _cOrder  := CR + " ORDER BY ZZ3_IMEI,ZZ3_NUMOS,ZZ3_DATA, ZZ3_HORA"

//    _cQryReg := _cCount + _cFrom + _cJoin + _cWhere  ,,
//    memowrite("mclaims.sql",_cQryReg)
//    _cQryReg := strtran(_cQryReg, CR, "")
//    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryReg),"REG",.T.,.T.)
//    dbselectarea("REG")
//    REG->(dbgotop())
//    _nReg := REG->NRREG
//    Procregua(_nReg)
//    REG->(dbCloseArea())  
    Procregua(10000)
     
    // Grava query em arquivo texto pra ser utilizado pelo Query Analiser
    _cQuery := _cSelect + _cFrom + _cJoin + _cWhere + _cOrder
    memowrite("MCLAIMS.SQL",_cQuery )
    _cQuery := strtran(_cQuery, CR, "")
//    memowrit("mclaims.sql",_cQuery)

    // Gera arquivos temporario com resultado da Query
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)
      TcSetField("QRY", "ZZ4_NFSDT","D")
      TcSetField("QRY", "ZZ4_NFEDT","D")
      TcSetField("QRY", "ZZ4_DOCDTS","D")    
      TcSetField("QRY", "ZZ4_DOCDTE","D")    
      TcSetField("QRY", "DTNFCOM","D")    

    //LINHA 1
    cLin:=cidregL1+_cSepara+cCLMCRT+_cSepara+cDtcriOS+_cSepara+'00:00'+_cSepara+ccodmask+_cSepara+_cSepara+cEOL
   	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Return
	   Endif
	Endif

    //LINHA 2
    cLin:=cidregL2+_cSepara+_cSepara+_cSepara+_cSepara+cEOL  
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Return
	   Endif
	Endif
	    
	//LINHA 3
	cLin:=cidregL3+_cSepara+_cSepara+_cSepara+cEOL  
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Return
	   Endif
	Endif
	    
	//LINHA 4
	QRY->(dbGoTop())	
	If QRY->(!EOF()) 
	    While QRY->(!EOF())
	    
		_c1_3 := _c1_7 := _c1_8 := _cendcons3 := _cendcons4 := ""
            _lpassou  :=.t.
            			   
			IF ZZJ->(dbseek(xFilial("ZZJ")+ QRY->ZZ4_OPEBGH+QRY->ZZ3_LAB))
				   	cinftrans:=ZZJ->ZZJ_INFTCM  // variavel que informa o Transcode - Processo Mclaims - Edson Rodrigues 22/03/10
				   	ctransfix:=ZZJ->ZZJ_TRAFIX  // variavel que diz se Transcode e fixo,sim, nao ou condicional - Processo Mclaims - Edson Rodrigues 15/04/10
 			      	ccodtrfix:=ZZJ->ZZJ_CODTRF // variavel que obtem o Transcode quando ZZJ_TRAFIX=SIM - Processo Mclaims - Edson Rodrigues 15/04/10
 			      	cfastnfix:=ALLTRIM(ZZJ->ZZJ_FASTRC)  // variavel que obtem a(s) fase(s) quando ZZJ_TRAFIX=NAO - Processo Mclaims - Edson Rodrigues 15/04/10
 			      	csettnfix:=ALLTRIM(ZZJ->ZZJ_SETTRC)  // variavel que obtem o(s) setor(s) quando ZZJ_TRAFIX=NAO - Processo Mclaims - Edson Rodrigues 15/04/10
 			      	cfasouinf:=ALLTRIM(ZZJ->ZZJ_FASOUT)  // variavel que obtem a(s) fase(s) que informa outros dados para o processo do Mclaims e que o ZZJ_TRAFIX=NAO - Edson Rodrigues 15/04/10
 			      	cinfcaut :=ALLTRIM(ZZJ->ZZJ_INFCAU)  // variavel que diz se informa dados da NF compra ou cod. autorizada se ZZJ_TRAFIX=NAO e ZZJ_INFTCM=SIM - Edson Rodrigues 16/04/10
				   	coperador:=AllTrim(ZZJ->ZZJ_CODOPE)  // declara operadora para envio mclaims.		      
 			      
            ELSE
               ApMsgInfo("Não foi encontrado a operacao cadastrada para OS "+QRY->ZZ4_OS+" e IMEI "+QRY->ZZ4_IMEI+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
		         QRY->(dbskip())
		         loop
            ENDIF
	 	      
		
	 	    //Alterado IF abaixo - Edson Rodrigues - 16/04/10
	 	    //IF QRY->ZZ4_OPEBGH $ "N01/N06"		// Alterado condição - Edson Rodrigues 23/03/10  		
	 	    IF cinftrans='S' //.and. ctransfix $ "C/S"
                csoftin :=ALLTRIM(QRY->ZZ4_SOFIN)
                csoftout:=ALLTRIM(QRY->ZZ4_SOFOUT)
                cartime :=IIF(EMPTY(QRY->ZZ3_ARTIME),"00000000000000000000",ALLTRIM(QRY->ZZ3_ARTIME))
                cminumb :=IIF(EMPTY(ALLTRIM(QRY->ZZ3_MINUMB)),"NA",ALLTRIM(QRY->ZZ3_MINUMB))          
               _ccodrecl:=IIF(empty(ALLTRIM(QRY->CODRECL)),"C0022",ALLTRIM(QRY->CODRECL))
                ctransc :=ALLTRIM(QRY->ZZ4_TRANSC)

            ENDIF
          
            IF empty(ctransc) .or. empty(csoftout) .or. empty(_ccodrecl)    // Alterado condição - Edson Rodrigues 23/03/10
              qryzz3("3",LEFT(QRY->ZZ3_NUMOS,6),LEFT(QRY->ZZ3_IMEI,15),cfastnfix,csettnfix,cfasouinf, AllTrim(QRY->ZZ4_TRANSC),AllTrim(QRY->ZZ4_SOFIN),AllTrim(QRY->ZZ4_SOFOUT)) 	          
              //Alterado Else abaixo - Edson Rodrigues - 16/04/10
              //Elseif !QRY->ZZ4_OPEBGH $ "N01/N06"				    
            Elseif cinftrans='S' .and. ctransfix = "N"
	           qryzz3("1",LEFT(QRY->ZZ3_NUMOS,6),LEFT(QRY->ZZ3_IMEI,15),cfastnfix,csettnfix,cfasouinf, AllTrim(QRY->ZZ4_TRANSC),AllTrim(QRY->ZZ4_SOFIN),AllTrim(QRY->ZZ4_SOFOUT)) 
		    Endif  
		    
		    dbselectarea("QRY")
		//If (!empty(ctransc) .AND. !(ALLTRIM(ctransc)$ "IOW,IRF,IXT") .OR. !empty(ctransc) .AND. Len(AllTrim(QRY->SPCPROJ))>1)  //Uiran Almeida -  Alterado para vir somente registros fora de garantia
		If (!empty(ctransc) .AND. (ALLTRIM(ctransc)$ "IOW,IRF,IXT") .OR. (!empty(ctransc) .AND. Len(AllTrim(QRY->SPCPROJ))<1 .AND. QRY->ZZ4_OPEBGH $ "N01/N10/N11"))
				
		       qryzz3("2",LEFT(QRY->ZZ3_NUMOS,6),LEFT(QRY->ZZ3_IMEI,15),cfastnfix,csettnfix,cfasouinf, AllTrim(QRY->ZZ4_TRANSC),AllTrim(QRY->ZZ4_SOFIN),AllTrim(QRY->ZZ4_SOFOUT))
		       qrysz9("1",LEFT(QRY->ZZ3_NUMOS,6),LEFT(QRY->ZZ3_IMEI,15),QRY->ZZ4_OPEBGH,QRY->ZZ3_LAB)
		       dbselectarea("QRY")
			  _ccpfclie :=""
		      _cnomcons :=""
		      _cendcons :=""
		      _ccidcons :=""
		      _cestcons :=""
		      _ccepcons :=""
		      _ctelcons :=""
		      _cemacons :=""        
		      _cendcons3:=""
              _cendcons4:=""		                      
		      _ccompcon :=""      
		      _ctranspo :=ALLTRIM(Posicione("SA4",1,xFilial("SA4") + QRY->CODTRAN,"A4_CODTRAM"))
		      _cstrepmo :=ALLTRIM(Posicione("ZZ1",2,xFilial("ZZ1") + QRY->ZZ3_LAB + QRY->ZZ3_FASE2 + QRY->ZZ3_FASE2 ,"ZZ1_STRMOT"))  
		      _choraSF1 :=ALLTRIM(Posicione("SF1",1,xFilial("SF1") + QRY->NFENTRADA + QRY->SERIE + QRY->ZZ4_CODCLI+QRY->ZZ4_LOJA,"F1_HORA"))
		 	  _cproblem1:=AllTrim(QRY->ZZ4_PROBLE)
 			  _crepair1 :=AllTrim(QRY->ZZ4_REPAIR)
	          IF !EMPTY(QRY->ZZ4_NFSCLI+QRY->ZZ4_NFSLOJ)
    		      _choraSF2 :=ALLTRIM(Posicione("SF2",1,xFilial("SF2") + QRY->ZZ4_NFSNR + QRY->ZZ4_NFSSER + QRY->ZZ4_NFSCLI+QRY->ZZ4_NFSLOJ,"F2_HORA"))  
    		  ELSE
         		  _choraSF2 :=ALLTRIM(Posicione("SF2",1,xFilial("SF2") + QRY->ZZ4_NFSNR + QRY->ZZ4_NFSSER + QRY->ZZ4_CODCLI+QRY->ZZ4_LOJA,"F2_HORA"))  
    		  ENDIF
    		  
    		      
		      _cstrepmo:=IIF(empty(_cstrepmo),"SHP",ALLTRIM(_cstrepmo))
		      _ctrakout :=""
		     
		      //Incluir ponto de entrada na NFS para solicitar ao usuário a inclusao da gravacao do Lacre, F2_TRACKOU 
              //_ccopoer: =ALLTRIM(QRY->CODOPER)  --deixado fixo como NEX para validacao do programa e porque a principio nao vai mudar. 18/06/09
		      _codpro:=ALLTRIM(QRY->ZZ4_CODPRO)
		      _codnewpro:=""                                                                
		      //_codautfor:= IIF(QRY->ZZ4_OPEBGH == "N01" .AND. QRY->ZZ4_GARANT="N","",QRY->OSAUTOR)
		      _codautfor:= IIF(cinftrans='S' .and. ctransfix = "C" .AND. QRY->ZZ4_GARANT="N","",QRY->OSAUTOR)
		      _nhora:=0
	          _chora:=""      
	          _hrdocent :=""
	          _hrdocsai :=""
			  _hrnfent  :=""
			  _hrnfsai  :=""

		      for x :=1 to len(_codpro)
			    if substr(_codpro,x,1) $ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" 
			       _codnewpro:=_codnewpro+substr(_codpro,x,1)
			    Endif		           
		      next         
		      
		      //Comentado edson Rodrigues - 04/09/10
	          //hora de Emissao Entrada X hora da Doca entrada
			  If empty(QRY->ZZ4_NFEHR) .and.  empty(_choraSF1) .and.  !empty(QRY->ZZ4_DOCHRE)
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_DOCHRE))
			             If substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1) $ "0123456789" 
			                 _hrnfent:=_hrnfent+substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1)
			                 _hrdocent:=_hrdocent+substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1)
			                 _choraSF1:=_choraSF1+substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1)
			             Endif
			         Next    
			         
			         
			  ELSEIF  Empty(QRY->ZZ4_NFEHR) .and.  !empty(_choraSF1) .and.  !empty(QRY->ZZ4_DOCHRE)        
			         FOR I:= 1 TO LEN(ALLTRIM(_choraSF1))
			             If substr(ALLTRIM(_choraSF1),I,1) $ "0123456789" 
			                 _hrnfent:=_hrnfent+substr(ALLTRIM(_choraSF1),I,1)
			                 _choraSF1:=_choraSF1+substr(ALLTRIM(_choraSF1),I,1)			                 
			             Endif
			         Next    
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_DOCHRE))
			             If substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1) $ "0123456789" 
			                 _hrdocent:=_hrdocent+substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1)			                 
			             Endif
			         Next    
			      
			  
			  ELSEIF empty(QRY->ZZ4_NFEHR) .and. empty(_choraSF1) .and.  empty(QRY->ZZ4_DOCHRE)
			           _hrnfent :="080000"
			           _hrdocent:="080000"                                      
			           _choraSF1:="080000"                                      
			  
			  ELSEIF !empty(QRY->ZZ4_NFEHR) .and. !empty(_choraSF1) .and. !empty(QRY->ZZ4_DOCHRE)
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_DOCHRE))
			             If substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1) $ "0123456789" 
			                 _hrdocent:=_hrdocent+substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1)
			             Endif
			         Next      
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_NFEHR))
			             If substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1) $ "0123456789" 
			                 _hrnfent:=_hrnfent+substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1)
			             Endif
			         Next              
			         FOR I:= 1 TO LEN(ALLTRIM(_choraSF1))
			             If substr(ALLTRIM(_choraSF1),I,1) $ "0123456789" 
			                 _choraSF1:=_choraSF1+substr(ALLTRIM(_choraSF1),I,1)
			             Endif
			         Next                   
			         
			         
			  ELSEIF !empty(QRY->ZZ4_NFEHR) .and. !empty(_choraSF1) .and.  empty(QRY->ZZ4_DOCHRE) 
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_NFEHR))
			             If substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1) $ "0123456789" 
			                 _hrnfent:=_hrnfent+substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1)
  			                 _hrdocent:=_hrdocent+substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1)
			             Endif
			         Next             
			         FOR I:= 1 TO LEN(ALLTRIM(_choraSF1))
			             If substr(ALLTRIM(_choraSF1),I,1) $ "0123456789" 
			                 _choraSF1:=_choraSF1+substr(ALLTRIM(_choraSF1),I,1)
			             Endif
			         Next                   

			  
			  ELSEIF !empty(QRY->ZZ4_NFEHR) .and. empty(_choraSF1) .and.  empty(QRY->ZZ4_DOCHRE) 
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_NFEHR))
			             If substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1) $ "0123456789" 
			                 _hrnfent:=_hrnfent+substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1)
  			                 _hrdocent:=_hrdocent+substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1)
			                 _choraSF1:=_choraSF1+substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1)
			             Endif
			         Next             
		      
		                              
		      ELSEIF !empty(QRY->ZZ4_NFEHR) .and. empty(_choraSF1) .and.  !empty(QRY->ZZ4_DOCHRE) 
			         FOR I:=1 TO LEN(ALLTRIM(QRY->ZZ4_NFEHR))
			             If substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1) $ "0123456789" 
			                 _hrnfent:=_hrnfent+substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1)
			                 _choraSF1:=_choraSF1+substr(ALLTRIM(QRY->ZZ4_NFEHR),I,1)
			             Endif
			         Next     
  			         FOR I:=1 TO LEN(ALLTRIM(QRY->ZZ4_DOCHRE))
			             If substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1) $ "0123456789" 
			                 _hrdocent:=_hrdocent+substr(ALLTRIM(QRY->ZZ4_DOCHRE),I,1)
			             Endif
			         Next              
			  
			         
			  ELSEIF empty(QRY->ZZ4_NFEHR) .and. !empty(_choraSF1) .and.  empty(QRY->ZZ4_DOCHRE) 
			         FOR I:=1 TO LEN(ALLTRIM(_choraSF1))
			             If substr(ALLTRIM(_choraSF1),I,1) $ "0123456789" 
			                 _hrnfent:=_hrnfent+substr(ALLTRIM(_choraSF1),I,1)
			                 _choraSF1:=_choraSF1+substr(ALLTRIM(_choraSF1),I,1)
			                 _hrdocent:=_hrdocent+substr(ALLTRIM(_choraSF1),I,1)
			             Endif
			         Next     
      
		      ENDIF          

			// Hora de Emissao Saida X hora da Doca Saida
			  If empty(QRY->ZZ4_NFSHR) .and.  empty(_choraSF2) .and. !empty(QRY->ZZ4_DOCHRS)
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_DOCHRS))
			             If substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1) $ "0123456789" 
			                 _hrnfsai  := _hrnfsai+substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1)
			                 _hrdocsai := _hrdocsai+substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1)
			                 _choraSF2 := _choraSF2+substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1)
			             Endif
			         Next      
			  

			  ELSEIF empty(QRY->ZZ4_NFSHR) .and.  !empty(_choraSF2) .and. !empty(QRY->ZZ4_DOCHRS)
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_DOCHRS))
			             If substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1) $ "0123456789" 
			                 _hrnfsai  := _hrnfsai+substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1)
			                 _hrdocsai := _hrdocsai+substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1)
			             Endif
			         Next 
			         FOR I:= 1 TO LEN(ALLTRIM(_choraSF2))
			             If substr(ALLTRIM(_choraSF2),I,1) $ "0123456789" 
			                _choraSF2 := _choraSF2+substr(ALLTRIM(_choraSF2),I,1)
			             Endif
			         Next      
			       
			  ELSEIF !empty(QRY->ZZ4_NFSHR) .and.  !empty(_choraSF2) .and. !empty(QRY->ZZ4_DOCHRS)
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_DOCHRS))
			             If substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1) $ "0123456789" 
			                 _hrnfsai  := _hrnfsai+substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1)
			         Endif
			         Next 
			         FOR I:= 1 TO LEN(ALLTRIM(_choraSF2))
			             If substr(ALLTRIM(_choraSF2),I,1) $ "0123456789" 
			                _choraSF2 := _choraSF2+substr(ALLTRIM(_choraSF2),I,1)
			             Endif
			         Next      
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_NFSHR))
			             If substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1) $ "0123456789" 
			                _choraSF2 := _choraSF2+substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1)
			             Endif
			         Next      
			  

			  ELSEIF empty(QRY->ZZ4_NFSHR) .and.  empty(_choraSF2) .and. empty(QRY->ZZ4_DOCHRS)
			           _hrnfsai :="080000"
			           _hrdocsai:="080000"
			           _choraSF2:="080000"
			      
			 
 			  ELSEIF !empty(QRY->ZZ4_NFSHR) .and. empty(_choraSF2) .and.  empty(QRY->ZZ4_DOCHRS)
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_NFSHR))
			             If substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1) $ "0123456789" 
			                 _hrnfsai  := _hrnfsai+substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1)
			                 _hrdocsai := _hrdocsai+substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1)
			                 _choraSF2 := _choraSF2+substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1)
			             Endif
			         Next      
				 
			  ELSEIF !empty(QRY->ZZ4_NFSHR) .and. !empty(_choraSF2) .and.  empty(QRY->ZZ4_DOCHRS)
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_NFSHR))
			             If substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1) $ "0123456789" 
			                 _hrnfsai  := _hrnfsai+substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1)
			                 _hrdocsai := _hrdocsai+substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1)
			             Endif
			         Next       
  			         FOR I:= 1 TO LEN(ALLTRIM(_choraSF2))
			             If substr(ALLTRIM(_choraSF2),I,1) $ "0123456789" 
			                _choraSF2 := _choraSF2+substr(ALLTRIM(_choraSF2),I,1)
			             Endif
			         Next      
			  
			  ELSEIF !empty(QRY->ZZ4_NFSHR) .and. empty(_choraSF2) .and.  !empty(QRY->ZZ4_DOCHRS)
			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_NFSHR))
			             If substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1) $ "0123456789" 
			                 _hrnfsai  := _hrnfsai+substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1)
			                 _choraSF2 := _choraSF2+substr(ALLTRIM(QRY->ZZ4_NFSHR),I,1)
			             Endif
			         Next       
  			         FOR I:= 1 TO LEN(ALLTRIM(QRY->ZZ4_DOCHRS))
			             If substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1) $ "0123456789" 
			                _hrdocsai := _hrdocsai+substr(ALLTRIM(QRY->ZZ4_DOCHRS),I,1)
			             Endif
			         Next      
			  
			  ELSEIF empty(QRY->ZZ4_NFSHR) .and. !empty(_choraSF2) .and.  empty(QRY->ZZ4_DOCHRS)
			         FOR I:= 1 TO LEN(ALLTRIM(_choraSF2))
			             If substr(ALLTRIM(_choraSF2),I,1) $ "0123456789" 
			                 _hrnfsai  := _hrnfsai+substr(ALLTRIM(_choraSF2),I,1)
			                 _choraSF2 := _choraSF2+substr(ALLTRIM(_choraSF2),I,1)
			                 _hrdocsai := _hrdocsai+substr(ALLTRIM(_choraSF2),I,1)
			             Endif
			         Next       
			  ENDIF
                                
              _hrdocent :=TRANSFORM(PADR(_hrdocent,8,'0') ,'99:99:99') 
			  _hrdocsai :=TRANSFORM(PADR(_hrdocsai,8,'0') ,'99:99:99')
			  _hrnfent  :=TRANSFORM(PADR(_hrnfent,8 ,'0') ,'99:99:99')
			  _hrnfsai  :=TRANSFORM(PADR(_hrnfsai,8 ,'0') ,'99:99:99')

		      IF QRY->ZZ4_DOCDTE <= QRY->ZZ4_NFSDT
		         _ctemprep :=STRZERO(QRY->ZZ4_NFSDT-QRY->ZZ4_DOCDTE,10)		          		           
		         _chemprep :=ELAPTIME(_hrdocent,_hrnfsai) 
		      ELSE
		         _ctemprep :=STRZERO(ddatabase-QRY->ZZ4_DOCDTE,10)//+':00:00' 
		         _chemprep :=ELAPTIME(_hrdocent,TIME()) 
		      ENDIF                 
		      _ctemprep:=IIF(VAL(_ctemprep) > 99 ,'99'+':23:59',right(_ctemprep,2)+':'+LEFT(_chemprep,5))
		     
		      IF QRY->ZZ4_NFEDT <= QRY->ZZ4_NFSDT
		        _ctcycler :=STRZERO(QRY->ZZ4_NFSDT-QRY->ZZ4_NFEDT,10)//+':00:00'
		        _hcycler :=ELAPTIME(_hrnfent,_hrnfsai) 
		      ELSE
		        _ctcycler :=STRZERO(ddatabase-QRY->ZZ4_NFEDT,10)//+':00:00'
  		        _hcycler :=ELAPTIME(_hrnfent,TIME()) 
		      ENDIF   
		      _ctcycler:=IIF(val(_ctcycler) > 99 ,'99'+':23:59',right(_ctcycler,2)+':'+LEFT(_hcycler,5)) 
		     
		      IF QRY->ZZ4_DOCDTE > QRY->DTNFCOM
		        _ctcyclec:= IIF(QRY->ZZ4_DOCDTE <= QRY->ZZ4_DOCDTS,STRZERO(QRY->ZZ4_DOCDTS-QRY->ZZ4_DOCDTE,10),STRZERO(ddatabase-QRY->ZZ4_DOCDTE,10))//+':00:00'  
		        _chcyclec:= IIF(QRY->ZZ4_DOCDTE <= QRY->ZZ4_DOCDTS,ELAPTIME(_hrdocent,_hrdocsai),ELAPTIME(_hrdocent,TIME()))//+':00:00'  
		      ELSE    
		        _ctcyclec:= IIF(QRY->DTNFCOM <= QRY->ZZ4_DOCDTS,STRZERO(QRY->ZZ4_DOCDTS-QRY->DTNFCOM,10),STRZERO(ddatabase-QRY->DTNFCOM,10))//+':00:00'      
		        _chcyclec:= IIF(QRY->DTNFCOM <= QRY->ZZ4_DOCDTS,ELAPTIME('00:00:00',_hrdocsai),ELAPTIME('00:00:00',TIME()))//+':00:00'  
		      ENDIF	
		        _ctcyclec:=IIF(val(_ctcyclec) > 99 ,'99'+':23:59',right(_ctcyclec,2)+':'+LEFT(_chcyclec,5))	  
		       
		      _cflagnfc :=iif(EMPTY(QRY->DTNFCOM),'N','Y')
              _cdtnfcom :=iif(_cflagnfc="Y",substr(DTOS(QRY->DTNFCOM),7,2)+'/'+substr(DTOS(QRY->DTNFCOM),5,2)+'/'+left(DTOS(QRY->DTNFCOM),4),"")
			/*
			IF Len(AllTrim(QRY->SPCPROJ))>1
		        _cflagnfc:='N'
			ENDIF
			*/
		    
		      _cdtbalca :=substr(DTOS(QRY->ZZ4_NFEDT),7,2)+'/'+substr(DTOS(QRY->ZZ4_NFEDT),5,2)+'/'+left(DTOS(QRY->ZZ4_NFEDT),4)
		      IF !EMPTY(QRY->ZZ4_DOCDTS) 
		       _cdtdespc :=substr(DTOS(QRY->ZZ4_DOCDTS),7,2)+'/'+substr(DTOS(QRY->ZZ4_DOCDTS),5,2)+'/'+left(DTOS(QRY->ZZ4_DOCDTS),4)
		       _chrdespc :=left(QRY->ZZ4_DOCHRS,2)+":"+substr(QRY->ZZ4_DOCHRS,3,2)
		      ELSE
		       _cdtdespc :=substr(DTOS(QRY->ZZ4_NFSDT),7,2)+'/'+substr(DTOS(QRY->ZZ4_NFSDT),5,2)+'/'+left(DTOS(QRY->ZZ4_NFSDT),4) 
		       _nhora:=VAL(left(QRY->ZZ4_NFSHR,2))+2
		       _chora:=iif(_nhora > 24,STR(_nhora-24,2),STR(_nhora))
		       _chrdespc :=alltrim(_chora)+":"+substr(QRY->ZZ4_NFSHR,4,2)
		      ENDIF   	    
   		      _cdtrepar :=substr(QRY->ZZ3_DATA,7,2)+'/'+substr(QRY->ZZ3_DATA,5,2)+'/'+left(QRY->ZZ3_DATA,4)
		     
		      //Alterado IF abaixo - Edson Rodrigues - 16/04/10
		      //IF !QRY->ZZ4_OPEBGH $ "N01/N06"				
			  IF cinftrans='S' //.and. ctransfix = "N"
			    //BUSCAR DADOS ADICIONAIS PELO CPF/CNPJ DO CONSUMIDOR NO CADASTRO DO CLIENTE E ADICIONAR A LINHA
			    IF !EMPTY(QRY->CPFCLI)
			        SA1->(DBSETORDER(3))
			        IF SA1->(dbSeek(xFilial("SA1") + QRY->CPFCLI)) 

				        ccpfclie:=QRY->CPFCLI
				        _cnomcons:=ALLTRIM(LEFT(SA1->A1_NOME,40))
				        _cendcons:=ALLTRIM(LEFT(SA1->A1_END,50))
				        _ccidcons:=ALLTRIM(LEFT(SA1->A1_MUN,50)) 
				        _ccompcon:=ALLTRIM(LEFT(SA1->A1_XNUMCOM,50))
				        _cestcons:=ALLTRIM(LEFT(SA1->A1_EST,2))
				        _ccepcons:=ALLTRIM(LEFT(SA1->A1_CEP,8))
				        _ctelcons:=ALLTRIM(LEFT(SA1->A1_TEL,30))
				        _cemacons:=ALLTRIM(LEFT(SA1->A1_EMAIL,100))
			        
			        ENDIF
			    ENDIF
				/*
			    //PEGAR OS DADOS DA NF DA ENTRADA OU OS SAM
			    IF QRY->NFCOMPR<>''
		          //Alterado IF abaixo - Edson Rodrigues - 16/04/10
			       //IF  QRY->ZZ4_OPEBGH $ "N03"
			       IF cinfcaut='S'
                      _cendcons3:=ALLTRIM(QRY->OSAUTOR)
                      _cendcons4:=ALLTRIM(QRY->CODAUTO)
                      IF empty(_cendcons4) .and. !EMPTY(QRY->A1_XCODSAM)
                          _cendcons4:=ALLTRIM(QRY->A1_XCODSAM)
                      Endif                      

			       ELSE
			         _cendcons3:=ALLTRIM(QRY->CNPJNFC)+ALLTRIM(QRY->NFCOMPR)+ALLTRIM(QRY->SERNFC)
			       ENDIF     
			    ENDIF   	               
				*/
			  ENDIF
			
			
			  //LINHA4			                                                                                                
			// Marcelo Munhoz - 14/06/2012
			// Correcao do preenchimento das informacoes SAM no arquivo MCLAIM.
			// Eu apenas tirei este codigo do IF acima que limitava o processo a operacoes que nao tivessem o transaction fixo,
			// o que nao eh o caso da operacao N03.
			//PEGAR OS DADOS DA NF DA ENTRADA OU OS SAM
			_cendcons3 := _cendcons4 := ""
			IF QRY->NFCOMPR<>''
				//Alterado IF abaixo - Edson Rodrigues - 16/04/10
				//IF  QRY->ZZ4_OPEBGH $ "N03"
				IF cinfcaut='S'
					_cendcons3:=ALLTRIM(QRY->OSAUTOR)
					_cendcons4:=ALLTRIM(QRY->CODAUTO)
					IF empty(_cendcons4) .and. !EMPTY(QRY->A1_XCODSAM)
						_cendcons4:=ALLTRIM(QRY->A1_XCODSAM)
					Endif
					
				ELSE
					_cendcons3:=ALLTRIM(QRY->CNPJNFC)+ALLTRIM(QRY->NFCOMPR)+ALLTRIM(QRY->SERNFC)
				ENDIF
			ENDIF
			
			  // EDUARDO 3.2.2010 - COLOCANDO NOME DA LOJA NO LUGAR DO CONSUMIDOR
			  // EDUARDO - COMO TAVA cLin:=cidregL4+"||"+_cnomcons+"|"+_cnomcons+"|"+_cendcons+"|"+_ccompcon+"|"+_cendcons3+"||"+_ccidcons+"|"
			  if !empty(QRY->ZZ4_CHVFIL)
			  	_c1_3 := posicione("SA1",1,xFilial("SA1")+substr(QRY->ZZ4_CHVFIL,7,8),"A1_NREDUZ")
			  	_c1_3 := alltrim(_c1_3)
			  else
				_c1_3 := ALLTRIM(QRY->A1_NREDUZ)
			  endif
			  _c1_7 := IIF(EMPTY(QRY->NFENTRADA),"","NFE: "+ALLTRIM(QRY->NFENTRADA))
			  _c1_8 := ""
			  			  
			  IF QRY->NFCOMPR<>''
			      IF cinfcaut='S'
   			          IF len(alltrim(_cendcons3))<=25
			              _c1_7 := _c1_7+" OS. SAM: "+alltrim(_cendcons3) 
			          ELSE
			              _c1_7 := _c1_7+" - "+left(alltrim(_cendcons3),32)			          
			          ENDIF    
			          IF len(alltrim(_cendcons4))<=25
			              _c1_8 := _c1_8+" COD.SAM: "+alltrim(_cendcons4) 
			          ELSE
			              _c1_8 := _c1_8+" - "+left(alltrim(_cendcons4),32)			          
			          ENDIF
			      Else                           
			          IF len(alltrim(_cendcons3))<=25
			              _c1_7 := _c1_7+" CNPJ/NFC: "+alltrim(_cendcons3)
			          Else
			              _c1_7 := _c1_7+" - "+left(alltrim(_cendcons3),32)
			          Endif    
			      Endif        
			  Endif
			_cendcons3:=""
			_cendcons4:=""
			  
			   IF EMPTY(ALLTRIM(QRY->B1_XCODAPC))
			     AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),ALLTRIM(QRY->ZZ4_IMEI),'',"APC CODE nao Preenchido. Prod/modelo : "+_codnewpro,"Corrija o cadastro produto. OK gravado no arquivo"})
		         //MsgAlert("Codigo APC CODE nao Preenchido para o produto/modelo : "+_codnewpro+" nessa OS. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
                 //Return
                 _lpassou:=.t.
               ENDIF     
               
               IF (!EMPTY(alltrim(_cproblem1)) .AND. EMPTY(alltrim(_crepair1))) 
         			     AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),ALLTRIM(QRY->ZZ4_IMEI),'','Para o PROBLEM FOUND(1) '+_cproblem1+' falta o Cod. REPAIR ACTION nessa OS.','Corrija o apontamento da OS :  '+ALLTRIM(QRY->MASC_CODE),'OK gravado no arquivo'})
		                 //MsgAlert("Codigo REF. DESIGNATOR nao Preenchido para o Peca :"+ALLTRIM(apartnum[n,5])+"  essa OS. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
                         //Return
                         _lpassou:=.t.
               ENDIF   
               
               IF (!EMPTY(alltrim(_cproblem2)) .AND. EMPTY(alltrim(_crepair2))) 
         			     AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),ALLTRIM(QRY->ZZ4_IMEI),'','Para o PROBLEM FOUND(2) '+_cproblem2+' falta  Cod. REPAIR ACTION.','Corrija o apontamento da OS :  '+ALLTRIM(QRY->MASC_CODE),'OK gravado no arquivo'})
		                 //MsgAlert("Codigo REF. DESIGNATOR nao Preenchido para o Peca :"+ALLTRIM(apartnum[n,5])+"  essa OS. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
                         //Return
                         _lpassou:=.t.
               ENDIF   

               IF (!EMPTY(alltrim(_crepair1)) .AND. EMPTY(alltrim(_cproblem1))) 
         			     AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),ALLTRIM(QRY->ZZ4_IMEI),'','Para o REPAIR ACTION(1) '+_crepair1+' falta  Cod. PROBLEM FOUND.','Corrija o apontamento da OS :  '+ALLTRIM(QRY->MASC_CODE),'OK gravado no arquivo'})
		                 //MsgAlert("Codigo REF. DESIGNATOR nao Preenchido para o Peca :"+ALLTRIM(apartnum[n,5])+"  essa OS. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
                         //Return
                         _lpassou:=.t.
               ENDIF   
               
               IF (!EMPTY(alltrim(_crepair2)) .AND. EMPTY(alltrim(_cproblem2))) 
         			     AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),ALLTRIM(QRY->ZZ4_IMEI),'','Para o REPAIR ACTION(2) '+_crepair2+' falta Cod. PROBLEM FOUND.','Corrija o apontamento da OS :  '+ALLTRIM(QRY->MASC_CODE), 'OK gravado no arquivo'})
		                 //MsgAlert("Codigo REF. DESIGNATOR nao Preenchido para o Peca :"+ALLTRIM(apartnum[n,5])+"  essa OS. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
                         //Return
                         _lpassou:=.t.
               ENDIF 
               
               //PARTUNMBERS    
			   If len(apartnum) > 0                
			     for n:=1 to len(apartnum)
			         //LINHA5
			         IF EMPTY(ALLTRIM(apartnum[n,5])) .AND. !EMPTY(ALLTRIM(apartnum[n,1]))
         			     AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),ALLTRIM(QRY->ZZ4_IMEI),ALLTRIM(apartnum[n,1]),'REF. DESIGNATOR nao Preenchido para a Peca : '+ALLTRIM(apartnum[n,1]), 'Corrija o cadastro do produto.OK gravado no arquivo'})
		                 //MsgAlert("Codigo REF. DESIGNATOR nao Preenchido para o Peca :"+ALLTRIM(apartnum[n,5])+"  essa OS. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
                         //Return
                         _lpassou:=.t.
                     ENDIF   
                 next
			   Endif
  
			IF !empty(QRY->ZZ4_MCLGER)
				AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),ALLTRIM(QRY->ZZ4_IMEI),'','IMEI gravado no MCLAIM '+left(QRY->ZZ4_MCLGER,8)+' - arquivo '+alltrim(substr(QRY->ZZ4_MCLGER,9,len(QRY->ZZ4_MCLGER)-8))+'.', 'OK gravado no arquivo'})
				_lpassou:=.t.
			ENDIF
			
               If _lpassou
			  
     			  cLin:=cidregL4+_cSepara+_cSepara+_c1_3+_cSepara+_cnomcons+_cSepara+_cendcons+_cSepara+_ccompcon+_cSepara+_c1_7+_cSepara+_c1_8+_cSepara+_ccidcons+_cSepara
	     		  cLin+=_cestcons+_cSepara+_ccepcons+_cSepara+_cSepara+_ctelcons+_cSepara+_cemacons+_cSepara+_cSepara+_cSepara+_ctranspo+_cSepara+"BR"+_cSepara+ALLTRIM(QRY->TRACKIN)+_cSepara+_ctrakout+_cSepara+ALLTRIM(QRY->MASC_CODE)+_cSepara
		    	  cLin+=_ccpfclie+_cSepara+coperador+_cSepara+ALLTRIM(ctransc)+_cSepara+ALLTRIM(QRY->B1_XCODAPC)+_cSepara+_codnewpro+_cSepara+_cSepara+_cSepara+IIF(QRY->ZZ4_OPEBGH $ "N06",'',ALLTRIM(LEFT(QRY->ZZ4_CARCAC,14)))+_cSepara+IIF(QRY->ZZ4_OPEBGH $ "N06",'',ALLTRIM(LEFT(QRY->ZZ4_CARCAC,14)))+_cSepara+IIF(QRY->ZZ4_OPEBGH $ "N06",'',ALLTRIM(QRY->ZZ4_IMEI))+_cSepara+IIF(Empty(QRY->ZZ4_SWAP),IIF(QRY->ZZ4_OPEBGH $ "N06",'',ALLTRIM(QRY->ZZ4_IMEI)), AllTrim(QRY->ZZ4_SWAP))+_cSepara+_cSepara+_cSepara+_cSepara
			      cLin+=alltrim(_cstrepmo)+_cSepara+_cSepara+_cSepara+_cdtbalca+_cSepara+LEFT(QRY->ZZ4_NFEHR,5)+_cSepara+_cSepara+_cSepara+_cdtdespc+_cSepara+_chrdespc+_cSepara+_cdtrepar+_cSepara+alltrim(_ctemprep)+_cSepara+alltrim(_ctcycler)+_cSepara+alltrim(_ctcyclec)+_cSepara+_cflagnfc+_cSepara+_cdtnfcom+_cSepara+_cSepara+_cSepara
			      cLin+=alltrim(csoftin)+_cSepara+alltrim(csoftout)+_cSepara+_ccodrecl+_cSepara+ALLTRIM(QRY->ZZ3_CODTEC)+_cSepara+alltrim(_cproblem1)+_cSepara+Iif(len(ALLTRIM(apartnum))> 0, alltrim(_cproblem2),'')+_cSepara+alltrim(_crepair1)+_cSepara+Iif(len(ALLTRIM(apartnum)) > 0, alltrim(_crepair2), '')+_cSepara+ALLTRIM(QRY->CODAUTO)+_cSepara+alltrim(cartime)+_cSepara+_cSepara+Iif (ALLTRIM(QRY->SPCPROJ) == "0","",ALLTRIM(QRY->SPCPROJ))+_cSepara+_cSepara+_cSepara+_cSepara+_cSepara+_cSepara+alltrim(cminumb)+_cSepara+_cSepara+_cSepara+_cSepara+_cSepara+_cSepara+_cSepara+_cSepara+_cSepara+cEOL
				_c1_3 := _c1_7 := _c1_8 := ""
			
			      If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	                  If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			             Return
	                  Endif
	              Endif
				
//				aAdd(_aMCLEnv, {QRY->ZZ4_IMEI, QRY->ZZ4_OS})
				aAdd(_aMCLEnv, xFilial("ZZ4")+left(QRY->ZZ4_IMEI,15)+space(5)+left(QRY->ZZ4_OS,6) )

			      //PARTUNMBERS    
			      If len(apartnum) > 0                
			        for n:=1 to len(apartnum)
			          //LINHA5
			          
                       cLin:=cidregL5+_cSepara+ccodmask+_cSepara+ALLTRIM(QRY->MASC_CODE)+_cSepara+ALLTRIM(apartnum[n,1])+_cSepara+STRZERO(apartnum[n,2],2)+_cSepara+STRZERO(apartnum[n,3],2)+_cSepara+ALLTRIM(apartnum[n,4])+_cSepara+ALLTRIM(apartnum[n,5])+_cSepara+ALLTRIM(apartnum[n,6])+_cSepara+ALLTRIM(apartnum[n,7])+_cSepara+ALLTRIM(apartnum[n,8])+_cSepara+_cSepara+_cSepara+cEOL
			  
			           If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	                    If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			               Return
	                    Endif
	                   Endif
			        next
			      Endif
				
			   Endif			   
			_c1_3 := _c1_7 := _c1_8 := _cendcons3 := _cendcons4 := ""

			   IncProc()	 
			
		    Else
			
		     IF empty(ctransc)
		        AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),ALLTRIM(QRY->ZZ4_IMEI),'','Transaction Code nao Preenchido','Verifique se ele esta na tabela ZZ3. OS nao gravada no arquivo'})
		        //MsgAlert("Transaction Code nao preenchido para OS : "+ALLTRIM(QRY->MASC_CODE)+". Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
                //Return
		     Endif
		    Endif
		
		    QRY->(dbSkip())
		Enddo
	Endif
	
	QRY->(dbCloseArea())	
	
	cLin:=cidregL9+_cSepara+_cSepara+_cSepara+_cSepara+cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	  	 Return
	   Endif
	Endif
	
	fClose(nHdl)
	Close(oGeraTxt)

// Ticket 6363 - Marcelo Munhoz - 11/06/2012
// Grava campo com data e nome do arquivo do MCLAIM. Utilizado para identificar se a NF excluida possui IMEI com MCLAIM gerado ou nao.
if len(_aMCLEnv) > 0 .and. upper(left(mv_par05,5)) <> "TESTE"
	_aAreaZZ4 := ZZ4->(getarea())
	_cMCLGER  := dtoc(dDataBase)+alltrim(mv_par05)
	ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
	for y := 1 to len(_aMCLEnv)
//		if ZZ4->(dbSeek(xFilial("ZZ4")+_aMCLEnv[y,1]+_aMCLEnv[y,2]))
		// Grava o ultimo nome do MCLAIM processado desde que o nome do arquivo nao comece com TESTE
		if ZZ4->(dbSeek(_aMCLEnv[y])) 
			reclock("ZZ4",.f.)
			ZZ4->ZZ4_MCLGER := _cMCLGER
			msunlock()
		endif
	next y
	restarea(_aAreaZZ4)
endif

Return

//Cria perguntas no SX1
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Data Atend Inicial?"	,"Data Atend Inicial?"	,"Data Atend Inicial?"	,"mv_ch1","D",08,0,0,"G","",""	,"",,"mv_par01",""			,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"02","Data Atend Final?"	,"Data Atend Final?"	,"Data Atend Final?"	,"mv_ch2","D",08,0,0,"G","",""	,"",,"mv_par02",""			,"","","",""		,"","",""		,"","","","","","","","")
//PutSX1(cPerg,"03","St. OS ? "			,"Status OS ?"			,"Status OS       ?"	,"mv_ch3","N",01,0,0,"C","",""	,"",,"mv_par03","Encerradas"	,"","","","Nao Encerradas"	,"","","Tudo"	,"","","","","","","","")
PutSX1(cPerg,"03","Data Saida Inicial?"	,"Data Saida Inicial?"	,"Data Saida Inicial?"	,"mv_ch3","D",08,0,0,"G","",""	,"",,"mv_par03",""			,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"04","Data Saida Final?"	,"Data Saida Final?"	,"Data Saida Final?"	,"mv_ch4","D",08,0,0,"G","",""	,"",,"mv_par04",""			,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"05","Nome Arquivo"		,"Nome Arquivo"			,"Nome Arquivo"			,"mv_ch5","C",40,0,0,"G","",""	,"",,"mv_par05",""			,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"06","Codigo OS"			,"Codigo OS"			,"Codigo OS"			,"mv_ch6","C",99,0,0,"G","",""	,"",,"mv_par06",""			,"","","",""		,"","",""		,"","","","","","","","")      
PutSX1(cPerg,"07","Gera SPC  ? "		,"Gera SPC ?"			,"Gera SPC       ?"		,"mv_ch7","N",01,0,0,"C","",""	,"",,"mv_par07","Sim"		,"","","","Não"		,"","","Todas"	,"","","","","","","","")
PutSX1(cPerg,"08","Formato arquivo"		,"Formato arquivo"		,"Formato arquivo"		,"mv_ch8","N",01,0,0,"C","",""	,"",,"mv_par08","Motorola"	,"","","","CSV"		,"","",""    	,"","","","","","","","")
                                                                                           
Return Nil
    
Static function qryzz3(cqual,cos,cimei,cfastnfix,csettnfix,ctransc,cswtin,cswtout)
cimei    :=alltrim(cImei) + space(20-len(alltrim(cImei)))
cos      :=alltrim(cos) + space(8-len(alltrim(cos)))                     

dbselectarea("ZZ3")
If ZZ3->(dbSeek(xFilial("ZZ3") + cimei + left(cos,6)))
	While ZZ3->(!eof()) .and. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .and. cimei == ZZ3->ZZ3_IMEI .and. left(cos,6) == left(ZZ3->ZZ3_NUMOS,6)
		   If ZZ3->ZZ3_STATUS == '1'
 		      //Alterado IF abaixo, acrescentado variaveis cfastnfix e csettnfix - Edson Rodrigues - 16/04/10 
		      If (cqual=="1" .AND. ZZ3->ZZ3_FASE1 $ alltrim(cfastnfix) .AND. ZZ3->ZZ3_CODSET $ alltrim(csettnfix) .AND. !EMPTY(ctransc))
       		   ctransc:=ctransc 
       		   
  		      //Alterado ELSEIF abaixo, acrescentado variaveis cfastnfix e csettnfix - Edson Rodrigues - 16/04/10         		           		   
       	      Elseif (cqual=="2" .AND. ZZ3->ZZ3_FASE1 $ alltrim(cfasouinf) .AND. ZZ3->ZZ3_CODSET $ alltrim(csettnfix))
       	       csoftin :=cswtin
               csoftout:=cswtout
               _ccodrecl:= IIF(empty(ALLTRIM(QRY->CODRECL)),"C0022",ALLTRIM(QRY->CODRECL))
               cartime :=ZZ3->ZZ3_ARTIME
               cminumb :=IIF(EMPTY(ZZ3->ZZ3_MINUMB),"NA",ALLTRIM(ZZ3->ZZ3_MINUMB))
               
              Elseif  cqual=="3"    
                 IF !EMPTY(ctransc) 
                   ctransc:=ctransc 
                 ENDIF    
                 IF !EMPTY(cswtout)     
                  csoftout :=cswtout
                 ENDIF
                 IF !EMPTY(ZZ4->ZZ4_DEFINF)  
                  _ccodrecl:=IIF(empty(ALLTRIM(QRY->CODRECL)),"C0022",ALLTRIM(QRY->CODRECL))
		         Endif                                                
		      Endif
		   Endif  
		   ZZ3->(dbSkip())
    Enddo     
ENDIF

return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QRYSZ9   ºAutor  ³Microsiga           º Data ³  04/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function qrysz9(cqual,cos,cimei,coperbgh,clab)                

      Private _cNexSint:=_cNexSolu:=_codrefd:=_cnumrefd:=_cPartN:=""
      _cproblem1:=_cproblem2:=_crepair1:=_crepair2 :=_creprepl:=""
      _ncount:=0
      _cfase:=''
      _csetor:=''
      _cseqz9:=''
      _cpartold:=''
       apartnum:={}
       cimei  :=alltrim(cImei) + space(20-len(alltrim(cImei)))
       cos    :=alltrim(cos) + space(8-len(alltrim(cos)))
       nposprtn := 0
       cproblem := "" 
       creparo  := ""

Dbselectarea("SZ9")

If SZ9->(dbSeek(xFilial("SZ9") + cimei + left(cos,6)))
	While SZ9->(!eof()) .and. (SZ9->Z9_FILIAL == xFilial("SZ9")) .And. (SZ9->Z9_IMEI == cimei) .And. (LEFT(SZ9->Z9_NUMOS,6) == left(cos,6))
	//   	if SZ9->Z9_SYSORIG == '1'
	//	 	SZ9->(dbSkip())
	//	   	loop
	//	endif
		_cseqz9:=SZ9->Z9_SEQ
		_cNexSint:=IIF(EMPTY(SZ9->Z9_SYMPTO),_cNexSint,SZ9->Z9_SYMPTO)
		_cNexSolu:=IIF(EMPTY(SZ9->Z9_ACTION),_cNexSolu,SZ9->Z9_ACTION)
		IF SZ9->Z9_STATUS=='1'
			dbselectarea("ZZ3")
			ZZ3->(dbSetOrder(1))
			If ((ZZ3->(dbSeek(xFilial("ZZ3") + cimei + cos+_cseqz9)) .or. ZZ3->(dbSeek(xFilial("ZZ3") + cimei + left(cos,6)+_cseqz9))  .or.  ZZ3->(dbSeek(xFilial("ZZ3") + cimei + left(cos,6)+'01'+_cseqz9)))) .AND. ZZ3->ZZ3_ESTORN <> 'S'
				_cfase:=ZZ3->ZZ3_FASE1
				_csetor:=ZZ3->ZZ3_CODSET
				While ZZ3->(!eof()) .and. (ZZ3->ZZ3_FILIAL == xFilial("ZZ3")) .And. (ZZ3->ZZ3_IMEI == cimei) .And. (left(ZZ3->ZZ3_NUMOS,6) == left(cos,6)) .AND. (ZZ3->ZZ3_SEQ == _cseqz9)
					IF ZZ3->ZZ3_STATUS=='1' .and. ZZ3->ZZ3_ESTORN <> 'S'
						/*
						// Eliminada regravacao de problema e reparo atraves da geracao do MCLAIM uma vez que estes campos ja estao sendo gravados corretamente durante os apontamentos de fases. Marcelo Munhoz. 01/08/2012
						dbselectarea("ZZ1")
						ZZ1->(dbSetOrder(1))
						If ZZ1->(dbSeek(xFilial("ZZ1") +cLab+ _csetor+_cfase))
							IF ZZ1->ZZ1_TIPO=="1"
								_ncount++
								IF _ncount <= 2
								   	//If Empty(AllTrim(_cproblem1)) .And. Empty(AllTrim(_crepair1))

										// Atualiza campo defeito informado pelo cliente (ZZ4_PROBLE / ZZ4_REPAIR)
										U_PROREPA(cimei,cos,cLab)
									
										_cproblem1 := ZZ4->ZZ4_PROBLE
										_crepair1  := ZZ4->ZZ4_REPAIR
				
									//EndIf                     
								Endif
							Endif
						Endif
						*/
						dbselectarea("SZ9")
						If !empty(SZ9->Z9_PARTNR)
							_codrefd :=Posicione("SB1",1,xFilial("SB1")+LEFT(SZ9->Z9_PARTNR,15), "B1_CREFDES")
							_cnumrefd :=Posicione("SB1",1,xFilial("SB1")+LEFT(SZ9->Z9_PARTNR,15), "B1_NREFDES")
							If empty(_codrefd)
								_codrefd:=refdesig(LEFT(SZ9->Z9_PARTNR,15))
							Endif
							
							DO CASE
								CASE (empty(SZ9->Z9_RESREPL) .AND. SZ9->Z9_USED="0" .AND. SZ9->Z9_QTY > 0) .OR. SZ9->Z9_RESREPL="2"
									_creprepl:="RPC"
								CASE (empty(SZ9->Z9_RESREPL) .AND. SZ9->Z9_USED="1" .AND. SZ9->Z9_QTY > 0) .OR. SZ9->Z9_RESREPL="1"
									_creprepl:="RSL"
							ENDCASE
							If !alltrim(SZ9->Z9_PARTNR) $ alltrim(_cpartold)
								_cPecFail := IIF(!EMPTY(_cNexSolu),Posicione("SZ8",2,xFilial("SZ8") + cLab + _cNexSolu, "Z8_PECFAIL"),_cNexSolu)
								_cPecFail := iif(empty(_cPecFail),"R",_cPecFail)
								AADD(apartnum,{SZ9->Z9_PARTNR,SZ9->Z9_QTY,0,IIF(SZ9->Z9_USED =="0","R","F"),_codrefd, _cnumrefd,_cPecFail,_creprepl})
							Else
								nposprtn :=  Ascan(apartnum, { |X| X[1] = SZ9->Z9_PARTNR } )
								If nposprtn > 0
									apartnum[nposprtn,2] += SZ9->Z9_QTY
								EndIf
							Endif
						Endif
					ENDIF
					
				   	//If Empty(AllTrim(_cproblem1)) .And. Empty(AllTrim(_crepair1))
					/*
					// Eliminada regravacao de problema e reparo atraves da geracao do MCLAIM uma vez que estes campos ja estao sendo gravados corretamente durante os apontamentos de fases. Marcelo Munhoz. 01/08/2012
						// Atualiza campo defeito informado pelo cliente (ZZ4_PROBLE / ZZ4_REPAIR)
						U_PROREPA(cimei,cos,cLab)
					
						_cproblem1 := ZZ4->ZZ4_PROBLE
						_crepair1  := ZZ4->ZZ4_REPAIR
				
					//EndIf    
					
					IF _cproblem1=_cproblem2 .and. _crepair1=_crepair2
						_cproblem2 :=""
						_crepair2  :=""
					Endif
					
					*/
					_cpartold := _cpartold+"/"+alltrim(SZ9->Z9_PARTNR)
					ZZ3->(dbSkip())
				EndDo
			ENDIF
		ENDIF
		SZ9->(dbSkip())
	EndDo
Else
	/*
	// Eliminada regravacao de problema e reparo atraves da geracao do MCLAIM uma vez que estes campos ja estao sendo gravados corretamente durante os apontamentos de fases. Marcelo Munhoz. 01/08/2012
	
//If Empty(AllTrim(_cproblem1)) .And. Empty(AllTrim(_crepair1))

	// Atualiza campo defeito informado pelo cliente (ZZ4_PROBLE / ZZ4_REPAIR)
	U_PROREPA(cimei,cos,cLab)
			
	_aAreaZZ4 := ZZ4->(getarea())
	ZZ4->(dbsetorder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
	If ZZ4->(DbSeek(xFilial("ZZ4") + cImei + cOs))
		_cproblem1 := ZZ4->ZZ4_PROBLE
		_crepair1  := ZZ4->ZZ4_REPAIR
	else
		_cproblem1 := QRY->ZZ4_PROBLE
		_crepair1  := QRY->ZZ4_REPAIR
	endif
	restarea(_aAreaZZ4)
	*/
	
Endif

Return	  
                                                            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ REFDESIG ºAutor  ³Microsiga           º Data ³  04/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function refdesig(_cpartnr)
   _crefdes:=""
   _cqryrfd:=""                            
   
    If Select("QRYREFD") > 0
	   QRYREFD->(dbCloseArea())
    EndIf
   
   _cqryrfd:="  SELECT B1_CREFDES FROM "+RetSqlName("SB1")+" WHERE  B1_FILIAL='"+XFILIAL("SB1")+"' AND B1_XCODFAB='"+alltrim(_cpartnr)+"' AND D_E_L_E_T_='' "
   
   TCQUERY _cqryrfd NEW ALIAS QRYREFD
   
   dbSelectArea("QRYREFD")
   dbGoTop()
   
   While !QRYREFD->(EOF())
      If !Empty(QRYREFD->B1_CREFDES)
         _crefdes:=QRYREFD->B1_CREFDES
      Endif
	  QRYREFD->(dbSkip())
   EndDo        
   
return(_crefdes)
