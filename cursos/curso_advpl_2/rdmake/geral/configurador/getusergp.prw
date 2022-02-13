#include "rwmake.ch"
#include "topconn.ch"        
#include "tbiconn.ch"   
#include "protheus.ch" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGETUSERSGPบ Autor ณ Paulo Francisco    บ Data ณ 23/06/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RETORNA USUARIOS PERTENCENTES AO GRUPO INFORMADO           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cGrupo: grupo a ser consultado                             บฑฑ
ฑฑบ          ณ cTipo : retorna string ou array (default string)           บฑฑ
ฑฑบ          ณ nIdent: tipo da informacao a ser retornada.                บฑฑ
ฑฑบ          ณ         (default 2=Nome Usuario, 4=Nome Completo)          บฑฑ
ฑฑบ          ณ         (14=Email                               )          บฑฑ
ฑฑบ          ณ cSepar: separador da string (default ,)                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/  
User Function getUserGp(cGrupo, cTipo, nIdent, cSepar)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Array com informacoes de usuarios

Indice     Tipo  Conteudo
[n][1][1]  C     Numero de identificacao sequencial com o tamanho de 6 caracteres
[n][1][2]  C     Nome do usuario
[n][1][3]  C     Senha (criptografada)
[n][1][4]  C     Nome completo do usuario
[n][1][5]  A     Vetor contendo as ultimas n senhas do usuario
[n][1][6]  D     Data de validade
[n][1][7]  N     Numero de dias para expirar
[n][1][8]  L     Autorizacao para alterar a senha
[n][1][9]  L     Alterar a senha no proximo logon
[n][1][10] A     Vetor com os grupos
[n][1][11] C     Numero de identificacao do superior
[n][1][12] C     Departamento
[n][1][13] C     Cargo
[n][1][14] C     E-mail
[n][1][15] N     Numero de acessos simultaneos
[n][1][16] D     Data da ultima alteracao
[n][1][17] L     Usuario bloqueado
[n][1][18] N     Numero de digitos para o ano
[n][1][19] L     Listner de ligacoes
[n][1][20] C     Ramal
[n][1][21] C     Log de operacoes
[n][1][22] C     Empresa, filial e matricula

[n][2][1]  A     Vetor contendo os horarios dos acessos, cada elemento do vetor corresponde um dia da semana com a hora inicial e final.
[n][2][2]  N     Uso interno
[n][2][3]  C     Caminho para impressao em disco
[n][2][4]  C     Driver para impressao direto na porta. Ex: EPSON.DRV
[n][2][5]  C     Acessos
[n][2][6]  A     Vetor contendo as empresas, cada elemento contem a empresa e a filial. Ex:"9901", se existir "@@@@" significa acesso a todas as empresas
[n][2][7]  C     Elemento alimentado pelo ponto de entrada USERACS
[n][2][8]  N     Tipo de impressใo: 1 - em disco, 2 - via Windows e 3 direto na porta
[n][2][9]  N     Formato da pagina: 1 - retrato, 2 - paisagem
[n][2][10] N     Tipo de Ambiente: 1 - servidor, 2 - cliente
[n][2][11] L     Priorizar configura็ใo do grupo
[n][2][12] C     Opcao de impressใo
[n][2][13] L     Acessar outros diretorios de impressao

[n][3]     A     Vetor contendo o modulo, o nivel e o menu do usuario. Ex: [n][3][1] = "019\sigaadv\sigaatf.xnu" [n][3][2] = "029\sigaadv\sigacom.xnu"
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

Local aUsrEmp := AllUsers()  
Local uRet      
Local i 

Default cTipo  := ""
Default nIdent := 2      
Default cSepar := ","      

u_GerA0003(ProcName())


If Empty(cTipo)
	uRet := ""
Else
	uRet := {}
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aUsrEmp)
	If U_isGroup(cGrupo, aUsrEmp[i,1,2])
		If Upper(cTipo) == "A"  //Retorna Array
			aAdd(uRet, aUsrEmp[i,1,nIdent])
		Else //Retorna String 
			If Empty(uRet)
				uRet := AllTrim(aUsrEmp[i,1,nIdent])
			Else
				uRet += cSepar + AllTrim(aUsrEmp[i,1,nIdent])
			EndIf
		EndIf
	EndIf		
Next i     

Return uRet