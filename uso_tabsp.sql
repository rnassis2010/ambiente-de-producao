## Monitor Uso Tablespace ##

set lines 1000
set pages 1000

SELECT Total.name "Tablespace Name",
       nvl(total_space-Free_space, 0) Used_space, 
       nvl(Free_space, 0) Free_space,
       total_space,
       round(nvl(total_space-Free_space, 0)*100/total_space,2) "Perc. Uso"
FROM
  (select tablespace_name, sum(bytes/1024/1024) Free_Space
     from sys.dba_free_space
    group by tablespace_name
  ) Free,
  (select b.name,  sum(bytes/1024/1024) TOTAL_SPACE
     from sys.v_$datafile a, sys.v_$tablespace B
    where a.ts# = b.ts#
    group by b.name
  ) Total
WHERE Free.Tablespace_name(+) = Total.name
ORDER BY Total.name
/
