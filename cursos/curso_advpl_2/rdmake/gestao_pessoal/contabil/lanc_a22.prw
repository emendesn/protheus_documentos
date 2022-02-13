#include "rwmake.ch"      

User Function Lanc_a22()   
// DIF SALARIO FAMILIA 

SetPrvt("_CCONTA,")

_cConta := Space(15)

u_GerA0003(ProcName())



   If     ALLTRIM(SRZ->RZ_CC) $ "1001/1002/1004/1040/1041/1042/1043/1044" // SERVICE
		//_cConta := "3230103006" alterado conforme Katia Ramos - 28/06/10 - Edson Rodrigues
		 _cConta :="3230103016"
   ElseIf ALLTRIM(SRZ->RZ_CC) $ "1011/1012/1013/1014"   // SONY ERICSON
		//_cConta := "3230104006" alterado conforme Katia Ramos - 28/06/10 - Edson Rodrigues
		 _cConta :="3230104016"                        
   ElseIf ALLTRIM(SRZ->RZ_CC) $ "1021/1022/1023/1024/1051/1052/1053/1054"   // NEXTEL
		//_cConta := "3230105006" alterado conforme Katia Ramos - 28/06/10 - Edson Rodrigues                      	   
		 _cConta :="3230105016" 
   ElseIf ALLTRIM(SRZ->RZ_CC) $ "2011/2012/2013/2014/2015/20101/20102/20103/20106/20107/2004/2001/2002"     // DISTRIB. CEL.
		//_cConta := "3240103006" alterado conforme Katia Ramos - 28/06/10 - Edson Rodrigues                      	   
		 _cConta :="3240103016" 
   ElseIf ALLTRIM(SRZ->RZ_CC) $ "2020/2021/2022/2023/2024/2030/2031/2032/2033/2034/1030/1031/1032/1033/1034" // DISTRIB. RADIO
		// _cConta := "3240104006" alterado conforme Katia Ramos - 28/06/10 - Edson Rodrigues                      	   
		 _cConta :="3240104016" 
   ElseIf ALLTRIM(SRZ->RZ_CC) $ "1060/1061/1062/1063/1064"  // SONY INDL
		_cConta := "3230108016"
   ElseIf ALLTRIM(SRZ->RZ_CC) $ "1070/1071/1072/1073/1074"  // POSITIVO
		_cConta := "3230109016"
   ElseIf ALLTRIM(SRZ->RZ_CC) $ "1080/1081/1082/1083/1084"  // ITAUTEC
		_cConta := "3230110016"
   ElseIf ALLTRIM(SRZ->RZ_CC) $ "3010/3021/3022/3023/3024/3031/3041/3043/3051"  // ADMIN.
		// _cConta := "3310104006" alterado conforme Katia Ramos - 28/06/10 - Edson Rodrigues                      	   
		 _cConta := "3310104016" 
   EndIf
Return(_cConta)       
