break on report
compute sum of gbytes on report

select round(sum(bytes)/1024/1024/1024) GBytes, 'DATA FILES' TYPE from DBA_DATA_FILES
union
select round(sum(bytes)/1024/1024/1024) GBytes, 'TEMP FILES' TYPE from DBA_temp_FILES
union
select round(sum(bytes)/1024/1024/1024) GBytes, 'REDO FILES' TYPE
from   v$log     l
,      v$logfile f
where  l.group# = f.group#
/

