clear breaks
set verify off
--set feedback off
set pages 200
set lines 1000
set wrap off
col no            format 9
col "SID,SERIAL#" format a11
col event         format a30
col object_name   format a25
col module        format a35 trunc
col program       format a30
col action        format a20
col username      format a17
col osuser        format a10
col machine       format a15
col swait         format 99999999
col logon         format a11
col status        format a8
col ssid          format a5
col spid          format a6
col kill_unix     format a40
col kill_db       format a40
col client_info   format a30
col last_call     format a9
col sql_id        format a15

accept vStatus   prompt "Status <A>ctive, <I>nactive, Al<l> - [A] : "
accept vUsername prompt "USERNAME : "
accept vOSUser   prompt "OS User  : "
accept vModule   prompt "MODULE   : "
accept vMachine  prompt "MACHINE  : "
accept vSid      prompt "SID      : "
accept vSpid     prompt "SPID     : "
accept vNode     prompt "Instance : "

select 
--       'kill -9 '||p.spid                                                         kill_unix,
--       'alter system kill session '||chr(39)||s.sid||','||s.serial#||chr(39)||';' kill_db  ,
       s.inst_id             no
,      s.sid||','||s.serial# "SID,SERIAL#"
--,      s.audsid
,      s.status
--,      p.pid
,      p.spid
--,      s.process
,      s.module
,      s.program
--,      s.action
,      sw.event
--,s.sql_id
--,      sw.seconds_in_wait as swait
--,      s.service_name
,      s.username
,      s.machine
,      s.osuser
,      to_char(s.logon_time,'DD/MM HH24:MI') as Logon
,      decode(s.last_call_et,0,null,
                               to_char(extract(hour   from numtodsinterval(s.last_call_et,'SECOND')),'FM09')||':'||
                               to_char(extract(minute from numtodsinterval(s.last_call_et,'SECOND')),'FM09')||':'||
                               to_char(extract(second from numtodsinterval(s.last_call_et,'SECOND')),'FM09')) last_call
--,      s.creator_addr
--,      s.client_info
--,      o.object_name
--,      s.action
--,      s.paddr
--,      s.taddr
--,      s.sql_address
--,      s.sql_hash_value
--,      p.pga_alloc_mem
--,      s.row_wait_obj#
--, s.p1
--, s.p2
--, s.p3
from   gv$session s
,      gv$process p
,      gv$session_wait sw
,      dba_objects o
where  s.username IS NOT NULL
and    s.audsid <> USERENV('SESSIONID')
and    s.type   <> 'BACKGROUND'
and    ( s.inst_id  = '&vNode' or '&vNode' is null )
and    ( s.status   = decode(upper(nvl('&vStatus','A')),'A','ACTIVE','I','INACTIVE','L',s.status) )
and    ( s.username like upper('&vUsername') or '&vUsername' is null )
and    ( s.osuser   like '&vOSUser'   or '&vOSUser'   is null )
and    ( s.module   like '&vModule'   or '&vModule'   is null )
and    ( s.machine  like '&vMachine'  or '&vMachine'  is null )
and    ( s.sid      like '&vSid'      or '&vSid'      is null )
and    ( p.spid     like '&vSpid'     or '&vSpid'     is null )
and    p.inst_id  = s.inst_id
and    p.addr     = s.paddr
and    sw.inst_id = s.inst_id
and    sw.sid     = s.sid
and    s.row_wait_obj# = o.object_id(+)
order  by s.logon_time
/

