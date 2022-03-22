set line 250
--set pagesize 0
--set feedback off
--set echo off
--set termout off
--set showmode off
--set verify off
--set trimspool off
col SEGMENT_NAME format a30

-- Tira foto antes do aumento
select OWNER,SEGMENT_NAME,BYTES/1024/1024 MB from dba_segments where SEGMENT_NAME = 'ATG_WF_1';

select df.tablespace_name "Tablespace",
totalusedspace "Used MB",
(df.totalspace - tu.totalusedspace) "Free MB",
df.totalspace "Total MB",
round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace))
"Pct. Free"
from
(select tablespace_name,
round(sum(bytes) / 1048576) TotalSpace
from dba_data_files
group by tablespace_name) df,
(select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
from dba_segments
group by tablespace_name) tu
where df.tablespace_name = tu.tablespace_name 
and tu.tablespace_name = 'ATG_WF';

-- Aumento da tabela: Forca o estouro
alter table atg_wf_1 allocate extent;
alter table atg_wf_1 allocate extent;
alter table atg_wf_1 allocate extent;

-- Tira foto depois do aumento
select OWNER,SEGMENT_NAME,BYTES/1024/1024 MB from dba_segments where SEGMENT_NAME = 'ATG_WF_1';

select df.tablespace_name "Tablespace",
totalusedspace "Used MB",
(df.totalspace - tu.totalusedspace) "Free MB",
df.totalspace "Total MB",
round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace))
"Pct. Free"
from
(select tablespace_name,
round(sum(bytes) / 1048576) TotalSpace
from dba_data_files
group by tablespace_name) df,
(select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
from dba_segments
group by tablespace_name) tu
where df.tablespace_name = tu.tablespace_name 
and tu.tablespace_name = 'ATG_WF';
