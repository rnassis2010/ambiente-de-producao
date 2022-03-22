SELECT a.request_id, d.sid, d.serial# ,d.osuser,d.process,c.SPID ,d.inst_id
FROM apps.fnd_concurrent_requests a,
apps.fnd_concurrent_processes b,
gv$process c,
gv$session d
WHERE a.controlling_manager = b.concurrent_process_id
AND c.pid = b.oracle_process_id
AND b.session_id=d.audsid
AND d.sid=&sid
and d.serial#=&serial
AND a.phase_code = 'R';
