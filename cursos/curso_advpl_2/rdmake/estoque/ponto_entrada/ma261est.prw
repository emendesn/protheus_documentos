#include 'protheus.ch'

/*/
+---------------------------------------------------------------------------+
| Programa  | MA261EST   | Autor | Luciano Siqueira       | Data | 25/02/13 |
+-----------+---------------------------------------------------------------+
| Descrição | Ponto de Entrada no Estorno de Transferência Modelo 2 que     |
|           | valida se pode estornar verificando se ja efetuou a transf.   |
|           | para producao do Documento                                    |
+---------------------------------------------------------------------------+
| Uso       | BGH                                                           |
+---------------------------------------------------------------------------+
/*/

User Function MA261EST()

Local _lRet := .T.
Local aArea := GetArea()
Local _nLin := ParamIXB[1]

dbSelectArea("SD3")
SD3->(DBOrderNickName('XDOCORI'))
If dbSeek(xFilial("SD3")+cDocumento)
	While SD3->(!EOF()) .and. SD3->(D3_FILIAL+D3_XDOCORI)==xFilial("SD3")+cDocumento
		If SD3->D3_ESTORNO <> "S"
			_lRet:= .F.
			MsgAlert("Não é possivel estornar pois o mesmo ja foi transferido para produção!")
			Exit
		Endif
		dbSelectArea("SD3")
		dbSkip()
	EndDo
Endif

RestArea(aArea)

Return(_lRet)           
