set pagesize 1000
set linesize 200

alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

column local_tran_id  format a13
column global_tran_id format a26
column state          format a15
column tran_comment   format a12
column os_user        format a8
column os_terminal    format a11
column host           format a25
column db_user        format a7
column commit#        format a14

select local_tran_id
,      global_tran_id
,      state
,      mixed
,      tran_comment
,      fail_time
,      force_time
,      retry_time
,      os_user
,      os_terminal
,      host
,      commit#
from   dba_2pc_pending
order  by fail_time;

column local_tran_id format a13
column in_out        format a6
column database      format a10
column dbuser_owner  format a12
column interface     format a9
column dbid          format a13
column sess#         format 99999
column branch        format a80

select *
from   dba_2pc_neighbors;
