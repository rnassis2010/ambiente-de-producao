#!/bin/ksh -x

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin
export ARQ_LOG=/export/home/oracle/atg/verifica_conc24hs.html

### Funcoes

### Verifica os concurrents rodando a mais de 24hs
vconc24h ()
{
rm -f $ARQ_LOG
sqlplus -L "/as sysdba" <<EOF
@/export/home/oracle/atg/conc24hs.sql
exit
EOF
}

### Envia email
eemail ()
{
###mailx -v -s "Alerta: Concurrent rodando a mais de 24hs em TP215." GRUPOATG@hpe.com < $ARQ_LOG
(
echo "To: ti-erp@abril.com.br"
echo "Cc: GRUPOATG@hpe.com"
echo "Subject: BANCO DE DADOS DE PRODUCAO DO ERP - Alerta: Concurrent rodando a mais de 24hs."
echo "MIME-Version: 1.0"
echo "Content-Type: text/html"
echo "Content-Disposition: inline"
cat $ARQ_LOG
) | /usr/sbin/sendmail -t
}

### Principal
{
vconc24h
if [ `grep -c "no rows" $ARQ_LOG` -lt 1 ]; then
eemail
fi
}
