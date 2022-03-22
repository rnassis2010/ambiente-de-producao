set serveroutput on size 1000000
set feedback off
set verify off
set linesize 1000
set trimspool on
spool /tmp/sqltune.log

accept vSQL_ID prompt "SQL_ID = "

BEGIN
  dbms_sqltune.drop_tuning_task('SQLTUNE_QUERY');
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
prompt Task deleted.

DECLARE
  stmt_task         varchar2(64);
  l_plan_hash_value number(15);
BEGIN
  --
  select plan_hash_value
  into   l_plan_hash_value
  from   v$sqlarea
  where  sql_id = '&&vSQL_ID';
  --
  dbms_output.put_line('PLAN_HASH_VALUE = '||l_plan_hash_value);
  --
  stmt_task := sys.dbms_sqltune.create_tuning_task(
                                                    sql_id          => '&&vSQL_ID'
                                                  , plan_hash_value => l_plan_hash_value
                                                  , time_limit      => 3600
                                                  , task_name       => 'SQLTUNE_QUERY'
                                                  , description     => 'SQLTUNE_QUERY'
                                                  );
END;
/
prompt Task created.

prompt Task running...
EXECUTE dbms_sqltune.execute_tuning_task('SQLTUNE_QUERY');

ALTER SESSION SET nls_date_format='dd-mon-yyyy hh24:mi:ss';

col description FOR a40
SELECT task_name, description, advisor_name, execution_start, execution_end, status
FROM   dba_advisor_tasks
WHERE  task_name = 'SQLTUNE_QUERY'
ORDER  BY task_id DESC;

SET linesize 200
SET LONG 999999999
SET pages 1000
SET longchunksize 20000
SELECT dbms_sqltune.report_tuning_task('SQLTUNE_QUERY', 'TEXT', 'ALL') FROM dual;

spool off

