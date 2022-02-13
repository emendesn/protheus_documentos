User Function ENVTrib
Local cData := GravaData(SE2->E2_VENCREA,.f.,5)
Local cPgto := GravaData(dDataBase,.f.,5)

u_GerA0003(ProcName())

/*Retorna o layout do tributo - Claudia */           
ctrib := ''
If SEA->EA_MODELO == '17'   //GPS
	cTrib := '01' 
	cTrib += IIF(SA2->A2_TIPO=='J','2631','2100') // CODIGO DE PAGTO
	cTrib += IIF(MONTH(SE2->E2_VENCREA)<10,'0','') + ALLTRIM(STR(Month(SE2->E2_VENCREA))) + ALLTRIM(STR(YEAR(SE2->E2_VENCREA)))
	cTrib += Iif(Empty(SM0->M0_CGC),space(14),SUBSTR(SM0->M0_CGC,1,14))
	cTrib += StrZero(SE2->E2_SALDO*100,14) // Vlr pagto
	cTrib += StrZero(SE2->E2_TXVLENT*100,14) // vlr outras entidades 
	cTrib += Replicate('0',14) //atualizacao monetaria
	cTrib += StrZero(SE2->E2_SALDO*100,14) // valor arrecadado
	cTrib += cPgto // data arrecadacao
	cTrib += space(8) // brancos
	cTrib += space(50) // informacoes complementares
	cTrib += SUBSTR(SA2->A2_NOME,1,30) // nome do contribuinte
	
Elseif SEA->EA_MODELO ==  '16'  // DARF
    cTrib := '02' 
	cTrib += SUBSTR(SE2->E2_CODRET,1,4) // CODIGO DA RECEITA
	cTrib += '2'// TIPO DE INSCRICAO DO CONTRIBUINTE = 2-CNPJ
	cTrib += SUBSTR(SM0->M0_CGC,1,14)
	cTrib += cData // PERIODO DE APURACAO
	cTrib += Iif(!empty(SE2->E2_TXNRREF),SE2->E2_TXNRREF,space(17)) // NUMERO DE REFERENCIA
	cTrib += StrZero(SE2->E2_SALDO*100,14) // Vlr principal
	cTrib += Replicate('0',14) // vlr da multa                      
	cTrib += Replicate('0',14) // vlr dos juros e encargos                      
	cTrib += StrZero(SE2->E2_SALDO*100,14) // valor total a ser pago
	cTrib += cData // data de vencimento
	cTrib += cPgto // data de pagamento
	cTrib += space(30) // complemento de registro
	cTrib += SUBSTR(SM0->M0_NOME,1,30) // nome do contribuinte
Elseif SEA->EA_MODELO == '18'// DARF SIMPLES
	cTrib := '03'
	cTrib += SUBSTR(SE2->E2_CODRET,1,4) // CODIGO DA RECEITA
	cTrib += '2'// TIPO DE INSCRICAO DO CONTRIBUINTE = 2-CNPJ
	cTrib += SUBSTR(SM0->M0_CGC,1,14)
	cTrib += cData // PERIODO DE APURACAO
	cTrib += Replicate('0',9) // vlr receita bruta acumulada
	cTrib += Replicate('0',4) // percentual sobre receita bruta acumulada                      
	cTrib += space(4) // complemento de registro
	cTrib += StrZero(SE2->E2_SALDO*100,14) // Vlr principal
	cTrib += Replicate('0',14) // vlr da multa                      
	cTrib += Replicate('0',14) // vlr dos juros e encargos                      
	cTrib += StrZero(SE2->E2_SALDO*100,14) // valor total a ser pago
	cTrib += cData // data de vencimento
	cTrib += cPgto // data de pagamento
	cTrib += space(30) // complemento de registro
	cTrib += SUBSTR(SM0->M0_NOME,1,30) // nome do contribuinte
Elseif SEA->EA_MODELO == '21' // DARJ
	cTrib := '04'
	cTrib += SUBSTR(SE2->E2_CODRET,1,4) // CODIGO DA RECEITA
	cTrib += '2'// TIPO DE INSCRICAO DO CONTRIBUINTE = 2-CNPJ
	cTrib += SUBSTR(SM0->M0_CGC,1,14)                         
	cTrib += SPACE(8) // INSCRICAO ESTADUAL 
	cTrib += space(16) // numero documento de origem
	cTrib += space(1) // complemento de registro
	cTrib += StrZero(SE2->E2_SALDO*100,14) // Vlr principal
	cTrib += Replicate('0',14) // vlr atualizacao monetaria
	cTrib += Replicate('0',14) // vlr da mora
	cTrib += Replicate('0',14) // vlr da multa
	cTrib += StrZero(SE2->E2_SALDO*100,14) // valor total a recolher
	cTrib += cData // data de vencimento
	cTrib += cPgto // data de pagamento
	cTrib += str(month(SE2->E2_VENCREA))+STR(YEAR(SE2->E2_VENCREA))
	cTrib += space(10) // complemento de registro
	cTrib += SUBSTR(SM0->M0_NOME,1,30) // nome do contribuinte
Elseif SEA->EA_MODELO == '22' // ICMS 
	cTrib := '05'       
	cTrib += SUBSTR(SE2->E2_CODRET,1,4) // CODIGO DA RECEITA
	cTrib += '2'// TIPO DE INSCRICAO DO CONTRIBUINTE = 2-CNPJ
	cTrib += SUBSTR(SM0->M0_CGC,1,14)                         
	cTrib += IIF(!EMPTY(SM0->M0_INSC),SUBSTR(SM0->M0_INSC,1,12),SPACE(12)) // INSCRICAO ESTADUAL 
	cTrib += space(13) // DIVIDA ATIVA E ETIQUETA 
	cTrib += str(month(SE2->E2_VENCREA))+STR(YEAR(SE2->E2_VENCREA)) // MES E ANO DE REFERENCIA
	cTrib += SPACE(13) // NUMERO PARCELA E NOTIFICACAO 
	cTrib += StrZero(SE2->E2_SALDO*100,14) // VALOR DA RECEITA
	cTrib += Replicate('0',14) // vlr DOS JUROS
	cTrib += Replicate('0',14) // vlr da MULTA
	cTrib += StrZero(SE2->E2_SALDO*100,14) // valor DO PAGAMENTO
	cTrib += cData // data de vencimento
	cTrib += cPgto // data de pagamento
	cTrib += space(11) // complemento de registro
	cTrib += SUBSTR(SM0->M0_NOME,1,30) // nome do contribuinte
	
Elseif SEA->EA_MODELO == '27' // IPVA
	cTrib := '07' // A IMERYS NAO FAZ IPVA
ElseIF SEA->EA_MODELO == '35' // FGTS-GFIP
	cTrib := SEA->EA_MODELO
	cTrib += SUBSTR(SE2->E2_CODRET,1,4) // CODIGO DA RECEITA 
	cTrib += '2'// TIPO DE INSCRICAO DO CONTRIBUINTE = 1-CNPJ   
	cTrib += SUBSTR(SM0->M0_CGC,1,14)                         
	cTrib += SUBSTR(SE2->E2_TXCDBAR,1,48) // codigo de barras
	cTrib += space(16) // identificador do FGTS
	cTrib += space(9) // lacre de conectividade social
	cTRib += space(2) // digito do lacre de conectividade social
	cTrib += SUBSTR(SM0->M0_NOME,1,30) // nome do contribuinte
	cTrib += cPgto // data de pagamento
	cTrib += StrZero(SE2->E2_SALDO*100,14) // valor DO PAGAMENTO
	cTrib += space(30) // complemento de registro
else // DPVAT ou GR-PR 
	cTrib := SEA->EA_MODELO //NAO FAZ DPVAT E GR-PR	
EndIF	
Return cTrib