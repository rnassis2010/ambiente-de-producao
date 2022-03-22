set verify off
set feedback off
set linesize 200

column login format a10

accept UserName prompt "UserName: "

break on login on last_logon_date on end_date


select a.user_name login
,      a.last_logon_date
,      a.end_date
,      b.attempt_time
from   apps.fnd_user                a
,      apps.fnd_unsuccessful_logins b
where  a.user_id = b.user_id
and    a.user_name like upper('%&UserName%')
order  by attempt_time
/
