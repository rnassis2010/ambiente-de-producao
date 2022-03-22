set feedback off
set linesize 160
set pagesize 1000

column "DIA" format a10
column "00"  format a4 justify right
column "01"  format a4 justify right
column "02"  format a4 justify right
column "03"  format a4 justify right
column "04"  format a4 justify right
column "05"  format a4 justify right
column "06"  format a4 justify right
column "07"  format a4 justify right
column "08"  format a4 justify right
column "09"  format a4 justify right
column "10"  format a4 justify right
column "11"  format a4 justify right
column "12"  format a4 justify right
column "13"  format a4 justify right
column "14"  format a4 justify right
column "15"  format a4 justify right
column "16"  format a4 justify right
column "17"  format a4 justify right
column "18"  format a4 justify right
column "19"  format a4 justify right
column "20"  format a4 justify right
column "21"  format a4 justify right
column "22"  format a4 justify right
column "23"  format a4 justify right
column "24"  format a4 justify right

column "TOT" format 99999 justify right

--alter session set nls_date_format='DD/MM/YYYY';

accept vQueueName prompt "Queue Name [%] : "

column user_concurrent_queue_name format a80

select user_concurrent_queue_name
from   apps.fnd_concurrent_queues_vl
where  ( upper(user_concurrent_queue_name) like upper('%&vQueueName%') or '&vQueueName' is null )
and    enabled_flag = 'Y'
order  by 1;

prompt
prompt ***************************
prompt * Confirme o nome da Fila *
prompt ***************************
accept vQueueName prompt "Queue Name : "

prompt
prompt **
prompt ** Concurrents executados e concluidos com sucesso (por hora)
prompt **
SELECT   to_char(trunc(actual_start_date),'dd/mm/yyyy')                               "DIA"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'00',1,0)),'9999')) "00"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'01',1,0)),'9999')) "01"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'02',1,0)),'9999')) "02"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'03',1,0)),'9999')) "03"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'04',1,0)),'9999')) "04"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'05',1,0)),'9999')) "05"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'06',1,0)),'9999')) "06"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'07',1,0)),'9999')) "07"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'08',1,0)),'9999')) "08"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'09',1,0)),'9999')) "09"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'10',1,0)),'9999')) "10"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'11',1,0)),'9999')) "11"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'12',1,0)),'9999')) "12"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'13',1,0)),'9999')) "13"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'14',1,0)),'9999')) "14"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'15',1,0)),'9999')) "15"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'16',1,0)),'9999')) "16"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'17',1,0)),'9999')) "17"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'18',1,0)),'9999')) "18"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'19',1,0)),'9999')) "19"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'20',1,0)),'9999')) "20"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'21',1,0)),'9999')) "21"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'22',1,0)),'9999')) "22"
,        trim(to_char(sum(decode(to_char(actual_start_date,'HH24'),'23',1,0)),'9999')) "23"
,        count(*)                                                        "TOT"
FROM     apps.fnd_concurrent_requests  fcr
,        apps.fnd_concurrent_processes fcp
,        apps.fnd_concurrent_queues_vl fcq
WHERE    fcr.controlling_manager = fcp.concurrent_process_id
AND      fcr.phase_code  = 'C'
AND      fcr.status_code = 'C'
AND      fcp.queue_application_id       = fcq.application_id
AND      fcp.concurrent_queue_id        = fcq.concurrent_queue_id
AND      fcq.user_concurrent_queue_name = nvl('&vQueueName','X')
GROUP BY trunc(actual_start_date)
ORDER BY 1
/
prompt
prompt **
prompt ** Concurrents submetidos e concluidos - com sucesso ou não (por hora)
prompt **
SELECT   to_char(trunc(request_date),'dd/mm/yyyy')                               "DIA"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'00',1,0)),'9999')) "00"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'01',1,0)),'9999')) "01"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'02',1,0)),'9999')) "02"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'03',1,0)),'9999')) "03"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'04',1,0)),'9999')) "04"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'05',1,0)),'9999')) "05"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'06',1,0)),'9999')) "06"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'07',1,0)),'9999')) "07"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'08',1,0)),'9999')) "08"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'09',1,0)),'9999')) "09"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'10',1,0)),'9999')) "10"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'11',1,0)),'9999')) "11"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'12',1,0)),'9999')) "12"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'13',1,0)),'9999')) "13"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'14',1,0)),'9999')) "14"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'15',1,0)),'9999')) "15"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'16',1,0)),'9999')) "16"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'17',1,0)),'9999')) "17"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'18',1,0)),'9999')) "18"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'19',1,0)),'9999')) "19"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'20',1,0)),'9999')) "20"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'21',1,0)),'9999')) "21"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'22',1,0)),'9999')) "22"
,        trim(to_char(sum(decode(to_char(request_date,'HH24'),'23',1,0)),'9999')) "23"
,        count(*)                                                        "TOT"
FROM     apps.fnd_concurrent_requests  fcr
,        apps.fnd_concurrent_processes fcp
,        apps.fnd_concurrent_queues_vl fcq
WHERE    fcr.controlling_manager = fcp.concurrent_process_id
AND      fcr.phase_code  = 'C'
--AND      fcr.status_code = 'C'
AND      fcp.queue_application_id       = fcq.application_id
AND      fcp.concurrent_queue_id        = fcq.concurrent_queue_id
AND      fcq.user_concurrent_queue_name = nvl('&vQueueName','X')
GROUP BY trunc(request_date)
ORDER BY 1
/
set feedback on
set linesize 80

