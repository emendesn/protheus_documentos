#Include "rwmake.ch"
#Include "bitmap.Ch"

User function SIGACFG()
u_GerA0003(ProcName())

//CriaBmp()
Return


User function SIGALOJA()
//CriaBmp()
Return

User function SIGATEC()
//CriaBmp()
Return

User function SIGAFIN()
//CriaBmp()
Return

User function SIGAEST()
//CriaBmp()
Return

//User function SIGAFAT()
//CriaBmp()
//Return

User function SIGACTB()
//CriaBmp()
Return


User function SIGALOJ()
//CriaBmp()
Return

//------------------------------------------------------------------------------------
// Função para criar um bitmap na janela principal
//------------------------------------------------------------------------------------
Static function CriaBmp()

Local nEsquerda := nTopo := nAltura := nLargura := 0, oBmp

oMainWnd:ReadClientCoors()	// Atualiza as coordenadas da janela principal

	cBitMap  := 'bgh.bmp'
	
	nAltura  := 260
	nLargura := 766

nTopo     :=40+(oMainWnd:nHeight/4)-(nAltura/2) // Meio da tela
nEsquerda :=(oMainWnd:nWidth/4) 			  // Left Máximo devido ao menu ocupar o resto da área

@ nTopo,nEsquerda BITMAP SIZE nLargura,nAltura FILE cBitMap Pixel NOBORDER


Return