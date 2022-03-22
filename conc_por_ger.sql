COL "Queue" FORMAT A70
COL fcqv.concurrent_queue_name FORMAT A30
COL TARGET_PROCESS	HEADING "Target Node"

Select RPAD(fcqv.user_concurrent_queue_name , 30, ' ')
       || '   (' || fcqv.concurrent_queue_name || ')' "Queue"
     , fcqv.target_processes target_process
     , fcqv.running_processes "Actual"
     , NVL(r.qtde,0) "Running"
     , NVL(p.qtde,0) "Pending"
  From apps.fnd_concurrent_queues_vl fcqv
     , (Select   concurrent_queue_id, Count ( * ) qtde
         From apps.fnd_concurrent_worker_requests 
        Where phase_code = 'R'
          And hold_flag != 'Y'
          And requested_start_date <= SYSDATE
     Group By concurrent_queue_id) r
     ,(Select   concurrent_queue_id, Count ( * ) qtde
         From apps.fnd_concurrent_worker_requests 
        Where phase_code = 'P'
          And hold_flag != 'Y'
          And requested_start_date <= SYSDATE
     Group By concurrent_queue_id) p
 Where fcqv.concurrent_queue_id = r.concurrent_queue_id (+)
   And fcqv.concurrent_queue_id = p.concurrent_queue_id (+)
   And fcqv.enabled_flag = 'Y'
   And (r.qtde > 0 OR p.qtde > 0)
 order by fcqv.user_concurrent_queue_name;

