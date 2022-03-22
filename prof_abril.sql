set pagesize 1000
set linesize 400
set verify off

COLUMN user_profile_option_name FORMAT a40
COLUMN created_by               FORMAT a20
COLUMN last_updated_by          FORMAT a20
COLUMN context                  FORMAT a30
COLUMN value                    FORMAT a05

break on level on context skip 1

select decode(to_char(fpov.level_id),'10001', 'SITE',
                                     '10002', 'APP',
                                     '10003', 'RESP',
                                     '10005', 'SERVER',
                                     '10006', 'ORG',
                                     '10004', 'USER', '???') "LEVEL"
,      decode(to_char(fpov.level_id),'10001', '',
                                     '10002', fa.application_short_name,
                                     '10003', fr.responsibility_name,
                                     '10005', fn.node_name,
                                     '10006', hou.name,
                                     '10004', fu3.user_name || decode(nvl(to_char(fu3.end_date),'X'),'X',null,' (INATIVO)'),
                                     '???') "CONTEXT"
,      fpot.user_profile_option_name
,      fpov.profile_option_value            "VALUE"
,      fu.user_name  created_by
,      fu2.user_name last_updated_by
,      fpov.creation_date
,      fpov.last_update_date
from   apps.fnd_profile_options       fpo
,      apps.fnd_profile_options_tl    fpot
,      apps.fnd_profile_option_values fpov
,      apps.fnd_user                  fu
,      apps.fnd_user                  fu2
,      apps.fnd_user                  fu3
,      apps.fnd_application           fa
,      apps.fnd_responsibility_tl     fr
,      apps.fnd_nodes                 fn
,      apps.hr_operating_units        hou
where  fpo.profile_option_name in ( 'FND_DIAGNOSTICS','FND_HIDE_DIAGNOSTICS','DIAGNOSTICS' )
and    fpo.profile_option_name  = fpot.profile_option_name
and    fpot.language            = 'US'
and    fpo.application_id       = fpov.application_id
and    fpo.profile_option_id    = fpov.profile_option_id
and    fu.user_id               = fpov.created_by
and    fu2.user_id              = fpov.last_updated_by
and    fu3.user_id          (+) = fpov.level_value
and    fa.application_id    (+) = fpov.level_value_application_id
and    fr.responsibility_id (+) = fpov.level_value
and    fr.language          (+) = 'US'
and    fa.application_id    (+) = fpov.level_value
and    fn.node_id           (+) = fpov.level_value
and    hou.organization_id  (+) = fpov.level_value
--and    fpov.level_id           != 10001   -- SITE
--and    (
--         ( fpov.level_id            = 10004 and -- USER
--           fu3.user_name       not in ( 'SYSADMIN','ATG','CRSILVA','ECLARO_EDS','DPAULI_EDS','LCARVALHO_EDS','HSANTOS_EDS' )
--         ) or
--         (
--           fpov.level_id           != 10004     -- USER
--         )
--       )
order  by 1,2,3
/

