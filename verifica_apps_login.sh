#!/bin/ksh

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin
export ARQ_EMAIL=/export/home/oracle/atg/apps_login_email.log
export ARQ_KILL=/export/home/oracle/atg/kill_apps.sql

### Funcoes

### Verifica as sessoes indevidas do APPS no banco
vapps ()
{
##rm -f $ARQ_EMAIL
##rm -f $ARQ_KILL
sqlplus -L "/as sysdba" <<EOF
@/export/home/oracle/atg/vapps_login.sql
@/export/home/oracle/atg/gera_kill_apps.sql
EOF
}

### Mata as sessoes
kapps ()
{
sqlplus -L "/as sysdba" <<EOF
@/export/home/oracle/atg/kill_apps.sql
EOF
}

### Envia email
eemail ()
{
mailx -v -s "Sessoes do APPS que foram eliminadas na base TP215 - OEBS PROD."  TI-InfraestruturaR12@abril.com.br,Cristiane.Jyo@abril.com.br < $ARQ_EMAIL
}

### Principal
{
vapps
if [ `tail -30 $ARQ_KILL | grep -ci KILL` -gt 0 ]; then
	kapps
        eemail
fi
}
