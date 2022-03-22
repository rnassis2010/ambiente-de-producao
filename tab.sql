set verify off
set lines 300
set pages 1000
accept vOwner     prompt "Owner : "
accept vTableName prompt "Table : "

column owner      format A8
column table_name format A30
column tablespace format A25
column last_analyzed format A19
column temp       format A4
column degree     format A6
column num_rows   format 9,999,999,999
column bytes      format 999,999,999,999
column avg_bytes  format 999,999,999,999
column "INITIAL"  format 999999999
column "NEXT"     format 999999999
column "MAX"      format 999999999999
column "PCT"      format 999
column "FREE"     format 999
column ITRANS     format 999

SELECT owner
,      table_name
,      tablespace_name tablespace
,      to_char(last_analyzed,'dd/mm/yyyy hh24:mi:ss') last_analyzed
,      global_stats
,      user_stats
,      blocks
,      num_rows
,      temporary temp
,      trim(degree) degree
,      logging
,      (
         select sum(bytes)
         from   dba_segments s
         where  s.owner        = t.owner
         and    s.segment_name = t.table_name
         and    s.segment_type like 'TABLE%'
       ) bytes
,      round((avg_row_len*num_rows)*(1+(nvl(pct_free,0)/100))) avg_bytes
--,      initial_extent "INITIAL"
--,      next_extent    "NEXT"
--,      max_extents    "MAX"
,      pct_increase   "PCT"
,      pct_free       "FREE"
,      ini_trans      ITRANS
FROM   dba_tables t
WHERE  ( owner      LIKE UPPER('&vOwner')     or '&vOwner'     IS NULL )
AND    ( table_name LIKE UPPER('&vTableName') or '&vTableName' IS NULL )
ORDER  BY 1,11 DESC
/

