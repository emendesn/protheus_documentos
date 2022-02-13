#include "rwmake.ch"
#include "tbiconn.ch"
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA01F   �Autor  �Paulo Francisco     � Data �01/10/2010   ���
�������������������������������������������������������������������������͹��
���Descricao �FUNCOES DO MBROWSE                                          ���
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

User Function POSCOMP()

Local cPath1	:= " http://172.16.0.4:8091/ReportServer/Pages/ReportViewer.aspx?%2fAging+Sintetico&rs:Command=Render "
Local cPath1b   := " http://172.16.0.4:8091/ReportServer/Pages/ReportViewer.aspx?%2fAging_Sintetico_Armazem&rs:Command=Render "
//Local cPath2	:= " http://172.16.0.4:8091/ReportServer/Pages/ReportViewer.aspx?%2fObsolescencia&rs:Command=Render "
Local cPath2	:= " http://172.16.0.4:8091/ReportServer/Pages/ReportViewer.aspx?%2fObsoleto&rs:Command=Render "
Local cPath3	:= " http://172.16.0.4:8091/ReportServer/Pages/ReportViewer.aspx?%2fBounce&rs:Command=Render "

Local cBrowser	:= "" // Criado para definir o Browser onde ira abrir o Relatorio

Private cPerg       := "POSCOMP"

u_GerA0003(ProcName())

//���������������������������������������������������������������������Ŀ
//|Cria dicionario de perguntas                                         �
//�����������������������������������������������������������������������
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return
Endif


//��������������������������������������������������������Ŀ
//�Alterado  - Uiran Almeida 21.01.2014 GLPI 15 475        �
//����������������������������������������������������������
                                            
If mv_par03 == 1
	cBrowser := "C:\Arquivos de programas\Internet Explorer\IEXPLORE.EXE"
ElseIf mv_par03 == 2
	cBrowser := "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" // Diretorio padrao para instalacao do GoogleChrome
Else
	Aviso("Browser","Browser n�o encontrado ou n�o escolhido !",{"Ok"})
EndIf


Do Case
	
	Case mv_par01 == 1
		//���������������������������������������������������������������������Ŀ
		//|Modulo para Administradores                                          �
		//�����������������������������������������������������������������������
		If mv_par02 == 1
			//ShellExecute("open","C:\Arquivos de programas\Internet Explorer\IEXPLORE.EXE",cPath1,"",5)
			ShellExecute("open",cBrowser,cPath1,"",5)
		Else
			//ShellExecute("open","C:\Arquivos de programas\Internet Explorer\IEXPLORE.EXE",cPath1b,"",5)
			ShellExecute("open",cBrowser,cPath1b,"",5)
		EndIf
	Case mv_par01 == 2
		//���������������������������������������������������������������������Ŀ
		//|Modulo para Administradores											�
		//�����������������������������������������������������������������������
		//ShellExecute("open","C:\Arquivos de programas\Internet Explorer\IEXPLORE.EXE",cPath2,"",5)
		ShellExecute("open",cBrowser,cPath2,"",5)
		
	Case mv_par01 == 3
		//���������������������������������������������������������������������Ŀ
		//|Modulo para Administradores											�
		//�����������������������������������������������������������������������
		//ShellExecute("open","C:\Arquivos de programas\Internet Explorer\IEXPLORE.EXE",cPath3,"",5)
		ShellExecute("open",cBrowser,cPath3,"",5)
EndCase


Return()
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FCRIASX1  � Autor �Paulo Lopez         � Data �  08/07/10   ���
�������������������������������������������������������������������������͹��
���Descricao �GERA DICIONARIO DE PERGUNTAS                                ���
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
Static Function fCriaSX1()

dbSelectArea("SX1")
dbSetOrder(1)
aSX1 := {}

aAdd(aSx1,{cPerg,"01","Tipo de Relatorio? ","","","mv_ch1", "N",01,0,0,"C","","mv_par01","Aging","","","","","Obsolesc�ncia","","","","","Bounce","","","","","","","","","","","","","","",""})
aAdd(aSx1,{cPerg,"02","Agrupar Por      ? ","","","mv_ch2", "N",01,0,0,"C","","mv_par02","Armazem+Produto","","","","","Armazem","","","","","","","","","","","","","","","","","","","",""})
aAdd(aSx1,{cPerg,"03","Qual o Navegador ? ","","","mv_ch3", "N",01,0,0,"C","","mv_par03","Int. Explorer","","","","","Google Chrome","","","","","","","","","","","","","","","","","","","",""})


dbSelectArea("SX1")
dbSetOrder(1)

/*��������������������������������������������������������������Ŀ
  � Carrega as Perguntas no SX1                                  �
  ����������������������������������������������������������������*/
ValidPerg(aSX1,cPerg)

Return
