set pagesize 0
set feedback off
set echo off
set heading off
set termout off
set showmode off
set verify off
set trimspool off
spool /export/home/oracle/atg/kill_forms.sql
SELECT 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;'
FROM gv$session
WHERE LAST_CALL_ET > 7200
and status = 'INACTIVE'
and PROGRAM like 'frmweb%'
and MODULE not like '%WMS%';
spool off
