select a.value smart_scan_started, b.value smart_scan_cont, a.value - b.value no_smart_scan
from v$sysstat a, v$sysstat b
where a.statistic#=262
and b.statistic#=263
/
