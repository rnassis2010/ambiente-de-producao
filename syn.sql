set pagesize 1000
set linesize 120
set verify off
COLUMN owner        FORMAT A15
COLUMN synonym_name FORMAT A30
COLUMN table_owner  FORMAT A15
COLUMN table_name   FORMAT A30
COLUMN db_link      FORMAT A20
accept vOwner       prompt "Owner        : "
accept vSynonymName prompt "Synonym Name : "
accept vTableOwner  prompt "Table Owner  : "
accept vTableName   prompt "Table Name   : "
SELECT owner
,      synonym_name
,      table_owner
,      table_name
,      db_link
FROM   dba_synonyms
WHERE  ( owner        LIKE UPPER('&vOwner')       or '&vOwner'       IS NULL )
AND    ( synonym_name LIKE UPPER('&vSynonymName') or '&vSynonymName' IS NULL )
AND    ( table_owner  LIKE UPPER('&vTableOwner')  or '&vTableOwner'  IS NULL )
AND    ( table_name   LIKE UPPER('&vTableName')   or '&vTableName'   IS NULL )
ORDER  BY owner
/
undefine vOwner
undefine vSynonymName
undefine vTableOwner
undefine vTableName


