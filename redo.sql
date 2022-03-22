select s.sid, n.name, s.value, sn.username, sn.program, sn.type, sn.module
from v$sesstat s 
  join v$statname n on n.statistic# = s.statistic#
  join v$session sn on sn.sid = s.sid
where name like '%redo entries%'
order by value;
