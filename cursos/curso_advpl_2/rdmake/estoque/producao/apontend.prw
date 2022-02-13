#include "protheus.ch"
#include "VKey.ch"
#Include "Colors.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#include "APVT100.CH"

#define ENTER CHR(10)+CHR(13)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ApontEnd � Autor �Luciano Siqueira    � Data �  15/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao �Tela para Apontamento de Endere�amento da Master no Estoque ���
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
/*/

User Function ApontEnd()

Private cVarMas  	:= Replicate(' ',20)
Private cVarEnd  	:= Replicate(' ',20)
Private _UserId     := __cUserID
Private _CodTec 	:= Posicione("AA1",4,xFilial("AA1") + _UserId,"AA1_CODTEC")
Private _aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private _lUsrAut 	:= .F.
Private _cOpera
Private	_cEtqMa
Private	_cEnd
Private	_cRefGar
Private	_cCodPro
Private	_cArmz


u_GerA0003(ProcName())

//���������������������������������������������������������������������Ŀ
//� Valida acesso de usuario                                            �
//�����������������������������������������������������������������������
For i := 1 to Len(_aGrupos)
	
	//Usuarios de Autorizado
	
	If AllTrim(GRPRetName(_aGrupos[i])) $ "Administradores#Estoque_ACD"
		
		_lUsrAut  := .T.
		
	EndIf
	
Next i

//���������������������������������������������������������������������Ŀ
//| Usuario Nao Autorizado                                              |
//�����������������������������������������������������������������������

If !_lUsrAut
	
	
	VTBEEP(3)
	VTAlert("------Tecnico n�o Autorizado, Entrar em contato com Supervisor.--------","Alerta",.t.,2500)
	cVarMas	:= Replicate(' ',20)
	cVarEnd	:= Replicate(' ',20)
	
	VTClear()
	
	Return()
	
EndIf

If Empty(AllTrim(_CodTec))
	
	VTBEEP(3)
	VTAlert("------Tecnico n�o cadastrado, Entrar em contato com Supervisor.--------","Alerta",.t.,2500)
	cVarMas	:= Replicate(' ',20)
	cVarEnd	:= Replicate(' ',20)
	
	VTClear()
	
	Return()
	
EndIf


CBChkTemplate()

While .t.
	VTClear
	nLin:= -1
	@ ++nLin,0 VTSAY "Coletor"
	If ! ApontEndA()
		Exit
	EndIf
	VTRead
	If (VTLastKey()==27)
		If ! VTYesNo('Confirma a Saida?','Aten��o')
			loop
		EndIf
		Exit
	EndIf
End

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ApontEndA � Autor �Luciano Siqueira    � Data �  15/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao �Tela para Apontamento Endere�o - COLETOR (ACD)              ���
���          �              ETQ MASTER e Endere�o                         ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ApontEndA()

Local lRet	:=	.T.

VTClear()
VTClearBuffer()

DLVTCabec("Endere�o",.F.,.F.,.T.)
@ 01, 00 VTGet cVarEnd Pict '@!'	Valid ApontEndd(@cVarEnd)
VTRead

DLVTCabec("Master",.F.,.F.,.T.)
@ 03, 00 VTGet cVarMas Pict '@!'	Valid ApontEndb(@cVarEnd,@cVarMas,'1')
VTRead

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ApontEndb �Autor  � Luciano Siqueira   � Data � 07/02/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao Apontamento                         			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ApontEndb(cCodEnd,cCodBar,nOpc)

Local _lRet		:= .T.

#IFDEF TOP
	Local xVaTemp		:= GetNextAlias()
	Local xVaTemp1		:= GetNextAlias()
	Local xlQuery		:= .F.
#ENDIF

If nOpc == '1'
	
	#IFDEF TOP
		xlQuery  := .T.
		BeginSql alias xVaTemp
			SELECT TOP 1 ZZ4.ZZ4_ETQMEM AS MASTER, ZZO_REFGAR AS REFGAR, ZZ4.ZZ4_OPEBGH AS OPERA,
			ZZ4_CODPRO AS CODPRO, ZZ4_LOCAL AS ARMZ
			FROM %table:ZZ4% ZZ4
			JOIN %table:ZZJ% ZZJ ON
			ZZJ.ZZJ_FILIAL = %xfilial:ZZJ% 				AND
			ZZ4.ZZ4_OPEBGH = ZZJ.ZZJ_OPERA   			AND
			ZZJ.%notDel%
			JOIN %table:ZZO% ZZO ON
			ZZO_FILIAL =%xfilial:ZZO% AND
			//ZZO_MODELO=ZZ4_CODPRO AND
			ZZO_IMEI=ZZ4_IMEI AND
			ZZO_CARCAC=ZZ4_CARCAC AND
			ZZO_NUMCX=ZZ4_ETQMEM AND
			ZZO_STATUS = %exp: '2'% AND
			ZZO.%notDel%
			WHERE   ZZ4.ZZ4_FILIAL = %xfilial:ZZ4% 		AND
			ZZ4.ZZ4_STATUS = %exp: '3'%					AND
			ZZ4.ZZ4_DOCSEP = %exp: ''%					AND
			//ZZ4.ZZ4_ENDES = %exp: ''%					AND
			ZZ4.ZZ4_ETQMEM = %exp: cVarMas%				AND
			ZZ4.%notDel%
		EndSql
		
		

/*
//�������������������������������������������������������Ŀ
//�Query utilizada para retornar o local da master,       �
//�caso j� esteja endere�ada e tente endere�ar novamente !�
//�Chamado ID- 15 331   Uiran Almeida 04.11.2013          �
//���������������������������������������������������������
*/
		
		BeginSql alias xVaTemp1 
			SELECT TOP 1 
				ZZ4.ZZ4_ETQMEM		AS 	'MASTER',
				ZZ4.ZZ4_LOCAL		AS	'ARMZ', 
 				ZZ4_ENDES			AS 	'ENDERECO'
			FROM ZZ4020 AS ZZ4(NOLOCK)
			
			INNER JOIN ZZJ020 AS ZZJ(NOLOCK) 
			ON ZZJ.ZZJ_FILIAL = %xfilial:ZZJ% 
			AND	ZZ4.ZZ4_OPEBGH = ZZJ.ZZJ_OPERA 
			AND	ZZJ.%notDel%

			INNER JOIN ZZO020 ZZO 
			ON	ZZO_FILIAL =%xfilial:ZZO% 
			AND	ZZO_IMEI=ZZ4_IMEI 
			AND	ZZO_CARCAC=ZZ4_CARCAC 
			AND	ZZO_NUMCX=ZZ4_ETQMEM 
			AND	ZZO_STATUS = %exp: '2'% 
			AND	ZZO.%notDel%
				
			WHERE ZZ4.ZZ4_FILIAL = '06'
			AND	ZZ4.ZZ4_STATUS	 = %exp: '3'%
			AND	ZZ4.ZZ4_ETQMEM = %exp: cVarMas%
			AND	ZZ4.%notDel%
		EndSql
		
		
		If _lRet .AND. Empty(AllTrim((xVaTemp)->MASTER)) .AND. !Empty(AllTrim((xVaTemp1)->ENDERECO))
			
			VTBEEP(3)
			VTAlert("------ Master endere�ada anteriormente endereco: "+AllTrim((xVaTemp1)->ENDERECO)+". Favor analisar! --------","Alerta",.t.,2500)
			cVarMas	:= Replicate(' ',20)
			_lRet := .F.
		EndIf
		
		If _lRet .AND. Empty(AllTrim((xVaTemp)->MASTER)) .AND. Empty(AllTrim((xVaTemp1)->ENDERECO))
			VTBEEP(3)
			VTAlert("------ Master n�o localizada. Favor analisar! --------","Alerta",.t.,2500)
			cVarMas	:= Replicate(' ',20)
			_lRet := .F.
			
		EndIf
		
				
		
/*
//��������������������������������������������Ŀ
//�Retirado e incluso valida��o acima ID 15 331�
//����������������������������������������������
*/
		/*
		If Empty(AllTrim((xVaTemp)->MASTER))
			
			VTBEEP(3)
			VTAlert("------ Master n�o localizada ou endere�ada anteriormente. Favor analisar! --------","Alerta",.t.,2500)
			cVarMas	:= Replicate(' ',20)
			_lRet := .F.
			
		EndIf
		*/
		
		
		If _lRet
			_cOpera	:=	AllTrim((xVaTemp)->OPERA)
			_cRefGar:=	AllTrim((xVaTemp)->REFGAR)
			_cCodPro:=	AllTrim((xVaTemp)->CODPRO)
			_cArmz:=	AllTrim((xVaTemp)->ARMZ)
			_cEtqMa	:=	cVarMas
			_cEnd := Alltrim(cVarEnd)
			_cEnd := _cEnd + Space(15-Len(_cEnd))
			ApontEndc()
		EndIf
		
		If xlQuery
			(xVaTemp)->( DbCloseArea())
		Endif
		
	#ENDIF
	
EndIf

Return(_lRet)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ApontEndc � Autor �Luciano Siqueira    � Data �  15/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao �Tela para Apontamento de Endere�o - COLETOR (ACD)           ���
���          �            ETQ MASTER                                      ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ApontEndc()

Private cCodFifo := space(6)
Private cEndBuf  := GetMv("MV_XENDBUF",.F.,"BUFFER")
Private cDocSep	 := ""

ZZ4->(DBOrderNickName('ZZ4ETQMEM'))
If ZZ4->(DbSeek(xFilial("ZZ4") + _cOpera + _cEtqMa))
	
	If Alltrim(_cEnd) == Alltrim(cEndBuf)//Endere�o com Masters que ser�o pagas para Produ��o
		DbSelectArea("ZZY")  // Tabela de Planejamento da Producao
		DbSetOrder(2)
		If DbSeek(xFilial("ZZY")+cVarMas ,.F.)
			While ZZY->(!Eof()) .and. ZZY->(ZZY_FILIAL+ZZY_NUMMAS)==xFilial("ZZY")+_cEtqMa
				If ZZY->ZZY_QTDSEP == 0 .AND. ZZY->ZZY_TPRESE == "T"
					cDocSep := ZZY->ZZY_NUMDOC	
					EXIT			
				Endif
				ZZY->(dbSkip())
			EndDo			
		Endif
		If EMPTY(cDocSep)
			VTBEEP(3)
			VTAlert("------ Transferencia n�o Efetuada. Favor verificar se a Master possui Documento de Separa��o! "+Alltrim(_cEtqMa),"Alerta",.t.,2500)
			cVarMas	:= Replicate(' ',20)
			cVarEnd	:= Replicate(' ',20)
			Return()
		Endif
	Endif
		
	Begin Transaction
	Do While !ZZ4->(EOF()) .And. ZZ4->ZZ4_FILIAL = xFilial("ZZ4") .And. ZZ4->ZZ4_OPEBGH == _cOpera .And. ZZ4->ZZ4_ETQMEM == _cEtqMa
		If ZZ4->ZZ4_STATUS == '3' .AND. EMPTY(ZZ4->ZZ4_DOCSEP) //.AND. EMPTY(ZZ4->ZZ4_ENDES)
			If Empty(cCodFifo) .and. Empty(ZZ4->ZZ4_FIFO)
				CODFIFO(@cCodFifo)
				If Empty(cCodFifo)
					cCodFifo := "000000"
					cCodFifo := Soma1(cCodFifo)
				Endif
			ElseIf Empty(cCodFifo) .and. !Empty(ZZ4->ZZ4_FIFO)
				cCodFifo := ZZ4->ZZ4_FIFO
			Endif
			RecLock("ZZ4",.F.)
			ZZ4->ZZ4_ENDES	:= _cEnd
			ZZ4->ZZ4_DOCSEP	:= cDocSep
			ZZ4->ZZ4_FIFO	:= IIF(Empty(ZZ4->ZZ4_FIFO),cCodFifo,ZZ4->ZZ4_FIFO)
			MsUnlock()
		Endif
		ZZ4->(dbskip())
	Enddo
	End Transaction
	
	VTBEEP(3)
	VTAlert("------ Endere�ado com sucesso Master "+Alltrim(_cEtqMa),"Alerta",.t.,2500)
	cVarMas	:= Replicate(' ',20)
	cVarEnd	:= Replicate(' ',20)
Else
	VTBEEP(3)
	VTAlert("------ Master n�o localizada, favor analisar. --------","Alerta",.t.,2500)
	cVarMas	:= Replicate(' ',20)
	cVarEnd	:= Replicate(' ',20)
EndIf

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ApontEndc � Autor �Luciano Siqueira    � Data �  15/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao �Tela para Apontamento de Endere�o - COLETOR (ACD)           ���
���          �            ETQ MASTER                                      ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CODFIFO()

Local aAreaAtu := GetArea()

#IFDEF TOP
	Local xVaTemp1		:= GetNextAlias()
	
	BeginSql alias xVaTemp1
		
		SELECT
		TOP 1 MAX(ZZ4_FIFO) AS CODFIFO
		FROM
		%table:ZZ4% ZZ4
		JOIN
		%table:ZZO% ZZO ON
		ZZO_FILIAL =%xfilial:ZZO% AND
		//ZZO_MODELO=ZZ4_CODPRO AND
		ZZO_IMEI=ZZ4_IMEI AND
		ZZO_CARCAC=ZZ4_CARCAC AND
		ZZO_NUMCX=ZZ4_ETQMEM AND
		ZZO_REFGAR=%exp: _cRefGar% AND
		ZZO_STATUS = %exp: '2'% AND
		ZZO.%notDel%
		WHERE
		ZZ4_FILIAL=%xfilial:ZZ4%
		AND ZZ4_CODPRO=%exp: _cCodPro%
		AND ZZ4_LOCAL =%exp: _cArmz%
		AND ZZ4.%notDel%
		
	EndSql
	
	If !Empty((xVaTemp1)->CODFIFO)
		cCodFifo := soma1((xVaTemp1)->CODFIFO)
	Endif
	
	(xVaTemp1)->( DbCloseArea())
	
#ENDIF

RestArea(aAreaAtu)

Return()

Static Function ApontEndd()

Local _lRet		:= .T.

_cEnd := Alltrim(cVarEnd)
_cEnd := _cEnd + Space(15-Len(_cEnd))
dbSelectArea("SBE")
dbSetOrder(9)
If !dbSeek(xFilial("SBE")+_cEnd)
	VTBEEP(3)
	VTAlert("------ Endere�o n�o cadastrado no sistema. Favor analisar! --------","Alerta",.t.,2500)
	cVarEnd	:= Replicate(' ',20)
	_lRet := .F.
Endif

Return(_lRet)
