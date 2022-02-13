#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GATINUM   �Autor  �Edson Rodrigues     � Data �  29/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �GATILHA NUMERO DIGITADO NO CAMPO ENDERECO                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GATINUM(cnum,cend)
  Local cnum:= ALLTRIM(cnum)                                 
  Local cend:= IIf(ALLTRIM(cend)$',', ALLTRIM(cend), ALLTRIM(cend)+',')
  Local ndiv:= AT(",",cend)
  Local creturn:=IIF(ndiv > 0,substr(cend,1,ndiv)+" "+cnum,cend)
  
Return(creturn) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VEREMAIL  �Autor  �Edson Rodrigues     � Data �  29/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �VERIFICA SE O CAMPO E-MAIL TEM @ E .DIGITADO                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VEREMAIL(cemail)
  Local _cemail:= ALLTRIM(cemail)                                 
  Local _lret :=.t.
  IF !empty(_cemail)
       if !'@'$ _cemail
         MsgBox("Favor digitar um e-mail valido","E-mail sem @(arroba)","ALERT")
         _lret:=.f.
       endif
       If !'.' $ _cemail
         MsgBox("Favor digitar um e-mail valido","E-mail sem .(Ponto)","ALERT")
         _lret:=.f.
       endif  
  Else	  
	  MsgBox("Favor digitar um e-mail valido","E-mail em branco","ALERT")
	  _lret:=.f.
  endif
  
Return(_lret) 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATE003   � Autor �Paulo Lopez         � Data �  09/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � VERIFICA PREENCHIMENTO DE CAMPOS PARA IMPORTA��O           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FATE003()

//���������������������������������������������������������������������Ŀ
//|Declaracao de variaveis                                              �
//�����������������������������������������������������������������������
Local aArea    := GetArea()
Local cRet     := M->C5_CLIENTE

//���������������������������������������������������������������������Ŀ
//| Verifica Preenchimento do Campo Segmento                            �
//�����������������������������������������������������������������������
If M->C5_TIPO $ "N" .And. !(SA1->A1_TIPO $ "X")
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1") + cRet))
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + cRet))
    
	If (Empty(Alltrim(SA1->A1_DDD)) .Or. Empty(AllTrim(SA1->A1_TEL)) .Or. Empty(AllTrim(SA1->A1_EMAIL)) )                
		MsgStop("Favor verificar campos no cadastro do cliente . Favor efetuar cadastro!")
		cRet := ""
	EndIf

  	ElseIf M->C5_TIPO $ "B" .And. !(SA2->A2_TIPO $ "X")

	SA2->(dbSetOrder(1))  
	SA2->(dbseek(xFilial("SA2") + cRet))	                                
	
		If (Empty(SA2->A2_CGC))                
			MsgStop("Favor verificar campos no cadastro do fornecedor . Favor efetuar cadastro!")
			cRet := ""
		EndIf
EndIf  


RestArea(aArea)

Return(cRet)  