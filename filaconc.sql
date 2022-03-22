set pages 100
Col fila For A45 word_wrap
col real for 999999
col meta for 999999
col exec for 999999
col pend for 999999

compute sum of real on report
compute sum of meta on report
compute sum of exec on report
compute sum of pend on report
break on report

select  /*+ RULE */
	fcq.user_Concurrent_Queue_Name fila,
	fcq.running_processes real,
	fcq.max_processes meta,
	count(case when fcw.Phase_Code = 'R' then fcw.REQUEST_ID else null end) Exec,
	count(case when fcw.Phase_Code = 'P' then fcw.REQUEST_ID else null end) Pend
from
	(
	-- Esta query é da tela que mostra as solicitações de uma fila
	-- (Administrar Gerenciadores Concorrentes)
	SELECT 	
		CONCURRENT_QUEUE_ID, QUEUE_APPLICATION_ID, REQUEST_ID, PHASE_CODE, STATUS_CODE, 
		ARGUMENT_TEXT, REQUESTED_BY, DESCRIPTION, CONCURRENT_PROGRAM_ID, 
		PROGRAM_APPLICATION_ID
	FROM 
		apps.FND_CONCURRENT_WORKER_REQUESTS 
	WHERE 
		(Phase_Code = 'P' or Phase_Code = 'R') and hold_flag != 'Y' and 
		Requested_Start_Date <= SYSDATE 
	) fcw,
	apps.Fnd_Concurrent_Queues_VL Fcq
where
	fcq.Concurrent_Queue_Id = fcw.Concurrent_Queue_Id	And
	fcq.Application_Id      = fcw.Queue_Application_Id	And
	fcq.enabled_flag = 'Y'
group by
	fcq.user_Concurrent_Queue_Name,
	fcq.running_processes,
	fcq.max_processes
--	fcw.CONCURRENT_QUEUE_ID, fcw.QUEUE_APPLICATION_ID
order by
	fila
/

