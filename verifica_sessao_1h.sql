set line 200
set pagesize 200
col MODULE format a50
col SQL_PROFILE format a30
col SQL_PLAN_BASELINE format a30
select distinct to_char(a.LOGON_TIME,'DD/MM/YYYY-HH24:MI:SS') LOGON_TIME,
a.INST_ID,a.SID,a.SERIAL#,a.SQL_ID,a.SQL_HASH_VALUE,
a.SQL_CHILD_NUMBER,b.PLAN_HASH_VALUE,
a.module,ceil(a.LAST_CALL_ET/60) Min
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
