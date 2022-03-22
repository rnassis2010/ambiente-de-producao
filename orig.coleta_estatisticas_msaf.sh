#!/bin/ksh

### Configura as variaveis de ambiente
export ORACLE_SID=PRODMSAF
export ORACLE_HOME=/u02/app/oracle/product/12.1.0.2/dbhome_1
export PATH=.:/u02/app/oracle/product/12.1.0.2/dbhome_1/bin:/u02/app/oracle/product/12.1.0.2/dbhome_1/OPatch:/usr/bin:/bin:/etc:/usr/sbin:/usr/ucb:/u02/bin:/usr/bin/X11:/sbin:.:/usr/local/bin:/usr/java/bin/

### Testa o dia, pois na queremos rodar as estatisticas entre os dias 1 e 9
#if [ $(date '+%d') -gt 9 ];then
sqlplus -s /nolog <<EOF

connect mastersaf/P4yGSSYbf0VjTXh
col data format a25
col descricao format a50


spool /u02/atg/coleta_estatisticas_msaf.log

select * from global_name;

alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';

select sysdate as data, 'Coletando Estatistica do Owner: MASTERSAF' as descricao from dual;

exec DBMS_STATS.GATHER_SCHEMA_STATS(OWNNAME => 'MASTERSAF' ,ESTIMATE_PERCENT => 30 ,METHOD_OPT => 'FOR ALL INDEXED COLUMNS SIZE SKEWONLY',DEGREE => 6,GRANULARITY => 'ALL',CASCADE => TRUE);

select sysdate as data, 'Final da Coleta de Estatistica do Owner MASTERSAF' as descricao from dual;

connect msafi/GDXdAmECHwKNg2C
col data format a25
col descricao format a50

alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';

select sysdate as data, 'Coletando Estatistica do Owner: MSAFI' as descricao from dual;

exec DBMS_STATS.GATHER_SCHEMA_STATS(OWNNAME => 'MSAFI' ,ESTIMATE_PERCENT => 30 ,METHOD_OPT => 'FOR ALL INDEXED COLUMNS SIZE SKEWONLY',DEGREE => 6,GRANULARITY => 'ALL',CASCADE => TRUE);

select sysdate as data, 'Final da Coleta de Estatistica do Owner MSAFI' as descricao from dual;

exit 0

EOF

# Manda email para o grupo ATG
LOG_FILE=/u02/atg/coleta_estatisticas_msaf.log
mailx -v -s "Coleta de estatisticas de Producao: PRODMSAF [MASTERSAF e MSAFI]" GRUPOATG@dxc.com < $LOG_FILE
#fi
