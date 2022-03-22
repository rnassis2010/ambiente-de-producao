set lines 200
set num 10
col MODULE format a20
col OSUSER format a10
col USERNAME format a10
col MACHINE format a30
col SCHEMANAME format a10
col ACTION format a30
select s.INST_ID,s.sid,s.serial#,p.spid os_pid,s.status,s.osuser,s.username,s.MACHINE,s.MODULE,s.SCHEMANAME,s.action 
from gv$session s, gv$process p 
WHERE s.paddr = p.addr 
and s.sid = '&sid'
and s.serial# = '&serial';
