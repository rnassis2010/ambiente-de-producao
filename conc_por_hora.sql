set feedback off
set verify off
set linesize 300
set pagesize 1000
set trimspool on

column "DIA" format a10
column "00"  format 99999
column "01"  format 99999
column "02"  format 99999
column "03"  format 99999
column "04"  format 99999
column "05"  format 99999
column "06"  format 99999
column "07"  format 99999
column "08"  format 99999
column "09"  format 99999
column "10"  format 99999
column "11"  format 99999
column "12"  format 99999
column "13"  format 99999
column "14"  format 99999
column "15"  format 99999
column "16"  format 99999
column "17"  format 99999
column "18"  format 99999
column "19"  format 99999
column "20"  format 99999
column "21"  format 99999
column "22"  format 99999
column "23"  format 99999
column "24"  format 99999

column "TOT" format 999999

compute sum of TOT break on report
break on report

column DataIni NEW_VALUE vDtIni noprint
column DataFim NEW_VALUE vDtFim noprint

set termout off
select to_char(sysdate-1,'dd/mm/yyyy') DataIni
,      to_char(sysdate-1,'dd/mm/yyyy') DataFim
from   dual;
set termout on

prompt **
prompt ** Historico de Concurrents executados por hora
prompt **

accept vDataIni prompt "Informe a Data Inicio [&vDtIni]: "
accept vDataFim prompt "Informe a Data Fim    [&vDtFim]: "

set termout off
select nvl('&vDataIni','&vDtIni') DataIni
,      nvl('&vDataFim','&vDtFim') DataFim
from   dual;
set termout on

alter session set nls_date_format='dd/mm/yyyy';

SELECT   trunc(actual_start_date)                                "DIA"
,        sum(decode(to_char(actual_start_date,'HH24'),'00',1,0)) "00"
,        sum(decode(to_char(actual_start_date,'HH24'),'01',1,0)) "01"
,        sum(decode(to_char(actual_start_date,'HH24'),'02',1,0)) "02"
,        sum(decode(to_char(actual_start_date,'HH24'),'03',1,0)) "03"
,        sum(decode(to_char(actual_start_date,'HH24'),'04',1,0)) "04"
,        sum(decode(to_char(actual_start_date,'HH24'),'05',1,0)) "05"
,        sum(decode(to_char(actual_start_date,'HH24'),'06',1,0)) "06"
,        sum(decode(to_char(actual_start_date,'HH24'),'07',1,0)) "07"
,        sum(decode(to_char(actual_start_date,'HH24'),'08',1,0)) "08"
,        sum(decode(to_char(actual_start_date,'HH24'),'09',1,0)) "09"
,        sum(decode(to_char(actual_start_date,'HH24'),'10',1,0)) "10"
,        sum(decode(to_char(actual_start_date,'HH24'),'11',1,0)) "11"
,        sum(decode(to_char(actual_start_date,'HH24'),'12',1,0)) "12"
,        sum(decode(to_char(actual_start_date,'HH24'),'13',1,0)) "13"
,        sum(decode(to_char(actual_start_date,'HH24'),'14',1,0)) "14"
,        sum(decode(to_char(actual_start_date,'HH24'),'15',1,0)) "15"
,        sum(decode(to_char(actual_start_date,'HH24'),'16',1,0)) "16"
,        sum(decode(to_char(actual_start_date,'HH24'),'17',1,0)) "17"
,        sum(decode(to_char(actual_start_date,'HH24'),'18',1,0)) "18"
,        sum(decode(to_char(actual_start_date,'HH24'),'19',1,0)) "19"
,        sum(decode(to_char(actual_start_date,'HH24'),'20',1,0)) "20"
,        sum(decode(to_char(actual_start_date,'HH24'),'21',1,0)) "21"
,        sum(decode(to_char(actual_start_date,'HH24'),'22',1,0)) "22"
,        sum(decode(to_char(actual_start_date,'HH24'),'23',1,0)) "23"
,        count(*)                                                "TOT"
FROM     bolinf.xxfnd_hist_concurrent_requests  fcr
WHERE    fcr.phase_code  = 'C'
AND      actual_start_date between to_date('&vDtIni','dd/mm/yyyy') and to_date('&vDtFim','dd/mm/yyyy')+0.99999
GROUP BY trunc(actual_start_date)
ORDER BY 1
/
set feedback on
set verify on
set linesize 80
set trimspool off

