set feedback off
SET VERIFY OFF
set line 200
set pagesize 2000
col ARGUMENT_TEXT format a70
col NUMBER_OF_ARGUMENTS format 999
col CONCURRENT_PROGRAM_NAME format a35
col actual_start_date noprint
prompt "HISTORICO DOS TEMPOS DE EXECUCAO DO CONCURRENT A PARTIR DA DATA DESEJADA..."
accept vconc prompt "concurrent_program_name: "
accept vdate prompt "Entre com a data desejada (ex:30-AUG-16) :" 
SELECT
      to_char(actual_start_date, 'DD/MM/YYYY HH24:Mi:SS') INICIO
     ,actual_start_date
     ,to_char(actual_completion_date, 'DD/MM/YYYY HH24:Mi:SS') FIM
     ,round((actual_completion_date - actual_start_date) * 3600 * 24 / 60) as "T.Minutos"
     ,b.concurrent_program_name
     ,a.NUMBER_OF_ARGUMENTS as "NUM.ARG"
     ,a.ARGUMENT_TEXT
FROM  apps.fnd_user                    fu
     ,apps.fnd_responsibility_vl       fr
     ,apps.FND_CONCURRENT_REQUESTS a
     ,apps.fnd_concurrent_programs_vl  b
WHERE (a.concurrent_program_id = b.concurrent_program_id)
  AND a.requested_by = fu.user_id
  AND a.responsibility_id = fr.responsibility_id
  AND a.phase_code = 'C'
  AND a.actual_start_date BETWEEN '&vdate' AND SYSDATE
  AND b.concurrent_program_name = upper('&vconc')
union all
SELECT
      to_char(actual_start_date, 'DD/MM/YYYY HH24:Mi:SS') INICIO
     ,actual_start_date
     ,to_char(actual_completion_date, 'DD/MM/YYYY HH24:Mi:SS') FIM
     ,round((actual_completion_date - actual_start_date) * 3600 * 24 / 60) as "T.Minutos"
     ,b.concurrent_program_name
     ,a.NUMBER_OF_ARGUMENTS as "NUM.ARG"
     ,a.ARGUMENT_TEXT
FROM  apps.fnd_user                    fu
     ,apps.fnd_responsibility_vl       fr
     ,DTO.XXFND_HIST_CONCURRENT_REQUESTS a
     ,apps.fnd_concurrent_programs_vl  b
WHERE (a.concurrent_program_id = b.concurrent_program_id)
  AND a.requested_by = fu.user_id
  AND a.responsibility_id = fr.responsibility_id
  AND a.phase_code = 'C'
  AND a.actual_start_date BETWEEN '&vdate' AND SYSDATE
  AND b.concurrent_program_name = upper('&vconc')
ORDER BY actual_start_date desc;
