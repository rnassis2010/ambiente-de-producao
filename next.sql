SELECT
a.owner
,a.segment_name
,a.tablespace_name
,a.next_extent
,b.largest
FROM
dba_segments a
,(SELECT tablespace_name, MAX(bytes) largest
  FROM dba_free_space
  GROUP BY tablespace_name) b
WHERE b.tablespace_name = a.tablespace_name
AND b.largest < a.next_extent
/

