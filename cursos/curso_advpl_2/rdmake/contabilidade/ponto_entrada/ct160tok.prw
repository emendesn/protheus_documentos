#INCLUDE "RWMAKE.CH"              
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT160T0K  �Autor  �Edson Rodrigues     � Data �  11/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     |Ponto de entrada que Valida digitacao da visao gerencial    ���
���          |quando o c�digo da vis�o for o 200                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������͹��
���Alteracoes�                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

*/

User Function ct160TOK()

Local _lret   := .t.
Local _centid :=""
Local _cconta :=""
Local _ccusto :=""
Local _codvis := M->CTS_CODPLA 
Local _codcls := M->CTS_CLASSE 
Local _centid := M->CTS_CONTAG
Local nDivi   := At("/",_centid)
Local nTamEnt:= TAMSX3("CTS_CONTAG")[1]

u_GerA0003(ProcName())


IF _codvis='200' .and. (altera .or. inclui)  .and. _codcls=='2'
    
   	
   	IF nDivi==0 
      msgstop("Obrigatorio digitar a entidade com a barra '/' separando a Conta do C.Custo. Objetivo: formar um c�digo de entidade v�lido (Conta + C.Custo - BGH-AR) para a Visao 200.","Entidade sem barra ' / '","STOP") 
   	  _lret := .f.
   	    	
   	Else
   	   _cconta := alltrim(Substr(_centid, 1, nDivi - 1))
   	   _ccusto := alltrim(Substr(_centid,nDivi + 1))
   	Endif 
   	
   	If _lret 
   	                 
   	   if Select("QryCon") > 0
	      QryCon->(dbCloseArea())
       endif
   	   
   	   //valida Conta
   	   _cQuery := "SELECT COD_CTA_CONT FROM INP_MAE_CTA_CONT (NOLOCK) WHERE COD_CTA_CONT='"+_cconta+"' "
       TCQUERY _cQuery ALIAS "QryCon" NEW

       dbSelectArea("QryCon")
       QryCon->(dbgotop())                                    

       If QryCon->(EOF())  
            msgstop("Conta nao encontrada na tabela de Contas Contabeis da BGH-AR. Informe o conta valida.","Conta Contabil Invalida","STOP") 
   	        _lret:=.f.                
   	   Endif
        
       //valida Centro de Custo
       If _lret 
           if Select("QryCc") > 0
	         QryCc->(dbCloseArea())
           endif
   	   
       
           _cQuery := "SELECT COD_CEN_COSTO FROM INP_MAE_CEN_COSTO (NOLOCK) WHERE COD_CEN_COSTO='"+_ccusto+"' "
           
           TCQUERY _cQuery ALIAS "QryCc" NEW
           
           dbSelectArea("QryCc")
           QryCc->(dbgotop())                                    

           if QryCc->(EOF())      
             msgstop("Centro de Custo nao encontrado na tabela de C.Custo da BGH-AR. Informe o centro de custo valido.","Centro de Custo Invalido","STOP") 
   	         _lret:=.f.              
   	        
   	       Else
   	           M->CTS_CONTAG:=_cconta+"/"+_ccusto
   	           
   	       Endif
        
        Endif
    
    Endif
Endif


Return(_lret)