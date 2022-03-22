set feedback off
set linesize 160
set pagesize 50

column "DIA" format a10
column "00"  format a3 justify right
column "01"  format a3 justify right
column "02"  format a3 justify right
column "03"  format a3 justify right
column "04"  format a3 justify right
column "05"  format a3 justify right
column "06"  format a3 justify right
column "07"  format a3 justify right
column "08"  format a3 justify right
column "09"  format a3 justify right
column "10"  format a3 justify right
column "11"  format a3 justify right
column "12"  format a3 justify right
column "13"  format a3 justify right
column "14"  format a3 justify right
column "15"  format a3 justify right
column "16"  format a3 justify right
column "17"  format a3 justify right
column "18"  format a3 justify right
column "19"  format a3 justify right
column "20"  format a3 justify right
column "21"  format a3 justify right
column "22"  format a3 justify right
column "23"  format a3 justify right
column "24"  format a3 justify right

column "TOT" format 9999 justify right

--alter session set nls_date_format='DD/MM/YYYY';

SELECT   to_char(trunc(first_time),'dd/mm/yyyy')                               "DIA"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'00',1,0)),'999')) "00"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'01',1,0)),'999')) "01"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'02',1,0)),'999')) "02"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'03',1,0)),'999')) "03"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'04',1,0)),'999')) "04"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'05',1,0)),'999')) "05"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'06',1,0)),'999')) "06"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'07',1,0)),'999')) "07"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'08',1,0)),'999')) "08"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'09',1,0)),'999')) "09"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'10',1,0)),'999')) "10"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'11',1,0)),'999')) "11"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'12',1,0)),'999')) "12"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'13',1,0)),'999')) "13"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'14',1,0)),'999')) "14"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'15',1,0)),'999')) "15"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'16',1,0)),'999')) "16"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'17',1,0)),'999')) "17"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'18',1,0)),'999')) "18"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'19',1,0)),'999')) "19"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'20',1,0)),'999')) "20"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'21',1,0)),'999')) "21"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'22',1,0)),'999')) "22"
,        trim(to_char(sum(decode(to_char(first_time,'HH24'),'23',1,0)),'999')) "23"
,        count(*)                                                        "TOT"
FROM     v$log_history
WHERE    trunc(first_time) > trunc(sysdate)-10
GROUP BY trunc(first_time)
ORDER BY 1
/
set feedback on
set linesize 80

