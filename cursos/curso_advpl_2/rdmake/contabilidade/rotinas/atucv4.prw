#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "protheus.ch"     
/* atualiza o campo CV4_ITSEQ DA TABELA CV4 */ 

User Function ATUCV4()       	
//Processa( { || MyRel() } ) 
//Return .t.                     

//static function myrel()  

u_GerA0003(ProcName())  

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "CV4"
*
Private aAlias  := {"CV4"}

DbSelectArea("CV4")
ProcRegua(CV4->(RecCount()))
CV4->(DbGotop())
While CV4->(!Eof())
	IncProc("Atualizando Rateios cadastrados") 
	cChaveAnt := CV4_FILIAL + CV4->(DTOS(CV4_DTSEQ)+CV4_SEQUEN)
	cItSeq := StrZero(0, Len(CV4->CV4_ITSEQ))
	While CV4->(!Eof()) .And.;
		CV4->(CV4_FILIAL+DTOS(CV4_DTSEQ)+CV4_SEQUEN) == cChaveAnt
		RecLock("CV4", .F.)
		cItSeq := Soma1(cItSeq)
		CV4->CV4_ITSEQ := cItSeq
		MsUnlock()
		CV4->(DbSkip())
	End		
End             
alert("CV4 Atualizado")
Return .t.