set pagesize 1000
set linesize 200
set verify off

COLUMN owner       FORMAT A15
COLUMN object_type FORMAT A17
COLUMN object_id   FORMAT 9999999
COLUMN object_name FORMAT A40
COLUMN status      FORMAT A10
COLUMN last_ddl    FORMAT A20

accept vOwner      prompt "Owner                  : "
accept vObjectName prompt "Nome do Objeto         : "
accept vObjectType prompt "Tipo do Objeto         : "
accept vStatus     prompt "Status (VALID/INVALID) : "

SELECT owner
,      object_type
,      object_id
,      object_name
,      status
,      created
,      to_char(last_ddl_time,'dd/mm/yyyy hh24:mi:ss') last_ddl
,      timestamp
FROM   dba_objects --as of timestamp systimestamp - interval '60' minute
WHERE  ( owner       LIKE UPPER('&vOwner')       or '&vOwner'      IS NULL )
AND    ( object_name LIKE UPPER('&vObjectName') or '&vObjectName' IS NULL )
AND    ( object_type LIKE UPPER('&vObjectType%') or '&vObjectType' IS NULL )
AND    ( status      LIKE UPPER('&vStatus%')     or '&vStatus'     IS NULL )
ORDER  BY owner
,         object_type
/
undefine vOwner
undefine vObjectName
undefine vObjectType
undefine vStatus

