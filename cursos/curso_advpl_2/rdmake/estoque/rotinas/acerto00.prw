#INCLUDE "protheus.ch "

USER FUNCTION ACERTO00()

u_GerA0003(ProcName())

processa( { || fGera()}, "Analisando Cadastros...")                                              

RETURN

STATIC FUNCTION fGera() 

ProcRegua(9)
IncProc("Processando Acerto Cadastro Cliente com Endere�o com Duas (2) v�rgulas AGUARDE...")      
U_ACERTO01()
IncProc("Processando Acerto Cadastro Cliente com Endere�o com caracter N� AGUARDE...")      
U_ACERTO02() 
IncProc("Processando Acerto Cadastros com Endere�o com v�rgula e caracter : no come�o do endere�o AGUARDE...")  
U_ACERTO03()
IncProc("Processando Acerto Cadastro Fornecedor com Endere�o com caracter ': ' AGUARDE...")  
U_ACERTO04() 
IncProc("Processando Acerto Cadastro Fornecedor com Endere�o com Duas (2) v�rgulas AGUARDE...")  
U_ACERTO05()           
IncProc("Processando Acerto Cadastro Fornecedor com Endere�o com caracter N� AGUARDE...")  
U_ACERTO06()  
IncProc("Processando Acerto Cadastro Cliente com Endere�o sem virgula AGUARDE...")  
U_ACERTO07()
IncProc("Processando Acerto Cadastro Cliente com Telefone com caracter '-' AGUARDE...")  
U_ACERTO08()
  
RETURN