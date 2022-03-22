set linesize 200
set pagesize 200
accept user    prompt "USERNAME : "
accept profile prompt "PROFILE  : "

column username format a25
column status   format a20
column default_ts   format a15
column temporary_ts format a12
column profile format a20

select username
,      user_id
,      account_status status
,      lock_date
,      expiry_date
,      default_tablespace default_ts
,      temporary_tablespace temporary_ts
,      created
,      profile
from   dba_users
where  username like upper('&user%')
and    profile  like upper('&profile%')
order  by username
/
undefine user

