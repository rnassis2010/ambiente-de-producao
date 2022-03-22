spool asm_info-ERP-Z3.html
set pagesize 1000
set linesize 250
set feedback off
col bytes format 999,999,999,999
col space format 999,999,999,999
col gn format 999
col name format a20
col au format 99999999
col state format a12
col type format a12
col total_mb format 999,999,999
col free_mb format 999,999,999
col od format 999
col compatibility format a12
col dn format 999
col mount_status format a12
col header_status format a12
col mode_status format a12
col mode format a12
col failgroup format a20
col label format a12
col path format a45
col path1 format a40
col path2 format a40
col path3 format a40
col bytes_read format 999,999,999,999,999
col bytes_written format 999,999,999,999,999
col cold_bytes_read format 999,999,999,999,999
col cold_bytes_written format 999,999,999,999,999

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS' ;

select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS' ) current_time from dual;
select group_number gn, name, allocation_unit_size au, state, type, total_mb, free_mb, offline_disks od, compatibility from v$asm_diskgroup;
select group_number gn,disk_number dn, mount_status, header_status,mode_status,state, total_mb, free_mb,name, failgroup, label, path,create_date, mount_date from v$asm_disk order by group_number, disk_number;

break on g_n skip 1
break on failgroup skip 1
compute sum of t_mb f_mb on failgroup
compute count of failgroup on failgroup

select g.group_number g_n,g.disk_number d_n,g.name , g.path , g.total_mb t_mb,g.free_mb f_mb,g.failgroup from v$asm_disk g order by g_n, failgroup, d_n;

SET MARKUP HTML ON
set echo on


select 'THIS ASM REPORT WAS GENERATED AT: ==)> ' , sysdate " " from dual;


select 'HOSTNAME ASSOCIATED WITH THIS ASM INSTANCE: ==)> ' , MACHINE " " from v$session where program like '%SMON%';

select * from v$asm_diskgroup;

SELECT * FROM V$ASM_DISK ORDER BY GROUP_NUMBER,DISK_NUMBER;

SELECT * FROM V$ASM_CLIENT;

select * from V$ASM_ATTRIBUTE;

select * from v$asm_operation;

select * from v$version;

show parameter

show sga

spool off

exit

