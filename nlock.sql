set pagesize 1000
set linesize 300
set trimspool on

set feedback off
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
set feedback on

column no            format a2
column "SID,SERIAL#" format a14
column spid          format a6
column username      format a10 truncate
column osuser        format a8  truncate
column module        format a35 truncate
column event         format a30 truncate
column waiting       format a11
column object_name   format a30

with locked_session as
     (
          --
          -- Locked sessions
          --
          select s.blocking_instance
          ,      s.blocking_session
          ,      s.inst_id
          ,      s.sid
          ,      s.serial#
          ,      s.paddr
          ,      s.status
          ,      s.username
          ,      s.osuser
          ,      nvl(nvl(s.module,s.program),s.action) module
          ,      s.logon_time
          ,      s.last_call_et
          ,      s.row_wait_obj#
          from   gv$session s
          where  s.blocking_session is not null
          and    s.last_call_et > 600 -- 10 minutos
     ),
     locker_session as
     (
          --
          -- Locker sessions
          --
          select s.blocking_instance
          ,      s.blocking_session
          ,      s.inst_id
          ,      s.sid
          ,      s.serial#
          ,      s.paddr
          ,      s.status
          ,      s.username
          ,      s.osuser
          ,      nvl(nvl(s.module,s.program),s.action) module
          ,      s.logon_time
          ,      s.last_call_et
          ,      s.row_wait_obj#
          from   gv$session s
          where  ( s.inst_id,s.sid ) in (
                                          select blocking_instance
                                          ,      blocking_session
                                          from   locked_session
                                        )
     ),
     locking as
     (
          select *
          from   locked_session
          union
          select *
          from   locker_session
     )
--
select  lpad(' ',level*2-2,' ')||l.sid||','||l.serial# "SID,SERIAL#"
,       to_char(l.inst_id,'FM99') no
,       p.spid
,       l.status
,       l.username
,       l.osuser
,       l.module
,       sw.event
,       l.logon_time
,       decode(last_call_et,0,null,decode(extract(day from numtodsinterval(l.last_call_et,'SECOND')),0,NULL,
                                   to_char(extract(day from numtodsinterval(l.last_call_et,'SECOND')),'FM99')||' ')||
                                   to_char(extract(hour   from numtodsinterval(l.last_call_et,'SECOND')),'FM09')||':'||
                                   to_char(extract(minute from numtodsinterval(l.last_call_et,'SECOND')),'FM09')||':'||
                                   to_char(extract(second from numtodsinterval(l.last_call_et,'SECOND')),'FM09')) waiting
,       o.object_name
from    locking         l
,       gv$process      p
,       gv$session_wait sw
,       dba_objects     o
where   p.inst_id       = l.inst_id
and     p.addr          = l.paddr
and     sw.inst_id      = l.inst_id
and     sw.sid          = l.sid
and     l.row_wait_obj# = o.object_id(+)
start   with l.blocking_session is null
connect by prior l.sid = l.blocking_session
/

