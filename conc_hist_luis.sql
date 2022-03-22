set verify off
set linesize 5000
set pagesize 10000
set trimspool on

accept vRequest_id   prompt "Request ID   : "
accept vProgram_id   prompt "Program ID   : "
accept vPhase_code   prompt "Phase_code   : "
accept vStatus_code  prompt "Status_code  : "
accept vRequested_by prompt "Requested_by : "

column program_name    format a50
column requested_by    format a15
column phase           format a12
column status          format a14
column last_updated_by format a20
column argument_text   format a40

alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

select --fcq.concurrent_queue_name        queue
       fcr.concurrent_program_id        program_id
,      fcr.request_id
,      fcp.user_concurrent_program_name                                                                PROGRAM_NAME
--,      fcr.parent_request_id
,      fu1.user_name                                                                                   REQUESTED_BY
--,      fcr.requested_start_date                                                                        REQUESTED_START_DATE
,      DECODE( fcr.phase_code
             , 'R', '(R)Running'
             , 'P', '(P)Pending'
             , 'I', '(I)Inactive'
             , 'C', '(C)Completed'
             , fcr.phase_code) phase
,      DECODE( fcr.status_code
             , 'A', '(A)Waiting'
             , 'B', '(B)Resuming'
             , 'C', '(C)Normal'
             , 'D', '(D)Cancelled'
             , 'E', '(E)Error'
             , 'G', '(G)Warning'
             , 'H', '(H)On Hold'
             , 'I', '(I)Normal'
             , 'M', '(M)No Manager'
             , 'P', '(P)Scheduled'
             , 'Q', '(Q)Standby'
             , 'R', '(R)Normal'
             , 'S', '(S)Suspended'
             , 'T', '(T)Terminating'
             , 'U', '(U)Disabled'
             , 'W', '(W)Paused'
             , 'X', '(X)Terminated'
             , 'Z', '(Z)Waiting'
             , fcr.status_code) status
--,      fcr.requested_start_date                                                                      REQUESTED_START_DATE
,      fcr.actual_start_date                                                                           STARTED
,      fcr.actual_completion_date                                                                      COMPLETED
,      CASE
         WHEN fcr.actual_completion_date IS NULL THEN NULL
         ELSE
           TO_CHAR(extract(hour   from numtodsinterval(((fcr.actual_completion_date - fcr.actual_start_date)*86400),'SECOND')),'FM09')||'h'||
           TO_CHAR(extract(minute from numtodsinterval(((fcr.actual_completion_date - fcr.actual_start_date)*86400),'SECOND')),'FM09')||'min'||
           TO_CHAR(extract(second from numtodsinterval(((fcr.actual_completion_date - fcr.actual_start_date)*86400),'SECOND')),'FM09')||'s'
       END TIME
--,      (fcr.actual_completion_date - fcr.actual_start_date)*86400                                      TIME
--,      fcr.requested_start_date
,      fcr.argument_text
--,      fcr.oracle_process_id
--,      fcr.os_process_id
-- from   apps.fnd_concurrent_requests    fcr
from   bolinf.xxfnd_hist_concurrent_requests    fcr
,      apps.fnd_user                   fu1
,      apps.fnd_concurrent_programs_tl fcp
,      apps.fnd_concurrent_queues_tl   fcq
where  fcr.requested_by           = fu1.user_id
and    fcp.application_id         = fcr.program_application_id
and    fcp.concurrent_program_id  = fcr.concurrent_program_id
and    fcp.language               = 'PTB'
and    fcr.queue_app_id           = fcq.application_id(+)
and    fcr.queue_id               = fcq.concurrent_queue_id(+)
and    ( fcr.request_id               = '&vRequest_id'          or '&vRequest_id'   is null )
and    ( fcr.concurrent_program_id    = '&vProgram_id'          or '&vProgram_id'   is null )
and    ( fcr.phase_code            like upper('&vPhase_code')   or '&vPhase_code'   is null )
and    ( fcr.status_code           like upper('&vStatus_code')  or '&vStatus_code'  is null )
and    ( fu1.user_name             like upper('&vRequested_by') or '&vRequested_by' is null )
order  by fcr.actual_start_date
/

