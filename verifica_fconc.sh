#!/bin/ksh

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin
export ARQ_LOG=/export/home/oracle/atg/verifica_fconc.log

### Funcoes

### Verifica fila de concurrents no banco
vfconc ()
{
rm -f $ARQ_LOG
sqlplus -L "/as sysdba" <<EOF
spool /export/home/oracle/atg/verifica_fconc.log
@/export/home/oracle/atg/filaconc.sql
spool off
exit
EOF
}

### Envia email
eemail ()
{
mailx -v -s "Alerta da fila de concurrents no ambiente TP215." GRUPOATG@hpe.com < $ARQ_LOG
}

### Principal
{
vfconc
if [ `grep sum $ARQ_LOG | awk '{print $NF}'` -gt `grep sum $ARQ_LOG | awk '{print $2*2}'` ]; then
eemail
fi
}
