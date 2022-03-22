set linesize 600
@@filaconc

prompt
accept fila prompt 'Fila: '

col concid for 9999999
col reqid for 9999999999
col programa for a50
col abrev for a25 heading "NOME ABREVIADO"
col descricao for a40
col executavel for a15
col user_name for a25
col parametros for a100
column fase for a5 heading 'FASE'
column status for a11 heading 'STATUS'

break on fila skip 1

prompt ==================================================
prompt TIPOS DE CONCURRENTS NAS FILAS "%&fila%"
prompt ==================================================

col prg head "PROGRAMA" for a60 trunc
select
   fcq.user_Concurrent_Queue_Name fila,
   cp.USER_CONCURRENT_PROGRAM_NAME prg,
   fcw.CONCURRENT_PROGRAM_ID concID,
   count(1) qtd,
   sum(case when phase_code = 'R' then 1 else 0 end) qtd_runn,
   min(requested_start_date) min_req_date,
   max(requested_start_date) max_req_date,
   max(actual_start_date) max_act_date,
   min(actual_start_date) min_act_date
from
   (
   SELECT
           *
   FROM
           apps.FND_CONCURRENT_WORKER_REQUESTS
   WHERE
           (Phase_Code = 'P' or Phase_Code = 'R') and hold_flag != 'Y' and
           Requested_Start_Date <= SYSDATE
   order by
           Priority, Priority_Request_ID, Request_ID
   ) fcw,
   apps.Fnd_Concurrent_Queues_VL Fcq,
   apps.fnd_concurrent_programs_vl cp, apps.fnd_executables_vl ex,
   apps.fnd_user fu
where
   ex.EXECUTABLE_ID = cp.EXECUTABLE_ID
   and cp.CONCURRENT_PROGRAM_ID = fcw.CONCURRENT_PROGRAM_ID
   and fcw.REQUESTED_BY = fu.USER_ID
   and fcq.Concurrent_Queue_Id = fcw.Concurrent_Queue_Id
   and fcq.Application_Id      = fcw.Queue_Application_Id
   and fcq.enabled_flag = 'Y'
   and upper(fcq.user_Concurrent_Queue_Name) like upper('%&fila%')
group by
   fcq.user_Concurrent_Queue_Name,
   cp.USER_CONCURRENT_PROGRAM_NAME,
   fcw.CONCURRENT_PROGRAM_ID
order by
   fila, qtd desc
/


prompt ==================================================
prompt CONCURRENTS NAS FILAS "%&fila%"
prompt ==================================================

col INC_COM like REQID

select 
	fcq.user_Concurrent_Queue_Name fila,
	fcw.request_id reqid, 
	--case 
        --  when fcq.Concurrent_Queue_Id = 4 /*Fila Conflict Resolution Manager*/ then
        --       (select RUN_REQID from EDU_CONCURRENTS_CONFLITO where INC_REQID = fcw.request_id)
        --  else to_number(null)
        --  end INC_COM,
	decode(phase_code,
		'R','Runn',
		'P','Pend',
		'C','Compl',
		'I','Inact',
		phase_code) fase,
	decode(status_code,
		'A','Waiting',
		'B','Resuming',
		'C','Normal',
		'D','Cancelled',
		'E','Error',
		'F','Scheduled',
		'G','Warning',
		'H','On Hold',
		'I','Programado',
		'M','No Mgr',
		'Q','StandBy',
		'R','Normal',
		'S','Suspend',
		'T','Terminating',
		'U','Disabled',
		'W','Paused',
		'X','Terminated',
		'Z','Waiting',
		status_code) status,
	fu.USER_NAME username, 
	cp.USER_CONCURRENT_PROGRAM_NAME programa, ex.executable_name executavel,
	fcw.CONCURRENT_PROGRAM_ID concID,
	ACTUAL_START_DATE start_date, ACTUAL_COMPLETION_DATE end_date, 
	REQUESTED_START_DATE REQ_START_DATE,
	fcw.ARGUMENT_TEXT Parametros
from
	(
	-- Esta query é baseada na tela que mostra as solicitações de uma fila
	-- (Administrar Gerenciadores Concorrentes)
	-- ver filaconc.sql
	SELECT 	
		*
	FROM 
		apps.FND_CONCURRENT_WORKER_REQUESTS
	WHERE 
		(Phase_Code = 'P' or Phase_Code = 'R') and hold_flag != 'Y' and 
		Requested_Start_Date <= SYSDATE 
	--	AND ('' IS NULL OR ('' = 'B' AND PHASE_CODE = 'R' AND STATUS_CODE IN ('I',  'Q'))) 
	--	and '1' in (0, 1, 4) and (CONCURRENT_QUEUE_ID=1127) and (QUEUE_APPLICATION_ID=0) 
	order by 
		Priority, Priority_Request_ID, Request_ID
	) fcw,
	apps.Fnd_Concurrent_Queues_VL Fcq,
	apps.fnd_concurrent_programs_vl cp, apps.fnd_executables_vl ex,
	apps.fnd_user fu
where 
	ex.EXECUTABLE_ID = cp.EXECUTABLE_ID
	and cp.CONCURRENT_PROGRAM_ID = fcw.CONCURRENT_PROGRAM_ID
	and fcw.REQUESTED_BY = fu.USER_ID
	and fcq.Concurrent_Queue_Id = fcw.Concurrent_Queue_Id
	and fcq.Application_Id      = fcw.Queue_Application_Id
	and fcq.enabled_flag = 'Y'
	and upper(fcq.user_Concurrent_Queue_Name) like upper('%&fila%')
/

clear breaks

