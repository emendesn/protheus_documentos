#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"              
#include "tbiconn.ch"                                
#DEFINE OPEN_FILE_ERROR -1  
#define ENTER CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ acplanc  บAutor  ณEdson Rodrigues     บ Data ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para insercao, altera็ใo e acerto do plano Contas บฑฑ
ฑฑบ          ณ e Lan็amentos Padใo.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACPLANC()

u_GerA0003(ProcName())

PREPARE ENVIRONMENT EMPRESA  "02" FILIAL  "02" TABLES "CT5","CT1"

For x:=1 to 4
  IF x <= 3
     _ctipolp :=alltrim(str(x))
  ENDIF   
  
  
  //----Lancamentos padroes onde a conta debito estแ com a conta = 2110199999  e a mesma deve ser bloqueada conforme tabela enviada pela Contabilidade
  // ----substituir via programa pela conta Porem a Conta = 2110100001
  
  _ccontnew:="2110100001"
  _ccontold:="2110199999"
  U_Altclp1(x,_ctipolp,_ccontnew,_ccontold)
  //U_Altclp2(x,_ctipolp,_ccontnew,_ccontold)  
  //U_Altclp3(x,_ctipolp,_ccontnew,_ccontold)    
  //U_Altclp4(x,_ctipolp,_ccontnew,_ccontold)
  _ccontnew:="1120100001"
  _ccontold:="1120199998"
  U_Altclp5(x,_ctipolp,_ccontnew,_ccontold)
                                          
Next



Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Altclp1  บAutor  ณEdson Rodrigues     บ Data ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera Lps onde a conta debito/credito ้ igual a 2110199999บฑฑ
ฑฑบ          ณ sendo que na nova estrutura deve ficar como 2110100001.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION Altclp1(_nopc,_ctipolp,_ccontnew,_ccontold)
_cqry :=""

//----Lancamentos padroes onde a conta debito estแ com a conta = 2110199999  e a mesma deve ser bloqueada conforme tabela enviada pela Contabilidade
//----substituir via programa pela conta Porem a Conta = 2110100001
_cqry := " SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA, "+ENTER

IF _nopc == 1 .or. _nopc == 3    
   _cqry += " RTRIM(CT5_DEBITO) AS CONTA,CT5.R_E_C_N_O_ AS RECNO "+ENTER
ELSEIF  _nopc == 2 .or. _nopc == 4                                               
   _cqry += " RTRIM(CT5_CREDIT) AS CONTA,CT5.R_E_C_N_O_ AS RECNO "+ENTER 
ENDIF   
_cqry += " FROM "+RETSQLNAME("CT5")+" CT5 "+ENTER
_cqry += " LEFT OUTER JOIN  "+ENTER
_cqry += "     (SELECT CT1_CONTA "+ENTER
_cqry += "      FROM "+RETSQLNAME("CT1")+"  "+ENTER
_cqry += "      WHERE  D_E_L_E_T_='') AS CT1 "+ENTER

IF _nopc == 1 .or. _nopc == 3    
  _cqry += " ON CT1_CONTA=LEFT(CT5_DEBITO,20)"+ENTER  
ELSEIF _nopc == 2 .or. _nopc == 4         
  _cqry += " ON CT1_CONTA=LEFT(CT5_CREDIT,20)"+ENTER
ENDIF 

_cqry += " LEFT OUTER JOIN "+ENTER
_cqry += "     (SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA "+ENTER
_cqry += "      FROM NEWPLANCON "+ENTER
_cqry += "      WHERE RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC "+ENTER

IF _nopc == 1 .or. _nopc == 3    
   _cqry += " ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_DEBITO,20))"+ENTER 
   _cqry += " WHERE CT5_DC='"+_ctipolp+"' AND CT5_DEBITO<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL "+ENTER
ELSEIF _nopc == 2 .or. _nopc == 4                                                                         
   _cqry += " ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_CREDIT,20))"+ENTER 
   _cqry += " WHERE CT5_DC='"+_ctipolp+"' AND CT5_CREDIT<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL "+ENTER
ENDIF   

IF _nopc == 1   
   _cqry += " AND CT5_DEBITO NOT IN ('2170200007','2510100999','3330101009','2150200015') "+ENTER

ELSEIF  _nopc == 2     
   _cqry += " AND ( RTRIM(CT5_CREDIT) NOT IN ('2150200015','3240107014','3240108006') AND  RTRIM(CT5_CREDIT) NOT IN ('1130200007','1130200009','2510100999','3310106015','3310107023','3330101009','3330205006')) "+ENTER

ELSEIF _nopc == 3     
   _cqry += " AND CT5_DEBITO NOT IN ('1130400004','1130400013','1130400023','1130499999','1140200002','1140700001','1140800002' "+ENTER
   _cqry += " ,'1140800005','1140800006','1140800007','1140800008','1320100004','1320100010','1320100998','1320100999','1510100001','1510100003','1510100004','1510100005' "+ENTER  
   _cqry += " ,'1510100006','1510100007','1510100993','1510100994','1510100995','1510100996','1510100997','1510100999','2160400001','2160400002','2160400003','2160400004' "+ENTER
   _cqry += " ,'2160400005','2160400006','2160400007','2160400008','2160400009','2160400010','2160400011','2160400012','2510100999','3110201001','3110301002','3210101002' "+ENTER
   _cqry += " ,'3210101003','3210103001','3220101001','3220101003','3220101005','3220101006','3220101007','3220101008','3230101001','3230107008','3240107001','3310107015' "+ENTER
   _cqry += " ,'3310107021','3310107023','3310107028','3310107047','3320101001','3320101004','3330102001','3370102003','3370102004','3370102005','3370102006') "+ENTER 
   _cqry += " AND CT5_DEBITO NOT IN ('11420200001','2150200011','2150200014','3120101011','3120101012','3240107014') "+ENTER

ELSEIF _nopc == 4     
   _cqry += " AND CT5_CREDIT NOT IN ('1120200001','1130400013','1130499999','1140200002','1140700001','1140800002','1140800007','1320100004','1320100010','1320100998','1320100999','1510100001','1510100003','1510100004','1510100005'"+ENTER
   _cqry += " ,'1510100006','1510100007','1510100993','1510100994','1510100995','1510100996','1510100997','1510100999','2120300999','2160400001','2160400002','2160400003','2160400004','2160400005','2160400006'"+ENTER
   _cqry += " ,'2160400007','2160400008','2160400009','2160400010','2160400011','2160400012','2510100999','3110202001','3110203001','3110301001','3110301002','3210101002','3210103001','3220101003','3220101005'"+ENTER
   _cqry += " ,'3220101006','3220101007','3220101008','3230101001','3230107008','3240107001','3310107015','3310107021','3310107023','3310107028','3320101001','3320101004','3370102001','3370102003','3370102004'"+ENTER
   _cqry += " ,'3370102005','3370102006') AND CT5_CREDIT NOT IN ('2150200011','2150200014','3120101011','3120101012','3240107014') "+ENTER
ENDIF   

IF _nopc == 1 .or. _nopc == 3    
   _cqry += " AND CT5_DEBITO LIKE  '%"+_ccontold+"%' "+ENTER
   _cqry += " ORDER BY CT5_DEBITO " +ENTER
ELSEIF  _nopc == 2 .or. _nopc == 4      
   _cqry += " AND CT5_CREDIT LIKE  '%"+_ccontold+"%' "+ENTER
   _cqry += " ORDER BY CT5_CREDIT " +ENTER
ENDIF
                                                  
if select("TRB") > 0
	TRB->(dbclosearea())
endif



TCQUERY _cqry NEW ALIAS "TRB"
ProcRegua(TRB->(reccount()))

TRB->(dbGoTop())
While TRB->(!eof())
	// Incrementa a regua
	IncProc()                                
	_nrecsz5:=TRB->RECNO
    _cconta := StrTran(alltrim(TRB->CONTA),_ccontold,_ccontnew)
	 
    DBSELECTAREA("CT5")
	CT5->(dbgoto(_nrecsz5))
	
	IF _nopc == 1 .or. _nopc == 3    
		reclock("CT5",.f.)
           	CT5->CT5_DEBITO :=_cconta
	    msunlock()
    ELSEIF  _nopc == 2 .or. _nopc == 4
		reclock("CT5",.f.)
           	CT5->CT5_CREDIT :=_cconta
	    msunlock()
    ENDIF
		
   TRB->(DBSKIP())
Enddo                          


Return()





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Altclp2  บAutor  ณEdson Rodrigues     บ Data ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ LANCAMENTOS COM CONTAS DEBITOS / CREDITO / PD  FIXAS.      บฑฑ
ฑฑบ          ณ  ANALISAR E REGULARIZAR                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION Altclp2(_nopc,_ctipolp,_ccontnew,_ccontold)

_cqry :=""

_cqry := " SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA, "+ENTER
IF _nopc == 1 .or. _nopc == 3    
   _cqry += " RTRIM(CT5_DEBITO) AS DEBITO,* "+ENTER
ELSEIF  _nopc == 2 .or. _nopc == 4                                               
   _cqry += " RTRIM(CT5_CREDIT) AS CREDITO,* "+ENTER 
ENDIF   
_cqry += " FROM "+RETSQLNAME("CT5")+" CT5 "+ENTER
_cqry += " LEFT OUTER JOIN  "+ENTER
_cqry += "     (SELECT CT1_CONTA "+ENTER
_cqry += "      FROM"+RETSQLNAME("CT1")+"  "+ENTER
_cqry += "      WHERE  D_E_L_E_T_='') AS CT1 "+ENTER

IF _nopc == 1 .or. _nopc == 3    
  _cqry += " ON CT1_CONTA=LEFT(CT5_DEBITO,20)"+ENTER  
ELSEIF _nopc == 2 .or. _nopc == 4         
  _cqry += " ON CT1_CONTA=LEFT(CT5_CREDIT,20)"+ENTER
ENDIF 

_cqry += " LEFT OUTER JOIN "+ENTER
_cqry += "     (SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA "+ENTER
_cqry += "      FROM NEWPLANCON "+ENTER
_cqry += "      WHERE RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC "+ENTER

IF _nopc == 1 .or. _nopc == 3    
   _cqry += " ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_DEBITO,20))"+ENTER 
   _cqry += " WHERE CT5_DC='"+_ctipolp+"' AND CT5_DEBITO<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL "+ENTER
ELSEIF _nopc == 2 .or. _nopc == 4                                                                         
   _cqry += " ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_CREDIT,20))"+ENTER 
   _cqry += " WHERE CT5_DC='"+_ctipolp+"' AND CT5_CREDIT<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL "+ENTER
ENDIF   

IF _nopc == 1   
   _cqry += " AND CT5_DEBITO NOT IN ('2170200007','2510100999','3330101009','2150200015') "+ENTER
   _cqry += " AND CT5_DEBITO NOT LIKE  '%2110199999%' AND CT5_DEBITO NOT LIKE '%U_LANC_%' "+ENTER
   _cqry += " AND ( CT5_DEBITO LIKE '%1130300001%' OR CT5_DEBITO LIKE '%2110100001%'    "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%3320207007%' OR CT5_DEBITO LIKE '%1130200004%' "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%1130200009%' OR CT5_DEBITO LIKE '%1130700009%' "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%3330101003%' OR CT5_DEBITO LIKE '%3330101014%' "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%1120199998%') "+ENTER
ELSEIF  _nopc == 2     
   _cqry += " AND  RTRIM(CT5_CREDIT) NOT IN ('2150200015','3240107014','3240108006') AND  RTRIM(CT5_CREDIT) NOT IN ('1130200007','1130200009','2510100999','3310106015','3310107023','3330101009','3330205006'))  "+ENTER
   _cqry += " AND CT5_CREDIT NOT LIKE  '%2110199999%' AND CT5_CREDIT NOT LIKE '%U_LANC_%' "+ENTER
   _cqry += " AND ( CT5_CREDIT LIKE '%1130300001%' OR CT5_CREDIT LIKE '%3320207007%'    "+ENTER
   _cqry += "      OR CT5_CREDIT LIKE '%3330101003%' OR CT5_CREDIT LIKE '%3330101014%'  "+ENTER
   _cqry += "      OR CT5_CREDIT LIKE '%1120199998%' OR CT5_CREDIT LIKE '%112010001%'   "+ENTER
   _cqry += "      OR CT5_CREDIT LIKE '%1120500001%') "+ENTER

ELSEIF _nopc == 3     
   _cqry += " AND CT5_DEBITO NOT IN ('1130400004','1130400013','1130400023','1130499999','1140200002','1140700001','1140800002' "+ENTER
   _cqry += " ,'1140800005','1140800006','1140800007','1140800008','1320100004','1320100010','1320100998','1320100999','1510100001','1510100003','1510100004','1510100005' "+ENTER
   _cqry += " ,'1510100006','1510100007','1510100993','1510100994','1510100995','1510100996','1510100997','1510100999','2160400001','2160400002','2160400003','2160400004' "+ENTER
   _cqry += " ,'2160400005','2160400006','2160400007','2160400008','2160400009','2160400010','2160400011','2160400012','2510100999','3110201001','3110301002','3210101002' "+ENTER
   _cqry += " ,'3210101003','3210103001','3220101001','3220101003','3220101005','3220101006','3220101007','3220101008','3230101001','3230107008','3240107001','3310107015' "+ENTER
   _cqry += " ,'3310107021','3310107023','3310107028','3310107047','3320101001','3320101004','3330102001','3370102003','3370102004','3370102005','3370102006') "+ENTER
   _cqry += " AND CT5_DEBITO NOT IN ('11420200001','2150200011','2150200014','3120101011','3120101012','3240107014') "+ENTER
   _cqry += " AND CT5_DEBITO NOT LIKE  '%2110199999%'  AND CT5_DEBITO NOT LIKE '%U_LANC_%'"+ENTER
   _cqry += " AND ( CT5_DEBITO LIKE '%3110202001%' OR CT5_DEBITO LIKE '%3110203001%'     "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%3110301001%' OR CT5_DEBITO LIKE '%3370102001%'  "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%2160500001%' OR CT5_DEBITO LIKE '%2110100001%'  "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%3120101005%' OR CT5_DEBITO LIKE '%3120101001%'  "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%3120101006%' OR CT5_DEBITO LIKE '%3220101001%'  "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%3210201002%' OR CT5_DEBITO LIKE '%1120100001%'  "+ENTER
   _cqry += "       OR CT5_DEBITO LIKE '%1120400001%' OR CT5_DEBITO LIKE '%1120199998%') "+ENTER

ELSEIF _nopc == 4     
   _cqry += " AND CT5_CREDIT NOT IN ('1120200001','1130400013','1130499999','1140200002','1140700001','1140800002','1140800007','1320100004','1320100010','1320100998','1320100999','1510100001','1510100003','1510100004','1510100005' "+ENTER
   _cqry += " ,'1510100006','1510100007','1510100993','1510100994','1510100995','1510100996','1510100997','1510100999','2120300999','2160400001','2160400002','2160400003','2160400004','2160400005','2160400006'  "+ENTER
   _cqry += " ,'2160400007','2160400008','2160400009','2160400010','2160400011','2160400012','2510100999','3110202001','3110203001','3110301001','3110301002','3210101002','3210103001','3220101003','3220101005'  "+ENTER
   _cqry += " ,'3220101006','3220101007','3220101008','3230101001','3230107008','3240107001','3310107015','3310107021','3310107023','3310107028','3320101001','3320101004','3370102001','3370102003','3370102004'  "+ENTER
   _cqry += " ,'3370102005','3370102006')  "+ENTER
   _cqry += " AND CT5_CREDIT NOT IN ('2150200011','2150200014','3120101011','3120101012','3240107014') "+ENTER
   _cqry += " AND CT5_CREDIT NOT LIKE  '%2110199999%' AND CT5_CREDIT NOT LIKE '%U_LANC_%'              "+ENTER
   _cqry += " AND ( CT5_CREDIT LIKE '%2160500001%' OR CT5_CREDIT LIKE '%2110100001%'     "+ENTER
   _cqry += "       OR CT5_CREDIT LIKE '%1130300001%' OR CT5_CREDIT LIKE '%3120101005%'  "+ENTER
   _cqry += "       OR CT5_CREDIT LIKE '%1120199998%' OR CT5_CREDIT LIKE '%3120101001%'  "+ENTER
   _cqry += "       OR CT5_CREDIT LIKE '%3120101006%' OR CT5_CREDIT LIKE '%3210201002%'  "+ENTER
   _cqry += "       OR CT5_CREDIT LIKE '%3220101001%' OR CT5_CREDIT LIKE '%3210201002%') "+ENTER
ENDIF   
IF _nopc == 1 .or. _nopc == 3    
   _cqry += " ORDER BY CT5_DEBITO " +ENTER
ELSEIF  _nopc == 2 .or. _nopc == 4      
   _cqry += " ORDER BY CT5_CREDIT " +ENTER
ENDIF

if select("TRB") > 0
	TRB->(dbclosearea())
endif


TCQUERY _cqry NEW ALIAS "TRB"
ProcRegua(TRB->(reccount()))

TRB->(dbGoTop())
While TRB->(!eof())
	// Incrementa a regua
	IncProc()


   TRB->(DBSKIP())
Enddo                          



Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Altclp3  บAutor  ณEdson Rodrigues     บ Data ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ LANCAMENTOS COM CONTAS DEBITO, CREDITOS OU PD VIA          บฑฑ
ฑฑบ          ณ PROGRAMAS DA FOLHA, ANALISAR E REGULARIZAR                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION Altclp3(_nopc,_ctipolp,_ccontnew,_ccontold)

//SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA,RTRIM(CT5_DEBITO) AS DEBITO,* FROM CT5020 
//LEFT OUTER JOIN 
//(SELECT CT1_CONTA FROM CT1020 WHERE /*CT1_BLOQ<>'1' AND*/ D_E_L_E_T_='') AS CT1 
//ON CT1_CONTA=LEFT(CT5_DEBITO,20)
//LEFT OUTER JOIN 
//(SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA FROM NEWPLANCON WHERE /*CONTASBD<>CONTASNEWBD AND*/ RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC
//ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_DEBITO,20)) 
//WHERE CT5_DC='1' AND CT5_DEBITO<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL 
//AND CT5_DEBITO NOT IN ('2170200007','2510100999','3330101009','2150200015') --AND CONTASNEWBD IS NULL 
//AND CT5_DEBITO NOT LIKE  '%2110199999%' AND CT5_DEBITO LIKE '%U_LANC_%'
//ORDER BY CT5_DEBITO


//CREDITO///
//SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA,RTRIM(CT5_CREDIT) AS CREDITO,* FROM CT5020 
//LEFT OUTER JOIN 
//(SELECT CT1_CONTA FROM CT1020 WHERE CT1_BLOQ<>'1' AND D_E_L_E_T_='') AS CT1 
//ON CT1_CONTA=LEFT(CT5_CREDIT,20)
//LEFT OUTER JOIN 
//(SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA FROM NEWPLANCON WHERE CONTASBD<>CONTASNEWBD AND RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC
//ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_CREDIT,20)) 
//WHERE CT5_DC='2' AND CT5_CREDIT<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL 
//AND ( RTRIM(CT5_CREDIT) NOT IN ('2150200015','3240107014','3240108006') AND  RTRIM(CT5_CREDIT) NOT IN ('1130200007','1130200009','2510100999','3310106015','3310107023','3330101009','3330205006')) AND CONTASNEWBD IS NULL 
//AND CT5_CREDIT NOT LIKE  '%2110199999%' AND CT5_CREDIT LIKE '%U_LANC_%'
//ORDER BY CT5_CREDIT  


//----lANวAMENTOS ( PARTIDA DOBRADA ) COM CONTAS DEBITOS VIA PROGRAMAS DA FOLHA, ANALISAR E REGULARIZAR //
//SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA,RTRIM(CT5_DEBITO) AS DEBITO,* FROM CT5020 
//LEFT OUTER JOIN 
//(SELECT CT1_CONTA FROM CT1020 WHERE CT1_BLOQ<>'1' AND D_E_L_E_T_='') AS CT1 
//ON CT1_CONTA=LEFT(CT5_DEBITO,20)
//LEFT OUTER JOIN 
//(SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA FROM NEWPLANCON WHERE CONTASBD<>CONTASNEWBD AND RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC
//ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_DEBITO,20)) 
//WHERE CT5_DC='3' AND CT5_DEBITO<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL 
//AND CT5_DEBITO NOT IN ('1130400004','1130400013','1130400023','1130499999','1140200002','1140700001','1140800002'
//,'1140800005','1140800006','1140800007','1140800008','1320100004','1320100010','1320100998','1320100999','1510100001','1510100003','1510100004','1510100005'
//,'1510100006','1510100007','1510100993','1510100994','1510100995','1510100996','1510100997','1510100999','2160400001','2160400002','2160400003','2160400004'
//,'2160400005','2160400006','2160400007','2160400008','2160400009','2160400010','2160400011','2160400012','2510100999','3110201001','3110301002','3210101002'
//,'3210101003','3210103001','3220101001','3220101003','3220101005','3220101006','3220101007','3220101008','3230101001','3230107008','3240107001','3310107015'
//,'3310107021','3310107023','3310107028','3310107047','3320101001','3320101004','3330102001','3370102003','3370102004','3370102005','3370102006') AND CONTASNEWBD IS NULL 
//AND CT5_DEBITO NOT IN ('11420200001','2150200011','2150200014','3120101011','3120101012','3240107014')
//AND CT5_DEBITO NOT LIKE  '%2110199999%' AND CT5_DEBITO LIKE '%U_LANC_%'
//ORDER BY CT5_DEBITO                               



//----lANวAMENTOS (PARTIDA DOBRADA) COM CONTAS CREDITOS VIA PROGRAMAS DA FOLHA, ANALISAR E REGULARIZAR //
//SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA,RTRIM(CT5_CREDIT) AS CREDITO,* FROM CT5020 
//LEFT OUTER JOIN 
//(SELECT CT1_CONTA FROM CT1020 WHERE CT1_BLOQ<>'1' AND D_E_L_E_T_='') AS CT1 
//ON CT1_CONTA=LEFT(CT5_CREDIT,20)
//LEFT OUTER JOIN 
//(SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA FROM NEWPLANCON WHERE CONTASBD<>CONTASNEWBD AND RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC
//ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_CREDIT,20)) 
//WHERE CT5_DC='3' AND CT5_CREDIT<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL 
//AND CT5_CREDIT NOT IN ('1120200001','1130400013','1130499999','1140200002','1140700001','1140800002','1140800007','1320100004','1320100010','1320100998','1320100999','1510100001','1510100003','1510100004','1510100005'
//,'1510100006','1510100007','1510100993','1510100994','1510100995','1510100996','1510100997','1510100999','2120300999','2160400001','2160400002','2160400003','2160400004','2160400005','2160400006'
//,'2160400007','2160400008','2160400009','2160400010','2160400011','2160400012','2510100999','3110202001','3110203001','3110301001','3110301002','3210101002','3210103001','3220101003','3220101005'
//,'3220101006','3220101007','3220101008','3230101001','3230107008','3240107001','3310107015','3310107021','3310107023','3310107028','3320101001','3320101004','3370102001','3370102003','3370102004'
//,'3370102005','3370102006')
//AND CT5_CREDIT NOT IN ('2150200011','2150200014','3120101011','3120101012','3240107014')
//AND CONTASNEWBD IS NULL 
//AND CT5_CREDIT NOT LIKE  '%2110199999%' AND CT5_CREDIT LIKE '%U_LANC_%'
//ORDER BY CT5_CREDIT




Return()


                                  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Altclp4  บAutor  ณEdson Rodrigues     บ Data ณ  13/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ LANCAMENTOS COM CONTAS DEBITOS / CREDITOS OU PD            บฑฑ
ฑฑบ          ณ VIA OUTRAS FORMULAS OU PROGRAMAS, ANALISAR E REGULARIZAR   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION Altclp4(_nopc,_ctipolp,_ccontnew,_ccontold)

//DEBITO
//SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA,RTRIM(CT5_DEBITO) AS DEBITO,* FROM CT5020 
//LEFT OUTER JOIN 
//(SELECT CT1_CONTA FROM CT1020 WHERE /*CT1_BLOQ<>'1' AND*/ D_E_L_E_T_='') AS CT1 
//ON CT1_CONTA=LEFT(CT5_DEBITO,20)
//LEFT OUTER JOIN 
//(SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA FROM NEWPLANCON WHERE /*CONTASBD<>CONTASNEWBD AND*/ RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC
//ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_DEBITO,20)) 
//WHERE CT5_DC='1' AND CT5_DEBITO<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL 
//AND CT5_DEBITO NOT IN ('2170200007','2510100999','3330101009','2150200015') --AND CONTASNEWBD IS NULL 
//AND CT5_DEBITO NOT LIKE  '%2110199999%' 
//AND ( CT5_DEBITO NOT LIKE '%1130300001%' AND CT5_DEBITO NOT LIKE '%2110100001%'
//      AND CT5_DEBITO NOT LIKE '%3320207007%' AND CT5_DEBITO NOT LIKE '%1130200004%' 
//      AND CT5_DEBITO NOT LIKE '%1130200009%' AND CT5_DEBITO NOT LIKE '%1130700009%' 
//      AND CT5_DEBITO NOT LIKE '%3330101003%' AND CT5_DEBITO NOT LIKE '%3330101014%'
//      AND CT5_DEBITO NOT LIKE '%1120199998%')
//AND CT5_DEBITO NOT LIKE '%U_LANC%'
//ORDER BY CT5_DEBITO




//----lANวAMENTOS COM CONTAS CREDITOS VIA FORMULAS OU OUTROS PROGRAMAS, ANALISAR E REGULARIZAR
//SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA,RTRIM(CT5_CREDIT) AS CREDITO,* FROM CT5020 
//LEFT OUTER JOIN 
//(SELECT CT1_CONTA FROM CT1020 WHERE CT1_BLOQ<>'1' AND D_E_L_E_T_='') AS CT1 
//ON CT1_CONTA=LEFT(CT5_CREDIT,20)
//LEFT OUTER JOIN 
//(SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA FROM NEWPLANCON WHERE CONTASBD<>CONTASNEWBD AND RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC
//ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_CREDIT,20)) 
//WHERE CT5_DC='2' AND CT5_CREDIT<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL 
//AND ( RTRIM(CT5_CREDIT) NOT IN ('2150200015','3240107014','3240108006') AND  RTRIM(CT5_CREDIT) NOT IN ('1130200007','1130200009','2510100999','3310106015','3310107023','3330101009','3330205006')) AND CONTASNEWBD IS NULL 
//AND ( CT5_CREDIT NOT LIKE '%1130300001%' AND CT5_CREDIT NOT LIKE '%3320207007%'
//      OR CT5_CREDIT NOT LIKE '%3330101003%' AND CT5_CREDIT NOT LIKE '%3330101014%' 
//      OR CT5_CREDIT NOT LIKE '%1120199998%' AND CT5_CREDIT NOT LIKE '%112010001%' 
//      OR CT5_CREDIT NOT LIKE '%1120500001%')
//AND CT5_CREDIT NOT LIKE  '%2110199999%' AND CT5_CREDIT NOT LIKE '%U_LANC_%'
//ORDER BY CT5_CREDIT


//----lANวAMENTOS (PARTIDA DOBRADA) COM CONTAS DEBITOS VIA FORMULAS OU OUTROS PROGRAMAS, ANALISAR E REGULARIZAR
//SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA,RTRIM(CT5_DEBITO) AS DEBITO,* FROM CT5020 
//LEFT OUTER JOIN 
//(SELECT CT1_CONTA FROM CT1020 WHERE /*CT1_BLOQ<>'1' AND*/ D_E_L_E_T_='') AS CT1 
//ON CT1_CONTA=LEFT(CT5_DEBITO,20)
//LEFT OUTER JOIN 
//(SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA FROM NEWPLANCON WHERE /*CONTASBD<>CONTASNEWBD AND*/ RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC
//ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_DEBITO,20)) 
//WHERE CT5_DC='3' AND CT5_DEBITO<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL 
//AND CT5_DEBITO NOT IN ('1130400004','1130400013','1130400023','1130499999','1140200002','1140700001','1140800002'
//,'1140800005','1140800006','1140800007','1140800008','1320100004','1320100010','1320100998','1320100999','1510100001','1510100003','1510100004','1510100005'
//,'1510100006','1510100007','1510100993','1510100994','1510100995','1510100996','1510100997','1510100999','2160400001','2160400002','2160400003','2160400004'
//,'2160400005','2160400006','2160400007','2160400008','2160400009','2160400010','2160400011','2160400012','2510100999','3110201001','3110301002','3210101002'
//,'3210101003','3210103001','3220101001','3220101003','3220101005','3220101006','3220101007','3220101008','3230101001','3230107008','3240107001','3310107015'
//,'3310107021','3310107023','3310107028','3310107047','3320101001','3320101004','3330102001','3370102003','3370102004','3370102005','3370102006') --AND CONTASNEWBD IS NULL 
//AND CT5_DEBITO NOT IN ('11420200001','2150200011','2150200014','3120101011','3120101012','3240107014')
//AND CT5_DEBITO NOT LIKE  '%2110199999%'  AND CT5_DEBITO NOT LIKE '%U_LANC_%'
//AND ( CT5_DEBITO NOT LIKE '%3110202001%' AND CT5_DEBITO NOT LIKE '%3110203001%'
//      AND CT5_DEBITO NOT LIKE '%3110301001%' AND CT5_DEBITO NOT LIKE '%3370102001%' 
//      AND CT5_DEBITO NOT LIKE '%2160500001%' AND CT5_DEBITO NOT LIKE '%2110100001%' 
//      AND CT5_DEBITO NOT LIKE '%3120101005%' AND CT5_DEBITO NOT LIKE '%3120101001%'
//      AND CT5_DEBITO NOT LIKE '%3120101006%' AND CT5_DEBITO NOT LIKE '%3220101001%'
//      AND CT5_DEBITO NOT LIKE '%3210201002%' AND CT5_DEBITO NOT LIKE '%1120100001%'
//      AND CT5_DEBITO NOT LIKE '%1120400001%' AND CT5_DEBITO NOT LIKE '%1120199998%')
//ORDER BY CT5_DEBITO


//----lANวAMENTOS (PARTIDA DOBRADA) COM CONTAS CREDITOS VIA FORMULAS OU OUTROS PROGRAMAS, ANALISAR E REGULARIZAR
//SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA,RTRIM(CT5_CREDIT) AS CREDITO,* FROM CT5020 
//LEFT OUTER JOIN 
//(SELECT CT1_CONTA FROM CT1020 WHERE CT1_BLOQ<>'1' AND D_E_L_E_T_='') AS CT1 
//ON CT1_CONTA=LEFT(CT5_CREDIT,20)
//LEFT OUTER JOIN 
//(SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA FROM NEWPLANCON WHERE CONTASBD<>CONTASNEWBD AND RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC
//ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_CREDIT,20)) 
//WHERE CT5_DC='3' AND CT5_CREDIT<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL 
//AND CT5_CREDIT NOT IN ('1120200001','1130400013','1130499999','1140200002','1140700001','1140800002','1140800007','1320100004','1320100010','1320100998','1320100999','1510100001','1510100003','1510100004','1510100005'
//,'1510100006','1510100007','1510100993','1510100994','1510100995','1510100996','1510100997','1510100999','2120300999','2160400001','2160400002','2160400003','2160400004','2160400005','2160400006'
//,'2160400007','2160400008','2160400009','2160400010','2160400011','2160400012','2510100999','3110202001','3110203001','3110301001','3110301002','3210101002','3210103001','3220101003','3220101005'
//,'3220101006','3220101007','3220101008','3230101001','3230107008','3240107001','3310107015','3310107021','3310107023','3310107028','3320101001','3320101004','3370102001','3370102003','3370102004'
//,'3370102005','3370102006')
//AND CT5_CREDIT NOT IN ('2150200011','2150200014','3120101011','3120101012','3240107014')
//AND ( CT5_CREDIT NOT LIKE '%2160500001%' AND CT5_CREDIT NOT LIKE '%2110100001%'
//      AND CT5_CREDIT NOT LIKE '%1130300001%' AND CT5_CREDIT NOT LIKE '%3120101005%' 
//      AND CT5_CREDIT NOT LIKE '%1120199998%' AND CT5_CREDIT NOT LIKE '%3120101001%' 
//      AND CT5_CREDIT NOT LIKE '%3120101006%' AND CT5_CREDIT NOT LIKE '%3210201002%'
//      AND CT5_CREDIT NOT LIKE '%3220101001%' AND CT5_CREDIT NOT LIKE '%3210201002%'
//      AND CT5_CREDIT NOT LIKE '%3240103019%')
//AND CONTASNEWBD IS NULL 
//AND CT5_CREDIT NOT LIKE  '%2110199999%' AND CT5_CREDIT NOT LIKE '%U_LANC_%'
//ORDER BY CT5_CREDIT

Return()






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Altclp5  บAutor  ณEdson Rodrigues     บ Data ณ  19/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera Lps onde a conta debito/credito ้ igual a 1120199998บฑฑ
ฑฑบ          ณ sendo que na nova estrutura deve ficar como 1120100001.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION Altclp5(_nopc,_ctipolp,_ccontnew,_ccontold)
_cqry :=""

//----Lancamentos padroes onde a conta debito estแ com a conta = 2110199999  e a mesma deve ser bloqueada conforme tabela enviada pela Contabilidade
//----substituir via programa pela conta Porem a Conta = 2110100001
_cqry := " SELECT CT1_CONTA,CONTASBD,CONTASNEWBD,NOVAESTRUTURA, "+ENTER

IF _nopc == 1 .or. _nopc == 3    
   _cqry += " RTRIM(CT5_DEBITO) AS CONTA,CT5.R_E_C_N_O_ AS RECNO "+ENTER
ELSEIF  _nopc == 2 .or. _nopc == 4                                               
   _cqry += " RTRIM(CT5_CREDIT) AS CONTA,CT5.R_E_C_N_O_ AS RECNO "+ENTER 
ENDIF   
_cqry += " FROM "+RETSQLNAME("CT5")+" CT5 "+ENTER
_cqry += " LEFT OUTER JOIN  "+ENTER
_cqry += "     (SELECT CT1_CONTA "+ENTER
_cqry += "      FROM "+RETSQLNAME("CT1")+"  "+ENTER
_cqry += "      WHERE  D_E_L_E_T_='') AS CT1 "+ENTER

IF _nopc == 1 .or. _nopc == 3    
  _cqry += " ON CT1_CONTA=LEFT(CT5_DEBITO,20)"+ENTER  
ELSEIF _nopc == 2 .or. _nopc == 4         
  _cqry += " ON CT1_CONTA=LEFT(CT5_CREDIT,20)"+ENTER
ENDIF 

_cqry += " LEFT OUTER JOIN "+ENTER
_cqry += "     (SELECT CONTASBD,CONTASNEWBD,NOVAESTRUTURA "+ENTER
_cqry += "      FROM NEWPLANCON "+ENTER
_cqry += "      WHERE RTRIM(NOVAESTRUTURA) NOT IN ('bloquear','BLOQUEAR','bloquer')) AS NEWPLC "+ENTER

IF _nopc == 1 .or. _nopc == 3    
   _cqry += " ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_DEBITO,20))"+ENTER 
   _cqry += " WHERE CT5_DC='"+_ctipolp+"' AND CT5_DEBITO<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL "+ENTER
ELSEIF _nopc == 2 .or. _nopc == 4                                                                         
   _cqry += " ON RTRIM(LEFT(CONTASBD,20))=RTRIM(LEFT(CT5_CREDIT,20))"+ENTER 
   _cqry += " WHERE CT5_DC='"+_ctipolp+"' AND CT5_CREDIT<> '' AND D_E_L_E_T_='' AND CT1_CONTA IS NULL "+ENTER
ENDIF   

IF _nopc == 1 .or. _nopc == 3    
   _cqry += " AND CT5_DEBITO LIKE  '%"+_ccontold+"%' "+ENTER
   _cqry += " ORDER BY CT5_DEBITO " +ENTER
ELSEIF  _nopc == 2 .or. _nopc == 4      
   _cqry += " AND CT5_CREDIT LIKE  '%"+_ccontold+"%' "+ENTER
   _cqry += " ORDER BY CT5_CREDIT " +ENTER
ENDIF
                                                  
if select("TRB") > 0
	TRB->(dbclosearea())
endif



TCQUERY _cqry NEW ALIAS "TRB"
ProcRegua(TRB->(reccount()))

TRB->(dbGoTop())
While TRB->(!eof())
	// Incrementa a regua
	IncProc()                                
	_nrecsz5:=TRB->RECNO
    _cconta := StrTran(alltrim(TRB->CONTA),_ccontold,_ccontnew)
	 
    DBSELECTAREA("CT5")
	CT5->(dbgoto(_nrecsz5))
	
	IF _nopc == 1 .or. _nopc == 3    
		reclock("CT5",.f.)
           	CT5->CT5_DEBITO :=_cconta
	    msunlock()
    ELSEIF  _nopc == 2 .or. _nopc == 4
		reclock("CT5",.f.)
           	CT5->CT5_CREDIT :=_cconta
	    msunlock()
    ENDIF
		
   TRB->(DBSKIP())
Enddo                          


Return()