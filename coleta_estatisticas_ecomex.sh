#!/bin/ksh

### Configura as variaveis de ambiente
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin

sqlplus -s /nolog <<EOF
connect apps/Z1bOE6ri
spool /export/home/oracle/atg/coleta_estatisticas_ecomex.log
select * from global_name;
alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';
select sysdate from dual;
EXEC FND_STATS.GATHER_SCHEMA_STATISTICS(SCHEMANAME=>'XXECOMEX',ESTIMATE_PERCENT=>0,DEGREE=>12);
--EXEC DBMS_STATS.gather_schema_stats('XXECOMEX', estimate_percent => 50, DEGREE=>12);
select sysdate from dual;
exit 0
EOF
