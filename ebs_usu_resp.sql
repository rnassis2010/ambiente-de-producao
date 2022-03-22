alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
--set feedback off
set pagesize 1000
set linesize 300
set trimspool on
set verify off
column user_name format a15
column responsibility_name format a40
column created_by format a15
accept vUser prompt "Informe o Usuario         : "
accept vResp prompt "Informe a Responsabilidade: "
select a.user_name
,      c.responsibility_id
,      c.responsibility_name
,      c.responsibility_key
,      b.start_date
,      b.end_date
,      d.user_name created_by
,      b.creation_date
from   apps.fnd_user                    a
,      apps.fnd_user_resp_groups_direct b
,      apps.fnd_responsibility_vl       c
,      apps.fnd_user                    d
where  upper(a.user_name)           like upper('%&vUser%')
and    a.user_id                       = b.user_id
and    b.created_by                    = d.user_id
and    b.responsibility_application_id = c.application_id
and    b.responsibility_id             = c.responsibility_id
and    b.end_date is null
and    upper(c.responsibility_name)    like upper('%&vResp%')
order  by 3
/

