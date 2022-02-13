#Include 'Totvs.ch'
/*
*Programa: TecA0003 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 01/10/12   
*Desc.   : Abertura do FrontEnd - MkTarget
*/
User Function TecA0003()
	Local cUrlFE := " http://172.16.0.7:8090 " 

u_GerA0003(ProcName())

	ShellExecute("open","C:\Arquivos de programas\Internet Explorer\IEXPLORE.EXE",cUrlFE,"",5) 
Return