set line 250
set pagesize 0
set feedback off
set echo off
set heading off
set termout off
set showmode off
set verify off
set trimspool off
spool /u02/atg/exec_sqltune_sessao_1h_1.sql
select distinct 'execute dbms_sqltune.drop_tuning_task(''sqltune_'||a.sql_id||''');'
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.INST_ID = 1
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
select  distinct 'EXEC :stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id => '''||a.sql_id||''', time_limit => 600, task_name=> ''sqltune_'||a.sql_id||''');'
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.INST_ID = 1
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
select distinct 'EXECUTE dbms_sqltune.execute_tuning_task(''sqltune_'||a.sql_id||''');'
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.INST_ID = 1
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
spool off
spool /u02/atg/exec_sqltune_sessao_1h_2.sql
select distinct 'execute dbms_sqltune.drop_tuning_task(''sqltune_'||a.sql_id||''');'
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.INST_ID = 2
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
select distinct 'EXEC :stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id => '''||a.sql_id||''', time_limit => 600, task_name=> ''sqltune_'||a.sql_id||''');'
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.INST_ID = 2
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
select distinct 'EXECUTE dbms_sqltune.execute_tuning_task(''sqltune_'||a.sql_id||''');'
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.INST_ID = 2
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
spool off
spool /u02/atg/exec_sqltune_report_sessao_1h_1.sql
select distinct 'SELECT dbms_sqltune.report_tuning_task(''sqltune_'||a.sql_id||''',''TEXT'',''TYPICAL'',''FINDINGS'') from dual;'
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.INST_ID = 1
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
spool off
spool /u02/atg/exec_sqltune_report_sessao_1h_2.sql
select distinct 'SELECT dbms_sqltune.report_tuning_task(''sqltune_'||a.sql_id||''',''TEXT'',''TYPICAL'',''FINDINGS'') from dual;'
from gv$session a,
gv$sqlarea b
where a.status = 'ACTIVE'
AND a.TYPE = 'USER'
and a.LAST_CALL_ET > 3600
and a.INST_ID = 2
and a.SQL_ID = b.SQL_ID
and a.module not in ('DownloadProcessorNormalMode','DownloadProcessorMigrationMode','C_AQCT_SVC');
spool off
