#include "Protheus.ch"

User Function Trees()                                 
Local cBmp1 := "PMSEDT3" //"PMSDOC"  //"FOLDER5" //"PMSMAIS"  //"SHORTCUTPLUS"
Local cBmp2 := "PMSDOC" //"PMSEDT3" //"FOLDER6" //"PMSMENOS" //"SHORTCUTMINUS"
Private cCadastro := "Modelo dbTree"
Private oDlg
Private oTree1

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 122,0 TO 432,600 OF oDlg PIXEL

   //DbTree():New(<nTop>, <nLeft>, <nBottom>, <nRight>, <oWnd>,<{uChange}>, <{uRClick}>, <.lCargo.>, <.lDisable.> )
   oTree1 := dbTree():New(0,0,0,0,oDlg,{|| ProcTrees(oTree1:GetCargo())},,.T.)
   oTree1:Align := CONTROL_ALIGN_ALLCLIENT

		//<oTree>:AddTree( <cLabel>, <.lOpen.>, <cResOpen>, <cResClose>, <cBmpOpen>, <cBmpClose>, <cCargo> )
	oTree1:AddTree("Caneta"+Space(24),.T.,cBmp1,cBmp1,,,"1.0")
		//<oTree>:AddTreeItem( <cLabel>, <cResOpen>, <cBmpOpen>, <cCargo>)
		oTree1:AddTreeItem("Tampa Dianteira",cBmp2,,"1.1")
		oTree1:AddTreeItem("Tampa Traseira"	,cBmp2,,"1.2")
		oTree1:AddTreeItem("Corpo"				,cBmp2,,"1.3")
		oTree1:AddTreeItem("Embalagem"		,cBmp2,,"1.4")

			oTree1:AddTree("Carga",.T.,cBmp1,cBmp1,,,"2.0")
				oTree1:AddTreeItem("Bico"	,cBmp2,,"2.1")
				oTree1:AddTreeItem("Tubo"	,cBmp2,,"2.2")
				oTree1:AddTreeItem("Tinta"	,cBmp2,,"2.3")
			oTree1:EndTree()
	oTree1:EndTree() 	

	oTree1:AddTree("Embalagem",.T.,cBmp1,cBmp1,,,"3.0")
		oTree1:AddTreeItem("Etiqueta"	,cBmp2,,"3.1")
	oTree1:EndTree()

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

Return           


Static Function ProcTrees(cCargo)

	If     cCargo == "1.1" ; MsgInfo("Tampa dianteira",cCadastro)
	Elseif cCargo == "1.2" ; MsgInfo("Tampa traseira",cCadastro)
	Elseif cCargo == "1.3" ; MsgInfo("Corpo",cCadastro)
	Elseif cCargo == "1.4" ; MsgInfo("Embalagem",cCadastro)
	Elseif cCargo == "2.1" ; MsgInfo("Bico",cCadastro)
	Elseif cCargo == "2.2" ; MsgInfo("Tubo",cCadastro)
	Elseif cCargo == "2.3" ; MsgInfo("Tinta",cCadastro)
	Elseif cCargo == "3.1" ; MsgInfo("Etiqueta da embalagem",cCadastro)
	Endif
		
Return