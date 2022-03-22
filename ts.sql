set verify off

column MBtotal    format 99,999,999 heading "Total(MB)"
column MBFree     format 99,999,999 heading "Free(MB)"
column "%Free"    format 999        heading "%Free(MB)"
column MBAumentar format 99,999,999 heading "Aumentar(MB)"

define vPercDef=20
define vByteDef=20000

accept vTablespaceName prompt "Tablespace Name : "
accept vPerc           prompt "%Livre    [20%] : "
accept vByte           prompt "Mb Livre [20000] : "

select ts.tablespace_name
,      nvl(round(df.bytes,0),0)                             MBTotal
,      nvl(round(free.bytes,0),0)                           MBFree
,      nvl(round((free.bytes / df.bytes)*100,0),0)          "%Free"
,      nvl(round( (( df.bytes * 0.10 ) - free.bytes ),0),0) MBAumentar
from
(
  select tablespace_name
  ,      nvl(sum(bytes),0) / 1024 / 1024 bytes
  from   dba_free_space
  group  by tablespace_name
) free,
(
  select tablespace_name
  ,      nvl(sum(bytes),0) / 1024 / 1024 bytes
  from   dba_data_files
  group  by tablespace_name
) df,
(
  select tablespace_name
  from   dba_tablespaces
  where  contents not in ( 'TEMPORARY','UNDO' )
) ts
where ts.tablespace_name    = free.tablespace_name(+)
and   ts.tablespace_name    = df.tablespace_name(+)
and   ts.tablespace_name like upper('%&vTablespaceName%')
and   ( (
          nvl(round((free.bytes / df.bytes)*100,0),0) <= to_number(nvl('&vPerc','&vPercDef')) and
          free.bytes                                  <  to_number(nvl('&vByte','&vByteDef'))
        ) or '&vTablespaceName' is not null
      )
/

