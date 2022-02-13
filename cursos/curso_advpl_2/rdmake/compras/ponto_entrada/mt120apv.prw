#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120APV ºAutor  ³ Hudson de Souza Santos    ³  29/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para alterar o Grupo de Aprovacao.        º±±
±±º          ³ Obs.: Na alteracao do pedido, pode ser usado para alterar  º±±
±±º          ³ o saldo do mesmo (var. n120TotLib)                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120APV()
Local __cGrp
Local oCombo
Local oTOk
Local oGrid
Local oData
Local cList		:= ""
Local aItems	:= {}
Local ___cQry	:= ""
Private aDados	:= {}
Private oList
Private cCombo	:= ""
// Grupo pelo solicitante caso não estejam bloqueados. Traz o grpo de aprovação do último item do pedido.
// Caso o solicitante tenha mais de um grupo de alçada, não será definido automaticamente. Será necessário informar na tela.
If Select("TRBAPROV") > 0
	TRBAPROV->(dbCloseArea())
EndIf
___cQry := "SELECT TOP 1 SAI.AI_APROV FROM "+RetSqlName("SC7")+" as SC7(NOLOCK)"
___cQry += " inner join "+RetSqlName("SC1")+" as SC1(NOLOCK) ON SC1.D_E_L_E_T_ = ''"
___cQry += " 	AND SC1.C1_NUM = SC7.C7_NUMSC"
___cQry += " 	AND SC1.C1_ITEM = SC7.C7_ITEMSC"
___cQry += " inner join ("
___cQry += " 			SELECT AI_USER, max(AI_APROV) as AI_APROV"
___cQry += " 			FROM "+RetSqlName("SAI")+"(NOLOCK)"
___cQry += " 			WHERE D_E_L_E_T_ = ''"
___cQry += " 			GROUP BY AI_FILIAL , AI_USER"
___cQry += " 			HAVING min(AI_APROV) = max(AI_APROV)"
___cQry += " ) as SAI ON SAI.AI_USER = SC1.C1_USER"
___cQry += " inner join ("
___cQry += " 			SELECT AL_COD, max(AL_MSBLQL) as AL_MSBLQL"
___cQry += " 			FROM "+RetSqlName("SAL")+"(NOLOCK)"
___cQry += " 			WHERE D_E_L_E_T_ = ''"
___cQry += " 			GROUP BY AL_FILIAL , AL_COD"
___cQry += " ) as SAL ON SAL.AL_MSBLQL <> '1' AND SAL.AL_COD = SAI.AI_APROV"
___cQry += " WHERE SC7.D_E_L_E_T_ = ''"
___cQry += " 	AND C7_FILIAL = '"+xFilial("SC7")+"'"
___cQry += " 	AND C7_NUM = '"+SC7->C7_NUM+"'"
___cQry += " ORDER BY SC7.C7_ITEM DESC""
TcQuery ___cQry NEW ALIAS "TRBAPROV"
// A query acima retornando registro, o sistema assume esse grupo para a alçada.
If !Empty(TRBAPROV->AI_APROV)
	__cGrp := TRBAPROV->AI_APROV
EndIf 
TRBAPROV->(dbCloseArea())
// Se a query acima não retornar valor ou retornar nulo, o sistema irá pegar o grupo definido no comprador.
/*
Retirado a definição do grupo pelo cadastro de comprador(SY1) pois o EIC precisa desse campo preenchido. Por isso ignoramos a regra para pedidos nacionais
Caso precise utilizar o campo, deve-se contemplar o EIC.
__cGrp := Iif(Empty(__cGrp),ValGrpCom(SY1->Y1_GRAPROV),__cGrp)
*/
// Não existindo grupo de aprovação nas duas primeiras regras, o sistema apresenta uma tela para definir qual alçada seguir.
If Empty(__cGrp)
	__cGrp := ""
	aItems := GetGrp()
	Define Msdialog oDlgGrupo Title "Defina o grupo" From 000, 000  To 280, 500 Pixel
	 oCombo	:= TComboBox():New(5,45,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItems,200,20,oDlgGrupo, ,{||oList:SetItems(AtuDados(cCombo))},;
	 			,  ,  ,.T.,  ,  ,  ,  ,  ,  ,  ,  , 'cCombo','Grupo:',1)
	 oList	:= TListBox():New(20,15,{|u|if(Pcount()>0,cList:=u,cList)},aDados,225,100,,oDlgGrupo,,,,.T.)
	 oTOk	:= TButton():New(125,200,"Ok",oDlgGrupo,{||Iif(Empty(cCombo),Alert("É OBRIGATÓRIO definir um grupo para alçada!!!");
	 			,oDlgGrupo:End())}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	Activate MsDialog oDlgGrupo Centered
	__cGrp := subSTR(cCombo,1,6)
EndIf
Return(__cGrp)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GetGrp   ºAutor  ³ Hudson de Souza Santos    ³  29/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetGrp()
Local aRet := {}
Local aArea1 := GetArea()
Local cCodGrp := ""
dbSelectArea("SAL")
SAL->(dbSetOrder(1))
SAL->(dbGoTop())
aAdd(aRet,"")
While !SAL->(Eof())
	If cCodGrp <> SAL->AL_COD .AND. SAL->AL_MSBLQL <> "1"
		cCodGrp := SAL->AL_COD
		aAdd(aRet,Alltrim(SAL->AL_COD)+" - "+Alltrim(SAL->AL_DESC))
	EndIf
	SAL->(dbSkip())
EndDo
RestArea(aArea1)
Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuDados ºAutor  ³ Hudson de Souza Santos    ³  29/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuDados(cCod)
Local aRet := {}
Local aArea2 := GetArea()
Local cCodSAL := SubSTR(cCod,1,6)
dbSelectArea("SAL")
SAL->(dbSetOrder(2))
SAL->(dbGoTop())
SAL->(dbSeek(xFilial("SAL")+cCodSAL))
While !SAL->(Eof()) .AND. SAL->AL_COD == cCodSAL
	If SAL->AL_MSBLQL <> "1" 
		aAdd(aRet,SAL->AL_NOME)
	End
	SAL->(dbSkip())
EndDo
RestArea(aArea2)
Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValGrpComºAutor  ³ Hudson de Souza Santos    ³  20/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValGrpCom(cGrp)
Local cRet := ""
Local cQry := ""
If !Empty(cGrp)
	If Select("TRBVAL") > 0
		TRBVAL->(dbCloseArea())
	EndIf
	cQry := "SELECT"
	cQry += " isnull(AL_COD,'') as CODIGO"
	cQry += " FROM "+RetSqlName("SAL")
	cQry += " WHERE D_E_L_E_T_ = ''"
	cQry += " AND AL_FILIAL = '"+xFilial("SAL")+"'"
	cQry += " AND AL_COD = '"+cGrp+"'"
	cQry += " AND AL_MSBLQL <> '1'"
	cQry += " GROUP BY AL_FILIAL, AL_COD"
	cQry += " ORDER BY AL_FILIAL, AL_COD"
	TcQuery cQry NEW ALIAS "TRBVAL"
	If Select("TRBVAL") > 0
		cRet := TRBVAL->CODIGO
	EndIf 
	TRBVAL->(dbCloseArea())
	If Empty(cRet)
		cQry := "UPDATE "+RetSqlName("SY1")+" SET Y1_GRAPROV = '' WHERE D_E_L_E_T_ = '' AND Y1_FILIAL = '"+xFilial("SY1")+"' AND Y1_GRAPROV = '"+cGrp+"'"
		TcSqlExec(cQry)
		TCRefresh(RetSqlName("SY1"))
		Alert("O sistema apagou o grupo default configurador no comprador " + Alltrim(SY1->Y1_NOME) + " por ser inválido ou inexistente!!!")
	EndIf
EndIf
Return(cRet)