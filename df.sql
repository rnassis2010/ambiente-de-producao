set linesize 1000

col perc for 99 head "%LIVRE"
col total for 999,999,999
col livre like total
col file_name format a50
col autoextend format a10
col tablespace_name format a15
col status format a10
col online_status format a13
col bytes format 999,999,999,999
col maxbytes format 999,999,999,999

define defperc = 10

prompt
accept tabsp prompt 'Tablespace: '

select FILE_NAME
,      FILE_ID
,      TABLESPACE_NAME
,      BYTES
,      BLOCKS
,      STATUS
,      AUTOEXTENSIBLE autoextend
,      MAXBYTES
,      MAXBLOCKS
,      INCREMENT_BY
,      ONLINE_STATUS
from   dba_data_files
where  tablespace_name like upper('%&tabsp%')
order  by file_id
/

