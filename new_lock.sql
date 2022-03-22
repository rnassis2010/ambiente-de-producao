        set feed off lines 120
        col blocker_sid head "BLOCKER|SID" for 99999
        col blocker_status head "BLOCKER|STATUS" for a8
        col blocker_username head "BLOCKER|USERNAME" for a15 trunc
        col blocker_module head "BLOCKER|MODULE" for a20 trunc
        col blocked_sid head "BLOCKED|SID" for 99999
        col blocked_status head "BLOCKED|STATUS" for a8
        col blocked_username head "BLOCKED|USERNAME" for a15 trunc
        col blocked_module head "BLOCKED|MODULE" for a20 trunc
        select
                blocker_sid, blocker_status, blocker_username,
                substr(
                        blocker_module,
                        instr( replace(blocker_module, '\', '/') , '/' , -1)+1
                ) blocker_module,
                minutos,
                blocked_sid, blocked_status, blocked_username,
                substr(
                        blocked_module,
                        instr( replace(blocked_module, '\', '/') , '/' , -1)+1
                ) blocked_module
        from
(
        select
                sysdate data,
                blocker.sid blocker_sid, pblocker.spid blocker_spid, blocker.status blocker_status, blocker.username blocker_username,
                blocker.osuser blocker_osuser, blocker.logon_time blocker_logon_time, blocker.program blocker_program,
                blocker.module blocker_module, blocker.action blocker_action,
                blocked.sid blocked_sid, pblocked.spid blocked_spid, blocked.status blocked_status, blocked.username blocked_username,
                blocked.osuser blocked_osuser, blocked.logon_time blocked_logon_time, blocked.program blocked_program,
                blocked.module blocked_module, blocked.action blocked_action,
                minutos,
                (
                        select u.user_name
                        from apps.fnd_logins l, apps.fnd_user u
                        where l.user_id = u.user_id and
                        l.pid = pblocker.pid and
                        l.process_spid = pblocker.spid and
                        l.spid = blocker.process and
                        l.user_id = u.user_id and
                        l.end_time is null and
                        pblocker.spid is not null
                ) blocker_user_apps,
                (
                        select u.user_name
                        from apps.fnd_logins l, apps.fnd_user u
                        where l.user_id = u.user_id and
                        l.pid = pblocked.pid and
                        l.process_spid = pblocked.spid and
                        l.spid = blocked.process and
                        l.user_id = u.user_id and
                        l.end_time is null and
                        pblocked.spid is not null
                ) blocked_user_apps
        from
                (
                select /*+ ORDERED */
                   blocker.sid blocker_sid
                ,  blocked.sid blocked_sid
                ,  TRUNC(blocked.ctime/60) minutos
                from (select *
                      from v$lock
                      where block != 0
                      and type = 'TX') blocker
                ,    v$lock        blocked
                ,    v$session     sblocker
                ,    v$session     sblocked
                where blocked.type='TX'
                and blocked.block = 0
                and blocked.id1 = blocker.id1
                and blocker.sid = sblocker.sid
                and blocked.sid = sblocked.sid
                ) bloq
                ,v$session blocker
                ,v$process pblocker
                ,v$session blocked
                ,v$process pblocked
        where
                minutos >= 2 and
                blocker.sid = bloq.blocker_sid and
                blocker.paddr = pblocker.addr and
                blocked.sid = bloq.blocked_sid and
                blocked.paddr = pblocked.addr
) topculock
where trunc(data)=trunc(sysdate) and MINUTOS >= 10;
