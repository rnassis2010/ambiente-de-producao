set lines 200
set pages 50
col CONTAINER_NAME format a40
col procid format a6
col TARGET format 999999
col ACTUAL format 999999
col COMPONENT_NAME format a50
col STARTUP_MODE format a13
col COMPONENT_STATUS format a20
select fcq.USER_CONCURRENT_QUEUE_NAME Container_Name,
DECODE(fcp.OS_PROCESS_ID,NULL,'Not Running',fcp.OS_PROCESS_ID) PROCID,
fcq.MAX_PROCESSES TARGET,
fcq.RUNNING_PROCESSES ACTUAL,
fcq.ENABLED_FLAG ENABLED,
fsc.COMPONENT_NAME,
fsc.STARTUP_MODE,
fsc.COMPONENT_STATUS
from APPS.FND_CONCURRENT_QUEUES_VL fcq,
APPS.FND_CP_SERVICES fcs, 
APPS.FND_CONCURRENT_PROCESSES fcp, 
fnd_svc_components fsc
where fcq.MANAGER_TYPE = fcs.SERVICE_ID
and fcs.SERVICE_HANDLE = 'FNDCPGSC'
and fsc.concurrent_queue_id = fcq.concurrent_queue_id(+)
and fcq.concurrent_queue_id = fcp.concurrent_queue_id(+)
and fcp.process_status_code(+) = 'A'
and fcq.USER_CONCURRENT_QUEUE_NAME = 'Workflow Mailer Service';
