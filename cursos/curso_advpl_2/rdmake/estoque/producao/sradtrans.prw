#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SRAdTrans  �Autor  � Edson Rodrigues    � Data �  12/03/2010���
�������������������������������������������������������������������������͹��
���Desc.     � Processo Sony Refurbish - Adciona ao vetor os daos de      ���
���          | Transferencia de estoque                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SRAdTrans(cprodori,armori,cdoc,cprodest,carmdest,_atransp,ltransf,lInclui,_lgertrans,recori,recdest,nqtde)
		NMODULO:=04
		CMODULO:="EST"

u_GerA0003(ProcName())
	
        AADD(_atransp,cprodori)
	    AADD(_atransp,left(armori,2))
		AADD(_atransp,nqtde)
		AADD(_atransp,cdoc)
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,cprodest)
		AADD(_atransp,carmdest)
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'' )
		AADD(_atransp,recori )
		AADD(_atransp,recdest )
		
		IF Len(_atransp) > 0 .and. _lgertrans
			ltransf:=U_BGHOP004(_atransp,lInclui)
	    ENDIF

Return()
                                                                     
