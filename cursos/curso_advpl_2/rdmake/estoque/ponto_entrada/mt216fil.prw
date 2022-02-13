User Function MT216FIL

u_GerA0003(ProcName())

/* filtro no recalculo do saldo de terceiros para nao considerar 
processos anteriores ao ano de 2007 */
aFiltro := {}      
aadd(aFiltro,"B2_LOCAL NOT IN ('02','06','60','11','12','13','04','32','09')")
aadd(aFiltro," B6_EMISSAO > '20071231' AND B6_LOCAL NOT IN ('02','06','60','11','12','13','04','32','09')" )
aadd(aFiltro," D1_EMISSAO > '20071231' AND D1_LOCAL NOT IN ('02','06','60','11','12','13','04','32','09')" )
aadd(aFiltro," D2_EMISSAO > '20071231' AND D2_LOCAL NOT IN ('02','06','60','11','12','13','04','32','09')" )
aadd(aFiltro," C6_ENTREG  > '20071231' AND C6_LOCAL NOT IN ('02','06','60','11','12','13','04','32','09')" )

Return (aFiltro)