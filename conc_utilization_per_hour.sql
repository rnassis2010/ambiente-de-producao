--  FILE:   fnd_cm_hrly_sum.sql
--
--  AUTHOR: Andy Rivenes, andy@appsdba.com, www.appsdba.com
--          Neil Jensen, neil@appsdba.com
--          Copyright (C) 2006 AppsDBA Consulting
--
--  DATE:   01/12/2006
--
--  DESCRIPTION:
--          Query to summarize concurrent manager usage by
--          hourly interval.
--
--  MODIFICATIONS:
--
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
--
SET LINESIZE 200;
SET TRIMSpool on;
SET PAGES 9999;
SET HEAD on;
--
SET HEAD off;
ACCEPT enddt  PROMPT 'ENTER the date (ex: 01-DEC-05) > ' ;
PROMPT ;
SET HEAD on;
--
SPOOL fnd_cm_hrly_sum.txt
--
PROMPT Concurrent Program Profile for &&enddt ;
--
COLUMN rtime        HEADING 'Date'              FORMAT A11;
COLUMN qn           HEADING 'Queue|Name'        FORMAT A20;
COLUMN cnt          HEADING 'Total|Jobs'        FORMAT 999,990;
COLUMN cntt         HEADING 'Total|Jobs'        FORMAT 999,990;
COLUMN tott         HEADING 'Total|Time(Min)'   FORMAT 9990.99;
COLUMN mint         HEADING 'Min|Time(Min)'     FORMAT 9990.99;
COLUMN avgt         HEADING 'Avg|Time(Min)'     FORMAT 9,990.99;
COLUMN maxt         HEADING 'Max|Time(Min)'     FORMAT 99,990.99;
COLUMN avgd	    HEADING 'Avg|Delay(Min)'	FORMAT 999.999;
COLUMN maxd	    HEADING 'Max|Delay(Min)'	FORMAT 999.999;
--
BREAK ON rtime SKIP 1 ON REPORT
--
SELECT 
       TO_CHAR(r.ACTUAL_START_DATE,'MM/DD/YY HH24') rtime,
       q.concurrent_queue_name qn,
       COUNT(r.REQUEST_ID) cnt,
       SUM(ROUND((r.ACTUAL_COMPLETION_DATE - r.ACTUAL_START_DATE)*(60*24),2)) tott,
       MIN(ROUND((r.ACTUAL_COMPLETION_DATE - r.ACTUAL_START_DATE)*(60*24),2)) mint,
       AVG(ROUND((r.ACTUAL_COMPLETION_DATE - r.ACTUAL_START_DATE)*(60*24),2)) avgt,
       MAX(ROUND((r.ACTUAL_COMPLETION_DATE - r.ACTUAL_START_DATE)*(60*24),2)) maxt,
       AVG(ROUND((r.ACTUAL_START_DATE - r.REQUESTED_START_DATE)*(60*24),3)) avgd,
       MAX(ROUND((r.ACTUAL_START_DATE - r.REQUESTED_START_DATE)*(60*24),3)) maxd
  FROM fnd_concurrent_requests r,
       fnd_concurrent_processes p,
       fnd_concurrent_programs cp,
       fnd_concurrent_queues q,
       fnd_concurrent_programs_tl cptl
 WHERE TRUNC(r.ACTUAL_START_DATE) = TO_DATE(UPPER('&&enddt'),'DD-MON-YY')
  AND r.phase_code = 'C'
  AND R.controlling_manager = P.concurrent_process_id
  AND p.concurrent_queue_id = q.concurrent_queue_id
  AND p.queue_application_id = q.application_id
  AND r.program_application_id = cp.application_id
  AND r.concurrent_program_id = cp.concurrent_program_id
  AND cp.application_id = cptl.application_id
  AND cp.concurrent_program_id = cptl.concurrent_program_id
GROUP BY
  TO_CHAR(r.ACTUAL_START_DATE,'MM/DD/YY HH24'), 
  q.concurrent_queue_name
ORDER BY
  rtime,
  q.concurrent_queue_name
/

