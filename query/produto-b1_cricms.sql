//
//ALTERAÇÃO DE PRODUTOS CAMPO B1_CRICMS = '1'
//

SELECT B1_COD,B1_DESC,D1_TES,F4_CF,F4_TEXTO
    FROM SD1130 SD1, SF1130 SF1, SF4130 SF4, SB1130 SB1      
	        WHERE SD1.D1_FILIAL = '01' AND
		          SD1.D1_DTDIGIT >='20100101' AND
    	  SD1.D1_DTDIGIT <='20151231' AND
SD1.D1_TIPO IN('N','C') AND 
SD1.D1_LOTECTL = ' ' AND
SD1.D1_NUMLOTE = ' ' AND
SD1.D_E_L_E_T_  <> '*' AND
		          SF1.F1_FILIAL  = '01' AND
		          SF1.F1_DOC     = SD1.D1_DOC AND
		          SF1.F1_SERIE   = SD1.D1_SERIE AND
        	      SF1.F1_FORNECE = SD1.D1_FORNECE AND
            	  SF1.F1_LOJA    = SD1.D1_LOJA AND
		          SF1.F1_TIPO    = SD1.D1_TIPO AND
	              SF1.D_E_L_E_T_ <> '*'  AND
			SD1.D1_BRICMS <> 0 AND
SF4.F4_CODIGO = SD1.D1_TES AND
                                                           SF4.F4_ISS <> 'S' AND
                                                           SF4.F4_CF <> '1353' AND
	              SF4.D_E_L_E_T_ <> '*'  AND					  
				  SB1.B1_COD = D1_COD AND
				  SB1.D_E_L_E_T_ <> '*'
		    GROUP BY B1_COD,B1_DESC,D1_TES,F4_CF,F4_TEXTO
