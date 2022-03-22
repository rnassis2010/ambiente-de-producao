set line 250
set echo off
set feedback off
set verify off
SET LONG 500
accept vsql_id     prompt "SQL_ID      : "
accept vinst_id    prompt "INST_ID     : "
SELECT SQL_FULLTEXT
FROM GV$SQLAREA
WHERE SQL_ID = '&vsql_id'
AND INST_ID = '&vinst_id';
