SELECT CN9_NUMERO, CN9_REVISA, CN9_TPCTO, CN9_SITUAC, CNE_CONTRA, CNE_REVISA, 
       F1_FORNECE, F1_LOJA, F1_DOC, F1_SERIE, D1_DOC, D1_SERIE, D1_FORNECE, 
       D1_LOJA, D1_COD, D1_ITEM
 FROM  SF1990 SF1
       INNER JOIN SD1990 SD1
               ON D1_DOC = F1_DOC AND
                  D1_SERIE = F1_SERIE AND
                  D1_FORNECE = F1_FORNECE AND 
                  D1_LOJA = F1_LOJA AND
                  D1_FILIAL =  '01'  AND
                  SD1.D_E_L_E_T_= ' '
       INNER JOIN SC7990 SC7
               ON C7_NUM = D1_PEDIDO AND
                  C7_ITEM = D1_ITEMPC AND
                  C7_FILIAL =  '01'  AND
                  SC7.D_E_L_E_T_= ' '
       INNER JOIN CNE990 CNE
               ON CNE_NUMMED = C7_MEDICAO AND
                  CNE_ITEM = C7_ITEMED AND
                  CNE_FILIAL =  '01'  AND
                  CNE.D_E_L_E_T_= ' '
       INNER JOIN CN9990 CN9
               ON CN9_NUMERO = CNE_CONTRA AND
                  CN9_REVISA = CNE_REVISA AND
                  CN9_FILIAL =  '01'  AND
                  CN9.D_E_L_E_T_= ' '
 WHERE F1_EMISSAO >=  '20000101' AND
       F1_EMISSAO <=  '20081231' AND
       F1_FILIAL =  '01'  AND
       SF1.D_E_L_E_T_= ' '
 ORDER BY CN9_NUMERO, CN9_REVISA,   F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA,   D1_ITEM