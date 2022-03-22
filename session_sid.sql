set pages 1000
set linesize 1000
col "SID,SERIAL#" format a11
col spid          format a7
col event         format a50
col module        format a50
col username      format a12
col osuser        format a10
col swait         format 999999
col status        format a8
col ssid          format a5
col pid           format 999999

select s.inst_id
,      s.sid||','||s.serial# "SID,SERIAL#"
,      s.status
,      p.spid
,      p.pid
,      sw.event
,      s.module
,      s.username
,      s.osuser
,      sw.seconds_in_wait as swait
,      to_char(s.logon_time,'DD/MM HH24:MI') as Logon
,      s.action
,      s.paddr
,      s.taddr
,      s.sql_address
,      s.sql_hash_value
--,      p.pga_alloc_mem
from   gv$session s
,      gv$process p
,      gv$session_wait sw
where  s.username IS NOT NULL
and    s.audsid <> USERENV('SESSIONID')
-- and    s.status = 'ACTIVE'
and    p.addr   = s.paddr
and    sw.sid   = s.sid
and    s.sid = &sid
order  by s.logon_time
/

