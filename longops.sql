column ssid             format a5
column username         format a10
column processo         format a100
column inicio           format a20
column "Tempo(s)"       format a10
column "Termina em (S)" format 9999999

set pagesize 80

SELECT to_char(s.sid)                              ssid
,      s.username
,      substr(message,1,100)                       "Processo"
,      to_char(start_time,'dd/mm/yyyy hh24:mi:ss') "Inicio"
,      TO_CHAR(elapsed_seconds,'9999999')          "Tempo(s)"
,      TIME_REMAINING                              "Termina em (s)"
FROM   gv$session_longops l
,      gv$session         s
WHERE  sofar     < totalWork
AND    s.inst_id = l.inst_id
AND    s.sid     = l.sid
ORDER  BY "Tempo(s)" desc
/
