set feedback off
set pagesize 100
compute sum of qtd on node
column username format a20
column resource_name format a50
break on node skip 2
select *
from   gv$resource_limit
where  resource_name in ( 'processes','sessions','transactions' )
order  by inst_id
/
select inst_id node
,      type
,      nvl(username,schemaname) username
,      status
,      count(*) qtd
from   gv$session
group  by  inst_id
,          type
,          nvl(username,schemaname)
,          status
order  by  1,2,5 desc
/
set feedback on
set pagesize 30
