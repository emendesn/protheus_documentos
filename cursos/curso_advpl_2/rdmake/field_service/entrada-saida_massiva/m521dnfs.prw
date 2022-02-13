#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M521DNFS �Autor  � M.Munhoz - ERPPLUS � Data �  04/08/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada apos a exclusao da Nota Fiscal de saida   ���
���          � para limpar os dados da NF no ZZ4                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function M521DNFS()

local _cUpdate := ""

u_GerA0003(ProcName())

_cUpdate := " UPDATE "+RetSqlName("ZZ4")+" SET ZZ4_NFSNR = '', ZZ4_NFSSER = '', ZZ4_NFSDT = '', "
_cUpdate += "        ZZ4_NFSHR = '', ZZ4_DOCDTS = '', ZZ4_DOCHRS = '', ZZ4_STATUS = '8' "
_cUpdate += " WHERE  D_E_L_E_T_ = '' AND ZZ4_FILIAL = '"+SF2->F2_FILIAL+"' AND ZZ4_NFSNR = '"+SF2->F2_DOC+"' AND "
_cUpdate += "        ZZ4_NFSSER = '"+SF2->F2_SERIE+"' AND ZZ4_NFSDT = '"+dtos(SF2->F2_EMISSAO)+"' "
tcSqlExec(_cUpdate)
TCREFRESH(RetSqlName("ZZ4"))

//Apaga NFs de peca - Edson Rodrigues
_cUpdate := " UPDATE "+RetSqlName("ZZ4")+" SET ZZ4_NFSPEC='',ZZ4_NFSSEP='',ZZ4_DTNPEC='',ZZ4_HRNPEC='' "
_cUpdate += " WHERE  D_E_L_E_T_ = '' AND ZZ4_FILIAL = '"+SF2->F2_FILIAL+"' AND ZZ4_NFSPEC = '"+SF2->F2_DOC+"' AND "
_cUpdate += "        ZZ4_NFSSEP = '"+SF2->F2_SERIE+"' AND ZZ4_DTNPEC = '"+dtos(SF2->F2_EMISSAO)+"' "

tcSqlExec(_cUpdate)
TCREFRESH(RetSqlName("ZZ4"))

//Apaga NFs de Servico - Edson Rodrigues
_cUpdate := " UPDATE "+RetSqlName("ZZ4")+" SET ZZ4_NFSERV='',ZZ4_NFSSSV='',ZZ4_DTNFSE='',ZZ4_HRNFSE='' "
_cUpdate += " WHERE  D_E_L_E_T_ = '' AND ZZ4_FILIAL = '"+SF2->F2_FILIAL+"' AND ZZ4_NFSERV = '"+SF2->F2_DOC+"' AND "
_cUpdate += "        ZZ4_NFSSSV = '"+SF2->F2_SERIE+"' AND ZZ4_DTNFSE = '"+dtos(SF2->F2_EMISSAO)+"' "

tcSqlExec(_cUpdate)
TCREFRESH(RetSqlName("ZZ4"))

//Limpa campos referentes a SWAP
_cUpdate := " UPDATE "+RetSqlName("ZZ4")+" SET ZZ4_SWNFDT = '', ZZ4_SWNFNR = '', ZZ4_SWNFSE = '', "
_cUpdate += "        ZZ4_SWSADC = '' "
_cUpdate += " WHERE  D_E_L_E_T_ = '' AND ZZ4_FILIAL = '"+SF2->F2_FILIAL+"' AND ZZ4_SWNFNR = '"+SF2->F2_DOC+"' AND "
_cUpdate += "        ZZ4_SWNFSE = '"+SF2->F2_SERIE+"' AND ZZ4_SWNFDT = '"+dtos(SF2->F2_EMISSAO)+"' "   

tcSqlExec(_cUpdate)
TCREFRESH(RetSqlName("ZZ4"))
return