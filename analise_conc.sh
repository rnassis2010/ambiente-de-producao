#!/bin/ksh 

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/orahome/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin

### Verifica request_id no banco
vrequest ()
{
echo -e "\n\nEntre com o RQUEST_ID: \c"
read REQ_ID
sqlplus -s "/as sysdba" <<EOF
set line 250
set echo off
set feedback off
set verify off
col USER_CONCURRENT_PROGRAM_NAME format a60
col ARGUMENT_TEXT format a45
col REQUESTOR format a15
SELECT REQUEST_ID,PROGRAM_SHORT_NAME,USER_CONCURRENT_PROGRAM_NAME,REQUESTOR,
DECODE(PHASE_CODE,
      'C','COMPLETED',
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
FROM APPS.FND_CONC_REQ_SUMMARY_V
WHERE REQUEST_ID = '${REQ_ID}';
exit
EOF
}

running ()
{
sqlplus -s "/as sysdba" <<EOF
set line 250
set echo off
set feedback off
set verify off
COL USER_CONCURRENT_QUEUE_NAME FOR A30
SELECT DISTINCT A.REQUEST_ID, D.INST_ID, D.SID, D.SERIAL#, D.STATUS, D.SQL_ID, D.PREV_SQL_ID, E.USER_CONCURRENT_QUEUE_NAME, ROUND(D.LAST_CALL_ET/60) MINUTOS,
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
AND A.PHASE_CODE = 'R'
AND B.CONCURRENT_QUEUE_ID = E.CONCURRENT_QUEUE_ID
AND B.CONCURRENT_PROCESS_ID = A.CONTROLLING_MANAGER;
exit
EOF

echo -e "\n \nEntre com o SQL_ID: \c"
read SQL_ID
echo -e "\n \nEntre com o INST_ID: \c"
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

echo -e "\n \nEntre com a fila (CONCURRENT_QUEUE_NAME) do concurrent: \c"
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
echo -e "\n \nQual o PHASE_COD do concurrent ? exs:COMPLETED, RUNNING, PENDING ou INACTIVE. \c"
read PHASE
	case $PHASE in
		"COMPLETED") exit ;;
		"RUNNING") running ;;
               	"PENDING") pending ;;
               	"INACTIVE") pending ;;
               	*) echo "\n \nOp��o inv�lida !!! - Digite COMPLETED, RUNNING, PENDING ou INACTIVE."
               	   escolha ;;
        esac
}

### Principal
{
vrequest
escolha
}
