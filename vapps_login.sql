set line 250
set pagesize 100
set feedback off
col machine format a20
col USERNAME format a10
col PROGRAM format a20
col OSUSER format a20
spool /export/home/oracle/atg/apps_login_email.log
SELECT to_char(LOGON_TIME, 'DD/MM/YYYY HH24:MI:SS') as LOGON_TIME,INST_ID,SID,SERIAL#,USERNAME,STATUS,OSUSER,MACHINE,PROGRAM
FROM gv$session
where username = 'APPS'
and upper (program) in ('PLSQLDEV.EXE','SQLNAVIGATOR.EXE')
order by LOGON_TIME;
spool off
