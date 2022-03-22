set linesize 300
column name                    format a10
column total_mg                format 999,999,999 heading "Total(GB)"
column free_mg                 format 999,999,999 heading "Free(GB)"
column required_mirror_free_gb format 999,999,999 heading "Req Mirror Free(GB)"
column usable_file_gb          format 999,999,999 heading "Usable Free(GB)"
column "%Free"                 format 990.99      heading "%Free"
column "%Usable Free"          format 990.99      heading "%Usable Free"

compute sum of total_gb on report
compute sum of free_gb on report
compute sum of required_mirror_free_gb on report
compute sum of usable_file_gb on report
break on report

prompt #
prompt # REDUNDANCY LEVEL
prompt #   NORMAL - 2 (1 primary and 1 mirror)
prompt #   HIGH   - 3 (1 primary and 2 mirrors)
prompt #
prompt # USABLE_FILE_MB = FREE_MB - REQUIRED_MIRROR_FREE_MB / REDUNDANCY LEVEL
prompt #


select name
,      type
--,      state
,      round(total_mb / 1024 / decode(type,'HIGH',3,'NORMAL',2,1),0) total_gb
,      round(free_mb  / 1024 / decode(type,'HIGH',3,'NORMAL',2,1),0) free_gb
,      decode(trunc((1 - ((total_mb-free_mb)/total_mb) )*100),0,
                    (1 - ((total_mb-free_mb)/total_mb) )*100,
                    round((1 - ((total_mb-free_mb)/total_mb) )*100)) "%Free"
,      round(required_mirror_free_mb / 1024 / decode(type,'HIGH',3,'NORMAL',2,1),0) required_mirror_free_gb
,      round(usable_file_mb /1024 / decode(type,'HIGH',3,'NORMAL',2,1),0) usable_file_gb
,      decode(trunc((1 - ((total_mb-usable_file_mb)/total_mb) )*100),0,
                    (1 - ((total_mb-usable_file_mb)/total_mb) )*100,
                    round((1 - ((total_mb-usable_file_mb)/total_mb) )*100)) "%Usable Free"
from   v$asm_diskgroup
where  state <> 'DISMOUNTED';

