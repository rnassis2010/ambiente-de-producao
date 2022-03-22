#!/bin/ksh -x

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin:$PATH
export ARQ_LOG=/u02/atg/verifica_sessao_1h.log

### Funcoes

### Verifica as sessoes rodando a mais de 1 hora
vsess ()
{
rm -f $ARQ_LOG
sqlplus -L "/as sysdba" <<EOF
spool /u02/atg/verifica_sessao_1h.log
@/u02/atg/verifica_sessao_1h.sql
spool off
exit
EOF
}

### Gera os comandos do SQLTUNE
gsqlt ()
{
sqlplus -L "/as sysdba" <<EOF
@gera_sqltune_sessao_1h.sql
exit
EOF
}

### Executa os comandos do SQLTUNE - PROD113
esqlt1 ()
{
sqlplus -L "/as sysdba" <<EOF
variable stmt_task VARCHAR2(64);
@exec_sqltune_sessao_1h_1.sql
exit
EOF
}

### Gera o report do SQLTUNE - PROD113
rsqlt1 ()
{
sqlplus -L "/as sysdba" <<EOF
SET linesize 200
SET LONG 999999999
SET pages 1000
SET longchunksize 20000
spool /u02/atg/sqltune_report_sessao_1h_1.log
@exec_sqltune_report_sessao_1h_1.sql
spool off
exit
EOF
}

### Executa os comandos do SQLTUNE - PROD113
esqlt2 ()
{
sqlplus -L "/as sysdba" <<EOF
variable stmt_task VARCHAR2(64);
@exec_sqltune_sessao_1h_2.sql
exit
EOF
}

### Gera o report do SQLTUNE - PROD113
rsqlt2 ()
{
sqlplus -L "/as sysdba" <<EOF
SET linesize 200
SET LONG 999999999
SET pages 1000
SET longchunksize 20000
spool /u02/atg/sqltune_report_sessao_1h_2.log
@exec_sqltune_report_sessao_1h_2.sql
spool off
exit
EOF
}

### Envia email
eemail ()
{
mailx -v -r GRUPOATG@dxc.com -s "Alerta: Sessao rodando a mais de 1hr no ambiente PROD113" GRUPOATG@dxc.com < $ARQ_LOG
}

### Principal
{
rm -f $ARQ_LOG
cd /u02/atg/
vsess
if [ `grep -c 'no rows' $ARQ_LOG` -lt 1 ]; then
gsqlt
	if [ `grep -c 'sqltune' /u02/atg/exec_sqltune_report_sessao_1h_1.sql` -gt 0 ]; then
	esqlt1
	rsqlt1
	cat /u02/atg/sqltune_report_sessao_1h_1.log >> /u02/atg/verifica_sessao_1h.log
        fi
        if [ `grep -c 'sqltune' /u02/atg/exec_sqltune_report_sessao_1h_2.sql` -gt 0 ]; then
        esqlt2
        rsqlt2
	cat /u02/atg/sqltune_report_sessao_1h_2.log >> /u02/atg/verifica_sessao_1h.log
        fi
eemail
fi
}
