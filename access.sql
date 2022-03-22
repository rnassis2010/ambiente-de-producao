set linesize 2000
set pagesize 200
set verify off

column kill     format a40
column osuser   format a10
column username format a10
column machine  format a30

accept vOwner  prompt "Owner  : "
accept vObjeto prompt "Objeto : "

select 'alter system kill session '||chr(39)||s.sid||','||s.serial#||chr(39)||';' kill
,      s.status
,      s.osuser
,      s.username
,      s.logon_time
,      s.machine
,      substr(s.module,1,30)  module
,      substr(s.program,1,30) program
,      s.action
from   gv$session s
,      gv$access  a
where  a.owner  = upper('&vOwner')
and    a.object like upper('&vObjeto')
and    a.inst_id = s.inst_id
and    a.sid     = s.sid
order  by s.logon_time
/

