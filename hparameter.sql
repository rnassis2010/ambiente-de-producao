set lines 600
set pages 5000
set trimspool on

clear breaks

accept par prompt 'Parametro: '

col description for a80 wrap
col name for a42
col session_value for a40 wrap
col system_value for a40 wrap

with h$parameter as
(
        select a.ksppinm NAME,
        a.ksppdesc DESCRIPTION,
        c.ksppstvl SYSTEM_VALUE,
        b.ksppstvl SESSION_VALUE
        from x$ksppi a, x$ksppcv b, x$ksppsv c
        where a.indx = b.indx and a.indx = c.indx
)
select name, system_value, session_value, description from h$parameter
where name like replace( lower('%&par%') , '_' , '\_' ) escape '\'
order by 1
/

