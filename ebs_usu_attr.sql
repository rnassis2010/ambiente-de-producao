set feedback off
column full_name format a60
accept user   prompt "User Name       : "
accept person prompt "Person Name (HR): "

set heading off
set pagesize 1000

select 'USER_ID    : '||user_id||chr(10)||
       'DESCRIPTION: '||description
from   apps.fnd_user
where  user_name = upper('&user');

set heading on
select b.attribute_code attribute_code
,      b.number_value   person_id
,      c.full_name      full_name
from   apps.fnd_user                    a
,      apps.ak_web_user_sec_attr_values b
,      apps.per_all_people_f            c
where  a.user_name       = upper('&user')
and    b.web_user_id     = a.user_id
and    b.number_value    = c.person_id
and    c.full_name    like upper('%&person%')
and    trunc(sysdate) between c.effective_start_date and c.effective_end_date
order  by c.full_name
/
set feedback on
undefine user
undefine person

