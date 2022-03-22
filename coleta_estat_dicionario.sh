#!/bin/ksh


### Configura as variaveis de ambiente

export ORACLE_SID=PROD113

export ORACLE_HOME=/u02/app/oracle/product/11.2.0/dbhome_1

export PATH=/u02/app/oracle/product/11.2.0/dbhome_1/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/u02/bin

sqlplus -s /nolog <<EOF

conn / as sysdba
spool /u02/atg/logs/coleta_estatisticas_dicionario.log

select * from global_name;

alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';

select sysdate from dual;

exec dbms_stats.GATHER_SYSTEM_STATS('interval',interval=>60); 
exec dbms_stats.gather_dictionary_stats;
exec dbms_stats.GATHER_FIXED_OBJECTS_STATS(null); 
   
select sysdate from dual;

exit 0

EOF
# Manda email para o grupo ATG

LOG_FILE=/u02/atg/logs/coleta_estatisticas_dicionario.log

#mailx -v -s "Coleta de estatisticas dic. de Producao: PROD113" GRUPOATG@hpe.com < $LOG_FILE

## fi

