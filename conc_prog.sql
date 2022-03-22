set lines 1000
set pages 1000

select      DECODE( a.phase_code
             , 'R', '(R)Running'
             , 'P', '(P)Pending'
             , 'I', '(I)Inactive'
             , 'C', '(C)Completed'
             , a.phase_code) phase
            , DECODE( a.status_code
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
             , a.status_code) status,
        b.user_concurrent_program_name, a.argument_text, c.user_name, a.request_date, a.last_update_date, a.requested_start_date,
        a.resubmit_interval, a.resubmit_interval_unit_code, a.resubmit_interval_type_code, a.resubmit_end_date,a.request_id
from    apps.fnd_concurrent_requests a,
        apps.fnd_concurrent_programs_tl b,
        apps.fnd_user c
where   a.concurrent_program_id = b.concurrent_program_id
and     a.requested_by = c.user_id
and     b.language = 'US'
and     a.phase_code = 'P'
and     status_code = 'Q'
--and     requested_by in ('0','19193','6083','19638')  ;
--and     a.concurrent_program_id = '38121'
--and c.user_name = 'CHUNGARO'
order by 8 ;
