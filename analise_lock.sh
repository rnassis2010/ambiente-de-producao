#!/bin/ksh 

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin

### Verifica request_id no banco
vlock ()
{
sqlplus -s "/as sysdba" <<EOF
set line 250
set echo off
set feedback off
set verify off
@/export/home/oracle/atg/lock.sql
exit
EOF
}

vsessao ()
{
echo "\n \nEntre com o INST_ID: \c"
read INST_ID
echo "\n \nEntre com o SID: \c"
read SID
echo "\n \nEntre com o SERIAL#: \c"
read SERIAL
sqlplus -s "/as sysdba" <<EOF
set line 250
set echo off
set feedback off
set verify off
col SCHEMANAME format a8
col USUARIO format a15
col PROCESS format a6
col MODULE format a35
col ACTION format a33
col INST_ID format 99
col OS_PID format a8
col SID format 999999
col SERIAL# a8
col PROGRAM format a33
col MIN format 99999
SELECT INST_ID,SID,SERIAL#,PROCESS OS_PID,STATUS,SCHEMANAME,CLIENT_IDENTIFIER USUARIO,
MODULE,ACTION,PROGRAM,SQL_ID,round(LAST_CALL_ET/60) MIN
FROM GV$SESSION
WHERE 
SID ='${SID}'
AND SERIAL# = '${SERIAL#}'
AND INST_ID = '${INST_ID}';
exit
EOF
}

vsql ()
{
echo "\n \nEntre com o SQL_ID: \c"
read SQL_ID
echo "\n \nEntre com o INST_ID: \c"
read INST_ID
sqlplus -s "/as sysdba" <<EOF
set line 250
set echo off
set feedback off
set verify off
SET LONG 500
SELECT SQL_FULLTEXT
FROM GV\$SQLAREA
WHERE SQL_ID = '${SQL_ID}'
AND INST_ID = '${INST_ID}';
exit
EOF
}

pending ()
{
sqlplus -s "/as sysdba" <<EOF
set line 250
set echo off
set feedback off
set verify off
COL CONCURRENT_QUEUE_NAME FOR A30
SELECT DISTINCT A.REQUEST_ID, D.INST_ID, D.SID, D.SERIAL#, D.STATUS, D.SQL_ID, D.PREV_SQL_ID, E.CONCURRENT_QUEUE_NAME, ROUND(D.LAST_CALL_ET/60) MINUTOS,
TO_CHAR(A.ACTUAL_START_DATE,'DD-MON-YY HH24:MI:SS') START_DATE,
TO_CHAR(A.ACTUAL_COMPLETION_DATE,'DD-MON-YY HH24:MI:SS') COMPLETION_DATE
FROM APPS.FND_CONC_REQ_SUMMARY_V A,
APPS.FND_CONCURRENT_PROCESSES B,
GV\$PROCESS C,
GV\$SESSION D,
APPS.FND_CONCURRENT_QUEUES_VL E
WHERE REQUEST_ID = '${REQ_ID}'
AND C.PID = B.ORACLE_PROCESS_ID
AND B.SESSION_ID=D.AUDSID
AND A.PHASE_CODE in ('P','I')
AND B.CONCURRENT_QUEUE_ID = E.CONCURRENT_QUEUE_ID
AND B.CONCURRENT_PROCESS_ID = A.CONTROLLING_MANAGER;

COL USER_CONCURRENT_QUEUE_NAME FORMAT A50
SELECT /*+ RULE */
B.USER_CONCURRENT_QUEUE_NAME,B.CONCURRENT_QUEUE_NAME,B.TARGET_PROCESSES TARGET,
SUM (DECODE(PHASE_CODE,'R',1,0)) RUNNING,
SUM (DECODE(PHASE_CODE,'P',1,0)) PENDING
FROM  APPS.FND_CONCURRENT_WORKER_REQUESTS A,
APPS.FND_CONCURRENT_QUEUES_VL B
WHERE A.CONCURRENT_QUEUE_NAME = B.CONCURRENT_QUEUE_NAME
AND A.HOLD_FLAG != 'Y'
AND A.REQUESTED_START_DATE <= SYSDATE
AND B.ENABLED_FLAG = 'Y'
AND B.CONTROL_CODE IS NULL
GROUP BY B.USER_CONCURRENT_QUEUE_NAME,B.CONCURRENT_QUEUE_NAME,B.TARGET_PROCESSES;
exit
EOF

echo "\n \nEntre com a fila (USER_CONCURRENT_QUEUE_NAME) do concurrent: \c"
read CONCURRENT_QUEUE_NAME
sqlplus -s "/as sysdba" <<EOF
set line 250
set echo off
set feedback off
set verify off
col USER_CONCURRENT_PROGRAM_NAME format a60
col ARGUMENT_TEXT format a45
col REQUESTOR format a15
SELECT REQUEST_ID,USER_CONCURRENT_PROGRAM_NAME,
DECODE(PHASE_CODE,
      'R','RUNNING',
      'P','PENDING',
      'I','INACTIVE',
      PHASE_CODE) PHASE_CODE,
DECODE(STATUS_CODE,
      'D','CANCELLED',
      'E','ERROR',
      'G','WARNING',
      'H','ON HOLD',
      'T','TERMINATING',
      'M','NO MANAGER',
      'X','TERMINATED',
      'C','C-NORMAL',
      'B','RESUMING',
      'A','WAITING',
      'I','I-NORMAL',
      'P','SCHEDULED',
      'Q','STANDBY',
      'R','R-NORMAL',
      'S','SUSPENDED',
      STATUS_CODE) STATUS_CODE,
TO_CHAR(ACTUAL_START_DATE,'DD-MON-YY HH24:MI:SS') START_DATE,
TO_CHAR(ACTUAL_COMPLETION_DATE,'DD-MON-YY HH24:MI:SS') COMPLETION_DATE, ARGUMENT_TEXT
FROM APPS.FND_CONCURRENT_WORKER_REQUESTS
WHERE PHASE_CODE IN ('R','P','I')
AND CONCURRENT_QUEUE_NAME = '$CONCURRENT_QUEUE_NAME'
AND ACTUAL_START_DATE IS NOT NULL;
exit
EOF
}

escolha()
{
echo "\n \nQual o PHASE_COD do concurrent ? exs:COMPLETED, RUNNING, PENDING ou INACTIVE. \c"
read PHASE
	case $PHASE in
		"COMPLETED") exit ;;
		"RUNNING") running ;;
               	"PENDING") pending ;;
               	"INACTIVE") pending ;;
               	*) echo "\n \nOpção inválida !!! - Digite COMPLETED, RUNNING, PENDING ou INACTIVE."
               	   escolha ;;
        esac
}

### Principal
{
vlock
escolha
}
