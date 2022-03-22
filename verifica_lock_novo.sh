#!/bin/bash

set -x

### Funcao para verificar lock no banco

function verifica_lock
{
$ORACLE_HOME/bin/sqlplus -s -L "/as sysdba" <<EOF
spool ${ARQ_LOG}
@/u01/home/atg/nlock.sql
spool off
exit
EOF
}

### Funcao para enviar email

function envia_email
{
#mailx -v -r grupoatg@dxc.com -s "Alerta de LOCK na instancia $ORACLE_SID ha mais de 10 min" grupoatg@dxc.com < ${ARQ_LOG}
mailx -v -r carlosroberto.silva@dxc.com -s "Alerta de LOCK na instancia $ORACLE_SID ha mais de 10 min" carlosroberto.silva@dxc.com < ${ARQ_LOG}
}

########################
### INICIO DO SCRIPT ###
########################

DB_NAME=${1}

[ -z ${DB_NAME} ] && echo "Informe o nome do banco!" && exit 1

### Configura variaveis

if [ -f /etc/oratab ]
   then
   export ORACLE_SID=$(grep ^$DB_NAME /etc/oratab | cut -d: -f1)
   export ORACLE_HOME=$(grep ^$DB_NAME /etc/oratab | cut -d: -f2)
   export ORACLE_BASE=$(echo $ORACLE_HOME | sed -e 's:/product/.*::g')
   #
   if [ -z ${ORACLE_SID} ]
      then
      echo "Instancia ${DB_NAME} nao encontrada em /etc/oratab."
      exit 1
   fi
   #
else
   echo "Arquivo /etc/oratab nao encontrato."
   exit 1
fi

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:/usr/bin:/usr/sbin:/sbin:/bin:.
export ARQ_LOG=/tmp/verifica_lock.log

### Verifica se o banco esta no ar

$ORACLE_HOME/bin/sqlplus -s /nolog <<EOF 1>/dev/null 2>/dev/null
whenever sqlerror exit 1
connect / as sysdba
select name from v\$database;
exit
EOF
if [ $? = 1 ]
   then
   echo "Instancia ${DB_NAME} nao esta no ar ou nao existe!"
   exit 1
fi

### Apaga arquivo de log

rm -rf ${ARQ_LOG}

### Executa funcao para verificar lock

verifica_lock

### Se log do lock possuir linhas, envia um email informando

[ -z "$(grep "no rows" ${ARQ_LOG})" ] && envia_email

