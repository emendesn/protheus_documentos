#INCLUDE "protheus.ch "

USER FUNCTION ACERTO00()

u_GerA0003(ProcName())

processa( { || fGera()}, "Analisando Cadastros...")                                              

RETURN

STATIC FUNCTION fGera() 

ProcRegua(9)
IncProc("Processando Acerto Cadastro Cliente com Endereço com Duas (2) vírgulas AGUARDE...")      
U_ACERTO01()
IncProc("Processando Acerto Cadastro Cliente com Endereço com caracter Nº AGUARDE...")      
U_ACERTO02() 
IncProc("Processando Acerto Cadastros com Endereço com vírgula e caracter : no começo do endereço AGUARDE...")  
U_ACERTO03()
IncProc("Processando Acerto Cadastro Fornecedor com Endereço com caracter ': ' AGUARDE...")  
U_ACERTO04() 
IncProc("Processando Acerto Cadastro Fornecedor com Endereço com Duas (2) vírgulas AGUARDE...")  
U_ACERTO05()           
IncProc("Processando Acerto Cadastro Fornecedor com Endereço com caracter N° AGUARDE...")  
U_ACERTO06()  
IncProc("Processando Acerto Cadastro Cliente com Endereço sem virgula AGUARDE...")  
U_ACERTO07()
IncProc("Processando Acerto Cadastro Cliente com Telefone com caracter '-' AGUARDE...")  
U_ACERTO08()
  
RETURN