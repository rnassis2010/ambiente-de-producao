set linesize 300
set pagesize 1000
column job format 99999
column schema_user format a15
column what format a80 wrap
column interval format a35
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
select job,broken,schema_user,last_date,next_date,interval,what
from   dba_jobs
/

