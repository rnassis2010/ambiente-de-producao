REM
REM  NAME
REM    sid.sql - $DBAHOME
REM  DESCRIPTION
REM    List database information about SID
REM  AUTHOR
REM  PARAMETERS IN
REM    SID
REM      sid number to search for
REM  NOTES
REM
REM  CHANGES
REM    Author    Date    Description
REM    --------  ------- ------------------------------------------------------
REM
ACCEPT pSID PROMPT "Enter SID number: "

SET VERIFY OFF
SET LINESIZE 1000
SET LONG 30000
COL username FORMAT A15
COL sid      FORMAT 99999
COL serial   FORMAT 9999	HEAD SER#
COL osuser   FORMAT A15
COL "Logon Time" FORMAT A20
COL module   FORMAT A60
COL program  FORMAT A50
COL pid      FORMAT 99999
COL gets     FORMAT 999,999,999,999
COL reads    FORMAT 999,999,999,999

COL sql_address    NEW_VALUE addr
COL sql_hash_value NEW_VALUE hash
COL sql_child      NEW_VALUE child

SELECT 
 s.username
,s.status
,s.inst_id
,p.spid
,s.sid
,i.consistent_gets Gets
,i.physical_reads Reads
,s.serial#
,s.osuser
,TO_CHAR(s.logon_time, 'DD/MM/YYYY HH24:MI:SS') "Logon Time"
,s.module
,s.program
,s.sql_address
,s.sql_hash_value
,null sql_child
FROM gv$session s
,gv$process p
,gv$sess_io i
WHERE 
    s.sid = &&pSID
AND p.addr = s.paddr
AND i.sid = s.sid
ORDER BY gets DESC
/


select '-----------------------------------------------------------------------------------------------------------------------------------------------' 
	from dual
UNION ALL
select '|   | Operation                                                      |  Name                         |  Rows | Bytes|  Cost  | Pstart| Pstop |'  
	as "Plan Table" 
from dual
UNION ALL
select '-----------------------------------------------------------------------------------------------------------------------------------------------' 
	from dual
UNION ALL
select 
	'|' || lpad(id,3)||
	rpad('| '||substr(lpad(' ',1*(depth-1))||operation||
            decode(options, null,'',' '||options), 1, 64), 65, ' ')||'|'||
       rpad(substr(object_name||' ',1, 30), 31, ' ')||'|'||
       lpad(decode(cardinality,null,'  ',
                decode(sign(cardinality-1000), -1, cardinality||' ', 
                decode(sign(cardinality-1000000), -1, trunc(cardinality/1000)||'K', 
                decode(sign(cardinality-1000000000), -1, trunc(cardinality/1000000)||'M', 
                       trunc(cardinality/1000000000)||'G')))), 7, ' ') || '|' ||
       lpad(decode(bytes,null,' ',
                decode(sign(bytes-1024), -1, bytes||' ', 
                decode(sign(bytes-1048576), -1, trunc(bytes/1024)||'K', 
                decode(sign(bytes-1073741824), -1, trunc(bytes/1048576)||'M', 
                       trunc(bytes/1073741824)||'G')))), 6, ' ') || '|' ||
       lpad(decode(cost,null,' ',
                decode(sign(cost-10000000), -1, cost||' ', 
                decode(sign(cost-1000000000), -1, trunc(cost/1000000)||'M', 
                       trunc(cost/1000000000)||'G'))), 8, ' ') || '|' ||
       lpad(decode(partition_start, 'ROW LOCATION', 'ROWID', 
            decode(partition_start, 'KEY', 'KEY', decode(partition_start, 
            'KEY(INLIST)', 'KEY(I)', decode(substr(partition_start, 1, 6), 
            'NUMBER', substr(substr(partition_start, 8, 10), 1, 
            length(substr(partition_start, 8, 10))-1), 
            decode(partition_start,null,' ',partition_start)))))||' ', 7, ' ')|| '|' ||
       lpad(decode(partition_stop, 'ROW LOCATION', 'ROW L', 
          decode(partition_stop, 'KEY', 'KEY', decode(partition_stop, 
          'KEY(INLIST)', 'KEY(I)', decode(substr(partition_stop, 1, 6), 
          'NUMBER', substr(substr(partition_stop, 8, 10), 1, 
          length(substr(partition_stop, 8, 10))-1), 
          decode(partition_stop,null,' ',partition_stop)))))||' ', 7, ' ')||'|' as "Explain plan"
from
	V$sql_plan
where 
	hash_value = &hash and child_number=nvl(to_number('&child'),0)
--	and (address = '&addr' or '&addr' is null)
UNION ALL
select '-----------------------------------------------------------------------------------------------------------------------------------------------' 
	from dual
UNION ALL
select 
	distinct 'OPTIMIZER_MODE: ' || OPTIMIZER
	from V$sql_plan
where 
	hash_value = &hash
--	and (address = '&addr' or '&addr' is null)
	and OPTIMIZER is not null
UNION ALL
select 
	'-----------------------------------------------------------------------------------------------------------------------------------------------'  || chr(10) ||
	chr(10) || 
	'FILTER/ACCESS PREDICATES' || chr(10) ||
	'------------------------' || chr(10)
from 
	dual
UNION ALL
select distinct
	case when ACCESS_PREDICATES is not null then lpad(id,4) || ':(ACCESS) ' || ACCESS_PREDICATES || chr(10) end ||
	case when FILTER_PREDICATES is not null then
		case when ACCESS_PREDICATES is not null then chr(10) end ||
		lpad(id,4) || ':(FILTER) ' || FILTER_PREDICATES end
from
	V$sql_plan
where 
	hash_value = &hash and child_number=nvl(to_number('&child'),0)
--	and (address = '&addr' or '&addr' is null)
	and ((ACCESS_PREDICATES is not null) or (ACCESS_PREDICATES is not null));


COL sql_text FORMAT A100 WRAP
COL disk_reads FORMAT 999,999,999,999
COL buffer_gets FORMAT 999,999,999,999
COL rows_processed FORMAT 999,999,9999
COL module FORMAT a30
SELECT
 s.sid
,a.sql_id
,s.sql_hash_value
,s.sql_address
,a.sql_text
,s.module
,executions
,disk_reads
,buffer_gets
,rows_processed
FROM
 v$session s
,v$sqlarea a
WHERE
    s.sid = &&pSID
AND a.address = s.sql_address
AND a.hash_value = s.sql_hash_value
/

