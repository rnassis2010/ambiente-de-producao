set verify off
set linesize 500

prompt Locker User  -  Objeto lockado
col BLOCKED_OBJ format a35 trunc

select /*+ ORDERED */
    l.sid 
,   l.lmode
,   TRUNC(l.ctime/60) min_blocked
,   u.name||'.'||o.NAME blocked_obj 
from (select *
      from gv$lock
      where type='TM'
      and block!=0) l
,     sys.obj$ o
,     sys.user$ u  
where o.obj# = l.ID1
and   o.OWNER# = u.user#
/


prompt Sessões Bloqueadas
break on blocker_sid skip 1
select /*+ ORDERED */
   blocker.sid blocker_sid
,  blocked.sid blocked_sid
,  TRUNC(blocked.ctime/60) min_blocked
,  blocked.request
from (select *
      from gv$lock
      where block != 0
      and type = 'TX') blocker
,    gv$lock        blocked
,    gv$session     sblocker
,    gv$session     sblocked
where blocked.type='TX' 
and blocked.block = 0
and blocked.id1 = blocker.id1
and blocker.sid = sblocker.sid
and blocked.sid = sblocked.sid
/

prompt  Sessões Criminosas.
col username format a10 trunc
col osuser format a12 trunc
col machine format a15 trunc
col process format a15 trunc
col action format a50 trunc
col "sid,serial#" format a10

SELECT to_char(sid)||','||to_char(serial#) "SID,SERIAL#"
,      status
,      username
,      osuser
,      logon_time
,      machine
,      process
,      module||' '||action action
FROM gv$session
WHERE sid IN (select sid
      from gv$lock
      where block != 0
      and type = 'TX')
/


