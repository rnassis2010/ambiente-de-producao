set lines 1000
set pages 1000
select  request_id, phase_code, status_code, actual_start_date, actual_completion_date, completion_text, argument_text
from apps.FND_CONCURRENT_REQUESTS
-- where concurrent_program_id = 49330
order by request_date desc;

