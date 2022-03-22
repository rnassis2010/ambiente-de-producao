set verify off
set linesize 5000
set pagesize 10000
set trimspool on
col user_concurrent_program_name format a60
accept vSID  prompt "SID   : "

select f.request_date, f.request_id, s.sid, s.serial#, s.status, s.username, s.osuser
, DECODE( f.phase_code
, 'R', '(R)Running'
, 'P', '(P)Pending'
, 'I', '(I)Inactive'
, 'C', '(C)Completed'
, f.phase_code) phase
, DECODE( f.status_code
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
, f.status_code) status
, f2.user_concurrent_program_name
from v$process v, v$session s
, applsys.fnd_concurrent_requests f
, applsys.fnd_concurrent_programs_tl f2
where 1=1
and s.paddr=v.addr
and f.oracle_process_id=v.spid
and (trunc(f.request_date)=trunc(sysdate) or trunc(f.request_date)=trunc(sysdate-1))
and sid='&vSID'
and f2.application_id=f.program_application_id
and f2.concurrent_program_id=f.concurrent_program_id;
