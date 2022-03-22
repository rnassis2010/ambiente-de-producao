set echo off ver off pagesize 50000 linesize 1000 trimspool on

prompt
prompt - Para pesquisas com LIKE, colocar o '%'
prompt - No Campo Tipo, colocar qualquer combinação das letras:
prompt ---- S(System), R(Roles), T(Table), Q(Quota)
prompt
accept usu  prompt 'Grantee...........: '
accept tipo prompt 'Tipo (S/R/T/Q)....: '
accept own  prompt 'Owner do objeto...: '
accept obj  prompt 'Objeto............: '
accept rol  prompt 'Role..............: '
accept priv prompt 'Privilégio........: '
accept tbsp prompt 'Tablespace........: '

col "OBJETO" for a40
col "PRIVILEGIO" for a30
col "DEF" for a3
col grantee for a30
col "GRT/ADM" for a7
col "TIPO" for a5
col dummy noprint

rem break on grantee skip 1

select
        1 dummy, grantee, 'ROLE' "TIPO", granted_role "OBJETO", null "PRIVILEGIO",
        default_role "DEF", admin_option "GRT/ADM"
from
        dba_role_privs
where
        grantee like nvl(upper('&usu'),'%') and granted_role like nvl(upper('&rol'),'%')
        and (upper('&tipo') like '%R%' OR upper('&tipo') is null)
UNION ALL
select
        2, username, 'QUOTA', tablespace_name,
        decode(max_bytes,-1,'UNLIMITED',to_char(max_bytes/1024/1024)||'M'), null, null
from
        dba_ts_quotas
where
        username like nvl(upper('&usu'),'%') and tablespace_name like nvl(upper('&tbsp'),'%')
        and (upper('&tipo') like '%Q%' OR upper('&tipo') is null)
UNION ALL
select
        3, grantee, 'SYS', null, privilege, null, admin_option "GRT/ADM"
from
        dba_sys_privs
where
        grantee like nvl(upper('&usu'),'%') and privilege like nvl(upper('&priv'),'%')
        and (upper('&tipo') like '%S%' OR upper('&tipo') is null)
UNION ALL
select
        4, grantee, 'TAB' , owner||'.'||table_name, privilege, null, grantable
from
        dba_tab_privs
where
        grantee like nvl(upper('&usu'),'%') and owner like nvl(upper('&own'),'%')
        and table_name like nvl(upper('&obj'),'%') and privilege like nvl(upper('&priv'),'%')
        and (upper('&tipo') like '%T%' OR upper('&tipo') is null)
ORDER BY 2,1,3,4
;

