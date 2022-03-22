------------------------------------------------------------------------------
-- Este script mostra o plano de execução de uma query previamente executada,
--     consultando a V$SQL_PLAN
--
-- Baseado no utlxpls.sql do Oracle 8i
--
-- Eduardo Claro, 15/12/2005
------------------------------------------------------------------------------

set linesize 200

prompt
accept hash  prompt 'Hash_Value  : '
accept addr  prompt 'Address     : '
accept child prompt 'Child_Number: '
set head off

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
	gV$sql_plan
where 
	hash_value = &hash and child_number=nvl(to_number('&child'),0)
--	and (address = '&addr' or '&addr' is null)
UNION ALL
select '-----------------------------------------------------------------------------------------------------------------------------------------------' 
	from dual
UNION ALL
select 
	distinct 'OPTIMIZER_MODE: ' || OPTIMIZER
	from gV$sql_plan
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
	gV$sql_plan
where 
	hash_value = &hash and child_number=nvl(to_number('&child'),0)
--	and (address = '&addr' or '&addr' is null)
	and ((ACCESS_PREDICATES is not null) or (ACCESS_PREDICATES is not null))
/

set head on

