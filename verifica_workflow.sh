#!/bin/ksh -x

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin
export ARQ_LOG=/export/home/oracle/atg/workflow_email.log

### Funcoes

### Verifica filas do workflow
vwfq ()
{
rm -f $ARQ_LOG
sqlplus -L "/as sysdba" <<EOF
spool /export/home/oracle/atg/workflow_email.log
@/export/home/oracle/atg/vworkflow.sql
spool off
exit
EOF
}

startwf ()
{
sqlplus apps/Z1bOE6ri <<EOF
@/export/home/oracle/atg/start_workflow.sql
exit
EOF
}

vwfq2 ()
{
sqlplus -L "/as sysdba" <<EOF
spool /export/home/oracle/atg/start_workflow_email.log
@/export/home/oracle/atg/vworkflow.sql
spool off
exit
EOF
}

### Envia email
eemail ()
{
cat /export/home/oracle/atg/start_workflow_email.log >> /export/home/oracle/atg/workflow_email.log
mailx -v -s "Alerta do workflow no ambiente TP215" GRUPOATG@hpe.com < $ARQ_LOG
}

### Principal
{
rm -f $ARQ_LOG
vwfq
if [ `egrep -c 'STOPPED_ERROR|DEACTIVATED_USER|DEACTIVATED_SYSTEM|' $ARQ_LOG` -gt 0 ]; then
startwf
sleep 60
vwfq2
eemail
fi
}
