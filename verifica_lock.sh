#!/bin/ksh -v

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin:$PATH
export ARQ_LOG=/u02/atg/lock_email.log

### Funcoes 

### Verifica o lock no banco
vlock ()
{
rm -f $ARQ_LOG
sqlplus -L "/as sysdba" <<EOF
spool $ARQ_LOG
@/u02/atg/nlock.sql
spool off
exit
EOF
}

### Envia email
eemail ()
{
mailx -v -r GRUPOATG@dxc.com -s "Alerta de LOCK na instancia $ORACLE_SID ha mais de 10 min" GRUPOATG@dxc.com < $ARQ_LOG
}

### Principal
{
vlock
if [ `grep -c 'no rows' $ARQ_LOG` -lt 1 ]; then
eemail
fi
}
