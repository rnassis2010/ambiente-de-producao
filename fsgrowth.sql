set pagesize 100

column MÊS    format a15 noprint
column "MÊS " format a20
column ANO    format a4  noprint

break on ANO on report
compute sum of "CRESCIMENTO EM MB" on ANO

select to_char(creation_time,'yyyy')                                      ANO
,      to_char(creation_time,'yyyymm')                                    MÊS
,      to_char(creation_time,'yyyy Month','NLS_DATE_LANGUAGE=PORTUGUESE') "MÊS "
,      round(sum(bytes)/1024/1024)                                        "CRESCIMENTO EM MB"
from   v$datafile
where  creation_time >= to_date('01012009000000','ddmmyyyyhh24miss')
group  by to_char(creation_time,'yyyy')
,         to_char(creation_time,'yyyymm')
,         to_char(creation_time,'yyyy Month','NLS_DATE_LANGUAGE=PORTUGUESE')
/
