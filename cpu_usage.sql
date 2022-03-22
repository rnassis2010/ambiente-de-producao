set pagesize 2000
set linesize 200
set trimspool on
column module format A60
compute sum of cpu_usage_seconds on report
break on report
select
   se.SID,
   ss.username,
   ss.osuser,
   ss.module,
   ss.logon_time,
   VALUE/100 cpu_usage_seconds
from
   v$session ss,
   v$sesstat se,
   v$statname sn
where
   se.STATISTIC# = sn.STATISTIC#
and
   NAME like '%CPU used by this session%'
and
   se.SID = ss.SID
and
   ss.status='ACTIVE'
and
   ss.username is not null
order by VALUE desc
/
select stat_name,
       round(value/1000000) "Time (Sec)"
from   v$sys_time_model
where  stat_name = 'DB CPU'
/

