set line 250
set pagesize 20
SET VERIFY OFF
col USER_CONCURRENT_PROGRAM_NAME format a80
accept vdatai prompt "Inicio do intervalo (ex:01/10/2015): "
accept vdataf prompt "Fim do intervalo (ex:30/10/2015): "
prompt "TOP 10: MAIOR QUANTIDADE DE EXECUCOES"
Select * from (
SELECT to_char(a.actual_start_date, 'MM') mes
       ,b.concurrent_program_name
       ,b.user_concurrent_program_name
       ,count(*) qtd_exec
       ,round(AVG(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) media_min
       ,round(MAX(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) maxima_min
       ,round(SUM(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) total_min
   FROM apps.fnd_user fu
      ,apps.fnd_responsibility_vl fr
      ,BOLINF.XXFND_HIST_CONCURRENT_REQUESTS a
      ,apps.fnd_concurrent_programs_vl  b
WHERE (a.concurrent_program_id = b.concurrent_program_id)
   AND a.requested_by = fu.user_id
   AND a.responsibility_id = fr.responsibility_id
   AND a.actual_start_date BETWEEN trunc(to_date('&vdatai', 'DD/MM/YYYY')) + .0 AND trunc(to_date('&vdataf', 'DD/MM/YYYY')) + .99999
   AND a.phase_code = 'C'
GROUP BY to_char(a.actual_start_date, 'MM')
         ,b.concurrent_program_name
         ,b.user_concurrent_program_name
ORDER BY qtd_exec desc )
WHERE ROWNUM <= 10;
prompt "TOP 10: MAIOR TEMPO MEDIO"
Select * from (
SELECT to_char(a.actual_start_date, 'MM') mes
       ,b.concurrent_program_name
       ,b.user_concurrent_program_name
       ,count(*) qtd_exec
       ,round(AVG(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) media_min
       ,round(MAX(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) maxima_min
       ,round(SUM(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) total_min
   FROM apps.fnd_user fu
      ,apps.fnd_responsibility_vl fr
      ,BOLINF.XXFND_HIST_CONCURRENT_REQUESTS a
      ,apps.fnd_concurrent_programs_vl  b
WHERE (a.concurrent_program_id = b.concurrent_program_id)
   AND a.requested_by = fu.user_id
   AND a.responsibility_id = fr.responsibility_id
   AND a.actual_start_date BETWEEN trunc(to_date('&vdatai', 'DD/MM/YYYY')) + .0 AND trunc(to_date('&vdataf', 'DD/MM/YYYY')) + .99999
   AND a.phase_code = 'C'
GROUP BY to_char(a.actual_start_date, 'MM')
         ,b.concurrent_program_name
         ,b.user_concurrent_program_name
ORDER BY media_min desc )
WHERE ROWNUM <= 10;
prompt "TOP 10: MAIOR TEMPO TOTAL"
Select * from (
SELECT to_char(a.actual_start_date, 'MM') mes
       ,b.concurrent_program_name
       ,b.user_concurrent_program_name
       ,count(*) qtd_exec
       ,round(AVG(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) media_min
       ,round(MAX(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) maxima_min
       ,round(SUM(round((actual_completion_date - actual_start_date) * 3600 * 24))/60) total_min
   FROM apps.fnd_user fu
      ,apps.fnd_responsibility_vl fr
      ,BOLINF.XXFND_HIST_CONCURRENT_REQUESTS a
      ,apps.fnd_concurrent_programs_vl  b
WHERE (a.concurrent_program_id = b.concurrent_program_id)
   AND a.requested_by = fu.user_id
   AND a.responsibility_id = fr.responsibility_id
   AND a.actual_start_date BETWEEN trunc(to_date('&vdatai', 'DD/MM/YYYY')) + .0 AND trunc(to_date('&vdataf', 'DD/MM/YYYY')) + .99999
   AND a.phase_code = 'C'
GROUP BY to_char(a.actual_start_date, 'MM')
         ,b.concurrent_program_name
         ,b.user_concurrent_program_name
ORDER BY total_min desc )
WHERE ROWNUM <= 10;
