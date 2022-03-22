set verify off
set linesize 5000
set pagesize 10000
set trimspool on

accept vRequest_id   prompt "Request ID   : "

col request_id format a10
col sid_serial format a12
col osuser format a10
col sql_id format a13
col module format a20 
col machine format a15
col user_name format a10
col requested_by format a10
col program_name format a30
col phase_code format a12
col status format a12

select to_char(a.request_id) as request_id,
       to_char(d.sid || ',' || d.serial#) as sid_serial,
       d.osuser,
       d.sql_id,
       substr(d.module, 1, 20) as module,
       d.machine,
       to_char(d.logon_time, 'dd/mm/rrrr hh24:mi:ss') as logon_time,
       d.status,
       to_char(a.requested_by) as requested_by,
       u.user_name,       
       DECODE(a.phase_code,
              'R', '(R)Running',
              'P', '(P)Pending',
              'I', '(I)Inactive',
              'C', '(C)Completed',
              a.phase_code) phase,
       DECODE(a.status_code,
              'A', '(A)Waiting',
              'B', '(B)Resuming',
              'C', '(C)Normal',
              'D', '(D)Cancelled',
              'E', '(E)Error',
              'G', '(G)Warning',
              'H', '(H)On Hold',
              'I', '(I)Normal',
              'M', '(M)No Manager',
              'P', '(P)Scheduled',
              'Q', '(Q)Standby',
              'R', '(R)Normal',
              'S', '(S)Suspended',
              'T', '(T)Terminating',
              'U', '(U)Disabled',
              'W', '(W)Paused',
              'X', '(X)Terminated',
              'Z', '(Z)Waiting',
              a.status_code) status,
       e.user_concurrent_program_name as program_name
  from apps.fnd_concurrent_requests    a,
       apps.fnd_user                   u,
       gv$process                      c,
       gv$session                      d,
       apps.fnd_concurrent_programs_tl e
 where (a.request_id = '&vRequest_id' or '&vRequest_id' is null) -- Request_Id do Concurrent
   and a.phase_code = 'R'
   and a.oracle_process_id = c.spid
   and e.application_id = a.program_application_id
   and e.concurrent_program_id = a.concurrent_program_id
   and e.language = 'PTB'
   and c.inst_id = d.inst_id
   and c.addr = d.paddr
   and u.user_id = a.requested_by;
