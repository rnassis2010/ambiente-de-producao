select /*+ RULE */
       fcwr.CONCURRENT_QUEUE_NAME,
         fcq.TARGET_PROCESSES Target,
         sum (decode(PHASE_CODE,'R',1,0)) Running,
         sum (decode(PHASE_CODE,'P',1,0)) Pending,
         fcq.sleep_seconds sleep,
         fcq.cache_size,
         fcq.node_name node
  from  apps.FND_CONCURRENT_WORKER_REQUESTS fcwr,
       apps.fnd_concurrent_queues_vl fcq
 where fcwr.CONCURRENT_QUEUE_NAME = fcq.CONCURRENT_QUEUE_NAME
and   fcwr.HOLD_FLAG != 'Y'
   AND   fcwr.REQUESTED_START_DATE <= SYSDATE
 AND   fcq.enabled_flag = 'Y'
 AND   fcq.control_code is null
group by fcwr.CONCURRENT_QUEUE_NAME,fcq.TARGET_PROCESSES,sleep_seconds,fcq.cache_size,node_name;

