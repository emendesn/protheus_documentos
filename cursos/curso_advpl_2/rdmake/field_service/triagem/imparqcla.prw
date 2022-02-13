#INCLUDE 'RWMAKE.CH'
#DEFINE OPEN_FILE_ERROR -1
#define ENTER CHR(10)+CHR(13)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IMPARQCLA�Autor  �Paulo Francisco     � Data �  17/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para importar a Reclamacao do Cliente  via arquivo���
���          � CSV e atualizar as tabelas ZZR do Protheus.                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IMPARQCLA()

Local aSay    		:= {}
Local aButton 		:= {}
Local nOpc    		:= 0
local _nRegImp  	:= 0
Local cTitulo 		:= "Importa��o de Arquivo .CSV "
Local cDesc1  		:= "Este programa executa a importa��o do Arquivo .CSV e "
Local cDesc2  		:= "Atualiza os arquivos ZZT."
Local cDesc3		:= "Favor remover todos os cabe�alhos e n�o inserir dados em brancos "
Private _amens   	:= {}
Private _acampos 	:= {}
Private _adados  	:= {}
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrNext  	:= .F.
Private lUsrAdmi    := .F.
Private cQryExec

u_GerA0003(ProcName())


//���������������������������������������������������������������������Ŀ
//� Valida acesso de usuario                                            �
//�����������������������������������������������������������������������
For i := 1 to Len(aGrupos)
	
	//Usuarios Nextel
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Next"
		lUsrNext  := .T.
	EndIf
	
	//Administradores
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Admi"
		U_UserId()
	EndIf
Next i


aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando Arquivo CSV ", .T. )

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RUNPROC  �Autor  �Paulo Francisco -   � Data �  17/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que executa a importacao do arquivo CSV do          ���
���          � cliente e atualiza as tabela ZZT                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunProc(lEnd)

local _aAreaZZT  := ZZT->(GetArea())
local _nCnt      := 0
local _nRegImp   := 0
local _ntotImp   := 0
local _cNomeArq  := ""
Local cPath      := "/IMPIMEI/"						// Local de gera��o do arquivo
Local aDirectory := Directory (cPath + "*.*")      // Tipo de arquivo a serem excluidos
Local cVimei

ZZG->(dbSetOrder(1))
ZZT->(dbSetOrder(1))


// Fecha o arquivo temporario caso esteja aberto
if select("EXC") > 0
	EXC->(dbCloseArea())
endif


// Abre o arquivo CSV gerado pelo cliente
_cTipo := "Arquivo Cliente (*.CSV)    | *.CSV | "
_cExcelDBF := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
If Empty(_cExcelDBF)
	Aviso("Cancelada a Sele��o!","Voce cancelou a sele��o do arquivo.",{"Ok"})
	Return
Endif

if !file(_cExcelDBF)
	return
else
	CpyT2S(_cExcelDBF,cPath)
endif

_clocalArq := alltrim(_cExcelDBF)
_cNomeArq := alltrim(_cExcelDBF)
_nPos     := rat("\",_cNomeArq)
if _nPos > 0
	_cNomeArq := substr(_cNomeArq,_nPos+1,len(_cNomeArq)-_nPos)
endif

cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

__CopyFile(_clocalArq, cRootPath + cPath + alltrim(_cNomeArq))
cFile :=  cPath + alltrim(_cNomeArq)
LPrim := .T.



If FT_FUSE( cfile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " nao encontrado!")
	Return
Endif

ProcRegua( FT_FLASTREC() )
lPrim   := .f.
clotirl := GetSx8Num("ZZT","ZZT_IMEI")
ConfirmSX8()

While !FT_FEOF()
	cImei := cMode := ""
	lPass :=.t.
	lMsErroAuto := .F.
	lPass :=.t.
	
	//�����������������������������Ŀ
	//� L� linha do arquivo retorno �
	//�������������������������������
	xBuffer := FT_FREADLN()
	
	IncProc()
	
	nDivi   := At(";",xBuffer)
	cImei   := Substr(xBuffer,1,  nDivi - 1)
	
	/* Modelo Equipamento */
	xBuffer := Substr(xBuffer , nDivi+1)
	nDivi   := At(";",xBuffer)
	cMode  	:= xBuffer
	
	
	cVimei := Posicione("ZZT",2,xFilial("ZZT") + cImei,"ZZT_IMEI")
	
	If Len(AllTrim(cVimei)) == 0
		
		dbSelectArea("ZZR")
		dbSetOrder(1)
		If MsSeek(xFilial("ZZR") + cImei)
			
			Begin Transaction
			RecLock("ZZT",.T.)
			
			ZZT->ZZT_FILIAL		:= xFilial("ZZT")
			ZZT->ZZT_MODELO		:= cMode
			ZZT->ZZT_IMEI 		:= cImei
			ZZT->ZZT_STATUS		:= "2"
			
			msunlock()
			End Transaction        
			
			RecLock("ZZR",.F.)
			
			dbDelete()
			
			msunlock()
			
		Else
			
			Begin Transaction
			RecLock("ZZT",.T.)
			
			ZZT->ZZT_FILIAL		:= xFilial("ZZT")
			ZZT->ZZT_MODELO		:= cMode
			ZZT->ZZT_IMEI 		:= cImei
			ZZT->ZZT_STATUS		:= "1"
			
			msunlock()
			End Transaction
			
		EndIf
		
		_nRegImp++
		
	EndIf
	
	FT_FSKIP()
EndDo

MsgAlert(" Foram Importados " + Transform(StrZero(_nRegImp,10),"@E 9999999999") + " Equipamentos !!!")

Return