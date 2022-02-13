#INCLUDE 'RWMAKE.CH'
#DEFINE OPEN_FILE_ERROR -1
#define ENTER CHR(10)+CHR(13)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IMPARQNEX�Autor  �Paulo Francisco     � Data �  17/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para importar a Reclamacao do Cliente  via arquivo���
���          � CSV e atualizar as tabelas ZZR do Protheus.                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IMPARQNEX()

Local aSay    		:= {}
Local aButton 		:= {}
Local nOpc    		:= 0
local _nRegImp  	:= 0
Local cTitulo 		:= "Importa��o de Arquivo .CSV "
Local cDesc1  		:= "Este programa executa a importa��o do Arquivo .CSV e "
Local cDesc2  		:= "Atualiza os arquivos ZZR."
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
���          � cliente e atualiza as tabela ZZR                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunProc(lEnd)

local _aAreaZZR  := ZZR->(GetArea())
local _nCnt      := 0
local _nRegImp   := 0
local _ntotImp   := 0
local _cNomeArq  := ""
Local cPath      := "/IMPIMEI/"						// Local de gera��o do arquivo
Local aDirectory := Directory (cPath + "*.*")      // Tipo de arquivo a serem excluidos
Local cVimei

ZZG->(dbSetOrder(1))
ZZR->(dbSetOrder(1))


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
clotirl := GetSx8Num("ZZR","ZZR_IMEI")
ConfirmSX8()

While !FT_FEOF()
	cImei := ""
	lPass :=.t.
	lMsErroAuto := .F.
	lPass :=.t.
	
	//�����������������������������Ŀ
	//� L� linha do arquivo retorno �
	//�������������������������������
	xBuffer := FT_FREADLN()
	
	IncProc()
	
	//nDivi   := At(";",xBuffer)
	//cImei    := Substr(xBuffer,1,  nDivi - 1)
	cImei	:= xBuffer
	
	cVimei := Posicione("ZZR",1,xFilial("ZZR")+cImei,"ZZR_IMEI")

		If Len(AllTrim(cVimei)) == 0
			
			Begin Transaction
			RecLock("ZZR",.T.)
			
			ZZR->ZZR_FILIAL		:= xFilial("ZZR")
			ZZR->ZZR_IMEI 		:= cImei
			ZZR->ZZR_MSBLQL		:= "2"
			
			msunlock()
			
			_nRegImp++
			
			End Transaction
			
		EndIf
		
	FT_FSKIP()
EndDo

MsgAlert(" Foram Importados " + Transform(StrZero(_nRegImp,10),"@E 9999999999") + " Equipamentos !!!")

Return