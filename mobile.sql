set line 250
set verify off
col machine format a30
col osuser format a10
col action format a28
col username format a5
prompt 'Type % for all users.'
accept vaction prompt 'USER: '
select to_char(a.logon_time, 'dd/mm/yyyy hh:mi:ss') as logon, round(a.last_call_et/60) as minutes,
a.inst_id, a.sid, a.serial#, a.machine,a.status, a.action, 
a.sql_id, a.sql_hash_value, a.prev_sql_id, a.prev_hash_value
from gv$session a, gv$process b
where a.paddr = b.addr
and type = 'USER'
and module like '%MWAJDBC%'
and action like upper('%&vaction%')
order by logon_time;
