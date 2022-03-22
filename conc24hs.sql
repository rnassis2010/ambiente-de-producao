set lines 1000
set pages 1000
column program_name    format a55
column requested_by    format a12
column phase           format a10
column status          format a9
column argument_text   format a180
set markup html on spool on entmap off
spool /export/home/oracle/atg/verifica_conc24hs.html
set heading off
SELECT '<h1 align="center">BANCO DE DADOS DE PRODUCAO DO ORACLE EBUSINESS SUITE - ERP</h1>'||chr(10)||
       '<h2 align="center">CONCURRENTS RODANDO A MAIS DE 24 HS</h2>' FROM dual;
set heading on
select to_char(fcr.actual_start_date,'DD/MM/YYYY-HH24:MI:SS') STARTED
,      fcr.request_id
,      fcp.user_concurrent_program_name PROGRAM_NAME                                                                
,      fu1.user_name REQUESTED_BY                                                                                  
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
,      fcr.argument_text
from   apps.fnd_concurrent_requests fcr
,      apps.fnd_user fu1
,      apps.fnd_concurrent_programs_tl fcp
,      apps.fnd_concurrent_queues_tl fcq
where  fcr.requested_by = fu1.user_id
and    fcp.application_id = fcr.program_application_id
and    fcp.concurrent_program_id = fcr.concurrent_program_id
and    fcp.language = 'PTB'
and    fcr.queue_app_id = fcq.application_id(+)
and    fcr.queue_id = fcq.concurrent_queue_id(+)
and    fcr.phase_code = 'R'
and    fcr.status_code <> 'W'
and    fcr.actual_start_date < sysdate -1
order  by fcr.actual_start_date;
spool off
