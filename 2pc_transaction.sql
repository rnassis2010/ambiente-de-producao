alter session set nls_date_format = 'DD/MM/YYYY-HH24:MI:SS';
set line 250
set pagesize 100
col LOCAL_TRAN_ID format a15
col GLOBAL_TRAN_ID format a28
col TRAN_COMMENT format a30
col HOST format a27
col os_user format a15
select distinct a.FAIL_TIME,a.RETRY_TIME,a.LOCAL_TRAN_ID,a.GLOBAL_TRAN_ID,a.MIXED,a.HOST,a.os_user,b.IN_OUT,a.state
from dba_2pc_pending a,
DBA_2PC_NEIGHBORS b
where a.LOCAL_TRAN_ID = b.LOCAL_TRAN_ID
--and a.os_user = 'aspeda5o'
--and a.state = 'prepared'
--and a.mixed = 'no'
order by 1;
