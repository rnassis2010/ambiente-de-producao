column instance format a30
select 'Instance '||( select instance_name from gv$instance where inst_id = x.inst_id )||' - '||to_char(x.qtd) INSTANCE
from
(
select inst_id,count(*) qtd
from   gv$session
where  status = 'ACTIVE'
group  by inst_id
order  by 1
) x
/
