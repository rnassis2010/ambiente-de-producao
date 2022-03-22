set feedback off
set linesize 300
set pagesize 1000
set trimspool on

column "DIA" format a10
column "00"  format a5 justify right
column "01"  format a5 justify right
column "02"  format a5 justify right
column "03"  format a5 justify right
column "04"  format a5 justify right
column "05"  format a5 justify right
column "06"  format a5 justify right
column "07"  format a5 justify right
column "08"  format a5 justify right
column "09"  format a5 justify right
column "10"  format a5 justify right
column "11"  format a5 justify right
column "12"  format a5 justify right
column "13"  format a5 justify right
column "14"  format a5 justify right
column "15"  format a5 justify right
column "16"  format a5 justify right
column "17"  format a5 justify right
column "18"  format a5 justify right
column "19"  format a5 justify right
column "20"  format a5 justify right
column "21"  format a5 justify right
column "22"  format a5 justify right
column "23"  format a5 justify right
column "24"  format a5 justify right

column "TOT" format 999999 justify right

--alter session set nls_date_format='DD/MM/YYYY';

prompt
prompt **
prompt ** Concurrents executados no dia anterior por hora
prompt **
SELECT   to_char(trunc(actual_start_date),'dd/mm/yyyy')                               "DIA"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'00',1,0)),'99999')) "00"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'01',1,0)),'99999')) "01"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'02',1,0)),'99999')) "02"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'03',1,0)),'99999')) "03"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'04',1,0)),'99999')) "04"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'05',1,0)),'99999')) "05"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'06',1,0)),'99999')) "06"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'07',1,0)),'99999')) "07"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'08',1,0)),'99999')) "08"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'09',1,0)),'99999')) "09"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'10',1,0)),'99999')) "10"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'11',1,0)),'99999')) "11"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'12',1,0)),'99999')) "12"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'13',1,0)),'99999')) "13"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'14',1,0)),'99999')) "14"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'15',1,0)),'99999')) "15"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'16',1,0)),'99999')) "16"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'17',1,0)),'99999')) "17"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'18',1,0)),'99999')) "18"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'19',1,0)),'99999')) "19"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'20',1,0)),'99999')) "20"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'21',1,0)),'99999')) "21"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'22',1,0)),'99999')) "22"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'23',1,0)),'99999')) "23"
,        count(*)                                                        "TOT"
FROM     apps.fnd_concurrent_requests  fcr
WHERE    fcr.phase_code  = 'C'
AND      trunc(actual_start_date) = trunc(sysdate)-1
GROUP BY trunc(actual_start_date)
ORDER BY 1
/
set feedback on
set linesize 80

