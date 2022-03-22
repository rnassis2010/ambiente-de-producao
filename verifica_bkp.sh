#!/bin/ksh -x
### Definicao das variaveis

export BKP_LOG_DIR=/export/home/oracle/scripts/logs
export TIME_STAMP=`date +%Y%m%d`
export TIME_STAMP2=`date +%d%m%Y`
###export TIME_STAMP=20160915
###export TIME_STAMP2=15092016
export BKP_DB_LOG=`ls -rt $BKP_LOG_DIR/bkp_hot_full*$TIME_STAMP*| tail -1`
export BKP_ARCH_LOG=`ls -rt $BKP_LOG_DIR/bkp_arc*$TIME_STAMP*| tail -1`
export MOVE_ARCH_LOG=`ls -rt $BKP_LOG_DIR/move_bkp_archive*$TIME_STAMP2*| tail -1`
export MOVE_DB_LOG=`ls -rt $BKP_LOG_DIR/move_bkp_database*$TIME_STAMP2*| tail -1`
export HOST=`hostname`
export CHECKLIST=/export/home/oracle/atg/checklist.log
export CHECKLIST2=/export/home/oracle/atg/checklist_n2.log
export ORACLE_SID=PROD113
export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u02/app/oracle/product/11.2.0.4/dbhome_1/bin:/u02/app/oracle/product/11.2.0.4/dbhome_1/OPatch:/u02/app/11.2.0.4/grid/bin:/usr/bin:/opt/CA/SharedComponents/bin:/usr/sbin

### Verifica o BKP de banco
V_BKP_DB ()
{
file $BKP_DB_LOG
if [ $? -eq 0 ] ; then
	echo "##########  BKP DE BANCO PARA DISCO  ##########\n" >> $CHECKLIST
	echo "Este e o ultimo log de bkp do banco: $BKP_DB_LOG." >> $CHECKLIST
	grep -i "finished running" $BKP_DB_LOG >> $CHECKLIST
else
	echo "##########  BKP DE BANCO PARA DISCO  ##########\n" >> $CHECKLIST
	echo "Arquivo de log do bkp de banco de hoje nao encontrado no $HOST." >> $CHECKLIST
	BKP_DB_LOG=`ls -rt $BKP_LOG_DIR/bkp_hot_full*| tail -1`
	echo "Este e o ultimo log de bkp do banco encontrado no $HOST: $BKP_DB_LOG." >> $CHECKLIST
        echo "Procurando o log no servidor brbaplx0100..." >> $CHECKLIST
        ssh oracle@brbaplx0100 /export/home/oracle/atg/verifica_log_bkp_db.sh 
	cat $CHECKLIST2 >> $CHECKLIST
fi
}

### Verifica o BKP de archives 
V_BKP_ARCH ()
{
file $BKP_ARCH_LOG
if [ $? -eq 0 ] ; then
        echo "\n##########  BKP DE ARCHIVES PARA DISCO  ##########\n" >> $CHECKLIST
        echo "Este e o ultimo log de bkp de archives: $BKP_ARCH_LOG." >> $CHECKLIST
        grep -i "finished running" $BKP_ARCH_LOG >> $CHECKLIST
else
        echo "\n##########  BKP DE ARCHIVES PARA DISCO  ##########\n" >> $CHECKLIST
        echo "Arquivo de log do bkp de archives de hoje nao encontrado no $HOST." >> $CHECKLIST
        BKP_ARCH_LOG=`ls -rt $BKP_LOG_DIR/bkp_arc*| tail -1`
        echo "Este e o ultimo log de bkp de archives encontrado no $HOST: $BKP_ARCH_LOG." >> $CHECKLIST
        echo "Procurando o log no servidor brbaplx0100..." >> $CHECKLIST
        ssh oracle@brbaplx0100 /export/home/oracle/atg/verifica_log_bkp_arch.sh
        cat $CHECKLIST2 >> $CHECKLIST
fi
}

### Verifica o BKP de arch para fita
V_BKP_ARCH_FITA ()
{
file $MOVE_ARCH_LOG
if [ $? -eq 0 ] ; then
        echo "\n##########  BKP DE ARCHIVES PARA FITA  ##########\n" >> $CHECKLIST
        echo "Este e o ultimo log de movimentacao de archives: $MOVE_ARCH_LOG." >> $CHECKLIST
        grep -i "fim" $MOVE_ARCH_LOG >> $CHECKLIST
else
        echo "\n##########  BKP DE ARCHIVES PARA FITA  ##########\n" >> $CHECKLIST
        echo "Arquivo de log da movimentacao de archives de hoje nao encontrado no $HOST." >> $CHECKLIST
        MOVE_ARCH_LOG=`ls -rt $BKP_LOG_DIR/move_bkp_archive*| tail -1`
        echo "Este e o ultimo log de movimentacao de archives encontrado no $HOST: $MOVE_ARCH_LOG." >> $CHECKLIST
        echo "Procurando o log no servidor brbaplx0100..." >> $CHECKLIST
        ssh oracle@brbaplx0100 /export/home/oracle/atg/verifica_log_move_arch.sh
        cat $CHECKLIST2 >> $CHECKLIST
fi
}

### Verifica o BKP de banco para fita
V_BKP_DB_FITA ()
{
file $MOVE_DB_LOG
if [ $? -eq 0 ] ; then
        echo "\n##########  BKP DE BANCO PARA FITA  ##########\n" >> $CHECKLIST
        echo "Este e o ultimo log de movimentacao de banco: $MOVE_DB_LOG." >> $CHECKLIST
        grep -i "fim" $MOVE_DB_LOG >> $CHECKLIST
else
        echo "\n##########  BKP DE BANCO PARA FITA  ##########\n" >> $CHECKLIST
        echo "Arquivo de log da movimentacao de banco de hoje nao encontrado no $HOST." >> $CHECKLIST
        MOVE_DB_LOG=`ls -rt $BKP_LOG_DIR/move_bkp_database*| tail -1`
        echo "Este e o ultimo log de movimentacao de banco encontrado no $HOST: $MOVE_DB_LOG." >> $CHECKLIST
        echo "Procurando o log no servidor brbaplx0100..." >> $CHECKLIST
        ssh oracle@brbaplx0100 /export/home/oracle/atg/verifica_log_move_db.sh
        cat $CHECKLIST2 >> $CHECKLIST
fi
}

### Envia email 
E_EMAIL ()
{
mailx -v -s "Resumo diario dos BKPS" GRUPOATG@hpe.com < $CHECKLIST
}

### Principal
{
cd /export/home/oracle/atg/
rm -f $CHECKLIST
V_BKP_DB
V_BKP_ARCH
V_BKP_DB_FITA
V_BKP_ARCH_FITA
##E_EMAIL
}
