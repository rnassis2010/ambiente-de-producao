set pagesize 0
set feedback off
set echo off
set heading off
set termout off
set showmode off
set verify off
set trimspool off
spool /export/home/oracle/atg/kill_apps.sql
SELECT 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;'
FROM gv$session
where username = 'APPS'
and upper (program) in ('PLSQLDEV.EXE','SQLNAVIGATOR.EXE');
spool off
