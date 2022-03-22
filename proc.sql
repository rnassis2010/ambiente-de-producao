set echo off
set term on
set verify off
set pagesize 33
set pause on 
set linesize 150
set feedback on
set head on

undefine status
undefine osuser
undefine usuario
undefine no_processo
undefine os_user

column SID    	format 9999999   trunc justify LEFT
column SPID    	format 99999 trunc justify LEFT
column STATUS   format a8
column LOGON   format a15
column OSUSER	format A10 trunc
column O_USER	format A15 trunc
column U_USER	format A10 trunc
column SERIAL#	format 99999 trunc
column TERMINAL	format A5 trunc
column PROGRAM	format A30 trunc
column BACKGROUND	format A1
column JOB      format a9
#column SERVER   format a5 trunc

break on o_user skip 1

select	s.sid,
        to_number(p.SPID) SPID,
        s.osuser OSUSER,
	'U:' || p.USERNAME u_user,
        'O:' || lower(s.USERNAME) o_user,
	        s.status,
       to_char(s.logon_time,'dd-mon-rr hh24:mi') LOGON,
        substr(p.program,18,4) PRT,
	upper(decode(nvl(s.command, 0),
		0,	'--------',
		1,	'Create Table',
		2,	'Insert...',
		3,	'Select...',
		4,	'Create Cluster',
		5,	'Alter Cluster',
		6,	'Update...',
		7,	'Delete...',
		8,	'Drop...',
		9,	'Create Index',
		10,	'Drop Index',
		11,	'Alter Index',
		12,	'Drop Table',
		13,	'--',
		14,	'--',
		15,	'Alter Table',
		16,	'--',
		17,	'Grant',
		18,	'Revoke',
		19,	'Create Synonym',
		20,	'Drop Synonym',
		21,	'Create View',
		22,	'Drop View',
		23,	'--',
		24,	'--',
		25,	'--',
		26,	'Lock Table',
		27,	'No Operation',
		28,	'Rename',
		29,	'Comment',
		30,	'Audit',
		31,	'NoAudit',
		32,	'Create Ext DB',
		33,	'Drop Ext. DB',
		34,	'Create Database',
		35,	'Alter Database',
		36,	'Create RBS',
		37,	'Alter RBS',
		38,	'Drop RBS',
		39,	'Create Tablespace',
		40,	'Alter Tablespace',
		41,	'Drop tablespace',
		42,	'Alter Session',
		43,	'Alter User',
		44,	'Commit',
		45,	'Rollback',
		46,	'Savepoint')) job,
		s.program program,
                                    s.logon_time
from	v$process p,
	v$session s
where	p.addr=s.paddr (+)
  and	p.spid is not null
  and   s.username like upper('&usuario%')
  and   s.status like upper('&status%')
  and   p.spid like ('&no_processo%')
  and   upper(s.osuser) like upper('&os_user%')
  and   s.sid like ('&sid%')
order	by s.username,s.osuser,s.sid,p.username,s.logon_time,spid;

