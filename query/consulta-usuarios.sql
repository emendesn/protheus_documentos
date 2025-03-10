-- Consulta os usuarios no Sistema

select * from sys_usr su 
inner join sys_usr_module mo on mo.usr_id = su.usr_id and mo.d_e_l_e_t_ = ''
where su.d_e_l_e_t_ =''
and su.usr_msblql = '2'
and usr_modulo = '6'
and usr_acesso = 'T'
