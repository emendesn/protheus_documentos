#INCLUDE 'RWMAKE.CH' 
#INCLUDE "topconn.ch"              
#include "tbiconn.ch" 
#DEFINE OPEN_FILE_ERROR -1
#define ENTER CHR(13)+CHR(10)           


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IMPDEF   �Autor  �Paulo Francisco     � Data �  17/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para importar a Reclamacao do Cliente  via arquivo���
���          � CSV e atualizar as tabelas ZZM do Protheus.                ���  
�������������������������������������������������������������������������͹��
���          � Vinicius - Delta Decis�o - 07/07/2014					  ��� 
���          � Altera��o realizada pela necessidade de se 				  ��� 
���          � gerar automaticamente a importa��o - GLPI 1053			  ��� 
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function IMPDEFCLI()

	local _nRegImp  	:= 0 
	Local cIn	 		:= ""
	Local cOutBkp       := "" 
	Local cServBKP		:= ""
	Local cDirBkpArq	:= "" 
	Local cBKP			:= ""
	local _aAreaZZM  	:= {}
	Local cQryExecUp 	:= "" 
	Local cBody		 	:= ""
	Local cQryExec      := ""
	Local cEmp 			:= ""
	Local cFil 			:= ""
	Local nLab			:= 0

	Conout("Importa��o de Arquivo .CSV ")
	Conout("Este schedule executa a importa��o do Arquivo .CSV e ")
	Conout("Atualiza os arquivos ZZM.")
	Conout("Favor remover todos os cabe�alhos e n�o inserir dados em brancos ")  
	
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "06" TABLES "ZZG","ZZM","ZZ4"  
	
	//_aAreaZZM  := ZZM->(GetArea())  
	
	/*If nLab == 1 // Nextel/Motorola*/ 
	
		cIn	 	:= SuperGetMV("BH_IDFINNM",  ,"\\BGH005\relato\Importacao_Def_Nextel_Motorola\Inbound\")
		cOutBkp	:= SuperGetMV("BH_IDFOUNM",  ,"\\BGH005\relato\Importacao_Def_Nextel_Motorola\Outbound_bkp\") 		
		cServBKP:= SuperGetMV("BH_IDEFBKP",  ,"\\BGH005\Microsiga\protheus_data\system\Importacao_Def_Nextel_Motorola\")   
		
	/*ElseIf nLab == 2 // Sony //A pedido de Edson, retirado tratamento para Sony
	
		cIn	 	:= SuperGetMV("BH_IDFINS",  ,"\system\Importacao_Def_Sony\Inbound\")
		cOutBkp	:= SuperGetMV("BH_IDFOUS",  ,"\system\Importacao_Def_Sony\Outbound_bkp\")  
	
	EndIf*/	
		
	aDirect := Directory(cIn+"*.CSV*")
	
	For nY := 1 to Len( aDirect ) 			
	    
	   	cDirArq := Alltrim(cIn+aDirect[nY][1]) 
		cNomArq := Alltrim(aDirect[nY][1])
		
		cDestArq:= Alltrim(cOutBkp+aDirect[nY][1])
		
		cDirBkpArq := Alltrim(cIn+aDirect[nY][1])
		
		cBKP	   := cServBKP+aDirect[nY][1]						
		
		ZZG->(dbSetOrder(1))
		ZZM->(dbSetOrder(1))
		
		if !file(cDirArq)  
			cBody += "Arquivo " + cNomArq + " nao encontrado. Arquivo n�o processado.Favor verificar." + CHR(13)+CHR(10) + CHR(13)+CHR(10)
			Conout("Arquivo " + cNomArq + " nao encontrado. Arquivo n�o processado.Favor verificar.")
			Loop
		endif		                                    
		
		If FT_FUSE( cDirArq ) = OPEN_FILE_ERROR 
			cBody += "Erro na abertura do arquivo " + cNomArq + ". Arquivo n�o processado.Favor verificar." + CHR(13)+CHR(10) + CHR(13)+CHR(10)
			Conout("Erro na abertura do arquivo " + cNomArq + ". Arquivo n�o processado.Favor verificar.")
			If !__CopyFile(cDirArq, cDestArq)
				cBody += "Arquivo " + cNomArq + " n�o foi copiado para seu diret�rio de destino " + cOutBkp + " .Arquivo n�o processado." + CHR(13)+CHR(10) + CHR(13)+CHR(10)
				Conout("Arquivo " + cNomArq + " n�o foi copiado para seu diret�rio de destino " + cOutBkp + " .Arquivo n�o processado.")
				Loop
			EndIf
			FT_FUSE( cDirArq )
			FERASE(cDirArq)
			Loop
		Endif 
		
		If !__CopyFile(cDirBkpArq, cBKP)			
			cBody += "Arquivo " + cNomArq + " n�o foi copiado para seu diret�rio de backup " + cServBKP + " .Arquivo n�o processado." + CHR(13)+CHR(10) + CHR(13)+CHR(10) 
			Conout("Arquivo " + cNomArq + " n�o foi copiado para seu diret�rio de backup " + cServBKP + " .Arquivo n�o processado.")
			Loop			
		EndIf
		
		clotirl := GetSx8Num("ZZM","ZZM_IMEI")
		ConfirmSX8()
		
		While !FT_FEOF()
			cImei := cDefrec := ddataOs := ""
			lPass :=.t.
			lMsErroAuto := .F.
			lPass :=.t.
			
			//�����������������������������Ŀ
			//� L� linha do arquivo retorno �
			//�������������������������������
			xBuffer := FT_FREADLN()
			
			IncProc()
			
			nDivi   := At(";",xBuffer)
			cImei    := Substr(xBuffer,1,  nDivi - 1)
			
			// Defeito Reclamado 
			xBuffer  := Substr(xBuffer , nDivi+1)
			nDivi    := At(";",xBuffer)
			cDefrec  := Substr(xBuffer,1,  nDivi - 1)
			
			// Data da OS  
			xBuffer  := Substr(xBuffer , nDivi+1)
			nDivi    := At(";",xBuffer)
			ddataOS  := Ctod(xBuffer)
			
			// Alterado por M.Munhoz em 27/03/2012 para nao importar defeitos com data de OS inferior a defeitos ja existentes
			// Ticket 4782 - Fernando Luciano / Luiz Reis
			if select("QRY2") > 0
				QRY2->(dbCloseArea())
			endif
			_cQry2 := " SELECT MAX(ZZM_DATAOS) ZZM_DATAOS  "
			_cQry2 += " FROM   "+retsqlname("ZZM")+" AS ZZM "
			_cQry2 += " WHERE  ZZM.D_E_L_E_T_ = '' "
			_cQry2 += "        AND ZZM_FILIAL = '"+xFilial("ZZM")+"' "
			_cQry2 += "        AND ZZM_IMEI   = '"+cImei+"' "
			_cQry2 += "        AND ZZM_LAB    = '2' "//+Iif(nLab == 1, "2","1")+"' " //A pedido de Edson, retirado tratamento para Sony
			//_cQry2 += "        AND ZZM_MSBLQL = '2' " 
			dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry2), "QRY2", .F., .T.)
			TcSetField("QRY2", "ZZM_DATAOS", "D")
			QRY2->(dbGoTop())
			if QRY2->ZZM_DATAOS <= ddataOs
		//		apMsgStop('O defeito a ser importado possui data de OS inferior a apontamentos j� existentes. IMEI: '+cImei+' - Data de OS existente: '+dtoc(QRY2->ZZM_DATAOS)+' - Data de OS a importar: '+dtoc(ddataOs),'Defeito n�o importado')
		//	else
		
			   	Begin Transaction
				RecLock("ZZM",.T.)
				
				ZZM->ZZM_FILIAL		:= XFILIAL("ZZM") //"02"
				ZZM->ZZM_IMEI 		:= cImei
				ZZM->ZZM_DEFINF 	:= cDefrec
				ZZM->ZZM_DATAOS		:= ddataOs
				ZZM->ZZM_MSBLQL		:= "2"
				ZZM->ZZM_LAB		:= "2"//Iif(nLab == 1, "2","1")//A pedido de Edson, retirado tratamento para Sony
				msunlock()
				_nRegImp++
				
				End Transaction
		
				//cQryExec := "DECLARE @IMEI VARCHAR(15), @RECNO AS VARCHAR(1000), @DATA VARCHAR(08), @COUNT VARCHAR(03), @LAB VARCHAR(1) "
				cQryExec := "DECLARE @IMEI VARCHAR(25), @RECNO AS VARCHAR(1000), @DATA VARCHAR(08), @COUNT VARCHAR(03), @LAB VARCHAR(1) "
				
				cQryExec += "SET @IMEI  = '"+ cImei +"' "
				cQryExec += "SET @DATA  = '"+ Dtos(ddataOs) +"' "
				cQryExec += "SET @LAB   = '2' "//+Iif(nLab == 1, "2","1") + "' "//A pedido de Edson, retirado tratamento para Sony
				cQryExec += "SET @RECNO = ( SELECT TOP 1 R_E_C_N_O_		FROM ZZM020 WHERE D_E_L_E_T_ = ''		AND ZZM_MSBLQL = '2' AND ZZM_IMEI = @IMEI ORDER BY R_E_C_N_O_ DESC) "
				cQryExec += "SET @COUNT = ( SELECT TOP 1 COUNT(*)CONTA	FROM ZZM020 WHERE D_E_L_E_T_ = ''		AND ZZM_MSBLQL = '2' AND ZZM_IMEI = @IMEI GROUP BY ZZM_IMEI HAVING COUNT(*)>1 ORDER BY CONTA DESC) "
				
				cQryExec += "If @COUNT >1 "
				cQryExec += "BEGIN  "
				cQryExec += "	UPDATE "+ RetSqlName("ZZM")
				cQryExec += "	SET ZZM_MSBLQL = '1' "
				cQryExec += "	WHERE ZZM_IMEI = @IMEI "
				cQryExec += "	AND R_E_C_N_O_ < @RECNO "
				cQryExec += "	AND ZZM_LAB = @LAB "
				cQryExec += "END "
				
				TcSqlExec(cQryExec)
				TCRefresh(RETSQLNAME("ZZM"))
		
			endif
		
			FT_FSKIP()
		EndDo
		
		//UPtemp()
		
		cQryExecUp := "EXEC SP_IMPDEFCLI " + ENTER
		
		TcSqlExec(cQryExecUp)
		
		cBody += "Arquivo " + cNomArq + " importado com sucesso!" + CHR(13)+CHR(10) + CHR(13)+CHR(10) 
		
		__CopyFile(cDirArq, cDestArq)
		
		FT_FUSE()
		FERASE(cDirArq)	
	
	Next nY 
/*	
	If !Empty(cBody)			
		U_ENVIAEMAIL("Importa��o Autom�tica de Planilha de Reclama��o do Cliente - Status de Processamento",;
		"paulo.francisco@bgh.com.br;fernando.luciano@bgh.com.br;edson.rodrigues@bgh.com.br;luiz.reis@bgh.com.br;vleonardo@deltadecisao.com.br",;
		"",;
		cBody,;
		"")
	EndIf  	
*/	
	If !Empty(cBody)			
		U_ENVIAEMAIL("Importa��o Autom�tica de Planilha de Reclama��o do Cliente - Status de Processamento",;
		"impdefcli@bgh.com.br",;
		"",;
		cBody,;
		"")
	EndIf  	

	rpcclearenv()
	
	Conout("Fim de processamento de Importa��o de Arquivo .CSV ") 


return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UPtemp    � Autor �Paulo Lopez         � Data �  17/11/10   ���
�������������������������������������������������������������������������͹��
���Descricao �GRAVACAO DE DADOS NAS TABELAS PERTINENTES                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/
Static Function UPtemp()

Local cQryExecUp
Local cQryExecUpZ4
Local cQryExecUpZ3
Local cQryExecUpZA
Local cQryExecUpZM

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

cQryExecUp := "IF OBJECT_ID(N'tempdb..##TEMPTM', N'U') IS NOT NULL " + ENTER
cQryExecUp += "DROP TABLE ##TEMPTM; " + ENTER

cQryExecUp += "SELECT ZM.ZZM_IMEI		AS ZM_IMPIMEI, " + ENTER
cQryExecUp += "		ZM.ZZM_DEFINF	AS ZM_DEFINF, " + ENTER
cQryExecUp += "		ZM.R_E_C_N_O_	AS ZM_RECNO, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_IMEI	AS Z4_IMEI, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_DEFINF	AS Z4_DEFINF, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_OS		AS Z4_OS, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_CODCLI	AS Z4_CODCLI, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_LOJA	AS Z4_LOJA, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_CODPRO	AS Z4_CODPRO, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_NFENR	AS Z4_NFENR, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_NFESER	AS Z4_NFESER, " + ENTER
cQryExecUp += "		ZZ4.ZZ4_FILIAL	AS Z4_FILIAL, " + ENTER
cQryExecUp += "		ZZ4.R_E_C_N_O_	AS Z4_RECNO " + ENTER
cQryExecUp += "INTO ##TEMPTM " + ENTER
cQryExecUp += "FROM " + RetSqlName("ZZM") + " ZM (NOLOCK) " + ENTER
cQryExecUp += "INNER JOIN " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) " + ENTER
cQryExecUp += "ON(ZM.ZZM_IMEI = ZZ4.ZZ4_IMEI AND ZZ4.ZZ4_STATUS <= '5' AND ZZ4.D_E_L_E_T_ = ZM.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = ZM.ZZM_FILIAL) " + ENTER
cQryExecUp += "WHERE ZM.D_E_L_E_T_ = '' " + ENTER
cQryExecUp += "AND ZZM_MSBLQL = '2' " + ENTER
cQryExecUp += "AND ZZM.ZZM_FILIAL = '" + xFilial("ZZM") + "' " + ENTER
cQryExecUp += "AND ZZ4.ZZ4_FILIAL = '" + xFilial("ZZ4") + "' " + ENTER
cQryExecUp += "AND ZZ4.ZZ4_DEFINF = '' " + ENTER
cQryExecUp += "ORDER BY 1 " + ENTER

TcSqlExec(cQryExecUp)

cQry	:= "SELECT TOP 1 Z4_IMEI IMEI " + ENTER
cQry	+= "FROM ##TEMPTM "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

If !Empty(QRY->IMEI)

	cQryExecUpZ4 := "UPDATE " + RetSqlName("ZZ4") + ENTER
	cQryExecUpZ4 += "SET ZZ4_DEFINF = SUBSTRING(TM.ZM_DEFINF,1,5), ZZ4_SEQZZ3 = '03' " + ENTER
	cQryExecUpZ4 += "FROM " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) " + ENTER
	cQryExecUpZ4 += "INNER JOIN ##TEMPTM TM " + ENTER
	cQryExecUpZ4 += "ON(TM.Z4_RECNO = R_E_C_N_O_) " + ENTER
	cQryExecUpZ4 += "WHERE D_E_L_E_T_ = '' " + ENTER
	
	TcSqlExec(cQryExecUpZ4)
	TCRefresh(RETSQLNAME("ZZ4"))
	
	cQryExecUpZ3 += "UPDATE " + RetSqlName("ZZ3") + ENTER
	cQryExecUpZ3 += "SET ZZ3_DEFINF = SUBSTRING(TM.ZM_DEFINF,1,5) " + ENTER
	cQryExecUpZ3 += "FROM " + RetSqlName("ZZ3") + " ZZ3 (NOLOCK) " + ENTER
	cQryExecUpZ3 += "INNER JOIN ##TEMPTM TM (NOLOCK) " + ENTER
	cQryExecUpZ3 += "ON(TM.Z4_IMEI = ZZ3.ZZ3_IMEI AND TM.Z4_OS = ZZ3.ZZ3_NUMOS AND TM.Z4_FILIAL = ZZ3.ZZ3_FILIAL) " + ENTER
	cQryExecUpZ3 += "WHERE D_E_L_E_T_ = '' " + ENTER
	
	TcSqlExec(cQryExecUpZ3)
	TCRefresh(RETSQLNAME("ZZ3"))
	
	cQryExecUpZA += "UPDATE " + RetSqlName("SZA") + ENTER + ENTER
	cQryExecUpZA += "SET ZA_DEFRECL = SUBSTRING(TM.ZM_DEFINF,1,5) " + ENTER
	cQryExecUpZA += "FROM " + RetSqlName("SZA") + " SZA (NOLOCK) " + ENTER
	cQryExecUpZA += "INNER JOIN ##TEMPTM TM " + ENTER
	cQryExecUpZA += "ON(TM.Z4_CODCLI = SZA.ZA_CLIENTE AND TM.Z4_LOJA = SZA.ZA_LOJA AND TM.Z4_CODPRO = SZA.ZA_CODPRO AND TM.Z4_IMEI = SZA.ZA_IMEI " + ENTER
	cQryExecUpZA += "AND TM.Z4_NFENR = SZA.ZA_NFISCAL AND TM.Z4_NFESER = SZA.ZA_SERIE AND TM.Z4_FILIAL = SZA.ZA_FILIAL) " + ENTER
	cQryExecUpZA += "WHERE SZA.D_E_L_E_T_ = '' " + ENTER
	
	TcSqlExec(cQryExecUpZA)
	TCRefresh(RETSQLNAME("SZA"))
	
	cQryExecUpZM += "UPDATE " + RetSqlName("ZZM") + ENTER
	cQryExecUpZM += "SET ZZM_MSBLQL = '1' " + ENTER
	cQryExecUpZM += "FROM " + RetSqlName("ZZM") + " ZM (NOLOCK) " + ENTER
	cQryExecUpZM += "INNER JOIN ##TEMPTM TM " + ENTER
	cQryExecUpZM += "ON(TM.ZM_RECNO = ZM.R_E_C_N_O_) " + ENTER
	cQryExecUpZM += "WHERE D_E_L_E_T_ = '' " + ENTER
	
	TcSqlExec(cQryExecUpZM)
	TCRefresh(RETSQLNAME("ZZM"))
	
	cQryExecMail := "EXEC msdb.dbo.sp_send_dbmail " + ENTER
	cQryExecMail += "@profile_name = 'Protheus', " + ENTER
	cQryExecMail += "@recipients='paulo.francisco@bgh.com.br;fernando.luciano@bgh.com.br;edson.rodrigues@bgh.com.br', " + ENTER 
	cQryExecMail += "@subject = 'E-mail Importa��o de Defeitos Reclamados', " + ENTER
	cQryExecMail += "@body = 'Abaixo Defeitos reclamados imputados', " + ENTER
	cQryExecMail += "@query = 'USE PROTHEUS; SELECT ZM_IMPIMEI AS IMEI, ZM_DEFINF DEFINF, ZM_RECNO SEQ,  ''>> '', Z4_IMEI IMEI1,Z4_DEFINF DEFINF1, Z4_OS OS1, Z4_CODCLI CLIENTE1, Z4_LOJA LOJA1, Z4_CODPRO PROD1, Z4_NFENR NFE1, Z4_NFESER SERIE1, Z4_RECNO SEQ1 FROM ##TEMPTM' " + ENTER
	
	TcSqlExec(cQryExecMail)
	

EndIf 
QRY->(dbCloseArea())

Return*/

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �USERID    � Autor �Paulo Lopez         � Data �  17/11/10   ���
�������������������������������������������������������������������������͹��
���Descricao �CADASTROS PARA MENU DINAMICO                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/

User Function UserID()

Private cPerg       := "AXZZ3"
//���������������������������������������������������������������������Ŀ
//|Cria dicionario de perguntas                                         �
//�����������������������������������������������������������������������
//fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return
Endif

Do Case
	
	Case mv_par01 == 1
		//���������������������������������������������������������������������Ŀ
		//|Modulo para Administradores                                          �
		//�����������������������������������������������������������������������
		lUsrAdmi  := .T.
		
	Case mv_par01 == 2
		//���������������������������������������������������������������������Ŀ
		//|Modulo para Administradores											�
		//�����������������������������������������������������������������������
		lUsrAdmi  := .F.
		
EndCase

Return*/  
