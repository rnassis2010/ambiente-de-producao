set pagesize 10000

accept sqlid  prompt 'SQL_ID         : '
accept phash  prompt 'Plan_Hash_Value: '

select plan_table_output from table (dbms_xplan.display_awr('&sqlid',to_number('&phash')));

