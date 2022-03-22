#!/bin/ksh -x

### Configura variaveis
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin::/opt/CA/SharedComponents/bin
export ARQ_LOG=/export/home/oracle/atg/alerta_wf_sms.log
export ARQ_LOG2=/export/home/oracle/atg/alerta_wf_sms2.log
export ARQ_MAIL=/export/home/oracle/atg/alerta_wf_sms_mail.log
export ARQ_MAIL2=/export/home/oracle/atg/alerta_wf_sms_mail2.log
export ARQ_SMS=/export/home/oracle/atg/alerta_wf_sms_abril.log

### Funcoes

### Verifica status do WF
vwf ()
{
rm -f $ARQ_LOG
sqlplus -L "/as sysdba" <<EOF
spool /export/home/oracle/atg/alerta_wf_sms.log
@/export/home/oracle/atg/alerta_wf_sms.sql
spool off
exit
EOF
}

###  Gera erro de extent no banco e aciona alarme do OVO
gerro ()
{
sqlplus -L "/as sysdba" <<EOF
spool /export/home/oracle/atg/alerta_wf_sms_gerro.log
@/export/home/oracle/atg/alerta_wf_sms_gerro.sql
spool off
exit
EOF
}

###  Recria a tabela de alarme atg_wf_1
ctable ()
{
sqlplus -L "/as sysdba" <<EOF
@/export/home/oracle/atg/alerta_wf_sms_ctable.sql
exit
EOF
}

vwf2 ()
{
rm -f $ARQ_LOG2
sqlplus -L "/as sysdba" <<EOF
spool /export/home/oracle/atg/alerta_wf_sms2.log
@/export/home/oracle/atg/alerta_wf_sms.sql
spool off
exit
EOF
}

### Envia email
eemail_1 ()
{
mailx -v -s "Alerta do WF - TP215: Forcado o erro no dbmon. Em 1 Hora enviaremos SMS para o Cliente" GRUPOATG@hpe.com < $ARQ_LOG
}

eemail_2 ()
{
mailx -v -s "Alerta do WF - TP215: Alerta enviado via SMS" GRUPOATG@hpe.com,1196079322@mail2sms.com.br < $ARQ_SMS
}

### Principal
{
rm -f $ARQ_LOG
vwf
DATA=`date | awk '{print $3"/"$2"/"$6"-"$4}'`
echo $DATA >> $ARQ_MAIL
grep -i workflow $ARQ_LOG  | awk '{print "Workflow Mailer Service: "$NF}' >> $ARQ_MAIL
if [ `tail -10 $ARQ_MAIL | egrep -c 'STARTING|STOPPED_ERROR|DEACTIVATED_USER|DEACTIVATED_SYSTEM|'` -gt 4 ]; then
gerro
cat /export/home/oracle/atg/alerta_wf_sms_gerro.log >> $ARQ_LOG
eemail_1
rm -f $ARQ_MAIL
sleep 3600
ctable
vwf2
DATA=`date | awk '{print $3"/"$2"/"$6"-"$4}'`
echo $DATA >> $ARQ_MAIL2
grep -i workflow $ARQ_LOG2  | awk '{print "Workflow Mailer Service: "$NF}' >> $ARQ_MAIL2
	if [ `tail -2 $ARQ_MAIL2 | egrep -c 'STARTING|STOPPED_ERROR|DEACTIVATED_USER|DEACTIVATED_SYSTEM|'` -gt 0 ]; then
	eemail_2
	rm -f $ARQ_MAIL2
	fi
fi
}
