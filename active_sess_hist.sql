set feedback off
set linesize 250
set pagesize 50
set trimspool on

column "DIA" format a10
column "00"  format a6 justify right
column "01"  format a6 justify right
column "02"  format a6 justify right
column "03"  format a6 justify right
column "04"  format a6 justify right
column "05"  format a6 justify right
column "06"  format a6 justify right
column "07"  format a6 justify right
column "08"  format a6 justify right
column "09"  format a6 justify right
column "10"  format a6 justify right
column "11"  format a6 justify right
column "12"  format a6 justify right
column "13"  format a6 justify right
column "14"  format a6 justify right
column "15"  format a6 justify right
column "16"  format a6 justify right
column "17"  format a6 justify right
column "18"  format a6 justify right
column "19"  format a6 justify right
column "20"  format a6 justify right
column "21"  format a6 justify right
column "22"  format a6 justify right
column "23"  format a6 justify right
column "24"  format a6 justify right

column "TOT" format 999999 justify right

--alter session set nls_date_format='DD/MM/YYYY';

SELECT   to_char(trunc(sample_time),'dd/mm/yyyy')                              "DIA"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'00',1,0)),'999999')) "00"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'01',1,0)),'999999')) "01"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'02',1,0)),'999999')) "02"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'03',1,0)),'999999')) "03"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'04',1,0)),'999999')) "04"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'05',1,0)),'999999')) "05"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'06',1,0)),'999999')) "06"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'07',1,0)),'999999')) "07"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'08',1,0)),'999999')) "08"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'09',1,0)),'999999')) "09"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'10',1,0)),'999999')) "10"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'11',1,0)),'999999')) "11"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'12',1,0)),'999999')) "12"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'13',1,0)),'999999')) "13"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'14',1,0)),'999999')) "14"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'15',1,0)),'999999')) "15"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'16',1,0)),'999999')) "16"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'17',1,0)),'999999')) "17"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'18',1,0)),'999999')) "18"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'19',1,0)),'999999')) "19"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'20',1,0)),'999999')) "20"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'21',1,0)),'999999')) "21"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'22',1,0)),'999999')) "22"
,        trim(to_char(sum(decode(to_char(sample_time,'HH24'),'23',1,0)),'999999')) "23"
,        count(*)                                                        "TOT"
FROM     dba_hist_active_sess_history
WHERE    trunc(sample_time) > trunc(sysdate)-10
GROUP BY trunc(sample_time)
ORDER BY 1
/
set feedback on
set linesize 80

