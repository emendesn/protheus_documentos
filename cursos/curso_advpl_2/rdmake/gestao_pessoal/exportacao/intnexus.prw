#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function Intnexux()    
PRIVATE cPerg := space(10)	 
cPerg :="XNEXUX"     
ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() ) 
//Local cArquivo   := alltrim(cRootPath) + alltrim(cStartPath) + alltrim(mv_par01)   
Local cArquivo   := alltrim(mv_par01)   
Local cQry1 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local nTotReg := 0

Private nRelat := mv_par07

u_GerA0003(ProcName())
nHandle := MsfCreate(alltrim(MV_PAR01),0)


IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif       
DbSelectArea("SRV")
DbSetOrder(1)
DbSelectArea("SRC")
DbSetOrder(1)
DbSelectArea("CTT")
DbSetOrder(1)
DbSelectArea("SRJ") // FUNCOES
DbSetOrder(1)
cQuery := " SELECT RA_FILIAL,RA_MAT,RA_CC,RA_NOME,RA_DEPIR,RA_DEPSF,RA_BCDEPSA,RA_CTDEPSA,RA_CODFUNC,RA_SALARIO,RA_DEMISSA,RA_ADMISSA,RA_NASC,RA_SEXO,RA_CIC,RA_ESTCIVI,RA_SITFOLH "
cQuery += " FROM " + RetSqlName("SRA") + " SRA (nolock) "
cQuery += " WHERE  "
cQuery += "	SRA.D_E_L_E_T_ = ' ' "    
IF MV_PAR02 = 2
	cQuery += " AND SRA.RA_SITFOLH NOT IN('D')"    
EndIF	
cQuery += " AND SRA.RA_MAT >= '" + MV_PAR03 + "' "
cQuery += " AND SRA.RA_MAT <= '" + MV_PAR04 + "' "
cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_NOME "
TCQUERY cQuery NEW ALIAS "QRY1"
DBSELECTAREA("QRY1")     
procregua(reccount())
QRY1->(DBGOTOP())   
ntotReg := 0
/*GRAVACAO DO REGISTRO HEADER */ 
clinha := "00" // Registro de abertura do arquivo
cLinha += Gravadata(ddatabase,.f.,8) + substr(time(),1,2) + substr(time(),4,2) + substr(time(),7,2)    //DATA DO MOVIMENTO aaaammddhhmmss
cLinha += '00003045' // 	Número que identifica a empresa na Base Brasil.
cLinha += space(255) //Campo reservado para expansão.
cLinha += space(9) // Uso livre
fWrite(nHandle, cLinha  + cCrLf)                 

DO WHILE !QRY1->(EOF())
	CTT->(Dbseek(xfilial("CTT") + QRY1->RA_CC))
	SRJ->(Dbseek(xfilial("SRJ") + QRY1->RA_CODFUNC))
	SRC->(dbSeek(XFILIAL("SRC") + QRY1->RA_MAT))
		
	/* GRAVACAO DO REGISTRO DETALHE */
	clinha := Iif(QRY1->RA_SITFOLH = 'D',"03","01") // TIPO DE REGISTRO :1 = Inclusão / 2 = Alteração / 3 = Cancelamento / 4 = Posição Cadastral - Registro para conferência.
	cLinha += '00003045' // 	Número que identifica a empresa na Base Brasil.
    cLinha += REPLICATE('0',3) //SUBEMPRESA - Código subfatural/ filial/ unidade na Base Brasil.
    cLinha += QRY1->RA_CC + space(40 - len(QRY1->RA_CC)) //Departamento ou Centro de Custo.
    cLinha += space(40) // Informação complementar sobre Centro de custos / departamentos / outros. Permite gravação de informações para efeitos de classificação e agrupamento. Livre utilização para empresa.
    cLinha += QRY1->RA_MAT + space(20 - len(QRY1->RA_MAT)) //	O campo matrícula / chapa, é chave dentro do contrato da empresa. Deve identificar o funcionário de forma exclusiva.
    cLinha += QRY1->RA_NOME + space(70 - len(QRY1->RA_NOME)) // NOME DO SEGURADO
    cLinha += QRY1->RA_NASC // DATA DE NASCIMENTO
    cLinha += IIF(QRY1->RA_SEXO='F','02','01') // SEXO
    cLinha += IIF(EMPTY(QRY1->RA_CIC),REPLICATE('0',11),QRY1->RA_CIC) // CPF
    cLinha += Iif(QRY1->RA_ESTCIVI = 'C','2',IIF(QRY1->RA_ESTCIVI='S','1',IIF(QRY1->RA_ESTCIVI='J','4',IIF(QRY1->RA_ESTCIVI='V','3','6')))) // ESTADO CIVIL 1 - Solteiro  / 2 - Casado / 3 - Viúvo / 4 - Separado ou Divorciado / 5 - Amasiado / 6 - Outros
    cLinha += SRJ->RJ_DESC + SPACE(25-LEN(SRJ->RJ_DESC)) // CARGO DO FUNCIONARIO
    cLinha += QRY1->RA_CC + space(20 - len(QRY1->RA_CC)) // Centro de Custo.
    cLinha += QRY1->RA_CC + space(20 - len(QRY1->RA_CC)) // Supervisão do segurado.
    cLinha += QRY1->RA_CC + space(20 - len(QRY1->RA_CC)) //Gerencia do funcionário
    fWrite(nHandle, cLinha  + cCrLf)                 
    ntotReg++
	QRY1->(DbSkip())
	Incproc()
EndDo
//Registro Tipo Trailer - Finalização do Arquivo
cLinha := StrZero(ntotReg,6)// Quantidade de registros do arquivo.
cLinha += space (282)
fWrite(nHandle, cLinha  + cCrLf)                 
fClose(nHandle)                         
MsgAlert( "Arquivo Gerado !" )
Return .T.                                                   

//CRIACAO DA PERGUNTA //
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
        //X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
         //	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44

  AAdd(aRegs,{cPerg,"01","Arquivo destino : "      ,""   				,""  			,"mv_ch1",	"C",		70      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                     

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return

Static Function Streeper(cVar,nlen)
cVar = StrTran('\',cvar,'')
cVar = StrTran('/',cvar,'')
cVar = StrTran('.',cvar,'')
cVar = StrTran('-',cvar,'')
cVar = Alltrim(cVar)
cVar = alltrim(cVar) + space(nLen - Len(alltrim(cvar)))
Return(cVar)

