#INCLUDE 'PONA130.CH'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PONCALEN.CH"

#DEFINE Confirma 1
#DEFINE Redigita 2
#DEFINE Abandona 3

/*
+------------+---------+--------+---------------+-------+--------------+
| Programa:  |  BPn130 | Autor: | Rogerio Alves | Data: | Setembro/2013|
+------------+---------+--------+---------------+-------+--------------+
| Descri��o: | Fonte padr�o de apontamentos PONA130 para montagem de   |
|            | filtro dos c�digos de evento                            |
+------------+---------------------------------------------------------+
| Uso:       | BGH                                                     |
+------------+---------------------------------------------------------+
*/


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Pona130  � Autor � Mauro Sergio          � Data � 09.09.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manutencao dos Apontamentos                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marinaldo   �21/04/04�Melhor�Tratamento de Lock e Delecao de Registros ��� 
��� 		   �--------�------|										  ���
���Luiz Gustavo�14/11/06�Melhor�Inclusao da funcao MenuDef() para versao  ���
���			   �--------�------� 9.12                      				  ���
���Mauricio MR �30/03/07�Melhor�Ajuste na implementacao do Menu Funcional.���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������/*/ 

USER Function BPn130()

Private aRotina		:= U__MenuDef() //Funcao MenuDef contendo aRotina
U__NewPona130( "PONA130" )
Return (Nil)

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    � NewPona130()	�Autor�                   � Data �30/03/2007�
�����������������������������������������������������������������������Ĵ
�Descri��o � Programa principal separado para tratamento da funcao      �
�          � MenuDef().                                                 �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �PONA130, PONA190                                                    �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/

USER Function _NewPona130( cChamada )

Local aArea			 := GetArea()
Local aIndexSRA		 := {}
Local cFiltraSRA	 := ""

Private cCadastro	 := ""
Private cPrefix		 := ""
Private cAliasApont	 := ""
Private cProg		 := IF( cChamada == NIL , FunName() , cChamada )
Private cPonmes		 := ''
Private dPerIni		 := Ctod("//")
Private dPerFim		 := Ctod("//")
Private lPona190	 := fContemStr( cProg , "PONA190" , .T. )

CALEND_POS_ORDEM := 02

// Bloqueio para uso exclusivo RH
DbSelectArea("SPO") // PER�ODO DE APONTAMENTO
DbSetOrder(3)
SPO->(dbSeek(xFilial("SPO") + DtoS(dDataBase), .T.))

If SPO->PO__STATUS == "2" //Posicione("SPO",3,xFilial("SPO")+DtoS(dDataBase),"PO__STATUS") == "2" //1=LIBERADO;2=EXCLUSIVO RH
   MsgAlert ("Per�odo Bloqueado. Aguarde libera��o do RH") 
   Return Nil
EndIf

SPO->( dbCloseArea() )

/*
������������������������������������������������������������������������Ŀ
�So executa se o Modo de Acesso do SPC e SRA foram iguais e se este  ulti�
�mo nao estiver vazio 													 �
��������������������������������������������������������������������������*/
IF ( ValidArqPon() .and. ChkVazio('SRA') )

	Private bFiltraBrw	:= {|| Nil }		
	Private aTabPadrao	:= {}

    If  !lPona190
		cCadastro 	:= OemToAnsi(STR0011)	//"Manuten��o dos Apontamentos"
		cAliasApont	:= "SPC"
	Else   
		cCadastro	:= OemToAnsi(STR0093)	//"Manuten��o Acumulado dos Apontamentos"
		cAliasApont	:= "SPH"	
	Endif
	
	/*
	������������������������������������������������������������������������Ŀ
	�Obtem o Prefixo dos Campos												 �
	��������������������������������������������������������������������������*/
	cPrefix := ( PrefixoCpo( cAliasApont ) + "_" )

	/*
	������������������������������������������������������������������������Ŀ
	� Inicializa o filtro utilizando a funcao FilBrowse                      �
	��������������������������������������������������������������������������*/
	cFiltraRh	:= ChkRh(cProg,"SRA","1")
	bFiltraBrw	:= {|| FilBrowse("SRA",@aIndexSRA,@cFiltraRH) }
	Eval(bFiltraBrw)
	
	dbSelectArea("SRA")
	mBrowse( 6, 1,22,75,"SRA",,,,,,fCriaCor() )
	
	/*
	������������������������������������������������������������������������Ŀ
	� Deleta o filtro utilizando a funcao FilBrowse                     	 �
	��������������������������������������������������������������������������*/
	EndFilBrw("SRA",aIndexSra)



EndIF

RestArea( aArea )

Return( NIL )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PN130Atu  � Autor � Mauro Sergio          � Data � 23.04.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de (Vis.,Inc.,Alt. e Del. de  dependentes         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � gp020Atu(ExpC1,ExpN1,ExpN2)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Pona130                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER Function _Pn130Atu(cAlias,nReg,nOpcx)

Local aSvKeys		:= GetKeys()
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local aRecnos		:= {}
Local aQueryCond	:= {}
Local aGdAltera		:= {}
Local aGdNoFields	:= {cPrefix+"FILIAL",cPrefix+"MAT"}
Local aGdNaoAltera	:= {cPrefix+"FILIAL",cPrefix+"MAT",cPrefix+"FLAG"}
Local aVisual		:= {}
Local bSkip			:= { || .F. }
Local cFil			:= SRA->RA_FILIAL
Local cMat      	:= SRA->RA_MAT
Local cNome     	:= SRA->RA_NOME
Local dPerIniPar	:= Ctod("//")  
Local dPerFimPar	:= Ctod("//")

//-- Variaveis para Verificacao de Bloqueios
Local lMarcacao		:= .F.
Local lApontamento	:= .F.
Local lAbono		:= .F.
Local nSavRec   	:= RecNo()
Local nCnt			:= 0   
Local nLenRecnos    := 0
Local nPosDt		:= 0
Local nPosPd		:= 0
Local nPosTp		:= 0
Local nPosCC		:= 0
Local nPosDesc		:= 0
Local oDlg
Local oFont
Local oGroup 

//Anadi
Local _CodEvent 	:= GetMv("MV__CODEVE") //Codigo do evento utilizado no filtro do fonte de Apontamentos
Local _cFiltro 		:= ""
Local _cQuery 		:= ""
//Fim

Private aTabCalend	:= {}
Private aAC       	:= {STR0003 ,STR0001 } // "Abandona"###"Confirma"
Private aColsRec  	:= {}   //--Array que contem o Recno() dos registros da aCols
Private aColsAnt  	:= {}
Private aVirtual  	:= {}
Private nPosSRA   	:= SRA->(RECNO())
Private oGet      

/*
������������������������������������������������������������������������Ŀ
�Quando For Acumulado Verifica o Periodo que foi previamente  Selecionado�
�pelo Usuario													 		 �
��������������������������������������������������������������������������*/
IF ( lPona190 )
	dPerIni := SPO->PO_DATAINI
	dPerFim := SPO->PO_DATAFIM
	IF ( Empty( dPerIni ) .or. Empty( dPerFim ) )
		Help( "" , 1 , "SPONOTPERC" )
		Return( .F. )
	EndIF
Else
	/*
	������������������������������������������������������������������������Ŀ
	�Caso Contrario Verifica se o Periodo eh Valido atraves de CheckPonmes() �
	��������������������������������������������������������������������������*/
	IF !( CheckPonMes( @dPerIni , @dPerFim , .F. , .T. , !lPona190 ) ) 
		Return( .F. )
	EndIF
EndIF
	
/*
������������������������������������������������������������������������Ŀ
�Valida o Periodo de Apontamento para Digitacao das Informacoes          �
��������������������������������������������������������������������������*/
IF !( GetPonMesDat( @dPerIniPar , @dPerFimPar ) .and. ValidPonData(dPerIni,"P",dPerIniPar,dPerFimPar,lPona190,.T.) )
	Return( .F. )
EndIF

/*
��������������������������������������������������������������Ŀ
� Monta as Dimensoes dos Objetos         					   �
����������������������������������������������������������������*/
aAdvSize		:= MsAdvSize()
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

//��������������������������������������������������������������Ŀ
//� Carrega Array de Campos Alteraveis                           �
//����������������������������������������������������������������
cAlias := cAliasApont

While .T.
	
	/*
	��������������������������������������������������������������Ŀ
	�Bloqueia Chaves Logicas de Marcacoes do Funcionario           �
	����������������������������������������������������������������*/
	If !(lApontamento:= u__Pona130Locks( nOpcX , cAliasApont, {} )) .or.;
	   !(lMarcacao   := u__Pona130Locks( nOpcX , IF( cAliasApont=='SPC', "SP8" , "SPG" ), {} ))  .or.;
	   !(lAbono		 := u__Pona130Locks( nOpcX , "SPK" , {} ))
       Exit
    Endif
	
	aTabCalend := {}
	
	//-- Cria calendario do funcionario para utilizacao nas consistencias
	IF nOpcx == 3 .or. nOpcx == 4 .or. nOpcx = 5 //Inclusao, Alteracao ou Exclusao
		IF !CriaCalend(dPerIni,dPerFim,SRA->RA_TNOTRAB,SRA->RA_SEQTURN,@aTabPadrao,@aTabCalend,SRA->RA_FILIAL,SRA->RA_MAT,SRA->RA_CC)
			Help(" ",1,"TPADNCAD")
			Return ( .F. )
		EndIF
	EndIF	

	//��������������������������������������������������������������Ŀ
	//� Monta a entrada de dados do arquivo                          �
	//����������������������������������������������������������������
	Private aTELA[0][0],aGETS[0],aHeader[0],Continua:=.F.,nUsado:=0
	Private aCOLS := {}
	
	//��������������������������������������������������������������Ŀ
	//� Monta o cabecalho e Detalhe                                  �
	//����������������������������������������������������������������
	dbSelectArea( cAlias )
	//��������������������������������������������������������������Ŀ
	//� Posiciona no Funcionario                                     �
	//����������������������������������������������������������������
	(cAliasApont)->( dbSeek( cFil + cMat , .F. ) )
	//��������������������������������������������������������������Ŀ
	//� Monta Bloco com condicao para desprezar apontamentos fora  do�
	//� periodo														 �
	//����������������������������������������������������������������
	bSkip		:= { || ( &(cPrefix+"DATA") < dPerIni ) .or. ( &(cPrefix+"DATA") > dPerFim ) }
	//��������������������������������������������������������������Ŀ
	//� Monta Query para a Selecao das Informacoes                   �
	//����������������������������������������������������������������

//Anadi

	If !Empty(_CodEvent)	
		For I := 1 To Len(_CodEvent)
			If !Empty(_cQuery)
				If Substr(Alltrim(_cQuery),-2,2) != "or"
					_cQuery := _cQuery + " or "	
				EndIf	
			EndIf
			If Substr(_CodEvent,I,1) != "/"
				_cFiltro += Substr(_CodEvent,I,1)
				If Len(_cFiltro) == 3
					_cQuery 	+= cPrefix + "PD='" + _cFiltro + "' " 
					_cFiltro	:= ""
				EndIf				
			EndIf			
		Next		
		_cQuery := _cQuery + ")"			
	EndIf
			
	#IFDEF TOP
		If !Empty(_CodEvent)
			aQueryCond := Array( 10 )
		Else                         
			aQueryCond := Array( 09 )
		EndIf
		aQueryCond[01] := cPrefix + "FILIAL='"+cFil+"'"
		aQueryCond[02] := " AND "
		aQueryCond[03] := cPrefix + "MAT='"+cMat+"'"
		aQueryCond[04] := " AND "
		aQueryCond[05] := cPrefix + "DATA>='"+Dtos( dPerIni ) +"'"
		aQueryCond[06] := " AND "
		aQueryCond[07] := cPrefix + "DATA<='"+Dtos( dPerFim ) +"'"
		aQueryCond[08] := " AND "
		aQueryCond[09] := "D_E_L_E_T_=' ' "                       		
		If !Empty(_CodEvent)
			aQueryCond[10] := " AND (" + _cQuery
		EndIf			
	#ENDIF
//Fim

	//��������������������������������������������������������������Ŀ
	//� Monta Cabecalho e detalhe                                    �
	//����������������������������������������������������������������
	aCols:=  GdMontaCols(	@aHeader	,; //01 -> Array com os Campos do Cabecalho da GetDados
							@nUsado		,; //02 -> Numero de Campos em Uso
							@aVirtual	,; //03 -> [@]Array com os Campos Virtuais
							@aVisual	,; //04 -> [@]Array com os Campos Visuais
							cAliasApont	,; //05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
							aGdNoFields	,; //06 -> Opcional, Campos que nao Deverao constar no aHeader
							@aRecnos	,; //07 -> [@]Array unidimensional contendo os Recnos
							cAliasApont	,; //08 -> Alias do Arquivo Pai
							(cFil+cMat)	,; //09 -> Chave para o Posicionamento no Alias Filho
							NIL			,; //10 -> Bloco para condicao de Loop While
							bSkip		,; //11 -> Bloco para Skip no Loop While
							NIL			,; //12 -> Se Havera o Elemento de Delecao no aCols  
							NIL			,; //13 -> Se cria variaveis Publicas
							NIL			,; //14 -> Se Sera considerado o Inicializador Padrao
							NIL			,; //15 -> Lado para o inicializador padrao	
							NIL			,; //16 -> Opcional, Carregar Todos os Campos
							NIL			,; //17 -> Opcional, Nao Carregar os Campos Virtuais  
							aQueryCond	,; //18 -> Opcional, Utilizacao de Query para Selecao de Dados
							.F.			,; //19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
							.F.      	,; //20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
							.T.			;  //21 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
						 )								
	nPosDt		:= GdFieldPos(cPrefix+"DATA")
	nPosPd		:= GdFieldPos(cPrefix+"PD")
	nPosTp		:= GdFieldPos(cPrefix+"TPMARCA")
	nPosCC		:= GdFieldPos(cPrefix+"CC")
	nPosDesc    := GdFieldPos(cPrefix+"DESC")

    nLenRecnos	:= Len( aRecnos )

	For nCnt := 1 To nLenRecnos
		aAdd(aColsRec,{})
		aAdd(aColsRec[Len(aColsRec)], aCols[nCnt,nPosDt]) //Data
		aAdd(aColsRec[Len(aColsRec)], aCols[nCnt,nPosPd]) //Evento
		aAdd(aColsRec[Len(aColsRec)], aCols[nCnt,nPosTp]) //Tipo de Marcacao		
		aAdd(aColsRec[Len(aColsRec)], aRecnos[ nCnt ] )
		aAdd(aColsRec[Len(aColsRec)], aCols[nCnt,nPosCC]) //C.Custo
		aCols[ nCnt , nPosDesc ] := DescPdPon( aCols[ nCnt , nPosPd ] )
	Next nCnt               
	
	IF Len( aRecnos ) > 0
		aSort(aCols,,,{ |x,y| DtoS(x[nPosDt])+x[nPosPd]+x[nPosTp] < DtoS(y[nPosDt])+y[nPosPd]+y[nPosTp] })	
		aSort(aColsRec,,,{ |x,y| DtoS(x[1])+x[2]+x[3] < DtoS(y[1])+y[2]+y[3] } )
	EndIF	
    
    If ( ( nCnt :=  nLenRecnos ) > 0 ) .and. nOpcx = 3    //--Quando Inclusao e existir Registro
			Help(" ",1,"a130CAPO")
 			Exit
    Elseif nCnt = 0 .And. nOpcx # 3  //--Quando Nao for Inclusao e nao existir Registro
        Help(" ",1,"a130SAPO")
	     Exit
	Endif

	/*
	��������������������������������������������������������������Ŀ
	� Carrega, apenas, os Campos Editaveis            			   �
	����������������������������������������������������������������*/
	For nCnt := 1 To nUsado
		IF (;
				( aScan( aVirtual 		, aHeader[ nCnt , 02 ] ) == 0 ) .and. ;
		   		( aScan( aVisual  		, aHeader[ nCnt , 02 ] ) == 0 ) .and. ;
		   		( aScan( aGdNaoAltera	, aHeader[ nCnt , 02 ] ) == 0 ) 	     ;
		  	)
			aAdd( aGdAltera , aHeader[ nCnt , 02 ] )
		EndIF			   
	Next nX

	aColsAnt	:= aClone(aCols)
	nOpca		:= 0
	
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg TITLE cCadastro From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL

	@ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO ( aObjSize[1,3] - 3 ),( ( aObjSize[1,4]/100*10 - 2 ) )				LABEL OemToAnsi(STR0020) OF oDlg PIXEL	// "Matricula:"
	oGroup:oFont:= oFont
	@ aObjSize[1,1] , ( ( aObjSize[1,4]/100*10 ) ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),( aObjSize[1,4]/100*80 - 2 )	LABEL OemToAnsi(STR0013) OF oDlg PIXEL	// "Nome:"
	oGroup:oFont:= oFont
	@ aObjSize[1,1] , ( aObjSize[1,4]/100*80 ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),aObjSize[1,4]						LABEL OemToAnsi(STR0092) OF oDlg PIXEL	// "Admiss�o:"
	oGroup:oFont:= oFont
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( aObjSize[1,2] + 5 )				SAY StrZero(Val(SRA->RA_MAT),Len(SRA->RA_MAT))	SIZE 050,10 OF oDlg PIXEL FONT oFont
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( ( aObjSize[1,4]/100*10 ) + 5 )	SAY OemToAnsi(SRA->RA_NOME) 					SIZE 146,10 OF oDlg PIXEL FONT oFont
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( ( aObjSize[1,4]/100*80 ) + 5 )	SAY Dtoc(SRA->RA_ADMISSA)						SIZE 050,10 OF oDlg PIXEL FONT oFont

    oGet := MSGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],nOpcx,"u__aPont130Ok" ,"u__pn130TudOk" ,"",If(nOpcx=2.Or.nOpcx=5,Nil,.T.),aGdAltera,1,,99999,,,,"fDelAponta()")
 
    //-- Posiciona Inicialmente na Coluna do Codigo do Evento Informado ou Abono
    u__Pn130PosCursor(oGet:oBrowse)

    
	ACTIVATE MSDIALOG oDlg ON INIT u__Pn130ChoiBar(oDlg, {||nOpca:=If(nOpcx=5,2,1),If(oGet:TudoOK(),oDlg:End(),nOpca := 0)},{||oDlg:End()},nOpcx) CENTERED
	//Desativa Teclas F4/F5 associada a chamada da Manutencao de Abonos em Pn130ChoiceBar
    GetKeys()
   
   //--Se nao for Exclusao
   If nOpcx # 5
        IF nOpcA == Redigita
            LOOP
        ELSEIF nOpcA == Confirma .And. nOpcx # 2
            Begin Transaction
                //--Gravacao
                u__pn130Grava(cAlias,nOpcx)
                //--Processa Gatilhos
                EvalTrigger()
            End Transaction
        Endif
   //--Se for Exclusao
   Elseif nOpca = 2 .And. nOpcx = 5
        Begin Transaction
            U__pn130Dele()
        End Transaction
   Endif

	Exit
EndDo

//��������������������������������������������������������������Ŀ
//� Libera Locks						                         �
//����������������������������������������������������������������
If lApontamento
   FreeLocks( cAliasApont, Nil, .T. ) 
Endif
If lMarcacao   
	FreeLocks( IF( cAliasApont=='SPC', "SP8" , "SPG" ) ,  Nil, .T. )
Endif	
If lAbono
	FreeLocks( 'SPK' , Nil, .T. ) 
Endif	

//��������������������������������������������������������������Ŀ
//� Restaura a integridade da janela                             �
//����������������������������������������������������������������
cAlias := "SRA"
dbSelectArea(cAlias)
( cAlias )->( dbGoto( nSavRec ) )


RestKeys( aSvKeys , .T. )

Return( .T. )

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �pn130Dele � Autor � Mauro                 � Data � 24.04.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Deleta os Registro dos Apontamentos                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � pn130Dele                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER Function _pn130Dele()
    
Local aDelSPK		:= {}
Local aArea			:= GetArea()
Local aAreaSP8		:= SP8->( GetArea() )
Local aAreaSPK		:= SPK->( GetArea() )
Local cOrdem		:= ""
Local cMsgErr		:= ""
Local nCnt			:= 0
Local lDelInfUsu	:= .F.	

SPK->(dbSetOrder(2))
SP8->(dbSetOrder(1))

If (cAliasApont)->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) ,.F. ) )
	//"Excluir, al�m dos apontamentos calculados pelo sistema, os apontamentos informados pelo usu�rio?"
	lDelInfUsu := MsgNoYes( OemToAnsi( STR0014 ) , cCadastro ) 
	While (cAliasApont)->( !Eof() .and. &(cPrefix+"FILIAL") + &(cPrefix+"MAT") == SRA->( RA_FILIAL + RA_MAT ) )
		IF ( !Empty( (cAliasApont)->( &(cPrefix+"PDI" ) ) ) .and. !( lDelInfUsu ) )
			IF (cAliasApont)->( RecLock( cAliasApont , .F. ) )
				(cAliasApont)->( &(cPrefix+"PD"		) )	:= (cAliasApont)->( &(cPrefix+"PDI" ) )
				(cAliasApont)->( &(cPrefix+"QUANTC"	) )	:= 0
				(cAliasApont)->( &(cPrefix+"FLAG"	) )	:= "I"
				(cAliasApont)->( MsUnlock() )
			EndIF
			(cAliasApont)->( dbSkip() )
			Loop
		EndIF
		If (cAliasApont)->( &(cPrefix+"DATA") >= dPerIni .and. &(cPrefix+"DATA") <= dPerFim )
			//-- Obtem os registros de abono a serem eliminados
			IF SPK->(dbSeek((cAliasApont)->(&(cPrefix+"FILIAL")+&(cPrefix+"MAT")+DTOS(&(cPrefix+"DATA"))+&(cPrefix+"PD"))))
				While SPK->( PK_FILIAL+PK_MAT+Dtos(PK_DATA)+PK_CODEVE) == ((cAliasApont)->(&(cPrefix+"FILIAL")+&(cPrefix+"MAT")+DTOS(&(cPrefix+"DATA"))+&(cPrefix+"PD")))
					//-- Somente Acrescenta no array de delecao se o tipo de marcacao (vazia ou nao) e centro de custo do abono
					//-- forem identicos ao do apontamento. Isto evita que tenhamos registros em duplicidade
					//-- qdo  trabalhamos com marcacao por centro de custo e/ou tipo de marcacao, onde, Filial+
                    //-- Mat + Data + Evento se repentem. 
					If  SPK->( PK_TPMARCA + PK_CC ) == (cAliasApont)->(&(cPrefix+"TPMARCA")+&(cPrefix+"CC"))
					    aAdd(aDelSPK, SPK->(Recno()))
					Endif
					SPK->(dbSkip())
				End While
			EndIF

            IF !lPona190
	            //Retira o Flag de Marcacao Apontada do SP8
	            cOrdem := GetInfoPosTab(CALEND_POS_ORDEM,"1E",(cAliasApont)->(&(cPrefix+"DATA")),aTabCalend)
	            IF !Empty( cOrdem )
	            	IF SP8->( dbSeek( (cAliasApont)->( &(cPrefix+"FILIAL")+&(cPrefix+"MAT") ) + cOrdem ) )
	            		While SP8->( !Eof() .and. P8_FILIAL + P8_MAT + P8_ORDEM == ( (cAliasApont)->( &(cPrefix+"FILIAL")+&(cPrefix+"MAT") ) + cOrdem )  )
	            			IF RecLock("SP8",.F.,.T.)
	            				SP8->P8_APONTA := "N"
	            				SP8->( MsUnLock() )
	            			EndIF
	            			SP8->( dbSkip() )
	            		EndDo
	            	EndIF
	            EndIF
			EndIF

			IF RecLock((cAliasApont),.F.,.T.)
				IF !(cAliasApont)->( FkDelete( @cMsgErr ) )
					(cAliasApont)->( RollBackDelTran( cMsgErr ) )
				EndIF
				(cAliasApont)->( MsUnlock() )
			EndIF	
		
		EndIF
		(cAliasApont)->(dbSkip())
	EndDo
EndIf

//-- Elimina os abonos relacionados
For nCnt := 1 To Len(aDelSPK)
	SPK->(dbGoTo(aDelSPK[nCnt]))
	IF RecLock('SPK',.F.)
		IF !SPK->( FkDelete( @cMsgErr ) )
			SPK->( RollBackDelTran( cMsgErr ) )
		EndIF
		SPK->( MsUnLock() )
	EndIF
Next nCnt

//Restaura os Dados de Entrada
RestArea( aAreaSP8 )
RestArea( aAreaSPK )
RestArea(  aArea   ) 
      
Return( NIL )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���                   ROTINAS DE CRITICA DE CAMPOS                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PN130Grava� Autor � J. Ricardo            � Data � 06.08.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava no arquivo de Dependentes                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � gp020Grava                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER Function _pn130Grava(cAlias,nOpcx,aMainSPC,aColsRecSPC,aHeaderSPK,aMainSPK,aColsSPK,aHeaderSP8,aColsSP8,lArquivo)

Local aArea		  := GetArea()
Local aAreaSPK	  := SPk->( GetArea() )
Local aAreaSP8	  := SP8->( GetArea() )
Local aAreaSPA	  := SPA->( GetArea() )
Local aDelSPK     := {}
Local nPosData    := GDFieldPos(cPrefix+'DATA')
Local nPosAbono   := GDFieldPos(cPrefix+'ABONO')
Local nPosQtAbono := GDFieldPos(cPrefix+'QTABONO')
Local nPosPD      := GDFieldPos(cPrefix+'PD')  
Local nPosQtC     := GDFieldPos(cPrefix+'QUANTC')  
Local nPosQtI     := GDFieldPos(cPrefix+'QUANTI')
Local nPosCC      := GDFieldPos(cPrefix+'CC')  
Local nPosTpMarca := GDFieldPos(cPrefix+'TPMARCA') 
Local nOrdemSPK	  := SPK->(Indexord())
Local ny          := 0
Local nMaxArray   := Len(aHeader)
Local nLenAnt	  := Len( aColsAnt )	
Local aAbonoSPK	  := {}
Local lFound      := .T.
Local lLock		  := .F.
Local nElem		  := 0   
Local cCCAnt      := ''  
Local cOrdem	  := ''
Local cMsgErr	  := ""	
Local bBlocoOrdem := { || NIL }

//-- Para Tratamento em memoria

Local cOrdemAnt     := '!!'
Local cRegra		:= ''
Local lMovel        := .F. 
Local lReaPonta		:= .T.
Local aAbonos		:= {}
Local cFilSPA		:= fFilFunc("SPA")
//-- Variaveis para posiocionamento dos campos no aHeader
Local nAPosData		:= 0
Local nAPosCodA		:= 0
Local nAPosMotA		:= 0
Local nAPosHrIn		:= 0
Local nAPosHrFm		:= 0
Local nAPosHrAb		:= 0
Local nAPosFlag		:= 0
Local nAPosCODEVE	:= 0
Local nAPosTpMarca	:= 0
Local nAPosCC 		:= 0
Local nMPosOrdem	:= 0
Local nMPosAponta	:= 0 
//-- Variaveis para controle de Loop
Local nX			:= 0   
Local n				:= 0
Local nLenX			:= 0           
//-- Variaveis para controle de Processamento
Local lSPKFound		:= .F.                  
//-- Variaveis Auxiliares para montagem de arrays
Local aColsTMP		:= {}
Local aColsAux		:= {}
Local nSPK			:= 0  

DEFAULT lArquivo := .T.

//Monta Bloco para retorno da ordem
bBlocoOrdem := { || cOrdem := GetInfoPosTab(CALEND_POS_ORDEM,"1E",(cAliasApont)->(&(cPrefix+"DATA")),aTabCalend) }
                        
If !lArquivo
	nAPosData		:= GdFieldPos( "PK_DATA"   	,aHeaderSPK)
	nAPosCodA		:= GdFieldPos( "PK_CODABO" 	,aHeaderSPK)
 	nAPosMotA		:= GdFieldPos( "PK_MOTABO" 	,aHeaderSPK) 
 	nAPosHrIn		:= GdFieldPos( "PK_HORINI" 	,aHeaderSPK)
 	nAPosHrFm		:= GdFieldPos( "PK_HORFIM" 	,aHeaderSPK)
 	nAPosHrAb		:= GdFieldPos( "PK_HRSABO" 	,aHeaderSPK)
 	nAPosFlag		:= GdFieldPos( "PK_FLAG" 	,aHeaderSPK)
 	nAPosCODEVE		:= GdFieldPos( "PK_CODEVE" 	,aHeaderSPK)            
 	nAPosTpMarca	:= GdFieldPos( "PK_TPMARCA"	,aHeaderSPK)            
 	nAPosCC 		:= GdFieldPos( "PK_CC"		,aHeaderSPK)       
 	nMPosOrdem		:= GdFieldPos( "P8_ORDEM"	,aHeaderSP8)  
 	nMPosAponta		:= GdFieldPos( "P8_APONTA"	,aHeaderSP8)  
 	aColsRec		:= aColsRecSPC
Endif 

//Seleciona a Area  para cAlias
dbSelectArea(cAlias)

SP8->( dbSetOrder( 01 ) )
SPK->( dbSetOrder( 02 ) )

//����������������������������������������������������������������������������������������������������������������
//                                L E I T U R A   DE   A P O N T A M E N T O S 
//����������������������������������������������������������������������������������������������������������������
For n:=1 TO Len(aCols)

	//����������������������������������������������������������������������������������������������������������������
    // REGRA 01 : Reapontar Marcacoes:
	//����������������������������������������������������������������������������������������������������������������
    /*  Requisitos:
         Arquivo:                    
   	     1) Apontamento Deletado ou Nao
         2) Qualquer Tipo de Horario 
         3) Apontamento Abonado ou que Anteriormente tenha sido Abonado 
         Acao:
             1) Alterar o Flag das Marcacoes para ""    
                                                                 
         Em Memoria:
   	     1) Apontamento Deletado ou Nao
         2) Horario Movel no dia da ordem
         3) Apontamento Abonado ou que Anteriormente tenha sido Abonado 
         4) Pelo Menos 1 Motivo de Abono que abone Horas
         Acao:
             1) Alterar o Flag das Marcacoes para ""    
	*/
	//����������������������������������������������������������������������������������������������������������������                  
   
    //Obtem a Regra de Apontamento da Ordem lida e Verifica o Tipo de Horario

	/*
	�������������������������������������������������������������������������������Ŀ
	�                            "E M   M E M O R I A"                              �
	�Verifica o Tipo de Horario de Acordo com a Regra Vigente em Determinado Dia:   �
	�                                                                               �
	�Horario Movel --> Se Apontamento Abonado, forcamos o reapontamento das         �
	�marcacoes pela alteracao do flag para " ".                                     �
	���������������������������������������������������������������������������������
	*/

	If ( !( lArquivo ) .and. !Empty(cOrdem) .and. ( cOrdem <> cOrdemAnt ) )
	   cOrdemAnt := cOrdem                                                                      	  
	   //-- Obtem a Regra vigente na Ordem corrente e verifica se tem horario movel        	  
	   //-- para posterior alteracao do flag da marcacao afim de forcar o reapontamento    	  
	   cOrdem	:= CalendRetCpo( Substr(cAlias,-2) + "_ORDEM",,,Substr(cAlias,-2) )      	  
       cRegra 	:= CalendRetCpo( "REGRA",,,Substr(cAlias,-2) )         
       SPA->( MsSeek( cFilSPA + cRegra , .F. ) )                                         	  
       lMovel:= .F.                                                                       	  
       If SPA->( PA_HRMOVEL == "S" .and. ( PA_ANTMOVE + PA_POSMOVE ) > 0 )                
          lMovel:=.T.                                                                       
       Endif    
       
       //-- Assumimos o Flag de Reapontamento se Horario Movel
	   lReaponta:= lMovel                                                                            
	   
	Endif                                                                                   

	//-- Apontamentos PRE-EXISTENTES
	If n <= Len(aColsRec)
        If lArquivo
	        dbSelectArea( cAlias )
	        (cAlias)->( dbGoto(aColsRec[n,4]) )
	       	lLock := RecLock(cAlias,.F.,.T.)    
        Else //Em Memoria Trabalha com o Array
            //Posiciona no Apontamento em ArrayMain
            nElem:= aColsRecSPC[n]
        Endif
    
        //--Se DELETADO
        If aCols[n,nUsado+1]
			If lArquivo
				//-- Obtem os registros de abono a serem eliminados
				If SPK->(dbSeek((cAliasApont)->(&(cPrefix+"FILIAL")+&(cPrefix+"MAT")+DTOS(&(cPrefix+"DATA"))+&(cPrefix+"PD"))))
					While SPK->(PK_FILIAL+PK_MAT+Dtos(PK_DATA)+PK_CODEVE) == (cAliasApont)->(&(cPrefix+"FILIAL")+&(cPrefix+"MAT")+DTOS(&(cPrefix+"DATA"))+&(cPrefix+"PD"))
	
						If SPK->(PK_TPMARCA+PK_CC) == (cAliasApont)->(&(cPrefix+"TPMARCA")+&(cPrefix+"CC") )
						   aAdd(aDelSPK, SPK->(Recno()))
						Endif   
						SPK->(dbSkip())
					Enddo
				Endif
            Else //-- Em Memoria Trabalha com Array  
                 //-- Obtem Abonos (baseado no apontamento original) para Serem Deletados e Altera Flag de marcacoes para reapontar qdo horario movel e abono abona horas
                 fGetAbonos(aMainSPK,@aDelSPK, aMainSPC[nElem, nPosData],aMainSPC[nElem, nPosPD],aMainSPC[nElem, nPosTpMarca],aMainSPC[nElem, nPosCC],cOrdem,@aColsSP8,nMPosOrdem,nMPosAponta,lMovel,lReaponta)   
            Endif    
            
			IF !lPona190
	            //Retira o Flag de Marcacao Apontada do SP8
	            If lArquivo
		          u__fApoMarcacao( NIL , NIL , bBlocoOrdem , NIL , NIL , NIL , cAliasApon , cPrefix , lArquivo )
			    Endif    
		    EndIF
		    
            If ( lArquivo ) .and. ( lLock )
				IF !(cAliasApont)->( FkDelete( @cMsgErr ) )
					(cAliasApont)->( RollBackDelTran( cMsgErr ) )
				EndIF
            	(cAliasApont)->( MsUnLock() )
            Endif
            
            Loop
        
        Endif
    
    Else//--Apontamentos NOVOS 
    
       //--Se NAO DELETADO
       If !aCols[n,nUsado+1]
            If lArquivo
	            IF ( lLock := RecLock(cAlias,.T.,.T.) )
	            	(cAliasApont)->(&(cPrefix+"FILIAL") )	:= SRA->RA_FILIAL
	            	(cAliasApont)->(&(cPrefix+"MAT"))		:= SRA->RA_MAT
	            EndIF	
			Else//-- Em Memoria trabalha com Array                       
			    //-- Adiciona Linha em Matriz Auxiliar
			    aAdd(aColsAux,aCols[n])
			Endif
       
       Else // DELETADO
			
			IF !lPona190
	        	 //Retira o Flag de Marcacao Apontada do SP8
	            If lArquivo
		           u__fApoMarcacao( NIL , NIL , bBlocoOrdem , NIL , NIL , NIL , cAliasApon , cPrefix , lArquivo )
				Else //--Em Memoria 
				     //-- Obtem Abonos (baseado no apontamento lido) Altera Flag de marcacoes para reapontar qdo horario movel e abono abona horas
				     //-- NAO DEVERA EXISTIR ABONOS
                     fGetAbonos(aMainSPK,, aCols[n, nPosData],aCols[n, nPosPD],aCols[n, nPosTpMarca],aCols[n, nPosCC],cOrdem,@aColsSP8,nMPosOrdem,nMPosAponta,lMovel,@lReaponta)   
				Endif
			EndIF	
            Loop
       Endif
    Endif                

	//����������������������������������������������������������������������������������������������������������������                  
	//  GRAVACAO DOS DEMAIS CAMPOS 
	//����������������������������������������������������������������������������������������������������������������                  
    //-- Procede Gravacao dos Demais Campos do Apontamento (Novo ou Pre-existente)
    If ( ( lArquivo ) .and. ( lLock ) )
	    For ny := 1 To nMaxArray
	        cCampo    := AllTrim(aHeader[ny][2])
	        //-- Campo quantidade de horas abonadas sera gravada na manutencao de abonos
	        If Ascan(aVirtual,cCampo) == 0 .Or. cCampo # (cPrefix+'QTABONO')
	            xConteudo := aCols[n,ny]
	            &cCampo := xConteudo
	        Endif
	    Next ny
	    (cAlias)->( MsUnlock() )
    Endif
    
    //-- Para Lancamentos Pre-existentes verifica alteracao de conteudo
	IF n <= nLenAnt .and. !fCompArray( aCols[n] , aColsAnt[n] ) //Quando Houver Diferencas
        IF !lPona190
	        //Retira o Flag de Marcacao Apontada do SP8
            If lArquivo
	           u__fApoMarcacao( NIL , NIL , bBlocoOrdem , NIL , NIL , NIL , cAliasApon , cPrefix , lArquivo )
		    Else//-- Em Memoria
		        //-- Obtem TODOS os Abonos para DATA+EVENTO+TPMARC+CC e Altera Flag de marcacoes para reapontar qdo horario movel e abono abona horas
                fGetAbonos(aMainSPK,, aCols[n, nPosData],aCols[n, nPosPD],aCols[n, nPosTpMarca],aCols[n, nPosCC],cOrdem,@aColsSP8,nMPosOrdem,nMPosAponta,lMovel,@lReaponta)   
		    Endif   
    	EndIF
    EndIF
    
    //����������������������������������������������������������������������������������������������������������������                  
	//  TRATA ABONOS
	//����������������������������������������������������������������������������������������������������������������                  
    If lArquivo                    
		SPK->(dbSetOrder(2))
    Endif
    
    //-- Se o Apontamento  possui Abono
	If !Empty(nPosAbono) .and. !Empty(aCols[n,nPosAbono])
		If lArquivo
			//-- Posiciona no SPK para o Evento
			SPK->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+DTOS(aCols[n,nPosData])+aCols[n,nPosPD]))
	    Else//-- Em Memoria posiciona no Evento  
	        //-- Obtem TODOS os Abonos para DATA+EVENTO e Altera Flag de marcacoes para reapontar qdo horario movel e abono abona horas
            aAbonos		:= aClone(fGetAbonos(aMainSPK,, aCols[n, nPosData],aCols[n, nPosPD],,,cOrdem,@aColsSP8,nMPosOrdem,nMPosAponta,lMovel,@lReaponta)   )
    		nLenX 		:= Len( aAbonos ) 								        
	    	lSPKFound	:= !Empty(nLenX)
	    Endif
	    
    	lFound:= .F. //-- Variavel sinalizadora de existencia de abonos para o evento de mesma Marcacao e C.C.
        //-- Se Econtrou Abonos Pre-Existentes verifica Tipo de Marcacao e C.C.
        If lArquivo
	        If SPK->(Found())
		        //-- Restaura o C.C. para o valor original do Apontamento
		    	cCCAnt:= (cAliasApont)->(&(cPrefix+"CC") )
				If n<=nLenAnt
				   	If aCols[n,nPosCC]<>aColsAnt[n,nPosCC] 
				      //-- Se houve, compara pelo valor anterior do C.C. 
					   cCCAnt:=aColsAnt[n,nPosCC] 
					Endif
				Endif  
		    	//-- Corre Todos os Abonos com o mesmo Evento
		    	While SPK->(PK_FILIAL+PK_MAT+Dtos(PK_DATA)+PK_CODEVE) == (cAliasApont)->(&(cPrefix+"FILIAL")+&(cPrefix+"MAT")+DTOS(&(cPrefix+"DATA"))+&(cPrefix+"PD"))
					//-- Verifica se trata da mesma Marcacao e C.C.
					//-- Para Abonos ja Cadastrados
				 
					If SPK->(PK_TPMARCA+PK_CC) == (cAliasApont)->(&(cPrefix+"TPMARCA")+cCCAnt )
					   lFound:=.T.
					   Exit
					Endif   
					SPK->(dbSkip())
				Enddo
	        
	        Endif
        Else 
        	If lSPKFound 
        		//-- Restaura o C.C. para o valor original do Apontamento
        		//-- Registros Ja Existentes vale o anterior se nao vale o do acols
		    	cCCAnt:= If( n <= Len(aColsRec),aMainSPC[nElem,nPosCC],aCols[n,nPosCC])
				If n<=nLenAnt
				   	If aCols[n,nPosCC]<>aColsAnt[n,nPosCC] 
				      //-- Se houve, compara pelo valor anterior do C.C. 
					   cCCAnt:=aColsAnt[n,nPosCC] 
					Endif
				Endif  
		    	//-- Corre Todos os Abonos com o mesmo Evento    
		    	//01-Cod
		    	//02-Qtde Horas
		    	//03-Horas Ini
		        //04-Horas Fim
		    	//05-Data
		    	//06-CC
		    	//07-TpMarca
		    	//08-Recno

				For nX := 1 To nLenX    
			        IF   aAbonos[ nX , 07] # aCols[n, nPosTpMarca]	.or. ;
			             aAbonos[ nX , 06] # cCCAnt
	                     Loop
	                Endif    
	                //-- Encontrou Abono Rapido para o Apontamento lido
	                lFound:=.T.
	                Exit
				Next nX
		    	
        	Endif
        Endif   
        //-- Se Nao Existem Abonos Pre-existentes Trata-se de um abono rapido
        //-- Nesse Caso cria abono em SPk/Array Abon baseado no codigo do Abono Rapido fornecido
	    If !lFound 
		   If lArquivo
			   If RecLock('SPK',.T.)
					SPK->PK_FILIAL  := SRA->RA_FILIAL
					SPK->PK_MAT     := SRA->RA_MAT
					SPK->PK_DATA    := aCols[n,nPosData]
					SPK->PK_CODABO  := aCols[n,nPosAbono]
					SPK->PK_HRSABO  := aCols[n,nPosQtAbono]
					SPK->PK_HORINI  := 0
					SPK->PK_HORFIM  := 0
					SPK->PK_CODEVE  := aCols[n,nPosPD]  
					SPK->PK_CC      := aCols[n,nPosCC]
					SPK->PK_TPMARCA := aCols[n,nPosTpMarca]
					SPK->PK_FLAG    := "I"
					SPK->(MsUnLock())
				Endif
		    Else 
			    //-- Em Memoria Cria Abono 
			    //-- Verifica se Ja existe algum abono no SPK
			    If !Empty(aMainSPK[1,nAPosCodA])        
			       //-- Realiza uma copia do primeiro elemento
			       aColsTmp:=Aclone(aMainSPK[1])         
			       //-- Adiciona esse novo elemento
			       AADD(aMainSPK,aColsTmp)    
			    Endif
			    //-- Altera Dados do Abono Rapido   
				nSPK:=Len(aMainSPK)
				aMainSPK[nSPK,nAPosData]		:=	aCols[n,nPosData]
				aMainSPK[nSPK,nAPosCodA]  		:=	aCols[n,nPosAbono]
				aMainSPK[nSPK,nAPosHrAb] 		:=	aCols[n,nPosQtAbono]
				aMainSPK[nSPK,nAPosHrIn]		:=	0
				aMainSPK[nSPK,nAPosHrFm]		:=	0
				aMainSPK[nSPK,nAPosCODEVE] 		:=	aCols[n,nPosPD]	 
				aMainSPK[nSPK,nAPosCC] 			:=	aCols[n,nPosCC]
				aMainSPK[nSPK,nAPosTpMarca]  	:=	aCols[n,nPosTpMarca]
				aMainSPK[nSPK,nAPosFlag] 		:= "I"   
				aMainSPK[nSPK,nAPosMotA]		:= SPACE(Len(SP6->P6_DESC)) 
				aMainSPK[nSPK,Len(aHeaderSPK) +1 ]   := .F.   
				
				If SP6->(dbSeek(fFilFunc('SP6')+	aCols[n,nPosAbono]))
				   aMainSPK[nSPK,nAPosMotA] := SP6->P6_DESC
				Endif
				
			     //-- Verifica o Tipo de Apontamento no dia Corrente
			    IF lMovel .AND. lReaPonta .AND. SP6->P6_ABHORAS =='S'
	               //-- Procura pelas Marcacoes de Mesma Ordem
		   		   //-- Altera o Flag das Marcacoes de mesma ordem
	       		   lReaponta:=fApoMarcacao( aMainSPK ,nAPosCodA,&('{||"'+cOrdem+'"}'),@aColsSP8,nmPosOrdem,nmPosAponta,,,.F.)   
	       		   
			    Endif
		    Endif		
		Else   
		    //--Se Houve Alteracao no Centro de Custo 
		    //--Armazena todos os Registros de Abonos que deverao sofre alteracao de C.C.
		    //--Somente Valido para para elementos pre-existentes
		    
		    If n<=nLenAnt .AND. aCols[n,nPosCC]<>aColsAnt[n,nPosCC]   
	      	   If lArquivo
		      	   Do While ! SPK->(Eof()) .AND. ;
		 				( (SRA->RA_FILIAL+SRA->RA_MAT+DTOS(aCols[n,nPosData])+aCols[n,nPosPD]) ==;
		   		          (SPK->PK_FILIAL+SPK->PK_MAT+DTOS(SPK->PK_DATA)+SPK->PK_CODEVE)  ;
		   			    )	       
	 					If SPK->(PK_TPMARCA+PK_CC) == (aCols[n,nPosTpMarca]+aColsAnt[n,nPosCC])
	 					    aAdd(aAbonoSPK,{aCols[n,nPosCC],SPK->(Recno())})
	 					Endif    
						
						SPK->(dbSkip())
				   Enddo	
               Else 
                   	//-- Recupera todos os abonos com o C.C. Anterior para posterior alteracao
				   	For nX := 1 To nLenX    
		        		IF  aAbonos[ nX , 07] # aCols[n, nPosTpMarca]	.or. ;
		             		aAbonos[ nX , 06] # aColsAnt[n,nPosCC]
                     		Loop
                		Endif 
				        //-- Encontrou Abono guarda referencia da linha no array Main
				        //-- (8o.Elemento do array aAbonos) e o novo C.C. para posterior
				        //-- autalizacao do C.C. dos Abonos com o C.C. do apontamento 
		                aAdd(aAbonoSPK,{aCols[n,nPosCC],aAbonos[nX,8]})
					Next nX
               Endif
	    	Endif
		Endif
	ElseIF !lArquivo //-- Em Memoria
	    //-- Se o Abono foi Eliminado
	    If !Empty(nPosAbono) .and. Empty(aCols[n,nPosAbono]) .AND. n<=nLenAnt   	
	       //-- Se Existia Abono
	       If !Empty(aColsAnt[n,nPosAbono])
	          //-- Forca Reapontamento
	          //-- Corre Todas as Marcacoes de Mesma ordem e altera Flag para
		 	  //-- que sejam apontadas novamente 
		 	  Aeval(aColsSP8, { |aMarcacoes| If( aMarcacoes[ nMPosOrdem  ] == cOrdem,aMarcacoes[ nMPosAponta]:='N',Nil) })
	       Endif
	   Endif
	Endif   
Next n

If lArquivo 
	SPK->(dbsetorder(nOrdemSPK))
Endif

//-- Elimina os abonos relacionados
nY := 0
For nY := 1 To Len(aDelSPK)
	If lArquivo
		SPK->(dbGoTo(aDelSPK[nY]))
		IF RecLock('SPK',.F.)
			IF !SPK->( FkDelete( @cMsgErr ) )
				SPK->( RollBackDelTran( cMsgErr ) )
			EndIF
			SPK->(MsUnLock())
		EndIF	
	Else
	     aMainSPK[ aDelSPK[nY] , Len(aHeaderSPK) + 1 ]:=.T.
	Endif
Next nY   

//-- Altera C.C.
//-- ATENCAO: A troca de C.C., SOMENTE apos a manutencao, se faz necessaria pois o C.C.
//-- faz parte da chave de pesquisa e pode-se perder a referencia entre o apontamento e
//-- seus abonos. O Recno armazenado eh a maneira de nos referirmos ao registro
//-- que tera o seu C.C alterado. Ex:
//--  Apontamentos  C.C.Ant. C.C. Atual     Abonos .C.C.
//--  409           1000     2000           001    1000
//--  409           1000     2000           001    1000
//--  409           2000     1000           002    2000
//--  409           2000     1000           002    2000
//--  No exemplo, acima, pede-se que sejam invertidos os centros de custos.
//--  Sem o Recno como referencia iriamos, primeiro, conseguir alterar todos os 
//--  abonos do C.C 1000 para 2000. Mas ao procedermos o mesmo com o Abono 002 
//--  encontrariamos 4 C.C. 2000 e nao saberiamos quais os 2 C.C que deveriam ser 
//-- alterados para 1000.  
nY := 0
For nY := 1 To Len(aAbonoSPK)
    If lArquivo
		SPK->(dbGoTo(aAbonoSPK[nY,2]))
		IF RecLock('SPK',.F.)
			SPK->PK_CC:= aAbonoSPK[nY,1]
			SPK->(MsUnLock())
		EndIF	
	Else 
	    aMainSPK[ aAbonoSPK[nY,2] , nAPosCC]:= aAbonoSPK[nY,1]
	Endif
Next nY
	
RestArea( aAreaSPA )
RestArea( aAreaSP8 )
RestArea( aAreaSPK )
RestArea(  aArea   )
 
Return( NIL )                                       
                     
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    �FGetAbonos   � Autor � Mauricio MR           � Data � 15.08.02 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Obtem Abonos e Altera Flag de Marcacoes para Reapontar        ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Pn130/Pn280                                                   ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������*/
USER Function  _fGetAbonos(aSPK,aDelSPK, dData,cPd,cTpMarca,cCC,cOrdem,aColsSP8,nmPosOrdem,nmPosAponta,lMovel,lReaponta)   
Local aAbonos		:= {}
Local bCopbAboCols	:= bAboCols
Local nAbonos		:= 0
Local nLenAbonos	:= 0   
Local nAposCodA		:= 1 // Conforme retorno da fABonos o 1o. Elemento corresponde ao Cod.Abono
Local nX			:= 0
Local lRetAponta	:= .F.
DEFAULT aDelSPK		:= {}

//-- Altera Temporariamente o Bloco de Retorno de Array padrao para consulta de abonos
bAboCols	:= {||aSPK}
nAbonos		:= fAbonos(dData,cPD,,@aAbonos,cTpMarca,cCC)
//-- Restaura Bloco de Retorno de Array
bAbocols	:= bCopbAboCols
nLenAbonos	:= Len(aAbonos)
//-- Carrega os numeros das linhas correspondentes do Array Principal de Abonos 
For nX:=1 to nLenAbonos

    //-- Carrega os numeros das linhas correspondentes aos Abonos no Array Principal
    aAdd( aDelSPK, aAbonos[nX, 8] ) 

    //-- Para Horario Movel Forca Apontamento
    If lMovel  .AND. lReaponta
       //-- Altera o Flag das Marcacoes de mesma ordem 
       //-- Como ja estamos no abono enviamos o mesmo como um elemento de um array unitario
      lRetAponta:=fApoMarcacao( {aAbonos[nX]} ,nAposCodA,&('{||"'+cOrdem+'"}'),@aColsSP8,nmPosOrdem,nmPosAponta,,,.F.)   
	  //-- Altera o Flag para reapontar marcacoes se um dos abonos abonar horas
	  If !lReaponta .AND. lRetAponta
	     lReaponta:=lRetAponta
	  Endif   
	Endif 	

Next nX     

Return aAbonos

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    �fApoMarcacao � Autor � Mauricio MR           � Data � 15.08.02 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Altera o Flag das Marcacoes para Forcar o Reapontamento       ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Pn130/Pn280                                                   ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������*/
USER Function _fApoMarcacao(aAbonos,nAPosCodA,bBlocoOrdem,aColsSP8,nmPosOrdem,nmPosAponta,cAliasApon,cPrefix,lArquivo)   
Local nY		:= 0
Local nX		:= 0
Local nLenX		:= 0
Local lForcou	:= .F.
Local cOrdem	:= Eval(bBlocoOrdem)

DEFAULT lArquivo	:= .T.
DEFAULT aAbonos		:= {}
DEFAULT nAPosCodA	:= 0
DEFAULT aColsSP8	:= {}
DEFAULT nmPosOrdem  := 0
DEFAULT nmPosAponta	:= 0
DEFAULT cAliasApon	:= IF(lPona190,  "SPH" , "SPC" )
DEFAULT cPrefix		:= PrefixoCpo( cAliasApon + "_" )


// *** Em Arquivo
If  lArquivo         
	  //-- Retorno se forca reapontamento
	  lForcou:= .T.
      If !Empty(cOrdem)
	      //-- Corre todas as Marcacoes de mesma Ordem
		  IF SP8->( dbSeek( (cAliasApont)->(&(cPrefix+"FILIAL")+&(cPrefix+"MAT")) + cOrdem ) )
		 	 While SP8->( !Eof() .and. P8_FILIAL + P8_MAT + P8_ORDEM == ( (cAliasApont)->(&(cPrefix+"FILIAL")+&(cPrefix+"MAT")) + cOrdem ) )
				IF RecLock("SP8",.F.,.T.)
					SP8->P8_APONTA := "N"
					SP8->( MsUnLock() )
				EndIF
				SP8->( dbSkip() )
			EndDo
		  EndIF
      Endif
Else// *** Em Memoria
   nLenX:=Len(aAbonos)
   //-- Corre Todos os Abonos 
   For nX:=1 To nLenX        
        //-- Obtem o Codigo do Abono
        cCodAbono:=aAbonos[nX,nAPosCodA]
		//-- Se o Abono Abona Horas
		If SP6->( dbSeek( fFilFunc('SP6') + cCodAbono ) .AND. P6_ABHORAS =='S')
		   //-- Corre Todas as Marcacoes de Mesma Ordem e Altera Flag para Forcar o Reapontamento
		   IF ( nY := aScan( aColsSP8 , { |x| x[ nMPosOrdem  ] == cOrdem } ) ) > 0
				
		      //-- Retorno se forca reapontamento
		 	  lForcou:= .T.
		   
	 		  //-- Corre Todas as Marcacoes de Mesma ordem e altera Flag para
		 	  //-- que sejam apontadas novamente 
		 	  Aeval(aColsSP8, { |aMarcacoes| If( aMarcacoes[ nMPosOrdem  ] == cOrdem,aMarcacoes[ nMPosAponta]:='N',Nil) })
		   Endif
		Endif
   Next 	
Endif

Return lForcou



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �aPont130Ok� Autor � J. Ricardo            � Data � 06.08.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Critica linha digitada                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
USER Function _Apont130Ok(o)

Local nX			:= 0
Local nPosData		:= GDFieldPos(cPrefix+'DATA')
Local nPosPD		:= GDFieldPos(cPrefix+'PD')
Local nPosCC		:= GDFieldPos(cPrefix+'CC')
Local nPosTpMarc	:= GDFieldPos(cPrefix+'TPMARCA')
Local nPosPDI		:= GDFieldPos(cPrefix+'PDI')
Local nPosQuantc	:= GDFieldPos(cPrefix+'QUANTC') 
Local nPosQuantI	:= GDFieldPos(cPrefix+'QUANTI')  
Local nPosQtAbono	:= GDFieldPos(cPrefix+'QTABONO')
Local nPosAbono 	:= GDFieldPos(cPrefix+'ABONO')
Local nRepet		:= 0
Local lRet			:= .T.

//-- Caso n�o seja Deletado
If !aCols[n,nUsado+1]

	Begin Sequence
		
		//-- Impede a existencia de Data/ C�digo / C.C. ou Tp.Marcacao repetidos
		nRepet := 0
		IF nPosData > 0 .and. nPosPD > 0 .and. nPosCC > 0 .and. nPosTpMarc > 0 
			aEval(aCols,{|x| nRepet += If(!x[nUsado+1].and.x[nPosData]==aCols[n,nPosData].and.x[nPosPD]==aCols[n,nPosPD].and.x[nPosCC]==aCols[n,nPosCC].and.x[nPosTpMarc]==aCols[n,nPosTpMarc],1,0)})
			IF nRepet > 1
				Help(' ', 1, 'P040DTCONI')
				lRet := .F.
				Break
			EndIF
		EndIF
		
		//-- Impede Datas em Branco
		If nPosData > 0 
			IF Empty(aCols[n,nPosData])
				Help(" ",1,"P040DTNIL")
				lRet := .F.
		   		Break
		   	EndIF
		   	//-- Verifica se a Data Entra Dentro do Periodo de Apontamento
		   	IF !( lRet := ValidPonData(aCols[n,nPosData],"G",dPerIni,dPerFim,lPona190,.T.) )
		   		Break
		   	EndIF
		EndIf
        
	    //-- Impede Cod.Evento e Informado Simultaneamente em Branco 
	    If nPosPD > 0   .AND. nPosPDI > 0
			If Empty( aCols[n, nPosPD] ) .And. Empty( aCols[n, nPosPDI] )
			   cHelp := STR0030	//"J� Existe Marca��o Cadastrada Para o Dia"
			   Help( ' ' , 1 , 'PN230INCON' , , OemToAnsi( cHelp ) , 5 , 0 )
			   lRet := .F.
			   Break
			Endif   
		EndIf        
		
			//-- Impede a existencia de Quantidades = 0 na linha
		If nPosQuantC > 0 .and. nPosQuantI > 0 .AND. nPosPDI > 0
		   	//-- Nao Permite que as horas Calculadas sejam negativas   
			If aCols[n,nPosQuantC] < 0
			 	Help(' ', 1, 'THORMENOR0')
				lRet := .F.
			    Break
			Endif                                   
			
			//-- Nao Permite que as horas Informadas sejam negativas   			
			If aCols[n,nPosQuantI] < 0
			 	Help(' ', 1, 'THORMENOR0')
				lRet := .F.
			    Break
			Endif  
		    	//-- Nao Permite que as horas sejam vazias simultaneamente
			If Empty(aCols[n,nPosQuantC] + aCols[n,nPosQuantI])
			    //-- Verifica Quantidade Calculada
	            If Empty(aCols[n,nPosQuantC]) .AND. Empty( aCols[n, nPosPDI] )
				   cHelp:=aHeader[nPosQuantC][1]
		    	   Help( ' ' , 1 , 'NVAZIO' , , OemToAnsi( cHelp ) , 5 , 0 )
		    	   lRet:= .F. 
		    	   Break
				Endif   
				
				//-- Verifica Quantidade Informada 
				If Empty(aCols[n,nPosQuantI])
				   cHelp:=aHeader[nPosQuantI][1]
		    	   Help( ' ' , 1 , 'NVAZIO' , , OemToAnsi( cHelp ) , 5 , 0 )
		    	   lRet:= .F. 
		    	   Break
				Endif                             
            Endif
		EndIf	

		If nPosQtAbono > 0 .and. nPosQuantI > 0 .and. nPosQuantC > 0
			
			//-- Impede a digita��o de Minutos Inv�lidos
			If aCols[n, nPosQtAbono ] > 0 .And. (aCols[n, nPosQtAbono ] - Int(aCols[n, nPosQtAbono ])) * 100 >= 60 .Or. ;
				aCols[n, nPosQuantI] > 0 .And. (aCols[n, nPosQuantI] - Int(aCols[n, nPosQuantI])) * 100 >= 60 .Or. ;
				aCols[n, nPosQuantC] > 0 .And. (aCols[n, nPosQuantC] - Int(aCols[n, nPosQuantC])) * 100 >= 60
				Help(' ', 1, 'THORMAIO59')
				lRet := .F.
				Break
			EndIf
			
			//-- Impede que se Abone horas Informadas
			If aCols[n, nPosQtAbono]	> 0 .And. aCols[n, nPosQuantI] > 0
				Help(' ', 1, 'A130INFABO')
				lRet := .F.
				Break
			EndIf
				
			//-- Impede o Abono maior que o Calculado
			If aCols[n, nPosQtAbono] > aCols[n, nPosQuantC]
				Help(' ',1,'A040ABOMAI') //Somente Adverte para permitir a alteracao do abono informado.
				lRet := .F.
				Break
			EndIf
			
		EndIf
		
	End Sequence	
		
EndIf

   

Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �pn130TudOk� Autor � J. Ricardo            � Data � 15.02/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
USER Function _pn130TudOk(o)
Local lRetorna  := .T.

lRetorna := u__Apont130Ok(o)

Continua := .F.
Return lRetorna


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130Valid� Autor � Mauro                 � Data � 06.08.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Critica a data da linha digitada                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
USER Function _Pn130ValDt()

Local lRet 	:= .T.
Local nPos1 := 0
Local dDataAp := Ctod("")

nPos1 := GDFieldPos(cPrefix+"DATA")

//-- Verifica se Existe uma lista como Calendario (Ver. Prog Pona280)
If Type("oLBox") == "O"                                                
   //-- Obtem a Data Corrente do Calendario
   dDataAp:=CalendRetCpo( cPrefix+"DATA"  )
   //-- Nao Permite Apontamentos em Datas Diferentes da do Calendario
   If aCols[n,nPos1] <> dDataAp
      lRet:=.F.
   Endif
Endif

If lRet
	If n <= Len(aColsRec)
		If aCols[n,nPos1] # GetMemVar( cPrefix+"DATA" ) .And. !Empty(aCols[n,nPos1])
		   lRet := .F.
		Endif	
	Else
	    //Nao permite Informar Data Fora do Periodo
		IF nPos1 > 0
			lRet := ValidPonData(GetMemVar( cPrefix+"DATA" ),"G",dPerIni,dPerFim,lPona190,.T.)
		EndIF	
	
	Endif
Endif

Return lRet   


/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130WPdI  � Autor � Mauricio MR           � Data � 09.10.02 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica When do  Codigo Informado                           ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Pona130                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������/*/
USER Function _Pn130WPdI()

Local lRet 	:= .T.
Local nPos1 := 0

//-- Nao Permite acesso ao Codigo Informado se o apontamento esta abonado
If ( nPos1 := GDFieldPos(cPrefix+"ABONO") ) > 0
    If !Empty(aCols[n,nPos1])
	   lRet:=.F.	
   Endif 
Endif    

Return lRet  

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130VPdI  � Autor � Mauricio MR           � Data � 09.10.02 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica Valid do Codigo Informado                           ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������/*/
USER Function _Pn130VPdI()

Local lRet 		:= .T.

Local cVar		:= ReadVar()

Local cAlias	:= IF( lPona190 , "SPH" , "SPC" ) 
Local cPrefix	:= ( PrefixoCpo( cAlias ) + "_" )

//-- Numericos -- Posicionamento dos campos em aHeader
Local nPosHrCalc:= GdFieldPos( cPrefix + "QUANTC"	)
Local nPosHrInf := GdFieldPos( cPrefix + "QUANTI"	)
Local nPosDesc	:= GdFieldPos( cPrefix + "DESC" 	) 
Local nPosPD	:= GdFieldPos( cPrefix + "PD" 		)
Local nPosPDI	:= GdFieldPos( cPrefix + "PDI" 		)
Local nPosFlag	:= GdFieldPos( cPrefix + "FLAG" 	)  

If !VAZIO() 
   If !ExistCpo("SP9")
	  //-- Codigo Informado nao Existe
      lRet:=.F.
   Endif 
Endif     

//-- Se nao houveram inconsistencias 
If lRet  .AND. !Empty(nPosHrCalc) .AND. !Empty(nPosPD)  .AND. !Empty(nPosDesc);
        .AND. !Empty(nPosHrInf)  .AND. !Empty(nPosPDI)  .AND. !Empty(nPosFlag)             

   //-- Verifica a Variavel Ativa no momento da saida da linha
   //-- e atualiza conteudo do aCols correspondente
   If cVar==("M->"+cPrefix+"PDI") .AND. !Empty(nPosPDI)
      aCols[n, nPosPDI]:= GetMemVar( cPrefix+"PDI" )
   Endif

   //-- Verifica se Codigo foi Informado                               
   If ( aCols[n, nPosFlag] == "I" )                                                           
   		If !Empty( aCols[n, nPosPDI]) 
      		aCols[n, nPosPD]    := aCols[n, nPosPDI]           
   	  		aCols[n, nPosDESC]  := DescPdPon( aCols[n, nPosPD] )
   	  	Else                                          
   	  	 	aCols[n, nPosPD]    := aCols[n, nPosPDI]  //-- Codigo informado esta em "branco"
   	  		aCols[n, nPosHrCalc]:= 0 
      		aCols[n, nPosHrInf] := 0	
 	  		aCols[n, nPosDESC]  := DescPdPon( aCols[n, nPosPD] )
   	  	Endif
   Else 
        If !Empty( aCols[n, nPosPDI]) 
	        //-- Alimenta as Horas informadas pelas calculadas sem ainda nao foram fornecidas
	        aCols[n, nPosHrInf]:= If( !Empty(  aCols[n, nPosHrInf] ) 	,  aCols[n, nPosHrInf] ,  aCols[n, nPosHrCalc] )  
        Else 
			//-- Zera as Horas informadas
	        aCols[n, nPosHrInf]:= 0
        Endif
   Endif        
           
Endif

Return lRet           

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130WQtdeI� Autor � Mauricio MR           � Data � 09.10.02 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica When da Quantidade Informada                        ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������/*/
USER Function _Pn130WQtdeI()
Local lRet 	:= .T.
Local nPos1 := 0

//-- Nao Permite acesso a Quantidade Informada sem o Codigo Informado
If ( nPos1 := GDFieldPos(cPrefix+"PDI") ) > 0
    If Empty(aCols[n,nPos1])
	   lRet:=.F.	
    Endif 
Endif

If lRet
	//-- Nao Permite acesso a Quantidade Informada se o apontamento esta abonado
	If ( nPos1 := GDFieldPos(cPrefix+"ABONO") ) > 0
	    If !Empty(aCols[n,nPos1])
		   lRet:=.F.	
	    Endif 
	Endif    
Endif

Return lRet 
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130VQtdeI� Autor � Mauricio MR           � Data � 09.10.02 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica Valid da Quantidade Informada                       ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������/*/
USER Function _Pn130VQtdeI()

Local lRet 	:= .T.
Local cVar		:= ReadVar()
Local cAlias	:= IF( lPona190 , "SPH" , "SPC" ) 
Local cPrefix	:= ( PrefixoCpo( cAlias ) + "_" )

//-- Numericos -- Posicionamento dos campos em aHeader
Local nPosHrCalc:= GdFieldPos( cPrefix + "QUANTC"	)
Local nPosHrInf := GdFieldPos( cPrefix + "QUANTI"	)
Local nPosDesc	:= GdFieldPos( cPrefix + "DESC" 	) 
Local nPosPD	:= GdFieldPos( cPrefix + "PD" 		)
Local nPosPDI	:= GdFieldPos( cPrefix + "PDI" 		)
Local nPosFlag	:= GdFieldPos( cPrefix + "FLAG" 	)


//-- Se nao houveram inconsistencias 
If lRet  .AND. !Empty(nPosHrCalc) .AND. !Empty(nPosPD)  .AND. !Empty(nPosDesc);
        .AND. !Empty(nPosHrInf)  .AND. !Empty(nPosPDI)  .AND. !Empty(nPosFlag)
   
   //-- Verifica a Variavel Ativa no momento da saida da linha
   //-- e atualiza conteudo do aCols correspondente
   If cVar==("M->"+cPrefix+"QUANTI") .AND. !Empty(nPosHrInf)
      aCols[n, nPosHrInf]:= GetMemVar( cPrefix+"QUANTI" )
   Endif 
   
   
   //-- Limpa Cod.Evento, Descricao e Quantidade para Apontamento Informado se o usuario
   //-- nao informar a quantidade
   If  ( aCols[n, nPosFlag] == "I" )  
	   If !Empty(aCols[n, nPosHrInf]) 
	   	  aCols[n, nPosHrCalc]:= aCols[n, nPosHrInf]
	   Else
	   	  aCols[n, nPosHrCalc]:= 0
	   Endif	
   Endif   
Endif

Return lRet           



/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130WAbono� Autor � Mauricio MR           � Data � 05.09.02 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica When do Abono                                       ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������/*/
USER Function _Pn130WAbono()

Local lRet 	:= .T.
Local nPos1 := 0

//-- Verifica o Uso da Funcao pelo Programa Pona280
If Type("LPONA280")<>"U"
   //-- Nao Permite Edicao de Abono para Apontamentos Informados
   If ( nPos1 := GDFieldPos(cPrefix+"FLAG") ) > 0
      If aCols[n,nPos1] == "I"
         lRet:=.F.
      Endif
   Endif 
Endif

//-- Verifica a Digitacao do Codigo Informado
If lRet                                      
   //-- Nao Permite Edicao de Abono para Apontamentos com Codigo Informado
   If ( nPos1 := GDFieldPos(cPrefix+"PDI") ) > 0
      If !Empty(aCols[n,nPos1])
         lRet:=.F.
      Endif
   Endif
Endif
           
If lRet                                      
   //-- Nao Permite Abonar se Nao existir qtde de horas a serem abonadas (Pode ocorrer em acumulados
   //-- ao digitar primeiro o abono e depois a quantidade)
   If ( nPos1 := GDFieldPos(cPrefix+"QUANTC") ) > 0
      If Empty(aCols[n,nPos1])
         lRet:=.F.
      Endif
   Endif
Endif
   
Return lRet   



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130Data � Autor � Mauricio MR           � Data � 29.07.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valor Padrao da data do apontamento                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Pona130/280                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
USER Function _Pn130Data()

Local dRet 	:= Ctod('')

//-- Verifica se Existe uma lista como Calendario (Ver. Prog Pona280)
If Type("oLBox") == "O"                                                
   //-- Obtem a Data Corrente do Calendario
   dRet:=CalendRetCpo( cPrefix+"DATA",,,cPrefix  )
Endif

REturn dRet
           
/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130PosCursor� Autor � Mauricio MR           � Data � 09.10.02 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o �Posiciona o cursor na coluna de codigos informados              ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � Pona130/280                                                    ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������/*/
USER Function _Pn130PosCursor(o)

Local lRet 	  	:= .T.
Local nPosPD 	:= GDFieldPos(cPrefix+"PD")
Local nPosPDI 	:= GDFieldPos(cPrefix+"PDI")
Local nPosABONO	:= GDFieldPos(cPrefix+"ABONO")

If !EMPTY(nPosPD) .AND. !EMPTY(nPosPDI) .AND.!EMPTY(nPosABONO)
    //-- Verifica a Existencia de Abonos
	If  !Empty(aCols[o:nAt,nPosABONO]) 
	    //-- Posiciona no Codigo do Abono
	    o:nColPos:= nPosABONO
	Else
	   //-- Verifica a Existencia de Codigo do Evento
		If  !Empty(aCols[o:nAt,nPosPD])
		    //-- Posiciona no Codigo Informado
	   		o:nColPos:= nPosPDI   
		Endif
	Endif	
Endif


REturn lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130VPd� Autor � Mauro                 � Data � 06.08.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Critica o Codigo da linha digitada                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
USER Function Pn130VPd()

Local lRet := .T.
Local nPos1 := 0
Local nPos2 := 0

nPos1 := GDFieldPos(cPrefix+"PD")
nPos2 := GDFieldPos(cPrefix+"DESC")

If n <= Len(aColsAnt)
	If aCols[n,nPos1] # GetMemVar( cPrefix+"PD" ) .And. !Empty(aCols[n,nPos1])
	   lRet := .F.
	Endif	
Endif

//-- Inclus�o da Descri��o
If lRet
	aCols[n,nPos2]	:= DescPDPon( GetMemVar( cPrefix+"PD" ) )
EndIf
Return lRet


USER Function _Pn130ChoiBar(oDlg,bOk,bCancel,nOpcx,nLinha)
     
Local oBar
Local bSet15
Local bSet24
Local bAbono:={||}
Local oBtRec
Local oBtCop
Local oBtCol
Local oBtCal
Local oBtAge
Local oBtSpo
Local oBtHlp
Local oBtOk
Local oBtCan
Local oBtAb
Local oBtAbVis
Local lOk     	:= .F.
Local lVolta  	:= .F.
Local dData   	:= Ctod('  /  /  ')
Local nHoras  	:= 0
Local nPosPDI 	:= GDFieldPos(cPrefix+"PDI")
Local nPosQuantI:= GDFieldPos(cPrefix+"QUANTI")
Local cEvento 	:= Space(03) 
Local cCusto  	:= (cAliasApont)->(CriaVar((cPrefix+"CC"),.T.))
Local cTpMarca	:= (cAliasApont)->(CriaVar((cPrefix+"TPMARCA"),.T.))	

//-- Somente permite a chamada da tela de abonos se o evento nao foi informado
bAbono:={||	If( Empty(aCols[n,nPosPDI]),;
		                (   bSet15 := oDlg:bSet15	,;
						    bSet24 := oDlg:bSet24	,;
							SetKey(VK_F4,{||Nil}),;
							RetDataHor(@dData, @nHoras, @cEvento, @cCusto, @cTpMarca),;
							fAcessAbono('PONA130',nOpcx,nPosSRA,dData,nHoras,cEvento,aHeader,@aCols,n,cCusto,cTpMarca,cPrefix,cAliasApont),;
							SetKEY(VK_F4,oBtAb:bAction),;
							oDlg:bSet15 := bSet15	,;
							SetKey(15,oDlg:bSet15)	,;
							bSet15 := NIL			,;
							oDlg:bSet24 := bSet24	,;
							SetKey(24,oDlg:bSet24)	,;
							bSet24 := NIL			,; 
							oDlg:Refresh();
						)   ,;
							(If ( Empty( aCols[n,nPosQuantI]) .OR. aCols[n,nPosQuantI]< 0 ,; 
							    (  cHelp := STR0031,;	 //'N�o se pode Abonar Apontamento com Codigo de Evento Informado.'		 
			                       Help( ' ' , 1 , 'PN230INCON' , , OemToAnsi( cHelp ) , 5 , 0 );
			                    ),; 
			                    Help(' ', 1, 'A130INFABO')), Nil);
			  );
		 }				

DEFINE BUTTONBAR oBara130 SIZE 25,25 3D TOP OF oDlg
DEFINE BUTTON oBtRec RESOURCE 'S4WB005N'  OF oBara130       ACTION NaoDisp() 		TOOLTIP STR0021  // 'Recortar'
oBtRec:cTitle:= OemToAnsi(STR0021)	// "Recortar"
DEFINE BUTTON oBtCop RESOURCE 'S4WB006N'  OF oBara130   	ACTION NaoDisp() 		TOOLTIP STR0022  // 'Copiar'
oBtCop:cTitle:= OemToAnsi(STR0022)	// "Copiar"
DEFINE BUTTON oBtCol RESOURCE 'S4WB007N'  OF oBara130       		ACTION NaoDisp()		TOOLTIP STR0023  // 'Colar'
oBtCol:cTitle:= OemToAnsi(STR0023)	// "Colar"
DEFINE BUTTON oBtCal RESOURCE 'S4WB008N'  OF oBara130 GROUP 		ACTION Calculadora()	TOOLTIP STR0024  // 'Calculadora...'
oBtCal:cTitle:= OemToAnsi(STR0124)	// "Calc"
DEFINE BUTTON oBtAge RESOURCE 'S4WB009N'  OF oBara130       		ACTION Agenda()      	TOOLTIP STR0025  // 'Agenda...'
oBtAge:cTitle:= OemToAnsi(STR0125)	// "Agenda"
DEFINE BUTTON oBtSpo RESOURCE 'S4WB010N'  OF oBara130       		ACTION OurSpool()    	TOOLTIP OemToAnsi(STR0026)  // 'Gerenciador de Impress�o...'
oBtSpo:cTitle:= OemToAnsi(STR0126)	// "Gerencia"
DEFINE BUTTON oBtHlp RESOURCE 'S4WB016N'  OF oBara130 GROUP 		ACTION HelProg()     	TOOLTIP STR0027  // 'Help de Programa...'
oBtHlp:cTitle:= OemToAnsi(STR0127)	// "Help"
DEFINE BUTTON oBtAb RESOURCE 'ALT_CAD'   OF oBara130 		ACTION Eval(bAbono)    TOOLTIP OemToAnsi(STR0028)  // 'Abonar/Justificar - <F4>'
oBtAb:cTitle:= OeMToAnsi(STR0128)  // 'Abonar'

If nOpcx == 3 .OR. nOpcx == 4
	SetKey(VK_F4,oBtAb:bAction)
Endif

DEFINE BUTTON oBtAbVis RESOURCE 'pesquisa'   OF oBara130 ACTION (bSet15 := oDlg:bSet15	,;
																bSet24 := oDlg:bSet24	,;
																SetKey(VK_F5,{||NIL}),;
																PONA210(),;
																SetKey(VK_F5,oBtAbVis:bAction),;
																oDlg:bSet15 := bSet15	,;
																SetKey(15,oDlg:bSet15)	,;
																bSet15 := NIL			,;
																oDlg:bSet24 := bSet24	,;
																SetKey(24,oDlg:bSet24)	,;
																bSet24 := NIL			,; 
																oDlg:Refresh()) TOOLTIP OeMToAnsi(STR0029)  //'Consultar os Abonos do Periodo - <F5>'
SetKey(VK_F5,oBtAbVis:bAction)
oBtAbVis:cTitle:= OeMToAnsi(STR0129)  // 'Consultar'
oBara130:nGroups += 5
DEFINE BUTTON oBtOka130 RESOURCE 'OK'   OF oBara130 GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP OeMToAnsi(STR0088)  // 'Ok - <Ctrl-O>'
SetKEY(15,oBtOka130:bAction)
oBtOka130:cTitle:= OeMToAnsi(STR0188)  // 'Ok'

DEFINE BUTTON oBtCana130 RESOURCE 'CANCEL' OF oBara130 ACTION ( lLoop:=.f.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OeMToAnsi(STR0090)  // 'Cancelar - <Ctrl-X>'
SetKEY(24,oBtCana130:bAction)
oBtCana130:cTitle:= OeMToAnsi(STR0190)  // 'Cancelar'

oDlg:bSet15 := oBtOka130:bAction
oDlg:bSet24 := oBtCana130:bAction
oBara130:bRClicked := {|| AllwaysTrue()}

//-- Quando for visulizacao ou exclusao desabilita o botao de abonos.
IF nOpcx == 2 .or. nOpcx == 5
	oBtAb:Disable()
EndIF

Return( NIL )

USER Function _ButtonOff(bSet15,bSet24,lOk)
DEFAULT lOk := .t.
IF lOk
	SetKey(15,bSet15)
	SetKey(24,bSet24)
Endif
Return .T.

USER Function _RetDataHor(dData, nHoras,cEvento,cCusto,cTpMarca)
Local nPos:=0

IF ( nPos := GDFieldPos(cPrefix+'DATA')) > 0
	dData := aCols[n, nPos]
EndIF

IF ( nPos := GDFieldPos(cPrefix+'QUANTC')) > 0
	nHoras:= aCols[n, nPos]
EndIF
                                               
IF (nPos := GDFieldPos(cPrefix+'PD')) > 0
	cEvento := aCols[n, nPos]
EndIF

//-- Obtem o Centro de custo do Apontamento
//-- Se estiver gravado pega do arquivo, senao, vale o que estiver no array
If n <= Len(aColsRec)
   cCusto:=aColsRec[n,5]
Else 
	IF (nPos := GDFieldPos(cPrefix+'CC')) > 0
	   cCusto:= aCols[n, nPos]
	EndIF    
Endif 
       
IF (nPos := GDFieldPos(cPrefix+'TPMARCA')) > 0
	cTpMarca := aCols[n, nPos]
EndIF   
Return( NIL )
   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn130VAb� Autor � Fernando joly Siquini � Data � 22/12/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida o campo "Abono" e altera campos no aCols            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PonA130                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER Function Pn130VAb()

Local lRet  		:= .T.
Local nPosAbono 	:= GDFieldPos(cPrefix+'ABONO')     
Local nPosData		:= GDFieldPos(cPrefix+'DATA')
Local nPosPD    	:= GDFieldPos(cPrefix+'PD')
Local nPosQtI   	:= GdFieldPos(cPrefix+'QUANTI' )   
Local nPosQtAb 		:= GdFieldPos(cPrefix+'QTABONO' )  
Local nPosQuantC	:= GdFieldPos(cPrefix+'QUANTC' ) 
Local nPosTpMarca	:= GdFieldPos(cPrefix+'TPMARCA' ) 
Local nPosCC	    := GdFieldPos(cPrefix+"CC")

Private aAbonos		:=	{} 

//��������������������������������������������������������������Ŀ
//� Verfica se Abono e Valido                                    �
//����������������������������������������������������������������
If !DescAbono( GetMemVar( cPrefix+"ABONO" ) , "L" , cPrefix+"DESCABO" )
   Return .f.
Endif

//��������������������������������������������������������������Ŀ
//� Verfica se Existem Abonos no SPK Para aquele apontamento     �
//����������������������������������������������������������������

fAbonos(aCols[n,nPosData],aCols[n,nPosPD],,@aAbonos,aCols[n,nPosTpMarca],aCols[n,nPosCC])
If !Empty(Len(aAbonos))
   Return .f.
Endif    

If Empty( GetMemVar( cPrefix+"ABONO" ) ) .And. !Empty(aCols[n, nPosAbono])
	Help(' ',1,'EXCLABO')
	lRet := .F.
Else
	lRet := .T.
EndIf

If lRet                
	//-- Calcula Qtde Abonada para Apontamento sem Abonos (somente abono rapido)
	//-- Se a Qtde Horas Abonadas nao existir e nao foi fornecida a qtde Informada
	//-- assume a qtde calculada, senao permanece a qtde abonada 
	aCols[n,nPosQtAB]:=iif(Empty(aCols[n,nPosQtAB]).AND. Empty(aCols[n,nPosQtI]),;
                       aCols[n,nPosQuantC],;
                       aCols[n,nPosQtAB])
Endif
Return lRet
  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Pn310Horas� Autor � Maurico MR            � Data � 27/06/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Devolve Conteudo para cCampo se houve alteracao nos dados  ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PonA310                                                    ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �cRet                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER Function _Pn310Horas(cCampo,aColsAtual,aColsCopia,nElem,cRetorno)

Local cRet := cRetorno         
//Como colocamos alguns Campos Pre-preenchidos, pode ocorrer que a informacao no Array 
//aCols nao esteja gravada fisicamente. Temos que verificar se o campo contem a informacao. 
//Se nao havia registro anteriormente, o campo sera setado para cRetorno informado  
If  Empty(cCampo)
    cRet:=cRetorno
Else    
	//Se nao foram adicionados novos registros compara conteudo atual com anterior 
	If  nElem  <=LEN(aColsCopia)    
	                     
        //fCompArray retorna .T. se nao houve alteracao nas informacoes do registro
        //Para informacao alterada seta flag para retorno informado 
        //Para informacao NAO alterada permanece o conteudo 
        cRet:=If(fCompArray(aColsAtual[nElem],aColsCopia[nElem]),cCampo,cRetorno )
    Else
        //Se foram adicionados outros elementos no array  
        cRet:=cRetorno
    Endif
Endif                           

Return( cRet ) 


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �fAcessAbono � Autor � Mauricio MR           � Data � 25/04/03 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Valida o acesso a dialog de abonos                           ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � PonA130                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/

USER Function _fAcessAbono(fChamadora,nOpcx,nPosSRA,dData,nHoras,cEvento,aHeader,aCols,n,cCusto,cTpMarca,cPrefix,cAliasApont)
Local nPQuantI		:=  GDFieldPos(cPrefix+ 'QUANTI' ) 	
Local lRet			:= .T.	
Local nPosHrAbono 	:= GDFieldPos(cPrefix+'QTABONO')
Local nPosHrCalc 	:= GDFieldPos(cPrefix+'QUANTC')

//-- Caso n�o seja Deletado
If !aCols[n,nUsado+1]
	//-- Se a Linha for Valida
	lRet := u__Apont130Ok()          
	If lRet .OR. (!lRet .AND.  aCols[n, nPosHrAbono] > aCols[n, nPosHrCalc])

	    //-- Se localizado o campo de quatidade informada
	   	If !Empty(nPQuantI)  
			//-- Impede que se Abone horas Informadas
			If aCols[n, nPQuantI] > 0
				Help(' ', 1, 'A130INFABO')
				lRet := .F.
			Else
	 		   PONA210(fChamadora,nOpcx,nPosSRA,dData,nHoras,cEvento,aHeader,@aCols,n,cCusto,cTpMarca,cPrefix,cAliasApont)
	 		   lRet := .F.
	        Endif
	    Endif
	Endif
Else                         
   //-- Nao permite acesso a abono se o evento esta deletado
   Help(' ',1,'P280ACESAB')                                                                                        
   lRet:=.F.
Endif
Return lRet 

/*
������������������������������������������������������������������������Ŀ
�Fun��o    �Pona130Locks    �Autor�Mauricio MR         � Data �14/04/2004�
������������������������������������������������������������������������Ĵ
�Descri��o �Bloqueia Lancamentos de Marcacoes /Apont/Abonos		         �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide parametros formais>									 �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide parametros formais>									 �
������������������������������������������������������������������������Ĵ
�Retorno   �NIL		                                               	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �PONA130                                                      �
��������������������������������������������������������������������������*/
USER Function _Pona130Locks( nOpc , cAlias, aRecnos )

Local lLocks	:= .T.
Local aRecAux	:= {}

Begin Sequence

	/*
	��������������������������������������������������������������Ŀ
	�Se nao For Visualizacao 				 					   �
	����������������������������������������������������������������*/
	IF ( nOpc == 2 ) 
		Break
	EndIF

	aEval(aRecnos, {|x| If( !Empty(x),aADD(aRecAux,x), Nil) } )

	IF !( lLocks := WhileNoLock( cAlias , aRecAux , {xFilial(cAlias)+SRA->RA_MAT} , 1 , 1 , .T. , NIL ) )
		Break
	EndIF

End Sequence

Return( lLocks )  

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    � MenuDef		�Autor�  Luiz Almeida     � Data �22/11/2006�
�����������������������������������������������������������������������Ĵ
�Descri��o �Isola opcoes de menu para que as opcoes da rotina possam    �
�          �ser lidas pelas blibliotecas Framework da Versao 9.12 .     �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �PONA130                                                     �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/

USER Function _MenuDef()

	Local aRotina		:= {}	
	/*
	��������������������������������������������������������������Ŀ
	� Define array contendo as Rotinas a executar do programa      �
	� ----------- Elementos contidos por dimensao ------------     �
	� 1. Nome a aparecer no cabecalho                              �
	� 2. Nome da Rotina associada                                  �
	� 3. Usado pela rotina                                         �
	� 4. Tipo de Transa��o a ser efetuada                          �
	�    1 - Pesquisa e Posiciona em um Banco de Dados             �
	�    2 - Simplesmente Mostra os Campos                         �
	�    3 - Inclui registros no Bancos de Dados                   �
	�    4 - Altera o registro corrente                            �
	�    5 - Remove o registro corrente do Banco de Dados          �
	����������������������������������������������������������������*/
	aRotina	:= {	{ STR0004 , "PesqBrw"		, 0 , 1, ,.F. },;		// "Pesquisar"
	                { STR0005 , "u__pn130Atu"	, 0 , 2 },;				// "Visualizar"
	                { STR0007 , "u__pn130Atu"	, 0 , 3,,,.T. },;		// "Incluir"
					{ STR0009 , "u__pn130Atu" 	, 0 , 4 },;				// "Alterar"
					{ STR0010 , "u__pn130Atu" 	, 0 , 5 },;				// "Excluir"
					{ STR0002 , "gpLegend" 		, 0 , 6 , , .F.};		// "Legenda"
				}
	
Return aRotina