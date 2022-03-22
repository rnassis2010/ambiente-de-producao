set lines 200
set pagesize 1000
column "sid,serial#" format a11
column program format a20
column process format a10
column module  format a10
column action  format a30
column spid    format a06
column pid     format 9999
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
select s.inst_id
,      s.sid||','||s.serial# "SID,SERIAL#"
,      p.spid
,      p.pid
,      s.process
,      s.program
,      s.module
,      s.action
,      s.status
,      s.logon_time
,      s.last_call_et
,      s.paddr
--,      s.sql_hash_value
--       distinct 'alter system kill session '||''''||s.sid||','||s.serial#||''''||' immediate ;'
from   gv$session s
,      gv$process p
where  s.program   like '%JDBC%'
and    s.module       = 'MWAJDBC'
--and    s.status       = 'INACTIVE'
--and    s.last_call_et > 1800
--and    s.sql_address  = '00'
and    s.paddr        = p.addr
and    s.inst_id      = p.inst_id
and    s.action like '%ITA%'
order  by s.logon_time
/

