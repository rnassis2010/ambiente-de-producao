set feedback on
set verify off
set pagesize 100
set linesize 300
set numwidth 18
accept vOwner       prompt "Owner      = "
accept vSegmentName prompt "Segmento   = "
accept vTablespace  prompt "Tablespace = "
column owner           format a10
column segment_name    format a30
column segment_type    format a20
column tablespace_name format a25
column bytes           format 999,999,999,999
column extents         format 99,999,999
column initial_extent  format 999,999,999 heading "INITIAL"
column next_extent     format 999,999,999 heading "NEXT"
column max_extents     format 999,999,999,999 heading "MAX"
column blocks          format 999,999,999 heading "BLOCKS"
column pct_increase    format 999 heading "INCREASE"

select owner
,      segment_name
,      segment_type
,      partition_name
,      tablespace_name
,      bytes
,      extents
,      initial_extent
,      next_extent
,      max_extents
,      blocks
,      pct_increase
from   dba_segments
where  ( owner like upper('&vOwner') or '&vOwner' is null )
and    ( segment_name like upper('&vSegmentName') or '&vSegmentName' is null )
and    ( tablespace_name like upper('&vTablespace') or '&vTablespace' is null )
/

