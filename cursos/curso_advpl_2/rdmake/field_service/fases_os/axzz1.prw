#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXZZ1    �Autor  �Edson B. - Erp Plus � Data �  24/04/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Fases de Ordens de Servico                     ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function AXZZ1()

Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrNext  	:= .F.
Private lBlqNext  	:= .F.
Private lUsrAdmi    := .F.

u_GerA0003(ProcName())

//���������������������������������������������������������������������Ŀ
//� Valida acesso de usuario                                            �
//�����������������������������������������������������������������������
For i := 1 to Len(aGrupos)
	
	//Usuarios Bloqueado Nextel - Motorola
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Nextel"
		lBlqNext  := .T.
	EndIf
	
	//Usuarios Nextel - Motorola
	If AllTrim(GRPRetName(aGrupos[i])) == "Nexteladm"
		lUsrNext  := .T.
	EndIf
	
	//Administradores
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Admi"
		lUsrAdmi	:= .T.
	EndIf
Next i

If lBlqNext
	
	If !(lUsrNext .Or. lUsrAdmi)
		
		MsgStop("Usuario n�o autorizado a usar essa rotina", "Bloqueio Usuario")
		Return()
		
	Endif
EndIf

AxCadastro("ZZ1","Cadastro de Fases")

Return