SET FEEDBACK ON
SET PAGESIZE 1000
SET LINESIZE 200

COLUMN command FORMAT A75

ACCEPT vOwner prompt "Owner : "
select 'alter '||
        decode( object_type,'PACKAGE BODY','PACKAGE',object_type ) ||' '||
        decode( object_type,'JAVA CLASS','"',owner )               ||
        decode( object_type,'JAVA CLASS','','.' )                  ||
        object_name                                                ||
        decode( object_type,'JAVA CLASS','" ',' ' )                ||
        decode( object_type,'INDEX','rebuild ','compile ' )        ||
        decode( object_type,'TYPE','','JAVA CLASS','','PACKAGE BODY','body',
                'TRIGGER',' ','PROCEDURE',' ','INDEX',' ','FUNCTION',' ','MATERIALIZED VIEW',' ','SYNONYM',' ',object_type) || ';' COMMAND
,       created
,       last_ddl_time
,       timestamp
from    dba_objects -- as of timestamp systimestamp - interval '60' minute
where   status           = 'INVALID'
and     object_type     != 'UNDEFINED'
and     ( '&vOwner' is null or owner like upper('&vOwner') )
order   by owner
/
SET HEADING ON

