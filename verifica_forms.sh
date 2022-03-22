#!/bin/ksh -x

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin
export ARQ_KILL=/export/home/oracle/atg/kill_forms.sql

### Funcoes

### Verifica o forms no banco com mais de 3 hs
vforms ()
{
sqlplus -L "/as sysdba" <<EOF
@/export/home/oracle/atg/gera_kill_forms.sql
EOF
}

### Mata as sessoes
kforms ()
{
sqlplus -L "/as sysdba" <<EOF
@/export/home/oracle/atg/kill_forms.sql
EOF
}

### Principal
{
vforms
if [ `tail -30 $ARQ_KILL | grep -ci KILL` -gt 0 ]; then
	kforms
fi
}
