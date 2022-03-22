column message_type format a12
column begin_date   format a10
column mail_status  format a11
select message_type
,      trunc(begin_date) begin_date
,      status
,      mail_status
,      count(*) qtd
from   apps.wf_notifications
where  trunc(begin_date) >= trunc(sysdate)-2
and    status             = 'OPEN'
and    message_type      in ('POAPPRV','REQAPPRV')
group  by message_type
,         trunc(begin_date)
,         status
,         mail_status
order  by message_type
,         trunc(begin_date)
,         status
/

