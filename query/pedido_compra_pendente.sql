
-- Query para selecionar pedidos com bloqueio
SELECT SC7.*  --*
  FROM SC6010 SC6
 INNER JOIN SC5010 SC5 ON SC5.D_E_L_E_T_ <> '*'
                       AND SC5.C5_FILIAL = SC6.C6_FILIAL 
                       AND SC5.C5_NUM = SC6.C6_NUM
  LEFT JOIN SC9010 SC9 ON SC9.D_E_L_E_T_ <> '*' 
                       AND SC9.C9_FILIAL = SC6.C6_FILIAL 
                       AND SC9.C9_PEDIDO = SC6.C6_NUM 
                       AND SC9.C9_ITEM = SC6.C6_ITEM
 WHERE SC6.D_E_L_E_T_ = ' '
       AND SC9.C9_BLEST <> '10'
       AND SC9.C9_BLCRED <> '10'


-- Query para selecionar aguardando aprovacao
select SC7.C7_FILIAL, SC7.C7_NUM,SCR.CR_FILIAL, SCR.CR_USER, SCR.CR_STATUS
  FROM SC7010 SC7
  RIGHT JOIN SCR010 SCR ON SCR.D_E_L_E_T_ <> '*' 
                       AND SC7.C7_FILIAL = SCR.CR_FILIAL 
                       AND SC7.C7_NUM = SCR.CR_NUM 
                       AND SCR.CR_STATUS IN ('01','02' )
                       AND SCR.CR_USER = '000419'
  WHERE SC7.D_E_L_E_T_ <> '*'
        AND C7_CONAPRO = 'B'
 ORDER BY SC7.C7_FILIAL, SC7.C7_NUM


