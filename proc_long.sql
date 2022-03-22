COL opname FORMAT a20
SELECT sid, serial#, opname,TO_CHAR(start_time, 'DD/MM/YY - HH24:MI:SS') AS "Data_Inicial", (sofar/totalwork)*100 AS "%_Completo"
FROM v$session_longops
WHERE (sofar/totalwork)*100 < 100
ORDER BY 4 asc
/

